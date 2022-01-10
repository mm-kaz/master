#TFlistのJASPARIDをもとにmemeのモチーフデータをダウンロードする

mkdir ./TFdata/meme
cd ./TFdata/meme


cut -d ',' -f 2 ../TFList_nonTrim.csv | sed -e '1d' | while read line

do
 wget http://jaspar.genereg.net/api/v1/matrix/${line}.meme
 sleep 2
done
