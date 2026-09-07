# Author report: 03-reads/06-subsetting-and-extraction

Author: bioinformatics-educator. Date: 2026-09-07. Target build: Preview
2026.9.13 (`.build/debug/lungfish-cli --version` reports `2026.9.13`).

Registry ids covered: `fastq.subsample-by-proportion`,
`fastq.subsample-by-count`, `fastq.extract-reads-by-id`,
`fastq.extract-reads-by-motif`, `fastq.select-reads-by-sequence`.

Lint result: `no issues found` (strict mode).

## Runs made

Every number and every behavioural claim in the chapter comes from a run
below. All runs used copies of the HG002 chromosome 20 fixture R1 file
(45,574 reads) under the session scratchpad at
`.../scratchpad/fastq-subset/`. Nothing was written to `~/Desktop/lge-docs`
or into the repository.

The R1 read count was independently confirmed at 45,574, matching the
fixture README's "45,574 read pairs".

### Subsampling

| Command | Reads out |
|---|---|
| `fastq subsample --proportion 0.1` | 4,473 (9.81 percent) |
| `fastq subsample --count 10000` | 10,000 (exact) |

Determinism: both commands were run twice and the read-identifier sets
compared with `comm`. Both returned byte-identical draws (4,473 shared of
4,473; count run identical). The CLI is therefore reproducible across runs
even though no seed is exposed.

Composition check used in "What good looks like": the parent is 76.7
percent `@D00360` and 23.3 percent `@HISEQ1` reads, and the 0.1 subsample
came back 76.5 percent and 23.5 percent (3,422 and 1,051 of 4,473).

### Extract Reads by ID (`fastq search-text`)

| Query | Flags | Reads out |
|---|---|---|
| `HISEQ1` | none | 0 |
| `HISEQ1` | `--regex` | 10,622 |
| `HISEQ1` | `--regex --field description` | 10,622 |
| `HISEQ1:93:H2YHMBCXX:1:1101:1457:14988` | none | 1 |

The 10,622 figure was independently confirmed with `grep -c HISEQ1` on the
extracted header list. The zero-result run is the headline finding for this
operation: a plain query is an exact whole-identifier match, not a
substring match, because `seqkit grep -p` without `-r` anchors to the full
ID. The chapter states this explicitly and tells the reader to turn the
regex box on for prefixes.

The fixture's reads come from five sequencing runs on two instruments
(`@HISEQ1:93:H2YHMBCXX` 10,622; `@D00360:94:H2YT5BCXX` 9,998;
`@D00360:97:H2YVMBCXX` 9,680; `@D00360:96:H2YLYBCXX` 8,049;
`@D00360:95:H2YWMBCXX` 7,225). This is what makes the operation
demonstrable on this fixture at all, and it is a fact about the fixture the
README does not record.

The description-field run returns the same count because these headers
carry no description. The chapter says so rather than presenting the two
fields as meaningfully different here.

### Extract Reads by Motif (`fastq search-motif`)

| Pattern | Flags | Reads out |
|---|---|---|
| `GCCTCCCAAAGTGCTGGGATTACAGG` | none | 521 |
| `GCCTCCCAAAGTGCTGGGATTACAG[GA]` | `--regex` | 565 |

The motif is the Alu right-arm 3' end, chosen because it is a real human
repeat present in the fixture rather than an invented string. Its flanking
context in the reads (`...GTGATCC...` before, `C[AG]TGAGCCAC` after) is the
canonical Alu signature.

The 521 figure decomposes as 260 reads carrying the motif as written plus
261 carrying its reverse complement, confirmed by two independent greps
summing exactly to 521. This corrects a claim carried by both the old
chapter and the registry `notes` for this operation (see Defects below).

### Select Reads by Sequence (`fastq sequence-filter`)

Sequence used throughout: the Illumina TruSeq adapter
`AGATCGGAAGAGCACACGTC`.

| Settings | Reads out |
|---|---|
| `--search-end right --min-overlap 16 --error-rate 0.15 --keep-matched` | 218 |
| same, without `--keep-matched` | 45,356 |
| same, plus `--search-rc` | 218 |
| CLI defaults (overlap 8, error 0.1, both ends), `--keep-matched` | 45,574 |
| `--search-end right --min-overlap 12 --error-rate 0.15 --keep-matched` | 12,058 |
| `--search-end right --min-overlap 8 --error-rate 0.15 --keep-matched` | 40,507 |
| `--search-end right --min-overlap 20 --error-rate 0.1 --keep-matched` | 179 |

The 218 and 45,356 runs sum to exactly 45,574, a clean partition of the
input, and the chapter uses that as a reader-facing check.

