# need to run LDhelmet on chunks of chromosome, because it dies after about
# 350 windows. so pass it 1mil SNPs at a time? Need to look up chromosome lengths

# bash can only do integer arithmetic, but that's ok in this instance

for CHR in {1..19}
do
  NUMSNPS=`wc -l ../4_VCF_to_fasta_out/chr${CHR}.pos | cut -d' ' -f1`
  NUMWINDOWS=$(($NUMSNPS / 1000000 + 1))
  # echo $NUMWINDOWS

  if [ "$NUMWINDOWS" -eq 1 ]
  then
    START=1
    END=$NUMSNPS
    echo "./run_chunk.sh chr${CHR} $START $END &> chr${CHR}_${START}-${END}.err" >> commands.txt
  fi

  if [ "$NUMWINDOWS" -gt 1 ]
  then
    START=1
    END=1000001
    echo "./run_chunk.sh chr${CHR} $START $END &> chr${CHR}_${START}-${END}.err" >> commands.txt

    if [ "$NUMWINDOWS" -gt 2 ]
    then
      for i in `seq 2 $(($NUMWINDOWS - 1))`
      do
        START=$(($i * 1000000 - 1000000))
        END=$(($i * 1000000 + 1))
        echo "./run_chunk.sh chr${CHR} $START $END &> chr${CHR}_${START}-${END}.err" >> commands.txt
      done
    fi

    START=$(($NUMWINDOWS * 1000000 - 1000000))
    END=$NUMSNPS
    echo "./run_chunk.sh chr${CHR} $START $END &> chr${CHR}_${START}-${END}.err" >> commands.txt
  fi

done
