# Reader report: Primer Trimming an Alignment

Reader 2. Senior. Two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Primer trimming at the alignment level removes..." | "At the alignment level" is doing a lot of work and I did not know there was another level until the end of the section. | Say the two levels exist before using the phrase. |
| What it is, "Given that list, LGE runs iVar," | I do not know what an amplicon toolkit is. Is iVar something I install, something already inside the app, or something I run separately? | One clause saying iVar is a program LGE runs for you. |
| What it is, "It changes the letter in the" | I have never seen a CIGAR string. Being told a letter changes from M to S means nothing without seeing one. | A four-character example of a CIGAR string before and after. |
| What it is, "What changes is that a variant" | I could not tell whether the caller skips the bases because of the S letter, or for some other reason. | Say the caller reads the S and skips on that basis. |
| What it is, "a manifest naming the protocol and" | Manifest is used here and again in the What good looks like and command-line sections and I never learned what one is. | Gloss manifest at this first use. |
| Why you would do this, "Primer schemes are designed against one" | I did not follow why a designer would deliberately put a wrong base into a primer. Read it three times. | One sentence on why a mismatch helps a primer keep binding. |
| Why you would do this, "That call is wrong, and it" | Three reasons stacked without a change of subject made me lose track. Which "it" is being described, the call or the error? | Name the subject once more in that sentence. |
| Why you would do this, "iVar's own variant caller expects a" | I did not know iVar was also a variant caller. Earlier it was an amplicon toolkit. | Say the toolkit contains both a trimmer and a caller. |
| Why you would do this, "This chapter works through the SRR36291587" | I could not judge whether 86,281 read pairs is a big or a small run compared with what I would get. | One clause saying whether that is a typical amplicon run size. |
| Before you start, "On the reference run behind this" | 172,562 records is not 86,281 doubled and I could not work out where the extra records came from. | Explain why the record count differs from the pair count. |
| Before you start, "Open Tools > Plugin Manager... (Cmd-Shift-B)" | I did not know whether installing a pack takes seconds or downloads something large, so I did not know whether to start it and wait. | Say roughly how long the install takes. |
| Opening the dialog, "The Analysis section is a grid" | I could not tell which of the six tabs to look for until I read further. Are they labelled on screen? | Name the tab labels, or say the tabs carry visible labels. |
| Opening the dialog, "Choose QIAseq Direct SARS-CoV-2 with Booster" | Several of the eight schemes could plausibly have similar names and I would not know which matches the kit box on my bench. | Say where in the kit paperwork the scheme name appears. |
| Setting the target, "An eligible track is one stored" | I do not know what an index is or how I would know mine is missing. | Gloss the index and say what a missing one looks like. |
| Setting the target, "It holds four iVar numbers whose" | I could not tell whether leaving Advanced Options collapsed is genuinely fine for a first run or a shortcut I would regret. | State plainly that the defaults suit a standard run. |
| Setting the target, "Click Run. The dialog closes and" | I did not know whether I must open the Operations Panel for the run to work or only to watch it. | Say the panel is optional to open. |
| Settings, "Minimum quality. Sets the quality floor" | The sliding window is used here but explained in the entry below, so I read this one blind. | Order sliding window width before minimum quality. |
| Settings, "The default is 20, a Phred" | I have heard Phred in lab meeting but never learned it. One wrong base in a hundred at 20, then "toward 30", left me unable to work out what 30 means. | Give the error rate for 30 as well. |
| Settings, "The default is 4, wide enough" | Four bases sounds tiny for a window and I could not judge whether that is small or normal. | Say four is iVar's own default. |
| Settings, "Use it only when you have" | I have no idea how I would ever establish that my coordinates are off by a fixed amount. | Say how a displaced scheme shows up in the trim rate. |
| Reading the results, "If you do not see them," | I could not find where the read display controls live from this sentence alone. | Name the Inspector section holding that toggle. |
| Reading the results, "Soft-clipped bases on the reference run" | Six large numbers across three sentences and I lost track of which pair counted bases and which counted reads. | Put the before and after counts in a small table. |
| Reading the results, "0.79% (1360) of reads started outside" | I have never used a flag and this log line assumes I know what -e is. | One clause saying LGE always passes -e. |
| Reading the results, "and a SHA-256 checksum for both" | I know checksum is in the glossary but not why I would care that one is recorded. | Say what the checksum lets me prove later. |
| What good looks like, "Three quarters of the reads found" | I could not tell whether I should be checking the trim rate or the soft-clipping percentage, since both are offered as the tell. | Say the trim rate is the check and the percentage only corroborates. |
| What good looks like, "which are the same SARS-CoV-2 genome" | I did not understand how one genome gets two accessions, or whether that matters when I import my own scheme. | One clause on why duplicate accessions exist. |
| On the command line, "The identifier is the short aln_" | I have never opened a manifest.json and would not know how to. | Say whether the identifier also appears somewhere in the app. |
| On the command line, "Two flags have no counterpart in" | I do not know what JSON is and this is its only mention in the chapter. | Gloss JSON or drop it from a bench-scientist chapter. |
| On the command line, "pick the References tab, and use" | I would not know where to get a BED file of my own panel's coordinates. | Say the BED usually comes from the kit vendor. |

The one thing I learned. Soft-clipping does not delete the primer bases, it only marks them so the variant caller walks past them, which is why the trimmed file still holds every read at full length.

The one thing I still could not do. Work out which of the eight bundled schemes matches a kit sitting on my bench, since the chapter warns me that a wrong scheme is silent but never tells me how to find the right name.

The sentence I liked most. "A wrong scheme is silent, so the trim rate in the log is your only check, and you should read it every time."
