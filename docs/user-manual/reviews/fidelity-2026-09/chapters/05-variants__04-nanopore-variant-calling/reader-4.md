# Reader report: Nanopore Variant Calling

Reader 4. Undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "A nanopore instrument measures an electrical current" | I do not know what a protein pore is or how DNA "passes through" one. I pictured a hole in a membrane but was not sure. | One clause saying the pore is a protein channel in a membrane and the DNA is pulled through it. |
| What it is / "Run LoFreq or iVar on raw" | LoFreq and iVar are dropped in with no gloss and no link, unlike the other tool names which are all linked. I do not know what either is. | Gloss both as short-read variant callers at first mention. |
| What it is / "dense with false calls at every homopolymer" | I had to read this twice. I could not tell whether "dense with false calls" describes the file or the reads. | Split this into two sentences. |
| What it is / "it takes a path to a directory of model files" | I do not know what a path is. In Geneious I never typed a location, I clicked a file. | Say a path is the text address of a folder on your computer, and say how to get one. |
| What it is / "Each ships in the `variant-calling` plugin pack" | "Ships in" made me think of shipping something. I guessed it means included. | Say "is installed with". |
| Why you would do this / "the smallest human genome there is" | This confused me. I thought a human has one genome. It took the rest of the paragraph to work out you mean the mitochondrial genome counts as its own. | Say mitochondrial genome in this sentence. |
| Why you would do this / "the Ashkenazim son of the Genome" | I do not know what the Genome in a Bottle trio is or why a son of it matters. | One sentence saying it is a reference sample set used for benchmarking. |
| Why you would do this / "sliced down to the mitochondrial genome" | "Sliced" is not a word I have met for data. I guessed it means only those reads were kept. | Say "filtered to only the reads that map to". |
| Why you would do this / "A whole-genome long-read library over-covers" | I do not know what a library is in sequencing. It is not glossed and not linked. | Gloss library at first use. |
| Why you would do this / "the reference itself carries a rare variant" | I had to read this three times. It felt backwards that everyone differs from the reference because the reference is the odd one. | Keep it, but say plainly that the reference person happened to have the uncommon base. |
| Why you would do this / "long reads reach through the repetitive control region" | I do not know what the control region is or why it is repetitive. | Half a sentence on what the control region is. |
| Before you start / "Import the FASTQ as reads with the platform" | I could not do this from the text. No menu is named and no steps are given, unlike everywhere else in the chapter. | Name the menu item and say where the platform choice appears. |
| Before you start / "LGE reads the platform off the imported bundle" | I do not know what a bundle is. It appears here first and is used on every page after. | Gloss bundle at first use. |
| Before you start / "whether a mapping preset is compatible" | Preset is used before it is explained. I only found out in Step 1 that it is a menu of read-type settings. | Move the one-line explanation of preset here. |
| Before you start / "Neither tool needs Docker" | I do not know what Docker is, so I could not tell whether this sentence is good news or a warning. | Drop it, or say it means no extra software to install. |
| Before you start / "neither ONT caller completes a run from" | This stopped me cold. I had already downloaded two files. I could not tell whether to keep going or stop. | Say up front whether the reader should still follow the procedure and what they get out of it. |
| Step 1 / "which passes `-x map-ont` to minimap2" | I do not know what this code means or where it goes. There is no box to type it in. | Say this is what LGE sends the tool for you, with no typing needed. |
| Step 1 / "1,210 alignment records from 950 reads" | I do not know what an alignment record is as distinct from a read, and I could not judge whether 1,210 is good. | Say a record is one placement of one read, and say what number would be worrying. |
| Step 1 / "a read can cross the point where" | I had to read this twice. I do not know what it means for a coordinate system to wrap. | Say the circle is numbered from an arbitrary start, so position 16,569 sits next to position 1. |
| Step 2 / "The fixture reads are shotgun, so skip" | Shotgun is not glossed. I know the word from class but could not define it against amplicon. | Gloss shotgun against amplicon in one clause. |
| Step 2 / "LGE bundles eight schemes, and four" | Four are promised, then the sentence reads as three names plus two more, so I counted twice to check it was four. | List the four names in one flat list. |
| Step 2 / "LGE files a primer-trim record beside" | "Files a record beside" is opaque. I do not know what the record is or where it sits. | Say LGE writes a small note file next to the BAM. |
| Step 3 / "The default is the first analysis-ready BAM" | I do not know what makes a track analysis-ready or how I would tell one from another. | Say what disqualifies a track. |
| Step 3 / "Those two fields are the same stored setting" | I had to read this paragraph twice. It is the most surprising thing in the chapter and it sits mid paragraph. | Give it its own short paragraph or a warning callout. |
| Step 3 / "they are written into the run's provenance" | I do not know what provenance is here. The link assumes I already know it is a record of the run. | Gloss it inline as the run's record. |
| Step 4 / "which are a PromethION run from the" | I have no idea what a PromethION is or what R9.4.1 means, and this is the exact value I am told to type. | Say PromethION is an instrument and R9.4.1 a pore version, and say where a run report lists both. |
| Step 4 / "Ask Medaka itself for the catalogue" | I cannot do this. That is a terminal command and I have never opened a terminal. It is the only route the chapter gives me to a valid model name. | Give a way to find a model name without a terminal, or say plainly this needs the command line. |
| Step 4 / "`samtools fastq -F 2304`, which drops the" | Secondary records are never explained, only supplementary. And 2304 means nothing to me. | Gloss secondary, and drop the number or say what it encodes. |
| Step 4 / "Either way the finished VCF is normalised" | Normalised is not glossed. I do not know what it does to my calls. | One clause on what normalising a VCF changes. |
| Settings / "The default is the first analysis-ready BAM track" | Manifest is a new word here and not glossed. I am warned the default may not be what I expect but not told how to check it. | Gloss manifest, and say the track name shows in the menu so I can confirm. |
| Settings / "The default is 0.05, and on these two" | Two paragraphs earlier I learned this setting does nothing for these callers. I could not tell why the dialog shows it at all. | Say once, near the top of Settings, that both thresholds are inert for the ONT callers. |
| Settings / "On the command line this is `--medaka-model`, the" | I read this as a typo three times before the next clause explained it. | Put the reason first in the sentence. |
| Settings / "going in right after the word `variant` for" | I do not know what command this is inserting into, so "after the word variant" gives me nothing to picture. | Show the shape of the command with a marker where the text lands. |
| Reading the results / "Of the 44 rows, 27 say `PASS`" | I did not know whether LowQual rows should be deleted, ignored, or looked at more closely. | Say what a reader should actually do with a LowQual row. |
| Reading the results / "Of the 44 rows, 18 are single-base" | 18 plus 26 is 44, but I was also told 27 PASS and 17 LowQual, then 14 PASS substitutions. I could not line the three counts up. | State whether each count covers all 44 rows or only the PASS rows. |
| Reading the results / "Six of those, 263, 750, 1438" | I could not check this. I do not know where a list of near-universal positions comes from, so I take it on faith. | Name the resource where these positions are published. |
| Reading the results / "and a Phred quality of 4.38 against" | I do not know what a Phred quality of 4.38 means in plain terms. | Say what 4.38 and 20 mean as chances of a base being wrong. |
| Reading the results / "despite the reads themselves averaging Phred 7.9" | This is the clearest number in the chapter, but it arrives after three other Phred numbers that got no translation. | Give this plain-English translation at the first Phred number instead. |
| What good looks like / "That check requires the model string you" | I do not know what a BAM header is or that it holds text I could search. | Say the header is a block of text at the top of the BAM describing how it was made. |
| What good looks like / "pypy not found, please check you are" | I do not know what pypy or a virtual environment is, and I could not tell whether there is anything I could do. | Say plainly there is nothing the reader can do about it. |
| What good looks like / "Until both are fixed, use Clair3 outside" | I cannot do this. Running Clair3 outside the app means a terminal. The chapter's only working advice is closed to me. | Say what a reader without a terminal should do instead. |
| On the command line / "This section is optional. Everything above happens" | I was relieved, but the two failures above send me here anyway, so it is not optional in practice. | Say in "What good looks like" that the workaround needs this section. |
| On the command line / "bcftools view -H "$BUNDLE"/variants/<track-id>" | Every other line looks copy-and-paste, but this one has a placeholder I would not know how to fill in. | Say where to find the track id. |

The one thing I learned. Nanopore basecallers make errors that cluster at runs of the same base, which is why the caller has to be trained on the same basecaller that produced the reads.

The one thing I still could not do. Find a valid Medaka model name, because the only route the chapter offers is a terminal command and I have never opened a terminal.

The sentence I liked most. "Depth is what rescues noisy reads."
