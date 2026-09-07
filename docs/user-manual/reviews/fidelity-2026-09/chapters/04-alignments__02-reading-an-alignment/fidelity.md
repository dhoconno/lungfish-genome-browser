# Fidelity review, 04-alignments/02-reading-an-alignment

Reviewed 2026-09-07 against Preview 2026.9.13 sources, `parameters.yaml`,
the `cli-help` tree, and live runs of `.build/debug/lungfish-cli` and the
managed `samtools` (`~/.lungfish/conda/envs/samtools/bin/samtools`, v1.24)
against copies of `docs/user-manual/fixtures/hg002-chr20/expected/mapping/`
under the session scratchpad. Nothing was written into the fixture folder or
into `~/Desktop/lge-docs`.

The chapter is in far better shape than the one the drift report describes.
Every one of the 13 false claims in DRIFT Part A is gone, all 6 changed
claims are corrected, and 15 of the 17 missing features are covered. The
registry coverage is complete: all 16 `bam.read-display` settings and both
`bam.extract-reads-in-region` settings have a Settings paragraph with the
right label, default, and allowed values.

Four claims are false, and three of them are new errors the author
introduced rather than survivals from the old chapter. Two of those three
trace to the same trap, which is that `ReadTrackRenderer` carries two
`drawCoverage` overloads and the richer one is dead code. The reads-based
overload at `ReadTrackRenderer.swift:298` draws a strand-split band and a
bare `max: Nx` label, and it has no call site outside its own file and the
test target. Both live render paths
(`SequenceViewerView+Rendering.swift:384` and `:729`) call the
`depthPoints` overload at `:406`, which draws a single-colour area and
always prints `max: Nx  mean: N.Nx` together. The ground-truth map's own
claim 3 cites the dead path, so the map led the author here.

