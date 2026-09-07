#!/usr/bin/env bash
# Fetch HG002 ONT and HiFi long reads over chrM from public GIAB data, plus
# build a minimal ONT run-folder layout from the ONT reads. Needs samtools
# from the managed lungfish-tools environment; the path below is the
# managed install. Reference is the human-mito fixture's NC_012920.1.fasta,
# not duplicated here.
set -euo pipefail
cd "$(dirname "$0")"
ENV="$HOME/.lungfish/conda/envs"
SAMTOOLS="$ENV/samtools/bin/samtools"
ONT_BAM="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/UCSC_Ultralong_OxfordNanopore_Promethion/HG002_GRCh38_ONT-UL_UCSC_20200508.phased.bam"
HIFI_BAM="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/GRCh38/HG002.SequelII.merged_15kb_20kb.GRCh38.duplomap.bam"
mkdir -p cache

# Reads: remote region fetch, name-sorted, single-end FASTQ. Both BAMs are
# GRCh38-aligned, so chrM is rCRS, matching the human-mito reference.
# chrM sits at very high copy number per cell, so both long-read libraries
# massively over-cover the 16.5 kb genome relative to nuclear chromosomes.
# Downsample straight to approximately 300x coverage (via
# samtools view -s <seed>.<frac>) before converting to FASTQ, keeping each
# FASTQ well under the 10 MB per-file fixture cap.
# ONT: chrM slice carries 3,621 reads after name-sort (17.46 Mb, ~1054x);
# 300x needs about 1,031 reads, giving fraction ~0.28 (seed 42).
# HiFi: chrM slice carries 4,005 reads after name-sort (55.15 Mb, ~3327x);
# 300x needs about 361 reads, giving fraction ~0.09 (seed 42).
ONT_FRACTION="0.28"
HIFI_FRACTION="0.09"
# Remote-touching samtools calls run with cwd=cache/ so the local .bai
# index cache htslib builds for the remote URLs lands there instead of
# littering the fixture root.
( cd cache && "$SAMTOOLS" view -b -h "$ONT_BAM" chrM -o ont.slice.bam )
( cd cache && "$SAMTOOLS" view -b -h "$HIFI_BAM" chrM -o hifi.slice.bam )

"$SAMTOOLS" view -b -s "42${ONT_FRACTION#0}" -o cache/ont.ds.bam cache/ont.slice.bam
"$SAMTOOLS" sort -n -o cache/ont.nsort.bam cache/ont.ds.bam
"$SAMTOOLS" fastq -0 HG002.chrM.ont.fastq.gz -n cache/ont.nsort.bam

"$SAMTOOLS" view -b -s "42${HIFI_FRACTION#0}" -o cache/hifi.ds.bam cache/hifi.slice.bam
"$SAMTOOLS" sort -n -o cache/hifi.nsort.bam cache/hifi.ds.bam
"$SAMTOOLS" fastq -0 HG002.chrM.hifi.fastq.gz -n cache/hifi.nsort.bam

# ONT run-folder layout: a minimal fastq_pass/barcode01/ directory holding
# the downsampled ONT reads under an instrument-style chunk name, the
# layout the app's ONT run import recognizes (see
# Sources/LungfishIO/Formats/FASTQ/ONTDirectoryImporter.swift and
# Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift). No sidecar
# file is required by either importer, only the FASTQ chunk itself.
mkdir -p ont-run/fastq_pass/barcode01
cp HG002.chrM.ont.fastq.gz ont-run/fastq_pass/barcode01/HG002_chrM_pass_barcode01_0.fastq.gz

du -sh *.fastq.gz ont-run/fastq_pass/barcode01/*.fastq.gz
