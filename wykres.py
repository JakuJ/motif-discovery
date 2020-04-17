import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

if __name__ == "__main__":
    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]

    print(f"Losowe - średnia: {np.mean(randoms)}, SD: {np.std(randoms)}")

    plt.hist(randoms)
    plt.title(f"Liczebności dla {len(randoms)} grafów losowych")
    plt.show()
