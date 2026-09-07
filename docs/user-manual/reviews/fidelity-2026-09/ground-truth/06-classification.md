# Reality map: 06-classification

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift`
- `Sources/LungfishApp/App/AppDelegate+Classification.swift`
- `Sources/LungfishApp/App/ToolsMenuModel.swift`
- `Sources/LungfishApp/Services/WorkflowLibrary.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialog.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
- `Sources/LungfishApp/Views/Metagenomics/ClassificationWizardSheet.swift`
- `Sources/LungfishApp/Views/Metagenomics/EsVirituWizardSheet.swift`
- `Sources/LungfishApp/Views/Metagenomics/TaxTriageWizardSheet.swift`
- `Sources/LungfishApp/Views/Metagenomics/UnifiedMetagenomicsWizard.swift`
- `Sources/LungfishApp/Views/Metagenomics/TaxonomyViewController.swift`
- `Sources/LungfishApp/Views/Metagenomics/TaxonomyTableView.swift`
- `Sources/LungfishApp/Views/Metagenomics/TaxonomySunburstView.swift`
- `Sources/LungfishApp/Views/Metagenomics/TaxonomyReadExtractionAction.swift`
- `Sources/LungfishApp/Views/Metagenomics/ClassifierExtractionDialog.swift`
- `Sources/LungfishApp/Views/Metagenomics/NaoMgsImportSheet.swift`
- `Sources/LungfishApp/Views/Metagenomics/NvdImportSheet.swift`
- `Sources/LungfishApp/Views/Metagenomics/CzIdImportSheet.swift`
- `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift`
- `Sources/LungfishApp/Views/Inspector/InspectorView.swift`
- `Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift`
- `Sources/LungfishApp/Views/Viewer/ViewerViewController+EsViritu.swift`
- `Sources/LungfishApp/Views/Viewer/ViewerViewController+Nvd.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift`
- `Sources/LungfishKit/BlastConfigPopoverView.swift`
- `Sources/LungfishKit/BlastResultsDrawerTab.swift`
- `Sources/LungfishKit/ClassifierActionBar.swift`
- `Sources/LungfishKit/FASTASequenceActionMenuBuilder.swift`
- `Sources/LungfishCore/Services/Blast/BlastVerificationRequest.swift`
- `Sources/LungfishCore/Services/Blast/BlastService.swift`
- `Sources/LungfishWorkflow/Conda/PluginPack.swift`
- `Sources/LungfishWorkflow/Metagenomics/MetagenomicsModels.swift`
- `Sources/LungfishWorkflow/Metagenomics/MetagenomicsDatabaseInfo.swift`
- `Sources/LungfishWorkflow/Extraction/ClassifierReadResolver.swift`
- `Sources/LungfishWorkflow/TwelveS/TwelveSAmpliconMatchingWorkflow.swift`
- `Sources/LungfishWorkflow/TwelveS/TwelveSAbundanceReassigner.swift`
- `Sources/LungfishIO/Bundles/AnalysesFolder.swift`
- `Sources/LungfishIO/Formats/FASTQ/FASTQSampleMetadata.swift`
- `Sources/LungfishIO/Formats/NaoMgs/NaoMgsResultParser.swift`
- `Sources/LungfishNaoMgsUI/NaoMgsResultViewController.swift`
- `Sources/LungfishNvdUI/NvdResultViewController.swift`
- `Sources/LungfishEsVirituUI/EsVirituResultViewController.swift`
- `Sources/LungfishEsVirituUI/ViralDetectionTableView.swift`
- `Sources/LungfishTaxTriageUI/TaxTriageResultViewController.swift`
- `Sources/LungfishTaxTriageUI/BatchTaxTriageTableView.swift`
- `Sources/LungfishTaxTriageUI/TaxTriageBatchExporter.swift`
- `Sources/LungfishTaxTriageUI/TaxTriageBatchOverviewView.swift`
- `Sources/LungfishTaxTriageUI/StrainComparisonView.swift`
- `Sources/LungfishTwelveSUI/TwelveSAmpliconResultViewController.swift`
- `Sources/LungfishTwelveSUI/TwelveSTargetTableView.swift`
- `Sources/LungfishTwelveSUI/TwelveSAmpliconResultExportService.swift`
- `Sources/LungfishCLI/Commands/FastqTwelveSMatchSubcommand.swift`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/conda.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/esviritu.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/taxtriage.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/blast.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/freyja.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/nao-mgs.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/nvd.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/cz-id.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/import.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/build-db.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/extract.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`
- `docs/user-manual/features.yaml` (partial index, itself stale on entry points)

## Part-wide finding that drives many verdicts

The Tools menu no longer carries a `FASTQ/FASTA Operations` submenu. `MainMenu.swift:700-706` builds the Tools menu from `ToolsMenuModel.build()`, which emits one submenu per `FASTQOperationCategoryID`. `ToolsMenuModel.swift:73` names the classification category "Classification", and `MainMenu.swift:786-819` builds each category submenu from the operation tool ids in that category. `FASTQOperationDialogState.swift:2070` puts `.kraken2`, `.esViritu`, and `.taxTriage` in `.classification`, and `FASTQOperationDialogState.swift:1994-1996` gives them the titles "Kraken2", "EsViritu", and "TaxTriage". So the live path for every runnable classifier is `Tools > Classification > Kraken2…` (or `> EsViritu…`, or `> TaxTriage…`), three separate menu items, not one `Classification…` item. "FASTQ/FASTA Operations" survives only as the dialog title (`FASTQOperationDialogState.swift:1250-1252`). Every chapter that writes the old path is wrong in the same way, and the corrected wording is given per row below.

The second part-wide finding is that no classification result is written next to its source FASTQ. `AppDelegate+Classification.swift:842-845` redirects the Kraken2 output directory to `AnalysesFolder.createAnalysisDirectory(tool: "kraken2", in: projectURL)`, and `AnalysesFolder.swift:132-141` names that directory `Analyses/kraken2-<timestamp>/` (or `kraken2-batch-<timestamp>/`). Only the CZ-ID importer writes a `.lungfishtax` bundle, and it writes it under `Classifications/` (`AppDelegate+ToolsMenu.swift:860-867`).

## 01-what-is-classification.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Open the run wizard at `Tools > FASTQ/FASTA Operations > Classification…` and let it pick the right database." | false | `MainMenu.swift:700-706`, `MainMenu.swift:786-819`, `ToolsMenuModel.swift:73`, `FASTQOperationDialogState.swift:2070` | "Open the classifier you want from `Tools > Classification`, which lists Kraken2, EsViritu, and TaxTriage as three separate items." |
| 2 | "Lungfish runs three classifiers you launch inside the app on a FASTQ bundle: Kraken2 for a broad survey, EsViritu for viral strain calling, and TaxTriage for clinical-surveillance triage." | true | `FASTQOperationDialogState.swift:2070` lists exactly `.kraken2`, `.esViritu`, `.taxTriage` under `.classification` | |
| 3 | "It also imports results produced by tools you ran elsewhere: CZ-ID, NAO-MGS, and NVD (Novel Virus Diagnostics)." | true | `ImportCenterViewModel.swift:413-508` defines cards for NAO-MGS, NVD, and CZ-ID under `tab: .classificationResults` | |
| 4 | "Results produced by Kraken2, EsViritu, or TaxTriage outside Lungfish can also be imported through the Import Center" | true | `ImportCenterViewModel.swift:424-486` defines Kraken2 Results, EsViritu Results, and TaxTriage Results cards on the same tab | |
| 5 | "NAO-MGS is a wastewater metagenomic surveillance pipeline from SecureBio" | true | `NaoMgsResultParser.swift:319` names `https://github.com/securebio/nao-mgs-workflow` | |
| 6 | "In the app, use `Tools > Plugin Manager…` to install or verify the `wastewater-surveillance` pack." | true | `MainMenu.swift:773-780` adds "Plugin Manager…"; `AppDelegate+ToolsMenu.swift:146-148` shows the Plugin Manager at `packID: "wastewater-surveillance"`; `PluginPack.swift:833` defines that pack | |
| 7 | "On the CLI, `lungfish freyja demix` writes a command plan and provenance by default, and `--execute` runs Freyja when the pack is installed." | true | `cli-help/freyja.txt`, banner `==== freyja demix ====`, options `--execute` and `--dry-run` | |
| 8 | "Kraken2 and imported CZ-ID results open the sunburst taxonomy viewport described below." | true | `features.yaml:661` and `ImportCenterViewModel.swift:500-508` route CZ-ID to the taxonomy result viewer; `TaxonomyViewController.swift` hosts the sunburst | |
| 9 | "The innermost ring is the root of life; each successive ring is a finer rank (domain, phylum, class, order, family, genus, species)." | true | `TaxonomySunburstView.swift:20-25` documents ring-per-rank rendering from the root | |
| 10 | "Each row is one taxon, with columns for rank, name, read count, and percent of classified reads." | changed | `TaxonomyTableView.swift:244-307` defines Sample, Taxon Name, Rank, Reads, Direct, Bracken, and % | "Each row is one taxon, with columns for Sample, Taxon Name, Rank, Reads (the clade count), Direct (reads assigned exactly to that taxon), and % of classified reads. A Bracken column joins them when Bracken abundance estimation ran." |
| 11 | "Sort by read count to find the dominant taxa, or filter by rank to see, for example, only species-level calls." | true | `TaxonomyTableView.swift:274-303` sets sort descriptor prototypes; `TaxonomyTableView.swift:141` documents per-column header filters | |
| 12 | "Instead, Lungfish installs each classifier and its default database on demand through the Plugin Manager, reached from `Tools > Plugin Manager…` (Cmd-Shift-B)." | true | `MainMenu.swift:773-780` sets `keyEquivalent: "b"` with `[.command, .shift]` | |
| 13 | "The install runs `micromamba` against the bioconda channel for the tool itself" | true | `cli-help/conda.txt`, banner `==== conda ====`, "Install bioinformatics tools from bioconda and conda-forge using micromamba" | |
| 14 | "After install, the wizard runs Kraken2 and EsViritu directly. TaxTriage additionally needs a container runtime" | true | `TaxTriageWizardSheet.swift:108-110`, `:302-304` gate the run on `containerAvailable` | |
| 15 | "Open it from `Tools > FASTQ/FASTA Operations > Classification…`. This is a single menu item, not a submenu: there is no `Classification > Kraken2` or `Classification > EsViritu` path." | false | `MainMenu.swift:786-819` builds `Classification` as a submenu whose items are `Kraken2…`, `EsViritu…`, and `TaxTriage…` | "Open it from `Tools > Classification`. That is a submenu, and it lists the three runnable classifiers as separate items, so `Tools > Classification > Kraken2…` opens the dialog with Kraken2 already selected." |
| 16 | "The wizard opens with a tool picker showing the three runnable classifiers (Kraken2 in blue, EsViritu in green, TaxTriage in purple…)" | changed | `FASTQOperationDialog.swift:30-43` passes `state.sidebarItems` to `DatasetOperationsDialog`; `FASTQOperationDialogState.swift:1144-1148` builds that list from the selected category. The dialog opens on the tool you chose in the menu. No color assignment for these three tools was found in the wizard source. | "The dialog opens on the classifier you picked in the menu, with a sidebar listing the other classifiers in the Classification category so you can switch without reopening the menu." |
| 17 | "the FASTQ input, and the database selector" | true | `FASTQOperationDialog.swift:34` passes `state.datasetLabel`; `ClassificationWizardSheet.swift:434-472` renders the Database picker | |
| 18 | "The import-only tools (CZ-ID, NAO-MGS, NVD) are not in this wizard; you reach them from the Import Center instead." | true | `FASTQOperationDialogState.swift:2070` omits them; `ImportCenterViewModel.swift:413-508` places them on the Import Center's Classification Results tab | |
| 19 | "The Run button always says 'Run'." | true | `FASTQOperationDialog.swift:20` defaults `primaryActionTitle` to "Run" | |
| 20 | "the Operations Panel logs the run, and the result appears as a new track on the source FASTQ bundle when it completes" | false | `AppDelegate+Classification.swift:842-845` writes the result into `Analyses/kraken2-<timestamp>/` via `AnalysesFolder.createAnalysisDirectory`; `AnalysesFolder.swift:132-141` | "the Operations Panel logs the run, and the result appears in the project's `Analyses` folder as its own timestamped analysis directory when it completes" |
| 21 | "Lungfish keeps each classification result as its own track on the FASTQ bundle, so you can have a Kraken2 result and an EsViritu result side by side" | false | `AnalysesFolder.swift:132-141` creates one directory per run, named `<tool>-<timestamp>` | "Lungfish writes each classification run into its own timestamped folder under `Analyses`, so a Kraken2 result and an EsViritu result sit side by side without overwriting each other." |
| 22 | "A standard Kraken2 database covers bacteria, archaea, viruses, fungi, and the human genome" | changed | `MetagenomicsModels.swift:137-138` gives the Standard contents as "Archaea, bacteria, viral, plasmid, human, UniVec"; fungi are in PlusPF only (`:143-144`) | "A standard Kraken2 database covers archaea, bacteria, viruses, plasmids, the human genome, and UniVec. Fungi and protozoa arrive with the PlusPF builds." |
| 23 | "TaxTriage runs a Nextflow pipeline that combines classifiers and ranks each organism by a confidence score" | true | `cli-help/taxtriage.txt`, banner `==== taxtriage ====`, "Execute the TaxTriage Nextflow pipeline (jhuapl-bio/taxtriage) … with confidence scoring" | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Classification category submenu also carries the workflow-library entries for the category, drawn separately below a divider | `MainMenu.swift:794-798` |
| Six cards on the Import Center's Classification Results tab, not three: Kraken2, EsViritu, TaxTriage, NAO-MGS, NVD, CZ-ID | `ImportCenterViewModel.swift:413-508` |
| 12S Amplicon Matching is filed under the Genotyping category, not Classification, and is a specialized workflow that must be enabled first | `WorkflowLibrary.swift:141-149` (`categoryID: .genotyping`, `maturity: .specialized`) |
| The Kraken 2 catalog has nine collections including MinusB and EuPathDB46, plus two locally built special databases (SILVA, Greengenes) | `MetagenomicsModels.swift:75-84`; `third-party-tools-lock.json` databases section |
| Every classification run registers an OperationCenter entry titled "Classifying <file>" or "Classification Batch (N samples)" | `AppDelegate+Classification.swift:851-858`, `:1385-1386` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `classification-wizard-tool-picker` (planned) | No | Its caption says "The Classification wizard with its three runnable tools visible". The live surface is the shared FASTQ/FASTA Operations dialog opened from `Tools > Classification > Kraken2…`, with the other two classifiers in a sidebar. Recaption to name that dialog and the menu path that opens it. |
| `taxonomy-viewport-overview` (planned) | Yes, with a caption fix | The sunburst, per-taxon table, and breadcrumb bar all exist (`TaxonomyViewController.swift`, `TaxonomyTableView.swift`, `TaxonomyBreadcrumbBar.swift`). The caption should also name the "Filter taxa…" search field above the table (`TaxonomyTableView.swift:225-232`). |
| `<!-- planned: taxonomy-viewport-overview -->` marker | Yes | Sits in the viewport section, which is the right place. |
| `<!-- planned: classification-wizard-tool-picker -->` marker | Yes, once the surrounding text is corrected | Sits under "Where the wizard lives", which must be rewritten around the new menu path first. |
| `classification-question` illustration | Yes | The schematic is conceptual and does not depend on any menu path. |

