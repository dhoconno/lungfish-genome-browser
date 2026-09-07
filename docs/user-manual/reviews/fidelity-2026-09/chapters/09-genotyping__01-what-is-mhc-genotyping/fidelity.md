# Fidelity review, 09-genotyping/01-what-is-mhc-genotyping

Chapter: `docs/user-manual/chapters/09-genotyping/01-what-is-mhc-genotyping.md`
Roster row 53, no registry ids (`parameters_refs: []`), build Preview 2026.9.13.

Reviewer inputs: the chapter, the author log, the ground-truth map
`ground-truth/09-genotyping.md:78-127`, the chapter's DRIFT section
`DRIFT.md:2960-3010`, `CONSISTENCY.md:105-131`, `cli-help/genotype.txt` and
`cli-help/fastq.txt`, the Swift source, `GLOSSARY.md`,
`docs/user-manual/build/mkdocs.yml`, the 12S chapter
`06-classification/10-twelve-s-metabarcoding.md`, the two concept-chapter
precedents `07-assembly/01-when-to-assemble.md` and
`06-classification/01-what-is-classification.md`, and the read-only Williams
project at `~/Desktop/lge-docs/32566_MS267_Williams1.lungfish`.

The author's one command was rerun live. `genotype list-samples` against
`amplicon-genotyping_3.lungfishgenotype` reproduces every figure the chapter
quotes: 30 sample rows, 23 `ok` and 7 `lowSupport`, `ok` reads 1,976 to 58,370,
`lowSupport` reads 2 to 713, `ok` loci 11 to 13, `lowSupport` loci 2 to 9, and
13 distinct locus names. The Williams bundle was read but never written to. No
GUI agent drove the app, so every viewport and menu claim is checked against
source.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "The MHC ... is a dense cluster of genes whose proteins hold up fragments of whatever is inside a cell for the immune system to inspect" | true | Standard immunology, and `GLOSSARY.md` `{#mhc}` carries the same definition | |
| 2 | "an amplicon run reads a chosen piece of the genome very deeply rather than reading the whole genome evenly" | true | Consistent with `GLOSSARY.md` `{#amplicon}` and the 156 bp panel in the Williams reference | |
| 3 | "LGE compares each read against a curated library of known allele sequences held as a FASTA file" | true | `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:315-364` filters alignments against reference records; the Williams reference is `26128_ipd-mhc-mamu-2021-07-09.lungfishref/genome/sequence.fa.gz` | |
| 4 | "a read that differs from every allele target by even one base is simply not counted" | true | `passes_strict_filter` at `:352-357` rejects on `mismatches > args.max_mismatches`, and the run's `maxMismatches` is `0` in `amplicon-genotyping_3.retained_demux_stats.json` | |
| 5 | "the Williams MiSeq genotyping project, a rhesus macaque study of 30 animals sequenced on an Illumina MiSeq" | true | `Imports/` holds 30 `.lungfishfastq` bundles `WD1`-`WD30` with `_S<n>_L001` Illumina suffixes; `genotype list-samples` returns exactly 30 rows | |
| 6 | "the run matched its reads against the IPD-MHC Mamu allele library dated 2021-07-09, which holds 970 allele targets" | true | The bundle name is `26128_ipd-mhc-mamu-2021-07-09.lungfishref`, and counting FASTA records in `genome/sequence.fa.gz` gives exactly 970 | |
| 7 | "a call reads as `01_Mamu-A1_001_05_01_01` rather than as a coordinate" | true | That exact record name is present in the library and in the bundle manifest's `browser_summary.sequences` | |
| 8 | "an animal carries at most two alleles at any one locus" | true | Standard genetics for a diploid autosomal locus | |
| 9 | "the class I loci reported are MHC-A, MHC-AG, MHC-B, MHC-E, MHC-F, MHC-G, MHC-I, and MHC-J, and the class II loci are MHC-DPA1, MHC-DPB1, MHC-DQA1, MHC-DQB1, and MHC-DRB" | true | The rerun `top_calls_by_locus` column yields exactly these 13 locus keys and no others. The class split is standard IPD-MHC convention (Mamu-A/AG/B/E/F/G/I/J class I, DP/DQ/DR class II). Note that no field in the bundle carries a class label, so the split is convention rather than app output | |
| 10 | "Which loci appear in your own result depends entirely on the allele library the run used rather than on any setting in LGE" | true | Locus keys are parsed from reference record names; no locus selector exists in `FASTQOperationToolPanes.swift:546-562` | |
| 11 | "LGE can also assign MHC haplotypes from called alleles. A worked example with an MCM dataset will be added in a later release of this manual." | true | Verbatim the two sentences `CONSISTENCY.md:118-120` mandates, under the mandated `## Haplotype analysis (placeholder)` heading | |
| 12 | "An allele name in a genotyping result is not something LGE composes. It is the record name from the FASTA library" | true | `GenotypeListSamplesSubcommand.swift:44` emits `$0.genotype` unchanged; the emitted strings match library record names byte for byte | |
| 13 | "A leading number groups records by locus" | true | The library carries 18 numeric prefixes `01` through `18`, each tracking one locus family (`01`=A1, `10`=DQB1, `12`=DPB1, `13`=E) | |
| 14 | "Many records carry a `g` and a list after a vertical bar, as in `01_Mamu-A1_001g1\|A1_001_01_01_01,A1_001_02`" | false | 362 of the 970 records carry the bar form, so "many" is right, but the quoted record is not the library's. The real record is `01_Mamu-A1_001g1\|A1_001_01_01_01,A1_001_01_01_02,A1_001_02`, with three members. The chapter drops the middle one while presenting the string as a quotation | Use the record verbatim: `01_Mamu-A1_001g1\|A1_001_01_01_01,A1_001_01_01_02,A1_001_02`. |
| 15 | "The amplicon this panel sequences is only about 156 bases long" | true | 577 of 970 records are exactly 156 bases, the single most common length, and every class I family (A, AG, E, F, G, I, J) is 156. "About" carries the MHC-B spread of 153 to 157 | |
| 16 | "several published alleles are identical to one another across that stretch while differing elsewhere in the gene. Because the reads cannot separate them, the library folds them into one record" | true | The `g` group records are exactly this construction, and each lists its members after the bar | |
| 17 | "Two allele targets in the library can be identical over the sequenced stretch even after grouping, so a read matching one matches both, and both appear in the result" | true | The rerun shows single samples carrying multiple co-reported records at one locus; the filter at `:352-357` has no uniqueness tie-break | |
| 18 | "Open **Tools > Genotyping** and you get a submenu holding three items, **miSeq amplicon MHC genotyping...**, **Full-length ONT MHC genotyping...**, and **12S Amplicon Matching**" | true | `FASTQOperationToolID.categoryID` puts only `.ontGenotyping` in `.genotyping`; `WorkflowLibraryCatalog` adds `fullLengthONTMHCGenotypingItem` and `twelveSAmpliconMatchingItem` with `categoryID: .genotyping`. `ToolsMenuModel.swift:59` gives the menu title `Genotyping`. Three items, confirming the author's defect 1 against the reality map | The submenu renders all three with a trailing ellipsis when enabled (`MainMenu.swift:826`), so the third reads `12S Amplicon Matching...`. The chapter shows the first two with ellipses and the third without. |
| 19 | "All three are specialized workflows, which means they do not appear ready to run until you enable them" | true | All three carry `.workflowOperations`, so `operationMenuItems` at `MainMenu.swift:804-806` filters every one of them out of the operations half, leaving only the workflow half. Confirms the author's defect 2 | |
| 20 | "An item you have not enabled shows in grey with `(not enabled)` after its name, and clicking it offers to enable it rather than opening a dialog" | true | `MainMenu.swift:832-841` composes `"\(workflow.title) (not enabled)"`, styles it `NSColor.disabledControlTextColor`, and wires `promptEnableWorkflowFromMenu` at `AppDelegate+ToolsMenu.swift:1740` | |
| 21 | "Enabling happens in the Workflow Library, which opens with **Tools > Workflow Library...**" | true | `MainMenu.swift:766-771` adds that exact title to the Tools menu. Matches the 12S chapter's route at `10-twelve-s-metabarcoding.md:78` | |
| 22 | "**miSeq amplicon MHC genotyping** is one workflow that handles both Illumina paired reads and ONT reads from a short-amplicon panel" | true | `FASTQOperationDialogState.swift:1982` titles the single `.ontGenotyping` tool that way, and `:2029` subtitles it "ONT barcode-demux or prepared Illumina sample bundles". Applies DRIFT rows 1.2 and 1.3 | |
| 23 | "It reports the mode it derived from your reads as a caption in its dialog rather than asking you to pick one" | true | `WorkflowOperationDialogState.swift:406-417` computes `effectiveGenotypingMode`, and `WorkflowOperationsDialog.swift:302-304` renders its `displayName` as read-only text (reality map row 2.10) | |
| 24 | "The MiSeq workflow needs Third-Party Tools and Read Mapping" | true | `WorkflowLibrary.swift:73-77` gives `.ontGenotyping` `requiredPluginPackIDs: ["lungfish-tools", "read-mapping"]`; `PluginPack.swift:441` names `lungfish-tools` "Third-Party Tools" and `:474` names `read-mapping` "Read Mapping" | |
| 25 | "minimap2 2.31, which is the program that actually aligns reads to the allele library" | true | `third-party-tools-lock.json:31` pins `minimap2=2.31` in `read-mapping`; `ONTGenotypingPipeline.swift:281` runs `tool: .minimap2` and `:661` records `"mappingTool": "minimap2"` | |
| 26 | "The full-length workflow needs those two plus Full-length MHC Genotyping, which supplies Savont 0.6.3 for clustering and BLAST 2.16.0" | true | `WorkflowLibrary.swift:155-161` lists all three pack ids; `PluginPack.swift:528` names the pack "Full-length MHC Genotyping"; lock lines 34-35 pin `savont=0.6.3` and `blast=2.16.0` | |
| 27 | "An alignment is retained only when it spans the allele target end to end, from the first base of the reference record to the last, with zero mismatches. Insertions and deletions are tolerated, substitutions are not." | true | `reference_span_is_full` at `:315-317` requires `reference_start == 0 and reference_end == ref_length`; `md_mismatch_count` at `:319-338` skips `^` deletion runs and counts only alphabetic substitutions; the run's `maxMismatches` is 0 and `allowIndels` is `true` | |
| 28 | "In the Williams run, 2,854,092 reads went in and 682,927 were retained, which is 23.9 percent" | true | `retained_demux_stats.json` gives `totalInputReads` 2854092, `retainedUniqueReads` 682927, `retainedUniquePercentOfTotalReads` 23.927995. Summing `passed_unique_reads` across the 30 rows of `retained-demux-samples.csv` gives 682,927 exactly | |
| 29 | "224,134 unmapped, 311,914 failing to span the reference end to end, and 296,843 carrying too many mismatches" | true | `passCounters` gives `unmapped` 224134, `not_full_reference_span` 311914, `too_many_mismatches` 296843. The counter names map to the three script branches at `:349-356` | |
| 30 | "a run where nearly everything passes is more likely to have been given a reference the reads came from than to be unusually clean" | unverifiable | An editorial judgement. No source, telemetry, or fixture establishes a pass-rate threshold. Reads as sound advice and makes no checkable claim | Would be settled only by run telemetry across projects, which the repository does not hold. |
| 31 | "In the IPD-MHC Mamu reference the class I amplicons are 156 bases and the DRB amplicons are 244" | true | `IlluminaAmpliconPairMerger.swift:14-16` states exactly this. Measured against the Williams library, class I records are 153 to 157 with 156 dominant (577 records) and DRB records span 211 to 247 with 244 dominant (198 records), so the two figures are the modes rather than universals | Optional precision: "the class I amplicons are 156 bases and the longest DRB amplicons are 244". |
| 32 | "with the usual chemistry neither mate alone covers 244 bases" | true | `IlluminaAmpliconPairMerger.swift:16-18`, "With 2x251 chemistry the sequenced insert is typically ~198 bp, so neither mate alone covers a 244 bp reference from position 0 to 244 exactly" | |
| 33 | "Left alone, every DRB allele would silently receive zero reads while every shorter locus genotyped normally" | true | `IlluminaAmpliconPairMerger.swift:18-20` states the silent zero-read outcome in those terms | |
| 34 | "The workflow therefore runs bbmerge first, joining each overlapping pair into one longer fragment before mapping, and mates that fail to merge are still carried through as singles" | true | `IlluminaAmpliconPairMerger.swift:27-32`, runs `bbmerge.sh` then feeds merged fragments to minimap2, and "Reads that fail to merge are retained as singles ... exactly as bbmerge's `outu` stream allows" | |
| 35 | "This happens without a setting" | true | The miSeq pane at `FASTQOperationToolPanes.swift:546-562` exposes Report Name, Analysis Name, Threads, and Min Reads only. No merge control | |
| 36 | "Both workflows write a `.lungfishgenotype` bundle" | true | cli-help `fastq.txt` `--output-dir` "Output .lungfishgenotype bundle directory" on both `fastq genotype` and `fastq full-length-ont-mhc-genotype` (reality map row 1.21) | |
| 37 | "The bundle lands under the project's `Analyses/` folder, and the MiSeq workflow gathers its runs into an `Amplicon genotyping results` subfolder inside it" | true | `WorkflowOperationDialogState.swift:1543` sets `ontGenotypingResultsDirectoryName = "Amplicon genotyping results"`, and the Williams project holds exactly that path. Correctly scoped to MiSeq: the full-length route uses `"Full-length ONT MHC genotyping results"` at `:1544` | |
| 38 | "Its central view is a grid with one row per allele target and one column per sample, so a filled cell says that sample carried that allele and holds the retained read count behind it" | true | `GenotypeComparisonMatrixView.swift` builds the allele-by-sample grid, and `GenotypeCallEvidenceView.swift:915` renders `Text("\(row.reads)")` per allele row (reality map row 3.12) | |
| 39 | "A run that produced allele calls and nothing else, which is what the Williams project holds, offers a single **Genotype Matrix** view" | true | `GenotypeResultPresentationPolicy.swift:98-106`, `choices` returns `[.genotypeMatrix]` when `isGenotypeOnlyResult`. The Williams `genotype-result.json` declares `workflowMode: genotypeOnly`. Display name `Genotype Matrix` at `:24-27` | Source nuance the chapter need not carry: `isGenotypeOnlyResult` is set from `manualHaplotypeEligibility == .eligible` at `:64-68`, not read straight off `workflowMode`. |
| 40 | "A run that also carried out haplotype analysis offers a two-way control with **Haplotype Calls** beside **Genotype Matrix**" | true | `GenotypeResultPresentationPolicy.swift:99-101` returns `[.haplotypeCalls, .genotypeMatrix]` when `appliesToHaplotypedMiSeq`, with those two display names at `:23-27` (reality map row 3.3) | |
| 41 | "If you are looking for a Haplotype Calls segment and cannot find one, the run did not haplotype rather than the view being hidden" | true | `choices` is the only source of segments, and it omits `.haplotypeCalls` unless a usable analysis is present (`appliesToHaplotypedMiSeq` at `:90-92`) | |
| 42 | "chiefly a per-sample summary and a long-form table with one row per sample and allele target" | true | `amplicon-genotyping_3.retained-demux-samples.csv` is keyed on `sample`; `...retained-demux-genotypes.csv` is keyed on `sample,genotype` | |
| 43 | "The Williams result's long table holds 2,109 such rows across its 30 samples" | true | `csv.reader` over `retained-demux-genotypes.csv` gives 2,110 lines, so 2,109 data rows, across 30 distinct sample values | |
| 44 | "An Excel workbook is written alongside them" | true | `amplicon-genotyping_3.xlsx` sits in the bundle, and cli-help `fastq.txt` `--output-dir` names a workbook among the outputs | |
| 45 | "Both workflows report progress into the Operations panel while they run, and the main window stays usable throughout" | true | Reality map row 2.17, both operations report into `OperationCenter` per project convention | |
| 46 | "A sample that produced no usable reads still gets a row" | true | The rerun returns 30 rows including a `lowSupport` sample at 2 reads, and `GenotypeListSamplesSubcommand.swift:39` iterates `result.samples` without filtering | |
| 47 | "the 23 samples marked `ok` carried between 1,976 and 58,370 retained reads, and the 7 marked `lowSupport` carried between 2 and 713" | true | Reproduced live. The `qc_status` vocabulary is exactly `ok` and `lowSupport` | The column the CLI prints as `total_reads` is `sample.passedAlignments` (`GenotypeListSamplesSubcommand.swift:47`), not retained unique reads. In this run the two coincide at both range endpoints, and differ by 1 on a single interior sample (WD17, 42,022 against 42,021), so the quoted figures stand. |
| 48 | "the samples that sequenced well carry calls at 11 to 13 loci, while the lowSupport samples carry as few as 2" | true | Reproduced live. `ok` loci 11 to 13, `lowSupport` loci 2 to 9 | |
| 49 | "The bundle's provenance record names the reference file the run read" | true | `retained_demux_stats.json` carries `referenceFasta` pointing at the `.lungfishref` `genome/sequence.fa.gz`, and `retained_demux_provenance.json` sits beside it | |
| 50 | "There is no quality score on a call, because a call is an exact match or nothing" | true | The genotypes CSV columns are read counts and percentages only, with no score field, consistent with the zero-mismatch filter | |
| 51 | "The genotype viewport also carries a manual haplotyping mode for assigning haplotypes by hand. This manual does not cover it." | true | `GenotypeManualHaplotypeEditor.swift:29-50` exists. One sentence plus the disclaimer, honouring the owner's placeholder constraint | |
| 52 | Front matter `entry_points` "Tools > Genotyping > miSeq amplicon MHC genotyping..." and "Tools > Genotyping > Full-length ONT MHC genotyping..." | true | Applies DRIFT changed row 1.1 exactly. Both titles match `FASTQOperationDialogState.swift:1982` and `WorkflowLibrary.swift:152` | |
| 53 | Shot caption `genotyping-submenu`, "the three specialized workflows it holds ... with any workflow that is not yet enabled shown in grey followed by (not enabled)" | true | Source-consistent with `MainMenu.swift:826-841`. Not observed, since no screenshot was captured | The caption writes `12S Amplicon Matching` without the ellipsis the enabled form carries. Either drop all three ellipses or add the third. |
| 54 | Shot caption `genotype-matrix-overview`, "allele-target rows down the left named by their reference record and one column per sample across the top" | true | Applies the reality map's own screenshot correction for this shot (`ground-truth/09-genotyping.md:278`). Not observed | |
| 55 | Nav addition, four chapters under a `Genotyping` part in `build/mkdocs.yml` using roster titles | true | `mkdocs.yml:133-137` carries all four under roster row 53 to 56 titles | Three of the four nav labels differ from the target files' own `title:` front matter (`Running Amplicon MHC Genotyping`, `Reading the Genotype Comparison Viewport`, `Haplotype Definitions, AI-Assisted Haplotyping, and Export`), so the sidebar label and the page heading will disagree until rows 54 to 56 are retitled. The author flagged this for row 56 only. |
| 56 | Author report, "Six `.lungfishgenotype` bundles from repeated runs" | false | The folder holds seven: `amplicon-genotyping`, `_1`, `_2`, `_3`, `finalcheck`, `spacefix`, `spacefix2`. Author log only, not in the chapter, so no reader is affected | Seven bundles. |
| 57 | Author report, "lengths from 153 to 251 bases across 23 distinct values" | false | Measured range is 153 to 247 across 23 distinct values. Author log only, not in the chapter | 153 to 247 bases across 23 distinct values. |

