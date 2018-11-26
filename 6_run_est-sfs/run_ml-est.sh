CONFIGFILE=$1
INFILE=$2
INFILENAME=`echo $INFILE | rev | cut -d'/' -f1 | rev`
SEEDFILE=${INFILENAME}.seed
OUT_SFS=$(echo $INFILENAME | cut -d'.' -f1-2).sfs
OUT_Pvalues=$(echo $INFILENAME | cut -d'.' -f1-2).pvalues

echo $RANDOM > $SEEDFILE

~/programs/est-sfs-release-2.01/est-sfs $CONFIGFILE $INFILE $SEEDFILE $OUT_SFS $OUT_Pvalues
