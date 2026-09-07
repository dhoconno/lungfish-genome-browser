# Author report, 03-reads/07-ont-runs.md

Chapter 20 of the campaign roster. Registry ids `import.ont-run`,
`fastq.demultiplex-barcodes`, `fastq.ont-fluidigm-sample-split`. Fixture
`hg002-long-reads`. Rewritten in place on 2026-09-07 against Preview
2026.9.13 and `.build/debug/lungfish-cli`.

## Runs made

All runs used copies of the fixture under
`scratchpad/ont-runs/`, with a scratch `demo.lungfish` project folder
created because `fastq scout`, `fastq demultiplex`, and
`fastq ont-fluidigm-samples` all refuse to run without a `.lungfish`
root above the input. Nothing was written to `~/Desktop/lge-docs`.

| Run | Command | Result |
|---|---|---|
| Run-folder import | `fastq import-ont ont-run/fastq_pass -o imported` | 1 barcode directory, 1 chunk, 950 reads, 0.2s. One bundle `barcode01.lungfishfastq` plus `demux-manifest.json` at the output root. |
| Barcode scout | `fastq scout Imports/HG002.chrM.ont.fastq.gz --kit ont-nbd114 -o scout-result.json` | 950 reads scanned, 0 assigned (0.0%), 0 accepted barcodes. Reproduced twice. |
| Demultiplex | `fastq demultiplex Imports/HG002.chrM.ont.fastq.gz --kit ont-nbd114 -o demux-out` | Input reads 927, assigned 0 (0.0%), unassigned 927, 0 barcodes with reads, 2.5s. Output held `demux-manifest.json` and `unassigned.lungfishfastq/unassigned.fastq.gz`. |
| Fluidigm split | `fastq ont-fluidigm-samples Imports/HG002.chrM.ont.fastq.gz --barcodes fluidigm-barcodes.csv -o fluidigm-out` | Scanned 950 reads, wrote 0 sample bundles, then failed with a provenance error. Manifest recorded `inputReadCount` 950, `extractedReadCount` 0, `unassignedReadCount` 950. Reproduced twice. |

Independent counts of the fixture with `awk` over the decompressed
FASTQ gave 950 reads and 4,348,051 bases, matching the fixture README.

The fixture carries no real barcodes, as the task anticipated. Both
demultiplexing operations therefore returned nothing useful, and the
chapter says so plainly and documents each operation from its dialog
source, its registry entry, and its help text rather than inventing
counts. The zero-assignment runs are quoted in the chapter precisely
because they show the reader what an unproductive demultiplex looks
like and why the scout is worth running first.

Every count and every quoted log block in the chapter comes from these
runs. Orient Reads was not run, because it belongs to the next chapter
and appears here only as a forward pointer in `## Next`.

## What was removed from the old chapter, and why

The old chapter was largely a hypothetical SARS-CoV-2 ARTIC walkthrough
with invented file listings and no run behind any number. Removed:

- **Both wrong menu paths.** `Tools > FASTQ/FASTA Operations > Read
  Processing…` and `… > Demultiplexing` do not exist. Replaced with
  `Tools > Demultiplexing > Demultiplex Barcodes...` and
  `Tools > Demultiplexing > ONT Fluidigm Sample Split...`, per the
  campaign-wide finding that Tools holds one submenu per category.
- **The entire Orient Reads section.** Orient Reads is chapter 21's
  subject. Four of the old chapter's claims about its controls were
  wrong (a non-existent Query Mask picker, a non-existent Save
  unoriented checkbox in the operations dialog, a non-existent Threads
  stepper, and the claim that Extra arguments is CLI-only). Rather than
  correct four errors about another chapter's operation, the section is
  gone and replaced by a two-sentence pointer that explains only why
  nanopore reads need orienting.
- **The invented 8-barcode ARTIC run directory listing.** No such run
  was ever executed. Replaced by the real fixture layout.
- **The ONT-versus-Illumina comparison table.** Five rows of platform
  throughput and cost figures with no source and no way to check them
  against this repository. The two properties that actually matter to
  the reader here, read length and per-base accuracy, are now stated as
  prose against measured fixture values (263 to 39,647 bases, mean
  quality 7.9).
- **The basecaller-model section.** It asserted that LGE does not parse
  the model from FASTQ headers, which the reality map marked
  unverifiable, and its advice (record the model via `metadata import`)
  belongs to the Medaka chapter that needs it.
