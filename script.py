import sys
import pandas as pd
import numpy as np
from scipy import stats


def t_test(sum, sum_of_squares, n, m_0):
    return (sum / n - m_0) / np.sqrt(sum_of_squares * (n) / (n - 1))


def p_value(t_stat, n):
    return stats.t.sf(np.abs(t_stat), n - 1) * 2


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
            pval = p_value(t_test(sum, sum_of_squares, n, m_0), n)
            if pval < 0.05:
                exit(0)
            print(pval, flush=True)
        n += 1
