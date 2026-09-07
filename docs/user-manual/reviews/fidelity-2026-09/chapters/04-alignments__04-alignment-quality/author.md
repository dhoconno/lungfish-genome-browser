# Author report: 04-alignments/04-alignment-quality

Chapter 25 of the 2026-09 fidelity campaign. Registry ids `bam.mark-duplicates`
and `bam.filter`. Fixture `hg002-chr20`, its `expected/mapping` output.

Author: bioinformatics-educator. Date: 2026-09-07.

## Runs made

Every number in the chapter comes from one of the runs below. Scratch
directory
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/alignment-quality/`.
Nothing was written into the repository or into `~/Desktop/lge-docs`.

Inputs were copies of the fixture's uncommitted `expected/mapping/HG002.sorted.bam`
and `.bai`, plus the committed `GRCh38.chr20.10.0-10.5Mb.fasta`.

### 1. Baseline flagstat

`samtools flagstat` from the managed environment at
`~/.lungfish/conda/envs/samtools/bin/samtools`, on the unmodified fixture BAM.

| Category | Count |
|---|---|
| total | 91,203 |
| primary | 91,148 |
| secondary | 0 |
| supplementary | 55 |
| duplicates | 0 |
| mapped | 90,990 (99.77%) |
| primary mapped | 90,935 (99.77%) |
| properly paired | 90,414 (99.19%) |
| singletons | 213 (0.23%) |

These agree exactly with the numbers the committed chapter
`01-mapping-reads-to-a-reference.md` already publishes and with the fixture
README's internal-consistency section, so the two chapters now quote one set
of figures.

### 2. `lungfish-cli markdup`

```
lungfish-cli markdup HG002.sorted.bam
```

Output, quoted verbatim in the chapter:

```text
Processed 1 BAM file (0 already marked)
Total reads: 90990, duplicates: 1684
Elapsed: 2.1s
```

Flagstat after the run: total still 91,203, duplicates now 1,684, every other
row unchanged. This is the direct evidence for the corrected claim that
marking flags without deleting, so a depth figure over all reads does not
fall on marking.

1,684 out of 91,148 primary records is 1.85%, the duplicate rate the chapter
quotes.

A second `markdup` on the same file printed
`Processed 1 BAM file (1 already marked)` and `Elapsed: 0.1s`, confirming the
already-marked skip that `--force` overrides.

### 3. Mean depth, with and without duplicates

`samtools depth -a` over the 500,001-base slice. Note that `samtools depth`
excludes duplicate-flagged reads by default, so the two variants had to be
forced explicitly.

| Reads counted | Mean depth |
|---|---|
| all records (`-g 0x400`) | 44.72x |
| duplicates excluded (default, and `-G 0x400`) | 43.90x |

44.72 matches the fixture's own `mapping-result.json` figure of 44.7234 for
`meanDepth`, so the chapter's 44.7x Est. Coverage claim is anchored twice.

### 4. MAPQ distribution

`samtools view | awk` over the marked BAM.

| Bin | Records |
|---|---|
| MAPQ 60 (maximum) | 87,759 |
| MAPQ 48 | 1,773 |
| MAPQ >= 20 | 90,802 |
| MAPQ < 20 | 401 |

### 5. Scratch bundle and `bam filter`

Built a scratch bundle so `bam filter` had a bundle-owned track to work on,
since it refuses a loose BAM.

```
lungfish-cli bundle create --fasta GRCh38.chr20.10.0-10.5Mb.fasta \
  --name "HG002 chr20 slice" --output-dir .
lungfish-cli bam adopt-mapping --bundle HG002_chr20_slice.lungfishref \
  --mapping-result mapping --name "HG002 minimap2 (dup-marked)" \
  --track-id hg002-marked
lungfish-cli bam filter --bundle HG002_chr20_slice.lungfishref \
  --alignment-track hg002-marked \
  --output-track-name "HG002 filtered (MAPQ 20, primary, no duplicates)" \
  --output-track-id hg002-filtered \
  --mapped-only --primary-only --min-mapq 20 --exclude-marked-duplicates
