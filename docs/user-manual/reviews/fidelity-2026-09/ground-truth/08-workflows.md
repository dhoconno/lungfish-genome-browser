# Reality map: 08-workflows

Chapters covered: `docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md`,
`docs/user-manual/chapters/08-workflows/02-exporting-as-nextflow-or-snakemake.md`,
`docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`.

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift`
- `Sources/LungfishApp/App/AppDelegate+ImportExport.swift`
- `Sources/LungfishApp/App/AppFilePanelFactory.swift`
- `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift`
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowBuilderViewController.swift`
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowNodePalette.swift`
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowCanvasView.swift`
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowNodeInspectorView.swift`
- `Sources/LungfishApp/Views/WorkflowLibrary/WorkflowLibraryPanelView.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift`
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsWindowController.swift`
- `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift`
- `Sources/LungfishApp/Services/WorkflowLibrary.swift`
- `Sources/LungfishApp/Services/WorkflowBuilderRunService.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowNode.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowGraph.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowLibraryStore.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowBuilderPlanCompiler.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowBuilderNativeRunner.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowBuilderRunRecord.swift`
- `Sources/LungfishWorkflow/Builder/WorkflowGraphDiff.swift`
- `Sources/LungfishWorkflow/Builder/VSP2WorkflowTemplate.swift`
- `Sources/LungfishWorkflow/Recipes/RecipeEngine.swift`
- `Sources/LungfishWorkflow/Resources/Recipes/vsp2.recipe.json`
- `Sources/LungfishWorkflow/Provenance/ProvenanceExporter.swift`
- `Sources/LungfishWorkflow/Engines/ContainerRuntimeProtocol.swift`
- `Sources/LungfishWorkflow/nf-core/NFCoreSupportedWorkflowCatalog.swift`
- `Sources/LungfishWorkflow/LocalWorkflowRunBundle.swift`
- `Sources/LungfishWorkflow/Native/NextflowScratchVolumeProbe.swift`
- `Sources/LungfishCLI/Commands/WorkflowCommand.swift`
- `Sources/LungfishCLI/Commands/WorkflowEngineLaunch.swift`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/workflow.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/provenance.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/conda.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/bundle.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/run-headless.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/ops.txt`
- `docs/user-manual/features.yaml`
- `Examples/WorkflowPackages/`

Cross-cutting findings that shape several verdicts below.

1. The palette does not contain every `WorkflowNodeType`. `WorkflowNodePalette.buildDataModel` at `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowNodePalette.swift:79` iterates `WorkflowNodeType.allCases where nodeType.isBuilderNativeFASTQNode`. `isBuilderNativeFASTQNode` at `Sources/LungfishWorkflow/Builder/WorkflowNode.swift:131-138` is true for exactly six types, so the palette shows six entries in four categories.
2. There is no `File > Save Workflow` menu item and no Cmd-S binding for the Builder. Saving is reachable through the sidebar library actions and through the automatic save that precedes a run.
3. In production the run service uses the `.graph` executor, which for a FASTQ bundle graph starts one extra Operations row titled `Workflow Builder Runner`, not one row per node.
4. Chapter 03 names a "Tools > Workflow Library…" entry point correctly, but "Workflow Operations" is a window reached by launching an enabled workflow from a Tools category submenu, not a menu item of its own.

## 01-the-workflow-builder.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Choose **Tools > Workflow Builder (Experimental)…** from the menu bar." | true | `MainMenu.swift:729-734` adds `Workflow Builder (Experimental)…` to the Tools menu | |
| 2 | entry_points front matter "Tools > Workflow Builder (Experimental)…" | true | `MainMenu.swift:730` | |
| 3 | "The menu item is labelled **Workflow Builder (Experimental)** for a reason" | true | `MainMenu.swift:730` | |
| 4 | (implied throughout, never stated) the Builder appears unconditionally | false | `MainMenu.swift:728` guards the item with `if experimentalFeaturesEnabled`; the toggle is `Show Experimental Features` at `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift:16` | Add to the Procedure: the item appears only after you turn on Show Experimental Features in Settings > Advanced. Without that setting the Tools menu has no Workflow Builder entry. |
| 5 | "A new window opens showing three panes: an operation palette on the left, a canvas in the middle, and an inspector on the right." | changed | `WorkflowBuilderViewController.swift:143-162` adds three split items, but the leading item is `WorkflowBuilderSidebarViewController`, which holds a project workflow library list above the node palette (`WorkflowBuilderViewController.swift:1230-1232`) | "A new window opens showing three panes. The left sidebar holds the project workflow library above the node palette, the canvas is in the middle, and the node inspector is on the right." |
| 6 | "The canvas starts empty except for a faint grid and two pinned nodes labelled **Sample input** and **Project output**." | true | `WorkflowGraph.swift:119-143` seeds both anchors; `WorkflowCanvasView.swift:296-340` draws the grid | |
| 7 | "These two nodes are not draggable." | true | `WorkflowNode.swift:713-720`, `isDraggable` is `!isPinned` and both anchors are pinned | |
| 8 | "a native FASTQ graph uses an explicit **FASTQ Bundle Input** node that you drag on yourself, while the pinned **Sample input** anchor is a legacy path that prompts for a sample at run time" | true | `WorkflowBuilderViewController.swift:369-387` takes the explicit-bundle path when any `.fastqBundleInput` node exists, otherwise calls `showRunBindingSheet` | |
| 9 | "The palette groups operations into seven categories: **Input**, **Preprocessing**, **Trimming & Filtering**, **Decontamination**, **Read Processing**, **Analysis**, and **Output**." | false | The seven names are the `NodeCategory` cases at `WorkflowNode.swift:410-417`, but `WorkflowNodePalette.swift:79-87` only builds a category when it has at least one `isBuilderNativeFASTQNode` member, so only Input, Trimming & Filtering, Decontamination, and Read Processing ever appear | "The palette shows four category headers: **Input**, **Trimming & Filtering**, **Decontamination**, and **Read Processing**. The node type model defines three more categories (Preprocessing, Analysis, Output), but no node in those categories is offered in the palette." |
| 10 | "Click a category header to expand or collapse its contents." | true | `WorkflowNodePalette.swift:224-226` marks categories expandable; `:151-154` expands them by default | |
| 11 | "Hovering a node shows a one-line description." | false | The tooltip helper at `WorkflowNodePalette.swift:367-400` builds a multi-line string listing the node name, its input ports and their data types, and its output ports and their data types | "Hovering a node shows its name and the data type of each input and output port." |
| 12 | "The five runnable FASTQ operations live in Trimming & Filtering, Decontamination, and Read Processing; the Analysis category holds the export-only nodes." | false | The first half is right (`WorkflowNode.swift:116-121`), the second half is not, because Analysis nodes are filtered out of the palette at `WorkflowNodePalette.swift:79` | "The five runnable FASTQ operations live in Trimming & Filtering, Decontamination, and Read Processing. Nothing else is offered." |
| 13 | (undocumented palette control) the palette has no search field | false | `WorkflowNodePalette.swift:94-103` adds an `NSSearchField` with the placeholder `Filter nodes` and filters by display name at `:166-192` | Add to the Procedure: a **Filter nodes** search field sits above the palette and narrows the list by node name as you type. |
| 14 | "Click and hold any palette entry, drag it onto the canvas, and release." | true | `WorkflowNodePalette.swift:126` sets the dragging source mask and `:230-240` writes the node type to the pasteboard | |
| 15 | "You can move a placed node at any time by dragging its header." | changed | `WorkflowCanvasView.swift:911` and `:926` gate dragging on `node.isDraggable`, which is the whole node, not a header hit region | "You can move a placed node at any time by dragging it. The two pinned anchors cannot be moved." |
| 16 | "To delete a node, select it and press `Delete` or `Backspace`." | changed | `WorkflowCanvasView.swift:1054-1057` handles key codes 51 (Delete) and 117 (Forward Delete); `WorkflowNode.swift:723-725` makes pinned anchors unremovable | "To delete a node, select it and press `Delete` or forward delete. The two pinned anchors cannot be deleted." |
| 17 | "A port connects only to another port of the same data type" | true | `PortDataType.isCompatible(with:)` at `WorkflowNode.swift:501-512` returns `self == other` after the two special cases | |
| 18 | "There is one exception, a reference output may feed an assembly input and an assembly output may feed a reference input" | true | `WorkflowNode.swift:505-510` | |
| 19 | "A port typed `Any` (such as the **Project output** input) accepts anything." | true | `WorkflowNode.swift:502-504`; the `projectOutput` input port is typed `.any` at `WorkflowNode.swift:180-183` | |
| 20 | "If you attempt any other incompatible edge, Lungfish plays the system alert sound and the connection is dropped." | true | `WorkflowCanvasView.swift:1033-1036` calls `NSSound.beep()` in the failure branch of `createConnection` | |
| 21 | "Ports are fixed per node type and always visible. There is no collapsing drawer of optional inputs." | true | `inputPorts` and `outputPorts` at `WorkflowNode.swift:141-263` are computed constants per case, and the node view has no disclosure control | |
| 22 | "The generic Alignment node, for example, shows a reads port and a reference port side by side, and the generic Variant Calling node shows an alignments port and a reference port." | changed | The port shapes are right (`WorkflowNode.swift:153-162`), but neither node can be placed from the palette (`WorkflowNodePalette.swift:79`), so the reader can never see this | Remove the example, or move it to a note that these node types exist in saved graphs and in the exporter model but are not offered in the palette. |
| 23 | "To draw an edge, click an output port on one node and drag to an input port on another." | true | `WorkflowCanvasView.swift:1000-1011` accepts output-to-input and input-to-output drags | |
| 24 | "To remove an edge, click it once to select and press `Delete`." | true | `WorkflowCanvasView.swift:702-732` deletes selected connections; `:1054-1057` binds Delete | |
| 25 | "The builder refuses any connection that would create a cycle, so a node can never feed itself, directly or through a loop." | true | `WorkflowGraph.swift:329-332` throws `.wouldCreateCycle` | |
| 26 | (undocumented) duplicate edges are rejected | false | `WorkflowGraph.swift:318-327` throws `.duplicateConnection` for a repeated source-port to target-port pair | Add one sentence: drawing the same edge twice is rejected the same way an incompatible edge is. |
| 27 | "The native FASTQ runner additionally requires a linear chain: each node feeds exactly one downstream node." | true | `WorkflowBuilderPlanCompilerError.nonLinearGraph` at `WorkflowBuilderPlanCompiler.swift:37` and its message at `:52-53`, thrown at `:94`, `:102`, `:112`, `:126`, `:173` | |
| 28 | "A branching graph … is valid in the editor for export purposes but is rejected when you run it natively." | true | `WorkflowGraph.validate()` at `WorkflowGraph.swift:520-575` has no fan-out rule, and the compiler rejects it | |
| 29 | "Click a node to select it. The right-hand inspector swaps to show the node's parameter form" | true | `WorkflowBuilderViewController.swift:134-141` wires the inspector to the selected node | |
| 30 | Parameter table row "Remove PCR duplicates \| none" | true | `WorkflowNode.swift:309-310` returns `[]` for `.fastpDedup` | |
| 31 | Parameter table row "Adapter + quality trim \| Detect adapters (on), Quality threshold (15), Window size (5), Cut mode (right)" | true | `WorkflowNode.swift:311-344` | |
| 32 | (missing from that row) Cut mode's allowed values and the numeric bounds | false | `WorkflowNode.swift:342` sets `allowedValues` to right, front, tail, both; quality is clamped to 0-93 at `:325-326` and window to a minimum of 1 at `:334` | Add the allowed values and ranges to the Settings entries, since the campaign template requires a Settings entry per setting. |
| 33 | Parameter table row "Remove human reads \| Database (deacon-panhuman)" | true | `WorkflowNode.swift:345-353`, and `deacon-panhuman` is the only allowed value at `:352` | |
| 34 | Parameter table row "Merge overlapping pairs \| Minimum overlap (15)" | true | `WorkflowNode.swift:354-362` | |
| 35 | Parameter table row "Remove short reads \| Minimum length (50), Maximum length (unset)" | true | `WorkflowNode.swift:363-379`, where `maxLength` has no default value | |
| 36 | "The generic Analysis export nodes (Alignment, Variant Calling, Quantification, Assembly) do not expose scientific parameters … They carry only two hidden metadata fields" | changed | `WorkflowNode.swift:380-381` returns exactly the two hidden definitions at `:387-404`, so the fact is right, but the reader can never place these nodes | Keep the fact and re-frame it as a note about saved graphs rather than about something the reader can select in the palette. |
| 37 | "When you save a workflow, every parameter you set on every node travels with it." | true | `WorkflowLibraryStore.saveWorkflow` at `:94-105` encodes the whole `WorkflowGraph`, and `WorkflowNode` carries `parameters` | |
| 38 | "choose an existing `.lungfishfastq` bundle in the active project and the node stores a project-relative path such as `@/Imports/Sample.lungfishfastq`" | true | The `bundle_path` definition at `WorkflowNode.swift:268-277` pins the pattern `^@/.+\.lungfishfastq$`, and the inspector offers a popup of project bundles at `WorkflowNodeInspectorView.swift:175-206` | |
| 39 | "The builder rejects bundle paths that point outside the project root" | changed | The rejection happens at run time in the compiler (`WorkflowBuilderPlanCompiler.swift:256-269`, `inputBundleOutsideProject`) and in the run guard at `WorkflowBuilderViewController.swift:823-838`, not at save time | "Lungfish rejects a bundle path that points outside the project root when you run the workflow. Saving does not check the path." |
| 40 | "The table below lists the node types that exist in the palette" | false | Of the seventeen rows only six exist in the palette (`WorkflowNodePalette.swift:79`, `WorkflowNode.swift:131-138`) | "The table below lists the six node types the palette offers. A saved graph can also hold node types that came from an earlier version or from the CLI, listed after them." |
| 41 | Node table row "FASTQ Bundle Input \| Input \| project `.lungfishfastq` \| FASTQ reads \| input" | true | `WorkflowNode.swift:62`, `:112-113`, `:194-197`, `:268-277` | |
| 42 | Node table row "FASTQ Input \| Input \| FASTQ file \| FASTQ reads \| input" | changed | The type exists (`WorkflowNode.swift:61`, `:194-197`) but is not in the palette, since `isBuilderNativeFASTQNode` is false at `WorkflowNode.swift:135` | Move to a separate table of node types not offered in the palette. |
| 43 | Node table row "FASTA Input \| Input \| FASTA file \| reference bundle \| input" | changed | Exists at `WorkflowNode.swift:63`, `:198-201`, and is not in the palette | Same as row 42. |
| 44 | Node table row "BAM Input \| Input \| BAM/CRAM file \| alignments \| input" | changed | Exists at `WorkflowNode.swift:64`, `:202-205`, and is not in the palette | Same as row 42. |
| 45 | Node table row "Sample Sheet \| Input \| CSV/TSV \| per-row metadata \| input" | false | Exists at `WorkflowNode.swift:65`, but its output port is `Samples` typed `.fastqBundle` at `:206-209`, not per-row metadata, and it is not in the palette | If retained at all, describe the output as a FASTQ Bundle port and mark the node as not offered in the palette. |
| 46 | Node table rows "Remove PCR duplicates", "Adapter + quality trim", "Remove short reads" as Trimming & Filtering, runnable | true | `WorkflowNode.swift:116-117`, `:131-134` | |
| 47 | Node table row "Remove human reads \| Decontamination \| … \| yes" | true | `WorkflowNode.swift:118-119`, `:133` | |
| 48 | Node table row "Merge overlapping pairs \| Read Processing \| paired FASTQ reads \| merged FASTQ reads \| yes" | changed | Category and runnability are right (`WorkflowNode.swift:120-121`, `:133`), but the input port is a plain `Reads` port typed FASTQ Bundle at `:145-148`, with no paired-only typing | Describe both ports as FASTQ Bundle and say separately that the underlying fastp merge step needs paired input. |
| 49 | Node table rows "Quality Control" and "Trimming" as Preprocessing, export-only | changed | Both exist (`WorkflowNode.swift:114-115`) and are excluded from the palette (`:135`) | Move to the not-offered table. Note that `Trimming` does carry two real parameters, minimum length default 20 and qualified quality default 15 (`WorkflowNode.swift:278-298`), which contradicts the chapter's blanket claim that export nodes carry only hidden metadata. |
| 50 | Node table rows "Alignment", "Variant Calling", "Quantification", "Assembly" as Analysis, export-only | changed | Ports match `WorkflowNode.swift:153-171` and `:239-255`, but none is in the palette | Move to the not-offered table. |
| 51 | Node table row "Report \| Output \| report inputs \| report file \| export-only" | changed | Exists at `WorkflowNode.swift:49`, `:172-175`, `:256-259`, and is not in the palette | Move to the not-offered table. |
| 52 | (missing from the node table) the `Export` node type | false | `WorkflowNode.swift:51`, `:78`, `:176-179` define an `Export` node in the Output category | Either list it with the other not-offered types or say the table is limited to the palette. |
| 53 | "There is no download node, no primer-trim node, no annotation node, and no phylogenetics node in the palette." | true | The palette holds only the six `isBuilderNativeFASTQNode` types (`WorkflowNode.swift:131-138`) | |
| 54 | "Choose **File > Save Workflow** or press `Cmd-S`." | false | No File menu item and no key equivalent exists for saving a workflow. `MainMenu.swift` has no such item, and `WorkflowBuilderViewController.validateMenuItem` at `:1358-1367` handles only undo, redo, and delete. Saving happens through the sidebar library actions and automatically before a run (`ensureWorkflowBundleForRun` at `:853-863`) | "Use the workflow library in the left sidebar to create, rename, duplicate, or delete a workflow in the active project. Clicking **Run** saves the current graph into the project library before it starts, so a workflow you run is always a saved workflow." |
| 55 | "The first save prompts for a name and writes the workflow to the active project at `Workflows/<name>.lungfishflow`." | changed | `WorkflowLibraryStore.workflowsDirectoryName` is `Workflows` at `:48` and the extension is `lungfishflow` at `:49`, so the path is right, but the prompt comes from the library sidebar create action rather than a save command | "New workflows are created from the sidebar and land in the project at `Workflows/<name>.lungfishflow`." |
| 56 | "The saved bundle includes the node graph, every parameter value, the tool versions in use at save time, and a provenance entry recording who saved the workflow and when." | changed | `WorkflowLibraryStore.saveWorkflow` at `:94-138` writes the graph twice, appends the version history, and writes a `WorkflowLibraryProvenance` whose `toolVersion` is the Lungfish app version (`:110`), not per-tool versions, and whose fields are a save timestamp and argv, with no user identity | "The saved bundle holds the node graph with every parameter value, a version-history entry, and a provenance record naming the Lungfish version, the save time, and the checksum of each written file." |
| 57 | "A **FASTQ Bundle Input** node stores only the project-relative `@/...` path" | true | `WorkflowNode.swift:276` pattern, and `WorkflowBuilderViewController.swift:812-820` resolves `@/` against the project | |
| 58 | "Every saved `.lungfishflow` carries a semver-style workflow version such as `1.0.0` or `1.1.0`." | true | `WorkflowGraph` decodes `version` through `WorkflowVersion.normalized` at `WorkflowGraph.swift:157` | |
| 59 | "The version is written into the saved `workflow.json` inside the bundle" | true | `WorkflowLibraryStore.swift:51` names `workflow.json` and `:105-106` writes the encoded graph to it | |
| 60 | "and is shown in the Workflow Builder window subtitle after a graph load or a version change" | changed | `updateWindowTitle()` at `WorkflowBuilderViewController.swift:990-996` sets the subtitle to name plus `v<version>`, but `viewWillAppear` at `:99-103` sets the subtitle to the name alone, so the version appears only after a load, save, or new-workflow action | "The window subtitle shows the workflow name, and after the first load or save it shows the version alongside it." |
| 61 | "Lungfish also appends a small `versions/history.json` entry with the version, workflow name, and save time." | true | `appendWorkflowVersionHistory` at `WorkflowLibraryStore.swift:222-235` appends a `WorkflowVersionHistoryEntry(version:savedAt:workflowName:)` | |
| 62 | `lungfish workflow diff Workflows/vsp2-fastq-v1.lungfishflow Workflows/vsp2-fastq-v1.1.lungfishflow` | true | `cli-help/workflow.txt` banner `==== workflow diff ====`, `USAGE: lungfish-cli workflow diff <first> <second> [--format <format>]` | |
| 63 | "The text output names version changes, added or removed nodes, changed node parameters, and connection changes." | true | `WorkflowGraphDiff.swift:35`, `:44-47`, `:56-59`, `:70-71` | |
| 64 | "add `--format json` to emit the same comparison as machine-readable JSON" | true | `cli-help/workflow.txt` diff options list values text, json, tsv, and `WorkflowCommand.swift:154-158` encodes the JSON report | |
| 65 | (missing) `--format tsv` on `workflow diff` | false | `WorkflowCommand.swift:159-166` prints a field-value TSV | Mention tsv alongside json, or say the format flag takes text, json, or tsv. |
| 66 | "Click the **Run** button in the toolbar." | true | `WorkflowBuilderViewController.swift:1098-1104` builds a toolbar item labelled `Run` bound to `runWorkflow(_:)` | |
| 67 | "the saved bundle path on that node is the workflow input and the run starts immediately after validation" | true | `WorkflowBuilderViewController.swift:346-387`, validation first then the explicit-bundle branch | |
| 68 | "If the graph instead uses the legacy pinned **Sample input** anchor, a small sheet appears asking you to bind that input to a real sample in the current project." | true | `showRunBindingSheet` at `WorkflowBuilderViewController.swift:696-745`, a sheet with a Sample popup, a Project label, and Run and Cancel buttons | |
| 69 | "In both cases, **Project output** binds to the active project." | true | `WorkflowBuilderRunBinding` at `WorkflowBuilderRunRecord.swift:18-26` binds project as the output role | |
| 70 | "Each run is written under `runs/<run-id>/` inside the `.lungfishflow` bundle." | true | `WorkflowBuilderRunStore.runDirectory` at `WorkflowBuilderRunRecord.swift:156-161` | |
| 71 | "The run record includes timestamps, a graph checksum, the sample and project bindings, per-node status, error state, and run-level reproducibility provenance." | true | `WorkflowBuilderRunRecord` fields at `:106-118` | |
| 72 | "Per-node status is one of running, succeeded, failed, or skipped" | false | `WorkflowBuilderNodeRunStatus` at `WorkflowBuilderRunRecord.swift:10-16` has five cases, and the fifth is `pending`, which is the initial value written for every node at `:41` | "Per-node status is one of pending, running, succeeded, failed, or skipped." |
| 73 | "written as text in the record (the Operations Panel shows the same words, not a colour cue alone)" | changed | The record stores the raw string, since the enum is `String`-backed at `:10`, but the Operations Panel does not show node statuses at all for a native run, because no per-node row is created | Drop the Operations Panel half of the sentence. |
| 74 | "The Operations Panel receives a parent workflow row and one child row per node, all carrying the same durable run id" | false | The production initialiser selects `.graph` mode (`WorkflowBuilderRunService.swift:86-92`). In `.graph` mode only a parent row is started at `:137` and, for a FASTQ bundle graph, one further row titled `Workflow Builder Runner` at `:323-331`. Per-node rows exist only in the `.nodes` mode, which is reached solely by the test-only initialiser at `:94-97` | "The Operations Panel receives a parent row named after the workflow and one row for the runner itself, both carrying the same run id, so you can watch progress while working elsewhere in the app." |
| 75 | "The first failing node marks the run failed and leaves every downstream node in the `skipped` state for inspection." | changed | In `.graph` mode `markUnfinishedNodesSkipped(in:except:)` at `WorkflowBuilderRunService.swift:190` marks every unfinished node skipped, and the failing node is guessed from the error or defaults to the first node at `:186` | "A failure marks the run failed, records the failing node when it can be identified, and leaves every unfinished node in the `skipped` state." |
| 76 | `lungfish-cli workflow builder-run --workflow … --project … --run-directory …` | true | `cli-help/workflow.txt` banner `==== workflow builder-run ====` | |
| 77 | "The real flags are `--workflow`, `--project`, `--run-directory`, `--threads`, and `--dry-run`." | true | Same banner, options list | |
| 78 | (missing) the `--threads` default | false | `cli-help/workflow.txt` builder-run options gives `--threads` a default of 4, and the runner signature defaults to 4 at `WorkflowBuilderNativeRunner.swift:71` | State the default of 4 threads. |
| 79 | "command lines recorded inside a provenance file (for example, argv beginning `workflow builder-run --graph-id …` or `workflow builder-step run …`) are audit records, not user-invocable commands" | changed | The GUI does record a non-invocable argv, but its shape is `Lungfish`, `Tools > Workflow Builder (Experimental)`, `run`, path, `--sample`, `--project`, `--run-id` (`WorkflowBuilderRunService.swift:124-134`) and, for saves, `Lungfish`, `Tools > Workflow Builder (Experimental)`, `Save` (`WorkflowLibraryStore.swift:113-114`). No `--graph-id` or `builder-step` argv exists anywhere in the source | Replace the invented argv examples with the real ones, for example an argv beginning `Lungfish "Tools > Workflow Builder (Experimental)" run`. |
| 80 | "The runner writes `builder-plan.json`, native tool provenance, the derived `.lungfishfastq` bundle, and `.lungfish-provenance.json` inside that output bundle." | true | `WorkflowBuilderNativeRunner.swift:80-81` writes `builder-plan.json`, and `:98-131` publishes the derived bundle with `ProvenanceRecorder.provenanceFilename` inside it | |
| 81 | "This is the one graph the native runner executes end to end." | true | `WorkflowBuilderPlanCompiler.swift:272-276` rejects any node that is not one of the five supported operation types | |
| 82 | "Choose **Tools > Workflow Builder (Experimental)…** and create a new workflow in the project library." | true | Sidebar create action wired at `WorkflowBuilderViewController.swift:117-119` and `createWorkflowInLibrary` | |
| 83 | Worked-example node order "Remove PCR duplicates, Adapter + quality trim, Remove human reads, Merge overlapping pairs, Remove short reads" | true | `Sources/LungfishWorkflow/Resources/Recipes/vsp2.recipe.json` steps, in that order | |
| 84 | "The default parameters mirror the VSP2 FASTQ recipe: adapter detection on, quality threshold `15`, window size `5`, Deacon database `deacon-panhuman`, merge minimum overlap `15`, and minimum length `50`." | true | `vsp2.recipe.json` step params match the node defaults at `WorkflowNode.swift:311-379` | |
| 85 | "Lungfish ships a built-in VSP2 template that generates the same chain programmatically … so two people who start from the template get byte-for-byte the same graph." | changed | `VSP2WorkflowTemplate.makeGraph` exists with stable node UUIDs at `Sources/LungfishWorkflow/Builder/VSP2WorkflowTemplate.swift:37-77`, but a repository-wide search finds it referenced only from tests. No GUI control, CLI subcommand, or menu item creates a graph from it | "A built-in VSP2 template exists in the code and produces this chain with stable node identifiers, but no menu item or command exposes it yet. Build the chain by hand." |
| 86 | "Save the workflow as `vsp2-fastq` and click **Run**." | changed | There is no save command, see claim 54 | "Name the workflow `vsp2-fastq` in the library sidebar and click **Run**." |
| 87 | "It compiles the connected graph into a native FASTQ plan, runs the operations, and writes a derived `.lungfishfastq` bundle under the run's `outputs/` folder." | true | `WorkflowBuilderNativeRunner.swift:73-81` compiles and writes the plan, and `availableOutputBundleURL` at `:194-199` places the bundle under `runDirectoryURL/outputs/` | |
| 88 | "The derived bundle records the input bundle as its parent and carries lineage entries for duplicate removal, trimming, human-read removal, merging, and length filtering." | true | `WorkflowBuilderNativeRunner.swift:299-311` sets `parentBundleRelativePath` and appends the derivative operations to the source lineage | |
| 89 | "Adjacent fastp-backed steps … are fused into a single fastp invocation for provenance accounting." | true | `Sources/LungfishWorkflow/Recipes/RecipeEngine.swift:25-26` and `:139-177` fuse consecutive fastp-fusible steps into one `.fusedFastp` entry | |
| 90 | "A successful workflow run leaves three things in your project: the output artefact …, one Operations Panel row per node with its full provenance, and a `runs/` folder …" | false | The middle item is wrong for the same reason as claim 74 | "A successful run leaves the derived `.lungfishfastq` bundle, a parent and a runner row in the Operations Panel, and a `runs/<run-id>/` folder inside the workflow bundle." |
| 91 | "If you ran the workflow three times against three bundles, you have three entries under `runs/` and three output bundles; the workflow file itself is unchanged." | changed | Each run gets its own `runs/<uuid>/` directory (`WorkflowBuilderRunRecord.swift:156-161`) and its own output bundle (`WorkflowBuilderNativeRunner.swift:194-206`), but `ensureWorkflowBundleForRun` at `WorkflowBuilderViewController.swift:853-863` re-saves the graph on every run, which rewrites `workflow.json` and appends a `versions/history.json` entry | "Each run adds an entry under `runs/` and an output bundle. Running also re-saves the graph, so `versions/history.json` gains one line per run." |
| 92 | "The runner writes the derived bundle and its `.lungfish-provenance.json` into a hidden staging bundle first, then renames the staging bundle into place only after provenance has been written." | true | `WorkflowBuilderNativeRunner.swift:99-131`, with the staging name prefixed by a dot at `:211-215` | |
| 93 | "On any error it deletes both the staging bundle and the target." | true | `WorkflowBuilderNativeRunner.swift:132-136` | |
| 94 | "the Operations Panel marks that row's status `failed` and leaves the downstream nodes `skipped`" | false | Same as claims 74 and 75, no downstream node rows exist | "Lungfish marks the run failed in the Operations Panel and records the skipped nodes in `run.json`." |
| 95 | "Inspect the generated `runs/<run-id>/run.json` and `runs/<run-id>/provenance.json` files" | true | `WorkflowBuilderRunRecord.swift:152-153` and `:162-176` | |
| 96 | "The builder refuses to save a **FASTQ Bundle Input** node whose path points outside the project root, with an error that names the offending value." | false | Saving performs no path check (`WorkflowLibraryStore.saveWorkflow` at `:93-138`). The refusal happens on run, in the compiler at `WorkflowBuilderPlanCompiler.swift:256-269` and in the GUI guard at `WorkflowBuilderViewController.swift:823-838` | "Lungfish refuses to run a workflow whose FASTQ Bundle Input node points outside the project root, with an error that names the offending path. Saving does not check." |
| 97 | "Continue to [Exporting as Nextflow or Snakemake] … to share a completed run with collaborators" | true | The next chapter exists at the cited path | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Show Experimental Features setting that gates the whole menu item | `MainMenu.swift:728`, `AdvancedSettingsTab.swift:16` |
| The project workflow library in the left sidebar, with create, rename, duplicate, and delete | `WorkflowBuilderViewController.swift:114-127`, `:588-630` |
| The palette Filter nodes search field | `WorkflowNodePalette.swift:94-103`, `:166-192` |
| The Builder's own toolbar Export menu, with Export to Nextflow and Export to Snakemake | `WorkflowBuilderViewController.swift:1160-1170`, `:1200-1207` |
| Zoom In, Zoom Out, and Reset Zoom toolbar items and their Cmd-plus and Cmd-minus tooltips | `WorkflowBuilderViewController.swift:1107-1135` |
| The Grid and Snap toolbar toggles | `WorkflowBuilderViewController.swift:1137-1155`, `:979-986` |
| The toggle-sidebar toolbar item and the collapsible inspector | `WorkflowBuilderViewController.swift:1062`, `:145-158` |
| Undo and Redo on the canvas | `WorkflowBuilderViewController.swift:1358-1376`, `WorkflowCanvasView.swift:1022-1027` |
| Arrow-key nudging of the selection by one grid step | `WorkflowCanvasView.swift:1058-1066` |
| Rubber-band selection of several nodes at once | `WorkflowCanvasView.swift:1038-1047` |
| The Configure operation button in the inspector, which opens the shared FASTQ Operations dialog with an Apply button | `WorkflowBuilderViewController.swift:789-810`, `WorkflowNodeInspectorView.swift:35` |
| The graph validation issues that block a run, listed in a Workflow Not Ready alert | `WorkflowBuilderViewController.swift:346-354`, `WorkflowGraph.swift:520-575` |
| The No Active Project alert when no project is open | `WorkflowBuilderViewController.swift:356-365` |
| The Input Bundle Not Ready alert when the bundle path is unset or unresolvable | `WorkflowBuilderViewController.swift:371-380` |
| The Project Is Open Read Only refusal | `WorkflowBuilderViewController.swift:874-887` |
| The disclosure line when several sidebar items were selected but only one seeded the sample anchor | `WorkflowBuilderViewController.swift:424-434` |
| The unsaved-changes prompt on New Workflow, with Save, Don't Save, and Cancel | `WorkflowBuilderViewController.swift:199-227` |
| The `Trimming` node's real parameters, minimum length 20 and qualified quality 15 | `WorkflowNode.swift:278-298` |
| The `Quality Control` node's Fail on QC error parameter, default off | `WorkflowNode.swift:299-308` |
| The `Export` node type | `WorkflowNode.swift:51`, `:78`, `:176-179` |
| Parameter bounds, quality 0 to 93, window minimum 1, minimum length minimum 0, maximum length minimum 1, minimum overlap minimum 1 | `WorkflowNode.swift:325-326`, `:334`, `:361`, `:370`, `:377` |
| The `--dry-run` mode of `workflow builder-run`, which prints the compiled plan as JSON without running tools | `cli-help/workflow.txt`, builder-run options |
| The CLI's default run directory when `--run-directory` is omitted | `WorkflowCommand.swift:97-105` |
| `workflow diff --format tsv` | `WorkflowCommand.swift:159-166` |
| The `parameters_refs` requirement of the campaign, which this chapter's front matter leaves empty along with `features_refs` and `glossary_refs` | chapter front matter lines 20-23 |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: workflow-builder-palette -->` and planned shot `workflow-builder-palette` | no | Its caption promises "the seven real category headers: Input, Preprocessing, Trimming & Filtering, Decontamination, Read Processing, Analysis, Output". The palette shows four headers. Recaption to the four real headers and add the Filter nodes field. |
| planned shot `workflow-builder-canvas` | yes, with a caveat | The VSP2 chain can be composed by hand, so the shot is capturable, but the caption must not imply the template generated it. |
| `<!-- planned: workflow-builder-node-inspector -->` and planned shot `workflow-builder-node-inspector` | yes | An `Adapter + quality trim` node with its four parameters is real and selectable. Consider also showing the Configure operation button. |
| Missing shot | add one | The left sidebar workflow library is undocumented and unillustrated, yet it is the only way to name or manage a workflow. |
| Missing shot | add one | The Settings > Advanced Show Experimental Features toggle, since without it the chapter's first step fails. |

