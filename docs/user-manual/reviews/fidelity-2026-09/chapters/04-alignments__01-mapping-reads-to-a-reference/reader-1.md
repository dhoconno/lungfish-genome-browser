# Reader 1 report, Mapping Reads to a Reference

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Mapping takes two things, a pile" | I do not know what a read physically is here. The chapter assumes I already picture a pile of them. | One clause saying a read is one short stretch of sequence the machine reported. |
| What it is, "a score saying how sure the" | I did not know this score had a name until MAPQ appeared much later, and I had to connect them myself. | Name it MAPQ here at first mention. |
| What it is, "It also comes out with a" | I did not know why an index has to be a separate file, or whether I must keep it. | One sentence saying the .bai must stay beside the BAM. |
| What it is, "so switching mappers changes the answers" | "Changes the answers a little" gave me no way to judge whether that little matters for my work. | Point forward to the four-mapper comparison table. |
| Why you would do this, "or from a repeat that" | I have heard of repeats but not why a repeat makes an address ambiguous. | Half a sentence saying identical copies give the mapper no way to choose. |
| Why you would do this, "The slice holds 45,574 read" | I did not know what a read pair is, or why 45,574 pairs is 91,148 reads. The doubling was not explained. | Say a pair is two reads from the two ends of one fragment. |
| Why you would do this, "drawn from a 500 kb" | I had to work out that kb means kilobases and 500 kb is 500,000 bases. | Spell out kilobases at first use. |
| Before you start, "Download the files GRCh38.chr20.10.0-10.5Mb.fasta," | I do not know what a fixture is in this context, so I was unsure the three files were the fixture the frontmatter names. | Gloss fixture as the sample data set the manual uses. |
| Before you start, "Importing the FASTA produces a" | I could not tell what a .lungfishref folder is, or whether a folder that behaves like one item is normal on a Mac. | Say the Finder shows it as a single item. |
| Before you start, "Three of the four mappers" | I could not tell which three. I had to infer it is all but BBMap from the following sentence. | Name the three. |
| Before you start, "No Docker Desktop is needed" | I do not know what Docker Desktop is, so the reassurance meant nothing to me. | Cut it, or say some genomics apps need a separate container program and LGE does not. |
| Procedure, "The wizard has five sections" | Five sections are named but the numbered steps touch only three, so I could not tell whether I had skipped something required. | Say the other two are optional before the steps. |
| Procedure, "and it stops guessing the" | I could not tell what happens if I change the preset and then want the guess back. | Say whether reopening the wizard restores the guess. |
| Procedure step 5, "Check the Input Compatibility readout" | I was told to check it but not what a good reading is until after the step told me to click Run. | Say "confirm the last line begins with Ready". |
| Procedure, "then samtools view to drop" | I do not know which records count as unwanted or who decided that. | Say it drops the records the Advanced Settings excluded. |
| Procedure, "When every step turns green," | I do not know what a step looks like when it is not green, so I would not recognise a failure. | One clause on what a failed step looks like. |
| Settings, Reference, "It defaults to the first reference" | This alarmed me. I could not tell whether a wrong default would be obvious or would silently ruin the run. | Say the picker prints the path so you can check it. |
| Settings, Preset, "because short accurate reads and" | I did not know some sequencing machines produce noisy reads. This is the first mention of it. | Half a sentence saying long-read machines trade accuracy for length. |
| Settings, Mode, "For BWA-MEM2 and Bowtie2 it" | A picker holding exactly one option confused me. I thought the app had failed to load the list. | Say the picker is shown for consistency. |
| Settings, Run Mode, "and pouring them together loses" | This seems to contradict the earlier note that each bundle gets its own read group automatically. | Clarify that the automatic read groups apply only to separate runs. |
| Settings, Read Group lead-in, "such as joint variant callers," | I do not know what a joint variant caller is and it has no glossary link. | Gloss it as a caller that reads several samples at once. |
| Settings, ID, "and it accepts any text" | I did not know why spaces are forbidden here but allowed in Sample. | Say the BAM header format forbids them. |
| Settings, Platform, "as long as it still" | I read this three times and still cannot tell what happens if I typed my own value and then changed the preset. | Split it into two sentences. |
| Settings, Threads, "It defaults to the number" | I do not know how to find my core count, so I could not tell whether the default was right. | Say the number shown is your machine's count. |
| Settings, Secondary alignments, "with Bowtie2 adding -k 10" | These flags meant nothing to me and I do not know what to do with them. | Cut them, or say the exact flag is recorded in provenance. |
| Settings, Supplementary, "and note that the command-line" | A checkbox that is on paired with a flag named --no-supplementary confused me about which state is the default. | State the default plainly before naming the flag. |
| Settings, Min mapping quality, "since 60 is the practical" | I did not know what MAPQ 60 means in plain terms, only that it is the top of the range. | Say 60 means the mapper found one clearly best location. |
| Settings, Extra arguments, "and prints in the footer" | I do not know where the footer of a wizard is. | Say the bottom edge of the sheet. |
| Importing an alignment, "works out which reference assembly the" | I read this twice. "The file names" looked like a noun phrase before I saw that names is the verb. | Recast as "which assembly the file's header names". |
| Reading the results, "Total Mapped is how many" | Records and reads are used as if interchangeable here, but the Flag Stats paragraph says they differ. | Say record here, and warn that one read can make more than one. |
| Reading the results, "which is what a human" | I could not tell whether 44.7x is good because of the number itself or because it matches a convention. | Say why 30x to 50x is the usual target. |
| Reading the results, "Est. Coverage is the estimated" | Estimated by what method, and how far off can it be? I could not judge whether to trust it. | Say it is total mapped bases divided by reference length. |
| Reading the results, "Of those, 90,935 were placed" | The same 99.77% is given earlier for 90,990 out of 91,203. Two different fractions cannot both be 99.77%. | Recompute one of them. |
| Reading the results, "which is 99.19% of the" | I could not find the denominator. The table calls 91,148 primary, not paired, so I could not reproduce the figure. | Show the denominator. |
| Four mappers table, "Bowtie2 91,148 90,241 99.00%" | Bowtie2 shows the same record count as the input while 907 reads went unmapped, and I could not tell where the unmapped records sit. | Add an unmapped column, or say records include unmapped. |
| Four mappers, "because the four programs scale" | If the scales differ, I do not know how to compare a Bowtie2 MAPQ of 42 against the threshold of 20 suggested earlier. | Say the Min mapping quality advice is minimap2-scaled. |
| What good looks like, "which is expected in shotgun" | Pathogen shotgun sampling is a topic this chapter never sets up, and I am mapping human reads. | Use a human example, or drop it. |
| What good looks like, "and is diagnosed by running" | I do not know what classification is or where it lives in the app. | Link to the classification chapter. |
| What good looks like, "the mark of a corrupted" | I could not tell how to check whether my download was truncated. | Say compare the file size with the source page. |
| What good looks like, "nudges soft-clip boundaries by a" | Soft-clip is linked to the glossary but never explained here, and it is the last new term in the chapter. | One clause saying it is the trimmed end of a read. |
| On the command line, "This section is optional. Everything" | Relieved by this, but every Settings entry ends with a command-line flag, so I could not tell whether those were optional too. | Say the flags are named for reference only. |
| On the command line, "--bundle "$HOME/Desktop/lge-docs/LGE Manual" | This path belongs to somebody else's machine and nothing told me to substitute my own project folder. | Say to replace it with your project path. |
| On the command line, "--paired --mapper minimap2 --preset sr" | Three flags appear that no Settings entry mentions, and --paired is nowhere else in the chapter. | Note that --paired is set automatically in the window. |
| On the command line, "while a .lungfishref path works" | I read this sentence three times and still cannot tell whether I should pass the bundle or the FASTA. | Say to pass the FASTA. |

One thing I learned. A read is useless until mapping gives it an address, and stacking those addressed reads is what turns forty separate observations into one piece of evidence.

One thing I still could not do. Judge whether my own run went well when my numbers do not match the fixture's, because the percentages in Reading the results do not agree with each other and I could not tell which arithmetic to copy.

The sentence I liked most. "It could be from chromosome 20, or from a repeat that appears a million times over, and nothing in the FASTQ file says which."
