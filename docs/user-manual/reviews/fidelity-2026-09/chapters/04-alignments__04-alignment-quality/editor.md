# Editor report: 04-alignments/04-alignment-quality

Editor: brand-copy-editor. Date: 2026-09-07.
Chapter: `docs/user-manual/chapters/04-alignments/04-alignment-quality.md`.

Inputs read in full. `fidelity.md` (73 true, 8 false, 3 unverifiable),
`readers.md` (83 rows, 28 in the Consensus section), `author.md`,
`docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
`docs/user-manual/STYLE.md`, and the persona's own Campaign rules block.
Ground truth was re-checked in the Swift source and the `cli-help/` dumps for
every claim I added that the fidelity review had not already settled.

## Changes by source

| Source | Changes |
|---|---|
| Fidelity false rows | 8 |
| Project manager rulings | 5 |
| Reader rows | 34 |
| Consistency sheet | 3 |
| Style and prose rules | 4 |
| Editor's own source checks | 3 |

Fifty-seven changes in all. Each is listed below with its source.

## Changes from the fidelity review's false rows

1. **"LGE reports an average of that figure in the Inspector"** (fidelity false
   row 3). Rewritten in What it is to "LGE reports an estimate of that figure
   in the Inspector, worked out from an assumed read length rather than
   measured position by position", and the measured curve is now named
   separately as the Coverage track.
2. **"On the HG002 slice these read 90,990, 213, 99.8%, 1, and 44.7x."**
   (fidelity false row, Procedure step 2). The fifth figure is now 27.3x.
3. **Est. Coverage of 44.7x as "the average depth"** (fidelity false row,
   Reading the results). Now reads "The Inspector's Est. Coverage of 27.3x is
   the 150-base estimate ... and the alignment's true mean depth across the
   500,001-base slice is 44.7x".
4. **Est. Coverage of 44.7x in What good looks like** (same false claim, fourth
   site). Now "A mean depth of 44.7x on this fixture is comfortable, and the
   Inspector's Est. Coverage of 27.3x is the same run seen through the 150-base
   assumption", which is the sentence shape committed chapter 22
   (`01-mapping-reads-to-a-reference.md:193`) already uses.
5. **The bundle operation lock paragraph** (fidelity false row, Before you
   start). Deleted and replaced. The section now states that nothing stops a
   marking run starting while another operation works on the same bundle, and
   names it a defect in this release.
6. **"and the Operations panel carries the row"** (fidelity false row, Mark
   duplicates step 3). Deleted. The step now says nothing appears in the
   Operations panel for that run and the progress indicator is the only signal.
7. **"Switch the Inspector to the View tab and open the Analysis section"**
   (fidelity false row). Analysis is a top-level Inspector tab, not a section
   inside View. Now "Switch the Inspector to its **Analysis** tab". The same
   correction was applied at the three other sites that said "the Analysis
   section" and in the two shot captions that said "the Inspector's Analysis
   section".
8. **"Name for New Alignment ... there is no default"** (fidelity false row,
   stated twice). Both sites rewritten. See ruling 1 below for the wording.

## Changes from the project manager's rulings

9. **Ruling 1, Est. Coverage.** Handled at all four sites as rows 2 to 4 above.
   Procedure step 3 now carries the full explanation, that the row multiplies
   mapped records by an assumed 150-base read length and divides by the
   reference length, that the true mean depth of 44.7x comes from
   `mapping-result.json` and the coverage curve's own `mean:` label, and that
   the understatement is a defect in this release. This is the wording
   committed chapters 22 and 23 use.
10. **Ruling 1, no lock and no Operations row.** As row 5 and row 6. The Export
    step now carries the same statement for Create Deduplicated Bundle, which
    the fidelity review found equally unguarded. The Derive a filtered
    alignment step states the contrast, since that workflow does check
    `canStartOperation` and does post a row titled "Create Filtered Alignment
    Track" (verified at
    `InspectorViewController+TrimDuplicateWorkflows.swift:563-600`).
11. **Ruling 1, Name for New Alignment.** Both the Procedure and the Settings
    paragraph now say the field arrives filled in as "Mapped primary
    alignments", worked out from the selected source track and the shipped
    defaults, and that it rewrites itself as the filters or the source track
    change. Both keep the note that clearing the field stops the run. The bold
    label is verbatim and the paragraph count is unchanged.
12. **Ruling 2, the confirmation sheet wording is accurate.** The author's
    defect claim 1 is not repeated anywhere. Mark duplicates step 4 now states
    the true behaviour, that LGE deletes the old BAM, index, and statistics
    file from inside the bundle, with the one exception the source carries for
    a BAM living outside the bundle
    (`AlignmentDuplicateService.swift:230-254`).
13. **Ruling 2, the command line marks in place.** Kept and strengthened into
    its own paragraph in On the command line, contrasting the in-place rewrite
    with the Inspector button, which never overwrites a file the reader brought
    in.

## Changes from reader rows hit by three or more readers

14. **Phred-like with no gloss** (4 readers). Now "written on the same kind of
    logarithmic scale as a [Phred score](../../GLOSSARY.md#phred-score), so a
    higher number means a smaller chance of a wrong placement", with the
    glossary link added.
15. **Paralogous** (4 readers). Replaced with "a near-identical copy of the
    sequence somewhere else in the genome". No glossary entry was added, since
    GLOSSARY.md is not mine to edit and the plain phrasing removes the need.
16. **Tool pack** (4 readers). The sentence now reads "Nothing extra needs
    installing. The programs these operations use came in with the ones mapping
    already installed".
17. **The orange failed-quality-check count** (4 readers). Promoted to its own
    Procedure step. It says the count is the instrument's own quality-check
    failures, that it is 0 on this fixture and on a healthy run, and that a
    count in the thousands is a conversation with the sequencing facility.
18. **The nested Inspector path** (4 readers). Mark duplicates step 1 now gives
    the path as one instruction and says both duplicate-marking controls and
    the filter panel live under Analysis, so the reader stays there.
19. **"the old unmarked track entries are gone"** (4 readers). Step 4 now
    states plainly what happens on disk. See row 12.
20. **Comparing two tracks** (4 readers). Now "Comparing means opening one
    track and then the other in the same viewport ... LGE does not draw two
    alignment tracks side by side."
21. **MAPQ stepper to 255 against a maximum of 60** (4 readers, two sites).
    What it is now says minimap2 caps at 60 and the field allows up to 255. The
    Settings paragraph says the same and adds that a setting above the mapper's
    cap discards every read.
22. **Hide against Remove** (4 readers). Each now has its own sentence, plus a
    third saying both end with the duplicates absent and the difference is only
    whether the flags have to be there already.
23. **The Flag Statistics arithmetic** (4 readers). Converted to a five-row
    table with the two 99.77% shares labelled by their own denominators.
24. **The coincidence aside** (4 readers). Now says outright that there is
    nothing here for the reader to check on their own data, and why it is
    mentioned at all.
25. **View Settings used before it is located** (4 readers). Now "one of the
    Read Inclusion toggles on the Alignment tab of the Inspector's **View
    Settings** section", matching how chapter 23 names the same controls.
26. **Coverage breadth and the coverage curve unlocated** (4 readers). Both are
    now placed on the coverage strip, breadth as the percentage beside the
    `Depth` key, matching chapter 23's own description of that strip.
27. **Is the command-line section skippable** (4 readers). A new opening
    paragraph says it is optional and names who it is for.
28. **In-place overwrite against the no-edit promise** (4 readers). See row 13.
    The paragraph now states explicitly that the Inspector button never
    overwrites a BAM the reader pointed it at.
29. **Ten and forty with no middle** (3 readers). Now "treat about 30x as the
    working floor and 30x to 50x as the comfortable band" for human shotgun
    data, which also answers the reader who asked whether the ten-read figure
    was general.
30. **samtools unexplained** (3 readers). Now "LGE runs a program called
    `samtools` for this ... LGE installs and runs `samtools` for you, so there
    is nothing to install and no command to type."
31. **Downloading one file from GitHub** (3 readers). The three files are now
    labelled reference, first read file, and second read file in prose, with
    one sentence on how to download a single file from that page.
32. **Contig unglossed** (3 readers). Glossed inline at first use as "one named
    sequence in the reference" and linked to `#contig-reference`.