```

Filtered-track flagstat: 89,107 total, 89,107 primary, 0 secondary, 0
supplementary, 0 duplicates, 89,107 mapped (100.00%), 88,666 properly paired
(99.51%), 196 singletons.

The 2,096 records the filter dropped account for themselves exactly.

| Reason dropped | Records |
|---|---|
| unmapped | 213 |
| supplementary | 55 |
| flagged duplicates | 1,684 |
| MAPQ < 20 among the rest | 144 |
| total | 2,096 |

Verified independently. `samtools view -c -F 0xC04` (drop unmapped,
duplicate, supplementary) gives 89,251, and 144 of those carry MAPQ < 20, so
89,251 - 144 = 89,107.

Filtered-track mean depth, measured the same way as above, is 43.83x.

Outputs landed at
`HG002_chr20_slice.lungfishref/alignments/filtered/hg002-filtered.{bam,bam.bai,stats.db}`,
which is where the chapter says they go.

### 6. `bundle deduplicate-alignments`

```
lungfish-cli bundle deduplicate-alignments HG002_chr20_slice.lungfishref
```

Output: `Deduplicated bundle: .../HG002_chr20_slice-deduplicated.lungfishref`
and `Processed tracks: 2`. The deduplicated copy of the marked track holds
89,519 records, which is 91,203 minus the 1,684 flagged, confirming that
`markdup -r` removes rather than marks on this path. The deduplicated copy of
the already-filtered track holds 89,097.

### A false lead worth recording

An early cross-check showed `samtools view -F 0x404 -q 20` giving 89,123
against LGE's 89,107, a 16-record gap that looked like a filter defect. It was
my mask, not the app. `0x404` excludes unmapped and duplicate but not
supplementary (`0x800`), and 16 supplementary records survived the other two
conditions. A read-name diff confirmed all 16 carry the supplementary bit and
that LGE dropped no record samtools kept for any other reason. `--primary-only`
is correct.

## What was removed from the old chapter, and why

**The `## What you will learn` section.** Not in the 2026-09 template. Its
content was folded into `## What it is` and `## Why you would do this`.

**Every mention of a "Mean coverage" field** (DRIFT false claims 4 and 25).
No such field exists. `ReadStyleSection.swift:1189-1192` renders
`statRow("Est. Coverage", ...)` and only when `chromosomeStats.count == 1`.
Replaced with Est. Coverage, plus the single-contig caveat the old chapter
never mentioned.

**"Read the Mapped reads and Properly paired counts"** (DRIFT changed 5). The
summary row is **Total Mapped**, and properly paired is not in the summary at
all. It lives in the collapsible Flag Statistics list. The chapter now names
all five summary figures and sends the reader to Flag Statistics for the
flagstat categories.

**"Note the Primary alignments count"** (DRIFT false 7). No such row. Replaced
with the `primary` row of Flag Statistics.

**"Re-read the Mean coverage field after marking; it falls by the duplicate
fraction"** (DRIFT false 25). Wrong twice over. The chapter now says the
opposite and proves it with the 91,203-before/91,203-after record count, then
gives the measured 44.72x/43.90x pair for what exclusion actually costs.

**"This is the last chapter in Alignments"** (DRIFT false 29). It is not.
`05-viral-recon-wizard.md` is. The Next section now points there and names it
as the last chapter, which reconciles with chapter 05's own DRIFT row 47.

