# Reader report: Alignment Quality

Reader 2. Senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "An alignment that holds the right..." | I do not know what "the right number of reads" would be, so the sentence opens on a standard I cannot picture. | Say what a finished mapping run gives you before saying what it is not. |
| What it is, "LGE reports an average of that..." | "Read stack" and "alignment viewport" arrive with no gloss. I pictured a pile of paper. | Gloss read stack at first use. |
| What it is, "Depth is what a variant caller..." | "Spends" for a number confused me. Depth is not currency and I read this twice. | Use a plain verb for what the caller does with depth. |
| What it is, "Ten reads showing the same change..." | Weak and comfortable are given with no middle. I do not know what twenty-five is. | Give the boundary, not two anecdotes. |
| What it is, "LGE runs `samtools markdup` for this..." | I have never run a program from a name like that and do not know if I need to install it. | State that LGE runs it for you and you install nothing. |
| What it is, "MAPQ is the mapper's own estimate, on a Phred-like scale" | Phred is not glossed. I have heard the word next to fastq files and could not use it here. | Gloss Phred-like, or drop it and say what the scale means. |
| What it is, "A MAPQ of 60 is the usual maximum" | If 0 to 255 is the range in Settings, I could not work out why 60 is the top. | Say the mapper never issues higher, not that 60 is the maximum. |
| Why you would do this, "A caller reading a region at 3x depth" | 3x appears with no earlier mention of x as a unit. I inferred it from 44.7x later. | Define the x notation the first time depth is given a number. |
| Why you would do this, "calls a variant that actually belongs to a paralogous copy" | Paralogous is not glossed and it is doing the whole work of the sentence. | Gloss paralogous, or say "a near-identical copy elsewhere". |
| Why you would do this, "In a shotgun library the DNA is fragmented..." | I do not know which kind of library my own samples are. Nothing tells me how to find out. | One line on where to check which protocol produced your reads. |
| Why you would do this, "The HG002 slice used in this chapter is a PCR-free shotgun library" | PCR-free is new here and it matters for every threshold later. | Gloss PCR-free where it first appears. |
| Before you start, "Download the reference file..." | Three files with long names and a GitHub link. I did not know whether to unzip the .gz files. | Say to leave the .gz files compressed. |
| Before you start, "No extra tool pack is needed beyond..." | "Tool pack" is a term I have not met in this chapter and I did not know whether I had one. | Name where a tool pack is seen in the app. |
| Procedure, read stats, "Click the alignment track in the sidebar." | I could not tell an alignment track from any other sidebar row on my own screen. | Say what icon or section the alignment track sits under. |
| Procedure, read stats, "**Chromosomes** counts the reference sequences the file's header names" | "The file's header" is not explained and I do not know which file. | Say which file has the header. |
| Procedure, read stats, "On the HG002 slice these read 90,990, 213, 99.8%, 1, and 44.7x." | Five bare numbers in a row with no labels. I had to count back to the definitions to map them. | Pair each number with its label. |
| Procedure, read stats, "Counts that failed the instrument's own quality check are shown separately in orange" | I do not know what the instrument's quality check is or whether a nonzero orange count is bad. | Say what to do if the orange count is large. |
| Procedure, read stats, "A single contig soaking up nearly all the reads is a sign..." | Contig is used here but glossed nowhere I could find. | Gloss contig at first use. |
| Procedure, mark duplicates, "Switch the Inspector to the View tab and open the Analysis section" | Three nested places at once and I lost track. The Inspector was on Bundle in step 1. | Number the tab moves as separate clicks. |
| Procedure, mark duplicates, "It processes every alignment track in the bundle" | I could not tell whether this would ruin other tracks I care about. | Say plainly whether marking can be undone. |
| Procedure, mark duplicates, "the old unmarked track entries are gone from the bundle" | This alarmed me. Are the original reads deleted or only the sidebar rows? | Say the original BAM file is or is not kept on disk. |
| Procedure, filtered alignment, "Stay on the Analysis section's **Filtering** tab and scroll past the divider" | This step is a paragraph, not numbered like the two sections above it. I lost my place twice. | Number these steps like the others. |
| Procedure, filtered alignment, "leave the two keep toggles on, raise..." | The settings are described "below", so I had to jump forward and come back. | Give the four values inline here in a short list. |
| Procedure, filtered alignment, "compare the two separately under **View > Alignment**" | I do not know what comparing two tracks looks like or what I would be looking for. | Say what a good comparison shows. |
| Procedure, export, "writes a sibling `.lungfishref` bundle" | Sibling and .lungfishref are both unexplained. I did not know where the file would appear. | Say it lands in the same folder. |
| Settings, Starting Alignment, "On the command line this is `--alignment-track`." | Every setting ends with a command-line flag. I have never opened a terminal and could not tell if I was meant to skip these. | One line saying the flags are only for the command-line section. |
| Settings, Minimum alignment confidence, "using a stepper that runs from 0 to 255" | 255 versus the earlier "60 is the usual maximum" looked like a contradiction. | Say values above 60 exist but are never issued. |
| Settings, Duplicate handling, "choose Remove duplicate reads when it has not, since Remove runs..." | Hide versus Remove read the same to me at first. The difference took three passes. | Say Hide keeps them in the file and Remove does not. |
| Settings, Minimum identity to reference, "Set it around 95 when you want to shed clearly foreign reads" | I do not know how 95 relates to MAPQ 20. Two different numbers filtering the same reads. | Say the two thresholds measure different things. |
| Reading the results, "Total Mapped of 90,990 ... counts alignment records rather than reads" | Records versus reads is the crux and it is introduced eight paragraphs after both words were already used loosely. | Distinguish record from read the first time either appears. |
| Reading the results, "The Flag Statistics list reports 91,203 records in total against 91,148 primary" | Six numbers in four sentences with subtraction between them. I could not follow which came from where. | Lay the arithmetic out as a short table. |
| Reading the results, "which is a coincidence of this fixture rather than the same fraction written twice" | I could not tell why I was being warned about a coincidence, or what I should take from it. | Say what the reader should do with this, if anything. |
| Reading the results, "That sits inside the 30x to 50x band a human genome project usually aims for" | This is the first stated target band and it arrives after I already judged 44.7x on my own. | Give the target band where depth is first defined. |
| Reading the results, "Out of 91,148 paired reads that is 99.19%." | Earlier 91,148 was the number of reads imported. Now it is paired reads. I could not tell if these are the same. | Say whether every imported read was paired. |
| Reading the results, "by turning off Include duplicate-marked reads in the View Settings" | View Settings has not appeared before and I did not know where to find it. | Say where View Settings lives. |
| Reading the results, "the mean depth over the slice is 44.72x ... and 43.90x once..." | Est. Coverage was 44.7x and mean depth is 44.72x. I could not tell if these are the same measurement. | Say whether Est. Coverage and mean depth are the same number. |
| Reading the results, "A shotgun library where excluding duplicates costs a fifth of the depth" | "A fifth of the depth" as a threshold, when everything else was a percent. I had to convert. | Give it as a percent like the other thresholds. |
| Reading the results, "the remaining 144 were mapped, primary, non-duplicate reads whose MAPQ fell below 20" | Later the chapter says 401 records fall below MAPQ 20. I could not reconcile 144 with 401. | Say why the two low-MAPQ counts differ. |
| Reading the results, "Its Mapped % is 100.00%, which it has to be once unmapped reads are gone" | I understood the arithmetic but not why I would still look at the panel at all. | Say which figure replaces Mapped % in a filtered track. |
| Reading the results, "A filtered track's BAM is written into the bundle under `alignments/filtered/`" | I do not know how to look inside a bundle from the app, and I would not go hunting in Finder. | Say whether the reader ever needs to open these folders. |
| Reading the results, "alongside its `.bai` index and a `.stats.db` metadata database" | Neither extension is explained and I did not know if I needed to keep them. | Say these are managed for you. |
| What good looks like, "the answer is more sequencing rather than a cleverer filter" | This is advice I cannot act on. Nothing says how much more sequencing. | Say roughly how much more, or that it is a conversation with the core. |
| What good looks like, "Depth is an average, so also check coverage breadth and the coverage curve" | I do not know how to read the coverage curve for low regions, and the earlier section did not show me. | Point to where reading the curve is taught. |
| What good looks like, "A rate above 80% on amplicon data means nothing at all went wrong" | I read this three times. The double negative plus "nothing at all" made it sound like a failure. | State it positively. |
| What good looks like, "87,759 of 91,203 records carry the maximum MAPQ of 60 and only 401 fall below 20" | 96% at MAPQ 60 is given as good, but no threshold tells me when the share is too low. | Give a share below which to worry. |
| On the command line, "Every step above has a command-line form" | The whole section assumes a terminal I have never opened, and nothing says I may skip it. | One line saying this section is optional. |
| On the command line, "It replaces the input BAM with the marked version and writes no separate output" | This is the scariest sentence in the chapter and it sits in the section I would skip. | Put the overwrite warning in the Procedure too. |
| Next, "Continue to Viral Recon Wizard ... for an end-to-end amplicon pipeline" | The chapter told me marking is wrong for amplicon data, so being sent to amplicon next confused me. | Say the next chapter handles duplicates differently for that reason. |

One thing I learned. PCR duplicates are copies of one original DNA fragment that a variant caller would otherwise count as separate pieces of evidence, so flagging them keeps the confidence honest.

One thing I still could not do. Decide whether my own samples are shotgun or amplicon, which the chapter says decides everything about duplicate marking but never tells me how to find out.

The sentence I liked most. "Marking on amplicon data throws away the run."