## Front matter

`parameters_refs: []` is correct. The reality map records that no genotyping
operation is registered in `parameters.yaml`, and roster row 53 carries an empty
registry column, so no Settings section is owed.

All 20 `glossary_refs` anchors resolve to exactly one `{#anchor}` in
`GLOSSARY.md`. All four relative chapter links resolve to files that exist. Both
`<!-- SHOT: -->` markers have matching `shots[]` entries and captions, and no
`planned_shots` key survives, so this chapter uses the template convention the
row-52 review found the corpus splitting on. `alleles-vs-haplotypes-schematic`
is dropped as the map directs.

`tools: []` and `features_refs: []` and `fixtures_refs: []` are empty. The
chapter runs nothing and names no `features.yaml` id, which is consistent, but
the Williams project is a named CONSISTENCY fixture and the two committed
concept precedents also leave `fixtures_refs` empty, so this matches precedent.

## Consistency

Section order is What it is, Why you would do this, three concept sections, the
haplotyping placeholder, What good looks like, Next. Both committed concept
precedents run What it is, Why you would do this, a middle run of concept
sections, What good looks like, Next. `07-assembly/01-when-to-assemble.md` and
`06-classification/01-what-is-classification.md` each drop Before you start,
Procedure, Settings, and On the command line for the same reason. The order
matches.

