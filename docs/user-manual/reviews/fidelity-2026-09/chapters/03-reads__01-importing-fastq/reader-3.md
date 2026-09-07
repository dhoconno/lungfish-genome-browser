# Reader report: Importing Sequencing Reads

Reader 3. Pre-med student, English is my second language. I have taken genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Importing is the step that brings" | "Brings read files from your disk into a project" sounds like copying, but two paragraphs later the chapter says it is not a copy. I read three paragraphs before I understood. | Say in the first sentence that import measures and repackages the reads. |
| What it is, "What import produces is a bundle" | "A folder that LGE treats as one object" is abstract for me. I do not know if I will see a folder in Finder or only an icon in the app. | Say whether Finder shows it as a folder or as one file. |
| What it is, "Inside it sit the read data" | The word order "Inside it sit the read data" is inverted and I read it twice before I parsed it. | Use plain order, "The bundle holds the read data, a metadata file, and a provenance folder." |
| What it is, "It computes a checksum, a short fingerprint" | I understand the definition, but not why I would ever need to prove data has not changed, or which later step does that. | One clause naming the situation that uses the checksum. |
| What it is, "It usually rewrites the reads into" | "Usually" made me anxious. I do not know when it does not. | Name the condition, or drop "usually". |
| What it is, "It also covers an unmapped Oxford" | I know FASTQ from class. I do not know BAM at all, and "unmapped" is explained but "BAM" itself is never glossed. | Gloss BAM at first use the way FASTQ is glossed. |
| Why you would do this, "Mapping, quality control, trimming, classification" | Six analysis terms in one sentence, none glossed here. I know two of them. | Say "every analysis in this manual" and let the later chapters name themselves. |
| Why you would do this, "This chapter works through the HG002" | British spellings "characterised", "recognised", "optimisation" sit next to American forms elsewhere. The mix made me stop and check whether I had misread. | Pick one spelling convention. |
| Why you would do this, "The two files hold 45,574 read" | I do not know what "kb" means without expanding it, and I could not tell whether 45,574 pairs is a lot or a little. | Expand "kb" once, and say this is a deliberately tiny slice. |
| Before you start, "You need a project open. If" | I do not know what happens after I pick a folder. Does the project open by itself? | One clause saying the project window opens. |
| Before you start, "Download the files HG002.chr20.10.0-10.5Mb_R1.fastq.gz and" | The URL is very long and printed inline in the middle of a sentence. On my screen it wraps and I could not tell where it ends. | Put the link on its own line. |
| Before you start, "Nothing here needs a plugin" | This tells me about two things I had never heard of, then says I do not need them. It only created new questions. | Move this to the chapter where those things are first needed. |
| How LGE decides, "Two files pair when their names" | "Mate suffix" is used before it is defined. I guessed it from the table below, so I had to jump ahead. | Define mate suffix in the same sentence. |
| How LGE decides, table column "Where it comes from" | "Illumina bcl2fastq and DRAGEN" and "ENA and SRA downloads" are five product names I do not know. I could not use this column at all. | Say "Illumina software" and "public archives" instead of tool names. |
| How LGE decides, "The match is case-sensitive, so use" | I know the term, but the consequence took two readings because the negative examples pile up, "does not pair", then "Neither does a dot". | Split it into two short sentences. |
| How LGE decides, "A file whose mate is missing" | "No warning appears" frightened me. My files could import wrongly and silently and I do not know how to notice before it is too late. | Say directly that the summary count is the only warning you get. |
| Procedure step 1, "Open your project and choose File" | I could not picture "a tabbed grid of cards". Are cards buttons? Do I click once or twice? | Say cards are clickable tiles. |
| Procedure step 3, "Click the Sequencing Read Files card" | I do not know how to select two files at once on a Mac. I have used a computer, but never for this. | Say to hold Command while clicking the second file. |
| Procedure step 4, "Read the Import FASTQ configuration sheet" | I could not tell whether "R1:" is a label I should literally see printed, or a placeholder standing for something else. | Say the sheet prints the literal label R1 followed by the filename. |
| Procedure step 5, "Confirm the settings and click Import" | "There is no sample-name field" answered a question I had not asked, and then I worried whether I can rename the bundle later. | Say whether the name can be changed after import. |
| Procedure, "Watch the progress in the Operations" | This sits after step 5, outside the numbered list, but it looks like an action I take. I did not know if it is a sixth step. | Number it, or say it is optional. |
| Importing an unmapped Oxford Nanopore BAM, "You can still change the Platform" | "Popup" here, "control" in the Settings section, and I think of it as a field. I was unsure all three are the same thing. | Use one word for it throughout. |
| Settings, Platform, "Records which sequencing instrument produced the" | Changing Platform silently changes two other settings. I could not tell whether it overwrites choices I already made by hand. | Say whether it overwrites my earlier choices. |
| Settings, Platform, "On the command line this is" | The app offers seven platforms and the command line accepts four. I could not tell what happens to the missing three. | Say what to use for MGI or Element on the command line. |
| Settings, Quality Binning, "Rounds each base quality score to" | I understand rounding, but not what I lose. The benefit comes first and no cost is named until the third sentence. | State the cost right after the benefit. |
| Settings, Quality Binning, "Choose None when a downstream tool" | I do not know what a variant caller is at this point in the manual, and "models per-base error rates" is three technical words together. | Use a simpler example, or link the glossary. |
| Settings, Optimize storage, "Turn it off on a machine" | I do not know how much memory counts as "short". My laptop has 16 GB and I cannot judge. | Give a number, or say the app already decides safely. |
| Settings, Compression Tool, "Picks the program that does the" | "BBTools clumpify" and "Trim Galore --clumpify" are program names with odd punctuation. "--clumpify" looks like something I should type. | Say these are the labels shown in the popup. |
| Settings, Compression Tool, "It is resolved from the total" | "Resolved from ... against" is a construction I do not know. I could not tell who decides. | "LGE picks one based on file size and your memory." |
| Settings, "(recipe picker). Chooses which packaged workflow" | A setting whose name is in parentheses and lowercase. I could not match it to anything I would see on the sheet. | Give the control the label it actually shows. |
| Settings, "A plain FASTQ import offers three" | Three recipe names, none explained. I do not know whether any of them applies to my human sample. | One clause saying none of them fits a plain human import. |
| Reading the results, "The top pane holds one summary" | The contrast "not a row per file" assumes I expected rows. I did not, so the sentence spent effort on nothing. | Drop the contrast. |
| Reading the results, table row "Reads, Bases" | Two cards squeezed into one row with the values joined by "and". I had to count which number belongs to which card. | One card per row. |
| Reading the results, "The summary bar carries nine cards" | N50 is listed among the cards and printed in the table but never explained, though Mean Q and GC are. | Gloss N50 the way the others are glossed. |
| Reading the results, "Mean Length is the average read" | "Which the minimum of 35 bases confirms" points at a number that is not one of the nine cards and not in the table. I do not know where to see it. | Say where the minimum appears, or remove it. |
| Reading the results, "A Q30 figure below about 70%" | This is the only judgement threshold in the chapter. For Mean Q, GC, and N50 I still cannot tell good from bad. | Give a threshold for Mean Q and GC too. |
| Reading the results, "The Reads tab lists individual records" | I could not tell whether the 1,000-record limit is something I can raise or a permanent view. | Say whether more can be loaded. |
| Reading the results, "The quality charts stay empty until" | Earlier the chapter says import measures read length and quality. Now it says the quality charts are empty. These felt contradictory. | Distinguish the measured summary numbers from the charts explicitly. |
| Editing sample metadata, "For many samples at once, prepare" | This section is in the app part of the chapter but the only many-sample answer is a terminal command, and I have never opened a terminal. | Say plainly there is no in-app way to do many at once. |
| What good looks like, "Confirm the sample count. The configuration" | I had to work out myself why the count would be exactly twice. It is because each mate became its own bundle, but the sentence does not say so. | Add "because each file became its own bundle". |
| What good looks like, "Confirm that a re-import did what" | Another terminal answer inside a section otherwise about the app. I cannot tell whether I can replace a bundle without a terminal. | Say whether the app can replace a bundle. |
| On the command line, "The command line does the same" | I do not know what "runs the whole chapter" means. Do I type all four blocks in order? | Say these are four separate alternatives. |
| On the command line, code block "--project \"$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish\"" | The path has a dollar sign, quotation marks, and a space inside the folder name. I would not know how to change it for my own computer. | One line saying to replace the quoted path with your own project. |
| What a bundle holds afterwards, "For this fixture the two source" | Byte counts are hard for me to feel. I converted them in my head to about 18 MB and 6 MB. | Give megabytes alongside the bytes. |
| What a bundle holds afterwards, "A bundle can also be virtual" | This arrives with no warning and I cannot tell whether my import made one. Saying later chapters produce them does not answer for mine. | Say plainly that an imported bundle is never virtual. |
| What a bundle holds afterwards, "To write one back out as" | "Materialize" is used as a verb with no definition, and it is not in the chapter's glossary list. | Gloss materialize at first use. |

One thing I learned. A bundle is not a copy of my FASTQ files. LGE reads every record, measures the reads, records where they came from, and repackages them, so the thing in the sidebar carries information the original files never had.

One thing I still could not do. I could not manage metadata for many samples, or replace a bundle I imported by mistake, because both answers are terminal commands and this chapter never shows me how to open a terminal.

The sentence I liked most. "The bundle records all three, so six months later the reads still know what they are."
