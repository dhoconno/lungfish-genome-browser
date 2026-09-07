# Editor pass: 09-genotyping/02-running-genotyping

Chapter: `docs/user-manual/chapters/09-genotyping/02-running-genotyping.md`
Roster row 54. Date 2026-09-07. Inputs read in order: `author.md`, `fidelity.md`,
`readers.md`, `CONSISTENCY.md`, and the committed sibling `01-what-is-mhc-genotyping.md`.
`brand_reviewed` and `lead_approved` both left at `false`.

## False claims fixed

All seven acted on, with the reviewer's corrected wording.

| # | What it said | What it says now |
|---|---|---|
| 6 | The Reference control is labelled differently on the two routes | The group is headed **Reference** and its menu **Project Reference** on both routes. The **Project Reference** Settings entry now covers both, and a short **Reference.** entry says it is the same control, which the registry still requires by label. |
| 12 | Merge message truncated at "...can be genotyped." | Quoted in full, ending "Import with the Illumina Amplicon Merge recipe to do this at import time instead." |
| 20 | "The Williams project holds four such runs side by side." | "several such runs side by side", since the folder holds seven bundle directories. |
| 26 | No input minimum for `genotype-cohort` | "needs at least two `.lungfishfastq` bundles", with the rejection message quoted and `fastq genotype` named as the single-sample route. |
| 27 | The 84 percent failure blamed on a world-writable directory | Rewritten to the real cause. A path spelled `/private/tmp/...` fails because LGE compares the two paths in different spellings. The same folder as `/tmp/...` works. The advice that follows is to write inside the project or the home folder. "World-writable" is gone, as is the claim that any `/tmp` path fails. |
| 33 | "between 80 and 117 allele rows each" | "between 45 and 117 allele rows each", with the median of 80 named separately as a median across all 30 samples. |
| 34 | "80 or more allele rows is a working sample" | Row-count floor dropped entirely. The paragraph now splits the plate by the app's own OK and Low Support labels. |

## Project manager rulings

**(a) Claim 35, settled by CONSISTENCY.** The chapter now uses the app's split at
1,000 retained unique reads, 23 OK and 7 Low Support, in Reading the results and
in What good looks like. Its own 100-read line is gone. Where it says how to spot
a failed sample it points at the Low Support label and gives the Williams ranges
(OK 1,976 to 58,370, Low Support 2 to 713) as orientation. No line of its own is
drawn anywhere.

**(b) Two runs, labelled at every mention.** Reading the results opens with a
sentence saying the two figures are different runs. Every mention now carries its
label, "the whole plate" (682,927 of 2,854,092, 23.9 percent) or "the three-bundle
reproduction" (119,146 of 505,528, 23.6 percent). What it is now quotes the plate's
23.9 percent rather than the reproduction's 23.6, so the headline figure matches
chapter 01. The 682,927 against 682,928 is settled in the drop-count paragraph:
the four counts count alignments, the retained figure counts reads, and a read on
several targets contributes several alignments. This is chapter 01's own framing.

**(c) The 2x251 sentence.** Rewritten as four sentences in step 3, following
chapter 01's wording. Mate, insert, and chemistry are each named once and glossed
once, and the 156 and 244 comparisons are split so each amplicon gets its own
sentence. `insert-size` is linked from the glossary.

**(d) Min Reads defect.** Stated inside the Min Reads Settings paragraph itself in
one sentence, as the second sentence of the entry. It is also stated in What good
looks like, where the reader is told which mode is affected and what to do instead.

**(e) Haplotype analysis.** Now one sentence, saying the run dialog's haplotype
definition choice is not documented in this release, and nothing more. The
"(placeholder)" suffix is dropped from the heading.

**(f) Before you start.** One paragraph now says the Williams project does not
ship, that there is no substitute dataset, and that a reader follows along with
their own MiSeq amplicon run. It names both bundle shapes the run needs and links
`02-sequences/01-importing-and-viewing`
for how a reference bundle gets into a project, alongside the FASTQ import link.

