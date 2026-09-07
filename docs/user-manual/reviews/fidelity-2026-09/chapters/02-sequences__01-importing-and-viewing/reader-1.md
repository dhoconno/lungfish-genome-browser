# Reader report, undergraduate reader 1

Persona: sophomore fresh from a genetics course, no lab time, never opened a terminal.
Chapter: `docs/user-manual/chapters/02-sequences/01-importing-and-viewing.md`

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Lungfish Genome Explorer (LGE) keeps every..." | I do not know what "indexes" are. The word appears twice before anything says what an index does. | One clause saying an index is a lookup table that lets the app jump to a position without reading the whole file. |
| What it is, "A feature is a labelled stretch..." | The types listed include `CDS` and nothing spells it out. It is in the glossary list but never in the prose. | Spell out coding sequence at first use. |
| What it is, "A GenBank flatfile holds the sequence..." | "flatfile" is new to me. I have heard of GenBank as a website, not as a file. | One sentence saying a GenBank flatfile is the plain-text file you download from the GenBank database. |
| What it is, "A GFF3, GTF, or BED file is..." | Three formats introduced at once, none explained, and I cannot tell whether they differ in any way that matters to me. | One line saying they are three ways of writing the same feature table. |
| Why you would do this, "Chapter 1 imported the HBB gene record..." | I did not read chapter 1 first. I do not know what HBB is or why one codon in it matters. | Half a sentence saying HBB is the human beta-globin gene and one change in it causes sickle cell disease. |
| Why you would do this, "The HBB gene record is `NG_000007.3`..." | I do not know what the `.3` means, and later the chapter tells me to leave it off, which made me read both places twice. | One clause saying the trailing number is the version of the record. |
| Why you would do this, "Eight of those features are genes..." | Eight genes inside one gene record confused me. I thought a record about HBB would hold one gene. | One line saying the record covers a cluster, so several related globin genes sit inside it. |
| Why you would do this, "The rest are other GenBank feature types..." | I cannot tell whether `misc_feature` is something I should care about or filler. | One clause saying `misc_feature` is a catch-all used when no specific type fits. |
| Before you start, "Download the file `NG_000007.3.gb`..." | The link points at a folder listing. I was not sure whether to use the Download button or the Raw link, and I have saved broken files that way before. | One sentence naming which link on that page to use. |
| Before you start, "no plugin pack has to be installed and Docker is not involved" | I do not know what a plugin pack or Docker is, so I could not tell whether this was reassuring me or warning me. | Say only that this chapter needs nothing beyond the app. |
| Procedure, step 2, "The drop starts the import at once..." | I could not tell whether anything visible happens, or how I know it finished. | One clause saying the bundle appears in the sidebar when the import is done. |
| Procedure, step 4, "Find the new bundle under `Reference Sequences/`..." | I did not know whether "open it" means one click or two. | Say click or double-click. |
| Attach a standalone annotation file, "Fill in the Import Annotation Track alert..." | The step sends me to a section further down and then back again. I lost my place. | Name the three fields inline so I can fill them without leaving the steps. |
| Settings, Track ID, "Change it only when the derived identifier collides..." | I do not know how I would ever find out that an identifier collides. The advice is not actionable for me. | One clause saying LGE tells you when the identifier is already taken. |
| Reading the results, "Control-click it in the Finder and choose Show Package Contents" | Everywhere else the chapter says right-click. Here it says Control-click and I stopped to work out whether these are two different actions. | Use one term throughout. |
| Reading the results, "a `genome/` folder holds the sequence..." | I do not know what compressed means here or whether I could still open that file myself. | One clause saying it is gzip-style compression the app reads directly. |
| The viewport, "and as a density rendering when you are not" | I have no picture of what a density rendering looks like. | One clause saying zoomed out the bases collapse into a shaded band. |
| The viewport, "Around 102 features across an 81,706-base record..." | I do not know how to judge this. There is no rule of thumb I could apply to a different record. | A rough ratio, such as a feature every few hundred to few thousand bases. |
| Moving around the record, "Type `NG_000007:70613-70615` and the viewport..." | I did not know whether coordinates start at 1 or at 0. The command-line section says 1-based much later, which is where I finally found out. | State 1-based here, at first use. |
| Moving around the record, "the viewport frames the three bases..." | I could not tell whether `GAG` is the healthy version or the sickle cell version. The phrase "sickle cell codon" made me guess wrongly. | One clause saying `GAG` is the normal codon and the sickle allele changes it. |
| Right-click actions, "**Copy Complement**, and **Copy Reverse Complement**" | Reverse complement is explained later, but complement alone never is, and I could not tell how the two differ. | One clause distinguishing them where they first appear. |
| Right-click actions, "**Run FASTQ/FASTA Operation...**, which sends..." | I do not know what the operations dialog is or what I would do there. | One clause saying it is covered in a later chapter. |
| Right-click actions, "appear only when the viewport is stacking several sequences at once" | I do not know how the viewport comes to be stacking several sequences, so I could not tell whether I would ever see these items. | One clause naming when that happens. |
| Translating a sequence to protein, "The standard code, table 1, covers most nuclear genes" | The nuclear versus mitochondrial distinction is one I half remember. I read this paragraph twice. | One clause contrasting genes in the nucleus with genes in mitochondria. |
| In the app, "**Sequence > Translate...** (Cmd-Shift-T) is a different thing" | Two commands with almost the same name doing different things is exactly what I would get wrong, and I could not tell which one this chapter wants. | Say plainly that the toolbar button is the one this chapter uses. |
| In the app, "`Zappo`, which is the default and which groups residues..." | "physicochemical property" told me nothing concrete, and the other three schemes are named with no explanation at all. | One line saying the choice is cosmetic. |
| Adding one annotation by hand, "and the strand menu offers `+`, `-`, or `none`" | I would not know which to pick for a region I selected by dragging. | One clause saying pick `+` unless you know the feature is read from the other strand. |
| Auto-detecting open reading frames, "Translation holds `Codon table` and `Minimum ORF length`..." | I cannot judge whether 100 is a lot or a little, and the command-line example uses 300, which made me doubt the default. | Say roughly what 100 nucleotides is in amino acids and why you might raise it. |
| Auto-detecting open reading frames, "Options holds `Include partial ORFs`, which keeps..." | I only know `ATG` as a start codon. I do not know what an alternative start is or when to switch this on. | One clause saying some codes allow starts other than `ATG`. |
| Auto-detecting open reading frames, "An ORF track is a set of candidates..." | "weak proxy" is vague. I could not tell how much to distrust the output. | One clause saying long stretches occur by chance, so a long ORF is a hint and not proof. |
| Transferring best-match CDS annotations, "Once you have mapped one reference's coding..." | I do not know what mapping or an assembly is at this point in the manual. The whole section was opaque to me. | One clause saying this comes after the alignment chapters. |
| What good looks like, "Confirm that the bases at 70613 to 70615..." | I do not know how I would then get the right version, since the download link gave me one file. | One clause pointing back to the fixture link. |
| What good looks like, "A file saved out of a word processor carries..." | I would not know how to re-export as plain text, and no app is named. | Name one way, such as saving from TextEdit as plain text. |
| On the command line, "This section is optional." | I have never opened a terminal, and nothing says where these lines get typed. I skimmed the rest without understanding it. | One clause saying these are typed in the macOS Terminal app. |
| On the command line, "`translate` takes `--frame`, where 1 to 3..." | The app calls the frames `+1` to `-3` and here they are 1 to 6. I could not map one onto the other. | One clause saying frame 4 is the app's `-1`, and so on. |
| On the command line, "`--start` and `--end` bound the search..." | I read this three times and still could not confidently convert a coordinate from the window into one for the command line. | A worked line showing the same region written both ways. |
| On the command line, "`--min-query-cover` sets how much of a CDS query..." | Half of what, and is half strict or loose. I could not judge whether to change it. | One clause saying higher values transfer fewer but more confident models. |

The one thing I learned. A reference bundle is a folder pretending to be a file, and every later step in the app points at that bundle instead of at the file I downloaded.

The one thing I still could not do. Run anything in the On the command line section, because nothing told me where those lines get typed.

The sentence I liked most. "One colour means one feature type, never one gene."
