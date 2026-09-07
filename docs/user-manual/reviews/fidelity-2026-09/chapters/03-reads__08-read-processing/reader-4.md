# Reader report: Read Processing

Persona: a student who used Geneious in one class. I have taken genetics. I
have never opened a terminal. In Geneious I clicked buttons and looked at
pictures, so I know some words like "assembly" and "reference" but I have
never had to set a number myself.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| Front matter, "tools: [bbmerge, repair.sh..." | I do not know what any of these five names are, and one of them has a `.sh` on it that looks like a file rather than a program. | Say in one sentence that these are the outside programs LGE runs for you. |
| What it is, "The operations in this chapter change..." | "Change the shape of a read rather than its quality" sounded like a metaphor and I had to read it twice before the trimming comparison made it land. | Put the trimming contrast in the same sentence as the word shape. |
| What it is, "Merge Overlapping Pairs joins the two..." | I did not know what a "mate" was until much later, and here it is used as if I already do. | Gloss mate at this first use. |
| What it is, "Repair Paired-End Files puts mates back..." | "Their proper order" does not tell me what order that is, so I could not picture what broken looks like. | Say the order is R1 then R2 for each fragment. |
| What it is, "Correct Sequencing Errors uses the depth..." | I do not know what "depth of the whole dataset" means as a quantity. | Gloss depth as how many reads cover the same position. |
| What it is, "there is no sensible way to carry three..." | I followed the arithmetic but not why quality scores cannot just be averaged, and the sentence asserts it rather than explaining. | One clause saying an averaged score would be misleading. |
| What it is, "In every case the input file is read and never written" | I read this twice. "Read and never written" sounds like nothing happens at all. | Say the input file is never modified. |
| Why you would do this, "Its two files hold 45,574 read pairs" | I could not tell whether 45,574 pairs means 45,574 reads or 91,148 reads until a number much later in the chapter forced the answer. | State both numbers here once. |
| Why you would do this, "all sequenced from a 500 kb window" | I do not know kb as a unit of DNA here, and I could not judge whether 500 kb is a big or small piece of a chromosome. | Expand kb once and say what fraction of chromosome 20 that is. |
| Why you would do this, "A library preparation shears human DNA" | "Library preparation" and "shears" are both new to me as lab terms. | Gloss library at first use. |
| Why you would do this, "so most pairs overlap by roughly 130 bases" | I could not reproduce 130 from 371 and 250 in my head on the first pass. | Show the subtraction the way the later Reading the results section does. |
| Before you start, "Download the files ... from the manual's practice data files" | The instruction to click a filename then click a download button is the only place the manual tells me the plain link does not work, and I nearly downloaded a web page instead. | Give the direct download link. |
| Before you start, "The import stores a paired sample inside its bundle as one interleaved file" | I did not know what a bundle is. It appears here and in the sidebar instructions as if defined earlier. | Gloss bundle at first use in this chapter. |
| Before you start, "which LGE pins at version 40.02" | I do not know what pinning a version means or whether I have to do anything about it. | Say LGE installs that exact version for you. |
| Before you start, "the one pack LGE installs by itself" | I could not tell whether I still need to open Plugin Manager or whether that is optional. | Say the check is optional. |
| Procedure, "Results land under `Analyses/` in your project" | The example bundle name `-mergeOverlappingPairs` does not match the menu wording closely enough for me to have predicted it. | Say the suffix comes from the operation name with the spaces removed. |
| Merging, step 3, "Leave **Strictness** on Normal and **Minimum Overlap** at 12" | I could not tell whether 12 is bases, percent, or a score until the Settings section, which is two pages later. | Put the unit in the step. |
| Repairing, "a read count that is not divisible by two" | I do not know where to see the read count, and the Quality Control cross-reference is back in Before you start rather than here. | Repeat the cross-reference at the symptom. |
| Repairing, "because repairing is a matter of sorting records rather than of judgement" | I had to read this twice. It explains the absence of settings by an analogy I did not follow. | Say there is nothing to tune. |
| Correcting errors, "leave **K-mer Size** at 50" | The k-mer glossary link is in the front matter but not in this sentence, and I did not know what a k-mer was when I hit this step. | Link k-mer at this first use in the body. |
| Flipping and orienting, "Import `GRCh38.chr20.10.0-10.5Mb.fasta` as a reference first" | I do not know how to import something as a reference rather than as reads, and no cross-reference is given. | Point to the chapter that covers importing a reference. |
| Flipping and orienting, "the pane says so under its advanced settings" | I did not see any advanced settings mentioned anywhere before this, so I did not know where to look. | Name the disclosure control. |
| Flipping and orienting, "run Orient Reads from the FASTQ viewport's Operations tab instead" | I do not know what the FASTQ viewport is or how to get to it. This is the only route to keeping my reads and I could not take it. | Say how to open the viewport. |
| Settings, Strictness, "where Strict rejects overlaps that look marginal" | The pane has segments and I only ever learn two of their names, Normal and Strict. I could not tell if there is a third. | List every segment. |
| Settings, Strictness, "On the command line this is `--strict`" | The setting has at least two values but the flag shown is a bare switch, so I could not map Normal onto it. | Say what the flag does for each value. |
| Settings, Minimum Overlap, "lower it only when you know your inserts are close to twice the read length" | This is the opposite of what I expected, since close to twice the read length is where overlap is smallest, and I had to read it three times. | Say lowering helps only barely-overlapping pairs. |
| Settings, Output Strategy, repeated five times | Five near-identical paragraphs made me stop reading carefully, and I nearly missed that the error-correction one has a different reason attached. | Cross-reference instead of repeating. |
| Settings, K-mer Size, "the command line caps the value at 62 while the dialog accepts any positive number" | I could not tell what happens in the window if I type 80. The sentence says the tool rejects it but not what I see. | Say what the error looks like. |
| Settings, Word Length, "short enough to find a match in noisy long reads" | The chapter's example is 250 base Illumina reads, so a justification about long reads did not connect to the run I am doing. | Justify 12 for the fixture at hand. |
| Settings, Database Mask, "the dust method masks low-complexity sequence" | Dust is a program name being used as a method name and I could not tell which. | Say dust is the name of the masking method. |
| Settings, Extra arguments, "unchecked by LGE before vsearch sees them" | I could not tell whether a typo here breaks the run silently or loudly. | Say a bad option makes the run fail. |
| Settings, Translate, "The dialog fixes the reading frame at 1" | I know what a codon is but not why a read would be read in six different ways, so I could not tell whether frame 1 is a limitation I should worry about. | One sentence on why frame matters for a read. |
| Reading the results, "which it reports as 70.283 percent" | Three decimal places on a percentage made me think it was a precise measurement rather than a tool's output format. | Say the tool prints that precision. |
| Reading the results, "standard deviation of 63.9" | I know the term from a stats class but not how to judge 63.9 against a mean of 371.5 for this purpose. | Say what a wide or narrow spread would mean. |
| Reading the results, "which is what you would expect if the ceiling is a real limit of the method" | I read this twice. The distinction between a limit of the method and a property of the library did not resolve for me. | Say the 500 base span is the cause. |
| Reading the results, "Tadpole read the same 91,148 reads" | This is the first place the total read count appears, and it silently answers the pairs-versus-reads question I had at the top of the chapter. | State 91,148 in the Why section. |
| Reading the results, "it fully corrected 24,219 and partly corrected 935" | 24,219 plus 935 is 25,154, not the 30,929 reads said to have a suspect base, and I could not account for the difference. | Say what happened to the remaining reads. |
| Reading the results, "It detected 122,406 errors and corrected 42,033 of them" | Correcting a third of detected errors sounded alarming until the paragraph reassured me, but the reassurance comes three sentences later. | Put the reassurance next to the number. |
| Reading the results, "Run on a copy of this fixture with 228 mates deliberately removed" | I could not tell whether I should make such a copy myself to follow along, or just read the numbers. | Say this example is not a step to repeat. |
| Reading the results, "On 950 nanopore reads from a human mitochondrial dataset" | The chapter switches datasets here without warning and I lost track of which numbers belong to which file. | Flag the dataset change. |
| Reading the results, "which is 250 bases divided by three with one base left over" | I followed the arithmetic but not what happens to the leftover base. | Say the leftover base is dropped. |
| Reading the results, "as in `_frame+1 [Standard] [83 aa]`" | I could not tell if this is appended to my read names or replaces them. | Say it is appended. |
| What good looks like, "Check the merge rate first." | I do not know how to see my own merge rate. The number is quoted from the run but I was never told where in the Operations panel to read it. | Say where the rate is printed. |
| What good looks like, "which often points to over-fragmentation during library preparation" | I do not know what over-fragmentation would mean I should do next. | Say whether the data is still usable. |
| What good looks like, "Read them as a lower bound on your true insert size" | I had to read this twice to see why leaving out long fragments biases the average downward. | Say long fragments are missing from the average. |
| What good looks like, "On thin coverage there is not enough repetition" | "Thin coverage" and "a few reads over each position" are the closest the chapter comes to a number, and I could not tell if my data qualifies. | Give a rough threshold. |
| On the command line, "If you have never used a terminal, skip this" | I did skip it, then had to come back because the Translate settings section says frame control is described here, so the skip instruction and the cross-reference conflict. | Note that one setting is command-line only. |
| Next, "This is the last chapter in Reads (FASTQ)" | The link is a bare dot and I could not tell what it points to. | Name the destination. |

One thing I learned: merging does not throw anything away, because the pairs
that fail to join are written out as two separate reads, so the output record
count is the joined pairs plus twice the unjoined pairs.

One thing I still could not do: keep the reads that Orient Reads could not
place, because the chapter tells me to use the FASTQ viewport's Operations
tab without telling me how to open the FASTQ viewport.

The sentence I liked most: "The 32,031 joined pairs each became one record.
The 13,543 unjoined pairs kept both mates, contributing 27,086 records."
