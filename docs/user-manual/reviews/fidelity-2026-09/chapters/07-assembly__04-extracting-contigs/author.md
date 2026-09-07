# Author record: 07-assembly/04-extracting-contigs

Chapter rewritten in place for Preview 2026.9.13. Roster row 49.
Registry id `assemble.extract-contigs`. Fixture `human-mito`.

## Fixture choice

The chapter's worked figures come from the MEGAHIT assembly of the HG002
mitochondrial reads, not from the SPAdes one, and this was a deliberate
change from the drift report's assumption. The SPAdes run on those reads
produces exactly one contig, which leaves a chapter about *selecting*
contigs with nothing to select. MEGAHIT on the same reads produces three,
one near-complete mitochondrial genome plus two short fragments, so the
selection step is real and the Share of Assembly column has something to
say. Both runs were copied from the chapter 02 author's scratchpad at
`scratchpad/assembly-spades/` into `scratchpad/assembly-extract/`.

## Commands run

Scratchpad:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-extract/`

A project was made by hand as `HG002-mito.lungfish/` with the MEGAHIT run
copied to `Analyses/megahit-20260907-050500/`. There is no
`lungfish-cli project new`, and none is needed, because `--project-root`
only has to name a directory and `ReferenceSequenceFolder.ensureFolder`
creates `Reference Sequences/` itself. All eight runs used
`.build/debug/lungfish-cli`.

| # | Command | Exit | Result |
|---|---|---|---|
| 1 | `extract contigs --assembly Analyses/megahit-... --contig k141_1` | 0 | FASTA on stdout, header `>k141_1 flag=3 multi=256.0000 len=16711` |
| 2 | same plus `--bundle --project-root HG002-mito.lungfish` | 0 | `megahit-20260907-050500-subset.lungfishref` |
| 3 | run 2 repeated verbatim | 0 | `megahit-20260907-050500-subset_2.lungfishref`, display name `megahit-20260907-050500-subset 2` |
| 4 | run 2 plus `--contig k141_2 --bundle-name HG002-mito-selected` | 0 | `HG002-mito-selected.lungfishref`, two sequences, 17,073 bp |
| 5 | `--contig k141_0 --contig k141_2 --output two-short.fa --line-width 80` | 0 | plain FASTA, 80 bases per line |
| 6 | `--contig k141_0 --output j.fa --format json` | 0 | accepted |
| 7 | `--contig-file names.txt --output from-file.fa` | 0 | 2 records |
| 8 | `--contigs .../final.contigs.fa --contig k141_1 --bundle --bundle-name k141_1` | 0 | `k141_1.lungfishref`, `Assembler` recorded as `Unknown` |

Run 8 is the important one, because it is the route the **Create Bundle**
button takes internally. See the defect below.

## Figures taken from those runs

Every number in the chapter comes from a run above or from a file read
afterwards. None is carried over from the old chapter, whose SARS-CoV-2
figures were illustrative rather than measured.

| Figure | Value | Where it came from |
|---|---|---|
| Contig count | 3 | `assembly-result.json` `contigCount` |
| Long contig length | 16,711 | `final.contigs.fa.fai` and the manifest |
| Fragment lengths | 362 and 332 | same |
| Total assembly | 17,405 bp | `totalLengthBP` |
| Shares | 96.01%, 2.08%, 1.91% | computed from those lengths |
| Long contig GC | 44.3% | recomputed from `genome/sequence.fa`, agrees with the manifest's `GC Content` |
| Two-contig bundle | 17,073 bp | run 4's manifest `total_length` |
| Assembler string | `MEGAHIT 1.2.9` | run 2's manifest metadata |
| Reference mtDNA length | 16,569 (`NC_012920.1`) | existing glossary entry, not a run |
| stderr line | `✓ Created bundle megahit-20260907-050500-subset.lungfishref` | run 2 |
| Counter form | `-subset 2` display, `_2` on disk | run 3 |

The bundle's `genome/sequence.fa` was confirmed as `ASCII text` by `file`,
which is the direct evidence for the drift report's changed claim 3 that the
derived FASTA is not bgzip-compressed.

## Source files consulted

- `Sources/LungfishCLI/Commands/ExtractContigsCommand.swift` (flags 22-47,
  `validate()` 53-72, `run()` 75-122, `buildBundle` 300-340 including
  `compressFASTA: false` at 335, `resolvedBundleName` 342-351,
  `makeUniqueBundleName` 353-364, `bundleURL` space-to-underscore at 366-371)
- `Sources/LungfishApp/Services/FASTASelectionReferenceBundleCLI.swift`
  (the whole file, which is where the `--contigs` defect lives)
- `Sources/LungfishApp/Views/Viewer/ViewerViewController.swift`
  (`createReferenceBundle` 2361-2398, `createReferenceBundleDirectlyFromDurableFASTA`
  2400-2452, operation title and details 2413-2415, completion 2432-2436,
  failure alert 2438-2450)
- `Sources/LungfishApp/Views/Viewer/ViewerViewController+Assembly.swift`
  (`onCreateBundleRequested` 116-117)
- `Sources/LungfishAssemblyUI/AssemblyActionBar.swift` (four buttons 10-13,
  `setSelectionCount` 60-69 including the BLAST Contig singular retitle and
  both info-label strings)
- `Sources/LungfishAssemblyUI/AssemblyResultViewController.swift`
  (`defaultSuggestedName` 312-319, context menu wiring 295-309)
- `Sources/LungfishAssemblyUI/AssemblyContigTableView.swift` (the six columns,
  18-46)
- `Sources/LungfishAssemblyUI/AssemblyLayoutPreference.swift` (three layouts)
- `FASTASequenceActionMenuBuilder.swift` (`buildItems` 71-127, the 50-sequence
  BLAST cap and its tooltip at 83-90, the MAFFT two-selection rule at 113-118)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/extract.txt`
