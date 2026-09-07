# Fidelity review, appendices/primer-schemes

Chapter: `docs/user-manual/chapters/appendices/primer-schemes.md`
Roster row 64. Reviewed 2026-09-07 against Preview 2026.9.13 sources and a
rerun of every author command.
Reviewer: manual-fidelity-reviewer.

Arbiters used: `Sources/LungfishIO/Bundles/PrimerSchemeBundle.swift`,
`PrimerSchemesFolder.swift`,
`Sources/LungfishWorkflow/Primers/PrimerSchemeImportService.swift`,
`PrimerSchemeResolver.swift`,
`Sources/LungfishCLI/Commands/PrimerCommand.swift`, the Import Center and
Inspector views, all eight shipped manifests and BEDs, live
`.build/debug/lungfish-cli primers [import] --help`, DRIFT
`### appendices.md/primer-schemes.md`, CONSISTENCY.md, and the committed
chapters 04-alignments/03-primer-trimming.md and 05-viral-recon-wizard.md.

Rerun scratch: `.../scratchpad/primer-schemes-review/`. Every import was run
from the worktree root with absolute paths, never with /private/tmp as the
working directory. No downloads, installs, or writes outside scratch.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Eight built-in schemes ship inside the app, in `Sources/LungfishApp/Resources/PrimerSchemes/`" | true | `ls` returns exactly eight `.lungfishprimers` directories | |
| All eight declare canonical `MN908947.3` and equivalent `NC_045512.2` | true | All eight manifests carry `[{MN908947.3, canonical:true}, {NC_045512.2, equivalent:true}]` | |
| Row: ARTIC SARS-CoV-2 V3 / `ARTIC-nCoV-2019-V3` / 218 / 98 | true | manifest.json, verbatim | |
| Row: ARTIC SARS-CoV-2 V4 / `ARTIC-SARS-CoV-2-V4` / 198 / 99 | true | manifest.json, verbatim | |
| Row: ARTIC SARS-CoV-2 V4.1 / `ARTIC-SARS-CoV-2-V4.1` / 209 / 99 | true | manifest.json, verbatim | |
| Row: ARTIC SARS-CoV-2 V5.3.2 / `ARTIC-SARS-CoV-2-V5.3.2` / 192 / 96 | true | manifest.json, verbatim | |
| Row: Midnight 1200 bp V1 / `Midnight-1200-V1` / 58 / 29 | true | manifest.json, and reproduced by a live import of that BED | |
| Row: NEB VarSkip Short v1 / `NEB-VarSkip-vss1` / 148 / 74 | true | manifest.json, verbatim | |
| Row: NEB VarSkip Long v1 / `NEB-VarSkip-Long-vsl1` / 50 / 29 | true | manifest.json, verbatim | |
| Row: QIAseq Direct SARS-CoV-2 with Booster A / `QIASeqDIRECT-SARS2` / 563 / 223 | true | manifest.json, and reproduced exactly by a live import of that BED (563/223) | |
| "The manifest `name` is the file-safe identifier, which is also the folder name" | true | Folder names equal each manifest `name` in all eight cases | |
| Both pickers sort on `manifest.name` | true | `PrimerSchemesFolder.swift:68` and `BuiltInPrimerSchemeService.swift:35`, both `sorted { $0.manifest.name < $1.manifest.name }` | |
| "a menu lists these eight in the order the second column reads alphabetically rather than the order this table uses" | true | Sorting the `name` column puts `ARTIC-SARS-CoV-2-V4` before `ARTIC-nCoV-2019-V3` (uppercase `S` < lowercase `n`), so the orders genuinely differ | |
| QIAseq's 563/223 and ARTIC V4.1's 209/99 exceed the 2x ratio because of spike-in and coverage-restoring primers | true | Booster/alt primer names present in both BEDs; consistent with 04-05's caption `MN908947.3 · 563 primers · 223 amplicons` | |
| Midnight and VarSkip Long make amplicons over a kilobase | true | Midnight rows 30..54 then 1183..1205 give a ~1150 bp amplicon | |
| "Each shipped bundle holds three files and nothing else ... `manifest.json`, `primers.bed`, and `PROVENANCE.md`" | true | `ls -1A` on all eight returns exactly those three | |
| "None of the eight ships a primer FASTA, and none carries the machine-readable provenance folder" | true | Same listing. Agrees with 04-03 line 193 | |
| Imported-bundle layout block (manifest, bed, optional fasta, optional attachments/, PROVENANCE.md, provenance/) | true | Live `ls -R` of the rerun DemoPanel bundle matches exactly | |
| Three files required, missing any one refuses to load | true | `PrimerSchemeBundle.swift:148-150`, three `guard` + `throw` | |
| Error string "Bundle is missing PROVENANCE.md." | true | `PrimerSchemeBundle.swift:134`, verbatim | |
| "A manifest that is present but unreadable gives a fourth message naming the parse failure" | true | `LoadError.invalidManifest`, `:135-137` | |
| "`primers.fasta` holds the primer sequences themselves and is optional" | true | `PrimerCommand.swift:22` help text, and `PrimerSchemeBundle.swift:174` treats it as optional. Agrees with 04-03 line 193 | |
| Attachments sit under `attachments/` inside the bundle | true | `PrimerSchemeImportService.swift:121-125`; rerun produced `attachments/kit-notes.txt` | |
| "`provenance/` folder holds one provenance sidecar per file the import wrote, named after that file, plus a `bundle.lungfish-provenance.json`" | true | Rerun listing shows five per-file sidecars plus `bundle.lungfish-provenance.json`, plus a nested `provenance/attachments/` sidecar. This is the author's DRIFT correction and it is correct | |
| Manifest keys are snake_case | true | `CodingKeys`, `PrimerSchemeBundle.swift:99-114` | |
| Manifest field table, all 14 rows and their meanings | true | Field-by-field against `CodingKeys` and the struct. `schema_version` is `1` in all eight and in every rerun | |
| "`primer_count` \| Number of non-empty, non-comment BED rows" | true | `PrimerSchemeImportService.swift:225-231, 245` | |
| "`source` ... All eight shipped schemes use `built-in`, and the importer writes `imported`" | true | All eight manifests `built-in`; `PrimerSchemeImportService.swift:141` writes `"imported"`; every rerun manifest shows `imported` | |
| "Only `schema_version`, `name`, `display_name`, `reference_accessions`, `primer_count`, and `amplicon_count` are always present" | true | Exactly those six are non-optional in `PrimerSchemeManifest` (`:4-11`); the other eight are `?` | |
| "The Inspector draws only the fields a given bundle has" | true | `PrimerSchemeInspectorView.swift:21-50`, every optional row behind `if let` | |
| The `reference_accessions` JSON sample | true | Matches all eight shipped manifests' shape | |
| "Both flags default to false when a hand-written manifest leaves them out" | true | Custom decoder, `PrimerSchemeBundle.swift:81-86`, `decodeIfPresent ?? false` | |
| "LGE then falls back to treating the first entry as canonical. That fallback is silent" | true | `canonicalAccession`, `:51-55`, `?? referenceAccessions.first?.accession`. No log or warning on that path | |
| BED is zero-based half-open, `30` to `54` covers 24 bases | true | Standard BED, and 54-30 = 24 | |
| The four-row BED sample | true | Byte-identical to the first four lines of the shipped `ARTIC-nCoV-2019-V3` `primers.bed` (diff clean) | |
| Column 5 is the primer pool, alternating 1 and 2 in a tiling scheme | true | Sample rows show 1,1,2,2; glossary entry agrees | |
| Column 6 strand `+` forward, `-` reverse | true | Sample rows | |
| "LGE counts every non-empty, non-comment row as one primer" | true | `PrimerSchemeImportService.swift:225-231` | |
| "it counts amplicons by stripping a trailing `_LEFT` or `_RIGHT` ... and then counting the distinct names left over" | true | `normalizedAmpliconName`, `:251-264` | |
| "It also drops a trailing dash followed by up to three digits, so `nCoV-2019_72_LEFT` and an alternate spelling such as `nCoV-2019_72_LEFT-1` fold onto the same amplicon rather than counting twice." | **false** | The two suffix rules run in that fixed order, so the dash-digit tag must sit *before* `_LEFT`, not after it. `_LEFT` is stripped only when the name ends in `_LEFT` (`:253`), which `nCoV-2019_72_LEFT-1` does not, so it normalizes to `nCoV-2019_72_LEFT` while `nCoV-2019_72_LEFT` normalizes to `nCoV-2019_72`. A live import of a 3-row BED holding `nCoV-2019_72_LEFT`, `nCoV-2019_72_LEFT-1`, and `nCoV-2019_72_RIGHT` returned `amplicon_count: 2`, not 1. The real convention is the QIAseq one: a 3-row BED holding `QIAseq_221_LEFT`, `QIAseq_221-2_LEFT`, `QIAseq_221_RIGHT` returned `amplicon_count: 1`. | "It also drops a trailing dash followed by up to three digits once that suffix has been removed, so a spare-primer name such as `QIAseq_221-2_LEFT` folds onto the same amplicon as `QIAseq_221_LEFT` rather than counting twice. The variant tag has to sit before the `_LEFT` or `_RIGHT`, which is where the shipped schemes put it." |
| "A scheme whose names follow neither convention still imports, but its amplicon count comes out equal to its primer count" | true | Live import of a 3-row BED with names `foo`, `bar`, `baz` returned `primer_count: 3`, `amplicon_count: 3` | |
| "a scheme built against one reference and applied to reads mapped against another can trim zero primers and raise no visible error" | true | Carried from 04-03 lines 152-161, which measured it. Consistent | |
| "the version suffix is ignored during matching, so `NC_045512` matches `NC_045512.2`" | true | `PrimerSchemeResolver.accessionsMatch` + `stripVersion`, `:118-131`, also case-insensitive | |
| "`lungfish-cli bam primer-trim --target-reference` overrides which contig name in the alignment the scheme is matched against" | true | Agrees verbatim with 04-03 line 179 | |
| "the trim rate iVar prints in the operation log is the only check" and the pointer to 04-03 | true | 04-03 lines 152-161 say exactly this | |
| "Both routes below run the same code and write the same bundle" | true | `PrimerSchemeImportViewModel.performImport` calls `PrimerSchemeImportService.importBundle` (`:84`), the same entry point as the CLI (`PrimerCommand.swift:53`) | |
| Menu path **File > Import Center...**, **Reference Sequences** tab | true | `ImportCenterViewModel.swift:597` `tab: .references`, `:180` title "Reference Sequences" | |
| Card titled **Primer Scheme**, file hint `.bed (+ optional .fasta/.fa/.fna)` | true | `ImportCenterViewModel.swift:593, 596`, verbatim | |
| Sheet titled **Import Primer Scheme** | true | `PrimerSchemeImportView.swift:35` | |
| "**Files** has a **BED** row ... and a **FASTA (optional)** row, each with a **Choose…** button" | true | `PrimerSchemeImportView.swift:41-53, 139` | |
| "**Identity** has four text fields, reading Name, Display name, Canonical reference accession, and Equivalent accessions" | true | `:57-63`. These are placeholder strings and the chapter paraphrases their leading words, which is a fair reading | |
| "The **Import** button stays disabled until a BED file, a name, and a canonical accession are all set" | true | `canRun`, `:88-92`, exactly three conditions | |
| "any slash in it is replaced with an underscore" | true | `PrimerSchemeImportViewModel.swift:81` | |
| "leave it empty to let the name serve as both" | true | `PrimerSchemeImportViewModel.swift:91`, `displayName.isEmpty ? safeName : displayName` | |
| "LGE writes `Primer Schemes/<name>.lungfishprimers` into the project" | true | `PrimerSchemesFolder.folderName` is `"Primer Schemes"` (`:19`); rerun wrote to that folder | |
| "The sheet offers no attachments picker, so a bundle built this way never carries an `attachments/` folder" | true | No attachments control in `PrimerSchemeImportView`, and `:110` passes `attachments: []` unconditionally | |
| "The sheet also writes no description, organism, source URL, or version into the manifest" | true | `PrimerSchemeImportViewModel.performImport` passes none of the four; `PrimerSchemeImportService.swift:136-137, 142-143` writes `nil` for all four | |
| "listed without its `.lungfishprimers` extension" in the sidebar | true | `SidebarProjectScanner.swift:318-319` maps the extension to `.primerSchemeBundle` | |
| Inspector row order: display name, description, counts side by side, reference and equivalents, then organism, source, version, then attachments | true | `PrimerSchemeInspectorView.swift:17-50`, exactly that order | |
| "That pane is read-only ... There is no editor and no command-line inspector" | true | The view has no bindings or controls; `primers` exposes only `import` | |
| The fixed command-line opener paragraph with "the sheet" swapped in | true | Matches CONSISTENCY.md lines 214-220 verbatim | |
| The eight-flag `primers import` example | true | Every flag exists with that spelling in live `primers import --help`; the rerun of that exact command exited 0 | |
| "That run printed one line and exited 0" and the quoted output line | true | Rerun printed `Primer scheme bundle written to <path>` and exited 0. `PrimerCommand.swift:45` | |
| "Only `--bed` and `--output` are required" | true | Live help: `--bed` and `--output` unbracketed, all others bracketed. `PrimerCommand.swift:20, 26` non-optional | |
| "`--fasta` copies a FASTA of the primer sequences themselves into the bundle rather than a reference genome" | true | Help text "Optional primer FASTA to copy into the bundle". Agrees with 04-03 line 193 | |
| "leaving it off makes the importer take the value from the BED file's first column" | true | `PrimerSchemeImportService.swift:107-109`; minimal rerun produced `MN908947.3` with no flag passed | |
| "`--display-name` ... defaults to the output filename's stem" | true | `:135` falls back to `safeName`; minimal rerun produced `MinimalPanel` | |
| "`--equivalent-accession` and `--attachment` may each be repeated" | true | Live help marks both "Repeatable"; `PrimerCommand.swift:38, 41` are arrays | |
| "With a project given, the bundle is written under that project's `Primer Schemes/` folder" | true | `resolvedBundleURL`, `:183-200`; rerun landed there | |
| "Without one, a relative path resolves from the directory you are standing in" | true | `:202-204` | |
| "An absolute `--output` path is honoured as given either way" | true | `:193-195` returns the absolute path before the project branch | |
| "The `.lungfishprimers` extension is appended for you when you leave it off" | true | `:179-181`; rerun `--output DemoPanel` produced `DemoPanel.lungfishprimers` | |
| "Running the same import a second time into the same project does not overwrite the first. It exits 1" | true | Rerun of the identical minimal command exited 1 | |
| Quoted duplicate error line | true | Rerun printed `Error: A primer scheme bundle already exists at <path>.` Matches `:70` | |
| The quoted MinimalPanel manifest JSON | true (with a formatting note) | Every key and value reproduced on rerun. The real output pretty-prints the accession object across five lines rather than the one line the chapter shows. Values are right; only the wrapping is condensed | Optional. Either re-quote the block verbatim from a run or add "shortened here", as the chapter already does for the provenance block |
| "`lungfish-cli primers` offers `import` and nothing else" | true | Live `primers --help` lists exactly one subcommand; `PrimerCommand.swift:10` | |
| "The importer writes nine lines into it" and the nine named fields in order | true | `writeMarkdownProvenance`, `:280-292`, nine content lines after the `# PROVENANCE` heading and blank line, in exactly that order. Rerun output matches | |
| Quoted `PROVENANCE.md` block including `Version: lungfish-cli 2026.9.13` | true | Rerun produced that block verbatim, same version string | |
| "the FASTA source path or the words \"not provided\"" | true | `:288`, `?? "not provided"` | |
| "A shipped scheme's `PROVENANCE.md` ... is a set of Markdown tables" naming build script, version, wall time, resolved options, Reference Verification, computed counts, input and output checksums and sizes, and a closing source and licence section | true | `Midnight-1200-V1/PROVENANCE.md` has all of those sections in that order, written by `scripts/build-primer-bundle.swift` | |
| "identical checksums on the canonical and equivalent rows are the evidence that the two accessions really are the same sequence" | true | Both rows carry `7d5621cd3b3e...68ca` | |
| "The `provenance/` folder ... exists only on bundles the importer wrote" | true | Absent from all eight shipped bundles, present on every rerun bundle | |
| `bundle.lungfish-provenance.json` holds argv array, durable replay command, resolved options beside defaults, file list with SHA-256 and byte size, runtime identity, exit status, wall time in seconds | true | Rerun file carries `argv`, `durableReplayArgv`, `reproducibleCommand`, `options.{explicit,defaults,resolvedDefaults}`, `files`, `runtimeIdentity`, `exitStatus`, `wallTimeSeconds` | |
| "one small sidecar per written file ... so `primers.bed.lungfish-provenance.json` covers the BED alone" | true | Rerun listing contains that exact filename | |
| "Nothing in LGE compares them for you" | true | No checksum-comparison path in the bundle or import code | |
| "`created` and `imported` are written from the clock at import time, so a regenerated bundle differs from the committed one in those two fields" | true | `:144-145`, `created: started` and `imported: Date()`. Both reruns wrote a fresh pair | |
| "Compare `primers.bed` instead, which the importer copies unchanged" | true | `:116` is a plain `copyItem`; rerun BED is byte-identical to the source | |
| Front matter `entry_points` (Import Center, `primers import`) | true | Both verified above | |
| "Every scheme LGE ships is a SARS-CoV-2 scheme, and this appendix uses SARS-CoV-2 examples for that reason rather than by preference" | true | All eight manifests carry organism "Severe acute respiratory syndrome coronavirus 2". This is the viral-by-design justification the campaign rules require, and it parallels 04-03 line 41 | |
| "A human or macaque amplicon panel imports through the same route and produces the same bundle" | true | Nothing in the importer or the format is organism-specific; a `chrX` BED imported cleanly on rerun | |