## Claims

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "A position ruler runs along the top, marking where you are on the reference in bases. Under the ruler sits a coverage curve... Under that the reads themselves stack up" | true | `SequenceViewerView+Rendering.swift:377-392` places the coverage rect above the read rows; `:718-745` draws sequence, coverage, then read tiers. Ground-truth claim 1. | (none) |
| "Zoomed far out it draws only the coverage curve... Zoomed in a little it draws the reads as plain bars. Zoomed all the way in it draws the individual base letters" | true | `ReadViewportPolicy.swift:7-14` returns `.coverage` above 2.0 bp/px, `.packed` above 0.6, `.base` below. | (none) |
| "Above roughly 2 bases per pixel the read rows are replaced by a message, "Zoom in to view individual mapped reads (<= 2.0 bp/px)", with the current zoom printed underneath it." | true | `ReadViewportPolicy.swift:4` `coverageThresholdBpPerPx = 2.0`; `SequenceViewerView+AnnotationRendering.swift:926-927` builds that exact message plus `"Current zoom: N.N bp/px"`. | (none) |
| "Reads are tinted by strand, pale blue for a read that aligned as sequenced and pale pink for one that aligned as its reverse complement" | true | `ReadStyleSection.swift:118` forward default `(0.69, 0.77, 0.87)` pale blue, `:121` reverse `(0.87, 0.69, 0.69)` pale pink; toggle at `:1988`. | (none) |
| "the coverage curve is split the same way into a forward band and a reverse band stacked together" | **false** | The live coverage path takes `[CoveragePoint]`, and `CoveragePoint` (`ReadTrackRenderer.swift:154-162`) carries only `position` and `depth`, with no strand field. `drawCoverage(depthPoints:)` at `:406-500` fills with `forwardCoverageColor` alone (`:451`, `:477`) and never touches `reverseCoverageColor`. The strand-split fill at `:346-359` lives in `drawCoverage(reads:)`, whose only callers are `ReadTrackRendererTests.swift:436, 504, 547, 1410`. | "and the coverage curve underneath is a single band, the total depth at each position, whichever strand the reads came from" |
| "Read ends the mapper set aside are drawn lightened rather than hidden." | true | `ReadTrackRenderer.swift:93` `softClipColor` at alpha 0.6, filled at a further `alpha * 0.5` at `:1926` and `:1938`. | (none) |
| "Choose **File > New Project** (Cmd-N)" | true | `MainMenu.swift` File menu; consistent with the campaign's other chapters. | (none) |
| "Choose **File > Import Center...** (Cmd-Shift-I) and pick a BAM, CRAM, or SAM file." | true | `MainMenu.swift:207-213` adds "Import Center…" with `keyEquivalent: "i"` and `[.command, .shift]`. `DocumentManager.swift:131` and `AppFilePanelFactory.swift:107` both list `["bam", "cram", "sam"]`. Corrects DRIFT false claim 7. | (none) |
| "A SAM file is converted to a sorted, indexed BAM on the way in" | true | `BAMImportService.swift:341, 371-390`, "Normalize SAM input to BAM for indexed random access." | (none) |
| "A CRAM file needs a matching reference FASTA already in the bundle" | true | `BAMImportService.swift:399` guards `sourceFormat == .cram && referenceFasta == nil`. | (none) |
| "LGE reads alignments by running the `samtools` program for every region you look at, rather than by opening the BAM itself." | true | `AlignmentDataProvider.swift:1` header comment; `:343-345` "Provides read alignment data by shelling out to samtools for region queries"; `:461` runs `samtools view` per fetch. | (none) |
| "That program comes from the Required Setup pack" | true | `third-party-tools-lock.json` `tools` includes `samtools`; `PluginPack.swift:431` gives the lock pack `category: "Required Setup"`. | (none) |
| "If the pack has never been installed, the viewport shows an empty pileup rather than an error" | true | `AlignmentDataProvider.fetchReads` throws `samtoolsFailed` (`:465-467`), but the only caller catches and logs without surfacing (`SequenceViewerView+Alignment.swift:740-742`), so the read cache stays empty. | (none) |
| "check the Plugin Manager under **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:774-779`, title "Plugin Manager…", `keyEquivalent: "b"`, `[.command, .shift]`. | (none) |
| Step 1: "Click the "minimap2 Mapping" track in the sidebar" | true | `AppDelegate+ToolsMenu.swift:1390, 1504, 1574` name the track `"\(tool.displayName) Mapping"`; `MappingTool.swift:15-22` gives minimap2 the display name "minimap2". | (none) |
| "The mapping run's own folder sits under the project's `Analyses/`." | true | `AnalysesFolder.swift:24-28` `knownTools` includes `minimap2`; `createAnalysisDirectory` writes `Analyses/<tool>-<timestamp>/`. | (none) |
| Step 2: "Hover any point for a tooltip reading `Depth`, then the position, then the depth as `Depth: 47x`." | true | `SequenceViewerView+Tooltips.swift:139` builds `"Depth\n<chrom>:<pos>\nDepth: <n>x"`. The `47x` is an illustrative value, consistent with the fixture's 44.7x mean. | (none) |
| Step 2: "At the right-hand edge of the coverage strip LGE prints the deepest column in view as a label reading `max: 79x`. Once you zoom in far enough for the reads to appear, that label gains the average as well, reading `max: 79x  mean: 44.7x`." | **false** | The live path always draws both figures together. `ReadTrackRenderer.swift:490` builds `"max: \(maxDepth)x  mean: \(...)x"` inside `drawCoverage(depthPoints:)`, the overload both call sites use. The bare `max: Nx` at `:390` is in the dead reads-based overload. The label is also not alone at that edge: `:486-487` draws a `Depth` legend key at the left and `:496-500` a `N% covered` detail beside it. Max depth 79 and mean 44.7 are correct for the fixture (measured: `samtools depth -a` max 79 at position 13,097, mean 44.72). | "At the right-hand edge of the coverage strip LGE prints both the deepest column in view and the average across it, as a label reading `max: 79x  mean: 44.7x`. A `Depth` key sits at the left-hand edge with the percentage of the window that carries any read beside it." |
| Step 2: "The status bar... reports your position, your current selection, and the scale in bases per pixel. It does not report depth" | true | `ViewerStatusBar.swift:88-92` sets exactly `positionLabel`, `selectionLabel`, and `String(format: "%.1f bp/px", scale)`. Corrects DRIFT changed claim 15. | (none) |
| Step 3: "**Sequence > Go to Location...** (Cmd-L)" and "**Sequence > Go to Gene...** (Cmd-Option-G)" | true | `MainMenu.swift:642-646` and `:648-655`, with `keyEquivalentModifierMask = [.command, .option]` on Go to Gene. Corrects DRIFT false claim 16. | (none) |
| Step 3: "right-click the spot and choose **Center View Here**" | true | `SequenceViewerView+Interaction.swift:1082`, added to both menus at `:681` and `:735`. | (none) |
| Step 3: "press `Cmd-=` to zoom in and `Cmd--` to zoom out, which are the same two commands as **Zoom In** and **Zoom Out** in the View menu" | true | `ZoomShortcutHandler.swift:28-57`; `MainMenu.swift:541-551`. | (none) |
| Step 3: "The Up and Down arrow keys zoom as well... while Left and Right pan, and on a trackpad pinching zooms." | true | `SequenceViewerView+Interaction.swift:361-364` (126 zoom in, 125 zoom out), `:351-360` (123/124 pan), `:1723-1724` `magnify(with:)`. | (none) |
| Step 3: "**Zoom to Fit** (Cmd-0)... and **Zoom Reset (10kb)** (Cmd-1)" | true | `MainMenu.swift:553-557` and `:559-563`. Closes the DRIFT missing-feature row for Zoom Reset. | (none) |
| Step 4: "By default a read base that agrees with the reference is drawn as a small dot and one that disagrees is drawn as a coloured letter" | true | `ReadStyleSection.swift:40` `showMismatches = true`; `:1964` toggle "Show matching bases as dots" with help text "matching bases are shown as dots and mismatches as colored letters". Corrects DRIFT changed claim 24. | (none) |
| Step 4: "The four bases have fixed colours in both rows, A green, T red, G yellow, and C blue." | true | `BaseColors.swift:13, 15, 17, 19`. | (none) |
| Step 4: "Before you click anything it reads "Select a read in the viewer to inspect it here."" | true | `ReadStyleSection.swift:1511`, verbatim. | (none) |
| Step 6: "choose **Extract Reads in Selected Region...**" | true | `SequenceViewerView+Interaction.swift:726-732`, title "Extract Reads in Selected Region…", gated on `explicitAlignmentSelection != nil`. | (none) |
| Step 6: "LGE asks where to save, then writes every read overlapping that stretch into a `.lungfishfastq` bundle in the project's `Extractions/` folder." | **false** | Two errors. (1) The save panel appears only for `.userSelectedDestination` (`ViewerViewController+Mapping.swift:820-830`), and an alignment track inside a project always resolves to `.projectDerivedRoot` (`ReferenceBundleViewportController.swift:1552-1557` for a mapping result, `:1594` for a direct bundle), so no panel opens in the chapter's own scenario. (2) The derived path is `<root>/alignment-read-extractions/selected-region-<UUID>.lungfishfastq` (`AlignmentScientificActionCoordinator.swift:41-45`), and `AlignmentReadExtractionPublisher.swift:92` writes to `destination.finalURL` verbatim with no relocation. `Extractions/` is `ClassifierReadResolver.swift:73`, used by the classifier extraction path, not this one. For a mapping result the root is the run directory, so the bundle lands under `Analyses/<run>/alignment-read-extractions/`. | "LGE writes every read overlapping that stretch into a `.lungfishfastq` bundle named `selected-region`, in an `alignment-read-extractions` folder beside the alignment it came from. Watch the Operations panel for the row titled Extract Reads in Selected Region." (The `Extractions/` sentence that follows should go, or move to the classifier extraction chapter that owns that folder.) |
| Step 6: "right-click the selected read and choose **Copy as FASTA (aligned orientation)**... or **Extract Reads... (original reads)**" | true | `ReadSelectionActionMenuBuilder.swift:70` and `:78`, exactly two items with those titles. Corrects DRIFT false claim 27. | (none) |
| "Right-clicking the alignment track itself offers **Show Alignment File in Finder**, which reveals the BAM on disk." | **false** | `SequenceViewerView+Interaction.swift:938` `alignmentRevealTitle(for:)` returns `"Show BAM in Finder"` when the extension is `bam` and `"Show Alignment File in Finder"` otherwise. This chapter's fixture is a BAM, so the reader sees the title the chapter does not name. The generic title is right only for CRAM and SAM, and for the multi-track submenu's own title (`:892`). | "Right-clicking the alignment track itself offers **Show BAM in Finder**, which reveals the file on disk. On a CRAM or SAM track the item reads **Show Alignment File in Finder** instead." |
| "When the bundle carries several alignment tracks the item becomes a submenu, one entry per track." | true | `SequenceViewerView+Interaction.swift:882-905`, `entries.count > 1` branch builds a submenu titled "Show Alignment File in Finder" with one item per entry. | (none) |
| "LGE quietly skips any record whose stored sequence is empty and reports the number it skipped in the status bar rather than failing the copy." | true | `SequenceViewerView+Interaction.swift:859-880`, doc comment "empty/`"*"` SEQ... reports the skip count via the status bar rather than a blocking alert". | (none) |
| Settings lead-in: "They live in the Inspector under **View Settings**, which is split into three tabs. The Alignment tab... The Reads tab... The Annotations tab" | true | `InspectorView.swift:247` renders the "View Settings" title; `ReadStyleViewSubsection` (`ReadStyleSection.swift:1006-1023`) has exactly `alignment`, `annotations`, `reads` with those display titles; `InspectorView.swift:258` grids them. | (none) |
| "None of them changes the BAM on disk, and none of them has a command-line flag" | true | Every `bam.read-display` setting in `parameters.yaml:3148-3260` carries `cli_flag: null`, and `cli_only` is empty. | (none) |
| **Visible Alignment.** "defaults to All Alignments", "stacks every alignment track in the bundle at once or shows one at a time" | true | `ReadStyleSection.swift:1664-1668`, picker with an "All Alignments" tag plus one per track; `:1651` lead-in text. Registry default "All Alignments". | (none) |
| **Show reads.** "It is on by default" | true | `ReadStyleSection.swift:111` `showReads = true`; toggle at `:1680`. | (none) |
| **Minimum alignment confidence.** "It defaults to 0" and hides below-threshold reads "in the viewport only" | true | `ReadStyleSection.swift:96` `minMapQ = 0`; `:1685-1689` `NumericSliderField` bounded `0...60`, matching the registry's "0 to 60". | (none) |
| "87,755 of the 90,935 placed reads carry the maximum score of 60 and only 165 fall below 30" | true | Measured: `samtools view -F 0x904` over the fixture BAM gives 90,935 primary mapped records, 87,755 at MAPQ 60, 165 below 30. | (none) |
| **Coverage scale.** "It defaults to Linear", "Switch to Log10 or Square root", "A compressed axis is labelled as such" | true | `CoverageScaleMode.swift:14-17` the three cases, `:21` `default = .linear`, `:23-28` display names "Linear", "Log10", "Square root", `:32-38` `axisLabel` returns `log₁₀` and `√` and nil for linear. Rendered at `ReadTrackRenderer.swift:487` as `Depth (log₁₀)`. | (none) |
| **Include duplicate-marked reads.** / **secondary** / **supplementary.** "It is off by default" (all three) | true | `ReadStyleSection.swift:99, 102, 105` all `= false`; toggles at `:1710`, `:1716`, `:1722` under the "Read Inclusion" heading at `:1707`. | (none) |
| "on this fixture there are none to show, because the mapping run excluded them" | true | `samtools flagstat` reports `0 + 0 secondary`. | (none) |
| "This fixture carries 55 supplementary records against 91,148 primary ones" | true | `samtools flagstat`: `91148 + 0 primary`, `55 + 0 supplementary`. | (none) |
| **Limit visible rows.** "It is off by default, and the control's own help text explains why, that leaving it off "keeps all mapped reads in the active view and enables stable vertical scrolling"." | true | `ReadStyleSection.swift:27` `limitReadRows = false`; `:1941` help text verbatim ("Off keeps all mapped reads..."). | (none) |
| **Read display budget.** "It defaults to 50,000", "raise it toward its ceiling of 500,000" | true | `ReadStyleSection.swift:32` binds `ReadViewportPolicy.defaultVisibleReadBudget`, which is `50_000` (`ReadViewportPolicy.swift:31`); slider range `5_000...500_000` step `5_000` at `:1943-1949`, matching the registry. | (none) |
| "This fixture never reaches the budget, since the whole 500 kb slice holds 91,148 reads in total." | true | 91,148 primary records, but the budget is per fetch window, and a 500 kb window at 50,000 would sample. The claim is about the whole slice's total, which is 91,148, so it is loose but not false: at the coverage tier no reads are drawn at all, and any window small enough to draw reads holds far fewer than 50,000. | (none) |
| **Use compact row height.** "It is on by default" | true | `ReadStyleSection.swift:35` `verticallyCompressContig = true`; toggle at `:1956`. | (none) |
| **Show matching bases as dots.** "It is on by default" | true | `ReadStyleSection.swift:40` `showMismatches = true`. | (none) |
| **Show soft-clipped sequence.** "It is on by default" | true | `ReadStyleSection.swift:62` `showSoftClips = true`; toggle at `:1976`. | (none) |
| **Show insertion and deletion markers.** "It is on by default" | true | `ReadStyleSection.swift:65` `showIndels = true`; toggle at `:1981`. | (none) |
| **Color reads by strand.** "It is on by default", "Turn it off, and every read is drawn a neutral grey" | true | `ReadStyleSection.swift:115` `showStrandColors = true`; `:1993` help text "When off, all reads have a neutral gray background". | (none) |
| **Forward strand color.** "It defaults to a pale blue" / **Reverse strand color.** "It defaults to a pale pink" | true | `ReadStyleSection.swift:118` and `:121`; `ColorPicker` wells at `:1999-2006` and `:2008-2015`. Closes DRIFT false claim 4's replacement. | (none) |
| "**(the selected region).**... the menu item stays hidden until you have dragged out a selection... On the command line this is `--region`." | true | Menu item gated on `explicitAlignmentSelection != nil` (`SequenceViewerView+Interaction.swift:725`); `extract.txt` `extract reads` lists `--region <region>  Genomic region to extract (repeatable, for --by-region)`. Matches the registry. | (none) |
| "**(the save destination).** ... It defaults to a bundle named `selected-region`... Change it in the save panel that opens when you pick the menu item" | **false** (same defect as step 6) | The base name `selected-region` is right (`ViewerViewController+Mapping.swift:60, 66`), but the folder and the save panel are not. See the step 6 row. The registry entry `bam.extract-reads-in-region` carries the same two errors in its `default` field and its `notes`, so this is a registry defect the chapter inherited rather than a chapter-only slip. | Replace the default with "a bundle named `selected-region` in an `alignment-read-extractions` folder beside the alignment", and drop "Change it in the save panel". The registry entry needs the same correction. |
| "If the extraction cannot run, LGE shows an alert titled "Extract Selected Region Failed"... most often that the selection was empty." | true | `ViewerViewController+Mapping.swift:46, 50, 71` all use that title; `:50` carries "Select a non-empty region first." | (none) |
| "Mean depth across the 500 kb slice is 44.7x, the deepest single column reaches 79x, and 99.99% of the slice carries at least one read." | true | Measured: `samtools coverage` gives `meandepth 44.7234`, `coverage 99.9938`; `samtools depth -a` gives max 79. | (none) |
| "Only 505 of the 500,001 positions fall below 10x, and only 31 positions carry no reads at all." | true | Measured with `samtools depth -a` plus an awk pass: 500,001 positions, 505 below 10, 31 at zero. | (none) |
| "roughly ten is the point below which a single sequencing error can outvote the truth in the column" | true (as framed) | A domain heuristic, not an app claim. DRIFT row 30 flagged the old wording as unverifiable. The chapter now states the reasoning in the same sentence and attaches it to the measured 505 figure, which is the settlement CONSISTENCY.md:95-97 asks for. | (none) |
| "Fifty-one reads cover the position. All fifty-one carry an A where the reference carries a G... Twenty-four of those reads run forward and twenty-seven run reverse" | true | Reproduced: `samtools mpileup -r chr20_10.0-10.5Mb:2078-2078` returns depth 51, reference `G`, pileup string of 24 uppercase `A` and 27 lowercase `a`. Matches the fixture README's `DP4=0,0,24,27` and `AD 0,51` at line 119. | (none) |
| "a difference from the reference that the independent benchmark for this genome also records" | true | `docs/user-manual/fixtures/hg002-chr20/README.md:119` records the position with genotype `1/1`, and the benchmark VCF ships in the fixture. | (none) |
| "a banner over the track reading "Showing 50,000 of 620,000 reads in view · depth, coverage and consensus use all reads", with a **Load all** button beside it. Pressing it lifts the budget for that window up to a ceiling of two million reads." | true | `ReadBudgetState.swift:44-51` builds that exact string including the `\u{00B7}` separator; `:54` `loadAllActionTitle = "Load all"`; `ReadViewportPolicy.swift:36` `loadAllReadCeiling = 2_000_000`. Corrects DRIFT false claims 28 and 29. | (none) |
| "the sample is a fixed stride through the reads rather than a random draw, which means the same reads appear every time you redraw" | true | `ReadViewportPolicy.swift:43-47` doc comment and `sampleReads` at `:48-61`, `index * reads.count / budget`. | (none) |
| "a badge reads "Loading mapped reads… " with a running count, then "Packing N reads…", with "(esc to cancel)" on the end." | true | `ReadBudgetState.swift:88-97` builds both messages; `:100` `cancelHint = "  (esc to cancel)"`. | (none) |
| "Pressing Escape during a load cancels it and leaves you on the coverage curve. Escape clears your selection the rest of the time" | true | `SequenceViewerView+Interaction.swift:377-386`, with the doc comment stating exactly that split. | (none) |
| "It reports the read's base qualities as three figures, Mean Q, a Range written as the lowest and highest scores seen, and the percentage of the read's bases at Q20 or better." | true | `ReadStyleSection.swift:1577-1583`, `statRow("Mean Q", ...)`, `statRow("Range", value: "Q\(minQ)-Q\(maxQ)")`, `statRow(">= Q20", ...)`. | (none) |
| "the panel lists the read's insertions... showing the first five with their positions and their inserted sequence and counting the rest" | true | `ReadStyleSection.swift:1585-1604`, `insertions.prefix(5)` then `"... and \(insertions.count - 5) more"`. | (none) |
| "The alignment summary at the top of the Inspector reports Total Mapped, Total Unmapped, Mapped %, the number of Chromosomes, and, for a single-contig reference like this one, Est. Coverage." | true | `ReadStyleSection.swift:1165-1191`, exactly those five rows with Est. Coverage gated on `chromosomeStats.count == 1`. Corrects DRIFT false claim 26. | (none) |
| "For this fixture those read 90,990, 213, 99.8%, 1, and 44.7x." | **false** (the last figure only) | The first four are right. `samtools flagstat` gives 90,990 mapped and 213 unmapped (91,203 total minus 90,990), so Mapped % computes to 90990/91203 = 99.766%, displayed as "99.8%" by `String(format: "%.1f%%")` at `ReadStyleSection.swift:1171`. But **Est. Coverage is not the mean depth**. `ReadStyleSection.swift:946-951` computes `mappedReads * 150.0 / length` with a hard-coded 150 bp assumed read length. For this fixture that is 90,990 x 150 / 500,001 = **27.3x**, not 44.7x. The reads are 248.7 bp on average (measured over the 90,935 primary mapped records), so the estimate undercounts by nearly half. 44.7x is the true mean depth from `samtools coverage`, which is what the coverage label reports, not what the Inspector's Est. Coverage shows. | "For this fixture those read 90,990, 213, 99.8%, 1, and 27.3x. Est. Coverage is an estimate rather than a measurement, since it assumes every read is 150 bases long, and this fixture's reads average about 249. The coverage curve's own `mean:` label reports the measured 44.7x instead, and that is the number to trust." |
| "a collapsed Flag Stats list holds the raw flagstat categories, including the primary and supplementary counts" | true | `ReadStyleSection.swift:1218-1236`; categories come from `samtools flagstat` (`AlignmentMetadataDatabase.swift:371-372`). | (none) |
| "A collapsed Provenance block below that holds the recorded command for each step... with a **Show command** button on each row and a note saying "Commands are collapsed by default."" | true | `ReadStyleSection.swift:1264` the note (whose full text continues "Click "Show command" to view the full invocation."), `:1297` and `:1356` the buttons. | (none) |
| "The Inspector's Analysis section... is a grid of six tabs showing one at a time. Filtering holds **Mark Duplicates in Bundle Tracks** and **Create Filtered Alignment**. Annotations holds **Convert Mapped Reads to Annotations**. Consensus holds **Extract Consensus...**. Primer Trim holds **Primer-trim BAM...**. Variant Calling holds **Call Variants...**. Export holds **Create Deduplicated Bundle**." | true | `AnalysisWorkflowSubsection` (`ReadStyleSection.swift:1025-1051`) the six cases and titles; `:2047-2062` the grid and the one-at-a-time switch; buttons at `:2124`, `:2264` (filtering), `:2404` (annotations), `:2530` (consensus), `:2565` (primerTrim), `:2592` (variantCalling), `:2612` (export). Every button falls in its stated tab's line range. Corrects DRIFT changed claims 31 and 32. | (none) |
| "Launching from the Inspector opens the dialog with an alignment track already chosen, which is the first eligible track in the bundle rather than necessarily the one you had selected." | unverifiable (as generalised) | Confirmed for the primer-trim dialog only: `BAMPrimerTrimDialogState.swift:33-38` documents "Auto-populated with the first eligible alignment track at init time". The chapter states it for the Analysis section as a whole, covering six dialogs. Settled by reading each dialog's state initialiser, chiefly `BAMVariantCallingDialogState.swift` and the filter and consensus panels, which belong to the 05-variants and 04-alignment-quality maps rather than this one. | (none) |
| "On this fixture 6,308 of the 90,935 placed reads carry a soft clip somewhere, about 7 percent" | true | Measured: a CIGAR grep for `S` over `samtools view -F 0x904` gives 6,308 of 90,935, which is 6.94%. | (none) |
| "At position 2,078 the split is 24 forward and 27 reverse" | true | Same mpileup as above. | (none) |
| CLI block: `lungfish-cli extract reads --by-region --bam HG002.sorted.bam --region chr20_10.0-10.5Mb --output hg002-chr20-reads.fastq` | true | Ran verbatim against a scratchpad copy of the fixture BAM. Exit 0. | (none) |
| "That run reports `Extracted 91148 reads from BAM` for this fixture, which is the primary read count" | true | The run printed `ℹ Extracted 91148 reads from BAM` verbatim, then `Reads extracted: 91148`. `samtools flagstat` gives `91148 + 0 primary`. | (none) |
| "`--exclude-unmapped` applies a stricter filter that drops unmapped reads as well as duplicates, where the default drops duplicates alone." | true | `extract.txt` `extract reads`: "Exclude unmapped reads (samtools -F 0x404 instead of -F 0x400) for --by-region". `0x400` is the duplicate flag, `0x404` adds unmapped. | (none) |
| "`--bundle` wraps the output in a `.lungfishfastq` bundle... and `--bundle-name` gives that bundle a display name and turns on `--bundle` by itself." | true | `extract.txt`: "--bundle  Wrap output in a .lungfishfastq bundle" and "--bundle-name  Custom bundle display name (implies --bundle)". | (none) |
| "`--format json` prints the run summary as JSON" | true | `extract.txt`: "--format  Output format: text, json, tsv (default: text)". | (none) |
| "In Preview 2026.9.13 the `--region` flag accepts only a bare reference sequence name. A region written in the usual `name:start-end` form is rejected with `No BAM reference names matched the requested regions`, so the command extracts a whole contig or nothing." | true | Reproduced both halves. `--region chr20_10.0-10.5Mb:2000-2200` exits 1 with `Error: No BAM reference names matched the requested regions: chr20_10.0-10.5Mb:2000-2200`; the bare name succeeds with 91,148 reads. Root cause is as the author describes: `BAMRegionMatcher.swift` parses bare `SN:` names (`readBAMReferences`, `:99-110`) and all three strategies compare the whole region string against them, `tryExact` by set membership (`:126`), `tryPrefix` by `bamRef.hasPrefix(region)` (`:147`), `tryContains` by `bamRef.contains(region)` (`:170`). A `name:start-end` string is longer than the name it starts with, so all three miss. `ReadExtractionService.swift:484-486` then throws `noMatchingRegions` because `config.fallbackToAll` is false on this path, and `ExtractionConfig.swift:703` formats the message. The author's note that `.fallbackAll` (`BAMRegionMatcher.swift:68-73`) would otherwise return every reference is also right, and `ReadExtractionService.swift:479-483` is the branch that would take it. | (none) |
| "Use the app's **Extract Reads in Selected Region...** when you need a coordinate range" | true | That path builds a `ResolvedAlignmentRegion` from the selection (`ViewerViewController+Mapping.swift:52`) and never passes a region string through `BAMRegionMatcher`. | (none) |
| "`samtools mpileup -f GRCh38.chr20.10.0-10.5Mb.fasta -r chr20_10.0-10.5Mb:2078-2078 HG002.sorted.bam`" | true | Ran verbatim against scratchpad copies. Returns the 51-read column quoted in the chapter. | (none) |

