---
title: Running in CI
chapter_id: appendices/06-running-in-ci
audience: power-user
prereqs: [01-foundations/08-provenance-and-reproducibility, 08-workflows/03-running-external-workflows]
estimated_reading_min: 30
task: Run Lungfish Genome Explorer workflows on a continuous integration runner with no window, provision the tools the job needs, and keep the provenance as a build artifact.
tags: [ci, headless, github-actions, circleci, conda, provenance]
tools: [nextflow, snakemake]
entry_points:
  - "CLI: lungfish-cli run-headless"
  - "CLI: lungfish-cli workflow run"
  - "CLI: lungfish-cli tools update"
shots: []
illustrations: []
glossary_refs: [cache, checkout, conda, container, continuous-integration, dependency-set, docker, environment-variable, exit-status, glob, kraken2, nf-core, offline-pack, path, plugin-pack, provenance-sidecar, push, repository, run-bundle, runner, shell, workflow-engine, yaml]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## Before you read this

Everything in this appendix is typed rather than clicked. A command is a line of text you type into the Terminal application, which is the macOS program that shows a text prompt and waits for you to type. Nothing here opens the Lungfish Genome Explorer (LGE) window.

A continuous integration job, the subject of this appendix, is a script a hosted machine runs on its own every time you push a change. The script lives in a file you commit alongside your code, and each service documents where that file must sit. On GitHub Actions the folder is `.github/workflows/`, and you create it yourself if the repository does not have one. CircleCI and the other services each name their own path.

The two templates below are starting points to adapt rather than runs this manual performed. Every command inside them was verified on its own, but no CI service executed either file, so expect to change the runner label and the paths before your first job goes green.

Two chapters are worth reading first, though neither is required. [Provenance and Reproducibility](../01-foundations/08-provenance-and-reproducibility.md) explains the record LGE keeps of every run. [Running External Workflows](../08-workflows/03-running-external-workflows.md) covers the same commands at a desk, with a window, and this appendix leans on it throughout.

## What it is

Continuous integration, usually shortened to CI, is a service that runs a set of commands on a fresh machine every time somebody pushes a change to a shared repository. A repository is the folder of files a version-control system tracks, and to push is to send your saved changes up to the shared copy everyone works from. The machine that runs the job is called a runner, and it is rented from the CI service rather than owned by you. It is created for the job, does its work, reports whether every command succeeded, and is then thrown away.

Nothing you install on a runner survives to the next job unless you deliberately save it. The machine is discarded on purpose. A job that passes on a machine nobody has touched is evidence the work does not depend on one person's laptop, which may carry years of software nobody else has.

LGE can take part in that. Its command-line program, meaning the version of LGE you drive by typing rather than by clicking, runs without the app's window, so a CI runner needs no display of any kind. What it does still need is whatever the analysis itself requires.

Which of the two toolsets a job needs depends on the route the workflow takes. A container is a packaged copy of a program together with the libraries it needs, so the program behaves the same on every machine, and a container runtime is the background program that unpacks and runs one. Conda is a package manager that installs bioinformatics tools into isolated per-tool folders, and each of those folders is a conda environment. A local `.nf` file or `Snakefile` runs the workflow engine directly from the conda-installed tools and needs no container runtime at all. Only an nf-core run reads the `--executor` flag, described below, and its default of `docker` is what makes a container runtime a requirement on that route.

## Finding the program

The command-line program is named `lungfish-cli`. Installed releases do not put it on your `PATH`, the list of folders your shell searches for programs, where the shell is the program that reads what you type and runs it. Typing the bare name `lungfish-cli` at a fresh prompt will therefore not find it, and a CI step that types the bare name fails on a runner that only unpacked the application.

Inside the Preview application bundle the program sits at `/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli`. That path holds a space, so it needs quoting, and every command begins `"/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli"`. Readers who compile LGE themselves can skip this, since their build puts the same program at `.build/debug/lungfish-cli` inside the source folder.

