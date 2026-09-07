# Reader report: Importing and Viewing a Sequence

Persona: student who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "the indexes that let LGE" | I do not know what an index is for a sequence. In Geneious I never saw one. | Say in one clause that an index is a lookup table so the app can jump to a position without reading the whole file. |
| What it is / "A GenBank flatfile holds the sequence" | "Flatfile" is new to me. I have only heard "GenBank file". | Gloss flatfile at first use. |
| What it is / "A GFF3, GTF, or BED" | GTF and BED are never glossed the way GFF3 is. I do not know if they are interchangeable. | Add a half sentence saying all three are feature-only text formats. |
| Why you would do this / "Chapter 1 imported the HBB" | I read this chapter cold and have not done chapter 1, so I do not know if I must go back first. | Say whether chapter 1 is required or whether the download below is enough. |
| Why you would do this / "Eight of those features are genes" | Eight genes, five mRNAs, five coding sequences, thirteen exons is 31 of 102. I could not tell if the rest matter. | One sentence saying the remaining features are not used in this chapter. |
| Why you would do this / "five are coding sequences, and" | CDS is only glossed later under Translating, and I do not know why there are five CDS but eight genes. | Gloss CDS the first time it appears, not in the translation section. |
| Before you start / "Download the file NG_000007.3.gb" | The link is a GitHub folder, not a file. I did not know that clicking a file on GitHub shows text and that I must use a download button. | Say which button on the GitHub page saves the actual file. |
| Before you start / "no plugin pack has to be" | Plugin pack and Docker are both mentioned with no explanation. I do not know what they are. | Drop the mention, or gloss both in one clause. |
| Import the record / "The Import Center opens as a" | I could not picture a card. I do not know if it is a button or a drop zone. | One clause saying a card is a labelled panel you can drop a file onto. |
| Import the record / "The drop starts the import at" | I do not know whether my original file gets compressed or only the copy. | Say the copy inside the bundle is compressed and the original is untouched. |
| Import the record / "It carries the name of the" | Later the manual says the contig is called `NG_000007` without the `.3`. Two names for the same thing confused me badly. | Say plainly that the bundle name keeps the version and the sequence name inside does not. |
| Attach a standalone annotation file / "Do this only when you have" | I could not tell if I should perform these steps or skip them. The instruction and the "do not do this" are in the same block. | Mark the whole subsection as optional in the heading. |
| Settings / "Sets the stable identifier the bundle stores" | I do not know what files refer to a track or why I would ever change this. | Say a collision is rare and that leaving the default is normal. |
| The bundle on disk / "Control-click it in the Finder" | Elsewhere the chapter says right-click. I did not know these are the same action. | Use one term throughout. |
| The bundle on disk / "a genome/ folder holds the sequence" | A compressed FASTA and a FASTA sound like different formats to me. | Say it is the same content stored in a compressed form. |
| The viewport / "The middle lane is the bases" | I do not know what a density rendering looks like or what it tells me. | One clause saying it is a solid band showing where sequence exists when letters will not fit. |
| The viewport / "Around 102 features across an 81,706-base" | I cannot judge whether 102 is a lot. The sentence tells me what is normal only for this one record. | Give a rough rule, such as features per ten thousand bases. |
| Moving around the record / "Type NG_000007:70613-70615 and the viewport frames" | The illustration caption mentions 70600 and 70620, and the CLI block uses 70544 and 70545. Four coordinate systems felt like too many to hold. | Keep one worked coordinate in the prose. |
| Moving around the record / "A single number jumps to that" | I do not know if coordinates start at 1 or at 0 here. The CLI section says the window is 1-based, but that is much later. | State 1-based at first use in the viewport section. |
| Right-click actions / "A Copy submenu holds Copy Name" | I do not know the difference between complement and reverse complement, and reverse complement is only defined in the next section. | Gloss both where the menu items are listed. |
| Right-click actions / "and Run FASTQ/FASTA Operation..., which sends" | I have not met the operations dialog and cannot tell what it would do. | Point to the chapter that covers it. |
| Right-click actions / "Two more items, Show All Translations" | I do not know what makes the viewport stack sequences or how to get there. | Say which feature produces a stacked view. |
| Translating a sequence to protein / "The standard code, table 1, covers" | I do not know how to tell which table my sequence needs if it is not human nuclear. | One sentence on how to decide. |
| In the app / "Sequence > Translate... (Cmd-Shift-T) is a" | I read this three times. Two commands named Translate that do different things is the most confusing part of the chapter. | Name the difference in the first clause, such as overlay versus file. |
| In the app / "The Color Scheme picker sets how" | Physicochemical property means nothing to me, and ClustalX, Taylor, Hydrophobicity are unexplained. | Say the schemes only change colours and none changes the protein. |
| Adding one annotation by hand / "The type menu offers gene, CDS" | I do not know which strand to pick for a region I selected by dragging. | Say what `none` means and when to use it. |
| Auto-detecting open reading frames / "Translation holds Codon table and Minimum" | I do not know whether 100 is generous or strict, and the CLI example uses 300 with no reason given. | Say what a typical real gene length is so 100 has a scale. |
| Auto-detecting open reading frames / "Options holds Include partial ORFs, which" | I did not know a start codon could be anything but ATG. | One clause naming that some codes allow other start codons. |
| Transferring best-match CDS annotations / "Once you have mapped one reference's" | I could not follow this at all. Mapping, assembly, mapping result, and CDS models arrive together with nothing I can act on. | Say up front this is a preview of a later chapter. |
| Getting data back out / "and the Provenance submenu writes the" | Submenu implies more than one choice and I am not told what they are. | Name the items or say they vary. |
| What good looks like / "Confirm that the bases at 70613" | I understood the check but not why versions shift coordinates. | One clause saying a new version can insert or remove bases. |
| On the command line / "This section is optional. The window" | It says optional, then says the window cannot delete a track, so deleting a track needs a terminal I have never opened. That is not optional for me. | Say plainly that track deletion is the one task requiring the terminal. |
| On the command line / "Import the record. Despite the subcommand" | A subcommand named fasta that takes GenBank made me doubt I had copied the right line. | Keep the note, but say it is a naming quirk and not an error. |
| On the command line / "--start and --end bound the search" | Two counting systems in one chapter, and I do not know which one the numbers I read on screen use. | Repeat the 1-based window rule right beside the 0-based CLI rule. |
| On the command line / "--min-query-cover sets how much of a" | I do not know half of what, the query or the target. | Say half of the CDS being transferred. |
| On the command line / "--include-secondary treats secondary alignments as candidate" | Secondary and supplementary alignments are undefined and I could not judge whether to use either. | Say a beginner should leave both off. |

I learned that a reference bundle is a folder pretending to be a file, and that everything downstream in LGE points at that bundle rather than at my original download.

I still could not delete an annotation track, because the only route is the command line and I have never opened a terminal.

The sentence I liked most is "An ORF track is a set of candidates and not a set of genes, because ORF length is only a weak proxy for a real gene."
