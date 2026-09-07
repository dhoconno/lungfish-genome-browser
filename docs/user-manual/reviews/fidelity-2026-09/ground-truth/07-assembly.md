# Reality map: 07-assembly

Covers the four chapters under `docs/user-manual/chapters/07-assembly/`.
Ground truth is the Swift source first, then the CLI help dumps under
`docs/user-manual/reviews/fidelity-2026-09/cli-help/`, then the managed tool
lock, and only then `features.yaml`. The June 2026 map at
`docs/user-manual/reviews/part-ii-fidelity-2026-06-02/ground-truth/07-assembly.md`
was consulted and every row reused from it was re-verified against current
source. Two of its headline findings are themselves now stale. The Assembly
menu is no longer one leaf item, it is a per-tool submenu, and the parent menu
is no longer called "FASTQ/FASTA Operations".

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/ToolsMenuModel.swift`
- `Sources/LungfishApp/Services/WorkflowLibrary.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
- `Sources/LungfishApp/Views/Assembly/AssemblyWizardSheet.swift`
- `Sources/LungfishApp/Views/Viewer/ViewerViewController+Assembly.swift`
- `Sources/LungfishApp/Views/Viewer/ViewerViewController.swift`
- `Sources/LungfishApp/Views/Sidebar/SidebarViewController+MenuDelegate.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyTool.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyReadType.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyCompatibility.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyOptionCatalog.swift`
- `Sources/LungfishWorkflow/Assembly/ManagedAssemblyPipeline.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyOutputNormalizer.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyBundleBuilder.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyRunRequest.swift`
- `Sources/LungfishWorkflow/Conda/PluginPack.swift`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `Sources/LungfishIO/Bundles/AnalysesFolder.swift`
- `Sources/LungfishAssemblyUI/AssemblyResultViewController.swift`
- `Sources/LungfishAssemblyUI/AssemblyContigTableView.swift`
- `Sources/LungfishAssemblyUI/AssemblyContigDetailPane.swift`
- `Sources/LungfishAssemblyUI/AssemblySummaryStrip.swift`
- `Sources/LungfishAssemblyUI/AssemblyActionBar.swift`
- `Sources/LungfishAssemblyUI/AssemblyContigMaterializationAction.swift`
- `Sources/LungfishAssemblyUI/AssemblyLayoutPreference.swift`
- `Sources/LungfishKit/FASTASequenceActionMenuBuilder.swift`
- `Sources/LungfishCLI/Commands/AssembleCommand.swift`
- `Sources/LungfishCLI/Commands/ExtractContigsCommand.swift`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/assemble.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/extract.txt`
- `docs/user-manual/features.yaml`

## Findings that recur across all four chapters

Three errors repeat in every chapter and are recorded once per chapter in the
tables below.

1. The menu path `Tools > FASTQ/FASTA Operations > Assembly…` does not exist.
   The Tools menu is built from operation categories, one submenu per category,
   with one leaf item per tool. The real path is `Tools > Assembly > SPAdes…`,
   and likewise `MEGAHIT…`, `SKESA…`, `Flye…`, `Hifiasm…`.
   `MainMenu.swift:703-706` builds a category submenu per
   `ToolsMenuModel.Category`; `MainMenu.swift:786-819` fills each submenu with
   one `"\(toolID.title)\u{2026}"` item per tool; `ToolsMenuModel.swift:71`
   gives the category title "Assembly";
   `FASTQOperationDialogState.swift:1989-1994` gives the five tool titles.

2. Assembly output does not land in an `Assemblies/` folder. It lands in the
   project's `Analyses/` folder, in a per-run directory.
   `FASTQOperationDialogState.swift:1607-1610` returns
   `projectURL/Analyses` as the default output directory;
   `AnalysesFolder.swift:18` names the directory "Analyses";
   `AnalysesFolder.swift:121-122` gives the per-run directory shape
   `Analyses/{tool}-{timestamp}/`; `AnalysesFolder.swift:24-26` lists the five
   assemblers among `knownTools`. Grep for `"Assemblies"` across `Sources/`
   returns one code comment and no path construction.

3. There is no per-contig coverage anywhere in the assembly viewport. The
   contig table columns are `#`, `Contig`, `Length (bp)`, `GC %`,
   `Share of Assembly (%)`, `Sequence Preview`
   (`AssemblyContigTableView.swift:20-45`), and the detail pane shows title,
   length, GC, rank, share, and the sequence
   (`AssemblyContigDetailPane.swift:11-18`). Grep for `coverage` across
   `Sources/LungfishAssemblyUI/`, `AssemblyContigCatalog.swift`, and
   `AssemblyResult.swift` returns nothing.

