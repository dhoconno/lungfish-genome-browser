# Fidelity review, 06-classification/02-running-kraken2

Chapter 33 of the 2026-09 campaign. Reviewed against the Swift sources, the
`lungfish-cli` help tree and live reruns from `.build/debug/lungfish-cli`,
`parameters.yaml`, the reality map, CONSISTENCY.md, and the author's report.

Ground truth for the numbers is the author's own scratch under
`scratchpad/kraken2/`, whose five kreports I read directly and two of whose
runs I reproduced (the SILVA exit-64 case and the wrong-argument extract case).
Nothing was written outside that scratch directory.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues.

## Claims

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "LGE labels this tool **Kraken2** in its menus" | true | `FASTQOperationDialogState.swift:1994` returns "Kraken2" for `.kraken2`; `MainMenu.swift:805-812` builds each item as `"\(toolID.title)…"` | |
| "describes it as \"Classify reads taxonomically\"" | true | `FASTQOperationDialogState.swift:2041` returns "Classify reads taxonomically." The app string carries a trailing period the chapter's quotation drops, which is a quoting nicety rather than a fidelity error | |
| "Kraken 2 assigns the reads, and then Bracken re-estimates how abundant each species actually was" | true | `ClassificationWizardSheet.swift:664-700` `makeProfileConfig` sets `goal: .profile` and `brackenProfileRequest: .automaticDefault`; `PluginPack.swift:776` ships both tools | |
| "The result lands as a timestamped folder under the project's `Analyses` folder" | true | `AppDelegate+Classification.swift:842-845` calls `AnalysesFolder.createAnalysisDirectory(tool: "kraken2", in: projectURL)`; matches CONSISTENCY.md's `Analyses/<tool>-<timestamp>/` rule | |
| "a sunburst chart on the left, a sortable table on the right, and a breadcrumb bar naming whichever part of the tree you have moved into" | true | `TaxonomyViewController.swift:153-158` composes all three; `:867-885` places the breadcrumb bar above the split view. The bar spans the full width above both panes rather than sitting over the chart alone, which the shot caption should keep in mind | |
| "86,281 paired-end Illumina read pairs" (Why you would do this) | false | The fixture README records 86,281 pairs for the archived run, but every count the chapter quotes comes from the copy actually classified, which holds 85,199 pairs (`wc -l reads/SRR36291587_1.fastq` / 4 = 85,199). The chapter then says "these 85,199 read pairs" three times, so it contradicts itself | "a QIAseq Direct amplicon library of 85,199 paired-end Illumina read pairs" |
| "taken from a human clinical specimen" | unverifiable | No campaign input establishes the specimen source. The fixture README (`fixtures/sarscov2-srr36291587/README.md`) names only the kit, the platform and the pair count, and DRIFT's fixture lines say only "viral by design". The SRA BioSample record would settle it | |
| "Kraken 2 and Bracken both ship in the `metagenomics` plugin pack, which the Plugin Manager lists as **Metagenomics**" | true | `PluginPack.swift:773` `name: "Metagenomics"`, `:776` `packages: ["kraken2", "bracken", "esviritu", "ribodetector"]` | |
| "Open **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:773-780`, keyEquivalent "b" with `[.command, .shift]` | |
| "Nine Kraken 2 collections are listed, from the half-gigabyte Viral collection up to the seventy-two-gigabyte PlusPF" | false | The Kraken 2 section of the Databases tab lists **eleven** rows, not nine. `PluginManagerView.swift:893-905` groups by `$0.tool`, and `third-party-tools-lock.json` files SILVA and Greengenes under `tool: kraken2` alongside the nine downloadable collections. `conda db list` confirms 13 rows of which 11 are Kraken 2. The nine-collection figure is right only for the downloadable collections. (`01-foundations/07-plugin-packs.md:153` carries the same undercount and needs the same fix.) | "Eleven Kraken 2 rows are listed, nine downloadable collections from the half-gigabyte Viral collection up to the seventy-two-gigabyte PlusPF, plus SILVA and Greengenes, which LGE builds on your own machine." |
| "the half-gigabyte Viral collection up to the seventy-two-gigabyte PlusPF" | true | `MetagenomicsModels.swift:107` PlusPF 72 GB, `:110` Viral 536,870,912 bytes | |
| "the banner at the top, which reads \"Recommended for your system\"" | true | `PluginManagerView.swift:858` renders `"Recommended for your system (\(formatRAM(...)) RAM): "` followed by the name. The chapter's partial quotation is accurate as far as it goes | |
| "and names the largest collection that fits your Mac's memory" | false | `MetagenomicsDatabaseRegistry.swift:966-983` picks the largest collection whose RAM need fits **60 %** of system RAM (`recommendationHeadroomFraction = 0.6`, `:985`), and `:990-997` restricts candidates to six general-purpose collections, excluding Viral, MinusB and EuPathDB46. On this 48 GB machine `conda db recommend` returns PlusPF-16 (16 GB), not EuPathDB46 (34 GB), which fits RAM but is a specialist catalog above the 28.8 GB headroom limit | "and names the largest general-purpose collection that fits comfortably in your Mac's memory, leaving headroom for everything else the machine is doing. Specialist collections such as Viral are never recommended this way." |
| "Kraken 2 loads the entire database into RAM before it classifies a single read" | true | `MetagenomicsModels.swift:116-119` documents the memory-mapping fallback for exactly this reason; `ClassificationWizardSheet.swift:291-297` auto-enables it when the database exceeds RAM | |
| "any collection asking for more memory than you have is labelled \"(exceeds system RAM)\" inline" | true | `PluginManagerView.swift:1076-1079` renders that exact string when `exceedsSystemRAM` | |
| "Click **Download** on **Viral**" | true | `PluginManagerView.swift:1243-1249` renders a Download button for any row not `.ready` | |
| "It is the smallest at about 0.5 GB" | true | `MetagenomicsModels.swift:110`, `:128`; `conda db list` prints 0.5 GB | |
| "either **Standard-8** or **Standard-16** ... Both are capped databases" | true | `MetagenomicsModels.swift:136-139` `contentsDescription` reads "Same as Standard, capped at 8 GB" / "capped at 16 GB" | |
| "The row turns to read **Installed** when the download and unpack finish" | true | `PluginManagerView.swift:1213-1217` renders `Text("Installed")` when `database.status == .ready` | |
| "it then reports the version, the install date, and whether a newer pinned build exists" | true | `PluginManagerViewModel.swift:974-991` `databaseTrackingSummary` joins "Installed \<date\>", "Version \<v\>", and either "Update available: \<v\>" or "Up to date" | |
| "`lungfish-cli conda db list`" and "`lungfish-cli conda db recommend` prints the recommendation the banner shows" | true | `cli-help/conda.txt` `==== conda db list ====` and `==== conda db recommend ====`; both rerun live, and `recommend` returned the same PlusPF-16 the banner logic selects | |
| "Open **Tools > Classification > Kraken2...**" | true | `ToolsMenuModel.swift:73` names the category "Classification"; `FASTQOperationDialogState.swift:2070` files `.kraken2` under `.classification`; `MainMenu.swift:805-812` builds `"Kraken2…"`. Matches CONSISTENCY.md and the reality map's part-wide finding | |
| "Classification is a submenu holding one item per classifier, so Kraken2, EsViritu, and TaxTriage are three separate menu items" | true | `FASTQOperationDialogState.swift:2070` and `:1994-1996`. The ground-truth map's workflow-divider row was struck on 2026-09-07, so the submenu holds exactly these three items and no divider | |
| "Picking Kraken2 opens the FASTQ/FASTA Operations dialog with Kraken 2 already selected. That is the title of the dialog window rather than a menu" | true | `FASTQOperationDialogState.swift:1250-1252` `dialogTitle` returns "FASTQ/FASTA Operations"; `MainMenu.swift:809` sets `representedObject = toolID` so the menu item selects the tool | |
| "The dialog's tool sidebar lists EsViritu and TaxTriage beside Kraken2" | true | `FASTQOperationDialog.swift:30-43` renders the sidebar from `state.sidebarItems` | |
| "Read the dataset line at the top of the dialog, which names whatever bundle was selected" | true | `FASTQOperationDialogState.swift:1119-1128` `datasetLabel` | |
| "LGE groups the selected bundles into samples and detects for each sample whether it holds one read file or a mated pair" | true | `ClassificationWizardSheet.swift:80-82` and `:180-183` use `MetagenomicsSampleGrouper.group(inputFiles)`; `performRun` maps each sample's `isPairedEnd` into its config | |
| "Open the **Database** picker. It lists only the collections that finished downloading, each with its size on disk beside the name" | true | `ClassificationWizardSheet.swift:456-470` iterates `readyDatabases` (`:177-179`, filtered to `.ready`) and renders `formatSize(db.sizeBytes)` beside each name | |
| "If no database is installed the picker is replaced by the words \"No databases installed.\" and a **Download Database...** button that opens the Plugin Manager straight to its Databases tab" | true | `ClassificationWizardSheet.swift:442-455`, including `PluginManagerWindowController.show(tab: .databases)` | |
| "Leave **Sensitivity** on **Balanced**" | true | `ClassificationWizardSheet.swift:74` `preset = .balanced`; `:521-538` renders the three-way segmented picker | |
| "every number in there already carries the value the preset chose" | true | `ClassificationWizardSheet.swift:296-298` and `:621-625` `applyPreset` writes `confidence` and `minimumHitGroups` on every preset change | |
| "the dialog shows a **Run Mode** control fixed on \"Run separately per bundle\" and explains why it is locked" | true | `ClassificationWizardSheet.swift:100-113` `classificationMultiBundleRunPolicy` with `allowedModes: [.perBundle]` and a lockReason; `:406-410` places the picker inside `sampleOverviewSection`, which `:383` renders only when `isBatchMode` | |
| "The selection runs as one classification batch that registers a single entry in the Operations Panel and writes one merged summary, and each sample is still classified separately inside that batch" | true | This is the lockReason verbatim in substance (`ClassificationWizardSheet.swift:110-112`); `AppDelegate+Classification.swift:1385-1386` registers one `OperationCenter.shared.start` for the batch | |
| "Click **Run**." | true | `FASTQOperationDialog.swift:20` `primaryActionTitle: String = "Run"`; the standalone footer's `:387` button is also titled "Run" | |
| "you open with **Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `MainMenu.swift:866-872` | |
| "The row is titled `Classifying SRR36291587`, naming the file rather than the tool" | false | The dialog always emits `goal: .profile` (`ClassificationWizardSheet.swift:664-668` `makeProfileConfig`), and `AppDelegate+Classification.swift:852-858` maps `.profile` to the goalLabel **"Profiling"**, not "Classifying". "Classifying" is reachable only from a `.classify` config, which the dialog never builds. The title also uses `inputFiles.first?.lastPathComponent`, so it carries the file extension | "The row is titled `Profiling SRR36291587_1.fastq`, naming the file rather than the tool, because a run started from the dialog always classifies and then profiles with Bracken." |
| "a multi-sample run is titled `Classification Batch (N samples)` instead" | true | `AppDelegate+Classification.swift:1385-1386` | |
| "the Viral database finished in 2.6 seconds and Standard-16 in 11.3 seconds against these 85,199 read pairs" | true | `run-viral/classification-result.json` runtime 2.620663, `run-standard16/classification-result.json` runtime 11.327877; input holds 85,199 pairs | |
| "both figures are for a database already sitting in the operating system's file cache, so a first run after a restart is slower" | true | Correctly hedged rather than asserted as a measured cold figure. The author's report states the same | |
| "It is a folder named `kraken2-<timestamp>` under the project's `Analyses` folder" | true | `AppDelegate+Classification.swift:842-845`; CONSISTENCY.md's Folders and files section | |
| "Every classification run gets its own timestamped folder, so a second run never overwrites the first" | true | `AnalysesFolder.createAnalysisDirectory` per CONSISTENCY.md, whose `knownTools` list names kraken2 | |
| "Right-click the taxon's row in the table, or its wedge in the sunburst, and choose **Extract Reads...**" | true | `TaxonomyViewController.swift:1303-1311` adds "Extract Reads…" as the first item of `buildTaxonContextMenu`, which serves both the table and the sunburst | |
| "The action bar's **Extract FASTQ** button does the same thing for whatever is selected" | true | `ClassifierActionBar.swift:49-51` titles the button "Extract FASTQ"; `TaxonomyViewController.swift:968-970` routes `onExtractFASTQ` to the same `presentUnifiedExtractionDialog` | |
| "leave the **Format** control on FASTQ, leave the **Destination** control on Save as Bundle, and check the **Name** field, which arrives pre-filled from the taxon and the run" | true | `ClassifierExtractionDialog.swift:161-174` (Format, default FASTQ), `:208-234` (four destinations, default `.bundle`), `:236-247` (Name field, shown for bundle and file), `:108` takes a `suggestedName` | |
| "Each of those three labels carries a trailing colon on screen" | true | `ClassifierExtractionDialog.swift:162` "Format:", `:209` "Destination:", `:239` "Name:" | |
| "Then run the extraction." | true | Deliberately vague, and correctly so, because the primary button is destination-aware. `ClassifierExtractionDialog.swift:33-40` titles it "Create Bundle" for Save as Bundle, "Save", "Copy", or "Share" for the others, so naming a single button here would have been wrong | |
| "The new bundle appears under the project's top-level `Extractions` folder" | true | `ClassifierReadResolver.swift:73-82` `extractionsFolderName = "Extractions"` with a comment saying extractions are derived data and never sequence imports; matches CONSISTENCY.md | |
| "holding the reads assigned to that taxon and to everything beneath it in the hierarchy" | true | `ClassifierReadResolver.swift:40` and `:681` pass `includeChildren: true` unconditionally for Kraken 2 | |
| "extracting under *Severe acute respiratory syndrome coronavirus 2* from the Viral result produced 83,591 read pairs" | true | `run-viral/classification.kreport` gives 83,591 clade and direct at taxid 2697049, and `sars-reads.fastq` holds 167,182 records, which is exactly two per pair | |
| "The extraction dialog for the alignment-backed classifiers carries an extra \"Include unmapped mates of mapped pairs\" checkbox, which is hidden here because Kraken 2 produces no alignment" | true | `ClassifierExtractionDialog.swift:180-182` renders it only when `model.showsUnmappedMatesToggle`; `cli-help/extract.txt` documents `--include-unmapped-mates` as "for --by-classifier, non-kraken2" | |
| **Database.** "The default is the first installed database that finished downloading" | true | `ClassificationWizardSheet.swift:160-169` `databaseSelectionAfterRefresh` returns `readyDatabases.first?.name`. Matches the registry entry | |
| **Sensitivity.** "Balanced, which uses confidence 0.20 with 2 hit groups, against Sensitive at 0.00 with 1 and Precise at 0.50 with 3" | true | `ClassificationConfig.swift:431-440` `parameters` returns exactly those three pairs | |
| **Run Mode.** "It is fixed on \"Run separately per bundle\" and cannot be changed" | true | `ClassificationWizardSheet.swift:104-107` `allowedModes: [.perBundle]` | |
| **Confidence:.** "The default is 0.20 ... and the slider runs from 0.00 to 1.00 in steps of 0.05" | true | `ClassificationWizardSheet.swift:118` (0.2), `:548-560` `InlineNumericSliderField(label: "Confidence:", in: 0...1, step: 0.05)` | |
| **Min hit groups:.** "The default is 2, and the stepper accepts 1 to 10" | true | `ClassificationWizardSheet.swift:119`, `:561-571` `Stepper(..., in: 1...10)` with label "Min hit groups:" | |
| **Threads:.** "The default is 4 and the stepper will not let you exceed your Mac's core count" | true | `ClassificationWizardSheet.swift:120` (4), `:572-585` `in: 1...ProcessInfo.processInfo.processorCount`. Note the CLI's own `--threads` default is "auto", not 4, but the chapter attributes 4 to the dialog, which is where it is right | |
| **Memory mapping:.** "The checkbox is off by default ... though the dialog ticks the box for you when you pick such a database, and its warning banner names both the gigabytes required and the gigabytes you have" | true | `ClassificationWizardSheet.swift:121` (false), `:291-297` auto-enable, `:250-257` `ramWarningText` interpolates both figures | |
| **Extra arguments:.** "It is empty by default ... an unclosed quote blocks the run with the dialog saying so" | true | `ClassificationWizardSheet.swift:122`, `:599-606`; `:629` `AdvancedCommandLineOptions.parse` failure blocks `performRun`, and `:352-356` surfaces `advancedArgumentsParseError` in the footer | |
| **Download.** "showing the download size, the memory the database needs, and a progress bar" | true | `PluginManagerView.swift:1065-1073` (size and RAM), `:1145-1158` (progress) | |
| **Remove.** "after a confirmation sheet naming the database" | true | `PluginManagerView.swift:834` confirmation text interpolates the name | |
| **Update.** "the two collections LGE builds on your own machine cannot be replaced in place, so they are reported as skipped" | true | `DbCommand.swift:401-402` says locally built indexes "are reported as skipped and are refreshed by reinstalling instead"; `third-party-tools-lock.json` has exactly two such entries, SILVA and Greengenes | |
| **Refresh.** "The list loads once when you open the tab, which is why it can go stale" | true | `PluginManagerView.swift:849-852` wires the button to `refreshDatabases()`; the list otherwise loads on tab appearance | |
| **Storage Settings....** "with the current folder and total space in use shown along the foot of the tab" | true | `PluginManagerView.swift:970-998` storageFooter shows `storageLocationPath` and `"Total: … used"` | |
| **Filter taxa….** "Hides every row whose taxon name, rank, or read count does not contain what you type, with a count beside the field reporting how many rows survive" | true | `TaxonomyTableView.swift:224-232` (placeholder "Filter taxa…"), `:489-499` `nodeMatchesFilter` also tests sample, Direct, Bracken and percent, so the chapter names a subset rather than the full set, and `:400-411` renders "N of M taxa". The narrowing is a simplification the registry entry shares, not a contradiction | |
| **Bracken.** "The column is hidden by default and appears on its own whenever the result carries Bracken numbers" | true | `TaxonomyTableView.swift:296-298` `brackenCol.isHidden = true`; `:61-64` `updateBrackenColumnVisibility()` runs on every `tree` set | |
| **Select All** and **Filter…** "which only appears at all for a result covering several samples" | true | `ClassifierSamplePickerView.swift` in `LungfishKit`; `TaxonomyTableView.swift:244-250` adds the Sample column only for multi-sample results | |
| **Column header filter.** "you set from that column's own header menu, and several column filters apply together" | true | `TaxonomyTableView.swift:141-151` `ColumnFilterSet`; `:429-431` requires every active column filter to pass alongside the free-text query | |
| **Destination:.** "that option is disabled above 10,000 reads with a tooltip telling you to pick another destination" | true | `TaxonomyReadExtractionAction.swift:94-95` `clipboardReadCap = 10_000`; `ClassifierExtractionDialog.swift:90-99` disables the row and supplies the tooltip | |
| **Name:.** "it cannot be left blank" | true | `ClassifierExtractionDialog.swift:280` disables the primary button when the trimmed name is empty | |
| "The table's columns are Sample, Taxon Name, Rank, Reads, Direct, Bracken, and a percent column" | true | `TaxonomyTableView.swift:244-307`, whose seventh column is titled "%" | |
| "**Reads** is the clade count ... **Direct** is only the reads assigned to that exact taxon and no lower" | true | `TaxonomyTableView.swift:277` and `:286` headerToolTips say exactly this | |
| Viral results table, all five rows and fifteen figures | true | Every cell matches `run-viral/classification.kreport` line for line, including Viruses 83,728/65/98.27, Coronaviridae 83,663/0/98.20, Betacoronavirus 83,662/0/98.20, *Betacoronavirus pandemicum* 83,645/54/98.18, and SARS-CoV-2 83,591/83,591/98.11. The table omits the intermediate ranks between them, which the lead-in ("one row per level from the top of the tree down to the species") signals | |
| "Kraken 2 reports 1,471 reads, or 1.73%, as unclassified" | true | `run-viral/classification.kreport` line 1 | |
| "on this run it reads 83,645 for *Betacoronavirus pandemicum*, identical to the Reads figure" | true | `run-viral/classification.bracken` gives `new_est_reads` 83,645 with `added_reads` 0 | |
| "A double-click re-centres the sunburst on that wedge ... Escape zooms out one level and Cmd-0 jumps straight back to the root" | true | `TaxonomySunburstView.swift:564-577` (double-click zoom), `:657-680` (Escape and Cmd-0) | |
| "The breadcrumb bar above the chart then shows the path back to the root, and clicking any earlier segment returns you there" | true | `TaxonomyBreadcrumbBar.swift:12-16` and `:131-133`; `TaxonomyViewController.swift:961-964` wires `onNavigateToNode` | |
| "Right-clicking a taxon offers Extract Reads..., Copy Taxon Name, Copy Taxonomy Path, Zoom to that taxon, Zoom Out to Root, a **Look Up on NCBI** submenu carrying NCBI Taxonomy, GenBank Sequences, PubMed Literature, and Genome Assemblies, and **BLAST Matching Reads...**" | true | `TaxonomyViewController.swift:1301-1414` builds exactly that menu in exactly that order | |
| "Right-clicking the chart background instead offers **Copy Chart as PNG**" | true | `TaxonomyViewController.swift:1282-1290`, the only item on the empty-space menu | |
| "**Export**, which writes the whole table as CSV or TSV in depth-first order with the columns Name, Rank, Reads (Clade), Reads (Direct), Clade %, and Direct %" | true | `TaxonomyViewController.swift:1602` sets exactly that header array; `:1610-1612` traverses `tree.allNodes()` depth-first. Visible metadata columns are appended after those six (`:1603-1605`), which the chapter does not mention but which are empty on a single-sample run | |
| "also offers **Copy Summary** for the plain-text summary" | true | `TaxonomyViewController.swift:1768-1774` | |
| "Beside it an information button opens the run's provenance, listing the tool version, the database and its version, the preset, the confidence, the runtime, and the input files" | false | `TaxonomyProvenanceView.swift:53-101` renders Tool, Database (name and path), Confidence, Hit Groups, Threads, Mem. Mapping, Runtime, Input, Bracken and Run ID. It shows **neither the database version nor the preset**. The file's own doc-comment at `:12` still promises both, which is where the chapter's wording came from, so the comment is stale and the chapter inherited it | "Beside it an information button opens the run's provenance, listing the tool version, the database and where it sits on disk, the confidence and hit-group values, the thread count, whether memory mapping was used, the runtime, and the input files." |
| "Two further buttons toggle side drawers, Collections for taxa you have set aside and BLAST Results" | true | `TaxonomyViewController.swift:163-188` defines both with those titles | |
| Comparison table, all eight Viral and Standard-16 figures | true | Viral 83,728 (98.27%) / 1,471 (1.73%) / 83,591 / 1 species and Standard-16 3,320 (3.90%) / 81,879 (96.10%) / 2,602 / 1 species all match the two kreports. `awk` over `run-standard16/classification.kreport` returns exactly one S-rank row | |
| "Standard-16 is a capped database, squeezed from a seventy-gigabyte collection down to sixteen" | true | `MetagenomicsModels.swift:104` Standard 67 GB, `:106` Standard-16 16 GB, `:138` "Same as Standard, capped at 16 GB". "Seventy-gigabyte" is a rounding of 67 rather than an error | |
| "what survives is spread thinly across archaea, bacteria, viruses, plasmids, the human genome, and vector sequence" | true | `MetagenomicsModels.swift:137` Standard's contents are "Archaea, bacteria, viral, plasmid, human, UniVec"; UniVec is vector sequence | |
| "No human reads were reported by Standard-16, even though it contains the human genome" | true | Grepping `run-standard16/classification.kreport` for Homo, sapiens, Chordata and Eukaryota returns nothing | |
| Preset table, all nine figures | true | Sensitive 85,181 (99.98%) / 18 (0.02%) / 5 species, Balanced 83,728 (98.27%) / 1,471 (1.73%) / 1, Precise 78,731 (92.41%) / 6,468 (7.59%) / 1 all match `run-sensitive`, `run-viral` and `run-precise`. The sensitive kreport carries exactly five S-rank rows | |
| "One is *Sinsheimervirus phiX174* with 5 reads" | true | `run-sensitive/classification.kreport` gives clade 5 at that species, with its child Escherichia phage phiX174 holding all five directly | |
| "The other three are one read of a Vibrio phage, one of a frog adenovirus, and one of a picorna-like virus" | false | The Vibrio phage hit is **two** reads, not one. `run-sensitive/classification.kreport` gives Valbvirus ValB1MD2 clade 2 with Vibrio phage ValB1MD-2 holding both. The author's own report records "(2 reads)", so the chapter lost the figure in the rewrite. The frog and picorna-like hits are one read each and are correct | "The other three are two reads of a Vibrio phage, one of a frog adenovirus, and one of a picorna-like virus" |
| "Precise threw away about 5,000 reads that Balanced was willing to name, and named nothing new for it" | true | 83,728 minus 78,731 is 4,997, and the precise kreport carries the same single species | |
| "the Viral database left 1.73% unclassified ... The Standard-16 run left 96.10% unclassified" | true | Both kreports' first lines | |
| "as Coronaviridae does here at 98.20%" | true | `run-viral/classification.kreport`, family row | |
| "The classification subcommand sits under `conda`" | true | `cli-help/conda.txt` `==== conda classify ====` | |
| "`--paired` treats the two files as the two mates ... `--db` names the database, and `--profile` runs Bracken afterwards" | true | `cli-help/conda.txt` `==== conda classify ====` documents all three with those meanings | |
| "the dialog always runs Bracken and the command line does not, so a command without `--profile` gives you a classification with no abundance re-estimation" | true | `ClassificationWizardSheet.swift:664` hard-codes `goal: .profile`; `--profile` is an opt-in flag on the CLI | |
| "The command writes `classification.kreport`, a compressed per-read `classification.kraken.gz`, and `classification.bracken` into the output directory, alongside a provenance sidecar" | true | `run-standard16/` holds all three plus `.lungfish-provenance.json`. It also holds `classification.bracken.kreport`, `classification-result.json` and a `.idx.sqlite`, which the chapter does not list, but nothing it does list is absent | |
| "The `.kreport` is the kreport file, the six-column summary the viewport reads" | false | Every kreport LGE writes has **eight** columns, because `ClassificationConfig.swift:402` appends `--report-minimizer-data` unconditionally, which inserts two k-mer columns. `awk -F'\t' '{print NF}'` over all five run kreports returns 8 on every line. `KreportParser.swift:31` documents both shapes and `:204` parses both, but the six-column form is what other tools produce, never LGE. (`GLOSSARY.md:265` carries the same error and needs the same fix, which belongs to the Bioinformatics Educator.) | "The `.kreport` is the kreport file, the per-taxon summary the viewport reads. Kraken 2 writes six columns by default, and LGE always asks for two extra k-mer columns, so a report LGE produced holds eight." |
| "`--preset sensitive|balanced|precise` ... `--confidence` and `--min-hit-groups` ... `--threads` ... `--memory-mapping` ... `--extra-args`" | true | All five appear in `cli-help/conda.txt` `==== conda classify ====` with those meanings | |
| "`--quick` stops examining a read as soon as one taxon matches" | true | Same banner, "Use Kraken2 quick mode" | |
| "`--recursive` picks up eligible FASTQ or FASTA files inside subfolders when an input is a folder" | true | Same banner, verbatim in substance | |
| "`--bracken-read-length`, `--bracken-level`, and `--bracken-threshold` ... defaulting to 150, automatic for the selected database, and 10 respectively, which are the values the dialog always uses" | true | Same banner for the three defaults; `ClassificationWizardSheet.swift:684` passes `.automaticDefault`, and `run-viral/classification-result.json` records `readLength: 150`, `threshold: 10`, `source: "catalogIdentity"` | |
| "the run stops with an error reading `Empty Kraken2 report` and exits with status 64, rather than reporting a result that is 100% unclassified" | true | Reproduced live against SILVA. Exit 64, stderr `Error: Workflow execution failed: Empty Kraken2 report`, and the written report holds one line reading `100.00 85199 85199 0 0 U 0 unclassified` | |
| "The reference run reproduced this by classifying these viral amplicon reads against the SILVA ribosomal database, which holds no viruses" | true | `third-party-tools-lock.json` describes SILVA as built from the SILVA rRNA reference collection | |
| "`list` prints every catalogued database with size, memory, install state, and update status" | true | Rerun live; the table's columns are Name, Status, Size, RAM, Update, Description | |
| "`update` replaces installed databases with their pinned versions and requires `--yes`, either for one name or with `--all`" | true | `cli-help/conda.txt` `==== conda db update ====`, "Either way --yes is required" | |
| "`remove <name>` drops a database, and `--delete-files` erases the index from disk" | true | Same file, `==== conda db remove ====` | |
| "A separate `conda db install-managed` handles the helper datasets used for host and ribosomal read removal rather than for classification, and `conda db install-managed --list` prints their identifiers" | true | `cli-help/conda.txt` `==== conda db install-managed ====`; the manifest's three managed entries are human-scrubber, deacon-panhuman and deacon-ribokmers, which are exactly host and ribosomal removal | |
| "Extracting a taxon's reads is its own command, which takes the result directory rather than a single file" | true | Confirmed by reproducing the failure. Passing `classification.kraken.gz` to `--result` exits non-zero with "No reads could be extracted" | |
| "`--taxon` takes the numeric taxonomy identifier, which the viewport's Copy Taxonomy Path puts on your clipboard" | false | `TaxonomyViewController.swift:1434-1443` `contextCopyPath` copies the chain of taxon **names** joined by " > ", with the root filtered out. `contextCopyName` at `:1427-1432` copies the name alone. Neither copies the numeric identifier, and no viewport control does | "`--taxon` takes the numeric taxonomy identifier, which the kreport's seventh column holds. The viewport's Copy Taxonomy Path gives you the chain of names rather than the number." |
| "which the kreport's fifth column holds" | false | The taxonomy identifier sits in the **seventh** column of an LGE-written kreport. On the SARS-CoV-2 row, column 5 is 9121 (distinct minimizers) and column 7 is 2697049. Column 5 holds the taxid only in the six-column form LGE never writes | (folded into the correction above) |
| "`--read-format fastq|fasta` chooses the output format, matching the dialog's Format picker" | true | `cli-help/extract.txt` `==== extract reads ====`, "Output read format: fastq or fasta … default fastq" | |
| "The `--include-unmapped-mates` flag exists for the alignment-backed classifiers and is rejected with `--tool kraken2`" | true | Same banner, "for --by-classifier, non-kraken2" | |
| "On the reference run this command extracted 83,591 pairs, written as 167,182 read records" | true | `wc -l sars-reads.fastq` / 4 = 167,182, which is exactly twice 83,591 | |
| "`lungfish-cli import kraken2 <kreport-file>` brings a Kraken 2 report generated elsewhere into a project" | true | `cli-help/import.txt` `==== import kraken2 ====` takes `<kreport-file>` | |
| "`lungfish-cli build-db kraken2 <result-dir>` builds a SQLite index over an existing Kraken 2 result directory ... taking `--force` ... `--no-cleanup` ... and `--sample-dir`" | true | `cli-help/build-db.txt` `==== build-db kraken2 ====` with all three options and the `<result-dir>` argument | |
| "That second command builds an index of a result, not a Kraken 2 classification database, and LGE offers no route to build one of those at all" | true | The catalog is a closed nine-collection enum (`MetagenomicsModels.swift:75-84`) plus two locally built rRNA indexes, and no code path builds a user-defined Kraken 2 database. Resolves DRIFT changed 63 | |
| "the finished database can then be pointed at from the Databases tab's storage location" | unverifiable | `PluginManagerView.swift:984-989` opens a storage-location setting, but nothing in the source shows that dropping a hand-built Kraken 2 index into that folder gets it registered and offered in the dialog's Database picker. The registry's `availableDatabases()` reads its own manifest, so an unregistered folder would have to be discovered by a scan I could not find. Settling it needs a live test in the Preview app with a hand-built index placed in the storage folder | |

