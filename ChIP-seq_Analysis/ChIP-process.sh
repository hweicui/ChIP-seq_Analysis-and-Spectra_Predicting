#!/bin/bash

var1=""
var2=""
var3=""
var4=""

while getopts "t:c:g:n:" opt; do
  case $opt in
    t) var1=$OPTARG ;;
    c) var2=$OPTARG ;;
    g) var3=$OPTARG ;;
    n) var4=$OPTARG ;;
  esac
done

macs3 callpeak -t "$var1" -c "$var2" -g "$var3" -n "$var4" -B -q 0.01

read -p "further processing for generated .xls file?" choice
if [ "$choice" = "yes" ]; then
  read -p "p_max" p_max
  read -p "q_max" q_max
  read -p "fold_enrichment_min" F_min
  read -p "output bed file name" outFile
  bash xls_processor.sh "${var4}_peaks.xls" $p_max $q_max $F_min $outFile
elif [ "$choice" = "no" ]; then
  echo "done"
  ls
else
  echo "done"
  ls
fi
