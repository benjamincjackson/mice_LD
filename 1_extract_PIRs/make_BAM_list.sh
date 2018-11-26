#!/bin/bash

# want to make a list of the samples, bamfiles for each sample, and chromosome for input into extractPIRs

ls -d -1 /localdisk/home/bjackso4/mice_BAM/Mmd/*bam > bam_paths.txt

for CHR in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19
do

	# The VCF sample names can be retrieved like this:
	/localdisk/home/bjackso4/programs/bcftools/bcftools query -l \
		/localdisk/home/bjackso4/mice_LD/Mmd/VCF/${CHR}.recoded.vcf.gz > samples_${CHR}.txt

	# and put the chromosome next to them
	# (this will need editing in order to use other chromosomes)
	while read p; do
		echo $CHR >> chromosome.txt
	done < bam_paths.txt

	# stick the three columns together into one file
	paste samples_${CHR}.txt bam_paths.txt chromosome.txt | column -s $'\t' -t > bamlist_${CHR}.txt

	# remove intermediate files
	rm samples_${CHR}.txt chromosome.txt

done
