# Merged reader report - Novel Virus Diagnostics

Four readers reviewed this chapter. Personas were a genetics sophomore who has never opened a terminal, a wet-lab senior with two years of pipetting and no data analysis experience, a pre-med student reading in a second language, and an undergraduate who spent one semester in Geneious. None had opened a terminal before.

| Location | Issue | Readers who hit it | Suggested fix |
|---|---|---|---|
| What it is, "a database of known nucleotide sequences" | All four readers could not tell which database NVD searches, whether it is a public collection, a local copy, or something the pipeline operator supplies. | 1, 2, 3, 4 | Name the database NVD searches, or say plainly that the pipeline operator chooses it and it stays invisible in LGE. |
| What it is, "written in Snakemake" | All four readers understood the gloss but still could not tell whether they would ever need to install or run Snakemake themselves. | 1, 2, 3, 4 | State plainly that running NVD is a terminal task done outside LGE, and the reader never installs or runs Snakemake to follow this chapter. |
| Before you start, "Download the folder `nvd-demo` ... on GitHub" | All four readers could not perform this step. GitHub has no download button for a single folder, only for a whole repository or single files, and none knew how to clone. | 1, 2, 3, 4 | Give a direct zip link, or say plainly to download the whole repository and navigate to the path inside it. |
| Before you start / Procedure step 2, the nesting of `nvd-demo`, `nvd-demo/results`, and `05_labkey_bundling/` | All four readers lost track of how the folder levels named across two or three sections nest inside each other. | 1, 2, 3, 4 | Show the folder layout once as a small tree. |
| Before you start, "No plugin pack is needed" | All four readers met "plugin pack" with no gloss and could not tell what one is or why the reassurance mattered. | 1, 2, 3, 4 | Gloss plugin pack at first use, or drop the sentence and say the import needs nothing extra. |
| Procedure step 2, "the preview reads experiment `100`" | All four readers could not tell what an experiment identifier is or whether 100 is a count, and the explanation that it comes from the CSV's first column arrives only in Settings, much later. | 1, 2, 3, 4 | Say at first use that the experiment identifier is a label from the CSV's first column, and that any value is fine. |
| Procedure step 3, "which is not where classification runs started inside LGE land" | All four readers stumbled on "inside LGE land" as an idiom or apparent typo, though the sentence carries the most important navigational fact in the chapter, that Import Center output goes to `Imports/` while runs started in LGE go to `Analyses/`. | 1, 2, 3, 4 | Rewrite as two short, plain sentences and drop the idiom. |
| Procedure step 3, "The command line writes wherever `--output-dir` points" | All four readers met a command-line flag offered as the fix to a folder-location problem, in the middle of a mouse-driven step, though none had opened a terminal. | 1, 2, 3, 4 | Move the flag out of the numbered step, and say whether the folder can be moved afterward in the sidebar. |
| Procedure step 4, "Six metric pills sit under that" | All four readers did not know "pill" as an interface term and pictured medicine, or looked for something round and clickable, before the meaning became clear. | 1, 2, 3, 4 | Gloss pill at first use as a small labelled badge showing one number. |
| Procedure step 4, "embeds the full alignment viewer over the reads that built the contig" | All four readers did not know what the alignment viewer shows, and it is the one part of the detail pane with no description, unshowable on the demo. | 1, 2, 3, 4 | Add one sentence saying what the viewer displays, since the fixture cannot demonstrate it. |
| Procedure step 5, "220 points tall to begin with ... down to 160 points" | All four readers could not judge a measurement in points and said the numbers told them nothing useful. | 1, 2, 3, 4 | Drop the point figures, or describe the drawer's size relative to the window. |
| Settings, "**--name.**" and "**--output-dir.**" | All four readers found these presented as command-line flags inside a Settings section a mouse-only reader consults, with no statement that the window offers no equivalent. | 1, 2, 3, 4 | State once, at the top of the section, that these two options exist only on the command line and the wizard has no substitute. |
| Settings, "the current working directory, which is almost never what you want" | All four readers did not know what a working directory is and could not judge the warning. | 1, 2, 3, 4 | Gloss working directory, or mark the paragraph as command-line only. |
| Reading the results, "Contigs are listed longest first by default, and there is no sort control" | All four readers could not tell whether the missing sort control is a limitation or a deliberate design, and one expected column-header sorting from other tools. | 1, 2, 3, 4 | State plainly that the order is fixed by design, unlike tools where clicking a column header sorts. |
| Reading the results, "the demo results run from `0.0` ... down to `1e-90`" | All four readers read "down to" as backwards, since 1e-90 is a larger number than 0.0, and stopped to reread the direction. | 1, 2, 3, 4 | Say plainly which value is smallest and which is largest, without the word "down," and gloss `1e-90` as one followed by ninety zeros in the denominator. |
| Reading the results, "Anything at or under `1e-30` is effectively certain not to be chance" | All four readers had no worked contrast for the 1e-30 threshold, since every demo value already passes it, and some were unsure which exponent counts as smaller. | 1, 2, 3, 4 | Give one example e-value that fails the test, and say which way the comparison runs. |
| Reading the results, "one reads `clade`, the Norovirus GII row" | All four readers' own coursework defined clade differently from how the chapter uses it, and the explanation is only a half-clause. | 1, 2, 3, 4 | Gloss clade fully at first use as a named group of related organisms that does not sit on the standard genus-species ladder. |
| Reading the results, "**Create Bundle…**, and **Run Operation…**" | All four readers were given a run of five or six context-menu items with no description of what any produces, and singled out Run Operation as the most opaque. | 1, 2, 3, 4 | Say what each item does in one clause, or link to where it is documented. |
| Reading the results, "shows an em dash in grey" | All four readers did not recognize "em dash" as a typography term and could not picture the character from the name alone. | 1, 2, 3, 4 | Describe it plainly as a short grey dash meaning no value. |
| What good looks like, "bit scores step down gently from 750 to 660" | All four readers found this example called both ambiguous and reassuring in one paragraph, needing a reread to separate the shape from the verdict, with no contrasting example given. | 1, 2, 3, 4 | Split into two sentences, the shape first and the verdict second, and add a contrasting drop for a clean case. |
| What good looks like, "a deep and evenly distributed pileup" | All four readers met "pileup" with no gloss and could not picture depth or evenness without ever seeing the demo produce one. | 1, 2, 3, 4 | Gloss pileup as the stack of reads sitting over one position. |
| On the command line, "it exits with status 1" | All four readers did not know what an exit status is and could not tell whether status 1 means a crash or an ordinary refusal. | 1, 2, 3, 4 | Say the command stops with an error message, without naming the status code. |
| What it is, "reaches the same goal as a read classifier" | Three readers were told to compare NVD to a read classifier before the chapter had said what either one's goal actually is. | 1, 2, 3 | Say the shared goal plainly, for example that both methods try to name organisms present in a sample, before making the comparison. |
| What it is, "carries far more evidence than one match on a single 150-base read" | Three readers found this central claim simply asserted, with no explanation of why a longer match is stronger evidence. | 1, 2, 3 | Add one clause tying longer aligned length to a lower chance of a coincidental match. |
| What it is, "matches it at low sequence agreement" | Three readers met a third name for percent identity here, before the term itself appears much later. | 1, 2, 3 | Use percent identity at this point, or say the two names mean the same number. |
| What it is, "a folder named `05_labkey_bundling/`" | Three readers had no idea what LabKey is and worried the folder name meant they needed an account or were missing earlier stage folders. | 1, 2, 4 | Say the folder name is the pipeline's own internal label and needs nothing from the reader. |
| Why you would do this, "a large comma-separated table" | Three readers met "comma-separated" used before CSV appears, and CSV itself is never spelled out. | 1, 2, 4 | Gloss CSV as comma-separated values at first use. |
| Why you would do this, "one disclosure triangle away" | Three readers did not know what a disclosure triangle was at this first mention, before step 4 describes clicking one. | 1, 2, 3 | Gloss disclosure triangle here, or drop the term until step 4 introduces it. |
| Why you would do this, "a checksum of the input file" | Three readers found checksum unglossed and unlinked, and could not tell what it is or why it makes a run auditable. | 1, 2, 3 | Gloss checksum at first use as a short fingerprint that changes if the file changes. |
| Why you would do this, "10 BLAST hit rows across 3 samples and 4 contigs" | Three readers could not judge whether 10 hits for 4 contigs is sparse, normal, or dense, since the payoff explanation arrives many sections later. | 1, 2, 3 | State here that most contigs carry several ranked matches. |
| Procedure step 4, "Identity, E-value, Bit Score, Mapped Reads, RPB, and Length" | Three readers met RPB unexpanded in the pill or column list, learning "reads per billion" only much later in Reading the results. | 1, 2, 3 | Expand RPB at its first appearance. |
| Reading the results, "The columns, left to right, are Sample, Contig, Length ..." | Three readers lost their place in a run-on list of fourteen column names and could not map them back to the six pills from step 4. | 1, 2, 3 | Break the list into a table, or say which columns match the pills. |
| Reading the results, "A contig of 5,000 bases aligning over 400" | Three readers could judge a near-total match but not a badly partial one, with no threshold given for when a partial match is worth chasing. | 1, 2, 3 | Give a rough fraction below which a partial match is worth flagging. |
| Reading the results, "A figure in the seventies or low eighties says the contig is related to something known" | Three readers found the middle range, roughly the high eighties to mid nineties, never described, leaving the most likely real-world values unjudged. | 1, 2, 3 | Describe the middle range explicitly, rather than leaving a gap between two examples. |
| Reading the results, "a scale that does not shift with database size" | Three readers understood the words but had no anchor for whether a given bit score is good, or why database size would matter at all. | 1, 2, 3 | Say plainly that bit scores are comparable within one contig's own hits, not across contigs, and that a bigger database makes chance matches more likely. |
| Reading the results, "a large drop from the first row to the second" | Three readers could not judge "large," since What good looks like calls a 750-to-660 step "gentle," leaving no anchor for what counts as large. | 1, 2, 3 | Give an approximate drop, or ratio, that counts as a clean call. |
| Reading the results, "50 mapped reads out of 1,000,000 total" | Three readers could not find the sample's total read count anywhere else in the app to check the figure or judge whether the resulting RPB is high or low. | 1, 2, 4 | Say where the total read count is shown in the app, and whether an RPB of that size is high or low for a typical sample. |
| What good looks like, "with hits at least equal to contigs since every contig has at least one match" | Three readers had to reread the sentence to separate the two uses of "at least." | 1, 3, 4 | Say the hits count can never be lower than the contigs count, with the ratio spelled out. |
| What good looks like, "sits well below ninety percent identity" | Three readers noticed this threshold contradicts the "seventies or low eighties" language used earlier in Reading the results. | 2, 3, 4 | Use one identity threshold consistently throughout the chapter. |
| What good looks like, "A contig assembled from very few reads may be an assembly artifact" | Three readers found "very few" ungiven a number, while the demo's own contigs range from 10 to 100 mapped reads with no guidance on which count is too few. | 1, 2, 3 | Give a rough minimum read count below which a contig should be distrusted. |
| On the command line, "The whole procedure runs headless." | Three readers met "headless" with no gloss and had to guess it means without opening the app window. | 1, 2, 3 | Gloss headless plainly as without opening the app. |
| On the command line, "`lungfish-cli nvd summary /path/to/nvd-demo/results --top 20`" | Three readers could not perform this, since nothing says where to type it, what `lungfish-cli` is, or how to open a terminal. | 1, 2, 3 | Point to the chapter that explains installing and opening the command-line tool, or say the window steps already did this work. |
| On the command line, "the TSV form's columns are `sample_id`, `qseqid`, `qlen` ..." | Three readers could not map these raw column names to the display names used earlier in the viewport. | 1, 2, 3 | Give the display name beside each raw name. |
| What it is, "stitches the reads into contigs first" | Two readers did not know an assembler was involved until much later, since "stitches" stands in for the word "assembly," which never appears at this point. | 2, 4 | Name the step assembly at first use. |
| What it is, "it either reports the nearest relative with unwarranted confidence" | Two readers could not tell whether this described a flaw in classifiers generally or one specific tool, and one found "unwarranted" a hard word. | 2, 3 | Say which behaviour belongs to the classifier and which to the operator reading it, and use a simpler word than unwarranted. |
| What it is, "`*_blast_concatenated.csv`" | Two readers did not know whether the file is literally named with an asterisk. | 1, 3 | Say the asterisk stands for whatever prefix the run used. |
| Procedure step 2, "the panel counts rows as it reads them" | Two readers could not observe this, since a file this small scans in under a second. | 3, 4 | Say the counting is visible only on larger runs. |
| Procedure step 3, "writes them into a small database inside the new result folder" | Two readers worried this meant installing extra database software. | 1, 3 | Add that the database is internal and never opened by hand. |
| Procedure step 4, "the same four the command-line summary prints" | Two readers, having never opened a terminal, could not use this cross-check, and found it appearing without warning inside a mouse-driven step. | 2, 3 | Note that the check is optional and terminal-only, or move it to the command-line section. |
| Procedure step 5, "A taxon group heading in the By Taxon grouping is not itself a hit" | Two readers met "By Taxon grouping" before it is introduced, since Settings, which defines it, comes after this step. | 2, 3 | Introduce By Sample and By Taxon in step 4, before step 5 refers to them. |
| Settings, "a reader arriving from the registry will look for them here" | Two readers found "registry" used with no explanation anywhere in the chapter. | 1, 4 | Drop the reference, or gloss registry at first use. |
| Settings, "it searches best matches only" | Two readers found this limitation buried at the end of a long, negative sentence, easy to miss. | 2, 3 | Lead with the limitation, in one short positive statement. |
| Reading the results, "when the pipeline did not report a separate figure the column repeats the mapped-read count" | Two readers noted this makes the demo's Unique Reads and Mapped Reads columns look identical, which a reader checking numbers by eye would mistake for a bug. | 2, 4 | Flag this fact where the demo numbers first appear, not only in the column gloss. |
| Reading the results, "Verify with BLAST…" versus step 5's "BLAST Verify" | Two readers could not tell whether the right-click item and the button name the same action. | 3, 4 | Use one name for the action, or say plainly the two labels refer to the same thing. |
| What good looks like, "the number of libraries that went into the run" | Two readers paused to check whether "library," used only here, and "sample," used elsewhere, meant the same thing. | 1, 2 | Use one of the two words consistently throughout. |
| On the command line, "byte-identical output for the same selection" | Two readers found "byte-identical" unhelpful on its own. | 1, 3 | Say the button and the command produce the same file. |
| What it is, "a few hundred bases long" | One reader found "bases" used before it connects to the letters A, C, G, T, and the later "150-base read" assumes the same unexplained term. | 3 | Gloss base at first use as one letter of DNA sequence. |
| What it is, "rather than a census tool" | One reader needed a moment to parse "census" as a metaphor for population counting. | 3 | Replace with a plain phrase such as a tool for counting what is already known. |
| What it is, "the practice of sequencing sewage" | One reader could not see why a wastewater example appears before the reason for it is given. | 3 | Move the reason for the example before the wastewater definition. |
| What it is, "optionally gzip-compressed" | One reader had not met gzip and was unsure whether `.gz` is the same as a zip file. | 3 | Gloss gzip at first use. |
| What it is, "the earlier stage folders of an NVD run do not need to be present" | One reader could not tell whether this sentence permitted deleting something. | 3 | Say briefly that an NVD run makes numbered stage folders and only `05_labkey_bundling/` is read here. |
| What it is, "The mental model to carry into the window" | One reader could not tell whether "the window" meant the app window or was itself a figure of speech. | 3 | Rewrite as a plain statement about how to read the display. |
| Why you would do this, "the rows are ranked matches rather than independent records" | One reader had to read the sentence three times before the next sentence clarified it. | 2 | Lead with the plain version, that several rows describe the same contig. |
| Why you would do this, "rather than the log files" | One reader found log files mentioned with no role in the chapter's own steps. | 3 | Drop the mention, or gloss it. |
| Why you would do this, "a table of that shape" | One reader could not tell what property "shape" referred to. | 3 | Say directly what property of the table causes the problem. |
| Why you would do this, "and that comparison is the thing a flat table hides" | One reader did not know what a flat table is or what it contrasts with. | 3 | Define flat table as one with no grouping. |
| Why you would do this, "checked by eye" | One reader needed a moment to parse the idiom. | 3 | Say checked by hand against the source file. |
| Before you start, "extracting the reads behind a contig" | One reader did not understand what read extraction means or why they would want it. | 1 | Say extraction pulls the sequencing reads that built a contig into their own file. |
| Before you start, "the BAM alignment files a full NVD run produces" | One reader could not reconcile the BAM gloss, which describes reads aligned to a reference, with NVD's contig-based workflow. | 2 | Say plainly that in NVD, reads are aligned back to the assembled contigs, not to an external reference. |
| Before you start, "finishes in under a second on a run this size" | One reader could not judge what a normal run size is or how long a real run takes. | 3 | Give the timing for a real, non-demo run as well. |
| Before you start, "this chapter says plainly where that boundary falls" | One reader was confused about who was speaking, since the sentence describes the chapter itself. | 3 | State directly which steps and commands cannot run on the demo. |
| Procedure step 1, "click the **Classification Results** tab" | One reader could not tell whether the Import Center opens on that tab or whether other tabs must be hunted through. | 2 | Say how many tabs there are or which one opens first. |
| Step 1, "Unlike most cards in the Import Center, this one does not open a plain file panel" | One reader, on a first import, could not benefit from a contrast with behavior never seen. | 4 | Drop the comparison and describe the wizard sheet directly. |
| Procedure 1, "Choose **File > Import Center...**" | One reader did not know whether the trailing ellipsis in a menu item required typing something. | 3 | Say once that three dots in a menu item mean it opens a dialog. |
| Procedure 1, "a wizard sheet titled NVD Import" | One reader did not know what a "wizard sheet" is, a window, a panel, or a page. | 3 | Gloss sheet at first use. |
| Procedure 2, "The path readout to the left of the button is a display of the chosen path and is not editable" | One reader was told what the field is not, and looked for a place to type that does not exist. | 3 | State positively that the path is shown for confirmation only. |
| Procedure 4, "contig `NODE_2_length_300_cov_5.0`" | One reader could not tell whether "cov" in the contig name mattered. | 3 | Explain the contig-name parts once, including cov. |
| Procedure 4, "opens to reveal four further HIV-1 matches under its best one" | One reader found the count here disagreed on its face with the count given for the same contig in What good looks like, needing arithmetic to reconcile them. | 3 | State the total once, in matching wording, in both places. |
| Procedure 5, "The button is deliberately fussy about selection" | One reader needed the next sentence to understand the idiom "fussy." | 3 | Say the button requires exactly one row selected. |
| Procedure step 5, "the sample's contig-sequence file" | One reader found this file named but never described, not knowing its format or origin. | 1 | Say a full NVD run writes a FASTA of the assembled contigs. |
| Step 5, "hovering it explains why in a tooltip" | One reader, used to silently greyed-out menu items, would not have thought to hover. | 4 | State directly that hovering a disabled control reveals the reason. |
| Step 5, "This step cannot be performed on the demo results" | One reader had already followed the section as instructions before reaching this caveat at the end. | 4 | Move the warning to the top of the section. |
| Settings, "`My Project.lungfish/Analyses`" | One reader met the project folder suffix for the first time inside a code block, not knowing a project was a folder with an extension. | 1 | Mention the project folder suffix once in Before you start. |
| Settings, "The NVD import has no settings." | One reader found the section then lists four things that look exactly like settings, and could not tell which ones the window actually offers. | 2 | Split the terminal-only flags from the window controls with a clearer heading. |
| Settings, "All Samples. Opens a popover" | One reader did not know "popover" as an interface term. | 4 | Gloss popover at first use as a small panel that appears next to the button. |
| Reading the results, "run 99.5%, 96.0%, 99.0%, and 97.5%" | One reader could not match these four numbers back to the four contigs in an order reconstructable from anything above. | 1 | Name the contig beside each figure, or point to the command line table. |
| Reading the results, "the number of matches this good you would expect" | One reader read this twice, since it first looked like a quality score rather than a count of expected chance matches. | 1 | Say it is how many hits this strong you would expect from a random database of the same size. |
| Reading the results, "`1e-90`" | One reader knew the underlying exponent from chemistry but not this way of writing it. | 3 | Explain the e notation once. |
| Reading the results, "so on contigs the e-value rarely does much work. It earns its place on short contigs" | One reader met two idioms in a row treating a number as a worker. | 3 | Say the e-value matters mainly for short contigs. |
| Reading the results, "the number of reads that mapped back to this contig" | One reader found "mapped" used without a gloss, a term their genetics course did not cover. | 1 | Gloss mapping as lining a read up against a sequence to find where it fits. |
| Reading the results, "**RPB** ... divided by the sample's total read count and multiplied by a billion" / "despite the raw counts differing twofold" | One reader could do the arithmetic in the worked example but stumbled on "library," never glossed, and on "twofold," understood only after checking the numbers. | 3 | Gloss library, and say plainly that one sample has twice as many reads. |
| Reading the results, "A broad rank is not a defect" | One reader understood the statement but was not told what to do differently when a rank is broad. | 3 | Say what action, if any, a broad rank should change. |
| Reading the results, "**Extract Reads…** opens the shared extraction dialog" | One reader found "shared extraction dialog" implying documentation elsewhere with no link given. | 2 | Link the chapter that documents the extraction dialog. |
| Reading the results, "through a save panel" | One reader paused on "save panel" as macOS-specific vocabulary. | 1 | Use save dialog, or gloss the term once. |
| Reading the results, "The information button at the right end" | One reader could not picture the icon, since it is never described. | 3 | Describe the icon, for example a lowercase i in a circle. |
| Reading the results, "Use Import Metadata… in the Inspector" | One reader could not locate the Inspector, which gets no menu path or shortcut, unlike the Operations panel. | 4 | Give the menu path or shortcut that opens the Inspector. |
| On the command line, "`/path/to/nvd-demo/results`" | One reader did not know the placeholder convention meant substituting their own path. | 1 | Say the placeholder stands for wherever the folder was saved. |
| On the command line, "`--top 20`" | One reader noted the example passes the default value, so it never shows what the flag changes. | 1 | Use a non-default value in the example. |
| On the command line, "`--bundle` wraps the output as a `.lungfishfastq` bundle" | One reader met two new ideas in one clause and did not know what wrapping accomplishes. | 1 | Say a bundle keeps the reads together with a record of where they came from. |
| On the command line, "`--format tsv` or `--format json`" | One reader found TSV and JSON unglossed, unlike FASTQ and BAM elsewhere in the chapter. | 3 | Gloss both, or say machine-readable file formats. |
| On the command line, whole section, no statement that it is optional | One reader found nothing at the top of the section saying a graphical-only reader could skip it. | 4 | Open the section by saying it requires a terminal and is optional for readers using the app. |
| Whole chapter, no Troubleshooting section | One reader could not relocate any of three scattered failure states, the preview warning, the greyed-out Run button, and the missing BAM, after first meeting them. | 4 | Collect the three into one short troubleshooting list. |
| Throughout, screenshot placeholders such as "SHOT: nvd-import-card" | One reader, a visual learner, found five places showing only a comment where a picture should be. | 3 | Add the screenshots before this chapter is published. |
| Step 4, "an outline list of contigs the right" | One reader found the sentence missing a verb, and "outline" collided with a different meaning from other software. | 4 | Restore the verb and gloss outline as the expandable table of contigs. |

