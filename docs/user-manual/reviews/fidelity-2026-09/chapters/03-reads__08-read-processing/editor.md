# Editor pass, 03-reads/08-read-processing

Date: 2026-09-07
Editor: brand-copy-editor

Inputs read in full before editing: `.claude/agents/brand-copy-editor.md`
(including its Campaign rules block), `fidelity.md` (61 true, 5 false, 0
unverifiable), `readers.md` (the merged four-reader synthesis, 78 rows, 26
hit by three or more readers), `author.md`,
`docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`, and
`docs/user-manual/STYLE.md`. Also checked against `GLOSSARY.md` anchors,
`parameters.yaml` rows 757 to 970, and
`Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift` plus
`Sources/LungfishApp/Views/Operations/DatasetOperationsModels.swift` for the
Advanced Settings section title.

Section order unchanged. All twelve Settings paragraphs kept, each with its
bold label verbatim. No other chapter, `GLOSSARY.md`, or `mkdocs.yml`
touched.

## Changes from fidelity rows

- **Row 10, false. Why you would do this.** "each read 250 bases long"
  replaced. The paragraph now reads "45,574 read pairs, which is 91,148
  individual reads counted one mate at a time, of up to 250 bases each and
  most of them the full 250." Lengths run 35 to 250 with 71.1 percent at
  exactly 250, so the fixed-length claim was wrong.
- **Row 28, false. Reading the results.** "against an input where every read
  was 250" became "against an input where no read exceeded 250." The
  conclusion that a record over 250 bases is a joined pair survives on the
  corrected premise, so that sentence stands.
- **Row 34, false. Reading the results.** "45,574 protein sequences of 83
  amino acids each" became "45,574 protein sequences, most of them 83 amino
  acids ... Shorter reads give shorter proteins, and on this fixture the
  lengths run from 16 to 83 residues." 90.8 percent are 83 aa, lengths run
  16 to 83.
- **Row 21, false. Procedure.** The bundle name
  `HG002.chr20.10.0-10.5Mb-mergeOverlappingPairs` was wrong. Replaced with
  `HG002.chr20.10.0-10.5Mb-pairedEndMerge`, the derivative kind string, and
  the five sibling suffixes `-pairedEndRepair`, `-reverseComplement`,
  `-translate`, `-orient`, and `-errorCorrection` are now listed so a reader
  can predict any of the six.
- **Row 61, false. Frontmatter.** `glossary_refs` now lists exactly the
  eighteen anchors the body links, verified by extracting every
  `GLOSSARY.md#` target from the body and diffing against the list. Rather
  than dropping `read`, `read-merging`, `k-mer`, `codon`, and `orient-reads`,
  the body now links all five at their first use, since each is a term the
  reader team asked to have glossed anyway. `required-setup-pack` was added
  to the list (the body already linked it), and `library-prep` and
  `coverage` were added because reader rows required glosses at those points
  and both have existing glossary entries.
- **Row 62, false. Frontmatter.** `fixtures_refs` is now
  `[hg002-chr20, hg002-long-reads, human-mito]`. Both added directories
  exist under `docs/user-manual/fixtures/`.
- **Row 48, project-manager ruling 2.** No change. The Output Strategy
  picker stays documented on all six operations. The DRIFT row claiming
  otherwise is struck.

## Changes from reader rows hit by three or more readers

All twenty-six consensus rows addressed.

- **Shape metaphor never cashed out.** The opening now defines a read first,
  says the operations rewrite or rearrange reads without throwing any away,
  and gives joining two reads as the concrete example in the same paragraph.
- **Mate used before gloss.** "The two reads from one fragment are called
  mates" now sits immediately before the first use.
- **Depth never glossed.** Correct Sequencing Errors now says "the depth of
  the whole dataset, meaning how many times each position was read across
  every read in the file."
- **Version pinning unexplained.** Before you start now says LGE "installs
  that exact version and always uses it, so your results match the numbers
  in this chapter and nothing about the version is yours to manage."
- **Library preparation and shears.** Library preparation is now glossed and
  linked, and the fragmentation is stated to be random.
