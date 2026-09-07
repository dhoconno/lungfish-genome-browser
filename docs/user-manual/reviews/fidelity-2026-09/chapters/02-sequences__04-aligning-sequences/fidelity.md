# Fidelity review: 02-sequences/04-aligning-sequences.md

Reviewed 2026-09-06 against the Swift source under `Sources/`, the CLI help
dumps under `reviews/fidelity-2026-09/cli-help/`, the tool lock manifest,
`docs/user-manual/parameters.yaml`, `GLOSSARY.md`, `CONSISTENCY.md`, and the
reality map at `reviews/fidelity-2026-09/ground-truth/02-sequences.md`.

This is the new chapter split out of `04-msa-and-trees.md`. The DRIFT Part A
entry for `02-sequences.md/04-msa-and-trees.md` describes the pre-split text.
Every false and changed row it listed on the alignment side has been fixed
here, and every item on its Missing list is now documented. Those are
re-verified against source below rather than trusted from the drift report.

Live checks ran the read-only `msa` subcommands against the author's scratch
bundle at
`.../scratchpad/primate-msa/proj.lungfish/Analyses/Multiple Sequence Alignments/primate-mito.lungfishmsa`,
so every worked number in the chapter was recomputed rather than copied.

## Worked numbers, recomputed

Parsing `alignment/primary.aligned.fasta` and `alignment/input.unaligned.fasta`
out of the bundle directly:

```
rows: 5
aligned length (all rows): 17247
input lengths:  Human 16569  Chimp 16554  Gorilla 16412
                RhesusMacaque 16564  CynomolgusMacaque 16575
gaps per row:   Human 678  Chimp 693  Gorilla 835
                RhesusMacaque 683  CynomolgusMacaque 672
variable columns (>1 distinct non-gap residue): 5053  (29.3 percent)
```

Every figure in the chapter is exact. 5 rows, 17,247 columns, longest input
16,575 (cynomolgus) carrying 672 gaps, shortest 16,412 (gorilla) carrying 835,
and 5,053 variable columns at 29 percent. The variable-column definition the
chapter gives matches the code, `variable: counts.count > 1` over non-gap
residues at `MultipleSequenceAlignmentViewController.swift:2221`.

The consensus:

```
$ lungfish-cli msa consensus <bundle> --output cons-default.fasta
  length 17247, N 479, gaps 0
```

The chapter's "17,247 characters long with 479 of them masked as `N`" is exact
at the shipped default. Worth recording for the author, because it is not
obvious: the default `--gap-policy omit` still writes 17,247 characters. It
omits gap *characters* from columns that would be called gaps, not columns from
the alignment. Passing `--gap-policy include` gives the same 17,247 with 723
gap characters and 579 N.

The identity matrix, from `msa distance` at its default `--model identity`:

```
                Human   Chimp   Gorilla  Rhesus  Cynomolgus
Human           1.000   0.9135  0.8945   0.7883  0.7898
Chimp           0.9135  1.000   0.8937   0.7955  0.7955
Gorilla         0.8945  0.8937  1.000    0.7943  0.7937
Rhesus          0.7883  0.7955  0.7943   1.000   0.9260
Cynomolgus      0.7898  0.7955  0.7937   0.9260  1.000
```

Macaque-macaque 0.926 is the highest off-diagonal pair, human-chimp is 0.913,
and human against the two macaques is 0.788 and 0.790, which the chapter rounds
to "about 0.789". All three claims true, and the biological ordering the
chapter rests its "what good looks like" section on is real.

## The consensus threshold mismatch the author raised

**Verdict: true as written, and worth keeping.** The viewport's Low support
slider defaults to 50 (`MSAAlignmentNumberingMode.swift:86`,
`lowSupportThresholdPercent: Int = 50`, confirmed as a 0 to 100 step-5 slider at
`ReadStyleSection.swift:1777-1781`). `msa consensus --threshold` defaults to 0.6
(`msa.txt:258-259`). The two really do disagree, and the chapter is the only
place in the manual that says so. The sentence "On the command line this is
`msa consensus --threshold`, which defaults to 0.6 rather than 0.5" is accurate
and is the right disclosure.

Two caveats for the author, neither a correction to this chapter. First, the
GUI slider and the CLI flag are not the same control: the slider re-renders the
displayed consensus row and never touches disk, while the flag writes a file.
The chapter already says the viewport settings "never change the bundle on
disk", so it does not mislead. Second, this is a genuine product inconsistency
rather than a documentation defect, and it belongs in a defect note to the
engineering owner, not in a chapter edit.

