# Editor pass, 06-classification/01-what-is-classification

Date: 2026-09-07
Role: brand-copy-editor
Chapter: `docs/user-manual/chapters/06-classification/01-what-is-classification.md`

Inputs read in full before editing. `fidelity.md` (55 true, 3 false, 1
unverifiable), `readers.md` (four-reader merge, 61 rows, 20 in Consensus),
`author.md`, `CONSISTENCY.md`, `STYLE.md`, and the
`.claude/agents/brand-copy-editor.md` campaign rules block. Source claims that
this pass introduces were each checked in `Sources/` before being written.

Section order is unchanged. No other chapter, `GLOSSARY.md`, or
`parameters.yaml` was touched.

## Changes by source

### Fidelity, false rows (ruling 1)

- **Row 33, analysis-folder timestamp.** `kraken2-20260907-143005` corrected to
  `kraken2-2026-09-07T14-30-05`, the shape `AnalysesFolder.swift:597-603`
  actually builds. The same sentence now spells the suffix out as date, then
  `T`, then time, which is the four-reader readability row on the same string.
- **Row 23, FASTQ/FASTA Operations described as a window.** The surface is an
  `NSPanel` run as a sheet whose own panel title is the category name, with
  "FASTQ/FASTA Operations" rendered as the sheet's heading. Body now reads
  "opens a sheet headed FASTQ/FASTA Operations" and "That heading names the
  sheet, not a menu". Three downstream mentions follow ("the same sheet serves
  the trimming...", "the operations sheet" in the TaxTriage and Bracken
  paragraphs). The `classification-dialog-tool-sidebar` caption changed
  "dialog" to "sheet" to match.
- **Row 38, three viewport panes described as all linked by a single click.**
  Replaced with the corrected wording the fidelity row supplied. Clicking links
  the sunburst and the table, and the breadcrumb bar follows drill-down. This
  also absorbs the two-reader row asking that the three views be named before
  they are called linked.

### Fidelity, unverifiable row (ruling 2)

- **Row 15, Kraken 2's minimizer algorithm.** Now attributed upstream rather
  than asserted as LGE behaviour. The paragraph opens "Kraken 2's own
  documentation describes how it does this, and the short version is worth
  carrying." Note that the four-reader row asked for a concrete k-mer length.
  I wrote "a few dozen bases each rather than a whole read" instead of the
  usual k of 35, because `author.md` records that k value as an unverifiable
  row belonging to chapter 02, and importing it here would put an unverifiable
  number in a chapter that currently asserts none.

### Ruling 3, 12S routing

The chapter did not previously route to 12S at all, so no wrong sentence
existed to correct. A closing paragraph in `## Next` now routes there with the
ruling's own framing. Filed under Genotyping, shown as "12S Amplicon Matching
(not enabled)" in grey in the **Tools > Genotyping** submenu until enabled
through **Tools > Workflow Library...**. Show Experimental Features is not
mentioned. Verified at `WorkflowLibrary.swift:143-145` (title, `categoryID:
.genotyping`), `MainMenu.swift:832-843` (the "(not enabled)" title and the
`disabledControlTextColor` styling), and `MainMenu.swift:766-770` (the Workflow
Library item).

### Ruling 4, glossary_refs

`shotgun` dropped, since the body never uses the word. Six anchors added
because this pass links them in the body: `amplicon`, `paired-end`,
`accession`, `provenance`, `coverage`, `bracken`, `contig`. Every remaining
entry corresponds to an anchor the body links.

### Reader rows, three or more readers (all twenty addressed)

- **Amplicon unglossed (4).** Glossed and linked at first use, with the
  reason an amplicon run reads a region deeply rather than evenly.
- **86,281 read pairs unjudgeable (4).** Now says paired-end means both ends of
  one fragment, gives 172,562 reads in all, and calls it a small run, normal
  for a clinical panel over a single 30 kb viral genome.
- **Provenance unglossed at first use (4).** Glossed and linked in the import
  paragraph as the record of where a result came from and how it was produced.
- **Provenance's second use has no location (4).** Check 2 of "What good looks
  like" now names the surface. The taxonomy viewport's export menu,
  **Show Provenance...**, which names tool version, database, and path.
  Verified at `TaxonomyViewController.swift:1747-1786` and
  `TaxonomyProvenanceView.swift:54-60`.
- **"Build" undefined and PlusPF unexpanded (4).** Both fixed in place. PlusPF
  expanded once as Plus Protozoa and Fungi, build defined as one prepared
  version of a database.
- **k-mer and minimizer give nothing to picture (4).** Minimizer now described
  as one chosen representative k-mer standing in for a group of neighbours,
  and aligning is glossed in the same sentence, which also clears the
  two-reader row on unglossed "aligning".
