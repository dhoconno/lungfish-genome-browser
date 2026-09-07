# Author record, 06-human-germline-variants/04-reference-packs

Roster row 45. Title "Reference Files for GATK". No registry ids
(`parameters_refs: []`). Fixture hg002-chr20. Rewritten against Preview
2026.9.13 on 2026-09-07.

Scratch directory for every run below:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-refs/`

CLI binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
GATK 4.6.2.0 at `~/.lungfish/conda/envs/gatk-core/bin/gatk` (installed by the
chapter-01 author, reused here). samtools 1.24 from `~/.lungfish/conda/envs/samtools`.
bcftools 1.24 from `~/.lungfish/conda/envs/bcftools`.

## Section order chosen

The brief allowed a reference-chapter shape. Used:

What it is, Why you would do this, Before you start, then four file-by-file
H2 sections (The reference FASTA and its index, The sequence dictionary, The
known-sites files, The interval list), then What good looks like, On the
command line, Next.

No Procedure section, because the chapter has no single ordered task with a
window. No Settings section, because `parameters_refs` is empty and the
chapter documents no registry operation. The `bqsr` flags that the old
chapter covered as prose are folded into the file sections and the closing
On the command line discussion, where each one is attached to the file it
consumes rather than listed in isolation.

## Inputs staged

Copied read-only from `docs/user-manual/fixtures/hg002-chr20/`. The fixture's
shipped `.fai` was deliberately NOT copied, so that the chapter's `samtools
faidx` step created it from scratch and could be compared against the shipped
one.

- `GRCh38.chr20.10.0-10.5Mb.fasta` (510,021 bytes)
- `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` + `.tbi`
- `expected/mapping/HG002.sorted.bam` (12,981,720 bytes) + `.bai`
- `expected/variants/bcftools/HG002.bcftools.vcf.gz` + `.tbi` (for collect-metrics)

Nothing was written to the fixture tree or to `~/Desktop/lge-docs/`.

## Commands run, in order

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `samtools faidx GRCh38.chr20.10.0-10.5Mb.fasta` | 0 | Wrote `GRCh38.chr20.10.0-10.5Mb.fasta.fai`, **34 bytes**, one line `chr20_10.0-10.5Mb 500001 19 50 51`. Byte-identical and content-identical to the fixture's shipped `.fai`, which is the evidence that the chapter's command reproduces the shipped file. The five-field explanation in the chapter is read off this line. |
| 2 | `gatk CreateSequenceDictionary -R GRCh38.chr20.10.0-10.5Mb.fasta` | 0 | Wrote `GRCh38.chr20.10.0-10.5Mb.dict`, **251 bytes**. Content quoted in the chapter: `@HD VN:1.6` and one `@SQ` with `SN:chr20_10.0-10.5Mb`, `LN:500001`, `M5:0bffe5f36c15cdb7069b96a1d4e4a0ef`, and a `UR:file://` absolute path. The chapter-01 author recorded 249 bytes and the chapter-02 author 252 for the same reference. The `UR` path field explains the spread, and the chapter says so. |
| 3 | `lungfish-cli gatk bqsr ... --known-sites <benchmark VCF>` (preview) | 0 | Printed **two** command lines, `BaseRecalibrator` then `ApplyBQSR`. Covers the Missing row that the chapter never said the preview prints two lines. |
| 4 | Same as 3 with `--execute`, benchmark VCF as known sites | **1** | FAILED. GATK contig-mismatch user error, quoted verbatim in the chapter. `contig reference = chr20_10.0-10.5Mb / 500001` versus `contig features = chr20_10.0-10.5Mb / 64444167`. Provenance written with `status: failed`, step exit 2, wall 1.13 s. This is the chapter's central worked failure. |
| 5 | `bcftools view -h <benchmark> \| grep ^##contig` | 0 | **195 contig header lines**, the one for the slice declaring `length=64444167`. Diagnosis behind run 4. |
| 6 | `bcftools reheader --fai ... -o known-sites.vcf.gz` then `bcftools index --tbi -f` | 0 | Wrote `known-sites.vcf.gz` **38,323 bytes** with exactly one contig line at `length=500001`, plus a **392 byte** `.tbi`. **961 records** preserved. |
| 7 | `bcftools view -H -v snps` / `-v indels` on the reheadered file | 0 | **809 SNVs, 152 indels**. 809 + 152 = 961, checks out. |
| 8 | `lungfish-cli gatk bqsr ... --known-sites known-sites.vcf.gz --execute` | 0 | SUCCEEDED. Printed exactly `GATK execution completed with exit code 0.` and `Provenance: <path>`. Wrote `HG002.recal.table` **1,191,386 bytes**, `HG002.bqsr.bam` **16,929,652 bytes**, `HG002.bqsr.bai` 1,576 bytes. Provenance `status: completed`, name "GATK Base Quality Score Recalibration", **two steps of 3.78 s and 2.58 s**, both `toolName: gatk-bqsr`, `toolVersion: 4.6.2.0`, exit 0. |
| 9 | `head -8 HG002.recal.table` | 0 | Confirmed the table opens with a `#:GATKReport.v1.1:5` line and an Arguments block listing `covariate ReadGroupCovariate,QualityScoreCovariate,ContextCovariate,CycleCovariate`. Basis for the chapter's and the glossary's claim that the first block lists the run's arguments. |
| 10 | `lungfish-cli gatk bqsr ... --intervals first100kb.bed --extra-args "--verbosity ERROR"` (preview) | 0 | **Both** printed commands carried `-L first100kb.bed` AND `--verbosity ERROR`. Covers two Missing rows at once, that `--intervals` reaches both steps and that `bqsr --extra-args` lands on both, unlike `joint-genotype`. |
| 11 | `--execute` in a folder holding FASTA + `.fai` but no `.dict` | **1** | FAILED with `A USER ERROR has occurred: Fasta dict file ... does not exist.` Quoted verbatim. Independently reproduces the chapter-01 author's finding that LGE never creates the `.dict`. |
| 12 | `--execute` in a folder holding FASTA + `.dict` but no `.fai` | **1** | FAILED with `A USER ERROR has occurred: Fasta index file ... does not exist. Please see https://gatk.broadinstitute.org/hc/articles/360035531652-FASTA-Refe...` Quoted verbatim. |
| 13 | `--execute` with a known-sites VCF that has no `.tbi` | **1** | FAILED with `An index is required but was not found for file ... Support for unindexed block-compressed files has been temporarily disabled. Try running IndexFeatureFile on the input.` Quoted verbatim. A fourth prerequisite not in the reality map. |
| 14 | `gatk IndexFeatureFile -I known-sites.vcf.gz` | 0 | Wrote a **430 byte** `.tbi`, confirming GATK's own suggested remedy from run 13 works. Offered in the chapter as an alternative to bcftools. |
| 15 | `bcftools view -v indels -Oz -o known-indels.vcf.gz` + index | 0 | **152 records**, 8,829 bytes, 360 byte `.tbi`. The stand-in for a Mills-style second resource. |
| 16 | `bqsr` preview with two `--known-sites` flags | 0 | Both paths appeared on the `BaseRecalibrator` line in order. Confirms the option repeats. |
| 17 | `lungfish-cli gatk collect-metrics --vcf HG002.bcftools.vcf.gz --output-prefix HG002.metrics --dbsnp known-sites.vcf.gz --sequence-dictionary GRCh38.chr20.10.0-10.5Mb.dict --execute` | 0 | SUCCEEDED. Wrote `HG002.metrics.variant_calling_summary_metrics` (1,612 B) and `...detail_metrics` (1,718 B). Figures quoted in What good looks like: **TOTAL_SNPS 873, NUM_IN_DB_SNP 805, PCT_DBSNP 0.922108, DBSNP_TITV 2.245968, NOVEL_TITV 1.344828**, 68 novel SNVs. This is the only run that exercises `--sequence-dictionary`, the one place a `.dict` is passed on a command line rather than found by convention. |
| 18 | `lungfish-cli conda install --pack gatk-core` | **3** | FAILED. `✗ Unknown tool pack: gatk-core` then `Available packs: lungfish-tools, read-mapping, full-length-mhc-genotyping, variant-calling, assembly, multiple-sequence-alignment, phylogenetics, metagenomics`. Confirms drift row 96. |
| 19 | `lungfish-cli conda install --pack phasing` | **3** | FAILED identically. Confirms drift row 101. |
| 20 | `lungfish-cli conda envs` | 0 | **`gatk-core 21 pkgs 887.6 MB`** and **`phasing 67 pkgs 369.9 MB`**. These are measured on-disk sizes against the Plugin Manager's declared 600 MB and 180 MB estimates. New finding, see Defects. |
| 21 | `lungfish-cli conda list` | 0 | Shows `gatk-core (21 packages)`. Named in the chapter as an inspection route. |
| 22 | `lungfish-cli conda packs` | 0 | Eight packs listed, neither experimental pack among them. Corroborates runs 18 and 19 from the other direction. |
| 23 | `lungfish-cli conda export-pack --pack gatk-core --output ./packexport` | 0 | SUCCEEDED on the experimental id that run 18 rejected. Wrote an offline pack with `offline-pack-manifest.json` and its own `.lungfish-provenance.json`, measuring **865 MB** by `du -sh`. Confirms the reality map's note that `export-pack` uses `builtInPack(id:)` rather than the visible list. Deleted after measuring. |
| 24 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh ...` | 0 | One warning first pass, clean on the second. See Lint. |

Note on the CLI help: run 23's flags are `--pack` and `--output`, not the
`--output-dir` I first guessed. Corrected from `conda export-pack --help`
before the successful run, and the chapter uses the correct spelling.

## Source files consulted

- `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:473-506`, the
  `baseQualityScoreRecalibrationCommands` function. Read directly to confirm
  the argument order, that `--known-sites` is emitted once per URL, that
  `-L` is appended to both the recalibrator and the apply argument arrays,
  that `config.extraArguments` is appended to both, and that
  `--create-output-bam-index` is stringified from the config. Runs 10 and 16
  confirm the same behaviour from outside.
- `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:569-580`, the
  `collectVariantCallingMetricsCommand` function, showing `--DBSNP` always
  emitted and `--SEQUENCE_DICTIONARY` emitted only when the optional URL is
  present. The basis for calling collect-metrics the place a `.dict` is
  passed explicitly.
- `Sources/LungfishWorkflow/Conda/PluginPack.swift:617-666`. The `gatk-core`
  pack, read line by line for the display name "GATK Core", the description
  string quoted in the chapter, `category: "Variant Calling"`,
  `isExperimental: true`, `estimatedSizeMB: 600`, and the smoke test
  `gatk --version` with a 30 second timeout requiring the substring "The
  Genome Analysis Toolkit". Then the `phasing` pack for the display name
  "Variant Phasing", its description, the same category and experimental
  flag, `estimatedSizeMB: 180`, and its `whatshap --version` smoke test with
  a 10 second timeout and no required substring.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/gatk.txt:1-28` for the
  subcommand list and the banner, `:139-166` for the full `bqsr` option set
  including the `--extra-args` help string "Additional GATK arguments
  appended to both BQSR commands", and `:244-263` for `collect-metrics`.