## Front matter

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| `parameters_refs: [msa.mafft, msa.view, msa.export, import.msa]` | true | All four ids exist in `parameters.yaml` at lines 5335, 5450, 5544, 1587. Every setting in all four entries has a Settings paragraph in the chapter | |
| `shots:` lists `mafft-dialog`, `alignment-viewport-primate-mito`, `export-alignment-sheet`, each with a caption | true | Body carries exactly three markers, `<!-- SHOT: mafft-dialog -->` (line 74), `<!-- SHOT: alignment-viewport-primate-mito -->` (line 150), `<!-- SHOT: export-alignment-sheet -->` (line 180). Ids and set match one to one, all three captioned | |
| `glossary_refs:` 18 anchors | true | All 18 resolve in `GLOSSARY.md` (checked each of msa, mafft, alignment-column, gap, conservation, consensus-sequence, homologous, fasta, accession, mitochondrial-genome, p-distance, percent-identity, plugin-pack, provenance, bundle, sidebar, inspector, operations-panel) | |
| `illustrations: msa-column-homology` | true | `assets/illustrations-imagegen/02-sequences/04-msa-and-trees/msa-column-homology.png` exists and is the path the body embeds | |
| Nav entry points at the new file | true | `build/mkdocs.yml:78`, `- Aligning Sequences: chapters/02-sequences/04-aligning-sequences.md` | |
| `entry_points` includes `Tools > Multiple Sequence Alignment > MAFFT...` | true | `ToolsMenuModel.swift:69` returns "Multiple Sequence Alignment" for `.alignment`; `FASTQOperationDialogState.swift:1983` titles the item "MAFFT"; `:2062-2063` puts `.mafft` in `.alignment` | |
| `fixtures_refs: [primate-mito]` | true | `docs/user-manual/fixtures/primate-mito/README.md` exists and its five lengths match the bundle | |
| `tools: [mafft]` | true | `msa describe msa.alignment.mafft` reports `Plugin packs: multiple-sequence-alignment`, single tool | |

## Body

