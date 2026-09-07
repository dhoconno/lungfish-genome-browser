# Reader report: Primer Trimming an Alignment

Reader 3. Pre-med student, English is my second language, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "Primer trimming at the alignment level removes" | "At the alignment level" is used before I know there is another level. I only learn there is a read level six paragraphs later. | Say in this first sentence that the other kind is read-level trimming. |
| What it is / "and starts the copying reaction that" | I do not know what "the copying reaction" is. PCR is never spelled out anywhere in this chapter. | Write polymerase chain reaction (PCR) once here. |
| What it is / "arranged so their products overlap and" | I cannot picture the arrangement. Overlap of what with what, and why overlap is needed. | One sentence saying neighbouring amplicons share ends so no part of the genome is missed. |
| What it is / "packages a scheme as a `.lungfishprimers`" | I do not know if a folder with a dot name is something I can open, or a file I must not touch. | Say it is a folder that the Finder shows as one item. |
| What it is / "a manifest naming the protocol and" | "Manifest" is not glossed here and is not in the chapter's glossary list. | Gloss manifest at first use. |
| What it is / "and a provenance note" | "Provenance note" appears before provenance is explained. The glossary link only comes much later, in Reading the results. | Link provenance here at first use, not at second use. |
| What it is / "It changes the letter in the read's" | I read this three times. I could not tell whether the whole CIGAR changes or only some letters. | Say only the letters covering the primer bases change. |
| What it is / "So what should you do with" | The question sounds like it is asked to me but then answers itself immediately. It made me stop and look for a question I had missed. | Delete the question and keep the instruction. |
| Why you would do this / "primers are frequently written with deliberate mismatches" | I do not understand why a scientist would design a primer that does not match on purpose. This is the key of the whole section and I did not follow it. | One sentence saying a deliberate mismatch keeps the primer binding even after the genome mutates. |
| Why you would do this / "it sits under deep coverage" | "Deep coverage" is used as if I know it. Coverage is in the chapter's glossary list but never glossed in the text. | Gloss coverage here, as how many reads sit over one position. |
| Why you would do this / "these calls cluster at amplicon boundaries" | I do not know how to see where amplicon boundaries are in the app, so I cannot use this tell. | Say where in the viewport the boundaries are visible. |
| Why you would do this / "iVar's own variant caller expects a" | I did not know iVar was also a variant caller. Earlier it was called an amplicon toolkit. | Say iVar does both trimming and variant calling. |
| Why you would do this / "86,281 paired-end Illumina read pairs from" | I cannot judge whether 86,281 is a lot or a little for this kind of work. | Say what a typical range is for a clinical amplicon run. |
| Before you start / "Download the reference file `MN908947.3.fasta` from" | I do not know what a FASTA file is at this point, and it is not glossed in this chapter. | Gloss FASTA at first use here. |
| Before you start / "mapping placed 171,355 of 172,562 read" | I do not know if 99.30% is good, bad, or expected, and no sentence tells me. | Say what percentage would worry me. |
| Before you start / "Open **Tools > Plugin Manager...** (Cmd-Shift-B) and" | I could not tell how long installing the pack takes or whether I can use the app meanwhile. | Say roughly how long the install runs. |
| Procedure / "Every count quoted in this chapter" | The date 2026-09-07 does not tell me whether my own numbers should match exactly or only approximately. | Say my numbers will differ if I use different reads. |
| Opening the dialog / "then click the alignment track inside" | I do not know what an alignment track looks like in the sidebar, so I cannot be sure I clicked the right thing. | Describe the icon or where the track sits under the bundle. |
| Opening the dialog / "The Analysis section is a grid" | I could not perform this step confidently. Six tabs are mentioned but none is named, so I did not know which one to look for among them. | Name the Primer Trim tab's position among the six. |
| Opening the dialog / "Choose **QIAseq Direct SARS-CoV-2 with Booster** " | Eight built-in schemes exist and I have no way to know which one matches my own library if it is not this one. | Say to read the scheme name off the kit box or protocol. |
| Setting the target / "because LGE fills it with the" | I had to read this twice. It surprised me that clicking a track in the sidebar does not carry over. | State the check as a plain instruction first, then the reason. |
| Setting the target / "so a track whose index is" | I do not know what an index is or how a track would lose one. | Gloss index, and say what to do if my track is absent. |
| Setting the target / "It holds four iVar numbers whose" | "Defaults follow iVar's own recommendations" does not tell me whether my kit is one of the exceptions. | Say most users never open this. |
| Reading the results / "turn on \"Show soft-clipped sequence\" in" | I could not find the read display controls from this sentence alone. It does not say where in the Inspector they are. | Name the Inspector section holding that toggle. |
| Reading the results / "Soft-clipped bases on the reference run" | Four big numbers in one sentence. I lost track of which was before and which was after by the end. | Put the four numbers in a small table. |
| Reading the results / "As a fraction of all the" | I could not check my own run against this because I do not know where LGE shows me these percentages. | Say which panel reports the soft-clip percentage. |
| Reading the results / "That starting figure is not primer" | I did not understand why minimap2 clips ends that "do not fit the reference". | One sentence on why a read end may not fit. |
| Reading the results / "Since the -e flag was given" | The log mentions a flag I never set and cannot see. I did not know whether I had done something. | Say LGE sets -e for me and why. |
| Reading the results / "1207 unmapped reads were not written" | Earlier the counts were 172,562 and 164,704. I tried to make these log numbers add up to that difference and could not. | Show the subtraction, or say the categories overlap. |
| Reading the results / "a SHA-256 checksum for both the" | I do not know what a checksum is for. The glossary link is there but the sentence gives me no reason to click it. | Say a checksum proves the file has not changed. |
| What good looks like / "soft-clipping reached only 13.44% of bases" | I do not know why a wrong scheme still clips 13% rather than almost nothing. | Say the wrong scheme still matches some reads by chance. |
| What good looks like / "which are the same SARS-CoV-2 genome" | I did not know one genome could have two accession numbers, and this confused me about which one I should use. | Say either accession is fine with the bundled schemes. |
| What good looks like / "a BAM whose contig carries a" | I do not know what a contig is or where I would see its name. | Gloss contig, and say where the name appears. |
| On the command line / "The identifier is the short `aln_`" | I have never opened a terminal or a `manifest.json`. I could not do this step at all. | Say whether the dialog can copy this identifier for me. |
| On the command line / "`--target-reference` overrides which contig name in" | Two sentences of terminal detail with no way for me to check whether I need it. | Say a dialog user never needs this flag. |
| On the command line / "open **File > Import Center...**, pick the" | This importing section sits inside the command-line section, so I nearly skipped it thinking it was terminal-only. | Move the Import Center steps out of the command-line section. |

One thing I learned. Soft-clipping does not delete the primer bases from the file. It only marks them so the variant caller looks past them, which means I can always go back and see the original bases.

One thing I still could not do. I could not check my own run's trim rate, because the chapter shows me the iVar log text but never tells me where in the app to find that log.

The sentence I liked most. "A wrong scheme is silent, so the trim rate in the log is your only check, and you should read it every time."
