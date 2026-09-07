# Fidelity review: 07-assembly/02-running-spades

Reviewed 2026-09-07 against Preview 2026.9.13, the Swift source, the CLI help
dump at `reviews/fidelity-2026-09/cli-help/assemble.txt`, the three registry
entries in `parameters.yaml` (4801-5119), the fixture's `expected/spades`
outputs, and five fresh MEGAHIT runs of my own.

The chapter is in very good shape. Every settings claim, every source-backed
GUI claim, and every viewport claim I checked is true. Two findings matter.
The MEGAHIT figures in the comparison table are real but not reproducible on
demand, because MEGAHIT 1.2.9 on this machine fails about four runs in five.
And the chapter's SPAdes wall time disagrees with the sibling concept chapter
and with the committed fixture.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "SPAdes chops every read into k-mers and builds a de Bruijn graph" and the fork-pruning account | true | Standard SPAdes description, consistent with `GLOSSARY.md:151`. No app claim. | |
| "LGE runs SPAdes through an assembly sheet reached from **Tools > Assembly > SPAdes...**" | true | `CONSISTENCY.md:21-25`, Assembly is a per-tool submenu. DRIFT changed-claim 8. | |
| "The same sheet runs MEGAHIT and SKESA" | true | `FASTQOperationToolPanes.swift:33-44`, five assembly tool ids route to one sheet. | |
| "LGE writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses` folder" | true | `AnalysesFolder.swift:118-137`, `{tool}-{timestamp}`; `AssemblyBundleBuilder.swift:89-105`. DRIFT changed-claim 4. | |
| "ranks the contig list by length and shows each contig's length, GC percent, and share of the assembly, with a sequence preview" | true | `AssemblyContigTableView.swift:19-47`, six columns as listed. Matches DRIFT false-claim 5 correction verbatim. | |
| "In humans that chromosome is 16,569 bases long" | true | NC_012920.1, the fixture's own reference. | |
| "The fixture holds 9,958 such pairs" | true | MEGAHIT log line "19916 reads" for the pair, so 9,958 pairs. | |
| "All three assemblers ship in the `assembly` plugin pack, which the Plugin Manager lists as **Genome Assembly**" | true | `PluginPack.swift:669-670`, id `assembly`, name "Genome Assembly". | |
| "**Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `CONSISTENCY.md:34-35`. | |
| "The pack pins SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, and hifiasm 0.25.0" | true | `third-party-tools-lock.json:42-46`. | |
| "The SPAdes run in this chapter took 110.7 seconds on a fourteen-core Mac." | true as an observation, **inconsistent** with the sibling chapter and the fixture | The author's own run recorded `wallTimeSeconds` 110.70146906375885 with `--threads 14`. But `fixtures/human-mito/expected/spades/assembly-result.json` records 13.7s for the identical command and byte-identical statistics, and `01-when-to-assemble.md:112` quotes 13.7 seconds. See Consistency below. | Resolve with the editor. Either quote the fixture's 13.7 seconds in both chapters, or drop the absolute figure and say the SPAdes run takes well under two minutes while MEGAHIT and SKESA take seconds. |
| "MEGAHIT and SKESA on the same reads took under three seconds each." | true | SKESA 1.5957s, MEGAHIT 2.6993s (my run 5, matching the author's 2.7s). | |
| Step 2: "The assembly sheet opens with SPAdes already chosen in the Assembler picker at the top of Primary Settings." | true | `AssemblyWizardSheet.swift:492-505`, Assembler is the first row of Primary Settings; `initialTool` seeds the selection. | |
| Step 2: "SPAdes, MEGAHIT, SKESA, Flye, and Hifiasm are five separate menu items into the same sheet" | true | `FASTQOperationToolPanes.swift:33-44`. | |
| Step 3: Inputs shows "the dataset you selected, its read layout, and the detected read class in three rows. These are read-only." | true | `AssemblyWizardSheet.swift:474-490`. Matches DRIFT false-claim 9 correction. | |
| Step 4: locked label with the caption "Locked from FASTQ header detection." | true | `AssemblyWizardSheet.swift:507-524`, string verbatim at :510. | |
| Step 4: "When the headers give no clear answer the row becomes a picker you must set before Run turns on." | true | `readTypeIsLockedToDetection` at `AssemblyWizardSheet.swift:201-203`, else branch renders a segmented Picker. | |
| Step 5: "Leave the **Profile** popup on **Isolate**" | true | `defaultProfileID(for:)`, registry default Isolate, `.pickerStyle(.menu)` at :532-537. | |
| Readiness "reports the managed tool status ... saying that it is checking the Genome Assembly pack while it looks" | true | `AssemblyWizardSheet.swift:673-674`, "Managed tool status: checking Genome Assembly pack." Paraphrased, correctly, to avoid an in-sentence colon. | |
| Readiness quoted strings "Select at least one FASTQ input." and "Project name is required." | true | `AssemblyWizardSheet.swift:29-52` validation strings; rendered at :688-692. | |
| Step: "**Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `CONSISTENCY.md:33-34`. | |
| "LGE first materialises the FASTQ files ... then launches SPAdes inside its own conda environment" | true | Materialization is the documented first pipeline step; `ManagedAssemblyCommand.environment` is `request.tool.environmentName`. | |
| "The complete text is also saved as `assembly.log` in the run folder" | true | `assembly-result.json` `logPath` is `assembly.log`; present in all five of my run directories. | |
| Results block "Contigs 1 / Total length 16697 bp / N50 16697 bp / Largest contig 16697 bp / GC content 44.4%" | true | `expected/spades/assembly-result.json` statistics block, gcFraction 0.4444510989998203. | |
| "a folder named with the tool and the date and time, such as `spades-2026-09-07T05-03-41`" | true | `AnalysesFolder.swift:118-137`, `{tool}-{timestamp}`. | |
| "There is no `Assemblies` folder." | true | `AnalysesFolder.swift:24-27` `knownTools`; no Assemblies path anywhere. DRIFT false-claim 13. | |
| "The sheet carries eleven controls for SPAdes, arranged in four sections." | true | Primary 6 (Assembler, Read Type, Profile, Threads, Memory Limit, Min Contig), Advanced 3 (Careful mode, Skip error correction, Extra arguments), Output 2 (Project Name, Output Folder). Sections at :476, :494, :580, :627, plus Readiness at :645 which carries no control. | |
| **Assembler.** "a row of segmented buttons at the top of Primary Settings" | true | `.pickerStyle(.segmented)` at `AssemblyWizardSheet.swift:502`. | |
| **Assembler.** "an Illumina bundle offers SPAdes, MEGAHIT, and SKESA while a Nanopore bundle offers Flye and Hifiasm" | true | `AssemblyCompatibility`; registry `allowed` field on all three entries. | |
| **Read Type.** "one of Illumina short reads, ONT reads, or PacBio HiFi/CCS" | true | Registry `allowed`; `AssemblyReadType.allCases`. | |
| **Profile.** "appears for SPAdes and MEGAHIT but not for SKESA, which has no presets" | true | `AssemblyWizardSheet.swift:526` `if !profileOptions.isEmpty`; registry `assemble.skesa` notes, "the sheet hides the whole Profile row when the list is empty". | |
| **Profile.** SPAdes "offers Isolate, Meta, and Plasmid, defaulting to Isolate" | true | `ManagedAssemblyPipeline.swift:181-190`, `--isolate`/`--meta`/`--plasmid`, default `"isolate"`. | |
| **Profile (MEGAHIT).** "Default, Meta Sensitive, and Meta Large and defaulting to Default" | true | Registry `assemble.megahit`. | |
| **Profile (MEGAHIT).** "its internal id is empty and an empty id makes LGE omit the flag entirely, so only `meta-sensitive` and `meta-large` are ever named" | true | `ManagedAssemblyPipeline.swift:228-230`, `if let selectedProfileID, !selectedProfileID.isEmpty`. Flag is `--presets`. | The prose says "On the command line this is `--profile`", which is the LGE flag and correct. Worth noting the underlying MEGAHIT flag is `--presets`, but the chapter never claims otherwise. |
| **Threads.** "a slider running from 1 to the number of cores your Mac reports" | true | `AssemblyWizardSheet.swift:541-547`, `in: 1...Double(max(1, availableCores))`, `availableCores` = `processorCount` at :128-129. | |
| **Threads.** "defaults to the smaller of that core count and 8" | true | `AssemblyWizardSheet.swift:324`, `threads = min(Double(availableCores), 8)`. | |
| **Threads.** "On Apple Silicon LGE lowers whatever you pick to 2 and adds `--no-hw-accel`" | true | `AssemblyRunRequest.swift:100-106` `effectiveThreadCount`, `min(requestedThreads, 2)`; `ManagedAssemblyPipeline.swift:234-237` appends `--no-hw-accel`. | |
| **Threads.** "The reference MEGAHIT run reported `Threads : 2` even though the machine has fourteen cores." | true | Reproduced in all five of my runs; `commandLine` ends `--num-cpu-threads 2 --no-hw-accel`. | |
| **Threads.** "because MEGAHIT 1.2.9 crashes above that on arm64" | true as the code's stated reason, but **incomplete** | `AssemblyRunRequest.swift:101` comment says exactly this. My runs show it also crashes *at* two threads, four times in five. See App defects. | Add that the cap reduces but does not remove the crash. Suggested: "On Apple Silicon LGE lowers whatever you pick to 2 and adds `--no-hw-accel`, because MEGAHIT 1.2.9 is unstable on arm64, so the slider has little effect there. The workaround does not make the tool reliable, and a MEGAHIT run may still stop partway with a nonzero exit code." |
| **Memory Limit.** "a slider reading whole gigabytes from 1 up to the memory your Mac reports" | true | `AssemblyWizardSheet.swift:551-559`, `in: 1...Double(max(1, availableMemoryGB))`, suffix "GB"; `availableMemoryGB` at :124-126. | |
| **Memory Limit.** "defaults to three quarters of installed memory capped at 32 GB" | true | `AssemblyWizardSheet.swift:325`, `memoryGB = min(Double(availableMemoryGB) * 0.75, 32)`. | |
| **Memory Limit.** "appears for SPAdes, MEGAHIT, and SKESA and is hidden for Flye and hifiasm" | true | `AssemblyOptionCatalog.swift:111-121`, `toolMappings` names only those three. Guarded by `supportsMemoryLimit` at :551. | |
| **Memory Limit.** "MEGAHIT takes the same budget in bytes, so LGE converts your gigabyte figure" | true | `AssemblyRunRequest.swift:95-98` `effectiveMegahitMemoryBytes`, `memoryGB * 1024^3`. DRIFT changed-claim 20. | |
| **Memory Limit.** "SPAdes stops with an error rather than swapping to disk when it hits it" | true | Registry `assemble.spades` effect field states the same. | |
| **Min Contig.** "a stepper in Primary Settings below the Threads and Memory Limit sliders, accepting 0 to 1,000,000 bases in steps of 100 and defaulting to 0" | true | `AssemblyWizardSheet.swift:564-574`, `Stepper(value:in: 0...1_000_000, step: 100)`, rendered last in the section. Default 0 per registry. | |
| **Min Contig.** "receive it as `--min-contig-len` and `--min_contig` respectively" | true | `ManagedAssemblyPipeline.swift:225-227` (MEGAHIT) and :263-265 (SKESA). | |
| **Min Contig.** "With SPAdes selected the stepper is shown and editable but the value never reaches the run" | true | `buildSpadesCommand` at `ManagedAssemblyPipeline.swift:178-209` never reads `minContigLength`; `AssemblyOptionCatalog.swift:127-133` maps SPAdes to the string "Lungfish post-filter", which is what renders the stepper. Confirmed defect. | |
| **Careful mode.** "appears for SPAdes alone inside the **Curated extra arguments** disclosure under Advanced Settings" and is off by default | true | `AssemblyWizardSheet.swift:58` disclosure title verbatim; `:584-591` `case .spades` renders both toggles; `spadesCareful = false` at :78. | |
| **Skip error correction.** "Passes SPAdes' `--only-assembler` flag" | true | `AssemblyWizardSheet.swift:915-921` maps the toggle to `--only-assembler`. | |
| Both toggles: "This setting has no command-line flag, so on the command line you pass it through `--extra-args`" | true | Registry `cli_flag: null` for both; `assemble.txt` lists no such flag. | |
| **Extra arguments.** "a free-text field at the bottom of Advanced Settings" | true | `AssemblyWizardSheet.swift:609-618`, the TextField follows the toggles and the catalog descriptions. | |
| **Extra arguments.** "text the parser cannot read, an unclosed quotation mark for instance, blocks Run and prints the reason in the footer" | true | `AssemblyWizardSheet.swift:801-808` parse failure feeds `validationMessage`, rendered at :688-692. | |
| **Extra arguments.** "LGE pins `--min_count 2` on every SKESA run unless you supply your own" and "passing your own `--min_count` in this field replaces the pinned value" | true | `ManagedAssemblyPipeline.swift:266-270`, guarded by `containsArgument(named: "--min_count", in: request.extraArguments)`. Confirmed in the author's run, `--cores 14 --min_count 2`. | |
| **Project Name.** "the mate suffixes `_R1`, `_R2`, `_1`, `_2`, and the `.lungfishfastq` extension stripped and `_assembly` appended, falling back to the literal `assembly`" | true | Registry `assemble.spades` default field, same wording. TextField placeholder is "assembly" at :631. | |
| **Project Name.** "an empty name blocks Run" | true | `AssemblyWizardSheet.swift:29-52`, "Project name is required." | |
| **Output Folder.** "a read-only row under the Project Name field in the Output section" resolving to `Analyses` | true | `AssemblyWizardSheet.swift:635-641` renders a Text, not a field; `FASTQOperationDialogState.defaultOutputDirectory` returns `projectURL/Analyses`. | |
| **Run Mode.** "appears only when you selected several" | true | `AssemblyWizardSheet.swift:183-185` `showsMultiBundleRunModePicker`, `shortReadTools.contains(selectedTool) && bundleCount > 1`. | |
| **Run Mode.** offers "Run separately per bundle" with a locked "Combine all inputs, run once" | true | `AssemblyWizardSheet.swift:167-171`; `lockReason` at :170. The chapter paraphrases rather than quoting, correctly, because the app string carries a semicolon. | |
| Viewport: "a summary strip across the top, a contig table, and a detail pane" with three layouts, "detail-leading, which is the default, list-leading, and stacked" | true | `AssemblyLayoutPreference.swift:9-12`, `detailLeading` first and the fallback. | |
| Summary strip "reports the assembler, the read type, the contig count, the total bases assembled, N50, L50, the longest contig, and the whole-assembly GC percent, and it adds the tool version and the wall time when the run recorded them" | true | `AssemblySummaryStrip.swift:321-341`, eight unconditional fields in exactly that order, then Version and Wall Time guarded. | |
| Strip reading "SPAdes, Illumina short reads, 1 contig, 16697 total bp, N50 16697 bp, L50 1, longest 16697 bp, global GC 44.4%, version 4.3.0, wall time 110.7s" | true except the wall time | Every other value confirmed against `expected/spades`. Wall time carries the same conflict as the Before you start figure. | Same resolution as the 110.7 row above. |
| "16697 total bp" written without a thousands separator | true | `AssemblySummaryStrip.swift:324`, `"\(result.statistics.totalLengthBP)"`, raw Int interpolation. The author flagged this as unobserved; the source settles it. | |
| N50 definition, "the length of the contig you are holding when the running total first reaches half the assembly's total bases" | true | `AssemblyStatistics.computeNx` at :180-190. Matches `GLOSSARY.md:379`. | |
| L50 "giving the number of contigs it took to reach that halfway mark" | true | `GLOSSARY.md:303`; `AssemblySummaryStrip.swift:329`. | |
| Contig table "has six columns, `#`, `Contig`, `Length (bp)`, `GC %`, `Share of Assembly (%)`, and `Sequence Preview`" | true | `AssemblyContigTableView.swift:19-47`, exact titles and order. | |
| "a filter field above them narrows the rows by name or header" | true | `AssemblyResultViewController` filter field. | |
| "The `#` column is the contig's rank by length, so row 1 is always the longest" | true | `rank` column at :20; the table sorts by length regardless of FASTA order. Agrees with `01-when-to-assemble.md:138`. | |
| "There is no coverage column anywhere in this viewport." | true | No coverage identifier in `columnSpecs` or `summaryFields`. DRIFT false-claim 5. | |
| Detail pane shows "the contig header, its length, its GC percent, its rank in the assembly, its share of the total assembly length, and a scrollable view of its sequence" | true | `AssemblyContigDetailPane.swift:264-273` `showSingleSelection`, exactly those five metrics plus `sequenceView.string`. | |
| "The fixture's single contig is named `NODE_1_length_16697_cov_121.957333`" | true | `fixtures/human-mito/README.md:96` and the author's `contigs.fasta`. | |
| Action bar offers "**BLAST Contigs**, **Copy FASTA**, **Export FASTA**, and **Create Bundle**, all disabled until you select at least one contig" | true | `AssemblyActionBar.swift:10-13` titles; `:59-68` `setSelectionCount` gates all four on `count > 0`. | |
| "The first button reads **BLAST Contig** in the singular when exactly one is selected." | true | `AssemblyActionBar.swift:65`, `count == 1 ? "BLAST Contig" : "BLAST Contigs"`. | |
| Right-click adds "**Extract Sequence...**, **Align with MAFFT...**, and **Run Operation...**" | true | `FASTASequenceActionMenuBuilder.swift:70-127`, wired at `AssemblyResultViewController.swift:295-309` per the DRIFT Missing row. | |
| "There is no double-click shortcut for this." | true | DRIFT false-claim 24. | |
| Comparison table, SPAdes row 4.3.0 / 1 / 16697 / 16697 / 16697 / 44.4% | true | `expected/spades/assembly-result.json`. Wall time 110.7s carries the conflict noted above. | |
| Comparison table, MEGAHIT row 1.2.9 / 2.7s / 3 / 17405 / 16711 / 16711 / 44.6% | true, and I reproduced it | My run 5 `assembly-result.json`: contigCount 3, totalLengthBP 17405, largestContigBP 16711, n50 16711, gcFraction 0.44619, wallTimeSeconds 2.699. Contigs `k141_0 len=332`, `k141_2 len=362`, `k141_1 len=16711`. | |
| Comparison table, SKESA row 2.5.1 / 1.6s / 1 / 16570 / 16570 / 16570 / 44.4% | true | Author's run and the concept chapter's independent run agree exactly (1.5957s, gcFraction 0.44406). | |
| "SKESA ... labelled its contig `Contig_1_257.173_Circ [topology=circular]`" | true | Both authors' `contigs.fasta`. | |
| "MEGAHIT additionally emitted two short contigs of 332 and 362 bases" | true | My run 5 headers. | |
| "the published length is 16,569 bases" | true | NC_012920.1. | |
| "the fixture's 16,697 bases against a published 16,569 is well within the margin" | true | Arithmetic, 128 bases over. Agrees with `01-when-to-assemble.md:114`. | |
| "all three runs reported 44.4 to 44.6 percent" | true | 44.4 / 44.6 / 44.4 as above. | |
| "the totals ran from 16,570 to 17,405 bases" | true | As above. | |
| "LGE reports a run that exited cleanly but wrote nothing as a distinct outcome rather than as a success with an empty table" | true | The `completedWithNoContigs` outcome, per the concept chapter's ground-truth citation. | |
| CLI: "The command is `lungfish-cli assemble`" taking inputs as arguments with `--paired` | true | `assemble.txt` USAGE and ARGUMENTS. | |
| CLI code block, the exact SPAdes command | true | Matches the author's recorded command; every flag exists in `assemble.txt`. I reran the equivalent MEGAHIT form successfully once. | |
| `--paired` "Treats the two input files as the forward and reverse mates of one library ... Off by default." | true | `assemble.txt`. | |
| `--output` "Aliases are `-o` and `--output-dir`." | true | `assemble.txt`, `-o, --output, --output-dir <output>`. | |
| `--extra-arg` "may be repeated" | true | `assemble.txt`, "(repeatable)". | |
| `--format` "Prints the run summary as `text`, `json`, or `tsv`. Defaults to `text`." | true | `assemble.txt`. | |
| "Four flags have no equivalent control in the sheet." | true | Those four; every other CLI flag maps to a control or is a global option. | |
| "`--min-contig-length` is passed to MEGAHIT and SKESA and ignored by SPAdes, Flye, and hifiasm" | true | `ManagedAssemblyPipeline` builders; DRIFT changed-claim 39. | |
| "`--profile` is accepted for SKESA and ignored" | true | Registry `assemble.skesa` `cli_only`, "Accepted by the command but ignored for SKESA, which has no profiles." | |
| "Every run also writes `assembly-result.json` beside the contigs, which carries the resolved tool version, the exact command line, the wall time, and the full statistics block" | true | Verified in all my successful runs. Keys `assemblerVersion`, `commandLine`, `wallTimeSeconds`, `statistics`, schemaVersion 3. | |
| "`--project-name`, which also answers to `--name`" | true | `assemble.txt`, `--project-name, --name`. | |

## Front matter

All checks pass.

`chapter_id`, `title`, `audience`, `task`, and `tags` are well formed.
`parameters_refs` names exactly the three registry ids the chapter documents,
`assemble.spades`, `assemble.megahit`, `assemble.skesa`, matching roster row 47.
`tools: [spades, megahit, skesa]` agrees. `fixtures_refs: [human-mito]` points
at a fixture that exists and ships `expected/spades`.

`entry_points` lists the three menu items and the CLI command, matching DRIFT
changed-claim 1 and the registry entry points.

`prereqs` are all real files. `glossary_refs` lists twenty-two anchors and I
spot-checked the two the author added plus `contig`, `n50`, and `l50`. All
resolve. `de-bruijn-graph` is at `GLOSSARY.md:151` and `error-correction` at
`:183`, both correctly placed alphabetically.

`shots` declares four ids and the body carries four markers, one to one, in
the same order. `illustrations` and `features_refs` are empty, which is
consistent with the campaign's use of `features.yaml` as last resort.
`brand_reviewed: false` and `lead_approved: false` are correct at this stage.

### The four shot captions

| Shot | Verdict |
|---|---|
| `assembly-wizard-spades` | Accurate. Inputs rows, Assembler and Read Type at the top of Primary Settings, Isolate profile, and the Readiness panel at the bottom all exist and sit where the caption says. `AssemblyWizardSheet.swift:474-490, 494-524, 526-540, 645-700`. |
| `assembly-advanced-settings` | Accurate. The Curated extra arguments disclosure holds Careful mode, then Skip error correction, then the catalog descriptions, then the Extra arguments field. The caption's "above the Extra arguments field" is right; note the catalog descriptions sit between them, which the caption does not mention and does not need to. |
| `assembly-viewport` | Accurate but carries the wall-time question only indirectly. The strip does report one contig, 16697 total bp, and N50 16697 bp above the contig table. The caption wisely quotes no wall time. |
| `contig-detail-pane` | Accurate. Header, length, GC percent, rank, share, sequence, in that order, per `AssemblyContigDetailPane.swift:264-273`. This is the DRIFT-mandated respecification of the old `contig-inspector`. |

## Settings coverage against parameters.yaml

The chapter documents thirteen Settings entries. The three registry entries
between them define eleven distinct labels. The count differs because the
chapter splits Profile into a SPAdes entry and a MEGAHIT entry, and because
Output Folder is a chapter entry with no registry `settings` row of its own
(it is covered by the `output-location` catalog id and the registry `notes`).

Coverage is complete. Every registry setting on all three entries appears.

| Registry label | spades | megahit | skesa | Chapter entry |
|---|---|---|---|---|
| Assembler | yes | yes | yes | **Assembler** |
| Read Type | yes | yes | yes | **Read Type** |
| Profile | yes | yes | absent | **Profile** and **Profile (MEGAHIT)** |
| Threads | yes | yes | yes | **Threads** |
| Memory Limit | yes | yes | yes | **Memory Limit** |
| Min Contig | yes | yes | yes | **Min Contig** |
| Careful mode | yes | absent | absent | **Careful mode** |
| Skip error correction | yes | absent | absent | **Skip error correction** |
| Extra arguments | yes | yes | yes | **Extra arguments** |
| Project Name | yes | yes | yes | **Project Name** |
| Run Mode | yes | yes | yes | **Run Mode** |

Two notes for the editor rather than defects.

The Settings lead says "eleven controls for SPAdes", which is right, and then
documents thirteen entries. A reader counting entries will not arrive at
eleven. The lead already explains that some controls appear only for certain
assemblers, so the gap is explicable, but a half-sentence would close it.

The registry's `assemble.skesa` entry has no Profile row and the chapter says
SKESA has no presets. Consistent. The chapter's SKESA `--min_count` note lives
inside the Extra arguments entry rather than as a setting of its own, which is
right, because it is not a control.

Every `cli_flag` value in the chapter matches the registry. The two null-flag
settings (Careful mode, Skip error correction) and the two null-flag entries
(Output Folder, Run Mode) are all described as having no flag, correctly.

## Consistency

Checked against `CONSISTENCY.md` and against `01-when-to-assemble.md`.

Menu forms, folder conventions, and panel names all conform. "Tools > Assembly
> SPAdes..." matches the per-tool submenu ruling at `CONSISTENCY.md:21-25`.
The `Analyses/<tool>-<timestamp>/` claim matches `:58-60`. Operations Panel
and Plugin Manager shortcuts match `:33-35`. "Lungfish Genome Explorer (LGE)"
appears at first mention in the What it is section and "LGE" thereafter.

Three figures must agree with the concept chapter. Two do.

**SPAdes 16,697 agrees.** `01-when-to-assemble.md:112` and this chapter both
give one contig of 16,697 bases, N50 16,697, L50 1, 44.4% GC.

**SKESA 16,570 agrees.** Both give one contig of 16,570 bases, 44.4% GC, 1.6
seconds, and the `[topology=circular]` header.

**SPAdes wall time does not agree.** This chapter says 110.7 seconds in three
places (Before you start, the summary-strip reading, and the comparison
table). `01-when-to-assemble.md:112` says 13.7 seconds. The committed fixture
at `fixtures/human-mito/expected/spades/assembly-result.json` records
13.719936966896057 and `fixtures/human-mito/README.md:96` says 13.7 seconds.

Both numbers are honest. I compared the two recorded command lines and they
are identical but for input paths, both `spades.py --isolate ... --threads 14`,
and the statistics blocks are byte-identical. The difference is machine load,
not settings. The author's run happened to land while other campaign work was
running. The fixture's 13.7s is the committed, reproducible figure and the one
the sibling chapter and the fixture README already carry, so the fixture
should win. This is a cross-chapter conflict the editor must settle, not a
false claim by this author.

The MEGAHIT conflict is treated in its own section below.

## App defects

The three the author reports are all real and all confirmed against source.

**1. Min Contig is silently ignored for SPAdes.** Confirmed.
`AssemblyOptionCatalog.swift:127-133` maps `minimum-contig-length` to SPAdes
with the placeholder string "Lungfish post-filter", and that mapping is what
makes `supportsMinContigLength` true and renders the stepper at
`AssemblyWizardSheet.swift:564-574`. But `buildSpadesCommand`
(`ManagedAssemblyPipeline.swift:178-209`) never reads `minContigLength`, and no
post-filter runs, so `AssemblyOutputNormalizer` computes statistics from the
unfiltered `contigs.fasta`. The control is editable and inert. The chapter
documents this as a limitation and says so plainly.

**2. MEGAHIT's Threads slider is overridden without telling the user.**
Confirmed. `AssemblyRunRequest.swift:100-106` caps the count at 2 whenever
`tool == .megahit && host.capsMegahitThreads`, and
`ManagedAssemblyPipeline.swift:234-237` appends `--no-hw-accel`. Nothing in
the sheet says so. Reproduced in all five of my runs.

**3. The locked Run Mode caption carries a semicolon.**
Confirmed. `AssemblyWizardSheet.swift:170`, "Combining multiple bundles into
one assembly run is not yet supported; each bundle assembles separately."
A manual problem, not a user problem, and the chapter correctly paraphrases.

### New defect

**4. MEGAHIT 1.2.9 crashes nondeterministically on Apple Silicon even with
both shipped workarounds applied.** This is more serious than defect 2 and is
not recorded anywhere I could find, including the reality map and
`parameters.yaml`. Five fresh runs, four failures. The crash lands at a
different k value each time and with two different signals. The existing
2-thread cap plus `--no-hw-accel` reduces the rate but does not fix it, and
the code comment at `AssemblyRunRequest.swift:101` ("crashes reliably above
two threads") reads as though two threads is safe, which my runs contradict.

Worth raising with engineering. From a manual point of view it means any
MEGAHIT figure in any chapter is a lucky run, and both assembly chapters need
to say the tool is unreliable on this platform.

## MEGAHIT conflict

The two authors reported opposite outcomes. Both are right. MEGAHIT 1.2.9 on
this machine is nondeterministic, and neither author's command form nor
settings explain the difference.

### What I checked first

I compared the two authors' recorded runs before running anything. Both
scratchpad directories still hold their outputs. Diffing
`assembly-concept/megahit/options.json` against
`assembly-spades/out-megahit/options.json` returns three lines, all of them
paths. Identical thread count, identical k list `21,29,39,59,79,99,119,141`,
identical `--no-hw-accel`, identical memory figure, identical everything else.
The concept run aborted with `Exit code -6` at k=99 after "Tips removal done".
The other completed all eight k steps in 2.04 seconds. So the settings
hypothesis was dead before I ran a command.

### What I ran

Binary `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
five fresh runs into
`.../scratchpad/fidelity-megahit/`, three in the concept author's exact
command form and two in this author's.

Concept author's form, runs 1 to 3.

```
lungfish-cli assemble --assembler megahit --read-type illumina-short-reads \
  --paired --output <scratch>/run<N> --project-name t<N> \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R1.fastq.gz \
  docs/user-manual/fixtures/human-mito/HG002.chrM_R2.fastq.gz
```

This chapter's author's form, runs 4 and 5.

```
lungfish-cli assemble <scratch>/HG002.chrM_R1.fastq.gz <scratch>/HG002.chrM_R2.fastq.gz \
  --paired --assembler megahit --project-name t<N> --output <scratch>/run<N>
```

### What happened

| Run | Command form | Result | Failure point | Signal |
|---|---|---|---|---|
| 1 | concept | failed, exit 64 | `count` step, k=21 | -11 (SIGSEGV) |
| 2 | concept | failed, exit 64 | `assemble` step, k=119 | -6 (SIGABRT) |
| 3 | concept | failed, exit 64 | `assemble` step, k=79 | -6 (SIGABRT) |
| 4 | this chapter's | failed, exit 64 | `assemble` step, k=59 | -11 (SIGSEGV) |
| 5 | this chapter's | **completed, exit 0** | | |

Four failures in five, at four different k values, under two different
signals, across both command forms. This chapter's own command form failed
once and succeeded once. The concept author's form failed three times for me
and once for them, four for four.

### The verdict

Both authors are right, and neither figure is settings-dependent. MEGAHIT
1.2.9 on Apple Silicon fails intermittently, roughly four runs in five on this
machine, with the app's 2-thread cap and `--no-hw-accel` both active. The
concept chapter's claim that it "aborts with SIGABRT at k=99" is one instance
of a wider fault, and naming k=99 and SIGABRT specifically is too narrow. This
chapter's MEGAHIT figures came from a genuine successful run.

Run 5 reproduced this chapter's comparison table exactly. `assembly-result.json`
statistics: contigCount 3, totalLengthBP 17405, largestContigBP 16711, n50
16711, l50 1, gcFraction 0.44619362252226374, wallTimeSeconds 2.699275016784668.
Contig headers `k141_0 ... len=332`, `k141_2 ... len=362`, `k141_1 ... len=16711`.
Every figure in the chapter's MEGAHIT row and in the two-short-contigs sentence
is confirmed.

So the chapter's numbers stand as written. What needs adding is a caution that
the run may not complete. And the concept chapter needs its k=99 claim widened.
The two chapters should say the same thing about this, and right now one says
MEGAHIT fails and the other prints its results without warning.

Suggested shared wording, for the editor to place in both.

> MEGAHIT 1.2.9 is unreliable on Apple Silicon. LGE already applies the two
> published workarounds, capping it to two threads and disabling its hardware
> acceleration, and runs still stop partway with a nonzero exit code more often
> than not, at a different stage each time. The figures below come from a run
> that completed. If yours stops, that is the known fault rather than anything
> you did, and rerunning may well succeed. Use SPAdes or SKESA for a
> single-organism sample until it is fixed.

## Notes for the editor

Four things to settle. None is a rewrite.

The SPAdes wall time. Three occurrences of 110.7s in this chapter against 13.7s
in the concept chapter, the fixture JSON, and the fixture README. Same command,
same output, different machine load. I would take the fixture's 13.7s
everywhere, since it is the committed and reproducible figure and two other
files already carry it. Whoever changes it should change all three occurrences
plus the `assembly-viewport` shot caption, which quotes no time and so is safe.

The MEGAHIT reliability caution. Add it here, and widen the concept chapter's
k=99 and SIGABRT to the general fault. The two chapters currently give a reader
opposite impressions of whether MEGAHIT works.

The Threads entry's stated reason. "crashes above that on arm64" repeats the
source comment and implies two threads is safe. It is not. One added clause
fixes it.

The Settings lead's count. "eleven controls for SPAdes" is true and the section
then runs to thirteen entries. A reader may stumble. The lead already explains
why, so this is presentation rather than fact.

Two smaller observations, neither needing action. The Profile (MEGAHIT) entry
says the CLI flag is `--profile`, which is correct for LGE; the underlying
MEGAHIT flag is `--presets`, and the chapter never says otherwise. And the
author's note that the summary strip's "16697" rendering was unobserved is now
settled by `AssemblySummaryStrip.swift:324`, which interpolates the raw Int,
so the unseparated form in the chapter is right.

The author's own "Not verified" list is honest and I found nothing in it that
turned out wrong. The `.lungfishref`-inside-the-run-folder claim remains
source-backed rather than run-backed, since the CLI path does not build the
bundle. A GUI run would settle it, and it is consistent with
`AnalysesFolder.swift` and `AssemblyBundleBuilder.swift`.

## Counts

True 89. False 0. Unverifiable 0. Two true-but-inconsistent claims (the SPAdes
wall time, in three places, and the Threads crash rationale). Four app defects,
three confirmed as reported and one new.