### Procedure and dialog

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Choose **Tools > Multiple Sequence Alignment > MAFFT...**" | true | `ToolsMenuModel.swift:69`, `FASTQOperationDialogState.swift:1983`, `:2062-2063` | |
| "Its window title reads FASTQ/FASTA Operations, which is the title of the dialog rather than a menu you can find." | true | `FASTQOperationDialogState.swift:1251` returns the literal "FASTQ/FASTA Operations". Matches CONSISTENCY, which calls it the dialog title and never a menu | |
| Step 3, "Check the **Sequences to align** picker at the top of the pane." then "Set it to All sequences (5)." | **false** | `MSASequenceScopePicker.isVisible` is `allCount > 0 && selectedCount > 0 && selectedCount < allCount` (`MSASequenceScopePicker.swift:33-35`). Step 1 tells the reader to select all five or select none. Selecting all five gives `selectedCount == allCount`, selecting none gives `selectedCount == 0`. **In both branches the picker is replaced by the summary line** and there is no radio to set. The summary reads "Aligning the 5 sequences you selected." or "Aligning all 5 sequences." (`:66-71`) | "Look at the top of the pane. Because you are aligning the whole file, there is no scope choice to make, so a single line states what will run, either Aligning all 5 sequences. or Aligning the 5 sequences you selected. The **Sequences to align** radio group appears in its place only when you select some but not all of a file's sequences, and Settings below describes it." |
| Step 3, "It offers All sequences (5) and Selected sequences (n), with the counts filled in" | true | `rowStates` builds "All sequences (\(allCount))" and "Selected sequences (\(selectedCount))" (`MSASequenceScopePicker.swift:50-63`) | |
| Step 3, "Where there is no choice to make, it replaces itself with a single line stating what it will align." | true | `MSASequenceScopePicker.swift:105-109`, the else branch renders `summaryText` | |
| Step 3, "it defaults to your selection when you reached the dialog by selecting sequences" | **false** | The stored default is `.all` unconditionally (`FASTQOperationDialogState.swift:292`, `self.mafftSequenceScope = .all`). Nothing sets it to `.selected` on entry. The picker only appears at all when a partial selection exists, and it still opens on All sequences | "and it opens on All sequences whichever way you reached the dialog" |
| Step 4, "Leave **Batch Output** on Combine into one run." | **false** | Two defects. (1) `MultiBundleRunModePicker.isVisible` requires `bundleCount >= 2` (`MultiBundleRunModePicker.swift:40-42`) and the procedure aligns one file, so the row is not on screen. (2) The row's title is "Combine all inputs, run once (1 result)" (`:76-83`), never "Combine into one run" | Delete the step. The row does not appear for a single input file. Its Settings paragraph should carry the real label and say when it appears |
| Step 4, "this row is locked and states the reason" | true, when visible | `mafftMultiBundleRunPolicy` is `allowedModes: [.combined]` with `lockReason: "Alignment requires all sequences in one run"` (`FASTQOperationToolPanes.swift:289-293`), and a disabled row shows the lock reason as its caption (`MultiBundleRunModePicker.swift:64-74`) | |
| Step 5, "Leave **Strategy** on **Automatic** and click Run." | true | Default `.auto` (`FASTQOperationDialogState.swift:283`), display name "Automatic" (`FASTQOperationToolPanes.swift:1004`) | |
| "MAFFT is the only aligner in LGE, so there is no aligner to pick." | true | `align.txt:11` lists `mafft (default)` as the sole subcommand; `FASTQOperationToolPanes.swift:606` has only the `.mafft` case | |
| "The new bundle appears in the sidebar under `Analyses/Multiple Sequence Alignments/`." | true | The scratch bundle sits at `proj.lungfish/Analyses/Multiple Sequence Alignments/primate-mito.lungfishmsa`. Matches CONSISTENCY, which names this the one exception to `Analyses/<tool>-<timestamp>/` | |
| "Right-clicking a FASTA selection and choosing **Align with MAFFT...** opens the same dialog with that selection already scoped." | true | `parameters.yaml:5339` lists that entry point; `FASTASequenceActionMenuBuilder` supplies the item via `onAlignWithMAFFT` | |
| "The alignment viewport does not offer that item, because realigning sequences that already carry gaps is a different operation" | true | `MultipleSequenceAlignmentViewController.swift:1629-1631` passes `onAlignWithMAFFT: nil` with the comment "realigning an alignment is a different operation from aligning sequences" | |
| "LGE warns you when a run's input already contains gaps." | true | `MAFFTAlignmentPipeline.swift:360` appends "Input sequences already contain gaps. Realigning an existing alignment produces unreliable results; remove gaps before aligning." | |
| "The pack ships MAFFT 7.526." | true | `third-party-tools-lock.json` packTools mafft entry, `"version": "7.526"`, `packageSpec` `conda-forge::mafft=7.526=h99b78c6_0` | |
| "MAFFT arrives in the `multiple-sequence-alignment` plugin pack" | true | Same entry, `"packID": "multiple-sequence-alignment"`. `msa describe msa.alignment.mafft` prints `Plugin packs: multiple-sequence-alignment` | |
| "Install it from **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:773-775`, title "Plugin Manager…" with the Cmd-Shift-B comment. Matches CONSISTENCY | |
| "Docker is not involved" | true | No docker or container reference anywhere in `MAFFTAlignmentPipeline.swift` | |
| "on the five primate genomes it chooses the fast progressive method" (Strategy paragraph) and "FFT-NS-2" implied | true | The bundle's `.lungfish-provenance.json` captures MAFFT's own report, "Strategy:\n FFT-NS-2 (Fast but rough)\n Progressive method (guide trees were built 2 times.)" | |
| "The alignment itself takes under a minute on this input on a current Mac." | unverifiable | A wall-clock claim. Nothing in source or provenance records a runtime. The prior review marked the same claim unverifiable (ground-truth row 21). Would be settled by timing a run and recording it in the fixture README | |
| Import section, "Choose **File > Import Center...** (Cmd-Shift-I), open the Alignments tab, and drop the file on the Multiple Sequence Alignments card." | true | `ImportCenterViewModel.swift:176` names the tab "Alignments", `:333` names the card "Multiple Sequence Alignments", `tab: .alignments` at `:337` | |
| "It reads aligned FASTA, Clustal, PHYLIP, NEXUS, Stockholm, and the a2m and a3m profile formats." | true | `ImportCenterViewModel.swift:334`, "Import aligned FASTA, CLUSTAL, PHYLIP, NEXUS, Stockholm, A2M, or A3M files as native .lungfishmsa bundles" | |
| "The card has no controls beyond a file panel, format detection is automatic, and each accepted file becomes one `.lungfishmsa` bundle." | true | `importKind: .openPanel` with a type list and no configuration sheet (`:338-352`); `parameters.yaml` `import.msa` has `settings: []` and says the same | |

### Settings, MAFFT pane

