# Results, fidelity and accessibility campaign 2026-09

Status: chapters complete, Phase 6 sweeps and verification done, screenshots pending Phase 5, merge pending the user's review.

## Summary

The campaign rewrote all 67 chapters on the roster in `DRIFT.md`, and every
roster row reads `done`. Every chapter passed a fidelity review against the
source tree and the `lungfish-cli` help dumps, a four-reader accessibility
panel, a synthesis pass, an editor pass, and a project-manager gate.

The Factual corrections table below holds 167 rows. Each one is a claim the
old manual made that a reviewer disproved against source, a CLI run, or a
committed fixture, and each is now corrected in the shipping chapter. They are
not evenly spread. Extracting a Consensus Sequence alone contributed 21, most
of them numbers that had been computed from a raw `samtools consensus` chain
rather than from the app's own normalized output. Variants and VCF Files
contributed 12, Extracting and Comparing 11, and Importing and Viewing 10.
Roughly a third of the total are wrong control labels, wrong menu paths, or
wrong button names, which is the failure mode a reader hits first and gives up
on.

Five chapters were added or retitled. Aligning Sequences and Building Trees are
new, split out of the old combined `02-sequences/04-msa-and-trees`, which was
deleted. Running External Workflows, The AI Assistant, and four Genotyping
chapters existed as files but had never been added to the navigation, so they
were unreachable from the manual's own table of contents. Exporting Genotypes,
Running Amplicon MHC Genotyping, Calling Variants, Reading the Variants Table,
Extracting a Consensus Sequence, and Importing NAO-MGS Results were retitled to
match what the app actually does. One chapter was deleted outright,
`05-variants/03-cross-caller-comparison`, because the cross-caller comparison
feature it described does not exist. Its one defensible paragraph was absorbed
into Reading the Variants Table.

No screenshots have been captured. All 207 `<!-- SHOT: id -->` markers across
59 chapters carry status `new`, and capture is Phase 5, pending.

Three fixes were larger than the rest. The AI Assistant chapter described a
floating window that opens beside the main window and remembers its position,
when in fact **View > AI Assistant** reveals a tab inside the Inspector and the
floating-window controller is dead code constructed only in a test, so the
entire chapter was rewritten around the Inspector's Assistant tab and retitled.
Reading the Genotype Comparison told readers to work from an in-window cohort
summary panel and a Smart Cohorts section that are both hidden by design on a
genotype-only result, which is the only kind of result the Williams fixture
produces, so seven claims collapsed to two root causes and the chapter now
routes the cohort-level depth judgement through `genotype list-samples`
instead. The assembly chapters had to be rewritten around a tool that mostly
does not work, because MEGAHIT 1.2.9 fails about four runs in five on Apple
Silicon with both shipped workarounds active, a finding that five reruns
established and that now carries a fixed caution paragraph in every chapter
offering MEGAHIT.

## Factual corrections

One row per correction. Columns: chapter, old claim, corrected claim, evidence.

