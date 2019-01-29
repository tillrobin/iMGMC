# workflow_management_16S_meta_int=function(bins_file,bins_metadata_file,S16_file_name,map_unam_file,blast_mat_file,res_folder)
# {


args1 <- commandArgs()

bins_file=as.character(args1[1])
bins_metadata_file=as.character(args1[2])
S16_file_name=as.character(args1[3])
map_unam_file=as.character(args1[4])
blast_mat_file=as.character(args1[5])
res_folder=as.character(args1[6])

dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)


Sys.setenv(http_proxy="RZproxy.helmholtz-hzi.de:3128")
    packages=c("RcppArmadillo","Rcpp","RCurl","plyr","ggplot2","zoo","grid","gridExtra","XML","stringr","checkmate","base64enc","colorspace","scales","scatterplot3d","digest","stringi","utils","setInternet2")
  
  if(length(setdiff(packages,rownames(installed.packages())))>0)
  {
    install.packages(pkgs=setdiff(packages, rownames(installed.packages())), repos='http://cran.us.r-project.org')  
  }
  
  lapply(packages,require,character.only=T)

# setInternet2(TRUE) 
  
  ###### Correlation:
  message("Load and normalize the raw 16S and metaBins files:")
print(bins_file)
  bins_raw=read.csv(file = bins_file,header = T,sep = "\t",fileEncoding="latin1") #

  message("Load and normalize the  metaBins metadata files:")
print(bins_metadata_file)
  bins_metadata=read.csv(file = bins_metadata_file,header = T,sep = ";",fileEncoding="latin1")

  message("Load and normalize the raw 16S files:")