Both templates below set that path once into a shell variable at the top of the job and then write `"$LUNGFISH"` in every command. A shell variable is a name you give a value so you can reuse it, and the `$` in front of the name is what asks the shell for the value back. Writing it once means one line to edit when the path changes.

The worked examples in the body of this appendix are shown with the bare name for readability. Substitute the quoted full path, or your own variable, when you type them.

## What a job needs installed

The first steps of an LGE job are the same as any other macOS CI job. It checks out a repository, meaning it copies the tracked files onto the runner, and it puts some programs on the machine.

The runner has to be macOS 26 or later, and that requirement cannot be changed. Container support in LGE is built on Apple Containerization, which arrives with macOS 26, and `lungfish-cli workflow run` says so in its own help text. On GitHub Actions the macOS version is chosen by a runner label, a short name written on the `runs-on:` line of the workflow file, and the label is `macos-26`. That is the label this project's own CI file uses, and the one the template below writes. Vendors rename labels from time to time, so check it against GitHub's published list of runner images, which the GitHub Actions documentation keeps current, before you rely on it.

Beyond the operating system, a job needs the tools the workflow calls. There are two ways that work, and they suit different situations.

The first way is to install the tools on the runner and cache the result. A cache is a copy of a folder the CI service keeps between jobs so the next job does not repeat the download. This is what this project's own CI does, and it is the route to reach for first.

`lungfish-cli tools update --plan` prints the work that is pending against the pinned dependency set, which is the exact list of tool versions one LGE release was built and tested against. To see which dependency set your own installed release uses, run `lungfish-cli tools update --plan` and read the first line of its output. The command is designed for a CI step, because it exits 10 when work is pending and 0 when there is nothing to do. Run against a machine whose environments were out of date, it printed this.

```text
Target dependency set: 2026.2
preserve  bracken  local install kept; pinned bioconda::bracken=1.0.0=1 not applied
          remove the 'bracken' environment and reinstall the pack to take the pinned build
reinstall gatk-core  unknown -> bioconda::gatk4=4.6.2.0=py310hdfd78af_1  [buildChanged]
Estimated download: 157.3 MB
```

Reading that block in full is optional, because a CI step only needs the exit code. The first word of each line is the action LGE would take, `preserve` meaning leave the existing install alone and `reinstall` meaning replace it. The strings with double colons and trailing `=1` are bioconda package coordinates, giving channel, name, version, and build in that order.

The 157.3 MB is the size of that particular pending download on that particular machine, and it is not a fixed figure. It grows with the number of tools out of date and shrinks to nothing once the runner matches the pinned set. On a job that restores a populated cache the download does not happen at all, which is the point of caching.

That run exited 10. A CI step that treats 10 as a failure therefore asserts the runner already matches the pinned set before any scientific work begins, which saves far more time than discovering a version drift halfway through a pipeline. Version drift is the gap that opens when the tools on a machine are no longer the versions a release was tested against.

To do the work rather than report it, `tools update --apply --yes --required-only` installs what cannot be deferred, and `--yes` is required because the command refuses to change anything when nobody is present to confirm. The `--required-only` part installs the tools LGE cannot start without and leaves the optional plugin packs for a later step, so a job that stops there is deliberately half provisioned and finishes the job with the pack commands below.

This project's own CI file uses exactly that line, followed by `lungfish-cli conda install --pack <id>` for each plugin pack the tests need and `lungfish-cli conda db download Viral` for the classification database. A plugin pack is a themed group of tools LGE installs together, and the angle brackets around `<id>` mark a placeholder, meaning you replace the whole thing, brackets included, with a real value. The pack table later in this appendix lists the ids and the kind of work each one serves. Viral is one of the catalogue databases the Kraken2 classifier matches reads against, and `lungfish-cli conda db list` prints the names of the others, so a lab working on something other than viruses picks a different one there.

The second way is an offline pack, which is a copy of already-installed conda environments written to a directory so it can be moved to a machine with no network access. Build it once on a machine that has the tools, commit or archive the result, then install it inside the job. Offline packs get their own section below, because the `--output` flag does not mean what it appears to mean.

