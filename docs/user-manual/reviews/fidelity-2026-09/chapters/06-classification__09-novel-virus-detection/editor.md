# Editor pass, 06-classification/09-novel-virus-detection

Date: 2026-09-07
Role: brand copy editor
Chapter: `docs/user-manual/chapters/06-classification/09-novel-virus-detection.md`
Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh ...`
prints "no issues found".

## 1. Fidelity rows applied

### False rows fixed (2)

- **Claim 23, filter bar order.** The sentence in step 4 now reads "three
  controls, which are the sample filter, the grouping control, and the search
  field", matching the built order at `NvdResultViewController.swift:1469`,
  `:1479`, `:1491`.
- **Claim 52, context menu item.** "Create Bundle…" is gone. The Reading the
  results paragraph now names **Extract to New Bundle…**, the default
  `createBundleMenuTitle` that NVD does not override.

### Incomplete row completed (1)

- **Claim 54, Export.** One added sentence discloses the defect where the
  reader meets it. "The exported table carries twelve of the fourteen columns,
  leaving out Unique Reads and Aln Length, so a comparison of Length against
  Aln Length has to be made in the window rather than in the exported file."

### Unverifiable row cut (1)

- **Claim 58, metadata columns surviving reopen.** The clause "and the columns
  survive closing and reopening the result" is deleted. Nothing replaces it,
  since the chapter has no verified persistence claim to make. If a GUI
  session later settles it, the sentence can return.

### Precision notes applied

- **Claim 22.** "A detail pane occupies the left side" becomes "A detail pane
  sits on one side and an outline of contigs on the other", with a following
  sentence naming the left position as the default and the Inspector's
  panel-layout preference as the thing that changes it. The
  `nvd-result-viewport` caption changes "the detail pane on the left" to "the
  detail pane alongside", as the fidelity note suggested.
- **Claim 25.** "in the order the pipeline ranked them" becomes "in rank
  order, best e-value first".

## 2. Consensus reader rows applied

The consensus list grew from 29 to 43 rows while this pass was running. All 43
are addressed below.

| Consensus row | What I changed |
|---|---|
| Database never named | New paragraph in What it is. The pipeline chooses and records a version rather than a name, so the chapter says "the pipeline's own BLAST database" and that it is not a database you pick or install. Per the PM ruling, since neither `author.md` nor the fixture CSV (`blast_db_version` only) records a name. |
| Snakemake terminal worry | "You never install or run Snakemake yourself. Somebody else runs the pipeline, usually on a computing cluster, and the finished results reach you as a folder of files." |
| GitHub folder download | The CONSISTENCY.md Download ZIP sentence, verbatim, after the GitHub link. |
| Folder nesting | A `text` code block showing the `nvd-demo` tree down to `demo_blast_concatenated.csv`, in Before you start. |
| Plugin pack ungossed | Glossed inline and linked. "A plugin pack is a themed group of external tools LGE installs on demand." |
| Experiment identifier late | Explained at first use in step 2. "a label the pipeline operator gave the run, carried in the CSV's first column, and it is not a count of anything". |
| "inside LGE land" | Cut, with every idiom around it. Replaced by three plain sentences per the PM ruling. |
| CLI flag inside a mouse step | The `--output-dir` offer is out of step 3. The step now states plainly that the Import Center always writes into `Imports`, that runs started in LGE go under `Analyses`, and that the demo project's `Analyses` copy exists only because it was imported from the command line with that destination. The flag stays in Settings and On the command line. |
| Metric pills | Glossed at first use. "A metric pill is a small rounded badge carrying one label and one number." |
| Alignment viewer undescribed | One sentence saying it draws the contig along the top and stacks the reads underneath at their matching positions, so depth and evenness are visible. |
| 220 and 160 points | Both figures cut. Replaced with "roughly the lower quarter of the window" and a drag description. |
| Settings flags with no window equivalent | Said once at the top of Settings, plus "A reader working only in the window can skip them." |
| Working directory | Glossed. "the folder the terminal is sitting in when you press Return". |
| No sort control | "there is no sort control, so the order is fixed by design. Clicking a column header does nothing here, unlike the spreadsheets and genome browsers where a header click sorts." |
| E-value direction backwards | Rewritten in the right direction per the ruling. Strongest is `1e-90`, weakest is `0.0`, said once that the scale is logarithmic, once that `0.0` means beyond the precision NCBI reports, once that smaller is better. |
| 1e-30 with no failing example | "A value such as `0.004` would fail that test and would tell you the match could easily be an accident." |
| Clade | Full gloss. "any group of organisms descended from one common ancestor, so it is a branch of the tree rather than a rung on the kingdom-to-species ladder". |
| Context menu run of items | Every item now carries a clause. Extract Sequence, Verify with BLAST, Copy FASTA, Export FASTA, Extract to New Bundle, and Run Operation each get one, with Run Operation given its own sentence naming the FASTQ/FASTA Operations dialog. |
| Em dash | "shows a grey dash rather than dropping the column". |
| Bit-score example both ambiguous and reassuring | Split. Shape first ("step down gently from bit score 750 to 660"), verdict second ("That shape would normally be a warning. Here it is not, because every one of the five matches names HIV-1"). |
| Pileup | Glossed and linked to `GLOSSARY.md#pileup`. |
| Exit status 1 | "the command stops with an error rather than writing a file ... finishing with an exit status of 1, which is the terminal's way of saying the command reported a failure." |
| Comparison before shared goal | The chapter now opens "A read classifier and Novel Virus Diagnostics ... are both trying to answer the same question, which is what organisms a sample contains." |
| Longer match asserted | New paragraph. "A chance resemblance between two sequences gets rapidly less likely as the matching stretch grows." |
| Third name for percent identity | "sequence agreement" is gone. The first mention now uses percent identity, linked, with the plain gloss beside it. |
| LabKey folder worry | "the pipeline's own internal label for its final stage and asks nothing of you". |
| Comma-separated before CSV | CSV is spelled out at first use. The glossary link was removed because `GLOSSARY.md` has no `#csv` anchor and I do not own that file. Flagged below. |
| Disclosure triangle early | Glossed at its first appearance in Why you would do this. |
| Checksum | Glossed. "a short fingerprint computed from a file's contents, and it changes if so much as one character of the file changes". |
| 10 hits / 4 contigs payoff late | Said at the number. "Ten hits for four contigs means most contigs carry several ranked matches, which is the normal shape of an NVD table." |
| RPB unexpanded | Expanded at the pill list in step 4 as "RPB (reads per billion)". |
| Fourteen columns run-on | Replaced by a table, one line of meaning each, per the ruling, with the six pill columns marked. |
| Partial-match threshold | "a match covering less than half a long contig's length is worth chasing", framed as a rough working line. |
| High eighties to mid nineties undescribed | Covered by the single reconciled identity statement below. |
| Bit score anchor and database size | "A larger database gives chance matches more opportunities to turn up, which is why an e-value moves with database size and a bit score does not", plus "comparable among one contig's own hits rather than between contigs or between runs". |
| "Large" bit-score drop | Not quantified, per the ruling. "Set the top hit's bit score against the second hit's. A drop of the same order as the top score itself means the call is clean, and two scores within a few percent of each other mean it is ambiguous." |
| Total read count and RPB anchor | Said the total is stored in the result and not shown in the window, and that RPB has no fixed good value so it is read by comparing contigs within one run. |
| Double "at least" | "The hits count can never be lower than the contigs count, since every contig carries at least one match." |
| Identity thresholds disagree | Reconciled to one statement, used identically in Reading the results and What good looks like. Near 100 is a known virus, high eighties to mid nineties is a divergent relative, below about 90 percent is the interesting case. The viewport draws no colour banding on identity, so it is framed as a rule of thumb per the ruling. The old "seventies or low eighties" is gone. |
| "Very few" reads | No number invented. "The check is to open the alignment ... A pileup covering only a short stretch of the contig, leaving most of its length bare, is the sign of an artifact." |
| Headless | Glossed. "with no app window at all, by typing commands into the Terminal application." |
| No path to a terminal | Links to `../appendices/cli-reference.md` for installing `lungfish-cli` and opening a terminal. |
| Raw CLI column names unmapped | A second table mapping each TSV column to its display name in the window. |

