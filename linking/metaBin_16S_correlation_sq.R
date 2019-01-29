metaBin_16S_correlation_sq=function(bins_metadata_mat=bins_metadata_mat,bins_raw_mat=bins_raw_mat,S16_file_mat=S16_file_mat)
{
  
  
  bins_tpm=matrix(0,nrow=nrow(bins_metadata_mat),ncol=ncol(bins_raw_mat))
  rownames(bins_tpm)=rownames(bins_metadata_mat)
  colnames(bins_tpm)=colnames(bins_raw_mat)
  
  
  for(i in 1:ncol(bins_tpm))
  {
    Tn.X=sum(bins_raw_mat[rownames(bins_metadata_mat),i]/(as.numeric(bins_metadata_mat[,"genome.size.bp"])-100+1))
    
    bins_tpm[,i]=(((bins_raw_mat[rownames(bins_metadata_mat),i]/(as.numeric(bins_metadata_mat[,"genome.size.bp"])-100+1))/Tn.X)*1e+06)
    
  }
  #### 16S Normalization:
  
  S16_file_mat_rel=S16_file_mat
  for(i in 1:ncol(S16_file_mat))
  {
    S16_file_mat_rel[,i]=S16_file_mat_rel[,i]*1e+06/sum(S16_file_mat_rel[,i])  
  }
  
  #### correlation between 16S and metagenome bin:
  
  source("/vol/projects/MIKI/R_files/meta_16S_corr.R")
  S16_mg_corr=meta_16S_corr(S16_data = S16_file_mat_rel,metagenome_data = bins_tpm,method="pearson")
  S16_mg_corr_spearman=meta_16S_corr(S16_data = S16_file_mat_rel,metagenome_data = bins_tpm,method="spearman")
  
  S16_mg_corr_sign=matrix(1,nrow=nrow(S16_mg_corr),ncol=ncol(S16_mg_corr))
  rownames(S16_mg_corr_sign)=rownames(S16_mg_corr)
  colnames(S16_mg_corr_sign)=colnames(S16_mg_corr)
  
  for(i in 1:nrow((S16_mg_corr)))
  {
    for(j in 1:ncol(S16_mg_corr))
    {
      if(any(c(sign(S16_mg_corr[i,j]),sign(S16_mg_corr_spearman[i,j]))<0))
      {
        S16_mg_corr_sign[i,j]=-1
        
        
      }
      
    }
  }
  
  S16_mg_corrInt=(abs(S16_mg_corr)*abs(S16_mg_corr_spearman))*S16_mg_corr_sign
  return(new(Class = "signed_coeff_of_deterv2",S16_meta_Int=S16_mg_corrInt,S16_meta_pr=S16_mg_corr,S16_meta_sp=S16_mg_corr_spearman))
  
}