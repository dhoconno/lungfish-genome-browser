#!/usr/bin/env bash
# Rebuild the constructed 12S fixture from the two sibling fixtures it is cut
# from: primate-mito (the five mitochondrial genomes the reference targets come
# out of) and human-mito (the HG002 chrM reads the amplicon read set is drawn
# from). Nothing is fetched from the network.
#
#   ../primate-mito/primate-mito.fasta      -> primate-12s-dedup.fasta
#                                              primate-12s-midori.tsv
#                                              primate-12s-targets.tsv
#   ../human-mito/HG002.chrM_R1.fastq.gz    -> HG002-12S-amplicon.fastq.gz
#                                              HG002-12S-oriented.fastq
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli

# 1. Cut the 60-base 12S reference targets and the MIDORI-style metadata table
#    out of the five primate mitochondrial genomes.
python3 build_ref.py

# 2. Select the HG002 chrM reads that overlap the human 12S locus, so the read
#    set behaves like a 12S amplicon library rather than a whole-mitochondrion
#    shotgun run.
python3 make_amplicon.py

# 3. Join the reference FASTA to the metadata table. The join is on the species
#    name parsed out of the FASTA header, which is why build_ref.py writes
#    headers in the "Common name (Scientific name)" form.
"$CLI" fastq 12s-reference-metadata \
  --dedup-fasta primate-12s-dedup.fasta \
  --midori-metadata primate-12s-midori.tsv \
  --output primate-12s-targets.tsv --force

# 4. Orient the amplicon reads against the reference. The 12S matcher has no
#    reverse-complement pass, so reverse-strand reads go unmatched until this
#    step flips them. --compress is deliberately omitted: the CLI writes plain
#    text regardless, so asking for a .gz name only produces a mislabelled file.
"$CLI" fastq orient HG002-12S-amplicon.fastq.gz \
  --reference primate-12s-dedup.fasta \
  --output HG002-12S-oriented.fastq --force

echo "reference targets: $(grep -c '^>' primate-12s-dedup.fasta)"
echo "amplicon reads:    $(( $(gzcat HG002-12S-amplicon.fastq.gz | wc -l) / 4 ))"
echo "oriented reads:    $(( $(wc -l < HG002-12S-oriented.fastq) / 4 ))"
