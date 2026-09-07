# Editor pass, 03-reads/05-decontamination.md

Date: 2026-09-07
Role: brand-copy-editor
Inputs: `fidelity.md` (78 true, 5 false, 5 unverifiable), `readers.md` (53
rows, 23 hit by three or more readers), `CONSISTENCY.md`, `STYLE.md`, the
project manager's eight binding rulings.

`author.md` does not exist in this review directory, so the pass ran on the
fidelity report, the merged reader report, the consistency sheet, and the
style guide.

## Changes from project-manager rulings

**Ruling 1, output location.** The Procedure's closing line was
`` The result lands under `Analyses/<tool>-<timestamp>/` in your project ``.
Corrected to "The result lands directly under `Analyses/` in your project, in
a bundle named for the operation that made it". This is the only occurrence
of the timestamped shape in the chapter. `CONSISTENCY.md` was updated
independently during this pass and now states the same rule, naming
`FASTQOperationDialogState.defaultOutputDirectory` and giving `fastpTrim` as
the example shape, so the chapter and the sheet agree. Also satisfies
fidelity row 34 and the reader row asking for a real folder name instead of a
placeholder.

**Ruling 2, the SARS-CoV-2 reads are not on GitHub.** The second fixture URL
and the "its fixture folder sits beside the first one" sentence were removed.
Before you start now names the two fixtures and the three files up front,
keeps the GitHub download for the HG002 pair, and sends the reader to
[Downloading Reads from the SRA](02-downloading-from-sra.md) to fetch run
SRR36291587, saying it lands as a `.lungfishfastq` bundle under `Imports/`.
Added `03-reads/02-downloading-from-sra` to `prereqs`.

One deviation from the ruling's wording, flagged for the project manager.
The ruling says to send the reader "through the Import Center's SRA search".
The committed SRA chapter's entry point is
**Tools > Search Online Databases > Search SRA...**, and that chapter states
explicitly "You never open the Import Center yourself in this procedure"
(line 41). I pointed at the chapter and its landing folder without naming a
surface, so the two chapters do not contradict each other. The ruling's
substance, fetch SRR36291587 as that chapter shows and it lands under
`Imports/`, is carried in full.

The human-read-removal worked example, both Deacon blocks, and every count
are unchanged, as instructed.

**Ruling 3, databases.** "the three decontamination databases" corrected to
two. The Before you start paragraph now says both Deacon indexes arrive with
Required Setup, names them as the Plugin Manager shows them, and states that
PhiX is a FASTA bundled inside the BBTools environment rather than a managed
download or a Plugin Manager entry, which is why the count is two. Fidelity
row 54 (false) and row 51 (unverifiable, "Both arrive with Required Setup")
are both settled by the ruling.

**Ruling 4, Database row buttons.** Step 3 now reads "with Replace... and
Clear buttons beside it. The first button reads Choose... instead while no
database is selected." The `human-scrub-dialog` caption was updated to match,
since it described the old button pair. Fidelity row 18.

**Ruling 5, flag count.** "Three flags exist only on the command line"
corrected to "Four", which matches the four the sentence then lists
(`--absolute-threshold`, `--relative-threshold`, `--format`, `--threads`).
Fidelity row 76.

**Ruling 6, the 12000 NovaSeq figure.** Optical Distance now reads "Illumina's
own documentation for patterned flow cells puts the equivalent figure there
at 12000, so use the number your instrument's documentation gives rather than
the default." The figure is now attributed rather than asserted as app
behaviour. Fidelity row 46.

## Changes from reader rows hit by three or more readers

All 23 consensus rows were addressed.

1. `.lungfishfastq` is a folder. Added "Finder shows it as a single item you
   can click, so it looks like a file even though it is a folder", and linked
   `bundle` to the Glossary.
2. "Managed" glossed at the table lead-in. "Managed means LGE downloads the
   reference and stores it for you, so it is on your machine without you
   having fetched anything."
3. Spike-in, vector, carrier genome. The table cell now reads "A control
   genome, a cloning vector, or carrier DNA", and a paragraph after the table
   glosses all three in one sentence each. The same trio reappeared in
   Contaminant Mode and in Next, and both were rewritten to the glossed
   wording so the chapter uses one vocabulary.
4. "Unless you have your own Deacon index". Step 3 now says "Leave this row
   alone. Almost everyone does", and explains Replace... as existing for the
   rare reader who built their own index.
5. The 99.84 percent subtraction. Now stated twice. "Deacon reports what it
   kept, never what it dropped, so every percentage in that line is a kept
   figure", and on the HG002 block, "Subtracting it from 100 gives 99.84
   percent removed, or 45,502 of the 45,574 reads".
6. Threshold naming and numbers. New Provenance paragraph explaining that
   `absoluteThreshold` is LGE's name and `abs_threshold` is Deacon's, and
   that the differing numbers belong to the two different runs quoted in the
   section rather than to two records of one run.
