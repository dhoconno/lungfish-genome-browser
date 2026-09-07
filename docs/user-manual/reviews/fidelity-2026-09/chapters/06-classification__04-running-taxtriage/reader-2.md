# Reader report: Running TaxTriage

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The classification step is Kraken 2," | I have not read the Kraken 2 chapter and I do not know what a Kraken 2 database is made of. It sounds like a program and a data file at the same time. | One sentence saying a Kraken 2 database is a prebuilt collection of reference genomes the program compares reads against. |
| What it is, "measures how much of that genome" | "How deeply" is used before depth is defined. I pictured physical depth in a tube. | Gloss depth here the way breadth is glossed later. |
| What it is, "so treat the acronym as LGE names it" | I could not tell whether this is a warning that the score is untrustworthy or only that the name is unofficial. | Say plainly that only the name is unofficial and the number still works. |
| What it is, "It is a published Nextflow pipeline," | I understood the words but not why a pipeline needs a separate engine and containers when the other tools apparently do not. | One sentence saying the other classifiers ship as single programs and this one does not. |
| Why you would do this, "and read counts alone cannot separate" | I had to read this twice. The two organisms being contrasted are both described before I learn which one is the good one. | Name the good case first. |
| Why you would do this, "an organism whose reads all pile onto one repetitive stretch" | I do not know what a repetitive stretch is or why reads pile there. | Gloss repetitive region once. |
| Why you would do this, "a QIAseq Direct amplicon library of 86,281" | I do not know what an amplicon library is, and I do not know whether 86,281 pairs is a lot or a little. | Gloss amplicon library and say whether this count is typical. |
| Before you start, "which arrives with the Required Setup pack" | I could not tell whether I have to do anything. Does it install itself or do I check? | Say "you already have it, no action needed" if that is true. |
| Before you start, "so Docker Desktop must be installed" | I have never installed Docker and the chapter does not say where to get it or how to tell whether it is running. | A link or one line naming where Docker Desktop comes from. |
| Before you start, "On macOS 26 and later, Apple" | I do not know which macOS I have or what Apple Containerization is, so I cannot tell whether this sentence applies to me. | Say how to check the macOS version. |
| Before you start, "from 0.5 GB for Viral up" | I do not know what PlusPF contains, so I cannot judge whether 72 GB is ever worth it. | One clause saying what each named database covers. |
| Procedure, "with the pinned pipeline revision `e10bfeb" | That string is frightening and I do not know whether I need to type it anywhere. | Say that you never type it and LGE supplies it. |
| Step 1.1, "Click the FASTQ bundle holding the" | I do not know what a bundle looks like in the sidebar or whether the SRA download made one for me. | One clause saying the SRA download produces the bundle you select here. |
| Step 1.3, "A spinner in place of a" | I do not know how long to wait before deciding something is wrong. | A rough waiting time. |
| Step 1, "The same check runs from the" | I have never opened a terminal, so I could not tell whether this paragraph was an instruction I was skipping. | Mark it as optional in the sentence itself. |
| Step 2.1, "The file names sit beside the" | "Single-ended" appears here without a gloss although paired-end has one. | Gloss single-end at the same moment. |
| Step 2.2, "It offers Clinical Sample, Negative Control," | I know what a negative control is now, but not what distinguishes an environmental control from an extraction blank, and I would guess wrong at the bench. | One clause each. |
| Step 3, "The other two segments are Oxford" | I do not know what an error profile is. | Gloss it as the kind of mistakes that machine tends to make. |
| Step 3, "With it ticked the pipeline classifies" | Assembly has not been defined anywhere in this chapter before this line. | Gloss assembly at first use. |
| Step 4, "The reference run of these 83,591" | Earlier the chapter said 86,281 read pairs for the same sample. I could not tell which number is the sample, so I stopped trusting both. | Reconcile the two counts or explain what removed the difference. |
| Step 4, "Once those images are cached the" | I do not know which of the 106 output files I am ever supposed to open. | Name the two or three that matter. |
| Settings, "Every setting the TaxTriage dialog offers" | I had to read the trailing-colon explanation twice, and entries printed as "K2 Confidence:." still look like typos to me. | Nothing I can suggest in one sentence. |
| Settings, "Set it on every control you" | Samplesheet is used here and defined only in the command-line section I was told I could skip. | Move the gloss to first use. |
| Settings, "The default is 0.20 and the" | I do not know what 0.20 means physically. Twenty percent of what part of the read? | Say what the fraction is a fraction of. |
| Settings, "The default is 16 GB and" | I do not know how much memory my Mac has or how to find out. | Say where to look. |
| Settings, "The default is empty, and an" | I do not know what an unclosed quote is. | Say only that malformed text blocks the run. |
| Reading the results, "The viewport opens as a summary" | The alignment pane is named before I learn what it shows, and I only find out several sections later. | Say in one clause what it shows when it is first named. |
| Reading the results, "**Abundance** gives the proportion of the" | I do not know whether abundance is a fraction, a percentage, or a count. | State the units. |
| TASS bands table, "0.40 up to 0.80" | BLAST is the action the table tells me to take, but it is never explained in this chapter. | One clause saying BLAST compares a sequence against NCBI's database. |
| A reporting gap, "On this pinned revision the viewport's" | I could not reconcile a score of 99 with a band table that tops out at 0.80. Two scales are in play and I did not see that stated until I reread. | Say the pipeline's scale is 0 to 100 before quoting the 99. |
| A reporting gap, "Until the app is fixed, read" | I do not know how to find or open that report file from inside the app. | Point at the Open Report button, which appears two sections later. |
| Working with a single row, "That view shares the general alignment" | No link, and I do not know where the alignment viewer is documented. | A link. |
| Comparing several samples, "The overview lays out the organisms" | "Value-facet control" is not a phrase I have ever met and I could not picture it. | Call it a picker. |
| Comparing several samples, "An organism carrying a real score" | I do not know what subtracting them would have meant, so the contrast was lost on me. | Drop the contrast or explain it. |
| What good looks like, "The reference run's row reported 165,500" | The reference run section earlier said 163,031 reads aligned. Two different numbers for what reads like the same measurement stopped me completely. | Reconcile the two figures. |
| What good looks like, "which for a PCR-amplified library is" | Two sentences earlier a large Reads to Unique Reads gap was the warning sign, and here it is expected. I cannot tell which rule applies to my own data. | Say which situations exempt a sample from the rule. |
| What good looks like, "Rank by coverage breadth and by" | Given the previous entry, I no longer know whether unique reads is trustworthy for an amplicon library. | Resolve the conflict. |
| On the command line, "--input extract_1_R1.fastq.gz" | The file names in the example match nothing else in the chapter, so I could not tell whether this is the same data. | Use the same file names throughout. |

The one thing I learned: coverage breadth is the number that separates a real detection from a pile of reads sitting on one spot, and it is the first thing to read.

The one thing I still could not do: install and confirm Docker, which the chapter requires before anything else works and never explains.

The sentence I liked most: "It is evidence that nothing was asked."
