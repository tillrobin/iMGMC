# iMGMC - integrated Mouse Gut Metagenomic Catalog

![logo](/images/logo.png)

## Description

*Creation of an new mouse gut gene catalog with special features:*
  - more diverse samples from different studies (12 Vendors incl. wild mice and various gut locations)
  - clustering-free approach: all-in-one assembly, keeping track of each ORF to contigs to bins
  - higher taxonomic resolution and more accuracy by using contigs for annotation
  - 16S rRNA gene integration via linkage to bins

Please cite our paper:

**An integrated metagenome catalog enables novel insights into the murine gut microbiome**  
Till R. Lesker, Abilash C. Durairaj, Eric. J.C. Gálvez,  John Baines, Thomas Clavel, Alexander Sczyrba, Alice C. McHardy, Till Strowig http://biorxiv.org/cgi/content/short/528737v1

### External studies providing data:
Xiao, Liang, et al. "A catalog of the mouse gut metagenome." Nature biotechnology 33.10 (2015): 1103-1108. http://doi.org/10.1038/nbt.3353

Wang, Jun, et al. "Dietary history contributes to enterotype-like clustering and functional metagenomic content in the intestinal microbiome of wild mice." Proceedings of the National Academy of Sciences 111.26 (2014): E2703-E2710. http://doi.org/10.1073/pnas.1402342111

Lagkouvardos, Ilias, et al. "The Mouse Intestinal Bacterial Collection (miBC) provides host-specific insight into cultured diversity and functional potential of the gut microbiota." Nature microbiology 1 (2016): 16131. http://doi.org/10.1038/nmicrobiol.2016.131


## Data:

| Description | Size | Link |
|--|--|--|
| Catalog ORF sequences | 1GB | [iMGMC-GeneID.fasta.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133644&authkey=AD4pwU2r1mk4FHU) |
| Full assembly contigs | 1.3GB | [iMGMC-ConitgID.fasta.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133647&authkey=AIM3mw3FbPE6b_M) |
| Mapping File (GeneID->ContigID->BinID) | 30MB | [iMGMC-map-Gene-Contig-Bin.tab.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133646&authkey=AJM_z8-oLOlOO58) |
| Taxonomic anotations | 40MB | [iMGMC_map_taxonomy.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133736&authkey=AOjPxI-kDPJEpc8) |
| Functional anotations | 36MB | [iMGMC_map_functionality.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133738&authkey=APk09LufvLmUJN8) |
| 16S rRNA sequences | 2MB | [iMGMC-16SrRNAgenes.fasta](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133739&authkey=AAsGBvRCokrqALg) |

## Pipelines:

![pipeline](/images/pipeline.png)

We recommend the use of [Bioconda](http://bioconda.github.io/)

### Genecatalog

[Instruction to process your own WGS samples with iMGMC](/genecatalog-pipeline.md)

### PICRUSt (mouse gut specific)

[Instruction to process your own samples 16S rRNA amplicon samples with PICRUSt and iMGMC](/PICRUSt/README.md)

### IMNGS (resource of processed 16S rRNA microbial profiles)

[Instruction to work with iMGMC-IMNGS data](/IMNGS.md)

### Workflows to create the iMGMC Catalog

[Code for assembly, binning and 16S rRNA gene reconstruction](/creation-cataloge-pipeline.md)

[Code for linking 16S rRNA genes to bins](/linking/README.md)

