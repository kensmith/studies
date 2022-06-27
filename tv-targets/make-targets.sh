#!/bin/sh

for i in $(seq 0 30)
do
  echo ./prog $i
  #mv calibration.gif $(printf "%02d" $i).gif
done | parallel -P 100% --bar
