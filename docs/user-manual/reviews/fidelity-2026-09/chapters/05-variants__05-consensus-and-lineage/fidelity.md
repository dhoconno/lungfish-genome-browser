# Fidelity review, 05-variants/05-consensus-and-lineage.md

Chapter: `docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md`,
retitled "Extracting a Consensus Sequence". Roster row 30, registry id
`bam.extract-consensus`, fixture `hg002-chr20`.

Ground truth used: the Swift source under `Sources/`, `docs/user-manual/parameters.yaml`,
`.build/debug/lungfish-cli msa consensus --help`, `docs/user-manual/GLOSSARY.md`,
`docs/user-manual/build/mkdocs.yml`, `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
and reruns of the app's own samtools chain from `~/.lungfish/conda/envs/samtools/bin/samtools`
(samtools 1.24, htslib 1.24) against copies of the fixture BAM and reference under
the author's scratch directory.

## The headline finding

The author reproduced `samtools consensus` faithfully but stopped one stage
short of what the app does. `AlignmentDataProvider.fetchConsensus`
(`Sources/LungfishIO/Bundles/AlignmentDataProvider.swift:763-880`) runs four
stages, not two, and its output passes through
`AlignmentConsensusNormalizer.normalize`
(`Sources/LungfishIO/Bundles/AlignmentDataProvider.swift:242-290`) before any
user sees it. That normalizer does two things the author's chain does not.

1. It rewrites every `*` as `N` (`:280`, `return callerBase == "*" ? "N" : callerBase`).
   The request is built with `deletionPolicy: .n`
   (`MappingConsensusExportRequestBuilder.swift:80`), and the normalizer's own
   guard refuses any other policy (`:250`). No asterisk ever reaches the file,
   the clipboard, the bundle, or the viewport row.
2. It masks any position whose independent `samtools depth` value falls below
   the minimum depth (`:278`), on top of the caller's own `-d` filter.

The author's chain also omitted the `-F` argument. The app's view stage passes
`-F 3332` whenever `excludedFlags` is non-zero (`AlignmentDataProvider.swift:786-788`),
and the default `excludeFlagsSetting` is `0xD04`, which is 3332
(`Sources/LungfishApp/Views/Viewer/SequenceViewerView.swift:430`), fed into the
filters by `currentAlignmentFilters()`
(`ReferenceBundleViewportController.swift:1633-1642`).

Every count in Reading the results and in What good looks like therefore
describes raw caller output rather than the app's output. Reproducing the full
app chain gives the figures in the corrected wording below.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Lungfish Genome Explorer (LGE) builds that sequence in the Inspector's Analysis tab, in a section named Consensus" | true | `ReadStyleSection.swift:1042` returns the tab title `"Consensus"`, and `consensusSection` begins at `:2437`. Matches the committed wording in `04-alignments/02-reading-an-alignment.md:196` | |
| 2 | "writes it out with a button named **Extract Consensus...**" | true | `ReadStyleSection.swift:2528`, `Button("Extract Consensus…")`. The source uses a Unicode ellipsis where the chapter uses three periods, which is the manual's settled convention | |
| 3 | "The result is the same length as the stretch of reference you asked about, one letter per position." | true | `AlignmentConsensusNormalizer.normalize` builds exactly `referenceLength` characters (`AlignmentDataProvider.swift:266`, `:276-282`), and the publication service refuses any other length (`AlignmentConsensusPublicationService.swift:105-108`) | |
| 4 | "Deletions the reads support appear as `*`, so a run of asterisks marks a stretch the reads say is missing from the sample." | false | The normalizer rewrites every `*` to `N` before the result leaves the provider (`AlignmentDataProvider.swift:280`), because the request always carries `deletionPolicy: .n` (`MappingConsensusExportRequestBuilder.swift:80`) and the normalizer's guard rejects anything else (`:250`). No asterisk path exists in the renderer either. My app-faithful rerun produced zero `*` characters | Deletions the reads support are written as `N` along with every other position the evidence could not settle, so the output alphabet is `A`, `C`, `G`, `T`, and `N` only. Delete the sentence about runs of asterisks |
| 5 | "Under the surface LGE runs samtools ... and passes it exactly the settings you chose." | true | Four staged samtools calls in `fetchConsensus` (`AlignmentDataProvider.swift:785-860`), each argument built from the request's filters | |
| 6 | "LGE installs and runs it for you, so there is nothing to type and nothing to install." | true | `findSamtools()` resolves the managed environment. The binary I ran, `~/.lungfish/conda/envs/samtools/bin/samtools`, reports samtools 1.24 on htslib 1.24 | |
| 7 | "LGE's own consensus surfaces do not assign a lineage name" | true | No Pango or Nextstrain assignment anywhere in `Sources/` outside the Viral Recon adapter. Matches DRIFT claim 4 | |
| 8 | "Lineage assignment happens inside the Viral Recon Wizard, where the nf-core pipeline runs Pangolin and Nextclade as stages of its own" | true | `docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md` exists and names both tools seven times. This is DRIFT changed claim 26 correctly applied | |
| 9 | "lineage abundances in a mixed sample belong to Running Freyja" | true | `docs/user-manual/chapters/06-classification/07-running-freyja.md` exists. Link resolves | |
| 10 | "The HG002 chromosome 20 slice used in this chapter is a 500,001-base stretch of human chromosome 20" | true | `docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta.fai` reads `chr20_10.0-10.5Mb 500001` | |
| 11 | "its benchmark call set holds 961 variants inside that stretch" | true | `docs/user-manual/fixtures/hg002-chr20/README.md:95` | |
| 12 | "the **Extract Consensus...** button stays disabled until the open bundle holds at least one alignment track" | true | `ReadStyleSection.swift:2531`, `.disabled(!viewModel.hasAlignmentTracks || viewModel.consensusExtractionAvailabilityMessage != nil)`. The button is also absent entirely unless `supportsConsensusExtraction` is true (`:2526`) | |
| 13 | "the samtools LGE uses for consensus is part of the managed tool set the app installs on its own" | true | Resolved through the managed conda environment. `gating: []` in the registry entry (`parameters.yaml:2914`) confirms no plugin pack | |
| 14 | "The section opens with a note reading \"Adjust consensus evidence settings here. Consensus controls are intentionally separate from View so display settings stay lighter.\"" | true | Verbatim at `ReadStyleSection.swift:2440` | |
| 15 | "Then set **Consensus scope** to `Whole contig` for the entire 500,001-base slice." | true | `AlignmentConsensusScope.resolve` returns `start: 0, end: context.contigLength` for `.wholeContig` (`AlignmentConsensusScope.swift:20`), and the contig length is 500,001 | |
| 16 | "the run refuses to start with the message \"Select a region in the viewer first\" when nothing is highlighted" | false | The string is right (`AlignmentConsensusScope.swift:23`) but the behaviour is not. `consensusScopeState()` resolves the scope eagerly (`ReferenceBundleViewportController.swift:988-999`) and publishes the error as `consensusExtractionAvailabilityMessage`, which both disables the button and prints the text beneath it (`ReadStyleSection.swift:2531`, `:2534-2537`). Nothing is submitted and then refused | With `Selected region` chosen and nothing highlighted, the button greys out and the line "Select a region in the viewer first" appears beneath it, so the run never starts |
| 17 | "Turning on **Hide high-gap sites** reveals two more sliders between the depth slider and the MAPQ slider." | true | `ReadStyleSection.swift:2487-2506`, the `if viewModel.consensusMaskingEnabled` block sits between the depth field (`:2479`) and the MAPQ field (`:2509`) | |
| 18 | "A row titled \"Generate Alignment Consensus\" appears in the Operations panel, which you open with **Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `ViewerViewController+Mapping.swift:130`, `title: "Generate Alignment Consensus"`. The menu path matches CONSISTENCY line 31 | |
| 19 | "a dialog headed Extract Sequence asks where the sequence should go" | true | `FASTASequenceExtractionDialog.swift:32`, `Text("Extract Sequence")` in the headline position | |
| 20 | "Pick `Save to File...` for a plain FASTA, `Save as Bundle` for a `.lungfishref` bundle, `Copy to Clipboard` ... or `Share...`" | true | All four labels verbatim at `ClassifierExtractionDialog.swift:27-31`. The file case writes a `.fasta` and the bundle case a `.lungfishref` (`ViewerViewController+Mapping.swift:361`) | |
| 21 | "Then click the button, which renames itself Save, Create Bundle, Copy, or Share to match." | true | `ClassifierExtractionDialog.swift:34-41`, `primaryButtonTitle` returns exactly those four titles | |
| 22 | Shot caption: "The Extract Sequence dialog with its Destination menu open on Save to File..., Save as Bundle, Copy to Clipboard, and Share..." | false | Destination is not a menu. It is a static column of four radio-style buttons rendered by `ForEach(DialogDestination.allCases)` (`FASTASequenceExtractionDialog.swift:50-60`), all four always visible with no menu to open. The order is Save as Bundle, Save to File..., Copy to Clipboard, Share... (`ClassifierExtractionDialog.swift:18-21`), and the default selection is Save as Bundle (`FASTASequenceExtractionDialog.swift:11`), not Save to File... | Rewrite the caption as the Extract Sequence dialog showing its four Destination choices, Save as Bundle selected by default, above Save to File..., Copy to Clipboard, and Share..., with the Name field prefilled |
| 23 | "If every position in the scope falls below your depth floor, an alert headed \"Consensus Contains Only N\" appears before the destination dialog and asks whether to continue." | true | `ViewerViewController+Mapping.swift:224`, `alert.messageText = "Consensus Contains Only N"`, with Continue and Cancel buttons (`:226-227`). It is awaited at `:155-166`, ahead of `presentAlignmentConsensusDestinationDialog` at `:170` | |
| 24 | "They steer both the consensus row drawn in the viewport and the sequence that **Extract Consensus...** writes out" | true | The same view-model values feed the renderer settings (`SequenceViewerView.swift:399-426`) and the exported request (`currentAlignmentFilters()`, `ReferenceBundleViewportController.swift:1633-1642`) | |
| 25 | "None of them has a command-line flag, because this operation has no command-line equivalent at all." | true | Every one of the ten registry settings carries `cli_flag: null` (`parameters.yaml:2926-2989`), and no `lungfish-cli` subcommand builds a consensus from an alignment | |
| 26 | **Show consensus track in viewer**, default on, on or off | true | `ReadStyleSection.swift:2445` label, `:87` default `true`. Registry `parameters.yaml:2920-2923` | |
| 27 | **Consensus Mode**, default `Bayesian`, values `Bayesian` and `Simple` | true | `ReadStyleSection.swift:2450-2453` label and both tags, `:90` default `.bayesian`. Registry `:2927-2932` | |
| 28 | **Consensus scope**, default `Whole contig`, values `Whole contig` and `Selected region` | true | `ReadStyleSection.swift:2459-2462`, `:342` default `.wholeContig`. Registry `:2934-2939` | |
| 29 | **Use IUPAC ambiguity codes**, default off | true | `ReadStyleSection.swift:2468`, `:93` default `false`. Registry `:2941-2946` | |
| 30 | **Hide high-gap sites**, default off | true | `ReadStyleSection.swift:2473`, `:68` default `false`. Registry `:2948-2952` | |
| 31 | **Consensus minimum depth**, default 8, "the range runs from 1 to 50" | true | `ReadStyleSection.swift:2479-2482`, `in: 1...50`, `:75` default `8`. Registry `:2955-2960` | |
| 32 | **Gap threshold**, default 90 percent, "the slider runs from 50 to 99 percent" | true | `ReadStyleSection.swift:2489-2494`, `in: 50...99` with a `%` suffix, `:71` default `90`. Registry `:2962-2967` | |
| 33 | **Masking minimum depth**, default 8, "the range runs from 1 to 50" | true | `ReadStyleSection.swift:2499-2503`, `in: 1...50`, `:78` default `8`. Registry `:2969-2974` | |
| 34 | **Consensus minimum MAPQ**, default 0, "the range runs to 60" | true | `ReadStyleSection.swift:2509-2513`, `in: 0...60`, `:81` default `0`. Registry `:2976-2981` | |
| 35 | **Consensus minimum base quality**, default 0, "the range runs to 60" | true | `ReadStyleSection.swift:2518-2522`, `in: 0...60`, `:84` default `0`. Registry `:2983-2988` | |
| 36 | "The viewport's own read inclusion settings ... decide which read groups and which flagged records are visible, and the consensus is built from exactly the reads that survive them." | true | `currentAlignmentFilters()` reads `excludeFlagsSetting` and `selectedReadGroupsSetting` straight off the viewer (`ReferenceBundleViewportController.swift:1639-1640`), and `fetchConsensus` turns them into `-F` and `-R` on the view stage (`AlignmentDataProvider.swift:789-794`). Settles the DRIFT "missing" row on read-group gating | |
| 37 | "Consensus minimum MAPQ ... The default is 0, which uses every read" | true, with a caveat worth adding | The effective MAPQ is `max(minMapQSetting, consensusMinMapQSetting)` (`ReferenceBundleViewportController.swift:1637`), so the viewport's own minimum can raise the floor even when this slider reads 0 | Optionally note that the viewport's own alignment-confidence filter can raise this floor, because the larger of the two wins |
| 38 | "produces a sequence 500,001 letters long" | true | The normalizer emits exactly `request.end - request.start` characters, and whole-contig scope sets that to the contig length of 500,001. My app-faithful rerun produced 500,001 | |
| 39 | "The 500,001 counts both ends of the 10.0 to 10.5 megabase range, which is why it is not the round 500,000 the file name suggests." | true | Arithmetic on the inclusive range, consistent with the `.fai` length | |
| 40 | "499,006 positions carry a plain `A`, `C`, `G`, or `T`, 724 carry `N`, and 271 carry `*`" | false | Those are raw caller counts from a chain missing `-F 3332` and the normalizer. The app's actual output is 498,974 plain bases and 1,027 `N`, with no `*` at all. My rerun of the author's exact chain reproduced 499,006 / 724 / 271 exactly, which confirms the discrepancy is the missing stages rather than a different sample | Within that sequence, 498,974 positions carry a plain `A`, `C`, `G`, or `T` and 1,027 carry `N`. Drop the asterisk sentence per claim 4 |
| 41 | "As a share of the slice it is 0.145 percent, so more than 99.8 percent of the region came back as a called base." | false | 1,027 of 500,001 is 0.205 percent, and the called share is 99.79 percent | As a share of the slice it is 0.205 percent, so a little under 99.8 percent of the region came back as a called base |
| 42 | "The 271 asterisks are positions the reads agree are deleted in this sample relative to the reference, and they are marked rather than silently dropped" | false | Follows from claim 4. The 271 caller deletions are folded into the `N` count, so they are neither marked nor separable in the output | Delete. If the deletion behaviour is worth keeping, say that positions the reads call deleted come back as `N` like any other unresolved position, which is why an `N` count is not purely a coverage measure |
| 43 | "finds 608 positions where a called letter differs from the reference, counting the asterisks and ignoring the `N` positions" | false | 608 is the raw-caller figure and it counts all 271 asterisks as differences. Against the app's normalized output the count is 337. Excluding asterisks from the author's own raw run also gives 337, so 337 is the substantive number under both chains | finds 337 positions where a called letter differs from the reference, ignoring the `N` positions where no comparison is possible |
| 44 | "The first of them is position 2,078, where the reference carries `G` and the consensus carries `A`." | true | Confirmed in the app-faithful normalized output. My rerun lists 2078 as the first differing position, reference `G`, consensus `A` | |
| 45 | "That is the same position the Reading an Alignment chapter uses as its worked example, and the consensus and the alignment agree about it." | true | `04-alignments/02-reading-an-alignment.md:58`, `:168`, `:208` all use position 2,078 with the same reference `G` and alternate `A` | |
| 46 | "The pileup there holds 51 read bases and every one of them is `A`, with a total depth of 63" | true | `samtools mpileup` on the app-faithful filtered BAM returns 51 bases, all `a` or `A`. `samtools depth -q 0 -g 1796` returns 63. The 51 also matches the 24 forward plus 27 reverse split quoted at `02-reading-an-alignment.md:208` | |
| 47 | "A position where every read carries the alternate is a homozygous change, meaning both copies of the chromosome carry it" | true (interpretive) | Standard genetics, correct for the reader level, and consistent with the fixture's benchmark treatment of this site | |
| 48 | Table row: "None, the defaults described above / 724 / 0.145 percent" | false | App-faithful value is 1,027 and 0.205 percent | 1,027, 0.205 percent |
| 49 | Table row: "**Consensus minimum depth** raised to 20 / 5,339 / 1.068 percent" | false | App-faithful value is 5,646 and 1.129 percent | 5,646, 1.129 percent |
| 50 | Table row: "**Consensus Mode** set to `Simple` / 888 / 0.178 percent" | false | App-faithful value is 1,176 and 0.235 percent | 1,176, 0.235 percent |
| 51 | Table row: "**Use IUPAC ambiguity codes** turned on / 171 / 0.034 percent" | false | App-faithful value is 361 and 0.072 percent | 361, 0.072 percent |
| 52 | Table row: "**Consensus minimum MAPQ** raised to 20 / 800 / 0.160 percent" | false | App-faithful value is 1,107 and 0.221 percent. The `-q 20` does go on the view stage as the author had it (`AlignmentDataProvider.swift:786-788`), so only the missing stages account for the gap | 1,107, 0.221 percent |
| 53 | "Raising the depth floor from 8 to 20 turns 4,615 more positions into `N`, which is a sevenfold increase in masking" | false | Recomputed from the corrected rows the increase is 4,619 positions, and 5,646 over 1,027 is a fivefold rise, not sevenfold | Raising the depth floor from 8 to 20 turns 4,619 more positions into `N`, roughly a fivefold increase in masking |
| 54 | "Switching to `Simple` mode masks 164 more positions than `Bayesian`" | false | Corrected difference is 149, which is 1,176 minus 1,027 | Switching to `Simple` mode masks 149 more positions than `Bayesian` |
| 55 | "Turning on ambiguity codes goes the other way and masks 553 fewer" | false | Corrected difference is 666, which is 1,027 minus 361 | Turning on ambiguity codes goes the other way and masks 666 fewer |
| 56 | "Those ambiguity letters were `R` 184 times and `Y` 191 times ... with `M`, `W`, `K`, and `S` making up the remaining 178" | false | Those are raw caller counts. After normalization the app's output holds `R` 182, `Y` 191, `M` 47, `K` 45, `W` 46, `S` 38, for 549 total and 176 in the remaining four. Depth masking removes two `R` and two `W` | Those ambiguity letters were `R` 182 times and `Y` 191 times, which are the two purine and pyrimidine pairs, with `M`, `W`, `K`, and `S` making up the remaining 176 |
| 57 | "The three settings that move those numbers most are worth seeing side by side." | false | The table carries four changed settings plus the baseline row, not three. Independent of the numeric corrections | Say the settings that move those numbers most, or name four |
| 58 | "the Operations panel row carries a summary block naming exactly what produced the sequence ... the scope, the region in `contig:start-end` form, the caller mode, the three evidence floors as one `depth/MAPQ/base quality` line, the excluded flags, the read groups, and two fixed policies" | true | `AlignmentScientificActionCoordinator.swift:145-157` builds exactly those eight lines. The floors line is labelled `Minimum depth/MAPQ/base quality`, which the chapter paraphrases accurately | |
| 59 | "two fixed policies reading `Low-depth policy: N` and `Reference-fill policy: never`" | true | Verbatim at `AlignmentScientificActionCoordinator.swift:154-155` | |
| 60 | "LGE never fills a thin position with the reference base, so an `N` in the output is genuinely an absence of evidence and never a quiet substitution of the reference for your sample." | true | The normalizer only ever emits caller bases or `N` and never consults the reference (`AlignmentDataProvider.swift:276-282`), and the bundle manifest description states the same (`AlignmentConsensusPublicationService.swift:307`) | |
| 61 | "When the run finishes, the Operations panel row carries a summary block" | false | The summary is logged to the Operations row only on the Copy to Clipboard path (`ViewerViewController+Mapping.swift:354`). Save to File..., Save as Bundle, and Share... complete without logging it (`:383-389`), so the block is not there after the run the Procedure walks the reader through | Say the summary reaches the Operations row when you copy the consensus to the clipboard, and that saving to a file records the settings in the provenance sidecar instead |
| 62 | "The FASTA record's own header names the sample, the contig, the scope, and the word consensus" | false | For `Whole contig` the builder deliberately omits both the scope word and the coordinates, giving `>{sample} {contig} consensus` (`MappingConsensusExportRequestBuilder.swift:52-59`). Only `Selected region` adds `:start-end` and the word `selected`. Since the Procedure uses whole contig, the reader will not see a scope in the header | The FASTA record's own header names the sample, the contig, and the word consensus. A selected-region consensus adds the coordinates and the word selected |
| 63 | "Saving as a bundle instead of a file writes a `.lungfishref` bundle you can open in LGE directly" | true | `ViewerViewController+Mapping.swift:361`, and the bundle branch writes a full manifest (`AlignmentConsensusPublicationService.swift:304-320`) | |
| 64 | "saving as a file writes the FASTA alongside a provenance sidecar recording the settings above" | true, but incomplete | The file path does write a sidecar, and it is installed before the payload so no FASTA can exist without it (`AlignmentConsensusPublicationService.swift:128-135`). The bundle path writes provenance too, inside the bundle, so the sentence implies a distinction that does not exist | Optionally note that the bundle carries the same provenance record inside it |
| 65 | "A whole-contig consensus should be exactly as long as the contig, and the fixture's 500,001 matches its reference." | true | As claim 38 | |
| 66 | "The fixture's 0.145 percent at the defaults is comfortable for a well-covered human slice." | false | Follows from claim 41. The figure is 0.205 percent | The fixture's 0.205 percent at the defaults is comfortable for a well-covered human slice |
| 67 | "A shorter sequence means the scope was `Selected region` when you meant `Whole contig`." | true | Selected-region requests resolve to the highlighted range only (`AlignmentConsensusScope.swift:31-36`), which is necessarily shorter | |
| 68 | "The fixture gives you position 2,078, where the reference reads `G` and every covering read reads `A`." | true | As claim 46 | |
| 69 | "There is no `lungfish-cli` equivalent for this operation." | true | No alignment-consensus subcommand exists in the CLI tree, and every registry setting carries `cli_flag: null` with `cli_only: []` (`parameters.yaml:2926-2990`) | |
| 70 | "the command the operation history records for it is written as `Lungfish.app alignment consensus`, which names the app rather than a command you can run" | true | `ViewerViewController+Mapping.swift:134` sets `cliCommand: "Lungfish.app alignment consensus --scope ... --region ... --reference-fill never"`. The author's flagged defect is real and correctly described | |
| 71 | "`lungfish-cli msa consensus` builds a consensus from a multiple sequence alignment bundle rather than from reads" | true | `lungfish-cli msa consensus --help` takes `<bundle-path>` described as "Input .lungfishmsa bundle" | |
| 72 | The `msa consensus` code block with `--output`, `--name`, `--threshold 0.75`, `--gap-policy omit` | true | All four options present in the help output, with `--output` required | |
| 73 | "`--threshold` is the minimum share of non-gap rows that must agree before a consensus base is written, and its default is 0.6." | true | Help text reads "Minimum non-gap residue fraction required for a consensus base (default: 0.6)" | |
| 74 | "`--gap-policy` takes `omit` or `include` ... with `omit` the default." | true | Help text reads "Gap policy: omit or include (default: omit)" | |
| 75 | "`--output-kind reference` writes a `.lungfishref` bundle instead of a bare FASTA, `--rows` restricts the consensus to named rows, and `--force` overwrites an existing output file." | true | Help lists all three with matching descriptions. Settles three DRIFT "missing" rows | |
| 76 | "The same action appears in the app on the multiple-sequence-alignment viewport as **Create Consensus Sequence**." | true | `MultipleSequenceAlignmentActionRegistry.swift:475` registers that exact title | |
| 77 | "Continue to Importing Existing VCFs" and the two closing cross-references | true | All three target files exist and the relative paths resolve | |
| 78 | Front matter `parameters_refs: [bam.extract-consensus]` | true | Matches roster row 30 (`DRIFT.md:3756`) and the registry id at `parameters.yaml:2910` | |
| 79 | Front matter `title: Extracting a Consensus Sequence` | true | Matches roster row 30 and the nav entry at `docs/user-manual/build/mkdocs.yml:102` | |
| 80 | Front matter `shots` lists every `<!-- SHOT -->` marker with a caption | true | Three markers in the body, `analysis-consensus-tab`, `consensus-masking-sliders`, `consensus-destination-dialog`, and three matching `shots` entries each with a caption. Caption accuracy is judged separately at claims 22 and 81 | |
| 81 | Shot caption: "The Consensus tab ... showing Show consensus track in viewer, the Consensus Mode and Consensus scope pickers, the two toggles, the three evidence sliders, and the Extract Consensus... button beneath the divider." | true | Self-consistent and accurate. The two toggles are `Use IUPAC ambiguity codes` (`ReadStyleSection.swift:2468`) and `Hide high-gap sites` (`:2473`), since `Show consensus track in viewer` (`:2445`) is named separately. Three sliders are visible at the default masking-off state (`:2479`, `:2509`, `:2518`), and the button does sit below a divider (`:2527-2530`) | |
| 82 | Shot caption: "The Consensus tab with Hide high-gap sites turned on, revealing the Gap threshold and Masking minimum depth sliders between Consensus minimum depth and Consensus minimum MAPQ." | true | Exactly the layout at `ReadStyleSection.swift:2479-2513` | |
| 83 | Every `glossary_refs` anchor resolves in GLOSSARY.md | true | All sixteen anchors resolve, including the two the author added, `iupac-ambiguity-code` and `samtools` | |
| 84 | Front matter `entry_points: ["Inspector > Analysis > Consensus > Extract Consensus..."]` | false | CONSISTENCY line 30 is explicit that chapters write "the Inspector's Consensus tab", not "Inspector > Analysis > Consensus". The chapter body obeys this but the front matter does not. The registry carries the same string (`parameters.yaml:2913`), so the registry needs the same correction | `"the Inspector's Consensus tab > Extract Consensus..."`, or whatever phrasing the lead settles, applied to both the chapter front matter and `parameters.yaml:2913` |
| 85 | "No plugin pack and no Docker Desktop are needed" | true | `gating: []` in the registry (`parameters.yaml:2914`) and a managed conda samtools with no pack requirement | |
| 86 | "in `Bayesian` mode low-quality bases are already down-weighted rather than counted equally" | unverifiable | This describes the samtools consensus model rather than anything LGE does. The app passes `-m bayesian` and `--min-BQ` (`AlignmentDataProvider.swift:823-825`) and nothing further. Reading the samtools consensus documentation or its source would settle whether the weighting works as described | |
| 87 | "Hide high-gap sites ... Turn it on when a noisy long-read alignment is filling the consensus with spurious insertions" | unverifiable | The control's own help text describes column masking "in packed or base views" (`ReadStyleSection.swift:2477`), which is a display claim, and the extraction request always sets `insertionPolicy: .omit` (`MappingConsensusExportRequestBuilder.swift:79`), so insertions never enter the extracted sequence at all. Whether the setting changes extracted output, and whether long-read insertion noise is the right trigger, needs a GUI run with masking on. My reruns covered the other four variations but not this one, because masking is not a samtools flag on this path | |

## Numbers to re-derive if the chapter is corrected

Each figure below comes from rerunning the app's full four-stage chain,
including `-F 3332` on the view stage and the normalizer's `*`-to-`N` rewrite
and depth mask.

| Run | `N` | Share | Notes |
|---|---|---|---|
| Defaults | 1,027 | 0.205 percent | 498,974 plain bases, no `*` |
| Depth 20 | 5,646 | 1.129 percent | |
| Simple mode | 1,176 | 0.235 percent | |
| IUPAC on | 361 | 0.072 percent | 549 ambiguity letters, `R` 182, `Y` 191, `M` 47, `K` 45, `W` 46, `S` 38 |
| MAPQ 20 | 1,107 | 0.221 percent | |

Differences from the reference at the defaults, `N` excluded, are 337. The first
difference is at position 2,078, reference `G`, consensus `A`, 51 pileup bases
all `A`, depth 63.

## Notes for the author and the lead

The bare-header check the author ran is sound and I confirmed it independently.
A whole-contig request returns `>chr20_10.0-10.5Mb` and `parseConsensusFASTA`
falls back to `0` rather than `nil` (`AlignmentDataProvider.swift:1146`), with
`parseConsensusHeaderStart` (`:1159-1166`) reading only the final
colon-delimited field so a contig name carrying colons cannot be misparsed. No
defect.

The unrunnable recorded command is confirmed and worth a cartographer decision,
as the author says.

One thing the chapter could add cheaply. Because deletions land as `N`, the `N`
count is not purely a coverage measure, which cuts against the What good looks
like framing that treats `N` share as an observation measure. At the defaults,
271 of the 1,027 `N` characters are called deletions rather than absent
evidence.

Verdicts: 66 true, 19 false, 2 unverifiable.