The chapter says "eleven settings. Five sit in plain view and six sit inside a
collapsed Advanced Options group." The visible pane renders scope picker, run
mode picker, Strategy, Sequence Type, Output Order (`FASTQOperationToolPanes.swift:607-639`),
which is five. The `DisclosureGroup("Advanced Options", isExpanded: $state.mafftAdvancedOptionsExpanded)`
holds Direction Adjustment, Symbol Policy, Threads, Deterministic threading, the
FASTQ toggle, and MAFFT Parameters (`:909-932`), which is six, and it opens
collapsed (`FASTQOperationDialogState.swift:282`, `= false`). The count and the
split are **true**. The eleven match `msa.mafft`'s eleven Settings entries one
for one.

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| **Sequences to align**, "The default is All sequences" | true | `FASTQOperationDialogState.swift:292`, `.all` | |
| **Sequences to align**, "On the command line this is `--sequence`, which is repeatable and accepts a full FASTA header, a bare accession, or the label shown in the alignment." | true | `align.txt:47-49` verbatim, "Align only this sequence. Repeatable. Accepts a full FASTA header, an accession, or the label shown in the alignment." | |
| **Batch Output**, "The default is Combine into one run" | **false** | The row's real title is "Combine all inputs, run once (1 result)" (`MultiBundleRunModePicker.swift:76-83`). `parameters.yaml:5364` carries the same wrong label, so the registry needs the same fix | "The default and only choice is Combine all inputs, run once (1 result), and the row is locked with the reason \"Alignment requires all sequences in one run\". The row appears only when you feed the dialog two or more files, because with one file there is nothing to combine." |
| **Batch Output**, lock reason quoted as "Alignment requires all sequences in one run" | true | `FASTQOperationToolPanes.swift:292`, verbatim | |
| **Batch Output**, "This setting has no command-line flag." | true | No batch or run-mode flag in `align.txt`. `parameters.yaml` gives `cli_flag: null` | |
| **Strategy**, "On the command line this is `--strategy`, which takes `auto`, `linsi`, `ginsi`, `einsi`, `fftns2`, or `parttree`." | true | `align.txt:29-30`, "auto, linsi, ginsi, einsi, fftns2, parttree (default: auto)" | |
| **Sequence Type**, "The default is Auto" and `--sequence-type` | true | `FASTQOperationDialogState.swift:285` `.auto`; `align.txt:33-35` "auto, nucleotide, protein (default: auto)" | |
| **Output Order**, "The default is Input Order" and `--output-order` | true | `FASTQOperationDialogState.swift:284` `.input`; display name "Input Order" (`FASTQOperationToolPanes.swift:1017`); `align.txt:31-32` "input or aligned (default: input)" | |
| **Direction Adjustment**, "The default is Off" and "`--adjust-direction`, taking `off`, `fast`, or `accurate`" | true | `FASTQOperationDialogState.swift:286` `.off`; `align.txt:36-38` | |
| **Symbol Policy**, "The default is Strict Alphabet" and `--symbols` | true | `FASTQOperationDialogState.swift:287` `.strict`; label at `FASTQOperationToolPanes.swift:1064`; `align.txt:39` "strict or any (default: strict)" | |
| **Threads**, "The default is blank" and `--threads` | true | `FASTQOperationDialogState.swift:289` `= nil`; `align.txt:65` "-t, --threads" | |
| **Deterministic threading**, "The default is on" and "clearing the box sends `--allow-nondeterministic-threads`" | true | `FASTQOperationDialogState.swift:288` `= true`; `align.txt:40-42` is a bare flag, so it is sent only when the box is cleared | |
| **Treat FASTQ records as assembled or consensus sequences**, "The default is off" and `--allow-fastq-assembly-inputs` | true | `FASTQOperationDialogState.swift:291` `= false`; label verbatim at `FASTQOperationToolPanes.swift:928`; `align.txt:43-46` | |
| **MAFFT Parameters**, "The default is empty, and the dialog checks that whatever you type parses as command-line arguments before it will run." and `--extra-mafft-options` | true | `FASTQOperationDialogState.swift:290` `= ""`; label at `FASTQOperationToolPanes.swift:930`; `align.txt:50-52` | |

### Settings, viewport display controls

