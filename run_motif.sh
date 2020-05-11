#!/bin/bash

set -e

NETWORK="FASCIA/hpylo.graph"
TEMPLATE="motif/graphs_n6_6/2.graph"
NUMRANDOMS=100
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
    echo -en "\r$i"
    bin/fascia -g $i -t $TEMPLATE -i $RANDITERS |\
    grep -v 'Single' |\
    grep -E '[0-9]' |\
    strip >>\
    losowe.csv
done

echo -e "\nLiczenie dla sieci"

NETITERS=$(python3 niter.py $NETWORK $TEMPLATE "meanRandom")
echo "Max. iteracji: $NETITERS"

bin/fascia -g "FASCIA/hpylo.graph" -t $TEMPLATE -i $NETITERS |\
grep --line-buffered Single |\
stdbuf -oL sed 's/Single //g' |\
python3 script.py >>\
network.csv

echo "Uruchom 'python3 wykres.py' aby zobacyć wykres dla sieci losowych"
