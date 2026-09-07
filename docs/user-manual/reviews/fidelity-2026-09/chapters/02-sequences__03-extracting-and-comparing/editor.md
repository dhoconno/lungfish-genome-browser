# Editor pass, 02-sequences/03-extracting-and-comparing

Date: 2026-09-06
Editor: brand-copy-editor

brand_reviewed: false
lead_approved: false

## Changes applied

| Location | Change | Reason | Source |
| --- | --- | --- | --- |
| Frontmatter, `parameters_refs` | Set to `[sequence.find-orfs, sequence.extract-region]` | Both registry ids now exist and the chapter documents both operations | fidelity |
| Frontmatter, `extract-region-dialog` caption | Rewritten around the Action picker, Source summary, flank fields with presets, Options toggles, and the Extract button | The caption described `FASTASequenceExtractionDialog`, not the sheet the marker sits under | fidelity |
| What it is, paragraph 1 | Added a definition of "a stretch" as a region of bases named by a start and an end; dropped the `Extractions/` claim from the opener since it is route-dependent | Readers met an undefined unit; the folder claim is only true of one route | readers, fidelity |
| What it is, paragraph 3 | Replaced "Each route offers the same four places" with a paragraph giving the visible-region route its three-way Action picker and the annotation route its four destinations | False, `ExtractionConfigurationView.swift:92-106` offers three actions | fidelity |
| What it is, share sheet | Glossed the macOS share sheet as the panel that hands the file to another app such as Mail | Four readers did not know what it was | readers |
| What it is, new paragraph after the three routes | Added a sentence stating the window covers the first two routes and the command line is optional except for whole feature sets | Two readers could not tell whether a terminal was required | readers |
| Why you would do this, opening | Added that the record is one downloaded stretch of chromosome 11 holding a cluster | Three readers did not understand why one record holds eight genes | readers |
| Why you would do this, sickle cell | Added the `GAG` to `GTG` change and the glutamic acid to valine swap | Two readers wanted the actual change named | readers |
| Why you would do this, `OR51AB1P` | Glossed pseudogene inline | Four readers stopped on the ungloss | readers |
| Before you start, filename | Added a sentence that `.3` is the record version and later mentions drop it | Three readers could not tell the file and the record apart | readers |
| Before you start, tooling and timing | Dropped the "no external tool" absolute, named the managed `bgzip` and `samtools` the bundle path uses, replaced the unmeasured "under a second" with "fast enough to feel immediate", and said the 25 minutes is on top of reading time | Two unverifiable claims hedged to evidence; two readers could not reconcile the time figures | fidelity, readers |
| Procedure 1, section opener | Added the fixed Before you start sentences with the hbb-gene link | Fixed sentences required for every procedure chapter | consistency |
| Procedure 1, step 1 | Named the ruler's position above the bases, said the placeholder is grey hint text and not something to type, and moved the leave-the-name-off reassurance ahead of the instruction | Three readers each on locating the ruler and on the placeholder | readers |
| Procedure 1, step 2 | Gave the overshoot a size (a few dozen bases usually, a few hundred zoomed out), and replaced the drag-selection warning with "Nothing you highlight with the mouse narrows it" | Four readers wanted a tolerance; two were warned off a feature not yet introduced | readers |
| Procedure 1, step 3 | Rewritten for `ExtractionConfigurationView`, scissors header and Source group, with the "1 selected" count removed | The count belongs to the other sheet | fidelity |
| Procedure 1, step 4 | Replaced the four Destination choices with the Action picker's Copy as FASTA, Copy Protein (CDS only), and New Bundle | No Destination group exists on this sheet | fidelity |
| Procedure 1, step 5 | Rewritten to Bundle Name plus the fixed **Extract** button | This sheet's button never changes label | fidelity |
| Procedure 1, closing paragraph | Removed "Extractions never land in ... `Reference Sequences/`", kept the two fallbacks, and replaced "working directory" with "next to the project folder" | The annotation route does write into `Reference Sequences/`; three readers hit the terminal-only term | fidelity, readers |
| Procedure 2 (annotation), step 1 | Named the annotation lane once as the band of feature blocks above the bases and used that name throughout; added Control-click | Three readers on the lane/track/block naming; one on right-click | readers |
| Procedure 2, steps 2 to 5 | Rewritten as its own five-step sequence for `FASTASequenceExtractionDialog`, carrying the "1 selected" count, the four destinations, the prefilled Name field, and the four-way button label, with a note that a FASTA can hold many records | The chapter previously deferred to the wrong sheet; readers wanted the count and the button label explained at the point of use | fidelity, readers |
| Procedure 2, closing paragraph | New paragraph stating Save as Bundle here writes into `Reference Sequences/` as a derived reference bundle, while the visible-region route fills `Extractions/`, and neither writes into `Imports/` | Corrects the false claim with the reviewer's evidence | fidelity |
| Procedure 2, Copy submenu | Added why only a CDS can be translated | Two readers | readers |
| Heading, "Procedure, marking coding stretches" | Retitled "Procedure, copying and scanning" | The copy subsection sat under a heading promising coding stretches | readers |
| Procedure 3, section opener | Added the fixed Before you start sentences with the hbb-gene link | Fixed sentences required for every procedure chapter | consistency |
| Copy the visible region, step 2 | Replaced the ellipsis-convention explanation with a plain statement that the item runs immediately, and wrote "three dots" | Three readers did not know the convention | readers |
| Find ORFs, step 2 | Dropped the repeated FIND ORFS heading detail | Three readers re-checked for a second window | readers |
| Find ORFs, step 3 | Told the reader to raise Minimum ORF length to 300 for this record, with the reason | Three readers hit the 100 versus 300 gap | readers |
| Find ORFs, step 4 | Said the translation is read in the Inspector when an ORF is selected | Two readers did not know where to look | readers |
| Find ORFs, closing paragraph | Replaced "the window cannot delete a whole track again" with the annotation table drawer's **Delete Track...** and its confirming alert | False, `AnnotationTableDrawerView+Filtering.swift:1207-1215`; "again" also misread by three readers | fidelity, readers |
| Settings, opening sentences | Dropped both "not in the settings registry" sentences and replaced them with per-sheet lead-ins | False, both ids are registered; four readers stopped on the registry mention | fidelity, readers |
| Settings, four new entries | Added **5' Flank.**, **3' Flank.**, **Reverse Complement.**, **Concatenate Exons (remove introns).** | Registry settings of `sequence.extract-region` | fidelity, template |
| Settings, three new entries | Added **Destination.**, **Name.**, **Create Bundle / Save / Copy / Share.** | Registry settings of `sequence.extract-region`, previously prose | fidelity, template |
| Settings, **+1, +2, +3, -1, -2, -3.** | Relabelled from "Reading Frames" to the six checkbox labels the registry carries, and explained why an extracted CDS can only be `+1` | The dialog has no control labelled Reading Frames; three readers could not follow the frame claim | fidelity, readers |
| Settings, **Codon table.** | Default written as `1 - Standard`, matching the menu string | Registry default copied exactly | fidelity |
| Settings, **Minimum ORF length.** | Added that the default suits a short sequence and 300 suits this record | Three readers | readers |
| Settings, **Track name.** and **Track ID.** | Said the name is for reading and the id is for commands, corrected the id's prefill to the generated `orfs-<sequence>` form with the value for this record, dropped the unverifiable uniqueness claim, and told window readers to leave it alone | Prefill claim false; uniqueness unverifiable; four reader hits across the two entries | fidelity, readers |
| Settings, **Allow alternative starts.** | Said bacteria use additional starts beyond `ATG` | Two readers read it as a contradiction | readers |
| Reading the results, the 0-based start | Rewritten to say the bases are correct and only the printed start differs, with the add-one rule, and noted both tokens print the 0-based start | Four readers; the reviewer also flagged "the leading token names the region" as loose | readers, fidelity |
| Reading the results, new table | Added a three-row coordinate-convention table | Three readers had no single place to check | readers |
| Reading the results, token order | Said the feature type token precedes the strand token | `SequenceExtractor.swift:366-375` | fidelity |
| Reading the results, padding example | Stated that the header's `70612-70615` and the command's `70613-70615` are the same span in the two conventions | Four readers could not reconcile them | readers |
| The new bundle | Glossed index files and the SHA-256 checksum, both as things the app writes and the reader never touches | Three readers each | readers |
| The ORF track, 134 | Written as 134 triplets counting the terminal stop, and stated the numbers and letters are the exact expected output | Reviewer note on the stop; two readers on whether the string was illustrative | fidelity, readers |
| The ORF track, 444 bases | Corrected "147 codons" to 148 triplets giving 147 amino acids plus a stop codon | False, 444 is 148 triplets | fidelity |
| The ORF track, `join(...)` | Glossed the GenBank join notation and said it is never typed | Three readers | readers |
| The ORF track, gene callers | Said Prodigal and Prokka are separate command-line tools run outside LGE | Three readers | readers |
| Extracting every feature, "its own provenance" | Changed to "its own source coordinates" | Two readers confused it with the sidecar | readers |
| Extracting every feature, CDS span | Added that CDS extraction uses the CDS's own coordinates, and replaced the `[exons concatenated]` instruction with the visible-region route where Concatenate Exons is on by default | False, the annotation route never sets `concatenateExons`; two readers on the coordinates | fidelity, readers |
| What good looks like, length check | Gave the tolerance in bases | Three readers | readers |
| What good looks like, folder check | Split by route, `Extractions/` for one and `Reference Sequences/` for the other | Follows the corrected folder fact | fidelity |
| What good looks like, first bases | Split the coding stretch into triplets with every amino acid named and the codon 6 change stated | Two readers, one of whom counted an unnamed sixth codon | readers |
| On the command line, opener | Replaced "the window covers everything except deleting a track" with the feature-set case, since the window can now delete tracks | Follows the corrected Delete Track fact | fidelity |
| On the command line, delete comment | Changed "which the window cannot do" to "which the annotation drawer can also do" | Same correction | fidelity |
| On the command line, quoted paths | Added a sentence that the double quotes are shell syntax for the space in the folder name | Two readers | readers |
| On the command line, `extract contigs` | Added `--contig-file` and the 60-column `--line-width` default | Reviewer note, the reader would carry the 70 forward | fidelity |
| On the command line, `--name-prefix` | Restored "name or gene name" from the help text | Reviewer note | fidelity |
| On the command line, `--feature-type` | Dropped `ORF` from the suggested values | Unverifiable whether the literal string matches an ORF track's rows | fidelity |

## Deliberately unchanged

- The Next link and its wording. The project manager repoints it at the gate, so the one-reader mismatch is left alone.
- `GLOSSARY.md`. Pseudogene, share sheet, index, and the GenBank join notation are glossed inline at first use instead, which is what the reader reports asked for and keeps the glossary file with its owner.
- The five shot ids and their markers. Only the `extract-region-dialog` caption needed correcting, and the marker sits under the visible-region step where the rewritten caption now matches.
- "Click an ORF to jump to it." The reviewer could not verify BED-backed feature hit-testing, but nor did any reader stop on it, and the sentence describes generic annotation behaviour the reviewer did confirm.
- The illustration brief for `extraction-header-anatomy`. It describes the header tokens accurately and the illustration is the user's to action.