The haplotyping placeholder is verbatim the two sentences and the exact heading
`CONSISTENCY.md:118-120` mandates.

The fixture is named "the Williams MiSeq genotyping project" on first use, which
is the CONSISTENCY name at `:127`.

"Lungfish Genome Explorer (LGE)" appears once at first mention and every later
reference is LGE. The bare word "Lungfish" appears zero times.

Zero em dashes, zero semicolons, zero in-sentence colons. The only colons are
inside the two shot markers. One numbered list of four in What good looks like,
no other list, so the 5-per-list and 2-per-section caps hold.

The Workflow Library route matches the 12S chapter exactly. Both say the
Workflow Library enables and the Tools menu runs, both name
`Tools > Workflow Library...`, and both describe the grey `(not enabled)` item
and the enable prompt. `10-twelve-s-metabarcoding.md:78-80` is the fuller
treatment and this chapter's shorter one does not contradict it.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports `no issues found`, reproducing the author's result.

## App defects

The author reported four. Three are app or docs defects and all three reproduce.
The fourth is a manual defect that reproduces but was already on record.

1. **The reality map files `Savont Clustering` under Genotyping. It is not
   there.** Reproduces. `WorkflowLibrary.swift:65-71` builds Savont's item
   through the `toolID` initialiser, so `:41` takes its `categoryID` from
   `FASTQOperationToolID.savont.categoryID`, which the `categoryID` switch in
   `FASTQOperationDialogState.swift` gives as `.clustering` on the shared
   `case .savont, .pbaa:` line. Savont appears under **Tools > Clustering**
   beside pbAA. The Genotyping submenu holds exactly three items. The chapter is
   right and the map is wrong. The same wrong Missing row appears in the map's
   chapter 02 section (`ground-truth/09-genotyping.md:191`) and in DRIFT, so it
   should be corrected before the row-54 author uses it.

