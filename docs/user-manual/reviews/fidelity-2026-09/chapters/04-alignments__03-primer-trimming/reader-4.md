# Reader report: Primer Trimming an Alignment

Persona: undergraduate who used Geneious in one class, has never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "Primer trimming at the alignment level removes..." | "At the alignment level" versus some other level. I did not know there was more than one level until three paragraphs later. | Say the two levels exist in the first sentence. |
| What it is / "Lungfish Genome Explorer (LGE) packages a scheme as" | A `.lungfishprimers` folder that is described as a folder but behaves like a file. In Geneious everything lived inside the program. | One sentence saying it looks like a single item in Finder. |
| What it is / "a manifest naming the protocol and" | Manifest. Not glossed, and it comes back four more times later. | Gloss manifest at first use. |
| What it is / "It changes the letter in the read's CIGAR" | CIGAR string. I read this twice. I have never seen one, and the sentence explains it while also using it. | Show a tiny before and after CIGAR string. |
| What it is / "So what should you do with this?" | The question is asked of me, but I do not yet know whether my own data is amplicon, and nothing tells me how to check. | Say how to tell whether a library is amplicon. |
| Why you would do this / "primers are frequently written with deliberate mismatches" | Why a designer would deliberately put a wrong base into a primer. This felt backwards. | Half a sentence on why a mismatch keeps a primer binding. |
| Why you would do this / "it sits under deep coverage, and it passes" | Deep coverage. Coverage is in the glossary list, but the word deep is doing work I could not judge. | Say roughly what depth counts as deep here. |
| Why you would do this / "a QIAseq Direct amplicon library of 86,281" | 86,281 read pairs here, but later numbers are 172,562 records. I could not reconcile the two until I guessed pairs times two. | State the record count next to the pair count. |
| Before you start / "fetch them from the Sequence Read Archive as accession" | I do not know how long this download takes or how large it is. I was afraid to start it. | Give the download size and rough time. |
| Before you start / "mapping placed 171,355 of 172,562 read records" | 99.30% is given, but I do not know whether that is good, expected, or lucky. | Say what mapping rate would worry me. |
| Before you start / "Open Tools > Plugin Manager... (Cmd-Shift-B)" | Whether installing the Variant Calling pack needs internet, and how long it takes. | One sentence on download size and time. |
| Procedure / "The Analysis section is a grid of six tabs" | Six tabs, but only one is named. I could not picture the grid. | Name the six tabs or point to the screenshot. |
| Procedure / "Eight schemes sit under a heading reading Built-in" | How I would know which of the eight matches my own kit if my kit is not named exactly. | Say to check the kit box or the wet-lab protocol sheet. |
| Procedure / "Choose QIAseq Direct SARS-CoV-2 with Booster A" | Booster A. There is presumably a Booster B, and I do not know how to choose between them. | One clause saying what a booster panel adds. |
| Procedure / "An eligible track is one stored as an indexed BAM" | Indexed. I do not know what an index is or how a track ends up without one. | Gloss index once and say what to do if a track is missing. |
| Procedure / "It holds four iVar numbers whose defaults follow" | I was told to leave it collapsed, then the Settings section documents all four in detail. I could not tell whether I should care. | Say plainly that most users never open it. |
| Settings / "The default is 20, a Phred score meaning" | One wrong base in a hundred. That 20 maps to one in a hundred is stated but not explained. | Skip the arithmetic or show the pattern with 30 as well. |
| Settings / "Sets how many neighbouring bases iVar averages" | Sliding window. I could not picture the window walking in from the read end. | A one-line picture of the window moving. |
| Settings / "which compensates for a scheme whose coordinates" | How I would ever establish that my coordinates are off by a fixed amount. | Say what symptom points to an offset. |
| Reading the results / "turn on Show soft-clipped sequence in the Inspector's" | Where the read display controls are. The Inspector has sections, and this one is not named among them. | Name the Inspector section holding that toggle. |
| Reading the results / "Soft-clipped bases on the reference run rose from" | Four large numbers in one sentence. I had to reread it to see which pair was before and which after. | Put the four numbers in a small table. |
| Reading the results / "The trim added roughly 6.6 million newly clipped" | Clipped bases rose by 6.64 million but matched bases fell by 8.12 million. Those do not match and I could not explain the gap. | Say where the extra bases went. |
| Reading the results / "3.88% (6651) of reads were quality trimmed" | 3.88% of what. 6651 out of 172,562 is 3.85%, and out of 169,906 it is 3.91%. Neither is 3.88%. | Say which total the percentages are taken from. |
| Reading the results / "with the date and scheme name beneath it" | I do not know where to find this checkbox. The variant-calling dialog has not been introduced. | Say the checkbox appears in a later chapter's dialog. |
| What good looks like / "A low rate means the scheme and the library disagree" | Low is not defined. 99.15% is good and 22.13% is bad, but I do not know where the line sits. | Give a threshold below which I should stop. |
| What good looks like / "soft-clipping reached only 13.44% of bases rather than" | Whether I should check this percentage too. The section says the trim rate is the only check, then gives a second number. | Say whether the base percentage is a check or only an illustration. |
| What good looks like / "all eight bundled schemes name both MN908947.3" | Two accessions being the same genome deposited twice. I did not know a genome could have two accessions. | One clause saying why duplicates exist. |
| On the command line / "The identifier is the short aln_ string in" | I have never opened a terminal, and I do not know how to look inside `manifest.json`. | Say whether the identifier is also shown somewhere in the app. |
| On the command line / "--format json prints one JSON object per line" | JSON. Not glossed anywhere in the chapter. | Gloss JSON or drop the sentence for this reader. |
| On the command line / "open File > Import Center..., pick the References tab" | Importing a scheme is a separate task buried at the end of the command-line section. I nearly missed it. | Move the import paragraph out of the command-line section. |
| On the command line / "takes a FASTA of primer sequences, not the reference" | Why the tool would want the primer sequences at all if the BED file already has the coordinates. | Half a sentence on what the FASTA is used for. |

One thing I learned: soft-clipping keeps the bases in the file and just tells the variant caller to ignore them, so nothing is actually thrown away.

One thing I still could not do: decide whether my own sequencing run is an amplicon library that needs this at all, since the chapter assumes I already know.

The sentence I liked most: "A wrong scheme is silent, so the trim rate in the log is your only check, and you should read it every time."
