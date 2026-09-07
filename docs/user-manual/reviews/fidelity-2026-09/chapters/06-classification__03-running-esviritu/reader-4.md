# Reader report: Running EsViritu

Persona: a student who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The collection EsViritu compares against holds..." | "Curated viral assemblies" is not glossed. In Geneious I downloaded genomes, not assemblies. I do not know if an assembly is a whole genome or a piece of one. | Gloss assembly at first use. |
| What it is, "which means finding for each read..." | I had to read the mapping sentence twice. "The position on a reference genome where it fits best" and "recording that placement" felt like the same act said twice. | Say it once. |
| What it is, "The tool that does the mapping is" | minimap2 is named but never explained. I do not know if I install it, choose it, or ever see it. | One clause saying it runs inside EsViritu and I never touch it. |
| What it is, "an off-target PCR product, or a stretch" | Off-target PCR product is used as if I know it. My genetics course covered PCR but never called anything off-target. | Gloss off-target PCR product. |
| What it is, "The viewport therefore draws a sparkline" | "Viewport" is used before anything says what a viewport is or where it appears. I thought it was a window until step 3. | Say the viewport is the result window before using the word. |
| Why you would do this, "a general-purpose reference collection spends" | I do not know what counts as a general-purpose reference collection or which one Kraken 2 uses here. | Name the specific broad database this compares against. |
| Why you would do this, "a QIAseq Direct amplicon library of paired-end" | Three unfamiliar things in one phrase. QIAseq Direct is a product name I have never seen and it is never explained or used again. | Drop the product name or say in a clause why it matters. |
| Before you start, "The reads themselves are too large" | I could not perform this. The chapter points at another chapter for downloading, but I do not know how long an SRA download takes or how big the file is, so I could not tell if I had time or disk space. | State the download size and rough time. |
| Before you start, "Open Tools > Plugin Manager... (Cmd-Shift-B) and install" | It says install Metagenomics but not how. There is no button named and no step. I clicked around guessing. | Name the control to click. |
| Procedure, "Every number quoted in this chapter came" | I do not know how to judge whether my own version differing from 1.3.3 or v3.2.4 matters. | Say whether a different version invalidates the numbers. |
| Step 1.2, "Plan for at least 8 GB of memory" | I do not know how much memory my laptop has or where to look. | Point at where the Mac reports its memory. |
| Step 1, "Outside the app, lungfish-cli esviritu db-status prints" | I have never opened a terminal. This block sits in the middle of the numbered install steps and I could not tell if I was supposed to run it or skip it. | Mark it as optional before the block. |
| Step 2.1, "Click the FASTQ bundle holding the SRR36291587" | I do not know what a bundle looks like in the sidebar or whether the two paired files appear as one item or two. | Say what a paired bundle looks like in the sidebar. |
| Step 2.3, "Pairing comes from the way LGE grouped" | This is the fix for a problem but it never says what a correct selection is. If mine says Single-end I still would not know what to select instead. | Say what to select to get a pair. |
| Step 2, "If you selected bundles for more than one sample, the Sample section becomes" | This paragraph mixes an advisory RAM warning and batch behaviour into one block after the steps, and I read it twice before realising neither applied to me. | Split the batch case out. |
| Settings, "where their labels carry a trailing colon on screen" | I had to read this twice. I could not work out why the manual was explaining its own punctuation to me. | Cut the aside. |
| Settings, "On the command line this is --sample." | Every setting ends with a flag I will never type. It made me think I had missed a required step. | Say once at the top that these lines are for the terminal only. |
| Settings, "Enable quality filtering (fastp)" | fastp is glossed by link but I still do not know whether unticking it is ever safe for me. "Untick it when the reads were already trimmed" assumes I know whether mine were. | Say how to tell if reads were already trimmed. |
| Settings, "and note that an unclosed quote blocks the run" | Unclosed quote means nothing to me since I would not be typing anything in that field anyway. | Cut or explain the quote. |
| Reading the results, "RPKMF is reads per kilobase of reference per million filtered" | I understood the words but not how to judge a value. The reference run shows 32,022.4 and I have no idea whether that is high. | Give a rough scale for RPKMF. |
| Reading the results, "Coverage is the mean sequencing depth along" | Depth and breadth arrive within two sentences of each other and I confused them for the rest of the chapter. | Define breadth first, then depth. |
| The reference run table, "Segment, em dash" | The table literally says the words "em dash" in a cell. I thought it was a value I was supposed to see on screen. | Show the character. |
| The reference run, "out of the 170,180 that survived the quality filter" | The 170,180 number appears from nowhere. Nothing earlier said where I would find how many reads survived the filter. | Say where that number is displayed. |
| The reference run, "The per-window coverage file divided the reference into 100 windows" | I do not know how to open the per-window coverage file or whether I need to. It sounds like a file only the terminal reaches. | Say whether I ever open this file. |
| The reference run, "the thinnest of them still averaged 319.4 reads deep" | I could not judge this. Is 319 deep good because it is high, or good because it is close to 1259? | Say what a thin window should be compared against. |
| Detail pane, "For a segmented virus, one whose genome comes" | I understood segmented but not how I would know in advance whether my virus is segmented. | Say the Segment column tells you. |
| Auditing, "it offers the same ruler, pan and zoom, read packing, and filters" | Read packing is not glossed. In Geneious I just saw stacked reads. | Gloss read packing. |
| Auditing, "It reads Structurally validated reference when the reference's contig" | Three Inspector messages are described but nothing says where the Inspector is or how to open it. | Say how to open the Inspector. |
| Auditing, "BAM M5 validated reference" | M5 is never explained. I could not tell whether I should worry when I do not see this one. | Gloss M5 or drop it. |
| Auditing, "The first two both let the mismatch and consensus displays work" | Mismatch and consensus displays are named here for the first and only time. I do not know what they show or where they are. | Name them earlier or cut. |
| Acting on a row, "A cell showing an ellipsis in the Unique Reads column" | I had to read this twice to connect the ellipsis back to the Recompute button. | Put the ellipsis sentence first. |
| What good looks like, "and a figure in the eighties means your reads" | The jump from high nineties to eighties leaves a gap. I do not know what a figure in the low nineties means. | Give one threshold rather than two examples. |
| What good looks like, "When Unique Reads is a small fraction of Reads" | Small fraction is not a number and I would not know where to draw the line. | Give a rough figure. |
| On the command line, whole section | I skipped it. Nothing at its top told me I could. | Say the section is optional. |
| On the command line, "currently report the version of the Python interpreter" | This says a displayed version is wrong. I could not tell whether that also makes the viewport numbers wrong. | Say the bug affects only the version string. |

One thing I learned: a read count alone is a weak claim, and the shape of the coverage along the genome is the evidence that turns it into a real one.

One thing I still could not do: tell whether my own run was good, because the chapter judges its own numbers but never gives me a threshold I could apply to mine.

The sentence I liked most: "Two hundred reads spread evenly along a 30,000-base viral genome and two hundred reads stacked on one 300-base stretch produce the same read count and mean completely different things."