- **The `--mask` and `--save-unoriented` CLI flags.** Neither exists.
- **The multi-step and combinatorial dual-index demultiplexing
  section.** See the unverifiable settlement below.
- **The `--extra-args` claim, the `demux-manifest.json` guess, and the
  `unassigned` bin guess.** All three are now stated from observation
  rather than assumed.

## How each DRIFT unverifiable row was settled

The DRIFT header counts three unverifiable rows. They are rows 39, 41,
and 42 of the reality map.

**Row 39, multi-step and auto-scouted combinatorial demultiplexing.**
Settled by deletion. The reality map found only `sampleAssignments: nil`
and `kitOverride: nil` hints and located no entry point, and the CLI
exposes a single `--kit` with no chaining option. I found no surface
either. The reality map's own instruction was to locate the entry point
or delete the section, so the section is deleted. What the chapter says
instead is the true and useful part, that a second inner barcode is a
reason to run Demultiplex Barcodes or the Fluidigm split after import.

**Row 41, the ONT-versus-Illumina comparison numbers.** Settled by
deletion rather than by hedging. These were platform facts with no
source in the repository and no way for any later reviewer to check
them. The chapter now makes the same two points from the fixture's own
measured values, which are checkable.

**Row 42, whether LGE parses the basecaller model from FASTQ headers.**
Settled by removing the claim. The reality map correctly noted that
absence of a search hit is not proof of absence, so rather than assert
either way, the chapter no longer discusses basecaller-model metadata
at all. That topic belongs to the Medaka chapter, which is where a
model mismatch actually bites.

The two DRIFT "changed" rows that asked for confirmation before quoting
a name were both settled by observation, not by reading source alone:

- **Row 32, the manifest filename.** Confirmed as `demux-manifest.json`.
  Both the run-folder import and the demultiplex wrote a file of that
  name at their output root.
  `DemultiplexManifest.filename` in
  `Sources/LungfishIO/Formats/FASTQ/DemultiplexManifest.swift:28`
  agrees.
- **Row 38, the unassigned bin name.** Confirmed as `unassigned`,
  materialised as `unassigned.lungfishfastq` beside the per-barcode
  bundles, with `disposition: keep` in the manifest.

## Shot markers

Four markers, four matching `shots` entries. The old chapter had one
planned shot and no markers.

| Marker | What it shows |
|---|---|
| `ont-import-configuration-sheet` | The Import FASTQ configuration sheet as it opens for a run folder. Recaptioned per the DRIFT screenshot row, which noted the old caption described a tile that only opens a folder chooser. |
| `ont-barcode-sheet-controls` | The Barcode Sheet and Demux Folder controls, which appear only once a nanopore recipe is picked. |
| `demultiplex-barcodes-pane` | The Demultiplex Barcodes pane and its eight controls, which the old chapter named as an entry point but never showed. DRIFT asked for this one. |
| `sidebar-after-ont-import` | The resulting `barcode01` bundle under `Imports/`. |

DRIFT also asked for an Orient Reads pane shot. That shot belongs to
chapter 21 now that Orient Reads is documented there, so it is not
claimed here.

## Glossary additions

Five terms added to `GLOSSARY.md` in the existing entry shape, each
listed in the chapter's `glossary_refs`.

- **Barcode scout** (B section), the subset scan that reports per-barcode
  hit counts before a full demultiplex.
- **cutadapt** (C section, placed with the other lowercase tool names
  such as `bbduk` and `fastp`), the fuzzy matcher behind demultiplexing.
- **Fluidigm sample barcode** (F section), the barcode between the CS1
  and CS2 primers.
- **MinKNOW** (M section), the instrument control software that writes
  `fastq_pass`.
- **Unclassified reads** (U section), the reads whose barcode could not
  be called.

## Possible app defects found

Three, all reproduced.

**1. The run-folder import writes an estimated base count into
`demux-manifest.json` and presents it as data.** For the fixture the
manifest recorded `baseCount: 7495398` where the reads actually hold
4,348,051 bases, an overstatement of about 72 percent. The cause is at
`Sources/LungfishIO/Formats/FASTQ/ONTDirectoryImporter.swift:372`:

