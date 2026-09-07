# Reader 1 report — Reading an Alignment

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is — "A BAM file is a long table" | I do not know what BAM stands for or what makes it different from the FASTQ files mentioned later. The link sends me away from the chapter. | Say in half a sentence what BAM is before linking out. |
| What it is — "which of the two DNA strands" | I learned strands as leading and lagging in replication. I could not tell whether this is the same idea or a sequencing idea. | One clause saying which strand means the direction the read matched, not a replication term. |
| What it is — "how confident the mapper was" | The word mapper appears before it is ever defined. I assumed it was a program but was not sure. | Name the program once, as in the mapper, the program that places reads. |
| What it is — "the single-position column through that pile" | I read this three times. I could not picture a column through stacked bars from words alone. | The figure is promised later, but this sentence needs the picture beside it. |
| What it is — "a figure it prints in the status bar as bases per pixel" | I do not know what a good bases per pixel number is, or which direction is more zoomed in. | Say that a smaller number means more zoomed in. |
| What it is — "Above roughly 2 bases per pixel" | Above sounds like more zoomed in to me, but the message says zoom in, so above must mean zoomed out. I got this backwards on first read. | Replace above with when each pixel has to hold more than. |
| What it is — "pale blue for a read that aligned as sequenced" | I know reverse complement from class but not why a read would align that way, so I could not tell if pink is a problem. | One clause saying both colours are normal and expected in roughly equal numbers. |
| Why you would do this — "an artefact of the sequencing chemistry" | Artefact is used as if obvious. In my class it meant a PCR band that should not be there. | Gloss artefact once as a signal made by the method rather than by the sample. |
| Why you would do this — "This chapter works through the HG002" | I did not know reference genomes come with a known truth set, so I did not understand what independently buys me. | Say who established it and why that makes it a teaching fixture. |
| Before you start — "This chapter uses the HG002 chromosome" | I have never downloaded anything from GitHub. The link goes to a folder listing and I would not know which button gets me the actual file. | One sentence saying to click each file name then the download button. |
| Before you start — "You need a project open. If" | I read Cmd-N and Cmd-Shift-I as if they were text to type. It took a moment to realise these are key presses. | Say once that Cmd means the Command key held with the letter. |
| Before you start — "A CRAM file needs a matching" | I do not know what a bundle is here. It is used before it is explained. | Gloss bundle at first use as the folder LGE keeps a reference and its tracks in. |
| Before you start — "LGE reads alignments by running the" | I do not know what samtools is and the chapter never says, though it is listed in the header. | Half a sentence saying samtools is the standard program for reading alignment files. |
| Before you start — "check the Plugin Manager under Tools" | I would not know what to do inside the Plugin Manager once it opened. | Say what to look for there, such as a Required Setup row marked not installed. |
| Procedure step 1 — "Click the "minimap2 Mapping" track in" | kb was used without expansion. I guessed kilobases, but the chapter also writes ten-kilobase elsewhere, which made me second guess. | Expand kb once at first use. |
| Procedure step 2 — "Read the coverage curve. Its height" | The 47x tooltip example sits next to a stated fixture max of 79x. I could not tell whether 47x is a real reading from this fixture. | Say that 47x is an example of the format rather than a fixture value. |
| Procedure step 2 — "It does not report depth, so" | I had to read this twice to work out that it refers to the status bar and not the label just mentioned. | Repeat the subject, as in the status bar does not report depth. |
| Procedure step 3 — "Go to position 2,078 and zoom" | Everywhere else the chapter writes 2,078 with a comma but the step says to type 2078. I did not know whether to type the comma. | Say to type the digits without a comma. |
| Procedure step 3 — "Then press Cmd-= to zoom in" | Cmd-- is two hyphens and I could not tell if that is one key or a typo. | Write it as Cmd and the minus key. |
| Procedure step 3 — "Keep zooming until each read is" | I do not know how many presses that is, so I would not know if I had gone too far or not far enough. | Give the bases per pixel value at which letters appear. |
| Procedure step 4 — "The four bases have fixed colours" | Both rows is ambiguous. I could not tell which two rows are meant. | Name them, the reference row and the read rows. |
| Procedure — step 4 is followed by step 6 | There is no step 5. I stopped and scrolled back looking for what I had missed. | Renumber so the steps run consecutively. |
| Procedure step 6 — "Pull the reads out of a" | I could not tell whether to drag on the ruler, on the coverage curve, or over the reads. | Say which band accepts the drag. |
| Procedure step 6 — "LGE asks where to save, then" | I do not know if a .lungfishfastq file can be opened by anything other than LGE. | One clause saying whether other programs can read it. |
| Procedure step 6 — "To pull out one read instead" | Copy as FASTA and Extract Reads both sound like they give me the read. I could not tell which one I would want. | One clause each saying which situation calls for which. |
| Settings — "Every control in this section is" | I have never scripted anything, and this sentence assumes I know what scripting a run means. | Cut or rephrase for a reader who only uses the app. |
| Settings — "Minimum alignment confidence. Hides reads whose" | The setting is named confidence but the text explains it as mapping quality. I could not tell if those are the same thing. | Say plainly that the app calls mapping quality confidence here. |
| Settings — "On this fixture almost nothing disappears," | I do not know the scale. Is 60 the ceiling for all aligners, or only this one, and why is 30 the line being drawn? | Say that 60 is the highest value this mapper assigns and what 30 means. |
| Settings — "Switch to Log10 or Square root" | I have not used a log scale on a genomics plot and could not predict what the curve would look like afterwards. | One clause saying a log scale shrinks tall peaks so short ones stay visible. |
| Settings — "A compressed axis is labelled as" | Amplicon and dropout are both used here before the Reading the results section explains them. | Move the gloss earlier or link it here. |
| Settings — "This fixture carries 55 supplementary records" | Earlier the chapter says 90,935 placed reads and later 90,990 Total Mapped. Three different totals appear and I could not tell which counts what. | A short line saying what each of the three totals includes. |
| Settings — "Read display budget. Sets how many" | Later the sample banner section says Load all lifts the ceiling to two million. Two different ceilings confused me. | Say that these are two different limits. |
| Settings — "(the selected region). Sets which stretch" | Settings written in parentheses with lowercase names look like placeholder text that was never filled in. | Give them real names or a line saying these are not named controls. |
| Reading the results — "On this fixture the curve is" | At least one read sounds like almost nothing after the chapter told me ten is the useful floor. I could not tell which figure judges the alignment. | Say which of the two figures is the one to judge the alignment by. |
| Reading the results — "Depth is the number of reads" | Outvote is a metaphor and I was not sure whether callers literally count votes. | Say that the caller weighs how many reads support each base. |
| Reading the results — "A shotgun library like this one" | I know GC content from class but not why amplification copies those less efficiently. | One clause on why, such as GC rich DNA is harder to separate during PCR. |
| Reading the results — "Fifty-one reads cover the position. All" | If every read carries A, I did not understand why a caller reports the A at all rather than the reference simply being wrong. | One clause saying the reference is one person's sequence, not a rule. |
| Reading the results — "The allele frequency is 51 out" | This is homozygous, the word I actually learned. Not using it made me unsure I had the right concept. | Use homozygous and gloss it. |
| Reading the results — "When a window holds more reads" | The fixture only holds 91,148 reads, so 620,000 cannot be from it. I spent time trying to reconcile them. | Say this banner text is an example from a different, deeper dataset. |
| Reading the results — "The second half of that banner" | Stride is not a word I know in this context. | Replace with every Nth read, or gloss stride. |
| Reading the results — "While a heavy window is loading," | I could not tell what a badge is or where on screen it appears. | Say where it appears. |
| Reading the results — "It reports the read's base qualities" | Q20 is glossed in the next sentence, which is good, but I did not know what percentage counts as fine. | Give a rough threshold, as the chapter does for depth. |
| Reading the results — "The alignment summary at the top" | Five labels then five numbers in a separate list. I had to count on my fingers to pair them. | Pair each label with its number, or use a small table. |
| Reading the results — "The Inspector's Analysis section is where" | Six operation names are listed with no hint of what any of them does. | One clause per tab, or a pointer to where each is explained. |
| Reading the results — "Launching from the Inspector opens the" | I do not know what makes a track eligible. | Say what disqualifies a track. |
| What good looks like — "Check that the coverage curve has" | Earlier this same paragraph says a stretch of zero coverage could be a real deletion. I could not tell why 31 positions here are safe to ignore. | Say that the 31 are scattered singles rather than one stretch. |
| What good looks like — "On this fixture 6,308 of the" | I do not know what soft clip rate would be alarming. | Give the number above which soft clipping is worth investigating. |
| On the command line — "The viewport settings are the picture," | I have never opened a terminal, so I could not tell whether this section is something I need or something I can skip. | One line at the top saying this section is optional for app users. |
| On the command line — "--region chr20_10.0-10.5Mb" in the code block | The Go to Location step had me type 2078 with no contig name. Here the region is a long name with underscores and dots, and I could not tell where that name comes from. | Say the contig name comes from the reference FASTA header. |
| On the command line — "That run reports Extracted 91148 reads" | The Inspector reports 90,990 Total Mapped, not 91,148. It does not visibly match. | Reconcile the two numbers or say which Inspector field matches. |

One thing I learned. A difference between reads and the reference is only believable when it shows up on reads running in both directions and away from the read ends, and the viewport shows both of those as a picture instead of a number.

One thing I still could not do. Get the fixture files onto my computer and reach the point where the chapter starts, because the download step and the mapping prerequisite are each handled in one sentence.

The sentence I liked most. "Silence from a caller looks the same whether the region matched the reference perfectly or was never sequenced at all."
