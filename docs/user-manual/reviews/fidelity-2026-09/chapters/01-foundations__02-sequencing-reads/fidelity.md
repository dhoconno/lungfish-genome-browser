# Fidelity review: 01-foundations/02-sequencing-reads.md

Reviewed 2026-09-06 against the Swift source under `Sources/`, the CLI help
dumps under `reviews/fidelity-2026-09/cli-help/`, the committed fixtures under
`docs/user-manual/fixtures/`, `GLOSSARY.md`, and `CONSISTENCY.md`.

The chapter is the post-rewrite version. The DRIFT.md Part A entry for this
chapter describes the *pre-rewrite* SARS-CoV-2 text, and every correction it
called for has been applied. Rows 1 to 9 below re-verify those corrections
against source rather than trusting the drift report.

## The 45,574 / 45,614 discrepancy, settled

The chapter says 45,574 records per file. The fixture README says 45,614 pairs.
Measured directly:

```
$ gzip -dc HG002.chr20.10.0-10.5Mb.R1.fastq.gz | wc -l
182296
$ gzip -dc HG002.chr20.10.0-10.5Mb.R2.fastq.gz | wc -l
182296
```

182,296 / 4 = 45,574 records in each file. **The chapter is right and the
fixture README is wrong.** `docs/user-manual/fixtures/hg002-chr20/README.md:78`
("91,203 total reads (45,614 read pairs)") is stale and needs correcting by the
fixture owner. The 91,203 figure also survives in the committed mapping result
(`expected/mapping/mapping-result.json` `"totalReads": 91203`), while the two
committed FASTQ files hold 91,148 reads between them, so the mapping run in
`expected/` predates the committed read files by 55 reads. That does not touch
any number the chapter quotes, but the mapping figures the chapter cites come
from that same file, so it is recorded here.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "FASTQ spends exactly four lines on each read. Line one names the read, line two spells its bases, line three is a separator, and line four gives one quality character for each base" | true | `GLOSSARY.md:103`; the verbatim fixture record below matches this shape | no change |
| 2 | The printed record `@D00360:94:H2YT5BCXX:1:1101:1582:14700` with its 250-character sequence and quality lines | true | `gzip -dc HG002.chr20.10.0-10.5Mb.R1.fastq.gz \| sed -n '5,8p'` returns all four lines character for character, sequence length 250, quality length 250 | no change |
| 3 | "Its sequence and quality lines are 250 characters long" | true | Measured on the record above, both lines 250 | no change |
| 4 | "The number of characters on this line is the read length, 250 here." | true | Same measurement | no change |
| 5 | "Each of the two files in this fixture holds 45,574 reads and so runs to 182,296 lines, because 4 times 45,574 is 182,296." | true | `wc -l` on both decompressed files returns 182,296; 4 x 45,574 = 182,296. Supersedes the fixture README's 45,614 | no change |
| 6 | "The two read files of this fixture take 8.3 MB and 8.9 MB on disk compressed" | true | `ls -l` gives 8,690,798 and 9,277,239 bytes, which is 8.29 MiB and 8.85 MiB. Matches the README's committed-file table | no change |
| 7 | "hold 22,662,846 bases between them" | true | `awk 'NR%4==2 {tot+=length($0)}'` across both files returns 22,662,846 | no change |
| 8 | "LGE handles `.fastq` and `.fastq.gz` alike, so you never unzip a file before importing it." | true | `cli-help/import-fastq.txt` accepts either extension; `Sources/LungfishIO/Formats/FASTQ/FASTQReader.swift` reads both | no change |
| 9 | "LGE keeps compressed reads compressed, and its FASTQ operations offer a compress option for their own outputs" | true | `cli-help/fastq.txt:108,126,152,174,191,209,230,260,289,307,328,344,371` each list `--compress  Compress output with gzip` as an opt-in flag. Compression is opt-in on operation outputs, exactly as written. This is the corrected wording DRIFT.md row 5 asked for | no change |
| 10 | "This fixture writes `R1` and `R2`." with the two filenames | true | Both files are committed under those exact names in `docs/user-manual/fixtures/hg002-chr20/` | no change |
| 11 | "The SRA convention writes the suffix as `_1` and `_2` instead, and Illumina's own instrument output often writes `_R1_001` and `_R2_001`. All three mean the same thing, and LGE recognises each of them when it pairs files during import." | true | `Sources/LungfishApp/Views/FASTQ/FASTQImportConfiguration.swift:181-185` sets `suffixPairs` to exactly `("_R1_001","_R2_001")`, `("_R1","_R2")`, `("_1","_2")` | no change |
| 12 | "Both files hold the same number of records in the same order." | true | Both files are 182,296 lines; the second record in each carries the identical header `@D00360:94:H2YT5BCXX:1:1101:1582:14700` | no change |
| 13 | The paired-header block giving the R1 record 250 bases and the R2 record 249 bases | true | R1 record 2 sequence is 250 characters, R2 record 2 sequence is 249 characters, both under the quoted header | no change |
| 14 | "LGE's Merge Overlapping Pairs operation uses `bbmerge` for it." | true | `FASTQOperationDialogState.swift:1969` `case .mergeOverlappingPairs: return "Merge Overlapping Pairs"`; `cli-help/fastq.txt:312-313` `==== fastq merge ====` / "Merge overlapping paired-end reads using bbmerge" | no change |
| 15 | "LGE keeps the mates as separate records by default and leaves the overlap to the downstream aligner." | true | Merging is an explicit operation with its own settings, `FASTQOperationDialogState.swift:97-98` and defaults at `254-255` (`mergeOverlappingPairsMinOverlap = 12`). Nothing merges at import | no change |
| 16 | "LGE bundles keep paired-end reads as two files, R1 and R2. Interleaving into a single alternating file is a separate operation you run when a downstream tool wants that shape, and Deinterleave reverses it." | true | `cli-help/fastq.txt:364-367` `==== fastq interleave ====` takes `--in1`/`--in2` and writes one output; `cli-help/fastq.txt:349-352` `==== fastq deinterleave ====` takes one input and writes `--out1`/`--out2`. Both are user-run subcommands. `GLOSSARY.md:145` states the same. This is the corrected wording DRIFT.md's one false row asked for, and it now reads true | no change |
| 17 | "`!` is ASCII 33 and decodes to Q0. `5` is ASCII 53 and decodes to Q20. `?` is ASCII 63 and decodes to Q30. `I` is ASCII 73 and decodes to Q40." | true | Phred+33 arithmetic, and consistent with `GLOSSARY.md:211` | no change |
| 18 | "The quality line opens `DDDDD`, and `D` is ASCII 68, so those five bases are Q35" and the `.` (Q13), `6` (Q21) decodes | true | The quality line of the printed record begins `DDDDD`; 68-33=35, 46-33=13, 54-33=21. All three characters appear in the quoted line | no change |
| 19 | "LGE and the tools underneath it, `fastp`, BWA-MEM2, and `minimap2`, do the decoding and report the aggregate statistics." | true | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:11,18` defines `bwaMem2 = "bwa-mem2"` with display name "BWA-MEM2"; fastp ships in Required Setup per the tool lock; minimap2 is the short-read and long-read default mapper. FastQC and plain BWA are correctly absent | no change |
| 20 | "The HG002 long reads hold 950 Oxford Nanopore reads." | true | `gzip -dc HG002.chrM.ont.fastq.gz \| awk 'NR%4==2{n++}'` returns 950 | no change |
| 21 | The printed nanopore record `@0b3c8fbc-4b82-45d9-9805-ac77b873001a` with 60 characters of sequence and quality | true | Records 9 to 12 of the decompressed ONT file match the header, the first 60 sequence characters, and the first 60 quality characters exactly | no change |
| 22 | "The `(` in the first position is ASCII 40, which decodes to Q7" | true | The quality line begins `('5;AO...`; 40-33=7 | no change |
| 23 | "This read is 16,303 bases long, which is 98% of the mitochondrial genome" | true | That record's sequence line is 16,303 characters; 16,303 / 16,569 = 98.4% | no change |
| 24 | "the nanopore reads average Q7.9, span 263 to 39,647 bases, and reach an N50 of 10,615 bases" | true | Min 263, max 39,647 and N50 10,615 all recomputed from the committed file. Mean quality 7.9 is the fixture README's `seqkit stats -a` figure at `hg002-long-reads/README.md:118` | no change |
| 25 | "The same fixture holds 363 PacBio HiFi reads." | true | `awk 'NR%4==2{n++}'` on `HG002.chrM.hifi.fastq.gz` returns 363 | no change |
| 26 | The printed HiFi record `@m64011_190830_220126/18416252/ccs` with 60 characters of sequence and quality | true | Records 9 to 12 of the decompressed HiFi file match exactly | no change |
| 27 | "`~`, ASCII 126, which decodes to Q93" | true | 126-33=93 | no change |
| 28 | "This read is 16,565 bases long" | true | That record's sequence line is 16,565 characters | no change |
| 29 | "the HiFi reads average Q29, with 97.6% of bases at Q30 or better and an N50 of 13,663 bases" | true | N50 13,663 recomputed from the committed file. Q29 and 97.6% Q30+ are the README's `seqkit stats -a` figures at `hg002-long-reads/README.md:120-122` | no change |
| 30 | "Click a FASTQ bundle in the sidebar and the main viewport switches to the FASTQ viewport." | true | `Sources/LungfishApp/Views/Viewer/FASTQDatasetViewController.swift` is the FASTQ dataset viewport, driven by bundle selection. Matches ground-truth 03-reads row 40 | no change |
| 31 | "Its top pane holds one summary bar and one sparkline strip computed over the whole bundle, not a row per file." | true | `FASTQDatasetViewController.swift:252-259` declares `topPane` holding `summaryBar` and `sparklineStrip`; `configureTopPane` at 458-490 pins the sparkline strip below the summary bar with no per-file branch. Matches ground-truth 03-reads rows 41 and 43 | no change |
| 32 | "The summary bar carries nine cards" and the names Reads, Bases, Mean Length, Median Length, N50, Mean Q, Q20, Q30, GC | true | `Sources/LungfishApp/Views/Viewer/FASTQChartViews.swift:30-41` returns exactly those nine `Card` labels in that order | no change |
| 33 | "Q20 and Q30 are the percentage of bases at or above those scores" and "GC is the percentage of bases that are G or C" | true | `FASTQChartViews.swift:37-40` formats `q20Percentage`, `q30Percentage`, and `gcContent * 100` all as `%.1f%%` | no change |
| 34 | "These are measured from the file and are not editable." | true | The cards are computed from `FASTQDatasetStatistics` in the `cards` override with no editing affordance | no change |
| 35 | "Below the cards sit three sparkline charts, labelled Length Dist., Q / Position, and Q Score Dist." | true | `Sources/LungfishApp/Views/Viewer/FASTQSparklineStrip.swift:24-31` gives exactly those three titles; the summary bar is constrained above the strip in `configureTopPane` | no change |
| 36 | "The first is the read-length distribution, the second is mean quality plotted against position along the read, and the third is how many bases fall at each quality score." | true | `FASTQSparklineStrip.swift:20-23` names the cases `length`, `qualityPerPosition`, `qualityScore`, backed by `FASTQHistogramChartView`, `FASTQQualityBoxplotView`, `FASTQHistogramChartView` (lines 48-50) | no change |
| 37 | "Click any of the three to open it full size in a popover." | false | `FASTQSparklineStrip.swift:103-115`: `mouseDown` opens a popover only when `kind == .length \|\| hasQualityData`. Before a quality report has run, the two quality sparklines draw "Click to Compute" (line 332) and clicking either fires `onComputeQualityReport` instead of a popover. So the unconditional "any of the three" is wrong on a freshly imported bundle | "Click the length chart to open it full size in a popover. The two quality charts read Click to Compute until a quality report has run, and clicking one then starts that report rather than opening a popover." |
| 38 | "Two tabs sit under the charts, Operations and Reads." | true | `FASTQDatasetViewController.swift:494-496` sets `middleTabControl.segmentCount = 2` with labels "Operations" and "Reads" | no change |
| 39 | "The Reads tab is a table of individual records, one row each, with columns for the row number, the read identifier, the length, the mean quality, and the sequence." | true | `FASTQDatasetViewController.swift:1437-1466` builds five columns titled `#`, `Read ID`, `Length`, `Mean Q`, `Sequence` in that order | no change |
| 40 | "It loads the first 1,000 records of the bundle, so it is a window onto the file rather than the whole of it." | true | `FASTQDatasetViewController.swift:290` sets the placeholder "Select the Reads tab to preview the first 1,000 records." Matches ground-truth 03-reads Missing row "The read preview loads the first 1,000 records" | no change |
| 41 | "Importing reads does not compute a quality report on its own." | true | No QC or statistics call exists on the import path (`grep` for `refreshQCSummary`, `qualityReport`, `computeStatistics` in `Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift` returns nothing), and the quality sparklines render their "Click to Compute" empty state until a report runs. Matches ground-truth 03-reads row 39 | no change |
| 42 | "The Operations tab offers Compute Quality Report when you want one" | false | No control anywhere is labelled "Compute Quality Report". The string appears only in a code comment at `FASTQSparklineStrip.swift:52`. The Operations tab's sidebar lists the twelve *category* names from `FASTQOperationCategoryID.title` (`FASTQOperationsCatalog.swift:18-32`), selecting one launches the FASTQ/FASTA Operations dialog (`FASTQDatasetViewController.swift:2795-2796`), and the QC category holds one operation whose label is "Refresh QC Summary" (`FASTQOperationDialogState.swift:1264-1265, 1955`) | "The Operations tab lists the operation categories. Choose QC & Reporting and then Refresh QC Summary when you want a quality report, or click one of the two quality charts, which starts the same computation." |
| 43 | "the same statistics are available from the command line" | unverifiable | The viewport computes its report by shelling out to `seqkit stats -a -T` plus a sampled quality pass (`FASTQDatasetViewController.swift:1633`), but `cli-help/fastq.txt` exposes no `stats` or `qc` subcommand in its 25-subcommand list, and no other dump was checked for one | Settle it by dumping the full `lungfish-cli --help` tree and naming the subcommand that prints these statistics, or drop the sentence if none does. |
| 44 | "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder" | true | This is the fixed sentence `CONSISTENCY.md` mandates verbatim for every procedure chapter's Before you start section | no change |
| 45 | "Download the files ... from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hg002-chr20" | true | Both named files are committed at that repository path, and the sentence follows the `CONSISTENCY.md` fixture-download template | no change |
| 46 | "The long-read examples come from the HG002 long reads, in the neighbouring `hg002-long-reads` folder" | true | `docs/user-manual/fixtures/hg002-long-reads/` exists with both committed read files. "the HG002 long reads" is the name `CONSISTENCY.md` mandates | no change |
| 47 | "Nothing here needs a plugin pack, and nothing here needs Docker Desktop." | true | The chapter runs no operation. The QC category requires no pack (`FASTQOperationsCatalog.swift:37-38` returns `[]` for `.qcReporting`), so even the one viewport action it names is pack-free | no change |
| 48 | "Mapping this fixture's reads back to its own 500,001 bp reference gives a mean depth of 44.7x with 99.77% of reads mapped" | true | `expected/mapping/mapping-result.json` gives `"meanDepth": 44.7234` and `"mappedReadPercent": 99.7664550508207` against `"contigLength": 500001`, which matches `GRCh38.chr20.10.0-10.5Mb.fasta.fai` | no change |
| 49 | "this fixture's read 1 file averages 248.6 bases with 90.8% of its reads at 249 or 250 and a minimum of 50" | true | Recomputed over R1: mean 248.64, 90.77% of reads at 249 or 250, min 50, max 250 | no change |
| 50 | "This fixture holds 45,574 pairs" | true | Both files hold 45,574 records each and pair record for record, so 45,574 pairs. Consistent with claim 5 | no change |
| 51 | "This fixture's nanopore reads average Q7.9, below that range, so treat it as an example of the format rather than a target to match." | true | Q7.9 is the README figure, and the chapter correctly flags it as below the Q12 to Q20 range it just quoted for current basecallers | no change |
| 52 | "A 250-base Illumina read spans about 1.5% of the 16,569 bp human mitochondrial genome. A 10,000-base nanopore read spans about 60% of it" | true | 250 / 16,569 = 1.51%; 10,000 / 16,569 = 60.4%. Genome length matches `hg002-long-reads/README.md:22` | no change |
| 53 | Platform table rows for Illumina, Oxford Nanopore, PacBio HiFi, and Ion Torrent | true | Domain facts about sequencing platforms, not app claims. The Illumina and nanopore rows agree with `GLOSSARY.md:241` | no change |
| 54 | Phred table rows Q10 through Q40 with their error probabilities | true | Phred arithmetic, and Q20/Q30/Q40 agree with `GLOSSARY.md:211` | no change |
| 55 | "Continue to [Amplicons and Shotgun Sequencing](03-amplicon-vs-shotgun.md)" | true | `docs/user-manual/chapters/01-foundations/03-amplicon-vs-shotgun.md` exists | no change |

## Front matter

| Field | Verdict | Evidence |
|---|---|---|
| `parameters_refs: []` | true | The chapter documents no operation. It names Merge Overlapping Pairs, Interleave, Deinterleave, and the QC report only to say what they are, and gives no Settings section, so an empty list is correct |
| `shots` lists two ids | true | The body carries exactly two markers, `<!-- SHOT: fastq-viewport-summary-cards -->` at line 198 and `<!-- SHOT: fastq-viewport-reads-tab -->` at line 204, and both ids appear in `shots` with captions. No marker is unlisted and no listed shot is missing a marker |
| `shots` caption "showing the nine summary cards above the three sparkline charts" | true | Nine cards and three charts, cards above charts, all confirmed at claims 32 and 35 |
| `shots` caption "listing the first records with their read identifier, length, mean quality, and sequence" | true | Matches the five real column titles at claim 39 |
| `glossary_refs` anchors | true | All eleven resolve in `GLOSSARY.md`: `#fastq` (line 103, reached from the front-matter token `FASTQ` case-insensitively and from the body link `#fastq` exactly), `#read` 239, `#paired-end` 203, `#single-end` 271, `#interleaved-fastq` 145, `#phred-score` 211, `#read-length` 241, `#insert-size` 141, `#circular-consensus-sequencing` 55, `#coverage` 77, `#n50` 183. Every body link matches its anchor's case |
| `fixtures_refs: [hg002-chr20, hg002-long-reads]` | true | Both fixture directories exist and both are quoted in the body |
| `illustrations` lists four ids | true | All four PNGs exist under `docs/user-manual/assets/illustrations-imagegen/01-foundations/02-sequencing-reads/` and all four are referenced in the body |
| `tools: []`, `entry_points: []`, `features_refs: []` | true | The chapter runs no tool and opens no dialog |

## Notes for the rewrite owner

The two false rows are both in the "How LGE shows a read set" section, and both
are the same kind of error: an affordance described as simpler than it is
because the reviewer wrote it from a bundle that already had quality data. A
freshly imported bundle shows "Click to Compute" on two of the three
sparklines, which is worth saying plainly since claim 41 already tells the
reader import runs no QC.

Claim 43 is the only unverifiable row. It needs a full `lungfish-cli --help`
tree dump to settle, which is outside the read-only CLI inspection done here.

The fixture README correction (45,614 to 45,574) belongs to the fixture owner,
not to this chapter. The chapter should not be changed to match the README.

## Counts

15 true, 0 false, 0 unverifiable in the front matter. 53 true, 2 false, 1
unverifiable in the body.

**Totals: 68 true, 2 false, 1 unverifiable.**
