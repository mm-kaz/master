#fimoにてTSS上流2kbにおける転写因子結合モチーフの位置を特定した

mkdir fimo2
cd fimo2

mkdir bedOutput


#allmotif vs screenedGenes
cut -d ',' -f 2 ../TFdata/TFList_nonTrim.csv | sed -e '1d' | while read line
do
 fimo --o ${line} ../TFdata/meme/${line}.meme ../genes/TSS_BDF1_expressed.fa
 python3.7 ../FimotoBed.py ${line} BDF1_expressed
done

cd bedOutput
cat *.bed > BDF1_expressed_allTF.bed