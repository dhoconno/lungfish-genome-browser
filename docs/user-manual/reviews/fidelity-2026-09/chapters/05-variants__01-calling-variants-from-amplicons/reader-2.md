# Reader report: Calling Variants

Persona: senior undergraduate, two years of bench pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "A variant caller reads a BAM" | "Walks the reference one position at a time" is a metaphor I had to read twice before I pictured what the program is actually doing. | Say it scans every base of the reference in order. |
| What it is / "looks at the pileup of read" | I do not know what a pileup looks like. The glossary link exists but I cannot picture the stack while reading. | A one-line gloss in the sentence, like the stack of reads covering one position. |
| What it is / "you pick a caller from" | "From a list of seven" arrives before I am told any of the seven names, so I read the sentence twice waiting for the list. | Give the count after the callers are introduced. |
| What it is / "and LGE stages the inputs" | I do not know what normalising a variant means or why the output needs it. | One clause saying what normalisation fixes. |
| What it is / "bcftools builds a genotype model" | I do not know what a genotype model is, and "which genotype best explains the pileup" reads as circular to me. | Gloss it as a short list of possible allele combinations it scores. |
| What it is / "which suits a sample with" | "A fixed small number of genome copies" left me unsure whether this just means diploid. | Use the word diploid and gloss it. |
| What it is / "LoFreq builds an error model" | I do not know what an error model is or how base qualities become one. | A sentence saying it estimates how often the machine miscalls a base. |
| What it is / "which suits a sample whose" | "True allele fractions can be anything at all" gave me no example to attach the rule to. | Name one sample type, such as a mixed viral population. |
| What it is / "So what should you do" | The question is asked of me and I did not realise it was rhetorical until the next clause. | Drop the question and state the rule directly. |
| Why you would do this / "The HG002 chromosome 20 slice" | I did not know HG002 was a cell line until the next clause, and the name looks like a filename. | Introduce it as a cell line before using the identifier. |
| Why you would do this / "mapped to a 500" | kb is never spelled out. | Spell out kilobases at first use. |
| Why you would do this / "a set of 961" | I have never heard of the Genome in a Bottle consortium and could not judge how much to trust it. | One clause saying who they are. |
| Before you start / "Import the FASTA as a" | I cannot perform this step from this text alone. It points at another chapter but gives me no menu item here. | Name the menu command for the import even if the detail lives elsewhere. |
| Before you start / "bcftools needs no extra installation" | I do not know what a pack is at this point, and the glossary link sits on the next phrase instead. | Gloss plugin pack where the word first appears. |
| Before you start / "Open Tools > Plugin Manager" | I could not tell whether installing the pack downloads something large or needs the internet, so I did not know whether to start it. | Say what the install needs and roughly how long it takes. |
| Step 2 / "The right side is one" | I could not tell whether the four sections are all visible at once or whether I have to scroll to find them. | Say that the later sections need scrolling. |
| Step 2 / "One thing about the Thresholds" | This is the most important sentence in the chapter and I read it three times, because the paragraph explains the exception before stating it plainly. | Lead the paragraph with the plain rule. |
| Step 2 / "For bcftools, LoFreq, Medaka, and" | Provenance is used as if familiar and I do not know what it means here. | Gloss it inline as the saved record of how the run was done. |
| Step 3 / "The Operations panel opens and" | "Piped into" stopped me. I have never used a terminal and do not know what piping is. | Say the output of one is fed straight into the other. |
| Step 3 / "rewrites the VCF header against" | I could not tell whether this is a step that might fail or something automatic I can ignore. | Say it is automatic and needs nothing from me. |
| Step 3 / "and loads the rows into" | SQLite is not glossed and I do not know what it is. | Gloss it as a small local database file. |
| Step 5 / "Filtering happens through the Presets" | I could not perform this. I do not know what a filter chip is or what one looks like. | Gloss chip once, or leave the sentence to the next chapter. |
| Step 6 / "iVar assumes its input is" | Shotgun is used without gloss and I only half know it from lecture. | Gloss shotgun against amplicon in one clause. |
| Settings / "Chooses which alignment the caller" | I do not know what makes a track analysis-ready or how I would tell. | Say what disqualifies a track. |
| Settings / "Minimum Allele Frequency. Sets the" | The entry gives the default and the fixture behaviour but never tells me how to pick a value for my own data. | One sentence on choosing when the sample is not the fixture. |
| Settings / "which is why a bcftools" | I could not tell where I would actually see the recorded value "caller-default". | Name where provenance is displayed. |
| Settings / "The default is 10, which" | I do not know how to check what depth my own alignment has, so I cannot judge whether 10 is safe for me. | Point at where coverage depth is shown. |
| Settings / "and never on an untrimmed" | I could not picture why primer bases look like variants, so the warning did not land. | One clause on primers carrying the reference base whatever the sample holds. |
| Settings / "Use it to set ploidy" | The example assumes I know why a haploid genome breaks the default. | Say the default assumes two copies. |
| Settings / "on a haploid genome with" | I would have to type these flags myself and nothing tells me the exact text to put in the field. | Show the field contents as they should be typed. |
| Reading the results / "Running both callers on the" | I could not tell whether my own run should match 1,056 and 862 exactly or only roughly. | Say whether the numbers are reproducible on my machine. |
| Reading the results / "Those two runs were made" | Being told they came from the command-line tool made me doubt the window gives the same counts. | State that the window run gives the same numbers. |
| Reading the results / "Every one of the 1,056" | I read this twice because "not one says PASS" sounded at first like something had gone wrong. | Say up front that this is expected. |
| Reading the results / "The bcftools VCF carries ten" | I could not remember the eight standard columns and they are not repeated here. | Name them or point at the exact section of the VCF chapter. |
| Reading the results / "plus a FORMAT column reading" | PL and AD are never explained anywhere in this chapter. | Gloss the three keys. |
| Reading the results / "At fixture coordinate 2078 both" | I did not know fixture coordinates differ from chromosome 20 coordinates until I saw the contig name in the code block. | Say the fixture is numbered from its own start. |
| Reading the results / code block | The two lines are wider than my screen and I could not line up which field is which without counting tabs. | Label the columns above the block. |
| Reading the results / "The quality scores are on" | I do not know what either scale is, so I cannot use the quality column at all. | One clause on what each caller's QUAL means. |
| Reading the results / "The bcftools track from this" | I could not judge whether 46 KB and 2.2 MB matter to me or are trivia. | Say whether disk use is ever a concern. |
| What good looks like / "The fixture covers 500 kb" | I could not reproduce "one difference every 470 bases" quickly and did not know where 470 came from. | Show the division. |
| What good looks like / "and it is a little" | I do not know why gene-rich regions carry more differences. I thought genes were more conserved. | One clause explaining the direction. |
| What good looks like / "Comparing positions only, 954 of" | The chapter said 1,056 rows earlier and now says 1,053 positions, and I could not tell whether one is an error. | Say that some positions carry more than one row. |
| What good looks like / "a real accuracy assessment needs" | I do not know how I would run something LGE does not ship, having never opened a terminal. | Say plainly that this is out of reach without a terminal. |
| On the command line / "The script below imports the" | Adopt is a term I have not met, and I could not tell whether the window does this step for me. | Say the window does it automatically on import. |
| On the command line / "bcftools view -H "$BUNDLE"/variants/<track-id>.vcf.gz" | I do not know where a track id comes from or what one looks like. | Say where the id is displayed. |

One thing I learned. Two callers run on the very same alignment give different numbers of rows on purpose, because they are answering different questions, and a FILTER column of `.` means unjudged rather than failed.

One thing I still could not do. Choose a Minimum Allele Frequency or Minimum Depth for my own sequencing data, since every number given is either a fixture number or a default and nothing tells me how to check my own coverage.

The sentence I liked most. "Read `.` as unjudged rather than as failed, and check what the column actually holds before filtering on it."
