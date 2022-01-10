#モチーフの位置データを遺伝子名のデータと連結

cd motifGenes

bedtools intersect -loj -a ../genes/TSS_BDF1_expressed.bed -b ../fimo2/bedOutput/BDF1_expressed_allTF.bed > BDF1_expressed_allTFmotif.bed
