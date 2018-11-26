for i in {1..19}
do
  echo "python3 shapeitVCF_2_fasta.py ../3_parse_SHAPEIT_outfile_out/chr${i}.phased.vcf.gz ../4_VCF_to_fasta_out/chr${i} --output_positions" >> commands.txt
done
