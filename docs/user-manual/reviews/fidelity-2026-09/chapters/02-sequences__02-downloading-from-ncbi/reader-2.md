# Reader report: Downloading from NCBI

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "What lands is a reference bundle, a folder..." | A folder that is also a file with an extension. I could not picture whether I double-click it or open it. | One sentence saying macOS shows it as a single item even though it is a folder. |
| What it is / "holds the sequence, its indexes, and any..." | "Indexes" is never glossed. I do not know what a sequence index is or why one exists. | A four-word gloss at first use. |
| What it is / "Leave the Include GFF3 Annotations checkbox on" | GFF3 has a 3 in it but the glossary link says GFF. I read it twice wondering if they are two things. | Say once that GFF3 is version 3 of GFF. |
| What it is / "because a variant caller can only report" | "Variant caller" arrives with no gloss, in a chapter that comes before any variant chapter. | Gloss it, or say "a later step that finds differences". |
| Why you would do this / "That record is the revised Cambridge Reference" | I could not tell if "revised Cambridge Reference Sequence" is a formal name I should recognise or just a description. | Say it is the standard name, abbreviated rCRS. |
| Why you would do this / "among them 13 protein-coding sequences, 22 transfer" | 77, 13, 22, and 2 do not add up and I spent time trying to make them. | Say the 77 includes other feature types besides these. |
| Before you start / "You can read the fixture's notes in the manual's" | "Fixture" is used as if I know it. I do not know what a fixture is in this app. | Gloss fixture at first use. |
| Before you start / "Nothing in this chapter needs a plugin pack" | Plugin pack and Docker Desktop are both dropped in with no explanation. Reassuring but confusing. | Say they are extra installs covered elsewhere. |
| Procedure step 2 / "The Advanced Search Filters panel below the field" | The screenshot callout here is for the filters panel, but the step tells me to leave it collapsed. I did not know whether to click Show. | Say plainly that the screenshot shows it expanded for reference only. |
| Procedure step 3 / "Ticking more than fifty records asks you" | I am downloading one record. This made me stop and check I had not done something wrong. | Move it out of the numbered step. |
| Procedure step 5 / "The sequence fills the viewport and the annotation" | "Viewport" is used without a gloss here and throughout. I guessed it is the main window. | Gloss viewport once. |
| Settings / "The controls below belong to two panes of the same" | Twenty-plus settings run together with no headings, and I lost track of which pane I was in halfway down. | A subheading per pane. |
| Settings / Mode / "Virus queries the NCBI Datasets virus service" | "NCBI Datasets" is a fourth thing after Nucleotide, Genome, and GenBank. I could not place it. | Drop the service name or gloss it. |
| Settings / Mode / "On the command line this is `--db`." | I have never opened a terminal. These trailing flags appear in nearly every entry and I did not know if I was meant to act on them. | One line at the top of Settings saying to ignore the command-line notes. |
| Settings / RefSeq Only / "which is what you want when you are looking" | The default being off is justified by a use case that is the opposite of mine. I could not tell what to do. | Say what a first-time reader should leave it on or off. |
| Settings / Include GFF3 Annotations / "the nearest equivalent is `--fasta-only` on `fetch genome`" | "Nearest equivalent" plus "skips both the annotations and the bundle" made me unsure whether the checkbox also skips the bundle. | Say the checkbox never affects the bundle. |
| Settings / (search scope) / "**(search scope).**" | A setting named in brackets with no real name. I could not find it in the dialog from this. | Name it as it appears on screen. |
| Settings / Sequence Properties / "among Has CDS, Has Gene, Has Source" | CDS and Source are unglossed. I know what a gene and a tRNA are. | Gloss CDS and Source. |
| Settings / Host through Annotated Only / "In Virus mode, keeps only records" | Five Virus-mode settings sit inside what the lead-in called two panes. I thought I had missed a third pane. | Say up front that Virus mode adds its own filters. |
| Settings / Organism (second entry) / "On the Pathoplexus pane this is the chip row" | Organism is defined twice, hundreds of words apart, and "chip row" is not a term I know. | Rename the second entry and gloss chip. |
| Settings / Nucleotide Mutations / "written as reference base, position, and new base" | I could not build an example from this description. | Show one worked example. |
| Settings / Amino Acid Mutations / "written as a gene name and a change separated" | Same problem, and the manual avoids colons in sentences, so I could not tell if the colon is literal. | Show one worked example. |
| Reading the results / "Right-click it in the Finder and choose Show" | The bundle was in the app sidebar. I did not know how to get from there to the Finder. | Say how to reveal it in the Finder. |
| Reading the results / "It is a SQLite database, a single-file database" | Glossed, but I still did not know whether I am ever supposed to open it. | Say it is internal and not for opening. |
| Reading the results / "Nothing warns you when that happens." | Alarming, and the fix is not stated in this section. | Point at the check in the next section. |
| Reading the results / "Inside that file the endpoint reads `https://eutils" | A dense list of nine field values from a command I will never run. I read it twice and got nothing. | Cut it or move it into the command-line section. |
| Reading the results / "`wallTimeSeconds` read 0.61 for that run" | I could not tell whether 0.61 is a target I should compare my own run against. | Say it is an example, not a benchmark. |
| What good looks like / "A number well below that usually means a partial" | I do not know how far below counts as "well below". | Give a threshold. |
| What good looks like / "check the Operations Panel row for the download" | The Operations Panel is mentioned in step 4 and again here, but never located. | Say where the Operations Panel is. |
| When fetch genome returns a different accession / heading | The whole section is about a command I will never type, yet it sits between two things I do need and ends by telling me a check applies "every time". | Mark the section as command-line only. |
| Searching Pathoplexus / "Some of them are segmented, meaning the genome" | I understood segmented, but not what changes for me if a bundle is segmented. | Say what a segmented download produces. |
| Searching Pathoplexus / "they combine with AND logic across organism" | "AND logic" is a computing term I have only met inside a search box. | Say all filters must match at once. |
| Searching Pathoplexus / "The nine filters described in the Settings section" | I counted the Pathoplexus entries and reached nine only by including Organism, which is the chip row and not in the filters panel. | Match the count to the panel. |
| Searching SRA / "with `search`, `download`, and `info` subcommands" | Subcommands, `prefetch`, `fasterq-dump`, and the SRA Toolkit all arrive at once in a section I was told was only a pointer. | Cut to the sentence saying reads have their own chapter. |
| On the command line / "This section is optional." | Good to know, but the two earlier command-line sections were not marked optional and I had already read them. | Move the optional marker earlier. |

Learned: an accession's version suffix matters, and typing the `.1` protects me from silently getting a different sequence than a colleague did.

Could not do: tell, while reading the Settings section, which of those two dozen controls I actually needed to touch for the one download the Procedure asked me to make.

Liked most: "Curators revise deposited sequences and the version number ticks up when they do, so a bare accession can quietly give you a different sequence than a colleague got last year."
