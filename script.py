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
        print(result, flush=True)

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
                    print(f"Motif found on iteration {n} - p = {pval}", file=sys.stderr)
                else:
                    print(f"Candidate discarded on iteration {n} - p = {pval}", file=sys.stderr)

                exit(0)

    print(f"Couldn't decide - p = {pval}", flush=True, file=sys.stderr)
