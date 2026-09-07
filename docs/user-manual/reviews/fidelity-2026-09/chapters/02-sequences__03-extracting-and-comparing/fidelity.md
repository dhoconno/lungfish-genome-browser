# Fidelity review, 02-sequences/03-extracting-and-comparing.md

Reviewed 2026-09-06 against the Swift source in this worktree, the CLI help
dumps under `reviews/fidelity-2026-09/cli-help/`, and live re-runs of
`extract sequence`, `bundle extract-annotations`, and the stored
`annotate-orfs` output in the author's scratch project at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/hbb-extract/`.

## Headline finding

The chapter documents the wrong sheet for its own primary procedure. Two
different sheets in the app are titled "Extract Sequence", and the chapter
describes one of them while instructing the reader to open the other.

`Sequence > Extract Visible Region...` calls `SequenceMenuActions.extractSelection`
(`MainMenu.swift:667-671`), which reaches `extractSelectionSequence`
(`AppDelegate+SequenceMenu.swift:442-451`) and then `presentExtractionSheet`
(`ViewerViewController+Extraction.swift:249-256`). That method hosts
`ExtractionConfigurationView` (`:301-320`), which is a 520x560 sheet with a
three-segment Action picker, Source, Flanking Sequence, Options, and Bundle
sections, and a primary button reading **Extract**. It has no Destination
radio group, no "N selected" header, no Save to File, no Copy to Clipboard,
no Share, and no Create Bundle button.

The four-destination sheet the chapter describes (`FASTASequenceExtractionDialog`)
is reached only from the annotation right-click route and from the MSA,
assembly, mapping, and NVD viewports. So the chapter's steps 3 through 5 of
the first procedure, and much of its Settings section, belong to the second
route, not the first.

