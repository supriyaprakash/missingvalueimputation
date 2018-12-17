#Running python scripts to build correlation matrices
python3 buildCorrelationMatrix.py 15 0 0.2 corMatrix1
python3 buildCorrelationMatrix.py 15 0.5 0.2 corMatrix2
python3 buildCorrelationMatrix.py 15 0.9 0.2 corMatrix3

#Running R scripts to generate dataset and execute imputation algorithms
Rscript --vanilla imputations.r corMatrix1 dataset1 data_missing_10_1 data_missing_25_1 data_missing_50_1
Rscript --vanilla imputations.r corMatrix2 dataset2 data_missing_10_2 data_missing_25_2 data_missing_50_2
Rscript --vanilla imputations.r corMatrix3 dataset3 data_missing_10_3 data_missing_25_3 data_missing_50_3

#Running python scripts to execute imputation algorithms for created datasets
python3 imputation.py dataset1 data_missing_10_1 data_missing_25_1 data_missing_50_1
python3 imputation.py dataset2 data_missing_10_2 data_missing_25_2 data_missing_50_2
python3 imputation.py dataset3 data_missing_10_3 data_missing_25_3 data_missing_50_3
