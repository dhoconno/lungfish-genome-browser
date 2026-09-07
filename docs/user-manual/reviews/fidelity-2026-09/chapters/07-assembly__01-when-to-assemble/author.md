# Author record: 07-assembly/01-when-to-assemble

Author pass by the bioinformatics-educator on 2026-09-07, against the
2026.9.13 Preview build's source tree in the campaign worktree.

Roster row 46. Title "When to Assemble". No registry ids, so
`parameters_refs` stays empty and the chapter documents no Settings
entries. Fixture human-mito.

## Section order chosen

Concept-chapter shape, following the committed model chapter
`06-classification/01-what-is-classification.md`:

1. What it is
2. Why you would do this
3. What LGE ships, and what it does not
4. How the sheet decides what you may run
5. Working out which assembler you want
6. Two assemblers on the same human reads
7. What the numbers mean
8. Where the result lands
9. What good looks like
10. Next

### Template sections deliberately dropped

- **Before you start.** This chapter opens no dialog and asks the reader
  to run nothing. Its two prerequisites (a project, a reads bundle) are
  stated where they matter, in the paragraph about selecting reads before
  opening the menu. The fixed two-sentence Before you start block belongs
  to procedure chapters, and chapters 02 to 04 carry it.
- **Procedure.** There is no procedure. The decision this chapter teaches
  is made before any window opens, and every actual run lives in chapters
  02 and 03.
- **Settings.** No registry ids on the roster row, and every assembly
  setting belongs to chapters 02 and 03, which carry `assemble.spades`,
  `assemble.megahit`, `assemble.skesa`, `assemble.flye`, and
  `assemble.hifiasm` between them. Documenting them here would duplicate
  those chapters and split the three-sentence Settings entries across two
  files.
- **On the command line.** Editorial rule 6 attaches the CLI appendix to
  chapters that walk a GUI procedure. This one walks none. `lungfish-cli
  assemble` is documented in chapter 02.
- **Troubleshooting.** The one failure mode this chapter needed to name,
  the MEGAHIT arm64 abort, is stated in the comparison section where the
  reader meets it, and the `completedWithNoContigs` outcome is stated in
  "Where the result lands". Neither warranted a section of its own in a
  chapter with no procedure to fail.

## Commands run

All commands run from the campaign worktree root
(`/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign`),
with output under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-concept/`.
Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

### 1. MEGAHIT on the human-mito reads

```
lungfish-cli assemble --assembler megahit --read-type illumina-short-reads \
  --paired --output <scratch>/megahit --project-name HG002-chrM-megahit \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R1.fastq.gz \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R2.fastq.gz
```

**Result: FAILED.** MEGAHIT reported `Exit code -6` (SIGABRT) at the
k=99 `assemble` step, and the CLI reported "MEGAHIT failed (exit 250)".
No `contigs.fasta` and no `assembly-result.json` were produced. The
process aborted immediately after "Tips removal done", inside
`megahit_core_no_hw_accel assemble`. The run took under 2 seconds of
wall time before aborting.

Note that the shell pipeline's `$?` read 0 because the invocation was
piped to `tail`; the failure is unambiguous from the CLI's own `✗
MEGAHIT failed (exit 250)` line and from the absent output files. Both
of the app's existing arm64 workarounds were active and visible in the
log, the 2-thread cap ("Threads : 2") and `--no-hw-accel` ("Using
megahit_core without POPCNT and BMI2 support, because --no-hw-accel
option manually specified").

**Figures taken:** none. The chapter quotes no MEGAHIT numbers. It
states the failure as a caution instead.

### 2. SKESA on the human-mito reads

```
lungfish-cli assemble --assembler skesa --read-type illumina-short-reads \
  --paired --output <scratch>/skesa --project-name HG002-chrM-skesa \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R1.fastq.gz \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R2.fastq.gz
