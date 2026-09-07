# Reader report: Alignment Files

Reader 2. Senior undergraduate. Two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "BAM is the compact binary form..." | I do not know what SAM stands for or why a format has two names. The chapter never spells it out. | Spell out SAM once and say it holds the same information in readable text. |
| What it is, "Lungfish Genome Explorer reads and writes BAM..." | `samtools` is set in code font and never glossed. I do not know if it is something I install, click, or ignore. | One sentence saying samtools is a program LGE runs behind the scenes. |
| What it is, "Where a single reference sequence is too long..." | Too long compared to what? No number appears here, and I did not know a sequence could be too long for a file to handle. | Give the size limit here rather than four sections later. |
| What it is, "read the pileup the way a variant caller will" | Variant caller is used before it is defined. I had to read to the pileup section to find out what one is. | Gloss variant caller at this first mention. |
| Why you would do this, "Consensus generation reads a BAM." | I do not know what a consensus is in this context. | Add a short gloss for consensus. |
| Why you would do this, "Its reads are Illumina 2x250 paired-end reads..." | I have heard of paired-end in lab, but I do not know what the 2x250 notation means. | Say 2x250 means each fragment is read 250 bases from each end. |
| Why you would do this, "a 500,001-base slice of human chromosome 20" | The odd number bothered me. I re-read it twice thinking it was a typo. | Say why the count is 500,001 rather than 500,000. |
| Before you start, "the demo project's `chr20 10.0-10.5Mb` bundle" | I do not know what a reference bundle or an alignment track is, or where the demo project comes from. | Point to the chapter that creates the demo project. |
| Before you start, "`samtools` comes with the Required Setup pack" | Required Setup pack is capitalised like a proper name but never explained. | Name where the user sees the Required Setup pack in the app. |
| Before you start, "Docker Desktop is not needed anywhere" | Docker Desktop is mentioned once and never explained, so I do not know why I would ever have worried. | Drop it or say in one clause what it is. |
| What one row records, "a handful of optional tags the mapper attached" | I could not tell whether optional tags matter to me or not. | Say plainly that a beginner can ignore optional tags. |
| What one row records, the code block fields | RNEXT, PNEXT, and TLEN appear in the block and are never explained, while the text promises to take the fields one at a time. | Either explain the three or say they are shown only for completeness. |
| What one row records, "RNEXT  =" | An equals sign as a value looked like a formatting error to me. | Say the equals sign means the mate sits on the same reference. |
| What one row records, "on the same logarithmic scale as a Phred score" | I do not remember what a Phred score is and this chapter does not restate it. | Restate in half a sentence what the Phred scale means. |
| What one row records, "The value 99 above unpacks into four of them." | I cannot see how 99 becomes those four facts, and the text says I will rarely do it by hand, so I am left holding a number I cannot check. | Say the number is a sum of coded values and leave it there. |
| The CIGAR string, "The row above carries `240M9S`" | The read is 250 bases and 240 plus 9 is 249. I counted and got stuck on the missing base. | Explain the arithmetic or use an example that adds up. |
| The CIGAR string, table row for `D` | "Deleted from the read, present in the reference" reads backwards to me next to the `I` row. I read both three times. | Phrase both rows from the same point of view. |
| The CIGAR string, "a CIGAR of `250M` is entirely compatible" | The example jumps from 240M9S to 250M with no link, so I was unsure whether this was still the same read. | Say this is a different, hypothetical read. |
| One row is not one read, "one read spans a junction" | I do not know what a junction is here. In my genetics class that word meant splice sites. | Gloss junction, or give an example. |
| One row is not one read, "91,203 rows, of which 91,148 are primary" | I could not work out how to see these counts myself in the app. | Say where in LGE these two numbers are displayed. |
| The index, "BAI can only reach 512 megabases" | I do not know whether any chromosome I care about is over 512 megabases, so I cannot tell if this ever affects me. | Name one organism where CSI is actually needed. |
| Coverage, "mean depth of 44.7" | Mean depth of what unit is not stated. I first read it as a percentage. | Say mean depth is an average number of reads per position. |
| Coverage, "99.77 percent of rows mapped" | This is a mapped fraction, not a coverage number, and it sits in the middle of coverage figures. It confused what the paragraph was about. | Move the mapped fraction out of the coverage paragraph. |
| Coverage, "the deepest single position reaching 79" | I do not know whether 79 against a mean of 44.7 is fine or a warning sign. | Say whether a peak near twice the mean is expected. |
| Coverage, "coverage breadth of 99.99 percent" | Breadth is used before it is defined. Its definition arrives in the last section. | Define breadth at first use. |
| Coverage, "505 positions sit below a depth of 10" | Why 10 and not some other number is not said here. | Say 10 is the working threshold and where it comes from. |
| Pileup, "At position 250,527" | I could not tell whether this position is counted within the 500,001-base slice or on the full chromosome 20. | State which coordinate system the position uses. |
| Pileup, "a proportion close to the half you expect" | 0.62 did not feel close to 0.5 to me and no tolerance is given. | Say what range around 0.5 still counts as heterozygous. |
| Pileup, "The Genome in a Bottle benchmark" | Named in two sections but never explained beyond "characterised in detail". I do not know who makes it or how to look at it. | One sentence saying what the benchmark is and where it lives. |
| Pileup, "The variant-calling dialog pre-fills a minimum..." | I never saw this dialog and cannot picture where 0.05 is set. | Say which chapter shows that dialog. |
| Pileup, "a 10 percent alternate is reportable" | The paragraph switches from decimals to percentages mid-thought and I had to convert in my head. | Keep one notation throughout the paragraph. |
| Strand, "the mapper aligned its reverse complement" | Reverse complement is assumed knowledge. I know the term vaguely from class but not why a mapper would use it. | Gloss reverse complement in one clause. |
| Strand, "16 are forward and 17 are reverse" | I do not know how to see the forward and reverse split for a position in LGE. | Say where the strand counts appear in the viewport. |
| Steps that reshape a BAM, "flags the extras in the FLAG field" | If the duplicates stay in the file, I could not tell whether they still count toward the coverage numbers I just learned to read. | Say whether marked duplicates are excluded from coverage. |
| Steps that reshape a BAM, "LGE's alignment-level primer trim runs `ivar trim`" | ivar is a new tool name with no gloss and no note about whether I need a pack for it. | Gloss ivar and say which pack supplies it. |
| Steps that reshape a BAM, "some `ivar trim` options drop rows" | Which options, and whether the defaults do this, is not said. | Say whether the LGE default drops rows. |
| Choosing a mapper, "BBMap handles messier reads where local alignment helps" | Messier and local alignment are both undefined. I could not tell when I would want BBMap. | Say in plain words what kind of run gives messy reads. |
| Choosing a mapper, "up to 500 bases in its standard mode and 6,000 in its PacBio mode" | I do not know whether these numbers are read lengths or something else. | Say these are maximum read lengths. |
| Choosing a mapper, "Its other presets cover Oxford Nanopore reads..." | The presets are described but not named, so I would not recognise them in a menu. | Give the preset names as they appear in LGE. |
| Choosing a mapper, "The mapper compatibility check compares..." | I do not know whether this check blocks me or only warns me. | Say whether the run is blocked or just flagged. |
| Provenance, "checksums of the input reads and reference" | Checksum is not glossed. | Gloss checksum in one clause. |
| Long reads and short reads, "where a read ran past a contig boundary" | Contig is used without a gloss. | Gloss contig. |
| Long reads and short reads, "LoFreq, iVar, or bcftools for short reads" | Five caller names arrive at once with no way to choose between the three short-read options. | Say which one LGE picks by default. |
| What good looks like, "A fraction below about 80 percent" | I could not tell what to do if my run lands between 80 and 99. | Say what the range between the two figures means. |
| On the command line, whole section | The chapter told me earlier that nothing here has to be run, then shows a command spanning six lines with backslashes I do not understand. | Say the backslash only continues the line. |
| On the command line, "Paths are written as if you are in the repository root." | I do not know what a repository root is or whether I have one. | Name the folder rather than calling it the repository root. |
| On the command line, "`lungfish-cli bam` derives filtered alignment tracks" | Four capabilities are listed in one sentence with no subcommands shown, so I could not act on any of them. | Point to where the bam subcommands are documented. |

One thing I learned. A BAM row is one alignment and not one read, so counting rows overcounts my sample, and the fixture's 55 extra rows made that concrete.

One thing I still could not do. Open the demo project and find the coverage track, the depth number, or the strand split at a position for myself. Every figure is quoted at me rather than shown where I would click.

The sentence I liked most. "Reading the coverage track before anything else is the habit worth forming."
