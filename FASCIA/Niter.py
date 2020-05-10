import pandas as pd
import numpy as np
import sys
import math
args = sys.argv
sigma = 0.025
assert(len(args) == 5)
def countNiter(args, sigma):
    networkName = args[1]
    templateName = args[2]
    expectedRandom = args[3]
    with open(templateName, "r") as f:
        k = int(f.readline())
    if args[4] == "meanRandom":
        expN = math.floor(sigma*int(expectedRandom))
    elif args[4] == "expER":
        with open(networkName, "r") as f:
            numVerts = int(f.readline())
            numEdges = int(f.readline())
        expN = (2*numEdges/(numVerts-1))**(k-1)
    else:
        print("Unknown variant")
        return -1
    return max(100, math.ceil((np.exp(k)*np.log(1/sigma))/(sigma**2 * expN**2)))
sys.stdout.write(str(countNiter(args, sigma)))