# Reader report: Running Kraken 2

Reader 4. Undergraduate. I used Geneious in one class. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is — "It then reads off the run" | I read this twice. I thought "run" meant a run of the program, but here it seems to mean a stretch or series. | Use "series" instead of "run" in this sentence. |
| What it is — "assigns the read to whichever taxon" | This is the whole point of the tool and it stays vague. What decides "will support"? | Say the read goes to the taxon holding the most matching minimizers. |
| What it is — "Bracken re-estimates how abundant" | I do not know what abundance means as a number here. A count of reads? A percentage? | Say abundance means the fraction of the sample each species made up. |
| What it is — "So what should you do with" | "Run it as a screen" is jargon to me. In my class a screen was a genetic screen with plates. | Say "run it as a first look, not as proof". |
| Why you would do this — "You have a low-yield run" | Host is not glossed at this first mention even though it is linked much later. I guessed it means the human the swab came from. | Gloss host DNA here. |
| Why you would do this — "This chapter works through the SRR36291587" | Here it says 86,281 read pairs, but later the chapter says 85,199 twice. I could not tell whether I misread. | Say why the number drops from 86,281 to 85,199. |
| Before you start — "The reads themselves are too large" | I do not know how big this download is or how long it takes, so I could not decide whether to start it before lab. | Give the approximate download size and time. |
| Before you start — "Kraken 2 and Bracken both ship" | I could not tell whether installing a plugin pack takes seconds or an hour, and the chapter never says. | Say roughly how long installing Metagenomics takes. |
| Step 1 — "Open Tools > Plugin Manager... (Cmd-Shift-B)" | I did not know which of the nine collections to pick beyond the two the chapter names, and the full table is in another chapter I have not read. | Name in one line what makes a collection worth choosing. |
| Step 1 — "up to the seventy-two-gigabyte PlusPF" | PlusPF is never expanded anywhere in this chapter. | Expand PlusPF once. |
| Step 1 — "Read the banner at the top" | I do not know how much memory my Mac has or how to find out, and the step assumes I do. | Say the banner does this for you and you need not look it up. |
| Step 1 — "The row turns to read Installed" | "Pinned build" means nothing to me. Pinned by whom? | Gloss pinned build at first use. |
| Step 2 — "Click the FASTQ bundle holding the" | I do not know what a bundle looks like in the sidebar or how to tell it apart from a folder. In Geneious everything was a document. | Say what icon or label marks a FASTQ bundle. |
| Step 2 — "Read the dataset line at the" | I could not work out how LGE knows which two files are mates. It matters if my filenames are unusual. | Say it matches the _1 and _2 in the filenames. |
| Step 2 — "Leave Sensitivity on Balanced and Advanced" | I had to read this twice to see it means the preset fills in the advanced numbers for me. | Split into two sentences. |
| Step 2 — "If you selected more than one" | I could not tell whether a multi-sample batch gives me one result folder or several. | Say how many result folders a batch produces. |
| Step 3 — "Click Run. The dialog closes" | The Viral run took 2.6 seconds, so Standard-16 on my laptop must be minutes, but the file-cache note gives me no number. | Give a rough worst-case time for a first Standard-16 run. |
| Step 3 — "Now repeat the dialog with Standard-16" | This is one sentence for a whole second run. I was not sure whether to reselect the bundle first. | Say to reselect the bundle before reopening the menu. |
| Step 4 — "Then run the extraction." | The button is not named. Everywhere else the chapter names the button. | Name the button. |
| Settings — "Confidence:. Sets how much of a" | I could not judge whether 0.20 is strict or loose until I read the preset table much further down. | Say 0.20 means one fifth of the read's k-mers must agree. |
| Settings — "Min hit groups:. Sets how many" | I could not picture a hit group. Is it a stretch of bases? How long? | Say a hit group is a run of neighbouring k-mers hitting the same taxon. |
| Settings — "Memory mapping:. Reads the database from" | If the dialog ticks the box for me, I do not know when I would ever tick it, and the entry tells me to. | Say plainly you rarely tick this yourself. |
| Settings — "Bracken. Adds a column of read" | This is listed among viewport controls but then says I do not control it. I was confused why it is here. | Say up front it is a column, not a control. |
| Settings — "Column header filter. Restricts one column" | I did not know a column header had a menu, or how to open it. | Say to click the small arrow in the header. |
| Settings — "Destination:. Chooses where the extracted reads" | I did not know whether the 10,000 limit is read pairs or read records, which differ by two elsewhere in the chapter. | Say pairs or records. |
| Reading the results — "The viewport shows the same tree" | The percent column is unnamed here and the tables below just say Percent. I did not know if it is clade percent or direct percent. | Name the percent column. |
| Reading the results — "Viruses domain 83,728 65 98.27" | Viruses is given the rank "domain" but in my genetics class viruses were not in a domain. This made me doubt the table. | Add a half-sentence that this is how the database's taxonomy labels it. |
| Reading the results — "Read it downward. Every level carries" | I checked 83,728 divided by 85,199 and got 98.27, so percentages are of pairs, but the extraction section counts records. I lost track of which unit each number uses. | State once that all counts in this chapter are read pairs. |
| Reading the results — "The species row above it is" | I had never seen *Betacoronavirus pandemicum* and could not tell whether it was a typo until the next sentence. | Move the explanation ahead of the table. |
| Moving around the tree — "A single click on a wedge" | I did not know whether the chart has to be clicked first for Escape and Cmd-0 to work. | Say the chart must have focus. |
| Moving around the tree — "The action bar above the viewport" | I could not find where the information button is from the text alone. Beside what? | Say where on the action bar it sits. |
| A different database — "The same 85,199 read pairs went" | Earlier PlusPF was seventy-two gigabytes and here Standard is seventy. Two different seventy-ish numbers confused me. | Give the full Standard size once. |
| A different database — "Species reported 1 1" | Standard-16 named 3,320 reads but only 2,602 SARS-CoV-2 reads and still one species. I could not work out what the other 718 reads were. | Say what the remaining classified reads were assigned to. |
| Sensitivity preset — "Sensitive 85,181 (99.98%) 18 (0.02%)" | The table says 5 species and the prose says four extra. I had to add them to check they agreed. | Say "five, being the same one plus four more". |
| Sensitivity preset — "One is *Sinsheimervirus phiX174* with 5" | phiX is used as if familiar. I have never heard of it and the gloss is only for spike-in control. | Add three words saying phiX is a small bacterial virus. |
| What good looks like — "A high share means the database" | I had to read this twice. "Denominator" sent me back to maths class rather than to the report. | Say the percentages are shares of only the reads that matched. |
| What good looks like — "A handful of reads against an" | I do not know where my sample falls if I have two hundred reads, and the chapter says the honest answer is you do not know. | Give one worked cutoff even if it is rough. |
| What good looks like — "It is not a BLAST e-value" | I have not read the BLAST chapter yet, so comparing to something I do not know did not help me. | Compare to something explained in this chapter instead. |
| On the command line — "The whole procedure runs headless." | I have never opened a terminal, so I skipped this, but I could not tell whether anything in it was information I needed for the app. | Add a line saying GUI readers can skip this section. |
| On the command line — "That last flag matters, because the" | This felt important enough that I worried the app might be quietly doing other things differently too. | Say this is the only difference between the two routes. |
| On the command line — "When the database matches nothing at" | "Exits with status 64" means nothing to me. | Drop the number or say it is an error code for scripts. |
| Next — "Continue to Running EsViritu for a" | After a chapter about the wrong database ruining a run, I could not tell when to choose EsViritu over Kraken 2. | Say in one line when EsViritu is the better choice. |

One thing I learned. A classifier can only ever report organisms that are in its database, so a report that is 96% unclassified is telling me about the database and not about my sample.

One thing I still could not do. Judge a low-abundance hit of a few hundred reads, because the chapter gives me a handful and a few thousand as anchors and nothing in between.

The sentence I liked most. "It is not an error and it is not noise. It is the classifier telling you where its knowledge ran out."
