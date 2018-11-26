#!/bin/bash

# using the PIRs from the previous step, in combination with the (single chromosome) VCF file
# we want to run shapeit in assemble mode. Using default options, the command should look like:

#shapeit -assemble
#	--input-vcf new_VCF.ox.vcf
#	--input-pir myPIRsList
#	-O myHaplotypes

CHR=$1

/localdisk/home/bjackso4/programs/shapeit-2.12/bin/shapeit -assemble \
					   --input-vcf /localdisk/home/bjackso4/mice_LD/Mmd/VCF/${CHR}.recoded.vcf.gz \
					   --input-pir /localdisk/home/bjackso4/mice_LD/Mmd/1_extract_PIRs_out/PIRs_${CHR}.txt \
					   -O ../2_run_SHAPEIT_out/haplotypes_${CHR} \
					   --thread 4
