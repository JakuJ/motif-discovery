#!/bin/bash
set -e

NETWORK="FASCIA/hpylo.graph"
TEMPLATE="motif/graphs_n8_23/0.graph"
NUMRANDOMS=20
RANDITERS=10

strip() {
  sed -E 's/^[^0-9\.e\+]*//g'
}

# Czyszczenie plików
rm -f losowe.csv
rm -f network.csv

# Generowanie losowych
bin/ensemble $NETWORK $NUMRANDOMS

echo "Liczenie dla losowych grafow"

for i in random_graphs/*; do
    echo $i
    bin/fascia -g $i -t $TEMPLATE -i $RANDITERS |\
    grep -v 'Single' |\
    grep -E '[0-9]' |\
    strip >>\
    losowe.csv
done

echo "Liczenie dla sieci"

NETITERS=$(python3 niter.py $NETWORK $TEMPLATE "meanRandom")
echo "Max. iteracji: $NETITERS"

bin/fascia -g "FASCIA/hpylo.graph" -t $TEMPLATE -i $NETITERS |\
grep --line-buffered Single |\
stdbuf -oL sed 's/Single //g' |\
python3 script.py >>\
network.csv

echo "Uruchom 'python3 wykres.py' aby zobacyć wykres dla sieci losowych"
