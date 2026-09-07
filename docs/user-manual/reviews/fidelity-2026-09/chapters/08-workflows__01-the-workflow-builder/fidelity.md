# Fidelity review: 08-workflows/01-the-workflow-builder

Reviewed 2026-09-07 against Preview 2026.9.13, the Swift source in this
worktree, `.build/debug/lungfish-cli` (build dated Sep 6, source dated Sep 5,
so not stale), the author's scratch outputs under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/workflow-builder/`,
and `parameters.yaml` entry `workflow.builder`.

Nine CLI commands were rerun independently. Every GUI claim was checked
against source only, because the author did not drive the app and neither did
this review.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "The Workflow Builder is a window in Lungfish Genome Explorer (LGE)" | true | `WorkflowBuilderViewController.swift`, three-pane `NSSplitViewController` | |
| "There is no command that composes a chain for you" | true | `WorkflowCommand.swift:35-190`, only `builder-run` and `diff` touch builder graphs | |
| "The palette you drag from offers six node types and nothing else" | true | `WorkflowNode.swift:135-138` `isBuilderNativeFASTQNode` returns true for exactly six cases; `WorkflowNodePalette.swift:79-81` filters on it | |
| "The node-type model in the source does define eleven further types across three more categories" | true | `WorkflowNode.swift:13-53` defines 21 cases; 6 native, 2 pinned anchors, 13 others. Eleven of those thirteen sit in Preprocessing, Analysis, Output; the two anchors are Input and Output | The count of eleven excludes the two pinned anchors, which is right, but "three more categories" is only true if Input is not counted. Preprocessing, Analysis, and Output are indeed the three categories the palette never draws |
| "The **Tools > Workflow Builder (Experimental)...** item is added to the menu only when the setting is on" | true | `MainMenu.swift:728-737`, inside `if experimentalFeaturesEnabled` | |
| The two Settings > Advanced caption strings | true | `AdvancedSettingsTab.swift:19-26`, both quoted accurately in substance | |
| "This feature is experimental. Turn on **Show Experimental Features** in **Settings > Advanced** before you look for it." | true | Matches the fixed sentence in CONSISTENCY.md:110-112 verbatim | |
| "The left sidebar holds the project workflow library above the node palette ... The sidebar and the inspector both collapse, and the canvas does not." | true | `WorkflowBuilderViewController.swift:150-165`, `paletteItem.canCollapse = true`, `canvasItem.canCollapse = false`, `inspectorItem.canCollapse = true` | |
| "a list headed **Workflows** with three small buttons ... New workflow, Duplicate workflow, and Delete workflow" | true | `WorkflowLibraryView.swift:98`, `:107-109` | |
| "There is no **File > Save Workflow** item and no Cmd-S binding" | true | No such menu item in `MainMenu.swift`; library save is the only path | |
| "clicking **Run** saves the current drawing into the library before it starts" | true | `WorkflowBuilderViewController.swift:851-861` `ensureWorkflowBundleForRun` calls `saveWorkflowBundle` before the run | |
| New Workflow prompt title, message, prefilled name, and **Create** button | true | `WorkflowBuilderViewController.swift:487-490` | |
| "LGE writes the workflow into the project at `Workflows/Mito read cleanup.lungfishflow`" | true | `WorkflowLibraryStore.swift:47-48`, and confirmed on disk in the scratch project | |
| "Right-clicking a row ... offers **Rename**, **Duplicate**, and **Delete**" | true | `WorkflowLibraryView.swift:190-196` | |
| "Two pinned nodes ... **Sample input** ... and **Project output**" | true | `WorkflowNode.swift:59`, `:74`; `WorkflowGraph.swift` seeds both pinned | |
| "A search field with the placeholder **Filter nodes**" | true | `WorkflowNodePalette.swift:97` | |
| "four category headers, **Input**, **Trimming & Filtering**, **Decontamination**, and **Read Processing**" | true | `NodeCategory` raw values at `WorkflowNode.swift:409-416`; only these four have native members | |
| "Hovering a node shows its name and the data type of each input and output port." | true | `WorkflowNodePalette.swift:380-399` builds exactly that string | |
| The six-row palette table (node, category, input port, output port) | true | Every row matches `WorkflowNode.swift:139-260`. FASTQ Bundle Input has no input port and a Reads (FASTQ Bundle) output; the five operations each take Reads and emit Deduplicated / Trimmed / Filtered / Scrubbed / Merged, all typed FASTQ Bundle | |
| "Merge overlapping pairs takes a plain Reads port typed the same as every other" | true | `WorkflowNode.swift:145-148`, `.fastqBundle` like the rest | |
| The twelve not-offered type names, and the three categories | true | `WorkflowNode.swift:16-51`, `:110-130`. All twelve named, including `Export` | |
| "The Trimming node ... holds a minimum length defaulting to 20 and a qualified quality defaulting to 15" | true | `WorkflowNode.swift:271-297` | |
| "the Quality Control node holds a Fail on QC error switch that is off by default" | true | `WorkflowNode.swift:299-308`, `defaultValue: .boolean(false)` | |
| "The four Analysis types carry only two hidden metadata fields" | true | `WorkflowNode.swift:377-378` returns `workflowBuilderOperationMetadataDefinitions`, both `isHidden: true` | |
| "you drag the whole node rather than a header strip" | true | `WorkflowCanvasView.swift:644` drags on any hit where `isPinned == false` | |
| "select it and press `Delete` or forward delete" | true | `WorkflowCanvasView.swift:1056-1057`, key codes 51 and 117 | |
| "Drag on empty canvas to rubber-band a group ... Nudge the selection one grid step at a time with the arrow keys. Undo and redo work" | true | `WorkflowCanvasView.swift:1038-1047`, `:1058-1066`, `:213-214` and the several `registerUndo` sites | |
| Toolbar Zoom In / Zoom Out tooltips naming Cmd-plus and Cmd-minus, Reset Zoom to 100 percent, Grid and Snap toggles | true | `WorkflowBuilderViewController.swift:1110-1155` | |
| "Running such a graph from the command line produced this exact refusal" plus the branching error text | true | Rerun: `workflow builder-run --workflow branching.json --dry-run` prints the quoted line byte for byte | |
| "a Reads port joins another Reads port and nothing else ... a reference output may feed an assembly input and an assembly output may feed a reference input ... A port typed `Any` ... takes anything" | true | `WorkflowNode.swift:501-512` | |
| "drawing the same connection twice is rejected the same way. So is any connection that would form a loop." | true | `WorkflowGraph.swift:318-332` raises `.duplicateConnection` and `.wouldCreateCycle`; `WorkflowCanvasView.swift:1034-1036` beeps on the throw | |
| "Drawing a connection LGE cannot accept makes it play the system alert sound and drop the line" | true | `WorkflowCanvasView.swift:1036` `NSSound.beep()` | |
| "Start with the input node, whose only control is a **FASTQ bundle** popup" | **false** | `WorkflowNodeInspectorView.swift:111-134`. Every node, the input node included, first gets a header and then a **Label** text field via `addLabelEditor`. The bundle popup and its path control come after | "Start with the input node. Below its **Label** field the inspector shows a **FASTQ bundle** popup listing the bundles in the open project." |
| "Under the popup a path control shows where that resolves to on disk." | true | `WorkflowNodeInspectorView.swift:200-207`, an `NSPathControl` bound to `bundle_path` | |
| "What the node stores is ... the project-relative form `@/Imports/HG002.chrM.lungfishfastq`" | true | `WorkflowNode.swift:266-272` pattern `^@/.+\.lungfishfastq$`; confirmed in the saved `workflow.json` | |
| "Click a node to select it and the right-hand inspector shows that node's form ... Every other node's numbers are already at the values this chapter uses" | **false** | `WorkflowNodeInspectorView.swift:125-131`. `addOperationDialogLauncher` returns true for all five operation node types, because `WorkflowBuilderOperationDialogBridge.availableToolIDs` is non-empty for each of them (`:16-25`), and `addParameterEditors` is called only when that returns false. The eight node parameters therefore never appear as inspector fields. The inspector shows Label, an Operation header naming the tool, the **Configure...** button, a caption, a port summary and a validation summary | "Click a node to select it and the right-hand inspector shows its Label, the tool it runs, and a **Configure...** button. The node's own numbers are not editable in the inspector. Click **Configure...** to open the shared FASTQ/FASTA Operations dialog, set them there, and click Apply to hand them back to the node. The defaults are the values this chapter uses, so a first run needs no changes." |
| "The Settings section below documents all thirteen controls." | **false** | The Settings section has twelve entries, and `parameters.yaml` lists twelve. Nine node settings plus three window controls is twelve | "The Settings section below documents all twelve controls." |
| "Thirteen controls live in this window. Ten belong to individual nodes ... and three are window controls" | **false** | Nine node settings (`FASTQ bundle`, `Detect adapters`, `Quality threshold`, `Window size`, `Cut mode`, `Database`, `Minimum overlap`, `Minimum length`, `Maximum length`) plus three window controls is twelve. The chapter itself then writes twelve paragraphs | "Twelve controls live in this window. Nine belong to individual nodes and three are window controls that belong to no node." |
| "**Configure...** button on the operation nodes, which opens the shared FASTQ/FASTA Operations dialog with an Apply button" | true | `WorkflowNodeInspectorView.swift:239`; `WorkflowBuilderViewController.swift:789-810` passes `primaryActionTitle: "Apply"` | |
| Run validation looks for "an empty drawing, a loop, an input node with nothing wired out of it, a required port with nothing wired into it, an output node with nothing wired into it, and any node parameter it does not recognise or that is required and missing" | true | `WorkflowGraph.swift:521-590`, six checks in that order. A seventh check rejects a non-semver version, which the chapter omits without contradicting | Optionally add the seventh, that a workflow version which is not semantic-version shaped is also refused |
| The **Workflow Not Ready**, **No Active Project**, and **Input Bundle Not Ready** alert titles and their triggers | true | `WorkflowBuilderViewController.swift:353-380` | |
| "A project opened read-only refuses the run rather than writing into it." | true | `WorkflowBuilderViewController.swift:874-887`, alert titled Project Is Open Read Only, reached through `requireWritableProject` | |
| "a small sheet would appear offering a Sample popup, a Project label, and Run and Cancel buttons" | true | `showRunBindingSheet`, `WorkflowBuilderViewController.swift:695-745`, titled Run Workflow | |
| "If several sidebar rows were selected but only one of them seeded that anchor, the sheet says so in a line naming the one it used and how many others it ignored." | true | `preferredSampleSelectionDisclosure` appended to the sheet's informative text, `:718-724` | |
| "the Operations Panel ... shows two rows and not one per node ... both carrying the same run identifier" | true | `WorkflowBuilderRunService.swift:137-146` starts the parent, and the native path starts a second row for the runner. No per-node row is started | |
| "Operations > Show Operations Panel (Cmd-Shift-P)" | unverifiable here | Not in the Workflow Builder sources. Settled by the Operations menu definition in `MainMenu.swift`, which this review did not open, and by the Operations Panel chapter | |
| "Run the saved `.lungfishflow` bundle and each run gets its own folder at `runs/<run-id>/` inside that bundle" | true | `WorkflowCommand.swift:97-105`; confirmed on disk at `runs/AC7F4093-.../` | |
| "Run a bare graph JSON file instead ... the runner ... derives a folder under the project at `Workflow Runs/<run-id>/`" | true | `WorkflowCommand.swift:101-104`; confirmed on disk at `Workflow Runs/9008AAD2-.../` | |
| "Inside that run folder sit three things. `builder-plan.json` ... A `workspace` folder ... An `outputs` folder" | true | Confirmed on disk, exactly those three entries | |
| "The finished bundle ... was `HG002.chrM-mito-read-cleanup.lungfishfastq`" | true | Confirmed on disk | |
| "It records the bundle it came from as `@/Imports/HG002.chrM.lungfishfastq`" | true | `derived.manifest.json` field `parentBundleRelativePath` | |
| "a [lineage] of five entries ... keyed `deduplicate`, `fastpTrim`, `humanReadScrub`, `pairedEndMerge`, and `lengthFilter`, each holding the exact command that produced it" | true | `derived.manifest.json` `lineage`, five entries with those `kind` values, each carrying `toolCommand` | |
| Reference-run table row 1, "Remove PCR duplicates + Adapter + quality trim, fastp 1.3.6, 19,916 in, 9,876 out" | **false** | The fused fastp report at `workspace/HG002.chrM_fused_fastp_report_*.json` gives `before_filtering.total_reads` 19,916 and `after_filtering.total_reads` 19,752. 9,876 is 19,752 halved into pairs, so the row mixes a read count in the "in" column with a pair count in the "out" column | "\| Remove PCR duplicates + Adapter + quality trim \| fastp 1.3.6 \| 19,916 \| 19,752 \|" |
| Reference-run table row 2, "Remove human reads, Deacon 0.16.0, 9,876 in, 159 out" | **false** | `workspace/HG002.chrM_deacon_summary.json` gives `seqs_in` 19,752, `seqs_out` 318, `seqs_removed` 19,434. Both figures are halved | "\| Remove human reads \| Deacon 0.16.0 \| 19,752 \| 318 \|" |
| Reference-run table row 3, "Merge overlapping pairs, fastp 1.3.6, 159 in, 225 out" | **false** | Deacon emitted 318 reads, so the merge step's input is 318 reads (159 pairs). 225 is a literal read count, so the row compares pairs to reads and is what makes merging look like it increased the count | "\| Merge overlapping pairs \| fastp 1.3.6 \| 318 \| 225 \|" and drop the "more reads out than in" paragraph, since 318 to 225 is a decrease |
| Reference-run table row 4, "Remove short reads, seqkit 2.13.0, 225 in, 106 out" | true | The length-filter output `HG002.chrM_lengthfilter.fq.gz` holds 106 records, and 225 is consistent with the merge output | |
| "Deacon removed 9,717 of 9,876 reads, leaving 159." | **false** | Deacon removed 19,434 of 19,752, leaving 318, a 98.4 percent depletion. Each figure is exactly half the truth | "Deacon removed 19,434 of 19,752 reads, leaving 318." |
| "The third row shows more reads out than in, which also looks wrong and is not." | **false** | Follows only from the halving. The real merge step went from 318 reads to 225, a decrease. The paragraph's explanation of read merging is itself correct, but its premise is not | Replace with a sentence noting that merging turns two mates into one sequence, so the count falls while the mean length rises, and keep the merged-plus-unmerged explanation as the reason the fall is not by half |
| "The final bundle held 106 reads over 30,498 bases, a mean read length of 287.7 against the input's 248.4" | true | `derived.manifest.json` `cachedStatistics`, `baseCount` 30,498, `meanReadLength` 287.7169..., and the output FASTQ holds 106 records | |
| "Adjacent steps that both run fastp are fused into one fastp invocation" | **false** | `WorkflowBuilderNativeRunner.swift:432-439` `isFusibleFastpBuilderStep` returns true for `.fastpDedup` and `.fastpTrim` only, and explicitly false for `.fastpMerge`. Merge is never fused with anything, even when adjacent to another fastp step | "Remove PCR duplicates and Adapter + quality trim are fused into one fastp invocation when they sit next to each other. Merge overlapping pairs also runs fastp but is never fused." |
| "ran together as a single command carrying both `--dedup` and `--cut_right`" | true | The fused argv in `derived.manifest.json` reads `fastp -i ... --dedup -A -G -Q -L --detect_adapter_for_pe -q 15 -W 5 --cut_right -w 4 ...` | |
| "the lineage still lists five entries, so nothing about the accounting is lost" | true | Five lineage entries on disk, and the deduplicate and fastpTrim entries carry the identical fused command | |
| "The runner builds the bundle and its provenance file inside a hidden staging folder first and renames that into place only once the provenance has been written, and on any error it deletes both the staging folder and the target." | true | `WorkflowBuilderNativeRunner.swift:99-134`, `:211-214`, staging name is a dot-prefixed `.staging-<uuid>` sibling, `moveItem` on success, both removed on catch | |
| "Per-node status is one of pending, running, succeeded, failed, or skipped, and the run record stores those words as text." | true | `WorkflowBuilderRunRecord.swift:10-16`, a `String`-raw-valued Codable enum | |
| "A run made from the Workflow Builder window writes `run.json` and `provenance.json` into `runs/<run-id>/`" | true | `WorkflowBuilderRunService.swift:161-248` calls `WorkflowBuilderRunStore.write` at every state change | |
| "A run made from the command line writes neither of those two files" | true | `WorkflowCommand.swift:60-63` uses the store only to derive a directory. Confirmed on disk, both run folders hold only `builder-plan.json`, `outputs`, `workspace` | |
| "Every saved chain carries a version such as `1.0.0`, written into the `workflow.json`" | true | `WorkflowGraph` encodes `version`; the scratch `workflow.json` carries `1.0.0` | |
| "Saving also appends a line to `versions/history.json` recording the version, the workflow name, and the time." | true | `WorkflowLibraryStore.swift:222-230`. Not observable in the scratch bundle, whose `versions/` is empty because the author hand-wrote the bundle rather than letting `saveWorkflow` create it | Worth a note to the editor, not a correction |
| "Because clicking Run saves first, running a chain adds a line to that history too" | true | Only for a window run. A CLI `builder-run` does not save, so it adds no history line. The sentence names clicking Run, so it is true as written | Consider adding that a command-line run does not re-save and so adds no history line |
| The three-line `workflow diff` text output | true | Reproduced byte for byte | |
| "Its `--format` option accepts `text`, `json`, and `tsv`, but a defect in 2026.9.13 makes all three print the text form" | true | Reproduced independently. Both `--format json` and `--format tsv` printed the identical three-line text form | |
| "The reference run's fused fastp call read `-q 15 -W 5 --cut_right` and its seqkit call read `-m 50`" | true | Both argv strings in `derived.manifest.json` | |
| "Open the finished bundle's lineage and read the reads-in and reads-out figures in order" | **false** | The five `derived.manifest.json` lineage entries carry only `createdAt`, `kind`, `toolUsed`, `toolVersion`, `toolCommand` and a few per-step parameters. There is no reads-in or reads-out field anywhere in the manifest or in `.lungfish-provenance.json`. The chapter's own counts came from the tool reports left in `workspace/`, not from the lineage | "Read the per-step counts out of the tool reports the run leaves in its `workspace` folder, `<name>_fused_fastp_report_<id>.json` for the fastp steps and `<name>_deacon_summary.json` for the human-read step, and compare them against the finished bundle's own read count." |
| "A bundle with no parent recorded is a bundle whose history stops at itself." | true | `parentBundleRelativePath` is the field, and it is present here | |
| "Open the `workflow.json` and confirm the input node's `bundle_path` begins `@/`." | true | The parameter is named `bundle_path` and the pattern requires the `@/` prefix | |
| "LGE enforces this on run rather than on save, so a chain with a bad path saves quietly and fails later." | true | `saveWorkflow` performs no path check; `explicitFASTQBundleInputURL` and the runner both check at run time | |
| The outside-project refusal text | true | Reproduced byte for byte, path elided in the chapter as stated | |
| "`lungfish-cli workflow list` lists the supported nf-core pipeline rather than the chains saved in your project" | true | Rerun prints two advisory lines about `--nf-core` and exits 0 | |
| "pointing it at a builder graph exits with status 5 and this message" plus the Unsupported format text | true | Rerun: exit 5, message identical | |
| The `--dry-run` command block and "prints the whole executable plan as JSON, which is the same content the runner later writes to `builder-plan.json`" | true | `WorkflowCommand.swift:63-75` encodes the same `WorkflowBuilderExecutablePlan` | |
| "The plan names the graph, the input bundle it resolved, the run directory it would use, a recipe rendering of the chain, and one entry per step carrying the operation, its parameters, and the exact argument list." | true | Plan top-level keys are `argv`, `graphID`, `inputBundleNodeID`, `inputBundleURL`, `projectURL`, `recipe`, `runDirectoryURL`, `steps`, `workflowName`, and each of the five steps carries `operation`, `parameters`, `argv` | |
| The three printed lines of a completed run | true | `WorkflowCommand.swift:92-94`; matches `run1.out` | |
| "Both arguments accept either a `.lungfishflow` folder or a bare graph JSON file." | true | `WorkflowCommand.swift:175-190` accepts a file, or a directory holding `graph.json`, `workflow.json` or `manifest.json` | |
| "The plan's steps each carry an argv beginning `lungfish-cli workflow builder-step run --operation ...`" | true | First step argv confirmed in the dry-run plan | |
| "a save made in the window records an argv beginning `Lungfish \"Tools > Workflow Builder (Experimental)\" Save`" | true | `WorkflowLibraryStore.swift:115` | |
| "`builder-step` is not a subcommand the executable exposes" | true | Absent from `cli-help/workflow.txt` and from `WorkflowCommand.swift`'s subcommand list | |
| "`--threads` ... The default is 4" | true | `WorkflowCommand.swift:53`, and `cli-help/workflow.txt` | |
| "the HG002 mitochondrial reads" as the fixture name | true | Matches CONSISTENCY.md's fixture naming line | |
| "On the reference run that bundle held 19,916 reads, which is 9,958 pairs, with a mean read length of 248.4" | unverifiable | The import bundle's own statistics were not re-read in this review. 19,916 is corroborated as the fastp input count, and 9,958 is its half. Settled by reading `Imports/HG002.chrM.lungfishfastq`'s cached statistics | |
| "fastp, Deacon, and seqkit ... all ship in the Required Setup pack" | unverifiable | Not checked against the tool lock manifest in this review. The three conda envs exist on this machine at `~/.lungfish/conda/envs/{fastp,deacon,seqkit}`. Settled by `third-party-tools-lock.json` | |
| "the Plugin Manager lists under Databases as the Deacon panhuman database" | unverifiable | Not checked. The index resolved at `~/.lungfish/databases/deacon-panhuman/panhuman-1.k31w15.idx`, so the id is right. Settled by the Plugin Manager source | |