- **Timestamp suffix unreadable (4).** Covered above under fidelity row 33.
- **Bracken unglossed (4).** Own paragraph now. What Bracken does (pushes reads
  parked at a broad rank down onto likely species), and what its column adds
  over Reads.
- **The four non-Kraken2 databases unnamed (4).** Now named. SILVA and
  Greengenes (Kraken2 databases built from rRNA collections for 16S work), the
  EsViritu Viral DB, and NCBI Taxonomy. Verified against the thirteen catalog
  entries in `third-party-tools-lock.json`.
- **LCA reads as failure before the reassurance (3).** The paragraph was split
  and now opens with the reassurance, "a call that stops at genus is still a
  usable answer rather than a failure", before the mechanism.
- **"Call" and its confidence score undefined (3).** Call glossed as the
  classifier's decision that an organism is present, with TaxTriage attaching a
  numeric score so a reviewer can sort strong from weak.
- **Wastewater pellet unglossed (3).** Glossed inline as the solid material
  spun down out of a wastewater sample.
- **Import rows break the table column's pattern (3).** All three import rows
  rewritten as biological questions, and a lead-in sentence now says the column
  asks a biological question throughout.
- **No way to check for Nextflow and a container runtime (3).** Now points at
  the TaxTriage pane's Prerequisites row with an indicator for each. Verified
  at `TaxTriageWizardSheet.swift:316-340`.
- **Dataset line state unclear (3).** Now says where it sits and gives all
  three states verbatim. A path, "No FASTQ selected", and a count such as
  "3 FASTQ datasets". Verified at `FASTQOperationDialogState.swift:1119-1128`.
- **% column denominator unstated (3).** Now says it is the clade count as a
  share of the reads the classifier managed to classify, so unclassified reads
  are out of the denominator (`TaxonomyTableView.swift:303`).
- **72 GB download's cost unestimated (3).** Disk space added from the
  manifest, PlusPF needs 72 GB free once installed, and the capped 8 GB builds
  are named as the answer. No duration written, since the readers' suggested
  "can take hours" would be an unsourced duration the campaign forbids.
- **Cmd-Shift-B unclear (3).** Kept in the CONSISTENCY.md form and followed by
  "The keyboard shortcut opens exactly the same window as the menu item".
  I did not explain the letter. The source comment says it stands for
  "Bioconda", which is an implementation detail rather than reader-facing.
- **No anchor for a normal unclassified fraction (3).** No number invented.
  The passage now says plainly that no single number separates normal from
  alarming and gives the reasoning instead, contrasting a viral-only database
  against a Standard database on the same swab.
- **Reference database's physical form unstated until late (3).** First
  paragraph now says it is a folder of files installed on your own machine
  rather than a website, and routes to the Databases section.
- **`.lungfishtax` and "top-level" unexplained (3).** Now "a `Classifications`
  folder sitting directly inside the project folder", the app chooses the
  location, and the reader never handles the file directly.

### Reader rows under three readers, fixed because the fix was a sentence or two

- Rank ladder with a worked example (2). Added, Eukaryota through
  *Homo sapiens*, broadest to narrowest.
- Kingdom's absence read as an error (2). Now stated as something these tools
  do not report.
- "Walks the reads" (2). Now "goes through the reads".
- Assembly unglossed in the NVD sentence (2). Now says it stitches overlapping
  reads into contigs with no step the reader performs.
- Coverage unglossed at first appearance (2). Glossed and linked in the
  three-classifiers paragraph, ahead of the EsViritu section.
- Vector sequence unglossed (2). Glossed as laboratory cloning DNA that
  contaminates a library.
- "Conserved" unglossed (2). Glossed as nearly identical across many organisms.
- Selection instruction placed too late (2+2). Moved to the start of its own
  paragraph, before the sheet paragraph, and it now names what is being
  selected and routes to the importing chapter, which clears the companion
  two-reader row.
- Three views not named before being called linked (2). Covered under fidelity
  row 38.
- "Do that" ambiguous (1). Now "Compare every read in the file".
- "Census" (1). Now "a count of which organisms are present and in what
  proportion".
- Duplicate LCA phrasing (1). One phrasing kept.
- Percentage denominator in "What it is" (1). Now says the share is calculated
  over the reads it managed to classify.
- What "verdict" rules out (1). Named. A classification does not answer yes or
  no about one organism you had in mind.
- Targeted assay unglossed (1). Glossed as a test that looks only for organisms
  chosen in advance.
- "Worked runs" misread as past tense (1). Now "The example runs".
- Long subject-verb sentence in the LGE-runs lead (1). Split in two.
- "This part" ambiguous (1). Now "a chapter among the classification chapters".
- SRR number unexplained (1). Glossed and linked as an accession from the NCBI
  Sequence Read Archive.