2. **Every item in the Genotyping submenu is a specialized workflow needing
   enablement.** Reproduces. `.genotyping` holds only `.ontGenotyping` among
   tool ids, and that tool carries `.workflowOperations`, so
   `operationMenuItems` at `MainMenu.swift:804-806` filters it out of the
   operations half. Both library-only items carry the same capability. The
   category therefore has no always-available operation, and a reader arriving
   with nothing enabled sees three grey rows and no separator above them.
   Neither the map nor DRIFT records this. This is app behaviour working as
   designed rather than a bug, but it is a genuine first-contact trap and the
   chapter is right to state it.

3. **The `haplotype`, `mhc`, and `allele` glossary entries carried the retired
   six-locus MCM model.** Reproduces as fixed. All three now read free of any
   locus list, and none names MHC-E as a reported locus. This is the correct
   resolution of DRIFT rows 1.10 and 1.11.

4. **The Genotyping part was absent from the public navigation.** Reproduces as
   fixed for the four genotyping chapters. Note for the record that the row-52
   fidelity review had already found `mkdocs.yml` misfiling
   `Running External Workflows` (see the new defect below), so the nav was
   partly wrong before this author touched it.

New defect found in this review, not in the author's list.

5. **The new `Genotyping` block was inserted above an already-misfiled nav
   line, leaving `Running External Workflows` orphaned inside it.**
   `mkdocs.yml:138` places `Running External Workflows`
   (`chapters/08-workflows/03-running-external-workflows.md`) as the last line
   of the `Genotyping:` block. The `Workflows:` block now closes at `:131` with
   only two chapters. The row-52 reviewer already logged this line as misfiled,
   so this author did not create it, but inserting the Genotyping block at
   `:133` cemented it: the sidebar will show a Workflows chapter after
   `Exporting Genotypes`, and that chapter's own closing sentence says it is the
   last chapter in Workflows. One-line move, and whoever makes it should move
   the line up into `Workflows:` rather than deleting it.

