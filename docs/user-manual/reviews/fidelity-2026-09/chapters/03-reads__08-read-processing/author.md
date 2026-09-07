# Author report, 03-reads/08-read-processing

Chapter 21 of the campaign roster. Rewritten in place on 2026-09-07 against
Preview 2026.9.13, and added to the nav in `build/mkdocs.yml` under
Reads (FASTQ) after ONT Runs with the title Read Processing.

Lint result: `no issues found` with `LUNGFISH_MANUAL_STRICT=1`.

## Runs made

All runs used `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
against copies of the fixtures written under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/fastq-process/`.
Nothing was written into `~/Desktop/lge-docs`. Every number and every quoted
figure in the chapter comes from one of the runs below.

Input reads were the HG002 chromosome 20 slice,
`HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and `_R2`, decompressed. Each file
holds 182,296 lines, so 45,574 reads, matching the fixture README's 45,574
pairs of 2x250 reads.

| Run | Command | Result |
|---|---|---|
| Interleave | `fastq interleave --in1 R1 --in2 R2 -o HG002.interleaved.fastq` | 364,592 lines, 91,148 records, 45,574 pairs |
| Merge, defaults | `fastq merge HG002.interleaved.fastq -o HG002.merged.fastq` | Pairs 45,574, Joined 32,031 (70.283%), No Solution 13,543 (29.717%), Ambiguous 0, Too Short 0. Avg insert 371.5, SD 63.9, mode 388, insert range 64 to 482. Output 236,468 lines = 59,117 records |
| Merge, strict | same plus `--strict` | Joined 31,773 (69.717%), No Solution 13,801 (30.283%), avg insert 371.1 |
| Merge, counted | same plus `--count-duplicates` | 58,915 records representing 59,117 reads. First header `@u000001;size=3`. Provenance records `countedOutputRecords` 58,915 and `countedOutputReadCount` 59,117 |
| Repair | `fastq repair HG002.desync.fastq -o HG002.repaired.fastq` on a copy with 228 R2 mates removed | Input 90,920 reads / 22,606,292 bases. Result 90,920 (100%). Pairs 90,692 (99.75%), Singletons 228 (0.25%) |
| Error correct | `fastq error-correct HG002.interleaved.fastq -o HG002.corrected.fastq` | Input 91,148 reads / 22,662,846 bases, output identical counts. Unique k-mers 1,485,830. Errors detected 122,406, corrected 42,033. Reads with errors detected 30,929 (33.93%), fully corrected 24,219 (78.31% of detected), partly corrected 935 (3.02%), rollbacks 4,121 (13.32%) |
| Reverse complement | `fastq reverse-complement R1 -o HG002.R1.rc.fastq` | 45,574 records. Verified by hand that the output quality string reversed equals the input quality string, so scores travel with their bases |
| Translate, frame 1 | `fastq translate R1 -o HG002.R1.protein.fasta` | 45,574 FASTA records, header `>...:41403_frame+1 [Standard] [83 aa]`, 83 aa from a 250 base read |
| Translate, frame 4 | same plus `--frame 4` | header reads `_frame-1`, confirming frames 4 to 6 are the reverse strand |
| Orient, chr20 reference | `fastq orient HG002.R1.10k.fastq --reference GRCh38.chr20.10.0-10.5Mb.fasta -o ...` | Forward 0, Reverse 0, All oriented 0 (0.00%), Not oriented 10,000 (100%). Zero-byte output. See the defect note below |
| Orient, chr20 reference, no mask | same plus `--db-mask none`, 1,000 reads | Still 0 oriented, so masking is not the cause |
| Orient, chr20 reference split into 5 kb chunks | same, `--reference chr20.chunks.fasta`, 1,000 reads | 986 of 1,000 records written, so the reference's single-record shape is the cause |
| Orient, mitochondrial | `fastq orient chrM.ont.1k.fastq --reference NC_012920.1.fasta -o chrM.oriented.fastq` on 950 HG002 chrM ONT reads | Forward 439 (46.21%), Reverse 488 (51.37%), All oriented 927 (97.58%), Not oriented 23 (2.42%). Output 927 records |
| Deinterleave round trip | `fastq deinterleave HG002.interleaved.fastq --out1 rt_R1 --out2 rt_R2` | Line counts match the originals exactly, but the content differs. See the second defect note below |

The chapter's Orient Reads worked numbers are the mitochondrial run, because
that is the one that produces an honest result on the app as shipped. The
chr20 attempt is not described in the chapter.

## What was removed from the old chapter and why

The old chapter was 115 lines and had no Before you start, no Settings, no
Reading the results, no What good looks like, and no On the command line
section, so the rewrite is closer to a new chapter than to an edit.

- Both menu paths of the form `Tools > FASTQ/FASTA Operations > Read Processing…`
  are gone. That submenu does not exist. Replaced with
  `Tools > Read Processing > <Operation>...` throughout, per the campaign-wide
  finding and DRIFT false rows 1 and 3.
- The claim that every operation writes a new FASTQ bundle is gone. Translate
  emits protein FASTA, and the chapter now says so and explains why, per
  DRIFT changed row 4.
- "Translate is covered with the sequence tools" is gone. Translate is the
  sixth member of this category and is now fully documented here, per DRIFT
  changed row 6 and the first Missing row.
- The `## What you will learn` section is gone. It is not in the campaign
  template.
