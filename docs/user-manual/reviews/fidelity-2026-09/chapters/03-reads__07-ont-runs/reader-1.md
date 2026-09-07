# Reader 1 report, Oxford Nanopore Runs

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "While the run is going, MinKNOW turns" | "Raw electrical signal from each pore" assumes I know a pore is a protein hole the DNA passes through. I pictured a hole in a filter. | One clause saying a pore is a protein channel that DNA threads through while current is measured. |
| What it is, "MinKNOW writes those reads into" | "Holding the reads that cleared its own quality threshold" leaves me not knowing what happened to the reads that failed, or where they went. | Name the sibling folder for failed reads and say whether I should ever care about it. |
| What it is, "A barcode is a short synthetic" | I could not tell whether the barcode is physically part of the read sequence or stored separately as a label. | Say that the barcode sits at the start of the read sequence itself. |
| What it is, "and drops the reads whose barcode" | "Could not read" is vague. Does that mean no barcode present, or a damaged one? | One sentence naming the two reasons a barcode fails to call. |
| Why you would do this, "The HG002 long reads used here run" | I do not know whether 263 to 39,647 bases is a normal spread or a sign of a broken run. | State the typical spread for a healthy nanopore run so I can compare. |
| Why you would do this, "meaning the basecaller expects to be" | I could not check the arithmetic from Phred 7.9 to "one base in six" and I do not know the formula. | Give the conversion in one clause, or point to the Phred glossary entry as the place it is derived. |
| Why you would do this, "You read the pile of reads" | The word for "pile of reads covering a position" is never given, though the chapter later says "covering the genome about 262 times over". | Name that as coverage or depth at first use. |
| Why you would do this, "That high copy number is why" | "Covering the genome about 262 times over" is a number I cannot judge. Is 262 a lot? What is enough? | Say what coverage is usually considered sufficient. |
| Before you start, "On the GitHub page, click into" | The instruction to "rebuild the same three levels of folders" does not name the three folders in order, and I had to reread the path to work them out. | Spell the three folder names on their own line. |
| Before you start, "Importing a run folder needs no" | "Docker Desktop" appears with no explanation and no glossary link, and I do not know what it is. | Gloss it or drop the mention. |
| Procedure step 2, "Click the Sequencing Reads tab, then" | I did not know whether "Open" here means a standard macOS file chooser or something inside LGE. | Say it is the standard macOS folder chooser. |
| Procedure step 3, "Read the Import FASTQ configuration sheet" | I do not know what the Pairing control would have done, so being told it is absent taught me nothing. | One clause saying pairing matches forward and reverse reads of the same fragment. |
| Procedure, "Reads whose barcode MinKNOW could not" | "On the command line that is the `--include-unclassified` option" points me at a terminal I have never opened, and I could not tell whether the window offers any way at all. | Say plainly that the window has no way to include them. |
| Needs demultiplexing, "Or the library may carry" | Inner and outer barcode is a new idea introduced in one clause and I could not picture the arrangement. | One sentence saying both barcodes sit on the same molecule, one nested inside the other. |
| Needs demultiplexing, "Twenty barcode kits ship with LGE" | I could not tell how to find out which kit my own library used, which is what I would actually be stuck on. | Say the kit name comes from the library preparation record or the kit box. |
| Needs demultiplexing, "It handles libraries built with Fluidigm" | CS1 and CS2 are called "fixed primer sequences" but I could not tell whether I must supply them or the software knows them. | Say the software already knows the CS1 and CS2 sequences. |
| Needs demultiplexing, "The operation finds the CS1 and" | "The distinct inserts with their duplicate counts recorded in the read headers" needed three readings, and I do not know what a read header is. | Gloss read header at first use. |
| Checking barcodes, "That is what the barcode scout" | This is the second useful step that is terminal only, and I could not tell whether I am expected to skip the check entirely. | State that window users cannot scout and say what they should do instead. |
| Checking barcodes, "It reads a subset of the reads" | Accept, reject, and undecided are given with no thresholds here, so I could not judge what undecided would mean for me. | Say undecided means the hit count fell between the accept and reject thresholds. |
| Settings lead-in, "The sheet also carries Platform, Quality" | Five settings are named and sent to another chapter, so I would have to hold two chapters open at once. | Say those five stay at their defaults for this chapter. |
| Settings, "(recipe picker). Chooses which of the" | A setting with no name is hard to find on screen, and "the unlabelled popup under the checkbox above" was my only clue. | Name the two choices before describing them so I can match by text on screen. |
| Settings, "Barcode Sheet:. Supplies the table mapping" | I do not know where a barcode sheet comes from or whether I would have to make one myself. | One clause saying the sheet usually comes from whoever prepared the library. |
| Settings, "Built-In Kit. Names the commercial barcode" | Saying the default "is almost never the one you want" without naming it left me unsure what I will see when the pane opens. | Name the default kit. |
| Settings, "Engine. Chooses the program that matches" | I could not judge when barcodes would sit "at unpredictable positions inside the read", so I do not know if this ever applies to me. | Name one library type where that happens. |
| Settings, "Location. Tells Cutadapt where in the" | "Anchored" and "terminus" are both unexplained, and 5' and 3' are used as labels with no reminder of what they mean. | Use "end of the read" rather than terminus, and remind me that 5' is the start. |
| Settings, "5' Distance. Sets how many bases" | I could not tell what number to raise it to when I do have leading adapter sequence. | Give a typical working value. |
| Settings, "Error Rate. Sets the fraction of" | 0.15 of 20 is 3, so I followed the example, but I could not tell whether the tolerated count rounds up or down for other barcode lengths. | Say whether it rounds down. |
| Settings, "Trim Barcodes. Removes the matched barcode" | The reversed command-line sense is clear in principle but I had to reread the sentence to be sure which state is the default there. | Say the command line trims unless you pass the flag. |
| Settings, "Output Strategy. Chooses whether each selected" | "The safe reading of a multi-select" was the phrase I stumbled on, because I do not know what multi-select refers to here. | Say it means selecting more than one bundle at once. |
| Reading the results, "Click the new bundle in the" | Nine cards and three charts are counted but not named, so I cannot tell whether what I am looking at is right. | Point to the chapter that names them. |
| Reading the results, "Output: imported" | I could not tell whether "imported" is a folder I chose, a fixed name, or a status word. | Say it is the output folder name given on the command. |
| Reading the results, "Input reads: 927" | The import summary says 950 reads and the demultiplex summary says 927 input reads. Nothing explains where the other 23 went, and I reread this three times. | Explain the difference between 950 and 927. |
| Reading the results, "Zero percent assigned is what a" | This is the most useful warning in the chapter, but the scout it recommends is terminal only, so I am told the fix and then denied it. | Same as above, say what a window user does instead. |
| Reading the results, "Do not read a base count" | "The section below says how to get the real figure" made me hunt, because the next heading is What good looks like and the answer sits in its third paragraph. | Name the heading. |
| What good looks like, "Confirm the base count yourself rather" | I trust the 72 percent overstatement but I cannot tell whether this is a bug that will be fixed or permanent behaviour. | Say whether this is a known limitation. |
| What good looks like, "Confirm the read counts are in" | "Within a few-fold of one another" is not something I can check against a real number. | Give a rough ratio that counts as a problem. |
| On the command line, "The scout and demultiplex commands need" | A `.lungfish` project folder is named for the first time here, and I do not know where it is or that my project is one. | Say the project folder you created in Before you start is that folder. |
| On the command line, "lungfish-cli fastq scout Imports/HG002.chrM.ont.fastq.gz" | Step 5 says the bundle is named `barcode01` in the sidebar, but the commands use `HG002.chrM.ont.fastq.gz`, and I could not reconcile the two names. | Explain why the sidebar name and the file name differ. |
| On the command line, "The window's Quality Binning and Optimize" | Three flag names and a nested condition in one sentence, and I could not work out which flag applies to what. | Split it into two sentences. |
| On the command line, "--threads is recorded for provenance only" | "Provenance" is not explained and I do not know what it means in this app. | Gloss provenance, or say the value is only written into the record. |
| On the command line, "The scout takes --read-limit (default 10,000" | Eight flags run together in one sentence, and I lost track of which belonged to the scout and which to the PacBio command named at the start of the paragraph. | Break the scout flags out of the PacBio sentence. |
| Does not cover, "POD5 and FAST5 files hold the" | I could not tell whether my own run folder will contain these files and whether it matters that LGE ignores them. | Say they sit beside `fastq_pass` and can be left alone. |
| Next, "Nanopore reads need it more often" | Good explanation, but "reverse strand" and "flips the ones" assume I remember strand orientation from my genetics course rather than from this manual. | Link the strand idea back to the foundations chapter. |

One thing I learned: nanopore reads vary in length because each read is one whole molecule that went through a pore, so a single run holds reads from a few hundred to tens of thousands of bases.

One thing I still could not do: check my barcodes before committing to a demultiplex, because the barcode scout is command line only and I have never opened a terminal.

The sentence I liked most: "You read the pile of reads covering a position and let the errors, which fall in different places on different reads, cancel each other out."