33. **Flag bits and the row names** (3 readers). A flag bit is now defined as a
    yes-or-no marker on each read, and each of the four rows gets a clause.
34. **The two keep toggles named only in Settings** (3 readers). Both are now
    named inline in the Derive a filtered alignment step.
35. **Are the CLI flags skippable** (3 readers). One sentence added to the
    Settings lead paragraph saying the flags belong to the command-line section
    and can be skipped.
36. **Records against reads** (3 readers). Both are now defined side by side in
    one sentence before the arithmetic that depends on the distinction.
37. **`.bai` and `.stats.db`** (3 readers). A new paragraph in Where the
    outputs land says the reader never has to open them and that LGE manages
    them.
38. **The MAPQ distribution unlocated** (3 readers). What good looks like now
    says outright that LGE has no screen drawing it, and points at
    `bam annotate` and the Selected Read panel instead.
39. **The 80% double negative** (3 readers). Restated positively as "On
    amplicon data a rate above about 80% is normal and expected".

## Changes from reader rows with a one or two sentence fix

40. Alignment defined in the opening sentence, and the chapter opens with a
    short plain statement of what it checks (rows hit by 2 and by 1 reader).
41. The three questions numbered First, Second, Third, and the inverted
    "Between X and Y sit three questions" written subject first (2 rows).