## 02-running-kraken2.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish labels the tool 'Classify & Profile (Kraken2)'" | false | `FASTQOperationDialogState.swift:1994` returns "Kraken2" for `.kraken2`; that label appears nowhere in the source | "Lungfish labels the tool 'Kraken2' and describes it as 'Classify reads taxonomically', because it runs Kraken2 to assign the reads and then Bracken to estimate community abundance from those assignments." |
| 2 | "it runs Kraken2 to assign the reads and then Bracken to estimate community abundance from those assignments" | true | `PluginPack.swift:776` ships `kraken2` and `bracken` in the metagenomics pack; `cli-help/conda.txt` `==== conda classify ====` documents `--profile` as "Run Bracken abundance profiling after classification" | |
| 3 | "The result lands as a taxonomy bundle in the project and opens in the taxonomy viewport" | changed | `AppDelegate+Classification.swift:842-845` writes to `Analyses/kraken2-<timestamp>/`, not a bundle | "The result lands as a timestamped analysis folder under the project's `Analyses` folder and opens in the taxonomy viewport" |
| 4 | "a sunburst on the left, a sortable table on the right, and a breadcrumb bar naming the selected taxon" | true | `TaxonomyViewController.swift` composes the sunburst, `TaxonomyTableView`, and `TaxonomyBreadcrumbBar` | |
| 5 | "35 bases by default in Kraken2" | unverifiable | Kraken 2's own k default is not set or surfaced anywhere in the Lungfish source; the wizard and the CLI expose no `--kmer-len` for classification. Settling it needs the upstream Kraken 2 manual. | Attribute the number to Kraken 2 itself rather than to LGE, or drop it. |
| 6 | "| Viral | ~0.5 GB | 1 GB |" | changed | `MetagenomicsModels.swift:110` gives 536,870,912 bytes (0.5 GB) size and `:128` gives the same 0.5 GB as `approximateRAMBytes` | "| Viral | ~0.5 GB | 0.5 GB |" |
| 7 | "| Standard-8 | ~8 GB | 8 GB |" | true | `MetagenomicsModels.swift:105`, `:123` | |
| 8 | "| Standard-16 | ~16 GB | 16 GB |" | true | `MetagenomicsModels.swift:106`, `:124` | |
| 9 | "| Standard | ~67 GB | 67 GB | Archaea, bacteria, viruses, plasmid, human, UniVec |" | true | `MetagenomicsModels.swift:104`, `:122`, `:137-138` | |
| 10 | "| PlusPF-8 / PlusPF-16 | ~8-16 GB | 8-16 GB |" | true | `MetagenomicsModels.swift:108-109`, `:126-127` | |
| 11 | "| PlusPF | ~72 GB | 72 GB | Standard plus protozoa and fungi |" | true | `MetagenomicsModels.swift:107`, `:125`, `:143-144` | |
| 12 | "| Custom | varies | … | User-built from selected RefSeq taxa |" | false | `MetagenomicsModels.swift:75-84` has no `custom` case; the catalog is a closed nine-collection enum plus two `Kraken2SpecialDatabase` builds | Drop the Custom row and replace it with the two collections the table omits: "| MinusB | ~11 GB | 11 GB | Standard minus bacteria | You want the Standard breadth without the bacterial bulk |" and "| EuPathDB46 | ~34 GB | 34 GB | Eukaryotic pathogens (EuPathDB) | Your target is a eukaryotic parasite |". |
| 13 | "Lungfish can fall back to Kraken2 memory mapping where supported" | true | `ClassificationWizardSheet.swift:291-297` auto-enables `memoryMapping` when the database exceeds RAM | |
| 14 | "Open the Plugin Manager from `Tools > Plugin Manager…` (Cmd-Shift-B), find the Kraken2 row, and click **Install**" | true | `MainMenu.swift:773-780` | |
| 15 | "installs it under the Lungfish conda root at `~/.lungfish/conda`" | true | `cli-help/conda.txt`, banner `==== conda ====`, "Tools are stored in /Users/dho/.lungfish/conda" | |
| 16 | "From the CLI, run `lungfish conda db info Viral` … to see the local version, install date, available update, disk path, and RAM requirement." | true | `cli-help/conda.txt`, banner `==== conda db info ====`, "Show installed database version and update status", argument `<name>` | |
| 17 | "With a FASTQ bundle selected in the project sidebar, open `Tools > FASTQ/FASTA Operations > Classification…`. It is one menu item, not a submenu." | false | `MainMenu.swift:786-819`; `ToolsMenuModel.swift:73` | "With a FASTQ bundle selected in the project sidebar, open `Tools > Classification > Kraken2…`. Classification is a submenu, and picking Kraken2 there opens the FASTQ/FASTA Operations dialog with Kraken2 already selected." |
| 18 | "In the **Classifier** picker, choose **Kraken2**." | false | The dialog has no control labelled "Classifier". `FASTQOperationDialog.swift:30-43` renders a tool sidebar built from `state.sidebarItems` (`FASTQOperationDialogState.swift:1144-1148`), and the menu item already selects Kraken2. | "Kraken2 is already selected, because you chose it in the menu. The dialog's tool sidebar lists EsViritu and TaxTriage beside it if you want to switch." |
| 19 | "a **Sensitivity** preset picker (Sensitive, Balanced, or Precise; default Balanced)" | true | `ClassificationWizardSheet.swift:74` (`preset = .balanced`), `:521-538` renders the segmented picker with those three labels | |
| 20 | "a **Database** dropdown listing every Kraken2 database registered through the Plugin Manager" | true | `ClassificationWizardSheet.swift:434-472`, filtered to `readyDatabases` (`:179-181`) | |
| 21 | "The Advanced section holds a **Confidence** threshold (default 0.2)" | true | `ClassificationWizardSheet.swift:118` (`confidence: Double = 0.2`), `:548-560` | |
| 22 | "a **Minimum hit groups** field (default 2)" | changed | `ClassificationWizardSheet.swift:119` sets 2; `:561-571` labels the control "Min hit groups:" and renders it as a stepper with range 1 to 10 | "a **Min hit groups** stepper (default 2, range 1 to 10)" |
| 23 | "a **Threads** stepper (default 4, capped at the machine's core count)" | true | `ClassificationWizardSheet.swift:120` (`threads: Int = 4`), `:572-585` (`in: 1...ProcessInfo.processInfo.processorCount`) | |
| 24 | "a **Memory mapping** toggle" | true | `ClassificationWizardSheet.swift:121`, `:586-598` | |
| 25 | "an **Extra arguments** field that passes raw flags straight to Kraken2" | true | `ClassificationWizardSheet.swift:122`, `:599-606` with placeholder "Kraken2 arguments" | |
| 26 | "When the selected database needs more RAM than the machine has, a warning banner appears under the Database dropdown and Lungfish auto-enables the Memory mapping toggle." | true | `ClassificationWizardSheet.swift:488-491` renders the banner inside the database section; `:291-297` auto-enables memory mapping | |
| 27 | "The Advanced section" (name) | changed | `ClassificationWizardSheet.swift:543` titles the disclosure "Advanced Settings" | "The **Advanced Settings** section" |
| 28 | "The **Input FASTQ** field is pre-filled with whatever bundle was selected when you opened the wizard." | changed | `FASTQOperationDialogState.swift:1119-1128` renders the selection as a `datasetLabel` string, not a labelled "Input FASTQ" field; `FASTQOperationDialog.swift:34` passes it to the dialog chrome | "The dialog's dataset line names whatever bundle was selected when you opened it." |
| 29 | "Paired-end reads are detected automatically: when the bundle holds a `_R1`/`_R2` pair, both files feed the same Kraken2 run." | true | `ClassificationWizardSheet.swift:80-82` documents `MetagenomicsSampleGrouper` grouping bundles into samples with per-sample paired detection | |
| 30 | "Select more than one bundle in the sidebar before opening the wizard and it switches to batch mode." | true | `ClassificationWizardSheet.swift:193-195` (`isBatchMode` when `groupedSamples.count > 1`) | |
| 31 | "runs one Kraken2 plus Bracken pass for each" | true | `ClassificationWizardSheet.swift:100-113` states one pass per sample inside one batch operation | |
| 32 | "The Operations Panel … shows a progress row labelled `Kraken2: <bundle>`." | false | `AppDelegate+Classification.swift:851-858` builds the title as `"\(goalLabel) \(inputName)"` with goalLabel "Classifying", "Profiling", or "Classifying (extract)"; `:1385-1386` titles a batch "Classification Batch (N samples)" | "The Operations Panel shows a progress row labelled `Classifying <file name>`, or `Classification Batch (N samples)` for a multi-sample run." |
| 33 | "a `SRR36291587.kraken2.viral.lungfishtax` bundle appears in the sidebar" | false | `AppDelegate+Classification.swift:842-845` and `AnalysesFolder.swift:132-141` produce `Analyses/kraken2-<timestamp>/` | "a `kraken2-<timestamp>` folder appears under the project's `Analyses` folder in the sidebar" |
| 34 | "The table on the right mirrors the sunburst, one row per taxon, with columns for taxon name, rank, read count, and percentage of total classified reads." | changed | `TaxonomyTableView.swift:244-307` | "The table on the right mirrors the sunburst, one row per taxon, with columns for Sample, Taxon Name, Rank, Reads, Direct, and %. A Bracken column appears when Bracken abundance estimation ran." |
| 35 | "A single click on the **Coronaviridae** wedge selects it and syncs the table. Double-click it to re-centre the sunburst" | true | `TaxonomySunburstView.swift:20`, `:564-577` | |
| 36 | "right-click the taxon row in the table and choose **Extract Reads…**" | true | `TaxonomyViewController.swift:1303-1311` adds an "Extract Reads…" item to the taxon context menu | |
| 37 | "A dialog opens with a **Format** picker (FASTQ or FASTA) and a **Destination** picker: Save as Bundle, Save to File…, Copy to Clipboard, or Share…." | true | `ClassifierExtractionDialog.swift:162-168` (Format), `:18-31` and `:207-232` (four destinations with those exact labels) | |
| 38 | "Save as Bundle writes a new virtual FASTQ bundle into the project" | changed | `ClassifierReadResolver.swift:73-82` puts extractions in a top-level `Extractions/` folder, explicitly not with sequence imports | "Save as Bundle writes a new FASTQ bundle into the project's top-level `Extractions` folder" |
| 39 | "The alignment-backed classifiers (EsViritu, TaxTriage, NAO-MGS, NVD) add an 'Include unmapped mates of mapped pairs' toggle to this dialog. Kraken2 has no alignment, so that toggle is not shown here." | true | `ClassifierExtractionDialog.swift:180-182` renders that toggle conditionally; `cli-help/extract.txt`, `==== extract reads ====`, `--include-unmapped-mates` is documented "for --by-classifier, non-kraken2" | |
| 40 | "Escape zooms out one level, and Cmd-0 jumps straight back to the root." | true | `TaxonomySunburstView.swift:25`, `:657-670` | |
| 41 | "Right-clicking the chart background offers **Copy Chart as PNG**" | true | `TaxonomyViewController.swift:1283-1290` | |
| 42 | "**Export as CSV…** and **Export as TSV…** both write the full table in depth-first order with the columns Name, Rank, Reads (Clade), Reads (Direct), Clade %, and Direct %" | true | `TaxonomyViewController.swift:1750-1768` for the menu items; `:1603` sets `headers = ["Name", "Rank", "Reads (Clade)", "Reads (Direct)", "Clade %", "Direct %"]` | |
| 43 | "**Copy Summary** puts the plain-text classification summary on the clipboard." | true | `TaxonomyViewController.swift:1768-1774`, `:77` | |
| 44 | "a **Provenance** button opens a popover listing the pipeline metadata for the run" | true | `TaxonomyViewController.swift:987-989`, `:1712-1730`; `ClassifierActionBar.swift:74` defines the provenance button | |
| 45 | "a **Look Up on NCBI** submenu that links out to NCBI Taxonomy, GenBank Sequences, PubMed Literature, and Genome Assemblies" | true | `TaxonomyViewController.swift:1362-1398` builds those four items under a "Look Up on NCBI" submenu | |
| 46 | "Two more action-bar buttons, **Collections** and **BLAST Results**, toggle side drawers" | true | `TaxonomyViewController.swift:161-188` defines both buttons with those titles | |
| 47 | "When you open a multi-sample batch result, the Inspector gains a sample picker." | true | `ClassifierSamplePickerView.swift` in `LungfishKit`; `TaxonomyTableView.swift:244-250` adds the Sample column for multi-sample results | |
| 48 | "The table's top row is usually **unclassified**" | unverifiable | Row ordering depends on the parsed kreport, not on code the map can cite. Settling it needs a real run. | |
| 49 | "`lungfish conda classify reads.fastq.gz --db Viral`" | true | `cli-help/conda.txt`, banner `==== conda classify ====`, usage `conda classify [<options>] <fastq-files> ... --db <db>` | |
| 50 | "`--preset sensitive|balanced|precise` sets the Sensitivity preset" | true | `cli-help/conda.txt`, `==== conda classify ====`, "--preset … (values: sensitive, balanced, precise; default: balanced)" | |
| 51 | "`--confidence` and `--min-hit-groups` set the Advanced thresholds" | true | Same banner | |
| 52 | "`--profile` turns on Bracken abundance estimation (tuned with `--bracken-read-length`, `--bracken-level`, and `--bracken-threshold`)" | true | Same banner; defaults 150 and 10 respectively | |
| 53 | "`--memory-mapping` runs the database from disk … and `--quick` stops at the first hit group" | true | Same banner | |
| 54 | "Pass two files with `--paired` to classify a read pair, and set the output location with `-o` (or `--output-dir`)." | true | Same banner | |
| 55 | "`lungfish conda db list` prints every catalogued database with size, RAM, and update status" | true | `cli-help/conda.txt`, `==== conda db list ====`, "List available and installed databases" | |
| 56 | "`lungfish conda db download <name>` installs one" | true | `cli-help/conda.txt`, `==== conda db download ====` | |
| 57 | "`lungfish conda db remove <name>` drops it from the registry (add `--delete-files` …)" | true | `cli-help/conda.txt`, `==== conda db remove ====`, `--delete-files` | |
| 58 | "`lungfish conda db recommend` names the largest database that fits in this machine's RAM" | true | `cli-help/conda.txt`, `==== conda db recommend ====`, "Show recommended database for this system" | |
| 59 | "use `lungfish extract reads --by-classifier --tool kraken2 --result <kreport> --taxon <taxid> -o out.fastq`" | true | `cli-help/extract.txt`, `==== extract reads ====`, all four options present with those meanings | |
| 60 | "`--read-format fastq|fasta` chooses the output format" | true | Same banner, "Output read format: fastq or fasta … default fastq" | |
| 61 | "The `--include-unmapped-mates` flag is rejected with `--tool kraken2`" | true | Same banner, "for --by-classifier, non-kraken2" | |
| 62 | "`lungfish import kraken2 <kreport-file>` brings a Kraken2 report you generated elsewhere into a project." | true | `cli-help/import.txt`, `==== import kraken2 ====` | |
| 63 | "`lungfish build-db kraken2 <result-dir>` builds a SQLite database from a Kraken2 result directory … the power-user route when you need a custom database the Plugin Manager does not offer." | changed | `cli-help/build-db.txt`, `==== build-db kraken2 ====`, "Build SQLite database from Kraken2 results". This builds a queryable index of an existing result, not a Kraken 2 classification database. | "`lungfish build-db kraken2 <result-dir>` builds a SQLite index over an existing Kraken2 result directory so the viewport can query it quickly (with `--force` to overwrite, `--no-cleanup` to keep intermediates, and `--sample-dir` to name one sample directory at a time). It does not build a Kraken2 classification database, and LGE offers no route to build one." |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The taxonomy table's "Filter taxa…" search field, added in August 2026 | `TaxonomyTableView.swift:185`, `:225-232` |
| The Bracken column, hidden until Bracken abundance estimation ran | `TaxonomyTableView.swift:288-298`, `:63` |
| Per-column header filter menus on the taxonomy table | `TaxonomyTableView.swift:141-151`, `:960-979` |
| The taxon context menu's Copy Taxon Name and Copy Path items | `TaxonomyViewController.swift:1315-1330` |
| The taxon context menu's "BLAST Matching Reads…" item, the per-row route to verification | `TaxonomyViewController.swift:1405-1414` |
| The action bar's "Extract FASTQ" button, a second route to extraction beside the right-click menu | `ClassifierActionBar.swift:49-51` |
| The extraction dialog's Name field and its clipboard read cap, which disables the Copy to Clipboard destination for large selections | `ClassifierExtractionDialog.swift:234-247`, `:213`; `TaxonomyReadExtractionAction.swift:94` |
| `conda classify --recursive`, which pulls eligible FASTQ or FASTA out of subfolders | `cli-help/conda.txt`, `==== conda classify ====` |
| `conda db update` (with `--all` and a required `--yes`) and `conda db install-managed` | `cli-help/conda.txt`, `==== conda db update ====`, `==== conda db install-managed ====` |
| A folder prompt appears when the sidebar selection is a folder holding FASTQ in subfolders | `AppDelegate+ToolsMenu.swift:286-311` |
| The multi-bundle run-mode picker is shown but locked to per-bundle for Kraken2, with an explanatory lock reason | `ClassificationWizardSheet.swift:100-113` |
| The RAM warning banner's exact text names the required and available gigabytes | `ClassificationWizardSheet.swift:250-257` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `kraken2-wizard` (planned) | Yes, with a caption fix | The database picker and the dataset line both exist. The caption should say "the FASTQ/FASTA Operations dialog with Kraken2 selected", since the surface is the shared dialog and not a standalone Classification wizard. |
| `kraken2-plugin-manager` (planned) | Yes | The Plugin Manager and its Databases tab exist (`ClassificationWizardSheet.swift:448-455` opens it directly). |
| `kraken2-taxonomy-viewport` (planned) | Yes, with a caption fix | Sunburst and table both exist. Add the "Filter taxa…" field to the caption so the shot is framed to include it. |
| `kraken2-drilldown-coronaviridae` (planned) | Yes | Double-click re-centring and the breadcrumb bar are both real (`TaxonomySunburstView.swift:564-577`). |
| `kraken2-extract-reads` (planned) | No, as captioned | Its caption says the menu item is "Extract Reads as FASTQ Bundle". The real item is "Extract Reads…" (`TaxonomyViewController.swift:1305`), which opens the dialog where Save as Bundle is one of four destinations. Recaption to "Right-click menu on a taxon row, with Extract Reads… selected". |
| `<!-- planned: kraken2-wizard -->` marker placement | Yes | Sits at the end of step 2, after the settings are described. |
| `<!-- planned: kraken2-extract-reads -->` marker placement | Yes | Sits right after the extraction paragraph. |

