# Author report: 09-genotyping/01-what-is-mhc-genotyping

Roster row 53. Concept chapter opening the Genotyping part. Rewritten in place
against Preview 2026.9.13 on 2026-09-07.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/09-genotyping/01-what-is-mhc-genotyping.md
```

Result, verbatim, on the first run and unchanged after the glossary and nav
edits:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/01-what-is-mhc-genotyping.md: no issues found
```

## Section order chosen

What it is, Why you would do this, Alleles/loci/haplotypes, Haplotype analysis
(placeholder), How allele names are built, What LGE offers and where it lives,
What counts as a supporting read, What a finished run looks like, What good
looks like, Next.

This follows the concept-chapter shape the committed
`07-assembly/01-when-to-assemble` and `06-classification/01-what-is-classification`
established: the two fixed opening sections, a run of concept sections in the
middle, then What good looks like and Next.

Sections deliberately dropped, with the reason each:

- **Before you start.** The chapter runs nothing and the reader needs no
  project, no fixture download, and no plugin pack to read it. Both model
  concept chapters drop it for the same reason.
- **Procedure.** No procedure exists here. Running a genotyping job is roster
  row 54's chapter, and repeating steps would create a second walkthrough to
  keep in sync.
- **Settings.** The roster gives this chapter no `parameters_refs`, and the
  reality map records that no genotyping operation is registered in
  `parameters.yaml` at all. `parameters_refs: []` is in the front matter.
- **On the command line.** CONSISTENCY's fixed CLI paragraph opens the
  command-line section of a *procedure* chapter. This chapter teaches no
  procedure to reproduce.
- **What you will learn.** Present in the old text. Cut because it restated the
  front matter's `task` and neither model chapter carries one.

## Commands run

One command ran. A concept chapter may run nothing, but the CLI offers a
read-only summary of a genotype result, so it was run against the Williams
project as instructed.

