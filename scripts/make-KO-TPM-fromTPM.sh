#!/bin/bash
#make KO from TPM
SampleFile=$1
SampleID=${1%.TPM}
SampleID=${SampleID##*/}

# file check

FILE=iMGMC-map-GeneID-KeggKO.tab
if [ -f "$FILE" ]; then
    echo "$FILE exist, go ahead"
else 
    echo "$FILE does not exist, please download!"
fi

echo "Filter and add KO for ${SampleID}, use only one KO per GeneID"

paste \
<( cut -f1 $SampleFile | fgrep -w -f - iMGMC-map-GeneID-KeggKO.tab | sort -k1,1 -u ) \
<( cut -f1 iMGMC-map-GeneID-KeggKO.tab | fgrep -w -f - $SampleFile | sort ) | \
 cut -f1,2,4 > GeneID-TPM-KO-${SampleID}.tab

echo "Sumup TPM for KOs for ${SampleID}"

cut -f2,3 GeneID-TPM-KO-${SampleID}.tab | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print i, a[i]}' > KO-sumTPM-${SampleID}.tab


# © Till Robin Lesker @ github.com/tillrobin