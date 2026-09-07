# Fidelity review: 02-sequences/01-importing-and-viewing.md

Reviewed against the working-tree draft on 2026-09-06. Ground truth used, in
campaign order: the Swift source under `Sources/`, a live run of
`.build/debug/lungfish-cli` against the `hbb-gene` fixture, the CLI help
dumps under `reviews/fidelity-2026-09/cli-help/`, `parameters.yaml`, the
reality map `ground-truth/02-sequences.md`, `DRIFT.md`, and
`CONSISTENCY.md`. Chapter 1 was read for cross-chapter agreement.

The live commands run for this review were

```
lungfish-cli import fasta docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb \
  --name HBB -o <scratch>/scratch.lungfish
lungfish-cli sequence annotate-orfs "<scratch>/scratch.lungfish/Reference Sequences/HBB.lungfishref" \
  --sequence NG_000007 --start 70544 --end 72152 \
  --frames +1,+2,+3 --table 1 --min-length 300 --track-name "HBB ORFs"
lungfish-cli translate docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb --frame 1 --table 1
lungfish-cli extract sequence docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb \
  NG_000007:70545-72152 --line-width 70
```

The first two succeeded. The last two both failed, which is finding 20 and
finding 24 below.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording when false |
|---|---|---|---|---|
| 1 | "a folder carrying the `.lungfishref` extension that the Finder shows as one icon" | true | `cli-help/import.txt`, `import fasta` overview, "Import a standalone reference sequence file as a .lungfishref bundle". The live import wrote `Reference Sequences/HBB.lungfishref/` | |
| 2 | "Importing turns a loose sequence file on your disk into a bundle in the project's `Reference Sequences/` folder." | true | `ImportCenterViewModel.swift:179` tab title "Reference Sequences"; `AppDelegate+ImportCenter.swift:281` calls `ReferenceSequenceFolder.ensureFolder`; the live import created that folder | |
| 3 | "The bundle holds a copy of the sequence, the indexes that let LGE jump to a position inside it, and, where the source format supports it, the features the file carried." | true | The live bundle holds `genome/sequence.fa.gz`, `sequence.fa.gz.fai`, `sequence.fa.gz.gzi`, and `annotations/imported_annotations.gff3` | |
| 4 | "Features arrive in the bundle as an annotation track, which is one named set of features stored together and drawn as one layer. A bundle can hold several tracks at once, and each one keeps its own name." | true | The live bundle's `manifest.json` after the ORF run holds two entries, `imported_annotations` / "Imported Annotations" and `orfs` / "HBB ORFs" | |
| 5 | "A FASTA file holds sequence and nothing else, so the bundle it makes has no features in it." | true | `ReferenceSourcePreparer.swift:130-162` reads annotations only on the GenBank and EMBL path; the FASTA path produces no track | |
| 6 | "A GenBank flatfile holds the sequence together with a table of features, so the bundle it makes arrives with a track already attached." | true | The live GenBank import produced `imported_annotations` with `"feature_count" : 102` in `manifest.json` | |
| 7 | "A GFF3, GTF, or BED file ... holds features and no sequence at all, so it cannot make a bundle on its own." | true | `ImportCenterViewModel.swift:549-551`, Annotation Track card, "Attach GTF, GFF, GFF3, or BED annotations to an existing reference sequence bundle." | |
| 8 | "The HBB gene record is `NG_000007.3`, a RefSeqGene record covering the human beta-globin cluster on chromosome 11." | true | The fixture's LOCUS and VERSION lines; `fixtures/hbb-gene/README.md` "RefSeqGene on chromosome 11" | |
| 9 | "It is 81,706 bases long" | true | Counting the fixture's ORIGIN block returns 81706; the live bundle `manifest.json` reads `"length" : 81706` | |
| 10 | "and carries 102 annotation features" | true | The live bundle `manifest.json` reads `"feature_count" : 102` for `imported_annotations` | |
| 11 | "Eight of those features are genes, five are mRNAs, five are coding sequences, and thirteen are exons." | true | `grep -c "^     gene  "` and its siblings on the fixture return 8, 5, 5, 13, matching `fixtures/hbb-gene/README.md` | |
| 12 | "The rest are other GenBank feature types such as `misc_feature` and `regulatory`." | true | `fixtures/hbb-gene/README.md` counts `misc_feature` 59 and `regulatory` 7 among the remaining 71 | |
| 13 | "Choose **File > Import Center...** (Cmd-Shift-I)." | true | `MainMenu.swift:207-213`, title `Import Center\u{2026}`, keyEquivalent "i", modifier `[.command, .shift]` | |
| 14 | "The six tabs are Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, and Application Exports." | true | `ImportCenterViewModel.swift:172-181`, the six `Tab.title` cases in that order | |
| 15 | "a grid of cards below them, one card per kind of file" | true | `ImportCenterView.swift:196-252`, `ImportCardView` in a grid, each card a titled unit | |
| 16 | "Every card is its own drop target, so the card you drop on decides what kind of import runs. There is no format picker and no preview step." | true | `ImportCenterView.swift:251-255`, `.onDrop(of: [UTType.fileURL], isTargeted: $isDropTargeted)` per card. No picker or preview view exists in the file | |
| 17 | "LGE compresses and indexes the sequence and builds the bundle without asking you to confirm anything." | true | The live import ran to completion with no prompt and wrote `sequence.fa.gz` plus `.fai` and `.gzi`. `parameters.yaml:1661-1663` states the same, live-checked in Preview 2026.9.13 | |
| 18 | "Click that card's **Import...** button instead" | true | `ImportCenterView.swift:230`, `Button("Import…")` | |
| 19 | "the panel accepts more than one file at a time" | true | `ImportCenterViewModel.swift:530` (fasta card) `allowsMultipleSelection: true` | |
| 20 | "It carries the name of the file you dropped, so it appears as `NG_000007.3`." | true | `cli-help/import.txt`, `--name` "(default: filename)". The live run passed `--name HBB` explicitly and got `HBB.lungfishref`, so the default path is unexercised but documented | |
| 21 | "the bundle arrives with an annotation track named Imported Annotations" | true | The live `manifest.json` reads `"name" : "Imported Annotations"` with `"id" : "imported_annotations"` | |
| 22 | "Dragging the file onto the project sidebar does the same import without opening the Import Center. The whole sidebar accepts a dropped file, not only the `Reference Sequences/` row." | true | `SidebarViewController+OutlineDataSource.swift:171-233`, `acceptDrop` reads file URLs from the pasteboard and posts `.sidebarFileDropped` regardless of `destinationItem` | |
| 23 | "Drop the `.gff3`, `.gtf`, or `.bed` file on the Annotation Track card" | true | `ImportCenterViewModel.swift:547-568`, fileHint ".gtf, .gff, .gff3, .bed", `tab: .references` | |
| 24 | "Fill in the Import Annotation Track alert that appears." | true | `ReferenceBundleAnnotationImportConfigurationPresenter.swift:57`, `alert.messageText = "Import Annotation Track"` | |
| 25 | "Click OK." | false | `ReferenceBundleAnnotationImportConfigurationPresenter.swift:58-59` adds the buttons "Import" and "Cancel". There is no OK button | "Click **Import**." |
| 26 | "Selecting more than one file at step 2 skips that alert." | false | `AppDelegate+ImportCenter.swift:94-113` calls the presenter unconditionally, then branches on `urls.count == 1` only after the alert returns a configuration. With several files the alert still appears; what is dropped is the Track Name and Track ID, since the multi-file branch passes only `configuration.bundleURL` | "Selecting more than one file at step 2 still shows the alert, but only the Reference choice is used. LGE then imports every file into the chosen bundle under names derived from the filenames." |
| 27 | "The alert does not appear at all when the project holds no reference bundle, so import a sequence first." | true | `ReferenceBundleAnnotationImportConfigurationPresenter.swift:50-53`, `guard !choices.isEmpty else { completion(nil); return }` | |
| 28 | "The Reference Sequences card has no settings." | true | `parameters.yaml:1648` `settings: []`; `ImportCenterViewModel.swift:519-548` is an `openPanel` import kind with no accessory controls | |
| 29 | "Two options exist on the command line only" (`--name`, `--output-dir`) | true | `parameters.yaml:1649-1655` lists exactly those two under `cli_only`; `cli-help/import.txt` confirms both on `import fasta` | |
| 30 | "**Reference.** ... The default is the reference bundle currently open in the viewport, and otherwise the first bundle the project holds" | true | `parameters.yaml:1675-1681` label "Reference", control popup, that exact default; `AppDelegate+ImportCenter.swift:93` passes `originSplit.viewerController.currentBundleURL` as `preferredBundleURL`, and the presenter falls back to the first discovered choice | |
| 31 | "**Track Name.** ... The default is derived from the annotation filename" | true | `parameters.yaml:1682-1688`; `ReferenceBundleAnnotationImportConfigurationPresenter.swift:72-73`, `defaultTrackName(for: sourceURL)`, label at `:105` | |
| 32 | "**Track ID.** ... The default is derived from the annotation filename ... Change it only when the derived identifier collides with a track the bundle already has." | true | `parameters.yaml:1689-1695`; presenter `:78-79` and label at `:106` | |
| 33 | "This setting has no command-line flag." on all three | true | `parameters.yaml:1681`, `:1688`, `:1695` all read `cli_flag: null` | |
| 34 | "There is no command-line equivalent for attaching an annotation track. The window is the only route." | true | `parameters.yaml:1703`, "There is no CLI equivalent for attaching an annotation track." `cli-help/import.txt` has no annotation subcommand | |
| 35 | "A `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its indexes, and `annotations/`, `variants/`, and `tracks/` folders hold whatever is attached" | true | The live bundle root holds `manifest.json`, `annotations/`, `genome/`, `metadata/`, `provenance/`, `tracks/`, `variants/` | |
| 36 | "The bundle also carries provenance ... which the Inspector shows in its own section when the reference is selected in the sidebar." | true | The live bundle has a `provenance/` folder; `Views/Inspector/Sections/ProvenanceSection.swift` renders it as a section | |
| 37 | "Selecting the reference gives you a Sequence Length row reading 81,706" | false | The Inspector's reference metadata row is labelled **Total Length**, not Sequence Length (`Views/Inspector/Sections/DocumentSection.swift:841`), and its value passes through `formatBases` (`:1562-1575`), which renders 81,706 as `81.7 Kb`, not `81,706`. A row literally named "Sequence Length" does exist but only in the Selected Region state after you drag out a selection (`ViewerViewController+SequenceAnnotationSelection.swift:89`) | "Selecting the reference gives you a Total Length row reading 81.7 Kb" |
| 38 | "selecting a single feature gives you that feature's own details. The rows change with the selection" | true | `Views/Inspector/Sections/SelectionSection.swift:1130` gives a per-annotation Length row; `DocumentSection.swift:841-860` gives a different row set for the genome | |
| 39 | "The sidebar on the left shows the bundle inside the `Reference Sequences/` folder. Right-click it for **Rename...**, **Show in Finder**, and **Move to Trash**." | false | The three titles are exact (`SidebarViewController+MenuDelegate.swift:311` "Show in Finder", `:335` "Rename...", `:361` "Move to Trash"), but the sentence reads as the whole menu and the menu also carries **Copy Path** (`:317`), **Show in Inspector** (`:325`), **Duplicate** (`:340`), and a **Move to** submenu (`:348`) | "Right-click it for **Rename...**, **Show in Finder**, and **Move to Trash**, among other items." |
| 40 | "Three lanes stack vertically inside that one view. They are drawing layers rather than separate labelled panes, so there is no divider to drag between them." | true | The ruler is `EnhancedCoordinateRulerView`; base and annotation drawing both live in `SequenceViewerView`. No `NSSplitView` separates them and no literal pane labels exist. This matches the reality map's correction to claim 22 | |
| 41 | "The bottom lane is the annotations, present only when the bundle carries features, drawn as coloured blocks. The colour comes from a per-type table, so a `misc_feature` and a `mat_peptide` are different colours." | true | `SequenceAnnotation.swift:330` `misc_feature` medium grey, `:333` `mat_peptide` magenta; `SequenceViewerView+MultiSequence.swift:443` uses the same per-type map | |
| 42 | "One colour means one feature type, never one gene." | true | Same evidence. The colour switch in `SequenceAnnotation.swift:320-340` keys on `type`, with no gene-name term | |
| 43 | "**Sequence > Go to Location...** (Cmd-L)" | true | `MainMenu.swift:641-646`, title `Go to Location\u{2026}`, keyEquivalent "l" with no extra modifier | |
| 44 | "Type `NG_000007:70613-70615` and the viewport frames the three bases of the sickle cell codon, which read `GAG`." | true | Reading the fixture's ORIGIN block, positions 70613-70615 1-based are `GAG` | |
| 45 | "The import names the sequence from the record's own LOCUS line, and that line carries no version, so the contig name inside the bundle is `NG_000007`." | true | The live import printed `Sequences: NG_000007`, and `manifest.json` records `"name" : "NG_000007"` | |
| 46 | "A single number jumps to that base and a range zooms to fit it. On a single-contig bundle such as this one, the bare range `70613-70615` resolves to the only sequence there is." | true | `EnhancedCoordinateRulerView.swift:1066` lists the accepted forms, "chr:start-end, chr:start..end, start-end, position" | |
| 47 | "The editable position field at the left end of the ruler accepts the same input and shows the placeholder `chr:start-end`." | true | `EnhancedCoordinateRulerView.swift:181`, `field.placeholderString = "chr:start-end"` | |
| 48 | "**Sequence > Go to Gene...** (Cmd-Option-G)" | true | `MainMenu.swift:649-655`, keyEquivalent "g" with `[.command, .option]` | |
| 49 | "opens a picker over the annotation names" | false | `AppDelegate+SequenceMenu.swift:118-125` builds an `NSAlert` titled "Go to Gene" with a free-text `NSTextField` whose placeholder is "e.g., BRCA1 or TP53" and buttons Go and Cancel. Nothing is listed to pick from, you type a name | "opens a dialog where you type a gene name" |
| 50 | "Clicking a feature block in the annotation lane centres the view on it." | false | `SequenceViewerView+Interaction.swift:510-522` sets `selectedAnnotation`, posts the selection notification, and calls `selectAnnotationInDrawer`. A double click shows a popover (`:519`). Neither path recentres or zooms. Centring is the separate context item **Zoom to Annotation** (`:1026`) | "Clicking a feature block selects it and highlights its row in the table drawer. Use **Zoom to Annotation** in its right-click menu to fit the view to it." |
| 51 | "A **Copy** submenu holds **Copy Name**, **Copy Coordinates**, **Copy Sequence**, **Copy Complement**, **Copy Reverse Complement**, and **Copy as FASTA**, plus **Copy Translation as FASTA** on a CDS feature." | true | `SequenceViewerView+Interaction.swift:966-1006`, those seven exact titles with the CDS gate at `:1001` | |
| 52 | "**Extract Sequence...**, which writes the feature's bases to a fresh bundle, a file, or the clipboard" | true | `SequenceViewerView+Interaction.swift:1013`, title `Extract Sequence\u{2026}`; `ClassifierExtractionDialog.swift:17-31` gives bundle, file, clipboard, and share destinations | |
| 53 | "**Run FASTQ/FASTA Operation...**, which sends the feature's sequence into the operations dialog" | true | `SequenceViewerView+Interaction.swift:1018`, exact title | |
| 54 | "**Zoom to Annotation** fits the view to the feature and **Show Annotation in Inspector** opens its details on the right." | true | `SequenceViewerView+Interaction.swift:1026` and `:1050`, both exact | |
| 55 | "**Edit Annotation...** and **Delete Annotation** revise or remove it." | true | `SequenceViewerView+Interaction.swift:1058` and `:1063` | |
| 56 | "**Copy Visible Region** puts the bases now on screen onto the clipboard, **Center View Here** recentres on the point you clicked, and **Zoom to Fit** returns the whole sequence to view." | true | `SequenceViewerView+Interaction.swift:720` "Copy Visible Region", `:1082` "Center View Here", `:684` "Zoom to Fit" | |
| 57 | "Those items keep acting on the visible region even when you have dragged out a selection" | true | `appendSelectedRangeMenuItems` (`:715-742`) appends the same `copySelectionAction`, which resolves through `currentVisibleViewportRegion()` (`ViewerViewController+Extraction.swift:213-215`) | |
| 58 | "Two more items, **Show All Translations** and **Hide All Translations**, appear only when the viewport is stacking several sequences at once." | true | `SequenceViewerView+Interaction.swift:687-707`, both titles inside `if isMultiSequenceMode, let state = multiSequenceState`, the title flipping on whether any track already shows a translation | |
| 59 | "The standard code, table 1, covers most nuclear genes, and alternatives cover vertebrate mitochondria (table 2), yeast mitochondria (table 3), and bacteria (table 11)." | true | `cli-help/translate.txt`, `--table` "(1=standard, 2=vertebrate mito, 3=yeast mito, 11=bacterial)" | |
| 60 | "There are six. Three run along the forward strand as `+1`, `+2`, and `+3`, and three run along the reverse complement as `-1`, `-2`, and `-3`." | true | `cli-help/sequence.txt`, `--frames` default `+1,+2,+3,-1,-2,-3` | |
| 61 | "Click **Translate** in the window toolbar. That button is the only route to the overlay translation tool." | true | `MainWindowController.swift:941-956`, the `translateTool` toolbar item labelled "Translate", action `showTranslationTool(_:)`. No other caller of that selector exists | |
| 62 | "**Sequence > Translate...** (Cmd-Shift-T) is a different thing, and it runs the translate operation on the active sequence rather than opening the overlay." | true | `MainMenu.swift:632-636`, title `Translate\u{2026}`, keyEquivalent "t" with `[.command, .shift]`; `AppDelegate+SequenceMenu.swift:27-36` calls `runSelectedSequenceFASTAOperation(toolID: .translate)` | |
| 63 | "Its sibling **Sequence > Reverse Complement...** (Cmd-Shift-R) runs the reverse-complement operation the same way." | true | `MainMenu.swift:626-630`, keyEquivalent "r" with `[.command, .shift]`; `AppDelegate+SequenceMenu.swift:17-25` calls the same helper with `.reverseComplement` | |
| 64 | "a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`. Picking `Single Frame` reveals a picker for one specific frame." | true | `TranslationToolView.swift:11-15`, the four raw values in that order; `:95-104` shows the frame picker under the Reading Frames section | |
| 65 | "Choose the code under `Genetic Code`." | true | `TranslationToolView.swift:111`, `Picker("Genetic Code", selection: $selectedTableIndex)` | |
| 66 | "The `Color Scheme` picker ... offering `Zappo`, which is the default and which groups residues by physicochemical property, then `ClustalX`, `Taylor`, and `Hydrophobicity`." | true | `TranslationToolView.swift:59` `@State private var colorScheme: AminoAcidColorScheme = .zappo`; `:122` the picker; `AminoAcidColors.swift:26-29` gives the four names in that order and `:36` describes Zappo | |
| 67 | "Leave `Show Stop Codons` on if you want stop positions marked, then click `Apply`." | true | `TranslationToolView.swift:60` defaults `showStopCodons` to true; `:130` the toggle; `:170` the Apply button | |
| 68 | "`Hide Translation` clears it." | true | `TranslationToolView.swift:159`, the Hide Translation button, which applies an empty frame list | |
| 69 | "The tool overlays the protein for reading and writes no file" | true | `TranslationToolConfiguration` (`TranslationToolView.swift:32-37`) carries frames, table, colour scheme, and the stop flag, and no output path. `MainWindowController.swift:483-494` routes Apply to `applyFrameTranslation` | |
| 70 | "Drag across the bases to select a region, then choose **Sequence > Add Annotation...**." | true | `MainMenu.swift:675-679`, title `Add Annotation\u{2026}` | |
| 71 | "The type menu offers `gene`, `CDS`, `exon`, `mRNA`, `region`, `misc_feature`, `promoter`, `primer`, and `restriction_site`, and the strand menu offers `+`, `-`, or `none`. Click **Add**." | true | `AppDelegate+SequenceMenu.swift:499-502`, `:510`, `:478`, matching the reality map row 51 | |
| 72 | "Selecting nothing first stops the command with the message \"Please select a region of the sequence first.\"" | true | `AppDelegate+SequenceMenu.swift:468-471`, that exact string | |
| 73 | "Choose **Sequence > Find ORFs...** on an open bundle. The dialog groups its controls under four headings." | true | `MainMenu.swift:681-685` for the item; `SequenceORFOperationDialog.swift:173`, `:183`, `:196`, `:202` give the sections Reading Frames, Translation, Output, Options | |
| 74 | "Reading Frames holds a checkbox per frame, all six on by default." | true | `SequenceORFOperationDialog.swift:173-181` draws two rows of three; `:34` `defaultFrames: ReadingFrame.allCases` | |
| 75 | "Translation holds `Codon table` and `Minimum ORF length`, the shortest ORF to keep in nucleotides, default 100." | true | `SequenceORFOperationDialog.swift:184` `Picker("Codon table"...)`, `:191` `TextField("Minimum ORF length"...)`, `:36` default 100; `cli-help/sequence.txt` `--min-length` "(default: 100)" | |
| 76 | "Output holds `Track name`, prefilled with the sequence name followed by ` ORFs`, so on this record it reads `NG_000007 ORFs`, and `Track ID`." | true | `AppDelegate+SequenceMenu.swift:681`, `let defaultTrackName = "\(sequenceName) ORFs"`; `SequenceORFOperationDialog.swift:197-198` for the two fields. The live import confirms the sequence name is `NG_000007`, so the prefill reads `NG_000007 ORFs` | |
| 77 | "Options holds `Include partial ORFs` ... and `Allow alternative starts`, which also treats the selected genetic code's alternative start codons as starts." | true | `SequenceORFOperationDialog.swift:203`, `:205`; `cli-help/sequence.txt` `--allow-alternative-starts` "Allow alternative starts for the selected genetic code." The chapter correctly avoids naming specific codons, which the reality map row 56 flagged as unverifiable | |
| 78 | "Click **Run**." | true | `SequenceORFOperationDialog.swift:153`, `primaryActionTitle: "Run"` | |
| 79 | "LGE writes a new annotation track holding one feature per ORF, each carrying its translated protein as an attribute." | true | The live ORF run wrote `annotations/orfs.bed` whose single row carries `translation=MKLVVRPWAGWYQGYKTG...` in its attribute column | |
| 80 | "The window has no command for deleting a whole annotation track." | true | No delete-track item appears in `MainMenu.swift`, in `SequenceViewerView+Interaction.swift`, or in the sidebar menu. **Delete Annotation** (`:1063`) removes one feature | |
| 81 | "Three items under **File > Export** ... **Sequences (FASTA/GenBank)...** ... **Annotations (GFF3)...** ... and the **Provenance** submenu" | true | `MainMenu.swift:221-231` for the first two exact titles, `:259-271` for the Provenance submenu | |
| 82 | "Confirm the length in the Inspector reads 81,706 for this record" | false | Same evidence as row 37. The Inspector row is Total Length and it reads `81.7 Kb`, so a reader running this check as written will not find the string 81,706 | "Confirm the Total Length in the Inspector reads 81.7 Kb for this record" |
| 83 | "Confirm that the bases at 70613 to 70615 read `GAG`" | true | Verified directly against the fixture's ORIGIN block | |
| 84 | "A GenBank flatfile opens with a `LOCUS` line and carries a FEATURES table" | true | The fixture's first line is `LOCUS       NG_000007              81706 bp` and it carries a `FEATURES` block | |
| 85 | Code block, `lungfish-cli import fasta ~/Downloads/NG_000007.3.gb --name HBB --output-dir ~/Documents/hbb-example.lungfish` | true | Ran with the same flags against the fixture and it succeeded, printing the summary and writing `HBB.lungfishref`. The comment "Despite the subcommand name, this accepts GenBank too" is borne out | |
| 86 | Code block, `lungfish-cli translate ~/Downloads/NG_000007.3.gb --frame 1 --table 1 -o hbb-frame1.faa` | false | Run against the fixture this exits with `Error: Unsupported format: gb (translate requires FASTA input)`. `cli-help/translate.txt` also states the argument is "Input file (FASTA format)". The command as printed cannot work on the file the chapter tells the reader to download | Point translate at a FASTA. The bundle's own sequence works, for example `lungfish-cli translate "~/Documents/hbb-example.lungfish/Reference Sequences/HBB.lungfishref/genome/sequence.fa.gz" --frame 1 --table 1 -o hbb-frame1.faa`, or export a FASTA first through **File > Export > Sequences (FASTA/GenBank)...** |
| 87 | Code block, `lungfish-cli extract sequence ~/Downloads/NG_000007.3.gb NG_000007:70545-72152 --line-width 70 -o hbb-gene.fasta` | false | Run against the fixture this exits with `Error: Unsupported format: gb (extract requires FASTA input)`. `cli-help/extract.txt` says "Extract subsequences from FASTA files" | Same fix as row 86. Point the region extraction at a FASTA rather than at the `.gb` |
| 88 | Code block, `lungfish-cli sequence annotate-orfs ... --sequence NG_000007 --start 70544 --end 72152 --frames +1,+2,+3 --table 1 --min-length 300 --track-name "HBB ORFs"` | true | Ran verbatim against the live bundle and printed `Created annotation track orfs with 1 feature(s).` The manifest then carried `"name" : "HBB ORFs"` | |
| 89 | Code block, `lungfish-cli sequence delete-annotation-track ... --track-id imported_annotations` | true | `cli-help/sequence.txt` gives the usage and the `--track-id` option, and the live bundle's track id is literally `imported_annotations`. Not executed, since it writes destructively | |
| 90 | "`import fasta` takes `--name`, which sets the display name of the reference and defaults to the input filename, and `--output-dir`, which names the project directory the bundle is written into and defaults to the current directory." | true | `cli-help/import.txt`, `import fasta`, `--name` "(default: filename)" and `-o, --output-dir` "(default: current directory)" | |
| 91 | "`translate` takes `--frame`, where 1 to 3 are the forward strand and 4 to 6 are the reverse complement, and translates all six when you omit it." | true | `cli-help/translate.txt` overview, "Reading frames 1-3 are forward strand, 4-6 are reverse complement ... By default, all 6 frames are translated" | |
| 92 | "`--table` picks the genetic code and defaults to 1." | true | `cli-help/translate.txt`, `--table` "(default: 1)" | |
| 93 | "`--trim-to-stop` cuts each translation at its first stop codon, `--no-stop-asterisk` drops the `*` characters marking stops, and `--longest-orf` keeps only the longest open reading frame per sequence per frame." | true | `cli-help/translate.txt`, the three options with those effects, `--longest-orf` worded "per sequence per frame" | |
| 94 | "The global `--format` flag takes `text`, `json`, or `tsv` and defaults to `text`" | true | `cli-help/translate.txt`, `--format` "(values: text, json, tsv; default: text)" | |
| 95 | "so `--format json` gives a script something machine-readable to read back" | true | Kept general, with no field list. This matches the reality map's correction to row 50 | |
| 96 | "`extract sequence` takes its region as `name:start-end`, counted 1-based and inclusive like the window." | true | `cli-help/extract.txt`, "specifying a region in the format chr:start-end (1-based, inclusive coordinates, matching samtools faidx convention)" | |
| 97 | "`--line-width` sets the FASTA wrapping and defaults to 70." | true | `cli-help/extract.txt`, `--line-width` "FASTA line width (default: 70)" | |
| 98 | "`--sequence` picks the contig and defaults to the first in the bundle." | true | `cli-help/sequence.txt`, "Sequence/chromosome name. Defaults to the first sequence in the bundle." | |
| 99 | "`--start` and `--end` bound the search and default to the whole sequence, and unlike the window they are 0-based with the start inclusive and the end exclusive, which is why the block above passes 70544 for a gene that starts at 70545." | true | `cli-help/sequence.txt`, "0-based inclusive start coordinate. Defaults to 0." and "0-based exclusive end coordinate. Defaults to the sequence length." Confirmed empirically: the live run's ORF row begins at 70658, and reading the fixture 0-based from 70658 gives `ATG` while reading 1-based gives `GAT`. The gene span check also holds, 0-based 70544 is 1-based 70545 | |
| 100 | "`--track-name` has no default at all, so pass it when you want a named track." | true | `cli-help/sequence.txt`, `--track-name` reads only "Annotation track display name." with no default, unlike `--track-id`. This is the reality map's correction to row 60 | |
| 101 | "`--track-id` falls back to a workflow-provided identifier." | true | `cli-help/sequence.txt`, "Annotation track ID. Defaults to a workflow-provided ID." The live run omitted it and got the id `orfs` | |
| 102 | "`sequence delete-annotation-track` removes a whole track by `--track-id`. Its sibling `sequence delete-annotations` removes individual rows from a track, taking `--track-id` plus one or more `--row-id` values." | true | `cli-help/sequence.txt`, both subcommands with those exact options and the `--row-id` note "Repeat or pass multiple values." | |
| 103 | "`bam annotate-cds-best` ... Its four required options are `--bundle` for the source, `--mapping-result` ..., and `--output-bundle` and `--output-track-name`" | true | `cli-help/bam.txt:146`, all four appear outside brackets in the usage line | |
| 104 | "It builds a new bundle and leaves the source untouched." | true | `cli-help/bam.txt`, overview "Create a new bundle with best CDS query gene and CDS annotations", and `--output-bundle` "Path for the new output reference bundle" | |
| 105 | "`--min-query-cover` sets how much of a CDS query the alignment has to cover before the model transfers, defaulting to 0.5, which means half." | true | `cli-help/bam.txt`, "Minimum fraction of the CDS query covered by aligned components (default: 0.5)" | |
| 106 | "`--output-track-id` names the new track and otherwise falls back to a generated identifier." | true | `cli-help/bam.txt`, "Annotation track ID. Defaults to a generated portable ID." | |
| 107 | "`--replace` overwrites an output bundle or track of the same name rather than stopping." | true | `cli-help/bam.txt`, "Replace an existing output bundle or track with the same name" | |
| 108 | "`--include-secondary` treats secondary alignments as candidate duplicated loci and `--include-supplementary` treats supplementary alignments as candidate CDS models" | true | `cli-help/bam.txt`, both option descriptions verbatim | |
| 109 | "That path reads a mapping result, so it sits with the alignment commands rather than on the **Sequence** menu, and it runs from the command line." | true | The command is under `bam` in the CLI tree, and no CDS-transfer item appears anywhere in `MainMenu.swift` | |
| 110 | "The import finishes in about a second" | true | The live import returned in roughly one second on this machine. Reported as an approximation, which is fair | |
| 111 | "Nothing here needs an external tool or an internet connection after that download ... no plugin pack has to be installed and Docker is not involved." | true | The import, ORF, and translate paths are native. `AppDelegate+ImportCenter.swift` provisions no managed tool, and no `ManagedTool` reference appears on the reference-import path | |
| 112 | "The illustration file `viewport-lanes.png`" (body image link at line 132) | false | `docs/user-manual/assets/illustrations-imagegen/02-sequences/01-importing-and-viewing/` holds `reference-bundle-anatomy.png` and `viewport-panes.png`. There is no `viewport-lanes.png`, so the image renders broken. The front matter already declares the id as `viewport-lanes`, matching the corrected lane wording, so the asset is the thing that has not caught up | Keep the `viewport-lanes` id and have the illustration owner regenerate the asset under that name, or point the link at `viewport-panes.png` until they do |

