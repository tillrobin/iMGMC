# Creation of single-sample MAGs

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Assembly](#Assembly)  
[Binning](#Binning)  
[Quality-Estimation](#CheckM)  
[Dereplication](#Dereplication)  


# Description

![sMAG-creation-pipeline](/images/sMAG-creation-pipeline.png)

# Requirements
* [BBmap](https://sourceforge.net/projects/bbmap/)
* [metaSPAdes](http://cab.spbu.ru/software/spades/)
* [Megahit](https://github.com/voutcn/megahit/releases)
* [BWA](http://bio-bwa.sourceforge.net/)
* [sambamba](http://lomereiter.github.io/sambamba/)
* [metaBAT2](https://bitbucket.org/berkeleylab/metabat)
* [CheckM](https://ecogenomics.github.io/CheckM/)
* [dRep](https://github.com/MrOlm/drep/)

Install tools via bioconda:

	conda install bbmap spades megahit bwa sambamba metabat2
	# built own environment for CheckM, please download database after the installation
	conda create -n checkm checkm-genome
	# built own environment for dRep
	conda create -n drep drep


# Assembly

We use metaSPAdes in default mode to create sample-wise assembly:

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	spades.py --meta -t 32 \
	--pe1-1 ${Fastq_R1} \
	--pe1-2 ${Fastq_R2} \
	-o Assembly-${SampleName}

# Preparation

We use bbmap and bwa to create bam-file for binning:

**1. Removal for short contigs bbmap-tools**

    cd Assembly-${SampleName}
	reformat.sh -Xmx20g threads=32 in=contigs.fasta out=contigs-1500bp.fasta fastaminlen=1500

**2. Index contings**

	bwa index contigs-1500bp.fasta

**3. Mapping the reads, pipe to sorted bam-file**
	
	bwa mem -t 32 contigs-1500bp.fasta ${Fastq_R1} ${Fastq_R2} | \
	sambamba view -t 8 -S -f bam /dev/stdin | \
	sambamba sort -t 16 -m 120G -o ${SampleName}.bam /dev/stdin

# Binning

	runMetaBat.sh -t 32  contigs-1500bp.fasta ${SampleName}.bam

# CheckM

	# activate CheckM environment
	conda activate checkm
	checkm lineage_wf -f checkM-SCG-single.txt \
	-t 32 --pplacer_threads 10 -x fa . \
	./checkM-out-single

# Dereplication

Create first a checkM-data.txt including all CheckM information of all MAGs you want to cluster:

	genome,completeness,contamination,strain_heterogeneity
	iMGMC-100.fa,97.07,1.27,1.27
	iMGMC-1000.fa,58.9,0.67,0.67
	iMGMC-1001.fa,79.84,0.23,0.23
	[...]

Run dRep with different settings using all mMAGs (comp >= 50, con < 10) located in the folder "all5010"

	# activate dRep environment
	# run for mMAGs
	conda activate dRep
	dRep dereplicate drep-outout-SkipSecondary-ANI95-c50c10 \
	--genomeInfo checkM-data.txt \
	-comp 50 -con 10 \
	--P_ani 0.95 --SkipSecondary -p 32 \
	-g all5010/*.fa


	# run for hqMAGs
	conda activate dRep
	dRep dereplicate drep-outout-SkipSecondary-ANI95-c50c10 \
	--genomeInfo checkM-data.txt \
	-comp 90 -con 5 \
	--P_ani 0.95 --SkipSecondary -p 32 \
	-g all5010/*.fa


	# default run without secondary clustering
	# Minumum genome completeness (default: 75)
	conda activate dRep
	dRep dereplicate drep-outout-SkipSecondary-ANI95-c50c10 \
	--genomeInfo checkM-data.txt \
	--P_ani 0.95 --SkipSecondary -p 32 \
	-g all5010/*.fa


## Pipeline to create integrated MAGs:
	
[Code for assembly, binning and 16S rRNA gene reconstruction](/creation-cataloge-pipeline.md)

## Linking of RAMBL sequences to bins:

[Code for linking 16S rRNA genes to bins](/linking/README.md)
