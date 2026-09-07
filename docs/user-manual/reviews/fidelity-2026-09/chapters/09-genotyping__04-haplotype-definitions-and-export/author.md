# Author report: 09-genotyping/04-haplotype-definitions-and-export

Roster row 56, registry id `genotype.export`, retitled "Exporting Genotypes".
Rewritten in place against Preview 2026.9.13 on 2026-09-07. The file name is
unchanged, per the roster's "existing (retitled, add to nav)" instruction.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/09-genotyping/04-haplotype-definitions-and-export.md
```

Result, verbatim, after the two Settings label fixes described below:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/04-haplotype-definitions-and-export.md: no issues found
```

Both sibling chapters were re-linted after the glossary edits and both still
print `no issues found`.

The only lint failure in the whole pass was informative and worth recording for
later authors. Two registry labels end in an ellipsis written as three periods,
`Filtered Pivot...` and `Export Excel View...`. The `settings-coverage` rule
requires the paragraph's bold run to be the label plus a closing period, so the
correct form is `**Filtered Pivot....**` with four periods, not three. Writing
the natural-looking three periods produces the warning "setting 'Filtered
Pivot...' ... is not documented", which reads as a missing paragraph rather than
as a punctuation problem.

## Retitle sites touched

Two, and only two were owed to this chapter.

1. **The chapter's own front matter.** `title:` changed from
   `Haplotype Definitions, AI-Assisted Haplotyping, and Export` to
   `Exporting Genotypes`.
2. **`docs/user-manual/help-ids.yaml`.** Searched and **not** edited, because
   the old title does not appear there. `grep -n -i "haplotype\|genotyp"` over
   the file returns exactly one line, `:427`, which is an unrelated Inspector
   Variant-section description. The file carries 101 `chapter:` entries and none
   of them points at any `09-genotyping` chapter. Nothing to retitle.

The nav in `docs/user-manual/build/mkdocs.yml` already carried
`Exporting Genotypes` for this file, added by the chapter 01 author, so the
sidebar label and the page title now agree. That file was not edited.

The old title also survives in the Next sections of chapters 01 and 03, at
`01-what-is-mhc-genotyping.md:129` and
`03-reading-the-genotype-comparison.md:209`. Those are sibling files this author
must not edit. **Both need updating to "Exporting Genotypes" in the Phase 6
sweep or by whoever gates rows 53 and 55.**

## Section order chosen

What it is, Why you would do this, Before you start, Procedure (four steps),
Settings, Reading the results, What good looks like, Haplotype analysis
(placeholder), On the command line, Next.

This is the template order the task named. Two placement notes.

- **The haplotyping placeholder sits after What good looks like**, the same
  position chapter 03 chose, because the whole chapter is about exporting a
  genotype-only result and the placeholder is the one place haplotypes are
  named. It is CONSISTENCY's fixed two-sentence form, verbatim, under the fixed
  heading. That is the owner's "one sentence at most" constraint honoured
  through the shared fixed form rather than by inventing a shorter one.
- **On the command line** carries chapter 33's fixed opening paragraph with
  "the dialog" swapped for nothing, since the paragraph's own wording fits.
  It then adds one qualifying sentence, because unlike every other procedure
  chapter this one has two formats that exist *only* headless, so the fixed
  claim that "nothing here unlocks a result the dialog cannot produce" would
  otherwise be false. The qualification is one sentence and does not alter the
  fixed paragraph.

## Commands run

Every command ran from the worktree with the debug CLI at
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
Outputs went to the scratchpad directory the task named, except where the
defect below forced a different path. Nothing in the Williams project was
written, moved, or copied out.

