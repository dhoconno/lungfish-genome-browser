# Editor pass: 01-foundations/08-provenance-and-reproducibility

Date: 2026-09-06
Role: brand-copy-editor

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/01-foundations/08-provenance-and-reproducibility.md`
reports no issues found.

## Changes

| Location | Change | Reason | Source |
|---|---|---|---|
| Frontmatter, `inspector-provenance-section` caption | "Files and Outputs, Invocation and Options" became "Files & Outputs, Invocation & Options" | The app renders both titles with an ampersand | fidelity (row 36) |
| Frontmatter, `glossary_refs` | Added `bundle`, `conda`, `pileup` | Three terms newly glossed in the body need their anchors declared | readers |
| What it is, para 1 | Sidecar glossed as a file that rides alongside the result and shares its name, with the motorcycle image made explicit; JSON gloss moved into its own sentence | Three readers read "sidecar" as a motorcycle term with no picture of a file beside a file | readers |
| What it is, para 2 | "A sidecar answers one question." kept, and the sentence after it punctuated as a question | One reader noted the question was punctuated as a statement | readers |
| What it is, para 2 | Added that the Procedure opens the sidecar inside LGE, and that the code block is a record rather than something to type | Three readers could not tell how to open a sidecar, three met a command before knowing whether to run it | readers |
| What it is, after code block | New sentence explaining that `...` marks a path the manual shortened | Two readers could not tell whether the dots were real text | readers |
| What it is, checksum para | "a single changed base" became "any change to the file at all, a single edited base or a single edited header character" | Two readers could not tell whether a header edit changes the string | readers |
| What it is, checksum para | New sentences saying LGE computes and compares checksums, so the reader reads a match or a mismatch | All four readers stalled on how a checksum is ever compared. The most common failure in the report | readers |
| Why you would do this, para 1 | Glossed bcftools at first use, glossed conda with a Glossary link, and named which piece of `bioconda::bcftools=1.24=h6bd33b9_2` is the channel, the version, and the build | Three readers hit bcftools and conda unglossed, two could not parse the package string | readers |
| Why you would do this, para 1 | "Its HG002 variant track" became "Its variant track" | The HG002 gloss now arrives in para 3, so the label is not needed before it | readers |
| Why you would do this, para 2 | "every supported workflow" became "every workflow it runs" | Three readers could not tell whether their own work counted as supported, and the qualifier was droppable | readers |
| Why you would do this, para 3 | Glossed HG002 as a widely shared human reference sample and minimap2 as the program that places reads onto a reference | Three readers could not tell whether HG002 is a person, a sample, or a file | readers |
| Before you start, para 1 | "which create it at ..." became "which have you create the project in the app at ... and then fill it in about two minutes" | The fixtures page does not create the demo project. The reader creates it in the app and the script fills it | fidelity (row 16) |
| Before you start, para 1 | Added that creating the project is clicks and filling it is one line pasted into Terminal | All four readers could not tell whether the fixture build needs a terminal | readers |
| Before you start, para 2 | "needs a plugin pack of its own or Docker Desktop" became "needs its own set of tools installed or any extra software" | All four readers were unsettled by "plugin pack" and "Docker Desktop" arriving unexplained only to be dismissed. Glossing two terms the chapter never uses again costs more than removing them | readers |
| Procedure step 4 | "in the table drawer" became "in the Variants tab of the table drawer", with the drawer located as the panel that slides up from the bottom of a reference bundle viewport and opened by clicking a variant track | CONSISTENCY fixes the surface name on first mention, and all four readers asked where the drawer is and how to open it | fidelity (row 23), readers, consistency |
| Procedure step 4 | Added that samtools, bgzip, tabix, and the staging steps are internal bookkeeping the reader need not follow | All four readers could not tell whether they had to learn those tools | readers |
| Procedure step 5 | Added that all six formats work and that Methods Section is the one to start with | Two readers could not tell whether the four unnamed formats work or which to pick | readers |
| Procedure, export-folder paragraph | Folded into step 5 as an indented continuation rather than a body paragraph after the list | All four readers lost their place at an unnumbered paragraph. A sixth numbered step would break the five-item list cap, so the text now sits inside the step it belongs to | readers, style |
| Settings, **Provenance.** | Added a clause glossing Nextflow and Snakemake as pipeline systems a collaborator may already run | All four readers could not judge whether either applied to them | readers |
| Settings, **Save As.** | Example default changed from `sample-provenance-nextflow` to `chr20_10.0-10.5Mb-provenance-nextflow` | Two readers could not tell whether "sample" was a literal word LGE writes. The registry's own example uses `sample`, but the label and the three sentences are unchanged | readers |
| Settings, **Save As.** and **Where.** | The two flag sentences now say the single `--output` path carries both the folder name and its location | All four readers read two fields mapping to one flag as a contradiction | readers |
| Reading the results, block list | "Files and Outputs, Invocation and Options" became "Files & Outputs, Invocation & Options" | The app renders both titles with an ampersand | fidelity (row 36) |
| Reading the results, block list | "A filter field labelled Filter provenance sits above them" became "appears above them once a record is long enough" | The field is conditional on step or row counts, not always present | fidelity (row 38) |
| Reading the results, Run Summary | Signatures now points forward to "Signing a record" | Two readers met signing here and did not reach its explanation until much later | readers |
| Reading the results, Lineage | Added a gloss of standard error as the channel a tool uses for its own progress notes | All four readers read it as a statistics term or an unexplained failure | readers |
| Reading the results, Lineage | "step 3 is the pileup and step 4 is the call" became "step 4 is the pileup and step 5 is the call" | Step 3 of the demo sidecar is `samtools faidx`. `bcftools mpileup` is step 4 and `bcftools call` is step 5 | fidelity (row 45) |
| Reading the results, Lineage | Glossed pileup with a Glossary link, and said what the call step decides | Three readers hit pileup and call unglossed | readers |
| Reading the results, **Files & Outputs.** | Bold lead retitled with the ampersand | The app renders the title with an ampersand | fidelity (row 36) |
| Reading the results, **Files & Outputs.** | Added that LGE does the comparing and that the reader reads the first few characters only for reassurance | Two readers could not tell how to compare two checksums once shown | readers |
| Reading the results, **Invocation & Options.** | Bold lead retitled with the ampersand, and "explicit or default" became "explicit, default, or resolved default" | The app renders the title with an ampersand and labels rows with three kinds | fidelity (rows 36, 51) |
| Reading the results, **Invocation & Options.** | "The thread count lives here" became "A thread count can appear here", and "recorded `-t 14`" became "ran with `-t 14`, which the mapping step's Command records" | On the demo sidecar the thread count reaches the reader through the step's Command, not as an Invocation & Options row | fidelity (row 52) |
| Reading the results, **Invocation & Options.** | Added that 14 describes the machine and is not a number to copy or tune | All four readers could not tell whether 14 was a good number | readers |
| Reading the results, **Runtime.** | Added a gloss of dependency set as the versioned collection of tools LGE installed for itself | All four readers hit "dependency set" undefined | readers |
| What the export folder holds | The six format-to-filename pairs became a table, and Nextflow's row gained the `containers` folder | All four readers lost track of which file belongs to which format, and the real export writes a `containers/` directory the sentence omitted | readers, fidelity (row 58) |
| What the export folder holds | "A script pulled out on its own will not run" became "is unlikely to run" | The claim was not verified by running the exported script, so it is hedged to what the evidence supports. The exporter does copy the records into `provenance/`, which is why the hedge is not a retraction | fidelity (row 63, unverifiable) |
| What the export folder holds | Added that no menu equivalent exists for locking a project on shared storage, and named `lungfish-cli` as the command line tool | Three readers met a terminal command with no menu alternative offered | readers |
| What good looks like, para 1 | "Files and Outputs" became "Files & Outputs", and the step-count check gained the demo project's eleven as an anchor | The app renders the title with an ampersand, and all four readers had no baseline count to judge against | fidelity (row 36), readers |
| What good looks like, para 2 | Reordered to lead with the harmless copied-file case and close with the bug case | All four readers had to reread to sort out which case applied | readers |
| What good looks like, para 2 | The empty-state wording now names the Provenance section's status line, reading Missing provenance or No provenance required, with the No Provenance Available alert named as what an export attempt raises | "No Provenance Available" is an export alert, not the Inspector's empty state | fidelity (row 69) |
| What good looks like, para 3 | Added a size for a typical cross-machine shift, a handful of borderline calls out of thousands | All four readers had no sense of how large a shift to expect | readers |
| What good looks like, para 3 | "the thread count in Invocation and Options" became "the thread count recorded in the run's commands" | Same defect as row 52. The demo project records the thread count in the step's Command | fidelity (row 70) |
| Signing a record | Opens by saying most readers leave signing off and can skip ahead, and glosses Cosign as an external signing service used in software supply-chain work | Two readers could not tell whether to act, and all four hit Cosign unglossed | readers |
| On the command line, lead | Opens by saying the section is optional because the Procedure is already done, and that two of three subcommands have no menu equivalent | All four readers found the section assumed a terminal with no word on whether they needed it | readers |
| On the command line, lead | "Each takes a sidecar file, a bundle, or an output directory" split so that `export` and `verify` take all three and `bibliography` takes a bundle or an output directory | `bibliography` does not accept a bare sidecar file | fidelity (row 78) |
| On the command line, lead | Added a gloss of `~` as the home folder | Three readers hit the tilde unexplained | readers |
| On the command line, fourth example | `provenance bibliography` now points at the chr20 reference bundle rather than the project root | Run against the project root the command errors with "No Lungfish provenance sidecar found" | fidelity (row 82) |
| On the command line, verify paragraph | "reports that the signature is valid and names what it checked" became "reports that the signature is valid" | No signed sidecar was available to confirm what the success line names, so the unconfirmed half of the claim is dropped | fidelity (row 87, unverifiable) |
| On the command line, bibliography paragraph | Added that the command wants a bundle rather than the project folder, which holds no sidecar of its own | The general form of the same error the fourth example hit | fidelity (row 82) |

## Left unchanged

The bundle name is written `chr20_10.0-10.5Mb` in every body mention and
`chr20_10.0-10.5Mb.lungfishref` in the command line paths, which is the same
name plus its extension rather than two spellings. Reader 3's report of two
spellings appears to come from comparing the body with the frontmatter caption,
which is not reader-facing prose.

`GLOSSARY.md` was not touched. Its `run-record` entry lists the seven blocks
with "Files and Outputs" and "Invocation and Options", which the ampersand
correction now contradicts. That is a Glossary edit this role does not own, so
it is routed to the Documentation Lead rather than made here.

Row 36's fourth site, "the closing paragraph of What good looks like", is the
Files & Outputs mention in the four-checks paragraph. Both instances the
fidelity note counted in that section were corrected.

## Status

brand_reviewed: false
lead_approved: false
