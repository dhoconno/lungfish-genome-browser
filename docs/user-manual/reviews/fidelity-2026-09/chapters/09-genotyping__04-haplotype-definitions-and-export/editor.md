# Editor pass: 09-genotyping/04-haplotype-definitions-and-export

Chapter "Exporting Genotypes", roster row 56, registry id `genotype.export`.
Edited 2026-09-07 against `author.md`, `fidelity.md` (64 claims, 2 false),
`readers.md` (99 merged rows, 21 in the Consensus section), `CONSISTENCY.md`,
and the committed siblings 01 and 03.

`brand_reviewed` and `lead_approved` both remain `false`.

## False claims fixed

Both, with the reviewer's wording.

1. **The read-count range (was Step 2, now Step 3).** "the individual samples
   range from 713 to well over forty thousand" is now "the individual samples
   range from 2 reads to 58,370". The reviewer's evidence is pivot row 3,
   whose minimum is 2 at two samples and whose maximum is 58,370. The same
   range is what chapter 01 already quotes at `:149`, so the three genotyping
   chapters now agree. The sentence that follows names the app's own
   1,000-read Low Support label rather than inventing a cutoff, per
   CONSISTENCY's "Genotyping sample status" section.
2. **The haplotype-band locus count.** "and so on through eight loci" is now
   "14 of them, labelled `MHC-A Haplotype 1`, `MHC-A Haplotype 2`, and so on
   through seven loci at two rows each". Fourteen rows at two slots each is
   seven, and the source's fallback list holds exactly seven entries.

## Project manager rulings

Every ruling applied. Where a ruling and a reader row pointed the same way,
the ruling's wording won.

**(a) The Procedure is window-only.** The Procedure is now three steps, all in
the window. Step 1 sets the two filters, Step 2 presses **Filtered Pivot...**
and explains what the file is, Step 3 reads the workbook. The old Steps 3 and
4, which were the CSV, TSV, and LabKey exports, have moved into On the command
line, each with its own command block, so nothing command-line is presented as
an ordinary Procedure step. A new line under the `## Procedure` heading says so
outright. The Settings paragraph for **Export Excel View....** and the one for
**Update and View Current Excel Version** now carry the one sentence saying
those two controls appear only on a haplotyped result or in the Current
Workbook block, and Before you start states the same fact once in prose. The
fixed opener's clause "nothing here unlocks a result the dialog cannot produce"
is replaced by "the CSV, TSV, and LabKey exports are the only things here the
window cannot produce", which names the three exports rather than making a
claim the chapter would then have to walk back. The old qualifying paragraph
that followed the opener is gone, since the opener now carries the
qualification itself.

**(b) The four counts.** Step 3 now carries one short paragraph that states all
four once and says what each counts. 970 is the library size and the number of
matrix rows the window can show, 305 is the rows carrying a call in at least
one sample and so the rows the pivot writes, 13 is the loci the run reports,
and seven is the fixed locus list of the empty haplotype band, which is why it
does not match the 13. Each number keeps its first appearance where the reader
meets it. The word slot is glossed at its first use in On the command line as
"the two allele positions a report gives each locus", and `report-slot` is now
a Glossary entry.

**(c) M1 through M7.** The Legend sentence now reads that `M1` through `M7` are
"the published names of the seven MHC haplotypes first described for Mauritian
cynomolgus macaques", each fixed to one colour so the same haplotype looks the
same in every workbook. That is the author's Legend reading plus the source
comment at `HaplotypeColorToken.swift:27-31`, which records the Budde 2010
palette and says the indices carry semantic meaning to MCM workers and must
never be recoloured. No hex value appears in prose, per the brand rule. The
`ERR` token is glossed as the software being unable to decide.

**(d) The worked allele target.** The shortened `01_Mamu-A1_002g` is kept and
followed by the clause "The name in the cell continues past a vertical bar with
the alleles that record covers, so search for the part before the bar when you
look for that row." Chapter 01 already explains the bar and the group records,
so the clause points rather than re-teaches.

**(e) Export location.** Dropped. Neither the author nor the reviewer recorded
a reason for choosing a folder outside the project, and no source note offers
one, so under the ruling the instruction goes rather than acquiring an invented
rationale. Step 2 now says "Pick any folder you can find again."

**(f) The "nothing here changes a call" claim.** Reconciled in What it is, in
one sentence naming the exception. The second paragraph now says only one
control writes back into the bundle, names it, and says it "rebuilds the
bundle's own workbook from calls you have already made rather than changing a
call". That is taken from the author's source note on
`GenotypeResultDocumentSection.swift:578-599` and the reviewer's confirmation
of the same caption. The bare sentence "Nothing in this chapter changes a call"
is gone, since it was the half-truth the ruling names.

