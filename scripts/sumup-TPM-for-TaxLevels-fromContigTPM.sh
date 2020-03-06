#!/bin/bash
#make Taxonomic summary from ContigID-sumTPM-${SampleID}.tab
SampleFile=$1
SampleID=${1%.tab}
SampleID=${SampleID#*ContigID-sumTPM-}

echo "Check annotation file: iMGMC_map_ContigID_TaxID_Superkingdom_Phylum_Class_Order_Family_Genus_Species.tab"

FILE=iMGMC_map_ContigID_TaxID_Superkingdom_Phylum_Class_Order_Family_Genus_Species.tab
if [ -f "$FILE" ]; then
    echo "$FILE exist, go ahead"
else 
    echo "$FILE does not exist, please download!"
fi

echo "Sumup TPM in Taxonomic levels for ${SampleID}"

echo -e "TaxLevel\tTaxonomy\tTPM" > sumContigTPM-Taxonomic-${SampleID}.tab

paste \
<( cut -f1 $SampleFile | fgrep -w -f - iMGMC_map_ContigID_TaxID_Superkingdom_Phylum_Class_Order_Family_Genus_Species.tab | sort -k1,1 -u ) \
<( cut -f1 iMGMC_map_ContigID_TaxID_Superkingdom_Phylum_Class_Order_Family_Genus_Species.tab | fgrep -w -f - $SampleFile | sort )  | \
sed "s/\t\t/\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified\tunclassified/" | \
tee >(cut -f3,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Superkingdom", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
tee >(cut -f4,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Phylum", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
tee >(cut -f5,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Class", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
tee >(cut -f6,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Order", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
tee >(cut -f7,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Family", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
tee >(cut -f8,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Genus", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab) | \
cut -f9,11 | awk -F '\t' 'BEGIN {OFS = FS} {a[$1] += $2} END {for (i in a) print "Species", i, a[i]}' | sort -k3 -n -r >> sumContigTPM-Taxonomic-${SampleID}.tab



echo -e "TaxLevel\tTaxonomy\tTPM" > sumContigTPM-Taxonomic-top12-${SampleID}.tab
fgrep -v "unclassified" sumContigTPM-Taxonomic-${SampleID}.tab | fgrep -v "NA" | \
tee >(grep -m 12 "^Superkingdom" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
tee >(grep -m 12 "^Phylum" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
tee >(grep -m 12 "^Class" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
tee >(grep -m 12 "^Order" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
tee >(grep -m 12 "^Family" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
tee >(grep -m 12 "^Genus" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab) | \
grep -m 12 "^Species" >> sumContigTPM-Taxonomic-top12-${SampleID}.tab





# © Till Robin Lesker @ github.com/tillrobin