**(g) Command-line-only flags.** Moved under a new `### Options that exist only on
the command line` subheading inside Settings, opened with one sentence telling the
window reader to skip to Reading the results. Every window setting keeps its
closing flag sentence, and the Settings lead-in now says the closers are for
scripting readers rather than telling them to skip.

**(h) Multi-select modifier.** Step 1 now names Cmd-click for individual rows and
Shift-click for a range, taken from the manual's earlier chapters.

**(i) Glosses at first use.** wall time, pbAA, cDNA, API access, insert, allele
target, plus mate, chemistry, substitution, consensus sequence, bundle, BAM,
mapping, primer, sequencing depth, colony, present, pooled, class I, class II,
DRB, adapter dimer, off-target product, determinism, headless, exit status
(rephrased to "whether that step succeeded"), and the three-key shortcut form.
Each in one clause at first use.

**(j) No invented numbers.** Nothing new was introduced. Where a reader asked for
a scale the app does not define, the chapter says so and gives the Williams range.
This applies at the retained fraction, at the Low Support judgement, and at the
Min Reads workaround, each of which now says LGE defines no threshold.

**(k) Shot markers.** All five kept with their `shots` entries unchanged. Verified
by grep that none of the five ids appears in any other chapter, and that none of
`genotype-matrix-overview`, `genotype-matrix-reading`, `genotype-inspector-display`,
`genotype-inspector-export`, `genotype-export-save-panel`, or
`genotype-pivot-workbook` appears in this one.

## Rows applied

**Consensus section, 27 rows. 27 applied, 0 skipped.**

**Other merged rows, 79 remaining after the consensus 27. 74 applied, 5 skipped.**

Skips, with reasons:

- Row 19 and row 97, moving the command-line flag names into a table or a separate
  column. Conflicts with the template, which fixes the three-sentence Settings
  shape ending in the flag sentence, and with ruling (g), which keeps that closing
  sentence on every window setting. The lead-in was reworded instead.
- Row 22, removing the Haplotype analysis section entirely. Ruling (e) fixes it as
  one sentence, so the section stays.
- Row 29, keeping only one of the two failure rules. Ruling (a) supersedes it. Both
  the old 100-read line and the "no threshold needed" sentence are gone, replaced
  by the app's label.
- Row 47's request for a row-count judgement and row 67's request for a typical DRB
  row count. Ruling (j) forbids inventing a number the app does not define. Each
  was answered with the reason rather than a count: why a sample yields dozens of
  rows, and why one solid DRB row suffices when the check is for total absence.

## Glossary changes

Three entries added to `docs/user-manual/GLOSSARY.md`, each alphabetically placed
and each a single anchor:

- **API access**{#api-access}, before "Alu element".
- **cDNA**{#cdna}, before "CDS (coding sequence)".
- **Wall time**{#wall-time}, before "Wastewater Surveillance pack".

`glossary_refs` grew from 26 to 35 terms, adding `adapter`, `api-access`, `bam`,
`bundle`, `cdna`, `consensus-sequence`, `insert-size`, `primer`, and `wall-time`.
`pbaa`, `allele-target`, and `exit-status` already existed and were already or are
now linked. Verified that every term in `glossary_refs` resolves to exactly one
anchor and is linked from the body, and that no body link is missing from
`glossary_refs`.

## Brand and style

No em dashes, no semicolons, no colons inside a sentence. No word from
`ai-tells-words.txt`. Mean sentence length 19.0 words across 386 body sentences,
with the long-sentence tail split, including the three the readers named
(Project Reference's 60-word opener, Orient Reference's "since" clause, and the
two-directional 156/244 comparison). Template section order unchanged.
"Lungfish Genome Explorer" at first mention, "LGE" thereafter.
`brand_reviewed: false` and `lead_approved: false` both untouched.

## Lint

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/02-running-genotyping.md: no issues found
