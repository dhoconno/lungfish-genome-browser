# Reader report, Downloading Reads from the SRA

Reader 3. Pre-med student, English is my second language. I have taken
genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The Sequence Read Archive, written SRA..." | "Public warehouse for raw sequencing reads" stopped me. A warehouse is a building for boxes. I read it twice before I understood it means a database. | Say it is a free public database. |
| What it is, "The archive nests four kinds of accession..." | "Nests" as a verb was new. I know a bird nest. I could not tell if the four accessions sit inside each other or beside each other. | Say the four kinds are arranged inside one another, largest to smallest. |
| What it is, "An experiment accession begins SRX..." | Four accession types arrive in four fast sentences with no picture. By the fourth I had lost the first and could not say which contains which. | A small diagram, or one sentence naming the order from project down to run. |
| What it is, "and names one pass of one library..." | "One pass of one library through one instrument" defeated me. I do not know what a library is here, and my genetics class used "library" for a cloning collection. | Gloss "library" at first use, since Strategy and Layout both rely on it later. |
| What it is, "its three panes hold GenBank & Genomes..." | I do not know what a "pane" is in a window. I guessed it means a tab. I could not tell whether I must choose the pane myself. | Say the window has three tabs and the menu item opens the right one already. |
| What it is, "LGE fetches the FASTQs from ENA..." | ENA appears for the first time here and is only called "the European mirror". I read "mirror" twice and still wondered whether the data is different. | One clause saying a mirror holds the same data at a second site. |
| What it is, "runs the same import the Import Center runs" | "Import Center" is capitalised like a place in the app, but I am never shown it and it is not in the entry points. I did not know whether I must open it. | Say the Import Center is not something you open in this procedure. |
| Why you would do this, "This run is 115,776 read pairs of 151-base..." | Three numbers in one sentence, pairs and read length and total bases. I could not judge whether 115,776 is a lot for an amplicon run. | Say whether this is a typical depth for an amplicon run. |
| Why you would do this, "one of 238 human amplicon runs deposited..." | I did not know why 238 matters to me. The next sentence says searches rarely return one run, but I still did not know what to do with the number. | Say the filters exist because a single study can be this large. |
| Before you start, "Nothing here needs a plugin pack or Docker..." | Both terms are new, and both appear only to be called unnecessary. I still worried I was missing an install. | Say plainly that this chapter needs no extra software. |
| Procedure step 1, "with an unlabelled scope popup at its left" | A popup with no label cannot be found by reading. The Settings section calls it "(search scope)", which did not help me locate it on screen. | Say what text the popup shows by default so I can recognise it. |
| Procedure step 2, "Click Show on the Advanced Search Filters panel" | I could not tell whether Show is a button, a link, or a small triangle. I hunted for a button named Show. | Name the control type. |
| Procedure step 2, "These narrow the search itself rather than..." | I read this twice. The distinction is real, but it is abstract at a moment when I have no list at all. | Say the filters go to the archive, so changing them means searching again. |
| Procedure step 3, "Type Homo sapiens mitochondrion into the query field" | The chapter calls the example a human amplicon run but never says the target is mitochondrial DNA. The search word arrives unexplained. | One clause saying the run targets the mitochondrial genome. |
| Procedure step 4, "Tick SRR32909537 in the results list" | With Max Results at 50 and 238 runs in the study, I did not know how to find this one accession. There is no sorting and no search inside the results. | Say to set the scope popup to Accession, or say where in the list the run falls. |
| Procedure step 5, "Confirm those two settings and click Import" | "Confirm" is vague to me. I did not know whether I must click something to confirm or only look. | Say to check the two values, then click Import. |
| Procedure, after step 5, "Override the Pairing popup before you import" | "Override" is a hard word for me, and this instruction sits after the numbered list where I nearly missed it. It also asks me to know the metadata is wrong, which I cannot know. | Say how a beginner would notice the metadata is wrong. |
| Procedure, "Watch the progress in the Download Center" | I was never told how to open the Download Center. The sentence assumes it is already in front of me. | Say where the Download Center is, or that it opens by itself. |
| Downloading a list of accessions, "pick a CSV or plain-text file listing them" | I did not know the required format. One accession per line? Commas? A header row? | State the file layout in one sentence. |
| Downloading a list of accessions, "A file with no recognisable accession in it" | I did not know what makes an accession "recognisable" to the app. | Say the app looks for identifiers beginning SRR, ERR, or DRR. |
| Settings, "Every entry ends by saying whether the setting reaches..." | I do not use the command line, and six of seven entries end with "This setting has no command-line flag." I read that sentence six times for nothing. | Move the skip advice so it lands before the entries begin. |
| Settings, Platform, "among Any, ILLUMINA, OXFORD_NANOPORE..." | Eight instrument names in capitals with underscores and no explanation. I only know Illumina. I could not tell which produce long reads. | Mark which of the eight are long-read platforms. |
| Settings, Strategy, "WXS, Targeted-Capture, and OTHER" | WGS and AMPLICON are glossed in the same sentence, but WXS, RNA-Seq, and Targeted-Capture are not. WXS means nothing to me. | Expand WXS at least, since it is the one pure initialism left unexplained. |
| Settings, Strategy, "when you want tiled primer-scheme data" | "Tiled primer-scheme data" is three unknown words together. I could not picture it. | Drop it or gloss it, since amplicon was already explained earlier. |
| Settings, Min Size, "for example a floor of 10 to drop everything..." | I did not know how to choose a floor, and the example gives 10 with no reason for 10. | Say what a sensible floor would be for the example run, which has 34.9 million bases. |
| Settings, Publication Date, "Set a start date when you are following..." | The advice is about an outbreak, but this chapter's data is human mitochondrial. I could not map the example onto my own situation. | Give a reason a student would have, such as keeping only recent deposits. |
| Reading the results, "it counts spots rather than individual reads" | "Spot" is new, and the definition "one fragment the instrument read" made me read the paragraph twice. I still cannot tell whether the app's cards count spots or reads. | Say which number the bundle's summary cards show. |
| Reading the results, "The 115.8K figure for SRR32909537 is 115,776 pairs" | The column is headed Reads but the text says it is really pairs. Later I am told to confirm 115.8K reads against the cards. I could not tell which number should match which. | Give the expected card value in plain numbers. |
| Reading the results, "12,840,092 and 15,276,682 bytes, about 28 MB" | Two exact byte counts stopped me and I added them by hand. The exact digits taught me nothing. | Give the two file sizes in MB. |
| Reading the results, "For this run it printed exactly thirteen fields." | I counted thirteen lines in the block, but I did not know why the count matters to me. | Say I should see all thirteen, so a shorter output signals a problem. |
| Reading the results, "Bases     : 34964352" | This number has no thousands separators while the prose writes 34,964,352 everywhere. I counted digits to check they match. | Note in the prose that the raw output omits separators. |
| Reading the results, "the nine summary cards and the three sparkline charts" | "Sparkline" is a new word and is not glossed here. I am told the previous chapter covers it, but I am reading this chapter cold. | Gloss sparkline once in this chapter. |
| Reading the results, "the Length Dist. sparkline is a single spike" | I could not tell whether a single spike is good or bad. The sentence says it is what untrimmed data looks like, not whether I should be pleased. | Say a single spike is expected and healthy here. |
| Which path served your download, the section title | I could not tell whether this section is a step I must perform or only information. It sits between the results and the troubleshooting like an instruction. | Label it as background. |
| Which path served your download, table row "When it fires" | "Fires" for a fallback starting was hard. In my first language that verb belongs to guns. | Use "when it is used". |
| Which path served your download, "selectedStrategy read ena-direct and each..." | I do not know what curl is, and I do not know where to look to read `selectedStrategy`. The sidecar is named but never located. | Say where the provenance sidecar sits inside the bundle. |
| Troubleshooting, "a partial file or an HTTP 429 in the log" | I do not know what HTTP 429 means, and I do not know which log to open. | Say 429 means too many requests, and name the log. |
| Troubleshooting, "since a failed download row carries no retry control" | I read this twice. I think it means there is no Retry button, but it is said in a negative shape. | Say there is no Retry button, so start the download again. |
| Troubleshooting, "after requesting a free key from your NCBI account" | I have no NCBI account, and the chapter never says whether the main procedure needs one. | Say the key is optional and only for heavy use. |
| Troubleshooting, "or to Interleaved when a single file holds both mates" | "Interleaved" and "consecutive records" together stopped me. I would not know how to discover my file is interleaved. | Say interleaved means the two mates alternate inside one file. |
| On the command line, "Every fetch subcommand also takes --format..." | Nine flags in one sentence. I skipped it, as the section allowed, but the sentence is very dense for anyone who does not skip. | Break it into a short list. |
| On the command line, "named .lungfish-provenance.json and placed in..." | A filename beginning with a dot. My file browser does not show these and I did not know that. | Say a leading dot means the file is hidden. |
| Reaching ENA directly, "so most people never call the mirror by name" | After a whole section explaining that ENA is preferred, this says I never need it. I was confused about whether the earlier section mattered. | Say this subsection is for inspection only. |
| Reaching ENA directly, "its File Size of 28.1 MB is the honest figure" | "Honest figure" reads as though one archive is lying. I read it twice before seeing it means the delivered size. | Say it counts the files as they arrive. |

Three closing lines.

The one thing I learned. The archive stores four levels of accession, and
only the run level, beginning SRR, ERR, or DRR, gives you FASTQ files you
can download.

The one thing I still could not do. Find `SRR32909537` inside a results
list drawn from a study of 238 near-identical runs, because the list has
no sorting and no search inside it, and the chapter tells me to tick that
one row without saying how to reach it.

The sentence I liked most. "Provenance is the record of where a file came
from and what was done to it."
