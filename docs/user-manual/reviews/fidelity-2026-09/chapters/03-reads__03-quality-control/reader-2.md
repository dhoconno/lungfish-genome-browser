# Reader report: Quality Control for Reads

Reader 2. Senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is — "Quality control is the step where" | "Fit to analyse" is the whole judgement I am here to learn, and nothing yet says what makes reads unfit. | Say in one sentence that unfit means the base calls are too uncertain to trust. |
| What it is — "The numbers live in the FASTQ" | I do not know what a viewport is. The word is used as if I already do. | Gloss viewport as the big panel on the right the first time. |
| What it is — "LGE scans the reads and reports" | Nine numbers, but only five card rows appear later in the table, so I could not tell which nine. | Name the nine in one line here. |
| Why you would do this — "Bad reads produce bad alignments" | I have never aligned anything, so alignment as a consequence means nothing to me yet. | Gloss alignment in half a sentence. |
| Why you would do this — "A read-length distribution spread over" | I do not know what long reads are versus the Illumina pair, or why the spread tells them apart. | Say Illumina reads are all one length and long reads are not. |
| Why you would do this — "The reads are 2x250 base pairs" | I could not decode 2x250. Two files? Two runs? Both ends? | Spell out that 2x250 means both ends of each fragment read for 250 bases. |
| Why you would do this — "a 500 kb window of chromosome" | I did not know whether 500 kb is a lot or a little for this purpose. | Say it is a small slice chosen to keep the download quick. |
| Before you start — "Refreshing the summary uses seqkit" | seqkit and Required Setup pack both arrive undefined, and I could not tell if I must do anything. | Say seqkit installs itself and you do nothing. |
| Procedure step 1 — "Click the HG002.chr20.10.0-10.5Mb bundle" | The bundle name has no _R1 or _R2, and I imported two files, so I did not know if I was looking at the right thing. | Say import merges the pair into one bundle name. |
| Procedure step 2 — "Read the nine summary cards along" | I was told to take four numbers first but not what to compare them against until six sections later. | Point forward to Reading the results in the same sentence. |
| Procedure step 5 — "Confirm that the bundle listed in" | I did not know if I must open the Operations Panel before clicking Run, or whether it matters at all. | Say the run works whether or not the panel is open. |
| Procedure — "There is a second way in." | Bundles "derived from other bundles" is never explained, so I could not tell whether mine is one. | Say a derived bundle is one made by an operation, not by import. |
| Settings — "Chooses whether the run writes one" | This sentence carries three ideas and I read it three times before Per Input and Grouped Result separated. | Split the default off into its own sentence. |
| Settings — "This setting has no command-line flag." | I do not use the command line, so I could not tell whether this warns me about something. | Drop the sentence or say it concerns terminal users only. |
| Reading the results — "Reads, Bases 91,148 and 22,662,846" | Bases is 22 million and I had no way to judge whether that is enough for anything. | Say what depth this gives over the 500 kb window. |
| Reading the results — "Mean Length, Median Length, N50" | N50 is glossed as a length where half the bases sit in longer reads, and I still could not see why anyone needs it when the reads are all 250. | Say N50 matters for long reads and is nearly flat here. |
| Reading the results — "A count far below what your sequencing" | Providers quote clusters or gigabases to me, not read counts, so I could not do the comparison. | Say the provider figure may be in millions of reads or in gigabases. |
| Reading the results — "A mean well below the median, as here" | I could not tell whether 1.4 bases counts as the small tail or the large one, since both terms follow. | Give a rough number where small becomes large. |
| Reading the results — "The card reads 24.9 while the same" | Two correct answers ten points apart shook my confidence in the whole card. I read this paragraph three times. | State up front that the card is the conservative one. |
| Reading the results — "which is the honest way to average" | I do not know what a logarithmic scale is, so the reason the two figures differ stayed opaque. | One clause saying low scores count far more than high ones. |
| The three charts — "Q / Position is per-position quality" | I have never seen a box plot and did not know what the box edges mean. | Say the box spans the middle half of the bases at that position. |
| The three charts — "It is the chart that shows quality" | I know 3' from a genetics course but not that it means the end of the read here. | Say the 3' end is the last bases sequenced. |
| The three charts — "On this fixture the mean holds above" | I could not tell why quality rises to a peak at base 14 instead of starting high. | One clause saying the first bases are always noisier. |
| The three charts — "Quality binning rounds each score" | If LGE bins my reads by default, I could not tell whether that loses information I need. | Say binning does not change the analysis result. |
| The three charts — "Read a binned chart by which spikes" | I still did not know which spike heights are the good ones. | Say a tall spike at Q37 is the healthy pattern. |
| The Reads tab — "A header that does not look the way" | N is never glossed and I only guessed it means an unknown base. | Gloss N as a base the instrument could not call. |
| What good looks like — "For Oxford Nanopore, judge by mean" | A second platform appears with different rules and no numbers, leaving me unsure what to do if I ever get such data. | Give a rough Nanopore mean read quality figure. |
| What good looks like — "Check that Q30 sits where the platform" | Here 80% is healthy, but earlier the chapter said below 70% means trouble, so the band between them is undefined. | Use one threshold in both places. |
| What good looks like — "Check that GC lands near the value" | Percent versus percentage points is ambiguous, and for GC near 41 those differ a lot. | Say five percentage points if that is what is meant. |
| What good looks like — "Low quality across the read is fixed" | Sliding window means nothing to me and I could not set one from this. | Cut the phrase or gloss it in the trimming chapter only. |
| On the command line — "lungfish-cli fastq qc-summary writes" | I have never opened a terminal, and nothing tells me I may skip this whole section. | Open the section by saying the app already does all of this. |
| On the command line — "On this fixture read 1 reports Q30" | After the 24.9 versus 34.9 warning I could not tell which of my card numbers these compare to. | Say these are command-line figures only. |
| On the command line — "One difference is worth knowing" | Cards from the whole file and charts from a sample is a real caveat I would never have guessed from the app. | Move this warning up beside the charts. |

Learned: the four numbers that decide whether reads are usable are Mean Q, Q20, Q30, and GC, and they are already computed before I click anything.

Could not do: judge my own data against the thresholds, because Q30 is given as both 70% and 80% and the GC tolerance is given in ambiguous percent.

Liked most: "Look at these numbers before you spend an hour of compute on reads that were never going to give you an answer."
