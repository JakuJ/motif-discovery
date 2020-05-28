#!/bin/bash

set -e

NETWORK_DIR="sieci"
TEMPLATE_DIRS=(graphs_n3_1 graphs_n4_2 graphs_n5_3 graphs_n6_6)

NUMRANDOMS=100
RANDITERS=10

strip() {
  sed -E 's/^[^0-9\.e\+]*//g'
}

norm_name () {
  tmp=$(echo "$1" | tr '.' '_' | tr '/' '_')
  echo "${tmp%_graph}"
}

# Przygotowanie
mkdir -p results
rm -f results/*

# Obliczenia
for netfilename in $(ls "$NETWORK_DIR" | grep graph); do
  # Zrób plik wynikowy
  netname=$(norm_name "$netfilename") # nazwa dla pliku
  target_file="results/${netname}.csv"

  echo "kandydat;srednia" >> "$target_file"

  # Generuj losowe sieci
  network="$NETWORK_DIR/$netfilename" # pełna ścieżka
  bin/ensemble $network $NUMRANDOMS

  for tmpdir in ${TEMPLATE_DIRS[*]}; do
    for template in $(ls "motif/$tmpdir" | grep graph); do
      # Zapisz nazwę motywu
      prefix=$(norm_name "$tmpdir/$template") # pretty name
      echo -n "$prefix;" >> "$target_file"

      # Mielenie losowych
      templatepath="motif/$tmpdir/$template"

      echo "Template: ${templatepath}"

      echo -n '' > losowe.csv
      for i in random_graphs/*; do
        echo -en "\rGraph: ${i}"

        bin/fascia -g "$i" -t $templatepath -i "$RANDITERS" |\
        grep -v 'Single' |\
        grep -E '[0-9]' |\
        strip >>\
        losowe.csv

        echo ""
      done
      python3 srednia_en_masse.py >> "$target_file"
    done
  done
done
