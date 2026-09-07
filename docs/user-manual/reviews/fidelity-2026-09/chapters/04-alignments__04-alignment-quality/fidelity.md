# Fidelity review: 04-alignments/04-alignment-quality

Reviewer: manual-fidelity-reviewer. Date: 2026-09-07.
Chapter: `docs/user-manual/chapters/04-alignments/04-alignment-quality.md`.
Registry ids: `bam.mark-duplicates`, `bam.filter`. Fixture: `hg002-chr20`.

Ground truth used, in campaign order. Swift source under `Sources/`, the CLI
binary `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
the `cli-help/` dumps, `docs/user-manual/parameters.yaml`, and direct measurement
with `~/.lungfish/conda/envs/samtools/bin/samtools` on copies of
`docs/user-manual/fixtures/hg002-chr20/expected/mapping/`. All writes went to the
session scratchpad under `.../scratchpad/alignment-quality/verify/`. Nothing was
written into the repository or into `~/Desktop/lge-docs`.

## Headline

The chapter's arithmetic is outstanding. Every flagstat count, every filter
count, every depth measurement, and every CLI output line reproduced exactly on
a fresh run, including the 89,107-record filter result and its four-way drop
breakdown. The author's independent verification was sound.

Three claims are false, and one of them is serious.

The serious one is **Est. Coverage of 44.7x**. `Est. Coverage` is not mean depth.
`ChromosomeReadStat.estimatedCoverage` is `mappedReads * 150 / length`
(`ReadStyleSection.swift:948-950`), which on this fixture is
`90990 * 150 / 500001 = 27.30`, displayed as **27.3x**. The reads are ~250 bp,
not 150, so the row understates the true depth by roughly two fifths. 44.7234 is
`meanDepth` from `mapping-result.json`, a different quantity. This is not a
subtle drift: the committed sibling chapter
`01-mapping-reads-to-a-reference.md:154-156, 193` already documents the row as
27.3x, names the 150-base assumption, and calls it "a defect in this release".
Chapter 04 as written contradicts chapter 01 on the same fixture in the same
part. The claim recurs in four places (procedure step 2, Reading the results,
and twice in What good looks like) and each needs the same correction.

The second is the **bundle operation lock**. `runMarkDuplicatesWorkflow`
(`InspectorViewController+TrimDuplicateWorkflows.swift:615-683`) has no
`canStartOperation` guard and starts no `OperationCenter` operation.
`runCreateDeduplicatedBundleWorkflow` (`:686-753`) likewise. The lock the reality
map cites at `:88-96` belongs to the primer-trim path, and the filtered-alignment
path has its own at `:563-573`. So a duplicate-marking run neither refuses to
start while the bundle is busy nor carries a row in the Operations panel.

The third is the **Name for New Alignment** field, which the chapter twice says
starts empty with no default. It auto-populates. Selecting a source track fires
`refreshAlignmentFilterOutputTrackNameIfNeeded` through the `didSet` on
`selectedAlignmentFilterSourceTrackID` (`ReadStyleSection.swift:197-201`), and
`configureAlignmentFilterTracks` sets that selection to the first track on load
(`:597-598`). With the shipped defaults the field reads "Mapped primary
alignments".

I also disagree with the author on defect claim 1. `removeAlignmentTracks`
(`AlignmentDuplicateService.swift:230-254`) deletes the source BAM, its index,
and its metadata DB from disk for any track living inside the bundle. The
confirmation sheet's "replace existing tracks" wording is accurate and there is
no disk leak. Defect claim 2 is correct and well stated.

## Claims

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "LGE runs `samtools markdup` for this, which finds records sharing a start and end position and flags all but one of each set." | true | `AlignmentMarkdupPipeline.swift:355-363` runs `samtools markdup`. Confirmed on the fixture: 1,684 records gained the duplicate flag with the total unchanged. | (none) |
| "A MAPQ of 60 is the usual maximum" | true | Fixture's maximum observed MAPQ is 60, carried by 87,759 of 91,203 records. Consistent with `MappingWizardSheet.swift:756` bounding its stepper `0...60`. | (none) |
| "LGE reports an average of that figure in the Inspector" | false | The Inspector's Est. Coverage is `mappedReads * 150 / length` (`ReadStyleSection.swift:948-950`), an estimate from an assumed 150-base read length, not an average of measured per-position depth. On 250-base reads it is not the average depth. | "LGE reports an estimate of that figure in the Inspector, worked out from an assumed read length rather than measured position by position" |
| "draws the per-position curve above the read stack in the alignment viewport" | true | `SequenceViewerView+Rendering.swift:384` and `:729` both call `ReadTrackRenderer.drawCoverage`, and the depth-point overload at `ReadTrackRenderer.swift:406` is reachable from the live viewport. | (none) |
| "You need a project open ... choose **File > New Project** (Cmd-N)" | unverifiable | Not re-derived in this review, and outside the two registry ids. Settled by reading the File menu construction in `MainMenu.swift`. | (none) |
| "LGE holds a lock on a bundle while an operation is working on it, so if a mapping or trimming run is still going, a duplicate-marking run refuses to start and an alert names the operation that is holding the bundle." | false | `runMarkDuplicatesWorkflow` (`InspectorViewController+TrimDuplicateWorkflows.swift:615-683`) has no `canStartOperation` check. The guard exists for primer trim (`:34-41`, `:89-96`) and for the filtered-alignment workflow (`:563-573`), not for duplicate marking or for Create Deduplicated Bundle (`:686-753`). | Either drop the paragraph, or move it to the Derive a filtered alignment step, where the guard is real and does present an "Operation in Progress" alert naming the holder. |
| "Wait for the row in the Operations panel to finish." (of a duplicate-marking run) | false | Neither duplicate workflow calls `OperationCenter.shared.start`, so no row appears. The filtered-alignment workflow does (`:594-600`, title "Create Filtered Alignment Track"). | Applies to the filter run, not to duplicate marking. |
| "the Inspector's Bundle tab fills with the alignment summary" | true | `InspectorView.swift:105-110` renders `AlignmentBundleSection` under `case .bundle` when `hasAlignmentTracks`. Tab label "Bundle" at `:228`. | (none) |
| "**Total Mapped** counts alignment records placed on the reference, **Total Unmapped** ... **Mapped %** ... **Chromosomes** ... and **Est. Coverage**" (five labels, that order) | true | `ReadStyleSection.swift:1165-1192` renders exactly `Total Mapped`, `Total Unmapped`, `Mapped %`, `Chromosomes`, `Est. Coverage` in that order. | (none) |
| "On the HG002 slice these read 90,990, 213, 99.8%, 1, and 44.7x." | false | The first four are right. Est. Coverage is 27.3x, not 44.7x. `estimatedCoverage = 90990 * 150 / 500001 = 27.2969`, formatted `%.1fx`. The stats DB for the fixture track stores `chr20_10.0-10.5Mb|500001|90990|213`. 44.7234 is `meanDepth` in `mapping-result.json`, a different measurement. Chapter 01 already publishes 27.3x for this row. | "On the HG002 slice these read 90,990, 213, 99.8%, 1, and 27.3x. The true mean depth is 44.7x. Est. Coverage assumes a 150-base read, and this fixture's reads are about 250 bases, so the row understates the real depth here." |
| "**Est. Coverage** appears only when the alignment covers a single contig. A multi-contig reference ... shows no depth figure here at all" | true | `ReadStyleSection.swift:1189-1192` guards the row on `chromosomeStats.count == 1`. | (none) |
| "Expand the **Flag Statistics** list below the five figures." | true | `ReadStyleSection.swift:1099-1106` renders `DisclosureGroup("Flag Statistics", ...)`, collapsed by default (`isFlagStatsExpanded = false`, `:1060`). | (none) |
| "The rows that matter for this chapter are `primary`, `duplicates`, `properly paired`, and `supplementary`." | true | All four category strings present in the fixture's `flag_stats` table, verbatim. | (none) |
| "Counts that failed the instrument's own quality check are shown separately in orange beside the passing count." | true | `ReadStyleSection.swift:1226-1230` renders `"(\(qcFail) fail)"` in `Color.lungfishOrangeFallback` when `qcFail > 0`. | (none) |
| "Expand **Per-Chromosome** if the reference holds more than one sequence." | true | `ReadStyleSection.swift:1108-1115` shows the disclosure only when `chromosomeStats.count > 1`, so on this fixture it is absent. The conditional phrasing is correct. | (none) |
| "Switch the Inspector to the View tab and open the Analysis section, then click its **Filtering** tab." | false | Analysis is a top-level Inspector tab, not a section inside View. `InspectorTab` (`InspectorSupportingTypes.swift:67-87`) lists `.view` and `.analysis` as siblings, `InspectorView.swift:138-142` switches between them, and `:231-232` labels the tab "Analysis". | "Switch the Inspector to the **Analysis** tab, then click its **Filtering** tab." |
| Confirmation sheet "headed 'Mark Duplicates in Alignment Tracks?'" | true | `InspectorViewController+TrimDuplicateWorkflows.swift:626` sets exactly that `messageText`. | (none) |
| "explains that `samtools markdup` will run for each alignment track in the bundle and replace the existing tracks with duplicate-marked versions" | true | `:627` informative text reads "This will run samtools markdup for each alignment track in the current bundle and replace existing tracks with duplicate-marked versions." Accurate: `removeAlignmentTracks` (`AlignmentDuplicateService.swift:230-254`) deletes the old BAM, index, and metadata DB from disk as well as the manifest entries. | (none) |
| "It processes every alignment track in the bundle, not just the one you selected." | true | `markDuplicatesInBundle` iterates `manifest.alignments` with no track argument (`AlignmentDuplicateService.swift:57-83`); the button passes none (`ReadStyleSection.swift:2124-2126`). | (none) |
| "Click **Mark Duplicates**." | true | `:629` `addButton(withTitle: "Mark Duplicates")`. | (none) |
| "A progress indicator reads 'Marking duplicates...' while the run works" | true | `:638` `activityIndicator.show(message: "Marking duplicates...", ...)`. Note the Filtering pane's own inline label differs, reading "Running duplicate workflow..." (`ReadStyleSection.swift:2133`). | (none) |
| "and the Operations panel carries the row" | false | See above. `runMarkDuplicatesWorkflow` starts no operation. | Delete the clause. |
| "Open it with **Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `MainMenu.swift:866-873` adds "Show Operations Panel" with `keyEquivalent: "p"` and `[.command, .shift]`. | (none) |
| "When the sheet reports how many tracks were processed" | true | `:656-658` alerts "Processed N alignment track(s). Duplicate-marked tracks are now loaded." | (none) |
| "Each track's name now carries a `[dup-marked]` suffix" | true | `AlignmentDuplicateService.swift:73` passes `outputTrackNameSuffix: "[dup-marked]"`, applied at `:207` as `"\(track.name) \(suffix)"`. | (none) |
| "and the old unmarked track entries are gone from the bundle" | true | `removeAlignmentTracks` at `:230-254` removes each manifest entry and deletes the in-bundle BAM, `.bai`, and metadata DB. | (none) |
| "The `duplicates` row now carries a count where it read 0 before. On the HG002 slice it reads 1,684." | true | Measured. Pristine fixture: `0 + 0 duplicates`. After `lungfish-cli markdup`: `1684 + 0 duplicates`, `1684 + 0 primary duplicates`. | (none) |
| Filter panel "headed by the line 'Build a new alignment track from an existing BAM without changing the source track.'" | true | `ReadStyleSection.swift:2140` verbatim. | (none) |
| "the panel's own note tells you where the result went. Find the new track under **Bundle > Alignment Tracks** and compare it separately under **View > Alignment**." | true | `ReadStyleSection.swift:2106` reads "After creating a filtered alignment, find it under Bundle > Alignment Tracks and compare it separately under View > Alignment." Quoted faithfully. | (none) |
| "Type a name into **Name for New Alignment**, which the run refuses to start without since there is no default" | false | The field auto-fills. `selectedAlignmentFilterSourceTrackID.didSet` (`ReadStyleSection.swift:197-201`) calls `refreshAlignmentFilterOutputTrackNameIfNeeded` (`:739-748`), which writes `derivedAlignmentDefaultName` whenever the field is empty or still holds a prior auto-value; `configureAlignmentFilterTracks` seeds the selection to the first track (`:597-598`). With the shipped defaults (mapped-only and primary-only both on) the suggestion is "Mapped primary alignments" (`AlignmentFilterModels.swift:120-122`). The refusal is real but only fires if you clear the field. | "The **Name for New Alignment** field arrives already filled in with a name describing the filters you set, such as 'Mapped primary alignments'. Replace it with something of your own, since the suggestion changes as you change the filters." |
| Export step: "open the Analysis section's **Export** tab and click **Create Deduplicated Bundle**" | true (button and tab) | `AnalysisWorkflowSubsection.export` titled "Export" (`ReadStyleSection.swift:1047-1048`), `exportSection` holds the button (`:2612`). The enclosing "Analysis section" phrasing inherits the tab error noted above. | Say Analysis tab rather than Analysis section, per the correction above. |
| "A confirmation sheet explains that this writes a sibling `.lungfishref` bundle with duplicate reads removed from all alignment tracks and leaves the current bundle unchanged." | true | `:697-698`: "Create Deduplicated Bundle?" / "This creates a sibling .lungfishref bundle with duplicate reads removed from all alignment tracks. The current bundle will not be modified." | (none) |
| "Neither duplicate-marking button opens a dialog, so that operation has no settings of its own." | true | Both present an `NSAlert` confirmation only. Matches `parameters.yaml` `bam.mark-duplicates` `settings: []`. | (none) |
| Settings: **Starting Alignment**, default "the first alignment track in the bundle", CLI `--alignment-track` | true | `ReadStyleSection.swift:2146-2164` Picker titled "Starting Alignment"; default selection `options.first?.id` (`:597-598`); `bam.txt` `--alignment-track`. Matches registry. | (none) |
| Settings: **Keep mapped reads only**, on by default, CLI `--mapped-only` | true | `:2166-2172` Toggle with that exact title; `alignmentFilterMappedOnly = true` (`:194`); `bam.txt` `--mapped-only`. | (none) |
| Settings: **Keep one primary alignment per read**, on by default, CLI `--primary-only` | true | `:2174-2180` Toggle, exact title; default `true` (`:200`); `bam.txt` `--primary-only`. | (none) |
| Settings: **Minimum alignment confidence**, "stepper that runs from 0 to 255", displays "MAPQ N", default 0, note "Uses SAM MAPQ. Set to 0 to keep every alignment confidence level.", CLI `--min-mapq` | true | `:2182-2205`: label, `Text("MAPQ \(...)")`, `Stepper(... in: 0...255)`, and the caption verbatim; default 0 (`:206`). | (none) |
| Settings: **Duplicate handling**, three choices "Keep all reads", "Hide duplicate-marked reads", "Remove duplicate reads", default Keep all reads | true | `AlignmentFilterInspectorDuplicateChoice.title` (`ReadStyleSection.swift:857-866`) gives the three titles verbatim; default `.keepAll` (`:225`). | (none) |
| "On the command line these are `--exclude-marked-duplicates` and `--remove-duplicates`, and the two flags refuse to run together." | true | Mapping at `:846-856`. Guard at `BAMCommand.swift:1095-1097` throws "--exclude-marked-duplicates and --remove-duplicates are mutually exclusive." This settles DRIFT changed row 24. | (none) |
| Settings: **Keep reads with zero mismatches to reference**, off by default, CLI `--exact-match` | true | `:2216-2222` Toggle, exact title; default `false` (`:232`); `bam.txt` "--exact-match  Keep only exact matches (NM == 0)". | (none) |
| Settings: **Minimum identity to reference (%)**, starts blank, "greyed out while zero-mismatch filtering is on, with its placeholder changing to say so", CLI `--min-percent-identity`, "refuses to run alongside `--exact-match`" | true | `:2224-2245`: label verbatim, placeholder switches to "Disabled while exact-match filtering is on", `.disabled(alignmentFilterExactMatchOnly)`, default `""` (`:239`). Guard at `BAMCommand.swift:1099-1101`. | (none) |
| Settings: **Name for New Alignment**, CLI `--output-track-name` | true (label and flag) | `:2247-2262` label verbatim; `bam.txt` marks `--output-track-name` required. Only the "starts empty, no default" part is wrong, handled above. | (none) |
| Settings coverage: all 8 `bam.filter` settings have a Settings paragraph | true | `parameters.yaml:3009-3086` lists 8 settings; the chapter's Settings section carries one paragraph each, with matching labels, defaults, and allowed values (the Name default being the one mismatch, and it is the registry that is right about the shape and the chapter that is wrong about the behavior). `bam.mark-duplicates` has `settings: []` and the chapter says so. | (none) |
| "The Flag Statistics list reports 91,203 records in total against 91,148 primary records, because 55 reads were split ... 90,935 of those primary records were placed." | true | Measured: total 91,203, primary 91,148, supplementary 55, primary mapped 90,935. | (none) |
| "Both 90,990 out of 91,203 and 90,935 out of 91,148 come to 99.77%, which is a coincidence of this fixture" | true | Both ratios are 99.766% and 99.766%. `samtools flagstat` prints 99.77% for each. | (none) |
| "Est. Coverage of 44.7x is the average depth across the 500,001-base slice." | false | The slice length and the 44.7x mean depth are both right, but that figure is not Est. Coverage. Measured mean depth over all records is 44.7234. Est. Coverage displays 27.3x. | "The mean depth across the 500,001-base slice is 44.7x. The Inspector's Est. Coverage reads 27.3x on this fixture, because it assumes a 150-base read." |
| "That sits inside the 30x to 50x band a human genome project usually aims for" | unverifiable | A domain convention with no repository source. Settled by a citation in `docs/user-manual/appendices/bibliography.md`. Reads as a rule of thumb, which is acceptable framing. | (none) |
| "The `properly paired` count of 90,414 ... Out of 91,148 paired reads that is 99.19%." | true | Measured: `90414 + 0 properly paired (99.19% : N/A)`, `91148 + 0 paired in sequencing`. | (none) |
| "marking flags 1,684 records as duplicates. That is 1.85% of the 91,148 primary records" | true | Measured 1,684. `1684 / 91148 = 1.848%`. | (none) |
| "It is 91,203 before marking and 91,203 after, because marking sets a flag and deletes nothing." | true | Measured both sides: 91,203 total in each flagstat. | (none) |
| "Est. Coverage is computed over all the reads the alignment holds, so it does not drop when duplicates are merely marked." | true | `estimatedCoverage` reads `stat.mappedReads` from the stats DB, which is unchanged at 90,990 after marking. The conclusion holds even though the figure quoted for the row elsewhere is wrong. | (none) |
| "The app does hide them in the viewport straight after a marking run, by turning off Include duplicate-marked reads in the View Settings" | true | `InspectorViewController+TrimDuplicateWorkflows.swift:651-653` sets `showDuplicates = false` then fires `onSettingsChanged`. Toggle titled "Include duplicate-marked reads" at `ReadStyleSection.swift:1715`. | (none) |
| "the mean depth over the slice is 44.72x counting every read and 43.90x once the flagged duplicates are excluded. That is a drop of 0.8x" | true | Measured with `samtools depth -a`: 44.7234 with `-g 0x400`, 43.8966 by default. Difference 0.827. | (none) |
| "leaves 89,107 records out of 91,203" | true | Measured twice. The author's filtered track flagstats 89,107 total, and `samtools view -c -q 20 -F 0xC04` on the marked BAM gives 89,107 independently. | (none) |
| "213 were unmapped, 55 were supplementary, 1,684 were flagged duplicates, and the remaining 144 were mapped, primary, non-duplicate reads whose MAPQ fell below 20." | true | `samtools view -c -F 0xC04` gives 89,251; 89,251 - 89,107 = 144. The other three come straight from the flagstat. Sum 2,096 = 91,203 - 89,107. | (none) |
| "The filtered track's mean depth is 43.83x" | true | Measured 43.8275 with `samtools depth -a`. | (none) |
| "Its Mapped % is 100.00%" | true | Filtered-track flagstat: `89107 + 0 mapped (100.00% : N/A)`. | (none) |
| "Its properly paired share rises from 99.19% to 99.51%" | true | Measured: `88666 + 0 properly paired (99.51% : N/A)`. | (none) |
| "A filtered track's BAM is written into the bundle under `alignments/filtered/`, named by the track identifier, alongside its `.bai` index and a `.stats.db` metadata database." | true | Observed on the scratch bundle: `alignments/filtered/hg002-filtered.bam`, `hg002-filtered.bam.bai`, `hg002-filtered.stats.db`. Note the index is `<name>.bam.bai`, not `<name>.bai`, which the chapter's loose phrasing does not contradict. | (none) |
| "A duplicate-marked track goes to `alignments/marked/`" | true | `AlignmentDuplicateService.swift:63-64` creates `alignments/marked`. | (none) |
| "a deduplicated bundle's tracks go to `alignments/deduplicated/` inside the new bundle" | true | `:106-107`. Observed: `HG002_chr20_slice-deduplicated.lungfishref/alignments/deduplicated/aln_*.bam`. | (none) |
| "Each output carries its own provenance record naming the exact commands that produced it." | true | `AlignmentMarkdupPipeline.swift:303-390` records an `AlignmentCommandExecutionRecord` per stage; `BundleAlignmentFilterService.swift:428-441` writes derivation metadata; provenance sidecars observed beside every fixture output. | (none) |
| "The HG002 slice covers 99.99% of its 500,001 bases." | true | Measured: 499,970 of 500,001 bases carry at least one read, 99.9938%. Matches `mapping-result.json` `coverageBreadth` 0.999938. | (none) |
| "Under about 5% on a PCR-free shotgun library ... A shotgun rate above about 20% means over-amplification ... A rate above 80% on amplicon data" | unverifiable | Domain rules of thumb, no repository source. The author softened DRIFT unverifiable row 27 to "above about 80%" and framed it as a consequence of amplicon design, which is the right handling. Settled by a bibliography citation. | (none) |
| "87,759 of 91,203 records carry the maximum MAPQ of 60 and only 401 fall below 20" | true | Measured: `awk '$5==60'` over all records gives 87,759; `awk '$5<20'` gives 401. | (none) |
| "Duplicate marking is a top-level command taking one positional path, which can be a single BAM or a directory of BAMs" | true | `markdup.txt` ARGUMENTS: "`<path>`  Path to a BAM file or a directory containing BAMs". | (none) |
| "`lungfish-cli markdup HG002.sorted.bam` ... prints three lines" and the quoted block | true | Reran on a fresh fixture copy. Output byte-for-byte: `Processed 1 BAM file (0 already marked)` / `Total reads: 90990, duplicates: 1684` / `Elapsed: 2.1s`. Emitters at `MarkdupCommand.swift:832-834`. | (none) |
| "It sorts the records by read name, runs `fixmate -m` ... sorts back into coordinate order, runs `markdup`, and indexes the result." | true | `AlignmentMarkdupPipeline.swift:302-380`: `sort -n`, `fixmate -m`, `sort`, `markdup`, `index`, in that order. Settles DRIFT changed row 12. | (none) |
| "Unlike the Inspector button, which writes new `[dup-marked]` tracks into the bundle, the command marks in place. It replaces the input BAM with the marked version and writes no separate output, and there is no input or output flag to change that." | true | `MarkdupCommand.swift:282-316` writes `<bam>.markdup.tmp` then `replaceItemAt(bamURL, withItemAt: tempBamURL)` and moves the new index over the old. `markdup.txt` offers no input or output flag beyond the positional. The author's defect claim 2 is correct and the chapter is right to warn about it. | (none) |
| "A second run on the same file prints `Processed 1 BAM file (1 already marked)` and finishes in a fraction of the time" | true | Reran. Printed exactly that, `Elapsed: 0.1s` against 2.1s. | (none) |
| "Pass `--force` to run the pipeline again anyway" | true | `markdup.txt`: "--force  Re-run markdup even if already marked". | (none) |
| "`--sort-threads` sets how many threads the two sorting stages use and defaults to 4, separately from the global `--threads`." | true | `markdup.txt` "(default: 4)". `AlignmentMarkdupPipeline.swift:298` builds `threadArguments` from `sortThreads` and appends it only to the two `sort` invocations (`:303`, `:338`), never to `fixmate`, `markdup`, or `index`. | (none) |
| "The same command exists as `lungfish-cli bam markdup` with one difference, which is that the `bam` form has no `--deduplicated-bundle` flag." | true | `bam.txt` `bam markdup` OPTIONS list `--force`, `--sort-threads`, `--format` and the globals, with no `--deduplicated-bundle`; the top-level `markdup.txt` has it. | (none) |
| "`lungfish-cli markdup HG002.sorted.bam --deduplicated-bundle HG002-dedup.lungfishref`" writes a bundle with reads removed | true | `markdup.txt`: "--deduplicated-bundle  Create a sibling .lungfishref bundle with duplicate reads removed". Flag declared at `MarkdupCommand.swift:46`. | (none) |
| "`lungfish-cli bundle deduplicate-alignments` ... copies the bundle, removes duplicates from every alignment track the copy holds, and records provenance in the output." | true | `bundle.txt:146-151` states exactly that. | (none) |
| "Omit `--output` and LGE writes the copy beside the source as `<source name>-deduplicated.lungfishref`, adding a number to the name if that path is already taken." | true | `AlignmentDuplicateService.uniqueDeduplicatedBundleURL` (`:268-286`) builds `<stem>-deduplicated.lungfishref` in the source's parent and tries `-2` through `-999`. Observed on the fixture. Settles DRIFT changed row 19. | (none) |
| "the run reports `Deduplicated bundle: .../HG002_chr20_slice-deduplicated.lungfishref` and `Processed tracks: 2`" | true | Emitters at `MarkdupCommand.swift:986-987`. The scratch bundle holds two deduplicated tracks, matching a processed count of 2. | (none) |
| "the deduplicated copy of the marked track holds 89,519 records, which is 91,203 minus the 1,684 that were flagged" | true | Measured `samtools view -c` on `aln_9C811091.bam`: 89,519. `91203 - 1684 = 89519`. | (none) |
| "`--output-track-id` fixes the new track's identifier instead of letting LGE generate one" | true | `bam.txt`: "Alignment track ID. Defaults to a generated portable ID." | (none) |
| "`--bundle` and `--mapping-result` are alternatives, and exactly one is required" | true | `BAMCommand.swift:1090-1093` throws "Specify exactly one of --bundle or --mapping-result." | (none) |
| "That is the exact run behind the 89,107 records quoted above." (the six-flag example) | true | Every flag in the block appears in `bam.txt` `bam filter`, and the count reproduces. | (none) |
| "`--format json` prints the run summary as one JSON object instead of the plain progress lines" | true | `bam.txt` "--format  Output format: text, json (default: text)". | (none) |
| "`lungfish-cli bam annotate` converts mapped reads into an annotation track, which turns the read stack into a sortable, filterable table." | true | `bam.txt` `bam annotate` OVERVIEW "Convert mapped reads to annotations in a reference bundle". | (none) |
| "Continue to [Viral Recon Wizard](05-viral-recon-wizard.md), the last chapter in this part" | true | `docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md` exists and is roster row 26, the last in part 04. Settles DRIFT false row 29. Chapter 05's own Next link (DRIFT row 47) still needs reconciling on that chapter's side. | (none) |

## Front matter

| Check | Verdict | Evidence |
|---|---|---|
| `parameters_refs: [bam.mark-duplicates, bam.filter]` matches roster row 25 | true | `DRIFT.md:3751` lists exactly `[bam.mark-duplicates, bam.filter]` for `04-alignments/04-alignment-quality`. |
| Both registry ids exist | true | `parameters.yaml:2790` and `:3002`. |
| Every `bam.filter` setting has a Settings paragraph with the exact label, default, and allowed values | true | All 8 registry settings covered, labels verbatim. The Name for New Alignment default is stated wrongly, but that is a source-behavior error rather than a registry mismatch, and the registry says the same thing (`default: empty`), so the registry needs the same correction. |
| `bam.mark-duplicates` has no settings, and the chapter says so | true | `parameters.yaml:2803` `settings: []`; chapter line 98. |
| Every `<!-- SHOT -->` marker has a front-matter entry with a caption | true | Four markers at chapter lines 72, 80, 88, 94: `inspector-alignment-stats`, `analysis-filtering-tab`, `filter-panel-controls`, `analysis-export-tab`. Four `shots:` entries, same ids, same order, each captioned. |
| Every `glossary_refs` anchor resolves | true | All 25 anchors found exactly once each in `GLOSSARY.md`, including the two the author added, `{#duplicate-rate}` and `{#edit-distance}`. |
| Shot captions describe states the app can actually show | true | Every label named in the four captions is verbatim from the source. Two captions describe non-default states the capturer must set up first, which is normal for a capture instruction: `inspector-alignment-stats` wants Flag Statistics expanded, and it is collapsed by default (`ReadStyleSection.swift:1060`), and `filter-panel-controls` wants the stepper at MAPQ 20 against a default of 0. `analysis-filtering-tab` correctly places both controls on one tab with the divider between them (`:2138`). No caption implies Analysis is a section of View. | (none) |

## Cross-document consistency

`CONSISTENCY.md` carries no entry for this chapter.

The live conflict is with the committed sibling
`04-alignments/01-mapping-reads-to-a-reference.md`. That chapter states Est.
Coverage as 27.3x at lines 154, 156, and 193, explains the 150-base assumption,
and names the understatement as a release defect. This chapter states 44.7x for
the same row on the same fixture in four places. One of the two is wrong and it
is this one. Fixing it also brings this chapter into line with the fixture
README, which reports 44.7x only as `meanDepth`.

Second, a naming split the author flagged and I confirm. The Inspector title is
`Flag Statistics` (`ReadStyleSection.swift:1101`), and both chapters use it. The
`bam.mark-duplicates` and `bam.filter` notes in `parameters.yaml`, the `flagstat`
glossary entry, and DRIFT all say "Flag Stats". The chapters follow the source
and are right. The registry and glossary should be brought to `Flag Statistics`.

## Author defect claims

| Claim | Verdict | Evidence |
|---|---|---|
| 1. The confirmation sheet says "replace existing tracks" but `markDuplicatesInBundle` leaves the original BAMs on disk, only removing manifest entries. A small disk leak. | false | `removeAlignmentTracks` (`AlignmentDuplicateService.swift:230-254`) removes the manifest entry, deletes the metadata DB, and deletes both the source BAM and its index when they resolve inside the bundle (`sourceURL.path.hasPrefix(bundleURL.path + "/")`). Only a track whose BAM lives outside the bundle survives, which is the correct behavior since the bundle does not own that file. The sheet's wording is accurate and there is no leak to report. |
| 2. `lungfish-cli markdup` overwrites the input in place while the Inspector button writes new tracks. | true | `MarkdupCommand.swift:282-316` replaces the input via `replaceItemAt`. `markDuplicatesInBundle` writes into `alignments/marked/` and attaches new tracks. The chapter is right to state the difference, and the warning to copy originals before walking a cohort is well placed. |
| 3. Docs surfaces disagree on "Flag Statistics" vs "Flag Stats". | true | See Cross-document consistency above. |

New defect this review found, not in the author's list. Neither
`runMarkDuplicatesWorkflow` nor `runCreateDeduplicatedBundleWorkflow` checks
`OperationCenter.shared.canStartOperation` or registers an operation, while the
three neighbouring workflows in the same file all do. A duplicate-marking run can
therefore start on a bundle another operation is already mutating, and it is
invisible in the Operations panel while it runs. Worth a product decision
independent of the chapter.

## Verdict counts

Chapter claims. True 73. False 8. Unverifiable 3.
Front matter. True 7. False 0. Unverifiable 0.
Author defect claims. True 2. False 1. Unverifiable 0.

All tables. True 82. False 9. Unverifiable 3.
