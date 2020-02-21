
## Data:

### Genecatalog:

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
| representative  mMAGs (n=1296) | 1 GB | [iMGMC-mMAGs-dereplicated_genomes.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137126&authkey=ADFYgL1YRjtb-Vo) | 
| representative  hqMAGs (n=830) | 0.7 GB | [iMGMC-hqMAGs-dereplicated_genomes.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137129&authkey=AFbfuXtd4Cm9kHQ) | 
| all mMAGs (n=20,927) | 15 GB | [iMGMC-mMAGs.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137128&authkey=AFxAhkbg1uYWzhY) | 
| Annotations by CheckM, dRep-Clustering, GTDB-Tk | 2 MB | [MAG-annotation_CheckM_dRep_GTDB-Tk.tar.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137698&authkey=AL9RrHT7_3oj2vI) |
| Functional annotations (hqMAGs by eggNOG mapper v2) | 187 MB | [hqMAGs.emapper.annotations.gz](https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137699&authkey=AJXI4bt0kzwDJtw) |

### Mouse gut metagenomic libraries (Raw Data Fastq):

Accession codes of the used gut metagenome sequences:
European Nucleotide Archive: [ERP008710](https://www.ebi.ac.uk/ena/data/view/ERP008710), [ERA473426](https://www.ebi.ac.uk/ena/data/view/ERA473426), [PRJEB32890](https://www.ebi.ac.uk/ena/data/view/PRJEB32890) and to the Metagenomics Rapid Genomes/Metagenomes (MG-RAST) with ID 4661127.3/ [mgp5130](https://www.mg-rast.org/linkin.cgi?project=mgp5130)


**How to download all data**

To download all data to a GNU/Linux enviroment, please copy the code:

    # download Gene-Catalog data:
    wget -O "iMGMC-GeneID.fasta.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133644&authkey=AD4pwU2r1mk4FHU"
    wget -O "iMGMC-ConitgID.fasta.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133647&authkey=AIM3mw3FbPE6b_M"
    wget -O "iMGMC-map-Gene-Contig-Bin.tab.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133646&authkey=AJM_z8-oLOlOO58"
    wget -O "iMGMC_map_taxonomy.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133736&authkey=AOjPxI-kDPJEpc8"
    wget -O "iMGMC_map_functionality.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133738&authkey=APk09LufvLmUJN8"
    wget -O "iMGMC-16SrRNAgenes.fasta" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133739&authkey=AAsGBvRCokrqALg"
	
	# download MAG data:
	wget -O "iMGMC_MAGs.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2134225&authkey=ABA7bpleGh606kI"
	wget -O "iMGMC-mMAGs-dereplicated_genomes.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137126&authkey=ADFYgL1YRjtb-Vo"
	wget -O "iMGMC-hqMAGs-dereplicated_genomes.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137129&authkey=AFbfuXtd4Cm9kHQ"
	wget -O "iMGMC-mMAGs.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137128&authkey=AFxAhkbg1uYWzhY" 
	wget -O "MAG-annotation_CheckM_dRep_GTDB-Tk.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137698&authkey=AL9RrHT7_3oj2vI"
	wget -O "hqMAGs.emapper.annotations.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2137699&authkey=AJXI4bt0kzwDJtw"





Please open an issue if the problem cannot be solved. We will need to know how to reproduce your problem.

Acknowledgements:
TS was funded by the Helmholtz Association (VH-NG-933), by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation, STR-1343/1 and STR-1343/2) and the European Union (StG337251).
JFB was funded by the DFG under Germany`s Excellence Strategy – EXC 22167-390884018 and by the DFG Collaborative Research Center (CRC) 1182 “Origin and Function of Metaorganisms”. 
TC received funding from the DFG (project CL481/2-1 and grants within Collaborative Research Center 1382).

