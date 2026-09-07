# Author report, 04-alignments/02-reading-an-alignment

Chapter 23 of the campaign roster. Registry ids `bam.read-display` and
`bam.extract-reads-in-region`. Fixture `hg002-chr20`.

Rewritten in place on 2026-09-07 against Preview 2026.9.13 sources, the
`cli-help` tree, and live measurements of the fixture's expected mapping BAM.

## Runs and measurements

Everything numeric in the chapter came from one of the runs below. Copies of
the fixture files were made under the session scratchpad at
`.../scratchpad/alignment-reading/`. Nothing was written into the fixture
folder or into `~/Desktop/lge-docs`.

Inputs copied: `expected/mapping/HG002.sorted.bam` and its `.bai`, plus
`GRCh38.chr20.10.0-10.5Mb.fasta` and its `.fai`.

`samtools` came from the app's managed environment at
`~/.lungfish/conda/envs/samtools/bin/samtools` (version 1.24, the same binary
the mapping run's `@PG` header records). `bcftools` came from
`~/.lungfish/conda/envs/bcftools/bin/bcftools`.

| Measurement | Command | Result | Where it appears in the chapter |
|---|---|---|---|
| Record counts | `samtools flagstat` | 91,203 total, 91,148 primary, 55 supplementary, 90,990 mapped, 90,935 primary mapped, 213 singletons | Include supplementary alignments setting, Inspector summary paragraph |
| Depth and breadth | `samtools coverage` | mean depth 44.7234x, coverage breadth 99.9938% of 500,001 bp | Coverage curve section, Inspector summary |
| Depth distribution | `samtools depth -a` then an awk pass | mean 44.72, max 79 at position 13,097, 505 positions below 10x, 31 positions at zero | Coverage curve section, What good looks like checks 1 and 2, the `max: 79x` label example |
| Pileup at the worked position | `samtools mpileup -f <ref> -r chr20_10.0-10.5Mb:2078-2078` | 51 reads, all carrying A against reference G, 24 forward and 27 reverse | Pileup section, What good looks like check 3 |
| Reads over the worked window | `samtools view -c ... chr20_10.0-10.5Mb:2000-2200` | 105 records over 201 bp | Used only to confirm the window is ordinary. Not quoted. |
| Soft-clip rate | `samtools view -F 0x904` then a CIGAR grep for `S` | 6,308 of 90,935 primary mapped reads, about 7 percent | Show soft-clipped sequence setting, What good looks like check 4 |
| MAPQ distribution | field 5 of the same primary records | 87,755 at MAPQ 60, 165 below MAPQ 30 | Minimum alignment confidence setting |
| CLI region extraction | `lungfish-cli extract reads --by-region --bam HG002.sorted.bam --region chr20_10.0-10.5Mb --output ...` | `Extracted 91148 reads from BAM` | On the command line section |
| CLI extraction with coordinates | same, with `--region chr20_10.0-10.5Mb:2000-2200` and `--region chr20_10.0-10.5Mb:1-1000` | failed both times with `No BAM reference names matched the requested regions` | The limitation note in On the command line. See the defect section below. |

The pileup at position 2,078 independently reproduces the counts the fixture
README already records for that position from both callers (`DP4=0,0,24,27`
for bcftools, `AD 0,51`), which is a useful cross-check that the copies used
here are the same BAM the README describes.

Position 2,078 was chosen because it is a homozygous SNV in the GIAB
benchmark VCF (`G` to `A`, genotype `1/1`), so the difference is established
independently of these reads. It is also the position both callers'
representative rows in the fixture README already use, so the manual now
tells one continuous story about that column across chapters.

## What was removed from the old chapter, and why

The old chapter carried 13 false claims and 6 changed ones. The whole body
was replaced rather than patched, because the section order did not match the
campaign template and the false claims were load-bearing rather than
incidental.

Removed outright:

- **The entire "Colour channels beyond strand" section** (four bullets plus a
  closing paragraph, old claims 35 through 39). `ReadColorMode` exists in
  `AlignedRead.swift` and `ReadTrackRenderer.color(for:colorMode:)` handles
  several of its cases, but nothing in the app ever passes a value, and the
  only colouring control in the Inspector is the strand toggle. This was
  unshipped code described as shipped UI. It is replaced by the three controls
  that do exist, the "Color reads by strand" toggle and the two colour wells.
- **"the Inspector reports per-strand depth as plain numbers"** (old claim 4).
  Neither the alignment summary nor the flagstat list carries a per-strand
  depth row. The accessibility point it was supporting is now made through
  the two colour wells instead, which are the real non-default escape hatch.
- **"the viewport draws a representative sample of about 2,500 reads"** and
  the 10,000-read contig threshold (old claims 28 and 29). No such numbers
  exist. Replaced with the real 50,000-read display budget, the deterministic
  even sample, the banner text, and the **Load all** ceiling of 2,000,000.
- **"Copy Read Sequence (FASTQ)", "Copy Read Sequence (FASTA)", and "Copy
  Read Name"** (old claim 27). The read context menu builds exactly two items.
  Replaced with their real titles.
- **"The alignment viewport has no typed-coordinate prompt"** (old claim 16).
  `Sequence > Go to Location...` (Cmd-L) exists, and so does
  `Sequence > Go to Gene...` (Cmd-Option-G).
- **"File > Open"** (old claim 7). There is no such item. The BAM, CRAM, and
  SAM entry point is **File > Import Center...** (Cmd-Shift-I), which the
  Inspector's own empty state names.
- **The `Nx` coverage label in the top-left corner** (old claim 13). The label
  reads `max: Nx` and sits at the right-hand edge, and at the packed tier it
  also carries the mean.
- **"the status bar reports the loaded read count"** (old claim 15). The
  status bar reports position, selection, and scale. The read count lives in
  the sampling banner.
- **The flat list of seven Analysis buttons** (old claims 31 and 32). All
  seven titles are real, but no view shows them together. Recast as the
  six-tab map the section actually is.
- **"the dialog opens with this BAM already set as input"** (old claim 34).
  The picker defaults to the first eligible track in the bundle, not
  necessarily the selected one, so the chapter now says to check it.
- **The SARS-CoV-2 SRR36291587 worked example and position 21618.** The
  campaign fixture for this chapter is `hg002-chr20`, and the campaign rule
  puts human examples first. Every worked number is now human.
- **"a CRAM file ... including `.gz`" on `lungfish import bam`** (old claim
  11). No evidence for `.gz` acceptance on that command, so the claim is gone
  and the `import bam` paragraph is folded into Before you start.
- **The "What you will learn" and "Importing an existing alignment" sections
  and the "Interpretation" heading.** None is in the campaign template. Their
  surviving content moved into Before you start and Reading the results.

## Missing features now covered

Fifteen of the seventeen features the drift report listed as missing are now
in the chapter. The coverage scale picker, all three Read Inclusion toggles,
the viewer minimum-MAPQ slider, the Visible Alignment picker, Show reads,
Limit visible rows, Use compact row height, the two soft-clip and indel
toggles, and both colour wells are documented as Settings paragraphs. The
Selected Read panel with its base qualities and insertion list, the
`Extract Reads in Selected Region...` menu item, `Show Alignment File in
Finder`, the Escape-cancels-a-load behaviour with its loading badge, the
zoom-threshold message, the three rendering tiers, `Zoom Reset (10kb)`, the
managed-samtools dependency, the collapsed provenance rows with **Show
command**, and the empty-SEQ skip are all in the body prose.

Two are deliberately left out. The consensus track and its five settings
belong to `bam.extract-consensus`, which is chapter 30's registry entry, and
documenting them here would duplicate that chapter's Settings section. The
read-group visibility panel appears only when an alignment carries more than
one read group, which the fixture does not, so there is nothing measurable to
say about it here.

## How each DRIFT unverifiable row was settled

The chapter's Part A verdict line reads 2 unverifiable. Both are rows 30 and
33 of the ground-truth map.

**Row 30, "positions with fewer than about ten reads are not reliable for
variant calling."** Settled by keeping it and grounding it. It is a domain
heuristic rather than an app claim, and the consistency sheet already fixes
the manual's phrasing for it ("A region under 10 is too thin to call a
variant with confidence"), which chapter 22 also uses. The chapter now states
the reasoning behind the number in the same sentence, that below about ten
reads a single sequencing error can outvote the truth in the column, and
frames the consequence as the caller being unable to be confident either way
rather than as the caller being wrong. It is attached to a measured figure,
505 positions below 10x out of 500,001, so the reader can see how much of
this particular alignment the heuristic touches.

**Row 33, "Call Variants runs a variant caller, iVar by default for amplicon
SARS-CoV-2 data, bcftools for general short-read data."** Settled by deletion.
The map says the default-caller selection lives in
`BAMVariantCallingDialogState.swift` and belongs to the 05-variants map, so
asserting it here would be this chapter guessing at another chapter's ground
truth. The Analysis tab map now names **Call Variants...** as the Variant
Calling tab's button and says nothing about which caller it defaults to. The
reader is pointed at the variant-calling chapter for that.

## Shot markers

Five markers, each with a caption in the frontmatter. Three carry forward
from the old planned shots and two are new.

| id | Status | Note for the Screenshot Scout |
|---|---|---|
| `bam-viewport-overview` | Kept, caption rewritten | Frame wide enough to include the `max: Nx` label at the right-hand edge of the coverage strip, since the old caption implied a top-left label. |
| `view-settings-alignment-tab` | New | The Alignment tab of View Settings. Needed because seven Settings paragraphs now describe controls that had no shot at all. |
| `view-settings-reads-tab` | New | The Reads tab of View Settings, covering the remaining nine paragraphs. |
| `pileup-zoom` | Kept, caption rewritten to name position 2,078 | Capture with "Show matching bases as dots" at its default so the dot-and-letter rendering is what the reader sees. |
| `extract-reads-region-menu` | New | The context menu over a selection, showing `Extract Reads in Selected Region...`. |

The old `alignment-inspector` planned shot is dropped rather than split. The
drift report asked for it to become two shots, one of the alignment summary
with Flag Stats expanded and one of the Analysis tab grid. Chapter 22 already
carries `alignment-inspector-stats` for the first of those and reads all five
summary numbers and the flagstat table in full, so this chapter cites that
chapter instead of duplicating the surface. The Analysis tab grid is described
in prose as a six-tab map, which is what the reader needs in order to find a
button, and did not warrant a fifth screenshot in a chapter that already has
five.

## Glossary additions

One term added, in the existing entry shape, alphabetised between "Alignment
column" and "Allele".

- **Alignment track**{#alignment-track}, the named BAM attached to a reference
  bundle and drawn as its own read stack and coverage curve.

Two candidates were considered and rejected. "Allele fraction" was going to be
added until a check found the existing **Allele frequency** entry, which
defines the same quantity, so the chapter uses that term and links to it.
"Coverage histogram" was dropped because the existing **Coverage** and
**Depth** entries already carry the meaning and the chapter calls the surface
a coverage curve rather than a histogram, matching how the renderer draws it
(a stacked area chart, not bars).

Note for whoever reconciles the glossary. While this chapter was being
written, an `Alignment track` entry appeared in `GLOSSARY.md` from a
concurrent campaign session and was then removed again, leaving the file
without one. The entry above is the one currently in the file. The version
that briefly appeared claimed alignment track identifiers take the form `aln_`
followed by eight characters, which the ground-truth map for chapter 22 lists
as an unverifiable claim (row 46, settled only by reading
`BAMAdoptMappingSubcommand.swift`). The entry now in the file makes no claim
about the identifier's shape.

## App defect found

**`lungfish-cli extract reads --by-region` rejects every region that carries
coordinates.**

The `--region` flag is documented in `cli-help/extract.txt` as "Genomic region
to extract (repeatable, for --by-region)", and the overview says the strategy
"Extracts reads from a sorted, indexed BAM file for one or more genomic
regions". The registry entry `bam.extract-reads-in-region` maps the GUI's
selected region onto this flag. In practice only a bare reference sequence
name is accepted.

Reproduction, against a copy of the fixture's expected mapping BAM:

```
lungfish-cli extract reads --by-region --bam HG002.sorted.bam \
  --region chr20_10.0-10.5Mb:2000-2200 --output out.fastq
# Error: No BAM reference names matched the requested regions: chr20_10.0-10.5Mb:2000-2200

lungfish-cli extract reads --by-region --bam HG002.sorted.bam \
  --region chr20_10.0-10.5Mb --output out.fastq
# Extracted 91148 reads from BAM
```

Root cause, from `Sources/LungfishWorkflow/Extraction/BAMRegionMatcher.swift`.
`readBAMReferences` parses the bare `SN:` names out of the BAM's `@SQ` lines.
The three matching strategies then compare the whole region string against
those bare names. `tryExact` tests set membership, `tryPrefix` tests
`bamRef.hasPrefix(region)`, and `tryContains` tests `bamRef.contains(region)`.
A region of the form `name:start-end` is longer than the reference name it
starts with, so it fails all three, and the caller reports
`ExtractionError` with the "No BAM reference names matched" message
(`ExtractionConfig.swift:703`). The coordinate suffix is never stripped before
matching.

Two things make this worth reporting rather than shrugging at. The failure is
silent about its real cause, since the message says the reference name did not
match when the reference name did match and only the suffix did not. And the
fallback path in the same file returns every reference in the BAM when nothing
matches at all, so a slightly different input shape could extract a whole
genome where the user asked for a two-hundred-base window. Here the error
fires first, which is the safe outcome, but the fallback sits one branch away.

The chapter states the limitation plainly in the On the command line section
and points the reader at the GUI's **Extract Reads in Selected Region...** for
a coordinate range, since that path builds a `ResolvedAlignmentRegion` from
the selection rather than going through the string matcher.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/04-alignments/02-reading-an-alignment.md
```

Final result:

```
docs/user-manual/chapters/04-alignments/02-reading-an-alignment.md: no issues found
```

Two findings were fixed on the way there. A six-item Procedure list exceeded
the five-item cap, fixed by folding the go-to-a-position step and the zoom
step into one, which they always were in practice. And "stall" is on the
overused-word list, replaced with "freeze" in the Read display budget
paragraph.
