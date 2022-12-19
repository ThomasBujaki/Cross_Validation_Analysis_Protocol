base_name=$(grep "base_name" analysis_parameters | cut -f2 -d: | sed 's/ //g')
nrep=$(grep "nrep" analysis_parameters | cut -f2 -d:)
burnin=$(grep "burnin" analysis_parameters | cut -f2 -d:)
readcv_check_freq=$(grep "readcv_check_freq" analysis_parameters | cut -f2 -d:)
nodes_used=$(grep "nodes_used" analysis_parameters | cut -f2 -d:)
model_params=$(grep "model:" analysis_parameters | cut -f2- -d:)

num_models=$(echo "$model_params" | wc -l)
for i in $nodes_used ; do 
    queue_var="${queue_var},all.q@compute-0-${i}.local"
done
cd submit_scripts
for (( i = 1; i <= $num_models ;  i++ )) {
    save_string=$(echo "$model_params" | head -n $i | tail -n1 | sed 's/^\t//g ; s/ //g ; s/^-//g ; s/-/_/g ; s/$.*\///g ; s/.txt//g' )
    model_string=$(echo "$model_params" | head -n $i | tail -n1)
    for (( rep_num = 0; rep_num < $nrep;  rep_num++ )) {
        echo "$(pwd)/../../readcv -rep $rep_num -x $burnin $readcv_check_freq ${save_string} ${base_name}" > submit_${save_string}_${rep_num}_readcv.sh
        qsub -q $(echo "$queue_var" | sed 's/^,//g') -wd $(pwd)/../CV_data -S /bin/bash submit_${save_string}_${rep_num}_readcv.sh
    }
}
cd -
