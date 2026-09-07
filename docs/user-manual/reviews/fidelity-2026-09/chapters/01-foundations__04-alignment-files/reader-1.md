# Reader 1 report, Alignment Files

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "BAM is the compact binary form" | SAM is named but never defined. I do not know if SAM is a file I would ever see or just a concept. | One sentence saying what SAM stands for and that I will never handle one directly. |
| What it is, "Lungfish Genome Explorer reads and writes BAM" | `samtools` is set in code font and called a toolkit, but I do not know if it is something I install, click, or ignore. | Say it runs invisibly and I never launch it myself. |
| What it is, "Where a single reference sequence" | "too long for BAI to address" means nothing to me here. The 512 megabase number only appears four sections later. | Give the size limit at first mention instead of later. |
| Why you would do this, "Variant calling reads a BAM." | Four sentences in a row name operations I have not met yet. I could not tell which of them I would ever do. | Name one as the thing this manual gets to next. |
| Why you would do this, "with a mapper unsuited to the read length" | I do not know what read lengths exist or what makes a mapper unsuited. | A half sentence example, such as a short-read mapper on very long reads. |
| Why you would do this, "Its reads are Illumina 2x250 paired-end" | I had to read this twice. I do not know what the 2x250 notation means or what paired-end is. | Gloss 2x250 as two reads of 250 bases from opposite ends of one fragment. |
| Before you start, "a project holding a reference bundle" | Reference bundle and alignment track are both new. I could not find these in the app from this text. | One sentence each saying what those two things are in LGE. |
| Before you start, "the demo project's `chr20 10.0-10.5Mb`" | I do not know how to open the demo project or whether it is already there. | A pointer to where the demo project lives. |
| Before you start, "Docker Desktop is not needed anywhere" | Docker Desktop is mentioned only to be dismissed, which made me wonder whether I was supposed to have installed it. | Drop it, or say it is needed in later chapters only. |
| What one row records, "a handful of optional tags" | Optional tags are named and then never explained or used. | Say they can be ignored for now. |
| What one row records, "RNEXT  =" | The example block shows RNEXT, PNEXT, and TLEN, but the walkthrough afterwards covers only POS, MAPQ, FLAG, and CIGAR. I did not know whether the other three mattered. | One line saying the remaining three describe the mate and the fragment length. |
| What one row records, "on the same logarithmic scale as a Phred score" | I half remember Phred from the reads chapter but cannot turn 60 into a probability. | State what MAPQ 60 means as odds, and what 0 means. |
| The CIGAR string, "`240M9S`" | I could not work out from the text whether the 9 clipped bases sit at the start or the end. The text says "off the end" but the mate example `6S244M` implies the order carries meaning. | Say explicitly that the order of the pairs is the order along the read. |
| The CIGAR string, table row `D` | "Deleted from the read, present in the reference" reads backwards to me next to the `I` row. I read the table three times. | Phrase both rows from the same viewpoint, the read's. |
| One row is not one read, "one read spans a junction" | Junction is undefined. In my genetics course junction meant a splice site, which cannot be right for DNA. | Gloss junction here, or give the case where it happens. |
| One row is not one read, "91,203 rows, of which 91,148 are primary" | I could follow the arithmetic but not why 55 supplementary rows is a good number rather than a worrying one. | Say whether 55 out of 91,203 is normal. |
| Coverage, "one bar per screen column when you are zoomed out" | I could not picture what the bar shows when many positions share one column. Is it the mean or the highest value? | Say which value the column reports. |
| Coverage, "99.77 percent of rows mapped" | Three numbers arrive in one paragraph, 44.7 and 99.77 and 99.99, and I lost track of which measured what. | Label each number with its name in the sentence. |
| Coverage, "roughly one position in a thousand" | 505 out of 500,001 is about one in a thousand, but the chapter had just said 31 positions have no coverage. I could not see how both were true at once. | State that the 505 includes the 31. |
| Pileup, "Twenty of them show `C` and 33 show `T`" | 20 plus 33 is 53, which matches, but I expected the reference base to be the majority and it is not. That confused me until the heterozygous sentence later on. | Flag up front that the alternate can outnumber the reference. |
| Pileup, "a proportion close to the half you expect" | 0.62 is not obviously close to 0.5 to me. I did not know how much spread is acceptable. | Give the range that still counts as heterozygous. |
| Pileup, "pre-fills a minimum alternate-allele frequency of 0.05" | The next clause says 10 percent is reportable and 0.5 percent is not, which mixes decimals and percentages in one breath. | Use one unit for all three numbers. |
| Strand, "aligned its reverse complement" | Reverse complement was in my genetics course but I could not connect it to what a mapper does to a read. | One clause saying the mapper flips the read over to make it fit. |
| Strand, "Amplicon data breaks this assumption" | I did not know from here whether my own data would be amplicon or shotgun. | Say which one is the common default for this reader. |
| Reshaping, "LGE runs `samtools markdup`" | I could not tell whether this happens on its own or whether I have to ask for it. | Say whether it is a step I choose. |
| Reshaping, "some `ivar trim` options drop rows" | Which options, and where would I see them? The chapter never points anywhere. | Name the chapter that covers those options. |
| Choosing a mapper, "up to 500 bases in its standard mode" | The four mappers, their read types, and their limits arrive in one dense paragraph. I could not hold them all. | A small table of mapper, read type, and limit. |
| Choosing a mapper, "picking the right one matters more" | The claim that presets matter more than mappers is stated but not shown, so I did not know how to act on it. | One consequence of picking the wrong preset. |
| Choosing a mapper, "the read class it detects in your input" | I do not know what a read class is, or where LGE shows me the one it detected. | Gloss read class. |
| Long and short reads, "LoFreq, iVar, or bcftools" | Five caller names arrive with no explanation and no way for me to choose among the three short-read ones. | Say the choice comes later and name one as a safe default. |
| What good looks like, "A fraction below about 80 percent" | The chapter gives 99.77 as good and 80 as bad but nothing about the middle. | Say what to do with a value between them. |
| On the command line, "Paths are written as if you are in the repository root" | Repository root means nothing to me. I have never opened a terminal, and this told me nothing about where to be. | Say this section is for readers who already use a terminal. |
| On the command line, "`lungfish-cli bam` derives filtered alignment tracks" | Four different actions are packed into one sentence with no separation. | Break it into a short list. |

The one thing I learned. A BAM is not a list of reads, it is a list of alignments, and one read can appear in more than one row, which is why a row count and a read count disagree.

The one thing I still could not do. Open the demo project and find the `chr20 10.0-10.5Mb` bundle with its alignment track, because nothing tells me where the demo project lives or how a bundle and a track appear on screen.

The sentence I liked most. "Reading the coverage track before anything else is the habit worth forming."
