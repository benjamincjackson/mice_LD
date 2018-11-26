for FILE in ../5_get_est-sfs_in/*.all.est-sfs_in.txt
do
  CHR=`echo $FILE | rev | cut -d'/' -f1 | rev | cut -d'.' -f1`
  echo "~/github_repos/wild_mice/est-sfs_2_anc_al.sh $FILE ../6_run_est-sfs/${CHR}.all.pvalues ../5_get_est-sfs_in/${CHR}.pos" >> commands_1.txt
done

for FILE in ../5_get_est-sfs_in/*.all.est-sfs_in.txt
do
  CHR=`echo $FILE | rev | cut -d'/' -f1 | rev | cut -d'.' -f1`
  echo " python3 ~/github_repos/wild_mice/est-sfs_2_anc_al.py ../4_VCF_to_fasta_out/${CHR}.pos $CHR.est-sfs.bed.gz ../VCF/${CHR}.recoded.vcf.gz ../6_run_est-sfs/${CHR}.all.sfs $CHR ${CHR}.anc.al.probs.txt" >> commands_2.txt
done
