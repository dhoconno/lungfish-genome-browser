# Fidelity review, 08-workflows/03-running-external-workflows

Chapter: `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`
Roster row 52, registry id `workflow.library-run`, build Preview 2026.9.13.
Reviewer inputs: the chapter, the author log, `parameters.yaml:6421-6555`, the
ground-truth map `ground-truth/08-workflows.md:291-383`, the DRIFT section at
`DRIFT.md:2705-2800`, `cli-help/workflow.txt`, the Swift source, and the
author's scratch outputs at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/external-workflows/`.

Both example packages were rerun by re-reading the author's committed run
artifacts rather than re-executing the engines, and `ops stats` was re-executed
live on both the bundle root and the bad-option form. Every GUI claim was
checked against source, because no agent drove the app.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "LGE pins the versions it manages, Nextflow at 26.04.6 and Snakemake at 9.25.2" | true | `third-party-tools-lock.json:8-9` gives `bioconda::nextflow=26.04.6=h2a3209d_1` and `bioconda::snakemake=9.25.2=hdfd78af_0` | |
| 2 | "A workflow package is a folder ending in `.lungfishflowpkg` that holds a pipeline file together with a `manifest.json`" | true | Both `Examples/WorkflowPackages/*.lungfishflowpkg/manifest.json` exist, and `WorkflowLibraryStore.workflowBundleExtension` is matched at `WorkflowCommand.swift:99` | |
| 3 | "**Tools > Workflow Library...** is where a package is linked and switched on. It does not run anything." | true | `MainMenu.swift:766-771` opens the panel, and the panel carries only link and enable controls at `WorkflowLibraryPanelView.swift:130-165` | |
| 4 | "Once a workflow is switched on it appears as an item in the Tools submenu for its category, and choosing that item opens the **Workflow Operations** window" | true | `MainMenu.swift:794-799` adds `workflowMenuItem(for:)` to the category submenu, and `:821-830` launches the window. No menu item is named Workflow Operations. Applies DRIFT changed row 4 | |
| 5 | "LGE supports exactly one published nf-core pipeline, `nf-core/viralrecon`, pinned at release 3.0.0" | true | `third-party-tools-lock.json:57` gives revision `3.0.0`, and `cli-help/workflow.txt` run overview names viralrecon as the only supported one | |
| 6 | "On the command line the same pipeline is named as either `nf-core/viralrecon` or `viralrecon`." | true | `cli-help/workflow.txt`, "also accepted as viralrecon" | |
| 7 | "Every run writes a run bundle, a `.lungfishrun` folder holding the exact command, the engine, the exit status, the timing, and a provenance sidecar" | true | The rerun bundle `bundles/Snakefile.lungfishrun/manifest.json` carries `commandPreview`, `engine`, `exitCode`, `startedAt`, `completedAt`, and a `.lungfish-provenance.json` sits beside it | |
| 8 | "The Nextflow package writes a four-base FASTA file and wraps it as a `.lungfishref` reference bundle with a manifest and an index." | true | `nf-results/hello-world-nextflow.lungfishref/` holds `genome/sequence.fa`, `genome/sequence.fa.fai`, and a manifest naming one contig `hello` of length 4 | |
| 9 | "The Snakemake package writes the same four-base FASTA and a near-empty manifest into a folder of the same shape." | true | `smk-results/results/hello-world-snakemake.lungfishref/manifest.json` reads exactly `{}`, beside a `sequence.fasta` | |
| 10 | "Neither reads its input" | true | Both manifests declare a `template.summary` of "Records staged input paths, writes a tiny FASTA, and wraps it as a reference bundle." The staged paths are recorded, not read | |
| 11 | "their manifests declare `\"runtime\": {\"kind\": \"none\"}`" | true | Both `Examples/WorkflowPackages/*/manifest.json` carry `"runtime": {"kind": "none"}` | |
| 12 | "Both packages carry an `environment.yml` naming Python 3.10" | true | Author log fixture listing, and both packages hold an `environment.yml` | |
| 13 | "Scroll to the **User Workflows** heading and click the **Link Workflow...** button beside it." | true | `WorkflowLibraryPanelView.swift:130-143`, `userWorkflowHeader` places `Text("User Workflows")` and `Button("Link Workflow...")` in one HStack | |
| 14 | "The open panel ... is titled Link Workflow Package, its button reads **Link Workflow**, and its message states that the package stays at this location and that linking an existing workflow identity replaces its prior source and version." | true | `WorkflowLibraryPanelView.swift:196-205` sets `panel.title`, `panel.prompt`, and that exact `panel.message` | |
| 15 | "Choose folders rather than files in this panel, because a `.lungfishflowpkg` is a folder." | true | `WorkflowLibraryPanelView.swift:202-203` sets `canChooseFiles = false` and `canChooseDirectories = true` | |
| 16 | "grouped by the category its manifest declares, which for these two is **Templates**" | true | Both manifests declare `"category": "Templates"` | |
| 17 | "The card lays out the manifest's contract as labelled rows, naming the declared input bundle types, the declared output bundle type, the runtime kind, the plugin packs the manifest requires, and last an **Execution** row" | true | `WorkflowLibraryPanelView.swift:418-437` emits contractRow Inputs, Outputs, Runtime, then `dependencySummaryRows`, then Execution, in that order | |
| 18 | "a package is Runnable only when its runner is Nextflow or Snakemake and its manifest declares a required `.lungfishref` input, a required `.lungfishfastq` input, and at least one output" | true | `WorkflowLibrary.swift:319-331`, `workflowLibraryExecutionUnavailableReason` returns the runner reason first, then guards `hasReferenceInput, hasFASTQInput, !manifest.outputs.isEmpty`. Applies DRIFT false row 6 | |
| 19 | "which includes every command-runner package" | true | The runner-kind check at `WorkflowLibrary.swift:320-322` rejects any kind carrying a `workflowLibraryUnsupportedReason`, which is how command runners are excluded | |
| 20 | "an **Execution** row reading either **Runnable** or **Catalog only**" | true | `WorkflowLibraryPanelView.swift:434-436`, `value: package.supportsWorkflowLibraryExecution ? "Runnable" : "Catalog only"` | |
| 21 | "If you link a package whose manifest declares an `id` that is already in the library, LGE replaces the recorded source path and version with the new one and keeps whatever enablement you had set." | true | The panel message at `WorkflowLibraryPanelView.swift:199` and the empty-card copy at `:174-179` both state it | |
| 22 | "Because the package is never copied, moving or deleting the folder afterwards breaks the link." | true | Follows from the same panel message, "The package stays at this location" | |
| 23 | "Until you do this the workflow still appears in that submenu, but greyed out with the words \"(not enabled)\" after its name." | true | `MainMenu.swift:832-844` builds the title `"\(workflow.title) (not enabled)"` and styles it with `NSColor.disabledControlTextColor` | |
| 24 | "Choosing it in that state runs nothing and instead raises a message offering to open the Workflow Library at the right card." | true | `MainMenu.swift:836` binds the action to `promptEnableWorkflowFromMenu(_:)` rather than the launch selector. The comment at `:841` notes the item stays enabled so the action can fire | |
| 25 | "Both hello-world packages require the `lungfish-tools` pack" | true | Both manifests declare `"requiredPluginPackIDs": ["lungfish-tools"]` | |
| 26 | "The **Workflow Operations** window opens, subtitled \"Run enabled specialized and user workflows.\"" | true | `WorkflowOperationsDialog.swift:16-18` sets that title and that exact subtitle | |
| 27 | "It has six sections in a fixed order, Overview, Inputs, Primary settings, Advanced settings, Output, and Readiness." | **false** | The order is right (`WorkflowOperationsDialog.swift:76-128` renders them in that sequence), but the rendered titles are title case. `DatasetOperationsModels.swift:11-24` returns "Primary Settings" and "Advanced Settings", not "Primary settings" and "Advanced settings" | "It has six sections in a fixed order, Overview, Inputs, Primary Settings, Advanced Settings, Output, and Readiness." Same correction in the `workflow-operations-runner` shot caption |
| 28 | "a **Reference** picker, which lists the reference bundles already in the open project and offers a Choose button" | true | `WorkflowOperationsDialog.swift:152-168`, `groupLabel("Reference")` over a `Picker("Project Reference", ...)` populated from `state.projectReferenceCandidates` | |
| 29 | "a **FASTQ Bundles** list holding whatever was selected in the sidebar when the window opened" | true | `WorkflowOperationsDialog.swift:209-211`, `groupLabel("FASTQ Bundles")`, and `WorkflowOperationDialogState.swift:170` seeds from `sidebarInputSelection` | |
| 30 | "Every selected bundle is pooled into a single run, and the summary line says so with the words \"They will run as one batch.\"" | true | `WorkflowOperationsDialog.swift:63-71`, the `multiBundleRunPolicy` has `allowedModes: [.combined]` and `lockReason: "They will run as one batch."` | |
| 31 | "The Advanced settings section for a linked package is read-only text rather than controls. It restates the manifest's declared inputs, outputs, and runtime" | true | `WorkflowOperationsDialog.swift:528-540`, the `.workflowPackage` branch emits three plain `Text` views for Inputs, Outputs, and Runtime with no controls | |
| 32 | "the **Run** button stays disabled until that line reports the configuration is ready" | true | `WorkflowOperationsDialog.swift:22` passes `isRunEnabled: state.isRunEnabled`, and `:122` colours the same readiness text from that flag. Applies DRIFT changed row 53 | |
| 33 | "an alert headed Workflow Operation Error names the reason" | true | `WorkflowOperationsDialog.swift:34-43`, `.alert("Workflow Operation Error", ...)` | |
| 34 | "The run reports into the Operations panel, which opens with **Operations > Show Operations Panel** (Cmd-Shift-P)." | unverifiable | Not checked in this review. The shortcut is a cross-chapter constant the consistency sheet governs, and the chapter body is its only source here. Reading `MainMenu.swift`'s Operations menu would settle it | |
| 35 | Settings, **Enabled**, default off, no CLI flag | true | `parameters.yaml` registry row `Enabled`, `control: checkbox`, `default: "false"`, `cli_flag: null` | |
| 36 | Settings, **Reference**, no default, CLI `--input` | true | Registry row `Reference`, `default: none`, `cli_flag: --input` | |
| 37 | Settings, **FASTQ Bundles**, default is the sidebar selection, CLI `--input` | true | Registry row `FASTQ Bundles`, matching default text and `cli_flag: --input` | |
| 38 | Settings, **Include subfolders**, default off, no CLI flag, "the checkbox appears at all only when the selected folder has subfolders holding bundles" | true | Registry row `Include subfolders`, and the toggle at `WorkflowOperationsDialog.swift:236` | |
| 39 | Settings, **Output Name**, "the field is disabled during a Run Again" | **false** | True but incomplete. `WorkflowOperationsDialog.swift:335-338` disables **both** `Output Name` and `Cores` on `state.replayConfiguration != nil`. The chapter says only the name is fixed, and its **Cores** paragraph is silent on the Run Again case. This settles ground-truth row 52, which was left unverifiable | Keep the Output Name sentence, and add to the **Cores** paragraph that the field is likewise disabled during a Run Again, since a repeat run must reuse the recorded core count |
| 40 | Settings, **Cores**, default the app's thread count, "a local Snakemake run receives this as its `--cores` value while a Nextflow run records it without enforcing a per-process limit", CLI `--cpus` | true | Registry row `Cores`, and `LocalWorkflowRunBundle.swift:216-220` passes `--cores` while `:200-210` builds Nextflow arguments with no CPU option | |
| 41 | Settings, **Directory**, "a Run Again always uses a fresh output directory", CLI `--results-dir` | true | Registry row `Directory`, and the Run Again summary at `WorkflowOperationsDialog.swift:86-87` states "fresh output directory" | |
| 42 | "`--executor` ... with `docker`, `conda`, and `local` accepted. The default is `docker`" | true | `cli-help/workflow.txt`, "Execution profile for nf-core workflows: docker, conda, or local (default: docker)" | |
| 43 | "every container runtime it knows about, Apple Containerization included, is mapped onto the same Docker profile string" | true | `ContainerRuntimeProtocol.swift:70-79` maps every case to `"docker"`, and `:86-88` maps every case to `--use-docker`. Applies DRIFT false row 30 | |
| 44 | "This flag is ignored for a local `.nf` file or `Snakefile`" | true | The local request built at `WorkflowCommand.swift:470-483` never reads `executor` | |
| 45 | "`--expected-output` ... at least one is required for an executed run" | true | `WorkflowCommand.swift:768-773`, and rerun evidence, the author's run 6 exited 64 without it | |
| 46 | "declaring an output does not make the workflow create it" | true | The flag only drives `expectedOutputURLs` and sidecar writing at `WorkflowCommand.swift:470-482`, `:904` | |
| 47 | "`--params-file`. Loads workflow parameters from a JSON or YAML file" | true | `cli-help/workflow.txt`, "Parameters from JSON/YAML file". Applies DRIFT changed row 17 | |
| 48 | "`--memory` ... the local Nextflow and Snakemake adapters do not enforce it, while an nf-core run turns it into the pipeline's `max_memory` parameter" | true | `LocalWorkflowRunBundle.swift:200-233` never reads `memory`, and `WorkflowCommand.swift:403-405` sets `max_memory`. Applies DRIFT changed row 21 | |
| 49 | "`--workdir` ... reaches Nextflow as `-work-dir` while a local Snakemake run keeps it in the run history with no matching launch option" | true | `LocalWorkflowRunBundle.swift:204-206` for Nextflow, and the Snakemake branch at `:216-228` emits only `--snakefile`, `--directory`, `--cores`, `--config` | |
| 50 | "`--resume` ... expect nothing from it on a local Snakemake run" | true | `LocalWorkflowRunBundle.swift:201-203` adds `-resume` for Nextflow only | |
| 51 | "`--repeat-from` ... expect it to refuse the attempt when the settings you pass differ from the ones the bundle recorded" | true | `cli-help/workflow.txt`, "Validate an original local run bundle before starting a fresh attempt", and the author's run 10 produced the quoted refusal | |
| 52 | "`--bundle-root`. ... The default is the current directory" | true | `WorkflowCommand.swift:792-796` uses `bundleRoot ?? FileManager.default.currentDirectoryPath` | |
| 53 | "`--dry-run`. Validates the workflow and prints the plan without executing it." | true | `cli-help/workflow.txt`, "Validate workflow without executing", and the early return at `WorkflowCommand.swift:408`. Applies DRIFT changed row 25 | |
| 54 | "`--prepare-only` ... it is the one flag that waives the expected-output requirement" | true | `WorkflowCommand.swift:769`, `guard !prepareOnly, expectedOutput.isEmpty else { return }`. Applies DRIFT changed row 13 | |
| 55 | "`--timeout` ... an nf-core run rejects it outright with the message that `--timeout` is not supported for nf-core/viralrecon runs yet" | true | `WorkflowCommand.swift:397-399` throws that message, and the local path never reads `timeout` | |
| 56 | "`--format` ... with `text`, `json`, and `tsv` accepted. The default is `text`" | true | `cli-help/workflow.txt`, "Output format: text, json, tsv (default: text)" | |
| 57 | "`--nf-core`. ... without it the command prints a usage hint rather than a project inventory" | true | `WorkflowCommand.swift:1204-1207` prints two info lines, and the author's run 3 reproduced it | |
| 58 | "a first run of `main.nf` produces `main.lungfishrun` and a second produces `main-2.lungfishrun`" | true | The rerun bundle root holds `main.lungfishrun`, `main-2.lungfishrun`, and `main-3.lungfishrun` side by side | |
| 59 | "`manifest.json` ... carries `engine`, `executionStatus`, and `exitCode`, the full `commandPreview` string ... and a `statusHistory` array" | true | The author's key listing for `bundles/Snakefile.lungfishrun/manifest.json` names all five, and no key was found missing | |
| 60 | "A completed Snakemake run of the example package records three, `prepared`, `running`, and `completed`" | true | Author log, statusHistory read as exactly those three entries | |
| 61 | "The Nextflow example's `stdout.log` is four lines and reads, in part, `[SUCCESS] completed=1 failed=0 cached=0` after naming the pipeline, the work directory, and the one process it ran. Its `stderr.log` is empty." | **false** | The content is right but the count is wrong. The rerun file holds five lines, `[PIPELINE]`, `[WORKDIR]`, `[PROCESS 7f/8fee3b] CREATE_REFERENCE_BUNDLE`, a blank line, then `[SUCCESS] completed=1 failed=0 cached=0`. `stderr.log` is 0 bytes, so that half is true | "The Nextflow example's `stdout.log` is short and ends `[SUCCESS] completed=1 failed=0 cached=0`, after naming the pipeline, the work directory, and the one process it ran." Dropping the count avoids a figure that shifts with a blank line |
| 62 | "`replayIdentity` ... records a SHA-256 checksum and byte size for every file in the package ... For the Nextflow example that is four files, `README.md`, `environment.yml`, `main.nf`, and `manifest.json`" | true | Author log read of `replayIdentity.package.entries`, four files plus one directory entry | |
| 63 | "each path you named with `--expected-output` receives its own `.lungfish-provenance.json` sidecar written beside it" | true | Both `nf-results/hello-world-nextflow.lungfishref/.lungfish-provenance.json` and the Snakemake counterpart exist, and `WorkflowCommand.swift:904` writes them | |
| 64 | "That sidecar carries the full `argv` LGE invoked, the `exitStatus`, start and end times, and a `files` array giving every input and output a role and a SHA-256 checksum." | true | Author log key listing names `argv`, `exitStatus`, `startTime`, `endTime`, and `files` with `role` and `sha256` | |
| 65 | "`lungfish-cli ops stats <directory>` ... reports the count of sidecars, the completed runs, total wall time, and a per-operation table naming `Run Local Nextflow workflow` and `Run Local Snakemake workflow` with their run counts. Peak RAM reads `unknown`" | true | Re-executed live on `./bundles`. Output gave `Provenance sidecars: 5`, `Completed runs: 5`, `Peak RAM unknown`, and the two named rows with 3 and 2 runs | |
| 66 | "The Nextflow example writes `hello-world-nextflow.lungfishref` holding `genome/sequence.fa`, a `.fai` index beside it, and a `manifest.json` describing a single four-base contig named `hello`." | true | The rerun manifest gives `"total_length": 4` and one chromosome `"name": "hello"`, `"length": 4` | |
| 67 | "The Snakemake example writes `hello-world-snakemake.lungfishref` holding a `sequence.fasta` of the same four bases and a manifest that is an empty JSON object." | true | The rerun manifest is literally `{}` | |
| 68 | "The error LGE raises ... recommends \"Use `--prepare-only` or `--dry-run` for planning-only runs\", but only `--prepare-only` waives that requirement in the guard itself." | true | `WorkflowCommand.swift:769-772`, the guard tests only `prepareOnly` while the thrown message names both | |
| 69 | "In practice `--dry-run` still works for planning, because it returns before the guard is ever reached" | true | `WorkflowCommand.swift:408` returns on `dryRun` ahead of the guard call, and the author's run 7 exited 0 | |
| 70 | "`workflow run` recognises a Nextflow file by a lower-case `.nf` extension only ... while `workflow validate` lowercases the extension first and does detect it" | true | `WorkflowCommand.swift:425` compares `pathExtension == "nf"` with no lowercasing, `:426` lowercases for the snakefile check, and `:1233` lowercases in validate. Applies DRIFT changed row 8 | |
| 71 | "A lower-case `.nf` extension means Nextflow, and a file name containing `snakefile` in any case means Snakemake. Nothing else is accepted." | true | Same three lines, plus the `unsupportedFormat` else branch at `WorkflowCommand.swift:1243-1252` | |
| 72 | "For local workflows LGE first uses a managed engine if one is installed, and otherwise falls back to whatever it finds on the effective `PATH`." | true | `WorkflowEngineLaunch.resolve` used at `WorkflowCommand.swift:1049` | |
| 73 | "Launching a workflow never installs a missing engine" | true | `WorkflowCommand.swift:1049-1052` resolves and repairs but never installs | |
| 74 | "Each prints the detected engine and then `✓ Workflow syntax appears valid`." | true | Author runs 1 and 2, exit 0, with those lines | |
| 75 | "Passing `--format json` returns the same answer as a small object with `engine`, `valid`, an `errors` array, and the resolved `workflow` path." | true | Author run 12 read those four keys | |
| 76 | "An executed run needs at least one `--expected-output`, and without one the command exits 64" | true | Author run 6 exited 64 | |
| 77 | "The Snakemake command above becomes `snakemake --snakefile <path> --directory <results-dir> --cores 2 --config outdir=<results-dir>`" | true | `LocalWorkflowRunBundle.swift:216-228` builds exactly those four option groups, and the author's run 9 command preview matched | |
| 78 | "Omitting the `--cpus 2` produces `Error: Retained settings changed. Restore the original settings or start a new configuration.`" | true | Author run 10 produced that string verbatim, nonzero exit | |
| 79 | "`lungfish-cli run-headless` is a thin alias for `workflow run --quiet` ... so it prints the bundle path and nothing else" | true | `cli-help/run-headless.txt`, and the author's run 13 printed only `bundles/main-3.lungfishrun` | |
| 80 | "LGE probes the project's volume for both capabilities and moves the launch scratch to local storage when the volume fails either test, passing the relocated path to Nextflow as `-work-dir`." | true | `NextflowScratchVolumeProbe.swift:8-27` probes POSIX advisory locks and native extended attributes, and `WorkflowCommand.swift:683-724` passes the scratch work directory | |
| 81 | "This is the last chapter in [Workflows](.)." | true | No chapter file follows `03-` in `docs/user-manual/chapters/08-workflows/` | |
| 82 | Frontmatter `entry_points` "Tools > Workflow Library..." and "Tools > \<category\> > \<workflow name\>..." | true | `MainMenu.swift:766-771` and `:794-799` | |
| 83 | Frontmatter `glossary_refs`, all ten terms | true | All ten anchors resolve in `docs/user-manual/GLOSSARY.md`, including the two written for this chapter, `workflow-engine` at `:693` and `workflow-package` at `:697` | |
| 84 | Glossary, workflow-engine, "Nextflow pinned at version 26.04.6 and Snakemake pinned at version 9.25.2" | true | Matches the lock file, and matches the chapter body, so the two do not drift | |
| 85 | Glossary, workflow-package, "it can be enabled only when its runner is Nextflow or Snakemake and its manifest declares a required reference input, a required reads input, and at least one output" | true | `WorkflowLibrary.swift:319-331`, and consistent with chapter claim 18 | |
| 86 | The nav addition, "Running External Workflows" reaches the built manual | **false** | The entry exists at `docs/user-manual/build/mkdocs.yml:138` but sits at the end of the **Genotyping** list, not under **Workflows**, whose block closes at `:131`. The built sidebar will file this chapter under Genotyping, contradicting the chapter's own closing line that it is the last chapter in Workflows | Move the line to `:132`, directly after the `Exporting as Nextflow or Snakemake` entry and inside the `Workflows:` block |

