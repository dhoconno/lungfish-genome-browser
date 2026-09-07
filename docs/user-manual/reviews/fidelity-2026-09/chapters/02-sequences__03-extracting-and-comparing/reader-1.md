# Reader report, undergraduate reader 1

Persona: sophomore, one genetics course, no lab time, never opened a terminal.
Chapter: `docs/user-manual/chapters/02-sequences/03-extracting-and-comparing.md`

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Extraction cuts a stretch out..." | "Bundle" is used before I know what it is. The glossary link sits on "reference bundle" a sentence later, but I met "a new bundle" first. | Gloss bundle at its actual first use. |
| What it is, "The third route runs on the command line" | I have never opened a terminal. I could not tell whether this chapter expects me to. | One clause saying the command line is optional here. |
| What it is, "or an item handed to the macOS share sheet" | I do not know what the share sheet is or what I would get out of it. | A short gloss of the share sheet. |
| Why you would do this, "carries eight genes across 81,706 bases" | I did not know why one gene record holds eight genes. I read it twice. | Say the record is a gene cluster, not a single gene. |
| Why you would do this, "It spans positions 70545 to 72152" | I could not check this number against anything on screen. | Say the span comes from the record's own annotation and where it shows. |
| Why you would do this, "and the pseudogene `OR51AB1P`" | I do not know what a pseudogene is and it is not in the chapter's glossary list. | Gloss pseudogene at first use. |
| Before you start, "Download the file `NG_000007.3.gb`" | The file is `NG_000007.3.gb` but every later mention says `NG_000007`. I could not tell if these are the same thing. | Say once that the `.3` is a version suffix. |
| Procedure, step 1, "typing coordinates into the position field at the left end of the ruler" | I could not find the ruler from the text alone. I do not know which part of the window is the ruler. | Name where the ruler sits relative to the bases. |
| Procedure, step 1, "which shows the placeholder `chr:start-end`" | The placeholder says `chr` but the record is `NG_000007`. I did not know whether to type `chr`. | State that `chr` is placeholder text, not something to type. |
| Procedure, step 2, "the framed span can be a little wider than the range you typed" | I could not tell how much wider, or when it is too wide to use. | Give a rough size, or point to the length token as the check. |
| Procedure, step 2, "so a drag selection does not narrow it" | This warns me off a feature I had never met. It reads like a correction to something I did not do. | Cut it, or introduce drag selection first. |
| Procedure, step 3, "a count reading \"1 selected\"" | I could not judge what a wrong value would look like. | Say what a number other than 1 would mean. |
| Procedure, step 5, "Type the name `HBB-gene`" | The feature route says the Name field arrives prefilled. Here I type it. I was unsure which state I should see. | Say the field is empty for this route. |
| Procedure, "it falls back to an `Extractions` folder beside the working directory" | "Working directory" is a terminal idea and I have never used one. | Name a folder a window user can actually point at. |
| Extract one annotated feature, step 1, "Right-click the feature block in the annotation lane" | I did not know which stripe of the window is the annotation lane, or how to spot a gene block. | Name the lane's position relative to the bases. |
| Extract one annotated feature, "**Copy Translation as FASTA** appears on a CDS feature" | I know CDS from lecture but not why translation appears only there. | One clause saying only a CDS carries a frame the app can trust. |
| Extract one annotated feature, "**Extract Reads in Selected Region...** appears" | A whole paragraph about a viewport I have not met. It broke my flow. | Move it to a note or cut it. |
| Heading "Procedure, marking coding stretches" | The heading promises coding stretches but the first subsection copies a region as FASTA. I read the heading twice. | Put the copy subsection under the previous H2. |
| Copy the visible region, "the missing ellipsis is the cue that it acts at once" | I had never noticed ellipses on menu items and did not know the convention. | Say plainly that this item runs immediately. |
| Find ORFs, step 2, "A panel titled Find ORFs opens, with the heading FIND ORFS inside it" | I could not tell whether the doubled title is a defect I should worry about. | Drop the inner heading detail. |
| Find ORFs, step 4, "each carrying its own translated protein as an attribute" | I do not know what an attribute is here, or where I would see the protein. | Say where the protein shows up in the window. |
| Find ORFs, "The window cannot delete a whole track again" | I read this twice. "Again" made me think I had already deleted one. | Say the window has no delete for tracks. |
| Settings, "neither is in the settings registry" | I do not know what the settings registry is and it changes nothing I do. | Cut the registry mention for readers. |
| Settings, Reading Frames, "only `+1` can be right" | I could not follow why extracting a CDS forces frame `+1`. | One clause saying an extracted CDS starts at its own base 1. |
| Settings, Codon table, "table 2 covers vertebrate mitochondria and table 11 covers bacteria" | I do not know where those table numbers come from or how to find others. | Name the numbering scheme's source. |
| Settings, Minimum ORF length, "high enough to drop most stretches that are open by chance" | I did not know random DNA could look open. That assumption is the whole reason for the setting. | One sentence on why random sequence produces false ORFs. |
| Settings, Track ID, "the stable identifier the bundle stores" | I could not tell how a track ID differs from a track name in practice. | Say the name is for reading and the ID is for commands. |
| Settings, Allow alternative starts, "where `GTG` and `TTG` starts are ordinary" | Genetics class taught me `ATG` is the start codon. This contradicted that and I reread it. | Say bacteria use additional start codons. |
| Reading the results, "The start reads 70544 rather than 70545" | The hardest paragraph in the chapter. I could not work out which number to trust when. | Give a one line rule for what the header start is good for. |
| Reading the results, "because the header prints the internal 0-based start" | 0-based versus 1-based is new to me and it arrives inside a subordinate clause. | Explain the two counting systems before using them. |
| Reading the results, "which matches 72152 minus 70545 plus 1" | The arithmetic uses 70545 while the header shows 70544. I could not reconcile them without stopping. | Show both numbers in the same worked line. |
| Reading the results, "a feature stitched from several exons adds `[exons concatenated]`" | I did not know a single feature could be cut from several pieces until this sentence. | Introduce spliced extraction before the token list. |
| Reading the results, "the length is 3 plus 100 plus 100" | The text says three bases but the header reads `70612-70615`, which I counted as four. | Reconcile the coordinates with the stated three bases. |
| The new bundle, "its own compressed FASTA with indexes under `genome/`" | I do not know what an index is or whether I need to care. | Say indexes let the app jump to a position quickly. |
| The new bundle, "a SHA-256 checksum and a byte size" | I know checksum only vaguely and could not tell what I would do with it. | Say the checksum proves the file did not change. |
| The ORF track, "its translation starts `MKLVVRPWAGWYQGYKTGL`" | I could not tell whether I should expect to reproduce this exactly. | Say this is what a correct run produces. |
| The ORF track, "`join(70595..70686,70817..71039,71890..72018)`" | This notation was never explained and I could not read it. | Gloss the join notation once. |
| The ORF track, "three pieces adding to 444 bases and 147 codons" | 444 divided by 3 is 148, not 147. I stopped to check my arithmetic. | Say the stop codon is not counted as an amino acid. |
| The ORF track, "such as Prodigal or Prokka outside LGE" | Two tool names with no idea how I would get or run them. | Say these are separate programs, not part of LGE. |
| Extracting every feature, "each headed with its own provenance" | I met provenance as a sidecar file earlier and as a header here. I was unsure they are the same idea. | Use a different word for the header case. |
| Extracting every feature, "The HBB CDS record comes out at 1,424 bases" | The gene starts at 70545 and this CDS starts at 70595, and I could not tell which coordinates the command used. | Say the CDS extraction uses the CDS coordinates. |
| What good looks like, "the codons for valine, histidine, leucine, threonine, proline" | I could not match those amino acids to the bases shown without a codon table in front of me. | Show the split triplets alongside. |
| What good looks like, "the `GAG` that the sickle cell change alters" | The sickle cell codon is called out three times but never located inside the extraction. | Say which position of the extract holds it. |
| On the command line, the whole section | I have never opened a terminal, so I cannot do the one thing the window cannot do, deleting a track. | Say what a window-only reader should do instead. |
| On the command line, `"Reference Sequences"` inside the path | The quotes in the middle of a path looked like a typo to me. | A note that quotes handle the space in the folder name. |
| On the command line, "Those two are 0-based with the start inclusive and the end exclusive" | Three counting conventions now appear in one chapter and I lost track of which applies where. | A small table of which command uses which convention. |
| Next, "Continue to [Aligning Sequences]" | The opening says the next chapter is alignment, the link says Aligning Sequences, and the file is `04-msa-and-trees`. I was unsure they are one chapter. | Match the promise to the chapter title. |

The one thing I learned. An extraction is a copy that carries its own coordinates in its FASTA header, so a loose file can always be traced back to the record it came from.

The one thing I still could not do. Delete an ORF track I created, because the only route given is the command line and I have never opened one.

The sentence I liked most. "An ORF track is a set of candidates, not a set of genes."
