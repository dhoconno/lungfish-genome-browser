# Fidelity review, 06-classification/03-running-esviritu

Chapter 34 of the campaign roster. Reviewed 2026-09-07 against the Swift
source in this worktree, the CLI help tree from
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
the tool lock manifest, `parameters.yaml` entry `classify.esviritu`, and the
author's reference-run artifacts under the chapter scratch at
`.../scratchpad/esviritu/`.

The chapter is a large improvement on what DRIFT recorded. Every false row
DRIFT listed is fixed, all five of its unverifiable rows are settled, and the
Coverage-is-breadth error, which was the worst thing in the old chapter, is
not only corrected but explicitly warned against. The figures from the
reference run all reconcile against the run's own TSV and JSON.

Three findings matter. First, the chapter's Operations Panel phase sequence
is presented as an ordered list, and the reference run's own log shows the
phases arriving out of that order with one of the six never printed at all.
Second, the reference run's result table quotes `Identity | 99.7%`, but the
detection table's Identity column does not multiply the stored fraction by
100, so the column renders `1.0%` while the detail pane's Identity pill
renders `99.7%`. That is an app defect the author did not report, and it
falsifies a figure the chapter puts in a table. Third, several smaller
dialog and viewport strings drifted by a word or two.

All four of the author's defect claims are confirmed at source.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "EsViritu is a virus detector." | true | `FASTQOperationDialogState.swift:2042` "Detect viruses and report coverage."; `cli-help` `esviritu` overview | |
| "The collection EsViritu compares against holds 19,925 curated viral assemblies across 63 families, and nothing else" | true | `third-party-tools-lock.json:69`, `esviritu-viral-v3` description "19,925 curated viral assemblies across 63 families (Tisza et al. 2023)" | |
| "The tool that does the mapping is minimap2." | true | Author's run notes record `minimap2_f 127.47 s` and `MM_SET sr` from EsViritu's own parameter dump; EsViritu 1.3.3 maps with minimap2 | |
| "this chapter's example run spent most of its time on exactly that step" | true | 127.47 s of 345.2 s is the single largest phase, and it is the only phase the run recorded a timing for | |
| "LGE labels the tool **EsViritu** in its menus and describes it as 'Detect viruses and report coverage'." | true | `FASTQOperationDialogState.swift:1995` title "EsViritu"; `:2042` description | The source string ends with a period, "Detect viruses and report coverage." Quote it with the period or drop the quotation marks. |
| "A run writes a table of detected viruses, a per-window coverage file, a consensus sequence for each virus it found, and an indexed alignment file" | true | Run output holds `SRR36291587.detected_virus.info.tsv`, `.virus_coverage_windows.tsv`, `_final_consensus.fasta`, and `SRR36291587_temp/SRR36291587.third.filt.sorted.bam` plus `.bai` | |
| "EsViritu ships in the `metagenomics` plugin pack, which the Plugin Manager lists as **Metagenomics** and which also carries Kraken 2, Bracken, and RiboDetector." | true | `PluginPack.swift:772-777` id `metagenomics`, name "Metagenomics", packages `["kraken2", "bracken", "esviritu", "ribodetector"]` | |
| "Open **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | CONSISTENCY.md fixed phrasing; matches chapters 01, 02 | |
| "You also need the EsViritu viral database... It is the only database EsViritu uses, so there is no database to choose at run time" | true | `EsVirituWizardSheet.swift:374-410` renders a status line, not a picker; `parameters.yaml` notes "The database is not a control." | |
| "Every number quoted in this chapter came from a real run made on 2026-09-07 with EsViritu version 1.3.3 against database version v3.2.4." | true | `esviritu-result.json` `savedAt` 2026-09-07, `databasePath` `.../v3.2.4/`; lock manifest pins `bioconda::esviritu=1.3.3` | |
| "The EsViritu Viral DB is listed there among the classification databases, and it is the only entry EsViritu can use." | false | `PluginManagerView.swift:894-905` groups the Databases tab by tool and `MetagenomicsModels.swift:36` titles the EsViritu group "EsViritu Databases". The row is not mixed in among the Kraken 2 rows, it sits under its own section heading. | "The EsViritu Viral DB is the only row under the **EsViritu Databases** heading, and it is the only database EsViritu can use." |
| "Click **Download** on the EsViritu Viral DB row." | true | `PluginManagerView.swift:1245` `Text("Download")` on the database row's button | |
| "The reference run's copy occupies about 900 MB on disk once unpacked." | true | `lungfish-cli esviritu db-status` reports `Size : 895.6 MB`; `du -sh` reports 855M | |
| "Plan for at least 8 GB of memory on the machine that will run it" | true | `third-party-tools-lock.json:69` `recommendedRAM` 8589934592; `EsVirituWizardSheet.swift:211-214` warns below the same threshold | |
| "You can confirm the same thing from the run dialog, whose Database section shows a green dot and reads `EsViritu v3.2.4` with the installed size beside it" | true | `EsVirituWizardSheet.swift:385-397` renders a sage-filled Circle plus `"EsViritu \(currentVersion)"` and the size in parentheses | |
| "`lungfish-cli esviritu db-status` prints the same facts as four lines, giving the status, the version, the path on disk, and the size." plus the quoted block | true | Ran `lungfish-cli esviritu db-status`; output matches the chapter's code block verbatim, including `Size   : 895.6 MB` | |
| "`lungfish-cli esviritu download-db` fetches the database from the command line instead, taking `--force` to replace a copy that is already there." | true | `cli-help` `esviritu` subcommands list `download-db`; `--force` documented as "Re-download even if the database is already installed" | |
| "Open **Tools > Classification > EsViritu...**." | true | `MainMenu.swift:786-819` builds the submenu; `FASTQOperationDialogState.swift:2070`, `:1995` | |
| "Picking EsViritu opens the FASTQ/FASTA Operations dialog with EsViritu already selected." | true | `FASTQOperationDialogState.swift:1250-1252` dialog title; ground-truth map line 76 | |
| "the tool sidebar down its left edge lists Kraken2 and TaxTriage beside EsViritu" | true | `FASTQOperationDialog.swift:30-43` passes `state.sidebarItems`; `FASTQOperationDialogState.swift:1144-1148`, `:2070` | |
| "Read the **Sample** section. It holds a text field carrying a sample name worked out from the file name, and under it one line reading **Paired-end reads** or **Single-end reads**." | true | `EsVirituWizardSheet.swift:326-370`, section title "Sample" at `:328`, `TextField` at `:359`, `Text(sample.isPairedEnd ? "Paired-end reads" : "Single-end reads")` at `:363` | |
| "Pairing comes from the way LGE grouped the bundles you selected" | true | `EsVirituWizardSheet.swift:96-100` comment naming `MetagenomicsSampleGrouper`; the line is read-only `Text`, not a control | |
| "If instead it shows an amber dot and reads `Database not installed`, a **Download Database...** button sits beside those words and opens the Plugin Manager straight to its Databases tab." | true | `EsVirituWizardSheet.swift:398-408`, creamsicle Circle, `Text("Database not installed")`, `Button("Download Database\u{2026}")` calling `PluginManagerWindowController.show(tab: .databases)` | |
| "Leave **Enable quality filtering (fastp)** ticked and **Advanced Settings** collapsed for a first run." | true | `EsVirituWizardSheet.swift:91` `qualityFilter = true`, `:92` `showAdvanced = false`, `:443` toggle label | |
| "A warning may appear under the Database section reading 'This system has limited RAM. EsViritu may run slowly with large databases. Consider closing other applications before running.'" | true | `EsVirituWizardSheet.swift:425` renders that string verbatim | |
| "It is advisory rather than blocking, and it appears only on a machine with modest memory." | true | `EsVirituWizardSheet.swift:211-214` `systemRAMBytes < 8_589_934_592`; the banner is not wired to `canRun` | The banner also requires the database to be installed (`:411` `showRAMWarning && isDatabaseInstalled`), so it never appears alongside the "Database not installed" state. Worth one clause if the reader might look for it before installing. |
| "If you selected bundles for more than one sample, the Sample section becomes **Batch Samples** instead, listing each grouped sample tagged `PE` or `SE`" | true | `EsVirituWizardSheet.swift:328` `isBatchMode ? "Batch Samples" : "Sample"`; `:340-343` renders `"\u{2022} \(sampleId) (\(mode))"` with mode `"PE"`/`"SE"` | The list shows at most eight samples, then "…and N more" (`:345-349`). Not stated, and a reader with a large batch will notice. |
| "a **Run Mode** control appears fixed on 'Run separately per bundle'" | false | `MultiBundleRunModePicker.swift:76-80` titles the row "Run separately per bundle (N results)" with the bundle count interpolated, and `:63-72` renders the second row, "Combine all inputs, run once (1 result)", present but disabled. The control is not "fixed on" one option, it shows two options with one greyed out. | "a **Run Mode** control appears, offering **Run separately per bundle** and a greyed-out **Combine all inputs, run once**, so the choice is made for you." |
| "for the reason the Settings section gives" / Settings entry "because pooling reads across samples before detection would mix up the per-virus coverage and abundance numbers that are the whole point of running the tool" | false | The on-screen lock reason is `EsVirituWizardSheet.swift:112-114`, "Selections run as one classification batch (one operations entry, merged summary); each sample is classified separately within the batch." The pooling rationale is the source-code comment at `:93-100`, not text the reader sees. `parameters.yaml` also carries the pooling wording, so the registry drifted here too. | Quote the caption the reader sees, then give the pooling rationale as the chapter's own explanation rather than as "the lock reason". |
| "The row's detail reads 'Running EsViritu detection…'" | true | `EsVirituPipeline.swift:373` `OperationMarker.markInProgress(..., detail: "Running EsViritu detection\u{2026}")` | |
| "then names each phase as EsViritu reaches it, in the sequence 'Quality filtering reads...', 'Aligning reads to viral references...', 'Screening for viral signatures...', 'Assembling viral contigs...', 'Calculating coverage statistics...', and 'Building taxonomic profile...'" | false | All six strings exist (`EsVirituPipeline.swift:787-800`), but they are emitted by substring matching on EsViritu's stderr, not in a fixed order. The reference run's own `run.log` never printed "Aligning reads to viral references..." at all, and printed the rest out of this order and repeatedly, for example Assembling before Screening and Building taxonomic profile interleaved with Assembling. | "then names phases as it matches them in EsViritu's output. You may see 'Quality filtering reads...', 'Aligning reads to viral references...', 'Screening for viral signatures...', 'Assembling viral contigs...', 'Calculating coverage statistics...', and 'Building taxonomic profile...'. They are matched from the tool's own log lines rather than driven by a fixed pipeline, so they can repeat, arrive out of order, or not appear at all." |
| "before finishing with 'Parsing detection results...', 'Saving result metadata...', 'Saving provenance...', and 'Detection complete'." | true | `EsVirituPipeline.swift:515`, `:537`, `:595`, `:647`, `:664`; the reference run's `run.log` printed exactly these four in that order at the end | |
| "The reference run took 345.2 seconds end to end against 85,199 read pairs on a fourteen-core Mac" | true | `esviritu-result.json` `"runtime": 345.236310005188`; `"threads": 14`; author's notes record 85,199 pairs. Measured duration, attributed to the run, which the campaign rules allow | |
| "of which the first mapping pass alone took 127 seconds" | true | Author's notes record `minimap2_f 127.47 s` from EsViritu's own parameter dump | |
| "It is a folder named `esviritu-<timestamp>` under the project's `Analyses` folder" | true | `AnalysesFolder.swift:25` lists `esviritu` in `knownTools`; CONSISTENCY.md fixes the `<tool>-<timestamp>` shape | |
| "The dialog carries six controls. Three sit in plain view and three live inside the **Advanced Settings** disclosure" | true | Sample, Run Mode, Enable quality filtering (fastp) in plain view; Min read length, Threads, Extra arguments inside `advancedSettings` (`EsVirituWizardSheet.swift:459-500`). Matches the six settings in `parameters.yaml` | Run Mode appears only in batch mode, so a single-sample reader sees two plain-view controls, not three. The chapter says so in the Run Mode entry, but the lead sentence does not. |
| "where their labels carry a trailing colon on screen" | true | `EsVirituWizardSheet.swift:463` "Min read length:", `:472` "Threads:", `:483` "Extra arguments:" | |
| Settings, **Sample.** "It arrives filled in with a name worked out from the file name... it appears only for a single-sample run" plus "On the command line this is `--sample`." | true | `EsVirituWizardSheet.swift:328-359`; `cli-help` `esviritu detect` `-s, --sample`; matches `parameters.yaml` | |
| Settings, **Run Mode.** "This setting has no command-line flag." | true | `parameters.yaml` `cli_flag: null`; no such flag in `esviritu detect --help` | |
| Settings, **Enable quality filtering (fastp).** "It is ticked by default... and the dialog says so under the checkbox in either state." plus "On the command line this is `--no-qc`, which turns the filter off rather than on." | true | `EsVirituWizardSheet.swift:91`, `:443-450` renders one of two captions depending on state; `cli-help` `--no-qc` "Skip quality filtering (fastp)" | |
| Settings, **Min read length:.** "The default is 100 bases and the stepper accepts 50 to 500 in steps of ten" plus "On the command line this is `--min-read-length`." | true | `EsVirituWizardSheet.swift:124` `= 100`, `:467` `in: 50...500, step: 10`; `cli-help` `--min-read-length` default 100 | |
| Settings, **Threads:.** "The default is the number of cores currently available on your Mac and the stepper will not let you exceed the core count" | true | `EsVirituWizardSheet.swift:125` `activeProcessorCount`, `:478` `in: 1...ProcessInfo.processInfo.processorCount`. The default uses active cores and the ceiling uses total cores, which is what the sentence says. Matches `parameters.yaml`. `cli-help` `-t, --threads` | |
| Settings, **Extra arguments:.** "It is empty by default... an unclosed quote blocks the run with the dialog saying so." plus "On the command line this is `--extra-args`." | true | `EsVirituWizardSheet.swift:126` `= ""`, `:195` comment on an unterminated quote, `:268` feeds `advancedArgumentsParseError` into the dialog's status text and `:270` gates the primary button; `cli-help` `--extra-args` | |
| "The table's columns are Sample, Virus Name, Family, Reads, Unique Reads, RPKMF, Coverage, Identity, and Segment" | true | `ViralDetectionTableView.swift:428`, `:437`, `:446`, `:455`, `:464`, `:473`, `:482`, `:491`, `:500`, and the export header at `:522` | |
| "a **Filter viruses...** field above them narrows the rows with a count beside it reporting how many survived" | true | `ViralDetectionTableView.swift:408` placeholder "Filter viruses..."; `:630` `countLabel.stringValue = "\(filtered.count) of \(total) assemblies"` | The count reads "N of M assemblies", which names assemblies rather than rows. Worth quoting so the reader recognises it. |
| "**Unique Reads** is how many of those reads mapped to that virus and to nothing else in the database" | true | `ViralDetectionTableView.swift:465` header tooltip "Deduplicated read count for this viral detection."; the chapter's gloss matches the recompute path's intent | |
| "**Coverage** is the mean sequencing depth along the reference, written with an `x` after it, drawn beside a sparkline" | true | `ViralDetectionTableView.swift:1799` `String(format: "%.1fx", meanCoverage)`; `:1808-1826` adds a `ViralCoverageSparklineView` in the same cell | The sparkline sits to the left of the number in the cell (`:1820-1824`), so "beside" is right but "before" would be more precise for a reader hunting for it. |
| "Note what the Coverage column is not. It reports depth... not coverage breadth" | true | `ViralDetectionTableView.swift:1799`; the DRIFT-flagged breadth error is correctly reversed here | The column's own numeric *filter* does match on breadth percent (`:1362-1364`), not on the depth it displays, so a reader who filters Coverage gets a different quantity from the one shown. That is an app defect, not a chapter error, and is listed below. |
| Reference run table: "Virus Name | Severe acute respiratory syndrome coronavirus 2" | true | `SRR36291587.detected_virus.info.tsv`, `Name` column | |
| Reference run table: "Family | Coronaviridae" | true | same TSV, `family` = `f__Coronaviridae` | |
| Reference run table: "Reads | 162,441" | true | same TSV, `read_count` 162441 | |
| Reference run table: "RPKMF | 32,022.4" | true | same TSV, `RPKMF` 32022.43092423311; column formats `%.1f` (`ViralDetectionTableView.swift:1622`) | |
| Reference run table: "Coverage | 1259.4x" | true | same TSV, `mean_coverage` 1259.352791196994, formatted `%.1fx` | |
| Reference run table: "Identity | 99.7%" | false | The underlying value is right (`avg_read_identity` 0.9969929135297535), and the detail pane's Identity pill does render 99.7% (`EsVirituDetailPane.swift:391` multiplies by 100). But the **table's** Identity column does not multiply: `ViralDetectionTableView.swift:1640` is `makeDecimalCell(value: assembly.avgReadIdentity, format: "%.1f%%")`, and the parser stores the raw fraction (`EsVirituDetectionParser.swift:385`). The column therefore renders `1.0%` for this run. | Either report the figure as the detail pane's Identity pill value and say the column is affected by the defect below, or quote the column's real output. Do not present 99.7% as what the Identity column shows. |
| Reference run table: "Segment | em dash" | true | same TSV, `Segment` = `NA`; `ViralDetectionTableView.swift:1685` renders `"\u{2014}"` for a nil segment | The chapter writes the words "em dash" in the cell rather than the glyph. Intentional and readable, but flagged so the brand editor can rule on it. |
| "The reference accession behind that row is `OP400692.1`, a 29,808-base SARS-CoV-2 genome that the database describes as the Omicron BQ.1.23 lineage." | true | same TSV, `Accession` OP400692.1, `Length` 29808, `description` "SARS-CoV-2 Omicron-BQ.1.23" | |
| "162,441 reads mapped, out of the 170,180 that survived the quality filter, so about 95 in every 100 reads in this library are viral." | true | TSV `filtered_reads_in_sample` 170180 matches `SRR36291587_esviritu.readstats.yaml` "reads for EsViritu denominator: 170180"; 162441/170180 = 95.45% | |
| "The detection recorded 29,777 of the reference's 29,808 bases as covered, a breadth of 99.90%, meaning only 31 bases of the genome went unread." | true | TSV `covered_bases` 29777, `Length` 29808; 29777/29808 = 99.896%, and 29808 − 29777 = 31 | |
| "The per-window coverage file divided the reference into 100 windows and the thinnest of them still averaged 319.4 reads deep." | true | `SRR36291587.virus_coverage_windows.tsv` holds exactly 100 data rows; minimum `average_coverage` is 319.40604026845637 | |
| "Nothing from the human background of this clinical specimen shows up, because the database holds no human sequence." | true | The run returned one detection, all viral; the manifest describes the database as viral assemblies only | |
| "It opens on a **Detected Viruses Overview** while nothing is selected" | true | `EsVirituDetailPane.swift:226` `overviewTitleLabel.stringValue = "Detected Viruses Overview"` | |
| "reporting four metric pills labelled Reads, RPKMF, Coverage, and Identity" | true | `EsVirituDetailPane.swift:387-392` builds exactly those four | |
| "The Coverage pill, like the column, is mean depth written with an `x`." | true | `EsVirituDetailPane.swift:390` `String(format: "%.1fx", assembly.meanCoverage)` | |
| "For a segmented virus... the pane also draws a completeness grid with one cell per segment showing that segment's depth and read count." | true | `SegmentCompletenessView.swift:32` holds `(label, coverage, reads)` per segment; `:55` titles it "Segment Coverage (N of M segments detected)" | |
| "SARS-CoV-2 has one continuous genome, so the reference run's Segment column shows an em dash and no grid appears." | true | TSV `Segment` = `NA`; the detection has one contig, so the grid has nothing to show | |
| "Selecting a row that carries alignment data also swaps the detail pane over to the full alignment viewer. There is no separate button to press." | true | `EsVirituResultViewController.swift:436-437` installs the evidence viewport's view on selection; `ViewerViewController+EsViritu.swift:50-56` supplies the factory | |
| "The viewer opens the indexed BAM file saved alongside the result" | true | `EsVirituResultViewController.swift:687-700` resolves `bamPath`/`bamIndexPath` relative to the result directory | The BAM the run wrote sits in a `<sample>_temp/` subfolder (`SRR36291587_temp/SRR36291587.third.filt.sorted.bam`) and is relocated to a `bams/` folder by `build-db` (`BuildDbCommand.swift:1518-1540`). "Alongside the result" is loose. "Inside the result folder" would be safe. |
| "it offers the same ruler, pan and zoom, read packing, and filters as the general alignment viewer elsewhere in LGE" | true | `MainSplitViewController.swift:417-424` builds a `ClassifierAlignmentEvidenceViewportController` sharing the alignment viewport's controls | |
| "EsViritu maps against the shared pangenome of its managed database rather than against a reference bundle in your project" | true | `ViewerViewController+EsViritu.swift:57-60` comment, "EsViritu aligns against the managed database's pangenome FASTA, which lives outside the result directory" | |
| "It reads 'Structurally validated reference'... 'BAM M5 validated reference'... and 'No reference provided'" | true | `ClassifierAlignmentInspectorCapabilities.swift:26-30`, all three strings verbatim | |
| "The first two both let the mismatch and consensus displays work. The third leaves them unavailable, and the message tells you why." | true | `ClassifierAlignmentInspectorCapabilities.swift:162-163` gates `.referenceMismatch` and `.consensus` on `referenceValidation.isValidated`, disabling with "A validated reference sequence is required."; `:17-22` makes `.structural` and `.md5` validated and `.absent`/`.unavailable` not | |
| "Right-click a detection row and the context menu offers **Extract Reads...** first... **BLAST Verify...**... a **Look Up on NCBI** submenu... GenBank Accession, Assembly Record, PubMed Literature, and Taxonomy Browser... Copy Virus Name, Copy Accession, and Copy Row as TSV, and... Expand All and Collapse All" | true | `ViralDetectionTableView.swift:805-864` builds exactly that menu in exactly that order. This settles DRIFT unverifiable row 29. | |
| "which writes the reads that mapped to that virus as a new FASTQ bundle in the project's `Extractions` folder" | true | `ClassifierReadResolver.swift:73-78` `extractionsFolderName = "Extractions"`, with the comment that extractions live in their own top-level folder | |
| "**Extract FASTQ** and **BLAST Verify** act on the current selection and stay disabled until you select a row, with the tooltip saying 'Select a row to use BLAST Verify' when nothing is chosen." | true | `ClassifierActionBar.swift:24`, `:51`, `:124-137`; `EsVirituResultViewController.swift:808`, `:898` pass exactly that reason | The rendered tooltip is that reason plus the BLAST help summary (`ClassifierActionBar.swift:130`), so the reader sees a longer string than the chapter quotes. |
| "**Export** writes the detections to a CSV or TSV file through a save panel, and its menu also offers Copy for the clipboard." | false | `EsVirituResultViewController.swift:1754-1789` builds the Export menu as "Export as CSV…", "Export as TSV…", "Copy Summary", and "Show Provenance…". The clipboard item is labelled **Copy Summary**, not Copy, and the menu also carries a fourth item the chapter does not mention. | "**Export** writes the detections to a CSV or TSV file through a save panel, and its menu also offers **Copy Summary** for the clipboard and **Show Provenance...**." |
| "An information button opens the run's provenance, which records the tool version, the runtime, the database, and the input files." | true | `ClassifierActionBar.swift:76` `info.circle` button; the run's `.lungfish-provenance.json` and `esviritu-result.json` hold `toolVersion`, `runtime`, `databasePath`, and `inputFiles` | The tool version it records is wrong for the reason in defect 1 below, which the chapter does say in the command-line section but not here. |
| "a **Recompute Unique Reads** button appears in the action bar, which recounts the unique read figures from each sample's alignment when a stored value is missing" | true | `EsVirituResultViewController.swift:218-222` "only shown in batch mode", title at `:221`; `:1330-1333` adds it as the custom button | |
| "A cell showing an ellipsis in the Unique Reads column is one of those missing values waiting to be recomputed." | true | `ViralDetectionTableView.swift:1621` returns `makeTextCell(text: "\u{2026}")` with the comment "ellipsis while computing" | |
| "A sample picker filters the table down to the samples you want to compare" | true | `EsVirituResultViewController.swift:298`, `:511-512`, `:789-792` | |
| "The Inspector's **Import Metadata...** button attaches a CSV or TSV sample sheet to the result." | true | `InspectorView.swift:1155-1160`; `EsVirituResultViewController.swift:179` conforms to `SampleMetadataPresentationConsumer` | |
| "A row with no value for one of those fields shows an em dash in that cell" | true | `MetadataColumnController.swift:503` returns `"\u{2014}"`, `:535` renders it in tertiary label colour | |
| "and the columns survive closing and reopening the result" | unverifiable | `InspectorViewController+MetadataImport.swift:455-491` writes metadata edits to disk, but that path is written against a `ReferenceBundle`. Nothing in `EsVirituResultViewController` reloads a stored metadata sheet on open. Settling it needs the app run, metadata imported into an EsViritu result, the result closed and reopened. | |
| "The reference run's detection is labelled with an Omicron BQ.1.23 genome, which says that BQ.1.23 was the nearest neighbour in a collection of 19,925 assemblies" | true | TSV description; manifest count | |
| "The detection subcommand takes its input behind `--input`, never as a bare argument, and repeating the flag supplies the two mates of a pair." | true | `esviritu detect --help`, `-i, --input <input>` "Provide two files for paired-end"; no positional argument in the usage line | |
| The `lungfish-cli esviritu detect` code block | true | Every flag in the block exists with the shown spelling; the author ran the same command | |
| "`--sample` names the run in every output file, which is required rather than optional." | true | `esviritu detect --help` usage line shows `--sample <sample>` outside the optional brackets | |
| "`--output` (or `-o`) chooses where the results go and defaults to the current directory" | true | `esviritu detect --help`, "-o, --output <output> Output directory (default: current directory)" | |
| "`--db` points at a specific database folder instead of the installed one" and "`--recursive` picks up eligible FASTQ files inside subfolders when an input is a folder" | true | `esviritu detect --help`, `--db` "(default: auto-detect)"; `--recursive` "When an input is a directory, include eligible FASTQ files in subfolders" | |
| "Adding `--format json` prints the summary as JSON instead of text" | true | `esviritu detect --help`, `--format` values `text, json, tsv` | The flag also takes `tsv`, which the chapter does not mention. Not wrong, just partial. |
| "The reference run ended with these two lines." plus the quoted block | true | The run's `run.log` ends with `✓ Detection completed in 345.2s` and `1 virus(es) detected` | |
| "The detection table is `<sample>.detected_virus.info.tsv`... it carries a full taxonomy for each row from kingdom down to subspecies alongside the read count, the covered bases, the mean coverage, and the identity figures." | true | The TSV header carries `kingdom` through `subspecies`, plus `read_count`, `covered_bases`, `mean_coverage`, `avg_read_identity`, `consensus_ref_identity` | |
| "Beside it sit `<sample>.detected_virus.assembly_summary.tsv`, `<sample>.tax_profile.tsv`, and `<sample>.virus_coverage_windows.tsv`" | true | All three present in the run's output directory | |
| "A consensus sequence for each virus found lands in `<sample>_final_consensus.fasta`, a browsable HTML report in `<sample>_EsViritu_reactable.html`, and a read-statistics file records how many reads survived the quality filter." | true | `SRR36291587_final_consensus.fasta`, `SRR36291587_EsViritu_reactable.html`, `SRR36291587_esviritu.readstats.yaml` all present; the readstats file holds both the pre-filter and denominator counts | |
| "A JSON sidecar named `esviritu-result.json` ties them together" | true | Present, holding `detectionPath`, `assemblyPath`, `coveragePath`, `taxProfilePath`, and the config | |
| "Its `toolVersion` field, and the 'Tool' line the command prints, currently report the version of the Python interpreter that ran EsViritu rather than the version of EsViritu itself." | true | `esviritu-result.json` `"toolVersion": "3.14"`; `run.log` prints `Tool: EsViritu 3.14`; installed tool is 1.3.3. Cause confirmed at `ShellUtilities.swift:146-151`, which takes the first `\d+\.\d+(\.\d+)?` match anywhere in the combined output, catching `python3.14t` in the site-packages path. Called from `EsVirituPipeline.swift:379`. | The chapter calls it "the version of the Python interpreter". It is more precisely a version-shaped fragment of the interpreter's path. The reader-facing advice is right either way. |
| "Read the version off the Plugin Manager's Metagenomics row instead when you need it for a methods section." | true | The pack's tool version comes from the lock manifest (`third-party-tools-lock.json:51` `"version": "1.3.3"`), not from `detectToolVersion` | |
| "`lungfish-cli import esviritu <results-dir>`... taking `--output-dir` for the destination project and `--name` for the imported result's name." | true | `import esviritu --help`, `-o, --output-dir` and `--name` with those descriptions | |
| "`lungfish-cli build-db esviritu <result-dir>` builds a SQLite index over an existing result... taking `--force` to rebuild over an existing index and `--no-cleanup` to keep the intermediates." | true | `build-db esviritu --help`, `--force` "Force rebuild even if database exists", `--no-cleanup` "Skip post-build cleanup of intermediate files" | |
| The `lungfish-cli extract reads --by-classifier` code block | true | `extract reads --help` shows `--by-classifier`, `--tool` (values include esviritu), `--result`, `--sample`, `--accession`, `-o, --output`, all with the shown spellings | |
| "`--accession` names the reference contig... and `--sample` scopes the accessions that follow it" | true | `extract reads --help`, `--accession` "Reference accession / contig name (repeatable)", `--sample` "Sample ID (repeatable; scopes subsequent --accession/--taxon flags)" | |
| "`--read-format fasta` drops the quality scores, `--include-unmapped-mates` also pulls the partner of any pair where only one mate mapped, and `--bundle` wraps the output as a `.lungfishfastq` bundle" | true | `extract reads --help`, all three present with matching descriptions | |
| "The same resolver backs the dialog and the command, so both produce identical output for the same selection." | true | `extract reads --help`, "The same resolver backs the GUI extraction dialog, so the CLI and GUI produce byte-identical output for the same selection." | |

