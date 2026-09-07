# Editor pass, chapter 37, 06-classification/06-blast-verification

Brand copy editor, 2026-09-07. Worktree `user-manual-fidelity-campaign`.
Inputs were `author.md`, `fidelity.md` (58 true, 3 false, 0 unverifiable),
`readers.md` (99 rows, 21 of them consensus), `parameters.yaml` entry
`classify.blast-verify`, and the committed chapters 02 and 03 as style
references. Source checks were read-only against `Sources/`.

Lint result, after one fix described at the end.

    docs/user-manual/chapters/06-classification/06-blast-verification.md: no issues found

## The three false rows

**Claim 43, the kreport taxid column.** Changed "sixth column" to "seventh
tab-separated column" in `## On the command line`. Went further than the
one-word fix the reviewer suggested, because reader row 39 says three readers
had never opened a kreport and could not count columns from prose. The chapter
now names the eight fields in order for the fixture's own kreport and says
plainly that `S1` is the sixth field and `2697049` is the seventh, so the
reader can check their own file against a worked case.

**Claim 44, Copy Taxon ID.** Removed. The taxonomy viewport has no such menu
item, and the chapter now points at the Tax ID column of the taxonomy table,
adding that it is turned on the same way as a drawer column, since Tax ID is
one of the five hidden drawer columns and a reader meeting the name twice
should not think they are the same control. Reader row 39's suggestion to
"lead with the Copy Taxon ID route for interface users" is deliberately not
applied, because the route does not exist. This is the row where the reader
report and the source disagree, and the source wins.

**Claim 58, the NVD confidence word.** Rewritten using the reviewer's wording.
The Novel Virus Diagnostics paragraph keeps its first sentence about
submitting the contig's own sequence, which is correct, and now says the
drawer still carries a confidence word. The missing word moved to a new
paragraph about the 12S viewport alone, which also absorbs reader row 42's
request to gloss 12S metabarcoding. The plain heading is quoted as
`BLAST results for <name>`.

## The 21 consensus rows

All 21 applied.

1. **Four columns, five names.** Now "Five more columns are hidden", listing
   Accession, Coverage, Align Length, Tax ID, and Verdict in one series. Tax ID
   is no longer set apart by "along with".
2. **K-mer.** Named and sized at first use in `## What it is`, as a fixed-length
   window of sequence, usually around 31 bases in a classifier database.
3. **What BLAST usually answers.** Stated as a baseline before the narrower
   question, which is a ranked list of every resembling record with the
   interpretation left to the reader.
4. **The Mixed boundary.** Replaced with the ruling's table. Boundaries are
   written as "80 percent and above", "40 percent up to but not including 80",
   "below 40 percent", and the no-good-match case.
5. **Relatives satisfying the check for each other.** Replaced with a plain
   statement that a read from one organism can match a close relative well
   enough to count as supporting.
6. **SRA download size.** 21.7 MB compressed, sourced from the fixture README
   per the ruling. No time given, only that it depends on the connection.
7. **Viewport.** Glossed at first use in `## Before you start` as the panel that
   fills the LGE window and displays one result.
8. **What leaves the Mac.** See the privacy ruling below.
9. **Both outcomes.** Named directly as one finished run and one timeout, with
   the reassurance that a timeout is normal rather than a sign of breakage.
10. **The popover title placeholder.** Shown filled in for the worked example
    rather than as `<taxon>`.
11. **Waiting duration.** See the waiting-time ruling below.
12. **The stray colon.** Kept, because it is verbatim from `parameters.yaml`
    and the app draws it. Handled the way chapters 02 and 03 handle it, with
    one short explanation at the top of `## Settings` saying the colon belongs
    to the label and the period closes the bold opening. This is the fix the
    style reference already uses, and it is why the row is answered rather
    than obeyed.
13. **The longest-versus-random split.** Stated as the longest reads first, up
    to five or a quarter of the sample, whichever is smaller, then the rest at
    random. Sourced at `BlastService.swift:363`,
    `mixed(longest: min(5, readCount / 4), random: ...)`. The declared default
    `mixed(longest: 5, random: 15)` at `BlastVerificationRequest.swift:227` is
    consistent with this at the default of 20 reads and is not quoted
    separately.
14. **One dot in the ten-dot bar.** Now says the bar always holds ten dots
    however many reads you sent, so each dot stands for a tenth of the sample
    rather than a fixed number of reads.
15. **The 99.6 percent arithmetic.** Now "disagreed at one of those 250
    positions".
16. **"the scale is brutal".** Removed. Replaced with the statement that the
    scale is logarithmic and each step in the exponent is a tenfold change.
17. **1e-30 written out.** "which is ten to the power of minus thirty", once,
    per the ruling.