## Front matter

`glossary_refs` lists fourteen terms and all fourteen anchors exist in
`GLOSSARY.md`, including the two new ones. `shots` holds three ids and all
three markers appear in the body in the same order. `entry_points` are both
verified. `prereqs` point at two chapters that exist.

`fixtures_refs: []` is correct. `docs/user-manual/fixtures/` holds twelve
fixtures and none is a primer scheme, so there is no fixture to cite and the
chapter rightly carries no "Before you start" fixture sentence.

`features_refs: []` and the absence of a `parameters_refs` key are both
correct. `parameters.yaml` has no `primers` or `primers.import` operation id.
The one primer-related id, `bam.primer-trim`, belongs to chapter 04-03, which
already carries it in its own `parameters_refs` and documents all four iVar
settings. This appendix documents no operation of its own, so it owes no
Settings entries.

`brand_reviewed: false` and `lead_approved: false` are correct at this stage.

## Consistency

Consistent with CONSISTENCY.md. "Lungfish Genome Explorer" appears at first
mention with "LGE" after. The tool is named `lungfish-cli` throughout. Bundle
extensions are in code font. The menu path is bold with the ellipsis. The
command-line section opens with the fixed paragraph, with "the dialog" swapped
for "the sheet", which the ruling permits.

Consistent with chapter 04-03. Both say eight bundled schemes, both say none
ships a FASTA, both describe `--fasta` as primer sequences rather than a
reference, both name `--target-reference` as the remedy for a mismatched
contig name, and both treat the trim rate as the only check. The appendix
correctly declines to restate the trim procedure, the four iVar settings, or
the trim-rate threshold, and points at 04-03 instead. That also disposes of
DRIFT row 26 without repeating a `bam primer-trim` example that would have
needed `--name`.

