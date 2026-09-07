# Author log: 08-workflows/01-the-workflow-builder

Roster row 50. Registry id `workflow.builder`. Rewritten 2026-09-07 against
Preview 2026.9.13 (`lungfish-cli --version` printed `2026.9.13`).

The previous author was cut off before writing anything, so this was a full
rewrite of the chapter that was on disk.

## Fixture and scratch project

The roster names "demo project" as the fixture. `~/Desktop/lge-docs/LGE Manual
Demo.lungfish` is read-only for this role and was never written to. The worked
example was built instead in a scratch project at

    /private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/workflow-builder/Mito Workflow.lungfish

using the human mitochondrial fixture at
`docs/user-manual/fixtures/human-mito/` (HG002 chrM reads), because the
campaign prefers human examples over viral ones. The imported bundle held
19,916 reads (9,958 pairs), mean read length 248.4, stored interleaved.

## Commands run

All commands used `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

| # | Command | Exit | What it produced for the chapter |
|---|---|---|---|
| 1 | `lungfish-cli --version` | 0 | `2026.9.13`, the build every figure is against |
| 2 | `lungfish-cli --help` | 0 | subcommand list, confirmed no `project create` |
| 3 | `lungfish-cli project --help` | 0 | confirmed project has only lock/unlock/migrate |
| 4 | `lungfish-cli import-fastq --help` | 0 | flags for the fixture import |
| 5 | `lungfish-cli import-fastq <R1> <R2> --project "Mito Workflow.lungfish"` | 0 | created `Imports/HG002.chrM.lungfishfastq`; import summary Completed 1, Failed 0, 2.7s |
| 6 | `lungfish-cli workflow builder-run --workflow mito-cleanup.json --project ... --dry-run` (first attempt) | non-zero | `DecodingError.typeMismatch ... Path: nodes` — led to the `[UUID: T]` flat-array encoding finding |
| 7 | same, second attempt | non-zero | `DecodingError.typeMismatch ... Path: nodes[1].position` — led to the CGPoint two-element-array finding |
| 8 | same, third attempt | 0 | 219-line compiled plan; source of the `builder-step run --operation ...` and `--graph-id` argv quoted in the chapter's last section |
| 9 | `lungfish-cli workflow builder-run --workflow mito-cleanup.json --project ... --threads 4` | 0 | full run against a bare graph JSON; output landed under `Workflow Runs/9008AAD2-.../outputs/` |
| 10 | `lungfish-cli workflow builder-run --workflow "Mito read cleanup.lungfishflow" --project ... --threads 4` | 0 | full run against a `.lungfishflow` bundle; output landed under `runs/AC7F4093-12E5-44C4-A421-766687890D11/outputs/`. The three printed lines are quoted verbatim in the chapter |
| 11 | `lungfish-cli workflow diff mito-cleanup.json v11.json` | 0 | the three-line diff quoted verbatim in the chapter |
| 12 | `lungfish-cli workflow diff ... --format json` | 0 | **defect**: printed the text form |
| 13 | `lungfish-cli workflow diff ... --format tsv` | 0 | **defect**: printed the text form |
| 14 | `lungfish-cli --format json workflow diff ...` | 0 | **defect**: still text, so the global flag is not the cause |
| 15 | `lungfish-cli workflow diff --help` | 0 | confirms `--format` is declared with values text, json, tsv |
| 16 | `lungfish-cli workflow validate mito-cleanup.json` | 5 | `Error: Unsupported format: Unknown workflow format`, quoted verbatim |
| 17 | `lungfish-cli workflow list` | non-zero | only advises `--nf-core`; does not list saved builder chains |
| 18 | `lungfish-cli workflow builder-run --workflow outside.json --project ... --dry-run` | non-zero | `Error: FASTQ bundle input is outside the active project: ...`, quoted (path elided in the chapter) |
| 19 | `lungfish-cli workflow builder-run --workflow branching.json --project ... --dry-run` | non-zero | `Error: Workflow Builder runner requires a single linear FASTQ chain: Node 'FASTQ bundle input' must have exactly one outgoing connection.`, quoted verbatim |
| 20 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <chapter>` | 0 after one fix | see Lint below |

Helper scripts written in the scratchpad (not in the repo): `make_graph.py`,
`make_branching.py`. The graph files `mito-cleanup.json`, `v11.json`,
`outside.json`, `branching.json`, and the saved bundle
`Workflows/Mito read cleanup.lungfishflow` are all in the scratchpad.

### Figures taken from those runs

Every count in the chapter's Reading the results table came from
`hg002-chrm.fastq.gz.lungfish-meta.json` inside the output bundle of run 10.

| Step | Tool and version | Reads in | Reads out |
|---|---|---|---|
| Remove PCR duplicates + Adapter + quality trim (fused) | fastp 1.3.6 | 19,916 | 9,876 |
| Remove human reads | deacon 0.16.0 | 9,876 | 159 |
| Merge overlapping pairs | fastp 1.3.6 | 159 | 225 |
| Remove short reads | seqkit 2.13.0 | 225 | 106 |

