# Editor pass: 03-reads/06-subsetting-and-extraction

Editor: brand-copy-editor. Date: 2026-09-07. Target build: Preview 2026.9.13.

Inputs read in full: `fidelity.md` (62 true, 1 false, 2 unverifiable),
`readers.md` (four-reader merge, 77 rows, 31 at three or more readers),
`author.md`, `CONSISTENCY.md`, `STYLE.md`, and the chapter itself.

Section order unchanged. All fourteen Settings paragraphs kept, in place,
with their bold labels verbatim. No other chapter, `GLOSSARY.md`, or
`parameters.yaml` was touched.

## Changes by source

### Project manager rulings

**Ruling 1, the one false row.** Before you start. Replaced
"Every result lands under `Analyses/<tool>-<timestamp>/` ... The timestamp
is what keeps a second run from overwriting the first" with the corrected
behaviour. A result lands directly under `Analyses/` as a bundle named for
the input and the operation, and a repeat run appends a counter. Gave the
real name `HG002.chr20.10.0-10.5Mb_R1-subsampleCount.lungfishfastq` as the
worked example, which also closes reader row "Analyses/<tool>-<timestamp>/"
(two readers could not tell whether the angle brackets were literal).
Matches CONSISTENCY.md's settled 2026-09-07 wording for FASTQ operations.
Checked for a repeat of the wrong claim. There was none. The "Reading the
results" mention of `Analyses/` was already correct and is unchanged.

**Ruling 2, both unverifiable rows settled true.** No edit. The
fewer-reads-than-asked sentence in the Count entry stands as written. The
GitHub fixture URL stands as written.

**Ruling 3, both-strands statement stands.** No hedge added. Kept "This
operation searches both strands" as an unqualified statement.

### Fidelity-driven, beyond the false row

**Window FASTQ export exists.** Subset bundles hold no reads of their own.
The chapter said the only way to get a plain FASTQ out of a subset bundle
was a terminal command, which is wrong. `MainMenu.swift:231-235` builds
**File > Export > FASTQ...**, `SidebarViewController+MenuDelegate.swift:225-227`
adds the sidebar right-click item **Export as FASTQ...**, and
`AppDelegate+ImportExport.swift:460` routes both through
`FASTQDerivativeService.exportMaterializedFASTQ`, so a virtual bundle
exports its full reads rather than its preview. Rewrote the paragraph to
name both window routes first and present the CLI as the alternative. This
also resolves the three-reader consensus row about a terminal-only escape
hatch. See Referred to the project manager below.

**Show in Finder, not Reveal in Finder.** Same subsection. The chapter said
"Reveal the bundle in the Finder" without naming a command, and a reader row
asked for the menu item. The real control is a sidebar right-click item
titled "Show in Finder"
(`SidebarViewController+MenuDelegate.swift:310-312`). There is no
**File > Reveal in Finder**. Wrote the right-click path.

**IUPAC codes, verified before asserting.** Extract Reads by Motif. A reader
row asked whether IUPAC codes work. `buildMotifSearchArgs`
(`FASTQDerivativeService+SubsetHelpers.swift:30-36`) emits `grep -s` with
`-r` only when regex is on, and neither surface passes seqkit's separate
`-d` degenerate flag. Stated that LGE does not turn that mode on, so `R` is
read as the letter `R`, and directed the reader to brackets instead.

**Two unsourced claims withdrawn during drafting.** I had written that
`D00360` is a HiSeq 2500 and that `HISEQ1:93` selects one run. The fixture
README names only "NIST/GIAB Illumina 2x250bp" and no run-scoped query was
in the evidence set, so both were cut before the final draft. The
instruments are now named only by the identifiers they carry in the read
names.

### Reader rows at three or more readers (all 31 addressed)

1. **Bundle folder-versus-file.** What it is. Said a bundle looks like a
   single document icon in the Finder rather than an openable folder, and
   that the reader never types the extension.
