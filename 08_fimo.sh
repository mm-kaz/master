#fimoにてTSS上流2kbにおける転写因子結合モチーフ(Klf4)の位置を特定した

mkdir fimo
cd fimo

mkdir bedOutput

fimo --o MA0039.2 ../TFdata/meme/MA0039.2.meme ../genes/TSS_BDF1_expressed.fa
python3.7 ../FimotoBed.py MA0039.2 BDF1_expressed


fimo --o allKlf4 ../TFdata/meme/MA0039.2.meme ../genes/allgenes_TSS.fa
python3.7 ../FimotoBed.py MA0039.2 all