**(g) The haplotype placeholder.** Now one sentence, "The choice of haplotype
definitions is not documented in this release of the manual." The heading is
unchanged. This departs from CONSISTENCY's fixed two-sentence form on the
project manager's instruction, which is the later ruling.

**(h) Min reads and Min percent.** Step 1 now says LGE defines no threshold,
that no number the manual quotes is a recommendation, and that the 50 and 5
used below are one example on one run. The reader is told to judge against
their own sequencing depth, which is glossed in the same sentence. The Min
reads Settings paragraph carries the same orientation. No threshold is
invented, and the three readers who asked for "a sensible starting value" get
an honest answer rather than a number.

**(i) The percent-basis defaults.** Stated as a fact rather than a possible
bug. On the command line now says "One difference from the window is a fact
rather than a fault", gives both defaults, cites the reviewer's evidence that a
flagless run reports `sample-retained` back in its own summary, and tells the
reader to pass `--percent-basis viewed-locus` to match the window. The Percent
Basis Settings paragraph carries a pointer to that passage.

**(j) The symlink error.** Rewritten in chapter 54's plain words. It now says
the command fails when the output path is spelled `/private/tmp/...`, that the
cause is LGE comparing two spellings of the same path, and that `/tmp/...` or a
folder in the home directory works. The phrases "symbolic link" and
"transaction generation" are gone.

**(k) The Inspector tab and the disclosure.** Step 1 now names "the Inspector's
**Genotype Display** section, on the Inspector's View tab", which is chapter
55's wording at `:122` and `:140`, and describes the disclosure as "the small
triangle at the left of its heading". The Settings lead uses the same
formulation.

**(l) Glossing.** JSON, viewport, rendered, report slot, manifest, checksum,
sidecar, amplicon panel, lens, mapping, sequencing depth, retained percentage,
long format, LabKey, MiSeq, IPD-MHC Mamu, DRB, GS ID, no call, pipeline
override, and display state are each glossed in one clause at first use.
Glossary additions are listed below.

**(m) Shot markers.** All three kept, with their `shots` entries unchanged.
Markers moved with their surrounding prose as the Procedure was renumbered, so
`genotype-inspector-export` now sits in Step 1, `genotype-export-save-panel` in
Step 2, and `genotype-pivot-workbook` in Step 3.

## Consensus rows

**21 of 21 applied.** In brief.

1. Title versus file name. The Procedure lead and the placeholder now both say
   haplotype definitions are not covered, so a reader stops looking early.
2. Bundle as a folder. What it is says Finder shows it as one item that opens
   in LGE when double-clicked.
3. No result of their own. Before you start tells a reader without a bundle to
   read for orientation and come back.
4. The disclosure triangle. Named as the small triangle at the left of the
   heading, with **View > Show Inspector** (Cmd-Opt-I) given in the same
   section.
5. Knowing they scrolled far enough. Step 1 names Cell Color as the last
   control above the Export block.
6. Starting values for the filters. Answered under ruling (h) by saying the app
   defines none and the example is an example.
7. Export location. Dropped under ruling (e).
8. The permanence warning. Now its own short paragraph opening Step 2's
   explanation, saying permanent in the exported copy alone.
9. Report slot. Glossed at first use and added to the Glossary.
10. M1 through M7. Explained under ruling (c).
11. The 929 to 927 arithmetic. Spelled out, "929 minus 1 minus 1 is 927 and 5
    minus 2 is 3".
12. Command-line steps in the Procedure. Removed under ruling (a).
13. The 970 figure against 305. Reconciled in the four-counts paragraph, and
    the Alleles Settings paragraph no longer quotes a bare 970.
14. The Show All Rows risk clause. Cut. The registry's "There is no automatic
    row limit that this undoes" carried no risk for a reader to act on.
15. The "Eight further options" line. Count verified at eight, sentence
    finished, and a closing sentence added telling a window reader to skip to
    Reading the results.
16. JSON, rendered, viewport in `--view-projection`. All three glossed, the app
    named as the writer of such a file, and most readers told they never supply
    one.
17. Seven thin samples out of 30. Answered with the app's own 1,000-read Low
    Support label rather than a judgement, per CONSISTENCY.
18. The command-line opener contradicting itself. Fixed under ruling (a). A
    pointer to where Terminal lives is added to the same paragraph.
19. The percent-basis mismatch. Stated as a fact under ruling (i).
20. The symlink error. Rewritten under ruling (j).
21. "Modest threshold" with no numbers. Why you would do this now names Min
    reads 50 and Min percent 5 in that sentence and says the outcome is normal.

