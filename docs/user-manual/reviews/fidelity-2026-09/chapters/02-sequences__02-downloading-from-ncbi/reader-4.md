# Reader report: Downloading from NCBI

Persona: a student who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "What lands is a [reference bundle]" | I do not know what "indexes" are. In Geneious a sequence was just a sequence. The word appears again in Reading the results and I still never learn what an index is for. | Gloss "index" once, the way accession is glossed. |
| What it is / "Annotations matter downstream because a variant" | "Variant caller" arrives with no explanation and no link, and "downstream" is used as if I already know the pipeline. | Say in half a sentence what a variant caller is. |
| Why you would do this / "That record is the revised Cambridge" | I had to read this twice. I could not tell whether "revised Cambridge Reference Sequence" is a second name for NC_012920.1 or a different thing I also need. | Name it as the record's other name outright. |
| Why you would do this / "The GenBank version of the record" | Suddenly there is a "GenBank version" as well as the record. Are these two files? I thought I was downloading one thing. | Say that GenBank is a format the same record comes in. |
| Why you would do this / "13 protein-coding sequences, 22 transfer" | I know what these are from genetics, but I cannot tell whether 77 features is a lot or normal. The text says it is dense but gives me nothing to compare against. | One clause saying what a typical record of this size carries. |
| Before you start / "Nothing in this chapter needs a plugin" | I do not know what a plugin pack is, or Docker Desktop. I cannot tell if this sentence means I am fine or means I should go check something. | Say plainly that nothing needs installing. |
| Before you start / "You can read the fixture's notes in" | I do not know what a "fixture" is. The sentence then tells me the chapter does not use it, so I could not work out why I was being sent to GitHub at all. | Drop the term or gloss it. |
| Procedure step 1 / "Leave **Mode** on Nucleotide and leave" | This is the first time Nucleotide appears and I do not know why it is the right one until the Settings section, much later. | One clause here saying Nucleotide is single records. |
| Procedure step 2 / "The Advanced Search Filters panel below" | The shot callout under this step is for the filters panel, but the step tells me to leave it collapsed. I could not tell if I was supposed to click Show to match the picture. | Say whether the picture shows an optional state. |
| Procedure step 3 / "Ticking more than fifty records asks" | I am downloading one record, so I could not work out why fifty matters here or what the confirmation would say. | Move this out of the numbered step. |
| Procedure step 5 / "Find the finished bundle under `Downloads/`" | I do not know whether `Downloads/` is my Mac's Downloads folder or something inside the project. I guessed wrong at first. | Say it is inside the project folder. |
| Settings / "**Mode.** Chooses which NCBI collection" | "NCBI Datasets virus service" is a fourth named thing and I cannot tell if it is a website, a database, or part of the app. | Cut the service name or gloss it. |
| Settings / "On the command line this is `--db`" | Every Settings entry ends with a command-line note. I never open a terminal, so I read fifteen of these before realising none of them are for me. | A line at the top of Settings saying these can be skipped. |
| Settings / "**(search scope).** Restricts the query text" | The heading is literally "(search scope)" in brackets. I looked in the dialog description for a control with that name and there is not one. | Name the popup as it appears on screen. |
| Settings / "**Organism.** Adds an organism term" (twice) | There are two entries called Organism and I did not notice the second one belonged to a different pane until I had read past it. | Distinguish the two headings. |
| Settings / "**Sequence Properties.** Keeps only records" | "the checked properties combine so a record must have all of them" took two reads. I think it means AND, but I was not sure. | Say the checks are combined with AND. |
| Settings / "**Nucleotide Mutations.** Keeps only records" | "written as reference base, position, and new base" gives me no example, so I would not know what to actually type. | Give one worked example string. |
| Settings / "**Amino Acid Mutations.** Keeps only records" | Same problem, and "antibody-escape site" is unexplained. | Give one worked example string. |
| Settings / "**INSDC Source.** Splits records by whether" | I could not work out why I would ever want Non-INSDC Only, or what makes such a record different apart from where it lives. | Say what is gained by that setting. |
| Reading the results / "Right-click it in the Finder and choose" | The bundle is in the app sidebar. I did not know how to get from the sidebar to the Finder, and the text does not say. | Say how to reveal it in the Finder. |
| Reading the results / "It is a SQLite database, a single-file" | This is glossed, but I could not tell whether I am ever meant to open it or whether it is internal plumbing. | Say it is internal. |
| Reading the results / "Nothing warns you when that happens" | This alarmed me. I am told a silent fallback exists, told the two runs can differ, and never told what to do about it. | Say what to do if the fallback name appears. |
| Reading the results / "Running the fetch shown at the end" | This whole paragraph is about a command-line run. I did not run one, so I could not tell whether my download has a sidecar too. | Say the sidecar is command-line only. |
| Reading the results / "`retryCount` reads 0 with an empty" | A run of field names and values I have no way to judge. I do not know what any of them should be. | Keep only the fields I can act on. |
| Reading the results / "`wallTimeSeconds` read 0.61 for that" | The tense reads wrong, "read" for one value after "reads" for the others, and I had to reread the sentence. | Match the tense. |
| What good looks like / "A number well below that usually means" | "Well below" gives me no threshold. Is 16,000 fine? Is 15,000 wrong? | Give a number to compare against. |
| When fetch genome returns a different / heading | The heading is a command I will never type, so I nearly skipped a section about a silent wrong-sequence problem. | Title it for the problem, not the command. |
| When fetch genome returns / "The command's own help states this" | I cannot see the command's help, so this is a citation I cannot follow. | Cut it or quote the line. |
| Searching Pathoplexus / "Some of them are segmented, meaning" | The gloss is there, but I could not tell what a segmented genome means for my download. Do I get three bundles or one? | Say what arrives for a segmented record. |
| Searching Pathoplexus / "they combine with AND logic across organism" | "AND logic across organism, provenance, and sequence attributes" was the hardest sentence in the chapter. I do not know which filter is in which category. | Drop the three categories. |
| Searching Pathoplexus / "LGE retrieves only records marked OPEN" | I do not know what marks a record OPEN, or who decides. | Say who sets that status. |
| Searching SRA / "Its help states that downloads use" | ENA mirrors, SRA Toolkit, `prefetch`, and `fasterq-dump` all arrive in one sentence and none of them are things I could act on. | Cut to a pointer to the reads chapter. |

The one thing I learned: an accession's version suffix matters, and typing `NC_012920.1` rather than `NC_012920` is what stops me getting a different sequence than a colleague got.

The one thing I still could not do: tell whether my own downloaded bundle got its annotations from GFF3 or from the silent GenBank fallback, and what I should do if it was the fallback.

The sentence I liked most: "Curators revise deposited sequences and the version number ticks up when they do, so a bare accession can quietly give you a different sequence than a colleague got last year."