2. **45,574 read pairs versus read count.** Why you would do this. Stated
   that each file holds 45,574 reads, that every count in the chapter comes
   from R1 alone, and that 45,574 is the number to measure against.
3. **Five runs, two instruments, second never named.** Same section. Named
   both instruments by their read-name identifiers, `HISEQ1` and `D00360`,
   and said which contributed how many runs. Also named both in Reading the
   results and in What good looks like, where the same row recurred.
4. **Docker Desktop.** Before you start. Cut the mention entirely, along
   with the "no optional pack" phrasing that framed absence as a warning.
5. **Depth unglossed.** Why you would do this. Glossed depth at first use
   and linked the Glossary entry.
6. **Per Input asserted before explained.** Procedure step 4. Gave the
   one-line meaning inline and pointed forward to Settings.
7. **Dialog described by what it lacks, pane versus window.** Procedure.
   Replaced the "no wizard with multiple pages" negative with a positive
   description of one scrolling page with a Run button. Settled the naming
   on "the window" in prose (14 uses to 2) and said the captions call the
   fields area the pane.
8. **0.15 times 16 equals 2.4.** Error Rate. Added a paragraph stating the
   allowance rounds down to two bases and never up.
9. **260 plus 261 equals 521, double counting.** Pattern. Added that a read
   is written out once however many times it matches, and that no read on
   this fixture carried both forms, which is why the figures add exactly.
10. **"reads this long" before the length is stated.** Min Overlap. Stated
    250 bases in Why you would do this, and made Min Overlap say "the
    250-base reads this fixture holds".
11. **Keep Matched Reads, three defaults in one sentence.** Split into the
    window sentence and a separate command-line sentence.
12. **Terminal-only FASTQ export.** Resolved by the fidelity finding above.
13. **"10,000 reads gives you 5,000 pairs, which is 10,000 reads".** Paired
    reads stay paired. Put the outcome first as its own sentence, then the
    mechanism, and said an odd number gives one read fewer.
14. **"name line" before any example.** What it is. Showed a real name line
    from the fixture in a code block at first use.
15. **What makes text look like a path.** Sequence or FASTA Path. Named the
    two triggers, a slash or a `.fa`/`.fasta` ending, and said a run of
    bases contains neither.
16. **5 prime and 3 prime as chemistry, not file direction.** Search End.
    Added a paragraph saying 5' is the first bases as written and 3' the
    last, with nothing about the molecule needing thought.
17. **Bracket example the only syntax shown.** Use Regular Expression under
    Motif. Added `[AG]GATCC` as a second example and the IUPAC statement.
18. **CLI contrast dropped into a window setting.** Search End. Moved the
    `--search-end both` paragraph out of Settings and into On the command
    line, where it now sits with the `right` mapping.
19. **`right` never mapped to 3' End.** On the command line. Stated it
    directly in the same relocated paragraph.
20. **Four extraction routes named in one closing sentence.** Extracting
    reads from a list. Kept the by-id mode as the chapter's, and pointed
    `--by-region` and `--by-classifier` at their own chapters. Dropped the
    `extract contigs` sentence, which introduced an unglossed term as the
    last line before Next (its own reader row).
21. **"within a percent or so" too vague.** What good looks like. Gave the
    range as half a percentage point either way, worked against the
    measured 9.81 percent, with 9.5 to 10.5 ordinary and 8.5 not. This also
    reconciles the row asking for one tolerance figure used consistently in
    both places.
22. **No rule for choosing Min Overlap on other data.** Added a paragraph
    saying start at 16 and lower it only for a stated reason. Also states
    the window default avoids the chance-matching problem and the CLI
    default does not, which is a separate reader row.
23. **Edit distance and the Java error unglossed.** On the command line.
    Glossed edit distance as the number of single-base changes allowed, and
    said the command exits without writing an output and nothing is
    damaged.
24. **gzip unexplained.** Extracting reads from a list. Said it is ordinary
    compression that changes no read and that nearly every program reads a
    gzipped FASTQ directly.
