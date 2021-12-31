#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)<2) {
  stop("Please provide a training dataset and a number of cores to be used.", call.=FALSE)
}

#check if parallel installed
list.of.packages <- c("parallel")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#load libraries and functions
library(parallel) #3.6.0
source('igp_parallel.R')

#load training data
training_data <- readRDS('training_data_reduced.Rds')

#read-in data
#HGNC gene identifiers as columns header
#sample identifiers as rows indexe
testing_data_path <- args[1]
testing_data <- read.table(testing_data_path,sep=',',header=TRUE,row.names = 1,quote = "\"")

#filter for variables in common
testing_data_filt <- testing_data[,colnames(testing_data) %in% rownames(training_data)]

if (dim(testing_data_filt)[1]==0 | dim(testing_data_filt)[2]==0) {
  stop("Please check the format of your training dataset.", call.=FALSE)
}

#standard scaling
testing_data_filt <- scale(testing_data_filt, center=T, scale=T)

#register clusters
cl <- parallel::makeForkCluster(args[2])
clusterSetRNGStream(cl = cl, 123)
clusterExport(cl, "permuteCol")
clusterExport(cl, "IGP.clusterRepro_parallel")

#clusterRepro
rna_data_clusterRepro <- clusterRepro_parallel(training_data,t(testing_data_filt),10000,cl)
rna_data_clusterRepro$trainingDim <- dim(testing_data_filt)

stopCluster(cl)

#save output as Rds file
saveRDS(rna_data_clusterRepro,'rna_data_reduced_clusterRepro.Rds')