Two commands are worth running first, before the workflow, since both are quick and both exit 0. `lungfish-cli debug env --check-tools` prints the runner's macOS version, core count, memory, and architecture, then reports each bioinformatics tool as found with its version or as not found. The core count and memory are the runner's own figures rather than a threshold to meet, and this appendix has no minimum to offer for either. `lungfish-cli debug container` reports whether the Apple Containerization framework is available and ready, and a result other than ready means the container route is closed on that runner, so switch the workflow to a local `.nf` file or a conda executor. Between them the two commands turn a confusing mid-pipeline failure into a clear early one.

## Running the workflow

Use `run-headless` in a CI script, and `workflow run` when you want to read the output yourself at a desk. That is the whole recommendation, and the rest of this paragraph is the evidence behind it. The explicit CI entry point is `lungfish-cli run-headless <workflow> ...`. Its own help text describes it as a thin alias for `lungfish-cli workflow run --quiet <workflow> ...`, an alias being a second name for the same command. The provenance record of a headless run confirms this, because the `argv` field it stores, `argv` being the list of words the command was actually invoked with, reads `workflow run ... --quiet` rather than `run-headless`. Every flag of `workflow run` is accepted after the workflow argument.

A workflow engine is a program that reads a description of an analysis, works out which step must run before which, and then runs them in that order. LGE drives two, Nextflow and Snakemake, and a workflow file is written for one or the other. The workflow argument is a real file or a supported pipeline name, and only three kinds are accepted.

- A Nextflow file with a lower-case `.nf` extension.
- A file whose name contains `snakefile`, in upper or lower case, both work.
- The one built-in nf-core pipeline, written as `nf-core/viralrecon` or `viralrecon`.

Nothing else is recognised. nf-core is a community project that publishes ready-made Nextflow pipelines under shared conventions, and viralrecon is the single one LGE has built in. The Viral Recon route requires exactly one `--input` samplesheet and has its own chapter.

Writing your own workflow file is outside this appendix. [Running External Workflows](../08-workflows/03-running-external-workflows.md) covers where a workflow file comes from and how to write one. The example used below ships with LGE inside its own workflow package folder, `hello-world-nextflow.lungfishflowpkg`, and does almost no work, which is why its timings read as instant.

A run producing scientific output must name that output. Here is a complete run of the shipped Nextflow example package, executed for this appendix. The backslash at the end of each line continues one command onto the next, and you type it. Written on a single line the backslashes are unnecessary.

```bash
lungfish-cli run-headless hello-world-nextflow.lungfishflowpkg/main.nf \
  --results-dir ./nf-results \
  --expected-output ./nf-results/hello-world-nextflow.lungfishref \
  --bundle-root ./bundles
```

`--results-dir` names where the pipeline writes its outputs. `--expected-output` names one finished file LGE must find and give a provenance record to, and it is repeatable, once per scientific output. `--bundle-root` names the folder that receives the run bundle, a `.lungfishrun` folder LGE writes before it launches the workflow, recording the pipeline name, the executor, the inputs, every parameter, and the outputs that must receive provenance. The run bundle is how a run can be described or repeated without being rerun.

That run exited 0 and printed one line, the path of the run bundle it created.

```text
/path/to/bundles/main.lungfishrun
```

Printing the bundle path and nothing else is what makes `run-headless` easy to use in a script, since the step can capture that one line and use it later.

LGE requires an executed run to name an output. The same command without `--expected-output` refused to start, and the refusal read as follows.

```text
Error: Workflow execution failed: workflow run executions require at least one
--expected-output so every final scientific output receives focused provenance.
Use --prepare-only or --dry-run for planning-only runs.
```

That refusal exited 64, and `--quiet` did not suppress it, which is the behaviour a CI job wants. An exit status is the number a command hands back when it finishes, where zero means success and anything else means it stopped. The exit numbers this appendix relies on are collected below.