25. **Two files merged into one, interleaved unexplained.** Paired reads
    stay paired. Stated the merge explicitly and added a four-record layout
    sketch. The sketch is schematic rather than real headers, because the
    fidelity review established that no header in this fixture contains a
    space, so a realistic paired header could not be shown from this data.
26. **GitHub download unclear.** Before you start. Added the one sentence
    saying the address opens a listing, click a file's name, then Download.
27. **"Read the next paragraph" pointing only to more warning.** Query.
    Said plainly that nothing damages data and an unmatched query returns
    zero reads with the original untouched.
28. **Second instrument at results and verification.** Covered under 3.
29. **"Alu right-arm end" as a new term.** Reading the results. Dropped the
    term and said "the end of an Alu element that this motif matches",
    adding why one in ninety is the expected order of magnitude.
30. **Alarm that a subset holds no reads.** Subset bundles hold no reads of
    their own. Added that no reads are lost, that the manifest records
    which ones, and that copying the subset alone carries the manifest
    without the reads, so send the parent or export a file.
31. **Count field step too dense.** Procedure step 3. Split into three
    sentences and said the message is a normal prompt rather than an error.

### Reader rows below three readers, fixed because the fix was a sentence or two

- **barcode not glossed beside adapter** (2 readers). Inline gloss at first
  use in What it is.
- **random draw trusted without explanation** (2 readers, plus a separate
  one-reader row asking the same). One clause in What it is on equal chance
  of being picked.
- **shotgun library unglossed** (2 readers). Inline gloss at its first use
  under Pattern.
- **primer footprint** (2 readers). Changed to "a primer's own sequence".
- **44 reads, strand counting consistency** (2 readers). Added that both
  figures count both strands the same way.
- **one read in ninety with no expected range** (2 readers). Tied it to Alu
  occupying over a tenth of the genome and only 26 bases being matched.
- **fragment size unknowable by the reader** (2 readers). Replaced the
  fixed judgement with what a high figure implies about fragment length.
- **Show in Finder menu item** (2 readers). Covered above.
- **what makes a bundle not virtual** (2 readers). Said bundles that
  rewrite every read, such as trimming, hold their reads outright.
- **summary cards and parent unexplained** (2 readers). Defined both at
  first appearance in Reading the results.
- **edit-distance limit versus the window default** (2 readers). Added a
  paragraph saying the limit is the command line's alone and the window's
  16 and 0.15 are safe there.
- **whether to watch the Operations panel** (2 readers). Said the operation
  runs whether or not the panel is open.
- **motif introduced before plain words** (1). Reordered to "a short
  stretch of bases you are looking for, called a sequence motif".
- **"removes that objection" idiom** (1). Changed to "makes the comparison
  fair before anyone questions it".
- **read-through unexplained at first mention** (1). Moved the explanation
  up to Why you would do this.
- **a sample sequenced more than once** (1). Added the clause.
- **"pack" and "Required Setup" ambiguous** (1). Said a pack is a set of
  outside programs LGE installs by itself, already present.
- **numbered steps apply to all five** (1). Stated directly, replacing "The
  other four operations differ only in what you type".
- **four-clause "so" sentence** (1). Split into two stages.
- **identifier parts unlabelled** (1). Labelled the colon-separated fields.
- **no description example** (1). Gave `1:N:0:ATCACG`.
- **mismatches as count versus fraction** (1). Changed the Select Reads by
  Sequence opening to "a stated fraction of the matched bases".
- **share column mixes two meanings** (1). Added a lead-in saying the last
  column is a request for the first two rows and a finding for the last
  three.
- **"ships inside the application"** (1). Said the CLI is a second,
  text-only way to drive the same operations, installed as part of the app,
  and that a reader with no terminal can skip the section.
- **project folder empty or not** (1). Said pick a new, empty folder.
- **"the box" ambiguous across three checkboxes** (1). Replaced every "the
  box" with **Use Regular Expression**.
