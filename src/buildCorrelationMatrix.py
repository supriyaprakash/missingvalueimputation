import numpy
import sys

def buildCorrelationMatrix(n, filename):
    corVals = int(((n * n) - n) / 2)
    normal = numpy.random.normal(0, 0.2, corVals)
    corMatrix = []
    for i in range(n):
        newRow = []
        for j in range(n):
            newRow.append(0)
        corMatrix.append(newRow)

    index = 0
    for i in range(n):
        for j in range(i + 1, n):
            corMatrix[i][j] = normal[index]
            index += 1
        for j in range(i):
            corMatrix[i][j] = corMatrix[j][i]
        corMatrix[i][i] = 1

    #Write to file   
    f = open(filename, "w")
    for row in corMatrix:
        for val in row:
            f.write(str(val) + " ")
        f.write("\n")

args = sys.argv
n = int(args[1])
fname = args[2]
buildCorrelationMatrix(n, fname)
