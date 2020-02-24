#!/bin/bash
# tax breaking
#!bash
#used ./splitTPMtoTaxonomy.sh SampleID
SampleID=$1
GeneIDcat=${iMGCPATH}/annotations/iMGC-GeneID-CAT.txt

echo "Start splitTPMtoTaxonomy.sh with ${SampleID}"


cat TPM-${SampleID}.txt | cut -f1 | sort > temp-Genes-${SampleID}.tmp
fgrep -w -f temp-Genes-${SampleID}.tmp $GeneIDcat | sort -k1,1 > temp-Genes-Taxonomy-${SampleID}.tmp
wc -l temp-Genes-Taxonomy-${SampleID}.tmp
wc -l temp-Genes-${SampleID}.tmp
cut -f1 temp-Genes-Taxonomy-${SampleID}.tmp | cat - temp-Genes-${SampleID}.tmp | sort | uniq -u | \
sed -e "s/$/\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified/" | \
cat temp-Genes-Taxonomy-${SampleID}.tmp - | sort -k1,1 > temp-Genes-Taxonomy-inclMissings-${SampleID}.tmp

wc -l temp-Genes-Taxonomy-inclMissings-${SampleID}.tmp

sort -k1,1 TPM-${SampleID}.txt | cut -f2 | paste - temp-Genes-Taxonomy-inclMissings-${SampleID}.tmp > temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp

echo -e "TaxLevel\tTPM\tTaxName" > Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$4] += $1} END {for (i in a) print "superkingdom" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$5] += $1} END {for (i in a) print "phylum" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$6] += $1} END {for (i in a) print "class" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$7] += $1} END {for (i in a) print "order" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$8] += $1} END {for (i in a) print "family" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$9] += $1} END {for (i in a) print "genus" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt
awk -F '\t' 'BEGIN {OFS = FS} {a[$10] += $1} END {for (i in a) print "species" , a[i] , i}' temp-Genes-Taxonomy-inclMissings-TPM-${SampleID}.tmp | sed -e "s/\r//" | sort -k2 -n -r  >> Taxonomy-Stats-${SampleID}.txt

rm temp*.tmp
