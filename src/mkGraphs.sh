#!/bin/bash

params='clusterSmallWorld-10-addUniform-5-spike-gaussian-Unobserved-fullKL'
#params='clusterSmallWorld-10-addUniform-5-localSpike-gaussian-Unobserved-localKL-ukf'

for i in attackThresholds separation; do
    file="$params-$i.csv"
    rm results/$file
    for f in results/*-$file; do
        echo $f
        cat $f >> results/$file
    done
done

./src/plotcsv-fraction.m "results/$params-separation.csv"
./src/plotcsv-thresholds.m "results/$params-attackThresholds.csv"
#cat results/$file
