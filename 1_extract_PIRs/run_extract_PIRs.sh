#!/bin/bash

# run extractPIRs (program that comes with ShapeIt) for chromosome 10.
# PIR = 'phase informative read', it means a read which encompasses more than one SNP

# see https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html for info
# NOTE - the vcf file should contain only SNPs from one chromosome.

# the command & arguments should be structured like this:
# extractPIRs --bam bamlist \
#             --vcf sequence.multiple.vcf.gz \
#             --out myPIRsList

# importantly, the sample names in the first column of the bamlist file should match the sample
# names in the VCF file.

CHR=$1

/localdisk/home/bjackso4/programs/extractPIRs-v1/extractPIRs --bam bamlist_${CHR}.txt \
							     --vcf /localdisk/home/bjackso4/mice_LD/Mmd/VCF/${CHR}.recoded.vcf.gz \
							     --out /localdisk/home/bjackso4/mice_LD/Mmd/1_extract_PIRs_out/PIRs_${CHR}.txt
