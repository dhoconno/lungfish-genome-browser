# Reader 1 report, Sequencing Reads

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A sequencing read is one fragment" | I do not know how a fragment of DNA becomes a string of letters. The chapter starts after the step I am missing. | One sentence saying the instrument reads bases in order and writes down its best guess. |
| What it is, "Reads arrive in a FASTQ file" | "Plain-text format" is not explained. I do not know whether I could open it in Word. | Say plain text means readable characters, openable in any text editor. |
| What it is, "The HG002 chromosome 20 slice" | I do not know what HG002 is here. It gets explained one section later, but I met it first here. | Gloss HG002 at this first mention, not in the next section. |
| Why you would do this, "A variant call is a claim that" | I have never seen a variant call. Three unexplained outputs arrive in three sentences, variant call, assembly, classification. | A half sentence each saying what those three outputs are. |
| Why you would do this, "the reference at one position" | "Reference" is used with no gloss. I think I know it from lecture but I am guessing. | Gloss reference the first time it appears. |
| Why you would do this, "Reads for both fixtures are cited" | The line shows template code in curly braces rather than a sentence. | Replace it with the actual citation text. |
| Before you start, "choose File > New Project (Cmd-N)" | I did not know what a project is or why reads need one. | One clause saying a project is the folder where LGE keeps your data and results. |
| Before you start, "Download the files HG002.chr20" | The GitHub link plus two long filenames is a lot, and I do not know how to download one file from GitHub. | A short note on how to save a single file from that page. |
| Before you start, "Nothing here needs a plugin pack" | I do not know what a plugin pack or Docker Desktop is, so this reassurance means nothing to me. | Say these are extra installs that some later chapters need. |
| The four-line FASTQ record, "Here is the second record in" | Why the second record and not the first? I wondered whether the first one was special. | Say the choice is arbitrary, or use the first record. |
| The four-line FASTQ record, "its colon-separated fields name the instrument" | Six things are listed with no explanation of flow cell, lane, tile, or cluster. I could not picture any of them. | Since the text says you never need it, cut the list or gloss flow cell and tile. |
| The four-line FASTQ record, "occasionally N, the letter for" | The gloss is there, but I did not know whether an N counts as an error or as missing data. | Say N means no call was made, which is different from a wrong call. |
| The four-line FASTQ record, "because a quality character can look" | I could not see why that matters until the Phred section two headings later. | Point forward to the Phred section here. |
| Compressed FASTQ files, "compressed with gzip, a general-purpose lossless" | I do not know how to unzip a .gz file on a Mac, and the section ends by telling me to look inside one. | Say double-clicking expands it, or say you never need to. |
| Compressed FASTQ files, "hold 22,662,846 bases between them" | I could not judge whether that is a lot. It is a bare number with nothing to compare it to. | Compare it to the size of the region the reads came from. |
| Paired-end reads, "runs inward to meet it" | The word "meet" made me think the two reads always touch. A later paragraph says they may not. | Say they run toward each other and may or may not overlap. |
| Paired-end reads, "The SRA convention writes the suffix" | SRA is never expanded. I do not know what it is. | Expand SRA at first use. |
| Paired-end reads, "which is why the two records printed" | I was confused that both mates share one header, because I had just been told no two reads share a header. | Say the uniqueness rule is per file, so the shared header is what links the mates. |
| Paired-end reads, "in the R2 file, 249 bases" | Why 249 and not 250? I read this twice looking for the reason. | One clause saying mates need not be the same length. |
| Paired-end reads, "a variant caller counts a pair as" | I could not follow why counting both mates would be dishonest. | Say counting both would double count one fragment of evidence. |
| When the mates overlap, "which is common in amplicon libraries" | Amplicon library is not glossed here. | Gloss amplicon, or drop the example. |
| When the mates overlap, "uses bbmerge for it" | I do not know what bbmerge is or whether I have to install it. | Say it is a bundled tool that LGE runs for you. |
| Interleaved FASTQ, "several read processors accept it" | "Read processors" is vague. I could not tell which tools or why I would care. | Name one tool, or say when a downstream tool asks for this shape. |
| Phred quality scores, "It is defined as Q equals minus ten" | I have not used log10 since high school and could not invert it to check the table myself. | Say the table is the practical form and the formula is optional. |
| Phred quality scores, "offset by 33, a convention called" | I do not know what ASCII is, and the whole decoding paragraph rests on it. | One clause saying ASCII is the number that stands for each keyboard character. |
| Phred quality scores, "and D is ASCII 68, so those" | The arithmetic is left implicit, so I could not reproduce it on the next character. | Show 68 minus 33 equals 35 once. |
| Phred quality scores, "about a 1-in-3,000 chance of being" | The table jumps in tens. I do not know how to get 1 in 3,000 out of Q35. | Say Q35 falls between the Q30 and Q40 rows on a smooth scale. |
| Phred quality scores, "fastp, BWA-MEM2, and minimap2, do" | Three tool names with no gloss. I do not know what any of them do. | Say they are the trimming and alignment tools LGE runs underneath. |
| Read length and platform differences, "Q12 to Q20 simplex, Q30+ duplex" | Simplex and duplex are not explained anywhere in the chapter. | Gloss both, one clause each. |
| Read length and platform differences, "spans about 1.5% of the 16,569 bp" | The mitochondrial genome arrives with no warning in a chapter that was about chromosome 20. | Say the long-read fixture is mitochondrial, so the comparison uses that genome. |
| A nanopore read, "The header is a plain UUID rather" | UUID is not expanded or explained. | Say it is a randomly generated unique name. |
| A nanopore read, "roughly a 1-in-5 chance of being wrong" | Q7 to 1 in 5 is another jump I cannot make from the table. | Give the rounded arithmetic, or point back to the formula. |
| A nanopore read, "reach an N50 of 10,615 bases, meaning" | The gloss is there, but I could not work out why it is half the bases and not half the reads. | Add one sentence on sorting the reads longest first. |
| A nanopore read, "the errors are largely independent between" | I could not tell why independence is what makes stacking work. | Say independent errors cancel out when reads vote at each position. |
| A HiFi read, "which decodes to Q93" | Q93 is far past the table, which stops at Q40. I thought I had made an arithmetic error. | Say the scale runs past Q40 for consensus values. |
| A HiFi read, "the HiFi reads average Q29, with" | An average of Q29 sitting beside a quality string full of Q93 looked contradictory to me. | Say the shown characters are the high end and the average includes weaker bases. |
| How LGE shows a read set, "Click a FASTQ bundle in the sidebar" | I never learned what a bundle is or how one gets into the sidebar. | Gloss bundle as LGE's container holding the paired files together. |
| How LGE shows a read set, "one summary bar and one sparkline strip" | Sparkline is not glossed. | Say it is a small chart drawn without axes. |
| How LGE shows a read set, "GC is the percentage of bases" | I know GC content from lecture but not what a good or bad value is here. | Give a typical human range. |
| How LGE shows a read set, "It loads the first 1,000 records" | I could not tell whether the summary cards also use only the first 1,000 reads. | Say the cards scan the whole bundle and only the table is windowed. |
| What good looks like, "and a viral amplicon sample needs" | Viral amplicon has not been introduced, and I am reading a human chapter. | Move this example later or gloss it. |
| What good looks like, "averages 248.6 bases with 90.8% of" | I did not know whether a minimum of 50 bases is a problem. | Say the shortest reads are the trimmed ones and are expected. |
| What good looks like, "a mean depth of 44.7x with 99.77%" | I did not know what the x in 44.7x means. | Say it means each base is covered about 45 times on average. |
| What good looks like, "which is comfortable for calling small variants" | "Small variants" is unglossed, and I do not know what depth would be uncomfortable. | Give a rough minimum depth number. |

The one thing I learned: a FASTQ file is only four lines per read, and the fourth line carries exactly one confidence character for every letter on the second.

The one thing I still could not do: decode a quality character by hand, because the chapter assumes I already know what ASCII codes are.

The sentence I liked most: "One read is a short, noisy guess at what one piece of your sample said."
