# Reader reports, merged - Amplicons and Shotgun Sequencing

Four readers reviewed this chapter. The table below merges their stops, sorted by how many readers hit the same sentence or gap.

| Location | What stopped readers | Readers hit | Shortest fix |
|---|---|---|---|
| Why you would do this, mean depth of 44.7 | No sense of whether 44.7 is a good, bad, or ordinary depth. The chapter defines depth but never gives a value to want. | 4 | State a rough band for adequate depth. |
| Why you would do this, coverage of 99.99% | No sense of whether 99.99% is routine or excellent, since any number near 100 looks the same to a reader without a baseline. | 4 | Say what a poor or typical value looks like. |
| What an amplicon looks like, positions 1000 to 1021 are 22 bases | The range only works out to 22 bases if both ends count, and readers had to count on their fingers, then were undercut when the BED row later shows 999 to 1021. | 4 | State once that these ranges are inclusive. |
| Primer trimming, the Inspector | The Inspector is named and used for real steps (viewing the trim, checking coverage) but never located on screen or introduced as a concept. | 4 | Name the Inspector as the side panel and say where it sits in the window. |
| Primer trimming, provenance sidecar | "Provenance sidecar" is two unfamiliar words with no gloss, so readers could not tell if it is a file, panel, or setting. | 4 | Say it is a small file saved beside the result recording what was run. |
| The schemes LGE ships, importing a scheme not bundled | The only import instruction given is a terminal command, and none of the readers had ever opened a terminal. | 4 | Give the in-app menu path for importing a scheme. |
| The schemes LGE ships, spike-in primers | "Spike-in primers" collides with "spike protein" or "spike gene" from SARS-CoV-2 news and lineage naming, so readers read it as protein-related. | 4 | Say spike-in means extra added primers, unrelated to the spike gene. |
| Why you would do this, the MHC reference is a database of alleles | A reference that is hundreds of separate allele sequences rather than one continuous genome broke readers' mental model of what a reference is. | 4 | State plainly that some references are a list of known alleles, not a chromosome. |
| What an amplicon looks like, Read 2 starts at 1250 | Readers could not see why read 2 starts at 1250 rather than 1000, since nothing said reads are measured inward from each end. | 4 | State that paired reads start at opposite ends and point at each other. |
| What a primer scheme is, the score column | The BED score column is listed with the other columns but never explained, so readers could not tell what a value of 1 means or whether to care. | 4 | Say the score column is unused here. |
| Amplicon sequencing, allele-frequency setting of 0.05 | Readers could not tell what unit 0.05 is in, whether percent or fraction, or what it means for a pile of reads. | 4 | Say 0.05 means the variant appears in 5 percent of reads at that position. |
| Amplicon sequencing, chimeric product | "Chimeric" is used with no gloss, and one reader also flagged the neighboring word "template" as unglossed in the same sentence. | 4 | Gloss chimeric as an artificial hybrid of two molecules. |
| Primer trimming, bbduk vs ivar trim as engine choice | Two tool names appear in code font with no explanation of what choosing between them changes or when to switch. | 4 | Say the default is fine, and name the one situation that calls for the alternative. |
| How to tell which prep, SRA and ENA | Both acronyms appear unexpanded, and readers would not know what these are or where to look inside them. | 4 | Expand both names once as public sequence archives. |
| What it is, FASTQ's four lines per read | The chapter refers to "the same four lines per read" as if the reader already knows the FASTQ layout from an earlier chapter, but readers did not retain it. | 3 | Name the four lines in half a sentence here. |
| What it is / Why you would do this, paired files or read pairs | Readers did not know why a single library produces two files, or what a read pair is, since paired-end sequencing is assumed rather than explained. | 3 | Say a paired-end run writes read 1 and read 2 into two separate files. |
| Why you would do this, HG002 named with no introduction | HG002 is used as though the reader has already met it, with no clue whether it is a person, a cell line, or a bundled file. | 2 | Say in half a sentence that HG002 is a reference human sample used for benchmarking. |
| Why you would do this, the Williams project named with no introduction | "Williams" appears with no explanation of whether it is a person, a lab, or a dataset. | 2 | Identify the project in one clause, for example as a dataset from a lab. |
| Why you would do this, the two allele lengths (577 at 156 bases, then another length) | Readers could not tell why two different lengths are given or what to do with the fact, and the numbers given do not visibly add up to the stated total. | 2 | Say why the two lengths exist, or account for the full total. |
| What an amplicon looks like, the 100 bases in the middle go unread | Readers could not tell whether this middle gap is a problem to look for or normal and expected. | 3 | Say the neighboring tiled amplicons cover this gap, so it is expected. |
| Amplicon sequencing / What a primer scheme is, loci | "Loci" is unglossed, and one reader noted it is listed in the chapter's glossary but not linked in the running text. | 3 | Gloss loci as specific positions on the genome. |
| Shotgun sequencing, "close enough to random" hedge | The hedge reads as first claiming randomness then qualifying it, leaving readers unsure whether the non-randomness matters later. | 3 | State plainly that read placement is effectively random for this purpose. |
| Shotgun sequencing, adapter trimming described as happening "often" | Readers could not tell whether they need to do anything about adapters in LGE or how to check. | 2 | Say what LGE does by default and how to confirm it happened. |
| What a primer scheme is, BED's zero-based half-open counting | The rule that BED starts count from 0 and ends are excluded is compressed into unfamiliar shorthand that took multiple readings to untangle. | 2 | Split into two short sentences, or show one primer's coordinates written both ways. |
| Target enrichment, capture, hybridization, and probes named together | Three names for the same technique arrive in one dense sentence, and "hybridisation" is unglossed. | 2 | Keep one name for the technique and gloss hybridisation separately. |
| Target enrichment, Twist and IDT named with no context | The two company names appear with no signal that they are vendor examples rather than something the reader must recognize or use. | 3 | Say they are commercial vendors, given only as examples. |
| Primer trimming, dropped reads location unreported | Readers are warned that some ivar trim options can drop reads but are not told whether that is a problem or where to see how many were dropped. | 3 | Say where the dropped-read count is reported. |
| The schemes LGE ships / Primer trimming, BAM named with no gloss | BAM appears in a sentence readers need to act on, with no explanation of what it is. | 2 | Gloss BAM as the aligned-read file at first use. |
| Primer trimming, pileup unglossed | "Pileup" is used with no gloss anywhere in the chapter. | 2 | Gloss pileup as the stack of reads at one position. |
| What a primer scheme is, the .lungfishprimers bundle looks like a single file | Readers did not know a folder can display as one item in macOS, and were unsure whether opening or double-clicking it was safe. | 2 | Say to right-click and choose Show Package Contents to look inside. |
| What it is, variant caller unglossed | "Variant caller" is used with no gloss at the point it is introduced, though it is central to the chapter's main point. | 1 | Gloss it as the program that decides where the sample differs from the reference. |

## Summary

The most common failure across all four readers is a number given with no scale to judge it against. Depth, coverage percentage, and allele frequency all arrive as bare figures with no stated range for what counts as low, typical, or good. The second most common failure is a term or entity used as though the reader already met it earlier, including the Inspector, HG002, the Williams project, and provenance sidecar, none of which are introduced at first use. The third most common failure is an instruction that assumes terminal access, most visibly the only route given for importing a primer scheme, which every reader without terminal experience could not follow.

Row count is 31.
Rows hit by three or more readers is 21.