- **Read count never located on screen.** The repair procedure now says to
  double-click the bundle to open its FASTQ viewport and read the Reads card
  along the top. The same pointer is repeated at the merge record count in
  Reading the results.
- **K-mer never glossed before Run.** The error-correction procedure gained
  a lead paragraph defining a k-mer, explaining that the tool counts how
  often each one appears, and giving the rule of thumb that puts k near 50
  for reads of 100 bases and longer.
- **Importing a reference never explained.** Now cross-referenced to
  `../02-sequences/01-importing-and-viewing.md`, with a clause saying it is a
  different import path from the one that brings in reads.
- **FASTQ viewport not findable.** Both mentions now say to double-click the
  bundle in the sidebar, and the Orient Reads one adds "go to its Operations
  tab."
- **K-mer rejection behaviour unstated.** The K-mer Size entry now gives the
  useful range 1 to 62, quotes the dialog's own guard message "Enter a
  positive k-mer size.", says a value above 62 surfaces as a failed
  operation in the Operations panel rather than a dialog warning, and states
  the input bundle is never modified by a failed run.
- **Where the merge report appears.** Reading the results now opens with the
  instruction to click the operation's row in the Operations panel to expand
  it, and states that every figure quoted comes from that expanded row.
- **Standard deviation not judged.** Added "A standard deviation near a
  sixth of the mean is a tight distribution for a sheared library, which is
  what a well-controlled fragmentation step produces."
- **91,148 not derived.** Now stated twice, at the pair count in Why you
  would do this and again at the Tadpole line, as the pairs counted one mate
  at a time.
- **Correction counts never reconcile.** Split into two paragraphs. The
  first counts errors, the second counts reads, with an explicit warning not
  to add the two kinds together. The 5,775 residual is now named and
  attributed, with the 4,121 rollbacks called out from the author's run log.
- **Nanopore dataset switch unflagged.** The Orient Reads result paragraph
  now names the HG002 mitochondrial reads as a different practice dataset
  and explains why, which is that Orient Reads exists for long nanopore
  reads whose strand the protocol does not fix.
- **Over-fragmentation with no next action.** Now says it is a bench problem
  rather than a software one, that the data is still usable, names merged
  reads shorter than a single read length as the sign to watch for, and says
  the fix is to shear less next time.
- **Coverage threshold never numeric.** Now "Below about 20 reads per
  position, skip this operation," with the note that coverage cannot be read
  from a FASTQ, a pointer to the Est. Coverage figure in the mapping
  chapter, and the fixture's 44.7 as the comparison. The 20 figure is
  consistent with the manual's existing framing in
  `01-foundations/02-sequencing-reads.md` and
  `05-variants/02-reading-the-variant-browser.md`.
