# Reader report, undergraduate reader 2

Persona: a senior who has pipetted for two years and has never analyzed data. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Extraction cuts a stretch out" | I did not know what "a stretch" means as a unit. Is it a gene, a range of numbers, or something I draw with the mouse? | Say once that a stretch is any run of consecutive bases named by a start and an end number. |
| What it is, "it keeps extractions in the project's" | `Extractions/` with a trailing slash looked like a typo to me before I worked out it means a folder. | Write "a folder named Extractions". |
| What it is, "The third route runs on the command line" | I have never opened a terminal, so a whole third of the chapter is closed to me, and I could not tell if I was missing something required. | One sentence saying the window can do everything except delete a track, placed here instead of only in the last section. |
| What it is, "an item handed to the macOS share sheet" | I did not know what a share sheet is or what it would do with a FASTA. | Name one thing it can do, for example send the FASTA to Mail. |
| Why you would do this, "The HBB gene record carries eight genes across 81,706 bases" | I did not know why one record has eight genes in it, or what a "record" is as opposed to a file. | Say the record is one downloaded region of a chromosome that happens to contain a cluster of related genes. |
| Why you would do this, "It spans positions 70545 to 72152" | I could not tell what these positions are counted from. From the start of chromosome 11, or the start of this downloaded file? | Say the positions are counted from the first base of this record, not of the chromosome. |
| Why you would do this, "so you can map reads against just that gene" | "Map reads" is used before it is explained anywhere I had read. | Gloss it in one clause, for example matching sequencing reads to their place on a reference. |
| Why you would do this, "the pseudogene `OR51AB1P`" | I know the word pseudogene from lecture but not why the manual calls it out separately from the other seven. | Say it is included because it is on the record, not because it is special to the procedure. |
| Before you start, "the whole chapter takes about twenty-five minutes" | The front matter says thirteen minutes of reading and this says twenty-five at the keyboard, and I could not tell which to budget. | State one total. |
| Procedure, step 1, "the position field at the left end" | I did not know what the ruler is in this app, and I had to hunt the screenshot for a field. | Name the ruler as the numbered bar above the bases the first time it appears. |
| Procedure, step 1, "which shows the placeholder `chr:start-end`" | I typed `70545-72152` as told, but the placeholder shows a `chr:` part, so I was not sure my input was wrong until the next sentence rescued me. | Move the sentence about leaving the name off to directly after the placeholder. |
| Procedure, step 2, "the framed span can be a little wider" | I do not know how much wider, so I could not tell whether an answer of 1608 or 1700 bases means I did it right. | Give a rough size of the overshoot, for example up to a few dozen bases. |
| Procedure, step 3, "a count reading 1 selected" | I read this twice. The text says it counts FASTA records, but I had not been told a FASTA can hold more than one record. | Say a FASTA file can hold many records, one per sequence, at the first mention of FASTA. |
| Procedure, step 5, "click the button at the bottom right" | The button has four possible labels and no default is named, so I was not sure which one I would see after choosing Save as Bundle. | Name the label for the choice the procedure just told me to make. |
| Procedure, "When LGE cannot work out which project" | I could not tell when this would happen to me, so I did not know whether to worry. | Say it happens only when the file was opened from outside a project. |
| Extract one annotated feature, step 1, "Right-click the feature block in" | I could not find a lane by that name. The first section called the same thing a track and the caption calls it a feature block. | Use one name for the horizontal band, and say once that it holds feature blocks. |
| Copy the visible region, step 2, "This is the only item on the" | I had to read this twice to see that the three dots are the thing being discussed rather than an omission in the manual. | Say the three dots after a menu item mean a dialog will open. |
| Find ORFs primer, "Six frames exist, three on each" | I know codons but I could not work out why three offsets per strand rather than two or four. | Add the reason, that a codon is three bases so there are three places to start. |
| Find ORFs, step 2, "A panel titled Find ORFs opens" | I could not tell why the panel title and the heading inside it are both being reported, and it read like a defect note rather than an instruction. | Drop it or say plainly the panel repeats its title. |
| Settings, "The Extract Sequence sheet has two" | I do not know what the settings registry is and it is mentioned twice as a reason for something. | Cut the mention or say it is an internal list readers do not see. |
| Settings, Reading Frames, "Turn frames off only when you" | I could not follow why a CDS I extracted myself forces frame plus one. | Say the extraction starts at the first base of the start codon so the count begins there. |
| Settings, Minimum ORF length, "The default is 100 nucleotides, which" | I could not judge whether 33 codons is a plausible protein. Every protein I have heard of is bigger. | Say the default is deliberately below any real protein so nothing is lost by accident. |
| Settings, Track ID, "Sets the stable identifier the bundle" | Deleting needs the terminal, which I cannot use, so I could not tell whether this field matters to me at all. | Say window users can leave it alone. |
| Reading the results, "The start reads 70544 rather than" | This is the sentence that most made me distrust my own output. I could not tell whether the file is wrong or the header is just labelled differently. | State first that the sequence itself is correct and only the printed start differs. |
| Reading the results, "That one-off is worth knowing before" | 0-based and 1-based are used throughout and never explained side by side. | One line early on showing the same base numbered both ways. |
| Reading the results, "The first token still names the" | The header says 203 bp but its first token reads `70612-70615`, which looks like four bases to me, and the command block asks for `70613-70615`. I could not reconcile the two. | Use the same coordinates in the example and the command. |
| The new bundle, "That sidecar records the exact command" | I do not know what a checksum is for and the glossary link did not stop me wondering why I would care. | Say in the sentence that it detects whether a file changed. |
| The ORF track, "That is 402 nucleotides, which is" | I did not know those letters were amino acids until I reached the words a paragraph later. | Say it is the one-letter amino acid code. |
| The ORF track, "Compare that against the record's own" | I have never seen this notation and could not tell it was three pieces until the following clause told me. | Say it is the GenBank way of writing a spliced gene. |
| Extracting every feature of one type, "The command-line route in the last" | This section sits before the command-line section but only makes sense after it, and I did not know how to produce these eight records from the window. | Say up front this output comes only from the command line. |
| What good looks like, "Confirm the first bases are the" | I did not know where to look in the app to see the first bases of my extraction. | Say to open the new bundle and read the leftmost bases. |
| What good looks like, "Confirm the provenance sidecar names the" | I could not do this. I do not know what file the sidecar is or how to open it. | Name the file and say it opens in any text editor. |
| On the command line, "This section is optional, and the" | Every check the previous section asked me to run on an exact base count sends me here, and I cannot follow any of it. | Say which of the four checks a window-only reader can complete. |

Learned: an extraction is a copy that carries its own coordinates in the header, so a loose FASTA can always be traced back to the record it came from.

Could not do: confirm my extraction was correct. Three of the four checks in What good looks like need either the terminal or a file I do not know how to open.

Liked most: "An ORF track is a set of candidates, not a set of genes."
