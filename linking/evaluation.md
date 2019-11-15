# Evaluation of Linking of reconstructed 16S rRNA genes to MAGs (CAMI2 data)

## Table of Contents  
[Description](#Description)  
[Requirements](#Requirements)  
[Gold-Standard-Creation](#Gold-Standard-Creation)  
[Blast-search](#Blast-search)  
[Split-Mapping](#Split-Mapping)  
[Correlation](#Correlation)  
[Integration](#Integration)  

# Description


We evaluate the linking approach on simulated data. We use the 2nd CAMI Toy Mouse Gut Dataset (Fritz et al., 2019, PMID: 30736849) following our original pipeline. 

![linking](linking.png)

In brief we perform a pooled assembly of all 64 samples with MegaHIT, followed by a binning of contigs with metaBAT to MAGs (n=438). RAMBL was using to reconstruct 16S rRNA gene sequences (n=460). 
Gold standard (MAG -> RABL-16S-sequence) were created by mapping MAGs to reference genomes with FastANI. Reference genomes were assigned to reconstructed 16S rRNA sequences using BlastN (min ident 97% and min coverage 100bp). 
204 MAGs reaching the quality criteria (CheckM completeness -contamination <= 80%) and of 163 it was possible to assign a reconstructed 16S rRNA sequence. 
Our linking approach predicted for 103 (63.2%) MAGs the best possible reconstructed 16S rRNA gene sequence (gold standard agreement). From the remaining 60 connections, 29 were filtered out by agreement of the taxonomic classification (disagreement on family level). These connections were replace by predictions of our linking approach (RAMBL-16S to MAGs). This step map 6 additional MAGs to the correct 16S rRNA gene sequence. Resulting final correct mappings are 109 of 163 (66.9%), for 23 (14.1%) no predictions were possible, 31 (19%) are incorrect links. For 15 of these 31 links represent closely related hit to the gold standard, the remaining 16 connections (9.8%) are distinct to the gold standard.



# Requirements

* [NCBI Blast](http://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)
* [FastANI](https://github.com/ParBLiSS/FastANI)
* [GTDBTk](https://github.com/Ecogenomics/GtdbTk)
* [Sina-Silva 16S rRNA classifer] (https://www.arb-silva.de/aligner/)




#Gold-Standard-Creation

**1. Create Blast database with reconstructed 16S rRNA sequences from RAMBL**










# Blast-search

**1. Create Blast database with reconstructed 16S rRNA sequences from RAMBL**

	makeblastdb -type nucl -in RAMBL-16SrRNAsequences.fasta

**2. Run Blast for all bins ($BinFastaFile)**

	blastn \
	-query $BinFastaFile \
	-db RAMBL-16SrRNAsequences.fasta \
	-max_target_seqs 50 \
	-outfmt 6 \
	-evalue 0.000001 \
	-num_threads 20 \
	-out blastn-bins_Finals-full-nr99.50-hits-fasta.outfmt6
	

**3. Filter Blast results (min ident 97% and min coverage 100bp)**

    cat blastn-bins_Finals-full-nr99.50-hits-fasta.outfmt6 | \
    awk '$3 > 97' | awk '$4 > 100' | cut -f1,2,12 > filtered-BlastOut.tab

**4. Create Blast results matrix**

Needed Input files:
* filtered-BlastOut.tab
* list for all 16SrRNA names in text-format: "16SrRNAnames.txt"
* list for all bin names in text-format: "BinNames.txt"


Run reformat script (iMGMC/linking/reformat-blast-results.sh)

    reformat-blast-results.sh filtered-BlastOut.tab 16SrRNAnames.txt BinNames.txt
    
    #final output: "matrix-Blast.tab"

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

**3. Map all mapped reads of a bin to all 16S rRNA sequences from RAMBL**

    mkdir statsfiles-unpaired-all scafstats-statsfiles-unpaired-all \
	cov-statsfiles-unpaired-all rpkm-statsfiles-unpaired-all
	# for each bin ($BinNr) we preform:
	zcat ./splited-read-*/out_bin_${BinNr}.fastq.gz | \
	bbmap.sh local=t -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
	ref=RAMBL-16sRNAsequences.fasta nodisk \
	interleaved=false \
	statsfile=./statsfiles-unpaired-all/${BinNr}.statsfile \
	scafstats=./scafstats-statsfiles-unpaired-all/${BinNr}.scafstats \
	covstats=./cov-statsfiles-unpaired-all/${BinNr}.covstat \
	rpkm=./rpkm-statsfiles-unpaired-all/${BinNr}.rpkm \
	sortscafs=f nzo=f ambiguous=all \
	in=stdin.fastq

**3. Summarize statistics**

    # run the script in the same directory
	# it use the dir "statsfiles-unpaired-all"
    make-splitmapping-stats.sh
	
	#final output: "final-unambiguousReads.tab"

# Correlation

**1. Create 16S rRNA gene abundances over all samples**

    # for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
    bbmap.sh -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
    ref=RAMBL-16sRNAsequences.fasta nodisk \
    statsfile=16SrRNA-statsfiles/${SampleName}.statsfile \
    scafstats=16SrRNA-scafstats-statsfiles/${SampleName}.scafstats \
    covstats=16SrRNA-cov-statsfiles/${SampleName}.covstat \
    rpkm=16SrRNA-rpkm-statsfiles/${SampleName}.rpkm \
    sortscafs=f nzo=f ambiguous=all local=t \
	in=${SampleName}_R1_rmhost.fastq.gz \
	in2=${SampleName}_R2_rmhost.fastq.gz

**2. Summarize statistics and create matrix file for 16S rRNA abundances**

    # run the script in the same directory
	# it use the dir "scafstats-statsfiles"
	make-16S-mapping-stats.sh
	
	#final output: "16S-abundances.tab"

**3. Create bin abundances over all samples**

    # create conducted bin-fasta file from all bins in ${Folder-of-all-bins}
	mkdir bin-abundances
	cd bin-abundances
	for binfile in ${Folder-of-all-bins}
	do
	BinFileName=${binfile##*/}
	echo ">${BinFileName%.*}" >> bin-sequences.fasta
	fgrep -v ">" $binfile >> bin-sequences.fasta
	done
	
	# create ref for bbmap
	bbmap.sh ref=bin-sequences.fasta
	
	# for each Sample ($SampleName) with ReadR1 ($Fastq_R1) and ReadR2 ($Fastq_R2) we preform:
	bbmap.sh -Xmx30g unpigz=t threads=${usedCores} minid=0.90 \
	statsfile=bin-statsfiles/${SampleName}.statsfile \
    scafstats=bin-scafstats-statsfiles/${SampleName}.scafstats \
    covstats=bin-cov-statsfiles/${SampleName}.covstat \
    rpkm=bin-rpkm-statsfiles/${SampleName}.rpkm \
    sortscafs=f nzo=f ambiguous=all \
	in=${SampleName}_R1_rmhost.fastq.gz \
	in2=${SampleName}_R2_rmhost.fastq.gz


**4. Summarize statistics and create matrix file for bin abundances**

    # run the script in the same directory
	# it use the dir "ref-statsfiles"
    make-bin-mapping-stats.sh
	
	#final output: "bin-abundances.tab"


# Integration

**Needed files:**

* matrix-Blast.tab
* bin-abundances.tab
* 16S-abundances.tab
* final-unambiguousReads.tab
* BinMetaData.csv ("BinID"<tab>"genome size bp")

**Create bin metadata file**


    echo -e "BinID\tgenome size bp" > BinMetaData.csv
	for bin-file in ${Folder-of-all-bins}
	do
	BinFileName=${bin-file##*/}
	BinName=${BinFileName%%.*}
	fgrep -v ">" $bin-file | wc -m | sed -e "s/^/${BinName}\t/" >> BinMetaData.csv
	done


**Run Integration pipeline in R**


    Rscript workflow_management_16S_meta_int.R \
    bin-abundances.tab \
    BinMetaData.csv \
    16S-abundances.tab \
	final-unambiguousReads.tab \
    blast-matrix.txt \
    ${PWD}

