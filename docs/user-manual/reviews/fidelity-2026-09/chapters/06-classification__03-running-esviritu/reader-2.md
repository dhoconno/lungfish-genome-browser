# Reader report: Running EsViritu

Persona: a senior who has pipetted for two years but never analyzed data. I have
never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The collection EsViritu compares against holds" | "Curated viral assemblies" is not a phrase I know. Is an assembly a finished genome sequence, or something rougher? | Gloss assembly the first time it appears. |
| What it is, "EsViritu instead performs mapping, which" | I understood mapping, but I could not tell whether EsViritu maps against all 19,925 genomes at once or picks a few first. | One sentence saying what the tool maps against. |
| What it is, "The viewport therefore draws a sparkline" | Viewport is used as if I already know it. I think it means the big window that opens, but I was guessing. | Gloss viewport at first use. |
| What it is, "an off-target PCR product, or a stretch" | Off-target PCR product is left undefined. I have run PCR but I would not have connected it to a read pile. | A half-sentence saying it is amplified DNA from the wrong place. |
| Why you would do this, "A broad survey with Kraken 2 tells you" | I have not read the Kraken 2 chapter yet and the text assumes I did. It is in prereqs, but I did not notice that. | Say in the sentence that Kraken 2 is the broad classifier from the previous chapter. |
| Before you start, "fetch them from the Sequence Read Archive as accession" | I could not perform this from the text alone. It hands me off to another chapter for the only data the whole chapter uses. | Say roughly how long the download takes and how big it is. |
| Before you start, "install Metagenomics if it is not already there" | I did not know how to tell whether it is already there. The Plugin Manager screen is not described. | One sentence naming what an installed pack looks like in that list. |
| 1. Install the viral database, "Plan for at least 8 GB of memory" | I do not know how to find out how much memory my Mac has, and I do not know what happens if I have less. | Point at the Apple menu About This Mac, and say what failure looks like. |
| 1. Install the viral database, "Outside the app, lungfish-cli esviritu db-status" | This is a terminal command and I have never opened a terminal. I did not know whether I was supposed to run it. | Say plainly that the app alone is enough and this is optional. |
| 2. Open the dialog, "Click the FASTQ bundle holding the SRR36291587 reads" | I did not know what a bundle looks like in the sidebar, or whether two paired files show as one item or two. | Say that a paired import appears as a single row. |
| 2. Open the dialog, "close the dialog and fix the selection in" | I was told to fix the selection but not how. I do not know what makes LGE treat two files as a pair. | One sentence, or a pointer, on how pairing is decided. |
| 2. Open the dialog, "A warning may appear under the Database section" | I could not judge whether to ignore this warning. Advisory rather than blocking helped, but I still wondered if my run would fail halfway. | Say the run will finish, only slower. |
| Settings, "where their labels carry a trailing colon on screen" | I read this twice. I could not work out why the manual was telling me about punctuation on labels. | Drop it or say it is only so the names match the screen. |
| Settings, Min read length, "in steps of ten, with 100 chosen because" | I do not know my own read length, so I cannot judge whether 100 is safe for my data. | Say where in LGE to look up the read length of an imported FASTQ. |
| Settings, Extra arguments, "after reading the EsViritu documentation for" | No link or location for that documentation. I would not know where to look. | A link, or say the tool's own site. |
| Reading the results, "RPKMF is reads per kilobase of reference per" | I followed the definition but I have no idea what counts as a big RPKMF. The reference run shows 32,022.4 and I cannot tell if that is huge or ordinary. | Give a rough band, or say the number is only for comparing rows. |
| Reading the results, "Identity is the average percent identity of" | Percent identity was used before it was explained. I know it loosely from BLAST class, but not what averaging over reads means. | Gloss percent identity, and say it is averaged across mapped reads. |
| The reference run, "| Segment | em dash |" | The table literally reads the words "em dash" in a cell. I thought it was a placeholder that had not been filled in. | Show the dash, or say the cell is blank. |
| The reference run, "out of the 170,180 that survived the quality filter" | The 170,180 figure appears here for the first time and I could not find where the viewport shows it. | Say which file or pane reports the surviving read count. |
| The reference run, "the thinnest of them still averaged 319.4 reads deep" | I could not tell whether 319.4 is a good floor or just a number from this run. I do not know what depth is enough. | Say what minimum window depth would start to worry you. |
| The detail pane, "reporting four metric pills labelled" | Metric pills is app jargon I have not met. I guessed it means small rounded boxes. | Call them boxes on first use, or gloss the term. |
| Auditing a detection, "Selecting a row that carries alignment data also swaps" | I did not know which rows carry alignment data and which do not, so I could not predict the behaviour. | Say that every row from an LGE run carries it. |
| Auditing a detection, "read packing, and filters as the general alignment viewer" | Read packing means nothing to me, and I have not seen the general alignment viewer. | Gloss read packing, or drop it. |
| Auditing a detection, "It reads Structurally validated reference when the reference's" | Contig names, lengths, and sequence checksums all landed at once. I read the paragraph three times and still could not act on it. | Say what I should do differently in each of the three cases. |
| Acting on a row, "which recounts the unique read figures from each" | I could not tell when a stored value would be missing, so I do not know when to press this. | Say what causes the missing values. |
| What good looks like, "Even shading from one end of the track" | The sparkline is described in words but I have never seen one, and the screenshot placeholders are not rendered. | Two tiny example sparklines, good and bad, side by side. |
| What good looks like, "When Unique Reads is a small fraction of Reads" | Small fraction is not a number. I do not know if a tenth is small. | Give a rough cutoff. |
| What good looks like, "a figure in the eighties means your reads come" | The reference run's table never shows Unique Reads, so I could not practise this comparison on the worked example. | Add Unique Reads to the reference run table. |
| On the command line, "The whole procedure runs headless." | Headless is undefined and it is the first word of the section. | Say without opening the app. |
| On the command line, "Its toolVersion field, and the Tool line the" | This says a reported number is wrong. I could not tell whether that affects my results or only the version label. | Say the detections themselves are unaffected. |

One thing I learned: a read count alone is a weak claim, and where the reads sat
along the genome is the evidence that makes the claim defensible.

One thing I still could not do: judge whether my own run was good, because the
chapter gives numbers from one excellent amplicon run without telling me the
values at which I should start to worry.

The sentence I liked most: "Two hundred reads spread evenly along a 30,000-base
viral genome and two hundred reads stacked on one 300-base stretch produce the
same read count and mean completely different things."