## 02-exporting-as-nextflow-or-snakemake.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | entry_points "File > Export > Provenance > Nextflow Pipeline" and "… > Snakemake Workflow" | true | `MainMenu.swift:216-274` nests Provenance inside Export inside File, and `ProvenanceExportMenuModel.items` at `:1094-1106` names both | |
| 2 | "the **File > Export > Provenance** submenu re-emits that same work as a runnable artifact" | true | Same evidence | |
| 3 | "The export is built from the provenance records the app keeps for every operation you ran, not from a Workflow Builder graph." | true | `AppDelegate+ImportExport.swift:52-88` resolves a provenance envelope, never a graph | |
| 4 | "You never had to build a workflow in the Builder to export one. Any sequence of operations leaves provenance behind, and that provenance is what the exporter renders." | changed | True in spirit, but the export is scoped to one artifact. `currentProvenanceExportResolution()` at `AppDelegate+ImportExport.swift:90-146` walks the visible viewport candidates and then the sidebar selection, and falls back to the most recent completed run at `:64-70`. It never exports the whole project | "Select the artifact whose history you want. Lungfish exports the provenance chain of the selected or currently displayed artifact, and falls back to the most recent completed run when nothing is selected." |
| 5 | "Six targets are available." | true | `ProvenanceExportMenuModel.items` has six entries at `MainMenu.swift:1082-1117` | |
| 6 | Target table "Shell Script \| `run.sh`, `provenance/`" | true | `ProvenanceExporter.swift:132-135`, `:179-187` | |
| 7 | Target table "Python Script \| `reproduce.py`, `provenance/`" | true | `ProvenanceExporter.swift:136-139` | |
| 8 | Target table "Nextflow Pipeline \| `main.nf`, `nextflow.config`, `containers/manifest.json`, `provenance/`" | true | `ProvenanceExporter.swift:140-157` | |
| 9 | Target table "Snakemake Workflow \| `Snakefile`, `config.yaml`, `provenance/`" | true | `ProvenanceExporter.swift:158-167` | |
| 10 | Target table "Methods Section \| `methods.md`, `provenance/`" | true | `ProvenanceExporter.swift:168-170` | |
| 11 | Target table "Full Provenance (JSON) \| `provenance.json`, `provenance/`" | true | `ProvenanceExporter.swift:171-174` | |
| 12 | "The submenu draws a separator between the first four targets and the last two" | true | `MainMenu.swift:263-268`, `prefix(4)` then a separator then `dropFirst(4)` | |
| 13 | "every one carries a `provenance/` subdirectory of the records copied from the project" | true | `ProvenanceExporter.swift:179-187` creates it unconditionally | |
| 14 | "With the project open, choose **File > Export > Provenance > Nextflow Pipeline**." | changed | The menu path is right, but the step omits selecting the artifact whose provenance you want, and an artifact with no provenance produces a no-provenance alert (`AppDelegate+ImportExport.swift:57-59`) | "Select the artifact whose run you want to export, then choose **File > Export > Provenance > Nextflow Pipeline**." |
| 15 | "In the save dialog, name the export folder `run-nf` and pick a location outside the project … Click **Export**." | false | `AppFilePanelFactory.provenanceExportPanel` at `:162-169` is a plain `NSSavePanel` with the title `Export Provenance`, the message "Choose a folder name for the exported reproducibility package.", and a prefilled name of the form `<artifact>-provenance-<format>`. It has no button named Export, so the default Save button applies | "In the save panel titled Export Provenance, accept or replace the prefilled folder name and choose a location outside the project, then click **Save**." |
| 16 | "Lungfish writes the export folder and reveals it in Finder." | false | `showProvenanceExportCompleteAlert` at `AppDelegate+ImportExport.swift:215-228` shows a Provenance Export Complete alert with OK and Show in Finder, and reveals only if you click the second button | "Lungfish writes the export folder and shows a Provenance Export Complete alert. Click **Show in Finder** to open it." |
| 17 | "Open Terminal in the export folder and run `nextflow run main.nf`." | true | The generated file is `main.nf` at `ProvenanceExporter.swift:141` and it is standard DSL2 at `:999` | |
| 18 | "The generated `main.nf` declares one Nextflow process per recorded provenance step." | changed | Ordinarily true (`ProvenanceExporter.swift:1011-1012`), but a retained-selection replay emits a single `REPLAY_RETAINED_SELECTION` process instead (`:969-987`), and an unavailable replay emits a stub script (`:968`) | Add the qualifier that a run whose steps are byte-copy replays emits one replay process instead. |
| 19 | "Each process carries the exact command line Lungfish recorded for that step, a pinned container reference when one was exported, and a `publishDir` directive pointing at `params.outdir`." | true | `ProvenanceExporter.swift:1022-1026` | |
| 20 | The quoted `nextflow.config` block, `process { errorStrategy = 'terminate' }` and `docker.enabled = true` | changed | `exportNextflowConfig` at `ProvenanceExporter.swift:774-784` also emits `container = null` inside the process block whenever any step recorded a container image | Add the conditional `container = null` line to the quoted block, or say the block is what you get when no step ran in a container. |
| 21 | "There are no `standard` or `slurm` profiles, so do not pass `-profile`." | true | `exportNextflowConfig` emits no `profiles` block | |
| 22 | "To target a specific scheduler you edit `nextflow.config` yourself and add an executor or a profile block." | true | Same evidence, no executor is written | |
| 23 | "The export also writes `containers/manifest.json`, a JSON list of the tool name, version, image, and digest for every step that ran in a container" | true | `exportContainerManifest` at `ProvenanceExporter.swift:787-802`, `ContainerEntry(toolName:toolVersion:image:digest:)` filtered on `step.containerImage != nil` | |
| 24 | "The tool name and version string for steps that ran as recorded operations (for example, a resolved `2.28-r1209` rather than just `minimap2`)." | true | `step.toolName` and `step.toolVersion` are emitted at `ProvenanceExporter.swift:1015` | |
| 25 | "Input file checksums where available" | true | The Python export writes each input's `sha256` at `ProvenanceExporter.swift:916` | |
| 26 | "The Lungfish app version and host in effect when the operations ran." | true | `ProvenanceExporter.swift:992-996` writes app version, host OS, and user into the Nextflow header | |
| 27 | "a reference acquisition that was never captured as its own operation is synthesized into the export with a tool version of `unknown`" | unverifiable | The exporter has `unknown` fallbacks, for example `input.sha256 ?? "unknown"` at `ProvenanceExporter.swift:916`, but I could not locate a synthesized reference-acquisition step. Running an export against a real reference bundle and reading `main.nf` for a step whose version is `unknown` would settle it | |
| 28 | "Remote registry availability for container images" and "The exact host CPU microarchitecture" as limits | true | Both are outside the exporter, which records only what the provenance holds | |
| 29 | "Reads that originated from an SRA download. The export references the accession; it does not bundle the FASTQ." | unverifiable | No SRA-specific branch appears in `ProvenanceExporter.swift`. The statement follows from the exporter never copying input data, but I could not confirm that an accession is referenced by name. Exporting a run seeded by an SRA fetch and reading the emitted parameters would settle it | |
| 30 | `lungfish bundle export <reference>.lungfishref --format container --output reference.oci.tar --plugin-pack read-mapping --plugin-pack variant-calling` | true | `cli-help/bundle.txt:186-197`, the example and the repeated `--plugin-pack` option | |
| 31 | "In builds that cannot invoke Docker or Apple Containers, Lungfish still writes a deterministic OCI layout with `oci-layout`, `index.json`, manifest, config, layer tar, pinned plugin-pack metadata, and `.lungfish-provenance.json`." | unverifiable | The claim is about a fallback path in the bundle container exporter, which is outside the files this map covers. Reading the container export implementation would settle it | |
| 32 | "The Nextflow export's container references then use that image digest instead of resolving tools from a registry at run time." | false | `exportNextflow` writes `container '<image>'` from `step.containerImage` at `ProvenanceExporter.swift:1022-1024`. The digest is recorded in `containers/manifest.json` only (`:787-802`), and nothing rewrites the process container reference to a digest or to a local OCI tarball | "The digest of each image is recorded in `containers/manifest.json` so an auditor can check which image produced each output. The `main.nf` process still names the image by its recorded reference, so pointing a run at a local tarball means editing the config yourself." |
| 33 | `lungfish conda lock --pack read-mapping --output locks/read-mapping-lock.yml` | changed | The subcommand and flags exist (`cli-help/conda.txt:217-224`), but its overview reads "Export a requested environment specification for a plugin pack (not a resolved lock)" and `--output` is described as a "Requested specification JSON output path", so the `.yml` extension misleads | Rename the file in the example to `read-mapping-spec.json` and say the command writes a requested specification. |
| 34 | `lungfish conda install --from-lockfile locks/read-mapping-lock.yml` | false | `cli-help/conda.txt:8-10` states "exact `--from-lockfile` reconstruction is unsupported", and the option help at `:58-60` says requested specifications cannot be installed as resolved locks | Remove the second command, or replace it with `lungfish conda install --pack read-mapping` and say the specification documents the request rather than pinning it. |
| 35 | "The lockfile recreates the same pinned environment before running the workflow." | false | Same evidence as claim 34 | "The specification records which packages were requested. It is documentation of intent, not a pinned reconstruction." |
| 36 | "The collaborator clones the repository, installs Nextflow (`curl -s https://get.nextflow.io \| bash`), and runs `nextflow run main.nf`." | changed | The pipeline runs, but the chapter never says which Nextflow version Lungfish itself pins, which matters when the export uses DSL2 syntax | Name the pinned version. `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` pins Nextflow 26.04.6. |
| 37 | "`main.nf`, `nextflow.config`, `containers/manifest.json`, and `provenance/` are all plain text." | true | All four are written as UTF-8 text or JSON at `ProvenanceExporter.swift:140-187` | |
| 38 | "Because `nextflow.config` enables Docker, the cleanest path on the collaborator's side is to run the recorded container images." | true | `ProvenanceExporter.swift:782` writes `docker.enabled = true` unconditionally | |
| 39 | "The exported `main.nf` exposes inputs at the top of the file as parameters, one per recorded input file." | true | `ProvenanceExporter.swift:1002-1008` iterates `run.primaryInputFiles` | |
| 40 | "The parameter names are derived from the input filenames (each dot becomes an underscore and the name is sanitized)" | true | `ProvenanceExporter.swift:1005`, `sanitize(input.filename.replacingOccurrences(of: ".", with: "_"))` | |
| 41 | The quoted params block including `params.outdir = './results'` | true | `ProvenanceExporter.swift:1006-1008` | |
| 42 | "The Snakemake export uses the same filename-derived keys in `config.yaml`, which a collaborator overrides via `--config`." | true | `exportSnakemakeConfig` at `ProvenanceExporter.swift:809-817` uses the same sanitized key and writes `outdir: results` | |
| 43 | "The shell and Python exports expose inputs as `INPUT_n` variables." | false | The shell export does use `INPUT_1`, `INPUT_2` and so on (`ProvenanceExporter.swift:846`), but the Python export writes a dictionary named `INPUTS` mapping filename to sha256 (`:913-919`) and never defines `INPUT_n` | "The shell export exposes inputs as `INPUT_n` variables. The Python export lists them in an `INPUTS` dictionary keyed by filename, with the recorded checksum as the value." |
| 44 | "The methods-section export does not parameterise anything; it is prose." | true | `exportMethods` at `ProvenanceExporter.swift:1163` onward emits Markdown text only | |
| 45 | "Nextflow's resume semantics also matter when steps are expensive: a failed run restarts from the failed process, not from the beginning." | changed | This is a true statement about Nextflow with `-resume`, but the generated config sets `errorStrategy = 'terminate'` at `:777` and the chapter never tells the reader to pass `-resume` | Say that resume needs `nextflow run main.nf -resume` and that the generated config terminates on the first error. |
| 46 | "Lungfish's Snakemake export is a flat layout: a single `Snakefile` plus a `config.yaml` in the export root, with no `workflow/` directory and no per-rule conda environment files." | true | `ProvenanceExporter.swift:158-167` writes exactly those two files into the export root | |
| 47 | "Per-rule isolation is expressed with `singularity:` directives that reference `docker://<image>`" | true | `exportSnakemake` at `ProvenanceExporter.swift:1146-1150` | |
| 48 | "the intended run command is `snakemake --cores 8 --use-singularity`" | true | `ProvenanceExporter.swift:1106` writes that exact usage comment into the Snakefile header | |
| 49 | "The shell export … each recorded command line is written in order, with `INPUT_n` and `OUTDIR` variables at the top." | true | `ProvenanceExporter.swift:842-859` | |
| 50 | "**Python Script** is the same idea as a portable subprocess driver (`reproduce.py`)" | true | `ProvenanceExporter.swift:905-960` builds a `subprocess.run` driver | |
| 51 | "The methods export emits one Markdown paragraph naming each tool, its resolved version, and the parameters that differed from defaults, in the order the operations ran." | changed | The export is a Markdown document with a `Methods` heading, a `Computational Analysis` subheading, and a leading generated-draft comment (`ProvenanceExporter.swift:1165-1172`), not a bare paragraph, and it includes only successful steps at `:1177` | "The methods export emits a short Markdown document headed Methods, with a Computational Analysis section naming each successful step's tool and version in the order they ran, above a comment reminding you to read the draft before submitting." |
| 52 | "**Full Provenance (JSON)** emits the raw provenance envelope (`provenance.json`)" | true | `ProvenanceExporter.swift:171-174` encodes the expanded envelope | |
| 53 | "You can run more than one export from the same project. The exports are independent folders and do not overwrite each other." | changed | Independent folders, yes, but the default folder name embeds the format token (`defaultProvenanceExportDirectoryName` at `AppDelegate+ImportExport.swift:189-193`), and an existing non-directory path at the chosen name is rejected at `:164-169` | "The default folder name carries the format, so successive exports of the same artifact do not collide. Exporting onto an existing file, rather than a folder, is refused." |
| 54 | "when a signer is configured, Lungfish cryptographically signs each generated export artifact, writing a `.signature.json` and a `.pub` next to it, and verifies the signature locally" | true | `signReportArtifacts` at `ProvenanceExporter.swift:229-244` signs each generated artifact, collects the signature and public-key URLs, and verifies locally for the local provider | |
| 55 | "When the exporter expands the provenance chain it walks input dependencies, including enclosing `.lungfishref` bundles and their manifests, and copies each discovered record into `provenance/source/…`" | true | `ProvenanceExporter.swift:122-127` expands the chain and `:602` sets the destination root to `provenance/source` | |
| 56 | "This is the last chapter in [Workflows](.)." | false | `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md` follows it | "Continue to Running External Workflows." |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The CLI equivalent `lungfish provenance export <input> --format <shell, python, nextflow, snakemake, methods, json> --output <dir>`, the only way to script an export | `cli-help/provenance.txt`, banner `==== provenance export ====` |
| `lungfish provenance verify`, which checks a signature the chapter tells the reader an auditor will want | `cli-help/provenance.txt`, banner `==== provenance verify ====` |
| `lungfish provenance bibliography`, which generates a citation list and belongs beside the Methods Section target | `cli-help/provenance.txt`, banner `==== provenance bibliography ====` |
| The Provenance Export Complete alert and its Show in Finder button | `AppDelegate+ImportExport.swift:215-228` |
| The prefilled export folder name `<artifact>-provenance-<format>` | `AppDelegate+ImportExport.swift:189-193` |
| The no-provenance alert path when the selection has no recorded history | `AppDelegate+ImportExport.swift:57-59`, `:65-68` |
| The fallback to the most recent completed run when nothing is selected | `AppDelegate+ImportExport.swift:64-70` |
| The export provenance sidecar the exporter writes for the export itself | `ProvenanceExporter.swift:188-197` |
| The retained-selection replay variants of the Nextflow, Snakemake, shell, and Python exports | `ProvenanceExporter.swift:968-987`, `:1086-1095`, `:823`, `:906` |
| That `run.sh` and `reproduce.py` are made executable | `ProvenanceExporter.swift:135`, `:139` |
| The Nextflow version Lungfish pins, 26.04.6, and the Snakemake version, 9.25.2 | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` |
| That the Workflow Builder has its own separate Nextflow and Snakemake exporters, a different code path from provenance export | `Sources/LungfishWorkflow/Builder/NextflowExporter.swift`, `SnakemakeExporter.swift`, reached from `WorkflowBuilderViewController.swift:1160-1170` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: export-provenance-submenu -->` and planned shot `export-provenance-submenu` | yes | Six targets with a separator after the fourth is exactly what `MainMenu.swift:263-268` builds. |
| `<!-- planned: nextflow-export-main-nf -->` and planned shot `nextflow-export-main-nf` | yes, with a caveat | Capture a run whose steps are ordinary operations, not a retained-selection replay, or the file will show one replay process instead of one per step. |
| Missing shot | add one | The Export Provenance save panel, since the corrected step names its title, its message, and its prefilled folder name. |
| Missing shot | add one | The Provenance Export Complete alert with Show in Finder, since the corrected step replaces the false automatic reveal. |