## 03-running-esviritu.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "EsViritu is a viral-focused classifier that maps reads against a curated database of viral reference genomes" | true | `cli-help/esviritu.txt`, banner `==== esviritu ====`, "Detect and characterize viruses from metagenomic sequencing data using EsViritu. Requires the EsViritu conda package and its curated viral reference database." | |
| 2 | "The EsViritu tool itself ships inside the `classification` plugin pack." | false | `PluginPack.swift:771-776` puts `esviritu` in the pack with `id: "metagenomics"`, named "Metagenomics"; no pack has the id `classification` | "The EsViritu tool itself ships inside the `metagenomics` plugin pack, listed in the Plugin Manager as **Metagenomics** alongside Kraken 2, Bracken, and RiboDetector." |
| 3 | "roughly 400 MB compressed, around 5 GB uncompressed" | true | `third-party-tools-lock.json`, `esviritu-viral-v3`: `sizeBytes` 419430400 (400 MB), `sizeOnDisk` 5368709120 (5 GB) | |
| 4 | "holding 19,925 curated viral assemblies across 63 families" | true | Same entry, description "19,925 curated viral assemblies across 63 families (Tisza et al. 2023)" | |
| 5 | "Plan for at least 8 GB of RAM for the default viral database." | true | Same entry, `recommendedRAM` 8589934592 (8 GB) | |
| 6 | "Open the Plugin Manager from `Tools > Plugin Manager…` (Cmd-Shift-B)." | true | `MainMenu.swift:773-780` | |
| 7 | "Find the **EsViritu** row under the Classification group." | false | `PluginPack.swift:772-777` sets `category: "Metagenomics"` for the pack that carries EsViritu | "Find the **EsViritu** row under the Metagenomics group." |
| 8 | "Click **Install Database**." | changed | The wizard's own button is labelled "Download Database…" and opens the Plugin Manager's Databases tab (`EsVirituWizardSheet.swift:404-406`). No "Install Database" string exists in the source. | "Open the Plugin Manager's Databases tab, which the wizard's **Download Database…** button also reaches, and install the EsViritu database from there." |
| 9 | "Wait until the row's status badge reads **Database ready**." | false | `EsVirituWizardSheet.swift:387` renders the installed state as `"EsViritu \(EsVirituDatabaseManager.currentVersion)"` with a size in parentheses; the not-installed state reads "Database not installed" (`:400`). No "Database ready" string exists. | "Wait until the wizard's Database section shows a green dot and reads `EsViritu <version>` with the installed size beside it, instead of `Database not installed`." |
| 10 | "From the CLI, the same status surface is `lungfish esviritu db-status`, which reports the database status, version, disk path, and disk size." | true | `cli-help/esviritu.txt`, banner `==== esviritu db-status ====`, "Check EsViritu database installation status" | |
| 11 | "Skip this step and the wizard still lets you choose EsViritu, but the **Run** button stays disabled and an inline notice points you back to the Plugin Manager." | true | `EsVirituWizardSheet.swift:398-406` shows "Database not installed" plus the Download Database… button; run readiness is gated on database presence | |
| 12 | "the CLI installs the database directly with `lungfish esviritu download-db`, which takes `--force`" | true | `cli-help/esviritu.txt`, banner `==== esviritu download-db ====`, `--force` "Re-download even if the database is already installed" | |
| 13 | "The tool binary itself installs through conda (`lungfish conda install esviritu`)." | true | `cli-help/esviritu.txt`, `==== esviritu ====`, "Install the tool: lungfish conda install esviritu" | |
| 14 | "Open **Tools > FASTQ/FASTA Operations > Classification…** and choose **EsViritu** in the wizard's tool picker." | false | `MainMenu.swift:786-819`; `FASTQOperationDialogState.swift:1995` | "Open **Tools > Classification > EsViritu…**, which opens the FASTQ/FASTA Operations dialog with EsViritu already selected." |
| 15 | "Confirm the **Inputs** step lists both paired reads … If only one mate shows, click **Add second mate** and pick the partner file." | false | `EsVirituWizardSheet.swift:326-370` renders one Sample section, not an Inputs step, and offers no "Add second mate" control. It reports "Paired-end reads" or "Single-end reads" for the grouped sample (`:362-367`). | "Confirm the Sample section reports **Paired-end reads** when you selected a pair. Pairing comes from the sample grouper, so if it reads Single-end, close the dialog and fix the bundle selection in the sidebar." |
| 16 | "Move to the **Database** step. The picker should read **EsViritu (installed)** with a version string and an install date." | false | `EsVirituWizardSheet.swift:374-410` renders a Database status line, not a picker. It shows `EsViritu <version>` and a size, with no install date. | "Check the **Database** section. It should show a green dot and read `EsViritu <version>` with the installed size beside it." |
| 17 | "On the **Options** step … EsViritu exposes two controls here: **Min Read Length** (default 100 nt) … and a quality-filter toggle" | changed | The quality-filter toggle is a top-level section labelled "Quality Filtering" with the checkbox "Enable quality filtering (fastp)" (`EsVirituWizardSheet.swift:438-450`), but Min read length sits inside the Advanced Settings disclosure (`:462-473`), not beside it | "The **Quality Filtering** section carries the one top-level option, the checkbox **Enable quality filtering (fastp)**, on by default. **Min read length** lives inside Advanced Settings with the Threads stepper and the Extra arguments field." |
| 18 | "**Min Read Length** (default 100 nt)" | true | `EsVirituWizardSheet.swift:124` (`minReadLength: Int = 100`); the stepper renders "bp" and steps by 10 in the range 50 to 500 (`:466-470`) | Name it "Min read length" to match the label, and give its range as 50 to 500 bp in steps of 10. |
| 19 | "There is no minimum-breadth or minimum-read-count field." | true | `EsVirituWizardSheet.swift:90-126` declares no such state | |
| 20 | "An **Advanced Settings** disclosure adds a **Threads** stepper (1 to the machine's core count) and an **Extra arguments** field" | true | `EsVirituWizardSheet.swift:462`, `:475-484` (`in: 1...ProcessInfo.processInfo.processorCount`), `:486-493` | |
| 21 | "`lungfish esviritu detect --input <fastq> --sample <name>`, with `--paired` for paired reads, `--db` …, `--min-read-length` (default 100), `--no-qc` …, `--extra-args` …, and `--output` (or `-o`)" | true | `cli-help/esviritu.txt`, `==== esviritu detect ====`, every option present with those defaults | |
| 22 | "it defaults to `esviritu-<sample>` beside the input" | false | `cli-help/esviritu.txt`, `==== esviritu detect ====`, "-o, --output <output> Output directory (default: current directory)" | "the output directory defaults to the current directory" |
| 23 | "The FASTQ goes behind `--input` (or `-i`), never as a bare positional argument." | true | Same banner; the usage line shows no positional argument | |
| 24 | "Select FASTQ for more than one sample and the wizard switches to batch mode. It replaces the sample-name field with a list of the grouped samples, each tagged paired-end (PE) or single-end (SE)" | true | `EsVirituWizardSheet.swift:328-359` swaps the sample-name TextField for the grouped list and tags each `"PE"` or `"SE"` | |
| 25 | "batch mode adds a **Recompute Unique Reads** button to the action bar" | true | `EsVirituResultViewController.swift:218-222` ("only shown in batch mode"), `:1330-1333` | |
| 26 | "with columns for accession, organism, read count, unique read count, RPKMF …, and coverage" | changed | `ViralDetectionTableView.swift:428-500` defines Sample, Virus Name, Family, Reads, Unique Reads, RPKMF, Coverage, Identity, and Segment. There is no Accession column, and Organism is called Virus Name. | "with columns for Sample, Virus Name, Family, Reads, Unique Reads, RPKMF (reads per kilobase of reference per million reads, a length-normalised abundance measure), Coverage, Identity, and Segment" |
| 27 | "A coverage sparkline rides alongside each row" | true | `ViralDetectionTableView.swift:26` documents the Coverage column as "Sparkline + mean coverage depth" | |
| 28 | "Segmented viruses also get a segment-completeness grid" | true | `ViralDetectionTableView.swift:500` defines the Segment column; `features.yaml:682-683` names segment completeness | |
| 29 | "Right-click a virus row … The context menu offers **Extract Reads…** …, **BLAST Verify…** …, and a **Look Up on NCBI** submenu" | unverifiable | `ClassifierActionBar.swift:22-24` and `:49-51` supply the BLAST Verify and Extract FASTQ action-bar buttons, and `EsVirituResultViewController.swift` wires a `NSMenu` for rows, but the exact three item titles could not be located in that file. Settling it needs the row context menu built and inspected in the running app. | |
| 30 | "click a virus row that carries alignment data. The full alignment viewer appears in the detail pane on its own. There is no separate 'Show reads' button" | true | `ViewerViewController+EsViritu.swift:56` calls `split.makeClassifierAlignmentEvidenceViewport()`; `EsVirituResultViewController.swift:436-437` installs that viewport's view as the detail pane's alignment evidence view on selection | |
| 31 | "EsViritu evidence is reference-free, so reference-dependent mismatch, consensus, variant, and reference-export controls are unavailable and the Inspector explains why." | unverifiable | The strings "reference-free" and "referenceFree" appear nowhere in `Sources/`. `MainSplitViewController.swift:417-424` builds a `ClassifierAlignmentEvidenceViewportController` bound to the inspector, but no message matching this description could be found. Settling it needs the Inspector inspected during a real EsViritu run. | |
| 32 | "Use **Import Metadata…** in the Inspector to attach a CSV or TSV sample sheet." | true | `InspectorView.swift:1155-1160` renders an "Import Metadata…" button; `EsVirituResultViewController.swift` conforms to the sample-metadata presentation consumer protocol | |
| 33 | "fields without a value for a row display an em dash" | unverifiable | No cell-formatter constant for the missing-value glyph was located in `ViralDetectionTableView.swift`. Settling it needs a run with partial metadata. | |
| 34 | "**Export** writes every detection to a CSV or TSV file through a save panel" | true | `ClassifierActionBar.swift:36-38` defines the Export button; `MetagenomicsFilePanelFactory` in `LungfishKit` supplies the TSV or CSV save panel | |
| 35 | "**Provenance** opens a popover recording the run's tool version, runtime, and database" | true | `ClassifierActionBar.swift:74` defines the provenance button | |
| 36 | "For SRR36291587 on an M-series laptop the run takes roughly 4 to 8 minutes" | unverifiable | No timing figure appears in the source. Settling it needs a measured run. | |
| 37 | "the Panel reports each phase (database load, mapping, coverage summarisation, report rendering) as it completes" | unverifiable | `AppDelegate+Classification.swift:1078-1084` starts the operation with the detail "Starting EsViritu viral detection…", but the four named phases could not be found as progress messages. Settling it needs a real run's operation log. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The wizard's sample-name text field for a single-sample run | `EsVirituWizardSheet.swift:361-364` |
| The limited-RAM warning banner shown when the machine is small | `EsVirituWizardSheet.swift:409-411`, `:420-425` |
| The multi-bundle run-mode picker in batch mode | `EsVirituWizardSheet.swift:339-343` |
| `esviritu detect --recursive`, which pulls eligible FASTQ out of subfolders | `cli-help/esviritu.txt`, `==== esviritu detect ====` |
| `lungfish import esviritu <results-dir>`, the route for a run produced outside LGE | `cli-help/import.txt`, `==== import esviritu ====` |
| `lungfish build-db esviritu <result-dir>`, which indexes an EsViritu result for the viewport | `cli-help/build-db.txt`, `==== build-db esviritu ====` |
| The action bar's Extract FASTQ button, a route to extraction beside the row menu | `ClassifierActionBar.swift:49-51` |
| The Identity and Family columns in the detection table | `ViralDetectionTableView.swift:446`, `:491` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `esviritu-wizard-tool-step` (planned) | Yes, with a caption fix | The caption says "the run wizard with EsViritu chosen as the tool". Recaption to "the FASTQ/FASTA Operations dialog opened from Tools > Classification > EsViritu…", since the tool is chosen in the menu, not in the dialog. |
| `esviritu-database-missing` (planned) | Yes, with a caption fix | The state exists but the wording is wrong. Recaption to "the wizard's Database section reading Database not installed, with the Download Database… button beside it" (`EsVirituWizardSheet.swift:398-406`). |
| Its marker placement | No | The marker sits inside step 1 of the install procedure, which tells the reader to open the Plugin Manager. The shot belongs in the wizard walkthrough where the missing-database state is first seen. |
| `esviritu-result-viewport` (planned) | Yes | Coverage sparklines exist in the Coverage column (`ViralDetectionTableView.swift:26`). |
| `esviritu-bam-viewer` (planned) | Yes | The full alignment viewer does appear in the detail pane on row selection (`EsVirituResultViewController.swift:436-437`). |

