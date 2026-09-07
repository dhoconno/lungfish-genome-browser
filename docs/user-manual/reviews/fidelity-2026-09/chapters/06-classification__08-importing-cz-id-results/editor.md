# Editor pass, 06-classification/08-importing-cz-id-results

Date: 2026-09-07. Role: brand copy editor.
Inputs: `author.md`, `fidelity.md`, `readers.md`, `parameters.yaml` entry
`import.cz-id`, `CONSISTENCY.md`, and the committed sibling chapters
`09-novel-virus-detection.md` and `02-running-kraken2.md`.

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
prints "no issues found", exit 0. No em dashes, no semicolons, no in-sentence
colons. No front-matter flag was flipped. `brand_reviewed` and `lead_approved`
both remain `false` for the gate.

## Fidelity rows

### The one false row

**JSON field names.** Applied the reviewer's replacement wording in On the
command line, folded together with the reader row asking what JSON adds over
TSV. The sentence now names the six camel-case keys `taxId`, `name`, `rank`,
`ntReadCount`, `ntRpm`, and `nrReadCount` explicitly rather than pointing back
at the TSV column names, keeps the four extra keys, and adds one sentence
saying the two forms hold the same measurements in two naming styles.

### The three unverifiable rows

- **Few-thousand-row timing.** Cut. Before you start now says only that the
  reference import finished in well under a second and that the work is
  parsing text rather than analysing sequence, so it stays quick on a longer
  report. That is the shape chapter 40 uses for the same claim. The reader row
  asking for a rough time for a few-thousand-row report is therefore answered
  qualitatively rather than with an invented number.
- **One-sample-of-a-multi-sample-export cause.** Cut the named cause. What
  good looks like now states only the symptom and the remedy, that a preview
  reading far fewer rows than expected means a different file from the one you
  meant, and the fix is to download the sample's report again. This also
  absorbs the reader row asking for an order of magnitude, using hundreds or
  thousands against a few dozen.
- **Hand-assembled-export cause.** Hedged into a remedy. The sentence now
  gives the arithmetic that is verified (every percentage is computed against
  the root row, so a foreign root row skews all of them) and the action
  (re-export as a single download), without asserting how the mismatch arises
  in practice.

### Optional additions offered by the reviewer

Not taken. The bundle-name sanitisation sentence was restructured for the
reader row rather than extended, so the hyphen-collapsing and
leading-or-trailing-trim behaviours stay out. Adding them would have grown a
clause the readers already found hard to parse.

## Consensus rows applied (35 of 35)

1. **Kraken 2 unglossed.** What it is now introduces Kraken 2 as the
   classifier LGE installs and runs on your own machine, with a link to
   chapter 33.
2. **Test-fixture path.** Replaced per the PM ruling. Before you start now
   uses the CONSISTENCY.md Download ZIP sentence with its last clause reading
   "find the file inside it under `Tests/Fixtures/czid/`", names the file as a
   small synthetic three-row taxon report kept in the repository for testing,
   and quotes the path nowhere else. `fixtures_refs` stays empty.
3. **No way to check the three columns.** Before you start now says to open
   the file in a spreadsheet program such as Numbers or Excel and read the
   header row.
4. **Forward reference under step 5.** Step 3.4 now carries the one-sentence
   warning inline. The fuller note stays below step 5.
5. **Equivalent command line not marked optional.** Step 4 now says it is
   optional and only useful for scripting or repeating the run.
6. **Bundle-renaming clause.** Now leads with "LGE names the bundle for you"
   before the character list.
7. **Settings says no settings then lists three.** Opener rebuilt on chapter
   40's shape, "has no settings in the window", "no equivalent anywhere in the
   window", and an explicit skip for window-only readers.
8. **argv, exit status, wall time.** Replaced with the command that ran,
   whether it succeeded, and how long it took.
9. **kreport columns.** All six now labelled in a sentence directly under the
   block.
10. **88 of 1,200.** Arithmetic shown once and plainly (88 divided by 1,200 is
    0.0733), the root row named as the source of 1,200, and one sentence
    saying the unassigned and host reads make up the remainder without
    appearing as rows.
11. **NT, NR, percent identity, alignment length, e-value.** NT and NR
    expanded as NCBI's nucleotide and protein collections at first use.
    Percent identity, alignment length, and e-value each glossed, with the
    logarithmic note and the ten-to-the-power form given once.
12. **Sunburst not picturable.** One sentence of description added, saying the
    centre holds the root row, each ring outward is more specific, wedges are
    sized by read count, and clicking a wedge selects it.
13. **3 taxa reads as a bug.** Now stated as expected behaviour rather than a
    mistake in the reader's file, with the defect note attached.
