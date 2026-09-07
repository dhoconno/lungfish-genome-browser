# Author record, appendices/primer-schemes

Chapter: `docs/user-manual/chapters/appendices/primer-schemes.md`
Roster row 64. Rewritten 2026-09-07 against Preview 2026.9.13.
Author: bioinformatics-educator.

## Lint

Final run, verbatim.

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/primer-schemes.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/primer-schemes.md: no issues found
exit=0
```

One intermediate failure, worth recording because it is a linter trap rather than a prose fault. The first run reported two `sentence-colon` warnings against the shipped-schemes table. The rule inspects `tableCell` nodes, and the right-align delimiter `---:` is counted as a colon inside a cell. Changing the two numeric columns from `---:` to `---` cleared both. A chapter with a right-aligned column can never pass this linter.

## Commands run

Working directory for every command was the worktree root
`/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign`,
except the two inspection commands noted as run from inside the scratch project.
Scratch output lives under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/primer-schemes/`.
CLI binary `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(built 2026-09-06, reports `lungfish-cli 2026.9.13`).

| # | Command | Exit |
|---|---|---|
| 1 | `lungfish-cli primers --help` | 0 |
| 2 | `lungfish-cli primers import --help` | 0 |
| 3 | `lungfish-cli primers import --bed .../midnight.bed --fasta .../panel-primers.fasta --output DemoPanel --project .../Demo.lungfish --reference-accession MN908947.3 --equivalent-accession NC_045512.2 --display-name "Demo Amplicon Panel" --attachment .../kit-notes.txt` | 0 |
| 4 | `ls -R "Primer Schemes"` in the scratch project | 0 |
| 5 | `lungfish-cli primers import --bed .../midnight.bed --output MinimalPanel --project .../Demo.lungfish` (defaults only) | 0 |
| 6 | `lungfish-cli primers import` repeating command 5 verbatim (duplicate test) | 1 |
| 7 | `python3` read of `provenance/bundle.lungfish-provenance.json` (key listing) | 0 |
| 8 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <chapter>` (twice, second clean) | 0 |
| 9 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/GLOSSARY.md` | 0 |

No downloads and no installs were run.

### Command 3 output

```
Primer scheme bundle written to /private/tmp/.../Demo.lungfish/Primer Schemes/DemoPanel.lungfishprimers
```

### Command 4 output

```
Primer Schemes/DemoPanel.lungfishprimers:
PROVENANCE.md
attachments
manifest.json
primers.bed
primers.fasta
provenance

Primer Schemes/DemoPanel.lungfishprimers/attachments:
kit-notes.txt

Primer Schemes/DemoPanel.lungfishprimers/provenance:
PROVENANCE.md.lungfish-provenance.json
attachments
bundle.lungfish-provenance.json
manifest.json.lungfish-provenance.json
primers.bed.lungfish-provenance.json
primers.fasta.lungfish-provenance.json

