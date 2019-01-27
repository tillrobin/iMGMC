#!/bin/bash
# use ./download.sh

echo "Download data to ./iMGMC-data"

wget -O "iMGMC-GeneID.fasta.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133644&authkey=AD4pwU2r1mk4FHU"
wget -O "iMGMC-ConitgID.fasta.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133647&authkey=AIM3mw3FbPE6b_M"
wget -O "iMGMC-map-Gene-Contig-Bin.tab.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133646&authkey=AJM_z8-oLOlOO58"
wget -O "iMGMC_map_taxonomy.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133736&authkey=AOjPxI-kDPJEpc8"
wget -O "iMGMC_map_functionality.tar.gz" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133738&authkey=APk09LufvLmUJN8"
wget -O "iMGMC-16SrRNAgenes.fasta" "https://onedrive.live.com/download?cid=36ADEB4B3D109F6F&resid=36ADEB4B3D109F6F%2133739&authkey=AAsGBvRCokrqALg"

echo "All done!"
