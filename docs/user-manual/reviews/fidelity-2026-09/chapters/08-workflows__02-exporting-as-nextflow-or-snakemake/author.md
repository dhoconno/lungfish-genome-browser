# Author record: 08-workflows/02-exporting-as-nextflow-or-snakemake

Roster row 51. Registry id `provenance.export`. Fixture: demo project,
`Analyses/mapping-HG002` (human HG002 chromosome 20 slice mapped with
minimap2 and processed with samtools). Rewritten against Preview 2026.9.13.

## Fixture handling

The demo project at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` was read
only. Its `Analyses/mapping-HG002` provenance records were copied to the
scratchpad at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/provenance-export/mapping-HG002/`
(`.lungfish-provenance.json`, `mapping-provenance.json`,
`mapping-result.json`). Every export below ran against that copy. Nothing
was written into `~/Desktop/lge-docs/`.

## Commands run

Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
All export runs used the scratchpad copy as input and a scratchpad
`out-<format>` directory as output. All six exited 0 and printed the
primary artifact plus the copied provenance artifacts.

| Command | Exit | Figures taken |
|---|---|---|
| `provenance export … --format nextflow --output out-nextflow` | 0 | `main.nf` 4,811 bytes; 5 processes `MINIMAP2_1`, `SAMTOOLS_2`…`SAMTOOLS_5`; 4 distinct params plus `params.outdir`; `nextflow.config` 67 bytes; `containers/manifest.json` 4 bytes, empty list |
| `provenance export … --format snakemake --output out-snakemake` | 0 | `Snakefile` with `rule all` plus 5 rules; usage comment `snakemake --cores 8 --use-singularity`; no `singularity:` directives; `config.yaml` with 7 keys, one duplicated |
| `provenance export … --format shell --output out-shell` | 0 | `run.sh` 4,187 bytes, mode 0755, `set -euo pipefail`, `INPUT_1`…`INPUT_6` with sha256 comments, `OUTDIR` |
| `provenance export … --format python --output out-python` | 0 | `reproduce.py` 4,577 bytes, mode 0755, `INPUTS` dict keyed by filename with sha256 values |
| `provenance export … --format methods --output out-methods` | 0 | `methods.md` with generated-draft HTML comment, `Methods`, `Computational Analysis`, `Tool Versions`, `Input Files`, `Reproducibility`; samtools named 4 times |
| `provenance export … --format json --output out-json` | 0 | `provenance.json` expanded envelope |
| `provenance bibliography <scratchpad copy>` | 0 | 2 citations, minimap2 (Li H., Bioinformatics 2018, DOI 10.1093/bioinformatics/bty191) and SAMtools (Danecek et al., GigaScience 2021, DOI 10.1093/gigascience/giab008) |
| `provenance verify <scratchpad copy>` | 0 (prints an Error line) | `Error: Workflow execution failed: Signature artifact is missing: …/.lungfish-provenance.json.signature.json` |
| `conda lock --help` | 0 | Overview reads "Export a requested environment specification for a plugin pack (not a resolved lock)"; `--output` is "Requested specification JSON output path" |
| `nextflow lint main.nf` (managed 26.04.6) | non-zero | 1 error, 11 warnings. Error: `main.nf:121:5: Incorrect number of call arguments, expected 3 but received 1` |
| `snakemake --dry-run --cores 1` (miniforge 8.26.0) | 0 (prints exception) | `CyclicGraphException in rule samtools_5 … Cyclic dependency on rule samtools_5.` |
| `nextflow -version` (managed env) | 0 | 26.04.6 build 12646, matching the pinned version |
| `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh <chapter>` | 0 | `no issues found` |

Both Nextflow and Snakemake were already installed on this machine
(`~/.lungfish/conda/envs/nextflow` at the pinned 26.04.6, and
`/Users/dho/miniforge3/bin/snakemake` at 8.26.0). Nothing was installed.

## Source files consulted

- `Sources/LungfishWorkflow/Provenance/ProvenanceExporter.swift` (export
  bundle assembly, the six format emitters, `makeExecutable`,
  `signReportArtifacts`, the retained-selection replay branch, the
  Snakemake `singularity:` branch, the container manifest)
- `Sources/LungfishApp/App/AppDelegate+ImportExport.swift` (artifact
  resolution and the fallback to the most recent completed run, the
  no-provenance alert, the save-sheet presentation, the non-directory
  refusal, `defaultProvenanceExportDirectoryName`, the Provenance Export
  Complete alert)
- `Sources/LungfishApp/App/AppFilePanelFactory.swift` (`provenanceExportPanel`
  title, message, and prefilled name)
- `Sources/LungfishApp/App/MainMenu.swift` (the Export submenu, the
  Provenance submenu built as `prefix(4)` then a separator then
  `dropFirst(4)`, and `ProvenanceExportMenuModel.items` with its six titles
  and their ellipses)
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowBuilderViewController.swift`
  (the Builder toolbar's separate Export to Nextflow... and Export to
  Snakemake... items)
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
  (Nextflow 26.04.6, Snakemake 9.25.2)
- `docs/user-manual/parameters.yaml` (`provenance.export`)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/provenance.txt`

## Drift rows settled

All 7 false and 9 changed rows were applied. The three unverifiable rows
were settled by running the export.

