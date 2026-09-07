# Reader report: Reading an Alignment

Reader 3. Pre-med student, English is my second language, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "A BAM file is a long..." | I do not know what BAM stands for. The link is there but I wanted the words in the sentence. | Say the words "Binary Alignment Map" once in the sentence. |
| What it is, "Each row records which read..." | "read" is used as a noun here for the first time in this chapter and never explained. In my language this word is a verb. I read it three times. | Gloss "read" as one short piece of sequenced DNA at first use. |
| What it is, "which of the two DNA..." | "the mapper" appears with "the" as if I already met it. I did not meet it in this chapter. | Say "the mapping program" once before calling it "the mapper". |
| What it is, "A table with ninety thousand..." | Ninety thousand rows, but later the chapter says 90,935 and 91,148 and 90,990. I could not tell if these are the same table. | Say which count the ninety thousand refers to. |
| What it is, "Zoomed all the way in it draws..." | I did not know the viewport changes by itself. I expected a button. I read this twice. | One clause saying no button is involved. |
| What it is, "LGE picks the picture from how many..." | "bases per pixel" as a unit. I do not know if a bigger number means more zoomed in or less. | Say which direction is zoomed in. |
| What it is, "Above roughly 2 bases per pixel..." | The message shows "<= 2.0 bp/px" but the sentence says "Above roughly 2". Above and less-than-or-equal look opposite to me. | Make the sentence and the quoted message agree. |
| What it is, "pale blue for a read that aligned as sequenced" | "as sequenced" versus "as its reverse complement". I know reverse complement from genetics class but "aligned as sequenced" I could not picture. | Say forward strand and reverse strand plainly. |
| What it is, "Read ends the mapper set aside..." | The sentence is long and "set aside" is idiomatic to me. I read it three times before I understood soft clips were the subject. | Split into two short sentences. |
| Why you would do this, "or an artefact of the sequencing chemistry" | "artefact" is a hard word and it is central to the chapter. It is not glossed. | Gloss artefact as a false signal made by the method. |
| Why you would do this, "human Illumina reads from a genome" | I do not know what Illumina is. It is a company name used like a technique. | One clause saying it is a sequencing platform. |
| Why you would do this, "mapped onto a 500 kb window" | "kb" is not spelled out anywhere in the chapter. | Spell out kilobases at first use. |
| Why you would do this, "This chapter works through the HG002" | I do not know what HG002 is at this first mention. | Say HG002 is a named reference human sample. |
| Before you start, "Download the files GRCh38.chr20..." | Three long filenames and a long URL. I could not tell if I need all three or only the fasta. | Say all three are required. |
| Before you start, "and pick a BAM, CRAM, or SAM file" | CRAM and SAM appear with no gloss. I only know BAM from the first paragraph. | One clause each saying they are the same data in other formats. |
| Before you start, "because random access into the middle" | "random access" is computer vocabulary I do not have. | Say jumping straight to one region without reading the whole file. |
| Before you start, "LGE reads alignments by running" | I have never opened a terminal, so I do not know what "running a program" means from inside an app. | Say LGE calls a helper tool in the background. |
| Before you start, "That program comes from the Required" | The Required Setup pack is capitalised and introduced with "the" as if I know it. I did not know where it lives until the next clause. | Name the Plugin Manager before the pack name. |
| Procedure step 1, "Click the minimap2 Mapping track" | I did not know a "reference bundle" is a thing in the sidebar. It is not defined in this chapter. | Gloss reference bundle at first use. |
| Procedure step 2, "Hover any point for a tooltip" | The word Depth appears twice in one clause with two meanings, the label and the number. Hard to parse. | Show the tooltip as one quoted example line. |
| Procedure step 2, "Once you zoom in far enough" | I did not know whether the mean is over the visible window or the whole file. | Say over which range the mean is taken. |
| Procedure step 3, "Choose Sequence > Go to Location..." | The sentence is very long with three alternative methods joined by commas. I lost the thread and restarted. | Break the alternatives into separate sentences. |
| Procedure step 3, "Then press Cmd-= to zoom" | Cmd-- is written with two hyphens. I could not tell if that is Command plus minus or a typo. | Write Command and the minus key in words. |
| Procedure step 3, "Keep zooming until each read" | I do not know how many presses that is. No number is given. | Give an approximate bases per pixel target. |
| Procedure step 4, "A reference-base row sits under" | I expected the reference row in the three-band description at the start, which never mentioned it. | Add the reference row to the three-band list earlier. |
| Procedure, the step numbers | The list goes 1, 2, 3, 4, then 6. There is no step 5. I thought I had missed something. | Renumber the steps. |
| Procedure step 6, "then writes every read overlapping" | "overlapping" could mean fully inside or partly inside. I could not judge which. | Say partly inside counts. |
| Procedure step 6, "into a .lungfishfastq bundle in the" | I do not know what a bundle is on disk. One file or a folder? | Say whether it is one file or a folder. |
| Procedure step 6, "choose Copy as FASTA (aligned orientation)" | "aligned orientation" versus "original reads". I could not tell which one I should use for what purpose. | One clause per option saying when to pick it. |
| Procedure, "If you select many reads at once" | I do not know how a read can have an empty stored sequence. It felt like a warning I could not act on. | Say briefly why some records have no sequence. |
| Settings, "None of them changes the BAM on disk" | The clause about scripting a run assumes I script things. I do not, and I read it twice for nothing. | Say plainly these settings are not saved into outputs. |
| Settings, Minimum alignment confidence, "On this fixture almost nothing disappears" | I do not know the scale of mapping quality. Is 60 always the maximum, or only here? | Say the scale runs 0 to 60. |
| Settings, Minimum alignment confidence, "and only 165 fall below 30" | I do not know whether 30 is a meaningful threshold or a number the author picked. | Say what 30 means. |
| Settings, Coverage scale, "Switch to Log10 or Square root" | I know logarithms from class but I could not picture what the curve would look like after switching. | Say tall peaks get shorter and small ones stay visible. |
| Settings, Coverage scale, "A compressed axis is labelled" | "labelled as such" is vague. Labelled where, with what words? | Quote the label text. |
| Settings, Include secondary alignments, "It is off by default, and on this" | If the mapping run excluded them, I could not tell whether turning the toggle on does anything at all. | Say the toggle cannot bring back what was never written. |
| Settings, Include supplementary alignments, "This fixture carries 55 supplementary" | "primary" is used here for the first time and not glossed, though secondary and supplementary both are. | Gloss primary alignment. |
| Settings, Read display budget, "and raise it toward its ceiling" | The ceiling is 500,000 here but two million in the banner section. Two different ceilings confused me. | Reconcile the two ceiling numbers. |
| Settings, "(the selected region)." | A setting whose name is a parenthesis. I could not tell if this is a real control name or a placeholder. | Name it in plain words. |
| Settings, "On the command line this is --region" | The section opened by saying none of these settings has a command-line flag, then gives one here. | Remove the contradiction. |
| Reading the results, "Every number in this section was" | I could not tell whether my own numbers should match these exactly or only roughly. | Say whether the reader should expect identical numbers. |
| The coverage curve, "Mean depth across the 500 kb slice" | A percentage and raw counts are both given and I could not check they agree without a calculator. | Give one form, not both. |
| The coverage curve, "Depth is the number of reads covering" | I could not follow the reasoning that connects ten reads to one error outvoting the truth. | One sentence of arithmetic. |
| The coverage curve, "A shotgun library like this one dips" | I know GC content from class but the chapter never uses the term, so I was not sure it was the same idea. | Use the term GC content. |
| The pileup, "Position 2,078 of the fixture carries" | "benchmark" is used as a name for a dataset. In my English a benchmark is a test you run. | Say a trusted list of known differences. |
| The pileup, "Twenty-four of those reads run forward" | 24 plus 27 is 51, which matches, but I had to check with a pen to be sure nothing was missing. | Say the split adds to the fifty-one. |
| The pileup, "which is as even a split as fifty-one" | I did not know whether a split like 35 and 16 would still be acceptable. | Give a rough acceptable range. |
| The pileup, "The allele frequency is 51 out of 51" | In my genetics class allele frequency is a decimal between 0 and 1 in a population, not a fraction of reads. | Say this is the read-level fraction, not the population one. |
| The pileup, "which is what you expect when both" | This is the homozygous case but the word homozygous is never used, so I had to supply it myself. | Use the word homozygous. |
| The read stack, "and the sample is a fixed stride" | "stride" is unfamiliar to me in this sense. | Say every Nth read. |
| The read stack, "Showing 50,000 of 620,000 reads in view" | The fixture has about 91,000 reads, so 620,000 made me think I had the wrong file open. | Say the banner example comes from a different dataset. |
| The read stack, "Escape clears your selection the rest" | I could not tell what happens if I press Escape by accident during a load. | Say the load can simply be restarted. |
| The Selected Read panel, "It reports the read's base qualities" | "Q" alone is not defined until the next sentence, and even then only Q20. | Define Q as a quality score first. |
| The Selected Read panel, "Q20 means a one in a hundred" | I could not tell whether a higher Q is better or worse. | Say higher is better. |
| The Inspector summary, "For this fixture those read 90,990" | This is a fourth different total. I now have ninety thousand, 90,935, 90,990 and 91,148 and cannot reconcile them. | Say in one place which count is which. |
| The Inspector summary, "the number of Chromosomes, and, for" | "Est." is abbreviated. I guessed estimated but was not certain. | Spell out estimated. |
| The Analysis tabs, "The Inspector's Analysis section is where" | A grid that shows one tab at a time sounded contradictory to me. | Describe it as six buttons. |
| The Analysis tabs, "Filtering holds Mark Duplicates in Bundle" | Six operations are listed with no explanation of any of them. I did not know which I would ever need. | Say each is covered in a later chapter. |
| Launching from the Inspector, "Launching from the Inspector opens the" | The phrase "rather than necessarily the one you had selected" is a double negative for me. I read it three times. | Split into two sentences. |
| What good looks like, "Check that the coverage curve has" | "contig" is linked earlier but I still did not know whether my 500 kb slice is one contig. | Say this fixture is a single contig. |
| What good looks like, "Zooming in on the edges of the gap" | I could not picture how the unmappable case differs in the same terms. | Say the unmappable case has reads thinning out gradually. |
| What good looks like, "On this fixture 6,308 of the 90,935" | The section is called what good looks like, but 7 percent is only called ordinary. I could not tell the pass mark. | Say the pass threshold. |
| On the command line, "The viewport settings are the picture" | This metaphor stopped me because I could not extract an instruction from it. | State it plainly. |
| On the command line, the bash code block | I have never opened a terminal. The chapter never says where to type this or that I may skip the whole section. | One line saying this section is optional. |
| On the command line, "--bam HG002.sorted.bam" | This filename never appeared before. My mapping output was called "minimap2 Mapping". | Say where to find the BAM path. |
| On the command line, "That run reports Extracted 91148 reads" | The sentence says this matches the Inspector, but the Inspector was said to report 90,990 Total Mapped. | Reconcile the two numbers. |
| On the command line, "Four flags are worth knowing beyond" | Four flags packed into one paragraph with no breaks. I could not hold them in my head. | Use a short list. |
| On the command line, "In Preview 2026.9.13 the --region flag" | The example above uses a --region value full of dots and dashes. I could not tell if that counts as "bare". | Say the example name is the whole contig name. |
| On the command line, "The reads in an alignment can also" | The chapter says LGE installs samtools, but not how I would reach it from a terminal. | Say where the installed tool lives. |

The one thing I learned. A difference between the reads and the reference is only believable when it appears on reads running in both directions, in the middle of those reads, and on reads the mapper placed confidently.

The one thing I still could not do. Reconcile the four different read totals in the chapter, so I could not tell which number my own alignment should be compared against.

The sentence I liked most. "Silence from a caller looks the same whether the region matched the reference perfectly or was never sequenced at all."
