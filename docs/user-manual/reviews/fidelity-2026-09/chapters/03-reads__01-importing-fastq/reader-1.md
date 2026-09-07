# Reader 1 report — Importing Sequencing Reads

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is — "Inside it sit the read" | "metadata file holding statistics measured from the reads" is the first use of metadata and it is never defined. Later the chapter splits metadata into technical and sample kinds, so I thought I had missed something. | Gloss metadata at this first use. |
| What it is — "It computes a checksum, a" | I understood the gloss but not why a fingerprint proves nothing changed. I read it twice. | One clause saying the fingerprint changes if any byte changes. |
| What it is — "It usually rewrites the reads" | "usually" left me unsure whether something I control decides this or whether it just happens. | Name the setting that decides it. |
| What it is — "It also covers an unmapped" | I do not know what a BAM file is. The sentence glosses unmapped but never BAM. | Gloss BAM at first use. |
| Why you would do this — "Mapping, quality control, trimming, classification," | Five operation names in one sentence, none defined. I could not tell whether I was expected to know them already. | Say these are each covered in later chapters. |
| Why you would do this — "The two files hold 45,574" | I know kb from genetics, but I could not tell whether 45,574 pairs over a 500 kb region is a lot of coverage or a little. | State the approximate coverage depth. |
| Before you start — "Download the files HG002.chr20.10.0-10.5Mb_R1.fastq.gz and" | The filename says 10.0-10.5Mb but the prose said 500 kb. I stopped to check these were the same thing. | Use one unit in both places. |
| Before you start — "Nothing here needs a plugin" | Being told what I do not need, for two things I had never heard of, confused me more than it reassured me. | Drop it or move it to the chapter that uses them. |
| How LGE decides two files — "The match is case-sensitive, so" | I do not know what case-sensitive means for filenames on a Mac, where I have always been told capitals do not matter. | One sentence saying LGE checks capitals even though the Finder does not. |
| How LGE decides two files — "A file whose mate is" | "no warning appears" alarmed me, and at that point I did not know how to catch the problem before importing. | Point at the summary counts in the same sentence. |
| Procedure step 3 — "Click the Sequencing Read Files" | Both fixture files end in .gz. I did not know whether to unzip them first. | Say gzipped files are selected as they are. |
| Procedure step 4 — "Read the Import FASTQ configuration" | I did not know what a configuration sheet looks like or whether it takes over the window. The screenshot is only a placeholder comment. | Say it is a panel that drops down over the project window. |
| Procedure — "Watch the progress in the" | I could not tell whether I must open the Operations Panel or whether the import runs without it. | Say the import runs whether or not the panel is open. |
| Settings — "Records which sequencing instrument produced" | Seven platform names and I recognise two. I could not judge which one applies to files a provider sent me. | Say the detected default is right in almost every case. |
| Settings — "Rounds each base quality score" | I do not know what 4-level and 8-level are counting. Four of what. | Say how many distinct quality values each keeps. |
| Settings — "Choose None when a downstream" | "a variant caller that models per-base error rates" packs three unglossed terms into one example. | Use a simpler example or defer it. |
| Settings — "Groups reads that share sequence" | I could not tell whether reordering changes my data. The Compression Tool paragraph then says Trim Galore does change the reads, which made me suspect this one does too. | State plainly that the order changes and the reads do not. |
| Settings — "It is resolved from the" | "resolved from" was the phrase I read three times. I could not tell who or what does the resolving. | Say LGE picks it automatically from file size and memory. |
| Settings — "A plain FASTQ import offers" | VSP2 Target Enrichment, Wastewater metagenomics, Illumina Amplicon Merge. I have no idea what any of them do or whether I want one. | One clause each, or a pointer to where they are explained. |
| Reading the results — "The top pane holds one" | "sparkline strip" appears here but sparkline is not defined until two paragraphs later. | Define it at first use. |
| Reading the results — "Mean Length and Median Length" | N50 is named as a card and as a table row but never explained, and it is the one length statistic I cannot guess from its name. | Gloss N50. |
| Reading the results — "and 248.6 against a 250-base" | "which the minimum of 35 bases confirms" points at a minimum, but no card in the list shows one, so I could not find that number. | Say where the minimum length appears. |
| Reading the results — "A Q30 figure below about" | A threshold is useful, but I could not tell whether it also applies to the Oxford Nanopore reads this chapter covers. | Say the threshold is for Illumina runs only. |
| Editing sample metadata — "For many samples at once," | This is a terminal command and I have never opened a terminal. Nothing says whether the app can do the same job. | Say whether a batch edit exists in the app. |
| What good looks like — "A count that is twice" | I had to reason out why a failed match doubles the count. Second read. | Say each file becomes its own bundle, so ten pairs read as twenty samples. |
| What good looks like — "Pass --force on the command" | The skip is described as something the app does, but the fix is offered only on the command line. | Say whether the configuration sheet has a matching control. |
| On the command line — "lungfish-cli import fastq \" | I do not know where lungfish-cli comes from or how to get it. The chapter never says. | Point to where the CLI is installed. |
| On the command line — "--project "$HOME/Desktop/lge-docs/LGE Manual" | The dollar sign and the backslashes at the ends of lines are unexplained. I would not know how to retype this correctly. | Say the backslash continues one command across several lines. |
| What a bundle holds afterwards — "A bundle from a paired" | Interleaved was earlier a setting I was told to use only when a file arrives that way. Now every paired bundle is stored interleaved. I could not reconcile the two. | One clause saying storage is interleaved regardless of the Pairing setting. |
| What a bundle holds afterwards — "Rather than holding its own" | "a manifest naming a root file and the operation to apply to it" is abstract, and virtual bundle is not glossed. | Gloss virtual bundle with a concrete case. |
| What a bundle holds afterwards — "To write one back out" | "materialize" is used as a verb and as a command with no gloss. | Gloss materialize. |

One thing I learned. Importing is not a copy. It is a measuring pass that produces a bundle carrying statistics and a record of where the reads came from.

One thing I still could not do. Judge whether Quality Binning should be on for my own data, because I do not know which of my later steps read exact quality values.

The sentence I liked most. "The bundle records all three, so six months later the reads still know what they are."
