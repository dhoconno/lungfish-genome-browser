# Editor pass: 02-sequences/01-importing-and-viewing

Date: 2026-09-06
Editor: brand-copy-editor

Order of work was fidelity corrections, then the merged reader report, then
the style pass. Sources are recorded per row as fidelity, readers,
consistency, template, or style.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| What it is, first paragraph | Added that the original file is never altered because the import copies rather than moves. | Two readers could not tell whether their own file on disk was changed by the import. | readers |
| What it is, first paragraph | Added a one-sentence gloss of index as a lookup table recording where each stretch begins, so the app can jump to base 70613 without reading from the start. | All four readers hit "indexes" used before it was defined. | readers |
| What it is, third paragraph | Said all three of GFF3, GTF, and BED are plain-text feature-only formats differing only in column count, and that LGE reads all three the same way. | All four readers could not tell whether the differences between the three mattered. | readers |
| What it is, third paragraph | Reworded "any of the three cannot make a bundle" to "none of them can make a bundle". | Negative-scope construction read as ambiguous. | style |
| Why you would do this, first paragraph | Added that chapter 1 is not required and that the chapter can be followed from Before you start. | Three readers could not tell whether they had to go back to chapter 1. | readers |
| Why you would do this, second paragraph | Defined cluster as a run of related genes side by side, and said the record holds the whole beta-globin family rather than the single gene its name suggests, which is why it is 81,706 bases. | All four readers expected HBB to be one small gene and were stopped by the size and the gene count. | readers |
| Why you would do this, second paragraph | Named the remaining seventy-one features as types the chapter does not break out, and glossed `misc_feature` and `regulatory` in half a sentence each. | Two readers found the named subset did not add to 102, and two more could not judge whether to care about `misc_feature` and `regulatory`. | readers |
| Before you start | Added a paragraph naming the two clicks that save the file from the GitHub folder listing, and where the browser puts it. | All four readers could not work out how to save the file from the linked folder view. | readers |
| Before you start | Replaced the plugin-pack and Docker dismissal with a plain statement that nothing else has to be installed. | All four readers found Docker and plugin pack named only to be dismissed and could not tell whether it was reassurance or warning. | readers |
| Before you start, first two sentences | Left verbatim. | The consistency sheet fixes both sentences with the hbb-gene link. | consistency |
| Procedure, step 1 | Added that only Reference Sequences matters here and the other five tabs belong to later chapters. | Two readers read the tab list as noise. | readers |
| Procedure, attach step 4 | "Click OK" became "Click **Import**". | The alert's buttons are Import and Cancel, with no OK button. | fidelity |
| Procedure, after attach step 4 | "Selecting more than one file skips that alert" became "still shows the alert, but only the Reference choice is used". | The presenter is called unconditionally, and the multi-file branch drops only Track Name and Track ID. | fidelity |
| Reading the results, bundle on disk | "Control-click it in the Finder" became "Right-click it". | Three readers did not know Control-click and right-click name the same action, and the chapter uses right-click everywhere else. | readers |
| Reading the results, bundle on disk | Added that compressed means the same bases in a smaller form with nothing thrown away, read without unpacking first. | Three readers could not tell whether compression lost data. Verified against the `.gzi` block index the bundle carries. | readers |
| Reading the results, Inspector | "Sequence Length row reading 81,706" became "Total Length row reading 81.7 Kb". | The reference row is labelled Total Length and renders through `formatBases` as 81.7 Kb. | fidelity |
| Reading the results, Inspector | Added that a drag switches the Inspector to a Selected Region state, where a Length row gives the dragged size and a separate Sequence Length row gives the whole sequence's size. | The Sequence Length row belongs to that state. Checked the source, where Sequence Length reports the parent sequence and Length reports the selection. | fidelity |
| Reading the results, sidebar | Added **Copy Path**, **Show in Inspector**, **Duplicate**, and the **Move to** submenu after the three named items. | The sentence read as the whole menu but named only three of seven items. | fidelity |
| The viewport, bases lane | Replaced the unexplained "density rendering" with the actual zoom behaviour, coloured blocks tinted for the dominant base, then a plain line further out, letters returning on zoom in. | All four readers had no picture of the zoomed-out view. Written from the rendering thresholds in the source rather than assumed. | readers |
| The viewport, feature count | Replaced the bare total with the ratio of features to length as the thing to compare, and noted that order of magnitude is what matters since curated records run denser than draft ones. Dropped "Around" before the exact 102. | All four readers had no rule for judging another record, and one flagged "Around" beside a number stated exactly earlier. | readers |
| Moving around the record, Go to Location | Moved the warning about dropping the trailing `.3` ahead of the example that needs it. | All four readers typed the coordinate wrong because the warning followed the example. | readers |
| Moving around the record, Go to Location | Said plainly that `GAG` is the normal codon at the sickle cell position, not the sickle variant. | All four readers could not tell which one `GAG` was. | readers |
| Moving around the record, Go to Gene | "opens a picker over the annotation names" became a free-text dialog with the placeholder `e.g., BRCA1 or TP53`, noting nothing is listed to pick from. | The command builds an alert with a free-text field, not a picker. | fidelity |
| Moving around the record, feature click | "Clicking a feature block centres the view on it" became selects it and highlights its drawer row, with **Zoom to Annotation** named as the centring item and double-click as the popover. | Clicking sets the selection and calls the drawer. Neither recentres nor zooms. | fidelity |
| Right-click actions, Copy submenu | Glossed complement and reverse complement where the two menu items are first listed, and said the reverse complement is the one wanted more often. | All four readers met the two items with only one ever explained, and not until later. | readers |
| Right-click actions, Run FASTQ/FASTA Operation | Added that the dialog is where LGE runs the tools transforming sequence and read files, covered by the read chapters, and that the item is a shortcut into work outside this chapter. | All four readers had not met the dialog. Described rather than cross-referenced, since no single chapter owns it. | readers |
| Right-click actions, stacked items | Added that stacking starts when more than one sequence is loaded, which a multi-contig bundle does, so this record never shows the two items. | All four readers did not know what makes the viewport stack. Written from the `isMultiSequenceMode` setters. | readers |
| Translating, genetic code | Added that the source organism and cell compartment pick the table, with the nucleus, mitochondrion, and bacterial cases named and table 1 as the guess when the source is unknown. | All four readers had four tables named with no way to choose. | readers |
| Translating, reading frame | Dropped the duplicate reverse-complement gloss and glossary link now that the term is introduced earlier. | The gloss moved to the Copy submenu, so repeating it read as redundant. | style |
| In the app, two Translate controls | Opened by saying two controls share the name and this section means the toolbar button, then said what each does and when to reach for which. | All four readers could not tell which Translate the chapter meant. | readers |
| In the app, Color Scheme | Said each scheme groups amino acids by a different chemical property, the choice changes only colour, and `Zappo` can be left alone. | All four readers could not judge the choice from the scheme names. | readers |
| Adding one annotation by hand, strand | Added that `+` is right unless the feature is known to read from the other strand, since the dragged bases are the forward strand, and `none` suits a feature with no direction. | All four readers did not know which strand to pick. | readers |
| Find ORFs, Minimum ORF length | Added that human coding sequences run from a few hundred to a few thousand bases, that the HBB coding sequence is 444, and that 100 is generous while 300 trims noise. | All four readers could not judge the default, and the command-line example's 300 was unexplained. The 444 was counted from the fixture's CDS join. | readers |
| Find ORFs, alternative starts | Added that `ATG` is the usual start, some codes allow others mostly in bacteria and mitochondria, and the box stays off for a human nuclear record. | All four readers knew only `ATG`. | readers |
| Removing a track | Said plainly that track deletion is the one task needing the terminal, so the optional section should not be skipped by anyone who has to remove one. | Three readers were blocked by an optional label over the only route to a task. | readers |
| Transferring best-match CDS annotations | Marked the section forward-looking, linked Mapping Reads to a Reference, and glossed mapping, assembly, and CDS models. | All four readers met unglossed terms and a workflow they could not yet perform. | readers |
| On the command line, opening | Said the section is optional with one exception and named track deletion as that exception. | Same reader finding as the Removing a track row. | readers |
| On the command line, coordinates | Added a paragraph setting the 1-based inclusive window convention beside the 0-based half-open `annotate-orfs` flags, worked through the 70545 to 70544 subtraction the block performs. | Three readers could not tell which system a number belonged to. | readers |
| On the command line, translate block | Repointed `translate` from the `.gb` fixture at the bundle's `genome/sequence.fa.gz`. | The printed command exits with `Unsupported format: gb`. The replacement was run against the fixture bundle and wrote a protein FASTA. | fidelity |
| On the command line, extract block | Repointed `extract sequence` at the same `genome/sequence.fa.gz`. | Same failure and same verification. The replacement extracted 1608 bp. | fidelity |
| On the command line, after the block | Added a paragraph saying both commands read FASTA only, naming the `Unsupported format: gb` message, and offering **File > Export > Sequences (FASTA/GenBank)...** as the other route to a FASTA. | The reviewer asked that the FASTA-only constraint be stated plainly. | fidelity |
| What good looks like, first check | "the length in the Inspector reads 81,706" became "the Total Length in the Inspector reads 81.7 Kb", with the rounding explained. | Same Inspector evidence as the Reading the results row. A reader running the check as written would not find 81,706. | fidelity |

## Left unchanged deliberately

- The `viewport-lanes.png` image link and the illustration brief. The asset
  is generated in phase 5 and the project manager accepts the broken image
  until then, so the id and the brief stay as written.
- Every claim the fidelity review marked true, including the 102 features,
  the 81,706 bases, the six Import Center tabs, the contig name, and all
  three Settings paragraphs.
- The Settings labels Reference, Track Name, and Track ID, spelled as the
  registry spells them, and the fixed three-sentence shape of each entry.
- The two fixed Before you start sentences from the consistency sheet.
- Chapter structure, section order, and the shot markers.
- `GLOSSARY.md`, which this pass did not touch.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/02-sequences/01-importing-and-viewing.md`
reports no issues found.

## Status

brand_reviewed: false
lead_approved: false
