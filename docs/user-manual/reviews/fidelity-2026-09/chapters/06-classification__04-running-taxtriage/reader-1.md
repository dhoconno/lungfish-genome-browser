# Reader 1 report, Running TaxTriage

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "TaxTriage is a pathogen-detection..." | I do not know what a "workflow" is as a thing separate from a program. The chapter later says it is a Nextflow pipeline, but by then I had read three paragraphs assuming it was software I could download. | Say in the first sentence that it is a chain of programs run by another program, not a single app. |
| What it is, "then goes back over the organisms..." | "Gathers additional evidence" was too vague to picture. I only understood what evidence meant two paragraphs later at the mapping sentence. | Name the evidence right there, coverage and depth. |
| What it is, "It maps the reads that Kraken..." | I do not know what "maps" means here. Genetics class used mapping for gene positions on chromosomes, not for reads against a genome. | Gloss "map" the first time, the way "read" is glossed. |
| What it is, "measures how much of that..." | "How deeply" is not a quantity I can picture. Depth of what. | One sentence saying depth is how many reads sit stacked on one position. |
| What it is, "The upstream project does not publish..." | I had to read this twice. I could not tell whether the app is doing something wrong or whether this is only a naming footnote. | Split it, one sentence on the name and one on how to use the number. |
| What it is, "and each of its steps..." | The gloss says a container is a packaged copy of a program with everything it needs. I still cannot tell whether I have to do anything about that or whether it just happens. | Say plainly that Docker does this for you and you never touch a container by hand. |
| Why you would do this, "and read counts alone cannot..." | I do not know what a repetitive stretch is or why reads would pile onto one. | Half a sentence saying some genome regions look alike so reads land there by mistake. |
| Why you would do this, "because its extra mapping pass reports..." | Second time depth appears with no definition. Breadth is glossed here, depth never is. | Define mean depth where breadth is defined. |
| Before you start, "It needs Nextflow, which arrives with..." | I could not tell whether this means I already have Nextflow or whether I have to go install something. | Say directly that you already have it unless the indicator is orange. |
| Before you start, "so Docker Desktop must be installed..." | The chapter never tells me how to install Docker Desktop or where to get it. Everything else in the chapter tells me exactly where to click. | A link or one line saying where Docker Desktop comes from. |
| Before you start, "On macOS 26 and later..." | I do not know what Apple Containerization is, whether I have it, or whether it means I can skip Docker entirely. | Say whether this is automatic or something to switch on. |
| Before you start, "The size depends entirely on which..." | I cannot judge which database to pick from size alone, and PlusPF is never expanded or described. | Say what PlusPF contains, the way Viral is self-explanatory. |
| Procedure, "Every number quoted in this chapter..." | A forty-character string with no explanation of what it is or whether I have to type it anywhere. | One clause saying this is an automatic version stamp you never enter. |
| Step 1, "Click the FASTQ bundle holding the..." | I do not know what a "bundle" is or what it looks like in the sidebar. The word appears here with no gloss. | Gloss bundle at first use. |
| Step 1, "If either indicator is orange, the..." | If I saw "No container runtime available" I would not know what to install, since a container runtime is not a thing I could go shopping for. | Say the fix for that message is to install and start Docker Desktop. |
| Step 1, "The same check runs from the..." | I have never opened a terminal, so I could not tell whether this paragraph was a step I had to do or optional background. | Mark it optional here, the way the last section of the chapter is set apart. |
| Step 2, "The file names sit beside the..." | "Single-ended" is used with no gloss even though paired-end has one. I could not tell which kind mine is. | Gloss single-end, or say how to tell which you have by looking at the row. |
| Step 3, "Leave Sequencing Platform on Illumina, which..." | I could not work out how I would know this for my own data later on. | One clause saying the platform is recorded with the reads or on the run sheet. |
| Step 3, "Leave Skip assembly (faster) ticked, which..." | I do not know what assembly is. It is used here, in the Settings entry, and again as "de novo assembly" without ever being explained. | Gloss assembly at first use. |
| Step 4, "The reference run of these 83,591..." | Earlier the chapter said 86,281 paired-end read pairs. Two different counts for the same file, and I cannot tell which is right or why they differ. | Reconcile the two numbers, or say what was dropped between them. |
| Step 4, "and produced 106 output files." | I have no idea whether that is a lot or a little, or whether I am supposed to look at any of them. | Say which one or two files matter. |
| Settings, "Five controls sit in plain view..." | I counted five before K2 Confidence and six after, but the clause about the trailing colon made me reread the list twice to check I had not missed a control. | Drop the colon explanation or move it to a footnote. |
| Settings, "K2 Confidence:. Sets how much of..." | "A read that falls short is pushed up to a broader group" left me unsure what the broader group is or whether the read still gets counted. | Name the broader group, for example genus instead of species. |
| Settings, "Max memory:. Caps how much memory..." | I do not know how to find out how much memory my Mac has, so I cannot tell whether 16 GB is safe. | Point at where to look, or say the dialog stops you. |
| Settings, "Extra arguments:. Passes text straight through..." | I do not know what an unclosed quote is, because I never type commands. | Say to leave it empty unless somebody handed you exact text to paste. |
| Reading the results, "The viewport opens as a summary..." | Alignment is never explained in this chapter and is not in the glossary links at the top. I could not tell what the alignment pane shows. | One sentence saying it draws reads stacked against the reference. |
| Reading the results, "Abundance gives the proportion of the..." | Proportion of the library measured how, and is it a percent or a fraction. | Say the unit. |
| The reference run, "The pipeline's own organism detection report..." | The library was said to hold about 86,281 read pairs, so 163,031 aligned reads is nearly double that, and I could not tell whether that was an error or whether each pair counts as two reads. | Say explicitly that each pair contributes two reads. |
| The reference run, "The Kraken 2 step inside the..." | 82,234 assigned out of 86,281 leaves about four thousand pairs unaccounted for, yet only 1 read is called unclassified. I could not make those add up. | Say where the remaining pairs went. |
| A reporting gap, "On this pinned revision the viewport's..." | The whole chapter puts TASS on a 0 to 1 scale with 0.80 as high, then this sentence says the pipeline scored it at 99. I read it three times before I saw it was a different scale. | Convert it, for example 99 out of 100, which is 0.99 on the viewport scale. |
| A reporting gap, "Until the app is fixed, read..." | I do not know which file "the pipeline's own report" is or how to open it, and I would not know how to find it in a folder of 106 files. | Name the file, or point at the Open Report button described later. |
| Working with a single row, "That view shares the general alignment..." | No link, and I do not know where the general alignment viewer is described. | Link it the way the other chapters are linked. |
| Comparing several samples, "The overview lays out the organisms..." | "Value-facet control" is a phrase I have never seen and it is not glossed. | Call it a menu that chooses what the cells show. |
| What good looks like, "The reference run's row reported 165,500..." | The reference run section said 163,031 reads aligned. Now it is 165,500. Two numbers for the same row, and "after deduplication" appears here for the first time with no explanation. | Use one number, and explain deduplication where it first appears. |
| What good looks like, "which for a PCR-amplified library is..." | Two sentences earlier the chapter said a small unique fraction means you can only claim something in the group is present. Here the same shape is fine. I could not tell which rule applies to my own data. | Say that amplicon libraries are the exception and why. |
| On the command line, "lungfish-cli taxtriage run \\ --input..." | The tilde path in `--db` means nothing to me and I would not know how to find that folder. The section heading also does not say it is optional. | Mark the section optional at its heading, the way the chapter's opening promises. |

One thing I learned: coverage breadth is the number that separates a real detection from reads piled on one spot, and reading it before anything else is the habit this chapter is teaching.

One thing I still could not do: install and start Docker Desktop, because the chapter says the run will not start without it and never says where it comes from.

The sentence I liked most: "It is evidence that nothing was asked."