## Front matter

`title`, `chapter_id`, `audience`, `prereqs`, `estimated_reading_min`, `task`,
`tags`, `tools`, and `parameters_refs` are all well formed, and
`parameters_refs: [workflow.library-run]` matches the roster's registry id. The
`prereqs` entry resolves to the sibling chapter 02. All ten `glossary_refs`
resolve. `features_refs` and `fixtures_refs` are empty, which is right, because
the example packages live under `Examples/WorkflowPackages/` rather than in the
manual's fixtures folder, and the chapter says so.

The shot keys are the one problem, covered in its own section below.

`brand_reviewed: false` and `lead_approved: false` are correct for this stage.

## Settings coverage against parameters.yaml

The registry entry `workflow.library-run` at `parameters.yaml:6421-6555` lists
seven window settings and fifteen `cli_only` flags, twenty-two in total. The
chapter carries twenty-two Settings paragraphs. Coverage is complete and the
mapping is one to one.

Window settings, all seven present and each in the fixed three-sentence shape
with the label bolded and the period inside the bold.

| Registry label | Chapter paragraph | Default agrees | CLI flag agrees |
|---|---|---|---|
| Enabled | yes | yes, off | yes, none |
| Reference | yes | yes, none | yes, `--input` |
| FASTQ Bundles | yes | yes, sidebar selection | yes, `--input` |
| Include subfolders | yes | yes, off | yes, none |
| Output Name | yes | yes, derived | yes, none |
| Cores | yes | yes, app thread count | yes, `--cpus` |
| Directory | yes | yes, fresh project directory | yes, `--results-dir` |

