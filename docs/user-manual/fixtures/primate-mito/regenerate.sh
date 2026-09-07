#!/usr/bin/env bash
# Align the five primate mitochondrial genomes with MAFFT and infer a
# maximum-likelihood tree with IQ-TREE, then copy the aligned FASTA and the
# treefile out of the produced bundles into stable expected/ names.
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli

# The --project argument must be a directory whose path carries a literal
# ".lungfish" extension (LungfishIO's ProjectTempDirectory.findProjectRoot
# walks up looking for that extension) -- a plain "tmp-project" directory is
# rejected with "Project context required but no .lungfish root found".
PROJECT=expected/tmp-project.lungfish
mkdir -p expected
rm -rf "$PROJECT"
mkdir -p "$PROJECT"

"$CLI" align mafft --strategy auto --name "Primate mitochondria" \
  --project "$PROJECT" primate-mito.fasta

MSA=$(find "$PROJECT" -name '*.lungfishmsa' | head -1)
echo "MSA bundle: $MSA"

"$CLI" tree infer iqtree --help > /dev/null   # confirm flags before the next line
"$CLI" tree infer iqtree "$MSA" --project "$PROJECT" \
  --output "$PROJECT/primate-mito.lungfishtree"

TREE="$PROJECT/primate-mito.lungfishtree"

# Copy the aligned FASTA and the treefile out of the bundles into stable
# names. Bundle internals observed on 2026-09-06/07 with CLI 2026.9.13:
#   <msa>/alignment/primary.aligned.fasta  -- the MAFFT-aligned FASTA
#   <tree>/tree/primary.nwk                -- the canonical primary Newick
#                                              tree (manifest.json's
#                                              primaryTreeID; byte-identical
#                                              to artifacts/iqtree/run.treefile)
cp "$MSA/alignment/primary.aligned.fasta" expected/primate-mito.aligned.fasta
cp "$TREE/tree/primary.nwk" expected/primate-mito.treefile

echo "Alignment records: $(grep -c '^>' expected/primate-mito.aligned.fasta)"
echo "Alignment length: $(awk '/^>/{next}{print length($0); exit}' expected/primate-mito.aligned.fasta)"
echo "Tree:"
cat expected/primate-mito.treefile
