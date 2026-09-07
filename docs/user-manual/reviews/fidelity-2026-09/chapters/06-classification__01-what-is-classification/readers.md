# Merged reader report, What Is Read Classification

Four readers reviewed this chapter. Personas were a genetics sophomore who has never opened a terminal, a wet-lab senior with two years of pipetting and no data analysis, a pre-med student reading in a second language, and an undergraduate who has used Geneious. None had opened a terminal before.

| Location | Issue | Readers who hit it | Suggested fix |
|---|---|---|---|
| Why you would do this, "a clinical amplicon dataset of 86,281" | All four readers did not know what "amplicon" meant at this first use, with no gloss given. | 1, 2, 3, 4 | Gloss amplicon at this first use. |
| Why you would do this, "86,281 read pairs" | All four readers could not tell whether a "pair" means the reported count is doubled, and could not judge whether 86,281 is a small, typical, or large run. | 1, 2, 3, 4 | Say a pair is two reads from the two ends of one fragment, and say whether this count is typical for a clinical run. |
| What LGE runs, "keep provenance for alongside" | All four readers met "provenance" with no gloss at this first use, some also finding the word order awkward. | 1, 2, 3, 4 | Gloss provenance at first use as the record of how a result was produced. |
| What good looks like, "which the run's provenance record names" | All four readers hit the second use of "provenance" still undefined and could not tell where to find the record in the interface. | 1, 2, 3, 4 | Say where the provenance record appears in the interface. |
| Picking a classifier, "They arrive with the PlusPF builds" | All four readers did not know what a "build" of a database is, and PlusPF is never expanded. | 1, 2, 3, 4 | Say a build is one prepared version of a database, and expand PlusPF once. |
| Picking a classifier, "short fixed-length words of sequence called" / "the compact fingerprints of" | All four readers could follow k-mer but not minimizer, with "compact fingerprints" giving nothing to picture or a concrete length to anchor it. | 1, 2, 3, 4 | Give one concrete k-mer length as an example, and say a minimizer is one chosen representative k-mer standing in for a group. |
| Where the classifiers live, "kraken2-20260907-143005" | All four readers could work out the date but not read the trailing digits as a time until they counted them. | 1, 2, 3, 4 | Say plainly that the suffix is the date followed by the time. |
| What you will see, "A Bracken column joins them when" | All four readers met "Bracken" with no gloss and could not say what it adds over the Reads column. | 1, 2, 3, 4 | Gloss Bracken at first use. |
| Databases, "The Plugin Manager's Databases tab lists thirteen" | All four readers could not tell what the four non-Kraken2 databases were or which tool each belongs to. | 1, 2, 3, 4 | Name what the remaining four databases serve. |
| What it is, "the classifier steps back up the hierarchy" / "which is honest rather than a failure" | Three readers read the lowest-common-ancestor step as a possible failure before the reassurance arrived, or could not tell whether "honest" was a technical judgement or the author's opinion. | 1, 3, 4 | Put the reassurance that a genus-level call is still usable before the mechanism, not after. |
| What LGE runs, "that scores its calls for confidence" | Three readers did not know what a "call" is or what form a confidence score takes. | 1, 2, 3 | Gloss call as the classifier's decision that an organism is present, and say what form the score takes. |
| Why you would do this, "a wastewater pellet" | Three readers did not know what a wastewater pellet is, picturing a pill or a piece of solid chemical instead. | 1, 3, 4 | Gloss pellet as the solid material spun down out of a wastewater sample. |
| What LGE runs, table row "CZ-ID", "How do I bring a hosted" | Three readers found the import rows in this table asked a software question while every other row asked a biology question, breaking the column's pattern. | 1, 3, 4 | Keep the column to one kind of question, or make the import rows ask a biological question too. |
| Picking a classifier, "it needs both Nextflow and a container" | Three readers could not tell how to check whether Nextflow and a container runtime are already on their machine, leaving them unable to judge whether the tool is realistic for them. | 1, 2, 4 | Point to where in the app a reader can check whether these are present, or say whether this is self-service or an IT task. |
| Where the classifiers live, "the dialog reports the current selection" | Three readers could not tell what the dialog shows when nothing or the wrong thing is selected, or where the dataset line appears on the window. | 1, 2, 3 | Say where the dataset line appears and what it shows when the selection is empty or wrong. |
| What you will see, "with columns for Sample, Taxon Name" | Three readers could not tell what the % column is a percentage of, out of all reads, classified reads, or reads at that rank. | 1, 3, 4 | State what the percentage is calculated from. |
| Databases, "about half a gigabyte for the viral-only" | Three readers could read the sizes but could not judge whether a 72 GB download was feasible or how long it would take. | 1, 2, 4 | Say roughly how much free disk space is needed and note that the largest downloads can take hours. |
| Where the classifiers live, "(Cmd-Shift-B)" | Three readers could not tell what B stood for, whether they had read the shortcut correctly, or whether it behaved the same as the menu item. | 2, 3, 4 | Say the shortcut does the same thing as the menu item, or drop the shortcut. |
| What you will see, "Some unclassified fraction is normal in any" / "A very large one is a prompt" | Three readers were given no number and could not judge whether their own unclassified fraction was normal or alarming. | 1, 2, 3 | Give a rough normal range for a common sample type. |
| What it is, "A classifier walks the reads one at a time" / "compares each one against a reference" | Three readers did not know what a reference database physically is, a file, a folder, or a website, since the chapter only says later that it is installed on the user's machine. | 1, 2, 4 | Say in this first sentence that the database is a file installed on the user's own machine. |
| Where the classifiers live, "writes a `.lungfishtax` bundle into a top-level" | Three readers could not tell what "top-level" meant relative to the disk or the project, or whether the `.lungfishtax` extension was something they would ever open themselves. | 2, 3, 4 | Say top-level means directly inside the project folder, and say whether the user ever opens this file directly. |
| What it is, "Every taxon sits at a taxonomic rank" / "running from domain down through phylum" | Two readers could not keep the rank order straight or judge which end of the list was broadest, with no ladder or worked example given. | 2, 3 | Give a one-line ladder with a worked example, from broadest to narrowest, next to the rank list. |
| What it is, "running from domain down through phylum" | Two readers had learned "kingdom" in genetics class and read its absence from this list as a possible mistake. | 1, 4 | Note that this is the set of ranks the tools report and that kingdom is skipped. |
| What it is, "A classifier walks the reads one" | Two readers found "walks the reads" an unclear or foreign-sounding phrase for going through them in order. | 3, 4 | Replace "walks" with "goes through". |
| What LGE runs, "NVD is a novel-virus pipeline" / "assembles reads into longer sequences" | Two readers met "assembly" with no gloss and could not say what it produces or whether the user or the tool performs it. | 1, 2, 4 | Add a short clause saying assembly stitches overlapping reads into longer sequences, and say the tool does this on its own. |
| What LGE runs, "reports how well each one is covered" | Two readers met "covered" with no gloss, not explained until a later section. | 2, 4 | Gloss coverage where it first appears. |
| Picking a classifier, "It casts the widest net LGE offers" / "plasmids, the human genome, and vector" | Two readers did not know what "vector sequence" meant, since they only knew "vector" from a different context. | 1, 4 | Gloss vector sequence as laboratory cloning contamination. |
| Picking a classifier, "which is why it can survey tens" / "without aligning any of them" | Two readers met "aligning" with no gloss at this point in the manual, undercutting the speed comparison the sentence makes. | 1, 4 | Gloss aligning in half a sentence, or drop the comparison here. |
| Picking a classifier, "a hundred reads stacked on one conserved" | Two readers did not know what "conserved" meant in this sentence and could not connect it to why the evidence is weaker. | 3, 4 | Gloss conserved as nearly identical across many organisms. |
| Where the classifiers live, "Select your reads in the project" | Two readers could not perform this step, since nothing says what a selected reads bundle looks like in the sidebar or how to confirm the right one was picked. | 1, 4 | Name what the selected item is called in the sidebar, or point to the importing chapter. |
| Where the classifiers live, "Select your reads in the project" | Two readers found this instruction placed after the menu step or at the end of its paragraph, so they would have opened the menu first and missed it. | 2, 3 | Put this instruction at the start of its paragraph, before the menu step. |
| What you will see, "The taxonomy viewport shows the same result" | Two readers did not know the viewport held three linked views until this sentence, and could not tell whether the breadcrumb bar was the third one. | 1, 3 | Name the three views before describing them as linked. |
| What it is, "the classifier steps back up the hierarchy" | One reader could not tell whether the lowest-common-ancestor step meant the classifier had failed, since the reassurance that it is honest came only after the mechanism was described. | 1 | Put the reassurance before the mechanism, not after. |
| What it is, "The whole-sample answer is a distribution" | One reader did not know what wrong "verdict" the sentence was ruling out. | 1 | Name the wrong expectation the sentence is correcting. |
| Why you would do this, "Most of what a nasal or throat" | One reader was given no number for the human background fraction of a swab and could not judge later results against it. | 1 | Give the rough human fraction of a swab as a range. |
| What LGE runs, "The import route is wider than those" | One reader could not see why anyone would import a Kraken2 result when the app can run Kraken2 itself, since the reason arrives only later in the sentence. | 1 | Lead with the reason, that a colleague ran the tool on another machine. |
| Where the classifiers live, "The one exception is a CZ-ID import" | One reader could not tell whether the reader must remember this exception or whether the app just handles it. | 1 | Say plainly that the app places it there and the user does not choose. |
| What you will see, "Colour groups the wedges by phylum" | One reader could not tell whether the sunburst colours meant anything to read off or whether a legend explains them. | 1 | Say whether a legend exists. |
| What good looks like, "A viral-only database run against a" | One reader was told "most reads unclassified" with no number, and expected something closer to the earlier host-background figure. | 1 | Use a number. |
| What it is, "When a read's sequence is shared" | One reader read two phrasings of the same lowest-common-ancestor move back to back and could not tell if they described one step or two. | 2 | Keep one of the two phrasings. |
| What it is, "A run reports a percentage of reads" | One reader could not tell the denominator of this percentage, whether it was all reads in the file or only the classified ones. | 2 | Name the denominator in this sentence. |
| What LGE runs, "bring the output file into LGE" | One reader did not know which output file to bring in, since these pipelines produce folders of files. | 2 | Name the file type each import expects, or point to the chapter that does. |
| Where the classifiers live, "a multi-sample run appears as" | One reader did not know how to start a multi-sample run, since nothing earlier said more than one bundle could be selected. | 2 | Say whether selecting several bundles is how a batch run starts. |
| What you will see, "columns for Sample, Taxon Name" | One reader did not know what the Sample column holds when only one sample was run. | 2 | Explain the Sample column, or say it repeats the input name. |
| What good looks like, "The run finished rather than stopping" | One reader did not know what a stopped run looks like in the Operations panel or what to do about it. | 2 | Point to the chapter that covers a failed run. |
| Next, "Importing NAO-MGS Results (05-running-nao-mgs.md)" | One reader found the link text said "Importing" while the file name said "running", after being told LGE never runs NAO-MGS itself. | 2 | Make the link text and the target file name agree. |
| What it is, "Do that for every read in the file" | One reader had to reread the paragraph to work out which earlier action "do that" referred to. | 3 | Repeat the action instead of saying "do that". |
| What it is, "and you have a census of the sample" | One reader read "census" as a government-specific word from their own language and was not sure it was meant as an ordinary word. | 3 | Use "a count of which organisms are present". |
| Why you would do this, "because a targeted assay only reports" | One reader met "targeted assay" with no gloss, unlike almost every other term in the chapter. | 3 | Gloss it as a test that looks only for organisms chosen in advance. |
| Why you would do this, "The worked runs in the chapters that follow" | One reader first read "worked" as a past-tense verb rather than an adjective. | 3 | Say "the example runs" instead. |
| What LGE runs and what it only imports, "and knowing which side a tool sits" | One reader had to reread this sentence because its subject sat far from its verb. | 3 | Split the sentence into two. |
| What LGE runs, "One tool sits near this part" | One reader could not tell whether "this part" meant a chapter, a section, or a group of chapters. | 3 | Name the part instead of saying "this part". |
| Picking a classifier, "It casts the widest net LGE offers" | One reader understood this idiom only from an unrelated English class and found it not obviously clear. | 3 | Say it covers the widest range of organisms. |
| Picking a classifier, "or as a first pass when the" | One reader could not quickly find the main verb in a sentence with three noun phrases in a row and no comma. | 3 | Shorten the sentence. |
| What you will see, "where the centre is the root of" | One reader could not picture what "the root" looks like at the centre of a circular chart. | 3 | Say the centre circle is one wedge covering all reads. |
| Databases, "from about half a gigabyte for the" | One reader had to convert between two different number formats, words and then digits, to compare the two database sizes. | 3 | Use the same format for both numbers. |
| What good looks like, "The run finished rather than stopping, which" | One reader expected three separate items after the lead-in "Three checks" but found them run together in one paragraph. | 3 | Number the three checks. |
| Front matter, "task: Understand the question read classifiers" | One reader met "classifiers" used before anything said it was a program. | 4 | Say "a classifier is a program that" at the first use. |
| What it is, "reports the lowest common ancestor, the most" | One reader understood the words but not how the program decides when to stop climbing the hierarchy, or whether the user controls that. | 4 | Say whether the user sets this or the tool decides alone. |
| Why you would do this, "That is three answers a targeted" | One reader had to count back through the previous sentence to find the three answers referred to. | 4 | Number them, or drop the count. |
| Why you would do this, "use the SRR36291587 SARS-CoV-2 reads" | One reader did not know what an SRR number is or where it comes from. | 4 | Say it is an accession number from a public sequence archive. |
| Import route, "The Import Center's Classification Results tab carries six cards" | One reader read this as contradicting the table just above, which said three tools were import only. | 4 | Put the six-card fact before the table so it does not read as a contradiction. |
| Freyja paragraph, "It reads variant and depth tables" | One reader did not know what a variant table or a depth table is. | 4 | Gloss both, or say they are files an earlier step in this manual produces. |
| Freyja paragraph, "estimates which SARS-CoV-2 lineages are mixed" | One reader did not know how a lineage differs from a taxon. | 4 | Distinguish lineage from taxon in one clause. |
| Results, "abundance estimation ran alongside the classification" | One reader did not know whether abundance estimation is a checkbox to tick or something that happens automatically. | 4 | Say whether it is a checkbox or automatic. |
| Databases, "which also carries RiboDetector" | One reader saw "RiboDetector" named once with no explanation of what it does. | 4 | Add a short clause saying what it does. |
| What good looks like, "the unclassified fraction is consistent with" | One reader had no number anywhere in the chapter to judge what a normal unclassified fraction looks like. | 4 | Give one rough range for a typical clinical sample. |
| Picking a classifier, "A hundred reads spread across a whole" | One reader could not tell how the results screen shows the difference between reads spread across a genome and reads stacked on one gene. | 1 | Name the coverage number the results screen reports. |

