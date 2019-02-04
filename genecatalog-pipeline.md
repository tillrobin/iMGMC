# Gene catalog pipeline

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data pre-processing](#Data-pre-processing)  
[Database-settings](#Database-settings)  
[Mapping](#Mapping)  
[TPM-normalization](#TPM-normalization)  
[Basic-statistics](#Basic-statistics)  

# Description

![iMGMC-pipeline](/images/pipeline.png)

# Requirements
* [BBmap](https://sourceforge.net/projects/bbmap/)
* [samtools](http://samtools.sourceforge.net/)
* [sambamba](http://lomereiter.github.io/sambamba/)
* iMGMC repository

**please export PATH of github clone to you PATH variable:**  
    git clone https://github.com/tillrobin/iMGMC)  
	PATH=${PWD}/iMGCM/scripts/:${PWD}/iMGCM/PICRUSt:${PATH  }

# Data-pre-processing

**1. Demultiplexing and adapter removing**

All reads were processed with Ilumina bcl2fastq Conversion

**2. Quality check of the reads**

Very low quality should be trimmed. Otherwise you do not need to preform quality trimming or any kind of error correction. If you want to trim you data you can just remove the "untrim" parameter in the next step. Please see [bbmap/bbduk documentation](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide) for more details.

**3. Removal of contaminated host**

You can use bbmap and the reference mouse genome from [Ensembl](http://www.ensembl.org/Mus_musculus/Info/Index).

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform
    bbmap.sh -Xmx50g usejni=t unpigz=t threads=10 fast=t \
    minratio=0.9 maxindel=3 bwr=0.16 bw=12 fast minhits=2 qtrim=r trimq=10 untrim idtag printunmappedcount kfilter=25 maxsites=1 k=14 \
    in=${Fastq_R1} \
    in2=${Fastq_R2} \
    ref=Mus_musculus.GRCm38.75.dna_rm.toplevel.fa.gz \
    statsfile=${SampleName}_rmhost_filtering.stats \
    outu=${SampleName}_R1_rmhost.fastq.gz \
    outu2=${SampleName}_R2_rmhost.fastq.gz

# Database-settings

**1. Download iMGMC data**

    download.sh

**2. Index iMGMC catalog**
    cd iMGCM-data
    bbmap.sh ref=iMGMC-GeneID.fasta.gz

**3. Export PATH for the data**
    export iMGCM-data=$PWD


# Mapping

For this tutorial we use bbmap for mapping the reads to iMGCM catalog (ORFs: iMGCM-GeneID). You can use an other mapper and process the standard output (sam-files) with bbmap to summarize the counts. Please see [bbmap documentation](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide) for more details.

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
    bbmap.sh -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
    ref=${iMGCM-data} nodisk \
    statsfile=${SampleName}.statsfile \
    scafstats=${SampleName}.scafstats \
    covstats=${SampleName}.covstat \
    rpkm=${SampleName}.rpkm \
    sortscafs=f nzo=f \
    in=${SampleName}_R1_rmhost.fastq.gz \
    in2=${SampleName}_R2_rmhost.fastq.gz


# TPM-normalization
You need to normalize you samples counts for a comparison. Here we use TPM-normalization to create TPM-${SampleID}.txt form ${SampleName}.covstat :

    makeTPMfromCovStats.sh ${SampleName}.covstat


# Basic-statistics

under construction


