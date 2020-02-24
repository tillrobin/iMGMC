#!/bin/bash
# use ./splitTPMtoMGS.sh SampleID

SampleID=$1
GeneIDMGSID=${iMGCPATH}/annotations/GeneID-MGSID.txt


echo "Split TPM for $SampleID die MGS via $GeneIDMGSID"

paste <(cut -f1 TPM-${SampleID}.txt | fgrep -w -f - $GeneIDMGSID | sort -k1,1) <(cut -f1 $GeneIDMGSID | fgrep -w -f - TPM-${SampleID}.txt | sort -k1,1 | cut -f2) > Genes-MGS-TPM-${SampleID}.txt

awk -F '\t' 'BEGIN {OFS = FS} {a[$2] += $3} END {for (i in a) print "MGS" , a[i] , i}' Genes-MGS-TPM-${SampleID}.txt | sort -k2 -n -r  > MGS-Stats-${SampleID}.txt

