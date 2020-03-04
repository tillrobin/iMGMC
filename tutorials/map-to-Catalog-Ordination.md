# Tutorials - Compare MAGs abundances with CoverM and R heatmap

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data download](#Data-pre-processing)  
[Bioconda: Installation of bbmap and R](#Bioconda-Tool-Installation)  
[Mapping](#Mapping)  
[Reformat the mapping output](#Reformat-Mapping-Output)  
[Create Heatmap with R](#Create-Heatmap-with-R)  

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

We will need the [iMGMC gene catalog](https://zenodo.org/record/3631711/files/iMGMC-GeneID.fasta.gz) and the [functionel annotations](https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz)


	# download iMGMC gene catalog and annotations
	wget -c "https://zenodo.org/record/3631711/files/iMGMC-GeneID.fasta.gz"
	wget -c "https://zenodo.org/record/3631711/files/iMGMC_map_functionality.tar.gz"
	gzip -d iMGMC-GeneID.fasta.gz
	tar -xzf iMGMC_map_functionality.tar.gz
	
	
	# download example data
	# waring: 39 files are in total 128GB big, you can download the [bbmap-covstats-files](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133643&authkey=AGbSUUUNGTYK8dg)
	wget -c https://github.com/tillrobin/iMGMC/blob/master/tutorials/data/download-list-PRJNA390686.txt"
	while read line
	do
	wget -c $line
	done < download-list-PRJNA390686.txt
	

# Bioconda-Tool-Installation

We install CoverM and Krona Plot via Bioconda. Please be sure the you install and activate Bioconda before.


	conda create -n coverm coverm
	conda create -n r-base r-base
	

# Mapping

For this tutorial, we use CoverM for mapping the reads to MAG collection.  Please see [CoverM documentation](https://github.com/wwood/CoverM) for more details. Waring this process need, around 32 GB of memory and some hours run time. Download: [CoverM-Output](https://github.com/tillrobin/iMGMC/blob/master/tutorials/data/Rscript_heatmap.R)

    # bioconda activate environment
	conda activate coverm
	# run CoverM for Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2)
    coverm genome --threads 24 \
	--genome-fasta-directory dereplicated_genomes \
	--genome-fasta-extension fa \
	--coupled  SRR6032* \
	> abundances-PRJNA390686.txt

![CoverM-Plot-PRJNA390686](/tutorials/images/coverm-PRJNA390686.png)

# Reformat-Mapping-Output

This will add taxonomy to the abundance profile and reformat output for Krona plotting with MAG-name

	# add taxonomy and MAG-name
	head -n 1 abundances-PRJNA390686.txt | sed "s/_1.fastq.gz Relative Abundance (%)//g" > abundances-PRJNA390686-withTaxonomy.txt
	paste \
	<( cut -f1 abundances-PRJNA390686.txt | sed "s/^/\^/" | grep -w -f - gtdbtk.bac120.summary.tsv | cut -f1,2 | sort | awk '{print $2"-"$1}' | sed "s/.*f__/f__/" ) \
	<( tail -n+3  abundances-PRJNA390686.txt | sort | cut -f2- ) \
	>> abundances-PRJNA390686-withTaxonomy.txt

![CoverM-Plot-PRJNA390686](/tutorials/images/coverm-PRJNA390686-reformat.png)

# Create-Heatmap-with-R

    # bioconda activate environment
	conda activate r-base
	# download example R Script
	wget https://github.com/tillrobin/iMGMC/blob/master/tutorials/data/Rscript_heatmap.R
	# run Rscript
	Rscript Rscript_heatmap.R

After running these steps, you can open the resulting pdf files and explore the microbiota. Colors dark blue: Lab-mice microbiota, light blue: reconstituted Lab-mice microbiota, dark green: Wild-mice microbiota, light green: reconstituted Wild-mice microbiota. You can see clustering for the samples into the Lab and Wild mice groups.

![heatmap-mean](/tutorials/images/headmap_abundances_mean.png)

Furthermore, you can look at specific species eg. "Helicobacter". You can see that there is no Helicobacter species in the Lab mice (blue samples). Only two for four species were transferred from the original Wild mice (dark green) to the reconstituted Wild-mice microbiota (light green).

![heatmap-mean](/tutorials/images/headmap_abundances_helicobacter.png)
