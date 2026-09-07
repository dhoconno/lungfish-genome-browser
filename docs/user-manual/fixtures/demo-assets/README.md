# Genotyping demo asset

The MHC genotyping chapters need a real, populated project to screenshot
against: 30 MiSeq amplicon samples run all the way through mapping,
markdup, and amplicon genotyping. That project is too large to commit
as a fixture, so it lives outside the repo and capture recipes
reference it by path instead.

## Where it is

Open **`/Users/dho/Desktop/lge-docs/32566_MS267_Williams1.lungfish`**
for capture. This is a copy the user placed under `~/Desktop/lge-docs/`
so that every project a manual screenshot is taken from sits under one
folder. It is otherwise identical to the original working copy at
`~/Downloads/32566_MS267_Williams1.lungfish`, which remains the source
of the data. The Downloads copy is not itself used for capture: treat
it only as provenance for where the project came from.

Capture recipes should reference the asset as:

```
{demo_assets}/32566_MS267_Williams1.lungfish
```

with `{demo_assets}` defined as `~/Desktop/lge-docs`.

## Why it is not committed

The project directory is **476 MB** on disk (`du -sh`, measured
2026-09-06): FASTQ bundles, a full IPD-MHC reference bundle, and seven
genotype result bundles with their SQLite/workbook state. That is far
past the fixture-set size caps used elsewhere in
`docs/user-manual/fixtures/` (see `hg002-chr20/README.md`'s 50 MB
fixture-set cap and 10 MB per-file cap), and the data is not
redistributable research material in the way the HG002 or SARS-CoV-2
fixtures are. It stays local, referenced by absolute path.

## Contents (as of 2026-09-06)

- **`Imports/`**: 30 MiSeq paired FASTQ bundles (`.lungfishfastq`),
  named `WD1_S148_L001` through `WD30_...` (barcode-demuxed samples).
- **`26128_ipd-mhc-mamu-2021-07-09.lungfishref`**: the IPD-MHC rhesus
  macaque (Mamu) reference bundle used for mapping and genotyping.
- **`Analyses/Amplicon genotyping results/`**: seven genotype result
  bundles (`.lungfishgenotype`): `amplicon-genotyping`,
  `amplicon-genotyping_1` through `_3`, `finalcheck`, `spacefix`,
  `spacefix2`. These represent iterative reruns and checkpoints of the
  same genotyping analysis, not seven distinct experiments.
- **`Primer Schemes/`** and **`32566_MS267_Williams1_barcodes.txt`**:
  a primer-scheme folder (currently empty in this copy, no
  `.lungfishprimers` bundle staged) and the demultiplexing barcode
  sheet (29 lines of barcode name and sequence, matching the sample
  count). Screenshots should not assume a populated primer scheme list
  without checking first.
- Root-level project state: a pivot export
  (`amplicon-genotyping_3-filtered-pivot.xlsx` and its
  provenance/view-projection sidecars) from a prior workbook export,
  plus the usual `.project.db`, `.universal-search.db`,
  `.lungfish-provenance.json`, `.lungfish-operation-history/`, and
  `metadata.json`.

## Campaign decision: scope for the genotyping chapters

The genotyping chapters use this project strictly as a
**genotyping-only example**: sample import, mapping and markdup, and
amplicon genotyping through to result review and pivot export. The
haplotype-analysis section of those chapters is a **labeled
placeholder**. There is no worked MHC haplotype-analysis example in
this asset, and the chapters must not fabricate one. Mark that section
clearly as a placeholder pending a suitable worked example rather than
describing haplotype analysis against screenshots of this project.

## Open question

Spec open item 3 (animal identifiers in screenshots): the sample names
and barcode sheet in this project may expose animal or subject
identifiers in captured screenshots. This is not resolved here. Flag it
to the controller before any screenshot from this asset is published
in the manual.