## Front matter

`parameters_refs` is `[classify.kraken2, classify.install-database,
classify.taxonomy-browser, classify.extract-reads-by-taxon]`, which matches
roster row 33 at DRIFT.md:3759 exactly, in the same order.

All six `<!-- SHOT -->` markers in the body have a front-matter entry with a
caption, and all six front-matter ids appear as markers. No orphans either way.
Two caption details are worth the screenshot author's attention. The
`kraken2-taxonomy-viewport` caption places the breadcrumb bar "above it",
meaning the sunburst, but `TaxonomyViewController.swift:867-870` spans the bar
across the whole window above both panes. The `kraken2-databases-tab` caption
says the Kraken 2 rows show "which collections are installed", which will
include the SILVA and Greengenes rows the body's nine-collection sentence
overlooks.

All 22 `glossary_refs` anchors resolve against `GLOSSARY.md`, including the
five the author added (`#bracken`, `#capped-database`, `#clade-count`,
`#kreport`, `#spike-in-control`). One caveat on `#kreport`, whose text repeats
the six-column error corrected above.

## Settings coverage

All 22 settings across the four registry entries have a Settings paragraph, and
every label matches `parameters.yaml` character for character, colons included
(`Confidence:`, `Min hit groups:`, `Threads:`, `Memory mapping:`,
`Extra arguments:`, `Format:`, `Destination:`, `Name:`, `Filter taxa…`,
`Filter…`, `Storage Settings...`). Every default and allowed-value statement
matches both the registry and the source. Nothing is missing and nothing extra
is documented as a setting.