| Chapter | Old claim | Corrected claim | Evidence |
|---|---|---|---|
| 01-foundations/02-sequencing-reads | Click any of the three sparklines to open it full size in a popover | Only the length chart opens a popover, the two quality charts read Click to Compute until a report runs | `FASTQSparklineStrip.swift:103-115` gates the popover on kind and quality data |
| 01-foundations/02-sequencing-reads | The Operations tab offers Compute Quality Report | The Operations tab lists categories, and QC & Reporting holds Refresh QC Summary | no control carries that label, the string is a code comment only |
| 01-foundations/03-amplicon-vs-shotgun | LGE's Primer Remove operation strips primer bases | The operation is Primer Trimming, and `primer-remove` is only the CLI subcommand | `FASTQOperationDialogState.swift:1961` titles it Primer Trimming |
| 01-foundations/03-amplicon-vs-shotgun | Its engine is bbduk by default with cutadapt-linked as the alternative | True of the CLI only, the app picks the engine from the primer source | `FASTQOperationDialogState.swift:546-565` maps sequence to bbduk and FASTA to cutadapt |
| 01-foundations/04-alignment-files | A CSI index takes BAI's place where a reference is too long | Every LGE-written index is BAI, and CSI is only read from imported BAMs | bare `samtools index` at `ManagedMappingPipeline.swift:903`, no call site passes `-c` |
| 01-foundations/04-alignment-files | Every BAM gets a .bam.bai or a .csi depending on the data | Every BAM LGE writes gets a `.bam.bai` | same evidence, the index path is hard-coded |
| 01-foundations/04-alignment-files | LGE picks the right index format without asking | sentence deleted, no selection logic exists | `ManagedMappingPipeline.swift:272` hard-codes `.bam.bai` |
| 01-foundations/04-alignment-files | All four BAM checks are visible in the viewport and the Inspector | The results table reports three, the coverage track labels depth, the Inspector records the mapped rate | `MappingDocumentStateBuilder.swift:115-120` carries no depth or breadth row |
| 01-foundations/05-variants-and-vcf | The fixture's bcftools VCF carries 29 header lines | 30 header lines | `bcftools view -h` piped to `grep -c '^##'` returns 30 |
| 01-foundations/05-variants-and-vcf | Its LoFreq VCF carries 18 header lines | 19 header lines | `grep -c '^##'` returns 19 |
| 01-foundations/05-variants-and-vcf | The indel sits at line 33 (author note) | line 43 | line 33 is an SNV in the decompressed stream |
| 01-foundations/05-variants-and-vcf | A variant track is stored as a BCF with a CSI index | Stored as a bgzip VCF with a tabix index and a SQLite sidecar | `BundleVariantTrackAttachmentService.swift:71-74` writes `.vcf.gz`, `.tbi`, `.db` |
| 01-foundations/05-variants-and-vcf | LGE writes a VCF from the stored BCF when one is needed | The stored payload is already a VCF, so it is copied or filtered | follows from the storage correction above |
| 01-foundations/05-variants-and-vcf | One column per VCF field plus a gene name from an attached GFF3 | Twelve fixed columns plus promoted INFO keys, Gene included | `AnnotationTableDrawerView+Columns.swift:312-323` and `:528` |
| 01-foundations/05-variants-and-vcf | Filter chips sit above the table | A **Presets** disclosure button above the table reveals them | `AnnotationTableDrawerView+Columns.swift:69` sets the Presets title |
| 01-foundations/05-variants-and-vcf | The nine listed chips are the complete set | Fourteen tokens exist, and Bookmarked plus three frequency chips were undocumented | `SmartFilterTokens.swift:15-30` |
| 01-foundations/05-variants-and-vcf | Rows hidden by a chip stay in the underlying BCF | stay in the underlying track | only the format word was wrong |
| 01-foundations/05-variants-and-vcf | The variants command group holds three subcommands | Four, the chapter omitted `variants phase` | `cli-help/variants.txt` |
| 01-foundations/05-variants-and-vcf | Both caller versions are recorded in the provenance sidecar | bcftools is recorded, LoFreq's field holds an error string | LoFreq rejects `--version`, sidecar step 3 stores the FATAL line |
| 01-foundations/05-variants-and-vcf | The two caller VCFs are rebuilt rather than committed | Both VCFs and both indexes are committed | `git ls-files` returns them, 46 KB and 16 KB against a 10 MB cap |
| 01-foundations/06-the-lungfish-project | The Inspector shows mean coverage and how evenly it is spread | It shows mapped and unmapped counts, mapped rate, mapper, and preset | `MappingDocumentStateBuilder.swift:110-140` has no coverage row |
| 01-foundations/06-the-lungfish-project | A selected variant shows INFO and FORMAT fields, per-strand counts, and a copy-position button | Position, alleles, quality, filter, a genotype summary, INFO fields, and a Copy Info button | `VariantSection.swift:309-440`, no FORMAT section exists |
| 01-foundations/07-plugin-packs | Every tool wears one of four status labels | Six labels exist, and managed data rows read Needs download or Needs refresh | `PluginPackStatusService.swift:69-82` |
| 01-foundations/07-plugin-packs | Several packs can install at once without interfering | Installs are serialised behind an exclusive lock on the conda root | `CondaRootMutationLock.swift:36` |
| 01-foundations/07-plugin-packs | The wastewater-surveillance pack ships Freyja | It ships Freyja, iVar, Pangolin, Nextclade, and minimap2 | `PluginPack.swift:842-869` |
| 01-foundations/07-plugin-packs | Sixteen databases are listed on the Databases tab | Thirteen, the lock's other three are filtered out of the catalogue | `MetagenomicsDatabaseInfo.swift:406-409` |
| 01-foundations/07-plugin-packs | Three entries on the Databases tab handle human sequence removal | None of the three appears there, they arrive with Required Setup | same filter, confirmed by `conda db list` |
| 01-foundations/07-plugin-packs | This is the one place in the chapter where you type a command | The only step in the walkthrough that does, the chapter prints eleven more later | the chapter contradicted itself |
| 01-foundations/08-provenance-and-reproducibility | The fixture instructions create the demo project for you | They have you create it in the app first, the CLI cannot create a project store | `fixtures/demo-project/README.md:10-27` |
| 01-foundations/08-provenance-and-reproducibility | In the bcftools chain step 3 is the pileup and step 4 the call | Step 4 is the pileup and step 5 the call, step 3 is `samtools faidx` | the demo project's provenance sidecar |
| 01-foundations/08-provenance-and-reproducibility | The Inspector shows No Provenance Available for an item without a record | It shows Missing provenance or No provenance required, the alert belongs to a failed export | `ProvenanceInspectorViewModel.swift:536-540` |
| 01-foundations/08-provenance-and-reproducibility | Each provenance subcommand takes a sidecar, a bundle, or a directory | True of export and verify, `bibliography` takes only a bundle or directory | `cli-help/provenance.txt` argument help |
| 01-foundations/08-provenance-and-reproducibility | `provenance bibliography` run against the project root | It fails there, the example now points at a reference bundle | run returns No Lungfish provenance sidecar found |
| 02-sequences/01-importing-and-viewing | Click OK on the annotation import alert | Click **Import** | `ReferenceBundleAnnotationImportConfigurationPresenter.swift:58-59` |
| 02-sequences/01-importing-and-viewing | Selecting more than one file skips the alert | The alert still shows, only the Reference choice is used | `AppDelegate+ImportCenter.swift:94-113` branches after the alert returns |
| 02-sequences/01-importing-and-viewing | The Inspector shows a Sequence Length row reading 81,706 | A Total Length row reading 81.7 Kb | `DocumentSection.swift:841` and `formatBases` at `:1562-1575` |
| 02-sequences/01-importing-and-viewing | The bundle's right-click menu offers three items | It also offers Copy Path, Show in Inspector, Duplicate, and a Move to submenu | `SidebarViewController+MenuDelegate.swift:311-361` |
| 02-sequences/01-importing-and-viewing | Go to Gene opens a picker over the annotation names | It opens a dialog where you type a gene name | `AppDelegate+SequenceMenu.swift:118-125` builds a free-text field |
| 02-sequences/01-importing-and-viewing | Clicking a feature block centres the view on it | It selects the feature, and Zoom to Annotation centres | `SequenceViewerView+Interaction.swift:510-522` |
| 02-sequences/01-importing-and-viewing | Confirm the Inspector length reads 81,706 | Confirm Total Length reads 81.7 Kb | same as the Total Length row above |
| 02-sequences/01-importing-and-viewing | `lungfish-cli translate` run against the `.gb` fixture | translate requires FASTA, the example now points at the bundle's sequence | run exits Unsupported format: gb |
| 02-sequences/01-importing-and-viewing | `lungfish-cli extract sequence` run against the `.gb` fixture | extract requires FASTA, same fix | run exits Unsupported format: gb |
| 02-sequences/01-importing-and-viewing | Body image link `viewport-lanes.png` | The asset is `viewport-panes.png` | the illustrations folder holds no `viewport-lanes` |
| 02-sequences/02-downloading-from-ncbi | The Pathoplexus settings section covers the filters | Host and Sequence Length paragraphs were missing | the registry lists 11 settings, the chapter documented 9 |
| 02-sequences/02-downloading-from-ncbi | Nine filters sit in the Advanced Search Filters panel | Ten | `DatabaseBrowserPane.swift:305-395` |
| 02-sequences/03-extracting-and-comparing | Extractions never land in `Imports/` or `Reference Sequences/` | The annotation route writes a reference bundle into `Reference Sequences/` | `ViewerViewController.swift:2657-2662` calls `createReferenceBundle` |
| 02-sequences/03-extracting-and-comparing | Each route offers the same four destinations | The annotation route offers four, the visible-region route a three-way Action picker | `ExtractionConfigurationView.swift:92-103` |
| 02-sequences/03-extracting-and-comparing | The sheet header carries an "N selected" count | That header belongs to a different sheet this menu item never opens | `FASTASequenceExtractionDialog.swift:34` |
| 02-sequences/03-extracting-and-comparing | Pick one of the four Destination choices | Pick one of the Action choices, Copy as FASTA, Copy Protein, or New Bundle | no Destination group exists on this sheet |
| 02-sequences/03-extracting-and-comparing | The button label follows the destination | The button is fixed and reads Extract | `ExtractionConfigurationView` has a fixed action button |
| 02-sequences/03-extracting-and-comparing | The window cannot delete a whole track, removal is a command-line job | The annotation table drawer's track menu offers Delete Track... | `AnnotationTableDrawerView+Filtering.swift:1207-1215` |
| 02-sequences/03-extracting-and-comparing | The Extract Sequence sheet has two controls | The visible-region sheet has six and the annotation sheet has two | `ExtractionConfigurationView` plus `parameters.yaml:6804` |
| 02-sequences/03-extracting-and-comparing | Neither extraction operation is in the settings registry | Both are, as `sequence.extract-region` and `sequence.find-orfs` | `parameters.yaml:6804` and `:6720` |
| 02-sequences/03-extracting-and-comparing | The ORF Track ID is prefilled from the same source as the name | It is generated as `orfs-<sequence>` | `defaultSequenceAnnotationTrackID` in `AppDelegate+SequenceMenu.swift` |
| 02-sequences/03-extracting-and-comparing | The HBB CDS is 444 bases and 147 codons | 444 bases is 148 triplets, 147 amino acids plus a stop codon | the record's `/translation` is 147 characters |
| 02-sequences/03-extracting-and-comparing | Extract the CDS from the annotation lane to get `[exons concatenated]` | That header comes from Extract Visible Region with Concatenate Exons on | the annotation route passes no arguments |
| 02-sequences/05-building-trees | Re-rooting leaves the branch lengths and groupings alone | On this release it duplicates every non-root tip, so groupings do not survive | reproduced, 5 tips became 13 |
| 02-sequences/05-building-trees | A Nodes drawer sits on the right | It runs across the bottom of the window | `PhylogeneticTreeViewController.swift:311-314` |
| 02-sequences/05-building-trees | Those two sit on the shortest branches, 0.0650 and 0.0299 | 0.0299 is the shortest tip branch, 0.0650 is not the second | the seven branch lengths, recomputed |
| 02-sequences/05-building-trees | Re-root Here writes a new bundle rooted on the node you clicked | It writes a bundle, but that bundle duplicates tips and is unusable | same reproduction as above |
| 03-reads/01-importing-fastq | An unpaired sample shows one R1 line and no R2 line | It shows the bare filename with a size beneath and no R1 or R2 labels | `FASTQImportConfigSheet.swift:603` |
| 03-reads/01-importing-fastq | The cards read Mean Length 248.6, Median 250, N50 250 | The cards round, so the Mean Length card reads 249 bp | card formatting rounds to a whole base |
| 03-reads/01-importing-fastq | The Mean Q card reads 24.87 | It reads 24.9 | `FASTQChartViews.swift:36` formats with `%.1f` |
| 03-reads/01-importing-fastq | The quality charts stay empty until a report runs | The import measures the chart data, so all three are populated at once | the scratch bundle's `computedStatistics` holds both quality series |
| 03-reads/01-importing-fastq | An import silently skips a sample whose bundle already exists | The app shows a duplicate dialog offering Replace, Keep Both, or Skip | skipping is the CLI behaviour, not the app's |
| 03-reads/01-importing-fastq | The glossary anchor `FASTQ` resolves | The anchor is lowercase `fastq` | `GLOSSARY.md:119` |
| 03-reads/02-downloading-from-sra | The query field is at the top with Import Accessions below | Import Accessions sits above the query field in its own card | `DatabaseBrowserPane.swift:24-30` |
| 03-reads/02-downloading-from-sra | The primary button changes from Search to Download Selected | True of the dialog's bottom button, but a second Search button sits beside the field | `DatabaseSearchDialogState.swift:112-114` |
| 03-reads/05-decontamination | The Database row has Choose... and Clear buttons | The first button reads Replace... once a database is chosen | `FASTQOperationToolPanes.swift:208-219` |
| 03-reads/05-decontamination | The result lands under `Analyses/<tool>-<timestamp>/` | It lands directly under `Analyses/` | `MainSplitViewController+GenomicsDisplay.swift:993-994` |
| 03-reads/05-decontamination | The three decontamination databases | Two, PhiX is a FASTA inside BBTools rather than a database | `third-party-tools-lock.json:27-28` |
| 03-reads/05-decontamination | The SARS-CoV-2 fixture folder sits beside the first one with reads in it | The folder holds no reads, they are regenerated or fetched from SRA | `fixtures/sarscov2-srr36291587/README.md` |
| 03-reads/05-decontamination | Three flags exist only on the command line | Four, plus more on `deacon-ribo` | the sentence's own list |
| 04-alignments/01-mapping-reads-to-a-reference | Output folders look like `Analyses/minimap2-20260906-134512/` | `Analyses/minimap2-2026-09-06T13-45-12/` | `AnalysesFolder.swift:121,139-140` |
| 04-alignments/01-mapping-reads-to-a-reference | A CRAM is converted on the way in | A CRAM stays a CRAM, sorted and indexed in place | `BAMImportService.swift:369-393` |
| 04-alignments/01-mapping-reads-to-a-reference | Below the five sits a collapsed Flag Stats list | The disclosure is titled Flag Statistics | `ReadStyleSection.swift:1101` |
| 04-alignments/04-alignment-quality | LGE reports an average of the depth in the Inspector | It reports an estimate from an assumed 150-base read | `ReadStyleSection.swift:948-950` |
| 04-alignments/04-alignment-quality | A duplicate-marking run refuses to start while a bundle is locked | No guard exists on that workflow, the guard is real for primer trim and filtering | `InspectorViewController+TrimDuplicateWorkflows.swift:615-683` |
| 04-alignments/04-alignment-quality | Wait for the duplicate-marking row in the Operations panel | No row appears, the workflow never registers | neither duplicate workflow calls `OperationCenter.shared.start` |
| 04-alignments/04-alignment-quality | On the HG002 slice Est. Coverage reads 44.7x | It reads 27.3x, and 44.7x is the measured mean depth | `90990 * 150 / 500001` is 27.2969 |
| 04-alignments/04-alignment-quality | Switch to the View tab and open the Analysis section | Analysis is a top-level Inspector tab | `InspectorSupportingTypes.swift:67-87` |
| 04-alignments/04-alignment-quality | The Operations panel carries the duplicate-marking row | clause deleted | same as above |
| 04-alignments/04-alignment-quality | Name for New Alignment has no default and blocks the run | It auto-fills with a name describing the filters | `ReadStyleSection.swift:197-201` |
| 04-alignments/04-alignment-quality | Est. Coverage of 44.7x is the average depth across the slice | Mean depth is 44.7x, Est. Coverage reads 27.3x | measured mean depth is 44.7234 |
| 04-alignments/04-alignment-quality | Marking duplicates leaves the original BAMs on disk | It deletes both the source BAM and its index | `AlignmentDuplicateService.swift:230-254` |
| 04-alignments/05-viral-recon-wizard | The Scheme setting maps to `--param primer_set_version` | It maps to `--param primer_bed` plus the two suffix parameters | `primer_set_version` appears nowhere in source or CLI help |
| 04-alignments/05-viral-recon-wizard | The structural set holds five primer parameters | Four | `ViralReconRunRequest.swift:262-265` |
| 04-alignments/05-viral-recon-wizard | Link text "Plugin Packs and Databases" | "Plugin Packs" | the target chapter's front-matter title |
| 04-alignments/05-viral-recon-wizard | Link text "Importing FASTQ Files" | "Importing Sequencing Reads" | the target chapter's front-matter title |
| 05-variants/05-consensus-and-lineage | Deletions appear as `*` in the consensus | Every `*` is rewritten as `N`, so the alphabet is ACGTN only | `AlignmentDataProvider.swift:280` normalizes before returning |
| 05-variants/05-consensus-and-lineage | The run refuses to start with a message when nothing is highlighted | The button greys out and the line appears beneath it, so no run starts | `ReferenceBundleViewportController` resolves the scope eagerly |
| 05-variants/05-consensus-and-lineage | The Destination menu opens on four choices | Destination is a static column of four radio-style buttons | `FASTASequenceExtractionDialog` renders a ForEach |
| 05-variants/05-consensus-and-lineage | 499,006 plain bases, 724 N, and 271 asterisks | 498,974 plain bases and 1,027 N, no asterisks at all | recomputed against the app's normalized output |
| 05-variants/05-consensus-and-lineage | Masked share is 0.145 percent, over 99.8 percent called | 0.205 percent, a little under 99.8 percent called | 1,027 of 500,001 |
| 05-variants/05-consensus-and-lineage | The 271 asterisks are marked deletions rather than silently dropped | They are folded into the N count and are not separable | follows from the normalization |
| 05-variants/05-consensus-and-lineage | 608 positions differ from the reference | 337, once the asterisks are excluded | 608 was the raw-caller figure |
| 05-variants/05-consensus-and-lineage | Defaults row of the settings table, 724 and 0.145 percent | 1,027 and 0.205 percent | app-faithful recomputation |
| 05-variants/05-consensus-and-lineage | Minimum depth raised to 20, 5,339 and 1.068 percent | 5,646 and 1.129 percent | app-faithful recomputation |
| 05-variants/05-consensus-and-lineage | Consensus Mode set to Simple, 888 and 0.178 percent | 1,176 and 0.235 percent | app-faithful recomputation |
| 05-variants/05-consensus-and-lineage | IUPAC ambiguity codes on, 171 and 0.034 percent | 361 and 0.072 percent | app-faithful recomputation |
| 05-variants/05-consensus-and-lineage | Minimum MAPQ raised to 20, 800 and 0.160 percent | 1,107 and 0.221 percent | app-faithful recomputation |
| 05-variants/05-consensus-and-lineage | Raising the depth floor masks 4,615 more, a sevenfold increase | 4,619 more, roughly a fivefold increase | 5,646 over 1,027 |
| 05-variants/05-consensus-and-lineage | Simple mode masks 164 more positions than Bayesian | 149 more | 1,176 minus 1,027 |
| 05-variants/05-consensus-and-lineage | Ambiguity codes mask 553 fewer | 666 fewer | 1,027 minus 361 |
| 05-variants/05-consensus-and-lineage | R appeared 184 times with 178 in the remaining codes | R 182 times with 176 in the remaining codes | recounted after normalization |
| 05-variants/05-consensus-and-lineage | The three settings that move those numbers most | The table carries four changed settings plus a baseline | independent of the numeric corrections |
| 05-variants/05-consensus-and-lineage | The Operations panel row carries a summary block when the run finishes | Only the Copy to Clipboard path logs it, saving records the settings in provenance | `ViewerViewController+Mapping.swift:354` |
| 05-variants/05-consensus-and-lineage | The FASTA header names the sample, contig, scope, and the word consensus | Whole contig omits the scope word, a selected region adds coordinates | `MappingConsensusExportRequest` builds the header |
| 05-variants/05-consensus-and-lineage | The fixture's 0.145 percent at the defaults is comfortable | 0.205 percent | follows from the recomputation |
| 05-variants/05-consensus-and-lineage | Front matter entry point "Inspector > Analysis > Consensus" | "the Inspector's Consensus tab" | CONSISTENCY line 30 |
| 05-variants/06-importing-existing-vcfs | The writability check runs on every VCF import on every path | It runs on the attach and naked paths, not on the CLI import | `AppDelegate+ImportCenter.swift:48-53` |
| 05-variants/06-importing-existing-vcfs | Its only options are the input file and `--output-dir` | It also accepts `--format` and the global option group | `cli-help/import.txt:72` |
| 05-variants/06-importing-existing-vcfs | Both export commands cap at 5,000 records | Only `variants query` has a limit, `extract-sample` writes every row | `VariantsCommand.swift:721-722` |
| 06-classification/01-what-is-classification | Picking a classifier opens a window titled FASTQ/FASTA Operations | It opens a sheet with that heading and the classifier preselected | `DatasetOperationsDialog.swift:72-73` renders it as a sheet |
| 06-classification/01-what-is-classification | Clicking a taxon in one of three views updates the other two | The sunburst and table are linked, the breadcrumb follows drill-down | `TaxonomyViewController.swift:896-940` |
| 06-classification/02-running-kraken2 | 86,281 paired-end read pairs were classified | 85,199 pairs, which is the copy actually classified | the archived run's count differs from the classified copy |
| 06-classification/02-running-kraken2 | Nine Kraken 2 collections are listed | Eleven rows, nine downloadable plus SILVA and Greengenes | `PluginManagerView.swift:893-905` |
| 06-classification/02-running-kraken2 | The recommendation names the largest collection that fits your memory | The largest general-purpose collection fitting 60 percent of RAM | `MetagenomicsDatabaseRegistry.swift:966-983` |
| 06-classification/02-running-kraken2 | The row is titled Classifying SRR36291587 | It is titled Profiling SRR36291587_1.fastq, because the dialog always profiles | `ClassificationWizardSheet.swift:664-668` emits `goal: .profile` |
| 06-classification/02-running-kraken2 | The provenance popover lists the preset and the confidence | It lists tool, database and path, confidence, hit groups, threads, memory mapping, runtime, input, Bracken, run id | `TaxonomyProvenanceView.swift:53-101` |
| 06-classification/02-running-kraken2 | The other three hits are one Vibrio phage read and two others | Two Vibrio phage reads, one frog adenovirus, one picorna-like virus | `run-sensitive/classification.kreport` |
| 06-classification/02-running-kraken2 | The kreport is the six-column summary | Every kreport LGE writes has eight columns | `ClassificationConfig.swift:402` always appends `--report-minimizer-data` |
| 06-classification/02-running-kraken2 | Copy Taxonomy Path puts the numeric taxid on your clipboard | It copies the chain of names, the taxid is the kreport's seventh column | `TaxonomyViewController.swift:1434-1443` |
| 06-classification/02-running-kraken2 | The taxid sits in the kreport's fifth column | The seventh, column five holds distinct minimizers | the SARS-CoV-2 row of an LGE-written kreport |
| 06-classification/03-running-esviritu | The EsViritu Viral DB is listed among the classification databases | It is the only row under its own EsViritu Databases heading | `MetagenomicsModels.swift:36` |
| 06-classification/03-running-esviritu | A Run Mode control appears fixed on Run separately per bundle | It offers that plus a greyed-out Combine all inputs | `MultiBundleRunModePicker.swift:63-80` |
| 06-classification/03-running-esviritu | The lock reason is that pooling would mix up the coverage numbers | The on-screen caption says something else, the rationale is the chapter's own | `EsVirituWizardSheet.swift:112-114` |
| 06-classification/03-running-esviritu | The progress line names each phase in a fixed sequence | Phases are matched by substring against stderr, so order is not guaranteed | `EsVirituPipeline.swift:787-800` |
| 06-classification/03-running-esviritu | The Identity column reads 99.7% | The column renders the stored fraction with a percent sign, showing 1.0% | `EsVirituDetailPane.swift:391` versus the column formatter |
| 06-classification/03-running-esviritu | The Export menu offers Copy for the clipboard | It offers Copy Summary and Show Provenance... | `EsVirituResultViewController.swift:1754-1789` |
| 06-classification/04-running-taxtriage | The result folder is `taxtriage-<timestamp>` | `taxtriage-batch-<timestamp>`, every run is named a batch | `AppDelegate+Classification.swift:2177-2183` passes `isBatch: true` |
| 06-classification/04-running-taxtriage | All six advanced labels carry a trailing colon | Five do, Skip Krona visualization is a toggle without one | `TaxTriageWizardSheet.swift:534` |
| 06-classification/04-running-taxtriage | The organism table has nine columns | Six, the nine belong to the multi-sample flat table | `BatchTaxTriageTableView.swift:249-260` is a different view |
| 06-classification/04-running-taxtriage | The reference run returned exactly one organism | One call worth acting on, the viewport shows fifteen lineage rows | `run-viral/taxtriage.sqlite` holds fifteen rows |
| 06-classification/04-running-taxtriage | The action bar carries Export, Open Report, Related, and provenance | It also carries Extract FASTQ between Export and the custom slot | `ClassifierActionBar.swift:4xx` |
| 06-classification/04-running-taxtriage | A summary table above the grid gives mean score and sample count | There is no second table, those are the grid's leading columns | `TaxTriageBatchOverviewView.swift:129` is one table view |
| 06-classification/04-running-taxtriage | A flagged organism's name is coloured with a Contamination risk tooltip | The overview adds a Risk column with a warning triangle and a different tooltip | the paragraph described the single-sample table |
| 06-classification/04-running-taxtriage | The extract example passes `--taxon` for TaxTriage | TaxTriage requires `--accession`, `--taxon` is a Kraken 2 selector | `ExtractReadsCommand.swift:306-309` |
| 06-classification/04-running-taxtriage | Copy TaxID gives the value the extract command wants | Copy Accession Number does | follows from the flag correction |
| 06-classification/05-running-nao-mgs | The bundle is named after the first sample the table names | It is named from the input file stem, as `naomgs-virus_hits_final` | the run's own output against `manifest.sampleName` |
| 06-classification/05-running-nao-mgs | The default name is derived from the first sample in the table | From the input file, and the sample label is the first alphabetically | same evidence |
| 06-classification/05-running-nao-mgs | Point the importer at the project folder and it places the bundle under Analyses | It writes directly into whatever directory you name | `MetagenomicsImportService.swift:855-860` |
| 06-classification/05-running-nao-mgs | The Taxa card reports distinct taxa | It counts table rows, one per sample-taxon pair | `NaoMgsResultViewController.swift:3260-3261` |
| 06-classification/05-running-nao-mgs | The bar read 5 samples and 4 taxa | 5 samples and 7 taxa, those 7 rows covering 4 organisms | the bar counts `taxon_summaries` rows |
| 06-classification/05-running-nao-mgs | The line reads `Taxid N` | It reads `Taxid: N` | the format string carries a colon |
| 06-classification/05-running-nao-mgs | Panels are ordered by unique read count | They are ordered by total hit count, and the note above them mislabels it | `NaoMgsDatabase+Queries.swift:235` orders by `read_count` |
| 06-classification/05-running-nao-mgs | The Extract FASTQ button and the command produce identical output | The button additionally narrows to the taxon's read names | `NaoMgsResultViewController.swift:1836-1857` builds an allowlist |
| 06-classification/07-running-freyja | Open the Plugin Manager and install the pack | Turn on Show Experimental Features first, the pack is hidden otherwise | `PluginManagerViewModel.swift:492` filters on the setting |
| 06-classification/07-running-freyja | The pack's card is marked Experimental in the Plugin Manager | It is hidden rather than badged while the toggle is off | same filter |
| 06-classification/08-importing-cz-id-results | The JSON form carries the TSV column names plus four extras | It uses camel-case keys throughout | the rerun's own output |
| 09-genotyping/01-what-is-mhc-genotyping | The quoted allele group record has two members | Three, the chapter dropped the middle one | the library's real record |
| 09-genotyping/01-what-is-mhc-genotyping | Six `.lungfishgenotype` bundles from repeated runs (author note) | Seven | the folder listing |
| 09-genotyping/01-what-is-mhc-genotyping | Lengths from 153 to 251 bases (author note) | 153 to 247 bases | measured range |
| appendices/ai-assistant | Ask which variants fall inside a named gene | The fixture has no annotations, so the question cannot be answered | `chr20_10.0-10.5Mb.lungfishref/manifest.json` has an empty annotations array |
| appendices/ai-assistant | With no key you get a message saying no provider has a usable key | You get a message that the API key is not configured, pointing at Settings > AI Services | `AIAssistantService.swift:266` |
| appendices/ai-assistant | The panel still opens and shows suggested questions with no account | The tab is not built at all until the toggle is on | `InspectorViewModel.swift:44-47` |
| appendices/ai-assistant | While the toggle is off the panel refuses every question with a reply | There is no assistant to type into, the menu item raises an alert instead | the string exists but is unreachable |
| appendices/ai-assistant | A floating window titled AI Assistant opens beside the main window | The Inspector opens with its Assistant tab selected, there is no window | `AppDelegate+MenuActions.swift:499-526` reveals the Inspector |
| appendices/ai-assistant | Shot caption, the AI Assistant panel floating beside a viewport | The Assistant tab of the Inspector beside a viewport | nothing floats |
| appendices/keyboard-shortcuts | Delete sits between Select All and the Find submenu | It sits just above Select All | `MainMenu.swift:382-397` |
| appendices/keyboard-shortcuts | Reset View Settings to Defaults sits at the bottom of the View menu | Near the bottom, Enter Full Screen follows it | `MainMenu.swift:597-613` |
| appendices/tool-versions | The lock lives at `Contents/Resources/third-party-tools-lock.json` | It lives inside the workflow resource bundle several levels deeper | `find` over the installed app returns one path |
| appendices/tool-versions | The bedGraphToBigWig license cell reads "Varies, see ..." | The lock stores a semicolon, "Varies; see ..." | the lock's `license` field |
| appendices/tool-versions | The command writes display names such as `SAMtools` | It writes `Samtools` | `ManagedToolLock.swift:39` |
| appendices/troubleshooting | Turn the Workflow Library card's Enabled switch on, then click Install Dependencies | The Install Dependencies button stands in place of the switch when packs are missing, and it enables the workflow itself | WorkflowLibraryPanelView.swift:346-360 |
| appendices/troubleshooting | Exit status 64 means a usage refusal | 64 is a workflow error and 2 is the usage error | LungfishCLI.swift:154 |
| appendices/troubleshooting | `project migrate` appears in neither the CLI Reference nor the help dumps | It is in both and Shared Projects documents it, so the section was dropped for scope rather than absence | ProjectCommand.swift:249, cli-help/project.txt:83 |

