# Reader 1 report, Alignment Quality

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "An alignment that holds the right..." | I do not know what "an alignment" is as a thing that "holds reads". The chapter opens as if I already know. | One sentence saying an alignment is the file of reads placed onto the reference. |
| What it is, "Between a finished mapping run and..." | "call set" is used before it is explained. | Gloss "call set" the way depth and MAPQ are glossed. |
| What it is, "Forty is comfortable." | Comfortable for what. Ten is weak and forty comfortable with no scale between, so I cannot judge 25. | A sentence saying roughly where the line sits and why. |
| What it is, "LGE runs `samtools markdup` for this..." | I do not know what samtools is or that a separate program is being run for me. | Half a sentence saying samtools is the standard toolkit LGE runs on your behalf. |
| What it is, "on a Phred-like scale, of how likely..." | "Phred-like" means nothing to me. | Say the score rises as the chance of a wrong placement falls, and drop or gloss Phred. |
| What it is, "A MAPQ of 60 is the usual maximum" | If the stepper later runs to 255, why is 60 the maximum. This contradicted itself in my head. | One clause saying mappers cap at 60 in practice even though the field allows more. |
| Why you would do this, "a caller reading through a repeat region calls..." | "paralogous" is a word I only half remember from lecture, and the sentence is long enough that I read it three times. | Say "a near-identical copy of the sequence elsewhere in the genome" instead of paralogous. |
| Why you would do this, "The HG002 slice used in this..." | I do not know what HG002 is, and PCR-free is used as if it were a familiar library type. | Name HG002 as a well-characterized human reference sample at first use, and say PCR-free means no amplification step. |
| Before you start, "Download the reference file `GRCh38.chr20...`" | I do not know what the FASTA file is or why the reference is separate from the reads. | A clause naming the reference as the known genome sequence the reads are compared to. |
| Before you start, "No extra tool pack is needed..." | "tool pack" and "Docker" both appear unexplained and I could not tell whether I had to install something. | Say plainly that nothing extra needs installing. |
| Before you start, "One thing to know before you..." | "bundle" is central to the whole chapter but is only linked, never explained in the body. | One sentence in the text defining a reference bundle. |
| Procedure, read the statistics, step 2, "On the HG002 slice these read..." | Five numbers in a run-on list mapped back onto five names from earlier in the same sentence. I lost track of which was which. | A small table pairing each name with its value. |
| Procedure, read the statistics, step 3, "Note that Est. Coverage appears only..." | "contig" is new here and never explained, though it is used three more times. | Gloss contig at first use. |
| Procedure, read the statistics, step 4, "This is the flagstat tally, the..." | "flag bits" is jargon I cannot picture, and I do not yet know how a record differs from a read. | Say a flag is a set of yes-or-no markers stored with each read. |
| Procedure, read the statistics, step 4, "Counts that failed the instrument's own..." | I did not know the instrument marks reads as failing, and I cannot tell whether the orange number should worry me. | Say whether the orange count matters for the task at hand. |
| Procedure, mark duplicates, step 1, "Switch the Inspector to the View..." | I could not perform this. I do not know where the Inspector is, and "open the Analysis section" does not say how. | Say where the Inspector sits and whether Analysis is a triangle, a tab, or a button. |
| Procedure, mark duplicates, step 4, "When the sheet reports how many..." | This alarmed me. The chapter promised LGE never edits the source, and here my original track disappears. | One sentence reconciling the two, saying marking replaces tracks while filtering adds them. |
| Procedure, derive a filtered alignment, "For a shotgun library heading into variant..." | "the two keep toggles" are not named until the Settings section further down, so I did not know which two. | Name them here. |
| Procedure, derive a filtered alignment, "Type a name into Name for..." | I could not do this. It says to compare the two tracks but not what comparing involves. | A sentence saying what the comparison actually looks like. |
| Settings, Starting Alignment, "Chooses which alignment the filtered copy..." | Every setting ends with a command-line flag and I could not tell whether I was meant to be doing something with them. | A line at the top of Settings saying the flags belong to the terminal section and can be skipped. |
| Settings, Minimum alignment confidence, "Drops reads whose MAPQ falls below..." | Given that 60 was called the maximum, I do not know what setting a value above 60 would do. | Say values above 60 keep nothing extra in practice. |
| Settings, Duplicate handling, "Decides what happens to reads flagged..." | I read this twice to see that Remove is for unmarked data and Hide is for marked data. The logic reverses mid-sentence. | Split into two sentences, one per choice. |
| Settings, Minimum identity to reference, "Keeps only reads matching the reference..." | I do not know what "the aligned region" is, so I cannot tell what the percentage is a percentage of. | Say it is measured over the part of the read that matched, not the whole read. |
| Reading the results, "Total Mapped of 90,990 on the..." | The record versus read distinction arrives here for the first time and the whole paragraph rests on it. | Introduce records versus reads back where Total Mapped is first read. |
| Reading the results, "The Flag Statistics list reports 91,203..." | The arithmetic runs in two directions, adding then subtracting, and I lost which total was which. | State it once, primary plus supplementary equals total. |
| Reading the results, "Both 90,990 out of 91,203 and..." | I traced four numbers through this and still could not tell whether the coincidence mattered to me. | Say outright that the coincidence changes nothing for the reader. |
| Reading the results, "The app does hide them in..." | View Settings has not been mentioned before and I do not know where it is. | Say where View Settings lives. |
| Reading the results, "Measured directly on the fixture, the..." | I could not reproduce this. It does not say what measured it, so I do not know if I can check it myself. | Say whether the app shows this number or whether it came from elsewhere. |
| Reading the results, "A shotgun library where excluding duplicates..." | "a fifth of the depth" is a different unit from the percentages used everywhere else, so I could not connect it to 1.85%. | Use a percentage for consistency. |
| Where the outputs land, "A filtered track's BAM is written..." | Three file extensions I do not recognize, with no statement of whether I ever touch them. | Say these are managed by LGE and need no attention. |
| What good looks like, "Depth is an average, so also..." | I could not do this. Coverage breadth is linked but the text never says where in the app to find it. | Name the place breadth is displayed. |
| What good looks like, "On the HG002 slice, 87,759 of..." | I do not know where in the app to see the MAPQ breakdown, so I cannot check my own run. | Say where the MAPQ distribution is shown. |
| On the command line, "Every step above has a command-line..." | I have never used a terminal and this section left me unsure whether I had skipped a required part of the chapter. | One sentence saying the section is optional and the GUI already covers everything. |
| On the command line, "It replaces the input BAM with..." | This frightened me. It sounds like my data can be overwritten with no undo, and I could not tell whether the GUI button behaves the same way. | State plainly that the Inspector button does not overwrite anything. |
| On the command line, "`--sort-threads` sets how many threads the..." | "threads" is unexplained and I do not know whether I should change it. | Say threads control speed and the default is fine. |

One thing I learned. Marking duplicates deletes nothing, so the average depth figure does not move after a marking run, and only a filter that actually excludes the flagged reads makes depth fall.

One thing I still could not do. Follow the procedure in the app, because I could not find the Inspector, the Analysis section, or the View Settings from the text alone.

The sentence I liked most. "A MAPQ of 0 means the read fits two or more places equally well, so its position is a coin flip and any variant it supports is unreliable."
