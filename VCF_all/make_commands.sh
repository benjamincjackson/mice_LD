for CHR in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19
do
	echo "./get_VCFs_for_sfs-est_A.sh ~/mice_GATK/3_genotypeGVCFs_out/${CHR}.Mmd.g.vcf.gz $CHR" >> commands.txt
done

