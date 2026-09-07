---
title: Troubleshooting
chapter_id: appendices/troubleshooting
audience: bench-scientist
prereqs: []
estimated_reading_min: 30
task: Look up a Lungfish Genome Explorer symptom by what appears on screen and find out what it means and what to do.
tags: [reference, troubleshooting, errors, support, operations-panel]
tools: []
entry_points: []
shots:
  - id: operations-panel-failed-row
    caption: "A failed row in the Operations Panel expanded to show its command and log, with the right-click menu open on Copy Failure Report."
illustrations: []
glossary_refs: [accession, advisory-lock, bundle, cohort, conda, container, dependency-set, depth, environment-variable, exit-status, failure-report, fastq, kraken2, nextflow, operations-panel, plugin-pack, project, project-lock, provenance-sidecar, read-classification, symlink, working-directory, workflow-library]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

Lungfish Genome Explorer (LGE) is a window over a set of established programs that were built to be typed at rather than clicked. You never have to run those programs yourself. LGE runs them for you and shows you the results. When something goes wrong, the message you see usually came from one of those programs rather than from LGE itself, so it may use words LGE never uses. This appendix collects the symptoms that actually appear in Preview 2026.9.13, says what each one means in plain words, and gives the action to take.

To check which release you have, open **Lungfish Genome Explorer > About Lungfish Genome Explorer**, the first item under the app's own menu. The version shown there is what these entries describe.

The appendix is organised by what you see on screen rather than by which part of LGE is at fault. Look up the item shown in pale grey that will not click, the message, the run that stopped, or the missing result, and read across. Each entry names the chapter that covers the operation in full.

Some of these sections are read in the window and some need commands typed into Terminal. Each section says which it is at its start. The window-only sections are "Start here", "Nothing happens when I choose a menu item", and "I cannot write to my project". The rest mix the two.

