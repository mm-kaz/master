#作業ディレクトリを設定する
setwd("/Users/shigenseigyo/Desktop/analysis/R/nagashima/FPKMheatmap/")

#データの読み込み(m2のFPKM値)
DATA <- read.table("/Users/shigenseigyo/Desktop/analysis/jupiter/nagashima/211006_master5/seqData/M2_FPKM_mm10_row.tsv",header = T,
                   quote="",sep="\t",row.names=1,check.names=FALSE)
#中身の確認
DATA

#ヒートマップを書く
#パッケージにはheatmap.2(gplots),ggplot2,ComplexHeatmapなどがある

library(gplots) #gplotsを呼び出す

#フィルタリング
#少なくとも一つのサンプルでFPKM>0.01の遺伝子のみを抽出する(発現量が低すぎる遺伝子の行は除外)
DATA2 <- DATA[which(apply(DATA,1,max)> 0.5),]
DATA3 <- log2(DATA2+0.001)
DATA4 <- t(scale(t(DATA3))) #Z-Score
DATA4

nrow(DATA2)

#階層的クラスタリング
#ユークリッド距離、ウォード法
d1 <- dist(DATA4, method="euclidean")
d2 <- dist(t(DATA4), method="euclidean")
d2
c1 <- hclust(d1, method="ward.D2")
c2 <- hclust(d2, method="ward.D2")
c1

#heatmap --> pdf
pdf(file="m2_dendrogram_heatmap.pdf", pointsize=6, width=10, height=15)

heatmap.2(as.matrix(DATA4),
          Colv=as.dendrogram(c2),Rowv=as.dendrogram(c1),
          dendrogram="column",na.color="grey",
          scale="none", trace="none", density.info="none",
          col=colorpanel(53, low="blue4", mid="black", high="yellow2"),
          keysize=1, symkey=T, key=T, key.xlab="Z-Score",
          key.title="", lhei=c(1,10), lwid=c(1,5), margin=c(12,18))

dev.off()

