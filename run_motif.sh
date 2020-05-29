#!/bin/bash

set -e

NETWORK="sieci/filmweb5k.graph"
TEMPLATE="motif/graphs_n6_6/1.graph" # motyw

NUMRANDOMS=100
RANDITERS=10

# Czyszczenie plików
rm -f losowe.csv
rm -f network.csv

# Generowanie losowych
bin/ensemble $NETWORK $NUMRANDOMS

echo "Liczenie dla losowych grafow"

strip() {
  sed -E 's/^[^0-9\.e\+]*//g'
}

for i in random_graphs/*; do
    echo -en "\r$i"
    bin/fascia -g "$i" -t $TEMPLATE -i "$RANDITERS" |\
    grep -v 'Single' |\
    grep -E '[0-9]' |\
    strip >>\
    losowe.csv
done

echo -e "\nLiczenie dla sieci"

NETITERS=$(python3 niter.py $NETWORK $TEMPLATE "expER")
echo "Max. iteracji: $NETITERS"

bin/fascia -g $NETWORK -t $TEMPLATE -i "$NETITERS" |\
grep --line-buffered Single |\
stdbuf -oL sed 's/Single //g' |\
python3 script.py >>\
network.csv

python3 wykres.py
