#!/bin/bash
# use ./splitTPMtoKeggKO.sh SampleID

SampleID=$1


masked_GeneID_KeggID=${iMGCPATH}/annotations/masked_GeneID_KeggID.map
masked_KeggID_KeggKO=${iMGCPATH}/annotations/masked_KeggID_KeggKO.map
all_iMGC_KOs=${iMGCPATH}/annotations/all_iMGC_KOs.txt

echo -e "Split $SampleID in KeggKOs via: \n $masked_GeneID_KeggID \n $masked_KeggID_KeggKO \n $all_iMGC_KOs"


#GeneID_KeggID=/vol/projects/trlesker/mousecatalog/Assembly-newMunich-mc5-metahit111/finals/tbl-GeneID-KeggGeneID.txt
#KeggID_KeggKO=/vol/projects/trlesker/mousecatalog/Assembly-newMunich-mc5-metahit111/finals/tbl-KeggID-KeggKO-version2.txt
#echo "mask mapping files"
#tail -n+2 $GeneID_KeggID | sed "s/\./_point_/g" | sed "s/\:/_douplepoint_/g" | sed "s/\-/_minus_/g" |  sed "s/^/gene/" > masked_GeneID_KeggID.map
#tail -n+2 $KeggID_KeggKO | sed "s/\./_point_/g" | sed "s/\:/_douplepoint_/g" | sed "s/\-/_minus_/g" > masked_KeggID_KeggKO.map

cat TPM-${SampleID}.txt | cut -f1 | sort > temp-Genes-${SampleID}.tmp
fgrep -w -f temp-Genes-${SampleID}.tmp $masked_GeneID_KeggID | sort -k 1,1 > temp-Genes-KeggGenes-${SampleID}.tmp
cut -f1 temp-Genes-KeggGenes-${SampleID}.tmp | fgrep -w -f - TPM-${SampleID}.txt | sort -k 1,1 > temp-Genes-TPM-${SampleID}.tmp

#head temp-Genes-${SampleID}.tmp
#head temp-Genes-KeggGenes-${SampleID}.tmp > head-temp-Genes-KeggGenes-${SampleID}.tmp
#head temp-Genes-TPM-${SampleID}.tmp > head-temp-Genes-TPM-${SampleID}.tmp 
#wc -l temp-Genes-${SampleID}.tmp
#wc -l temp-Genes-KeggGenes-${SampleID}.tmp
#wc -l temp-Genes-TPM-${SampleID}.tmp

paste temp-Genes-TPM-${SampleID}.tmp temp-Genes-KeggGenes-${SampleID}.tmp > temp-TPM-KeggGenes-${SampleID}.tmp 

#cut -f2 $masked_KeggID_KeggKO | sort | uniq > all_iMGC_KOs.txt

echo "grepping KOs please be patient"
while read line
do
#echo "$line"
fgrep -w $line $masked_KeggID_KeggKO | cut -f1 | fgrep -w -f - temp-TPM-KeggGenes-${SampleID}.tmp | cut -f2 | awk 'BEGIN {sum=0} {sum+=$1} END {print sum}' >> temp-KOs-${SampleID}.tmp
#break
done < $all_iMGC_KOs

paste $all_iMGC_KOs temp-KOs-${SampleID}.tmp > KOs-${SampleID}.txt

rm temp*.tmp


