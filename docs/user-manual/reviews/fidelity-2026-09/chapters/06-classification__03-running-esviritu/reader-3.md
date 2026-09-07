# Reader report: Running EsViritu

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The collection EsViritu compares against..." | "curated viral assemblies" is two unknown words at once. I know "genome" but not "assembly", and "curated" I only know from museums. | Say what an assembly is at first use. |
| What it is, "so it can find a virus in..." | "in fine detail" against "cannot find a bacterium at all" made me read twice. At first I thought EsViritu was failing at something. | Say plainly that the narrow database is a deliberate choice. |
| What it is, "Kraken 2, the classifier the previous..." | "chopping each read into short words" confused me. A read is letters A T G C, so I did not know what a "word" means here. | Say the word is a short fixed-length piece of the sequence. |
| What it is, "The first is what a genuine..." | I do not know "off-target PCR product". PCR I know from lecture, but not what makes a product off-target. | Gloss off-target PCR product at first use. |
| What it is, "The second is what a shared..." | I could not tell why PCR duplicates are bad. The chapter treats it as obvious. | One sentence saying duplicates are copies of the same original molecule, so they are not new evidence. |
| What it is, "A run writes a table of..." | Three output types I have never met, listed before any of them is explained, especially "per-window coverage file". | Explain window and consensus where they first appear, not later. |
| Why you would do this, "That is often as far as..." | "spends most of its size on bacteria" is a metaphor I had to stop and translate. Databases do not spend. | Plainer wording. |
| Why you would do this, "This chapter works through the SRR36291587..." | Four terms in one phrase, and QIAseq Direct is never explained anywhere in the chapter. | Say whether QIAseq Direct matters to me or is only a product label. |
| Before you start, "The reads themselves are too large..." | I do not know how large this download is or how long it takes. My laptop disk is small. | Give the download size. |
| Before you start, "Open Tools > Plugin Manager... (Cmd-Shift-B)..." | I could not tell how to know whether the pack is already there. The sentence assumes I can see this. | Say what an installed pack looks like in the Plugin Manager. |
| Step 1, "Plan for at least 8 GB..." | I do not know how to check my Mac's memory, and I could not tell whether 8 GB means total or free. | Say where to look and which one it means. |
| Step 1, "Outside the app, `lungfish-cli esviritu db-status`..." | This is a terminal command. I have never opened a terminal and the chapter does not tell me I may skip it. | Say plainly that the app path alone is enough. |
| Step 2, "Pairing comes from the way LGE..." | I could not perform the fix. It says close the dialog and fix the selection, but not what a correct selection looks like. | Say how to select two mate files so they group as a pair. |
| Step 2, "A warning may appear under the..." | I did not know whether to stop or continue. It says advisory, but then tells me to close other applications, which sounds like I must act. | Say whether the run is safe to start anyway. |
| Step 3, "The row's detail reads Running EsViritu..." | Ten phase names in one sentence. I do not know what a viral signature is, or why screening comes after aligning. | Split the list, or drop the phases I cannot act on. |
| Step 3, "The reference run took 345.2 seconds..." | I do not know my own core count, so I could not judge how long my run would take. | Say roughly how the time scales, for example double it for half the cores. |
| Settings, "The dialog carries six controls. Three..." | I read this three times. It explains punctuation, and I thought I had missed a setting called "Min read length:". | Remove or shorten the colon explanation. |
| Settings, Run Mode, "It is fixed on Run separately..." | "abundance" is used here, but abundance is only explained later under RPKMF. | Gloss abundance at this first use. |
| Settings, Min read length, "Lower it for degraded or heavily..." | "scrutinise" is a hard word for me, and I did not learn how to scrutinise the extra detections. | Simpler verb, and point me to the What good looks like section. |
| Settings, Extra arguments, "Use it only after reading the..." | I do not know what an unclosed quote is, because I never type commands. | A one-line example of a right and a wrong value. |
| Reading the results, "RPKMF is reads per kilobase of..." | The expansion did not help. Two divisions in one sentence and I could not picture it. | A small worked example with a long virus and a short one. |
| Reading the results, "Coverage is the mean sequencing depth..." | I did not know what the `x` means. Times? Multiplied by what? | Say the x means times, as in read this many times over. |
| Reading the results, "A high mean depth with a..." | "a pile rather than a genome" is a figure of speech I only understood after the later section. | Give the plain meaning first. |
| The reference run, table row "Segment" | The table literally prints the words "em dash". I thought this was a mistake, or a value I had to look up. | Print "not applicable" or the actual symbol. |
| The reference run, the whole table | The table has no Unique Reads row, but a later section tells me to compare Reads against Unique Reads. I could not do that comparison for the example. | Add the Unique Reads value to the table. |
| The reference run, "162,441 reads mapped, out of the..." | The 170,180 figure appears for the first time here and I could not find where to see it in the app. | Say which file or panel reports the surviving read count. |
| The reference run, "The per-window coverage file divided the..." | I did not know whether 319.4 is good. The chapter gives no threshold for a thin window. | Say what depth counts as too thin. |
| The detail pane, "For a segmented virus, one whose..." | The gloss of segmented is good, but "completeness grid" is not explained and there is no picture of it. | Say what a filled cell versus an empty cell means. |
| Auditing a detection, "Selecting a row that carries alignment..." | I could not tell which rows carry alignment data and which do not. | Say when a row would lack it. |
| Auditing a detection, "It reads Structurally validated reference when..." | Three states with unexplained names. "M5" and "contig names and lengths" both stopped me, and no state tells me what to do. | Say what action each state asks of me. |
| Auditing a detection, "The first two both let the..." | I never learned what a mismatch display is. It appears only here. | Gloss it or drop it. |
| Acting on a row, "Below it sits BLAST Verify..., which..." | I could not tell whether my reads leave the machine. For a clinical specimen that matters to me. | Say the reads are sent to NCBI over the internet. |
| Acting on a row, "A cell showing an ellipsis in..." | "Ellipsis" is a grammar word for me. I did not connect it to three dots on the screen. | Say three dots. |
| What good looks like, "When Unique Reads is a small..." | "Small fraction" gives me no number, so I could not judge my own result. | Give a rough figure. |
| What good looks like, "so a figure in the high..." | I could not tell where the boundary sits. Ninety-two percent is neither the high nineties nor the eighties. | Give one cut point. |
| What good looks like, "Even at 99.7% identity across 29,808..." | "lineage assignment" and "variants" arrive together and neither is glossed here. | Gloss lineage. |
| On the command line, whole section | I cannot use any of this, and I was not told I could skip it, so I read it all in case something important hid inside. | One line at the top saying the app already did all of this. |
| On the command line, "Its `toolVersion` field, and the Tool..." | This sounds like a bug, and I could not tell whether it affects the numbers I read in the viewport. | Say the results themselves are unaffected. |

The one thing I learned. Read counts alone are weak evidence, and where the reads landed along the genome is the real evidence, which is why the little sparkline chart matters more than the big number beside it.

The one thing I still could not do. Judge a result that is not the perfect example. Every threshold in the chapter is a word like thin, small fraction, or high nineties, so with my own messier data I would not know which side of the line I am on.

The sentence I liked most. "Two hundred reads spread evenly along a 30,000-base viral genome and two hundred reads stacked on one 300-base stretch produce the same read count and mean completely different things."
