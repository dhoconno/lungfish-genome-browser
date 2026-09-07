---
title: Exporting Genotypes
chapter_id: 09-genotyping/04-haplotype-definitions-and-export
audience: analyst
prereqs: [09-genotyping/03-reading-the-genotype-comparison]
estimated_reading_min: 26
task: Send a reviewed genotype result out of LGE as an Excel workbook, a filtered samples-across pivot, a CSV or TSV table, or a set of LabKey-ready CSV files.
tags: [genotyping, mhc, export, xlsx, pivot, labkey, macaque, rhesus]
tools: []
parameters_refs: [genotype.export]
entry_points:
  - "Inspector > Genotype Display > Filtered Pivot..."
  - "Genotype viewport > Actions > Export Excel View..."
  - "CLI: lungfish-cli genotype export"
  - "CLI: lungfish-cli genotype export-xlsx"
  - "CLI: lungfish-cli genotype export-pivot-xlsx"
  - "CLI: lungfish-cli genotype export-labkey"
shots:
  - id: genotype-inspector-export
    caption: "The Export block at the foot of the Inspector's Genotype Display section, showing the Filtered Pivot... button and the caption stating that the copy is one-way."
  - id: genotype-export-save-panel
    caption: "The Export Genotype View save panel opened by Filtered Pivot..., with the suggested filename ending in -filtered-pivot.xlsx."
  - id: genotype-pivot-workbook
    caption: "The pivot sheet of an exported workbook in a spreadsheet application, with samples running across the columns and allele targets down the rows beneath the Total and # Obs. columns."
illustrations: []
glossary_refs: [allele-target, audit-log, cohort, csv, genotype, genotype-matrix, genotype-result-bundle, haplotype, inspector, json, labkey, locus, long-format, mhc, override, pivot-workbook, provenance, report-slot, retained-read, smart-cohort, tsv, viewport, xlsx]
features_refs: [genotype.export]
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

