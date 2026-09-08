---
title: Provenance and Reproducibility
chapter_id: 01-foundations/08-provenance-and-reproducibility
audience: bench-scientist
prereqs: [01-foundations/06-the-lungfish-project]
estimated_reading_min: 12
task: Read the run record for a Lungfish Genome Explorer result and export it so a collaborator can re-run the same work.
tags: [foundations, provenance, reproducibility, inspector, export]
tools: []
parameters_refs: [provenance.export]
entry_points:
  - Inspector > Provenance section
  - File > Export > Provenance
  - "CLI: lungfish-cli provenance export"
shots:
  - id: inspector-provenance-section
    caption: "The chr20 reference bundle selected in the demo project, with the Inspector's Provenance section open on the right showing Run Summary above the Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON blocks."
  - id: provenance-lineage-step-expanded
    caption: "The Provenance section with HG002 bcftools chosen in the Source picker and one bcftools step expanded in Lineage, showing that step's own Command, Inputs, Outputs, Exit Status, and Wall Time."
  - id: file-export-menu
    caption: "The File > Export submenu open, showing the sequence, annotation, FASTQ, metadata, and image export items above the Provenance submenu."
  - id: provenance-export-folder
    caption: "The exported provenance folder open in Finder, with the primary artifact beside the provenance subdirectory of copied run records."
  - id: provenance-signing-settings
    caption: "Settings > General > Provenance Signing, showing the Off, Local, and Cosign Plan provider choices above the local signing key field, the public key path field, and the Save Signing Key and Clear Signing Key buttons."
illustrations:
  - id: provenance-graph-cartoon
    brief: "Schematic of the demo project's chain: an imported chr20 reference FASTA and an imported pair of HG002 FASTQ files feed a minimap2 mapping that produces a BAM, which feeds a bcftools variant call that produces a VCF. Each stage is a node, arrows show which stage produced inputs for the next, and each arrow carries a small SHA-256 label. Use Lungfish Creamsicle for nodes, Deep Ink for arrows and labels, Peach to highlight the variant track at the end as the item you would select before exporting."