**The whole `## Thresholds by workflow` table.** Six rows of coverage and
duplicate thresholds across viral amplicon, viral shotgun, bacterial isolate,
and metagenomic workflows, none of it an app claim and none of it sourced
(DRIFT unverifiable 28, which flags the table as explicitly framed "working
defaults, not regulatory minima"). It also violated the campaign's
human-examples rule by making viral amplicon the default worked case. Replaced
with a `## What good looks like` section whose every number is either measured
on the fixture or stated as a rule of thumb about a protocol.

**The "80-95% of reads as duplicates" figure for amplicon data** (DRIFT
unverifiable 27). A domain heuristic with no repository source. Softened to
"above about 80%" and framed as a statement about what amplicon design
guarantees rather than a measurement.

**The SRR36291587 worked example.** Its central claim, "mean coverage near
800x and >99% mapped", is DRIFT unverifiable 26, and it names a field that
does not exist. The whole example was replaced by HG002 numbers I measured,
which is the fixture the roster assigns this chapter and which is human data
as the campaign requires.

**"the Inspector's Analysis section" without a tab** (DRIFT changed 1, 10, 16,
21). All four buttons are now placed on their real tabs: Mark Duplicates in
Bundle Tracks and Create Filtered Alignment on Filtering, Create Deduplicated
Bundle on Export.

**"Drag horizontally across the genome"** (DRIFT changed 9). The whole
coverage-histogram scanning procedure was cut rather than corrected, because
chapter 02 already documents the coverage curve, the Coverage scale picker,
and the Read Inclusion toggles in its View Settings section, and duplicating
them here would have put the same controls in two chapters. This chapter now
points at depth and breadth as numbers and leaves the viewport controls to
chapter 02.

## How each DRIFT row was settled

### False (4)

Rows 4, 7, 25, 29 all corrected as described above, each against the source
line the reality map cites.

### Changed (9)

- **1, 10, 16, 21 (tab placement).** Confirmed in
  `ReadStyleSection.swift`. The `AnalysisWorkflowSubsection` enum at `:1030-1050`
  gives the six tab titles, `filteringSection` at `:2098` holds Mark Duplicates
  in Bundle Tracks (`:2124`) and Create Filtered Alignment (`:2264`), and
  `exportSection` at `:2600` holds Create Deduplicated Bundle (`:2612`).
- **5 (summary field names).** Confirmed at `ReadStyleSection.swift:1165-1192`
  and `:1101` for the `Flag Statistics` disclosure title. Note that the source
  and chapter 01 both say **Flag Statistics** while `parameters.yaml` notes and
  the DRIFT text say "Flag Stats". The chapter follows the source.
- **9 (panning).** Resolved by removing the section, per the reasoning above.
- **12 (markdup stage list).** Settled by reading
  `Sources/LungfishWorkflow/Alignment/AlignmentMarkdupPipeline.swift:274-390`,
  which the reality map had not read. The five stages are exactly
  `samtools sort -n`, `samtools fixmate -m`, `samtools sort`,
  `samtools markdup`, `samtools index`, in that order, and the old chapter's
  claim was right. Kept, now with a source behind it. `--sort-threads` reaches
  the two sort stages only, via the `threadArguments` variable at `:298`,
  which is why the chapter says "the two sorting stages".
- **19 (default deduplicated-bundle name).** Settled two ways. Source:
  `AlignmentDuplicateService.uniqueDeduplicatedBundleURL` at `:268-287` builds
  `<source stem>-deduplicated.lungfishref` in the source's parent directory
  and appends `-2` through `-999` if taken. Run: the fixture bundle produced
  `HG002_chr20_slice-deduplicated.lungfishref` beside the source. The chapter
  states the naming rule rather than softening it.
- **24 (mutual exclusivity).** Settled in source. `BAMCommand.swift:1095-1101`
  throws `ValidationError("--exclude-marked-duplicates and --remove-duplicates
  are mutually exclusive.")` and the matching one for `--exact-match` with
  `--min-percent-identity`. The chapter asserts the refusal, since the guards
  are real.

### Unverifiable (3)

- **26 (SRR36291587 mean coverage near 800x, >99% mapped).** Settled by
  discarding it. The chapter's assigned fixture is `hg002-chr20`, the field it
  named does not exist, and the campaign wants human examples. Replaced by the
  measured HG002 figures.
- **27 (80-95% amplicon duplicate rate).** Settled by softening to "above
  about 80%" and reframing it as a consequence of amplicon design rather than a
  measured rate. No source exists for a precise band.
- **28 (threshold table).** Settled by deleting the table. It was never an app
  claim, the manual cannot stand behind the numbers, and the campaign's
  reader-first rule is better served by the fixture-anchored `What good looks
  like` section that replaced it.

### Missing features now covered (13 of 13)

The GUI filter panel and every one of its controls (all 8 in Settings); the
panel's pointer to Bundle > Alignment Tracks and View > Alignment; the
bundle-level operation lock (Before you start); `--sort-threads` and its
default of 4; `bam markdup` as a second spelling lacking
`--deduplicated-bundle`; `bam filter --output-track-id`; `bam annotate` as the
table-shaped QC surface; the Flag Statistics list as the home of properly
paired, primary, supplementary and duplicate counts, with the orange QC-fail
note; the Read Groups list; the Per-Chromosome breakdown; and the
single-contig restriction on Est. Coverage.

Two of the thirteen were handled by deferral rather than by inclusion, and
this is deliberate. The **coverage scale picker** and the **Read Inclusion
toggles** are already documented in chapter 02's View Settings section, which
covers Coverage scale in full including the Log10 and Square root modes. This
chapter references the Read Inclusion duplicate toggle only where it matters
here, in explaining why the viewport depth appears to drop after a marking run
even though Est. Coverage does not.

## Shot markers

Four markers, four front-matter entries, in body order.

| id | Where | Caption |
|---|---|---|
| `inspector-alignment-stats` | Procedure, step 1 of Read the alignment statistics | The Inspector's alignment summary showing Total Mapped, Total Unmapped, Mapped %, Chromosomes, and Est. Coverage, with the Flag Statistics list expanded beneath them. |
| `analysis-filtering-tab` | Procedure, step 1 of Mark duplicates | The Filtering tab of the Inspector's Analysis section, showing Mark Duplicates in Bundle Tracks above the divider and the Create Filtered Alignment panel below it. |
| `filter-panel-controls` | Procedure, Derive a filtered alignment | The Create Filtered Alignment panel with Starting Alignment, the two keep toggles, the Minimum alignment confidence stepper reading MAPQ 20, Duplicate handling, and the Name for New Alignment field. |
| `analysis-export-tab` | Procedure, Export a deduplicated bundle | The Export tab of the Inspector's Analysis section, showing the Create Deduplicated Bundle button and its two explanatory lines. |

Changes from the old `planned_shots`. `inspector-alignment-stats` kept with a
rewritten caption naming the real fields, per the reality map. The two
coverage-histogram shots were dropped along with the histogram-scanning
procedure, since chapter 02 owns those controls and the reality map's advice
to add a Log10 companion belongs with them. `markdup-dialog` was split, since
the reality map correctly notes the two buttons sit on different tabs and
cannot appear in one frame. It became `analysis-filtering-tab` and
`analysis-export-tab`. `filter-panel-controls` is new, covering the GUI filter
panel the reality map listed as the chapter's largest omission.

## Glossary additions

Two terms, both added in the existing entry shape with anchors, alphabetised.

- **Duplicate rate** `{#duplicate-rate}`, inserted after Duplex read.
- **Edit distance** `{#edit-distance}`, inserted between E-value and ENA.

No existing entry was modified. Every other term the chapter links
(`alignment-track`, `amplicon`, `bam`, `coverage`, `coverage-breadth`, `depth`,
`flagstat`, `library-prep`, `mapq`, `mark-duplicates`, `operations-panel`,
`optical-duplicate`, `pcr-duplicate`, `percent-identity`, `pileup`,
`primary-alignment`, `properly-paired`, `provenance`, `reference-bundle`,
`secondary-alignment`, `shotgun`, `supplementary-alignment`,
`variant-caller`) already existed.

## Possible app defects and inconsistencies found

None of these blocks the chapter. All three are behaviour observations rather
than crashes.

**1. The Mark Duplicates confirmation sheet says "replace existing tracks",
which is only half true.** `AlignmentDuplicateService.markDuplicatesInBundle`
(`:63-84`) writes new tracks into `alignments/marked/` with a `[dup-marked]`
name suffix and then calls `removeAlignmentTracks` to drop the old manifest
entries. The old BAM files themselves stay on disk under their original
directory, unreferenced by the manifest. This is arguably a small disk leak,
and the wording "replace existing tracks with duplicate-marked versions" reads
to a user as though the originals are gone when the recovery path is really
just a manifest edit. Worth a product decision on whether to delete the
orphaned BAMs or to say so in the sheet.

**2. The GUI and CLI duplicate-marking paths differ in a way neither surface
announces.** `lungfish-cli markdup` overwrites the input BAM in place, while
the Inspector button writes new tracks and leaves the old files behind. Same
tool, same flags, materially different consequences for the user's data. The
chapter states the difference explicitly because a reader who learns one and
scripts the other will lose files.

**3. A naming inconsistency across the docs surfaces, not the app.** The
Inspector's disclosure title is literally `Flag Statistics`
(`ReadStyleSection.swift:1101`), and chapter 01 uses that. The
`bam.mark-duplicates` and `bam.filter` notes in `parameters.yaml`, the
`flagstat` glossary entry, and the DRIFT report all say "Flag Stats". The
glossary entry is mine to edit but changing it was outside this chapter's
brief, so it is flagged here instead. Someone should settle on `Flag
Statistics` across `parameters.yaml` and `GLOSSARY.md`.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/04-alignments/04-alignment-quality.md
```

Result: `docs/user-manual/chapters/04-alignments/04-alignment-quality.md: no issues found`

One warning was raised and fixed on the first pass. The Procedure H2 held
three numbered lists against a cap of two, so the Derive a filtered alignment
steps became two prose paragraphs.
