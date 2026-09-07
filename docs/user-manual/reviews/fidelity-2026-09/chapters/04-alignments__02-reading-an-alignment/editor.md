# Editor report, 04-alignments/02-reading-an-alignment

Date: 2026-09-07
Role: brand-copy-editor
Inputs: `fidelity.md` (62 true, 4 false, 1 unverifiable), `readers.md`
(merged four-reader synthesis, 93 rows, Consensus section), `author.md`,
`CONSISTENCY.md` (Folders section updated 2026-09-07 for this chapter),
`STYLE.md`, and the project manager's five binding rulings.

The previous editor on this chapter was interrupted before writing anything,
so the starting text was the author's. Baseline lint was already green.

## Change counts by source

| Source | Changes |
|---|---|
| Fidelity, false rows | 5 |
| Fidelity, unverifiable row | 1 |
| Ruling 3, step numbering | 3 |
| Fidelity, other findings (captions, front matter) | 3 |
| Reader rows hit by 3 or more readers | 30 |
| Reader rows hit by 1 or 2, fixable in a sentence or two | 36 |
| Consistency sheet | 2 |
| Style and brand | 3 |
| Source-verified corrections to my own drafting | 3 |

## Fidelity, false rows (ruling 1)

1. **Strand-split coverage curve.** "What it is" no longer says the coverage
   curve is split into a forward band and a reverse band. It now reads "The
   coverage curve underneath is a single band rather than two, the total
   depth at each position whichever strand the reads came from." Step 2 and
   the "Reading the results" coverage section carry the same correction.
   Source: fidelity row on `ReadTrackRenderer.swift:406-500`, where the live
   `depthPoints` overload fills with `forwardCoverageColor` alone and
   `CoveragePoint` has no strand field.

2. **The coverage label.** Step 2 no longer claims the label reads `max: 79x`
   alone and later "gains the average". It now says LGE prints both figures
   together as `max: 79x  mean: 44.7x` at the right-hand edge, and describes
   the `Depth` key and the `100% covered` figure at the left-hand edge. It
   also states that both figures are recomputed for the visible window, which
   answers a reader row as well. Source: fidelity row on
   `ReadTrackRenderer.swift:486-500`.

3. **Show BAM in Finder.** The post-procedure paragraph now names **Show BAM
   in Finder** for this chapter's BAM track and notes that a CRAM or SAM
   track reads **Show Alignment File in Finder** instead. Source: fidelity
   row on `SequenceViewerView+Interaction.swift:938`.

4. **Est. Coverage.** The Inspector summary paragraph now reads 27.3x rather
   than 44.7x for Est. Coverage, explains that it is the mapped record count
   times an assumed 150-base read length over the reference length, notes
   this fixture's reads average about 249 bases, and directs the reader to
   the coverage curve's measured `mean:` of 44.7x. It cross-references
   [Mapping Reads to a Reference], which settles the same field the same way.
   Source: fidelity row on `ReadStyleSection.swift:946-951`.

5. **The extraction destination.** Procedure step 5 and the **(the save
   destination)** setting both now say no save panel opens for a track inside
   a project, and that the bundle lands in an `alignment-read-extractions/`
   folder inside the mapping run's own folder under `Analyses/`, or under the
   project root when the track has no run folder, named for the selection
   plus a unique identifier. The two sentences putting extractions in
   `Extractions/` and forbidding `Imports/` are gone, since that folder
   belongs to the classifier extraction path. The bold label **(the save
   destination).** is unchanged. Source: fidelity row on
   `AlignmentScientificActionCoordinator.swift:41-45` and
   `ViewerViewController+Mapping.swift:820-830`, and CONSISTENCY.md's Folders
   section as amended 2026-09-07.

## Fidelity, unverifiable row (ruling 2)