- `docs/user-manual/parameters.yaml` (`assemble.extract-contigs`)
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/07-assembly.md` (273-364)
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md` (2494-2560)
- `CONSISTENCY.md`, `ARCHITECTURE.md`
- Style references: `06-classification/02-running-kraken2.md`,
  `03-running-esviritu.md`; sibling author record for chapter 02

## Drift coverage

All 7 false claims and all 8 changed claims are applied. Every Missing row
has a home.

| Missing row | Where it landed |
|---|---|
| Contig-table context menu, seven items | Procedure, paragraph after step 5 |
| BLAST capped at 50 with a tooltip | Same paragraph |
| MAFFT needs two contigs | Same paragraph |
| Export FASTA save panel pre-fills `.fa` | Not included, see Not verified |
| Copy FASTA goes through the same `extract contigs` call | On the command line, last paragraph, generalised to the whole Create Bundle route |
| Derived bundle metadata block | Reading the results, third paragraph |
| "Could not resolve the enclosing Lungfish project root" | Reading the results, last paragraph |
| "Reference Bundle Creation Failed" alert | Same paragraph |
| Three assembly panel layouts | Not included, see Not verified |

## Settings

Ten Settings paragraphs, matching the registry exactly. Two are window
settings (Contig selection, Bundle name) and eight are the `cli_only` flags
(`--assembly`, `--contigs`, `--contig-file`, `--output`, `--bundle`,
`--project-root`, `--line-width`, `--format`). Each states what it does, its
default, its allowed values, when to change it, and closes on its flag. The
two window settings close with their flags rather than with "no command-line
flag", because both do reach the command line.

## Screenshots

Three shots, `shots` and body markers agreeing one to one. The two planned
shots were kept and recaptioned, and one was added.

- `create-bundle-action-bar` recaptioned to the human-mito MEGAHIT run with a
  single contig selected, so the caption can name the **BLAST Contig**
  singular retitle that the drift report asked to be surfaced. The old
  caption said three contigs, which would have shown the plural form.
- `contig-context-menu` is new, covering the highest-value Missing row.
- `derived-bundle-in-sidebar` recaptioned off `-subset`, which is the CLI
  default only, onto the contig's own name, which is what the button
  produces and what the chapter's procedure does.

## Glossary

One term added, `Derived bundle` `{#derived-bundle}`, inserted after "Depth"
in section D to match the file's existing ordering. Every other term the
chapter links was already present. `fai` already covered the FASTA index, so
no new entry was needed for it.

One slug correction. The chapter first linked `#variant`, which does not
exist. The glossary has `variant-caller`, `variant-track`, and
`variant-only-bundle` but no bare `variant`. The sentence was rewritten to
link `variant-caller` with an inline gloss, and `glossary_refs` follows.

## App defects found

