# Reader 3 report, Alignment Files

Persona: pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "BAM is the compact binary" | I do not know what SAM stands for. The chapter never expands it, but names a format after it. | Expand SAM at first use. |
| What it is, "so unlike a FASTQ you cannot" | FASTQ appears with no gloss and no link, while BAM and BAI beside it both get links. | Link FASTQ to the glossary here. |
| What it is, "then one row per aligned read" | I did not know a BAM had rows. I pictured a file, not a table. The word carries the whole chapter afterwards. | One sentence saying a BAM is like a table with one line per alignment. |
| What it is, "too long for BAI to address" | "address" in this computing sense was new to me. I first read it as a postal address. | Use "reach" instead of "address". |
| What it is, "Three ideas carry the rest" | I read this paragraph twice. It promises three ideas then adds a fourth instruction, so I lost the count. | Put the habit sentence in its own paragraph. |
| Why you would do this, "Primer trimming rewrites one." | Primer is not glossed, and this is a Foundations chapter. The word returns later carrying more weight. | Gloss primer at this first mention. |
| Why you would do this, "Illumina 2x250 paired-end reads" | I could not tell whether 2x250 means 500 bases total or two separate reads of 250. | Say it plainly, two reads of 250 bases per fragment. |
| Why you would do this, "a 500,001-base slice of human" | The number ending in 1 looked like a typo and I stopped to check it. | Half a sentence on why the count ends in 1. |
| Why you would do this, "the run recorded in the fixture's" | I do not know what `expected/mapping/` is or how I would look inside it without a terminal. | Say whether that folder is reachable inside the app. |
| Before you start, "the demo project's `chr20 10.0-10.5Mb`" | I could not open the demo project. The chapter assumes it is already in front of me. | Link the chapter or menu item that opens the demo project. |
| Before you start, "needs the read-mapping plugin pack" | I could not perform this step. Nothing says where packs are installed from inside LGE. | Name the menu where plugin packs are installed. |
| Before you start, "Docker Desktop is not needed" | Docker is named with no explanation. I do not know what it is or why it might have been needed. | Gloss it in three words or drop it. |
| What one row records, "a handful of optional tags" | Tags are named and never explained or used again, so I could not tell if I needed them. | Say tags are extra fields safe to ignore for now. |
| What one row records, code block with RNEXT and TLEN | Four of the nine field names in the block are never explained. I did not know whether that was deliberate. | One line naming the fields the chapter will not cover. |
| What one row records, "on the same logarithmic scale as" | I could not judge from this whether MAPQ 60 is twice as good as 30 or far more. | Give MAPQ 60 as a probability of being wrong. |
| What one row records, "The value 99 above unpacks into four" | I could not see how the single number 99 turns into four separate facts. The arithmetic is invisible. | Say each fact is a power of two added together. |
| The CIGAR string, "`240M9S`, which reads as 240" | I read it twice before seeing the pattern is number then letter, even though the sentence says so. | Show it split as `240M` plus `9S`. |
| The CIGAR string, table row for the letter D | "Deleted from the read, present in the reference" confused me about whose deletion it is. | Say the read is missing bases that the reference has. |
| One row is not one read, "spans a junction and only aligns" | I do not know what a junction is in this context, and the phrase is very compressed. | Give one concrete example of a junction. |
| One row is not one read, "91,203 rows, of which 91,148" | I had to do two subtractions myself before I trusted the paragraph. | State the 55 as an explicit subtraction. |
| The index, "BAI can only reach 512 megabases" | I do not know how long a human chromosome is, so I cannot tell if 512 megabases is generous or tight. | Compare it to the longest human chromosome. |
| Coverage, "one bar per screen column when you are" | I could not picture a screen column, nor tell whether the bar then shows a mean or a maximum. | Say which value the bar shows when zoomed out. |
| Coverage, "mean depth of 44.7 across the 500,001-base" | Three numbers arrive in one sentence, 44.7 and 99.77 percent and 79. I could not hold all three. | Split into two sentences. |
| Coverage, "coverage breadth of 99.99 percent measures" | My own arithmetic gave 99.994 percent, so I thought I had misunderstood the definition. | Say the figure is rounded. |
| Coverage, "shifts the apparent allele frequency by" | Allele frequency is used here but only glossed two sections later, where I finally understood this sentence. | Gloss allele frequency at this first use. |
| Coverage, "appears as `N` in any consensus sequence" | Consensus sequence is not glossed and I do not know what one is. | Gloss consensus sequence here. |
| Pileup, "a proportion close to the half you" | I could not tell why 0.62 counts as close to a half. It looked far from 0.50 to me. | Say what range around 0.5 still reads as heterozygous. |
| Pileup, "The Genome in a Bottle benchmark for" | Genome in a Bottle is named twice but never explained as a project or a dataset. | Gloss it in half a sentence at first mention. |
| Pileup, "a minimum alternate-allele frequency of 0.05" | The sentence mixes 0.05 with 10 percent and 0.5 percent, so I had to convert units while reading. | Use one unit through the whole sentence. |
| Strand, "reverse if the mapper aligned its reverse" | Reverse complement is not glossed. I half remembered it from genetics and was not confident. | Gloss reverse complement. |
| Strand, "In a shotgun run, where fragments are" | Shotgun is used with no gloss and no link, although a chapter about it exists. | Link the shotgun chapter at this word. |
| Steps that reshape a BAM, "flags the extras in the FLAG" | I did not understand whether a marked row is then ignored by later tools or still counted. | Say whether callers skip marked rows. |
| Steps that reshape a BAM, "the reads came from a PCR-free" | PCR-free library is new and unexplained, and it is the reason the whole sentence works. | Gloss PCR-free library. |
| Steps that reshape a BAM, "LGE's alignment-level primer trim runs" | "alignment-level" implies a second level exists, and I did not learn what it was until the last sentence. | Name both levels together in one sentence. |
| Choosing a mapper, "up to 500 bases in its standard" | I could not tell whether 500 and 6,000 are read lengths or something else. | Say these are read-length limits. |
| Choosing a mapper, "assembled contigs, and spliced RNA alignment" | Contig and spliced are both new to me and neither is glossed. | Gloss contig here. |
| Choosing a mapper, "checksums of the input reads and" | Checksum is a computing word I do not know. | Gloss checksum in three words. |
| Long reads and short reads, "ran past a contig boundary" | Contig appears a second time and I still do not know what it is. | Gloss contig at its first use. |
| Long reads and short reads, "LoFreq, iVar, or bcftools for short" | Five tool names arrive with no description, and I cannot judge which one I would need. | Name the chapter that explains the choice. |
| What good looks like, "A fraction below about 80 percent" | I could not tell whether this threshold holds for any organism or only for human data like the fixture. | Say whether the threshold is general. |
| On the command line, "Paths are written as if you" | "repository root" means nothing to me and I have never opened a terminal. | Say plainly that this section is for terminal users. |
| On the command line, the `lungfish-cli map` block | The backslashes at the ends of lines confused me. I did not know whether to type them. | One line explaining the line-continuation character. |
| On the command line, "`lungfish-cli bam` derives filtered alignment" | Three commands are named with no example, while `map` above got a full one. | Give one short example, or drop the paragraph. |

The one thing I learned: a BAM row is one alignment and not one read, so a row count and a read count are different numbers.

The one thing I still could not do: install the read-mapping plugin pack or open the demo project, because neither is shown anywhere in the chapter.

The sentence I liked most: "Read the coverage track first to see which parts of the genome the run covered at all, then zoom to a position and read the pileup the way a variant caller will."
