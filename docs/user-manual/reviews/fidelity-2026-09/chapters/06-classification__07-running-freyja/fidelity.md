# Fidelity review, 06-classification/07-running-freyja

Chapter `docs/user-manual/chapters/06-classification/07-running-freyja.md`.
Roster row 38, registry id `workflow.freyja-demix`. Reviewed against Preview
2026.9.13, the Swift source in this worktree, `.build/debug/lungfish-cli`
help, the pinned Freyja 2.0.3 in `~/.lungfish/conda/envs/freyja`, and the
author's six recorded runs under the scratchpad.

The author's run outputs were all present and were re-read rather than
trusted. Every number quoted in the chapter was recomputed from the files on
disk. Three read-only commands were rerun to settle claims the run outputs
could not settle on their own, all of them Freyja help or a deliberately
failing probe, none of them writing into the repository.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "BQ.1.19 is a sublineage of BQ.1, carrying everything BQ.1 carries plus a little more" | true | Pango hierarchical naming. Consistent with the run's own output, where BQ.1 and BQ.1.19 both appear | |
| 2 | "Freyja holds a table of which mutations define which lineage, called the lineage barcode" | true | `~/.lungfish/conda/envs/freyja/lib/python3.1/site-packages/freyja/data/usher_barcodes.feather`; `freyja demix --help` exposes `--barcodes` "Path to custom barcode file" | |
| 3 | "Download the reference file `MN908947.3.fasta` from the manual's practice data files" | true | `docs/user-manual/fixtures/sarscov2-srr36291587/MN908947.3.fasta` exists, 30,427 bytes | |
| 4 | "fetch them from the Sequence Read Archive as accession `SRR36291587`" | true | `fixtures/sarscov2-srr36291587/README.md` names SRR36291587 and says the FASTQ is not committed | |
| 5 | "Freyja does not read your reads. It reads two summary tables derived from an alignment" | true | `freyja demix --help` usage is `freyja demix [OPTIONS] VARIANTS DEPTHS`; `cli-help/freyja.txt` requires `--variants` and `--depths` | |
| 6 | "Open **Tools > Plugin Manager...** (Cmd-Shift-B) and install it" | false | `MainMenu.swift:775-779` confirms the title and Cmd-Shift-B, but `PluginManagerViewModel.swift:492` loads packs with `includeExperimental: AppSettings.shared.experimentalFeaturesEnabled`, and `AppSettings.swift:419-424` defaults that to `false` in a release build. The Packs tab of Preview 2026.9.13 does not list the pack at all until the toggle is on. See App defects, new defect 4 | "Open **Settings > Advanced** and turn on **Show Experimental Features**, because the Wastewater Surveillance pack is marked experimental and the Plugin Manager hides it otherwise. Then open **Tools > Plugin Manager...** (Cmd-Shift-B) and install the pack." |
| 7 | "The pack carries five programs rather than one. Freyja itself, iVar and minimap2 ... and Pangolin and Nextclade" | true | `PluginPack.swift:836` lists `["freyja", "ivar", "pangolin", "nextclade", "minimap2"]` | |
| 8 | "The pack's card is marked Experimental in the Plugin Manager" | false | `PluginPack.swift:840` does set `isExperimental: true`, but with the toggle off the card is filtered out rather than badged, and with the toggle on the reader has already been told the pack is experimental. The claim describes a badge on a card the default build never draws. `PluginPackStatusService.swift:292-297` does the filtering | "The pack is marked experimental in the source, which is why the Plugin Manager hides it behind the experimental-features toggle." |
| 9 | "LGE pins version 2.0.3 of it" | true | `third-party-tools-lock.json:53` `"version": "2.0.3"`; `freyja --version` returns `freyja, version 2.0.3`; the plan JSON records `"toolVersion" : "2.0.3"` | |
| 10 | "The runs in this chapter used a barcode file dated 22 March 2026" | true | `last_barcode_update.txt` reads `03_22_2026-00-48` | |
| 11 | "Freyja has its own `freyja update` command for refreshing it, which LGE does not wrap" | true | `freyja --help` lists `update  Update to the most recent barcodes and curated lineage...`; `cli-help/freyja.txt` shows `demix` as the only LGE subcommand | |
| 12 | "Freyja has no dialog in LGE and no menu item of its own" | true | `FASTQOperationDialogState.swift` carries no Freyja tool id; no `NSMenuItem` in `MainMenu.swift` targets `showFreyjaDemix` | |
| 13 | "The app does carry an internal handler for Freyja ... all that handler does is open the Plugin Manager at the Wastewater Surveillance pack" | true | `MainMenu.swift:1172` declares it, `AppDelegate+ToolsMenu.swift:146-148` implements it as a single `PluginManagerWindowController.show(packID: "wastewater-surveillance")` call | |
| 14 | "Freyja is not a FASTQ or FASTA operation, so it never appears in the Tools category submenus" | true | Matches the reality map's corrected wording for DRIFT row 7 verbatim in substance | |
| 15 | "this produced a variants table with 16,779 rows and a depths table with 29,903 rows" | true | `wc -l` gives 16,780 lines for the variants table, which is 16,779 data rows plus the `REGION POS REF ALT ...` header, and 29,903 lines for the headerless depths table | |
| 16 | "`MN908947.3` is 29,903 bases long, so that count is exactly the genome length" | true | The fixture FASTA has 29,903 non-header characters | |
| 17 | "the printed command was `freyja demix .../srr36291587.variants.tsv .../srr36291587.depths.tsv --output .../demix-dry/freyja-demix.tsv`" | true | `demix-run/freyja-command-plan.json` `shellCommand` is exactly that shape, and `FreyjaDemixPlan.swift` composes it in that order | |
| 18 | "The command prints the same composed Freyja command line, then `Freyja demix complete.`" | true | `FreyjaCommand.swift` emits `plan.shellCommand`, then `emit("Freyja demix complete.")` on exit code 0 | |
| 19 | "The recorded run took 16.7 seconds of wall time, which the provenance sidecar records to the millisecond" | true | `demix-run/.lungfish-provenance.json` `"wallTime" : 16.743734002113342`. The value is recorded well past millisecond precision, so the sentence understates rather than overstates | |
| 20 | "Passing both `--dry-run` and `--execute` does not run Freyja ... with `execute` recorded as `false`" | true | `FreyjaCommand.swift` gates on `if execute && !dryRun` and writes `"execute": .string(String(execute && !dryRun))`; `demix-both/.lungfish-provenance.json` records `"execute" ... "value" : "false"` and the directory holds two files, no result | |
| 21 | "Three of the flags are required and the run refuses to start without them" | true | `FreyjaCommand.swift` declares `variantsPath`, `depthsPath`, and `outputDirectory` as non-optional `@Option`s; the CLI usage line brackets only `--sample` and `--extra-args` | |
| 22 | "LGE creates the directory for you if it does not exist" | true | `FreyjaCommand.swift` calls `createDirectory(at: outputDirURL, withIntermediateDirectories: true)` before building the plan | |
| 23 | "a second run pointed at the same directory overwrites the first run's plan and result without warning" | true | The plan is written `options: .atomic` with no existence check, and Freyja's `--output` path is fixed per directory. Nothing in `FreyjaCommand.swift` guards an existing file | |
| 24 | "the identifier is deliberately not passed to Freyja itself, because the pinned Freyja 2.0.3 has no `--sample` option and aborts the run when it is given one" | true | `FreyjaDemixPlan.swift` carries that exact comment and never appends `--sample`; the composed command in every plan JSON omits it; `freyja demix --help` has no `--sample`; a probe run returns `Error: No such option '--sample'. Did you mean '--solver'?` and does not demix | |
| 25 | "anything you put here is passed through unchecked, so a misspelled option is refused by Freyja rather than by LGE" | true | `FreyjaDemixPlan.swift` does `command += configuration.extraArguments` with no validation | |
| 26 | "`--eps` to change the minimum abundance a lineage must reach to be reported, which Freyja defaults to 0.001" | true | `freyja demix --help` gives `--eps FLOAT  minimum abundance to include for each lineage  [default: 0.001]` | |
| 27 | "the whole set of arguments goes inside one pair of quotes, for example `--extra-args \"--eps 0.01\"`" | true | `demix-extra/freyja-command-plan.json` `shellCommand` ends `--output .../freyja-demix.tsv --eps 0.01`, confirming both the quoting and the append-after-`--output` position | |
| 28 | "a command with neither this flag nor `--dry-run` writes the plan and stops without running anything" | true | The `else` branch emits the plan path only; `demix-default/` holds two files and no result | |
| 29 | "A finished run leaves three files in the output directory" | true | `demix-run/` holds `freyja-demix.tsv` (500 bytes), `freyja-command-plan.json` (2,452), `.lungfish-provenance.json` (3,922) | |
| 30 | "`freyja-command-plan.json` \| The exact command, the resolved options, and checksums of the inputs" | true | The plan JSON carries `command`, `shellCommand`, `options`, `resolvedDefaults`, and `sha256` plus `sizeBytes` on both inputs | |
| 31 | The verbatim five-line result block, including `summarized`, `lineages`, `abundances`, `resid 12.28623928020283`, `coverage 99.50506638129953` | true | Byte-for-byte identical to `demix-run/freyja-demix.tsv` read with `cat -A`, including the leading tab on line 1 and the tab after each label | |
| 32 | "On this sample 98.85 percent of the virus was assigned to Omicron" | true | `summarized [('Omicron', 0.9885371959826457)]` | |
| 33 | "BQ.1 accounts for 0.623 of the virus in this sample and BE.1.1.1 for 0.346. Those two together are 96.9 percent" | true | 0.62326010 + 0.34613150 = 0.9693916 | |
| 34 | "the remaining ten lineages share under two percent between them in slices of half a percent or less each" | true | The ten sum to 0.0191456, and the largest of them is 0.00468872, which is under half a percent | |
| 35 | "They are ordered from largest to smallest" | true | The twelve abundances are monotonically decreasing in the result file | |
| 36 | "`coverage` is the percentage of genome positions covered by at least ten reads, ten being Freyja's own default cutoff" | true | `freyja demix --help` gives `--covcut INTEGER  calculate percent of sites with n or greater reads  [default: 10]` | |
| 37 | "the twelve of them summed to 0.9885, which is the same figure the `summarized` line gives for Omicron" | true | The twelve sum to 0.9885372 against the summarized 0.9885371959826457, equal to seven decimal places | |
| 38 | "The plan holds ... the pack identity `wastewater-surveillance`, the pinned tool version `2.0.3`, the path of the environment Freyja ran from" | true | The plan JSON carries `packID`, `toolVersion`, and `runtimeIdentity` of `/Users/dho/.lungfish/conda/envs/freyja` | |
| 39 | "The sidecar holds the LGE command line you typed, the app version, the host operating system, the start and end timestamps, the exit code, the wall time, and the same input records" | true | All seven present in `demix-run/.lungfish-provenance.json`, the command line as an argv array on the single step | |
| 40 | "The output record for `freyja-demix.tsv` carries no checksum or size ... The input tables and the plan file do carry checksums" | true | The result's output record has only `format`, `path`, `role`. Both inputs and `freyja-command-plan.json` carry `sha256` and `sizeBytes`. Root cause in `FreyjaDemixPlan.swift`, which builds the output `FileRecord` before Freyja runs, and `FreyjaCommand.swift`, which reuses `plan.outputs` verbatim afterwards | |
| 41 | "A total well under 1 means Freyja could not attribute part of the signal to any lineage it knows about, which usually means the barcode file is older than the lineages actually present" | unverifiable | Reasonable and consistent with how the solver works, but no run in this campaign produced a low total, and no Freyja documentation was consulted that states the causal link. Settling it needs a deliberate run against a stale barcode file, which would be a write operation | |
| 42 | "A lineage that emerged after your barcode snapshot cannot be reported ... and the symptom is a poor residual or a low abundance total rather than an error message" | unverifiable | Same as row 41. The first half follows from the barcode being the only lineage vocabulary, the symptom claim is untested | |
| 43 | "what you are more likely seeing is one true lineage plus its close relatives absorbing part of the signal" | true | Stated as an interpretation and hedged with "more likely". BQ.1 and BE.1.1.1 are both Omicron descendants, which the `summarized` line confirms by assigning the whole 0.9885 to Omicron | |
| 44 | "its pipeline's own Freyja step is always skipped, which is that the pipeline pins a Freyja container built for Intel processors only" | true | Matches `chapters/04-alignments/05-viral-recon-wizard.md:175` in substance and in reason | |

