# Reader 3 report

Persona. Pre-med student, English is my second language, strong on biology
words from textbooks, slow on idioms and long sentences, never opened a
terminal.

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "built by SecureBio for wastewater" | SecureBio is never explained. Is it a company, a university lab, a government group? I do not know whether to trust the pipeline or how to cite it. | Add four words saying what SecureBio is. |
| What it is, "screens every read against a broad reference collection" | "Broad reference collection" is not defined here, and the whole chapter later depends on it (the boundary section says a virus absent from it cannot appear). I could not tell what is in it. | Say once what the collection contains. |
| What it is, "The pipeline's main output is a table" | I do not know what a pipeline is in this context. I guessed it means a chain of programs, but nobody told me. | Gloss "pipeline" at first use. |
| What it is, "give it a viewport, which is this manual's word" | The gloss arrives inside the same sentence as three other ideas, and the sentence runs 44 words. I read it twice. | Split the viewport definition into its own sentence. |
| What it is, "`virus_hits_final.tsv.gz`" | TSV and .gz are never explained. I have seen .csv in a class but not .tsv, and I do not know if .gz means I must unzip it first. | Say what a gzipped tab-separated table is at first use. |
| What it is, "there is no `samples/` folder, `metadata.tsv`, or `manifest.json` structure to assemble first" | This tells me what does not exist. Since I never saw those things, the sentence gave me new unfamiliar words and no new ability. | Cut, or say plainly that no folder preparation is needed. |
| What it is, "So what should you do with this?" | The question is addressed to me but I have no way to answer it. It reads like a rhetorical device rather than instruction. | Replace with a direct statement. |
| Why you would do this, "that is the wrong shape for the question" | "Wrong shape" is a metaphor. A table does not have a shape to me. I stopped here. | Say the table is organised per read, not per organism. |
| Why you would do this, "Thirty columns wide, one row per matching read, split across every sample" | This is not a full sentence and it has no verb. I read it three times looking for the missing part. | Make it a complete sentence. |
| Why you would do this, "its own bit score, edit distance, and reference position" | "Edit distance" and "reference position" are never glossed and are not in the glossary list at the top. Bit score is linked, the other two are not. | Gloss edit distance, or drop it. |
| Why you would do this, "Ten reads that are ten copies of one amplified fragment" | This is the most important idea in the chapter and I only understood it after the PCR sentence much later in Reading the results. "Amplified" is used before PCR duplicates are explained. | Explain PCR duplication here, at first use. |
| Why you would do this, "chased down without leaving the window" | "Chased down" is an idiom. I understood it only from context after rereading. | Use "investigated". |
| Why you would do this, "hand-writing a query against the pipeline's table" | I have never written a query and do not know what one is. This makes the benefit invisible to me. | Say "without writing your own analysis code". |
| Before you start, "an NAO-MGS wastewater run covering five sampling sites" | "Run" is used here for a sequencing run, but the chapter also uses "run" as a verb constantly. I was not sure whether five sites means five files or one file. | Say the run produced one combined table covering five sites. |
| Before you start, "produced by an external `securebio/nao-mgs-workflow` run" | I cannot get this file. The chapter admits there is no public fixture. So I cannot perform any step in the Procedure. | Say up front that this chapter is read-only unless you have your own file. |
| Before you start, "the figures quoted below come from a five-sample surveillance run" | I cannot check any number in the chapter against anything. Every count later (35, 4, 12, 8, 28, 26) is unverifiable for me. | Keep, but flag which numbers are illustrative. |
| Before you start, "no plugin pack, no conda environment, and no Docker container is involved" | Three terms I do not know, all in one sentence, used to tell me nothing is needed. It made me worry those things exist elsewhere. | Say only that nothing needs installing. |
| Procedure 1, "each card is also a drop target" | I do not know what a drop target is. I guessed drag and drop but was not sure. | Say you can drag a file onto the card. |
| Procedure 1, "carries an NM badge" | I do not know what NM stands for or whether I need it to identify the card. | Expand NM once. |
| Procedure 2, "It holds no settings at all, only a source picker and a validation readout" | Then the Settings section describes three settings. I was confused about whether the sheet has settings or not until I read the Settings section twice. | Cross-reference the Settings section here. |
| Procedure 2, "truncated in the middle when it is long" | "Truncated" is a word I had to look up. | Say "shortened with dots in the middle". |
| Procedure 2, "recognisable NAO-MGS virus-hits table" | I cannot tell from the text what makes a header recognisable, so if the warning triangle appears I would not know what is wrong with my file. | Name what the header must contain. |
| Procedure 2, "When the run wrote one file per sequencing lane" | "Sequencing lane" is never explained. I do not know if my file is one lane or many, so I do not know if I will see this row. | Gloss lane, or say this row appears sometimes. |
| Procedure 3, "Commit the import." | This is the only instruction and it does not tell me what to click. Every other step names a button. I could not perform this step. | Name the button on the sheet. |
| Procedure 3, "partitions the table by sample, imports each sample in turn, merges the per-sample databases, and resolves the numeric taxonomy identifiers" | Four technical actions in one sentence, before taxonomy identifier is defined in the next sentence. I read it twice. | Split, and define taxonomy identifier before using it. |
| Procedure 3, "named `naomgs-<sample>` after the first sample" | Later the CLI output shows `naomgs-virus_hits_final`, which is a file name, not a sample name. These two contradict each other for me. | Reconcile the two examples. |
| Procedure 3, "the import reported 35 hits across 4 distinct taxa" | I have no idea whether 35 is a lot or a little for a wastewater run. The chapter never gives me a scale. | Say what a typical range looks like. |
| Procedure 3, "SQLite is a small self-contained database format" | Good gloss, but it arrives after the sentence that already used it. I stopped at the first use. | Gloss before use. |
| Settings, "The three settings below therefore exist only on the command line" | I have never opened a terminal. So this whole section is unusable to me, but it sits in the middle of the chapter before Reading the results, not in the optional command line section at the end. | Move to the command line section, or mark it optional. |
| Settings, Fetch references, "The registry records reference fetching as on by default" | "The registry" appears once, with no explanation. I do not know what it is or why it decides defaults. | Say "it is on by default". |
| Settings, Fetch references, "when the run names hundreds of accessions" | I cannot judge hundreds. Is my five-site run tens or hundreds? Nothing tells me. | Say roughly how many accessions a typical run names. |
| Settings, Output directory, "It defaults to the current directory, which is almost never what you want" | "Current directory" means nothing to someone who has never used a terminal. | Gloss, or move with the section. |
| Reading the results, "A summary bar runs along the top, the detail pane fills the left side" | The screenshot caption at the top of the file says the bar chart fills the detail pane and the table is on the right, but I cannot picture left and right until I see the image, and the image is not there. | Keep, but the figure is essential here. |
| The summary bar, "reads \"N of M samples\"" | N and M are algebra placeholders. I worked it out but it stopped me, and the app shows real numbers. | Show a real example such as "2 of 5 samples". |
| The summary bar, "it is easy to miss because it is the only control on that row" | This says the interface has a usability problem. I was not sure if I should look harder or if something is broken. | State plainly where the button sits. |
| The taxon table, "falling back to `Taxid N` when the lookup found no name" | "Falling back" is an idiom. Also I do not know whether an unnamed taxon means my data is bad. | Say "shows Taxid N instead" and say it is normal. |
| The taxon table, "right-click a header to filter on that column's values" | I could not perform this. It does not say what the filter looks like or how to clear it. | Add one sentence on clearing a filter. |
| The taxon table, "loaded per-sample metadata through the Inspector's Import Metadata..." | The Inspector is never introduced in this chapter. I do not know where it is. | Say where the Inspector is, or cross-link. |
| The taxon table, "12 hits from 8 unique reads, meaning a third of the evidence was duplicate" | I checked. 12 minus 8 is 4, and 4 of 12 is one third. But the sentence says "a third of the evidence", which I first read as 8 being a third. I had to do arithmetic to trust it. | Say "4 of the 12 hits were duplicates". |
| The taxon table, "which is a much stronger claim from a similar-looking count" | 12 and 28 are not similar-looking counts to me. I could not follow the comparison. | Compare the ratios, not the counts. |
| The taxon table, "the taxon is leaning on a small number of fragments" | "Leaning on" is an idiom. | Use "is supported by". |
| The detail pane, "then draws a Top Taxa by Read Count bar chart of the top fifteen taxa" | The example run has only 4 taxa. So I would never see fifteen bars and wondered if something was wrong. | Say the chart shows up to fifteen. |
| The detail pane, "It does not plot a time series, because one import is one run" | I did not expect a time series, so this defence confused me into thinking I had missed a feature. | Cut, or say surveillance trends need several imports. |
| The detail pane, "`Taxid 28875  •  26 unique / 28 total reads  •  7 accessions`" | Earlier the same organism was given as 12 hits from 8 unique, then 28 from 26. Now a third pair, 26 of 28. I could not tell if these are the same row or different ones. | Use one consistent example throughout. |
| The detail pane, "reading `All: 3 of 3 accessions` ... and `Top 5: 5 of 12`" | Nothing says what decides between All and Top 5, or whether I can raise the cap. | State the threshold. |
| The detail pane, "Drag a panel's handle downward" | I do not know what the handle looks like or where it is. | Say where the handle sits. |
| The action bar, "submits a sample of the selected taxon's reads" | "A sample" here means a subset of reads, but the whole chapter has used "sample" to mean a wastewater collection site. I read it twice with the wrong meaning. | Use "a subset". |
| The action bar, "the export records those choices in its own provenance sidecar" | "Sidecar" is a metaphor I did not understand at all. | Say "a companion file". |
| The action bar, "That is the route to taking a candidate signal somewhere else" | "The route to" is figurative and the sentence names three destinations I do not know how to use. | Simplify to one plain sentence. |
| What good looks like, "a row whose unique count is under half its hit count" | Just above, the chapter says there is no threshold and this is a judgement, then immediately gives me a threshold. I could not tell whether half is a rule or not. | Pick one framing. |
| What good looks like, "one organism appearing in several independent samples is a stronger observation than the same total spread over one" | I read this three times. "The same total spread over one" is very compressed and I still am not certain what it means. | Rewrite as two short sentences. |
| What good looks like, "Reads stacked on one short stretch are what a conserved region shared with a relative looks like" | I know what a conserved region is from my textbook, but I could not tell how to judge "one short stretch" by eye in the pileup. No number, no picture. | Say roughly how much of the reference should carry reads. |
| What good looks like, "what the name commits you to" | "Commits you to" is figurative and I did not understand it until the end of the paragraph. | Use "what the name does and does not prove". |
| What good looks like, "`Cressdnaviricota sp.`, an unclassified member of a large viral phylum" | The gloss is good but the name is unpronounceable and the point would land with any broad name. | Keep the gloss, it helped. |
| What good looks like, "A handful of reads is a lead, not a result." | "A handful" and "a lead" are both idioms. I understood "lead" only from crime shows. | Say "a few reads suggest something to check". |
| On the command line, "This section is optional." | Good, but the Settings section earlier was also command-line only and was not marked optional. | Mark the Settings section the same way. |
| On the command line, "The input is a positional argument rather than a flag" | Positional argument and flag are terminal vocabulary I do not have. | Gloss both, or accept this section is not for me. |
| On the command line, "it printed one sample name, 34 hits, and blank Organism cells, while the project importer ... found five samples, 35 hits" | 34 versus 35 is a one-hit difference and I could not work out where the missing hit went, or whether 34 is the first sample's count. | Explain the one-hit gap. |
| On the command line, "`--min-bitscore`, which drops hits below a bit-score floor and defaults to 0" | I cannot judge what bit score is high or low, so I would not know what number to put. | Give one example value. |
| On the command line, "MU-CASPER-2026-03-31-a-IL_CHI_StickneyWS_20260308" | This identifier is 45 characters and I cannot tell which part I would change for my own data. | Break down the parts, or shorten. |
| On the command line, "It does not work against a result the importer produced ... exits with `The extraction produced zero reads`" | A long paragraph describing a route that never works. I read it twice trying to find the case where it does work. | Say in one sentence not to use it. |

The one thing I learned. Two reads that are copies of the same amplified
fragment count twice but are only one piece of evidence, so the unique-read
column matters more than the hit count.

The one thing I still could not do. Perform the Procedure at all. I have no
`virus_hits_final.tsv.gz` and the chapter says none is available to download,
and step 3 never names the button that starts the import.

The sentence I liked most. "A read is one fragment of sequence the instrument
reported, a few hundred bases long."
