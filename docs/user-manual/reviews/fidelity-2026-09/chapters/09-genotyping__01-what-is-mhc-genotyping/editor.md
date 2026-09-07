# Editor pass: 09-genotyping/01-what-is-mhc-genotyping

Date: 2026-09-07. Roster row 53. Brand copy editor.

Inputs read in full: `author.md`, `fidelity.md` (57 claims, including the Notes
for the editor section), `readers.md` (93 merged rows, 29 in Consensus), and
`CONSISTENCY.md`. The Williams project was read read-only for verification.
Nothing outside this chapter and `GLOSSARY.md` was edited.

## False claims fixed

**Claim 14, the group-record example.** The chapter quoted
`01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_02`, dropping the middle member. It
now carries the library's record verbatim,
`01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_01_01_02,A1_001_02`, and the
surrounding prose says "Here that is three alleles under one name" so the
count is visible rather than implied. Verified byte for byte against
`26128_ipd-mhc-mamu-2021-07-09.lungfishref/genome/sequence.fa.gz`.

Claims 56 and 57 are author-log arithmetic slips that reach no reader. No
chapter text carried them, so nothing was changed here.

**Claim 30, the unverifiable pass-rate heuristic.** Hedged rather than
deleted, per instruction. The sentence now names the circularity mechanism
explicitly and the retention figure is framed as "a single point of
orientation rather than as a target".

## Rulings applied

**(a) Amplicon lengths are modes.** Applied with the reviewer's wording. The
sentence now reads "the class I amplicons are about 156 bases and the longest
DRB amplicons are 244". The 156 figure in the allele-names section already
carried "about" and was left.

**(b) Trailing ellipsis on every enabled workflow submenu item.** Applied in
both places. The body now writes **12S Amplicon Matching...** and the
`genotyping-submenu` caption matches. The first two already carried it.

**(c) Enabling route through the Workflow Library.** The chapter previously
said only that enabling "happens in the Workflow Library". It now carries the
click sequence in a new `### Enabling a genotyping workflow` subsection, taken
from the committed 12S chapter's identical route
(`06-classification/10-twelve-s-metabarcoding.md:78-80`) and confirmed against
`WorkflowLibrary.swift:137-186` (all three genotyping items are `.specialized`)
and `WorkflowLibraryPanelView.swift:343-355` (the **Enabled** switch and the
**Install Dependencies** button). Route: **Tools > Workflow Library...**, the
card under the **Specialized Workflows** heading in the **Genotyping** group,
then its **Enabled** switch.

**(d) The discarded-read tally must add up.** It did not, and the reason was
not a missing category. The three counters tally *alignment records*, not
input reads, which is why they could never subtract from 2,854,092. From
`amplicon-genotyping_3.retained_demux_stats.json`, `totalAlignments` is
1,515,819 and the four `passCounters` sum to exactly that
(682,928 + 224,134 + 311,914 + 296,843 = 1,515,819, verified). The paragraph
now states the total, says the four categories are exhaustive and sum to it
exactly, and gives the three rejection categories' own sum of 832,891. This
corrects a real misreading the chapter invited rather than only papering over
the arithmetic.

**(e) Indels tolerated, substitutions not.** Rewritten from source, not
guesswork. `md_mismatch_count`
(`ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:319-338`) walks the MD tag,
skips `^` deletion runs, and counts only alphabetic substitutions. Insertions
never appear in MD at all. So the matcher does not "tolerate" indels as a
biological allowance, it simply never counts them, while `reference_span_is_full`
still forces coverage of every reference base. The chapter now says the
counted quantity is substitutions, that the record it counts from does not
expose indels, and closes with "Treat the rule as exact matching over the full
length, with the narrow exception that a gap does not get counted as a
mismatch." This removes the contradiction the readers heard.