Exporting a genotype result copies what Lungfish Genome Explorer (LGE) computed into a file another program can open. The result itself stays where it is. A genotyping run leaves behind a [genotype result bundle](../../GLOSSARY.md#genotype-result-bundle), a folder carrying the `.lungfishgenotype` extension. It holds the read counts, an Excel workbook, the run statistics, and a [provenance](../../GLOSSARY.md#provenance) record of exactly how the run was made. Provenance is the written trail of what produced a file, naming the tool, the version, the inputs, and their checksums. A checksum is a short fingerprint that shows whether a file has changed. Finder shows the bundle as one item rather than as a folder of loose files, and double-clicking it opens the result in LGE.

The workbook already inside the bundle is LGE's own working copy, which the app rewrites as you review. An export is a separate file that stops changing the moment it is written, which is why the two exist side by side. Everything in this chapter reads the bundle and writes somewhere else, and only one control in the whole chapter writes back into the bundle. That control is **Update and View Current Excel Version**, described in Settings, and it rebuilds the bundle's own workbook from calls you have already made rather than changing a call.

There are four shapes an export can take, and they differ in who is going to open the file. An [XLSX](../../GLOSSARY.md#xlsx) workbook is the Excel format, and LGE writes two different workbooks from one result. One is a matrix workbook that lays samples down the rows and [loci](../../GLOSSARY.md#locus) across the columns, which is the shape a person reads. A locus is the place on a chromosome where one gene sits. The other is a [pivot workbook](../../GLOSSARY.md#pivot-workbook), where rows become columns and columns become rows, so samples run across the columns and [allele targets](../../GLOSSARY.md#allele-target) run down the rows. An allele target is one reference sequence the reads are matched against, and that samples-across shape is what most downstream spreadsheets in a genotyping lab already expect. A [CSV](../../GLOSSARY.md#csv) or [TSV](../../GLOSSARY.md#tsv) file is a plain text table, separated by commas or by tabs, which any program reads, Excel included. And a [LabKey](../../GLOSSARY.md#labkey) export writes several plain text tables in [long format](../../GLOSSARY.md#long-format), meaning one row per single fact, such as one row for each sample-and-allele pair, rather than one row per sample. LabKey is a shared research database, and long format is the shape a database loads most easily.

The choice among them is not a matter of taste. Give a collaborator the pivot workbook, give a script the CSV, and give a database the LabKey set. Exporting for your own records is the same decision made about yourself, so pick the pivot workbook if you will open it in Excel. Decide who opens the file first, and let that pick the format.

## Why you would do this

A genotype result is useful inside LGE and useless outside it until you export. The `.lungfishgenotype` folder is an LGE object, and the people who need your calls mostly do not run LGE. The immunologist wants a spreadsheet. The statistician wants a table a script can read. The data manager wants rows to load into a shared database. Each of those is a different file. Producing them by hand from the result window would mean retyping numbers. Retyping is exactly the step that introduces errors nobody catches.

The second reason is that an export is a fixed record of what you decided. The result bundle keeps changing while you review it, because every note, every flag, and every [override](../../GLOSSARY.md#override) you apply is written back into it. An override is a call you replaced by hand, recorded alongside the original so both survive. An exported file does not change. When you send a workbook to a collaborator and they come back three months later with a question, the file they hold is the one you sent, which makes the conversation possible.

The third reason is filtering. A genotyping result carries many allele targets seen only once or twice, which are real observations and poor evidence. On the worked example below, filtering the pivot at Min reads 50 and Min percent 5 removed 192 of 305 allele rows without touching a single strongly supported call. That is a normal outcome rather than a disaster, because the removed rows are the ones carrying one or two reads. Sending an unfiltered table asks your collaborator to do that filtering themselves, in Excel, with no record of what they removed.

This chapter works through the Williams MiSeq genotyping project, a rhesus macaque study of 30 animals sequenced on a MiSeq, a benchtop Illumina sequencing instrument. Its reads were matched against an IPD-MHC Mamu allele library, meaning the Immuno Polymorphism Database's catalogue of rhesus macaque [MHC](../../GLOSSARY.md#mhc) sequences. Every number quoted below comes from exporting that project's result.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder.

This chapter uses the Williams MiSeq genotyping project. It does not ship with LGE, so the figures below are for orientation rather than something you can reproduce on your own machine. If you have a `.lungfishgenotype` bundle of your own, follow along with it, because every export described here reads the same manifest, meaning the index file inside the bundle that names its contents. If you do not have one, read this chapter for orientation and come back when a run of your own finishes.

You also need a finished genotype result open in the window, which means you have already run a genotyping job as [Running Amplicon MHC Genotyping](02-running-genotyping.md) describes and read it as [Reading the Genotype Comparison](03-reading-the-genotype-comparison.md) describes. Click the `.lungfishgenotype` bundle in the sidebar to open it. That chapter also sets the filters this chapter's export will capture, so work through it first if you have not.

One fact about your result decides which in-app export you will find, so check it before you go looking. A run that produced only allele calls, with no haplotype analysis on top of them, is what LGE calls a genotype-only result, and the Williams result is one. The window shows you which kind you have. A genotype-only result shows the matrix with no view selector above it. A result that also carried out haplotype analysis shows a two-way selector reading **Haplotype Calls** and **Genotype Matrix**, with an **Actions** button beside it.

The [viewport](../../GLOSSARY.md#viewport) is the main display area in the middle of the window. On a genotype-only result it hides that **Actions** menu, and with it the **Export Excel View...** item, because the menu belongs to the haplotype presentation controls. The export you will actually use sits in the [Inspector](../../GLOSSARY.md#inspector), which is the panel down the right side of the window. Open it with **View > Show Inspector** (Cmd-Opt-I) if it is not already showing.

## Procedure

Every step here runs in the LGE window. The CSV, TSV, and LabKey exports have no button at all and are covered in On the command line at the end of the chapter.

### Step 1. Set the two filters that the export will capture

Open the Inspector's **Genotype Display** section, on the Inspector's View tab, by clicking the small triangle at the left of its heading. Scroll down through the Alleles and Samples search fields, the Min reads and Min percent controls, the Percent Basis picker, and the Cell Color choice. The Cell Color choice is the last control above the block headed **Export**, so once you can see it you have arrived.

<!-- SHOT: genotype-inspector-export -->

Set the two numeric filters before you press anything, because the export captures whatever they say at that moment. **Min reads** hides any allele value supported by fewer reads than the number you type, and **Min percent** hides any allele value making up less than that share of a sample's reads. Both sit at 0, which turns both filters off and shows every observation the run made.

Whether to change them is your call rather than a rule. LGE defines no threshold here, so there is no number the app treats as correct and none this manual will invent. The worked filter below uses Min reads 50 and Min percent 5, which is one example on one run rather than a recommended setting. Leave both at 0 for a first export if you want to see everything, then judge the result against your own sequencing depth, meaning how many reads each of your samples received.

### Step 2. Export the filtered pivot from the Inspector

Press **Filtered Pivot...**. A save panel opens with a suggested filename built from the result name and ending in `-filtered-pivot.xlsx`. Pick any folder you can find again.

<!-- SHOT: genotype-export-save-panel -->

Two things about this file are worth knowing before you open it. The filters you set in Step 1 are frozen into it, so a value your filters hid arrives as a blank cell rather than as a number. That is permanent in the exported copy alone and changes nothing about the calls in the result. The Inspector's own caption means exactly this when it says visual filters do not change genotype calls. The copy is also one-way, so edits you make in Excel never flow back into the result.

What LGE writes is a complete copy of the result's own workbook with exactly one sheet changed. The pivot sheet has the two filters applied, each row's Total and observation count are recomputed from what survived, and rows left with nothing in them are dropped. Every other sheet and all the formatting are carried through untouched.

### Step 3. Read what the pivot workbook holds

Open the exported file. Its first sheet is the pivot, named after the result, and it is laid out in three groups of rows.

<!-- SHOT: genotype-pivot-workbook -->

The top group is a header of three rows. The first two carry `Animal ID` and `GS ID`, the two sample identifiers, running across the columns. `Animal ID` names the animal and `GS ID` is the sequencing identifier the run carried, so one animal sequenced twice appears under two GS IDs. The third row is labelled `Filtered exact-match read count`. A [retained read](../../GLOSSARY.md#retained-read) is one that matched an allele target exactly across the whole sequenced stretch. That is a much stricter test than ordinary mapping, so these numbers are far smaller than a mapping run would report. That third row gives, for each sample, how many retained reads it contributed, alongside a Total and an Average across the whole run. On the Williams result the total is 682,927 reads across 30 samples, an average of 22,764 each, and the individual samples range from 2 reads to 58,370. LGE labels a sample carrying fewer than 1,000 retained reads Low Support, which on this plate covers 7 of the 30.

The middle group is a block of empty haplotype rows, 14 of them, labelled `MHC-A Haplotype 1`, `MHC-A Haplotype 2`, and so on through seven loci at two rows each. A [haplotype](../../GLOSSARY.md#haplotype) is a set of alleles across linked loci inherited together. These rows are left blank on a genotype-only result because no haplotype analysis ran to fill them, and they are where such an analysis would write its results.

The bottom group is the data, beginning with a row headed `Genotype` that labels the `Total` and `# Obs.` columns before the sample columns start. Every row below it is one allele target, named by its reference record. Each row gives that target's total read count across the run, the number of samples that observed it, and then one cell per sample.

Four different counts appear in this one result, and they count four different things. The library the run matched against holds 970 allele targets, which is the number of rows the matrix in the window can show. Of those, 305 carry a call in at least one sample, which is the number of rows the pivot writes. The run reports calls at 13 loci. The empty haplotype band covers seven loci in two rows each, and that list is fixed in the app rather than derived from your run, which is why it does not match the 13.

The filtering is visible in the numbers. On the Williams result, exporting at Min reads 50 and Min percent 5 blanked 1,478 individual allele values and removed 192 rows, leaving 113 of the original 305 allele rows. Blanking and removing are different. A value is blanked when it falls below a filter, and a row is removed only once every one of its values has been blanked.

One row shows the arithmetic plainly. The allele target `01_Mamu-A1_002g` carried a Total of 929 across 5 observations before filtering, and after filtering the same row reads 927 across 3 observations. Two of its five observations were single reads, so 929 minus 1 minus 1 is 927 and 5 minus 2 is 3. Both figures were recomputed rather than left stale. The name in the cell continues past a vertical bar with the alleles that record covers, so search for the part before the bar when you look for that row.

The workbook carries five further sheets. A long summary sheet holds the same data one row per sample-and-allele pair, 2,109 rows on this result, which is far fewer than 30 times 305 because it lists only the pairs actually observed. A sample summary sheet gives one row per sample with its read counts and its retained percentage, the share of that sample's reads that matched an allele target exactly. A `Run Stats` sheet lists the run's own settings and counters as name-and-value pairs. An `Overrides` sheet and an `Audit Log` sheet carry the edits a reviewer made by hand, and on a result nobody has reviewed both hold only their header row.

## Settings

The controls below sit in the Inspector's **Genotype Display** section, on the Inspector's View tab, with three exceptions named in their own paragraphs. **Export Excel View...** is an item in the viewport's **Actions** menu, and **Update and View Current Excel Version** is a button in the Inspector's **Current Workbook** block. That last one is the only control in this chapter that writes into the result bundle rather than out of it, so read its paragraph before you press it.

Everything else here changes only what you see. None of it alters a stored call. The section itself says so, in the line "Visual filters do not change genotype calls." What these controls do change is what an export writes, because the in-app export captures the view as it stands.

**Min reads.** Hides any allele value in the matrix supported by fewer reads than this, and the Filtered Pivot export then writes those hidden values out as blanks rather than as numbers. It sits at 0 by default, which turns the filter off so that every observation the run made is visible, and it accepts a whole number from 0 to 100,000. Raise it to drop the low-count background before handing a table to a collaborator, judging the number against your own run rather than against the 50 this chapter's example uses. On the command line this is `--min-reads`.

**Min percent.** Hides any allele value making up less than this share of a sample's reads, with Percent Basis deciding what that share is measured against. It sits at 0 by default, which turns the filter off, and it accepts a value from 0 to 100 which the control rounds to the nearest 0.5. Use it instead of Min reads when your samples were sequenced to very different depths, because a percentage suits them all where a fixed read count suits only the deep ones. On the command line this is `--min-percent`.

**Percent Basis.** Chooses the denominator Min percent divides by, offering two choices. Viewed Locus is the per-locus basis and compares an allele against that sample's reads at the same locus. Sample Retained is the per-sample basis and compares it against every read kept for the sample. The default in the window is Viewed Locus. Use Viewed Locus when your loci were amplified to different depths, which is the usual case for an amplicon panel, meaning a set of PCR products sequenced together. Use Sample Retained only when you genuinely want one sample-wide threshold. On the command line this is `--percent-basis`, whose default differs from the window's and is covered in On the command line.

**Alleles.** Keeps only the matrix rows whose allele name contains what you type, so typing `DRB`, one of the MHC class II gene families, narrows the matrix to the DRB targets alone. It starts empty, which shows every row, and it accepts any text. Use it to narrow a wide result to one locus family before exporting. On the command line this is `--filter`.

**Samples.** Keeps only the matrix columns whose sample name contains what you type. It starts empty, which shows every column, and it accepts any text. Use it to narrow an export to one plate or one group of animals. On the command line this is `--sample`, which names a sample exactly rather than matching a substring.

**Show All Rows.** Brings back every allele row you had hidden by selecting rows and choosing Hide Selected Rows from the same menu. It is a command rather than a stored value, so it has no default, and it is chosen from the **Rows...** menu and stays disabled while no rows are hidden. Use it when hiding has gone too far and you want the full allele list back. This setting has no command-line flag.

**Show All Columns.** Brings back every sample column you had hidden by selecting columns and choosing Hide Selected Columns. It is a command rather than a stored value, and it is chosen from the **Columns...** menu and stays disabled while no columns are hidden. Use it when hiding has gone too far and you want the full sample list back. This setting has no command-line flag.

**Cell Color.** Chooses what the matrix cell colours mean. Support shades a cell darker the more reads back it, Highlights shows only the colours you applied by hand, and None leaves cells plain. The default is Support. Switch to Highlights when you want an exported view to show your own marks and nothing else. This setting has no command-line flag.

**Filtered Pivot....** Writes a copy of the result workbook whose pivot sheet has Min reads and Min percent already applied, so hidden values arrive blank instead of needing to be cleared in Excel. Every other sheet is carried through unchanged. It is a button rather than a stored value, and it appears only when the result carries a workbook the pivot can be built from. If it does not appear, close the result and reopen it from the sidebar, and if it still does not appear write the same file with `lungfish-cli genotype export-pivot-xlsx`. This setting has no command-line flag, though that subcommand writes the same file.

**Export Excel View....** Writes the matrix as the viewport is showing it, together with your annotations, always as an Excel workbook with no format to choose, through a save panel. It is an item in the viewport's **Actions** menu rather than a stored value. That menu is hidden on a genotype-only result, so this item is out of reach on a result like the Williams one. Use it when you want a snapshot of the view in front of you rather than the whole result. This setting has no command-line flag, though `lungfish-cli genotype export-xlsx` writes the same workbook.

**Update and View Current Excel Version.** Rebuilds the bundle's own `current.xlsx` workbook from the calls and annotations on display, records the change as a workbook revision, then opens the file. It is a button in the Inspector's **Current Workbook** block rather than a stored value. It stays disabled while the workbook is already current, or while the bundle is read-only, which usually means the project sits in a folder you cannot write to. It writes into the result bundle rather than out of it, but it changes no call, because it copies calls and notes you have already made into the workbook that lives inside the bundle. Use it after review edits you want carried into that workbook. This setting has no command-line flag.

Eight further options exist only on the command line, and each one shapes an export that no button offers. A reader who works in the LGE window can skip to Reading the results.

**`--export-format`.** Chooses the container `lungfish-cli genotype export` writes, accepting `xlsx`, `csv`, or `tsv`, and defaulting to `xlsx`. Reach for `csv` or `tsv` when a script rather than a person opens the file, since neither in-app button offers a text format.

**`--view-projection`.** Points at a [JSON](../../GLOSSARY.md#json) file, meaning a plain text data file, that describes a rendered viewport, which is the app's record of what was drawn on screen. LGE writes such a file itself, which is how the in-app Export Excel View reproduces on disk exactly what was displayed. It defaults to none, in which case the export is built from the bundle itself, and most readers never supply one.

**`--lens`.** A lens is one of the named views a genotype result can be shown through. This flag records which one an export came from, writing the name into the export's provenance rather than changing the file's content. It defaults to none.

**`--annotations`.** Names an annotation sidecar, meaning a separate notes file stored beside the bundle, whose notes and comments are folded into the export. It defaults to the bundle's own `annotations.json` when one is present. Point it elsewhere only when you are exporting one bundle's calls with another reviewer's annotations.

**`--active-haplotype-definition`.** Names the haplotype definition set the calls are resolved against for the export. It defaults to none, which is the right setting for a genotype-only result, since there is no haplotype analysis to resolve, and haplotype definitions are covered in a later release of this manual.

**`--keep-empty-rows`.** Keeps allele rows in the pivot export that are empty after filtering, instead of removing them, which is the default behaviour. Pass it when a downstream sheet expects a fixed row order and would break if rows vanished. On the Williams result 192 rows vanish, which is that run's own figure rather than a general one.

**`--source-workbook`.** Names the workbook the pivot export copies and filters, defaulting to the bundle's `current.xlsx` when one exists and to its primary workbook otherwise. Name one explicitly when you want to filter an earlier revision rather than the current one.

**`--force`.** Overwrites an existing output file instead of stopping with an error. Without it every exporter refuses to write over a file that is already there. Most readers never need it, and it matters only when a script has to rerun cleanly.

## Reading the results

An export tells you nothing new. It is the same numbers in a different container, and the useful reading is a check that the container holds what you meant it to.

From the window, open the exported workbook and count. The pivot sheet should carry one column per sample you submitted and one row per allele target that survived your filters. The Total column of any row you recognise should match what the window showed for that allele.

From the command line there is more to read, because each exporter prints a summary. `genotype export-pivot-xlsx` names `matchedAlleleRows`, `filteredAlleleValueCount`, and `removedAlleleRowCount`. Those three numbers record how much your filters removed. On the Williams result an unfiltered export reported 305 matched rows, 0 filtered values, and 0 removed rows. The same export at Min reads 50 and Min percent 5 reported 305 matched rows, 1,478 filtered values, and 192 removed rows. The matched-row count is the total number of rows examined rather than the number that survived, so it stays at 305 either way. Read it as a check that the exporter saw the whole result, and read the other two as the effect of your thresholds.

Check the sample count. Every exporter reports one, and it should match the number of samples you submitted rather than the number that worked. The run's own provenance record names how many went in, so check there if the run was not yours. The Williams exports all report 30, which is correct even though 7 of those samples carry the Low Support label. A result that quietly dropped its failures would be worse than one that carries them.

Check that the empty files are empty for the right reason. Four of the five LabKey files came out header-only on this result, and that is correct output for a run nobody had annotated. On a reviewed result those same four files should carry rows, and if they do not, the review edits did not reach the bundle.

## What good looks like

A good export is boring, which is a compliment. The exporter finishes without an error, the summary names the file it wrote, the sample count matches what you ran, and the file opens in the program it was meant for.

Beyond that, one number is worth a moment. A filtered pivot that removes a large fraction of its rows is normal rather than alarming. Removing 192 of 305 rows sounds severe until you look at which rows went. They were the ones carrying one or two reads in a single sample, and the strongly supported calls kept every one of their values. If a filter removes rows you expected to survive, the threshold is wrong for your sequencing depth, not the export.

A bad export usually announces itself as a mismatch rather than a failure. Three mismatches say the same thing. A sample count lower than the number you submitted, an allele row you can see in the window but not the file, or a total that disagrees with the result. Each means the export captured a filtered view when you wanted the whole one. Set Min reads and Min percent both back to 0 and export again.

## Haplotype analysis (placeholder)

The choice of haplotype definitions is not documented in this release of the manual.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, and the CSV, TSV, and LabKey exports are the only things here the window cannot produce. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application, which you open from the Applications folder under Utilities.

In the examples below, the backslash at the end of a line means the command continues on the next line. You can type each command as one long line instead and leave every backslash out.

Every command takes a `--bundle` pointing at the `.lungfishgenotype` folder. The quickest way to get that path right is to type `--bundle ` and then drag the bundle from a Finder window into the Terminal window, which pastes its full path. Write the matrix workbook with

```bash
lungfish-cli genotype export-xlsx \
  --bundle "Analyses/Amplicon genotyping results/my-run.lungfishgenotype" \
  --output my-run-matrix.xlsx
```

which prints a summary naming the bundle, the output, and the counts it wrote. On the Williams result that summary read `sampleCount` 30, `locusCount` 13, `overrideCount` 0, and `auditEntryCount` 0.

The matrix workbook holds four sheets. `Matrix` puts one row per sample and two columns per locus, headed `H1` and `H2`. Those two columns are the locus's two [report slots](../../GLOSSARY.md#report-slot), meaning the two allele positions a report gives each locus. A two-row header gives the locus above and the slot below. `Legend` decodes the fill colours. It lists the tokens `M1` through `M7`, the published names of the seven MHC haplotypes first described for Mauritian cynomolgus macaques. Each token is fixed to one colour, so the same haplotype looks the same in every workbook. The same sheet carries an `ERR` token, meaning the software could not decide and made no call, and a `(blank)` entry meaning absent or unanalyzed. `Overrides` and `Audit Log` carry the reviewer edits, header-only when nobody has reviewed the result.

Write the pivot workbook, with or without filters, using `genotype export-pivot-xlsx`. Its `--min-reads`, `--min-percent`, and `--percent-basis` flags mirror the Inspector controls exactly, `--keep-empty-rows` suppresses the row removal, and `--source-workbook` names which workbook to copy.

```bash
lungfish-cli genotype export-pivot-xlsx \
  --bundle "Analyses/Amplicon genotyping results/my-run.lungfishgenotype" \
  --output my-run-pivot.xlsx \
  --min-reads 50 --min-percent 5 --percent-basis viewed-locus
```

One difference from the window is a fact rather than a fault. The Inspector's Percent Basis defaults to Viewed Locus, while `--percent-basis` on the command line defaults to `sample-retained`, which a run with no flag at all reports back in its own summary. The two defaults are simply different, so pass `--percent-basis viewed-locus` whenever you want the command line to match the window.

Write a text table with the general `genotype export` and its `--export-format`, which is the only route to a CSV or a TSV.

```bash
lungfish-cli genotype export \
  --bundle "Analyses/Amplicon genotyping results/my-run.lungfishgenotype" \
  --export-format csv --output my-run.csv
```

The CSV and TSV are the same matrix flattened into one header row and one row per sample. On the Williams result that is 30 data rows and 27 columns. The 27 is one `Sample` column plus an `H1` and `H2` pair for each of the 13 loci the run reported, since 13 times 2 plus 1 is 27.

Write the LabKey set with `genotype export-labkey`, which takes an output folder rather than a file and creates it if it is missing. Filters do not apply to this export, because the shape is fixed by what a database importer wants.

```bash
lungfish-cli genotype export-labkey \
  --bundle "Analyses/Amplicon genotyping results/my-run.lungfishgenotype" \
  --output-dir labkey-out
```

The files are `haplotype_calls.csv`, `allele_read_counts.csv`, `overrides.csv`, `audit_log.csv`, and `smart_cohorts.csv`. Together they cover the final post-override haplotype calls, the per-sample per-allele read counts, the reviewer overrides, the [audit log](../../GLOSSARY.md#audit-log), and any saved [smart cohorts](../../GLOSSARY.md#smart-cohort). A smart cohort is a named filter over the samples, saved inside the result. Every file is in long format, one row per fact, and a comma inside a value is handled safely.

On the Williams result `allele_read_counts.csv` carried 2,109 data rows under the header `animal_id,gs_id,allele,locus_group,unique_reads,passed_unique_reads,passed_alignments`. Its three read-count columns differ. `unique_reads` counts the distinct read sequences seen for that allele in that sample, `passed_unique_reads` counts those that survived the run's own checks, and `passed_alignments` counts the individual alignments behind them. The other four files carried their header row and nothing else, which is the correct output for a result nobody had annotated. A correction you make by hand replaces the original pipeline call in these files, so a database receives the reviewed call rather than the raw output of the run.

One defect to work around. On this build `genotype export` fails when the output path is spelled `/private/tmp/...`, reporting a provenance publication artifact error and writing no file. The cause is that LGE compares two spellings of the same path and concludes wrongly that they do not match. The same folder reached as `/tmp/...` works, and so does a folder inside your home directory. The other three exporters are unaffected.

## Next

Return to [Reading the Genotype Comparison](03-reading-the-genotype-comparison.md) to set the filters an export will capture, or to [What Is MHC Genotyping](01-what-is-mhc-genotyping.md) for the allele naming that fills every row of the files you just wrote.
