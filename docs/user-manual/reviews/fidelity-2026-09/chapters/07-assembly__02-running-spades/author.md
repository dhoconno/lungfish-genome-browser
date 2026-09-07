# Author record: 07-assembly/02-running-spades

Chapter rewritten in place for Preview 2026.9.13. Roster row 47.
Registry ids `assemble.spades`, `assemble.megahit`, `assemble.skesa`.
Fixture `human-mito`.

## Commands run

Scratchpad:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-spades/`

All three assembler conda environments (`spades`, `megahit`, `skesa`) were
already present under `~/.lungfish/conda/envs/`, so no `lungfish-cli conda
install` was needed. Verified by `ls ~/.lungfish/conda/envs/`, exit 0.

Fixture reads copied from `docs/user-manual/fixtures/human-mito/`
(`HG002.chrM_R1.fastq.gz`, `HG002.chrM_R2.fastq.gz`). Read count confirmed
by gzip line count, 39,832 lines in R1, so 9,958 pairs.

### SPAdes, exit 0

```
lungfish-cli assemble HG002.chrM_R1.fastq.gz HG002.chrM_R2.fastq.gz \
  --paired --assembler spades --profile isolate \
  --project-name HG002.chrM_assembly --output ./out-spades
```

Figures taken from the run's own stdout and from `out-spades/assembly-result.json`.

| Figure | Value |
|---|---|
| Wall time | 110.7s (`wallTimeSeconds` 110.70146906375885) |
| Version | 4.3.0 |
| Contigs | 1 |
| Total bp | 16697 |
| Longest | 16697 |
| N50 | 16697 |
| L50 | 1 |
| Global GC | 44.4% (`gcFraction` 0.4444510989998203) |
| Contig header | `NODE_1_length_16697_cov_121.957333` |

Resolved command line recorded in the JSON was
`spades.py --isolate -1 <R1> -2 <R2> -o <out> --threads 14`.
Note that no `--memory` reached the command, because the CLI run passed no
`--memory-gb`. The GUI slider always supplies one.

### MEGAHIT, exit 0

```
lungfish-cli assemble HG002.chrM_R1.fastq.gz HG002.chrM_R2.fastq.gz \
  --paired --assembler megahit \
  --project-name HG002.chrM_megahit --output ./out-megahit
```

| Figure | Value |
|---|---|
| Wall time | 2.7s |
| Version | 1.2.9 |
| Contigs | 3 |
| Total bp | 17405 |
| Longest | 16711 |
| N50 | 16711 |
| Global GC | 44.6% |
| Contig headers | `k141_0 ... len=332`, `k141_2 ... len=362`, `k141_1 ... len=16711` |

Confirms the Apple Silicon behaviour the reality map lists as missing. The
run reported `Threads : 2` on a fourteen-core machine and the recorded
command line ends `--num-cpu-threads 2 --no-hw-accel`. MEGAHIT's own log line
"Using megahit_core without POPCNT and BMI2 support, because --no-hw-accel
option manually specified" appeared in stdout.

### SKESA, exit 0

```
lungfish-cli assemble HG002.chrM_R1.fastq.gz HG002.chrM_R2.fastq.gz \
  --paired --assembler skesa \
  --project-name HG002.chrM_skesa --output ./out-skesa
```

| Figure | Value |
|---|---|
| Wall time | 1.6s |
| Version | 2.5.1 |
| Contigs | 1 |
| Total bp | 16570 |
| Longest | 16570 |
| N50 | 16570 |
| Global GC | 44.4% |
| Contig header | `Contig_1_257.173_Circ [topology=circular]` |

Confirms the pinned `--min_count 2`. The recorded command line ends
`--cores 14 --min_count 2`.

### Where the results landed

Each CLI run wrote to the `--output` directory given. Each holds
`contigs.fasta` (or `final.contigs.fa` for MEGAHIT), `contigs.fasta.fai`,
`assembly.log`, and `assembly-result.json` with schemaVersion 3. In the app
the same run lands in a per-run folder `Analyses/<tool>-<timestamp>/`, per
`AnalysesFolder.swift:121-122`, with the `.lungfishref` bundle inside it.
There is no `Assemblies/` folder.

### Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/07-assembly/02-running-spades.md
```

