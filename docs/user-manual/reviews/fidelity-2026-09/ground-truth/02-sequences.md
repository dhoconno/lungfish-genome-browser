# Reality map: 02-sequences

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/ToolsMenuModel.swift`
- `Sources/LungfishApp/App/AppDelegate+SequenceMenu.swift`
- `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift`
- `Sources/LungfishApp/Views/ImportCenter/ImportCenterView.swift`
- `Sources/LungfishApp/Views/Viewer/SequenceViewerView+Interaction.swift`
- `Sources/LungfishApp/Views/Viewer/ViewerViewController+Extraction.swift`
- `Sources/LungfishApp/Views/Viewer/FASTASequenceExtractionDialog.swift`
- `Sources/LungfishApp/Views/Viewer/EnhancedCoordinateRulerView.swift`
- `Sources/LungfishApp/Views/Viewer/MultipleSequenceAlignmentViewController.swift`
- `Sources/LungfishApp/Views/Viewer/MSAAlignmentExportSheet.swift`
- `Sources/LungfishApp/Views/Viewer/MSAAlignmentNumberingMode.swift`
- `Sources/LungfishApp/Views/Sequence/SequenceORFOperationDialog.swift`
- `Sources/LungfishApp/Views/Metagenomics/ClassifierExtractionDialog.swift`
- `Sources/LungfishApp/Views/DatabaseBrowser/GenBankGenomesSearchPane.swift`
- `Sources/LungfishApp/Views/DatabaseBrowser/PathoplexusSearchPane.swift`
- `Sources/LungfishApp/Views/DatabaseBrowser/DatabaseBrowserPane.swift`
- `Sources/LungfishApp/Views/DatabaseBrowser/DatabaseBrowserViewController.swift`
- `Sources/LungfishApp/Views/DatabaseBrowser/DatabaseSearchDialogState.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift`
- `Sources/LungfishApp/Views/Phylogenetics/IQTreeInferenceDialog.swift`
- `Sources/LungfishApp/Views/MainWindow/MainWindowController.swift`
- `Sources/LungfishApp/Views/Sidebar/SidebarViewController+MenuDelegate.swift`
- `Sources/LungfishApp/Views/Sidebar/SidebarViewController+OutlineDataSource.swift`
- `Sources/LungfishApp/Views/TranslationTool/TranslationToolView.swift`
- `Sources/LungfishApp/ViewModels/GenBankBundleDownloadViewModel.swift`
- `Sources/LungfishKit/MSASequenceScopePicker.swift`
- `Sources/LungfishPhylogeneticsUI/PhylogeneticTreeViewController.swift`
- `Sources/LungfishWorkflow/MSA/MSAAlignmentRunRequest.swift`
- `Sources/LungfishWorkflow/Bundles/ReferenceSourcePreparer.swift`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `Sources/LungfishCore/Extraction/SequenceExtractor.swift`
- `Sources/LungfishCore/Models/SequenceAnnotation.swift`
- `Sources/LungfishCore/Translation/AminoAcidColors.swift`
- `Sources/LungfishCore/Services/Pathoplexus/PathoplexusService.swift`
- `Sources/LungfishCLI/Commands/FetchCommand.swift`
- `Sources/LungfishCLI/Commands/BundleCommand.swift`
- cli-help dumps `align.txt`, `tree.txt`, `msa.txt`, `fetch.txt`, `import.txt`, `sequence.txt`, `extract.txt`, `translate.txt`, `bundle.txt`, `bam.txt`
- `docs/user-manual/features.yaml`
- `docs/release-notes/2026.9.8.md` through `2026.9.13.md`

Two cross-cutting corrections govern every chapter in this part.

1. There is no `Tools > FASTQ/FASTA Operations` submenu. The Tools menu is now built from operation categories, one submenu per category, each holding the tools in that category (`MainMenu.swift:704-706`, `MainMenu.swift:786-819`, `ToolsMenuModel.swift:31-56`). MAFFT sits in the `Multiple Sequence Alignment` category (`FASTQOperationDialogState.swift:2065-2066`, `ToolsMenuModel.swift:69`) and its menu item is titled `MAFFT…` (`FASTQOperationDialogState.swift:1983`, `MainMenu.swift:810`). The correct path is `Tools > Multiple Sequence Alignment > MAFFT…`. "FASTQ/FASTA Operations" survives only as the dialog's own title (`FASTQOperationDialogState.swift:1251`).
2. `Sequence > Translate…` does not open the overlay translation tool. It runs the `translate` FASTQ/FASTA operation on the active sequence (`AppDelegate+SequenceMenu.swift:28-37`, `viewerView.runSelectedSequenceFASTAOperation(toolID: .translate)`). The overlay tool with Mode, Genetic Code, Color Scheme, and Show Stop Codons is reached from the window toolbar's `Translate` button (`MainWindowController.swift:941-956`, `showTranslationTool(_:)` at `:470-501`).

---

## 01-importing-and-viewing.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish keeps every genome you work with inside a **reference bundle**: a folder with the `.lungfishref` extension" | true | `import.txt` "import fasta" banner, "Import a standalone reference sequence file as a .lungfishref bundle" | |
| 2 | "Importing converts a loose `.fasta` or `.gb` on your Desktop into a bundle in the project's `Reference Sequences/` folder." | true | `ImportCenterViewModel.swift:179` tab title "Reference Sequences"; `ONTGenotypingPipeline.swift:422` uses the same folder name | |
| 3 | "A GFF3 (or GTF or BED) carries features only, with no sequence, so it is not a way to create a bundle on its own. You attach a GFF3 to a reference bundle that already exists." | true | `ImportCenterViewModel.swift:549-551`, Annotation Track card, "Attach GTF, GFF, GFF3, or BED annotations to an existing reference sequence bundle." | |
| 4 | Format table row FASTA, "`.fasta`, `.fa`, `.fna`" | changed | `ImportCenterViewModel.swift:514` fileHint lists `.fa, .fasta, .fna, .faa, .ffn, .frn, .gb, .gbk, .gbff, .genbank, .embl`; the open panel also accepts `.fas` and `.fsa` (`:527-528`) | Add `.faa`, `.ffn`, `.frn`, `.fas`, and `.fsa` to the FASTA row |
| 5 | Format table row GenBank, "`.gb`, `.gbk`, `.gbff`" and "EMBL (`.embl`) is also accepted" | true | `import.txt` "import fasta" argument line, "(.fa/.fasta/.gb/.embl, optionally .gz/.bgz/.bz2/.xz/.zst)"; `ImportCenterViewModel.swift:514` adds `.genbank` | |
| 6 | Format table row Compressed, "`.gz`, `.bgz`, `.bz2`, `.xz`, `.zst`" | changed | `ImportCenterViewModel.swift:534-535` also accepts `.gzip` and `.zstd` | Add `.gzip` and `.zstd` |
| 7 | "Compressed FASTA or GenBank ... Carries annotations: No" | false | Compression is a wrapper. A compressed GenBank still carries its features, and `ReferenceSourcePreparer.swift:130-162` decompresses then reads annotations from the GenBank input | Set the Carries annotations cell to "Same as the uncompressed format" |
| 8 | "When a GenBank record imports, Lungfish converts its features into an annotation track named `imported_annotations`." | true | `ReferenceSourcePreparer.swift:154-161`, `id: "imported_annotations"`, display name "Imported Annotations" | |
| 9 | "Open the project window, then drag the `.fasta` or `.gb` from the Finder onto the **Reference Sequences** folder in the sidebar." | changed | `SidebarViewController+OutlineDataSource.swift:171-233` accepts a file-URL drop on the outline view and posts an import notification. The drop is not restricted to the Reference Sequences row | "drag the file from the Finder onto the project sidebar" |
| 10 | "Open it from the menu bar with **File > Import Center…**, or press Cmd-Shift-I." | true | `MainMenu.swift:207-213`, title "Import Center…", keyEquivalent "i", modifier `[.command, .shift]` | |
| 11 | "The sheet shows a drop zone and a format picker, and previews the file before you commit. Click **Import** when the preview looks right." | false | `ImportCenterView.swift:97-146` renders a window with a six-tab segmented control and a grid of import cards. Each card is its own drop target and carries an `Import…` button (`:230`, `:252`). There is no single drop zone, no format picker, and no file preview | "The window shows a row of tabs and a grid of import cards, one per file kind. Switch to **Reference Sequences**, then drop the file on the **Reference Sequences** card or click that card's **Import…** button." |
| 12 | "The Import Center is also where you attach a standalone GFF3, GTF, or BED file as an annotation track to a bundle that already exists." | true | `ImportCenterViewModel.swift:547-568`, Annotation Track card on the `references` tab | |
| 13 | "lungfish import fasta path/to/MN908947.3.gb" | true | `import.txt` "import fasta" usage line | |
| 14 | "A `--name` flag overrides the default bundle name, which otherwise comes from the source filename, and `-o`/`--output-dir` points at the target project" | true | `import.txt` "import fasta" options, `--name` "(default: filename)" and `-o, --output-dir` "(default: current directory)" | |
| 15 | "The plain FASTA is a single contig ... of 29,903 bases" | unverifiable | The length is a property of the NCBI record, not of LGE. Nothing in `Sources/` asserts it | Leave for the data reviewer |
| 16 | Step 2, "A sheet drops down with a drop zone in the centre." | false | `ImportCenterWindowController.swift` presents a window, and `ImportCenterView.swift:97-146` draws a card grid, not a centred drop zone | "A window opens showing import cards grouped under six tabs." |
| 17 | Step 3, "The format picker auto-detects FASTA and previews the file's contents." | false | No format picker and no preview exist in `ImportCenterView.swift`; the card's `onDrop` calls `performDropImport` directly (`:105-106`) | "Dropping the file on the Reference Sequences card starts the import at once." |
| 18 | Step 4, "Click Import." | false | Same evidence as row 17. The drop itself commits; the `Import…` button (`ImportCenterView.swift:230`) is the alternative to dropping, not a confirmation after it | Delete the separate confirm step |
| 19 | Step 4, "Lungfish creates the bundle at `Reference Sequences/MN908947.3.lungfishref`" | true | `ImportCenterViewModel.swift:179`; the FASTA card's action is `.fasta`, which routes to the `import fasta` path that writes a `.lungfishref` | |
| 20 | "the annotation lane now shows the spike (`S`), nucleocapsid (`N`), ORF1ab, and other coding regions as orange blocks" | false | Feature colors come from a per-type table. `SequenceViewerView+MultiSequence.swift:443` sets `misc_feature` grey, and `SequenceAnnotation.swift:333` gives `mat_peptide` magenta, so a track is multi-coloured by type, not uniformly orange | "as coloured blocks, one colour per feature type" |
| 21 | "Those features land in a track named `imported_annotations`" | true | `ReferenceSourcePreparer.swift:159` | |
| 22 | "Three panes stack vertically. The **position ruler** ... The **base track** ... The **annotation track**" | changed | The ruler is `EnhancedCoordinateRulerView`; base and annotation drawing live in `SequenceViewerView`. These are drawing lanes inside one view, not three named panes, and no literal pane labels exist in source | Say "three lanes stack vertically" and drop the implication that each is a separate labelled pane |
| 23 | "The Inspector on the right summarises the bundle: the source file, contig list, total length, annotation count, and any tracks attached" | changed | `ViewerViewController+SequenceAnnotationSelection.swift:89` shows a `Sequence Length` row; the full row set is assembled per selection across `Views/Inspector/Sections/`. The listed items are plausible but the exact row set is not a single literal list in source | Name only the rows you can point at, or mark the sentence as a summary |
| 24 | "Right-click for rename, reveal in Finder, and move-to-trash actions." | changed | `SidebarViewController+MenuDelegate.swift:312` "Show in Finder", `:335` "Rename...", `:361` "Move to Trash" | "Right-click for **Rename...**, **Show in Finder**, and **Move to Trash**." |
| 25 | "**Sequence > Go to Location…** (Cmd-L)" | true | `MainMenu.swift:643-647`, title "Go to Location…", keyEquivalent "l", no extra modifier | |
| 26 | "The editable position field on the ruler accepts the same input, with placeholder `chr:start-end`." | true | `EnhancedCoordinateRulerView.swift:181`, `field.placeholderString = "chr:start-end"` | |
| 27 | "on a single-contig bundle the bare range `21563-25384` resolves to it" | true | `EnhancedCoordinateRulerView.swift:1066` comment lists the accepted forms, "chr:start-end, chr:start..end, start-end, position" | |
| 28 | "**Sequence > Go to Gene…** (Cmd-Option-G)" | true | `MainMenu.swift:650-656`, keyEquivalent "g" with `[.command, .option]` | |
| 29 | "typing `spike` jumps to the `S` gene at position 21563" | unverifiable | The match behavior depends on the record's own gene names. Nothing in source guarantees `spike` matches `S` | Settle it by running Go to Gene against the MN908947.3 bundle |
| 30 | Right-click Copy submenu, "the feature's name, coordinates, bases, complement, reverse complement, or FASTA, with a protein-FASTA option on CDS features" | changed | `SequenceViewerView+Interaction.swift:967-1008` gives "Copy Name", "Copy Coordinates", "Copy Sequence", "Copy Complement", "Copy Reverse Complement", "Copy as FASTA", and on CDS "Copy Translation as FASTA" | Use the literal item titles, in particular **Copy Sequence** rather than "bases" |
| 31 | "**Extract Sequence...**: writes the feature's bases to a fresh bundle or FASTA." | true | `SequenceViewerView+Interaction.swift:1013`, title "Extract Sequence…"; the sheet's destinations are bundle, file, clipboard, and share (`ClassifierExtractionDialog.swift:17-31`) | |
| 32 | "**Run FASTQ/FASTA Operation...**: sends the feature's sequence into the operations dialog." | true | `SequenceViewerView+Interaction.swift:1018`, exact title | |
| 33 | "**Zoom to Annotation**: fits the view to the feature." | true | `SequenceViewerView+Interaction.swift:1026` | |
| 34 | "**Edit Annotation...** and **Delete Annotation**: revise or remove it." | true | `SequenceViewerView+Interaction.swift:1058`, `:1063` | |
| 35 | The annotation-menu bullet list omits "Show Annotation in Inspector" | changed | `SequenceViewerView+Interaction.swift:1050` adds "Show Annotation in Inspector" to the same menu | Add it to the bullet list, or say the list is partial |
| 36 | "**Copy Visible Region** puts its bases on the clipboard, **Zoom to Visible Region** fits the view to it, and **Center View Here** recentres on the click point." | false | `SequenceViewerView+Interaction.swift:720` gives "Copy Visible Region" and `:1082` gives "Center View Here", but there is no "Zoom to Visible Region". The zoom items are "Zoom to Fit" (`:684`) and, only when an alignment selection exists, "Zoom to Selected Region" (`:738`) | "**Copy Visible Region** puts its bases on the clipboard and **Center View Here** recentres on the click point. **Zoom to Fit** returns the whole sequence to view." |
| 37 | "Right-click a region you have dragged out instead, and the menu turns to the selection" | changed | The selected-range menu is appended by `appendSelectedRangeMenuItems` (`:715-742`), but its Copy item still acts on the visible viewport region (`ViewerViewController+Extraction.swift:213-215`, `currentVisibleViewportRegion()`), not on the drag | Say the items act on the visible region even when a drag selection exists |
| 38 | "the standard code (table 1) covers most nuclear genes, while alternatives cover vertebrate mitochondria (table 2), yeast mitochondria (table 3), and bacteria (table 11)" | true | `translate.txt` `--table` line, "1=standard, 2=vertebrate mito, 3=yeast mito, 11=bacterial" | |
| 39 | "there are six: three on the forward strand (`+1`, `+2`, `+3`) and three on the reverse-complement strand (`-1`, `-2`, `-3`)" | true | `sequence.txt` `--frames` default `+1,+2,+3,-1,-2,-3` | |
| 40 | "Open a sequence bundle, then choose **Sequence > Translate...**. A sheet opens with a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`" | false | `Sequence > Translate…` runs the `translate` FASTQ/FASTA operation (`AppDelegate+SequenceMenu.swift:28-37`). The Mode control belongs to `TranslationToolView` (`TranslationToolView.swift:12-15`), opened by the toolbar's `Translate` button (`MainWindowController.swift:941-956`) | "Open a sequence bundle, then click **Translate** in the window toolbar. A sheet opens with a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`" |
| 41 | "Choose the genetic code under `Genetic Code`." | true | `TranslationToolView.swift:111`, `Picker("Genetic Code", ...)` | |
| 42 | "the `Color Scheme` picker sets how the overlaid residues are tinted: `Zappo` (the default, grouping by physicochemical property), `ClustalX`, `Taylor`, or `Hydrophobicity`" | true | `TranslationToolView.swift:123`; `AminoAcidColors.swift:26-29` gives the four titles in that order, and `:36` describes Zappo as grouping by physicochemical property | |
| 43 | "Leave `Show Stop Codons` on if you want stop positions marked, and click `Apply`. ... `Hide Translation` clears it." | true | `TranslationToolView.swift:130`, `:159`; `MainWindowController.swift:483-494` wires Apply to `applyFrameTranslation` and the empty-frame case to `hideTranslation` | |
| 44 | "Under `Display Options`" | unverifiable | No literal `Display Options` string appears in `TranslationToolView.swift`. The Color Scheme and Show Stop Codons controls exist but the section heading is not confirmed | Read the sheet in the running app, or drop the section name |
| 45 | "lungfish translate MN908947.3.fasta --frame 1 --table 1 -o spike-protein.fasta" | true | `translate.txt` usage and options | |
| 46 | "Frames `1` to `3` are the forward strand; `4` to `6` are the reverse complement. Omit `--frame` to translate all six." | true | `translate.txt` overview, "Reading frames 1-3 are forward strand, 4-6 are reverse complement ... By default, all 6 frames are translated" | |
| 47 | "`--table` selects the genetic code (default 1, the standard code)" | true | `translate.txt` `--table` "(default: 1)" | |
| 48 | "`--trim-to-stop` cuts each translation at its first stop codon, `--no-stop-asterisk` drops the `*` characters that mark stops, and `--longest-orf` keeps only the longest stop-free stretch per frame" | true | `translate.txt`; `--longest-orf` reads "Output only the longest open reading frame per sequence per frame" | |
| 49 | "The command drops a provenance sidecar next to the output, recording the exact options used." | unverifiable | `translate.txt` shows no provenance flag, and `TranslateCommand.swift` was not read for a sidecar writer | Confirm against `Sources/LungfishCLI/Commands/TranslateCommand.swift` |
| 50 | "the global `--format json` flag prints a machine-readable summary of the run (input and output files, sequence and translation counts, and the genetic code)" | changed | `translate.txt` confirms `--format <format>` with values text, json, tsv. The exact JSON payload fields are not visible in help | Keep the flag, drop the field list unless you verify it from a run |
| 51 | "The type menu offers `gene`, `CDS`, `exon`, `mRNA`, `region`, `misc_feature`, `promoter`, `primer`, and `restriction_site`; the strand menu offers `+`, `-`, or `none`. Click **Add**." | true | `AppDelegate+SequenceMenu.swift:499-502`, `:510`, `:478` | |
| 52 | "Drag across the bases in the sequence viewport to select a region, then choose **Sequence > Add Annotation...**." | true | `MainMenu.swift:676-680`; `AppDelegate+SequenceMenu.swift:468-471` requires an explicit selection and otherwise shows "Please select a region of the sequence first." | |
| 53 | "Choose **Sequence > Find ORFs...** on an open reference bundle." | true | `MainMenu.swift:682-686`, title "Find ORFs…" with the ellipsis | |
| 54 | "`Reading Frames`: checkboxes for `+1`, `+2`, `+3`, `-1`, `-2`, `-3` (all six on by default)" | true | `SequenceORFOperationDialog.swift:173-181`, `:34` `defaultFrames: ReadingFrame.allCases` | |
| 55 | "`Codon table` ... `Minimum ORF length`: the shortest ORF to keep, in nucleotides (default 100) ... `Include partial ORFs` ... `Allow alternative starts`" | true | `SequenceORFOperationDialog.swift:183`, `:191`, `:36` default 100, `:203`, `:205`; `sequence.txt` `--min-length` "(default: 100)" | |
| 56 | "`Allow alternative starts`: also treat `GTG`, `TTG`, and `CTG` as starts." | unverifiable | `sequence.txt` says only "Allow alternative starts for the selected genetic code." The specific codons depend on the chosen NCBI table and were not confirmed in the codon-table source | Say "also treat the selected genetic code's alternative start codons as starts" |
| 57 | "a `Track name` field, prefilled with the sequence name followed by ` ORFs` (for the SARS-CoV-2 reference, `MN908947.3 ORFs`), and a `Track ID` field" | true | `AppDelegate+SequenceMenu.swift:681`, `let defaultTrackName = "\(sequenceName) ORFs"`; `SequenceORFOperationDialog.swift:196-198` | |
| 58 | "Click **Run**." | true | `SequenceORFOperationDialog.swift:153`, `primaryActionTitle: "Run"` | |
| 59 | "one feature per ORF, each carrying its translated protein as an attribute" | true | `SequenceORFOperationDialog.swift:58` subtitle, "Add ORF annotations with translated products." | |
| 60 | "the `--track-name` option instead defaults to `ORFs`" | false | `sequence.txt` `--track-name` shows no default at all, only "Annotation track display name." Only `--track-id` documents a fallback | "the `--track-name` option has no default, so pass it when you want a named track" |
| 61 | "lungfish sequence annotate-orfs MN908947.3.lungfishref --frames +1,+2,+3 --table 1 --min-length 300 --track-name \"ORFs\"" | true | `sequence.txt` "sequence annotate-orfs" usage and options all match | |
| 62 | "lungfish bam annotate-cds-best --bundle ... --mapping-result ... --output-bundle ... --output-track-name ..." | true | `bam.txt:146`, all four options are required in the usage line | |
| 63 | "The `--min-query-cover` option sets that bar (default 0.5, meaning at least half of the CDS query must be covered)" | true | `bam.txt:161-163`, "Minimum fraction of the CDS query covered by aligned components (default: 0.5)" | |
| 64 | "The error sheet names the file, the line number where parsing stopped, and the offending text." | unverifiable | No literal error-sheet template was found on the import path | Open a malformed FASTA in the app and record the real message |
| 65 | "Lungfish accepts the standard nucleotide letters (`A`, `C`, `G`, `T`, plus ambiguity codes like `N`) and gap characters." | unverifiable | Not confirmed from the FASTA reader in this pass | Confirm against `Sources/LungfishIO/Formats/FASTA` |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Import Center's six tabs (Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, Application Exports) | `ImportCenterViewModel.swift:173-181` |
| The Import Center cards for `Geneious Export` and `Primer Scheme`, both reachable from the same window | `ImportCenterViewModel.swift:571-594` |
| `Sequence > Reverse Complement…` (Cmd-Shift-R), the sibling of Translate on the same menu | `MainMenu.swift:627-632` |
| The window toolbar's `Translate` button as the only route to the overlay translation tool | `MainWindowController.swift:941-956` |
| `File > Export > Sequences (FASTA/GenBank)…` and `File > Export > Annotations (GFF3)…`, the round trip out of a bundle | `MainMenu.swift:220-231` |
| The `File > Export > Provenance` submenu, which writes the bundle's provenance record | `MainMenu.swift:259-271` |
| The viewport's `Show All Translations` and `Hide All Translations` context items in multi-sequence mode | `SequenceViewerView+Interaction.swift:695-707` |
| `Show Annotation in Inspector` on the annotation context menu | `SequenceViewerView+Interaction.swift:1050` |
| `lungfish sequence delete-annotations` and `lungfish sequence delete-annotation-track`, the only way to remove a track added here | `sequence.txt:61`, `:88` |
| `annotate-orfs` scoping options `--sequence`, `--start`, `--end`, which pick the contig and sub-range | `sequence.txt:26-32` |
| `bam annotate-cds-best` options `--include-secondary`, `--include-supplementary`, `--output-track-id`, `--replace` | `bam.txt:157-167` |
| `lungfish extract sequence --line-width` (default 70), which sets FASTA wrapping | `extract.txt:55-56` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: import-center-fasta`, "The Import Center with a FASTA file selected." | No | The Import Center has no file-selection state to photograph. Reshoot as the Reference Sequences tab with the Reference Sequences card highlighted as a drop target (`ImportCenterView.swift:196-252`) |
| `<!-- planned: import-center-fasta -->` at step 1 | No | It sits under "Open a project", before the Import Center is open. Move it to the corrected step 2 |
| `planned_shots: sequence-viewport-genbank`, "An annotated GenBank record open in the sequence viewport." | Yes | The annotated GenBank case is unchanged. The caption should say "coloured blocks, one colour per feature type" rather than orange |
| `<!-- planned: sequence-viewport-genbank -->` under "What you see in the viewport" | Yes | Correctly placed |
| `illustrations: reference-bundle-anatomy` | Yes | The bundle layout (FASTA, FAI, manifest, provenance) is unchanged |
| `illustrations: viewport-panes` | Changed | The illustration labels three "panes". Relabel as lanes to match claim 22 |

