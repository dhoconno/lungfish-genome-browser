# Author report: 04-alignments/01-mapping-reads-to-a-reference

Chapter 22 of the campaign roster. Registry ids `map.minimap2`, `map.bwa-mem2`,
`map.bowtie2`, `map.bbmap`, `import.bam`. Fixture `hg002-chr20`.

Author: bioinformatics-educator. Date: 2026-09-07.
Lint: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`.

## Runs made

All runs used `.build/debug/lungfish-cli` against copies of the fixture files in
the session scratchpad. Nothing was written into the repository, the fixture
folder, or `~/Desktop/lge-docs`.

Inputs for every run were `HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and
`HG002.chr20.10.0-10.5Mb_R2.fastq.gz` mapped against
`GRCh38.chr20.10.0-10.5Mb.fasta`, paired, sample name `HG002`, all other
settings at their defaults.

All four mappers are installed on this machine. `~/.lungfish/conda/envs/` holds
`minimap2`, `bwa-mem2`, `bowtie2`, and `bbtools`, so nothing had to be
documented from dialog text alone.

| Mapper | Preset | Records | Mapped | Mapped % | Unmapped | Mean depth | Breadth | Mean identity | Median MAPQ | Runtime |
|---|---|---|---|---|---|---|---|---|---|---|
| minimap2 | `sr` | 91,203 | 90,990 | 99.77% | 213 | 44.7x | 99.994% | 99.42% | 60 | 4.8 s |
| BWA-MEM2 | `sr` | 91,317 | 91,239 | 99.91% | 78 | 44.8x | 99.994% | 99.42% | 60 | 8.0 s |
| Bowtie2 | `sr` | 91,148 | 90,241 | 99.00% | 907 | 44.8x | 99.979% | 99.11% | 42 | 8.4 s |
| BBMap | `bbmap-standard` | 91,148 | 90,658 | 99.46% | 490 | 45.0x | 99.994% | 98.97% | 45 | 14.4 s |

Depth, breadth, identity, and median MAPQ come from each run's own
`mapping-result.json`. Runtimes are the `wallClockSeconds` each run recorded on
a 14-core Apple Silicon machine and are reported in this report only. The
chapter quotes no durations.

### Comparison against the fixture's expected mapping

My minimap2 run reproduces `expected/mapping/mapping-result.json` exactly.
91,203 total, 90,990 mapped, 213 unmapped, 99.7664550508207% mapped, mean depth
44.7234, coverage breadth 0.999938, mean identity 0.9942115, median MAPQ 60.
Every figure matches to the digit, which confirms the fixture README's numbers
and confirms the pipeline is deterministic for this input.

### samtools flagstat on each result BAM

| Category | minimap2 | BWA-MEM2 | Bowtie2 | BBMap |
|---|---|---|---|---|
| total | 91,203 | 91,317 | 91,148 | 91,148 |
| primary | 91,148 | 91,148 | 91,148 | 91,148 |
| secondary | 0 | 0 | 0 | 0 |
| supplementary | 55 | 169 | 0 | 0 |
| primary mapped | 90,935 | (not quoted) | (not quoted) | (not quoted) |
| properly paired | 90,414 | (not quoted) | (not quoted) | (not quoted) |

The 55 supplementary records match the fixture README. The 169 for BWA-MEM2 is
new and is quoted in the chapter's mapper-comparison paragraph. Bowtie2 and
BBMap emit none, which is why their totals equal the input's 91,148 reads.

### Adoption run

```
lungfish-cli bam adopt-mapping --bundle <scratch>/GRCh38.chr20.10.0-10.5Mb.lungfishref \
  --mapping-result <scratch>/minimap2-out --name "minimap2 Mapping"
```

Printed exactly `Attached alignment track 'minimap2 Mapping' (aln_86981CC7) to bundle.`
The scratch bundle was created with `lungfish-cli import fasta`, which placed it
under `Reference Sequences/` as the consistency sheet describes.

### Provenance read from the minimap2 run

`mapping-provenance.json` records `mapperVersion` 2.31 and `samtoolsVersion`
1.24, matching the pinned versions the reality map names. It records five steps,
not three, in this order.

```
minimap2 -a -x sr -t 14 -R @RG\tID:HG002\tSM:HG002\tLB:HG002\tPL:ILLUMINA\tPU:HG002 --secondary=no -o HG002.raw.sam <ref> <r1> <r2>
samtools view -b -o HG002.filtered.bam -F 256 HG002.raw.sam
samtools sort -@ 7 -o HG002.sorted.bam HG002.filtered.bam
samtools index HG002.sorted.bam
samtools flagstat HG002.sorted.bam
```

