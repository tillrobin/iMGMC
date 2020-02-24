#!/bin/bash
#use ./makeTPMstats.sh SampleID


SampleID=$1
GeneID_TaxLevel=${iMGCPATH}/annotations/GeneID-TaxLevel-PPSP.txt

echo "Mapping taxonmic levels for $SampleID via $GeneID_TaxLevel"


paste <(cut -f2 TPM-${SampleID}.txt) <(cut -f1 TPM-${SampleID}.txt | fgrep -w -f - $GeneID_TaxLevel | sort -k1,1)  > TaxLevel-PPSP-TPM-${SampleID}.txt

awk -F '\t' 'BEGIN {OFS = FS} {a[$3] += $1} END {for (i in a) print "TaxLevel" , a[i] , i}' TaxLevel-PPSP-TPM-${SampleID}.txt | sort -k2 -n -r  > TaxLevel-PPSP-Stats-${SampleID}.txt

