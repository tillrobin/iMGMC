# Tutorials - Explore MAGs with CoverM and Krona

## Table of Contents

[Description](#Description)  
[Requirements](#Requirements)  
[Data download](#Data-pre-processing)  
[Bioconda: Installation of CoverM and Krona Plot](#Bioconda-Tool-Installation)  
[Mapping](#Mapping)  
[Reformat the mapping output](#Reformat-Mapping-Output)  
[Create Krona plot](#Create-Krona-Plot)  

# Description

In this tutorial we will map a metagenomic library to the iMGMC mouse MAG collection to get species abundances and visualize the results with a Krona plot. 

# Requirements
* iMGMC data
* [Bioconda](https://bioconda.github.io/)
* [CoverM](https://github.com/wwood/CoverM)
* [Krona Plot](https://github.com/marbl/Krona/wiki)


# Data-pre-processing


# Data-Download

We select representative mMAG even with medium Quality (comp>50, con<10) to cover full diversity.


	# download mMAG genomes and annotations
	wget -O iMGMC-mMAGs-dereplicated_genomes.tar.gz "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137126&authkey=ADFYgL1YRjtb-Vo"
	
	
	# download example data
	wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR335/000/ERR3357550/ERR3357550_1.fastq.gz
	wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR335/000/ERR3357550/ERR3357550_2.fastq.gz
	
	# set sample name
	SampleName=ERR3357550

# Bioconda-Tool-Installation

We install CoverM and Krona Plot via Bioconda. Please be sure the you install and activate Bioconda before.


	conda create -n coverm coverm
	conda create -n krona krona
	

# Mapping

For this tutorial we use CoverM for mapping the reads to MAG collection.  Please see [CoverM documentation](https://github.com/wwood/CoverM) for more details. Waring this process need around 32 GB of memory.

    # bioconda activate enviroment
	conda activate coverm
	# run CoverM for Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2)
    coverm genome --threads 24 \
	--genome-fasta-directory dereplicated_genomes \
	--genome-fasta-extension fa \
	--coupled \
	${SampleName}_1.fastq.gz \
	${SampleName}_2.fastq.gz \
	> abundances-${SampleName}.txt

![coverm](/tutorials/images/coverm.png)

# Reformat-Mapping-Output

This will add taxonomy to the abundance profile and reformat output for Krona plotting with MAG-name

    # add taxonomy and MAG-name
	paste \
	<( tail -n+3  abundances-${SampleName}.txt | sort ) \
	<( cut -f1 abundances-${SampleName}.txt | sed "s/^/\^/" | grep -w -f - gtdbtk.bac120.summary.tsv | cut -f1,2 | sort ) | \
	awk '{print $2"\t"$4"-"$1}' | tr -s ";" $"\t" > krona-input-MAGs-${SampleName}.txt

	#add unmapped reads
	grep unmapped abundances-${SampleName}.txt | cut -f2 >> krona-input-MAGs-${SampleName}.txt

![reformat-krona.png](/tutorials/images/reformat-krona.png)

# Create-Krona-Plot

    # bioconda activate enviroment
	conda activate krona
	# run Krona
	ktImportText -n MAG-mapping -o ${SampleName}.krona.html krona-input-MAGs-${SampleName}.txt

After running this steps you can open the resulting html file and explore the microbiota:

![krona-plot](/tutorials/images/krona-plot.png)



