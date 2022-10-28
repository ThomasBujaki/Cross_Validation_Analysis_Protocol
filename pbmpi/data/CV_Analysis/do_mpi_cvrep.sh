alignment_file=$(grep "alignment_file" analysis_parameters | cut -f2 -d:)
nrep=$(grep "nrep" analysis_parameters | cut -f2 -d:)
nfold=$(grep "nfold" analysis_parameters | cut -f2 -d:)
learn_size=$(echo $(($(head -n1 $alignment_file | awk '{print $2}' ) / $nfold * ($nfold - 1))))
test_size=$(echo $(($(head -n1 $alignment_file | awk '{print $2}' ) / $nfold)))
base_name=$(grep "base_name" analysis_parameters | cut -f2 -d:)
echo "running command: ../cvrep -nrep $nrep -nfold $nfold -d $alignment_file $base_name"
../cvrep $alignment_file $learn_size $test_size $nrep  $base_name
echo "Moving the files to CV_data"
mv ${base_name}*.ali CV_data 
