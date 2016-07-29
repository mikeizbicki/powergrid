
for seed in $(seq 3); do
for grid in "src/grid/clusterSmallWorld.m"; do
for gridsize in "10"; do
for gridupdate in "src/gridUpdate/addUniform.m"; do
for gridupdatesize in "10"; do
for attack in "src/attacks/spike.m"; do
for load in "src/loads/gaussian.m"; do
for obs in "src/powerObservations/Unobserved.m"; do
for kl in "src/extractKL/fullKL.m"; do
for filter in "src/filters/ukf.m"; do
    args="$seed $grid $gridsize $gridupdate $gridupdatesize $attack $load $obs $kl $filter"
    file=$(echo $args | tr ' ' '-' | tr '/' '_')
    echo "cd powergrid; module load octave; time ./src/runsim.m $args" | qsub -o "output/$file"
    #echo 'cd powergrid; module load octave; ./src/runsim.m 0 src/grid/clusterSmallWorld.m 5 src/gridUpdate/addLaplace.m 10 src/attacks/localSpike.m src/loads/gaussian.m src/powerObservations/Unobserved.m src/extractKL/localKL.m src/filters/ukf.m' #| qsub
done
done
done
done
done
done
done
done
done
done
