# Editor pass: 03-reads/03-quality-control

Date: 2026-09-06
Role: brand-copy-editor
Chapter: `docs/user-manual/chapters/03-reads/03-quality-control.md`

Inputs read in full before editing: `fidelity.md` (61 true, 5 false, 2
unverifiable), `readers.md` (52 rows, 23 hit by three or more readers),
`docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
`docs/user-manual/STYLE.md`, `.claude/agents/brand-copy-editor.md` including
its Campaign rules block.

The chapter was lint-green before the pass and is lint-green after it.

## Changes from the fidelity review

**Row 30, Mean Length card (false).** The card table now reads "249, 250, and
250" instead of "248.6, 250, and 250". The card formats `%.0f`, so 248.6 is a
number the app never puts on screen. The unrounded value is not reintroduced
anywhere, since no card shows a decimal read length.

**Row 35, the mean-versus-median lesson (false).** Rewritten against what the
card shows. The paragraph now reads "the card reads 249 against a median of
250, a gap of about one base", drops the 1.4-base figure entirely, and gives
the reader a rough boundary for when the gap matters (under about five bases
is normal on a fixed-length run, tens of bases is a large tail). This also
answers the two-reader row asking where small becomes large.

**Row 58, "writes the same statistics" (false).** Now "writes statistics of
the same shape as a JSON file". The Mean Q note was extended into a new
paragraph in the command-line section covering the other two divergences, with
the measured figures: report Q20 94.62% against the card's 95.0%, report Q30
91.28% against the card's 91.0%, and GC agreeing to the tenth of a percent.
The cause is attributed as the fidelity review supports it, `seqkit` handing
Q20 and Q30 over already rounded to whole percents while the command line
counts the bases itself.

**Row 63, truncated refusal message (false).** Now quotes the full string,
`Error: Output file already exists: <path>. Use --force to overwrite.`, so the
remedy the binary offers is visible.

**Row 75 (false).** No chapter edit. The row corrects a campaign note about
which chapter shares two shot ids (chapter 1, not chapter 2), not the chapter
body, and the fidelity review says so explicitly.

**Row 40, Q30 threshold (unverifiable) plus the three-reader conflict row.**
Reconciled to one figure stated once, per the project manager's ruling. The
70% figure is gone from Reading the results, which now points forward to What
good looks like for the threshold. What good looks like carries the single
statement and attributes it as "a common rule of thumb rather than a published
specification is that a Q30 above roughly 80% is healthy".

**Row 41, human GC (unverifiable).** Softened to "human DNA runs about 41
percent G or C across the whole genome", introduced as "As a rough guide", with
no citation. The same wording is reused in What good looks like so the two
sections agree.

**Row 26, Output Strategy.** Left as a both-values setting per the ruling. The
paragraph still names Per Input and Grouped Result and still carries the bold
registry label **Output Strategy.** verbatim. Only the sentence packing was
changed, which the three-reader row asked for.

**Row 44, optional caveat, taken.** The Q / Position paragraph now describes
what the box and its line stand for, which also serves the four-reader box-plot
row. The subsampling caveat itself was not added, since it is marked optional
and the four-reader rows carried more weight in the same paragraph.

## Changes from the reader synthesis

All 23 rows hit by three or more readers are addressed. Rows hit by one or two
readers were taken where the fix was a sentence or two.

Hit by four readers:

- Two mean-quality figures. New sentence states which number to quote ("Quote
  the card's 24.9 ... it is the more conservative of the two") before the
  explanation begins.
- Error probability and logarithmic averaging. Replaced with a worked
  conversion. Q30 is 1 in 1,000 and Q10 is 1 in 10, averaged as scores gives
  Q20, averaged as probabilities gives 0.0505 which converts back to about
  Q13. Arithmetic verified (`-10*log10(0.0505)` is 12.97). The phrase
  "logarithmic scale" is gone, replaced by "this kind of scale" plus the plain
  statement that a bad base is far more wrong than a good base is right.
- Box plot. The box is now described as covering the middle half of the
  quality scores at that position, with the median line and whiskers named,
  and tall versus short given a meaning.
- 3' end. Glossed inline as "the end of the read the instrument sequenced
  last", with the reason the decline is expected on every Illumina run.
- Binned chart, what healthy looks like. Added that a binned run is healthy
  when the tallest spikes sit at high scores, naming this fixture's Q37, and a
  worry when they sit near Q20 or below.
- Binning as a change to their data. Now says it can be turned off at import
  by setting the Quality Binning control to None (preserve original), verified
  against `FASTQImportConfigSheet.swift:296-299`, and that binning never
  changes which bases were called. "Compress harder" replaced with "so the
  file takes less disk space".
- N glossed as a position the instrument could not call as any of A, C, G,
  or T.
- Oxford Nanopore. Named as one of two kinds of sequencer, with the provider's
  run report as the way to tell which produced your files, and the Mean Q card
  named as the figure to judge Nanopore by.
- 2x250 spelled out as two reads of 250 bases, one from each end of the same
  fragment.
- Alignment and variant calling each glossed in half a sentence at first use.
- seqkit glossed as a read-counting program LGE runs for you, with the Required
  Setup pack explained and the reader told they install nothing by hand.
- Derived bundle given a concrete example, the trimmed bundle from Quality
  Trim, and defined as one an operation produced rather than one import
  created.
- Library glossed at first use in the Settings paragraph as one prepared
  sample loaded onto the sequencer.
- Operations Panel. Step 5 now says the panel can be opened before or after
  clicking Run and that the run works whether or not it is open. Kept inside
  step 5 rather than as a sixth step, see Left unchanged below.
- Read and base counts given something to judge against. The depth of coverage
  is worked out in the text, 22,662,846 bases over a 500 kb window is roughly
  45x. Arithmetic verified (45.33), and 45 matches the mean depth CONSISTENCY.md
  records for this slice.
- N50 given a worked example and a reason to exist. Four reads of 400, 200,
  100, and 100 give a median of 150, a mean of 200, and an N50 of 400.
  Arithmetic verified. The first draft of this example used 300 as the longest
  read, which gives an N50 of 200 rather than 300, and was corrected before the
  final lint.

Hit by three readers:

- Output Strategy sentence split, with the default in its own sentence.
- Viewport glossed as the main panel to the right of the sidebar.
- Q30 threshold conflict, see the fidelity section above.
- Bundle name against the `_R1` and `_R2` files. Step 1 now says import merged
  the pair into one bundle under the shared name and a single row is what to
  expect. Consistent with CONSISTENCY.md's paired-end storage ruling.
- Step 2 now names all five of the other cards, says the groups add up to nine,
  and points forward to Reading the results.
- The command-line section opens by saying it is optional and that the app
  already does this work.
- The sample-size caveat now appears at the top of The three charts, not only
  at the end of the command-line section.

Hit by one or two readers, taken because the fix was short:

- Command-line aside in Settings marked as ignorable for the app-only path.
- Docker Desktop explained in one clause rather than named bare.
- Sliding window dropped from What good looks like, with the pointer to the
  trimming chapter kept and widened to "explains the settings each one takes".
- GC tolerance stated once, in percentage points, with the term explained, and
  the two previously different figures collapsed into one.
- Adapter glossed at first use.
- Long reads contrasted with Illumina, with rough lengths for each.
- Paired-read command-line figures marked as command-line only, never
  comparable to a card.
- Step 4 now names the visible confirmation (Refresh QC Summary highlighted in
  the operation list) and glosses FASTA against FASTQ.
- "Spread out rather than averaged" replaced with a concrete example, how many
  reads sit at each length.
- Project folder may be new and empty.
- Platform stated once, macOS and the Command key.
- Popover replaced with "a small floating window" in both places.
- Second full "Lungfish Genome Explorer" mention added in What it is.
- GC described as a fingerprint of the organism at first mention.
- Settings lead-in split so it no longer says there are no settings and then
  names one.
- Phred scale explained at first use of Mean Q, with the tenfold-per-ten-points
  fact added.
- The repeated 91.0% reworded so the two figures read as a widening of the same
  count rather than a duplicated number.
- JSON glossed as a plain text file laid out for other programs to read.
- Import described as running a scan, not only a file copy.
- The forward reference to clicking a blank quality chart moved out of What it
  is and left to the Procedure paragraph that already covers that path.
- The Reads tab's 1,000 records described as the first in file order, not a
  random sample.
- Kit length attributed to the sequencing provider's run report.
- Trimming stated to write a new bundle and leave the original alone.
- Unfit defined in the opening paragraph as base calls too uncertain to trust.
- Provider figures noted as often quoted in millions of reads or gigabases.
- Base call glossed at first use.

## Changes from style and consistency

- Removed "On this fixture the refresh finishes in a few seconds" from Before
  you start. Unsourced duration, banned by the campaign prose rules.
- Bullet cap. Adding the Operations Panel as its own numbered step took the
  Procedure list to six items and tripped `bullet-cap.js`. Folded back into
  step 5, keeping the reader fix.
- `estimated_reading_min` raised from 11 to 18. The body is now 4,472 words.
- `brand_reviewed` flipped to `true`.
- Checked by hand and clean: no em dashes, no semicolons, no in-sentence colons
  (the only colon hits are YAML frontmatter keys), "Lungfish Genome Explorer"
  at first mention then LGE, every Settings paragraph keeps its bold registry
  label verbatim.

## Left unchanged, deliberately

- **Section order, and the count of Settings paragraphs.** Out of scope per the
  ruling and per the role definition.
- **Fidelity row 26, Output Strategy.** Not narrowed to Per Input. The fidelity
  review confirmed the picker offers both values and that the registry entry is
  right.
- **Fidelity row 75.** Campaign-note correction, no chapter edit.
- **Fidelity row 44's optional addition** that wide reads are thinned to fit
  the chart. Marked optional in the review, and the same paragraph already grew
  to serve two four-reader rows.
- **The Operations Panel as its own numbered step**, which the four-reader row
  asked for literally. A sixth step trips the five-item bullet cap, which is a
  hard style rule. The substance of the row is delivered inside step 5.
- **GLOSSARY.md.** Untouched per the ruling. Terms with no entry got an inline
  gloss at first use instead, listed above.
- **Other chapters.** Untouched. Several reader rows point at material the
  trimming and decontamination chapters own, and the chapter points forward to
  them rather than absorbing them.

## Lint

Command:

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/03-quality-control.md

Output, verbatim:

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/03-quality-control.md: no issues found

## Status

brand_reviewed: true