Consistent with chapter 04-05. The appendix quotes only the Primer Trim
picker's headings, "Built-in" and "In This Project", which I confirmed at
`PrimerSchemePickerView.swift:21, 28`. It does not repeat 04-05's "Project"
heading, which is right, since the two pickers label that section differently.
The claim that the two sort orders differ is sound and explains 04-05's
alphabetically-first default of ARTIC SARS-CoV-2 V3.

One nuance worth recording rather than correcting. The shipped manifests'
counts were written by `scripts/build-primer-bundle.swift`, not by the
importer, so in principle they could have diverged from what the app's own
rule computes. They have not. I re-imported the QIAseq and Midnight BEDs
through the CLI and got 563/223 and 58/29, matching those manifests exactly.
The chapter's counting rule and its shipped table therefore agree.

## App defects

Defects 1, 2, 3, 4, and 5 in the author's report are all confirmed as written.

1. Confirmed. `PrimerSchemeImportView.swift:110` passes `attachments: []`
   unconditionally and the sheet has no attachments control, while the CLI's
   `--attachment` and the manifest's `attachments` array both work.
2. Confirmed. Neither description, organism, source URL, nor version reaches
   `PrimerSchemeImportService`, which writes `nil` for all four. A
   sheet-imported scheme's Inspector shows four fewer rows than a shipped one,
   with no in-app way to set them.
