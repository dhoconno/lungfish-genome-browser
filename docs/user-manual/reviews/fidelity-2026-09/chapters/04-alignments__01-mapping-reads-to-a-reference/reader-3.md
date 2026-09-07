# Reader 3 report, Mapping Reads to a Reference

Persona: pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Mapping takes two things, a pile" | "A pile of sequencing reads" is informal English. I was not sure if "pile" is a technical unit or just an image. | Say "a set of sequencing reads". |
| What it is, "and a score saying how sure" | The score is not named here. Later the chapter calls it MAPQ. I did not connect the two until the end. | Name it MAPQ at this first mention. |
| What it is, "so switching mappers changes the answers" | "Changes the answers a little" is vague. A little compared to what? | Give the size, for example "under one percent of mapped reads". |
| What it is, "It also comes out with a companion index" | I do not know what an index file contains or whether I must keep it. | Say the `.bai` must stay in the same folder as the BAM. |
| What it is, "The entry point in the window is a two-part choice" | "Entry point" is app jargon I have not met. "Catches people out" is an idiom I had to look up. | Say "You start this in two steps, and the order matters". |
| Why you would do this, "or from a repeat that appears a million times" | "A repeat" used as a noun was new to me. I learned "repeated sequence" in genetics class. | Gloss repeat at first use. |
| Why you would do this, "The slice holds 45,574 read pairs" | "Slice" is used as the name of the fixture and also as ordinary English. I read it twice. | Use one word, slice or subset, and gloss it once. |
| Why you would do this, "drawn from a 500 kb window" | "kb" is never expanded. I guessed kilobases but I was not certain. | Write "500 kb (kilobases, 500,000 bases)". |
| Before you start, "click the Download raw file button" | I could not tell whether I need a GitHub account for this. | State that no account is needed. |
| Before you start, "Three of the four mappers arrive" | The sentence does not say which three. I worked it out by elimination from the BBMap sentence. | Name the three. |
| Before you start, "No Docker Desktop is needed" | I have never heard of Docker Desktop, so this reassurance meant nothing to me. | Cut it, or say what it is in three words. |
| Procedure, "titled Mode for the three mappers" | Two names for one section confused me while I was looking at my screen. | Say plainly that the section is called Preset only in minimap2. |
| Procedure, "a sixth section appears between Preset" | I could not tell whether this affects me. I only selected one bundle. | Add "skip this if you selected one bundle". |
| Procedure step 4, "it stops guessing the moment you change" | I did not understand the consequence. Does it stop guessing forever, or only here? | Say the scope, for example "for the rest of this wizard session". |
| Procedure, "then samtools view to drop unwanted records" | Which records are unwanted, and who decided? Nothing above told me. | Say the filter uses the Advanced Settings you chose. |
| Procedure, "such as Analyses/minimap2-20260906-134512/" | I could not read the folder name pattern. Is 134512 a time? | Say the pattern is mapper name, date, time. |
| Settings, Reference, "which is a convenience rather than a judgement" | Abstract phrasing. I read it twice and still had to infer that the app is not recommending it. | Say "the app is not recommending it, so check it". |
| Settings, Preset, "Assembly-to-assembly, Spliced CDS/cDNA" | Three of the six options are terms I do not know, and none is explained. | Add a short gloss for each non-Illumina option. |
| Settings, Mode, "offers nothing else, because both programs" | A picker with one option is strange. I wondered whether my install was broken. | Say the picker is expected to look disabled. |
| Settings, Run Mode, "This setting has no command-line flag" | The explanation of why is long and I lost the thread before the end. | Split into two sentences. |
| Settings, Read Group lead-in, "LGE fills in every field for you, so skip these" | It says skip, but then five full entries follow. I did not know whether to read them. | Mark the five entries as reference only. |
| Settings, ID, "it accepts any text without spaces" | I do not know what happens if I type a space. Does it warn me, or fail silently? | Say the field rejects it. |
| Settings, Platform, "as long as it still holds the old preset's default" | This conditional was the hardest sentence in the chapter. I read it three times. | Say "unless you already edited the field by hand". |
| Settings, Threads, "the fixture run below reports 14 threads" | I could not find the run below that reports 14 threads. Neither table shows a thread count. | Point to where the 14 appears, or drop the cross-reference. |
| Settings, Secondary alignments, "with Bowtie2 adding -k 10" | Raw flags with no explanation. I do not know what `-k 10` does. | Say what the flags mean in plain words, or cut them. |
| Settings, Supplementary, "the command-line flag is the inverse of the checkbox" | Inverse logic. I could not tell whether `--no-supplementary` matches ticking or unticking. | Say "ticking the box means the flag is not passed". |
| Settings, Min mapping quality, "the practical ceiling for minimap2 and BWA" | Only two of the four mappers are named, so I do not know the ceiling for Bowtie2 or BBMap. | State the range for all four, or say the stepper caps at 60 regardless. |
| Settings, Min mapping quality, "Raise it to about 20 when repeated sequence" | I do not know how to tell that repeated sequence is causing this. The symptom is not described. | Name the symptom I would see in the viewport. |
| Settings, Extra arguments, "LGE parses it live and a parse error" | "Parses" is programmer vocabulary. I guessed it means checks. | Say "checks the text as you type". |
| Settings headings, "Threads:." and "Secondary alignments:." | Four headings end with a colon and a full stop together. It looks like a typo and broke my reading rhythm. | Remove the stray colon. |
| Import section, "works out which reference assembly the file names" | I read "the file names" as a plural noun first, then realised names is the verb. I read it three times. | Rephrase as "which reference assembly the file's header declares". |
| Reading the results, "Total Mapped is how many alignment records" | Records and reads are used as if interchangeable, but the Flag Stats section later says they differ. | Keep the distinction from the start. |
| Reading the results, "which is what a human genome project aims for" | No project is named and no source is given, so I cannot check this claim. | Name the typical target, for example 30x to 50x. |
| Reading the results, "A region under 10 is too thin" | Under 10 what? The unit is dropped here but written as 44.7x above. | Write "under 10x". |
| Reading the results, "Est. Coverage is the estimated average depth" | The Inspector says Est. Coverage, the next paragraph says Mean depth, and the table says Mean depth. Three names for one number. | Use one name, and say once that the Inspector labels it differently. |
| Reading the results, "which is 99.19% of the paired reads" | I could not reproduce this. The paired-read denominator is never given. | Give the paired-read denominator. |
| Flag Stats table, "primary mapped 90,935" | The five numbers above say Total Mapped 90,990, but this row says 90,935. Nothing explains the difference. | Say the 55 supplementary records account for it. |
| Four mappers table, "Median MAPQ" | This column is not among the Inspector's five numbers, and the chapter never says where to find it. | Say where median MAPQ is displayed or computed. |
| Four mappers, "Bowtie2 reports 42 and BBMap 45, because the four programs scale" | If the scales differ, I do not know how to compare a MAPQ of 42 to one of 60 in my own work. | Say the score is only comparable within one mapper. |
| What good looks like, "which is expected in shotgun sampling of a pathogen" | This chapter is a human genome example, so a pathogen scenario arrived with no setup. | Move this elsewhere or add one clause of setup. |
| What good looks like, "and is diagnosed by running classification first" | Classification is named but not linked and not explained. | Link to the classification chapter. |
| What good looks like, "the mark of a corrupted or truncated download" | I did not know a download could be truncated without an error message. | Say the file looks complete but is short. |
| Provenance paragraph, "read the sidecar's version fields" | I do not know what a sidecar file is, where it lives, or how to open it without a terminal. | Say where in the app to see it. |
| Provenance paragraph, "nudges soft-clip boundaries by a base or two" | Soft-clip is linked but the sentence assumes I already know why boundaries matter. | Add one clause saying what a soft clip is. |
| On the command line, "--preset sr" | The window said Short-read and the command says `sr`. I found the translation table only two paragraphs later. | Put the table before the command block. |
| On the command line, "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish/" | This path appears nowhere earlier in the chapter. I do not know where my own project is. | Say this is an example path to replace. |
| On the command line, "a 4.8 second runtime" | This is the only runtime given, so I cannot judge how long my own data would take. | Say the run scales with read count and reference size. |
| On the command line, "the reliable move when a bundle path is rejected" | "The reliable move" is idiomatic English. I understood it only from context. | Say "if the bundle path is rejected, pass the FASTA instead". |
| On the command line, "eight characters taken from a fresh UUID" | UUID is never expanded or glossed. | Expand it once. |

Three closing lines.

The one thing I learned is that the total record count can legitimately exceed the number of reads I imported, because a read split across two places writes a second supplementary record.

The one thing I still could not do is check my own run against the chapter, because Total Mapped (90,990) and primary mapped (90,935) disagree and the text never reconciles them, so I would not know which number my file should match.

The sentence I liked most is "Reads on their own tell you almost nothing."
