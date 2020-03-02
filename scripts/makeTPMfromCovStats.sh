#!/bin/bash
#make TPM from CovStats
SampleID=$1


echo "Making TPM from ${SampleID}"

tail -n+2 ${SampleID}.covstats | gawk -v OFS='\t' -v FS='\t' '{print $1, $3, ($7+$8)/(($3-50)/1000)}' > temp-RPK-${SampleID}.tmp
PerMillionScalingFactor=$(gawk -v OFS='\t' -v FS='\t' '{sum+=$3} END {print sum/1000000}' temp-RPK-${SampleID}.tmp) 
echo "Sample: "${SampleID}" PerMillionScalingFactor: "${PerMillionScalingFactor}

gawk -v PMSF=${PerMillionScalingFactor} -v OFS='\t' -v FS='\t' '{print $3/PMSF}' temp-RPK-${SampleID}.tmp >> temp-TPM-${SampleID}.tmp



paste <(tail -n+2 ${SampleID}.covstats | cut -f1) temp-TPM-${SampleID}.tmp | sort -k1,1 -n | sed "s/^/gene/" | grep -w -v "0$" > TPM-${SampleID}.txt

rm temp-RPK-${SampleID}.tmp
rm temp-TPM-${SampleID}.tmp

