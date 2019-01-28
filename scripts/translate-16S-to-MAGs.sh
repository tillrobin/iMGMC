#!/bin/bash
# translate 16S reads library to MAGs abundances, generate simulated covstats-file
# use 
echo $1
SampleID=$1

mgs16SGeneID=${iMGCPATH}/annotations/mgs16S-GeneID.txt
Ref16S=${iMGCPATH}/ref-16S/
#iMGC-16SwithMGS.fasta


bbmap.sh path=${Ref16S} in=${2} scafstats=${SampleID}-iMGC16s.scafstats


tail -n+2 ${SampleID}-iMGC16s.scafstats | cut -f1,6 > temp-cut-${SampleID}-iMGC16s.tmp

#echo -e "16S\tGeneID\tReads" > ${SampleID}-Genes-Reads.txt


while read line
do
Name16s=$( echo $line | cut -f1 -d" " )
Reads=$( echo $line | cut -f2 -d" " )
if [ "$Reads" -eq "0" ] 
then
continue
fi
fgrep -w ${Name16s} $mgs16SGeneID | sed -e "s/$/\t${Reads}/" >> ${SampleID}-Genes-Reads.txt
done < temp-cut-${SampleID}-iMGC16s.tmp


PerMillionScalingFactor=$(gawk -v OFS='\t' -v FS='\t' '{sum+=$3} END {print sum/1000000}' ${SampleID}-Genes-Reads.txt)
echo "Sample: "${SampleID}" PerMillionScalingFactor: "${PerMillionScalingFactor}

#gawk -v PMSF=${PerMillionScalingFactor} -v OFS='\t' -v FS='\t' '{print $1,$2,$3,$3/PMSF}' ${SampleID}-Genes-Reads.txt >> TPM-${SampleID}.txt
gawk -v PMSF=${PerMillionScalingFactor} -v OFS='\t' -v FS='\t' '{print "gene"$2,$3/PMSF}' ${SampleID}-Genes-Reads.txt >> TPM-${SampleID}.txt


#################
