#nice -n19 ~/programs/LDhelmet_v1.9/ldhelmet find_confs --num_threads 72 -w 50 -o Mmd.conf ../4_VCF_to_fasta_out/chr1.fa ../4_VCF_to_fasta_out/chr2.fa ../4_VCF_to_fasta_out/chr3.fa ../4_VCF_to_fasta_out/chr4.fa ../4_VCF_to_fasta_out/chr5.fa ../4_VCF_to_fasta_out/chr6.fa ../4_VCF_to_fasta_out/chr7.fa ../4_VCF_to_fasta_out/chr8.fa ../4_VCF_to_fasta_out/chr9.fa ../4_VCF_to_fasta_out/chr10.fa ../4_VCF_to_fasta_out/chr11.fa ../4_VCF_to_fasta_out/chr12.fa ../4_VCF_to_fasta_out/chr13.fa ../4_VCF_to_fasta_out/chr14.fa ../4_VCF_to_fasta_out/chr15.fa ../4_VCF_to_fasta_out/chr16.fa ../4_VCF_to_fasta_out/chr17.fa ../4_VCF_to_fasta_out/chr18.fa ../4_VCF_to_fasta_out/chr19.fa &> find_confs.err 
#nice -n19 ~/programs/LDhelmet_v1.9/ldhelmet table_gen --num_threads 72 -c Mmd.conf -t 0.0038 -r 0.0 0.1 10.0 1.0 100.0 -o Mmd.lk &> table_gen.err
#nice -n19 ~/programs/LDhelmet_v1.9/ldhelmet pade --num_threads 72 -c Mmd.conf -t 0.0038 -x 11 -o Mmd.pade &> pade.err

parallel -j n_jobs.txt :::: commands.txt
