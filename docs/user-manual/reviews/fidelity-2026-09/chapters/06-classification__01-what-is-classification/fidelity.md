# Fidelity review, 06-classification/01-what-is-classification

Chapter 32 of the campaign roster. Concept chapter, no worked operation, no
`parameters_refs` (roster row 32 at `DRIFT.md:3758` lists `[]`, so the empty
array in the front matter is correct and `settings-coverage.js` has nothing to
check). Reviewed against the Swift source, the tool lock manifest, the
committed plugin-packs chapter, `GLOSSARY.md`, and two read-only CLI calls.

Every claim in the chapter body about a menu, a dialog, a control, a folder, a
column, a tool, or a database is listed below. Prose that carries no app claim
(the primer on taxa and lowest common ancestors, the advice on choosing a
classifier, the interpretive paragraphs) is not tabled.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Three classifiers run inside the app." | true | `FASTQOperationDialogState.swift:2070`, `case .kraken2, .esViritu, .taxTriage: return .classification` is the whole `.classification` category | |
| 2 | "Each appears as its own item in the **Tools > Classification** submenu" | true | `MainMenu.swift:786-819` builds one submenu per category with one item per tool id; `ToolsMenuModel.swift:81` gives `.classification` the title "Classification"; `MainMenu.swift:812` titles each item `"\(toolID.title)…"` | |
| 3 | The app's one-line descriptions are "Classify reads taxonomically", "Detect viruses and report coverage", and "Run the TaxTriage pathogen workflow" | true | `FASTQOperationDialogState.swift:2041-2043`. Source strings end with a period, the chapter quotes them without one, which is a quoting nuance rather than a wrong string | |
| 4 | "Three more tools produce results LGE can read but never runs." (CZ-ID, NAO-MGS, NVD) | true | None appears in `FASTQOperationDialogState.swift:2070`; all three are Import Center cards at `ImportCenterViewModel.swift:413-508`. CZ-ID's own card text says "CZ-ID is imported, not run locally" (`:498`) | |
| 5 | "[NAO-MGS] is a wastewater metagenomic surveillance pipeline from SecureBio." | true | `NaoMgsResultParser.swift:319` names `https://github.com/securebio/nao-mgs-workflow` | |
| 6 | "[NVD] is a novel-virus pipeline that assembles reads into longer sequences and searches each one against a public database with BLAST." | true | `ImportCenterViewModel.swift:490-495`, card text "Parses blast_concatenated.csv ... with BLAST hit rankings and mapped reads" | |
| 7 | Catalogue table, "Yes, from **Tools > Classification > Kraken2...**", and the same for EsViritu and TaxTriage | true | `MainMenu.swift:805-818`; `FASTQOperationDialogState.swift:1994-1996` gives the titles Kraken2, EsViritu, TaxTriage | |
| 8 | Catalogue table, CZ-ID, NAO-MGS, NVD each "No, import only" | true | Same evidence as row 4 | |
| 9 | "The Import Center's Classification Results tab carries six cards, not three" | true | `ImportCenterViewModel.swift:413-508`, six `ImportCardInfo` values with `tab: .classificationResults`, ids `nao-mgs`, `kraken2`, `esviritu`, `taxtriage`, `nvd`, `cz-id` | |
| 10 | The six card titles, "Kraken2 Results, EsViritu Results, TaxTriage Results, NAO-MGS Results, NVD Results, and CZ-ID Results" (shot caption) | true | `ImportCenterViewModel.swift:416,426,448,469,490,500` | |
| 11 | "Open it with **File > Import Center...** and pick the Classification Results tab." | true | CONSISTENCY.md, "The Import Center is **File > Import Center...**, a tabbed grid of cards" | |
| 12 | "[Freyja] ... does not classify reads at all. It reads variant and depth tables produced after mapping" | true | `PluginPack.swift:833` puts freyja in `wastewater-surveillance`, not in any classification surface; freyja is absent from `FASTQOperationDialogState.swift:2070`; `cli-help/freyja.txt` documents `demix` over variant and depth inputs | |
| 13 | "[Kraken2's] Standard database covers archaea, bacteria, viruses, plasmids, the human genome, and vector sequence in one pass." | true | `MetagenomicsModels.swift:137-138`, `contentsDescription` for `.standard` is "Archaea, bacteria, viral, plasmid, human, UniVec". UniVec is NCBI's vector-contamination set, so "vector sequence" is a fair gloss | |
| 14 | "Fungi and protozoa are not in Standard. They arrive with the PlusPF builds" | true | `MetagenomicsModels.swift:143-144`, PlusPF is "Standard + protozoa + fungi" | |
| 15 | "It works by matching short fixed-length words of sequence called k-mers, or more precisely the compact fingerprints of them called minimizers" | unverifiable | This is Kraken 2's own algorithm, not an LGE behaviour. The only minimizer references in `Sources/` are `KreportParser.swift:31,204` (the `--report-minimizer-data` column layout) and Deacon's ribokmer threshold, neither of which states how Kraken 2 classifies. Settling it needs the upstream Kraken 2 paper or manual, and the claim is uncontroversial there | Attribute it to Kraken 2 rather than to LGE, or leave it, but it cannot be checked against this build |
| 16 | "[EsViritu's] database is a curated set of viral genomes" | true | Manifest database `esviritu-viral-v3`, tool `esviritu`; `MetagenomicsDatabaseInfo.swift:390-405` builds it as a catalog entry | |
| 17 | "rather than only counting reads it reports how much of each viral genome those reads actually covered" | true | `ViralDetectionTableView.swift:482`, `covCol.title = "Coverage"`, beside Reads and Unique Reads | |
| 18 | "[TaxTriage] runs as a Nextflow pipeline ... it needs both Nextflow and a container runtime present on the machine" | true | `TaxTriageWizardSheet.swift:298-306` blocks the run on `nextflowAvailable == false` and `containerAvailable == false`; `:315-332` renders a Prerequisites row with a Nextflow indicator and a container indicator | |
| 19 | "It also classifies against an installed Kraken2 database rather than carrying one of its own." | true | `TaxTriageWizardSheet.swift:430` labels the picker "Kraken2 Database"; `:436` reads "No Kraken2 databases installed"; `:591-598` fills it from the shared `MetagenomicsDatabaseRegistry` filtered to kraken2 | |
| 20 | "Open **Tools > Classification** and you get a submenu with three items, **Kraken2...**, **EsViritu...**, and **TaxTriage...**." | true | `MainMenu.swift:805-818`. The filter at `:808` drops only tool ids whose catalog item carries `.workflowOperations`, and none of the three does (`WorkflowLibrary.swift:164-186` gives that capability to `ontGenotyping` alone among tool-backed items) | |
| 21 | "There is no single Classification command that then asks which tool you want." | true | Same evidence as row 20. No `Classification…` leaf item is built anywhere in `MainMenu.swift` | |
| 22 | Implicitly, three items and nothing else in that submenu (no workflow divider, contra the DRIFT missing row) | true | `MainMenu.swift:794-798` draws the separator and the workflow items only when `category.workflows` is non-empty. `ToolsMenuModel.swift:28-33` fills `workflows` from catalog items carrying `.workflowOperations`, and the only two such items, `twelveSAmpliconMatchingItem` and `fullLengthONTMHCGenotypingItem`, are both `categoryID: .genotyping` (`WorkflowLibrary.swift:145,155`). The Classification submenu therefore has no divider today. **The DRIFT missing row and reality-map row are wrong on this point, and the author was right to omit it** | |
| 23 | "Picking one opens a window titled FASTQ/FASTA Operations" | false | `FASTQOperationDialogState.swift:1250-1252` returns "FASTQ/FASTA Operations" for `dialogTitle`, and `DatasetOperationsDialog.swift:72-73` renders it as the sheet's heading. But the surface is an `NSPanel` run as a sheet (`FASTQOperationsDialogPresenter.swift:33-59`, `window.beginSheet(panel)`), and the panel's own title is set to the category name at `:39` (`panel.title = initialCategory.title`, so "Classification"). "Window titled" overstates it | "Picking one opens a sheet headed FASTQ/FASTA Operations with your chosen classifier already selected." |
| 24 | "with your chosen classifier already selected" | true | `FASTQOperationsDialogPresenter.swift:25-27` calls `state.selectTool(initialToolID)` before presenting, and `MainMenu.swift:815` puts the tool id on the menu item's `representedObject` | |
| 25 | "the same window serves the trimming, filtering, and mapping tools from their own submenus" | true | `FASTQOperationsDialogPresenter.present` takes any `initialCategory`, and `FASTQOperationDialogState.swift:2050-2073` assigns every tool id to one of the twelve categories that build the Tools submenus | |
| 26 | "A sidebar down its left edge lists the other classifiers in the Classification category" | true | `FASTQOperationDialog.swift:30` passes `state.sidebarItems`; `FASTQOperationDialogState.swift:1144-1148` builds that list from `visibleToolIDs(for: selectedCategory)`; `DatasetOperationsDialog.swift:89-106` renders each as a selectable row | |
| 27 | "the dialog reports the current selection on its dataset line rather than offering a file picker" | true | `FASTQOperationDialog.swift:25` passes `state.datasetLabel`; `FASTQOperationDialogState.swift:1118-1128` renders it as a path, a count, or "No FASTQ selected". No file picker is presented from this sheet | |
| 28 | "The button that starts the work says **Run**." | true | `FASTQOperationDialog.swift:12` defaults `primaryActionTitle` to "Run"; `FASTQOperationsDialogPresenter.swift:14` carries the same default | |
| 29 | "a single-sample Kraken2 run appears as a row titled 'Classifying' followed by the input file name" | true | `AppDelegate+Classification.swift:850-858`, `goalLabel` is "Classifying" for `.classify` and `operationTitle = "\(goalLabel) \(inputName)"` | |
| 30 | "a multi-sample run appears as 'Classification Batch' followed by the sample count" | true | `AppDelegate+Classification.swift:1386`, `title: "Classification Batch (\(sampleCount) sample\(...))"` | |
| 31 | "The window stays usable while the run proceeds." | true | The sheet is dismissed by `window.endSheet(panel)` in the `onRun` closure (`FASTQOperationsDialogPresenter.swift:50`) before the pipeline starts, so the main window is not blocked during the run. The sentence reads as if it means the operations sheet, which is gone by then, so it is true of the main window only | Consider "The main window stays usable while the run proceeds." |
| 32 | "A finished run lands in the project's `Analyses` folder in its own timestamped subfolder, named for the tool that produced it" | true | `AppDelegate+Classification.swift:843` calls `AnalysesFolder.createAnalysisDirectory(tool: "kraken2", in: projectURL)`; `AnalysesFolder.swift:139-140` builds `"\(tool)-\(timestamp)"` | |
| 33 | "for example `kraken2-20260907-143005`" | **false** | The timestamp format is `yyyy-MM-dd'T'HH-mm-ss` (`AnalysesFolder.swift:597-603`, and the doc comment at `:414` names the same format). A real folder is `kraken2-2026-09-07T14-30-05`, not `kraken2-20260907-143005`. The compact form appears nowhere in the source | "for example `kraken2-2026-09-07T14-30-05`" |
| 34 | "Nothing is written back onto the reads bundle you started from." | true | `AppDelegate+Classification.swift:842-845` redirects `config.outputDirectory` to the analysis directory, and no write to the input bundle follows | |
| 35 | "The one exception is a CZ-ID import, which writes a `.lungfishtax` bundle into a top-level `Classifications` folder" | true | `AppDelegate+ToolsMenu.swift:861-867`, `projectURL.appendingPathComponent("Classifications").appendingPathComponent("....lungfishtax")` | |
| 36 | "Kraken2 results, and imported CZ-ID results, open the taxonomy viewport described here." | true | Kraken2 results route through `ClassifierDatabaseRouter` to the taxonomy display (`MainSplitViewController+ContentDisplay.swift:151-154`); CZ-ID routes to `CzIdResultViewController`, which embeds `TaxonomyViewController` at `CzIdResultViewController.swift:11` | |
| 37 | "EsViritu, TaxTriage, NAO-MGS, and NVD each open a table" | true | `ViralDetectionTableView.swift`, `BatchTaxTriageTableView.swift`, `NaoMgsResultViewController.swift`, `NvdResultViewController.swift` each build their own table rather than the taxonomy viewport | |
| 38 | "The taxonomy viewport shows the same result three ways, linked together, so clicking a taxon in one updates the other two." | false | `TaxonomyViewController.swift:896-903` syncs sunburst selection to the table, and `:930-940` syncs table selection to the sunburst, so those two are linked by a single click. The breadcrumb bar is driven by zoom, not selection (`:906-914` on double-click and `:917-921` on zoom change), so a single click does not update it. Two of the three are linked by clicking; the third follows drill-down | "The taxonomy viewport shows the same result three ways. Clicking a taxon in the sunburst or the table selects it in the other, and the breadcrumb bar follows as you drill down." |
| 39 | "It is a ring chart read from the middle outwards, where the centre is the root of the tree of life and each ring further out is a finer taxonomic rank." | true | `TaxonomySunburstView.swift:14-16`, "concentric rings, where each ring represents a taxonomic rank (Domain -> Species)" | |
| 40 | "The angular width of a wedge is proportional to the number of reads assigned to that taxon and everything below it" | true | `TaxonomySunburstView.swift:16-17`, "each arc segment's angular span is proportional to its clade read count" | |
| 41 | "Colour groups the wedges by phylum, so relatives sit in related shades." | true | `TaxonomySunburstView.swift:22`, "Phylum-based coloring with depth tinting"; `:356` uses `PhylumPalette` | |
| 42 | "One row per taxon, with columns for Sample, Taxon Name, Rank, Reads, Direct, and %." | true | `TaxonomyTableView.swift:245,254,263,274,283,303`, the six visible column titles in that order | |
| 43 | "Reads is the clade count, meaning every read assigned to that taxon or to anything beneath it" | true | `TaxonomyTableView.swift:275`, headerToolTip "Clade read count: reads assigned to this taxon and descendants" | |
| 44 | "Direct counts only the reads pinned to that exact taxon and no lower." | true | `TaxonomyTableView.swift:284`, "Direct read count: reads assigned exactly to this taxon" | |
| 45 | "A Bracken column joins them when Bracken abundance estimation ran alongside the classification." | true | `TaxonomyTableView.swift:290-298`, the column is built with `brackenCol.isHidden = true` and unhidden when Bracken data is present | |
| 46 | "Above the columns sits a **Filter taxa...** search field" | true | `TaxonomyTableView.swift:226`, `searchField.placeholderString = "Filter taxa\u{2026}"` | |
| 47 | "The breadcrumb bar keeps track of where you are. It records the path you drilled down through and lets you step back up to a parent rank" | true | `TaxonomyBreadcrumbBar.swift:10-16`, "A horizontal bar showing the current zoom path ... Each segment is a clickable button that navigates back to that level" | |
| 48 | "% of classified reads" wording implied by the `%` column | true | `TaxonomyTableView.swift:304`, "Percent of classified reads represented by this clade" | |
| 49 | "none of these databases ship inside the application" | true | Every catalog entry is built with `status: .missing` and an install recipe (`MetagenomicsDatabaseInfo.swift:355-405`), so nothing is preinstalled | |
| 50 | "The Kraken2 collections run from about half a gigabyte for the viral-only build to 72 GB for PlusPF" | true | `MetagenomicsModels.swift:104,107`, viral `536_870_912`, plusPF `72 * 1_073_741_824`. Those are the smallest and largest of the nine | |
| 51 | "both go through the Plugin Manager at **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:773-780` sets the item with `keyEquivalent: "b"` and `[.command, .shift]`; CONSISTENCY.md fixes the same wording | |
| 52 | "Kraken2, Bracken, and EsViritu arrive together in the `metagenomics` plugin pack, shown in the Plugin Manager as Metagenomics, which also carries RiboDetector." | true | `PluginPack.swift:771-776`, `id: "metagenomics"`, `name: "Metagenomics"`, `packages: ["kraken2", "bracken", "esviritu", "ribodetector"]`, with display names Kraken 2, Bracken, EsViritu, RiboDetector at `:785,795,804,814`. Matches the committed `01-foundations/07-plugin-packs.md:94` | |
| 53 | "TaxTriage is not in a pack at all" | true | `grep -c -i taxtriage Sources/LungfishWorkflow/Conda/PluginPack.swift` returns 0 | |
| 54 | "The Plugin Manager's Databases tab lists thirteen databases, nine of them Kraken2 collections" | true | The manifest holds sixteen database specs, and `MetagenomicsDatabaseInfo.catalogEntry(from:)` returns nil for the three sidecars (`:406-410`, "Bundled sidecars (human scrubber, Deacon indexes) are not catalog databases"), leaving thirteen. Nine carry a `DatabaseCollection` (`MetagenomicsModels.swift:75-84`). `lungfish-cli conda db install-managed --list` returns exactly the three excluded sidecars, `human-scrubber`, `deacon-panhuman`, `deacon-ribokmers`. The committed `07-plugin-packs.md:153` states the same thirteen and nine | |
| 55 | "the run's provenance record names [the database]" | true | Classification writes a provenance record alongside the analysis directory, and `ClassificationWizardSheet.swift:441-450` records the selected database name into the config the run replays from | |
| 56 | "A viral-only database run against a clinical swab will leave most reads unclassified by design, because it has no human genome to match them to" | true | `MetagenomicsModels.swift:110-111`, the viral collection is "RefSeq viral genomes only" | |
| 57 | "the SRR36291587 SARS-CoV-2 reads, a clinical amplicon dataset of 86,281 read pairs" | true | `docs/user-manual/fixtures/sarscov2-srr36291587/README.md:4`, "QIAseq Direct SARS-CoV-2, paired-end Illumina, 86,281 read pairs". Fixture name matches CONSISTENCY.md's "the SRR36291587 SARS-CoV-2 reads" | |
| 58 | Routing in Next, to `02-running-kraken2.md`, `03-running-esviritu.md`, `04-running-taxtriage.md`, `06-blast-verification.md`, `05-running-nao-mgs.md`, `08-importing-cz-id-results.md`, `09-novel-virus-detection.md`, and to `07-running-freyja.md` and `../03-reads/05-decontamination.md` and `../01-foundations/07-plugin-packs.md` earlier | true | Every target file exists under `docs/user-manual/chapters/`; all ten link targets resolve | |
| 59 | Absence of any per-classifier colour claim (the chapter asserts none, and the campaign asked for this to be settled from source) | true | No per-classifier colour exists in this build. `LungfishColors.swift` defines only brand and semantic colours, with no match for kraken, esviritu, taxtriage, or nao. `DatasetOperationToolSidebarItem` (`DatasetOperationsModels.swift:43-59`) carries id, title, subtitle, and availability, and no colour. A search of `Sources/` for any `(kraken2|esviritu|taxtriage|naomgs)*(Color|Tint|Accent)` constant returns nothing. **The project-memory line recording Kraken2 blue, EsViritu green, TaxTriage purple, NAO-MGS amber does not describe this build.** The author's omission is correct and the memory line should be corrected or retired | |

