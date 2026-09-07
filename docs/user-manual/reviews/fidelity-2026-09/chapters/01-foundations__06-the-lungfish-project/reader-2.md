# Reader report: The Lungfish Genome Explorer Project

Reader 2. A senior who has pipetted for two years and never analyzed data. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "A Lungfish Genome Explorer (LGE) project keeps..." | "provenance" is used as if I know it. It links to a glossary but I do not want to leave the page on the first sentence. | Gloss it in place, one clause, the first time it appears. |
| What it is / "Double-click it and the app opens rather..." | I could not tell whether "the app opens" means the app opens the project, or just the app opens empty. | Say "the project opens in LGE". |
| What it is / "Right-click it and choose Show..." | On my laptop trackpad I have no right button. I did not know what to do. | Add "or Control-click". |
| What it is / "What you see there is an..." | "the project is a folder that has been given a costume" made me read the paragraph twice to check I had not missed a technical meaning. | Drop the metaphor or put it after the plain statement. |
| What it is / "Inside that bundle, two files sit..." | Hidden where? I have never seen a hidden file in Finder and do not know how to make one visible. | One sentence saying you do not need to see them. |
| What it is / "`.project.db` is a SQLite database, which..." | "sequence catalog" is new and it does real work later, in the Analyses caveat. | Gloss catalog once, as the list of everything the project knows about. |
| What it is / "A small number of analyses lean on..." | "reference databases tens of gigabytes in size" arrives with no sense of whether I need to worry. Do I need that much free space now? | Say when this matters, for example only for certain classification runs. |
| What it is / "Reproducing it on another Mac takes..." | "plugin packs" appears here but is only explained two sections later, in Before you start. | Gloss at first use, not at second. |
| What it is / "The viewport fills the centre and..." | "a sequence track", "an alignment", "a variants table", "a classification chart" is four terms in one sentence and I know none of them from the bench. | Say these are each covered in later chapters. |
| What it is / "LGE also ships a command-line tool..." | I do not know what a command-line tool is, and the backticked name looked like something I was meant to type. | Say plainly it is an optional text-based way to do the same things, and that this chapter does not use it. |
| Why you would do this / "Reads land under `Imports/`, references under..." | "Reads" is not glossed anywhere in this chapter, and it is the thing I actually generate at the bench. | Gloss reads at first use here. |
| Why you would do this / "When you later need to reproduce..." | The phrase "a checksum of the bytes" earlier in the paragraph. I do not know what a checksum is or why it makes something reproducible. | One clause, a fingerprint that shows the file was not altered. |
| Before you start / "Build it by following the instructions..." | A bare GitHub URL. I could not tell if I download something, copy text, or run something. The two-minute claim did not tell me what I actually do. | Say what you get at that link and what kind of steps they are. |
| Before you start / "Nothing here needs a plugin pack..." | I do not know what Docker Desktop is beyond "a separate free application", which does not tell me why it exists. | Say what it does, in one clause. |
| Before you start / "One rule about who creates a..." | I could not perform anything from this paragraph. It is a rule about a tool I am not using and I could not tell whether it affected me. | Move it to the command-line section, or mark it as only mattering if you use the CLI. |
| Before you start / "A folder built only from the..." | "read-only view of the files" left me unsure whether my data is at risk or just uneditable. | Say the files are safe, you just cannot add to them. |
| Procedure step 2 / "Read the setup panel before you..." | I did not know whether I should click Install now or later, and the step never tells me. | Say whether to install before continuing this chapter. |
| Procedure step 2 / "Opening a project waits while an..." | I read this twice. I could not tell if it is a warning or a reassurance that nothing breaks. | Say it plainly, you cannot open a project until it finishes. |
| Procedure step 3 / "The wording differs between the two..." | "surfaces" is used here, in step 5, and in the Help section. I could not work out what a surface is. | Use window or panel instead. |
| Procedure step 5 / "**View > Focus Viewer** (Cmd-Opt-F) hides..." | I do not know what a coverage track is, so the reason for the shortcut was lost on me. | Give a reason I already understand, such as making the middle pane as wide as possible. |
| A tour of the sidebar / table row "`Reference Sequences/`" | The table gave me file extensions but no sense of which folders I will actually use as a bench person. | Mark which two or three folders a beginner touches. |
| A tour of the sidebar / "The Analyses group in the sidebar..." | "assembled from the project rather than read straight off the folder it points at" is the hardest sentence here. Three readings and I am still unsure of the consequence for me. | Say what I would notice, for example the group can differ from what Finder shows. |
| A tour of the sidebar / "De novo assemblies are results, so..." | "De novo assemblies" is not glossed and is not in the glossary list at the top. | Gloss it, building a genome from reads with no reference. |
| What "bundle" means / "It is a directory holding a..." | Five file and folder names in one sentence. I could not hold them, and I do not know what indexes are. | Gloss indexes once, and consider a short list. |
| Sharing a project / "The record names the user, the..." | "the host" and "the process" mean nothing to me. | Gloss both, or cut them. |
| Sharing a project / "On the command line, `lungfish-cli project..." | The angle brackets confused me. I did not know if I type them. | Say the brackets stand for your own project path. |
| Sharing a project / "Project bundles carry a schema version..." | I do not know what a schema version is or how I would find out mine is old. | Say what I would see if a project needed migrating. |
| Saving and exporting / "Project changes are stored when an..." | Coming from lab software I expected a Save button. The section tells me there is none, but only at the end, after I had gone looking. | Lead with the plain statement that LGE saves for you. |
| Saving and exporting / "Editing tools may ask you to..." | "a draft" is vague. I could not tell what would be lost if I discarded one. | Name what a draft is in this app. |
| Saving and exporting / "Sequence and annotation exports use an..." | "before falling back to the open document" needed two readings, and I still could not predict which file I would get. | Say it as a simple rule, exports what is selected, otherwise what is open. |
| Searching the project / "Type into it and LGE searches..." | "against a background index" told me nothing I could act on and made me wonder if results would be stale. | Cut it, or say results may lag briefly on a new project. |
| Searching the project / "A Scope selector narrows the search..." | Four tool names I have never heard of, listed with no hint of what they classify. | Say these are analysis tools covered later. |
| Searching the project / "Below it, fields filter by Keywords..." | Min Unique Reads and Min and Max Total Reads are numbers I am asked to supply, and nothing tells me how to judge a good value. | Give one worked value, or say leaving them empty is normal. |
| The Inspector / "Select the `HG002` paired-end FASTQ bundle..." | "paired-end" and "FASTQ" both arrive unglossed, and they are the formats I will meet first from a sequencer. | Gloss both here. |
| The Inspector / "Select the `HG002` paired-end FASTQ bundle..." | I can read the mean length and the per-base quality summary but I do not know what a good value looks like. | State what a typical value is before saying what to do with it. |
| The Inspector / "Select an alignment track inside a..." | Mapped read count, mean coverage, evenness. Three more numbers with no way to judge any of them. | Give a rough good range for coverage. |
| The Inspector / "Click a row in the Variants..." | "the table drawer" appears here for the first time with no explanation of where it is or how to open it. | Say where the drawer is and how to open it. |
| The Inspector / "Click a row in the Variants..." | `INFO` and `FORMAT` look like they are shouted at me, and I have no idea what they contain. | Gloss both, or point to the VCF chapter. |
| The Operations Panel / "Failed operations stay until you dismiss..." | I could not find how to dismiss one until the next section mentioned Clear. | Name Clear here. |
| When things go wrong / "**Run Again…** appears at the top..." | I could not tell when it would not appear, so I would not know if something was broken. | Give one case where it is absent. |
| When things go wrong / "Cancellation is cooperative, so the tool..." | I read this twice. I could not tell how long a cancel takes or whether my partial output is left behind. | Say the row may take a moment, and what happens to partial files. |
| What good looks like / "Confirm the window title carries the..." | I could perform three of the four checks. This one refers back to the project-store rule I had already skipped as CLI-only. | Restate the cause in plain words here. |
| On the command line / "This section is optional. The app..." | I have never opened a terminal, so I could not run any of it. The `\` line breaks and the quoted paths looked fragile and I would not know if I had typed them right. | Say the section can be skipped entirely by app users. |

One thing I learned. The project is a single bundle on disk, and the folder a file sits in tells you where the file came from, so `Downloads/` versus `Imports/` is information and not just tidiness.

One thing I still could not do. Build the demo project. The chapter sends me to a GitHub link without telling me what happens there, and every screenshot afterwards assumes I succeeded.

The sentence I liked most. "A file under `Imports/` came off your own disk, and its history reaches back only as far as your copy of it."