The chapter states five steps and names them. The old chapter said three.

## What was removed from the old chapter, and why

The rewrite is close to total. Sections that no longer exist and what replaced
them.

**"What you will learn".** Not in the campaign template. Its content is absorbed
into What it is and Why you would do this.

**"Choosing a mapper" table.** Every cell was an unsourced editorial judgement,
including a literature-benchmark claim (DRIFT unverifiable 8). Replaced by a
"What the four mappers give you on the same reads" table built entirely from my
own four runs, plus a short paragraph of practical guidance that no longer
asserts benchmark equivalence.

**"Choosing a preset" as its own section.** Preset selection now lives in the
Settings entry for **Preset.** and the label-to-token table moved into On the
command line, which is the only place the tokens are needed.

**"Read groups" as its own section.** The old chapter treated read groups as
CLI-only, which is false. The wizard has five editable read-group fields.
Rewritten as five Settings paragraphs using the wizard's verbatim labels.

**"Advanced filters" table.** Replaced by five Settings paragraphs. The old
table's Threads row named no CLI flag (DRIFT false 27) and its Supplementary row
inverted the wizard checkbox's polarity (DRIFT changed 29).

**"Worked example: SRR36291587 against MN908947.3".** Wrong fixture for this
chapter and viral where the roster calls for human. Replaced throughout by the
HG002 chromosome 20 slice. This also removes the unsourced "well under a minute"
duration and the invented "mapping rate above 95% and mean coverage in the
hundreds or thousands".

**"Interpretation" section.** Named four Inspector fields that do not exist,
total reads, mapped reads, mapping rate, mean coverage, primary alignment count
(DRIFT false 43). Replaced by Reading the results, built on the five rows the
Inspector actually renders plus the Flag Stats list.

**"Troubleshooting" section.** Folded into What good looks like, keeping the
three real failure modes and dropping the paired-end claim about "slots" (DRIFT
false 50), since the wizard has no slots and pairing is decided after the run
starts.

**"A note on viral recon" section.** Cut. Its whole content was the wrong menu
path plus a pointer to chapter 05, and the menu-path correction (DRIFT changed
51) leaves nothing behind worth a section. The Viral Recon submenu item is
named in the `tools-mapping-submenu` shot caption instead, and chapter 05 owns
the wizard. The chapter's Next line points at chapter 02 as before.

**Every `Tools > FASTQ/FASTA Operations > Mapping…` path.** Replaced with
**Tools > Mapping > minimap2...** and siblings (DRIFT false 3 and 35). The
old dialog-and-tool-row model is gone from the chapter entirely.

**The `map` operations-row label.** Replaced with the real title,
`Map Reads (minimap2): <sample name>` (DRIFT false 39).

**"All it asks you for is the reference and the preset".** Replaced with the
corrected two-fields-plus-two-disclosures wording (DRIFT false 5), and the
multi-bundle sixth section is now documented (DRIFT changed 33 and the first
Missing row).

**"`lungfish map --reference` resolves the primary FASTA from whatever you
point it at".** Softened to the corrected wording (DRIFT changed 48).

**"a CLI run uses whatever you pass to `--name`".** Corrected to
`lungfish bam adopt-mapping --name` (DRIFT changed 42), since `map` has no
`--name`.

## Missing features now covered

Every row of the DRIFT Missing table is in the chapter except two, noted below.

Covered: multi-bundle run mode and its per-bundle read-group notice (quoted
verbatim); the five editable Read Group fields with their CLI twins in the
labels; the Platform field rewriting itself when the preset changes; the
wizard auto-selecting a preset and stopping once you change it; the live
parse of Extra arguments blocking Run; the four per-mapper Extra arguments
placeholders; the `read-mapping` plugin pack and BBMap's BBTools exception;
the pinned versions (minimap2 2.31 and samtools 1.24, quoted from my own
provenance sidecar); Bowtie2's `-k 10` and BBMap's `secondary=t`;
`lungfish map` treating multiple inputs as one sample; `--format json` and
`--format tsv`.

Not covered, deliberately. The per-preset one-line descriptions under the
picker are not quoted, because quoting six of them would bloat the Preset
Settings paragraph past its three-sentence shape. `bam annotate-best` and
`bam annotate-cds-best` are out of scope for a mapping chapter and belong with
the bundle-building commands.

## How each DRIFT unverifiable row was settled

**Claim 8, "minimap2 equivalent to BWA-MEM in published benchmarks for
short-read viral data".** Settled by deletion. This is a literature claim with
no source in the repository and no citation in the bibliography. Rather than
chase a citation, the chapter now makes the comparison empirically from my own
four runs on the fixture and says what those runs show, which is that the four
mappers agree within a percentage point on mapping rate and within a third of a
read on mean depth. The chapter makes no claim about published benchmarks.

