# Editor pass: 03-reads/04-trimming-and-filtering

Date: 2026-09-07
Role: brand-copy-editor
Chapter: `docs/user-manual/chapters/03-reads/04-trimming-and-filtering.md`

Inputs were `fidelity.md` (98 true, 1 false, 2 unverifiable), `readers.md`
(the merged four-reader synthesis, 90 rows, 12 hit by three or more
readers), `CONSISTENCY.md`, and `docs/user-manual/STYLE.md`. The chapter was
lint-green before this pass and is lint-green after it.

Section order is unchanged. All 26 registry settings keep their bold labels
verbatim, in the original order, under the six original H3 headings. No
other chapter and no `GLOSSARY.md` entry was touched.

## Changes from the fidelity report

**FASTA input, the one false row (fidelity row 53).** The claim that every
operation in the category accepts FASTA was replaced with the corrected
count. The section now says four of the six accept FASTA and names them
(Adapter Removal, Primer Trimming, Trim Fixed Bases, Filter by Read
Length), and says the two fastp quality operations do not because a FASTA
file has no quality scores to read. This also absorbs fidelity row 55,
which noted the old closing sentence understated the set by naming only the
length filter and the fixed trim.

While correcting that row I read `FASTQOperationDialogState.swift:1763-1775`
and `2196-2208` to answer reader row 66, which asked what the pane actually
does with the quality operations on FASTA input. `visibleToolIDs(for:)`
filters the list by `supportsFASTA`, so the two are removed from the
left-hand list rather than greyed out or failed at run time. The chapter now
says so, and says the list holds four operations rather than six.

**Fixed-base trimming attribution (fidelity unverifiable row, ruling 2).**
Left as it stands, per the project manager's ruling that the CLI declares
fastp as the native tool for `fastq fixed-trim`. The program table in What
it is still pairs fastp with fixed-base trimming.

**Primer figures 45,410 and 15,046 (fidelity row 112, ruling 4).** Not
added. Verified absent from the finished chapter.

**Unlinked glossary anchors (fidelity, Notes for the editor).** The two
declared-but-unlinked anchors, `read-length` and `primer-trim`, now have
links at natural first mentions rather than being dropped from
`glossary_refs`.

## Changes from the reader report

### Rows hit by three or more readers (all twelve addressed)

**Row 7, the six operations never listed together.** What it is now names
all six in the sentence that introduces them.

**Row 8, Cut Front and Cut Tail unexplained, Cut Right's name conflicts
with its behavior.** The **Mode.** entry keeps its three-sentence shape.
A short paragraph and a four-row table follow it, describing all four
options and stating that the names describe where the cut lands rather than
where the scan starts, which is why Cut Right walks from the start.

**Row 9, IUPAC ambiguity codes never glossed.** Glossed at first use, under
**Adapter Sequence.** in the fastp section, naming N, R, and Y, and saying
the same codes are accepted wherever the chapter names them again.

**Row 10, the trimmed bundle's sidebar name never given.** Step 1 of the
length filter now says the run added a new sidebar item beside the original,
that the new one is named for the operation that made it (`fastpTrim`), and
that it sits under the `Analyses` folder rather than beside the imported
reads. The stem is `operationKindString` for the derivative request
(`FASTQDerivativeServiceModels.swift:194`), reached through
`FASTQOperationPlanner.outputNameStem`.

**Row 11, "viral by design".** Rewritten to separate the feature from the
bundled content. The operation has no organism restriction and trims human
amplicon primers exactly as viral ones. What is viral is the set of
ready-made schemes LGE ships, and for a human panel you supply your own
sequence or FASTA.

**Row 12, the one-base read reads as a bug.** The table cell now reads
"1 bp (expected, and kept)", and the paragraph below opens by saying a
one-base read is not a bug and not a typo before explaining it.

**Row 13, 677 spelled out in words.** Now the digit form.

**Row 14, two percentages against two denominators in one sentence.** Split
into three sentences, each naming its denominator, with a closing sentence
saying which figure to quote when.

**Row 15, whether the reader's own run reproduces the numbers.** The
Procedure lead-in now states that the operations are deterministic, that
the same file reproduces the counts exactly, and that a differing count
means a different file or setting rather than a mis-click.

**Row 16, the Required Setup pack.** Before you start now says LGE installs
it by itself the first time it needs it, that the reader does not install
it, and that it can be confirmed in **Tools > Plugin Manager...**
(Cmd-Shift-B) under the heading Required Setup. The menu path and shortcut
come from `CONSISTENCY.md:32-33`.

