cd scafstats-statsfiles


for i in *.scafstats
do
echo $i
echo "Sample${i%.scafstats}" > ${i%.scafstats}.tmp
tail -n+2 $i | cut -f6 >> ${i%.scafstats}.tmp
done





for i in *.scafstats
do
echo $i
echo "Sample" > 00000.tmp
tail -n+2 $i | cut -f1 >> 00000.tmp
break
done

paste *.tmp > ../16S-abundances.tab

rm *.tmp

cd ..
