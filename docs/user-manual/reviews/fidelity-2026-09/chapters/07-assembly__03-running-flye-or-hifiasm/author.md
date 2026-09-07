# Author record: 07-assembly/03-running-flye-or-hifiasm

Author pass by the bioinformatics-educator on 2026-09-07, against the
2026.9.13 Preview build's source tree in the campaign worktree.

Roster row 48. Title "Running Flye or hifiasm". Registry ids
`assemble.flye` and `assemble.hifiasm`. Fixture hg002-long-reads.

Both assemblers ran for real on the fixture. Every figure in the chapter
comes from one of the four runs recorded below or from a file read
directly out of a run folder.

## Section order chosen

Full procedure-chapter shape, the ARCHITECTURE / STYLE template in its
given order, following the committed model chapter
`06-classification/02-running-kraken2.md`:

1. What it is
2. Why you would do this
3. Before you start
4. Procedure (three numbered subsections)
5. Settings
6. Reading the results
7. What good looks like
8. On the command line
9. Next

No template section was dropped. The previous version's "What you will
learn", "Worked example", and "Interpretation" headings are gone, since
none of the three is in the template. Their content is redistributed.
The learning-objectives list became the last paragraph of "What it is",
the worked example became the Procedure's own real runs plus the
figures in "Reading the results", and the interpretation material split
between "Reading the results" and "What good looks like".

## Commands run

All commands run from the campaign worktree root
(`/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign`),
with output under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-long/`.
Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

The fixture's two read files were copied into the scratchpad first and
their md5 checked against the committed originals. Both matched
(`751d2bb30e1040b787d95a9ac588da9d` for the ONT file), so every run
below is against byte-identical copies of the committed fixture.

### 0. Plugin pack

No install was needed. `~/.lungfish/conda/envs/` already held both
`flye` and `hifiasm` environments, so the Genome Assembly pack was
present before this pass began and `lungfish-cli conda install --pack
assembly` was never run. The chapter therefore states the pack
requirement from `PluginPack.swift` and the tool lock rather than from
an install this pass performed. `lungfish-cli conda install --help` was
read to confirm the `--pack` form the chapter would have used.

### 1. Flye on the ONT reads (first run)

```
lungfish-cli assemble --assembler flye --read-type ont-reads \
  --output <scratch>/flye --project-name HG002-chrM-flye \
  <scratch>/HG002.chrM.ont.fastq.gz
```

**Exit 0, outcome `completed`.** Read back from
`<scratch>/flye/assembly-result.json`:

| Field | Value |
|---|---|
| tool | flye |
| assemblerVersion | 2.9.6 |
| outcome | completed |
| contigCount | 1 |
| totalLengthBP | 32652 |
| largestContigBP | 32652 |
| n50 | 32652 |
| n90 | 32652 |
| l50 | 1 |
| gcFraction | 0.43005022663236553 (43.0%) |
| wallTimeSeconds | 36.992290019989014 |

Resolved command line, from the same JSON:
`flye --nano-hq <input> --out-dir <scratch>/flye --threads 14`.

`<scratch>/flye/assembly_info.txt`:
`contig_1  32652  126  Y  N  4  *  1`, so Flye marked the contig
circular with multiplicity 4. Contig header `>contig_1`.

This length is roughly twice the 16,569 bp reference and does **not**
match the fixture README's recorded 16,359 bp for the same command.
That mismatch is the finding recorded as defect 1 below and prompted
run 3.

### 2. hifiasm on the HiFi reads

```
lungfish-cli assemble --assembler hifiasm --read-type pacbio-hifi \
  --output <scratch>/hifiasm --project-name HG002-chrM-hifiasm \
  <scratch>/HG002.chrM.hifi.fastq.gz