One hundred and four rows total.

## Consensus

Forty-three rows were hit by three or more readers.

- The database NVD searches is never named.
- Snakemake's gloss does not settle whether the reader will ever need a terminal for it.
- The GitHub demo folder cannot be downloaded as linked, blocking the whole walkthrough.
- The nesting of `nvd-demo`, `nvd-demo/results`, and `05_labkey_bundling/` is never shown as a folder tree.
- Plugin pack is used with no gloss at first mention.
- The experiment identifier is explained too late to help when it first appears.
- The "inside LGE land" sentence garbles where Import Center output actually lands.
- A command-line flag is offered as the fix to a folder-location problem inside a mouse-only step.
- Metric pills is never glossed as an interface term.
- The alignment viewer's contents are never described, and the demo cannot show it.
- The 220 and 160 point measurements for the drawer are meaningless without a screen reference.
- The command-line-only Settings entries never say the window has no equivalent.
- Working directory is used without a gloss for readers who have never opened a terminal.
- No sort control is never stated as an intended design rather than a limitation.
- The e-value direction from 0.0 down to 1e-90 reads backwards.
- The 1e-30 threshold is never tested against a failing example.
- Clade is used without matching how readers' own coursework defines it.
- The row of context-menu commands names five or six items with no description.
- Em dash is never described in plain terms.
- The bit-score example is called both ambiguous and reassuring with no contrasting case.
- Pileup is never glossed.
- Exit status 1 is never explained in plain terms.
- The read classifier comparison opens before either method's shared goal is stated.
- The central claim that longer BLAST matches carry more evidence is simply asserted.
- Percent identity appears under a third, earlier name with no link drawn.
- LabKey in the folder name worries readers that something is missing or required.
- Comma-separated is used before CSV is spelled out.
- Disclosure triangle is used before it is ever explained.
- Checksum is never glossed or linked.
- The payoff for "10 hits across 4 contigs" arrives sections after the number itself.
- RPB is used unexpanded well before its definition.
- The fourteen-column list is a run-on sentence with no table.
- No threshold is given for when a partial contig match is worth chasing.
- The high eighties to mid nineties identity range is never described.
- Bit score has no anchor for what counts as good, and the database-size caveat is unexplained.
- "Large" is never quantified for a bit-score drop.
- The sample's total read count and the resulting RPB have no anchor for high or low.
- The double "at least" in the hits-versus-contigs sentence needs two readings.
- The ninety percent identity threshold in What good looks like contradicts the seventies-eighties threshold used earlier.
- "Very few" reads is never given a number for judging assembly artifacts.
- Headless is never glossed.
- The CLI summary command section gives no path to opening a terminal in the first place.
- The CLI's raw column names are never mapped to the viewport's display names.