```

**Result: exit 0, completed.** Read back from
`<scratch>/skesa/assembly-result.json`:

| Field | Value |
|---|---|
| tool | skesa |
| assemblerVersion | 2.5.1 |
| outcome | completed |
| contigCount | 1 |
| totalLengthBP | 16570 |
| largestContigBP | 16570 |
| n50 | 16570 |
| l50 | 1 |
| gcFraction | 0.444055522027761 (44.4%) |
| wallTimeSeconds | 1.5956580638885498 |

Contig header from `<scratch>/skesa/contigs.fasta`:
`>Contig_1_257.173_Circ [topology=circular]`.

**Figures quoted in the chapter:** 1 contig, 16,570 bp, N50 16,570, L50
1, 44.4% GC, 1.6 seconds, and the `[topology=circular]` header label.

### 3. SPAdes figures (not re-run)

The SPAdes numbers are taken from the committed fixture's own verified
run rather than re-executed, since the fixture ships the result and its
README records the run. Source:
`docs/user-manual/fixtures/human-mito/expected/spades/assembly-result.json`,
observed 2026-09-06, cross-checked against the same figures in
`docs/user-manual/fixtures/human-mito/README.md`.

| Field | Value |
|---|---|
| tool | spades |
| assemblerVersion | 4.3.0 |
| outcome | completed |
| contigCount | 1 |
| totalLengthBP | 16697 |
| n50 | 16697 |
| l50 | 1 |
| gcFraction | 0.4444510989998203 (44.4%) |
| wallTimeSeconds | 13.719936966896057 |

Contig header: `>NODE_1_length_16697_cov_121.957333`.

**Figures quoted in the chapter:** 1 contig, 16,697 bp, N50 16,697, L50
1, 44.4% GC, 13.7 seconds, and the 128 bp / 0.8% overshoot against the
16,569 bp reference. The 127 bp SPAdes-minus-SKESA difference is
arithmetic on the two figures above.

### 4. Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/07-assembly/01-when-to-assemble.md
```

Run three times. First run (pre-rewrite baseline) 17 warnings. Second
run (post-rewrite) 1 warning, an `assembly-submenu` shot declared with no
matching body marker. Third run, after adding the marker and its
paragraph, exit 0:

```
docs/user-manual/chapters/07-assembly/01-when-to-assemble.md: no issues found
```

## Source files consulted

Assembly model and pipeline:

- `Sources/LungfishWorkflow/Assembly/AssemblyTool.swift` (the five tools,
  display names, per-tool micromamba environment names)
- `Sources/LungfishWorkflow/Assembly/AssemblyCompatibility.swift` (the
  read-class gate and the hybrid blocking message, verbatim)
- `Sources/LungfishWorkflow/Assembly/AssemblyReadType.swift` (the three
  read classes, their display names, header sniffing, CLI spellings)
- `Sources/LungfishWorkflow/Assembly/ManagedAssemblyPipeline.swift`
  (per-tool command construction, output directory handling)
- `Sources/LungfishWorkflow/Assembly/AssemblyOutputNormalizer.swift` (the
  `completedWithNoContigs` outcome at lines 66-71)
