for FILE in /localdisk/home/bjackso4/mice_LD/Mmd/6_run_est-sfs/*pvalues
do
  CHR=`echo $FILE | rev | cut -d'/' -f1 | rev | cut -d'.' -f1`
  echo "./get_mut_matrix.sh /localdisk/home/bjackso4/mice_LD/Mmd/5_get_est-sfs_in/${CHR}.all.est-sfs_in.txt $FILE" >> commands_mut_mat.txt
done