14. **BLAST Verify and Export.** One clause each, with the BLAST chapter
    linked.
15. **Source citation in reader text.** `AppDelegate+ToolsMenu.swift:860-867`
    removed. No file paths or line numbers remain in reader-facing prose.
16. **Command-line section not marked optional.** Opens with chapter 33's
    optional wording, adapted.
17. **RPM 73333.0.** Explained as 88 of 1,200 scaled to a million, with a
    plain statement that a single RPM figure is not high or low on its own and
    exists for cross-sample comparison. No judgement of the value invented.
18. **Two CLI spellings.** Now a three-column table, presented once as two
    spellings of one import that differ in what they need and where the result
    lands.
19. **Root row never introduced.** New second paragraph in What it is
    introduces it, and the chapter now calls it "the root row" throughout.
20. **Reference database unglossed.** Glossed at first use as a stored
    collection of known sequences, distinguished from a reference genome.
21. **Rhetorical question.** Cut. Replaced with a plain statement of the
    two-step workflow.
22. **`.lungfishtax` before bundle.** Bundle gloss moved ahead of the
    extension.
23. **What to do with a checksum.** Now says LGE computes, stores, and
    compares them and the reader never types or checks one.
24. **"Long tail of one-read hits".** Replaced with a plain statement that
    taxa carrying only one or two reads are usually background.
25. **Manual's viral-examples aside.** Cut to the ruled sentence, "This
    chapter uses a viral example because CZ ID is a pathogen-detection
    service."
26. **Plugin pack unglossed.** Glossed and linked, on chapter 40's wording.
27. **Drag-and-drop.** Source-checked before writing. Dropping on the card
    calls `openWizardSheet(action:sourceURL:)`, which passes the URL as
    `initialSourceURL` to `CzIdImportSheet`, so it opens the same sheet with
    the path filled in rather than completing the import. The chapter now says
    exactly that.
28. **Operations Panel auto-open.** Source-checked. `OperationCenter` never
    presents a window and no CZ ID path shows the panel, so the chapter now
    says it does not open on its own and the reader opens it to watch.
29. **Placeholder paths.** Flagged once at the top of Procedure and referred
    back to in On the command line.
30. **Truncated checksum.** Now says the value is shortened for display and
    only the match matters.
31. **Clade against the sunburst layout.** Reworded so the gloss is
    hierarchical rather than directional, "one taxon together with everything
    beneath it in the classification", with no "under it" left to fight the
    chart's outward layout.
32. **"A count far smaller than expected".** Replaced with hundreds or
    thousands against a few dozen.
33. **Root-row mismatch remedy.** Now says to re-export the sample from CZ ID
    as a single download.
34. **JSON camelCase unexplained.** Covered by the false-row fix above.
35. **Step 5 heading.** Retitled "Do the same on the command line (optional)"
    with chapter 33's optional lead sentence.

## Other reader rows applied

Applied without inventing facts: pipeline glossed once as a chain of programs
run one after another; taxon glossed before the tree-of-life phrase; the
command-line-help citation in paragraph two cut entirely rather than moved,
since the boundary is stated in the chapter's own words and again on the card;
the Import Center location stated before the Tools-menu absence; classifier,
FASTQ, and viewport glossed at first use; "pick a folder" now says to make a
new empty folder; "commit" replaced with "start the work"; pipeline version
explained as which version of the analysis code produced the numbers;
superkingdom tied to the kreport's D for domain; the three file forms split
into a three-item list; "path" replaced with "ways" where it meant a route;
the metadata sidecar gloss moved ahead of the word, and both provenance-only
flags now say that moving or deleting the original leaves the bundle intact;
host organism glossed as the person or animal the sample came from; the
Bracken sentence cut entirely; the Project row's identifier explained and a
missing row called normal; the failed-scan cue described as text beside the
icon rather than by colour alone, which also drops the "amber" wording the
reviewer flagged as unsettled; the three Run-button conditions split into two
sentences; the nine-fact preview sentence replaced with a lead-in and a
two-column table; the row-count check pulled forward into step 3 where the
preview is on screen, and What good looks like now says so; plausible and
implausible taxa exemplified for the worked example; the percent check
narrowed to the top two or three wedges; `--top` explained in terms of what it
hides and when to raise it; Reads and Direct explained as columns shared with
locally run classifiers, with "roll up" replaced by "add together"; bundle
internals declared internal and never opened by hand; "ship", "shapes",
"reach for", "advisory", "relationship", "hides its own shape", "on someone
else's schedule", and "the numbers a reviewer will ask for" all replaced with
the plainer wording the readers asked for; the "situation importing was
supposed to prevent" clause split into its own sentence; the two-clause
multi-sample sentence split.