```swift
// Estimate base count (compressed bytes × ~1.5 accounts for FASTQ overhead)
let baseCount = Int64(Double(totalBytesWritten) * 1.5)
```

4,996,932 compressed bytes times 1.5 is 7,495,398 exactly. The
multiplier treats a compressed byte count as if it were an uncompressed
one, so the error scales with compression ratio and is not a small
rounding slip. The read count in the same manifest is exact. The
chapter warns the reader off this field and tells them to read the
Bases card instead, but the honest fix is either to count the bases
during the pass that already counts the reads or to omit the field.

**2. Demultiplexing silently loses reads and misreports its own input
count.** The fixture holds 950 reads with 950 distinct read ids and no
duplicates. The demultiplex reported `Input reads: 927` and wrote 927
reads to the unassigned bundle. Diffing the read ids showed 23 distinct
reads present in the input and absent from the output, with none
duplicated. Nothing in the summary, the manifest, or the progress log
accounts for the 23. The run was a both-ends cutadapt pass with the
"Enforcing both-end barcode matching" step at
`Sources/LungfishWorkflow/Demultiplex/DemultiplexingPipeline.swift:571`.
Two things are wrong regardless of where the reads go. Reads vanish
with no record, and the reported input count is the post-loss figure
rather than the true input, so the loss is invisible in the summary a
user reads. I did not chase the root cause further, since that is
outside this chapter's scope, but the read-conservation invariant is
broken.

**3. `fastq ont-fluidigm-samples` fails after completing its work, and
exits 0 while printing an error.** After reporting "ONT Fluidigm sample
split complete" at progress 1.0 and writing its manifest, the command
prints:

```
Error: Local provenance file descriptor must be added from a URL so
checksum and size are computed from disk: <output directory>
```

The shell exit status is nevertheless 0. Reproduced twice with a fresh
output directory each time. A script checking the exit status would
treat a failed run as a success, and a user sees an error after being
told the operation completed. The zero-sample outcome is expected for
this fixture, but the provenance failure is not about the sample count.
The chapter documents the operation's behaviour without quoting this
error, since it is a defect rather than something the reader should
learn to expect.

## Lint status, and a rule collision the campaign needs to settle

Final lint result:

```
108:1-108:512 warning colon inside a sentence...
110:1-110:461 warning colon inside a sentence...
⚠ 2 warnings
```

These two warnings cannot be cleared from inside the chapter. They are
a direct collision between two lint rules, and this chapter is the
first in the campaign to document a control whose registry label ends
in a colon.

`settings-coverage.js` requires a settings paragraph to begin with the
registry label verbatim, with the period inside the bold, so
`import.ont-run`'s `Barcode Sheet:` must be written `**Barcode Sheet:.**`.
`sentence-colon.js` then counts that label's colon as a prose colon and
warns, because it counts every colon in a paragraph's `proseText` and
allows one only when the paragraph ends with it immediately before a
list, table, or code block. A settings paragraph starts with its label
and continues, so it can never end with the colon.

I tested every option available to me. Dropping the colon clears
`sentence-colon` and trips `settings-coverage` with two warnings.
Keeping it does the reverse. Quoting the label in straight double
quotes, which is the convention STYLE.md gives for a label that
collides with the banned-words rule, trips both at once for four
warnings. Wrapping the colon in inline code cannot work, because
`proseText` returns an empty string for `inlineCode`, so
`settings-coverage` would no longer see the label at all. There is no
lint-disable mechanism.

I have left the label verbatim, which is the state that satisfies the
substantive fidelity requirement, and the two warnings are the
`sentence-colon` misfire on UI-label punctuation.

This is not a one-chapter problem. `parameters.yaml` carries more than
twenty labels ending in a colon (`Threads:`, `Secondary alignments:`,
`Supplementary:`, `Min mapping quality:` across four mapper entries,
`Confidence:`, `Min hit groups:`, and others), and
`reviews/fidelity-2026-09/live-spot-check.md:45` records that the
trailing colons were added to the registry deliberately to match the
UI. Every chapter documenting a mapper or classifier will hit this.

The fix belongs to a role that owns the rules or the registry, not to
the chapter author. The smallest one is to exempt a paragraph's leading
bold label from `sentence-colon`, which preserves both the verbatim
label and the ban on genuine prose colons. Flagging it here so the
Documentation Lead can settle it once for the whole campaign rather
than twenty times.