**(f) No invented read-count thresholds.** Applied, with one correction to the
brief. The app *does* define a threshold, which neither the author nor the
reviewer recorded: `GenotypeCohortSubjectBuilder.swift:175-184` and
`InspectorViewController+PublicAPI.swift:742-747` mark a sample Low Support
below 1,000 unique reads or 20 alignments, and Review at zero. There is also a
third status, `review`, that the chapter never mentioned. The chapter now
states the real rule and the three statuses, then says plainly that LGE defines
no read count at which an *empty cell* becomes trustworthy, and gives the
Williams range (2 to 58,370, Low Support topping out at 713, OK starting at
1,976) as orientation. No number was invented.

**(g) Manual haplotyping.** One sentence in Next, never walked through, and it
now says plainly it "is not documented in this release".

**(h) Nav titles.** `mkdocs.yml` and all three sibling chapters were not
touched. File timestamps confirm only this chapter and `GLOSSARY.md` changed.

**(i) Shot id.** `genotype-matrix-overview` kept here, marker and `shots` entry
both intact.

**(j) Glossing.** Every Consensus term glossed at first use in one clause:
read, alignment, primer, mode, MCM, PCR, paired reads, mate, call, resolution,
clustering, assay, depth, coordinate, homozygous, recombination, T cell,
pedigree work, arm, quality score, ONT, bundle, segmented toggle.

## Consensus rows

All 29 applied. The three that needed the most work were the 156-base
comparison (now set against "several thousand bases across all its parts" for
the whole gene), the `g1` marker (the `g` and its digit are both explained
where the example appears), and the 2,109-row reconciliation (one row per
called allele per sample, with the real 2 to 117 per-sample range added and
verified from the CSV).

## Other merged rows

Of the remaining 64 rows, 61 applied and 3 skipped.

- **"Give a concrete read-count floor instead of a described shape or gap."**
  Skipped. Conflicts with ruling (f). Replaced with the separation test plus
  the Williams range.
- **"Add a number comparing MHC variation to a typical non-immune gene."**
  Skipped. No source in the repository or the Williams project supports a
  figure, and inventing one is what ruling (f) forbids in the read-count case.
- **"Say how often novel alleles turn up in practice."** Skipped. The manual
  holds no full-length run and no fixture, so any frequency would be invented.
  The author already recorded that this route is unverified.

## Corrections made beyond the reports

Three claims I introduced or inherited did not survive checking, and were
fixed rather than shipped.

1. I had written a worked coordinate `chr6:29944214 A>G` as the variant-calling
   contrast. It is a fabricated human coordinate in a macaque chapter. Replaced
   with a generic description of what a coordinate is.
2. I had written that the `.lungfishgenotype` bundle opens in Finder with
   right-click and Show Package Contents. No `UTExportedTypeDeclarations` entry
   for the extension exists in the installed Preview app, and on disk the
   bundle is a plain directory. Corrected to an ordinary folder.
3. The author's "970 allele targets" is right, but "the whole catalogue for the
   species" is not checkable from the bundle. Hedged, and the verified fact that
   362 of the 970 records are groups was added instead.

## Glossary changes

Two entries added, both alphabetically placed and both added to
`glossary_refs`.

- `**MCM (Mauritian cynomolgus macaque)**{#mcm}`, inserted before `{#mhc}`.
- `**PCR (Polymerase Chain Reaction)**{#pcr}`, inserted before `{#pcr-duplicate}`.

No existing entry was edited. `glossary_refs` grew from 20 to 28 anchors, all
28 verified to resolve to exactly one `{#anchor}`, and 27 of the 28 are now
linked inline in the body.

## Style

Zero em dashes, zero semicolons, zero in-sentence colons. Mean sentence length
18.5 words across 242 sentences, longest 34. Template section order unchanged.
`brand_reviewed` and `lead_approved` both left at `false`. Both
`<!-- SHOT: -->` markers still match their `shots` entries.

## Lint

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/01-what-is-mhc-genotyping.md: no issues found
```
