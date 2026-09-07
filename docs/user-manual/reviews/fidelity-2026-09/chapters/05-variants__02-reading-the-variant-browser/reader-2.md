# Reader report: Reading the Variants Table

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A variant caller writes its answer" | I do not know what "tab-separated" means as a file property, or why that matters if I never open the file myself. | One clause saying tab-separated means columns divided by tab characters. |
| What it is, "The drawer starts 250 points tall" | "Points" is not a unit I have ever used for a screen. I could not tell whether that is big or small. | Say roughly what fraction of the window that is. |
| What it is, "A two-segment control switches between" | I did not know what a "two-segment control" looks like, so I did not know what to hunt for on screen. | Name the two labels it shows so I can spot it. |
| Why you would do this, "The HG002 chromosome 20 slice holds" | I do not know what makes a cell line "well-studied" or why that matters for this exercise. | One sentence on why a known sample is useful for learning. |
| Why you would do this, "Those two runs produced 1,056 rows" | I could not tell whether two callers disagreeing by two hundred rows is normal or alarming at this point in the chapter. | Say early that a later section explains the gap. |
| Before you start, "You need a project open. If" | I did not know whether the project has to sit in any particular place or be named anything special. | One clause saying any folder works. |
| Before you start, "No plugin pack is needed" | I do not know what a plugin pack is, and this is the first place I met the phrase. | Gloss plugin pack at first use here. |
| Step 1, "Check the Operations panel with Operations" | I have never opened the Operations panel and did not know what a finished run looks like there. | Say what a finished row looks like, not only its text. |
| Step 2, "Seven of them are the VCF's" | I counted the table below and it lists six rows, because Ref and Alt share one. I could not reconcile seven with what I saw. | Split Ref and Alt into two table rows. |
| Step 2, "The remaining six carry Filter, which" | The first six are in a table and the second six are in a paragraph. I lost track and had to read it twice to line them up. | Put all twelve in the one table. |
| Step 2, "but LGE's own iVar output writes" | iVar has not appeared anywhere before this and I do not know what it is. | Gloss iVar or drop it here. |
| Step 2, "The bcftools track on this fixture" | I do not know what DP4, MQ, AC, or SB mean, and they are named as if I should. | Expand each abbreviation once. |
| Step 2, "A few are pulled to the" | I could not tell which few, so I would not know whether my table was ordered correctly. | Name them, or say the order does not matter. |
| Step 3, "The table is a standard macOS" | I do not know what VoiceOver is and could not tell whether this sentence was meant for me. | One clause saying it is the macOS screen reader. |
| Step 4, "Biological Effect holds SNV, Indel, High" | I do not know what impact level "Moderate+" refers to or what ClinVar is. | Gloss both at first use. |
| Step 4, "The impact chips need an IMPACT" | Neither SnpEff nor VEP was introduced and I do not know whether I am supposed to have one. | Say plainly that this fixture has neither and you do not need one. |
| Step 4, "The three frequency chips appear only" | I know haploid from genetics, but I could not work out why a frequency chip would be haploid-only. | One clause on why the fraction is only meaningful there. |
| Step 4, "Het Only is unavailable on every" | I could not tell whether this is a bug I should report or expected behaviour. | Say it is a known gap. |
| Step 5, "Population/Frequency offers AF and the three" | I do not know which population databases or keys these are. | Name them once. |
| Step 5, "Sample/Genotype offers Sample.GT, Sample.AF, and Sample.DP" | The dot notation was new and I did not know it meant a field belonging to one sample. | One clause explaining the dot. |
| Step 5, "A Location rule takes only =" | I did not know whether 1-250000 counts from the start of chromosome 20 or from the start of the 500 kb slice. | State which coordinate the range counts from. |
| Step 5, "On the bcftools track that leaves" | I could not reproduce 574 because I did not know whether the scope control had to be Region or Genome. | State the scope setting alongside the numbers. |
| Step 5, "tells you to zoom the viewport" | I do not know how to zoom the viewport, and this chapter never said. | Cross-reference the chapter that covers zooming. |
| Step 6, "The tick colors on the genome" | I did not know there was a genome track above the drawer, or what a tick is. | Name where that track sits when it is first mentioned. |
| Step 6, "with allele depths of 20 reference" | I could not tell where in the Inspector to find the allele depths. | Name the field key that holds them. |
| Step 6, "because LoFreq skips indels unless you" | I could not tell whether I can ask for indels inside LGE or only outside it. | Say whether the option is exposed. |
| Settings, "note that at narrow window widths" | "GT" appears with no expansion. I only worked it out later from the genotype discussion. | Expand GT here. |
| Settings, "Auto / Haploid / Diploid. Tells the" | This control is described in Settings but never appeared in the six procedure steps, so I did not know when I would ever touch it. | Mention it once in the procedure. |
| Settings, "The default is Auto, which guesses" | I could not judge how a size guess separates a virus from a human, or whether a 500 kb slice might fool it. | One clause on the size cutoff. |
| Reading the results, "It is a Phred score" | I understood the one-in-a-thousand part but not why two Phred scores "cannot be compared". | One clause on why the scales differ. |
| Reading the results, "The bcftools rows run from 4.5" | I did not know whether I should worry about the 24 rows below 30 or ignore them. | Say what to do with them. |
| Reading the results, "That is comfortable for human work" | I could not tell whether 30 counts reads or something else, since the same passage carries 44.7. | Say "30 reads deep" outright. |
| Reading the results, "623 rows reading 0/1 and 415" | 623 plus 415 is 1,038, not 1,056, and I could not find where the other 18 went. | Account for the remainder. |
| What good looks like, "The bcftools track called 1,056 rows" | I could not follow how 1,056 rows across 500 kb becomes one every 470 bases without doing the division myself. | Show the division or drop the derived number. |
| What good looks like, "The Source column names the track" | I did not know which track to click or where, since the Source column holds text and not a button. | Say where the track is clickable. |
| On the command line, "The --filter flag accepts per-sample clauses" | This contradicted what the Settings section told me, that the Search Builder query text is what --filter takes. I read both passages three times. | Reconcile the two statements in one place. |
| On the command line, "BUNDLE=\"MyProject.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref\"" | I have never opened a terminal and did not know I had to replace MyProject with my own project name. | Say the path is an example to edit. |
| On the command line, "--filter 'Sample[HG002].GT=1/1' \\" | I did not know where to find the sample name HG002 in my own project if mine differed. | Point at the Samples tab for the name. |
| On the command line, "bcftools view -H hom-alt.vcf" | I do not know what -H or wc -l do, and the section never said bcftools is a separate program I am now running directly. | One clause saying this counts the rows. |
| Next, "Continue to Nanopore Variant Calling for" | The links jump from chapter 02 to 04 and 05, so I wondered whether I had skipped 03. | Say what 03 covers or why it is skipped. |

The one thing I learned: a blank or dotted `Filter` value means nobody judged the row rather than that the row failed, so an empty table after clicking `PASS` is a fact about the file and not about my filter.

The one thing I still could not do: run any of the command-line examples, because I could not work out what to substitute for the bundle path or the sample name from my own project.

The sentence I liked most: "Read a bare `.` as unjudged rather than as failed, look at the column before you filter on it, and use **Clear** to bring the rows back."
