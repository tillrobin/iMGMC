#!/bin/bash
#make TPM from CovStats
SampleID=${1%.covstats}
SampleID=${SampleID##*/}

echo "Making TPM from ${SampleID}"

PerMillionScalingFactor=$(tail -n+2 ${SampleID}.covstats | gawk -v OFS='\t' -v FS='\t' '{sumRPK+=($7+$8)/(($3-50)/1000)} END {print sumRPK/1000000}')
echo "Sample: "${SampleID}" PerMillionScalingFactor: "${PerMillionScalingFactor}
tail -n+2 ${SampleID}.covstats | \
gawk -v PerMillionScalingFactor=${PerMillionScalingFactor} -v OFS='\t' -v FS='\t' \
'{print $1, ($7+$8)/(($3-50)/1000)/PerMillionScalingFactor }' | \
grep -w -v "0$" > ${SampleID}.TPM

# © Till Robin Lesker @ github.com/tillrobin