Final result, exit 0:
`docs/user-manual/chapters/07-assembly/02-running-spades.md: no issues found`

Four warnings were fixed on the way. A declared shot whose marker was indented
inside a numbered step and so not detected, a six-item procedure list over the
five-item cap, an in-sentence colon in the Readiness step, and a semicolon
inside a quoted app string in the Run Mode entry. The Run Mode caption is now
paraphrased rather than quoted, because the app's own string carries a
semicolon the prose rules forbid.

## Source files consulted

- `Sources/LungfishApp/Views/Assembly/AssemblyWizardSheet.swift` (section
  titles at 476/494/580/627/648, Inputs rows 474-490, Read Type lock 507-524,
  validation strings 29-52, readiness panel 646-695)
- `Sources/LungfishWorkflow/Assembly/AssemblyOptionCatalog.swift`
- `Sources/LungfishWorkflow/Assembly/ManagedAssemblyPipeline.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyRunRequest.swift`
- `Sources/LungfishWorkflow/Assembly/AssemblyBundleBuilder.swift` (89-105)
- `Sources/LungfishWorkflow/Conda/PluginPack.swift` (669-670, pack name
  "Genome Assembly", id `assembly`)
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
  (pinned 4.3.0 / 1.2.9 / 2.5.1 / 2.9.6 / 0.25.0)
- `Sources/LungfishIO/Bundles/AnalysesFolder.swift` (115-130)
- `Sources/LungfishIO/Assembly/AssemblyStatistics.swift` (`computeFromLengths`
  136-176 and `computeNx` 180-190, which is where the N50 definition in the
  chapter comes from)
- `Sources/LungfishAssemblyUI/AssemblyContigTableView.swift` (six columns,
  18-45)
- `Sources/LungfishAssemblyUI/AssemblySummaryStrip.swift` (`summaryFields`
  321-340, ten fields with Version and Wall Time conditional)
- `Sources/LungfishAssemblyUI/AssemblyContigDetailPane.swift`
  (`showSingleSelection` 264-272, five values plus sequence)
- `Sources/LungfishAssemblyUI/AssemblyActionBar.swift` (10-13, 55-68,
  including the BLAST Contig singular retitle)
- `Sources/LungfishAssemblyUI/AssemblyLayoutPreference.swift` (three layouts,
  `detailLeading` default)
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
  (1985-1996, tool display titles)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/assemble.txt`
- `docs/user-manual/parameters.yaml` (4801-5119)
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/07-assembly.md`
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md` (2380-2455)
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/ARCHITECTURE.md`, `docs/user-manual/STYLE.md`
- Style references: `06-classification/02-running-kraken2.md`,
  `06-classification/03-running-esviritu.md`

## Glossary terms added

Two, both alphabetically placed and listed in `glossary_refs`.

- **De Bruijn graph** `{#de-bruijn-graph}`, inserted before "De novo assembly"
  in section D.
- **Error correction** `{#error-correction}`, inserted between "ENA" and
  "EsViritu" in section E.

## Drift coverage

All six false claims and all eight changed claims from the chapter's DRIFT
section are applied. Every Missing row is covered somewhere in the chapter,
with these homes.

| Missing row | Where it landed |
|---|---|
| Readiness panel | Procedure, paragraph after step 5 |
| Validation message strip | Same paragraph |
| Inputs rows Dataset / Read Layout / Detected | Procedure step 3 |
| Read Type picker and lock caption | Procedure step 4 and the Read Type setting |
| Extra arguments field and its parse error | Extra arguments setting |
| Output Folder read-only row | Output Folder setting |
| Multi-bundle Run Mode picker, locked | Run Mode setting |
| MEGAHIT thread cap and `--no-hw-accel` | Threads setting, with the measured `Threads : 2` |
| Per-tool advanced option descriptions | Named as the sheet's printed summaries in the Settings lead |
| Action bar four buttons, disabled until selection | Reading the results, last paragraph |
| Contig-table context menu three items | Same paragraph |
| Three panel layouts | Reading the results, first paragraph |
| Share of Assembly and Sequence Preview columns | Reading the results, contig table paragraph |
| L50 and Global GC in the summary strip | Reading the results, N50 paragraph |
| Pinned versions 4.3.0 / 1.2.9 / 2.5.1 | Before you start, plus the comparison table |