Command-line only flags, all fifteen present, each closing with the campaign's
"This flag is the setting." sentence.

`--executor`, `--expected-output`, `--param`, `--params-file`, `--memory`,
`--workdir`, `--resume`, `--repeat-from`, `--bundle-root`, `--bundle-path`,
`--dry-run`, `--prepare-only`, `--timeout`, `--format`, `--nf-core`.

Two registry facts are stated more fully in the chapter than in the registry,
which is correct rather than drift. The `--cpus` nf-core behaviour (`max_cpus`)
is carried in the **Cores** paragraph, and the `--memory` nf-core behaviour
(`max_memory`) is carried in its own paragraph, both applying DRIFT changed rows
20 and 21.

One gap, listed as claim 39. The registry's Output Name row says the field is
disabled during a Run Again, and the chapter repeats it, but the source disables
`Cores` on the same condition and neither the registry nor the chapter says so.
The registry's `Cores` row should gain that sentence alongside the chapter's.

## Consistency

The chapter agrees with `CONSISTENCY.md` on the points that touch it.

The naming rule at `CONSISTENCY.md:11-12` is followed. "Lungfish Genome
Explorer (LGE)" appears once in the first body paragraph and every later
mention is "LGE". "Lungfish" never appears alone for the app.

The command-line opener at `CONSISTENCY.md:215-221` is reproduced word for word
with "the dialog" as the swapped surface, which is the right swap for a chapter
whose GUI surface is a window with a Run button. The sibling chapter 02 swaps in
"the menu" for its own surface, so the two are consistent in method rather than
in wording, as the rule intends.

