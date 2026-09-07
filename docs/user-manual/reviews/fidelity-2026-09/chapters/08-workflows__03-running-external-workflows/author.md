# Author log, 08-workflows/03-running-external-workflows

Chapter: `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`
Roster row 52, registry id `workflow.library-run`, build Preview 2026.9.13.
Binary used for every run: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
Fixture working directory: `/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/external-workflows/`.

## Fixture setup

Both shipped example packages were copied from `Examples/WorkflowPackages/` into the
scratchpad directory above, as whole folders, and every run below was executed against
those copies rather than against the repository originals.

- `hello-world-nextflow.lungfishflowpkg` (4 files: `README.md`, `environment.yml`, `main.nf`, `manifest.json`)
- `hello-world-snakemake.lungfishflowpkg` (4 files: `README.md`, `environment.yml`, `Snakefile`, `manifest.json`)

What each package does, in one sentence each. The Nextflow package runs one process,
`CREATE_REFERENCE_BUNDLE`, which writes a four-base FASTA (`>hello` / `ACGT`), a `.fai`
index, and a full reference manifest, and publishes them as
`hello-world-nextflow.lungfishref`. The Snakemake package runs one rule,
`write_reference_bundle`, which writes the same four-base FASTA as `sequence.fasta`
plus a manifest that is the empty JSON object `{}`, into
`results/hello-world-snakemake.lungfishref`.

Both packages' manifests declare `"runtime": {"kind": "none"}`, so neither needs Docker
or Apple Containers, and both meet the Runnable contract (required `.lungfishref` input,
required `.lungfishfastq` input, one declared output). Docker was present on the machine
(`/usr/local/bin/docker`) but was not exercised, because no run in this chapter needs it.
Engines resolved from `PATH`: `/Users/dho/miniforge3/bin/nextflow` and
`/Users/dho/miniforge3/bin/snakemake`.

## Commands run

All commands were run from the scratchpad fixture directory.

