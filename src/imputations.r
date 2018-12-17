#Required packages
library(clusterGeneration)
library(mi)
library(Amelia)
library(Hmisc)
library(mice)
library(MASS)
library(missForest)
library(doParallel)
library(betareg)
library(Metrics)
registerDoParallel(4)

args = commandArgs(trailingOnly=TRUE)
features = 15
n = 15000

#Read randomly generated correlation matrix
corMat <- as.matrix(read.table(args[1]))
nearest_pd_matrix <- nearPD(corMat, corr=TRUE)
corMat <- as.matrix(nearest_pd_matrix$mat)

#Compute covariance matrix
mu <- rep(0, features)
stddev <- rep(0.2, features)
covMat <- stddev %*% t(stddev) * corMat

#Simulate datasetset
dataset <- mvrnorm(n=n, mu=mu, Sigma=covMat, empirical=TRUE)
min <- min(dataset)
max <- max(dataset)
dataset <- (dataset - min)/(max - min)

#Introduce missing values
dataset.mis10 <- prodNA(dataset, noNA=0.1)
dataset.mis25 <- prodNA(dataset, noNA=0.25)
dataset.mis50 <- prodNA(dataset, noNA=0.5)

#Write datasets created to use other imputation methods
write.table(dataset, file=args[2], sep=" ", col.names = F, row.names = F)
write.table(dataset.mis10, file=args[3], sep=" ", col.names = F, row.names = F)
write.table(dataset.mis25, file=args[4], sep=" ", col.names = F, row.names = F)
write.table(dataset.mis50, file=args[5], sep=" ", col.names = F, row.names = F)

#MICE
old = proc.time()
mice_imputation1 <- mice(dataset.mis10, m=5, method="norm")
proc.time() - old
completed1 <- complete(mice_imputation1, 5)
mae(as.matrix(completed1), dataset)
rmse(completed1, dataset)

old = proc.time()
mice_imputation2 <- mice(dataset.mis25, m=5, method="norm")
proc.time() - old
completed2 <- complete(mice_imputation2, 5)
mae(as.matrix(completed2), dataset)
rmse(completed2, dataset)

old = proc.time()
mice_imputation3 <- mice(dataset.mis50, m=5, method="norm")
proc.time() - old
completed3 <- complete(mice_imputation3, 5)
mae(as.matrix(completed3), dataset)
rmse(completed3, dataset)

#Amelia
old = proc.time()
amelia_imp1 <- amelia(dataset.mis10, m=5, parallel="multicore")
proc.time() - old
completed1 <- amelia_imp1$imputations[[5]]
mae(as.matrix(completed1), dataset)
rmse(completed1, dataset)

old = proc.time()
amelia_imp2 <- amelia(dataset.mis25, m=5, parallel="multicore")
proc.time() - old
completed2 <- amelia_imp2$imputations[[5]]
mae(as.matrix(completed2), dataset)
rmse(completed2, dataset)

old = proc.time()
amelia_imp3 <- amelia(dataset.mis50, m=5, parallel="multicore")
proc.time() - old
completed3 <- amelia_imp3$imputations[[5]]
mae(as.matrix(completed3), dataset)
rmse(completed3, dataset)

#Missforest
old = proc.time()
forest_imp1 <- missForest(dataset.mis10, maxiter=5, parallelize="variables")
proc.time() - old
completed1 <- forest_imp1$ximp
mae(as.matrix(completed1), dataset)
rmse(completed1, dataset)

old = proc.time()
forest_imp2 <- missForest(dataset.mis25, maxiter=5, parallelize="variables")
proc.time() - old
completed2 <- forest_imp2$ximp
mae(as.matrix(completed2), dataset)
rmse(completed2, dataset)

old = proc.time()
forest_imp3 <- missForest(dataset.mis50, maxiter=5, parallelize="variables")
proc.time() - old
completed3 <- forest_imp3$ximp
mae(as.matrix(completed3), dataset)
rmse(completed3, dataset)

#Hmisc
old = proc.time()
hmisc_imp1 <- aregImpute(~ V1+V2+V3+V4+V5+V6+V7+V8+V9+V10+V11+V12+V13+V14+V15, data=as.data.frame(dataset.mis10), n.impute=5)
proc.time() - old
completed1 <- as.data.frame(impute.transcan(hmisc_imp1, imputation=1, data=as.data.frame(dataset.mis10), list.out=TRUE, pr=FALSE, check=FALSE))
mae(as.matrix(completed1), dataset)
rmse(completed1, as.data.frame(dataset))

old = proc.time()
hmisc_imp2 <- aregImpute(~ V1+V2+V3+V4+V5+V6+V7+V8+V9+V10+V11+V12+V13+V14+V15, data=as.data.frame(dataset.mis25), n.impute=5)
proc.time() - old
completed2 <- as.data.frame(impute.transcan(hmisc_imp2, imputation=1, data=as.data.frame(dataset.mis25), list.out=TRUE, pr=FALSE, check=FALSE))
mae(as.matrix(completed2), dataset)
rmse(completed2, as.data.frame(dataset))

old = proc.time()
hmisc_imp3 <- aregImpute(~ V1+V2+V3+V4+V5+V6+V7+V8+V9+V10+V11+V12+V13+V14+V15, data=as.data.frame(dataset.mis50), n.impute=5)
proc.time() - old
completed3 <- as.data.frame(impute.transcan(hmisc_imp3, imputation=1, data=as.data.frame(dataset.mis50), list.out=TRUE, pr=FALSE, check=FALSE))
mae(as.matrix(completed3), dataset)
rmse(completed3, as.data.frame(dataset))