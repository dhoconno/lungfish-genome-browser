# Reader 1 report, Calling Variants

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "A variant caller reads a BAM" | I do not know what a BAM file is beyond the link. I met the word before any hint of what it holds. | One clause saying a BAM is the file of reads already lined up against the reference. |
| What it is, "looks at the pileup of read" | Pileup is linked but never described in words here. I pictured a heap, not a column. | Say a pileup is the stack of read bases sitting over one reference position. |
| What it is, "strongly enough to clear its" | I do not know what the threshold is on, or who sets it. | Name what the threshold measures, such as how many reads must disagree. |
| What it is, "you pick a caller from" | I had no way to guess which of seven I would want, and the paragraph that helps comes after. | Say up front that the next paragraph explains how to choose. |
| What it is, "normalises and sorts the output" | I do not know what normalising a variant means or why it needs doing. | One clause on what normalising fixes. |
| What it is, "bcftools builds a genotype model and" | Genotype model was the hardest phrase in the chapter. I know genotype from class as the pair of alleles, but not what a model of it is. | Say it tries each possible pair of alleles and picks the one the reads fit best. |
| What it is, "a fixed small number of" | I had to read this twice to work out it means diploid, two copies. | Just say two copies for a human, and name the word diploid. |
| What it is, "whose true allele fractions can" | I could not think of an example of such a sample, so the contrast did not land. | Name one such sample in the same sentence. |
| What it is, "sit behind experimental plugin packs" | I do not know what experimental means for me. Can I use them or not? | Say whether experimental packs are installable by a normal user. |
| Why you would do this, "mapped to a 500 kb stretch" | I know kb but had to stop and convert to half a million bases, and the next paragraph says half-megabase, a third unit. | Pick one unit and keep it. |
| Why you would do this, "from a well-characterised human cell line" | I did not know a cell line could be a genome standard, or whose genome it is. | One clause saying HG002 is DNA from one consenting donor used worldwide as a reference sample. |
| Why you would do this, "the Genome in a Bottle consortium" | Never heard of it, and the name gave me no idea what kind of body it is. | Say it is a public standards project. |
| Why you would do this, "roughly one difference from the reference" | I could not tell whether that is a lot. The number arrives without a comparison. | Compare it to something, such as how many total differences that means per genome. |
| Before you start, "choose File > New Project" | The Cmd-N shortcut implies Mac, but the manual never says the app is Mac only. | State the platform once. |
| Before you start, "which is a fixture, the sample" | The gloss helped, but I still could not tell whether the fixture is something I download or something already inside the app. | Say plainly that you download it yourself. |
| Before you start, "Import the FASTA as a reference" | This is the biggest step in the chapter and it is one sentence pointing elsewhere. I could not do it from this text. | Say roughly how long the mapping chapter takes, so I know to go do it first. |
| Before you start, "carrying an alignment track named minimap2" | I could not check whether I had this. I do not know where in the window a track name appears. | Say where to look to confirm the track exists. |
| Before you start, "A loose BAM sitting in a" | I did not know what loose meant here, and I do not know how a BAM stops being loose. | Say a BAM must be imported into a bundle first, and where that happens. |
| Before you start, "It arrives in the Required" | I do not know whether this pack installs itself or whether I must do something. | Say it installs on first launch, if that is true. |
| Before you start, "greyed out and labelled with the" | I could not tell whether greyed out means I can click to install from there. | Say whether the greyed entry is clickable. |
| Step 1, "Select the reference bundle in the" | I do not know what a bundle looks like in the sidebar versus a track or a file. | Say what level or icon in the list is the bundle. |
| Step 2, "and LoFreq is selected when the" | This contradicted my expectation after Step 3 tells me to click bcftools. I reread to check I had not missed a setting. | No fix needed, this was just a stumble. |
| Step 2, "a footer bar underneath it carries" | I do not know what a readiness message is until Step 6 explains it for iVar. | Say in one clause that the readiness line tells you why Run is disabled. |
| Step 2, "recorded in the run's provenance and" | Provenance is linked but not glossed here, and this is its first use. I guessed it meant history and hoped that was right. | Gloss provenance as the record of exactly how the run was done. |
| Step 2, "the Extra arguments field is the" | I do not know what to type in it. I was told to use a field I could not use. | Point forward to the Extra arguments entry in Settings. |
| Step 3, "call as an orthogonal cross-check on" | Orthogonal stopped me completely. I know it as perpendicular from math class. | Say independent. |
| Step 3, "indexes the reference with samtools faidx" | A wall of commands I cannot evaluate. I do not know whether I am supposed to understand these or just watch them scroll. | Say the reader does not need to follow these, they are listed so the panel makes sense. |
| Step 3, "loads the rows into a SQLite" | I do not know what SQLite is, and it is not in the chapter's glossary list. | Say it is a small database file the app uses to search fast. |
| Step 4, "Open the dialog again and click" | I had to read this twice. It tells me to click something and then says the click is unnecessary. | No fix needed, but the aside slowed me. |
| Step 5, "The table drawer at the bottom" | Two words I do not know, drawer and viewport, in one phrase, and neither is glossed. | Say the panel at the bottom of the main window. |
| Step 5, "and through the Search Builder sheet" | I do not know what a sheet is, or what the Search Builder does. | One clause on what the Search Builder is for. |
| Step 6, "and the HG002 reads are shotgun" | Shotgun is not glossed anywhere in this chapter and it carries the whole reason not to run iVar. | Say shotgun means reads from randomly broken DNA rather than targeted PCR products. |
| Step 6, "where every primer position would then" | I could not work out why primer bases look like variants. I know primers are synthetic, but the link to false calls was left for me to make. | Say the primer sequence comes from the synthesis, not the sample, so it hides the real base. |
| Step 6, "LGE exports them to a GFF3" | GFF3 appears once with no gloss, and I do not know whether I must supply anything. | Say whether the reader must add annotations or whether this only happens if they exist. |
| Step 6, "two neighbouring changes inside one codon" | I know codons from class but not why merging two changes into one row matters. | Say the two changes together give one amino acid result. |
| Settings, "The default is the first analysis-ready" | I do not know what makes a track analysis-ready or how I would tell. | Say what disqualifies a track. |
| Settings, "records the value caller-default instead" | I could not tell whether that is a problem to fix or just a note. | Say it is the correct record, not an error. |
| Settings, "The default is 10, which is" | I do not know what depth I actually have in this fixture, so I could not judge whether 10 is near my numbers or far below. | Give the fixture's typical depth once. |
| Settings, "set a real floor through Extra" | I do not know either tool's flag, and the chapter only gives LoFreq's later. | Name the bcftools flag too. |
| Settings, "because amplicon libraries are lopsided by" | I did not follow why an amplicon library is lopsided by strand. | One clause on why amplicon reads land mostly one way. |
| Settings, "to set ploidy on a haploid" | This is the first time I am told the tool assumes a ploidy at all. I did not know bcftools had defaulted to two. | Say bcftools assumes two copies unless told otherwise. |
| Settings, "makes LGE run an extra lofreq" | I do not know what indelqual does, and it is offered as a casual aside. | One clause saying it adds quality scores for insertions and deletions. |
| Reading the results, "produces 1,056 rows from bcftools and" | I could not tell whether I should expect these exact numbers on my own machine. | Say whether these numbers are reproducible run to run. |
| Reading the results, "873 are single-base substitutions and 183" | 873 plus 183 is 1,056, which I checked, but nothing told me the two categories are exhaustive. | No fix needed, this was me being suspicious. |
| Reading the results, "has FILTER set to a bare" | I did not know a period was a value. I first read it as the end of the sentence. | Say the column holds a single period meaning no value. |
| Reading the results, "plus a FORMAT column reading GT:PL:AD" | I do not know what PL and AD are, and they are not glossed. | Gloss the three tags in one clause. |
| Reading the results, "Of its rows, 623 carry" | 623 plus 415 is 1,038, not 1,056. I could not tell what the other 18 rows are. | Say what the remaining rows carry. |
| Reading the results, the two-line VCF code block | The lines are wide and the fields are unlabelled, so I could not tell which chunk was which column without counting tabs. | Label the columns above the block. |
| Reading the results, "The quality scores are on different" | I was told these cannot be compared but not what either one means on its own. | Say what a quality score in a VCF is measuring. |
| Reading the results, "DP4=0,0,24,27" inside the code block | Four numbers with no explanation, and they differ between the two lines even though the depth is the same 62. | Say what the four DP4 numbers count, or drop them from the example. |
| Reading the results, "writes 46 KB, 368 bytes, and" | I had to map three sizes back onto three file types listed in the sentence before. | Put the size next to each file type. |
| What good looks like, "which is roughly one difference every" | I could not reproduce this. 500,000 over 1,056 is about 473, so I think it is right, but the arithmetic was left to me. | Show the division, or round the same way as the earlier one-in-a-thousand figure. |
| What good looks like, "denser than average because this slice" | I learned in class that gene-rich regions are usually more conserved, so I expected fewer differences, not more. | Say why gene-rich means denser here. |
| What good looks like, "954 of the 1,053 distinct" | The chapter said 1,056 rows a page earlier and now says 1,053 positions with no explanation of the gap. | Say that a few positions carry more than one row. |
| What good looks like, "a benchmarking program such as hap.py" | I do not know what I am supposed to do with this. Install it? Give up? | Say whether accuracy assessment is out of scope for this manual. |
| What good looks like, "the tool versions, and checksums of" | I do not know what a checksum is or what it proves. | Say it is a fingerprint showing the file did not change. |
| On the command line, "This section is optional. Everything above" | Relief, but the section then holds the only way I saw to count rows in a track. | No fix needed, but the row-count command has no window equivalent given. |
| On the command line, "--mapping-result mapping/" | I have no idea where a folder called mapping comes from. It was never produced in this chapter. | Say the mapping chapter creates it. |
| On the command line, "bcftools view -H $BUNDLE/variants/<track-id>" | Angle brackets mean fill this in, but I do not know where to find a track id in the window. | Say where a track id is displayed. |

The one thing I learned: two callers can look at the same reads at the same position and agree on the biology while sharing almost none of the same numbers, so the FILTER column has to be read rather than trusted.

The one thing I still could not do: get an alignment track into the project at all, because the whole mapping step is one sentence pointing at another chapter, and I could not tell from this text what I would see when it worked.

The sentence I liked most: "Read `.` as unjudged rather than as failed, and check what the column actually holds before filtering on it."
