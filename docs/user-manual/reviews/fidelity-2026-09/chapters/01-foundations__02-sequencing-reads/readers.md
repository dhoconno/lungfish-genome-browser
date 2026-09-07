# Merged reader report, Sequencing Reads

The four source reports are reader-1.md (sophomore, one genetics course), reader-2.md (bench technician, two years pipetting), reader-3.md (pre-med, English as second language), and reader-4.md (undergraduate, prior Geneious use). Rows that described the same sentence or the same gap in different words are merged into one row.

| Location | What stopped readers | Readers hit | Shortest fix |
|---|---|---|---|
| The four-line FASTQ record, header field list | Six fields are named in prose but the example header shows seven colon-separated values, so readers could not match the names to the numbers | 4 | Label the fields on the example instead of listing them in prose |
| The four-line FASTQ record, "occasionally N" | Readers could not tell whether an N is an error, is missing data, or is a problem they must fix | 4 | Say N means no call was made and this differs from a wrong call |
| Why you would do this, citation line | The citation renders on the page as an unfilled template placeholder with braces, not as English | 4 | Replace the placeholder with the actual citation text |
| Paired-end reads, R1 250 bases vs R2 249 bases | Readers could not tell whether mates having different lengths is normal or a sign of trouble | 4 | Say mates need not be the same length |
| Phred quality scores, "offset by 33" | ASCII is never explained, so readers had no way to get a character's numeric code | 4 | Gloss ASCII as the number that stands for each keyboard character |
| Phred quality scores, "Q35, about a 1-in-3,000 chance" | The table lists only round tens (Q30, Q40), so readers could not see how Q35 maps to 1 in 3,000 | 4 | Say Q35 falls between the Q30 and Q40 rows |
| Read length and platform table, "simplex" and "duplex" | Both terms appear only in the table and are never defined | 4 | Gloss both terms in one clause under the table |
| What good looks like, "comfortable for calling small variants" | "Small variants" is never glossed and no depth threshold is given for what would be uncomfortable | 4 | Gloss small variants and give a minimum depth number |
| What it is, "one fragment of DNA... written down as a string of letters" | Readers could not tell whether a read is the physical DNA molecule or the data record describing it | 3 | Say the read is the data the instrument wrote down, not the molecule itself |
| Why you would do this, variant call / assembly / classification | Three outputs are named in close succession with none of the three defined | 3 | Give each of the three a half-sentence gloss at first use |
| Before you start, GitHub download | Readers did not know how to download a specific file from a GitHub page | 3 | Add two sentences on how to save a single file from that page |
| Compressed FASTQ files, "unzip a file to look inside" | No instruction is given for unzipping a .gz file on a Mac, and readers were unsure whether this step is required | 3 | Say the step is optional, or say how to do it |
| Compressed FASTQ files, "22,662,846 bases" | The number has nothing to compare against, so readers could not judge whether it is a lot | 3 | Compare it to the size of the sequenced region |
| Paired-end reads, "The SRA convention" | SRA is never expanded anywhere in the chapter | 3 | Expand SRA at first use |
| Paired-end reads, counting a pair as one observation | Readers could not follow why counting both mates would double count the evidence | 3 | Say the two mates are not independent evidence because they came from one fragment |
| When the mates overlap, "amplicon libraries" | Amplicon library is used before it is defined, in a chapter about a non-amplicon sample | 3 | Gloss amplicon library here, or defer the example to the amplicon chapter |
| When the mates overlap, "uses bbmerge" | The tool name is given with no indication of what it does or whether the reader must install it | 3 | Say it is a bundled tool LGE runs for the reader |
| Phred quality scores, "Q equals minus ten times log10" | The formula appears before the plain-language version, and readers without recent log10 practice could not use it | 3 | Put the table first and mark the formula as optional |
| Phred quality scores table, Q30 "working definition of good" vs Q40 "routine" | Readers could not tell which of the two numbers is the actual threshold to judge against | 3 | State plainly which value is the threshold and which is the ceiling |
| A nanopore read, "a plain UUID" | UUID is never expanded or explained | 3 | Gloss it as a randomly generated unique name |
| A nanopore read, "errors are largely independent" | Readers could not see why independence between reads is what lets stacked reads correct each other | 3 | Add one sentence saying independent errors cancel out when reads vote at each position |
| A nanopore read, Q7.9 average vs the stated Q12-Q20 nanopore range | The fixture's own average sits below the range the chapter states as normal, and readers could not tell if the fixture is broken | 3 | Explain at first mention why this fixture reads below the stated range |
| A HiFi read, "which decodes to Q93" | Q93 falls past the end of every table in the chapter, so readers could not judge whether it is a real value | 3 | Say plainly that the scale runs past Q40 for consensus values |
| How LGE shows a read set, "bundle" | Bundle is used repeatedly before or without being defined as a specific container | 3 | Gloss bundle at first use as LGE's container holding a sample's paired files |
| How LGE shows a read set, "GC is the percentage of bases" | GC content is defined but readers are given no typical or worrying value to compare it to | 3 | Give a typical range for human samples |
| What good looks like, "a minimum of 50" against an average of 248.6 | Readers could not tell whether the short reads in the tail are a problem or expected after trimming | 3 | Say the short reads are the trimmed ones and are expected |
| What good looks like, "44.7x" | The x notation for depth is never explained | 3 | Say it means each base is covered about that many times on average |
| Before you start, "plugin pack" and "Docker Desktop" | Neither term is defined, and the reassurance that they are not needed here read as a warning of a future requirement | 3 | Say these are optional extra installs that only some later chapters need |
| What it is, "Plain-text format" | Readers did not know whether plain text meant they could open the file in Word or another editor | 2 | Say plain text means readable characters, openable in any text editor |
| What it is, "fixtures" | The word is used throughout the chapter without ever being defined | 2 | Gloss fixture at first use as the example dataset shipped with the manual |
| Why you would do this, "Genome in a Bottle" | The project name is used as if already known | 2 | Add one clause saying it is a reference project that supplies known-answer human samples |
| Before you start, "Cmd-N" | Readers could not tell whether the keystroke is required or just an alternative to the menu | 2 | State that either route does the same thing |
| Before you start, "You need a project open" | Readers did not know whether a project is a folder on disk or something internal to the app | 2 | Say a project is a folder on disk that LGE manages |
| Paired-end reads, "runs inward to meet it" | Readers could not tell whether the two mates always touch, sometimes overlap, or usually leave a gap | 2 | Say the mates run toward each other and may or may not overlap |
| Paired-end reads, shared header on two mates | Readers had just read that no two reads share a header, then saw two mates sharing one | 2 | Add "within one file" to the earlier uniqueness rule |
| Interleaved FASTQ and When the mates overlap, "Interleave," "Deinterleave," "Merge Overlapping Pairs" | Readers could not tell where in the app these named operations are found (menu, button, right-click) | 2 | Say where operations live, or point to the chapter that shows it |
| Read length and platform differences, mitochondrial genome | The chapter had been using chromosome 20 and switches genomes with no signal | 2 | Say the long-read fixture is mitochondrial before giving the comparison |
| Read length and platform table, "Ion Torrent" | The platform is listed but never used again, so readers could not tell if LGE supports it | 2 | Say whether LGE handles it |
| A nanopore read, "roughly a 1-in-5 chance" for Q7 | The table only lists round tens, so readers could not derive this figure themselves | 2 | Show the rounded arithmetic, or point back to the formula |
| A nanopore read, N50 gloss | The definition arrives in a trailing clause that readers had to reread several times | 2 | Give N50 its own sentence with a short worked example |
| A HiFi read, Q93 shown vs Q29 average | A single read displaying Q93 characters beside a fixture average of Q29 looked contradictory | 2 | Say the shown characters are the high end and the average includes weaker bases |
| How LGE shows a read set, "sparkline" | The term is never glossed | 2 | Say it is a small chart drawn without axes |
| How LGE shows a read set, first 1,000 records | Readers could not tell whether the summary cards, not just the read table, are limited to the first 1,000 records | 2 | Say the cards scan the whole bundle and only the table is windowed |
| What good looks like, two read-count targets | Hundreds of millions of reads and a few hundred thousand reads are both given with no rule connecting either to genome size | 2 | Give the rule that connects read count to genome size |
| What good looks like, coverage as the fourth number | Coverage is promised as one of four numbers judged from the read set, but it can only be produced after mapping, which the chapter has not covered | 2 | Say up front that this number comes only after mapping |
| Interleaved FASTQ, "read processors" | The phrase is vague and readers could not tell which tools are meant | 2 | Name one tool, or say when a downstream tool needs this shape |
| Phred quality scores, three tool names (fastp, BWA-MEM2, minimap2) | The tools are named with no explanation of what they do or whether the reader must install them | 2 | Say LGE ships and runs these tools automatically |
| What it is, "slice" | The word suggested a physical tissue slice rather than a region of data | 1 | Say the slice is a small region cut from the data, not the sample |
| What it is, "noisy" | The word was read literally, as involving sound | 1 | Gloss noisy as containing errors |
| What it is, "stacking those guesses until they agree" | The phrasing needed a second reading to get the literal meaning | 1 | State plainly that many reads over the same position are compared |
| What it is, advice given before the concepts it depends on | "So what should you do with this" arrives before the three practices it references are explained | 1 | Move this sentence to the end of the chapter |
| What it is, FASTQ never opened by hand | A reader who used Geneious did not know whether FASTQ is a file they open themselves | 1 | Say the file is not normally opened by hand |
| Why you would do this, fixture read-length figures | Readers could not tell whether the 250 to 10,000 base figures were fixture-specific or general platform figures | 1 | Say these two numbers come from the two fixtures |
| Before you start, download deferred to a later chapter | Files are downloaded here but importing them is covered only in a later chapter, leaving no instruction for what to do with them yet | 1 | Say plainly the files are only needed once the import chapter is reached |
| The four-line FASTQ record, arbitrary choice of the second record | Readers wondered whether the first record was special since the second is shown instead | 1 | Say the choice is arbitrary, or use the first record |
| The four-line FASTQ record, forward reference to Phred | The remark about quality characters resembling bases makes sense only after the Phred section, two headings later | 1 | Point forward to the Phred section here |
| The four-line FASTQ record, line wrapping on screen | The four-line record wraps across the screen, obscuring exactly the line boundaries the section is teaching | 1 | Say the block is four lines even though it wraps on screen |
| The four-line FASTQ record, "45,574 reads" | Readers could not judge whether this count is a lot or a little for a teaching slice | 1 | Say here that this is a small teaching slice |
| Compressed FASTQ files, LGE named before it is defined | A reader had to scroll back to find where LGE was first defined | 1 | No fix needed if the earlier definition is easier to notice |
| Paired-end reads, "reverse complement" | The illustration caption uses the phrase but the body text never explains it | 1 | Gloss reverse complement where it first appears |
| Paired-end reads, checking for a mismatched pair | Readers are warned that a split or reordered pair degrades quietly, with no way to check their own files | 1 | Point to whatever in LGE flags a mismatched pair |
| Paired-end reads, "mate" used before it is introduced | The term's meaning had to be worked out from context | 1 | Gloss mate at first use |
| Paired-end reads, "variant caller" | The term is used as though already known | 1 | Gloss variant caller at first use |
| When the mates overlap, finding insert size | Readers had no way to find their own insert size to check whether the merging discussion applies to their data | 1 | Say where insert size is reported |
| Phred quality scores, "P" in the formula | Readers could not tell whether P is a probability between 0 and 1 or a percentage | 1 | State that P is a probability between 0 and 1 |
| Read length and platform differences, "fences in" | The idiom was unfamiliar | 1 | Use "limits" or "restricts" instead |
| How LGE shows a read set, nine cards listed in one paragraph | Readers lost track of the cards partway through the list | 1 | Give a small table of card name and meaning |
| How LGE shows a read set, "bar" vs "cards" naming | The summary bar and the summary cards are used as if interchangeable without saying so | 1 | Use one consistent name |
| How LGE shows a read set, command-line mention | A reader with no terminal experience found "available from the command line" a dead end | 1 | Say the GUI path alone is sufficient |
| How LGE shows a read set, import computing no report vs cards already described | Readers could not tell which numbers appear immediately on import and which require running a report | 1 | Say which numbers appear immediately and which need the report |
| How LGE shows a read set, entire section not doable without import | A reader who had not yet reached the import chapter could not perform any step in this section | 1 | Mark the section as read-only until after the import chapter |
| What good looks like, depth and coverage used interchangeably | The two terms are used as synonyms with no note that they mean the same thing here | 1 | State once that depth and coverage mean the same thing here |
| What good looks like, "ask your sequencing provider" | The advice names no specific numbers to request | 1 | Name the two or three numbers to quote |

**The merged table has 73 rows. 28 of those rows were hit by three or more readers.**

## Summary

The most common failure was a term or number introduced and used without being defined at first mention, from ASCII and simplex/duplex to bundle, SRA, and small variants. The second most common failure was giving a precise number, such as a base count, a depth value, or a quality score, with no comparison point so readers could not judge whether it was expected or a problem. A smaller but recurring failure was structural, where a placeholder rendered as raw template text, or where a section described steps that could not be attempted because a dependency such as import or mapping was deferred to a later chapter.