The chapter says "These nine settings". `msa.view` lists nine, and the chapter
carries nine paragraphs. **True.** The placement sentence, "Numbering, the two
consensus sliders, Mask, Reference, and Display live in the Inspector's View
tab. All Sites, the colour scheme, and the name gutter live on the viewport
itself", matches `ReadStyleSection.swift:1746-1836` for the first group and
`MultipleSequenceAlignmentViewController.swift:374-399` for the second.

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| **All Sites / Variable Sites**, "The default is All Sites" | true | `NSSegmentedControl(labels: ["All Sites", "Variable Sites"])` (`MultipleSequenceAlignmentViewController.swift:379-384`), segment 0 selected, and `performSearch` restores segment 0 as the all-sites mode (`:1032`) | |
| **Nucleotide / Conservation**, "The default is Nucleotide" | true | `colorSchemeControl` built from `MultipleSequenceAlignmentColorScheme.allCases` (`:395-399`) with `.nucleotide` first (`:82-92`) | |
| **Numbering**, "The default is Alignment + Source" and "The other choices are Alignment Columns, Source Coordinates, and Hidden." | true | `MSAAlignmentNumberingMode.swift:7-25` gives the four cases and the four display titles verbatim; `ReadStyleSection.swift:127` defaults `= .both` | |
| **Numbering**, "alignment columns counting gapped positions from the left edge and source coordinates counting ungapped positions along each original sequence" | true | `MSAAlignmentNumberingMode.swift:31`, "Show alignment column ticks and per-row source coordinate ranges" | |
| **Low support (of non-gap residues)**, "The default is 50 percent" | true | `MSAAlignmentNumberingMode.swift:86`, `lowSupportThresholdPercent: Int = 50`; slider `in: 0...100, step: 5` (`ReadStyleSection.swift:1777-1781`); label verbatim at `:1772` | |
| **Low support**, "On the command line this is `msa consensus --threshold`, which defaults to 0.6 rather than 0.5." | true | `msa.txt:258-259`, "(default: 0.6)". See the dedicated section above for the verdict on the mismatch | |
| **High gap**, "The default is 50 percent" and "This setting has no command-line flag, though `msa consensus --gap-policy` decides whether gap columns are written out at all." | true | `MSAAlignmentNumberingMode.swift:87` `= 50`; label at `ReadStyleSection.swift:1787`; `msa.txt:260-261` "omit or include (default: omit)" | |
| **Mask**, "The default is Auto, which writes `X` for protein alignments and `N` for everything else" | true | `MSAConsensusMaskSymbolMode.symbol(alphabet:)` (`MSAAlignmentNumberingMode.swift:72-82`) returns X when the alphabet contains protein or amino, else N; default `.automatic` (`:88`) | |
| **Mask**, "so the primate consensus masks with `N`" | true | The measured consensus holds 479 N and 0 X | |
| **Reference**, "The default is Consensus" and "the right-click items **Use Consensus** and **Use as Reference** set the same value" | true | `ReadStyleSection.swift:1816-1818` tags `Text("Consensus")` as `Optional<String>.none`, the default; `MultipleSequenceAlignmentViewController.swift:1645-1651` adds both menu items, and `useConsensusAsReference` sets `referenceRowID = nil` (`:1694`) | |
| **Display**, "The default is Letters" and "Dots to Reference stays disabled until a Reference row is chosen." | true | `MSAResidueIdentityDisplayMode` default `.letters` (`MultipleSequenceAlignmentViewController.swift:373`); `ReadStyleSection.swift:1829` disables `.dotsToReference` when `selectedMSAReferenceRowID == nil` | |
| **Name gutter width**, "Widen it up to 640 points ... narrow it toward the 160-point floor" and "remembered for the next session" | true | `minimumGutterWidth: CGFloat = 160`, `maximumGutterWidth: CGFloat = 640` (`MultipleSequenceAlignmentViewController.swift:408-409`), clamped at `:923` and persisted to `UserDefaults` key `msaRowGutterWidth` at `:928` | |

### Settings, Export Alignment sheet

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| **Destination**, "The default is Save to File..." | true | `MSAAlignmentExportModel.destination = .file` (`MSAAlignmentExportSheet.swift:163`); labels "Save as Bundle", "Save to File…", "Copy to Clipboard" (`:18-22`) | |
| **Destination**, "a bundle export runs `msa extract` underneath and a file or clipboard export runs `msa export`" | true | `cliArguments(for:)` routes `.bundle` to `buildExtractArguments` and `.file`/`.clipboard` to `buildExportArguments` (`MSAAlignmentExportSheet.swift:113-135`) | |
| **Sequences**, "The default is Aligned FASTA (keep gaps)" and the two labels | true | `layout: MSAExportLayout = .aligned` (`:164`); labels verbatim at `:41-45` | |
| **Sequences**, "On the command line this is `--output-format` for a file export and `--output-kind` for a bundle export." | true | Same routing as above; `bundleOutputKind` feeds `outputKind:` (`:121`), `configuration.format` feeds `outputFormat:` (`:131`) | |
| **Format**, "The default is `aligned-fasta`" | true | `format: String = "aligned-fasta"` (`:165`) | |
| **Format**, "The other choices are `phylip`, `nexus`, `clustal`, `stockholm`, `a2m`, and `a3m`, plus plain `fasta` only when gaps are removed." | **false** on the last clause | `alignedFileFormats` is exactly `["aligned-fasta", "phylip", "nexus", "clustal", "stockholm", "a2m", "a3m"]` (`:85`), so the six named alternatives are right. But the Format picker renders only when `destination == .file && model.availableFormats.count > 1` (`:262`), and with gaps removed `availableFormats` is the single-element `["fasta"]` (`:185-190`). The row **disappears** rather than offering plain fasta | "The other choices are `phylip`, `nexus`, `clustal`, `stockholm`, `a2m`, and `a3m`. Removing the gaps forces the format to plain `fasta` and hides this row, because there is then only one format to pick." |
| **Format**, "the row appears only for that destination because bundle and clipboard exports are always FASTA" | true | `availableFormats` returns a single FASTA entry for any non-file destination (`:185-188`), and the row is gated on `destination == .file` (`:262`) | |
| **Scope**, "The default is Selected subalignment (n rows) when rows are selected and Entire alignment (n) otherwise" and "the row appears only when a selection exists" | true | `self.scope = hasSelection ? .selectedRows : .entireAlignment` (`:172`); row gated on `model.hasSelection` (`:275`); labels "Entire alignment (\(totalRowCount))" and "Selected subalignment (\(selectedRowCount) rows)" (`:277-278`) | |
| **Scope**, "On the command line this is `--rows` and `--columns`." | true | `cliArguments` passes `scopedRows`/`scopedColumns` only for `.selectedRows` (`:110-111`); `msa.txt:226-227` and `:290-291` | |
| **Bundle name**, "The default is the current alignment name, and the Create Bundle button stays disabled until the field holds something." | true | `name` is seeded from the caller and the primary button is disabled on an empty trimmed name (`:305`); `primaryButtonTitle` for `.bundle` is "Create Bundle" (`:27`) | |
| **Bundle name**, "the row appears only for that destination" and `--name` | true | Gated on `model.destination == .bundle` (`:281`); `msa.txt:292` | |
| "The Multiple Sequence Alignments import card has no settings at all. Its three command-line options are covered in the last section." | true | `parameters.yaml` `import.msa` has `settings: []` and exactly three `cli_only` flags, and the last section names `--source-format`, `--name`, `--output` | |