Also read from that run: the fused fastp argv carrying `--dedup ... -q 15 -W 5
--cut_right`, the seqkit argv carrying `-m 50`, the output bundle's
`derived.manifest.json` with `parentBundleRelativePath = @/Imports/HG002.chrM.lungfishfastq`
and five lineage entries keyed `deduplicate`, `fastpTrim`, `humanReadScrub`,
`pairedEndMerge`, `lengthFilter`, and the output statistics (106 reads,
30,498 bases, mean read length 287.7).

### The saved workflow file

Written by hand to `Workflows/Mito read cleanup.lungfishflow` as
`workflow.json` plus `graph.json`, matching what `WorkflowLibraryStore.saveWorkflow`
writes, and then read back by the runner (run 10) without complaint. After
that run the bundle held `graph.json`, `workflow.json`, `versions/`, and
`runs/AC7F4093-.../` containing `builder-plan.json`, `outputs/`, `workspace/`.

## Source files consulted

- `Sources/LungfishApp/App/MainMenu.swift` (:725-736, the `experimentalFeaturesEnabled` gate and the exact menu title)
- `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift` (:10-25, the toggle label and both caption strings)
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowBuilderViewController.swift` (:110-230 sidebar wiring and the unsaved-changes prompt, :340-440 run validation and the four alerts, :440-540 library create/rename, :1090-1180 every toolbar item and its tooltip)
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowNodePalette.swift` (:79-103, the `isBuilderNativeFASTQNode` filter and the `Filter nodes` placeholder)
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowLibraryView.swift` (:98-112 the `Workflows` heading and the three button tooltips, :190-193 the context menu)
- `Sources/LungfishApp/Views/WorkflowBuilder/WorkflowNodeInspectorView.swift` (:170-210 the FASTQ bundle popup and path control, :239 the `Configure...` button)
- `Sources/LungfishApp/Services/WorkflowBuilderRunService.swift` (the `.graph` executor and the parent-plus-runner row shape)
- `Sources/LungfishWorkflow/Builder/WorkflowNode.swift` (:13-53 node type raw values, :110-138 categories and the six native types, :139-260 every port, :264-410 every parameter definition with its default, bounds, and allowed values)
- `Sources/LungfishWorkflow/Builder/WorkflowGraph.swift` (:33-170 the Codable shape and the two pinned anchors, :318-332 duplicate and cycle rejection, :520-580 the six validation checks)
- `Sources/LungfishWorkflow/Builder/WorkflowConnection.swift` (:24-70 the connection fields)
- `Sources/LungfishWorkflow/Builder/WorkflowLibraryStore.swift` (:46-140 the `Workflows` folder name, the `lungfishflow` extension, the three written files, the version history, and the provenance argv)
- `Sources/LungfishWorkflow/Builder/WorkflowBuilderRunRecord.swift` (:10-16 the five node statuses, :100-180 the record fields and the `runs/` layout)
- `Sources/LungfishWorkflow/Builder/VSP2WorkflowTemplate.swift` (whole file, for the node ids, ports, and positions used to hand-write the graph)
- `Sources/LungfishCLI/Commands/WorkflowCommand.swift` (:35-180 `builder-run` and `diff`, including the derived run directory and the diff format switch)
- `Sources/LungfishCLI/Options/GlobalOptions.swift` (:247-256 the `OutputFormat` enum)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/workflow.txt`
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/08-workflows.md`
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md` (lines 2549-2645)
- `docs/user-manual/parameters.yaml` (lines 6558-6697)
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/ARCHITECTURE.md`
- `docs/user-manual/fixtures/human-mito/README.md`
- `docs/user-manual/chapters/06-classification/03-running-esviritu.md` (style reference)

## Drift coverage

Every false and changed row for this chapter in DRIFT.md was applied. The
notable ones, and where they landed:

- Row 4, the experimental gate: now the fixed CONSISTENCY sentence plus a
  paragraph in Before you start explaining that with the toggle off there is
  no menu item at all.
- Rows 9 and 12, the palette: four category headers, six node types, stated
  as a table. The three model-only categories are named and explained.
- Row 11, the tooltip: rewritten to name and port data types.
- Row 13, the Filter nodes field: documented in the Procedure and as a
  Settings paragraph.
- Rows 15 and 16, dragging and deleting: whole-node drag, `Delete` or forward
  delete, pinned anchors exempt from both.
- Row 26, duplicate edges: one sentence in step 4.
- Row 32, allowed values and bounds: every Settings paragraph carries them.
- Rows 40 through 52, the node tables: replaced with one six-row palette
  table plus a prose paragraph naming all twelve not-offered types, including
  `Export`, and calling out the `Trimming` and `Quality Control` parameters
  that contradict the old blanket claim.
- Row 54, `File > Save Workflow`: removed. Replaced with the sidebar library
  and the save-before-run behaviour.
- Row 55: the settled wording about new workflows landing at
  `Workflows/<name>.lungfishflow` is used verbatim in substance.
- Row 56: the saved bundle described as graph plus version history plus a
  provenance record naming the LGE version, save time, and per-file checksum.
- Row 60: window subtitle claim dropped entirely rather than restated, since
  it is a detail no reader acts on.
- Row 65, `--format tsv`: mentioned, together with the defect that neither
  json nor tsv works.
- Row 72, the five node statuses including `pending`.
- Rows 73, 74, 90, 94, the Operations Panel: a parent row and a runner row,
  never one row per node.
- Row 78, `--threads` default 4.
- Row 79, the argv examples: replaced with the two real shapes, both verified
  (the `builder-step run --operation` argv from the dry-run output, the
  `Lungfish "Tools > Workflow Builder (Experimental)" Save` argv from
  `WorkflowLibraryStore.swift:113`).
- Row 85, the VSP2 template: the chapter no longer mentions a template at
  all, since it is unreachable. The chain is built by hand throughout.
- Row 91, re-saving on every run: stated in Reading the results.
- Row 96, the outside-project refusal: moved to run time, with the real error.

All 25 Missing rows are covered. The two that changed the chapter most are
the sidebar library (now the whole of step 1) and the toolbar (zoom, grid,
snap, export menu, collapsible panes), which had been absent.

## Defects found

1. **`workflow diff --format json` and `--format tsv` both print the text
   form.** Reproduced three ways (runs 12, 13, 14). `--format` is declared in
   `WorkflowDiffSubcommand` with values text, json, tsv and appears in
   `--help`, and the `switch format` in `run()` looks correct, but the option
   is not taking effect at runtime. The built binary postdates the source
   file, and the worktree copy of `WorkflowCommand.swift` is byte-identical to
   the primary checkout's, so this is not a stale-build artefact. Stated as a
   defect in the chapter's Comparing two versions subsection, with the advice
   to read the two `workflow.json` files instead.

2. **A command-line `builder-run` writes no `run.json` and no
   `provenance.json`.** `WorkflowBuilderRunStore.write` is called only from
   `WorkflowBuilderRunService` (the GUI path). The CLI uses
   `WorkflowBuilderRunStore` solely to derive the run directory
   (`WorkflowCommand.swift:100`). Confirmed on disk after run 10, where
   `runs/AC7F4093-.../` held only `builder-plan.json`, `outputs/`, and
   `workspace/`. The chapter states this as a real difference between the two
   surfaces rather than glossing it.

3. **`workflow validate` cannot validate a builder graph.** It exits 5 with
   "Unsupported format: Unknown workflow format". Arguably by design, since
   it targets Nextflow and Snakemake files, but the name invites the mistake
   and there is no builder-graph validator on the command line at all. Noted
   in the chapter so a reader does not waste time on it.

4. **`workflow list` does not list saved builder workflows.** It only
   advises `--nf-core`. Noted in the chapter.

5. **The graph JSON encoding is undocumented and non-obvious.** `nodes` and
   `connections` encode as flat alternating key/value arrays (Swift's
   `[UUID: T]` behaviour) rather than as objects, and `position` encodes as a
   two-element array rather than an `{x, y}` object. Both cost a failed run
   each to discover (runs 6 and 7). Not stated in the chapter, since the
   chapter tells readers to compose in the window, but recorded here because
   anyone generating a graph file programmatically will hit it.

## Not verified

- **Nothing in the window was seen on screen.** Every GUI claim in this
  chapter comes from the Swift source, not from driving the app. The five
  SHOT markers are therefore unillustrated claims until the Screenshot Scout
  captures them, and two of them (the sidebar library, the experimental
  toggle) are the ones the drift report flagged as needing new shots.
- The **Configure...** button's dialog was not opened, so the chapter says
  only that it opens the shared FASTQ/FASTA Operations dialog with an Apply
  button, which is what the source shows.
- The **run-binding sheet** for the legacy Sample input anchor was not
  exercised, since the worked example uses the explicit input node. Its
  description comes from `showRunBindingSheet`.
- The **Workflow Not Ready**, **No Active Project**, **Input Bundle Not
  Ready**, and read-only refusals were not triggered in the window. The
  equivalent command-line refusals for a branching graph and an
  outside-project path were triggered and are quoted.
- **Deacon's panhuman database** was already installed on this machine, so
  the missing-database path was not seen.
- The claim that **fastp fusion applies to any two adjacent fastp steps** was
  verified for the dedup-then-trim pair only. The merge step also runs fastp
  but was not adjacent to another fastp step in this chain, so it was not
  fused, which is consistent with the rule but does not prove the general case.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md`

First pass: one warning, a six-item list exceeding the five-item cap in the
node-placement step. Converted to prose. Second pass:

    docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md: no issues found

## Glossary

Three terms added to `docs/user-manual/GLOSSARY.md` in alphabetical order and
listed in `glossary_refs`:

- `directed-acyclic-graph`
- `node-port`
- `workflow-bundle`

The other seventeen `glossary_refs` entries already existed.
