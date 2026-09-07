# Reader report: Sequencing Reads

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A sequencing read is one fragment" | "one fragment of DNA that came off a sequencing instrument, written down as a string of letters" made me think the read is the physical DNA. Later it is a text file. I read it twice to see which one it is. | Say the read is the data record, not the molecule. |
| What it is, "One read is a short, noisy guess" | "noisy" is a figure of speech I did not know in this context. There is no sound involved. | Gloss noisy as containing errors. |
| What it is, "the analysis that follows is the work" | "the work of stacking those guesses until they agree" is poetic and I had to read it twice to get the literal meaning. | State plainly that many reads over the same position are compared. |
| What it is, "So what should you do with this?" | The paragraph gives advice before I have learned any of the three things. I did not know what "keep paired files together" meant yet. | Move this sentence to the end of the chapter. |
| Why you would do this, "HG002 is a well-characterised human" | "Genome in a Bottle project" is a name I have never met and it is not glossed. I could not tell if it is a company, a consortium, or a product. | One clause saying what Genome in a Bottle is. |
| Why you would do this, "Compare the two and you can" | The text says read length goes "from 250 bases to 10,000" but the platform table later says Illumina is 75 to 300 bp and nanopore up to 100 kb. I could not tell if 250 and 10,000 are fixture numbers or the general case. | Say these two numbers come from the two fixtures. |
| Why you would do this, "Reads for both fixtures are cited" | The line prints as a template placeholder rather than English. I do not know what it will become. | Nothing for me to act on, but as printed it is unreadable. |
| Before you start, "You need a project open" | I did not know if Cmd-N is typed instead of the menu or after it. My keyboard labels that key differently. | Say the keyboard shortcut is an alternative to the menu. |
| Before you start, "This chapter uses the HG002" | I could not perform this step. I do not know what to do at a GitHub page. Nothing says which button downloads a file. | Two sentences on how to get a file off that page. |
| The four-line FASTQ record, "Its sequence and quality lines" | It says 250 characters, but under Paired-end reads the same read is listed at 250 bases and its mate at 249. I could not judge whether one base of difference is a problem. | Say a mate may be a base or two shorter and that this is normal. |
| The four-line FASTQ record, "Line 1 is the header" | Six things are named for the header but I counted seven colon-separated fields in the example. I could not match them up. | Label the fields on the example or drop the list. |
| The four-line FASTQ record, "Line 2 is the sequence" | I did not know whether N counts toward read length, and whether many N is bad. No number is given to judge it. | State that N counts as a base and give a rough limit. |
| The four-line FASTQ record, "Line 3 is the separator" | I had to read the last clause twice. At this point I have not seen the quality alphabet, so I could not see why a quality character resembles a base. | Move this remark after the Phred section. |
| Compressed FASTQ files, "Almost every FASTQ you meet is" | "hold 22,662,846 bases between them" is a very precise number I cannot judge. I do not know if this is a lot. | Compare it to something, for example the length of chromosome 20. |
| Compressed FASTQ files, "LGE handles .fastq and .fastq.gz" | LGE appears in the body here and I had to scroll back to find where it was defined. | Nothing needed if the earlier definition is easier to notice. |
| Compressed FASTQ files, "Unzip a file to look inside" | I could not perform this. There is no instruction for how to unzip, and I was told earlier I never need to. | Say this step is optional and not required. |
| Paired-end reads, "Most short-read Illumina protocols read" | The illustration caption says "reverse complement" but the text never uses or explains that phrase. | Gloss reverse complement where it first appears. |
| Paired-end reads, "The SRA convention writes the suffix" | SRA is not spelled out or glossed. | Expand SRA at first use. |
| Paired-end reads, "Pairing earns its keep twice" | I did not follow why counting a pair as one observation rather than two makes depth honest. I read it twice and still guessed. | One sentence saying the two mates are not independent evidence. |
| When the mates overlap, "With 250-base reads, that happens" | The arithmetic under 500 bases was clear, but I do not know how to find my own insert size, so I could not tell if this applies to me. | Say where insert size is reported. |
| When the mates overlap, "Merging turns that overlap to advantage" | bbmerge is a bare tool name with no gloss. I did not know if I must install it myself. | One clause saying it is bundled. |
| Interleaved FASTQ, "This is interleaved FASTQ, and several" | "read processors" is vague and I could not tell which tools are meant. | Name one, or say some downstream tools. |
| Interleaved FASTQ, "LGE bundles keep paired-end reads as" | I could not tell whether Interleave and Deinterleave are menu items, buttons, or something else, or where to find them. | Say where these operations live. |
| Phred quality scores, "A Phred score is a per-base" | I know logarithms but I could not tell whether P is a fraction like 0.01 or a percentage. The table helped more than the formula. | State that P is a probability between 0 and 1. |
| Phred quality scores table, "Q40 1 in 10,000 Routine on" | The table says Q40 is routine, but What good looks like says Q30 is the working definition of good. I could not tell which number to judge against. | Say which one is the threshold and which is the ceiling. |
| Phred quality scores, "In the file each score is" | "offset by 33, a convention called Phred+33" needs ASCII, which is never explained. I do not know what an ASCII code is. | Gloss ASCII in one clause. |
| Phred quality scores, "Apply that to the record printed" | I could not reproduce the step. Nothing tells me how to find that D is 68 without a table of ASCII codes. | Give a small lookup table or say a tool does it. |
| Phred quality scores, "The quality line opens DDDDD" | Q35 to 1 in 3,000 does not follow from the table, which jumps from 1 in 1,000 to 1 in 10,000. I read it twice and still could not check it. | Show the halfway step or say it falls between the table rows. |
| Read length and platform differences, "Sequencing platforms produce reads of very" | "fences in" is an idiom I did not know. | Use limits or restricts. |
| Platform table, "Oxford Nanopore (MinION, PromethION)" | simplex and duplex are not glossed anywhere and I do not know which one my data would be. | Gloss both terms in a note under the table. |
| Read length and platform differences, "Read length is quoted in base" | The chapter used chromosome 20 as the example, but here it switches to the mitochondrial genome without warning. I was confused about which genome we are in. | Signal the switch to mitochondrial DNA. |
| A nanopore read, "Two things stand out beside the" | I can see the first character is a bracket but I could not verify ASCII 40 without a table. Same problem as before. | Same as above, a small lookup table. |
| A nanopore read, "The ( in the first position" | Q7 to a 1-in-5 chance needs the formula, not the table, and I could not do the fractional power in my head. | Add Q7 to the table or show the arithmetic. |
| A nanopore read, "That looks alarming and is normal" | The fixture averages Q7.9, but later the chapter says to expect Q12 to Q20 from nanopore. I could not tell whether this fixture is broken or just old. | Say why the fixture is below range where the number first appears. |
| A nanopore read, "Nanopore trades per-base accuracy for length" | I had to read this twice. I did not see why independence of errors lets stacking fix them. | One sentence connecting independence to consensus. |
| A HiFi read, "That is why the quality string" | Q93 is far outside the table, which ends at Q40. I could not judge whether Q93 is real or a placeholder. | Say the scale is capped in practice or that this value is nominal. |
| A HiFi read, "It is a consensus confidence, not" | I understood the words but not what I should do differently because of it. | Say what this number must not be compared against. |
| How LGE shows a read set, "Click a FASTQ bundle in the" | The text says one summary bar, the next paragraph says nine cards, and the shot caption says nine summary cards. I read it twice to see these are the same thing. | Use one name for the bar or the cards. |
| How LGE shows a read set, "The summary bar carries nine cards" | I could not tell what a good Mean Q or Q30 percentage is at the point where the cards are described. | Point forward to What good looks like. |
| How LGE shows a read set, "Importing reads does not compute a" | I have never opened a terminal, so "available from the command line" is a dead end for me. | Say the GUI path alone is enough. |
| What good looks like, "Read count is how many records" | Amplicon has not been defined yet. It arrives in the next chapter. | Gloss amplicon or drop the example. |
| What good looks like, "Read length should match the platform" | I did not know why the average is 248.6 when 90.8% of reads are 249 or 250. I read it twice. | Mention that a tail of shorter reads pulls the average down. |
| What good looks like, "Coverage is how many reads cover" | I could not perform or check this. Mapping has not been introduced and I do not know where 44.7x came from. | Say this number comes from a later chapter's procedure. |
| What good looks like, "Mapping this fixture's reads back to" | "comfortable for calling small variants" gives no threshold. I do not know what depth is too low. | Give a minimum depth number. |

The one thing I learned. A FASTQ file spends exactly four lines on each read, and the fourth line has one character for every letter on the second line.

The one thing I still could not do. Decode a quality character by myself, because I was never given the ASCII codes I would need.

The sentence I liked most. "Split the pair, lose one file, or reorder one of them, and every step after that quietly degrades."
