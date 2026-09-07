# Editor pass: 04-alignments/01-mapping-reads-to-a-reference

Editor: brand-copy-editor. Date: 2026-09-07.
Lint: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`.

Inputs read in full. `fidelity.md` (81 true, 4 false, 1 unverifiable),
`readers.md` (79 rows, 27 hit by three or more readers), `author.md`,
`docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
`docs/user-manual/STYLE.md`, and the Campaign rules block of
`.claude/agents/brand-copy-editor.md`.

Section order is unchanged. All fourteen Settings paragraphs remain, in
order, with their bold labels verbatim including the four colon-terminated
ones. No other chapter and no `GLOSSARY.md` entry was touched.

## Changes from fidelity rows

**Fidelity false, row 43. The Analyses timestamp shape.** Procedure, closing
paragraph. `Analyses/minimap2-20260906-134512/` became
`Analyses/minimap2-2026-09-06T13-45-12/`, the `{tool}-{yyyy-MM-dd'T'HH-mm-ss}`
shape ruling 1 fixes. The sentence now also says the folder is named for the
mapper followed by the date and time the run started, and reads the example
back as 13:45:12 on 6 September 2026, which closes reader row 30 in the same
edit.

**Fidelity false, row 71. Flag Stats is titled Flag Statistics.** Four sites,
per ruling 1. The frontmatter caption for `alignment-inspector-stats`, the
body sentence introducing the disclosure, the table header cell ("Flag
Statistics category"), and the What good looks like check that names the
total. No occurrence of "Flag Stats" remains in the chapter.

**Fidelity false, row 103. The shot caption.** Same rename, applied in the
frontmatter `shots[]` entry rather than in the body.

**Fidelity false, row 63. CRAM import.** Importing an alignment somebody else
made. "A CRAM is converted on the way in, and a SAM is normalised to a
sorted, indexed BAM" became "A CRAM stays a CRAM, sorted and indexed in place
with a `.crai` index beside it, and only a SAM is normalised to a sorted,
indexed BAM," per ruling 1 and the reviewer's corrected wording.

**Fidelity unverifiable, row 101. Identical methods.** Last paragraph of On
the command line. The claim that the two routes "record identical methods" is
dropped, per ruling 2. The sentence now reads "Both routes write a provenance
sidecar, recording the command that ran, the version of each tool it called,
and checksums of the files involved." I confirmed the checksum claim against
`ManagedMappingPipeline.swift:1069` and `MappingProvenance.swift:809` before
writing it, so nothing unsourced replaced the dropped claim.

## Changes from reader rows hit by three or more readers

Twenty-seven consensus rows, all addressed.

**Row 7, MAPQ unnamed at first mention.** What it is, first paragraph. The
score is now "a confidence score called [MAPQ]" with the glossary link at
that first mention rather than only in Settings.

**Row 8, "changes the answers a little" has no size.** What it is, second
paragraph. Added the size and the forward pointer, that the four mappers land
within one percentage point of each other on the worked example and that the
comparison table under Reading the results shows how far apart they sit.

**Row 9, the `.bai` index's ownership.** What it is, third paragraph. Split
into a plain statement that LGE writes the index and keeps it next to the BAM
inside the project, so the reader never creates, opens, or moves it.

**Row 10, read pairs versus read count.** Why you would do this, third
paragraph. A read pair is now defined at first use as two reads sequenced
from the two ends of one DNA fragment, with the 45,574 to 91,148 doubling
spelled out.

**Row 11, "kb" unexpanded.** Same paragraph. "a 500 kb window of chromosome
20, where kb means kilobases, so the window is 500,000 bases long."

**Row 12, the three mappers unnamed.** Before you start. "Three of the four
mappers, minimap2, BWA-MEM2, and Bowtie2, arrive in the `read-mapping` plugin
pack."

**Row 13, Docker Desktop.** Before you start. The mention is cut entirely,
which is the row's first suggested fix. Nothing in the chapter needs Docker,
and the consistency sheet's fixed Docker sentence is reserved for pipelines
that actually require it.

**Row 14, which records the filter drops.** Procedure, pipeline paragraph.
Added that the dropped records are the ones the Advanced Settings the reader
chose exclude, and that with the defaults that means secondary alignments.

**Row 15, the pathogen example arriving with no setup.** What good looks like,
first check. Reordered so the wrong-reference and preset-mismatch causes come
first, then a sentence of setup introduces the multi-organism case before the
swab example appears.

**Row 16, classification named but not linked.** Same check. Now links to
[What Is Read Classification](../06-classification/01-what-is-classification.md).
I verified that chapter's title from its own frontmatter rather than guessing
it.

**Row 17, no way to check a truncated download.** What good looks like, fourth
check. Added that a truncated file opens and looks complete but stops short
with no error, and that the reader can compare file size against the download
page or simply download and re-import the pair.

**Row 18, "the file names" misparsed.** Importing an alignment somebody else
made. Reworded to "which reference assembly the file's own header declares,"
the row's own suggested phrasing, so "names" no longer appears as a verb that
reads as a noun.

**Row 19, records versus reads.** Reading the results, first paragraph. The
distinction is now made at the first appearance of "records" rather than only
in the Flag Statistics paragraph, with a pointer down to where the fixture's
numbers settle it.

**Row 20, the 99.19% denominator.** Reading the results, interpretation
paragraph. "Out of the 91,148 paired reads that is 99.19%."

**Row 21, the MAPQ cutoff across mappers.** Four mappers section, closing
paragraph. Added that the scaling is why a Min mapping quality cutoff does
not mean the same thing across the four, and that 20 is a mild filter under
minimap2 or BWA-MEM2 and harsher under Bowtie2 or BBMap.

**Row 22, the example project path.** On the command line. Added that the
reader replaces the project path in the second command with their own, and
that the path shown is the demo project this manual builds and is not created
anywhere in this chapter.

**Row 23, the 60 ceiling stated for only two mappers.** Settings, Min mapping
quality. Now says the stepper accepts 0 to 60 whichever mapper you chose, and
that 60 is reached in practice only by minimap2 and BWA-MEM2 while Bowtie2
and BBMap scale lower.

**Row 24, the raw secondary-alignment flags.** Settings, Secondary
alignments. The paragraph now says LGE sets the right option for whichever
mapper you chose and records it in provenance, so there is nothing to type.
The `-k 10` and `secondary=t` values themselves are kept, moved down to the
placeholder-text paragraph where they read as reference rather than as an
instruction, since they are fidelity-verified (row 55) and cover a DRIFT
Missing item the author deliberately included.

**Row 25 and row 65, the Platform conditional.** Settings, Platform. Split
into two sentences. Correcting it is one sentence, and the rewrite rule is
another, ending "so anything you typed in yourself is left alone."

**Row 26, the thread default.** Settings, Threads. Now leads with the fact
that the wizard already fills in the right number for the reader's own Mac
and the stepper will not let them exceed it, so there is nothing to look up.
The "14 threads on a 14-core machine" aside is dropped as the thing that
prompted the lookup.

**Row 27, the Supplementary polarity.** Settings, Supplementary. Stated once,
plainly, in one clause. "Ticked keeps those supplementary alignments and
unticked drops them, and the box is ticked by default." The inverse flag is
explained at the end rather than as a mid-paragraph aside.

**Row 28, no coverage target figure.** Reading the results, second paragraph.
"inside the 30x to 50x band a human genome project usually aims for."

**Row 29, the dropped depth unit.** Same paragraph. "A region under 10x."

**Row 34, depth versus breadth.** Same paragraph. Depth is now defined at its
first mention as the number of reads covering a single position, contrasted
in the same sentence against breadth, which counts how many positions carry
any read at all.

**Row 35, where the sidecar lives.** What good looks like, provenance
paragraph. The sidecar is named (`mapping-provenance.json`), located (the
run's folder under `Analyses/`), and opened (a text editor).

**Row 48, whether the guess persists.** Procedure, step 4. "your choice
stands for the rest of this wizard session no matter what else you touch."

**Row 50, the Median MAPQ column.** Four mappers section, lead-in. One line
before the table defines median MAPQ as the middle confidence score of all
placed reads, and names `mapping-result.json` as where a reader's own run
reports it.

## Changes from other reader rows fixable in a sentence or two

**Row 30, the folder-naming pattern.** Folded into the fidelity row 43 fix
above.

**Row 31, preset names unglossed.** Settings, Preset. Took the row's
alternative fix and stated that only Short-read applies to Illumina data,
rather than glossing CDS and cDNA inside a paragraph already at its length
limit.

**Row 32, the Run Mode explanation.** Settings, Run Mode. Split the
command-line-flag explanation into two sentences and moved the tube example
forward so it arrives with the warning rather than after it.

**Row 33, the Read Group lead-in.** Marked the five entries as reference
material to read only when a downstream tool asks for a specific value.

**Row 36, `--paired` and `--mapper` unexplained.** On the command line. A new
paragraph before the code block says both flags have no counterpart in the
window and why.

**Row 37, UUID unexpanded.** On the command line, adoption paragraph. "a
randomly generated identifier long enough that no two runs produce the same
one."

**Row 38, whether the multi-bundle note applies.** Procedure. "Skip the next
paragraph if you selected only one read bundle, which is what the steps below
assume."

**Row 39, primary mapped versus Total Mapped.** Reading the results,
interpretation paragraph. The 55-record difference is now reconciled
explicitly against the Inspector's 90,990.

**Row 40, Preset versus Mode.** Procedure, opening paragraph. "you will see
one name or the other on your own screen, never both."

**Row 41, what a read is, and "a pile".** What it is, first paragraph. "a
pile of sequencing reads" became "a collection of sequencing reads," and a
read is defined at first use.

**Row 42, why a repeat is ambiguous.** Why you would do this, first
paragraph. Repeat is glossed and the ambiguity stated, that identical copies
give the mapper no way to choose between them.

**Row 43 (reader), plugin pack installation.** Before you start. Added that
installing downloads the three programs and needs an internet connection, and
that the Plugin Manager shows progress. No duration is given, since none is
sourced.

**Row 44, GitHub account.** Before you start. "No GitHub account is needed to
download them."

**Row 45, spaces in the ID field.** Settings, ID. The reason is stated, that
the BAM header format uses whitespace to separate fields. I did not state
whether the field rejects or strips a typed space, because neither behaviour
is established in the fidelity review or the registry.

**Row 46 and row 47, the footer and what a parse error looks like.** Settings,
Extra arguments. The footer is located as the strip along the bottom edge of
the sheet, and the error is described as an orange message, matching
`MappingWizardSheet.swift:783-785` as the fidelity review records it.

**Row 49, how Est. Coverage is calculated.** Reading the results, first
paragraph. "worked out as the total mapped bases divided by the length of the
reference."

**Row 51, duplicate marking.** Settings, Library. Glossed at first use as the
later step that flags reads which are copies of one original fragment rather
than independent evidence.

**Row 52, the two-part choice ordered after its warning.** What it is, fourth
paragraph. The two steps now come first and the warning last.

**Row 53, "read bundle" unglossed.** Procedure. "A read bundle is the sidebar
item holding one sample's imported reads."

**Row 54, SAM unexplained.** Procedure, pipeline paragraph. "a SAM file,
which is the plain-text form of a BAM holding the same rows uncompressed."

**Row 55, fixture unglossed.** Before you start. "which is a fixture, the
sample data set this manual works its examples against."

**Row 56, the `.lungfishref` folder.** Before you start. "The Finder shows
that folder as a single item rather than something you open, which is normal
on a Mac."

**Row 57, five sections but three steps.** Procedure, opening paragraph. Read
Group and Advanced Settings are called optional, and the paragraph says the
numbered steps touch only three of the five sections.

**Row 58, what a good readout looks like.** Procedure, step 5. "A good
reading ends in a line beginning with the word Ready," placed before the
instruction to click Run.

**Row 59, what a failed step looks like.** Procedure, closing paragraph. "A
step that fails turns red instead and stops the run, leaving its error text
in the expanded row."

**Row 60, the Reference default.** Settings, Reference. Kept the registry's
wording, "the first reference the app finds in the project," and added that
the reader should read the path the wizard prints under the picker to confirm
the choice before running. I drafted a more specific ordering rule and
reverted it after checking `parameters.yaml`, which does not establish one.

**Row 61, long-read noise.** Settings, Preset. "Long-read machines trade
accuracy for length."

**Row 62, the single-option picker.** Settings, Mode. "a picker holding one
option is expected rather than a sign that anything failed to load."

**Row 63 (reader), automatic read groups in a merged run.** Settings, Run
Mode. Added that the automatic per-bundle read groups apply only to separate
runs.

**Row 64, joint variant callers.** Read Group lead-in. Glossed as callers
that examine several samples at once instead of one at a time.

**Row 66, what MAPQ 60 means.** Settings, Min mapping quality. "60 means it
found one clearly best location," alongside the existing gloss of 0.

**Row 67, the symptom of repeat-driven mismapping.** Same paragraph. "a pile
of low-MAPQ reads over one spot carrying variants that no neighbouring region
supports."

**Row 69, the flag in the heading.** Read Group lead-in. "The bracketed flag
in each label is the command-line name of that field, not something you type
into the window." The labels themselves are unchanged, per ruling 3.

**Row 70, where the Platform value is visible.** Settings, Platform. "The
value shows in this field while the wizard is open, and after the run it
lives only inside the BAM header."

**Row 71, the two 99.77% figures.** Reading the results. Both figures are
correct and the fidelity review verified each separately, so nothing was
recomputed. The text now shows both fractions, 90,935 of 91,148 and 90,990 of
91,203, and says they agree to two decimal places without being the same
fraction.

**Row 72, where Bowtie2's unmapped records sit.** Four mappers lead-in. "The
Records column counts every record the mapper wrote, unmapped ones included,
which is why Bowtie2's 91,148 records still contains 907 reads it could not
place."

**Row 73, whether the Settings flags are optional.** On the command line,
opening paragraph. "The command-line flags named in the Settings section are
there for reference too, so you never have to type one to use the wizard."

**Row 74, flag bits.** Reading the results, Flag Statistics paragraph. "a
small set of yes-or-no markers each record carries."

**Row 75, "parses".** Settings, Extra arguments. "LGE checks the text on
every keystroke."

**Row 76, the token table's placement.** On the command line. The
`--preset` translation table moved from after the code block to before it,
with its lead-in adjusted to say it pairs the labels before the commands that
need them.

**Row 77, the runtime figure.** On the command line. Kept the sourced 4.8
second figure, since it is what the CLI printed on a real run and the
fidelity review verified it, but named the machine it came from and added
that runtime rises with read count and reference size. This is a measured
observation, not a duration promise.

**Rows 78 and 79, the bundle-versus-FASTA idiom.** On the command line, `map`
details. Now opens "so pass the FASTA," then explains when a bundle path
works and what to do when it is rejected.

**Row 80, whether both commands are required.** On the command line. "takes
two commands rather than one, and both are required."

**Row 81, contig undefined.** On the command line, after the preset table.
"one continuous stretch of sequence built by joining overlapping reads
together."

**Row 82, how to open `mapping-result.json`.** Reading the results. "right-
click the alignment track in the sidebar, choose Show in Finder, and read the
file in any text editor." I checked
`SidebarViewController+MenuDelegate.swift:310-315` and confirmed Show in
Finder is on the sidebar context menu for any non-group item before writing
this, and pointed the reader at the track rather than the folder because the
run folder is not itself a sidebar item.

**Row 83, what a pairing failure looks like.** What good looks like, fourth
check. "a red row in the Operations panel, and expanding it prints the
failure text."

**Rows 84 and 85, soft-clip unexplained.** What good looks like, provenance
paragraph. "A soft clip is an end of a read the mapper left unaligned while
placing the rest, so moving its boundary shifts where the alignment is judged
to start or stop."

## Changes from consistency and style

The chapter already opened with "Lungfish Genome Explorer (LGE)" and used
"LGE" after, and my edits kept that. No em dash, semicolon, or in-sentence
colon was introduced. The colons the file still contains are the quoted
Input Compatibility output, the four `<!-- SHOT -->` markers, and the
code-font Operations row label `Map Reads (minimap2): HG002.chr20.10.0-10.5Mb`,
which is verbatim UI text.

I checked the Advanced Settings paragraph's new material against the
`ai-tells-words.txt` list before writing it. No banned word appears in any
inflection, and no list in the chapter exceeds five bullets or two lists per
H2.

## Left unchanged, deliberately

**Reader row 68, the "Threads:." and "Secondary alignments:." punctuation.**
The reader called the colon plus period a typo. Ruling 3 says the
colon-terminated labels stay verbatim, and the fidelity review confirms the
on-screen labels carry those colons (`MappingWizardSheet.swift:727`, `:741`,
`:751`, `:759`), while "Extra arguments" correctly has none. The shape is
the Settings template's period-inside-the-bold applied to a label that
already ends in a colon. Left as is.

**Reader row 31's first fix, glossing CDS and cDNA.** Taking the row's
alternative instead. Both terms belong to a preset this chapter's reader will
never select, and glossing them would push the Preset paragraph past its
three-sentence shape for no gain to an Illumina reader.

**Reader row 45's second half, what happens if you type a space into ID.**
Neither the fidelity review nor `parameters.yaml` establishes whether the
field rejects the space, strips it, or accepts it and writes a malformed
header. I stated only the sourced reason spaces are disallowed. Worth a
source read by whoever next touches the mapping wizard.

**Author-flagged app defect, the CLI's "Total reads" label.** Confirmed by
the fidelity review as a real labeling defect that reaches the user. The
chapter still works around it by explaining the arithmetic rather than
claiming the label is right. Not an editorial fix, and out of my authority.

## Items for the project manager

One. Reader row 45's second half is unanswerable from the sources available
to this pass, so the ID paragraph explains why spaces are disallowed without
saying what the field does when a reader types one. If that behaviour matters,
it needs a source read rather than an editorial guess.

## Verbatim lint output

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/04-alignments/01-mapping-reads-to-a-reference.md: no issues found
```

## Status

brand_reviewed: true
