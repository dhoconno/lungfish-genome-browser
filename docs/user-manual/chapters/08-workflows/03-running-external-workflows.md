---
title: Running External Workflows
chapter_id: 08-workflows/03-running-external-workflows
audience: analyst
prereqs: [08-workflows/02-exporting-as-nextflow-or-snakemake]
estimated_reading_min: 30
task: Link a workflow package into the Workflow Library, enable it, run it against project data, and read the run bundle and provenance it leaves behind.
tags: [workflows, nextflow, snakemake, nf-core, runner, workflow-package]
tools: [nextflow, snakemake]
parameters_refs: [workflow.library-run]
entry_points:
  - "Tools > Workflow Library..."
  - "Tools > <category> > <workflow name>..."
  - "CLI: lungfish-cli workflow run"
shots:
  - id: workflow-library-linked-package
    caption: "The Workflow Library window's User Workflows heading with its Link Workflow... button, showing a linked Hello World Nextflow card whose Execution row reads Runnable."
  - id: workflow-operations-runner
    caption: "The Workflow Operations window opened from a Tools category submenu, showing its Overview, Inputs, Primary Settings, Advanced Settings, Output, and Readiness sections."
illustrations: []
glossary_refs: [checksum, container, nextflow, nf-core, plugin-pack, provenance-sidecar, run-bundle, snakemake, workflow-engine, workflow-package]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

This chapter is for a reader who already has a pipeline written by somebody else and wants to run it on data in a project. Nothing here asks you to write one. The previous chapter, [Exporting as Nextflow or Snakemake](02-exporting-as-nextflow-or-snakemake.md), took a finished run inside Lungfish Genome Explorer (LGE) and wrote it out as a pipeline somebody else could read. This chapter goes the other way. It takes a pipeline that already exists, written by your lab or by a collaborator, and runs it against data in your project. Pipeline and workflow mean the same thing throughout, a recorded series of analysis steps.

