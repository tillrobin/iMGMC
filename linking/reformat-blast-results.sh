BlastOutput=$1
mgs16SFile=$2
BinFile=$3


#cat $BlastOutput | awk '$3 > 97' | awk '$4 > 100' | cut -f1,2,12 > filtered-BlastOut.tab

cut -f2 $BlastOutput | sort -u | fgrep -w -v -f - $mgs16SFile > missing-16S.txt
cut -f1 $BlastOutput | sort -u | fgrep -w -v -f - $BinFile > missing-bins.txt


#fgrep ">" $BinFile | tr -d ">" > all-bins.txt
#fgrep ">" $mgs16SFile | tr -d ">" > all-16S.txt


while read line
do
echo "${line}" > temp-pasting-${line}.tmp
cat \
<( fgrep -w $line $BlastOutput | cut -f2,3) \
<( fgrep -w $line $BlastOutput | cut -f2 | fgrep -w -v -f - $2 | sed -e "s/$/\t0/" ) | \
sort -k 1 | cut -f2 >> temp-pasting-${line}.tmp
done < $3

paste <( cat <(echo "Name") $2) temp-pasting-*.tmp > matrix-Blast.tab
#rm temp-pasting-*.tmp