## Other merged rows

**63 applied, 15 skipped.** The applied ones are the glosses and splits already
summarised under ruling (l) plus these substantive changes: the wide-versus-long
example, the "turns that layout on its side" plain restatement, the
spreadsheet-library phrase cut, the "So what should you do with this?" question
cut, the retyping sentence split, "three bands" changed to "three groups of
rows", GS ID glossed, the blanked-versus-removed distinction added, the 2,109
rows explained as observed pairs only, the 27-column arithmetic shown, the
matched-row count renamed in its description as the total rows examined, the
submitted-count source named, "Clear the fields" changed to "set both back
to 0", "directory" changed to "folder" in prose, "standard quoting" replaced by
"a comma inside a value is handled safely", "tuning options" replaced by
"Filters do not apply to this export", the three LabKey read-count columns
defined, the backslash explained, the drag-a-folder-into-Terminal tip added,
"a good export is boring" followed by "which is a compliment", the exporting-for-yourself
clause added, the Cell Color shading direction given, and the Step 1
pointer back to chapter 03.

Skipped, each with its reason.

1. **Rename the file to match the title.** Out of the editor's authority. The
   roster instruction is "existing (retitled, add to nav)" and the author
   recorded the file name as deliberately unchanged.
2. **Note the haplotype gap in the front matter.** The template has no field
   for it and the placeholder section already says it.
3. **Two tiny tables, wide and long, side by side.** A structural addition, and
   the one-clause example the same row offers is applied instead.
4. **A small table naming the three workbooks.** Same reason. The three are
   named in running prose at their own first uses.
5. **"Say what the person receiving the file actually does with it."**
   Unverifiable. Neither the author nor the reviewer recorded what a recipient
   lab does with a pivot sheet, and inventing it is out of bounds.
6. **"Say what read count counts as strongly supported."** Refused under ruling
   (h) and CONSISTENCY. The app defines no such threshold.
7. **"Say what read count is enough to reliably call a sample."** Same reason.
   The Low Support label is given instead.
8. **"Give a rule of thumb tying depth to a threshold."** Same reason.
9. **"Give a fraction that would count as a warning sign"** for row removal.
   Same reason. No source records one.
10. **"Say whether a sixty-fold spread between samples is normal for an
    amplicon panel."** Unverifiable. No source in the campaign says so, and the
    real spread is wider than sixty-fold once the range is corrected.
11. **"Break down one allele name once, saying what each part means."**
    Chapter 01 owns the naming scheme and does this at `:71-75`. Repeating it
    here duplicates a sibling's material.
12. **"Gloss haplotype as a set of alleles inherited together"** in Step 2's
    old wording. Applied in substance, but the reader's specific placement
    request no longer exists, since the sentence was rewritten for the
    seven-loci fix.
13. **"Expand MCM at first use"** in the placeholder. The placeholder no longer
    mentions MCM, per ruling (g). MCM is expanded where it does appear, in the
    Legend sentence.
14. **"Say what happens if the export is placed inside the project folder."**
    The instruction it qualifies was dropped under ruling (e), so there is
    nothing left to qualify, and no source records a consequence.
15. **"Drop the repeatable note"** on `--sample`. The note is trimmed rather
    than dropped, because the reviewer confirmed the field and the flag differ
    in kind and a reader who takes them as equivalent will be wrong.

## Glossary changes

Three entries added to `docs/user-manual/GLOSSARY.md`, each one sentence in the
existing shape, each alphabetised, and each added to this chapter's
`glossary_refs`.

- **JSON**{#json}, in `## J` before Joint genotyping.
- **Report slot**{#report-slot}, in `## R` before Representative reads.
- **Viewport**{#viewport}, in `## V` before vsearch.

`glossary_refs` now lists 23 anchors, up from 20. All 23 resolve to exactly one
`{#anchor}` in `GLOSSARY.md`, and every inline `GLOSSARY.md#...` link in the
body resolves as well. No existing entry was edited. Chapters 01 and 03 were
re-linted after the glossary edits and both still print `no issues found`.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/09-genotyping/04-haplotype-definitions-and-export.md
```

Result, verbatim:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/04-haplotype-definitions-and-export.md: no issues found
```

## Left for the gate

The reviewer's app defects are unchanged by this pass and none is a prose
problem. The outstanding retitle site at
`03-reading-the-genotype-comparison.md:209` belongs to whoever gates row 55.
The wrong-cased `GenotypeExportXLSXSubcommand.swift` path in
`parameters.yaml:6168` and `DRIFT.md` is a registry fix rather than a chapter
one. The three shot markers still await capture.