## Front matter

`parameters_refs: [bam.read-display, bam.extract-reads-in-region]` matches
roster row 23 at DRIFT.md line 3749 exactly.

Registry coverage is complete. All 16 `bam.read-display` settings
(`parameters.yaml:3148-3260`) have a Settings paragraph carrying the exact
label, the right default, and the right allowed values, in registry order.
Both `bam.extract-reads-in-region` settings (`:3093-3147`) have one too,
though the save-destination default is wrong in both the chapter and the
registry (see the table).

All five `<!-- SHOT -->` markers in the body have a caption in `shots`, and
`shots` lists no marker the body lacks. Two caption problems, both minor:

- `bam-viewport-overview` says "the max label at the right-hand edge". The
  label there is `max: Nx  mean: N.Nx`, and there is also a `Depth` key and
  a percent-covered figure at the left edge. Reword alongside the step 2 fix
  so the Scout frames and names the whole strip.
- `extract-reads-region-menu` says the item shows "beneath Copy Visible
  Region". Two items sit between them, Copy Visible Region as FASTA and
  Extract Visible Region… (`ViewerViewController+Extraction.swift:64-84`,
  called at `SequenceViewerView+Interaction.swift:724`). True as written but
  imprecise enough to misdirect the capture.

All 18 `glossary_refs` anchors resolve in `GLOSSARY.md`, each exactly once.
`Alignment track` appears exactly once, at line 23, and its entry makes no
claim about the identifier's shape, which is the right call given that the
chapter-22 map lists that shape as unverifiable. One unused ref: `read-group`
is declared but the term never appears in the body.

