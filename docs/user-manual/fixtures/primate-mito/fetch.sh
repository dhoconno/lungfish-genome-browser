#!/usr/bin/env bash
# Fetch five primate mitochondrial reference genomes (RefSeq) into a single
# FASTA for the alignment and tree chapters. Headers are rewritten to
# "<Common name>_<accession>" so alignment columns and tree tips read well
# without a separate relabel step.
set -euo pipefail
cd "$(dirname "$0")"

# accession:label pairs, verified against NCBI esummary on 2026-09-06 (see
# README.md for the full accession-check output). All five resolved to the
# expected species at their expected RefSeq accession; none needed
# substitution.
ACCESSIONS=(
  "NC_012920.1:Human"
  "NC_001643.1:Chimp"
  "NC_011120.1:Gorilla"
  "NC_005943.1:RhesusMacaque"
  "NC_012670.1:CynomolgusMacaque"
)

: > primate-mito.fasta
for entry in "${ACCESSIONS[@]}"; do
  acc="${entry%%:*}"
  label="${entry##*:}"
  curl -sL "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${acc}&rettype=fasta&retmode=text" \
    | awk -v hdr=">${label}_${acc}" '/^>/{print hdr; next} {print}' \
    >> primate-mito.fasta
done

du -sh primate-mito.fasta
grep -c '^>' primate-mito.fasta