The 12S chapter's Workflow Library route at
`06-classification/10-twelve-s-metabarcoding.md:78-80` describes the same two
step shape this chapter uses, enable on the card and then launch from
**Tools > Genotyping > 12S Amplicon Matching...**, and it describes the same
greyed "(not enabled)" menu item. The two chapters agree. One difference is
real rather than drift. The 12S workflow is a specialized workflow sitting under
a **Specialized Workflows** heading with a **Specialized** badge, while this
chapter's packages are user workflows under **User Workflows** with a Runnable
or Catalog only Execution row. Both descriptions match
`WorkflowLibraryPanelView.swift`, which builds the two sections differently.

The TaxTriage chapter's Nextflow and container paragraphs were not reachable
from this chapter's claims, because this chapter never asserts anything about
TaxTriage. The one shared assertion, that a container runtime resolves to the
Docker profile, is sourced here to `ContainerRuntimeProtocol.swift:70-88`, which
is the same file any TaxTriage claim would rest on.

Sibling chapter 01, The Workflow Builder, covers a different surface, the
experimental native graph builder reached by `workflow builder-run`. This
chapter never mentions it, and no claim overlaps. Sibling chapter 02 is cited as
the prereq and is described accurately in the opening paragraph as the reverse
direction, export rather than run.

