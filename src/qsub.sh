
for seed in $(seq 100 200); do
for grid in "src/grid/clusterSmallWorld.m"; do
for gridsize in 50 100 200; do
for gridupdate in "src/gridUpdate/addUniform.m"; do
for gridupdatesize in $(( $gridsize * 2)); do
#for gridupdatesize in $(( $gridsize / 2 )) $(( $gridsize * 2)) $(( $gridsize * 4)); do
for attack in "src/attacks/spike.m"; do
for load in "src/loads/gaussian.m"; do
for obs in "src/powerObservations/Unobserved.m"; do
for kl in "src/extractKL/rank1.m"; do
#for kl in "src/extractKL/localKL.m"; do
#for kl in "src/extractKL/fullKL.m"; do
for filter in 'src/filters/ukf.m'; do
#for filter in 'src/filters/ukf0.m' 'src/filters/ukf.m'; do
    args="$seed $grid $gridsize $gridupdate $gridupdatesize $attack $load $obs $kl $filter"
    file=$(echo $args | tr ' ' '-' | tr '/' '_')
    #echo $args
    echo "cd $HOME/bigdata/powergrid; module load octave; time ./src/runsim.m $args" | qsub -o "output/out.$file" -e "output/err.$file" -l mem=32gb
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