```

**Exit 0, outcome `completed`.** Read back from
`<scratch>/hifiasm/assembly-result.json`:

| Field | Value |
|---|---|
| tool | hifiasm |
| assemblerVersion | 0.25.0 |
| outcome | completed |
| contigCount | 1 |
| totalLengthBP | 33140 |
| largestContigBP | 33140 |
| n50 | 33140 |
| l50 | 1 |
| gcFraction | 0.4440856970428485 (44.4%) |
| wallTimeSeconds | 5.856860995292664 |

Resolved command line:
`hifiasm -o <scratch>/hifiasm/HG002-chrM-hifiasm -t 14 <input>`. Note
the absence of `--ont`, correct for a HiFi read type, and the `-o`
prefix built from the Project Name.

Contig header `>ptg000001c`. The primary GFA's single `S` line reads
`S ptg000001c 33140`, confirming the FASTA is a faithful conversion of
the primary contig graph.

**Figures quoted in the chapter:** 1 contig, 33,140 bp, N50 33,140, L50
1, 44.4% GC, 5.9 seconds, the `33140 / 16569 = 2.0002` ratio, and the
file names in the run folder.

This reproduces the fixture README's recorded hifiasm result exactly
(1 contig, 33,140 bp, 44.4% GC), and the committed
`expected/hifiasm/contigs.fasta` measures 33,140 bases with the same
`>ptg000001c` header.

### 3. Flye on the ONT reads (second run, determinism check)

Identical command to run 1, only the output directory and project name
changed (`<scratch>/flye2`, `HG002-chrM-flye2`).

**Exit 0, outcome `completed`.**

| Field | Value |
|---|---|
| totalLengthBP | 16359 |
| largestContigBP | 16359 |
| n50 | 16359 |
| l50 | 1 |
| gcFraction | 0.4390855186747356 (43.9%) |
| wallTimeSeconds | 35.24902594089508 |

`assembly_info.txt`: `contig_1  16359  256  Y  N  3  *  1`.

So the same binary, on the same bytes, with the same flags, returned
16,359 bp on one run and 32,652 bp on another. Both were marked
circular. This settles the mismatch in run 1 as nondeterminism rather
than a stale fixture. It is the chapter's Flye caution and defect 1
below.

**Figures quoted in the chapter:** the 16,359 bp result and everything
derived from it (43.9% GC, N50 16,359, L50 1, 35.2 seconds, the 210 bp
and 1.3% shortfall against 16,569 bp, the `circ. Y` marking), plus the
32,652 bp / 43.0% / multiplicity-4 figures from run 1 as the
counter-example.

### 4. Files inspected inside the run folders

`ls` of `<scratch>/flye2` gave `00-assembly`, `10-consensus`,
`20-repeat`, `30-contigger`, `40-polishing`, `assembly-result.json`,
`assembly.fasta`, `assembly.fasta.fai`, `assembly.log`,
`assembly_graph.gfa`, `assembly_graph.gv`, `assembly_info.txt`,
`flye.log`, `params.json`.

`ls` of `<scratch>/hifiasm` gave the primary, hap1, hap2, p_utg and
r_utg GFAs with their `.lowQ.bed` and `.noseq.gfa` siblings, the three
`.bin` files, `assembly-result.json`, `assembly.log`, `contigs.fasta`,
and `contigs.fasta.fai`. The chapter's claim that hifiasm's alternate
haplotype graphs stay on disk unlisted is from this listing plus
`AssemblyOutputNormalizer.swift:44-52`.

`assembly.log` line counts: 64 for Flye, 1,675 for hifiasm. The Flye
log's `Assembly statistics` block was read directly and matches the
JSON figures.

### 5. Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/07-assembly/03-running-flye-or-hifiasm.md
```

Run four times. First (pre-rewrite baseline) 21 warnings, all prose
mechanics in the old text (bare "Lungfish", in-sentence colons,
semicolons). Second (post-rewrite) 1 warning, an 8-item list in the
Flye procedure against the 5-item cap. Third, after splitting that
list, 1 warning, a third list in the Procedure H2 against the 2-list
cap. Fourth, after folding the split-off steps back into prose, exit 0:

```
docs/user-manual/chapters/07-assembly/03-running-flye-or-hifiasm.md: no issues found
```

A fifth confirming run after the two late link fixes also printed the
same line.

## Source files consulted

Assembly model and pipeline:

- `Sources/LungfishWorkflow/Assembly/AssemblyCompatibility.swift:14-23`
  (Flye offered for `ontReads` only, hifiasm for both `ontReads` and
  `pacBioHiFi`, so a HiFi bundle offers hifiasm alone) and `:9-11` (the
  hybrid blocking message)
- `Sources/LungfishWorkflow/Assembly/AssemblyReadType.swift:14-21` (the
  three display names, verbatim: "Illumina short reads", "ONT reads",
  "PacBio HiFi/CCS")
