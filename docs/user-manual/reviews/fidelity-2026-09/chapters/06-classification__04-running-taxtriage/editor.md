# Editor pass: 06-classification/04-running-taxtriage

Date: 2026-09-07
Editor: brand copy editor
Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-classification/04-running-taxtriage.md` prints "no issues found".

## The big ruling: raw reads replace the extraction

Every run figure in the chapter came from the 83,591 read pairs Kraken 2 had
already extracted as SARS-CoV-2. The chapter now quotes only the raw-read rerun
recorded in `author.md`'s final section. The dataset is described as the
SRR36291587 reads, an amplicon library of paired-end Illumina reads from a human
clinical specimen, the same fixture the Kraken 2 chapter used, and the reference
run is stated as classifying 85,199 read pairs. The archive's deposited count of
86,281 is dropped entirely, since the chapter needs no second count.

| Figure | Was | Now |
|---|---|---|
| Single-sample runtime | 72.2s | 73.4s |
| Two-sample runtime | 85.5s | 86.2s |
| % Reads | 97.52% | 96.9542% |
| Reads aligned, pipeline report | 163,031 | 165,208 |
| Reads aligned, SQLite database | 165,500 | 168,265 |
| Mean depth | 1249.7 | 1258.7 reads per position |
| K2 reads | 82,234 | 82,983 |
| Unclassified | 1 read | 770 read pairs |
| Unique reads | 5,690 | 6,865 |
| Two-sample rows parsed | 29 | 30 |
| Subsample depth / K2 reads | 149.5 / 9,851 | 147.7 / 9,748 |

The two aligned-read counts are reconciled in What good looks like in one
paragraph that names each source once. 165,208 is the count the pipeline wrote
into its own report. 168,265 is LGE's recount from the alignment file after
duplicate marking, and it is what the app's Reads column shows. Neither number
is quoted anywhere else without its source. `Covered Bases` is not quoted, per
the ruling and the author's own note that 33,878 exceeds the 29,903-base genome.

The extraction-removed-the-non-viral-reads framing is gone. The old sentence
"which is what an amplicon library of a single virus should return from a
database holding only viruses" is replaced, and the 770 unclassified pairs get
their own paragraph explaining them as primer sequence, host DNA the Viral
database does not hold, and reads too poor to place, kept few by PCR enrichment.

## False rows applied (9 of 9)

1. **Result folder name.** Now `taxtriage-batch-<timestamp>`, with the added
   sentence that LGE names every TaxTriage run a batch whether it holds one
   sample or several, and a real example name for reader 4's angle-bracket
   complaint.
2. **Colon convention.** Settings opener now says five of the six advanced
   labels carry a trailing colon and names Skip Krona visualization as the one
   drawn without one. Reworded to match the Kraken 2 and EsViritu opener.
3. **Six-column table.** The single-sample table is now six columns, Organism,
   TASS Score, Reads, Unique Reads, Coverage, Confidence, with one sentence
   saying a multi-sample run adds Sample, Coverage Depth, and Abundance.
4. **Fifteen rows.** The reference run section now says the table shows the
   species plus the lineage rows from `root` down through `Sarbecovirus` plus an
   `unclassified` row, fifteen in all, and the Organisms card reads 15. The CLI
   section's "Parsed 15 taxonomy rows" line now explains the same thing.
5. **Action bar.** Extract FASTQ added between Export and Open Report. Related
   moved into its own sentence as a button that appears only once the project
   holds other analyses.
6. **Batch overview layout.** The claimed second summary table is gone. The
   grid's leading columns are described in one sentence, with the Risk column
   appearing only when the batch holds a negative control.
7. **Contamination flag.** Both surfaces are now described. The overview's Risk
   column triangle with the tooltip "Detected in negative control sample", and
   the per-sample table's orange organism name with a triangle. The chapter now
   says plainly that neither view names the control sample.
8. **Extraction command.** Rewritten to `--accession NC_045512.2`, which is the
   flag `--tool taxtriage` actually requires.
9. **Flag explanation.** The following paragraph now explains `--accession` and
   Copy Accession Number, and notes that Kraken 2 results use `--taxon` instead.

## Unverifiable rows (3 of 3)

1. **Required Setup pack.** `PluginPack.swift:431` shows "Required Setup" is a
   category, not a pack, and the pack that carries Nextflow takes its name from
   the lock manifest, where `displayName` is "Third-Party Tools". Rather than
   introduce a name the reader gains nothing from, the chapter now says LGE
   installs Nextflow on first launch as one of the tools it needs before you can
   create or open a project, and that no action is required. This also settles
   the consensus reader row asking for the same statement.
2. **Upstream TASS expansion.** Hedged. The chapter now says nothing the app can
   cite records what the upstream project calls the acronym, so treat the
   expansion as LGE's name for it, and adds that the score itself is not in
   doubt on that account. That also settles the two-reader row asking whether
   the warning was about the name or the number.
3. **Deposited pair count.** Cut. 86,281 no longer appears.

## Consensus reader rows applied (24 of 24)

Docker Desktop now carries the fixed CONSISTENCY.md sentence plus a free
download from docker.com and the menu-bar whale icon as the running check.
Apple Containerization is stated as automatic on macOS 26 and later on Apple
Silicon, sourced from `ContainerRuntimeFactory.swift`, which selects it first and
falls back to Docker with no user choice. Colon-plus-period explained once in
the Settings opener. Max memory points at Apple menu, About This Mac, Memory
line. Extra arguments says to leave it empty. Depth glossed at first use as the
average number of reads covering each position. Nextflow stated as needing no
action. Database sizes now say what Viral, Standard, and PlusPF each contain.
The forty-character revision string is called a version identifier LGE fills in
that the reader never types. The CLI prerequisite check is marked optional in
chapter 33's wording. Read-pair counts reconciled to one number. The alignment
pane is glossed at first mention and links to
`../04-alignments/02-reading-an-alignment.md`. Abundance now states its unit as
a proportion between 0 and 1 of that sample's classified reads. The report file
is named `report/<sample>.odr.txt` with a Finder route. Aligned-read counts
reconciled as above. Repetitive stretch, bundle, single-end, assembly, and
amplicon library each glossed in one clause at first use. K2 Confidence now says
the fraction is the share of a read's k-mers that must agree and that a demoted
read moves to the lowest common ancestor of its candidate taxa. The 0 to 100
scale is stated before the 99 is quoted. Value-facet control is now a menu, in
prose and in the shot caption. The amplicon exception to the unique-read rule is
stated in its own paragraph.

## Other reader rows applied

TaxTriage stated as a chain of programs in the first sentence. FASTQ glossed.
Map glossed. Commit glossed. Second pass rewritten as second round. "Settings"
meaning situations rewritten to "situations". Tile expanded to "spread across
the reference". LGE introduced in its own short sentence before the possessive.
Run folder forward-referenced to step 4. The long opening sentence split at read
classification. The dialog-title reassurance moved ahead of the window name.
Prerequisite indicators stated as reading Docker unless on macOS 26, with the
text label named as a non-colour cue for the red-green deficient reader. Spinner
given a rough settling time. Why you would add a row by hand stated before the
naming. The separate Kraken 2 tool named explicitly. "Segments" replaced with
three choices. Error profile glossed. Platform sourcing named. TASS band
boundary rewritten as "0.40 to below 0.80". BLAST glossed at the band table.
Good case named before the bad case. Samplesheet glossed at its first use in
Settings. TSV glossed. Rank letters expanded. Database path location named. The
106 output files narrowed to the three that matter. First-run duration given as
tens of minutes. The five sample roles each given a clause, with the two that
feed the contamination check named. Step disagreement given a concrete example.
Middle-range breadth given a sentence. Depth judged as ordinary for an amplicon
run. Subtraction clarified as flagging without removal. CLI file names changed
to `SRR36291587_1.fastq.gz` and `_2` so they match the rest of the chapter.
Headless glossed. Which views the reporting gap affects stated plainly, and the
contamination flag stated as surviving it.

The reporting gap moved ahead of the band table and the organism table, which
settles both the "flag the gap before the band table" row and the High
Confidence card row, since the card is now explained where the reader meets it.

## App defects disclosed

Both in one sentence each, where the reader meets them. The TASS Score column,
the Confidence column, and the High Confidence card all read zero on this
revision, stated in the Reading the results opener and expanded in its own
subsection. The Open Report button is disclosed as not reliably opening the
`.odr.txt` file, with the Finder route given instead.

## Facts I could not source, left for the gate

- **Open Report and the `.odr.txt` file.** `TaxTriageResultViewController.swift:4024`
  opens the first PDF among the output files, else the first entry of
  `result.reportFiles`, else the output directory. Nothing guarantees that entry
  is the `.odr.txt`. Per the ruling I routed the reader through the Finder and
  disclosed the button's behaviour rather than claiming it opens the report. If
  the gate can confirm the ordering, the sentence can be simplified.
- **First-run download duration.** "Tens of minutes on an ordinary connection"
  is an estimate. No timed cold run is recorded anywhere in the review
  materials, and readers asked for an order of magnitude. Worth replacing with a
  measured figure if one is ever captured.
- **Required Setup pack name.** Resolved by not naming it, as above. If the gate
  prefers the manifest's "Third-Party Tools" display name in the prose, the
  sentence is one clause away.

## Not done

Front-matter flags untouched. `brand_reviewed` and `lead_approved` both remain
`false` for the gate to flip.
