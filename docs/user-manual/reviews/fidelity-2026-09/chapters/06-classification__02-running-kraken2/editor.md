# Editor pass, 06-classification/02-running-kraken2

Date: 2026-09-07
Role: brand-copy-editor
Chapter: `docs/user-manual/chapters/06-classification/02-running-kraken2.md`

Inputs read in full: `fidelity.md` (104 true, 9 false, 2 unverifiable),
`readers.md` (four-reader merge, 106 rows, 23 consensus items),
`author.md`, `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
`docs/user-manual/STYLE.md`, and the project manager's five binding rulings.

Section order is unchanged. No settings paragraph was added or removed. All 22
settings keep their bold labels verbatim, colon-terminated labels included. No
other chapter, `GLOSSARY.md`, or `parameters.yaml` was touched.

## Changes from false fidelity rows (ruling 1)

Nine false rows, all fixed.

- **Why you would do this, read-pair count.** "86,281" became "85,199", matching
  every other count in the chapter. Source: fidelity row on the pair count, and
  the four-reader consensus row on the same contradiction.
- **Step 1, database row count.** "Nine Kraken 2 collections are listed" became
  "Eleven Kraken 2 rows are listed", split into nine downloadable collections
  plus SILVA and Greengenes, which LGE builds locally. Source: fidelity row
  citing `PluginManagerView.swift:893-905` and the tool lock manifest.
- **Step 1, recommendation banner.** "the largest collection that fits your
  Mac's memory" became "the largest general-purpose collection that fits
  comfortably in your Mac's memory, leaving headroom for everything else the
  machine is doing", with the added sentence that specialist collections such as
  Viral are never recommended this way. Source: fidelity row citing the 60 %
  headroom fraction and the six-candidate restriction. The same correction was
  applied to the `conda db recommend` description in On the command line, which
  carried the same wrong rule.
- **Step 3, Operations Panel row title.** "`Classifying SRR36291587`" became
  "`Profiling SRR36291587_1.fastq`", with the reason stated, that a run started
  from the dialog always classifies and then profiles with Bracken. Source:
  fidelity row citing `makeProfileConfig` and the `.profile` goal label.
- **Sensitivity preset section, Vibrio phage.** "one read of a Vibrio phage"
  became "two reads of a Vibrio phage". Source: fidelity row against
  `run-sensitive/classification.kreport`.
- **Moving around the tree, provenance popover.** The list of what the popover
  shows was replaced with the verified list, dropping the preset and the
  database version and adding the database path, hit groups, threads, and
  memory mapping. Source: fidelity row citing `TaxonomyProvenanceView.swift:53-101`,
  which notes the chapter inherited a stale doc-comment.
- **On the command line, kreport columns.** "the six-column summary the viewport
  reads" became "the per-taxon summary the viewport reads", followed by the
  sentence that Kraken 2 writes six columns by default and LGE always asks for
  two extra k-mer columns, so an LGE report holds eight. Source: fidelity row
  citing the unconditional `--report-minimizer-data`.
- **On the command line, `--taxon` source (two rows folded together).** Copy
  Taxonomy Path no longer claimed to copy the number. The text now says the
  taxonomy identifier sits in the kreport's seventh column, states what Copy
  Taxonomy Path and Copy Taxon Name actually put on the clipboard, and points
  the reader at **Look Up on NCBI > NCBI Taxonomy**, whose URL carries the
  number (`TaxonomyViewController.swift:374`). Source: the two fidelity rows on
  the clipboard and the fifth column.

## Changes from unverifiable fidelity rows (ruling 2)

- **"taken from a human clinical specimen"** dropped from the fixture
  description. Nothing in the campaign inputs establishes the specimen source.
- **"the finished database can then be pointed at from the Databases tab's
  storage location"** replaced with the verified negative, that LGE offers no
  supported way to register a hand-built index so the Database picker lists it.

## Changes from ruling 3, the command-line section

- The `lungfish-cli extract reads --by-classifier` form was kept as written.
- The all-unclassified failure was rewritten to say what actually fails. Kraken 2
  finishes and writes its report, LGE fails reading that report back because it
  holds no classified taxon, and this happens before the Bracken step runs.

## Changes from reader rows hit by three or more readers (ruling 4)

Every consensus row was addressed.

- **Sliding window and minimizer (two rows).** What it is now defines a k-mer
  with a worked example, defines a sliding window as a fixed-width stretch
  stepping one base at a time, and says what "smallest" means for a k-mer.
- **Core assignment rule.** Stated as counting, so the taxon holding the most
  matching minimizers wins the read, subject to the confidence threshold.
- **"Run it as a screen."** The question form was dropped and screen is glossed
  as a first quick pass you follow up rather than trust.
- **Read-pair count mismatch.** Fixed under ruling 1, and paired-end is now
  glossed at first mention with the statement that every count is a count of
  pairs.
- **RAM banner.** The banner is now said to have already checked the memory,
  removing the assumption that the reader knows their own figure.
- **Standard-8 versus Standard-16.** The number is now stated to be the memory
  the collection needs, 8 GB and 16 GB, with the fallback of taking the banner's
  recommendation.
- **"Pinned build."** Glossed as the exact version this release of LGE was
  tested against.
- **Hit group.** The Min hit groups entry now defines a hit group as one
  unbroken run of neighbouring k-mers pointing at the taxon, separated from the
  next by at least one k-mer that does not.
- **Bracken among the controls.** The entry now opens by saying it is a column
  rather than a control, and closes by saying there is nothing to set.
- **Betacoronavirus pandemicum.** A paragraph before the table explains that
  SARS-CoV-2 sits below it as a named subspecies and that viral taxonomy names
  species that hold familiar viruses as members.
- **BLAST e-value comparison.** Removed. Confidence is now explained on its own
  terms, saying what it does and does not tell you, with no e-value.
- **Command-line section optionality.** The section opens by saying it is
  optional, that nothing in it unlocks a result the dialog cannot produce, and
  glosses headless.
- **"Reads off the run."** Changed to "reads off the series".
- **"Bundle."** Glossed at first use in Step 2, linked to the Glossary, with a
  note on what marks one in the sidebar, and the bundle / sample / dataset trio
  distinguished in one sentence.
- **2.6-second runtime.** Now stated to be the normal shape of the thing,
  because classifying a read is a table lookup, with the warm-cache caveat
  rewritten without the unglossed "file cache" and with the direction of the
  first-run penalty stated. No new duration was invented.
- **Confidence values.** The entry now says what 0.20 means as a fraction of a
  read's k-mers, with 0.00 and 0.50 as anchors, and the Sensitivity entry
  defines both numbers before quoting the presets.
- **Memory mapping default.** Rewritten so the reader is told the box stays off
  for every database that fits memory, that this is the state they will see, and
  that it ticks itself otherwise.
- **Reads or read pairs.** Stated once above the first table that every count in
  every table in the chapter is a count of read pairs.
- **Five species for Sensitive.** Now written as "five species in total, four
  more than Balanced found".
- **How the three false calls were judged.** The two grounds are now stated,
  the one- and two-read counts against phiX's five, and the absence of any route
  into the sample, with the caveat that this judgement leaned on knowing what the
  sample was.
- **Threshold between "a handful" and "a few thousand."** Under about ten reads
  is noise, a hundred is a sensible line on a library this size.
- **"Exits with status 64."** Kept but glossed as a numeric code meant for
  scripts, which readers typing by hand can ignore.

## Changes from reader rows with a one-or-two-sentence fix (ruling 4)

Two-reader rows.

- Click instruction split from the dialog-title explanation in Step 2.
- The batch sentence split in two, and the number of result folders stated.
- "operating system's file cache" replaced with plainer wording.
- Step 3 now says to reselect the bundle before reopening the dialog, and why.
- The mid-procedure punctuation note removed from Steps 2 and 4 and consolidated
  into the Settings lead.
- Bracken's "parked its reads" replaced with "stopped" at both earlier
  mentions, and abundance defined at the first one.
- Escape and Cmd-0 now say the chart must have focus and that neither closes the
  window.
- Species reported staying at 1 is now interpreted, and the 718-read remainder
  explained as reads stopping above species.
- "denominator" removed in favour of "shares of only the reads that matched".
- Copy Taxonomy Path fixed under ruling 1, including what the copied text looks
  like.
- The Next section now says when to reach for EsViritu.

One-reader rows with a one-or-two-sentence fix.

- Alignment glossed in What it is.
- "a point the whole rest of this chapter turns on" changed to "depends on".
- Yield, host DNA, assembly, and the 96-well plate glossed in Why you would do
  this.
- Empty-folder clause and the Cmd-shortcut convention added to Before you start.
- SRA stated to need no account.
- conda environments described as self-contained inside the app.
- The plugin pack's ready state named ("4 of 4 ready", **Install All**),
  verified against `PluginManagerView.swift:566-577` and `:715` rather than
  taken from the reader's suggested wording.
- Version-difference expectation stated in the Procedure lead.
- The CLI line in Step 1 marked optional.
- Collection stated once to be one database.
- PlusPF expanded as Plus Protozoa and Fungi, and one line added on what makes a
  collection worth choosing.
- Mate detection explained as matching the mate markers in filenames, with both
  the `_1`/`_2` and `_R1`/`_R2` forms, verified against
  `MetagenomicsSampleInput.swift:131-142`.
- The two numbers behind Sensitivity named in Step 2, and Balanced stated to be
  what the worked example uses.
- Action bar located, the taxon to right-click named, the reading-first option
  offered, and the extraction button named **Create Bundle**, verified against
  `ClassifierExtractionDialog.swift:34-41`.
- Settings lead now says how many controls are always visible, and that the
  command-line closing sentences can be skipped.
- Threads entry says raising it risks nothing but responsiveness.
- Column header filter says how the menu opens and gives an example threshold.
- Destination entry glosses the hover message, says the 10,000 cap counts read
  records, and names the dialog's own "N unique reads" readout.
- Sample, Rank, and the percent column defined; the percent column named as the
  app heads it, **%**, and identified as a clade percentage.
- Clade glossed inline and linked.
- Large and near-zero Direct given proportional meanings.
- The nonzero Direct at the domain row explained as lowest-common-ancestor
  assignments.
- The missing comma added to the unclassified sentence.
- Viruses at domain rank explained as the database's own taxonomy.
- Why Bracken did not push the subspecies reads down explained.
- Provenance said to be what goes into a methods section.
- Reference fragment glossed, and the loss stated to scale with the cap.
- Why capping hurts the abundant organism most explained in one clause.
- An example long-tail rule given in the same sentence.
- The full Standard size given as sixty-seven gigabytes, resolving the clash
  with PlusPF's seventy-two.
- phiX described as a small virus that infects bacteria.
- Pairs and records distinguished at the extraction count.
- The Bracken flag cross-referenced to the Bracken column entry, and stated to
  be the only difference between the two routes.
- BLAST described in one clause where the long-tail advice sends the reader to
  it.

## Front matter

`glossary_refs` gained `bundle`, `clade`, and `paired-end`, matching the anchors
the body now links, per ruling 4. Nothing else in the front matter changed, and
`brand_reviewed` was left at `false` because this pass is the campaign editor
pass rather than the standalone brand gate.

## Deliberately left unchanged

- **Section order, settings count, and settings labels.** Ruling 4 forbids
  changes, and none were made. The Settings section still documents 22 settings
  in the same order with the same bold labels.
- **The four false claims that belong to other files.** The nine-collection
  undercount in `01-foundations/07-plugin-packs.md` and the six-column kreport in
  `GLOSSARY.md` are other roles' files. The project manager has already ruled the
  glossary entry corrected, so this chapter now matches it.
- **Durations the readers asked for.** Three reader rows asked for the SRA
  download size and time, how long installing Metagenomics takes, and a time
  range for a first run on a larger database. No campaign input measures any of
  them, and the prose rules forbid unsourced durations, so each was answered with
  direction rather than a number. The first-run row was answered by saying the
  wait grows with the collection size, the Metagenomics row was left unanswered,
  and the SRA row was answered only on the account question. **For the project
  manager, if measured figures for those three exist, they can be dropped in.**
- **`parameters.yaml`'s stale `conda extract` entry point.** The fidelity review
  found the registry still names the deprecated `conda extract` form and its
  flags. Ruling 3 keeps the chapter on `extract reads --by-classifier`, and the
  registry belongs to another role, so it was left alone. **For the project
  manager to route.**
- **The `kraken2-taxonomy-viewport` and `kraken2-databases-tab` captions.** The
  fidelity review flagged that the first places the breadcrumb bar over the
  sunburst when it spans both panes, and that the second will now show eleven
  Kraken 2 rows rather than nine. Captions are the screenshot author's, so both
  are noted here rather than edited. **For the project manager to route.**
- **The reader row asking the unclassified count to be put in the first table.**
  Adding a row to a fixture-derived table is a content change beyond a
  sentence-level fix, and the count already has its own paragraph immediately
  below the table.

## Lint

```
$ LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-classification/02-running-kraken2.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/06-classification/02-running-kraken2.md: no issues found
```

One warning was raised on the first run and fixed. The Settings lead had quoted
a colon-terminated label inline as `**Confidence:.**`, which the sentence-colon
rule flags. The sentence was rewritten to describe the convention without
quoting a label.
