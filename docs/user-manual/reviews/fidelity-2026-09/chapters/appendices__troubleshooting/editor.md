# Editor pass, appendices/troubleshooting.md

Date: 2026-09-07. Brand copy editor, campaign fidelity-2026-09.

## False claims fixed

Three, each with the reviewer's own wording.

1. **Install Dependencies.** The Genotyping row said to turn the **Enabled**
   switch on and click **Install Dependencies** first if needed. The button
   stands in place of the switch when packs are missing, and it enables the
   workflow itself. Replaced with the reviewer's sentence, matching committed
   chapter 51.
2. **Exit 64.** "Sixty-four means a usage refusal" is gone. 64 is a workflow
   error, 2 is the usage error. The corrected gloss says 64 covers both a run
   started without a required setting and a classification that finished and
   matched nothing, which resolves the contradiction with the Kraken 2 row that
   stopped two readers.
3. **`project migrate` reasoning.** The author's justification, that the command
   appears in neither the CLI Reference index nor `cli-help/`, was wrong. The
   command exists and Shared Projects documents it. Dropping the migration
   section stays right, so the section stays dropped and the appendix now points
   at Shared Projects for the lock work instead of resting on the bad reason.

## Missing symptom added

A new row in "A run stopped and I do not know why". Every Medaka run fails in
this release, because the pipeline calls a subcommand Medaka removed, and Clair3
stops on any alignment path containing a space, which every path under
`Reference Sequences/` has. The remedy is stated for Clair3, a space-free path,
and stated plainly as absent for Medaka. Links to
[Nanopore Variant Calling](../05-variants/04-nanopore-variant-calling.md).

## Unverifiable claims

- **Reference bundle for the Assistant tab.** Replaced with the reviewer's
  hedge, load a bundle that opens the Sequence viewport, which is what puts the
  Inspector in its genomics mode.
- **Index regenerate-on-demand.** Hedged to "so far as we have seen", and the
  manual `samtools` and `tabix` route is now marked as what to do if the
  automatic rebuild fails rather than as an equal alternative.

## Project manager rulings

| Ruling | Where applied |
|---|---|
| (a) First instruction unchanged | "Start here, at the failed row" keeps the failed-row failure report as the first action and keeps the reconstruct-by-hand prohibition. Reader 4 asked to cut the warning; not applied, ruling binds. |
| (b) "Before you type anything" paragraph | New H2 after "What it is", pointing at the CLI Reference's Terminal opener and the binary-path line. Every section now opens with one sentence saying whether it is window work or Terminal work, and names the window route where one exists ("Nothing happens", "I cannot write", the Plugin Manager for missing tools) or says plainly there is none ("Is this file or bundle intact", the genotype-only cohort row). |
| (c) Exit-status table | Small table before the first exit number is used, holding 2 usage, 3 unknown pack, 10 pending work, 64 workflow error, plus 0. Every later mention checked against it: the Kraken 2 row's 64, the gatk-core row's 3, the `tools update --plan` 10, and `provenance verify`'s 64 all match. |
| (d) Machine numbers labelled | Eighteen tool rows, 157.3 MB, `Dependency set: 2026.2`, macOS 26.6.2, 14 CPU cores, 48 GB, and the `debug container` status are each attributed to "the machine that wrote this appendix" with a clause saying what the reader's own copy prints. No threshold invented anywhere. |
| (e) Lock clearing in one sentence | One sentence at the head of "I cannot write to my project" pointing at the "If a project just opened read-only" section of Shared Projects and naming the **Recover and Open** button that chapter carries. |
| (f) Min Reads consequence | Row moved to the top of "The run finished but the result is not what I expected", where a reader scanning genotyping symptoms meets it first, and now opens "The filter you set is not applied." |
| (g) Glosses at first use | bundle, project, FASTQ, cohort, accession, environment, container, pipeline, Kraken 2, database, Nextflow, depth, index file, image, recipe, deprecated, admin user, network storage, host, process id, proxy, card, experimental, disclosure triangle (as "the small arrow at its left edge"), greyed (as "pale grey"), and inert (removed, replaced with "do nothing when clicked"). |
| (h) Every `glossary_refs` entry linked | Verified by script. All 23 ids resolve to a real anchor and each is linked at least once in the body. |
| (i) SHOT marker | One `<!-- SHOT: operations-panel-failed-row -->`, one matching `shots` entry, unchanged. |

## Glossary changes

- **Workflow Library** moved above **Working directory** in `GLOSSARY.md`, since
  "Workflow" sorts before "Working". No entry text altered.
- No new terms added. Every term the consensus called for already had an entry,
  so the fix was linking or glossing inline rather than writing definitions.
- `glossary_refs` grew from 13 to 23 ids, adding accession, bundle, cohort,
  depth, environment-variable, fastq, kraken2, nextflow, project, and
  read-classification. The three previously declared but unlinked ids, container,
  failure-report, and workflow-library, are now each linked in the body.

## Reader rows

**Consensus section, 48 rows. 48 applied.** Every one, including the four
chapter-wide problems the merge folded into single rows (Terminal opener,
example-machine numbers, lock clearing, command-line-only sections). The
retention count is now 50, the `--format json` commands are named, the `/tmp`
row leads with the fix, the 84 percent is marked approximate, and the
`provenance verify` sentence is split so the unsigned-record fact comes first.

**Other merged rows, 50. 44 applied, 6 skipped.**

| Skipped row | Reason |
|---|---|
| Cut the reconstruct-by-hand warning (reader 4) | Ruling (a) binds. The warning is the campaign's first instruction. |
| Give the build folder's exact name (reader 1) | Not stably knowable across builds. Applied the row's own alternative instead, that the name does not matter because **Reveal Failure Report in Finder** opens it. |
| Screenshot of the Workflow Library (reader 1) | Shots are the Screenshot Scout's to declare, and ruling (i) fixes this chapter at one. Card is glossed instead. |
| Gloss or link each of the five bundle kinds (readers 1, 4) | Applied the row's own second option, glossing the category, since five inline glosses in one table cell would bury the symptom. |
| Move the conda gloss to its first use (reader 2) | Conda's first use is now in the gatk-core row, which carries an inline gloss and the glossary link, so the ordering complaint is answered without moving the packs paragraph. |
| Cut the symlink and hard-link clause (readers 1, 2) | Applied for hard link, which is gone. Symlink stays in the `/private/tmp` row, where it is the actual mechanism and carries a glossary link. |

## Brand and style

No em dashes. The one semicolon is inside the verbatim app string
`conda root is read-only; reinstall as the admin user` and must stay. No colon
inside a sentence, checked by script excluding code spans and table rows. No
word from `ai-tells-words.txt`. Sentences held near 20 words. "Lungfish Genome
Explorer" at first mention and "LGE" after, `lungfish-cli` throughout.
Cmd-Shift-P is written out in full at its first use per the reader row, then
used in short form. `estimated_reading_min` raised from 18 to 20 for the added
section and rows. `brand_reviewed` and `lead_approved` both left `false`.

## Lint

```text
docs/user-manual/chapters/appendices/troubleshooting.md: no issues found
```

Green on the first run. All relative chapter links re-resolved against the
filesystem and every one exists.