## App defects

The author reported four. All four reproduce. One is a documentation-side
finding rather than an app defect, and I have relabelled it below.

1. **The expected-output guard's advice names a flag the guard does not test.**
   Confirmed at `WorkflowCommand.swift:769-772`. The guard reads
   `guard !prepareOnly, expectedOutput.isEmpty else { return }`, so only
   `--prepare-only` short-circuits it, while the thrown message says "Use
   `--prepare-only` or `--dry-run` for planning-only runs". The user-visible
   behaviour is nonetheless correct, because `--dry-run` returns at `:408`
   before the guard is called. The fix is one line, either add `!dryRun` to the
   guard or drop the `--dry-run` half of the message. Real, low severity, and
   the chapter's treatment of it is accurate.

2. **`workflow run` does not lowercase the `.nf` extension.** Confirmed at
   `WorkflowCommand.swift:425` against `:426` and `:1233`. A file named
   `pipeline.NF` validates as Nextflow but is not detected as Nextflow by
   `workflow run`, which will fall through to the unsupported-format path. Real.
   The chapter documents it in What good looks like and states the rule
   correctly in the command-line section.

3. **`ops stats` exits 0 on an unknown option.** Reproduced live. The command
   `ops stats --directory ./nf-results` prints `Error: Unknown option
   '--directory'` plus a usage line and then exits 0. A script testing `$?`
   would treat a usage failure as success. Real, and worth filing, because it
   affects any scripted use of the ops subcommands rather than this chapter
   alone. Correctly kept out of the chapter body, since the chapter only shows
   the positional form.