## Front matter

| Field | Verdict | Note |
|---|---|---|
| `parameters_refs: [workflow.freyja-demix]` | true | The id exists at `parameters.yaml:6374` and is the only registry entry for this operation |
| `shots` against SHOT markers | true | One entry, `plugin-manager-wastewater-pack`, and exactly one `<!-- SHOT: plugin-manager-wastewater-pack -->` marker at line 59. They pair |
| `glossary_refs` against GLOSSARY.md anchors | true | All eighteen anchors resolve. Checked `allele-frequency`, `amplicon`, `bam`, `coverage`, `demixing`, `depth`, `freyja`, `ivar`, `lineage`, `lineage-barcode`, `plugin-pack`, `primer-scheme`, `provenance`, `provenance-sidecar`, `reference-bundle`, `residual`, `sublineage`, `wastewater-surveillance` |
| `prereqs` | true | All four chapter files exist |
| `fixtures_refs: [sarscov2-srr36291587]` | true | `docs/user-manual/fixtures/sarscov2-srr36291587/` exists and is referenced by seven other chapters |
| `tools: [freyja, ivar, samtools]` | changed | The chapter's own Step 1 is `freyja variants`, which shells out to samtools and iVar, so all three are used. But the pack ships minimap2 too and the chapter tells the reader to map with it in Before you start. Consider adding `minimap2` |
| `estimated_reading_min: 16` | unverifiable | The chapter is roughly 3,900 words, which is high for 16 minutes at typical prose rates but within range for a manual read at reference pace. No campaign rule fixes the conversion |

