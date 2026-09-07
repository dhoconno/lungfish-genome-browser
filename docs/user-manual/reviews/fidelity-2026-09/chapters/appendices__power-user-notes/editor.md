# Editor record, appendices/power-user-notes.md

Edited 2026-09-07. Inputs: `author.md`, `fidelity.md` (75 claims, 4 false),
`readers.md` (136 merged rows, 53 Consensus), `CONSISTENCY.md`, and the
committed `cli-reference.md` opener sections.

## The four false claims

1. **GATK block was incomplete.** `GATKCommandBuilder.swift:384-395` always
   emits `--sample-ploidy`, `--max-alternate-alleles`, and
   `--pcr-indel-model` between `-O` and `--native-pair-hmm-threads`. All
   three are now in the bash block with the source defaults (2, 6,
   `CONSERVATIVE`, confirmed at `:53-57` and against `parameters.yaml`), and
   a following paragraph says what each one does and that all three are the
   tool's own defaults.
2. **`ops stats` exit status was inverted.** The old text said an
   unrecognised `--format` produces an error line and exit 0. Replaced with
   the reviewer's wording: an accepted-but-ignored `--format json` prints the
   text table and exits 0, while a value the parser does not recognise is
   refused with exit status 64, so a script must read the output rather than
   infer the format from the status.
3. **Flye was written `--flye --nano-hq`.** Corrected to `flye --nano-hq`,
   matching `ManagedAssemblyPipeline.swift:285` and `:292` and the chapter's
   own bash block. The sentence now names the command's opening directly and
   points at the block above it.
4. **The envelope block presented an abridgement as a full read.** The block
   now carries the three omitted top-level keys (`createdAt`, `output`,
   `runtime`), shows `options`, `parameters`, `outputs`, and `steps`
   populated rather than empty, and marks its cuts with three explicit
   elision entries. The lead-in labels it as abridged and names the four keys
   a reader actually needs.

## The two missing gate caveats

Both added to the consolidated caveat list rather than softening the
"every reproducibility defect" lead-in.

- The `04-alignments__04` gate finding, that the Inspector's duplicate
  marking registers nothing with OperationCenter and takes no lock, joins the
  **samtools** entry with the consequence "do not run it alongside anything
  else on that bundle".
- The `08-workflows__02` finding, that `provenance verify` exits 64 on an
  ordinary unsigned record, gets its own **Provenance** entry with the
  consequence that a nonzero status there means "not signed" rather than
  "not valid".

## Project manager rulings

**(a) Opening paragraph.** The chapter now opens, before any command, with
who the appendix is for, that most of it needs a terminal, a pointer to the
CLI Reference's "Before you type anything" and "Finding the program" sections
for getting a terminal and putting `lungfish-cli` on the machine, and a
second paragraph naming the two sections a window-only reader can act on
(the consolidated caveat list and the Operations panel section) and telling
them to skip the rest.

**(b) Caveat list moved up.** It is now the second H2, immediately after the
opening, since every cross-reference into this appendix lands there. Each of
the eleven entries gained a clause of consequence saying what to do or what
not to trust, rather than only a link. The old iVar entry, which packed two
defects and a link into one sentence, is split into four sentences.

**(c) Glossed at first use.** Flag, argument, and wrapper are glossed
together in the "What it is" section, where flag and argument first appear.
Absolute path is glossed in the same section, alongside a plain statement
that a bash block is a grey block of terminal text and that nothing on the
page has to be typed. `--extra-args` is now explained at its first
appearance under `ivar variants` as "the option that inserts your own words
into the command LGE builds", rather than on the last page.

**(d) Terminal-only capabilities named.** LoFreq indel calling says there is
no dialog control and is command-line only, with one complete example
invocation. The four `--ivar-*` tuning flags say none has a dialog control.
LoFreq `--extra-args` says there is no window route. "Summarising cost" says
no panel in the window shows those totals. "Pinning an environment" says the
section is command-line only. The `.dict` fix names
`gatk CreateSequenceDictionary` and says it has no window route.