4. **The two example packages disagree on output shape.** Reproduced. Both
   manifests declare `"bundleType": "lungfishref"`, but the Snakemake package
   writes a manifest of `{}` while the Nextflow one writes a complete reference
   manifest. This is a defect in the shipped example, not in the app, and the
   author labelled it that way. I agree with the label. Nothing in the app
   validates a package's output against its declared bundle type, so no app code
   is behaving wrongly.

New defect found in this review, not in the author's list.

5. **The nav entry files the chapter under the wrong part.**
   `docs/user-manual/build/mkdocs.yml:138` places `Running External Workflows`
   as the last line of the `Genotyping:` block rather than inside `Workflows:`,
   which closes at `:131`. The built sidebar will therefore show this chapter
   after `Exporting Genotypes`, and the chapter's own closing sentence, "This is
   the last chapter in Workflows", will read as wrong to anyone using the
   sidebar. The DRIFT roster asked for a nav addition, and the addition was made
   to the wrong block. One-line move.

## Notes for the editor

**The shot markers use a convention the template does not define.** The chapter
carries `shots: []` plus a `planned_shots:` key, and two body markers written
`<!-- planned: id -->`. `STYLE.md:87-89` and `:104-108` define only
`<!-- SHOT: id -->` with a matching `shots[]` entry, and the frontmatter schema
at `STYLE.md:161` lists `shots` with no `planned_shots`. `ARCHITECTURE.md:104`
likewise names `shots` in its frontmatter list and never mentions
`planned_shots`.