The caption on the one shot says the card shows "its Experimental marking and
the five tools it installs". The five tools are right. The Experimental
marking is the subject of claim 8 and new defect 4, so the caption needs the
same correction as the prose before the Screenshot Scout shoots it, and the
recipe must turn the experimental toggle on first or the card will not be
on screen to shoot.

## Settings coverage against parameters.yaml

The registry entry has `settings: []` and seven `cli_only` flags. The chapter
has seven Settings paragraphs and no dialog settings, which is the right
shape for a command-line-only operation.

| Registry flag | Paragraph | Default agrees | Effect agrees |
|---|---|---|---|
| `--variants` | **Variants.** | yes, "none, and the flag is required" | yes |
| `--depths` | **Depths.** | yes | yes, and the chapter adds the coverage-gating detail from the registry note |
| `--output-dir` | **Output dir.** | yes | yes |
| `--sample` | **Sample.** | yes, empty | yes, including the Freyja 2.0.3 abort |
| `--extra-args` | **Extra args.** | yes, empty | yes, and the chapter is more specific than the registry, naming `--eps` and `--barcodes` |
| `--execute` | **Execute.** | yes, false | yes |
| `--dry-run` | **Dry run.** | yes, false | yes, and the chapter adds the precedence over `--execute`, which the registry omits |

