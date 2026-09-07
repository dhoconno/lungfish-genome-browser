# Merged reader report, Downloading Reads from the SRA

Four readers. Sophomore with one genetics course, senior undergraduate with pipetting experience, pre-med student with English as a second language, and an undergraduate who has used Geneious. None had opened a terminal.

| Location | What stopped readers | Hit count | Shortest fix |
|---|---|---|---|
| What it is, "The archive nests four kinds" | The four accession levels (project, sample, experiment, run) arrive as flat facts and readers could not tell which level contains which. | 4 | Say project holds samples, which hold experiments, which hold runs, before listing them. |
| Why you would do this, "This run is 115,776 read pairs" | Readers could not judge whether 115,776 pairs is a lot or a little for an amplicon run. | 4 | Say this is a typical depth for a single amplicon target. |
| Before you start, "Nothing here needs a plugin pack or Docker Desktop" | Naming unfamiliar tools only to dismiss them made readers worry they had skipped a setup step. | 4 | Say only that no extra software is needed, drop the tool names. |
| Procedure step 1, the unlabelled scope popup | Readers did not know what the popup showed by default, so they could not find it on screen. | 4 | Say the popup reads "All Fields" by default. |
| Procedure step 3, "Type Homo sapiens mitochondrion" | Nothing earlier said the run targets mitochondrial DNA, so readers thought they had the wrong search text. | 4 | Say the run targets the mitochondrial genome when it is first introduced. |
| Procedure step 5, "Confirm those two settings and click Import" | Readers did not know what action "confirm" requires, a click, a check, or just reading the values. | 4 | Say to check that the values are correct, then click Import. |
| Procedure, "Watch the progress in the Download Center" | Readers were never told how to open the Download Center, the first time it appears. | 4 | Give the menu path to the Download Center. |
| Downloading a list of accessions, the CSV or plain-text file | Readers did not know the required file layout, one accession per line, a header row, or a column name. | 4 | Give one example line of file content. |
| Settings, Platform, instrument names | Readers could not tell which of the listed instruments are long-read versus short-read. | 4 | Mark which listed platforms are long-read in one clause. |
| Settings, Strategy, "WXS" | WGS and AMPLICON are glossed in the same sentence but WXS is not, and one reader mistook it for a typo of WGS. | 4 | Expand WXS the way WGS is expanded. |
| Settings, Min Size | The example floor is not tied to the chapter's own run, so readers could not judge whether it was strict or loose. | 4 | Anchor the example floor to the chapter's own run size. |
| Reading the results, "spot" | Spot is introduced late, is not in the glossary list, and readers reread the paragraph to accept that one spot equals one pair. | 4 | Gloss spot at first use and add it to the glossary list. |
| Reading the results, sparkline | Readers did not know what a sparkline is and could not picture the chart. | 4 | Gloss sparkline as a small inline chart. |
| Reading the results and What good looks like, metadata and provenance sidecars | Readers could not tell how to view a sidecar from the app, or how the metadata and provenance sidecars differ. | 4 | Say how to view a sidecar from the app, and distinguish the two in one sentence. |
| What good looks like, summary card counting spots or reads | Readers were asked to check the bundle against the archive but were not told whether the summary card shows spots or reads. | 4 | State what number the summary card shows. |
| Troubleshooting, "HTTP 429" | Readers did not know what HTTP 429 means or which log to check. | 4 | Say it means a rate-limit error, and name the log. |
| What it is, multiple prefixes for one level (SRR, ERR, DRR and SRP, PRJNA) | Different prefixes for the same accession level made readers reread, unsure whether the data itself differed. | 3 | Say the prefixes only record which archive took the deposit. |
| What it is, pane versus tab versus window | Readers could not tell whether a pane is something they click or something already visible. | 3 | Name the control, for example "three tabs across the top". |
| What it is, "Import Center" | The Import Center has not appeared yet in the chapter, so the reference points at something unseen. | 3 | Say the Import Center is not something readers need to open in this procedure. |
| Why you would do this, "34,964,352 bases in total" | Readers tried to check this against 115,776 pairs and 151 bases, got a number twice as large, and suspected an error before the explanation arrives later. | 3 | Say here that the base count already counts both mates. |
| Procedure step 2, "Click Show" on Advanced Search Filters | Readers could not tell whether Show is a button, a link, or a disclosure triangle. | 3 | Name the control type. |
| Procedure step 4, finding one accession in 238 unsorted rows | With no sorting and no search inside the results, readers had no way to find one specific accession among near-identical rows. | 3 | Say to narrow the scope popup to Accession and search the accession directly. |
| Reading the results, byte counts not converted | Exact byte counts could not be checked against the 28 MB claim without a manual conversion. | 3 | Give the sizes in MB alongside the bytes. |
| Reading the results, single spike in Length Dist. sparkline | Readers could not tell whether a single spike is expected or a warning sign. | 3 | Say plainly that a single spike is expected and fine at this stage. |
| Reading the results, "exactly thirteen fields" | Readers counted the fields but could not tell why the count matters or whether it holds for every run. | 3 | Drop the count, or say whether every run prints the same fields. |
| What good looks like, "a bundle half the expected size" | Readers did not know where the bundle's size is displayed, so they could not run this check. | 3 | Say where the bundle size is shown. |
| Which path served your download, prefetch and fasterq-dump | Readers could not tell whether these command-line programs need separate installation or are handled by the app. | 3 | Say whether the app installs these itself. |
| Troubleshooting, "An NCBI API key" | Readers have no NCBI account and the chapter does not say whether one is needed for the main procedure. | 3 | Say the key is free and optional, only for heavy use. |
| Troubleshooting, no retry control | The sentence says what is absent, a retry button, but not what to do instead. | 3 | Say to start the download again from the pane. |
| Troubleshooting, "Interleaved" | Readers could not tell how they would recognize their own file as interleaved. | 3 | Say interleaved means the two mates alternate down the file. |
| What it is, "library" | Readers' genetics classes used "library" for a cloned collection and could not tell if this chapter means the same thing. | 2 | Gloss library at first use, the way FASTQ and accession are glossed. |
| Settings, Max Results, dialog default of 50 versus command-line default of 20 | Two different defaults for what read as one setting made readers think they had misread one of them. | 2 | State plainly that the dialog and the command line differ on purpose. |
| On the command line or Settings, the optional command-line section | A reader trusted the "optional" label but was unsure after Settings had already pointed to a command-line flag. | 2 | Repeat the "optional" line wherever Settings first mentions a flag. |
| Reaching ENA directly, multiple file-size figures for one run | Three different size figures for the same run, in bytes, about 28 MB, and 28.1 MB, left readers unsure which to trust. | 2 | State once which figure is the true, delivered size. |
| Troubleshooting, "The run page on NCBI's" | Readers were not told how to reach the run page from an accession. | 2 | Give the URL pattern, or say the accession is searchable on the NCBI site. |

## Summary

The most common failure was readers hitting an instruction or a control before the chapter had told them what it looked like or where to find it, the unlabelled scope popup, the Download Center, and the Advanced Search Filters "Show" control all drew this same complaint. A close second was numbers and terms introduced without a frame of reference, spot, sparkline, the read-pair count, and the base count all left readers unable to judge whether what they saw was normal. The third recurring pattern was naming something, a plugin pack, an API key, prefetch and fasterq-dump, or a sidecar file, only to leave its relevance or its access method unresolved.
