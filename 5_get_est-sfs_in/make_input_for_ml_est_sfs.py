"""
Make an input file for Peter's program. Needs a VCF file for the polymorphism
data and (indexed) fasta files for the outgroups.

NOTE THAT THIS VERSION PRINTS SNP LINES WITH MSSING OUTGROUP DATA, BUT NOT FIXED
WITH MISSING OUTGROUP DATA - BECAUSE OF THE LIMITATIONS OF EST-SFS
"""

import argparse, csv, gzip, copy, sys, glob
from pysam import VariantFile
from pyfaidx import Fasta

# command line arguments
parser = argparse.ArgumentParser(description="""make an input file for peter's ml program for estimating
                                                the unfolded sfs""")

parser.add_argument('vcf_file', help='the VCF file with SNP calls in it')
parser.add_argument('fasta_file_1', help='the fasta file for the first outgroup - it should have an associated .fai index file')
parser.add_argument('fasta_file_2', help='the fasta file for the second outgroup - it should have an associated .fai index file')
parser.add_argument("--output_positions",
					action="store_true",
					required=False,
					help="If invoked then also output a file with a list of the positions")
parser.add_argument("--output_relative_SNP_positions",
					action="store_true",
					required=False,
					help="If invoked then also output a file with a list of the SNP positions RELATIVE TO THE FILE")

args = parser.parse_args()

# get at the fasta files:
fasta1 = Fasta(args.fasta_file_1)
fasta2 = Fasta(args.fasta_file_2)
# get at the VCF file:
vcf = VariantFile(args.vcf_file)

# This is the format of the input file for ml-est-sfs:
"""
3,0,0,17    0,0,0,1 0,0,0,1 0,0,1,0
"""
# where the order of alleles is A, C, G, T, columns are white-space separated (!?),
# the first column is the ingroup data, and the following columns are the outgroup data.
# currently, there can be up to 3 outgroups. Use 2 for the purposes of this?
# Here's a dict to look up the correct index for ATGC in length-4 numeric list:
nuc_idx_dict = {'A': 0, 'C': 1, 'G': 2, 'T': 3}
# (use this below)

# get the number of samples from the VCF file
# NB will need to do thsi different for sex chromosomes
nSam = len(list(vcf.header.samples))

# need to define the chromosome for looking up the fasta file:
chrom = args.vcf_file.split('/')[-1].split('.')[0]

# initiate a list of positions:
if args.output_positions:
    positions = []
    filename_pos = chrom + '.pos'

# # and for where the SNPs are
if args.output_relative_SNP_positions:
    rel_SNP_positions = []
    filename_SNP_pos = chrom + '.relative.SNP.pos'
    # and initiate a counter for this:
    SNP_counter = 1


filename_mlsfs_input = chrom + '.' + args.vcf_file.split('/')[-1].split('.')[1] + '.est-sfs_in.txt'

# open the ml-est-sfs infiles for writing to
with open(filename_mlsfs_input, 'w') as f_out:
    for record in vcf.fetch():
        SNP=False
        # maybe ignore sites with missing data?
        if not 'AN' in record.info:
            # print('no AN in record.info: ' + str(record.pos))
            continue
        if record.info['AN'] != (nSam * 2):
            # print('record.info[AN] !- nSam * 2: ' + str(record.pos))
            continue
        # ignore sites that have more than two alleles
        if len(record.alleles) > 2:
            # print('more than two alleles at site: ' + str(record.pos))
            continue
        # ignore MNPS and indels
        if len(record.ref) > 1:
            # print('MNP or indel at site: ' + str(record.pos))
            continue

        # also apply the filters we use for polymorphism (NB add these in on the command line?)
        if record.qual < 30.0:
            # print('record.qual < 30 at site: ' + str(record.pos))
            continue
        if record.info["DP"] > 1236:
            # print('record.DP > 744 at site: ' + str(record.pos))
            continue

        # if there's not SNP:
        if not record.alts:
            ref = record.ref
            if not ref in nuc_idx_dict:
                continue
            poly_col = ['0'] * 4
            poly_col[nuc_idx_dict[ref]] = str(nSam * 2)

        else:
            SNP=True
            # skip sites that differ signficantly from HWE:
            if not 'ExcessHet' in record.info:
                # print('ExcessHet not defined at site: ' + str(record.pos))
                continue
            if record.info['ExcessHet'] > 13:
                # print('ExcessHet > 13 at site: ' + str(record.pos))
                continue

            ref = record.ref
            alt = record.alts[0]
            # ignore indels
            if len(alt) > 1:
                # print('indel at site: ' + str(record.pos))
                continue

            # make an empty list for the genotypes
            l = []
            # for every sample, add the GT tuple to the empty list:
            for sample in record.samples:
                l.append(record.samples[sample]['GT'])

            # then flatten the list:
            GTs = [i for sub in l for i in sub]

            # now count the 0s and 1s.
            refcount = len([i for i in GTs if i == 0])
            altcount = len([i for i in GTs if i == 1])

            # initiate a list that will be the polymorphism column in the input file
            poly_col = ['0'] * 4
            poly_col[nuc_idx_dict[ref]] = str(refcount)
            poly_col[nuc_idx_dict[alt]] = str(altcount)


        out1 = fasta1[chrom][record.pos - 1].seq.upper()
        out2 = fasta2[chrom][record.pos - 1].seq.upper()

        out1_col = ['0'] * 4
        out2_col = ['0'] * 4

        # if there's missing data we can just leave the list as [0, 0, 0, 0]
        if out1 in nuc_idx_dict:
            out1_col[nuc_idx_dict[out1]] = '1'
        if out2 in nuc_idx_dict:
            out2_col[nuc_idx_dict[out2]] = '1'

        # add the SNP position to the list, to print to file
        if args.output_relative_SNP_positions:
            SNP_counter+=1
            if SNP == True:
                rel_SNP_positions.append(str(SNP_counter - 1))


        # NB for now im only printing lines with full outgroup data - because peter's program can't
        # currently handle the amount of missing data for a whole chromosome.
        if out1 in nuc_idx_dict and out2 in nuc_idx_dict:
            f_out.write(','.join(poly_col) + '\t' + ','.join(out1_col) + '\t' + ','.join(out2_col) + '\n')

            # add the position to the list, to print to file
            if args.output_positions:
                positions.append(str(record.pos))

f_out.close()

if args.output_positions:
    with open(filename_pos, 'wt') as f_pos:
        f_pos.write('\n'.join(positions) + '\n')
f_pos.close()

if args.output_relative_SNP_positions:
    with open(filename_SNP_pos, 'wt') as f_SNP_pos:
        f_SNP_pos.write('\n'.join(rel_SNP_positions) + '\n')
f_SNP_pos.close()
