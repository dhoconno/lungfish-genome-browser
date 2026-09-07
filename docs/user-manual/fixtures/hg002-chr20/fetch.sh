#!/usr/bin/env bash
# Slice HG002 chromosome 20 (10.0 to 10.5 Mb) from public GIAB data.
# Needs samtools, bcftools, and htslib (bgzip, tabix) from the managed
# lungfish-tools environment; the paths below are the managed installs.
set -euo pipefail
cd "$(dirname "$0")"
ENV="$HOME/.lungfish/conda/envs"
SAMTOOLS="$ENV/samtools/bin/samtools"; BCFTOOLS="$ENV/bcftools/bin/bcftools"
BGZIP="$ENV/htslib/bin/bgzip"; TABIX="$ENV/htslib/bin/tabix"
REGION="chr20:10000000-10500000"; OFFSET=9999999
BAM="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam"
VCF="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz"
CHR="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz"
mkdir -p cache
# Reference slice, header renamed so the fixture stands alone.
[ -f cache/chr20.fa.gz ] || curl -sL "$CHR" -o cache/chr20.fa.gz
gunzip -kf cache/chr20.fa.gz
"$SAMTOOLS" faidx cache/chr20.fa "$REGION" | sed '1s/.*/>chr20_10.0-10.5Mb/' > GRCh38.chr20.10.0-10.5Mb.fasta
"$SAMTOOLS" faidx GRCh38.chr20.10.0-10.5Mb.fasta
# Reads: remote region fetch, name-sorted, paired FASTQ.
# Full 2x250bp slice over 500 kb comes back at ~13-14 MB gzipped per mate,
# over the 10 MB per-file fixture cap, so downsample to DOWNSAMPLE_FRACTION
# (via samtools view -s <seed>.<frac>, e.g. 42.65 keeps ~65% of read pairs)
# before converting to FASTQ.
DOWNSAMPLE_FRACTION="0.65"
# Remote-touching samtools/bcftools calls run with cwd=cache/ so the local
# .bai/.tbi index caches htslib fetches for the remote URLs land there
# instead of littering the fixture root.
( cd cache && "$SAMTOOLS" view -b -h "$BAM" "$REGION" > slice.bam )
"$SAMTOOLS" view -b -s "42${DOWNSAMPLE_FRACTION#0}" -o cache/slice.ds.bam cache/slice.bam
"$SAMTOOLS" sort -n -o cache/slice.nsort.bam cache/slice.ds.bam
"$SAMTOOLS" fastq -1 HG002.chr20.10.0-10.5Mb.R1.fastq.gz -2 HG002.chr20.10.0-10.5Mb.R2.fastq.gz -0 /dev/null -s /dev/null -n cache/slice.nsort.bam
# Benchmark calls, shifted into fixture coordinates.
( cd cache && "$BCFTOOLS" view -r "$REGION" "$VCF" -Ou ) | "$BCFTOOLS" annotate --rename-chrs <(echo "chr20 chr20_10.0-10.5Mb") -Ov \
 | awk -v o="$OFFSET" 'BEGIN{OFS="\t"} /^#/ {print; next} {$2=$2-o; print}' | "$BGZIP" -c > HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz
"$TABIX" -p vcf HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz
du -sh *.fasta *.fastq.gz *.vcf.gz
