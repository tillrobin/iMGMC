#!/usr/bin/env Rscript

# load data
TPM_abundances <- read.csv("SampleID-GeneID-TPM-min1.tab" , header = TRUE , sep = "\t")
KO_abundances <- read.csv("SampleID-KO-TPM.tab" , header = TRUE , sep = "\t")
MetaDATA <- read.csv("MetaDATA-PRJNA390686.txt", header = TRUE , sep = "\t")

# load libraries
library("data.table")
library("vegan")
library("ggplot2")


# gene ordination
setDT(TPM_abundances)
TPM_data_wide <- dcast.data.table(as.data.table(TPM_abundances), GeneID ~ SampleID, value.var="TPM" , fill = 0)
matrix_TPM <- as.matrix(TPM_data_wide[,-1])
TPM_MNDS <- metaMDS(t(matrix_TPM), distance = "bray")
TPM_nmds_df<-scores(TPM_MNDS,display=c("sites"))
TPM_nmds_df<-cbind.data.frame(TPM_nmds_df,
                             Microbiota=MetaDATA$Group[match(rownames(TPM_nmds_df),MetaDATA$SRA)],
                             SampleName=MetaDATA$SampleName[match(rownames(TPM_nmds_df),MetaDATA$SRA)]
                             )
plot_TPM_MNDS <- ggplot(data=TPM_nmds_df,aes(NMDS1,NMDS2,colour=Microbiota)) +
  geom_point(size=4) + theme_bw() + labs(title="Ordination by gene profiles") + geom_text(aes(label=row.names(TPM_nmds_df))) 

pdf("plot_ordination_genes.pdf",width = 8,height = 6,onefile=FALSE )
plot(plot_TPM_MNDS)
dev.off()


# KO ordination
KO_data_wide <- dcast(KO_abundances, KO  ~ SampleID, value.var="TPM" , fill = 0)
KO_data_wide
matrix_KO <- as.matrix(KO_data_wide[,-1])
KO_MNDS <- metaMDS(t(matrix_KO), distance = "bray")
KO_nmds_df<-scores(KO_MNDS,display=c("sites"))
KO_nmds_df<-cbind.data.frame(KO_nmds_df,
                             Microbiota=MetaDATA$Group[match(rownames(KO_nmds_df),MetaDATA$SRA)],
                             SampleName=MetaDATA$SampleName[match(rownames(KO_nmds_df),MetaDATA$SRA)]
                             )
plot_KO_MNDS <- ggplot(data=KO_nmds_df,aes(NMDS1,NMDS2,colour=Microbiota)) +
  geom_point(size=4)+ theme_bw() + labs(title="Ordination by KO profiles") + geom_text(aes(label=row.names(KO_nmds_df))) 

pdf("plot_ordination_KO.pdf",width = 8,height = 6,onefile=FALSE )
plot(plot_KO_MNDS)
dev.off()



