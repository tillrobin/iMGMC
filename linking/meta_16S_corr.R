meta_16S_corr=function(S16_data,metagenome_data,method)
{
  if(method=="pearson")
  {
    S16_mg_corr=matrix(0,nrow=nrow(S16_data),ncol=nrow(metagenome_data))
    rownames(S16_mg_corr)=rownames(S16_data)
    colnames(S16_mg_corr)=rownames(metagenome_data)
    for(i in 1:nrow(S16_data))
    {
      for(j in 1:nrow(metagenome_data))
      {
        dc=cor.test(x = S16_data[i,],y = metagenome_data[j,],method = "pearson")
        S16_mg_corr[i,j]=unname(dc$estimate)
      }
    }
    
    S16_mg_corr[which(is.na(S16_mg_corr))]=0
    # S16_mg_corr[S16_mg_corr<0]=0
    
    return(S16_mg_corr)
    
  }
  
  
  if(method=="bicorr")
  {
    S16_mg_bicorr=matrix(0,nrow=nrow(S16_data),ncol=nrow(metagenome_data))
    rownames(S16_mg_bicorr)=rownames(S16_data)
    colnames(S16_mg_bicorr)=rownames(metagenome_data)
    for(i in 1:nrow(S16_data))
    {
      for(j in 1:nrow(metagenome_data))
      {
        
        S16_mg_bicorr[i,j]=bicor(S16_data[i,],metagenome_data[j,])
      }
    }
    return(S16_mg_bicorr)
    
    
  }
  
  
  
  if(method=="spearman")
  {
    S16_mg_corr=matrix(0,nrow=nrow(S16_data),ncol=nrow(metagenome_data))
    rownames(S16_mg_corr)=rownames(S16_data)
    colnames(S16_mg_corr)=rownames(metagenome_data)
    for(i in 1:nrow(S16_data))
    {
      for(j in 1:nrow(metagenome_data))
      {
        dc=cor.test(x = S16_data[i,],y = metagenome_data[j,],method = "spearman")
        S16_mg_corr[i,j]=unname(dc$estimate)
      }
    }
    
    S16_mg_corr[which(is.na(S16_mg_corr))]=0
    # S16_mg_corr[S16_mg_corr<0]=0
    
    return(S16_mg_corr)
    
  }
  
}