6. **"the first eligible track".** The claim was verified only for the
   primer-trim dialog and was stated for all six Analysis dialogs. Hedged
   rather than dropped, per the fidelity review's own suggestion. It now
   reads "It picks the first eligible track in the bundle, meaning the first
   sorted, indexed alignment attached to that reference, and that is not
   always the track you had selected. So read the picker at the top of the
   dialog and confirm it names the track you meant." The instruction to check
   the picker carries the reader's weight rather than the generalisation.
   This also serves two reader rows, on what makes a track eligible and on
   the double-negative phrasing.

## Step numbering (ruling 3)

7. The last procedure step is renumbered from `6.` to `5.`, so the steps run
   1 through 5.
8. The Settings lead-in cross-reference now reads "The extraction in step 5".
9. The "On the command line" cross-reference now reads "the extraction in
   step 5". The Procedure lead-in also changed from "The last one" to "The
   fifth" so the count is explicit.

## Fidelity, other findings

10. **`bam-viewport-overview` caption** rewritten to name the whole coverage
    strip, the Depth key and percent-covered figure at the left edge and the
    max and mean label at the right, so the Screenshot Scout frames it.
11. **`extract-reads-region-menu` caption** rewritten to name the two items
    that actually sit between Copy Visible Region and the extraction item.
12. **`glossary_refs`** edited per ruling 4. Dropped the unused `read-group`.
    Added the eight anchors the body now links, `read`, `mapper`,
    `reference-bundle`, `shotgun`, `homozygous`, `heterozygous`, `amplicon`,
    and `phred-score`. All 24 resolve in `GLOSSARY.md`, and every declared
    ref is now linked in the body, including `extraction` and
    `secondary-alignment`, which were declared but unlinked before.

## Reader rows hit by three or more readers

Every row in the readers.md Consensus section is addressed. Grouped by where
the fix landed.

**What it is.** "Above roughly 2 bases per pixel" became "Zoomed out past 2
bases per pixel" so the prose and the quoted message agree. BAM is spelled out
as Binary Alignment Map in the sentence that first uses it. The mapper is
named as the program that places reads. "Read" is glossed as a noun at first
use. The direction of the bases-per-pixel scale is stated, that a smaller
number means more zoomed in. The three zoom tiers are named (coverage, bar,
base) and the switching is stated to be automatic with no button. Depth,
coverage, and percent-covered are separated in their own paragraph. Reverse
tinting is confirmed as the normal expected outcome. The status bar's position
along the bottom of the window is stated at first mention. The reference row
is added to the band description. Soft clipping is defined before its drawing
is described, and whether clipped bases count toward depth is stated.

**Why you would do this.** Artefact is glossed as a false signal made by the
method rather than the sample. HG002 is explained as a benchmark human genome
with a published truth set. Illumina is named as a sequencing platform.
"500 kb" is spelled out as 500 kilobases here and everywhere else in the
chapter.

**Before you start.** The prerequisite chapter is named in the first
paragraph. GitHub download is explained (no folder download, use Download raw
file on each of the three needed files). The samtools paragraph now leads with
"There is nothing to install by hand." The Plugin Manager row to look for is
named. A missing-tool blank is distinguished from a real coverage hole.

**Procedure.** `Cmd-=` and `Cmd--` are written in words as holding Command and
pressing the equals or the minus key. A target zoom is given, below 0.6 bases
per pixel for the base tier. The three navigation routes are split into
separate sentences. The extraction step says which band accepts the drag, that
the whole read is written rather than the overlapping part, and what a
`.lungfishfastq` bundle is (a folder macOS shows as one file). Each of the two
read-level menu items gets a sentence saying which situation calls for it.

**Settings.** The introduction is rewritten for a reader who only uses the
app and scopes the no-flag claim to the sixteen viewer settings, removing the
contradiction with the two settings that do name flags. The two parenthetical
settings get a sentence explaining that neither has an on-screen label and
that lowercase parentheses mark a description rather than a control. Mapping
quality's 0 to 60 scale is stated with what 30 means. The three read-count
totals (91,203 records, 91,148 primary, 90,990 mapped, 90,935 primary mapped)
are reconciled once in a paragraph after the introduction. The 500,000 display
budget ceiling is marked as a different limit from the two-million Load all
ceiling, in both places. The Coverage scale paragraph says a compressed scale
shrinks tall peaks so short ones stay visible.

