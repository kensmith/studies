#!/bin/sh

for i in $(seq 1 30)
do
  ./prog $i
  mv calibration.gif $(printf "%02d" $i).gif
done
