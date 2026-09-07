# Author log, 06-classification/05-running-nao-mgs

Chapter retitled "Importing NAO-MGS Results". Roster row 36, registry id
`import.nao-mgs`. Rewritten against Preview 2026.9.13 sources and against a
real import of the repository's own NAO-MGS fixture.

## Fixture

The DRIFT roster marked the fixture an open item. A usable one exists in the
repository at `Tests/Fixtures/naomgs/virus_hits_final.tsv.gz` (4,937 bytes,
36 lines, 35 hit rows). It was found by
`find . -iname "*virus_hits*"` and copied to the scratchpad at
`<scratchpad>/nao-mgs/virus_hits_final.tsv.gz`. The demo project at
`~/Desktop/lge-docs/LGE Manual Demo.lungfish` holds no NAO-MGS output
(searched for `*naomgs*` and `*virus_hits*`, no matches).

The fixture is a five-site wastewater surveillance run. Sample column values
resolve to five sites once lane and sample suffixes are stripped
(CA_LosAngeles_County, IL_CHI_StickneyWS, MA_Boston_DITPN, NY_PLC_009, and a
Water control), spread over seven raw sample strings. Four distinct taxa:
Rotavirus A (28875), Human rotavirus A (10941), Cressdnaviricota sp.
(2748378), Otarine picobirnavirus (1187973).

Every number quoted in the chapter comes from the runs below or from the
manifest they produced. No count was invented.

