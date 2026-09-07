# Reader 1 report: Primer Trimming an Alignment

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Primer trimming at the alignment level removes..." | "At the alignment level" is doing a lot of work in the first four words, and I did not know there was another level until much later. | Say plainly that trimming can happen before or after mapping and this chapter is the after. |
| What it is, "LGE packages a scheme as a..." | I do not know what a manifest is. It is not glossed or linked on that line. | Gloss manifest at first use, the way primer and amplicon are glossed. |
| What it is, "a manifest naming the protocol and..." | Provenance appears here but is only linked to the glossary many paragraphs later in Reading the results. | Link and gloss provenance at this first use. |
| What it is, "It changes the letter in the read's CIGAR string..." | I read this three times. I could not tell whether M and S are single letters inside one long string or the names of two formats. | One example CIGAR string shown before and after, so I can see the letters change. |
| What it is, "the stack of read bases sitting over one reference position." | I could follow the words but I could not picture a pileup, and there is no figure anywhere in the chapter. | A small drawing of reads stacked over one column. |
| Why you would do this, "primers are frequently written with deliberate mismatches" | I did not know a primer could be deliberately wrong and still work. It seemed to contradict the earlier sentence saying a primer binds a chosen spot. | One clause saying a primer tolerates a few mismatches and still binds. |
| Why you would do this, "It reproduces on every rerun, it sits" | I did not understand why reproducibility makes an error harder to catch. I had assumed reproducible meant trustworthy. | Say that the usual way to spot a mistake is that it wobbles between runs, and this one does not. |
| Why you would do this, "iVar's own variant caller expects a primer-trimmed input" | This is the first hint that iVar both trims and calls variants. I had assumed iVar was one tool that did one thing. | Say iVar is a toolkit with several commands where iVar is first introduced. |
| Why you would do this, "a QIAseq Direct amplicon library of 86,281" | I could not judge whether 86,281 read pairs is a lot or a little, and the chapter calls it clinical-scale without saying what that means. | A sentence saying what read count range this kind of run normally lands in. |
| Before you start, "Primer trimming uses iVar and samtools" | I did not know a pack is a thing I install, how long installing takes, or whether it needs the internet. | One sentence saying what a pack is and that installing needs a network connection. |
| Before you start, "mapping placed 171,355 of 172,562" | I could not tell whether my own mapping number has to be near 99.30% before I am allowed to continue. | Say what mapping rate is low enough that I should stop and fix the mapping first. |
| Procedure, "Click the MN908947.3 reference bundle in" | I did not know whether the alignment track is nested inside the bundle and needs a disclosure triangle clicked first. | Say the track sits under the bundle and may need expanding. |
| Opening the dialog, "In the Inspector, open the Analysis" | Six tabs are mentioned but never named, so I could not confirm I was looking at the right grid. | Name the six tabs, or say where the Primer Trim tab sits in the grid. |
| Opening the dialog, "Open the Primer Scheme menu. Eight" | I had no way to know which of the eight built-in schemes matches my own library if I were not following the worked example. | Say where in my own lab paperwork the scheme name is recorded. |
| Setting the target, "Read the Target section. Its Alignment" | I do not know what an index is or how I would get one if mine were missing. | One clause saying an index is a companion file the mapping step writes automatically. |
| Setting the target, "Leave Advanced Options collapsed. It holds" | I could not tell whether leaving them collapsed is a real recommendation or just what the example happens to do. | State that the defaults are correct for nearly every run. |
| Settings, "Minimum quality. Sets the quality floor" | I did not expect a primer trim to also cut for quality, and this is the first time that is said. An earlier chapter already trimmed for quality, so I thought that was finished. | Say up front in What it is that iVar does a quality trim as well as a primer trim. |
| Settings, "The default is 20, a Phred" | The number and the error rate did not connect for me. I could not work out why 20 gives one in a hundred rather than one in twenty. | Give a second data point, that 30 means one in a thousand, so I can see the pattern. |
| Settings, "Sliding window width. Sets how many" | I could not picture a window walking in from the read end, or what happens at the moment the average fails. | One sentence saying what iVar does when the window average drops below the floor. |
| Settings, "Primer offset. Shifts every primer coordinate" | I could not imagine how I would ever establish that my coordinates are off by a fixed amount. | Name the symptom that points at an offset, such as a low trim rate with a scheme you trust. |
| Reading the results, "If you do not see them," | I could not find where the read display controls live. The Inspector was described earlier as having an Analysis section, not display controls. | Say which Inspector section holds that toggle. |
| Reading the results, "Soft-clipped bases on the reference run" | Matched bases fell by about 8.1 million but clipped bases rose by only 6.6 million. I could not account for the difference and worried I had misread something. | One clause saying the discarded short reads account for the gap. |
| Reading the results, "0.79% (1360) of reads started" | The log mentions a `-e` flag that appears nowhere in the dialog or the Settings list, so I did not know whether I had set it. | Say that LGE always passes `-e` and that this is what the dialog's retention note means. |
| Reading the results, "The alignment held 172,562 records before" | 172,562 minus 164,704 is 7,858, but the log lists 6,651 short reads and 1,207 unmapped. I had to do the arithmetic myself to trust the paragraph. | Show the subtraction, since the reader will do it anyway. |
| What good looks like, "Three quarters of the reads found" | I did not know whether 13.44% would have looked alarming on its own without the good run beside it. | Say what soft-clipping percentage should make me suspicious when I have no comparison run. |
| What good looks like, "which are the same SARS-CoV-2 genome" | I did not know one genome could have two accessions, and this made me distrust accession numbers generally. | One clause saying duplicate deposits are common and both names are valid. |
| On the command line, "The identifier is the short `aln_`" | I have never opened a terminal, and I do not know how to look inside a folder named something.lungfishref to read a file. | Say whether the identifier is also shown somewhere in the Inspector. |
| On the command line, "`--format json` prints one JSON object" | I do not know what JSON is and it is not glossed. | Gloss JSON, or drop the flag from a chapter aimed at bench readers. |
| On the command line, "To build a scheme LGE does" | This paragraph sits under a command-line heading but describes a menu procedure, so I nearly skipped it. | Give the scheme import its own heading. |

One thing I learned. Soft-clipping does not delete bases, it only marks them so the variant caller looks past them, which means the file keeps every base and the original reads stay recoverable.

One thing I still could not do. Judge my own run, because I could not find a threshold anywhere for the trim rate below which I should stop and change the scheme, only the two example numbers of 99.15% and 22.13%.

The sentence I liked most. "A wrong scheme is silent, so the trim rate in the log is your only check, and you should read it every time."
