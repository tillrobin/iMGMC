# Creation of the Genecatalog

## Table of Contents
[Description](#Description)
[Requirements](#Requirements)
[Data pre-processing](#Data-pre-processing)
[Assembly](#Assembly)
[Gene Calling](#Gene-Calling)
[Binning](#Binning)
[16S rRNA gene reconstruction](#RAMBL)


# Description

![iMGMC-creation-pipeline](/images/iMGMC-creation-pipeline.png)

# Requirements
* [BBmap](https://sourceforge.net/projects/bbmap/)
* [Megahit](https://github.com/voutcn/megahit/releases)
* [Metagenemark](http://exon.gatech.edu/GeneMark/meta_gmhmmp.cgi)
* [BWA](http://bio-bwa.sourceforge.net/)
* [sambamba](http://lomereiter.github.io/sambamba/)
* [metaBAT](https://bitbucket.org/berkeleylab/metabat)
* [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
* [RAMBL](https://github.com/homopolymer/RAMBL)

# Data-pre-processing

**1. Demultiplexing and adaptor removing**

All reads were processed with Ilumina bcl2fastq Conversion

**2. Quality check of the reads**

Very low quality should be trimmed. However we only use HiSeq sequencing reads and do not preform quality trimming or any kind of error correction.

**3. Removel of contaminated host**

We use bbmap the mouse reference genom from [Ensembl](http://www.ensembl.org/Mus_musculus/Info/Index).

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	bbmap.sh -Xmx50g usejni=t unpigz=t threads=10 fast=t \
    minratio=0.9 maxindel=3 bwr=0.16 bw=12 fast minhits=2 qtrim=r trimq=10 untrim idtag printunmappedcount kfilter=25 maxsites=1 k=14 \
    in=${Fastq_R1} \
    in2=${Fastq_R2} \
    ref=Mus_musculus.GRCm38.75.dna_rm.toplevel.fa.gz \
    statsfile=${SampleName}_rmhost_filtering.stats \
    outu=${SampleName}_R1_rmhost.fastq.gz \
    outu2=${SampleName}_R2_rmhost.fastq.gz


# Assembly

All reads were used for an all-in-one assembly with Megahit on a SGI UV-2000

    /vol/cluster-data/trlesker/megahit_v1.1.1/megahit \
    --k-list 21,27,33,37,43,55,63,77,83,99 \
    --min-count 5 \
    --num-cpu-threads 256 \
    --out-dir Megahit-${SampleName} \
    -1 ${SampleName1}_R1_rmhost.fastq.gz \
    -2 ${SampleName1}_R2_rmhost.fastq.gz \
	-1 ${SampleName2}_R1_rmhost.fastq.gz \
    -2 ${SampleName2}_R2_rmhost.fastq.gz \
    [ ... ]
	-1 ${SampleName298}_R1_rmhost.fastq.gz \
    -2 ${SampleName298}_R2_rmhost.fastq.gz


# Gene-Calling

**1. Sorting and removel for short contigs bbmap-tools**

    dedupe.sh sort=d in=${MegaHIT-contigs} out=stdout.fasta minscaf=1000 | \
	rename.sh in=stdin.fasta out=MegaHIT-sort-rename_contigs.fasta prefix="contig"

**2. Gene calling with MetaGeneMark**

	MetaGeneMark_linux_64/mgm/gmhmmp -r \
	-m MetaGeneMark_v1.mod \
	-D MegaHIT-sort-rename_contigs_ORFs.ffn \
	MegaHIT-sort-rename_contigs.fasta

**3. Remove sort ORFs**
	
	dedupe.sh sort=d minscaf=100 \
	in=MegaHIT-sort-rename_contigs_ORFs.ffn \
	out=MegaHIT-sort-rename_contigs_ORFs_filtered.ffn
	
# Binning

**1. Create index for BWA mapping**

	bwa index MegaHIT-sort-rename_contigs.fasta

**2. BWA mapping of all libraries to Contigs**

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	bwa mem -t 12 MegaHIT-sort-rename_contigs.fasta ${Fastq_R1} ${Fastq_R2} > ${SampleName}.sam

**3. Covert sam to ordered bam file**

	# each Sample ${SampleName}.sam
	sambamba view -t 12 -S -f bam ${SampleName}.sam | sambamba sort -t 12 -m 60G -o ${SampleName}.bam

**4. Calculating abundance table with MetaBAT from all bam-files located in folder ${BamDir}**

	jgi_summarize_bam_contig_depths \
	--outputDepth depth.txt \
	--pairedContigs paired.txt \
	--minContigLength 1000 \
	--minContigDepth 2 \
	${BamDir}/*.bam

**5. Run MetaBAT**

	metabat --keep -t 30 \
	--minClsSize 200000 \
	--verysensitive \
	-B 100 \
	-p paired.txt \
	-i MegaHIT-sort-rename_contigs.fasta \
	-a depth.txt  \
	-o MetaBAT-binning

# RAMBL

We use RAMBL for 16S rRNA gene reconstruction from all libraries in an all-in-one approach.

**1. Bowtie2 mapping of all libraries to GG index**

Please see RAMBL instruction for details.

	# for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	bowtie2 -p 12 --local --very-sensitive-local -x 99_otus -1 ${Fastq_R1} -2 ${Fastq_R2} -S ${SampleName}.sam

**2. Covert sam to ordered bam file**

	# each Sample ${SampleName}.sam
	sambamba view  -F "not unmapped" -t 12 -S -f bam ${SampleName}.sam | sambamba sort -t 12 -m 60G -o ${SampleName}.bam

**3. Create bam file list and metadata file for RAMBL**

Please see RAMBL instruction for details.

	#bams.fofn:
	${SampleName1}.bam
	${SampleName2}.bam
	[...]
	${SampleName298}.bam
	
	#data_info.txt:
	BamFiles=bams.fofn
	GeneSeq=/RAMBL/99_otus.fasta
	GeneTax=/RAMBL/99_otu_taxonomy.txt
	GeneTree=/RAMBL/99_otus_unannotated.tree
	GeneIndex=/RAMBL/99_otus.fasta.fai
	GeneAlign=/RAMBL/99_otus_aligned.fasta

**4. Run RAMBL**

	rambl.py -R -c 30 -v data_info.txt


