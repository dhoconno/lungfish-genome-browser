---
title: Exporting as Nextflow or Snakemake
chapter_id: 08-workflows/02-exporting-as-nextflow-or-snakemake
audience: analyst
prereqs: [01-foundations/08-provenance-and-reproducibility, 08-workflows/01-the-workflow-builder]
estimated_reading_min: 30
task: Export one artifact's recorded history as a Nextflow pipeline, a Snakemake workflow, a script, a methods draft, or raw JSON.
tags: [workflows, export, nextflow, snakemake, methods, provenance]
tools: [nextflow, snakemake]
parameters_refs: [provenance.export]
entry_points:
  - "File > Export > Provenance > Nextflow Pipeline..."
  - "File > Export > Provenance > Snakemake Workflow..."
  - "CLI: lungfish-cli provenance export <input> --format <format> --output <dir>"
shots:
  - id: export-provenance-submenu
    caption: "The File > Export > Provenance submenu, with the six export targets and the separator after the fourth."
  - id: export-provenance-save-panel
    caption: "The Export Provenance save panel, showing its message and a shortened folder name ending in -provenance-nextflow."
  - id: export-provenance-complete-alert
    caption: "The Provenance Export Complete alert, with its OK and Show in Finder buttons."
  - id: nextflow-export-main-nf
    caption: "The generated main.nf open in TextEdit, showing the process blocks for the selected chr20 reference bundle's import, bgzip, and samtools steps."
