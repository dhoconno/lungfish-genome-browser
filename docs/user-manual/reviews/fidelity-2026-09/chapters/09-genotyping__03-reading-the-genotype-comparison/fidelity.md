# Fidelity review: 09-genotyping/03-reading-the-genotype-comparison

Roster row 55. Reviewed 2026-09-07 against Preview 2026.9.13, the Swift source
under `Sources/`, the CLI help tree, and the Williams project bundle
`~/Desktop/lge-docs/32566_MS267_Williams1.lungfish/Analyses/Amplicon genotyping results/amplicon-genotyping_3.lungfishgenotype`
(read-only). Both CLI commands were rerun independently and their figures
reproduced exactly.

Ground truth used, in order: the Swift source, `.build/debug/lungfish-cli`
genotype help, the Williams bundle's own JSON and CSV artefacts, then the
reality map and DRIFT. Where the map and the source disagree, the source wins
and the disagreement is recorded under App defects or Notes for the editor.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "LGE opens it when you click a `.lungfishgenotype` bundle in the sidebar" | true | `features.yaml:907` `viewport.genotype-matrix`; map row 3.1 | |
| 2 | "There is no coordinate ruler and no position anywhere in it" | true | `GenotypeComparisonMatrixView.swift:1484-1515` builds only Genotype, reference fields, Locus, Samples, Unique and one column per sample. No positional column exists | |
| 3 | "rows are the allele targets in the run's reference library and whose columns are the samples" | true | `genotype-reviewable-rows.json` holds 970 rows of `kind`/`section` `reference` and 30 samples | |
| 4 | "the number in a filled cell is how many retained reads that sample gave that allele target" | true | `GenotypeComparisonMatrixView.swift:2951-2956`, `cellValue` returns `integer(support.passedUniqueReads)` | |
| 5 | "The Inspector down the right side of the window holds every display control the window has." | true, with a caveat | `GenotypeResultDisplaySection.swift:1219-1252` is the whole control set, and `GenotypeResultViewController.swift:2708` hides `lensControl` for a genotype-only result | The Inspector for a genotype result is tabbed, not one column. See Consistency item 1. |
| 6 | "A filter bar above the grid narrows it." | true | `GenotypeResultViewController.swift:2748, 2781-2784` pins `quickFilterBar` above `comparisonMatrix` | |
| 7 | "A detail pane beside the grid shows either a cohort-wide summary or, once you pick a sample, that sample's own evidence." | **false** | `GenotypeResultViewController.swift:3946-3956`. When `rawMatrixUsesSampleCurationDetail && showsRawMatrix`, which is exactly the genotype-only case, `cohortSummaryPanel.isHidden = true` unconditionally. With no selection the detail stack is emptied. `Tests/LungfishGenotypeUITests/GenotypeResultViewportLensAndManualHaplotypeTests.swift:131-142` asserts `testingCohortSummaryIsHidden` is true and `testingDetailText` is `""` | "A detail pane beside the grid stays blank until you pick a sample, and then shows that sample's own evidence." |
| 8 | "an IPD-MHC Mamu allele library of 970 allele targets" | true | 970 rows in `genotype-reviewable-rows.json`; chapter 01 line 49 agrees | |
| 9 | "Its result carries allele calls and no haplotype analysis" | true | `genotype-result.json` `workflowMode` is `genotypeOnly` and `haplotypeAnalysis` is null | |
| 10 | "A MiSeq amplicon run gathers its bundles into an `Amplicon genotyping results` folder inside the project's `Analyses/` folder." | true | the Williams project holds seven `.lungfishgenotype` bundles under exactly that path | |
| 11 | "A run that produced allele calls and nothing else shows the matrix with no view selector above it at all." | true | `GenotypeResultViewController.swift:2717` `lensControl.isHidden = isGenotypeOnlyResult \|\| viewportSelectionCount <= 1`, and `:618` gives `viewportHeaderHeight` of 0 | |
| 12 | "A run that also carried out haplotype analysis shows a two-way selector reading Haplotype Calls and Genotype Matrix, and an Actions button beside it." | true | `GenotypeResultPresentationPolicy.swift:100-107` returns those two choices; `GenotypeResultViewController.swift:2663-2682` builds `Actions`; `:2718` `presentationActionsButton.isHidden = choices.isEmpty` | |
| 13 | "**Genotype** holds the allele target's name ... so a Williams row reads `01_Mamu-A1_001_05_01_01`" | true | `GenotypeComparisonMatrixView.swift:1486` titles the column `Genotype`; that exact `display_name` is present in the projections file | |
| 14 | "**Locus** names the gene ... **Samples** counts ... **Unique** totals the retained reads" | true | `:1509, 1512, 1515` and `cellValue` cases `.locus`, `.samples`, `.uniqueReads` at `:2934-2939` | |
| 15 | "Right-clicking the column headers offers a menu that turns each of the four on or off, and adds any extra fields the reference library carried." | true | `GenotypeComparisonMatrixView.swift:1636-1668` builds the header context menu over the four standard IDs and the reference fields | |
| 16 | "LGE tints a filled cell pale blue ... That tint carries no meaning beyond the cell being filled." | true | `GenotypeComparisonMatrixView.swift:5815-5820`. On the `manualHaplotypeEditingEligible` branch, which is the genotype-only case, every filled cell gets flat `systemBlue` at alpha 0.20. The graded heatmap at `:5825-5836` is the other branch | Confirms the chapter and contradicts DRIFT row 3.13 |
| 17 | "970 allele-target rows by 30 sample columns, which is 29,100 cells, and only 2,109 of them are filled. Just 305 of the 970 rows carry a call in even one sample." | true | counted directly from `genotype-reviewable-rows.json`: 2,109 non-zero `support` entries of 29,100, and 305 rows with at least one | |
| 18 | "MHC-B contributes 342 of the 970 rows and MHC-DRB another 222, while MHC-F and MHC-J contribute 5 each." | true | counted: MHC-B 342, MHC-DRB 222, MHC-F 5, MHC-J 5 | |
| 19 | "spread unevenly across 13 loci" | true | 13 distinct `locus` values in the projections file and 13 in `top_calls_by_locus` | |
| 20 | "the sentence \"Visual filters do not change genotype calls.\"" | true | `GenotypeResultDisplaySection.swift:1241` verbatim | |
| 21 | "a note reading that genotype calls and haplotype thresholds are fixed by the completed run and that re-running the original workflow is the way to change them" | true | `GenotypeResultDisplaySection.swift:1422-1426` under the heading `Run and Calling Thresholds` | |
| 22 | "With no sample selected it shows the cohort summary" | **false** | same evidence as claim 7. On a genotype-only result the cohort summary panel is never shown, under any lens. `.summary` routes through `applySummaryViewModeVisibility` which hides it, and `.audit` installs `artifactScrollView` instead (`:3110-3112`) | Step 2 has no counterpart in the window a Williams reader sees. See App defect 1. |
| 23 | "It has five sections" | true | `GenotypeCohortSummaryPanelView.swift:112-128` makes five calls, two `makeFlagSection` and three `makeSection` | Confirms the chapter and contradicts DRIFT row 3.18 |
| 24 | "**Below N reads** counts the samples under a fixed threshold of 5,000 retained reads" | true, wording imprecise | `GenotypeResultDisplayState.swift:142` defaults `cohortFlagThreshold` to 5,000, but `GenotypeCohortSummaryPanelView.swift:119` titles the section with `formatThreshold`, which renders 5,000 as `5.0K` | The section heading reads **Below 5.0K reads** rather than a literal `Below N reads`. |
| 25 | "its footnote warns that calls in those samples may be unreliable" | true | `:122` footnote "Samples below the absolute read threshold — calls here may be unreliable." | |
| 26 | "Both counts turn red when they are above zero, and hovering either one lists the samples behind it, up to eight of them followed by a count of how many more there are. The other three sections carry no such tooltip." | true | `:154-163`, `textColor = count > 0 ? .lungfishDanger : .labelColor`, `samples.prefix(8)` and `(+N more)`. `makeSection` at `:202-230` sets no `toolTip` | |
| 27 | "**QC distribution** breaks the run down ... into OK, Low support, and Needs review." | true | `GenotypeResultViewController.swift:8056-8060` builds exactly those three labels | Confirms the lowercase `review` in `Needs review` |
| 28 | "**Errors** counts calls the run could not complete, by type. **Annotations** counts what analysts have added" | true | `:8061-8062`, `cohortErrorTypeCounts` and `cohortAnnotationCounts` | The Errors vocabulary was not traced. Unverifiable in detail, correctly hedged by the chapter. |
| 29 | "23 of the 30 samples are marked OK and 7 are marked Low support" | true | `genotype list-samples` rerun: 23 `ok`, 7 `lowSupport` | |
| 30 | "The 23 OK samples carried between 1,976 and 58,370 retained reads. The 7 Low support samples carried between 2 and 713." | true | rerun `list-samples`, `total_reads` min/max per group: 1976/58370 and 2/713 | Matches chapter 01 line 121 exactly |
| 31 | "Click a sample's column header and the detail pane switches from the cohort summary to that sample." | **false** in its premise | `:3946-3956` routes a genotype-only result to `rawMatrixUsesSampleCurationDetail`. The pane switches from **blank** to that sample, not from the cohort summary | "Click a sample's column header and the detail pane fills with that sample's evidence." |
| 32 | "Its header carries four figures. **Selected Sample** ... **Retained Unique Reads** ... **Passed Alignments** ... **Call-support check**" | true | `GenotypeResultViewController.swift:4979-5001` builds exactly those four `Metric` labels in that order | |
| 33 | "**Meets thresholds** means the sample has at least one call, at least 1,000 retained unique reads, and at least 20 passed alignments." | true | `GenotypeSampleCurationWorkbenchView.swift:22-28` and the `.meetsThresholds` explanation at `:46-49` | |
| 34 | "**Low support** means it has at least one call but falls under one of those two numbers. **Review needed** means it has no calls, no retained reads, or no passed alignments at all." | true | `:25-27` and the two explanation strings at `:50-57` | |
| 35 | "Every one of the three carries the same caveat in the pane, that this automated check is not analyst approval and not confirmation that any assignment is correct." | true, wording loose | `:41-43`, the caveat is shared but reads "confirmation that **haplotype assignments** are correct" | The caveat names haplotype assignments specifically. "any assignment" broadens it. Acceptable as a gloss, but the editor may prefer the narrower reading. |
| 36 | "those thresholds sort the 30 samples into 23 Meets thresholds and 7 Low support, the same split as the run's own QC status" | true | evaluating `GenotypeCallSupportCheck.evaluate` over the 30 rows of `amplicon-genotyping_3.retained-demux-samples.csv` gives 23 / 7 / 0 | |
| 37 | "Below the header the pane lists **Supported Alleles**, one line per allele target that sample showed, each with the allele name and its retained read count." | true | `GenotypeSupportedAllelesPanel.swift:154` and `GenotypeResultViewController.swift:4959` | |
| 38 | "Two filters sit above the grid and the rest are in the Inspector." | true | the filter bar carries the search field and the pill row; every other control is in the Inspector | |
| 39 | "a search field whose placeholder reads \"Search samples or alleles…\"" | true | `GenotypeQuickFilterBarView.swift:121`, and `configureSearchCapability` at `:252-258` keeps that wording when `hasHaplotypingResult` is false | |
| 40 | "matching both sample names and allele names rather than samples alone" | true | the placeholder and empty-state string both name samples and alleles, and `GenotypeSearchIndex.swift` indexes both. Note `parseSearchText` at `:359-370` falls through to a comment substring predicate for plain text, so the allele half is served by the index rather than by the predicate | |
| 41 | "Cmd-F puts the cursor in it from anywhere in the window, and Escape clears it." | true | `GenotypeResultViewController.swift:1119-1128` | |
| 42 | "typing `Cohort=Kenyon20` narrows to samples whose metadata field named Cohort contains that value, and the colon form `Cohort:Kenyon20` does the same" | true | `GenotypeQuickFilterBarView.swift:351` documents both forms, `:361-362` maps to `.metadataFieldContains` | The Williams samples carry no imported metadata, so this is syntax rather than a run result. The chapter presents it that way. |
| 43 | "six of them, labelled Has errors, Homozygous, Recombinant, Bw6+, Has comments, and Duplicate" | true | `GenotypeQuickFilterBarView.swift:22-30` gives exactly those six labels, and none is hidden on a genotype-only result | |
| 44 | "the two that do useful work are Has errors and Has comments" | true | the other four map to `.isHomozygousAcrossAll`, `.hasRegionalRecombinant`, and two `.commentContains` predicates over haplotype vocabulary (`:33-40`), none of which a genotype-only bundle can satisfy | Note Bw6+ and Duplicate are comment-substring predicates, so they would in principle match an analyst comment. Immaterial on a bundle with no comments. |
| 45 | "The **Smart Cohorts** section above it saves a filter you have set" | **false** | `GenotypeResultDocumentSection.swift:396-398`, `.smartCohorts` is appended to `visibleComponents` **only** when `state.hasHaplotypingResult`. On a genotype-only result the section is not rendered at all. It also lives in the Inspector's Bundle tab (`InspectorView.swift:106`, `DocumentSection.swift:606`), not above Genotype Display in the View tab | "On a run that carried haplotype analysis the Inspector's Bundle tab gains a **Smart Cohorts** section that saves a filter you have set. A genotype-only result does not show it." |
| 46 | "On a run that carried haplotype analysis LGE seeds four of them, named Incomplete haplotypes, Needs review, Homozygous, and Recombinants." | true | `GenotypeAnnotationStore.swift:268-299` seeds exactly those four with that capitalisation | Confirms the chapter and contradicts DRIFT row 3.23, whose `Needs Review` comes from a `#Preview` block at `GenotypeSmartCohortSection.swift:118` |
| 47 | "On a genotype-only result it seeds none, so the section reads \"No saved cohorts.\" until you press **Save Current Filter…** to make one." | **false** in its second half | seeding none is true (`GenotypeResultViewController.swift:1352` passes `seedBuiltInSmartCohorts: result.haplotypeAnalysis != nil`, and the Williams `annotations.json` has `smartCohorts: []`). But the section is not rendered, so neither string is visible, and `GenotypeResultDocumentSection.swift:477-485` guards select, delete, and add on `hasHaplotypingResult`, making the button inert even if reached | "On a genotype-only result LGE seeds none and does not show the section at all, which is why the command line reports no cohorts." |
| 48 | "Everything you record about a result goes through the Inspector's **Matrix Annotations** section, which stays empty until you select a matrix row, a sample column, or a single cell." | true | `GenotypeMatrixAnnotationSection.swift:14, 17-24`, empty state "Select a matrix row, sample column, or cell to edit saved annotations." | The section is in the Inspector's Annotations tab (`InspectorView.swift:129-135`), which the chapter does not name. See Consistency item 1. |
| 49 | "**Review Annotation** marks a selected cell **False Positive** or **False Negative**, and **Clear Review Mark** removes the mark." | true | `GenotypeMatrixAnnotationSection.swift:43, 59, 66, 78` | |
| 50 | "A cell marked false positive draws its read count inside square brackets, so 54 becomes `[54]`. A cell marked false negative draws an em rule where the blank was." | true | `GenotypeComparisonMatrixView.swift:2955-2957` for `[n]`, `:2953` returns `"—"` for `.falseNegative` | |
| 51 | "A legend under the matrix spells both out along with the comment marker." | true | `GenotypeComparisonMatrixView.swift:1108`, `"[n] False positive   ▣ False negative   ◥ Comment"` | The legend's false-negative glyph is `▣`, not the `—` the cell draws. The chapter does not claim they match. |
| 52 | "The styling controls below let you set a **Fill**, **Text**, or **Border** colour ... with **Clear Style** ... and a **Quick Colors** palette" | true | `GenotypeMatrixAnnotationSection.swift:221, 231, 243, 266, 291` | |
| 53 | "All of it is saved to the bundle's `annotations.json` file and synced into the result's working workbook, which the Inspector states in its own caption." | true | `:34`, "Edits are saved to annotations.json and synced to current.xlsx." The Williams bundle records `currentWorkbookPath` `artifacts/workbooks/current.xlsx` | |
| 54 | "the cohort summary grows a red banner reading that the bundle is read-only and that edits and annotations are kept in memory only" | **false** in its placement | `GenotypeCohortSummaryPanelView.swift:105-107, 174-190` puts the banner at the top of the cohort summary panel, and that panel is never shown on a genotype-only result (claim 22) | The read-only banner is a cohort-summary element, so a genotype-only reader never sees it. Either drop the sentence or attach it to a result shape that shows the panel. |
| 55 | "a **Rows** readout giving how many rows are visible out of the total and a **Hidden Cells** count" | true | `GenotypeResultDisplaySection.swift:1344-1348`, `LabeledContent("Rows", value: "N of M")` and `LabeledContent("Hidden Cells", ...)`, rendered first in the section body at `:1222` | |
| 56 | "**Alleles.** Narrows the matrix to rows whose allele name matches what you type. The default is empty" | true | `:1437-1443`, a `TextField` whose placeholder is `Alleles`, bound to `matrixRowFilterText` | `Alleles` is a placeholder rather than a visible label. Minor. |
| 57 | "**Samples.** Narrows the matrix to the sample columns whose names match what you type." | true | `:1444-1449`, bound to `matrixSampleFilterText` | Same placeholder caveat. |
| 58 | "**Min reads.** ... The default is 0, which means off ... On the command line the pivot export takes the same number as `--min-reads`." | true | `GenotypeNumericFilterDraft.swift:106-118` gives label `Min reads` and bounds 0 to 100,000. `GenotypeResultDisplaySection.swift:1558` shows `0 = Off.` `cli-help/genotype.txt:281` documents `--min-reads` on `export-pivot-xlsx` | |
| 59 | "**Min percent.** ... `--min-percent`" | true | `GenotypeNumericFilterDraft.swift:120-131`, bounds 0 to 100, step 0.5. `cli-help/genotype.txt:284` | |
| 60 | "**Percent Basis.** ... either **Sample Retained** ... or **Viewed Locus** ... The default is Viewed Locus ... `--percent-basis` with the values `sample-retained` and `viewed-locus`." | true | `GenotypeResultDisplaySection.swift:1561-1570`; `ONTGenotypeResultBundle.swift:742-744` for the two display names; `GenotypeResultDisplayState.swift:127` defaults to `.viewedLocus`; `cli-help/genotype.txt:290-291` | |
| 61 | "**Rows… and Columns….** Two menus ... each offering Hide Selected, Show Only Selected, and Show All." | true, wording loose | `GenotypeResultDisplaySection.swift:1602-1640`. The item titles are `Hide Selected Rows`, `Show Only Selected Rows`, `Show All Rows`, and the Columns equivalents | The items name their axis. "each offering Hide Selected Rows, Show Only Selected Rows, and Show All Rows, and the Columns equivalents." |
| 62 | "use **Reset Visibility** below them to undo the lot" | true | `:1644-1651` | |
| 63 | "**Cell Color.** ... either **Support** ... **Highlights** ... or **None**. The default is Support" | true | `GenotypeResultDisplayState.swift:83-96` for the three display names; `:129` region defaults `cellColorMode` to `.support` (verified: `fillColor` at `:5810` requires `.support` for the tint) | |
| 64 | "**Content Text Size.** Steps the text ... with **A−** and **A+**, and **Default** returns it to the system size." | true | `GenotypeResultDisplaySection.swift:1295, 1308, 1315` | |
| 65 | "**Filtered Pivot….** Writes a copy of the result workbook whose pivot sheet has the Min reads and Min percent filters above already applied, leaving every other sheet unchanged ... the copy is one-way" | true | `:1275-1281`, caption verbatim except that it capitalises `Min Reads` and `Min Percent` | The Inspector's caption capitalises both, while the filter labels do not. The chapter's lowercase matches the labels. Leave as is. |
| 66 | "On the command line this is `lungfish-cli genotype export-pivot-xlsx`." | true | `cli-help/genotype.txt:272-276` | |
| 67 | "none has a command-line flag of its own, although the two support filters have equivalents on the pivot export" | true | no genotype display setting appears in `parameters.yaml`, and only `--min-reads`, `--min-percent`, `--percent-basis` recur on the export | |
| 68 | "In the Williams run the samples that sequenced well carry calls at 11 to 13 of the 13 loci, while the Low support samples carry as few as 2." | true | counted from `top_calls_by_locus`: ok samples span 11 to 13, lowSupport samples span 2 to 9 | Matches chapter 01 line 122 |
| 69 | "as in `05_Mamu-B17_01g1\|B17_01_01_01,B17_01_01_02` and onward. That is one call on a group record" | true | that prefix is a real `display_name` in the projections file, and chapter 01 line 71 explains the group form identically | |
| 70 | "two allele targets can be identical over the sequenced stretch even after grouping, so a read matching one matches both and both appear as rows" | true | chapter 01 line 73 states the same, sourced from the same library design | |
| 71 | "The Williams grid fills 2,109 of its 29,100 cells and puts a call in only 305 of its 970 rows." | true | same count as claim 17 | |
| 72 | "There is no quality score on a genotype call, because a call is an exact match or it is nothing." | true | chapter 01 lines 98-100 describe the zero-mismatch full-span retention rule | |
| 73 | The haplotyping placeholder's two sentences | true | verbatim match to `CONSISTENCY.md:117-120` | |
| 74 | "`lungfish-cli genotype list-samples --bundle ...` prints one tab-separated row per sample under the header `animal_id`, `gs_id`, `qc_status`, `total_reads`, `top_calls_by_locus`" | true | rerun: header matches exactly, 30 data rows | |
| 75 | "`top_calls_by_locus` field lists the top call at each of the 13 loci as `MHC-A=…;MHC-AG=…`" | true | rerun row 2 begins `MHC-A=02_Mamu-A4_14g1\|...` and separates loci with `;` | Note the CLI names four loci `MHC-DPA1`, `MHC-DPB1`, `MHC-DQA1`, `MHC-DQB1`, while the matrix's Locus column reads `MHC-DPA`, `MHC-DPB`, `MHC-DQA`, `MHC-DQB`. The chapter never lists the 13 names, so nothing is wrong, but a reader comparing the two surfaces will see the mismatch. |
| 76 | "`genotype list-cohorts` ... prints the header `starred`, `name`, `scope`, `matches`, `description`. On the Williams result it prints the header and no rows" | true | rerun: one header line, zero data rows | |
| 77 | "which is the command-line view of the empty Smart Cohorts section described in step 4" | **false** | the section is not rendered at all on this result shape (claim 45), so there is no empty section for the command to be a view of | "which is the command-line confirmation that a genotype-only result carries no saved cohorts." |
| 78 | "`genotype replay-matrix-annotation` rebuilds an annotation sidecar from a recorded annotation edit, and `genotype replay-manual-haplotype-assignments` and `genotype replay-call-overrides` replay their recorded edits" | true | `cli-help/genotype.txt:27-35` | |
| 79 | "`genotype apply-annotations`, merges an annotation patch file into a bundle's sidecar" | true | `cli-help/genotype.txt:25, 149-153` | |
| 80 | "Both commands in it are read-only" | true | neither `list-samples` nor `list-cohorts` takes an output path or a write flag | |