## Front matter

`title`, `chapter_id`, `audience`, `task`, and `tags` are all consistent with
the chapter body. `tools: [fastp, deacon, seqkit]` matches the three tools the
worked example actually invoked.

`parameters_refs: [workflow.builder]` is correct and matches the registry id
in the roster. `features_refs` and `illustrations` are empty, which the drift
report flagged as a gap for `parameters_refs` only, and that one is now filled.

`glossary_refs` lists twenty terms. All twenty resolve to anchors in
`GLOSSARY.md`. The three the author says are new,
`directed-acyclic-graph` (line 169), `node-port` (line 399), and
`workflow-bundle` (line 677), are present, in alphabetical order, and
technically accurate. The `workflow-bundle` entry correctly names all four
written files including `provenance.json`, which the chapter body itself never
names.

`fixtures_refs: [human-mito]` matches a real fixture directory holding the two
FASTQ files the chapter names.

`prereqs` point at two chapters that exist. `estimated_reading_min: 26` is
plausible for 5,989 words.

`shots` holds five entries, all with `<!-- SHOT: -->` markers present in the
body and in the same order. Four captions are accurate. The fifth is not, and
it is the same error as the inspector claim above.

- `workflow-builder-experimental-toggle`, accurate.
- `workflow-builder-sidebar-library`, accurate.
- `workflow-builder-palette`, accurate. Names the Filter nodes field and all
  four real headers, which is exactly the drift report's correction.