## Features the old manual described that do not exist

| Chapter | Claim | Evidence |
|---|---|---|
| appendices/ai-assistant | A floating AI Assistant window that stays in front of the main window and remembers its position | The window controller is dead code constructed only in a test, the feature is an Inspector tab |
| appendices/ai-assistant | An Azure endpoint-kind setting | No control exists for it |
| 06-classification/01-what-is-classification | Per-classifier accent colours, Kraken2 blue, EsViritu green, TaxTriage purple, NAO-MGS amber | No per-classifier colour constant exists in the shipping app |
| 06-classification/01-what-is-classification | A workflow divider in the Classification submenu | The app never draws one |
| 09-genotyping/03-reading-the-genotype-comparison | The comparison matrix's own filter field and locus popup | Both are built and hidden, so a reader can never use them |
| 09-genotyping/03-reading-the-genotype-comparison | Smart Cohorts on a genotype-only result | Not rendered, and its guard is doubled |
| 09-genotyping/03-reading-the-genotype-comparison | The in-window cohort summary panel on a genotype-only result | Hidden by design, with two tests asserting the behaviour |
| 09-genotyping/04-haplotype-definitions-and-export | The Actions menu and the Audit lens on a genotype-only result | Both hidden, so Filtered Pivot... is the only in-app export |
| 01-foundations/06-the-lungfish-project | Save Project with Cmd-S | No such menu item, the project saves as you work |
| 01-foundations/06-the-lungfish-project | Cancelling a running operation with Cmd-Period | No such binding, cancel is on the row's context menu |
| 01-foundations/04-alignment-files | Automatic BAI or CSI index selection | No selection logic exists, the path is hard-coded to BAI |
| 01-foundations/05-variants-and-vcf | A `Presets > PASS` chip path in a filter bar | Chips sit behind a Presets disclosure button, there is no filter bar |
| 01-foundations/05-variants-and-vcf | A separate variant browser window | Variants live in the table drawer's Variants tab |
| 01-foundations/07-plugin-packs | The `classification-kraken2`, `classification-esviritu`, `classification-taxtriage`, and `classification-naomgs` packs | No such packs, their tools are in one `metagenomics` pack |
| 01-foundations/07-plugin-packs | The `read-qc` pack | No such pack, fastp arrives with Required Setup |
| 01-foundations/07-plugin-packs | The `decontamination` pack | No such pack, Deacon is Required Setup and RiboDetector is in `metagenomics` |
| 02-sequences/03-extracting-and-comparing | A Concatenate Exons control reachable on the annotation route | The control exists but no caller passes an annotation source, so it is dead in this release |
| 02-sequences/03-extracting-and-comparing | A four-destination sheet on the visible-region route | That sheet belongs to the annotation route, the visible-region route has a three-way Action picker |
| 03-reads/03-quality-control | A control labelled Compute Quality Report | The string appears only in a code comment, the operation is Refresh QC Summary |
| 04-alignments/04-alignment-quality | A bundle lock and an Operations row for duplicate marking | Neither workflow guards or registers, so no lock and no row |
| 05-variants/02-reading-the-variant-browser | The Het Only filter chip | Defined but never offered, its availability check always returns false |
| 05-variants/06-importing-existing-vcfs | A File > Open VCF menu item | `importVCFToBundle` has no menu item, so the features.yaml entry is unreachable |
| 06-classification/04-running-taxtriage | A separate cross-sample summary table above the batch grid | There is one table, those are its leading columns |
| 06-classification/08-importing-cz-id-results | An `Analyses/cz-id-<timestamp>` destination | The sheet composes that path but no import writes to it |
| 06-human-germline-variants/01-haplotype-caller | A working GATK plus WhatsHap Phased dialog entry | It builds a plan nothing consumes and raises Variant Calling Not Ready |
| 07-assembly/02-running-spades | Align with MAFFT on the assembly contig context menu | Absent rather than greyed out, because the handler is never passed |
| 07-assembly/02-running-spades | A Min Contig control that reaches SPAdes | Shown and editable but never reaches the command |
| 07-assembly/03-running-flye-or-hifiasm | Circularity or multiplicity columns in the assembly viewport | Neither exists, so a doubled circular contig looks healthy |
| 08-workflows/01-the-workflow-builder | Node parameters editable from the builder inspector | Only Label, tool, Configure..., ports, and validation appear there |
| appendices/power-user-notes | `ops stats --format json` and `--format tsv` | Advertised and unimplemented |
| appendices/file-formats | A runnable `bundle export` command | Its `--format` collides with the global option, so it cannot be run |
| appendices/file-formats | Writable SAM and VCF entries in the format registry | Marked writable with no writer class behind them |
| appendices/primer-schemes | `primers` subcommands for inspecting a scheme | The group advertises inspection but has only `import` |
| appendices/shared-projects | Stale-lock recovery from the window | Unreachable dead code |
| appendices/tool-versions | A Source column carried in the lock, and a micromamba license | The old page presented a derived column as lock data and invented the license |

