# Reality map: 09-genotyping

Covers the four chapters under `docs/user-manual/chapters/09-genotyping/`.
There is no June 2026 map for this part. These chapters were written after that
pass, so every row here is a first verification against current source.

## Campaign decision recorded at the top of this map

The genotyping chapters will be rewritten as a genotyping-only example on a
rhesus MiSeq project. Haplotype analysis, meaning MCM M-family haplotyping, is
covered only by a placeholder section. Every haplotyping claim below still
carries a verdict, because the verdict is the record of what the code does. Its
corrected-wording cell is marked `haplotyping (placeholder scope)` so the
rewriter knows the row is not to be worked into prose. Rows about running a
genotyping operation, about the genotype viewport as a genotype surface, and
about export are in scope and carry real corrected wording.

## The single largest finding

Chapters 01 through 04 describe a three-route workflow family, a Summary,
Review, and Audit lens viewport, and a six-locus MCM haplotype model. The app
has one MiSeq genotyping operation whose display title is literally
`miSeq amplicon MHC genotyping`, a second full-length ONT operation, a MiSeq
viewport whose only two views are `Haplotype Calls` and `Genotype Matrix`, and a
built-in MCM definition set with five reported loci, not six. MHC-E is a source
locus folded into the MHC-A haplotype group, never a reported locus of its own.

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/ToolsMenuModel.swift`
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift`
- `Sources/LungfishApp/Services/WorkflowLibrary.swift`
- `Sources/LungfishApp/Services/GenotypeAIHaplotypingExecutionService.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/ONTGenotypingPipeline.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline+Scripts.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCGenotypingPipeline.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTPBAAArtifactPlanner.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/MCMHaplotypingPreset.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/AIHaplotypingTypes.swift`
- `Sources/LungfishWorkflow/ONTGenotyping/AIHaplotypingPromptRegistry.swift`
- `Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref/haplotypes/mcm-mhc-miseq-20260617.lungfishhaplotypedef.json`
- `Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref/mcm_mhc_miseq_reference.trimmed.unique.fasta`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `Sources/LungfishGenotypeUI/GenotypeResultViewController.swift`
- `Sources/LungfishGenotypeUI/GenotypeResultPresentationPolicy.swift`
- `Sources/LungfishGenotypeUI/GenotypeResultDisplayState.swift`
- `Sources/LungfishGenotypeUI/GenotypeResultDisplaySection.swift`
- `Sources/LungfishGenotypeUI/GenotypeComparisonMatrixView.swift`
- `Sources/LungfishGenotypeUI/GenotypeHaplotypeTapeView.swift`
- `Sources/LungfishGenotypeUI/GenotypeOutlineView.swift`
- `Sources/LungfishGenotypeUI/GenotypeManualHaplotypeEditor.swift`
- `Sources/LungfishGenotypeUI/GenotypeHaplotypeDefinitionEditor.swift`
- `Sources/LungfishGenotypeUI/GenotypeHaplotypeDefinitionMatrixView.swift`
- `Sources/LungfishGenotypeUI/GenotypeQuickFilterBarView.swift`
- `Sources/LungfishGenotypeUI/GenotypeSmartCohortSection.swift`
- `Sources/LungfishGenotypeUI/GenotypeCohortSummaryPanelView.swift`
- `Sources/LungfishGenotypeUI/GenotypeCallEvidenceView.swift`
- `Sources/LungfishGenotypeUI/GenotypeViewportExportService.swift`
- `Sources/LungfishGenotypeUI/GenotypeOverrideSection.swift`
- `Sources/LungfishIO/Bundles/GenotypeAnnotationSidecar.swift`
- `Sources/LungfishIO/Bundles/MHCReferenceRecordCatalog.swift`
- `Sources/LungfishCLI/Commands/GenotypeExportXLSXSubcommand.swift`
- `Sources/LungfishCLI/Commands/GenotypeExportLabKeySubcommand.swift`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/genotype.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/haplotypes.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`
- `docs/user-manual/features.yaml`
- `docs/user-manual/parameters.yaml`

---

## 01-what-is-mhc-genotyping.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1.1 | "Workflow Library > miSeq amplicon MHC genotyping" (frontmatter `entry_points`) | changed | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:1982` gives the tool title `miSeq amplicon MHC genotyping`, but `Sources/LungfishApp/App/MainMenu.swift:786-802` builds the launch path as a category submenu and `MainMenu.swift:766-771` makes Workflow Library a separate enablement window under Tools | `Tools > Genotyping > miSeq amplicon MHC genotyping...`. The Workflow Library window enables the workflow, it does not launch it. |
| 1.2 | "The genotyping workflows live together in the Workflow Library: the short-amplicon miSeq route ... and the full-length Oxford Nanopore (ONT) route" | changed | `Sources/LungfishApp/Services/WorkflowLibrary.swift:141-186` puts four items in `.genotyping`, and only two are MHC genotyping | Two MHC genotyping workflows appear under Tools > Genotyping, `miSeq amplicon MHC genotyping` and `Full-length ONT MHC genotyping`. `Savont Clustering` and `12S Amplicon Matching` also sit in that category. |
| 1.3 | "the miSeq amplicon, ONT, and full-length ONT MHC genotyping workflows listed in the genotyping group" (planned shot caption `workflow-library-genotyping`) | false | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:1982` shows a single `.ontGenotyping` tool titled `miSeq amplicon MHC genotyping`. There is no separate item titled ONT MHC genotyping | Two MHC genotyping workflows, not three. The one tool the chapter splits into "miSeq" and "ONT" is one tool, `miSeq amplicon MHC genotyping`, which handles both read types. |
| 1.4 | "Amplicon MHC genotyping reads the immune-recognition region of a genome by sequencing many short, targeted PCR products and matching each read against a library of known allele sequences." | true | `Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:40` describes the filter as full-reference alignment against the allele library | |
| 1.5 | "The reads arrive as FASTQ files ... and the library they are matched against is a FASTA file" | true | cli-help `fastq.txt` banner `fastq genotype`, `--reference` accepts "Reference FASTA file, .lungfishref bundle, or .lungfishmhcref bundle" | |
| 1.6 | "Throughout this chapter the worked organism is the Mauritian cynomolgus macaque, abbreviated MCM" | true | `Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref/haplotypes/mcm-mhc-miseq-20260617.lungfishhaplotypedef.json` `speciesCode` is `MCM` | haplotyping (placeholder scope). The campaign decision moves the worked example to a rhesus MiSeq project. |
| 1.7 | "the full-length Oxford Nanopore (ONT) route, which expects long reads" | true | cli-help `fastq.txt` banner `fastq full-length-ont-mhc-genotype`, "Run full-length ONT MHC genotyping from per-sample FASTQ bundles using Savont clusters" | |
| 1.8 | "For each of the hundreds of known MHC allele sequences held in a curated library, it asks one plain question: is this allele present in this animal, and how many reads support it?" | true | `Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref/mcm_mhc_miseq_reference.trimmed.unique.fasta` carries 189 allele records, and cli-help `fastq.txt` `--min-support` counts retained unique reads per row | The built-in MCM MiSeq library holds 189 allele targets, so "hundreds" overstates it by roughly a factor of two. |
| 1.9 | "the entire MHC of a Mauritian animal is almost always one of a small, fixed set of blocks named M1 through M7" | true | the definition JSON lists exactly `M1` through `M7` at every locus | haplotyping (placeholder scope) |
| 1.10 | "Each of these M-families is a whole-region haplotype ... spanning all six MHC loci" | false | the built-in definition set has five `locusDefinitions`, `MHC-A`, `MHC-B`, `MHC-DP`, `MHC-DQ`, `MHC-DR` | haplotyping (placeholder scope). The correct count is five reported loci. |
| 1.11 | "Those six are three class I loci (MHC-A, MHC-E, and MHC-B) and three class II loci (MHC-DR, MHC-DQ, and MHC-DP)." | false | the FASTA header field `haplotype_groups=` takes only five values, `MHC-A`, `MHC-B`, `MHC-DP`, `MHC-DQ`, `MHC-DR`. `MHC-E` appears only as a `source_loci=` value whose `haplotype_groups` is `MHC-A`, for example `>MCM_MHC_MiSeq_0010\|source_loci=MHC-E\|haplotype_groups=MHC-A` | haplotyping (placeholder scope). MHC-E is a source locus rolled into the MHC-A haplotype group, not a reported locus. |
| 1.12 | "Each allele target has an identifier such as `0068[MHC-A1]`, where `0068` is that sequence's catalogue number in the library and the bracketed part names its locus." | false | the reference FASTA record is `>MCM_MHC_MiSeq_0068\|source_loci=MHC-A1\|haplotype_groups=MHC-A\|...`. The identifier is `MCM_MHC_MiSeq_0068`. The `0068[MHC-A1]` form appears nowhere in source | The allele-target identifier is the FASTA record name, for example `MCM_MHC_MiSeq_0068`, and its source locus is carried in the header field `source_loci=MHC-A1`. |
| 1.13 | "M1 across the six MCM miSeq loci (illustrative): MHC-A 0068[MHC-A1], 0129[MHC-K], 0079[MHC-AG1] / MHC-E 0010 / ..." (the fenced block) | false | M1 at `MHC-A` has `primaryAlleles` `MCM_MHC_MiSeq_0068`, `MCM_MHC_MiSeq_0129`, `MCM_MHC_MiSeq_0079` and 15 `diagnosticAlleles`. There is no `MHC-E` locus row. `0010` is a `source_loci=MHC-E` record whose haplotype group is `MHC-A` | haplotyping (placeholder scope). The block must drop the MHC-E row, use full record names, and distinguish `primaryAlleles` from the longer `diagnosticAlleles` list. |
| 1.14 | "Lungfish prefers to keep a family intact when the evidence allows" | changed | `Sources/LungfishWorkflow/ONTGenotyping/AIHaplotypingPromptRegistry.swift:159` states this as an instruction inside the AI haplotyping prompt, not as deterministic pipeline behavior. No deterministic slot-consistency rule exists in `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift` | haplotyping (placeholder scope). Slot consistency is a rule given to the AI haplotyping provider, not a deterministic calling behavior. |
| 1.15 | "Each locus gets two report slots, labelled H1 and H2." | true | `Sources/LungfishGenotypeUI/GenotypeHaplotypeTapeView.swift:85-140` draws one `h1` and one `h2` cell per locus slot, and `HaplotypeSlot` has exactly those cases | haplotyping (placeholder scope) |
| 1.16 | "an unresolved slot is written as `?`" | true | `Sources/LungfishGenotypeUI/GenotypeHaplotypeOverrideTargets.swift:4` defines `static let unresolved = "?"`, and `GenotypeHaplotypeTapeView.swift:281-284` normalizes both `?` and a label containing `NO HAP` to `?` | haplotyping (placeholder scope). A stored label of `NO HAP` also displays as `?`. |
| 1.17 | "when three or more families turn up with credible support at a locus, Lungfish does not quietly pick the two strongest and move on. It reports `?/?` and flags the locus for a person" | changed | `Sources/LungfishWorkflow/ONTGenotyping/AIHaplotypingPromptRegistry.swift:156-157` is the only overcall guard in the codebase, and it is prompt text sent to an AI provider. The deterministic genotyping script has no such rule | haplotyping (placeholder scope). The overcall guard is an AI haplotyping prompt instruction, not a deterministic pipeline guard. |
| 1.18 | "That behaviour is the overcall guard, covered in detail in Reading the Genotype Comparison Viewport" | changed | same as 1.17 | haplotyping (placeholder scope) |
| 1.19 | "It maps short reads to the allele library and counts exact and indel-aware matches per allele target" | true | `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:40` "Filter exact+indel/no-mismatch full-reference alignments", `:50` `--max-mismatches` default `0`, `:453` "full-reference MD-tag mismatches <= max-mismatches; indels allowed" | |
| 1.20 | "It first clusters reads into consensus sequences ... using Savont or pbAA, and then genotypes those consensus sequences" | changed | `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCGenotypingPipeline.swift:513-560` runs Savont only. pbAA is a separate operation, `fastq pbaa-cluster`, that writes a `.lungfishref` bundle. `FullLengthONTPBAAArtifactPlanner.swift:4-19` lets the full-length workflow reuse a saved pbAA artifact rather than run pbAA itself | The full-length route clusters with Savont. pbAA is a separate clustering operation whose saved artifact the full-length workflow can reuse. |
| 1.21 | "Both routes end in the same place: a genotype result bundle you open in the comparison dashboard." | true | both `fastq genotype` and `fastq full-length-ont-mhc-genotype` write a `.lungfishgenotype` bundle directory, per cli-help `fastq.txt` `--output-dir` "Output .lungfishgenotype bundle directory" | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The `mcm-mhc-miseq` locked preset, which carries its own reference and definitions and cannot be combined with `--reference` | cli-help `fastq.txt`, `fastq genotype` `--preset` "Locked genotyping preset. Supported value: mcm-mhc-miseq." |
| bbmerge pair merging of overlapping Illumina mates before mapping, without which every 244 bp DRB amplicon silently receives zero reads | `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift:5-34` |
| The zero-mismatch, full-reference-span retention rule that defines what counts as a supporting read | `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:316-364` |
| `evidenceWeights` and the `primaryAlleles` versus `diagnosticAlleles` distinction inside a definition | the definition JSON gives `MCM_MHC_MiSeq_0079` a weight of `0.25` while primary records carry `1` |
| `Savont Clustering` and `12S Amplicon Matching` also live in the Genotyping category | `Sources/LungfishApp/Services/WorkflowLibrary.swift:141-186` |
| The plugin packs the two workflows require, `lungfish-tools`, `read-mapping`, and `full-length-mhc-genotyping` | `Sources/LungfishApp/Services/WorkflowLibrary.swift:157-162, 173-179` |
| Savont 0.6.3 and BLAST 2.16.0 are the pinned tools of the full-length pack | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`, `full-length-mhc-genotyping` entries |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `workflow-library-genotyping` (planned) | no | Its caption names three MHC genotyping workflows and places them in the Workflow Library. There are two, and the launch path is Tools > Genotyping. Recapture as a Tools > Genotyping submenu shot. |
| `<!-- planned: workflow-library-genotyping -->` marker | keep, recaption | The marker sits in the right paragraph. Only the caption is wrong. |
| `alleles-vs-haplotypes-schematic` (planned) | no | Its caption names six loci spanning MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, MHC-DP. There are five, and MHC-E is not one of them. Under the campaign decision this schematic belongs in the haplotyping placeholder, so drop it from the rewrite. |
| `<!-- planned: alleles-vs-haplotypes-schematic -->` marker | drop | Sits inside the M-family block, which the campaign decision reduces to a placeholder. |

