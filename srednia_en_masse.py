import pandas as pd
import numpy as np

if __name__ == "__main__":
    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]
    print(np.mean(randoms))