- `workflow-builder-canvas`, accurate, and correctly avoids implying a
  template generated the chain.
- `workflow-builder-node-inspector`, **false**. "An Adapter + quality trim
  node selected, with its four parameters and the Configure... button in the
  right-hand inspector" cannot be captured, because the inspector renders the
  Configure... button instead of the four parameters, never alongside them.
  Recaption to "An Adapter + quality trim node selected, showing its Label,
  the tool it runs, and the Configure... button in the right-hand inspector."
  The drift report's own note on this shot repeats the same mistake.

`brand_reviewed: false` and `lead_approved: false` are correct for this stage.

## Settings coverage against parameters.yaml

`parameters.yaml` `workflow.builder` declares twelve settings and five
`cli_only` flags. The chapter documents twelve settings and five flags, in the
registry's order, so coverage is complete with nothing invented and nothing
dropped.

Every default, allowed-value set, and bound was checked against
`WorkflowNode.swift:264-380` and all twelve agree with both the registry and
the source.

| Setting | Registry | Source | Chapter |
|---|---|---|---|
| FASTQ bundle | unset, project bundles | `:266-272`, required, pattern `^@/.+\.lungfishfastq$` | agrees |
| Detect adapters | true | `:312-317`, `.boolean(true)` | agrees |
| Quality threshold | 15, 0 to 93 | `:319-326` | agrees |
| Window size | 5, 1 or more | `:328-334` | agrees |
| Cut mode | right; right, front, tail, both | `:336-344` | agrees |
| Database | deacon-panhuman, sole value | `:345-352` | agrees |
| Minimum overlap | 15, 1 or more | `:354-361` | agrees |
| Minimum length | 50, 0 or more | `:363-370` | agrees |
| Maximum length | unset, 1 or more | `:372-377` | agrees |
| Filter nodes | empty, any text | `WorkflowNodePalette.swift:97` | agrees |
| Grid | true | `WorkflowCanvasView.swift:68` | agrees |
| Snap | true | `WorkflowCanvasView.swift:73` | agrees |

