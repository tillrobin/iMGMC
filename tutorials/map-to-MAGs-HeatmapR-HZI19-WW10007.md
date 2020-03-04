# Tutorials - Compare MAGs abundances with CoverM and R heatmap

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data download](#Data-pre-processing)  
[Bioconda: Installation of CoverM and R](#Bioconda-Tool-Installation)  
[Mapping](#Mapping)  
[Reformat the mapping output](#Reformat-Mapping-Output)  
[Create Heatmap with R](#Create-Heatmap-with-R)  

# Description

In this tutorial, we will map metagenomic libraries to the iMGMC mouse MAG collection, calculate species abundances and visualize the results with a heatmap with R. We use the metagenomic data from [Rosshart, 2017](https://doi.org/10.1016/j.cell.2017.09.016) and generate a heatmap like in [Figure 4](https://www.cell.com/fulltext/S0092-8674(17)31065-6#figures)

# Requirements
* iMGMC data
* [Bioconda](https://bioconda.github.io/)
* [CoverM](https://github.com/wwood/CoverM)
* [R](https://cran.r-project.org/)


# Data-pre-processing

Reads have to be filtered for mouse host reads. Here we only want the MAG abundances and skip this step. Please see [Genecatalog-Pipeline](https://github.com/tillrobin/iMGMC/blob/master/genecatalog-pipeline.md#Data-pre-processing)

# Data-Download

We select representative mMAG even with medium Quality (comp>50, con<10) to cover full diversity.


	# download mMAG genomes and annotations
	wget -c "https://zenodo.org/record/3631711/files/iMGMC-mMAGs-dereplicated_genomes.tar.gz"
	wget -c "https://zenodo.org/record/3631711/files/MAG-annotation_CheckM_dRep_GTDB-Tk.tar.gz?download=1"
	tar -xzf iMGMC-mMAGs-dereplicated_genomes.tar.gz
	tar -xzf MAG-annotation_CheckM_dRep_GTDB-Tk.tar.gz
	
	
	# download example data
	# waring: 39 files in total 128GB data, you can download the [CoverM results files](https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/abundances-PRJNA390686.txt)
	wget -c "https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/download-list-PRJNA390686.txt"
	while read line
	do
	wget -c $line
	done < download-list-PRJNA390686.txt
	

# Bioconda-Tool-Installation

We install CoverM and Krona Plot via Bioconda. Please be sure the you install and activate Bioconda before.

	conda create -n coverm coverm
	conda create -n r-base r-base
	

# Mapping

For this tutorial, we use CoverM for mapping the reads to MAG collection.  Please see [CoverM documentation](https://github.com/wwood/CoverM) for more details. Waring this process need, around 32 GB of memory and some hours run time. Download: [CoverM-Output](https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/abundances-PRJNA390686.txt)

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
	wget https://github.com/tillrobin/iMGMC/raw/master/tutorials/data/Rscript_heatmap.R
	# run Rscript
	Rscript Rscript_heatmap.R

After running these steps, you can open the resulting pdf files and explore the microbiota. Colors dark blue: Lab-mice microbiota, light blue: reconstituted Lab-mice microbiota, dark green: Wild-mice microbiota, light green: reconstituted Wild-mice microbiota. You can see clustering for the samples into the Lab and Wild mice groups.

![heatmap-mean](/tutorials/images/headmap_abundances_mean.png)

Furthermore, you can look at specific species eg. "Helicobacter". You can see that there are no Helicobacter species in the Lab mice (blue samples). Only two of four species were transferred from the original Wild mice (dark green) to the reconstituted Wild-mice microbiota (light green).

![heatmap-mean](/tutorials/images/headmap_abundances_helicobacter.png)
