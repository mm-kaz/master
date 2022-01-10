#作業ディレクトリを設定する
setwd("/Users/shigenseigyo/Desktop/analysis/R/nagashima/DeSeq2")

library(DESeq2)
library(tximport)

s2c <- read.table("M2.csv", header=T, sep=",", stringsAsFactors = F)
s2c$group <- gsub(" ", "_", s2c$group)

#RSEMの出力ファイルの読みこみ
files <- s2c$path
names(files) <- s2c$sample

txi <- tximport(files, type="rsem", txIn=F, txOut=F)
txi
#length=0を1に置換
txi$length[txi$length==0] <- 1

#sampleの読み込み
sampleTable <- data.frame(condition=s2c$group)
rownames(sampleTable) <- colnames(txi$counts)
sampleTable
dds <- DESeqDataSetFromTximport(txi, sampleTable, ~condition)
dds

#Wald検定（wt） 2群
#dds_wt <- DESeq(dds)
#dds_wt
#res_wt <- results(dds_wt)
#res_wt_naomit <- na.omit(res_wt) # NA を除外
#res_wt_naomit

#尤度比検定（lrt）3群以上でも可
dds_lrt <- DESeq(dds, test="LRT", reduced =~1)

#BDF1 vs ddY
res_lrt_1 <- results(dds_lrt,contrast=c("condition","BDF1","ddY"))
res_lrt_naomit_1 <- na.omit(res_lrt_1) # NA を除外
res_lrt_naomit_1
write.table(res_lrt_naomit_1, file = "BDF1vsddY_lrt.tsv", row.names = T, col.names = T, sep = "\t")
#可視化
plotMA(res_lrt_naomit_1, ylim=c(-15,15), colNonSig = "gray32", colSig = "grey32")
png("BDF1vsddY_MAplot.png", height=2500, width=3000, res=500)
plotMA(res_lrt_naomit_1, ylim=c(-15,15), colNonSig = "gray32", colSig = "grey32")
dev.off()

#BDF1 vs ICR
res_lrt_2 <- results(dds_lrt,contrast=c("condition","BDF1","ICR"))
res_lrt_naomit_2 <- na.omit(res_lrt_2) # NA を除外
res_lrt_naomit_2
write.table(res_lrt_naomit_2, file = "BDF1vsICR_lrt.tsv", row.names = T, col.names = T, sep = "\t")
#可視化
plotMA(res_lrt_naomit_2, ylim=c(-15,15), colNonSig = "gray32", colSig = "grey32")
png("BDF1vsICR_MAplot.png", height=2500, width=3000, res=500)
plotMA(res_lrt_naomit_2, ylim=c(-15,15), colNonSig = "gray32", colSig = "grey32")
dev.off()

#ICR vs ddY
res_lrt_3 <- results(dds_lrt,contrast=c("condition","ICR","ddY"))
res_lrt_naomit_3 <- na.omit(res_lrt_3) # NA を除外
res_lrt_naomit_3
write.table(res_lrt_naomit_3, file = "ICR1vsddY_lrt.tsv", row.names = T, col.names = T, sep = "\t")
#可視化
plotMA(res_lrt_naomit_3, ylim=c(-15,15),colNonSig = "gray32", colSig = "grey32")
png("ICR1vsddY_MAplot.png", height=2500, width=3000, res=500)
plotMA(res_lrt_naomit_3, ylim=c(-15,15),colNonSig = "gray32", colSig = "grey32")
dev.off()

