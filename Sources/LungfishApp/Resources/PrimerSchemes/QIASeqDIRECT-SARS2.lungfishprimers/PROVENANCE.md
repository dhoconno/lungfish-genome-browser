# QIAseq Direct SARS-CoV-2 (with Booster A)

Panel designer: QIAGEN N.V.

Retrieved from: https://www.qiagen.com/us/products/discovery-and-translational-research/next-generation-sequencing/rna-sequencing/qiaseq-direct-sars-cov-2-kits-handbooks-and-supplemental-files

Retrieval date: 2026-04-24

Primer coordinates anchored to a public reference are not independently copyrightable. Users should verify against QIAGEN's current product documentation before clinical or production use.

## Build

The bundle was authored by `scripts/build-primer-bundle.swift` from `scripts/inputs/qiaseq-direct-with-booster-a-primers.bed`. The script fetches both `MN908947.3` (canonical) and `NC_045512.2` (declared equivalent) from NCBI eutils efetch at build time, computes SHA256 over each FASTA's sequence body (excluding the header line, with all whitespace removed), and refuses to emit the bundle on hash mismatch. At this build the canonical reference (MN908947.3) was verified byte-identical to the equivalent (NC_045512.2).

## Sequences

No `primers.fasta` is bundled because primer sequences are derivable from MN908947.3 at the listed BED coordinates. Trimming tools that need the primer nucleotide sequences should look them up from a local copy of MN908947.3 (or an equivalent build of the same reference).
