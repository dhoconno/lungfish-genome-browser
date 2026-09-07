# Reader report, Extracting a Consensus Sequence

Persona: senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| Title vs. body, "Extracting a Consensus Sequence" | The file name says consensus and lineage, and the first section tells me lineage lives elsewhere. I spent a minute deciding I was in the right chapter. | Say in the opening that lineage is not covered here. |
| What it is, "A consensus sequence is what" | "Reading an alignment downward instead of across" is a picture I could not form until three sentences later. I do not know what across looks like yet. | One sentence saying a read is a row and a position is a column. |
| What it is, "Deletions the reads support appear" | I did not know a consensus could hold a character that is not a base. I cannot tell whether an asterisk counts when someone asks how long my sequence is. | Say whether the asterisks are counted in the length. |
| What it is, "You decide whether disagreement between reads" | "A letter standing for both possibilities" meant nothing until I reached IUPAC many paragraphs later. | Name IUPAC here so the two halves connect. |
| What it is, "Under the surface LGE runs samtools" | The text says nothing to install, but I still do not know whether the first run downloads something and needs internet. | Say whether the first consensus run needs internet. |
| Why you would do this, "Phylogenetic tree builders, alignment tools" | Four downstream destinations named at once and I only recognize BLAST. | Gloss phylogenetic tree builder at first use. |
| Why you would do this, "The HG002 chromosome 20 slice" | HG002 arrives with no introduction. I could not tell if it is a person, a cell line, or just a file name. | One clause saying HG002 is a standard human reference sample. |
| Why you would do this, "its benchmark call set holds" | "Benchmark call set" is undefined, and I could not tell whether it comes with the fixture or is a separate download. | Gloss benchmark call set and say whether I need it. |
| Before you start, "Download the files GRCh38.chr20.10.0-10.5Mb.fasta" | The reference is named exactly but "the two HG002 FASTQ files" are not, so I did not know when I had them all. | Name all three files exactly. |
| Before you start, "and remember where you saved it" | "It" is singular after three downloads. I could not tell whether they must sit in one folder. | Say to keep all three files together. |
| Before you start, "the run behind every number quoted" | I could not tell whether mapping the reads myself gives me the same numbers as the chapter, or only close ones. | Say plainly whether my numbers should match exactly. |
| Before you start, "No plugin pack and no Docker" | Two things I have never heard of are ruled out here, which made me worry other chapters need them. | Drop these or gloss them. |
| Procedure step 1, "Click the alignment track in" | I do not know what an alignment track looks like in the sidebar or what it is named after mapping. I could not do this step from the text. | Say what the sidebar row is called. |
| Procedure step 2, "Switch the Inspector to its" | An Analysis tab holding a Consensus tab, which earlier prose called a section. Tab inside a tab left me unsure where to click. | Use one word per level, tab or section. |
| Procedure step 3, "Choosing Selected region instead reads only" | I do not know how to highlight a stretch in the viewport. Click and drag is never described anywhere. | Say how to make a selection. |
| Procedure step 4, "Set the evidence controls described" | This step sends me forward to a long section and back. I lost my place and reread the procedure from the top. | Give the two or three defaults inline. |
| Procedure step 5, "Pick Save to File... for" | Four destinations with no guidance on which a first-timer should choose. I stalled here. | Say which one to pick on a first run. |
| Procedure, "If every position in the scope" | I could not tell which setting caused the all-N alert, since "the scope" could be either scope choice. | Name the exact setting to lower. |
| Settings, "None of them has a command-line" | I do not know what a command-line flag is, and had to read to the end of the chapter to learn it does not affect me. | Move this to the command-line section. |
| Settings, "Consensus Mode. Chooses how the" | Bayesian is a word from a stats lecture I did not follow. The weighting explanation helped, but the word still scared me off touching it. | Add a clause saying it is named for a statistical method. |
| Settings, "Consensus minimum depth. Sets how many" | I know the default is 8 and the range is 1 to 50, but not what a real experiment uses. "Publication-grade" comes with no number. | Give one example number for publication grade. |
| Settings, "Gap threshold. Sets what share" | This one says spanning reads and the depth setting says covering reads. I could not tell whether those are the same reads. | Use one term for the same thing throughout. |
| Settings, "Consensus minimum MAPQ. Ignores reads the" | If raising it to 20 is the advice, I do not understand why the default is 0. | One clause saying why 0 is the default. |
| Settings, "Consensus minimum base quality. Ignores individual" | Same puzzle as MAPQ, and I do not know how to tell whether my run's tail-end quality is poor. | Say where in LGE I can see read quality. |
| Settings, "Two further filters reach the" | "The Alignment tab of the Inspector's View Settings section" is a third nested location I could not picture, and "flagged records" is undefined. | Gloss flagged records and simplify the location. |
| Reading the results, "Within that sequence, 499,006 positions carry" | I added the three counts by hand to check they reach 500,001. The chapter never says they should. | Say the three counts sum to the length. |
| Reading the results, "either because fewer than eight reads" | Two causes of `N` are named but nothing tells me how to tell them apart in my own output. | Say whether the app distinguishes the two causes. |
| Reading the results, "The pileup there holds 51" | 51 read bases against a depth of 63 stopped me cold. I do not know what makes 12 reads unusable or which number the depth floor of 8 is compared against. | Say which number the depth floor uses. |
| Reading the results, "A position where every read" | "The alternate" is used as a noun here for the first time with no gloss. | Gloss alternate base at first use. |
| Reading the results, table row "Use IUPAC ambiguity codes turned on" | The column header says `N` count, but with ambiguity letters in play I could not tell if 171 counts only `N`. | Add a note that 171 counts only `N`. |
| Reading the results, "Raising the depth floor from 8" | The same sentence gives 4,615 added positions and a sevenfold increase, and I computed the wrong ratio from the first number before rereading. | Give either the difference or the ratio, not both. |
| Reading the results, "with M, W, K, and" | The chapter points me to the glossary for R and Y but not for these four, which I do not know. | Point to the glossary here as well. |
| Reading the results, "the region in contig:start-end form" | Contig is used from the Procedure onward and never glossed in the chapter body. | Gloss contig at its first use. |
| Reading the results, "Reference-fill policy: never" | I understood the explanation but wondered whether this is a setting I could turn on somewhere. | Say the policy cannot be changed. |
| Reading the results, "writes the FASTA alongside a" | "Sidecar" is new to me. I could not tell if it is a second file I must keep or something inside the FASTA. | Say it is a separate small file to keep with the FASTA. |
| What good looks like, "There is no universal threshold" | I have never done this before, so I have no run I trust to compare against. The advice cannot be followed on a first analysis. | Give a rough acceptable range for a first-timer. |
| What good looks like, "Fourth, spot-check one position you" | I have no independent evidence for anything in my own data, so this check works only on the fixture. | Say this check applies to the fixture. |
| On the command line, "There is no lungfish-cli equivalent" | The section is about a terminal I have never opened but sits between two sections I need, so I did not know whether to read it. | Open with a line telling app-only readers to skip. |
| On the command line, "lungfish-cli msa consensus my-alignment.lungfishmsa" | I do not know what a multiple sequence alignment bundle is or where one comes from, and I could not choose between omit and include. | Say where a `.lungfishmsa` file comes from. |
| On the command line, "The same action appears in" | The only hint that I can do this without a terminal is buried in the terminal section I nearly skipped. | Move this sentence out of the code section. |

The one thing I learned: an `N` in a consensus means nobody looked, not that the sample matched the reference, so counting `N` characters is an honest measure of how much of my sample I actually saw.

The one thing I still could not do: step 1, because I do not know what the alignment track is called in the sidebar, or how to highlight a region if I wanted Selected region scope.

The sentence I liked most: "LGE never fills a thin position with the reference base, so an `N` in the output is genuinely an absence of evidence and never a quiet substitution of the reference for your sample."
