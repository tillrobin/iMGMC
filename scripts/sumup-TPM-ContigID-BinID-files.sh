#!/bin/bash
# Conduct ContigID-sumTPM*.tab file for all samples

echo "Summarize TPM for all ContigID-TPM-files for all samples"

echo -e "SampleID\tContigID\tTPM" > SampleID-ContigID-TPM.tab

for i in ContigID-sumTPM-*.tab
do
SampleName=${i#ContigID-sumTPM-}
SampleName=${SampleName%.tab}
echo $i
sed "s/^/${SampleName}\t/" ${i} >> SampleID-ContigID-TPM.tab
done

echo "Filter TPM>1 for ContingIDs into extra file"
awk 'NR==1{print} NR>1{ if ($3 >= 1) { print } }' SampleID-ContigID-TPM.tab > SampleID-ContigID-TPM-min1.tab


###########

echo "Summarize TPM for all BinID-TPM-files for all samples"

echo -e "SampleID\tBinID\tTPM" > SampleID-BinID-TPM.tab

for i in BinID-sumTPM-*.tab
do
SampleName=${i#BinID-sumTPM-}
SampleName=${SampleName%.tab}
echo $i
sed "s/^/${SampleName}\t/" ${i} >> SampleID-BinID-TPM.tab
done

echo "Filter TPM>1 for BinIDs into extra file"
awk 'NR==1{print} NR>1{ if ($3 >= 1) { print } }' SampleID-BinID-TPM.tab > SampleID-BinID-TPM-min1.tab


# © Till Robin Lesker @ github.com/tillrobin