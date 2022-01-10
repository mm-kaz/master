# master
修士論文で使用したコード<br>

<u>**RNA-seq解析(RNA-seq.sh)**</u><br>
fastp version0.20.1(Shifu Chen et al., 2018)を用い、パラメーターを -q 20 -length_requierd 20 に設定し、RNA-seqリードのトリミングを行った。トリミングされたリードはSTAR version2.7.8a(https://github.com/alexdobin/STAR) を用いてリファレンスゲノム(mm10)へのマッピングを行った。STARのパラメーターは –runMode alignReads –quantMode TranscriptomeSAM GeneCounts を指定して実行した。その後、マッピングにより得られたデータを用いてRSEM(Li, B., Dewey, C.N., 2011)による転写産物の発現量の推定を行った。RSEMで得られたFragments Per Kilobase of exon per Million mapped reads(FPKM)値をもとに、R version4.0.2を用いて複製実験間の相関解析(R/correlation/210610_m2/1_REPcorrelation.R)および階層的クラスタリング(R/FPKMheatmap/heatmap.R)を行った。また、FPKM値をもとにRパッケージのDEseq2 version1.30.1(Love MI et al., 2014)を用いて、差次的遺伝子発現を検出した(R/DESeq2/DESeq2.R)。なお、マッピング後のデータはIntegrative Genomics Viewer(IGV)(Thorvaldsdóttir H, Robinson JT, Mesirov JP., 2013; Robinson JT, 2013)を使用し、indexの作成および可視化を行った。

<u>**遺伝子・転写因子のスクリーニング**</u><br>
　解析はpython3.7.10(https://www.python.org/downloads/release/python-3710) を主に用いて行った。RSEMの出力データとDEseq2の出力データを結合させ、BDF1のFPKM値が0.5以上かつ、BDF1とICRの差ではlog2FCが0.8以上(p-value < 0.05)、ICRとddYの差ではlog2FCが0.1以上(p-value < 0.05)の遺伝子を抽出した(jupyter/03_screening.ipynb)。抽出した遺伝子はoPOSSUM version3.0(http://opossum.cisreg.ca/oPOSSUM3) のSingle Site Analysis(SSA) mouseにて、遺伝子群で濃縮している転写因子結合モチーフを検索した。なお、転写因子結合モチーフのデータベースはJASPAR CORE 2020(Fornes O, et al., 2019)を使用し、TSS上流2kbを対象にZ-scoreが2以上となる転写因子のみを抽出した。抽出した上流の転写因子の候補の中から、MⅡ期卵のRNA-seqにおいてBDF1のFPKM値が0.3以上かつ、BDF1とICRの差とBDF1とddYとの差で共にlog2FCが0.6以上(p-value < 0.05)の転写因子を抽出した(jupyter/06_TFsearch.ipynb)。

<u>**Klf4の下流遺伝子の探索**</u><br>
GTFtools 0.8.0(Hong-Dong Li, 2018)を使用してGRCm38のアノテーションデータからTSSのデータを取得した(jupyter/07_getTSS.sh)。取得したTSSのデータを基に全遺伝子のTSS上流2kbを抽出し、BED形式のファイルとして出力した(jupyter/08_genesToBed.sh)。bedtools(Quinlan AR1, Hall IM., 2010)のgetfastaを用いて、BED形式のファイルからFASTA形式(リファレンス:mm10)のファイルに変換した(jupyter/09_getFASTA.sh)。JASPAR CORE 2020からKLF4の結合モチーフのデータ(MEME motif 形式)を取得し、MEME Suite 5.4.1のFIMO(Charles E. Grant et al., 2011)を用いてTSS上流2kbの中にあるKLF4結合モチーフの場所を特定した(jupyter/11_fimo.sh)。bedtoolsのintersectを用いて、KLF4結合モチーフの場所と遺伝子名を紐づけた(jupyter/12_TFmotifgene.sh)。以上の行程で得られたTSS上流2kb以内にKLF4結合モチーフを持つ遺伝子をKlf4の下流遺伝子として、MⅡ期卵での発現量とスクリーニングした遺伝子との一致度を調べた(jupyter/13_klf4downstream.ipynb)。また、Metascape(Zhou et al., 2019)を使用してGene Ontology解析を行い、得られたデータを可視化した(jupyter/14_GO.ipynb)。