**Row 17, one-in-32 does not follow from one-in-a-hundred.** The scale is
now stated once, in a paragraph after the fastp **Threshold.** entry, as
"each step of ten means ten times fewer expected errors", with 10, 20, and
30 anchored and 15 placed between them. The When a trim goes wrong entry
now refers back to that scale instead of asserting the figure cold.

**Row 18, Window Size 4 to 1 appears to contradict the default.** A
paragraph now says a window of 1 is a diagnostic setting rather than the
normal recommendation, and describes the two chart shapes that pick between
them (steady decline toward the read end wants 4, isolated downward spikes
on an otherwise flat chart want 1), ending with an instruction to set it
back.

### Other reader rows fixed (a sentence or two each)

What it is: adapter explained before the term is attached to it (row 19);
"baggage" replaced with "unwanted sequence" (row 40); the program roles put
in a table (row 41); mapping glossed at first use (row 46); short reads and
long reads introduced early (row 47); primer scheme and amplicon glossed
(row 48); fragment covered by the rewritten library-prep sentence (row 49);
library preparation glossed (row 50); "grip" replaced with sticking to the
flow cell (row 51); "oligonucleotides" replaced with "short synthetic pieces
of DNA" (row 52); "artefact" glossed inline (row 53); the bundle stated to
be a real Finder-visible folder with the menu item to open it (row 54);
placement on a genome glossed via the mapping gloss (row 55); BAM glossed at
first use (row 33); `.lungfishref` glossed with a cross-reference to the File Formats appendix
(row 45).

Why you would do this: variant caller glossed (row 20); HG002 explained
(row 21); the "or worse" sentence split in two (row 56).

Before you start: "fixtures" replaced with "practice data files" (row 57);
both files stated as needed with one line on downloading them (row 44);
the Docker and optional-pack sentence replaced with a plain statement that
nothing else needs installing (row 58).

Procedure: "the fixture's R1 file" replaced with "the R1 file you
downloaded" (row 59); the readiness-line paragraph moved above the numbered
steps as prose (row 22); a worked folder name
`Analyses/fastpTrim-2026-09-06T14-32-08/` shown with the angle brackets
called out as a placeholder (row 23), the timestamp format taken from
`AnalysesFolder.swift:597-601`; step 3 pointed at Settings for other data
(rows 60, 62); the shared window named as shared and differently titled
(rows 61, 63); "Ready to configure output." stated to mean the pane is ready
(row 42); the UMI definition split into its own sentence (row 24); 0 versus
an empty field settled for Trim Fixed Bases (row 64); the justification for
Min Length 50 added to the step itself (row 31); the dense position-beats-
sequence sentence split in two (row 25); the Extra arguments field explained
as a design choice (row 65); the FASTA subtitle located under the window
title (row 67).

Settings: a lead-in saying the trailing command-line sentences can be
skipped (row 69) and that Output Strategy is identical in all six (row 26,
with the five repeats now pointing back to the first entry rather than
restating it); "base caller" used consistently and glossed in What it is so
it no longer collides with "the instrument" (row 68); the single-selection
case and the Grouped Result risk stated (row 70); Primer Source rephrased to
the standard "On the command line this is" shape (row 71) with the
two-programs fact given its own sentence (row 72); k written as "k-mer"
throughout rather than alternating with "word" (row 73) and its specificity
anchored to about a billion possible fifteen-base k-mers, with a note that
it does not depend on genome size (row 74); the k default mismatch stated as
by design with the dialog default named as the one to use in the window
(row 28); Hamming distance glossed as counting differing positions (row 75);
mink named as short for minimum k (row 76), given both directions to move
(row 78), and told to stay independent of k (row 77); hdist told plainly to
stay at 1 for Illumina with "noisy" glossed as a per-base error rate of
several percent (row 29); "bounds" replaced with "trim amounts" in the fixed
trim so it no longer collides with the length filter's bounds (row 36);
adapter dimer glossed (row 79); the shotgun case given before the amplicon
case in Min Length (row 80); concatemer and chimaera glossed (row 81); the
unpaired-mate consequence stated along with its effect on mapping (row 30).

Reading the results: sparkline glossed (row 34) and the specific cards and
charts this chapter uses named (row 82); the division shown once (row 84);
precision matched at 7.0 percent (row 83); the gap given as 6.9 percentage
points (row 85); the misleading "kept ... but only" replaced with an
explicit statement that both figures fell (row 86); the 1.59 million bases
given as 15.1 percent of what the Q20 trim had left (row 87); **Copy CLI
Command** named as the context-menu item that matters (row 39,
`OperationsPanelController.swift:1517`); the provenance folder reached
without a terminal via the sidebar's **Show in Finder**
(`SidebarViewController+MenuDelegate.swift:312`), covering rows 37 and 88.

