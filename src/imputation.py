from fancyimpute import *
from sklearn.metrics import mean_absolute_error
import numpy
import sys
import time

#Construct numpy array from file with data
def getData(filename):
    f = open(filename, "r")
    data = []
    for line in f:
        line = line.replace("\n", "")
        row = line.split(" ")
        for i in range(len(row)):
            if row[i] == "NA":
                row[i] = numpy.NaN
            else:
                row[i] = float(row[i])
        data.append(row)
    return numpy.array(data)

def computeMAE(dataset, imputed):
    dataset = numpy.array(dataset)
    imputed = numpy.array(imputed)
    mae = mean_absolute_error(dataset, imputed)
    return mae

def computeRMSE(dataset, imputed):
    dataset = numpy.array(dataset)
    imputed = numpy.array(imputed)
    rmse = numpy.sqrt(((dataset - imputed) ** 2).mean())
    return rmse

#Functions to execute imputation methods
def mice(data, incompleteData):
    s = time.time()
    filled = MICE(n_imputations=5, verbose=False).complete(incompleteData)
    e = time.time()
    t = e - s
    print("Time taken: " , t)
    print("MAE: ", computeMAE(data, filled))
    print("RMSE: ", computeRMSE(data, filled))

def matrixFactorization(data, incompleteData):
    s = time.time()
    filled = MatrixFactorization(verbose=False).complete(incompleteData)
    e = time.time()
    t = e - s
    print("Time taken: " , t)
    print("MAE: ", computeMAE(data, filled))
    print("RMSE: ", computeRMSE(data, filled))

def softImpute(data, incompleteData):
    s = time.time()
    filled = SoftImpute(verbose=False).complete(incompleteData)
    e = time.time()
    t = e - s
    print("Time taken: " , t)
    print("MAE: ", computeMAE(data, filled))
    print("RMSE: ", computeRMSE(data, filled))

def simpleFill(data, incompleteData):
    s = time.time()
    filled = SimpleFill(verbose=False).complete(incompleteData)
    e = time.time()
    t = e - s
    print("Time taken: " , t)
    print("MAE: ", computeMAE(data, filled))
    print("RMSE: ", computeRMSE(data, filled))

def iterativeSVD(data, incompleteData):
    s = time.time()
    filled = IterativeSVD(verbose=False).complete(incompleteData)
    e = time.time()
    t = e - s
    print("Time taken: " , t)
    print("MAE: ", computeMAE(data, filled))
    print("RMSE: ", computeRMSE(data, filled))

#Execute imputation methods in order
def fancyimpute(data, mis10, mis25, mis50):
    print("MICE:")
    mice(data, mis10)
    mice(data, mis25)
    mice(data, mis50)

    print("Matrix factorization:")
    matrixFactorization(data, mis10)
    matrixFactorization(data, mis25)
    matrixFactorization(data, mis50)

    print("Soft impute:")
    softImpute(data, mis10)
    softImpute(data, mis25)
    softImpute(data, mis50)

    print("Simple fill:")
    simpleFill(data, mis10)
    simpleFill(data, mis25)
    simpleFill(data, mis50)

    print("Iterative SVD:")
    iterativeSVD(data, mis10)
    iterativeSVD(data, mis25)
    iterativeSVD(data, mis50)

def main():
    args = sys.argv
    dataset = args[1]
    missing10 = args[2]
    missing25 = args[3]
    missing50 = args[4]

    data = getData(dataset)
    mis10 = getData(missing10)
    mis25 = getData(missing25)
    mis50 = getData(missing50)

    fancyimpute(data, mis10, mis25, mis50)

main()