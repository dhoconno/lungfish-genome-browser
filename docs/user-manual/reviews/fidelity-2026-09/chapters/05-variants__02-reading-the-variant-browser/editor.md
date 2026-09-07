# Editor pass, chapter 28, Reading the Variants Table

File edited: `docs/user-manual/chapters/05-variants/02-reading-the-variant-browser.md`
Date: 2026-09-07
Role: brand-copy-editor
Lint after editing: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`.

Section order unchanged. All six Settings paragraphs kept with their bold
labels verbatim. No other chapter, `GLOSSARY.md`, `parameters.yaml`,
`help-ids.yaml`, or `mkdocs.yml` touched. Front matter changed only in the
`variants-inspector-row` caption and in `glossary_refs`, both of which the
rulings allow.

## Changes from the fidelity review

**Fidelity 21 and 29, and PM ruling 1, the Inspector.** Step 3 previously said
the Inspector shows the consequence, and the `variants-inspector-row` caption
promised an INFO and FORMAT payload alongside Consequence and AA Change. The
Inspector renders identity, quality and filter, a genotype summary, and INFO
fields only. The step-3 paragraph now names those four groups and states
plainly that the Inspector does not repeat `Consequence` or `AA Change` and
does not print the per-sample `FORMAT` payload. The caption was replaced with
the wording the fidelity review proposed.

**Fidelity 54 and 55, and PM ruling 1, the Search Builder worked example.**
The Region rule value `1-250000` is silently dropped by `parseRegion`, so the
reader following the old text got an unfiltered table. Step 5 now carries a
new paragraph stating that a Region value has to be `chrom:start-end` and that
a bare range is ignored, and the worked example enters
`chr20_10.0-10.5Mb:1-250000`. I confirmed against
`AnnotationTableDrawerView+Filtering.swift:2052-2058` that this exact string
parses, since the contig name carries no colon and the range parses as two
integers. The 512-of-574 figures therefore stay, which is what fidelity row 55
recommended once the Region value is corrected.

**Fidelity 71, and PM ruling 1, the Settings entry for the Search Builder.**
Both the Settings lead paragraph and the **Search Builder....** entry said the
sheet's query text is what `--filter` takes. Both now say the sheet's text is
not in general accepted by `--filter`, which takes per-sample clauses only,
matching the chapter's own command-line section.

**Fidelity 83, and PM ruling 1, the genotype counts.** The sentence now reads
623 `0/1`, 415 `1/1`, and 18 `1/2`, with a gloss on what `1/2` means and the
explicit reconciliation to 1,056, which is the same shape chapter 27 uses.

**Fidelity 51, the Sample/Genotype fields.** The sheet replaces the
placeholder labels with one triple per loaded sample. The category table row
now says the sheet offers a genotype, allele-frequency, and depth field per
sample, and the prose below names `HG002.GT`, `HG002.AF`, and `HG002.DP` as
what this fixture shows.

**Fidelity 45, where a saved profile lives.** Changed from "stores your own
under the bundle" to "stores your own on this Mac, keyed to the bundle you
saved it from", with an added sentence saying a profile does not travel with a
copied or shared bundle.

**PM ruling 2, the Type convention.** A new sentence in step 2 states that LGE
reads only the first alternate allele on a row and gives the whole row that
one type, and that every substitution and indel count in the chapter follows
that rule. The "Reading the results" sentence now points back at it. The
figures stay at 874 and 182.

**Fidelity 50, the Population/Frequency category.** The category table row now
adds that the category also picks up any frequency-like `INFO` key the loaded
track carries, which the review offered as optional and which also answers a
reader row.

### Unverifiable rows, handled per ruling 3

**Fidelity 73 and 26, hedged and in one case corrected.** Row 73 doubted that
Auto "gets a human fixture and a viral genome right". Reading
`AnnotationSearchIndex.isLikelyHaploidOrganism` settles it as false. Auto
reads a ploidy note from bundle metadata when one exists and otherwise treats
any reference under 10 megabases as haploid, so this fixture's 500 kilobase
slice is guessed haploid. The Settings entry now describes that mechanism and
says the guess is right for a whole small genome and wrong for a slice of a
large one. Step 4's chip-availability paragraph was rewritten to match, since
it previously asserted that a human fixture never shows the frequency chips,
which does not follow once Auto reads this fixture as haploid. Step 4 now
tells the reader to set the control to Diploid, which is the truthful answer
for a human sample and which removes the three chips. Row 26, the
drag-to-reorder and right-click-to-hide affordances, was left as written, see
"Left unchanged" below.

**Fidelity 79, the mean depth of 44.7.** Not derivable from the two VCFs. The
figure is now attributed to where it is actually visible, the alignment
viewport's coverage strip, and described as a mean across the visible window
rather than across the slice, which matches the wording in
`04-alignments/02-reading-an-alignment.md`.

**Fidelity 89, the provenance record.** The claim that clicking the track in
this table shows a record with version, command line, and checksums was not
verifiable. The fifth check now says every track LGE writes carries a
provenance record filed beside it, states that the `Source` column is not a
link, and directs the reader to select the track in the project sidebar.

**Fidelity 30 and 31, arrow-key selection and VoiceOver.** Both left as
written, since neither is contradicted by any source and both are standard
`NSTableView` behaviour. VoiceOver is now glossed.

### One error I introduced and corrected in the same pass

While rewriting the `INFO` column paragraph I first asserted that `DP`, `MQ`,
`AF`, `AC`, `DP4`, and `SB` are promoted to the front in that order. Checking
`AnnotationTableDrawerView+Columns.swift:526-530` shows the promoted patterns
are only AF, Gene, and Impact. The shipped paragraph says three keys come to
the front, allele frequency then gene then impact, and lists the four other
fixture abbreviations as ordinary columns.

## Changes from the reader report

### Rows hit by three or more readers, all twenty-five addressed

1. **250-point drawer height.** Replaced with "tall enough to show something
   like eight rows at once, which is under a third of a full-height window",
   derived from the 250 point default and the table's 22 point row height.
2. **HG002 never explained.** "Why you would do this" now opens with HG002 as
   a consenting research participant distributed as a cell line with an
   independent truth set, matching chapter 27's framing.
3. **Plugin pack unglossed.** "Before you start" now opens the paragraph with
   "Nothing needs installing for this chapter", glosses plugin pack inline,
   and links the glossary entry.
4. **Operations panel.** Step 1 now glosses it as the running log of every job
   and describes what a running row and a finished row look like.
5. **Seven standard columns against six table rows.** All twelve columns are
   now in one table with a "Where it comes from" column, `Ref` and `Alt` split
   into their own rows, so the count needs no hand checking and the old
   six-columns-in-one-sentence paragraph is gone.
6. **iVar unglossed.** Now glossed inline as a variant caller built for
   amplicon data, with the link, and explicitly marked as not used here.
7. **DP4, MQ, AC, SB never expanded.** Each is now expanded once, and the
   paragraph says plainly that only `DP` and `AF` matter in this chapter.
8. **Haploid-only frequency logic reads backwards.** Step 4 now explains why
   allele fraction is a clean filter only at one genome copy, contrasting the
   haploid and diploid readings of a fraction near one half.
9. **The 574-row scope setting explained only in Settings.** The worked
   example now opens by telling the reader to set the scope control to
   **Genome** before running it.
10. **Genome track never introduced.** Step 6 now introduces it as a thin
    horizontal band above the drawer carrying one tick per call before it
    warns about the colors.
11. **623 plus 415 does not reach 1,056.** Fixed under ruling 1 above.
12. **The 470-bases arithmetic.** The division is now shown, and the paragraph
    says the slice is about twice as dense as one base in a thousand and that
    a factor of two is expected on a gene-rich stretch.
13. **GT used before expansion.** The Calls / Genotypes entry now says GT is
    the standard abbreviation for genotype.
14. **Auto / Haploid / Diploid absent from the Procedure.** Now named in step
    4 alongside the frequency chips, with an instruction for this fixture.
15. **`--filter` grammar never reconciled with the Search Builder.** The
    command-line section now opens that paragraph by saying the two grammars
    differ and leading with the one shape that works, and the Settings entry
    and lead paragraph say the same, which is also ruling 1.
16. **The BUNDLE path.** A new paragraph before the block says commands go in
    Terminal, explains that the first line sets a shortcut name, says the path
    is an example to replace, and says what the double quotes are for.
17. **`bcftools view -H ... | wc -l` unexplained.** The comment in the block
    now says bcftools prints the rows without the header and `wc -l` counts
    the lines it printed.
18. **The 02 to 04 jump.** The Next section now opens by saying nothing was
    skipped and that step 6 absorbed the retired chapter 03.
19. **The two two-segment controls indistinguishable.** Both are now named by
    their on-screen labels in bold at first mention, **Calls** and
    **Genotypes**, then **Region** and **Genome**.
20. **852 shared positions against the row totals.** A sentence now says the
    figures count distinct coordinates rather than rows and that each track
    keeps its own row at a shared coordinate. The same point is repeated in
    "Reading the results" beside the 1,918 total.
21. **"Verdict" undefined.** The `Filter` table row now reads "The caller's
    own pass or fail label for the row", and the two later uses of "verdict"
    and "hard filter" were reworded.
22. **VoiceOver unidentified.** Now glossed as the screen reader built into
    macOS.
23. **The three population-database keys unnamed.** Now named in the category
    table as `gnomAD_AF`, `ExAC_AF`, and `1000G_AF`, with a sentence saying
    neither caller here writes any of them.
24. **Coordinate range relative or genomic.** The new Region paragraph says
    coordinates are counted from the start of the 500 kilobase slice, so the
    slice runs 1 to 500000 despite the 10.0 Mb in its name.
25. **Zooming never explained.** The large-database paragraph now points at
    `04-alignments/02-reading-an-alignment.md` for the zoom commands.

### Other reader rows fixed, each a sentence or two

- Variant caller glossed as a program (row 46). Tab-separated glossed as
  fields separated by tab characters rather than commas (row 46).
- Gene feature exemplified as exons and coding regions (row 47).
- Drawer glossed as a panel that slides out from an edge (row 48).
- `lungfish-cli variants query` marked as a Terminal command covered at the
  end of the chapter (row 49).
- The rhetorical question "So what should you do with this?" dropped (row 50).
- The missing free-text box now points forward to the Search Builder in the
  same paragraph (row 51).
- "Two sibling tabs" changed to "Two other tabs sit in the same drawer"
  (row 52).
- A sentence added saying the reader never opens the VCF by hand (row 53).
- "Mapped" glossed and linked (row 54). Illumina glossed as a sequencing
  instrument brand (row 55).
- A sentence added saying that in the Calls view one row is one variant in one
  track (row 56).
- A sentence added on how the two callers differ, pointing at step 6 (row 57).
- "Any folder you can write to works" added (row 58).
- bcftools now said to arrive with the Required Setup pack the first time you
  run it, with nothing to fetch by hand (row 59).
- "Declares" replaced with "carries", and `INFO` keys glossed as the extra
  per-variant measurements a caller records (row 61).
- A sentence added saying the two tracks do not contribute the same columns
  (row 62).
- The promoted columns are now named (row 63), corrected against the source as
  noted above.
- An example `INFO` string `DP=63;VDB=0.62;MQ=60` added in step 3 (row 64).
- "A strip of fourteen chips" states the count where the chips are listed
  (row 65).
- `Bookmarked` now described as keeping rows you flagged by hand, covered
  elsewhere (row 66).
- The bare `.` lesson moved to the front of its paragraph (row 67).
- "Hard filter" dropped for "no filter of its own", in both places (row 68).
- The human fixture and frequency chip contradiction resolved (row 69), see
  fidelity 73 above.
- The seven categories are now a table (row 70).
- Dot notation glossed as a field belonging to one named sample (row 71).
- A Location rule's `=` glossed as "inside this range" (row 72).
- The LoFreq `AF` value now identified as a fraction of the reads LoFreq
  counted and located in the table's own `AF` column (row 73), see the note
  below on what I did not assert here.
- The Auto size cutoff of 10 megabases now stated (row 74).
- `Qual >= 30` in the Presets Settings entry changed to `Qual ≥ 30`, and the
  three frequency chip labels to the `≤` and `≥` glyphs, so the symbols match
  step 4 (row 75).
- Phred anchored at 10, 20, and 30 with the ten-points-per-tenfold rule
  (row 76).
- A sentence added saying twenty-four low rows in a thousand is a normal tail
  and to read them alongside their depth (row 77).
- "30 reads deep" and "a depth of 10 reads or more" written out (row 78).
- The 1,918 total now says the tracks are stacked rather than merged (row 79).
- The `Source` column stated not to be clickable, with the sidebar named
  instead (row 80), which is also fidelity 89.
- The optional section now says every row count in the chapter can be read off
  the table itself (row 81).
- "Smart-filter token" now used only for the chips, which is what the glossary
  entry defines, and the CLI text is called a filter expression throughout
  (row 82).
- The pipe explained in the block comment (row 83).
- A paragraph added explaining why 770 is not 623 plus 415 (row 84).

### Reader rows deliberately not acted on

- **Row 33, how long the prerequisite chapter takes.** The chapter now says
  the whole of it is required, which is the actionable half. The duration half
  is blocked by the campaign's no-unsourced-durations rule and I have no
  measured figure.
- **Row 40's second half, how to reach a specific coordinate.** Partly acted
  on. Step 6 now names **Sequence > Go to Location...** (Cmd-L), verified at
  `MainMenu.swift:643`, and notes that it works with the scope control on
  Region. I did not add a table-side search route, because none exists.
- **Row 22's "what to substitute for their own project"** is answered by the
  new paragraph, but I did not spell out how to find a folder's path in
  Finder, which belongs to a terminal primer rather than to this chapter.

## Changes from the consistency sheet

- The command-line section's Terminal sentence and the Before-you-start
  opening keep the sheet's fixed sentences intact. The only change to the
  fixed fixture sentence was moving the plain-language definition ahead of the
  word "fixture", which the sheet's glossary-discipline section asks for and
  which two readers flagged.
- Naming, menu paths, the Operations panel path, the drawer phrasing, and the
  Settings three-sentence shape all follow the sheet unchanged.

## Changes from the style guide

- No em dashes, semicolons, or in-sentence colons were introduced. The only
  semicolons in the file are inside the inline code example `DP=63;VDB=0.62;MQ=60`,
  which is the literal shape of a VCF INFO string and which the linter exempts
  as code.
- No banned word from `ai-tells-words.txt` was introduced. "Determine" and
  "navigate" were avoided in favour of "settles" and "reach".
- The `Type` and `INFO` paragraphs were kept as prose rather than bullets, so
  no list was added to any H2 section and the bullet cap is untouched. Two
  tables were added in step 2 and step 5, which the cap does not govern.
- Voice held to the calm, precise register. The rhetorical question in "What
  it is" was the only voice removal.

## Left unchanged, and why

- **Fidelity 26, drag-to-reorder and right-click-to-hide.** Left as written.
  The source restores saved ordering and visibility, which implies both, and I
  cannot drive the app to confirm the gestures. Marked here for the GUI pass
  rather than hedged in the prose, since hedging a true-looking affordance
  costs the reader more than it saves.
- **Fidelity 16, bcftools in the Required Setup pack.** Left asserted, with
  the wording tightened to say LGE installs it the first time you run it.
  `PluginPack.swift` would settle it and belongs to another role.
- **Fidelity 30 and 31, arrow keys and VoiceOver.** Left as written.
- The five shot ids, their positions, and the other four captions.
- Every section heading, the six-step structure, and all six Settings
  paragraphs and their bold labels.

## For the project manager to rule on

1. **The Auto ploidy guess reads this fixture as haploid.** This is the one
   place where correcting a false claim forced me to change a reader-facing
   behaviour statement without being able to drive the app.
   `AnnotationSearchIndex.isLikelyHaploidOrganism` returns true for any
   reference under 10 megabases when the bundle carries no ploidy metadata,
   and this fixture's reference is 500 kilobases. The three frequency chips
   also require `hasGenotypes`, which the bcftools track satisfies. So on the
   default Auto setting the three frequency chips are probably visible on this
   fixture, which is the opposite of what the chapter said before. I rewrote
   step 4 and the Settings entry to describe the mechanism and to tell the
   reader to set Diploid, which is correct either way, rather than to assert
   what the strip looks like on Auto. A GUI run should confirm whether the
   three chips do appear on Auto, and the two paragraphs may want a further
   sentence once it does.
2. **`parameters.yaml`'s `variants.query` note** still says a sheet query can
   be pasted straight into `--filter`, which the chapter now contradicts in
   three places. That file belongs to another role.
3. **`help-ids.yaml`'s `inspector.VariantSection` description** still says
   "per-variant INFO and FORMAT detail", which is wrong for the same reason as
   fidelity 21. Also another role's file.
4. **Chapter 27's 873 and 183** still contradict this chapter's 874 and 182,
   pending the correction ruling 2 promises.

## Verbatim lint output

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/05-variants/02-reading-the-variant-browser.md: no issues found
```

## Status

brand_reviewed: false, left as it was. The chapter still needs the GUI
confirmation in item 1 above before this pass should be called complete.