## Features the old manual omitted

| Feature | Chapter that now covers it | Evidence |
|---|---|---|
| The `.lungfish` directory bundle and its hidden `.project.db` and `metadata.json` | 01-foundations/06-the-lungfish-project | `ProjectFile.swift:15-16,98,392-399` |
| Chromosome-name mapping between reference naming conventions | 01-foundations/01-what-is-a-genome | `ChromosomeNameMapping.swift` |
| The `.lungfishref` bundle's `genome/`, `annotations/`, `variants/`, and `tracks/` folders | 01-foundations/01-what-is-a-genome | `BundleManifest.swift:79-93` |
| BigBed annotation and BigWig signal tracks in a reference bundle | 01-foundations/01-what-is-a-genome | `BundleManifest.swift:70-93` |
| The `Extractions/` project folder | 01-foundations/01-what-is-a-genome and 02-sequences/03-extracting-and-comparing | `ViewerViewController+Extraction.swift:575` |
| The `Haplotype Definitions/` project folder | 01-foundations/06-the-lungfish-project | `HaplotypeDefinitionStore.swift:18` |
| The full FASTQ operation catalogue, 25 subcommands across twelve categories | 01-foundations/02-sequencing-reads and the Part III chapters | `cli-help/fastq.txt:24-49` |
| Virtual FASTQ bundles and `fastq materialize` | 01-foundations/02-sequencing-reads | `cli-help/fastq.txt:49` |
| Read deduplication with clumpify.sh and its six presets | 03-reads/05-decontamination | `cli-help/fastq.txt:40` |
| Low-complexity entropy filtering and its threshold | 03-reads/05-decontamination | `FASTQOperationDialogState.swift:84` |
| Barcode scouting and demultiplexing, with ONT and PacBio barcode paths | 03-reads/07-ont-runs | `cli-help/fastq.txt:41-48` |
| The ONT Fluidigm Sample Split operation | 03-reads/07-ont-runs | the Demultiplexing category's second item |
| The twenty built-in ONT barcode kits | 03-reads/07-ont-runs | the Built-In Kit menu |
| Merge Overlapping Pairs and its strictness and minimum-overlap settings | 03-reads/08-read-processing | `FASTQOperationDialogState.swift:97-98,254-255` |
| The Translate read-processing operation and its frame and table flags | 03-reads/08-read-processing | `fastq translate --frame`, `--table` |
| The Output Strategy picker, Per Input or Grouped Result | the Part III chapters | `supportsConfigurableOutput` admits all six read-processing operations |
| The eight bundled primer schemes, needing no import step | 01-foundations/03-amplicon-vs-shotgun and appendices/primer-schemes | `Sources/LungfishApp/Resources/PrimerSchemes/` |
| NEB VarSkip and VarSkip Long schemes | appendices/primer-schemes | `NEB-VarSkip-vss1.lungfishprimers`, `NEB-VarSkip-Long-vsl1.lungfishprimers` |
| `lungfish-cli primers import` and its four options | appendices/primer-schemes | `cli-help/primers.txt:24-36` |
| Duplicate marking as an alignment step | 04-alignments/04-alignment-quality | `cli-help/markdup.txt`, `MarkdupService.swift` |
| minimap2 presets beyond the read-type default | 04-alignments/01-mapping-reads-to-a-reference | `MappingTool.swift:194-195` |
| The mapper compatibility check that warns before a mismatched mapper runs | 04-alignments/01-mapping-reads-to-a-reference | `MappingCompatibility.swift:44-100` |
| Multi-bundle mapping with a per-bundle or pooled run-mode picker | 04-alignments/01-mapping-reads-to-a-reference | the run-mode picker on a multi-selection |
| The mapping provenance sidecar written beside every BAM | 04-alignments/01-mapping-reads-to-a-reference | `MappingProvenance.filename` |
| The `bam` and `map` CLI command groups | appendices/cli-reference | `cli-help/bam.txt`, `cli-help/map.txt` |
| The four built-in variant filter profiles, Clinical, Research, QC, High Confidence | 05-variants/02-reading-the-variant-browser | `FilterProfileManager.swift:38-69` |
| The other smart-filter tokens, including the three within-sample frequency chips | 05-variants/02-reading-the-variant-browser | `SmartFilterTokens.swift:16-24` |
| Saving a custom filter profile | 05-variants/02-reading-the-variant-browser | `FilterProfileManager` |
| The Variant Query Builder sheet | 05-variants/02-reading-the-variant-browser | `VariantQueryBuilderSheet.swift` |
| `variants phase`, the GATK plus WhatsHap command plan | 06-human-germline-variants/01-haplotype-caller | `cli-help/variants.txt` |
| VCF import profiles and their semantics | 05-variants/06-importing-existing-vcfs | the Settings picker's profile list |
| The Required Setup pack's 17 tools | 01-foundations/07-plugin-packs | `third-party-tools-lock.json` tools list |
| The `full-length-mhc-genotyping`, `multiple-sequence-alignment`, and `phylogenetics` packs | 01-foundations/07-plugin-packs | `PluginPack.swift:527-770` |
| The `long-read`, `rna-seq`, `single-cell`, `amplicon-analysis`, `genome-annotation`, and `data-format-utils` packs | 01-foundations/07-plugin-packs | `PluginPack.swift:823-960` |
| Which packs are experimental, and the Show Experimental Features toggle that reveals them | 01-foundations/07-plugin-packs | `PluginPack.swift:626,652,841` |
| The nine Kraken 2 databases by name, plus the locally built SILVA and Greengenes | 01-foundations/07-plugin-packs and 06-classification/02-running-kraken2 | `third-party-tools-lock.json` databases |
| The Deacon panhuman and ribokmer managed indexes, installed with Required Setup | 03-reads/05-decontamination | `third-party-tools-lock.json:27-28` |
| The `conda`, `tools`, and `provision-tools` CLI command groups | appendices/cli-reference | `cli-help/conda.txt`, `tools.txt`, `provision-tools.txt` |
| **File > Import Center...** (Cmd-Shift-I) and its six tabs of drop-target cards | 01-foundations/06-the-lungfish-project and 02-sequences/01-importing-and-viewing | `MainMenu.swift:206-212` |
| **File > Manage Project Storage...** | 01-foundations/06-the-lungfish-project | `MainMenu.swift:275-283` |
| The rest of the File > Export menu, six further export routes | 01-foundations/06-the-lungfish-project | `MainMenu.swift:220-256` |
| **View > Focus Viewer** and **View > Restore Side Panes** | appendices/keyboard-shortcuts | `MainMenu.swift:465-478` |
| **Operations > Cancel All Operations** | 01-foundations/06-the-lungfish-project | `MainMenu.swift:884-890` |
| **Tools > Workflow Library...** | 08-workflows/03-running-external-workflows | `MainMenu.swift:765-771` |
| Project locking, unlocking, lock modes, and lock recovery | appendices/shared-projects | `ProjectLock.swift`, `ProjectLockRecovery.swift`, `cli-help/project.txt` |
| Project bundle migration and its dry run | appendices/shared-projects | `project migrate --dry-run` |
| The Welcome window's setup panel, tool-status cards, and storage-location flow | 01-foundations/06-the-lungfish-project | `WelcomeWindowController.swift:1265-1520` |
| The Provenance section's Invocation, Runtime, and Raw JSON blocks, its filter field, and its Copy button | 01-foundations/08-provenance-and-reproducibility | the Inspector's Provenance section |
| Per-artifact SHA-256 checksums and the signing controls in Settings | 01-foundations/08-provenance-and-reproducibility | the signing provider row and its four companions |
| The MSA viewport's display controls, identity modes, variable-site navigation, and numbering modes | 02-sequences/04-aligning-sequences | the alignment viewport's control strip |
| **Export Alignment...** with its three destinations and gap choice | 02-sequences/04-aligning-sequences | the alignment right-click menu |
| `msa actions` and `msa describe` | 02-sequences/04-aligning-sequences | the `msa` command group |
| The nine FASTQ summary cards, including Median Length, N50, and GC | 03-reads/03-quality-control | `FASTQStatisticsCollector.swift` |
| The read preview table and its first 1,000 records | 03-reads/01-importing-fastq | the viewport's Reads tab |
| The Compression Tool popup and the `--clumping-tool` flag | 03-reads/01-importing-fastq | the import sheet and its CLI counterpart |
| The SRA filter controls, Strategy, Min Size, Publication Date, and Max Results | 03-reads/02-downloading-from-sra | the Database Browser's SRA pane |
| `extract reads`'s other strategies, `--by-region`, `--by-db`, and `--by-classifier` | 03-reads/06-subsetting-and-extraction | `cli-help/extract.txt` |
| `extract contigs`, the assembly counterpart | 07-assembly/04-extracting-contigs | `cli-help/extract.txt` |
| The `amplicon-analysis` plugin pack | 01-foundations/03-amplicon-vs-shotgun | `PluginPack.swift:907-924` |

## Claims that could not be verified