## 04-running-taxtriage.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "That score is the TASS score (the TaxTriage Aggregate Scoring System)." | unverifiable | `BatchTaxTriageTableView.swift:253` names the column "TASS Score" and the pipeline reports it, but no expansion of the acronym appears in `Sources/`. Settling it needs the upstream jhuapl-bio/taxtriage documentation. | |
| 2 | "Lungfish runs TaxTriage through the same run wizard as Kraken2 and EsViritu" | true | `FASTQOperationDialogState.swift:2070` puts all three in the `.classification` category, and all three open through `FASTQOperationDialog` | |
| 3 | "you get a TASS-ranked result table with a compact confidence bar, a batch overview …, and a batch exporter that writes a cross-sample organism matrix" | true | `BatchTaxTriageTableView.swift:253`, `:256`; `TaxTriageBatchOverviewView.swift:44-47`; `TaxTriageBatchExporter.swift:14`, `:44` | |
| 4 | "a TASS at or above 0.8 is a strong call, between 0.4 and 0.8 is a call worth a closer look, and below 0.4 is weak evidence" | true | `TaxTriageResultViewController.swift:1170-1171` (`>= 0.8` returns "High", `>= 0.4` returns "Medium", otherwise low) | |
| 5 | "Lungfish shows the score in the result table with a numeric **TASS Score** column and a compact confidence bar." | true | `BatchTaxTriageTableView.swift:253` (TASS Score), `:256` (Confidence) | |
| 6 | "It runs the `jhuapl-bio/taxtriage` Nextflow pipeline inside a container, so before you install the database you must have two things available: **Nextflow** and a **container runtime** (Docker, or Apple Containerization on Apple Silicon)." | true | `cli-help/taxtriage.txt`, banner `==== taxtriage ====`, "Requires Nextflow and Docker (or Apple Containerization on macOS 26+)"; `TaxTriageWizardSheet.swift:108-110` | |
| 7 | "The wizard checks for both and keeps the **Run** button disabled until they are present" | true | `TaxTriageWizardSheet.swift:296-312` returns a validation message when either is missing; `:316-347` renders the Prerequisites indicators | |
| 8 | "Verify both at once with `lungfish taxtriage check-prerequisites`" | true | `cli-help/taxtriage.txt`, banner `==== taxtriage check-prerequisites ====`, "Verify Nextflow and container runtime availability" | |
| 9 | "install the reference database, which is separate from the Kraken2 and EsViritu databases and is not bundled with the application" | false | `TaxTriageWizardSheet.swift:426-450` renders a picker headed "Kraken2 Database" populated from the installed Kraken 2 databases; `cli-help/taxtriage.txt`, `==== taxtriage run ====`, "--db <db> Path to existing Kraken2 database". There is no separate TaxTriage database. | "TaxTriage classifies against an installed Kraken2 database, so it needs no database of its own. Install a Kraken2 database as in the Kraken2 chapter and TaxTriage will pick it up." |
| 10 | "The first time you select TaxTriage in the wizard, its Tool step shows a 'Database not installed' warning instead of a database picker." | false | `TaxTriageWizardSheet.swift:434-438` shows "No Kraken2 databases installed" instead of the picker | "When no Kraken2 database is installed, the wizard's **Kraken2 Database** section reads `No Kraken2 databases installed` instead of showing a picker." |
| 11 | "Open the **Plugin Manager** from `Tools > Plugin Manager…` (Cmd-Shift-B), find the TaxTriage entry under Classification, and click **Install**." | false | `PluginPack.swift` defines no TaxTriage pack, and there is no "Classification" plugin category (`PluginPack.swift:772-777` names the pack "Metagenomics") | "Open the Plugin Manager from `Tools > Plugin Manager…` (Cmd-Shift-B) and install a Kraken2 database from the Databases tab. TaxTriage itself is not a plugin pack, because it runs as a Nextflow pipeline inside a container rather than as a conda tool." |
| 12 | "The default clinical-surveillance database is on the order of tens of gigabytes" | false | The database is a Kraken 2 database chosen by the user; `MetagenomicsModels.swift:104-112` gives sizes from 0.5 GB (Viral) to 72 GB (PlusPF) | "The size depends on which Kraken2 database you point it at, which ranges from 0.5 GB for Viral to 72 GB for PlusPF." |
| 13 | "the default run should be planned as a 16 GB or larger memory operation" | true | `TaxTriageWizardSheet.swift:103` sets `maxMemoryGB = 16`; `cli-help/taxtriage.txt`, `==== taxtriage run ====`, "--max-memory … default: 16.GB" | |
| 14 | "From the CLI, use `lungfish conda db info \"NCBI Taxonomy\"` for the bundled taxonomy support database and `lungfish conda db list`" | true | `cli-help/conda.txt`, `==== conda db info ====` and `==== conda db list ====`; `third-party-tools-lock.json` carries an `ncbi-taxonomy` database entry | |
| 15 | "select all four FASTQ bundles. Open **Tools > FASTQ/FASTA Operations > Classification…** and choose **TaxTriage** in the wizard's tool picker." | false | `MainMenu.swift:786-819`; `FASTQOperationDialogState.swift:1996` | "select all four FASTQ bundles, then open **Tools > Classification > TaxTriage…**, which opens the FASTQ/FASTA Operations dialog with TaxTriage already selected." |
| 16 | "The four samples populate the Inputs step." | changed | `TaxTriageWizardSheet.swift:349-367` renders a Samples section, one editable row per sample, with an **Add Sample** button below | "The four samples populate the **Samples** section, one editable row each, and an **Add Sample** button lets you add another." |
| 17 | "**Sequencing Platform** (Illumina, Oxford Nanopore, or PacBio)" | true | `TaxTriageWizardSheet.swift:455-464` renders exactly those three labels | |
| 18 | "The **Skip assembly** toggle is on by default" | true | `TaxTriageWizardSheet.swift:92` (`skipAssembly: Bool = true`), `:473` labels it "Skip assembly (faster)"; `cli-help/taxtriage.txt`, "--skip-assembly Skip genome assembly steps (default: true)" | Name the control "Skip assembly (faster)" to match the label. |
| 19 | "the **Skip Krona** toggle controls whether the pipeline renders its own Krona chart" | changed | `TaxTriageWizardSheet.swift:534` puts "Skip Krona visualization" inside the Advanced Settings disclosure, not beside Skip assembly, and `:93` defaults it off | "Inside Advanced Settings, the **Skip Krona visualization** toggle, off by default, controls whether the pipeline renders its own Krona chart." |
| 20 | "The Advanced section exposes the Kraken2 confidence (default 0.2), the number of top hits to keep (default 10), and the memory and CPU ceilings." | true | `TaxTriageWizardSheet.swift:101-104` (0.2, 10, 16 GB, `activeProcessorCount`), `:487-533` renders all four in the "Advanced Settings" disclosure | Name the disclosure "Advanced Settings", and give the Max memory range as 2 to 256 GB in steps of 2 (`:516`) and Top hits as 1 to 100 (`:507`). |
| 21 | "There is no clinical-versus-research-versus-wastewater profile picker" | true | `TaxTriageWizardSheet.swift:90-112` declares no such state | |
| 22 | "The headless form is `lungfish taxtriage run`, with `--platform`, `--samplesheet` …, `--confidence` (default 0.2), `--top-hits` (default 10), `--rank` (default S, for species), `--skip-assembly` (on by default), `--skip-krona`, `--max-memory`, and `--nf-profile` (default docker)." | true | `cli-help/taxtriage.txt`, `==== taxtriage run ====`, every option present with those defaults | |
| 23 | "The pipeline revision is pinned so a re-run reproduces the same result." | true | `cli-help/taxtriage.txt`, `==== taxtriage run ====`, "--revision … (defaults to Lungfish's pinned TaxTriage revision) (default: e10bfebda32a62711f38a4e23ab03b61725a9675)" | Say the revision is pinned by default and that `--revision` can override it. |
| 24 | "Each row is one organism call, sorted by TASS score, highest first." | true | `BatchTaxTriageTableView.swift:250-253` ("TASS Score sorts descending by default … highest score first") | |
| 25 | "Switch to the **batch overview** tab." | false | `TaxTriageResultViewController.swift:1373-1380` shows the batch overview when the sample filter is on "All Samples" and more than one sample is loaded, and hides the organism table in its place. There is no tab. | "Set the sample filter back to **All Samples**. With more than one sample loaded, the viewport swaps the per-sample organism table for the batch overview." |
| 26 | "The batch overview lays out all samples in the run as columns and the union of called organisms as rows, with the score in each cell." | true | `TaxTriageBatchOverviewView.swift:44-47` documents rows as organisms, columns as samples, cells as TASS | |
| 27 | "The full BAM viewer shows the reads that support the currently selected organism" | true | `ViewerViewController+TaxTriage.swift` wires the classifier alignment evidence viewport for TaxTriage rows; `MainSplitViewController.swift:417-424` | |
| 28 | "Reference-dependent controls are enabled only when Lungfish can validate the exact downloaded reference record against the BAM; otherwise the Inspector reports reference-free mode." | unverifiable | "reference-free" appears nowhere in `Sources/`. Settling it needs the Inspector inspected during a real TaxTriage run. | |
| 29 | "right-click its row on the batch table and choose **Verify with BLAST…**" | changed | `FASTASequenceActionMenuBuilder.swift:7` sets the shared blast item title to "Verify with BLAST…", but that builder is used by the sequence-backed viewports (NVD); the TaxTriage action bar's button is "BLAST Verify" (`ClassifierActionBar.swift:24`) | "Select the row and click **BLAST Verify** in the action bar." Verify the row context menu in the running app before naming a right-click item. |
| 30 | "You can attach a CSV or TSV sample sheet with **Import Metadata…** in the Inspector." | true | `InspectorView.swift:1155-1160` | |
| 31 | "A second tab holds a **cross-sample SNP table**" | false | `StrainComparisonView.swift:36` declares the view `internal` and it is instantiated only in `Tests/LungfishTaxTriageUITests/StrainComparisonColumnWindowingTests.swift`; no production call site exists | Delete the claim. The strain-comparison surface is not reachable in the shipping app. |
| 32 | "The exporter writes two files to a folder you choose: a **cross-sample organism matrix** as a CSV … and a plain-text summary report." | true | `TaxTriageBatchExporter.swift:14`, `:44`, `:129-153` | |
| 33 | "one row per organism, with columns for the mean TASS score, how many samples detected it, a contamination-risk indicator, and then the per-sample TASS score" | true | `TaxTriageBatchExporter.swift:44` writes the header `"Organism,Mean TASS,Samples Detected,Contamination Risk"` then one column per sample | |
| 34 | "There is no PDF and there are no report templates" | true | `TaxTriageBatchExporter.swift:14` names only the CSV matrix and the text report | |
| 35 | "A four-sample batch takes a few minutes per sample on Apple Silicon" | unverifiable | No timing figure appears in the source. Settling it needs a measured run. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The per-sample **role** picker on each sample row, with Clinical Sample, Negative Control, Positive Control, Environmental Control, and Extraction Blank | `TaxTriageWizardSheet.swift:394-399`; `FASTQSampleMetadata.swift:26-33` |
| The **Add Sample** and **Remove** buttons, which let you edit the sample list inside the dialog | `TaxTriageWizardSheet.swift:362-366`, `:405-409` |
| The Prerequisites section, which shows a live green or amber dot for Nextflow and for the detected container runtime by name | `TaxTriageWizardSheet.swift:316-347` |
| The **Max CPUs** stepper in Advanced Settings, defaulting to the machine's active processor count | `TaxTriageWizardSheet.swift:104`, `:522-531` |
| The **Extra arguments** field, which forwards raw flags to TaxTriage or Nextflow | `TaxTriageWizardSheet.swift:105`, `:537-542` |
| The batch overview's facet control, which reswitches the cell value between TASS score and other facets such as unique reads | `TaxTriageBatchOverviewView.swift:66-68`, `:166-171` |
| The sample filter segmented control, whose "All Samples" segment is what reveals the batch overview | `TaxTriageResultViewController.swift:1209`, `:1373-1380` |
| `taxtriage run --rank`, `--max-cpus`, `--revision`, `--extra-args`, and `--recursive` | `cli-help/taxtriage.txt`, `==== taxtriage run ====` |
| `lungfish import taxtriage <results-dir>` and `lungfish build-db taxtriage <result-dir>` | `cli-help/import.txt`, `==== import taxtriage ====`; `cli-help/build-db.txt`, `==== build-db taxtriage ====` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `taxtriage-wizard-tool-step` (planned) | Yes, with a caption fix | The caption says "the run wizard with TaxTriage selected and a multi-sample batch loaded". Recaption to name the FASTQ/FASTA Operations dialog, and frame the shot to include the Prerequisites indicators and the per-sample role pickers, which the chapter must now cover. |
| Its marker placement | Yes | It sits in the step that checks the database and prerequisites, which is where the shot is most useful. |
| `taxtriage-result-table` (planned) | Yes | The TASS Score and Confidence columns both exist (`BatchTaxTriageTableView.swift:253`, `:256`). |
| Its marker placement | No | The marker sits at the end of step 3, which is about the reagent blank column of the batch overview. Move it to step 1, which is where the result table is read. |
| `taxtriage-batch-overview` (planned) | Yes, with a caption fix | The overview exists but is reached by setting the sample filter to All Samples, not by clicking a tab. The caption should not imply a tab. |
| `taxtriage-batch-export` (planned) | Yes | `TaxTriageBatchExporter.swift:44` writes exactly the matrix the caption describes. |

