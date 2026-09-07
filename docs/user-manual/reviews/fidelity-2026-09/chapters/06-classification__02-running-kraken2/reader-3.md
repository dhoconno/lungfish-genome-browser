# Reader report: Running Kraken 2

Reader 3. Pre-med student, English is my second language. I have taken genetics.
I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Kraken 2 slides a window along..." | I do not know what a sliding window is here. How wide is it? The sentence assumes I can picture it. | One clause saying a window is a fixed number of neighbouring bases the tool looks at before moving one base along. |
| What it is, "It then reads off the run..." | "Reads off the run of taxa" uses "read" and "run" in senses different from the ones defined two sentences earlier. I read it three times. | Say "It then looks at the list of taxa the read's minimizers point at." |
| What it is, "assigns the read to whichever taxon..." | "Whichever taxon those matches will support" is vague. Support by what rule? A majority? All of them? | Name the rule in half a sentence, or say the next paragraph explains it. |
| What it is, "It is also why the tool..." | "A point the whole rest of this chapter turns on" is idiomatic. I first read "turns on" as switching something on. | "a point the rest of this chapter depends on". |
| What it is, "It does mean that a Kraken..." | Later in the same section "where Kraken 2 parked its reads" uses "parked" as slang. It returns again in Reading the results. | Say "left" or "placed". |
| What it is, "So what should you do..." | The paragraph explains what the tool is and then asks me a question. I did not know whether I was supposed to answer it. | Delete the question and state the advice directly. |
| Why you would do this, "You have a library you believe..." | "A mislabelled tube and a cross-contaminated plate look identical" assumes I know what a plate is in sequencing. Plate of what? | Gloss the 96-well plate once, since it is not obvious from a genetics course. |
| Why you would do this, "This chapter works through the SRR36291587..." | Four unglossed terms in one phrase. QIAseq Direct, paired-end, Illumina, read pairs. Only amplicon is linked. | Gloss "paired-end read pair" here, since the whole chapter counts in pairs. |
| Why you would do this, "This chapter works through the SRR36291587..." | It says 86,281 read pairs, but the Procedure and every table say 85,199. I could not tell which number is the sample. | Say once why the number changed, or use one number throughout. |
| Before you start, "You need a project open..." | "Cmd-N" appears with no explanation. I did not know whether it is something I press or something on screen. | One line stating that Cmd-something means a keyboard shortcut. |
| Before you start, "Kraken 2 and Bracken both ship..." | "Private conda environments" is not explained. I could not tell whether this needs internet or costs disk space. | Say in one clause that LGE downloads them and keeps them inside the app. |
| Step 1, "Read the banner at the top..." | It tells me memory is what matters, but I do not know how to find how much memory my Mac has. | Say the banner already made this check so I do not need to look it up. |
| Step 1, "Read the banner at the top..." | "The binding constraint" is economics vocabulary, not biology vocabulary. | "the limit that matters". |
| Step 1, "Download a second, broader collection..." | I am told to choose Standard-8 or Standard-16 "depending on your memory" but not given the rule for choosing. | "Pick whichever one the banner recommends." |
| Step 1, "The row turns to read Installed..." | "Whether a newer pinned build exists" uses "pinned", which is never glossed and returns in the Update setting. | Gloss pinned once, meaning the exact version LGE was tested against. |
| Step 2, "Open Tools > Classification > Kraken2..." | "That is the title of the dialog window rather than a menu" corrects a mistake I had not made yet, so it created confusion instead of removing it. | Cut it, or move it to a note. |
| Step 2, "Leave Sensitivity on Balanced..." | "Disclosure" as the name of a screen part is new to me. I know the word only as revealing information. | Call it "the Advanced Settings section". |
| Step 2, "If you selected more than one..." | One sentence carries batches, a single Operations Panel entry, a merged summary, and per-sample abundance. I lost the subject halfway. | Split it into two sentences. |
| Step 3, "Click Run. The dialog closes..." | "The operating system's file cache" is not explained, so I could not judge how much slower my own first run would be. | Say only that the first run takes noticeably longer. |
| Step 4, "In the dialog that opens..." | "Each of those three labels carries a trailing colon on screen" told me something about typography when I was trying to do a task. | Keep this note in the Settings section only. |
| Settings, "The classification dialog carries these eight..." | The bold labels written as "Confidence:." with a colon and then a period looked like a typing error and stopped me at every entry. | Explain the convention once at the top of Settings. |
| Settings, "Confidence:. Sets how much of a read..." | It says a failing read is "pushed up to a broader group or left unclassified", two different outcomes, without saying which happens when. | Say which outcome is the usual one. |
| Settings, "Min hit groups:. Sets how many separate..." | I followed the logic but never learned what a hit group physically is on a read. | "a hit group is one continuous stretch of matching k-mers". |
| Settings, "Memory mapping:. Reads the database from disk..." | If the dialog ticks the box for me when I pick a large database, I could not tell when I would ever set it myself. | State plainly that you rarely need to touch it. |
| Settings, "Bracken. Adds a column of read counts..." | It is listed among settings but ends "You do not control this one". I did not know why it was there. | Say at the start of the entry that this describes a column, not a control. |
| Settings, "Destination:. Chooses where the extracted reads go..." | "A tooltip telling you to pick another destination". I do not know what a tooltip is. | "a message appears when you hover over it". |
| Reading the results, "Two of those columns are easy..." | "Reads is the clade count" uses clade before defining it. I only guessed the meaning from the definition that follows. | Put the two-word gloss inline. |
| Reading the results, "| Betacoronavirus pandemicum | species |" | The table gives SARS-CoV-2 the rank subspecies. I have never seen a virus ranked below species and assumed the table was wrong. | One clause saying the reference taxonomy ranks the named strain below the species. |
| Reading the results, "The row that is not in that table..." | "No match the database and the confidence threshold would both accept" has no comma. I parsed it as one thing and read the sentence four times. | "no match that both the database and the confidence threshold would accept". |
| Moving around the tree, "A single click on a wedge..." | "Cmd-0 jumps straight back to the root". Same problem as Cmd-N, and here it sits beside Escape, which is a key, so I had to infer the pattern. | The same shortcut convention line as above. |
| Moving around the tree, "Right-clicking a taxon offers Extract..." | Copy Taxonomy Path sounds like it copies a path of names, but the command-line section says it puts a numeric identifier on the clipboard. | Say what the copied text actually looks like. |
| The same reads a different database, "| Species reported | 1 | 1 |" | Standard-16 named only 3,320 reads yet reported the same single species. I could not tell whether that is reassuring or a coincidence. | One sentence saying what to conclude from that row. |
| The same reads a different database, "The lesson generalises past this fixture..." | "The loss falls hardest on whatever the sample is actually full of". I could not follow why capping hurts the abundant organism most rather than the rare one. | One clause of reasoning. |
| Sensitivity preset, "| Sensitive | 85,181 (99.98%) |" | The table says 5 species and the prose says four extra species. I had to do the arithmetic before I trusted either. | "five in total, four more than Balanced". |
| Sensitivity preset, "The other three are one read..." | The chapter declares these three false but never says how that was determined, so I could not make the same judgement myself. | Say the judgement came from BLAST, or from the single-read counts. |
| What good looks like, "Read the unclassified share first..." | "Proportions of the wrong denominator" is statistics phrasing. I know what a denominator is but not what a wrong one means for a report. | "percentages of only the few reads it recognised". |
| What good looks like, "Then scan the long tail..." | "Hold it to a rule you set before you looked". I did not know what kind of rule or how to write one. | Give one example rule in the same sentence. |
| What good looks like, "Finally, remember what Kraken 2 confidence..." | E-value is used with no gloss. I have heard of BLAST but never of an e-value. | Gloss e-value in five words. |
| On the command line, "The whole procedure runs headless..." | I have never opened a terminal, and nothing says I may skip this section, while every Settings entry sent me here. | One line at the start saying the section is optional. |
| On the command line, "One failure is worth knowing..." | "Exits with status 64". I do not know what an exit status is or where I would see one. | Cut the number, or say it appears in the error message. |
| On the command line, "--taxon takes the numeric taxonomy..." | The example uses 2697049, but nothing earlier showed me a number for SARS-CoV-2, so I could not find my own. | Say where the identifier is shown in the app. |

What I learned: a classifier can only ever name something already present in its
database, so a high unclassified share is a statement about the database rather
than about my sample.

What I still could not do: choose between Standard-8 and Standard-16 for my own
Mac, because I do not know how to find how much memory my Mac has and the chapter
never told me.

The sentence I liked most: "It is the classifier telling you where its knowledge
ran out."