### Reading the results

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "On the left, a resizable name gutter lists every sequence in alignment order. Click a name to select that row, Command-click to add rows, and Shift-click for a range." | true | `rowGutterView` is an `MSAAlignmentRowGutterView` (`:389`) with a resize handle; `selectWholeRows(at:modifiers:)` handles shift ranges, command union, and plain click (`:1066-1085`) | |
| "Across the top, a column header carries the numbering, and below it a conservation overview strip draws a bar at each column whose height is the fraction of non-gap rows sharing that column's most common residue." | true | `columnHeaderView` (`:392`) and `overviewSignalView` labelled "Alignment conservation overview" (`:393`, `:775`); arithmetic at `:2220`, `Double(maxCount) / Double(nonGapTotal)` | |
| "Above the sequence rows sits the pinned comparison row, which holds the current Reference and stays in place while the rows below it scroll." | true | `comparisonLabelView` and `comparisonHeaderView` (`:390-391`), outside the scrolling matrix, labelled from `comparisonTitle` (`:965-966`) | |
| "They are coloured by the `Nucleotide` scheme by default, which you can swap for `Conservation`." | true | `:82-92`, `:395-399` | |
| "Annotations carried by the source sequences draw on the alignment tracks. There is no toggle to switch them off." | true | The generic annotation drawer is pinned to `heightAnchor.constraint(equalToConstant: 0)` (`:604`) and no annotations toggle exists; source annotation tracks still render (`:1421-1433`, `:3763`) | |
| "A `Find sequence or column` search field matches a sequence name, and typing a bare column number jumps to that column instead, switching back to All Sites first if the column is one the Variable Sites view is hiding." | true | Placeholder verbatim at `:625`; `performSearch` parses `Int(query)`, and when `!displayedColumns.contains(column)` it sets `siteModeControl.selectedSegment = 0` and reapplies before selecting (`:1028-1036`), falling through to a case-insensitive name match (`:1038-1041`) | |
| "**Previous Variable** and **Next Variable** step between disagreeing columns without changing that setting." | true | Button titles verbatim (`:385-386`); `moveVariableSelection` only selects, never touches `siteModeControl` (`:1058-1064`) | |
| "Both buttons grey out when the alignment has no variable column at all." | true | `updateVariableSiteButtonAvailability` sets both `isEnabled` from `columnSummaries.contains(where: \.variable)` (`:1052-1056`), and the doc comment explains the change | |
| "Icon buttons zoom in, zoom out, and fit the columns to the window." | true | `zoomOutButton`, `zoomInButton`, `fitColumnsButton` (`:376-378`), configured via `configureIconButton` with SF Symbols | |
| "The primate alignment is 5 rows and 17,247 columns." | true | Measured from the bundle | |
| "The longest input sequence is the cynomolgus macaque at 16,575 bases, so alignment added 672 gap columns to the longest row and 835 to the shortest, the gorilla at 16,412 bases." | true | Measured. Cynomolgus 16,575 with 672 gaps, gorilla 16,412 with 835. Fixture README agrees on both lengths | |
| "Of those 17,247 columns, 5,053 are variable ... That is 29 percent of the alignment" | true | Measured, 5,053 and 29.3 percent | |
| "The consensus built from this alignment is 17,247 characters long with 479 of them masked as `N`." | true | `msa consensus` at defaults gives exactly 17,247 and 479 N | |
| "On this alignment the two macaques come out at 0.926, the highest pair in the matrix. Human and chimpanzee come out at 0.913. Human against either macaque falls to about 0.789." | true | `msa distance` output above. 0.926000, 0.913460, 0.788330 and 0.789758 | |
| "The Inspector reports the alignment's own summary rows for the selected bundle, and it changes with what you have selected, so read what is there rather than looking for a row this manual promised." | true | A deliberate hedge rather than a claim about a named row. The controller does compute a live summary string, "\(displayedColumns.count) columns, \(variableCount) variable, \(gapBearingCount) gap-bearing" (`:3174-3176`), which does change with the displayed column set | |
| "**Copy Subalignment** puts the selected block on the clipboard as FASTA." | true | `:1636` renames the built menu's "Copy FASTA" item to "Copy Subalignment"; handler is `copySelectedFASTAToPasteboard` (`:1626`) | |
| "**Extract Selection to New Bundle...** writes the block as a fresh `.lungfishmsa` bundle with its own provenance" | **false** on the extension | The menu title is right (`:1627`), but `createBundleFromSelectedSequences` requests `outputKind: "reference"` with a suggested name of `"\(selectedFASTAName()).lungfishref"` (`:1836-1838`). The new bundle is a `.lungfishref` reference bundle, not a `.lungfishmsa`. The export sheet agrees, its unaligned bundle caption reads "Creates a .lungfishref reference bundle holding the sequences with gaps removed" (`:62`) | "**Extract Selection to New Bundle...** writes the block as a fresh `.lungfishref` reference bundle with its own provenance" |
| "**Export Selected Residues...** writes it to a file." | true | Menu title passed as `exportMenuTitle` (`:1633`), handler `exportSelectedSequences` (`:1625`) | |
| "**Export Alignment...** opens the export sheet described in Settings." | true | `:1637-1644`, item title "Export Alignment…", enabled when `bundleURL != nil` | |
| "**Use as Reference** makes the row you clicked the pinned comparison row, and **Use Consensus** puts the consensus back." | true | `:1645-1651`; `useSelectedRowAsReference` sets `referenceRowID` from the clicked row (`:1699-1701`), `useConsensusAsReference` clears it (`:1694`) | |
| "**Add Annotation from Selection...** records a named feature over the selected columns of one row, and **Apply Annotation to Selected Rows** copies an existing annotation onto the other rows you have selected." | true | Titles verbatim at `:1664-1676`; the CLI mirrors are `msa annotate add --row --columns` (`msa.txt:96-105`) and `msa annotate project --target-rows` (`:184-194`) | |
| "It enables only when more than one row is selected and an annotation is part of the selection." | true | `applyAnnotationItem.isEnabled = selectedRowIndices.count > 1 && !selectedAnnotations().isEmpty` (`:1677`) | |
| "**Build Tree with IQ-TREE...** ... stays greyed out until at least two rows are selected" | true | `treeItem.isEnabled = bundleURL != nil && selectedRowIndices.count >= 2` (`:1660`) | |
| "Copy to Clipboard on the export sheet disables itself with an explanation when the alignment text would exceed 5 MB" | true | `clipboardByteCap = 5 * 1024 * 1024` (`:89`), the radio is disabled when unavailable and carries `clipboardUnavailableMessage` as help text (`:245-256`) | |
| "Confirm the conservation overview strip shows blocks rather than noise." | unverifiable | A visual heuristic about what a good strip looks like. The strip and its arithmetic are real, but "blocks rather than noise" is judgement with no source or measurement behind it. Would be settled by a screenshot of the primate strip in the shot named in the front matter | |

