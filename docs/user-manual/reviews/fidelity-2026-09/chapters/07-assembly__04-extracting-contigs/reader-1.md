# Reader 1 report, Extracting Contigs

Persona. Sophomore, one genetics course finished, no lab time, never opened a
terminal, never used sequencing software.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "An assembler hands you every contig" | "Assembler" is used before anything says what one is. I worked out from the next sentence that it builds contigs, but I had to read backwards to get there. | Gloss assembler at first use as the program that joins reads into contigs. |
| What it is, "reconstructed from the overlaps between reads" | "Reads" is never explained here. I think it means the short pieces the sequencer produces, but I am guessing. | Gloss read at first use in this chapter. |
| What it is, "MEGAHIT produced three contigs" | MEGAHIT appears with no introduction. I could not tell whether it is a setting, a file, or a program until much later. | Say MEGAHIT is one of the two assemblers LGE runs. |
| What it is, "the HG002 mitochondrial reads used throughout this part" | HG002 is never identified. I do not know if it is a person, a cell line, or a sample name. | Add a half-sentence saying HG002 is a widely used human reference sample. |
| What it is, "together under 4% of the assembly" | I cannot judge whether 4% is small enough to ignore or a sign of a problem. The number arrives before any rule for reading it. | Say what share counts as leftover fragments before quoting the figure. |
| What it is, "builds a FASTA index beside it so tools can jump" | I do not know what "index" means for a file, and "jump to any position" did not tell me why that matters to me. | Say the index is a small companion file listing where each sequence starts. |
| What it is, "The FASTA inside a derived bundle is left uncompressed, unlike the one inside an assembly bundle." | I had to read this twice. It states a difference without saying whether it changes anything I do. | Add whether uncompressed matters to the reader or is only a note. |
| What it is, "So what should you do with this?" | The question is addressed to me but the paragraph had already told me the answer, so I re-read the paragraph looking for something I missed. | Delete the rhetorical question and keep the advice. |
| Why you would do this, "which muddies the depth numbers you use to judge a call" | "Depth numbers" is new here and never defined. I could not picture what gets muddied. | Gloss depth as how many reads cover a position. |
| Why you would do this, "the available reference is too distant to map against comfortably" | I do not know how to tell whether a reference is "too distant". No number or example is given. | Give one concrete example of a distance that is too far. |
| Why you would do this, "open a contig in the sequence viewport where you can move along it by coordinate, translate it, or search it" | "Translate it" surprised me. In genetics that means DNA to protein, but here it sits beside navigation verbs so I was not sure. | Say translate to protein if that is what is meant. |
| Before you start, "choose File > New Project (Cmd-N)" | I could follow this, but nothing says what a project is or why extraction needs one. It only becomes clear in the failures paragraph much later. | Add one sentence saying a project is the folder LGE keeps all your work in. |
| Before you start, "Download the folder human-mito from the manual's fixtures" | The step tells me to download a folder, then immediately says GitHub cannot download a folder. I read the whole paragraph twice before I understood the second half is the actual instruction. | Lead with the ZIP instruction and drop the impossible first version. |
| Before you start, "Run Running SPAdes against those reads first." | The link is titled SPAdes but the chapter then tells me to use the MEGAHIT run instead. I could not tell which run I am supposed to produce. | Say plainly to follow that chapter's MEGAHIT run. |
| Before you start, "There is no Assemblies/ folder." | I never thought there was one, so this sentence made me stop and hunt for the claim it is correcting. | Drop it or attach it to a place where the reader might expect one. |
| Procedure step 1, "with its rank, name, length in bases, GC percent, share of the assembly" | GC percent is linked but not glossed in the text, and I do not know what value is normal, so the column is just a number to me. | Add what GC percent measures and a typical range. |
| Procedure step 1, "There is no coverage column." | Same problem as the Assemblies note. It denies something I had no reason to expect, and coverage is not explained until the last section. | Remove, or move next to where coverage is first discussed. |
| Procedure step 2, "shows 'Select contigs to materialize' while nothing is chosen" | "Materialize" is app jargon I have never met. I could not tell if it means the same thing as extract. | Gloss materialize, or note it is the app's word for extracting. |
| Procedure step 3, "The others are BLAST Contigs, Copy FASTA, and Export FASTA" | BLAST is never explained anywhere in this chapter. I have heard of it in class but could not say what pressing that button does. | Gloss BLAST at first use. |
| Procedure step 4, "Watch the run in the Operations Panel" | I do not know what an operation is in this app or why extraction counts as a run. The panel appears without introduction. | One sentence saying the Operations Panel lists every job the app is running. |
| Procedure step 4, "It finishes quickly, because the only work is subsetting and indexing." | "Quickly" gives me nothing to check against. If it took two minutes I would not know whether to worry. | Give a rough time, for example under a few seconds. |
| Procedure, "Extract Sequence... takes a sub-range of a contig" | I could not perform this from the text. There is no indication of how a sub-range is chosen or what dialog appears. | Say where the sub-range is entered, or link to the chapter that covers it. |
| Procedure, "Align with MAFFT... builds a multiple sequence alignment" | MAFFT and multiple sequence alignment both arrive unexplained in the same clause. | Gloss multiple sequence alignment and name MAFFT as the program that builds one. |
| Procedure, "hands the selection to the FASTQ/FASTA Operations dialog" | I do not know what that dialog is or what it would do with my contigs. | Link to the chapter that describes that dialog. |
| Procedure, "BLAST is capped at 50 selected sequences" | I could not tell whether this applies to Create Bundle too, because it sits in the same paragraph as the bundle actions. | Say explicitly the cap is on BLAST only. |
| Settings, "The command-line flags that have no counterpart in the window follow them" | I have never opened a terminal, so I did not know whether the next eight entries were things I needed. I read all of them before finding they were not. | Put the command-line flags under their own heading so window readers can skip. |
| Settings, "a SPAdes selection suggests something like NODE_1_length_16697_cov_121.957333" | The example is from SPAdes, but the whole chapter uses MEGAHIT, so I could not match it to anything on my screen. | Use a MEGAHIT contig name to match the worked example. |
| Settings, "--output ... The default is standard output, so the FASTA prints to the terminal" | "Standard output" and "pipe cleanly" mean nothing to me. | Mark the flag entries as terminal-only so a window reader knows to skip. |
| Settings, "--project-root. Point it at the .lungfish folder" | This is the first time the project folder is named `.lungfish`, and it is buried in a terminal flag. | Introduce the `.lungfish` folder name where the project is first described. |
| Reading the results, "gives a bundle with one sequence of 16,711 bases at 44.3% GC" | I cannot judge 44.3%. Nothing says what GC value a human mitochondrial sequence should have. | Say what GC value to expect for this sample. |
| Reading the results, "The bundle also carries a Derived Subset block of metadata" | I could not perform the check. Nothing says where in the window I would look to see this block. | Say which panel shows the Derived Subset block. |
| Reading the results, "Moving or renaming the source assembly afterwards is what makes that record harder to follow." | I had to read this twice. The sentence warns about something but does not say what breaks or what to do instead. | Say what the consequence is and whether it can be repaired. |
| Reading the results, "'Could not resolve the enclosing Lungfish project root'" | I did not understand this until I reached the CLI section and learned the project folder ends in `.lungfish`. | Explain project root the first time a project is mentioned. |
| What good looks like, "roughly the length of the repeated stretch at the point where a circular molecule gets cut open" | I read this three times. I know mitochondrial DNA is circular but I could not follow why cutting it open adds length. | Say the assembler repeats the overlap at the join, which adds bases. |
| What good looks like, "the reference record NC_012920.1" | I do not know what a reference record is or where that identifier comes from. | Say it is the accession number of the standard human mitochondrial sequence in NCBI. |
| What good looks like, "96.01% of its assembly, with the two fragments at 2.08% and 1.91%" | I could follow the arithmetic, but "several contigs of comparable share" gives no threshold, so I still would not know how to judge a real result. | Give a rough cutoff for when one contig counts as dominant. |
| What good looks like, "If coverage against the extracted contig comes back patchy" | Coverage is linked but never explained in words, and "patchy" and "well below" are not numbers I can check. | Gloss coverage and give a rough number for too low. |
| What good looks like, "annotation later shows the contig is host or vector" | "Vector" is ambiguous. In my genetics course it meant a plasmid, but I could not tell if that is meant here. | Say what vector means in this context. |
| On the command line, "The whole procedure runs headless, meaning with no window at all" | I appreciated the gloss, but the section still assumes I know how to open the Terminal application and what a working directory is. | Say this section assumes prior terminal experience. |
| On the command line, "megahit-20260907-050500" | I could not tell whether that folder name is an example or a literal name I should type. | Say the timestamp will differ on your machine. |
| On the command line, "the line ✓ Created bundle ... on standard error" | I do not know the difference between standard output and standard error, so I could not tell where to look for each line. | Drop the distinction or explain it once. |
| On the command line, "The Create Bundle button takes the --contigs route internally, so a bundle made in the window records Unknown" | This contradicts the Why you would do this section, which told me the derived bundle names the assembler. I read both twice and still cannot reconcile them. | Fix the earlier claim so it matches this one. |

Three lines.

The one thing I learned. Extracting a single long contig gives reads one place
to land, so depth and variant calls are not spread across junk fragments.

The one thing I still could not do. Judge any of the numbers on my own screen,
because GC percent, share of assembly, and coverage all arrive without a range
to compare against.

The sentence I liked most. "A successful extraction is uneventful, and that is
the intended experience."