## Front matter

`parameters_refs: [classify.esviritu]` matches roster row 34 at DRIFT.md
line 3760 exactly.

All five `<!-- SHOT -->` markers in the body (`esviritu-dialog`,
`esviritu-database-missing`, `esviritu-advanced-settings`,
`esviritu-result-viewport`, `esviritu-alignment-evidence`) have a matching
`shots` entry with a caption, and there are no extra `shots` entries and no
`planned_shots` left over. The `esviritu-database-missing` marker moved into
the dialog walkthrough as the DRIFT screenshot row asked.

All 26 `glossary_refs` anchors resolve in `GLOSSARY.md`. The three the author
added (`minimap2` at line 317, `pangenome` at 367, `rpkmf` at 447) are in the
existing entry shape, in alphabetical position, and each carries a
`See also:` line.

`LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues.

## Settings coverage against parameters.yaml

All six settings in the `classify.esviritu` registry entry have a Settings
paragraph, with labels copied exactly including the trailing colons on the
three Advanced Settings controls. Every default and allowed range matches the
registry and the source. The `cli_flag` values match, including the `null` for
Run Mode rendered as "This setting has no command-line flag."

One registry drift found. The Run Mode entry's `effect` field carries the
pooling rationale rather than the lock caption the picker actually shows, so
`parameters.yaml` and the chapter are wrong together on that point. The
registry owner should update the entry alongside the chapter.

## Consistency

Menu path, Plugin Manager and Operations Panel shortcuts, the
`Analyses/esviritu-<timestamp>/` result shape, the `Extractions` folder, the
`metagenomics` pack shown as **Metagenomics**, the fixture name "the
SRR36291587 SARS-CoV-2 reads", and the two fixed Before you start sentences
all match CONSISTENCY.md and chapters 01, 02, and 01-foundations/07. No
per-classifier colour is claimed anywhere, which is right, since the
ground-truth map found no colour assignment in the wizard source.

## App defects

1. **Confirmed, and the author's report is right.** The recorded EsViritu
   tool version is a fragment of the Python interpreter path.
   `ShellUtilities.swift:146-151` returns the first `\d+\.\d+(\.\d+)?` match
   in the combined stdout and stderr, and `EsViritu --version` emits the
   site-packages path containing `python3.14t` before the real version, so
   `detectToolVersion` (`EsVirituPipeline.swift:379`) returns `3.14` for a
   tool that is 1.3.3. This lands in `esviritu-result.json`, in the
   provenance record, and in the CLI summary line. A provenance-integrity
   bug, and it would put a wrong version into a methods export. The regex
   should anchor on the last line, or on a line that is a bare version.

2. **Confirmed.** Three disagreeing database sizes.
   `third-party-tools-lock.json:69` gives `sizeOnDisk` 5368709120 (5 GB) and
   `sizeBytes` 419430400 (400 MB), `EsVirituCommand.swift:311` prints
   `Size: ~2 GB (compressed)`, and the installed copy measures 855M on disk
   with `db-status` reporting 895.6 MB. Low severity, but it misleads anyone
   budgeting disk, and the 5 GB `sizeOnDisk` also drives the RAM warning
   comment at `EsVirituWizardSheet.swift:212`.

3. **Confirmed.** `lungfish-cli conda db install-managed --list` returns only
   `human-scrubber`, `deacon-panhuman`, and `deacon-ribokmers`. The EsViritu
   database is not listed. Probably by design, since `esviritu download-db`
   exists, but a reader who reaches for the managed list will not find it.

4. **Confirmed.** The run log is deleted on success. `SRR36291587_esviritu.log`
   existed during the run and is absent from the finished output directory,
   so a completed run is harder to debug after the fact than a running one.

5. **New, not in the author's report, and it falsifies a chapter figure.**
   The detection table's Identity column does not convert the stored fraction
   to a percentage. `EsVirituDetectionParser.swift:385` stores
   `avg_read_identity` as the raw 0.9969…, `EsVirituDetailPane.swift:391`
   renders the Identity pill as `String(format: "%.1f%%", ... * 100)` giving
   99.7%, but `ViralDetectionTableView.swift:1640` renders the column as
   `String(format: "%.1f%%", assembly.avgReadIdentity)` with no multiplier,
   giving 1.0%. The column and the pill disagree by two orders of magnitude
   for the same detection. The chapter's reference-run table quotes 99.7% as
   a column value.

6. **New.** The Coverage column's numeric filter matches on breadth, not on
   the depth the column displays. `ViralDetectionTableView.swift:1362-1364`
   computes `coveredBases / assemblyLength * 100` for the filter predicate,
   while `:1799` renders `meanCoverage`. A reader who filters Coverage above
   500 on this run's 1259.4x row gets no match, because the filter is
   comparing 99.9. Given how hard the chapter works to separate depth from
   breadth, this is worth fixing.

## Counts

True: 74. False: 6. Unverifiable: 1.
