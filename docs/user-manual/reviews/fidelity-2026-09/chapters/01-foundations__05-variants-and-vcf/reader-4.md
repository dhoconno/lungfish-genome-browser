# Reader report: Variants and VCF Files

Persona: undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A VCF file, short for Variant" | "tab-separated text file" arrives before I know whether I would ever open one myself. In Geneious a variant list was just a table inside the program. | Say in one clause that you normally never open the text by hand. |
| What it is, "walks the reference position by position" | "pileup" is linked but not glossed in place, so I had to guess it means the stack of reads at one spot. | Gloss pileup here the way REF and ALT get glossed later. |
| What it is, "The meaning of a field name" | I do not know what "the format specification" is or where it lives. | Name it once as the published VCF standard document. |
| Why you would do this, "from consensus building to lineage" | "consensus building" and "lineage assignment" are both new to me and neither is explained or linked. | Drop or gloss these two examples. |
| Why you would do this, "a human sample the Genome in" | I could not tell what "characterised in detail" got them, or whether HG002 is a person, a cell line, or a file. | One clause saying HG002 is a human reference sample whose true variants are known. |
| Before you start, "which is what the demo project's" | I do not know what a "bundle" is at this point, and the chapter never defines it. | Gloss bundle at first use here. |
| Before you start, "Calling variants needs the variant-calling plugin" | I could not tell whether I need to do anything now. The paragraph tells me a pack exists but not how to know if I have it. | Say plainly that nothing in this chapter requires it. |
| What a VCF file looks like, "The compression is bgzip, a" | I had to read this twice. I do not know what "jump into the middle of the file" buys me or why plain gzip could not. | One clause on why random access matters for a big file. |
| What a VCF file looks like, "and a CSI index serves" | "where a reference sequence is too long for `.tbi` to address" means nothing to me. How long is too long? | Give the rough length, or say this only happens for very large chromosomes. |
| What a VCF file looks like, "An optional SQLite sidecar sits" | I do not know what SQLite is or what a "sidecar" is, and I cannot tell whether it is something I create. | Say it is a helper file LGE writes for itself. |
| Eight standard columns, "QUAL is a Phred-scaled confidence" | The 20 and 30 examples made sense, but I could not judge the 222.235 in the example row until much later. | Put the "far above doubt" judgement here rather than only in the walkthrough. |
| Eight standard columns, "For an insertion or deletion, POS" | The anchor-base rule took three readings. I still cannot tell which base of `CTTTTT` is the anchor. | Mark the anchor base visually in the example. |
| Eight standard columns, iVar row "GT:DP:REF_DP:REF_RV:REF_QUAL:ALT_DP" | Nine keys appear with no explanation of any of them, and `REF_RV` is not defined anywhere in the chapter. | Say the keys are explained in the viral chapters, or cut the row. |
| Eight standard columns, "iVar adds two more keys" | "codon-merging step" arrives with no definition of codon merging. | Gloss codon merging in half a sentence. |
| Eight standard columns, "LGE's iVar lane writes the bare" | "lane" is a new word for a thing I do not recognise, and it appears nowhere else. | Use the same word the rest of the chapter uses. |
| Walking through one row, "DP=63;VDB=0.177212;SGB=-0.693127;RPBZ=1.00958" | Nine INFO keys in the pasted row are never explained and I could not tell whether I should care about them. | One line saying the unexplained keys are caller internals you can ignore. |
| Walking through one row, "PL holds Phred-scaled likelihoods for" | I could not work out why `255,0,255` marks `0/1`. Which position in the list is which genotype? | Say the three values run homozygous reference, heterozygous, homozygous alternate. |
| Walking through one row, "A QUAL of 1093 on" | If QUAL is Phred-scaled it ought to be comparable. The chapter says both that it is Phred and that it is not comparable, and I could not resolve that. | One clause explaining why the two scales differ in practice. |
| Walking through one row, "a strand-bias score of SB=0" | I do not know the range of SB, so I cannot judge any value other than zero. | Say what a high SB looks like. |
| FILTER section, "min_snvqual_73 The substitution's QUAL fell" | I do not know how the 73 was computed, or whether a different run puts a different number in the flag name. | Say the number changes from run to run. |
| FILTER section, "after a correction for testing many" | I have not met multiple-testing correction and this phrasing did not teach it to me. | Name it and say in one clause why testing many positions needs it. |
| FILTER section, "ft marks a row that" | I know the phrase Fisher exact test, but not "the run's mean error rate", and I could not tell which direction of p-value counts as failing. | State which outcome fails. |
| FILTER section, "Amplicon protocols pile strand-imbalanced reads near" | This is the first use of "amplicon" and "primer" in the chapter and neither is glossed. | Gloss amplicon at first use. |
| Where a VCF comes from, "and the row count grows" | I could not judge "an order of magnitude" without a number. Ten times more rows, or a hundred? | Give the approximate factor plainly. |
| Where a VCF comes from, "and 954 of bcftools' 1,053" | The jump from 1,056 rows to 1,053 distinct positions is unexplained, and I read the sentence three times counting numbers. | Say why some rows share a position. |
| Where a VCF comes from, "needs a benchmarking tool such as" | I cannot use `hap.py` and do not know whether I need to. It arrives with no context. | Say it is outside LGE and optional. |
| Where a VCF comes from, "a Medaka model where the" | "model" here is completely opaque to me. | One clause on what a Medaka model is and why the caller needs one. |
| Reading a variant track, "Variants live in the Variants" | I could not find this from the text alone. "Table drawer at the bottom of a reference bundle viewport" is three unfamiliar nouns and I do not know what to click first. | Name the first click, starting from the project window. |
| Reading a variant track, "and the protein consequence where" | The same undefined codon merge, and "protein consequence" is new here too. | Gloss protein consequence. |
| Reading a variant track, "High Impact and Moderate+ filter on" | I do not know what makes an impact high or moderate, or who predicts it. | Name the scale these labels come from. |
| Reading a variant track, "Rare (<1%), Qual >= 30" | "the obvious threshold or lookup" was not obvious to me. Rare relative to which population, and what is ClinVar? | Gloss ClinVar and say which frequency field "rare" is measured against. |
| Reading a variant track, "and the sheet combines the" | I could not tell whether Match All is a fixed behaviour or a setting I can switch to Match Any. | Say whether it can be changed. |
| Reading a variant track, "The categories are Location, Variant" | Seven category names arrive with no example of a finished query, so I could not picture building one. | Give one worked example query. |
| What good looks like, "Across this fixture the mean" | I could not tell whether 44.7 is good, only that under 10 is bad. | Say what a comfortable depth is. |
| What good looks like, "A position under about 10" | The threshold is given for a human sample, and the chapter discusses viral data elsewhere, so I did not know whether it transfers. | Say whether the threshold differs for viral samples. |
| What good looks like, "sort the table by QUAL" | I do not know what I am looking for in the distribution, or what to do once I have looked. | Say what a healthy distribution looks like. |
| On the command line, "running against a bundle-owned alignment" | I have never opened a terminal. The section says it is optional, but the two VCFs I read all chapter came from here, so I felt I had missed a step. | Say the same tracks can be produced in the window. |
| On the command line, "--alignment-track names the alignment inside" | I could not tell where the name `hg002-minimap2` comes from or how I would find mine. | Say where the track name is displayed on screen. |

One thing I learned. A `FILTER` holding a bare dot is not the same as passing, and a whole file of dots just means nobody judged the rows.

One thing I still could not do. Open the Variants tab in the app from the instructions given, because I do not know what a bundle is or what to click to get a viewport.

The sentence I liked most. "Read `.` as "unjudged" and go and look at `QUAL` and `DP` yourself."
