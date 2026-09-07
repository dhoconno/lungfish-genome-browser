# Author record: 09-genotyping/02-running-genotyping

Chapter: `docs/user-manual/chapters/09-genotyping/02-running-genotyping.md`
Roster row 54. Registry ids `genotype.miseq-amplicon` and `genotype.full-length-ont`.
Fixture: the Williams MiSeq genotyping project.
Build under test: Preview 2026.9.13, CLI binary `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

## Result

Lint, verbatim:

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/02-running-genotyping.md: no issues found

Settings paragraphs 33, covering all 16 registry `settings` labels across the two
operations plus all 17 `cli_only` flags. Shot markers 5, matching 5 `shots`
front-matter entries with captions. Glossary terms added 2. A run was
reproduced from the Williams inputs.

## Commands run

All output directories were outside the project. The first three attempts went
to the session scratchpad and failed for the reason recorded under Defects, so
the successful runs went to `~/lge-genotyping-scratch/` instead. Nothing was
written into `~/Desktop/lge-docs/`.

| # | Command | Exit | Notes |
|---|---|---|---|
| 1 | `lungfish-cli fastq genotype-cohort <3 Williams bundles> --mode illumina-paired --read-type illumina --reference 26128_ipd-mhc-mamu-2021-07-09.lungfishref --output-dir <scratchpad>/three-sample --output-name three-sample --threads 8 --min-support 1` | 1 | Failed at 84 percent with "The genotype reviewable-row catalog output is outside the result bundle". 55 s. |
| 2 | Same, `--output-dir <scratchpad>/three-sample.lungfishgenotype` | 1 | Same failure. Extension is not the cause. 55 s. |
| 3 | Same, `--output-dir <scratchpad>/run-b.lungfishgenotype --keep-intermediates` | 1 | Same failure. Reproducible. 55 s. |
| 4 | Same, `--output-dir ~/lge-genotyping-scratch/run-c.lungfishgenotype --output-name run-c` | 0 | Succeeded. 55 s wall clock. All figures in the chapter come from this run. |
| 5 | Same as 4 with `--output-name run-d --min-support 50` | 0 | Succeeded, 55 s. Produced byte-identical row counts to run 4. See Defects. |
| 6 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/09-genotyping/02-running-genotyping.md` | 0 (final) | 6 semicolon warnings on the first pass, then clean. |

Non-run inspection commands: `ls`, `du`, `find`, `wc`, `head`, `sed`, `grep`,
and Python scripts reading JSON, CSV, and XLSX from the Williams project and
from runs 4 and 5.

## Figures from run 4, quoted in the chapter

- 505,528 input reads, 119,146 retained unique reads, 23.568625 percent retained.
- Drop counts across the 3 samples: 40,716 unmapped, 58,895 not spanning the
  reference end to end, 51,315 with too many mismatches, 119,146 passed.
- 293 genotype rows across 3 samples. `WD1_S148_L001` produced 104 rows,
  identical to the Williams project's own run for that sample.
- Filtering step wall clock 14.94 s of the 55 s total.
- One DRB row (`07_Mamu-DRB1_03_03_01_01`) carried 3,598 retained reads,
  evidence the bbmerge step worked.
- Workbook sheets: `run-c`, `run-c Long Summary`, `run-c Sample Summary`,
  `Run Stats`.
- Bundle contents named in the chapter's table, all confirmed present on disk.
- Operations message quoted verbatim from run 4's stdout: "3 of 3 Illumina
  inputs contain unmerged read pairs. Merging overlapping pairs before mapping
  so full-length amplicons (including the 244 bp DRB loci) can be genotyped."

## What was read from the Williams project

Read-only. Path `~/Desktop/lge-docs/32566_MS267_Williams1.lungfish`.

- Layout: `Imports/` holds 30 `.lungfishfastq` bundles (180 MB total), one per
  sample, named `WD1_S148_L001` through `WD30_S177_L001`. `Downloads/` and
  `Primer Schemes/` are empty. A `.lungfishref` reference sits at the project
  root. `Analyses/` holds one folder, `Amplicon genotyping results`, confirming
  the fixed category-folder naming rather than a timestamped one.
- Reference `26128_ipd-mhc-mamu-2021-07-09.lungfishref`: `manifest.json`
  `browser_summary` lists 970 sequences. Length histogram: 577 at 156 bp,
  198 at 244 bp, 57 at 154 bp, 39 at 192 bp, then a tail. Created 2026-06-28.
  This is the source of the chapter's 970, 156, and 244 figures, and it is the
  direct evidence behind the DRB merge explanation.