- `Sources/LungfishWorkflow/Assembly/AssemblyBundleBuilder.swift` (the
  `<name>.lungfishref` publish path at lines 89-101, bgzip and index of
  the assembler's own FASTA without reordering)
- `Sources/LungfishWorkflow/Conda/PluginPack.swift` (the `assembly` pack,
  name "Genome Assembly", `estimatedSizeMB: 950`, its five requirements)
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
  lines 42-46 (SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6,
  hifiasm 0.25.0)

Wizard and menu:

- `Sources/LungfishApp/Views/Assembly/AssemblyWizardSheet.swift` (Inputs
  section read-only rows at 474-490, Assembler picker at 494-504, Read
  Type row and its "Locked from FASTQ header detection." note at 505-522,
  Readiness panel at 645-700, Output Folder row at 635-641, the
  mixed-detection message at 56-57, the multi-bundle run policy and its
  lock reason at 165-180, the long-read multi-file rejection at 268-276,
  `buildRequest` at 761-784)
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift` lines
  33-44 (the five assembly tool ids routing to the one shared sheet)
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
  `defaultOutputDirectory` at 1607-1613 (returns `projectURL/Analyses`)
- `Sources/LungfishApp/Views/MainWindow/MainSplitViewController+GenomicsDisplay.swift`
  lines 1215-1226 (the `.assemble` branch calling
  `AnalysesFolder.createAnalysisDirectory(tool:in:)` with
  `assemblyRequest.tool.rawValue`) and 1195-1214 (the batch branch
  reusing one shared batch root)
- `Sources/LungfishApp/Views/Sidebar/SidebarViewController+MenuDelegate.swift`
  lines 207-212 (the "Reassemble..." item, gated on assembly provenance)

Viewport:

- `Sources/LungfishAssemblyUI/AssemblySummaryStrip.swift` `summaryFields`
  at 321-341 (Assembler, Read Type, Contigs, Total bp, N50, L50, Longest,
  Global GC, then optional Version and Wall Time)
- `Sources/LungfishAssemblyUI/AssemblyContigTableView.swift`
  `columnSpecs` at 19-47 (#, Contig, Length (bp), GC %, Share of Assembly
  (%), Sequence Preview)
- `Sources/LungfishAssemblyUI/AssemblyActionBar.swift` lines 10-13 (BLAST
  Contigs, Copy FASTA, Export FASTA, Create Bundle)

Storage and statistics:

- `Sources/LungfishIO/Bundles/AnalysesFolder.swift` (directory name at
  18, `knownTools` at 24-27 including all five assemblers, the
  `{tool}-{timestamp}` and `{tool}-batch-{timestamp}` shapes at 118-137)
- `Sources/LungfishIO/Assembly/AssemblyStatistics.swift` lines 24-27 and
  138-155 (the N50 and L50 definitions used for the "What the numbers
  mean" section, and the descending sort that `computeNx` walks)

CLI and campaign docs:

- `docs/user-manual/reviews/fidelity-2026-09/cli-help/assemble.txt`
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/07-assembly.md`
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md` (chapter section at
  lines 2327-2378)
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/ARCHITECTURE.md` (editorial rules, the 07 Assembly
  TOC entries)
- `docs/user-manual/chapters/06-classification/01-what-is-classification.md`
  and its `fable-gate.md` (concept-chapter model)
- `docs/user-manual/fixtures/human-mito/README.md`
- `docs/user-manual/GLOSSARY.md`

## DRIFT rows applied

All five false claims and all six changed claims from the chapter's
DRIFT section are applied:

- Row 1 (false). `entry_points` replaced with the five
  `Tools > Assembly > <tool>...` paths.
- Row 3 (changed). "five assemblers behind one shared configuration
  sheet", reached by picking a tool under **Tools > Assembly**, opening
  with that tool preselected.
- Rows 4 and 19 (changed). Output is a `.lungfishref` bundle in a per-run
  folder under `Analyses/`. The chapter states the folder shape
  `spades-2026-09-07T05-14-22` and the `spades-batch-` variant, and says
  outright that there is no `Assemblies/` folder.
- Row 5 (changed). Contigs in a table, statistics in the viewport's
  summary strip, with the strip's full field list.
- Row 6 (false). Five menu items, one per assembler, opening the same
  sheet whose segmented Assembler control switches between the
  compatible tools.
- Row 13 (false). The size column is headed "Practical size ceiling, not
  enforced by the app", and a sentence before the table says nothing in
  LGE checks genome size or warns you.
- Row 20 (changed). The FASTA holds the assembler's own order, the table
  ranks by length, SPAdes and MEGAHIT happen to emit longest-first and
  Flye and hifiasm do not promise it.
- Row 21 (changed). The summary strip's nine-to-eleven fields, with
  version and wall time marked conditional.
- Row 22 (false). One sidebar item, contigs as table rows, and Create
  Bundle plus a pointer to chapter 04 as the route to a sequence
  viewport.
- Row 23 (false). "minimap2, BWA-MEM2, Bowtie2, or BBMap under
  **Tools > Mapping**".

## Missing rows covered

All eleven Missing rows are now in the chapter:

| Missing row | Where it landed |
|---|---|
| Assembly category submenu, one item per assembler | "What LGE ships", the paragraph before the `assembly-submenu` shot |
| Genome Assembly pack and the Readiness panel | "What LGE ships", first paragraph |
| Pinned versions 4.3.0 / 1.2.9 / 2.5.1 / 2.9.6 / 0.25.0 | "What LGE ships", second paragraph |
| Read Type picker, locked vs editable | "How the sheet decides", second paragraph |
| Hybrid blocking message (verbatim) | "How the sheet decides", third paragraph |
| Mixed detected-and-unclassified message (verbatim) | same paragraph |
| Multi-bundle run mode picker, locked to per-bundle | "How the sheet decides", fourth paragraph |
| Long-read tools reject multi-file selections | same paragraph |
| MEGAHIT arm64 thread cap and `--no-hw-accel` | "Two assemblers on the same human reads", final paragraph, and this record's run 1 |
| Sidebar "Reassemble..." | "Where the result lands", final paragraph |
| `completedWithNoContigs` | "Where the result lands" final paragraph, and check 1 of "What good looks like" |

## Where assemblies land, as verified

`Analyses/<tool>-<timestamp>/`, holding the `.lungfishref` bundle.

The chain is: the operations dialog's `defaultOutputDirectory` returns
`projectURL/Analyses`
(`FASTQOperationDialogState.swift:1607-1610`); the `.assemble` branch of
`MainSplitViewController+GenomicsDisplay.swift:1215-1226` then calls
`AnalysesFolder.createAnalysisDirectory(tool: assemblyRequest.tool.rawValue,
in: currentProjectURL)`, which builds `Analyses/{tool}-{yyyy-MM-dd'T'HH-mm-ss}/`
(`AnalysesFolder.swift:118-137`), or `{tool}-batch-{timestamp}` for a
batch; `AssemblyBundleBuilder.build` then publishes
`<name>.lungfishref` into that directory
(`AssemblyBundleBuilder.swift:89-101`).

The tool segment is `AssemblyTool.rawValue`, so `spades`, `megahit`,
`skesa`, `flye`, `hifiasm`. It is **not**
`AssemblyTool.analysisDirectoryPrefix`, which would give
`assembly-spades`. That property exists on `AssemblyTool.swift:37-40` and
has no call sites anywhere in `Sources/`, so it is dead code. Flagged
below.

The CLI is different and the chapter does not claim otherwise. `lungfish-cli
assemble --output <dir>` writes exactly where you point it, with no
timestamped folder created. This is visible in the demo project, whose
assembly sits at `Analyses/HG002-chrM/` rather than at
`Analyses/spades-<timestamp>/`, because it was produced by a CLI run
with an explicit `--output`.

## Defects found

1. **MEGAHIT 1.2.9 aborts on Apple Silicon.** Reproduced above on a
   19,916-read, 16.5 kb-target dataset. `megahit_core_no_hw_accel
   assemble` exits `-6` (SIGABRT) at k=99, immediately after tip
   removal, with both existing workarounds (2-thread cap from
   `AssemblyRunRequest.swift:99-104`, `--no-hw-accel` from
   `ManagedAssemblyPipeline.swift:233-236`) active. This is not a
   large-input or memory problem, and the log line "Memory used:
   46385646796" on a machine reporting 30 GB available to SKESA in the
   same session suggests MEGAHIT's own memory sizing on this platform is
   also wrong. As shipped, the MEGAHIT path in the Assembly submenu
   cannot complete a run on this hardware. Chapter 02 documents MEGAHIT
   as a runnable option, so this needs an engineering decision rather
   than only a documentation note.

2. **`AssemblyTool.analysisDirectoryPrefix` is dead code.**
   `AssemblyTool.swift:37-40` returns `"assembly-\(rawValue)"` and its
   doc comment calls it the "stable analysis-directory prefix for
   normalized output bundles", but a grep across `Sources/` finds no
   caller. The real directory name uses the bare `rawValue`. A future
   reader trusting the comment would document the wrong folder name.
   This is the likely origin of the campaign's recurring `Assemblies/`
   confusion.

3. **Min Contig is inert for SPAdes** (inherited, not re-verified here).
   The DRIFT report's row 11 for chapter 02 records that the stepper's
   value never reaches SPAdes and that
   `AssemblyOptionCatalog.swift:128` advertises a "Lungfish post-filter"
   that is not implemented. This chapter documents no settings, so it
   states nothing about it. Left to chapter 02's author, flagged here
   only so the two records agree.

## Fixture handling

The chapter cites the human-mito fixture by the CONSISTENCY name "the
HG002 mitochondrial reads". No license text is inlined. The fixture has
complete metadata, a citation block, and a fetch and regenerate script.
The read count (9,958 pairs), the coverage figure (about 300-fold), the
reference length (16,569 bp), and the accession (`NC_012920.1`) come
from the fixture README's Downsampling and Genome sections.

The chapter uses human data throughout, per the campaign's human and
macaque preference. The previous version's worked comparison used the
SRR36291587 SARS-CoV-2 amplicon run and quoted unverified expectations
("expect one contig or a small handful, the longest near 29.9 kb"). That
whole passage is replaced by the two real human runs above.

## What could not be verified

1. **No GUI run was made.** Every figure comes from `lungfish-cli` or
   from source. The menu path, submenu contents, the Assembler and Read
   Type controls, the Readiness panel, the summary strip, the contig
   table columns, the action bar, and the Reassemble item are all read
   from source rather than seen on screen. The three declared shots are
   the check on this, and the Screenshot Scout's captures will either
   confirm the descriptions or return the chapter.

2. **The `Analyses/<tool>-<timestamp>/` folder was never observed from a
   GUI run.** The path is traced through source with the call sites above
   and is consistent with the CONSISTENCY ruling, but the only assembly
   folder on disk in the demo project came from a CLI run with an
   explicit `--output` and so is named `HG002-chrM`. A GUI assembly on
   the fixture would settle it directly, and the
   `assembly-bundle-in-analyses` shot should be captured from one.

3. **Flye and hifiasm were not run.** Neither the ONT nor the HiFi path
   was exercised. The chapter quotes no figures from either and states
   only their read-class gating, which is read from
   `AssemblyCompatibility.swift:16-22`. Chapter 03 owns those runs.

4. **The Readiness panel's wording with the pack absent was not seen.**
   The Genome Assembly pack is installed on this machine, so the
   missing-pack state could not be triggered. The chapter says the panel
   "names what is missing" rather than quoting any string.

5. **The 950 MB pack size is the manifest's `estimatedSizeMB`**, not a
   measured install size. The chapter says "roughly 950 MB installed",
   which is the hedge that claim needs.

6. **MEGAHIT's behaviour on Intel Macs is unknown.** The chapter scopes
   the failure to Apple Silicon, which is what the workarounds in source
   scope themselves to and what this machine is. Whether the same build
   completes on x86_64 was not tested.

7. **The 95% identity threshold for "a reference fits"** is domain
   guidance with no app enforcement behind it, presented as a rough
   figure ("somewhere above roughly 95%"). Nothing in LGE checks it.

## Glossary

Five entries added, alphabetically, in the existing one-sentence-plus-
"See also:" shape:

- **Assembly graph** (after Assembly bundle)
- **De novo assembly** (opening section D, before Deacon)
- **L50** (opening section L, before LabKey)
- **Scaffold** (between savONT and seqkit)
- **Structural variation** (before Substitution model)

All five are listed in `glossary_refs`, along with the eleven existing
terms the chapter deep-links. All sixteen anchors were verified to
resolve against `GLOSSARY.md`.

## Front matter

`estimated_reading_min` raised from 8 to 14, matching the chapter's
growth from roughly 1,400 to roughly 2,900 words and the model chapter's
15 for comparable length. `brand_reviewed: false` and `lead_approved:
false` left as required. `parameters_refs: []` added, since the roster
row lists no ids and the template expects the key. `fixtures_refs`
set to `[human-mito]`, which the previous version left empty.

Shots changed from two planned to three declared, all three needing
capture:

- `assembly-submenu` (new)
- `assembly-sheet-assembler-picker` (replaces
  `assembly-wizard-assembler-picker`, recaptioned per the reality map's
  instruction that the picker never shows all five at once for a
  detected bundle)
- `assembly-bundle-in-analyses` (replaces `assembly-bundle-in-sidebar`,
  recaptioned for the right folder and the right pane)

The `assembly-vs-mapping` illustration is kept unchanged. The reality map
rules it still valid, its PNG is committed, and the chapter's opening
section is still its right home.