| # | Command | Exit | Figures taken from it |
|---|---|---|---|
| 1 | `genotype export-xlsx --bundle "…/amplicon-genotyping_3.lungfishgenotype" --output …/williams-matrix.xlsx` | 0 | JSON summary `sampleCount` 30, `locusCount` 13, `overrideCount` 0, `auditEntryCount` 0 |
| 2 | `genotype export --bundle … --export-format csv --output <scratchpad>/williams-export.csv` | **1** | The defect. Error text quoted below |
| 3 | `genotype export --bundle … --export-format tsv --output <scratchpad>/williams-export.tsv` | **1** | Same defect, second format |
| 4 | `genotype export --bundle … --output <scratchpad>/williams-export.xlsx` | **1** | Same defect, default format |
| 5 | Same as 2 into a freshly created empty subdirectory | **1** | Proves the failure is not stale-state |
| 6 | `genotype export-pivot-xlsx --bundle … --output …/williams-pivot.xlsx` | 0 | `matchedAlleleRows` 305, `filteredAlleleValueCount` 0, `removedAlleleRowCount` 0, `sampleCount` 30, `percentBasis` `sample-retained`, `sourceWorkbook` the bundle's `artifacts/workbooks/current.xlsx` |
| 7 | Same with `--min-reads 50 --min-percent 5 --percent-basis viewed-locus` | 0 | `filteredAlleleValueCount` **1478**, `removedAlleleRowCount` **192**, `matchedAlleleRows` still 305 |
| 8 | `genotype export-labkey --bundle … --output-dir …/labkey` | 0 | The five filenames and `rowCounts` `allele_read_counts` 2109, the other four 0 |
| 9 | `genotype export --bundle … --export-format csv --output /tmp/lgeexp-test/x.csv` | 0 | Succeeds outside the scratchpad. `sampleColumns` array of 30 names, `usedProjection` false |
| 10 | Same, `--export-format tsv` | 0 | 31 lines, 27 tab-separated columns |
| 11 | Same, default format, to `/tmp/lgeexp-test/x.xlsx` | 0 | Same four sheets as command 1, different SHA-256 |
| 12 | Lint on this chapter | 0 (after fix) | the lint line above |
| 13 | Lint on chapters 01 and 03 | 0 | confirmed the glossary edits broke nothing |

## What was read from the exported files

Every structural claim in the chapter comes from parsing these files, not from
the CLI summaries.

**`williams-matrix.xlsx`** (from `export-xlsx`, 10,798 bytes). Four sheets in
this order: `Matrix` (32 rows), `Legend` (10 rows), `Overrides` (1 row),
`Audit Log` (1 row). Strings are stored inline rather than in a shared-strings
table, which matters for anyone parsing it.

- `Matrix` row 1 is a 27-cell locus header, `Sample` then each of 13 loci
  followed by a blank merge cell: MHC-A, MHC-AG, MHC-B, MHC-DPA1, MHC-DPB1,
  MHC-DQA1, MHC-DQB1, MHC-DRB, MHC-E, MHC-F, MHC-G, MHC-I, MHC-J. Row 2 is the
  slot header, `H1` and `H2` under each locus. Rows 3 to 32 are the 30 samples.
  Cell values are full IPD-MHC record names such as
  `05_Mamu-B17_01g1|B17_01_01_01,…`, not M-family tokens.
- `Legend` rows are `Token, Display Name, Hex, Notes` then M1 `#0C0000`,
  M2 `#FF0000`, M3 `#0000FF`, M4 `#008000`, M5 `#FFFF00`, M6 `#808080`,
  M7 `#800080`, `ERR` / `Error / no call` / `#A65F3A` with notes
  `ERR: NO HAP / ERR: TMH / ERR: TMG`, and `(blank)` / `Absent or unanalyzed`
  with no hex. The chapter does not quote the hex values, per the brand rule
  against raw hex in prose.
- `Overrides` header: `Sample, Locus, Slot, Original Call, Override Call,
  Reason, Rationale, Author, Timestamp`.
- `Audit Log` header begins `Action, Target, Disposition, Validation Status,
  Validation Reason, Sample, Locus, Slot, Before, After`.

**`williams-pivot.xlsx`** (unfiltered, 151,013 bytes) and
**`williams-pivot-filtered.xlsx`** (139,931 bytes). Six sheets each, identical
names: `amplicon-genotyping_3` (the pivot), `amplicon-genotyping_3 Long Summ`,
`amplicon-genotyping_3 Sample Su`, `Run Stats`, `Overrides`, `Audit Log`.
Sheet names are truncated to Excel's 31-character limit.

- Pivot sheet dimensions `A1:AG326` unfiltered and `A1:AG134` filtered. The
  326 minus 134 difference is exactly the reported `removedAlleleRowCount` of
  192.
