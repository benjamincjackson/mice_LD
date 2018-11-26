# take the gVCFs and extract only SNPs that pass specific filters (QUAL > 30),
# RGQ > 15 in all individuals with no missing data.

FILE=$1
TEMP=${FILE##*/}
CONTIG=${TEMP%%.*}
POP=`echo $TEMP | cut -d'.' -f2-3`

#need a line

bcftools filter --include 'type="snp"' $FILE |\
  bcftools filter --exclude 'QUAL<30' |\
  bcftools filter --exclude 'AN<16' |\
  bcftools filter --exclude 'FMT/GQ<15' |\
  bcftools filter --exclude 'FMT/DP<10' |\
  bcftools filter --exclude 'DP>588' |\
  bcftools filter --exclude 'ExcessHet>13' |\
  bcftools annotate --remove 'FORMAT/PL,FORMAT/PGT,FORMAT/PID' -Oz -o ${CONTIG}.${POP}.SNPs.Q30.AN16.GQ15.DP10.FORMATtrim.g.vcf.gz
tabix ${CONTIG}.${POP}.SNPs.Q30.AN16.GQ15.DP10.FORMATtrim.g.vcf.gz

python ~/github_repos/wild_mice/overwrite_ref_allele_for_SHAPEIT.py ${CONTIG}.${POP}.SNPs.Q30.AN16.GQ15.DP10.FORMATtrim.g.vcf.gz $CONTIG ${CONTIG}.${POP}.recoded.g.vcf
bgzip ${CONTIG}.${POP}.recoded.g.vcf
tabix ${CONTIG}.${POP}.recoded.g.vcf.gz