## Front matter

`parameters_refs` is `[import.reference, import.annotation-track]`, and both
ids exist in `parameters.yaml` at lines 1638 and 1665. Every setting either
registry entry declares is documented. `import.reference` declares
`settings: []` and two `cli_only` flags, and the chapter states both the
absence of settings and the two flags. `import.annotation-track` declares
three settings, Reference, Track Name, and Track ID, and the chapter carries
one Settings paragraph for each, with labels, defaults, and effects matching
the registry text and each ending in the required "This setting has no
command-line flag." sentence.

All six `<!-- SHOT -->` markers in the body have a matching `shots` entry
with a caption, and no `shots` entry lacks a marker. The ids are
`import-center-reference-card`, `import-center-annotation-track-alert`,
`hbb-record-in-sequence-viewport`, `go-to-location-hbb-codon`,
`hbb-annotation-context-menu`, and `translation-tool-hbb-cds`. Three of
those, `import-center-reference-card`, `hbb-record-in-sequence-viewport`,
and `go-to-location-hbb-codon`, are shared with chapter 1 by design, and
chapter 1 declares and places the same three ids.

Two caption checks are worth passing to the screenshot scout. The
`import-center-annotation-track-alert` caption says the alert shows "the
Reference popup above the Track Name and Track ID fields", which the
presenter confirms at lines 104-106. The `translation-tool-hbb-cds` caption
names "Mode, Genetic Code, and Color Scheme controls above the Apply
button", which `TranslationToolView.swift` confirms, though the sheet groups
them under the section headers Reading Frames, Codon Table, and Display
Options rather than showing a control literally labelled Mode.

