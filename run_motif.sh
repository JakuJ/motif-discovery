#!/bin/bash
set -e

TEMPLATE="motif/graphs_n8_23/0.graph"
NETITERS="1000"
RANDITERS="10"

# Czyszczenie plików
if [ -e "losowe.csv" ]; then
    rm "losowe.csv"
fi

if [ -e "network.csv" ]; then
    rm "network.csv"
fi

echo "Liczenie dla sieci"

bin/fascia -g "FASCIA/hpylo.graph" -t "$TEMPLATE" -i "$NETITERS" |\
grep -E '[0-9]' |\
sed -E 's/^[^0-9\.e\+]*//g' >\
"network.csv"

echo "Liczenie dla losowych grafow"

for i in random_graphs/*; do
    echo "$i"
    bin/fascia -g "$i" -t "$TEMPLATE" -i "$RANDITERS" |\
    grep -E '[0-9]' |\
    sed -E 's/^[^0-9\.e\+]*//g' >>\
    "losowe.csv"
done

