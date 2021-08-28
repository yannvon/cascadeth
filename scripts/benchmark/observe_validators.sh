##!/usr/bin/env bash

for i in $(seq 0 $1)
do
  echo  'tail -f /home/yann/Documents/cascadeth/scripts/benchmark/datadir/geth'$i'.log'
  gnome-terminal -e  'tail -f /home/yann/Documents/cascadeth/scripts/benchmark/datadir/geth'$i'.log'
done