| # | Command | Exit | Figures taken from it |
|---|---|---|---|
| 1 | `.build/debug/lungfish-cli genotype list-samples --bundle "…/Analyses/Amplicon genotyping results/amplicon-genotyping_3.lungfishgenotype"` | 0 | 30 sample rows; 23 `ok` and 7 `lowSupport`; `ok` retained reads 1,976 to 58,370; `lowSupport` 2 to 713; `ok` samples carry calls at 11 to 13 loci, `lowSupport` at 2 to 9; the 13 locus names |
| 2 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh …` | 0 | the lint line above |

Command 1's output columns are `animal_id`, `gs_id`, `qc_status`,
`total_reads`, `top_calls_by_locus`. The `qc_status` vocabulary observed is
exactly `ok` and `lowSupport`. No animal or sample identifier is named in the
chapter body.

## What was read from the Williams project

Read-only throughout. Nothing was copied out of it and no reads were moved.

- `metadata.json`. Project name `32566_MS267_Williams1`, created 2026-09-01.
- `Imports/`. 30 `.lungfishfastq` bundles, `WD1` through `WD30`, each with an
  `_S<n>_L001` Illumina suffix. The chapter says 30 animals and names no
  individual sample.
- `26128_ipd-mhc-mamu-2021-07-09.lungfishref/manifest.json`. The allele library.
  **970 records**, lengths from 153 to 251 bases across 23 distinct values, with
  18 numeric locus-group prefixes. Record names such as
  `01_Mamu-A1_001_05_01_01` and the group form
  `01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_02`. This is the source for the
  chapter's account of how allele names are built and what a `g` group means.
- `Analyses/Amplicon genotyping results/`. Six `.lungfishgenotype` bundles from
  repeated runs. `amplicon-genotyping_3` was read as the representative one.
- `…/amplicon-genotyping_3.lungfishgenotype/genotype-result.json`.
  `kind` and `workflowKind` are both `miseq-amplicon-mhc-genotype`, and
  `workflowMode` is `genotypeOnly`. This is the evidence behind the chapter's
  statement that a genotype-only result offers a single **Genotype Matrix**
  view and no **Haplotype Calls** segment. Also records three workbook
  revisions and a `currentWorkbookPath` of `artifacts/workbooks/current.xlsx`.
- `…/amplicon-genotyping_3.retained_demux_stats.json`. The run's own tally.
  `totalInputReads` 2,854,092; `retainedUniqueReads` 682,927;
  `retainedUniquePercentOfTotalReads` 23.928; `passCounters` of `unmapped`
  224,134, `not_full_reference_span` 311,914, `too_many_mismatches` 296,843,
  `passed` 682,928. Settings recorded as `maxMismatches` 0, `minSupport` 1,
  `allowIndels` true, `requireFullReferenceSpan` true. Every retention figure
  in the chapter comes from this file.
- `…/amplicon-genotyping_3.retained-demux-genotypes.csv`. 2,109 data rows
  across 30 distinct samples, counted with `csv.reader`.
- `…/amplicon-genotyping_3.retained-demux-samples.csv`. Per-sample passed
  alignments and retained percentages.
- `…/annotations.json`. Schema version 4, every annotation list empty, which is
  consistent with a `genotypeOnly` run nobody had yet reviewed.
- `.lungfish-provenance.json` and `provenance/` were listed but not parsed in
  detail. The chapter's one provenance claim is that the record names the
  reference file, which the stats JSON's `referenceFasta` field confirms
  independently.

## Source files consulted

- `Sources/LungfishApp/App/MainMenu.swift:760-845`. Tools menu construction.
  `categoryToolsMenuItem` builds one submenu per category, `operationMenuItems`
  **filters out** any tool whose `WorkflowLibraryItem` carries
  `.workflowOperations`, and `workflowMenuItem` renders a not-yet-enabled
  workflow in grey with `(not enabled)` appended and a prompt-to-enable action.
  Workflow Library is a separate item in the Tools menu, not a launcher.
- `Sources/LungfishApp/App/ToolsMenuModel.swift:25-80`. Category assembly, and
  `menuTitle` giving the literal string `Genotyping`.
- `Sources/LungfishApp/Services/WorkflowLibrary.swift:137-186`. The two
  specialized genotyping items, their titles, subtitles, and required plugin
  pack IDs.
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:1286`,
  `:1982`, `:2029`, `:2073`. The `.genotyping` category holds exactly
  `[.ontGenotyping]`, whose title is `miSeq amplicon MHC genotyping` and whose
  subtitle names "ONT barcode-demux or prepared Illumina sample bundles".
- `Sources/LungfishGenotypeUI/GenotypeResultPresentationPolicy.swift:15-135`.
  `choices` returns `[.haplotypeCalls, .genotypeMatrix]` for a haplotyped MiSeq
  result and `[.genotypeMatrix]` for a genotype-only one, with display names
  `Haplotype Calls` and `Genotype Matrix`.
- `Sources/LungfishGenotypeUI/GenotypeManualHaplotypeEditor.swift:29-50`. Read
  only far enough to confirm the manual haplotyping surface exists, since the
  owner's constraint limits it to one placeholder sentence.
- `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift:1-40`.
  The bbmerge step and its rationale. This file states the amplicon lengths
  directly: class I 156 bp, DQB1/DPA1/DPB1/DQA1 154-204 bp, **DRB 244 bp**, and
  a typical ~198 bp insert on 2x251 chemistry, hence the silent DRB zero-read
  hole the merge prevents.
- `Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:316-364`.
  `reference_span_is_full`, `md_mismatch_count`, and `passes_strict_filter`.
  The retention rule and the exact counter names quoted from the stats file.
- `Sources/LungfishWorkflow/Conda/PluginPack.swift:441-560`. Pack display names,
  `Third-Party Tools`, `Read Mapping`, and `Full-length MHC Genotyping`.
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`.
  Version `2026.9.13`. minimap2 2.31 in `read-mapping`; Savont 0.6.3 and BLAST
  2.16.0 in `full-length-mhc-genotyping`.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/genotype.txt` and
  `fastq.txt`. Subcommand inventory and the `list-samples` contract.