## Commands run

Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(176 MB, built 2026-09-06 16:48).

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `lungfish-cli import nao-mgs --help` | 0 | Positional `<input-path>`; `--sample-name`; `-o, --output-dir` default "current directory"; `--fetch-references/--no-fetch-references` default `--fetch-references`. Confirms all three Settings paragraphs. |
| 2 | `gzcat virus_hits_final.tsv.gz \| head -3` | 0 | 30-column per-read schema, one row per matching read, carrying `query_seq`, `query_qual`, `prim_align_*` fields. Supports the "Why you would do this" opening. |
| 3 | `gzcat ... \| awk -F'\t' 'NR>1{print $2}' \| sort \| uniq -c` | 0 | Seven raw sample strings across five sites; 35 rows total. |
| 4 | `lungfish-cli nao-mgs summary <fixture> --top 20` | 0 | Printed one sample, "Total virus hits: 34", "Distinct taxa: 4", blank Organism cells, and columns TaxID / Organism / Hits / Avg %ID / Avg Score / Refs. Column list quoted in the chapter. The 34/one-sample result is the multi-sample defect recorded below. |
| 5 | `lungfish-cli import nao-mgs <fixture> -o <scratch>.lungfish --no-fetch-references` | 0 | Phase list (partition by sample, per-sample import, merge, resolve taxon names). Summary block quoted verbatim in the chapter: `Total hits : 35`, `Distinct taxa : 4`, `References fetched: 0`, `Output : naomgs-virus_hits_final`. |
| 6 | `find <scratch>.lungfish` | 0 | Bundle layout: `hits.sqlite`, `manifest.json`, `analysis-metadata.json`, `.lungfish-provenance.json`, `bams/<sample>.bam` + `.bai` one per site. |
| 7 | `cat manifest.json` | 0 | Per-taxon rows. Quoted: IL_CHI_StickneyWS Rotavirus A `hitCount 12 / uniqueReadCount 8`; CA_LosAngeles_County Rotavirus A `hitCount 28 / uniqueReadCount 26 / accessionCount 7`. The `Taxid 28875 • 26 unique / 28 total reads • 7 accessions` detail line in the chapter is that row rendered in the format string at `NaoMgsResultViewController.swift:1035`. |
| 8 | `sqlite3 hits.sqlite ".tables"` and a combined row-count query | 0 | Tables `virus_hits`, `taxon_summaries`, `accession_summaries`, `sample_hit_counts`, `taxon_read_names`, `reference_lengths`, `lungfish_database_state`. Counts: `virus_hits` **0**, taxon_summaries 7, accession_summaries 16, sample_hit_counts 5, taxon_read_names 34, reference_lengths 14. |
| 9 | `lungfish-cli extract reads --by-classifier --tool naomgs --result <bundle> --taxon 28875 -o ...` | non-zero | Failed with `--tool naomgs requires at least one --accession`. Quoted verbatim in the chapter as the reason `--taxon` is Kraken 2 only. |
| 10 | `lungfish-cli extract reads --by-classifier --tool naomgs --result <bundle> --sample MU-CASPER-2026-03-31-a-IL_CHI_StickneyWS_20260308 --accession KU048583.1 -o extract1.fastq` | 0 | "Wrote 4 reads", 1.2 KB. The chapter's "The command above extracted 4 reads" is this run. |
| 11 | `lungfish-cli extract reads --by-db --database <bundle>/hits.sqlite --db-taxid 28875 -o bydb.fastq` | non-zero | `Error: The extraction produced zero reads`. Quoted verbatim. |
| 12 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <chapter>` | 0 | Final: `no issues found`. |

## Source files consulted for window claims

| Claim in the chapter | Source |
|---|---|
| Import Center card title, NM badge, file hint, Classification Results tab | `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift:413-422` (card), `:178` (tab title "Classification Results") |
| Sheet has only Browse..., a read-only path readout, and Validation | `Sources/LungfishApp/Views/Metagenomics/NaoMgsImportSheet.swift:140-160` (readout and `Browse\u{2026}`), `:161` (the caption "Select a directory containing virus_hits_final.tsv.gz, or the file directly.") |
| Validation states: green tick "Valid NAO-MGS results", source file row, "N per-lane files", warning triangle | Same file, `:168-220` |
| Split layout, summary bar on top, detail left, table right, action bar bottom | `Sources/LungfishNaoMgsUI/NaoMgsResultViewController.swift:25-48` (layout doc comment) |
| Summary bar holds exactly two cards, Samples and Taxa, with "N of M samples" form | Same file, `:3242-3300` (`NaoMgsSummaryBar`, `cards` returns `Samples` and `Taxa`) |
| Sample-filter button titles "All Samples" / "N of M Samples" | Same file, `:669-671`; button construction `:1700-1709` |
| The filter bar holds only that button (no search field) | Same file, `:1692-1717`. This is why the chapter says it is the only control on that row, unlike the EsViritu chapter's Filter viruses field. |
| Five table columns Sample, Taxon, Hits, Unique Reads, Refs | Same file, `:1619`, `:1629`, `:1637`, `:1645`, `:1653` |
| Column-header filter menus (no free-text field) | Same file, `:112` (`columnFilterSet`), `:1725` (column type hints for filter menus) |
| Metadata columns arrive from the Inspector | Same file, `:234-241`; `Sources/LungfishApp/Views/Inspector/InspectorView.swift:1155-1165` (the `Import Metadata…` button, shown when no metadata is loaded) |
| Overview pane: Total Hits, Unique Taxa, Sample/Samples cards, "Top Taxa by Read Count", top 15, bars clickable | `Sources/LungfishNaoMgsUI/NaoMgsChartViews.swift:135-250` (`NaoMgsOverviewView`); hosted at `NaoMgsResultViewController.swift:918-927` |
| Taxon detail line format | `NaoMgsResultViewController.swift:1035` |
| miniBAM heading `All: N of M accessions` / `Top 5: N of M accessions`, limit 5, ordered by unique read count, drag handle note | Same file, `:177` (`miniBAMDisplayLimit = 5`), `:1030-1046` (heading and the note "Top references by unique read count. Drag a panel handle downward to make it taller.") |
| Accession is a GenBank link with a context menu | Same file, `:1112-1142` |
| Action bar buttons BLAST Verify, Export, Extract FASTQ, and the info/provenance button | `Sources/LungfishKit/.../ClassifierActionBar.swift:22-80` |
| Export writes displayed rows to TSV, suggested `<sample>_naomgs_summary.tsv`, records filters and sort in provenance | `NaoMgsResultViewController.swift:2655-2710` |
| Context menu items Copy Taxon ID, Copy Top Accessions, View on NCBI, View Taxonomy on NCBI, Search PubMed, Extract Reads… | Same file, `:2098-2131` |
| Result lands under `Analyses` as `naomgs-<sample>` | `AnalysesFolder.swift:24-32`, confirmed by run 5's on-disk layout |
| `references/` folder is per accession, not per virus | `Sources/LungfishWorkflow/Metagenomics/MetagenomicsImportService.swift:1019-1026` (`allMiniBAMAccessions()` drives the fetch); help text at `Sources/LungfishCLI/Commands/ImportCommand.swift:1745` |
| Upstream repository URL | `Sources/LungfishIO/Formats/NaoMgs/NaoMgsResultParser.swift:319` |
| `virus_hits` rows are dropped on merge by design | `Sources/LungfishIO/Formats/NaoMgs/NaoMgsDatabase+Merge.swift:15` comment, "`virus_hits` rows are intentionally not copied" |

## DRIFT items applied

- Row 7 (false): "Choose" corrected to **Browse...**.
- Row 9 (changed): the result now lands "under the project's `Analyses` folder, named `naomgs-<sample>`", confirmed on disk by run 5.
- Row 10 (changed): the CLI example no longer writes into `Imports/`. It points `--output-dir` at the project folder and says to let the importer place the bundle.
- Row 16 (changed): the blanket "no charts" negative is gone. The chapter now describes the real overview bar chart (`NaoMgsOverviewView`) and makes only the narrow, provable statement that one import is one run and the chart is not a time series.
- Missing, sample-filter button: covered in its own subsection under Reading the results.
- Missing, Export and Extract FASTQ: covered in the action bar subsection.
- Missing, View on NCBI: covered with the rest of the context menu.
- Missing, metadata columns via the Inspector: covered in the taxon table subsection.
- Missing, `extract reads --by-db`: covered in On the command line, together with the finding that it does not work on an imported bundle.
- Missing, SQLite-backed storage: covered in Procedure step 3, with the reason it matters (sorting and random access without re-reading the table).

## Screenshots

Four `<!-- SHOT: ... -->` markers with matching `shots` front matter. Two are
new relative to the old `planned_shots` list.

- `nao-mgs-import-card` (kept, step 1). Caption now names the NM badge and the
  file hint, both verified in `ImportCenterViewModel.swift`.
- `nao-mgs-import-sheet` (new, step 2). The sheet is the whole Settings surface
  of this operation, so it needs its own shot.
- `nao-mgs-result-viewport` (kept, recaptioned per DRIFT). Caption now names the
  sample-filter button, the two summary cards, the five columns, and the
  overview chart.
- `nao-mgs-taxon-detail` (new). The miniBAM evidence is the chapter's main
  interpretive claim and the old shot list had nothing showing it.

## Retitle sites touched

- Front matter `title` was already "Importing NAO-MGS Results". Left as is.
- `docs/user-manual/build/mkdocs.yml:110`, nav label "Running NAO-MGS" changed
  to "Importing NAO-MGS Results".
- `docs/user-manual/help-ids.yaml:361-365`, `viewport.NAOMGSResultViewer`. The
  `anchor` was `interpretation`, a heading this rewrite removes, so it was
  repointed to `reading-the-results`. The `description` said "longitudinal
  abundance charts", which no surface produces, and now names the per-taxon
  table, the sample filter, and the miniBAM evidence.
- `help-ids.yaml:207` mentions NAO-MGS in a classifier-run description but
  belongs to another operation's entry and was left alone.

## Glossary

Two terms added to `docs/user-manual/GLOSSARY.md`, both listed in
`glossary_refs`.

- **miniBAM** `{#minibam}`, placed before `minimap2` in the M section.
- **Taxonomy identifier** `{#taxonomy-id}`, placed after `Taxonomic rank` and
  before `TaxTriage`.

Every other term in `glossary_refs` already existed and was linked at first
use: accession, bam, bit-score, blast, coverage, depth, fastq, mapping,
metagenomics, nao-mgs, operations-panel, paired-end, pcr-duplicate,
percent-identity, provenance, read, read-classification, reference-genome,
taxon.

## App defects found

1. **`nao-mgs summary` reports only the first sample of a multi-sample table.**
   On the five-site fixture it printed one sample name, "Total virus hits: 34",
   and an empty Organism column, while `import nao-mgs` on the same file found
   five samples, 35 hits, and resolved every organism name. The 34 against 35
   suggests the summary path also drops a row. Recorded in the chapter's
   On the command line section as a defect, with the advice to quote counts
   from the project import instead.

2. **`extract reads --by-db` cannot work against any imported NAO-MGS bundle.**
   The merge step at `NaoMgsDatabase+Merge.swift:15` intentionally does not copy
   `virus_hits` rows into the merged database, so the bundle's `hits.sqlite` has
   zero rows in the only table that carries read sequences. The command exits
   with `The extraction produced zero reads` for any filter. The CLI help
   advertises the mode with no such caveat. Recorded in the chapter, which
   directs readers to `--by-classifier`.

3. **Cosmetic, `nao-mgs summary` prints an empty Organism column.** Taxon-name
   resolution happens during the project import, not in the standalone summary,
   so the summary shows bare taxonomy identifiers. Not called out separately in
   the chapter beyond defect 1, since the column list is quoted and the reader
   will see it.

## Not verified

- **The running app was never opened.** Every window claim above is read from
  Swift source, not from a live window. The screenshot pass should confirm in
  particular the two summary-bar card labels, the sample-filter button title,
  and the miniBAM heading string, since those are the strings the chapter
  quotes most closely.
- **The sample picker popover's own contents.** The chapter says the button
  "opens the sample picker" without describing its controls. The picker is
  `ClassifierSamplePickerView` in the kernel and is shared with other
  classifiers, so its description belongs wherever that shared surface is
  documented rather than being re-derived here.
- **Reference fetching.** Every import in this log used
  `--no-fetch-references`, so the `references/` folder was never populated and
  "References fetched: 0" is the only figure quoted for it. The behaviour is
  read from `MetagenomicsImportService.swift:1019-1026`. A network run would
  confirm the folder contents and the per-accession naming.
- **The per-lane validation message.** `Files found` with a per-lane count needs
  a results directory holding several `_virus_hits.tsv.gz` files. The fixture is
  a single combined table, so that branch of the Validation section was read
  from source only.
- **BLAST Verify on an NAO-MGS taxon.** Not exercised. It sends reads to NCBI,
  and the chapter defers the detail to the BLAST Verification chapter.
- **The `Cressdnaviricota sp.` gloss.** The chapter calls it an unclassified
  member of a large viral phylum, which is general taxonomy rather than
  something the app asserts. Worth a domain reviewer's eye.

## Phase 5 note

A public NAO-MGS sample output is still needed, and the open item on the roster
should stay open even though this chapter ran against real data.

The run used here is `Tests/Fixtures/naomgs/virus_hits_final.tsv.gz`, a test
fixture rather than a manual fixture. It is not published under
`docs/user-manual/fixtures/`, has no fixture README or citation block, and the
chapter's Before you start section therefore cannot give a reader a download
link the way every other chapter in this part does. It currently tells the
reader to produce their own output from the upstream pipeline.

Two things follow. First, the screenshots need a project holding an imported
NAO-MGS result, and the demo project has none, so either this fixture is
promoted to a manual fixture with provenance and licence notes or a
publishable sample is obtained. Second, the sample identifiers in this run are
long instrument-style strings such as
`MU-CASPER-2026-03-31-a-IL_CHI_StickneyWS_20260308`, which appear in the
chapter's extract command and would appear in the screenshots. If a cleaner
sample set is available, prefer it, and the chapter's worked figures (35 hits,
4 taxa, 12/8 and 28/26 hit-versus-unique pairs, 4 extracted reads) would then
need re-running and re-quoting.
