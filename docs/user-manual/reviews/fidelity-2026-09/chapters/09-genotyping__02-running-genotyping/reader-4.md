---
role: undergraduate-reader
persona: Geneious user, one semester, never opened a terminal
chapter: 09-genotyping/02-running-genotyping
date: 2026-09-07
---

# Reader 4 report: Running Amplicon MHC Genotyping

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "one or more animals" | The chapter never says here how one animal maps to one file. In Geneious a document is one sequence or one list. I could not tell if a bundle is one animal, one lane, or one barcode until Before you start. | Say "one read bundle per animal" in this first paragraph. |
| What it is, "as the alignment evidence behind them" | "Alignment evidence" is not glossed and is not obviously the BAM mentioned 170 lines later. I read the sentence twice trying to work out what an evidence is. | Name it as the alignment file here. |
| What it is, "23.6 percent of the reads survived" | I cannot judge this. In Geneious a 24 percent mapping rate would have made me redo the run. The text asserts it is healthy but the reason arrives only in What good looks like. | Give the one-line reason (strict filter plus adapter dimer) at first mention. |
| What it is, "far smaller than a mapping workflow would report" | I do not know what LGE calls a mapping workflow or what number it would report, so the comparison told me nothing. | Give the contrasting number, or drop the comparison. |
| Why you would do this, "which chapter 1 calls an allele target" | "Chapter 1" is ambiguous. Chapter 1 of the manual is Foundations. I think this means section 01 of chapter 9. | Link it as [What Is MHC Genotyping] rather than "chapter 1". |
| Before you start, "the Williams MiSeq genotyping project" | Named like something I could obtain, then two sentences later I learn I cannot have it. I hunted for a download link first. | Say it is private in the same sentence it is introduced. |
| Before you start, "imported as one `.lungfishfastq` bundle per animal" | This is the first place the one-bundle-one-animal rule is stated, and it sits inside a cross-reference sentence. It is the most load-bearing fact in the chapter. | Promote it to its own sentence. |
| Before you start, "with names of the form `WD1_S148_L001`" | I do not know which part of that name is the animal. Later the whole string is used as a sample name. Geneious lets me rename documents freely, so I wondered whether the name matters to the run. | Say whether LGE parses the name or treats it as opaque. |
| Before you start, "970 rhesus allele sequences" and "198 of them are 244 bases" | Four numbers with no way to check them against my own library. I do not know how to look inside a `.lungfishref` to count mine. | Say how to inspect a reference bundle, or cross-reference the chapter that does. |
| Before you start, "That 244 figure matters in a way step 3 explains" | Forward reference to a step I have not read. I flipped to step 3 and back. | State the consequence in one clause here. |
| Before you start, "the `read-mapping` plugin pack" | I do not know how to tell from Plugin Manager whether a pack is installed. The text says "check both" without saying what installed looks like or how to install one. | Say what the installed state shows, and how to install. |
| Before you start, "Installing one needs a network connection" | No size or time given. A Geneious plugin install takes seconds. I did not know whether to expect a coffee break. | Give an approximate download size or duration. |
| Before you start, "raises a message window whose Open Workflow Library button" | Two routes to the same place are given in one paragraph. I read it twice to work out that they are alternatives, not steps. | Split into two sentences, or keep only the Workflow Library route. |
| Step 1, "Click the read bundles you want" | Multi-select is implied by the next paragraph but never told to me. In Geneious it is Shift-click or Cmd-click, and I do not know if LGE is the same. | Say Cmd-click to add to the selection. |
| Step 1, "Merged means one report file, not pooled reads" | I had to read this three times. "Merged" is used here for reports and in step 3 for read pairs, in the same chapter. | Use a different word for one of the two meanings. |
| Step 2, "The Workflow Operations dialog opens with that workflow already selected" | This implies the dialog can hold other workflows and has a selector I might disturb. Nothing tells me where that selector is or to leave it alone. | Add a clause saying not to change the workflow selection. |
| Step 2, "If LGE found any reference bundles inside your project" | I do not know how a reference bundle gets inside the project. Importing a FASTA is never described anywhere in this chapter. | Cross-reference the chapter that covers importing a reference. |
| Step 3, "Under Threads and Min Reads ... sits a line of small grey text" | The heading tells me to read the mode caption, but the caption can hold at least two values and only one is shown. I could not tell what the ONT caption would say. | Give both possible caption strings. |
| Step 3, "if it names the wrong platform the fix is in the bundles" | I am told the fix is in the bundles but not what the fix is or which chapter has it. This is a dead end for a windows-only reader. | Name the bundle field to correct, or link the import chapter. |
| Step 3, "with 2x251 chemistry a single MiSeq mate covers roughly 198 bases of insert" | I do not know my own chemistry and the text never says how to find it. Also 2x251 sounds like 251 bases, not 198, and the gap is unexplained. | Say where the chemistry is recorded, and explain the 251 to 198 drop. |
| Step 3, "so without merging every DRB allele ... would receive exactly zero reads" | The most important warning in the chapter, buried mid-paragraph in a step titled "leave the merge alone". | Pull it out as its own short paragraph or callout. |
| Step 3, "3 of 3 Illumina inputs contain unmerged read pairs" | The Williams plate has 30 samples everywhere else. Here the quoted message says 3 of 3. I assumed a typo before deciding it was the reproduction run. | Say the message is from the three-sample reproduction. |
| Step 4, "unless API access has been configured for your copy of LGE" | I do not know what API access is, whether I have it, or where it would be configured. It appears with no gloss. | Gloss it in one clause or link the settings chapter. |
| Step 4, "two fields you have no reason to change on a first run" | Advanced Options holds different fields on the two routes (two on miSeq here, three on ONT in step 6). Counting them cost me a pass. | Name the two fields. |
| Step 5, "Operations > Show Operations Panel (Cmd-Shift-P)" | Nothing says whether the panel opens by itself when a run starts, so I did not know if I would miss the beginning. | Say whether it opens automatically. |
| Step 5, "took 329 seconds of wall time" | Seconds for a five and a half minute run is hard to feel, and no machine is described, so I cannot scale it to my laptop. | Give minutes and name the machine class. |
| Step 6, "which the `full-length-mhc-genotyping` pack supplies at version 0.6.3" | A version number I have no way to check or act on. | Drop it, or say where the version is shown. |
| Step 6, "pbAA is a separate operation whose saved output this workflow can reuse" | pbAA arrives with no gloss and the reuse mechanism is never explained. I do not know if I need it. | Say pbAA is out of scope here in one clause. |
| Step 6, "They start at 2000 and 4000 bases" | I cannot judge these against my own amplicon because the chapter never says how to find my amplicon's length. | Say how to work out your amplicon length. |
| Step 6, "filled in automatically when LGE finds suitable files inside your project" | "Suitable" is doing a lot of work. I cannot tell whether an empty field means missing or unrecognised. | State the matching rule, even loosely. |
| Step 7, "lands beside the first as `amplicon-genotyping_1`" | Good behaviour, but a Geneious user expects a timestamped folder and would look for one. The text notes these are category folders "rather than the timestamped per-run folders most other tools use" without saying how to tell runs apart later. | Say how to identify which run is which. |
| Settings intro, "Those closing sentences belong to the optional command-line section" | Three sentences of instruction about which sentences to skip. I read it twice and skimmed the flags anyway. | Move the flag to a trailing parenthesis and drop the instruction. |
| Settings, "Include subfolders" | Documented, but it never appears in the Procedure or in any screenshot caption, so I did not know where to look for it. | Name its group in the dialog. |
| Settings, "Min Reads ... Be aware of what it does not do in the release tested here" | A setting that does not work is described in the neutral Settings voice with the warning deferred to another section. I would have set it to 50 and trusted it. | State the defect in the entry itself. |
| Settings, "Threads ... your machine's active processor count" | I do not know my processor count or how to find it, and I do not know if the number in the box is already it. | Say the box arrives pre-filled with that number. |
| Settings, "On the command line this is `--min-support`" and 11 similar closers | Every window setting ends in a command-line flag. I have never opened a terminal, so a dozen entries each end in a sentence I must discard. | Group the flags in a table at the end of the CLI section. |
| Settings, the block of 15 `--flag` paragraphs | Fifteen consecutive entries beginning with a double dash, explicitly unreachable from the window. This is the longest stretch of the chapter and none of it applies to me. | Move the whole block into the command-line section. |
| Reading the results, "23.9 percent of 2,854,092 input reads" against What it is, "23.6 percent" | Two different retained fractions for what I read as the same example. It took a second pass to see one is the plate and one is the reproduction. | Label each number with its run on first use. |
| Reading the results, "The remaining 682,928 alignments passed" | 682,928 here against 682,927 retained reads one paragraph above. I assumed I had misread and checked twice. | Reconcile the two figures or explain the difference. |
| Reading the results, "live in the result bundle's statistics file and in the workbook's Run Stats sheet" | I do not know how to open the statistics file from the window, and the bundle is described as a single sidebar row rather than a folder I can open. | Say how to reach these from the window. |
| Reading the results, "produced between 80 and 117 allele rows each" | A macaque has a handful of MHC genes. 80 to 117 rows per animal was shocking and the chapter never says why one animal yields so many. | Say in one clause why a sample yields dozens of rows. |
| What good looks like, "read it against your own assay rather than against a fixed number" | On a first run I have no previous run to compare against, which is exactly the situation the chapter's example describes. | Give a first-run floor. |
| What good looks like, "A sample with fewer than a hundred retained reads has failed" | Two sentences later I am told no threshold is needed to see the split. Then a threshold has just been given. I read both twice. | Keep one or the other. |
| What good looks like, "Scan the allele names in the report for DRB rows" | I do not know how to scan a report from the window, and the viewport is deferred to the next chapter. | Say which view shows allele names. |
| What good looks like, "the value was recorded in the run statistics without being applied" | I could not tell whether this affects Deterministic mode too, or only Genotype only, even on a second read. | Say explicitly which modes are affected. |
| What good looks like, "open the bundle's provenance record" | Told to open a file with no route given from the window. Same problem as the statistics file. | Say how to open it. |
| Haplotype analysis (placeholder) | A section saying a section will exist later. Having been told three times to leave Analysis Mode alone, I expected this to explain why. | Remove until it has content, or link the haplotype chapter. |
| On the command line, "This section is optional" | I was reassured, but the Settings section above already made me skip a sentence per entry and read 15 flag paragraphs. The optionality arrived too late to help. | Move the CLI framing before the Settings section. |
| On the command line, "refuses to write inside a world-writable directory" | "World-writable" is not glossed and `/tmp` means nothing to me. | Gloss or drop for this reader. |

One thing I learned. Read merging is not a tidy-up step but the only reason the 244-base DRB loci get any reads at all, and its failure is silent.

One thing I still could not do. Confirm from the window that my own run worked, because the retained fraction, the four drop counts, and the provenance record all live in files the chapter never tells me how to open.

The sentence I liked most. "The failure would be silent, since a locus with no reads simply has no rows."
