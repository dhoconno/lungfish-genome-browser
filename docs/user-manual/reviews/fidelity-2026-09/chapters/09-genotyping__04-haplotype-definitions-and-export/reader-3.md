# Reader 3 report, Exporting Genotypes

Reader persona. Pre-med student, English is my second language, comfortable
with biology words from textbooks, slowed by idioms and long sentences, and I
have never opened a terminal.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| Title and front matter, "Exporting Genotypes" vs "haplotype-definitions-and-export" | The title says exporting, the file name promises haplotype definitions, and the chapter never defines a haplotype definition set. I expected a section on it and did not find one. | Rename the file to match the title, or add one paragraph saying haplotype definitions are covered elsewhere. |
| What it is, "a folder carrying the `.lungfishgenotype` extension" | I know files have extensions. I did not know a folder can have one, and I did not know whether double-clicking it in Finder opens it or opens LGE. | Add one sentence saying macOS shows this folder as a single item and it opens in LGE. |
| What it is, "which turns that layout on its side" | This is a figure of speech. I stopped to picture it and was not sure whether rows became columns or the whole table was mirrored. | Say "so rows become columns and columns become rows". |
| What it is, "one row per single fact rather than one row per sample" | "Fact" is not a data word I have learned. I could not tell what one fact is here. | Give the example, one row per sample-and-allele pair. |
| What it is, "So what should you do with this?" | The question is addressed to me but I had not been given anything to do yet, so I read the paragraph twice looking for the missing instruction. | Delete the question and keep the advice sentence. |
| Why you would do this, "which is exactly the step that introduces errors nobody catches" | Long sentence, and the relative clause is far from what it refers to. I had to re-read to see that retyping is the dangerous step. | Split into two sentences. |
| Why you would do this, "filtering the pivot at a modest threshold" | "Modest" gives me no number. I could not judge whether my own threshold is modest. | Name the threshold here, Min reads 50 and Min percent 5. |
| Why you would do this, "removed 192 of 305 allele rows" | Two thirds of the rows are gone and I could not tell whether that is normal. The reassurance is far away in What good looks like. | Add "which is normal" and point forward to What good looks like. |
| Why you would do this, "the Williams MiSeq genotyping project" | MiSeq is not explained. I have heard of Illumina in class but not this machine name. | Gloss MiSeq once as an Illumina short-read sequencer. |
| Why you would do this, "IPD-MHC Mamu allele library" | Three unfamiliar terms in one phrase. I know MHC but not IPD-MHC or Mamu. | Gloss as the reference database of rhesus macaque MHC alleles, Mamu being the rhesus prefix. |
| Before you start, "read this chapter against a genotype result of your own" | I do not have my own macaque data. I could not perform any step in this chapter and there is no substitute dataset offered. | Say plainly that readers without a result should read for orientation only. |
| Before you start, "because every export described here reads the same manifest" | "Manifest" is used once and never explained. | Gloss manifest at first use, or say "the same index file inside the bundle". |
| Before you start, "the viewport's **Actions** menu is hidden" | "Viewport" is used as if I already know it, and it is not in the glossary list at the top. I could not tell which part of the window is the viewport. | Gloss viewport at first use as the main display area in the middle of the window. |
| Before you start, "One fact about the window decides which in-app export you will find, and it is worth settling before you go looking." | Two idioms in one sentence, "settling" and "go looking". I read it three times before I understood it means check this first. | Replace with "Check one thing about your result before you start." |
| Step 1, "clicking its disclosure triangle" | I do not know what a disclosure triangle looks like. There is no screenshot at this point, the first one comes after. | Say it is the small arrow at the left of the section heading. |
| Step 1, "past the search fields, the numeric filters, and the colour controls" | This assumes I can recognise each of those groups by sight. Without a screenshot before this step I could not confirm I had scrolled to the right place. | Move the screenshot marker above this paragraph. |
| Step 1, "Both sit at 0 by default, which means both are off" | I understand 0 is off, but I was not told what value to type for the worked example until much later in Step 2. | State the example values, 50 and 5, here. |
| Step 1, "The caption in the section states the rule in one line, that visual filters do not change genotype calls, and the export is where those visual filters finally become permanent in a file." | Very long, and "finally become permanent" felt like a warning I did not fully understand. Does the export lock in a mistake? | Split, and say directly that a filter you forgot to clear will be baked into the exported file. |
| Step 1, "Choose a location outside the project folder" | I was told to do it but not what goes wrong if I do not. | Say what happens, for example that LGE may treat it as part of the result. |
| Step 2, "it is laid out in three bands" | "Band" is a metaphor for a group of rows. In biology class a band is on a gel, so I first pictured electrophoresis. | Say "three groups of rows". |
| Step 2, "the individual samples range from 713 to well over forty thousand" | I could not judge whether 713 is a failing sample or an acceptable one, and the number is written in words while every other number is digits. | Give the pass or fail meaning of a low count, and write 40,000 as digits. |
| Step 2, "a much stricter test than ordinary mapping" | "Mapping" appears without explanation and is not in the glossary list. I have not learned it. | Gloss mapping at first use as aligning reads to a reference. |
| Step 2, "eight [loci](../../GLOSSARY.md#locus)" then later "13 loci the run reported" | Eight here and thirteen in Step 3. I could not tell whether these count different things or whether one is a mistake. | Say why the counts differ. |
| Step 2, "where a haplotyped run would write its family calls" | "Family calls" is new and undefined, and "haplotyped" is used as a verb. | Gloss, or say "where a haplotype analysis would write its results". |
| Step 2, "named by its reference record" | I do not know what a reference record is, and the example name `01_Mamu-A1_002g` has parts I cannot decode. | Break down one allele name once, saying what each part means. |
| Step 2, "blanked 1,478 individual allele values and removed 192 rows, leaving 113 of the original 305 allele rows" | Four numbers in one sentence. I had to re-read to see which subtraction gives which. | Split into two sentences, or add "305 minus 192 leaves 113". |
| Step 2, "because two single-read observations were blanked and the totals were recomputed rather than left stale" | 929 minus 927 is 2, and two observations were dropped, so I expected 5 minus 2 to be 3 and it is. But I had to work the arithmetic myself to trust it. | Show the subtraction explicitly. |
| Step 2, "on an unreviewed result both hold only their header row" | "Unreviewed" and "header row" are clear, but "the analyst edits" assumes I know that a person adds notes to the result. | Say in one clause what an analyst edit is. |
| Step 3 heading, "from the command line" | I have never opened a terminal. This step is presented as part of the required Procedure, not as optional, so I believed I had to do it and could not. | Mark Steps 3 and 4 as optional, the way the later section is marked. |
| Step 3, "headed `H1` and `H2` for the two report slots each locus carries" | "Report slot" is a new term. I guessed it means the two chromosome copies but I am not sure. | Say whether H1 and H2 mean the two alleles a diploid animal carries. |
| Step 3, "listing the tokens `M1` through `M7` with their hex colours" | "Token" and "hex colour" are both computer words I do not know. | Replace token with label, and say hex colour is a colour code such as `#D47B3A`. |
| Step 3, "an `ERR` token for an error or no call" | I do not know what "no call" means or whether it is bad. | Gloss "no call" as the software could not decide. |
| Step 4, "it takes no tuning options at all" | "Tuning options" is idiomatic. I was not sure whether this means I cannot filter the LabKey files. | Say directly that filters do not apply to this export. |
| Step 4, "`animal_id,gs_id,allele,locus_group,unique_reads,passed_unique_reads,passed_alignments`" | Seven column names, none explained. I could not tell what "passed" means or what GS ID is. | Add one line saying what GS ID is, and what passed counts. |
| Step 4, "reflect your overrides merged over the pipeline result" | "Merged over" is a phrase I could not parse. Does the override replace the pipeline value, or sit beside it? | Say "your override replaces the pipeline call". |
| Settings, "Everything in this section lives in the Inspector's **Genotype Display** section, except the two export buttons and the workbook button, which are named where they sit." | Long sentence with an exception inside an exception, and "named where they sit" is idiomatic. | Split, and say plainly that those three buttons are elsewhere in the window. |
| Settings, "Every control here is display state." | "Display state" is a software term with no gloss. | Say "these controls change only what you see". |
| Settings Min reads, "a whole number from 0 to 100,000" | The range is given but not what a sensible value is. The example used 50, which I only learn from Step 2. | Say a typical starting value and why. |
| Settings Min percent, "in steps of 0.5" | I did not know whether that means I cannot type 5.2, and I could not judge what percent is reasonable. | Say the field rounds to the nearest 0.5, and give a typical value. |
| Settings Percent Basis, "which is the usual case for an amplicon panel" | "Amplicon panel" is not explained anywhere in the chapter. | Gloss as a set of PCR products sequenced together. |
| Settings Alleles, "narrows a 970-row matrix to the DRB targets alone" | 970 rows appears here and 305 appears everywhere else. I could not tell whether these are the same result. | Say this number comes from a different result, or use the Williams number. |
| Settings Show All Rows, "remembering that there is no automatic row limit for it to undo" | I read this three times. I still do not know what it warns me about. | Delete, or say plainly what the risk is. |
| Settings Filtered Pivot, "it appears only when the result carries a workbook the pivot can be built from" | I could not tell how to know in advance whether my result has one, or what to do if the button is missing. | Say what to check if the button does not appear. |
| Settings Update and View Current Excel Version, "disabled while the workbook is already current or the bundle is read-only" | I do not know what makes a bundle read-only or how I would fix it. | Say the common cause, for example a locked folder. |
| Settings, "Eight further options exist only on the command line, and each one shapes an export a button cannot." | The sentence is compressed and the ending clause reads as unfinished. I re-read it. | Rewrite as "a button cannot produce". |
| Settings --view-projection, "Points at a JSON file describing a rendered viewport" | JSON, rendered, and viewport in one sentence, none glossed. I could not tell where such a file would come from. | Say a JSON file is a plain text data file, and where LGE writes one. |
| Settings --lens, "Records which viewport view an export came from" | "Lens" is used as a flag name and never explained as a concept. | Gloss lens once. |
| Settings --annotations, "annotation sidecar" | "Sidecar" is a metaphor I did not understand at all. | Say it is a separate file stored next to the bundle. |
| Settings --force, "which is a guard worth keeping until a script needs to rerun cleanly" | I do not write scripts, so I could not judge when to use this. | Say most readers never need it. |
| Reading the results, "those three numbers are the record of how hard your filters bit" | "How hard your filters bit" is an idiom. I understood the words but not the meaning on first pass. | Say "how much your filters removed". |
| Reading the results, "read it as a check that the exporter saw the whole result" | Very long sentence, over 60 words, with three clauses about three different numbers. | Split into three short sentences, one per number. |
| Reading the results, "7 of those samples were too thin to call much" | "Too thin" is an idiom, and I could not tell what read count counts as thin. | Say "had too few reads", and give the cutoff. |
| What good looks like, "A good export is boring." | I liked this line but as a non-native reader I stopped to check whether "boring" was a technical judgement. | Keep, but follow immediately with the plain meaning. |
| What good looks like, "the threshold is wrong for your sequencing depth, not the export" | I was told the threshold is wrong but not which direction to move it. | Say lower the threshold and export again. |
| Haplotype analysis (placeholder), "A worked example with an MCM dataset will be added" | MCM is never expanded. I could not guess it. | Expand MCM at first use. |
| On the command line, "by typing commands into the Terminal application" | This is my first sight of what a terminal is, and it comes near the end after Steps 3 and 4 already required one. | Move this sentence to the first mention of the command line, in Step 3. |
| On the command line, "Every command takes a `--bundle` pointing at the `.lungfishgenotype` folder" | I do not know how to write the path to a folder on my computer, and the examples use a relative path I would not know how to reproduce. | Say how to get a folder path, for example by dragging it into the Terminal window. |
| On the command line, "`lungfish-cli genotype export-xlsx \`" | The backslash at the end of each line is not explained. I would have deleted it. | Say the backslash continues the command onto the next line. |
| On the command line, "`--percent-basis` on the command line defaults to `sample-retained`" | The two defaults disagree and I could not tell which one is correct behaviour or whether this is a bug I should report. | Say whether this difference is intended. |
| On the command line, "reporting that a provenance publication artifact no longer matches the transaction generation" | I could not understand any part of this error message, and "symbolic link" is also unexplained. | Say only what the reader sees and what to do, and drop or gloss the internal wording. |

One thing I learned. An exported file is frozen while the result bundle keeps
changing, so the workbook a collaborator holds three months later is exactly
the one I sent.

One thing I still could not do. I could not perform any of the four exports.
Steps 1 and 2 need a macaque result I do not have, and Steps 3 and 4 need a
terminal I have never opened and the chapter does not teach.

The sentence I liked most. "A good export is boring."