42. "call set" glossed inline (1 reader).
43. "spends" replaced with "weighs" (1 reader).
44. The x notation defined the first time depth is given a number (1 reader).
45. "read stack" glossed inline, and the on-screen element named as the
    Coverage track (2 rows).
46. HG002 introduced as a well-characterised reference sample, and PCR-free
    glossed (2 readers).
47. "Marking on amplicon data throws away the run" restated so it is clear no
    data is deleted (1 reader).
48. One line added on where to find out which protocol produced the reader's
    own reads (1 reader).
49. Reference bundle defined in the body, once, at first use (2 rows).
50. The menu path and shortcut for opening the Inspector added, and the
    Inspector located on the right-hand side (1 reader). Verified against
    `MainMenu.swift:447-452`, **View > Show Inspector** (Cmd-Option-I).
51. "The button title is literal" deleted and replaced with a direct statement
    (1 reader), and a sentence added saying marking is not undoable from the
    app and affects every track (1 reader).
52. The duplicate percentage given at the point the count first appears (1
    reader).
53. The five figures paired with their labels in a table (2 readers).
54. "sibling" glossed as "written next to the current one, in the same folder"
    (2 readers).
55. Secondary and supplementary split into two sentences (1 reader).
56. "the aligned region" restated as "across the part of the read that actually
    lined up rather than across the whole read" (1 reader), a benchmark added
    from the fixture's own 99.4% mean identity (1 reader), and one sentence
    saying percent identity and MAPQ measure different things (1 reader).
57. Both duplicate-marking buttons named in the Settings lead paragraph (1
    reader).
58. The dropped-read categories put in a table with the total, plus a sentence
    saying the categories cannot overlap and why (2 readers), and a sentence
    reconciling the 144 with the later 401 (1 reader).
59. "a fifth of the depth" given as "about 20% of the depth" (2 readers).
60. Est. Coverage and mean depth stated to be different measurements, at the
    point the two similar numbers appear together (2 readers).
61. 91,148 given one consistent label, "primary records, one per imported
    read", at both sites (2 readers).
62. The 500,001 explained against the file name's 500,000 (1 reader).
63. "you got a bargain" replaced with "the run was unusually generous" (1
    reader).
64. Threads glossed, with a note that the default is fine (2 readers).
65. "This is the point where the old advice ..." rewritten so it does not refer
    to advice the reader has never seen (1 reader).
66. What replaces Mapped % in a filtered track named as the record count (1
    reader).
