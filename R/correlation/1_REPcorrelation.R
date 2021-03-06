#作業ディレクトリを設定する
setwd("/Users/shigenseigyo/Desktop/analysis/R/nagashima/correlation/210610_m2/")

#データの読み込み(m2のFPKM値)
DATA <- read.table("/Users/shigenseigyo/Desktop/analysis/jupiter/nagashima/210609_master1/M2_FPKM_mm10_row.tsv",header = T,
                   quote="",sep="\t",row.names=1,check.names=FALSE)
#中身の確認
DATA

library(ggplot2) #ggplot2 を呼び出す

#Rは文字列結合に+が使えないので定義
"+" = function(e1, e2){
  if(is.character(c(e1, e2))){
    paste(e1, e2, sep="")
  }else{
    base::"+"(e1, e2)
  }
}

#(FPKM1,2)の発現量を比較する

#ピアソン相関係数を算出する(+0.001はFPKM0だと駄目なため)
cor.test(log2(DATA$BDF1_FPKM_rep1+0.001),log2(DATA$BDF1_FPKM_rep2+0.001),method="pearson")

# 「r={相関係数}」という文字列を作成する。ピアソン相関係数はroundする。
corr <- round(cor(log2(DATA$BDF1_FPKM_rep1+0.001),log2(DATA$BDF1_FPKM_rep2+0.001),method="pearson"), 5)

#scattering plotを描く(ggplot2)
p <- ggplot(log2(DATA+0.001),aes(x=BDF1_FPKM_rep1, y=BDF1_FPKM_rep2))+
  geom_point()+  #散布図
  geom_smooth(method="lm",se=FALSE,colour ="red")+ #回帰直線
  
  annotate("text",label="r^2=="+corr,parse=TRUE,x=12,y=2.5) #相関係数の挿入
theme_bw() #白を基調としたテーマ

p <- p+
  xlab("BDF1 rep1 log2(FPKM+0.001)")+ #x軸ラベル
  ylab("BDF1 rep2 log2(FPKM+0.001)")+ #y軸ラベル
  xlim(-10,15)+ylim(-10,15) #x軸とy軸の範囲指定

#scattering plotを出力する(解像度100dpi,幅6インチ,高さ6インチ)
ggsave(file="./BDF1_rep_FPKM.png",plot=p,dpi=100,width=6,height=6)