Sixty-eight rows total.

## Consensus

Twenty-one rows were hit by three or more readers.

- The amplicon term is used with no gloss at its first appearance.
- The 86,281 read-pairs figure cannot be judged for scale, and "pair" is never defined there.
- Provenance is used unglossed at its first appearance in "What LGE runs".
- Provenance's second use in "What good looks like" still lacks a location for the record.
- A database "build" such as PlusPF is never defined.
- The k-mer and minimizer explanation gives no concrete length and no picture for "fingerprints".
- The run-folder timestamp suffix is not read as a date and time without counting digits.
- The Bracken column appears with no gloss.
- The four non-Kraken2 databases in the Plugin Manager are never named.
- The lowest-common-ancestor step reads as a possible failure before the reassurance that it is honest arrives.
- A classifier's "call" and the form of its confidence score are never defined.
- A wastewater pellet is never glossed and is pictured as something else entirely.
- The CZ-ID import row breaks the pattern of the "question it answers" column.
- Readers cannot tell how to check whether Nextflow and a container runtime are already on their machine.
- The dialog's current-selection state, including what an empty or wrong selection shows, is unclear.
- The % column's denominator is never stated.
- The 72 GB database download's disk and time cost is never estimated.
- The Cmd-Shift-B shortcut's letter and scope are unclear.
- No number anchors "normal" against "very large" for the unclassified fraction.
- The reference database's physical form, a file installed on the user's own machine, is not said until much later.
- The `.lungfishtax` bundle's file extension and its "top-level" location are both left unexplained.
