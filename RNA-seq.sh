#!/bin/env zsh -e


echo 'リファレンスゲノムを入力して下さい[mm9,mm10]'
read ref
echo 'single or pair ?'
read ends

echo '@edu.k.u-tokyo.ac.jpのアドレスを設定すると、プログラム終了時にメールが届きます。メールを設定しますか？[y/n]'
read mail
if [ $mail = 'y' ]; then
  echo '@edu.k.u-tokyo.ac.jpの前を入力してください'
  read address
else
  echo 'メールを設定しません'
fi

for accession in '210426_NovaSeq_SP_TruseqUD_l2_0028_D04_Dr_Funaya_1_BDF1_MII_S28_L002' '210426_NovaSeq_SP_TruseqUD_l2_0029_E04_Dr_Funaya_1_ICR_MII_S29_L002' '210426_NovaSeq_SP_TruseqUD_l2_0030_F04_Dr_Funaya_1_ddY_MII_S30_L002' '210426_NovaSeq_SP_TruseqUD_l2_0031_G04_Dr_Funaya_2_BDF1_MII_S31_L002' '210426_NovaSeq_SP_TruseqUD_l2_0032_H04_Dr_Funaya_2_ICR_MII_S32_L002' '210426_NovaSeq_SP_TruseqUD_l2_0033_A05_Dr_Funaya_2_ddY_MII_S33_L002'
do
 

 dir=(`pwd`)


 mkdir ${dir}/${accession}
 mkdir ${dir}/${accession}/${ref}
 cd ${dir}/${accession}/${ref}

 touch ${accession}_analysis.detail
 echo '<<sample detail>>' | tee -a ${accession}_analysis.detail
 echo 'SAMPLENAME:'${accession} | tee -a ${accession}_analysis.detail
 echo 'READ:'${ends} | tee -a ${accession}_analysis.detail
 echo 'REFERENCE:'${ref} | tee -a ${accession}_analysis.detail
 echo '\n' | tee -a ${accession}_analysis.detail
 fastp -v | tee -a ${accession}_analysis.detail
 star --version | tee -a ${accession}_analysis.detail
 rsem-calculate-expression -version | tee -a ${accession}_analysis.detail

 #fastpによるQuality Check(20bp>,q>20)
 mkdir fastp_reports
 if [ $ends = 'single' ]; then
   fastp -i ../../Dr_Funaya_210426_Fastq/${accession}.fastq.gz -o ./fastp_reports/fastp_${accession}.fastq -h ./fastp_reports/report_fastp.html -j ./fastp_reports/report_fastp.json -q 20 --length_required 20
 else
   fastp -i ../../Dr_Funaya_210426_Fastq/${accession}_R1_001.fastq.gz -I ../../Dr_Funaya_210426_Fastq/${accession}_R2_001.fastq.gz -o ./fastp_reports/fastp_${accession}_R1_001.fastq -O ./fastp_reports/fastp_${accession}_R2_001.fastq -h ./fastp_reports/report_fastp.html -j ./fastp_reports/report_fastp.json -q 20 --length_required 20
 fi

 #STARによるマッピング
 mkdir star
 if [ $ends = 'single' ]; then
    STAR --runThreadN 8 \
     --runMode alignReads \
     --genomeDir /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/${ref}/Sequence/StarIndex \
     --quantMode TranscriptomeSAM GeneCounts \
     --outSAMtype BAM SortedByCoordinate \
     --readFilesIn ./fastp_reports/fastp_${accession}.fastq \
     --outFileNamePrefix ./star/star_${accession}

    rm ./fastp_reports/fastp_${accession}.fastq
 else
    STAR --runThreadN 8 \
     --runMode alignReads \
     --genomeDir /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/${ref}/Sequence/StarIndex \
     --quantMode TranscriptomeSAM GeneCounts \
     --outSAMtype BAM SortedByCoordinate \
     --readFilesIn ./fastp_reports/fastp_${accession}_R1_001.fastq ./fastp_reports/fastp_${accession}_R2_001.fastq \
     --outFileNamePrefix ./star/star_${accession}

    rm ./fastp_reports/fastp_${accession}_R1_001.fastq ./fastp_reports/fastp_${accession}_R2_001.fastq
 fi

 #RSEMによる遺伝子発現定量
 mkdir rsem
 cd rsem
 if [ $ends = 'single' ]; then
    rsem-calculate-expression \
    --alignments \
    -p 8 \
    ../star/star_${accession}Aligned.toTranscriptome.out.bam \
    /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/${ref}/Sequence/RsemReference/RsemReference \
    ${accession}
 else
    rsem-calculate-expression \
    --alignments --paired-end \
    -p 8 \
    ../star/star_${accession}Aligned.toTranscriptome.out.bam \
    /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/${ref}/Sequence/RsemReference/RsemReference \
    ${accession}
 fi

 cd ${dir}
done

#終了時メールで送信
if [ $mail = 'y' ]; then
  echo "Process done　メールを送信しました。" | mail -s "Process done" ${address}@edu.k.u-tokyo.ac.jp
else
  echo "Process done"
fi