**(e) FORMAT DP.** Added to the consolidated caveat list as a **Variant
filters** entry, glossed as the per-sample read depth, saying the clause
returns an empty table rather than an error and that this applies in the
Variants tab as much as from a script. The section-level mention now
cross-references the list.

**(f) Numbers given scale.** `-d 600000` is oriented against the 10,000 to
50,000 depth range amplicon panels reach, taken from the chapter's own
20,000-fold example rather than invented. `-Q 20` gains the generalisation
that 30 means one in a thousand. Kraken 2's `--confidence 0.0` and
`--minimum-hit-groups 2` are each stated to be the tool's own default, as
are the three GATK values and SKESA's `--min_count 2`. The 104 allele rows
figure now says explicitly that the point is the two counts agreeing rather
than the value. No threshold was invented anywhere.

**(g) Determinism claims unchanged in substance.** The genotyping pair is
still the manual's one recorded pair and is now labelled weak evidence. The
pivot timestamp, MEGAHIT, Flye, and hifiasm findings keep their evidenced
wording, with "occasionally" changed to "rarely" for Flye per the fidelity
note and the committed `07-assembly/03` chapter. Nothing new is called
deterministic. The section lead now says outright that nothing outside the
measured list is claimed.

**(h) Glossary.** Eight terms added to `GLOSSARY.md` in alphabetical order
using the existing entry shape: **Absolute path**, **Alternate read**,
**Argument**, **Dialog**, **HG002**, **Linkage**, **Mapping quality**,
**Wrapper**. Bundle, BED, GVCF, stderr, pid (as `process-id`), CI (as
`continuous-integration`), camelCase, JSON, Bracken, secondary alignment,
sliding-window trimming, REF/ALT, phase, symlink, smart-filter-token, and
shotgun already existed and are linked rather than duplicated. `glossary_refs`
was updated to the 54 anchors the body actually links, dropping five that
the rewrite no longer links (coverage, depth, flag, shell, subcommand) and
adding smart-filter-token.

**(i) Shape kept.** The 16 topic sections survive intact. The only structural
change is the caveat list moving up under ruling (b) and one new H3, "Two
dialog settings are ignored on some assemblers", under ruling from the
readers' most-repeated Assembly row.

## Reader rows

**All 53 Consensus rows applied.** Grouped by the chapter-wide fixes that
close many at once:

- *The opening paragraph and the moved caveat list* (rulings a and b) close
  the terminal-signposting row, the "which sections can I act on" row, the
  audience row, the caveat-list-signpost row, the bash-block row, the
  "Summarising cost is terminal-only" row, and the source-checkout skip row
  (the latter also gets its own explicit skip sentence).
- *The first-use gloss pass* (ruling c plus ruling h) closes the rows for
  argument list, flag, wrapper, absolute path, scratch folder, bundle, BED,
  `@SQ SN`, GVCF, stderr, pid, CI, camelCase, JSON, conda, environment,
  phase-aware, linkage, REF and ALT, alternate read, HG002, mapping quality,
  fold as a coverage unit, secondary alignment, Bracken, smart filter,
  FORMAT DP, bcftools, doubling, pivot workbook, `/private/tmp`, symlink,
  working directory, sliding window, root command and subcommand, exclusive
  advisory lock, and byte-identical.
- *The "say plainly what happens" pass* closes the rows on `caller-default`,
  exit status 0, the two sidecar filenames (now on separate lines with the
  zero-count reading stated), the `-t` override, "zero out", the four
  `--ivar-*` flags, `lungfish-internal`, the `--format` collision, the
  refusing command, MEGAHIT's contradiction, and the FATAL version string
  (reassurance moved before the error text).
- *The four new tables* close the exit-code row, the `--extra-args` versus
  `--extra-arg` row, the steps-array field row, and the Kraken 2 flag row.
- *Dropped jargon and metaphor* closes "pure function", "escape hatches",
  "sit near this problem", "resolved artifact inventory", "swallowed", "fast
  paths", "ambient Python", "drifted from the pinned set", "asymmetry", and
  "commit a run".