Coverage is complete, in registry order, and every paragraph ends by naming
its flag as the chapter's opening sentence promises. Two paragraphs are
better than the registry entry they document.

Registry drift worth reporting to whoever owns `parameters.yaml`. The
`--dry-run` effect line does not record that the flag overrides `--execute`,
which is now settled true by both source and run. The `--extra-args` effect
line gives "for example a different lineage barcode file" and could name
`--eps` as the chapter does. Neither is a chapter defect.

## Consistency

Against `chapters/04-alignments/05-viral-recon-wizard.md`. Both chapters say
the viralrecon Freyja step is always skipped, both give the same reason,
which is an Intel-only container against Apple Silicon, and both point the
reader at the native pack as the working path. The Viral Recon chapter links
to this one at line 175 and this one links back in Next. No contradiction.

Against `CONSISTENCY.md`. The fixed sentence for experimental features is
"This feature is experimental. Turn on **Show Experimental Features** in
**Settings > Advanced** before you look for it." The author deliberately did
not use it, reasoning that the pack is visible without any toggle and merely
carries a badge. That reasoning is wrong on the evidence, and the fixed
sentence is exactly right for this chapter. `PluginManagerViewModel.swift:492`
filters the pack out of the Packs tab unless the toggle is on, and the toggle
defaults off in a release build. The chapter must use the fixed sentence in
Before you start, ahead of the Plugin Manager instruction.

Terminology is consistent with the campaign rules. "Lungfish Genome Explorer
(LGE)" is introduced at first mention in the Before you start section and
"LGE" is used thereafter. The chapter never uses "Lungfish" alone for the
app. Tool names match the source spellings, Freyja, iVar, Pangolin,
Nextclade, minimap2.

The chapter's honesty about the clinical fixture is consistent with the
campaign's example rule. The rule prefers human or macaque data, the chapter
states that Freyja is SARS-CoV-2 by design so no such example is possible,
and that is the correct exemption rather than an evasion of it.

## App defects

The author reported three. All three confirmed, one restated more precisely.
One new defect found.

**1. The demix result carries no checksum or size. Confirmed.** In
`demix-run/.lungfish-provenance.json` and in `freyja-command-plan.json`, the
output record for `freyja-demix.tsv` holds only `format`, `path`, and `role`,
while both input tables and `freyja-command-plan.json` hold `sha256` and
`sizeBytes`. The cause is as the author describes.
`FreyjaDemixPlan.swift` builds the output `FileRecord` at plan-construction
time through `ProvenanceRecorder.fileRecord`, before Freyja has written
anything, and `FreyjaCommand.swift` passes `plan.outputs` unchanged into
`writeCommandPlanProvenance` after the run rather than re-recording the file.
The fix is one line at the provenance-writing site, re-recording
`plan.outputs` after a successful execute. The chapter discloses this
accurately at the end of Reading the results.