- **Skip instruction conflicts with skipped facts.** The three facts a
  window user needed from that section (the k-mer range, the fixed reading
  frame, the dialog's record count) are now stated in the main text, and the
  skip instruction says so explicitly.
- **Tools not mapped to operations.** Before you start gained a paragraph
  saying none of these operations is written by LGE and pairing each tool
  with its operation, including the note that Reverse Complement and
  Translate are done by LGE itself.
- **File stem never glossed.** Now "the filename with its extensions
  removed," with `HG002.chr20.10.0-10.5Mb.fastq.gz` worked through.
- **Minimum Overlap advice circular.** "lower it only when you know your
  inserts are close to twice the read length" became "lower it only to
  rescue pairs that barely overlap, which a first run's reported insert size
  will tell you whether you have."
- **Dust not named as an algorithm.** Now "dust is the name of the masking
  algorithm," and poly-A tract is glossed as a long run of adenine bases.
- **Extra arguments risk unstated.** Now says an unrecognised option "makes
  the run fail outright rather than quietly producing a wrong answer."
- **Frame header not explained together.** A new paragraph states the frame
  and code table are appended to the read's original name rather than
  replacing it, glosses code table as the codon-to-amino-acid mapping with
  Standard named, and says the names are visible by double-clicking the
  output bundle.
- **Lower bound not sized.** Now "Your true average insert is higher than
  the printed one," with the size of the understatement tied to the merge
  rate.
- **Inward-pointing reads unpicturable.** Added "so the two mates point
  toward each other from opposite ends and meet in the middle if the
  fragment is short enough."

## Changes from other reader rows with a one- or two-sentence fix

- **Protein FASTA a distinct format.** Now "the same FASTA format holding
  amino acid letters instead of bases."
- **Quality averaging asserted, not explained.** Now says averaging three
  scores "would give a residue a score that describes none of the three
  measurements honestly."
- **"read and never written" misread as nothing happening.** Now "LGE reads
  the input file and never modifies it."
- **Proper order not stated.** Now "the forward read of a fragment followed
  immediately by its reverse read."
- **Broken pairing unpicturable.** The repair procedure now describes the
  healthy alternating order and what a removed partner does to every record
  after it.
- **Repair section reads as a step to reproduce.** Now "a demonstration
  rather than a step for you to repeat."
- **Whether a window user needs interleave.** Now "If you work only in the
  window you never need either one, because importing a paired sample
  already stores it interleaved."
- **Fixture unexplained.** "the practice dataset this chapter runs
  everything against."
- **Chromosome 20 slice / kb.** Now "a 500 kb region of chromosome 20,
  meaning 500,000 bases, which is under one percent of that chromosome."
- **Pairs versus reads at first use.** Both numbers now given together.
- **Assembly unglossed.** Now "assembly, where a program reconstructs long
  stretches of a genome from overlapping reads."
- **Upstream script vague.** Now "most often a filtering step that dropped
  reads from one mate file without dropping their partners from the other."
- **130 versus 129 inconsistency.** The Why you would do this paragraph now
  shows the subtraction and gives 129, matching the figure in Reading the
  results. "Roughly 130" is gone.
- **Bundle unglossed.** Now glossed at first use in Before you start.
- **Plugin Manager check required or optional.** Now "Checking is optional,
  and you only need it if an operation reports a missing tool."
- **Output Strategy named in Procedure before it is defined.** The Procedure
  now introduces it in one sentence and forward-references the Settings
  section.
- **Output Strategy repeated six times.** A lead paragraph under `## Settings`
  states the general behaviour once, including that the two choices behave
  identically with a single dataset selected, and says each entry repeats it
  because each pane shows it.
- **Strictness meaning at step 3.** Now "on Normal, which accepts any
  overlap the merger finds convincing."
- **Unit of 12 at step 3.** Now "at 12 bases."
- **Strictness segments not enumerated.** Now "offering exactly two
  settings, Normal and Strict."
- **Strictness flag mapping.** Now "Normal is the default and Strict is
  `--strict`, a switch with no value."
- **Mismatches in the joined region not observable.** Now "which you would
  notice as unexpected disagreement with a reference after mapping the
  merged reads."
- **The two 12s confusable.** Both entries now name what each counts and
  point at the other.
- **Word Length justification aimed at long reads.** Now "chosen for the
  long nanopore reads this operation is built for," which also matches the
  corrected Orient Reads results paragraph.
- **Reading frame significance.** A new paragraph before the Translate frame
  statement explains that bases are read three at a time, that a sequence
  splits three ways, and that only one split is usually real.
- **Leftover base fate.** Now "with one base left over that is discarded."
- **"No Solution" literal or paraphrase.** Now "counted on a line labelled
  'No Solution', which is the tool's own wording."
- **500-base ceiling distinction unresolvable.** Replaced the
  method-versus-library contrast with the plain cause. "The maximum observed
  insert of 482 sits just under that ceiling because the 500 bases the two
  reads span together is what causes the ceiling."
- **Reassurance placed three sentences late.** "a number that sounds
  alarming until you see that one read can hold several" now sits inside the
  same sentence as the 122,406.
- **Orient numbers out of order.** Reordered to input, forward, reverse,
  oriented, unoriented.
- **Merge rate idiom and no alternative.** "low single digits" became "under
  about 5 percent," and the alternative is now named, which is carrying the
  unmerged pairs forward since mappers and assemblers accept paired reads.
- **Where the merge rate is printed.** Now "on the joined line of the
  expanded operation row in the Operations panel."
- **Where the output record count is visible.** Now the Reads card of the
  output bundle's FASTQ viewport.
- **Duplicate collapsing never mentioned in Settings.** A paragraph after
  the Merge Output Strategy entry says the dialog always collapses identical
  merged sequences and points to Reading the results.
- **Dialog record count contradiction.** Reading the results now states
  plainly that a dialog merge of this run writes 58,915 records standing for
  all 59,117 reads, so the 59,117 figure and the dialog behaviour no longer
  appear to disagree.
- **"leans on" idiom.** Now "depends on."
- **"genuine biology" vague.** Now "real variants."
- **Frame 4 to minus 1 mapping.** Now "the reverse frames are renumbered
  from 1 on their own strand, so frames 4, 5, and 6 print as `_frame-1`,
  `_frame-2`, and `_frame-3`."
- **CLI section pulls a window reader back in.** The skip paragraph now ends
  the skip cleanly, and the sentence about where `lungfish-cli` lives moved
  into a second paragraph addressed to readers who want the terminal.
- **Bare dot link in Next.** Replaced with a named destination. "the Reads
  (FASTQ) part of the manual, which began with Importing Sequencing Reads."
- **Advanced settings disclosure unnamed.** Now "its Advanced Settings
  section, further down the same pane," matching
  `DatasetOperationsModels.swift` where `.advancedSettings.title` returns
  "Advanced Settings". Note that Orient Reads has no `DisclosureGroup` on
  that pane, so the chapter names the section rather than a control to open.

## Brand and style changes

- Chapter identity already correct. "Lungfish Genome Explorer (LGE)" at
  first mention, "LGE" after. No new violations introduced.
- No em dashes, no semicolons outside code spans, no colons inside a
  sentence. The one semicolon in the file is inside the backticked literal
  `u000001;size=3`.
- No unsourced durations added. The chapter still gives none.
- Voice: the added prose stays in the calm, precise register. No banned
  words from `ai-tells-words.txt` and no banned sentence shapes.
- No palette, typography, or caption changes were needed. The four captions
  were already brief and descriptive, and no hex or font name appears in the
  chapter.

## Deliberately left unchanged

- **Section order and section set.** Untouched, per ruling 3.
- **All twelve Settings paragraphs.** All kept, all labels verbatim, none
  added or removed. The additions inside that section are separate
  paragraphs beside the entries rather than replacements for them, so each
  entry keeps its fixed three-sentence shape.
- **The two fixed Before you start sentences.** One reader asked for a
  clause saying the Welcome window is the one shown at launch. CONSISTENCY
  fixes those two sentences and permits adjusting only the fixture name and
  file, so the clause was not added. This is a manual-wide wording question
  for the project manager rather than a chapter edit.
- **The GitHub download instruction.** One reader asked for a direct
  download link. The chapter already carries the click-the-download-button
  workaround that CONSISTENCY established, and a raw blob URL is a different
  convention that would need settling across every chapter.
- **`GLOSSARY.md`.** No entries added. `mate`, `dust`, `poly-A tract`,
  `assembly`, `file stem`, and `code table` are all glossed inline at first
  use instead, per ruling 3.
- **The DRIFT Output Strategy narrowing.** Not applied, per ruling 2.
- **Both author-reported app defects.** The interleave Phred rewrite and the
  silent empty orient output stay undocumented as behaviour. Neither is a
  fidelity error in the chapter, and the chapter's existing instruction to
  compare orient input and output counts remains the reader's protection.
- **`mkdocs.yml` and every other chapter.** Untouched.

## For the project manager

- The Welcome window gloss and the direct-download link are both
  CONSISTENCY-level wording questions rather than chapter edits. Flagged
  above, not applied.
- The coverage threshold of 20 reads per position for error correction is my
  own synthesis from the manual's existing depth guidance rather than a
  figure any source document states for Tadpole specifically. Worth a
  ruling if you want a sourced number instead.

## Verbatim lint output

```
$ LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/08-read-processing.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/08-read-processing.md: no issues found
```

Passed on the first run after editing. No lint fixes were needed.

## Status

brand_reviewed: true
