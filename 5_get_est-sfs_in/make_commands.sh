for i in {1..19}
do
  echo "python3 make_input_for_ml_est_sfs.py /localdisk/home/bjackso4/mice_LD/Mmd/VCF_all/chr${i}.all.recoded.vcf.gz /localdisk/home/bjackso4/mice_reference/mm10_Mf.fa /localdisk/home/bjackso4/mice_reference/mm10_pahari_alleles.fasta --output_positions --output_relative_SNP_positions" >> commands.txt
done
