# Reader report: Downloading Reads from the SRA

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The archive nests four kinds of accession..." | I read this paragraph three times. Four accession types arrive at once and I could not hold them apart. I still do not know which one is printed in a paper. | A small table with the prefix, what it names, and which one to paste into the search box. |
| What it is, "A run accession begins `SRR`, `ERR`..." | Why three different prefixes for the same thing? I assumed different prefixes meant different data. | One clause saying the prefix only records which archive took the deposit. |
| What it is, "or `PRJNA` in NCBI's own BioProject numbering" | Two names for one thing, `SRP` and `PRJNA`, with no explanation of when I would see each. | Say which one papers usually print. |
| What it is, "its three panes hold GenBank & Genomes, SRA Runs, and Pathoplexus" | I have never heard of Pathoplexus and it is not glossed here. | A four-word gloss, or drop the name since this chapter never uses that pane. |
| What it is, "LGE fetches the FASTQs from ENA, the European mirror" | The chapter told me I was searching SRA, then said the files come from somewhere else. I thought I had misread a step. | One sentence up front saying the search and the file transfer use two different services on purpose. |
| What it is, "written into the bundle's metadata sidecar" | I do not know what a sidecar is. Provenance is defined in the next sentence but sidecar never is. | Gloss "sidecar" at first use the way provenance is glossed. |
| Why you would do this, "115,776 read pairs of 151-base Illumina reads" | I cannot tell whether 115,776 pairs is a lot or a little. The text says it behaves like a real dataset but not what a real dataset usually is. | One comparison sentence, for example that a typical amplicon run falls somewhere between X and Y pairs. |
| Why you would do this, "34,964,352 bases in total" | I tried to check this against 115,776 pairs and 151 bases and got a different number until I remembered to double for mates. That took me a minute. | Show the arithmetic once, since the spot-versus-read trap is explained much later. |
| Before you start, "Nothing here needs a plugin pack or Docker Desktop" | I do not know what a plugin pack is and I do not know whether I have Docker Desktop. Being told I do not need them made me worry I might. | Drop the sentence or say "you do not need to install anything extra". |
| Procedure step 1, "an unlabelled scope popup at its left" | I could not find this. A popup with no label is exactly the thing a beginner cannot locate, and the screenshot is called for two steps later. | Describe what the popup reads by default, so I can look for the words "All Fields". |
| Procedure step 2, "Click Show on the Advanced Search Filters panel" | I looked for a button named Show and was not sure whether Show is a button, a link, or a disclosure triangle. | Say which it is. |
| Procedure step 2, "Min Size (Mbases)" | Mbases is never spelled out here. I guessed megabases. | Expand it once at first use. |
| Procedure step 3, "Type `Homo sapiens mitochondrion`" | Nothing told me this run is mitochondrial until this line. The chapter earlier called it a human amplicon run, so I did not know what region was amplified. | Say what was amplified when the run is introduced. |
| Procedure step 3, "The results list fills with runs that match every filter" | I did not know how long to wait or whether an empty list means a failure or a real zero. | A note on the expected wait and what an empty list looks like. |
| Procedure step 4, "Tick `SRR32909537` in the results list" | With 238 near-identical rows and no sort, I have no idea how to find one specific accession. The text says elsewhere the list is not sortable. | Tell me to narrow the scope popup to Accession and search the accession directly. |
| Procedure step 5, "Confirm those two settings and click Import" | Confirm against what? I have no independent source to confirm them against at that moment. | Point at `fetch sra info` earlier, or say these are read from the archive and are usually right. |
| Procedure, "Watch the progress in the Download Center" | I was never told where the Download Center is or how to open it. | Name the menu item or window that shows it. |
| Downloading a list of accessions, "pick a CSV or plain-text file listing them" | I do not know what the file should look like. One accession per line? A header row? | A two-line example of the file contents. |
| Settings, "Every entry ends by saying whether the setting reaches the command line." | I have never opened a terminal, so I did not know if these last sentences were warnings I needed. | Say plainly that a missing flag does not limit the dialog. |
| Settings, Platform, "among Any, ILLUMINA, OXFORD_NANOPORE..." | Eight instrument names with no hint which are short-read and which are long-read, though the next sentence says the distinction matters downstream. | Mark which of the listed options are long-read. |
| Settings, Strategy, "WXS, Targeted-Capture, and OTHER" | WGS and AMPLICON are expanded. WXS, Targeted-Capture, and RNA-Seq are not. | Expand WXS at least, since it looks like a typo for WGS. |
| Settings, Min Size, "for example a floor of 10 to drop everything under 10 million bases" | 10 million bases sounds enormous to me but the example run is 35 million, so a floor of 10 keeps almost everything. I could not tell if the example was meant to be strict or loose. | Anchor the example to the chapter's own run. |
| Settings, Publication Date, "through two fields labelled From and To" | No date format is given. I did not know whether to type 2025-01-01 or 01/01/2025. | State the expected format. |
| Reading the results, "it counts spots rather than individual reads" | Spot is a new word introduced in a results section, and it is the single most confusing number in the chapter. It is defined here but the number it explains appears much earlier. | Define spot the first time a read count appears. |
| Reading the results, "12,840,092 and 15,276,682 bytes, about 28 MB" | Two exact byte counts I cannot use for anything. I do not know how to see the byte count of my own download. | Say what I would check instead, or give only the 28 MB. |
| Reading the results, "the Length Dist. sparkline is a single spike" | I do not know what a sparkline is and I have not seen the FASTQ viewport yet in this chapter. | Gloss sparkline, or call it a small inline chart. |
| What good looks like, "the bundle's summary cards should agree once you remember the spot-versus-read distinction" | Agree how? If the card says 231,552 and the archive said 115.8K, those do not look equal to me. | State the expected card value outright. |
| What good looks like, "A bundle half the expected size means the import ran as single-end" | I do not know where to see the bundle size, and half of what exactly, files or reads. | Name the place the size is shown. |
| Which path served your download, "`prefetch` then `fasterq-dump`" | These are terminal programs and I was told the terminal section is optional, yet this table is not marked optional. | Say the fallback is automatic and needs nothing from me. |
| Which path served your download, "`selectedStrategy` read `ena-direct`" | This is a field inside a file I have never opened. I do not know how to look at a provenance sidecar from the app. | Say whether the app shows this anywhere, or mark it as a command-line detail. |
| Troubleshooting, "an HTTP 429 in the log" | I do not know what HTTP 429 means and I do not know which log. | Say it means the server asked you to slow down, and name the log. |
| Troubleshooting, "since a failed download row carries no retry control of its own" | So what do I click? The sentence tells me what is absent, not what to do. | Say to start the download again from the pane, as the next item does. |
| Troubleshooting, "or to Interleaved when a single file holds both mates" | Interleaved appears only here, with no way for me to tell which case I have. | Say how to tell, or point to the earlier import chapter. |
| On the command line, "which needs `prefetch` and `fasterq-dump` installed" | I could not tell whether the app version also needs these installed, since the fallback table said the app uses them too. | State that the app manages this itself. |

Learned: the SRA search and the actual file download go through two different archives, and a downloaded run becomes exactly the same kind of bundle as one I import from a drive.

Could not do: find one specific run accession inside a results list of 238 rows that has no sorting and no column headers.

Liked most: "A spot is one fragment the instrument read, so a paired run reports one spot for every pair."