| # | Command | Exit | Figure taken from it |
|---|---|---|---|
| 1 | `lungfish-cli workflow validate hello-world-nextflow.lungfishflowpkg/main.nf` | 0 | Output lines `ℹ Validating Nextflow workflow: main.nf` and `✓ Workflow syntax appears valid` |
| 2 | `lungfish-cli workflow validate hello-world-snakemake.lungfishflowpkg/Snakefile` | 0 | Same two lines with engine Snakemake |
| 3 | `lungfish-cli workflow list` | 0 | Two info lines, no inventory. Confirms ground-truth claim 39 |
| 4 | `lungfish-cli workflow list --nf-core` | 0 | `Supported nf-core Pipeline` then the single `nf-core/viralrecon` row |
| 5 | `lungfish-cli workflow run …/main.nf --results-dir ./nf-prepare-results --prepare-only --bundle-root ./bundles` | 0 | Created `bundles/main.lungfishrun`; printed the `nextflow run … --outdir …` preview and the bundle path as the last line |
| 6 | `lungfish-cli workflow run …/main.nf --results-dir ./nf-guard` (no `--expected-output`) | 64 | Guard message quoted verbatim in the chapter's defect paragraph |
| 7 | `lungfish-cli workflow run …/main.nf --results-dir ./nf-dry --dry-run` (no `--expected-output`) | 0 | Printed `Workflow: / Results: / Executor: docker / Parameters: 0`. Proves `--dry-run` returns before the guard |
| 8 | `lungfish-cli workflow run …/main.nf --results-dir ./nf-results --expected-output ./nf-results/hello-world-nextflow.lungfishref --bundle-root ./bundles` | 0 | REAL Nextflow run. Bundle `bundles/main-2.lungfishrun`. `stdout.log` = 4 lines ending `[SUCCESS] completed=1 failed=0 cached=0`; `stderr.log` empty |
| 9 | `lungfish-cli workflow run …/Snakefile --results-dir ./smk-results --expected-output ./smk-results/results/hello-world-snakemake.lungfishref --bundle-root ./bundles --cpus 2` | 0 | REAL Snakemake run. Bundle `bundles/Snakefile.lungfishrun`. Assembled command shows `--snakefile … --directory … --cores 2 --config outdir=…` |
| 10 | Same as 9 plus `--repeat-from ./bundles/Snakefile.lungfishrun` but without `--cpus 2` | nonzero | `Error: Retained settings changed. Restore the original settings or start a new configuration.` Quoted verbatim in the chapter |
| 11 | Same as 10 with `--cpus 2` restored | 0 | Bundle `bundles/Snakefile-2.lungfishrun`, results written to `smk-repeat/` |
| 12 | `lungfish-cli workflow validate …/Snakefile --format json` | 0 | JSON object with keys `engine`, `errors`, `valid`, `workflow` |
| 13 | `lungfish-cli run-headless …/main.nf --results-dir ./nf-headless --expected-output … --bundle-root ./bundles` | 0 | Printed only the bundle path `bundles/main-3.lungfishrun`, confirming the `--quiet` alias behaviour |
| 14 | `lungfish-cli ops stats ./nf-results` | 0 | 1 sidecar, 1 completed run, `Run Local Nextflow workflow` row, Peak RAM `unknown` |
| 15 | `lungfish-cli ops stats ./bundles` | 0 | 5 sidecars, 5 completed runs, rows `Run Local Nextflow workflow` (3) and `Run Local Snakemake workflow` (2) |
| 16 | `lungfish-cli ops stats --directory ./nf-results` | 0 (with `Error: Unknown option '--directory'`) | Established that `ops stats` takes a positional argument, not a flag |
| 17 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/08-workflows/03-running-external-workflows.md` | 0 | `…/03-running-external-workflows.md: no issues found` |

## Files produced by the real runs, and read

Nextflow run (command 8):

- `nf-results/hello-world-nextflow.lungfishref/genome/sequence.fa`
- `nf-results/hello-world-nextflow.lungfishref/genome/sequence.fa.fai`
- `nf-results/hello-world-nextflow.lungfishref/manifest.json`
- `nf-results/hello-world-nextflow.lungfishref/.lungfish-provenance.json` (the expected-output sidecar)
- `nf-results/hello-world-nextflow.lungfishref/provenance/bundle.lungfish-provenance.json`
- `bundles/main-2.lungfishrun/{manifest.json, .lungfish-provenance.json, logs/stdout.log, logs/stderr.log, provenance/manifest.json.lungfish-provenance.json, provenance/bundle.lungfish-provenance.json}`

Snakemake run (command 9):

- `smk-results/results/hello-world-snakemake.lungfishref/sequence.fasta` (content read: `>hello` / `ACGT`)
- `smk-results/results/hello-world-snakemake.lungfishref/manifest.json`
- `smk-results/results/hello-world-snakemake.lungfishref/.lungfish-provenance.json`
- `bundles/Snakefile.lungfishrun/` with the same six-file shape as above

Run-bundle `manifest.json` top-level keys, read from `bundles/Snakefile.lungfishrun/manifest.json`:
`commandPreview, completedAt, createdAt, engine, executionStatus, exitCode, inputBindings,
outputDirectoryName, params, replayIdentity, request, resume, schemaVersion, startedAt,
statusHistory, stderrLogPath, stdoutLogPath, workflowDisplayName, workflowName, workflowPath`.
Its `statusHistory` held exactly three entries, `prepared`, `running`, `completed`, which is
the figure quoted in the chapter.

Expected-output sidecar keys, read from the Nextflow run's `.lungfish-provenance.json`:
`appVersion, argv, createdAt, endTime, exitStatus, files, hostOS, id, name, options, output,
outputs, parameters, reproducibleCommand, runtime, runtimeIdentity, schemaVersion, signatures,
startTime, status, stderr, steps, tool, toolName, toolVersion, wallTimeSeconds, workflowName,
workflowVersion`. Its `files` array gave each entry a `role` of `input` or `output` plus a
`sha256`, which is the basis of the chapter's provenance paragraph.

`replayIdentity.package.entries` for the Nextflow package listed the four package files with
SHA-256 and byte size, plus one directory entry, which is the figure behind the chapter's
Run Again paragraph.

## Source files consulted

- `Sources/LungfishApp/App/MainMenu.swift` (lines 760-845): the `Workflow Library…` item, the
  category submenu builder, and `workflowMenuItem(for:)` which produces the greyed
  `(not enabled)` title and its enable prompt.
- `Sources/LungfishApp/Views/WorkflowLibrary/WorkflowLibraryPanelView.swift` (lines 120-215, 425-445):
  the `Link Workflow...` button, the open panel titled `Link Workflow Package` with prompt
  `Link Workflow` and its relink message, and the contract rows ending in
  `Execution: Runnable | Catalog only`.
- `Sources/LungfishApp/Services/WorkflowLibrary.swift` (lines 315-333):
  `workflowLibraryExecutionUnavailableReason`, the beta enablement contract.
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift` (lines 14-130):
  the window title and subtitle, the `Workflow Operation Error` alert, the multi-bundle
  `lockReason` string `They will run as one batch.`, the six sections, the Run Again
  buttons, and the Readiness section gating `Run` on `state.isRunEnabled`.
