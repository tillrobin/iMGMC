#!/usr/bin/env Rscript

# load data
my_abundances <- read.csv("abundances-PRJNA390686-withTaxonomy.txt" , header = TRUE , sep = "\t")
my_SampleMetaData <- read.csv("MetaDATA-PRJNA390686.txt" , header = TRUE , sep = "\t")

# transform to matrix
matrix_abundances <- as.matrix(my_abundances[,-1])
rownames(matrix_abundances)=my_abundances[,1]

# filter MAGs with zeros counts
matrix_abundances_no_zeros <- matrix_abundances[!rownames(matrix_abundances) %in% c("unmapped"), ]
matrix_abundances_no_zeros <- matrix_abundances_no_zeros[-(which(apply(matrix_abundances_no_zeros,1,function(x){all(x==0)})==T)),]

# filter low abundant MAGs (< 0.1%)
matrix_abundances_mean <- matrix_abundances_no_zeros[-(which(apply(matrix_abundances_no_zeros,1,function(x){mean(x)}<0.1))),]

# plot heatmap into pdf-file
pdf("headmap_abundances_mean.pdf",width = 12,height = 6,onefile=FALSE)
heatmap(matrix_abundances_mean , ColSideColors=as.vector(my_SampleMetaData$Color))
dev.off()

# selection of "Helicobacter"
matrix_abundances_Helico <- subset(matrix_abundances_no_zeros,grepl("Helicobacter",rownames(matrix_abundances_no_zeros)))

pdf("headmap_abundances_Helicobacter.pdf",width = 12,height = 6,onefile=FALSE )
heatmap(matrix_abundances_Helico , ColSideColors=as.vector(my_SampleMetaData$Color))
dev.off()

