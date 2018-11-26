"""
take VCF output from shapeit and write a fasta file with one entry per haplotype
(individuals chromosome)
"""

import argparse, gzip, sys, copy
from Bio.Alphabet import generic_dna
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Align import MultipleSeqAlignment
from Bio import AlignIO

parser = argparse.ArgumentParser(description="""convert a phased diploid vcf file to multiple alignment fasta file""")

parser.add_argument('vcf', help='the input VCF file (gzipped)')
parser.add_argument('output_prefix', help='the name of the fasta and SNP files to write')

parser.add_argument("--output_positions",
					action="store_true",
					required=False,
					help="If invoked then also output a file with a list of SNP positions")
args = parser.parse_args()

counter=0
with gzip.open(args.vcf, 'rt') as f:
    for line in f:
        if line[0:2] == '##':
            continue
        if line[0:6] == '#CHROM':
            samples = line.strip('\n').split()[9:]
            continue
        counter+=1
f.close()

seq_dict = {}
for sample in samples:
    seq_dict[sample + '_1'] = ['N'] * counter
    seq_dict[sample + '_2'] = ['N'] * counter

positions = [0] * counter
# for sample in samples:
#     seq_dict[sample + '_1'] = ''
#     seq_dict[sample + '_2'] = ''
# print(seq_dict.keys())

i=0
with gzip.open(args.vcf, 'rt') as f:
    for line in f:
        if line[0:1] == '#':
            continue

        items = line.strip('\n').split()
        chrom = items[0]
        pos = items[1]
        REF = items[3]
        ALTs = items[4].split(',')
        alleles = tuple([REF] + ALTs)
        GTs = items[9:]

        for x, sample in enumerate(samples):
            # print(i)
            seq_dict[sample + '_1'][i] = alleles[int(GTs[x].split('|')[0])]
            seq_dict[sample + '_2'][i] = alleles[int(GTs[x].split('|')[1])]

        positions[i] = pos

        i+=1
        # print(i)

alignment = MultipleSeqAlignment([SeqRecord(Seq(''.join(y), generic_dna), id=x, description='') for x,y in seq_dict.items()])
AlignIO.write(alignment, args.output_prefix + '.fa', "fasta")

if args.output_positions:
    with open(args.output_prefix + '.pos', 'wt') as f_out:
        f_out.write('\n'.join(positions) + '\n')
    f_out.close()
















#