Two words carry most of the meaning here. A [workflow engine](../../GLOSSARY.md#workflow-engine) is a program that reads a description of an analysis, works out which step has to happen before which other step, and then runs them in that order. LGE speaks to two of them. [Nextflow](../../GLOSSARY.md#nextflow) describes an analysis as processes connected by the files that flow between them, where a process is one step that runs a single command, and [Snakemake](../../GLOSSARY.md#snakemake) describes it as rules, each naming the files it consumes, the files it produces, and the command in between. LGE installs and pins both engines itself, Nextflow at 26.04.6 and Snakemake at 9.25.2, so you never install or check either one, and a run does not change behaviour when a tool on your own Mac is upgraded by you or by someone else who uses it.

The second word is package. A [workflow package](../../GLOSSARY.md#workflow-package) is a folder ending in `.lungfishflowpkg` that holds a pipeline file together with a `manifest.json` describing it. Finder shows that folder as a single item, which is what you click, while LGE treats it as a folder inside. JSON is a plain-text format for structured data, and you never edit this file. The manifest is what makes the package more than a loose script. It names the pipeline, gives it a version, and declares which engine runs it, what the pipeline needs as input, and what it produces as output. Declaring means the package's author wrote those statements into `manifest.json` once, and you only read them. LGE builds the run form from those declarations, which is why a package declaring a reference bundle and a read bundle shows a reference picker and a reads picker without anyone writing that dialog. A reference bundle is a folder holding a genome sequence LGE can measure reads against, saved with the extension `.lungfishref`. A read bundle is a folder holding one sample's sequencing reads, saved with the extension `.lungfishfastq`, and the window calls the same thing a FASTQ bundle.

There are two ways to reach this chapter's material, and it is worth knowing which is which before you start. **Tools > Workflow Library...** is where a package is linked and switched on. It does not run anything. Once a workflow is switched on, choosing its item in the Tools submenu for its category opens the **Workflow Operations** window, which is where a run is configured and started. The command line reaches the same engines through `lungfish-cli workflow run`, which takes a pipeline file directly and does not use a package at all. That route is optional, and the window route in this chapter is complete without it.

One workflow in this area is a special case, and you can skip this paragraph unless you work on viruses. LGE supports exactly one published [nf-core](../../GLOSSARY.md#nf-core) pipeline, `nf-core/viralrecon`, fixed at release 3.0.0 so results do not shift between runs, and it has its own window and its own chapter in [Viral Recon Wizard](../04-alignments/05-viral-recon-wizard.md). Use that chapter for the Viral Recon route. On the command line the same pipeline is named as either `nf-core/viralrecon` or `viralrecon`.

So the thing to do with all of this is to decide which of the two routes you want. If you have a `.lungfishflowpkg` and want it in the app's menus, start at the Workflow Library. If you have a bare `.nf` file, which is a Nextflow pipeline, or a file named exactly `Snakefile`, which is the Snakemake one, and you want to run it once, go to the command line at the end of this chapter.

## Why you would do this

A colleague has a Snakemake workflow that does something LGE does not do. Perhaps it computes a summary statistic your field uses and nobody else does, or it calls a tool LGE does not ship. You could run it in a terminal outside LGE, meaning a window where you type commands rather than click, and it would work. You would then hold a result file with nothing attached to say what produced it. The window route in this chapter needs no terminal at all.

Running the same pipeline through LGE gives you that record. Every run writes a [run bundle](../../GLOSSARY.md#run-bundle), a `.lungfishrun` folder holding the exact command, the engine, the exit status, the timing, and a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar). An exit status is the number a program reports when it finishes, where zero means success and anything else means it stopped early. A sidecar is a small companion file written next to a result file, and this one is a JSON file recording the [checksum](../../GLOSSARY.md#checksum) of every file that went in and came out. A checksum is a short fingerprint computed from a file's exact bytes, so two people can confirm later that they are holding the identical file. Six months on, that folder answers the question the terminal run cannot, which is which files and which command produced this result.

The second reason is that a packaged workflow becomes something the rest of your group can use without reading its source. Once a package is linked and enabled, it is a menu item with a form, and a person who has never seen Snakemake can run it correctly.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. Any name and any writable folder will do. A project is required even for the example packages here, because the Workflow Operations window draws its pickers from an open project.

This chapter uses the two example workflow packages that ship inside LGE, `hello-world-nextflow.lungfishflowpkg` and `hello-world-snakemake.lungfishflowpkg`. They are not in the manual's fixtures folder. They live in the project's public page on GitHub, where the source lives, under `Examples/WorkflowPackages/`. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `Examples/WorkflowPackages/`. The download lands in your Downloads folder and unpacks into a folder named for the repository, holding the whole source tree. Drag the two packages into your Documents folder, or anywhere else you will not lose them, because a linked package stays where it is rather than being copied into the project, and moving or deleting that folder later breaks the link.

Each package runs one step, deliberately. Both ignore the input you give them on purpose, because they exist to prove the whole path works, from linking a package to reading its provenance, before you trust that path with a pipeline that takes an hour. The Nextflow package writes a FASTA file of four bases, deliberately tiny so the run finishes in about two seconds, and wraps it as a `.lungfishref` reference bundle with a manifest and an index. An index is a small companion file that lets a program jump straight to a position in a large file without reading the whole thing. The Snakemake package writes the same four-base FASTA and a near-empty manifest into a folder of the same shape.

Neither package needs Docker or Apple Containers, and nothing in this chapter asks you to install a container runtime. Both manifests ask for no [container](../../GLOSSARY.md#container) at all, which the manifest writes as a runtime kind of none. A container is a packaged copy of a program together with everything it needs to run, so it behaves the same on every machine. Both packages also carry an `environment.yml` naming Python 3.10, which would name the conda environment a package used if it needed one, where conda is a tool that installs a program together with its own private copies of what it depends on. Neither of these two uses it, and you need no Python install for this chapter.

Two things must be selected in the project sidebar before you open the run window, because the window fills its pickers from that selection. Select one reference bundle from `Reference Sequences/` and one read bundle from `Imports/`. Any of each will do, since these packages ignore what you give them, and a freshly created project has neither, so import a read bundle and a reference bundle first if the folders are empty.

## Procedure

### 1. Link the package into the Workflow Library

Choose **Tools > Workflow Library...**. Scroll to the **User Workflows** heading and click the **Link Workflow...** button beside it. A file chooser opens, titled Link Workflow Package, with a button reading **Link Workflow** and a message stating that the package stays at this location and that linking an existing workflow identity replaces its prior source and version. A workflow's identity is the `id` string written in its `manifest.json`. Relinking a package carrying an id already in the library replaces the old entry's recorded source path and version and keeps whatever enablement you had set, and because the package is never copied, moving or deleting the folder afterwards breaks the link.

The chooser accepts folders rather than files, so the package appears there as a single item you can select. Click `hello-world-nextflow.lungfishflowpkg` once and click **Link Workflow**. A card appears under the User Workflows heading, grouped by the category its manifest declares, which for these two is **Templates**. That category name does double duty, as the group heading here and as the name of the Tools submenu the workflow lands in once it is enabled. The card lays out the manifest's contract as labelled rows.

- The declared input bundle types, here a reference bundle and a read bundle.
- The declared output bundle type, here a reference bundle.
- The runtime kind, which is none for both example packages.
- The plugin packs the manifest requires, here the one carrying the engines.
- An **Execution** row reading either **Runnable**, meaning the workflow can be switched on, or **Catalog only**, meaning it can be read but never run.

That last row decides whether the workflow can be switched on at all. In this build a package is Runnable only when it meets four conditions together. Its runner must be Nextflow or Snakemake. Its manifest must declare a required `.lungfishref` input, holding a reference genome. It must declare a required `.lungfishfastq` input, holding sequencing reads. And it must declare at least one output. Anything else is catalogued and readable but not runnable, which includes every command-runner package, meaning a package whose manifest names a plain shell command rather than one of the two engines. Both hello-world packages meet the contract, so both read Runnable.

<!-- SHOT: workflow-library-linked-package -->

### 2. Enable the workflow

Every linked workflow is listed in the Tools submenu for its category from the moment it is linked. Until you enable it, it sits there greyed out with the words "(not enabled)" after its name, and choosing it in that state runs nothing and instead raises a message offering to open the Workflow Library at the right card. Turning the card's **Enabled** switch on is what makes the item live.

You need to install nothing for these two examples. Both require the `lungfish-tools` [plugin pack](../../GLOSSARY.md#plugin-pack), which is the Required Setup pack LGE installs on first launch before you can create or open a project at all, and it is the pack that carries Nextflow and Snakemake themselves. A plugin pack is a themed group of tools LGE downloads on demand into its own private storage, so nothing is added to the rest of your Mac. If a card's dependency row ever says a pack is missing, install it from **Tools > Plugin Manager...** (Cmd-Shift-B) before enabling that workflow.

### 3. Open the workflow and set its inputs

With the reference bundle and the read bundle selected in the sidebar, choose the workflow from its Tools category submenu, here **Tools > Templates > Hello World Nextflow...**. The **Workflow Operations** window opens, subtitled "Run enabled specialized and user workflows", where a specialized workflow is one built into LGE rather than linked from a package. It has six sections in a fixed order, Overview, Inputs, Primary Settings, Advanced Settings, Output, and Readiness. Overview names the workflow and its version, Primary Settings holds the Output Name and Cores fields, and Output holds the results directory.

The Inputs section holds the pickers the manifest asked for. For these two packages that is a **Reference** picker, listing the reference bundles already in the open project and offering a Choose button for anything elsewhere, and a **FASTQ Bundles** list holding what you selected in the sidebar. A linked workflow package accepts exactly one read bundle. Select more than one and the Readiness line reads "Imported workflow packages currently accept one FASTQ bundle. Select one bundle, or choose a built-in workflow for folder batches." Run the bundles one at a time when you have several libraries, where a library is one prepared sample's reads.

The Advanced Settings section for a linked package is read-only text rather than controls, so there is nothing to click or type there. The manifest fixes these values, and the section simply restates the declared inputs, outputs, and runtime so you can confirm what the package promised without leaving the window.

<!-- SHOT: workflow-operations-runner -->

### 4. Check the Readiness line and run

The Readiness section carries one line of text describing whether the configuration can be launched, and it reads exactly "Ready to run." when everything it needs is set. The **Run** button stays disabled until that line reads those words, so read the line first. When something is missing, the line names the missing thing instead, for example "Select a reference bundle or FASTA file." When a run cannot start after you click Run, an alert headed Workflow Operation Error names the reason.

Progress appears in the Operations panel, which you open with **Operations > Show Operations Panel** (Cmd-Shift-P). A successful run of either example package leaves one row there whose status column reads **Completed**, and the two reference runs behind this chapter took two seconds for the Nextflow package and nine seconds for the Snakemake one. A run that stops early reads **Failed** instead, and its row carries the error message. Right-clicking a finished workflow row offers **Run Again...**, which reopens the window with the original package, inputs, and core count locked so a repeat run reproduces the recorded one exactly.

## Settings

The Workflow Operations window generates its form from the linked package's manifest, so a package declaring different inputs shows different pickers than the ones described here. The settings below are the ones the two hello-world packages produce.

**Enabled.** Turns a linked package into a runnable entry in its Tools category submenu. The default is off, so a freshly linked package is catalogued and listed greyed out until you say otherwise. Turn it on once for each package you intend to run, and off again to hide a workflow you no longer use without unlinking it, remembering that a package whose card reads Catalog only cannot be enabled at all. This setting has no command-line flag.

**Reference.** Supplies the reference bundle the package manifest declares as a required input, chosen either from a popup listing the reference bundles already in the open project or with a Choose button that reaches any other location. There is no default, so the picker starts empty. Change it whenever the run should be measured against a different genome, for example a newer assembly of the same organism. On the command line this is `--input`.

**FASTQ Bundles.** Supplies the sequencing reads the package manifest declares as a required input, accepting one `.lungfishfastq` bundle for a linked package. The default is whatever was selected in the sidebar when the window opened. Change it when a different library belongs in this run, and run the bundles one at a time when you have several. On the command line this is `--input`.

The command line uses one flag for both of those pickers, repeating `--input` once per input rather than giving each input its own flag, which is why the same flag name appears in two settings above.

**Include subfolders.** Adds every eligible bundle found in folders beneath the one you selected. The default is off, and the checkbox appears at all only when the selected folder has subfolders holding bundles, so a missing checkbox means the folder you chose has none rather than that the feature is gone. Turn it on when a run folder groups its libraries into per-sample subfolders and you want all of them. This setting has no command-line flag.

**Output Name.** Names the result the run writes, accepting any text that is not blank. The default is derived from the package name and the selected inputs, which is usually what you want. Change it when a second run of the same package on the same inputs would otherwise collide with the first, and note that the field is disabled during a Run Again so a repeat run cannot silently overwrite or rename the original result. This setting has no command-line flag.

**Cores.** Sets how many processor cores the workflow engine may use, accepting integers of one or more. The default is the app's own thread count, sized to your Mac from the core count Apple menu > About This Mac reports, and most people should leave it alone. Lower it to keep the machine responsive while a long pipeline runs, and raise it on a machine with cores to spare, bearing in mind that Snakemake honours this value as its `--cores` setting while Nextflow only records it and does not limit anything by it. The field is disabled during a Run Again, because a repeat run must reuse the recorded core count. On the command line this is `--cpus`.

**Directory.** Chooses where the run writes its results, accepting any writable directory. The default is a fresh directory under the project. Change it when the results belong on a different volume, for example one with more free space, and note that a Run Again always uses a fresh output directory so the original run stays untouched. On the command line this is `--results-dir`.

### Command-line only settings

The fifteen flags below belong to `lungfish-cli workflow run` and have no control in the window. If you work in the LGE window, skip to [Reading the results](#reading-the-results), because nothing here changes what the window does.

**`--executor`.** Chooses the execution profile for an nf-core run, with `docker`, `conda`, and `local` accepted. The default is `docker`, and it is the only profile LGE genuinely exercises, because every container runtime it knows about, Apple Containerization included, is mapped onto the same Docker profile string. It does not apply to this chapter's examples, which need no container runtime at all, and it reaches only the Viral Recon route covered in its own chapter. This flag is ignored for a local `.nf` file or `Snakefile`, since a local file carries its own engine configuration.

**`--expected-output`.** Names a scientific output so LGE knows which finished file to fingerprint with a provenance sidecar once the run succeeds, and it may be repeated once per output. There is no default, and at least one is required for an executed run. Declare every final output you care about, remembering that naming an output tells LGE where to look rather than making the workflow create it. This flag is the setting.

**`--param`.** Supplies one workflow parameter as `key=value`, repeated once per parameter. There is no default. Use it for the handful of parameters a run overrides, and switch to a file once the list grows past a few. This flag is the setting.

**`--params-file`.** Loads workflow parameters from a JSON or YAML file instead of one flag per parameter. There is no default. Use it when a run takes many parameters or when the same parameter set is shared between runs, since a file can be version-controlled and a shell line cannot. This flag is the setting.

**`--memory`.** Records a memory ceiling, written in the engine's own style such as `8.GB`, where the dot is the engines' own spelling rather than a typo. There is no default. Set it when you are recording the resources a run was meant to have, and understand that the local Nextflow and Snakemake adapters do not enforce it, while an nf-core run turns it into the pipeline's `max_memory` parameter. This flag is the setting.

**`--workdir`.** Names the working directory for the engine's scratch files, meaning the temporary files it deletes after the run, also written `-w`. There is no default. Set it when those files belong somewhere other than beside the results, noting that it reaches Nextflow as `-work-dir`, because Nextflow's own options take a single dash, while a local Snakemake run keeps it in the run history with no matching launch option, since Snakemake works inside the results directory. This flag is the setting.

**`--resume`.** Continues a repeated run from the last checkpoint rather than starting over. The default is off. Turn it on when a long Nextflow pipeline failed partway and the completed steps are still valid, and expect nothing from it on a local Snakemake run, which keeps the flag in the run history without a matching launch option. This flag is the setting.

**`--repeat-from`.** Validates an original `.lungfishrun` bundle before starting a fresh attempt, and it is the command-line counterpart of the window's Run Again. There is no default. Use it to repeat a recorded run rather than retyping its options, and pass the same settings the original run used, since it refuses the attempt when they differ. This flag is the setting.

**`--bundle-root`.** Chooses the parent directory that receives the new `.lungfishrun` bundle. The default is the current directory, so a run started from a random folder leaves its bundle there. Point it at a folder you keep, since the bundle is the durable record of the run. This flag is the setting.

**`--bundle-path`.** Sets the exact `.lungfishrun` bundle path to create or update, instead of letting the name follow the workflow file. There is no default. Use it when a script needs to know the bundle path in advance rather than discovering it from the command's output. This flag is the setting.

**`--dry-run`.** Validates the workflow and prints the plan without executing it. The default is off. Use it to confirm that a workflow parses and that the executor and parameter count are what you expect, before committing to a run. This flag is the setting.

**`--prepare-only`.** Creates the run bundle and the command preview without launching the engine. The default is off. Use it when you want the exact command LGE would run, in order to inspect it or run it yourself, and note that it is the one flag that waives the expected-output requirement. This flag is the setting.

**`--timeout`.** Sets a maximum execution time in minutes, and it currently has no effect on a local run. There is little reason to set it, because the local runner accepts it and does not enforce it, and an nf-core run rejects it outright with the message that `--timeout` is not supported for nf-core/viralrecon runs yet. This flag is the setting.

**`--format`.** Chooses the output format of `workflow run`, `workflow list`, and `workflow validate`, with `text`, `json`, and `tsv` accepted. The default is `text`, which is the human-readable form. Switch to `json` when a script needs to read the result rather than a person. This flag is the setting.

**`--nf-core`.** On `workflow list`, prints the one supported nf-core pipeline. The default is off, and without it the command prints a usage hint rather than a project inventory. Pass it when you want to confirm which nf-core release this build is fixed to. This flag is the setting.

## Reading the results

Every run writes a `.lungfishrun` bundle. A run started from the window puts it under the results directory the Output section named, and a run started from the command line puts it in the current directory under the workflow file's name unless `--bundle-root` says otherwise, so a first command-line run of `main.nf` produces `main.lungfishrun` and a second produces `main-2.lungfishrun` rather than overwriting the first.

The bundle holds four things worth knowing about. LGE does not display them inside the app, so open them in TextEdit or any other text editor.

`manifest.json` is the record of the run itself. It carries `engine`, `executionStatus`, and `exitCode`, the full `commandPreview` string LGE assembled, the `params` it passed, and a `statusHistory` list with a timestamped entry for each state the run passed through. A completed Snakemake run of the example package records three of them, `prepared`, `running`, and `completed`, seconds apart. The final state is what matters, and the count of entries is not something to check.

The `logs/` folder holds `stdout.log` and `stderr.log`. The Nextflow example's `stdout.log` is short and ends `[SUCCESS] completed=1 failed=0 cached=0`, after naming the pipeline, the work directory, and the one process it ran. Cached counts steps skipped because their result already existed from an earlier run, so a nonzero count there is fine. Its `stderr.log` is empty. This is the first place to look when a run fails.

`replayIdentity` inside the manifest is the section of that JSON file that makes Run Again possible. It records a SHA-256 checksum and byte size for every file in the package, so a repeat run can confirm it is running the same pipeline rather than an edited copy. SHA-256 is simply the kind of checksum LGE uses everywhere, and there is no choice to make about it. For the Nextflow example that is four files, `README.md`, `environment.yml`, `main.nf`, and `manifest.json`, alongside a copy of the package manifest itself.

The `provenance/` folder holds the provenance record for the bundle. LGE signs that record when a signer is configured and leaves it unsigned otherwise, and signing is off by default and covered elsewhere in this manual. Separately, and this is the part that matters most, each path you named with `--expected-output` receives its own `.lungfish-provenance.json` sidecar once the run succeeds, written beside the output when it is a plain file and inside it at the bundle root when the output is a bundle, as both examples here are. That sidecar carries the full `argv` LGE invoked, the `exitStatus`, start and end times, and a `files` list giving every input and output a role and a SHA-256 checksum.

## What good looks like

A run can finish without producing the files you wanted, so four checks separate a run that worked from one that merely stopped.

The exit status is the first and the quickest. In the window, the Operations panel row's status column should read **Completed**. On the command line, `manifest.json` should carry `"executionStatus": "completed"` and `"exitCode": 0`, and the command itself should have exited zero. Partial files can look usable when they are not, so a nonzero exit with output files present is worse than no output at all.

The declared outputs should exist and carry sidecars. Look for the paths you named with `--expected-output` and confirm each has a `.lungfish-provenance.json`, at the bundle root for a bundle output and beside the file otherwise. An output that exists without a sidecar means the run did not reach the provenance step. An output that is missing entirely, with the run reporting success, means the workflow never wrote what you declared, since naming an output does not create it.

The logs should end the way a successful engine ends them. A Nextflow run's `stdout.log` ending in `failed=0` is the signal, and any process reported as failed is the thing to read next in `stderr.log`.

Last, the output should be the shape you expected. Both example outputs are correct as shipped, including the sparse one. The Nextflow example writes `hello-world-nextflow.lungfishref` holding `genome/sequence.fa`, a `.fai` index beside it, and a `manifest.json` describing a single four-base contig named `hello`. The Snakemake example writes `hello-world-snakemake.lungfishref` holding a `sequence.fasta` of the same four bases and a manifest that is an empty JSON object, written `{}`, meaning it describes nothing about the sequence it sits beside. That difference between the two is real rather than a mistake in this manual, and it is a useful reminder that a package's output is only as complete as its author made it.

### Known defects in this release

Three defects found while testing this chapter against Preview 2026.9.13 are worth knowing, and none of them stops the procedure above.

The error LGE raises when an executed run names no output recommends "Use `--prepare-only` or `--dry-run` for planning-only runs", but only `--prepare-only` waives that requirement in the check itself. In practice `--dry-run` still works for planning, because the command returns before the check ever runs, so the advice holds even though the check does not implement it.

`workflow run` recognises a Nextflow file by a lower-case `.nf` extension only, so a file named `pipeline.NF` is not detected as Nextflow, while `workflow validate` lowercases the extension first and does detect it. Name your pipeline files in lower case and neither command will surprise you.

The Snakemake example package declares its output as a `.lungfishref` reference bundle but writes a manifest of `{}`, so that output would not open as a usable reference bundle. Nothing in LGE checks a package's output against the bundle type its manifest declared, so this is an incompleteness in the shipped example rather than a fault in the app.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, apart from running a bare pipeline file that is not wrapped in a package, which only the command line offers. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application.

Terminal is in the Utilities folder inside Applications, and Spotlight finds it if you press Cmd-Space and type its name. Every command below is typed at the prompt, followed by the Return key, from the folder that holds the package, which you reach by typing `cd` and then dragging that folder onto the Terminal window. `lungfish-cli` is the command-line copy of LGE and it arrives with the app. Where a command below is split across lines, the trailing backslash means the command continues on the next line, and you may type it all on one line instead.

The command line does not use a package. It takes a pipeline file directly rather than a `.lungfishflowpkg`, and it picks the engine from the file name. A lower-case `.nf` extension means Nextflow, and a file name containing `snakefile` in any case means Snakemake. Nothing else is accepted, and the case rule differs between `workflow run` and `workflow validate`, as the Known defects section above describes.

For local workflows LGE first uses a managed engine if one is installed, and otherwise falls back to whatever it finds on the `PATH`, which is the list of folders your Mac searches for programs. Launching a workflow never installs a missing engine, so install the Required Setup pack first if neither engine is present.

Start by confirming the pipeline parses.

```bash
lungfish-cli workflow validate hello-world-nextflow.lungfishflowpkg/main.nf
lungfish-cli workflow validate hello-world-snakemake.lungfishflowpkg/Snakefile
```

Each prints the detected engine and then `✓ Workflow syntax appears valid`. That check reads the file's syntax only. It does not check that the tools the pipeline calls exist or that its inputs are present, which is why the wording is cautious. A file that fails prints the engine's own parse error instead of the tick. Passing `--format json` returns the same answer in machine-readable form for a script to read.

Next, see the plan without running it. A prepare-only run creates the bundle and the command preview and stops there.

```bash
lungfish-cli workflow run hello-world-nextflow.lungfishflowpkg/main.nf \
  --results-dir ./nf-results \
  --prepare-only \
  --bundle-root ./bundles
```

Then run for real. An executed run needs at least one `--expected-output`, and without one the command refuses to run and reports the number 64, which like any nonzero number means it did not start, along with a message saying an expected output is required.

```bash
lungfish-cli workflow run hello-world-nextflow.lungfishflowpkg/main.nf \
  --results-dir ./nf-results \
  --expected-output ./nf-results/hello-world-nextflow.lungfishref \
  --bundle-root ./bundles
```

The Snakemake package runs the same way, with one difference in the output path. Its `Snakefile` writes into a `results/` subfolder of its own, so the path you pass to `--expected-output` sits one level deeper. That path must match exactly where the pipeline writes, or the run reports success with no sidecar.

```bash
lungfish-cli workflow run hello-world-snakemake.lungfishflowpkg/Snakefile \
  --results-dir ./smk-results \
  --expected-output ./smk-results/results/hello-world-snakemake.lungfishref \
  --bundle-root ./bundles \
  --cpus 2
```

Each run prints the assembled engine command before it launches, which is the fastest way to see what LGE actually did. The Snakemake command above becomes `snakemake --snakefile <path> --directory <results-dir> --cores 2 --config outdir=<results-dir>`, so `--results-dir` reaches Snakemake twice, once as its working directory and once as a config value. That second use matters only to a pipeline written to read it, and these examples do not.

A repeat run must pass the same settings the original run recorded. To repeat one, pass its bundle to `--repeat-from`. LGE validates the bundle first and refuses the attempt when the settings differ, which is why the `--cpus 2` set by the Snakemake command above is repeated below rather than dropped.

```bash
lungfish-cli workflow run hello-world-snakemake.lungfishflowpkg/Snakefile \
  --repeat-from ./bundles/Snakefile.lungfishrun \
  --results-dir ./smk-repeat \
  --expected-output ./smk-repeat/results/hello-world-snakemake.lungfishref \
  --bundle-root ./bundles \
  --cpus 2
```

Omitting the `--cpus 2` produces `Error: Retained settings changed. Restore the original settings or start a new configuration.` rather than a run.

Three more commands complete this section. `lungfish-cli run-headless` is the same command as `workflow run` with less printed output, useful inside a script, since it prints the bundle path and nothing else. `lungfish-cli workflow list` prints the single supported nf-core pipeline when given `--nf-core`, and the name is misleading, because without that flag it prints a usage hint rather than a project inventory. And `lungfish-cli ops stats` reads back the sidecars under a folder and summarises them, where the angle brackets in `ops stats <directory>` mean you substitute your own path. Pointed at the folder holding this chapter's bundles it reports the count of sidecars, the completed runs, total wall time, and a per-operation table naming `Run Local Nextflow workflow` and `Run Local Snakemake workflow` with their run counts. Peak RAM reads `unknown` for these runs, which is expected rather than a fault, since the local adapters do not record it. Note that `ops stats` reports an unknown option and still exits zero, so a script must read its output rather than its exit status.

```bash
lungfish-cli run-headless hello-world-nextflow.lungfishflowpkg/main.nf \
  --results-dir ./nf-headless \
  --expected-output ./nf-headless/hello-world-nextflow.lungfishref \
  --bundle-root ./bundles
lungfish-cli workflow list --nf-core
lungfish-cli ops stats ./bundles
```

One detail applies to Nextflow runs on external drives. Some external drives cannot hold the temporary files Nextflow keeps beside a run, so LGE tests the project's volume first and moves those files to local storage when the volume fails, passing the relocated path to Nextflow itself. Two properties are tested. The first is file locks, a way for a program to reserve a file so nothing else writes it at the same time, which some volumes refuse. The second is extended attributes, extra labels macOS stores alongside a file, which some volumes cannot hold and instead write into separate `._` companion files that Nextflow's cache then trips over. This is why a run on an external drive may write its temporary files somewhere other than beside the results. The format most affected is exFAT, which covers most drives formatted to work with both a Mac and a Windows PC, and you can check a drive's format by selecting it in Finder and choosing **File > Get Info**.

## Next

This is the last chapter in Workflows, the part of this manual covering the Workflow Builder, provenance export, and external pipelines. See the [CLI Reference](../appendices/cli-reference.md) for every command-line operation in one place, [Keyboard Shortcuts](../appendices/keyboard-shortcuts.md) for the window bindings, and [Troubleshooting](../appendices/troubleshooting.md) when a run fails.
