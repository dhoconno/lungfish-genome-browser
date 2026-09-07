# Reader report: Extracting a Consensus Sequence

Reader 1, undergraduate persona. Sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| Title vs body, "Extracting a Consensus Sequence" | The file is named consensus-and-lineage and the intro promises lineage, then says lineage lives elsewhere. I kept waiting for the lineage part. | Say in the first sentence that lineage is not covered here. |
| What it is, "A consensus sequence is what you get" | "Reading an alignment downward instead of across" is a picture I could not form. I have never seen an alignment on a screen. | A small figure showing a stack of reads with one vertical column highlighted. |
| What it is, "Where the reads gave enough evidence" | "The letter is the base the reads carried, which may or may not match the reference." I read this twice. I did not know the consensus was allowed to disagree with the reference. | One sentence saying the consensus describes your sample, not the reference. |
| What it is, "Deletions the reads support appear" | I did not know a FASTA file could contain `*`. My genetics class only showed A, C, G, T. | Say whether other programs accept `*` or whether you must strip it. |
| What it is, "You decide whether disagreement between reads" | I could not tell why reads covering the same position would disagree at all. Sequencing error, or two different chromosomes? | One clause naming the causes of disagreement. |
| What it is, "Under the surface LGE runs samtools" | I do not know what a toolkit is here, or why it matters that it is standard. | Say plainly that samtools is the program doing the counting. |
| What it is, "So what should you do" | The question sounded addressed to someone else and broke the flow. | Cut the question and keep the advice. |
| Why you would do this, "Phylogenetic tree builders, alignment tools, BLAST" | Four tool names in one sentence, none glossed. I know BLAST only vaguely from lecture. | Gloss one and drop or link the rest. |
| Why you would do this, "its benchmark call set holds 961" | I do not know what a benchmark call set is or who produced it. | One clause saying it is a trusted answer key for this sample. |
| Why you would do this, "A variant caller that finds nothing" | This was the clearest idea in the chapter but it took two reads to see that the consensus is more honest than the variant list. | Put this point earlier, it is the strongest argument here. |
| Before you start, "Download the files GRCh38.chr20" | Three files are listed, then "remember where you saved it" is singular. I was unsure whether I needed all three. | Make it plural and say all three are required. |
| Before you start, "You also need an alignment inside" | I cannot tell whether the thing I opened is a reference bundle or something else. | Say what the sidebar looks like when a bundle is open. |
| Before you start, "No plugin pack and no Docker" | I do not know what either of these is, so being told I do not need them did not reassure me. | Cut, or move to a note for readers who know the terms. |
| Procedure step 1, "Click the alignment track in" | I could not find the sidebar or tell which row is the alignment track. This is step one and I was already stuck. | Name the icon or the section heading the track sits under. |
| Procedure step 2, "Switch the Inspector to its" | A tab inside a tab. I could not picture where to look. | The screenshot is marked here but I only had the caption. |
| Procedure step 3, "Then set Consensus scope to" | Contig is used here but never glossed in the running text. | Gloss contig at first use in the body. |
| Procedure step 4, "Turning on Hide high-gap sites" | The step tells me to turn something on that Settings later says should stay off for this fixture. I did not know whether to do it. | Say plainly to leave it off, and that the sentence only explains what would happen. |
| Procedure step 5, "Pick Save to File... for a plain" | Four destinations and no hint which to choose on a first try. | Name the one to pick the first time. |
| Procedure, "If every position in the scope" | If every position failed, what should I lower the floor to? No second value is offered. | Suggest a number to try next. |
| Settings, "None of them has a command-line" | I have never opened a terminal, so this told me nothing and made me wonder whether I had missed a required step. | Move this to the command-line section. |
| Settings, "Consensus Mode. Chooses how the" | Bayesian is a statistics word I have heard but cannot define. The paragraph explains the behavior, not the name. | One clause saying the name just means it uses the quality numbers. |
| Settings, "Use IUPAC ambiguity codes. Writes a" | I did not know what R or Y stood for until much later in the chapter. | Give one example inline, R means A or G. |
| Settings, "Hide high-gap sites. Masks columns" | The setting masks gaps, then the reason to use it mentions spurious insertions. I could not reconcile gap and insertion. | Use one word consistently. |
| Settings, "Consensus minimum depth. Sets how many" | I do not know how to choose within 1 to 50. The text gives 8 and "raise it" but no second landmark. | Give one more anchor, such as what 20 buys you. |
| Settings, "Consensus minimum MAPQ. Ignores reads the" | I could follow 0 and 60 but not what 20 means in between, and the advice says raise to about 20 without saying what that rules out. | Say roughly what share of reads a 20 floor discards. |
| Settings, "Consensus minimum base quality. Ignores individual" | The same paragraph says Bayesian mode already down-weights low quality, so I could not tell whether raising this double counts. | Say whether the two interact. |
| Settings, "Two further filters reach the consensus" | "Alignment tab of the Inspector's View Settings section" is a third nested location. I lost track of where I was in the interface. | A single map of the Inspector early in the chapter. |
| Settings, "which read groups and which flagged" | Read group and flagged record are both new, and flagged record is not in the glossary list. | Gloss flagged record. |
| Reading the results, "Running the fixture's alignment at the" | I had to work out the 500,001 off-by-one myself. I got there but it slowed me down. | State the arithmetic once. |
| Reading the results, "The `N` count is the number" | This is the first time conflict, not just thin depth, is named as a cause of `N`. Settings said `N` meant too few reads. | Mention both causes where `N` is first defined. |
| Reading the results, "As a share of the slice" | 724 plus 271 is about 0.199 percent that is not a plain base, so "more than 99.8 percent came back as a called base" left me unsure whether asterisks count as called. | State whether asterisks count as called. |
| Reading the results, "Comparing the consensus letter by letter" | 608 differing positions against the 961 variants quoted earlier. Nothing explains the gap. | Say why the two numbers differ. |
| Reading the results, "The pileup there holds 51 read" | 51 versus a total depth of 63. I did not know what makes a read unusable, or which number the depth slider compares against. | Say which number the depth floor uses. |
| Reading the results, "A position where every read carries" | Alternate is used as a noun for the first time here. I know homozygous from class, not alternate in this sense. | Gloss alternate at first use. |
| Reading the results, table row "Use IUPAC ambiguity codes turned on" | The column is headed `N` count, and this row's number falls for a different reason than the others. I first read it as the setting improving coverage. | A short note in the row saying the drop is a relabeling, not more data. |
| Reading the results, "Raising the depth floor from 8" | 724 to 5,339 is about seven and a half times. I checked the arithmetic because "sevenfold" did not sit right. | Say "more than seven times". |
| Reading the results, "Those ambiguity letters were `R` 184" | 184 plus 191 plus 178 is 553, which matches the drop, but I had to add it up to see that the sentences connect. | Say the three numbers sum to 553. |
| Reading the results, "It lists the scope, the region" | Caller mode appears here but the control is named Consensus Mode. I was unsure they were the same thing. | Use the control's name. |
| Reading the results, "two fixed policies reading Low-depth policy" | I could not tell whether these are settings I could change somewhere or facts about the app. | Say they cannot be changed. |
| What good looks like, "There is no universal threshold, so" | I have no previous run to trust. This is my first one. | Say what a first-time user should compare against. |
| What good looks like, "the coverage curve above the read" | First mention of a coverage curve in this chapter. I did not know one was on screen. | Name it in the Procedure where the viewport is first described. |
| On the command line, "the command the operation history records" | I could not tell whether `Lungfish.app alignment consensus` is something I should ever type. I read the sentence three times. | Say outright that you never type this. |
| On the command line, code block | I have never opened a terminal, so the block was inert, and the trailing backslashes looked like typos. | A note saying terminal users only, skip this. |
| On the command line, "`--threshold` is the minimum share of" | A fourth kind of threshold, measured on a different thing than the three in Settings. I finished unsure which threshold is which. | A one-line table of the thresholds and what each counts. |
| On the command line, "The same action appears in the" | So there are two consensus buttons in the app. I no longer knew which one I had used. | Say early that the two are different features. |

One thing I learned: an `N` in a consensus means nobody looked, not that the position matched the reference, so counting the `N` characters is an honest measure of how much of the sample you really observed.

One thing I still could not do: find the Consensus tab. Step one asks me to click an alignment track in the sidebar, I do not know what that row looks like, and so I never reached any of the controls the chapter explains so carefully.

The sentence I liked most: "A variant caller that finds nothing at a position is silent, and silence means either that the sample matched the reference or that no reads were there to say."