| Exit status | What it means for a job |
|---|---|
| 0 | The command succeeded and the job step passes. |
| 3 | A pack id was not recognised. The step fails and nothing was installed. |
| 10 | `tools update --plan` found pending work. The step fails, which is what makes it an assertion. |
| 64 | A usage refusal, such as a run with no `--expected-output` or a `provenance verify` on an unsigned record. The step fails before any work happened. |

Naming an expected output tells LGE where to look for a finished file and does not make the workflow produce one. A path that does not match where the pipeline actually writes gives a run that reports success and leaves no provenance behind. That is the quietest failure in this appendix. To find the real path, run the pipeline once at a desk with `--results-dir` set and list what appeared in that folder, then point `--expected-output` at what you found.

Four flags of `workflow run` are worth setting in CI, and each is one sentence of what it does followed by why a job would set it.

- `--executor` picks the execution profile for an nf-core run from `docker`, `conda`, or `local`, defaulting to `docker`, so a job with no container runtime sets `conda` and a job on a local `.nf` file ignores the flag entirely.
- `--dry-run` validates the workflow and prints the plan without running anything, and it exits 0 without an expected output, which makes it the fastest possible check on a pull request, a pull request being a proposed change waiting to be reviewed and merged.
- `--prepare-only` writes the run bundle and the command preview without launching the engine, and this flag is the only one that removes the expected-output requirement.
- `--resume` continues a repeated run from the last checkpoint, a checkpoint being a record of which steps already finished, kept in the engine's own work directory, so it earns its place only when that directory survived from a previous job in a cache. Most jobs leave it off.

One flag is worth knowing so you do not set it. `--timeout` sets a ceiling in minutes. A local run accepts it and does not enforce it. An nf-core run rejects it outright. A CI job should use the runner's own timeout instead, which is the `timeout-minutes:` line in the template below.

A dry run of the same example package printed its plan and exited 0. Note that a dry run reports the configured default rather than checking the runtime is present, so the `docker` executor line below says what would be requested, not what the machine has. `Parameters: 0` is normal for this example, which takes none. The `Results:` line shows this run's own `--results-dir` value, which differs from the worked run above.

```text
ℹ Preparing workflow: hello-world-nextflow.lungfishflowpkg/main.nf
ℹ Dry run - workflow would execute with:
  Workflow: hello-world-nextflow.lungfishflowpkg/main.nf
  Results: ./results
  Executor: docker
  Parameters: 0
```

Two environment variables move LGE's storage off the user's home folder, which matters on a runner where the home folder is not cached but a scratch folder is. A scratch folder is temporary space the runner lets a job write to and discards afterwards. An environment variable is a named value the shell hands to every program it starts. `LUNGFISH_CONDA_ROOT` sets the folder holding conda environments, and `LUNGFISH_STORAGE_ROOT` sets the folder holding everything else LGE manages, which is the conda environments, the downloaded classification databases, and the managed tool installs. Those databases are the bulk of it, and a Kraken2 viral database alone runs to several gigabytes.

LGE reads the two together, and setting `LUNGFISH_STORAGE_ROOT` alone moves the conda root along with it, so a job that means to keep the environments somewhere else must set both. A third variable, `NCBI_API_KEY`, is worth setting on any job that fetches records from NCBI, because unkeyed requests are rate limited and a shared CI address exhausts that allowance quickly. NCBI issues a key from the account settings page of an NCBI account, and the key belongs in the CI service's own secret store rather than in the workflow file.

Setting one looks like this. The `export` command hands the value to every program the job starts afterwards, and `$RUNNER_TEMP` reads back a value GitHub Actions supplies for you, naming the runner's scratch folder. That variable is specific to GitHub Actions, and CircleCI has its own.

```bash
export LUNGFISH_CONDA_ROOT="$RUNNER_TEMP/lungfish-conda"
```

