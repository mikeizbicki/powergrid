
for i in attackThresholds separation; do
    file="clusterSmallWorld-10-addUniform-5-spike-gaussian-Unobserved-fullKL-$i.csv"
    rm results/$file
    for f in results/*-$file; do
        echo $f
        cat $f >> results/$file
    done
done
#cat results/$file
