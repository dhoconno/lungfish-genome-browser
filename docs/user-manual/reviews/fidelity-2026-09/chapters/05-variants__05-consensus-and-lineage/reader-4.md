# Reader report: Extracting a Consensus Sequence

Reader 4. Undergraduate who used Geneious in one class for a cloning project. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| Title vs. content, "Extracting a Consensus Sequence" / file named `05-consensus-and-lineage` | The file is called consensus-and-lineage but the chapter tells me lineage is somewhere else. I kept waiting for the lineage part and it never came. | Say in the first paragraph that lineage is not covered here. |
| What it is, "Deletions the reads support appear as" | I have never seen an asterisk inside a sequence. In Geneious deletions were dashes. I did not know whether other programs would accept a FASTA with asterisks in it. | One sentence saying whether downstream tools accept `*` or whether I should replace it. |
| What it is, "You decide whether disagreement between reads" | Read this sentence three times. I did not know what a letter standing for both possibilities looked like until eight paragraphs later. | Give the example letter here rather than much later. |
| What it is, "So what should you do with this?" | The question is addressed to me but it sits in the middle of a paragraph about samtools, so I could not tell whether it was a heading or a sentence. | Start a new paragraph. |
| Why you would do this, "its benchmark call set holds 961" | I do not know what a benchmark call set is or where it lives. Is it a file I have? Is it something I download? | Gloss it or say I do not need it. |
| Before you start, "Download the files `GRCh38.chr20.10.0-10.5Mb.fasta` and" | Three files are named but the sentence ends with "remember where you saved it," singular. I could not tell whether the two FASTQ files are one paired set, and their names are given as a pattern not as filenames. | Give the three exact filenames. |
| Before you start, "No plugin pack and no Docker" | I do not know what a plugin pack is and I have never installed Docker. Being told I do not need things I have never heard of made me worry I had skipped a setup chapter. | Drop it, or point to where plugin packs are explained. |
| Procedure step 1, "Click the alignment track in the" | I have a project and I mapped reads. I did not know what an alignment track looks like in the sidebar or what it would be named. | Say what the row is called, for example the BAM file name. |
| Procedure step 2, "Switch the Inspector to its Analysis" | A tab inside a tab confused me. I looked for Consensus at the top of the window for a while. | Say plainly that Consensus is one of several tabs inside Analysis. |
| Procedure step 3, "Then set Consensus scope to Whole contig" | Contig was never explained anywhere in the chapter text. | Gloss contig at first use here. |
| Procedure step 5, "Then click the button, which renames" | I could not tell which button. There is a Destination menu and then "the button," with no name given for how it reads before I choose. | Name the button as it reads at first sight. |
| Procedure, "If every position in the scope" | I did not know whether this alert means normal or broken. It says the usual answer is Cancel and a lower depth floor, but not how much lower. | Suggest a starting value, for example try 4 or 1. |
| Settings, "None of them has a command-line" | I have never used a command line, so I could not tell whether this was warning me something is missing or reassuring me. | Say plainly that these are app-only settings. |
| Settings, Consensus Mode, "The default is `Bayesian`, which weighs" | Bayesian is a word I have only met in a statistics lecture and I could not connect it to what the app is doing, or decide whether it is the safer choice. | One short sentence saying it is the safer default, without the word Bayesian. |
| Settings, Use IUPAC ambiguity codes, "Turn it on when you are reporting" | I do not know what a mixed population means in a human sample. My sample is one person, so I could not tell whether this setting is ever for me. | Say what turning this on means for a human sample with two chromosome copies. |
| Settings, Hide high-gap sites, "Turn it on when a noisy long-read" | The setting is about gaps, which I read as deletions, but the reason given is spurious insertions. I could not follow which way round it goes. | Use the same word in both halves of the sentence. |
| Settings, Consensus minimum depth, "Raise it when you need a publication-grade" | I know the range is 1 to 50 but not what to pick. "Publication-grade" is vague and I would not know whether 20 or 30 is normal. | Give one concrete alternative value and say what it is for. |
| Settings, Consensus minimum MAPQ, "The default is 0, which uses every" | The scale is explained as 0 for a bad placement, then the default floor is also 0. It sounded like the app lets in the bad reads on purpose. | Say that a floor of 0 means no filtering, which is different from a read scoring 0. |
| Settings, "Two further filters reach the consensus without" | I could not find View Settings. I had just been told View and Consensus are deliberately separate, so I did not know where to look. | Give a short click path the way the Procedure steps do. |
| Reading the results, "Within that sequence, 499,006 positions carry" | The three numbers add to 500,001, which reassured me, but I have no way to check my own run against them because I do not know how to count letters in a file. | Say whether the app reports these counts anywhere. |
| Reading the results, "The pileup there holds 51 read" | Two depths are given for one position, 51 and 63, and I could not tell which one the depth slider is comparing against. | Say which of the two numbers the minimum depth setting tests. |
| Reading the results, "A position where every read carries" | Alternate was not glossed. I know homozygous from genetics, but "the alternate" used as a noun was new to me. | Gloss alternate at first use. |
| Reading the results table, row "Use IUPAC ambiguity codes turned on" | Every other row raises the N count and this one cuts it to a quarter. That looked too good, and I could not tell whether fewer N is actually better. | One sentence saying fewer N is not automatically better in this row. |
| Reading the results, "Those ambiguity letters were `R` 184" | The three counts add to 553, which matched, but I still do not know what R and Y mean without leaving the chapter. | Say inline that R means A or G and Y means C or T. |
| Reading the results, "and two fixed policies reading `Low-depth" | I did not understand what danger was being ruled out until the sentence after the quoted policy line. | Put the plain explanation before the quoted line. |
| What good looks like, "so compare against a run you" | I have no previous run to compare against. This is my first one. | Say what a first-time reader should do instead. |
| On the command line, "There is no `lungfish-cli` equivalent for" | I have never opened a terminal. The section says there is no command for this, then shows a command for something else with five flags, and I could not tell if I was meant to skip it. | Label the section as optional for terminal users. |
| On the command line, "lungfish-cli msa consensus my-alignment.lungfishmsa" | A `.lungfishmsa` file appears here and nowhere else in the chapter. I do not have one and do not know how to make one. | Say where a `.lungfishmsa` comes from, or drop the example. |

One thing I learned: an `N` in a consensus means nobody looked, and a matching base means somebody looked and agreed, and a variant list cannot tell those two apart.

One thing I still could not do: choose a minimum depth for my own data. I understand what the number counts, but with only the fixture's 8 and a vague "publication-grade" to go on I would leave the default and hope.

The sentence I liked most: "A consensus sequence is what you get when you read an alignment downward instead of across."