## Screenshots

Front matter now declares four shots, up from three planned. The `shots` list
and the body markers agree one to one. `contig-inspector` was dropped and
respecified as `contig-detail-pane` per the drift ruling, and its marker moved
to follow the corrected "Click the row" paragraph. One shot was added,
`assembly-advanced-settings`, because the Careful mode and Skip error
correction toggles live inside a disclosure the reader will not find without
seeing it. The `planned_shots` key was replaced by `shots`, matching the
committed chapters in part 06.

## App defects found

1. **Min Contig is silently ignored for SPAdes.** Confirmed against source
   rather than by a run. `AssemblyOptionCatalog.swift:128` maps Minimum Contig
   Length to SPAdes with the summary string "Lungfish post-filter", which is
   what makes the sheet render the stepper, but
   `ManagedAssemblyPipeline.buildSpadesCommand` never reads the value and
   `AssemblyOutputNormalizer` computes its statistics from the unfiltered
   `contigs.fasta`. The control appears editable and does nothing. Already
   known to the reality map and to `parameters.yaml`. Documented in the
   chapter as a limitation with the advice to leave it at 0.

2. **MEGAHIT's Threads slider is overridden without telling the user.** On
   Apple Silicon `AssemblyRunRequest.swift:99-104` lowers the requested thread
   count to 2 regardless of what the slider says, and the sheet gives no
   indication. This is a deliberate workaround for a MEGAHIT 1.2.9 arm64
   crash rather than a bug, but the silence is a UI gap. Documented in the
   Threads setting.

3. **The locked Run Mode caption carries a semicolon.** Minor, and only a
   problem for the manual rather than for users. The app string is
   "Combining multiple bundles into one assembly run is not yet supported;
   each bundle assembles separately." The chapter paraphrases it rather than
   quoting it, because the prose rules forbid semicolons.

## Not verified

- **Nothing in the chapter was seen on screen.** Every GUI claim comes from
  the Swift source and from the reality map, not from a running window. The
  four shot markers are placed for the Screenshot Scout, and the captions
  describe what the source says those surfaces draw. In particular the summary
  strip's exact rendering of "16697 total bp" versus a thousands-separated
  form was not observed. `AssemblySummaryStrip.swift:324` interpolates the raw
  Int, so the chapter quotes it unseparated, but a capture should confirm.
- **The `.lungfishref` bundle inside a run folder was not produced.** The CLI
  `assemble` path writes the managed run directory and its `contigs.fasta`.
  The bundle is built by `AssemblyBundleBuilder` on the app path. The chapter
  says the bundle lives inside the run folder on the strength of
  `AssemblyBundleBuilder.swift:89-101` and `AnalysesFolder.swift:121-122`
  rather than a run.
- **The Readiness panel's exact wording while checking** was paraphrased
  rather than quoted, because the string at
  `AssemblyWizardSheet.swift:673-674` reads "Managed tool status: checking
  Genome Assembly pack." and quoting it inside a sentence would have put a
  colon there. The two validation strings that are quoted end in periods and
  were safe to quote verbatim.
- **The Careful mode and Skip error correction toggles were not exercised.**
  Their flags are read from `AssemblyWizardSheet.swift:915-921`, not from a
  run.
- **No comparison of the assembled contigs against `NC_012920.1`** beyond
  length and GC. The chapter claims the three assemblers "agreed about its
  content" on the evidence of length and GC agreement, which is weaker than an
  alignment would be. An alignment check would strengthen the What good looks
  like section if a later pass wants it.