---

## 02-running-genotyping.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 2.1 | "Workflow Library > miSeq amplicon MHC genotyping" and "Workflow Library > Full-length ONT MHC genotyping" (frontmatter) | changed | `Sources/LungfishApp/App/MainMenu.swift:786-802` builds category submenus, `:766-771` makes Workflow Library a separate window | `Tools > Genotyping > miSeq amplicon MHC genotyping...` and `Tools > Genotyping > Full-length ONT MHC genotyping...`. |
| 2.2 | "CLI: lungfish fastq ont-genotype" (frontmatter) | true | cli-help `fastq.txt`, `==== fastq ont-genotype ====` | |
| 2.3 | "CLI: lungfish fastq genotype" (frontmatter) | true | cli-help `fastq.txt`, `==== fastq genotype ====` | |
| 2.4 | "CLI: lungfish fastq full-length-ont-mhc-genotype" (frontmatter) | true | cli-help `fastq.txt`, `==== fastq full-length-ont-mhc-genotype ====` | |
| 2.5 | "You start every run from the Workflow Library, the launcher that lists the workflows Lungfish can run against your project data." | false | `MainMenu.swift:766-771` and `:1187` describe the Workflow Library window as the surface "for enabling specialized workflow surfaces". `AppDelegate+ToolsMenu.swift:1731-1771` shows the run dialog is opened by `showWorkflowOperations` from a Tools submenu item | Runs start from the Tools menu, at Tools > Genotyping. The Workflow Library window is where a specialized workflow is enabled before it appears there. |
| 2.6 | "The run compares them to an MHC allele-library reference bundle: a `.lungfishmhcref` package that carries the allele FASTA ... plus the haplotype definitions used to name families." | true | cli-help `fastq.txt` `--reference` ".lungfishmhcref bundle (FASTA + paired haplotype definitions)" | |
| 2.7 | "Three routes share this chapter" | false | there are two MHC genotyping operations. The chapter's Route A and Route B are two CLI subcommands, `fastq genotype` and `fastq ont-genotype`, that share one GUI tool, `miSeq amplicon MHC genotyping` | Two genotyping operations exist in the app. On the command line the MiSeq operation is reachable as `fastq genotype` or `fastq genotype-cohort`, and `fastq ont-genotype` is a separate simpler mapping-and-filtering command that produces no haplotype analysis. |
| 2.8 | "ONT MHC genotyping (sample bundles or barcode demux)" as a distinct workflow in the routing table | false | there is no workflow with that title. `FASTQOperationDialogState.swift:1982` names the only such tool `miSeq amplicon MHC genotyping`, and `:2029` says it runs "for ONT barcode-demux or prepared Illumina sample bundles" | The one operation, `miSeq amplicon MHC genotyping`, covers ONT sample bundles, Illumina paired bundles, and the deprecated ONT barcode-demux mode. |
| 2.9 | "Open your project, then open the Workflow Library from the toolbar." | false | `MainMenu.swift:766-771` places Workflow Library in the Tools menu. No toolbar item was found | Open your project, then choose Tools > Genotyping and the workflow you need. |
| 2.10 | "leave the mode on Illumina sample bundles" | false | `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift:546-562` shows the miSeq pane has only Report Name, Analysis Name, Threads, Min Reads, and a locked multi-bundle picker. `WorkflowOperationDialogState.swift:406-417` computes `effectiveGenotypingMode` from the reads themselves | There is no mode control to leave alone. The mode is derived from the selected reads and shown as a caption. `WorkflowOperationsDialog.swift:302-304` renders `state.effectiveGenotypingMode.displayName` as read-only text. |
| 2.11 | "The `--min-support` setting controls how many retained reads an allele target needs before it appears as a genotype row." | true | cli-help `fastq.txt`, `fastq genotype` `--min-support` "Minimum retained unique-read support required for a genotype row in the report and workbook (default: 1)" | In the dialog this setting is labelled `Min Reads` (`FASTQOperationToolPanes.swift:559`). |
| 2.12 | "Choose the barcode-demux mode ... only for legacy barcode-split inputs: it is deprecated" | changed | cli-help `fastq.txt` `--mode` lists "deprecated ont-barcode-demux", and `==== fastq ont-barcode-genotype ====` is banner-marked "Deprecated ONT barcode demux genotyping workflow" | True of the CLI. There is no such mode control in the dialog, so the GUI half of this instruction has no target. |
| 2.13 | "In both cases, select the MHC reference bundle and click Run." | true | `WorkflowOperationDialogState.swift:1339-1341` requires a reference URL before a request is built, and `:615-617` gates `isRunEnabled` on readiness | |
| 2.14 | "The workflow clusters each sample with Savont by default, using a quality-value cutoff and a minimum cluster size" | changed | Savont is the only clusterer in the full-length pipeline, and the GUI exposes only Min Length and Max Length (`WorkflowOperationsDialog.swift:316-320`). Quality cutoff and minimum cluster size are CLI-only for this route | The full-length route clusters with Savont. In the dialog you set only Min Length and Max Length. The Savont quality cutoff and minimum cluster size are command-line settings. |
| 2.15 | "As an alternative upstream path, you can cluster PacBio HiFi or ONT reads with pbAA first and feed the passed consensus FASTA in as the reads." | changed | `FullLengthONTPBAAArtifactPlanner.swift:4-19` reuses a saved pbAA artifact by signature rather than accepting a consensus FASTA as reads. cli-help `fastq.txt` `fastq pbaa-cluster` writes "the .lungfishref result" | pbAA runs as its own operation and stores a reusable artifact. The full-length workflow reuses a compatible saved pbAA artifact rather than taking its FASTA as input reads. |
| 2.16 | "On a cohort, Lungfish processes samples largest-first and runs several in parallel" | true | `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCSampleScheduling.swift:88-90` sorts descending on `readCount`, and `FullLengthONTMHCGenotypingPipeline.swift:541` logs the concurrent job count | |
| 2.17 | "All three routes report into the Operations Panel" | changed | two operations, not three. Both report into `OperationCenter` per project convention | Both genotyping operations report into the Operations Panel. |
| 2.18 | "A missing reference FASTA and an empty cluster set are the two most common causes" | unverifiable | no source enumerates the two most common failure causes. This is an editorial assertion | Would be settled only by run telemetry, which the repository does not hold. |
| 2.19 | "lungfish fastq mhc-reference-bundle --reference-fasta ... --haplotype-definition ... --output ..." | true | cli-help `fastq.txt`, `==== fastq mhc-reference-bundle ====`, all three flags present | |
| 2.20 | "lungfish fastq genotype sampleA_R1.fastq.gz sampleA_R2.fastq.gz --mode illumina-paired --reference ... --output-dir ..." | true | cli-help `fastq.txt` `fastq genotype` usage takes `<inputs> ...` plus `--output-dir`, with `--mode` and `--reference` as shown | |
| 2.21 | "lungfish fastq pbaa-cluster sampleC.lungfishfastq --guide ... --output-dir ..." | true | cli-help `fastq.txt`, `==== fastq pbaa-cluster ====` | |
| 2.22 | "Each command writes CSV summaries, a workbook, run statistics, and provenance into its output directory" | changed | true of `fastq genotype`, whose `--output-dir` is "Directory for genotype CSV summaries, workbook, stats, and provenance". `fastq ont-genotype` writes "filtered BAMs, indexes, report CSV, and workflow provenance", with no workbook | `fastq genotype` and `fastq genotype-cohort` write CSV summaries, a workbook, statistics, and provenance. `fastq ont-genotype` writes filtered BAMs and indexes, a report CSV, and provenance, with no workbook. |
| 2.23 | "Run `lungfish fastq genotype-cohort` in place of `genotype` ... it needs at least two `.lungfishfastq` bundles" | changed | cli-help `fastq.txt` `fastq genotype-cohort` says "Each bundle must contain one prepared per-sample FASTQ" but states no two-bundle minimum | Drop the two-bundle minimum. The documented requirement is that each input bundle holds one prepared per-sample FASTQ. |
| 2.24 | "it defaults `--mode` to `illumina-paired`" | true | cli-help `fastq.txt` `fastq genotype-cohort` `--mode` "(default: illumina-paired)" | |
| 2.25 | "Pass `--preset mcm-mhc-miseq` instead of `--reference` to lock the established MCM panel." | true | cli-help `fastq.txt` `--preset` "Locked genotyping preset. Supported value: mcm-mhc-miseq." | |
| 2.26 | "The preset carries its own reference FASTA and haplotype definitions, so it cannot be combined with `--reference` or any `--haplotype-*` selector." | true | `Sources/LungfishCLI/Commands/FastqGenotypingSubcommand.swift:255-268` throws on a non-empty `--reference` and on any of `--haplotype-assay`, `--haplotype-species`, `--haplotype-definition-scope`, or `--haplotype-definition`. `MCMHaplotypingPreset.swift:228-231` supplies the two messages | The two errors read "Preset mcm-mhc-miseq uses a locked bundled reference; omit --reference." and "Preset mcm-mhc-miseq uses its bundled haplotype definition; omit explicit haplotype definition options." |
| 2.27 | Options table row `--mode` default `auto` | true | cli-help `fastq.txt` `fastq genotype` `--mode` "(default: auto)" | |
| 2.28 | Options table row `--read-type` default `auto` | true | cli-help `fastq.txt` `fastq genotype` `--read-type` "(default: auto)" | For `genotype-cohort` the default is `illumina`, not `auto`. |
| 2.29 | Options table row `--min-support` default `1` | true | cli-help `fastq.txt` `--min-support` "(default: 1)" | |
| 2.30 | Options table row `--haplotype-min-sample-percent` default `0` (off) | true | cli-help `fastq.txt` "0 disables (default: 0.0)" | |
| 2.31 | Options table row `--haplotype-min-locus-percent` default `0` (off) | changed | true of the CLI. The GUI default differs. `FASTQOperationDialogState.swift:314` sets `ontGenotypingHaplotypeDropoutLocusPercent = 1.0` | The command-line default is 0, which disables the filter. The dialog's `Locus %` field starts at 1.0. |
| 2.32 | Options table row `--haplotype-min-locus-percent-override` example `MHC-DQ=10`, repeatable | true | cli-help `fastq.txt` "Per-locus percent override such as MHC-DQ=10; may be repeated" | |
| 2.33 | "`--haplotype-species` (a species code such as `MCM` or `MAMU`)" | true | cli-help `fastq.txt` "Species code used to restrict compatible haplotype definitions, such as MCM or MAMU" | haplotyping (placeholder scope) |
| 2.34 | "Omit `--haplotype-definition` to skip haplotyping." | true | cli-help `fastq.txt` "Optional assay-scoped haplotype definition set ID; omit to skip haplotyping" | haplotyping (placeholder scope) |
| 2.35 | Route C table row `--min-length` / `--max-length` defaults `2000` / `4000` | true | cli-help `fastq.txt` `full-length-ont-mhc-genotype` "(default: 2000)" and "(default: 4000)". `WorkflowOperationDialogState.swift:203-204` sets the same values in the dialog | |
| 2.36 | Route C table row `--savont-quality-value-cutoff` default `90` | true | cli-help `fastq.txt` "(default: 90)" | |
| 2.37 | Route C table row `--savont-min-cluster-size` default `3` | true | cli-help `fastq.txt` "(default: 3)" | |
| 2.38 | Route C table row `--cdna-threshold` default `2000` | true | cli-help `fastq.txt` "Alleles shorter than this length are treated as cDNA references (default: 2000)" | |
| 2.39 | Route C table row `--min-unmatched-reads` default `5` | true | cli-help `fastq.txt` "(default: 5)" | |
| 2.40 | "`--sample-jobs` caps how many samples run at once and `--savont-threads-per-sample` sets Savont threads for each" | true | cli-help `fastq.txt`, both flags present with automatic defaults | |
| 2.41 | "Add `--keep-intermediates` ... and `--reuse-compatible-checkpoints`" | true | cli-help `fastq.txt`, both flags present on `full-length-ont-mhc-genotype` | |
| 2.42 | "Each reportable sample carries six locus rows (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP)" | false | the built-in definition set has five `locusDefinitions` and MHC-E is not among them | haplotyping (placeholder scope). Five loci, and MHC-E is a source locus inside the MHC-A group. |
| 2.43 | "A sample where nearly every M-family has substantial support across many loci is the pattern the overcall guard is designed to catch." | changed | the overcall guard exists only as AI prompt text (`AIHaplotypingPromptRegistry.swift:156`) | haplotyping (placeholder scope) |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The dialog's `Analysis Mode` picker with three values, `AI preset`, `Deterministic`, and `Genotype only`, which decides whether a run haplotypes at all | `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift:34-56`, `WorkflowOperationsDialog.swift:363-395` |
| The AI specialist preset path, disabled until API access is configured | `WorkflowOperationsDialog.swift:370-387`, `WorkflowOperationDialogState.swift:1264-1271` |
| The `Manage...` button beside the Haplotype Definition picker, which opens the Haplotype Definitions editor from inside the run dialog | `WorkflowOperationsDialog.swift:416-432` |
| The locked multi-bundle run picker that tells you selections run as one merged batch, with the reason string "Selections run as one genotyping batch producing a merged report. Run bundles individually for separate per-sample reports." | `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift:313-318` |
| `Analysis Name` and `Report Name` fields in both dialogs | `FASTQOperationToolPanes.swift:553-554`, `WorkflowOperationsDialog.swift:294, 311` |
| The full-length dialog's `Call Thresholds` group, its `Locus %` field, and the caption "Used for haplotype calls and Excel output. Inspector filters only change what is shown." | `WorkflowOperationsDialog.swift:322-325` |
| Optional orientation reference and forward and reverse primer FASTA pickers on the full-length sheet | `WorkflowOperationsDialog.swift:491-511` |
| `fastq savont-cluster` as a standalone operation, and `Savont Clustering` as a Tools > Genotyping item | cli-help `fastq.txt` `==== fastq savont-cluster ====`, `WorkflowLibrary.swift:166-171` |
| `fastq ont-fluidigm-samples` and `fastq ont-pacbio-barcode-demux`, the two sample-preparation commands that make the per-sample bundles the genotyper wants | cli-help `fastq.txt` lines 478 and 515 |
| `fastq update-current-workbook`, which applies review edits back into a bundle's `current.xlsx` | cli-help `fastq.txt` `==== fastq update-current-workbook ====` |
| bbmerge pair merging and the DRB zero-read failure it prevents | `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift:5-34` |
| `--extra-args` for advanced minimap2 arguments, exposed in the dialog's advanced section | cli-help `fastq.txt` `--extra-args`, `FASTQOperationToolPanes.swift:887-890` |
| `--comparison-workbook` and `--comparison-name`, which lay an expected-call sheet beside the result | cli-help `fastq.txt` `fastq genotype` |
| `--sort-threads`, default 4 | cli-help `fastq.txt` `fastq genotype` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `genotyping-workflow-config` (planned) | recaption | The sheet exists but is reached from Tools > Genotyping, not the Workflow Library. Caption should name the Report, Run Parameters, and Haplotyping groups it actually shows. |
| `genotyping-ont-barcode-config` (planned) | no | Its caption promises "barcode-demux mode selected" from a mode control. No such control exists in the dialog. Drop it. |
| `genotyping-full-length-clustering` (planned) | no | Its caption promises "the Savont or pbAA clustering options". The sheet offers Min Length, Max Length, Threads, a Locus % threshold, and primer pickers. Recapture as the full-length sheet's Length Filter and Call Thresholds groups. |
| `genotyping-operations-panel` (planned) | yes, recaption | The Operations Panel does track the run. The caption's "cohort genotyping run from clustering through to a genotype result bundle" is fine for the full-length route only. |
| `<!-- planned: genotyping-workflow-config -->` marker at line 111 | keep | Sits under Step 1, which survives the rewrite as a Tools-menu step. |
| `<!-- planned: genotyping-ont-barcode-config -->` marker at line 145 | drop | Its Step 3 has no distinct workflow behind it. |
| `<!-- planned: genotyping-full-length-clustering -->` marker at line 161 | keep, recaption | Step 4 survives, but only Min Length and Max Length are dialog settings. |
| `<!-- planned: genotyping-operations-panel -->` marker at line 174 | keep | Step 5 survives unchanged. |

