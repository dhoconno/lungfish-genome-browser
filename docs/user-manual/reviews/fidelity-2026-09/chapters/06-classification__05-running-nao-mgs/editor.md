# Editor log, 06-classification/05-running-nao-mgs

Date: 2026-09-07. Chapter: Importing NAO-MGS Results. Registry id `import.nao-mgs`.

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh` prints
`no issues found`. Green on the first run after the rewrite.

Front-matter flags untouched. `brand_reviewed: false` and `lead_approved: false`
stand for the gate.

## The ten false rows

Every one applied in the reviewer's wording, adapted only where a ruling below
tightened it further.

**Row 20 (scoped).** Procedure step 3 now says "The Import Center writes the
finished bundle under the project's `Analyses` folder", naming the path that
does it, and the Output directory setting and the CLI example carry the other
half.

**Row 21 (bundle naming).** "named `naomgs-` followed by the sample name when
one is given, and by the input file's name otherwise, so on this fixture it
comes out as `naomgs-virus_hits_final`." The worked name now matches the code
block later in the chapter, which is the contradiction readers.md flagged.

**Row 23 (SQLite contents).** "a folder holding a database of the per-taxon and
per-accession summaries", not "of every hit". This removes the contradiction
with the `--by-db` paragraph 100 lines later.

**Row 27 (default sample label).** "It defaults to the first sample in
alphabetical order, taken from the table itself." The old "first sample the
virus-hits table names" is gone from both places it appeared.

**Row 32 (`--output-dir`).** Both the Settings entry and the CLI example now
name the `Analyses` folder itself. The example's `--output-dir` argument was
changed to `"/path/to/My Project.lungfish/Analyses"`, and the prose says the
importer "adds no `Analyses` step of its own." The `--result` path in the
extract example was updated to match, so the two code blocks agree.

**Rows 36 and 37 (the two taxon counts).** The Taxa card "counts the rows in the
taxon table, which is one row per sample-and-taxon pair rather than one per
organism", the bar "reads 5 samples and 7 taxa, those 7 rows covering 4 distinct
organisms", and the sentence names the overview pane's Unique Taxa card as the
one reading 4. Per the ruling both numbers are used consistently: 7 appears only
as the row count, 4 only as the distinct-organism count, in the summary bar
subsection and again in the detail-pane subsection.

**Row 53 (`Taxid:`).** Both occurrences carry the colon now. The generic form
reads `Taxid: N` and the example reads
`Taxid: 28875  •  26 unique / 28 total reads  •  7 accessions`.

**Row 55 (panel ordering).** "The panels are ordered by total hit count, so the
reference with the most reads comes first. The note above them says unique read
count, which is a mislabel in the app." Defect 4 disclosed in one sentence where
the reader meets it.

**Row 64 (context menu).** Rewritten to "offers BLAST verification and **Extract
Reads...**, plus" the five verified items, and a closing clause says Export is
not on that menu and the action bar button is the route to it.

**Row 83 (extraction parity).** The parity claim is gone. "The viewport's
Extract FASTQ button uses this same classifier resolver and additionally narrows
the reads to the taxon's own read names, so a command-line extraction of one
accession can return more reads than the button does for the same taxon."

## The 38 consensus rows

All 38 applied. Grouped by what the fix was.

Glosses added at first use, per the ruling's list and the consensus rows:
`.tsv` and `.gz` separately in What it is, sequencing lane (one physical channel
on the sequencer) in step 2, bit score and edit distance and reference position
as a three-sentence paragraph in Why you would do this, PCR duplicate before
"amplified" rather than several paragraphs after it, sidecar (a small companion
file written beside the export), conserved region (sequence that changes little
between related species), reference collection (the fixed set of viral genomes
the pipeline searches against), current directory (the folder the terminal is
pointed at when you press Return), the Inspector with **View > Show Inspector**
(Cmd-Option-I) and where it sits, the drag handle (a resize handle along the
panel's bottom edge, confirmed at `MiniBAMViewController.swift:39` and `:323`),
the NM badge (a small two-letter tag on the card), the miniBAM pileup view (the
reference along the top with a depth curve above it, reads stacked underneath at
the positions where they matched, disagreeing bases coloured, from
`MiniPileupView.swift:10-15`), pipeline, cluster, NCBI and GenBank, FASTA
contrasted with FASTQ, and Cmd-N as a keyboard shortcut.

"N of M samples" now shows the real example `2 of 5 samples`, and the sample
button shows `2 of 5 Samples`.

Naming and expansion. NAO-MGS is handled under the ruling below. SecureBio is
identified as a nonprofit research organisation working on biosecurity.

Cut or replaced. The `samples/`, `metadata.tsv`, `manifest.json` list is gone,
replaced by "Nothing else from the pipeline output has to be prepared first".
The plugin-pack, conda, Docker list is now "Nothing needs installing for this
import." "Thirty columns wide, one row per matching read" is a full sentence.
"So what should you do with this?" is a direct statement. "Wrong shape" is
"organised per read rather than per organism". "Chased down" is "investigated".
"Hand-writing a query" is "writing your own analysis code". "A handful of reads
is a lead, not a result" is "A few reads suggest something to check, not a
confirmed result". "What the name commits you to" is "what the name proves and
does not prove". The "easy to miss because it is the only control on that row"
admission is replaced by a plain statement of where the button sits. The "It
does not plot a time series" defensive line is now "Surveillance trends need
several imports compared side by side."

Facts added. "Commit the import" is now **Run** (ruling below). The 35 hits get
a scale sentence. The column filter says what appears on right-click and how to
clear it. The 12-and-8 arithmetic is stated (4 of the 12 hits are duplicates)
and the two rows are compared as proportions, 67 against 93 percent, rather than
as raw counts. The Top Taxa chart says it shows all taxa when there are fewer
than fifteen. `--min-bitscore` gets a typical range. `--by-db` is cut to one
sentence (ruling below). The step-2 sheet sentence and the Settings section are
reconciled. The `.tsv(.gz)` notation is written out with a preference stated.
The 34-against-35 defect is confined to that command (ruling below).

Layout. The Reading the results opener now lists the regions in the order the
screenshot caption does, summary bar, taxon table on the right, detail pane on
the left, action bar, so caption and prose agree.

Network. Left out, per the ruling. See "Could not source" below.

## Other reader rows applied

Roughly 30 of the remaining 48. Notable ones: "Hits" is defined as
read-to-reference alignments rather than reads, so one read matching two
references counts twice; Refs gets a sentence on what high and low mean; the
`Taxid N` fallback is described as normal and still usable, and the sorting
consequence is noted; Extract FASTQ names the selection it acts on and what
happens with nothing selected; BLAST Verify says 20 reads by default
(`NaoMgsResultViewController.swift:2078-2086`) and uses "subset" rather than
"sample" to avoid the wastewater collision; the `--sample` identifier in the
extract block is explained as the Sample column value the reader replaces; the
first classifier LGE runs itself is named with a link; the viewport gloss is its
own short sentence defining it as a panel rather than the window; "directory" is
now "folder" in window prose, with "directory" kept only inside CLI text where
the flag is named `--output-dir`; drop target is "a file can also be dragged
straight onto a card"; truncated is "shortened with dots in the middle";
fixture is not used in reader-facing prose; step 3's four actions are split
across two sentences with the taxonomy-identifier gloss ahead of its use; SQLite
is introduced after the plain word "database" rather than before it; the
Cressdnaviricota example is now paired with a familiar one (an unclassified
enterovirus); the "same total spread over one" sentence is two plain sentences;
the Import Center is flagged as replacing a plain file-open dialog; the Files
found count is called informational only; the What it is opener states in its
first line that this is a file somebody else made.

Rows not applied, and why. Two ask for numbers no source gives: "roughly how
many accessions a typical run names" and a firmer figure for how much of a
reference should carry reads (the latter got a hedged "several separated parts
of the genome" rather than a number). One asks to move the command-line section
behind a collapsed block, which is structure and belongs to the Lead. One asks
to rename the chapter file, also structural. One asks to make the Next link text
match chapter 09's title, and it already does ("Novel Virus Diagnostics" is that
chapter's front-matter title). One asks to name what a valid header must
contain, which no source states as a reader-checkable list, so the text says
only that it must match the shape of a virus-hits table. One asks whether
grouping survives an unresolved name, which is answered from the sort order
rather than from a source claim about grouping.

## Rulings

**Fixture.** Before you start names `Tests/Fixtures/naomgs/virus_hits_final.tsv.gz`,
uses the CONSISTENCY Download ZIP sentence with its last clause changed to
"and find the file inside it under `Tests/Fixtures/naomgs/`", and says in one
sentence that it is a small five-site wastewater run kept in the repository for
testing. No origin invented. `fixtures_refs` stays an empty list, since this is a
test fixture and not a published manual fixture under
`docs/user-manual/fixtures/`. **For Phase 5:** the fixture question from
author.md and fidelity.md stands. Every other chapter in this part links a
published fixture with a README and a citation block. Either promote this file
with provenance and licence notes or obtain a publishable sample. If a cleaner
sample set arrives, the worked figures that need re-running are 35 hits, 4
distinct taxa, 7 taxon-table rows, the 12/8 and 28/26 pairs with their 67 and 93
percent, 7 accessions, and 4 extracted reads.

**Where the import lands.** Stated plainly in three places. Step 3 gives the
Import Center path (`Analyses`). The Output directory setting and the CLI
example give the command-line behaviour, that it writes into whatever folder you
name with no `Analyses` component, and both instruct the reader to pass the
project's `Analyses` folder itself. The bundle name is from the input file stem,
`naomgs-virus_hits_final` on this fixture, used consistently in prose and in
both code blocks.

**"Commit the import".** The button is **Run**. Sourced from
`NaoMgsImportSheet.swift:98`, which calls `ImportSheet` without passing
`primaryTitle`, and `DialogSheets.swift:44`, whose default is `"Run"`. The
chapter's `canRun` guard in the same file confirms the name.

**NAO-MGS expansion.** No expansion exists in `Sources/`, in
`docs/user-manual/features.yaml`, or in `GLOSSARY.md`. Searched for
"Nucleic Acid Observatory" and for any expansion string across all three. The
chapter therefore says LGE uses the pipeline's own name and does not expand the
letters, and names it as a metagenomic sequencing pipeline whose output LGE
imports.

**The Taxa card.** 7 sample-and-taxon rows against 4 distinct organisms, stated
together in the summary bar subsection, with the overview pane's Unique Taxa
card named as the source of the 4. Those two numbers are used consistently
everywhere they appear.

**Worked figures.** Every count matches author.md. The Rotavirus A figures are
now quoted once each with their site named: IL_CHI_StickneyWS is 12 hits from 8
unique, and CA_LosAngeles_County is 28 hits from 26 unique with 7 accessions,
both sourced to the bundle's `manifest.json`. The detail-pane example is
explicitly the CA row, so 26 and 28 appear there as the same numbers the table
showed, and the miniBAM heading example uses that row's real 7 accessions
against the cap of 5, which replaces the invented 3-of-3 and 5-of-12 pair. The
35-against-34 reconciliation says the command-line summary's 34 counts one
sample's rows, is confined to that command, and that the viewport's numbers come
from the importer.

**`--by-db`.** One sentence, disclosing that it always returns zero reads on an
imported bundle because the merge drops the per-read rows, and directing the
reader to `--by-classifier`.

**Terminal-only material.** The Settings section opens the way chapter 09's
does, saying the sheet has no settings, naming its whole surface, saying the
three flags are command-line only with no equivalent in the window, and closing
with "A reader working only in the window can skip them." Procedure step 2 says
the same thing in one clause so the two sections do not contradict. The command-
line section uses chapter 33's optional-section opener, adapted only in its
second clause for an import-only tool, and it keeps the "headless" gloss and the
CLI Reference link that the previous draft dropped.

**Glosses at first use.** All listed terms glossed. See the consensus section
above for the wording of each.

**Thresholds.** "There is no threshold the app enforces" is gone as a standalone
disclaimer. The half rule is now introduced as a rule of thumb, and the
"enforces nothing" clause follows it as support rather than preceding it as a
contradiction.

**Network.** Left out. See below.

**App defects.** All five disclosed in one sentence each, where the reader meets
them: the miniBAM note mislabel in the detail-pane subsection, the two taxon
counts in the summary bar subsection, the summary command's first-sample defect
and its blank Organism column in the command-line section, and `--by-db` in the
same section.

## Facts I could not source

**Whether taxonomy name lookup needs a network connection.** Three readers asked.
Per the ruling, this is stated only if a source says so. Nothing in the sources
I read states it, and the chapter says only that the step looks names up at
NCBI. Left out. Worth a source check by whoever can run the import offline,
since a reader who ran `--no-fetch-references` may reasonably ask.

**How many accessions a typical NAO-MGS run names.** One reader asked. No source
gives a range, so the Fetch references setting says "many hundreds" as the
condition for turning it off rather than quoting a typical figure.

**How much of a reference should carry reads.** One reader asked for a number.
No source states one, so the text gives a qualitative guide instead.

**Bit-score range.** The `--min-bitscore` sentence gives low tens to hundreds for
a read of a few hundred bases. That is general alignment knowledge rather than
an LGE source claim, and it is phrased as "typically" so a reviewer can tighten
or remove it.

## Left for the gate

- Both front-matter flags.
- `estimated_reading_min: 6`. Fidelity flagged it as too low and as wrong across
  the whole classification set, so it is a sweep rather than a chapter fix.
  Untouched.
- `glossary_refs` trimmed from 20 entries to the 16 the body actually links.
  Dropped: `coverage`, `depth`, `mapping`, `read-classification`,
  `reference-genome`, none of which the rewrite links. Fidelity's front-matter
  note asked for either linking or dropping, and dropping is the smaller change.
- The `import.nao-mgs` registry `notes` field still says the result lands under
  `Analyses` as `naomgs-<sample>`, which is right for the Import Center only and
  wrong about `<sample>` on both paths. Not mine to edit. Flagged by fidelity
  too.
- `help-ids.yaml:367-368` points `viewport.CzIdResultViewer` at
  `06-classification/07-importing-cz-id-results`, but that chapter is `08` and
  `07` is Freyja. Outside this chapter.
- The CONSISTENCY sheet's "Where imported classifier results land" section
  should gain the CLI half of this chapter's ruling, that the NAO-MGS
  command-line import writes into whatever `--output-dir` names with no
  `Analyses` component. Its `knownTools` sentence is also slightly misleading
  for imported-result tools, which use `<tool>-<name>` rather than a timestamp.
- Whether the command-line section's opener is a fixed sentence run the way
  Before you start's is. This chapter now uses chapter 33's wording per the
  ruling, which settles it here, but the sheet should record it.
- Screenshots. The `nao-mgs-result-viewport` shot must be read carefully when
  captured. If the Taxa card shows 7, the summary-bar text stands as written.
  The miniBAM heading string and the `Taxid:` line should be checked in the same
  pass.