glossary_refs: [provenance, provenance-sidecar, reproducibility, checksum, inspector, methods-export, run-record, project, bundle, conda, pileup]
features_refs: []
fixtures_refs: [demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

Every time Lungfish Genome Explorer (LGE) makes a file, it writes down how that file came to be. The note it writes is called [provenance](../../GLOSSARY.md#provenance), the record of where a file came from or how it was produced. LGE stores that record as a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), a small file that rides alongside the result it describes and shares its name, the way a sidecar rides alongside a motorcycle. The sidecar is written in JSON, a plain-text format that both a program and a person can read.

A sidecar answers one question. Which tool, at which version, with which options, read which files and wrote which files? The chr20 reference [bundle](../../GLOSSARY.md#bundle) in the demo project has such a sidecar, and the Procedure below opens it for you inside LGE. The first field you meet is the command that made the bundle. This is a record of what already ran, not something to type.

```json
"reproducibleCommand": "lungfish-cli import fasta .../GRCh38.chr20.10.0-10.5Mb.fasta --output-dir '.../LGE Manual Demo.lungfish' --name 'chr20 10.0-10.5Mb'"
```

The three dots in that path stand for a longer folder path the manual shortened to fit the page. They are not part of the real command.

Every file that command touched is listed with a [checksum](../../GLOSSARY.md#checksum), a short fingerprint computed from the file's exact bytes. LGE uses SHA-256, a standard fingerprinting method whose output is a 64-character string. Two people holding the same checksum are holding the same bytes, and any change to the file at all, a single edited base or a single edited header character, changes the whole string. You never compute or compare one of these by hand. LGE computes the checksum when it writes the file and compares it for you when it reads the file back, so what reaches you is a match or a mismatch rather than a string to check character by character.

[Reproducibility](../../GLOSSARY.md#reproducibility) is what the record is for. It means running the same tool at the same version with the same options on the same inputs and landing on the same answer. Provenance is what LGE writes down. Reproducibility is what you, a collaborator, or a reviewer does with what was written. The practical thing to do with this chapter is to look at one run record before you trust a result, and to export that record whenever the result leaves your machine.

## Why you would do this

Six months after a run, nobody remembers which version of bcftools called those variants. bcftools is the program that reads aligned sequencing reads and writes out the positions where a sample differs from the reference. The demo project holds an answer. Its variant track was produced by a chain of eleven steps, and the sidecar names bcftools at `1.24 (managed conda environment bcftools; executable bcftools; package bioconda::bcftools=1.24=h6bd33b9_2)`. [Conda](../../GLOSSARY.md#conda) is the package manager LGE uses to install its bioinformatics tools. In that last string, `bioconda` is the channel the package came from, `1.24` is the release version, and `h6bd33b9_2` is the build, the particular compilation of that release. Naming the build rather than just the release is the level of detail a reviewer asking how a figure was made actually needs.

The record also helps in less formal moments. A run fails and you want to see which of eleven steps broke. A collaborator asks for your workflow and you would rather not retype it from memory. A paper needs a methods paragraph naming every tool. LGE writes a record for every workflow it runs, with no opt-out anywhere in the interface, so the material for all three is already on disk before you go looking for it.

This chapter works against the demo project, using its chr20 reference bundle, the HG002 minimap2 mapping built on top of it, and the HG002 bcftools variant track built on top of that. HG002 is a widely shared human reference sample, the one whose DNA the sequencing field uses to check that a method works, and minimap2 is the program that places sequencing reads onto a reference genome. Those three results sit in a chain, so each one's record reaches back through the one before it. Human data suits this well, since the chr20 slice was imported, mapped, and called entirely inside one project and nothing in the chain came from outside it.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the demo project. Build it by following the instructions in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/demo-project, which have you create the project in the app at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and then fill it in about two minutes. Creating the project is a matter of clicks in LGE. Filling it is one script you paste into the Terminal app, and those instructions give you the line to paste.

Nothing in this chapter needs its own set of tools installed or any extra software, because it only reads and exports records that earlier runs already wrote. The tools those earlier runs needed were already installed on the machine that built the demo project. Reading a record takes a minute. Exporting one takes a few seconds, and the export folder for a variant track is small enough to mail.

## Procedure

1. Open the demo project and select the `chr20_10.0-10.5Mb` reference bundle under `Reference Sequences/` in the sidebar. The [Inspector](../../GLOSSARY.md#inspector) on the right fills with what LGE knows about the bundle.

2. Scroll the Inspector to its **Provenance** section. This is a section of the Inspector rather than a tab of its own, so it sits below the other sections for the same selection.

    <!-- SHOT: inspector-provenance-section -->

3. Read **Run Summary** at the top. For this bundle it names the workflow `lungfish import fasta`, the tool and its version, when the run was created, an exit status of 0, the wall time, and counts of steps, inputs, and outputs. The final row gives the path of the sidecar file itself.

4. Open the **Lineage** block and expand one step inside it. To see a longer chain, choose `HG002 bcftools` from the **Source** picker in the Inspector's Provenance section. This picker offers **Bundle** and the named variant tracks attached to the reference bundle. Choosing a track loads that track's own record. That track's chain runs eleven steps, from staging the alignment through `samtools`, four `bcftools` calls, `bgzip`, `tabix`, and the import back into the bundle. Those are internal bookkeeping steps LGE ran on your behalf, so read them as a list of what happened rather than as tools you need to learn.

    <!-- SHOT: provenance-lineage-step-expanded -->

5. To hand over the variant track's record, leave it selected in **Source**, click **Export** in the Provenance section header, and pick a format. For a result selected in the project sidebar, you can also choose **File > Export > Provenance** and pick a format from the submenu. All six formats work on any result that has a record. Choose **Methods Section...** to draft a paragraph, or **Shell Script...** to give a collaborator something they can run. Methods Section is the one to start with if you are unsure.

    <!-- SHOT: file-export-menu -->

    A save panel titled Export Provenance follows, reading "Choose a folder name for the exported reproducibility package." Its default name already carries the artifact and the format, so accept it or type your own. Click Save, then click Show in Finder on the Provenance Export Complete alert to open the folder that was written.

    <!-- SHOT: provenance-export-folder -->

## Settings

**Provenance.** Chooses what the export renders from the recorded history of the selected artifact, offering Shell Script..., Python Script..., Nextflow Pipeline..., Snakemake Workflow..., Methods Section..., and Full Provenance (JSON).... Nextflow and Snakemake are pipeline systems a bioinformatics collaborator may already run, so those two targets suit a handover to someone with a computational setup of their own. Neither emitted workflow passes its own engine's validity check in this release, so treat those two as accurate transcriptions a collaborator edits into a working pipeline rather than as pipelines that run unchanged, which [Exporting a Run as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md) covers in full. There is no default, because you pick a target from the submenu rather than accept one, and the first four sit above a separator as the runnable group while the last two are the read-only group. Pick the target that matches what the reader needs, a transcription for a collaborator to run, a methods draft for a manuscript, or the raw JSON for an auditor. On the command line this is `--format`.

**Save As.** Names the folder that receives the export. The default is the artifact name followed by `-provenance-` and the format, for example `chr20_10.0-10.5Mb-provenance-nextflow`, so successive exports of the same artifact do not collide. Change it when several exports of the same artifact and format need to be told apart, for example before and after a reanalysis. On the command line the single `--output` flag carries both this name and the location below, because it takes one full path.

**Where.** Chooses where the export folder is created, and it opens on the save panel's last location. Putting the export outside the project keeps it separate from the data it describes, which is the default arrangement for that reason. Choose a location you can share, such as a repository checkout, when the export is going to a collaborator. On the command line this is the folder part of that same `--output` path.

## Reading the results

For a reference bundle with variant tracks, the **Source** picker selects the bundle or an individual track. The Provenance section breaks into blocks you can open and close one at a time. They are Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON, and the Warnings block appears only when the run emitted one. A filter field labelled Filter provenance appears above them once a record is long enough, and narrows a long lineage to the steps whose text matches what you type. A Copy button in the section header puts the whole record on the clipboard.

**Run Summary** carries the identity of the run. Steps is the number of tool invocations the record holds. On the demo project's chr20 import that number is small, and on its bcftools variant track it is eleven. Inputs and Outputs here are counts rather than lists, so a run reporting one input and ten outputs read one file and wrote ten. Signatures appears only when the sidecar was signed, which "Signing a record" below covers, and Sidecar gives the path of the record on disk.

**Lineage** is the chain of steps in order, each one numbered and expandable. Open a step and it shows that step's own Command, its own Inputs and Outputs as file lists, its exit status, its wall time, and whatever the tool wrote to standard error. Standard error is the channel a command-line tool uses for its own progress notes and complaints, so text there is normal rather than a sign of failure. This is the level at which a failure becomes legible. In the demo project's bcftools chain, step 4 is the [pileup](../../GLOSSARY.md#pileup), which gathers the bases every read shows at each reference position, and step 5 is the call, which decides from that evidence where the sample differs.

```
bcftools mpileup -Ou -f .../reference.fa .../hg002-minimap2.bam
bcftools call -mv -Ov -o .../bcftools.raw.vcf
```

**Files & Outputs** lists the files the whole run read and produced, with a role, a size, and a SHA-256 checksum under each path. The chr20 import's own record shows the source FASTA it read at `sha256 3ee1418353a681cbd415a278ecc0bd9579121eac2bc483448ab78ca679840101` and the compressed sequence it wrote at `sha256 e8d07729ea4729764967e236a2450ff1e356ee7947020dab68dc73dc85589a1e`. Those two strings are what let a collaborator confirm they hold your file rather than a lookalike, and LGE does the comparing. Read the first few characters if you want reassurance that two records refer to the same file, and let the app do any comparison you would act on.

**Invocation & Options** lists the option values the run resolved, each one marked as explicit, default, or resolved default. A thread count can appear here, which matters because a tool given a different number of threads can produce a different answer. The demo project's minimap2 mapping ran with `-t 14`, which the mapping step's Command records. That 14 describes the machine the run happened on rather than a recommended setting, so it is not a number to copy or tune.

**Runtime** names the machine. The chr20 record carries an app version, an architecture of `arm64`, a dependency set of `2026.2`, an operating system of `macOS 26.6.2 (arm64)`, and the user who ran it. The dependency set is the versioned collection of bioinformatics tools LGE installed for itself, so `2026.2` names that whole collection rather than any one tool. **Raw JSON** shows the whole sidecar as text with a Copy button of its own, which is the block to reach for when you want a field the other blocks do not surface.

### What the export folder holds

Every export is a folder rather than a single file. Inside it sits the primary artifact for the format you chose.

| Format | What it writes |
|---|---|
| Shell Script | `run.sh` |
| Python Script | `reproduce.py` |
| Nextflow Pipeline | `main.nf`, `nextflow.config`, and a `containers` folder |
| Snakemake Workflow | `Snakefile` and `config.yaml` |
| Methods Section | `methods.md` |
| Full Provenance (JSON) | `provenance.json` |

Beside the artifact sits a `provenance` subdirectory holding the copied run records the export was built from.

Send the whole folder, compressed. A script pulled out on its own is unlikely to run, because it reads the records in `provenance` and any reference files that travel beside it.

If your collaborator also runs LGE, you need not export at all. Hand over the `.lungfish` [project](../../GLOSSARY.md#project) bundle directly, or share it on lab storage. On shared storage there is no menu equivalent, so use the command line tool `lungfish-cli project lock` so two people cannot run advanced workflows against it at once, which [The Lungfish Genome Explorer Project](06-the-lungfish-project.md) covers along with unlocking and migrating an older bundle.

## What good looks like

Four checks tell you a record is worth trusting. Confirm the exit status in Run Summary is 0, since a non-zero status means the tool reported a failure whatever the output files look like. Confirm the tool version string names a package build rather than a bare number, the way the demo project's `bioconda::bcftools=1.24=h6bd33b9_2` does. Confirm the input checksums in Files & Outputs match the files you meant to use. And confirm that the step count matches the work you think ran. The demo project's bcftools variant track runs eleven steps, and a chain far shorter than the one you expect usually means a step was skipped.

Most results have a record, and an empty Provenance section usually has an ordinary explanation. A file you simply copied into the project folder by hand has no run record to show, and LGE says so in the Provenance section's status line, which reads Missing provenance for an item that should have a record and No provenance required for one that should not. Trying to export from such a selection raises a No Provenance Available alert rather than an error. If instead you open a result LGE itself produced and its Provenance section is empty, that is a bug, and **Help > Report an Issue...** is the place to say so.

Three things the record cannot promise are worth holding in mind. A public database can revise a record after you fetched it, so a download recorded with an accession and a date may not return the same bytes next year. A re-run on a different Mac, a different macOS version, or a different CPU family can shift a tool's output a little, usually as a handful of borderline variant calls appearing or disappearing out of thousands rather than as a wholesale change, and the thread count recorded in the run's commands is the value to match first when you are chasing a difference. And the [methods export](../../GLOSSARY.md#methods-export) is a rough first draft rather than a finished paragraph, so read it against what you actually intended and add the accession numbers, access dates, and database citations it has no way to know. LGE writes down what ran, not what you meant to run.

### Signing a record

Most readers leave signing off and can skip to the next section. For audit work that needs a tamper-evident record, `Settings > General` holds a Provenance Signing section. Its Provider control offers Off, Local, and Cosign Plan, where Cosign is an external signing service used in software supply-chain work, and the default is Off, which is the right setting for research. Below the provider sit a local signing key field, a public key path field, and Save Signing Key and Clear Signing Key buttons, with a status line under them and an error line when something is wrong. Signing only matters if you go on to check the signature, which the command line does.

<!-- SHOT: provenance-signing-settings -->

## On the command line

Everything the Procedure asked for is done by then, so this section is optional. It is here because two of the three `lungfish-cli provenance` subcommands have no menu equivalent. `export` is the one that does. `export` and `verify` each take a sidecar file, a bundle, or an output directory as their target, and `bibliography` takes a bundle or an output directory. In the paths below, `$HOME` stands for your home folder, the one holding Desktop and Documents, and it is written that way because the project path holds spaces and needs quotation marks, inside which `~` would not expand. A bare `~/Desktop/...` outside quotation marks means the same folder.

```bash
# Export the same reproducibility package the menu writes.
lungfish-cli provenance export \
  "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref" \
  --format shell \
  --output ~/Desktop/chr20-provenance-shell

# Draft a methods paragraph instead.
lungfish-cli provenance export \
  "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref" \
  --format methods \
  --output ~/Desktop/chr20-provenance-methods

# Check a signed sidecar against its signature.
lungfish-cli provenance verify \
  "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref"

# Print a citation list for every tool the catalog recognises.
lungfish-cli provenance bibliography \
  "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref"
```

`--format` accepts `shell`, `python`, `nextflow`, `snakemake`, `methods`, and `json`, matching the six menu items one for one. `--output` names the directory that receives the export bundle.

`provenance verify` checks a signed sidecar against its signature. It looks for the signature beside the sidecar at `<sidecar>.signature.json` and the public key at `<sidecar>.pub`, and `--signature` or `--public-key` point it elsewhere. On success it reports that the signature is valid. Verification means nothing for a sidecar that was never signed, so it pairs with the Provenance Signing setting above. With signing Off there is nothing to check.

`provenance bibliography` reads a bundle's provenance and prints a citation list for the tools it recognises, which is the fastest way to start the reference list for a paper. Point it at a bundle rather than at the project folder, which holds no sidecar of its own. Read the list against your own tool list, since a tool the catalog does not know still has to be cited by hand.

## Next

Foundations is complete. Continue to one of the workflow parts.

- [Sequences](../02-sequences/01-importing-and-viewing.md) for sequence import, viewing, and download workflows
- [Reads (FASTQ)](../03-reads/01-importing-fastq.md) for read import, QC, trimming, and decontamination
- [Alignments](../04-alignments/01-mapping-reads-to-a-reference.md) for mapping, alignment review, and primer trimming
- [Variants](../05-variants/01-calling-variants-from-amplicons.md) for variant calling and VCF interpretation
- [Classification](../06-classification/01-what-is-classification.md) for taxonomic classification of reads