The overlap ladder (40,507 at 8, 12,058 at 12, 218 at 16) is the evidence
behind the Min Overlap paragraph. At the CLI's own default of 8 every read
in the file matches, which is the strongest available argument for why the
dialog raised its default to 16, and it is far more persuasive than
restating the two numbers.

### `extract reads --by-id`

Twenty read identifiers taken from the fixture itself. Single `--source`
returned 20 reads. Two `--source` files returned 20 reads each as
`_R1`/`_R2`. Output is gzip-compressed regardless of the extension given to
`--output`, which the chapter notes.

## What was removed from the old chapter, and why

**The menu path.** Every mention of
`Tools > FASTQ/FASTA Operations > Search & Subsetting...` and of "pick one
from the list inside the dialog" is gone. The five operations are five
separate items under `Tools > Search & Subsetting`, per CONSISTENCY and
`ToolsMenuModel.swift:68`. This was DRIFT false rows 1 and 4.

**`Imports/` as the output location.** Replaced with
`Analyses/<tool>-<timestamp>/` per CONSISTENCY, confirmed against
`FASTQOperationDialogState.swift:1607-1613`, where `defaultOutputDirectory`
returns `<project>/Analyses`. This was DRIFT changed row 7.

**Three wrong Select Reads by Sequence defaults.** The old chapter gave Min
Overlap 8, Error Rate 0.1, and both toggles off. The dialog's real defaults
are 16, 0.15, `Keep Matched Reads` on, `Search Reverse Complement` off
(`FASTQOperationDialogState.swift:268-272`). The 8 and 0.1 figures are the
CLI defaults, and the chapter now names both surfaces separately rather
than conflating them. This was DRIFT false rows 11, 25, and 28 and changed
row 12.

**"For paired data both mates of a matched read are kept" under Extract
Reads by ID.** Removed from that row as DRIFT false row 9 directs, because
the GUI request carries no pairing parameter and `search-text` exposes no
such flag. Pair keeping is instead documented where it belongs, in its own
subsection under Procedure for the GUI derivative pipeline and under the
`extract reads` heading for that command's flags.

**"No mismatch budget and no strand option" for Extract Reads by Motif.**
The no-mismatch half is true and kept. The strand half was wrong and is
replaced by a statement that both strands are searched, with the 260/261
decomposition as evidence.

**The three invented worked examples.** The old chapter's SampleA/SampleB
normalization example, its `SRR36291587` test-slice example, and its ARTIC
v3 primer example all used numbers and samples that do not exist in any
fixture, and the last two used viral data against the campaign's
human-first rule. All three are replaced by the fixture's own measured
results, which now carry the same teaching points inside the Settings and
Reading the results sections.

**"Do not record a seed in your methods."** Softened and corrected. The
claim that there is no seed control is true of both surfaces, but the old
chapter's advice ignored that the CLI is in fact deterministic. The chapter
now distinguishes the two surfaces and keeps the archive-the-bundle advice
for the window.

**The `## Interpretation` and `## What you will learn` headings.** Replaced
by the template's `## Reading the results`, `## What good looks like`, and
`## On the command line`.

## DRIFT unverifiable rows, settled

**Row 20, the virtual-bundle sidebar badge and the Inspector read count.**
Not settled, and therefore not asserted. I could not locate the badge or
the Inspector field in the source, and I did not run the GUI. The chapter
drops the badge claim entirely. It keeps the weaker and independently
supported statements that the bundle holds a `preview.fastq` rather than
the full file, and that the viewport read count is the real count rather
than the preview's, the latter following from the manifest carrying the
subset read-ID payload. If the Screenshot Scout can see a badge when
capturing `subsample-by-count-pane`, this is worth revisiting.

**Row 29, "paired-end is supported, and pairs stay paired".** Settled as
TRUE for the window, and the chapter now explains the mechanism rather than
asserting the outcome. `FASTQDerivativeService+Transformations.swift:183-190`
routes interleaved input for both search operations through
`runPairedAwareSearch`, which
(`FASTQDerivativeService+SubsetHelpers.swift:45-93`) searches, collects the
matched base IDs, deduplicates them, and re-extracts both mates from the
source. The two subsample operations take a parallel path, using
`reformat.sh` with `interleaved=t` and, for count, halving the target to a
pair count (`:33-47` and `:74-88`). Since CONSISTENCY records that a
paired import is stored interleaved, this covers every paired bundle. The
CLI subcommands have no equivalent logic, and the chapter does not claim
they do.