## Notes for the editor

**The group-record example is not verbatim.** Claim 14. The chapter writes
`01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_02` where the library's record is
`01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_01_01_02,A1_001_02`. The middle member
is dropped. The paragraph's whole argument is that a long name is one call and
not several, so it is exactly the sentence where a shortened string undercuts
the point. This is the one substantive correction the chapter needs. The other
quoted record, `01_Mamu-A1_001_05_01_01`, is verbatim correct.

**The two amplicon lengths are modes, not universals.** Claim 31. The chapter
quotes the merger docstring's 156 and 244 as flat facts about the reference. In
the Williams library class I records run 153 to 157 and DRB records run 211 to
247. Both quoted values are the dominant length in their group (577 records at
156, 198 at 244), and the DRB argument only needs the longest DRB amplicon to
exceed a single mate, so the reasoning survives intact. If the editor wants
precision without adding length, "the longest DRB amplicons are 244" does it.

**The shot caption is inconsistent about the ellipsis.** Claims 18 and 53. The
body and the caption both write the first two submenu items with a trailing
ellipsis and the third without. `MainMenu.swift:826` appends the ellipsis to
every enabled workflow item, so all three carry it. Either add it to the third
or drop it from all three, in both places.

**The shot id `genotype-matrix-overview` is now used by two chapters.** This
chapter carries it as a live `<!-- SHOT: -->` marker; chapter 55
(`03-reading-the-genotype-comparison.md:14,45`) carries the same id as a
`planned` marker with its own differing caption. `STYLE.md` does not require
globally unique shot ids, so this is not a lint failure, but the Screenshot
Scout will capture one image for two captions. Worth deciding now which chapter
owns the id.