## 05-running-nao-mgs.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "NAO-MGS is a metagenomic surveillance pipeline for wastewater pathogen monitoring, built by SecureBio." | true | `cli-help/nao-mgs.txt`, banner `==== nao-mgs ====`, "Import results from the SecureBio NAO-MGS metagenomic surveillance pipeline" | |
| 2 | "This is an import-only tool. There is no NAO-MGS option in the run wizard and no 'run NAO-MGS' surface anywhere in the app." | true | `FASTQOperationDialogState.swift:2070` omits it; `ImportCenterViewModel.swift:414-422` routes it to a wizard sheet | |
| 3 | "You produce the results with an external `securebio/nao-mgs-workflow` run" | true | `NaoMgsResultParser.swift:319` names `https://github.com/securebio/nao-mgs-workflow` | |
| 4 | "The primary file Lungfish reads is `virus_hits_final.tsv.gz` (the pipeline also writes `_virus_hits.tsv.gz` per-sample files)." | true | `ImportCenterViewModel.swift:417`, "Parses virus_hits_final.tsv.gz or _virus_hits.tsv.gz files"; `cli-help/nao-mgs.txt`, `==== nao-mgs import ====`, argument "Path to NAO-MGS results directory or virus_hits_final.tsv(.gz)" | |
| 5 | "If you point the importer at a directory, it finds that file for you; if you point it at the file directly, that works too." | true | Same CLI banner; `NaoMgsImportSheet.swift:161` says "Select a directory containing virus_hits_final.tsv.gz, or the file directly." | |
| 6 | "Choose **File > Import Center…**, open the **Classification Results** tab, and pick the **NAO-MGS Results** card." | true | `MainMenu.swift:207-214` adds "Import Center…" to the File menu; `ImportCenterViewModel.swift:414-422` defines the card with `tab: .classificationResults`; `:178` names that tab "Classification Results" | |
| 7 | "Click **Choose** and select either the pipeline output directory or the `virus_hits_final.tsv(.gz)` file directly." | false | `NaoMgsImportSheet.swift:154` labels the button "Browse…" | "Click **Browse…** and select either the pipeline output directory or the `virus_hits_final.tsv(.gz)` file directly." |
| 8 | "There is no `samples/`, `metadata.tsv`, or `manifest.json` structure to assemble; the importer validates only that it can find the virus-hits TSV." | true | `NaoMgsImportSheet.swift:172-219` renders one Validation section whose success state is "Valid NAO-MGS results" | |
| 9 | "an NAO-MGS result appears in the sidebar under your project's classification results" | changed | `AnalysesFolder.swift:24-32` lists `naomgs` among the known tools and among the imported-result tools that use `<tool>-<sampleName>` naming under `Analyses` | "an NAO-MGS result appears in the sidebar under the project's `Analyses` folder, named `naomgs-<sample>`" |
| 10 | "`lungfish import nao-mgs /path/to/nao-mgs-output/ --output-dir /path/to/project/Imports/`" | true | `cli-help/import.txt`, `==== import nao-mgs ====`, positional `<input-path>` and `-o, --output-dir` | The example writes into `Imports/`, which conflicts with the canonical bundle location. Point the example at the project root and let the importer place the bundle. |
| 11 | "useful options are `--sample-name` to label the sample, `--output-dir` (`-o`) …, and `--no-fetch-references` when you want to skip reference FASTA downloads" | true | `cli-help/import.txt`, `==== import nao-mgs ====`, "--fetch-references/--no-fetch-references … (default: --fetch-references)" | |
| 12 | "This command writes the canonical `naomgs-<sample>/` result bundle" | true | `AnalysesFolder.swift:30-32` documents `naomgs` using `{tool}-{sampleName}` naming | |
| 13 | "`lungfish nao-mgs import /path/to/virus_hits_final.tsv.gz --output-dir ./summaries` … writes a JSON summary outside a project and supports `--sample-name`, `--output-dir` (`-o`), and `--min-bitscore`" | true | `cli-help/nao-mgs.txt`, `==== nao-mgs import ====`, "Import NAO-MGS results as a standalone JSON summary", with those three options and `--min-bitscore` defaulting to 0 | |
| 14 | "`lungfish nao-mgs summary /path/to/virus_hits_final.tsv.gz --top 20`" | true | `cli-help/nao-mgs.txt`, `==== nao-mgs summary ====`, `--top` defaults to 20 | |
| 15 | "The viewport is a single-import split view: a detail pane on the left and a sortable taxon table on the right." | true | `NaoMgsResultViewController.swift:32` documents that layout | |
| 16 | "It is not a time series. One import shows one run's taxa; there is no multi-week chart, no series, and no per-week abundance line." | changed | `NaoMgsChartViews.swift` exists in the same module and `features.yaml:711-712` describes the NAO-MGS viewport as "SQLite-backed viewport with charts and provenance" | Soften to what the map can prove and verify the chart surface in the running app before restating the negative. The single-import split view is real; the absence of every chart is not established. |
| 17 | "The taxon table has columns for **Sample**, **Taxon**, **Hits** …, **Unique Reads**, and **Refs**" | true | `NaoMgsResultViewController.swift:1619`, `:1629`, `:1637`, `:1645`, `:1653` set exactly those five titles | |
| 18 | "If you imported per-sample metadata, that travels as extra columns." | true | `NaoMgsResultViewController.swift:234-241` refreshes metadata columns when the sample metadata store changes | |
| 19 | "The pane shows the taxon's run context, read-count metrics, accession count, and miniBAM evidence cards for the top references when alignment data is available." | true | `NaoMgsResultViewController.swift:168` holds an array of `MiniBAMViewController`; `:1171` creates one per card | |
| 20 | "The viewport's action bar has a **BLAST Verify** button" | true | `ClassifierActionBar.swift:22-24`; `NaoMgsResultViewController.swift:307` exposes `onBlastVerification` | |
| 21 | "the verification flow selects a coverage-stratified sample of the taxon's reads and submits them to NCBI BLAST" | true | `BlastConfigPopoverView.swift:25`, `:40`, `:65-98` | |
| 22 | "The provenance record for the import is reachable from the Inspector and names the source path, the importing command, and the input checksums." | true | `NaoMgsProvenanceView.swift`; `NaoMgsResultViewController.swift:473` records `sourceFilePath` | |
| 23 | "cite the upstream pipeline at `https://github.com/securebio/nao-mgs-workflow`" | true | `NaoMgsResultParser.swift:319`, `NaoMgsCommand.swift:13` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The sample-filter button above the taxon table, labelled "All Samples" or "N of M Samples" | `NaoMgsResultViewController.swift:110`, `:669-671` |
| The action bar's Export and Extract FASTQ buttons | `ClassifierActionBar.swift:36-38`, `:49-51`; `NaoMgsResultViewController.swift:310` |
| A "View on NCBI" action on a taxon | `NaoMgsResultViewController.swift:313` (`onViewOnNCBI`) |
| Sample metadata columns loaded through the Inspector's Import Metadata… | `NaoMgsResultViewController.swift:234-241`; `InspectorView.swift:1155-1160` |
| `extract reads --by-db`, which queries the NAO-MGS SQLite database directly by taxid or accession | `cli-help/extract.txt`, `==== extract reads ====`, "By Database (--by-db)" |
| The NAO-MGS result is stored SQLite-backed for random-access queries | `NaoMgsDatabase+Queries.swift`; `features.yaml:711-712` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `nao-mgs-import-card` (planned) | Yes | `ImportCenterViewModel.swift:414-422` defines exactly that card on the Classification Results tab. |
| Its marker placement | Yes | It sits in step 1 beside the Import Center instruction. |
| `nao-mgs-result-viewport` (planned) | Yes, with a caption fix | The split layout is real (`NaoMgsResultViewController.swift:32`). Add the sample-filter button to the caption so the shot is framed to include it. |