- Row 27 (a synthesized reference acquisition carrying a tool version of
  `unknown`): not reproduced. The emitted `main.nf` for the HG002 mapping
  run contains zero occurrences of `unknown`, and every step carries a real
  resolved version. The chapter keeps the `unknown` check as a thing to look
  for under What good looks like, and states that this run carries none,
  rather than asserting the synthesized-step mechanism.
- Row 29 (an SRA-seeded run referencing the accession): disproved as
  worded. The demo project's `Imports/SRR36291587.lungfishfastq` sidecar
  records `argv` of `lungfish-cli import fastq …/_scratch/sra/SRR36291587_1.fastq …`,
  meaning local scratch paths from the import step, with no accession field.
  The chapter therefore drops the SRA-accession claim entirely rather than
  restating it, and covers the general point (the export never copies input
  data, and recorded paths are the original machine's) under What good looks
  like.
- Row 31 (the deterministic OCI-layout fallback of `bundle export --format
  container`): not verified, and the whole OCI-tarball passage was cut. The
  corrected row 32 removes the reason the passage was there, since the
  emitted `main.nf` names images by their recorded reference and not by
  digest, so pointing a run at a local tarball is manual editing either way.

Every Missing row is covered: the CLI export command, `provenance verify`
(including the missing-signature message), `provenance bibliography` (with
its two real citations), the Provenance Export Complete alert and Show in
Finder, the prefilled `<artifact>-provenance-<format>` name, the
no-provenance alert, the most-recent-completed-run fallback, the export's
own provenance sidecar and `provenance/source/external/` tree, the
retained-selection replay variant, the executable bit on `run.sh` and
`reproduce.py`, the pinned Nextflow 26.04.6 and Snakemake 9.25.2, and the
Workflow Builder's separate exporters.

## App defects found

All four were found by running the export and validating its output, and
all four are reported in the chapter's What good looks like section as
exporter defects rather than reader mistakes.

1. **The emitted Nextflow pipeline does not validate.** `nextflow lint
   main.nf` under the pinned Nextflow 26.04.6 reports
   `Incorrect number of call arguments, expected 3 but received 1` at the
   workflow block. `MINIMAP2_1` declares three input paths (R1, R2, and the
   reference FASTA) but the generated workflow calls it with only the first
   channel. Ten of the eleven warnings are unused channel variables and the
   deprecated `Channel` factory spelling.
2. **The emitted Snakemake workflow does not validate.** `snakemake
   --dry-run` fails with `CyclicGraphException in rule samtools_5`. The
   recorded `samtools flagstat` step lists `HG002.sorted.bam` as both an
   input and an output of the same rule, which Snakemake reads as a
   self-dependency.
3. **Duplicated parameter keys.** `params.hg002_sorted_bam` is emitted twice
   in `main.nf` (both in the params block and in the workflow block's channel
   declarations), `hg002_sorted_bam` twice in `config.yaml`, and the same
   filename key twice in the Python export's `INPUTS` dictionary. Two
   recorded steps declared the same file and nothing deduplicates.
4. **Absolute host paths in every emitted command.** The process and rule
   scripts carry the original machine's paths verbatim, including
   `/Users/dho/.lungfish/conda/envs/samtools/bin/samtools` and a
   `micromamba run -n minimap2` invocation, so the declared parameters and
   channels are decorative on any second machine.

Defects 1 and 2 mean the chapter cannot promise a runnable export. It says
so in the What it is section rather than leaving the reader to discover it.

## Could not verify

- Nothing in the window. This chapter was written from source plus real CLI
  runs, so the four planned shots (`export-provenance-submenu`,
  `export-provenance-save-panel`, `export-provenance-complete-alert`,
  `nextflow-export-main-nf`) are declared and marked but not captured. The
  save panel's title, message, and prefilled name, the alert's title and its
  OK and Show in Finder buttons, and the submenu's six items with a separator
  after the fourth all come from source and should be confirmed against the
  captures.
- The signing path. No signer is configured on this machine, so no
  `.signature.json` or `.pub` was produced and `provenance verify` could only
  be exercised on its missing-signature branch. The chapter states the
  signing behaviour from `signReportArtifacts` and is explicit that the
  default is unsigned.
- The retained-selection replay branch. Read from source
  (`ProvenanceExporter.swift`) but not reproduced, since no retained-selection
  run exists in the demo project. The chapter states it as a qualifier and
  tells screenshot capture to avoid such a run.
- Whether a non-empty `containers/manifest.json` and the Snakemake
  `singularity:` directives render as the source says. The demo project's
  runs all used conda environments, so `containerImage` was nil on every
  step and both container paths went untaken.

## Glossary

Added one term, **Snakemake** (`{#snakemake}`), inserted alphabetically
between Smart-filter token and SNV. Listed in `glossary_refs` alongside the
existing checksum, container, methods-export, provenance,
provenance-sidecar, and reproducibility.

## Front matter

`parameters_refs: [provenance.export]` added. `estimated_reading_min` kept
at 8. `brand_reviewed` and `lead_approved` left false. `shots` left empty
with four `planned_shots`, each with a matching `<!-- planned: … -->`
marker in the body. Two planned shots were added beyond the original two,
for the save panel and the completion alert, as the drift report's
screenshot table requested.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/08-workflows/02-exporting-as-nextflow-or-snakemake.md`

Result: `docs/user-manual/chapters/08-workflows/02-exporting-as-nextflow-or-snakemake.md: no issues found`