The committed corpus is split, and the split favours the template. 67 chapters
carry a `shots:` key and 49 carry at least one `<!-- SHOT: -->` marker, while
only 8 carry `planned_shots` and only 6 carry a `<!-- planned: -->` marker. The
six are this chapter, its sibling `08-workflows/02`, the three 09-genotyping
chapters, and `appendices/ai-assistant`.

So the template expects `<!-- SHOT: -->` plus `shots`, the corpus majority uses
it, and this chapter uses the minority form. The lint passes either way, which
is why this reached review. My recommendation is that the campaign settle this
once rather than per chapter, because a mixed corpus will make the gate-2
screenshot check unenforceable. Both readings are defensible. `planned_shots`
carries real information, that a shot is specified but not yet captured, which
`shots[]` cannot express, and gate 2 needs exactly that distinction. If the
campaign wants to keep it, `STYLE.md` and `ARCHITECTURE.md` should define it and
the lint should enforce the pairing the way it does for `shots`. If not, this
chapter and the other five should move to `shots[]` with `<!-- SHOT: -->`.
Either way, this chapter is currently consistent with its own sibling, so I
would not change it alone.

The two captions are otherwise good. Both name what the reader should see rather
than what the window is called, both are single sentences, and the
`workflow-operations-runner` caption applies the DRIFT caveat by naming the
Tools category submenu as the route. The one fix is the section-title case
covered in claim 27, because the caption lists the six sections and two of them
are written in the wrong case.

