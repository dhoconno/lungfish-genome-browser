# Editor pass: 01-foundations/06-the-lungfish-project

Date: 2026-09-06
Editor: brand-copy-editor

Chapter: `docs/user-manual/chapters/01-foundations/06-the-lungfish-project.md`

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues after the pass.

## Changes

| Location | Change | Reason | Source |
|---|---|---|---|
| What it is, para 1 | Glossed provenance in the sentence as the record of where a file came from and what was done to it | Term used before explanation, link alone insufficient | readers |
| What it is, para 1 | Replaced "a folder that has been given a costume" with a plain statement that a project bundle is a folder Finder displays as one item, moved to the opening | Metaphor read as ambiguous, readers reread it | readers |
| What it is, para 1 | Changed "Right-click it" to "Control-click it (hold Control and click, or click with two fingers on a trackpad)" and said what Show Package Contents does | Readers could not trigger a right-click on a trackpad | readers |
| What it is, para 2 | Replaced "two files sit hidden at the root" with the corrected wording, "`.project.db` is hidden and `metadata.json` sits in plain sight beside the folders" | Only `.project.db` is hidden; `metadata.json` is visible | fidelity (claim 9) |
| What it is, para 2 | Glossed sequence catalog as the list of sequences the project knows about | Term used without saying what the catalog lists | readers |
| What it is, para 2 | Cut "and you never edit either by hand" to "LGE writes both for you", the never-edit point already made in the preceding sentence | Redundant clause | style |
| What it is, para 3 | Named the Kraken2 standard database as an example and added that LGE checks free space and offers another storage location | No sense of which analyses need the space or whether their disk suffices | readers |
| What it is, para 3 | Glossed plugin packs at this first use as the optional sets of analysis tools LGE installs on request | First use preceded the explanation by two sections | readers |
| What it is, para 3 | Removed the trailing "Beyond those shared installs..." sentence | Paragraph already ran long after the additions, and the point restates the preceding sentences | style |
| What it is, para 4 | Added "Later chapters introduce each of those views in turn" after the four view types | Four unglossed terms in one clause | readers |
| What it is, para 4 | Changed "A fourth surface" to "A fourth window" | "Surface" unsettled readers across the chapter | readers |
| Why you would do this, para 1 | Glossed reads as the short sequence fragments a sequencing machine produces | Bare noun with no gloss | readers |
| Why you would do this, para 2 | Glossed checksum as a short fingerprint showing the file has not been altered | Readers did not know what it proves | readers |
| Why you would do this, para 3 | Replaced the result-type list with "the results of several analyses" | Second unglossed list of result types | readers |
| Before you start, para 1 | Said the linked page asks the reader to paste one command into Terminal and press Return, and that it does need a terminal | Readers could not tell what the page asks or whether a terminal is needed | readers |
| Before you start, para 1 | Glossed `~` as the home folder named after the reader's account | Tilde never explained | readers |
| Before you start, para 2 | Said Docker Desktop runs an analysis tool inside a self-contained package and that it can be skipped for this chapter | Readers did not know what Docker does or whether to install now | readers |
| Before you start, para 3 | Named the project store as the single term, said it is one file inside the bundle rather than the bundle itself | Three names appeared to point at the same thing | readers |
| Procedure step 2 | Added "You do not need to click Install for this chapter, because nothing here runs an analysis tool" | Readers could not tell whether to install before continuing | readers |
| Procedure step 2 | Replaced "shared tool and database root" with "the folder where LGE keeps its shared tools and databases" | "Root" read as a disk root | readers |
| Procedure step 2 | Rewrote the waiting sentence as "the project opens as soon as it finishes" | Readers read waiting as failing | readers |
| Procedure step 3 | Replaced "between the two surfaces" with "between the Welcome window and the menu" | "Surface" unsettled readers | readers |
| Procedure step 5 | Changed "the fourth surface" to "the Operations Panel" and moved Focus Viewer and Restore Side Panes into a following paragraph | "Surface" wording, plus five shortcuts in one step | readers |
| Procedure step 5 | Replaced "a full-width look at a coverage track" with "when a wide result runs off the edge of the centre pane" | Coverage track unglossed, so the reason for the shortcut was lost | readers |
| A tour of the sidebar, intro | Replaced "canonical view" with "authoritative view... trust the sidebar", and marked `Imports/`, `Reference Sequences/`, and `Analyses/` as where bench work starts | "Canonical" carried a different genetics sense; table did not say which folders a beginner uses | readers |
| Sidebar table, `Primer Schemes/` | Glossed primers as the short DNA sequences used to amplify a target region, dropped the bare "Amplicon" stack | Three unfamiliar terms stacked in one row | readers |
| Sidebar table, `Haplotype Definitions/` | Glossed as files listing which allele combinations travel together on one chromosome | "Haplotype" used with no gloss of what the file holds | readers |
| Sidebar table, `Analyses/` | Removed "with its own provenance sidecar" and applied the corrected wording, that most results record provenance beside the output and the Provenance chapter shows where each keeps it | Sidecar is not universal; the demo project has three analysis folders with none, and mapping uses `mapping-provenance.json` | fidelity (claim 38) |
| A tour of the sidebar, after table | Added that the angle brackets stand for values LGE fills in, with the real example `kraken2-2026-09-04T14-12-33` | Readers could not tell if the bracket parts are typed | readers |
| A tour of the sidebar, Analyses caveat | Rewrote "LGE prepends it... assembled from the project rather than read straight off the folder" as LGE building the group from the project's own records, so it can list a result whose files Finder shows elsewhere | Readers reread this and still could not say what changes for them | readers |
| A tour of the sidebar, de novo para | Glossed de novo assembly as building a genome from reads alone with no reference | Never glossed in the chapter | readers |
| What "bundle" means | Added a sentence on what a genome index does | "Indexes" used repeatedly, never explained | readers |
| What "bundle" means | Replaced "seek into" with "jump straight to one part of the file without unpacking the rest" | Not everyday English | readers |
| Sharing a project, para 1 | Replaced "the host, the process" with "the Mac it was taken on, the running copy of the app" | Both terms unfamiliar in this sense | readers |
| Sharing a project, para 1 | Added that the second person can still open and read the project and only writing is blocked | Readers did not know if hitting a lock loses work | readers |
| Sharing a project, para 2 | Added that the window has no button for clearing a stale lock yet, so it is done from the command line | Readers could not act on a stale lock with no window equivalent given | readers |
| Sharing a project, para 2 | Added that `<project>` stands for the reader's own path and the brackets are not typed | Readers unsure whether brackets are literal | readers |
| Sharing a project, para 2 | Replaced "Both accept `--force`, which skips the stale-owner checks" with the corrected wording distinguishing lock from unlock | `--force` on unlock removes another user's lock, which is broader than a stale-owner check | fidelity (claim 48) |
| Sharing a project, para 3 | Glossed schema version as the number recording the layout LGE used, said the reader sees a message when a project needs migrating, replaced "no safe transformer" with "any older layout it cannot safely convert", and said what to do next | Readers could not tell what a schema version is, how they would know, or what to do | readers |
| Saving and exporting, para 1 | Led with "LGE saves for you, and there is no Save or Save As command to look for" | Reassurance arrived after the worry | readers |
| Saving and exporting, para 1 | Named the Inspector's sample metadata fields as a tool that holds a draft, and said a draft is unfinished changes | "Draft" undefined, no tool named | readers |
| Saving and exporting, exports para | Split the export-source rule into two plain steps, sidebar selection first, otherwise what the viewport shows | Readers reread this and could not predict which file they would get | readers |
| Searching the project, para 1 | Added that the reader does not wait for the index and anything imported is findable as soon as the import finishes | Readers did not know if the index must finish building | readers |
| Searching the project, para 2 | Said EsViritu, Kraken/Bracken, and TaxTriage are classification tools covered in the Classification chapters, and to leave the scope on All Project Data until one has run | Tool names unfamiliar and gave no hint what they classify | readers |
| Searching the project, para 2 | Said blank read-count fields are normal, with 50 in Min Unique Reads as a worked first cut | No worked value or sense of reasonable range | readers |
| Searching the project, para 2 | Said the pathogen checkbox restricts to organisms the classification tool itself flagged | No explanation of what sets the flag | readers |
| The Inspector, FASTQ para | Glossed paired-end as two reads from opposite ends of the same fragment | Readers could not define the pairing | readers |
| The Inspector, FASTQ para | Said the per-base quality summary is an average Phred score, with above 30 good and below 20 worth investigating | No sense of what the number measures or a normal range | readers |
| The Inspector, alignment sentence | Replaced the mean coverage and evenness claim with the corrected wording, the mapped and unmapped read counts, the proportion mapped, and the mapper and preset | Neither coverage figure is shown anywhere in the alignment Inspector | fidelity (claim 68) |
| The Inspector, variant sentence | Replaced the `INFO`/`FORMAT`, per-strand counts, and copies-the-position claims with the corrected wording, position, alleles, quality, filter, genotype summary with alternate allele frequency, `INFO` fields, and a Copy Info button that copies the whole summary | No FORMAT section, no per-strand counts, and the button is Copy Info | fidelity (claim 69) |
| The Inspector, variant sentence | Said `INFO` fields come from the VCF format and pointed to the Variant Calling chapters | Code-typeset with no explanation of where the fields come from | readers |
| The Inspector, variant sentence | Said the table drawer is the panel that slides up from the bottom of a reference bundle viewport | Introduced with no mention of where it is | readers |
| The Inspector, para split | Split the long Inspector paragraph in two at the alignment sentence | Paragraph ran long after the glosses were added | style |
| The Operations Panel, para 1 | Said each of the five operation kinds has its own later chapter | Listed with no gloss before any had been introduced | readers |
| The Operations Panel, para 2 | Added that LGE runs command-line tools such as minimap2 and Kraken2 underneath the buttons | Readers did not know why a command would be involved | readers |
| The Operations Panel, para 2 | Named **Clear** as how a failed row is dismissed | Readers could not find how until a later section | readers |
| When things go wrong, intro | Added that a missing menu item means only that the row does not support that action | An absence could look like a breakage | readers |
| When things go wrong, Run Again | Added that it is absent on rows not from a replayable workflow package, an ordinary file import among them | Readers could not tell when the control would be missing | readers |
| When things go wrong, cancellation | Said the row can sit a few seconds while LGE waits for the tool to exit and clears the partial output it owns, and that the row reading cancelled is the signal cleanup is done | Readers could not tell how long a cancel takes or what happens to partial output | readers |
| When things go wrong, failure report | Said the item appears on its own as soon as the failure is recorded | Readers did not know when to look for it | readers |
| Finding this manual | Expanded VCF as Variant Call Format at first use in the section | Used with no expansion | readers |
| Finding this manual | Replaced "the right surface" with "the right menu item" | "Surface" unsettled readers | readers |
| What good looks like | Split the two causes of "(Read Only)" and gave the test that separates them, the **Project Is Open Read Only** message naming the lock holder | Two causes in one clause with no way to tell them apart | readers |
| On the command line, intro | Replaced the blanket optional label, saying the imports are optional and lock, unlock, and migrate are not because the window has no equivalent | The section was the only place those commands are documented, yet marked optional | readers |
| On the command line, intro | Said a trailing backslash only continues the line | Trailing backslashes confused readers | readers |
| On the command line, intro | Said `--output-dir` and `--project` differ by subcommand and that this is how the tool is built, with `--help` to check | Readers could not tell if the differing flags were a mistake | readers |
| On the command line, code block | Added a comment that `--mode` records the kind of lock and exclusive is the one most readers need | No list of allowed modes given, and the CLI help enumerates none | readers |

## Not changed, and why

- **Claim 100, the `--project` extension check.** Kept as written. The
  fidelity review marked it unverifiable from source, and the project manager
  ruled it true on the campaign's own observation of the CLI refusing a path
  without the extension.
- **The eight shot captions.** Left exactly as they were. The project manager
  has ruled that Phase 5 will put an extraction and a replayable operation
  into the demo project before capture.
- **Every other fidelity row.** All remaining claims were verified true and
  no other factual claim was touched.
- **Reader item on per-strand read counts.** The item asked for a clause on
  why the two strands are counted separately. Fidelity claim 69 established
  that the variant Inspector shows no per-strand counts at all, so the fact
  was removed rather than explained.
- **`GLOSSARY.md`.** Not touched. Every term glossed in this pass was glossed
  inline in the chapter, and the existing `glossary_refs` entries all still
  resolve.
- **Chapter structure.** Section order, the shot markers, and the frontmatter
  are unchanged.

## Status

brand_reviewed: false
lead_approved: false
