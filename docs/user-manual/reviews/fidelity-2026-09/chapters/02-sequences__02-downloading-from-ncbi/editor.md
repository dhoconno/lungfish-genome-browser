# Editor pass: 02-sequences/02-downloading-from-ncbi

Date: 2026-09-06
Role: brand-copy-editor

Applied in order: fidelity corrections, the merged reader report, the
consistency sheet, the chapter template, then the style pass. The chapter
lints clean with `LUNGFISH_MANUAL_STRICT=1`.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Frontmatter, `ncbi-search-dialog` caption | "GenBank and Genomes" to "GenBank & Genomes" | Pane title on screen carries an ampersand | fidelity (22) |
| What it is, para 2 | "GenBank and Genomes pane" to "GenBank & Genomes pane" | Same label mismatch | fidelity (22) |
| What it is, para 2 | Added a one-sentence gloss of "index" as a lookup file that lets the app jump to a position | Term used repeatedly and never explained | readers (15) |
| What it is, para 2 | Added that macOS shows the bundle as a single item you double-click | Readers unsure whether to treat a `.lungfishref` folder as file or folder | readers (38) |
| What it is, para 3 | Added "and GFF3 is version 3 of that format" | Readers unsure whether GFF and GFF3 are the same thing | readers (43) |
| What it is, para 3 | Glossed "variant caller" inline as the program that reports where a sample differs from the reference | Term arrives before any variants chapter | readers (23) |
| What it is, para 4 | Glossed "read" as one stretch of sequence produced by the sequencing machine | Noun used before it is defined | readers (36) |
| Why you would do this, para 1 | Added the nuclear genome size (roughly 3.1 billion bases) beside the ratio | Ratio had no comparison number | readers (44) |
| Why you would do this, para 2 | Said the rCRS is simply the standard name for this record, and gave the abbreviation | Name arrived unexplained | readers (16, 61) |
| Why you would do this, para 2 | Said GenBank is one of the formats the same record comes in | Readers thought two files were being described | readers (51) |
| Why you would do this, para 2 | Said the 77 total includes other feature types besides the three listed | Listed counts do not sum to the total and readers tried to reconcile them | readers (24) |
| Why you would do this, para 2 | Added that a coding sequence is the translated stretch inside a gene | Readers could not distinguish CDS from gene | readers (52) |
| Why you would do this, para 3 | Rewrote so RefSeq is described as records NCBI staff choose, and the stability reason now precedes the promise that depends on it | "Curated subset" did not land, and the reasoning read backwards | readers (37, 45) |
| Before you start, para 1 | Opens with the consistency-sheet sentences, then says there is nothing to download first because the chapter fetches the record live | Fixed opening required, adjusted for a live-fetch chapter | consistency |
| Before you start, para 1 | Glossed "fixture" as the manual's own frozen copy | Readers could not tell whether a download was needed | readers (17) |
| Before you start, para 1 | Named Cmd as the Command key | A reader on a Windows keyboard did not know the key | readers (46) |
| Before you start, para 2 | Said the plugin pack and Docker Desktop are optional installs covered later | Readers read them as a missed install step | readers (18) |
| Before you start, para 2 | Replaced "the bundle build runs inside the app" with the bundle build using the samtools tooling LGE ships with | The build shells out to bgzip and samtools faidx and pre-flights them | fidelity (105) |
| Procedure, step 1 | "GenBank & Genomes pane" | Label mismatch | fidelity (22) |
| Procedure, step 1 | Added a clause saying Nucleotide is the collection of single records | The reason Nucleotide is right came only in Settings | readers (62) |
| Procedure, step 2 | Said an accession query returns one result or a small handful | Readers did not know what success looks like | readers (56) |
| Procedure, step 2 | Said the screenshot shows the panel opened, for reference only | Screenshot contradicted the step | readers (40) |
| Procedure, step 3 | Moved the fifty-record confirmation out of the step, into the closing paragraph, and stated what the prompt says | Did not apply to a single-record download and readers could not tell what it does | readers (19) |
| Procedure, step 4 | "reporting each stage in the Download Center rather than in the Operations Panel" | Progress goes to the Download Center, not the Operations Panel | fidelity (18) |
| Procedure, step 5 | Said `Downloads/` is a folder inside the project, not the system Downloads folder | Readers guessed wrong | readers (25) |
| Procedure, closing paragraph | Corrected the Include GFF3 Annotations claim: the box skips the GFF3 fetch only, never the bundle, and a record with a FEATURES table still yields a GenBank-derived track | The chapter said the bundle would hold bases alone | fidelity (20), readers (35) |
| Settings, lead-in | Rewrote the two-group split so the Pathoplexus group starts at the **Organism** paragraph describing the chip row, and said four labels repeat across panes | The old seam was wrong by fifteen paragraphs | fidelity (21), readers (10) |
| Settings, lead-in | Said five settings appear only in Virus mode | A reader thought a third pane had been missed | readers (60) |
| Settings, lead-in | Added a sentence saying the command-line closing sentences can be skipped | Readers who never open a terminal could not tell whether to act on them | readers (7) |
| Settings, **Mode.** | Replaced "the NCBI Datasets virus service" with "NCBI's separate virus collection", and glossed assembly | A fourth named service readers could not place, and no gloss for assembly | readers (26, 53) |
| Settings, **RefSeq Only.** | Dropped "nucleotide" from the first sentence | The toggle applies in Virus mode too, and the registry carries no mode qualifier | fidelity (25) |
| Settings, **RefSeq Only.** | Put the common case first and the exception second | The advice read backwards to a student reader | readers (33) |
| Settings, **Include GFF3 Annotations.** | Replaced "amino-acid reporting" with being told which protein change a mutation causes, and said the bundle is still produced | Undefined term carrying the whole justification, and an unclear scope | readers (47, 35) |
| Settings, **(search scope).** | Described the control as the unlabelled popup at the right-hand end of the query field | Control named only by a bracketed description | readers (27) |
| Settings, **Organism.** (NCBI) | Named the pane in the first sentence | Two entries share the label | readers (10) |
| Settings, **Molecule Type.** | Glossed transcript as the RNA copy made from a gene, with introns spliced out | Readers could not choose between mRNA and Genomic DNA | readers (54) |
| Settings, **Sequence Length.** (NCBI) | Named the pane, and gave a worked minimum of 16000 for the mitochondrial example | Two entries share the label, and no number was given | readers (10, 55) |
| Settings, **Sequence Properties.** | Glossed CDS and Source, and stated the checks combine with AND | Terms unexpanded and the combination rule unclear | readers (34, 42) |
| Settings, **Host.** (Virus mode) | Named the pane alongside the mode | Two entries share the label | readers (10) |
| Settings, Pathoplexus group | Added a lead-in paragraph marking where the Pathoplexus settings begin | Reused labels lost readers | readers (10) |
| Settings, **Host.** (Pathoplexus) | New paragraph in the fixed three-sentence shape, label copied from the registry | Registry setting was undocumented | fidelity (44) |
| Settings, **Sequence Length.** (Pathoplexus) | New paragraph in the fixed three-sentence shape, label copied from the registry | Registry setting was undocumented | fidelity (44) |
| Settings, **Nucleotide Mutations.** | Added the literal example strings `C180T` and `C180T, A200G` | No worked example, so readers could not build an entry | readers (8) |
| Settings, **Amino Acid Mutations.** | Added the literal example string `GP:440G` and said further entries are comma-separated | Same problem | readers (9) |
| Settings, **INSDC Source.** | Said Non-INSDC Only gives the records deposited to Pathoplexus alone | Readers could not see why anyone would want them | readers (39) |
| Reading the results, para 1 | Gave the route from the sidebar to the Finder via Show in Finder, then Show Package Contents | The chapter had kept readers inside the sidebar until this point | readers (20) |
| Reading the results, para 2 | Dropped the "all 77 features" bridge; the no-filter claim now stands on the GFF3's own rows | 77 is the GenBank FEATURES count, not the GFF3 track's row count | fidelity (49) |
| Reading the results, para 2 | Said the `.db` file is internal and not meant to be opened, and dropped "database engine" | The gloss used a further unfamiliar term | readers (31) |
| Reading the results, para 3 | Said the fallback track still works, and told the reader to delete and re-download if they want the GFF3 track | Readers were alarmed with no action to take | readers (11) |
| Reading the results, para 4 | Said the rest of the section is reference material and not a step to take | Readers read values they could not act on | readers (21) |
| Reading the results, para 4 | "wallTimeSeconds read 0.61 for that run" to "reads 0.61" | Past tense beside present tense in one list | readers (32) |
| Reading the results, para 5 | Checksum verb to present tense, and said nothing needs typing to see it | Same tense issue, and a reader did not know how to produce one | readers (32, 59) |
| What good looks like, length check | Replaced "well below" with "under 16,000", and added what a near-miss means | No threshold to judge against | readers (12) |
| What good looks like, annotations check | "the fallback described above ran" | Points back to the new remedy paragraph | readers (11) |
| What good looks like, folder check | "the project's `Downloads/` folder", and "the Download Center row" for a missing bundle | Same surface error as step 4, plus the system-folder ambiguity | fidelity (70), readers (25) |
| Section heading, accession substitution | Retitled "When a download returns a different accession" and added an opening line telling dialog users they are unaffected | The command-named heading made dialog readers skip a warning that concerns them | readers (13) |
| Accession substitution, para 3 | Dropped "The command's own help states this" and folded the silence into the sentence | Cited help text the reader cannot see | readers (50) |
| Searching Pathoplexus, para 1 | Rewrote the organism list to the app's display names, including "Crimean-Congo hemorrhagic fever" and "Human metapneumovirus", with the two ebolaviruses as separate names | Display names differed from the chapter, and counting the old phrasing gave eleven | fidelity (74, 75), readers (48) |
| Searching Pathoplexus, para 1 | Said LGE fetches a segmented genome one segment at a time | Readers wanted to know what a segmented download does | readers (28) |
| Searching Pathoplexus, para 3 | "nine filters" to ten, split into the nine in the panel and the scope popup outside it | The panel holds ten filters counting the shared scope popup | fidelity (51), readers (29) |
| Searching Pathoplexus, para 3 | Replaced "AND logic" with a record must match every filter you fill in | Unfamiliar computing term | readers (14) |
| Searching Pathoplexus, para 3 | Said the submitter sets the OPEN status | Readers did not know who sets it | readers (49) |
| Searching SRA | "The third item" to "The second item" | SRA sits between Search NCBI and Search Pathoplexus | fidelity (80) |
| Searching SRA, para 2 | Cut the toolkit and subcommand detail down to a pointer, with a line saying nothing extra needs installing | Terminal-only tool names in a section framed as a pointer | readers (22) |
| On the command line, para 3 | Added a line saying the trailing backslash continues the command and is typed | Readers could not tell it from a line-wrap artifact | readers (30) |
| On the command line, para 4 | Glossed an API key as a free identifier from NCBI and said the chapter works without one | Readers did not know what one is | readers (57) |
| On the command line, `fetch search` para | Corrected the contrast: `--db` reaches a protein collection the Mode picker lacks, since the picker does offer Genome, and split the sentence in two | The old contrast named the wrong collection | fidelity (99), readers (58) |

## Deliberately left unchanged

Row 12, the `File > New Project` and Welcome window route, is the fidelity
review's one unverifiable. The wording is the consistency sheet's fixed
opening sentence, so it stays as written and the claim is the Foundations
chapter's to verify. Nothing was hedged, because hedging a fixed sentence
would break the phrasing every other chapter shares.

Row 90, the `NCBI_API_KEY` environment fallback, was marked changed pending
verification. It was verified in this pass against
`Sources/LungfishCLI/Commands/FetchCommand.swift:461` and
`Sources/LungfishCore/Services/NCBI/NCBIService.swift:89`, so the clause
stands as written.

Both **Organism** paragraphs keep the bare label in bold, since the linter
matches the registry label verbatim and a suffix such as "(Pathoplexus)"
would fail settings coverage. The disambiguation the readers asked for is
carried in each paragraph's first sentence and in the group lead-ins
instead. The same applies to **Host** and **Sequence Length**.

`GLOSSARY.md` was not touched. Every new gloss is a one-sentence inline
explanation of the kind the consistency sheet asks for, and no new term was
introduced that needs an entry.

## Status

brand_reviewed: false
lead_approved: false
