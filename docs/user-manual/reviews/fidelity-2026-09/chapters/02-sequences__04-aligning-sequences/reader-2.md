# Reader report: Aligning Sequences

Persona: senior undergraduate, two years of pipetting, no data analysis experience, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "positions descended from the same ancestral" | I know what an ancestor is but not what it means for a *position* to descend from one. I read the sentence three times. | One example showing the same base in two species tracing back to one base in a shared ancestor. |
| What it is / "Each row is one input sequence" | The word "residue" appears two paragraphs later and is never defined. I only know "base". | Gloss residue at first use as base or amino acid. |
| What it is / "Conservation at a column is" | The share of non-gap rows carrying the most common residue is arithmetic packed into one clause. I could not compute it until the A/G example arrived. | Put the worked example before the definition. |
| What it is / "LGE aligns with MAFFT and stores" | I do not know what a bundle being a folder shown as one file means for me. Can I email it? Open it elsewhere? | One sentence on what you can and cannot do with a bundle outside the app. |
| Why you would do this / "Their individual lengths run from" | I could not tell whether a 163-base spread is a lot or a little for mitochondrial genomes. | State that this spread is typical, so I know it is not a red flag. |
| Before you start / "Download the file `primate-mito.fasta`" | The link goes to a GitHub directory. I have never downloaded from GitHub and see no download button on such a page. | Say to click the file and then Download, or give a direct link. |
| Before you start / "Install it from **Tools > Plugin Manager...**" | I do not know what happens after the Plugin Manager opens. Do I search? Is there an Install button? How long? | Name the button I click. |
| Before you start / "The pack ships MAFFT 7.526." | I do not know whether that number matters to me or is only for the record. | Say it is recorded for reproducibility and needs no action. |
| Procedure step 1 / "Open the imported bundle so its" | I do not know how to select all five. Cmd-A? Drag? Click then Shift-click? | Name the keystroke, as the chapter does elsewhere. |
| Procedure step 2 / "Choose **Tools > Multiple Sequence Alignment**" | The window title reading FASTQ/FASTA Operations made me think I opened the wrong thing before the reassurance arrived. | Lead with the reassurance that the title is expected. |
| Procedure step 3 / "Check the **Sequences to align** picker" | I could not picture when the picker "replaces itself with a single line" or what that line says. | Say it happens when the file holds only one sequence. |
| Procedure step 5 / "Leave **Strategy** on **Automatic** and" | Reassuring, but then eleven settings paragraphs follow and I could not tell which I would ever touch. | A line naming the two settings a beginner is most likely to change. |
| Procedure / "MAFFT scores a gap as though" | I do not understand why that makes realigning bad. I accepted it on faith. | One clause saying old gaps get treated as real data and distort the result. |
| Import an alignment / "It reads aligned FASTA, Clustal, PHYLIP" | I have never heard of a2m or a3m profile formats and cannot tell if I should care. | Say they come from profile tools and most readers will not meet them. |
| Settings / Strategy / "Picks how hard MAFFT works" | I do not know what "the fast progressive method" means or what the alternative is. | Gloss progressive as adding sequences one pair at a time. |
| Settings / Strategy / "Move to L-INS-i when you have" | I have five sequences, so this is irrelevant, but I only worked that out by arithmetic. | Say plainly that with five sequences either choice works. |
| Settings / Strategy / "the automatic alignment leaves ragged gap" | I do not know what ragged looks like on screen versus normal. | Describe the visual, gaps scattered instead of in blocks. |
| Settings / Sequence Type / "Set it by hand when a" | I could not tell how a protein alignment scored as DNA would look to me. | Say what the symptom looks like in the viewport. |
| Settings / Direction Adjustment / "Lets MAFFT reverse-complement a sequence that" | Reverse-complement is not glossed. I half remember it from a lecture. | Gloss it as reading the sequence backwards on the other strand. |
| Settings / Symbol Policy / "Choose Allow Any Symbol when your" | Selenocysteine and stop codons are protein words in what I thought was a DNA chapter. | Say this only matters for protein alignments. |
| Settings / Threads / "Sets how many processor cores MAFFT" | I do not know what a thread is. I skipped this setting entirely. | Gloss thread as one of the parallel workers a computer runs at once. |
| Settings / Deterministic threading / "Clear it only when a large" | "byte-identical" is a computing word. I guessed it means exactly the same. | Say exactly the same file. |
| Settings / MAFFT Parameters / "Use it for a MAFFT option" | I do not know what a gap-opening penalty is, and this is the one setting where I cannot check my own work. | Say most readers should leave this empty. |
| Viewport display controls / "Numbering, the two consensus sliders, Mask" | I had not met "consensus sliders" before and did not know which two settings that means. | Name them, Low support and High gap. |
| Viewport display controls / "Mask, Reference, and Display live in" | I do not know where the Inspector is or how to show it. | One clause saying how to open the Inspector. |
| Settings / Low support / "On the command line this is" | I could not tell whether the 0.6 versus 0.5 mismatch is a bug I should worry about. | Say the difference is deliberate and does not change the on-screen view. |
| Settings / Name gutter width / "Widen it up to 640 points" | I do not know what a point is on my screen, or how I would know I hit the 160 floor. | Say the handle simply stops moving. |
| Export sheet / Sequences / "On the command line this is" | Two different flag names for one dialog row in one sentence. I could not follow which applies when. | Split into two sentences. |
| Reading the results / "Annotations carried by the source sequences" | I do not know what an annotation or a track is here, or where they appear. | Gloss annotation as a labelled feature such as a gene, and say where it draws. |
| The numbers / "The longest input sequence is the" | I checked the subtraction and it works, but the chapter earlier said gaps fill columns a row has nothing for, so "added to a row" felt like a second meaning. | State the subtraction explicitly so I can follow it. |
| The numbers / "Of those 17,247 columns, 5,053 are" | I checked that 29 percent is right, but "under a few percent" and "over about half" gave me no sense of where 29 sits. | Say plainly that 29 percent is comfortably in the good range. |
| The numbers / "The consensus built from this alignment" | I do not know whether 479 out of 17,247 is a low N count, which is exactly the judgement the sentence asks me to make. | Give the percentage and say it is low. |
| Pairwise identity / "It is the same arithmetic as" | This assumes I already read the percent identity glossary entry. I had not. | Restate it, the fraction of columns where two rows carry the same base. |
| Pairwise identity / "On this alignment the two macaques" | I could not find where in the app I see this matrix. The CLI has `msa distance` but I have never opened a terminal. | Name the menu or panel that shows the matrix in the app. |
| Pairwise identity / "The Inspector reports the alignment's own" | Being told not to expect what the manual promised left me unsure whether 0.926 is visible to me at all. | Say directly whether the identity matrix appears in the GUI. |
| Acting on a selection / "**Extract Selection to New Bundle...** writes" | I do not know how to select a block of columns. Clicking a name selects a row, but nothing covers columns. | Say how to drag-select columns. |
| Acting on a selection / "It enables only when more than" | Circular for me. I do not know how to get an annotation into a selection. | Say the selection must overlap an existing annotation. |
| What good looks like / "A missing row means an input" | First mention of the Operations panel, with the keystroke given only three paragraphs later. | Give Cmd-Shift-P at first mention. |
| What good looks like / "An even wash of low bars" | I have never seen a good conservation strip, so I have no baseline for a bad one. | Point to the screenshot, which shows the good case. |
| On the command line / "The block below reproduces the whole" | I have never opened a terminal. This is nearly a third of the chapter and I skipped all of it. | A line at the top saying GUI-only readers may skip. |
| On the command line / "Note that `msa export` defaults to" | This contradicts the Export sheet, where the default keeps gaps. I could not tell which is true for me. | Say the GUI and CLI defaults deliberately differ. |
| On the command line / "`lungfish msa` is a different command" | Every other line says `lungfish-cli`, not `lungfish`. I did not know whether these are two programs. | Use the same command name throughout. |
| On the command line / "`--parsimony-uninformative` for columns that carry no" | I do not know what parsimony is. | Gloss it, or say this option is for tree builders. |

One thing I learned. Aligning sequences is what makes a column exist, and a column is the unit that everything downstream, conservation, trees, and identity, actually counts.

One thing I still could not do. Find the pairwise identity matrix inside the app, which the chapter treats as the single clearest check that my run worked.

The sentence I liked most. "An alignment that says otherwise is telling you something went wrong with the run, not something new about primates."