- Pivot rows 1 to 3 are the header band: `Animal ID` with sample names across,
  `GS ID` with `Total` and `Average` then sample names, and
  `Filtered exact-match read count` with 682,927 total, 22,764.23 average, and
  per-sample values starting at 713.
- Rows 4 and 5 are blank. Rows 6 to 19 are the empty haplotype band, labelled
  `MHC-A Haplotype 1` and `2`, then MHC-B, MHC-DRB, MHC-DQA, MHC-DQB, MHC-DPA,
  MHC-DPB, eight loci in two slots each, all with no values.
- Row 20 is `Comments` / `Subtotal` / `# Obs.`. Row 21 is the data header,
  `Genotype` / `Total` / `# Obs.` then the 30 sample columns. Rows 22 onward
  are allele targets.
- **305 allele rows unfiltered, 113 filtered.** 305 minus 113 is 192, matching
  the summary exactly.
- The worked arithmetic in the chapter comes from one row read in both files.
  `01_Mamu-A1_002g|A1_002_01_01_01,A1_002_01_01_02` reads
  `Total 929, # Obs. 5, values 1, 301, 1, 95, 531` unfiltered and
  `Total 927, # Obs. 3, values 301, 95, 531` filtered. Two single-read values
  blanked, and both Total and observation count recomputed rather than left
  stale.
- Long Summary sheet `A1:J2110`, so 2,109 data rows, header
  `sample, genotype, passed_alignments, passed_unique_reads,
  sample_total_reads, sample_unique_retained_reads,
  sample_unique_retained_percent, overall_input_reads,
  overall_unique_retained_reads, overall_unique_retained_percent`.
- Sample Summary sheet `A1:G31`, so 30 rows, header
  `sample, passed_alignments, passed_unique_reads, sample_total_reads,
  sample_unique_retained_percent, overall_input_reads,
  overall_unique_retained_percent`.
- `Run Stats` sheet `A1:B42`, a `metric` / `value` pair list beginning
  `allowIndels 1` and `assignedUniqueRetainedReads 682927`.
- Both `Overrides` and `Audit Log` are header-only in both files.
- **Both pivot workbooks are identical outside the pivot sheet**, confirming
  the "every other sheet carried through unchanged" claim by inspection rather
  than by trusting the help text.

**The five LabKey CSVs.** Line counts and headers read directly.

- `allele_read_counts.csv`, 2,110 lines (2,109 data rows), header
  `animal_id,gs_id,allele,locus_group,unique_reads,passed_unique_reads,passed_alignments`.
  Allele fields containing commas are correctly double-quoted.
- `haplotype_calls.csv`, 1 line, header
  `animal_id,gs_id,locus,slot,called_haplotype,status,reads_supporting,is_override,notes`.
- `overrides.csv`, 1 line, header
  `animal_id,locus,slot,original_call,override_call,reason_tag,rationale,author,timestamp`.
- `audit_log.csv`, 1 line, header
  `action,animal_id,locus,slot,before,after,color,reason,rationale,author,timestamp`.
- `smart_cohorts.csv`, 1 line, header
  `cohort_id,cohort_name,predicate_json,created_at,sample_count`.
- Each CSV gets its own `<name>.lungfish-provenance.json` sidecar, plus one
  directory-level `.lungfish-provenance.json`.