Review inputs read in full: `ARCHITECTURE.md`, `CONSISTENCY.md`, the
`09-genotyping` reality map, the chapter's DRIFT section, the two model concept
chapters and both their `fable-gate.md` files, and
`.claude/agents/bioinformatics-educator.md`.

## Corrected wordings applied

Every corrected wording in the chapter's DRIFT section is honoured.

- 1.1, 1.2, 1.3. Front-matter `entry_points` now read
  `Tools > Genotyping > miSeq amplicon MHC genotyping...` and
  `Tools > Genotyping > Full-length ONT MHC genotyping...`. The body says two
  MHC workflows, states plainly that `miSeq amplicon MHC genotyping` handles
  both Illumina and ONT short-amplicon reads despite its name, and separates
  the Workflow Library's enabling role from the Tools menu's running role in
  its own paragraph.
- 1.8. "hundreds" dropped. The Williams library's 970 records are quoted
  instead, from the manifest.
- 1.12. The `0068[MHC-A1]` identifier form is gone from the chapter and from
  the glossary. Names are the FASTA record name, shown as
  `01_Mamu-A1_001_05_01_01`, with a section explaining the convention.
- 1.20. The full-length route is described as clustering with Savont. pbAA is
  not named, since it is a separate operation and this concept chapter does not
  need it.
- 1.9 through 1.18 (the haplotyping rows). All reduced to CONSISTENCY's fixed
  two-sentence placeholder, verbatim. No M-family list, no six-locus claim, no
  H1/H2 slots, no overcall guard, no fenced M1 block.

## Missing rows covered

- The zero-mismatch, full-reference-span retention rule. Its own section, with
  the Williams run's four pass counters as the worked figures.
- bbmerge pair merging and the DRB failure it prevents. Same section, with the
  156 and 244 base figures from the merger's own documentation.
- The plugin packs both workflows require, by their Plugin Manager display
  names, with minimap2 2.31, Savont 0.6.3, and BLAST 2.16.0 named.
- `12S Amplicon Matching` as the third item in the Genotyping submenu, with a
  link to its own chapter and a sentence saying why it is filed there.

Two Missing rows were **not** applied, both because the source contradicts the
reality map. See defects below.

Three Missing rows belong to the haplotyping placeholder and are therefore out
of scope by the campaign decision: the `mcm-mhc-miseq` locked preset,
`evidenceWeights`, and the `primaryAlleles` versus `diagnosticAlleles`
distinction. All three are properties of the MCM haplotype definition set.

The `parameters_refs` row is satisfied by carrying `parameters_refs: []`, which
matches roster row 53's empty registry column.

## Shot markers

Two, both on windows.

- `genotyping-submenu`. Replaces the retired `workflow-library-genotyping`
  planned shot. Recaptioned to the Tools > Genotyping submenu with its three
  workflows and the grey `(not enabled)` styling, per the reality map's
  screenshot table.
- `genotype-matrix-overview`. New here, borrowed from chapter 55's planned
  shot list, because this chapter shows the reader what a finished run looks
  like. Captioned to the Williams result with allele-target rows named by
  reference record, which is the reality map's own correction to that caption.

`alleles-vs-haplotypes-schematic` is dropped as the reality map directs. Both
markers have matching `shots` entries and captions, and no `planned_shots` key
survives.

## Defects found

1. **The reality map and DRIFT both place `Savont Clustering` in the Genotyping
   category.** It is not there.
   `WorkflowLibrary.swift:166-171` builds Savont's item through the
   `toolID`-based initialiser, so `WorkflowLibrary.swift:41` sets its
   `categoryID` from `FASTQOperationToolID.savont.categoryID`, which
   `FASTQOperationDialogState.swift:2065` gives as `.clustering`. Savont
   therefore appears under **Tools > Clustering**, beside pbAA. The Genotyping
   submenu holds exactly three items. The chapter states the three and does not
   repeat the map's claim. This affects the same Missing row in chapters 54's
   map section and should be corrected there before that author uses it.

