# iMGCM - Mouse gut specific PICRUSt workflow

## Table of Contents  
[Description](#Description)  
[Requirements](#Requirements)  
[Workflow](#Workflow)   

## Description

*PICRUSt with iMGMC data*
  - data form diverse mouse samples from different studies (12 Vendors incl. wild mice and various gut locations)
  - using MAGS to 16S rRNA gene linkage

## Requirements

* PICRUSt 1.1.3
* pynast
* FastTree
* iMGMC repository (/PICRUst/iMGMC-PICRUSt.bash)

### Bioconda
Please use [Conda](https://conda.io/docs/install/quick.html)
to install needed enviroment over the [Bioconda channel](https://bioconda.github.io/):
```
conda create -n iMGMC-PICRUSt -c bioconda picrust pynast fasttree
```

## Workflow
![picrust-workflow-denovo](/PICRUSt/picrust-workflow-denovo.png)

### Needed input files
* BiomFile, your abundance table in biom format
* OTUseq, your OTU sequences in fasta format

### Pipeline

  Quick start:

    conda activate iMGMC-PICRUSt
    iMGMC-PICRUSt.bash BiomFile.biom OTUseq.fasta

Please cite our paper:

**An integrated metagenome catalog enables novel insights into the murine gut microbiome**  
Till R. Lesker, Abilash C. Durairaj, Eric. J.C. Gálvez,  John Baines, Thomas Clavel, Alexander Sczyrba, Alice C. McHardy, Till Strowig http://biorxiv.org/cgi/content/short/528737v1