- **special characters once regex is on** (1). Listed the metacharacters
  and noted colons and digits are unaffected.
- **why exact matching is the safer default** (1). Added the clause.
- **materialize example uses SampleA** (1). Changed to the fixture's own
  subset bundle name.
- **when the two search operations overlap** (1). Added a paragraph to What
  good looks like.
- **sixth route not flagged as separate** (1). Said up front it is
  command-line only and not one of the five.
- **can a virtual bundle be used directly** (1). Answered in Subset bundles
  and again in Next.
- **positive control undefined** (1). Gave the Alu motif as the worked
  positive control on human data.
- **command-line sentences unmarked for window readers** (1). Added the
  lead-in to Settings saying the last sentence of each entry is safe to
  skip.
- **Proportion gives two competing reasons** (1). Reduced to one, cutting
  by the same factor.
- **stranded versus unstranded, and why the end moves** (2 readers).
  Explained both in one added paragraph under Search Reverse Complement.

### Style and consistency

- Frontmatter `glossary_refs` gained `barcode`, `depth`, and `shotgun` for
  the three new inline links.
- Removed "All five finish in seconds on a bundle this size" from Before
  you start. An unsourced duration, banned by the campaign prose rules. No
  timing claim replaced it.
- Prose rules verified mechanically after editing. No em dash, no
  semicolon, and no colon inside a sentence anywhere in the file. The only
  colons are in frontmatter keys and one shell comment.
- "Lungfish Genome Explorer (LGE)" at first mention, "LGE" thereafter,
  unchanged from the draft.
- Bullet caps unaffected. The only list in the chapter is the five-step
  numbered procedure.

## Deliberately left unchanged

**Section order and all fourteen Settings paragraphs.** Per ruling 4. Every
setting keeps its bold label verbatim and its position. Additions are
separate paragraphs after an entry, never inside one, so the fixed
three-sentence shape survives.

**The `--search-end both` content.** Moved rather than cut, because the
fidelity review confirms it true and it is the DRIFT "Missing" row.

**"usually a virtual bundle".** Kept the hedge. The fidelity review calls
it the right strength.

**The results table's five rows and percentages.** All recounted true. Only
the lead-in changed.

**Reader row asking to put subsetting's plain meaning in the title line.**
The title is frontmatter and section structure, which this role does not
edit. The first body sentence already gives the plain meaning.

**Reader row asking to split the results table.** Addressed with a lead-in
rather than a split, because splitting one table into two would change
section structure.

**`--by-db` gloss.** The row asked to gloss metagenomics database and
taxonomy or cut the aside. Neither is a one-or-two-sentence fix without
importing a concept this chapter's audience tier has not been primed for,
so the mention now points at the classification chapter instead of
explaining itself.

## Referred to the project manager

**The window FASTQ export is a fidelity finding the review missed.** The
chapter as drafted told readers the command line was the only way to get a
plain FASTQ out of a subset bundle. Two window routes exist and both
materialize the full reads. I corrected the chapter against source, but the
fidelity report's claim list has no row for this sentence, so it was never
checked. Worth a row in the record, and worth checking whether other
chapters carry the same wrong belief.

**The interleaved layout sketch is schematic.** Reader row 25 asked for a
two-line example of the layout. A realistic paired-end header carries a
mate number in its description, and this fixture's headers have no
description at all, so showing real headers from it would misrepresent the
data. The sketch labels the records instead. If a real interleaved example
is wanted, it needs a fixture that has one.

**The 0.5 percentage-point subsample tolerance is my synthesis.** Reader
rows asked for two concrete numbers and for one tolerance used
consistently. I derived the range from the single measured run at 9.81
percent. It is a reasonable envelope for a per-read Bernoulli draw at this
depth but it is not itself a measured figure, so it is worth confirming
against a second proportion run before publication.

## Lint

Command run from the worktree root.

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/06-subsetting-and-extraction.md
```

Output, verbatim.

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/06-subsetting-and-extraction.md: no issues found
```

## Status

brand_reviewed: true
