#!/bin/bash

# Execute from cascadeth directory
cd ~/Documents/cascadeth/scripts/benchmark/datadir

after=": { \"balance\": \"10000000000000000000000000\" },"

for dir in ./*/; do
  cd $dir
    for filename in ./keystore/*; do
      cat $filename | cut -b 12-53 |tr '\n' ' ' && echo $address$after
    done
    cd ..
done