## 06-blast-verification.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "It rolls the answers up into one of four verdicts. **Supported** … **Unsupported** … **Mixed** … And **Inconclusive**" | true | `BlastResultsDrawerTab.swift:92-95` returns exactly "Supported", "Mixed", "Unsupported", "Inconclusive" | |
| 2 | "Alongside the verdict you get a verification rate: the percentage of submitted reads that were independently verified." | true | `BlastResultsDrawerTab.swift:109` documents "Verification rate as a percentage (0 to 100)" | |
| 3 | "The same flow is available from the Kraken2, EsViritu, TaxTriage, and NAO-MGS viewports, and from the Novel Virus Diagnostics viewport, where **BLAST Verify** submits the selected contig sequence rather than a sample of reads." | true | `ClassifierActionBar.swift:22-24` is shared by all five viewports; `NvdResultViewController.swift:102` shows the BLAST Verify button in its action bar and `:1934-1938` routes it through the sequence-action handler | |
| 4 | "Click **BLAST Verify** in the viewport's action bar." | true | `ClassifierActionBar.swift:24` sets that exact title | |
| 5 | "(A taxon's right-click menu offers the same action, labelled 'BLAST Verify…' or 'BLAST Matching Reads…'.)" | changed | In the taxonomy viewport the item is "BLAST Matching Reads…" (`TaxonomyViewController.swift:1405-1408`); in the NVD viewport the shared builder titles it "Verify with BLAST…" (`FASTASequenceActionMenuBuilder.swift:7`). "BLAST Verify…" is not a menu title anywhere. | "(A right-click menu offers the same action. In the taxonomy viewport it reads **BLAST Matching Reads…**; in the NVD contig viewport it reads **Verify with BLAST…**.)" |
| 6 | "A popover opens, titled `Verify \"<taxon>\" via NCBI BLAST`." | true | `BlastConfigPopoverView.swift:65` renders `Text("Verify \"\(taxonName)\" via NCBI BLAST")` | |
| 7 | "Set the **Reads to submit** slider. It defaults to 20 and ranges from 1 to 50, capped to the number of reads available for the taxon." | true | `BlastConfigPopoverView.swift:40` (`readCount = 20`), `:50` (`min(50, max(1, readsClade))`), `:75` (`in: 1...Double(maxReads)`), `:109` | |
| 8 | "Lungfish selects that many reads automatically, stratified across the taxon's coverage" | true | `BlastConfigPopoverView.swift:25` documents the clamped range and `:90` states the reads are selected and submitted for the user | |
| 9 | "There is no representative-read list to scroll and no database or program to choose: the database is NCBI `nt` and the program is `blastn`, both fixed." | true | `BlastVerificationRequest.swift:86-88` defaults `database: String = "nt"` and `program` to blastn; `BlastConfigPopoverView.swift:65-98` renders only the slider and the two buttons | |
| 10 | "Click **Run BLAST**." | true | `BlastConfigPopoverView.swift:98` | |
| 11 | "NCBI returns a request ID and Lungfish polls for completion." | true | `BlastService.swift:640-662` builds the URL-API submission and the service polls for the RID | |
| 12 | "Each read is a parent row that expands to its NCBI hits (up to about five per read, the fixed hit-list size)." | true | `BlastVerificationRequest.swift:88` (`maxTargetSeqs: Int = 5`); `BlastService.swift:661-662` sends it as `HITLIST_SIZE` and `MAX_NUM_SEQ` | Say five exactly rather than "about five", since the default is a fixed 5. |
| 13 | "The columns available are Status, Read ID, Organism, Identity, E-value, Bit score, Accession, Coverage, Align Length, Tax ID, and the per-read Verdict." | changed | `BlastResultsDrawerTab.swift:215-225` defines those identifiers, but `:253-257` documents Coverage, Align Length, Tax ID, and Verdict as optional columns hidden until you show them from the header's right-click menu | "The drawer shows Status, Read ID or Accession, Organism, Identity, E-value, and Bit score. Right-click the column header to add Coverage, Align Length, Tax ID, and Verdict, which stay hidden until you ask for them. Your choice persists between sessions." |
| 14 | "**Open in NCBI BLAST** loads the full NCBI result for the submission in your web browser." | true | `BlastResultsDrawerTab.swift:249`, `:307` | |
| 15 | "**Re-run BLAST** submits the same taxon again" | true | `BlastResultsDrawerTab.swift:249`, `:310` | |
| 16 | "The subcommand is `blast verify`, and it needs three inputs the GUI assembles for you: the Kraken2 report, the per-read Kraken2 output, and the source FASTQ." | true | `cli-help/blast.txt`, banner `==== blast verify ====`, "Requires the kreport file …, the per-read Kraken2 output …, and the source FASTQ" | |
| 17 | "The `--taxid` selects the taxon to verify. `--reads` sets how many to submit (default 20). `--include-children` also pulls reads classified to descendant taxa. `--max-concurrent` caps in-flight submissions (default 1), and `--extra-args KEY=VALUE` passes additional NCBI URL-API parameters" | true | `cli-help/blast.txt`, `==== blast verify ====`, all five options with those defaults and meanings | |
| 18 | "The command prints the same verdict the drawer shows: SUPPORTED, MIXED, UNSUPPORTED, or INCONCLUSIVE" | true | `BlastResultsDrawerTab.swift:92-95` defines the four verdicts the service returns | |
| 19 | "Lungfish enforces a minimum spacing between submissions to keep you below the threshold" | true | `cli-help/blast.txt`, `==== blast verify ====`, `--max-concurrent` defaults to 1, capping in-flight submissions per process | The spacing claim is better stated as the concurrency cap the CLI documents. |
| 20 | "Lungfish does not offer a local-BLAST escape hatch: the database and program are fixed at NCBI `nt` and `blastn`" | true | `BlastVerificationRequest.swift:86-88`; `BlastConfigPopoverView.swift:90` says "Reads leave the app for NCBI" | |
| 21 | "the drawer at the bottom of the viewport" | true | `TaxonomyViewController.swift:1155-1173` toggles the BLAST results tab of the bottom drawer; `NvdResultViewController.swift:1898-1904` animates a bottom drawer to 220 points | |
| 22 | "Typical wait is 30 seconds to a few minutes; during NCBI peak hours the queue can stretch to ten minutes or more." | unverifiable | No timing figure appears in the source. This is NCBI queue behavior, not LGE behavior. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The popover's own warning that the reads leave the app for NCBI | `BlastConfigPopoverView.swift:90` |
| When a taxon has fewer reads than the slider minimum, the popover drops the slider and states the fixed count instead | `BlastConfigPopoverView.swift:54`, `:86` |
| A conflicting-organisms warning in the drawer, which counts reads whose hits disagree with each other | `BlastResultsDrawerTab.swift:468` |
| Column visibility choices persist under the UserDefaults key `blastResultsHiddenColumns` | `BlastResultsDrawerTab.swift:228-229`, `:253-257` |
| In the taxonomy viewport the drawer is one of two tabs, shared with Collections | `TaxonomyViewController.swift:1155-1182` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `blast-verify-popover` (planned) | Yes | Both the "Reads to submit" slider and the "Run BLAST" button exist exactly as captioned (`BlastConfigPopoverView.swift:71`, `:98`). |
| `blast-results-drawer` (planned) | Yes, with a caption fix | The verdict, the verification rate, and the per-read rows are all real. The caption should not imply the optional columns are visible by default, since Coverage, Align Length, Tax ID, and Verdict are hidden until enabled. |

## 07-running-freyja.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish exposes Freyja as a command-plan workflow." | true | `cli-help/freyja.txt`, banner `==== freyja demix ====`, "Construct a Freyja demix command plan from variant and depth tables" | |
| 2 | "A dry run writes the exact `freyja demix` command, the resolved options, the input and output file records, the pack identity, the tool version, and the Lungfish provenance sidecar." | true | Same banner, `--dry-run` "Write and print the command plan without running Freyja"; `--output-dir` "Output directory for plan, provenance, and demix output" | |
| 3 | "Add `--execute` once the `wastewater-surveillance` pack is installed" | true | Same banner, `--execute` "Run Freyja through the wastewater-surveillance tool pack."; `PluginPack.swift:833-846` defines that pack with `freyja` | |
| 4 | "Open `Tools > Plugin Manager…` and select the `wastewater-surveillance` pack to install or verify Freyja" | true | `MainMenu.swift:773-780`; `AppDelegate+ToolsMenu.swift:146-148` shows the Plugin Manager at exactly that pack id | |
| 5 | "There is no Freyja menu item." | true | `MainMenu.swift:1172` declares `showFreyjaDemix` in the actions protocol, but no `NSMenuItem` anywhere in `MainMenu.swift` targets that selector; the only implementation is `AppDelegate+ToolsMenu.swift:146-148` | |
| 6 | "The GUI's job here is installing the pack. The demixing itself runs from the command line below." | true | `AppDelegate+ToolsMenu.swift:146-148` opens the Plugin Manager and does nothing else | |
| 7 | "Freyja stays off the FASTQ/FASTA Operations menu because that menu is reserved for direct data operations." | changed | `FASTQOperationDialogState.swift:2047-2073` has no Freyja tool id, which is why it is absent, but the menu is now the Tools category submenus rather than a "FASTQ/FASTA Operations" menu | "Freyja is not a FASTQ/FASTA operation, so it never appears in the Tools category submenus. Those cover operations that read a FASTQ or FASTA directly, and Freyja consumes variant and depth tables instead." |
| 8 | "It needs two files: Variants … Depths" | true | `cli-help/freyja.txt`, `==== freyja demix ====`, `--variants` and `--depths` are both required in the usage line | |
| 9 | "`lungfish freyja demix --variants sample.variants.tsv --depths sample.depths.tsv --output-dir freyja-sample-001 --sample sample-001`" | true | Same banner; `--output-dir` is required and `--sample` is optional | |
| 10 | "| `freyja-command-plan.json` | The reproducible Freyja command plan. |" | true | Same banner, "Output directory for plan, provenance, and demix output" | |
| 11 | "| `.lungfish-provenance.json` | Lungfish operation provenance for the wrapper output. |" | true | Same banner | |
| 12 | "`lungfish conda install --pack wastewater-surveillance`" | true | `cli-help/conda.txt`, banner `==== conda ====`, subcommand "install Install a tool or plugin pack from bioconda"; the `--pack` form is documented in the same file's lock example | |
| 13 | "`--dry-run` wins over `--execute`. Pass both flags and Freyja does not run." | unverifiable | `cli-help/freyja.txt` lists both flags but states no precedence. Settling it needs `Sources/LungfishCLI/Commands/FreyjaCommand.swift` or a run, neither of which contradicts the claim. | |
| 14 | "Freyja writes its lineage-abundance table to `freyja-demix.tsv` inside the `--output-dir`" | unverifiable | The CLI help names the output directory but not the file name. Settling it needs `FreyjaDemixPlan.swift` or an executed run. | |
| 15 | "Advanced Freyja arguments pass through with `--extra-args`" | true | `cli-help/freyja.txt`, `==== freyja demix ====`, "--extra-args Additional Freyja demix arguments" | |
| 16 | "The sidecar records the workflow name (`lungfish freyja demix`), the Lungfish version, the exact command line, the resolved defaults, the pack identity (`wastewater-surveillance`), the tool version, the input and output paths, checksums and file sizes …, the exit status, the wall time, and stderr" | unverifiable | The CLI help says provenance is written but does not enumerate its fields. Settling it needs `FreyjaDemixPlan.swift`. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The `wastewater-surveillance` pack is flagged experimental, so the Plugin Manager marks it as such | `PluginPack.swift:838` (`isExperimental: true`) |
| The pack ships iVar, Pangolin, Nextclade, and minimap2 alongside Freyja, so installing it brings a whole surveillance toolset | `PluginPack.swift:836` |
| Freyja is one of the few tools whose GUI handler exists but is wired to no menu item, which is why the chapter's CLI-only framing holds | `MainMenu.swift:1172`; `AppDelegate+ToolsMenu.swift:146-148` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers and an empty `planned_shots` list | Correct as it stands | The chapter documents a CLI-only workflow whose only GUI surface is the Plugin Manager, which the Plugin Packs chapter already illustrates. Adding a Plugin Manager shot scoped to the `wastewater-surveillance` pack would help, since the chapter tells the reader to find that pack by name. |

