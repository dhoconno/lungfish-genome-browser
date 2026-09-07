# Editor report: 09-genotyping/03-reading-the-genotype-comparison

Roster row 55. Brand copy editor pass, 2026-09-07, against the fidelity report
(80 claims, 7 false), the merged reader report (87 rows, 31 consensus), the
project manager rulings, and `CONSISTENCY.md`, in particular its binding
"Genotyping sample status" section.

## False claims fixed

All seven, using the fidelity reviewer's corrected wording.

| # | Was | Now |
|---|---|---|
| 7 | The detail pane "shows either a cohort-wide summary or, once you pick a sample, that sample's own evidence." | "A detail pane beside the grid stays blank until you pick a sample, and then shows that sample's own evidence." (What it is) |
| 22 | "With no sample selected it shows the cohort summary" | Step 2 rewritten. It now opens by saying there is no cohort-wide summary on this result and the pane is blank until a sample is clicked. |
| 31 | "the detail pane switches from the cohort summary to that sample" | "Click a sample's column header and the detail pane fills with that sample's evidence." (step 3) |
| 45 | "The **Smart Cohorts** section above it saves a filter you have set" | Paragraph cut from step 4 per ruling (b). The term survives only in the command-line section, glossed in place where `list-cohorts` reports it. |
| 47 | "it seeds none, so the section reads \"No saved cohorts.\" until you press **Save Current Filter…**" | Cut with the same paragraph. No unreachable string or inert button is described anywhere. |
| 54 | The read-only case "grows a red banner" on the cohort summary | Rewritten without the banner, since it is a cohort-summary element a genotype-only reader never sees. Step 5 now states the consequence directly, that edits are kept in memory only and do not persist. |
| 77 | `list-cohorts` output is "the command-line view of the empty Smart Cohorts section described in step 4" | "the command-line confirmation that a genotype-only result carries no saved cohorts." |

## Rulings applied

**(a) Step 2 rewritten.** Retitled "Judge the depth of the whole run". It now
tells the reader the detail pane starts blank until a sample is selected, that
the in-window cohort summary belongs to a haplotyped result and is not
documented here, and that the cohort-level depth judgement comes from
`genotype list-samples`. The author's reading order, depth before biology, is
kept and stated explicitly as the point of the step. The `genotype-cohort-summary`
shot and its `shots` entry were removed with the panel, leaving three shots.

**(b) Smart Cohorts paragraph cut** from step 4. The `smart-cohort` glossary
entry is untouched and stays listed in `glossary_refs`, since the term is still
used once, in the command-line section.

**(c) Inspector tabs named** at every route. "the **Genotype Display** section
of the Inspector's View tab" in step 4 and again in the Settings lead, and "the
**Matrix Annotations** section of the Inspector's Annotations tab" in step 5.
What it is now says the Inspector's controls are spread across its tabs.

**(d) Shot renamed.** `genotype-matrix-overview` is now
`genotype-matrix-reading` in both the `shots` entry and the `<!-- SHOT: -->`
marker, with this chapter's caption kept verbatim. Chapter 01 keeps the
original id and was not touched.

**(e) Three depth numbers stated once.** Step 2 carries the statement, at the
first of the three. It gives the app's 1,000-read split for `ok` and
`lowSupport` as the run's own line, then says the Call-support check reuses
1,000 with a second alignment test and the 5,000 default belongs to a
haplotyped result and plays no part here. No threshold the app does not define
appears anywhere. Where readers asked for a middle-ground cutoff, step 2 says
LGE defines none beyond 1,000 and offers the observed Williams range as
orientation, thinnest trustworthy sample just under 2,000 reads and deepest
failure at 713. "What good looks like" check 2 restates the 1,000-read line
rather than inventing a second rule.

**(f) Locus-count check given a surface.** The check is kept and pointed at
`top_calls_by_locus` in `genotype list-samples`, which names the top call at
each locus reached, so counting its entries gives the number. Verified against
the bundle's own `genotype-reviewable-rows.json`, which confirms 13 loci, `ok`
samples covering 11 to 13 and `lowSupport` samples as few as 2.