`--format json` is declared on almost every command, and asks for output as JSON, a text format that stores named fields so a program can read one value without matching printed words. Many commands accept the flag and print their ordinary text anyway. `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, and `version` all did so on the 2026.9.13 build. Check the output of any command before a CI step parses it. `tools update` is the exception worth knowing, since it carries its own `--json` flag.

## Offline packs, and the flag that does not mean what it says

An offline pack suits a job that must run without network access, or one where a full tool install is too slow to repeat. Build it on a machine that already has the pack installed, which you do with `lungfish-cli conda install --pack <id>` on your own machine first.

```bash
lungfish-cli conda offline-export \
  --pack metagenomics \
  --output .ci/lungfish-conda-packs
```

`--output` names the directory the pack directory is written into, not the pack directory itself. Exporting the `gatk-core` pack for this appendix exited 0 and made the relationship plain.

| What you pass | What you get |
|---|---|
| `--output ./packs-gatk` | `./packs-gatk/gatk-core-conda-offline-pack` |

Inside that pack directory sit two records. `offline-pack-manifest.json` holds the pack id, the source conda root, the exporting command line, and a SHA-256 checksum and byte size for every file in the exported environments. A manifest is an index file listing what a package contains, and a checksum is a short fingerprint computed from a file's contents, so a file that fails to match its recorded checksum has changed since the pack was built. The `.lungfish-provenance.json` beside it records the export as an operation, naming the pack and the output paths. A filename beginning with a dot is hidden in the Finder, so use the Terminal to list either of them.

Install the pack inside the job, pointing at the pack directory the export created.

```bash
lungfish-cli conda offline-install \
  .ci/lungfish-conda-packs/metagenomics-conda-offline-pack \
  --conda-root "$LUNGFISH_CONDA_ROOT" \
  --overwrite
```

`--overwrite` replaces environments whose names already exist, which is what a re-run of a job that restored a cache meets immediately. Without it, a second run against a restored cache fails on environments the first run already created.

Pack ids are fixed strings, and passing one that does not exist is a clean early failure rather than a confusing one. Asking for a pack named `classification`, which does not exist, exited 3 and listed the ones that do.

```text
✗ Unknown tool pack: classification
Available packs: lungfish-tools, read-mapping, full-length-mhc-genotyping,
variant-calling, assembly, multiple-sequence-alignment, phylogenetics, metagenomics
```

Those eight ids map to kinds of work as follows, which is how a CI author picks one. Kraken2 is the read classifier LGE uses to say which organism each read came from, and it lives in the metagenomics pack.

| Pack id | The work it serves |
|---|---|
| `lungfish-tools` | The base tools LGE needs before a project opens at all. |
| `read-mapping` | Mapping reads to a reference with minimap2, bwa-mem2, or bowtie2. |
| `variant-calling` | Calling variants from an alignment track. |
| `assembly` | Assembling a genome from reads with no reference. |
| `metagenomics` | Classifying reads by organism with Kraken2 and Bracken. |

The remaining three, `full-length-mhc-genotyping`, `multiple-sequence-alignment`, and `phylogenetics`, name their work in their ids.

Ten further ids are accepted by `offline-export` even though the error message omits them, because the id lookup searches the whole built-in pack list while the message prints only the eight the CLI shows. Three of them, `gatk-core`, `phasing`, and `wastewater-surveillance`, are real packs the tool lock manifest defines and are the ones worth knowing, and they are safe to use. The rest name environments the build does not install, so an export of one fails on a missing environment rather than on the id.

An offline pack carries tools and not databases. A classification workflow needs both, so a job that classifies reads also runs `lungfish-cli conda db download <name>` for a catalogue database such as Viral, or `lungfish-cli conda db install-managed <identifier>` for a managed one, meaning a database LGE fetches and prepares from a named upstream source rather than from its own catalogue. The host-depletion index is one such identifier, `deacon-panhuman`, which the project's own CI installs. Host depletion is the step that removes reads from the host organism, usually human, before the rest are classified.

Use `conda offline-export` for a plain directory. A second command, `conda export-pack`, calls the identical code and is what you reach for when you want an archive instead, since its `--output` also accepts a `.tar`, `.tgz`, or `.tar.gz` path. Those three are all compressed-archive formats, meaning one file holding a whole folder.

Do not cache a live conda root across jobs and let several jobs write to it. That happens when two jobs of the same workflow run at the same time, which CI services do by default, and both restore and then update the same cached conda root. Two jobs updating one root at once corrupt it in ways that are hard to see and harder to reproduce. An offline pack is a read-only artifact with a manifest and a provenance record, so it is the safer thing to move between machines.

## A GitHub Actions template

This file goes at `.github/workflows/lungfish-headless.yml` in your repository, and you create the `.github/workflows/` folder if it is not there. The file is written in YAML, a text format that records settings as indented `key: value` lines, where indentation is what shows which setting belongs inside which. It is a template to adapt rather than a run performed for this appendix, and it may still need edits before it runs in a real job.

Change the `LUNGFISH` path if your runner holds the program somewhere else, the runner label if GitHub has renamed it, and `pipeline.nf` and the `outputs` paths to match your own repository. Leave the rest as it is. The `${{ }}` expressions are GitHub's own boilerplate, which you copy unchanged, and `runner.temp` inside one is GitHub's name for the runner's scratch folder.

```yaml
name: lungfish-headless

