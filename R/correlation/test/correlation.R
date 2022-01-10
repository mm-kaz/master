#データの読み込み(early2cellのFPKM値)
DATA <- read.table("./Desktop/analysis/rna-seq/early_2cell_fpkm.csv",header = T,
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

#rep(FPKM1,2)の発現量を比較する

#ピアソン相関係数を算出する(+1はRPKM0だと駄目なため)
cor.test(log2(DATA$FPKM1+1),log2(DATA$FPKM2+1),method="pearson")

# 「r={相関係数}」という文字列を作成する。ピアソン相関係数はroundする。
corr <- round(cor(log2(DATA$FPKM1+1),log2(DATA$FPKM2+1),method="pearson"), 2)

#scattering plotを描く(ggplot2)
p <- ggplot(log2(DATA+1),aes(x=FPKM1, y=FPKM2))+
  geom_point()+  #散布図
  geom_smooth(method="lm",se=FALSE,colour ="red")+ #回帰直線
  
  annotate("text",label="r^2=="+corr,parse=TRUE,x=12,y=2.5) #相関係数の挿入
theme_bw() #白を基調としたテーマ

p <- p+
  xlab("rep1 log2(RPKM+1)")+ #x軸ラベル
  ylab("rep2 log2(RPKM+1)")+ #y軸ラベル
  xlim(0,13)+ylim(0,13) #x軸とy軸の範囲指定

#scattering plotを出力する(解像度100dpi,幅6インチ,高さ6インチ)
ggsave(file="./Desktop//analysis/rna-seq/scatter.png",plot=p,dpi=100,width=6,height=6)