The five `cli_only` flags match `cli-help/workflow.txt` and
`WorkflowCommand.swift:41-55` exactly, including the `--threads` default of 4
and the fact that `--workflow` and `--project` are required.

Each of the twelve Settings paragraphs follows the fixed three-sentence shape
and closes with "This setting has no command-line flag", which is correct in
all twelve cases.

The only coverage fault is arithmetic, not omission. The section's lead-in
sentence and the pointer to it in step 5 both say thirteen where the section,
the registry, and the source all say twelve.

The **Remove PCR duplicates** line about having no parameters is accurate
(`WorkflowNode.swift:309-310` returns an empty array) and sits outside the
twelve, which is the right treatment.

## Consistency

The experimental-feature sentence is reproduced word for word from
CONSISTENCY.md:110-112. The fixture is named "the HG002 mitochondrial reads",
which is the required form.

"Lungfish Genome Explorer (LGE)" appears at first mention and "LGE"
thereafter, with no bare "Lungfish" used for the application.

Prose rules hold. No em dashes, no semicolons, no in-sentence colons, and no
list exceeds five items. Numbers are introduced by what they measure before a
good value is named, which the Quality threshold and Minimum length entries do
well.

Against the sibling `02-exporting-as-nextflow-or-snakemake.md`, the two
chapters agree. That chapter's closing paragraph says the Builder's "own
Export menu writes Nextflow and Snakemake through a separate code path from
the provenance export", and this chapter names the same Export menu in step 3.
Neither claims the other's territory. The forward pointer in this chapter's
Next section resolves to both siblings.

