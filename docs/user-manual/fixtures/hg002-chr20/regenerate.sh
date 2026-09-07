#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
HERE="$(pwd)"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
BCFTOOLS=/Users/dho/.lungfish/conda/envs/bcftools/bin/bcftools
mkdir -p expected
if [ ! -f expected/mapping/HG002.sorted.bam ]; then
  "$CLI" map --paired --mapper minimap2 --preset sr --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --sample-name HG002 -o expected/mapping HG002.chr20.10.0-10.5Mb_R1.fastq.gz HG002.chr20.10.0-10.5Mb_R2.fastq.gz
fi
ls expected/mapping

# Variant calls (bcftools, LoFreq) from expected/mapping/HG002.sorted.bam
# against the fixture reference, with default settings. Run inside a scratch
# .lungfish project because `variants call` only operates on a bundle-owned
# alignment track, never a loose BAM.
mkdir -p expected/variants/bcftools expected/variants/lofreq
if [ ! -f expected/variants/bcftools/HG002.bcftools.vcf.gz ] || [ ! -f expected/variants/lofreq/HG002.lofreq.vcf.gz ]; then
  SCRATCH="$(mktemp -d)"
  trap 'rm -rf "$SCRATCH"' EXIT
  PROJ="$SCRATCH/proj.lungfish"
  mkdir -p "$PROJ"
  touch "$PROJ/.project.db"

  "$CLI" import fasta "$HERE/GRCh38.chr20.10.0-10.5Mb.fasta" --name "chr20 10.0-10.5Mb" -o "$PROJ"
  BUNDLE="$(find "$PROJ/Reference Sequences" -maxdepth 1 -name '*.lungfishref' | head -1)"

  "$CLI" bam adopt-mapping --bundle "$BUNDLE" --mapping-result "$HERE/expected/mapping" \
    --name "HG002 minimap2" --track-id hg002-minimap2

  if [ ! -f expected/variants/bcftools/HG002.bcftools.vcf.gz ]; then
    "$CLI" variants call --bundle "$BUNDLE" --alignment-track hg002-minimap2 \
      --caller bcftools --name "HG002 bcftools"
    BC="$(/usr/bin/python3 -c '
import json,sys
m=json.load(open(sys.argv[1]+"/manifest.json"))
for v in m.get("variants") or []:
    if v.get("name")=="HG002 bcftools":
        print(v.get("id")); break
' "$BUNDLE")"
    cp "$BUNDLE/variants/$BC.vcf.gz" expected/variants/bcftools/HG002.bcftools.vcf.gz
    cp "$BUNDLE/variants/$BC.vcf.gz.tbi" expected/variants/bcftools/HG002.bcftools.vcf.gz.tbi
    cp "$BUNDLE/variants/$BC.lungfish-provenance.json" expected/variants/bcftools/HG002.bcftools.lungfish-provenance.json
  fi

  if [ ! -f expected/variants/lofreq/HG002.lofreq.vcf.gz ]; then
    "$CLI" variants call --bundle "$BUNDLE" --alignment-track hg002-minimap2 \
      --caller lofreq --name "HG002 LoFreq"
    LF="$(/usr/bin/python3 -c '
import json,sys
m=json.load(open(sys.argv[1]+"/manifest.json"))
for v in m.get("variants") or []:
    if v.get("name")=="HG002 LoFreq":
        print(v.get("id")); break
' "$BUNDLE")"
    cp "$BUNDLE/variants/$LF.vcf.gz" expected/variants/lofreq/HG002.lofreq.vcf.gz
    cp "$BUNDLE/variants/$LF.vcf.gz.tbi" expected/variants/lofreq/HG002.lofreq.vcf.gz.tbi
    cp "$BUNDLE/variants/$LF.lungfish-provenance.json" expected/variants/lofreq/HG002.lofreq.lungfish-provenance.json
  fi
fi
echo "record counts:"
"$BCFTOOLS" view -H expected/variants/bcftools/HG002.bcftools.vcf.gz | wc -l
"$BCFTOOLS" view -H expected/variants/lofreq/HG002.lofreq.vcf.gz | wc -l
