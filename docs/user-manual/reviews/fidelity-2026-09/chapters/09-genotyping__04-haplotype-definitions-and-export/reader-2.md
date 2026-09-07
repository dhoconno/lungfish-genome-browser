# Reader 2 report, Exporting Genotypes

Persona. Senior, two years of wet lab, library prep and PCR are second
nature, no data analysis at all, never opened a terminal.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| Title vs. front matter, "Exporting Genotypes" | The file is named haplotype-definitions-and-export and the last section says haplotype analysis is a placeholder, so I spent a minute looking for the haplotype definitions half that never arrives. | Say in the first paragraph that haplotype definitions are not covered yet. |
| What it is, "a folder carrying the `.lungfishgenotype` extension" | I did not know a folder could have an extension. In Finder my folders do not look like files, so I could not picture what I am clicking. | Add that this folder shows up as a single item you click like a file. |
| What it is, "their checksums" | Checksum is never explained, and it is inside the sentence that explains provenance. | Gloss checksum in the same sentence as a fingerprint that shows a file has not changed. |
| What it is, "loci across the columns" | Locus is used here, four paragraphs before it is defined in Step 2. I read the first use as a typo for "locus". | Move the one-line locus gloss to this first use. |
| What it is, "allele targets run down the rows" | Allele target is linked but not glossed here. I know what an allele is from genetics, but not what makes it a "target". | Add that an allele target is one reference sequence the reads are matched against. |
| What it is, "which any script can read without a spreadsheet library" | I do not know what a script or a spreadsheet library is. This is offered as the reason to pick a format, so I cannot pick. | Say instead that a CSV opens in any program including Excel. |
| What it is, "one row per single fact rather than one row per sample" | I read this three times. "One fact" is abstract with no example. | Give the example, one row for one sample and one allele and its count. |
| Why you would do this, "filtering the pivot at a modest threshold removed 192 of 305 allele rows" | 192 of 305 is not modest to me. Two thirds of my rows disappearing sounds like a disaster, and the number that made it happen is not stated here. | Name the thresholds here and say why losing two thirds is expected. |
| Why you would do this, "a long tail of very low read counts" | "Long tail" is a statistics phrase I have not met. | Replace with a plain phrase such as many alleles seen only once or twice. |
| Before you start, "an IPD-MHC Mamu allele library" | Three unexplained things in five words. IPD-MHC, Mamu, and what an allele library is. | Gloss all three in one sentence, or drop to "a rhesus macaque MHC allele reference set". |
| Before you start, "read this chapter against a genotype result of your own" | I do not have a genotype result of my own and the manual does not ship one, so I cannot do any step in this chapter. Every number below is from a dataset I cannot open. | Say plainly that without a result you can only read, or point to a sample bundle. |
| Before you start, "A run that produced only allele calls, with no haplotype analysis on top of them" | I could not tell from this whether my own run has haplotype analysis, and the rest of the chapter branches on it. | Say where in the window to look to tell the two apart. |
| Step 1, "Open the Inspector's Genotype Display section by clicking its disclosure triangle" | Disclosure triangle is Mac vocabulary I only half know, and Inspector is glossed one section earlier but not shown. Without the screenshot I cannot find the panel. | Add "the small arrow at the left of the section heading". |
| Step 1, "past the search fields, the numeric filters, and the colour controls" | This lists controls I have not seen and which are only explained later in Settings, so scrolling past them is guesswork. | Say only "scroll to the bottom of the section". |
| Step 1, "Min reads hides any allele value supported by fewer reads" | I do not know what number to type. The text says the Settings section explains it, but the worked example uses 50 and I only learn that two pages later. | Give the starting value, 50, here in the step. |
| Step 1, "the export applies whatever they say at the moment you press" | Had to read twice. It is the important warning of the whole chapter and it is buried mid-paragraph. | Make it its own short sentence at the start of the paragraph. |
| Step 1, "Choose a location outside the project folder" | I do not know what counts as inside my project folder, and nothing said where the project folder is. | Suggest a concrete place such as the Desktop. |
| Step 2, "an average of 22,764 each, and the individual samples range from 713 to well over forty thousand" | I cannot judge these. Is 713 a failed sample I should throw out, or fine? The text gives no line between good and bad. | Say what read count is too low to trust. |
| Step 2, "matched an allele target exactly across the whole sequenced stretch, which is a much stricter test than ordinary mapping" | I have never done mapping, so the comparison explains nothing to me. | Say instead that a single mismatching base disqualifies a read. |
| Step 2, "eight loci" here versus "13 loci" in Step 3 | Two different locus counts for what I thought was the same run. I could not tell whether I had misread. | State that the haplotype rows cover eight loci while the run reported 13. |
| Step 2, "blanked 1,478 individual allele values and removed 192 rows" | I do not know the difference between a blanked value and a removed row. Both sound like deletion. | Add that a row is removed only when every one of its values was blanked. |
| Step 2, "the same row reads 927 across 3 observations, because two single-read observations were blanked" | The arithmetic does not work for me. 929 minus two single reads is 927, that part is fine, but 5 observations minus 2 is 3 while the two blanked reads were 1 each. I read it four times before I trusted it. | Spell out that the two blanked cells held one read each. |
| Step 2, "retained percentages" | Never defined. Percentage of what. | Gloss it as the share of a sample's reads that matched an allele exactly. |
| Step 3, "The three remaining formats have no button. They come from `lungfish-cli genotype export`" | This is the terminal, which I have never opened, and there is no pointer to how to open it until the very last section. | Add here that the On the command line section explains how to start. |
| Step 3, "two columns per locus, headed H1 and H2 for the two report slots each locus carries" | Report slot is new and unexplained. I guessed it means the two alleles you inherit, but the chapter never says so. | Say H1 and H2 hold the two alleles called at that locus. |
| Step 3, "listing the tokens M1 through M7 with their hex colours" | Token and hex colour are both unexplained, and I do not know what M1 through M7 stand for. | Gloss what the M tokens mean, or say the Legend sheet explains them. |
| Step 4, "It writes five CSV files into a directory you name" | Directory is used here where the rest of the chapter says folder, and I did not know they were the same. | Use folder throughout. |
| Step 4, "with a stable header and standard quoting" | Standard quoting means nothing to me. | Delete it or say commas inside a value are handled safely. |
| Step 4, "reflect your overrides merged over the pipeline result" | Pipeline is used without gloss, and "merged over" made me read twice. | Say your corrections replace the original calls. |
| Settings, "Every control here is display state" | Display state is jargon. I worked it out from the next sentence but not on the first pass. | Say these controls change only what you see. |
| Settings, Min reads, "it accepts a whole number from 0 to 100,000" | The range is given but not a value to start at, and elsewhere the chapter uses 50 without saying why. | Name 50 as a reasonable starting point. |
| Settings, Min percent, "in steps of 0.5" | I could not tell whether that means I cannot type 5.2 or the arrows just move by 0.5. | Say whether typed values off the step are allowed. |
| Settings, Percent Basis, "the usual case for an amplicon panel" | I have made amplicons at the bench but do not know what an amplicon panel means here or why depths would differ across loci. | Say that some primer pairs amplify better than others in the same reaction. |
| Settings, Alleles, "narrows a 970-row matrix to the DRB targets alone" | 970 rows appears once and contradicts the 305 allele rows quoted throughout. I could not tell which is the Williams result. | Use the same result's number or say this example is a different run. |
| Settings, Alleles, "typing `DRB`" | DRB is used as if familiar. I have heard of it only vaguely. | Say DRB is one MHC class II gene family. |
| Settings, Show All Rows, "remembering that there is no automatic row limit for it to undo" | I read this three times and still do not know what it warns me about. | Cut it or state the risk directly. |
| Settings, Cell Color, "shades each cell by its read count" | It does not say which direction, darker for more or for fewer, so I cannot read an exported sheet. | Say darker means more reads. |
| Settings, Export Excel View, "with the format fixed rather than chosen" | Had to read twice. I think it means you get XLSX and no choice. | Say the file is always an Excel workbook. |
| Settings, Update and View Current Excel Version, "records the change as a workbook revision" | Workbook revision is new here, and this is the one button that writes into my result, which is worth more warning than it gets. | Add one sentence on what a revision is and that the old one is kept. |
| Settings, "Eight further options exist only on the command line" | I counted nine bold entries after this line. I recounted twice thinking I had lost one. | Fix the count or the list. |
| Settings, --view-projection, "Points at a JSON file describing a rendered viewport" | JSON, rendered, and viewport in one line, none glossed, and I cannot tell whether I would ever need this. | Say a non-terminal reader can ignore this option. |
| Settings, --annotations, "an annotation sidecar" | Sidecar is unexplained and sounds like a motorcycle. | Say a separate notes file stored next to the result. |
| Settings, --active-haplotype-definition | This is the only place the chapter's own title subject appears, and it says the right setting is none. | Say haplotype definitions are covered in a later release. |
| Reading the results, "prints a JSON summary naming `matchedAlleleRows`" | I would not know where this summary appears, since I never ran a command. | Say it prints in the Terminal window after the command finishes. |
| Reading the results, "7 of those samples were too thin to call much" | Thin is not defined, and this is the first hint that some samples fail. I still do not know how to spot mine. | Give the read count below which a sample is too thin. |
| What good looks like, "the threshold is wrong for your sequencing depth, not the export" | I know depth from library prep talk but not how to translate my depth into a Min reads number. | Give a rule of thumb tying depth to a threshold. |
| On the command line, "by typing commands into the Terminal application" | This is the first and only mention of how to start, and it comes after two Procedure steps that already required it. Nothing says where Terminal is or what a prompt looks like. | Move a one-line "open Terminal from Applications, Utilities" up to Step 3. |
| On the command line, code block "`lungfish-cli genotype export-xlsx \`" | The backslash at line ends and the quoted relative path both stopped me. I do not know whether to type the backslash or where the command runs from. | Add one line saying the backslash continues the command and paths are relative to the project folder. |
| On the command line, "`--percent-basis` on the command line defaults to `sample-retained`" | A default that differs from the window is exactly the kind of trap I would fall into, and it sits after the example that already passes the flag. | Put this warning before the example. |
| On the command line, "reporting that a provenance publication artifact no longer matches the transaction generation" | I could not parse this error at all, and I do not know what a symbolic link is or how I would know I had one. | Say simply that exports to temporary folders fail. |

One thing I learned. An export is a frozen copy, and the filters showing on
screen are what get written into the file.

One thing I still could not do. Run any of Step 3 or Step 4, because I have
never opened a terminal and the chapter explains how only at the very end.

The sentence I liked most. "A good export is boring."
