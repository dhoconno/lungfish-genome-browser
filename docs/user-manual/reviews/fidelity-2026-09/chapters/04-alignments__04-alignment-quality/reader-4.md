# Reader report: Alignment Quality

Persona: undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is: "Do you have enough reads over..." | Three questions are asked in one paragraph and then answered in three separate paragraphs, but nothing labels which paragraph answers which question. I had to read the block twice to line them up. | Number the three questions so the answers can be matched to them. |
| What it is: "LGE reports an average of that..." | I do not know what "the per-position curve above the read stack" looks like or where the alignment viewport puts it. In Geneious the coverage graph was a labelled row. | Name the on-screen element, for example "the Coverage track above the reads". |
| What it is: "Ten reads showing the same change is..." | "Forty is comfortable" gives me a good number but never says what happens between ten and forty. Is twenty acceptable? | State the threshold as a range with a cutoff rather than two example values. |
| What it is: "MAPQ is the mapper's own estimate..." | "Phred-like scale" is used without a gloss and it is not in the glossary list at the top. I know Phred from a lecture on quality scores but not what "Phred-like" changes. | Gloss "Phred-like scale" at first use the way depth and MAPQ are glossed. |
| What it is: "A MAPQ of 60 is the usual maximum" | If 60 is the maximum but the stepper later runs to 255, I could not tell whether values above 60 exist. | Say that mappers cap MAPQ well below the field's limit. |
| Why you would do this: "calls a variant that actually belongs to a paralogous copy" | "Paralogous" is not defined anywhere and is not in the glossary list. | Gloss paralogous at first use. |
| Before you start: "Download the reference file GRCh38.chr20..." | Downloading three files from a GitHub folder link is not a step I could perform from the text alone. I did not know whether to click each file and find a download button or fetch the whole folder. | Say how to download a single file from that page. |
| Before you start: "No extra tool pack is needed beyond..." | I do not know what a "tool pack" is or how I would check which one mapping installed. | Gloss tool pack, or drop the sentence. |
| Before you start: "One thing to know before you start" | The sentence says LGE holds a lock on a bundle, but "bundle" alone appears here while the glossed term two sections earlier was "reference bundle". I could not tell if they are the same thing. | Use the glossed term consistently. |
| Read the alignment statistics, step 1 | "The Inspector's Bundle tab" assumes I know where the Inspector is and that it has tabs. Nothing in this chapter says how to open the Inspector if it is closed. | Add the menu path or shortcut that shows the Inspector. |
| Read the alignment statistics, step 2 | The five numbers are given for the fixture but I cannot tell which ones I should worry about. 213 unmapped sounded like a lot until I did the division myself. | Say what a bad value looks like for each figure, not only the fixture's value. |
| Read the alignment statistics, step 4 | "the flag bits on every record" is unexplained. I do not know what a flag bit is, and `primary`, `properly paired`, and `supplementary` are named as rows that matter without saying what they mean. | One sentence saying a flag bit is a yes or no marker stored on each read. |
| Read the alignment statistics, step 4 | "Counts that failed the instrument's own quality check are shown separately in orange" left me unsure whether I should care about the orange number or ignore it. | Say whether a non-zero orange count is a problem. |
| Read the alignment statistics, step 5 | "A single contig soaking up nearly all the reads is a sign..." but step 3 says the fixture has 1 chromosome, so I could not tell if my own single-contig case was the bad case or the normal one. | Say this check applies only when the reference holds many sequences. |
| Mark duplicates, step 1 | "Switch the Inspector to the View tab and open the Analysis section, then click its Filtering tab" is three nested places and I lost track of which level I was on. | Give the path as one line with separators. |
| Mark duplicates, step 4 | "the old unmarked track entries are gone from the bundle" alarmed me. I could not tell whether my original reads were destroyed. | Say plainly whether the original BAM file still exists on disk. |
| Derive a filtered alignment | This whole section is prose with no numbered steps, unlike the two sections before it. I lost my place between picking the alignment, setting filters, and naming the output. | Number these steps like the other procedures. |
| Derive a filtered alignment: "compare the two separately under View" | I could not work out how to display two alignment tracks side by side, which is what "compare" made me expect. | Say what comparing actually means here. |
| Settings: "Keep one primary alignment per read" | The entry defines secondary and supplementary alignments inside one long sentence with two glossary links, and I read it three times before seeing they were two different things. | Split the definitions into two sentences. |
| Settings: "Minimum alignment confidence" | The stepper runs 0 to 255 but the text only ever recommends 20 and says 60 is the usual maximum. I did not know what setting it to 200 would do. | Say that values above about 60 keep nothing. |
| Settings: "Duplicate handling" | Hide versus Remove confused me. Both sound like the read is gone from the result. | Say whether Hide leaves the read in the output file. |
| Reading the results: "The Flag Statistics list reports 91,203..." | This paragraph does four subtractions in a row and I could not follow which number came from where. I gave up midway. | Put the arithmetic in a small table. |
| Reading the results: "which is a coincidence of this fixture..." | I did not understand why the author was pointing out a coincidence or what I was supposed to do about it. | Say what the reader should check instead. |
| Reading the results: "Out of 91,148 paired reads that is" | Earlier 91,148 was called the number of reads imported, and here it is called the number of paired reads. I could not tell if these are the same thing. | Keep one label for this number. |
| What duplicate marking changed: "by turning off Include duplicate-marked reads" | I did not know View Settings existed or where to find it, so I could not check this or undo it. | Say where View Settings lives. |
| What duplicate marking changed: "Measured directly on the fixture, the mean" | I do not know how the author measured mean depth, so I could not reproduce 43.90x myself. | Say which screen or command reports mean depth. |
| What filtering changed: "leaves 89,107 records out of 91,203" | The four dropped categories are said to account for themselves exactly, but I only trusted that after adding 213, 55, 1,684, and 144 by hand. | Show the sum. |
| Where the outputs land: "alongside its .bai index and a" | I do not know what a .bai or a .stats.db is, or whether I ever need to touch them. | Say these are companion files the app manages. |
| What good looks like: "also check coverage breadth and the" | Coverage breadth is glossary-linked but the chapter never says where LGE displays it, so I could not perform this check. | Name where breadth is shown. |
| What good looks like: "On the HG002 slice, 87,759 of" | I could not find where in the app I would see this MAPQ breakdown. It is quoted like a number I should be able to read off a screen. | Say where the MAPQ distribution appears. |
| What good looks like: "A rate above 80% on amplicon" | I had to read this twice. The phrasing sounds at first like a warning and then turns out to be reassurance. | Restate as a positive. |
| On the command line: "Every step above has a command-line" | I have never opened a terminal, so I could not tell whether this whole section is optional for me. | Add a line saying the section is for scripted runs. |
| On the command line: "It replaces the input BAM with" | This contradicts the earlier promise that LGE never edits the source alignment. I could not tell which behaviour applies to me. | Flag the difference from the app behaviour explicitly at that point. |
| On the command line: "The same command exists as lungfish-cli" | I could not tell which of the two forms I should use. | Recommend one. |
| On the command line: "--bundle and --mapping-result are alternatives, and" | A mapping result appears here for the first and only time with no explanation of what it is. | Gloss mapping result or drop the flag. |
| On the command line: "One more bam subcommand belongs in" | Annotate is introduced at the very end with no procedure and no place in the app, so I did not know whether it was something I should have done. | Say whether this has an equivalent in the app. |

One thing I learned. Marking duplicates does not delete any reads and does not change the coverage number, so the depth figure I read after marking is still counting reads I had decided not to trust.

One thing I still could not do. I could not derive a filtered alignment from the text alone, because that section drops the numbered steps and I could not find the Inspector's Analysis section from the instructions given.

The sentence I liked most. "A MAPQ of 0 means the read fits two or more places equally well, so its position is a coin flip and any variant it supports is unreliable."