3. Confirmed. `PrimerCommand.swift:9` abstracts `primers` as "Build and
   inspect primer-scheme bundles" and live `primers --help` prints that line,
   but `:10` registers only `ImportSubcommand`. Nothing inspects.
4. Confirmed. `canonicalAccession` falls back to the first array entry
   (`PrimerSchemeBundle.swift:51-55`) and the decoder defaults both flags to
   false (`:84-85`) rather than rejecting the manifest. No warning is logged.
5. Confirmed, with a correction to the author's reasoning. `created: started`
   and `imported: Date()` are two different clock reads
   (`PrimerSchemeImportService.swift:144-145`), not one instant. They print
   identically only because the import finishes inside the same second, which
   both my reruns also did. The user-visible consequence the author describes
   is right, so the chapter's wording stands.
6. Confirmed as a linter defect, not an app defect. I reproduced it: copying
   the chapter with its two numeric columns changed from `---` to `---:`
   produces exactly two `sentence-colon` warnings. `sentence-colon.js:17`
   checks `tableCell` nodes and the alignment delimiter is counted as a colon
   in a cell. Any chapter with a right-aligned column fails strict lint. Worth
   a campaign-level fix, since the shipped `PROVENANCE.md` files use
   right-aligned size columns and a future chapter may want one.