## 08-importing-cz-id-results.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "It does not turn CZ-ID into a runnable option under `Tools > FASTQ/FASTA Operations > Classification`." | changed | The conclusion is right and the path is wrong. `FASTQOperationDialogState.swift:2070` omits CZ-ID; `MainMenu.swift:786-819` builds the menu as `Tools > Classification`. | "It does not turn CZ-ID into a runnable option under `Tools > Classification`." |
| 2 | "Lungfish does not run CZ-ID locally, submit reads to it, or sync with a CZ-ID account." | true | `cli-help/cz-id.txt`, banner `==== cz-id ====`, "This command imports existing CZ-ID outputs; it does not run or submit data to CZ-ID." | |
| 3 | "take a CZ-ID taxon report TSV, ZIP archive, or extracted export folder" | true | `cli-help/import.txt`, `==== import cz-id ====`, argument "Path to a CZ-ID taxon report TSV, ZIP archive, or extracted export folder" | |
| 4 | "The importer writes a project classification bundle at `Classifications/<sample>.lungfishtax`." | true | `AppDelegate+ToolsMenu.swift:860-867` appends `Classifications` then `<bundleFileName>.lungfishtax` | |
| 5 | "It keeps NT and NR read metrics when they are present, writes a Kraken-compatible taxonomy report …, writes `classification-result.json`, and writes `.lungfish-provenance.json`" | unverifiable | The preview surfaces NT and NR database versions (`CzIdImportSheet.swift:230-235`), and the CLI records provenance, but the three output file names could not be confirmed from the sources consulted. Settling it needs `Sources/LungfishWorkflow/Metagenomics/CzId/`. | |
| 6 | "In Import Center, choose **Classification Results > CZ-ID Results**" | true | `ImportCenterViewModel.swift:498-508` defines the CZ-ID Results card with `tab: .classificationResults`; `:178` names the tab | |
| 7 | "`lungfish import cz-id /path/to/cz-id-taxon-report.tsv --project /path/to/project.lungfish --sample-name Sample-CZ-001`" | true | `cli-help/import.txt`, `==== import cz-id ====`, usage requires exactly `<input-path> --project <project> --sample-name <sample-name>` | |
| 8 | "Confirm the command creates `/path/to/project.lungfish/Classifications/Sample-CZ-001.lungfishtax`" | true | `AppDelegate+ToolsMenu.swift:860-867` builds that path shape | |
| 9 | "prints the sample name, row count, CZ-ID pipeline version, and NT/NR database versions when those columns are present" | true | `CzIdImportSheet.swift:221-235` surfaces exactly those fields in the preview; the CLI reports the same import result | |
| 10 | "Open the project sidebar under **Classifications** and select the imported `.lungfishtax` bundle" | true | `AppDelegate+ToolsMenu.swift:862` writes into a `Classifications` folder | |
| 11 | "the sheet's **Preview** panel scans the export and reports what it found: the sample name, the project id when the export carries one, the row count, the source kind (TSV, ZIP, or extracted folder), the report file name, the CZ-ID pipeline version, the NT and NR database versions, and the first few taxa by name" | true | `CzIdImportSheet.swift:192-243` renders Preview with sample, Project (when present), Rows, Source, Pipeline, NT, and NR rows | The "report file name" and "first few taxa by name" rows could not be located in `:192-243`; drop them or confirm them in the running sheet. |
| 12 | "The **Import** button stays disabled until a path is selected and the preview scan succeeds" | true | `CzIdImportSheet.swift:101-102` gates on `preview` and `scanValidationGate` | |
| 13 | "hand it to the importer so it lands in provenance … `--metadata /path/to/metadata.json --non-host-fastq /path/to/non-host.fastq.gz`" | true | `cli-help/import.txt`, `==== import cz-id ====`, "--metadata … Optional CZ-ID metadata sidecar path to record in provenance" and "--non-host-fastq … Optional non-host FASTQ path to record in provenance" | |
| 14 | "`lungfish cz-id summary /path/to/cz-id-taxon-report.tsv --top 20`" | true | `cli-help/cz-id.txt`, `==== cz-id summary ====`, `--top` defaults to 20 | |
| 15 | "By default `summary` prints a text table; add the global `--format json` or `--format tsv`" | true | `cli-help/cz-id.txt`, `==== cz-id summary ====`, "--format … (values: text, json, tsv; default: text)" | |
| 16 | "The TSV form writes one header row and the columns `tax_id`, `name`, `rank`, `nt_reads`, `nt_rpm`, and `nr_reads`; the JSON form emits the top taxa as a pretty-printed array of records. Both forms respect `--top` and drop the root taxon before ranking by NT read count." | unverifiable | The CLI help documents the `--format` values but not the column names or the root-dropping rule. Settling it needs `Sources/LungfishCLI/Commands/CzIdCommand.swift`. | |
| 17 | "`lungfish cz-id import <input> --output-dir <dir>` writes a self-contained `cz-id-<sample>` directory wherever you point it and takes no `--project`." | true | `cli-help/cz-id.txt`, `==== cz-id import ====`, "-o, --output-dir … (default: ./cz-id-{sample})", and the usage line carries no `--project` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The sheet's **Browse…** button and its Project Destination section | `CzIdImportSheet.swift:176`, `:253` |
| The Import Center card's own file hint, "taxon report TSV, .zip, or extracted folder" | `ImportCenterViewModel.swift:504` |
| Imported CZ-ID results open in a dedicated `CzIdResultViewController`, and the chapter never describes that viewport | `Sources/LungfishApp/Views/Metagenomics/CzIdResultViewController.swift`; `features.yaml:754-757` |
| A CZ-ID provenance view exists for reviewing the recorded pipeline and database versions | `Sources/LungfishApp/Views/Metagenomics/CzIdProvenanceView.swift` |
| `cz-id import` takes no `--sample-name`, so the standalone form derives the sample from the export | `cli-help/cz-id.txt`, `==== cz-id import ====` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers and an empty `planned_shots` list | Not adequate | The chapter describes a Preview panel with seven named fields and an Import button that stays disabled until the scan succeeds (`CzIdImportSheet.swift:192-243`, `:101-102`). That is the chapter's one visual surface and it should be shot. Add a planned shot of the CZ-ID import sheet with a successful preview, and a second of the imported result in the sidebar under `Classifications`. |

## 09-novel-virus-detection.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "NVD is an external Snakemake pipeline built for wastewater viral surveillance, and Lungfish does not run it." | true | `cli-help/nvd.txt`, banner `==== nvd ====`, "Import results from the Novel Virus Diagnostics (NVD) Snakemake pipeline" | features.yaml:748 calls it Nextflow, which contradicts the CLI help. The CLI help outranks features.yaml, so Snakemake stands. |
| 2 | "The pipeline's main output file is named `*_blast_concatenated.csv` (or `.csv.gz`), and the importer reads it from the run's `05_labkey_bundling/` folder." | true | `cli-help/nvd.txt`, `==== nvd import ====`, argument "Path to NVD results directory (containing 05_labkey_bundling/)"; `ImportCenterViewModel.swift:494` gives the same file hint | |
| 3 | "Choose **File > Import Center…**, open the **Classification Results** tab, and pick the **NVD Results** card." | true | `MainMenu.swift:207-214`; `ImportCenterViewModel.swift:488-496` | |
| 4 | "Click **Choose** and select the NVD results directory." | false | `NvdImportSheet.swift:195` labels the button "Browse…" | "Click **Browse…** and select the NVD results directory." |
| 5 | "`lungfish nvd import /path/to/nvd-output/ --output-dir ./project/Imports/`" | true | `cli-help/nvd.txt`, `==== nvd import ====`, positional path and `-o, --output-dir` | The example writes into `Imports/`. Point it at the project root instead so the bundle lands where the app expects it. |
| 6 | "`--name` overrides the bundle name, which defaults to `nvd-<experiment>`" | true | `cli-help/nvd.txt`, `==== nvd import ====`, "--name … (default: nvd-{experiment})" | |
| 7 | "The Import-command family also offers `lungfish import nvd`, which behaves the same way." | true | `cli-help/import.txt`, `==== import nvd ====`, same argument and the same `--name` default | |
| 8 | "`lungfish nvd summary /path/to/100_blast_concatenated.csv.gz --top 20` … `--top` sets how many contigs the table shows and defaults to 20. Add `--format json` or `--format tsv`" | true | `cli-help/nvd.txt`, `==== nvd summary ====`, argument accepts "results directory or *_blast_concatenated.csv(.gz) file", `--top` defaults to 20, `--format` values text, json, tsv | |
| 9 | "A summary bar across the top reports the experiment, the sample count, and the total number of contigs." | true | `NvdResultViewController.swift:102` shows the action bar layout and the controller composes a summary bar above the outline | |
| 10 | "a detail pane sits on the left and an outline list of contigs on the right" | true | `NvdResultViewController.swift:102` and the split layout it documents | |
| 11 | "The columns include the **Sample** and **Contig** identifiers, the contig **Length**, the hit's **Classification** and **Rank**, the subject **Accession** and its **Subject** title, **Identity %**, **E-value**, **Bit Score**, **Aln Length** …, and read counts: **Mapped Reads**, **Unique Reads**, and **RPB**" | true | `NvdResultViewController.swift:1208-1287` sets exactly those thirteen titles | |
| 12 | "Expand a contig row to see the secondary BLAST hits the pipeline ranked below the best one." | true | `NvdResultViewController.swift` builds an outline view whose children are the secondary hits; `cli-help/nvd.txt`, `==== nvd ====`, "BLAST hit rankings" | |
| 13 | "A grouping control switches the outline between **By Sample** … and **By Taxon**" | true | `NvdResultViewController.swift:313` (`NSSegmentedControl(labels: ["By Sample", "By Taxon"], …)`) | |
| 14 | "A sample-filter button, labelled with the current sample count, opens a popover … and a **Search contigs…** field filters the rows" | true | `NvdResultViewController.swift:1707-1709` ("All Samples" or "N of M Samples"), `:1482` (`placeholderString = "Search contigs…"`) | |
| 15 | "For a contig with alignment data, the pane includes the full BAM viewer" | true | `ViewerViewController+Nvd.swift:60` calls `split.makeClassifierAlignmentEvidenceViewport()` | |
| 16 | "When the imported NVD reference record validates against the BAM, reference-aware mismatch and consensus inspection is available; otherwise the Inspector labels the evidence as reference-free." | unverifiable | "reference-free" appears nowhere in `Sources/`. Settling it needs the Inspector inspected during a real NVD import. | |
| 17 | "Use **Import Metadata…** in the Inspector to attach CSV or TSV sample metadata." | true | `InspectorView.swift:1155-1160` | |
| 18 | "Missing values display an em dash rather than removing the column." | unverifiable | No missing-value glyph constant was located in `NvdResultViewController.swift`. Settling it needs a run with partial metadata. | |
| 19 | "click **BLAST Verify** in the viewport's action bar" | true | `NvdResultViewController.swift:102`; `ClassifierActionBar.swift:24` | |
| 20 | "The verification submits the contig sequence to NCBI BLAST" | true | `NvdResultViewController.swift:1934-1938` routes the BLAST handler through the sequence-action builder, which acts on the contig's own sequence | |
| 21 | "The action bar's **Export** button writes the displayed results out … and its **Extract FASTQ** button pulls the reads behind the selected contigs into a fresh FASTQ dataset through the shared extraction dialog." | true | `ClassifierActionBar.swift:36-38`, `:49-51`; `NvdResultViewController.swift:1545` routes Extract FASTQ to the unified extraction dialog; `:2159-2175` exports through a TSV save panel | |
| 22 | "**Extract Reads…** reaches the same extraction dialog, while **Extract Sequence…**, **Verify with BLAST…**, **Copy FASTA**, **Export FASTA…**, **Create Bundle…**, and **Run Operation…** act on the contig's own sequence." | true | `NvdResultViewController.swift:1916-1924` ("Extract Reads…"); `FASTASequenceActionMenuBuilder.swift:79`, `:7`, `:94`, `:17`, `:123` supply the other six with those exact titles | |
| 23 | "**Copy Contig Name** and **Copy Accession** place those identifiers on the clipboard, and **View Accession on NCBI** and **Search PubMed** open the subject accession or its organism name in a browser." | true | `NvdResultViewController.swift:1956`, `:1963`, `:1973`, `:1980` set exactly those four titles | |
| 24 | "The importer expects the run to hold a `05_labkey_bundling/` folder … and it locates that file for you." | true | `NvdImportSheet.swift:202` ("Select the top-level NVD run directory (containing 05_labkey_bundling/)") | |
| 25 | "The provenance record for the import is reachable from the Inspector and names the source directory, the importing command, and the input checksums." | true | `Sources/LungfishNvdUI/NvdProvenanceView.swift`; `ClassifierActionBar.swift:74` | |
| 26 | "| NVD | Per contig (assembled, BLASTed) | Flagging novel or divergent viruses | No, import only |" | true | `cli-help/nvd.txt`, `==== nvd ====`; `FASTQOperationDialogState.swift:2070` omits NVD | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The import sheet's Preview panel, which scans and counts rows before you commit | `NvdImportSheet.swift:213-263` |
| The BLAST results drawer opens at the bottom of the NVD viewport, 220 points tall | `NvdResultViewController.swift:1898-1904` |
| BLAST Verify is disabled unless exactly one identity-backed row is selected, with the reason shown in the tooltip | `NvdResultViewController.swift:2107`, `:2128` |
| Column visibility and sorting in the contig outline, driven by the shared column-filter machinery | `NvdResultViewController.swift:1208-1287`; `LungfishKit/ColumnFilter.swift` |
| `extract reads --by-classifier --tool nvd` reproduces the GUI extraction byte for byte from the command line | `cli-help/extract.txt`, `==== extract reads ====`, "By Classifier Selection (--by-classifier)" |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `nvd-import-card` (planned) | Yes | `ImportCenterViewModel.swift:488-496` defines exactly that card on the Classification Results tab. |
| Its marker placement | Yes | It sits in step 1 beside the Import Center instruction. |
| `nvd-result-viewport` (planned) | Yes, with a caption fix | The expanded contig row, the detail pane, and the full BAM viewer are all real. The caption should also name the By Sample and By Taxon grouping control and the Search contigs… field, since the chapter covers both (`NvdResultViewController.swift:313`, `:1482`). |