- `Sources/LungfishWorkflow/LocalWorkflowRunBundle.swift` (lines 195-235): the Nextflow
  argument builder (`-resume`, `-work-dir`, `--key value`) and the Snakemake one
  (`--snakefile`, `--directory`, `--cores`, `--config key=value`).
- `Sources/LungfishWorkflow/Engines/ContainerRuntimeProtocol.swift` (lines 66-90):
  `nextflowProfile` mapping both `.appleContainerization` and `.docker` to the string
  `docker`, and `snakemakeArguments` mapping both to `--use-docker`.
- `Sources/LungfishWorkflow/Native/NextflowScratchVolumeProbe.swift` (lines 1-55): the two
  probed capabilities, POSIX advisory locks and native extended attributes, and the
  AppleDouble failure mode behind the scratch relocation.
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`:
  `bioconda::nextflow=26.04.6=h2a3209d_1` and `bioconda::snakemake=9.25.2=hdfd78af_0`.
- `Examples/WorkflowPackages/*/manifest.json`, `main.nf`, `Snakefile`, `README.md`, `environment.yml`.
- `docs/user-manual/parameters.yaml` lines 6421-6555, registry entry `workflow.library-run`.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/workflow.txt`, `run-headless.txt`.
- Style references read but not edited: `06-classification/10-twelve-s-metabarcoding.md`,
  `08-workflows/02-exporting-as-nextflow-or-snakemake.md`.

## Drift rows applied

All 2 false and 9 changed rows were applied.

- False 6, the beta enablement contract, now stated in step 1 and in the **Enabled** setting.
- False 30, Docker as the only exercised executor, now stated in the `--executor` paragraph.
- Changed 4, the Workflow Operations window is reached from a Tools category submenu.
- Changed 8, `.nf` lower case only, `snakefile` any case. Stated in the command-line section
  and in the defect paragraph.
- Changed 13, `--prepare-only` waives the expected-output requirement, with the error
  message's `--dry-run` mention flagged as a defect and the run-16 evidence behind it.
- Changed 17, `--params-file` takes JSON or YAML.
- Changed 20 and 21, nf-core behaviour of `--cpus` (`max_cpus`) and `--memory` (`max_memory`).
- Changed 25, `--dry-run` validates without executing.
- Changed 49, `Open Tool Setup…` opens the Plugin Manager.
- Changed 53, Run stays disabled until the readiness line reports ready.

All 17 Missing rows were covered: `--repeat-from` (run and quoted), `--format`,
`run-headless`, `ops stats`, the pinned Nextflow and Snakemake versions, the pinned
viralrecon 3.0.0, the `Link Workflow...` button and its panel, the stay-in-place and
relink-by-identity behaviour, the Runnable versus Catalog only badge, both example
packages, the greyed `(not enabled)` menu item, the Nextflow scratch relocation, the
`-work-dir` override, Snakemake's `--directory` and `--config`, the one-batch pooling
policy, the Workflow Operation Error alert, and the six dialog sections.

## Screenshots

The chapter previously had no marker at all for its single planned shot. Two planned
markers now sit in the body.

- `workflow-library-linked-package`, new, placed at the end of step 1. Added per the drift
  report's "Missing shot" row, showing the Link Workflow... button and the Runnable badge.
- `workflow-operations-runner`, kept from the old front matter, recaptioned per the drift
  report's caveat to say the window opens from a Tools category submenu, and placed at the
  end of step 3. Its caption now names the six real sections.

## Defects found

1. **Expected-output guard advice is wrong about `--dry-run`.** The error thrown by
   `requireExpectedOutputsForExecution()` reads "Use `--prepare-only` or `--dry-run` for
   planning-only runs", but the guard is `guard !prepareOnly, expectedOutput.isEmpty`, so
   only `--prepare-only` short-circuits it. Verified by runs 6 and 7. In practice
   `--dry-run` still succeeds because it returns before the guard is reached, so the
   user-visible advice happens to hold. Either the guard should also test `dryRun` or the
   message should drop the `--dry-run` half. Documented in the chapter's What good looks
   like section.
2. **`workflow run` does not lowercase the `.nf` extension.** `WorkflowCommand.swift:425`
   compares `pathExtension == "nf"` directly while `:426` lowercases before the snakefile
   check, and `workflow validate` at `:1233` does lowercase. A file named `pipeline.NF`
   therefore validates as Nextflow but is not detected as Nextflow by `workflow run`. Not
   reproduced by a run, since the shipped packages are lower case. Documented as a defect,
   sourced to the ground-truth reading.
3. **`ops stats` argument shape is easy to get wrong.** `--directory` is rejected with
   `Error: Unknown option '--directory'` yet the process still exits 0 (run 16). A usage
   error exiting zero would break a script that checks status. Noted here, not in the
   chapter, since the chapter only shows the correct positional form.
4. **The two example packages disagree on output shape.** The Nextflow package writes a
   complete reference bundle (FASTA, `.fai`, full manifest with a described contig) while
   the Snakemake package writes `sequence.fasta` and a manifest of `{}`. Both are declared
   as `bundleType: lungfishref` in their manifests, so the Snakemake one would not open as
   a usable reference bundle. Called out in the chapter as an author-side incompleteness
   rather than an app bug, since nothing validates a package's output against its declared
   bundle type.

## Not verified

- **No GUI interaction.** Every claim about the Workflow Library window, the Link Workflow
  open panel, the Workflow Operations window, its six sections, its Readiness gating, the
  Run Again buttons, and the greyed `(not enabled)` menu item comes from reading the Swift
  source named above, not from driving the app. The two planned shots remain planned.
- **Drift row 52, "The output name and core count remain fixed in this mode",** was marked
  unverifiable in the ground truth and stays partly so. The chapter states only what the
  registry asserts, that the Output Name field is disabled during a Run Again. The core
  count being fixed was not confirmed against the control-disabling code in
  `WorkflowOperationDialogState`.
- **Docker and Apple Containerization were never exercised.** Both example packages declare
  `runtime.kind: none`, so no containerised run happened. The `--executor` paragraph rests
  on `ContainerRuntimeProtocol.swift:70-88` alone.
- **`--memory`, `--params-file`, `--param`, `--workdir`, `--resume`, `--bundle-path`, and
  `--timeout`** were documented from the CLI help text and the source, not from runs. The
  hello-world packages take no parameters and finish in under a second, so none of these
  flags would have produced an observable difference.
- **The Nextflow scratch relocation** was documented from `NextflowScratchVolumeProbe.swift`.
  The scratchpad volume qualified, so the fallback path never triggered and no exFAT volume
  was available to force it.
- **nf-core/viralrecon** was not run. It has its own chapter and its own wizard, and this
  chapter only names it and points there.
