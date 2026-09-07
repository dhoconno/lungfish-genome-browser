# Reader report: Importing CZ ID Results

Reader 1, undergraduate persona. Sophomore, one genetics course, never opened a terminal, never used sequencing software.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "compares them against reference databases" | Reference database is never glossed. My class used the word for GenBank, but I could not tell if that is what is meant, or something CZ ID built itself. | Gloss reference database at first use as a named collection of known sequences. |
| What it is, "one row per named group on the tree of life" | I read this twice. "Named group on the tree of life" and "taxon" arrived in the same breath and I could not tell which defined which. | Give the taxon gloss first, then say the report has one row per taxon. |
| What it is, "the same format every classifier in LGE writes" | Classifier is used as if I already know it. I met "classification" in the chapter title but not the machine that does it. | Gloss classifier at first use as a program that names the organism a read came from. |
| What it is, "a Kraken 2 run" | Kraken 2 appears with no explanation and is then used as the comparison point four more times. I have no idea what it is. | One clause saying Kraken 2 is LGE's own classifier, described in an earlier chapter. |
| What it is, "the tab-separated summary format Kraken 2 uses" | TSV is explained much later in Procedure step 1, but tab-separated is used here first and I did not know what a tab character does to a file. | Move the tab-separated values gloss to its first appearance here. |
| What it is, "a FASTQ file" | FASTQ is named with no gloss. I do not know how it differs from the report I am importing. | Gloss FASTQ at first use as the file holding the raw reads. |
| What it is, "So what should you do with this?" | The question is addressed to somebody who already asked something. I had not asked anything and it broke my reading. | Cut the question and keep the instruction that follows. |
| Why you would do this, "a large metagenomic pipeline locally" | Pipeline is not glossed. I could not tell if it is a program, a series of programs, or a machine. | Gloss pipeline at first use as a chain of programs run in order. |
| Why you would do this, "the `.lungfishtax` bundle" | The bundle gloss arrives one sentence after the file extension, and the extension is what confused me. | Say the extension names a bundle before showing it. |
| Why you would do this, "a short fingerprint computed from the file's exact bytes" | I could follow the fingerprint idea but not why a fingerprint proves two files are identical. I read it twice. | Add that any change to the file changes the fingerprint. |
| Why you would do this, "the long tail of one-read hits" | Long tail is jargon. I guessed it means many taxa with tiny counts but I was not sure. | Say plainly that most taxa have only one or two reads. |
| Why you would do this, "This chapter is one of the manual's viral examples" | This sentence explains an editorial policy, not the software. I did not know what to do with it. | Cut, or move to a note. |
| Before you start, "pick a folder" | I could not tell what folder. A new empty one, or an existing one holding my data? | Say to make a new empty folder for the project. |
| Before you start, "`Tests/Fixtures/czid/minimal_taxon_report.tsv`" | A path inside the program's own source code, with no way for me to reach it. I spent a minute wondering if I was supposed to find it. | Say the file is internal to the project and not something the reader opens. |
| Before you start, "No plugin pack is needed" | I do not know what a plugin pack is, so being told I do not need one told me nothing. | Cut, or gloss plugin pack. |
| Before you start, "carries the columns the importer needs" | I could not perform this check. I do not know how to look at the columns of a TSV without opening it in something, and the text does not say what to open it in. | Say to open the file in a spreadsheet program and read the first line. |
| Procedure step 2, "every card is also a drop target for a dragged file" | Drop target is an interface term I had to work out. Also it is a second way to do the same thing, offered before I have done it once. | Move the drag alternative to the end of the step. |
| Procedure step 3.3, "The Project row appears only when the export carries a project identifier" | Three conditional rules about which preview rows appear. I could not tell whether a missing row means my file is broken. | Say plainly that missing rows are normal and not an error. |
| Procedure step 3.4, "read the note under step 5 before you trust what it says" | A forward reference that made me jump ahead and lose my place. The note is then a full paragraph about a bug. | Put the warning inside step 4, not after step 5. |
| Procedure step 3.5, "the same word every LGE dialog uses to commit" | Commit is used in a sense I do not know. My only meaning for it is from a git lecture I did not follow. | Say the button starts the import. |
| Procedure step 3.5, "an amber triangle and the reason appear" | I do not know what a scan failing would look like beyond the triangle, or what I should then do. | Add one sentence saying to pick a different file. |
| Procedure step 4, "Cmd-Shift-P" | Three keys with no explanation, although Cmd-N was explained earlier. I was unsure whether Shift means the arrow key. | Spell this shortcut out the way Cmd-N was spelled out. |
| Procedure step 4, "The row carries the equivalent command line" | I have never opened a terminal, so I do not know what I would do with a command line, or where "copy it out of the panel" leads. | Say this is for readers who use the terminal, and skippable. |
| Procedure step 4, "with any character that is not a letter, a digit, a dot, a hyphen, or an underscore replaced by a hyphen" | One long sentence with a five-item list embedded. I read it three times before I saw it was about renaming. | Split into two sentences, naming the rule first. |
| Procedure step 5, "`/path/to/cz-id-taxon-report.tsv`" | I do not know how to turn "where I saved my file" into one of these strings, and nothing in the chapter shows me. | Add one sentence saying how to get a file's path on macOS. |
| Settings, "The CZ ID import has no settings" | Then three settings are described at length. The section contradicts its own first sentence and I could not tell whether they applied to me. | Retitle the section for command-line-only options. |
| Settings, "--sample-name" | The whole Settings section is unusable to me since I am using the app, but nothing tells me I may skip it until the second sentence. | Say at the top that app users can skip this section. |
| Settings, "--non-host-fastq", "discarding everything matching the host organism" | Host organism was not glossed. In a human sample I could not tell whether the host is the human or the pathogen. | Say the host is the person or animal the sample came from. |
| Reading the results, "The reference import printed this to the terminal" | The whole Reading the results section shows terminal output, but I imported through the app. I could not tell if my screen would show the same thing. | Say where the app shows these same five values. |
| Reading the results, "the `root` row that CZ ID writes to carry the sample's total read count" | I could not judge why a root row exists or whether its number should equal my total reads. | Say root stands for the whole sample. |
| What lands in the bundle, "both source and copy reading `3852c1bd...`" | A truncated number I cannot check and do not know how to compare. | Say the two matching values are what matters, not the digits. |
| What lands in the bundle, "recording the argv, the exit status, the wall time" | Three terms in a row, none glossed, all from a world I have not entered. | Gloss or cut all three. |
| Reading the results, "100.00	1200	1200	R	1	root" | Six columns and only four are later explained. I could not tell what the second and third numbers were until I reached the next paragraph. | Label the columns above the block. |
| Reading the results, "Viruses drew 88 of the sample's 1,200 reads, which is 7.33 percent" | 88 of 1200 is 7.33 percent, but SARS-CoV-2 is 42 of 1200, which I make 3.50 percent only if I round. I checked it twice, unsure whether I had misunderstood. | Show the division once so the arithmetic is visible. |
| Reading the results, "Only the NT read counts reach the kreport" | NT and NR appear throughout with no explanation of what they stand for or why there are two. This is the single thing I most wanted explained. | Gloss NT and NR at first use as the two databases CZ ID searches. |
| Reading the results, "percent identity, alignment length, and e-value" | Three measures I do not know. E-value especially, my class never covered it. | Gloss e-value, or drop the list to just naming that extra columns are kept. |
| The viewport, "one ring per rank outward with each wedge sized by read count" | I could not picture the sunburst from words alone, and the screenshot is only a caption here. | A small labelled figure of the sunburst. |
| The viewport, "the reference bundle reports 3 taxa for a report holding two real ones" | I read this twice. The app appears to say a wrong number on purpose and I could not tell whether that is a bug I should worry about. | Say plainly that the count includes root by design. |
| The viewport, "Reads is the clade count" | Clade is not glossed. I have met it in lecture as a branch of a tree but could not connect that to a read count. | Gloss clade at first use. |
| The viewport, "There is no Bracken column" | Bracken is explained only as a Kraken 2 companion, and Kraken 2 was never explained either. Explaining an absence with two unknowns left me nowhere. | Cut the Bracken sentence for this chapter. |
| The viewport, "**BLAST Verify** and **Export** stay available" | Two buttons named with no idea what either does. | Link each to where it is described, or say briefly what each does. |
| What good looks like, "check that the row count in the Preview panel matches what CZ ID showed you" | I could not judge this. Nothing tells me where CZ ID shows a row count in the browser. | Say where in CZ ID's own page the count appears. |
| What good looks like, "A count far smaller than expected" | Far smaller is not a number. Is half suspicious, or only a tenth? | Give a rough threshold. |
| What good looks like, "the top taxa named in the preview are ones the sample could plausibly contain" | For a sample I did not collect I have no way to judge plausibility, and no example of an implausible one is given. | Give one example of a taxon that should worry the reader. |
| What good looks like, "the report's root row and its taxon rows came from different runs" | I could not follow how a hand-assembled export produces this, and I would not know how to fix it. | Say to re-export the sample from CZ ID. |
| Known defect, "verified in the source at `AppDelegate+ToolsMenu.swift:860-867`" | A source-code line reference means nothing to me and made the paragraph feel written for someone else. | Cut the source reference for readers, or move it to a footnote. |
| On the command line, "The block below reproduces the whole chapter" | The section is six commands long and I cannot run any of them, but it is presented as the summary of everything I just read. | Say the section is for terminal users only. |
| On the command line, "`--format tsv`" and "`--format json`" | JSON is never glossed anywhere in the chapter. | Gloss JSON, or cut the machine-readable forms from a beginner chapter. |
| On the command line, "superkingdom" | The kreport earlier calls 10239 a domain with the code D, and this table calls it superkingdom. I could not tell whether these are the same thing. | Say the two names mean the same rank. |
| On the command line, "NT RPM ... 73333.0" | 88 reads becoming 73,333 per million told me the sample is tiny, but I could not judge whether such a number is normal or alarming. | Say RPM is only comparable between samples, not judged on its own. |
| On the command line, "`lungfish-cli import cz-id` ... `lungfish-cli cz-id import`" | Two commands differing only in word order. I had to read the paragraph three times and still would mistype it. | Set the two forms side by side in a two-row table. |

Three lines.

The one thing I learned: importing a result is not just filing a copy of it, because the pipeline and database versions travel with the numbers and answer the question a reviewer will ask six months later.

The one thing I still could not do: check my own exported report for the three required columns before importing, because the chapter never says what to open a TSV file in.

The sentence I liked most: "The answer lives in a browser tab, in an account, behind a login, on someone else's schedule."
