# Fidelity review: 09-genotyping/04-haplotype-definitions-and-export

Chapter "Exporting Genotypes", roster row 56, registry id `genotype.export`.
Reviewed 2026-09-07 against Preview 2026.9.13, the Swift source, the live
`.build/debug/lungfish-cli`, and `docs/user-manual/parameters.yaml`.

Every export was rerun into this reviewer's own scratch folder at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/rev-export/`
against the same bundle the author used, `amplicon-genotyping_3.lungfishgenotype`,
and every workbook, sheet, header, and row count below was read back out of the
produced files rather than taken from the author's report or from a CLI summary.
Nothing in the Williams project was written or modified.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| Front matter `title: Exporting Genotypes` | true | Matches roster row 56 and `mkdocs.yml:138`, which already carries the same label | |
| `parameters_refs: [genotype.export]`, and the id exists | true | `parameters.yaml:6151` defines `genotype.export` with 11 `settings` and 8 `cli_only` | |
| Four export shapes: matrix XLSX, pivot XLSX, CSV/TSV, LabKey CSV set | true | All four produced. `export-xlsx`, `export-pivot-xlsx`, `export --export-format csv\|tsv`, `export-labkey` | |
| A genotype result bundle is a `.lungfishgenotype` folder holding read counts, a workbook, run statistics, and provenance | true | Bundle holds `artifacts/workbooks/current.xlsx`, `genotype-result.json`, provenance sidecars | |
| Nothing in the chapter changes a call; the export is `inspectOnly` | true | `GenotypeExportXlsxSubcommand.swift:22-25`, "provenance-`inspectOnly` (`cli.genotype` policy) — it never modifies the bundle or its sidecar" | |
| Filtering removed 192 of 305 allele rows at a modest threshold | true | Rerun at `--min-reads 50 --min-percent 5`: `removedAlleleRowCount` 192, `matchedAlleleRows` 305 | |
| On a genotype-only result the viewport's **Actions** menu is hidden, and with it **Export Excel View...** | true | `GenotypeResultViewController.swift:2945` `presentationActionsButton.isHidden = presentationChoices.isEmpty`; `:605-610` returns `[]` unless `appliesToHaplotypedMiSeq` | |
| The Actions menu belongs to the haplotype presentation controls | true | `:2663-2683` builds it with title "Actions", accessibility label "Haplotype analysis actions", items AI Discovery, AI Refinement, Export Excel View… | |
| The Williams result is a genotype-only result | true | `:590-596` `isGenotypeOnlyResult`; consistent with chapters 01 and 03, which read `workflowMode: genotypeOnly` | |
| If a result carried haplotype analysis, the Actions menu is visible and both routes are open | true | Same gating read the other way at `:605-610` | |
| The Export block sits at the foot of the Inspector's **Genotype Display** section | true | `GenotypeResultDisplaySection.swift:1271-1286` `exportControls`, heading "Export", after the search fields, numeric filters, and colour controls in the `:1218-1252` body order | |
| The section states "Visual filters do not change genotype calls." | true | `GenotypeResultDisplaySection.swift:1243`, verbatim | |
| The caption states the copy is one-way | true | `:1281` "The copy is a one-way export: edits made to it in Excel do not flow back into this result." | |
| The save panel suggests a filename ending in `-filtered-pivot.xlsx` | true | `GenotypeResultViewController.swift:9688` `filenameSuffix: "filtered-pivot"`; `:9694` panel title "Export Genotype View"; `GenotypeViewportExportService.swift:36` `.pivotExcel` extension `xlsx` | |
| The export writes a complete copy of the workbook with exactly one sheet changed | true | Byte-compared the two pivot workbooks entry by entry. Only `xl/worksheets/sheet1.xml` and `docProps/core.xml` differ; sheets 2 to 6 are byte-identical | |
| Header band of three rows, `Animal ID`, `GS ID`, `Filtered exact-match read count` | true | Pivot sheet rows 1 to 3, read back | |
| Total 682,927 reads across 30 samples, average 22,764 | true | Row 3 cells B and C read 682927 and 22764.2333…; 30 sample columns | |
| "the individual samples range from 713 to well over forty thousand" | **false** | Row 3's 30 per-sample values run from **2** (WD18_S165_L001 and WD22_S169_L001) to **58,370** (WD2_S149_L001). 713 is column D, the first sample alphabetically, not the minimum. Ten samples fall under 5,000 | "the individual samples range from 2 reads to over fifty-eight thousand" |
| The middle band is empty haplotype rows labelled `MHC-A Haplotype 1`, `MHC-A Haplotype 2` "and so on through eight loci" | **false** | Rows 6 to 19 are 14 rows over **seven** distinct loci, MHC-A, MHC-B, MHC-DRB, MHC-DQA, MHC-DQB, MHC-DPA, MHC-DPB. Source `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:1271-1280` fixes the fallback list at exactly those seven. Fourteen rows at two slots each is seven loci, not eight | "and so on through seven loci" |
| Those rows are blank on a genotype-only result | true | All 14 rows carry only the label cell, `cells=1`, in both the filtered and unfiltered workbook | |
| The bottom band begins with a row headed `Genotype` labelling `Total` and `# Obs.` before the sample columns | true | Row 21 reads `Genotype`, `Total`, `# Obs.`, then 30 sample names | |
| Exporting at Min reads 50 and Min percent 5 blanked 1,478 values and removed 192 rows, leaving 113 of 305 | true | Rerun summary `filteredAlleleValueCount` 1478, `removedAlleleRowCount` 192; allele rows counted in the sheets, 305 and 113 | |
| `01_Mamu-A1_002g` carried Total 929 across 5 observations, and reads 927 across 3 after filtering | true | Row read from both workbooks: `929, 5, 1, 301, 1, 95, 531` and `927, 3, 301, 95, 531`. Two single-read values blanked, totals recomputed | The chapter shortens the target name; the full cell is `01_Mamu-A1_002g\|A1_002_01_01_01,A1_002_01_01_02`. Acceptable in prose |
| The workbook carries five further sheets | true | Six sheets total: the pivot, Long Summ, Sample Su, `Run Stats`, `Overrides`, `Audit Log` | |
| A long summary sheet holds one row per sample-and-allele pair, 2,109 rows | true | Sheet 2 dimension `A1:J2110` | |
| A sample summary sheet gives one row per sample | true | Sheet 3 dimension `A1:G31`, 30 data rows | |
| A `Run Stats` sheet lists settings and counters as name-and-value pairs | true | Sheet 4 `A1:B42`, header `metric`/`value`, first rows `allowIndels 1`, `assignedUniqueRetainedReads 682927` | |
| `Overrides` and `Audit Log` hold only their header row on an unreviewed result | true | Sheets 5 and 6 dimensions `A1:I1` and `A1:P1` | |
| `genotype export`'s `--export-format` chooses among `xlsx`, `csv`, `tsv` | true | CLI help, live: "(values: xlsx, csv, tsv; default: xlsx)" | |
| The XLSX it writes is the matrix workbook, the same file `export-xlsx` produces | true | `GenotypeExportXlsxSubcommand.swift:22-25` names the shared `GenotypeXlsxWorkbookWriter` "also used by the unified `genotype export` subcommand" | |
| The matrix workbook holds four sheets, `Matrix`, `Legend`, `Overrides`, `Audit Log` | true | Read back from `matrix.xlsx`, in that order | |
| `Matrix` puts one row per sample and two columns per locus headed `H1` and `H2`, with a two-row header | true | Row 1 `Sample`, then each locus with a blank merge cell; row 2 `H1`/`H2`; rows 3 to 32 the 30 samples | |
| `Legend` lists `M1` through `M7` with hex colours, an `ERR` token, and a `(blank)` entry meaning absent or unanalyzed | true | Legend rows 2 to 10 read back: M1 to M7, `ERR`/`Error / no call`, `(blank)`/`Absent or unanalyzed`. Source `GenotypeExportXlsxSubcommand.swift:12-16` | |
| CSV and TSV are the matrix flattened, 27 columns, `Sample` plus H1/H2 for 13 loci, 30 data rows | true | Reran to a plain path. 31 lines, 27 comma-separated columns, header `Sample,MHC-A H1,…,MHC-J H2` | |
| `export-labkey` writes five CSV files into a directory you name and takes no tuning options | true | Live help shows only `--bundle` and `--output-dir`. Rerun wrote all five | |
| The five names are `haplotype_calls.csv`, `allele_read_counts.csv`, `overrides.csv`, `audit_log.csv`, `smart_cohorts.csv` | true | Listed in the rerun summary and on disk | |
| `allele_read_counts.csv` carried 2,109 data rows under the quoted header | true | 2,110 lines, header `animal_id,gs_id,allele,locus_group,unique_reads,passed_unique_reads,passed_alignments`, verbatim | |
| The other four carried their header row and nothing else | true | All four are 1 line | |
| `export-pivot-xlsx` prints `matchedAlleleRows`, `filteredAlleleValueCount`, `removedAlleleRowCount` | true | All three keys present in both rerun summaries | |
| Unfiltered reported 305 matched, 0 filtered, 0 removed; filtered reported 305, 1,478, 192 | true | Both reruns reproduced these exactly | |
| The matched-row count does not change because it counts what the result holds | true | 305 in both runs despite 192 rows being removed | |
| The Williams exports all report a sample count of 30 | true | `export-xlsx` `sampleCount` 30, both pivots `sampleCount` 30, `export` returned 30 `sampleColumns` | |
| 7 of those samples were too thin to call much | true | Consistent with chapter 03:160, "In the Williams run that is 7 of 30" | This reviewer counts 10 samples under 5,000 retained reads, so the figure depends on the app's own low-coverage threshold rather than an arbitrary cut. Consistent with the sibling, so left as true |
| `export-xlsx` summary read `sampleCount` 30, `locusCount` 13, `overrideCount` 0, `auditEntryCount` 0 | true | Rerun reproduced all four | |
| `--min-reads`, `--min-percent`, `--percent-basis` mirror the Inspector controls, `--keep-empty-rows` suppresses row removal, `--source-workbook` names the workbook | true | Live help for `export-pivot-xlsx` carries all five with those descriptions | |
| The Inspector's Percent Basis defaults to Viewed Locus while `--percent-basis` defaults to `sample-retained` | true | `GenotypeResultDisplayState.swift:106,127` default `.viewedLocus`; live help "default: sample-retained"; the unfiltered rerun reported `percentBasis: sample-retained` with no flag given | |
| `export-labkey` takes an output directory and creates it if missing | true | Live help, "Directory to write the LabKey CSV files into. Created if missing." | |
| `genotype export` fails when the output path sits under `/private/tmp` or another symlinked directory, writes no file | true | Reproduced. Exit 1, `Error: The provenance publication artifact no longer matches the transaction generation at /tmp/…/x.csv.lungfish-provenance.json.` No `x.csv` written; a zero-byte `.lungfish-genotype-export-publication.lock` left behind | |
| The other three exporters are unaffected | true | `export-xlsx`, `export-pivot-xlsx`, and `export-labkey` all succeeded under the same `/private/tmp` path | |
| Writing to a plain path succeeds | true | The same command to a non-symlinked path exited 0 and wrote a valid 31-line CSV | |
| Two exports of the same logical workbook hash differently, so no determinism claim is made | true | The two pivot workbooks differ in `docProps/core.xml`, an embedded timestamp. The author's removal of the determinism claim is correct and the chapter makes none | |
| Glossary: six new terms added, twenty `glossary_refs` anchors | true | All 20 anchors resolve to exactly one `{#anchor}`. The six new ones are `audit-log:45`, `csv:155`, `long-format:351`, `override:449`, `pivot-workbook:481`, `xlsx:729` under a new `## X` section, each one sentence and correctly alphabetised | |
| Three shot markers, each paired with a `shots` entry and caption | true | `genotype-inspector-export:67`, `genotype-export-save-panel:73`, `genotype-pivot-workbook:81`, all three declared in front matter | |
| No shot id collides with `genotype-matrix-overview`, `genotype-inspector-display`, or chapter 02's ids | true | Those two belong to chapters 01 and 03. Chapter 02 owns five ids, all prefixed `genotyping-`. No overlap | |
| The `Filtered Pivot...` shot caption describes a Filtered Pivot button and a one-way caption | true | Both exist at `GenotypeResultDisplaySection.swift:1276-1281` | |
| The save-panel shot caption names the `-filtered-pivot.xlsx` suffix | true | `GenotypeResultViewController.swift:9688` | |
| The pivot-workbook shot caption describes samples across the columns and allele targets down the rows beneath `Total` and `# Obs.` | true | Row 21 header and the allele rows beneath it | |
| Haplotype placeholder is CONSISTENCY's fixed two-sentence form | true | `CONSISTENCY.md:117-120` gives the exact two sentences; chapter lines 173 match verbatim under the fixed heading | |
| All 11 registry `settings` have a Settings paragraph, and all 8 `cli_only` flags | true | 19 paragraphs counted, one per registry entry, labels verbatim. Lint's `settings-coverage` rule passes | |
| **Min reads** default 0, whole number 0 to 100,000, flag `--min-reads` | true | `GenotypeNumericFilterDraft.swift:106-118` label "Min reads", `bounds: 0 ... 100_000`, `step: 1` | |
| **Min percent** default 0, 0 to 100 in steps of 0.5, flag `--min-percent` | true | `GenotypeNumericFilterDraft.swift:120-132` label "Min percent", `bounds: 0 ... 100`, `step: 0.5` | |
| **Percent Basis** offers Viewed Locus and Sample Retained, default Viewed Locus, flag `--percent-basis` | true | `ONTGenotypeResultBundle.swift:735-747` display names; `GenotypeResultDisplayState.swift:106` default `.viewedLocus`; picker at `GenotypeResultDisplaySection.swift:1566` | |
| **Alleles** starts empty, any text, flag `--filter` | true | `GenotypeResultDisplaySection.swift:1438` `TextField("Alleles"…)`; registry maps it to `--filter` | The chapter's "narrows a 970-row matrix to the DRB targets alone" is consistent with chapter 03's verified 970-row, 222-DRB figures |
| **Samples** starts empty, any text, flag `--sample`, repeatable and an exact-name restriction | true | `GenotypeResultDisplaySection.swift:1444` `TextField("Samples"…)`; live help "Restrict to this sample (repeatable)." The chapter correctly flags that the field is a substring match while the flag is not | |
| **Show All Rows** is chosen from the **Rows...** menu and disabled while no rows are hidden | true | `GenotypeResultDisplaySection.swift:1601-1617` `Menu("Rows…")` with Hide Selected Rows, Show Only Selected Rows, a divider, and Show All Rows `.disabled(!…canShowAllRows)` | |
| **Show All Columns** is chosen from the **Columns...** menu and disabled while no columns are hidden | true | `:1620-1638`, the same shape for columns | |
| **Cell Color** offers Support, Highlights, None, default Support | true | `GenotypeResultDisplayState.swift:83-84,107` `cellColorMode` default `.support`; picker at `GenotypeResultDisplaySection.swift:1659-1662` | |
| **Filtered Pivot....** appears only when the result carries a workbook the pivot can be built from | true | `GenotypeResultDisplaySection.swift:105` `canExportFilteredPivot` is `onFilteredPivotExportRequested != nil`, set when a viewport is bound | The registry's own gloss is "shown only when the result carries a workbook the pivot can be built from"; source gates on viewport binding. Close enough to stand, but see Notes |
| **Export Excel View....** is an Actions menu item, hidden on a genotype-only result | true | `:2678` menu item; `:2945` hides the button | |
| **Update and View Current Excel Version** is a button in the Inspector's **Current Workbook** block, disabled while the workbook is current or the bundle is read-only | true | `GenotypeResultDocumentSection.swift:578-599`, `DisclosureGroup("Current Workbook"…)`, `.disabled(!update.isEnabled)`, caption "Writes displayed haplotype calls, matrix annotations, Overrides, and Audit Log worksheets." | |
| The eight `cli_only` flags and their defaults as stated | true | Each checked against live help. `--export-format` default xlsx, `--view-projection` none, `--lens` none, `--annotations` defaults to the bundle's `annotations.json` when present, `--active-haplotype-definition` none, `--keep-empty-rows` off, `--source-workbook` defaults to `current.xlsx` else the primary workbook, `--force` overwrites | |
| No registry entry is missing from the chapter | true | All 11 settings and all 8 cli_only accounted for, one paragraph each | |
| The chapter's `--keep-empty-rows` advice, "would break if 192 rows vanished" | true | The 192 figure is this result's, and the flag does suppress the removal per live help | |

