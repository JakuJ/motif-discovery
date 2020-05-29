import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats


def plot_norm(data):
    mu = np.mean(data)
    sigma = np.std(data)
    x = np.linspace(mu - 3 * sigma, mu + 3 * sigma, 100)
    plt.plot(x, stats.norm.pdf(x, mu, sigma))


def plot_hist(data):
    plt.hist(data, bins=20, density=True)


if __name__ == "__main__":
    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]

    net = pd.read_csv("network.csv")
    net = np.array(net).T[0]

    plot_norm(randoms)
    plot_hist(randoms)

    plot_norm(net)
    plot_hist(net)

    plt.xlabel("Liczba wystąpień motywu")
    plt.ylabel("Prawdopodobieństwo wystąpienia")
    plt.legend(['Sieci podobne', 'Sieć wejściowa', 'Sieci podobne', 'Sieć wejściowa'])
    plt.show()
