#!/bin/bash
# running PICRUSt workflow with iMGMC data
# use ./iMGMC-PICRUSt.bash OTUtable.biom OTUseq.fasta

SampleName=${1%.biom}
SampleName=${SampleName##*/}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

echo "$SCRIPTPATH"

CopyNumber=$SCRIPTPATH/iMGMC-CopyNr-16SrRNA.tab
LinkFile=$SCRIPTPATH/iMGMC-MAGs16SrRNAlinks.tab
KOfile=$SCRIPTPATH/iMGMC-KO_traits.tab
iMGMC16SrRNAalignment=$SCRIPTPATH/iMGMC-16SrRNA-alignment.fasta

mkdir $SampleName
cd $SampleName

#run alignment:
pynast -i $2 -t $iMGMC16SrRNAalignment -p 50 -l 100 -a ${SampleName}-pynast-alignment.fasta

#cleanup alignment:
cat iMGC-16S-alignment.fasta <(cat ${SampleName}-pynast-alignment.fasta | sed -e "s/ 1.*//" | sed "s/_//" ) > ${SampleName}-pynast-final-alignment.fasta

#create tree:
FastTreeMP -nt < ${SampleName}-pynast-final-alignment.fasta > ${SampleName}-FastTree.nwk

#setting vars
TreeFile=${SampleName}-FastTree.nwk

#PICRUSt Genome Prediction
format_tree_and_trait_table.py -t $TreeFile -i $CopyNumber -m $LinkFile -o format/16S/
format_tree_and_trait_table.py -t $TreeFile -i $KOfile -m $LinkFile -o format/KEGG/

ancestral_state_reconstruction.py -i format/16S/trait_table.tab -t format/16S/pruned_tree.newick -o asr/16S_asr_counts.tab
ancestral_state_reconstruction.py -i format/KEGG/trait_table.tab -t format/KEGG/pruned_tree.newick -o asr/KEGG_asr_counts.tab

predict_traits.py -i format/16S/trait_table.tab -t format/16S/reference_tree.newick -r asr/16S_asr_counts.tab -o predict_traits/16S_precalculated.biom
predict_traits.py -i format/KEGG/trait_table.tab -t format/KEGG/reference_tree.newick -r asr/KEGG_asr_counts.tab -o predict_traits/ko_precalculated.biom

#PICRUSt Metagenome Prediction
#biom convert -i otu_table.tab -o otu_table.biom --to-hdf5

normalize_by_copy_number.py -i otu_table.biom -o normalized_otus.biom -c predict_traits/16S_precalculated.biom

predict_metagenomes.py -f -i normalized_otus.biom -o metagenome_predictions.tab -c predict_traits/ko_precalculated.biom