- The two summary tables in the old What it is and Procedure sections are
  gone. The template asks for prose plus a Settings section, and the tables
  carried the wrong field labels (`Min Overlap` for **Minimum Overlap**,
  `K-mer` for **K-mer Size**) that DRIFT changed rows 11, 13, and 24 correct.
- "valid range 1 to 62" for the k-mer is gone. The app's only check is
  greater than zero, and the 62 ceiling is the command line's. The Settings
  entry now states both facts separately, per DRIFT changed row 13.
- The old `## Interpretation` heading is gone, replaced by the template's
  Reading the results and What good looks like.
- The deferral of Orient Reads to chapter 07 is gone. Orient Reads is
  documented here in full, with the corrections from the 07 rows 18 to 24
  applied. Specifically the Query Mask picker, the Threads stepper, the
  `--mask` flag, and the `--save-unoriented` flag are all removed because
  none exists, and the Extra arguments field is documented because it does
  exist. The Save unoriented reads checkbox is described as belonging to the
  FASTQ viewport's Operations tab, not to the operations dialog.
- The last-chapter sentence is kept here, per DRIFT false row 27. Removing it
  from chapter 07 is that chapter's job.

Newly added because the old chapter omitted them: the Output Strategy setting
on all six operations, the CLI `--frame` and `--table` on translate, the
CLI `--force` and `--compress` pair, the readiness messages, the counted
exemplar behaviour with `size=N` headers, and the bbtools 40.02 pin.

## How each unverifiable row was settled

DRIFT records three unverifiable claims for this chapter. Ground-truth rows
12, 15, 17, 23, and 26 carry them.

1. Rows 12 and 23, the ordering of merged and unmerged reads in the output.
   Settled by reading `Sources/LungfishCLI/Commands/FastqCommand.swift`
   around line 2074, where bbmerge is given `out=merged.fastq` and
   `outu=unmerged.fastq` and the two files are concatenated in that order,
   merged first. Confirmed empirically: record 32,031 of the output is the
   last merged record and record 32,032 begins the unmerged block, and
   32,031 + 13,543 x 2 = 59,117 exactly matches the output record count. The
   chapter now states the ordering and the arithmetic as fact.
2. Rows 15 and 26, whether repair keeps orphaned reads as singletons.
   Settled by reading the same file around line 2245, where repair.sh is
   given `out=repaired.fastq` and `outs=singletons.fastq` and both are
   concatenated into the single output. Confirmed by the run above, where
   90,692 paired plus 228 singletons equals the 90,920 input records with
   nothing lost. The chapter now asserts the singleton behaviour with the
   worked numbers behind it.
3. Row 17, whether the dialog interleaves a paired bundle before feeding
   bbmerge. Settled by the CONSISTENCY sheet's paired-end storage note, which
   records that a paired-end import is already stored inside its
   `.lungfishfastq` bundle as one interleaved file with
   `pairingMode: interleaved`. No interleaving step is therefore needed or
   performed, and no such step exists in
   `FASTQDerivativeServiceModels.swift`, whose `pairedEndMerge` case passes
   the bundle's resolved input path straight to `fastq merge`. The chapter
   drops the old sentence and instead tells the reader in Before you start
   that an import stores a paired sample interleaved, which is why merge and
   repair work on a bundle without preparation.