**Changed row 18, the multi-source `--keep-read-pairs` default.** Not
settled by experiment, and restated rather than asserted, as the DRIFT row
permits. My two-source test could not discriminate the flags, because the
20 identifiers I supplied are shared by both mates, so `--no-keep-read-pairs`
returned the same 20/20 output as the default. The chapter therefore says
what each flag does without claiming which is the default.

## Shot markers

Three markers, all with frontmatter entries.

`search-subsetting-menu` is new. It shows the `Tools > Search & Subsetting`
submenu itself. The chapter's single largest correction is that these are
five menu items rather than one dialog with a list, and a picture of the
submenu is the cheapest guard against that error returning.

`select-reads-by-sequence-pane` is new and is the shot DRIFT asked for. It
captures the pane at its real defaults (Min Overlap 16, Error Rate 0.15,
Keep Matched Reads on), which is where the old chapter was wrong three
times over.

`subsample-by-count-pane` is new. It sits beside the numbered procedure and
also shows the Output Strategy picker, which the old chapter never
mentioned and which DRIFT listed as missing.

The old chapter had `shots: []` and no markers in the body, so nothing was
reused and nothing was dropped.

## Glossary additions

Seven terms, all in the existing entry shape and alphabetised, all listed
in `glossary_refs`.

`alu-element`, `materialization`, `read-identifier`, `regular-expression`,
`sequence-motif`, `subsampling`, `virtual-bundle`.

`cutadapt`, `bbduk`, `seqkit`, `adapter`, `reverse-complement`,
`interleaved-fastq`, `paired-end`, `bundle`, `provenance`, `sidebar`,
`inspector`, and `fastq` already existed and are referenced rather than
redefined.

## Possible app defects found

**1. `fastq sequence-filter` crashes with a raw Java stack trace on a legal
combination of its own options.** This is the significant one.

`FastqSequenceFilterSubcommand.swift` computes bbduk's edit distance as
`edist = max(1, round(errorRate * minOverlap))`. bbduk asserts that edit
distance must be between 0 and 2. Any combination whose product exceeds 2.5
therefore fails. Reproduced with:

```
lungfish-cli fastq sequence-filter <input> --sequence AGATCGGAAGAGCACACGTC \
  --search-end right --min-overlap 20 --error-rate 0.15 --keep-matched -o out.fastq
```

which exits non-zero with:

```
Exception in thread "main" java.lang.AssertionError: edit distance must be between 0 and 2; default is 0.
```

`--min-overlap 18 --error-rate 0.15` fails the same way. `--min-overlap 20
--error-rate 0.1` (edist 2) succeeds.

Three things make this worth fixing. The failure surfaces as an unhandled
Java assertion and a stack trace rather than a validation message. The
combination is not exotic, since the window's own default error rate of
0.15 fails for any overlap of 18 or more. And the two surfaces disagree,
because the window runs cutadapt, which has no such cap, so a reader who
reproduces a successful window run on the command line at the same settings
gets a crash. A range check at parse time naming both options would be the
minimal fix.

The chapter documents the constraint and tells the reader to keep the
product at or below 2 or to use the window, which is the best a manual can
do while the behaviour stands.

**2. The registry note for `fastq.extract-reads-by-motif` is wrong.** It
reads "The motif is matched on the read as stored, so the reverse
complement is not searched unless you write it into the pattern." Both
surfaces pass `seqkit grep --by-seq` (CLI `FastqSearchMotifSubcommand.swift`,
GUI `buildMotifSearchArgs`), and seqkit searches both strands by default,
which the 260 forward plus 261 reverse-complement equals 521 measurement
confirms. This is the Code Cartographer's file, so I have not edited it.
The same wrong belief sat in the old chapter's "No mismatch budget and no
strand option" line, which suggests the note and the chapter share an
ancestor.

**3. `extract reads --output` does not honour the extension it is given.**
Passing `--output picked.fastq` writes `picked.fastq.gz`. The summary block
does print the real filename, so this is a minor surprise rather than data
loss, but a caller scripting around the requested path will not find the
file. The chapter warns the reader.

**4. Chapter frontmatter `tools:` was understated.** The old chapter listed
`[seqkit, bbduk]`. The five operations actually reach four tools, and which
one runs depends on the surface. seqkit backs both search operations and
the CLI subsample. `reformat.sh` backs the GUI subsample on interleaved
input. cutadapt backs the GUI Select Reads by Sequence. bbduk backs the CLI
`sequence-filter`. The frontmatter now lists all four. This is a
documentation fix rather than an app defect, but the GUI-versus-CLI tool
split under one operation name is the kind of thing worth a second opinion
from the Cartographer.