`03-running-external-workflows.md` was not compared, per the brief, since it
is still in progress.

## App defects

The author reports five. All five are confirmed, and this review adds a sixth.

1. **`workflow diff --format json` and `--format tsv` print the text form.**
   Confirmed by independent rerun. Both produced the identical three-line text
   output. The switch in `WorkflowCommand.swift:151-166` reads correctly and
   the option is declared with the right values, and the binary (Sep 6)
   postdates the source file (Sep 5), so this is not a stale build. Cause not
   located. The chapter states it, which is right.

2. **A command-line `builder-run` writes no `run.json` and no
   `provenance.json`.** Confirmed. `WorkflowBuilderRunStore.write` is called
   only from `WorkflowBuilderRunService`, the window path. Both scratch run
   directories hold only `builder-plan.json`, `outputs`, and `workspace`. The
   chapter states this plainly rather than glossing it, which is right.

3. **`workflow validate` cannot validate a builder graph.** Confirmed, exit 5
   with "Unsupported format: Unknown workflow format". Arguably by design, and
   the chapter frames it that way while warning the reader off.

4. **`workflow list` does not list saved builder workflows.** Confirmed. It
   exits 0 and prints two advisory lines. The author log records this as
   non-zero, which is wrong, but the chapter makes no exit-code claim so
   nothing needs changing.