## Front matter

Correct and complete. `title` is the roster title and agrees with `mkdocs.yml:138`.
`chapter_id` matches the path. `prereqs` names chapter 03, which is the chapter
this one depends on. `parameters_refs` and `features_refs` both carry
`genotype.export`, which exists at `parameters.yaml:6151`. `tools: []` is right,
since no managed third-party tool is invoked. `estimated_reading_min: 14` is
plausible for the length. `glossary_refs` lists 20 anchors and every one resolves
to exactly one definition. `shots` declares three ids and all three have a
matching `<!-- SHOT: -->` marker in the body, with no orphan markers. No
`planned_shots` key survives, correctly, since the four planned shots of the old
chapter were all retired. `brand_reviewed: false` and `lead_approved: false` are
the right state for a chapter entering review.

The retitle is complete on this chapter's side. The old title survives in one
place the author correctly declined to touch, chapter 03's Next section at
`03-reading-the-genotype-comparison.md:209`. Chapter 01 has since been updated
and now uses "Exporting Genotypes" at both `:134` and `:153`, so chapter 03 is
the only outstanding site, not two as the author's report says.

## Consistency

Consistent with `CONSISTENCY.md` on every rule this chapter touches.

The haplotyping placeholder is the fixed two-sentence form at `CONSISTENCY.md:117-120`,
reproduced verbatim under the fixed heading. The Settings shape follows the
fixed order of effect, default, allowed values, when to change, then the flag
sentence, and every no-flag paragraph closes with "This setting has no
command-line flag." per `CONSISTENCY.md:97-99`.