## The author's three defect claims

**Defect 1, the all-unclassified run, is confirmed and the diagnosis is right.**
I reran the SILVA case and got exit 64 with `Error: Workflow execution failed:
Empty Kraken2 report` against a report holding one well-formed line. The
mechanism is `KreportParser.parse(text:)`: at `KreportParser.swift:150-152` a
row whose rank is `.unclassified` is assigned to `unclassifiedLine` and
deliberately kept out of `parsedNodes`, so the guard at `:158-160` finds
`parsedNodes` empty and throws `.emptyReport`, whose message string is at `:39`.
The author cited `:39`, which is the message rather than the throw. The throw is
`:159`. The judgement that this misdescribes the file and turns a legitimate
result into a workflow failure is sound, and `.missingRootNode` at `:170` would
indeed have been the accurate error of the two that already exist.

**Defect 2, the deprecated `conda extract`, is confirmed.**
`CondaExtractCommand.swift:76-77` defines a deprecation warning written to
stderr on every invocation (`:104`), directing users to `extract reads
--by-classifier --tool kraken2`. `parameters.yaml` still names `CLI:
lungfish-cli conda extract …` as an entry point for
`classify.extract-reads-by-taxon` and still documents `--taxid`,
`--kraken-output`, `--kreport`, `--include-children` and `--no-read-pairs` as
its `cli_only` flags. The chapter documents the recommended form, which is the
right call, so the divergence is the registry's to fix. Note the deprecation
does not appear in `conda extract --help`, only at runtime, which is why the
cli-help dump does not show it.

**Defect 3, the misleading `--result` message, is confirmed.** Passing
`classification.kraken.gz` produced `Error: No reads could be extracted: 1
sample(s) were skipped because their classification output or source FASTQ could
not be located (sample).` The message blames a missing file when the real fault
is a file supplied where a directory was wanted. Minor, and correctly ranked as
such.

## Notes for the chapter author

The nine false claims fall into three groups. Two are transcription slips from
the author's own measurements (the 86,281 pair count, the Vibrio phage read
count) and are one-word fixes. Three come from trusting a stale doc-comment or a
generic description of a format (the provenance popover's preset and database
version, the six-column kreport, the fifth-column taxid). Four are genuine
misreadings of the app (the row title, the nine-collection count, the
recommendation rule, and Copy Taxonomy Path). The row-title error is the one a
reader will hit first, because they will watch the Operations Panel for a row
that says "Classifying" and see "Profiling" instead.

Two errors escape this chapter. `01-foundations/07-plugin-packs.md:153` repeats
the nine-Kraken-2-collections undercount, and `GLOSSARY.md:265` repeats the
six-column kreport. Both files belong to other roles.

Verdict counts: 104 true, 9 false, 2 unverifiable.
