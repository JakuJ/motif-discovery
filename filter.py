import sys
import pandas as pd
import numpy as np
from scipy import stats

if __name__ == "__main__":
    randoms = pd.read_csv("losowe.csv")
    randoms = np.array(randoms).T[0]

    obs = []
    streak = 0

    for i, line in enumerate(sys.stdin):
        result = float(line)
        obs.append(result)

        n = i + 1

        if n >= 2:
            pval = stats.ttest_ind(randoms, np.array(obs), equal_var=False).pvalue

            if pval < 0.01:
                streak += 1
            else:
                streak = 0

            if streak >= 20:
                if np.mean(randoms) < np.mean(obs):
                    print("1", end='', flush=True) # motyw
                else:
                    print("0", end='', flush=True) # nie motyw
                exit(0)

    print("2", end='', flush=True) # couldn't decide
    exit(0)
