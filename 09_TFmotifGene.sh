#モチーフの位置データを遺伝子名のデータと連結

mkdir motifGenes
cd motifGenes

bedtools intersect -loj -a ../genes/TSS_BDF1_expressed.bed -b ../fimo/bedOutput/BDF1_expressed_MA0039.2.bed > BDF1_expressed_TFmotif.bed
bedtools intersect -loj -a ../genes/allgenes_TSS.bed -b ../fimo/bedOutput/all_MA0039.2.bed > all_klf4_TFmotif.bed
