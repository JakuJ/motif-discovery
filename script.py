import sys
import os
import math
import pandas as pd
import numpy as np

def t_test(sum, sum_of_squares, n, m_0):
    return (sum / n - m_0) / (sum_of_squares / (n - 1)) * math.sqrt(n)

if __name__ == "__main__":
    n = 1
    sum_of_squares = 0
    sum = 0

    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]

    m_0 = np.mean(randoms)
    sd_0 = np.std(randoms)

    for line in sys.stdin:
        result = float(line)
        sum += result
        sum_of_squares += result ** 2
        if n != 1:
          print(t_test(sum, sum_of_squares, n, m_0))
        n += 1
