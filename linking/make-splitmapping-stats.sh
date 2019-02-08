
cd ./scafstats-statsfiles-unpaired-all

for statsfile in *.scafstats; do
 echo ${statsfile%.scafstats}
 echo ${statsfile%.scafstats} > name.tmp
 cat ${statsfile} | cut -f6 > stat.tmp
 cat name.tmp stat.tmp > ${statsfile%.scafstats}-mamestat.tmp
done


#file limit
#paste *-mamestat.tmp > allstats.txt

for f in *-mamestat.tmp; do cat final.res | paste - $f >temp; cp temp final.res; echo $f; done; rm temp

rm *.tmp
mv final.res ../allstats-unambiguousReads.txt && rm final.res
cd ..
echo "all done"




#orginal solution: http://unix.stackexchange.com/questions/205642/combining-large-amount-of-files
#for f in res.*; do cat final.res | paste - $f >temp; cp temp final.res; done; rm temp


###for ambiguousReads


cd ./scafstats-statsfiles-unpaired-all

for statsfile in *.scafstats; do
 echo ${statsfile%.scafstats}
 echo ${statsfile%.scafstats} > name.tmp
 cat ${statsfile} | cut -f7 > stat.tmp
 cat name.tmp stat.tmp > ${statsfile%.scafstats}-mamestat.tmp
done


#file limit
#paste *-mamestat.tmp > allstats.txt

for f in *-mamestat.tmp; do cat final.res | paste - $f >temp; cp temp final.res; echo $f; done; rm temp

rm *.tmp
mv final.res ../allstats-ambiguousReads.txt && rm final.res
cd ..
echo "all done"
