#!/bin/bash
set -e

NETWORK="FASCIA/hpylo.graph"
TEMPLATE="motif/graphs_n8_23/0.graph"
NETITERS=1000
NUMRANDOMS=100
RANDITERS=10

# Czyszczenie plików
rm -f losowe.csv || true
rm -f network.csv || true

# Generowanie losowych
bin/ensemble $NETWORK $NUMRANDOMS

echo "Liczenie dla sieci"

bin/fascia -g "FASCIA/hpylo.graph" -t $TEMPLATE -i $NETITERS |\
grep -E '[0-9]' |\
sed -E 's/^[^0-9\.e\+]*//g' >\
network.csv

echo "Liczenie dla losowych grafow"

for i in random_graphs/*; do
    echo $i
    bin/fascia -g $i -t $TEMPLATE -i $RANDITERS |\
    grep -E '[0-9]' |\
    sed -E 's/^[^0-9\.e\+]*//g' >>\
    losowe.csv
done

echo "W naszej sieci: $(cat network.csv)"
echo "Uruchom 'python3 wykres.py' aby zobacyć wykres dla sieci losowych"
