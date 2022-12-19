base_name=$(grep "base_name" analysis_parameters | cut -f2 -d: | sed 's/ //g')
nrep=$(grep "nrep" analysis_parameters | cut -f2 -d:)
model_params=$(grep "model:" analysis_parameters | cut -f2- -d:)

num_models=$(echo "$model_params" | wc -l)
for i in $nodes_used ; do 
    queue_var="${queue_var},all.q@compute-0-${i}.local"
done
for (( i = 1; i <= $num_models ;  i++ )) {
    save_string=$(echo "$model_params" | head -n $i | tail -n1 | sed 's/^\t//g ; s/ //g ; s/^-//g ; s/-/_/g ; s/$.*\///g ; s/.txt//g' )
    sumcv_string="${sumcv_string} ${save_string}"
}
cd CV_data
../../sumcv -nrep $nrep $sumcv_string $base_name
cd -