**(g) Wording fixes.** The haplotyped result's section title is not quoted at
all now that step 2 no longer documents that panel, so no `Below N reads`
string survives to be wrong. The Rows and Columns menu items name their axis
("Hide Selected Rows, Show Only Selected Rows, and Show All Rows, and the
Columns equivalents"). The call-support caveat names haplotype assignments.

**(h) Allele name parsed once.** In Reading the results, in one sentence,
using chapter 01's scheme, the leading number grouping by locus family, the
locus, the `g` marking a group record, and the members after the bar. Step 1's
plain-name example is parsed the same way and the long-name sentence refers
back to it rather than repeating the scheme.

**(i) Orders of magnitude cut.** The claim did not match the numbers, since
713 to 1,976 is under a threefold gap. Verified against the per-sample read
counts. The sentence is gone and step 2 reports the two ranges plainly instead.

**(j) Exact matching said once early.** In What it is, one sentence saying
there is no similarity percentage to set anywhere in LGE, unlike an assembler
that lets you accept a 98 percent match. The later "strict matching test"
wording is gone and the chapter uses one name for the rule throughout.

**(k) Terms glossed at first use.** New inline glosses for read, alignment,
bundle, reference library, panel, call, MiSeq, IPD-MHC and Mamu, amplicon
length, homozygous, quality score, group record, pivot sheet, result workbook,
`gs_id`, provenance file, hidden cell, and the trailing-dots convention. Nine
terms added to `glossary_refs` (alignment, bundle, homozygous, ipd-mhc, miseq,
operations-panel, read, plus the retained allele, genotype and others already
present). No new `GLOSSARY.md` entries were needed, since every term already
had an anchor, verified by anchor check.

**(l) Manual haplotyping stays one sentence** in Next, as a placeholder
saying this release of the manual does not document it.

## Reader rows

**Consensus rows: 31 of 31 applied.** Every row hit by three or more readers is
addressed in the body, including the fraction-filled figure (about 7 percent,
with "past a tenth" as the check-the-run line), the alignment gloss with why
the count exceeds the read count, the two thresholds explained by what each
guards against, the em rule renamed a long dash, the workbook introduced once
and named consistently, the 13 loci given a readable surface, the command-line
section's independence stated up front, the Control-click alternative, the
Operations panel menu path, and the replay paragraph reduced to one purpose
with a skip instruction.

**Other rows: 48 applied, 8 skipped.**

Skipped, with reason.

1. *List the 13 locus names in this chapter.* Chapter 01 lists them and
   CONSISTENCY forbids restating a sibling's primer. Ruling (f) is satisfied by
   the `top_calls_by_locus` surface instead.
2. *Expand MCM in the placeholder.* The placeholder is two fixed sentences,
   verbatim, under CONSISTENCY's recurring-sentences rule.
3. *Use a Williams value in the `Cohort=` example.* The Williams samples carry
   no imported metadata, so no real value exists. The chapter says so and
   presents the syntax as syntax.
4. *Say roughly how many samples the one-standard-deviation flag catches.*
   That flag is part of the cohort summary panel, cut under ruling (a).
5. *Say how to see the full list when a tooltip caps at eight samples.* Same
   panel, same cut.
6. *Reconcile the 5,000 threshold with the OK range.* Same panel. Ruling (e)
   handles the surviving threshold question directly.
7. *Say how to sort a column, or drop the mention.* Sorting survives only in
   the "display state and nothing more" sentence, which is a fidelity-verified
   claim about what does not change a call rather than an instruction.
8. *Say what background the chapter assumes, from the front-matter audience.*
   Applied in substance, one clause in What it is, but not as a front-matter
   discussion, which is out of an editor's scope.

## Glossary changes

None. All nineteen terms in `glossary_refs` already have anchors in
`GLOSSARY.md`, verified individually. Nine terms were added to the chapter's
`glossary_refs` list to match new first-use links, and the `smart-cohort` entry
the author added is kept as ruled.

## Brand and style

No em dashes. No semicolons or colons in prose, the two remaining instances
being inside code-formatted app output and an app query string. Sentences
average about 20 words. No word from `ai-tells-words.txt`. Template section
order unchanged apart from the step 2 rewrite. Two courtroom and personification
metaphors replaced ("earned its calls a hearing", "the failure that hides
best"). `brand_reviewed` and `lead_approved` both remain `false`.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/09-genotyping/03-reading-the-genotype-comparison.md
```

Result, verbatim, green on the first run:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/09-genotyping/03-reading-the-genotype-comparison.md: no issues found
```

## Note for the Documentation Lead

Ruling (a) removed the `genotype-cohort-summary` shot, so the Screenshot Scout
has three shots to capture for this chapter rather than four, and the renamed
`genotype-matrix-reading` resolves the id collision with chapter 01.