5. **The graph JSON encoding is undocumented and non-obvious.** Not
   re-derived, but consistent with Swift's `[UUID: T]` Codable behaviour and
   with `CGPoint`'s two-element array encoding. Correctly kept out of the
   chapter and recorded in the author log.

6. **New. The five operation nodes' parameters are unreachable from the
   inspector.** `WorkflowNodeInspectorView.rebuild` at `:125-131` calls
   `addParameterEditors` only when `addOperationDialogLauncher` returns false,
   and that launcher returns true for every node type with a non-empty
   `availableToolIDs`, which includes all five operation types
   (`WorkflowBuilderOperationDialogBridge.swift:16-25`). So Detect adapters,
   Quality threshold, Window size, Cut mode, Database, Minimum overlap,
   Minimum length and Maximum length are never rendered as inspector fields.
   The only way to change any of them in the window is the **Configure...**
   button and the shared dialog behind it. Eight of the twelve documented
   settings therefore live somewhere other than where the chapter, the shot
   caption, and the drift report all place them. Whether this is a regression
   or the intended design, it needs an app decision, because the inspector
   still renders a port summary and a validation summary that reference
   parameters the user cannot see.

## Notes for the editor

The chapter is careful, well evidenced, and honest about its own limits. Six
things need fixing before it goes on, and four of them are the same mistake in
different clothes.