## 01-when-to-assemble.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` | false | `MainMenu.swift:703-706, 786-819`, `ToolsMenuModel.swift:71`, `FASTQOperationDialogState.swift:1989-1994`. The Tools menu has an "Assembly" category submenu whose items are the five tools. | `entry_points: ["Tools > Assembly > SPAdes…", "Tools > Assembly > MEGAHIT…", "Tools > Assembly > SKESA…", "Tools > Assembly > Flye…", "Tools > Assembly > Hifiasm…"]` |
| 2 | "Assembly stitches sequencing reads into longer contiguous sequences, called contigs, without ever consulting a reference genome." | true | Conceptual, and consistent with `ManagedAssemblyPipeline.swift:185-320`, where no assembler command takes a reference argument. | |
| 3 | "Lungfish runs five assemblers through one wizard" | changed | `AssemblyTool.swift:8-13` confirms five tools, and `AssemblyWizardSheet.swift:55` is one shared wizard, but "one wizard" is now reached through five separate menu items rather than one, and the wizard opens with `initialTool` preset from the menu item (`AssemblyWizardSheet.swift:63, 95, 112`). | "Lungfish Genome Explorer ships five assemblers behind one shared configuration sheet. You reach it by picking a tool under `Tools > Assembly`, and the sheet opens with that tool preselected in its Assembler picker." |
| 4 | "packages every result the same way: a `.lungfishref` assembly bundle in the project's `Assemblies/` folder" | changed | The `.lungfishref` half is true: `AssemblyBundleBuilder.swift:89-101` publishes `<name>.lungfishref`. The folder half is false, see recurring finding 2. | "packages every result the same way, as a `.lungfishref` assembly bundle inside a per-run folder in the project's `Analyses/` folder" |
| 5 | "with each contig as a navigable sequence and the assembly statistics (N50, total length, contig count) in the Inspector" | changed | `AssemblySummaryStrip.swift:321-338` shows Assembler, Read Type, Contigs, Total bp, N50, L50, Longest, Global GC, and optionally Version and Wall Time. These sit in the viewport summary strip, not the Inspector. | "with each contig listed in a table and the assembly statistics in the viewport's summary strip. The strip shows the assembler, the read type, the contig count, total bp, N50, L50, the longest contig, and the whole-assembly GC percent." |
| 6 | "One menu item opens the wizard, `Tools > FASTQ/FASTA Operations > Assembly…`, and you pick the assembler from a segmented Assembler control inside it." | false | Five menu items, not one, see recurring finding 1. The segmented Assembler control does exist (`AssemblyWizardSheet.swift:496-504`), and it lists only the tools compatible with the detected read class (`AssemblyWizardSheet.swift:242-249`). | "Five menu items open the same sheet, one per assembler, under `Tools > Assembly`. Inside the sheet a segmented Assembler control lets you switch between the assemblers that fit your reads." |
| 7 | "The bundle format matches a reference bundle exactly, so any contig you produce can serve downstream as a mapping target" | true | `AssemblyBundleBuilder.swift:89-140` builds the same `.lungfishref` structure with a bgzipped, indexed contigs FASTA and a manifest. | |
| 8 | Table row: "SPAdes \| Illumina paired short reads \| … \| Profiles: Isolate (default), Meta, Plasmid." | true | `AssemblyWizardSheet.swift:878-883` lists exactly Isolate, Meta, Plasmid; `AssemblyWizardSheet.swift:938-939` makes `isolate` the default; `ManagedAssemblyPipeline.swift:181-190` emits `--isolate`, `--meta`, `--plasmid`. | |
| 9 | Table row: "MEGAHIT \| Illumina short reads" | true | `AssemblyCompatibility.swift:16-18` allows MEGAHIT only for `illuminaShortReads`. | |
| 10 | Table row: "SKESA \| Illumina short reads" | true | `AssemblyCompatibility.swift:16-18`. | |
| 11 | Table row: "Flye \| Oxford Nanopore long reads … In this version Flye accepts ONT reads only." | true | `AssemblyCompatibility.swift:19-20` returns `[.flye, .hifiasm]` for `ontReads` and `[.hifiasm]` for `pacBioHiFi`, so Flye is offered for ONT alone. | |
| 12 | Table row: "Hifiasm \| PacBio HiFi long reads … Also accepts ONT reads." | true | `AssemblyCompatibility.swift:19-22` lists hifiasm under both `ontReads` and `pacBioHiFi`; `ManagedAssemblyPipeline.swift:314-316` inserts `--ont` when the read type is ONT. | |
| 13 | Table row: "Flye \| … up to ~100 Mb" and "SPAdes \| … up to ~10 Mb" and "MEGAHIT \| … unbounded" | false | No genome-size gate exists anywhere in the code. `AssemblyRunRequest.swift` carries no genome-size field, and the wizard has no genome-size control. These are the authors' domain guidance presented as if the app enforced them. | Keep the guidance but mark it as advice, for example "Practical ceiling, not enforced by the app" as the column heading. |
| 14 | "Two assemblers are missing from this table because Lungfish does not ship them: Canu and Trinity." | true | `AssemblyTool.swift:8-13` and `PluginPack.swift:673` list only the five. | |
| 15 | "The wizard reads the FASTQ headers, detects the read class for you, and then shows only the assemblers that fit." | true | `AssemblyReadType.swift:57-89, 134-146` sniffs the first FASTQ header, falling back to persisted metadata; `AssemblyWizardSheet.swift:242-249` narrows `availableTools` to the compatible set once detection resolves. | |
| 16 | "Select a paired Illumina bundle and the Assembler picker offers SPAdes, MEGAHIT, and SKESA; an ONT bundle offers Flye and Hifiasm." | true | `AssemblyCompatibility.swift:16-20`. | |
| 17 | "Hybrid assembly that blends read types in one run … the Lungfish wizard detects one read class per bundle and runs a single technology at a time." | true | `AssemblyCompatibility.swift:10-11` defines the blocking message "Hybrid assembly is not supported in v1. Select one read class per run."; `AssemblyCompatibility.swift:42-49` returns it whenever more than one read class is detected. | |
| 18 | Worked example: "you BLAST the longest contigs to see what assembled" | true | `AssemblyActionBar.swift:10, 45` provides a BLAST Contigs button; `AssemblyContigMaterializationAction.swift:68-80` builds the BLAST request from the selection. | |
| 19 | "Every assembler in this list writes a `.lungfishref` assembly bundle into the project's `Assemblies/` folder." | changed | Same as claim 4. | "Every assembler writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses/` folder." |
| 20 | "The bundle's primary FASTA holds the contigs in length-descending order." | changed | `AssemblyBundleBuilder.swift:114-120` bgzips and indexes the assembler's own contigs FASTA without reordering it. The viewport's table is what sorts by length, and it does so by default rank (`AssemblyContigTableView.swift:20`). SPAdes and MEGAHIT happen to emit length-descending output, Flye and hifiasm do not guarantee it. | "The bundle's primary FASTA holds the contigs in whatever order the assembler emitted them. The contig table in the assembly viewport ranks them by length, so the longest is row 1 regardless." |
| 21 | "The Inspector shows N50, total assembled length, contig count, longest-contig length, and the resolved tool version." | changed | Those five values do exist but they are in the viewport's summary strip (`AssemblySummaryStrip.swift:321-338`), which also shows L50 and global GC. `AssemblyBundleBuilder.swift:682-683` writes a Min Contig Length metadata item, so the Inspector shows the bundle's metadata groups, not this list. | "The viewport's summary strip shows the assembler, read type, contig count, total bp, N50, L50, longest contig, global GC percent, and, when the run recorded them, the tool version and wall time." |
| 22 | "The contigs themselves appear as navigable sequences in the sidebar, and any one can be opened in a sequence viewport" | false | The assembly bundle appears in the sidebar as one item. Its contigs are rows in the assembly viewport's table (`AssemblyResultViewController.swift:118-179`), and there is no double-click-to-open handler in `Sources/LungfishAssemblyUI/`. To get a contig into a sequence viewport you extract it into a reference bundle, which is what chapter 04 covers. | "The assembly bundle appears in the sidebar as a single item. Opening it shows the contig table. To open one contig in a sequence viewport, select it and derive a reference bundle from it, which chapter [Extracting Contigs](04-extracting-contigs.md) covers." |
| 23 | "used as a mapping target for a fresh `Map Reads` run" | false | No operation is named "Map Reads". The Tools menu's Mapping category lists minimap2, BWA-MEM2, Bowtie2, BBMap, and Viral Recon (`FASTQOperationDialogState.swift:2068-2069, 1985-1990`). | "used as a mapping target for a fresh run of minimap2, BWA-MEM2, Bowtie2, or BBMap under `Tools > Mapping`" |
| 24 | "Most short-read viral and bacterial work belongs on SPAdes." and the rest of the decision guidance | true | Editorial advice, consistent with the compatibility model. No code claim to check. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Assembly category submenu itself, with one item per assembler | `MainMenu.swift:786-819`, `ToolsMenuModel.swift:71` |
| The managed Genome Assembly conda pack, which must be installed before any assembler runs, and the Readiness panel that reports its state | `PluginPack.swift:669-716`, `AssemblyWizardSheet.swift:646-695` |
| Pinned tool versions: SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, hifiasm 0.25.0 | `third-party-tools-lock.json:42-46` |
| The Read Type picker, which appears and becomes editable when header detection is inconclusive, and is a locked label when detection succeeds | `AssemblyWizardSheet.swift:507-524` |
| The blocking message for a mixed selection, "Hybrid assembly is not supported in v1. Select one read class per run." | `AssemblyCompatibility.swift:10-11` |
| The second blocking message for a selection mixing detected and unclassified inputs | `AssemblyWizardSheet.swift:56-57` |
| The multi-bundle run mode picker for SPAdes, MEGAHIT, and SKESA when more than one bundle is selected, currently locked to per-bundle | `AssemblyWizardSheet.swift:167-187, 402-409` |
| Long-read tools reject a multi-file selection outright | `AssemblyWizardSheet.swift:261-270` |
| MEGAHIT threads are capped at 2 on Apple Silicon because 1.2.9 arm64 crashes above that, and `--no-hw-accel` is added | `AssemblyRunRequest.swift:99-104`, `ManagedAssemblyPipeline.swift:233-236` |
| Sidebar context menu "Reassemble…" on a bundle that carries assembly provenance | `SidebarViewController+MenuDelegate.swift:207-209` |
| The `completedWithNoContigs` outcome, reached when an assembler exits cleanly but produces nothing | `AssemblyOutputNormalizer.swift:56-70` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-assembler-picker`, captioned "The Assembly wizard's segmented Assembler picker (SPAdes, MEGAHIT, SKESA, Flye, Hifiasm) above the separate Read Type control." | Retake with a new caption | The picker and its position above Read Type are real (`AssemblyWizardSheet.swift:496-524`), but it never shows all five at once for a bundle whose read class was detected. The caption must say the picker lists the assemblers compatible with the detected read class. |
| `assembly-bundle-in-sidebar`, captioned "An assembly bundle in the Assemblies/ folder, with contigs listed in the Inspector." | Retake with a new caption | Wrong folder and wrong pane. The bundle lives under `Analyses/`, and contigs are listed in the assembly viewport's table, not the Inspector. |
| `<!-- planned: assembly-bundle-in-sidebar -->` marker in "Where the result lands" | Keep the marker, fix the shot | The section itself is the right home for a shot of where output lands. |
| Illustration `assembly-vs-mapping` | Valid | Conceptual schematic with no app claim in it. |

## 02-running-spades.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` and `"CLI: lungfish assemble"` | changed | The CLI half is right (`cli-help/assemble.txt`, banner `==== assemble ====`). The menu half is wrong, see recurring finding 1. | `entry_points: ["Tools > Assembly > SPAdes…", "Tools > Assembly > MEGAHIT…", "Tools > Assembly > SKESA…", "CLI: lungfish assemble"]` |
| 2 | "Lungfish surfaces three as profiles in the wizard: Isolate (the default), Meta, and Plasmid." | true | `AssemblyWizardSheet.swift:878-883` and `:938-939`. | |
| 3 | "There is no viral profile." | true | `AssemblyWizardSheet.swift:878-883` offers only three, and `ManagedAssemblyPipeline.swift:181-190` falls through to `default: break` for anything else. | |
| 4 | "Lungfish writes a `.lungfishref` assembly bundle into the project's `Assemblies/` folder." | changed | See recurring finding 2. | "Lungfish Genome Explorer writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses/` folder." |
| 5 | "the assembly result viewport ranks the contig list by length, with per-contig length, coverage, and GC content" | false | There is no coverage column, see recurring finding 3. | "the assembly result viewport ranks the contig list by length and shows each contig's length, GC percent, and share of the assembly, with a sequence preview" |
| 6 | Profile table: "Isolate (default) \| `--isolate`", "Meta \| `--meta`", "Plasmid \| `--plasmid`" | true | `ManagedAssemblyPipeline.swift:181-190`. | |
| 7 | "The only way to reach it is to type it into the wizard's advanced options text field, or to pass `--extra-args \"--viral\"` on the CLI." | true | `AssemblyWizardSheet.swift:609-618` is the Extra arguments field, parsed by `AdvancedCommandLineOptions.parse` and appended to the command (`AssemblyWizardSheet.swift:783, 797-799`; `ManagedAssemblyPipeline.swift:201`). `cli-help/assemble.txt` documents `--extra-args`. | |
| 8 | Procedure step 2: "Choose `Tools > FASTQ/FASTA Operations > Assembly…`. The Assembly wizard opens. Set the Assembler picker at the top to `SPAdes`." | changed | See recurring finding 1. Choosing the SPAdes item already sets the picker, since `initialTool` seeds `selectedTool` (`AssemblyWizardSheet.swift:95, 112`). | "Choose `Tools > Assembly > SPAdes…`. The assembly sheet opens with SPAdes already chosen in the Assembler picker at the top of Primary Settings." |
| 9 | Procedure step 2: "Your selection pre-fills the input FASTQ bundle; confirm it, or swap it with the input picker." | false | The sheet has no input picker. The Inputs section is three read-only rows, Dataset, Read Layout, and Detected (`AssemblyWizardSheet.swift:474-490`). The input comes from the sidebar selection before the sheet opens. | "The Inputs section at the top shows the dataset you selected, its read layout, and the detected read class. These are read-only. To assemble a different bundle, close the sheet, select that bundle in the sidebar, and open the menu item again." |
| 10 | Procedure step 3: "For SPAdes' slower, more accurate run, expand Advanced Settings and turn on `Careful mode`." | changed | The toggle exists (`AssemblyWizardSheet.swift:586-587`) and maps to `--careful` (`AssemblyWizardSheet.swift:915-918`), but the disclosure inside Advanced Settings is labelled "Curated extra arguments" (`AssemblyWizardSheet.swift:58, 582`). | "expand the Curated extra arguments disclosure under Advanced Settings and turn on `Careful mode`" |
| 11 | Procedure step 3: "The `Min Contig` stepper there sets a length below which Lungfish drops contigs after SPAdes finishes. It is a Lungfish post-filter, not a SPAdes flag." | false | The stepper is real and sits in Primary Settings, not Advanced Settings (`AssemblyWizardSheet.swift:564-574`). More seriously, no post-filter exists. `ManagedAssemblyPipeline.swift:176-206` builds the SPAdes command without any min-contig handling, and `AssemblyOutputNormalizer.swift:23-27, 65` reads `contigs.fasta` unfiltered. Only MEGAHIT (`--min-contig-len`, `:225-227`) and SKESA (`--min_contig`, `:263-265`) receive it. The catalog string `.spades: "Lungfish post-filter"` at `AssemblyOptionCatalog.swift:128` is what the wizard prints as the setting's summary, and it describes behavior that is not implemented. | "The `Min Contig` stepper sits in Primary Settings, below the Threads and Memory Limit sliders. It takes effect for MEGAHIT and SKESA, which receive it as `--min-contig-len` and `--min_contig`. With SPAdes selected the stepper is shown but the value is not applied to the run, so leave it at 0." Flag this to engineering as a defect rather than a documentation gap. |
| 12 | Procedure step 4: "Lungfish pre-fills the field from your input bundle name (for example `SRR36291587_assembly`), or `assembly` if it cannot derive one." | true | `AssemblyWizardSheet.swift:326-337` strips `_R1`, `_R2`, `_1`, `_2`, and `.lungfishfastq` from the first input's stem and appends `_assembly`, falling back to the literal `assembly`. | |
| 13 | Procedure step 4: "The output lands in the project's `Assemblies/` folder." | false | See recurring finding 2. The sheet also shows the resolved path in a read-only Output Folder row (`AssemblyWizardSheet.swift:635-641`). | "The output lands in the project's `Analyses/` folder. The Output Folder row below the name shows the exact path." |
| 14 | Procedure step 5: "Click `Run`." | true | `AssemblyWizardSheet.swift:463-468`, a prominent button titled "Run", disabled until `canRun`. | |
| 15 | Procedure step 5: "Lungfish materialises the FASTQ files (reconstructing full reads if the bundle is virtual), launches SPAdes in its conda environment, and streams progress into the Operations Panel." | true | `AssemblyInputMaterialization.swift` and `AssembleCommand.swift:409-413, 532-536` handle derived-bundle materialization; `AssemblyTool.swift:27` names the per-tool micromamba environment; `ManagedAssemblyPipeline.swift:81-174` runs and reports. | |
| 16 | Procedure step 5: "When the run completes, the new assembly bundle appears in `Assemblies/` and opens in the assembly result viewport." | changed | Folder is wrong, see recurring finding 2. | "the new assembly bundle appears under `Analyses/` and opens in the assembly result viewport" |
| 17 | "**Threads** is a slider that sets how many CPU threads the assembler uses. It ranges from 1 to the number of cores your Mac reports and defaults to the smaller of that count and 8." | true | `AssemblyWizardSheet.swift:542-548` is an `InlineNumericSliderField` over `1...availableCores`; `:324` sets `threads = min(Double(availableCores), 8)`; `:128-130` reads `processorCount`. | |
| 18 | "The wizard maps this to SPAdes' `--threads`, and to the matching flag on the other assemblers (`--num-cpu-threads` for MEGAHIT, `--cores` for SKESA)." | true | `ManagedAssemblyPipeline.swift:199` (`--threads`), `:223` (`--num-cpu-threads`), `:259` (`--cores`). Flye also takes `--threads` (`:288`) and hifiasm takes `-t` (`:312`). | |
| 19 | "**Memory Limit** is a slider that caps how much RAM the assembler may use, read in whole gigabytes from 1 up to the memory your Mac reports, and defaulting to roughly three-quarters of installed memory capped at 32 GB." | true | `AssemblyWizardSheet.swift:551-562` over `1...availableMemoryGB` with a "GB" suffix; `:325` sets `memoryGB = min(Double(availableMemoryGB) * 0.75, 32)`; `:124-126` reads `physicalMemory`. | |
| 20 | "The wizard shows it only for the assemblers that accept a memory budget, SPAdes, MEGAHIT, and SKESA, and passes the value as `--memory`. It is hidden for Flye and hifiasm" | changed | The gating is right (`AssemblyOptionCatalog.swift:116-120` lists only those three; `AssemblyWizardSheet.swift:226-230, 551`). The flag is `--memory` for all three (`ManagedAssemblyPipeline.swift:200, 231, 261`), but MEGAHIT receives it in bytes, not gigabytes (`AssemblyRunRequest.swift:94-97` multiplies by 1024^3). | Add one sentence: "MEGAHIT takes the same budget in bytes, so Lungfish Genome Explorer converts your gigabyte figure before passing it." |
| 21 | "**Skip error correction** is a toggle under Advanced Settings, shown for SPAdes, that passes SPAdes' `--only-assembler` flag … It is off by default" | true | `AssemblyWizardSheet.swift:588`, `:919-921`, and `:79` (`spadesSkipErrorCorrection = false`). | |
| 22 | "Download the run via `Tools > Search Online Databases > Search SRA...`" | true | `MainMenu.swift:739-770` builds the "Search Online Databases" submenu with "Search SRA..." in it. | |
| 23 | "Click the row. The Inspector shows length, coverage (parsed from the SPAdes contig header, for example the `cov_412.7` field in `NODE_1_length_29812_cov_412.7`), and GC content." | false | Two errors. Selecting a row updates the viewport's detail pane, not the Inspector (`AssemblyResultViewController.swift:144, 176-177`; `AssemblyContigDetailPane.swift:264-271`). And no coverage is parsed anywhere, see recurring finding 3. | "Click the row. The detail pane beside the table shows the contig header, its length, its GC percent, its rank in the assembly, its share of the total assembly length, and a scrollable view of its sequence. SPAdes encodes its own coverage estimate in the contig name, for example `NODE_1_length_29812_cov_412.7`, so you can read the depth off the header text even though it is not a separate column." |
| 24 | "Double-click the contig. It opens in a sequence viewport" | false | No double-click handler exists in `Sources/LungfishAssemblyUI/`. | "Select the contig and use `Create Bundle` in the action bar to derive a reference bundle from it, which you can then open in a sequence viewport." |
| 25 | "The headline assembly metrics live in the bundle's Inspector, and N50 is the one you will meet most." | changed | The metrics are in the viewport summary strip (`AssemblySummaryStrip.swift:321-338`). | "The headline assembly metrics live in the summary strip along the top of the assembly viewport, and N50 is the one you will meet most." |
| 26 | "N50 is defined so that half the assembly's total length sits in contigs of at least N50 bases." | true | Standard definition, and `AssemblySummaryStrip.swift:327` reports `statistics.n50`. | |
| 27 | Organism threshold table (SARS-CoV-2 ~29.9 kb, Influenza A, E. coli, M. tuberculosis) | true | Domain guidance, explicitly labelled "practical, and they are simplifications, not rules". No app claim. | |
| 28 | Troubleshooting: "Open the FASTQ bundle and read the read count and per-base quality summary in the Inspector." | true | Belongs to the FASTQ chapters, outside this part's code, and the Inspector does carry FASTQ QC summaries. | |
| 29 | Troubleshooting: "Read the Operations Panel log." | true | Every assembly run is an OperationCenter operation with a log; `ManagedAssemblyPipeline.swift:126` writes `assembly.log` into the output directory and `AssemblyOutputNormalizer.swift:71-72` records its path. | |
| 30 | "MEGAHIT offers three profiles in the Profile picker: `Default`, `Meta Sensitive`, and `Meta Large`." | true | `AssemblyWizardSheet.swift:884-889`. | |
| 31 | "On the CLI, `Default` is not a literal profile value: it means omitting `--profile` entirely, and only `meta-sensitive` and `meta-large` are named values you pass." | true | `AssemblyWizardSheet.swift:886` gives Default the empty id; `AssemblyWizardSheet.swift:782` drops an empty profile id from the request; `ManagedAssemblyPipeline.swift:228-230` only appends `--presets` when the id is non-empty. | |
| 32 | "SKESA has no Profile picker, so the wizard shows only the shared controls." | true | `AssemblyWizardSheet.swift:890-891` returns an empty profile list, and `:526` hides the whole Profile row when the list is empty. | |
| 33 | "Lungfish pins SKESA's `--min_count 2` setting by default, which keeps small assemblies … from being zeroed out by SKESA's high-coverage auto-escalation." | true | `ManagedAssemblyPipeline.swift:266-271`, including the code comment giving the same reason. | |
| 34 | CLI flag table: `--assembler <name>` values "`spades` (default), `megahit`, `skesa`, `flye`, or `hifiasm`" | true | `cli-help/assemble.txt`, banner `==== assemble ====`, OPTIONS. | |
| 35 | CLI flag table: `--read-type <class>` values "`illumina-short-reads`, `ont-reads`, or `pacbio-hifi`; auto-detected if omitted" | true | `cli-help/assemble.txt`; `AssemblyReadType.swift:98-107` for the spellings; `AssembleCommand.swift:346, 366` for detection. | |
| 36 | CLI flag table: `--output <dir>` "aliases `--output-dir` and `-o`" | true | `cli-help/assemble.txt` shows `-o, --output, --output-dir <output>`. | |
| 37 | CLI flag table: `--project-name <name>` "alias `--name`" | true | `cli-help/assemble.txt` shows `--project-name, --name <project-name>`. | |
| 38 | CLI flag table: `--paired`, `--profile <id>`, `--memory-gb <n>` with alias `--memory`, `--min-contig-length <bp>`, `--extra-args`, `--extra-arg` | true | All present in `cli-help/assemble.txt`. | |
| 39 | CLI flag table: "`--min-contig-length <bp>` \| Minimum contig length post-filter" | changed | The flag exists, but it is passed straight to MEGAHIT and SKESA and ignored for SPAdes, Flye, and hifiasm. The help text itself says "when the selected assembler supports it". | "Minimum contig length, passed to MEGAHIT and SKESA. Ignored by SPAdes, Flye, and hifiasm." |
| 40 | "A SARS-CoV-2 amplicon assembly is `lungfish assemble reads_R1.fastq.gz reads_R2.fastq.gz --paired --assembler spades --profile isolate`." | true | Matches the USAGE line and options in `cli-help/assemble.txt`. | |
| 41 | "SPAdes … builds contigs from Illumina reads by constructing a de Bruijn graph … pruning that graph of sequencing-error branches" | true | Tool-domain description, no app claim. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Readiness panel, which reports the managed tool status and blocks Run until the assembly pack is installed and smoke-tested | `AssemblyWizardSheet.swift:646-695`, `:218-224` |
| The validation message strip in the footer, which names exactly why Run is disabled | `AssemblyWizardSheet.swift:29-52, 447-455` |
| The Inputs section rows Dataset, Read Layout, and Detected | `AssemblyWizardSheet.swift:474-490, 731-754` |
| The Read Type picker and the "Locked from FASTQ header detection." caption | `AssemblyWizardSheet.swift:507-524` |
| The Extra arguments free-text field and its parse error, which also disables Run | `AssemblyWizardSheet.swift:609-618, 801-808` |
| The Output Folder read-only row | `AssemblyWizardSheet.swift:635-641` |
| The multi-bundle run mode picker for the three short-read tools, locked to per-bundle with the reason string | `AssemblyWizardSheet.swift:167-187, 402-409` |
| MEGAHIT threads capped at 2 and `--no-hw-accel` added on Apple Silicon | `AssemblyRunRequest.swift:99-104`, `ManagedAssemblyPipeline.swift:233-236` |
| The advanced option descriptions the wizard prints per tool, four for SPAdes, three for MEGAHIT, three for SKESA | `AssemblyOptionCatalog.swift:168-244`, rendered at `AssemblyWizardSheet.swift:599-607` |
| The action-bar buttons `BLAST Contigs`, `Copy FASTA`, `Export FASTA`, `Create Bundle`, all disabled until a contig is selected | `AssemblyActionBar.swift:10-13, 59-68` |
| The contig-table context menu, which adds `Extract Sequence…`, `Align with MAFFT…`, and `Run Operation…` | `FASTASequenceActionMenuBuilder.swift:70-127`, wired at `AssemblyResultViewController.swift:295-309` |
| The three assembly panel layouts, detail-leading (default), list-leading, and stacked | `AssemblyLayoutPreference.swift:9-22` |
| The `Share of Assembly (%)` and `Sequence Preview` columns | `AssemblyContigTableView.swift:32-45` |
| L50 and Global GC in the summary strip | `AssemblySummaryStrip.swift:328, 330` |
| Pinned tool versions SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1 | `third-party-tools-lock.json:42-44` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-spades`, captioned "The Assembly wizard with SPAdes selected and the Isolate profile chosen." | Valid, retake for the current sheet | Both controls exist (`AssemblyWizardSheet.swift:496-540`). The shot should be reached through `Tools > Assembly > SPAdes…` and should include the Inputs rows and the Readiness panel so the caption can name them. |
| `<!-- planned: assembly-wizard-spades -->` marker in procedure step 2 | Keep | Right place in the corrected procedure. |
| `assembly-viewport`, captioned "The assembly result viewport showing contigs ranked by length with N50 in the summary strip." | Valid | Both true (`AssemblyContigTableView.swift:20-45`, `AssemblySummaryStrip.swift:327`). |
| `<!-- planned: assembly-viewport -->` marker in procedure step 5 | Keep | Right place. |
| `contig-inspector`, captioned "Inspector pane for the longest contig showing length, coverage, and GC content." | Invalid, respecify | Wrong pane and a control that does not exist. Respecify as `contig-detail-pane`, captioned "The detail pane for the longest contig, showing its header, length, GC percent, rank, share of the assembly, and sequence." |
| `<!-- planned: contig-inspector -->` marker after the double-click paragraph | Move | The paragraph it follows is being rewritten. Place the marker after the corrected "Click the row" paragraph instead. |

## 03-running-flye-or-hifiasm.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` | false | See recurring finding 1. | `entry_points: ["Tools > Assembly > Flye…", "Tools > Assembly > Hifiasm…", "CLI: lungfish assemble"]` |
| 2 | "Lungfish runs both through the same Assembly wizard you used for SPAdes in the previous chapter" | true | `AssemblyWizardSheet.swift:55` is one sheet for all five tools. | |
| 3 | "both produce the same kind of output: an assembly bundle under `Assemblies/` in your project folder, holding a contigs FASTA and per-contig metadata" | changed | The bundle shape is right (`AssemblyBundleBuilder.swift:89-140`), the folder is not, see recurring finding 2. | "both produce an assembly bundle in a per-run folder under `Analyses/` in your project, holding a contigs FASTA and its index" |
| 4 | Comparison table: "Input platform \| Flye: Oxford Nanopore (R9, R10) \| Hifiasm: PacBio HiFi (CCS), and also ONT" | true | `AssemblyCompatibility.swift:16-22`; `ManagedAssemblyPipeline.swift:314-316` for the ONT branch of hifiasm. The R9 and R10 detail is domain background, not an app gate. | |
| 5 | Comparison table: "Output style \| Flye: Single primary assembly \| Hifiasm: Primary plus haplotype-resolved contigs" | changed | Hifiasm does emit both, but Lungfish Genome Explorer only reads the primary contig graph. `AssemblyOutputNormalizer.swift:44-52` takes `<projectName>.bp.p_ctg.gfa` and converts it to `contigs.fasta`. The alternate haplotigs stay on disk and never reach the viewport. | "Hifiasm produces primary and haplotype-resolved contigs. Lungfish Genome Explorer loads the primary contig set into the viewport, so the alternate haplotigs remain in the run folder and are not listed." |
| 6 | "in this version it also accepts ONT reads (adding the `--ont` flag when the detected read type is Nanopore), so it is not strictly HiFi-only" | true | `ManagedAssemblyPipeline.swift:314-316`. | |
| 7 | "In this version Flye accepts ONT reads only. PacBio CLR is not an accepted Flye input, and the wizard will not offer Flye for a CLR bundle." | changed | Flye is ONT-only in the compatibility model (`AssemblyCompatibility.swift:16-22`), so the first sentence holds. The CLR sentence overstates the mechanism. `AssemblyReadType.swift:38-43, 48-53` returns nil for the `pacbio` platform, and `:135-141` promotes a header to `pacBioHiFi` only when it contains `/ccs`. A CLR bundle therefore falls through to "no read class detected" rather than being classified as CLR and then refused. | "In this version Flye accepts ONT reads only. PacBio CLR has no read class of its own, so a CLR bundle is detected as no single read class, the Read Type picker unlocks, and you must choose a class before Run enables." |
| 8 | Flye step 2: "Choose **Tools > FASTQ/FASTA Operations > Assembly…**. The Assembly wizard opens. Set the Assembler picker to **Flye** and confirm the input FASTQ is your ONT bundle." | changed | See recurring finding 1, and the input is read-only. | "Choose **Tools > Assembly > Flye…**. The sheet opens with Flye already chosen. Confirm the Inputs section names your ONT bundle and reports ONT reads under Detected." |
| 9 | Flye step 3: "The default is **Nano HQ** … Switch to **Nano Raw** … or **Nano Corrected**" | true | `AssemblyWizardSheet.swift:892-897` lists Nano HQ, Nano Raw, Nano Corrected; `:944-945` defaults to `nano-hq`; `ManagedAssemblyPipeline.swift:284-290` emits `--nano-hq`, `--nano-raw`, or `--nano-corr` from the profile id. | |
| 10 | Flye step 4: "Leave the **Metagenome mode** toggle (under Advanced Settings) off unless your sample is a mixed community." | changed | The toggle exists and maps to `--meta` (`AssemblyWizardSheet.swift:590-591, 922-925`), and is off by default (`:80`). The disclosure is labelled "Curated extra arguments". | "Leave the **Metagenome mode** toggle, inside the Curated extra arguments disclosure under Advanced Settings, off unless your sample is a mixed community." |
| 11 | Flye step 4: "The wizard has no genome-size field and no polishing control" | true | The wizard renders only the tool toggles plus text descriptions for the catalog's advanced entries (`AssemblyWizardSheet.swift:584-607`). Flye's Genome Size and its polishing iterations are catalog descriptions, not controls (`AssemblyOptionCatalog.swift:253-259, 156-165`). | |
| 12 | Flye step 4: "If you must pass a genome-size hint, type it into the advanced options text field as `--genome-size 30k`." | true | `AssemblyWizardSheet.swift:609-618` for the field, `:797-799, 783` for the pass-through, `ManagedAssemblyPipeline.swift:294` appends `request.extraArguments` to the Flye command. | |
| 13 | Hifiasm step 3: "**Diploid** (the default) … or **Haploid/Viral**" | true | `AssemblyWizardSheet.swift:898-902` and `:946-947`. | |
| 14 | Hifiasm step 3: "Hifiasm has no genome-size parameter; it infers structure from the reads themselves." | true | No genome-size handling in `buildHifiasmCommand` (`ManagedAssemblyPipeline.swift:299-337`), and no such control in the sheet. | |
| 15 | Hifiasm step 4: "For just the primary assembly, without the alternate haplotigs, turn on **Primary contigs only** under Advanced Settings." | changed | The toggle exists and adds `--primary` (`AssemblyWizardSheet.swift:592-594, 926-929`), inside the Curated extra arguments disclosure. But the viewport reads the primary contig graph either way (`AssemblyOutputNormalizer.swift:44-52`), so the toggle changes what hifiasm writes to disk rather than what you see. | "Turn on **Primary contigs only**, inside the Curated extra arguments disclosure, to have hifiasm emit only the primary assembly. The viewport lists the primary contigs either way, so this mostly saves disk and time." |
| 16 | Hifiasm step 4: "The wizard has no trio-binning fields." | true | No trio arguments anywhere in `ManagedAssemblyPipeline.swift` or the sheet. | |
| 17 | The Haploid/Viral profile is described only as "Single-haplotype assembly for haploid or viral genomes" with no mention of what it adds | changed | `ManagedAssemblyPipeline.swift:400-414` also appends `--n-hap 1`, `-l0`, and `-f0` unless the user already supplied them. The chapter never says so. | Add to the Hifiasm step 3 text: "Haploid/Viral also tells hifiasm to expect one haplotype and to skip purging and the bloom filter, which is what makes it fast on a small genome." |
| 18 | "The wizard hands the run to the Operations Panel, exactly as SPAdes did in the previous chapter. Close the wizard and watch progress there." | true | Same pipeline for all five tools (`ManagedAssemblyPipeline.swift:81-174`). | |
| 19 | Worked example: "The shipped Lungfish fixtures cover the short-read SARS-CoV-2 case (see `Tests/Fixtures/sarscov2/`); a matched ONT fixture is not yet packaged" | true | `Tests/Fixtures/sarscov2/` exists and holds paired Illumina FASTQ. No ONT amplicon fixture is present. | |
| 20 | "The Operations Panel logs each Flye stage: read overlap, graph construction, contig extraction, and polishing." | changed | The panel streams the tool's own stdout and stderr, and `ManagedAssemblyPipeline.swift:126` writes `assembly.log`. Lungfish Genome Explorer does not parse or name Flye's stages, so what appears is Flye's own wording. | "The Operations Panel streams Flye's own output as it works through overlap, graph construction, contig extraction, and polishing, and the full text is saved as `assembly.log` in the run folder." |
| 21 | "The new bundle in `Assemblies/` holds a single contig of about 29.8 kb." | changed | Folder, see recurring finding 2. The number is illustrative, and the chapter already labels the example hypothetical. | "The new bundle under `Analyses/` holds a single contig of about 29.8 kb." |
| 22 | "A long-read assembly bundle looks the same in the project sidebar as a short-read one." | true | `AssemblyBundleBuilder.swift:89-140` builds one shape for all five tools; `SidebarProjectScanner.swift:876` gives all five the same icon. | |
| 23 | "Flye asks more of your machine than SPAdes for the same small-genome input." and the rest of the resource-use paragraph | true | Domain guidance, no app claim. Note that the Memory Limit slider is hidden for both Flye and hifiasm (`AssemblyOptionCatalog.swift:116-120`), which is worth saying here. | Consider adding: "Neither Flye nor hifiasm takes a memory budget, so the Memory Limit slider does not appear for them." |
| 24 | "Other long-read assemblers exist (Canu, NextDenovo, Raven, Shasta, wtdbg2, miniasm) … Lungfish currently ships only Flye and Hifiasm" | true | `AssemblyTool.swift:8-13`. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| Flye and hifiasm each accept exactly one input file, and a multi-file selection is refused before Run with a per-tool message | `AssemblyWizardSheet.swift:261-270`, `ManagedAssemblyPipeline.swift:278-282, 300-304` |
| The Memory Limit slider is hidden for both long-read tools | `AssemblyOptionCatalog.swift:116-120`, `AssemblyWizardSheet.swift:226-230, 551` |
| The Min Contig stepper is also hidden for both, since neither is in the minimum-contig-length mapping | `AssemblyOptionCatalog.swift:126-131`, `AssemblyWizardSheet.swift:232-236, 564` |
| The Haploid/Viral profile silently adds `--n-hap 1`, `-l0`, and `-f0` unless you already passed them | `ManagedAssemblyPipeline.swift:400-414` |
| Hifiasm output is a GFA that Lungfish Genome Explorer converts to `contigs.fasta` before the viewport can show it | `AssemblyOutputNormalizer.swift:44-52`, `GFASegmentFASTAWriter.swift` |
| Flye's assembly graph is kept as `assembly_graph.gfa` in the run folder | `AssemblyOutputNormalizer.swift:38-41` |
| Hifiasm writes its output under a prefix built from the Project Name, so renaming the run renames the files | `ManagedAssemblyPipeline.swift:311` |
| Pinned versions Flye 2.9.6 and hifiasm 0.25.0 | `third-party-tools-lock.json:45-46` |
| Four Flye and four hifiasm advanced option descriptions printed in the sheet without controls | `AssemblyOptionCatalog.swift:245-304` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-flye`, captioned "Assembly wizard with Flye selected, an ONT FASTQ chosen as input, and the Nano HQ profile in the Profile picker." | Valid, retake for the current sheet | All three elements exist (`AssemblyWizardSheet.swift:496-540`, `:892-897`). Reach it through `Tools > Assembly > Flye…`. The caption should say the input was selected in the sidebar before the sheet opened, since the sheet has no input picker. |
| `<!-- planned: assembly-wizard-flye -->` marker after Flye step 5 | Keep | Right place. |
| `assembly-wizard-hifiasm`, captioned "Assembly wizard with Hifiasm selected and a PacBio HiFi FASTQ chosen as input." | Valid, retake | Same as above. With a HiFi bundle selected the Assembler picker will show Hifiasm alone, since it is the only tool compatible with `pacBioHiFi` (`AssemblyCompatibility.swift:21-22`). The caption should say so, because a reader will otherwise think the picker is broken. |
| `<!-- planned: assembly-wizard-hifiasm -->` marker after Hifiasm step 5 | Keep | Right place. |
| `flye-single-contig-result`, captioned "Project sidebar showing a Flye assembly bundle that contains a single full-length contig." | Retake with a new caption | The sidebar shows the bundle, not its contigs. Either recaption as "the Flye assembly bundle in the sidebar under Analyses" or reshoot as the assembly viewport with its one-row contig table, which is what the surrounding prose actually describes. |
| `<!-- planned: flye-single-contig-result -->` marker in the worked example | Keep | Right place for whichever of the two shots is chosen. |

## 04-extracting-contigs.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Frontmatter `entry_points: "Assembly result viewport: Create Bundle button (action bar)"` and `"CLI: lungfish extract contigs"` | true | `AssemblyActionBar.swift:13, 48` for the button; `cli-help/extract.txt`, banner `==== extract contigs ====`, for the command. | |
| 2 | "Extraction is the operation that picks contigs from an assembly and derives a new reference bundle containing just those contigs as sequences." | true | `AssemblyResultViewController.swift:411-433` and `ExtractContigsCommand.swift:300-340`. | |
| 3 | "Lungfish writes the selected contigs to a new FASTA, bgzip-compresses it, builds a FASTA index, assembles a `.lungfishref` bundle around it, and writes a provenance record pointing at the source assembly." | changed | Subsetting, indexing, bundling, and provenance are all real, but the FASTA is not bgzip-compressed. `ExtractContigsCommand.swift:335` passes `compressFASTA: false` to `ReferenceBundleBuilder`. | "Lungfish Genome Explorer writes the selected contigs to a new FASTA, builds a FASTA index for it, assembles a `.lungfishref` bundle around it, and writes a provenance record pointing at the source assembly." |
| 4 | "From the assembly viewport the work runs as a short background task (the GUI calls the same `extract contigs` CLI command under the hood), so it returns quickly without a progress bar but is not strictly instantaneous." | false | In the app the Create Bundle button is routed to the viewer, not to the CLI helper. `AssemblyResultViewController.swift:415-422` prefers `onCreateBundleRequested`, which `ViewerViewController+Assembly.swift:116-118` wires to `createReferenceBundle`. That path starts a named OperationCenter operation, "Create Reference Bundle", with a cancel callback and a visible row (`ViewerViewController.swift:2412-2422`). The `extract contigs` CLI call in `AssemblyContigMaterializationAction.swift:48-66` is the fallback used only when no viewer callback is installed. | "Create Bundle starts a real operation named `Create Reference Bundle`, which appears in the Operations Panel with its own row and can be cancelled. It is quick, because the only work is subsetting and indexing the contigs you chose." |
| 5 | "most reference-driven operations downstream (mapping, variant calling, primer-scheme alignment, coverage analysis) want a reference bundle, not an assembly bundle" | changed | An assembly bundle is itself a `.lungfishref` (`AssemblyBundleBuilder.swift:101`), so it is accepted by reference pickers. The real reason to extract is to drop the contigs you do not want, so a mapping run targets one sequence rather than all of them. | "An assembly bundle is already a `.lungfishref`, so a reference picker will accept it whole. Extracting is how you narrow it to the contigs you actually want as the mapping or variant-calling target, instead of every fragment the assembler emitted." |
| 6 | "The assembly viewport is designed for this and shows per-contig length, coverage, and GC content." | false | No coverage, see recurring finding 3. | "The assembly viewport is designed for this and shows each contig's length, GC percent, and share of the assembly." |
| 7 | Procedure step 1: "Open the assembly bundle (from `Assemblies/` in the sidebar)" | false | See recurring finding 2. | "Open the assembly bundle from `Analyses/` in the sidebar" |
| 8 | Procedure step 1: "The contig table lists every contig with its length, coverage, and GC content." | false | See recurring finding 3. | "The contig table lists every contig with its rank, name, length, GC percent, share of the assembly, and a sequence preview." |
| 9 | Procedure step 2: "Click rows to toggle selection; the action bar shows the selected count." | true | `AssemblyActionBar.swift:59-68` sets the info label to "N contigs selected" or "Select contigs to materialize". | |
| 10 | Procedure step 3: "Click **Create Bundle** in the action bar at the bottom of the result viewport. The button is enabled only when at least one contig is selected." | true | `AssemblyActionBar.swift:13, 48, 59-64`; `AssemblyResultViewController.swift:214` places the bar at the bottom. | |
| 11 | Procedure step 3: "The same action bar also offers **BLAST Contigs**, **Copy FASTA**, and **Export FASTA** on the current selection." | changed | All three exist (`AssemblyActionBar.swift:10-12`), but the BLAST button retitles itself to "BLAST Contig" when exactly one contig is selected (`AssemblyActionBar.swift:65-66`). | "The same action bar also offers **BLAST Contigs**, **Copy FASTA**, and **Export FASTA** on the current selection. With a single contig selected the first button reads **BLAST Contig**." |
| 12 | Procedure step 4: "Lungfish writes the new reference bundle into `Reference Sequences/` and it appears in the sidebar." | true | `ExtractContigsCommand.swift:305` calls `ReferenceSequenceFolder.ensureFolder` and builds into it; the app path routes through `createReferenceBundle`, which also targets the project's reference folder. | |
| 13 | Procedure step 4: "The work runs as a short background task, so there is no progress bar" | false | Same as claim 4. The operation reports through OperationCenter. | "The work runs as a `Create Reference Bundle` operation, so you can watch it and cancel it from the Operations Panel." |
| 14 | "The Create Bundle button runs the `extract contigs` CLI command for you, so the bundle it produces is identical to what you would get from the command line." | changed | Two code paths exist and they differ. In the app the button goes through `createReferenceBundle` (`ViewerViewController+Assembly.swift:116-118`), which builds the bundle from the selected FASTA records. `extract contigs` is the path used by the standalone materialization action and by the command line. The bundles are equivalent in shape, but the claim that the button literally shells out to `extract contigs` is not accurate for the in-app path. | "Create Bundle and `lungfish extract contigs --bundle` both produce a `.lungfishref` bundle of the selected contigs in `Reference Sequences/`, so you can script the same result you get from the button." |
| 15 | "The CLI form is `lungfish extract contigs --assembly <bundle> --contig <id> [--contig <id> ...] --output <path>`" | changed | The flags are right (`cli-help/extract.txt`, `==== extract contigs ====`), but `--assembly` takes the managed assembly output directory that holds `assembly-result.json`, not the `.lungfishref` bundle. The help text says so and `ExtractContigsCommand.swift:22-23` repeats it. Also, `--output` writes a plain FASTA; a bundle needs `--bundle` plus `--project-root`. | "The CLI form is `lungfish extract contigs --assembly <run folder> --contig <id> [--contig <id> ...] --bundle --bundle-name <name> --project-root <project>`. Pass the run folder under `Analyses/` that holds `assembly-result.json`, not the `.lungfishref` bundle inside it. Swap `--bundle` for `--output <path>` to write a plain FASTA instead." |
| 16 | "(note `extract contigs` as two words, not a hyphenated `extract-contigs`)" | true | `cli-help/extract.txt` lists `contigs` as a subcommand of `extract`. | |
| 17 | "The `--contig` flag may be repeated and accepts the contig identifier shown in the table (`NODE_1_length_29812_cov_412.7` for a SPAdes contig)." | true | `cli-help/extract.txt` marks it repeatable; `ExtractContigsCommand.swift:28-29` declares it with `parsing: .upToNextOption`. The Contig column shows the record name (`AssemblyContigTableView.swift:21`). | |
| 18 | Flag table: "`--contigs <fasta>` \| Source contigs from a bare FASTA instead of `--assembly`" | true | `cli-help/extract.txt`; `ExtractContigsCommand.swift:25-26`. | |
| 19 | Flag table: "`--contig-file <path>` \| Read contig names from a file, one per line (repeatable)" | true | `cli-help/extract.txt`; `ExtractContigsCommand.swift:31-32`. | |
| 20 | Flag table: "`--bundle`, `--bundle-name`, `--project-root` \| Build a `.lungfishref` bundle in a project rather than a plain FASTA" | true | `cli-help/extract.txt`; `ExtractContigsCommand.swift:37-44`; `:300-340`. | |
| 21 | Flag table: "`--line-width <n>` \| FASTA wrap width (default 60)" | true | `cli-help/extract.txt` and `ExtractContigsCommand.swift:46-47` both give 60. | |
| 22 | "If you omit `--output`, the selected contigs are written to standard output as FASTA" | true | `cli-help/extract.txt` describes `-o, --output` as the output FASTA path, and the app's own materialization action reads the FASTA off stdout when it omits `--output` (`AssemblyContigMaterializationAction.swift:39-42, 82-85`). | |
| 23 | "From the Create Bundle button, the suggested name comes from your selection: a single selected contig suggests the contig identifier itself (for example `NODE_1_length_29812`), and a multi-contig selection suggests `<assembly>-selected-contigs`." | changed | The shape is right but the single-contig example is wrong. `AssemblyResultViewController.swift:312-319` returns `selectedContigs[0]` unchanged for one contig, so a SPAdes selection suggests the full `NODE_1_length_29812_cov_412.7`, not a truncated form. The multi-contig base is the assembly run folder's name. | "a single selected contig suggests that contig's full identifier, for example `NODE_1_length_29812_cov_412.7`, and a multi-contig selection suggests `<run folder name>-selected-contigs`" |
| 24 | "From the CLI without `--bundle-name`, the default is `<source>-subset`: an assembly whose source is `SRR36291587` produces `SRR36291587-subset`." | true | `ExtractContigsCommand.swift:343-351`. | |
| 25 | "if the proposed name is already taken in the project, Lungfish appends a counter (`SRR36291587-subset 2`, and so on) so nothing is overwritten" | true | `ExtractContigsCommand.swift:353-364`, which starts the counter at 2 and joins with a space. | |
| 26 | "Renaming the bundle later in the sidebar does not break provenance, because the provenance record holds bundle UUIDs, not display names." | changed | The extraction records provenance and a source note, but `ExtractContigsCommand.swift:322-337` writes `sourceURL` and the note "Derived from <source name>" into the bundle's source info, which are path and name based. The bundle gets its own generated identifier at `:326`. Renaming the derived bundle is safe, but the claim that the link is a UUID pointing at the source is not what the code writes. | "The derived bundle records where it came from in its own source information, including the source assembly's path and name. Renaming the derived bundle in the sidebar is safe. Moving or renaming the source assembly afterwards is what makes that record harder to follow." |
| 27 | "So you can tell at a glance which assembly a reference bundle came from" | true | `ExtractContigsCommand.swift:327-336` writes `database: "Derived Contig Subset"` and the "Derived from" note into the bundle metadata; `AssemblySubsetBundleMetadata.makeGroups` adds the assembler and the selected contig list. | |
| 28 | Worked example step 1: "The result is an assembly bundle named something like `SRR36291587-spades`" | changed | The run folder is `Analyses/{tool}-{timestamp}/` (`AnalysesFolder.swift:121-122`) and the bundle inside it is named from the wizard's Project Name, which pre-fills as `<input stem>_assembly` (`AssemblyWizardSheet.swift:326-334`). | "The result is an assembly bundle named from the Project Name you set, `SRR36291587_assembly` by default, inside a timestamped `spades-` folder under `Analyses/`." |
| 29 | Worked example step 2: "sort the contig table by length descending" | true | `AssemblyContigTableView.swift:23-29` defines a sortable Length (bp) column. | |
| 30 | Worked example step 4: "Open the mapping wizard from `Tools > FASTQ/FASTA Operations > Mapping…`." | false | No such path. The Mapping category holds one item per mapper (`FASTQOperationDialogState.swift:2068-2069`, `:1985-1990`; `ToolsMenuModel.swift:70`). | "Open a mapper from `Tools > Mapping`, for example `minimap2…` for long reads or `BWA-MEM2…` for Illumina short reads." |
| 31 | Interpretation: "the operation logs a single line in the Operations Panel showing the source assembly, the selected contig identifiers, and the new bundle UUID" | false | The completion detail is "Created <bundle file name>" (`ViewerViewController.swift:2432-2436`), and the started row's detail names the count of selected sequences (`:2415`). Neither prints a UUID. | "the Operations Panel row reads `Create Reference Bundle` while it runs, naming how many sequences were selected, and then reports the name of the bundle it created" |
| 32 | "If the contig you extracted turns out to be host or vector after annotation, delete the derived bundle and extract a different contig. The operation is cheap to redo." | true | Nothing in the code prevents repeated extraction from the same assembly, and the name collision handling at `ExtractContigsCommand.swift:353-364` accommodates it. | |
| 33 | "This is the last chapter in [Assembly](.)." | true | The part contains four chapter files and this is the fourth. | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The contig-table context menu, which offers `Extract Sequence…`, `BLAST`, `Copy FASTA`, `Export FASTA`, `Create Bundle`, `Align with MAFFT…`, and `Run Operation…` | `FASTASequenceActionMenuBuilder.swift:70-127`, wired at `AssemblyResultViewController.swift:295-309` |
| BLAST is capped at 50 selected sequences, with a tooltip explaining why the item is disabled | `FASTASequenceActionMenuBuilder.swift:83-90` |
| `Align with MAFFT…` needs at least two selected contigs | `FASTASequenceActionMenuBuilder.swift:113-118` |
| The Export FASTA save panel pre-fills a `.fa` filename derived from the same suggested name | `AssemblyResultViewController.swift:387, 397-400` |
| Copy FASTA writes the selection to the clipboard through the same `extract contigs` call | `AssemblyContigMaterializationAction.swift:39-42` |
| The derived bundle's metadata carries the assembler, the source assembly name, the selected contig list, and a selection summary | `ExtractContigsCommand.swift:315-321`, `AssemblySubsetBundleMetadata.swift` |
| A `Create Bundle` run can fail with "Could not resolve the enclosing Lungfish project root", which happens when the assembly sits outside a project | `AssemblyContigMaterializationAction.swift:19-21` |
| The failure alert "Reference Bundle Creation Failed" | `ViewerViewController.swift:2438-2450` |
| The three assembly panel layouts, which change where the detail pane sits relative to the table | `AssemblyLayoutPreference.swift:9-22` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `create-bundle-action-bar`, captioned "The assembly result action bar with three contigs selected in the table and the Create Bundle button enabled." | Valid | Both true (`AssemblyActionBar.swift:13, 59-64`). With three selected, the first button reads "BLAST Contigs", which the caption may note. |
| `<!-- planned: create-bundle-action-bar -->` marker after procedure step 4 | Keep | Right place in the corrected procedure. |
| `derived-bundle-in-sidebar`, captioned "The derived reference bundle in the project sidebar under Reference Sequences/, named with the -subset default." | Retake with a new caption | The folder is right (`ExtractContigsCommand.swift:305`), but `-subset` is the CLI default only. A bundle made with the button carries the contig identifier or `<run folder>-selected-contigs`. Recaption to match whichever path the shot actually uses, and prefer the button path since that is what the chapter's worked example does. |
| `<!-- planned: derived-bundle-in-sidebar -->` marker in the worked example | Keep | Right place. |

## Could not verify

Two claims resisted a source-only verdict.

The wall-clock estimates in chapter 02 ("A SARS-CoV-2 amplicon run on a laptop
typically finishes in two to five minutes; a bacterial isolate at 100x coverage
takes ten to thirty") and in chapter 03 ("the assembly finishes in a few
minutes") cannot be checked without running an assembly, which this review does
not do. They are plausible and should be confirmed by whoever captures the
screenshots, since that run produces the timing.

The wizard's rendered dimensions are fixed at 620 by 640 points when it opens
standalone (`AssemblyWizardSheet.swift:319-322`), which is wider and taller than
the 480 to 520 by 400 to 520 range the project's dialog convention records. No
chapter states a size, so nothing is wrong in the manual, but a screenshot
reviewer should expect a larger sheet than the other wizards.

## One defect to route to engineering, not to the rewrite

`AssemblyOptionCatalog.swift:126-131` declares Minimum Contig Length as
applying to SPAdes with the summary "Lungfish post-filter". The wizard reads
that mapping to decide whether to show the Min Contig stepper
(`AssemblyWizardSheet.swift:232-236`), so with SPAdes selected the stepper is
visible and editable. No SPAdes post-filter exists. `buildSPAdesCommand`
(`ManagedAssemblyPipeline.swift:176-206`) never reads `minContigLength`, and
`AssemblyOutputNormalizer.swift:23-27, 65` computes statistics from the
unfiltered `contigs.fasta`. A user who sets Min Contig with SPAdes selected
gets a silently ignored setting. Either the pipeline should apply the filter or
the catalog should stop mapping the option to SPAdes.
