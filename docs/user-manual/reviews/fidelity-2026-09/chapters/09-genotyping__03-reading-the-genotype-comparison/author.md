# Author report: 09-genotyping/03-reading-the-genotype-comparison

Roster row 55. The result-reading chapter of the Genotyping part. Rewritten in
place against Preview 2026.9.13 on 2026-09-07.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/09-genotyping/03-reading-the-genotype-comparison.md
```

Result, verbatim, on the first run and unchanged after the glossary edits:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/03-reading-the-genotype-comparison.md: no issues found
```

Chapter 01 was re-linted after the glossary edits and is still clean.

## Section order chosen

What it is, Why you would do this, Before you start with the result open,
Procedure (five steps), Settings (headed "Settings, the controls of the result
window"), Reading the results, What good looks like, Haplotype analysis
(placeholder), On the command line, Next.

This is the order the task named, which is the standard template with the
Procedure repurposed as a viewport walk and the Settings section relabelled to
say it documents the controls of a result window rather than the parameters of
an operation. Three notes on placement.

- **Settings before Reading the results.** The template's order. It also works
  here because Min reads, Min percent, and Percent Basis are the controls a
  reader reaches for while forming the judgement Reading the results describes,
  so meeting them first makes that section shorter.
- **The haplotyping placeholder sits after What good looks like** rather than
  in the concept run, because the whole chapter is about a genotype-only
  result and the placeholder is the one place haplotypes are mentioned. It is
  CONSISTENCY's fixed two-sentence form, verbatim, under the fixed heading.
- **On the command line** carries chapter 33's fixed opening paragraph with
  "the dialog" swapped for "the window", per CONSISTENCY. Both commands in it
  are read-only, which the section says.

Sections deliberately dropped:

- **What you will learn.** Present in the old text, restated the front matter's
  `task`, and no committed model chapter carries one.
- **Switching lenses.** The old chapter's H2 for the three-lens control. The
  control does not exist on a MiSeq result, and on a genotype-only result no
  view selector is shown at all, so the surviving fact is one paragraph in
  Before you start rather than a section.
- **Interpretation.** Renamed to Reading the results to match the committed
  classification chapters and the template.

## Commands run

Every command ran from the worktree. All output was written under the
scratchpad directory the task named. Nothing in the Williams project was
written, moved, or copied out.

| # | Command | Exit | Figures taken from it |
|---|---|---|---|
| 1 | `.build/debug/lungfish-cli genotype list-samples --bundle "…/Analyses/Amplicon genotyping results/amplicon-genotyping_3.lungfishgenotype"` | 0 | 30 sample rows; the five column names; `qc_status` values `ok` (23) and `lowSupport` (7); retained-read ranges 1,976–58,370 and 2–713; 11–13 loci per ok sample and as few as 2 per lowSupport sample; the 13 locus names; the `MHC-A=…;MHC-AG=…` shape of `top_calls_by_locus` |
| 2 | `.build/debug/lungfish-cli genotype list-cohorts --bundle "…/amplicon-genotyping_3.lungfishgenotype"` | 0 | The header line `starred name scope matches description` and **no data rows**, which is the evidence that a genotype-only result seeds no smart cohorts |
| 3 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/09-genotyping/03-reading-the-genotype-comparison.md` | 0 | the lint line above |
| 4 | Same lint on `01-what-is-mhc-genotyping.md` | 0 | confirmed the glossary edits broke nothing |

Command 1 reproduces the sibling author's figures exactly, which is a useful
independent check that both of us read the same bundle correctly.

## What was read from the Williams project

Read-only throughout. `amplicon-genotyping_3.lungfishgenotype` was used as the
representative bundle, the same one chapter 01 used, so the two chapters quote
one result rather than two.

- `Analyses/Amplicon genotyping results/`. Seven `.lungfishgenotype` bundles
  from repeated runs (`amplicon-genotyping`, `_1`, `_2`, `_3`, `finalcheck`,
  `spacefix`, `spacefix2`).
- `…/amplicon-genotyping_3.lungfishgenotype/genotype-result.json`. `kind` and
  `workflowKind` both `miseq-amplicon-mhc-genotype`; **`workflowMode` is
  `genotypeOnly`**. This single field is what decides the entire shape of the
  window this chapter describes, via `GenotypeManualHaplotypeEligibility`. Also
  records three workbook revisions and `currentWorkbookPath`
  `artifacts/workbooks/current.xlsx`.
- `…/artifacts/projections/genotype-reviewable-rows.json`. The matrix's own
  shape, and the source of every matrix figure in the chapter. **970 rows and
  30 samples**, all of `kind` and `section` `reference`. Counted directly:
  **2,109 filled cells of 29,100**, and **305 of 970 rows carry a call in at
  least one sample**. Support values run 1 to 16,505 with a median of 16. Rows
  per locus: MHC-B 342, MHC-DRB 222, MHC-A 160, MHC-DQB 57, MHC-DPB 48,
  MHC-AG 37, MHC-DQA 31, MHC-DPA 27, MHC-I 15, MHC-E 13, MHC-G 8, MHC-F 5,
  MHC-J 5.
- `…/amplicon-genotyping_3.retained-demux-samples.csv`. Per-sample
  `passed_alignments`, `passed_unique_reads`, and retained percentages.
  Evaluating `GenotypeCallSupportCheck.evaluate` by hand over these 30 rows
  gives **23 Meets thresholds and 7 Low support, and zero Review needed**,
  matching the `qc_status` split from command 1. That agreement is quoted in
  the chapter as the reassuring outcome.
- `…/amplicon-genotyping_3.retained-demux-genotypes.csv`. Header and first
  rows read to confirm the long-form shape and to take the real group-record
  allele name `05_Mamu-B17_01g1|B17_01_01_01,B17_01_01_02` quoted in Reading
  the results.
- `…/annotations.json`. Schema version 4. **Every annotation list is empty**
  (`matrixStyles`, `matrixComments`, `matrixReviews`, `cellHighlights`,
  `rowHighlights`, `cellComments`, `sampleNotes`, `sampleStatusFlags`,
  `callStatusFlags`, `callOverrides`, `manualHaplotypeAssignments`,
  `aiHaplotypeReviews`, `auditLog`, **`smartCohorts`**). The key names are the
  inventory of what the window's annotation surfaces write, and the empty
  `smartCohorts` corroborates command 2.
- `metadata.json` and the project root listing. Project
  `32566_MS267_Williams1`, 30 `.lungfishfastq` imports, the
  `26128_ipd-mhc-mamu-2021-07-09.lungfishref` allele library, and a
  `amplicon-genotyping_3-filtered-pivot.xlsx` at the project root with its own
  `.view-projection.json`, which is a real artefact of the Filtered Pivot
  export the Settings section documents.

No individual animal is named anywhere in the chapter body. The 970-target
library figure is carried over from chapter 01, which read the manifest.

## Source files consulted

`Sources/LungfishGenotypeUI/` unless noted.

- `GenotypeResultPresentationPolicy.swift:55-135, 151-162`. `choices` returns
  `[.genotypeMatrix]` for a genotype-only result and
  `[.haplotypeCalls, .genotypeMatrix]` only for a typed haplotyped MiSeq one.
  `defaultSummaryViewMode` returns `.matrix` for genotype-only.
  `persistencePolicy` returns `.sessionOnly` when read-only.
  `haplotypeCallsUnavailableExplanation` carries the malformed-analysis string.
- `GenotypeManualHaplotypeEligibility.swift:8-33`. `.eligible` requires the
  genotype-only workflow declaration **and** no haplotype analysis. This is
  the predicate behind `isGenotypeOnlyResult` and behind
  `manualHaplotypeEditingEligible` in the matrix, so the Williams bundle takes
  the genotype-only branch of both.
- `GenotypeResultViewController.swift:590-620`. `isGenotypeOnlyResult`,
  `availableLenses`, `presentationChoices` (empty unless
  `appliesToHaplotypedMiSeq`), and `viewportHeaderHeight` of **0** for a
  genotype-only result.
- `:2663-2683`. The `Actions` button and its three items, `AI Discovery`,
  `AI Refinement`, `Export Excel View…`.
- `:2700-2725` and `:2943-2962`. `lensControl.isHidden = isGenotypeOnlyResult
  || viewportSelectionCount <= 1` and `presentationActionsButton.isHidden =
  presentationChoices.isEmpty`. Both are hidden on a genotype-only result.
- `:1115-1155`. Cmd-F focuses the quick search, Escape clears it, and the four
  review shortcuts are gated behind `selectedLens == .review ||
  (appliesToHaplotypedMiSeq && a locus is selected)`.
- `:3920-3983`. The detail-pane switch. `showsSelectedCallEvidence` requires
  `appliesToHaplotypedMiSeq`, and `rawMatrixUsesSampleCurationDetail` is true
  for `isGenotypeOnlyResult`, so a genotype-only result shows the sample
  curation workbench rather than the call-evidence view.
- `:4740-4848` and `:4973-5027`. The workbench's construction and its four
  header metrics, `Selected Sample`, `Retained Unique Reads`,
  `Passed Alignments`, `Call-support check`.
- `:8040-8090`. `rebuildCohortSummary`, the QC row labels `OK`,
  `Low support`, `Needs review`, and `cohortFlagThreshold`.
- `:9634-9640` and `:9658-9689`. Block classification labels and the two export
  buttons, plus the comment stating the Audit lens is hidden for MiSeq results.
- `GenotypeSampleCurationWorkbenchView.swift:12-59`. `GenotypeCallSupportCheck`,
  its three titles, its 1,000-read and 20-alignment thresholds, and the caveat
  text quoted in step 3.
- `GenotypeSupportedAllelesPanel.swift:154`. The `Supported Alleles` heading.
- `GenotypeSampleComparisonPanel.swift:86, 357`. `Compare & Copy` and
  `Choose Haplotype Assignments`, both manual-haplotyping scope, read only far
  enough to confirm they are not part of the genotype reading path.
- `GenotypeCohortSummaryPanelView.swift:100-230`. **Five** sections built, the
  two `makeFlagSection` tooltips, the eight-sample cap with `(+N more)`, and
  the read-only banner text.
- `GenotypeQuickFilterBarView.swift:14-45, 121, 340-375`. The six pill labels,
  the placeholder `Search samples or alleles…`, and the `field=value` /
  `field:value` metadata syntax.
- `GenotypeSmartCohortSection.swift:44-105`. `Smart Cohorts` disclosure,
  `No saved cohorts.`, and `Save Current Filter…`. The `Needs Review` string at
  `:118` is inside a `#Preview` block only.
- `GenotypeAnnotationStore.swift:258-310`. The four seeded built-ins,
  `Incomplete haplotypes`, `Needs review`, `Homozygous`, `Recombinants`, and
  the `seedBuiltInSmartCohorts` gate.
- `GenotypeResultDisplaySection.swift:1204-1252`. The `Genotype Display`
  section's body order, and `showsViewportAndLayoutControls` being
  `!isGenotypeOnlyResult`.
- `:1344-1350`. The `Rows N of M` and `Hidden Cells` readout.
- `:1417-1430`. The `Run and Calling Thresholds` note quoted in step 1.
- `:1432-1571`. `Search and Support Filters` with the `Alleles` and `Samples`
  fields, the two numeric filters, `0 = Off.`, and the `Percent Basis` picker.
- `:1573-1650`. `Selected Rows and Columns`, the `Rows…` / `Columns…` menus,
  and `Reset Visibility`.
- `:1652-1745`. `Cell Color` and `Selected Highlight`.
- `:1268-1285`. `Filtered Pivot…` and its one-way-export caption.
- `GenotypeNumericFilterDraft.swift:106-130`. The labels **`Min reads`** and
  **`Min percent`**, bounds 0–100,000 and 0–100.
- `GenotypeResultDisplayState.swift:83-142`. `GenotypeResultCellColorMode`
  (`Support`, `Highlights`, `None`), `supportDenominator` defaulting to
  `.viewedLocus`, and `cohortFlagThreshold` defaulting to **5,000**.
- `GenotypeComparisonMatrixView.swift:468-485, 605-620`.
  `manualHaplotypeEditingEligible` set from the same eligibility predicate.
- `:1083, 1104`. The matrix's own `Filter genotypes, loci, or samples` field
  and its locus popup, **both `isHidden = true`** at build.
- `:1108`. The review legend `[n] False positive   ▣ False negative   ◥ Comment`.
- `:1484-1520`. The pinned columns `Genotype`, `Locus`, `Samples`, `Unique`.
- `:1636-1668`. The header context menu that toggles those four and any
  reference fields.
- `:2919-2970`. `cellValue`, giving the read count, the `[n]` false-positive
  form, and the `—` false-negative form.
- `:5790-5840`. `fillColor`. On the `manualHaplotypeEditingEligible` branch every
  filled cell gets a **flat** `systemBlue` at alpha 0.20, and the graded
  heatmap is the other branch.
- `GenotypeMatrixAnnotationSection.swift:14-300`. `Matrix Annotations`, its
  select-something empty state, the `annotations.json` and `current.xlsx`
  caption, `Review Annotation` with `False Positive` / `False Negative` /
  `Clear Review Mark`, `Comments`, `Fill` / `Text` / `Border`, `Clear Style`,
  and `Quick Colors`.
- `Sources/LungfishApp/Views/Inspector/InspectorView.swift:135, 251`. Confirms
  both genotype sections are hosted in the Inspector.
- `Sources/LungfishIO/Bundles/ONTGenotypeResultBundle.swift:735-747`. The
  `Viewed Locus` and `Sample Retained` display names.
- `Sources/LungfishIO/Bundles/GenotypeAnnotationSidecar.swift:306, 530, 677`.
  Matrix target and style shapes.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/genotype.txt`. The full
  subcommand inventory, `list-samples` and `list-cohorts` contracts, and the
  `--min-reads`, `--min-percent`, `--percent-basis` flags on
  `export-pivot-xlsx`.
- Lint rules read to confirm structure: `frontmatter.js`,
  `primer-before-procedure.js`, `settings-coverage.js`, `ai-tells-words.txt`.

Review inputs read in full: `ARCHITECTURE.md`, `CONSISTENCY.md`, the
`09-genotyping` reality map, this chapter's DRIFT section, chapter 01's body
and author report, `06-classification/03-running-esviritu.md`, and
`.claude/agents/bioinformatics-educator.md`.

## Corrected wordings applied

Every corrected wording in the chapter's DRIFT section is honoured, and several
are tightened further because the Williams result is genotype-only rather than
haplotyped. See defects for the four places the map is wrong.

- **3.2.** The three-region framing is gone. The chapter names the matrix, the
  filter bar, the Inspector, and the detail pane, and says the detail pane
  shows the cohort summary or one sample's evidence depending on selection.
- **3.3, 3.4, 3.6, 3.7.** No lens vocabulary survives. Before you start states
  that a genotype-only run shows **no selector at all** and a haplotyped run
  shows `Haplotype Calls` and `Genotype Matrix`, and tells a reader who cannot
  find a segment that the run did not haplotype.
- **3.5, 3.23.** No Review lens. The Smart Cohorts paragraph says a
  genotype-only result seeds no cohorts and shows `No saved cohorts.` with
  `Save Current Filter…`.
- **3.11.** Row names are the reference record, shown as
  `01_Mamu-A1_001_05_01_01`.
- **3.15, 3.16, 3.17, 3.27, 3.28, 3.29, 3.30, 3.31.** Every haplotyping row
  reduced to CONSISTENCY's fixed two-sentence placeholder. No tape, no H1/H2
  slots, no `?`, no rationale categories, no overcall guard, and the invented
  LF2840 example is gone.
- **3.18, 3.19.** The cohort summary is described with its real sections and
  the tooltip is scoped to the two low-coverage counts with its eight-sample
  cap.
- **3.20, 3.21, 3.22.** The search field matches samples and alleles, its
  placeholder is quoted, both `=` and `:` metadata forms are given, and the six
  pills are named with a note that four of them are inert on a genotype-only
  result.
- **3.26.** No `Showing N of M samples` banner and no column window. The chapter
  documents `Rows…` / `Columns…` and `Reset Visibility` as undoing hiding you
  applied yourself, and quotes the Inspector's own `Rows N of M` readout.
- **3.32.** Annotations are documented by their real Inspector controls.

## Missing rows covered

Every Missing row in the chapter's DRIFT section is addressed.

- The `Actions` menu with `AI Discovery`, `AI Refinement`, `Export Excel View…`.
  Named in Before you start as part of what a haplotyped run shows and a
  genotype-only run does not.
- The Inspector's `Genotype Display` section. It is the whole Settings section.
- `Percent Basis`, with both values, its default, and its CLI flag.
- Cmd-F and Escape. In step 4.
- The read-only session behaviour. The red banner and its text, at the end of
  step 5.
- The explanation shown when a saved haplotype analysis is empty or malformed.
  Folded into Before you start's paragraph on what the run produced, without
  quoting the string, since it cannot arise on a genotype-only result.
- `genotype list-samples` and `genotype list-cohorts`. Both run, both quoted
  with their real column headers and real output.
- The three replay commands and `apply-annotations`. Named in the final CLI
  paragraph with what each is for.
- `parameters_refs`. Carried as `[]`, matching roster row 55's empty column.

Rows deliberately not worked into prose, with the reason:

- **Weak calls at half opacity and override hatching**
  (`GenotypeHaplotypeTapeView.swift`). Both are properties of the haplotype
  tape, which the campaign decision puts in the placeholder.
- **The manual haplotype editor with its copy-candidate list.** The owner's
  constraint allows one sentence. It gets the closing sentence of Next, the
  same form chapter 01 used.
- **The candidate-allele evidence surfaces and the difference track.** These
  belong to the full-length ONT route, not to the MiSeq result this chapter
  reads.
- **Block classifications** (`Block coherent`, `Regional recombinant`,
  `Atypical`, `Unknown`). These are outline rows on a haplotyped result, and
  the outline is not shown on a genotype-only one.

## Shot markers

Four, all on windows a reader of a genotype-only result actually sees.

- `genotype-matrix-overview`. Kept from the planned list, recaptioned to say
  the row label is the reference record name, per the map's own correction.
- `genotype-cohort-summary`. Kept, recaptioned to name its **five** sections
  rather than the map's four. See defect 1.
- `genotype-call-evidence`. Kept and recaptioned away from "the rationale
  behind a called haplotype" to the sample header metrics and the
  Supported Alleles list, which is what this pane holds on a genotype-only
  result. See defect 2.
- `genotype-inspector-display`. New, replacing `genotype-haplotype-tape` and
  `genotype-manual-haplotyping`, both of which the map moves to the
  haplotyping placeholder. The Inspector is where every control in the
  Settings section lives, so the chapter needs a picture of it.

`genotype-haplotype-tape` and `genotype-manual-haplotyping` are dropped. No
`planned_shots` key survives, and all four markers have matching `shots`
entries with captions.

## Glossary

One term added, one corrected.

- **Added `smart-cohort`**, alphabetically before `smart-filter-token`. It is
  used in step 4 and had no entry, though `cohort` did.
- **Corrected `genotype-matrix`.** The entry promised "a haplotype tape, cohort
  summary, and per-sample evidence" as parts of the dashboard. The haplotype
  tape is not shown on a genotype-only result and belongs to the placeholder
  under the campaign decision, so the entry now names the matrix, the cohort
  summary, and the per-sample evidence, and uses the full app name at first
  mention as the other entries do. Chapter 01 was re-linted after the change
  and is still clean.

## Defects found

Four in the reality map or DRIFT, and one in the app.

1. **The cohort summary has five sections, not four.** DRIFT row 3.18 and the
   map's screenshot row both say four, naming "Low-coverage samples", "QC
   distribution", "Errors", and "Annotations".
   `GenotypeCohortSummaryPanelView.swift:113-128` adds five, because
   `Low-coverage samples` and `Below N reads` are two separate
   `makeFlagSection` calls, not one section with a subtitle. Row 3.19 gets this
   right when it says the tooltip applies to "the two low-coverage tallies",
   so the map contradicts itself. The chapter documents five.

2. **The call-evidence panel does not appear on a genotype-only result at
   all.** `GenotypeResultViewController.swift:3929-3934` gates
   `showsSelectedCallEvidence` on `appliesToHaplotypedMiSeq`, and
   `:3980-3983` routes a genotype-only result to
   `rawMatrixUsesSampleCurationDetail` instead. The detail pane a Williams
   reader sees is the **sample curation workbench** built at `:4788-4840`, with
   a four-metric header and a `Supported Alleles` list. Neither the workbench,
   the `Call-support check` verdict, nor its 1,000-read and 20-alignment
   thresholds appears anywhere in the map or DRIFT, and the map's
   `genotype-call-evidence` screenshot row assumes the wrong panel. This is the
   largest gap in the map for this chapter, and the chapter documents the
   workbench.

3. **The built-in smart cohort is `Needs review`, not `Needs Review`, and it is
   not seeded on a genotype-only result.** DRIFT row 3.23 asserts the capital
   R on the strength of `GenotypeSmartCohortSection.swift:118`, but that line
   is inside a `#Preview` block. The real seed list is
   `GenotypeAnnotationStore.swift:268-299`, which uses lowercase `Needs review`
   and adds three more (`Incomplete haplotypes`, `Homozygous`,
   `Recombinants`). Every caller passes `seedBuiltInSmartCohorts:
   hasHaplotypingResult`, so on a genotype-only result **nothing is seeded**,
   which `genotype list-cohorts` confirmed on the Williams bundle by printing
   a header and no rows.

4. **Cells on a genotype-only result are not coloured by M-family.** DRIFT row
   3.13 records the fixed Budde 2010 palette claim as true.
   `GenotypeComparisonMatrixView.swift:5815-5821` gives every filled cell a
   flat `systemBlue` at alpha 0.20 whenever `manualHaplotypeEditingEligible`,
   which is exactly the genotype-only case. The graded heatmap at `:5825-5836`
   is the other branch. The chapter says the tint means only that the cell is
   filled.

5. **App defect: the matrix's own filter field and locus popup are built and
   then hidden, and nothing unhides them.**
   `GenotypeComparisonMatrixView.swift:1090` sets `filterField.isHidden = true`
   and `:1104` sets `locusPopup.isHidden = true`. The only assignment of
   `false` anywhere in the file is `:8547`, inside
   `testingPerformNativeFilterAction`, a testing hook. DRIFT rows 3.24 and 3.25
   record the placeholder `Filter genotypes, loci, or samples` and the
   `All Loci` popup as true on the strength of those strings existing, but a
   user cannot see or use either control. The equivalent filtering is reachable
   through the Inspector's `Alleles` and `Samples` fields, which write the same
   `matrixRowFilterText` and `matrixSampleFilterText` state, so nothing is lost
   functionally. The chapter documents the Inspector fields and does not
   mention the hidden ones. Worth deciding whether the dead controls should be
   removed or restored.

## What could not be verified

- **The window was not driven.** No GUI session was run for this chapter, so
  every claim about layout rests on source reading plus the bundle's own data.
  The four shot markers are where the Screenshot Scout will settle whether the
  described layout matches the pixels, and defect 5 in particular deserves a
  visual confirmation that the matrix carries no filter row of its own.
- **The `Errors` section's contents.** `cohortErrorTypeCounts` was not traced
  to its vocabulary, because the Williams result has no errors, so the chapter
  says only that the section counts calls the run could not complete, by type.
- **The `Needs review` QC value in the wild.** The QC distribution's third row
  exists in `rebuildCohortSummary`, but no Williams sample carries it, so the
  chapter names the three values without claiming a count for the third.
- **The read-only banner.** Its text is quoted from source. The Williams bundle
  is writable, so the banner was not observed.
- **`Import Metadata` and the `field=value` search.** The Williams samples
  carry no imported metadata sheet, so the `Cohort=Kenyon20` example is the
  one from `GenotypeQuickFilterBarView.swift:351` rather than a query run
  against this fixture. The chapter presents it as syntax, not as a result.
