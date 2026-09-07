---
chapter: appendices/shared-projects
reviewer: undergraduate-reader
persona: sophomore, one genetics course, never opened a terminal, never used sequencing software
round: 1
date: 2026-09-07
---

# Reader 1 report, Shared Projects and Bundle Migration

| Location | Issue | Suggested fix |
| --- | --- | --- |
| What it is, "is a `.lungfish` folder holding one analysis" | I do not know what "one analysis" means as a unit. Is a project one experiment, one sample, one lab, one paper? Everything after this depends on how big a project is supposed to be. | Add a clause giving one concrete example of what one project holds. |
| What it is, "The record lives at `.lungfish/project.lock`" | A folder name starting with a dot is invisible in Finder, and nobody tells me that. I went looking for it, saw nothing, and thought the chapter was wrong. | Say in one clause that this folder is hidden in Finder. |
| What it is, "The lock is advisory, meaning it works only because" | I had to read this twice. The gloss explains the mechanism but not the consequence I care about, which is whether my labmate can still wreck my project. | Add a clause saying plainly that a non-LGE program, such as a copy in Finder, is not blocked. |
| What it is, "no operation that writes into the project will start" | "Operation" is used here as a technical noun for the first time and never explained. I do not know if opening a viewport counts as an operation. | Gloss "operation" at first use as a named piece of work the app runs. |
| What it is, "every bundle can be inspected" | "Bundle" is used here but not explained until two paragraphs later. I stalled and had to scroll ahead. | Move the bundle gloss before this sentence, or gloss it here. |
| What it is, "`project migrate` is the command that reports" | This is the first command name in the chapter and I do not know where a command goes. The chapter never shows me a terminal or tells me what app to type into. | Name Terminal once here, or point to the CLI chapter. |
| What it is, "run `project migrate` with `--dry-run` first" | "--dry-run" is used before it is explained, and the two leading dashes are unfamiliar. I read them as part of the word. | Gloss "--dry-run" here in one clause as a mode that reports without changing files. |
| Why you would do this, "a project catalog inconsistent" | "Project catalog" appears once and nowhere else. I do not know what a catalog is or whether I would ever see it. | Gloss it, or say "the project's own index of its contents". |
| Why you would do this, "a cached summary the window uses" | I do not know what "cached" means, and "the window" is used as a noun for the app. I read the sentence twice before deciding "the window" meant the main LGE window. | Gloss "cache" once and say "the LGE window" the first time. |
| Before you start, "This appendix uses the demo project" | The build instructions live only on a GitHub page, so I cannot do this step from the text alone. Following a link out to a repository is where I would give up. | Summarize the demo-project build in two or three sentences here. |
| Before you start, "Every command below is a command-line command" | This is where I learn the whole rest of the chapter needs a terminal, and I have never opened one. Nothing tells me how to open one or what I would see. | Add one sentence naming Terminal and pointing to the CLI chapter for setup. |
| Before you start, "Duplicate the demo project in Finder" | I do not know whether duplicating a `.lungfish` folder in Finder is safe, given the chapter has just told me a bundle looks like one icon. Would the copy still work? | State that duplicating in Finder copies the whole bundle intact. |
| Reading the window's read-only state, "when the lock is not from a live local process" | Three unglossed technical words in a row describe when a button appears. I could not predict when I would see the button. | Replace with a plain clause, such as "when the other session is not running on this Mac". |
| Reading the window's read-only state, "the owner and host and process number" | I do not know what a host is or what a process number is for. The chapter shows these fields several more times without explaining what I do with them. | Gloss host and process number once, saying what each tells the reader. |
| Reading the window's read-only state, "a checksum of the archived bytes" | "Checksum" is never explained and I do not know what one is for. | Gloss checksum in one clause as a fingerprint used to tell whether a file changed. |
| Reading the window's read-only state, "naming the lock's tool, its status, its mode" | Six fields are listed but none is explained, and I cannot judge whether any value in the banner is good or bad. | Say in one sentence which field the reader should actually look at. |
| Reading the window's read-only state, "has no project store" | "Project store" is new here and never defined. I could not tell what is missing or how it got that way. | Gloss project store as the app's own index file inside the project. |
| Locking a project from the command line, "cannot be read as valid JSON" | I do not know what JSON is. I guessed it is a file format only because the word looks like one. | Gloss JSON once as a plain-text format the app writes settings in. |
| Locking a project from the command line, "`--mode exclusive`" | The example command uses a flag before the chapter explains modes, and the backslash inside the path looks like a typo to me. | Explain the backslash-before-space convention in one clause at the first command. |
| Locking a project from the command line, "On success it prints three lines and exits 0" | "Exits 0" is used as if I know it. I had to guess that zero means success, which is backwards from grading. | Gloss exit codes once, saying 0 means success and anything else means failure. |
| Locking a project from the command line, "The record it writes holds twelve fields" | Twelve items run together in one sentence and I lost my place halfway. This is the hardest sentence in the chapter to follow. | Break into a short list, or cut to the three fields that matter. |
| Locking a project from the command line, "an opaque identifier for the Mac itself" | "Opaque identifier" stopped me. I read it as meaning unclear rather than meaning not human-readable. | Say "an identifier for the Mac that does not change when the network does". |
| Locking a project from the command line, "so `exclusive` and `maintenance` block writes" | This is the first mention of a `maintenance` mode. I do not know what other values `--mode` takes or where the full list is. | Name the accepted values of `--mode` in one clause. |
| Locking a project from the command line, "the process id in the record belongs to that one short-lived command" | I read this paragraph three times. The point seems to be that a command-line lock is nearly useless, which contradicts the earlier advice to take a lock before scripted maintenance. | State the conclusion first, then the reason. |
| Locking a project from the command line, "a script that needs an unbroken hold" | I do not know what a script is in this context or how I would keep an LGE process alive. This is advice I cannot act on. | Point to the CLI chapter for what a script is, or drop the sentence. |
| Locking a project from the command line, "Verified on a copy, `project lock --force`" | "Verified" appears three times in the chapter and reads like a note the writer left for another writer, not something for me. | Move the verification asides to a footnote or remove them. |
| Unlocking a project, "it belongs to the current user on this machine and its owning process has exited" | The two allowed cases are stated as one long conditional and I had to diagram it on paper. | Split into two short sentences, one per case. |
| Unlocking a project, "isn't in the correct format.. Inspect the lock file" | There is a double period inside the quoted error. I assumed it was a typo in the manual rather than a real message. | Note in one clause that the doubled period comes from the app. |
| Migrating older bundles, "reports the schema each one is written to" | "Schema" was glossed earlier as a number, but here a file is "written to" one. The two uses do not match and I lost the thread. | Use "schema version" consistently. |
| Migrating older bundles, "Bundles inspected: 4 / Current: 1 / Unsupported: 2" | I cannot judge these numbers, and ten lines later the chapter tells me the counts are wrong on purpose. Until then I did not know whether my own run was broken. | State up front that the counts are unreliable, before showing them. |
| Migrating older bundles, "any folder whose extension begins with `lungfish`" | I do not know what a folder's extension is, since folders in my experience do not have extensions. | Say the folder name ends in a dot plus a word starting with lungfish. |
| Migrating older bundles, "Those bundle types store their metadata under a different filename" | "Metadata" is not glossed anywhere in this chapter. | Gloss metadata once as information about the data rather than the data itself. |
| Migrating older bundles, "`migration-available` is counted in no line at all" | This reads like a bug described as a quirk, and I could not tell whether to report it or ignore it. | Say plainly whether this is expected to change. |
| Migrating older bundles, "a cache in a reference bundle's manifest holding the chromosome list" | I know what a chromosome is, but not why the app needs a stored list of them or what breaks without it. | Say in one clause what the reader would notice if the cache is missing. |
| Migrating older bundles, "A reference manifest at format version 1.0" | "Format version" appears here, "schema version" earlier, and bare "schema" in between. I could not tell whether these are three things or one. | Use one term for the version number throughout. |
| Migrating older bundles, "`tsv` is accepted but currently prints the same text report" | This tells me a documented option does not work. I do not know whether to avoid it forever or just for now. | Say whether this is a known defect being fixed. |
| Provenance expectations, "writes no provenance sidecar and neither should it" | "Provenance sidecar" is linked but not glossed in this chapter, and I do not know what a sidecar is. | Gloss sidecar in one clause as a small companion file stored next to the data. |
| Provenance expectations, "It records the tool name and version, the reproducible command, the input files" | Another run-on list, eleven items long. I skimmed it, which I do not think was the intent. | Cut to what the reader would look up, or make it a short list. |
| Provenance expectations, "The wider rule is a requirement on migrations LGE has not written yet" | This section describes rules for software that does not exist. As a student I could not tell why I am reading it. | Say in the first sentence of the section that this paragraph is a promise about future versions. |
| What good looks like, "a second attempt against a live owner exits 1" | This contradicts the earlier finding that a second `project lock` succeeds because the first owner is already dead. I could not tell which behavior to expect. | Add the qualifier that this applies only while the owner is still running. |
| What good looks like, "suspect the project before the app" | I do not know what "suspect the project" means as an action. There is no next step. | Name one thing to check first. |
| See also, "for how a read-only project refuses a workflow run" | "Workflow" is used throughout the chapter without a gloss, and I never learned what one is. | Gloss workflow at first use, in the read-only section. |

Three lines.

I learned that a lock in this app is a note other copies of the app agree to respect, not a real barrier.

I still could not open a terminal or run a single command from this chapter, because the text never says where commands are typed.

The sentence I liked most is "The lock turns a silent corruption into a visible refusal, which is the whole point of it."
