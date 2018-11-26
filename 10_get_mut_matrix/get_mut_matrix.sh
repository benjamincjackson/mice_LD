EST_SFS_INPUT=$1
EST_SFS_OUTPUT=$2

CHR=`echo $EST_SFS_INPUT | rev | cut -d'/' -f1 | rev | cut -d'.' -f1`

tail -n+9 $EST_SFS_OUTPUT > ${CHR}.temp
paste $EST_SFS_INPUT ${CHR}.temp > ${CHR}.in_out.txt

python3 ~/github_repos/wild_mice/est-sfs_2_mut_mat.py ${CHR}.in_out.txt ${CHR}.mut_mat.txt 48

rm ${CHR}.in_out.txt ${CHR}.temp 