1. **Create Bundle loses the assembler in the derived bundle's provenance.**
   This is new, found by running the app's own route rather than by reading
   it. `FASTASelectionReferenceBundleCLI.arguments` builds
   `extract contigs --contigs <fasta> ... --bundle`, sourcing from the FASTA
   rather than from the run folder. `ExtractContigsCommand` can only read
   `assembly-result.json` when it is given `--assembly`, so on the `--contigs`
   path `source.result` is nil and `assemblerDisplayName` falls through to
   the literal string `Unknown`. Run 8 above reproduces it. A bundle made
   with the button records `Assembler = Unknown` and
   `Source Assembly = final.contigs`, where the same selection made with
   `--assembly` records `MEGAHIT 1.2.9` and the run folder's name. The button
   has the run folder in hand, so this looks fixable by preferring
   `--assembly` when the source is a managed assembly. Documented in the
   chapter's command-line section rather than hidden, since it changes what a
   reader finds in their own bundle metadata.

2. **The drift report's claim 14 verdict is half right and should be
   corrected in a later pass.** It says the in-app button "is routed to the
   viewer, not to the CLI helper" and that the claim it shells out to
   `extract contigs` "is not accurate for the in-app path". The first half is
   right, the second is not. `createReferenceBundle` prefers
   `createReferenceBundleDirectlyFromDurableFASTA` whenever the selection
   comes from one durable FASTA, which is the normal assembly case, and that
   method does run `lungfish-cli extract contigs --bundle` through
   `LungfishCLIRunner`. It is a real OperationCenter operation *and* a CLI
   call. The chapter states the operation behaviour, which is what the reader
   sees, and does not repeat either version of the routing claim.

3. **Bundle name collision is not visible in the window.** The CLI appends a
   counter silently, which is right, but the display name gains a space
   (`-subset 2`) while the folder gains an underscore (`_2`). Not a fault,
   but a reader comparing the sidebar to Finder will see two different
   strings, so the chapter says both.

## Not verified

- **Nothing was seen on screen.** Every window claim comes from the Swift
  source, from `parameters.yaml`, and from the reality map. The three shot
  markers are placed for the Screenshot Scout and their captions describe
  what the source says those surfaces draw. In particular the exact rendering
  of the Share of Assembly column, whether it prints `96.01` or `96.0`, was
  not observed. The chapter quotes `96.01%`, computed from the lengths, and a
  capture should confirm the app's own rounding.
- **The `Create Bundle` button itself was never clicked.** Its behaviour is
  established from `AssemblyActionBar`, `ViewerViewController`, and the
  equivalent CLI runs. Defect 1 is inferred from reading
  `FASTASelectionReferenceBundleCLI` and then reproducing its exact argument
  vector on the command line, which is strong evidence but is not the button.
- **The Export FASTA save panel's pre-filled `.fa` name** was left out. It is
  an Export behaviour rather than an extraction behaviour, chapter 02 already
  covers the action bar, and including it would have pushed the procedure's
  follow-up paragraph past a comfortable length. It remains uncovered by
  either chapter.
- **The three assembly panel layouts** were left out for the same reason.
  Chapter 02's author placed them in that chapter's Reading the results
  section, so they are covered in the part, just not here.
- **The `.lungfishref` bundle inside an assembly run folder was not produced,**
  because the CLI `assemble` path does not build one. The chapter says so
  plainly in the command-line section rather than implying the headless
  reader has one, and every headless instruction works from the run folder.
- **`--format json` and `--format tsv` output shapes were not inspected.**
  Run 6 confirms `--format json` is accepted and exits 0, but the run wrote a
  bundle-free FASTA and the summary text was not captured, so the chapter
  describes the flag's purpose without quoting its output.
- **The failure messages are quoted from source, not reproduced.** Neither
  "Could not resolve the enclosing Lungfish project root" nor the
  "Reference Bundle Creation Failed" alert was triggered.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/07-assembly/04-extracting-contigs.md
```

Final result, exit 0:
`docs/user-manual/chapters/07-assembly/04-extracting-contigs.md: no issues found`

Two warnings were fixed on the way. A declared shot
(`derived-bundle-in-sidebar`) with no body marker, fixed by placing the
marker at the top of Reading the results where the drift report wanted it,
and the overused word "navigate", replaced with "move along it by
coordinate".

`GLOSSARY.md` reports 388 warnings when linted as a chapter, 307 of them the
`See also:` colon that 302 of its entries carry. The new entry follows that
house pattern, so it adds one warning of the same shared kind and no new kind.