## Shot markers

Four, each with a caption in the frontmatter `shots` list.

- `read-processing-menu`, in What it is, showing the six operations in the
  submenu. Added because DRIFT false rows 1 and 3 turn on the menu shape.
- `merge-overlapping-pairs-pane`, in the merge procedure, showing the
  Strictness segments and the Minimum Overlap field. This is the shot the
  DRIFT screenshots table asks for, placed where it asks for it.
- `sidebar-after-merge`, after the merge run, showing the output bundle under
  Analyses. Added because CONSISTENCY settled that a FASTQ operation writes
  its bundle directly under `Analyses/` named `<input stem>-<operation>`, and
  the old chapter never showed where output lands.
- `orient-reads-pane`, in the orient procedure, showing Word Length, the
  single Database Mask picker, and Extra arguments. This is the shot the 07
  screenshots table asks for, and four of the old claims about this pane
  were wrong.

## Glossary additions

Two terms added to `GLOSSARY.md` in the existing entry shape, alphabetised,
and both listed in `glossary_refs`.

- `Read merging`{#read-merging}, placed between Read identifier and Reading
  frame.
- `Singleton read`{#singleton-read}, placed between Single-end and
  Sliding-window trimming.

Every other term the chapter links already existed, including insert size,
interleaved FASTQ, k-mer, Phred score, reverse complement, reading frame,
codon, Orient Reads, amplicon, and provenance.

## Possible app defects found

Two, both in `fastq` subcommands, both reproducible.

### 1. Interleave silently rewrites Phred 2 as Phred 0

`lungfish-cli fastq interleave` changes quality scores. On this fixture,
every one of the 3,522 `#` characters in the two input files (Phred 2, the
Illumina read-segment-quality-control indicator that marks a B tail) becomes
`!` (Phred 0) in the interleaved output. Counted directly:

```
hash characters in original R1+R2 quality lines: 3522
bang characters in original R1+R2 quality lines: 0
hash characters in interleaved output:              0
bang characters in interleaved output:           3522
```

The round trip therefore does not preserve the input. `deinterleave` of the
interleaved file gives files with the right line counts whose content
differs from the originals at exactly those positions, first at R1 line
1872.

Cause, from `Sources/LungfishCLI/Commands/FastqCommand.swift` around line
2395, is that the reformat.sh invocation passes only `in1`, `in2`, and `out`
with no `qin=33 qout=33`, so BBTools auto-detects the quality encoding and
re-encodes. Deinterleave is not implicated. The defect is in interleave
alone.

Impact is small but real. Phred 2 is the conventional marker for the
low-quality tail of an Illumina read, and turning it into Phred 0 destroys
the distinction between "flagged as unreliable" and "no confidence at all"
for any downstream tool that treats the two differently. The chapter does
not document interleave as lossy, because a reader should not have to work
around this, but the round trip in the chapter's command block will show the
behaviour to anyone who diffs the result.

### 2. Orient Reads returns an empty output against a single-record reference

`lungfish-cli fastq orient` against
`GRCh38.chr20.10.0-10.5Mb.fasta`, a single 500,001 base FASTA record,
orients zero of 10,000 reads and writes a zero-byte output file. It exits 0
and prints nothing at all, so from the terminal the run looks successful.
Setting `--db-mask none` does not change the result. Splitting the same
reference sequence into 5 kb records makes it work, orienting 986 of 1,000
reads, so the trigger is the reference being one long record rather than
anything about the sequence or the reads.

Two things are worth separating here. The zero orientation rate is plausibly
vsearch's own behaviour on a database of one very long sequence rather than
an LGE bug. The silent success is an LGE behaviour: the subcommand does not
check whether the output has any records, does not surface vsearch's
"All oriented sequences: 0 (0.00%)" summary to the user, and prints no
completion message of its own, unlike merge, repair, and error-correct which
all print a "written to" line. A user orienting reads against a whole-genome
or whole-chromosome reference gets an empty file and no indication that
anything went wrong.

The chapter's What good looks like section tells the reader to compare the
orient output count to the input count every time, which is the workaround,
but a warning when the oriented count is zero would be a better fix.

### Note, not a defect

The `--force` refusal on a pre-existing zero-byte output is correct behaviour
and behaved as documented.
