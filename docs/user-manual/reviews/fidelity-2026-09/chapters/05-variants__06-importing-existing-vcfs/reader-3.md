# Reader report: Importing Existing VCFs

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "The whole thing turns on one question" | "Turns on" is an idiom I do not know. I thought something was being switched on. | Say "depends on one question". |
| What it is / "A VCF's coordinates are meaningless without one" | I did not know "coordinates" here means the position numbers in the file. | Gloss coordinates as the position numbers in each row. |
| What it is / "There is no inference readout, no dropdown" | "Inference readout" is two hard words together and I could not picture the thing that is missing. | Say the app never shows you a guess about which reference it matched. |
| What it is / "then quietly tries to fetch a matching" | "Quietly" made me unsure whether this is a problem or normal behaviour. | Say the download starts without asking you. |
| What it is / "That is the entire decision tree" | I do not know "decision tree" as an English phrase. | Say "those are all the possible outcomes". |
| What it is / "So what should you do with this?" | I read this twice. The question sounded like it was about the VCF file, not about my behaviour. | Drop the question and give the advice directly. |
| Why you would do this / "treated as an answer key" | "Answer key" is a school word I had to guess from context. | Gloss it once as the correct answers you compare against. |
| Why you would do this / "produced 1,056 and 862 rows" | Two numbers with no unit and I could not tell which belongs to which caller. | Attach each number to its caller name. |
| Why you would do this / "bcftools reports more than is really there" | I did not know what bcftools and LoFreq are. They appear before any explanation. | Gloss both as variant callers at first mention. |
| Before you start / "which is a fixture, the sample data set" | The sentence defines fixture inside a relative clause and I lost the main sentence. | Define fixture in its own short sentence. |
| Before you start / "Download the file HG002.chr20.10.0-10.5Mb" | The file name has many dots and I could not tell where the name ends. | Show the two file names on separate lines. |
| Before you start / "the Download raw file button" | I could not find this button from the text alone. I do not know what "raw" means for a file. | Say where on the GitHub page the button sits. |
| Before you start / "the Required Setup pack" | I do not know what a pack is or where I get one. | Point to the chapter that installs packs. |
| Procedure / "The fifth covers what happens when" | The step numbering in prose confused me because step 5 is described as an exception, so I did not know whether to do it. | Say step 5 is only for readers with no bundle. |
| Step 1 / "keyed against the same 500 kb slice" | "Keyed against" is unfamiliar to me. | Say the positions were measured along that same slice. |
| Step 1 / "so the check is yours to make" | I did not understand what exactly I must check or how to compare a viewport name to a VCF column when I cannot open the VCF. | Say how to see the first column of the VCF. |
| Step 2 / "Cmd-Shift-I" | I could not tell if Shift is pressed together or after. | Spell out that all keys are held at once. |
| Step 2 / "so a .bcf cannot be chosen here" | I do not know what a BCF is or how to convert one. | Gloss BCF as the binary form of a VCF. |
| Step 3 / "where Auto names the import profile" | I did not understand that Auto is a setting name until I reached the Settings section much later. | Say Auto is a setting explained below. |
| Step 3 / "writes the rows into a SQLite database" | I do not know SQLite. | Gloss it as a small local database file. |
| Step 3 / "Only one operation can hold a bundle at a time" | "Hold a bundle" sounded physical and I could not tell what I should do if this happens. | Say the second import waits until the first finishes. |
| Step 5 / "records a Default Ploidy value" | I know ploidy from genetics but not what auto or haploid do to my import. | Say what changes for me when it is haploid. |
| Step 5 / "the existing one is replaced, so type carefully" | This frightened me and I could not tell whether the old data is deleted forever. | Say whether the replaced bundle can be recovered. |
| Settings / "Chooses how much memory the import may use" | I do not know how to tell if my machine has "plenty of memory". | Give a rough number of gigabytes. |
| Settings / "This setting has no command-line flag" | I never use the command line, so I did not know if this sentence concerns me. | Mark command-line notes so I can skip them. |
| Reading the results / "with the scope control set to Genome" | I never saw a scope control in the earlier steps and could not find it. | Say where the scope control sits. |
| Reading the results / "about one every 520 bases" | I could not reproduce this number. I did not see that 500,001 divided by 961 gives it. | Show the division. |
| Reading the results / "Every one of the 1,056 bcftools rows reads a bare ." | A single dot as a value is hard to see and I first thought it was the end of the sentence. | Say the value is a period meaning no filter applied. |
| Reading the results / "Clicking the PASS preset chip" | I do not know what a preset chip is or where it is. | Gloss chip as a clickable filter button. |
| Reading the results / "reading a benchmark row's 50 against a bcftools row's 225" | I did not understand what a Quality of 225 means on its own scale either. | Say briefly what bcftools quality measures. |
| Reading the results / "sixteen more rows carrying multi-allelic calls such as 2/1" | I do not know what 2/1 means. The chapter explains 0/1 and 1/1 but not this. | Gloss 2 as a second alternate allele. |
| Reading the results / "with LoFreq's allele frequency of 0.571" | I could not connect 0.571 to the genotype 0/1. | Say roughly half the reads carry the change. |
| What good looks like / "far fewer for two clonal isolates" | "Clonal isolates" is microbiology vocabulary I have not learned. | Gloss or use a human comparison. |
| What good looks like / "a filter that empties the view has three possible explanations" | The three explanations are never listed, so I could not use this check. | List the three. |
| On the command line / "Types : SNP: 809, DEL: 74, INS: 64" | The abbreviations SNP, DEL, INS are never expanded in this chapter. | Expand them once. |
| On the command line / "the same per-sample filter grammar the Search Builder" | "Filter grammar" and "Search Builder" are both new to me here. | Point to the chapter that teaches the Search Builder. |
| On the command line / "both cap the export at 5,000 records" | "Cap" as a verb was unclear and "The cap is silent" I read twice. | Say the export stops at 5,000 rows with no warning. |

One thing I learned. The reference bundle that is open on screen decides where my imported variants go, and the app never tells me which reference it matched.

One thing I still could not do. Confirm before importing that my VCF's first column matches the bundle, because the chapter tells me to compare them but never shows me how to see inside the VCF.

The sentence I liked most. "A caller missing a class of variant it was never looking for is a configuration fact, not a failure."
