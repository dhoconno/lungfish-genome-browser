# Reader report: Reading the Variants Table

Reader 4. Undergraduate. I used Geneious in one class for assembling Sanger reads and looking at a couple of alignments. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A variant caller writes its answer..." | I know what a variant is from genetics but I have never seen a VCF. In Geneious the variants just appeared in a table and I never saw a file. The sentence says the file is tab-separated text, but I do not know whether I am ever supposed to open it myself. | One sentence saying you never open the VCF by hand in LGE. |
| What it is, "The drawer starts 250 points tall" | I do not know what a point is. Is that pixels? | Give the size in a way I can picture, such as a fraction of the window. |
| What it is, "Two sibling tabs share the same drawer." | "Sibling" made me stop. I thought it meant the tabs were related in some special way. | Say "Two other tabs sit in the same drawer." |
| What it is, "There is no free-text box to type" | This was helpful but it made me anxious. In Geneious I always used the little search box. I did not learn what replaces it until step 5. | Point forward to the Search Builder in the same sentence. |
| Why you would do this, "The HG002 chromosome 20 slice" | I did not know what HG002 is or why it is well studied, and it sounded like it mattered. | Half a sentence saying it is a reference person whose true genome is known. |
| Why you would do this, "mapped to a 500 kb stretch" | I had to work out that kb means kilobases, then that 500 kb is the same as the "half-megabase" used two paragraphs later. | Use one unit throughout. |
| Why you would do this, "once with bcftools and once" | I do not know what makes these two callers different or why anyone would run both. The first real difference comes only in step 6. | One sentence here on how the two differ. |
| Before you start, "Follow Calling Variants first." | I read this chapter cold and have not done the previous one, so I could not perform any of the six steps. I also do not know how long that chapter takes. | Say roughly how long the prerequisite takes to run. |
| Before you start, "No plugin pack is needed" | I do not know what a plugin pack is. It is not explained in this chapter. | Gloss it, or just say nothing needs installing. |
| Step 1, "Check the Operations panel with Operations" | I do not know what the Operations panel is, or what a still-running job looks like there versus a failed one. | One sentence saying it is the list of jobs LGE is running. |
| Step 2, "Seven of them are the VCF's own standard" | The table below has only six rows, because Ref and Alt share one. I spent a while trying to find the seventh. | Give Ref and Alt their own rows, or note that six rows cover seven columns. |
| Step 2, "The remaining six carry Filter, which is" | One very long sentence describing six columns at once. I read it three times. The table above it was far easier. | Put these six in the same table as the first six. |
| Step 2, "which is the caller's own verdict on the row" | I did not know what a verdict means for a variant until step 4 explained PASS and the dot. Here it meant nothing. | Say "whether the caller judged the call good enough" at this point. |
| Step 2, "LGE's own iVar output writes a bare" | iVar has not appeared before and I do not know what it is or whether I would ever use it. | Gloss iVar, or leave it out since this fixture does not use it. |
| Step 2, "the table adds a column for each INFO key" | I do not know what an INFO key is. The glossary link only appears later, in step 3. | Gloss INFO where it first appears. |
| Step 2, "declares sixteen INFO keys including DP, DP4" | Four abbreviations with no explanation. I only learned DP means depth much later. | Expand at least DP and MQ here. |
| Step 3, "the dense INFO string the table squeezes" | I could not picture this because I have never seen an INFO string. | A two-word example of what one looks like. |
| Step 3, "so VoiceOver announces the focused cell" | I do not know what VoiceOver is. | Say it is the macOS screen reader. |
| Step 4, "High Impact, Moderate+, and ClinVar Path." | I do not know what impact levels are, what moderate means, or what ClinVar is. The next paragraph says these chips will not appear here, so I never got to find out. | One sentence each on impact and ClinVar. |
| Step 4, "The three frequency chips appear only for" | This says a human fixture never shows them because they need a haploid organism. But the Settings section says Auto "gets a human fixture and a viral genome right", which sounds like humans do work. I could not reconcile the two. | Say plainly whether a human sample can ever show these chips. |
| Step 4, "Het Only is unavailable on every track today" | If it never works anywhere, I do not know why it is in the list. I hunted for it before reading on. | Say it is not implemented yet. |
| Step 4, "Three sets behave like radio buttons inside" | I half know what a radio button is, and "inside themselves" made it worse. | Say "picking one clears the other in the same group." |
| Step 4, "a default bcftools run applies no hard filter" | I do not know what a hard filter is, or what a soft one would be. | Drop "hard", or explain it. |
| Step 5, "and the three population-database frequency" | These are not named, so I would not recognise them in the sheet. | Name them. |
| Step 5, "A Location rule takes only `=`, because a" | I could not follow why a range needs an equals sign. It reads like a contradiction. | Say the equals sign here means "inside this range". |
| Step 5, "that leaves 512 rows out of the 574 in that" | The 574 arrives from nowhere and I have no way to check it, since I do not know how to count rows in a window. | Say where the 574 comes from. |
| Step 5, "zoom the viewport in below 10 Mb" | I do not know how to zoom the viewport. Nothing in this chapter says how. | Cross-reference the chapter that covers zooming. |
| Step 6, "The tick colors on the genome track above" | I never noticed a genome track with ticks, and the chapter has not introduced it. I am guessing from Geneious that it is marks on the sequence. | Introduce the genome track before warning me about it. |
| Step 6, "Coordinate 250527 shows the shape of a" | I do not know how to get to a specific coordinate. Do I scroll, or type it somewhere? | Say how to jump to a coordinate. |
| Step 6, "allele depths of 20 reference reads and 33" | 20 plus 33 is 53, but the same sentence says the depth is 63. I checked twice and could not account for the ten missing reads. | Explain why allele depths do not sum to the depth. |
| Step 6, "reports `AF=0.571429` instead" | I do not know where in a row I would find this. Is AF a column, part of the INFO string, or only in the Inspector? | Say which column or panel shows it. |
| Settings, "shortens its label to GT" | I did not know GT meant genotype here. The glossary link for genotype was back in step 3. | Spell out GT at this point. |
| Settings, "Qual >= 30" versus step 4's "Qual ≥ 30" | The same chip is written two ways and for a moment I thought they were two different chips. | Use one form throughout. |
| Settings, "Auto / Haploid / Diploid." | This control never appears in the six-step procedure, so I did not know where in the toolbar to find it or when I would touch it. | Mention it in step 4 alongside the frequency chips. |
| Reading the results, "a logarithmic scale where 30 means" | I understood this, then "The two callers put their scores on scales that cannot be compared" undid it. If both are Phred, why can they not be compared? | One sentence on why the same scale is not comparable across callers. |
| Reading the results, "The bcftools rows run from 4.5 to" | I do not know how to get these numbers out of the table. Do I sort and count by hand? | Say whether these come from sorting or from a filter. |
| Reading the results, "623 rows reading `0/1` and 415 reading" | 623 plus 415 is 1,038, but the track has 1,056 rows. Eighteen rows are unaccounted for. | Say what the other eighteen rows are. |
| Reading the results, "339 at or above 0.8, 517 between" | These add to 862, which I could check and appreciated. But I do not know how to produce the three groups in the app, since the frequency chips never appear on a human fixture. | Say where these counts come from. |
| What good looks like, "roughly one difference every 470 bases" | 500 kb over 1,056 rows is about 473, but humans are said to differ at one base in a thousand. One in 470 is twice that, and I could not tell whether that is fine or a warning. | Say plainly that a factor of two is expected. |
| On the command line, "This section is optional." | I was relieved, but the counts in Reading the results look like they come from these commands, so I could not verify anything without doing the optional part. | Say whether those counts need the command line. |
| On the command line, "The plain clause keys the Search Builder" | The grammar I learned in step 5 is refused by the flag. I understand the sentence but not why the manual taught me a language the command rejects. | Say up front that the two use different filter languages. |
| On the command line, `BUNDLE="MyProject.lungfish/Reference` | I have never opened a terminal. I do not know where to type this, what the quotes do, or how to find that path on my computer. | A pointer to whichever chapter introduces the terminal. |
| On the command line, `--filter 'Sample[HG002].GT=1/1'` | I do not know where the sample name HG002 comes from or how I would find mine. | Say the sample name is the one shown in the Samples tab. |
| On the command line, "bcftools view -H hom-alt.vcf" | Two commands I have never seen, joined by a symbol I do not know. The comment says it counts, but I cannot tell which half does the counting. | A note that this line is only a count and can be skipped. |
| Next, "Continue to Nanopore Variant Calling" | The link is numbered 04 and this chapter is 02, so I wondered whether I had skipped a chapter 03. | Say what 03 is, or link it. |

The one thing I learned: an empty table after a filter can mean the file was never judged rather than that everything failed, and the bare dot in the Filter column is what tells you which.

The one thing I still could not do: reproduce any of the row counts in this chapter from the app myself, because the counting method is never shown and the command-line section is marked optional.

The sentence I liked most: "Read a bare `.` as unjudged rather than as failed, look at the column before you filter on it, and use **Clear** to bring the rows back."
