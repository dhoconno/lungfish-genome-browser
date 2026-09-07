# Reader report, Extracting and Comparing Sequences

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Extraction cuts a stretch out" | "A stretch" is vague to me. Is it a piece of DNA, a distance, or an exercise? I know the word mainly as pulling a muscle. | Say "a region of bases" the first time instead of "a stretch". |
| What it is, "it keeps extractions in the project's" | The name `Extractions/` with a slash. I did not know if the slash is part of the name I must type. | Say once that a trailing slash marks a folder. |
| What it is, "so a right-click on a gene block" | "Gene block" appears before I ever see one. I do not know what a block looks like in the window. | Name it as the coloured bar drawn above the bases. |
| What it is, "an item handed to the macOS share sheet" | I do not know what a share sheet is or what it would do with my sequence. | One clause saying it opens the standard macOS sharing menu. |
| Why you would do this, "The HBB gene record carries eight genes" | I had to read this twice. A record that carries genes, and one of those genes is also called HBB, the same as the record. | Distinguish the record name `NG_000007` from the gene name `HBB` at first mention. |
| Why you would do this, "It spans positions 70545 to 72152" | I could not check this. 72152 minus 70545 is 1607, but the text says 1,608. I thought I had made an arithmetic mistake. | Say the count includes both end positions. |
| Why you would do this, "You might want its coding stretch" | "Coding stretch" against "the HBB gene on its own". I did not understand these are different sizes until much later in the chapter. | Say here that the gene includes introns and the coding part does not. |
| Why you would do this, "and the pseudogene `OR51AB1P`" | I do not know the word pseudogene, and it is not in the glossary list at the top either. | Gloss it as a gene copy that no longer makes protein. |
| Before you start, "Download the file `NG_000007.3.gb`" | The file has `.3` in the name but the chapter everywhere calls the record `NG_000007`. I was not sure it was the same file. | Say the `.3` is the version suffix. |
| Before you start, "a plugin pack, an internet connection, or Docker" | Docker means nothing to me and I worried for a moment that I needed to install it. | Since it is not needed, drop it or gloss it. |
| Procedure, "which shows the placeholder `chr:start-end`" | I typed `70545-72152` as told but the placeholder shows three parts. I did not trust leaving one out until the next sentence. | Put the reassurance before the instruction, not after. |
| Procedure, "the framed span can be a little wider" | How much wider? I have no way to judge whether my result is correct. | Give a number, even approximate, for how much wider. |
| Procedure, "which is the number of FASTA records" | I framed one region and the sheet says "1 selected", but I selected nothing with the mouse. The word "selected" felt wrong to me. | Say the count is of records to be written. |
| Procedure, "it falls back to an `Extractions` folder beside the working directory" | "Working directory" is a terminal idea and I have never opened a terminal. | Say "next to the project folder" instead. |
| Extract one annotated feature, "Right-click the feature block" | My trackpad has no right button. I did not know how to perform this step. | One clause naming Control-click as the same thing. |
| Extract one annotated feature, "appears on a [CDS] feature and gives the protein" | CDS is glossed by link only. In my genetics course we said "coding sequence" and I did not connect them at first. | Spell out coding sequence at first use. |
| Copy the visible region, "This is the only item on the Sequence menu without a trailing ellipsis" | "Ellipsis" is a punctuation word I did not know. | Say "the three dots". |
| Copy the visible region, section placement | This step sits under the heading "Procedure, marking coding stretches" but copying a region is not marking coding stretches. I thought I had skipped something. | Move it under the cutting procedure, or retitle the section. |
| Find ORFs, "Six frames exist, three on each strand" | I understood the definition but not why six. Three offsets times two strands was never stated. | State the multiplication once. |
| Find ORFs, "A panel titled Find ORFs opens, with the heading FIND ORFS inside it" | Two names for what seems to be the same thing made me look for a second window. | Drop one of the two mentions. |
| Find ORFs, "The window cannot delete a whole track again" | The word "again" stopped me. Delete a track again? I read the sentence three times. | Remove "again". |
| Settings, "neither is in the settings registry" | I do not know what the settings registry is, or why I should care about it as a reader. | This sentence seems written for the authors, not for me. |
| Settings, Reading Frames, "only `+1` can be right" | I could not follow why only plus one. I do not know how the plus and minus numbering works. | One clause explaining that +1 means the first offset on the forward strand. |
| Settings, Minimum ORF length, "The default is 100 nucleotides, which is about 33 codons" | Later the results section uses 300. I did not know which value I should type to reproduce the example. | Say in the procedure to change it to 300 for this walkthrough. |
| Settings, Track ID, "which is what the delete command later asks for" | I do not use the command line, so I could not tell whether I still need to care about this field. | Say window users can leave it as it arrives. |
| Reading the results, "The start reads 70544 rather than 70545" | This broke my confidence. One token is 0-based and another is 1-based on the same line. I could not decide which number to trust. | A single sentence saying never do arithmetic with the header numbers, only read the length. |
| Reading the results, "and the length is 3 plus 100 plus 100" | The example asks for `70613-70615` in the command block but the header shows `70612-70615`. I could not reconcile the two. | Make the two numbers agree, or explain the offset right here. |
| Reading the results, "its own compressed FASTA with indexes under `genome/`" | I do not know what an index is here or whether I have to make one. | Say the app makes them for you. |
| Reading the results, "SHA-256 checksum" | I know checksum only from downloading software. I did not know whether I must verify anything. | Say it is recorded automatically and you never compute it yourself. |
| The ORF track, "its translation starts `MKLVVRPWAGWYQGYKTGL`" | These are one-letter amino acid codes. My course used three-letter codes and I could not read this at all. | Say these are single-letter amino acid codes. |
| The ORF track, "`join(70595..70686,70817..71039,71890..72018)`" | The `join(...)` form with double dots is never explained. I did not know if I type this anywhere. | Say this is how GenBank writes a spliced feature. |
| The ORF track, "three pieces adding to 444 bases and 147 codons" | 444 divided by 3 is 148, not 147. I lost time here thinking I had misunderstood codons. | Say the stop codon is not counted as an amino acid. |
| The ORF track, "reach for a dedicated gene caller such as Prodigal or Prokka" | Two tool names with no word on where I would get them or whether I am able to. | One clause saying they are separate programs outside LGE. |
| Extracting every feature, "the record's imported track for the `gene` type" | The word "track" for annotations against "lane" earlier in the chapter. I thought these were two different things. | Use one word throughout. |
| Extracting every feature, "The HBB CDS record comes out at 1,424 bases" | Here 72018 minus 70595 plus 1 does give 1424, so this one checked out, but the header arithmetic earlier did not. The inconsistency made me distrust both. | Use one coordinate convention in the prose. |
| What good looks like, "the codons for valine, histidine, leucine, threonine, proline" | I counted the bases after ATG and got GTG CAT CTG ACT CCT, which matched, but only after several minutes and a codon table I had to find myself. | Show the codons split with spaces. |
| What good looks like, "the `GAG` that the sickle cell change alters" | The chapter names the sickle cell codon four times but never says what it changes to or why that matters. As a pre-med student this was the part I most wanted. | One sentence naming the resulting change. |
| On the command line, "`hbb-example.lungfish/"Reference Sequences"/`" | Quotation marks in the middle of a path. I do not know whether I am supposed to type them. | Say the quotes are needed because the folder name has a space. |
| On the command line, "Output goes to standard output unless `-o` names a file" | "Standard output" means nothing to me. | Say it prints into the terminal window. |
| On the command line, "Those two are 0-based with the start inclusive and the end exclusive" | This is the third counting convention in one chapter. At this point I stopped trying to compute any coordinate myself. | Collect all three conventions in one small table. |

The one thing I learned. An ORF track is only a list of candidates, and on a human gene with introns it will not match the real coding sequence, so I must read it beside a curated track.

The one thing I still could not do. Reproduce any coordinate myself, because the chapter uses 1-based inclusive numbers in the prose, a 0-based number in the FASTA header, and 0-based half-open numbers on the command line, and I could never tell which one I was looking at.

The sentence I liked most. "An ORF track is a set of candidates, not a set of genes."