---

## 02-downloading-from-ncbi.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish reaches them through `Tools > Search Online Databases > Search NCBI…`" | true | `MainMenu.swift:741-745`, title "Search NCBI..." inside the "Search Online Databases" submenu | |
| 2 | "which opens a search dialog on its \"GenBank & Genomes\" tab" | true | `DatabaseSearchDialogState.swift` tab titles; the NCBI item selects the `GenBankGenomesSearchPane` | |
| 3 | "The download writes a `.lungfishref` reference bundle straight into the project, with a provenance sidecar recording where it came from." | true | `GenBankBundleDownloadViewModel.swift:73-181` builds the bundle directly | |
| 4 | "leave the \"Include GFF3 Annotations\" toggle on" | true | `GenBankGenomesSearchPane.swift:7`, `:36`; the default is `true` (`DatabaseBrowserViewController.swift:773`) | |
| 5 | "a bundle-owned annotation track converted from the record's `gene`, `CDS`, and `mat_peptide` features" | false | The GFF3 path stores every feature row the server returns. `GenBankBundleDownloadViewModel.swift:280-285` counts any nine-column non-comment line, with no feature-type filter, and the fallback BED writer applies none either | "converted from every feature the record carries" |
| 6 | "Search for these with Mode set to **Nucleotide**, or **Virus** for curated viral records." | true | `GenBankGenomesSearchPane.swift:6`, `modeTitles = ["Nucleotide", "Genome", "Virus"]` | |
| 7 | "The dialog handles them with Mode set to **Genome**, which downloads the assembly FASTA plus its GFF3 and builds a `.lungfishref` bundle." | true | `GenBankGenomesSearchPane.swift:6`; `fetch.txt` "fetch genome" overview, "including the FASTA sequence and GFF3 annotations, then creates a .lungfishref bundle" | |
| 8 | "The GUI has no four-way file-format menu." | true | `GenBankGenomesSearchPane.swift:22-38` offers only Mode plus the two toggles | |
| 9 | Control table rows "Include GFF3 Annotations", "RefSeq Only", "Mode: Nucleotide / Virus", "Mode: Genome" | true | `GenBankGenomesSearchPane.swift:6-7` | |
| 10 | "RefSeq Only ... Restricts results to curated RefSeq records (the `NC_`/`GCF_` series)." | changed | `DatabaseBrowserViewController.swift:1072` applies `refseqOnly` only when the mode is `.nucleotide`, while the pane shows the toggle for nucleotide and virus (`GenBankGenomesSearchPane.swift:30-33`). Its effect in Virus mode is not established | Say it filters nucleotide searches to RefSeq records |
| 11 | "Switch **Mode** to **Genome** and the **Include GFF3 Annotations** and **RefSeq Only** checkboxes disappear" | true | `GenBankGenomesSearchPane.swift:30`, `:35`, both guarded on `.virus || .nucleotide` | |
| 12 | "The four file formats FASTA, GenBank, GFF3, and XML are a command-line concept, exposed through `lungfish fetch ncbi --fetch-format`." | true | `fetch.txt` `--fetch-format` "genbank, fasta, gff3, xml (default: genbank)" | |
| 13 | Step 2, "Set **Mode** to `Nucleotide`. Leave **Include GFF3 Annotations** on" | true | The defaults are already Nucleotide and on (`DatabaseBrowserViewController.swift:731`, `:773`) | |
| 14 | Step 4, "The primary button changes from **Search** to **Download Selected**." | true | `DatabaseSearchDialogState.swift:112-114`, `activeViewModel.selectedRecords.isEmpty ? "Search" : "Download Selected"` | |
| 15 | Step 5, "Lungfish downloads the record and builds a `.lungfishref` reference bundle in one action" | true | `GenBankBundleDownloadViewModel.swift:40-181` | |
| 16 | "the annotation track `annotations/imported_annotations.gff3`" | false | The GUI writes `annotations/ncbi_gff3_annotations.db` with track id `ncbi_gff3_annotations` and name "NCBI GFF3 Annotations" (`GenBankBundleDownloadViewModel.swift:255`, `:267-269`). When the GFF3 fetch fails it falls back to `annotations/ncbi_genbank_annotations.db`, id `ncbi_genbank_annotations` (`:154`, `:161-165`). `imported_annotations` is the file-import track, not the download track (`ReferenceSourcePreparer.swift:159`) | "the annotation track `annotations/ncbi_gff3_annotations.db`, named NCBI GFF3 Annotations" |
| 17 | "a `.lungfish-provenance.json` sidecar recording the source, the output checksums, file sizes, runtime, exit status, and wall time" | changed | The CLI sidecar carries endpoint, apiKeyProvided, retryCount, retryEvents, and a SHA-256 checksum (`FetchCommand.swift:409-449`). Runtime, exit status, and wall time are not among those fields | List the fields the CLI actually writes, and mark the GUI sidecar as separately checked |
| 18 | "For a viral genome over a normal connection, that usually takes a second or two." | unverifiable | A network timing claim with no code backing | Drop or soften |
| 19 | "lungfish fetch ncbi MN908947.3 --fetch-format genbank --save-to ./Downloads/MN908947.3.gb" | true | `fetch.txt` "fetch ncbi" usage and examples | |
| 20 | "lungfish import fasta ./Downloads/MN908947.3.gb --output-dir . --name MN908947.3" | true | `import.txt` "import fasta" usage | |
| 21 | "recording the resolved endpoint, the accession, the output checksum ..., the file size, retry events, whether an API key was provided, and the exact command line" | true | `FetchCommand.swift:409-415`, `:449` | |
| 22 | "The sidecar records only `apiKeyProvided: true` or `false`; it never writes the key itself." | true | `FetchCommand.swift:409`, `:468` | |
| 23 | "`lungfish fetch ncbi` takes several accessions in one call" | true | `fetch.txt` `<accessions> ...` argument and the example `lungfish fetch ncbi MN908947 NM_000546 --save-to sequences.gb` | |
| 24 | "the GUI can import an accession list from a CSV or text file and queue the whole set for download" | true | `DatabaseBrowserViewController.swift`, the `importAccessionList` path | |
| 25 | "`lungfish fetch search` runs a query and lists the matching accessions" | true | `fetch.txt:60`, "Search NCBI databases and list matching accessions" | |
| 26 | "`lungfish fetch ena search`, `lungfish fetch ena fasta`, and `lungfish fetch ena reads`" | true | `fetch.txt:224`, `:250`, `:276` | |
| 27 | "`--fasta-only` saves just the decompressed FASTA and skips both annotations and the bundle, while `--no-bundle` keeps the FASTA and the annotations but stops short of assembling them" | true | `fetch.txt` "fetch genome" options, "(no annotations, no bundle)" and "Download files but don't create a .lungfishref bundle" | |
| 28 | "`--output-dir` sets the destination (default the current directory) and `--name` overrides the bundle name" | true | `fetch.txt` "fetch genome" options, "(default: .)" and "(default: derived from assembly)" | |
| 29 | "`--db nucleotide` or `--db protein` picks the database" | true | `fetch.txt` "fetch ncbi" `--db` "nucleotide, protein (default: nucleotide)" | |
| 30 | "`--api-key <key>` (or the `NCBI_API_KEY` environment variable) raises NCBI's rate limit" | true | `fetch.txt` `--api-key`; `FetchCommand.swift:468` reads the environment fallback | |
| 31 | "HTTP 429 rate-limit responses are retried automatically with exponential backoff ... Scripts that would rather fail fast can add `--no-retry`." | true | `fetch.txt` `--no-retry` "Do not retry HTTP 429 rate-limit responses"; `FetchCommand.swift:138` snapshots retry events | |
| 32 | "you will see the source URL it actually hit (so you can confirm whether you fetched from `eutils.ncbi.nlm.nih.gov` or a mirror)" | changed | `FetchCommand.swift:415` hard-codes `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi` for the NCBI path, so the field never names a mirror | Drop the mirror clause |
| 33 | "reached through the `Tools > Search Online Databases > Search Pathoplexus…` menu item" | true | `MainMenu.swift:753-757`, title "Search Pathoplexus..." | |
| 34 | "On first use, read and accept the ABS/data-use notice. Lungfish stores that consent locally" | unverifiable | `PathoplexusSearchPane.swift:19` shows a consent-aware header line, but the notice text and the gating were not read in full | Confirm against the consent view model |
| 35 | "narrow with the filter fields: Country, Host, Clade, Lineage, Nucleotide Mutations, Amino Acid Mutations, Collection Date, Sequence Length, and INSDC Source" | true | `DatabaseBrowserPane.swift:314`, `:320`, `:328`, `:334`, `:342`, `:348`, `:356`, `:369`, `:386` | |
| 36 | "Clade takes a clade label such as `IIb`, Lineage a lineage designation such as `B.1`." | true | `DatabaseBrowserPane.swift:329` placeholder "e.g., IIb"; `:335` placeholder "e.g., B.1" | |
| 37 | "Nucleotide Mutations takes comma-separated nucleotide changes such as `C180T, A200G`, while Amino Acid Mutations takes gene-qualified residues such as `GP:440G`." | true | `DatabaseBrowserPane.swift:344` and `:350` placeholders | |
| 38 | "INSDC Source is a three-way picker, `Any`, `INSDC Only`, or `Non-INSDC Only`" | true | `DatabaseBrowserViewController.swift:599-602` | |
| 39 | "The filters combine with AND logic across organism, provenance, and sequence attributes." | true | `DatabaseBrowserPane.swift:396`, the caption is verbatim | |
| 40 | "The search returns OPEN records only, so restricted sequences never appear in the results." | unverifiable | Not confirmed from `PathoplexusService.swift` in this pass | Confirm against the query builder |
| 41 | "When a record carries an INSDC accession, Lungfish tries the GenBank path first and appends Pathoplexus metadata; if that retrieval fails, or no INSDC accession exists, it builds a FASTA-backed bundle from the Pathoplexus record instead." | true | `DatabaseBrowserViewController.swift:2756`, `:2791` both call `genBankVM.buildBundleFromSequence`, the FASTA-backed fallback described at `GenBankBundleDownloadViewModel.swift:287-291` | |
| 42 | "a fixed catalogue of ten outbreak-relevant pathogens: Mpox virus, Marburg virus, measles, the Sudan and Zaire ebolaviruses, RSV-A and RSV-B, human metapneumovirus, West Nile virus, and Crimean-Congo hemorrhagic fever" | true | `PathoplexusService.swift:194-204`, exactly those ten | |
| 43 | "Crimean-Congo hemorrhagic fever, for one, splits into `S`, `M`, and `L` segments" | true | `PathoplexusService.swift:194`, `segmented: true, segments: ["S", "M", "L"]` | |
| 44 | "the result is the same: a `.lungfishref` reference bundle in the project's `Reference Sequences/` folder with a provenance sidecar" | true | `GenBankBundleDownloadViewModel.swift` writes a `.lungfishref`; `ImportCenterViewModel.swift:179` names the folder | |
| 45 | "SRA accessions begin with `SRR`, `ERR`, or `DRR` and route through `lungfish fetch sra`, which uses an ENA mirror and falls back to the SRA Toolkit." | changed | `fetch.txt:95` confirms `fetch sra` with `search`, `download`, and `info`. The ENA-mirror-then-toolkit ordering is not stated in help | Keep the command, verify the fallback order against `SRAService.swift` |
| 46 | "For an assembly accession (`GCF_` or `GCA_`), switch Mode to Genome, or use `lungfish fetch genome`" | true | `fetch.txt` "fetch genome" overview, "Assembly accessions (GCF_/GCA_) are resolved through the assembly database" | |
| 47 | "if the record genuinely has none, choose a RefSeq record instead, which usually does" | unverifiable | A claim about NCBI content, not about LGE | Leave as editorial advice |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| `lungfish fetch search` options `--limit` (default 20) and `--organism` | `fetch.txt:76-79` |
| `lungfish fetch search --db genome`, a third database the fetch command does not offer | `fetch.txt:76-77` |
| `lungfish fetch genome --api-key`, the rate-limit flag on the assembly path | `fetch.txt:338` |
| `lungfish fetch genome` accepting a plain nucleotide accession, and the warning that the assembly database substitutes a different record for one | `fetch.txt:307-311` |
| `Tools > Search Online Databases > Search SRA...`, the third item in the same submenu | `MainMenu.swift:747-751` |
| The SRA Runs tab living in the same dialog as the NCBI and Pathoplexus tabs | `SRARunsSearchPane.swift` |
| The Pathoplexus organism requirement, which blocks a download with "Select a Pathoplexus organism" | `DatabaseBrowserViewController.swift:2447-2451` |
| The GFF3-fetch failure fallback to GenBank FEATURES, which silently changes the track id and name | `GenBankBundleDownloadViewModel.swift:130-165` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: ncbi-search-dialog` | Yes | The Mode picker, both toggles, the results list, and the Search-to-Download-Selected button swap all still exist as described |
| `<!-- planned: ncbi-search-dialog -->` before step 1 | Yes | Correctly placed ahead of the procedure |
| `planned_shots: ncbi-bundle-prompt`, "The .lungfishref bundle produced directly by Download Selected" | Changed | Valid as a shot, but any visible track name must read `NCBI GFF3 Annotations`, not `imported_annotations` |
| `<!-- planned: ncbi-bundle-prompt -->` after step 5 | Yes | Correctly placed |
| `illustrations: ncbi-accession-anatomy` | Yes | Accession shape and the nucleotide-versus-assembly split are unchanged |

---

## 03-extracting-and-comparing.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish handles these jobs from the `Sequence` menu of an open sequence viewport." | true | `MainMenu.swift:621-689` | |
| 2 | "extract a visible range as a new reference bundle, copy a visible range to the clipboard as FASTA, reverse-complement a selected range, or translate it" | true | `MainMenu.swift:627-667` | |
| 3 | Operations table, "Extract Visible Region ... `Sequence > Extract Visible Region…` ... `Cmd-Shift-E`" | true | `MainMenu.swift:666-671` | |
| 4 | "Copy Visible Region as FASTA ... `Cmd-Shift-C`" | true | `MainMenu.swift:659-665` | |
| 5 | "Reverse Complement ... `Sequence > Reverse Complement…` ... `Cmd-Shift-R`" | true | `MainMenu.swift:627-632` | |
| 6 | "Translate ... `Sequence > Translate…` ... `Cmd-Shift-T`" | true | `MainMenu.swift:634-639` | |
| 7 | "Find ORFs ... `Sequence > Find ORFs` ... none" | changed | `MainMenu.swift:682-686` gives the title "Find ORFs…" with an ellipsis. The empty shortcut is right | Write the menu path as `Sequence > Find ORFs…` |
| 8 | "Add Annotation ... `Sequence > Add Annotation…` ... none" | true | `MainMenu.swift:676-680` | |
| 9 | "`Copy Visible Region as FASTA` and `Find ORFs` carry no ellipsis, yet Find ORFs still opens a dialog." | false | Find ORFs does carry the ellipsis (`MainMenu.swift:683`). Only Copy Visible Region as FASTA lacks one | "`Copy Visible Region as FASTA` is the only item here without an ellipsis, and it acts at once." |
| 10 | "`Cmd-Shift-C` overrides the standard macOS Copy because the active window is a sequence viewport." | changed | Cmd-Shift-C is not the standard macOS Copy, which is Cmd-C. `MainMenu.swift:659-664` simply assigns Cmd-Shift-C to this item | Drop the override claim |
| 11 | Step 2, "Drag across the ruler, or type coordinates into the position field ... The selected range lights up orange. The dialog extracts whatever region is visible" | changed | The position field and placeholder are real (`EnhancedCoordinateRulerView.swift:181`), and the dialog does read the visible viewport region (`ViewerViewController+Extraction.swift:248-264`), but a drag selection does not narrow it and no orange highlight is asserted in source | "Frame the region by typing coordinates into the position field. Extraction takes whatever the viewport is showing, so a drag selection does not narrow it." |
| 12 | Step 3, "A sheet titled **Extract Sequence** opens." | true | `FASTASequenceExtractionDialog.swift:31`, `Text("Extract Sequence")` | |
| 13 | Step 4, "The sheet has a **Destination** radio group and a **Name** field, and no coordinate boxes" | true | `FASTASequenceExtractionDialog.swift:46-76` | |
| 14 | Step 4, "Choose a destination, name the new bundle, and click `Extract`." | false | The primary button is `Create Bundle` for the bundle destination, `Save` for a file, `Copy` for the clipboard, and `Share` for share (`ClassifierExtractionDialog.swift:34-41`; `FASTASequenceExtractionDialog.swift:118`) | "Choose a destination, name the new bundle, and click `Create Bundle`." |
| 15 | Step 4 implies one destination kind | changed | Four destinations exist, Save as Bundle, Save to File…, Copy to Clipboard, and Share… (`ClassifierExtractionDialog.swift:17-31`). The Name field appears only for the first two (`:44-46`) | Name all four, and say the Name field hides for clipboard and share |
| 16 | Step 5, "Lungfish writes a new `.lungfishref` bundle into the project's `Reference Sequences/` folder and selects it in the sidebar." | false | The destination is the project's `Extractions/` folder (`ViewerViewController+Extraction.swift:575`), falling back to `Extractions` beside the working directory (`:579`) or `~/Documents/Lungfish Extractions` (`:582`) | "into the project's `Extractions/` folder" |
| 17 | "its own FASTA, its own FAI index, and its own provenance sidecar recording the source bundle and the extracted coordinates" | unverifiable | Not confirmed from `SequenceExtractionPipeline.swift` in this pass | Confirm the sidecar field set from a produced bundle |
| 18 | "The clipboard now holds a FASTA record whose header names the source bundle and the extracted coordinates" | changed | `SequenceExtractor.swift:355-388` builds `<name> [chrom:start-end] [<n> bp]`, where the name is the region description rather than the bundle name | "a FASTA record whose header names the region and its length, in the bracketed form `MN908947.3:21562-25384 [MN908947.3:21562-25384] [3822 bp]`" |
| 19 | "Those open the standard FASTQ/FASTA Operations dialog and write CLI-backed derived outputs with provenance." | true | `AppDelegate+SequenceMenu.swift:17-37` routes both to `runSelectedSequenceFASTAOperation`; `FASTQOperationDialogState.swift:1251` is the dialog title | |
| 20 | Step 3 of reverse-complement, "Confirm the preselected tool and output settings in the FASTQ/FASTA Operations dialog, then click `Run`." | true | Same wiring as row 19 | |
| 21 | "Lungfish writes the selected bases out as a temporary FASTA input and runs the matching `lungfish-cli fastq` operation." | unverifiable | The routing to `runSelectedSequenceFASTAOperation` is confirmed, but the temporary-FASTA staging was not read | Confirm in `SequenceViewerView+Interaction.swift:1406` and its callee |
| 22 | "**Reading Frames** ..., **Translation** (the **Codon table** and the **Minimum ORF length** in nucleotides), **Output** (the **Track name** and **Track ID** ...), and **Options** (toggles for **Include partial ORFs** and **Allow alternative starts**)" | true | `SequenceORFOperationDialog.swift:173`, `:182`, `:195`, `:202` | |
| 23 | "The dialog (titled **Find ORFs**)" | changed | The panel's window title is "Find ORFs" (`SequenceORFOperationDialog.swift:247`) while the header inside reads "FIND ORFS" (`:146`) | Note both, or quote the header |
| 24 | "Lungfish calls `lungfish sequence annotate-orfs`" | true | `sequence.txt:19` | |
| 25 | "records provenance for the generated BED, database, and updated manifest" | unverifiable | Not confirmed from the ORF pipeline in this pass | Confirm from the produced bundle's provenance |
| 26 | "which you do from the command line with `lungfish sequence delete-annotation-track --track-id <id>`" | true | `sequence.txt:88` | |
| 27 | "`lungfish bundle extract-annotations --bundle ... --track ... --output-bundle ...`" | true | `bundle.txt:113-121` | |
| 28 | "`--track` accepts either the track ID or the track name." | true | `bundle.txt:120`, "Annotation track id or name to extract from" | |
| 29 | "`--feature-type` selects which features to pull and defaults to `gene`" | true | `bundle.txt:123-125`, "(default: gene)" | |
| 30 | "`--name-prefix` keeps only features whose name or gene name starts with a given string, and `--replace` overwrites an existing output bundle" | true | `bundle.txt:126-129` | |
| 31 | "Minus-strand features are reverse-complemented so every extracted sequence reads in its coding orientation." | true | `BundleCommand.swift:781-783` | |
| 32 | "Each FASTA header carries provenance in the form `source=chrom:start-end strand=`, where the coordinates are 1-based against the source sequence" | true | `BundleCommand.swift:786`, `">\(name) source=\(record.chromosome):\(record.start + 1)-\(record.end) strand=\(record.strand)"` | |
| 33 | Worked example step 1, "type `21563-25384`, then press `Return`. The viewport scrolls to the spike CDS and the range highlights." | changed | The bare range is accepted (`EnhancedCoordinateRulerView.swift:1066`), but no highlight behavior is asserted in source | Drop the highlight clause |
| 34 | Worked example step 2, "Press `Cmd-Shift-E` ... name the new bundle `MN908947.3-spike`, and click `Extract`." | false | Same as row 14, the button reads `Create Bundle` | Replace `Extract` with `Create Bundle` |
| 35 | Worked example step 3, "Lungfish writes `Reference Sequences/MN908947.3-spike.lungfishref/`" | false | Same as row 16, the folder is `Extractions/` | `Extractions/MN908947.3-spike.lungfishref/` |
| 36 | "The new bundle is 3,822 bases long." | changed | Arithmetically 25384 minus 21563 plus 1 equals 3822, but `currentVisibleViewportRegion()` returns the visible frame rather than the typed range, so the extracted span depends on how the viewport settled | Say "about 3,822 bases", or verify against a produced bundle |
| 37 | "Map reads to it with `Tools > FASTQ/FASTA Operations > Mapping…` (the \"Map Reads\" operation)" | false | There is no `FASTQ/FASTA Operations` submenu and no `Mapping…` item. The Tools menu has a `Mapping` category holding `minimap2…`, `BWA-MEM2…`, `Bowtie2…`, `BBMap…`, and `Viral Recon…` (`ToolsMenuModel.swift:70`, `FASTQOperationDialogState.swift:1984-1988`, `:2072-2073`) | "Map reads to it with `Tools > Mapping > minimap2…`" |
| 38 | Primer example step 2, "In the position field, type `38-59` and press `Return`." | true | `EnhancedCoordinateRulerView.swift:1066` accepts a bare range | |
| 39 | Primer example step 3, "Press `Cmd-Shift-C`. The 22 bases plus a FASTA header are now on the clipboard." | changed | The copy takes the visible region, so the base count depends on the viewport rather than on the typed range (`ViewerViewController+Extraction.swift:213-215`) | "the visible bases plus a FASTA header are now on the clipboard" |
| 40 | Primer example step 4, "The header names the source bundle and the extracted coordinates" | false | Same as row 18, the header is `<name> [chrom:start-end] [<n> bp]` | |
| 41 | ORF example step 2, "Set the minimum length to `300` nucleotides and leave all six frames selected." | true | `SequenceORFOperationDialog.swift:191` field, `:34` all six frames on by default | |
| 42 | ORF example step 3, "Lungfish adds an `ORFs` track with one feature per qualifying ORF." | false | The Track name field is prefilled with the sequence name plus " ORFs" (`AppDelegate+SequenceMenu.swift:681`), so the default track is `<sequence> ORFs` | "adds a track named after the sequence, for example `NODE_1 ORFs`" |
| 43 | "`lungfish extract sequence`, which reads a FASTA and takes a region in `name:start-end` form (1-based, inclusive)" | true | `extract.txt:24-45` | |
| 44 | "`--flank` adds the same number of bases on both sides; `--flank-5` and `--flank-3` set the upstream and downstream padding separately, and `--reverse-complement` flips the result." | true | `extract.txt:49-54` | |
| 45 | "The output is a plain FASTA, or a `.lungfishref` bundle when you give the output path a `.lungfishref` extension." | unverifiable | `extract.txt` describes `-o` only as "Output file path (default: stdout)". The bundle behavior is not in help | Confirm against `ExtractCommand.swift` |
| 46 | "`--longest-orf` to keep only the longest ORF per sequence per frame" | true | `translate.txt`, "Output only the longest open reading frame per sequence per frame" | |
| 47 | "`lungfish sequence delete-annotations` to drop individual rows from a track" | true | `sequence.txt:61` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Extract Sequence sheet's Save to File…, Copy to Clipboard, and Share… destinations | `ClassifierExtractionDialog.swift:17-31` |
| The sheet's "N selected" count in its header, which reports what the extraction covers | `FASTASequenceExtractionDialog.swift:35` |
| The annotation right-click route into the same sheet, `Extract Sequence…` on a feature block | `SequenceViewerView+Interaction.swift:1013` |
| `Extract Reads in Selected Region…`, offered on the selection menu when an alignment selection exists | `SequenceViewerView+Interaction.swift:756-763` |
| `annotate-orfs` options `--sequence`, `--start`, `--end`, `--include-partial`, `--allow-alternative-starts`, and `--track-id` on the command line | `sequence.txt:26-46` |
| `lungfish extract sequence --line-width` (default 70) | `extract.txt:55-56` |
| `lungfish extract contigs`, the sibling that pulls contigs out of an assembly | `extract.txt:169` |
| The `Extractions/` folder as the destination convention for every GUI extraction | `ViewerViewController+Extraction.swift:575-582` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: extract-region-dialog`, "The Extract Sequence dialog with its destination and name fields." | Yes | The sheet is unchanged. The caption should say the destination group offers four choices and the button reads Create Bundle |
| `<!-- planned: extract-region-dialog -->` after step 5 | Changed | It sits after the procedure ends. Move it beside step 3, where the sheet first appears |

