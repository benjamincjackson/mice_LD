# get 1,000,000 SNP chunks of chromosome and feed them to LDhelmet,
# cos otherwise it crashes.

CHR=$1
START=$2
END=$3

awk -v awk_START=$START -v awk_END=$END 'NR>=awk_START&&NR<=awk_END' ../11_get_anc_probs/${CHR}.anc.al.probs.txt > ${CHR}_${START}-${END}.anc.al.probs.txt
awk -v awk_START=$START -v awk_END=$END 'NR>=awk_START&&NR<=awk_END' ../4_VCF_to_fasta_out/${CHR}.pos > ${CHR}_${START}-${END}.pos

for SAMPLE in `grep "^>" ../4_VCF_to_fasta_out/${CHR}.fa | cut -d">" -f2`
do
  samtools faidx ../4_VCF_to_fasta_out/${CHR}.fa ${SAMPLE}:${START}-${END} >> ${CHR}_${START}-${END}.fa
done

nice -n19 ~/programs/LDhelmet_v1.9/ldhelmet rjmcmc --num_threads 10 -l Mmd.lk -p Mmd.pade -w 50 -b 100.0 --pos_file ${CHR}_${START}-${END}.pos --snps_file ${CHR}_${START}-${END}.fa -m ../10_get_mut_matrix/${CHR}.mut_mat.txt -a ${CHR}_${START}-${END}.anc.al.probs.txt --burn_in 100000 -n 1000000 -o ${CHR}_${START}-${END}.post
nice -n19 ~/programs/LDhelmet_v1.9/ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o ${CHR}_${START}-${END}.rho.out ${CHR}_${START}-${END}.post
