# Merged reader report - Primer Trimming an Alignment

Four readers reviewed this chapter. Personas were a genetics sophomore who has never opened a terminal, a wet-lab senior with two years of pipetting and no data analysis, a pre-med student reading in a second language, and an undergraduate who has used Geneious. None had opened a terminal before.

| Location | Issue | Readers who hit it | Suggested fix |
|---|---|---|---|
| What it is, "Primer trimming at the alignment level removes..." | All four readers hit "at the alignment level" before knowing there was another level (read-level trimming), and did not learn about the other level until many paragraphs later. | 1, 2, 3, 4 | Say in the first sentence that trimming can happen at the read level or the alignment level, and that this chapter covers the alignment level. |
| What it is, "a manifest naming the protocol and..." | All four readers met "manifest" with no gloss at first use, and it recurs later in What Good Looks Like and the command-line section. | 1, 2, 3, 4 | Gloss manifest at its first use in this chapter. |
| What it is, "It changes the letter in the read's CIGAR string..." | All four readers could not picture a CIGAR string from the sentence alone, and could not tell whether one letter changes or the whole string does. | 1, 2, 3, 4 | Show a short example CIGAR string before and after trimming, so the letter change is visible rather than described. |
| Why you would do this, "primers are frequently written with deliberate mismatches" | All four readers could not understand why a primer would be designed with a mismatch on purpose, and felt it contradicted the idea that a primer binds a chosen spot. | 1, 2, 3, 4 | Add one sentence saying a deliberate mismatch still lets the primer bind, including after the genome mutates at that position. |
| Why you would do this, "a QIAseq Direct amplicon library of 86,281" | All four readers could not judge whether 86,281 read pairs is a typical size for this kind of run, and some could not reconcile it with the later count of 172,562 records. | 1, 2, 3, 4 | State what read-pair range is typical for a clinical amplicon run, and place the record count next to the pair count so the reader can see they are pairs times two. |
| Setting the target, "An eligible track is one stored as an indexed BAM" | All four readers did not know what an index is, how a track would end up without one, or what to do if their own track is missing one. | 1, 2, 3, 4 | Gloss index as a companion file the mapping step writes automatically, and say what to do if a track lacks one. |
| Setting the target, "It holds four iVar numbers whose defaults follow..." | All four readers could not tell whether leaving Advanced Options collapsed was a genuine recommendation for their own run or just what the worked example happened to do. | 1, 2, 3, 4 | State plainly that the defaults suit a standard run and that most users never need to open this section. |
| Opening the dialog, "The Analysis section is a grid of six tabs" | All four readers found six tabs mentioned with none named, and could not confirm they were looking at the right one before reading further. | 1, 2, 3, 4 | Name the six tabs, or say where the Primer Trim tab sits among them. |
| Opening the dialog, "Choose QIAseq Direct SARS-CoV-2 with Booster..." (eight schemes) | All four readers had no way to know which of the eight built-in schemes matched their own kit if it was not the one in the worked example. | 1, 2, 3, 4 | Say to check the kit box or the wet-lab protocol sheet for the scheme name. |
| Reading the results, "turn on \"Show soft-clipped sequence\" in the Inspector's..." | All four readers could not find where the read display controls live in the Inspector from this sentence alone. | 1, 2, 3, 4 | Name the Inspector section that holds this toggle. |
| Reading the results, "Soft-clipped bases on the reference run rose from..." | All four readers lost track of several large before-and-after numbers in one sentence, and some could not reconcile the rise in clipped bases against the fall in matched bases. | 1, 2, 3, 4 | Put the before and after counts in a small table, and add a clause accounting for the gap between the two changes. |
| What good looks like, "which are the same SARS-CoV-2 genome" (two accessions) | All four readers did not know a single genome could be deposited under two accession numbers, which left some distrusting accession numbers generally. | 1, 2, 3, 4 | Add one clause saying duplicate deposits of the same genome are common and either accession is valid. |
| On the command line, "The identifier is the short `aln_` string in..." | All four readers had never opened a terminal or a manifest.json file and could not tell whether the identifier also appears somewhere in the app itself. | 1, 2, 3, 4 | Say whether the identifier is also shown somewhere in the Inspector or dialog. |
| Why you would do this, "iVar's own variant caller expects a primer-trimmed input" | Three readers had assumed iVar was a single-purpose amplicon toolkit and were surprised here to learn it is also a variant caller. | 1, 2, 3 | Say at the first mention of iVar that it is a toolkit containing both a trimmer and a variant caller. |
| Before you start, "Open Tools > Plugin Manager... (Cmd-Shift-B)" | Three readers did not know whether installing the pack takes seconds or downloads something large, or whether the app can be used while it installs. | 1, 2, 3 | State roughly how long the install takes and whether it needs a network connection. |
| Before you start, "mapping placed 171,355 of 172,562 read records" | Three readers were given 99.30% with no sense of whether that figure is good, expected, or a sign to stop and fix the mapping first. | 1, 3, 4 | State what mapping rate is low enough that the reader should stop and address the mapping before continuing. |
| Reading the results, "Since the -e flag was given" / "0.79% (1360) of reads started outside" | Three readers met the `-e` flag in the log with no explanation of what it does or whether they had set it themselves. | 1, 2, 3 | State that LGE always passes `-e` and say briefly what it does. |
| Settings, "The default is 20, a Phred score meaning..." | Three readers could not extend the pattern from Phred 20 (one error in a hundred) to the recommended value of 30. | 1, 2, 4 | Give the error rate for Phred 30 as a second data point so the pattern is clear. |
| Settings, "Primer offset. Shifts every primer coordinate..." / "compensates for a scheme whose coordinates" | Three readers could not imagine how they would ever discover that their own coordinates were off by a fixed amount. | 1, 2, 4 | Name the symptom that points to an offset, such as a low trim rate with a scheme the reader otherwise trusts. |
| Settings, "Sliding window width. Sets how many neighbouring bases..." | Three readers could not picture the sliding window moving in from the read end, and one noted it is used in an earlier entry before being explained. | 1, 2, 4 | Add a short description or picture of the window moving in from the read end, and introduce it before it is first used. |
| On the command line, "--format json prints one JSON object per line" | Three readers met JSON with no gloss anywhere in the chapter. | 1, 2, 4 | Gloss JSON at its first use, or drop the flag from a chapter aimed at bench readers. |
| Reading the results, "and a SHA-256 checksum for both..." | Two readers knew checksum was in the glossary but were given no reason to care that one is recorded. | 2, 3 | Add a clause saying the checksum lets the reader prove later that the file has not changed. |
| What good looks like, "A low rate means the scheme and the library disagree" | Two readers were given two example numbers, 99.15% and 22.13%, but no threshold marking where a trim rate becomes too low to trust. | 1, 4 | Give a threshold below which the reader should stop and check the scheme. |
| What good looks like, "Three quarters of the reads found" / "soft-clipping reached only 13.44% of bases" | Two readers could not tell whether the trim rate or the soft-clipping percentage was the real check, since both are presented as a tell. | 2, 4 | State plainly that the trim rate is the check, and that the soft-clipping percentage only corroborates it. |
| On the command line, "open File > Import Center..., pick the References tab" | Two readers found the scheme-import steps placed inside the command-line section and nearly skipped them, assuming they were terminal-only. | 3, 4 | Move the Import Center steps out of the command-line section into their own heading. |

Twenty-four rows total.

## Consensus

Thirteen rows were hit by three or more readers.

- The phrase "at the alignment level" is used before the other level, read-level trimming, is introduced.
- Manifest is used with no gloss at its first appearance in the chapter.
- The CIGAR string change is described but never shown, so the letter change cannot be pictured.
- A deliberate primer mismatch is presented with no explanation of why it still lets the primer bind.
- The 86,281 read-pair figure cannot be judged as typical or reconciled with the later record count.
- Index is used with no gloss and no guidance for a track that lacks one.
- Leaving Advanced Options collapsed is never confirmed as a real recommendation rather than an artifact of the worked example.
- The six Analysis tabs are mentioned but never named.
- Readers have no way to match one of the eight built-in schemes to their own kit.
- The Inspector section holding the soft-clipped-sequence toggle is never named.
- The soft-clipped before-and-after numbers are dense and, for some readers, do not visibly reconcile.
- Two accession numbers for the same genome are presented with no explanation that duplicate deposits are common.
- The command-line identifier is never confirmed as visible anywhere in the app itself.
