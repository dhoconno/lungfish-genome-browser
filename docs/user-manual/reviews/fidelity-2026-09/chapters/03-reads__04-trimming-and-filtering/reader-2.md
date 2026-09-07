# Reader report: Trimming and Filtering Reads

Reader 2. Undergraduate senior. Two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "Reads arrive carrying four kinds" | I had to read the whole paragraph twice. Four things are listed but each is a long sentence with a definition folded inside it, so I lost count of where I was. | Number the four kinds. |
| What it is / "The second is adapter sequence" | I have made libraries at the bench but never understood why a read would run into the adapter. The explanation comes after the term is named. | Explain the short fragment first, then name it adapter. |
| What it is / "Six operations sit under Tools" | Six operations are promised but never listed together anywhere. I had to count them out of the Settings headings much later. | Give the six names in one line here. |
| What it is / "A bundle is the folder LGE" | I did not know whether a bundle is a real folder I can open in Finder or just a thing on screen. | Say whether I can see it in Finder. |
| What it is / "fastp handles quality trimming, adapter" | Four program names arrive in one paragraph and I could not keep straight which one does what by the time I reached Settings. | A three-row table of program and job. |
| Why you would do this / "will map to the wrong" | I do not know what "map" means. It is used several times before anything explains it. | Gloss map at first use like the other terms. |
| Why you would do this / "This chapter works through the HG002" | I did not know what HG002 is or why chromosome 20, and I could not tell whether I needed to care. | Say HG002 is a standard reference human sample. |
| Before you start / "Download the files HG002.chr20" | Two files are named but the procedure has me select one bundle. I could not tell whether I import both files or one. | Say the two files import as one bundle here. |
| Before you start / "These operations use tools from" | "Required Setup pack" is capitalised like a proper name but never explained, and I did not know whether I had to do anything about it. | Say I already have it and need do nothing. |
| Procedure / "Every number quoted below came" | I did not know whether my own numbers should match these exactly. If I got 45,570 reads I would not know whether I broke something. | Say whether the numbers are reproducible to the read. |
| Combined trim step 2 / "Choose Tools > Trimming & Filtering" | The menu item says fastp Adapter + Quality Trim but the window that opens has a different name. I would have thought I clicked the wrong thing. | One clause saying the window is shared by all six. |
| Combined trim step 3 / "Leave Adapter Mode on Auto-Detect" | Threshold of what is not said until Settings. At the point I am told to leave it at 20 I have no idea what the number measures. | Say "quality score of 20" here. |
| Combined trim step 5 / "Click Run." | The instruction to look at the readiness line before clicking is printed after the step that says to click. I had already clicked in my head. | Move the readiness paragraph above the Run step. |
| Combined trim / "It reads Ready to configure output" | I could not tell whether that message means everything is fine or that something is still left for me to configure. It reads like a to-do. | Say plainly that this wording means ready to run. |
| Combined trim / "in the shape Analyses/<tool>-<timestamp>/" | The angle brackets look like something I am supposed to type. I did not know what an actual folder name would look like. | Show one real example folder name. |
| The length filter step 1 / "Click the trimmed bundle in" | I did not know what the trimmed bundle would be called or whether it appears in the sidebar by itself. I would have sat there looking. | Give the name the new bundle takes. |
| The length filter step 3 / "Set Min Length to 50" | Nothing here tells me why 50. The Settings entry says 30 to 50 is usual but I read that much later. | Say why 50 in the step. |
| Trimming a fixed number / "That happens when the library design" | The UMI definition was good, but I could not tell how I would know whether my own library has one. | Say to check the kit protocol. |
| Primer trimming / "Primer schemes in LGE are viral" | I did not understand this. It sounds like a limitation but I could not tell whether it means I cannot trim primers off human amplicons. | State plainly whether human amplicon primers work. |
| Primer trimming / "and marks the primer bases as" | Soft-clipped is glossed but I still could not picture it. The pileup definition inside the same sentence made it too long to hold. | Split into two sentences. |
| Primer trimming / "Position beats sequence whenever a read" | I read this three times. It is the most important idea in the section and the densest sentence in the chapter. | Shorten it. |
| Quality trimming on their own / "and it carries an Extra arguments" | I could not tell whether the missing field in the combined pane is a reason to prefer one operation over the other. | Say whether I will ever need it. |
| FASTA input / "the window relabels itself and its" | I do not know what the subtitle is on this window. I have never seen the window. | Point at where the subtitle sits. |
| Settings fastp / Threshold / "The default is 20, which means" | "Wrong about once in a hundred" is clear, but the link between the number 20 and one-in-a-hundred is asserted, not shown. | One clause on how 20 gives one in a hundred. |
| Settings fastp / Mode / "offering Cut Right, Cut Front, Cut" | Four options are named and only two are explained. I would not know when Cut Front or Cut Tail is right. | Say what the other two do. |
| Settings fastp / Mode / "The default is Cut Right, which" | Cut Right walking from the start confused me badly. The name says right and the behaviour says start. | Say why it is called Cut Right. |
| Settings fastp / Adapter Sequence / "and the IUPAC ambiguity codes that" | I do not know what IUPAC ambiguity codes are and there is no gloss link on this one. | Gloss it or drop it. |
| Settings fastp / Output Strategy / "offering Per Input and Grouped Result" | I could not judge which applies to me. I have one bundle, so both sound like they do the same thing. | Say the choice does not matter with one input. |
| Settings / the repeated Output Strategy entries | The same paragraph appears six times almost word for word. By the fourth I started skipping the Settings section, which is where the answers were. | Write it once and cross-reference. |
| Settings Primer Trimming / "The default is Literal Sequence, and" | That the two choices run different programs is a big deal given as a clause mid-paragraph. I nearly missed that my settings stop mattering. | Give it its own sentence. |
| Settings Primer Trimming / k / "On the command line this is" | Two defaults for one thing, 15 and 23. I could not work out which one applies to me. | Say the dialog gives 15 and stop there. |
| Settings Primer Trimming / mink / "The default is 11, comfortably below" | If I change k, does mink move with it? I could not tell whether 11 stays sensible after I raise k. | Say whether mink must stay below k. |
| Settings Primer Trimming / hdist / "Raise it to 2 for" | Long reads have not been introduced anywhere in this chapter. I did not know whether my Illumina data counts as noisy. | Say Illumina data stays at 1. |
| Settings Trim Fixed Bases / "so a 5' Trim of" | Good warning, but I did not know whether that emptied read is dropped or kept as an empty record. | Say what happens to the emptied read. |
| Settings Filter by Read Length / "Set it to your amplicon length" | I do not know my amplicon length and for shotgun data I do not have one. The advice assumes amplicons. | Give the shotgun case first. |
| Filter by Read Length / "It has no option to drop" | I did not understand the consequence. If one mate is dropped, is the other now unpaired, and does that break mapping later? | Say whether this hurts the mapping step. |
| Reading the results / "Its top pane holds the nine" | Nine and three are given as counts with no names. I would not know which card I am looking at. | Name the two or three cards I need here. |
| Reading the results table / "Shortest read 50 bp 1 bp" | A one-base read alarmed me. I thought the trim had broken. It is explained two paragraphs later. | Say under the table that this is expected. |
| Reading the results / "Bases is the total sequence, and" | I could not find where 93.0 percent came from. I had to divide the two base numbers myself to believe it. | Show the division once. |
| Reading the results / "That gap between the two survival" | This is the key judgement in the chapter and I only got it on the second read, because "the gap" is never given a number. | Give the gap as a number. |
| Reading the results / "Six hundred and seventy-seven reads came" | Every other count in this section is in digits. Spelling this one out made me stop and re-read. | Use 677. |
| Reading the results / "so raising the threshold by ten" | I could not tell whether losing 1.59 million bases is bad. It sounds enormous but I have no scale for it. | Give it as a percent like the others. |
| Reading the results / "Right-click a finished row to reach" | The context menu is mentioned but nothing says what is in it or why I would open it. | Say what the menu offers. |
| What good looks like / "Re-run Tools > QC & Reporting" | This menu item comes from another chapter and I did not know whether it is needed or whether the viewport already refreshed itself. | Say whether the re-run is required. |
| What good looks like / "Four checks tell you the trim" | Four are promised. The first paragraph contains two signs, so I counted five things and thought I had missed one. | Match the count to the paragraphs. |
| What good looks like / "no longer dips below Q20 at" | Q20 appears here for the first time in that written form. It is the same as Threshold 20 but the chapter never says so. | Link Q20 to Threshold 20 once. |
| When a trim goes wrong / "Re-run at a Threshold of" | One in 32 is a strange number and I could not see where it came from. | Drop the number or show the arithmetic. |
| When a trim goes wrong / "Drop Window Size from 4 to" | Window size 1 is not mentioned as allowed in the Settings entry, which only says larger and smaller. I did not know 1 was legal. | Say the minimum window is 1 in Settings. |
| On the command line / whole section | I have never opened a terminal. I was grateful it is optional, but CLI defaults are also discussed inside Settings, where I could not skip them. | Keep CLI defaults out of the Settings entries. |

Three lines.

The one thing I learned. A healthy trim shows up as reads surviving while bases fall, and the two numbers falling together in step is the warning sign.

The one thing I still could not do. Trim primers off my own reads, because the only worked example lives in a different chapter and this chapter never says whether the operation works on non-viral amplicons.

The sentence I liked most. "The input bundle is never modified, so a trim you regret costs you disk space and nothing else."
