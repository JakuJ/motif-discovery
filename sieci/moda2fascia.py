import numpy as np
import pandas as pd
import sys

if __name__ == "__main__":
    path = sys.argv[1]

    df = pd.read_csv(path, header=None, sep=r'\s+', names=['v1', 'v2'])
    df = df.drop_duplicates().astype(np.int32)

    df.sort_values(by=['v1', 'v2'], inplace=True)

    uniq = set(df['v1']).union(set(df['v2']))
    mapping = dict(zip(uniq, range(10000000)))

    verts = max(mapping.values()) + 1
    edges = len(df)

    print(f"Graph: {verts} vertices, {edges} edges")

    df['v1_norm'] = df['v1'].apply(lambda x: mapping[x])
    df['v2_norm'] = df['v2'].apply(lambda x: mapping[x])

    df.sort_values(by=['v1_norm', 'v2_norm'], inplace=True)

    with open(path[:path.find('.')] + '.graph', 'w') as f:
        print(verts, file=f)
        print(edges, file=f)
        for v1, v2 in zip(df.loc[:, 'v1_norm'], df.loc[:, 'v2_norm']):
            print(f"{v1} {v2}", file=f)
