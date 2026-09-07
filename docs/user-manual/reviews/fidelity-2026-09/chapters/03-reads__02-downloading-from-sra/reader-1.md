# Reader report: Downloading Reads from the SRA

Reader 1. Sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "The archive nests four kinds" | "Nests" made me picture folders inside folders, but the four are then listed flat and I could not tell which level contains which. | One sentence saying a project holds samples, which hold experiments, which hold runs. |
| What it is / "names one pass of one" | I do not know what a "library" is here. In genetics class a library was a cloned collection and I could not tell if this is the same thing. | Gloss library at first use, the way FASTQ and accession are glossed. |
| What it is / "A project accession begins `SRP`" | Two different prefixes for the same level made me reread. I still do not know which one a paper would print. | Say which prefix papers usually print. |
| What it is / "That window is the same one" | I could not tell if a pane is a tab I click or three things visible at once. | Name the control, for example "three tabs across the top". |
| What it is / "then runs the same import" | The Import Center has not appeared yet in this chapter, so "the same import" points at something I have not seen. | Add "described in the previous chapter" after Import Center. |
| Why you would do this / "This run is 115,776 read pairs" | I could not judge whether 115,776 pairs is a lot or a little for an amplicon run. | One clause saying this is a typical depth for a single amplicon target. |
| Why you would do this / "34,964,352 bases in total, and" | I tried to check this against 115,776 and 151 and got a number twice as large, so I thought the manual had an error long before the spot explanation arrives. | Say here that the base count already counts both mates. |
| Before you start / "Nothing here needs a plugin" | I do not know what a plugin pack is, and being told I do not need something I have never heard of made me worry I had skipped a setup chapter. | Drop the mention or point to the chapter that explains it. |
| Procedure step 1 / "A query field sits at the top" | I would not know what to look for. Everything on a screen looks labelled to me until I am told otherwise. | Say what text the popup shows by default, "All Fields". |
| Procedure step 2 / "Set **Platform** to ILLUMINA, **Strategy**" | The step tells me to set them but not why these three. I copied them without understanding. | One clause tying each choice to the example run. |
| Procedure step 3 / "Type `Homo sapiens mitochondrion` into" | Nothing earlier said this run is mitochondrial. I thought I had the wrong search text. | Mention mitochondrial when the run is first introduced. |
| Procedure step 4 / "Each row carries the run accession" | Length of what, one read or the whole run? I only guessed the whole run once I reached the results table much later. | Say "the run's total bases". |
| Procedure step 5 / "Confirm those two settings and" | I did not know what "confirm" means as an action. Is there a Confirm button, or do I just look at them? | Say "check that they read Illumina and Paired-end, then click Import". |
| Procedure / "Watch the progress in the" | I was not told how to open the Download Center, and it is the first time it appears. | Give the menu path the way the search menu path is given. |
| Downloading a list / "Click Import Accessions on the" | I could not tell the required file layout. One accession per line? A header row? A particular column name? | One example line of file content. |
| Settings / "Every entry ends by saying" | I have never opened a terminal, so I could not tell whether "reaches the command line" mattered to me at all. | Say plainly that dialog-only readers can ignore those sentences. |
| Settings / Platform / "Keeps only runs produced on" | Five instrument names I have never heard. I could not tell which are long-read and which are short. | Mark which of these are long-read in one clause. |
| Settings / Strategy / "Keeps only runs whose library" | WGS and AMPLICON are glossed in the same sentence but WXS and Targeted-Capture are not. | Gloss WXS the way WGS is glossed. |
| Settings / Min Size / "Set it to exclude runs" | I do not know what a reasonable floor is for this chapter's run, whose own size is about 35 million bases. | Tie the example floor to the chapter's run. |
| Settings / Max Results / "On the command line this" | The dialog default is 50 and the command default is 20, and I could not tell which number applied to the search I had just run. | State that the dialog you used returned up to 50. |
| Reading the results / "Each row in the results" | I do not know what monospaced type is by sight. | Say "in a typewriter-style font". |
| Reading the results / "Read that Reads column carefully" | "Spot" is new here and is not in the glossary list at the top of the chapter. I read the paragraph twice before accepting that one spot equals one pair. | Gloss spot the way run accession is glossed. |
| Reading the results / "The Size column is the" | Raw byte counts stopped me. I could not convert them in my head to check the 28 MB claim. | Give MB alongside the bytes. |
| Reading the results / "For this run it printed" | I counted thirteen lines, but I could not tell whether "exactly thirteen" is a promise for every run or just this one. | Say whether every run prints the same fields. |
| Reading the results / "Source    : GENOMIC" | The one field in that block that is never explained anywhere in the chapter. | One clause saying what Source means. |
| Reading the results / "Its FASTQ viewport shows the" | I do not know what a sparkline is, and I could not picture nine cards. | Gloss sparkline. |
| Reading the results / "For this run every read" | I could not tell whether a single spike is good or bad, and even after the untrimmed clause I was unsure whether I should now trim. | Say plainly that a single spike is expected and fine at this stage. |
| Reading the results / "The bundle also carries where" | Two sidecars appear in one paragraph, a metadata sidecar and a provenance sidecar, and I could not tell them apart or say which holds what. | One sentence distinguishing the two. |
| What good looks like / "`fetch sra info` reported 115.8K" | I was asked to do the doubling myself but not told which number the summary card shows, spots or reads. | State what the card shows. |
| What good looks like / "A bundle half the expected" | I do not know where to see the bundle's size, so I could not run this check. | Say where the size is displayed. |
| What good looks like / "Confirm the folder. A downloaded" | "Reference bundles" is new here and I could not tell how one differs from the read bundle I just made. | Gloss reference bundle or point to its chapter. |
| Which path served / "Tools involved | Direct HTTPS fetch" | `prefetch` and `fasterq-dump` read like programs I would have to install, and the table does not say whether the app handles that for me. | Say whether the app installs these itself. |
| Which path served / "The provenance sidecar names which" | I did not know where to look to see this field, or whether I can open that file at all. | Say how to view the provenance sidecar from the app. |
| Troubleshooting / "The symptom is a download" | I do not know what HTTP 429 is or which log to look in. | Say "a rate-limit error in the Download Center log". |
| Troubleshooting / "An NCBI API key lifts" | I have no NCBI account and the chapter does not say I would need one. | One clause saying an account is free and optional. |
| Troubleshooting / "The fix is to set" | Interleaved appears here for the first time in the body and I could not tell how I would know my file is interleaved. | Say how to recognise an interleaved file. |
| Troubleshooting / "The run page on NCBI's" | I was not told how to reach that page. | Give the URL pattern or say the accession is searchable on the NCBI site. |
| On the command line / "This section is optional. If" | I trusted this, but Settings had already sent me to the command line for `--limit`, so I was not sure I could really skip it. | Repeat the "optional" line where Settings first mentions flags. |
| Reaching ENA directly / "For a reference that needs" | I did not know what annotations are or why their absence matters to me. | One clause saying annotations mark where genes sit. |

One thing I learned. The archive stores four levels of accession and only the run level, the one starting SRR, holds the FASTQ files you actually download.

One thing I still could not do. Check my downloaded bundle against the archive, because I never learned whether the summary card counts spots or reads, or where the bundle's size is shown.

The sentence I liked most. "A spot is one fragment the instrument read, so a paired run reports one spot for every pair."