---

## 03-reading-the-genotype-comparison.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 3.1 | "Open a genotype result bundle from the sidebar" (frontmatter `entry_points`) | true | `Sources/LungfishGenotypeUI/GenotypeResultViewController.swift` is the viewport bound to a `.lungfishgenotype` bundle, and `features.yaml:907-912` records the same entry point | |
| 3.2 | "The dashboard has three regions ... the comparison matrix ... the haplotype tape ... the cohort summary." | changed | those three views exist (`GenotypeComparisonMatrixView.swift`, `GenotypeHaplotypeTapeView.swift`, `GenotypeCohortSummaryPanelView.swift`) but so do the outline (`GenotypeOutlineView.swift`), the call-evidence panel (`GenotypeCallEvidenceView.swift`), the quick-filter bar (`GenotypeQuickFilterBarView.swift`), and the Smart Cohort list (`GenotypeSmartCohortSection.swift`) | The dashboard carries at least seven regions. Naming three as "the" regions understates it. |
| 3.3 | "The viewport opens on one of three lenses, chosen from a segmented control at the top right." | false | `GenotypeResultPresentationPolicy.swift:100-107` returns `[.haplotypeCalls, .genotypeMatrix]` for a typed haplotyped miSeq bundle, and `GenotypeResultViewController.swift:2700-2718` labels the segmented control from those choices | A MiSeq genotyping result opens on a two-way control whose segments are `Haplotype Calls` and `Genotype Matrix`. Summary, Review, and Audit remain only for older non-MiSeq result shapes. |
| 3.4 | "Summary is the dashboard this chapter describes" | false | `GenotypeResultPresentationPolicy.swift:151-158` forces `viewportLens = .summary` for the MiSeq shape, so Summary is never a user-visible choice there | The Summary lens is not offered on a MiSeq result. It is the internal state the two presentation choices both sit inside. |
| 3.5 | "Review is a queue that walks the flagged samples one at a time" | false | `GenotypeResultPresentationPolicy.swift:151-156` normalizes any non-summary lens away for the MiSeq shape, so the Review segment is not shown | haplotyping (placeholder scope) for its call-evidence half. For a MiSeq result there is no Review lens. Flagged samples are reached through the Needs Review smart cohort instead. |
| 3.6 | "Audit lays out the haplotype definitions and the run artifacts the calls rest on." | false | same normalization at `GenotypeResultPresentationPolicy.swift:151-156`, and `GenotypeResultViewController.swift:9687-9689` states plainly "The Audit lens that hosted the export buttons is hidden for MiSeq results" | There is no Audit lens on a MiSeq result. |
| 3.7 | "Within Summary, an Outline and Matrix toggle switches how the samples are laid out." | changed | `GenotypeResultDisplaySection.swift:1229-1232` shows the Inspector toggle only when `presentationChoices.isEmpty`, and `:1327-1334` labels it "Show haplotyping view" or "Show genotype matrix" | On a MiSeq result the switch is the viewport's own `Haplotype Calls` and `Genotype Matrix` segmented control. The Inspector's "Show haplotyping view" and "Show genotype matrix" button appears only on older result shapes. |
| 3.8 | "Outline is the default for a run that carries haplotype calls, and Matrix is the default for a run that produced raw calls but no haplotype analysis." | true | `GenotypeResultPresentationPolicy.swift:110-122`, `defaultSummaryViewMode` returns `.outline` when the policy applies and `.matrix` for a genotype-only result | The user-facing names are `Haplotype Calls` and `Genotype Matrix`, per `GenotypeResultPresentationPolicy.swift:23-28`. |
| 3.9 | "Each sample's call-evidence panel carries Confirm and Skip buttons" | true | `Sources/LungfishGenotypeUI/GenotypeCallEvidenceView.swift:1283-1294` renders both, helped as "Confirm analyzer call" and "Skip to next review sample" | The chapter ties these to a Review lens that a MiSeq result does not have. The buttons are in the call-evidence panel itself. |
| 3.10 | "Cmd-R marks it reviewed. Cmd-K marks it confirmed. Cmd-Shift-F flags it as needing review. Cmd-Shift-O opens the Sample Detail sheet with the override editor." | true | `GenotypeResultViewController.swift:1138-1151` maps exactly those four | The chapter frames these as Review-lens shortcuts. `GenotypeResultViewController.swift:1130-1134` makes them work on a MiSeq result too, whenever a call is selected. |
| 3.11 | "Each row is an allele target from the reference library, written with its identifier and source label such as `0068[MHC-A1]`." | false | the reference record is `MCM_MHC_MiSeq_0068` with header field `source_loci=MHC-A1`. The `0068[MHC-A1]` display form appears nowhere in source | Rows are named by the reference record, for example `MCM_MHC_MiSeq_0068`. |
| 3.12 | "A filled cell means that sample showed that allele target, and the cell carries the retained read count behind it." | true | `GenotypeCallEvidenceView.swift:915` renders `Text("\(row.reads)")` for each allele row, and the matrix is built from the same retained counts | |
| 3.13 | "Cells are colored by the M-family they support, using a fixed palette" | true | `GenotypeCLI export doc` `GenotypeExportXLSXSubcommand.swift:12-14` names "the canonical Budde 2010 palette (M1-M7)", and `GenotypeHaplotypeTapeView.swift:310-317` resolves a token fill colour | haplotyping (placeholder scope) |
| 3.14 | "The matrix never modifies the bundle: sorting, filtering, and selecting are display state only." | true | `GenotypeResultDisplaySection.swift:1243` renders the caption "Visual filters do not change genotype calls." | |
| 3.15 | "For the selected sample it lays out the six MHC loci (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP)" | false | the definition set has five loci and MHC-E is not one | haplotyping (placeholder scope). Five loci. |
| 3.16 | "Each slot holds an M-family name or a `?` when the slot is unresolved." | true | `Sources/LungfishGenotypeUI/GenotypeHaplotypeOverrideTargets.swift:4` defines `unresolved` as `"?"`, and `GenotypeHaplotypeTapeView.swift:281-284` renders both `?` and a `NO HAP` label as `?` | haplotyping (placeholder scope) |
| 3.17 | "Lungfish reorders H1 and H2 freely to keep the same M-family aligned down a column of loci" | changed | `AIHaplotypingPromptRegistry.swift:159` states this only as an AI prompt instruction | haplotyping (placeholder scope) |
| 3.18 | "how many samples fell below the read-support threshold, how many carry errors, how the quality-control statuses are distributed, and how many analyst annotations exist" | true | `GenotypeCohortSummaryPanelView.swift:113-128` builds exactly four sections, "Low-coverage samples", "QC distribution", "Errors", and "Annotations" | The low-coverage section is titled "Low-coverage samples" with a "Below N reads" subtitle. |
| 3.19 | "Each tally names its samples when you hover the count" | changed | `GenotypeCohortSummaryPanelView.swift:158-162` sets a `toolTip` reading "Hover to list: ..." on the count label, but only for the two flag sections built by `makeFlagSection`, "Low-coverage samples" and "Below N reads". The QC distribution, Errors, and Annotations sections use `makeSection` (`:202-220`), which sets no tooltip | Hovering names the samples behind the two low-coverage tallies. It lists at most eight, then "(+N more)". The other tallies carry no tooltip. |
| 3.20 | "Summary and Review share a filter bar above the content. Its search field is sample-oriented" | false | `GenotypeQuickFilterBarView.swift:121` sets the placeholder to "Search samples or alleles…", and `GenotypeSearchIndex.swift:154-170` indexes both sample metadata and reference-row metadata | The search field matches samples and alleles. Its placeholder reads "Search samples or alleles…". |
| 3.21 | "A `field=value` query such as `Cohort=Kenyon20` narrows to samples whose metadata field contains that value." | true | `GenotypeQuickFilterBarView.swift:351` documents "`Cohort=Kenyon20` (or `Cohort:Kenyon20`) — sample metadata", and `:362-363` maps it to `.metadataFieldContains` | The colon form `Cohort:Kenyon20` works too. |
| 3.22 | "a pill bar of one-click sample predicates: Has errors, Homozygous, Recombinant, Bw6+, Has comments, and Duplicate" | true | `GenotypeQuickFilterBarView.swift:16-30` defines exactly those six with those labels | |
| 3.23 | "the built-in 'Needs review' cohort is the one the Review lens activates" | changed | `GenotypeSmartCohortSection.swift:118` names it `Needs Review` with a capital R. The Review lens does not exist on a MiSeq result | The built-in smart cohort is named `Needs Review`. On a MiSeq result you activate it yourself rather than having a Review lens do it. |
| 3.24 | "The Matrix view adds its own row filter, a field reading 'Filter genotypes, loci, or samples'" | true | `GenotypeComparisonMatrixView.swift:1083` sets exactly that placeholder | |
| 3.25 | "alongside an All Loci popup that restricts the grid to a single locus" | true | `GenotypeComparisonMatrixView.swift:1449` adds the item titled "All Loci" to `locusPopup` | |
| 3.26 | "Because the Matrix instantiates only a capped window of sample columns, a wide cohort shows a 'Showing N of M samples' banner with a Show all button." | false | no such banner string exists in `Sources/LungfishGenotypeUI/`. The only related controls are `GenotypeResultDisplaySection.swift:1614` "Show All Rows" and `:1634` "Show All Columns", plus `GenotypeMatrixVisibilityState.swift:278` "Show All Rows and Columns", all of which reverse a manual hide, not a column window | The Inspector offers `Show All Rows` and `Show All Columns` buttons that undo hiding you applied yourself. There is no automatic column window and no "Showing N of M samples" banner. |
| 3.27 | "Four rationale categories cover most calls ... `direct-primary` ... `shared-resolved` ... `secondary-rescued` ... `overcall-human-curation`" | false | none of these four strings appears anywhere in `Sources/`. The only rationale vocabulary is `AIHaplotypingTypes.swift:152-160`, an evidence-class enum of `direct_observation`, `coverage_summary`, `cohort_recurrence`, `dropout_signal`, `overcall_signal`, `deterministic_call`, `manual_review`, and `current_ai_call`, and it belongs to AI haplotyping | haplotyping (placeholder scope). These four category names do not exist. The call-evidence panel shows diagnostic support counts, observed allele reads, "Other possible haplotypes", and "Why alternatives were not selected". |
| 3.28 | "Before ranking any calls, Lungfish checks whether the sample is even consistent with that." | false | no such deterministic check exists in `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift`. `AIHaplotypingPromptRegistry.swift:156` instructs an AI provider to apply it | haplotyping (placeholder scope) |
| 3.29 | "Picture a hypothetical animal we will call LF2840, showing credible support for nearly every family" | changed | an invented example resting on a guard that is prompt text only | haplotyping (placeholder scope). Drop the worked example with the guard it illustrates. |
| 3.30 | "use the override control in the call-evidence panel to set a slot to the M-family the evidence supports" | true | `GenotypeCallEvidenceView.swift:1207-1215` shows "Pending haplotype overrides" with a from-to line, and `GenotypeOverrideSection.swift:96-113` holds the editable draft | haplotyping (placeholder scope) |
| 3.31 | "Your override is recorded with your name, a timestamp, the original call, and your stated reason" | true | `Sources/LungfishIO/Bundles/GenotypeAnnotationSidecar.swift:362-374`, `CallOverride` carries `sample`, `locus`, `slot`, `originalCall`, `overrideCall`, `reasonTag`, `rationale`, `author`, `timestamp`, `analysisIdentity`, and `operationID` | haplotyping (placeholder scope). The record also carries a reason tag chosen from chips, an analysis identity, and an operation ID. |
| 3.32 | "Select cells, rows, or columns to add a color, a note, or a comment that travels with the bundle and into the exports." | true | `GenotypeMatrixAnnotationSection.swift` exists, and `GenotypeExportXLSXSubcommand.swift:20` names the `Audit Log` sheet drawn from `annotations.json` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The `Actions` menu button beside the presentation control, carrying `AI Discovery`, `AI Refinement`, and `Export Excel View…` | `GenotypeResultViewController.swift:2665-2682` |
| The Inspector's `Genotype Display` section, holding Min Reads, Min Percent, a Percent Basis picker, cell colours, highlight scope, and content text size | `GenotypeResultDisplaySection.swift:1224-1251, 1433-1560, 1289-1310` |
| The `Percent Basis` choice between the sample's retained reads and the viewed locus | `GenotypeResultDisplaySection.swift:1566-1571`, cli-help `genotype.txt` `--percent-basis` |
| Cmd-F focuses the search field and Escape clears it | `GenotypeResultViewController.swift:1119-1128` |
| Weak calls draw at half opacity | `GenotypeHaplotypeTapeView.swift:320-322`, `withAlphaComponent(0.5)` |
| Override hatching drawn over an overridden tape cell | `GenotypeHaplotypeTapeView.swift:137-140` |
| The manual haplotype editor with its copy-candidate list, a separate surface from a single-slot override | `Sources/LungfishGenotypeUI/GenotypeManualHaplotypeEditor.swift:29-47, 846` |
| The candidate-allele evidence surfaces for the full-length route, including the difference track | `GenotypeCandidateEvidenceSection.swift`, `GenotypeCandidateDifferenceTrackView.swift` |
| Block classifications shown in the outline, `Block coherent`, `Regional recombinant`, `Atypical`, `Unknown` | `GenotypeResultViewController.swift:9634-9640` |
| The read-only session behavior on a read-only bundle, where a presentation change is not saved | `GenotypeResultPresentationPolicy.swift:126-131` |
| The explanation shown when a saved haplotype analysis is empty or malformed | `GenotypeResultPresentationPolicy.swift:124-127` |
| The `genotype list-samples` and `genotype list-cohorts` read-only inspection commands | cli-help `genotype.txt` |
| The three replay commands that reproduce a recorded GUI edit headlessly, `replay-matrix-annotation`, `replay-manual-haplotype-assignments`, `replay-call-overrides` | cli-help `genotype.txt` |
| `genotype apply-annotations`, which merges an annotation patch into the sidecar | cli-help `genotype.txt` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `genotype-matrix-overview` (planned) | yes | The allele-by-sample matrix is real. Caption should say the row label is the reference record name, not `0068[MHC-A1]`. |
| `genotype-haplotype-tape` (planned) | recaption, haplotyping scope | The tape exists, but the caption's six loci are five. Under the campaign decision this belongs to the placeholder section. |
| `genotype-cohort-summary` (planned) | yes | The four-section panel is real. Caption should name the four sections. |
| `genotype-call-evidence` (planned) | recaption | The panel exists, but "the rationale behind a called haplotype" promises rationale categories that do not exist. Recaption to diagnostic support, observed reads, and alternatives not selected. |
| `genotype-manual-haplotyping` (planned) | recaption, haplotyping scope | The override control exists. The caption should not imply a lone slot control, since a separate manual haplotype editor also exists. |
| `<!-- planned: genotype-matrix-overview -->` at line 45 | keep | Sits in the opening description, which survives. |
| `<!-- planned: genotype-haplotype-tape -->` at line 121 | move | Its section becomes the haplotyping placeholder. |
| `<!-- planned: genotype-cohort-summary -->` at line 141 | keep | The cohort summary section survives. |
| `<!-- planned: genotype-call-evidence -->` at line 194 | keep, recaption | Step 3 survives once the four rationale categories are removed. |
| `<!-- planned: genotype-manual-haplotyping -->` at line 235 | move | Step 4 is override and annotation work, and its haplotype half moves to the placeholder. |