- The two sibling author reports named in the brief, both read in full before
  writing. The `.dict` prerequisite and its fix command come from
  `01-haplotype-caller/author.md` and were independently reproduced here at
  run 11. The pack-install defect, the Plugin Manager route, and the lock's
  pinned build string come from `02-joint-genotyping/author.md` and were
  independently reproduced at runs 18 and 19.
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md` for the naming
  rule, the fixed experimental-feature sentence, the fixed project sentence,
  and the fixture name "the HG002 chromosome 20 slice".

## Drift coverage

Every false and changed row applied.

Row 96 and 101, the two false install commands, removed entirely and replaced
with the Plugin Manager route plus a plain statement of the defect. Row 105,
`entry_points` rewritten to the two GUI pack routes plus the `gatk bqsr` CLI
line. Row 92, the in-sentence colon gone, and BQSR is now glossed across a
whole Why-you-would-do-this section rather than a parenthetical. Row 94,
`--intervals` now says both steps, proved at run 10. Row 97, the full pinned
build string is in the chapter-02 sibling and this chapter instead states the
installed version 4.6.2.0 and its path, because this chapter's reader needs
the path to run the commands and the pin is documented next door. Row 98, the
experimental flag's concrete effects are now stated, hidden from the Plugin
Manager without the toggle and absent from the CLI installer. Row 99, the
600 MB is attributed to the Plugin Manager as a declared estimate, and the
measured 887.6 MB is given beside it. Row 100, the phased entry is described
as not running from the GUI, with the CLI `variants phase` route named. Row
102, the display name "Variant Phasing" and the id `phasing` both given.
Row 104, split into separate sentences with no colon, and provenance is said
to land beside the output file on the CLI route. Row 107, `features_refs` set
to `[variants.gatk-germline]`.

Every Missing row covered. The **Show Experimental Features** toggle and its
warning text are in Before you start with a shot marker. Both pack display
names, descriptions, and the Variant Calling category are named. The 180 MB
Variant Phasing estimate is given. The `gatk-core` and `phasing` environment
paths under `~/.lungfish/conda/envs/` are given, and the chapter uses the
full binary path in every command for that reason. `conda envs` and
`conda list` are named as the way to check what is installed. That `bqsr`
prints two commands is stated and proved. That `bqsr --extra-args` reaches
both commands, unlike `joint-genotype`, is stated with the contrast drawn
explicitly. `conda export-pack` is given as the scripted workaround, with the
note that it accepts the experimental id the installer rejects.

The one Missing row I did not cover as written is the WhatsHap smoke test
detail (`whatshap --version`, 10 second timeout, no required substring). It
is a pack-internal implementation detail with no reader-visible consequence,
and this chapter is not the phasing chapter. Recorded here rather than
inserted.

## Defects found

Four, two of them new relative to the reality map.

1. **`conda install --pack` rejects both experimental packs** (reality map
   rows 96 and 101, reproduced at runs 18 and 19, exit code 3). The chapter
   states this plainly and routes the reader to the Plugin Manager.

2. **A known-sites VCF whose header contig length disagrees with the
   reference is rejected, and the fixture's own benchmark VCF is such a
   file** (new). Run 4. The fixture ships a sliced 500,001 base reference
   beside a benchmark VCF whose header still declares chromosome 20's full
   64,444,167 bases and 195 contigs. Any reader who tries the obvious thing,
   passing the shipped benchmark VCF as `--known-sites`, hits this. It is
   arguably a fixture defect rather than an app defect, since `regenerate.sh`
   could reheader the benchmark at build time. I did not change the fixture,
   which is the Cartographer's. The chapter turns it into the worked example
   instead, because the reheader fix generalises to every real known-sites
   file a reader will meet.

3. **The Plugin Manager's size estimates understate the installed
   environments by roughly half** (new). Run 20. GATK Core is declared
   600 MB and measures 887.6 MB installed. Variant Phasing is declared
   180 MB and measures 369.9 MB. The declared numbers are hard-coded
   `estimatedSizeMB` values at `PluginPack.swift:641` and `:666`. The chapter
   gives both numbers and tells the reader to budget for the larger one. A
   caveat on my own figure: `conda envs` reports on-disk environment size,
   which is not the same quantity as download size, so the two numbers are
   not strictly comparable and the chapter does not claim they are.

4. **The GATK Core pack description is stale** (already flagged in the
   reality map, restated here because it is reader-visible). It says "GATK4
   command construction and dry-run support", which described the pack before
   `--execute` existed. The chapter quotes it and immediately says it
   understates what the pack does, rather than silently repeating it.

## What I could not verify

- **The two screenshots.** `<!-- SHOT: settings-advanced-experimental -->`
  and `<!-- SHOT: plugin-manager-gatk-packs -->` are declared with captions
  and no images exist yet. The reality map's screenshot table asks for
  exactly these two, so the markers match the plan. Capturing them belongs to
  the Screenshot Scout at gate 2. I did not launch the app, so every GUI
  sentence in Before you start rests on source reading, namely
  `PluginPack.swift:617-666` for the two cards and the reality map's cited
  `AdvancedSettingsTab.swift:16-19` for the toggle and its warning text. A
  GUI reviewer should confirm both cards actually render under Variant
  Calling once the toggle is on.

- **The real dbSNP and Mills files.** The brief capped downloads at a few
  hundred megabytes and the GRCh38 dbSNP VCF is far larger, so I downloaded
  neither. The chapter's sizes, roughly 1.5 GB for dbSNP and around 20 MB for
  Mills, are stated as approximations from the Broad Institute's public
  resource bundle and are the least well grounded numbers in the chapter.
  Everything else in it came from a file I created or read. A reviewer with
  bandwidth should confirm those two figures.

- **BQSR's actual effect on the quality scores.** The run succeeded and wrote
  a recalibrated BAM, and I confirmed the file sizes and the table's argument
  block, but I did not compare quality distributions before and after. The
  chapter therefore describes what BQSR is for without claiming a measured
  improvement on this fixture. That is the honest position, since a 500 kb
  slice with 961 known sites is far too small a training set for
  recalibration to mean anything, which is itself worth a reviewer's thought
  about whether the fixture should carry a caveat.

- **`--create-output-bam-index false`.** Named in the chapter as the way to
  turn the index off. Read from the builder source and the CLI help but not
  run.

## Glossary terms added

Four, inserted alphabetically into `docs/user-manual/GLOSSARY.md` in the
existing one-sentence-plus-"See also:" shape.

`dbsnp` (after Depth), `known-sites` (before Kreport), `picard` (before
Pileup), `recalibration-table` (before Reference bundle).

Existing entries reused rather than duplicated: `bqsr`, `fai`, `fasta`,
`indel`, `interval-list`, `phred-score`, `plugin-pack`, `provenance-sidecar`,
`read-group`, `reference-genome`, `sequence-dictionary`, `snv`, `tabix`,
`vcf`. All eighteen anchors in `glossary_refs` and all eighteen inline
`GLOSSARY.md#` links were checked to resolve against a real `{#anchor}`.

