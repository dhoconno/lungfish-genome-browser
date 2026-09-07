# Reader report: Importing and Viewing a Sequence

Persona: a senior who has pipetted for two years but never analyzed data. I have never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "LGE keeps every genome you work" | The word "indexes" is used twice with no explanation. I do not know what an index of a sequence is or why jumping to a position needs one. | Gloss index at first use. |
| What it is, "A GFF3, GTF, or BED" | Three formats arrive at once and only GFF3 is linked. I cannot tell whether GTF and BED differ in any way that matters to me. | Say in one clause that all three are feature-only text formats. |
| Why you would do this, "Chapter 1 imported the HBB gene" | I am reading this chapter cold and did not do Chapter 1. I could not tell whether I was supposed to already have the bundle. | Say the chapter imports the record from scratch. |
| Why you would do this, "The HBB gene record is NG_000007.3" | I was taught HBB is a small gene. I could not understand why the record is 81,706 bases. | One sentence saying the record covers a cluster region, not one gene. |
| Why you would do this, "Eight of those features are genes" | Eight genes in something called the HBB record stopped me. I read the sentence twice. | Name the cluster so eight genes reads as expected. |
| Before you start, "Download the file NG_000007.3.gb from" | The link goes to a GitHub folder. I have never worked out where the download button is from a folder view. I stalled here. | Say to open the file first and then use the download button. |
| Before you start, "no plugin pack has to be" | Docker is named here for the first and only time. It means nothing to me. | Drop it or gloss it. |
| Import the record, "The six tabs are Sequencing Reads" | Six tab names are listed but I do not know what most of them hold, so the list was noise I read twice before finding the one I needed. | Cut the list or say the other tabs come in later chapters. |
| Import the record, "The drop starts the import at" | It compresses and indexes my sequence. I could not tell whether my own file on disk is changed by this. | Repeat here that the original file is untouched. |
| Import the record, "Find the new bundle under Reference" | I do not know whether the `Reference Sequences/` folder already exists in the sidebar or whether I have to make it. | Say LGE creates the folder on the first import. |
| Attach a standalone annotation file, "Do this only when you have" | I do not have such a file, and the section then gives me four steps I cannot perform. I was unsure whether to skip ahead. | A plainer skip instruction. |
| Attach a standalone annotation file, "The alert does not appear at" | This describes a negative case for a dialog I never saw. After two readings I still do not know what happens instead. | Say what does happen. |
| Settings, "Two options exist on the command" | I have never opened a terminal. I could not tell whether I am missing anything important by staying in the window. | Say whether a window-only user loses anything. |
| Settings, "Track ID. Sets the stable identifier" | I could not tell how this differs in practice from Track Name, or where I would ever see a Track ID. | Say where the ID is visible. |
| The bundle on disk, "Control-click it in the Finder" | I have never done this and did not know a folder could look like a single file. I was afraid of breaking the bundle by opening it. | Say that looking inside is safe. |
| The bundle on disk, "a genome/ folder holds the sequence" | Compressed FASTA with its indexes. Third use of indexes and I still do not know what they are, and I do not know whether I could open a compressed FASTA myself. | Gloss both terms once, early. |
| The bundle on disk, "which the Inspector shows in its" | I do not know where the Inspector is or how to open it. Nothing so far told me it is a pane. | Say where the Inspector lives at first mention. |
| The viewport, "and as a density rendering when" | I do not know what a density rendering looks like or what it would tell me. | One clause describing what appears on screen. |
| The viewport, "Around 102 features across an 81,706-base" | I am given a number for this record but no rule for judging any other record. | Give a rough sense of features per kilobase. |
| Moving around the record, "Type NG_000007:70613-70615 and the viewport frames" | The warning to drop the trailing `.3` comes after the instruction, so I typed it wrong first. I also do not know what a LOCUS line is. | Put the warning before the example. |
| Moving around the record, "the three bases of the sickle" | I know sickle cell from genetics, but I could not tell whether GAG is the normal codon or the disease codon. That is the thing I most wanted to know. | Say GAG is the normal sequence. |
| Moving around the record, "so the contig name inside the" | Contig is linked but I still could not picture what a contig is in a record that is one continuous stretch. | Gloss contig in plain words. |
| Right-click actions, "Copy Sequence, Copy Complement, Copy Reverse" | I cannot tell the difference between complement and reverse complement here. Reverse complement is explained two sections later and complement never is. | Gloss both at first use. |
| Right-click actions, "and Run FASTQ/FASTA Operation..., which sends" | I have never seen an operations dialog and do not know what it would do with my sequence. | Point to the chapter that covers it. |
| Right-click actions, "appear only when the viewport is" | I do not know how a viewport comes to hold several sequences, so I cannot tell when these items would show up. | Say what puts several sequences in one view. |
| Translating a sequence to protein, "alternatives cover vertebrate mitochondria (table 2)" | Four tables are listed but I do not know how I would decide which one applies to a sequence a collaborator sends me. | Say the source organism decides it. |
| In the app, "Click Translate in the window" | I do not know which toolbar this is or whether the button is always there. I looked in the menus first because the chapter had used menus up to now. | Say where the toolbar sits. |
| In the app, "Sequence > Translate... (Cmd-Shift-T) is a" | Two commands with the same name doing different things stopped me completely. I could not decide which I wanted. | Say plainly which one to use for reading a protein on screen. |
| In the app, "The Color Scheme picker sets how" | Physicochemical property is a term I only half know, and the other three schemes are named with no hint about what they do. | One clause per scheme, or say the default is fine. |
| Adding one annotation by hand, "and the strand menu offers +" | I do not know how to work out which strand my selected region is on. | Say how to tell, or that none is a safe choice. |
| Auto-detecting open reading frames, "Translation holds Codon table and Minimum" | I do not know whether a default of 100 is permissive or strict, and the command-line block later uses 300 without saying why. | Say what those two values mean in practice. |
| Auto-detecting open reading frames, "and Allow alternative starts, which also" | I only know ATG as a start codon. I do not know what an alternative start is or when I would want one. | Name one example. |
| Removing a track, "The window has no command for" | I cannot use a command line, so this reads as a dead end. | Say whether any workaround exists in the window. |
| Transferring best-match CDS annotations, "Once you have mapped one reference's" | Mapping and assembly are both unexplained here, and the paragraph describes something I have no way to do yet. | Mark the section as forward-looking. |
| Getting data back out, "and the Provenance submenu writes the" | I do not know what a run record contains or why I would want to export one. | One clause on what is in it. |
| What good looks like, "Confirm the length in the Inspector" | This is the check I could not run, because I still do not know how to open the Inspector. | Give the Inspector keystroke here. |
| What good looks like, "A file saved out of a" | Invisible formatting characters are invisible, so I could not tell how I would ever detect this. | Say what the symptom looks like on screen. |
| On the command line, "This section is optional. The window" | I have never opened a terminal. The section is called optional, but deleting a track lives only here, so the one thing the window cannot do is the one thing I also cannot do. | Say what a window-only reader should do instead. |

Learned: importing makes a self-contained bundle in the project, and every later step points at that bundle rather than at my original file.

Could not do: check the sequence length in the Inspector, because the chapter never says where the Inspector is or how to show it.

Liked most: "One colour means one feature type, never one gene."