---

## 04-haplotype-definitions-and-export.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 4.1 | "Tools > Haplotype Definitions..." (frontmatter and Step 1) | true | `Sources/LungfishApp/App/MainMenu.swift:708-714` adds the item titled `Haplotype Definitions…` to the Tools menu | haplotyping (placeholder scope). The item appears only when an enabled workflow declares the `haplotypeDefinitions` capability (`MainMenu.swift:708`, `WorkflowLibrary.swift:99-102`). |
| 4.2 | "Genotype viewport > Haplotype Definitions" (frontmatter) | changed | the viewport's Actions menu carries `AI Discovery`, `AI Refinement`, and `Export Excel View…` only (`GenotypeResultViewController.swift:2677-2680`). The `Manage…` route into the editor lives in the run dialog, not the viewport (`WorkflowOperationsDialog.swift:421-423`) | haplotyping (placeholder scope). The in-app route to the editor is Tools > Haplotype Definitions, or the `Manage…` button in the genotyping run dialog. |
| 4.3 | "Genotype viewport > AI Discovery / AI Refinement" (frontmatter) | true | `GenotypeResultViewController.swift:2677-2678` adds both menu items | |
| 4.4 | "Genotype viewport > Export" (frontmatter) | changed | there is no menu item named Export. `GenotypeResultViewController.swift:2680` names it `Export Excel View…` inside the Actions menu, and `GenotypeResultDisplaySection.swift:1276` puts `Filtered Pivot…` in the Inspector | `Genotype viewport > Actions > Export Excel View…` and `Inspector > Genotype Display > Filtered Pivot…`. |
| 4.5 | "CLI: lungfish genotype export-xlsx" (frontmatter) | true | cli-help `genotype.txt`, `==== genotype export-xlsx ====` | |
| 4.6 | "CLI: lungfish genotype export-labkey" (frontmatter) | true | cli-help `genotype.txt`, `==== genotype export-labkey ====` | |
| 4.7 | "CLI: lungfish genotype ai-haplotyping" (frontmatter) | true | cli-help `genotype.txt`, `==== genotype ai-haplotyping ====` | |
| 4.8 | "Definition sets live in `.lungfishmhcref` bundles and in your project" | true | cli-help `haplotypes.txt` banner, "Definitions may be stored as project JSON definition files or embedded in project .lungfishmhcref reference bundles" | haplotyping (placeholder scope) |
| 4.9 | "Each of the six loci (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP) lists the M-families it can call" | false | the built-in definition set has five `locusDefinitions` and MHC-E is not among them | haplotyping (placeholder scope). Five loci. |
| 4.10 | "a definition ID, an assay label, a species code such as MCM, a version, and a per-family display color" | changed | the definition JSON's top-level keys are `assayID`, `displayName`, `id`, `locusDefinitions`, `prefix`, `speciesCode`, `speciesName`. There is no `version` key | haplotyping (placeholder scope). The metadata is an id, a display name, an assay id, a species code and name, and an allele prefix. No version field exists in the built-in set. |
| 4.11 | "The editor opens as a sheet showing the definition's loci down one axis and its families across the marker columns" | false | `GenotypeHaplotypeDefinitionEditor.swift:184-201` builds a locus sidebar `List` with `.listStyle(.sidebar)`, and `:225-230` shows one selected locus at a time with its `haplotypeList`. There is no marker-column grid and no second axis | haplotyping (placeholder scope). The editor is a locus sidebar beside the selected locus's family list, one locus at a time. |
| 4.12 | "Each definition also carries a required **Allele prefix**, and a save stays blocked until it is filled in." | true | `GenotypeHaplotypeDefinitionEditor.swift:161` renders the `Allele prefix` field, and `:774` appends the validation message "Allele prefix is required." | haplotyping (placeholder scope). The built-in MCM set's prefix is `MHC`. |
| 4.13 | "At each locus two fields sit side by side: **Locus** is the display name the call shows, while **Source** is the locus the reads were called against" | true | `GenotypeHaplotypeDefinitionEditor.swift:247` `Text("Locus")` and `:265` `Text("Source")`. The FASTA header confirms the split, for example `source_loci=MHC-A1` under `haplotype_groups=MHC-A` | haplotyping (placeholder scope) |
| 4.14 | "Built-in definition sets are read-only, so to change one you duplicate it into your project scope first" | true | cli-help `haplotypes.txt` `==== haplotypes duplicate ====`, "Duplicate a project definition into the project scope" | haplotyping (placeholder scope) |
| 4.15 | "Each named haplotype carries a **Requires N of M** stepper ... from one up to the full count of targets listed." | true | `GenotypeHaplotypeDefinitionEditor.swift:328` renders `"Requires \(haplotype.effectiveMinimumMatches) of \(haplotype.diagnosticAlleles.count)"`, and `:834-835` clamps the value to `max(1, min(minimumMatches, max(1, alleleCount)))` | haplotyping (placeholder scope). Every family in the built-in MCM set has `minimumMatches` of 1. |
| 4.16 | "Its rows are haplotype definitions, and its columns are Sample, Locus, Call, Haplotype, an Obs/Req/Total triple, and Status" | true | `GenotypeHaplotypeDefinitionMatrixView.swift:278-283` adds exactly those six columns with those titles, then one column per diagnostic target | haplotyping (placeholder scope). Rows are per sample and locus, not per definition. |
| 4.17 | "Status reads Called, Observed support, or Not observed." | true | `GenotypeHaplotypeDefinitionMatrixView.swift:25-27` maps `.called`, `.candidate`, and `.absent` to exactly those strings | haplotyping (placeholder scope) |
| 4.18 | "The same operations are available headless under `lungfish haplotypes`: `list`, `validate`, and `save`, plus `export`, `import`, `duplicate`, and `delete` ... and `bundle-create`, `bundle-save`, and `bundle-replace-reference`" | changed | cli-help `haplotypes.txt` lists eleven subcommands. The chapter names ten and omits `bundle-install` | haplotyping (placeholder scope). Add `bundle-install`, which installs an existing `.lungfishmhcref` bundle into a project. |
| 4.19 | "Open them from AI Discovery or AI Refinement in the genotype viewport." | true | `GenotypeResultViewController.swift:2677-2678` | The two items sit inside an `Actions` menu button, not directly on the viewport chrome. |
| 4.20 | "you can scope it to every sample or to the unresolved calls only" | true | cli-help `genotype.txt` `--review-scope` "AI refinement review scope: all or unresolved-only. (values: all, unresolved-only; default: all)" | |
| 4.21 | "you supply credentials for an AI provider such as OpenAI or Anthropic" | true | `Sources/LungfishApp/Services/GenotypeAIHaplotypingExecutionService.swift:258-298` resolves credentials for `.openAI` and `.anthropic` | |
| 4.22 | "It appends a workbook revision: a separate, dated draft analysis that leaves your original definitions untouched" | true | cli-help `genotype.txt` banner, "it appends a versioned AI haplotype analysis revision with provenance and review metadata" | |
| 4.23 | "`--preview-prompt` to render the request without contacting a provider at all" | true | cli-help `genotype.txt` `--preview-prompt` "Render prompt/evidence JSON without contacting an AI provider or publishing a revision." | |
| 4.24 | "`--provider openai` (the default) or `--provider anthropic`" | true | cli-help `genotype.txt` "(values: openai, anthropic; default: openai)" | |
| 4.25 | "set the mode with `--mode ai-discovery` or `--mode ai-refinement`" | true | cli-help `genotype.txt` "(values: ai-discovery, ai-refinement; default: ai-refinement)" | The chapter never states the default is `ai-refinement`. |
| 4.26 | "Credentials resolve in a fixed order: the `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` environment variable first, then the matching key held in the app keychain." | true | `Sources/LungfishCLI/Commands/GenotypeAIHaplotypingSubcommand.swift:681-694` reads the environment variable first, then falls through to `provider.keychainKey`, then throws. `:1052-1056` names the two variables | The Azure key `AZURE_OPENAI_API_KEY` is checked ahead of both, at `:674-678`. |
| 4.27 | "pass `--azure-openai-endpoint` and `--azure-openai-deployment` ... that path is OpenAI-only, and the deployment name stands in for the model" | true | cli-help `genotype.txt` `--azure-openai-deployment` "Azure OpenAI deployment name to use instead of a direct OpenAI model", and `GenotypeAIHaplotypingExecutionService.swift:353-370` builds the Azure argument pair | |
| 4.28 | "`--reasoning-effort` accepts none, minimal, low, medium, high, or xhigh." | true | cli-help `genotype.txt` "OpenAI Responses API reasoning effort: none, minimal, low, medium, high, or xhigh." | |
| 4.29 | "`--preview-prompt --input-table <file>` builds the request from a long-form genotype table, with `--input-format` selecting auto, csv, tsv, or json" | true | cli-help `genotype.txt` `--input-table` and `--input-format` "(values: auto, csv, tsv, json; default: auto)" | |
| 4.30 | "That table path is discovery-only." | true | `Sources/LungfishCLI/Commands/GenotypeAIHaplotypingSubcommand.swift:109-111` throws "--input-table prompt previews currently support --mode ai-discovery." | The same `validate()` also requires `--preview-prompt` with `--input-table` (`:106-108`) and forbids passing both `--bundle` and `--input-table` (`:103-105`). |
| 4.31 | "with fields `revisionID`, `reviewState`, `callCount`, `discoveredDefinitionCount`, and `provenancePath`" | true | `Sources/LungfishCLI/Commands/GenotypeAIHaplotypingSubcommand.swift:285-290` builds the published summary with exactly those five fields | |
| 4.32 | "The genotype viewport offers a single in-app export: the Audit lens carries an **Export Excel View...** button" | false | `GenotypeResultViewController.swift:9687-9689` states "The Audit lens that hosted the export buttons is hidden for MiSeq results", and `:2680` moves `Export Excel View…` into the Actions menu. `GenotypeResultDisplaySection.swift:1276` adds a second in-app export, `Filtered Pivot…` | The viewport offers two in-app exports. `Export Excel View…` sits in the Actions menu beside the presentation control, and `Filtered Pivot…` sits at the foot of the Inspector's Genotype Display section. |
| 4.33 | "There is no in-app format picker." | true | both in-app buttons hard-set a format, `.excel` at `GenotypeResultViewController.swift:9674` and `.pivotExcel` at `:9678` and `:9691` | |
| 4.34 | "a Matrix sheet ... a Legend sheet ... an Overrides sheet ... and an Audit Log sheet" | true | `Sources/LungfishCLI/Commands/GenotypeExportXLSXSubcommand.swift:11-20` documents exactly those four sheets in that order | |
| 4.35 | "The Filtered Pivot button at the foot of the Inspector's Genotype Display section" | true | `GenotypeResultDisplaySection.swift:1247-1250` places `exportControls` last, and `:1276` renders `Filtered Pivot…` | |
| 4.36 | "allele values below the Min Reads and Min Percent filters shown above it are blanked, each row's Total and observation count are recomputed, and rows left empty are removed" | true | `GenotypeResultDisplaySection.swift:1281` says "the pivot sheet has the Min Reads and Min Percent filters above applied", and cli-help `genotype.txt` `--keep-empty-rows` "Keep allele rows that are empty after filtering instead of removing them" confirms removal is the default | |
| 4.37 | "Every other sheet and all formatting are carried through unchanged." | true | cli-help `genotype.txt` `--source-workbook` "The export is that workbook with only the pivot sheet changed" | |
| 4.38 | "The copy is a one-way export, so edits made to it in Excel never flow back into the result." | true | `GenotypeResultDisplaySection.swift:1281` renders that sentence nearly verbatim | |
| 4.39 | "`lungfish genotype export-pivot-xlsx` for the filtered pivot workbook (with `--min-reads`, `--min-percent`, `--percent-basis` and an optional `--source-workbook`)" | true | cli-help `genotype.txt` `==== genotype export-pivot-xlsx ====`, all four flags present | The chapter omits `--keep-empty-rows`. |
| 4.40 | "`lungfish genotype export`, whose `--export-format` defaults to `xlsx` and also accepts `csv` or `tsv`" | true | cli-help `genotype.txt` "(values: xlsx, csv, tsv; default: xlsx)" | |
| 4.41 | "a repeatable `--sample` to restrict the matrix to named samples, an `--active-haplotype-definition` ... and an `--annotations` sidecar, and it refuses to overwrite an existing file unless you pass `--force`" | true | cli-help `genotype.txt` `genotype export`, all four options present with those descriptions | |
| 4.42 | "It writes several long-format CSV files, one row per fact" | true | `Sources/LungfishCLI/Commands/GenotypeExportLabKeySubcommand.swift:114-117` says "one of the five LabKey CSV files" | The count is exactly five. |
| 4.43 | "The set covers the final post-override haplotype calls, the per-sample per-allele read counts, the analyst overrides, the audit trail, and the saved cohorts." | true | `GenotypeExportLabKeySubcommand.swift:135-139` names `haplotype_calls.csv`, `allele_read_counts.csv`, `overrides.csv`, `audit_log.csv`, and `smart_cohorts.csv` | |
| 4.44 | "The command-line form is `lungfish genotype export-labkey` with a bundle path and an output directory." | true | cli-help `genotype.txt` usage `--bundle <bundle> --output-dir <output-dir>` | |
| 4.45 | "Editing and export are deterministic: run them again and the output does not move." | unverifiable | no source states determinism for the XLSX writers. A workbook may carry a generation timestamp | Would be settled by exporting the same bundle twice and comparing bytes, which is a write operation and out of bounds for this review. |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Tools > Haplotype Definitions item appears only when an enabled workflow declares the `haplotypeDefinitions` capability | `MainMenu.swift:708`, `WorkflowLibrary.swift:69-102, 162, 178` |
| `haplotypes bundle-install`, the eleventh subcommand | cli-help `haplotypes.txt` |
| `--include-shadowed` and `--include-reference-bundles` on `haplotypes list` | cli-help `haplotypes.txt` |
| `--change-note`, the provenance note carried on import, save, bundle-save, and duplicate | cli-help `haplotypes.txt` |
| `--compact-knowledge-pack`, which retrieves only prompt-relevant knowledge-pack records | cli-help `genotype.txt` |
| `--prompt-template-id` and `--prompt-template-version`, which pin a prompt for reproducibility | cli-help `genotype.txt` |
| `--temperature` default 0.0, `--max-output-tokens` default 4096, `--max-observations-per-chunk` default 10000, `--max-provider-retries` default 2 | cli-help `genotype.txt` |
| `--debug-output`, which validates a run without publishing a revision, and the chunk-index flags that pair with it | cli-help `genotype.txt` |
| `--population` and `--assay-resolution` prompt hints, such as `mcm` or `indian-rhesus` and `short-exon-amplicon` or `full-length` | cli-help `genotype.txt` |
| The `--lens`, `--min-reads`, `--filter`, and `--view-projection` provenance options on `genotype export` | cli-help `genotype.txt` |
| `Export Filtered Pivot...` also exists as a viewport button on non-MiSeq result shapes | `GenotypeResultViewController.swift:9658-9670` |
| The XLSX Matrix sheet colours ERR cells with the Lungfish danger colour and leaves absent cells unfilled | `GenotypeExportXLSXSubcommand.swift:14-16` |
| The export is provenance `inspectOnly` and never modifies the bundle or its sidecar | `GenotypeExportXLSXSubcommand.swift:22-23` |
| The definition editor's read-only diagnostic matrix adds one column per diagnostic target after the six fixed columns | `GenotypeHaplotypeDefinitionMatrixView.swift:278-283` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `haplotype-definition-editor` (planned) | recaption, haplotyping scope | The editor exists. Its caption's "aligned marker columns" is not a control name found in source. Under the campaign decision the whole definitions procedure becomes a placeholder. |
| `haplotype-ai-discovery` (planned) | recaption | The AI Discovery panel is reached from an `Actions` menu, which the caption should show. |
| `genotype-export-dialog` (planned) | no | Its caption promises "the XLSX, CSV, TSV, and samples-across pivot options" in one dialog. There is no in-app format picker. Recapture as the Actions menu plus the Inspector's Filtered Pivot button. |
| `genotype-labkey-export` (planned) | no | The LabKey export is command-line only. There is no in-app surface to photograph. Replace with a listing of the five CSV filenames. |
| `<!-- planned: haplotype-definition-editor -->` at line 106 | move | Step 1 becomes the haplotyping placeholder. |
| `<!-- planned: haplotype-ai-discovery -->` at line 141 | keep, recaption | Step 2 survives as an advisory-drafting section. |
| `<!-- planned: genotype-export-dialog -->` at line 187 | keep, recaption | Step 3 survives once the single-dialog framing is dropped. |
| `<!-- planned: genotype-labkey-export -->` at line 219 | drop | Step 4 has no in-app screen. |