on:
  pull_request:
  workflow_dispatch:

jobs:
  workflow:
    runs-on: macos-26
    timeout-minutes: 60
    env:
      LUNGFISH: "/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli"
      LUNGFISH_CONDA_ROOT: ${{ runner.temp }}/lungfish-conda
      LUNGFISH_STORAGE_ROOT: ${{ runner.temp }}/lungfish-storage

    steps:
      - uses: actions/checkout@v4

      - name: Provision the required tools
        run: |
          "$LUNGFISH" tools update --apply --yes --required-only
          "$LUNGFISH" conda install --pack metagenomics

      - name: Assert the runner matches the pinned dependency set
        run: '"$LUNGFISH" tools update --plan'

      - name: Preflight
        run: |
          "$LUNGFISH" debug env --check-tools
          "$LUNGFISH" debug container

      - name: Run the workflow
        run: |
          "$LUNGFISH" run-headless pipeline.nf \
            --results-dir outputs \
            --expected-output outputs/result.lungfishref \
            --bundle-root outputs/bundles

      - name: Upload outputs and provenance
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: lungfish-outputs
          path: outputs/
```

`uses: actions/checkout@v4` is GitHub's own step that copies your repository onto the runner, and every job needs it first.

There is no cache step in that file, and that is deliberate. This project's own CI provisions with install-and-cache rather than with offline packs, so the template provisions the same way. Caching the conda root is an optimisation to add once the job runs green without it, and GitHub's own cache documentation covers the restore-and-save pattern to add.

Three points in the file are worth stating rather than leaving to be inferred. A CI service treats any non-zero exit status as an automatic step failure, so the `tools update --plan` step fails the job on exit 10, which is what makes it an assertion instead of a report. The upload step carries `if: always()` so a failed run still yields its logs and whatever provenance was written. And the upload path is the whole `outputs/` folder, because for a bundle output the provenance file is written inside the bundle rather than beside it, as the provenance section below shows.

The 60-minute ceiling on that job is GitHub's own default rather than a figure this appendix measured. The example workflow used above finishes in under a second and tells you nothing about a real one, so time your own pipeline at a desk before you tighten or loosen the number.

## A CircleCI template

CircleCI is a second CI service, an alternative to GitHub Actions, and a repository hosted outside GitHub is the usual reason to pick it. It selects the macOS version by naming an Xcode image rather than an operating system label, so `xcode: "26.0.0"` is what asks for a macOS 26 machine. Check that tag against CircleCI's current macOS image list, since the pairing of Xcode version to macOS version changes with each release.

CircleCI splits caching into separate restore and save steps. `store_artifacts` runs as part of the step list and takes only `path` and `destination`, so to keep artifacts from a failed job put the storing step inside the job and let CircleCI's own step ordering reach it, or guard an earlier `run` step with `when: always` rather than the storing step. This is likewise a template rather than a run.

```yaml
version: 2.1

