# Reader 2 report: Read Processing

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is: "The operations in this chapter change" | "The shape of a read rather than its quality" is abstract. I did not know what a read's shape was until three paragraphs later. | One example in the same sentence, like joining two mates into one sequence. |
| What it is: "Repair Paired-End Files puts mates" | I do not know what "an earlier step scrambled them" means. Which step? Something I did? | Name one common cause, such as a script that filtered one file only. |
| What it is: "Correct Sequencing Errors uses the depth" | "Depth of the whole dataset" is used before depth is explained. I only got a feel for it in the last section. | Gloss depth here as how many times each position was read. |
| What it is: "It emits protein FASTA, because" | I know FASTQ from the glossary link but protein FASTA is new and not linked. | A glossary link or a half-sentence saying FASTA is FASTQ without the quality lines. |
| Why you would do this: "A library preparation shears human DNA" | "Shears" and "library preparation" are bench words I half know, but I could not tell if the shearing is random or targeted, which matters for the insert numbers. | One clause saying the fragmentation is random. |
| Why you would do this: "the sequencer reads 250 bases inward" | I had to read this twice. "Inward from each end" only made sense once I drew it. | This is exactly where a diagram of a fragment with two arrows would settle it. |
| Why you would do this: "On this fixture the average insert" | The word "fixture" appears here for the first time with no explanation. I thought it meant a lab fixture. | Say "practice dataset" or gloss fixture at first use. |
| Before you start: "Merge, repair, and error correction run on BBTools" | BBTools, bbmerge, repair.sh, tadpole, vsearch, and Tadpole all appear as names. I could not tell which name goes with which operation. | A one-line list mapping each operation to its tool. |
| Before you start: "which LGE pins at version 40.02" | I do not know what pinning a version means or whether I have to do anything about it. | Say the app installs that exact version for you. |
| Procedure: "click Run. The dialog that opens is titled" | The order confused me. The third move says set the fields, but the dialog is only named after Run is mentioned. | Name the dialog before the four moves. |
| Merging: "Leave Strictness on Normal and Minimum Overlap at 12" | I could not tell whether these fields already hold those values when the pane opens or whether I must type them. | Say the pane opens with these values already set. |
| Repairing: "a read count that is not divisible by two" | I do not know where to find a read count in the app. Quality Control was recommended but not required reading. | Point to the exact place the count is shown. |
| Repairing: "The pane has no settings beyond the output strategy" | Output strategy is named here as if I already know it. It is only defined far below in Settings. | Define output strategy at first mention or link forward to it. |
| Correcting: "leave K-mer Size at 50" | k-mer is in the glossary list but not linked in this sentence, and I did not know why 50 was a length in bases. | Link k-mer here and say 50 bases. |
| Flipping: "Import GRCh38.chr20.10.0-10.5Mb.fasta as a reference first" | I do not know how to import something "as a reference" as opposed to a normal import. No link is given. | A link to the chapter that covers importing a reference. |
| Flipping: "run Orient Reads from the FASTQ viewport's" | I could not find the FASTQ viewport from this text alone. I do not know what opens it. | One sentence saying how to open the viewport for a bundle. |
| Settings, Merge: "On the command line this is --strict" | The command line is optional for me, so these trailing sentences kept pulling my eye to something I was told to skip. | A note that these lines belong to the last section. |
| Settings, Correct: "the command line caps the value at 62" | I read this three times. It sounds like the dialog will let me enter a value that then fails. I do not know what number is safe. | State the largest value the dialog will actually accept. |
| Settings, Orient: "Shorten it when many reads come back unoriented" | I do not know how many is many. Twenty-three out of 950 later sounded fine, but I had no threshold. | Give a rough percentage that counts as too many. |
| Settings, Orient: "Extra vsearch options passed straight through" | I have never seen vsearch and do not know where its options are documented. | A pointer to where vsearch options are listed. |
| Reading the results: "which it reports as 70.283 percent" | I could not find where in the app this report appears. The Operations panel was mentioned earlier but not connected to these numbers. | Say where in the panel the numbers appear. |
| Reading the results: "standard deviation of 63.9" | I know standard deviation from a stats course but not how to judge 63.9 here. Is a wide spread bad? | One clause saying what a wide or narrow spread implies. |
| Reading the results: "Tadpole read the same 91,148 reads" | 91,148 appears with no explanation. Elsewhere the fixture is 45,574 pairs. It took me a minute to see it is twice that. | Say this is both mates counted separately. |
| Reading the results: "of those it fully corrected 24,219" | 24,219 plus 935 is not 30,929 and I could not tell what happened to the rest. | Account for the remaining reads in one clause. |
| Reading the results: "On 950 nanopore reads from a" | The whole chapter used HG002 until now. I could not tell whether this is an exercise I can run or a different dataset. | Say plainly that this example is not in the practice files. |
| Reading the results: "it placed 439 forward and 488" | The sums are right but I had to check both by hand to trust the 97.58 percent. | Stating the arithmetic once would save the reader doing it. |
| What good looks like: "A rate very close to 100 percent" | "Over-fragmentation during library preparation" is a problem I have heard of but I do not know what I would do about it from here. | Say whether the fix is at the bench or in the software. |
| What good looks like: "so it needs depth. On thin coverage" | Depth and coverage are used as if interchangeable and neither is glossed in this chapter. | Gloss coverage once and say whether it is the same as depth. |
| What good looks like: "If your dataset has only a few" | "A few" is the only guidance and I do not know how to find out how many reads sit over a position. | A number, and a pointer to where the app shows coverage. |
| On the command line: "If you have never used a terminal" | I skipped it as told, then found that reading frames other than 1 and the discarding of unoriented reads are only explained inside the skipped section. | Move the frame limitation and the orient discard note into the main text. |

One thing I learned. Merging paired reads works because the two mates overlap in the middle when the DNA fragment was shorter than the two reads put together, and that overlap gives both extra length and a second measurement of the same bases.

One thing I still could not do. Import the chromosome 20 FASTA as a reference sequence, which Orient Reads needs, because the chapter tells me to do it but never says how or where.

The sentence I liked most. "The gap between detected and corrected is not a failure. It is the tool declining to change a base when the evidence for the replacement was not strong enough, which is the behaviour you want."
