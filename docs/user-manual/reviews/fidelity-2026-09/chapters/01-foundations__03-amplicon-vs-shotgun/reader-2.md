# Reader report: Amplicons and Shotgun Sequencing

Persona: a senior who has pipetted for two years but never analyzed data. I have run PCRs and made libraries at the bench. I have never opened a terminal and have never looked at a FASTQ or a BAM.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "Both preparations produce FASTQ files that" | I have never opened a FASTQ. The sentence tells me it has "the same four lines per read" as if I already know what those four lines are. | One clause naming the four lines. |
| What it is / "the same pair of files" | Why are there two files? I made one library from one tube. | Say that paired-end runs write read 1 and read 2 into two files. |
| What it is / "and a variant caller that is not" | "Variant caller" arrives with no gloss and is the whole point of the paragraph. | Gloss it here as the program that decides where the sample differs from the reference. |
| What it is / "LGE can do the trim in either" | I could not tell whether this is a choice I make or a choice the app makes for me. | Say plainly that the user picks. |
| Why you would do this / "The HG002 chromosome 20 slice" | I do not know what HG002 is or where this slice came from. It is named as if I have met it. | Half a sentence saying it is a reference human sample used for benchmarking. |
| Why you would do this / "Mapped back to its own reference" | "Mapped" is used before it is explained. I only guessed from context. | Gloss mapped at first use. |
| Why you would do this / "of 44.7 reads per position and" | I do not know whether 44.7 is a lot. The text says depth is the count but never says what count is good. | State the range that counts as enough for variant calling. |
| Why you would do this / "cover 99.99% of the slice" | Same problem. Is 99.99% routine or excellent? | Say what a normal value looks like. |
| Why you would do this / "The Williams MiSeq genotyping project is" | Whose project? I could not tell if Williams is a person, a lab, or a dataset name. | Name it as a dataset from a lab. |
| Why you would do this / "and the reference it is genotyped" | "Genotyped against a database of allele sequences" was the sentence I had to read three times. The reference is not a genome here and that surprised me. | Say directly that for MHC the reference is a list of known alleles, not a chromosome. |
| Why you would do this / "577 of them 156 bases" | I could not work out why two different lengths exist or whether that matters to me. | One clause saying different loci give different amplicon lengths. |
| Shotgun sequencing / "which is close enough to random for" | This hedge made me stop. Is it random or not, and does the not-quite matter later? | Either drop the hedge or say what the bias is. |
| Shotgun sequencing / "Adapters do get removed, but adapter trimming" | So do I need to do adapter trimming in LGE or not? "Often does it" left me unsure whether to check. | Say how to check whether adapters are already gone. |
| Amplicon sequencing / "The SARS-CoV-2 schemes LGE ships are" | I work on macaques. This is the first place the chapter assumes I care about a virus and I did not know if any of this applies to me. | Say whether a non-viral panel can be used here. |
| Amplicon sequencing / "it can sometimes join two different templates" | "Chimeric product" is named but not glossed, and I could not tell how worried to be. | Gloss chimera in place. |
| Amplicon sequencing / "which is pre-filled at 0.05, usually filters" | I do not know what 0.05 means as a frequency. Five percent of what? | Say it means the variant is seen in 5 percent of reads at that position. |
| What an amplicon looks like / "A 22-base forward primer binds at reference" | The arithmetic did not work for me. 1000 to 1021 looks like 22 positions only if both ends count, and two sentences later 1000 to 1399 is called 400 bases, which needs the same rule. I checked this twice. | State once that these ranges include both endpoints. |
| What an amplicon looks like / "Read 2 covers positions 1250 to" | I could not see why read 2 starts at 1250. Nothing said reads are measured inward from each end. | Say read 2 is the last 150 bases of the amplicon. |
| What an amplicon looks like / "from the other strand" | Strand came in with no explanation of why it changes where the read sits. | Gloss what the other strand means for a paired read. |
| What an amplicon looks like / "The 100 bases in the middle" | I could not tell whether uncovered middles are normal and fine or a problem I should look for. | Say that neighbouring amplicons are designed to cover this. |
| Primer trimming / "Its engine is `bbduk` by default, with" | Two tool names in code font with no explanation of what choosing between them would do for me. | One clause on when you would switch. |
| Primer trimming / "`ivar trim` takes the primer coordinates" | I could not follow "primer footprint". I think it means the stretch the primer covers, but I was guessing. | Gloss footprint. |
| Primer trimming / "from the Inspector's Primer Trim tab" | This is the first mention of the Inspector and I do not know where it is in the window. | Say where the Inspector sits in the app. |
| Primer trimming / "its provenance sidecar records the exact options" | "Provenance sidecar" meant nothing to me. | Gloss it as a small file recording what was run. |
| Primer trimming / "Some `ivar trim` options can drop" | I could not perform anything here. I want to know if reads were dropped in my run and the text does not say where to look. | Point to where the dropped count is reported. |
| What a primer scheme is / "chrom, start, end, name, score, strand" | "Score" is the only column I could not guess, and nothing says what a score of 1 means. | Say the score column is unused here. |
| What a primer scheme is / "LGE converts for you, and you only" | Reassuring, but I did not know whether the coordinates I see in the app are the 0-based or the 1-based ones. | Say which numbering the app displays. |
| What a primer scheme is / "a manifest, and a provenance note naming" | Manifest is another unglossed file word. | Gloss manifest. |
| The schemes LGE ships / "more rows than twice the amplicon count" | I had to read this twice to see that two primers per amplicon is the baseline. | Say each amplicon needs two primers, so 98 amplicons expect 196 rows. |
| The schemes LGE ships / "V4.1 adds spike-in primers that restore" | "Spike-in primers" is not glossed and I could not tell whether this makes V4.1 always the better choice. | Gloss spike-in and say when to prefer V4.1. |
| The schemes LGE ships / "which on the command line is `lungfish-cli primers import`" | I have never opened a terminal. This is the only instruction given for importing and I cannot follow it. | Give the menu path for importing a scheme in the app. |
| The schemes LGE ships / "so a BAM aligned to either name" | BAM appears here for the first time with no gloss, in a sentence I needed to act on. | Gloss BAM at first use. |
| How to tell which prep / "in the SRA or ENA fields describing library" | SRA and ENA are unexplained acronyms and I would not know where to look in them. | Name them as public sequence archives. |
| How to tell which prep / "Amplicon coverage steps up and down at" | I could not perform this check. I do not know where in LGE to look at a coverage profile. | Point to the view that shows coverage. |
| Target enrichment / "For every workflow in this manual, treat" | This contradicted my expectation after being told capture is a third route, and I had to reread to be sure there is genuinely nothing to set. | Say there is no capture-specific setting anywhere in LGE. |
| What good looks like / "which the Inspector shows on the trimmed" | I could not do this. Nothing tells me what a trimmed track looks like versus an untrimmed one. | Describe the visible difference. |
| What good looks like / "a cluster of high-frequency calls sitting at" | I would not recognise a primer position in a variant list without the scheme open beside it. | Say how to see primer positions alongside variants. |

One thing I learned. The first and last stretch of an amplicon read is the primer I added at the bench, not my sample, so a variant caller reads my own reagent back to me as a mutation.

One thing I still could not do. Import a primer scheme, since the only route given is a terminal command.

The sentence I liked most. "Those calls match no lineage, appear in no database, and track exactly with the protocol rather than with the biology."