The reference-run count table is the most damaging problem, because the
chapter builds a whole teaching moment on it. The author halved reads into
pairs for the first two rows and left rows three and four as literal read
counts, so the table silently changes units mid-column. Two consequences
follow. The Deacon sentence understates a 98.4 percent depletion by a factor
of two, and the "more reads out than in" paragraph describes an increase that
did not happen, since the real merge step went from 318 reads to 225. Fix the
table to read 19,916 to 19,752, 19,752 to 318, 318 to 225, and 225 to 106,
correct the Deacon sentence, and rewrite the merging paragraph around a fall
in count with a rise in mean length. The mean-length figures, 248.4 in and
287.7 out, are correct and can carry that paragraph on their own.

The second problem is the inspector. Eight of the twelve settings cannot be
edited where the chapter says they are, and the fifth shot cannot be captured
as captioned. Until an app decision lands on defect 6, the safe wording routes
the reader through **Configure...**, which is what the source supports and
what the chapter already describes one paragraph later. That paragraph and the
step-5 paragraph currently contradict each other, so the fix also removes an
internal inconsistency.

The third is small and mechanical. Thirteen should be twelve in two places,
the Settings lead-in and the pointer to it in step 5. The section itself is
already correct at twelve.

The fourth is the fastp fusion rule. Merge is explicitly excluded from fusion
in the source, so the blanket "any two adjacent fastp steps" claim is wrong.
The author's own log flagged this as unproven and it turns out to be false,
which is a good argument for keeping that section of the log.