## Other findings

**Procedure step numbering.** The steps run 1, 2, 3, 4, 6. The author's fold
of two steps into one left the last marker at `6.` (line 86) where the
lead-in at line 72 ("The first four steps read the picture. The last one
pulls reads back out of it.") and the two body cross-references
("the extraction in step 6", lines 132 and 202) all expect five. Markdown
renumbers it to 5 on render, so the rendered text and the prose disagree.
Fix the source marker and the two cross-references together.

**A convention the chapter departs from.** CONSISTENCY.md:88-90 asks for
"This setting has no command-line flag." on each flagless setting. The
chapter instead states it once for the whole section ("none of them has a
command-line flag"), which reads better across sixteen paragraphs but is not
what the sheet specifies. Worth a ruling from the lead rather than a fix,
since applying the sheet literally would add sixteen identical sentences.

**A registry defect to route onward.** `bam.extract-reads-in-region` in
`parameters.yaml` carries the same two errors the chapter inherited, in the
save-destination `default` ("a file named selected-region in the project's
Extractions folder") and in `notes` ("asking only where to save",
"Extractions belong in the project's Extractions folder"). Correcting the
chapter without correcting the registry would leave the two out of step.

**The dead-code trap, for whoever reviews the rest of this part.**
`ReadTrackRenderer.drawCoverage(reads:)` and its strand-split fill and bare
`max: Nx` label are unreachable from the app. Chapter 04-alignment-quality's
map cites the same renderer for its coverage-histogram claims, so the same
trap is waiting there. The reachable path is `drawCoverage(depthPoints:)` at
`ReadTrackRenderer.swift:406`, and `CoveragePoint` has no strand field.

## Verdict count

**True 62, false 4, unverifiable 1.**
