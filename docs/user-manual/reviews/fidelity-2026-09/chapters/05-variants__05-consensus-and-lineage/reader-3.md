# Reader report: Extracting a Consensus Sequence

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| Title and front matter, "Extracting a Consensus Sequence" | The file is named consensus-and-lineage but the title says only consensus, and later the chapter says it does not do lineage. I expected lineage here. | Say in the first paragraph that lineage naming is not in this chapter. |
| What it is, "A consensus sequence is what" | "Reading an alignment downward instead of across" is a picture I could not build on first reading. I read it twice. | A small figure showing the read stack and one vertical column. |
| What it is, "Deletions the reads support appear" | I did not know a deletion could be written inside a FASTA. In my class a FASTA has only A C G T and N. | One sentence saying whether other programs accept the asterisk. |
| What it is, "You decide whether disagreement between" | I did not understand why reads at the same position would disagree at all. The causes are never named. | Name the two causes, a real difference between chromosome copies and a sequencing error. |
| What it is, "Under the surface LGE runs" | I do not know what a "toolkit for reading alignment files" is or whether I ever have to see it. | Say plainly that I never interact with it directly. |
| Why you would do this, "Phylogenetic tree builders, alignment tools, BLAST" | Four tool categories in one sentence and none is explained. I do not know what a "public sequence submission portal" is. | Gloss the list or cut it to one example. |
| Why you would do this, "and its benchmark call set holds" | I do not know what a "benchmark call set" is or who produced it. | Gloss benchmark call set at first use. |
| Before you start, "Download the files GRCh38.chr20.10.0-10.5Mb.fasta and" | The step names three files, then says "remember where you saved it", singular. I was not sure whether I need all three. | Make the number agree and say what each file is for. |
| Before you start, "No plugin pack and no" | I do not know what a plugin pack or Docker Desktop is, so this reassurance meant nothing to me. | Drop the terms or gloss them. |
| Procedure step 1, "Click the alignment track in" | I did not know what an alignment track looks like in the sidebar or how to tell it from other items. | Name the icon or the folder it sits under. |
| Procedure step 2, "Switch the Inspector to its" | There is a tab inside a tab, the Consensus tab inside the Analysis tab, and I could not picture where to click. | Say the Consensus tab is a second row of tabs. |
| Procedure step 4, "For a first pass on" | The word Bayesian appears here with no explanation. The explanation is far below in Settings. | Add a short gloss here or point to Settings. |
| Procedure step 5, "Then click the button, which" | I could not tell which button. There is a destination menu and then a button, and I did not know if it is the one I already clicked. | Name the button's starting label. |
| Settings, "None of them has a" | I do not use a command line, so I could not tell whether this sentence was warning me about something I am missing. | Move this remark to the command line section. |
| Settings, Consensus Mode, "weighs each read's base by" | I did not understand how a weighted vote differs from a majority vote in practice. Two reads say A and one says T, what happens? | A one-line numeric example. |
| Settings, Use IUPAC ambiguity codes, "an unexpected R or Y" | I do not know what R or Y mean, and the link comes at the end of the sentence after the confusion. | Give the meaning of R in the same sentence. |
| Settings, Hide high-gap sites, "filling the consensus with spurious" | The setting hides gaps but the sentence says insertions. I could not tell whether this is a mistake or my misunderstanding. | Use one word consistently. |
| Settings, Consensus minimum depth, "Depth is the number of" | I do not know how to judge whether 8 is right for my own data. I only know it works for this fixture. | Say what depth typical data has. |
| Settings, Consensus minimum MAPQ, "MAPQ is the mapper's own" | I could not tell whether MAPQ 20 is good or bad, and "about 20" is vague. | State roughly what share of reads a floor of 20 removes. |
| Settings, Consensus minimum base quality, "judged by the same Phred" | Two different scales both use the number 20, MAPQ and Phred, and I confused them while reading. | Say explicitly that they are different scales. |
| Settings, "Two further filters reach the" | I could not find "the Alignment tab of the Inspector's View Settings section". It is a third nested location with no click path. | Give a click path the way the Procedure does. |
| Reading the results, "Running the fixture's alignment at" | I could not tell whether I am supposed to reproduce these exact numbers or whether mine will differ. | Say whether the numbers are reproducible. |
| Reading the results, "either because fewer than eight" | I did not know a position with many reads could still be N. That seemed to contradict my reading of the depth slider. | Mention conflict as a second cause of N earlier. |
| Reading the results, "The pileup there holds 51" | 51 and 63 appear in one sentence and I could not tell which number the depth slider compares against. | Say which of the two the depth floor uses. |
| Reading the results, "A position where every read" | The word "alternate" appears here for the first time with no gloss. | Gloss alternate. |
| Reading the results, table row "Use IUPAC ambiguity codes turned" | The column says N count, and for this row the count drops because letters became R and Y. I first read it as fewer errors. | Add a note saying where the missing N characters went. |
| Reading the results, "Raising the depth floor from" | The sentence attaches "sevenfold" to 4,615, but 4,615 is the difference and 5,339 is about seven times 724. I did the arithmetic twice. | Attach sevenfold to the total, not to the difference. |
| Reading the results, "Those ambiguity letters were R" | 184 plus 191 plus 178 is 553, but only 171 N characters remain. I could not make these numbers agree. | Show how the counts add up. |
| Reading the results, "That last line is the" | I did not understand the danger this protects me from until the following sentence, so I read both twice. | Put the danger before the policy name. |
| What good looks like, "There is no universal threshold" | As a student I have no earlier run I trust. This advice does not work for a first-time user. | Give a rough range for a first run. |
| What good looks like, "and the coverage curve above" | I did not know there is a coverage curve in the viewport. It was never mentioned in the Procedure. | Mention the coverage curve when the viewport first opens. |
| On the command line, "There is no lungfish-cli equivalent" | I have never opened a terminal. I could not tell whether I may skip this section or whether the msa command is something I will need. | One line saying readers working in the app can skip it. |
| On the command line, "--threshold is the minimum share" | "Non-gap rows" and "aligned sequences rather than reads" arrived together and I lost the difference between a row and a read. | Define row here. |

The one thing I learned. The `N` characters in a consensus are an honest record of what the reads could not tell me rather than an error, and counting them measures how much of the sample I actually observed.

The one thing I still could not do. Choose a depth floor and a MAPQ floor for my own data, because every number in the chapter is tied to this one fixture and I have nothing to compare against.

The sentence I liked most. "A variant caller that finds nothing at a position is silent, and silence means either that the sample matched the reference or that no reads were there to say."
