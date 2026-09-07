# Reader reports, merged

Chapter: `01-foundations/06-the-lungfish-project.md`

| Location | What stopped readers | Readers | Shortest fix |
|---|---|---|---|
| What it is, "provenance" | Used before it is explained, and the link is not enough on the first sentence. | 4 | Gloss it in the sentence as the record of where a file came from. |
| What it is, Show Package Contents step | Readers did not know what the command does or how to trigger a right-click on a trackpad. | 4 | Say a folder can display as one file, then add "Control-click or two-finger click" to the step. |
| What it is, "the project is a folder that has been given a costume" | Readers could not tell if the costume was literal or a figure of speech and reread the sentence. | 4 | State plainly that it is a folder Finder displays as one item. |
| What it is, "A small number of analyses lean on reference databases tens of gigabytes in size" | No sense of which analyses need this or whether their own disk is enough. | 4 | Name one example database and say the space is checked for you. |
| What it is, "the same plugin packs" | First use of "plugin packs" comes before the term is explained, two sections later in Before you start. | 4 | Gloss plugin packs at this first use. |
| What it is, "such as a sequence track, an alignment, a variants table, or a classification chart" | Four unglossed terms land in one clause and readers could not picture any of them. | 4 | Say these are covered in later chapters. |
| Why you would do this, "Reads land under `Imports/`" | "Reads" is used as a bare noun with no gloss, even though it is what a sequencer produces. | 4 | Gloss reads at first use as the sequence fragments a sequencer produces. |
| Why you would do this, "a checksum of the bytes" | Readers do not know what a checksum is or what it proves. | 4 | Gloss it as a short fingerprint that shows the file was not altered. |
| Before you start, "Build it by following the instructions in the manual's fixtures on GitHub" | Readers could not tell what the linked page asks them to do, or whether it needs a terminal they have never opened. | 4 | Say in one sentence what the linked page asks the reader to do and whether it needs a terminal. |
| Before you start, "Docker Desktop is a separate free application" | Readers do not know what Docker does or whether they need to install it now. | 4 | Add one clause on what it does for LGE and say whether it matters for this chapter. |
| Procedure step 2, "whether the Required Setup pack is installed" | Readers could not tell if they must click Install before continuing. | 4 | Say plainly whether to click Install now. |
| Procedure step 3, "surfaces" | The word is used here, in step 5, and for the Operations Panel, and readers could not settle on what it meant. | 4 | Name the window or panel instead of calling it a surface. |
| Procedure step 5, "a coverage track" | Readers do not know what a coverage track is, so the reason for the Focus Viewer shortcut was lost. | 4 | Gloss coverage or pick a plainer example the reader already understands. |
| A tour of the sidebar, "assembled from the project rather than read straight off the folder it points at" (also "LGE prepends it") | Readers reread this sentence two or three times and still were not sure what it changes for them. | 4 | Say what the reader would notice differently, for example that the group can differ from what Finder shows. |
| A tour of the sidebar, "De novo assemblies are results" | "De novo assembly" is never glossed in the chapter. | 4 | Gloss it as building a genome from reads with no reference. |
| What it is / Before you start, "sequence catalog" and what it holds | The term is used but never says plainly what the catalog lists. | 4 | Say the catalog lists the sequences the project knows about. |
| What "bundle" means, "and its indexes" | "Indexes" is used repeatedly and never explained. | 4 | Add one sentence on what a genome index does. |
| Sharing a project, "Project bundles carry a schema version" / "legacy schema" / "transformer" | Readers could not tell what a schema version is, how they would know theirs is old, or what "no safe transformer" means for them. | 4 | Say what a reader would see if a project needed migrating, and what to do next. |
| Saving and exporting, "Project changes are stored when an import or an edit finishes successfully" | Coming from software with a Save command, readers were unsure their work was safe, and the reassurance arrives after the worry. | 4 | Lead with the plain statement that LGE saves for you. |
| Saving and exporting, "Editing tools may ask you to apply or discard a draft" | "Draft" is undefined and readers could not tell which tools have one or what would be lost. | 4 | Name one editing tool that uses a draft. |
| Saving and exporting, "Sequence and annotation exports use an explicit sidebar selection before falling back to the open document" | Readers reread this two or three times and could not predict which file they would get. | 4 | State it as two short steps, select the item first, otherwise LGE exports what is open. |
| Searching the project, "against a background index" | Readers did not know if the index needs to finish building before search works. | 4 | Say search works immediately after import. |
| Searching the project, Scope selector tool names | The listed tool names were unfamiliar to every reader and gave no hint what they classify. | 4 | Say these are analysis tools covered later, and point to those chapters. |
| Searching the project, "Min Unique Reads" and "Min and Max Total Reads" | No worked value or sense of what is reasonable for these fields. | 4 | Give one worked value, or say it is normal to leave them blank. |
| The Inspector, "paired-end" | Readers had heard the term but could not define the pairing. | 4 | Gloss it as two reads from opposite ends of the same fragment. |
| The Inspector, "the mapped read count, the mean coverage, how evenly that coverage is spread" | Three numbers with no sense of what counts as a good or bad value. | 4 | Give a rough good range for mean coverage. |
| The Inspector, "`INFO` and `FORMAT` fields" | Typeset like code with no explanation of what they contain or where they come from. | 4 | Say they are fields from the VCF file format and point to that chapter. |
| When things go wrong, "Cancellation is cooperative, so the tool is asked to stop" | Readers could not tell how long a cancel takes or what happens to partial output. | 4 | Say the row may take a moment and what happens to any partial files. |
| What good looks like, "since that suffix means the bundle was never given a project store or that somebody else holds the lock" | Two different causes in one clause with no way to tell them apart. | 4 | Say how to tell which of the two causes applies. |
| Sharing a project, "the host" / "the process" | Both terms were unfamiliar in this sense. | 3 | Say the Mac and the running copy of the app. |
| Sharing a project, lock and unlock shown only on the command line | Readers could not act on a stale lock because no window equivalent is given. | 3 | Say what to click in the app when a lock is stale, or say the app has no such control yet. |
| A tour of the sidebar, `Haplotype Definitions/` row | "Haplotype" and "MHC genotyping" are used with no gloss of what the file holds. | 3 | Add a few plain words on what a haplotype definition file holds. |
| The Inspector, "the supporting read counts on each strand" | Readers were unsure this "strand" is the same DNA strand they learned, and why counts split by it. | 3 | Add one clause on why the two strands are counted separately. |
| The Inspector, per-base quality summary | No sense of what the number measures or what a good value looks like. | 3 | Say what the number means and what range is normal. |
| On the command line, lock and migrate shown only here | The section is marked optional, but it is also the only place lock, unlock, and migrate are documented. | 3 | Say in the Sharing section whether the app also covers this, or drop the optional label for these commands. |
| On the command line, `--output-dir` then `--project` for the same path | Readers could not tell if the different flag names across the two example commands was a mistake. | 3 | Say why the two flags differ, or use one flag in both examples. |
| Before you start, three names for the same thing ("project store", `.project.db`, "bundle") | Three names seemed to point at the same thing, with no statement that they are the same. | 3 | Pick one name, say the others are the same thing, then use only that one name. |
| A tour of the sidebar, `<tool>-<timestamp>` | Readers could not tell if the angle-bracket parts are typed or written by LGE. | 2 | Show one real example folder name. |
| Before you start, `~` in a path | The tilde was never explained. | 2 | Gloss `~` as the reader's home folder at first use. |
| Procedure step 2, "database root" | The term "root" read as a disk root rather than a shared-tools folder. | 2 | Name the folder plainly as where LGE keeps its shared tools and databases. |
| Procedure step 2, "Opening a project waits while an installation runs" | Readers first read this as the project failing rather than the project waiting. | 2 | State plainly that the project opens once the install finishes. |
| What "bundle" means, "seek into" | Not everyday English, readers guessed at the meaning. | 2 | Say jump straight to one part without unpacking the rest. |
| The Inspector, "table drawer" | Introduced with no earlier mention of where it is or how to open it. | 2 | Say where the drawer is and how to open it. |
| When things go wrong, "**Run Again…**" absence | Readers could not tell when the control would be missing, so an absence could look like a breakage. | 2 | Give one case where it is absent. |
| Searching the project, "High-confidence pathogens only" checkbox | No explanation of what sets the flag or who decides it. | 2 | Say what the flag is based on. |
| Why you would do this, result-type list ("an assembly, an alignment with its tree, and a classification") | A second unglossed list of result types, separate from the one under What it is. | 2 | Cut the list, or gloss each term in two or three words. |
| A tour of the sidebar, "canonical" | Readers who knew "canonical sequence" from genetics found the word meant something different here. | 1 | Say the sidebar is the authoritative view. |
| A tour of the sidebar, which folders a beginner actually uses | The table lists file extensions but not which folders a bench reader will touch first. | 1 | Mark the two or three folders a beginner uses. |
| Sidebar table, `Primer Schemes/` row | "Amplicon primer-scheme bundles" stacks three unfamiliar terms. | 1 | Gloss amplicon and primer scheme in the row or before the table. |
| Procedure step 5, shortcut count | Five shortcuts in one step, some multi-key, more than a reader could hold at once. | 1 | Move the rarely used shortcuts out of this step. |
| Sharing a project, effect of a lock on the second user | Readers did not know if hitting a lock loses their work or only blocks writing. | 1 | Say the second person can still open the project, only writing is blocked. |
| Sharing a project, `<project>` angle brackets in the CLI example | Readers were unsure whether the angle brackets are typed literally. | 1 | Say the brackets stand for the reader's own project path. |
| The Operations Panel, why the app builds a command | Readers clicking buttons did not know why a command-line tool would be involved underneath. | 1 | Add one clause saying LGE runs command-line tools underneath the buttons. |
| The Operations Panel, dismissing a failed operation | Readers could not find how to dismiss a failed row until a later section named Clear. | 1 | Name Clear in this section. |
| The Operations Panel, five operation kinds | Listed with no gloss, at a point in the manual where none had been introduced yet. | 1 | Say each kind has its own later chapter. |
| When things go wrong, right-click menu items missing | Readers could not predict the menu, so a missing item could look like a problem. | 1 | Say a missing item just means that row does not support the action. |
| When things go wrong, "Reveal Failure Report in Finder" timing | Readers could not tell when the report file is written, so did not know when to look for the menu item. | 1 | Say the item appears on its own right after a failure. |
| Finding this manual, "VCF" | Used with no expansion. | 1 | Expand VCF at first use. |
| On the command line, `--mode exclusive` | No list of the allowed modes is given. | 1 | List the allowed modes, or say exclusive is the only one most readers need. |
| On the command line, backslash line continuation | The trailing backslashes in the code block were confusing. | 1 | Say the backslash just continues the line. |

## Summary

Across all four readers, the most common failure is a term used at first mention with no gloss, then explained later or never, including provenance, plugin packs, reads, checksum, de novo assembly, indexes, and paired-end. The second most common failure is a sentence that states a rule or a cause correctly but packs it so tightly that readers had to read it two or three times, seen in the costume metaphor, the sidebar assembly sentence, the export rule, and the two-cause suffix explanation. The third is a missing point of reference for judging a number or a next action, seen in disk space, coverage, per-base quality, and the search filter fields, where every reader wanted a worked example or a stated range rather than a bare figure.
