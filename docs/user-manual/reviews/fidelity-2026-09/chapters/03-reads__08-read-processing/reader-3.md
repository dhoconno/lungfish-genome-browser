# Reader report: Read Processing

Reader 3. Pre-med student, English is my second language. I have taken
genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "The operations in this chapter change" | "change the shape of a read rather than its quality" is a metaphor I had to read twice. A read is text to me, so "shape" means nothing yet. | Say plainly that these operations rewrite or rearrange reads and keep all of them. |
| What it is / "Repair Paired-End Files puts mates" | "mates" is used before it is explained. I guessed it means the two reads of a pair, but I was not sure it was not a biology word about breeding. | Gloss "mate" at first use, next to paired-end. |
| What it is / "Correct Sequencing Errors uses the" | "uses the depth of the whole dataset" - I do not know what depth is here. Depth of what? | Gloss depth or coverage at first use. It is needed again in What good looks like. |
| What it is / "Two more shape-changing utilities exist" | Told me these live only on the command line, but the chapter later tells me to skip the command-line section. So I never learn whether I need interleave. | One sentence saying whether a window-only user ever needs interleave. |
| Why you would do this / "The chapter's worked example is" | "chromosome 20 slice" - slice is not defined. I guessed it means a piece of the chromosome. | Say "a 500 kb region of chromosome 20" the first time. |
| Why you would do this / "A library preparation shears human DNA" | "library preparation" and "shears" are both new to me in this sense. I know library as a building. | Gloss library and library preparation. |
| Why you would do this / "When the insert is shorter than" | I had to draw this on paper before I saw why 500 is the threshold. The arithmetic only appears much later. | Say "500 is 250 plus 250, the two reads together" right here. |
| Why you would do this / "so most pairs overlap by roughly 130" | I could not reproduce 130 from 371. Later the chapter says 129 from the same numbers. Two numbers for one thing confused me. | Use one number and show 500 minus 371. |
| Why you would do this / "such as assembly or a search" | "assembly" appears with no explanation and no glossary link, unlike other terms here. | Gloss assembly or link it. |
| Why you would do this / "Repair rescues a paired file that" | "some upstream script left out of step" - I do not know what an upstream script is. I have no scripts. | Say what would have done this to my file. |
| Before you start / "click Create Project on the Welcome" | I do not know what the Welcome window is or when it appears. | One clause saying it is the window shown at launch. |
| Before you start / "which LGE pins at version 40.02" | "pins" in this sense was unfamiliar. I first thought of a pin on a map. | Say "uses version 40.02" or "fixes the version at". |
| Before you start / "Nothing else needs installing." | I could not tell whether I must open Plugin Manager and act, or whether checking is optional. | Say explicitly that no action is required unless the pack is missing. |
| Procedure / "in a bundle named from the input file stem" | "file stem" is new. I guessed it is the name without the extension. | Write "the filename without .fastq.gz". |
| Procedure / "The pane has no settings beyond the output strategy" | Output Strategy appears here for the first time in the Procedure but was never introduced. The merge steps never mentioned it. | Introduce Output Strategy once in Procedure, before it is referenced. |
| Repairing / "a read count that is not divisible by two" | I do not know where to find the read count in LGE. The chapter points to another chapter but not to a place on screen. | Name the panel or field where the read count is shown. |
| Correcting sequencing errors / "leave K-mer Size at 50" | I do not know what a k-mer is at this point. There is no gloss or link in the body here. | Gloss k-mer where it first appears in the Procedure. |
| Flipping, orienting / "Import GRCh38.chr20... as a reference first" | I do not know how to import a reference. Importing reads has a chapter link. Importing a reference has none. | Link to the reference-import chapter. |
| Flipping, orienting / "run Orient Reads from the FASTQ viewport's" | I do not know what the FASTQ viewport is or how to reach its Operations tab. This is the only way to keep reads, and I cannot follow it. | Say how to open the viewport, or link a chapter. |
| Settings / "where Strict rejects overlaps that look marginal" | "marginal" was hard, and I cannot judge what "look marginal" means without knowing what evidence bbmerge weighs. | Replace marginal with "weakly supported". |
| Settings / "Switch to Strict when merged reads are showing" | I would not know how to see mismatches in the joined region. No procedure is given for looking. | Point to where mismatches would be visible. |
| Settings / "lower it only when you know your inserts" | I do not know my insert size before I merge, and the chapter says the merge estimate is biased. The advice is circular for me. | Say how to learn insert size independently. |
| Settings / "Choose Grouped Result when several files" | This exact sentence repeats in six places. By the fourth I stopped reading Output Strategy entries, so I missed that the error-correction one gives a different reason. | Say it once and cross-reference. |
| Settings / "note that the command line caps the value" | Confusing. I was told to skip the command line, then a command-line cap of 62 sits inside a window setting. I could not tell if it applies to me. | State the dialog's own accepted range for window users. |
| Settings / "The default is 12 bases, which is short enough" | Word Length 12 and Minimum Overlap 12 are both "12 bases" and both about matching. I mixed them up on second reading. | Add a clause naming what each 12 counts. |
| Settings / "the dust method masks low-complexity sequence" | "low-complexity" and "poly-A tract" are both new. I guessed poly-A from genetics but not tract. | Gloss low-complexity and poly-A tract. |
| Settings / "unchecked by LGE before vsearch sees them" | I did not understand the risk. Does a wrong option damage my data or just fail? | Say what happens on a bad option. |
| Reading the results / "which it reports as 70.283 percent" | I do not know where this report is shown. Operations panel? A log file? | Name where to read these numbers. |
| Reading the results / "labels \"No Solution\", meaning it found no" | I could not tell whether No Solution is text I will see on screen or an internal label. | Say where the label appears. |
| Reading the results / "standard deviation of 63.9" | I know the term from statistics class but cannot judge 63.9. Is that tight or wide for a library? | Say what a good spread looks like. |
| Reading the results / "the fragments near or above 500" | This is the explanation I needed several pages earlier in Why you would do this. | Move or foreshadow the 500 arithmetic earlier. |
| Reading the results / "The output file holds 59,117 records" | I do not know how to see the record count of my own output in LGE. The arithmetic is shown but not how to check it myself. | Say where the output read count is displayed. |
| Reading the results / "Tadpole read the same 91,148 reads" | 91,148 arrives with no derivation. I had to compute 45,574 times 2 myself before I believed it. | Say it is both mates of the 45,574 pairs. |
| Reading the results / "it fully corrected 24,219 and partly" | 24,219 plus 935 is 25,154, not 30,929. I could not reconcile these and spent several minutes on it. | Say what happened to the remaining reads. |
| Reading the results / "It detected 122,406 errors and corrected" | These count errors, but the nearby numbers count reads. I confused the two units on first reading. | Label the units in each sentence. |
| Reading the results / "On 950 nanopore reads from a human" | The chapter uses HG002 Illumina reads throughout, then this result switches dataset and instrument with no warning. I thought I had lost my place. | Flag the dataset change in the same sentence. |
| Reading the results / "439 forward and 488 reverse, oriented 927" | The arithmetic works, but the numbers arrive out of order so I had to check twice. | Order them input, forward, reverse, unoriented. |
| Reading the results / "which is 250 bases divided by three" | 250 divided by 3 is 83 remainder 1, correct, but I did not know what happens to the leftover base. | Say the leftover base is discarded. |
| Reading the results / "as in `_frame+1 [Standard] [83 aa]`" | I do not know where I would see this header. In the app? In a text editor? | Say where headers are visible. |
| What good looks like / "A rate in the low single digits" | "low single digits" is an idiom I had to translate. | Write "below about 5 percent". |
| What good looks like / "which often points to over-fragmentation" | I do not know what I would do about over-fragmentation. No action is suggested. | Say whether to redo the library or proceed anyway. |
| What good looks like / "Read them as a lower bound on your" | I understand lower bound but cannot act on it. Nothing tells me how much lower. | Say whether the bias is small or large. |
| What good looks like / "It leans on seeing the same true base" | "leans on" is idiomatic and slowed me down. | Write "depends on". |
| What good looks like / "If your dataset has only a few reads" | "a few" is not a number, and this is exactly the decision the paragraph asks me to make. | Give a threshold, for example fewer than 10 reads per position. |
| On the command line / "skip this whole section" | I skipped it as told, but three window settings had already pointed at command-line flags and at the cap of 62. Skipping loses me things I was told matter. | Keep window-relevant facts out of the CLI-only section. |

One thing I learned. Merging works because the two reads of a pair overlap
in the middle whenever the DNA fragment is shorter than the two read lengths
added together, and that shared middle was measured twice so it is more
trustworthy than either read alone.

One thing I still could not do. Keep the reads that Orient Reads cannot
place. The chapter says to use the FASTQ viewport's Operations tab, but it
never tells me how to open that viewport or find that tab.

The sentence I liked most. "The gap between detected and corrected is not a
failure. It is the tool declining to change a base when the evidence for the
replacement was not strong enough, which is the behaviour you want."