18. **The three Verified thresholds.** Stated as at least 90 percent identity,
    at least 80 percent query coverage, and an e-value of `1e-10` or smaller.
    See the thresholds ruling below for sourcing.
19. **"small enough to be written in scientific notation".** Removed. Replaced
    with numbers in `## What good looks like`, which are 95 percent identity or
    better, coverage above 90 percent, and e-values at or below `1e-20`. These
    are stated as what a reliable verification looks like, deliberately
    stricter than the Verified rule's floor, and they are the author's own
    qualitative bar made numeric rather than a new source claim.
20. **Low-complexity and adapter-contaminated.** Both glossed inline where they
    appear.
21. **The two-of-three example versus the small-sample warning.** See the
    worked-example ruling below.

## The rulings

**Thresholds.** `BlastService.swift:75` `verifiedIdentityThreshold = 90.0` and
`:78` `verifiedCoverageThreshold = 80.0`, applied at `:929-931` together with
`eValue <= eValueThreshold`. The threshold is a request parameter whose default
is `1e-10` at `BlastVerificationRequest.swift:89`, so the chapter states it as
`1e-10` rather than as an unnamed threshold. The verdict bands are the ruling's
table. "Good match" is defined once, in `## What it is`, as a read that passed
the per-read Verified rule, with a forward pointer to where the three numbers
are given.

**The worked example.** Handled in `## What good looks like`, in its own
paragraph immediately after the Mixed-on-a-small-sample warning, so the two
reconcile rather than contradict. It says the default is 20, that the reference
run first submitted 5 and timed out at the ten-minute ceiling, that it then
submitted 2 so the page could show a completed job, that two reads demonstrate
the mechanics and are not evidence, and that the reader should leave the
default at 20 for real work. The earlier sentence reporting the two-read
Supported result is kept and now reads as a demonstration rather than a
recommendation.

**Timeout recovery.** One sentence at the head of `## On the command line`,
placed where a window-only reader will still see it because the section opens
with the skip line. It says recovery by request ID is a command-line and
browser route and that a window reader should resubmit from the popover. The
GUI timeout description in `## Before you start` says the result stays
collectable from NCBI's site, which is true for both readers, and does not
promise an in-app recovery.

**Waiting time.** No typical duration anywhere. `## Before you start` now gives
the poll cadence (10 seconds, then 15, then 30) and the ten-minute ceiling, and
says NCBI's queue sets the wait and it varies with how busy the service is.
Procedure step 5 repeats that the waiting phase has no expected length. Reader
rows 17 and 81, which both asked for a typical duration, are therefore answered
with a refusal rather than a number, which is the ruling.

**Privacy.** Confirmed in source before writing. `BlastService.swift:401` sends
`request.toMultiFASTA()`, and that method at
`BlastVerificationRequest.swift:114-116` emits only `>id` and the sequence for
each selected read. The chapter says LGE sends the sequence of each selected
read and the read's own identifier and nothing else, then names what is not
sent, which is the sample name, project, file, and any unselected part of the
sample. It adds that NCBI holds a submitted search and returns it to anyone
holding the tracking number, and that a sample under a data-use agreement or
carrying human reads should not be sent without checking that agreement. The
read identifier is called out explicitly because it is part of the payload and
a reader told only "the read sequences" would be told something slightly
untrue.

**SRA download size.** 21.7 MB compressed, no time.

**Idioms.** Viewport, action bar, k-mer, low-complexity, adapter-contaminated,
e-value with its logarithmic scale and the written-out `1e-30`, and bit score
are all glossed at first use. Bit score also gained a rough magnitude, which is
low hundreds for a full-length near-perfect 250 base read and under about 50
being weak.

**Disclosed defects.** Both kept, each in one sentence where the reader meets
it. The gzipped `--source` failure is in `## On the command line`, saying the
error names the wrong cause and to check the extension first, with `gunzip`
given. The NVD confidence word is now a correction rather than a defect
disclosure, since the app behaves correctly and the chapter was wrong.

## Other reader rows applied

Beyond the 21, these were applied because they needed no new fact.

Rows 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 40, 41, 43, 44, 45, 46, 49,
50, 52, 53, 54, 56, 57, 59, 60, 61, 62, 63, 66, 67, 68, 69, 70, 71, 72, 73,
74, 76, 77, 78, 79, 80, 82, 83, 84, 85, 86, 87, 91, 92, 93, 94, 96, 97, 98,
99, 100, 101, 103, 104, 105, 106, 107, 109, 110, 111, 112, 113, 114, 115, 116,
117, 118.

Seventy-four rows. The notable ones.

- Row 56 became the small table of viewport names and right-click items in
  `## Where else verification starts`, with one sentence up front saying the
  behaviour is identical and only the wording changes.
