# Author report, 06-classification/03-running-esviritu

Chapter 34 of the campaign roster. Registry id `classify.esviritu`, fixture
`sarscov2-srr36291587`. Rewritten in place on 2026-09-07 by the
bioinformatics-educator persona.

## Runs made

One real EsViritu run, from the CLI, in the chapter scratch at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/esviritu/`.
The reads were copied from the chapter 33 Kraken 2 scratch and not modified.

Command.

```
lungfish-cli esviritu detect \
  --input reads/SRR36291587_1.fastq --input reads/SRR36291587_2.fastq \
  --paired --sample SRR36291587 --output out -v
```

Database used. The managed EsViritu Viral DB, version `v3.2.4`, already
installed at `~/.lungfish/databases/esviritu/esviritu-viral-db/v3.2.4`.
`esviritu db-status` reports its size as 895.6 MB, `du -sh` reports 855M.
Tool version is EsViritu 1.3.3, the version the lock manifest pins
(`bioconda::esviritu=1.3.3=pyhdfd78af_0`). No download was needed.
`conda db install-managed --list` was checked and lists only
`human-scrubber`, `deacon-panhuman`, `deacon-ribokmers`, so it is not the
route to the EsViritu database.

Input. 85,199 read pairs (the copy in the chapter 33 scratch; the fixture
README says 86,281 pairs for the published accession, so the chapter avoids
quoting a pair count as a fixture property and quotes it only as a property
of the reference run).

Counts produced, all quoted in the chapter.

| Measure | Value |
|---|---|
| Runtime, end to end | 345.2 s |
| First minimap2 pass | 127.47 s |
| Reads before quality filter | 170,398 |
| Reads after quality filter | 170,180 |
| Viruses detected | 1 |
| Detection accession | `OP400692.1`, 29,808 bp |
| Detection name | Severe acute respiratory syndrome coronavirus 2 |
| Database description of it | SARS-CoV-2 Omicron-BQ.1.23 |
| Family | Coronaviridae |
| Reads mapped | 162,441 |
| RPKMF | 32,022.4 |
| Mean coverage | 1259.4x |
| Average read identity | 99.7% |
| Covered bases | 29,777 of 29,808, breadth 99.90% |
| Coverage windows | 100, thinnest window 319.4x |
| Segment | `NA` in the TSV, an em dash in the table cell |

Files the run wrote, all named in the chapter's command-line section.
`SRR36291587.detected_virus.info.tsv`,
`SRR36291587.detected_virus.assembly_summary.tsv`,
`SRR36291587.tax_profile.tsv`,
`SRR36291587.virus_coverage_windows.tsv`,
`SRR36291587_final_consensus.fasta`,
`SRR36291587_EsViritu_reactable.html`, `SRR36291587_esviritu.readstats.yaml`,
the fastp report pair, and `esviritu-result.json`.

`esviritu db-status` was also run and its four-line output is quoted verbatim
in the chapter.

## What was removed from the old chapter, and why

- **`classification` plugin pack.** No pack has that id. EsViritu is in
  `metagenomics`, shown as **Metagenomics**
  (`PluginPack.swift:771-778`). DRIFT false rows 2 and 7.
- **The whole `Tools > FASTQ/FASTA Operations > Classification…` menu path.**
  Replaced with `Tools > Classification > EsViritu...` throughout. DRIFT
  false row 14, and the ground-truth map's part-wide note.
- **"Install Database" button, "Database ready" badge, "EsViritu (installed)"
  picker with an install date, "Add second mate", the Inputs step, the
  Database step, the Options step.** None of these controls or strings exist.
  The dialog is one sheet with a Sample section, a Database status line, a
  Quality Filtering section, and an Advanced Settings disclosure. DRIFT false
  rows 9, 15, 16 and changed row 8.
- **"Min Read Length" as a top-level option beside the quality toggle.** It
  lives inside Advanced Settings. DRIFT changed row 17.
- **`--output` defaulting to `esviritu-<sample>` beside the input.** It
  defaults to the current directory. DRIFT false row 22.
- **The column list "accession, organism, read count, unique read count,
  RPKMF, coverage".** The real columns are Sample, Virus Name, Family, Reads,
  Unique Reads, RPKMF, Coverage, Identity, Segment. There is no Accession
  column and Organism is Virus Name. DRIFT changed row 26.
- **"coverage, the percent breadth of the reference covered" and the
  "95% breadth" worked reading.** This was the most consequential error in
  the old chapter. The Coverage column renders `String(format: "%.1fx",
  meanCoverage)` (`ViralDetectionTableView.swift:1799`), so it is mean
  **depth**, not breadth. The chapter now names depth explicitly, says in so
  many words that the column is not breadth, points the reader at the
  sparkline for breadth, and quotes the run's real breadth (99.90%) from the
  detection TSV's `covered_bases` rather than from the column.
- **"the run takes roughly 4 to 8 minutes"** as an unsourced duration.
  Replaced with the measured 345.2 s and 127.47 s from the reference run,
  both attributed to that run and that machine.
- **The four invented Operations Panel phases** (database load, mapping,
  coverage summarisation, report rendering). Replaced with the six real
  phase strings plus the four bracketing ones.
- **The "EsViritu evidence is reference-free" paragraph.** False, see below.
- **The whole "EsViritu compared with Kraken2" table and the "What you will
  learn" section.** Not template sections. The comparison survives as prose
  in Why you would do this, and the template's own section order now governs.
- **The "Batch runs" and "Interpretation" H2 sections.** Folded into
  Procedure and Reading the results so the template order holds.

## How each DRIFT unverifiable row was settled

Five rows were marked unverifiable. All five are now settled from source or
from the reference run.

- **Row 29, the row context menu's three items.** Settled TRUE and expanded.
  The menu is built in `ViralDetectionTableView.buildContextMenu()`
  (`:805-860`), not in `EsVirituResultViewController.swift`, which is why the
  reviewer could not find it. It holds **Extract Reads…**, a separator,
  **BLAST Verify…**, a separator, a **Look Up on NCBI** submenu with GenBank
  Accession, Assembly Record, PubMed Literature, and Taxonomy Browser, a
  separator, Copy Virus Name, Copy Accession, Copy Row as TSV, a separator,
  and Expand All / Collapse All. The chapter now documents the whole menu.
- **Row 31, "EsViritu evidence is reference-free".** Settled FALSE. It is the
  opposite of reference-free. `ViewerViewController+EsViritu.swift:58-73`
  installs an `EsVirituReferenceResolver` precisely so the viewport can find
  the managed database's pangenome FASTA, with the comment "without it the
  viewport reports 'reference: not provided' for every detection". The
  chapter replaces the claim with what the Inspector actually reports, the
  four `ClassifierAlignmentInspectorCapabilities.ReferenceValidation` labels
  ("No reference provided", "Structurally validated reference", "BAM M5
  validated reference", and the unavailable reason string) from
  `ClassifierAlignmentInspectorCapabilities.swift:24-31`, and explains that
  the two validated states do let the mismatch and consensus displays work.
- **Row 33, "fields without a value display an em dash".** Settled TRUE.
  `MetadataColumnController.swift:503` returns `"\u{2014}"` for a missing
  metadata value and `:535` renders it in tertiary label colour. The
  detection table uses the same glyph for a missing Family or Segment
  (`ViralDetectionTableView.swift:1662`, `:1684`). Kept, and the Segment
  em dash is now also shown in the reference run's result table.
- **Row 36, "roughly 4 to 8 minutes on an M-series laptop".** Settled by
  measurement. The reference run took 345.2 s end to end on a fourteen-core
  Mac, so the old range happened to bracket the truth but had no source. The
  chapter now quotes the measured figure and attributes it.
- **Row 37, the four Operations Panel phases.** Settled FALSE as written and
  replaced with the real strings. `EsVirituPipeline.swift:786-799` maps
  EsViritu's stderr onto "Quality filtering reads...", "Aligning reads to
  viral references...", "Screening for viral signatures...", "Assembling
  viral contigs...", "Calculating coverage statistics...", and "Building
  taxonomic profile...", and `:355-664` adds "Validating configuration...",
  "Detecting EsViritu version...", "Running EsViritu...", "Parsing detection
  results...", "Saving result metadata...", "Saving provenance...", and
  "Detection complete". The reference run's own stdout printed exactly these,
  which is where the chapter's list is taken from.

## Missing features now covered

Every row from the DRIFT missing table is in the chapter. The sample-name
text field and the Batch Samples list are in Procedure step 2 and in the
Settings entry for **Sample**. The limited-RAM banner is quoted verbatim in
Procedure step 2. The locked run-mode picker has its own Settings entry.
`--recursive` and `--db` are named in the command-line section, as are
`import esviritu` and `build-db esviritu` with their flags. The action bar's
Extract FASTQ button is in Acting on a row alongside the context menu. The
Identity and Family columns are in the column list and Identity has its own
paragraph in both Reading the results and What good looks like.

## Screenshot markers

Five markers, five matching `shots` entries, no `planned_shots` left.

| id | Placement | Change from the old stub |
|---|---|---|
| `esviritu-dialog` | Procedure step 2, at the Sample section | Renamed from `esviritu-wizard-tool-step` and recaptioned to name the FASTQ/FASTA Operations dialog and its real sections, per the DRIFT screenshot row. |
| `esviritu-database-missing` | Procedure step 2, at the Database section | Kept, recaptioned to "Database not installed" with the **Download Database...** button. Moved out of the Plugin Manager install step into the dialog walkthrough, which is the placement the DRIFT row asked for. |
| `esviritu-advanced-settings` | Procedure step 2, at the defaults step | New. The three Advanced Settings controls each get a Settings paragraph and the reader needs to see where the disclosure is. |
| `esviritu-result-viewport` | End of Procedure step 3 | Kept, recaptioned to name the detection table and the detail pane rather than "per-virus coverage sparklines", since there is one sparkline column rather than a sparkline view. |
| `esviritu-alignment-evidence` | Reading the results, Auditing a detection | Renamed from `esviritu-bam-viewer` and recaptioned to say the viewer fills the detail pane on row selection. |

## Glossary additions

Three terms added to `GLOSSARY.md` in the existing entry shape and in
alphabetical order, all three listed in `glossary_refs`.

- **minimap2** (`{#minimap2}`), inserted before Minimizer. Needed because the
  chapter now says which tool does EsViritu's mapping.
- **Pangenome** (`{#pangenome}`), inserted before Pathoplexus. Needed for the
  Inspector paragraph, which has to say what EsViritu maps against.
- **RPKMF** (`{#rpkmf}`), inserted before Representative reads. Needed
  because RPKMF is a column the reader must interpret and the old chapter
  glossed it only inline.

No existing entry was edited. `esviritu` and `coverage-breadth` already
existed and both were checked against the chapter's use.

## Consistency with the rest of Part 6

- Menu path `Tools > Classification > EsViritu...`, matching chapters 01 and
  02 and CONSISTENCY.md.
- Result folder `Analyses/esviritu-<timestamp>/`, per CONSISTENCY.md.
- Plugin pack named `metagenomics`, shown as **Metagenomics**, carrying
  Kraken 2, Bracken, RiboDetector, matching chapters 01 and 02.
- Plugin Manager opened with **Tools > Plugin Manager...** (Cmd-Shift-B),
  Operations Panel with **Operations > Show Operations Panel** (Cmd-Shift-P).
- No per-classifier colour is claimed anywhere. The chapter never assigns a
  colour to EsViritu.
- Fixture named "the SRR36291587 SARS-CoV-2 reads" and linked to the GitHub
  fixture folder in Before you start, with the two fixed opener sentences.
- Extractions land in the project's `Extractions` folder, matching chapter 02.

## Possible app defects found

1. **The recorded EsViritu tool version is the Python version, not the tool
   version.** `esviritu-result.json` from the reference run holds
   `"toolVersion": "3.14"` and the CLI summary printed `Tool: EsViritu 3.14`.
   The installed tool is EsViritu 1.3.3. The cause is that
   `EsViritu --version` prints three lines, a `RuntimeWarning` about the GIL,
   then the site-packages path
   `.../lib/python3.14t/site-packages/EsViritu`, then `1.3.3`, and
   `detectToolVersion` (called at `EsVirituPipeline.swift:379`) takes a
   version-shaped token from the wrong line. This is a provenance-integrity
   bug, since the run record names a version the tool never had, and it
   would put a wrong version into a methods export. The chapter warns the
   reader about it in the command-line section and tells them to read the
   version off the Plugin Manager instead. Worth fixing at source.

2. **The database size in the lock manifest disagrees with reality by about
   6x.** `third-party-tools-lock.json` gives `esviritu-viral-v3` a
   `sizeOnDisk` of 5368709120 (5 GB). The installed copy is 855M on disk and
   `esviritu db-status` reports 895.6 MB. Separately, the CLI's
   `download-db` path prints `Size: ~2 GB (compressed)`
   (`EsVirituCommand.swift:311`) while the same manifest entry's `sizeBytes`
   is 419430400 (400 MB). Three numbers, no two of which agree. The chapter
   therefore quotes only the measured installed size and the 8 GB memory
   recommendation, and says nothing about download size. Low severity but it
   will mislead anyone budgeting disk.

3. **`conda db install-managed --list` does not list the EsViritu database.**
   It returns only `human-scrubber`, `deacon-panhuman`, and
   `deacon-ribokmers`. This is probably by design, since EsViritu has its own
   `esviritu download-db` subcommand, but a reader told to check the managed
   database list will not find EsViritu there. Noted rather than claimed as a
   bug. The chapter routes database installation through the Plugin Manager's
   Databases tab and `esviritu download-db` only.

4. **The EsViritu run log is deleted on success.** During the run,
   `out/SRR36291587_esviritu.log` existed and was the only readable source of
   phase timings. It is gone from the finished output directory. That makes
   a completed run harder to debug after the fact than a running one. Not
   documented in the chapter, since the reader has the Operations Panel row
   instead, but worth a look.
