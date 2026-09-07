# Reader report: Amplicons and Shotgun Sequencing

Reader 4. Undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Somebody first turned a tube..." | "Nucleic acid" is used before anything says whether that means DNA or RNA or either. I only ever loaded DNA in Geneious. | Say once that nucleic acid here means DNA or RNA. |
| What it is, "Each holds the same four lines..." | "The same four lines per read" assumes I remember the FASTQ layout from the previous chapter. I did not. | Name the four lines in half a sentence. |
| What it is, "Both preparations produce FASTQ files..." | "The same pair of files" told me FASTQ comes in twos but never why. | Say a paired-end run makes two files, one per read direction. |
| Why you would do this, "It holds 45,574 Illumina read pairs" | A read pair is not defined anywhere before this number. | Gloss read pair at first use. |
| Why you would do this, "Mapped back to its own reference" | I am told what depth is but not whether 44.7 is good, bad, or ordinary. | Add a clause saying what range is normal for this kind of data. |
| Why you would do this, "and cover 99.99% of the slice" | Same problem in the other direction. I cannot tell if 99.99% is expected or unusually good. | Say what a poor coverage percentage would look like. |
| Why you would do this, "That coverage is smooth, because..." | I do not know what local base composition has to do with coverage rising and falling. | One clause on GC content affecting how well fragments are recovered. |
| Why you would do this, "and the reference it is genotyped..." | A reference that is a database of 970 allele sequences, not one continuous genome, broke my mental model. In Geneious the reference was always one sequence. Also "allele" is not glossed. | Say plainly that some references are a list of known variants rather than a genome. |
| Why you would do this, "577 of them 156 bases long" | I could not work out why I am given these two lengths. They never come back. | Say what the two lengths signify, or cut them. |
| Shotgun sequencing, "In a shotgun prep the nucleic..." | "By an enzyme or by physical shearing" read twice. I could not tell if this is a choice I make or just background. | Say it is a bench choice that does not change the analysis. |
| Shotgun sequencing, "If your target is one part in..." | I followed the arithmetic but do not know what a realistic on-target fraction is for a real sample. | Give one concrete example, such as a pathogen in blood. |
| Amplicon sequencing, "An amplicon prep uses PCR instead..." | PCR is never spelled out and "polymerase" is not glossed. I half remember PCR from lecture. | Expand PCR once at first use. |
| Amplicon sequencing, "The SARS-CoV-2 schemes LGE ships..." | First mention that LGE ships schemes, before I knew what a scheme file even was. | Add "listed later in this chapter", or move the sentence. |
| Amplicon sequencing, "PCR also introduces artifacts of its own." | "Chimeric product" stopped me. Chimeric is not glossed and is not in the chapter's glossary list. | Gloss chimera in one clause. |
| Amplicon sequencing, "and the minimum allele-frequency setting..." | I do not know whether 0.05 means 5% or something else, nor whether I would ever change it. | Say 0.05 means 5% of reads. |
| What an amplicon looks like, "A 22-base forward primer binds..." | Positions 1000 to 1021 is 22 bases only if the end is included. I counted on my fingers, then the BED row later said 999 to 1021 and I doubted myself again. | Say inclusive explicitly at first use. |
| What an amplicon looks like, "The amplicon is everything between..." | I recomputed all three numbers (22, 22, 400) before I trusted the paragraph. | Show the arithmetic once, or give fewer numbers. |
| What an amplicon looks like, "Read 2 covers positions 1250 to 1399" | I do not know what "from the other strand" does to the read. Is it stored backwards in the file? | One clause saying the aligner handles direction for you. |
| What an amplicon looks like, "The 100 bases in the middle get no..." | I could not tell whether this gap is a problem I must fix or normal. | Say the tiling neighbours cover it, so it is expected. |
| Primer trimming, "Its engine is `bbduk` by default..." | Two tool names, no guidance on when I would pick the alternative. | Say which situation calls for the alternative. |
| Primer trimming, "`ivar trim` takes the primer coordinates..." | BAM appears here with no introduction. The Next section says a later chapter covers it. | Gloss BAM as the aligned-read file at first use. |
| Primer trimming, "Soft-clipping means the bases stay..." | "Pileup" is new and not glossed. | Gloss pileup in one clause. |
| Primer trimming, "In LGE this runs after alignment..." | I have no idea what the Inspector is or where it sits in the window, so I could not perform this step. | Say the Inspector is the side panel, or point to the chapter with the picture. |
| Primer trimming, "and its provenance sidecar records..." | "Provenance sidecar" means nothing to me. | Say it is a small companion file recording what was run. |
| Primer trimming, "Some `ivar trim` options can drop..." | I am told reads can be dropped but not whether that is bad or how I would notice. | Say whether the dropped count is reported anywhere. |
| What a primer scheme is, "For each primer it records which..." | Six plain-English items, then six column names, given as separate lists. I had to map them by position myself. | Pair each column name with its meaning. |
| What a primer scheme is, "a score, and which strand it binds" | The score column is never explained, and the example row just holds 1. | Say the score is unused here. |
| What a primer scheme is, "MN908947.3\t999\t1021\t..." | The row is tab separated so I could not see where one field ended in my reader. | A header line above the row. |
| What a primer scheme is, "LGE packages a scheme as a..." | "A folder that macOS shows as one item" left me unable to look inside if I needed to. | Say right-click then Show Package Contents. |
| What a primer scheme is, "Bundles you add yourself live in..." | I could not find the project folder on my disk from this text. | Say where a project folder lives, or point to the chapter that does. |
| The schemes LGE ships, "**ARTIC SARS-CoV-2 V3** is the original..." | Read three times. The explanation for 218 rows arrives after the number, and I had already stopped to do the arithmetic. | Put the reason before the number. |
| The schemes LGE ships, "and V4.1 adds spike-in primers..." | "Spike-in primers" sounds like it means the spike gene, and I could not tell whether it does. | Say spike-in means extra added primers, unrelated to the spike gene. |
| The schemes LGE ships, "**QIAseq Direct SARS-CoV-2 with..." | "Built for fragmented RNA" does not tell me why fragmented RNA needs a different kit. | One clause on degraded samples. |
| The schemes LGE ships, "**Midnight 1200 bp V1** uses far..." | Oxford Nanopore is named once and never explained. | Gloss it as the long-read platform. |
| The schemes LGE ships, "Any scheme LGE does not bundle..." | The only import route given is a terminal command. I have never opened a terminal, so I cannot import a scheme. | Give the in-app menu path first. |
| The schemes LGE ships, "Every bundled scheme declares both..." | I could not tell why one sequence carries two accession names or whether I must care. | One clause saying two databases named it differently. |
| The schemes LGE ships, "Those calls match no lineage..." | "Track exactly with the protocol rather than with the biology" read twice. "Track with" was the hard part. | A plainer verb. |
| How to tell which prep, "The sequencing submission record names..." | SRA and ENA are not expanded, and I would not know where in a record to look. | Expand both once. |
| How to tell which prep, "A hint is not proof." | This felt like it contradicted the earlier warning that not trimming produces phantom variants. I could not tell which harm is worse. | Say which failure is easier to spot afterwards. |
| Target enrichment, "Twist and IDT sell panels of this kind." | Two company names, and "panel" is used without being glossed. | Gloss panel once. |
| Target enrichment, "When you inspect coverage, expect..." | I would not recognise a probe boundary while looking at a coverage plot. | Describe the shape, such as shallow scallops between targets. |
| What good looks like, "Confirm the primer trim actually ran..." | The Inspector again. I do not know where it is, so I could not run this check. | Name the window region. |
| What good looks like, "And look at the variant list for..." | I would not know which positions are primer positions while reading a variant list. | Say the scheme BED file gives those coordinates. |

The one thing I learned: reads from an amplicon prep begin and end with primer sequence that is not my sample, which is why a variant caller will happily report the primer as a mutation.

The one thing I still could not do: import a primer scheme that LGE does not bundle, because the only route offered is a terminal command and I have never opened a terminal.

The sentence I liked most: "What it found was the primer."