**The generic export's CSV and TSV.** 31 lines each, 27 columns, header
`Sample,MHC-A H1,MHC-A H2,…,MHC-J H2`, one row per sample. Same shape as the
matrix workbook's `Matrix` sheet, flattened. The generic export's default XLSX
carries the same four sheets as `export-xlsx` but a different SHA-256, which is
consistent with an embedded timestamp and is the reason the chapter makes no
byte-reproducibility claim (DRIFT row 4.45's open question is left open).

**On naming.** No individual animal is named in the chapter body. The
`WD<n>_S<n>_L001` sample identifiers appear only in this report, and even here
only as the shape a screenshot would show.

## Source files consulted

- `Sources/LungfishGenotypeUI/GenotypeResultViewController.swift`. `:590-596`
  `isGenotypeOnlyResult`; `:598-603` `availableLenses` returning
  `[.summary, .audit]` for genotype-only; `:605-610` `presentationChoices`
  returning empty unless `appliesToHaplotypedMiSeq`; `:2663-2683` the `Actions`
  button and its three items; `:2717-2718`, `:2944-2945`, `:2960-2961` the two
  `isHidden` assignments; `:3095-3113` `showLens` and the `.audit` branch;
  `:5531` `addAuditSection(title: "Share View", …)`; `:9643-9670` the two audit
  buttons and their tooltips; `:9674-9692` the format-fixing handlers and the
  comment stating the Audit lens is hidden for MiSeq results; **`:692-700`
  `handleHaplotypeDefinitionsRequest`, which redirects a genotype-only result to
  `.summary` instead of `.audit`.**
- `Sources/LungfishGenotypeUI/GenotypeResultDisplaySection.swift`. `:105`
  `canExportFilteredPivot`; `:1218-1252` the section body order and the
  `Visual filters do not change genotype calls.` caption; `:1271-1286`
  `exportControls` with the `Filtered Pivot…` button and its one-way caption;
  `:1566` the `Percent Basis` picker; `:1579-1655` `matrixVisibilityControls`
  with the `Rows…` and `Columns…` menus, their six items, and
  `Reset Visibility`; `:1657+` `colorControls`.
- `Sources/LungfishGenotypeUI/GenotypeResultDocumentSection.swift:578-599`. The
  `Current Workbook` disclosure holding
  `Update and View Current Excel Version`, its disabled condition, its help
  text, and the caption "Writes displayed haplotype calls, matrix annotations,
  Overrides, and Audit Log worksheets."
- `Sources/LungfishCLI/Commands/GenotypeExportXlsxSubcommand.swift:1-36`. The
  four-sheet contract, the Budde 2010 palette note, the ERR danger colour, the
  unfilled absent cells, and the `inspectOnly` provenance policy. Note the file
  name is `…XlsxSubcommand.swift`, lowercase `lsx`, not the
  `…XLSXSubcommand.swift` the reality map cites.
- `Sources/LungfishCLI/Commands/GenotypeExportLabKeySubcommand.swift:88-140`.
  The summary JSON shape, `GenotypeLabKeyExportFile`, the RFC 4180 escaping
  note, and the `filenames` map giving all five names.
- `Sources/LungfishWorkflow/Provenance/ProvenancePublicationSnapshot.swift:9-30`.
  `ProvenancePublicationSnapshotError.mutationReceiptConflict` and its message,
  which is the error the `genotype export` defect raises.
- `Sources/LungfishIO/Bundles/ONTGenotypeResultBundle.swift:740-745`. The
  `Viewed Locus` and `Sample Retained` display names.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/genotype.txt`. The full
  eleven-subcommand inventory and every flag, default, and allowed-value list
  quoted in the Settings section.
- `docs/user-manual/build/scripts/lint/rules/frontmatter.js` and
  `settings-coverage.js`. Read to understand the required keys, the shot-marker
  pairing, and the `**Label.**` period rule that produced the only lint failure.

Review inputs read in full: the persona
`.claude/agents/bioinformatics-educator.md`, `ARCHITECTURE.md`,
`CONSISTENCY.md`, the `09-genotyping` reality map, this chapter's DRIFT section
and roster row, the `genotype.export` registry entry, both sibling author
reports, and `06-classification/03-running-esviritu.md` as the style model.

## Corrected wordings applied

Every corrected wording in the chapter's DRIFT section is honoured.

- **4.32 (false).** The old "single in-app export ... the Audit lens carries an
  Export Excel View... button" is gone. See defect 1 below, which goes further
  than the correction.
- **4.2, 4.4 (changed).** Front-matter `entry_points` now lead with
  `Inspector > Genotype Display > Filtered Pivot...` and
  `Genotype viewport > Actions > Export Excel View...`, in that order, since
  the Inspector route is the one that works on the fixture. The four CLI
  entry points are named individually rather than as one line.
- **4.9, 4.10, 4.11, 4.18 and every other `haplotyping (placeholder scope)`
  row (4.1, 4.8, 4.12 to 4.17).** All dropped. The chapter contains no
  definition editor, no locus sidebar, no `Requires N of M` stepper, no
  diagnostic matrix, no `haplotypes` subcommand inventory, and no
  `ai-haplotyping` section. The whole of Step 1 and Step 2 of the old chapter is
  gone, replaced by CONSISTENCY's fixed two-sentence placeholder. This
  discharges the owner's constraint.
- **4.33, 4.34, 4.36, 4.37, 4.38, 4.39, 4.40, 4.41, 4.42, 4.43, 4.44 (true).**
  All retained and each re-verified against a run rather than carried over.
  4.39's noted omission of `--keep-empty-rows` is fixed, and it now has its own
  Settings paragraph.
- **4.45 (unverifiable).** The old chapter's claim that "Editing and export are
  deterministic: run them again and the output does not move" is **removed**.
  Command 11 produced a different SHA-256 from command 1 for the same logical
  workbook, which is consistent with an embedded timestamp, so the claim is not
  supported and the chapter makes none.

## Missing rows covered

Of the 15 Missing rows in this chapter's DRIFT section, 9 are haplotyping-scope
and 6 are in scope. All 6 in-scope rows are covered.

- **`--lens`, `--min-reads`, `--filter`, `--view-projection` on
  `genotype export`.** All four have Settings paragraphs. `--min-reads` and
  `--filter` appear as the CLI flags of the `Min reads` and `Alleles` settings,
  per the registry's own mapping. `--lens` and `--view-projection` are
  cli-only paragraphs.
- **`Export Filtered Pivot...` also exists as a viewport button on non-MiSeq
  shapes.** Covered as the second half of the Before you start paragraph and,
  more precisely, by defect 1 below.
- **The XLSX Matrix sheet colours ERR cells with the danger colour and leaves
  absent cells unfilled.** Covered in Step 3's account of the `Legend` sheet,
  which names the ERR token and the `(blank)` entry meaning absent or
  unanalyzed. The hex values are deliberately not quoted, per the brand rule.
- **The export is provenance `inspectOnly` and never modifies the bundle.**
  Covered as the fixed sentence closing What it is, "Nothing in this chapter
  changes a call", and again in the Settings lead paragraph.
- **`--keep-empty-rows`.** Its own Settings paragraph.
- **`--source-workbook`.** Its own Settings paragraph, with its two-level
  default stated.
- **The `parameters_refs` row.** Superseded. The reality map recorded that no
  genotyping operation was registered, but `genotype.export` now exists in
  `parameters.yaml:6151`. The chapter carries
  `parameters_refs: [genotype.export]` and documents all 19 entries.

Nine Missing rows are haplotyping-scope and are therefore out of scope by the
campaign decision and the owner's constraint: the `haplotypeDefinitions`
capability gating of the Tools menu item, `haplotypes bundle-install`,
`--include-shadowed` / `--include-reference-bundles`, `--change-note`,
`--compact-knowledge-pack`, `--prompt-template-id` / `-version`, the four
`ai-haplotyping` tuning defaults, `--debug-output` and its chunk-index flags,
`--population` / `--assay-resolution`, and the definition editor's diagnostic
matrix columns. All belong to `haplotypes` or `genotype ai-haplotyping`, which
the retitle removes from this chapter.

## Settings section

**19 paragraphs**, covering all 11 `settings` entries and all 8 `cli_only`
flags from `genotype.export`. Every label is copied verbatim from the registry,
including the trailing ellipsis on the two button labels, and every paragraph
follows the fixed shape of what it does, its default, its allowed values, when
to change it, then the flag sentence or "This setting has no command-line
flag."

Two paragraphs required judgement.

- **`Filtered Pivot....`** and **`Export Excel View....`** carry
  `cli_flag: null` in the registry, so both close with "This setting has no
  command-line flag." Each then adds a clause naming the subcommand that writes
  the same file, because a reader who has just been told a button has no flag
  will otherwise conclude the file is unobtainable headless, which is false.
- **`Samples.`** maps to `--sample` in the registry, but the flag's semantics
  differ from the field's. The Inspector field is a substring match, while
  `--sample` is a repeatable exact-name restriction. The paragraph says so.

The eight `cli_only` flags are introduced by one lead sentence before them
rather than being folded into the eleven, so a reader can see at a glance which
controls have no button.

## Shot markers

**Three**, all new, all on surfaces that exist on a genotype-only result. None
reuses `genotype-matrix-overview` or `genotype-inspector-display`, which
chapters 01 and 03 own.

- `genotype-inspector-export`. The Export block at the foot of the Genotype
  Display section. Replaces the retired `genotype-export-dialog` planned shot,
  whose caption promised a format picker that does not exist.
- `genotype-export-save-panel`. The save panel `Filtered Pivot...` opens, with
  the `-filtered-pivot.xlsx` suffix the code composes at
  `GenotypeResultViewController.swift:9686`.
- `genotype-pivot-workbook`. The exported pivot sheet open in a spreadsheet,
  which is the one picture that shows what the chapter's central export
  actually produces.

The four planned shots of the old chapter are all dropped.
`haplotype-definition-editor` and `haplotype-ai-discovery` belong to the
haplotyping placeholder. `genotype-export-dialog` promised a dialog that does
not exist. `genotype-labkey-export` has no in-app surface at all, and the
reality map's suggested replacement, a listing of the five CSV filenames, is in
the prose of Step 4. No `planned_shots` key survives, and all three markers
have matching `shots` entries with captions.

## Glossary terms added

**Six**, each one sentence, each alphabetised into its section, each listed in
`glossary_refs`.

`audit-log` (A), `csv` (C, between CSI and Ct), `long-format` (L, before Lowest
common ancestor), `override` (O, after Outgroup), `pivot-workbook` (P, before
Ploidy), and `xlsx` in a **new `## X` section** appended after `## W`, since the
glossary had no X section before.

No existing entry needed correcting. `labkey`, `tsv`, `smart-cohort`,
`retained-read`, `allele-target`, `genotype-result-bundle`, `genotype-matrix`,
`locus`, `cohort`, `provenance`, `inspector`, `mhc`, `haplotype`, `genotype`
were all already present and accurate for this chapter's use.

All 20 anchors in `glossary_refs` were verified to resolve to exactly one
`{#anchor}` in `GLOSSARY.md`, and all 15 inline `GLOSSARY.md#…` links in the
body were checked against the same list. Both relative sibling links resolve to
files that exist.

## Defects found

Three in the app, one in the reality map.

1. **App defect. On a genotype-only result there is exactly one reachable
   in-app export, not two.** DRIFT row 4.32 corrects the old chapter to "The
   viewport offers two in-app exports", with `Export Excel View…` in the Actions
   menu. That is true only of a haplotyped MiSeq result. On a genotype-only
   result such as the Williams one, `GenotypeResultViewController.swift:2945`
   sets `presentationActionsButton.isHidden = presentationChoices.isEmpty`, and
   `:605-610` returns an empty `presentationChoices` unless
   `appliesToHaplotypedMiSeq`, so the Actions button and its
   `Export Excel View…` item are hidden.

   The `Share View` block at `:5531`, which hosts both
   `Export Excel View...` and `Export Filtered Pivot...` as buttons, lives in
   the Audit lens. `availableLenses` at `:598-603` **does** include `.audit` for
   a genotype-only result, so the lens exists, but `:2944` sets
   `lensControl.isHidden = isGenotypeOnlyResult || …`, so the control that would
   switch to it is hidden, and `:692-700`
   (`handleHaplotypeDefinitionsRequest`) explicitly redirects a genotype-only
   result to `.summary` rather than `.audit`. The Audit lens is therefore built
   and unreachable, and with it both of its export buttons.

   The net effect is that the Inspector's `Filtered Pivot…` is the only in-app
   export on a genotype-only result. The chapter states this plainly in Before
   you start. Worth deciding whether `availableLenses` should stop returning
   `.audit` for genotype-only results, or whether the lens should be reachable.

2. **App defect. `lungfish-cli genotype export` fails whenever its output path
   sits under a symlinked directory, and writes nothing.** Reproduced at 100%
   across all three `--export-format` values, in a freshly created empty
   directory, and with `--force`. The error is

   ```
   Error: The provenance publication artifact no longer matches the transaction
   generation at /tmp/claude-501/.../t3/.lungfish-provenance.json.
   ```

   raised as `ProvenancePublicationSnapshotError.mutationReceiptConflict`
   (`ProvenancePublicationSnapshot.swift:27-28`). The tell is in the message
   itself. The requested output path was under `/private/tmp/...` and the error
   reports `/tmp/...`, so the publication step resolves the symlink for one side
   of its comparison and not the other, and the two never match. The same
   command with an output under a plain path such as `/tmp/lgeexp-test/`
   succeeds immediately (commands 9 to 11). Exit code is 1, no output file is
   written, and a zero-byte
   `.lungfish-genotype-export-publication.lock` is left behind.

   `export-xlsx`, `export-pivot-xlsx`, and `export-labkey` all succeeded under
   the very same `/private/tmp` path, so the bug is specific to
   `GenotypeExportSubcommand`'s publication path and not to the shared
   provenance layer. This blocks CSV and TSV export entirely for anyone whose
   working directory is under `/tmp` on macOS, which includes every scratch
   directory `mktemp -d` produces. The chapter documents the workaround in one
   paragraph at the end of the command-line section.

3. **App defect, minor. The pivot workbook writes an empty haplotype band on a
   genotype-only result.** Rows 6 to 19 of the pivot sheet are labelled
   `MHC-A Haplotype 1` through `MHC-DPB Haplotype 2` and are entirely blank,
   and they survive filtering unchanged. They are harmless but confusing in a
   file sent to a collaborator, since fourteen labelled rows with no values
   invite the question of what went wrong. The chapter names the band and says
   why it is empty rather than leaving a reader to guess.

   Note also that this band covers **eight** loci (MHC-A, B, DRB, DQA, DQB,
   DPA, DPB in two slots each) while the same workbook's data covers **13**,
   and the matrix workbook's `Matrix` sheet covers all 13. The haplotype band's
   locus list is fixed rather than derived from the run.

4. **Reality map inaccuracy.** The map's source list cites
   `Sources/LungfishCLI/Commands/GenotypeExportXLSXSubcommand.swift`, with
   `XLSX` in capitals. The file on disk is `GenotypeExportXlsxSubcommand.swift`.
   Every line reference in rows 4.34, 4.37, and 4.38 is otherwise correct.
   Minor, but it costs a reviewer a failed `Read` before they find it.

## What could not be verified

- **The three shots.** None was captured. Screenshots are Phase 5 work and the
  markers are left for the Screenshot Scout. The
  `genotype-inspector-export` caption in particular should be confirmed on a
  genotype-only result, since defect 1 means a scout who opens a haplotyped
  result will see a different set of export controls.
- **The window was not driven.** No GUI session was run. Every claim about
  which control is visible rests on source reading plus the Williams bundle's
  `workflowMode: genotypeOnly`, which chapter 01 and 03's authors both read from
  `genotype-result.json`. Defect 1 above is the most important thing a
  screenshot pass should confirm or refute.
- **`Export Excel View...` and `Update and View Current Excel Version` were
  never pressed.** Both are documented from source and from the CLI equivalents
  that write the same files. The chapter's account of what `Export Excel View`
  writes is the account of `genotype export-xlsx`'s output, which the shared
  `GenotypeXlsxWorkbookWriter` guarantees is the same workbook
  (`GenotypeExportXlsxSubcommand.swift:22-25`), but the in-app path adds a
  view projection that was not exercised.
- **Byte reproducibility.** DRIFT row 4.45 remains open. Two runs of the same
  logical XLSX export produced different SHA-256 values, which is evidence
  against reproducibility but not proof, since the two runs used different
  subcommands. Running `export-xlsx` twice to the same content and diffing
  would settle it, and was not done.
- **A reviewed result.** Every annotation-bearing output on this fixture is
  empty, so the `Overrides` and `Audit Log` sheets, and four of the five LabKey
  files, were only ever seen header-only. The claim that overrides are merged
  over the pipeline result before export comes from
  `GenotypeExportLabKeySubcommand.swift` and the CLI help, not from an observed
  non-empty file.
- **The Legend palette in use.** The `Legend` sheet was read and its nine rows
  quoted, but no `Matrix` cell in this result carries an M-family token, so
  the colouring the legend describes was never seen applied.
