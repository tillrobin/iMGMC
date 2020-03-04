#!/bin/bash
# Conduct *.TPM KOsum*.tab file for all samples
SampleFile=$1
SampleID=${1%.TPM}
SampleID=${SampleID##*/}

echo "Summarize TPM for all samples"

echo -e "SampleID\tGeneID\tTPM" > SampleID-GeneID-TPM.tab

for i in *.TPM
do
echo $i
sed "s/^/${i%.TPM}\t/" ${i} >> SampleID-GeneID-TPM.tab
done

echo "Filter TPM>1 into extra file"
awk 'NR==1{print} NR>1{ if ($3 >= 1) { print } }' SampleID-GeneID-TPM.tab > SampleID-GeneID-TPM-min1.tab


echo "Summarize sumTPM for KOs for all Samples"

echo -e "SampleID\tKO\tTPM" > SampleID-KO-TPM.tab

for i in KO-sumTPM-*.tab
do
SampleName={i#KO-sumTPM-}
sed "s/^/${i%.tab}\t/" ${i} >> SampleID-KO-TPM.tab
done

# © Till Robin Lesker @ github.com/tillrobin