Two words are worth fixing before anything else. An [exit status](../../GLOSSARY.md#exit-status) is the number a command hands back when it finishes, where zero means it succeeded and anything else means it stopped. Terminal reports it and the failure report records it, so a window user may never read one directly. A [working directory](../../GLOSSARY.md#working-directory) is the folder a Terminal window is sitting in when you type a command, and typing `pwd` and pressing Return prints it.

## Before you type anything

Every command in this appendix is typed into Terminal, the application macOS keeps at **Applications > Utilities > Terminal**. [CLI Reference](cli-reference.md) opens with the full route, including the one line you run first so that the bare name `lungfish-cli` finds the program, since an installed release does not put it where the shell looks by default. Read that section once before you type any command shown here.

## Start here, at the failed row

This section is done entirely in the LGE window. No command is needed.

Before you read any table below, do one thing. A run that fails shows as a red row in the [Operations Panel](../../GLOSSARY.md#operations-panel). Right-click that row and choose **Copy Failure Report**. On a trackpad with no second button, hold Control and click, or click with two fingers. Do not retype the command by hand from what you remember choosing in a dialog. Typing it yourself introduces a fresh mistake that hides the real one.

Open the panel with **Operations > Show Operations Panel**, which means holding Command and Shift together and pressing P, written Cmd-Shift-P from here on. Find the failed row and click the small arrow at its left edge to expand it, which shows the command LGE built on your behalf and the running log. Behind every dialog LGE writes a text command for you, which is what that line is. Then right-click the row. **Copy Failure Report** gathers the operation title, the command, the error message, the one-line summary the tool printed, the longer detail underneath it, and the log into one block ready to paste. The row also offers **Copy CLI Command** for the command alone and **Reveal Failure Report in Finder**, which opens the file on disk without your needing to know where it lives.

<!-- SHOT: operations-panel-failed-row -->

That [failure report](../../GLOSSARY.md#failure-report) file is written as the failure happens, so it survives quitting the app. LGE keeps the 50 most recent reports and deletes the oldest each time it writes a new one, so collect a report you care about rather than assuming it will still be there next month. Use **Reveal Failure Report in Finder** to reach it, because the folder sits inside Library, which Finder hides.

[The Lungfish Genome Explorer Project](../01-foundations/06-the-lungfish-project.md) covers the panel and its right-click menu in full.

## Nothing happens when I choose a menu item

This section is done entirely in the LGE window.

Three menu items in this release do nothing when clicked until something is turned on, and none of them says so in a way a first-time reader will notice.

| Symptom | What it means | What to do | Chapter |
|---|---|---|---|
| Every item in **Tools > Genotyping** is pale grey with `(not enabled)` after its name | Genotyping is working out which versions of a gene a sample carries, and its workflows are off until you turn them on, because each needs a large install of outside programs. Nothing is broken and nothing is missing. | Open **Tools > Workflow Library...**, the [Workflow Library](../../GLOSSARY.md#workflow-library) window listing each workflow as its own box, or card. Find the card under **Specialized Workflows** in the **Genotyping** group and turn its **Enabled** switch on. If the card reads Needs install, an **Install Dependencies** button stands in place of the switch, and it fetches the outside programs the workflow needs and enables the workflow when it finishes. The card shows progress while it runs. | [What Is MHC Genotyping](../09-genotyping/01-what-is-mhc-genotyping.md) |
| The Workflow Builder item is not in the Tools menu at all | The Workflow Builder is experimental and hidden by default, so the item is absent rather than pale grey. Experimental here means still changing between releases, so treat what it writes as provisional. | This feature is experimental. Turn on **Show Experimental Features** in **Lungfish Genome Explorer > Settings... > Advanced**, reached from the app's own menu or with Cmd-comma, before you look for it. | [The Workflow Builder](../08-workflows/01-the-workflow-builder.md) |
| The Inspector has no Assistant tab | The Assistant tab appears only when the Inspector is in its genomics mode. A reads [bundle](../../GLOSSARY.md#bundle), a folder LGE manages holding one dataset and its records, gives you an Inspector without it, and so do an assembly, a mapping result, a classifier result, and a genotype result. | Load a bundle that opens the Sequence viewport, which is what puts the Inspector in its genomics mode. Also check that the assistant is switched on, since **View > AI Assistant** with it off raises an alert headed "AI Assistant Disabled". | [The AI Assistant](ai-assistant.md) |

A pale grey menu item's keyboard shortcut does nothing either, so pressing the key combination for a workflow you have not enabled is silence rather than a second symptom.

## I cannot write to my project

This section is done entirely in the LGE window.

This is the failure mode most likely to look like a bug in your own work when it is not. A [project](../../GLOSSARY.md#project) is the folder LGE keeps one piece of work in. LGE takes a lock on a project so that two copies of the app, or a `lungfish-cli` run and a window, do not write into the same folder at once. That cause only applies if you or someone else ran `lungfish-cli` against this project. A [project lock](../../GLOSSARY.md#project-lock) is that claim, and it is an [advisory lock](../../GLOSSARY.md#advisory-lock), which means a program that does not check it can still write into the folder and overwrite what is there. Every program LGE runs does check it.

To clear a lock, follow the section "If a project just opened read-only" in [Shared Projects](shared-projects.md), which gives the plain window route including the **Recover and Open** button that clears a lock left behind by a session that has genuinely ended.

| Symptom | What it means | What to do | Chapter |
|---|---|---|---|
| The window title ends in ` (Read Only)` | Another session holds the project lock, or LGE could not read the lock file to find out. | Read the banner underneath, which names the owner. Close the other copy of the app, or the command-line run, and reopen the project. | [Shared Projects](shared-projects.md) |
| A banner headed "Project opened read-only" names a user, a host, and a process id | A live lock from a named session. Host is the name of the computer holding it and the process id is the number macOS gave that running copy, so together they say which machine and which window to close. LGE blocks project-writing workflows to protect the folder. | Confirm that session has genuinely ended before you clear the lock, since clearing a live one is how two writers end up in one folder. | [Shared Projects](shared-projects.md) |
| An alert headed "Project Is Open Read Only" appears when you click Run | You started a workflow that writes into the project while the write gate is closed. The alert names the workflow. | Close the other writer, then close and reopen the project. The alert keeps appearing until you have reopened it, because reopening is what puts the lock back in your hands. | [Shared Projects](shared-projects.md) |
| A message says lock metadata is corrupted, or could not be read | The lock file exists but LGE cannot make sense of it. Writing stays blocked until the lock is inspected or force-removed. | Make sure no other session is running, then clear the lock as [Shared Projects](shared-projects.md) describes. | [Shared Projects](shared-projects.md) |

On network storage, which means a drive living on another computer and reached over the network rather than a drive plugged into yours, a reported locking failure is often not a real lock problem. Lock failures surface against `.lungfish/project.lock` for a project, or against a `.install.lock` inside the conda root for a plugin install, never against `manifest.json`. Those names begin with a dot, so Finder hides them and you never need to open one yourself. Before you change how a share is mounted, look for stray files whose names begin with `._`, which macOS leaves on volumes that cannot hold its metadata properly and which confuse the check. Those are safe to delete, and macOS writes fresh ones as it needs them.

## A run stopped and I do not know why

These entries name the exact text a run prints, so you can match what you saw. The fixes are done in the window except where a command is shown.

The exit-status numbers below are worth reading rather than ignoring. They appear in the failure report and in Terminal.

| Exit status | What it means |
|---|---|
| 0 | The command succeeded. |
| 2 | A usage error, meaning the command was typed wrongly and stopped before doing any work. |
| 3 | A pack name was not recognised and nothing was installed. |
| 10 | `tools update --plan` found pending work, which is a report rather than a fault. |
| 64 | A workflow error, meaning the command refused the work or the work failed inside a workflow step. |

Exit 64 covers both a run started without a required setting and a classification that finished and matched nothing, so read the message rather than assuming a typing mistake.

| Symptom | What it means | What to do | Chapter |
|---|---|---|---|
| `Empty Kraken2 report`, exit status 64 | [Kraken 2](../../GLOSSARY.md#kraken2), the program that sorts reads by which organism they came from, finished and matched nothing. In [read classification](../../GLOSSARY.md#read-classification) a database is the collection of reference genomes the reads are compared against, and yours held nothing matching. The run is not broken and your reads are not necessarily bad. | Try a larger database. `lungfish-cli conda db recommend` prints the collections this machine has the free disk space to hold, largest first. | [Running Kraken 2](../06-classification/02-running-kraken2.md) |
| An assembly with MEGAHIT exits nonzero and writes no contigs | MEGAHIT 1.2.9 fails most runs on Apple Silicon in this release, with both shipped workarounds active. Check your own chip under **About This Mac** in the Apple menu, where a Chip line reading M1 or later means Apple Silicon. A run that completes is correct, and its contigs are as trustworthy as any other assembly's. | Rerun it, which is the only workaround. Two or three attempts is reasonable before you switch to SPAdes instead. | [When to Assemble](../07-assembly/01-when-to-assemble.md) |
| Every Medaka run fails, and Clair3 stops on a file path containing a space | Medaka completes no run in this release, because the pipeline calls a subcommand its current version removed. Clair3 refuses any alignment file whose path holds a space, which every path under `Reference Sequences/` has. | There is no workaround for Medaka in this release. For Clair3, move the alignment to a folder whose whole path has no spaces in it and run it from there. | [Nanopore Variant Calling](../05-variants/04-nanopore-variant-calling.md) |
| A message about a provenance publication artifact, with nothing written | Runs must not live in a temporary folder. Your [working directory](../../GLOSSARY.md#working-directory) sits under `/private/tmp`, and LGE compares the path it recorded against the path it checks. The two spellings differ across the [symlink](../../GLOSSARY.md#symlink) macOS keeps between `/tmp` and `/private/tmp`. | Run from an ordinary folder such as one inside Documents. Type `pwd` and press Return to see where you are. The same folder reached as `/tmp/...` works, so it is the spelling rather than the location. | [CLI Reference](cli-reference.md) |
| A genotyping run stops near 84 percent, saying an output is outside the result bundle | The same `/private/tmp` path comparison, hit at the end of a genotyping run after all the real work is finished. The percentage varies a little, so match on the message text rather than the number. | Write the output bundle somewhere inside your project or your home folder and run it again. | [Running Amplicon MHC Genotyping](../09-genotyping/02-running-genotyping.md) |
| A medium or long run on an external drive slows down or moves its scratch files | [Nextflow](../../GLOSSARY.md#nextflow), the pipeline runner behind some LGE workflows, needs a drive that supports a few features your external drive may lack. When the project volume does not qualify, LGE quietly moves its temporary files to the internal drive. Results still land where you asked. | Nothing, if the run finishes. If it does not, move the project to the internal drive and rerun. A drive formatted exFAT is the usual cause, and Finder's **File > Get Info** on the drive names the format. | [Running External Workflows](../08-workflows/03-running-external-workflows.md) |

## A command refused me

Every entry here is a command typed into Terminal. A refusal means nothing ran and nothing on disk was changed.

| Symptom | What it means | What to do | Chapter |
|---|---|---|---|
| Raising **Min Reads** on a genotyping run removes no rows from the report | The filter you set is not applied. On a Genotype only run, meaning one with no haplotype analysis layered on the allele calls, the value is recorded in the run statistics and never used to drop a row. The command-line `--min-support` behaves the same way. | Read the read-count column of the Long Summary sheet in the exported workbook and set aside the thin rows yourself. LGE defines no floor, and the ranges the genotyping chapter reports from its worked plate are the only orientation on offer. | [Running Amplicon MHC Genotyping](../09-genotyping/02-running-genotyping.md) |
| `genotype-cohort` stops with a message that at least two input FASTQ bundles are required | A [cohort](../../GLOSSARY.md#cohort) is the group of samples compared together, so one bundle is not a cohort. [FASTQ](../../GLOSSARY.md#fastq) is the text format holding sequencing reads and their quality scores. The minimum of two is not stated in the help text. | Pass two or more bundles, or run `fastq genotype` on the single sample instead. | [Running Amplicon MHC Genotyping](../09-genotyping/02-running-genotyping.md) |
| `bundle export` reports `--format container` as unknown, then reports the format as missing without it | This command cannot be used in this release, because the subcommand's own `--format` flag collides with the global one. | Zip the bundle folder by hand instead. A bundle looks like one file in Finder, so right-click it, choose **Show Package Contents** to confirm you have the right one, then compress the item itself. | [File Formats](file-formats.md) |
| `conda install --pack gatk-core` exits 3 with an unknown-pack error | The pack exists but the [conda](../../GLOSSARY.md#conda) installer, which is the tool LGE uses to fetch outside programs, does not know its name. The same is true of `--pack phasing`. | Install both from the Plugin Manager, **Tools > Plugin Manager...** (Cmd-Shift-B). | [Reference Files for GATK](../06-human-germline-variants/04-reference-packs.md) |
| `convert` refuses because input and output name the same file | The command declines an in-place conversion. | Give the output a different name. | [CLI Reference](cli-reference.md) |
| A VCF import stops saying VCFv3 is not supported | The file is in version 3 of the Variant Call Format, which LGE refuses. Any 4.x version is accepted. | Convert it to VCF 4.x with `bcftools convert` or with vcftools' `vcf-convert`. Neither program ships with LGE, so install bcftools or vcftools yourself, or ask whoever gave you the file for a 4.x copy. | [Importing Existing VCFs](../05-variants/06-importing-existing-vcfs.md) |
| `fastq ont-barcode-genotype` prints a deprecation notice | Deprecated means the command still works but is scheduled for removal. | Build per-sample `.lungfishfastq` bundles with a FASTQ import recipe, which is a saved set of import steps LGE replays for you, then run `fastq genotype` or `fastq genotype-cohort` on those. | [Oxford Nanopore Runs](../03-reads/07-ont-runs.md) |

## The run finished but the result is not what I expected

The hardest failures are the quiet ones, where a command finishes with exit status zero and the answer is still wrong. The first fix here is done in the window and the rest need Terminal.

| Symptom | What it means | What to do | Chapter |
|---|---|---|---|
| A genotyping result shows no cohort summary panel and no Smart Cohorts section | A genotype-only result hides both by design, so the cohort-level counts LGE builds are never shown in the window. There is no window equivalent in this release. | Take the whole-run [depth](../../GLOSSARY.md#depth) judgement, meaning how many reads stacked up at each position, from `lungfish-cli genotype list-samples`, which prints one row per sample with its retained read count and status. | [Reading the Genotype Comparison](../09-genotyping/03-reading-the-genotype-comparison.md) |
| You import a BigWig or BigBed file and nothing appears in the window | Both formats hold values along a genome, BigWig for a continuous signal such as coverage and BigBed for named intervals. LGE recognises both but has no reader for them in this release, so detection succeeds and display cannot follow. The file is not broken. | Convert the file to a format LGE reads, or view it in a genome browser that supports it. | [File Formats](file-formats.md) |
| `fetch genome` returns a record under a different sequence name than the [accession](../../GLOSSARY.md#accession) you asked for | An accession is the identifier a public database gives one record. Assembly accessions, which begin `GCF_` or `GCA_` and name a whole assembled genome, go through the assembly database. Asking that database for a nucleotide accession, which names one sequence and looks like `NC_045512.2`, returns the linked assembly instead. The command's own help text says so. The sequence is usually the same organism under another name rather than a different organism, but check rather than assume. | Read the sequence name in the sidebar entry for the bundle that came back before you use it. | [Downloading from NCBI](../02-sequences/02-downloading-from-ncbi.md) |
| A command given `--format json` prints ordinary text anyway | Five commands accept the flag and ignore it, `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, and `version`, so their output cannot be parsed reliably yet. | Parse the text, or read the field you need out of the [provenance sidecar](../../GLOSSARY.md#provenance-sidecar) with any text editor, since it is plain text. | [Running in CI](06-running-in-ci.md) |

## Tools and databases are missing

Every check in this section is a command typed into Terminal. The Plugin Manager, **Tools > Plugin Manager...** (Cmd-Shift-B), is the window route for installing what these commands report as missing.

Most LGE operations run out of per-tool environments, where an environment is a private folder of software holding one tool and everything it needs. A missing-tool error means an environment is absent rather than that the operation is unsupported. LGE calls the installable units [plugin packs](../../GLOSSARY.md#plugin-pack) and keeps each tool in its own [conda](../../GLOSSARY.md#conda) environment.

The first diagnostic for any missing-tool error is `lungfish-cli debug env --check-tools`, which reports each tool as found with its version or as not found. Add `--tool <name>`, replacing `<name>` with the tool you mean, to check one.

A [dependency set](../../GLOSSARY.md#dependency-set) is the exact list of tool versions one LGE release was built and tested against. `lungfish-cli version --tools` prints the managed tools with the dependency set they belong to. On the machine that wrote this appendix it exited 0 and printed `Lungfish 2026.9.13` with `Dependency set: 2026.2 (2026-08-18)` above eighteen tool rows. Your own copy prints your version, your dependency set, and however many tools your install carries, and a different count is not a fault.

To find out what is out of date, `lungfish-cli tools update --plan` names every install, reinstall, removal, and database update this machine is missing against the pinned set. It exits 10 when work is pending and 0 when there is none. On the machine that wrote this appendix it exited 10 and printed two lines of pending work with an estimated download of 157.3 MB. Your own run prints whatever your machine is missing, which is commonly nothing at all.

Databases are managed separately from tool packs. Use `lungfish-cli conda db list` to see what is available and installed, `lungfish-cli conda db recommend` to see which collections your free disk space allows, and `lungfish-cli conda db download <name>` to fetch one. EsViritu has its own pair, `lungfish-cli esviritu download-db` and `lungfish-cli esviritu db-status`.

Two more messages belong here, both from the lock LGE takes while it changes the conda root. Running two installs at once prints `waiting for conda lock held by pid <n>`, where a number appears in place of `n` naming the process id of the other install, and then continues on its own once that install finishes. A conda root you cannot write to prints `conda root is read-only; reinstall as the admin user`, which means the folder's permissions rather than anything about the pack. An admin user is an account allowed to install software, and whoever set the computer up can tell you whether yours is one.

If a pack install hangs at solving the environment for many minutes, a proxy is the usual cause, meaning a machine your network routes downloads through. Ask whoever runs your network whether one is in use and what its address is, then set the [environment variable](../../GLOSSARY.md#environment-variable) `HTTPS_PROXY` in the Terminal window you launch LGE from, as in `export HTTPS_PROXY=http://proxy.example.org:8080`, using the address they give you. The variable is read by micromamba and the underlying network stack rather than by LGE itself. [Plugin Packs](../01-foundations/07-plugin-packs.md) covers installing and checking packs in full.

## Containers and pipelines will not start

Every check in this section is a command typed into Terminal.

A [container](../../GLOSSARY.md#container) packages a program with everything it needs so it behaves the same on every machine, and a pipeline is a chain of tools run one after another. Some pipelines run their steps inside containers, and when the container runtime is not ready those pipelines fail in ways that do not name the runtime.

Run `lungfish-cli debug container` first. It reports whether the Apple Containerization framework is available and ready. On the machine that wrote this appendix it exited 0 and printed `Apple Containerization framework available` with `Status      : Ready`, and your own machine prints its own status. A status other than ready means the container route is closed on that machine. Add `--pull-test` to check that the machine can actually download an image, which is the packaged copy of a tool, because the framework can be present and still fail to fetch one. For a TaxTriage run specifically, `lungfish-cli taxtriage check-prerequisites` verifies Nextflow and the container runtime together before you commit to a run.

When the container route is closed, a Nextflow run can be pointed at a local `.nf` pipeline file or at conda instead of containers, and [Running External Workflows](../08-workflows/03-running-external-workflows.md) shows the dialog where that choice is made.

`lungfish-cli debug env` on its own is a quicker check with no tool probing. On the machine that wrote this appendix it exited 0 and reported macOS Version 26.6.2, 14 CPU cores, 48 GB of physical memory, arm64 architecture, and Apple Containerization available. Your own machine reports its own operating system version, its own core count, and its own memory, and none of those figures is a target to match.

## Is this file or bundle intact

Every check in this section is a command typed into Terminal. There is no window route for these three.

`lungfish-cli analyze validate <files>...` checks whether a sequence or variant file is well formed. Adding `--strict` also rejects files that are readable but irregular, such as a record whose fields disagree with the header, so use it when a file parses yet behaves oddly downstream. `lungfish-cli bundle validate <bundle>` checks a reference bundle.

`lungfish-cli provenance verify` needs one thing said first. Signing is off by default, so most records are unsigned and the command does nothing useful on them. On an ordinary unsigned sidecar it exits 64 with an error rather than a clean pass. Its real job is detecting a record that changed after it was signed. On an unsigned record, open the provenance sidecar, which sits in the `provenance/` folder inside the result bundle and opens in any text editor, read its `exitStatus` field, and check that the outputs it declares exist.

Missing index files regenerate on their own. An index file is a small companion file that lets LGE jump straight to one part of a large file rather than reading all of it. LGE rebuilds a `.fai`, a `.bai`, or a `.tbi` the first time an operation needs one, in every case this campaign met. If that rebuild fails, the underlying tools are `samtools faidx`, `samtools index`, and `tabix`.

## Reporting something this appendix does not cover

Gather the failure report first, with **Copy Failure Report** on the right-click menu of the failed row, since it already holds the command, the message, and the log. Then add the app version, which the **Lungfish Genome Explorer > About Lungfish Genome Explorer** window shows and which `lungfish-cli version` prints, and the macOS version from the Apple menu's **About This Mac**. Adding the installed tool versions from `lungfish-cli version --tools` helps but is optional, and a report without them is still worth filing.

The fastest route is **Open GitHub Issue** on the failed row's right-click menu, which opens a pre-filled issue in your browser carrying that report. You review it and submit it yourself, so nothing is ever filed without your action. Submitting needs a free GitHub account. Without one, use **Help > Report an Issue...**, which opens the same template carrying the version string, and send it to whoever supports LGE where you work.

Leave your project's data files out of the report. The generated failure report holds LGE's own log and the command it ran rather than your sequences, so it is safe to send as it stands, and sequence data is rarely yours alone to share.

## Next

See [CLI Reference](cli-reference.md) for the syntax of any command named here, [Running in CI](06-running-in-ci.md) for the exit statuses and the diagnostic commands in a scripting context, or [File Formats](file-formats.md) for what each LGE bundle contains.