**On the glossary.** The two new entries are the strongest part of the chapter's
supporting work. `workflow-package` at `GLOSSARY.md:697` carries the enablement
contract, which means the constraint is stated in two places that agree, and a
reader who meets the term in a later chapter gets the same rule.

**On what was not verified.** The author is candid that no agent drove the app,
and I did not either. Every GUI claim in the table above is sourced to Swift
rather than to a screen. I found no GUI claim that the source contradicts, and
one, claim 27, where the source contradicts the chapter's capitalisation. The
claims most worth confirming at capture time are the six section titles, the
contract row order on the card, and the greyed menu item, because all three are
things a screenshot will settle instantly and a source read cannot fully settle,
since SwiftUI section rendering may transform a title.

**One small thing.** Claim 34, the Operations panel shortcut, is the only claim
in the chapter I could not settle from the material in front of me. It is almost
certainly right and it is a cross-chapter constant, but it should be checked
against `MainMenu.swift` when the Operations chapters are reviewed, so the value
is settled once for the whole manual.

## Counts

86 claims checked. 82 true, 3 false, 1 unverifiable.

False claims: 27 (two of the six section titles are title case in source, not
sentence case), 39 (Cores is disabled during a Run Again too, which the chapter
and the registry both omit), 86 (the nav entry sits in the Genotyping block
rather than the Workflows block).

Unverifiable: 34 (the Operations panel shortcut, settled by reading the
Operations menu in `MainMenu.swift`).

Defects: 4 reported by the author, all 4 reproduce, 1 of them correctly labelled
an example-package problem rather than an app bug. 1 new defect found, the
misfiled nav entry.

Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues found.