## 03-running-external-workflows.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | entry_points "Tools > Workflow Library…" | true | `MainMenu.swift:766-771` | |
| 2 | entry_points "CLI: lungfish workflow run" | true | `cli-help/workflow.txt`, banner `==== workflow run ====` | |
| 3 | "In the app, **Tools > Workflow Library…** manages workflow availability." | true | `MainMenu.swift:766-771`, and the panel's enable and link controls at `WorkflowLibraryPanelView.swift:130-165` | |
| 4 | "**Workflow Operations** configures enabled specialized workflows and supported imported local packages." | changed | `WorkflowOperationsDialog.swift:16-18` gives the window the title `Workflow Operations` and the subtitle "Run enabled specialized and user workflows.", but no menu item opens it. It is reached by choosing an enabled workflow from a Tools category submenu (`MainMenu.swift:794-799`, `:821-830`) | "Choosing an enabled workflow from its Tools category submenu opens the **Workflow Operations** window, which configures enabled specialized workflows and linked local packages." |
| 5 | (not stated) the Workflow Library is unconditionally available | true | `MainMenu.swift:766-771` sits outside the `experimentalFeaturesEnabled` guard at `:728` | |
| 6 | (not stated) which packages a beta build can enable | false | `WorkflowLibraryPanelView.swift:174-176` tells the reader that in beta builds only Nextflow and Snakemake packages with a reference-plus-FASTQ contract can be enabled, and `WorkflowLibrary.swift:322-329` enforces a required `.lungfishref` input, a required `.lungfishfastq` input, and at least one declared output | Add one sentence: a linked package can be enabled only when its runner is Nextflow or Snakemake and its manifest declares a required reference bundle input, a required FASTQ bundle input, and at least one output. Others are catalogued but not runnable. |
| 7 | "The supported Viral Recon adapter has a separate [Viral Recon Wizard] … The CLI accepts `nf-core/viralrecon` or `viralrecon` for that adapter." | true | `cli-help/workflow.txt` run overview, "The only built-in nf-core workflow supported by this command is nf-core/viralrecon, also accepted as viralrecon", and `NFCoreSupportedWorkflowCatalog.swift:143-160` holds only viralrecon | |
| 8 | "The engine is inferred from the path: a `.nf` extension is treated as Nextflow, and a filename containing `snakefile` (case-insensitive) is treated as Snakemake." | changed | `WorkflowCommand.swift:426` lowercases before the snakefile check, but `:425` compares `workflowURL.pathExtension == "nf"` without lowercasing, so `pipeline.NF` is not recognised as Nextflow by `workflow run`. `workflow validate` does lowercase the extension at `:1233` | "A `.nf` extension in lower case is treated as Nextflow, and a filename containing `snakefile` in any case is treated as Snakemake." |
| 9 | `lungfish workflow run pipeline.nf --results-dir ./example-results --prepare-only` | true | `cli-help/workflow.txt`, run options list both flags | |
| 10 | `lungfish workflow run Snakefile --results-dir ./example-results --prepare-only` | true | Same | |
| 11 | "You must also declare its actual final outputs with `--expected-output <path>`, repeated as needed, so Lungfish can attach provenance." | true | `requireExpectedOutputsForExecution()` at `WorkflowCommand.swift:768-773` throws unless `--prepare-only` is set or at least one is given | |
| 12 | "An output declaration does not make the workflow create that file." | true | The flag only drives `expectedOutputURLs` and sidecar writing at `WorkflowCommand.swift:470-482`, `:904` | |
| 13 | (missing) which planning flag waives the expected-output requirement | changed | The guard at `WorkflowCommand.swift:768-773` reads `guard !prepareOnly, expectedOutput.isEmpty`, so only `--prepare-only` short-circuits it, yet the error message it throws recommends "Use `--prepare-only` or `--dry-run` for planning-only runs" | Say the requirement is waived by `--prepare-only`. Flag the error message's mention of `--dry-run` as a source defect if the intent was to waive both. |
| 14 | "For local workflows, Lungfish first uses an available managed engine, then falls back to its effective `PATH`." | true | `WorkflowEngineLaunch.resolve` is shared by app and CLI, aliased at `Sources/LungfishCLI/Commands/WorkflowEngineLaunch.swift:1-4` and used at `WorkflowCommand.swift:1049` | |
| 15 | "Launching a workflow does not install a missing engine." | true | `WorkflowCommand.swift:1049-1052` resolves and repairs launchers but never installs | |
| 16 | Flag table "`--input <path>` \| Input file for the run; repeat for multiple inputs." | true | `cli-help/workflow.txt`, run options | |
| 17 | Flag table "`--params-file <path>` \| Load parameters from a JSON file." | changed | The help reads "Parameters from JSON/YAML file" | "Load parameters from a JSON or YAML file." |
| 18 | Flag table "`--param key=value` \| Supply a workflow parameter; repeat per parameter." | true | `cli-help/workflow.txt`, run options | |
| 19 | Flag table "`--expected-output <path>` \| A scientific output that should receive a provenance sidecar; repeat per output." | true | Same, plus `WorkflowCommand.swift:876-877` | |
| 20 | Flag table "`--cpus <n>` \| Retained CPU request; passed as `--cores` for local Snakemake. The local Nextflow adapter does not enforce a per-process CPU limit from this field." | changed | Both halves are right (`LocalWorkflowRunBundle.swift:216-220` passes `--cores`, and `:200-210` builds the Nextflow arguments without a CPU option), but the row omits that for an nf-core run `--cpus` becomes the `max_cpus` parameter at `WorkflowCommand.swift:400-402` | Add the nf-core behaviour to the row. |
| 21 | Flag table "`--memory <size>` \| Retained memory request. The local adapters do not enforce a memory ceiling from this field." | changed | Right for local runs (`LocalWorkflowRunBundle.swift:200-233` never uses `memory`), but for nf-core it becomes `max_memory` at `WorkflowCommand.swift:403-405` | Add the nf-core behaviour to the row. |
| 22 | Flag table "`--workdir, -w <dir>` \| Passed as Nextflow `-work-dir`; retained in local Snakemake history without a separate launch option. Engine execution uses the results directory." | true | `LocalWorkflowRunBundle.swift:204-206` for Nextflow and `:216-220` for Snakemake, where `--directory` is the results directory | |
| 23 | Flag table "`--resume` \| Adds Nextflow `-resume`; retained in local Snakemake history without a separate launch option." | true | `LocalWorkflowRunBundle.swift:201-203`, and no resume argument in the Snakemake branch | |
| 24 | Flag table "`--timeout <minutes>` \| Accepted but not enforced by the local runner; rejected for nf-core runs." | true | `WorkflowCommand.swift:397-399` throws "--timeout is not supported for nf-core/viralrecon runs yet", and the local path never reads `timeout` | |
| 25 | Flag table "`--dry-run` \| Print the resolved plan without executing anything." | changed | The help reads "Validate workflow without executing" | "Validate the workflow without executing it." |
| 26 | Flag table "`--prepare-only` \| Create the run bundle and command preview without launching the engine." | true | `cli-help/workflow.txt`, run options, "Create the Lungfish run bundle and command preview without launching Nextflow" | |
| 27 | Flag table "`--results-dir <dir>` \| Output directory for results. Defaults to `./results`." | true | Same options list | |
| 28 | "Two flags are nf-core-only. `--executor` (the `docker`, `conda`, or `local` profile) and `--version` (the pipeline release or tag)" | true | `cli-help/workflow.txt`, run options, "Execution profile for nf-core workflows: docker, conda, or local (default: docker)" and "nf-core workflow version or tag" | |
| 29 | "are ignored when the argument is a local `*.nf` or `Snakefile`, since a local file already carries its own engine configuration" | true | The local request at `WorkflowCommand.swift:470-483` never reads `executor` or `version` | |
| 30 | (not stated) Docker is the only working executor | false | `ContainerRuntimeType.nextflowProfile` at `Sources/LungfishWorkflow/Engines/ContainerRuntimeProtocol.swift:70-79` maps every runtime, Apple Containerization included, to the string `docker`, with the comment "Apple Containerization is Docker-compatible for Nextflow", and `:86-88` maps every runtime to `--use-docker` | Add a sentence: `--executor docker` is the default and the path Lungfish exercises. Apple Containerization is mapped onto the same Docker profile, so a working Docker runtime is what the pipeline actually needs. |
| 31 | "Every run produces a `.lungfishrun` bundle, printed as the final line on completion." | true | `WorkflowCommand.swift:765` prints `runBundleURL.path` after the run | |
| 32 | "By default it is created in the current directory under the workflow's name" | true | `WorkflowCommand.swift:792-796` uses `bundleRoot ?? FileManager.default.currentDirectoryPath` | |
| 33 | "`--bundle-root` chooses a parent directory and `--bundle-path` sets an exact path" | true | `cli-help/workflow.txt`, run options for both flags | |
| 34 | "a `manifest.json` that tracks the run's status history" | true | `WorkflowCommand.swift:866`, `:928`, and the `statusHistory` parameter of `LocalWorkflowRunRequest.manifest` at `LocalWorkflowRunBundle.swift:275-289` | |
| 35 | "a `logs/` folder holding `stdout.log` and `stderr.log`" | true | `WorkflowCommand.swift:589-590`, `:741-742` | |
| 36 | "a provenance record that Lungfish signs when a signer is configured" | true | The signing provider is optional and only signs when configured, `ProvenanceExporter.swift:229-232` | |
| 37 | "When you name `--expected-output` targets, the same provenance envelope is also written as a sidecar next to each of those outputs once the run succeeds." | true | `writeExpectedOutputProvenance(run, to: request.expectedOutputURLs)` at `WorkflowCommand.swift:904` and `:977` | |
| 38 | "`lungfish workflow list --nf-core` prints only the supported Viral Recon pipeline" | true | `WorkflowCommand.swift:1199-1203` prints the single catalog entry, and `NFCoreSupportedWorkflowCatalog.supportedWorkflows` at `:143-160` holds only viralrecon | |
| 39 | "without the flag it prints a usage hint rather than a project inventory" | true | `WorkflowCommand.swift:1204-1207` prints two info lines | |
| 40 | "`lungfish workflow validate <file>` checks syntax for a `.nf` file or a Snakefile (a filename containing `snakefile`) and rejects anything else" | true | `WorkflowCommand.swift:1233-1252`, with `unsupportedFormat` in the else branch | |
| 41 | "so it does not accept a `.yaml` workflow definition" | true | Same else branch | |
| 42 | "In **Workflow Operations**, choose **Open Previous Run…** and select a `.lungfishrun` folder." | true | `WorkflowOperationsDialog.swift:81` places the `Open Previous Run…` button in the Overview section | |
| 43 | "A terminal local workflow row in Operations offers **Run Again…** in its context menu." | true | `OperationsPanelController.swift:1509-1514` adds `Run Again…` when `WorkflowOperationsWindowController.replaySourceBundleURL(for: item)` is non-nil | |
| 44 | "Run Again currently supports imported local packages that fit the existing reference-plus-one-FASTQ configuration controls without dropping saved options." | true | `WorkflowLibrary.swift:322-329` states the beta1 contract, and `LocalWorkflowReplayConfiguration.swift:13` restricts replay to finished attempts | |
| 45 | "Completed, failed and cancelled histories can be inspected. Older histories without a bound configuration, unfinished attempts and unsupported settings explain why they cannot be repeated." | true | `LocalWorkflowReplayConfiguration.swift:13` and `LocalWorkflowReplayIdentity.swift:69`, `:128`, `:132` each throw a described reason | |
| 46 | "The form shows the source run, package name and version, retained inputs, core count and a fresh output location." | true | `WorkflowOperationsDialog.swift:84-90` renders the package name and version, the source path, the retained-input count, the core count, and the fresh-output note | |
| 47 | "For missing sources, use **Open Workflow Library…**, the reference chooser or **Locate Original Reads…**." | true | `WorkflowOperationsDialog.swift:91-94` for the first and `:220` for `Locate Original Reads…` | |
| 48 | "Relocated copies must retain the original bytes." | true | `WorkflowOperationsDialog.swift:89` states only the original package and input bytes are accepted, and `LocalWorkflowReplayIdentity.swift:128-132` rejects symlinks and non-regular files | |
| 49 | "**Open Tool Setup…** opens the existing runtime management surface." | changed | `WorkflowOperationsDialog.swift:93` binds the button to `PluginManagerWindowController.show()`, and the Tools menu names that window `Plugin Manager…` at `MainMenu.swift:772-780` | "**Open Tool Setup…** opens the Plugin Manager, where tool runtimes are installed and repaired." |
| 50 | "Choose **Check Configuration** after repairing a source or choosing a new output parent." | true | `WorkflowOperationsDialog.swift:123-127` shows the `Check Configuration` button only while a replay configuration is loaded | |
| 51 | "Checking does not launch a workflow." | true | The button calls `state.checkReplayConfiguration()` at `WorkflowOperationsDialog.swift:124`, distinct from the Run action | |
| 52 | "The output name and core count remain fixed in this mode." | unverifiable | The replay summary at `WorkflowOperationsDialog.swift:86-87` displays a fixed core count, but I did not find the control-disabling code that fixes the output name. Reading the replay branch of `WorkflowOperationDialogState` would settle it | |
| 53 | "Choose **Run** only after the check succeeds." | changed | The dialog's Run button is gated by `state.isRunEnabled` at `WorkflowOperationsDialog.swift:22`, not by an ordering rule the reader must remember | "The **Run** button stays disabled until the readiness line reports the configuration is ready." |
| 54 | "Lungfish validates the captured configuration and originating window again before starting a new operation with its own run bundle, output directory and provenance." | true | `WorkflowOperationsWindowController.swift:178-190` re-checks the originating window and project before launch | |
| 55 | "Read-only projects permit configuration inspection but cannot start a scoped write." | true | `WorkflowOperationsWindowController.swift:178-190`, and the read-only refusal pattern shared with `WorkflowBuilderViewController.swift:874-887` | |
| 56 | "Closing or replacing the configuration during validation prevents launch." | true | `WorkflowOperationsWindowController.swift:180`, "The originating window is unavailable", and `:188`, "The originating project was closed or replaced" | |
| 57 | "This is the last chapter in [Workflows](.)." | true | No chapter file follows `03-` in `docs/user-manual/chapters/08-workflows/` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The `--repeat-from <bundle>` flag, which validates an original run bundle before a fresh attempt and is the CLI counterpart of Run Again | `cli-help/workflow.txt`, run options |
| The `--format text, json, tsv` output flag on `workflow run`, `list`, and `validate` | `cli-help/workflow.txt`, all three banners |
| `run-headless`, the thin alias for `workflow run --quiet` | `cli-help/run-headless.txt` |
| `ops stats`, which summarises runtime and peak memory from the provenance sidecars a run leaves | `cli-help/ops.txt`, banner `==== ops stats ====` |
| The pinned Nextflow version 26.04.6 and Snakemake version 9.25.2 | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` |
| The pinned viralrecon revision 3.0.0 | Same lock file, pipelines list, and `NFCoreSupportedWorkflowCatalog.swift:148` |
| The **Link Workflow...** button and the Link Workflow Package open panel, which is how a `.lungfishflowpkg` enters the library at all | `WorkflowLibraryPanelView.swift:136-143`, `:196-205` |
| That a linked package stays at its original location and that relinking the same identity replaces the source and version while preserving enablement | `WorkflowLibraryPanelView.swift:174-179`, panel message at `:199` |
| The Runnable versus Catalog only badge on a linked package card | `WorkflowLibraryPanelView.swift:434` |
| The two shipped example packages a reader could link to try this | `Examples/WorkflowPackages/hello-world-nextflow.lungfishflowpkg`, `hello-world-snakemake.lungfishflowpkg` |
| That an enabled workflow also appears as a Tools category submenu item, and that a disabled one appears greyed with "(not enabled)" and prompts to enable | `MainMenu.swift:794-799`, `:821-844` |
| Where the Nextflow launch scratch lives, which moves off the project volume when that volume cannot host `.nextflow/` | `Sources/LungfishWorkflow/Native/NextflowScratchVolumeProbe.swift:8-27`, `:49-52`, and the scratch work directory passed at `WorkflowCommand.swift:722-724` |
| The `-work-dir` override that scratch placement applies for nf-core runs | `WorkflowCommand.swift:683-724` |
| That local Snakemake receives `--directory <results-dir>` and `--config key=value` pairs | `LocalWorkflowRunBundle.swift:216-228` |
| The batch policy note, that Workflow Operations pools every selected FASTQ bundle into one run | `WorkflowOperationsDialog.swift:63-71` |
| The Workflow Operation Error alert | `WorkflowOperationsDialog.swift:34-43` |
| The six dialog sections a reader will actually see, Overview, Inputs, Primary settings, Advanced settings, Output, Readiness | `WorkflowOperationsDialog.swift:76-128` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| planned shot `workflow-operations-runner` | yes, with a caveat | The window and its configuration controls are real, but the caption should say the window opens from a Tools category submenu, not from a menu item named Workflow Operations. |
| Missing marker | note | The chapter has no `<!-- SHOT -->` or `<!-- planned: … -->` marker in its body, so the single planned shot is never placed. Add a marker in the Run Again section. |
| Missing shot | add one | The Workflow Library panel with the Link Workflow... button and a Runnable versus Catalog only badge, since linking is how a package arrives and the chapter never shows it. |
