#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
mkdir -p expected
"$CLI" map --paired --mapper minimap2 --preset sr --reference GRCh38.chr20.10.0-10.5Mb.fasta \
  --sample-name HG002 -o expected/mapping HG002.chr20.10.0-10.5Mb_R1.fastq.gz HG002.chr20.10.0-10.5Mb_R2.fastq.gz
ls expected/mapping