**Reading the results.** Depth, percent-covered, and the coverage curve are
distinguished with where each is found. The ten-read reasoning is spelled out
arithmetically (one error in three versus one in twenty) and called a working
convention rather than a law. Shotgun is glossed and the GC-dip mechanism
explained. The homozygous case is named, with heterozygous given as the
roughly 25-of-51 contrast. The banner's 620,000 is marked as an example from a
deeper dataset. "Fixed stride" became "keeping every Nth read". Each of the
six Analysis operations gets a clause saying what it does. The Extracted 91148
figure is reconciled against Total Mapped of 90,990 in the command-line
section.

**What good looks like.** A soft-clip threshold is given, under about 10
percent unremarkable and above a quarter worth chasing, with a note that LGE
does not print the figure so it is read off the picture.

**On the command line.** The section now opens with a line saying it is
optional for readers using the app.

## Reader rows hit by one or two readers, fixed in a sentence or two

Cmd shortcuts explained as keys held rather than text typed. BAM travels with
an index file, stated in the first paragraph, and index glossed as a lookup
table. BAM, CRAM and SAM differences named with which one a sequencing core
hands over. GRCh38 named as the standard human reference build. minimap2
glossed as the aligner. The mapping run folder's purpose stated. Position
2,078 stated as slice-relative and to be typed without a comma. Zoom Reset
stated to centre on the current position. The reference row stated to appear
only at the base tier. "Both rows" replaced by naming the reference row and
the read rows. Base colours stated to be LGE's own and not adjustable. The
47x tooltip marked as a format example, the tooltip given as one literal form,
and "the status bar does not report depth" given an explicit subject. The
range the mean is computed over stated. Visible Alignment gained a forward
pointer to the primer-trimming chapter. "Confidence" tied explicitly to
mapping quality. Amplicon linked at its Coverage scale mention and the
compressed-axis label quoted from source. Include secondary alignments states
up front that this fixture has none. Limit visible rows explained in the
manual's own words instead of the quoted in-app text. Read display budget
gained a rough rule for the reader's own data. The colour "wells" became
colour swatches. Whether the reader's numbers should match is stated. Allele
frequency marked as a read-level fraction, not the population figure. Why a
caller reports a base the reference lacks is answered by saying the reference
is one composite sequence, not an infallible rule. The 51 is stated to be the
depth. An acceptable strand-split range is given, with 45 and 6 as the case
to stop at. Q is defined before the figures that use it, higher stated to be
better, a typical Q20 percentage given, and the Range given an interpretation.
Why only insertions are listed is answered. Why Est. Coverage needs a single
contig is stated. Provenance is explained in the chapter's own words. The
Analysis section is described as six buttons rather than a grid. Packing is
explained and the loading badge located. Escape is stated to be recoverable.
The 31 zero positions are stated to be scattered singles. The unmappable case
is described as depth thinning gradually. The viewport-settings metaphor is
replaced by a plain statement. The BAM path and the region name are sourced
(Show BAM in Finder, and the reference FASTA header). The four CLI flags
became a four-item list. "Bare" is defined by contrast. The mpileup output is
described. The installed samtools path is given. The CLI region defect is
stated not to affect the app path. How to tell an amplicon panel is answered
in Next. This fixture is stated to be a single contig in What good looks like.
Empty stored sequence is stated to be normal for secondary and supplementary
records.

## Consistency sheet

- The extraction destination follows the Folders exception added 2026-09-07,
  which is the same wording ruling 1 gives.
- Fixture named as "the HG002 chromosome 20 slice" throughout, unchanged.

## Style and brand

