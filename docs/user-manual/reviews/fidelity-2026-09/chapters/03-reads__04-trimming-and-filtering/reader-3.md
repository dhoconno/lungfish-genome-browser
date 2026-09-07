# Reader report: Trimming and Filtering Reads

Reader 3. Pre-med student, English is my second language. I have taken genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "Reads arrive carrying four kinds" | "baggage" is a suitcase word. I had to guess it means unwanted extra sequence. | Say "unwanted sequence" the first time. |
| What it is / "so the instrument could grip it" | "grip" is a strange verb for a machine reading DNA. I did not know if it is physical or chemical. | Say the adapter lets the fragment attach to the flow cell. |
| What it is / "where short synthetic oligonucleotides started" | "oligonucleotides" is never glossed, and it appears only here. | Gloss it as a short piece of made DNA. |
| What it is / "Six operations sit under Tools" | I counted the six only much later in Settings. Here I did not know their names. | List the six names once here. |
| What it is / "removes real sequence alongside the artefact" | "artefact" in my science reading means an object in a museum. I had to read twice. | Gloss "artefact" as sequence that is not from the sample. |
| Why you would do this / "or worse, will map to the wrong" | Long sentence with two clauses joined by "or worse". I read it three times. | Split into two sentences. |
| Why you would do this / "a variant caller counts miscalled bases" | "variant caller" is used before it is explained. I do not yet know what it is. | Gloss it as the program that finds differences from the reference. |
| Why you would do this / "This chapter works through the HG002" | I did not know what "chromosome 20 slice" means. Is it a piece of the chromosome? | Say it is reads from one small region of chromosome 20. |
| Before you start / "Download the files ... from the manual's fixtures" | "fixtures" sounds like lamps. I did not understand it is a set of practice data. | Say "practice data files". |
| Before you start / "These operations use tools from the Required Setup" | I do not know what the Required Setup pack is or where to see it. | One sentence saying it installs automatically at first launch. |
| Procedure / "Every number quoted below came from" | I could not tell whether I should expect exactly these numbers on my own run. | Say whether my numbers should match exactly. |
| The combined adapter and quality trim, step 2 / "Its left-hand list holds all six" | I looked for a window titled Trimming and Filtering and found a different title. Confusing. | Say the window title is different from the menu name. |
| The combined adapter and quality trim, step 3 / "the defaults are the ones this fixture wants" | I do not know how to choose defaults for my own data later. | Point to the Settings section for other data. |
| The combined adapter and quality trim, step 5 / "Before you click, glance at the readiness" | This paragraph comes after step 5 but tells me to do something before step 5. I went backwards. | Move it before step 5 or make it its own numbered step. |
| The combined adapter and quality trim / "in a folder named for the tool and the time" | I did not know what a timestamp folder name looks like. | Show one example folder name. |
| The length filter, step 1 / "Click the trimmed bundle in the sidebar" | I did not know what the trimmed bundle is called, so I could not find it in the sidebar. | Give the name the trimmed bundle gets. |
| Trimming a fixed number of bases / "such as a UMI, which is a short random" | Very long sentence with the gloss inside it. I lost the beginning. | Put the UMI gloss in its own sentence. |
| Primer trimming at the read level / "its pane changes shape depending on" | "changes shape" made me think the window resizes. I think it means fields appear. | Say which fields appear and disappear. |
| Primer trimming at the read level / "Primer schemes in LGE are viral by design" | I do not know what a primer scheme is, and "viral by design" is unclear. | Gloss primer scheme and say it is a named set of primers. |
| Primer trimming at the read level / "Position beats sequence whenever a read" | Very long sentence. I understood it only on the third reading. | Split at "because". |
| Quality trimming and adapter removal on their own / "it carries an Extra arguments field" | I did not know what an argument is here. I have never used a terminal. | Say it is extra text passed to fastp. |
| FASTA input / "the window relabels itself and its subtitle" | I could not tell what the subtitle is or where it is on the window. | Say where the subtitle appears. |
| Settings, fastp / "which means the base caller expects to be wrong about once in a hundred" | I did not know 20 maps to one in a hundred. The rule behind it is never given. | State that Q30 is one in a thousand so the pattern is visible. |
| Settings, fastp / "Mode. Chooses which end of the read" | Four choices are named but only Cut Right and Cut Both are explained. I do not know Cut Front or Cut Tail. | One clause each for Cut Front and Cut Tail. |
| Settings, fastp / "the IUPAC ambiguity codes that stand for" | IUPAC is never glossed and is not in the glossary list at the top. | Gloss IUPAC once. |
| Settings, Primer Trimming / "This choice maps to --literal or --ref" | I do not use the command line, so this sentence is noise in the middle of a GUI instruction. | Move CLI flags to the end of each entry as the other settings do. |
| Settings, Primer Trimming / "k. The length of the exact-match word" | The label "k" alone told me nothing, and the sentence uses "word" and "k-mer" for the same thing. | Use one term consistently. |
| Settings, Primer Trimming / "whose own default is 23 rather than 15" | I did not understand why one program has two different defaults. It felt like an error in the manual. | Say plainly this is a known mismatch, not a mistake. |
| Settings, Primer Trimming / "mink. The shortest word bbduk will still" | "mink" looks like an animal. I could not guess it is minimum k. | Say the name is short for minimum k. |
| Settings, Trim Fixed Bases / "so the operation does nothing until you set at least one of the two bounds" | Earlier the text called them 5' Trim and 3' Trim, here "bounds". I thought these were new fields. | Use the same word for these two fields everywhere. |
| Settings, Filter by Read Length / "Set it when concatemers or chimaeric long" | Both "concatemers" and "chimaeric" are unknown to me and not glossed. | Gloss both or drop them. |
| Reading the results / "Its top pane holds the nine summary cards" | Nine cards and three charts are named but not listed. I did not know what to look at. | Name the cards used in this chapter. |
| Reading the results / "Shortest read 50 bp / 1 bp" | A read of 1 base seemed impossible to me. I thought the table had a typo. | Say explicitly that a 1 base read is real and kept. |
| Reading the results / "Six hundred and seventy-seven reads came" | Numbers everywhere else are digits. Spelled out here it broke my reading. | Use 677. |
| Reading the results / "which is 98.51 percent of what went into the filter and 98.43 percent of the original" | Two percentages of two different denominators in one sentence. I got lost. | Split into two sentences. |
| Reading the results / "read the durable record in the bundle's provenance/ folder" | I do not know how to reach a folder inside a bundle from the app. | Say whether there is a menu item to reveal it. |
| What good looks like / "Re-run Tools > QC & Reporting > Refresh QC Summary..." | This menu was never mentioned before. I did not know QC needs a re-run. | Say why the summary is not automatic. |
| What good looks like / "Four checks tell you the trim did what you meant." | I counted the paragraphs after and found four only if the charts paragraph counts as one. It was not obvious. | Number the four checks. |
| When a trim goes wrong / "Re-run at a Threshold of 15, a one-in-32 error rate" | One in 32 does not follow from the earlier one in a hundred rule I was given. | Show the formula once so 15 and 20 both make sense. |
| When a trim goes wrong / "Long-read data sits far lower by nature" | "Long-read data" appears here for the first time and is not explained. | Say it is a different sequencing type, such as Nanopore. |
| When a trim goes wrong / "Drop Window Size from 4 to 1 to judge each base" | Earlier the text said a window of 4 exists so one bad base does not truncate a read. Now it says set 1. It felt contradictory. | Say this is a diagnostic setting, not a normal one. |
| On the command line / "A backslash at the end of a line means" | I do not know what a backslash looks like or where to find it on my keyboard. | Show the character once. |
| On the command line / "--engine cutadapt-linked to select it" | "linked mode" was mentioned earlier without explanation, and here again. | Gloss linked mode once. |

One thing I learned. A healthy trim loses many bases but almost no whole reads, and the gap between those two survival numbers is how you tell.

One thing I still could not do. I could not run the primer trimming operation, because the chapter gives no example I can follow on the data it told me to download.

The sentence I liked most. "The input bundle is never modified, so a trim you regret costs you disk space and nothing else."
