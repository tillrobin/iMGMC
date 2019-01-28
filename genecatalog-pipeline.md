# Genecatalog pipeline

**1. Quality check of your reads**

Low quality and contaminated host reads should be remove before mapping!

**2. Process your data with  iMGMC using bbmap for mapping the reads** 

Quick start:

 
    ./iMGC.sh [DNA RNA 16S] [your SampleID] [file of ReadLibrary fasta/fastq gzip] [OPTIAL second read file]
    # iMGC.sh  processing-mode SampleID file_R1 [file_R2]
	
	#example: /[PathToInstallFolder]/iMGC.sh DNA MouseMicrobiom1 /[PathToSampleFolder]/Library_R1.fastq.gz /[PathToSampleFolder]/Library_R2.fastq.gz

 
