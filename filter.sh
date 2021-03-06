#!/bin/bash

set -e

# Sprawdzenie poprawności parametrów wejściowych
if [ $# -lt 2 ]; then
  echo -e "Usage:\tfilter.sh <network file> <max. motif size> [<strat>] [<model>]"
  echo "Arguments:"
  echo -e "\tmotif size must range from 3 to 9"
  echo -e "\tstrat:\t\"positive\" or \"nonnegative\" - whether to return all templates that were
  \t\tnot discarded or just the ones that were predicted to be a motif by FASCIA."
  echo -e "\t\tDefaults to \"nonnegative\""

  echo -e "\tmodel:\t\"meanRandom\" or \"expER\" - a model for calculating max. number of iterations
  \t\tFASCIA tries before giving up."
  echo -e "\t\tDefaults to \"meanRandom\""

  echo -e "\n\tThis script emits debug info to stderr. To get a list of probable motifs redirect
  \toutput to a file like so: \"./filter.sh path/to/file.graph 6 positive > motifs.txt\""
  exit 1
fi

# Domyślna wartość dla sposobu filtrowania kandydatów
if [[ $# -ge 3 && ("$3" -eq "positive" || "$3" -eq "nonnegative") ]]; then
  FILTER="$3"
else
  FILTER="nonnegative"
fi

# Domyślna wartość dla sposobu określania max. liczby iteracji
if [[ $# -ge 4 && ("$4" -eq "meanRandom" || "$4" -eq "expER") ]]; then
  MODEL="$4"
else
  MODEL="meanRandom"
fi

>&2 echo "Filter: ${FILTER}"
>&2 echo "Model: ${MODEL}"

NETWORK="$1" # sieć wejściowa
MAXSIZE="$2" # maksymalny interesujący nas rozmiar motywu

TEMPLATE_ROOT="motif" # katalog z drzewami
NUMRANDOMS=100        # ilość generowanych sieci podobnych
RANDITERS=10          # ilość iteracji FASCII na każdej z nich

# Czyszczenie plików tymczasowych gdyby zostały
rm -f losowe.csv

# Generowanie sieci podobnych
rm -f random_graphs/*
>&2 bin/ensemble "$NETWORK" $NUMRANDOMS

# Funkcja pomocnicza
strip() {
  sed -E 's/^[^0-9\.e\+]*//g'
}

for template_dir in $(ls "$TEMPLATE_ROOT" | grep -E "graphs_n\d_" | sort -h | head -n $((MAXSIZE - 2)) ); do
  for template in $(ls "$TEMPLATE_ROOT/$template_dir" | grep graph); do
    # Pełna ścieżka do kandydata
    templatepath="$TEMPLATE_ROOT/$template_dir/$template"

    # Przeliczenie liczności w sieciach podobnych
    rm -f losowe.csv

    for i in random_graphs/*; do
        bin/fascia -g "$i" -t $templatepath -i "$RANDITERS" |\
        grep -v 'Single' |\
        grep -E '[0-9]' |\
        strip >>\
        losowe.csv
    done

    netiters=$(python3 niter.py $NETWORK $templatepath $MODEL)

    exit_code=$(bin/fascia -g "$NETWORK" -t "$templatepath" -i "$netiters" |\
    grep --line-buffered Single |\
    stdbuf -oL sed 's/Single //g' |\
    python3 filter.py)

    if [[ $exit_code -eq 1 || ($exit_code -eq 2 && $FILTER -eq "nonnegative") ]]; then
      >&2 echo "Possible motif found"
      echo "$templatepath"
    else
      >&2 echo "Motif candidate discarded"
    fi
  done
done

# Sprzątanie
rm -f losowe.csv