All nineteen `glossary_refs` anchors resolve in `GLOSSARY.md`, checked one
by one: reference-bundle, bundle, contig-reference, annotation-track,
import-center, sequence-viewport, sidebar, inspector, fasta, gff, cds, exon,
codon, reading-frame, reverse-complement, genetic-code, open-reading-frame,
refseqgene, provenance.

The `viewport-lanes` illustration is declared with a brief but has no PNG on
disk, which is claim 112 above.

## Agreement with chapter 1

Chapter 1 covers the same import and the same coordinate, and the two agree
everywhere they overlap. Both give the record as `NG_000007.3`, the length
as 81,706 bases, the contig name as `NG_000007` with the version dropped and
an explanation of why, the codon at 70613 to 70615 as `GAG`, and the
sickle change as the middle `A` at 70614 going to `T`. Both use the same
fixed Before you start sentences that `CONSISTENCY.md` requires, and both
route the import through the Reference Sequences card rather than a drop
zone.

One shared claim is wrong in both chapters in the same way. Chapter 1's What
good looks like says the length "appears in the Inspector beside the
reference's name", and chapter 9 says the Inspector gives "a Sequence Length
row reading 81,706". The Inspector's row is Total Length and it renders
`81.7 Kb`. Chapter 1's wording is vaguer and so survives, while chapter 9
names a row label and a number that a reader will not see. Fixing chapter 9
per row 37 does not put it at odds with chapter 1.

## Consistency sheet

The chapter follows `CONSISTENCY.md`. It says "Lungfish Genome Explorer
(LGE)" at first mention and "LGE" after, writes the CLI as `lungfish-cli`
throughout, writes menu paths in bold with a greater-than sign and a
trailing ellipsis on dialog-opening items, calls the Import Center "a tabbed
grid of cards, each card a drop target", names the fixture "the HBB gene
record", uses the two fixed Before you start sentences verbatim, and writes
bundle extensions in code font. Each Settings paragraph opens with the
control's label in bold with the period inside the bold and runs the three
sentences in the required order before the no-flag sentence.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues on this file.

## Counts

True 102, false 10, unverifiable 0.