print(S16_file_name)
  S16_file=read.csv(S16_file_name,header = T,sep = "\t",fileEncoding="latin1")
  
  bins_raw_mat=bins_raw[,-1]
  rownames(bins_raw_mat)=as.character(bins_raw$X.name)
  rownames(bins_raw_mat)=str_replace_all(string = rownames(bins_raw_mat),pattern = "verysensitive-B100pB20.",replacement = "")
  bins_raw_mat=as.matrix(bins_raw_mat)
  
  bins_metadata_mat=bins_metadata[,-1]
  rownames(bins_metadata_mat)=as.character(bins_metadata$Bin.Id)
  bins_metadata_mat=as.matrix(bins_metadata_mat)
  
  S16_file_mat=S16_file[,-1]
  rownames(S16_file_mat)=as.character(S16_file$X.name)
  S16_file_mat=as.matrix(S16_file_mat)
  
  
  source("/vol/projects/MIKI/R_files/metaBin_16S_correlation_sq.R")
  
  
  setClass(Class = "signed_coeff_of_deterv2",
           representation(
             S16_meta_pr="matrix",
             S16_meta_sp="matrix",
             S16_meta_Int="matrix"
           ))
  
  
  
  S16_mg_corrInt=metaBin_16S_correlation_sq(bins_metadata_mat=bins_metadata_mat,bins_raw_mat=bins_raw_mat,S16_file_mat=S16_file_mat)
  S16_mg_corr_pr=S16_mg_corrInt@S16_meta_pr
  S16_mg_corr_sp=S16_mg_corrInt@S16_meta_sp
  S16_mg_corrInt=S16_mg_corrInt@S16_meta_Int
  
  ### Pearson and spearman individual signed coeff.of.deter:
  
  
  
  ####### unambiguous mapping:
  
  message("Load the unambiguous mapping files:")
  map_unambiguous=read.csv(file = map_unam_file,,header = T,sep = "\t",fileEncoding="latin1")
  map_unambiguous_mat=as.matrix(map_unambiguous[,-1])
  rownames(map_unambiguous_mat)=map_unambiguous[,1]
  colnames(map_unambiguous_mat)=str_replace_all(string = colnames(map_unambiguous_mat),pattern = "X",replacement = "")
  
  # unamb_map_score_norm(map_unambiguous_mat=map_unambiguous_mat)
  
  map_unambiguous_norm=apply(map_unambiguous_mat,2,function(x){x/sum(x)})
  map_unambiguous_norm[is.nan(map_unambiguous_norm)]=0
  
  map_unambiguous_norm=matrix(0,nrow=nrow(map_unambiguous_mat),ncol=ncol(map_unambiguous_mat))
  rownames(map_unambiguous_norm)=rownames(map_unambiguous_mat)
  colnames(map_unambiguous_norm)=colnames(map_unambiguous_mat)
  
  for(i in 1:ncol(map_unambiguous_mat))
  {
    if(sum(map_unambiguous_mat[,i])>10)
    {
      map_unambiguous_norm[,i]=map_unambiguous_mat[,i]/sum(map_unambiguous_mat[,i])
    } else{
      map_unambiguous_norm[,i]=0
    }
    
  }
  
  ####### BLAST:
  
  blast_mat=read.csv(file = blast_mat_file,header = T,sep = "\t",fileEncoding="latin1")
  bm=as.matrix(blast_mat[,-1])
  rownames(bm)=as.character(blast_mat$X.name)
  colnames(bm)=str_replace_all(colnames(bm),pattern = "X",replacement = "")
  bm1=bm/max(sort(apply(bm,1,sum)))
  
  
  ######### Integration:
  xxc=((1-S16_mg_corrInt)*(1-map_unambiguous_norm[rownames(S16_mg_corrInt),colnames(S16_mg_corrInt)])*(1-bm1[rownames(S16_mg_corrInt),colnames(S16_mg_corrInt)]))
  int_map_all3=1-(xxc^(1/3))
  
  int_map_allscale021v1=apply(int_map_all3,2,function(x){x/max(x)})
  int_map_allscale021v2=t(apply(int_map_all3,1,function(x){x/max(x)}))
  int_map_allscale021fin=int_map_allscale021v1*int_map_allscale021v2
  int_map_allscale021fin[is.nan(int_map_allscale021fin)]=0
  
  top_hits_all=lapply(1:ncol(int_map_allscale021fin),function(x){sort(int_map_allscale021fin[,x],decreasing = T)[1:5]})
  names(top_hits_all)=colnames(int_map_allscale021fin)
  
  top_hits_all16S=lapply(1:nrow(int_map_allscale021fin),function(x){sort(int_map_allscale021fin[x,],decreasing = T)[1:5]})
  names(top_hits_all16S)=rownames(int_map_allscale021fin)
  
  
  
  saveRDS(str_join(res_folder,"/top_hits_all_meta.rds"),top_hits_all)
  saveRDS(str_join(res_folder,"/top_hits_all_16S.rds"),top_hits_all16S)
  

pg_nm=ceiling(nrow(top_hits_all)/900)

kk=1
for(i in 1:pg_nm)
{
  sink(str_join(res_fol)) 
  top_hits_all [1:900]
  sink(res_folder,"/top_hits_metaBin_part",i,".txt")
mm=kk+(900*pg_nm)
if(mm<=nrow(top_hits_all))
{
  top_hits_all[kk:mm]

} else {
  top_hits_all[kk:length(top_hits_all)]


}
  sink()
  
 

} 

pg_nm=ceiling(nrow(top_hits_all16S)/900)

kk=1
for(i in 1:pg_nm)
{
  sink(str_join(res_fol)) 
  top_hits_all [1:900]
  sink(res_folder,"/top_hits_16S_part_",i,".txt")
mm=kk+(900*pg_nm)
if(mm<=nrow(top_hits_all16S))
{
  top_hits_all16S[kk:mm]

} else {
  top_hits_all16S[kk:length(top_hits_all16S)]


}
  sink()
  
 

} 


  
  
  
 


# source("/vol/projects/MIKI/R_files/workflow_management_16S_meta_int.R")