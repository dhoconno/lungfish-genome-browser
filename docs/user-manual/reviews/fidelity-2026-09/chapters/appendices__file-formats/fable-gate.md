# Fable gate: appendices/file-formats

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a reference appendix. What it is, Before you type anything, the registry with its write-flag paragraph, one section per standard format, the bundle table, one section per bundle kind, provenance sidecars, sharing, an extension index, Next. |
| Every quoted line traceable | Pass. Every FASTA, FASTQ, GFF3, BED, VCF, Newick, manifest, and sidecar excerpt names the fixture or demo bundle it came from, and the reviewer reran each inspection command. |
| Fidelity false claims corrected | Pass. Four of four, plus the GFF3 ellipsis, with the write-flag paragraph kept. |
| Rulings | Pass. All nine, with the BAM contradiction reconciled, the Terminal pointer and a folder sentence per command, the worked 27 to 51 conversion, orientation without invented thresholds, the unrooted sentence beside the Newick block, materialization stated as automatic, window equivalents named, and fourteen glossary terms. |
| Reader consensus | Pass. Forty-seven of forty-seven applied, 85 of 91 others. |
| Cross-chapter agreement | Pass after the gate edits. The genotype bundle covers both routes and both folders per chapter 54, and the imported primer scheme's provenance folder matches chapter 64. |
| Storage rulings | Pass. The variants folder and its two exceptions, paired-end interleaving, virtual bundles, classifier placement, 12S results, and workflow bundles all match CONSISTENCY.md. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The genotype bundle description covers the MiSeq and full-length routes and their two folders, and the fixture sentence no longer tells the reader they have nothing.
2. The meanQuality explanation defers to the quality chapter rather than asserting which average the sidecar stores.
3. The imported primer scheme's provenance layout matches chapter 64, and its manifest key list says "include".
4. Reading time raised to 40 minutes.

## Rulings

BED has a writer and DRIFT's decision line is wrong. The `Assemblies/` folder question is settled by CONSISTENCY.md and the assembly chapters, and the author was right. DRIFT's five unverifiable claims are a template artifact. The right-align delimiter lint trap is a Phase 6 tooling item.

## Findings for RESULTS.md

`lungfish-cli bundle export` cannot be run because its `--format` collides with the global option. The registry marks SAM and VCF writable with no writer class behind them. The CZ ID import sheet's destination readout names a path nothing writes.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