jobs:
  lungfish-workflow:
    macos:
      xcode: "26.0.0"
    environment:
      LUNGFISH: "/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli"
      LUNGFISH_CONDA_ROOT: /tmp/lungfish-conda
      LUNGFISH_STORAGE_ROOT: /tmp/lungfish-storage
    steps:
      - checkout

      - restore_cache:
          keys:
            - lungfish-conda-packs-v1

      - run:
          name: Install the cached pack
          command: |
            "$LUNGFISH" conda offline-install \
              .ci/lungfish-conda-packs/metagenomics-conda-offline-pack \
              --conda-root "$LUNGFISH_CONDA_ROOT" \
              --overwrite

      - run:
          name: Assert the runner matches the pinned dependency set
          command: '"$LUNGFISH" tools update --plan'

      - run:
          name: Run the workflow
          command: |
            "$LUNGFISH" run-headless pipeline.nf \
              --results-dir outputs \
              --expected-output outputs/result.lungfishref \
              --bundle-root outputs/bundles

      - save_cache:
          key: lungfish-conda-packs-v1
          paths:
            - .ci/lungfish-conda-packs

      - store_artifacts:
          path: outputs
          destination: lungfish-outputs
```

That template restores an offline pack from a cache, so it needs the pack committed to the repository at `.ci/lungfish-conda-packs` before the first job runs. On the very first run the cache is empty, `restore_cache` finds nothing and does not fail, the install step reads the committed pack from the checkout, and `save_cache` then fills the cache for every later run.

## Keeping the provenance

A provenance sidecar is the JSON file LGE writes to record one operation, holding what ran, what went in, what came out, and whether it worked. Keeping those files as CI artifacts is the reason to run LGE in CI at all, rather than calling the bioinformatics programs by hand and keeping no record of how.

Where the sidecar lands depends on what the output is. For the verified Nextflow run above, whose expected output was a reference bundle carrying the `.lungfishref` extension, the sidecar was written inside the bundle rather than beside it. The layout looked like this.

```text
nf-results/
  hello-world-nextflow.lungfishref/
    .lungfish-provenance.json      <- the run's own record, the one to check
    manifest.json
    provenance/
      bundle.lungfish-provenance.json   <- the bundle's record of how it was made
```

The `.lungfish-provenance.json` at the top is the run record, and it is the one a CI check reads. The copy under `provenance/` belongs to the bundle rather than to the run.

A CI artifact step that searches for files named `*.lungfish-provenance.json` beside the output will therefore find nothing, since nothing sits beside the bundle. Upload the whole results directory instead, which is what both templates above do.

The sidecar from that run carried the following.

- The workflow name, the tool name and version, and the full `argv` LGE invoked.
- The resolved options the run was given.
- A runtime identity block, holding the application version, the architecture, the operating system version, the dependency set, and the user.
- A `files` list giving every input and output a role, a SHA-256 checksum, and a byte size.
- The exit status, the start and end times, the wall time, and the captured error stream, which the terminal calls standard error.

Wall time is the elapsed clock time a run took, as a stopwatch would measure it. The error stream is the second of the two text streams a program writes, the one it uses for problems, and it has nothing to do with the statistical term of the same name.

[Provenance and Reproducibility](../01-foundations/08-provenance-and-reproducibility.md) describes these fields in full, and this appendix repeats only the ones a job reads. The record is written for a headless run exactly as it is for a run started from the window.

To read the sidecars back, `lungfish-cli ops stats <directory>` walks a folder and summarises every sidecar under it. Pointed at the results directory of the verified run it reported the following and exited 0.

```text
Operation Stats

Project            : /path/to/nf-results

Provenance sidecars: 1
Completed runs     : 1
Total wall time    : <1s
Peak RAM           : unknown