The Inspector-route rule at `CONSISTENCY.md:28-32` governs the Inspector's
Analysis section, whose six tabs are named in prose as "the Inspector's Consensus
tab" rather than as a path. This chapter's surface is the Inspector's **Genotype
Display** section, not one of those six tabs, and the chapter names it in prose
as "the Inspector's **Genotype Display** section", which is exactly how the
sibling chapter 03 names it at `:116` and `:136`. The path form
`Inspector > Genotype Display > Filtered Pivot...` appears only in front-matter
`entry_points`, which the same rule explicitly permits as metadata. Compliant.

Terms agree with the siblings. Both chapters use "allele target", "retained
read", "the Williams MiSeq genotyping project", and "genotype-only result" in the
same senses. The 970-row matrix, the 305 called rows, the 2,109 filled cells, and
the 7-of-30 thin samples are all shared figures and all agree.

One divergence worth the editor's eye rather than a correction. Chapter 03:154
closes its Filtered Pivot paragraph with "On the command line this is
`lungfish-cli genotype export-pivot-xlsx`", while chapter 04:129 says "This
setting has no command-line flag, though `lungfish-cli genotype
export-pivot-xlsx` writes the same file." Chapter 04's form matches the
registry's `cli_flag: null` and the fixed no-flag sentence, so chapter 04 is the
one in the right and chapter 03 is the one that drifts. Flagging for whoever
gates row 55, not for this author.

