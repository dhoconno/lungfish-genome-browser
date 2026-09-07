#!/usr/bin/env python3
"""Select the HG002 mitochondrial reads that overlap the 12S rRNA locus, so the
selection behaves like a 12S amplicon library rather than whole-mitochondrion
shotgun. Overlap is decided by an exact 24-base seed shared with the human 12S
region of NC_012920.1, in either orientation.

Reads   ../primate-mito/primate-mito.fasta
        ../human-mito/HG002.chrM_R1.fastq.gz
Writes  HG002-12S-amplicon.fastq.gz
"""
import gzip
import os

HERE = os.path.dirname(os.path.abspath(__file__))
MITO = os.path.join(HERE, os.pardir, 'primate-mito', 'primate-mito.fasta')
READS = os.path.join(HERE, os.pardir, 'human-mito', 'HG002.chrM_R1.fastq.gz')
OUT = os.path.join(HERE, 'HG002-12S-amplicon.fastq.gz')


def read_fasta(path):
    seqs, name = {}, None
    for line in open(path):
        line = line.strip()
        if line.startswith('>'):
            name = line[1:]
            seqs[name] = []
        elif name:
            seqs[name].append(line)
    return {k: ''.join(v).upper() for k, v in seqs.items()}


def rc(s):
    return s.translate(str.maketrans('ACGTN', 'TGCAN'))[::-1]


mito = read_fasta(MITO)
human = mito['Human_NC_012920.1']
# MT-RNR1 (12S rRNA) is NC_012920.1:648-1601.
locus = human[647:1601]

K = 24
seeds = {locus[i:i + K] for i in range(len(locus) - K + 1)}
seeds |= {rc(s) for s in seeds}

kept = 0
total = 0
# mtime=0 keeps the gzip header byte-stable so reruns reproduce the file
# exactly rather than embedding a fresh timestamp.
with gzip.open(READS, 'rt') as fin, \
        gzip.GzipFile(OUT, 'wb', mtime=0) as raw:
    while True:
        head = fin.readline()
        if not head:
            break
        seq = fin.readline().rstrip('\n')
        plus = fin.readline()
        qual = fin.readline()
        total += 1
        s = seq.upper()
        hit = any(s[i:i + K] in seeds for i in range(0, len(s) - K + 1, 4))
        if hit:
            kept += 1
            raw.write(head.encode())
            raw.write((seq + '\n').encode())
            raw.write(plus.encode())
            raw.write(qual.encode())

print(f'{total} reads scanned, {kept} overlap the 12S locus')