**Claim 46, "`bam adopt-mapping` mints an identifier of the form
`aln_<hex>`".** Settled as true, with a correction to the wording. The reality
map asked for `Sources/LungfishCLI/Commands/BAMAdoptMappingSubcommand.swift` to
be read. Line 46 is
`let outputTrackID = trackIDOverride ?? "aln_\(UUID().uuidString.prefix(8))"`.
That is not hex, it is the first eight characters of a UUID string, which
happen to be hex digits for a version-4 UUID's first block but are uppercase
and could in principle include a hyphen. I confirmed it by running the
adoption, which produced `aln_86981CC7`. The chapter therefore says "of the
form `aln_` followed by eight characters taken from a fresh UUID" and quotes
the real identifier.

**Claim 52, "the separate top-level Workflow Operations… item is the generic
Nextflow/Snakemake runner".** Settled by deletion. The claim was asserted only
by omission in the old chapter and the reality map found no menu item bound to
`showWorkflowOperations`, the same orphan pattern as
`showFASTQMappingOperations`. The rewritten chapter makes no statement about a
Workflow Operations menu item, so nothing needs settling. Flagged below as a
possible defect for whoever owns the Tools menu.

## Shot markers

Four markers, each with a frontmatter entry.

| Marker | Why it is placed there |
|---|---|
| `tools-mapping-submenu` | Replaces the old `mapping-tool-picker`, which framed a dialog that is not the entry point. Caption names all five submenu items, per the reality map's recapture note. |
| `mapping-wizard-overview` | Kept from the old planned shot. Caption rewritten to name the HG002 reference, the Short-read preset, and the collapsed Read Group and Advanced Settings disclosures beneath, so it evidences the correction to DRIFT claim 5. |
| `mapping-wizard-advanced` | New. The Settings section documents five controls that are invisible until the disclosure is opened, so the reader needs to see them. |
| `alignment-inspector-stats` | New. The Inspector's five rows and its collapsed Flag Stats list are the correction to DRIFT false 43, and a reader looking for "mean coverage" needs to see that the field is called Est. Coverage. |

The old `mapping-tool-picker` planned shot and its caption are gone.

## Glossary additions

Six terms, all added in the existing entry shape, alphabetised, with `See also:`
lines.

- **Coverage breadth**{#coverage-breadth}
- **Flagstat**{#flagstat}
- **Primary alignment**{#primary-alignment}
- **Properly paired**{#properly-paired}
- **Read group**{#read-group}
- **Secondary alignment**{#secondary-alignment}

Each is listed in the chapter's `glossary_refs`. Seven further terms the chapter
links (`bam`, `mapping`, `alignment`, `mapper`, `soft-clip`,
`supplementary-alignment`, `mapq`, `mapping-preset`, `plugin-pack`,
`reference-bundle`, `provenance`) already existed and were not edited.

Each new entry raises exactly one linter warning, the `See also:` colon, which
every one of the file's 300-plus existing entries also raises. The glossary as a
whole reports 282 warnings and has done since before this chapter. No new
semicolon, em dash, or banned word was introduced.

## Possible app defects found

**Orphaned Tools menu selectors.** The reality map found `showFASTQMappingOperations`
(`MainMenu.swift:1164`) and `showWorkflowOperations` (`MainMenu.swift:1180`)
declared with no menu item bound to either. Dead selectors are harmless at
runtime but they are the reason the old chapter documented a
`Tools > FASTQ/FASTA Operations > Mapping…` path that no user can follow. Worth
either removing or rebinding, so the source stops implying a menu that is not
there.

**Documentation-facing, not a crash.** The mapping-result JSON's `totalReads`
counts alignment records rather than reads, so it exceeds the input read count
whenever the mapper emits supplementary alignments. The CLI's own summary block
prints that number under the label "Total reads", which reads as a plain read
count and is not one. On the fixture this makes the CLI print 91,203 total
reads for a 91,148-read input, a discrepancy a user has no way to explain
without running `samtools flagstat` themselves. The fixture README already
records this trap in its own words. A label of "Total records" or a separate
primary-read line would remove it. The chapter works around it by explaining
the arithmetic in Reading the results.

**Not a defect, recorded so it is not rediscovered.** BWA-MEM2 streams its SAM
output through a pipe (`Streaming bwa-mem2 SAM output...`) where minimap2 writes
a SAM file to disk and filters it afterwards. The two mappers therefore take
different paths through the same pipeline. The chapter describes the minimap2
path, which is the default, and does not claim the other three share it.