67. Whether the reader ever opens the output folders answered (1 reader).
68. Roughly how much more sequencing helps, and who to ask (1 reader).
69. `--mapping-result` glossed (1 reader).
70. One of the two markdup spellings recommended as the default (1 reader).
71. The 89,519 and 89,107 difference explained in one clause (1 reader).
72. A `bam annotate` example block added (2 readers), with a sentence on its
    GUI equivalent. See the source-check note below.
73. The Next section now says why an amplicon chapter follows a duplicate
    chapter (1 reader).

## Changes from the consistency sheet

74. Analysis written as a tab throughout, per the sheet's rule to write "the
    Inspector's Consensus tab" rather than "Inspector > Analysis > Consensus".
75. The Operations panel named as **Operations > Show Operations Panel**
    (Cmd-Shift-P), the sheet's fixed phrasing, kept where it is now true and
    removed where it is not.
76. "the HG002 chromosome 20 slice" kept as the fixture's sheet name.

## Changes for style and the prose rules

77. No em dash, semicolon, or in-sentence colon was introduced. The two colons
    added both end a lead-in immediately before a table.
78. "Lungfish Genome Explorer (LGE)" still appears once, in the first body
    paragraph, and every later mention is LGE.
79. No banned word or sentence shape was introduced. Verified against
    `ai-tells-words.txt` and by the linter.
80. No unsourced duration was introduced. The only elapsed times in the chapter
    are inside quoted CLI output.

## Editor's own source checks

Three claims I added were not settled by any input document, so I checked them
myself rather than assert them.

81. **The Inspector menu item.** `MainMenu.swift:447-452` adds "Show Inspector"
    with `keyEquivalent: "i"` and `[.command, .option]`. Written as **View >
    Show Inspector** (Cmd-Option-I).
82. **The filtered-alignment lock and Operations row.**
    `InspectorViewController+TrimDuplicateWorkflows.swift:563-573` guards on
    `canStartOperation` and raises an alert headed "Operation in Progress",
    and `:589-600` starts an operation titled "Create Filtered Alignment
    Track". Both are quoted as written.
83. **`bam annotate` has a GUI equivalent.** My first draft said it did not.
    `ReadStyleSection.swift:2404` holds a **Convert Mapped Reads to
    Annotations** button, and `:2053-2054` places
    `mappedReadsAnnotationSection` under the Analysis tab's **Annotations**
    subsection. Corrected before the final lint. The example block's flags come
    from `cli-help/bam.txt:77-91`.

## Left unchanged deliberately

**The three unverifiable rows.** Handled as the fidelity review suggests, which
means left as they are. The 30x to 50x band and the duplicate-rate rules of
thumb stay framed as rules of thumb rather than measurements, and the "You need
a project open" sentence is the consistency sheet's fixed opening and is not
mine to change.

**Section order, and the count of Settings paragraphs.** Unchanged, per ruling
4. All eight `bam.filter` settings keep their paragraph and their bold label
verbatim.

**GLOSSARY.md, parameters.yaml, and every other chapter.** Untouched, per
ruling 4. Two terms readers stumbled on, paralogous and tool pack, were fixed
by rewriting rather than by adding a glossary entry.

**The Derive a filtered alignment procedure stays as prose.** Three readers
asked for it to be numbered like the two procedures before it. It cannot be.
The Procedure H2 already carries two numbered lists, which is the cap
`bullet-cap.js` enforces at two lists per H2 section, and the author's own lint
note records hitting exactly this wall and converting these steps to prose for
the same reason. I named the two keep toggles inline instead, which was the
underlying complaint in the reader row that sits beside it. **This is the one
consensus row I could not act on, and it needs a project manager ruling if the
numbered form matters more than the list cap.**

**"Flag Statistics" against "Flag Stats".** The chapter follows the source, as
the fidelity review and the author both conclude. Reconciling `parameters.yaml`
and the `flagstat` glossary entry to match is outside this chapter's brief and
stays flagged for the project manager.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/04-alignments/04-alignment-quality.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/04-alignments/04-alignment-quality.md: no issues found
```

Green on the first run after the final edit and on every run during the pass.

## Status

brand_reviewed: true
