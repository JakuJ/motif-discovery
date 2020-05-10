import pandas as pd
import numpy as np
import sys
import math

args = sys.argv
sigma = 0.005
assert (len(args) == 4)


def countNiter(args, sigma):
    networkName = args[1]
    templateName = args[2]

    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]
    expectedRandom = np.mean(randoms)

    with open(templateName, "r") as f:
        k = int(f.readline())
    if args[3] == "meanRandom":
        expN = math.floor(sigma * int(expectedRandom))
    elif args[3] == "expER":
        with open(networkName, "r") as f:
            numVerts = int(f.readline())
            numEdges = int(f.readline())
        expN = (2 * numEdges / (numVerts - 1)) ** (k - 1)
    else:
        print("Unknown variant")
        return -1
    return max(100, math.ceil((np.exp(k) * np.log(1 / sigma)) / (sigma ** 2 * expN ** 2)))


sys.stdout.write(str(countNiter(args, sigma)))
