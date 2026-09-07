# Reader report: Quality Control for Reads

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "In Lungfish Genome Explorer (LGE) that step" | I do not know what a "viewport" is. The chapter uses it constantly and never says it is the big panel that shows the selected item. | Gloss viewport at first use. |
| What it is, "The numbers live in the FASTQ" | FASTQ is used before it is explained. I know DNA sequence but not this file format. | One sentence saying a FASTQ file holds reads plus a quality score for every base. |
| What it is, "LGE scans the reads and reports" | "Base calls" is new to me. I know bases, not base calls. | Gloss base call as the instrument's guess at which base sat at a spot. |
| What it is, "The charts show how those numbers" | I could not picture what "spread out rather than averaged" means for a chart I have not seen. | Name the thing being spread, for example how many reads sit at each length. |
| What it is, "The signature of adapter read-through" | I do not know what an adapter is or what read-through means, and the chapter tells me to wait a chapter for it. | A one-line gloss of adapter here, even if the fix waits. |
| Why you would do this, "bad alignments produce bad variant calls" | Alignment and variant calling are both undefined here. I could guess but I had to read it twice. | Gloss both in half a sentence. |
| Why you would do this, "The reads are 2x250 base pairs" | I could not read the notation 2x250. Is that 250 bases total or 500? | Say it means each fragment is read 250 bases from each end. |
| Before you start, "You need a project open." | Nothing tells me what a project folder should contain or whether it may be empty. | Say the folder can be a new empty one. |
| Before you start, "Refreshing the summary uses seqkit" | I do not know what seqkit or a pack is, and I could not tell whether I must install something. | Say plainly that LGE installs this for you and you do nothing. |
| Procedure step 1, "Click the HG002.chr20.10.0-10.5Mb bundle" | I did not know the sidebar had a folder named Imports, since I came here without doing the import chapter. | Say Imports is the folder LGE creates during import. |
| Procedure step 2, "Read the nine summary cards along" | I was told which four to read first, four sections before I was told what any of them mean. | Point forward to Reading the results in the same sentence. |
| Procedure step 5, "Confirm that the bundle listed in" | I did not know an Operations Panel existed or that a "row" appears in it for my run. | Say each run adds one line to that panel. |
| Procedure, "There is a second way in." | I could not tell which bundles are "derived from other bundles" or how I would recognise one. | Give one concrete example of a derived bundle. |
| Settings, "Output Strategy. Chooses whether the run" | I do not know what "one library" means as opposed to one sample, so I could not choose between Per Input and Grouped Result. | Gloss library. |
| Settings, "This setting has no command-line flag." | I never use a terminal, so I could not tell whether this sentence was a warning aimed at me. | Mark command-line asides as not needed for the app path. |
| Reading the results, "Reads, Bases 91,148 and 22,662,846" | I could not judge whether 91,148 reads is a lot or a little for a 500 kb window. | Say what read count this window should produce. |
| Reading the results, "Mean Length is the average read" | The N50 definition is dense and I read it three times, and I still could not see why anyone prefers it to the median. | Add why N50 is used at all. |
| Reading the results, "Mean Q deserves one note." | Two numbers for the same quantity, ten apart, alarmed me. I could not tell which one to write in a report. | Say outright which number to quote when reporting QC. |
| Reading the results, "The card averages the error probabilities" | I do not know the formula that turns a Phred score into an error probability, so I could not follow the argument. | Restate the relation here, Q20 means one error in a hundred. |
| The three charts, "Q / Position is per-position quality" | I have never had a box plot explained. I did not know what the box or the line inside it stands for. | One sentence saying the box covers the middle half of the values. |
| The three charts, "It is the chart that shows" | I know 3' from genetics, but not why sequencing quality should fall there in particular. | Say quality falls as the run goes on, and 3' is simply the end read last. |
| The three charts, "and LGE applies it by default" | I was surprised that the app changes my data on import, and I could not tell whether I may turn it off or whether I should. | Say whether binning is optional and whether it costs anything. |
| The three charts, "Read a binned chart by which" | The sentence stops before telling me what tall spikes mean. Tall where is good? | Say a binned run is healthy when the tall spikes sit at high scores. |
| The Reads tab, "or a run of N characters" | I had to guess that N means a base the instrument could not read. | Gloss N. |
| What good looks like, "For Oxford Nanopore, judge by mean" | I do not know what Oxford Nanopore is, whether my fixture is one, and no card is named "mean read quality". | Say Nanopore is a different instrument type and name the card to look at. |
| What good looks like, "A bundle that fails on any" | I could not tell whether trimming destroys my original reads or makes a new copy. | Say a trim makes a new bundle and leaves the original alone. |
| On the command line, "One report for the imported bundle's" | I have never opened a terminal, and this path does not match where I was told earlier to save the files. | Say this whole section is optional and can be skipped. |
| On the command line, "with the arithmetic mean quality at" | After the earlier warning about two kinds of mean, I could not tell whether these paired-read figures compare to the cards. | Repeat which kind of mean this is in the same sentence. |
| On the command line, "and then builds the three distributions" | I could not tell whether the charts I was told to trust in the Procedure are therefore only approximate. | Say plainly that on large files the charts are an estimate. |

One thing I learned: quality is not one number but a spread, and the same reads honestly give two different mean qualities depending on how you average a logarithmic scale.

One thing I still could not do: decide whether the charts I was looking at describe my whole file or only its first 100,000 reads, because that caveat arrives at the very end inside the section written for people who use a terminal.

The sentence I liked most: "Look at these numbers before you spend an hour of compute on reads that were never going to give you an answer."
