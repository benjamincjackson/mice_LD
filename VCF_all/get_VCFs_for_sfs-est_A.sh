# make VCF files that I can use to get the input for est-sfs - need to make sure
# that all the SNPs that are in the SNP-only VCF file for SHAPEIT are in this file
# too.

FILE=$1
TEMP=${FILE##*/}
CONTIG=${TEMP%%.*}

~/programs/bcftools/bcftools filter --exclude 'type~"indel"' $FILE |\
  ~/programs/bcftools/bcftools filter --exclude 'QUAL<30' |\
  ~/programs/bcftools/bcftools filter --exclude 'AN<48' |\
  ~/programs/bcftools/bcftools filter --exclude 'DP>1236' |\
  ~/programs/bcftools/bcftools filter --exclude 'ExcessHet>13' |\
  ~/programs/bcftools/bcftools annotate --remove 'FORMAT/PL,FORMAT/PGT,FORMAT/PID' -Oz -o ${CONTIG}.all.Q30.AN16.maxDP1236.vcf.gz
~/programs/tabix ${CONTIG}.all.Q30.AN16.maxDP1236.vcf.gz

python3 ~/github_repos/wild_mice/overwrite_ref_allele_general.py ${CONTIG}.all.Q30.AN16.maxDP1236.vcf.gz $CONTIG ${CONTIG}.all.recoded.vcf
~/programs/bgzip ${CONTIG}.all.recoded.vcf
~/programs/tabix ${CONTIG}.all.recoded.vcf.gz