**Three nav labels will not match their pages.** Claim 55. Rows 54, 55, and 56
are all listed under roster titles in `mkdocs.yml` while the files still carry
their older `title:` values. The author flagged only row 56. All three retitles
are owed, and until they land the sidebar and the page heading disagree on three
of the four chapters in the new part.

**The class I and class II split has no source in the app.** Claim 9. The split
is correct by IPD-MHC convention, but the bundle carries locus names with no
class label anywhere, so a later reviewer will not find a field to check it
against. The author already recorded this. No change wanted, since the
convention is stable and the chapter needs the distinction to explain class I
and class II at all.

**One claim is editorial rather than checkable.** Claim 30, that a run where
nearly everything passes more likely used a reference the reads came from. It is
sound reasoning and reads as advice rather than as a measurement, so it does not
need a hedge, but nothing in the repository settles it.

## Counts

57 claims checked. 54 true, 2 false, 1 unverifiable.

False claims: 14 (the `g` group record example drops a member and is not the
library's record), and 56 and 57, both author-log-only arithmetic slips that
reach no reader (seven bundles not six, library lengths 153 to 247 not 153 to
251).

Unverifiable: 30 (the pass-rate heuristic, settled only by cross-project run
telemetry the repository does not hold).

Defects: 4 reported by the author, all 4 reproduce, 1 of them (defect 2) more
precisely an as-designed trap than an app bug. 1 new defect found, the orphaned
`Running External Workflows` nav line the new Genotyping block encloses.

Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues found.