7. The chr20 row. The table cell now reads "chr20 as a custom reference (a
   deliberate mistake, explained below)". The explanatory paragraph was moved
   ahead of the duplicate-threshold paragraph so the table rows are discussed
   in table order, and "Four of the five rows" became "Every row but the
   third".
8. Pixels on the flowcell. Optical Duplicates now opens "An Illumina
   instrument reads a run by photographing the flowcell one base at a time,
   so every cluster has a position in an image measured in pixels."
9. Patterned flowcell. Glossed in the Preset paragraph, with the etched-well
   contrast, four patterned instrument names and two unpatterned ones, and
   the advice to read the instrument name off the run report or ask the
   sequencing core.
10. The terminal command in Before you start. `lungfish-cli conda db
    install-managed --list` was moved out of Before you start and into the
    optional command-line section, where it also now notes that the command
    prints identifiers rather than the display names just introduced
    (fidelity row 55's optional note).
11. `--database-id deacon-panhuman`. The identifier now appears in the window
    section too, in the Remove Human Reads Settings entry.
12. The deprecated flag. Now "One flag does nothing at all, and it is the only
    one in this chapter that behaves that way", plus "It survives only so that
    scripts written against an older release keep running" and "Every other
    setting documented above does what it says."
13. The empty settings pane. Step 3 now says the pane "holds no controls, only
    a line of text saying so. That is normal and expected for this operation
    rather than a sign the dialog failed to load." This also incorporates
    fidelity row 19's note that the pane is not literally blank.
14. Placeholder folder name. Covered by ruling 1 above.
15. The 20 percent threshold. Its own paragraph now, stating it belongs to
    Remove Duplicates alone, glossing PCR-free and saying the core or the kit
    name tells you, and giving the action, re-prepare the library from more
    input rather than remove harder.
16. Amplicon glossed at first use and linked to the Glossary.
17. K-mer 31. Now carries the arithmetic, 4 to the power of 31 possible words
    against three billion genome positions, with a 15-base contrast, and a
    floor of 20 for shortening.
18. Window. "Shorten it when your reads are under about 100 bases."
19. "One operation is an exception to the word removal" rewritten to "One of
    the five can be turned around. Remove ribosomal RNA sequences has a Retain
    Reads control that chooses which class of reads is written out."
20. Supplied versus shipped reference. "Two of the three references ship with
    LGE and need nothing from you, and the third is a file you supply yourself
    when you want to strip something LGE does not carry."
21. The repeating-unit logic. Worked example added, `CAGCAGCAGCAGCAG`, with
    the reasoning spelled out.
22. Variant caller glossed inline and linked.
23. Coverage glossed inline and linked, at the point the argument first needs
    it.

## Changes from other reader rows

Sentence-or-two fixes, as instructed.

- Bacterial isolate replaced with a macaque sample, with a note that macaque
  is the quieter trap because some reads do come back. Follows the campaign
  rule of human or macaque examples.
- Mate-file vocabulary settled on one term. "the first of the two mate files"
  became "the R1 file of the pair", and "accepts both mate files at once"
  became "both files of a pair".
- Import inline. "the ordinary import with both files selected rather than
  any special action" added before the link to the import chapter.
- Plugin Manager located before it is used. **Tools > Plugin Manager...**
  (Cmd-Shift-B) added, per `CONSISTENCY.md`, together with a way to confirm
  Required Setup is installed.
- Next section now says which operations combine and in what order, and that
  one is usually enough.
- Tandem repeat glossed in Entropy Threshold, and the benchmark figures
  reframed as describing the tool's tuning run rather than predicting the
  reader's sample.
- Entropy scale ends explained, why the slider stops at 0.3 and 0.9.
- File count stated up front, "two fixtures, and you need three files in all".
- Timings reconciled. The four-second figure is now given as 3.90 seconds of
  index loading against 56 milliseconds of filtering, attributed to the
  SARS-CoV-2 fixture and scoped to Remove Human Reads, with the ribosomal
  index's ten milliseconds noted. Also settles fidelity row 49's optional
  scoping note.
- Backslash. "typed as part of the command, and it tells the shell that one
  long command continues on the next line".
- Micromamba glossed in place, "the tool LGE uses to keep each bioinformatics
  program in its own isolated environment".
- Clear button. "Clearing the row leaves the operation with nothing to match
  against, so the Run button will not proceed until a database is set again."
- Checksum glossed as a fingerprint and linked.
- Hamming Distance now points at Quality Control for Reads for judging
  error-prone reads.
- `--database-id` and the window. Settings entry now states the Database row
  is the window's equivalent of the flag.
- Expected shotgun range added, "anywhere from 50 to over 99 percent human",
  so seven dropped reads has something to be low against.
- Output Strategy exclusion explained without the unverifiable causal clause.
  See the fidelity section below.
- `norrna` versus non-rRNA reconciled in the Retain Reads entry.
- "Both" now says "two separate bundles out of one pass, one holding each
  class, rather than one bundle with the two classes mixed together".
  Grouped Result now says a paired R1 and R2 are not that case, since LGE
  holds both mates in one bundle, which also matches `CONSISTENCY.md`'s
  paired-end storage rule.
- Low-Complexity Filter table cell now says "it scores each read's entropy"
  rather than "it scores the read itself".
- Preset count. "Five other presets sit behind it" became "The picker holds
  six presets in all", matching the six in Settings and the shot caption.
- "Record it and stop" now says the kept count is already in the provenance
  sidecar.
- The 72-read result is now marked as a deliberate demonstration on a human
  fixture.
- Decontamination is not lab cleaning. First sentence now reads
  "Decontamination here is a computational step, not a bench one. Nothing is
  cleaned in the lab."
- The three and the two named explicitly rather than counted.
- Slice explained as the reads from one region of the chromosome, with the
  half-megabase window and why chromosome 20.
- SRR36291587 introduced as "a public sequencing run deposited in the
  Sequence Read Archive under that accession".

## Changes from fidelity rows not covered by a ruling

- Row 25, the Output Strategy exclusion. The causal clause "because it writes
  one file per retained read class rather than one file per input" was
  unverifiable and contradicted by the observed output, which holds one file
  per input mate. Replaced with the observed behaviour, "It writes into an
  output directory rather than to a single output file, so there is no
  one-output-per-input choice for the picker to make." This is the fidelity
  report's own suggested resolution.
- Row 11, optional. `read` added to `glossary_refs`, since the body deep-links
  it in the first paragraph. `bundle`, `checksum`, `coverage`, `amplicon`, and
  `variant-caller` added too, for the new inline links. All six anchors were
  confirmed present in `GLOSSARY.md`.
- Row 62, unverifiable, the 20 percent duplicate threshold. Softened and
  attributed to the field rather than to the app. "A duplicate rate above
  roughly 20 percent is the field's rough alarm line."

## Style and consistency changes

- `brand_reviewed` flipped to `true`. `lead_approved` untouched.
- App name. The first draft of my "two of the three references ship with LGE"
  sentence placed LGE before the first spell-out and the linter caught it. The
  paragraph was split so "Lungfish Genome Explorer (LGE)" comes first.
- Docker. "neither is Docker Desktop" became "neither is Docker, which other
  chapters in this manual need but this one does not", which answers the
  reader row without importing the fixed Docker sentence from
  `CONSISTENCY.md`, since that sentence is for chapters that do need it.
- No em dashes, no semicolons outside the quoted CLI block, no colons inside
  sentences. Verified by grep as well as by the linter.
- Checked every new sentence against
  `build/scripts/lint/rules/ai-tells-words.txt`. Nothing added uses a banned
  word or a banned sentence shape.
- Bullet caps respected. No new list was added to the chapter body. The one
  numbered list in Procedure is unchanged in length.

## Left unchanged deliberately

- **Section order, and the count of Settings paragraphs.** All 14 registry
  settings keep their bold labels verbatim and their positions. No settings
  paragraph was added or removed, per ruling 7.
- **Every number, every quoted CLI block, every count in the results table.**
  The fidelity review recounted all of them from the FASTQ files and found
  them true. Nothing numeric was touched except to restate 99.84 percent as a
  shown subtraction and to name 45,502 explicitly.
- **Other chapters and `GLOSSARY.md`.** Untouched, per ruling 7. Where a
  reader row wanted a term glossed and no Glossary entry exists (control
  genome, cloning vector, carrier DNA, patterned flowcell, tandem repeat,
  managed, micromamba, PCR-free, slice), the gloss is inline at first use.
- **`CONSISTENCY.md`.** Not mine to edit. It was updated independently during
  this pass and now matches ruling 1.
- **The `.lungfishfastq` extension and bundle vocabulary.** Kept as the
  consistency sheet writes them.
- **The three shot markers and their ids.** Only the `human-scrub-dialog`
  caption changed, and only to match the corrected button labels.
- **Fidelity row 63, "subs 2 keeps 44,871".** The figure is correct but the
  chapter never states it, and adding it would mean a sixth results-table row.
  That is a content addition rather than an editorial fix, so it is left for
  the project manager. Flagged below.

## For the project manager to rule on

1. **The Import Center wording in ruling 2.** I pointed the reader at the SRA
   chapter without naming a surface, because that chapter's entry point is
   **Tools > Search Online Databases > Search SRA...** and it states the
   reader never opens the Import Center in that procedure. If the Import
   Center really is a second route to the same download, the sentence should
   name it. If not, `CONSISTENCY.md`'s "reads fetched from SRA or ENA go
   through the Import Center" line describes the internal mechanism rather
   than the reader's path and may mislead a later chapter.
2. **Fidelity row 63, the Near Duplicate 2 figure.** Whether 44,871 kept at
   `--subs 2` should join the results table as a sixth row. It is verified,
   and it would let the Substitutions setting's "raise it to 1 or 2" advice
   land against a real number, but it adds a table row rather than editing an
   existing sentence.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/05-decontamination.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/05-decontamination.md: no issues found
```

## Status

brand_reviewed: true