- Voice tightened toward Trustworthy and calm in the samtools paragraph and
  the optional-section opener, both of which now reassure before they inform.
- `estimated_reading_min` raised from 20 to 30. The body grew from about
  5,200 to about 8,160 words, and the sibling chapters in this part run at
  roughly 200 to 250 words per minute (25 minutes for 6,145 words, 22 for
  4,139).
- `brand_reviewed` flipped to `true`. `lead_approved` untouched.

## Corrections to my own drafting, caught against source

Three figures I drafted from inference were checked against the Swift sources
and corrected before the final lint.

- I first wrote that the compressed-axis label reads `Coverage (log10)` or
  `Coverage (sqrt)`. `CoverageScaleMode.axisLabel` gives `log₁₀` and `√`, and
  `ReadTrackRenderer.swift:486` builds the key as `Depth (log₁₀)`. Corrected.
- I first wrote that base letters arrive at roughly 0.1 bases per pixel.
  `ReadViewportPolicy.baseThresholdBpPerPx` is 0.6, and
  `matchLetterThresholdPxPerBase` is 4.0 px per base, so matched bases become
  letters below 0.25 bases per pixel. Both figures corrected and both stated.
- I first cross-referenced the Est. Coverage explanation to Alignment Quality.
  Chapter 22 is Mapping Reads to a Reference, which carries that explanation
  at its lines 154 and 156. Corrected, and my wording aligned with that
  chapter's settled phrasing, "the 150-base estimate of that same figure".

The `100% covered` figure in step 2 is computed rather than measured. The
fixture's breadth is 99.9938% and `ReadTrackRenderer.swift:498` formats it as
`\(Int(coveragePct.rounded()))% covered`, which rounds to 100.

## Left unchanged, deliberately

- **Section order and the settings roster.** Per ruling 4, no section moved
  and all 18 settings paragraphs remain with their bold labels verbatim and
  in registry order.
- **Other chapters, GLOSSARY.md, and parameters.yaml.** Not touched. The
  registry `notes` for `bam.extract-reads-in-region` still contain the two
  errors the fidelity review flagged, "asking only where to save" and
  "Extractions belong in the project's Extractions folder", even though the
  `default` and `allowed` fields have been corrected. That is a registry
  defect outside my authority, flagged below.
- **The one-sentence flagless claim.** CONSISTENCY.md asks for "This setting
  has no command-line flag." on each flagless setting. The chapter still
  states it once for the sixteen viewer settings rather than sixteen times.
  The fidelity review asked for a lead ruling rather than a fix, and my
  rewrite of the Settings introduction makes the scope explicit and removes
  the contradiction two readers found. Flagged below.
- **Reader rows needing a screenshot or a structural change.** Two rows asked
  for the pileup figure to be moved beside the "single column" sentence in
  What it is, and for the arrow keys to be given a table. Both are structural
  and belong to the Documentation Lead and the Screenshot Scout. The column
  sentence was reworded instead so it can be pictured without a figure.
- **The `read-group` glossary entry.** Removed from `glossary_refs` rather
  than given a body mention. The read-group panel appears only on
  multi-read-group alignments, which this fixture is not, so the author's
  decision to leave it out of the body stands.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/04-alignments/02-reading-an-alignment.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/04-alignments/02-reading-an-alignment.md: no issues found
```

Green on the first run after the edits and on every rerun since. No linter
findings had to be fixed.

## For the project manager

1. `parameters.yaml`'s `bam.extract-reads-in-region` `notes` field still says
   the operation runs "asking only where to save" and that "Extractions
   belong in the project's Extractions folder, never in Imports". The
   `default` and `allowed` fields were corrected, so the entry is now
   internally inconsistent. Outside my authority to edit.
2. The flagless-setting sentence convention (CONSISTENCY.md, Settings
   entries) still needs a ruling. Applying it literally would add sixteen
   identical sentences to this chapter.

## Status

brand_reviewed: true
