# Linking of reconstructed 16S rRNA genes to bins

## Table of Contents  
[Description](#Description)  
[Requirements](#Requirements)  
[Blast-search](#Blast-search)   
[Split-Mapping](#Split-Mapping)   
[Correlation](#Correlation)   
[Integration](#Integration)  

# Description

![linking](linking.png)

# Requirements

* NCBI Blast
* bbmap
* R

# Blast-search

**1. Create Blast database with reconstructed 16S rRNA sequences from RAMBL**

	makeblastdb -type nucl -in RAMBL-16SrRNAsequences.fasta

**2. Run Blast for all bins ($BinFastaFile) **

	blastn \
	-query $BinFastaFile \
	-db RAMBL-16SrRNAsequences.fasta \
	-max_target_seqs 50 \
	-outfmt 6 \
	-evalue 0.000001 \
	-num_threads 20 \
	-out blastn-bins_Finals-full-nr99.50-hits-fasta.outfmt6
	
**3. Filter Blast results and create blast-summary-file **

* min ident 97%
* min coverage 100bp

under construction

# Split-Mapping

**1. Create BBmap index for all bins**

	bbsplit.sh ref=${Folder-of-all-bins}

**2. Run BBsplit to split each library into reads mapping to each bin**

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	mkdir splited-read-${SampleName}
	bbsplit.sh -Xmx80g usejni=t unpigz=t threads=24 minid=0.90 \
	ambiguous2=toss \
	in=${SampleName}_R1_rmhost.fastq.gz \
	in2=${SampleName}_R2_rmhost.fastq.gz \
	basename=./splited-read-${SampleName}/out_%.fastq.gz

**2. Map all mapped reads of a bin to all 16S rRNA sequences from RAMBL**

    mkdir statsfiles-unpaired-all scafstats-statsfiles-unpaired-all \
	cov-statsfiles-unpaired-all rpkm-statsfiles-unpaired-all
	# for each bin ($BinNr) we preform:
	cat ./splited-read-*/out_bin_${BinNr}.fastq.gz | \
	bbmap.sh local=t -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
	ref=RAMBL-16sRNAsequences.fasta \
	interleaved=false \
	statsfile=./statsfiles-unpaired-all/${BinNr}.statsfile \
	scafstats=./scafstats-statsfiles-unpaired-all/${BinNr}.scafstats \
	covstats=./cov-statsfiles-unpaired-all/${BinNr}.covstat \
	rpkm=./rpkm-statsfiles-unpaired-all/${BinNr}.rpkm \
	sortscafs=f nzo=f ambiguous=all \
	in=stdin.fastq

**3. Summerize statistics**

under construction

# Correlation

under construction

# Integration

under construction