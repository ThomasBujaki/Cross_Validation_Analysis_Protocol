nrep=$(grep "nrep" analysis_parameters | cut -f2 -d:)
base_name=$(grep "base_name" analysis_parameters | cut -f2 -d: | sed 's/ //g')
save_freq=$(grep "save_freq" analysis_parameters | cut -f2 -d:)
chain_length=$(grep "chain_length" analysis_parameters | cut -f2 -d:)
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
        echo "$(pwd)/../../pb -d $(pwd)/../CV_data/${base_name}${rep_num}_learn.ali -s -x ${save_freq} ${chain_length} $(eval echo "$model_string") $(pwd)/../CV_data/${save_string}${base_name}${rep_num}_learn.ali" > submit_${save_string}_${rep_num}.sh
        qsub -q $(echo "$queue_var" | sed 's/^,//g') -wd $(pwd)/../CV_data -S /bin/bash submit_${save_string}_${rep_num}.sh
    }
}
cd -
