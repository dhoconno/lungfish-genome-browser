# Reader report: Alignment Files

Persona: undergraduate who used Geneious in one class, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "BAM is the compact binary form" | I have never heard of SAM before, and it is introduced only as the thing BAM is the compressed form of. I could not tell whether SAM is something I will ever see. | One sentence saying whether I will ever handle a SAM file myself. |
| What it is / "Lungfish Genome Explorer reads and writes BAM" | "A standard toolkit that LGE installs and runs for you" left me unsure whether I have to install anything. | One clause saying I never install samtools myself. |
| What it is / "Where a single reference sequence is" | I did not know what "too long for BAI to address" meant, and the actual number only appears much later in the chapter. | Give the 512 megabase figure at this first mention. |
| What it is / "Three ideas carry the rest" | The three ideas are written as one sentence fragment with no verb, and I read it twice before I saw it was a list. | Make it a real sentence or an actual list. |
| Why you would do this / "Its reads are Illumina 2x250 paired-end" | I do not know what 2x250 means. I guessed 250 bases from each end, but the text never says. | Gloss 2x250 at first use. |
| Why you would do this / "a 500,001-base slice of human" | The trailing 1 made me think it was a typo, and I stopped to check. | Say why it is 500,001 and not 500,000. |
| Why you would do this / "the run recorded in the fixture's" | I could not tell where the `expected/mapping/` folder is or whether I need it. | Say it sits inside the downloaded fixture folder. |
| Before you start / "a project holding a reference bundle" | I do not know what a reference bundle is or how a track gets attached to one. Nothing on this page tells me. | Link the chapter that explains bundles and tracks. |
| Before you start / "samtools comes with the Required Setup" | Required Setup pack is capitalised like a proper name but never explained. | Gloss Required Setup pack once. |
| Before you start / "Docker Desktop is not needed anywhere" | Docker appears from nowhere and is never mentioned again. I could not tell why I was being told this. | Drop it, or say which chapters do need it. |
| What one row records / "a handful of optional tags the mapper" | Optional tags are named and then never explained or mentioned again. | Say I can ignore them for now. |
| What one row records / "QNAME D00360:94:H2YT5BCXX:1:1204" | RNEXT, PNEXT and TLEN appear in the block and are never explained, and the next line says "the fields that matter", which made me wonder whether these do not matter. | Say plainly that those three describe the mate and are not covered here. |
| What one row records / "RNEXT =" | A bare equals sign as a value looked like a formatting error. | One clause saying the equals sign means the same reference sequence. |
| What one row records / "on the same logarithmic scale as" | I have half-forgotten Phred from the reads chapter, and this sentence assumes I have it. A MAPQ of 60 is called the top value, but I could not work out what 60 means as a probability. | Restate the scale in the form "60 means about one in a million". |
| What one row records / "The value 99 above unpacks into" | I could not check this. No way to unpack a FLAG is shown, so I had to take 99 on faith. | Point at where the app or a website shows the decoded FLAG. |
| The CIGAR string / "D Deleted from the read, present" | I read this table row three times. "Deleted from the read" plus "present in the reference" sounds contradictory until you realise it means missing from the read. | Word it as "missing from the read". |
| The CIGAR string / "any tool that respects the CIGAR" | "Any tool that respects the CIGAR" implies some tools do not, which worried me and was never resolved. | Say whether LGE always respects it. |
| One row is not one read / "one read spans a junction and" | I do not know what a junction is here. I know splice junctions from class, but this seems to be something else. | Gloss junction, or give the usual example. |
| One row is not one read / "Its BAM holds 91,203 rows, of" | I had to do the arithmetic myself to see that 45,574 twice makes 91,148, and I checked twice in case unmapped rows were hiding in the gap. | State that no reads were unmapped in this fixture. |
| The index / "BAI can only reach 512 megabases" | I could not tell whether any real chromosome exceeds 512 megabases, so I could not judge whether CSI ever applies to me. | Name a genome that needs CSI. |
| Coverage / "one bar per screen column when you" | I could not picture what one bar per screen column shows. Is it the mean of that window, or the maximum? | Say which value the zoomed-out bar shows. |
| Coverage / "a mean depth of 44.7 across the" | Three numbers arrive in one sentence, mean depth, percent mapped, and deepest position, and I lost track of which one the next sentence was about. | Split it into two sentences. |
| Coverage / "the deepest single position reaching 79" | I do not know how to judge 79. Is a deep spot good news, or a warning about a repeat? | Say what a high maximum depth means. |
| Coverage / "which is what the fixture's coverage breadth" | 31 uncovered positions out of 500,001 works out to 99.994 percent, so I could not tell whether 99.99 was rounded or a different measurement. | Say the figure is rounded. |
| Coverage / "because a single sequencing error among those" | The maths is left to me. I had to turn "a fifth" into 20 percent myself before the point landed. | Spell out the resulting allele frequency. |
| Coverage / "In this fixture 505 positions sit below" | I could not reconcile 505 thin positions with the 31 uncovered positions given two paragraphs earlier. | Say explicitly that the 505 includes the 31. |
| Pileup / "Twenty of them show C and" | Twenty is spelled out and 33 is a numeral in the same sentence, so I reread it to check they were the same kind of thing. | Use numerals for both. |
| Pileup / "a proportion close to the half you" | 0.62 does not look close to 0.50 to me, and the text does not say how far off is still acceptable. | Give the range a caller treats as heterozygous. |
| Pileup / "The Genome in a Bottle benchmark for" | I could not see how to look this up myself, so the answer key only works if the manual hands me the answer. | Say whether the benchmark ships with the fixture. |
| Pileup / "The variant-calling dialog pre-fills a minimum" | The sentence mixes 0.05 with 10 percent and 0.5 percent, and I had to convert 0.05 into 5 percent in my head to follow it. | Use percentages throughout the sentence. |
| Strand / "forward if the read aligned as sequenced" | Reverse complement is used as if known. I met it in genetics, but not applied to a read flipped by software. | Gloss reverse complement here. |
| Strand / "16 are forward and 17 are reverse" | I do not know how far from even is still fine. 16 to 17 is obviously fine and 20 to 0 is obviously not, but nothing tells me about 25 to 8. | Give a rough threshold, or say the app flags it. |
| Steps that reshape a BAM / "flags the extras in the FLAG" | I could not tell what happens next. Are marked duplicates ignored automatically later, or do I have to do something? | Say who honours the duplicate flag. |
| Steps that reshape a BAM / "LGE's alignment-level primer trim runs" | "Alignment-level" is only contrasted with a "read-based alternative" in the last line of the paragraph, so the contrast arrived too late. | Name both options at the start of the paragraph. |
| Steps that reshape a BAM / "though some ivar trim options drop" | Which options? I would not know whether my run had dropped rows. | Name the option, or say where the count appears. |
| Choosing a mapper / "BBMap handles messier reads where local" | Local alignment is used without a gloss, and I could not tell what makes reads messier. | Gloss local alignment, or drop the term. |
| Choosing a mapper / "up to 500 bases in its standard" | I could not tell whether these are limits I have to respect or limits the app enforces. | Say the app checks this for me. |
| Choosing a mapper / "and each is restricted to that role" | I did not know whether restricted means the app hides them or that I should simply not choose them. | Say whether the app prevents the choice. |
| Choosing a mapper / "assembled contigs, and spliced RNA alignment" | Contig and spliced RNA alignment are both new here, and neither is glossed. | Gloss contig at first use. |
| Long reads and short reads / "LoFreq, iVar, or bcftools for short" | Five caller names arrive at once, with no way to choose among the three short-read ones. | Say which one LGE picks by default. |
| What good looks like / "A fraction below about 80 percent" | The fixture is 99.77 and the warning line is 80, so the whole middle is undefined. I would not know what to think of 92 percent. | Give an acceptable range, not only the failure point. |
| On the command line / "The same mapping run that produced" | I have never opened a terminal. The section says it is optional, which I appreciated, but the code block still made me anxious I was skipping something required. | Say plainly that the app does all of this without a terminal. |
| On the command line / "Paths are written as if you" | I do not know what a repository root is. | Gloss it, or call it the folder you downloaded. |
| On the command line / "lungfish-cli bam derives filtered alignment tracks" | "Derives filtered alignment tracks" is four nouns in a row, and I could not picture the result. | Say what a filtered track is for. |

The one thing I learned: a BAM row is one alignment and not one read, so a row count and a read count are allowed to differ, and the CIGAR is the field that records how a read actually lines up base by base.

The one thing I still could not do: judge a BAM of my own, because nearly every number is given either as the fixture's value or as a failure point, with nothing in between. I would not know what to make of 92 percent mapped or a strand split of 25 to 8.

The sentence I liked most: "Disagreements live in the pileup, not in the CIGAR."
