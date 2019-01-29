#!/bin/bash -e
#$ -l arch=linux-x64
#$ -b n
#$ -q all.q
#$ -i /dev/null
#$ -e /vol/cluster-data/adurairaj/gmak_transcriptome/output/
#$ -o /vol/cluster-data/adurairaj/gmak_transcriptome/output/
#$ -cwd
#$ -l vf=3G
#$ -pe multislot 20




 Rscript /vol/projects/MIKI/R_files/workflow_management_16S_meta_int.R /vol/projects/MIKI/R_files/forCor-Bins-TPMbyLibrary.txt /vol/projects/MIKI/R_files/MetaData.csv /vol/projects/MIKI/R_files/forCor-16S-unambignousMappedReadsbyLibrary.txt /vol/projects/MIKI/R_files/map-unambignous-matrix.txt /vol/projects/MIKI/R_files/blast-matrix.txt /vol/projects/MIKI/R_files/