## 3. Other reader rows applied

Beyond the consensus set, these one- and two-reader rows are also fixed.

- 150-base read versus "a few hundred" reconciled to "typically about 150
  bases on an Illumina machine", used once and reused in the evidence
  paragraph.
- "census tool" replaced with "a tool for counting what is already known".
- "unwarranted confidence" replaced with "more confidence than the evidence
  supports", and the sentence split.
- The wastewater reason now precedes the definition, and says why the
  chapter's examples are viral.
- The asterisk in `*_blast_concatenated.csv` explained as standing for the
  run's prefix.
- gzip glossed as a compression format like zip.
- Numbered stage folders explained, with "nothing is lost by their absence".
- "The mental model to carry into the window" rewritten as a plain
  instruction to read contigs first and organisms second.
- "rather than the log files" cut.
- "a table of that shape" replaced by the plain statement that several rows
  describe the same contig.
- "flat table" replaced by "a table with no grouping".
- "checked by eye" replaced by "checked by hand".
- Menu ellipsis explained once, in step 1.
- "wizard sheet" glossed as a panel that drops down attached to the window.
- The "Unlike most cards" contrast cut.
- Path readout stated positively, with how to change it.
- Row counting noted as visible only on a larger run.
- The internal database file said to need nothing installed.
- The command-line cross-check in step 4 marked optional and terminal-only.
- Contig name parts explained, `NODE_2`, `length_300`, and `cov_5.0`.
- "an outline list of contigs the right" given its verb, and outline glossed
  as an expandable table.