## App defects

Four, three of them confirmed reproductions of the author's findings and one new.

**1. Confirmed. On a genotype-only result there is exactly one reachable in-app
export.** `GenotypeResultViewController.swift:605-610` returns an empty
`presentationChoices` unless `appliesToHaplotypedMiSeq`, and `:2945` hides the
Actions button on that emptiness, taking `Export Excel View…` with it.
`availableLenses` at `:598-603` still returns `.audit` for a genotype-only
result, so the Audit lens and its `Share View` block are built, but `:2944` hides
the lens control and `:692-700` redirects a genotype-only result to `.summary`,
so nothing can select it. The lens is constructed and unreachable. DRIFT row 4.32's
correction, "The viewport offers two in-app exports", is therefore true only of a
haplotyped result and the chapter is right to say otherwise. The registry's
`entry_points` still lead with the Actions route, which is unreachable on the
documented fixture. Worth deciding whether `availableLenses` should stop
returning `.audit` for genotype-only results, or whether the lens should become
reachable.

**2. Confirmed. `genotype export` fails under a symlinked output path.**
Reproduced first attempt. The requested output was
`/private/tmp/.../rev-export/x.csv` and the error named
`/tmp/.../rev-export/x.csv.lungfish-provenance.json`, so one side of the
publication comparison resolves the symlink and the other does not, and they can
never match. Exit code 1, no output file, and a zero-byte
`.lungfish-genotype-export-publication.lock` left in the directory. The same
path took `export-xlsx`, `export-pivot-xlsx`, and `export-labkey` without
complaint, so the fault is in `GenotypeExportSubcommand`'s publication path
rather than the shared provenance layer. On macOS this blocks CSV and TSV export
for any output under `/tmp`, which includes everything `mktemp -d` produces. The
chapter documents the workaround accurately.