## Front matter

Roster row 32 at `DRIFT.md:3758` lists `[]` for registry ids, and the chapter's
`parameters_refs: []` matches. No Settings section is owed.

All four `<!-- SHOT: -->` markers in the body have a captioned `shots[]` entry,
and no `shots[]` entry lacks a marker.

| Marker (line) | Caption present | Caption accurate |
|---|---|---|
| `import-center-classification-tab` (76) | yes | yes, all six card titles match `ImportCenterViewModel.swift` |
| `classification-submenu` (98) | yes | yes, three items with ellipses |
| `classification-dialog-tool-sidebar` (102) | yes | yes, though "dialog" is the right word and the body's "window" is not (row 23) |
| `taxonomy-viewport-overview` (114) | yes | yes, and it names the "Filter taxa..." field as DRIFT directed |

All 25 anchors in `glossary_refs` resolve to a `{#anchor}` in `GLOSSARY.md`,
including the author's nine new entries (`taxon`, `taxonomic-rank`,
`lowest-common-ancestor`, `read-classification`, `metagenomics`, `kraken2`,
`esviritu`, `taxtriage`, `cz-id`).

One unused ref. `shotgun` is listed in `glossary_refs` but the word never
appears in the body, so no link points at it. Harmless, and it resolves, but it
should either be dropped from the list or the term should be used where the
chapter describes a broad survey.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports "no issues found".