Primer Schemes/DemoPanel.lungfishprimers/provenance/attachments:
kit-notes.txt.lungfish-provenance.json
```

### Command 5 manifest, quoted in the chapter

```json
{
  "amplicon_count" : 29,
  "created" : "2026-09-07T14:10:05Z",
  "display_name" : "MinimalPanel",
  "imported" : "2026-09-07T14:10:05Z",
  "name" : "MinimalPanel",
  "primer_count" : 58,
  "reference_accessions" : [
    { "accession" : "MN908947.3", "canonical" : true, "equivalent" : false }
  ],
  "schema_version" : 1,
  "source" : "imported"
}
```

The accession came from the BED's first column and the display name from the
output stem, with neither flag passed. That settles DRIFT rows 21 and 22.

### Command 6 output

```
Error: A primer scheme bundle already exists at /private/tmp/.../Demo.lungfish/Primer Schemes/MinimalPanel.lungfishprimers.
```

## Shipped schemes, verified

Source location for all eight is
`Sources/LungfishApp/Resources/PrimerSchemes/<name>.lungfishprimers/manifest.json`.
Every count below was read out of the manifest rather than recomputed, and each
matches DRIFT row 2 exactly. All eight declare canonical `MN908947.3`,
equivalent `NC_045512.2`, `source` `built-in`, `version` `1.0.0`, and
`organism` "Severe acute respiratory syndrome coronavirus 2".

| Display name | `name` | Primers | Amplicons |
|---|---|---|---|
| ARTIC SARS-CoV-2 V3 | ARTIC-nCoV-2019-V3 | 218 | 98 |
| ARTIC SARS-CoV-2 V4 | ARTIC-SARS-CoV-2-V4 | 198 | 99 |
| ARTIC SARS-CoV-2 V4.1 | ARTIC-SARS-CoV-2-V4.1 | 209 | 99 |
| ARTIC SARS-CoV-2 V5.3.2 | ARTIC-SARS-CoV-2-V5.3.2 | 192 | 96 |
| Midnight 1200 bp V1 | Midnight-1200-V1 | 58 | 29 |
| NEB VarSkip Short v1 | NEB-VarSkip-vss1 | 148 | 74 |
| NEB VarSkip Long v1 | NEB-VarSkip-Long-vsl1 | 50 | 29 |
| QIAseq Direct SARS-CoV-2 with Booster A | QIASeqDIRECT-SARS2 | 563 | 223 |

`ls -1` on each of the eight returns exactly `PROVENANCE.md`, `manifest.json`,
`primers.bed`. No FASTA and no `provenance/` folder on any of them, which is
DRIFT row 6 confirmed.

## Source files consulted

| File | What it settled |
|---|---|
| `Sources/LungfishIO/Bundles/PrimerSchemeBundle.swift` | Manifest keys and their snake_case coding keys, `imported` and `attachments` as real fields (DRIFT missing rows 2 and 3), the four `LoadError` cases and their exact messages, the three required files, `canonicalAccession` first-entry fallback, and the custom `ReferenceAccession` decoder defaulting both flags to false. |
| `Sources/LungfishIO/Bundles/PrimerSchemesFolder.swift` | `Primer Schemes` folder name, folder creation on demand, listing sorted by `manifest.name`, and silent skipping of bundles that fail to load. |
| `Sources/LungfishWorkflow/Primers/PrimerSchemeImportService.swift` | `source` is written as `imported`, not `built-in`. Primer count is non-empty non-comment lines. Amplicon count strips `_LEFT`/`_RIGHT` and additionally a trailing dash plus up to three digits. `.lungfishprimers` suffix appended when absent. `--project` resolution rules. Duplicate refusal. The nine `PROVENANCE.md` lines and the fields of the JSON envelope. |
| `Sources/LungfishWorkflow/Primers/PrimerSchemeResolver.swift` | Canonical match uses the bundle BED unchanged, equivalent match rewrites column 1 into a temp BED, unknown accession throws. Version-suffix-insensitive and case-insensitive matching (`NC_045512` matches `NC_045512.2`). |
| `Sources/LungfishCLI/Commands/PrimerCommand.swift` | `primers` has exactly one subcommand, `import`. Every option name and which two are required. |
| `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift` | The card id `primer-scheme`, its title "Primer Scheme", its description, its file hint `.bed (+ optional .fasta/.fa/.fna)`, and its tab `.references`, whose title is "Reference Sequences". |
| `Sources/LungfishApp/Views/ImportCenter/PrimerSchemeImportView.swift` | Sheet title "Import Primer Scheme", the Files and Identity sections, all four Identity field placeholders, the Choose… buttons, the Import/Cancel buttons, and the three-condition `canRun` gate. |
| `Sources/LungfishApp/Views/ImportCenter/PrimerSchemeImportViewModel.swift` | The GUI passes `attachments: []` unconditionally, and passes no description, organism, source URL, or version. Slashes in the name become underscores. |
| `Sources/LungfishApp/Views/Sidebar/PrimerSchemeInspectorView.swift` | The exact Inspector layout and its conditional rows, and that the pane is read-only. |
| `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift` | `.lungfishprimers` is a sidebar item type displayed without its extension. |
| `Sources/LungfishApp/Views/BAM/PrimerSchemePickerView.swift` | Picker section headings "Built-in" and "In This Project", keyed on `manifest.name`. |
| `Sources/LungfishApp/Services/BuiltInPrimerSchemeService.swift` | Built-ins are enumerated from the app resource root and sorted by `manifest.name`, matching the project-local sort. |
| `Sources/LungfishApp/Resources/PrimerSchemes/*/manifest.json` (all 8) | The shipped-scheme table above. |
| `Sources/LungfishApp/Resources/PrimerSchemes/Midnight-1200-V1.lungfishprimers/PROVENANCE.md` | The shape of a shipped scheme's provenance, which is Markdown tables from `scripts/build-primer-bundle.swift` rather than the importer's nine lines. The Reference Verification table and its identical SHA-256 for both accessions. |
| `Sources/LungfishApp/Resources/PrimerSchemes/ARTIC-nCoV-2019-V3.lungfishprimers/primers.bed` | The six-column BED sample quoted in the chapter, real rows read from the shipped file. Column 5 alternates 1 and 2, which is the pool convention. |

## Committed chapters treated as binding

- `docs/user-manual/chapters/04-alignments/03-primer-trimming.md` and its
  `fable-gate.md`. Run-verified and lead-approved, so it wins on how a scheme
  is chosen and applied. This appendix does not restate the trim procedure, the
  iVar settings, or the trim-rate threshold, and points at that chapter instead.
  Its own closing paragraphs already describe the Import Center route and the
  `primers import` command, and this appendix is consistent with them.
- `docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md`. Confirms
  the eight bundled schemes appear in a second picker, that the Viral Recon
  picker's caption reads `MN908947.3 · 563 primers · 223 amplicons`, and that
  the default is the alphabetically first scheme, ARTIC SARS-CoV-2 V3. That
  default is why the appendix says the two sort orders differ.
- `CONSISTENCY.md`. `Primer Schemes/` folder convention, the fixed
  command-line opener paragraph (used verbatim with "the sheet" swapped in),
  `lungfish-cli` as the tool name, bundle extensions in code font, menu paths
  in bold with an ellipsis, and the glossary discipline.

## DRIFT rows applied

False row 2, eight schemes with the table. False row 9, `imported` and
`attachments` rows added. Changed rows 6, 11, 12, 17, 19, 21, 22, 24, 26 all
applied. Row 26's `--name` requirement is honoured by not repeating the
`bam primer-trim` example here at all and pointing at chapter 04-03, whose
own example already carries all four required flags.

All eight Missing rows applied, with one refinement. The DRIFT layout row said
imported bundles carry a root-level `.lungfish-provenance.json`. The live run
shows a `provenance/` folder holding one sidecar per written file plus
`bundle.lungfish-provenance.json`. The chapter documents what the run
produced.

The two `bam primer-trim` Missing rows (`--target-reference` and the four iVar
parameters) belong to chapter 04-03, which already documents all five. This
appendix names `--target-reference` once, in the BED expectations section,
because it is the fix for the appendix's own zero-trim warning, and refers the
four iVar parameters to chapter 04-03 rather than duplicating them.

## App defects found

1. **The GUI import cannot add attachments.** `PrimerSchemeImportView` has no
   attachments control and `PrimerSchemeImportViewModel.performImport` is
   called with `attachments: []` hard-coded, while the bundle format, the
   manifest's `attachments` array, and `lungfish-cli primers import
   --attachment` all support them. A scheme imported in the window can never
   carry vendor documentation. Recorded in the chapter as a stated limit.
2. **The GUI import writes an impoverished manifest.** No description,
   organism, source URL, or version reaches the manifest from the sheet, so a
   user-imported scheme's Inspector shows four fewer rows than a shipped one.
   There is no way to set them without editing `manifest.json` by hand.
3. **`primers` advertises inspection it does not have.** The subcommand's own
   abstract reads "Build and inspect primer-scheme bundles", but `import` is
   the only subcommand. Nothing inspects.
4. **The canonical-flag fallback is silent.** `PrimerSchemeManifest.canonicalAccession`
   falls back to the first array entry when no entry is marked `canonical`,
   and the decoder defaults both flags to false rather than rejecting the
   manifest, so a hand-written accession list with the flags omitted loads and
   resolves against whichever entry happens to be first. Nothing warns.
5. **`created` and `imported` are written from the same clock instant** on a
   fresh import (both `2026-09-07T14:09:52Z` on the demo run), so the
   distinction between authoring and importing carries no information on a
   bundle the importer made. It only means something on a bundle authored
   elsewhere and imported later.
6. **Linter defect, not an app defect.** `sentence-colon.js` counts the `---:`
   right-align delimiter of a Markdown table as a colon in a table cell. Any
   chapter with a right-aligned column fails strict lint. Reported here for the
   campaign rather than worked around silently.

## Not verified

- **No GUI run.** Every Import Center and Inspector statement is read from
  source, not from a driven app. The three SHOT markers are the places a
  screenshot would settle the reading, and the Screenshot Scout should treat
  the sheet's exact field labels and the Inspector's row order as claims to
  check rather than as confirmed.
- **The shipped schemes' primer and amplicon counts were read from each
  manifest, not recomputed from each BED.** Only Midnight 1200 bp V1 was
  cross-checked, by importing its BED through the CLI and getting 58 and 29
  back, which match its manifest. The other seven are trusted from their
  manifests.
- **No scheme was applied to an alignment.** The zero-trim warning and the
  `--target-reference` remedy are carried from chapter 04-03, which measured
  them, rather than re-measured here.
- **The Viral Recon picker's "Project" heading** is quoted from chapter 04-05
  rather than read from source. This appendix quotes only the Primer Trim
  picker's headings, "Built-in" and "In This Project", which were read from
  `PrimerSchemePickerView.swift`.
- **`fixtures_refs` is empty.** The material used is the shipped app resource
  bundles under `Sources/`, which are not a `docs/user-manual/fixtures/`
  folder, and no primer-scheme fixture exists there. The chapter therefore
  needs no Before you start fixture sentence and cites no GitHub fixture link.

## Glossary

Two terms added, both alphabetically placed and matching the existing
one-sentence-plus-See-also shape.

- **Manifest** `{#manifest}`, inserted after Managed environment.
- **Primer pool** `{#primer-pool}`, inserted between Primer and Primer scheme.

Both are listed in the chapter's `glossary_refs`. Every other term in
`glossary_refs` already existed. The existing `primer-scheme` entry was left
alone, since the gate for chapter 04-03 ruled its wording adequate.