- Import route's reason arrives late (1). The paragraph now opens with the
  reason, a colleague ran the tool on another machine.
- Six cards read as contradicting the table (1). A sentence now says why the
  tab holds more cards than the table has import-only rows. The reader's
  suggested reordering was not applied, see below.
- Which output file to import (1). Now says each import chapter names the file
  its tool produces.
- "Widest net" idiom (1). Now "covers the widest range of organisms".
- Three noun phrases without a comma (1). Split into two sentences.
- Sunburst root unpicturable (1). The centre is now described as labelled with
  the taxon everything else sits beneath, plus its read count
  (`TaxonomySunburstView.swift:22`).
- Whether a legend exists (1). Stated. There is none, and hovering names a
  wedge.
- Sample column's content (1). Now says it matters in a batch run and repeats
  the input name for a single sample.
- Bracken checkbox or automatic (1). Stated as automatic for a Kraken2 run
  started from the sheet. Verified at
  `ClassificationWizardSheet.swift:680` (`goal: .profile`,
  `brackenProfileRequest: .automaticDefault`) reached through
  `FASTQOperationToolPanes.swift:45`.
- How a multi-sample run starts (1). Folded into the dataset-line sentence.
- What a stopped run looks like (1). Routes to the Troubleshooting appendix.
- RiboDetector unexplained (1). One clause added, strips ribosomal RNA reads
  out of a library before classification.
- Lineage versus taxon (1). One clause added, a named subgroup inside one
  species, finer than any rank a classifier reports.
- Variant and depth tables unglossed (1). Now says a mapping run produces them
  and what each lists.
- Three checks run together in a paragraph (1). Numbered as a three-item list.
- "Classifiers" used before being defined (1). First paragraph now says "A
  classifier is a program that".
- Who decides where the LCA climb stops (1). Stated. The tool decides from what
  the database contains, and the reader does not set it.

### Style and consistency

- `Running Kraken2` link text in `## Next` corrected to `Running Kraken 2`,
  matching that chapter's own `title`.
- Menu paths, the Plugin Manager shortcut form, the Import Center form, and the
  fixture name all left in their CONSISTENCY.md shapes.
- Prose rules verified mechanically over the body after editing. No em dash, no
  semicolon, no sentence-internal colon, no word from
  `ai-tells-words.txt` in any inflection, no bullet list over five items, at
  most two lists per H2. "Lungfish Genome Explorer (LGE)" still occurs once at
  first mention with "LGE" after.

## Left unchanged, deliberately

1. **No human-background percentage for a clinical swab** (1 reader), **no
   number for "most reads unclassified"** (1 reader), and **no rough normal
   range for the unclassified fraction** (3 readers). Nothing in the source,
   the fixture README, or any run on this machine supplies these figures, and
   the campaign forbids invented numbers. Both passages were rewritten to give
   the reasoning that lets a reader judge their own number instead.
2. **No download duration** (3 readers asked for "can take hours"). That is an
   unsourced duration, which the prose rules forbid outright. Replaced with the
   sourced disk-space figure.
3. **No k of 35 for Kraken 2** (4 readers asked for a concrete k-mer length).
   `author.md` records that value as an unverifiable row owned by chapter 02.
   Written as "a few dozen bases each" instead.
4. **The six-cards paragraph was not moved above the table** (1 reader). The
   ruling forbids changing section order, and moving a paragraph across the
   table is close enough to that to route rather than act. The perceived
   contradiction is instead answered in place by the new table lead-in and a
   sentence in the paragraph itself.
5. **The NAO-MGS link text and filename still disagree** (1 reader). The link
   text "Importing NAO-MGS Results" already matches that chapter's own `title`.
   Only the filename `05-running-nao-mgs.md` disagrees, and renaming a file in
   another chapter's territory is out of this pass's scope. **For the project
   manager to rule on.**
6. **The Cmd-Shift-B letter is still unexplained.** The source comment records
   it as standing for "Bioconda", which is an implementation detail rather than
   something a reader would find useful. The shortcut's scope is now stated.
7. **The classifier colour convention** flagged by `fidelity.md` note 3 and
   `author.md` defect 1 is still absent from the chapter, correctly. This pass
   introduced no colour claim. The project-memory line remains wrong for this
   build and is the Lead's to retire.
8. **`estimated_reading_min: 11`** left as is. The chapter grew by roughly a
   fifth, so 12 or 13 might now be closer, but the field is the author's and
   no ruling covered it. **For the project manager to rule on.**

## Lint

Command.

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-classification/01-what-is-classification.md

Output, verbatim.

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/06-classification/01-what-is-classification.md: no issues found

## Status

brand_reviewed: true
