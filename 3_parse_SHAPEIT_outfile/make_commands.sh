for FILE in `ls ../2_run_SHAPEIT_out/*haps`
do
	CHR=`echo $FILE | rev | cut -d'/' -f1 | rev | cut -d'.' -f1 | cut -d'_' -f2`
	echo "python3 ~/github_repos/wild_mice/shapeit_2_vcf.py $FILE ../2_run_SHAPEIT_out/haplotypes_${CHR}.sample ../3_parse_SHAPEIT_outfile_out/${CHR}.phased.vcf" >> commands.txt
done