| Chapter | Claim | Why unverifiable |
|---|---|---|
| 01-foundations/02-sequencing-reads | The same statistics are available from the command line | No `stats` or `qc` subcommand appears in the fastq help dump |
| 01-foundations/03-amplicon-vs-shotgun | Twist and IDT sell panels of this kind | A vendor fact about the market, outside the app |
| 01-foundations/03-amplicon-vs-shotgun | Shotgun coverage climbs and falls gently rather than jumping at fixed points | The fixture holds no per-base depth track, only aggregates |
| 01-foundations/03-amplicon-vs-shotgun | Amplicon coverage piles onto designed targets rather than spreading | No coverage artifact from a genotype bundle was opened |
| 01-foundations/03-amplicon-vs-shotgun | The SRA submission record names the kit in its library-strategy fields | A claim about SRA and ENA metadata schemas, outside the app |
| 01-foundations/03-amplicon-vs-shotgun | Instrument software often removes adapters before you see the file | A fact about sequencer vendors, not about LGE |
| 01-foundations/05-variants-and-vcf | `min_indelqual_20` uses a threshold fixed at 20 | Nothing in source sets or varies it, so a second dataset would be needed |
| 01-foundations/05-variants-and-vcf | The genome track draws each variant as a tick at its POS | A visual property source alone cannot settle |
| 01-foundations/05-variants-and-vcf | The Inspector's provenance carries the thresholds | The sidecar carries them, whether the Inspector surfaces them was not settled |
| 01-foundations/06-the-lungfish-project | The CLI rejects a `--project` path that does not end in `.lungfish` | No extension check appears in the CLI sources |
| 01-foundations/07-plugin-packs | The whole tour takes about ten minutes plus download time | No source states a duration and the campaign forbids timing an install |
| 01-foundations/07-plugin-packs | Use an SSD, a spinning external drive is too slow | Nothing states a storage-medium requirement |
| 01-foundations/08-provenance-and-reproducibility | An exported script will not run outside its folder | Running it would run tools, which the review may not do |
| 01-foundations/08-provenance-and-reproducibility | On success verify reports a valid signature and names what it checked | No signed sidecar exists in the demo project |
| 02-sequences/04-aligning-sequences | Two claims about MSA behaviour the source could not settle | Recorded in the chapter's fidelity file |
| 02-sequences/05-building-trees | Two tree-rendering claims | Visual properties not settled from source |
| 03-reads/01-importing-fastq | Sample metadata is editable one bundle at a time from the Inspector | Per-bundle metadata is persisted, but the editing surface was not confirmed |
| 03-reads/01-importing-fastq | Nothing here needs a plugin pack or Docker Desktop | The default import runs clumpify.sh from a managed conda environment |
| 03-reads/02-downloading-from-sra | Downloads report in the Download Center rather than the Operations panel | `DownloadCenter` is a typealias for `OperationCenter`, so the code cannot settle it |
| 03-reads/03-quality-control | A Q30 figure below roughly 70 percent means the run had trouble | A domain threshold with no source in the repository |
| 03-reads/03-quality-control | A human sample sits near 41 percent GC | A domain claim needing a citation |
| 03-reads/04-trimming-and-filtering | Trim Fixed Bases runs fastp | The help text names no tool, unlike its neighbours |
| 03-reads/05-decontamination | The exclusion is because it writes one file per read class | The condition carries no comment giving a reason |
| 03-reads/05-decontamination | Use 12000 for Optical Distance on a NovaSeq | Only the manual's own registry states it |
| 03-reads/05-decontamination | Above roughly 20 percent duplicates means too little starting material | Domain guidance with no source |
| 03-reads/05-decontamination | Both Deacon indexes arrive with Required Setup | They are managed data rather than pack tools, so the routing is indirect |
| 03-reads/06-subsetting-and-extraction | Asking for more reads than the bundle holds returns all of them | Standard seqkit behaviour, but no run tested it |
| 03-reads/06-subsetting-and-extraction | The fixture GitHub tree URL is public at that path | Network access is outside this role |
| 04-alignments/01-mapping-reads-to-a-reference | A window run and a CLI run record identical methods | Only CLI sidecars could be produced, and runtime identity differs |
| 04-alignments/03-primer-trimming | `--format json` prints one object per line | The flag is real, the rendering was not confirmed |
| 04-alignments/04-alignment-quality | The File > New Project path and shortcut | Boilerplate verified in other chapters, not re-derived here |
| 04-alignments/04-alignment-quality | 30x to 50x is the band a human genome project aims for | A domain convention needing a bibliography citation |
| 04-alignments/04-alignment-quality | The 5, 20, and 80 percent duplicate-rate rules of thumb | Domain rules with no repository source |
| 05-variants/01-calling-variants-from-amplicons | The alignment track is named "minimap2 Mapping" | Deferred to the mapping chapter, a GUI run would settle it |
| 05-variants/02-reading-the-variant-browser | bcftools arrives in the Required Setup pack | Not settled from the sources read |
| 05-variants/02-reading-the-variant-browser | Columns can be dragged to reorder and hidden from the header menu | Implied by saved state, but neither affordance is built explicitly |
| 05-variants/02-reading-the-variant-browser | Arrow keys move the selection and the Inspector follows | Plausible NSTableView behaviour, the key handling was not located |
| 05-variants/02-reading-the-variant-browser | VoiceOver announces the focused cell and headers activate to sort | Labels exist, the announcement text was not confirmed |
| 05-variants/02-reading-the-variant-browser | The fixture has a mean depth of 44.7 across the slice | Not derivable from the two VCFs, needs a samtools depth run |
| 05-variants/02-reading-the-variant-browser | Clicking the track shows provenance with checksums of the inputs | Sidecars exist, the sidebar interaction was not confirmed |
| 05-variants/05-consensus-and-lineage | Bayesian mode down-weights low-quality bases | Describes samtools consensus rather than anything LGE does |
| 05-variants/05-consensus-and-lineage | Hide high-gap sites helps a noisy long-read alignment | The control's help text describes display masking instead |
| 05-variants/06-importing-existing-vcfs | Dragging a VCF onto the viewport runs the same import | The drop routes through the sidebar pipeline, equivalence unconfirmed |
| 05-variants/06-importing-existing-vcfs | The import profile applies to every VCF import the window performs | The naked path was not found reading the profile |
| 06-classification/01-what-is-classification | Kraken 2 matches minimizers rather than raw k-mers | Kraken 2's own algorithm, not an LGE behaviour |
| 06-classification/02-running-kraken2 | The fixture reads came from a human clinical specimen | No campaign input establishes the specimen source |
| 06-classification/02-running-kraken2 | A hand-built database can be pointed at from the storage location | Nothing shows a dropped index gets registered |
| 06-classification/03-running-esviritu | Metadata columns survive closing and reopening the result | The persistence path is written against a reference bundle |
| 06-classification/04-running-taxtriage | The upstream project does not publish the TASS expansion | A negative about a third-party project, needing the upstream README |
| 06-classification/04-running-taxtriage | The fixture holds 86,281 pairs | The runs used 83,591, and 86,281 is presumably the deposited count |
| 06-classification/04-running-taxtriage | Nextflow arrives with the Required Setup pack | Nextflow is present, the pack attribution was not confirmed |
| 06-classification/07-running-freyja | A total well under 1 means the barcode file is older than the lineages present | No run produced a low total |
| 06-classification/07-running-freyja | A post-snapshot lineage shows as a poor residual rather than an error | The symptom claim is untested |
| 06-classification/07-running-freyja | The estimated reading time of 16 minutes | No campaign rule fixes the word-count conversion |
| 06-classification/08-importing-cz-id-results | A few-thousand-row report finishes while you read the sheet | Extrapolated from a three-row import |
| 06-classification/08-importing-cz-id-results | A small count means you pointed at one sample inside a multi-sample export | No multi-sample CZ ID export was available |
| 06-classification/08-importing-cz-id-results | A percentage disagreement means the export was assembled by hand | The arithmetic is sound, the cause is a plausible story |
| 06-classification/09-novel-virus-detection | Metadata columns survive closing and reopening the result | No run was made against an NVD result |
| 06-human-germline-variants/01-haplotype-caller | The File > New Project path and shortcut | Boilerplate verified elsewhere, not re-checked |
| 06-human-germline-variants/01-haplotype-caller | The dialog does not preselect the track you arrived from | Neither the registry nor the dialog state says how the initial selection works |
| 06-human-germline-variants/02-joint-genotyping | The run split as 1.61 and 1.62 seconds per step | The successful run's provenance was overwritten by a later failure |
| 06-human-germline-variants/03-filtering-selecting-and-metrics | The experimental-features and Plugin Manager path | Not driven in the GUI |
| 06-human-germline-variants/03-filtering-selecting-and-metrics | A whole human genome takes minutes rather than seconds | No whole-genome run was made |
| 07-assembly/01-when-to-assemble | Above roughly 95 percent identity a reference fits | No app behaviour corresponds to the threshold |
| 07-assembly/01-when-to-assemble | MEGAHIT uses less memory than SPAdes on such samples | The MEGAHIT run aborted, so no figure supports it |
| 07-assembly/03-running-flye-or-hifiasm | Hifiasm doubles because it walks the circle twice | A mechanism claim about hifiasm's internals |
| 07-assembly/04-extracting-contigs | A SPAdes selection suggests a `NODE_1_length_...` bundle name | The shape is right, the exact string was never produced |
| 08-workflows/01-the-workflow-builder | The bundle held 19,916 reads with a mean length of 248.4 | The bundle's cached statistics were not re-read |
| 08-workflows/01-the-workflow-builder | fastp, Deacon, and seqkit ship in the Required Setup pack | Not checked against the tool lock in this review |
| 08-workflows/01-the-workflow-builder | The Plugin Manager lists the Deacon panhuman database | The index resolved on disk, the Plugin Manager listing was not checked |
| 08-workflows/03-running-external-workflows | The Operations panel shortcut Cmd-Shift-P | A cross-chapter constant not re-derived here |
| 09-genotyping/01-what-is-mhc-genotyping | A run where nearly everything passes probably used the reference the reads came from | An editorial judgement with no checkable threshold |
| appendices/bibliography | IQ-TREE 3 had not published its own paper when this release was built | No network access, settled by a literature search at submission |
| appendices/keyboard-shortcuts | Show Experimental Features lives in Settings > Advanced | The toggle's own pane was not read in this review |
| appendices/keyboard-shortcuts | Context-menu shortcuts work only while the menu is open | The correct AppKit reading, but no key was pressed to confirm |
| appendices/keyboard-shortcuts | Menu items can be remapped from System Settings > Keyboard | macOS behaviour, outside LGE source |
| appendices/keyboard-shortcuts | An override takes effect at the next launch | macOS behaviour |
| appendices/keyboard-shortcuts | Ctrl-Opt-M moves VoiceOver into the menu bar | macOS VoiceOver behaviour |
| appendices/keyboard-shortcuts | Full Keyboard Access reaches every control without a pointer | macOS behaviour, and the "every control" half was not audited |
| appendices/tool-versions | The Viral Recon release matches the wizard's version field | Not settled by the lock or the CLI |
| appendices/troubleshooting | The workaround is to select a reference bundle | The gate names the genomics content mode, not a bundle specifically |
| appendices/troubleshooting | LGE rebuilds a missing `.fai`, `.bai`, or `.tbi` on demand | No single source states the policy for all three |

## App defects found during the audit

Deduplicated across chapters. The Evidence column names every chapter that met
the defect.

