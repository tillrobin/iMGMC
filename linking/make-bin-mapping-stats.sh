cd ref-statsfiles


for i in *.statsfile
do
echo $i
echo "Sample${i%.statsfile}" > ${i%.statsfile}.tmp
tail -n+2 $i | cut -f6 >> ${i%.statsfile}.tmp
done





for i in *.statsfile
do
echo $i
echo "Sample" > 00000.tmp
tail -n+2 $i | cut -f1 >> 00000.tmp
break
done

paste *.tmp > ../bin-abundances.tab

rm *.tmp

cd ..