Operation                    Runs  Total  Average  Peak RAM
───────────────────────────────────────────────────────────
Run Local Nextflow workflow  1     <1s    <1s      unknown
```

Both numbers in that block need context. The wall time reads under a second because the shipped example workflow does almost no work, and a real pipeline reports minutes or hours. Peak RAM reading `unknown` is expected rather than a fault, because the local workflow adapters do not record it.

`ops stats` exits 0 even when it is given an option it does not understand, printing `Error: Unknown option '--nonsense-flag'` and a usage line in place of the table above. A CI step must therefore read the output rather than trusting the exit status, and the presence of the `Provenance sidecars:` line is the thing to check for.

`lungfish-cli provenance verify` sounds like the natural CI check on a sidecar and is not one. It verifies a signed sidecar, where signing means attaching a cryptographic signature that proves the record has not been altered since it was written. LGE signs a record only when a signer is configured, and signing is off by default. Run against the unsigned sidecar of the verified run it exited 64 with this.

```text
Error: Workflow execution failed: Signature artifact is missing:
.../hello-world-nextflow.lungfishref/.lungfish-provenance.json.signature.json
```

A CI job that has not configured a signer should therefore check the sidecar's `exitStatus` field and the presence of the declared outputs instead, reaching for `provenance verify` only once signing is set up. Reading one field from the sidecar takes one line, using the `jq` JSON reader that ships with most runners.

```bash
jq -e '.exitStatus == 0' outputs/result.lungfishref/.lungfish-provenance.json
```

## What fails, and why

Six failures account for most failed CI jobs, and each prints a message that identifies it.

The command is not found. Installed releases do not put `lungfish-cli` on the `PATH`, so a step that types the bare name on a runner that only unpacked the application will not find it. Use the full quoted path inside the application bundle, as both templates do.

The run exits 64 saying an expected output is required. This is an executed run with no `--expected-output`. Add one per scientific output, or switch the step to `--dry-run` or `--prepare-only` if it was only meant to validate.

The run reports success and no sidecar appears. The path given to `--expected-output` does not match where the pipeline actually wrote. Naming an output tells LGE where to look, and never creates it.

The pack id is rejected with exit 3. The name is not one LGE knows. Read the list the error prints, remembering that ten further ids exist which that list omits, three of them real packs.

The second run of a cached job fails on existing environments. `conda offline-install` was called without `--overwrite`. Add it.

The workflow file is not recognised. Name pipeline files in lower case, as both templates do with `pipeline.nf`. The reason is that `workflow run` accepts a lower-case `.nf` extension only, so a file named `pipeline.NF` is not seen as Nextflow. A different command, `workflow validate`, lowercases the extension before it looks and does accept the file, which is why validating a workflow can succeed where running it fails.

### Rough edges found while writing this appendix

None of the rough edges below prevents a working CI job, and none of them means a run that reported success was wrong. Each is a place where the 2026.9.13 build reports something less usefully than it could.

`--format json` is accepted and ignored by more than one command. `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, and `version` all print their ordinary text and exit 0, so none of them can be parsed reliably by a script yet.

The unknown-pack error lists eight pack ids, but `conda offline-export` also accepts ten more, including the three real packs `gatk-core`, `phasing`, and `wastewater-surveillance`.

The `wallTimeSeconds` field of the verified run's sidecar held a very small negative number rather than a duration. Only that one field is affected and the run itself was correct, so a CI check should read `startTime` and `endTime`, which are sound, and compute nothing from `wallTimeSeconds`.

The offline export's own `.lungfish-provenance.json` has an empty file list and records no reproducible command, while a workflow run's sidecar populates both. The checksums, sizes, and command line for an exported pack are in `offline-pack-manifest.json` instead.

`lungfish-cli debug env --check-tools` asks Nextflow for its version with a flag Nextflow rejects, so Nextflow answers with a complaint and LGE prints that complaint as the version. The Nextflow row of that report confirms the program is present without telling you which release it is. Every other tool row reports a real version.