- One input bundle inspected in full (`WD1_S148_L001.lungfishfastq`): a single
  10,182,215-byte `WD1_S148_L001.fastq.gz`, a meta JSON, and a provenance
  folder. Confirms the interleaved single-file paired storage ruling.
- Four finished genotype runs sit side by side: `amplicon-genotyping`,
  `_1`, `_2`, `_3`. Chapter figures come from `_3`.
- `_3` provenance (`.lungfish-provenance.json`): appVersion "Lungfish 2026.9.6 (1)",
  hostOS "macOS 26.6.2 (arm64)", exitStatus 0, wallTimeSeconds 329.05,
  workflowName "Illumina Paired Amplicon Genotyping", toolName
  "lungfish fastq genotype", 67 steps. The recorded `argv` is
  `fastq genotype-cohort` over all 30 bundles with `--mode illumina-paired
  --read-type illumina --threads 14 --sort-threads 4 --min-support 1
  --analysis-name amplicon-genotyping_3 --project <project>`. This is the source
  of the chapter's 329-second and 67-step figures and of the command shape in
  the command-line section.
- `_3` stats JSON: 2,854,092 input reads, 682,927 retained, 23.927995 percent,
  drop counts 224,134 unmapped / 311,914 not spanning / 296,843 mismatched /
  682,928 passed, `maxMismatches` 0, `allowIndels` true,
  `requireFullReferenceSpan` true, `assignmentMode` "query-prefix",
  `minSupport` 1.
- `_3` samples CSV (30 rows): retained reads range 2 to 58,370, retained
  percent 0.61 to 26.81. Six samples under 100 retained reads (2, 2, 4, 7, 12,
  76). Twenty-four between 14.17 and 26.81 percent.
- `_3` genotypes CSV: 2,109 rows across 30 samples, 2 to 117 rows per sample,
  median 80. 522 rows supported by a single read.
- `_3` `genotype-result.json`: `kind` and `workflowKind`
  "miseq-amplicon-mhc-genotype", `workflowMode` "genotypeOnly".
- Per-sample step logs confirm minimap2 loaded an index for 970 target
  sequences and that each sample got a minimap2 plus samtools sort pair.

Individual animals are not named beyond the `WD<n>_S<n>_L001` sample
identifiers, which are what a screenshot of the sidebar or the result table
shows.

## Source files consulted

- `Sources/LungfishApp/App/MainMenu.swift` (menu construction, lines 760-845)
- `Sources/LungfishApp/App/ToolsMenuModel.swift` (category and workflow model)
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift` (dialog dispatch)
- `Sources/LungfishApp/Services/WorkflowLibrary.swift` (catalog, maturity,
  required packs, default enablement)
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift`
  (every control label and group heading in both dialogs)
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift`
  (defaults, results directory names, `effectiveGenotypingMode`)
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
  (tool title, subtitle, category membership)
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift`
  (multi-bundle lock reason string)
- `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift`
  (the DRB zero-read rationale and the 2x251 / 198 bp insert arithmetic)
- `Sources/LungfishWorkflow/ONTGenotyping/AmpliconGenotypingMode.swift`
  (mode display names, including "Illumina sample bundles")
- `Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline.swift`
  (min-support handling, `haplotypeDropoutEvaluator`)
- `Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline+Scripts.swift`
  (`passes_strict_filter`, the four drop counters, `--min-support` parsing)
- `Sources/LungfishWorkflow/ONTGenotyping/GenotypeReviewableRowCatalogPublisher.swift`
  (the failing publish path)
- `Sources/LungfishIO/Storage/DurableAtomicFileStore.swift`
  (`openDirectoryHierarchy`)
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
  (minimap2 2.31, savont 0.6.3, BLAST 2.16.0, pack membership)