**3. Confirmed, with a correction to its scope. The pivot workbook writes an
empty haplotype band on a genotype-only result.** Rows 6 to 19 of the pivot sheet
carry labels and no values, in both the filtered and unfiltered workbook. The
band is **14 rows over seven loci**, not eight. `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:1271-1280`
fixes the fallback list at MHC-A, MHC-B, MHC-DRB, MHC-DQA, MHC-DQB, MHC-DPA,
MHC-DPB, and `:2276-2278` writes two rows for each. The author's report, the
chapter, and the task brief all say eight. The underlying oddity stands and is
worth fixing: the band's locus list is hard-coded rather than derived from the
run, so a workbook whose data covers 13 loci shows a haplotype band for seven
unrelated ones.

**4. New, minor. The `GenotypeExportXlsxSubcommand.swift` misspelling is not
confined to the reality map.** The author reported the map citing
`GenotypeExportXLSXSubcommand.swift` with `XLSX` capitalised where the file on
disk is `GenotypeExportXlsxSubcommand.swift`. The same wrong casing also appears
in `docs/user-manual/parameters.yaml:6168`, in the `genotype.export` registry
entry's own `sources` list, and twice in `DRIFT.md` at `:2982` and `:2983`, as
well as at five places in the reality map. The registry is the campaign's
canonical source list, so the bad path there will send every later reader of this
operation to a file that does not exist. Worth one sweep across all three files.