---

## 04-msa-and-trees.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Where one sequence carries an insertion the others lack, MAFFT pads the others with `-` gap characters." | true | `MultipleSequenceAlignmentViewController.swift:105-107`, gaps are `-` or `.` | |
| 2 | "Lungfish runs MAFFT under `Tools > FASTQ/FASTA Operations > Multiple Sequence Alignment…`" | false | No such submenu. MAFFT is `Tools > Multiple Sequence Alignment > MAFFT…` (`ToolsMenuModel.swift:69`, `FASTQOperationDialogState.swift:1983`, `:2065-2066`, `MainMenu.swift:804-816`). `features.yaml:960` agrees, "Tools > Multiple Sequence Alignment" | "Lungfish runs MAFFT under `Tools > Multiple Sequence Alignment > MAFFT…`" |
| 3 | "writes the result as a `.lungfishmsa` bundle that opens in the MSA viewport" | true | `align.txt` "align mafft" overview, "create a .lungfishmsa bundle" | |
| 4 | "From that open bundle, right-click and choose **Build Tree with IQ-TREE…**" | changed | `MultipleSequenceAlignmentViewController.swift:1655` has that exact title, but the item is enabled only when `bundleURL != nil && selectedRowIndices.count >= 2` (`:1661`). With fewer than two rows selected it stays greyed out | Add "select at least two sequences first, or the item stays disabled" |
| 5 | "writes it as a `.lungfishtree` bundle that opens in the tree viewport" | true | `tree.txt` "tree infer iqtree" `--output` "Output .lungfishtree bundle path" | |
| 6 | "MAFFT is the only aligner wired into Lungfish, in both the GUI and the CLI; there is no aligner picker to choose among." | true | `align.txt` root lists `mafft (default)` as the sole subcommand; `FASTQOperationToolPanes.swift:606-644` has only the `.mafft` case | |
| 7 | Tool table, "MUSCLE ... In Lungfish: No" and "Clustal Omega ... In Lungfish: No" | true | Same evidence as row 6 | |
| 8 | Step 1, "use `File > Import Center…` (Cmd-Shift-I)" | true | `MainMenu.swift:207-213` | |
| 9 | Step 2, "Choose `Tools > FASTQ/FASTA Operations > Multiple Sequence Alignment…`. The MSA wizard opens on the MAFFT pane." | false | Same as row 2 | "Choose `Tools > Multiple Sequence Alignment > MAFFT…`. The operations dialog opens on the MAFFT pane." |
| 10 | Step 3, "add all ten FASTAs. Lungfish concatenates them into a single multi-FASTA before handing them to MAFFT." | changed | `align.txt` takes `<input-files> ...`, several files in one call, and `FASTQOperationToolPanes.swift:613-617` adds a `MultiBundleRunModePicker` that chooses between a combined run and per-bundle runs. Concatenation is one of two modes, not automatic | "add all ten FASTAs, then set the run mode to combine them into one alignment" |
| 11 | Step 4, "Leave **Strategy** on **Auto**" | changed | The Strategy picker's first entry displays **Automatic** (`FASTQOperationToolPanes.swift:1004`); `auto` is the CLI value (`align.txt`) | "Leave **Strategy** on **Automatic**" |
| 12 | Step 4, "The pane also has **Sequence Type** and **Output Order** pickers" | true | `FASTQOperationToolPanes.swift:626`, `:634` | |
| 13 | Step 5, "Name the output bundle ... and click `Run`." | true | `align.txt` `--name` "Display name for the alignment bundle" | |
| 14 | "**Automatic** (`--strategy auto`), **L-INS-i** (`linsi`), **G-INS-i** (`ginsi`), **E-INS-i** (`einsi`), **FFT-NS-2** (`fftns2`), and **PartTree** (`parttree`)" | true | `FASTQOperationToolPanes.swift:1001-1012`; `align.txt` `--strategy` "auto, linsi, ginsi, einsi, fftns2, parttree (default: auto)" | |
| 15 | "**Sequence Type** takes **Auto**, **Nucleotide**, or **Protein** (`--sequence-type`)" | true | `FASTQOperationToolPanes.swift:1024-1029`; `align.txt` `--sequence-type` "auto, nucleotide, protein (default: auto)" | |
| 16 | "**Direction Adjustment** (Off, Adjust Direction, or Adjust Direction Accurately; `--adjust-direction off|fast|accurate`)" | true | `FASTQOperationToolPanes.swift:1051-1058`; `align.txt` `--adjust-direction` "off, fast, accurate (default: off)" | |
| 17 | "**Symbol Policy** (Strict Alphabet or Allow Any Symbol; `--symbols strict|any`)" | true | `FASTQOperationToolPanes.swift:1061-1067`; `align.txt` `--symbols` "strict or any (default: strict)" | |
| 18 | "**Threads** plus a **Deterministic threading** toggle ...; clearing the toggle is the `--allow-nondeterministic-threads` flag" | true | `FASTQOperationToolPanes.swift:924-925`; `align.txt` `--allow-nondeterministic-threads` | |
| 19 | "**Treat FASTQ records as assembled or consensus sequences** (`--allow-fastq-assembly-inputs`)" | true | `FASTQOperationToolPanes.swift:928`; `align.txt` `--allow-fastq-assembly-inputs` | |
| 20 | "A **MAFFT Parameters** field (`--extra-mafft-options`) passes text straight to MAFFT after the chosen strategy." | true | `FASTQOperationToolPanes.swift:930`; `align.txt` `--extra-mafft-options` | |
| 21 | "MAFFT typically finishes in under a minute on this input size." | unverifiable | A runtime claim with no code backing | Soften or drop |
| 22 | "On the left, the row picker lists every input sequence in alignment order, each with a checkbox to hide that row from the column ruler's conservation calculation." | false | The left region is a name gutter (`MSAAlignmentRowGutterView`, `MultipleSequenceAlignmentViewController.swift:389`) with a resize handle (`:415`). It has no checkboxes, and no hide-from-conservation control exists anywhere in the controller | "On the left, a resizable name gutter lists every sequence in alignment order. Click a name to select that row, Command-click to add rows, Shift-click for a range." |
| 23 | "bases in the standard four-color nucleotide palette and gaps as light dashes on the Cream background" | changed | The colour control is a two-segment `Nucleotide` and `Conservation` picker (`MultipleSequenceAlignmentViewController.swift:82-92`, `:395-399`), so the four-colour palette is one of two schemes | "bases coloured by the `Nucleotide` scheme, which you can swap for `Conservation`" |
| 24 | "The column ruler across the top carries two tracks: a 1-based column index and a conservation track whose height at each column is the fraction of non-gap rows that share the modal base." | changed | The conservation arithmetic is exactly right (`:2220`, `conservation: Double(maxCount) / Double(nonGapTotal)`), but it is drawn by a separate `MSAAlignmentOverviewSignalView` labelled "Alignment conservation overview" (`:393`, `:775`), not as a second track inside the column header (`MSAAlignmentColumnHeaderView`, `:392`) | "A column header runs across the top carrying the numbering, and below it a conservation overview strip whose height at each column is the fraction of non-gap rows sharing the modal base." |
| 25 | The column ruler shows "a 1-based column index" only | changed | The numbering mode picker offers `Alignment + Source`, `Alignment Columns`, `Source Coordinates`, and `Hidden`, defaulting to `Alignment + Source` (`MSAAlignmentNumberingMode.swift:7-25`; `MultipleSequenceAlignmentViewController.swift:472` sets `.both`) | Say the header shows alignment columns and per-row source coordinates by default, and name the four numbering modes |
| 26 | "the viewport's `Annotations` toggle projects gene boundaries onto the column ruler" | false | No `Annotations` toggle exists. The generic annotation drawer is present but pinned to zero height and hidden (`MultipleSequenceAlignmentViewController.swift:604`, `:939`), which the 2026.9.10 notes describe as removed. Source annotations remain visible on alignment tracks (`:1421-1433`) | "Annotations carried by the source sequences draw on the alignment tracks. There is no toggle to switch them off." |
| 27 | "you should see a strongly conserved 5' block ... Omicron rows carry a visible insertion near position 214 ... eight of ten rows are gap characters" | unverifiable | Data claims about SARS-CoV-2 lineages, not about LGE | Leave for the data reviewer |
| 28 | "`lungfish msa consensus` collapses the alignment into a single consensus FASTA, and `lungfish msa distance` writes a pairwise distance matrix as a TSV" | true | `msa.txt:244`, `:413` | |
| 29 | "`lungfish msa distance S-gene-10-isolates.lungfishmsa --output S-gene-10-isolates-distances.tsv`" | true | `msa.txt:413-420` usage | |
| 30 | "`lungfish msa export` writes aligned FASTA, PHYLIP, NEXUS, Clustal, Stockholm, and the a2m/a3m HMMER formats through `--output-format`" | changed | `msa.txt:221-223` lists `fasta, aligned-fasta, phylip, nexus, clustal, stockholm, a2m, or a3m (default: fasta)`. Plain `fasta` is missing from the chapter and is the default | Add plain `fasta` and note it is the default, so an aligned export needs `--output-format aligned-fasta` |
| 31 | "`msa consensus` ... `--output-kind fasta\|reference`, `--threshold`, `--gap-policy omit\|include`, `--rows`" | true | `msa.txt:252-263`; `--threshold` "(default: 0.6)", `--gap-policy` "(default: omit)" | |
| 32 | "`msa distance` ... `--model identity\|p-distance`, `--rows`, `--columns`" | true | `msa.txt:419-425`, `--model` "(default: identity)" | |
| 33 | "`msa extract` ... `--output-kind fasta\|msa`, `--rows`, `--columns`, `--name`" | true | `msa.txt:286-292` | |
| 34 | "`msa mask columns` ... `--ranges`, `--gap-threshold`, `--conservation-below`, `--codon-position 1\|2\|3`" | changed | All four exist (`msa.txt:333-346`), but `--parsimony-uninformative`, `--annotation`, and `--reason` are also offered and unlisted | Add the three missing options |
| 35 | "`msa trim columns` ... `--gap-only`, `--gap-threshold`" | true | `msa.txt:386-390` | |
| 36 | "`msa annotate` ... `add` / `edit` / `delete` / `project` verbs" | true | `msa.txt:93`, `:124`, `:155`, `:181` | |
| 37 | "The `mask` and `trim` actions each take a `columns` verb, hence `lungfish msa mask columns` and `lungfish msa trim columns`." | true | `msa.txt:324`, `:382` | |
| 38 | "Every action takes `--output` for the destination and `--force` to overwrite one that already exists." | true | `msa.txt` shows `--output` and `--force` on export, consensus, extract, mask columns, trim columns, and distance | |
| 39 | "The **Phylogenetic Tree Operations** dialog opens (subtitle \"Configure IQ-TREE for the selected multiple sequence alignment\")" | true | `IQTreeInferenceDialog.swift:102-105`, both strings verbatim | |
| 40 | Step 1, "Set **Output Name** for the tree bundle" | true | `IQTreeInferenceDialog.swift:258` | |
| 41 | Step 2, "Leave **Model** on **MFP**." | true | `IQTreeInferenceDialog.swift:260` field, `:83` default `"MFP"`; `tree.txt` `--model` "(default: MFP)" | |
| 42 | Step 3, "Tick **Ultrafast Bootstrap** ... then set the replicate count to `1000` ... bootstrap is off by default" | true | `IQTreeInferenceDialog.swift:321` toggle, `:85` `bootstrapEnabled = false`, `:86` `bootstrapReplicates = 1000`; `tree.txt` `--bootstrap` carries no default | |
| 43 | Step 3, "Tick **SH-aLRT** too if you want a second, faster support measure alongside." | true | `IQTreeInferenceDialog.swift:327`; `tree.txt` `--alrt` | |
| 44 | Step 4, "The remaining fields (Sequence Type, Seed, Threads, Safe numerical mode, Keep identical sequences)" | true | `IQTreeInferenceDialog.swift:263`, `:275`, `:276`, `:280`, `:282` | |
| 45 | Step 4, "There is no outgroup field here." | true | `IQTreeInferenceDialog.swift:256-303` enumerates every field, and none is an outgroup | |
| 46 | "select the rows or columns you want in the MSA viewport before choosing **Build Tree with IQ-TREE…**; the selection carries into the inference. The CLI exposes the same scoping through `--rows` and `--columns`." | true | `tree.txt` `--rows` and `--columns` on `tree infer iqtree`; `MultipleSequenceAlignmentViewController.swift:1661` gates the item on the row selection | |
| 47 | "it requires both `--project` (for staging) and `--output`" | true | `tree.txt:41` usage, both marked required | |
| 48 | "lungfish tree infer iqtree ... --project . --output ... --model MFP --bootstrap 1000" | true | `tree.txt:41-58` | |
| 49 | "The builder command for the alignment itself is `lungfish align mafft <inputs> --project <dir>`" | true | `align.txt` "align mafft" usage | |
| 50 | "`--sequence-type` forces the data type ..., taking `auto`, `DNA`, `AA`, `CODON`, `BIN`, `MORPH`, or `NT2AA`" | true | `tree.txt:54-56` | |
| 51 | "`--seed <n>` fixes the random seed for a reproducible run (default `1`) and `--force` overwrites an existing output bundle" | true | `tree.txt:58`, "(default: 1)"; `:68` | |
| 52 | "`--extra-iqtree-options` and `--extra-args` pass text straight through to IQ-TREE verbatim" | true | `tree.txt:61-66` | |
| 53 | "`--iqtree-path` points at a specific `iqtree3` executable; without it Lungfish uses the binary from the Phylogenetics plugin pack" | true | `tree.txt:66-67`, "Override path to iqtree3 executable"; `third-party-tools-lock.json` packTools entry `{packID: phylogenetics, id: iqtree, executables: [iqtree3], version: 3.1.3}` | |
| 54 | "IQ-TREE on ten sequences finishes in seconds to a minute." | unverifiable | A runtime claim | Soften or drop |
| 55 | "The tree viewport renders a rectangular phylogram by default." | true | `PhylogeneticTreeViewController.swift:79`, `labels: ["Phylogram", "Cladogram"]`, phylogram first | |
| 56 | "`Layout` switches between a branch-length phylogram and an equal-depth cladogram." | changed | The segmented control's segments read `Phylogram` and `Cladogram` (`:79`). No control is labelled `Layout` | Name the segments instead of a `Layout` label |
| 57 | "`Color` can highlight support values or branch lengths." | changed | The segmented control offers `None`, `Support`, and `Branch` (`:85`), and `None` is the third value the chapter omits | "A second control switches branch colouring between `None`, `Support`, and `Branch`." |
| 58 | "`Tip labels` can switch from the original tree labels to a column in `metadata.tsv` when the bundle includes one." | true | `:623-626`, the popup's first item is "Original", followed by the metadata column titles | |
| 59 | "navigation buttons: `Zoom in`, `Zoom out`, `Fit tree`, and `Reset`" | changed | Four buttons exist (`:74-77`, `fitButton`, `resetButton`, `zoomOutButton`, `zoomInButton`) but each is created with an empty title, so they are icons | Describe them as icon buttons for zoom in, zoom out, fit, and reset |
| 60 | "A `Find tip or node` search field filters the tree to labels that match." | true | `:441`, `searchField.placeholderString = "Find tip or node"`; `:554` also matches metadata values | |
| 61 | "Right-click a node or tip to copy labels, copy Newick for a subtree, center the view, reveal provenance, re-root, collapse, or extract a subtree as a new bundle." | true | `:768-853` gives Show in Inspector, Copy Node Label, Copy Subtree as Newick, Re-root Here, Collapse Clade or Expand Clade, Extract Subtree as New Bundle…, Export Subtree…, Copy Selected Tip Names, Center Node, and Reveal Provenance | |
| 62 | "A persistent `Nodes` table drawer lists every tip and internal node, with `Node`, `Type`, `Tips`, `Branch`, and `Support` columns." | true | `:223-227` adds exactly those five columns; `:272` labels the drawer "Nodes" | |
| 63 | "Selecting any node also fills the inspector with its detail rows, among them `Descendant Tips`, `Cumulative Divergence` ..., and, where support is present, `Support` and `Support Type`." | true | `:703`, `:709`, `:713` | |
| 64 | "`Extract Subtree as New Bundle...` produces a fresh `.lungfishtree` bundle ..., while `Export Subtree...` writes a plain `.nwk` Newick file" | true | `:816`, `:825`; `tree.txt:99-102` confirms the Newick export path | |
| 65 | "right-click the tip or internal node that should become the root and choose `Re-root Here`." | true | `PhylogeneticTreeViewController.swift:797` | |
| 66 | "The new bundle records the source bundle, selected node, resolved options, checksums, file sizes, command line, runtime identity, exit status, wall time, and any useful stderr" | unverifiable | The provenance writer for reroot was not read in this pass | Confirm from a produced bundle |
| 67 | "`lungfish tree reroot --bundle ... --on ... --output ...`" | true | `tree.txt:133` usage, all three required | |
| 68 | "If more than one node matches a label, Lungfish reports the ambiguity instead of guessing." | changed | `tree.txt:133-153` confirms `--on`, but the ambiguity behavior is not stated in help | Confirm against `TreeCommand.swift` |
| 69 | "an id column named `id`, `sample`, `sample_id`, `name`, or `tip`" | true | `PhylogeneticTreeViewController.swift:610`, exactly those five, matched case-insensitively, falling back to column 0 | |
| 70 | "`lungfish tree relabel --bundle ... --column ... --output ...`" | true | `tree.txt:183` usage | |
| 71 | "right-click an internal node and choose `Collapse Clade` ... right-click it again and choose `Expand Clade`" | true | `PhylogeneticTreeViewController.swift:805-808` toggles the title on the collapsed state | |
| 72 | "Shift-click more tips to build a highlighted tip set, then right-click and choose `Copy Selected Tip Names`" | true | `:834` | |
| 73 | "`lungfish tree extract-subtree --bundle ... --node ... --output ...`" | true | `tree.txt:158` usage | |
| 74 | "`lungfish tree export subtree` still writes a plain Newick export plus sidecar provenance." | true | `tree.txt:99-102` overview, "Export a selected .lungfishtree subtree as Newick with provenance" | |
| 75 | "`lungfish import msa` reads aligned FASTA, Clustal, PHYLIP, NEXUS, Stockholm, and a2m/a3m" | true | `import.txt:137-139`, `--source-format` "aligned-fasta, clustal, phylip, nexus, stockholm, a2m-a3m" | |
| 76 | "`lungfish import tree` reads Newick or Nexus" | true | `import.txt:169-170`, `--source-format` "newick or nexus" | |
| 77 | "Both take a `--project` directory" | true | `import.txt:127`, `:161`, both required in the usage lines | |
| 78 | "There is no `Tools > Orient` for reference FASTA; the FASTQ \"Orient Reads\" operation handles reads" | true | `FASTQOperationDialogState.swift:1971` title "Orient Reads"; `:2070` puts it in `readProcessing`, so the path is `Tools > Read Processing > Orient Reads…` | |
| 79 | "open the wizard's **Advanced Options** and set **Direction Adjustment** to **Adjust Direction** ... The CLI spelling is `lungfish align mafft --adjust-direction fast`." | true | `FASTQOperationToolPanes.swift:909-911`, the disclosure is titled "Advanced Options"; `align.txt` `--adjust-direction` | |
| 80 | "switch **Strategy** from Auto to **L-INS-i** ... (the CLI spelling is `--strategy linsi`)" | changed | Correct except that the first entry displays **Automatic** (`FASTQOperationToolPanes.swift:1004`) | "switch **Strategy** from Automatic to **L-INS-i**" |
| 81 | "check the operation's log link in the Operations Panel; the full MAFFT or IQ-TREE stderr sits there, along with the resolved command line" | true | `IQTreeInferenceDialog.swift:112` states the output records resolved options, inputs, outputs, and command provenance | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The **Sequences to align** scope picker, the September addition offering "All sequences (n)" or "Selected sequences (n)" and falling back to a one-line summary when there is no choice | `MSASequenceScopePicker.swift:50-71`; `FASTQOperationToolPanes.swift:607-611`; release note 2026.9.8 |
| The CLI counterpart `align mafft --sequence <name>`, repeatable, accepting a full header, an accession, or the alignment label | `align.txt`, `--sequence` |
| The warning raised when realigning sequences that already carry gaps | release note 2026.9.8, "Realigning sequences that already contain gaps now warns" |
| **Export Alignment…** on the alignment right-click menu, with destinations Save as Bundle, Save to File…, and Copy to Clipboard, and a gap choice of Aligned FASTA (keep gaps) or Unaligned FASTA (remove gaps) | `MultipleSequenceAlignmentViewController.swift:1637-1644`; `MSAAlignmentExportSheet.swift:10-66` |
| The export sheet's scope choice between the entire alignment and the selected rows, and its 5 MB clipboard cap | `MSAAlignmentExportSheet.swift:69-101` |
| **Use as Reference** and **Use Consensus** on the row menu, which switch the comparison target without changing the alignment | `MultipleSequenceAlignmentViewController.swift:1645-1650`, `:1683`; release notes 2026.9.10 and 2026.9.12 |
| The pinned comparison row that stays above the sequences while scrolling | `MultipleSequenceAlignmentViewController.swift:390-391`, `comparisonLabelView` and `comparisonHeaderView`; release note 2026.9.12 |
| The residue identity display modes `Letters`, `Dots to Consensus`, and `Dots to Reference` | `MSAAlignmentNumberingMode.swift:95-113` |
| The **All Sites** and **Variable Sites** segmented control, plus the **Previous Variable** and **Next Variable** buttons | `MultipleSequenceAlignmentViewController.swift:379-386`, `:1010-1012`, `:1053-1059` |
| The `Find sequence or column` search field, which also jumps to a typed column number | `MultipleSequenceAlignmentViewController.swift:625`, `:1029` |
| The `Nucleotide` and `Conservation` colour scheme control | `MultipleSequenceAlignmentViewController.swift:82-92`, `:395-399` |
| The numbering modes `Alignment + Source`, `Alignment Columns`, `Source Coordinates`, and `Hidden` | `MSAAlignmentNumberingMode.swift:7-25` |
| The consensus display options, the low-support and high-gap thresholds (both 50 percent) and the mask symbol mode Auto, N, or X | `MSAAlignmentNumberingMode.swift:53-93` |
| The resizable name gutter, persisted between 160 and 640 points | `MultipleSequenceAlignmentViewController.swift:407-419` |
| Row selection by click, Command-click, and Shift-click, and **Extract Selection to New Bundle…** and **Export Selected Residues…** on the same menu | `MultipleSequenceAlignmentViewController.swift:1617-1625`; release notes 2026.9.8 and 2026.9.10 |
| **Add Annotation from Selection…** and **Apply Annotation to Selected Rows** on the alignment menu | `MultipleSequenceAlignmentViewController.swift:1664-1676` |
| **Copy Subalignment**, the renamed Copy FASTA item | `MultipleSequenceAlignmentViewController.swift:1636` |
| The tool versions the alignment and tree actually run, MAFFT 7.526 and IQ-TREE 3.1.3, and their packs `multiple-sequence-alignment` and `phylogenetics` | `third-party-tools-lock.json` packTools entries |
| `msa actions` and `msa describe`, the two introspection subcommands | `msa.txt:27`, `:52` |
| `align mafft --output`, which names an explicit bundle path instead of letting the project pick | `align.txt`, `--output` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `shots: msa-viewport`, "An MSA viewport showing aligned sequences with a column ruler." | No | The viewport changed substantially across 2026.9.8 to 2026.9.13. Reshoot to show the name gutter, the pinned comparison row, the column header, and the conservation overview strip, and drop "column ruler" from the caption |
| `<!-- SHOT: msa-viewport -->` after the MAFFT procedure | Yes | Correctly placed, provided it follows the corrected menu path in step 2 |
| `shots: tree-viewport`, "A phylogenetic tree viewport showing a rectangular tree with annotated tips." | Yes | The tree viewport is unchanged. Consider showing the Nodes drawer, which the chapter describes but the caption ignores |
| `<!-- SHOT: tree-viewport -->` before the tree interpretation section | Yes | Correctly placed |
| `illustrations: msa-column-homology` | Yes | Gap insertion for homology is unchanged |
| `illustrations: tree-anatomy` | Yes | Tips, internal nodes, branch lengths, and support values all still appear in the viewport |
| A shot of the **Sequences to align** picker | Missing | The September scope picker is the most consequential undocumented control in this chapter and has no planned shot |
| A shot of the **Export Alignment…** sheet | Missing | Three destinations and a gap choice, none documented and none photographed |