## Front matter

Complete and valid. Every key the lint requires is present, `audience` is
`bench-scientist`, `parameters_refs` is a list, and all four declared shot ids
have matching `<!-- SHOT: -->` markers in the body with no orphans in either
direction.

`parameters_refs: []` is correct. No genotyping operation is registered in
`docs/user-manual/parameters.yaml`, which the reality map records, and roster
row 55 carries an empty column.

`features_refs: [viewport.genotype-matrix]` resolves to `features.yaml:907`.

`glossary_refs` lists twelve terms and every one has an anchor in
`docs/user-manual/GLOSSARY.md`. Both glossary changes are correct.
`smart-cohort` is new at line 605, alphabetically between `sliding-window-trimming`
and `smart-filter-token`, and its text ("seeded with four defaults on a run that
carried haplotype analysis and with none on a genotype-only run") matches
`GenotypeAnnotationStore.swift:268-299` exactly. The corrected `genotype-matrix`
entry at line 241 no longer promises a haplotype tape.

One front-matter problem. The shot id `genotype-matrix-overview` is already
used by chapter 01 (`01-what-is-mhc-genotyping.md:17`), whose caption describes
the same picture in almost the same words. Two chapters declaring one id is a
collision the Screenshot Scout has to resolve, and the two captions differ only
in whether they call the view "the Genotype Matrix view" or "the genotype
result window". Either share one shot deliberately, in which case the captions
should be reconciled, or rename this chapter's to something like
`genotype-matrix-window`.

`estimated_reading_min: 15` is plausible for the length. `tools: []` is right,
since the chapter runs no tool. `entry_points` matches map row 3.1.

## Consistency

1. **Inspector route naming.** `CONSISTENCY.md:30-31` rules that body prose
   writes "the Inspector's Consensus tab" rather than a path. The genotype
   Inspector is tabbed the same way, with five tabs for a genotype result,
   Bundle, Selected Item, Annotations, View, and Provenance
   (`InspectorViewModel.swift:71`, names at `InspectorView.swift:227-234`). The
   chapter names sections without ever naming the tab they sit in, so a reader
   who opens the Inspector on the Bundle tab will not find **Genotype Display**,
   which is under **View** (`InspectorView.swift:250-251`), or **Matrix
   Annotations**, which is under **Annotations** (`:129-135`). Add the tab on
   first mention of each, as "the Genotype Display section of the Inspector's
   View tab" and "the Matrix Annotations section of the Inspector's Annotations
   tab".

2. **Haplotyping placeholder.** Verbatim match to the fixed two sentences under
   the fixed heading. Correct.

3. **On the command line opening.** Matches the fixed paragraph used in
   `06-classification/03-running-esviritu.md:229` with "the dialog" swapped for
   "the window", which is the right adaptation for a result window.

4. **Fixture naming.** "the Williams MiSeq genotyping project" is the name
   `CONSISTENCY.md:129` fixes. Used consistently.

5. **Chapter 01 agreement.** Every shared figure agrees: 970 allele targets,
   30 animals, 23 ok and 7 lowSupport, 1,976 to 58,370 against 2 to 713, 11 to
   13 loci against as few as 2, 2,109 filled entries. The allele naming scheme
   and the group-record explanation are consistent, and this chapter correctly
   defers the full explanation to chapter 01 rather than restating it.

6. **App name.** "Lungfish Genome Explorer (LGE)" at first mention, "LGE"
   after. Correct.

7. **Prose rules.** Lint is green under `LUNGFISH_MANUAL_STRICT=1`. No em
   dashes, no semicolons, no in-sentence colons, bullet caps respected.

8. **Settings section shape.** Each entry follows the three-sentence form and
   ends with the command-line sentence where a flag exists. The group lead
   paragraph says once that none of the controls has a flag of its own, which
   `CONSISTENCY.md:98-101` permits for a group of viewer display settings.

## App defects

1. **The cohort summary panel is unreachable on a genotype-only result.**
   `GenotypeResultViewController.swift:3946-3956` sets
   `cohortSummaryPanel.isHidden = true` whenever
   `rawMatrixUsesSampleCurationDetail && showsRawMatrix`, and
   `rawMatrixUsesSampleCurationDetail` at `:3982-3985` is true for
   `isGenotypeOnlyResult`. The `.summary` lens is the only lens that could show
   the panel, and it routes through that method. `.audit` installs
   `artifactScrollView` instead (`:3110-3112`). Two committed tests assert the
   behaviour deliberately,
   `testGenotypeOnlySummaryLeavesScrollableEmptySelectionDetailBlank` and
   `testClearingGenotypeOnlyMatrixSelectionRestoresBlankDetail`
   (`GenotypeResultViewportLensAndManualHaplotypeTests.swift:131-165`), so this
   looks intentional rather than accidental. The consequence is that a
   genotype-only reader has no in-window view of the low-coverage counts, the QC
   distribution, the error tally, the annotation tally, or the read-only banner,
   and the code that builds all five (`rebuildCohortSummary` at `:8040-8076`)
   runs for a surface nobody sees. Worth deciding whether the panel should be
   restored for this result shape, since the cohort-level judgement the chapter
   describes is exactly what a genotyping reader needs first.

2. **The matrix's own filter field and locus popup are built and then hidden.**
   `GenotypeComparisonMatrixView.swift:1090` sets `filterField.isHidden = true`
   and `:1104` sets `locusPopup.isHidden = true`. The only assignment of `false`
   anywhere in the file is inside `testingPerformNativeFilterAction`, a testing
   hook. A user can neither see nor use either control. DRIFT rows 3.24 and 3.25
   record both as true on the strength of the strings existing. Nothing is lost
   functionally, because the Inspector's Alleles and Samples fields write the
   same `matrixRowFilterText` and `matrixSampleFilterText` state, but the dead
   controls should be removed or restored. Independently confirmed, as the
   author reported.

3. **Smart Cohorts is doubly disabled on a genotype-only result.**
   `GenotypeResultDocumentSection.swift:396-398` omits the section from
   `visibleComponents` unless `hasHaplotypingResult`, and separately `:477-485`
   guards select, delete, and add on the same flag. The second guard is
   unreachable given the first. Not user-visible, but it means the empty-state
   string `No saved cohorts.` and the `Save Current Filter…` button can never
   appear on the result shape where a saved filter would be most useful, since
   the underlying `GenotypeAnnotationStore` supports user cohorts regardless of
   haplotyping. Worth deciding whether saving a filter should be allowed on a
   genotype-only result.

4. **The cohort summary's second section title renders its threshold, not a
   letter.** `GenotypeCohortSummaryPanelView.swift:119` builds the title through
   `formatThreshold`, so the default 5,000 renders as `Below 5.0K reads`. Not a
   defect, but it means no surface anywhere shows a literal `Below N reads`, and
   both the map and the chapter quote it that way.

## Notes for the editor

Four DRIFT rows are wrong and the author is right about all four. Rows 3.13,
3.18, 3.23, 3.24, and 3.25 should be corrected in the map:

- **3.13** records the fixed Budde 2010 M-family palette as true. On a
  genotype-only result `fillColor` returns flat `systemBlue` at alpha 0.20 for
  every filled cell (`GenotypeComparisonMatrixView.swift:5815-5820`).
- **3.18** says four cohort-summary sections. There are five
  (`GenotypeCohortSummaryPanelView.swift:112-128`), and row 3.19 already
  contradicts 3.18 by naming "the two low-coverage tallies".
- **3.23** asserts `Needs Review` with a capital R from
  `GenotypeSmartCohortSection.swift:118`, which is inside a `#Preview` block.
  The real seed list at `GenotypeAnnotationStore.swift:268-299` uses lowercase
  `Needs review` and carries four cohorts, not one.
- **3.24 and 3.25** record the matrix filter field and All Loci popup as true.
  Both are hidden at build. See App defect 2.

The map also has a gap the author identified correctly. Neither the sample
curation workbench, nor its four header metrics, nor the Call-support check and
its 1,000-read and 20-alignment thresholds appears anywhere in the map or
DRIFT, and the map's `genotype-call-evidence` screenshot row assumes a panel
(`GenotypeCallEvidenceView`) that a genotype-only result never shows. The
chapter documents the right surface.

Five things the chapter should change, in order of consequence.

1. **Step 2 describes a panel the reader cannot open.** This is the largest
   problem in the chapter and it is not the author's error, because the map
   gave no warning. On a genotype-only result the detail pane is blank until a
   sample is selected. Every fact in step 2 is true of the code that builds the
   cohort summary and false of what a Williams reader sees. The section should
   either be cut, with the low-coverage judgement moved into the CLI section
   where `list-samples` genuinely delivers it, or rewritten to say the summary
   appears on a haplotyped result and that a genotype-only reader gets the same
   information from `genotype list-samples`. Claims 7, 22, 31, and 54 all
   follow from this one root cause.

2. **The Smart Cohorts paragraph in step 4 should go or be rewritten.** The
   section is not rendered on this result shape (claim 45), the button is inert
   (claim 47), and it lives in the Bundle tab rather than "above" Genotype
   Display. The `smart-cohort` glossary entry is fine and can stay, since it is
   correct about the seeding behaviour.

3. **Name the Inspector tabs.** See Consistency item 1. Two one-word additions
   fix it.

4. **Resolve the shot-id collision with chapter 01.** See Front matter.

5. **Small wording fixes.** The cohort-summary section heading is `Below 5.0K
   reads` rather than `Below N reads` (claim 24). The Rows and Columns menu
   items name their axis (claim 61). The call-support caveat names haplotype
   assignments specifically (claim 35).

Two things worth keeping exactly as they are. The chapter's treatment of the
flat blue tint ("That tint carries no meaning beyond the cell being filled") is
right and corrects the map. The reading order it argues for, read the depth
before the biology, is the correct judgement for this assay and is well made.

Nothing was verified by driving the window. Every layout claim rests on source
reading plus the bundle's data, so the Screenshot Scout should confirm defects
1 and 2 visually, in particular whether the detail pane is truly blank on
opening and whether the matrix carries no filter row of its own.

## Counts

80 claims checked. 73 true, 7 false. Four of the true verdicts carry a wording
caveat noted in the Corrected wording column (claims 5, 24, 35, 61). 0
unverifiable, though the Errors section's vocabulary was not traced because the
Williams result has no errors and the chapter correctly hedges it.

False claims: 7, 22, 31, 45, 47, 54, 77. That is seven rows, of which 7, 22,
31, and 54 share one root cause, the unreachable cohort summary, and 45, 47,
and 77 share a second, the unrendered Smart Cohorts section.

Four app defects recorded, three of them user-visible. Five DRIFT rows to
correct. Lint green.