## Notes for the editor

**Two corrections are owed to the chapter body.**

The read-count range at line 83 is wrong. "the individual samples range from 713
to well over forty thousand" should read "from 2 reads to over fifty-eight
thousand". The true minimum is 2, carried by two samples, and the maximum is
58,370. This is not a rounding quibble. The sentence is doing rhetorical work,
introducing how uneven the run was before the reader meets the filters, and 713
makes the worst samples look four hundred times healthier than they are. It also
sits two paragraphs from the claim that 7 samples were too thin to call much,
which a reader will find hard to square with a floor of 713.

The locus count at line 85 is wrong. "and so on through eight loci" should read
"through seven loci". Fourteen rows at two slots each is seven, and the source's
fallback list has exactly seven entries.

**Three things worth the editor's judgement rather than a correction.**

The chapter shortens the worked allele target to `01_Mamu-A1_002g` where the cell
actually reads `01_Mamu-A1_002g|A1_002_01_01_01,A1_002_01_01_02`. That is a fair
shortening for prose, and chapter 01 establishes the naming, but a reader who
opens the workbook looking for that exact string will not find it. One clause
saying the name continues past the pipe would close the gap.

The `Filtered Pivot....` Settings paragraph says the button "appears only when
the result carries a workbook the pivot can be built from", which is the
registry's own wording. Source gates it on `onFilteredPivotExportRequested != nil`,
which is set when a viewport is bound rather than on a workbook being present.
The two coincide in practice and the registry is the authority the campaign
names, so the paragraph stands, but the registry gloss is the looser of the two.

The determinism removal is correct and the evidence is now stronger than the
author had. The two pivot workbooks I produced differ in exactly one non-sheet
entry, `docProps/core.xml`, which is the embedded timestamp. That is direct
evidence for the non-reproducibility DRIFT row 4.45 left open, from two runs of
the *same* subcommand rather than two different ones. The row can be closed as
"not byte-reproducible, by embedded timestamp" if the campaign wants it closed.

**Unverifiable, and what would settle each.** The three shots were not captured
and cannot be judged beyond their captions, which all describe surfaces that do
exist. A screenshot pass on a genotype-only result would settle them, and should
confirm defect 1 while it is there, since a scout who opens a haplotyped result
will see a different set of export controls. `Export Excel View...` and `Update
and View Current Excel Version` were never pressed by either the author or this
reviewer, and both are documented from source plus the CLI equivalents. The
merge-overrides-before-export behaviour was never seen on a non-empty file,
because this fixture carries no overrides and no audit entries, so every
annotation-bearing output is header-only. A reviewed result would settle it.

## Counts

62 true, 2 false, 0 unverifiable in the claim table.

Chapter body corrections owed: 2, both at Step 2, both numeric.

App defects: 4. Three confirmed from the author's report, one of those with its
scope corrected from eight loci to seven. One new, the wrong-cased source path in
`parameters.yaml` and `DRIFT.md` as well as the reality map.

Retitle sites outstanding: 1, `03-reading-the-genotype-comparison.md:209`.

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh` on
this chapter prints `no issues found`.