- "deliberately fussy" replaced by the plain requirement.
- Hovering a disabled control stated as a general LGE behaviour.
- The step 5 warning moved to the top of the section.
- popover glossed.
- The Search contigs entry rewritten as a positive statement plus one short
  limitation, with "surface" as a verb removed.
- "so on contigs the e-value rarely does much work" rewritten literally.
- "despite the raw counts differing twofold" replaced by "although one has
  twice as many reads".
- Broad rank now says what to do, which is to report the group rather than a
  species.
- The information button described as a lowercase letter i in a circle.
- The Inspector given its menu path and shortcut, **View > Show Inspector**
  (Cmd-Option-I), verified against three committed chapters.
- "library" glossed as one prepared sample loaded onto the sequencer, and the
  sample/library distinction made once rather than left to collide.
- The "shape to worry about" metaphor split into short literal sentences.
- `/path/to/nvd-demo` explained as a placeholder.
- `--top 20` explained against the fixture, with `--top 2` named as the
  contrast, rather than changing the quoted command (the quoted transcript is
  a verbatim CLI run and must not be re-flagged).
- `--bundle` explained as keeping the reads with a record of where they came
  from.
- "byte-identical" replaced by "produce the same file".
- TSV and JSON glossed.
- On the command line opened with the optional-section sentence, matching
  `03-running-esviritu.md`.
- Read extraction explained in Before you start as pulling the reads that
  built a contig into their own file.
- BAM reconciled with NVD's contig workflow. "In NVD the reads are aligned
  back to the contigs the pipeline assembled rather than to an outside
  reference genome."
- Demo-run timing given alongside a real-run figure.
- The demo's limits stated up front in Before you start, naming step 5 and
  the extraction command, and repeated at each.