**2. Successful runs record no stderr. Confirmed, and it is narrower than
"minor".** `FreyjaCommand.swift` calls `writeCommandPlanProvenance` without a
`stderr` argument on every path, and the successful sidecar has no `stderr`
key. On the failure path the stderr goes into
`CLIError.workflowFailed(reason:)`, so it reaches the terminal but never the
sidecar, which means a failed run's provenance is no better off than a
successful one. The author's framing of "possibly intended" is fair for the
success path and understates the failure path. The chapter correctly drops
the old claim that the sidecar records stderr rather than restating it.

**3. `freyja variants` exits 0 with an empty variants table when the pack env
is off PATH. Confirmed as reported and correctly scoped.** This is Freyja's
own behavior, LGE does not wrap `freyja variants`, and the chapter documents
the command while leaving the environment to the reader. It is the most
likely way a reader following this chapter gets a wrong answer silently,
because an empty variants table still demixes and still prints a coverage
figure. The author's suggestion that LGE wrap `freyja variants` is sound and
belongs with the Documentation Lead. Not reproduced here, because provoking
it means writing new output files, and the author's record is specific enough
to stand.

**4. NEW. The Wastewater Surveillance pack is invisible in the Plugin Manager
in a release build.** `PluginManagerViewModel.loadPackStatuses` at
`PluginManagerViewModel.swift:492` calls
`visibleStatuses(includeExperimental: AppSettings.shared.experimentalFeaturesEnabled)`.
`PluginPackStatusService.swift:292-297` filters out every pack whose
`isExperimental` is true when that argument is false.
`AppSettings.swift:419-424` defines `defaultExperimentalFeaturesEnabled` as
`true` under `#if DEBUG` and `false` otherwise. Preview 2026.9.13 is a
release build, so the default is off and the pack does not appear on the
Packs tab. `PluginPack.swift:840` sets `isExperimental: true` for this pack.

Two consequences. First, the chapter's Before you start instruction sends the
reader to a window where the pack is not listed, with no explanation, which
is a hard stop on the only GUI step the chapter has. Second, the handler at
`AppDelegate+ToolsMenu.swift:146-148` calls
`PluginManagerWindowController.show(packID: "wastewater-surveillance")`, which
focuses a pack that the Packs tab may not be showing. That handler is wired
to no menu item today, so it is latent rather than live, but it would
misbehave the moment a menu item is added.

The CLI is unaffected. `PluginPack.visibleForCLI` uses `activeOptionalPacks`
without the experimental filter, so `lungfish conda install --pack
wastewater-surveillance` works with the toggle off. That asymmetry is worth
naming in whatever bug this becomes, because it means the chapter has a
working workaround that the prose does not currently mention.

## Notes for the editor

Three things need changing, and only the first is substantial.

The Before you start Plugin Manager paragraph is wrong and needs the
CONSISTENCY.md fixed sentence in front of it. The corrected wording for claim
6 gives the shape. The paragraph after it, which explains what the
Experimental marking means, then needs its opening clause adjusted, because
"The pack's card is marked Experimental in the Plugin Manager" describes
something the reader will only see after following the new instruction. The
explanation itself, that the marking means less testing inside LGE rather
than an unfinished Freyja, is good and should survive. Consider also
mentioning the CLI install as the alternative that needs no toggle, since it
is one line and it is what a reader who dislikes changing preferences will
want.

The shot caption and the Screenshot Scout recipe both need the toggle turned
on before the Plugin Manager is opened, or the shot cannot be taken.

Two claims about barcode staleness, rows 41 and 42, are unverifiable rather
than wrong. They are plausible and they are the kind of guidance a reader
needs. If the editor wants them airtight, the way to settle them is a
deliberate demix against an old barcode file, which is a write operation this
review does not perform. Leaving them as written is defensible. Attributing
them to Freyja's own documentation would be better than leaving them
unattributed.

Everything else in the chapter is accurate. The numbers are exact, the result
block is byte-for-byte, the provenance description now matches a real sidecar
rather than the old chapter's guess, and the split between what lives in the
plan and what lives in the sidecar is correct where the old chapter conflated
them. The `--sample` claim, which the task singled out, is true in both
halves and is the strongest-sourced claim in the chapter, backed by a source
comment, the composed command in five separate plan files, the Freyja help,
and a probe that reproduces the abort verbatim.

Lint is clean under `LUNGFISH_MANUAL_STRICT=1`, confirmed by rerunning it.

## Counts

True 39. False 2. Unverifiable 3. Changed 1 (front matter `tools`).
Total claims assessed 44, plus 7 front-matter fields and 7 settings
paragraphs.

App defects confirmed 3, new 1.