2. **Every item in the Genotyping submenu is a specialized workflow needing
   enablement.** The category's only `FASTQOperationToolID` is `.ontGenotyping`,
   which carries `.workflowOperations` and is therefore filtered out of the
   operations half of the submenu by `MainMenu.swift:804-806`. So unlike
   Classification or Assembly, this submenu has no always-available items, and a
   reader arriving with nothing enabled sees three grey rows. Neither the map
   nor DRIFT records this, and it is the likeliest first-contact confusion in
   the part. The chapter states it explicitly.

3. **The `haplotype`, `mhc`, and `allele` glossary entries carried the retired
   six-locus MCM model**, naming MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and
   MHC-DP as the loci an M-family spans. DRIFT rows 1.10 and 1.11 establish
   that the built-in definition set has five reported loci and that MHC-E is a
   source locus folded into the MHC-A group. All three entries are rewritten
   free of the locus list. `allele`'s "individual MiSeq target identity" was
   also replaced, since the assay is not MiSeq-only.

4. **The Genotyping part was absent from the public navigation entirely.**
   All four chapters existed on disk and none was reachable from
   `build/mkdocs.yml`.

## Nav change

`docs/user-manual/build/mkdocs.yml` gains a `Genotyping` part after `Workflows`
and before `Reference`, with all four chapters in file order under their roster
titles:

```yaml
  - Genotyping:
    - What Is MHC Genotyping: chapters/09-genotyping/01-what-is-mhc-genotyping.md
    - Running Genotyping: chapters/09-genotyping/02-running-genotyping.md
    - Reading the Genotype Comparison: chapters/09-genotyping/03-reading-the-genotype-comparison.md
    - Exporting Genotypes: chapters/09-genotyping/04-haplotype-definitions-and-export.md
```

The three sibling chapter files were not edited. They are linked by their
current file names and each is described in one sentence from its roster title.
Note for whoever gates row 56: its nav label is the roster's `Exporting
Genotypes` while the file still carries the old title in its front matter, so
the retitle is still owed.

## Glossary terms added

Seven new entries, each one sentence, alphabetised into the existing sections,
and every one listed in `glossary_refs`:

`allele-target`, `bbmerge`, `class-i-mhc`, `class-ii-mhc`, `ipd-mhc`, `locus`,
`retained-read`.

Four existing entries were corrected rather than added: `allele`, `haplotype`,
`mhc` (defect 3 above), and no change was needed to `genotype-matrix`, whose
description of allele-target rows by sample columns is accurate.

All twenty anchors in `glossary_refs` were verified to resolve to exactly one
`{#anchor}` in `GLOSSARY.md`, and all five relative chapter links were verified
to point at files that exist.

## What could not be verified

- **The two shots.** Neither was captured. Screenshots are Phase 5 work and the
  markers are left in place for the Screenshot Scout. The submenu caption
  predicts grey `(not enabled)` rows from `MainMenu.swift:832-841`, which is a
  source reading rather than an observation, and the scout should confirm the
  styling on a machine where the workflows are off.
- **The full-length ONT route on real data.** The Williams project contains no
  full-length run, and no full-length fixture exists in the manual. Every
  statement about that route comes from source and the tool lock, and the
  chapter makes no numeric claim about it.
- **What the Genotype Matrix view looks like in the running app.** The claim
  that a genotype-only result offers one view and no Haplotype Calls segment is
  read from `GenotypeResultPresentationPolicy.swift` plus the Williams bundle's
  `workflowMode: genotypeOnly`. It was not confirmed by opening the app.
- **The class I and class II assignment of the 13 Williams loci.** The split
  given in the chapter follows standard immunological classification rather
  than a field in the bundle. The result's own data carries locus names only,
  with no class label anywhere, so a reviewer wanting a source-backed split
  will not find one in the app.
- **Timing.** The run's `wallClockSeconds` of 97.8 was read but not quoted,
  since it describes one machine under unknown load and the assembly gate's
  ruling treats runtime as not a check.
