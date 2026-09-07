#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
mkdir -p expected
"$CLI" assemble --assembler spades --read-type illumina-short-reads --paired \
  --name HG002-chrM -o expected/spades HG002.chrM.R1.fastq.gz HG002.chrM.R2.fastq.gz
ls expected/spades