- Row 116 is the timeout-recovery ruling.
- Row 103 got its own short paragraph, as the reader asked.
- Row 96 is answered by saying the word carries the whole meaning so colour is
  never needed, which is better for the colourblind reader than naming
  colours.
- Rows 94 and 95 asked for colours alongside the shapes. Not applied. The dot
  colours are not stated in the source I read and I will not invent them. The
  shapes are described and the tint is mentioned without a mapping.
- Row 39's second clause is refused, as above.
- Row 51 says why the CLI cap is higher, which is that a scripted run can wait
  where a window cannot, and adds that the difference does not change how a
  result is read.
- Row 41 now says LGE waits rather than failing at the hourly ceiling, sourced
  at `BlastService.swift:1441-1443`, and separates that ceiling from the
  slider maximum.
- Row 107 explains the hidden Accession column as the one that also fills in on
  parent rows.
- Row 100 says the Status icon mirrors Verdict.
- Row 104 says Re-run BLAST reopens the popover.
- Row 88 says a sample below about ten reads swings too far on one read.

## Also applied from the fidelity notes

The reviewer's line 165 precision note on NAO-MGS is applied. The paragraph now
covers all three bands, including a taxon between 21 and 50 reads showing both
the 20-read item and the all-reads item, and it uses a real number in
**BLAST All 34 Reads** rather than the escaped placeholder that reader rows 117
and 1, 3 misread as literal backslashes.

## Not applied

Rows 94 and 95, the dot colours, for lack of a source.

Row 58, a rough read length below which BLAST settles nothing. No number in
source and none in the two recorded runs, so it stays qualitative.

Row 64's request for a concrete organism pair is answered with a rhinovirus
pair given explicitly as the shape of the error rather than as a measured
result from this fixture. If the gate considers that too close to invented
data, it is one clause to cut and the sentence stands without it.

Row 102's request for a good bit score is answered with a magnitude tied to a
250 base read, reasoned from the definition rather than measured. Flagging it
for the same reason.

## For the gate

Both front-matter flags are untouched and still read `brand_reviewed: false`
and `lead_approved: false`.

Two items route elsewhere, as the reviewer said, and neither is mine to edit.
DRIFT row 13 and the `classify.blast-verify` `notes` block in
`parameters.yaml` both need the Accession correction, since the hidden set is
five and not four, and `parameters.yaml` also needs the slider threshold
corrected from "fewer than two reads" to the `maxReads >= 2` behaviour. Ground
truth row 29 of `03-running-esviritu.md` can be marked true.

One possible app request, which is the missing Copy Taxon ID in the taxonomy
viewport's context menu. The reviewer notes the usability gap. The chapter now
sends the reader to the Tax ID column instead, which works, but the menu item
would be the better fix.

One possible app defect stands, which is the missing
`presentationStyle = .contigBlast` in `NvdResultViewController`. The chapter
describes what ships.

## Lint

One warning on the first pass. `ai-tells.js` flagged "two-finger tap" on the
column-header sentence, because `tap` is a list entry. Reworded to "which on a
trackpad means clicking it with two fingers", which keeps reader row 54's
trackpad guidance. Second pass clean.

    docs/user-manual/chapters/06-classification/06-blast-verification.md: no issues found

No em dashes, no semicolons, no in-sentence colons. Two tables, each the only
table in its section. No list exceeds five entries.

## Follow-up pass

Brand copy editor, 2026-09-07, same worktree. The first pass read an interim
`readers.md` with 21 consensus rows. The final `readers.md` carries 112 rows
and a `## Consensus` section of 44. This pass checks all 44 against the
chapter as it now stands, applies the gate rulings, and corrects the registry.

### The 44 consensus bullets

Forty-three were already addressed. The first pass applied its own 21 and a
further 74 non-consensus rows, and the 23 consensus bullets that were new to
the final merge had all been carried by those 74. Each is recorded below with
where the chapter answers it.

Addressed already, from the original 21.

1. Five more columns are hidden, all five named in one series.
2. K-mer named and sized at first use.
3. What BLAST usually returns stated as a baseline.
4. The confidence bands written as an explicit table.
5. The close-relative sentence written plainly.
6. SRA download given as 21.7 MB compressed.
7. Viewport glossed in `## Before you start`.
8. Both outcomes named as one finished run and one timeout.
9. The popover title shown filled in for the worked example.
10. No expected length given for the waiting phase, per the ruling.
11. The label colon explained once at the head of `## Settings`.
12. The longest-versus-random split stated with its proportion.
13. The ten-dot bar stated as ten dots whatever the read count.
14. The 99.6 percent arithmetic shown as one position in 250.
15. Low-complexity and adapter-contaminated both glossed inline.
16. The two-read example reconciled with the small-sample warning.
17. The e-value scale called logarithmic rather than brutal.
18. `1e-30` written out in the ten-to-the-power form.
19. The three Verified thresholds stated as numbers.
20. Scientific notation replaced by usable cutoffs.
21. The Mixed upper boundary resolved by the table.