The fifth is the "read the reads-in and reads-out figures" instruction in What
good looks like. The lineage carries commands and tool versions, not counts.
Point the reader at the `workspace` tool reports instead, which is where the
chapter's own numbers came from.

Two things worth adding rather than fixing. The chapter says running a chain
adds a line to the version history, which is true of a window run and false of
a command-line run, since the CLI never saves. One clause would settle it. And
the saved bundle holds a fourth file, `provenance.json`, which the glossary
entry names and the chapter body does not, even though the chapter describes
its contents in prose.

Three claims stayed unverifiable and none of them is load-bearing. The
Operations Panel keyboard shortcut, the Required Setup pack membership of the
three tools, and the Plugin Manager's listing of the Deacon database. Each is
settled by a source this review did not open, and each is corroborated
indirectly.

Two notes on the author's method, for the record rather than for the chapter.
The saved `.lungfishflow` bundle in the scratchpad was hand-written rather than
produced by `saveWorkflow`, so its `versions/` folder is empty and it holds no
`provenance.json`. The chapter's claims about both are true of the source but
were never observed on disk. And the author log attributes the count figures to
`hg002-chrm.fastq.gz.lungfish-meta.json`, which holds only ingestion metadata.
They came from `derived.manifest.json` and the `workspace` tool reports.

## Counts

Claims checked: 76. True 66, false 7, unverifiable 3.

False claims are the input node's "only control", the inspector showing node
parameters, "thirteen controls" in two places counted as one claim plus its
step-5 pointer counted as another, three reference-run table rows, the Deacon
removal sentence, the "more reads out than in" premise, the fastp fusion rule,
and the lineage reads-in and reads-out instruction. The fifth shot caption is
counted with the inspector claim it repeats.

Defects: 5 confirmed as reported, 1 new.
