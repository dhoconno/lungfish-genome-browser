---
role: undergraduate-reader
persona: sophomore, one genetics course, never opened a terminal, never used sequencing software
chapter: docs/user-manual/chapters/06-classification/09-novel-virus-detection.md
date: 2026-09-07
---

# Reader 1 report on Novel Virus Diagnostics

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "reaches the same goal as a read classifier" | The chapter assumes I already know what a read classifier is and what its goal is. The prereq chapter is named in the front matter, which is not something I read. | Say in one clause what a read classifier does before comparing NVD to it. |
| What it is, "a database of known nucleotide sequences" | Which database? I could not tell whether it holds everything ever sequenced or some curated subset, and that changes what a miss means. | Name the database once, for example NCBI's nucleotide collection. |
| What it is, "carries far more evidence than one match" | Read twice. I could not tell whether more evidence means a better score, more confidence, or both. | State that a longer aligned region makes a chance match far less likely. |
| What it is, "matches it at low sequence agreement" | The number that measures this, percent identity, is not named until many screens later, so the idea and the column never got connected for me. | Use the phrase percent identity here. |
| What it is, "written in Snakemake" | Snakemake is glossed, but I still could not tell whether I need to install or run it. The sentence made me think I was missing software. | Add that you never install or run Snakemake to follow this chapter. |
| What it is, "a folder named `05_labkey_bundling/`" | I do not know what labkey is, and the 05 made me think folders 01 through 04 were missing from my download. | Say the number is the pipeline's stage order and the other stages are not needed. |
| What it is, "`*_blast_concatenated.csv`" | The asterisk is never explained. I did not know whether the file is literally named that. | Say the asterisk stands for whatever prefix the run used. |
| Why you would do this, "a large comma-separated table" | Comma-separated and CSV are used for the same thing without ever being linked. | Gloss CSV as comma-separated values at the first file name. |
| Why you would do this, "one disclosure triangle away" | Disclosure triangle is macOS vocabulary I do not have. I could not picture the control until step 4. | Say it is the small arrow at the left of a row that opens the rows beneath it. |
| Why you would do this, "a checksum of the input file" | Checksum is not glossed and is not in glossary_refs. I do not know what it is or why it makes anything auditable. | Gloss checksum as a short fingerprint that changes if the file changes. |
| Why you would do this, "10 BLAST hit rows across 3 samples and 4 contigs" | On first read these were three unjudgeable numbers. Only much later did I learn hits should exceed contigs. | Add here that most contigs carry several ranked matches. |
| Before you start, "Download the folder `nvd-demo`" | I could not perform this step. A GitHub tree page has no button that downloads one subfolder, and I did not know what to click. | Say how to get the folder, for example download the repository zip and find the folder inside. |
| Before you start, "The folder you point the importer at is `nvd-demo/results`" | The step above names `nvd-demo` and this names `nvd-demo/results`, so I could not tell whether results is inside my download or something I make. | Show the folder layout so results is visibly inside nvd-demo. |
| Before you start, "No plugin pack is needed" | Plugin pack appears with no gloss. I did not know such a thing existed or why it would be needed. | Say plugin packs are the extra tool downloads other chapters use and this one needs none. |
| Before you start, "extracting the reads behind a contig" | I did not understand what extracting reads means or why I would want to. The BAM gloss explains BAM, not extraction. | Say extraction pulls the sequencing reads that built a contig into their own file. |
| Procedure step 2, "the preview reads experiment `100`" | I could not judge 100. Identifier or count? Both readings fit at this point. | Say the experiment identifier comes from the CSV's first column, as the Settings section later does. |
| Procedure step 3, "writes them into a small database" | I did not know LGE creates databases, and I could not tell whether I need to care about it. | Say the database is internal and you never open it directly. |
| Procedure step 3, "which is not where classification runs started inside LGE land" | Read three times. The phrase inside LGE land is confusing and the sentence packs a contrast, a location, and an exception together. | Split into two sentences, one for `Imports/` and one for `Analyses/`. |
| Procedure step 3, "The command line writes wherever `--output-dir` points" | I have never opened a terminal and the chapter has said nothing about one yet. A flag mid-procedure was disorienting. | Move the flag to the command line section and cross-reference it here. |
| Procedure step 4, "Six metric pills sit under that" | Metric pills is interface vocabulary I do not have. I could not picture them. | Say the six numbers appear as small rounded labels. |
| Procedure step 4, "Identity, E-value, Bit Score, Mapped Reads, RPB, and Length" | Six abbreviations at once, none explained until several screens later. RPB meant nothing at all. | Point forward to Reading the results in the same sentence. |
| Procedure step 4, "embeds the full alignment viewer over the reads" | I do not know what the alignment viewer is or shows, and over the reads is ambiguous. | Say it shows where each read sits along the contig. |
| Procedure step 5, "220 points tall to begin with" | I cannot judge a point. I do not know whether 220 is a thin strip or half the screen, and the number does not help me do anything. | Drop the numbers, or say a point is roughly a screen pixel at standard scaling. |
| Procedure step 5, "the sample's contig-sequence file" | Named but never described. I do not know its format or where it comes from, only that the demo lacks it. | Say a full NVD run writes a FASTA of the assembled contigs. |
| Settings, "a reader arriving from the registry" | I do not know what the registry is. This is its only mention in the chapter. | Drop the phrase or name the document it refers to. |
| Settings, "**--name.**" and "**--output-dir.**" | The whole Settings section is command line flags. Reading a Settings section holding nothing I can click was disorienting. | Say up front that these two settings exist only outside the app. |
| Settings, "The default is the current working directory" | Current working directory is terminal vocabulary and is not glossed. I could not tell what folder that would be. | Gloss it as the folder the terminal is pointed at when you run the command. |
| Settings, "`My Project.lungfish/Analyses`" | The project folder suffix appears first inside a code block. I did not know a project was a folder with an extension. | Mention the project folder suffix once in Before you start. |
| Reading the results, "The columns, left to right, are Sample, Contig, Length" | Fourteen names in one sentence. I lost track partway, and only seven get explained afterwards. | Break the list into a table, or say which ones the following paragraphs cover. |
| Reading the results, "longest first by default, and there is no sort control" | Read twice. By default implies I can change it, then the same sentence says I cannot. | Say the ordering is fixed at longest first. |
| Reading the results, "A contig of 5,000 bases aligning over 400" | I could judge the 500 over 498 case but not this one. Very different is asserted without saying what fraction should worry me. | Give a rough threshold, for example below half the contig length. |
| Reading the results, "run 99.5%, 96.0%, 99.0%, and 97.5%" | I could not match these four numbers to the four contigs. They are in an order I cannot reconstruct from anything above. | Name the contig beside each figure, or point to the command line table. |
| Reading the results, "A figure in the seventies or low eighties" | High nineties means known and seventies means novel, but nothing covers eighty-five to ninety-five, where I expected most real data to sit. | Say what the middle range means, or that it needs case by case judgement. |
| Reading the results, "the number of matches this good you would expect" | Read twice. It is a count of expected chance matches, but at first it read like a quality score. | Say it is how many hits this strong you would expect from a random database of the same size. |
| Reading the results, "down to `1e-90`" | I have not met scientific notation in this form. `1e-90` is used as a landmark value but never decoded. | Say `1e-90` is a decimal point, 89 zeros, and a one. |
| Reading the results, "at or under `1e-30` is effectively certain" | Sequence of this length is vague. Demo contigs run 200 to 500 bases and I could not tell which length the threshold assumes. | Name the length range the threshold applies to. |
| Reading the results, "a scale that does not shift with database size" | I understood the words but not why it matters, since the e-value paragraph never said shifting was a problem. | Say bit scores from searches run at different times stay comparable and e-values do not. |
| Reading the results, "a large drop from the first row to the second" | Large is never defined. What good looks like calls 750 to 660 gentle, but I still cannot tell what counts as large. | Give a rough figure, for example a drop of more than a quarter. |
| Reading the results, "the number of reads that mapped back to this contig" | Mapped is used without a gloss. My genetics course did not cover read mapping. | Gloss mapping as lining a read up against a sequence to find where it fits. |
| Reading the results, "50 mapped reads out of 1,000,000 total" | The sample's total read count appears nowhere else, not in the columns and not in the command line output, so I could not check the arithmetic or find the number in the app. | Say where the total read count is displayed, or that it is stored but not shown. |
| Reading the results, "one reads `clade`" | My course used clade to mean any branch of a tree, not a formal rank between genus and species. I had to reread. | Say clade here is a formal rank the pipeline uses when species is too specific. |
| Reading the results, "**Create Bundle…**, and **Run Operation…**" | Six menu items named, none explained. I do not know what a bundle is beyond a glossary link, or what Run Operation would run. | Say what Create Bundle and Run Operation do, or point to the chapter that covers them. |
| Reading the results, "through a save panel" | Save panel is macOS vocabulary. I would have said save dialog, and I paused on it. | Use save dialog, or gloss the term once. |
| Reading the results, "shows an em dash in grey" | I do not know an em dash by name, and this detail gave me nothing I could act on. | Say the cell shows a grey dash. |
| What good looks like, "the number of libraries that went into the run" | Library appears for the first time here with no gloss. In my course a library was a concept, not a countable thing to check against a card. | Gloss a library as one prepared sample loaded onto the sequencer. |
| What good looks like, "with hits at least equal to contigs since every contig has at least one match" | Read twice. Two uses of at least in one sentence made the parse hard. | Say the hits count can never be lower than the contigs count. |
| What good looks like, "step down gently from 750 to 660" | The same case is called the ambiguous shape and then reassuring. I had to reread to see that the shape is ambiguous but the content is not. | Split the shape claim and the reassurance into two sentences. |
| What good looks like, "may be an assembly artifact" | Assembly artifact is not glossed. I could guess but not confidently, and this is the check the section calls most important. | Say it means a sequence the assembler built by mistake out of noise. |
| What good looks like, "a deep and evenly distributed pileup" | Pileup is new and glossed nowhere in the chapter. It is the last word of the section that tells me how to make the final check. | Gloss pileup as the stack of reads sitting over each position. |
| On the command line, "The whole procedure runs headless" | Headless is not glossed. I guessed it means without the app window, but I was not sure. | Gloss headless as without opening the app. |
| On the command line, "`lungfish-cli nvd summary /path/to/nvd-demo/results`" | I could not perform this. Nothing tells me how to open a terminal, where `lungfish-cli` comes from, or whether the app installs it. | Point to the chapter that covers installing and opening the command line tool. |
| On the command line, "`/path/to/nvd-demo/results`" | I did not know I was meant to substitute my own path. The placeholder convention is never explained. | Say the placeholder stands for wherever you saved the folder. |
| On the command line, "`--top 20`" | The example passes the default value, so the example never shows what the flag changes. I was confused about why it was there. | Use a different value in the example, or drop the flag from it. |
| On the command line, "`sample_id`, `qseqid`, `qlen`" | These raw names match none of the display names in Reading the results, and no mapping is given. | Give the display name beside each raw name. |
| On the command line, "`--bundle` wraps the output as a `.lungfishfastq` bundle" | Two new things in one clause. I do not know what wrapping does or why I would want it. | Say a bundle keeps the reads together with the record of where they came from. |
| On the command line, "byte-identical output for the same selection" | Byte-identical told me nothing useful. I could not tell why identical output matters here. | Say the button and the command produce the same file. |
| On the command line, "it exits with status 1" | Exits with status 1 is terminal vocabulary. I do not know what a status is or where I would see it. | Say the command stops with an error and prints the message below. |

The one thing I learned is that RPB lets you compare two contigs from libraries of different sizes, because 50 reads out of a million and 100 out of two million mean the same thing.

The one thing I still could not do is get the demo folder, since GitHub does not let me download a single subfolder and the chapter does not say how.

The sentence I liked most is "A broad rank is not a defect."
