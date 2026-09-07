# Reader report: Quality Control for Reads

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "The numbers live in the FASTQ viewport" | I do not know the word "viewport". I guessed it is the big area on the right, but the chapter never says. | Gloss "viewport" at first use as the main panel where a bundle's contents appear. |
| What it is / "LGE scans the reads and reports" | The chapter says "LGE" here but the full name appeared only once before. I lost a second checking back. | A second full mention would help. |
| What it is / "what fraction of the bases are" | I know G and C are bases, but I do not know why anyone would count them. The reason comes ten paragraphs later. | One clause saying GC fraction is a fingerprint of the organism. |
| What it is / "The charts show how those numbers" | Read twice. "Spread out rather than averaged into one figure" is abstract before I have seen a chart. | An example instead of the abstraction. |
| What it is / "It does not report adapter contamination" | I do not know what an adapter is. The word is used four more times and never explained. | Gloss "adapter" at first use as the short synthetic DNA added during library preparation. |
| Why you would do this / "bad alignments produce bad variant" | "Alignment" and "variant call" are both new to me here. | Gloss both or link them. |
| Why you would do this / "A read-length distribution spread over" | I could not tell why thousands of bases means long reads. I do not know typical lengths per platform. | A number for Illumina and a number for long reads side by side. |
| Why you would do this / "not the Illumina pair you thought" | "Illumina" is used as if I already know it is a sequencing platform. | Say "the Illumina platform" once. |
| Why you would do this / "The reads are 2x250 base pairs" | I do not know how to read "2x250". Is it 500 bases in total? | Say it means two reads of 250 bases from the two ends of one fragment. |
| Before you start / "choose File > New Project (Cmd-N)" | I use a Windows keyboard at home. I was not sure this manual assumes a Mac. | State the platform once in the chapter or in the prerequisites. |
| Before you start / "Refreshing the summary uses seqkit" | I do not know what seqkit is or what a "pack" is. | One sentence saying seqkit is a bundled read-counting tool installed automatically. |
| Before you start / "No optional pack and no Docker" | Docker Desktop appears with no explanation. Since it is not needed here, I did not know why it is named at all. | Drop it, or say it is needed elsewhere but not here. |
| Procedure step 1 / "Click the HG002.chr20.10.0-10.5Mb bundle" | I did not know whether `Imports/` is a folder I create or one LGE makes for me. | Say LGE creates it during import. |
| Procedure step 2 / "Take Mean Q, Q20, Q30, and" | Q20 and Q30 are not defined until Reading the results, which is two sections later. | Gloss Q20 and Q30 where they first appear. |
| Procedure step 3 / "Click any one of them to" | I do not know the word "popover". I guessed a small floating window. | Use "a small floating window" instead. |
| Procedure step 4 / "The FASTQ/FASTA Operations window opens with that" | I know FASTQ but not FASTA. The chapter never separates the two. | Gloss FASTA at first use. |
| Procedure step 5 / "Watch the row in the Operations" | I could not tell whether I must open the panel before clicking Run or after. The sentence orders it after. | Say when to open it. |
| Procedure, after step 5 / "which happens for some bundles derived from" | I could not think of an example of a derived bundle. | Name one example, such as a trimmed bundle. |
| Settings / "Read counts, the length distribution, and" | Read twice. The paragraph says there are no settings and then says one control applies. | Split it into two short sentences. |
| Settings / "Chooses whether the run writes one" | This sentence is very long and holds three ideas including the default. I read it three times. | Shorter sentences. |
| Settings / "Switch to Grouped Result when the" | I do not know what a "library" means in sequencing. It appears again in the Length Dist. paragraph. | Gloss "library" at first use. |
| Reading the results / "Reads, Bases 91,148 and 22,662,846" | I could not judge whether 22 million bases is a lot for a 500 kb window. | Say what depth of coverage this works out to. |
| Reading the results / "N50 is the length such that" | I read this definition four times and I am still not confident. Half of bases, not half of reads, is subtle. | A tiny worked example with five reads. |
| Reading the results / "Mean Q is the average base" | The Phred scale is defined here, but Mean Q, Q20 and Q30 were already used in the Procedure. | Move the Phred explanation earlier. |
| Reading the results / "On an Illumina run, a Q30" | This says below roughly 70% means trouble. What good looks like says above roughly 80% is healthy. I did not know which to use for 75%. | Use one number, or explain the gap between the two. |
| Reading the results / "A human sample sits near 41%" | The fixture reads 39.4% and the text calls that fine, but What good looks like says a shift of five percent is worth chasing. I could not tell whether 1.6 counts as a shift. | Say plainly that 39.4 is inside the acceptable band. |
| Reading the results / "The card averages the error probabilities" | I did not follow this at all. Averaging probabilities and converting back to Phred is beyond me from this sentence. | A one-line worked example with two bases. |
| Reading the results / "and it weights a handful of" | Read twice. I could not see why a logarithmic average punishes bad bases. | Say the low-quality bases dominate because their error probability is large. |
| The three charts / "71.1% of reads are exactly 250" | The 91.0% here is the same figure as the Q30 card earlier. I thought it was a copied number by mistake. | Note that the coincidence is real, or reorder. |
| The three charts / "It is the chart that shows" | I know 3' from genetics, but I did not know the read end and the 3' end are the same thing here. | Say "the end of the read". |
| The three charts / "Q / Position is per-position quality, plotted" | I do not know how to read a box plot. Nothing tells me what the box edges mean. | One sentence on what the box shows. |
| The three charts / "peaks at Q36.5 around base 14" | I could not tell whether a peak at base 14 rather than base 1 is normal or a warning sign. | Say it is normal. |
| The three charts / "Quality binning rounds each score to" | "Compress harder" was odd English to me. I understood it only on the second reading. | Say "so the file takes less disk space". |
| The three charts / "Read a binned chart by which" | I did not know what to conclude from a tall spike at Q37. Is a tall spike good? | Say a tall spike at a high score is the good outcome. |
| The Reads tab / "A header that does not look" | I do not know what `N` means inside a sequence. | Gloss N as an undetermined base. |
| What the summary does not gate / heading | I do not know the verb "to gate" in this sense. The heading was the hardest part of the chapter for me to parse. | A plainer heading. |
| What good looks like / "For Oxford Nanopore, judge by mean" | I do not know Oxford Nanopore, and "expect far lower percentages" gives me no number to work with. | Give a number, or say this chapter does not cover it. |
| What good looks like / "Low quality across the read is" | I do not know what a sliding window is in trimming. | Gloss it, or drop it and point to the trimming chapter. |
| On the command line / "writes the same statistics as a" | I have never opened a JSON file and do not know what one looks like. | Say it is a text file that other programs read. |
| On the command line / the whole code block | I have never opened a terminal. The backslashes at line ends and the `$HOME` and `~` symbols were all unfamiliar. | A line saying this section is optional and can be skipped. |
| On the command line / "On this fixture read 1 reports" | Earlier the card read 24.9 and the command line 34.9 for the same reads. Now Q37.5 and Q36.0 appear. I lost track of which mean is which. | A small table of the four means with their source. |
| On the command line / "while the in-app quality report takes" | I could not tell whether reading only the first 100,000 reads is safe, since reads may not be in random order in the file. | Say whether the ordering matters. |
| On the command line / "On this fixture, with 91,148 reads" | Read twice. I had to work out for myself that 91,148 is smaller than 100,000. | State the comparison directly. |

One thing I learned. A read-length distribution with a second hump on the left means adapter read-through, and the quality scores alone would never have told me that.

One thing I still could not do. I could not decide from this chapter alone whether a Q30 of 75% is acceptable, because the chapter gives 70% in one place and 80% in another.

The sentence I liked most. "Look at these numbers before you spend an hour of compute on reads that were never going to give you an answer."