## 10-twelve-s-metabarcoding.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "The default matching mode is `illumina-exact`, which accepts only exact embedded reference matches (no substitutions)." | true | `cli-help/fastq.txt`, banner `==== fastq 12s-match ====`, "--matching-mode … 'illumina-exact' (exact embedded reference matches only; default)" | |
| 2 | "A second mode, `ont-indel`, tolerates insertion or deletion differences for Oxford Nanopore reads" | true | Same banner, "'ont-indel' (allow indel-only fallback)" | |
| 3 | "The default policy (`strict`) lets any nonzero lead win." | true | Same banner, "--ambiguity-resolution … 'strict' (any nonzero abundance lead wins; default)"; `TwelveSAbundanceReassigner.swift:134-135` | |
| 4 | "A `conservative` policy requires the winner to have at least twice the runner-up and at least ten reads, otherwise the read stays unresolved." | true | Same banner; `FastqTwelveSMatchSubcommand.swift:62` maps `"conservative"` to `.conservative(minFoldRatio: 2.0, absoluteFloor: 10)`; `TwelveSAbundanceReassigner.swift:136-140` | |
| 5 | "Lungfish runs a chimera review over the unresolved clusters and marks likely chimeras" | true | `cli-help/fastq.txt`, `==== fastq 12s-match ====`, "--chimera-review/--no-chimera-review Run vsearch chimera review on unresolved sequences (default: --chimera-review)"; `TwelveSChimeraReview.swift` | |
| 6 | "Open the Workflow Library and choose **12S Amplicon Matching**." | true | `MainMenu.swift:766-772` adds "Workflow Library…"; `WorkflowLibrary.swift:141-149` defines the item with `title: "12S Amplicon Matching"` | Add that the workflow is specialized, so it must be enabled in the Workflow Library before it appears in the menus, and that once enabled it also opens from `Tools > Genotyping > 12S Amplicon Matching…` (`WorkflowLibrary.swift:145-146`, `MainMenu.swift:794-798`). |
| 7 | "Leave the matching mode on the default for Illumina reads, or switch it to the Nanopore mode" | changed | `WorkflowOperationsDialog.swift:350-360` labels the control **Read Platform**, a segmented picker | "Leave the **Read Platform** picker on the Illumina setting, or switch it to the Nanopore setting" |
| 8 | "The workflow merges any remaining paired reads, matches them, resolves cross-species reads, reviews unresolved clusters for chimeras, and writes a result bundle into your project." | false | `WorkflowOperationsDialog.swift:522-524` states "The 12S workflow expects merged FASTQ inputs; paired-read merging should be handled before import." | "The workflow matches the merged reads, resolves cross-species reads, reviews unresolved clusters for chimeras, and writes a result bundle into your project. It does not merge pairs for you, so merge them first with the read-processing operation." |
| 9 | "It opens on the **Targets** view, which is the species table." | true | `TwelveSAmpliconResultViewController.swift:234` (`labels: ["Targets", "Unresolved"]`), `:492` calls `showTargets()` on load | |
| 10 | "Each row is one species, with its scientific name, common name, taxon group (for example Fish or Mammal), taxid, and the number of reads that matched it exactly." | changed | `TwelveSTargetTableView.swift:156-164` defines Sample, Scientific Name, Common Names, Group, Tax ID, Exact Reads, % of Sample, Refs, and Alternates | "Each row is one species, with columns for Sample, Scientific Name, Common Names, Group (for example Fish or Mammal), Tax ID, Exact Reads, % of Sample, Refs (how many reference records it matched), and Alternates (how many other species share its sequence)." |
| 11 | "The summary line at the top reports the sample count, the total exact reads, the percent of reads left unresolved, and the number of chimera candidates." | unverifiable | The controller composes a summary bar, but the four named figures could not be confirmed from `TwelveSAmpliconResultViewController.swift`. Settling it needs the summary bar's own source or a run. | |
| 12 | "use the filter field to narrow by species or taxon group" | true | `cli-help/fastq.txt`, `==== fastq 12s-export ====`, `--filter` matches "species, common-name, taxon, or alternate-match text"; the viewport carries the matching filter row | |
| 13 | "Some rows carry an alternate-match note." | true | `TwelveSTargetTableView.swift:164` defines the Alternates column; `cli-help/fastq.txt`, `==== fastq 12s-export ====`, `--require-alternate-matches` | |
| 14 | "two controls appear above the species table (both stay hidden for a single-sample result)" | true | `TwelveSAmpliconResultViewController.swift:403` exposes `testingSampleFilterButtonHidden`; `:240` and `:299` define the two buttons | |
| 15 | "The sample-filter button, labelled with the current selection (for example **All Samples**)" | true | `TwelveSAmpliconResultViewController.swift:240`, `:574` | |
| 16 | "Per-sample **Reads** and **% of sample** columns are added automatically when eight or fewer samples are selected, and are suppressed above that count" | true | `TwelveSAmpliconResultViewController.swift:298` (`autoReadsColumnSampleLimit = 8`), `:545-551` | |
| 17 | "The **Sample Columns** menu carries an **Import Metadata…** item that loads a CSV or TSV of per-sample metadata" | true | `TwelveSAmpliconResultViewController.swift:299` (button title "Sample Columns"), `:647` (menu item "Import Metadata…") | |
| 18 | "Switch the view to **Unresolved**. This table lists the unresolved sequence clusters, each with its sequence, its read count, and a chimera status." | true | `TwelveSAmpliconResultViewController.swift:234`, `:243` (`TwelveSUnresolvedTableView`); `cli-help/fastq.txt`, `==== fastq 12s-export ====`, `--chimera-status` values "all, notReviewed, notDetected, candidate, confirmed" | |
| 19 | "Select one or more unresolved clusters and click **BLAST Verify** in the action bar." | true | `TwelveSAmpliconResultViewController.swift:313` (`onUnresolvedBlastRequested`), `:856-858`; `ClassifierActionBar.swift:24` | |
| 20 | "The hits appear in a drawer below the table with their species, percent identity, and accession" | true | `BlastResultsDrawerTab.swift:215-225` defines Organism, Identity, and Accession columns | |
| 21 | "Click **Export** to write the current table out. The species table exports to CSV, TSV, or Excel (`.xlsx`)" | true | `TwelveSAmpliconResultExportService.swift:8-28` defines csv, tsv, and excel with the `.xlsx` extension; `TwelveSAmpliconResultViewController.swift:1576-1589` builds "Export as CSV...", "Export as TSV...", "Export as Excel..." | |
| 22 | "the Excel export adds the unresolved rows as a second sheet" | true | `cli-help/fastq.txt`, `==== fastq 12s-export ====`, `--min-unresolved-reads` and `--chimera-status` are both documented "for Excel export" | |
| 23 | "the workflow also writes an `unresolved-sequences.fasta` into the result bundle automatically" | unverifiable | `TwelveSAmpliconMatchingWorkflow.swift` writes the bundle, but that file name could not be confirmed. Settling it needs the bundle-writing code or a run. | |
| 24 | "`lungfish fastq 12s-match merged.fastq.gz --reference vertebrate-12s.fasta --output-dir results --output-name diet-run`" | true | `cli-help/fastq.txt`, `==== fastq 12s-match ====`, usage requires `<inputs> ... --reference --output-dir --output-name` | |
| 25 | "`--ambiguity-resolution conservative`" | true | Same banner | |
| 26 | "`lungfish fastq 12s-export --bundle results/diet-run.lungfish12s --export-format csv --output species.csv`" | true | `cli-help/fastq.txt`, `==== fastq 12s-export ====`, usage requires `--bundle --export-format --output` | |
| 27 | "`lungfish fastq 12s-export-unresolved --bundle results/diet-run.lungfish12s --min-reads 5 --output unresolved.fasta`" | true | `cli-help/fastq.txt`, `==== fastq 12s-export-unresolved ====`, `--min-reads` defaults to 5 | |
| 28 | "The `--reference` for `12s-match` accepts either a plain deduplicated FASTA or a prepared `.lungfish12sref` bundle" | true | `cli-help/fastq.txt`, `==== fastq 12s-match ====`, "--reference … Deduplicated 12S reference FASTA or .lungfish12sref bundle" | |
| 29 | "`--sample-metadata` takes a CSV or TSV of per-sample metadata …, and `--reference-metadata` takes a target metadata TSV, overriding the bundled one when both are present" | true | Same banner, both options documented | |
| 30 | "Use `--min-exact-reads` …, `--filter` …, and `--taxon-group` or `--exclude-taxon-group` … `--exclude-human` drops Homo sapiens (taxid 9606) rows, and `--require-alternate-matches` keeps only rows that carry an alternate-match note." | true | `cli-help/fastq.txt`, `==== fastq 12s-export ====`, all six options present with those meanings including the taxid 9606 wording | |
| 31 | "`--include-chimera-candidates` adds sequences flagged as candidate or confirmed chimeras … `--sequence-id` (repeatable) exports only the named clusters, and `--metadata-output` writes a companion TSV" | true | `cli-help/fastq.txt`, `==== fastq 12s-export-unresolved ====`, all three options present with those meanings | |
| 32 | "Lungfish resolves these by abundance: it looks at how many reads unambiguously support each candidate species elsewhere in the sample and reassigns the shared read to the most abundant candidate." | true | `TwelveSAbundanceReassigner.swift:58-141` computes per-sample and global unambiguous totals then picks the top species by policy | |
| 33 | "Reassigned reads are tracked in their own channel and never quietly folded into the exact-match counts" | true | `TwelveSAbundanceReassigner.swift:62` accumulates a `moves` array recording every reassignment | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The dialog's **Min Soft Clip** field, which sets how many read bases must flank the matched target | `WorkflowOperationsDialog.swift:332`; `cli-help/fastq.txt`, `==== fastq 12s-match ====`, "--min-soft-clip … (default: 1)" |
| The Advanced Options disclosure's **Max Indels** field, enabled only in the Nanopore mode | `WorkflowOperationsDialog.swift:519-520`; `cli-help/fastq.txt`, "--max-indels … (default: 3)" |
| The Advanced Options disclosure's **Run vsearch chimera review** toggle | `WorkflowOperationsDialog.swift:521` |
| The sample-metadata picker in the dialog, with **Choose Metadata…** and **Replace Metadata…** | `WorkflowOperationsDialog.swift:268-282` |
| A reference-bundle draft builder in the dialog, for turning a FASTA plus MIDORI metadata into a `.lungfish12sref` bundle in place | `WorkflowOperationsDialog.swift:61`, `:140`, `:175-178` |
| `fastq 12s-reference-metadata`, which builds the target metadata TSV from a dedup FASTA plus a MIDORI metadata TSV | `cli-help/fastq.txt`, `==== fastq 12s-reference-metadata ====` |
| `fastq 12s-reference-bundle`, which packages that pair into a reusable `.lungfish12sref` bundle | `cli-help/fastq.txt`, `==== fastq 12s-reference-bundle ====` |
| `12s-match --force`, which replaces an existing output bundle | `cli-help/fastq.txt`, `==== fastq 12s-match ====` |
| The viewport's Provenance popover | `TwelveSAmpliconResultViewController.swift:390-392`, `:1596-1605` |
| 12S Amplicon Matching is a specialized workflow that must be enabled before it appears, and it lives under Genotyping | `WorkflowLibrary.swift:145-147` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `twelve-s-workflow-library` (planned) | Yes, with a caption fix | The caption says "the merged FASTQ and reference FASTA inputs listed". The dialog also carries the Read Platform picker, Min Soft Clip, the metadata picker, and the Advanced Options disclosure, all of which the chapter must now cover. Widen the caption or add a second shot of the dialog's options. |
| Its marker placement | No | The marker sits at the end of the "What it is" section, before the procedure begins. Move it into step 1, where the reader is told to open the workflow. |
| `twelve-s-result-species-table` (planned) | Yes, with a caption fix | The Targets table exists. The caption names only per-species read counts, but the real table also shows Sample, Common Names, Group, Tax ID, % of Sample, Refs, and Alternates (`TwelveSTargetTableView.swift:156-164`). |
| `twelve-s-unresolved-clusters` (planned) | Yes | `TwelveSAmpliconResultViewController.swift:234`, `:243` confirm the Unresolved view and its table. |
| `twelve-s-blast-review` (planned) | Yes | The unresolved BLAST path is real (`TwelveSAmpliconResultViewController.swift:313`, `:856-858`). |
| `twelve-s-export` (planned) | No, as captioned | The caption says the export control writes "CSV, TSV, Excel, or FASTA". The viewport's Export menu offers only CSV, TSV, and Excel (`TwelveSAmpliconResultExportService.swift:8-11`), and the FASTA export of unresolved clusters is command-line only, which the chapter itself says. Recaption to name the three formats the menu offers. |