- The HIV-1 contig's counts now match between step 4 and What good looks
  like, both saying five matches in all.
- A **Troubleshooting** section added collecting the three failure states
  (preview warning, greyed-out Run button, missing BAM), each in one line,
  three bullets, inside the five-bullet cap.

## 4. Rulings applied

Every binding ruling is in the chapter.

- Fixture download uses the CONSISTENCY.md sentence verbatim.
- Import destination stated plainly in the Procedure, with the "LGE land"
  sentence and every idiom cut, no flag offered inside the window-only step,
  and the demo project's `Analyses` copy explained.
- Identity thresholds reconciled to one statement, framed as a rule of thumb
  because the viewport applies no identity colouring or banding, and the same
  figures used in both sections.
- E-values written in the correct direction, with the logarithmic scale, the
  meaning of `0.0`, and "smaller is better" each said once.
- Bit-score drop described by comparison rather than by an invented number.
- Drawer measurements cut.
- Every named term glossed at first use, including viewport, metric pills,
  headless, Snakemake, CSV, disclosure triangle, checksum, plugin pack,
  experiment identifier, reads per billion, By Taxon, working directory,
  pileup, and exit status 1.
- The fourteen columns are a table with one line of meaning each.
- Settings says once that the import has no dialog settings and that the two
  flags are command-line only, and the three viewport controls are labelled
  as controls of the result window rather than settings.
- The assembly-artifact check is the pileup covering only a short stretch, no
  read-count number invented.
- Each app defect is disclosed in one sentence where the reader meets it. No
  sort control in Reading the results, the twelve-column export in the Export
  paragraph, and the `extract reads --tool nvd` failure in the final
  command-line paragraph.

## 5. Left for the gate

- `brand_reviewed` and `lead_approved` both stay `false`. Not flipped.
- `estimated_reading_min` raised from 7 to 9, because the chapter grew by
  roughly a third with the glosses, the two tables, and Troubleshooting. If
  the gate would rather that number stayed put, it is a one-token change.
- **Not mine to fix, still open.** The fixture README
  (`docs/user-manual/fixtures/nvd-demo/README.md`) still calls NVD "Nucleotide
  Viral Diversity" and still says the rows are all SARS-CoV-2 hits. Both are
  wrong and another role owns that file (fidelity App defect 4).
- **Not mine to fix, still open.** `features.yaml:743-746` is wrong about
  both the workflow engine and the expansion (App defect 5).
- **Not mine to fix.** The DRIFT row for this chapter needs its "thirteen
  columns" corrected to fourteen and its sorting claim struck.
- **Template question routed to the Documentation Lead.** The fidelity review
  asks whether viewport controls with no registry row belong under Settings
  across the campaign. I kept them and labelled them as result-window
  controls per the ruling, but the campaign-wide answer is not mine.
- **Screenshot recipes.** `nvd-column-menu` needs metadata imported first, and
  `nvd-blast-drawer` needs a full NVD run, since the fixture ships no
  per-sample FASTA. Noted for the screenshot scout.

## 6. Facts I could not source

- **The BLAST database's name.** Neither `author.md` nor the fixture CSV
  records it. The CSV carries `blast_db_version` (`2.5.0`) and no name field.
  I applied the ruling's fallback and wrote "the pipeline's own BLAST
  database", and said the pipeline records a version rather than a name.
- **Metadata column persistence across reopen.** Cut rather than hedged, per
  the instruction. Unverified either way.
- **A `#csv` glossary anchor.** `GLOSSARY.md` has none, so the CSV gloss is
  inline with no link. `#pileup` and `#plugin-pack` both exist and are
  linked. Adding a `csv` entry is the Documentation Lead's call, not mine.
- **Whether the imported folder can be moved in the sidebar afterwards.** One
  reader row asked. No source settles it, so the chapter says nothing about
  moving the folder rather than guessing.

## Status

brand_reviewed: false (the gate flips it)