- *Individual Consensus rows* also fixed one at a time: the mapper count now
  reads four mappers plus BBMap shown as a fifth command; the codon band gets
  a biological sentence; the LoFreq error-model sentence is rewritten as two
  counts; Dindel is dropped by name; the minimap2 and BBMap wording now runs
  in one direction with the last-value-wins rule stated once; the eight-column
  kreport says who is affected and that the window reads it correctly; the
  `.dict` fix names its command; the JSON block gets a which-keys-matter
  lead-in; the older sidecar shape names `schemaVersion` as the discriminator;
  the assembly settings row gets its own H3; and the "three processes" wording
  becomes "three programs run one after another" so that "process" is reserved
  for the conda-lock sense.

**Other merged rows: 71 applied, 12 skipped.** Applied among them are the
three-names-for-one-setting mapping, the `-p` prefix note, the silent-failure
bold lead-in, the `-x` offset symptom, shotgun glossing, the read-technology
sentence before the assembler list, the two named GATK dialog entries, the
GVCF-before-`-ERC` ordering, the near-duplicate field pairs with which to
read, the `bioconda::` string labelled part by part, the `-c` example
explained, the window-only debugging order, the tilde and Reveal in Finder,
"fifty in total regardless of age", the positive rewrite of the absent-report
sentence, the xlsx-is-a-zip sentence, the two named MEGAHIT workarounds, the
"compare against the known genome length" advice, the required-versus-advisory
database clause, the split `bam adopt-mapping` sentence, the angle-bracket
note, what stops working without a sidecar, the OCI artifact list moved after
the unreachable statement, the twelve versions replaced by a pointer to Tool
Versions, the assembler-choice pointer, and the Medaka/Clair3 and
Nextflow/Snakemake introductions at the head of the caveat list.

Skipped, with reasons:

1. *Give MEGAHIT's observed failure rate.* CONSISTENCY.md fixes the wording
   as "fails most runs" for every chapter and the fidelity report confirms
   that precedence over the gate's "four runs in five". Naming a rate would
   break the fixed phrasing.
2. *Give the size of the LoFreq indel gap.* Not measured. The chapter says so
   rather than inventing a figure (ruling f).
3. *Give a typical amplicon depth as a single number.* Only a range is
   evidenced from the chapter's own example, so a range is what is given.
4. *Say whether `peakMemoryBytes` is ever written.* The author could not
   verify it, so the "treat a missing figure as normal" wording stands.
5. *Enumerate the `-x` preset per read type.* The author did not read that
   mapping end to end, so the chapter still states only the `sr` default and
   that the preset follows the declared read type.
6. *List the six LoFreq normalisation steps.* The chapter now points at the
   sidecar's own `steps` array instead, since the six are a run detail rather
   than a fixed list in source.
7. *Add a per-tool determinism table.* Dropped by the author for want of
   evidence and forbidden by ruling g.
8. *Move the Operations panel section much earlier.* The alternative offered
   in the same row, a signpost at the top, was taken instead, because ruling
   i keeps the appendix shape.
9. *Cut the camelCase aside or mark the paragraph for script writers.* The
   term is glossed instead, which the same row offered first and which suits
   an appendix whose readers are reading JSON.
10. *Use a shipped build in the envelope example.* The block is quoted from a
    real sidecar, so the `Lungfish dev (0)` value stays and the disagreement
    is explained instead, as the same row's first option allows.
11. *Gloss conda-lock.* The bare name is dropped rather than glossed, which
    the row offered as its first option.
12. *Restate the FORMAT DP caveat in window terms inside "Querying variants".*
    It is stated in window terms in the consolidated caveat list under ruling
    e, and the section cross-references it, so restating it twice more would
    duplicate.

## Brand and style

No em dashes. No semicolons in authored prose (the two in the file sit inside
verbatim quoted tool output, as the fidelity report already noted). No colon
inside a sentence. No word from `ai-tells-words.txt` and no banned sentence
shape. Sentences run to about 20 words. `brand_reviewed` and `lead_approved`
both remain `false`. `estimated_reading_min` raised from 24 to 30 for the
added glossing and the four new tables.

## Lint

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/power-user-notes.md: no issues found
```
