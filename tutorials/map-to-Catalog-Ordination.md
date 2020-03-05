# Tutorials - Ordination of samples by gene and KO profiles


## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data download](#Data-pre-processing)  
[Bioconda: Installation of bbmap and R](#Bioconda-Tool-Installation)  
[Mapping](#Mapping)  
[TPM-normalization](#TPM-normalization)  
[Kegg-KO-annotations](#Kegg-KO-annotations)  
[Summary-of-statistics-for-all-samples](#Summary-of-statistics-for-all-samples)  
[Create-MNDS-Ordination-Plots-with-R](#Create-MNDS-Ordination-Plots-with-R)  

# Description

In this tutorial, we will map a metagenomic libraries to the iMGMC gene catalog, calculate gene abundances in TPM and visualize the results as an ordination plot in R. We use the metagenomic data from [Rosshart, 2017](https://doi.org/10.1016/j.cell.2017.09.016).

# Requirements
* iMGMC data
* [Bioconda](https://bioconda.github.io/)
* [bbmap](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbmap-guide/)
* [R](https://cran.r-project.org/)


# Data-pre-processing

Reads have to be filtered for mouse host reads. Please see [Genecatalog-Pipeline](https://github.com/tillrobin/iMGMC/blob/master/genecatalog-pipeline.md#Data-pre-processing)

# Data-Download

We will need the [iMGMC gene catalog](https://zenodo.org/record/3631711/files/iMGMC-GeneID.fasta.gz) and the [functionel annotations](https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz). Waring the 39 files are in total 128GB big, if you wamt can download the [bbmap-covstats-files](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133643&authkey=AGbSUUUNGTYK8dg) and skip downloading and mapping step.


	# download iMGMC gene catalog and annotations
	wget -c "https://zenodo.org/record/3631711/files/iMGMC-GeneID.fasta.gz"
	wget -c "https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz"
	gzip -d iMGMC-GeneID.fasta.gz
	tar -xzf iMGMC_map_functionality.tar.gz
	
	
	# download example data
	wget -c https://github.com/tillrobin/iMGMC/blob/master/tutorials/data/download-list-PRJNA390686.txt"
	while read line
	do
	wget -c $line
	done < download-list-PRJNA390686.txt
	

# Bioconda-Tool-Installation


We install bbmap and R via Bioconda. Please be sure the you install and activate Bioconda before.


	conda create -n iMGMCtutorial bbmap r-base r-vegan r-data.table r-ggplot

	

# Mapping


For this tutorial, we use bbmap for mapping the reads to iMGMC gene catalog.  Please see [Genecatalog-Pipeline](https://github.com/tillrobin/iMGMC/blob/master/genecatalog-pipeline.md) for more details. Waring this process need, around 32 GB of memory and some hours run time. Download the results here: [bbmap-covstats-files](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133643&authkey=AGbSUUUNGTYK8dg)


    # bioconda activate environment
	conda activate iMGMCtutorial
	
	# index the gene catalog
    bbmap.sh ref=iMGMC-GeneID.fasta
	
	# mapping samples to catalog
    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
    bbmap.sh -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
    ref=${iMGCM-data} nodisk \
    statsfile=${SampleName}.statsfile \
    covstats=${SampleName}.covstat \
    sortscafs=f nzo=f \
    in=${SampleName}_R1_rmhost.fastq.gz \
    in2=${SampleName}_R2_rmhost.fastq.gz
	
# TPM-normalization
You need to normalize you samples counts for a comparison. Here we use TPM-normalization to create ${SampleID}.TPM form ${SampleName}.covstat :

    make-GeneID-TPM-fromCovStats.sh ${SampleName}.covstat


# Kegg-KO-annotations
To add Kegg KO annotations to our "${SampleID}.TPM" file you need the mapping file [iMGMC-map-GeneID-KeggKO.tab](https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz). GeneID without a KO annotation will be obmitted. For each GeneID only one KO will be added. In addition the summary file "KOsum-${SampleID}.tab" will be generated, including summarized TPM for each KO in the sample.

    make-KO-TPM-fromTPM.sh ${SampleName}.covstat

# Summary-of-statistics-for-all-samples
The script will conduct all *.TPM and KOsum*.tab into files including SampleID and a header (long-format table). This files can be eg. imported to R. 

    sumup-TPM-KOsum-files.sh

# Create-MNDS-Ordination-Plots-with-R

    # bioconda activate environment
	conda activate iMGMCtutorial
	# download example R Script and metadata
	wget https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/Rscript_ordination.R
	wget https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/MetaDATA-PRJNA390686.txt
	# run Rscript
	Rscript Rscript_ordination.R

After running these steps, you can open the resulting pdf files and see the relationship of the microbiota samples. Colors dark blue: Lab-mice microbiota, light blue: reconstituted Lab-mice microbiota, dark green: Wild-mice microbiota, light green: reconstituted Wild-mice microbiota. You can see clustering for the samples into the Lab and Wild mice groups according to the gene abundance profiles:

![plot_ordination_genes](/tutorials/images/plot_ordination_genes.png)

Furthermore, you can look at ordination of the functional profiles of the samples:

![plot_ordination_KO](/tutorials/images/plot_ordination_KO.png)