| Area | Observation | Evidence | Issue |
|---|---|---|---|
| CLI, provenance | Any command whose working directory is under `/private/tmp` fails with a provenance publication artifact error and writes nothing, because a resolved path is compared with an unresolved one across the `/tmp` symlink | appendices/cli-reference, 09-genotyping/02-running-genotyping, 09-genotyping/04-haplotype-definitions-and-export | open |
| CLI, options | `bundle export` cannot be run because its `--format` collides with the root-level global option that every subcommand advertises | appendices/cli-reference, appendices/file-formats, appendices/power-user-notes | open |
| Assembly | MEGAHIT 1.2.9 fails about four runs in five on Apple Silicon with both shipped workarounds active, exiting nonzero with no contigs written | 07-assembly/01-when-to-assemble, 07-assembly/02-running-spades | open |
| Genotyping | Min Reads and `--min-support` are recorded but never filter a genotype-only run | 09-genotyping/02-running-genotyping | open |
| Genotyping | The cohort summary panel and Smart Cohorts are hidden on a genotype-only result, so the cohort-level counts they build are never shown, and the Smart Cohorts guard is doubled | 09-genotyping/03-reading-the-genotype-comparison | open |
| Genotyping | The comparison matrix's own filter field and locus popup are built and hidden | 09-genotyping/03-reading-the-genotype-comparison | open |
| Genotyping | On a genotype-only result the Actions menu is hidden and the Audit lens is unreachable, leaving Filtered Pivot... as the only in-app export | 09-genotyping/04-haplotype-definitions-and-export | open |
| Genotyping | The pivot workbook writes 14 blank haplotype rows over a fixed list of seven loci while the data covers 13 | 09-genotyping/04-haplotype-definitions-and-export | open |
| Genotyping | Two exports of the same subcommand differ in the workbook's embedded timestamp | 09-genotyping/04-haplotype-definitions-and-export | open |
| Genotyping | `genotype-cohort` enforces an undocumented two-bundle minimum | 09-genotyping/02-running-genotyping | open |
| Genotyping | Every Genotyping submenu item starts greyed until enabled in the Workflow Library, with nothing on screen explaining why beyond the suffix | 09-genotyping/01-what-is-mhc-genotyping | open |
| Genotyping | The run reports no count of merged pairs, and the status `review` exists in the result files but is undocumented | 09-genotyping/01-what-is-mhc-genotyping | open |
| Decontamination | Both Deacon indexes are Required Setup managed data, yet the Plugin Manager's Databases tab lists only the Kraken 2 catalogue, so they appear nowhere in the manager | 03-reads/05-decontamination, appendices/troubleshooting | open |
| Decontamination | `scrub-human --remove-reads` is accepted and ignored | 03-reads/05-decontamination | open |
| FASTQ operations | `fastq sequence-filter` crashes with a raw Java assertion when the rounded error-rate product exceeds bbduk's cap, at the dialog's own default error rate | 03-reads/06-subsetting-and-extraction | open |
| FASTQ operations | The window and the command line disagree on defaults for Min Overlap, Error Rate, Keep Matched Reads, and Search End | 03-reads/06-subsetting-and-extraction | open |
| FASTQ operations | `fastq interleave` re-encodes Phred 2 as Phred 0, because the reformat.sh call omits `qin=33 qout=33` | 03-reads/08-read-processing | open |
| FASTQ operations | `fastq orient` against a single long reference record orients nothing and writes an empty output at exit 0 with no message | 03-reads/08-read-processing | open |
| FASTQ operations | `fastq orient --compress` writes plain text under a `.gz` name | 06-classification/10-twelve-s-metabarcoding | open |
| FASTQ operations | `fastq primer-remove` defaults `--kmer` to 23 where the dialog defaults k to 15 | 03-reads/04-trimming-and-filtering | open |
| FASTQ operations | `fastq trim` and `quality-trim` take `--extra-args` while only the Quality Trim pane offers the field | 03-reads/04-trimming-and-filtering | open |
| FASTQ QC | The Mean Q card is seqkit's probability-averaged score while `fastq qc-summary` reports the arithmetic mean, and Q20 and Q30 differ slightly because seqkit rounds | 03-reads/01-importing-fastq, 03-reads/03-quality-control | open |
| FASTQ import | A paired import is stored inside its bundle as one interleaved file, which the import and export surfaces do not say | 03-reads/01-importing-fastq | open |
| ONT | `ONTDirectoryImporter` estimates the manifest base count as compressed bytes times 1.5 | 03-reads/07-ont-runs | open |
| ONT | Demultiplexing reports the post-loss input count and drops 23 of 950 reads silently | 03-reads/07-ont-runs | open |
| ONT | `fastq ont-fluidigm-samples` prints a provenance error after completion and exits 1 | 03-reads/07-ont-runs | open |
| ONT | An imported ONT run lands at the project root rather than under `Imports/` | 03-reads/07-ont-runs | open |
| Alignment | `extract reads --by-region` rejects any `--region` carrying coordinates, blames the reference name, and falls back to every reference | 04-alignments/02-reading-an-alignment | open |
| Alignment | The Inspector's Est. Coverage assumes 150-base reads, so it disagrees with measured mean depth | 04-alignments/02-reading-an-alignment, 04-alignments/04-alignment-quality | open |
| Alignment | Extract Reads in Selected Region writes to `alignment-read-extractions/` rather than `Extractions/`, against the 2026-08-22 decision | 04-alignments/02-reading-an-alignment | open |
| Alignment | `runMarkDuplicatesWorkflow` and `runCreateDeduplicatedBundleWorkflow` have no `canStartOperation` guard and never register with OperationCenter | 04-alignments/04-alignment-quality | open |
| Alignment | `lungfish-cli markdup` marks in place while the Inspector button writes new tracks and deletes the old ones | 04-alignments/04-alignment-quality | open |
| Alignment | `lungfish-cli map` prints the flagstat record count under the label Total reads | 04-alignments/01-mapping-reads-to-a-reference | open |
| Alignment | `showFASTQMappingOperations` and `showWorkflowOperations` have no bound menu item | 04-alignments/01-mapping-reads-to-a-reference | open |
| Primer trimming | A wrong primer scheme trims with exit 0 and no warning while iVar's summary is captured into provenance and never surfaced | 04-alignments/03-primer-trimming | open |
| Primer trimming | `PrimerSchemePickerView` shows only the display name although it holds the accession and amplicon count | 04-alignments/03-primer-trimming | open |
| Primer schemes | The Import Primer Scheme sheet hard-codes empty attachments and writes no description, organism, source URL, or version | appendices/primer-schemes | open |
| Primer schemes | The canonical-flag fallback to the first accession is silent, and a variant tag after the LEFT or RIGHT suffix inflates the amplicon count silently | appendices/primer-schemes | open |
| Viral Recon | `ViralReconWizardSheet.loadKnownParameters` falls back to `overridableAdvancedKeys` before the schema is pulled, so a valid Extra parameter is refused on a fresh install | 04-alignments/05-viral-recon-wizard | open |
| Viral Recon | Freyja is skipped because the pinned container is Intel-only | 04-alignments/05-viral-recon-wizard | open |
| Variant calling | Minimum Allele Frequency and Minimum Depth reach only iVar and are recorded as caller-default for every other caller with no warning | 05-variants/01-calling-variants-from-amplicons, 06-human-germline-variants/01-haplotype-caller | open |
| Variant calling | The PASS chip hides every default bcftools row with no empty-state explanation | 05-variants/01-calling-variants-from-amplicons | open |
| Variant calling | `IVarCodonMerger` applies a fixed 0.40 to 0.60 merge band that no setting controls | 05-variants/01-calling-variants-from-amplicons | open |
| Variant calling | LoFreq rejects `--version`, so its provenance version field holds an error message | 05-variants/01-calling-variants-from-amplicons, 01-foundations/05-variants-and-vcf | open |
| Variant calling | Every Medaka run fails because the pipeline calls a subcommand Medaka 2.2.2 removed, and its preflight demands a basecaller model no LGE mapping writes | 05-variants/04-nanopore-variant-calling | open |
| Variant calling | Clair3 launches without its managed environment on PATH, and CheckEnvs.py cannot read a BAM path containing a space, which every bundle path under `Reference Sequences/` does | 05-variants/04-nanopore-variant-calling, appendices/troubleshooting | open |
| Variant calling | The Medaka and Clair3 model fields share one stored setting and one flag named for Medaka | 05-variants/04-nanopore-variant-calling | open |
| Variants table | The Het Only chip is defined but never offered | 05-variants/02-reading-the-variant-browser | open |
| Variants table | A Search Builder Region value without the reference name is silently ignored, and `QueryLogic.matchAny` is rewritten to `matchAll` on preset load | 05-variants/02-reading-the-variant-browser | open |
| Variants table | `variants query --filter` accepts per-sample clauses only, and `Sample[x].DP` reads a FORMAT DP that bcftools does not write | 05-variants/02-reading-the-variant-browser | open |
| Variants table | The Auto ploidy guess treats any reference under 10 megabases as haploid | 05-variants/02-reading-the-variant-browser | open |
| Bundles | `bundle create --variant` writes BCF plus CSI, unlike every other variant-track path, and writes `variant_count` 0 until the window opens the bundle | 05-variants/02-reading-the-variant-browser, 05-variants/06-importing-existing-vcfs | open |
| Consensus | The operation history records alignment consensus as a `Lungfish.app` command string that no `lungfish-cli` subcommand can run | 05-variants/05-consensus-and-lineage | open |
| Consensus | The consensus chain masks by depth twice and rewrites every `*` as `N`, so raw samtools output does not match the app's | 05-variants/05-consensus-and-lineage | open |
| VCF import | `importVCFToBundle` has no menu item, so the features.yaml File > Open VCF entry is unreachable | 05-variants/06-importing-existing-vcfs | open |
| VCF import | `import vcf --format` is accepted and ignored, the Settings picker mistags Low Memory and omits ultraLowMemory, and a CLI-built database has no `source_file` column | 05-variants/06-importing-existing-vcfs | open |
| Kraken 2 | An all-unclassified run exits 64 with Empty Kraken2 report before Bracken runs | 06-classification/02-running-kraken2, appendices/troubleshooting | open |
| Kraken 2 | Copy Taxonomy Path copies names, so the taxid for extract reads must come from the kreport or NCBI | 06-classification/02-running-kraken2, 06-classification/06-blast-verification | open |
| EsViritu | The Identity column renders the stored fraction with a percent sign, showing 1.0% for a 99.7% detection | 06-classification/03-running-esviritu | open |
| EsViritu | The Coverage column filter compares breadth while the column displays depth | 06-classification/03-running-esviritu | open |
| EsViritu | `detectToolVersion` records a Python path fragment as the EsViritu version | 06-classification/03-running-esviritu | open |
| EsViritu | Three disagreeing database sizes across the lock, the CLI banner, and db-status, and `install-managed --list` omits the database | 06-classification/03-running-esviritu | open |
| EsViritu | The run log is deleted on success | 06-classification/03-running-esviritu | open |
| TaxTriage | TASS scores are all 0.000 because the pinned v3.3.8 never writes `multiqc_confidences.txt`, and the parser's 0 to 1 scale disagrees with the report's 0 to 100 | 06-classification/04-running-taxtriage | open |
| TaxTriage | The single-sample entry point always names the folder `taxtriage-batch` | 06-classification/04-running-taxtriage | open |
| TaxTriage | `extract reads --tool taxtriage` requires `--accession` and rejects `--taxon` | 06-classification/04-running-taxtriage | open |
| TaxTriage | Open Report picks the first PDF or report file rather than the organism detection report | 06-classification/04-running-taxtriage | open |
| NAO-MGS | `nao-mgs summary` reads only the first sample of a multi-sample table and prints no organism names | 06-classification/05-running-nao-mgs | open |
| NAO-MGS | `extract reads --by-db` can never return reads from an imported bundle because the merge drops the virus_hits rows | 06-classification/05-running-nao-mgs | open |
| NAO-MGS | The miniBAM note says unique read count while the panels are ordered by total | 06-classification/05-running-nao-mgs | open |
| NAO-MGS | The Taxa card counts sample-taxon rows while the Unique Taxa card counts distinct taxa | 06-classification/05-running-nao-mgs | open |
| BLAST | `blast verify --source` cannot read a gzipped FASTQ and reports no matching reads | 06-classification/06-blast-verification | open |
| BLAST | The NVD viewport never sets a presentation style, so a single-contig BLAST shows a Supported or Unsupported word with no supporting share behind it | 06-classification/06-blast-verification | open |
| Freyja | The Wastewater Surveillance pack is hidden from the Packs tab in Preview builds unless experimental features are on, while the CLI installs it regardless | 06-classification/07-running-freyja | open |
| Freyja | `FreyjaDemixPlan` records the output file before the run and never refreshes it, so the result carries no checksum or size, and the sidecar omits stderr | 06-classification/07-running-freyja | open |
| Freyja | `freyja variants` with a bare program name not on PATH writes an empty table and exits 0 | 06-classification/07-running-freyja | open |
| CZ ID | The import sheet's Project Destination readout composes a path nothing writes to and recomputes its timestamp on every read | 06-classification/08-importing-cz-id-results, appendices/file-formats | open |
| CZ ID | The action bar's taxon count includes the root row, and neither route creates an Analyses folder | 06-classification/08-importing-cz-id-results | open |
| NVD | The outline has no sort control, and the TSV export drops Unique Reads and Aln Length | 06-classification/09-novel-virus-detection | open |
| NVD | The three classifier import routes disagree on destination, writing NVD into `Imports`, NAO-MGS into `Analyses`, and CZ ID into `Classifications` | 06-classification/09-novel-virus-detection | open |
| 12S | The matcher never tries the reverse complement, silently losing every read on the other strand | 06-classification/10-twelve-s-metabarcoding | open |
| 12S | `12s-reference-metadata` and `12s-reference-bundle` help text names five of seven required columns, and a header without parentheses yields empty species metadata at exit 0 | 06-classification/10-twelve-s-metabarcoding | open |
| GATK | The GATK plus WhatsHap Phased dialog entry builds a plan nothing consumes and raises Variant Calling Not Ready | 06-human-germline-variants/01-haplotype-caller | open |
| GATK | LGE never creates the `.dict` or the `.fai` for a reference handed to gatk, so a first run fails until the reader makes them | 06-human-germline-variants/01-haplotype-caller, 06-human-germline-variants/04-reference-packs | open |
| GATK | `conda install --pack gatk-core` reports an unknown pack while `conda export-pack` accepts it | 06-human-germline-variants/01-haplotype-caller, 06-human-germline-variants/02-joint-genotyping, 06-human-germline-variants/04-reference-packs | open |
| GATK | `gatk joint-genotype` accepts no `--gvcf` and composes a CombineGVCFs command with no input at exit 0 | 06-human-germline-variants/02-joint-genotyping | open |
| GATK | Unrecognised `--combine-strategy`, `--preset`, `--type`, and `--emit-ref-confidence` values all fall back silently | 06-human-germline-variants/01-haplotype-caller, 06-human-germline-variants/02-joint-genotyping, 06-human-germline-variants/03-filtering-selecting-and-metrics | open |
| GATK | The provenance sidecar has a fixed name per output folder, so each `--execute` overwrites the previous run's record | 06-human-germline-variants/03-filtering-selecting-and-metrics | open |
| GATK | `collect-metrics` reports exit 3 and hides Picard's dictionary error in the sidecar | 06-human-germline-variants/03-filtering-selecting-and-metrics | open |
| GATK | `variants phase --threads` is shadowed by the root command's global `--threads` | 06-human-germline-variants/01-haplotype-caller | open |
| Assembly | The assembly sheet's Min Contig control is shown and editable for SPAdes but never reaches the command | 07-assembly/02-running-spades | open |
| Assembly | MEGAHIT's Threads are overridden to 2 on Apple Silicon with no indication in the sheet, and `--profile default` passes nothing | 07-assembly/02-running-spades | open |
| Assembly | Align with MAFFT never appears in the assembly contig menu because the handler is not passed | 07-assembly/02-running-spades, 07-assembly/04-extracting-contigs | open |
| Assembly | `assemble` accepts `--memory-gb` and `--min-contig-length` for Flye and hifiasm and ignores both silently, and the multi-input refusal exits 0 | 07-assembly/03-running-flye-or-hifiasm | open |
| Assembly | The viewport shows no circularity or multiplicity column, so a doubled circular contig looks healthy | 07-assembly/03-running-flye-or-hifiasm | open |
| Assembly | The Create Bundle button passes `--contigs` rather than `--assembly`, so window-made bundles record Assembler Unknown | 07-assembly/04-extracting-contigs | open |
| Assembly | A derived bundle's collision suffix reads `-subset 2` in the sidebar and `_2` on disk | 07-assembly/04-extracting-contigs | open |
| Workflow builder | The five operation nodes' parameters are unreachable from the inspector, so eight of twelve settings live behind the shared operations dialog | 08-workflows/01-the-workflow-builder | open |
| Workflow builder | `workflow diff --format json` and `--format tsv` print the text form, `workflow validate` refuses a builder graph with exit 5, and `workflow list` omits saved chains | 08-workflows/01-the-workflow-builder | open |
| Workflow builder | A command-line `builder-run` writes no run.json and no provenance.json | 08-workflows/01-the-workflow-builder | open |
| Workflow export | The Nextflow emitter calls a three-input process with one channel, and the Snakemake emitter lists the flagstat BAM as both input and output, producing a cycle | 08-workflows/02-exporting-as-nextflow-or-snakemake | open |
| Workflow export | A parameter is emitted twice at four sites, and every emitted command carries absolute host paths | 08-workflows/02-exporting-as-nextflow-or-snakemake | open |
| Workflow run | `workflow run` detects Nextflow by a lower-case `.nf` extension only while `workflow validate` lowercases first | 08-workflows/03-running-external-workflows | open |
| Workflow run | The no-output error advises `--dry-run` as a planning route the check does not implement | 08-workflows/03-running-external-workflows | open |
| Workflow run | The Snakemake example package declares a `.lungfishref` output and writes a `{}` manifest | 08-workflows/03-running-external-workflows | open |
| Provenance | `provenance verify` exits 64 with an error line on an ordinary unsigned record, and handles only signed sidecars while signing is off by default | 08-workflows/02-exporting-as-nextflow-or-snakemake, appendices/06-running-in-ci | open |
| Provenance | A bundle output's sidecar lands inside the bundle rather than beside it | appendices/06-running-in-ci | open |
| Provenance | Every `files[]` entry writes checksum and size under two key spellings | appendices/power-user-notes | open |
| Provenance | The offline-export provenance record has an empty file list and no reproducible command | appendices/06-running-in-ci | open |
| Provenance | The sidecar's `wallTimeSeconds` held a small negative number | appendices/06-running-in-ci | open |
| CLI, options | `--format json` is accepted and ignored by conda packs, ops stats, workflow list, conda offline-export, and version | appendices/06-running-in-ci, appendices/power-user-notes, appendices/shared-projects | open |
| CLI, packs | The unknown-pack error lists eight ids while offline-export accepts eighteen, three of them real packs the CLI cannot install | appendices/06-running-in-ci | open |
| CLI, diagnostics | `debug env --check-tools` probes Nextflow with a flag it rejects, and `ops stats` reports an unknown option and exits zero | appendices/06-running-in-ci, 08-workflows/03-running-external-workflows | open |
| CLI, stats | `ops stats` counts only files named exactly `.lungfish-provenance.json`, so per-output sidecars are never counted | appendices/power-user-notes | open |
| CLI, iVar | The four `--ivar-*` flags configure LGE's own converter and never reach iVar | appendices/power-user-notes | open |
| AI Assistant | The Assistant tab exists only in the genomics content mode, so read, assembly, mapping, classifier, and genotype viewports get an Inspector without it and without an explanation | appendices/ai-assistant | open |
| AI Assistant | The demo project's chr20 bundle records its organism as the slice name rather than Homo sapiens, so species-aware suggestions interpolate a slice name | appendices/ai-assistant | open |
| Bibliography | The shared-word matching tier prints a confident wrong citation for Trim Galore, gatk-variant-filtration, and gatk-variants-to-table | appendices/bibliography | open |
| Bibliography | Sixteen managed tools have no alias entry, GATK and Freyja record wrapper step names, four alias entries name tools in no lock array, and a matched-nothing run exits 0 | appendices/bibliography | open |
| Tool versions | `tool-versions.md` is stale against the lock on nine versions and omits Trim Galore | appendices/bibliography, appendices/tool-versions | open |
| Shared projects | Two consecutive CLI locks both succeed because a CLI lock is stale the instant the command exits, and the host field can change between two records on one Mac | appendices/shared-projects | open |
| Shared projects | `lock --force` deletes the displaced record with no archive, and stale-lock recovery in the window is unreachable dead code | appendices/shared-projects | open |
| Shared projects | The migration summary counts do not reconcile | appendices/shared-projects | open |
| Keyboard | The Workflow Builder toolbar tooltips advertise Cmd-plus and Cmd-minus but nothing binds them there, and View > Zoom In is gated on an active sequence viewer | appendices/keyboard-shortcuts | open |
| Keyboard | Cmd-0 means four different things by responder context, and Cancel All Operations carries a redundant static disable | appendices/keyboard-shortcuts | open |
| Sequences | `ExtractionConfigurationView` carries a Concatenate Exons control the `.annotation` case can reach, but no caller passes an annotation source, so it is dead in this release | 02-sequences/03-extracting-and-comparing | open |
| Sequences | `extract sequence` prints a 0-based start in its header tokens while its length token is the inclusive span | 02-sequences/03-extracting-and-comparing | open |
| MSA | The consensus Low support slider defaults to 50 percent while `msa consensus --threshold` defaults to 0.6 | 02-sequences/04-aligning-sequences | open |
| Trees | `tree reroot` and Re-root Here duplicate every tip except the new root, turning 5 tips into 13 | 02-sequences/05-building-trees | open |
| Trees | `tree infer iqtree` fails when the MSA bundle lacks a root `.lungfish-provenance.json`, and the dialog labels both replicate fields plain Replicates | 02-sequences/05-building-trees | open |
| Database browser | SRA read downloads land under `Imports/` as bundles while only NCBI reference records go to `Downloads/`, and the browser exposes two Search buttons | 03-reads/02-downloading-from-sra | open |
| Classification | 12S Amplicon Matching sits under Genotyping as a specialized workflow rather than with the classifiers | 06-classification/01-what-is-classification | open |
| Plugin Manager | Size estimates understate installed environments by about half, and GATK Core's description still says dry-run support | 06-human-germline-variants/04-reference-packs | open |

