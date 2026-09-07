# Reader report, Mapping Reads to a Reference

Persona, a senior who has pipetted for two years and never analyzed data. Read cold, top to bottom.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Mapping takes two things, a pile" | I do not know what counts as a reference genome here. Is it the whole species genome or one file somebody made for my experiment | One sentence saying a reference is a known genome sequence you compare against |
| What it is, "a compressed binary container holding" | Binary container means nothing to me. I cannot open it in TextEdit then | Say plainly that you cannot read a BAM by eye and the app reads it for you |
| What it is, "and a score saying how sure" | I do not know what the score is called or what range it runs over. MAPQ turns up much later | Name the score here and point ahead to the MAPQ setting |
| What it is, "ending in `.bai`, which lets a viewer" | Do I have to make this file or does the app make it | Say the app writes it for you |
| What it is, "so switching mappers changes the answers" | Changes them how much. A little could mean anything | The four mapper table later answers this, a pointer to it would have stopped my worry |
| Why you would do this, "or from a repeat that appears" | I do not know what a repeat is in genome terms | Gloss repeat at first use |
| Why you would do this, "The slice holds 45,574 read pairs" | Read pairs versus reads confused me until the next clause. I had to read twice | Put the word pair in the earlier sentence about the two files |
| Why you would do this, "drawn from a 500 kb window" | kb here, and 500 kb versus 10.0 to 10.5 Mb in the filename, I could not connect them | Say the 0.5 Mb between 10.0 and 10.5 Mb is the 500 kb |
| Before you start, "the manual's fixtures on GitHub at" | I have never used GitHub. I did not know if I needed an account | One line saying no account is needed |
| Before you start, "Three of the four mappers arrive in" | I do not know what a plugin pack installs or how long it takes or whether it needs the internet | Say it downloads and roughly how long |
| Before you start, "No Docker Desktop is needed" | I do not know what Docker is, so this reassurance meant nothing to me | Drop it or say it as no extra software is required |
| Procedure, "titled **Mode** for the three mappers" | I had to reread this parenthesis twice to work out which mappers | Say Mode for BWA-MEM2, Bowtie2, and BBMap |
| Procedure, "a sixth section appears between Preset" | I could not tell if this happens to me. I only selected one bundle | Fine, but the sentence starts with the exception before the normal case |
| Procedure step 1, "click the `HG002.chr20.10.0-10.5Mb` read bundle" | After importing two FASTQ files I expected two sidebar items, not one bundle | Say the pair imports as a single bundle |
| Procedure step 4, "it stops guessing the moment you change" | I did not know what stops guessing means in practice. Does my choice stick if I go back | Say your choice sticks for the rest of the session |
| Procedure, "Observed max read length: 250 bp" | I do not know whether 250 bp is good, bad, or just what it is | Say this is only a description, not a quality judgement |
| Procedure, "then `samtools view` to drop unwanted records" | Unwanted by whose definition. I would want to know what got dropped | Name what the filter step removes |
| Procedure, "such as `Analyses/minimap2-20260906-134512/`" | I could not decode the number. Guessed date then time, but it took a moment | Say the folder is named for the mapper plus the date and time |
| Settings, Reference, "It defaults to the first reference the app finds" | First by what order. Alphabetical, or import order | Say which order |
| Settings, Preset, "Assembly-to-assembly, Spliced CDS/cDNA" | I do not know what any of these three are, and CDS is not glossed anywhere | Gloss CDS and cDNA, or say ignore these unless you know you need them |
| Settings, Run Mode, "for example two sequencing runs of the same tube" | This was the one line that made the whole setting click, but it arrives after the warning | Nothing, this one worked, I only wished it came first |
| Settings, Read Group, "written as an `@RG` line" | I do not know what a BAM header is, so a line in it is abstract | Say the header is the descriptive block at the top of the file |
| Settings, ID, "it accepts any text without spaces" | Why no spaces here but spaces allowed for Sample | Say the format requires it |
| Settings, Library, "which is what duplicate marking compares against" | I do not know what duplicate marking is. It is never explained | Gloss duplicate marking or drop the reference |
| Settings, Platform, "as long as it still holds the old preset's default" | I read this three times. I think it means it will not overwrite something I typed | Say it will not overwrite a value you typed yourself |
| Settings, Threads, "reports 14 threads on a 14-core machine" | I do not know how many cores my Mac has or how to find out | Say the app fills in the right number so you do not need to know |
| Settings, Secondary alignments, "with Bowtie2 adding `-k 10`" | These flags mean nothing to me and I cannot act on them | Say the effect differs by mapper without the flags |
| Settings, Supplementary, "the command-line flag is the inverse" | Inverse of the checkbox made me stop and work it out | Say checked keeps them, and the flag removes them |
| Settings, Min mapping quality, "since 60 is the practical ceiling" | Practical ceiling for minimap2 and BWA, so what about the other two. The MAPQ table later shows 42 and 45 and I could not reconcile the two | Say what the ceiling is for Bowtie2 and BBMap |
| Settings, Extra arguments, "prints in the footer" | I do not know what the footer of a wizard is | Name where the footer sits |
| Import section, "works out which reference assembly the file names" | I had to read this twice. I first parsed names as a noun | Reword so names is clearly the verb |
| Reading the results, "Total Mapped is how many alignment records" | Records versus reads again. The Flag Stats paragraph explains it but only later | Flag the difference the first time records appears |
| Reading the results, "which is what a human genome project aims for" | Which number is aimed for, 30x, 44.7x, something else | Give the usual target figure |
| Reading the results, "A region under 10 is too thin" | 10 what. I assume 10x but the unit is dropped | Write 10x |
| Reading the results, "by tallying the flag bits on every record" | Flag bits is jargon I cannot picture | Say each record carries yes or no markers |
| Reading the results, "which is 99.19% of the paired reads" | I could not reproduce this. 90,414 over what denominator | Show the denominator |
| Reading the results, "including coverage breadth" | Breadth versus depth, I mixed them up for a paragraph | Contrast the two in one clause |
| Four mappers table, "Median MAPQ" | The column is not explained before the table, and median is a statistics word I half remember | One line before the table saying what median MAPQ means |
| Four mappers, "because the four programs scale that confidence" | So a lower MAPQ is not worse. That reverses what the setting section implied when it told me to raise the cutoff to 20 | Say a MAPQ cutoff of 20 means different things per mapper |
| What good looks like, "which is expected in shotgun sampling of a pathogen" | Shotgun and pathogen arrive here with no setup in a human chapter | Keep the example human, or gloss shotgun |
| What good looks like, "diagnosed by running classification first" | I do not know what classification is or where to find it | Link the classification chapter |
| What good looks like, "the mark of a corrupted or truncated download" | I would not know how to tell a truncated download from a good one | Say to compare file sizes or just re-download |
| Provenance paragraph, "read the sidecar's version fields" | I do not know where the sidecar file is or how to open it | Give the path and say it opens in any text editor |
| On the command line, "which is the step that makes the track appear" | Two commands where the window needed one click. I could not tell if I had to run both or if the second is optional | Say both are required |
| On the command line, "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish" | This path appeared out of nowhere. Nothing earlier told me to make a project there | Use the project path the reader actually chose |
| On the command line, "`--paired --mapper minimap2 --preset sr`" | Nothing told me I had to say paired. The wizard never asked me | Say the window detects pairing and the command line does not |
| Preset token table, "Assembly or assembled contigs" | Contigs is undefined here | Gloss contig |
| On the command line, "eight characters taken from a fresh UUID" | UUID is undefined | Say a randomly generated identifier |

One thing I learned. A BAM is just one row per read saying where on the reference that read landed, and stacking those rows over a position is what makes a variant call believable rather than a single machine error.

One thing I still could not do. Judge whether my own numbers are good, because the depth targets are given loosely and the MAPQ cutoff advice of 20 does not square with Bowtie2 and BBMap topping out near 42 and 45.

The sentence I liked most. "A single 250-base read from a human sample is a fragment of sequence with no address."
