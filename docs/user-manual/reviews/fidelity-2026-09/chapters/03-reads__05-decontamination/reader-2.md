# Reader 2 report, Decontamination

Persona: senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The second way needs no reference" | I did not know what "reference" meant here. The text says "a stored collection of sequence you already have" but I first read it as a control sample. | Say it is a file on disk, not a sample. |
| What it is, "carrying the extension `.lungfishfastq`" | I have never looked at a file extension on a folder. I could not tell whether I make this or the app makes it. | One clause saying the app creates the bundle when you import. |
| What it is, table row "Managed human index" | "Index" is never glossed. I do not know if it is the human genome or something derived from it. | Gloss "index" at first use. |
| What it is, table row "A spike-in, vector, or carrier genome" | Three terms in one cell, none defined. I know spike-in from qPCR but not here. | Define at least "carrier genome" in the Settings entry. |
| Why you would do this, "A read made of a repeating" | I had to read the whole paragraph twice to see that the aligner is a later step, not part of this operation. | Say "later, when you map the reads" at the start. |
| Why you would do this, "Every number this chapter quotes" | I could not tell whether I should expect the same numbers on my own data. | State that your own numbers will differ. |
| Before you start, "click a filename and then the Download" | I did this and got a file with no `.gz` visible in Finder. I could not confirm I had the right thing. | Say the file may show without its extension. |
| Before you start, "Deacon spends about four of those seconds" | I do not know what an index is, so "loading its index" told me nothing about why it is slow. | Tie it back to a glossed "index". |
| Procedure step 3, "unless you have your own Deacon" | I have no idea how I would ever have one. This made me worry I was missing a setup step. | Say most users never need this. |
| Procedure step 3, "The settings pane below the" | I looked for a settings pane and could not tell an empty pane from a missing one. | The screenshot caption should say the pane shows a message. |
| Procedure, "Remove Contaminants shows a Contaminant Mode" | K-mer 31 and Hamming Distance 1 appear before either is explained. I stopped to hunt for the meaning. | Point forward to Settings in the same sentence. |
| Settings, Retain Reads, "Chooses which class of reads" | "Both" writes two bundles, which I only learned two sentences later. I first thought it merged them. | Say "two bundles" in the first sentence. |
| Settings, K-mer, "The default is 31, long" | I cannot judge "almost never happens by chance". I do not know if that is one in a thousand or one in a billion. | Give an order of magnitude. |
| Settings, Entropy Threshold, "Shannon entropy measures how varied" | I do not know what a score of 0.60 means for one read. Is it typical, or already unusual? | Give the entropy of an ordinary read. |
| Settings, Entropy Threshold, "The default is 0.60, which" | Which benchmark dataset? I could not tell if the 4 percent applies to my sample. | Name the dataset or say it is not yours. |
| Settings, Window, "Shorten it for short reads" | I do not know how short is short. My reads are 150 bases and I could not decide. | Give a rule, such as below 100 bases. |
| Settings, K-mer under Low-Complexity, "Longer words tell repeat patterns" | I read this three times. The logic that three-letter repeats use all four bases fairly did not land. | Split into two sentences with an example string. |
| Settings, Preset, "Near Duplicate 1 and Near" | I do not know if our core's machine has a patterned flowcell. Nothing tells me how to find out. | Say to ask the sequencing core. |
| Settings, Optical Distance, "Sets how many pixels apart" | Pixels of what? I did not know flowcell images had pixels. | One clause saying the instrument photographs the flowcell. |
| Settings, Output Strategy, "Choose Grouped Result when several" | I could not tell whether R1 and R2 of one sample count as "several files belonging to one library". | Say explicitly that mate pairs are not this case. |
| Reading the results, "Deacon v0.16.0; mode: deplete" | The `abs_threshold` and `rel_threshold` on that line are never explained and I assumed I had done something wrong. | Say to ignore the first line. |
| Reading the results, "That is 99.84 percent of" | The block above says "Retained 72/45574 sequences (0.158%)". I had to subtract to get 99.84 and was unsure I had done it right. | Show the subtraction once. |
| Reading the results, table row "Remove Contaminants, chr20 as a" | I could not tell this row was a deliberate mistake until the paragraph after the table. | Mark the row in the table itself. |
| Reading the results, "Just over one percent exact" | I do not know whether my own library was PCR-free. The 20 percent threshold is useless without that. | Say how to tell from the kit name. |
| Provenance, "For the ribosomal run above" | The log block earlier shows `abs_threshold=2, rel_threshold=0.01`. Here it is `absoluteThreshold` 1 and `relativeThreshold` 0. Different names and different numbers, and I could not reconcile them. | Explain why the two records differ. |
| What good looks like, "Reference-based operations only remove what" | I did not know whether my library is DNA or RNA without asking someone. The check assumes I know. | Say the import record shows this. |
| On the command line, "This section is optional. Everything" | I have never opened a terminal, and the fixture download instructions earlier felt like they might need one. | State that the GUI path needs no commands at all. |
| On the command line, "--database-id deacon-panhuman --output SRR36291587_1.scrubbed.fastq" | This id appears nowhere in the GUI section, so I could not connect it to the Database row. | Name the id where the Database row is described. |
| Next, "Continue to Subsetting and Extraction" | After five operations I did not know whether to run all five or only one. | Say which order, or that one is often enough. |

The one thing I learned is that removing reads is not one operation but five, and that three of them need something to compare against while two do not.

The one thing I still could not do is decide which of the five my own samples need, because every judgement in the chapter depends on knowing whether my library is amplicon or shotgun, DNA or RNA, PCR-free or amplified, and patterned flowcell or not, and the chapter never says where to look those up.

The sentence I liked most is "It is the demonstration that Custom Reference mode does exactly what you tell it to, including when what you tell it is a mistake."