## Claims table

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "it keeps extractions in the project's `Extractions/` folder" | true | `ViewerViewController+Extraction.swift:401` calls `extractionsDirectory()`, defined `:573-586`, returning `<project>/Extractions` | |
| "When LGE cannot work out which project the source belongs to, it falls back to an `Extractions` folder beside the working directory, and failing that to `Lungfish Extractions` in your Documents folder." | true | `ViewerViewController+Extraction.swift:574-585`, the three branches in order | |
| "Extractions never land in `Imports/` or in `Reference Sequences/`." | false | The annotation right-click route's Save as Bundle calls `createReferenceBundle` (`ViewerViewController.swift:2657-2662`), which writes into `ReferenceSequenceFolder.ensureFolder` (`:2476`, folder name `"Reference Sequences"` at `ReferenceSequenceFolder.swift:20`) or routes through `importFASTAFromURL` (`:2391`). Only the visible-region route uses `Extractions/` | "The visible-region route writes into `Extractions/`. The annotation route writes a new reference bundle into `Reference Sequences/` instead, because it goes through the same import path an imported FASTA takes." |
| "one command gives you all eight genes on a record as eight FASTA records" | true | Re-ran `bundle extract-annotations --feature-type gene`, "Extracted features: 8"; `NG_000007.3.gb` has 8 `gene` features | |
| "Each route offers the same four places to put the result." | false | The visible-region route offers three (Copy as FASTA, Copy Protein on a CDS, New Bundle) via the Action picker at `ExtractionConfigurationView.swift:92-103`. The CLI route offers stdout or `-o`, not four destinations | "The annotation route offers four destinations. The visible-region route offers a three-way Action picker instead, and the command line writes to standard output or to a file." |
| "The HBB gene record carries eight genes across 81,706 bases" | true | `LOCUS NG_000007 81706 bp`; 8 `gene` features counted from the flatfile | |
| "It spans positions 70545 to 72152 of the record, which is 1,608 bases" | true | `NG_000007.3.gb` gene feature; live extract reports "Extracted 1608 bp" | |
| "`HBE1`, `HBG2`, `HBG1`, `BGLT3`, `HBBP1`, `HBD`, `HBB`, and the pseudogene `OR51AB1P`" | true | The eight headers produced by the live gene extraction, listed below | |
| "**File > New Project** (Cmd-N)" | true | `MainMenu.swift:169-173`, title "New Project", keyEquivalent "n" | |
| "**File > Import Center...** (Cmd-Shift-I)" | true | `MainMenu.swift:207-212`, ellipsis title, Cmd-Shift-I | |
| "the position field at the left end of the ruler, which shows the placeholder `chr:start-end`" | true | `EnhancedCoordinateRulerView.swift:181`, `field.placeholderString = "chr:start-end"` | |
| "**Sequence > Go to Location...** (Cmd-L) accepts the same text." | true | `MainMenu.swift:641-645`, title with ellipsis, keyEquivalent "l" | |
| "On a single-contig bundle such as this one the bare range resolves to the only sequence there is" | true | `EnhancedCoordinateRulerView.swift:1066` parses `chr:start-end`, `chr:start..end`, `start-end`, and a bare position | |
| "Extraction takes whatever the viewport is showing, so a drag selection does not narrow it" | true | `currentVisibleViewportRegion()` (`ViewerViewController+Extraction.swift:257-263`) reads `viewController.referenceFrame`, never a selection | |
| "Choose **Sequence > Extract Visible Region...** (Cmd-Shift-E). A sheet titled Extract Sequence opens." | true | `MainMenu.swift:665-671` for the item and shortcut; `ExtractionConfigurationView.swift:81` renders `Text("Extract Sequence")` as the header | |
| "Its header carries a count reading \"1 selected\", which is the number of FASTA records the extraction covers" | false | That header belongs to `FASTASequenceExtractionDialog` (`:34`, `Text("\(model.selectionCount) selected")`), which this menu item never opens. `ExtractionConfigurationView`'s header is a scissors icon plus the title, with no count (`:77-86`) | Move the "N selected" sentence to the annotation-route procedure, where the count is the number of records prepared by `presentAnnotationSequenceExtractionDialog` (`ViewerViewController+Extraction.swift:124-147`). |
| "Pick one of the four Destination choices. Save as Bundle ... Save to File... ... Copy to Clipboard ... Share..." | false | No Destination group exists on the sheet this step opens. `ExtractionConfigurationView.swift:92-106` offers a segmented Action picker with Copy as FASTA, Copy Protein (CDS only), and New Bundle | For this step, "Pick one of the Action choices at the top. Copy as FASTA puts the FASTA text on the clipboard, Copy Protein appears only on a CDS and gives the translated protein, and New Bundle writes a new `.lungfishref` bundle into the project." |
| "The Name field appears for the first two choices and hides for the other two, because a clipboard entry and a shared item have no filename to set." | true (of the annotation route only) | `DialogDestination.showsNameField` (`ClassifierExtractionDialog.swift:44-46`) is true for `.bundle` and `.file`; `FASTASequenceExtractionDialog.swift:66` gates the field on it | Keep the sentence, but attach it to the annotation route. |
| "Type the name `HBB-gene` and click the button at the bottom right. Its label follows the destination, so it reads Create Bundle for a bundle, Save for a file, Copy for the clipboard, and Share for the share sheet." | false | Correct for the annotation route (`ClassifierExtractionDialog.swift:34-41`; `FASTASequenceExtractionDialog.swift:90`), but the sheet this step opens has a fixed **Extract** button (`ExtractionConfigurationView.swift:200`) and a Bundle Name field shown only for New Bundle (`:177-183`) | For this step, "Type the name into Bundle Name, which appears once you pick New Bundle, and click Extract." |
| "The new bundle appears under `Extractions/` in the sidebar." | true | `createExtractionBundle` (`ViewerViewController+Extraction.swift:394-402`) writes to `extractionsDirectory()` | |
| "Right-click the feature block in the annotation lane ... Choose **Extract Sequence...**." | true | `SequenceViewerView+Interaction.swift:1013`, `NSMenuItem(title: "Extract Sequence\u{2026}", action: #selector(extractAnnotationSequence(_:)))` | |
| "The same Extract Sequence sheet opens, with the feature's name already filled into the Name field." | false in part | A *different* sheet opens, `FASTASequenceExtractionDialog` (`ViewerViewController+Extraction.swift:147` into `ViewerViewController.swift:2622-2676`). The name prefill is right, `suggestedName = annotations[0].name` (`+Extraction.swift:146`) | "A sheet also titled Extract Sequence opens, though it is not the same sheet as the visible-region route's. It carries a Destination group, a record count, and a Name field already holding the feature's name." |
| "The bases you get are the feature's own, taken from its recorded start and end rather than from the screen." | true | `presentAnnotationSequenceExtractionDialog` builds `ExtractionRequest(source: .annotation(annotation))` (`+Extraction.swift:129`) and `extractAnnotation` reads the annotation's own intervals (`SequenceExtractor.swift:247-253`) | |
| "**Copy Sequence** puts the bases on the clipboard as plain text, **Copy as FASTA** adds a header line, **Copy Reverse Complement** gives you the other strand, and **Copy Translation as FASTA** appears on a CDS feature and gives the protein." | true | `SequenceViewerView+Interaction.swift:979`, `:996`, `:989`, `:1002` with the CDS gate at `:1001` | |
| "The same right-click menu holds a Copy submenu" | true | `SequenceViewerView+Interaction.swift:964-1010`, `NSMenu(title: "Copy")` | |
| "**Extract Reads in Selected Region...** appears on the right-click menu only when an alignment selection is present" | true | `SequenceViewerView+Interaction.swift:725-733`, guarded by `viewController?.explicitAlignmentSelection != nil` | |
| "Choose **Sequence > Copy Visible Region as FASTA** (Cmd-Shift-C)." | true | `MainMenu.swift:658-664`, keyEquivalent "c" with `[.command, .shift]` | |
| "This is the only item on the **Sequence** menu without a trailing ellipsis" | true | The Sequence menu holds Reverse Complement..., Translate..., Go to Location..., Go to Gene..., Copy Visible Region as FASTA, Extract Visible Region..., Add Annotation..., Find ORFs... (`MainMenu.swift:620-689`). Only the copy item lacks an ellipsis | |
| "the missing ellipsis is the cue that it acts at once with no dialog" | true | `copySelectionAsFASTA` (`+Extraction.swift:213-239`) writes straight to `NSPasteboard.general` | |
| "the copy takes the visible region and the visible region is whatever the viewport settled on" | true | `copySelectionAsFASTA` calls `currentVisibleViewportRegion()` (`+Extraction.swift:214`) | |
| "Choose **Sequence > Find ORFs...**. A panel titled Find ORFs opens, with the heading FIND ORFS inside it." | true | `MainMenu.swift:682-686` for the ellipsis title; `SequenceORFOperationDialogPresenter` sets `panel.title = "Find ORFs"` (`:247`) and `DatasetOperationsDialog(title: "FIND ORFS", ...)` (`:146`) | |
| "grouped under Reading Frames, Translation, Output, and Options" | true | `SequenceORFOperationDialog.swift:173`, `:182`, `:195`, `:202` | |
| "Click Run." | true | `primaryActionTitle: "Run"` (`SequenceORFOperationDialog.swift:153`) | |
| "LGE writes a new annotation track holding one feature per surviving ORF, each carrying its own translated protein as an attribute." | true | The produced `hbb_orfs.bed` row carries `translation=MKLVVRPWAGW...` in its attribute column | |
| "The window cannot delete a whole track again, so removal is a command-line job" | false | The annotation table drawer's track menu offers **Delete Track…** (`AnnotationTableDrawerView+Filtering.swift:1207-1215`), wired to `deleteAnnotationTrackFromMenu` (`:1240-1247`) and a confirming alert (`ViewerViewController+AnnotationDrawer.swift:524-527`) | "Remove a track again from the annotation table drawer's track menu, which offers Delete Track... and asks you to confirm. The command line can do the same." |
| "The Extract Sequence sheet has two controls" | false | The visible-region sheet has an Action picker, 5' Flank, 3' Flank, Reverse Complement, Concatenate Exons (discontiguous only), and Bundle Name (`ExtractionConfigurationView.swift:92-183`). The annotation sheet has the two the chapter names | "The visible-region sheet has six controls and the annotation sheet has two." Document both against `sequence.extract-region`, which already lists 5' Flank, 3' Flank, Reverse Complement, Concatenate Exons, Destination, and Name. |
| "neither is in the settings registry" | false | `docs/user-manual/parameters.yaml:6804` defines `sequence.extract-region` with six settings, and `:6720` defines `sequence.find-orfs` with seven | Drop both "not in the registry" sentences and cite the ids. |
| **Reading Frames.** "as one checkbox per frame. All six start on" | true | `SequenceORFOperationDialog.swift:34` defaults `defaultFrames` to `ReadingFrame.allCases`; `:221-230` renders a Toggle per frame | The dialog has no control literally labelled "Reading Frames" beyond the section heading. The six checkboxes are labelled `+1`, `+2`, `+3`, `-1`, `-2`, `-3` (`:222`, `frame.rawValue`). Say so. |
| **Reading Frames.** "On the command line this is `--frames`, which takes a comma-separated list such as `+1,+2,+3`." | true | `sequence.txt:31-32`, "Comma-separated reading frames, e.g. +1,+2,+3,-1,-2,-3. (default: +1,+2,+3,-1,-2,-3)" | |
| **Codon table.** label | true | `SequenceORFOperationDialog.swift:183`, `Picker("Codon table", ...)` | |
| **Codon table.** "The default is table 1, the standard code" | true | `:35` defaults to `CodonTable.standard.id`, which is 1 (`CodonTable.swift:15-22`). The menu renders `"1 - Standard"` (`:185`) | |
| **Codon table.** "table 2 covers vertebrate mitochondria and table 11 covers bacteria" | true | `CodonTable.swift:24-30` and `:69-76` | |
| **Codon table.** "On the command line this is `--table`." | true | `sequence.txt:33`, "NCBI genetic code table ID. (default: 1)" | |
| **Minimum ORF length.** label and default 100 | true | `SequenceORFOperationDialog.swift:191` `TextField("Minimum ORF length", ...)`; `:36` `defaultMinimumORFLength: Int = 100`; `sequence.txt:34-35` | |
| **Minimum ORF length.** "counted in nucleotides rather than in amino acids ... about 33 codons" | true | `sequence.txt:35`, "Minimum ORF length in nucleotides"; 100/3 is 33.3 | |
| **Track name.** label | true | `SequenceORFOperationDialog.swift:196`, `TextField("Track name", ...)` | |
| **Track name.** "arrives prefilled with the sequence name followed by ` ORFs`, so on this record it reads `NG_000007 ORFs`" | true | `AppDelegate+SequenceMenu.swift:681`, `let defaultTrackName = "\(sequenceName) ORFs"`. The scratch bundle's sequence is `NG_000007` | |
| **Track name.** "On the command line this is `--track-name`." | true | `sequence.txt:41-42` | |
| **Track ID.** label | true | `SequenceORFOperationDialog.swift:198`, `TextField("Track ID", ...)` | |
| **Track ID.** "it has to be unique inside the bundle" | unverifiable | The dialog validates the character set only (`SequenceORFOperationDialog.swift:123-126`, `isValidTrackID`), not uniqueness. Whether the pipeline rejects or silently replaces a colliding id was not read | Read `SequenceAnnotationOperation`'s track-write path, or run `annotate-orfs` twice with the same `--track-id` against a scratch bundle and record what happens. |
| **Track ID.** "It is prefilled from the same source as the name" | false | The name comes from `"\(sequenceName) ORFs"` but the id comes from `defaultSequenceAnnotationTrackID(prefix: "orfs", chromosome: sequenceName)` (`AppDelegate+SequenceMenu.swift:682-685`), a separate generator | "It arrives prefilled with a generated id built from the same sequence name, in the form `orfs-<sequence>`." |
| **Track ID.** "which is what the delete command later asks for" | true | `sequence.txt:97`, `delete-annotation-track --track-id` | |
| **Include partial ORFs.** label, default off, `--include-partial` | true | `SequenceORFOperationDialog.swift:203` `Toggle("Include partial ORFs", ...)`; `:37` `includePartialORFs: Bool = false`; `sequence.txt:36` | |
| **Allow alternative starts.** label, default off, `--allow-alternative-starts` | true | `SequenceORFOperationDialog.swift:205`; `:38`; `sequence.txt:37-39` | |
| **Allow alternative starts.** "Turn it on for bacterial sequence, where `GTG` and `TTG` starts are ordinary." | true | `CodonTable.swift:75`, table 11 `startCodons: ["ATG", "GTG", "TTG"]` | |
| Settings section omits the visible-region sheet's flank, reverse-complement, and concatenate controls | false (omission) | `ExtractionConfigurationView.swift:125-172` and `parameters.yaml:6810-6845` | Add a Settings entry for 5' Flank, 3' Flank, Reverse Complement, and Concatenate Exons (remove introns), which appears only on a discontiguous feature. The two flank fields carry 100/500/1000/5000 preset buttons (`:135-143`, `:154-162`). |
| `>NG_000007:70544-72152 [NG_000007:70544-72152] [1608 bp]` | true | Re-ran `extract sequence ... NG_000007:70545-72152 --line-width 70`, which printed exactly this header | |
| "The start reads 70544 rather than 70545 because the header prints the internal 0-based start while the length is computed over the inclusive span." | true | `buildHeader` is called with `effectiveStart` (`SequenceExtractor.swift:214`), which is the 0-based internal start, and `length: nucleotideSequence.count` (`:218`). Both the leading name and the bracketed token use it, since `sourceName` for the CLI region path is rebuilt 0-based | The leading token is also 0-based here, so "the leading token names the region" is loose. Say both coordinate tokens print the 0-based start. |
| "1608, which matches 72152 minus 70545 plus 1" | true | 72152 - 70545 + 1 = 1608, and the run reported "Extracted 1608 bp" | |
| "A flipped extraction adds `[reverse complement]`, and a feature stitched from several exons adds `[exons concatenated]`." | true | `SequenceExtractor.swift:377-383` | |
| "A feature also contributes `[strand: +]` or `[strand: -]` and its feature type." | true | `SequenceExtractor.swift:366-375`. The type token precedes the strand token, so the order is name, coordinates, type, strand | |
| `>NG_000007:70612-70615 [NG_000007:70512-70715] [203 bp]` | true | Re-ran `extract sequence ... NG_000007:70613-70615 --flank 100`, which printed exactly this header | |
| "Padding changes only the second token." | true | `extractRegion` passes `sourceName` built from the unpadded start and end (`SequenceExtractor.swift:153`) while `buildHeader` uses `effectiveStart`/`effectiveEnd` (`:210-212`) | |
| "the length is 3 plus 100 plus 100" | true | The run reported "Extracted 203 bp" | |
| "It carries its own `manifest.json`, its own compressed FASTA with indexes under `genome/`, and its own provenance sidecar." | true | The produced `hbb-genes.lungfishref` holds `manifest.json`, `genome/sequence.fa.gz`, `.fai`, `.gzi`, and `.lungfish-provenance.json` | |
| "That sidecar records the exact command that produced it, the timestamp, the exit status, and one entry per input and output file carrying a SHA-256 checksum and a byte size." | true | The sidecar's top-level keys include `argv`, `reproducibleCommand`, `createdAt`, `startTime`, `endTime`, `exitStatus`, and a `files` array whose entries carry `sha256`/`checksumSHA256` and `sizeBytes`/`fileSize` | |
| "Map reads against it with **Tools > Mapping > minimap2...**" | true | `ToolsMenuModel.swift:70`, `case .mapping: return "Mapping"`, the category holding minimap2 | |
| "Running Find ORFs over the HBB gene span with the minimum length at 300 nucleotides gives one surviving ORF, on frame `+1`, from 70658 to 71060." | true | The scratch bundle's `annotations/hbb_orfs.bed` holds exactly one row, `NG_000007 70658 71060 ORF_+1_70658_71060 ... frame=+1`, and `manifest.json` reports `feature_count: 1` | |
| "That is 402 nucleotides, which is 134 amino acids, and its translation starts `MKLVVRPWAGWYQGYKTGL`." | true | The BED attributes read `length_nt=402;length_aa=134` and `translation=MKLVVRPWAGWYQGYKTGL...` | Worth noting the 134 counts the terminal stop, since the recorded translation ends in `*` and 402/3 is 134. |
| "the record's own curated CDS, which is `join(70595..70686,70817..71039,71890..72018)`" | true | `NG_000007.3.gb:557` | |
| "three pieces adding to 444 bases" | true | 92 + 223 + 129 = 444 | |
| "and 147 codons" | false | 444 bases is 148 triplets. The protein is 147 residues (the record's `/translation` is 147 characters), so the 148th triplet is the stop codon | "three pieces adding to 444 bases, which is 147 amino acids plus a stop codon" |
| "The ORF scan found neither the right start nor the right end" | true | The ORF runs 70658-71060 while the CDS runs 70595-72018 | |
| "an intron-spanning frame that reads open by chance" | true | 70658-71060 spans the first intron boundary at 70686 and ends inside the second intron, past 71039 | |
| The eight `gene` headers, `>OR51AB1P source=NG_000007:5265-6149 strand=+` through `>HBB source=NG_000007:70545-72152 strand=+` | true | Read from the produced `hbb-genes.lungfishref/genome/sequence.fa.gz`, all eight match character for character | |
| "with a `source=` token in 1-based coordinates and a `strand=` token" | true | `BundleCommand.swift:786` emits `source=\(chrom):\(record.start + 1)-\(record.end)` | |
| "The HBB line reads `70545-72152`, matching the record's own gene span exactly." | true | Both the header and the flatfile's gene feature read 70545..72152 | |
| "Asking for the `CDS` type instead gives five records" | true | Re-ran with `--feature-type CDS`, "Extracted features: 5" | |
| "because `BGLT3` is a long non-coding RNA and `HBBP1` is a pseudogene, so neither has one" | true | The flatfile carries 5 `CDS` features against 8 `gene` features, and the fixture README names those two as the pair without a CDS | |
| "The HBB CDS record comes out at 1,424 bases spanning 70595 to 72018." | true | The produced record measures 1424 bases and its header reads `source=NG_000007:70595-72018` | |
| "this command cuts a single interval from the first coordinate to the last" | true | 72018 - 70595 + 1 = 1424, the outer span, not the 444 spliced bases | |
| "extract the CDS feature from the annotation lane in the window, where the header reports `[exons concatenated]`" | false | The annotation right-click route builds `ExtractionRequest(source: .annotation(annotation))` with no arguments (`+Extraction.swift:101`, `:129`, `:157`, `:188`), and `concatenateExons` defaults to `false` (`SequenceExtractor.swift:40`). The `[exons concatenated]` token is only added when the flag is true (`:260`, `:381-383`), so the annotation route never emits it | "extract the CDS through **Sequence > Extract Visible Region...** with the feature framed, where Concatenate Exons (remove introns) is on by default and the header then reports `[exons concatenated]`" |
| "The HBB gene span opens `ACATTTGCTTCTGACACAACT`" | true | The live extraction's first line begins `ACATTTGCTTCTGACACAACTGTGTTCACTAGCAACCT...` | |
| "the coding stretch opens `ATGGTGCATCTGACTCCTGAGGAG`" | true | Present in the same first line at offset 44, and the record's `/translation` begins `MVHLTPEEK`, matching Met-Val-His-Leu-Thr-Pro-Glu | |
| "the `ATG` start followed by the codons for valine, histidine, leucine, threonine, proline, and then the `GAG` that the sickle cell change alters" | true | GTG=Val, CAT=His, CTG=Leu, ACT=Thr, CCT=Pro, GAG=Glu at codon 6, the rs334 site named in the fixture README | |
| "`extract sequence` needs FASTA input and rejects a GenBank flatfile" | true | Running it against `NG_000007.3.gb` returned "Error: Unsupported format: gb (extract requires FASTA input)" | |
| "Its region argument is `name:start-end`, counted 1-based and inclusive." | true | `extract.txt:26-28`, "1-based, inclusive coordinates, matching samtools faidx convention" | |
| "On a file holding one sequence you may leave the name off." | true | `extract.txt:30-32` | |
| "`--line-width` sets the FASTA wrapping and defaults to 70." | true | `extract.txt:55-56` | |
| "`--flank` pads both sides by the same amount, while `--flank-5` and `--flank-3` pad the upstream and downstream sides separately." | true | `extract.txt:50-54` | |
| "`--reverse-complement` flips the result and adds `[reverse complement]` to the header." | true | `extract.txt:49`; `SequenceExtractor.swift:377-379` | |
| "Output goes to standard output unless `-o` names a file." | true | `extract.txt:55`, "Output file path (default: stdout)" | |
| "`extract contigs` pulls named contigs out of an assembly, taking `--assembly` or `--contigs` for the source, `--contig` repeated once per name, and `--bundle` to write a `.lungfishref` into the project" | true | `extract.txt:169-186`. The chapter omits `--contig-file`, `--bundle-name`, `--project-root`, and the fact that `extract contigs` defaults `--line-width` to 60 rather than 70 | Consider naming `--contig-file` and the 60-column default, since the reader will otherwise assume the 70 quoted a paragraph earlier. |
| "`extract reads` pulls reads rather than sequence" | true | `extract.txt:18-20` | |
| "`bundle extract-annotations` needs `--bundle`, `--track`, and `--output-bundle`." | true | `bundle.txt:113-121`, all three in the required-usage line | |
| "`--track` accepts either the track ID or the display name, so `imported_annotations` and `\"Imported Annotations\"` both work." | true | `bundle.txt:120`, "Annotation track id or name"; re-ran with `--track "Imported Annotations"` and it resolved to the same track | |
| "`--feature-type` picks which features to cut and defaults to `gene`" | true | `bundle.txt:123-125`, "(default: gene)" | |
| "so pass `CDS` or `ORF` when you want those instead" | unverifiable for `ORF` | `CDS` was confirmed by the live run. Whether the literal string `ORF` matches an `annotate-orfs` track's rows was not tested, and the ORF track stores its type in a BED column rather than a GFF3 type field | Run `bundle extract-annotations --track hbb_orfs --feature-type ORF` against the scratch bundle and record the count. |
| "`--name-prefix` keeps only features whose name starts with a string, which is a prefix match and not an exact one, so `--name-prefix HBB` on this record returns two records rather than one, `HBB` and `HBBP1`." | true | Re-ran it, "Extracted features: 2", and the produced bundle holds `>HBBP1` and `>HBB` | The help says "whose name **or gene name** starts with this prefix" (`bundle.txt:126-128`), which the chapter's shorter phrasing drops. |
| "`--replace` overwrites an existing output bundle instead of stopping." | true | `bundle.txt:129`, "Replace an existing output bundle" | |
| "Minus-strand features come out reverse-complemented so every record reads in its coding orientation." | true | `BundleCommand.swift:781-783` | |
| "`sequence annotate-orfs` scopes its scan with `--sequence`, which defaults to the first sequence in the bundle, plus `--start` and `--end`, which default to the whole sequence." | true | `sequence.txt:27-30` | |
| "Those two are 0-based with the start inclusive and the end exclusive, which is why the block above passes 70544 for a gene starting at 70545." | true | `sequence.txt:28-30`, "0-based inclusive start" and "0-based exclusive end". The stored ORF row's attributes read `range_start=70544;range_end=72152`, confirming the scratch run used those bounds | |
| "The window's controls map to `--frames`, `--table`, `--min-length`, `--include-partial`, `--allow-alternative-starts`, `--track-name`, and `--track-id`" | true | `makeRequest()` (`SequenceORFOperationDialog.swift:97-114`) passes exactly those seven fields; all seven appear in `sequence.txt:31-42` | |
| "`sequence delete-annotation-track` removes a whole track by `--track-id`, and `sequence delete-annotations` removes individual rows from one, taking `--track-id` plus one or more `--row-id` values." | true | `sequence.txt:88-97` and `:61-72` | |
| "Nothing in this chapter needs an external tool, a plugin pack, an internet connection, or Docker." | unverifiable | The extraction bundle build shells out to managed conda binaries. The scratch bundle's sidecar records `/Users/dho/.lungfish/conda/envs/htslib/bin/bgzip` and `/Users/dho/.lungfish/conda/envs/samtools/bin/samtools faidx` as steps 2 and 3 of the extract-annotations run | Determine whether the GUI's Create Bundle path also needs bgzip and samtools, and if so say the bundle destination needs the managed tools while the clipboard destination does not. |
| "Every extraction here finishes in under a second" | unverifiable | The scratch runs all report identical start and end timestamps to the second, which is consistent but not a measurement | Time a GUI run, or read `wallTimeSeconds` from a GUI-produced sidecar. |
| "the whole chapter takes about twenty-five minutes at the keyboard" | unverifiable | An editorial estimate, not checkable against the app | |
| "Click an ORF to jump to it, and right-click it to copy or extract it through the routes above." | unverifiable | The right-click routes are confirmed generic to annotation features (`SequenceViewerView+Interaction.swift:964-1013`), but whether an `orf`-typed BED track renders clickable feature blocks in the annotation lane was not read | Open the scratch bundle in the app and click an ORF block, or read the annotation-lane hit-testing path for BED-backed tracks. |

## Front matter

`parameters_refs` is `[]`. Both registry ids now exist, so it should read
`parameters_refs: [sequence.find-orfs, sequence.extract-region]`. Once it
does, the chapter owes a Settings entry per setting of both, which means
adding 5' Flank, 3' Flank, Reverse Complement, and Concatenate Exons
(remove introns) alongside the Destination and Name entries it already has
in prose, and keeping the seven Find ORFs entries it already writes.

`shots` lists five ids and the body carries five `<!-- SHOT: -->` markers,
matching one to one, each with a caption. Three ids are shared by design,
`hbb-record-in-sequence-viewport`, `go-to-location-hbb-codon`, and
`hbb-annotation-context-menu`, all of which also appear in
`02-sequences/01-importing-and-viewing.md`, and the first two in
`01-foundations/01-what-is-a-genome.md` as well.

Two captions describe the wrong sheet. The `extract-region-dialog` caption
promises "its count of selected records, its four destination choices, the
Name field, and the Create Bundle button", none of which the sheet at that
marker has. Either repoint the marker at the annotation route or rewrite the
caption around the Action picker, the flank fields, and the Extract button.
The `find-orfs-dialog` caption is accurate.

All sixteen `glossary_refs` anchors resolve in `GLOSSARY.md`, checked one by
one.

`tools: []` and `features_refs: []` are consistent with a chapter whose
operations are built in. `fixtures_refs: [hbb-gene]` matches the fixture the
chapter uses.

The Next link points at `04-msa-and-trees.md`, which still exists, though
`04-aligning-sequences.md` now sits beside it. The project manager repoints
this at the gate.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues.

## Verdict counts

True 90, false 13, unverifiable 6.

The four qualified verdicts count with their base category. "true (of the
annotation route only)" and "false in part" and "false (omission)" and
"unverifiable for `ORF`" are counted as true, false, false, and
unverifiable respectively.
