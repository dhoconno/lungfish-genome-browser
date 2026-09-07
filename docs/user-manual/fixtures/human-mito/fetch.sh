#!/usr/bin/env bash
# Fetch the human mitochondrial reference (rCRS) and HG002 reads mapped to
# chrM from public GIAB data. Needs samtools from the managed
# lungfish-tools environment; the path below is the managed install.
set -euo pipefail
cd "$(dirname "$0")"
ENV="$HOME/.lungfish/conda/envs"
SAMTOOLS="$ENV/samtools/bin/samtools"
BAM="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam"
mkdir -p cache

# Reference: rCRS via NCBI efetch.
curl -sL "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_012920.1&rettype=fasta&retmode=text" > NC_012920.1.fasta
"$SAMTOOLS" faidx NC_012920.1.fasta

# Reads: remote region fetch, name-sorted, paired FASTQ.
# chrM in this GIAB BAM carries ~2.6M reads (mitochondrial DNA is present
# at very high copy number per cell, so WGS libraries massively over-cover
# it relative to the nuclear genome). Full depth would produce enormous
# FASTQs for a 16.5 kb genome, so downsample straight to ~300x coverage
# (via samtools view -s <seed>.<frac>) before converting to FASTQ.
# 300x over 16,569 bp at 2x250bp reads needs ~19,900 total reads; chrM has
# ~2,596,041 reads in the source BAM, giving fraction ~0.0077 (seed 42).
DOWNSAMPLE_FRACTION="0.0077"
# Remote-touching samtools calls run with cwd=cache/ so the local .bai
# index cache htslib builds for the remote URL lands there instead of
# littering the fixture root.
( cd cache && "$SAMTOOLS" view -b -h "$BAM" chrM > slice.bam )
"$SAMTOOLS" view -b -s "42${DOWNSAMPLE_FRACTION#0}" -o cache/slice.ds.bam cache/slice.bam
"$SAMTOOLS" sort -n -o cache/slice.nsort.bam cache/slice.ds.bam
"$SAMTOOLS" fastq -1 HG002.chrM.R1.fastq.gz -2 HG002.chrM.R2.fastq.gz -0 /dev/null -s /dev/null -n cache/slice.nsort.bam

du -sh *.fasta *.fastq.gz