Note: GLOSSARY.md was being edited concurrently by another chapter author
during this session. One of my four edits reported the file had changed
underneath it. I re-read the insertion point before the following edit and
all four entries are present and correctly placed.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-human-germline-variants/04-reference-packs.md`

Final result:

```
docs/user-manual/chapters/06-human-germline-variants/04-reference-packs.md: no issues found
```

One warning was fixed to reach it. The overused word "gold", from the phrase
"gold-standard indel set" describing the Mills resource, in both the chapter
and the new `known-sites` glossary entry. Replaced with "curated Mills indel
set" in both places.

## Counts

- `<!-- SHOT: -->` markers: 2, matching two `shots:` front-matter entries
  with captions.
- Glossary terms added: 4. Terms linked: 18.
- Settings paragraphs: 0, since `parameters_refs` is empty and the chapter
  documents no registry operation.
- Front matter keeps `estimated_reading_min: 5`, `brand_reviewed: false`,
  `lead_approved: false`. `fixtures_refs: [hg002-chr20]`.
  `features_refs: [variants.gatk-germline]` per drift row 107.
- `prereqs` gained `06-human-germline-variants/01-haplotype-caller` alongside
  the existing plugin-packs prereq, because the chapter's Next section and
  its BAM input both assume the reader has met the caller.

## Files LGE creates versus files the reader creates

Stated plainly in the chapter, and this is the single fact it exists to
deliver. LGE creates none of them. The reader creates the `.fai` with
`samtools faidx`, the `.dict` with `gatk CreateSequenceDictionary`, the
known-sites VCFs by download plus `bcftools reheader` and an index, and the
interval BED by hand in a text editor. LGE's mapper does write the BAM read
group the chapter tells the reader to check for, which is the only companion
input that arrives already correct.
