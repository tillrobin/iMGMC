# Gene catalog pipeline

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data pre-processing](#Data-pre-processing)  
[Database-settings](#Database-settings)  
[Mapping](#Mapping)  
[TPM-normalization](#TPM-normalization)  
[Basic-Statistics](#Basic-statistics)  

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
You need to normalize you samples counts for a comparison. Here we use TPM-normalization to create ${SampleID}.TPM form ${SampleName}.covstat :

    make-GeneID-TPM-fromCovStats.sh ${SampleName}.covstat


# Basic-statistics
To get basic statistics for samples eg. to import in other software like R you need a ${SampleName}.covstat for each sample. All scripts used below you can find [here](https://github.com/tillrobin/iMGMC/tree/master/scripts).

## Kegg-KO annotations
To add Kegg KO annotations to our "${SampleID}.TPM" file you need the mapping file [iMGMC-map-GeneID-KeggKO.tab](https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz). GeneID without a KO annotation will be obmitted. For each GeneID only one KO will be added. In addition the summary file "KOsum-${SampleID}.tab" will be generated, including summarized TPM for each KO in the sample.

    make-KO-TPM-fromTPM.sh ${SampleName}.TPM

## Summary of KO statistics for all samples
The script will conduct all "${SampleName}.TPM" and "KOsum-{SampleName}.tab" files into a table including SampleID and a header (long-format table). These files can be eg. imported to R. 

    sumup-TPM-KOsum-files.sh

See an example for an [gene and KO ordination](https://github.com/tillrobin/iMGMC/blob/master/tutorials/map-to-Catalog-Ordination.md) in the [tutorial section](https://github.com/tillrobin/iMGMC#Tutorials).

## Mapping GeneID to orginal ContigID and BinID
In this step we summarize the TPM of ORFs (GeneID) to the corresponding ContigID and BinID for each "${SampleID}.TPM" file. You need the mapping file [iMGMC-map-Gene-Contig-Bin.tab](https://zenodo.org/record/3631711/files/iMGMC-map-Gene-Contig-Bin.tab.gz). First we add the ContigID and BinID information to the "${SampleID}.TPM" -> "GeneID-ContigID-BinID-${SampleID}.tab". In addition two summary files "ContigID-sumTPM-${SampleID}.tab" and "BinID-sumTPM-${SampleID}.tab" will be generated, including summarized TPM form each sample.

    make-GeneID-ContigID-BinId-TPM-fromTPM.sh ${SampleName}.TPM

## Summary of ContigID and BinID statistics for all samples
The script will conduct all "ContigID-sumTPM-${SampleID}.tab" and "BinID-sumTPM-${SampleID}.tab" files including SampleID and a header (long-format table). These files can be eg. imported to R. 

    sumup-TPM-ContigID-BinID-files.sh
	
Results:

SampleID-ContigID-TPM.tab : Sum of gene TPM-counts for each sample for each ContigID  
SampleID-ContigID-TPM-min1.tab :  Sum of gene TPM-counts for each sample for each ContigID with a minimum of TPM>=1  
SampleID-BinID-TPM.tab : Sum of gene TPM-counts for each sample for each BinID  
SampleID-BinID-TPM-min1.tab :  Sum of gene TPM-counts for each sample for each BinID with a minimum of TPM>=1  


