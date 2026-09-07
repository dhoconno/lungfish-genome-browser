# Reader report: Reading the Variants Table

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The table is not a window" | "It lives in the table drawer, the panel that slides up" — I did not know a drawer was a UI thing. I first pictured a physical drawer. | Say once that a drawer is a panel that slides out of an edge. |
| What it is, "The drawer starts 250 points tall" | "Points" is not a unit I know. Is it pixels? Millimeters? | Give the unit a gloss the first time. |
| What it is, "A two-segment control switches between" | "Two-segment control" was new. I read the sentence three times before I guessed it is a button split in two halves. | Name it in plain words, like a small switch with two labelled halves. |
| What it is, "A second two-segment control decides" | Two controls with the same shape described back to back. I could not keep straight which one was scope and which one was rows. | Give each one its on-screen label in bold in the same sentence. |
| What it is, "So what should you do with this?" | A question asked to me in the middle of an explanation made me stop and check whether I had missed an instruction. | Drop the rhetorical question. |
| Why you would do this, "The HG002 chromosome 20 slice" | I did not know HG002 is the name of a cell line until the next clause. Also "slice" was ambiguous, a physical slice or a region? | Say region of the genome, not slice. |
| Why you would do this, "holds Illumina reads from a well-studied" | "Illumina" is used with no gloss anywhere in this chapter. I know it from lecture but a classmate would not. | One clause saying it is a sequencing instrument brand. |
| Why you would do this, "Those two runs produced 1,056 rows" | I could not tell whether a row equals one variant or one variant per sample. It matters later at Calls versus Genotypes. | State that in the Calls view one row is one variant. |
| Before you start, "which is a fixture, the sample data" | The word fixture is defined here but used as if I already agreed to it. I had to re-read to attach the definition. | Put the definition before the word. |
| Before you start, "Follow Calling Variants first" | I could not tell whether I must finish the whole other chapter or only part of it. It sounds long. | Say the whole chapter is needed and roughly how long it takes. |
| Before you start, "bcftools arrives in the Required Setup pack" | I do not know what a pack is or whether I already have it. Nothing tells me how to check. | One line saying it installs automatically, or where to look. |
| Step 1, "Check the Operations panel with Operations" | I do not know what the Operations panel looks like or what I am checking for beyond one message. | A sentence on what a running row looks like versus a finished one. |
| Step 2, "Seven of them are the VCF's own standard" | The count did not add up for me. The table below lists six rows, then the prose says "the remaining six", and seven standard columns are claimed. I counted three times and gave up. | Make the table list all twelve so I do not have to count. |
| Step 2, "Ref and Alt, The reference and alternate" | Two columns share one table row, so my count of twelve broke here. | Give Ref and Alt their own rows. |
| Step 2, "which is the caller's own verdict on the row" | I did not understand what a verdict means for a machine. Pass or fail? Something else? | Say it is the caller's own pass or fail label. |
| Step 2, "LGE's own iVar output writes a bare" | iVar is never explained and is not part of this chapter's workflow. I stopped to wonder whether I needed it. | Say iVar is another caller you may meet later. |
| Step 2, "Beyond the twelve, the table adds a column" | I did not know INFO keys were per-file, so I expected the same columns for both tracks and was confused when told they differ. | Say plainly that the two tracks give different extra columns. |
| Step 2, "the bcftools track declares sixteen INFO keys" | DP4, MQ, AC, and SB are listed and none are explained. I could not judge whether I should care. | Gloss the ones used later, at least DP and AF. |
| Step 3, "the dense INFO string the table squeezes" | I have never seen a raw INFO string, so "dense" did not tell me anything. | Show one short example string. |
| Step 3, "the table is a standard macOS table, so VoiceOver" | I did not know what VoiceOver is and thought it was a feature of the app. | Say it is the built-in macOS screen reader. |
| Step 4, "Moderate+, and ClinVar Path." | "Moderate+" and "ClinVar Path." are abbreviations I could not expand. Path is pathogenic? Or pathway? | Expand both once. |
| Step 4, "You will not see all fourteen" | I counted the chips listed and reached fourteen only after recounting. The sentence assumes I had counted. | State the count in the previous paragraph. |
| Step 4, "an annotation program such as SnpEff or VEP" | Two program names, no gloss, and I cannot tell whether I need to install them. | Say they are separate annotation tools not required here. |
| Step 4, "The three frequency chips appear only for a haploid" | I know haploid from genetics but the logic surprised me. Why would frequency chips be for haploid organisms only? It felt backwards. | One clause saying why. |
| Step 4, "Three sets behave like radio buttons inside themselves" | "Radio buttons" and "inside themselves" together were hard. I re-read twice. | Say only one chip in each of these three groups can be on. |
| Step 4, "Read a bare `.` as unjudged rather than as failed" | This is the key lesson but it arrives at the end of a long paragraph. I nearly missed it. | Put it as its own short sentence up front. |
| Step 5, "They combine with Match All, meaning a row" | I wanted OR and could not tell whether I was doing something wrong or whether it is impossible. The answer comes only in Settings much later. | Say here that OR does not exist. |
| Step 5, "Seven categories organise the fields" | Seven categories with many fields each, all in one dense paragraph. I could not hold it in memory and there is no table. | Break the categories into a table. |
| Step 5, "and the three population-database frequency keys" | Unnamed keys. I do not know what a population database is in this context. | Name them, or say they are absent on this fixture. |
| Step 5, "then 1-250000, which keeps the first half" | The reference is called chr20_10.0-10.5Mb but the region is written 1-250000. I could not tell whether coordinates restart at 1 or are genomic. | Say the coordinates are relative to the slice. |
| Step 5, "leaves 512 rows out of the 574 in that window" | I could not reproduce 574 because I did not know the scope control had to be set a certain way. That instruction is elsewhere. | Repeat the scope setting inside the worked example. |
| Step 5, "zoom the viewport in below 10 Mb" | I do not know how to zoom the viewport. It has not been shown in this chapter. | Point to the chapter that teaches zooming. |
| Step 6, "The tick colors on the genome track above" | I have not seen the genome track described in this chapter, so a warning about its colors landed on nothing. | One clause saying what the genome track is. |
| Step 6, "Coordinate 250527 shows the shape" | I could not find this row. Nothing tells me to search or sort to reach it, and the chapter says there is no free-text box. | Say how to navigate to a coordinate. |
| Step 6, "reports AF=0.571429 instead" | I could compute the fraction but I did not know whether AF here counts reads or chromosomes. | Say AF here is the fraction of reads. |
| Settings, "note that at narrow window widths the second" | I did not understand what GT stands for until step 6 mentions genotype. | Expand GT at first use. |
| Settings, "Auto / Haploid / Diploid." | This control is never mentioned in the Procedure, so meeting it in Settings made me think I had skipped a step. | Mention it once in step 4 with the frequency chips. |
| Reading the results, "It holds 1,918 rows" | 1,056 plus 862 is 1,918, but earlier the chapter said the callers share 852 positions. I could not see how a shared position becomes two rows. | Say each track contributes its own row even at a shared coordinate. |
| Reading the results, "The two callers put their scores" | If the scales cannot be compared, I did not understand why the same Qual >= 30 chip applies to both. | Say the chip uses one threshold on both anyway. |
| Reading the results, "623 rows reading 0/1 and 415" | 623 plus 415 is 1,038, not 1,056. Eighteen rows are unaccounted for and nothing says why. | Say what the remaining rows carry. |
| What good looks like, "roughly one difference every 470 bases" | I could not follow the arithmetic against "one base in a thousand" in the next clause. One in 470 is denser than one in 1,000, but the text says only "slightly". | Say roughly twice as dense and why. |
| On the command line, "applies a smart-filter token" | "Token" for a filter expression was strange to me. I expected "expression" or "query". | Use one word for this thing throughout. |
| On the command line, "The --filter flag accepts per-sample clauses only" | This contradicts what Settings told me, that the query text the sheet writes is what --filter takes. I could not tell which is true. | Resolve the contradiction in one sentence. |
| On the command line, "BUNDLE=MyProject.lungfish/Reference Sequences" | I have never opened a terminal. I do not know where to type this or how to find my own bundle path. | Say where the terminal is and how to get the path. |
| On the command line, "bcftools view -H hom-alt.vcf" | The pipe symbol and wc -l mean nothing to me. | One clause saying it counts the lines. |
| On the command line, "Calls where over half the reads carry" | 623 het rows near 0.5 plus 415 hom rows above it made me expect about 1,038, not 770. | Say why the count differs. |

Learned: a bare dot in the Filter column means the caller never judged the row, which is not the same as the row failing.

Could not do: reach coordinate 250527 in the table, because the chapter never says how to jump to a position and tells me there is no free-text box.

Liked most: "Read a bare `.` as unjudged rather than as failed, look at the column before you filter on it, and use **Clear** to bring the rows back."