### On the command line

| Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "`align mafft` takes `--project` for the project directory that receives the bundle" and the code comment "--project is required" | true | `align.txt:19` shows `--project <project>` outside the optional brackets, and `:25-26` describes it as the directory that will receive the bundle | |
| "`--output` names an explicit `.lungfishmsa` path instead of letting the project choose one, and `--extra-args` passes further arguments to MAFFT verbatim" | true | `align.txt:27` and `:53-54` | |
| "`lungfish msa` is a different command from `lungfish align`. It transforms and inspects an alignment that already exists, and it cannot build one from unaligned FASTA." | true | `msa.txt:2`, "Inspect and run multiple sequence alignment actions", and every subcommand takes an existing `<bundle-path>`. No subcommand accepts unaligned FASTA | |
| "`msa actions` lists every registered alignment action with its category and whether it is implemented" | true | Ran it. Output is "Multiple Sequence Alignment Actions (35)" with rows shaped `- msa.navigation.overview [P0, navigation, implemented]: Alignment Overview` | |
| "`msa describe <action-id>` prints one action's detail, taking an identifier such as `msa.alignment.mafft`" | true | `msa.txt:58` gives that exact example. Ran `msa describe msa.alignment.mafft`, which printed category, priority, status, surfaces, CLI form, and plugin packs | |
| "each takes `--output` for the destination and `--force` to overwrite one that already exists" | true | `--output` and `--force` appear on export, consensus, extract, mask columns, trim columns, and distance (`msa.txt:225-228`, `:255-262`, `:289-293`, `:348-351`, `:395-397`, `:424-427`) | |
| Table row, `msa export`, "`--output-format fasta\|aligned-fasta\|phylip\|nexus\|clustal\|stockholm\|a2m\|a3m` (default `fasta`), `--rows`, `--columns`" | true | `msa.txt:222-227` | |
| "Note that `msa export` defaults to plain `fasta`, which strips the gaps, so an aligned export needs `--output-format aligned-fasta` written out." | true | Verified by running both. Default export reported `Columns: 16569` (the ungapped human length), `--output-format aligned-fasta` reported `Rows: 5, Columns: 17247` | |
| Table row, `msa consensus`, "`--output-kind fasta\|reference`, `--threshold` (default 0.6), `--gap-policy omit\|include`, `--rows`, `--name`" | true | `msa.txt:253-261`, `:256`, `:257` | |
| Table row, `msa distance`, "`--model identity\|p-distance` (default `identity`), `--rows`, `--columns`" | true | `msa.txt:422-426` | |
| Table row, `msa extract`, "`--output-kind fasta\|msa`, `--rows`, `--columns`, `--name`" | true | `msa.txt:287-292` | |
| Table row, `msa annotate`, "the `add`, `edit`, `delete`, and `project` verbs, with `--row`, `--columns`, `--type`, `--strand`" | true | `msa.txt:86-89` for the verbs, `:102-106` for the options | |
| "`msa mask columns` ... `--ranges` ... `--gap-threshold` and `--conservation-below` ... `--parsimony-uninformative` ... `--annotation` ... `--codon-position 1|2|3` ... and `--reason`" | true | All six confirmed at `msa.txt:333-350`. This is the DRIFT row 34 gap, now closed | |
| "`msa trim columns` removes columns outright and takes `--gap-only` and `--gap-threshold`." | true | `msa.txt:391-394` | |
| "Both are spelled with the `columns` verb, hence `lungfish-cli msa mask columns`." | true | `msa.txt:324` and `:382` | |
| "`import msa` takes `--project` ... `--source-format` to force a file ... to be read as `aligned-fasta`, `clustal`, `phylip`, `nexus`, `stockholm`, or `a2m-a3m`, `--name` ... and `--output`" | true | `import.txt`, `import msa` block. Options and the six source formats verbatim | |
| Code block, `lungfish-cli msa distance <bundle> --output primate-mito-identity.tsv` | true | Ran the same shape against the scratch bundle and it wrote the matrix quoted above | |
| Code block, `lungfish-cli msa export <bundle> --output-format phylip --output primate-mito.phy` | true | `phylip` is an accepted `--output-format` value (`msa.txt:223`) | |
| Code block path `.../Analyses/"Multiple Sequence Alignments"/primate-mito.lungfishmsa` | true | The scratch bundle sits at exactly that path | |
| Code block, `--sequence Human_NC_012920.1` and the two macaque labels | true | Those are the literal FASTA labels in the fixture, confirmed against `input.unaligned.fasta` in the bundle and the fixture README table | |
| "The p-distance model that `msa distance` offers alongside identity is the proportion of positions at which two aligned sequences differ, with no correction" | true | `msa.txt:422-423` offers both models. The definition is standard and matches the `p-distance` glossary entry | |

