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

mode="meanRandom" # albo expER
target_file="fascia_results_${mode}.csv"

echo "siec;kandydat;max_iteracji;iteracje;wynik;motyw" > "$target_file"

# Obliczenia dla sieci wejściowych
for netfilename in $(ls "$NETWORK_DIR" | grep graph); do
  echo "Network: $netfilename"

  # Zrób plik wynikowy
  netname=$(norm_name "$netfilename") # nazwa do csv
  network="$NETWORK_DIR/$netfilename" # pełna ścieżka

  # Sieci losowe
  bin/ensemble $network $NUMRANDOMS

  for tmpdir in ${TEMPLATE_DIRS[*]}; do
    for template in $(ls "motif/$tmpdir" | grep graph); do
      # Zapisz nazwę motywu
      prefix=$(norm_name "$tmpdir/$template")
      templatepath="motif/$tmpdir/$template"

      echo -n "${netname};" >> "$target_file"
      echo -n "${prefix};" >> "$target_file"

      rm -f losowe.csv
      for i in random_graphs/*; do
        echo -en "\r$i"
        bin/fascia -g "$i" -t $templatepath -i "$RANDITERS" |\
        grep -v 'Single' |\
        grep -E '[0-9]' |\
        strip >>\
        losowe.csv
      done

      # Średnia dla sieci podobnych
      echo "\nTemplate: ${templatepath}"

      NETITERS=$(python3 niter.py $network $templatepath $mode)
      echo "Max. iteracji: $NETITERS"
      echo -n "${NETITERS};" >> "$target_file"

      bin/fascia -g $network -t $templatepath -i "$NETITERS" |\
      grep --line-buffered Single |\
      stdbuf -oL sed 's/Single //g' |\
      python3 srednia_fascii.py >> "$target_file"
    done
  done
done