Addressed already, new to the final merge.

22. Does not scale replaced by one taxon at a time in `## Why you would do this`.
23. Long tail glossed as the many taxa each carrying a handful of reads.
24. Action bar glossed as the strip of buttons under the results table.
25. The uncompressed FASTQ fix given as `gunzip`, with the misleading error named.
26. 12S metabarcoding glossed in its own paragraph.
27. The 50 versus 100 read gap explained by scripted runs being able to wait.
28. What leaves the Mac stated as the sequence and the read identifier only.
29. SRR36291587 introduced as a public sequencing run identifier at NCBI.
30. The Operations panel located at the toolbar's Operations button.
31. `nt` tied to the general nucleotide collection named earlier.
32. NAO-MGS identified as mapping reads to a reference genome.
33. `--extra-args` marked as command-line only where it is first cited.
34. Row expansion given as the disclosure triangle at the left of the row.
35. `## On the command line` opens by saying the section is optional.
36. The kreport's fields listed in order for the fixture, with the taxid seventh.
37. In flight replaced by running at the same time.
38. The hourly ceiling of fifty sequences separated from the slider maximum.
39. Contig glossed at first use, which is the merged table's suggested fix.
40. The classifier database placed in `## What it is` as installed on your machine.
41. The four viewport names introduced as the other classifiers, with a forward
    pointer to the section that gives each one's wording.
42. Request ID glossed as the tracking number NCBI assigns, before its first use.
43. A high conflicting count given as roughly a quarter of submitted reads or more.
44. The identity figure paired with coverage above 90 percent.

Applied this pass, from the 44: none. Every bullet was already answered.

Refused this pass, from the 44: none.

### Gate rulings applied

**The rhinovirus pair, cut.** `## Why you would do this` reasoned the error's
shape from a human and bovine rhinovirus pair that no run in this campaign
measured. The clause is now "Reads landing on a close relative's record rather
than the true source is the shape of the error", which carries the same shape
with no organism pair and no number.

**The bit-score magnitude, cut.** `## Reading the results` gave a low hundreds
figure for a 250 base read and a weakness floor of about 50, both reasoned from
the definition rather than measured. The sentence now says only that the score
rises with the length and quality of the match and that reading it means
comparing it against the other hits for the same read rather than against a
fixed number. No number remains.

**Dot colours, left out.** The source read does not state them. The chapter
describes the shapes, mentions the tint without a mapping, and says the word
carries the whole meaning.

**Read-length floor, left out.** No number in source and none in the two
recorded runs. Inconclusive stays qualitative.

### Registry corrections

`docs/user-manual/parameters.yaml`, entry `classify.blast-verify`.

The `notes` block now names the hidden set as the five the source hides, which
are Accession, Coverage, Align Length, Tax ID, and Verdict, each reachable by
right-clicking the column header, and states that six columns show by default.
Evidence is `fidelity.md` claim 32 and App defect one, which record
`BlastResultsDrawerTab.swift:913`, `:923`, `:933`, `:943`, and `:953` each
setting `isHidden = true` under the comment "Optional columns (hidden by
default, right-click header to show)", against the six default columns at
`:852` through `:897` that set no `isHidden`. The earlier four-name wording
from DRIFT row 13 omitted Accession and was wrong.

The `allowed` field now reads "1 to 50 in the popover slider, capped at the
number of reads the taxon actually has, and 1 to 100 on the command line".
Evidence is `fidelity.md` claim 18, `BlastConfigPopoverView.swift:75`
`in: 1...Double(maxReads)` with `:49-51` `maxReads = min(50, max(1,
readsClade))`, and claim 19, `BlastCommand.swift:115-117`
`guard readCount >= 1, readCount <= 100`.

Two further registry sentences the fidelity pass flagged are corrected while
the entry was open. The slider threshold is now "only one read" rather than
"fewer than two reads", per App defect three and `showsSlider = maxReads >= 2`.
The closing phrase "plus a verification rate" is now the supporting and
contradicting counts, per `BlastResultsDrawerTab.swift:451`, which shows counts
and not a rate.

    parameters ok

### Lint

Clean on the first run after the two cuts.

    docs/user-manual/chapters/06-classification/06-blast-verification.md: no issues found

No em dashes, no semicolons, no in-sentence colons. Both front-matter flags are
untouched and still read `brand_reviewed: false` and `lead_approved: false`.
