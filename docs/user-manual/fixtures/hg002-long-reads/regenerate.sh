#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
mkdir -p expected

"$CLI" assemble --assembler flye --read-type ont-reads --name HG002-chrM-ONT \
  -o expected/flye HG002.chrM.ont.fastq.gz
ls expected/flye

"$CLI" assemble --assembler hifiasm --read-type pacbio-hifi --name HG002-chrM-HiFi \
  -o expected/hifiasm HG002.chrM.hifi.fastq.gz
ls expected/hifiasm
