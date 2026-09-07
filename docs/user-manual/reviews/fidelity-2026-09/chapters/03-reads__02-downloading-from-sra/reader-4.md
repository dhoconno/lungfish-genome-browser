# Reader report: Downloading Reads from the SRA

Reader 4. Undergraduate. I used Geneious in one class, where I clicked a button that said NCBI and things appeared in a folder. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The archive nests four kinds" | I had to read the paragraph twice to see that SRR, SRX, SRS, SRP are one nesting, smallest to largest. It reads as four separate facts. | Say the four go from smallest to largest before listing them. |
| What it is, "and only one of them" | I could not tell whether pasting an SRP into the search box is an error or just gets me a list. In Geneious I paste whatever accession the paper prints. | Say what happens if you paste an SRP. |
| What it is, "A run accession begins SRR" | Three prefixes with no explanation of why one thing has three spellings. I wondered whether ERR meant something was wrong. | One clause saying they are the same thing from three archives. |
| What it is, "which opens the Database Browser" | I did not know what a pane is versus a window or a tab. The next sentence says the window holds three panes, which helped only after I was already lost. | Gloss pane at first use. |
| What it is, "then runs the same import" | The Import Center has not been mentioned before this. I do not know whether it is a window, a menu, or a background thing. | Name it as a place, or drop the mention. |
| What it is, "each run lands as a" | I do not know whether a bundle is one file or a folder. Later the chapter says the sidecar sits inside the bundle, which suggests a folder, but the .lungfishfastq ending suggests a file. | Say which it is. |
| Why you would do this, "This run is 115,776 read" | I could not judge whether 115,776 pairs is a lot or a little. The chapter says it behaves like a real dataset, which is reassuring but is not a number I can reason with. | Say what a typical amplicon run of this kind holds. |
| Why you would do this, "34,964,352 bases in total, and" | I tried to check this against 115,776 and 151 and got a number twice too big before I realised pairs count twice. That trap is only explained much later. | Move the spot-versus-read explanation up to here. |
| Before you start, "Nothing here needs a plugin" | Two things I have never heard of, dismissed in one clause. I could not tell whether I should go install them anyway to be safe. | Say only that no extra software is needed. |
| Procedure 1, "A query field sits at" | I looked for something labelled and there is nothing to look for. I could not be sure I had found the right control until the Settings section explained it many paragraphs later. | Say what the popup reads by default so I know what to look for. |
| Procedure 2, "Click Show on the Advanced" | I did not know whether Show is a button, a link, or a triangle. In Geneious that kind of thing is a disclosure arrow. | Name the control type. |
| Procedure 3, "Type Homo sapiens mitochondrion into" | Nothing connects the query words to the filters, so I did not understand why a mitochondrion search returns an amplicon run. | One clause on why that query. |
| Procedure 3, "The results list fills with" | I do not know how long to wait or what an empty list would mean. Nothing says what a search in progress looks like. | Say roughly how long, and what an empty list means. |
| Procedure 4, "Tick SRR32909537 in the results" | With Max Results at 50 and 238 runs in the study, I did not know whether my target would even be on the page, or how to find it if it were row 40. | Say where in the list it appears, or how to narrow to it. |
| Procedure 5, "Confirm those two settings and" | Confirm how. I did not know whether there is a checkbox to tick or whether confirm just means look at them and proceed. | Say that reading them is all that is required. |
| Procedure, "Watch the progress in the" | I had no idea how to open the Download Center. It is a glossary link, not a menu path, and the chapter never says where the window is. | Give the menu path. |
| Procedure, "Click it once to open" | Once, and not twice, is emphasised, which made me think a double click breaks something. | Drop once, or say what a double click does. |
| Downloading a list, "Click Import Accessions on the" | I do not know the layout the file needs. One accession per line, or commas, or a header row. | Show two lines of an example file. |
| Settings, "All seven shape the search" | I read this three times. It took a while to see that it means the filters cannot change the file you get, only which files you see. | Say it that way. |
| Settings, Platform, "Keeps only runs produced on" | Six instrument names I have never seen and cannot rank. I did not know whether picking the wrong one loses my run. | Say that anything other than Illumina is long read or rare. |
| Settings, Strategy, "Keeps only runs whose library" | WXS is never expanded, though WGS and AMPLICON are. I first assumed it was a typo for WGS. | Expand WXS the way WGS is expanded. |
| Settings, Strategy, "Set it to AMPLICON when" | Tiled primer scheme means nothing to me and is not glossed here. | Gloss it or cut it. |
| Settings, Min Size, "Drops runs that produced less" | I could not convert this to anything I know. The example run is 34,964,352 bases, so is that 35 here. I had to work it out myself. | Give the example run's own value in Mbases. |
| Settings, Min Size, "Set it to exclude runs" | Depth has not been defined in this chapter and I do not know what depth my analysis needs. | Point to where depth is explained. |
| Settings, Max Results, "On the command line this" | Two different defaults for what I read as one setting made me think I had misread one of them. | Say plainly that the two interfaces differ on purpose. |
| Settings, "(search scope). Restricts the query" | The heading is a bracketed lowercase phrase, unlike the six bold names above it, so I first took it for a footnote rather than a setting. | Give it a name like the others. |
| Reading the results, "Each row in the results" | The row calls it length in bases, but the command-line table calls one column Size in MB and another Reads. I could not line the two up. | Say which table column the list's number matches. |
| Reading the results, "The list is not a" | Coming from Geneious, where I sort by clicking a header, I read this as a defect and wondered whether I had an old version. | Say it is a list by design. |
| Reading the results, "Read that Reads column carefully" | Spot is the hardest word in the chapter. It is defined in the next clause but it is not in the glossary list at the top, so I could not look it up again later. | Add spot to the glossary. |
| Reading the results, "The Size column is the" | I could not tell whether a mismatch between the promised and the actual size is normal or a sign something went wrong. | Say the mismatch is expected every time. |
| Reading the results, "For this run it printed" | I counted fourteen lines, then twelve, then thirteen. Counting fields was not a good use of my attention and I still do not know why it matters. | Drop the count. |
| Reading the results, "Source : GENOMIC" | GENOMIC appears in the output but nowhere in the Settings section, so I do not know what it means or whether I can filter on it. | Gloss Source in one clause. |
| Reading the results, "Its FASTQ viewport shows the" | I do not know what a sparkline is and it is not glossed. | Gloss sparkline. |
| Reading the results, "For this run every read" | I could not tell whether a single spike is good news or a warning. The sentence says it is what untrimmed looks like, but not whether I want that. | Say whether a spike here is expected and fine. |
| Reading the results, "Its metadata sidecar records the" | I could not find where to look at any of this. The sidecar is named but never opened. | Say how to view the sidecar, or that you do not need to. |
| What good looks like, "fetch sra info reported 115.8K" | This asks me to do a conversion in my head without giving me the number to expect. I know 115.8K spots and 231,552 reads, but not which the card shows. | Print the number the card shows. |
| What good looks like, "A bundle half the expected" | Half of what. I never learned the expected size of a bundle, only the size of the two downloaded files. | Give the expected figure. |
| Which path served, "The two paths produce equivalent" | Machinery underneath told me nothing concrete and I skipped ahead hoping the table would say it. | Cut the phrase and let the table speak. |
| Which path served, table row "Tools involved" | Two program names with no indication of whether I need to install them. Troubleshooting says later that the toolkit needs them, but the table does not. | Say in the table that these need installing. |
| Which path served, "For the download this chapter" | I do not know what curl is, where selectedStrategy is written, or how I would look at either. | Say I do not need to read this unless a download fails. |
| Troubleshooting, "The symptom is a download" | I do not know where the log is or how to open it. | Give the path to the log. |
| Troubleshooting, "Wait a few minutes and" | I read this twice. It seems to mean there is no Retry button, so I must start over, but it is phrased as a reason rather than an instruction. | Say there is no Retry button and to start again from the pane. |
| Troubleshooting, "An NCBI API key lifts" | This fixes a problem I hit in the dialog, but the only fix given is a terminal command, which I cannot run. | Say whether the app itself can hold an API key. |
| Troubleshooting, "The fix is to set" | Consecutive records assumes I know a FASTQ is made of records. I could not picture the file. | Say the two mates alternate down the file. |
| Troubleshooting, "The run page on NCBI's" | I do not know how to reach that page from a run accession. | Give the address pattern. |
| On the command line, "This section is optional. If" | Reassuring, but two of the fixes in Troubleshooting exist only here, so skipping it costs me those fixes. | Say which dialog problems need this section. |
| Reaching ENA directly, "Note that its File Size" | Three sizes now exist for one run, 23 MB, about 28 MB, and 28.1 MB, and I lost track of which to trust. | State once which figure is the true one. |
| Reaching ENA directly, "For a reference that needs" | FASTA appears here for the first time, right after a chapter about FASTQ, and I confused the two. | Say FASTA is the sequence format and not the read format. |

Learned: an SRA search returns runs, and only a run accession, the one starting SRR, ERR, or DRR, is the thing you can actually download.

Could not do: find and open the Download Center to watch my download, because the chapter tells me to watch it there but never says where it is.

Liked most: "Download it once and the bundle is yours to reuse."