## Verification (Phase 6)

The cross-chapter sweep applied ten of its twelve items and is recorded in `phase6-sweep.md` (the hg002-chr20 fixture README was already correct, and the glossary entry was fixed in a separate pass recorded in `glossary-sweep.md`). The campaign prose rules are strict by default in `build/scripts/lint/rules/severity.js`, and every chapter and `index.md` passes them. `check-links.mjs` reports links ok after three fixes and after it learned to skip the PDF the with-pdf plugin writes at build time. `validate-parameters.mjs` reports parameters ok. Every chapter carries `brand_reviewed: true` and `lead_approved: true`. `check-shots.mjs` reports 414 problems, all of them the missing PNG and recipe for each of the 207 markers plus five orphan recipes under `assets/recipes/04-variants/`, which Phase 5 resolves. Two illustration briefs, `viewport-lanes` and `extraction-header-anatomy`, were embedded as images that do not exist yet and are now `<!-- ILLUSTRATION: id -->` markers awaiting generation.

`mkdocs build --strict` cannot run on this Mac with the shipped configuration because the with-pdf plugin imports weasyprint, which needs a pango library the machine lacks. With that one plugin removed from a scratch copy of the configuration the strict build reports a single warning, the `pdf/lungfish-user-manual.pdf` link on the index page, which the plugin satisfies on Read the Docs where `.readthedocs.yaml` sets `ENABLE_PDF_EXPORT=1`. Three rendered chapters (The Lungfish Genome Explorer Project, Trimming and Filtering, Running Amplicon MHC Genotyping) were read in a browser from the built site, and the Settings paragraphs, code blocks, glossary links, and navigation render as intended. The "not ready for use" banner is still in place pending the user's decision.

## Screenshots

All 207 markers carry status `new`, meaning no PNG exists for them yet.
Capture is Phase 5, pending.