illustrations: []
glossary_refs: [checksum, container, methods-export, provenance, provenance-sidecar, reproducibility, snakemake]
features_refs: []
fixtures_refs: [demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

This chapter is for anyone who needs to hand a finished analysis to somebody else, whether that is a collaborator, a journal, or your own future self. It assumes no terminal experience.

Every time Lungfish Genome Explorer (LGE) runs a tool for you, it writes down what it did. A tool here is a separate analysis program that LGE installs and runs on your behalf rather than a feature inside the app, and the writing-down happens automatically with nothing to switch on. The record it writes is a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), a small JSON file that sits beside the output. JSON is a plain text format that both people and programs can read. The sidecar holds the exact command line, the tool and its version, the [checksum](../../GLOSSARY.md#checksum) of every input and output, and how long the step took. The command line is the text form of an instruction, the kind you type at a keyboard prompt rather than click, and the last section of this chapter shows you one. The tool and version is a name and number such as minimap2 version 2.31. A checksum is a short fingerprint computed from a file's exact bytes, so two people can confirm they are holding the identical file.

The **File > Export > Provenance** submenu turns that written-down history into something a person outside LGE can read or run. Six targets are available. The first four can be run by another program, and the last two are for reading. Each one writes a folder rather than a single file, so compress the folder into a zip archive before you email it. Two of the six targets are workflow engines, meaning programs that run a pipeline of tools in order on one computer or on a cluster, which is a shared set of computers that a lab or a university submits large jobs to. Nextflow is one such engine and Snakemake is another, and the two do the same job in two different styles. A shell script is a plain text file of terminal commands run top to bottom, which is the simplest of the six. In the table below, a name ending in a slash such as `provenance/` is a folder rather than a file.

| Target | Files written | Best for |
|---|---|---|
| Shell Script... (runnable) | `run.sh`, `provenance/` | Reading what LGE actually ran, one command at a time |
| Python Script... (runnable) | `reproduce.py`, `provenance/` | A group that prefers Python to shell |
| Nextflow Pipeline... (runnable) | `main.nf`, `nextflow.config`, `containers/manifest.json`, `provenance/` | Handing the run to a collaborator who already uses Nextflow |
| Snakemake Workflow... (runnable) | `Snakefile`, `config.yaml`, `provenance/` | Handing the run to a group that already uses Snakemake |
| Methods Section... (documentary) | `methods.md`, `provenance/` | Drafting the methods paragraph of a paper |
| Full Provenance (JSON)... (documentary) | `provenance.json`, `provenance/` | Feeding the machine-readable record to your own tooling |

The submenu draws a thin dividing line after the fourth item, so the four runnable targets sit above the two documentary ones. All six work.

The Nextflow and Snakemake files this chapter produces are accurate transcriptions of what ran rather than portable pipelines. Neither of them passed its own engine's validity check in the release tested here, and the section headed Known defects in this release says what breaks and why.

One thing to understand before you choose a target. The export is scoped to one artifact, not to the whole project. Select the file or bundle whose history you want, and LGE collects every earlier step that fed into it, stopping when it reaches a file nothing in the project produced, such as an imported FASTQ. When nothing is selected, LGE falls back to the run that finished most recently, which the Operations panel lists at the top. Select the artifact first, then pick the target that matches what the person receiving it needs to do.

## Why you would do this

A collaborator writes and asks how you produced a result. You could describe it in an email, which is slow to write and impossible to check. Or you could hand over a folder that names every tool, every version, and every command, in order, with the fingerprints of the files that went in and came out. The second answer takes one menu choice.

The same reasoning covers three other situations. A journal asks for the analysis code behind a figure, and the Full Provenance target gives a reviewer the machine-readable record while the Nextflow or Snakemake target gives them something to run. A manuscript needs a methods paragraph, and the Methods Section target drafts one from the versions that actually ran rather than the ones you remember installing. And six months from now you will not remember which copy of minimap2 produced a particular [BAM](../../GLOSSARY.md#bam) file, but the export will. minimap2 is the aligner that places sequencing reads onto a reference genome, a BAM file holds those aligned reads in compressed form, and a copy here means one specific compiled build of a version rather than the version number alone.

Here is the warning that belongs at the top rather than the bottom. The exported Nextflow and Snakemake files are faithful records of what ran. They are not, in the release tested for this chapter, pipelines that execute unmodified on a second machine. That release is Preview 2026.9.13, and your own copy names its version in the About window, the first item in the application menu at the left of the menu bar. Both files need edits before they will run, and the edits are a short job for somebody who already knows the engine rather than a rewrite. Treat the runnable targets as an accurate, editable starting point, and treat the documentary targets as finished.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder.

This chapter uses the demo project. Build it by following the instructions in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/demo-project, which have you create the project in the app at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and then fill it in about two minutes. The example throughout is that project's `Analyses/mapping-HG002` run, and any finished run in a project of your own works the same way. Open the sidebar's `Analyses` folder to find one.

That run mapped human reads from the HG002 chromosome 20 slice against a piece of the human reference genome with minimap2, and then processed the alignment with [samtools](../../GLOSSARY.md#samtools). HG002 is a well-characterised human genome that reference datasets are built from, mapping means placing each read at the position on the genome it came from, and samtools is the standard toolkit for handling alignment files.

What matters is that the artifact you select actually has a recorded history. LGE records provenance for files it created through a tool operation, so a mapping result, an assembly, a classification, or a download all qualify, while a FASTA you dragged in from your desktop does not. The way to test a file is to try the export. An artifact with no recorded history produces a **No Provenance Available** alert instead of a save panel, and the answer when you see it is to select a different artifact, one LGE produced.

Nothing needs installing to produce an export. Reading one back needs only a text editor, and TextEdit, which every Mac has, will do. Running one needs Nextflow or Snakemake installed on whichever machine will run it, which is the recipient's machine rather than yours. LGE does not install either engine for them, and the last section of this chapter names the versions LGE itself uses.

## Procedure

The walkthrough below exports the HG002 mapping run as a Nextflow pipeline. The same four steps produce any of the six targets, since only the menu item changes.

### 1. Select the artifact whose history you want

Click the run's folder or its result file in the sidebar, or open it so its viewport is showing. The viewport is the large central panel that displays whichever file you have selected. LGE looks at the visible viewport first and the sidebar selection second, so either route works. For this walkthrough, expand the `Analyses` folder in the sidebar on the left of the window and select `mapping-HG002` inside it.

If you skip this step entirely and nothing is selected, LGE falls back to the most recent completed run, which is convenient right after a run finishes and confusing at any other time. Selecting deliberately is the habit worth forming.

### 2. Choose the target from the menu

Choose **File > Export > Provenance > Nextflow Pipeline...**, meaning the Export item inside the File menu, then Provenance inside that, then the target. The six targets appear in the order of the table above.

<!-- SHOT: export-provenance-submenu -->

### 3. Name the folder and save it

A save panel titled **Export Provenance** appears, carrying the message "Choose a folder name for the exported reproducibility package." Its name field arrives prefilled in the form `<artifact>-provenance-<format>`. Angle brackets like those stand for names LGE fills in for you and are never typed, so selecting the mapping run and choosing Nextflow prefills `mapping-HG002-provenance-nextflow`.

Accept the prefilled name or replace it, then choose a location outside the project so the export stays separate from the data it describes. Your Desktop is a good choice. Click **Save**, which is the panel's standard Save button rather than one named Export.

<!-- SHOT: export-provenance-save-panel -->

Because the prefilled name carries the format, exporting the same artifact twice in two different formats does not collide. If a file of that same name already sits in the folder you chose, LGE refuses the export and shows an error naming the path, so rename the export or pick a different location.

### 4. Open the folder

A **Provenance Export Complete** alert appears, naming the target and the file it wrote. It carries two buttons, **OK** and **Show in Finder**. Nothing opens on its own, so click **Show in Finder** when you want to look at the folder.

<!-- SHOT: export-provenance-complete-alert -->

## Settings

This operation has three settings, all of them parts of the standard macOS save panel, plus two options that exist only on the command line. Every entry below closes with the flag that does the same job there. A flag is an option you type after a command, and those closing sentences matter only if you read the optional last section.

**Provenance.** Names the selected record's rendering target, and it has no control to set, because you chose it when you picked one of the six submenu items. There is no default for the same reason. The allowed values are Shell Script..., Python Script..., Nextflow Pipeline..., Snakemake Workflow..., Methods Section..., and Full Provenance (JSON).... Pick the one that matches what the person receiving the folder needs, meaning a runnable pipeline for a collaborator, a methods draft for a manuscript, or the raw JSON for a journal reviewer checking your analysis. On the command line this is `--format`.

**Save As.** Names the folder that receives the export. It arrives prefilled as `<artifact>-provenance-<format>`, for example `mapping-HG002-provenance-nextflow`, and the format token in that name is what keeps two exports of the same artifact from overwriting each other. Any folder name the file system accepts is allowed. Change it when two exports of the same artifact in the same format need to be told apart, such as one taken from a first mapping run and one from a rerun with different settings.

**Where.** Chooses which directory the export folder is created in. It opens at the save panel's last location, and any writable directory is allowed. Choose somewhere outside the project, and choose somewhere you can share, such as a repository checkout, when the export is going to a collaborator. Save As and Where are one thing on the command line rather than two, since `--output` takes the full location including the folder name as a single value.

Two options reach only the command line, and both belong to the `provenance verify` command rather than to the export itself. Signing is optional and off unless somebody has configured a signer for your installation, so most readers can skip both. A signature is a small file proving a record was not altered after it was written, and a public key is the matching file that lets anybody else check that proof without being able to forge one.

**--signature.** Names the signature file that `provenance verify` should check, instead of the default. The default is the file sitting beside the sidecar, so for a sidecar named `mapping-provenance.json` it is `mapping-provenance.json.signature.json`. Pass it when the signature was stored somewhere other than beside the record it signs.

**--public-key.** Names the public key file that `provenance verify` should check the signature against, instead of the default. The default is again beside the sidecar, so `mapping-provenance.json.pub`. Pass it when you received the key separately from the export, which is the safer way to receive one.

## Reading the results

Every export folder, whichever target you chose, carries a `provenance/` subdirectory alongside the file the target names. That subdirectory holds the copied records, and it is worth opening before you look at anything else, because it is the part that does not depend on how well the emitted pipeline turned out.

Inside `provenance/` sits a fresh sidecar for the export itself, recording the command that produced the folder, the input record it read, and the checksum of every file it wrote. Beside it, `provenance/source/` holds the sidecars of every earlier step that fed into the artifact, including any inside an enclosing `.lungfishref` reference bundle, which is the folder LGE stores a reference genome and its indexes in. Sidecars that came from outside the export's own directory land under `provenance/source/external/` with their original path rebuilt as a folder tree. The whole chain of earlier steps, not just the last command, is what a journal reviewer wants. The Nextflow export of the mapping run lays out like this.

```text
mapping-HG002-provenance-nextflow/
  main.nf
  nextflow.config
  containers/manifest.json
  provenance/
    source/
      mapping-provenance.json
      external/Users/.../mapping-HG002/
```

### The Nextflow export

Open `main.nf`. Everything quoted in this section is output LGE generated for you to read, and none of it is anything you type. The header comment names the run, the LGE version, the clock time the original run started, the host operating system, and the user. Below that sit the parameters, one per file the run read or wrote, with names derived from the filenames. The exact transformation lowercases the name and replaces dots and other punctuation with underscores, and it is not worth predicting, so read the file rather than guessing a name. The HG002 mapping run produced this complete block.

```groovy
params.hg002_chr20_10_0_10_5mb_r1_fastq_gz = 'HG002.chr20.10.0-10.5Mb.R1.fastq.gz'
params.hg002_chr20_10_0_10_5mb_r2_fastq_gz = 'HG002.chr20.10.0-10.5Mb.R2.fastq.gz'
params.grch38_chr20_10_0_10_5mb_fasta = 'GRCh38.chr20.10.0-10.5Mb.fasta'
params.hg002_raw_sam = 'HG002.raw.sam'
params.hg002_filtered_bam = 'HG002.filtered.bam'
params.hg002_sorted_bam = 'HG002.sorted.bam'
params.hg002_sorted_bam = 'HG002.sorted.bam'
params.outdir = './results'
```

The first three lines are the run's input files and the next four are the files it produced along the way. The `params.hg002_sorted_bam` line appears twice, which is a defect covered below rather than a copying mistake. The names are derived from filenames rather than from roles, so nothing in `params.grch38_chr20_10_0_10_5mb_fasta` announces that it is the reference. Read the file before overriding a parameter.

Below the parameters comes one Nextflow process per recorded step, so the number of processes is simply the number of commands the run recorded and it changes from run to run. The HG002 mapping run recorded five commands, so `main.nf` holds `MINIMAP2_1` followed by `SAMTOOLS_2` through `SAMTOOLS_5`. Each process carries a comment naming the tool, its resolved version, and how long that step took, then the input and output file names, then the exact command LGE ran. Each process also states where its results are written, in a `publishDir` line pointing at the `params.outdir` parameter, which is Nextflow's way of naming the results folder. Step 1's comment reads `minimap2 2.31 (managed conda environment minimap2; executable minimap2; root /Users/.../.lungfish/conda)`, which is the level of version detail the export preserves. A conda environment is the sandboxed folder LGE installs each tool into, and the three dots in that path stand in for the account name of whoever ran the analysis, so your own export shows your own username there.

<!-- SHOT: nextflow-export-main-nf -->

One qualifier. Some runs do no analysis at all and only copy a previously saved subset of reads out again byte for byte. A run made only of steps like that emits a single `REPLAY_RETAINED_SELECTION` process instead of one process per step, with a comment saying it does not rerun the upstream analysis. If you are capturing a screenshot or judging an export, use a run of ordinary operations.

`nextflow.config` is deliberately small. On a run where no step recorded a container image, which describes the HG002 mapping run because its tools came from conda environments rather than containers, it holds exactly this.

```groovy
process {
    errorStrategy = 'terminate'
}

docker.enabled = true
```

The `docker.enabled` line is harmless when no step used a container, since Nextflow only reaches for Docker when a process names an image. When any step did record a container image, a `container = null` line joins the process block. Neither case carries any cluster settings, so somebody familiar with Nextflow has to add them before the pipeline reaches a scheduler. The `errorStrategy = 'terminate'` line also means a failed run stops rather than retrying, and restarting it from the failed step takes an extra option covered in the last section.

`containers/manifest.json` lists the tool name, version, image, and image digest for every step that ran inside a [container](../../GLOSSARY.md#container), which is a packaged copy of a program together with everything it needs to run, and an image digest, which is a fingerprint of one exact build of that package. On the HG002 mapping run the file is an empty list, because every tool came from a conda environment instead. When it is not empty, the digest is recorded so a reviewer can check which image produced which output, while the process in `main.nf` still names its image by the recorded reference rather than by that digest.

### The Snakemake export

Open the `Snakefile`. Its header carries the same run identification as `main.nf`, plus a usage comment reading `snakemake --cores 8 --use-singularity`. The 8 is an editable starting number of processor cores rather than a requirement, and Singularity is a container program like Docker that clusters commonly prefer. Below that sits a `rule all` naming the run's final outputs, then one rule per recorded step, a rule being one step of the workflow with its inputs, its outputs, a log file under `logs/`, and the recorded command. Per-step isolation appears as a `singularity:` line pointing at `docker://<image>`, and only for steps that recorded a container image, so the HG002 mapping run's Snakefile carries none. This file also carries no cluster settings.

`config.yaml` holds the same filename-derived keys the Nextflow parameters use, mapped to the recorded absolute paths, plus `outdir: results`. A collaborator points one key at a file of their own when they run the workflow, like this.

```bash
snakemake --cores 8 --config grch38_chr20_10_0_10_5mb_fasta=/data/GRCh38.chr20.fasta
```

### The other four exports

`run.sh` opens with `set -euo pipefail`, a line that makes the script stop at the first command that fails rather than carrying on. Then comes an `INPUT_n` variable per recorded input with that file's SHA-256 in a trailing comment, SHA-256 being the kind of checksum described at the start of this chapter, then `OUTDIR`, then each recorded command in order with a comment naming the tool version and how long the step took. It is the easiest of the six to read if what you want is to understand what LGE did.

`reproduce.py` does the same job in Python. It differs from the shell export in how it names inputs, listing them in an `INPUTS` dictionary keyed by filename with the recorded checksum as the value, rather than as `INPUT_n` variables. Both files arrive already marked as runnable programs, which the last section explains.

`methods.md` is a short Markdown document rather than a bare paragraph. It opens with a comment reading "This is an automatically-generated draft. Read it before submitting.", then a `Methods` heading, then a `Computational Analysis` section naming each successful step's tool and version in the order they ran, then a Tool Versions table, an Input Files list with checksums, and a Reproducibility paragraph naming the LGE version and host. Only successful steps appear. The draft is genuinely a draft, and the HG002 run shows why. Its Computational Analysis paragraph names samtools four times in four nearly identical sentences, because four separate samtools steps ran, so condensing that into one sentence is editing you still have to do.

`provenance.json` is the expanded provenance record encoded as JSON, for your own tooling rather than for reading.

## What good looks like

Check three things before you send an export to anybody, and all three can be done in the LGE window and a text editor.

First, open `provenance/` and confirm it is populated. This is the part of the export that is reliably correct, and it is what backs any claim you make about the run.

Second, open the file the target named in a text editor and confirm the tool versions and the input file names look right. The versions sit in the header comment above each step in `main.nf`, the `Snakefile`, `run.sh`, and `reproduce.py`, in the Tool Versions table in `methods.md`, and in each step's record in `provenance.json`. None of them should read `unknown`, which is the word LGE writes when it never recorded a version for a step, and citing `unknown` in a methods section is worse than citing nothing. The HG002 mapping run carries no `unknown` versions, which is what a clean run looks like.

Third, if you chose Nextflow or Snakemake and the recipient intends to run it, have the file checked by its own engine before you send it. Those two checks are terminal commands, and the last section of this chapter gives them. They are optional, since the two defects they find are the same ones described just below.

### Known defects in this release

Five defects are worth knowing about, and each one is LGE's rather than a mistake you made. They were found on Preview 2026.9.13.

The emitted Nextflow pipeline does not pass Nextflow's own check, because the generated pipeline hands the first step one input file when that step declares three, so somebody familiar with Nextflow has to correct the wiring by hand.

The emitted Snakemake workflow does not pass Snakemake's own check either, because the exporter gives the `samtools flagstat` step the same BAM file as both an input and an output. The tool really does read that file, but it writes its report to the screen rather than to disk, and a step listed as producing a file it also consumes reads to Snakemake as a step waiting on itself, which it refuses to schedule.

One parameter is written twice, in four places across the exports, because two recorded steps both name the same sorted BAM file and nothing removes the repeat. It is only clutter in the Nextflow and Snakemake files, and in `reproduce.py` the second copy of the key silently replaces the first.

Every emitted command carries the absolute file paths of the machine that ran it, including a conda environment path under the original account's home folder, so none of those paths will resolve on anybody else's computer. This one is the most practically important of the five, and it follows from the export being a faithful record of what ran rather than a rewritten pipeline, so expect to redirect the paths yourself.

The `provenance verify` command described in the last section reports a failing status on a record that was simply never signed, which is the ordinary case, so a script that runs it needs to expect that.

What all this means for you is practical. The runnable targets are an accurate transcription of what ran and a good starting point, and turning one into a pipeline that executes on a second machine is editing work rather than a menu choice. If your goal is only to document the run, the Methods Section, Full Provenance, and Shell Script targets carry no such problem, and the `provenance/` folder is correct in all six.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it. It is here for readers who want to script an export or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application. Three things live only here, and they are scripting an export, printing a bibliography of the tools that ran, and checking a signature.

Terminal is in the Utilities folder inside Applications, and Spotlight finds it if you press Cmd-Space and type its name. Every command below is typed at the prompt, followed by the Return key, from the folder that holds the export or the project, which you reach by typing `cd` and then dragging the folder onto the Terminal window. `lungfish-cli` is the command-line copy of LGE and it arrives with the app.

Scripting an export is the one thing the menu cannot do, and this is the command that does it.

```bash
lungfish-cli provenance export ./Analyses/mapping-HG002 \
  --format nextflow \
  --output ./mapping-HG002-provenance-nextflow
```

A trailing backslash continues one command over several lines, so the three lines above are typed as one instruction. A path beginning with `./` is read from the folder you are currently in. The input argument takes a provenance sidecar file, a bundle, or an output directory, and pointing it at the run's folder covers all three cases. `--format` accepts the same six targets the submenu offers, named `shell`, `python`, `nextflow`, `snakemake`, `methods`, and `json`. `--output` names the folder to create. The command prints the primary file it wrote and then one line per record it copied, which is a quick way to see the chain of earlier steps the export captured.

Two related commands have no menu equivalent at all. The second word after `lungfish-cli` names which of them you want.

```bash
lungfish-cli provenance bibliography ./Analyses/mapping-HG002
lungfish-cli provenance verify ./Analyses/mapping-HG002
```

`bibliography` reads a bundle's provenance and prints a citation for each tool that ran, which is the companion the Methods Section target does not include. On the HG002 mapping run it emitted two entries, one for minimap2 and one for SAMtools, each with authors, title, journal, year, DOI, and project URL. A DOI is the permanent identifier of a published article, the string a journal prints on the first page. Run it alongside a methods export and you have both halves of what a manuscript needs.

`verify` checks a signature over a provenance record. Signing is optional and nothing sets it up by default, so on an ordinary installation this command has nothing to check and says so. What you see is `Error: Workflow execution failed: Signature artifact is missing`, followed by the name of the file it looked for, and the command exits with a failing status. That is the expected result for an unsigned record rather than a failed check, and it is the fifth defect listed above. When a signer has been configured, LGE signs each generated export artifact, writes a `.signature.json` and a `.pub` beside it, and verifies locally at export time.

Three terminal instructions from earlier sections belong here. To have the emitted files checked by their own engines, run these from inside the export folder.

```bash
nextflow lint main.nf
snakemake --dry-run --cores 1
```

On the HG002 mapping run, `nextflow lint` reported one error and eleven warnings. Only the error stops a run, and it reads `Incorrect number of call arguments, expected 3 but received 1`, which is the Nextflow defect described above. The warnings are advisory, and ten of the eleven are the same defect showing up a second way, as inputs the pipeline declared and then never used. Snakemake's dry run stopped with `CyclicGraphException in rule samtools_5`, which is the Snakemake defect. To restart a Nextflow run from the step that failed rather than from the beginning, add `-resume` to the run command, as `nextflow run main.nf -resume`. `run.sh` and `reproduce.py` arrive already marked as executable, meaning the file system flags them as programs, so `./run.sh` and `./reproduce.py` start them without a `chmod` command first.

Two version numbers matter if the export is going to be run. LGE ships Nextflow 26.04.6 and Snakemake 9.25.2 in its managed tool list, and those are the versions this release was built and tested against. Older and newer engines were not tested, so a collaborator on a very different version may meet syntax theirs does not know. The Nextflow check above ran on that pinned 26.04.6. The Snakemake check ran on Snakemake 8.26.0, which was the copy installed on the test machine, so the cyclic-graph result is worth reconfirming on 9.25.2 before you rely on the version number.

One last command belongs here, with a caution attached. If a collaborator wants the same tool environment rather than the same commands, you can export the requested package list for a plugin pack. The Plugin Manager, at **Tools > Plugin Manager...**, lists the pack names.

```bash
lungfish-cli conda lock --pack read-mapping --output read-mapping-spec.json
```

Read the subcommand's own overview before you rely on it, because it says plainly that this is a requested environment specification and not a resolved lock. Those are two different things. The requested list records which packages were asked for by name, while a resolved lock would record exactly which build of each one got installed. This file is the first kind, so it cannot be used to rebuild the identical environment. A collaborator installs the same pack with `lungfish-cli conda install --pack read-mapping`, which requests the same packages and may resolve them to slightly different builds.

## Next

Continue to [Running External Workflows](03-running-external-workflows.md), which covers the opposite direction, importing rather than exporting, meaning how a Nextflow or Snakemake pipeline written outside LGE is linked into the app and run from it. For the visual composer that builds a graph rather than replaying a recorded one, see [The Workflow Builder](01-the-workflow-builder.md), whose own Export menu writes Nextflow and Snakemake through separate code from the provenance export this chapter describes. The defects listed above belong to this chapter's exporter, and the Builder's exporter was not tested here, so check its output the same way before sending it.
