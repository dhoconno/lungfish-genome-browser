# Reader 4 report, Troubleshooting

Reader. An undergraduate who used Geneious for one semester. Comfortable with a
graphical sequence viewer. Expects every operation to have a dialog. Has never
opened a terminal. My run just stopped with a red row and I came here to find
out what to do.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "a window over a set of established command-line programs" | This is the first sentence and it already tells me the thing I use is really a pile of programs I have never seen. I did not know that and I do not know what it means for me. In Geneious the program is the program. | Add one sentence saying the user never has to run those programs themselves. |
| What it is, "the symptoms that actually appear in Preview 2026.9.13" | I do not know which version I have or where to look. Nothing here tells me how to check before I trust the table. | Name the About window here, not only in the reporting section at the end. |
| What it is, "A working directory is the folder your Terminal is sitting in when you type a command" | I have never opened a Terminal. This is offered as one of the two words worth fixing first, so the chapter opens by assuming I am a terminal user. | Say what a working directory is for someone using the window, then add the Terminal meaning. |
| What it is, "typing `pwd` and pressing Return" | I do not know where I would type this. There is no window shown and no menu named. | Name the app you type it into, or give the window equivalent. |
| What it is, "An exit status is the number a command hands back" | I never see a number when I run something from a dialog. I could not tell whether this applies to me at all. | Say where in the window an exit status appears, or say it appears only in the failure report. |
| Start here, "right-click its row in the Operations Panel" | Good, this is the first thing I could actually do. But nothing above told me a failed row is red or how I recognise it. My row is red and I inferred the match. | Say what a failed row looks like. |
| Start here, "take the report the panel offers you" | Vague. Take it where? I did not know it meant Copy Failure Report until the paragraph after. | Name the menu item in this sentence. |
| Start here, "Do not reconstruct the command by hand from what you remember choosing in a dialog" | I would never have thought to do this, so the warning made me think reconstructing was a normal step I had missed. | Cut or move to a note. |
| Start here, "`~/Library/Logs/`, in a folder named for the build, then `Operations/Failures`" | I cannot get here. Library is hidden in Finder and the tilde means nothing to me. The chapter offers Reveal Failure Report in Finder one sentence earlier, then gives me a path I cannot type. | Say to use Reveal in Finder and drop the path, or say the folder is hidden. |
| Start here, "prunes older ones each time it writes a new one" | I cannot judge this. How many are kept? A week? Ten? "the most recent" is not a number. | Give the count. |
| Nothing happens, "with `(not enabled)` after its name" | The whole row reads well and I could do it. This is the only table entry with a complete window route. | None. |
| Nothing happens, "Turn on Show Experimental Features in Settings > Advanced" | Settings is not in the Tools menu the row is about, and the chapter never says Settings lives under the app menu or Cmd-comma. I hunted for it. | Give the menu path from the app menu. |
| Nothing happens, "Select a reference bundle under `Reference Sequences/`" | I do not know what a reference bundle is or where `Reference Sequences/` appears. It is written like a folder but I think it is a thing in the sidebar. | Gloss reference bundle and say where the folder shows up. |
| Nothing happens, "a mapping result, a classifier result, or a genotype result" | Four kinds of result named with no gloss, in a row whose point is which ones do not work. I could not tell which one I have. | Gloss or link each. |
| I cannot write, "an advisory lock, meaning it works because every cooperating program checks it" | Read twice. The gloss explains the mechanism, not what it means for me. My question is whether my data is safe. | Say plainly that a program that ignores the lock can still write. |
| I cannot write, "Read the banner underneath, which names the owner" | The owner is a user, a host, and a process id per the next row. I do not know what a host or a process id is, or how I would use either to find the other copy. | Gloss process id, or say the banner tells you which machine. |
| I cannot write, "before you clear the lock" | Clearing the lock is named as an action three times in this section and never described. The route is pushed to another chapter every time. This is the section I most needed to finish here. | Give the window route to clear a lock, or say plainly there is no window route and the other chapter has it. |
| I cannot write, "remove the lock as Shared Projects describes" | Same gap. I have a read-only window and no way forward without leaving this appendix. | Name the menu item at least. |
| I cannot write, "Lock failures surface against `.lungfish/project.lock` ... never against `manifest.json`" | I do not know what any of these three files are and I cannot see files beginning with a dot in Finder. I could not use this. | Say what the reader should do with this, or move it to a note for administrators. |
| I cannot write, "stray files whose names begin with `._`" | Same problem. I cannot see them and the text does not say to delete them or how. | Say the action, not only the cause. |
| A run stopped, "`Empty Kraken2 report`, exit status 64" | Exit status 64 is called a usage refusal later in this same section, but here it is attached to a run that finished and matched nothing. Those two readings contradict and I read the section twice. | Reconcile, or say why this one case reuses 64. |
| A run stopped, "Run `lungfish-cli conda db recommend`" | This is the fix for my most likely first failure and it is a terminal command. There is no window route and the text does not say one is missing. I stopped here. | Give the window route for choosing a broader database, or say plainly this check has no window equivalent. |
| A run stopped, "MEGAHIT 1.2.9 fails most runs on Apple Silicon" | I do not know whether my Mac is Apple Silicon, and "fails most runs" gives me no way to judge whether to try again once or ten times. | Say how to check the chip, and give a number of retries. |
| A run stopped, "with both shipped workarounds active" | Read twice. Workarounds I never turned on, described as a reason it still fails. This sentence is for a developer. | Cut. |
| A run stopped, "Your working directory sits under `/private/tmp`" | I never chose a working directory. I picked a folder in a dialog. I could not tell whether this row is about me. | Say which dialog choice causes it. |
| A run stopped, "the two spellings differ across the symlink macOS keeps between `/tmp` and `/private/tmp`" | Read three times. Symlink is glossed by link only, and the sentence is about two names for one folder, which I have never met. | State the rule first, then the cause. |
| A run stopped, "reaches about 84 percent and stops" | Good, this is the one number in the chapter I could match against what I saw. | None. |
| A run stopped, "Nextflow keeps a cache that needs file locks" | Nextflow appears with no gloss, in a row about an external drive. I do not know if I am using Nextflow. | Gloss at first use, and say which operations use it. |
| A run stopped, "a drive formatted exFAT is the usual cause" | I do not know how my drive is formatted or how to look. | Say how to check the format in Finder. |
| A run stopped, "Three means a pack name was not recognised ... Ten means `tools update --plan` found pending work" | Four exit statuses in a paragraph, all reachable only by typing commands. Nothing says where a window user would ever see one. | Say these appear in the failure report, or mark the paragraph as for command-line use. |
| A command refused me | The whole section is command-line only and its heading does not say so. I read all six rows before realising none of them could be my red row, because I never typed a command. | Retitle to say these are command-line refusals. |
| A command refused me, "`bundle export` reports `--format container` as unknown ... this command cannot be run in this release" | A broken feature with the workaround "Zip the bundle folder by hand". I did not know a bundle was a folder I could see, and nothing says where it is. | Say where the bundle folder lives. |
| A command refused me, "Install both from the Plugin Manager, Tools > Plugin Manager... (Cmd-Shift-B)" | The one row in this section with a window route, and it is the fix for a command I would never have run. Good route, wrong place for me. | None. |
| A command refused me, "Convert it to VCF 4.x with `bcftools convert` or with vcftools' `vcf-convert`" | Two outside programs I do not have, named with no install route and no window alternative. My VCF import is the kind of thing I would do from a dialog. | Say whether LGE can convert it, and if not say so plainly. |
| A command refused me, "Build per-sample `.lungfishfastq` bundles with a FASTQ import recipe" | Recipe is not glossed anywhere in the chapter. I do not know what a recipe is or where one lives. | Gloss recipe and link. |
| The run finished, "On a Genotype only run the value is recorded in the run statistics and never applied as a filter" | This is a setting in a dialog that does nothing, which is exactly my kind of problem, and I had to read it twice to be sure I understood that Min Reads is simply ignored. | Say it plainly in the first clause. |
| The run finished, "Read the read-count column of the report's Long Summary sheet" | Long Summary sheet is not explained. Is it a tab in the window, or a spreadsheet I export? | Say where the sheet is. |
| The run finished, "set aside the thin rows yourself" | Thin is not defined and no threshold is given. I have no way to judge which rows to drop. | Give a starting read count. |
| The run finished, "Take the whole-run depth judgement from `lungfish-cli genotype list-samples`" | The window hides the cohort panel and the only replacement offered is a terminal command. The text does not say the window route is gone for good. | Say plainly that there is no window equivalent in this release. |
| The run finished, "read the field you need out of the provenance sidecar with a JSON reader" | I do not have a JSON reader and would not know how to pick one. The sidecar is glossed by link only. | Name one, or say the sidecar opens in TextEdit. |
| Tools and databases, "The first diagnostic ... is `lungfish-cli debug env --check-tools`" | This whole section's diagnostics are commands. A missing tool is a very likely cause of my red row and I cannot run a single check here. | Say whether the Plugin Manager shows the same information. |
| Tools and databases, "printed `Lungfish 2026.9.13` with `Dependency set: 2026.2 (2026-08-18)` above eighteen tool rows" | Read twice. This describes the author's machine, not mine, and I could not tell whether eighteen rows is what I should expect. | Say this is an example, or cut the counts. |
| Tools and databases, "It exits 10 when work is pending and 0 when there is none, which makes it usable as an assertion in a script" | Assertion and script are for a programmer. I skipped the sentence. | Move to the CI chapter. |
| Tools and databases, "an estimated download of 157.3 MB" | A number from the author's machine that tells me nothing about mine. I first read it as the size I should expect. | Cut or mark as an example. |
| Tools and databases, "`waiting for conda lock held by pid <n>`" | pid is not glossed here, and the angle brackets are a convention I had to work out. | Gloss pid, or write it as a plain number. |
| Tools and databases, "Setting `HTTPS_PROXY` in the shell that launches LGE fixes it" | Shell is not glossed, and I launch LGE from the Dock. I could not do this and the text does not say a window user cannot. | Say this applies only on managed networks and needs help from IT. |
| Containers, "containers, which are isolated environments holding a whole operating system's worth of software" | Read twice. The gloss is fine but it arrives after the heading has already used the word twice. | Gloss in the heading paragraph's first clause. |
| Containers, "switch a Nextflow run to a local `.nf` file or to a conda executor" | Executor is not glossed and neither route is a window route. This is the action for a whole class of failure and I cannot take it. | Give the dialog where the executor is chosen. |
| Containers, "reported macOS Version 26.6.2, 14 CPU cores, 48 GB of physical memory" | Again the author's machine. I have no idea what my numbers should be, or whether 48 GB is required. | Say whether any of these are minimums. |
| Is this file intact, "`--strict` raises the bar" | Raises it how, and when would I want that? No consequence is given. | Say what strict rejects. |
| Is this file intact, "on an ordinary unsigned sidecar it exits 64 with an error rather than a clean pass" | Read twice. The command fails on the normal case, which is the opposite of what a verify command should do, and the sentence buries that in a subordinate clause. | Lead with the fact that verify does not work on ordinary records. |
| Is this file intact, "Missing index files regenerate on their own" | Good. This is the one place the chapter tells me not to worry and I believed it. | None. |
| Is this file intact, "the underlying tools are `samtools faidx`, `samtools index`, and `tabix`" | Three programs I do not have, offered as a manual route with no install step. | Say these are for command-line users only. |
| Reporting, "Open GitHub Issue on the failed row's right-click menu" | Good, a real window route, and the promise that nothing is filed without me was reassuring. | None. |
| Reporting, "add the app version, which the ... About window shows" | This should have been at the top. The chapter's own first section tells me it covers one version and only here do I learn how to check mine. | Move the About route into the opening. |
| Next, "See CLI Reference ... Running in CI ... File Formats" | All three next steps are for command-line users. There is no onward link for someone who only uses the window. | Add a window-side link. |

Three lines.

The one thing I learned. Right-clicking a failed row in the Operations Panel
gives me a Copy Failure Report that already holds everything I would be asked
for, so I never have to describe the failure from memory.

The one thing I still could not do. Clear a project lock. The read-only banner
is named three times and the action is pushed to another chapter every time, so
my window stays read-only and this appendix does not tell me how to fix it.

The sentence I liked most. "You review it and submit it yourself, so nothing is
ever filed without your action."