---

## Verdict totals

| Chapter | Claims | True | False | Changed | Unverifiable |
|---|---|---|---|---|---|
| 01-what-is-mhc-genotyping | 21 | 10 | 5 | 6 | 0 |
| 02-running-genotyping | 43 | 27 | 6 | 9 | 1 |
| 03-reading-the-genotype-comparison | 32 | 16 | 10 | 6 | 0 |
| 04-haplotype-definitions-and-export | 45 | 37 | 3 | 4 | 1 |
| **Total** | **141** | **90** | **24** | **25** | **2** |

Only two rows stayed unverifiable. Row 2.18 asserts that a missing reference FASTA and an empty cluster set are the two most common failure causes, which no source in the repository can settle. Row 4.45 asserts that an export is byte-for-byte reproducible, which needs two write runs and is out of bounds for this review.

Rows carrying the corrected-wording marker `haplotyping (placeholder scope)`, which the rewriter must not work into prose: 1.6, 1.9, 1.10, 1.11, 1.13, 1.14, 1.15, 1.16, 1.17, 1.18, 2.33, 2.34, 2.42, 2.43, 3.5, 3.13, 3.15, 3.16, 3.17, 3.27, 3.28, 3.29, 3.30, 3.31, 4.1, 4.2, 4.8, 4.9, 4.10, 4.11, 4.12, 4.13, 4.14, 4.15, 4.16, 4.17, 4.18. That is 37 rows.
