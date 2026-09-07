# Reader report: Alignment Quality

Reader 3. Pre-med student, English is my second language, genetics course
done, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "An alignment that holds the right" | The first sentence is long, and the shape "is not yet an alignment you can call variants from" made me read it three times before I understood it. | Start with a short plain sentence saying what this chapter checks. |
| What it is, "Between a finished mapping run and" | "Between X and Y sit three questions" is inverted word order. I did not see the verb until the end. | Write it in normal order so the subject comes first. |
| What it is, "Ten reads showing the same change" | I do not know if ten reads is a rule for every project or only for human data. The chapter later says under 10x is too little, so is 10 bad or borderline? | One sentence saying the ten-read figure is a rough floor for human shotgun data. |
| What it is, "LGE runs `samtools markdup` for this" | `samtools markdup` is written like code but I do not know if I must type it. Nothing says it runs automatically. | Say plainly that LGE runs this program for you and you never type it. |
| What it is, "on a Phred-like scale" | "Phred-like" is not glossed anywhere in this chapter. I have heard of quality scores but I cannot say what Phred means. | Gloss Phred at first use, one clause. |
| What it is, "A MAPQ of 60 is the usual maximum" | If 60 is only the usual maximum, what decides it, and is 60 from one mapper the same as 60 from another? | Say which mapper gives 60 and whether the scale is comparable between mappers. |
| Why you would do this, "calls a variant that actually belongs" | "paralogous copy" is not glossed and is not in the glossary list at the top. This sentence is the hardest in the chapter. | Gloss paralogous, or say "a near-identical copy of the sequence elsewhere". |
| Why you would do this, "Marking on amplicon data throws away" | I could not tell if "throws away the run" means LGE deletes my data or that the result is useless. That difference is frightening. | Say the data is not deleted, only the numbers become meaningless. |
| Before you start, "Download the reference file `GRCh38.chr20.10.0-10.5Mb.fasta`" | The file names are very long and I could not tell which one is the reference and which are reads without counting the R1 and R2. | Label them in a short list, reference then read 1 then read 2. |
| Before you start, "No extra tool pack is needed beyond" | "tool pack" appears only here. I do not know what a tool pack is or where I would have installed one. | Gloss tool pack, or point to the chapter where it was installed. |
| Before you start, "One thing to know before you start" | "LGE holds a lock on a bundle" is a computing metaphor I had to guess at. | Say the bundle is busy and other runs must wait. |
| Read the alignment statistics, step 2, "Read the five figures at the top" | Chromosomes reads 1 for my file, but I have 500 kb of chromosome 20, not a whole chromosome. I could not tell if 1 is correct. | Say that a slice of one chromosome counts as one sequence. |
| Read the alignment statistics, step 2, "and **Est. Coverage** is the estimated" | It says estimated but never says why it is only an estimate or how far off it can be. Later the chapter gives 44.7x and 44.72x as if exact. | One clause on what makes it an estimate. |
| Read the alignment statistics, step 4, "The rows that matter for this chapter" | Four row names are given but three of them are never explained here, only `duplicates` is used later. I did not know what `primary` counts versus `supplementary`. | Gloss the four rows in one line each, or point forward to Settings. |
| Read the alignment statistics, step 4, "Counts that failed the instrument's own" | I do not know what the instrument's own quality check is, and orange text is described but I do not know if a large orange number is bad. | Say what a normal orange count looks like. |
| Read the alignment statistics, step 5, "A single contig soaking up nearly all" | "contig" is used here for the first time in the Procedure and is not glossed in this chapter. "Soaking up" is an idiom I had to translate twice. | Gloss contig and use a plain verb. |
| Mark duplicates, step 1, "Switch the Inspector to the View" | Step 1 of the first procedure said the Bundle tab fills with the summary. Now I must switch to a View tab. I could not picture where these tabs are relative to each other. | Say where the Inspector tabs sit in the window. |
| Mark duplicates, step 2, "Click **Mark Duplicates in Bundle Tracks**" | The sheet says the old tracks are replaced, and step 4 says the old entries are gone. But the chapter's theme is that LGE never destroys the source. I could not reconcile the two. | State clearly whether the original unmarked BAM is recoverable. |
| Mark duplicates, step 2, "The button title is literal." | I did not understand this sentence at all on the first read. | Delete the metaphor and just warn that every track is processed. |
| Mark duplicates, step 5, "Re-read the Flag Statistics list" | I did not know whether 1,684 is a good or a bad number until I reached a much later section. | Give the percent here, or say the good news is explained below. |
| Derive a filtered alignment, "Stay on the Analysis section's **Filtering**" | This procedure is a paragraph, while the two before it are numbered steps. I lost my place twice while clicking. | Number these steps like the others. |
| Derive a filtered alignment, "Pick the alignment you want to filter" | I had to jump forward to a different section for the settings and then come back. I did not know how far to read. | Name the exact settings to change here, or move Settings above Procedure. |
| Derive a filtered alignment, "Type a name into **Name for New Alignment**" | I do not know what comparing the two tracks looks like. Do two viewports open side by side, or do I switch back and forth? | Say what the comparison view actually shows. |
| Export a deduplicated bundle, "Marking flags duplicates without deleting them" | "sibling `.lungfishref` bundle" is a metaphor for a file location that I did not know. | Say it is written next to the current bundle in the same folder. |
| Settings, "Neither duplicate-marking button opens a dialog" | Only one duplicate-marking button was described in the Procedure. I looked back for a second one and could not find it. | Name both buttons here. |
| Settings, "**Starting Alignment.** Chooses which alignment" | Every setting ends with a command-line flag. I have never opened a terminal, so I did not know if I was allowed to skip these lines. | Say once at the top of Settings that these lines are for terminal users only. |
| Settings, "**Minimum alignment confidence.** Drops reads whose" | The stepper range goes to 255 but the chapter says 60 is the usual maximum. I did not know what values above 60 would ever do. | Say values above 60 are unusable with most mappers. |
| Settings, "**Duplicate handling.** Decides what happens to" | Hide and Remove sound almost the same to me, and the difference is buried in a clause about running the marking step first. | Give the two options one short contrast sentence each. |
| Settings, "**Minimum identity to reference (%).** Keeps only" | I do not know if 95 percent is strict or loose for human data. Ninety-five sounded very strict to me. | Say what percent identity a normal human read reaches. |
| Reading the results, "Total Mapped of 90,990 on the" | Records versus reads is the key idea of this whole section but the difference is only explained by the arithmetic that follows. | Define record and read side by side in one sentence before the numbers. |
| Reading the results, "The Flag Statistics list reports 91,203" | I read this paragraph four times. The two subtractions and the coincidence sentence lost me completely. | Put the four numbers in a small table instead of prose. |
| Reading the results, "Both 90,990 out of 91,203" | If the matching percentage is a coincidence then I do not know what I was supposed to learn from the paragraph. | Say in one line what the reader should check in their own data. |
| Reading the results, "Est. Coverage of 44.7x is the" | The odd number 500,001 made me think I had misread the file name, which says 10.0 to 10.5 Mb. | Say why the count is 500,001 and not 500,000. |
| Reading the results, "and a slice averaging 200x on" | "You got a bargain" is an idiom. I understood the warning only from context. | Replace the idiom with a plain clause. |
| What duplicate marking changed, "This is the point where the" | I have never heard the old advice being corrected, so I did not know what the correction was against. | Say plainly that depth does not change after marking, without referring to advice I do not know. |
| What duplicate marking changed, "The app does hide them in" | This names an Include duplicate-marked reads control in View Settings that no procedure step showed me. I did not know where to find it or how to turn it back on. | Point to where View Settings lives. |
| What duplicate marking changed, "Measured directly on the fixture, the" | Earlier the Inspector said 44.7x and here it is 44.72x measured directly. I could not tell if these are the same number or two different measurements. | Say the Inspector rounds. |
| What filtering changed, "Filtering the marked HG002 alignment with" | The four dropped groups add to 2,096, but duplicates and supplementary records might overlap and I could not check the arithmetic myself. | Say whether the categories can overlap. |
| What good looks like, "Depth is an average, so also" | Coverage breadth appears here for the first time as a number with no explanation of how to see it in the app. | Say where breadth is displayed. |
| What good looks like, "A rate above 80% on" | The double negative "means nothing at all went wrong" stopped me. I first read it as "nothing is right". | Rewrite it as a positive statement. |
| What good looks like, "Confirm the placements are confident." | I could not find where in the app I would see the MAPQ distribution. The Inspector figures listed earlier do not include it. | Say which screen shows MAPQ counts. |
| On the command line, "Every step above has a" | I have never opened a terminal and the chapter never says whether I can stop reading here. | One line telling GUI readers this section is optional. |
| On the command line, "It replaces the input BAM with" | This destroys my file, which contradicts the earlier promise that LGE never edits the source. I found this alarming. | Flag the contradiction with the GUI behavior explicitly. |
| On the command line, "`--sort-threads` sets how many threads" | "Threads" is not glossed and I do not know what number to pick or if the default is fine. | Say the default is fine and move on. |
| On the command line, "On the fixture bundle the run" | 89,519 here and 89,107 in the filtering section are close but different, and I could not remember why without scrolling back. | Say in one clause why the two counts differ. |
| On the command line, "One more `bam` subcommand belongs in" | The last paragraph introduces a new command with no example line, unlike every command before it. | Add the example command or drop the paragraph. |

The one thing I learned. PCR duplicates are copies of one original DNA
fragment, and counting them as separate evidence makes a variant caller more
confident than the sample deserves.

The one thing I still could not do. Derive a filtered alignment, because
that procedure is a paragraph that sends me to a different section for the
settings and then never numbers the clicks.

The sentence I liked most. "In an amplicon library every read from a given
amplicon starts at the same primer position by design, so duplicate
detection flags most of the data as duplicated when nothing is wrong."
