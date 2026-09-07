# Editor pass: 02-sequences/04-aligning-sequences

Date: 2026-09-06
Role: brand-copy-editor

Applied in three ordered passes. First the six false rows and two
unverifiable rows from `fidelity.md`. Then `readers.md`, taking every item hit
by two or more readers plus the single-reader items whose fix is one sentence.
Then the style pass against `STYLE.md` and `CONSISTENCY.md`.

Lint after the pass: `no issues found`.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Frontmatter, `mafft-dialog` caption | "Sequences to align scope picker" became "scope summary line", matching what the shot will actually contain for a whole-file run | The picker is hidden in the procedure's own case | fidelity |
| What it is, conservation paragraph | Glossed residue as one base in DNA or one amino acid in a protein, and moved a worked 4-of-5 example ahead of the definition | Residue was unglossed and the arithmetic arrived before any example | readers |
| What it is, bundle paragraph | Added that the bundle can be copied, moved, renamed, and backed up like an ordinary file | Readers could not tell what a folder-shown-as-a-file permits outside the app | readers |
| What it is, bundle paragraph | Linked MAFFT to its glossary entry at first mention | Named with no link | readers |
| Why you would do this | Added a five-row table of label, accession, species, and length, plus a sentence saying all five sit in the one fixture file | Readers could not map a length to a record and did not know the five shared a file | readers |
| Why you would do this | Named the gorilla as shortest and the cynomolgus macaque as longest where the range is first given, and called the 163-base spread ordinary | The later gap-column sentence relied on a shortest record never named, and readers could not judge the spread | readers |
| Before you start, download sentence | Added that the link opens a folder listing, so click the file then click Download raw file | All four readers stalled at the link | readers |
| Before you start, plugin pack | Named the list row and the Install button, and said the download needs an internet connection and nothing after it does | Readers did not know what to click or whether the network was needed | readers |
| Before you start, plugin pack | Said the 7.526 version number is recorded for reproducibility and asks nothing of the reader | Readers did not know whether the number required action | readers |
| Before you start, import sentence | Named the imported bundle as `.lungfishref` and related it to the `.lungfishmsa` bundle the run produces | Reference bundle was unglossed and indistinguishable from the alignment bundle | readers |
| Before you start, runtime claim | Removed "takes under a minute on this input on a current Mac" as a standalone claim and hedged it into the post-Run paragraph as "short, well under the time it takes to read the next section" | Unverifiable row. Nothing in source or provenance records a runtime | fidelity |
| Procedure step 1 | Named `Reference Sequences/` as the sidebar folder and gave Cmd-A as the select-all gesture | No gesture and no location were given | readers |
| Procedure step 2 | Led with the reassurance that the reader is in the right place before explaining the FASTQ/FASTA Operations title | The confusing title was explained but never dismissed | readers |
| Procedure step 3 | Rewritten to the reviewer's corrected wording. The step now describes the summary line for the whole-file case and states that the radio group appears only on a partial selection | **False row.** `MSASequenceScopePicker.isVisible` requires `0 < selectedCount < allCount`, so both branches of step 1 hide the picker the old step told the reader to set | fidelity |
| Procedure step 4 (old Batch Output step) | Deleted the step and renumbered | **False row.** `MultiBundleRunModePicker.isVisible` requires two or more input files, so the row is not on screen for this one-file procedure | fidelity |
| Procedure, post-Run paragraph | Added that the dialog closes and a run row with a progress bar appears in the Operations panel | Readers did not know what to expect right after Run | readers |
| Procedure step 4 (Strategy) | Added that Advanced Options should stay collapsed unless a named symptom appears | Readers could not tell what they were safely leaving alone | readers |
| Procedure, realignment paragraph | Added the mechanism, that old gaps are read as real data on a second pass and MAFFT aligns to them and inserts more | Readers accepted the warning on faith | readers |
| Import an alignment built elsewhere | Added that a2m and a3m come from profile search tools such as HMMER and HHsuite and most readers will never meet one | The two formats were bare and unplaceable | readers |
| Settings, intro paragraph | Named which five settings are in plain view and which six are in Advanced Options, by their first and last entries | The five-and-six split was never mapped onto the headings | readers |
| Settings, Sequences to align | Added that the radio group appears only on a partial selection, and gave one example each of a full FASTA header, a bare accession, and an alignment label | Consistency with the corrected procedure, and readers could not tell the three input forms apart | fidelity, readers |
| Settings, Batch Output | Label corrected to "Combine all inputs, run once (1 result)", the registry's exact spelling. Added that the row appears only at two or more input files, and that locked means greyed out | **False row.** The real row title is "Combine all inputs, run once (1 result)" and the row is gated on `bundleCount >= 2` | fidelity, readers |
| Settings, Strategy | Glossed progressive method, said Automatic is right for this chapter and the alternatives are out of scope, and described a ragged gap column as gaps scattered singly rather than blocked | Progressive method and the six codes were unglossed, and readers had no picture of a ragged column | readers |
| Settings, Sequence Type | Described the visible symptom of a protein alignment scored as DNA | Readers could not use an unseen symptom | readers |
| Settings, Direction Adjustment | Glossed reverse-complement in place | Unglossed term | readers |
| Settings, Symbol Policy | Said the setting matters mainly for protein alignments and is rare, and put selenocysteine after the plainer stop codons | Selenocysteine was unfamiliar and the relevance to a DNA run was unclear | readers |
| Settings, Threads | Gave `2` as a concrete small number | The blank default gave readers nothing to judge against | readers |
| Settings, Deterministic threading | Replaced "byte-identical result" with "exactly the same result" | Computing jargon | readers |
| Settings, MAFFT Parameters | Said most readers should leave it empty, and glossed gap-opening penalty | Readers could not check their own setting against an unglossed term | readers |
| Settings, viewport intro | Split the placement sentence in two, named the two sliders as Low support and High gap, and gave **View > Show Inspector** (Cmd-Option-I) | One sentence sorted several controls into two places without naming the sliders, and the Inspector was never located. Menu path confirmed at `MainMenu.swift:446-453` | readers |
| Settings, Low support | Rewrote the opening so the heading's meaning arrives in the first clause, and separated the on-screen slider from the command-line flag, saying plainly the slider governs the run just completed | The heading read as unparseable and two defaults left readers unsure which applied to them | readers |
| Settings, High gap | Split the flag sentence in two so the "no flag" statement stands alone before the related `--gap-policy` option is named | The single sentence denied a flag then named one | readers |
| Settings, Mask | Glossed `N` as the DNA code for any base and `X` as its protein equivalent | Readers did not know what the mask characters mean | readers |
| Settings, Reference | Said the consensus is computed by LGE and is not one of the five input records | Readers could not tell whether the consensus was a real organism's sequence | readers |
| Settings, Name gutter width | Glossed points as the macOS screen unit and said the handle stops on its own at each end | Readers could not judge 640 or 160 | readers |
| Settings, Export sheet, Sequences | Said which flag goes with which Destination choice instead of naming two flags for one control | Two flag names for one visible control | readers |
| Settings, Export sheet, Format | Rewritten to the reviewer's corrected wording. Removing gaps forces plain `fasta` and hides the row | **False row.** The picker renders only when `availableFormats.count > 1`, and with gaps removed the list is the single entry `["fasta"]` | fidelity |
| Settings, Export sheet, Scope | Replaced the bare letter n with a worked example using live counts of 3 and 5 | The letter n was unexplained and one reader looked for a literal n | readers |
| Reading the results, annotations | Glossed annotation as a labelled feature such as a gene, and said the chapter's plain FASTA fixture carries none | Readers did not know what an annotation is or whether their file had any, and the no-toggle sentence read as a warning | readers |
| Reading the results, the numbers | Showed the subtraction, 17,247 minus each input length, that produces the gap counts | Readers could not follow the arithmetic | readers |
| Reading the results, variable columns | Stated the denominator, said 29.3 is rounded to 29, and said plainly that a middle figure is the normal healthy case | Readers could not place 29 percent between the two stated extremes, or tell what it was measured against | readers |
| Reading the results, consensus | Gave 479 out of 17,247 as under 3 percent and a rough cutoff of a tenth for a high count | Readers could not tell whether 479 was low or high | readers |
| Pairwise identity | Said plainly that no window or Inspector row draws the matrix and that it comes only from `lungfish-cli msa distance`. Confirmed by grep, no `Pairwise` symbol exists anywhere in `Sources/LungfishApp` or `Sources/LungfishKit` | The single worst location failure. The fidelity review confirmed the Inspector hedge is true, so this adds the missing location rather than changing the fact | readers |
| Pairwise identity | Gave 0.926 once as 92.6 percent identical | Percent identity suggested a percentage while the figures were fractions | readers |
| Pairwise identity, Inspector paragraph | Rewrote the hedge to say what the Inspector does show, a live count of displayed and variable columns, rather than only what it may not show | The bare hedge left readers unsure the numbers were visible at all. The positive claim is the one the fidelity review verified at `MultipleSequenceAlignmentViewController.swift:3174-3176` | readers |
| Acting on a selection | Added how to select a column range by dragging across the residues, and Control-click for trackpad users. Drag behaviour confirmed at `MultipleSequenceAlignmentViewController.swift:3395-3408` | Row selection was explained but column selection never was, and a trackpad has no second button | readers |
| Acting on a selection | `.lungfishmsa` corrected to `.lungfishref` for **Extract Selection to New Bundle...** | **False row.** `createBundleFromSelectedSequences` requests `outputKind: "reference"` and suggests a `.lungfishref` name | fidelity |
| Acting on a selection, annotations | Split the enablement rule into its two conditions and said the selection must cover a stretch an annotation already occupies | Readers could not tell what gets an annotation into a selection | readers |
| Acting on a selection, clipboard cap | Added that 5 MB is roughly 300 rows at this genome length and that the five primate rows come to under 90 KB | Readers could not estimate their own alignment against the cap | readers |
| What good looks like, first check | Added **Operations > Show Operations Panel** (Cmd-Shift-P) at first mention and removed it from the later paragraph | The panel was named three paragraphs before its keystroke | readers |
| What good looks like, third check | Pointed at the viewport screenshot for the good strip and described the failure as no run of tall bars anywhere | **Unverifiable row** ("blocks rather than noise" was judgement with nothing behind it). Hedged to the shot the frontmatter already names, which is also the readers' shortest fix | fidelity, readers |
| On the command line, opening | Added a paragraph saying GUI-only readers may skip the section, with the one exception that the identity matrix lives only here | Nearly a third of the chapter with no statement of who it is for | readers |
| On the command line | `lungfish msa` and `lungfish align` corrected to `lungfish-cli msa` and `lungfish-cli align` | Two command names for one program. `lungfish-cli` is the CONSISTENCY spelling | readers, consistency |
| On the command line | Moved the dialog-versus-command default mismatch into a paragraph before the table and deleted the duplicate note after it | The mismatch arrived only after readers had already read the table | readers |
| On the command line, mask columns | Glossed `--parsimony-uninformative` as columns a tree builder cannot use and said parsimony is out of scope, and spelled out CDS as coding sequence | Neither term was known to any reader | readers |
| On the command line, p-distance | Added the worked case of a site mutating `A` to `G` and back to `A`, reading today as no change | Readers could not follow what a reverted change means for a count | readers |
| Throughout | Verified no em dashes, no semicolons, no in-sentence colons, no ai-tells-list word in any inflection, no `{{ fixtures_refs[] \| cite }}`, at most five bullets per list and two lists per H2, "Lungfish Genome Explorer" at first body mention and "LGE" after, and every Settings label spelled as `parameters.yaml` spells it | Style rules | style |
| Settings paragraphs | Reverted an interim "(Visible.)" and "(Advanced.)" marker on each of the eleven MAFFT paragraphs, folding the mapping into the section intro instead | The markers broke the fixed shape, which requires the paragraph to open with the bold label and its period | template |

## Deliberately left unchanged

The consensus-threshold sentence keeps both numbers, the 50 percent slider and
the 0.6 command-line default, as the fidelity review confirmed and asked. It is
reworded for the reader but not softened, since it is the only disclosure of a
real product inconsistency in the manual.

`GLOSSARY.md` was not touched. Residue, progressive method, points, and the
other terms readers stumbled on are glossed inline at first use, which is what
the campaign's glossary discipline asks for, and adding entries is not this
role's authority.

The registry defects the fidelity review found in `parameters.yaml` are left to
their owner. The chapter now carries the corrected Batch Output label, so it no
longer inherits the wrong one.

Two reader rows are left for the screenshot role rather than fixed in prose.
The request for a second image of a failed conservation strip needs a capture
that does not exist, and the chapter now points at the strip in the shot the
frontmatter already names.

## Status

brand_reviewed: false
lead_approved: false