## Registry defects found while reviewing

Not chapter corrections, but the chapter's Settings paragraphs copy their labels
from `parameters.yaml`, so two registry rows carry the error into the chapter.

- `parameters.yaml:5364` gives Batch Output's default as "Combine into one run"
  and `allowed` as "Combine into one run". The real row title is "Combine all
  inputs, run once (1 result)" (`MultiBundleRunModePicker.swift:76-83`). The
  entry should also record that the row appears only at two or more inputs.
- `parameters.yaml` `msa.mafft` notes say the scope picker collapses to a
  summary "when nothing is selected or the selection is the whole file", which
  is right, but the chapter's procedure then instructs the reader to set a
  control that those very conditions hide. The registry is correct and the
  chapter misread it.
- `msa.view` notes place the tree output in a "Phylogenetic Trees folder"
  (`parameters.yaml`, `tree.iqtree` Output Name effect). CONSISTENCY settles
  trees under `Analyses/Multiple Sequence Alignments/`. Out of scope for this
  chapter, which never makes the claim, but the next chapter will hit it.

## Counts

8 true, 0 false, 0 unverifiable in the front matter tables. 99 true, 6 false, 2
unverifiable in the body tables. Three further claims are adjudicated in prose
rather than in a table and all three are true: the consensus threshold mismatch
the author raised, the MAFFT pane's "eleven settings ... five in plain view and
six inside a collapsed Advanced Options group", and the viewport's "nine
settings" with their split between the Inspector View tab and the viewport
itself.

**Totals: 110 true, 6 false, 2 unverifiable.**
