# Reader report: Quality Control for Reads

Persona: undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "What you read there is a" | It says nine numbers as cards, but the list right after gives four things. I counted four and spent a while wondering which five I had missed. | Say the four groups add up to nine cards. |
| What it is / "Import computes all of this as" | I did not know import ran anything after copying files. In Geneious, importing just puts the file in a folder. | One clause saying import runs a scan, not just a copy. |
| What it is / "Clicking one of the quality charts" | At this point I did not know what a quality chart looked like or that one could be blank, so the sentence had nothing to attach to. | Move this sentence to after the charts are introduced. |
| Why you would do this / "The reads are 2x250 base pairs" | I had to read 2x250 twice. I guessed it means two reads of 250 bases per fragment, but the text never says so. | Gloss 2x250 as two reads of 250 bases from each fragment. |
| Why you would do this / "from a 500 kb window of" | kb is never spelled out anywhere in the chapter. | Write 500 kilobases at first use. |
| Before you start / "Refreshing the summary uses seqkit from" | I do not know what seqkit is or whether I have to install it. Required Setup pack is also a new term here. | Say seqkit is a read-counting program that LGE installs for you. |
| Before you start / "No optional pack and no Docker" | Docker Desktop appears once and is never explained. I could not tell whether I needed to go get it. | Drop the name or gloss it. |
| Procedure step 1 / "Click the HG002.chr20.10.0-10.5Mb bundle in the" | The two files I downloaded end in _R1 and _R2, so I looked for two rows in the sidebar and could not find a row with this exact name. | Say import merges the pair into one bundle under the shared name. |
| Procedure step 2 / "Take Mean Q, Q20, Q30, and" | Q20 and Q30 are used as card names here, but what they mean only arrives much further down the chapter. | Add a half-sentence gloss at this first use. |
| Procedure step 4 / "The FASTQ/FASTA Operations window opens with" | I could not tell whether the window that opened was the right one, because I do not know what "already selected" looks like on screen. | Name the visible thing that confirms it, such as a highlighted row. |
| Procedure step 5 / "Watch the row in the Operations" | I could not do this. I did not know the Operations Panel existed, and the instruction to open it is buried inside a sentence about watching. | Make opening the panel its own step before Run. |
| Procedure / "which happens for some bundles derived" | I do not know what a bundle derived from another bundle is, or how I would end up with one. | An example, such as a trimmed copy of a bundle. |
| Settings / "Chooses whether the run writes one" | One long sentence with three ideas in it. I read it three times and still had to reread the Per Input clause. | Split it. |
| Settings / "Switch to Grouped Result when the" | I do not know what a library is. The word is used twice with no gloss. | Gloss library at first use. |
| Reading the results / "Reads is how many records the" | I could not follow how 91,148 reads is 45,574 pairs until I divided it myself, and "counted as individual reads" sounded to me like the opposite. | Say each pair contributes two reads to the count. |
| Reading the results / "and N50 is the length such" | I read the N50 definition four times and still cannot judge the number. I do not know what a good or bad N50 would be here. | Say what N50 tells you that the mean and median do not. |
| Reading the results / "A mean well below the median" | "Well below" and "far below" are both used and I cannot tell them apart. A 1.4 base gap is called small, but nothing says where small stops. | Give a rough number for when the gap matters. |
| Reading the results / "The card reads 24.9 while the" | This stopped me completely. Two numbers for the same quantity, ten points apart, and I have no way to know which one belongs in my lab notebook. | Say which number to quote when someone asks for mean quality. |
| Reading the results / "The card averages the error probabilities" | I cannot follow this. I do not know how a Phred score converts to an error probability, so I cannot picture the averaging. | Show the conversion once with a worked number. |
| Reading the results / "which is the honest way to" | Logarithmic scale is not glossed, and it is the load-bearing part of the explanation. | Gloss it, or drop it and keep the plain-language half. |
| The three charts / "plotted as a box for each" | I do not know what a box on this chart means. My class taught box plots with parts I could name, and I cannot tell if this is the same thing. | Say the box shows the spread of quality at that position. |
| The three charts / "which every Illumina run does" | I could not tell whether the falling quality is a defect I should worry about or normal behaviour, because the paragraph both flags it and shrugs at it. | State plainly that the decline is expected. |
| The three charts / "toward the 3' end, which every" | 3' is never explained. I have seen it in class but could not say which end of a read it is. | Gloss it as the end sequenced last. |
| The three charts / "and LGE applies it by default" | I was surprised that LGE changes my data during import. I could not tell whether this loses information or whether I can turn it off. | Say whether binning can be turned off and where. |
| The three charts / "Read a binned chart by which" | I do not know what to conclude from which spikes are tall. The sentence tells me how to look but not what to look for. | Say what a healthy set of tall spikes looks like. |
| The Reads tab / "It loads the first 1,000 records" | I could not tell whether those 1,000 records are representative or just the top of the file, which matters if I am hunting for a problem. | Say these are the first records in file order. |
| The Reads tab / "or a run of N characters" | N in a sequence is not glossed here. I guessed it means an unknown base. | Gloss N at first use. |
| What good looks like / "For Oxford Nanopore, judge by mean" | I do not know what Oxford Nanopore is or whether my data came from one. The chapter assumes I know my platform. | Say Illumina and Nanopore are two kinds of sequencer and that your provider tells you which. |
| What good looks like / "at the length your kit was" | I do not know what my kit was configured for, or where I would find that out. | Say the number comes from the sequencing provider's run report. |
| What good looks like / "A shift of more than about" | Two sentences earlier says "within a few percent is fine" and this one says five percent. I could not tell whether these are the same threshold. | Use one number in both sentences. |
| On the command line / "lungfish-cli fastq qc-summary writes the same" | I have never opened a terminal, so I could not run any of this. That part is fair, but the section holds facts I want, the shortest read length and the read 1 against read 2 comparison, that the app apparently will not show me. | Say up front which facts are command-line only. |
| On the command line / "then builds the three distributions from" | This worried me. On a real run, the charts I was told to trust would describe only part of the file. | Say whether that sample is large enough to trust. |

The one thing I learned: quality drops off toward the end of every Illumina read, so a sagging tail on the Q / Position chart is normal and only a mid-read drop below Q20 calls for trimming.

The one thing I still could not do: decide which mean quality figure is the real one, since the card says 24.9 and the command line says 34.9 for the same reads.

The sentence I liked most: "Look at these numbers before you spend an hour of compute on reads that were never going to give you an answer."
