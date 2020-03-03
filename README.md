# iMGMC - integrated Mouse Gut Metagenomic Catalog

![logo](/images/logo.png)

## Description

*Creation of an new mouse gut gene catalog with special features:*
  - more diverse samples from different studies (12 Vendors incl. wild mice and various gut locations)
  - clustering-free approach: all-in-one assembly, keeping track of each ORF to contigs to bins
  - higher taxonomic resolution and more accuracy by using contigs for annotation
  - 16S rRNA gene integration via linkage to bins
  - expansion by 20,927 MAGs from sample-wise assembly of 871 mouse gut metagenomic samples, representing 1,296 species
  - [Pipelines](#Pipelines) and [Tutorials](#Tutorials) to process you own data

See our paper for details.

**An integrated metagenome catalog enables new insights into the murine gut microbiome**  
Till R. Lesker, Abilash C. Durairaj, Eric. J.C. Gálvez, Ilias Lagkouvardos, John F. Baines, Thomas Clavel, Alexander Sczyrba, Alice C. McHardy, Till Strowig.
https://doi.org/10.1016/j.celrep.2020.02.036

### External studies providing data:
Xiao, Liang, et al. "A catalog of the mouse gut metagenome." Nature biotechnology 33.10 (2015): 1103-1108. http://doi.org/10.1038/nbt.3353

Wang, Jun, et al. "Dietary history contributes to enterotype-like clustering and functional metagenomic content in the intestinal microbiome of wild mice." Proceedings of the National Academy of Sciences 111.26 (2014): E2703-E2710. http://doi.org/10.1073/pnas.1402342111

Lagkouvardos, Ilias, et al. "The Mouse Intestinal Bacterial Collection (miBC) provides host-specific insight into cultured diversity and functional potential of the gut microbiota." Nature microbiology 1 (2016): 16131. http://doi.org/10.1038/nmicrobiol.2016.131


## Data:

### Genecatalog:

Please download the files by using the links in the table, use script provided here: [download all iMGMC data](/download.md) or use alternative download at [Zenodo](https://zenodo.org/record/3631711).

| Description | Size | Link |
|--|--|--|
| Catalog ORF sequences | 1 GB | [iMGMC-GeneID.fasta.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133644&authkey=AD4pwU2r1mk4FHU) |
| Full assembly contigs | 1.3 GB | [iMGMC-ConitgID.fasta.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133647&authkey=AIM3mw3FbPE6b_M) |
| Mapping File (GeneID->ContigID->BinID) | 30 MB | [iMGMC-map-Gene-Contig-Bin.tab.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133646&authkey=AJM_z8-oLOlOO58) |
| Taxonomic annotations | 40 MB | [iMGMC_map_taxonomy.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133736&authkey=AOjPxI-kDPJEpc8) |
| Functional annotations | 36 MB | [iMGMC_map_functionality.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133738&authkey=APk09LufvLmUJN8) |
| 16S rRNA sequences | 2 MB | [iMGMC-16SrRNAgenes.fasta](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133739&authkey=AAsGBvRCokrqALg) |

### Metagenome-assembled genomes (MAGs) :

| Description | Size | Link |
|--|--|--|
| integrated MAGs | 0.5 GB | [iMGMC_MAGs.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2134225&authkey=ABA7bpleGh606kI) |
| representative mMAGs (n=1296) | 1 GB | [iMGMC-mMAGs-dereplicated_genomes.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137126&authkey=ADFYgL1YRjtb-Vo) | 
| representative hqMAGs (n=830) | 0.7 GB | [iMGMC-hqMAGs-dereplicated_genomes.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137129&authkey=AFbfuXtd4Cm9kHQ) | 
| all mMAGs (n=20,927) | 15 GB | [iMGMC-mMAGs.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137128&authkey=AFxAhkbg1uYWzhY) | 
| Annotations by CheckM, dRep-Clustering, GTDB-Tk | 2 MB | [MAG-annotation_CheckM_dRep_GTDB-Tk.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137698&authkey=AL9RrHT7_3oj2vI) |
| Functional annotations (hqMAGs by eggNOG mapper v2) | 187 MB | [hqMAGs.emapper.annotations.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137699&authkey=AJXI4bt0kzwDJtw) |

For species abundance determination you can use [CoverM](https://github.com/wwood/CoverM) or our [bbmap-pipeline](/MAG-pipeline.md).

### Mouse gut metagenomic libraries (Raw Data Fastq):

Accession codes of the used gut metagenome sequences:
European Nucleotide Archive: [ERP008710](https://www.ebi.ac.uk/ena/data/view/ERP008710), [ERA473426](https://www.ebi.ac.uk/ena/data/view/ERA473426), [PRJEB32890](https://www.ebi.ac.uk/ena/data/view/PRJEB32890) and to the Metagenomics Rapid Genomes/Metagenomes (MG-RAST) with ID 4661127.3/ [mgp5130](https://www.mg-rast.org/linkin.cgi?project=mgp5130)

___

## Pipelines:

![pipeline](/images/pipeline.png)

We recommend the use of [Bioconda](http://bioconda.github.io/)

### Use of the gene catalog (mapping pipeline using the catalog or MAGs)

[Instruction to process your own WGS samples with iMGMC](/genecatalog-pipeline.md)

[Using MAGs with iMGMC/sMAGS with your own WGS samples ](/MAG-pipeline.md)

### PICRUSt (mouse gut specific)

[Instruction to process your own samples 16S rRNA amplicon samples with PICRUSt and iMGMC](/PICRUSt/README.md)

### IMNGS (resource of processed 16S rRNA microbial profiles)

[Instruction to work with iMGMC-IMNGS data](/IMNGS.md)

### Workflows to create the iMGMC Catalog

[Code for assembly, binning and 16S rRNA gene reconstruction](/creation-cataloge-pipeline.md)

[Code for linking 16S rRNA genes to bins](/linking/README.md)

### Workflows to create by sample MAGs (single wise)

[Code for the generation and clustering of single-wise assembly MAGs](/sMAG-pipeline.md)

[Code for the evaluation of single-wise assembly MAGs versus all-in-one assembly MAGs](/evaluation/README.md)

___

## Tutorials

![tutorials](/images/tutorials.png)

[Explore MAG abundances with CoverM and Krona Plot](/tutorials/map-to-MAGs-Krona-plot.md)

[Compare MAGs abundances with CoverM and R heatmap](/tutorials/map-to-MAGs-HeatmapR.md)

[Ordination of samples by gene and KO profiles](/tutorials/map-to-Catalog-Ordination.md)


___


Please open an issue if the problem cannot be solved. We will need to know how to reproduce your problem.

Acknowledgements:
TS was funded by the Helmholtz Association (VH-NG-933), by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation, STR-1343/1 and STR-1343/2) and the European Union (StG337251).
JFB was funded by the DFG under Germany`s Excellence Strategy – EXC 22167-390884018 and by the DFG Collaborative Research Center (CRC) 1182 “Origin and Function of Metaorganisms”. 
TC received funding from the DFG (project CL481/2-1 and grants within Collaborative Research Center 1382).