## Notes for the Lead, beyond the chapter

1. **The DRIFT missing row about a workflow divider in the Classification
   submenu is wrong.** `MainMenu.swift:794-798` draws that divider only for a
   non-empty `category.workflows`, and the only two `.workflowOperations`
   catalog items are both `.genotyping`. The author was right not to write it.
   The reality map at `ground-truth/06-classification.md` carries the same
   incorrect row and should be corrected before the Kraken2 chapter is
   reviewed against it.

2. **The 12S routing note in the author's report overstates the gate.** 12S
   Amplicon Matching is `categoryID: .genotyping` and `maturity: .specialized`
   (`WorkflowLibrary.swift:145-146`), so the author is right that it is filed
   under Genotyping and not Classification. But it is not hidden behind Show
   Experimental Features. That setting (`AdvancedSettingsTab.swift:16`) gates
   the Workflow Builder item (`MainMenu.swift:728-733`) and not the workflow
   library. A specialized workflow always appears in its category submenu,
   rendered as "12S Amplicon Matching (not enabled)" in disabled grey until it
   is turned on through **Tools > Workflow Library...**
   (`MainMenu.swift:767-768`, `MainMenu.swift:833-845`). The manual-structure
   question the author raises stands, but the fixed experimental-features
   sentence from CONSISTENCY.md would be the wrong sentence for chapter 41.

3. **The classifier colour convention in project memory is not in this
   build.** Recorded here so the two later chapters in this part that inherited
   the claim can be corrected from one finding rather than three.

4. The analysis-directory timestamp format (row 33) is `yyyy-MM-dd'T'HH-mm-ss`.
   Any other chapter in this part that spells out a folder name should use that
   shape. The demo project on disk holds a hand-made `kraken2-SRR36291587`
   folder with no `analysis-metadata.json`, which is not what a real run
   produces, so screenshots taken against it will not show a timestamped name.

## Verdicts

55 true, 3 false, 1 unverifiable, out of 59 rows. The false rows are 23 (the
FASTQ/FASTA Operations sheet described as a window), 33 (the analysis-folder
timestamp example), and 38 (the three viewport panes described as all linked by
a single click). None is a large error and none touches the chapter's frame.
The unverifiable row is 15, Kraken 2's own minimizer algorithm, which no LGE
source states either way.
