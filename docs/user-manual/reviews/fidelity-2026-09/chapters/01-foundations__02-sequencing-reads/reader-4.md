# Reader report: Sequencing Reads

Reader 4. Undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Reads arrive in a FASTQ file" | In Geneious I only saw a list of sequences with names. I never saw a file with four lines. I could not tell whether FASTQ is something I open or something the program opens for me. | One sentence saying you never open this file by hand. |
| What it is, "This chapter takes those three in turn" | The word "fixtures" appears with no explanation. I thought a fixture was lab equipment. | Gloss fixture as a small practice dataset supplied with the manual. |
| What it is, "The HG002 chromosome 20 slice supplies" | HG002 is not explained here. I had to read two sections further to learn it is a person's genome. | Say at first mention that HG002 is a well-studied human sample. |
| Why you would do this, "Reads for both fixtures are cited" | The line prints curly braces and code on the page. I could not tell whether I was supposed to type that somewhere. | Replace the placeholder with the real citation. |
| Why you would do this, "A variant call is a claim that" | Three claims in a row about variant calls, assemblies, and classifications, none of the three defined. I know variant from genetics class but not assembly as a noun. | Gloss assembly and classification at first use. |
| Before you start, "You need a project open" | I did not know what a project is in this app. In Geneious everything sat in a sidebar folder. Is a project a folder on my computer or something inside the app? | One sentence saying a project is a folder on disk that the app manages. |
| Before you start, "Download the files HG002.chr20.10.0" | The link goes to a GitHub page. I have never used GitHub and do not know how to download two specific files from a page like that. | Say how to download from that page, or give direct file links. |
| Before you start, "Nothing here needs a plugin pack" | I do not know what a plugin pack or Docker Desktop is. Being told I do not need them made me worry I will need them later. | Drop the mention, or gloss both in one clause. |
| The four-line FASTQ record, "Here is the second record in HG002" | The example wraps across my screen, so I could not tell where line 2 ended and line 4 began. That is exactly what the section is teaching. | Say the block is four lines even though it wraps on screen. |
| The four-line FASTQ record, "This one is an Illumina identifier" | Six things are listed in one sentence and I could not match any of them to the numbers in the header. I read it three times and gave up. | Match each field to its number, or drop the list. |
| The four-line FASTQ record, "occasionally N, the letter for" | I did not know an N could appear in a read, or whether an N is a problem I have to fix. | Say whether N bases are normal and whether I must act on them. |
| The four-line FASTQ record, "Each of the two files in this" | I could not judge whether 45,574 reads is a lot or a little. The answer arrives many pages later. | Say here that this is a small teaching slice. |
| Compressed FASTQ files, "Unzip a file to look inside" | I do not know how to unzip a .gz file on a Mac. Double-clicking works for .zip but I have never seen .gz. | Say how to do it, or say plainly that you never need to. |
| Paired-end reads, "One starts at one end of" | I could not picture whether the two reads meet, overlap, or leave a gap in the middle. | One sentence saying there is usually a gap between the mates. |
| Paired-end reads, "which is why the two records" | Earlier the chapter said no two reads share a header. Now two reads share a header. It took me two readings to see the earlier rule was per file. | Add "within one file" to the earlier sentence. |
| Paired-end reads, "(in the R2 file, 249 bases)" | R1 is 250 bases and R2 is 249. I could not tell whether that mismatch is normal or a sign of trouble. | Say that mates need not be the same length. |
| Paired-end reads, "the mate's position narrows down" | The word mate is used before it is introduced. I worked out it means the other read of the pair only from context. | Gloss mate at first use. |
| Paired-end reads, "a variant caller counts a pair" | Variant caller is used as though I already know it. I do not. | Gloss variant caller at first use. |
| When the mates overlap, "which is common in amplicon libraries" | Amplicon library is unexplained. I know PCR from class but not what a library is. | Gloss library here, or defer amplicons entirely to the next chapter. |
| When the mates overlap, "LGE's Merge Overlapping Pairs operation" | I could not tell where this operation lives. Is it a menu, a button, a right-click? The chapter never says how to run an operation. | Say where operations are found, or point to the chapter that shows it. |
| Interleaved FASTQ, "Interleaving into a single alternating file" | Same problem. Interleave and Deinterleave are named with no indication of where to click. | Point to where operations live. |
| Phred quality scores, "It is defined as Q equals minus" | I have not used a logarithm since high school. I could not get from the formula to the table and simply trusted the table. | Say the reader may skip the formula and use the table. |
| Phred quality scores, "Q40, 1 in 10,000, Routine on modern" | The Q30 row calls Q30 the working definition of a good base, but the Q40 row calls Q40 routine. If Q40 is routine, why is Q30 the good one? | Reconcile the two rows in one sentence. |
| Phred quality scores, "In the file each score is" | I do not know what ASCII is. The whole decoding paragraph assumes I can look up a character's ASCII code, and I cannot. | Gloss ASCII as a numbering of keyboard characters. |
| Phred quality scores, "so those five bases are Q35" | I followed 68 minus 33 equals 35, but I could not get from Q35 to a 1-in-3,000 chance because the table only lists round tens. | Show the step, or say it falls between the Q30 and Q40 rows. |
| Read length and platform, "Q12 to Q20 simplex, Q30 plus duplex" | Simplex and duplex appear only in this table cell and are never explained. | Gloss both, or drop them from the table. |
| Read length and platform, "Ion Torrent, 200 to 400 bp" | The table lists four platforms but the chapter only uses three. I could not tell whether Ion Torrent matters for anything I will do. | Say which platforms LGE actually handles. |
| A nanopore read, "The header is a plain UUID" | UUID is not explained. I guessed it means a random-looking name. | Gloss UUID, or just call it a random identifier. |
| A nanopore read, "the nanopore reads average Q7.9" | Q7.9 is below every number in the Phred table, which said Q10 is usually trimmed away. I could not tell whether this fixture is broken. | Flag here that these reads sit below the healthy range. |
| A nanopore read, "the errors are largely independent between" | I did not follow why independence makes stacking reads work. I accepted it without understanding it. | One sentence on why independent errors cancel out. |
| A HiFi read, "which decodes to Q93" | Q93 is far off the end of the table. I could not judge whether that means near-perfect or means the number is not meaningful. | Say plainly that Q93 is a ceiling, not a measurement. |
| A HiFi read, "the HiFi reads average Q29, with" | The single read shows Q93 characters but the fixture averages Q29. Those two numbers looked contradictory and I could not reconcile them. | Explain why per-character values run so far above the average. |
| How LGE shows a read set, "Click a FASTQ bundle in the" | Bundle appears here for the first time as the thing in the sidebar. Earlier the chapter talked about files. I did not know whether a bundle is one file, two, or a folder. | Gloss bundle at first use. |
| How LGE shows a read set, "Its top pane holds one" | I do not know what a sparkline is. | Gloss sparkline as a small inline chart. |
| How LGE shows a read set, "GC is the percentage of bases" | The chapter says what GC is but never why I should care or what a good value looks like, unlike every other card. | Say what GC content tells you. |
| How LGE shows a read set, "Importing reads does not compute a" | This says no report is computed on import, yet the section above describes nine cards and three charts already on screen. I could not tell what appears before I run anything. | Say which numbers appear immediately and which need the report. |
| What good looks like, "A whole human genome at usable" | Two very different targets are given, hundreds of millions and a few hundred thousand, with no way for me to work out which applies to my own sample. | Give a rule for picking the right target. |
| What good looks like, "Mapping this fixture's reads back to" | Mean depth of 44.7x uses an x notation never explained, and mapping is used as a step I have not been shown. | Gloss depth and the x notation. |
| What good looks like, "which is comfortable for calling small" | I do not know what counts as a small variant, or what depth would not be comfortable. | Give the threshold number. |

The one thing I learned. A FASTQ file spends four lines on every read, and the fourth line gives one confidence character per base, so the file itself tells you how much to trust each letter.

The one thing I still could not do. Get the two fixture files onto my computer from that GitHub link and open them in the app, because the chapter shows neither the download nor the import.

The sentence I liked most. "One read is a short, noisy guess at what one piece of your sample said."