What good looks like: the four checks numbered and labelled (row 32); the
QC re-run stated to be required because the summary does not refresh itself
(row 38); the survival range corrected from "90 to 99 percent" to "90
percent or more" so the 99.91 percent example falls inside it (row 89); the
input base count made actionable by naming the Bases card and saying to
select each bundle in turn (row 90); Q20 tied explicitly to the Threshold of
20 (row 91); chart names given exactly as they appear on screen and
introduced as "the chart labelled" (row 92).

On the command line: the section opened with a plain statement that a reader
who has never used a terminal can skip all of it, including the trailing
command-line sentences in Settings (rows 43, 97); the backslash explained as
formatting rather than something typed (row 35); the primer example marked
as illustrative and safe to run but not a result worth keeping (rows 93,
95); linked mode glossed at first mention (row 96); `--error-rate` 0.12
explained as a fraction of the primer's own length, with a worked example on
a 25-base primer (row 94).

## Style and consistency changes

Verified against `STYLE.md` and `CONSISTENCY.md`. No em dashes, no
semicolons, no colons inside a sentence. "Lungfish Genome Explorer" at first
mention then "LGE". No banned word from `ai-tells-words.txt` introduced.
Every new list is within the five-item cap, and the two new tables (the
program roles table in What it is, the Mode options table in Settings) are
tables rather than lists precisely because the bullet caps would otherwise
bind. Menu paths keep the bold, greater-than, ellipsis form.

Two frontmatter fields changed. `glossary_refs` gained the nine terms newly
linked from the body (`basecaller`, `library-prep`, `shotgun`,
`primer-scheme`, `bam`, `mapping`, `variant-caller`, `sparkline`,
`required-setup-pack`), all of which resolve to existing `{#anchor}`
headings in `GLOSSARY.md`. `estimated_reading_min` went from 14 to 30, since
the body grew to 7,219 words and the neighbouring chapter
`03-quality-control.md` sets the manual's convention at roughly 237 words
per minute.

`brand_reviewed` flipped to `true`. `lead_approved` untouched.

## Left unchanged, deliberately

**The fastp attribution for fixed-base trimming.** Ruling 2 settles it. Left
as written.

**Section order, and the count and placement of the settings paragraphs.**
Ruling 3 forbids changes here, and the persona forbids structural edits in
any case. Every reader row whose only fix would have been structural was
handled inside the existing section instead. Row 22 is the clearest case.
Readers wanted the readiness-line paragraph made into its own numbered step,
but the combined-trim list already holds five items and the Procedure H2
already holds two lists, so a sixth step or a third list would break
`bullet-cap.js`. The paragraph moved above the numbered list as prose
instead, which achieves the same ordering.

**The primer figures 45,410 and 15,046.** Ruling 4. Neither appears.

**Reader row 43's second half, keeping CLI content out of Settings
entries.** The consistency sheet requires the command-line flag sentence in
every settings entry (`CONSISTENCY.md:70-72`), so removing it would break
the manual-wide shape. The reader's underlying complaint was addressed by
telling them once, at the top of Settings, that those sentences are
skippable.

## For the project manager to rule on

**The exact sidebar name of the trimmed bundle.** I stated `fastpTrim`,
derived from `operationKindString` at
`FASTQDerivativeServiceModels.swift:194` flowing into
`FASTQOperationPlanner.outputNameStem` and then
`FASTQOperationOutputImporter.uniqueBundleURL(named:)`. I did not run the
app to confirm what the sidebar renders, and the persona forbids me from
building. A live check would confirm it, and if the sidebar shows something
else the sentence in step 1 of the length filter needs the real string.

**The worked folder name `Analyses/fastpTrim-2026-09-06T14-32-08/`.** The
timestamp format is verified (`AnalysesFolder.swift:597-601`,
`yyyy-MM-dd'T'HH-mm-ss`) and the tool half comes from the same
`outputNameStem`. The specific date and time are illustrative. If the
campaign prefers worked examples to come only from a recorded run, this one
should be replaced with a captured folder name.

**The unpaired-mate claim about mapping.** I wrote that a bundle holding
reads whose mate was filtered away still maps, and that the mapper places
the survivor without the mate's positional evidence. That is standard
short-read behaviour rather than something I verified in LGE's own mapping
path, and reader row 30 asked for it explicitly. Worth a check by whoever
owns the alignments chapters.

## Lint

Command:

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/04-trimming-and-filtering.md

Output, verbatim:

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/04-trimming-and-filtering.md: no issues found

## Status

brand_reviewed: true
