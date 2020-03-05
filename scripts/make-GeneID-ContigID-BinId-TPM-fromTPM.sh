#!/bin/bash
#make GeneID-ContigID-BinID from TPM
SampleFile=$1
SampleID=${1%.TPM}
SampleID=${SampleID##*/}

# file check

FILE=iMGMC-map-Gene-Contig-Bin.tab
if [ -f "$FILE" ]; then
    echo "$FILE exist, go ahead"
else 
    echo "$FILE does not exist, please download!"
fi

echo "Add ContigID and BinID to GeneIDs for ${SampleID}"

paste \
<( cut -f1 $SampleFile | fgrep -w -f - iMGMC-map-Gene-Contig-Bin.tab | sort -k1,1 -u ) \
<( cut -f1 iMGMC-map-Gene-Contig-Bin.tab | fgrep -w -f - $SampleFile | sort ) | \
 cut -f1,2,3,5 > GeneID-ContigID-BinID-${SampleID}.tab

echo "Sumup TPM for ContigID and BinID for ${SampleID}"

cut -f2,4 GeneID-ContigID-BinID-${SampleID}.tab | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print i, a[i]}' > ContigID-sumTPM-${SampleID}.tab
cut -f3,4 GeneID-ContigID-BinID-${SampleID}.tab | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print i, a[i]}' > BinID-sumTPM-${SampleID}.tab

# © Till Robin Lesker @ github.com/tillrobin