New defect found in this review, minor and documentation-facing rather than
user-facing. The amplicon-name variant rule is order-dependent in a way
nothing documents or validates. `normalizedAmpliconName` strips `_LEFT` or
`_RIGHT` first and the `-N` tag second, so a scheme that spells its spare
primers `NAME_LEFT-1` instead of `NAME-1_LEFT` silently counts each variant as
its own amplicon. There is no warning, and the only symptom is an amplicon
count higher than the scheme really has. The shipped schemes all use the
supported spelling, so no bundled scheme is affected.

## Notes for the editor

One false claim to fix, in the BED expectations section, and it is a single
sentence. The corrected wording is in the claim table. Take the replacement
example from the QIAseq scheme, since `QIAseq_221-2_LEFT` beside
`QIAseq_221_LEFT` is a real pair of rows in a shipped BED and demonstrably
folds to one amplicon, whereas the current example is invented and does not.
Nothing else in that section changes, and the sentence after it, about
non-conforming names giving an amplicon count equal to the primer count, is
correct and should stay.

Optionally, re-quote the MinimalPanel manifest block from a real run or add
the "shortened here" hedge the chapter already uses for the provenance block.
The values are all correct; only the accession object's line wrapping was
condensed.

The three shot captions describe surfaces I verified in source but which no
one has photographed. The Screenshot Scout should treat the sheet's four
Identity placeholders and the Inspector's row order as claims to confirm
against the running app, since both are read from source here.

Lint is green. I reran
`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh
docs/user-manual/chapters/appendices/primer-schemes.md` and got
"no issues found", exit 0. `GLOSSARY.md` is likewise clean.

## Counts

True 88, false 1, unverifiable 0.