New for this pass, following chapter 40's shape: a **Troubleshooting** section
covering the three failure states the chapter actually documents.

## Rulings applied

- **Fixture.** As above. `fixtures_refs` left empty. The repository path is
  quoted once, inside the Download ZIP sentence, and nowhere else.
- **Getting the export out of CZ ID.** Before you start now describes only
  what the importer requires (the three columns, and that a single-sample
  download or the whole export archive both work), says plainly that the steps
  inside the CZ ID website are the service's own and are not covered here, and
  gives the spreadsheet check.
- **Where the import lands.** Stated as
  `Classifications/<sample>.lungfishtax` on both routes, in Procedure step 4,
  in Settings, in the CLI comment, and in the two-spelling table. The
  Project Destination defect is disclosed in one sentence at step 3.4, in the
  fuller note under step 5, in Known defect, and in Troubleshooting, with no
  source files or line numbers anywhere.
- **Taxon count.** Stated as expected behaviour with a defect note, in the
  viewport subsection and again under Known defect.
- **Terminal material.** Settings opens the way chapter 40's does. Step 5 and
  the command-line section carry chapter 33's optional wording. The Operations
  row's equivalent command line is marked optional.
- **Glosses at first use.** All the ruled terms are glossed. Four glossary
  refs added to front matter for terms that already have entries and are now
  linked: `clade`, `e-value`, `fastq`, `percent-identity`, `plugin-pack`.
  Terms with no `GLOSSARY.md` entry (reference database, classifier, viewport,
  sunburst, pipeline, argv-in-plain-words) are glossed inline only, and no
  glossary entry was added, since `GLOSSARY.md` is not this role's file.
- **88 of 1,200.** Arithmetic shown once, plainly.
- **kreport block.** All six columns labelled.
- **Two CLI spellings.** Presented once, as a table.
- **Rhetorical question and the viral aside.** Cut and reduced as ruled.
- **Drag-and-drop and the Operations Panel.** Both source-confirmed before
  stating. See consensus rows 27 and 28.
- **App defects.** Each disclosed in one sentence where the reader meets it,
  with no file paths or line numbers.

## Front matter

Only two changes, neither a flag. `glossary_refs` gained `clade`, `e-value`,
`fastq`, `percent-identity`, and `plugin-pack`, all of which resolve in
`GLOSSARY.md` and are now linked from the body. `estimated_reading_min` went
from 14 to 24, since the body grew from about 4,000 to 5,608 words and the
siblings run at roughly 250 words per estimated minute (chapter 40 is 6,157
words at 26, chapter 36 is 4,963 at 26).

The `czid-import-sheet` caption gained a closing clause saying the Project
Destination readout must stay visible because it is the defective control the
chapter documents, which is the reviewer's capture caution written into the
caption itself.

## Left for the gate

- **Both front-matter flags.** `brand_reviewed` and `lead_approved` stay
  `false`.
- **The Project Destination defect passages.** The author's Phase 5 note 3
  says the chapter should not ship until it is settled whether the sheet gets
  fixed. If it is fixed, four passages come out together, the step 3.4 inline
  sentence, the note under step 5, the first paragraph of Known defect, and
  the third Troubleshooting bullet.
- **The consistency-sheet correction.** `CONSISTENCY.md` still lists `cz-id`
  among the tools that get an `Analyses/<tool>-<timestamp>/` folder, which is
  dead for this import. The author and the fidelity reviewer both raised it. I
  did not edit `CONSISTENCY.md`, since the PM owns it.
- **The four shots.** All still uncaptured. Every window claim in this chapter
  rests on source reading rather than a GUI run.
- **Phase 5 fixture decision.** If a `docs/user-manual/fixtures/czid/` folder
  ships, Before you start's second paragraph and `fixtures_refs` both change.

## Facts I could not source

- **CZ ID's own interface.** Which button produces which of the three file
  forms by default, and where the row count appears on CZ ID's page, are both
  reader requests I could not answer, since neither the source tree nor the
  CLI knows anything about the CZ ID website. Handled by the PM ruling, which
  sends the reader to CZ ID's own instructions rather than guessing.
- **A typical row count for a real CZ ID report.** Reader 2 asked for a range.
  I wrote "hundreds or thousands" in What good looks like as the scale a
  reader compares against, which is the weakest claim that still answers the
  question. Nothing in the repository establishes it, so it is worth a second
  look from someone with a real export.
- **Whether the failed-scan icon reads as amber on screen.** The reviewer
  flagged the source as a filled SF Symbol tinted `.yellow`. I removed the
  colour word rather than guess, so the chapter now describes the text beside
  the icon, which also answers the colour-deficient reader's row.
