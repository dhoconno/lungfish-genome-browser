# Reader report: The Lungfish Genome Explorer Project

Reader 4. Undergraduate. Used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A Lungfish Genome Explorer (LGE) project keeps imported files, derived bundles…" | "Derived bundles" is used before "bundle" is defined. The definition arrives many screens later under What "bundle" means. | Gloss bundle in this first sentence. |
| What it is, "and their provenance together in a" | "Provenance" is not glossed here even though it is linked later. In Geneious I never saw this word. | One clause saying provenance is the record of where a file came from and what was run on it. |
| What it is, "Right-click it and choose Show" | I do not know how to right-click on a Mac trackpad, and the manual never says. | Say two-finger click or Control-click once. |
| What it is, "so the project is a folder that has been given a costume." | I read this twice. I could not tell if the costume is a real thing I would see or a figure of speech. | Drop the metaphor or mark it plainly as one. |
| What it is, "`.project.db` is a SQLite database" | I do not know what SQLite is beyond the gloss given, and I cannot tell whether I ever need to care. | Say outright that I never open this file. |
| What it is, "it holds the project's sequence catalog" | "Sequence catalog" is a new term and never returns. | Gloss catalog or drop it. |
| What it is, "its format version" | I do not know what a format version is or what would happen if mine were old. | Point forward to the migrate paragraph here. |
| What it is, "the sidebar can show a stored sequence that has no separate FASTA file of its own in Finder." | I read this twice. I could not work out why that is good news or bad news. | Say what this means for me in one sentence. |
| What it is, "A small number of analyses lean on reference databases tens of gigabytes in size." | I do not know how to judge tens of gigabytes against my laptop. I have 256 GB total and I panicked. | Give the actual figure for the default install. |
| What it is, "takes a compatible LGE version, the same plugin packs" | "Plugin packs" appears before it is explained. It is explained two sections down under Before you start. | Move the plugin pack gloss up, or link it here. |
| What it is, "such as a sequence track, an alignment, a variants table, or a classification chart." | "Sequence track" and "classification chart" mean nothing to me yet. I know alignments from Geneious. | Gloss track once. |
| What it is, "LGE also ships a command-line tool, `lungfish-cli`" | I have never opened a terminal. I could not tell whether I am expected to install this or whether it is already there. | One sentence saying the app installs it and I can ignore it. |
| Why you would do this, "Reads land under `Imports/`, references under" | "Reads" is used as a noun for the first time with no gloss. In class we said sequencing reads. | Gloss read at first use. |
| Why you would do this, "and it arrived with a provenance sidecar, a small JSON file" | I do not know what JSON is. | Four words saying it is a plain text file. |
| Why you would do this, "the accession, the time of the fetch" | "Accession" is not glossed. I have seen accession numbers on NCBI but I am guessing. | Gloss accession at first use. |
| Why you would do this, "and a checksum of the bytes." | I do not know what a checksum is or what I would do with one. | Gloss checksum in half a sentence. |
| Why you would do this, "a mapping with two variant tracks, an assembly, an alignment with its tree, and a classification" | Five unglossed result types in one sentence. I could not picture any of them. | Say these are covered in later chapters. |
| Before you start, "Build it by following the instructions in the manual's fixtures on GitHub at https://" | I could not perform this step. I do not know what to do at a GitHub page, and the instructions there are not described. | Say in one sentence what the linked page asks me to do. |
| Before you start, "which create it at `~/Desktop/lge-docs/LGE Manual Demo.lungfish`" | The `~` is never explained. I could not find that folder by that name in Finder. | Say `~` means my home folder. |
| Before you start, "Docker Desktop is a separate free application" | I could not tell whether I need to install it now or later. The sentence says a few later chapters use it but not whether this matters today. | Say plainly that I do not need it for this chapter. |
| Before you start, "Only the app creates the project store" | I read this whole paragraph twice. Since I never use the command line, I could not tell whether any of it applies to me. | Open the paragraph by saying it matters only if a colleague builds folders for you. |
| Procedure step 2, "It reports whether the Required Setup pack is installed" | I could not perform this step confidently. The text does not say what to do if it reports not installed, only that an Install button exists. | Say whether I should click Install before continuing. |
| Procedure step 2, "moves the shared tool and database root somewhere with more room." | "Database root" is a new term. I do not know how much room is needed, so I cannot judge whether to move it. | Give the disk-space figure. |
| Procedure step 3, "Either card has a menu equivalent, so **File > New Project**" | I read this twice. The last sentence, "The wording differs between the two surfaces and the actions do not," took a third read. | Split that sentence in two. |
| Procedure step 5, "**View > Focus Viewer** (Cmd-Opt-F) hides both at once for a full-width look at a coverage track" | "Coverage track" is unglossed and I have not met coverage yet. | Gloss coverage at first use or pick a plainer example. |
| A tour of the sidebar, "each in its own subfolder named `<tool>-<timestamp>`" | I do not know what the angle brackets mean or what a real folder name looks like. | Show one real example name. |
| A tour of the sidebar, "`Haplotype Definitions/` Shareable haplotype definition files" | "Haplotype" is not glossed anywhere in this chapter. | Gloss haplotype in the table cell. |
| A tour of the sidebar, "LGE prepends it to the top of the tree" | "Prepends" is a word I had to guess at. | Use "puts it at the top". |
| A tour of the sidebar, "De novo assemblies are results" | "De novo assembly" is not glossed. I have heard the phrase and could not define it. | Gloss de novo assembly at first use. |
| What "bundle" means, "a `genome/` folder with the bgzip-compressed FASTA and its indexes" | "Indexes" is used three times and never glossed. I do not know what a genome index is. | Gloss index at first use. |
| Sharing a project, "LGE writes a lock record inside the bundle" | I could not tell whether locks happen to me on my own laptop or only on shared storage. | Say plainly that a single-user project locks and unlocks itself. |
| Sharing a project, "On the command line, `lungfish-cli project lock <project>` takes a lock" | I could not perform any of this and there is no window equivalent given for recovering a stale lock. | Say what I click in the app when I hit a stale lock. |
| Sharing a project, "and reports a legacy schema it has no safe transformer for" | I read this twice and still do not know what "no safe transformer" means for my project. | Say what I do when that happens. |
| Saving and exporting, "Project changes are stored when an import or an edit finishes successfully." | I could not tell whether my typed sample metadata is saved. Nothing here says when typing is saved. | Say when edits in the Inspector are stored. |
| Saving and exporting, "Editing tools may ask you to apply or discard a draft" | "Draft" is new and I do not know which tools have drafts. | Name one. |
| Saving and exporting, "Sequence and annotation exports use an explicit sidebar selection before falling back to the open document." | I read this three times. I could not work out what I have to click to export the thing I mean. | Say it as a two-step instruction. |
| Searching the project, "against a background index" | I do not know what a background index is or whether it needs building first. | Say whether search works right after import. |
| Searching the project, "offering All Project Data, EsViritu, Kraken/Bracken, TaxTriage, FASTQ Datasets" | Four tool names I have never seen, with no gloss. | Say these are analysis tools covered later. |
| Searching the project, "by Min Unique Reads and Min and Max Total Reads" | I do not know how to judge these numbers. No example value is given. | Give one worked example value. |
| Searching the project, "A 'High-confidence pathogens only' checkbox restricts results to flagged pathogens." | I do not know what flags a pathogen as high-confidence. | Say what sets the flag. |
| The Inspector, "Select the `HG002` paired-end FASTQ bundle" | "Paired-end" is not glossed. I have heard it and could not define it. | Gloss paired-end at first use. |
| The Inspector, "a per-base quality summary" | I do not know what per-base quality is or what a good value looks like. | Say what the number means and what is good. |
| The Inspector, "showing the mapped read count, the mean coverage, how evenly that coverage is spread" | Three numbers and no sense of what is good for any of them. | Give a good and a bad value for mean coverage. |
| The Inspector, "to that variant's `INFO` and `FORMAT` fields" | These are unglossed and typeset like code, so I could not tell whether they are buttons or file contents. | Gloss both in one clause. |
| The Inspector, "the supporting read counts on each strand" | "Strand" here means something different from the DNA strands I learned. I read this twice. | Gloss strand in this context. |
| The Inspector, "the ingestion settings recorded at import time" | "Ingestion settings" is new and never returns. | Use "import settings". |
| The Operations Panel, "Cancellation is cooperative, so the tool is asked to stop" | I read this twice. I could not tell how long to wait or what to do if it does not stop. | Say roughly how long a cancel takes. |
| When things go wrong, "**Run Again…** appears at the top when LGE still holds enough of the original request" | I could not tell why it would sometimes be missing, so I would think the app was broken. | Name one case where it is absent. |
| What good looks like, "since that suffix means the bundle was never given a project store or that somebody else holds the lock" | Two causes with one symptom and no way to tell them apart. | Say how to tell which of the two it is. |
| On the command line, the ```bash block | I could not perform any of it, and the backslashes at the ends of lines confused me. | Say the backslash just continues the line. |
| On the command line, "The CLI rejects a `--project` path that does not end in `.lungfish`." | I do not know what `--project` is, since the first command uses `--output-dir` instead for what looks like the same thing. | Explain why the two commands take different flags. |

I learned that the project is a single folder wearing a costume, and that the folder a file sits in tells you where it came from.

I still could not build the demo project, because the chapter sends me to a GitHub page without saying what I would do once I got there.

The sentence I liked most was "A file under `Imports/` came off your own disk, and its history reaches back only as far as your copy of it."