- `Sources/LungfishWorkflow/Assembly/ManagedAssemblyPipeline.swift:280-298`
  (`buildFlyeCommand`, the single-input guard, `--<profile>` from
  `selectedProfileID ?? "nano-hq"`, `--out-dir`, `--threads`, then
  `extraArguments`), `:300-325` (`buildHifiasmCommand`, the single-input
  guard, the `-o <outputDirectory>/<projectName>` prefix, `-t`, the
  `--ont` insert for ONT read type), and `:400-414`
  (`appendHifiasmProfileArguments`, which adds `--n-hap 1`, `-l0`, and
  `-f0` for `haploid-viral` only when the user did not supply them)
- `Sources/LungfishWorkflow/Assembly/AssemblyOutputNormalizer.swift:39-53`
  (Flye's `assembly.fasta` plus `assembly_graph.gfa`; hifiasm's
  `<projectName>.bp.p_ctg.gfa` converted to `contigs.fasta` via
  `GFASegmentFASTAWriter` when no FASTA exists) and `:56-70` (the
  `completedWithNoContigs` outcome)
- `Sources/LungfishWorkflow/Assembly/AssemblyOptionCatalog.swift:110-131`
  (Memory Limit maps only to spades/megahit/skesa, and Minimum Contig
  Length only to spades/megahit/skesa, which is why both controls are
  hidden for the two long-read tools) and `:245-304` (the four Flye and
  four hifiasm advanced descriptions, quoted by title in the chapter)
- `Sources/LungfishWorkflow/Conda/PluginPack.swift:669-676` (the
  `assembly` pack, display name "Genome Assembly", its five packages)
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
  lines 45-46 (`flye=2.9.6`, `hifiasm=0.25.0`)

Wizard:

- `Sources/LungfishApp/Views/Assembly/AssemblyWizardSheet.swift:58-59`
  (`advancedDisclosureTitle = "Curated extra arguments"`,
  `extraArgumentsFieldTitle = "Extra arguments"`), `:261-270` (the
  multi-file rejection, whose message interpolates the read type's
  display name), `:463` (the Run button), `:474-490` (the Inputs
  section's Dataset, Read Layout, and Detected rows), `:494-524` (the
  segmented Assembler picker over the Read Type row and its "Locked from
  FASTQ header detection." note), `:524-540` (the Profile picker and its
  detail line), `:543-549` (the Threads slider), `:324` (the threads
  default, `min(availableCores, 8)`), `:582-620` (the Advanced Settings
  disclosure, the two per-tool toggles, the read-only catalog
  descriptions, the Extra arguments field), `:624-641` (Project Name and
  Output Folder), `:645-695` (the Readiness panel), `:885-902` (the
  profile lists for Flye and hifiasm, verbatim titles), `:906-932`
  (`curatedAdvancedArguments`, mapping Metagenome mode to `--meta` and
  Primary contigs only to `--primary`), `:936-950` (`defaultProfileID`,
  `nano-hq` for Flye and `diploid` for hifiasm)

Viewport:

- `Sources/LungfishAssemblyUI/AssemblySummaryStrip.swift:321-341`
  (Assembler, Read Type, Contigs, Total bp, N50, L50, Longest, Global
  GC, then Version and Wall Time when present)
- `Sources/LungfishAssemblyUI/AssemblyContigTableView.swift:19-47` (the
  six columns: `#`, Contig, Length (bp), GC %, Share of Assembly (%),
  Sequence Preview, and no coverage column)

Storage:

- `Sources/LungfishIO/Bundles/AnalysesFolder.swift:118-140` (the
  `Analyses/{tool}-{yyyy-MM-dd'T'HH-mm-ss}/` shape, the `-batch-`
  variant, and the `-2`, `-3` collision suffixes)

Campaign docs and references:

- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/07-assembly.md`
  (the recurring findings and this chapter's claims table at lines
  217-272)
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md` lines 2442-2520
  (this chapter's section) and 3774 (the roster row)
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/reviews/fidelity-2026-09/chapters/07-assembly__01-when-to-assemble/author.md`
  (the sibling chapter's settled folder story and picker behaviour)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/assemble.txt`
- `docs/user-manual/ARCHITECTURE.md` (editorial rules, the 07 TOC entry)
- `docs/user-manual/STYLE.md` (the chapter template and the Settings
  three-sentence shape)
- `docs/user-manual/parameters.yaml` lines 5120-5300 (both registry
  entries)
- `docs/user-manual/chapters/06-classification/02-running-kraken2.md`
  and `03-running-esviritu.md` (style references)
- `docs/user-manual/fixtures/hg002-long-reads/README.md`,
  `regenerate.sh`, and both `expected/` FASTAs
- `docs/user-manual/GLOSSARY.md`
- `docs/user-manual/build/scripts/lint/rules/settings-coverage.js` and
  `frontmatter.js` (to confirm the label-matching and shot-pairing rules
  before writing)

## DRIFT rows applied

The one false claim and all nine changed claims are applied.

| Row | Where it landed |
|---|---|
| 1 (false, entry_points) | Front matter now lists `Tools > Assembly > Flye...`, `Tools > Assembly > Hifiasm...`, and the CLI |
| 3 (changed, output folder) | "What it is", fourth paragraph, which also says outright that there is no `Assemblies` folder |
| 5 (changed, hifiasm output style) | "Reading the results", the paragraph on what hifiasm keeps but does not show |
| 7 (changed, PacBio CLR) | The **Read Type** Settings entry, which says CLR has no read class of its own and so resolves to no single class, unlocking the picker |
| 8 (changed, Flye step 2) | Procedure step 2 and step 3, with the sheet opening on Flye and the Detected row named |
| 10 (changed, Metagenome mode) | The **Metagenome mode** Settings entry, which places it inside the Curated extra arguments disclosure |
| 15 (changed, Primary contigs only) | The **Primary contigs only** Settings entry, including that the viewport lists primary contigs either way |
| 17 (changed, Haploid/Viral) | The **Profile** Settings entry, which names `--n-hap 1`, `-l0`, and `-f0` and says what they do |
| 20 (changed, Operations Panel) | Procedure step 1's closing paragraph, which says the panel streams Flye's own output and names `assembly.log` |
| 21 (changed, bundle folder) | Procedure step 3, with the real timestamped folder names |

The old chapter's comparison table is gone entirely rather than
corrected. Its rows mixed app behaviour with unenforced domain guidance
(the "Memory footprint" and "Runtime on a SARS-CoV-2 amplicon run" rows
had no source at all), and editorial rule 3's tool-comparison
requirement is satisfied for this part by chapter 01, which carries the
five-assembler table. The two facts worth keeping from it, the read-type
gating and hifiasm's ONT acceptance, are now prose in "What it is" and
in the Assembler and Read Type Settings entries.

The old chapter's SARS-CoV-2 worked example is also gone. It was
explicitly hypothetical and quoted unverifiable numbers ("about
29.8 kb"). It is replaced by the two real human runs, which the
campaign's human-and-macaque preference also asks for.

## Missing rows covered

All nine Missing rows are in the chapter.

| Missing row | Where it landed |
|---|---|
| Both tools take exactly one input, multi-file refused with a per-tool message | "On the command line", third paragraph, with both messages quoted verbatim and the concatenation workaround |
| Memory Limit hidden for both | Settings lead paragraph, and the `--memory-gb` sentence in the cli-only paragraph |
| Min Contig hidden for both | same two places |
| Haploid/Viral silently adds `--n-hap 1`, `-l0`, `-f0` | the **Profile** Settings entry |
| Hifiasm's GFA converted to `contigs.fasta` | Procedure step 2's closing paragraph, and again in "Reading the results" |
| Flye keeps `assembly_graph.gfa` | "Reading the results", final paragraph |
| Hifiasm's output prefix comes from Project Name | the **Project Name** Settings entry |
| Pinned versions 2.9.6 and 0.25.0 | "Before you start", final sentence of the pack paragraph |
| Four Flye and four hifiasm read-only advanced descriptions | Settings, the paragraph before the `assembly-sheet-curated-arguments` shot, naming all eight by title |

## Settings coverage

Eight Settings paragraphs cover all sixteen registry settings (seven for
each tool, of which six labels are shared).

Shared, documented once each, with a sentence naming which assembler
differs where they differ: **Assembler.**, **Read Type.**, **Profile.**,
**Threads.**, **Extra arguments.**, **Project Name.**

Tool-specific: **Metagenome mode.** (Flye) and **Primary contigs
only.** (hifiasm), each of which says which assembler shows it.

The **Profile** entry is the one shared label whose meaning genuinely
differs between the tools, so that paragraph carries both tools' full
option lists and both defaults rather than picking one.

Every entry closes with either the flag or the fixed sentence. The two
toggles have `cli_flag: null` in the registry, so each closes by saying
it has no command-line flag of its own and naming the `--extra-args`
form instead, which is what the registry's own `notes` field
prescribes. The five `cli_only` flags of each tool are identical between
the two entries and are documented once, in the paragraph closing the
Settings section, since the CONSISTENCY sheet allows a group to state a
shared property once rather than per item.

Lint's `settings-coverage` rule passes, which confirms every label in
both registry entries is matched verbatim by a paragraph beginning
`**Label.**` with the period inside the bold. Neither of these two
operations has a label carrying a trailing colon, so the
`**Label:.**` form was not needed in this chapter.

## Defects found

1. **Flye 2.9.6 is nondeterministic on this fixture, and the fixture's
   own recorded result is one of two outcomes.** Runs 1 and 3 above used
   the identical command on byte-identical input and returned 32,652 bp
   and 16,359 bp respectively, both from a single contig both marked
   circular. The doubled result carried multiplicity 4 and the unit
   result multiplicity 3, so Flye's repeat resolution reached a
   different conclusion about the same graph on the two runs. Nothing in
   LGE passes a seed to Flye, and Flye's command line as recorded in
   `assembly-result.json` is identical in both runs but for the output
   directory. Two consequences. First, the fixture README's Flye figures
   (1 contig, 16,359 bp) are not reproducible on demand, so
   `regenerate.sh` will sometimes produce a `expected/flye/assembly.fasta`
   twice the committed length, and any test comparing against it will
   flake. Second, the chapter cannot promise the reader a specific
   length, which is why it documents both outcomes and teaches the
   size check instead. This is a fixture and testing problem more than
   an app problem, but somebody should decide whether the fixture pins
   a seed, records a tolerance, or drops the length assertion.

2. **The doubled-circle outcome is invisible in the viewport.** Both the
   16,359 bp and the 32,652 bp Flye results, and hifiasm's 33,140 bp
   result, look identical in every field the summary strip reports. One
   contig, N50 equal to the length, L50 1, plausible GC. Flye records
   the circularity and the multiplicity in `assembly_info.txt` and
   hifiasm encodes the `c` suffix in its `ptg000001c` contig name, and
   neither reaches the viewport. A reader who does not already know the
   expected genome size has nothing on screen to warn them. Surfacing
   Flye's `circ.` and `mult.` columns, or hifiasm's circular-contig
   suffix, in the contig table would catch this class of error where the
   reader is looking. Recorded as a suggestion rather than a bug, since
   nothing is wrong with what the viewport does show.

3. **`--memory-gb` and `--min-contig-length` are silently ignored for
   both tools** rather than rejected. The registry documents this
   honestly and the chapter repeats it, but a CLI user who passes
   `--memory-gb 8` to a Flye run gets no warning that the flag did
   nothing. Not verified by running it, since the registry and
   `AssemblyOptionCatalog.swift:110-131` agree and the chapter makes no
   claim beyond theirs.

4. **The MEGAHIT arm64 abort** recorded as defect 1 in the chapter 01
   author record is inherited, not re-tested here. This chapter documents
   neither MEGAHIT nor any short-read assembler, so it says nothing about
   it. Noted only so the two records agree.

## Fixture handling

The chapter refers to the fixture as "the HG002 long reads", the
CONSISTENCY sheet's fixed name. No license text is inlined. The fixture
has complete metadata, a citation block, a fetch script and a regenerate
script.

Facts taken from the fixture README: the two source read sets and their
GIAB provenance, the reference `NC_012920.1` at 16,569 bp, the 950 ONT
reads and 363 HiFi reads, the roughly 300-fold downsampled coverage, and
the HG002 / NA24385 Ashkenazim-son identity. The read counts and
coverage figures come from the README's Downsampling table, which
records `seqkit stats -a` output.

The chapter uses human data throughout, satisfying the campaign's human
and macaque preference. The previous version used a hypothetical
SARS-CoV-2 ONT amplicon dataset that the manual does not ship.

The Download ZIP sentence is included verbatim, since hg002-long-reads
is a folder fixture rather than a single file.

## What could not be verified

1. **No GUI run was made.** Every number in the chapter comes from
   `lungfish-cli` or from a file in a run folder. The menu path, the
   submenu, the Inputs section's three rows, the Assembler picker's
   narrowing, the locked Read Type label and its exact note text, the
   Profile picker, the Curated extra arguments disclosure and its
   read-only descriptions, the Readiness panel, the summary strip, the
   contig table, and the sidebar's Reassemble item are all read from
   source rather than seen on screen. The four declared shots are the
   check on this.

2. **The `Analyses/flye-<timestamp>/` and `Analyses/hifiasm-<timestamp>/`
   folders were never observed.** The shape is traced through
   `AnalysesFolder.swift:118-140` and matches the CONSISTENCY ruling and
   the sibling chapter's own trace, but every run this pass made used
   `--output` and so wrote a flat directory. The two example folder names
   in Procedure step 3 are constructed from the documented format string
   and the real timestamps of this pass's runs, not copied off a GUI run.

3. **The multi-file rejection messages were not triggered.** Both are
   quoted verbatim, but they are assembled from
   `AssemblyWizardSheet.swift:261-270`, which interpolates
   `effectiveReadType.displayName` into a fixed string, together with the
   display names at `AssemblyReadType.swift:16-21`. The interpolation is
   simple enough to be safe, but neither message was seen rendered.

4. **The Haploid/Viral profile was not run.** Both real hifiasm figures
   come from the Diploid default. What that profile adds is read from
   `ManagedAssemblyPipeline.swift:400-414` and stated as behaviour, and
   the chapter quotes no numbers for it. The same is true of Flye's Nano
   Raw and Nano Corrected profiles, and of both Advanced Settings
   toggles.

5. **Why Flye's result varies was not diagnosed.** The chapter states
   the observation and offers the circular-graph explanation as the
   likely reason, hedged accordingly. Whether it is thread scheduling,
   a hash seed, or something in the repeat resolver was not investigated,
   and it would take more Flye runs and probably a single-threaded
   comparison to say.

6. **Both results were checked against the expected genome size, not
   against the reference sequence.** Neither assembly was aligned back
   to `NC_012920.1.fasta`, so the chapter says the contigs reconstruct
   the genome on length and circularity evidence rather than on sequence
   identity. The fixture README makes the same limitation explicit and
   assigns that comparison to the alignment chapters.

7. **Runtimes are from this machine only.** 35.2 seconds for Flye and
   5.9 seconds for hifiasm on 14 threads, on Apple silicon. The chapter
   attributes them to "a recent Apple silicon laptop" and to the
   reference run rather than promising them.

## Glossary

Three entries added, alphabetically, in the existing one-sentence-plus-
"See also:" shape:

- **GFA (Graphical Fragment Assembly)** (section G, before GFF)
- **Nanopore sequencing** (section N, between N50 and Negative control)
- **Unitig** (section U, after Unclassified reads)

All three are listed in `glossary_refs`, together with the nineteen
existing terms the chapter deep-links. All twenty-two anchors were
verified to resolve against `GLOSSARY.md` by exact-match count, and
every one of the twenty-two is linked at least once in the body.

`GLOSSARY.md` was modified concurrently by another author during this
pass. One of the three edits reported the file as changed on disk since
last read. The edit applied cleanly and the U-section insertion point
was re-located before the final edit, so no other author's entry was
disturbed.

## Front matter

- `title` changed from "Running Flye or Hifiasm" to "Running Flye or
  hifiasm", matching the roster row and the tool's own lowercase name.
- `parameters_refs` added as `[assemble.flye, assemble.hifiasm]`, which
  the previous version lacked entirely.
- `entry_points` replaced per DRIFT row 1.
- `task` rewritten to name reading the results, which the chapter now
  does at length.
- `estimated_reading_min` raised from 10 to 24, matching the growth from
  roughly 1,900 to roughly 4,200 words and the model chapter's 30 for a
  longer one.
- `fixtures_refs` set to `[hg002-long-reads]`, previously empty.
- `glossary_refs` set to twenty-two terms, previously empty.
- `brand_reviewed: false` and `lead_approved: false` left as required.
- `features_refs` and `illustrations` left empty.

Shots changed from three planned to four declared, all four needing
capture:

- `assembly-sheet-flye` (replaces `assembly-wizard-flye`, recaptioned
  per the reality map to say the input was selected before the sheet
  opened and that the picker shows only the ONT-compatible tools)
- `assembly-sheet-hifiasm` (replaces `assembly-wizard-hifiasm`,
  recaptioned to say the picker shows Hifiasm alone, since the reality
  map warns a reader will otherwise think it is broken)
- `assembly-sheet-curated-arguments` (new, for the disclosure whose
  contents three DRIFT rows depend on)
- `flye-contig-table` (replaces `flye-single-contig-result`, reshot as
  the viewport rather than the sidebar, which is the reality map's
  second option and the one the surrounding prose describes)

The `planned_shots` key and the `<!-- planned: -->` marker form are both
gone, replaced by real `shots` entries and `<!-- SHOT: -->` markers,
which is what the lint's frontmatter rule pairs.
