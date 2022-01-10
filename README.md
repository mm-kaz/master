# master
修士論文で使用したコード<br>

<u>**RNA-seq解析(`RNA-seq.sh`)**</u><br>
　fastp version0.20.1(Chen S et al., 2018)を用い、パラメーターを -q 20 -length_requierd 20 に設定し、RNA-seqリードのトリミングを行った。トリミングされたリードはSTAR version2.7.8a(https://github.com/alexdobin/STAR)を用いてリファレンスゲノム(UCSC mm10)へのマッピングを行った。STARのパラメーターは –runMode alignReads –quantMode TranscriptomeSAM GeneCounts を指定して実行した。その後、マッピングにより得られたデータを用いてRSEM(Li B & Dewey CN, 2011)による転写産物の発現量の推定を行った。RSEMで得られたFPKM(Fragments Per Kilobase of exon per Million mapped reads)値をもとに、R version4.0.2を用いて複製実験間の相関解析(`R/correlation/1_REPcorrelation.R`)および階層的クラスタリング(`R/FPKMheatmap/heatmap.R`)を行った。階層的クラスタリング解析に関しては、FPKM値が少なくとも1つのサンプルで0.01より大きくなる遺伝子を対象に行った。また、FPKM値をもとにRパッケージのDEseq2 version1.30.1(Love MI et al., 2014)を用いて、正規化および遺伝子発現の差の検出を行った(`R/DESeq2/DESeq2.R`)。

<u>**母性因子候補遺伝子のスクリーニング(`02_Genescreening.ipynb`)**</u><br>
　解析はpython3.7.10（https://www.python.org/downloads/release/python-3710)を主に用いて行った。まず、RSEMの出力データとDEseq2の出力データを結合させ、BDF1のFPKM値が1以上、ICRのFPKM値が0.1以上となる遺伝子を抽出した。続いて、抽出した遺伝子の中からBDF1とICRの差ではlog2Fold Change（FC）が0.8以上（p-value < 0.05）、ICRとddYの差ではlog2FCが0.1以上（p-value < 0.05）の遺伝子を抽出し、母性因子の候補遺伝子とした。また、スクリーニングした遺伝子群のGene Ontology解析はMetascape（Zhou YY et al., 2019）を使用して行った(metascape & `11_GO.ipynb`)。
 
<u>**上流転写因子のスクリーニング(`03_TFscreening.ipynb`)**</u><br>
　oPOSSUM 3.0（Andrew TK, 2012）のSingle Site Analysis（SSA） mouseにて、候補遺伝子群に見られる転写因子結合モチーフを検索した。なお、転写因子結合モチーフのデータベースはJASPAR CORE 2020（Fornes O, et al., 2019）を使用し、TSS上流2kbを対象に抽出を行った。90個の母性因子の候補遺伝子のうち20%に相当する18個以上の遺伝子の上流に存在する転写因子結合モチーフを抽出し、得られた転写因子を候補遺伝子の上流転写因子の候補とした。抽出した99個の上流転写因子の候補に対し、スクリーニングを行った。上流の転写因子の候補のスクリーニングにはMⅡ期卵のRNA-seqデータを利用した。まず、BDF1のFPKM値が0.3以上の転写因子を抽出した。続いて、BDF1とICRの差とBDF1とddYの差で共にlog2FCが0.6以上（p-value < 0.05）の転写因子を抽出し、ddYとICRの差でlog2FCが0.6以上となる転写因子は除いた。

<u>**Klf4の下流遺伝子の探索**</u><br>
GTFtools 0.8.0(Hong-Dong Li, 2018)を使用してGRCm38のアノテーションデータからTSSのデータを取得した(`04_getTSS.sh`)。取得したTSSのデータを基に全遺伝子のTSS上流2kbを抽出し、BED形式のファイルとして出力した(05_genesToBed.sh)。bedtools(Quinlan AR1, Hall IM., 2010)のgetfastaを用いて、BED形式のファイルからFASTA形式(リファレンス:mm10)のファイルに変換した(`06_getFASTA.sh`)。JASPAR CORE 2020からKLF4の結合モチーフのデータ(MEME motif 形式)を取得し(`07_getTFmeme.sh`)、MEME Suite 5.4.1のFIMO(Charles E. Grant et al., 2011)を用いてTSS上流2kbの中にあるKLF4結合モチーフの場所を特定した(`08_fimo.sh`)。bedtoolsのintersectを用いて、KLF4結合モチーフの場所と遺伝子名を紐づけた(`09_TFmotifgene.sh`)。以上の行程で得られたTSS上流2kb以内にKLF4結合モチーフを持つ遺伝子をKlf4の下流遺伝子として、MⅡ期卵での発現量とスクリーニングした遺伝子との一致度を調べた(`10_klf4downstream.ipynb`)。