| Chapter | Shot id | Status (new, recaptured, unchanged) |
|---|---|---|
| 01-foundations/01-what-is-a-genome | `go-to-location-hbb-codon` | new |
| 01-foundations/01-what-is-a-genome | `hbb-record-in-sequence-viewport` | new |
| 01-foundations/01-what-is-a-genome | `import-center-reference-card` | new |
| 01-foundations/02-sequencing-reads | `fastq-viewport-reads-tab` | new |
| 01-foundations/02-sequencing-reads | `fastq-viewport-summary-cards` | new |
| 01-foundations/03-amplicon-vs-shotgun | `primer-scheme-picker-built-in` | new |
| 01-foundations/04-alignment-files | `bam-viewport-coverage-and-pileup` | new |
| 01-foundations/05-variants-and-vcf | `inspector-variant-selected` | new |
| 01-foundations/05-variants-and-vcf | `variants-pass-chip-and-tokens` | new |
| 01-foundations/05-variants-and-vcf | `variants-tab-hg002-bcftools` | new |
| 01-foundations/06-the-lungfish-project | `empty-project-window` | new |
| 01-foundations/06-the-lungfish-project | `file-export-menu` | new |
| 01-foundations/06-the-lungfish-project | `inspector-fastq-detail` | new |
| 01-foundations/06-the-lungfish-project | `inspector-fastq-selected` | new |
| 01-foundations/06-the-lungfish-project | `operations-panel-right-click-menu` | new |
| 01-foundations/06-the-lungfish-project | `operations-panel-row` | new |
| 01-foundations/06-the-lungfish-project | `sidebar-folder-conventions` | new |
| 01-foundations/06-the-lungfish-project | `welcome-window` | new |
| 01-foundations/07-plugin-packs | `plugin-manager-databases-tab` | new |
| 01-foundations/07-plugin-packs | `plugin-manager-installed-tab` | new |
| 01-foundations/07-plugin-packs | `plugin-manager-offline-commands` | new |
| 01-foundations/07-plugin-packs | `plugin-manager-window` | new |
| 01-foundations/08-provenance-and-reproducibility | `file-export-menu` | new |
| 01-foundations/08-provenance-and-reproducibility | `inspector-provenance-section` | new |
| 01-foundations/08-provenance-and-reproducibility | `provenance-export-folder` | new |
| 01-foundations/08-provenance-and-reproducibility | `provenance-lineage-step-expanded` | new |
| 01-foundations/08-provenance-and-reproducibility | `provenance-signing-settings` | new |
| 02-sequences/01-importing-and-viewing | `go-to-location-hbb-codon` | new |
| 02-sequences/01-importing-and-viewing | `hbb-annotation-context-menu` | new |
| 02-sequences/01-importing-and-viewing | `hbb-record-in-sequence-viewport` | new |
| 02-sequences/01-importing-and-viewing | `import-center-annotation-track-alert` | new |
| 02-sequences/01-importing-and-viewing | `import-center-reference-card` | new |
| 02-sequences/01-importing-and-viewing | `translation-tool-hbb-cds` | new |
| 02-sequences/02-downloading-from-ncbi | `ncbi-advanced-filters` | new |
| 02-sequences/02-downloading-from-ncbi | `ncbi-bundle-in-sidebar` | new |
| 02-sequences/02-downloading-from-ncbi | `ncbi-results-download-selected` | new |
| 02-sequences/02-downloading-from-ncbi | `ncbi-search-dialog` | new |
| 02-sequences/02-downloading-from-ncbi | `pathoplexus-pane` | new |
| 02-sequences/03-extracting-and-comparing | `extract-region-dialog` | new |
| 02-sequences/03-extracting-and-comparing | `find-orfs-dialog` | new |
| 02-sequences/03-extracting-and-comparing | `go-to-location-hbb-codon` | new |
| 02-sequences/03-extracting-and-comparing | `hbb-annotation-context-menu` | new |
| 02-sequences/03-extracting-and-comparing | `hbb-record-in-sequence-viewport` | new |
| 02-sequences/04-aligning-sequences | `alignment-viewport-primate-mito` | new |
| 02-sequences/04-aligning-sequences | `export-alignment-sheet` | new |
| 02-sequences/04-aligning-sequences | `mafft-dialog` | new |
| 02-sequences/05-building-trees | `iqtree-dialog` | new |
| 02-sequences/05-building-trees | `tree-viewport-primate-mito` | new |
| 03-reads/01-importing-fastq | `fastq-viewport-summary-cards` | new |
| 03-reads/01-importing-fastq | `import-center-sequencing-reads-tab` | new |
| 03-reads/01-importing-fastq | `import-fastq-configuration-sheet` | new |
| 03-reads/01-importing-fastq | `sidebar-after-import` | new |
| 03-reads/02-downloading-from-sra | `sra-bundle-in-sidebar` | new |
| 03-reads/02-downloading-from-sra | `sra-import-configuration-sheet` | new |
| 03-reads/02-downloading-from-sra | `sra-results-download-selected` | new |
| 03-reads/02-downloading-from-sra | `sra-runs-pane` | new |
| 03-reads/03-quality-control | `fastq-sparkline-popover` | new |
| 03-reads/03-quality-control | `fastq-viewport-reads-tab` | new |
| 03-reads/03-quality-control | `fastq-viewport-summary-cards` | new |
| 03-reads/03-quality-control | `refresh-qc-summary-dialog` | new |
| 03-reads/04-trimming-and-filtering | `length-filter-readiness` | new |
| 03-reads/04-trimming-and-filtering | `primer-trimming-literal-pane` | new |
| 03-reads/04-trimming-and-filtering | `trim-operation-row` | new |
| 03-reads/04-trimming-and-filtering | `trimming-dialog` | new |
| 03-reads/05-decontamination | `human-scrub-dialog` | new |
| 03-reads/05-decontamination | `low-complexity-pane` | new |
| 03-reads/05-decontamination | `remove-duplicates-preset-picker` | new |
| 03-reads/06-subsetting-and-extraction | `search-subsetting-menu` | new |
| 03-reads/06-subsetting-and-extraction | `select-reads-by-sequence-pane` | new |
| 03-reads/06-subsetting-and-extraction | `subsample-by-count-pane` | new |
| 03-reads/07-ont-runs | `demultiplex-barcodes-pane` | new |
| 03-reads/07-ont-runs | `ont-barcode-sheet-controls` | new |
| 03-reads/07-ont-runs | `ont-import-configuration-sheet` | new |
| 03-reads/07-ont-runs | `sidebar-after-ont-import` | new |
| 03-reads/08-read-processing | `merge-overlapping-pairs-pane` | new |
| 03-reads/08-read-processing | `orient-reads-pane` | new |
| 03-reads/08-read-processing | `read-processing-menu` | new |
| 03-reads/08-read-processing | `sidebar-after-merge` | new |
| 04-alignments/01-mapping-reads-to-a-reference | `alignment-inspector-stats` | new |
| 04-alignments/01-mapping-reads-to-a-reference | `mapping-wizard-advanced` | new |
| 04-alignments/01-mapping-reads-to-a-reference | `mapping-wizard-overview` | new |
| 04-alignments/01-mapping-reads-to-a-reference | `tools-mapping-submenu` | new |
| 04-alignments/02-reading-an-alignment | `bam-viewport-overview` | new |
| 04-alignments/02-reading-an-alignment | `extract-reads-region-menu` | new |
| 04-alignments/02-reading-an-alignment | `pileup-zoom` | new |
| 04-alignments/02-reading-an-alignment | `view-settings-alignment-tab` | new |
| 04-alignments/02-reading-an-alignment | `view-settings-reads-tab` | new |
| 04-alignments/03-primer-trimming | `primer-trim-dialog-target` | new |
| 04-alignments/03-primer-trimming | `primer-trim-scheme-menu` | new |
| 04-alignments/03-primer-trimming | `primer-trim-track-result` | new |
| 04-alignments/04-alignment-quality | `analysis-export-tab` | new |
| 04-alignments/04-alignment-quality | `analysis-filtering-tab` | new |
| 04-alignments/04-alignment-quality | `filter-panel-controls` | new |
| 04-alignments/04-alignment-quality | `inspector-alignment-stats` | new |
| 04-alignments/05-viral-recon-wizard | `viral-recon-advanced-open` | new |
| 04-alignments/05-viral-recon-wizard | `viral-recon-inspector-outputs` | new |
| 04-alignments/05-viral-recon-wizard | `viral-recon-menu-item` | new |
| 04-alignments/05-viral-recon-wizard | `viral-recon-wizard-overview` | new |
| 05-variants/01-calling-variants-from-amplicons | `call-variants-dialog-bcftools` | new |
| 05-variants/01-calling-variants-from-amplicons | `call-variants-dialog-ivar` | new |
| 05-variants/01-calling-variants-from-amplicons | `variants-tab-two-callers` | new |
| 05-variants/02-reading-the-variant-browser | `variants-inspector-row` | new |
| 05-variants/02-reading-the-variant-browser | `variants-preset-chips` | new |
| 05-variants/02-reading-the-variant-browser | `variants-search-builder` | new |
| 05-variants/02-reading-the-variant-browser | `variants-source-column` | new |
| 05-variants/02-reading-the-variant-browser | `variants-tab-twelve-columns` | new |
| 05-variants/04-nanopore-variant-calling | `call-variants-dialog-medaka` | new |
| 05-variants/04-nanopore-variant-calling | `medaka-model-field` | new |
| 05-variants/04-nanopore-variant-calling | `tools-mapping-submenu` | new |
| 05-variants/05-consensus-and-lineage | `analysis-consensus-tab` | new |
| 05-variants/05-consensus-and-lineage | `consensus-destination-dialog` | new |
| 05-variants/05-consensus-and-lineage | `consensus-masking-sliders` | new |
| 05-variants/06-importing-existing-vcfs | `import-center-vcf-card` | new |
| 05-variants/06-importing-existing-vcfs | `imported-benchmark-in-variants-tab` | new |
| 05-variants/06-importing-existing-vcfs | `name-imported-variant-bundle` | new |
| 06-classification/01-what-is-classification | `classification-dialog-tool-sidebar` | new |
| 06-classification/01-what-is-classification | `classification-submenu` | new |
| 06-classification/01-what-is-classification | `import-center-classification-tab` | new |
| 06-classification/01-what-is-classification | `taxonomy-viewport-overview` | new |
| 06-classification/02-running-kraken2 | `kraken2-advanced-settings` | new |
| 06-classification/02-running-kraken2 | `kraken2-databases-tab` | new |
| 06-classification/02-running-kraken2 | `kraken2-dialog` | new |
| 06-classification/02-running-kraken2 | `kraken2-drilldown-coronaviridae` | new |
| 06-classification/02-running-kraken2 | `kraken2-extract-reads` | new |
| 06-classification/02-running-kraken2 | `kraken2-taxonomy-viewport` | new |
| 06-classification/03-running-esviritu | `esviritu-advanced-settings` | new |
| 06-classification/03-running-esviritu | `esviritu-alignment-evidence` | new |
| 06-classification/03-running-esviritu | `esviritu-database-missing` | new |
| 06-classification/03-running-esviritu | `esviritu-dialog` | new |
| 06-classification/03-running-esviritu | `esviritu-result-viewport` | new |
| 06-classification/04-running-taxtriage | `taxtriage-advanced-settings` | new |
| 06-classification/04-running-taxtriage | `taxtriage-batch-overview` | new |
| 06-classification/04-running-taxtriage | `taxtriage-dialog` | new |
| 06-classification/04-running-taxtriage | `taxtriage-result-table` | new |
| 06-classification/05-running-nao-mgs | `nao-mgs-import-card` | new |
| 06-classification/05-running-nao-mgs | `nao-mgs-import-sheet` | new |
| 06-classification/05-running-nao-mgs | `nao-mgs-result-viewport` | new |
| 06-classification/05-running-nao-mgs | `nao-mgs-taxon-detail` | new |
| 06-classification/06-blast-verification | `blast-results-drawer` | new |
| 06-classification/06-blast-verification | `blast-verify-popover` | new |
| 06-classification/07-running-freyja | `plugin-manager-wastewater-pack` | new |
| 06-classification/08-importing-cz-id-results | `czid-import-card` | new |
| 06-classification/08-importing-cz-id-results | `czid-import-sheet` | new |
| 06-classification/08-importing-cz-id-results | `czid-provenance-popover` | new |
| 06-classification/08-importing-cz-id-results | `czid-result-viewport` | new |
| 06-classification/09-novel-virus-detection | `nvd-blast-drawer` | new |
| 06-classification/09-novel-virus-detection | `nvd-column-menu` | new |
| 06-classification/09-novel-virus-detection | `nvd-import-card` | new |
| 06-classification/09-novel-virus-detection | `nvd-import-preview` | new |
| 06-classification/09-novel-virus-detection | `nvd-result-viewport` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-blast-review` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-dialog-inputs` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-dialog-options` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-export` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-result-species-table` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-unresolved-clusters` | new |
| 06-classification/10-twelve-s-metabarcoding | `twelve-s-workflow-library` | new |
| 06-human-germline-variants/01-haplotype-caller | `call-variants-dialog-gatk` | new |
| 06-human-germline-variants/01-haplotype-caller | `operations-panel-gatk-run` | new |
| 06-human-germline-variants/04-reference-packs | `plugin-manager-gatk-packs` | new |
| 06-human-germline-variants/04-reference-packs | `settings-advanced-experimental` | new |
| 07-assembly/01-when-to-assemble | `assembly-bundle-in-analyses` | new |
| 07-assembly/01-when-to-assemble | `assembly-sheet-assembler-picker` | new |
| 07-assembly/01-when-to-assemble | `assembly-submenu` | new |
| 07-assembly/02-running-spades | `assembly-advanced-settings` | new |
| 07-assembly/02-running-spades | `assembly-viewport` | new |
| 07-assembly/02-running-spades | `assembly-wizard-spades` | new |
| 07-assembly/02-running-spades | `contig-detail-pane` | new |
| 07-assembly/03-running-flye-or-hifiasm | `assembly-sheet-curated-arguments` | new |
| 07-assembly/03-running-flye-or-hifiasm | `assembly-sheet-flye` | new |
| 07-assembly/03-running-flye-or-hifiasm | `assembly-sheet-hifiasm` | new |
| 07-assembly/03-running-flye-or-hifiasm | `flye-contig-table` | new |
| 07-assembly/04-extracting-contigs | `contig-context-menu` | new |
| 07-assembly/04-extracting-contigs | `create-bundle-action-bar` | new |
| 07-assembly/04-extracting-contigs | `derived-bundle-in-sidebar` | new |
| 08-workflows/01-the-workflow-builder | `workflow-builder-canvas` | new |
| 08-workflows/01-the-workflow-builder | `workflow-builder-experimental-toggle` | new |
| 08-workflows/01-the-workflow-builder | `workflow-builder-node-inspector` | new |
| 08-workflows/01-the-workflow-builder | `workflow-builder-palette` | new |
| 08-workflows/01-the-workflow-builder | `workflow-builder-sidebar-library` | new |
| 08-workflows/02-exporting-as-nextflow-or-snakemake | `export-provenance-complete-alert` | new |
| 08-workflows/02-exporting-as-nextflow-or-snakemake | `export-provenance-save-panel` | new |
| 08-workflows/02-exporting-as-nextflow-or-snakemake | `export-provenance-submenu` | new |
| 08-workflows/02-exporting-as-nextflow-or-snakemake | `nextflow-export-main-nf` | new |
| 08-workflows/03-running-external-workflows | `workflow-library-linked-package` | new |
| 08-workflows/03-running-external-workflows | `workflow-operations-runner` | new |
| 09-genotyping/01-what-is-mhc-genotyping | `genotype-matrix-overview` | new |
| 09-genotyping/01-what-is-mhc-genotyping | `genotyping-submenu` | new |
| 09-genotyping/02-running-genotyping | `genotyping-advanced-options` | new |
| 09-genotyping/02-running-genotyping | `genotyping-analysis-mode` | new |
| 09-genotyping/02-running-genotyping | `genotyping-full-length-dialog` | new |
| 09-genotyping/02-running-genotyping | `genotyping-operations-row` | new |
| 09-genotyping/02-running-genotyping | `genotyping-run-dialog` | new |
| 09-genotyping/03-reading-the-genotype-comparison | `genotype-call-evidence` | new |
| 09-genotyping/03-reading-the-genotype-comparison | `genotype-inspector-display` | new |
| 09-genotyping/03-reading-the-genotype-comparison | `genotype-matrix-reading` | new |
| 09-genotyping/04-haplotype-definitions-and-export | `genotype-export-save-panel` | new |
| 09-genotyping/04-haplotype-definitions-and-export | `genotype-inspector-export` | new |
| 09-genotyping/04-haplotype-definitions-and-export | `genotype-pivot-workbook` | new |
| appendices/ai-assistant | `ai-assistant-azure-endpoint` | new |
| appendices/ai-assistant | `ai-assistant-panel` | new |
| appendices/ai-assistant | `ai-assistant-provider-setup` | new |
| appendices/primer-schemes | `primer-scheme-import-card` | new |
| appendices/primer-schemes | `primer-scheme-import-sheet` | new |
| appendices/primer-schemes | `primer-scheme-inspector` | new |
| appendices/shared-projects | `shared-projects-read-only-banner` | new |
| appendices/troubleshooting | `operations-panel-failed-row` | new |