- `docs/user-manual/parameters.yaml` (both registry entries)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`
  (`fastq genotype`, `fastq genotype-cohort`,
  `fastq full-length-ont-mhc-genotype`)
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/09-genotyping.md`
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/ARCHITECTURE.md`, `STYLE.md`, `GLOSSARY.md`
- Style references: `chapters/06-classification/02-running-kraken2.md`,
  `03-running-esviritu.md`, `10-twelve-s-metabarcoding.md`
- Sibling chapters read but not edited: `09-genotyping/01`, `03`, `04`

## Glossary terms added

- `genotype-result-bundle`, inserted between "Genotype quality" and
  "Germline variant".
- `miseq`, inserted between "MinKNOW" and "mosdepth".

Both appear in the chapter's `glossary_refs` and are linked from the body.
Every other term in `glossary_refs` already existed.

## Defects found in Preview 2026.9.13

1. **Min Reads does nothing on a Genotype only run.** `--min-support 50` on
   run 5 left all 293 genotype rows in the CSV, all 293 rows in the workbook's
   Long Summary sheet, and 197 in the main sheet, exactly as run 4 with
   `--min-support 1` did. Rows supported by a single read survived. The value
   is written into `retained_demux_stats.json` as `minSupport: 50`, so it is
   carried but not applied. Root cause: `filter-demux-retained-bam.py`
   (`ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:51`) declares
   `--min-support` and uses it only to populate two stats fields at lines 571
   and 592, never as a filter predicate. The value reaches a real filter only
   through `haplotypeDropoutEvaluator`
   (`ONTBarcodeDemuxGenotypingPipeline.swift:328-341`), which the pipeline
   builds only when a haplotype threshold or definition is also in play. The
   chapter documents this plainly in Settings and in What good looks like
   rather than describing the intended behaviour.

2. **A run whose `--output-dir` sits under a world-writable directory fails at
   84 percent.** Runs 1, 2, and 3 all failed with "The genotype reviewable-row
   catalog output is outside the result bundle: <path>/artifacts/projections/
   genotype-reviewable-rows.json" after completing every expensive step. The
   same command with an output directory under `$HOME` succeeded. The message
   names the wrong cause, since the path it prints is plainly inside the
   bundle. `GenotypeReviewableRowCatalogPublisher.publishCatalogData` reaches
   the directory through `NoFollowFileSystem.openDirectoryHierarchy` and throws
   `outputOutsideBundle` from `openOrCreateDirectory` when the descriptor-
   relative open fails, which is what happens under `/private/tmp` (mode 1777)
   on this machine. Verified that plain `mkdir -p` of the same path succeeds,
   so it is the hardened open rather than permissions in the ordinary sense.
   Two costs to a user: the failure comes after all the work, and the message
   points at the wrong thing. The chapter warns about it in the command-line
   section.

3. **Ground-truth map correction.** The reality map's "Missing from this
   chapter" table claims `Savont Clustering` is a `Tools > Genotyping` item.
   It is not. `FASTQOperationDialogState.toolIDs(for:)` puts `.savont` and
   `.pbaa` under `.clustering`, and the Genotyping category holds only
   `.ontGenotyping` plus the two workflow-library entries (full-length ONT and
   12S). The chapter says nothing about Savont Clustering as a menu item, and
   this note records why the Missing row was not acted on.

## Not verified

- **No GUI verification.** Every dialog label, group heading, default, and
  caption in the chapter comes from the Swift source rather than from driving
  the app. The screenshot captions describe what the source says the dialogs
  render. A Screenshot Scout pass should confirm the five shots and correct any
  caption that does not match the window.
- **The full-length ONT route was not run.** No long-read MHC dataset was
  available. Every claim about it comes from
  `FullLengthONTMHCGenotypingPipeline.swift`, the dialog source, the CLI help,
  and the tool lock file. Its runtime, its cluster counts, and the shape of its
  result are therefore not quoted anywhere in the chapter, and no figure is
  attributed to it.
- **The Workflow Library enablement flow for the full-length route** was read
  from `WorkflowLibraryEnablementStore.defaultEnabledWorkflowIDs` and
  `MainMenu.workflowMenuItem`, not exercised. The "(not enabled)" wording and
  the "Open Workflow Library" button come from the source.
- **The `--preset mcm-mhc-miseq` path** was not run. Its behaviour and its
  conflict with `--reference` come from the CLI help and from
  `FastqGenotypingSubcommand.swift` as quoted in the reality map.
- **`--comparison-workbook`, `--comparison-name`, `--barcodes`, and
  `--demux-manifest`** were not exercised. Documented from CLI help alone.
- **Runtime figures are from one machine.** 329 s for 30 samples and 55 s for 3
  are the author's Apple Silicon Mac. The chapter frames them as such.
- **The four-sheet workbook** was read by unzipping the XLSX and listing sheet
  names and row counts. The cell contents of the main sheet were not parsed.
