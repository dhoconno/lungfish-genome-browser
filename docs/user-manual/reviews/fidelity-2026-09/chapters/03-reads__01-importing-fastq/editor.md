# Editor pass: 03-reads/01-importing-fastq.md

Date: 2026-09-06
Role: brand-copy-editor

Order of work was fidelity corrections, then the reader report, then the
style pass. Every change is listed once, under the source that caused it.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Front matter `glossary_refs` | Changed `FASTQ` to `fastq` and added `phred-score`. Also added `bam` and `n50`, whose body links this pass introduced. | Row 109. The glossary anchor is lowercase and the body already linked `#fastq`. `phred-score` was linked but undeclared, and the two new links needed declaring on the same rule. | fidelity |
| Reading the results, card table | Mean Length row now reads 249 bp, 250 bp, and 250 bp. Mean Q now reads 24.9. The measured 248.6 moved into the prose beneath, which names it as the underlying measurement. | Rows 64 and 65. The table is introduced as what the cards read, and both cards round. | fidelity |
| Reading the results, closing paragraph | Replaced "The quality charts stay empty until a report runs" with a statement that all three sparkline charts are drawn from statistics the import already measured and are populated as soon as the import finishes. Kept the separate-quality-report distinction and the Quality Control link. | Row 79. The import writes per-position quality, the quality histogram, and the read-length histogram, so the old sentence sent readers after a step they do not need. | fidelity |
| Procedure step 4 | The unpaired summary now reads "its filename on one line with `Size:` beneath it, and no `R1:` or `R2:` labels at all". Also corrected the paired case to quote `Total size:`. | Row 28. The single-unpaired branch prints the bare filename and `Size:`, with no `R1:` prefix. | fidelity |
| What good looks like, fourth check | Split the duplicate behaviour by surface. The window raises a Replace / Keep Both / Skip dialog and Keep Both appends a number. Only the command line skips silently, and `--force` replaces. | Row 86. `showDuplicateFileDialog` is on both GUI import paths. The old text described CLI behaviour in a section framed around the app. | fidelity |
| Editing sample metadata | Replaced the named fields (collection date, host organism) with a description of what the Inspector's Sample Metadata section actually shows, which is one row per sample and one column per metadata field, editable by clicking a cell, with "No metadata imported" when there is none. | Row 81, unverifiable. Read `SampleMetadataSection.swift` to describe the pane generically rather than name fields the source does not fix. | fidelity |
| Reading the results, Q30 threshold | Dropped the numeric 70 percent gate. Now a rule of thumb, "expect Q30 to sit well above two thirds of bases", explicitly scoped to Illumina, with nanopore sent to the per-platform expectations in Sequencing Reads. | Row 71, unverifiable. No source in `Sources/` encodes a Q30 gate, so the manual has no arbiter for a numeric threshold. | fidelity |
| Before you start, third paragraph | Replaced "Nothing here needs a plugin pack or Docker Desktop" with a statement that the import uses tools from the Required Setup pack, that the reordering step calls `clumpify.sh` from that pack's `bbtools` entry, and that no optional pack and no Docker Desktop is needed. Links to Plugin Packs. | Row 112, unverifiable, plus reader row 11. The fixture import does invoke a managed tool, and Plugin Packs names Required Setup as the pack LGE installs by itself. | fidelity |
| What it is, bundle paragraph | Split into two paragraphs. Said where the bundle lives on disk, that the Finder shows it as an ordinary folder, and not to rename or move its contents outside LGE. Glossed metadata at first use and put the sentence in subject-first order. | Readers rows 29 and 30, three readers each. | readers |
| What it is, checksum sentence | Said who recomputes the fingerprint and when, and why it matters. Named Optimize storage as the setting behind the rewriting, replacing "usually". | Readers rows 7 and 8, four readers each. | readers |
| What it is, BAM sentence | Glossed BAM at first use with a link, kept the gloss of unmapped, and said nanopore basecalling software writes unmapped BAM by default, which is why reads arrive that way. | Readers row 9, four readers. | readers |
| Why you would do this, fixture paragraph | Split in two. Added the scale comparison, that a whole human run delivers hundreds of millions of pairs, that these cover their own 500 kb window about 45 times over, and that this is the depth a real project aims for. Explained the `10.0-10.5Mb` in the filenames against the 500 kb in the prose. | Readers rows 10 and 32, four and three readers. Depth figure is the fixture README's 44.7x, which CONSISTENCY.md rounds to 45. | readers |
| Why you would do this, first paragraph | Added that mapping, quality control, trimming, classification, assembly, and variant calling each have their own later chapter. | Readers row 31, three readers. | readers |
| Before you start, download paragraph | Put the fixtures URL on its own line and said to use the Download raw file button. | Readers row 32, three readers. | readers |
| Pairing table, third column | Replaced product and archive names with "Illumina's own conversion software", "Most sequencing providers", and "Public sequence archives". | Readers row 46, one reader, one-line fix. | readers |
| Pairing section, case-sensitivity paragraph | Said plainly that the Finder treats the two names as the same and LGE does not, then gave the negative examples in one sentence rather than piled up. | Readers row 12, four readers. | readers |
| Pairing section, missing-mate paragraph | Pointed directly at the configuration sheet's two counts as the way to catch a bad pairing before anything is written, and said to click Cancel. | Readers row 13, four readers. | readers |
| Procedure step 1 | Said cards are clickable tiles and that files can be dragged onto one. | Readers row 41, two readers. Drop targets confirmed in `ImportCenterView.swift:252`. | readers |
| Procedure step 3 | Said to hold Command to select the second file, and that selecting a folder reads its top level only unless `--recursive` is used. | Readers row 42, two readers. | readers |
| Procedure step 5 | Defined stem as the part of the filename left once the mate suffix and the `.fastq.gz` ending are stripped, and said how to get a different bundle name. | Readers row 40, two readers. | readers |
| Procedure, after step 5 | Said the import runs the same way whether the Operations Panel is showing or not, and that opening it is optional. Kept it out of the numbered list. | Readers row 23, three readers. Kept unnumbered to stay inside the five-item bullet cap. | readers |
| Importing many samples at once | Added that a mixed-instrument folder gets one Platform setting for all of it, so each instrument should be a separate batch. | Readers row 48, one reader, one-sentence fix. | readers |
| Settings, opening | Added a paragraph saying the defaults are right for a standard Illumina run and which control is worth a glance. | Readers row 44, one reader, but the fix is one paragraph and answers a question the section otherwise leaves open. | readers |
| Settings, Platform | Said to leave `--platform` off for Element Biosciences, MGI / DNBSEQ, and Unknown / Other, because any other value is rejected. | Readers row 33, three readers. Confirmed at `ImportFastqCommand.swift:242-244`. | readers |
| Settings, Quality Binning | Glossed base quality score and Phred score at this first use. Replaced the variant-caller example with a plainer statement that the decision belongs to the tool you plan to run. | Readers rows 24 and 25, three readers each. | readers |
| Settings, Optimize storage | Said to leave it on, that LGE sizes the work to reported memory and picks a gentler tool for large files, and that a 16 GB laptop needs no adjustment. | Readers row 26, three readers. Confirmed in `ClumpingTool.resolve`. | readers |
| Settings, Compression Tool | Said LGE picks the tool by weighing input size against memory, flagged Trim Galore as a caution that alters the reads themselves, and said the popup labels are labels rather than text to type. | Readers rows 14 and 50, four and one reader. | readers |
| Settings, recipe picker | Kept the registry label `(recipe picker)` in bold, and said in the body that the control carries no label on the sheet and is the popup under the checkbox. | Readers row 15, four readers. The registry spells the label this way, so the label stays and the body explains it. | readers |
| Settings, bundled recipes | Gave one clause per recipe from the recipe JSON descriptions, and said none applies to the HG002 fixture. Split the nanopore recipes into their own paragraph. | Readers row 15, four readers. | readers |
| Reading the results, first paragraph | Glossed viewport at first use. | Readers row 45, one reader, one-clause fix. | readers |
| Reading the results, nine cards | Glossed N50 at first use with a link. | Readers row 16, four readers. | readers |
| Reading the results, numbers paragraph | Said the 35-base minimum is not on the cards and appears as Min Length in the Inspector's Dataset Statistics section. | Readers row 17, four readers. Confirmed at `DocumentSection.swift:1005`. | readers |
| Reading the results, quality paragraph | Added what a good Mean Q looks like for Illumina, and gave GC an expected range for a human sample. | Readers rows 49 and 43, one and two readers. GC phrasing matches Sequencing Reads. | readers |
| Reading the results, sparkline paragraph | Moved the sparkline gloss to first use, and said the 1,000-record limit is fixed. | Readers rows 34 and 35, three and two readers. Confirmed hard-coded in `FASTQDatasetViewController.swift`. | readers |
| Editing sample metadata | Said there is no batch edit in the window and that editing many at once means the command line, and gave a reason to want the per-bundle copy. | Readers rows 19 and 51, four and one reader. | readers |
| What good looks like, first check | Added the reason a doubled count happens, that each file becomes its own single-end bundle. | Readers row 27, three readers. | readers |
| On the command line, opening | Said the section is optional, that nothing later requires a command, and where `lungfish-cli` comes from. Added the backslash and quoted-path explanation. | Readers rows 20 and 39, four and two readers. | readers |
| On the command line, sample sheet paragraph | Replaced "relative paths resolve next to the CSV file" with plainer wording about a bare filename being looked for in the CSV's own folder. | Readers row 52, one reader, one-sentence fix. | readers |
| What a bundle holds afterwards, first paragraph | Added that interleaved storage is how every paired sample is stored whatever the Pairing setting said, and that the two are separate things. | Readers row 37, two readers. | readers |
| What a bundle holds afterwards, metadata paragraph | Added MB alongside the raw byte counts. | Readers row 38, two readers. | readers |
| What a bundle holds afterwards, virtual bundle | Grounded the gloss in the concrete cases, said why later chapters produce them, and said a plain FASTQ import never produces one. | Readers row 21, four readers. | readers |
| What a bundle holds afterwards, materialize | Glossed materialize as a verb, said LGE does it on its own when an operation needs the full reads, and said the deliberate form has no button in the window. | Readers row 22, four readers. | readers |
| Before you start | Left the two fixed opening sentences and the hg002-chr20 link untouched. | The Before you start block already matched CONSISTENCY.md verbatim. | consistency |
| Settings, all eight entries | Kept every bold label exactly as `parameters.yaml` spells it, including `(recipe picker)`, and kept the three-sentence shape with the flag sentence last. | The registry is the source for labels, and the template fixes the shape. | template |
| Whole chapter | Changed "characterised" and "recognised" to the American forms, matching the manual's dominant `-ize` usage. Left "labelled", which is the manual's dominant form. | Readers row 47, one reader, on mixed conventions inside one chapter. | style |
| What it is, checksum sentence | Rewrote "Nothing checks it for you on a schedule" as "LGE does not re-check it on a schedule". | Calmer, and names the actor. | style |
| Pairing section | Rewrote "the rule that catches people out" as "the rule most people meet the hard way". | The original read as colloquial rather than precise. | style |
| Reading the results | Rewrote "Quality reads from three of the nine cards" as "Three of the nine cards report quality". | Subject-first, plainer. | style |
| Settings, opening | Rewrote "the setting a wrongly named file gets wrong" as "a misnamed file shows up there as a wrong value". | The original was ambiguous about what does the getting-wrong. | style |
| What good looks like, fourth check | Wrote LGE rather than "the window" as the actor showing the dialog, and used `SampleA` rather than a shortened fixture name for the Keep Both example. | CONSISTENCY.md names the app as the actor, and the fixture's real bundle name is the long stem. | style |

## Deliberately unchanged

The Q30 rule of thumb is hedged rather than expanded to Mean Q, GC, and
Q20 in one place. Readers row 18 asked for thresholds on all four. Mean Q
and GC now carry their own guidance in the quality paragraph, and the
per-platform question goes to Sequencing Reads, which already holds the
four-number judgement the reader was reaching for. Duplicating it here
would put two authorities in the manual for the same numbers.

The 103 claims the fidelity review verdicted true are untouched, including
the pairing table's three suffix rows, every default and flag in Settings,
the byte counts, and the CLI blocks.

## Status

brand_reviewed: false
lead_approved: false
