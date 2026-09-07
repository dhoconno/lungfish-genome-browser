---
title: Plugin Packs
chapter_id: 01-foundations/07-plugin-packs
audience: bench-scientist
prereqs: [01-foundations/06-the-lungfish-project]
estimated_reading_min: 12
task: Install and verify Lungfish Genome Explorer plugin packs and reference databases from the Plugin Manager.
tags: [foundations, plugin-pack, installation, databases]
tools: []
parameters_refs: [classify.install-database]
entry_points:
  - Tools > Plugin Manager... (Cmd-Shift-B)
  - Settings > Advanced
  - "CLI: lungfish-cli conda packs"
  - "CLI: lungfish-cli conda db list"
shots:
  - id: plugin-manager-window
    caption: "The Plugin Manager on the Packs tab, with the Required Setup section above the Optional Tools section and the Read Mapping card showing its three mappers."
  - id: plugin-manager-offline-commands
    caption: "The offline strip at the foot of one pack card, showing the two greyed command lines and the Copy button beside them."
  - id: plugin-manager-installed-tab
    caption: "The Installed tab with one environment row expanded to list the packages and versions inside it, and the Check for Tool Updates button above the list."
  - id: plugin-manager-databases-tab
    caption: "The Databases tab, with installed databases beside ones offering a Download button, the recommended-database banner at the top, and the total storage readout at the foot."
illustrations: []
glossary_refs: [plugin-pack, conda, micromamba, required-setup-pack, managed-environment, post-install-hook]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

Lungfish Genome Explorer (LGE) does not carry every bioinformatics tool inside the application. A bioinformatics tool here means a small program that reads sequencing files and writes an answer back out. Tools update on their own schedules, no one person uses all of them, and bundling the lot would make the download enormous and stale on arrival. So LGE ships small and installs tools on request.

A [plugin pack](../../GLOSSARY.md#plugin-pack) is a themed group of related command-line tools installed together, because the chapters that need one tend to need the rest. A command-line tool is a program with no window of its own, which LGE runs for you behind the scenes, so installing one never means you have to type anything. The `read-mapping` pack hands you three read mappers, `minimap2`, `BWA-MEM2`, and `Bowtie2`. All three do the same job, and each workflow chapter names the one it uses. The `variant-calling` pack hands you four variant callers, iVar, LoFreq, Medaka, and Clair3, which differ mainly in the sequencing technology they were built for, and again each chapter names its own. A mapper places each sequencing read at the position on a reference genome it best matches, a reference genome being a finished genome sequence used as a yardstick, and a variant caller reads those placements and reports where the sample differs from the reference.

Names in this typeface, such as `read-mapping`, are the internal ids LGE uses for a pack. On screen the same pack shows a plain-language title, Read Mapping, and the table further down pairs every id with the title on its card.

One pack is not optional. The pack shown in the Plugin Manager as Third-Party Tools, which this manual calls the [Required Setup pack](../../GLOSSARY.md#required-setup-pack) after the section it sits in, holds the seventeen everyday utilities LGE leans on to open a project at all. Knowing what is in it answers the question the pack table below would otherwise raise, which is where the ordinary file-handling tools went. `samtools` and `bcftools`, which sort and query alignment and variant files, are there. So are `fastp` and `Deacon`, which trim reads and strip human reads out of a sample. Trimming cuts low-quality ends and leftover adapter sequence off each read. So is BBMap, a general-purpose read mapper, which arrives inside the entry the card labels `bbtools`. The remaining utilities are internal helpers that no workflow chapter asks you for by name. None of these live in an optional pack, because everything else assumes they are already present.

Installation is handled by [conda](../../GLOSSARY.md#conda), a package manager that installs compiled scientific software along with the shared code it depends on. That shared code is called a library in software, which has nothing to do with a sequencing library. LGE drives conda with [micromamba](../../GLOSSARY.md#micromamba), a small standalone program that does the same job faster, and you never touch it directly. Every tool lands in a [managed environment](../../GLOSSARY.md#managed-environment) of its own, which is a private folder holding that tool and the code it depends on, so two tools that want different versions of the same shared code never collide and neither one breaks the other. The whole collection sits in a hidden folder at `~/.lungfish/conda`, where the `~` stands for your home folder, the one named after your account. You never need to open that folder yourself. It sits outside any project, and every project on the machine shares it, so you install a pack once and every project sees it.

In practice, when a later chapter says to install a pack first, you open the Plugin Manager, click one button, and carry on.

## Why you would do this

Every workflow chapter in this manual opens by naming a pack. The workflow chapters are the ones that walk a dataset through an analysis, and they begin after this Foundations part ends. That opening instruction is only actionable if you know where the packs live and what "installed" looks like. Learning it once here means the rest of the manual can say "install the `assembly` pack" and move on.

The second reason is that a missing pack does not look like a missing pack when you first meet one. It looks like a workflow that refuses to start with a message about a tool you have never heard of. Reading this chapter turns that dead end into a one-click fix.

The third reason is disk. Reference databases are large, some of them very large, and they are tracked separately from the tools. Knowing which database your work actually needs, before you download one, is the difference between the 8 GB Standard-8 collection and the 72 GB PlusPF, both described later in this chapter.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses no fixture file, so there is nothing to download before you begin. Everything here happens in the Plugin Manager window, against your own machine.

LGE runs on macOS 26 Tahoe or later, on Apple Silicon Macs. The About window, the first item in the application menu at the left of the menu bar, states the full minimum requirements. It asks for 16 GB of memory as a minimum and recommends 32 GB for metagenomics and assembly. Your own Mac reports how much memory it has in **Apple menu > About This Mac**. A Mac at the 16 GB minimum runs everything in this manual, and only the largest reference databases are out of reach, so a smaller number slows work down or narrows your database choice rather than blocking it.

Separately, the app recommends 100 GB of free disk for tool packs, databases, and projects. Nothing enforces that figure, so a smaller disk does not block an install, but a download that runs out of room fails partway. Finder reports free space in the sidebar of any window, or in **Apple menu > About This Mac** under Storage. Metagenomics is the study of all the DNA in a mixed sample at once, and it asks for the most memory here because tools such as Kraken2 load their whole reference database into RAM before classifying a single read.

If your startup disk is small, or you want the large databases off the boot drive, you can move the shared storage location onto an external drive. The setting that moves the storage location sits on the Plugin Manager's Databases tab.

Nothing in this chapter needs Docker Desktop, the container software some other pipelines rely on, so you do not need to install it.

## Procedure

1. Open the Plugin Manager from **Tools > Plugin Manager...** (Cmd-Shift-B). Three tabs run across the top. **Installed** lists the managed environments LGE has built. **Packs** holds the groups of tools available to install. **Databases** holds the reference databases that classification and decontamination workflows read.

2. Look at the **Packs** tab. Two sections stack down the window. **Required Setup** holds the Third-Party Tools pack described above. **Optional Tools** holds everything else, one card per pack.

    <!-- SHOT: plugin-manager-window -->

3. Expand a pack card to see the tools inside it. Every tool wears one of four status labels. **Ready** means installed and working. **Needs install** means not installed yet. **Needs reinstall** means installed but failing its integrity check, which re-running the install repairs. An integrity check confirms the installed files are complete and undamaged, and it never touches your own data. **Storage unavailable** means the external drive the install lives on is unplugged. Two rows on the Required Setup card are reference data rather than programs, and those read **Needs download** or **Needs refresh** instead. A pack is ready to use when every row inside it reads Ready.

4. Click **Install All** on the `read-mapping` pack. The Required Setup card says **Install** instead, because it is installed as one unit, and on a first launch it is present but not yet installed, so you click it too. Progress streams into the card as LGE downloads the tools and builds their environments. Leave the lid open until the card finishes, since a sleeping Mac pauses the download. There is no need to restart the app afterwards. The next operation that reaches for one of those tools will find it.

5. Click **Install All** on the `variant-calling` pack. Packs are independent, so starting a second one is safe. LGE takes an exclusive lock on the install root, so the second install waits for the first to finish rather than running beside it. On a fresh machine the first install is the slowest, usually a few minutes on a fast connection, because LGE sets up micromamba along the way, and every install after it is quicker.

Both packs should now read Ready on every tool. Clicking Install on a pack that is already installed runs the integrity check again rather than downloading anything, which is the way to confirm an install survived a closed lid, a dropped network, or a reboot.

Any of this reverses when you need the space back. An installed optional pack shows **Remove All** where Install was, and clicking it tears down every environment the pack owns and returns it to **Needs install**. The Required Setup pack has no Remove All, since LGE needs it to run.

### The packs, and what is in them

Ten packs are available in the Plugin Manager. Seven cards show until you turn on **Show Experimental Features** in **Settings > Advanced**, and the three marked experimental appear alongside them once you do. Experimental packs install and run like any other. They are simply less tested than the rest.

| Pack id | Shown as | Approximate size | Tools |
|---|---|---|---|
| `read-mapping` | Read Mapping | 260 MB | minimap2, BWA-MEM2, Bowtie2 |
| `variant-calling` | Variant Calling | 260 MB | LoFreq, iVar, Medaka, Clair3 |
| `assembly` | Genome Assembly | 950 MB | SPAdes, MEGAHIT, SKESA, Flye, hifiasm |
| `metagenomics` | Metagenomics | 1.2 GB | Kraken 2, Bracken, EsViritu, RiboDetector |
| `full-length-mhc-genotyping` | Full-length MHC Genotyping | 650 MB | Savont, NCBI BLAST+ |
| `multiple-sequence-alignment` | Multiple Sequence Alignment | 120 MB | MAFFT |
| `phylogenetics` | Phylogenetics | 180 MB | IQ-TREE |
| `gatk-core` | GATK Core (experimental) | 600 MB | GATK4 |
| `phasing` | Variant Phasing (experimental) | 180 MB | WhatsHap |
| `wastewater-surveillance` | Wastewater Surveillance (experimental) | 1.5 GB | Freyja, iVar, Pangolin, Nextclade, minimap2 |

The list above is complete. Every pack the Plugin Manager can install appears in it. MHC in the genotyping pack's name stands for major histocompatibility complex, the cluster of immune genes that varies more between individuals than any other part of the genome, and Savont is the tool that genotypes it from full-length sequencing reads.

Add the ten sizes together and the optional packs come to about 5.9 GB, on top of the 2.7 GB Required Setup pack. Most people install two or three packs rather than all ten. The `gatk-core` pack runs larger than the viral caller packs, because GATK4 ships as a Java toolkit with its own runtime.

Some packs finish with extra work after the tools land. LGE calls these [post-install hooks](../../GLOSSARY.md#post-install-hook), small follow-up commands a pack declares for itself, such as fetching the lineage data Freyja needs to be useful. Lineage data is the reference list of named virus variants a surveillance tool matches a sample against. A pack that has hooks shows the count on its card, and resting the pointer on the count without clicking lists what they do.

### Install a pack without internet access

An air-gapped Mac is one deliberately kept off the network, and a firewalled one sits behind rules that block outside downloads, which is how many campus and hospital networks are set up. Neither can reach the tool channels, so LGE lets you carry a pack across by hand. Every pack card carries two greyed command lines and a **Copy** button that puts both on the clipboard.

<!-- SHOT: plugin-manager-offline-commands -->

Both commands are typed into the Terminal application, the macOS window where you type commands instead of clicking, which the [previous chapter](06-the-lungfish-project.md) shows you how to open. Run the first command on a networked Mac to bundle the pack into one archive. Move the archive to the offline Mac and run the second to install from it.

```bash
lungfish-cli conda export-pack --pack read-mapping --output ./read-mapping-conda-offline-pack.tgz
lungfish-cli conda install --offline --from-bundle ./read-mapping-conda-offline-pack.tgz
```

The Copy button fills in whichever pack card you took it from, so the archive name always matches the pack id. This is the only step in the walkthrough where you type a command, and every other install path in it runs from a button.

### Manage installed environments

The **Installed** tab lists every managed environment LGE has built, one per tool. Click a row to expand it and read the exact packages and versions inside, which is the fastest way to confirm what a tool actually pulled in. Each row carries a **Remove** button that deletes that one environment, finer-grained than the pack-level Remove All.

<!-- SHOT: plugin-manager-installed-tab -->

**Check for Tool Updates…** sits above the list. It compares the tools installed on this machine against the exact versions your copy of LGE expects, and reports anything that has drifted. That expected set is called the pinned dependency list, and this chapter uses that one name for it throughout. The pinned list is versioned in step with the app, so a build of LGE 2026.9.13 checks against the 2026.9.13 pinned list, and the two never disagree about which version of a tool is the right one.

An interrupted install sometimes leaves an environment behind named with a long string of letters and numbers rather than a tool name. LGE hides these from the tool list and gathers them into an **Orphaned Environments** row that reports how many it found. Its **Remove** button clears them in one pass. Removing them is safe, since nothing in the packs list depends on one of those leftovers.

## Settings

The Databases tab is where reference databases are downloaded, updated, and removed. Its five controls follow. Two of them touch a database LGE builds on your own machine from downloaded source sequences rather than fetching ready-made, which the Reading the results section below describes, and those cannot be replaced in place. Each entry ends with the command that does the same job outside the app, and the commands all start with `lungfish-cli` when you type them into the Terminal. A word in angle brackets such as `<name>` marks a name you replace with your own, brackets included.

**Download.** Fetches one database and unpacks it into the app's managed storage, showing the download size, the memory the database needs while it runs, and a progress bar with a Cancel button. Nothing is installed until you ask, because the collection runs from half a gigabyte to seventy-two gigabytes and no machine needs all of it. Download the one your work needs, and take the header's recommendation as the safe first choice, since it names the database that fits your Mac's memory. On the command line this is `lungfish-cli conda db download <name>`.

**Remove.** Deletes an installed database and frees its disk space, after a confirmation sheet that names the database. Nothing is removed unless you ask, since a removed database has to be downloaded again from scratch. Remove one you no longer classify against, because the large collections take tens of gigabytes. On the command line this is `lungfish-cli conda db remove <name> --delete-files`.

**Update.** Replaces an installed database with the version named in the app's pinned dependency list. Nothing is updated unless you ask, and the locally built databases described above cannot be replaced in place, so they are reported as skipped instead. Update when the row says an update is available and you want your results to match the current pinned build. On the command line this is `lungfish-cli conda db update <name> --yes`.

**Refresh.** Re-reads the catalog and the installed set, so a database that arrived some other way shows up. The list is loaded once when you open the tab, which is why it can go stale while the window stays open. Use it when a download you started elsewhere has finished and the list still looks unchanged. On the command line this is `lungfish-cli conda db list`.

**Storage Settings....** Opens the setting that decides where downloaded databases live, with the current folder and the total space in use shown along the foot of the tab. It points at the app's own managed storage folder by default, the shared folder holding both the managed environments and the databases, which is the one place LGE can always reach. Change it when the startup disk is too small for a Standard database and you want to keep databases on an external drive. There is no command-line equivalent for this setting.

## Reading the results

<!-- SHOT: plugin-manager-databases-tab -->

The Databases tab groups its rows by the tool that reads them. Each row reports the database's size, the memory it wants, its install state, the install date, the version, and whether the local copy is up to date. An installed row reads **Installed**, and one you have not fetched yet shows a **Download** button in that place instead. The memory figure is there because a database is not only a stored file. Kraken2 loads the whole thing into RAM before it classifies a single read, which is the memory question Before you start raised. A banner at the top reads "Recommended for your system" and names the database that fits your Mac's memory. Any database asking for more memory than you have reads "(exceeds system RAM)" inline, so you do not load one by mistake.

Thirteen databases are listed. Kraken2 is the classifier that reads a database of reference genomes and reports which organism each sequencing read most likely came from. Nine of the thirteen rows are Kraken2 collections, which differ in what organisms they cover and how much memory they need.

| Database | Memory it wants | What it covers |
|---|---|---|
| Standard | about 67 GB | Archaea, bacteria, viruses, plasmids, human, and vector sequence, meaning the cloning-vector DNA used to carry inserts in the lab |
| Standard-8 and Standard-16 | 8 GB and 16 GB | The same collection as Standard, compressed to fit smaller machines |
| PlusPF | about 72 GB | Standard plus protozoa and fungi, with PlusPF-8 and PlusPF-16 capped the same way |
| Viral | about 0.5 GB | RefSeq viral genomes only, the smallest of the set |
| MinusB | about 11 GB | Standard with the bacteria taken out, for a sample where a bacterial background would swamp what you are after |
| EuPathDB46 | about 34 GB | Eukaryotic pathogens such as *Plasmodium* and *Toxoplasma*, with 46 being the release number |

Compression is what makes Standard-8 and Standard-16 fit a smaller Mac, and it costs some sensitivity. A compressed database keeps fewer reference sequence fragments, so a read that the full Standard would have assigned to a species is more often left unassigned or reported at genus level instead. On a 16 GB Mac that tradeoff is the price of running the analysis at all.

Two more Kraken2 databases are assembled on your machine rather than downloaded, which the same **Download** button does after fetching their source sequences. SILVA and Greengenes are both built from ribosomal RNA reference collections, the gene regions used to identify bacteria and archaea by sequence. SILVA is the larger of the two at about 12 GB against Greengenes at about 8 GB, so reach for SILVA when you want the broader reference, and for Greengenes when you are matching results against earlier work that used it. Because they are built locally, they cannot be updated in place, and the Update control reports them as skipped. Rebuild them by downloading them again.

The last two rows are not Kraken2 at all. The EsViritu Viral DB holds a curated set of viral genome sequences, broad enough to name most viruses you would meet in a clinical or environmental sample. Reach for it when viruses are the whole question, and for the Kraken2 Viral database when you want viruses reported alongside everything else Kraken2 covers. The NCBI Taxonomy is a small download that turns numeric taxon identifiers into names.

Three more reference sets handle host and background sequence, and they do not appear on this tab. The Human Read Scrubber Database serves NCBI's scrubber, which strips a patient's own reads out of a clinical sample before analysis. The Human Read Removal Data entry is a prebuilt Deacon index that strips human reads, and Ribosomal RNA Removal Data is a Deacon index that strips ribosomal RNA. All three arrive with Required Setup, and on the command line `lungfish-cli conda db install-managed --list` names them.

### What a missing tool looks like

Run an operation that needs a tool you have not installed and it stops before doing any work, naming the tool and the pack. Run Map Reads without the `read-mapping` pack, for example, and you get "minimap2 is not installed. Install the read-mapping plugin pack first." The operation stopped before writing anything, so your input files and project are exactly as they were. Install the named pack and run it again.

If that message appears on a machine where you believe the pack is installed, open the Plugin Manager and check the pack's tools on the **Packs** tab. Anything reading **Needs install** or **Needs reinstall** is repaired by clicking Install All on that same Packs tab. If instead a row on the **Installed** tab expands to an empty package list, the environment is present but hollow, and clicking Install All on the pack rebuilds it. On a shared workstation, an install that stops with `conda root is read-only; reinstall as the admin user` needs whoever administers the machine, as the last section of this chapter explains. For network blocks, locked package caches, or an install that died halfway, see the [Plugin packs and conda environments](../appendices/troubleshooting.md#plugin-packs-and-conda-environments) section of the **Troubleshooting** appendix.

### Disk usage

Required Setup alone is roughly 2.7 GB, and all ten optional packs together add about 5.9 GB, for something under 9 GB with everything installed. The databases are the real weight, and a single Standard or PlusPF collection at 67 GB or 72 GB outweighs every tool on the machine put together. Project folders never hold tool binaries or databases, so a project stays small and portable no matter how much you have installed.

## What good looks like

Four checks tell you the machine is set up the way you think it is. Every tool in the packs you installed reads **Ready** on the Packs tab. The Installed tab lists an environment for each of those tools, and expanding one shows real package versions rather than an empty list. The Databases tab shows an install date and a version for each database you downloaded, with no "(exceeds system RAM)" beside the one you plan to classify against. And **Check for Tool Updates…** comes back with nothing pending.

When one of those disagrees, suspect the install rather than the app. An interrupted download, an external drive unplugged mid-run, or a database downloaded outside the window and never refreshed accounts for most of what looks like a broken feature.

## On the command line

This section is optional. Skip it unless you drive a Mac remotely, over SSH, which means working on a distant machine by typing commands into a terminal on your own. Everything the Plugin Manager does has a command-line equivalent, which is what makes that possible. The `lungfish-cli` program ships inside the application, so installing LGE gave it to you, and the [CLI Reference](../appendices/cli-reference.md) appendix says where it lives and how to run it. Its `conda` command group manages tools and databases. Two of its other subcommands are worth knowing, `envs` to list the managed environments and `list` to show what is inside one.

```bash
# What is available, and what is on this machine already.
lungfish-cli conda packs
lungfish-cli conda envs
lungfish-cli conda list --env minimap2

# Install a pack, then a database sized for this Mac.
lungfish-cli conda install --pack read-mapping
lungfish-cli conda db recommend
lungfish-cli conda db download Viral
lungfish-cli conda db info Viral

# Bring the machine in line with the pinned dependency list.
lungfish-cli tools update --plan
lungfish-cli tools update --apply --yes
lungfish-cli conda db update --all --yes
```

Two command groups sit beside `conda`. `lungfish-cli tools update` compares this machine against the pinned dependency list bundled with the build and reports, or performs, the installs and updates needed to bring it in line. A word beginning with two dashes, such as `--plan`, is an option you add to change what the command does. With `--plan`, the default, it prints the work and exits without changing anything. With `--apply --yes` it does the work. `lungfish-cli provision-tools` installs micromamba itself, copying the version pinned in the app resources into place so conda workflows can run at all, and LGE normally does this for you without being asked. Its `--status` option reports whether micromamba is installed, and `--list-tools` names it without installing anything.

## Notes for shared workstations

Skip this section. It is written for whoever administers a machine several people share, and nothing in it is needed to use LGE on your own Mac.

On a shared workstation, an administrator can put the tool packs and databases on a larger shared volume so every user draws on one installation. LGE reads the `LUNGFISH_CONDA_ROOT` environment variable to make this work. Set it, and every LGE process, window and command line alike, treats that location as the install root.

The pattern that works is to set `LUNGFISH_CONDA_ROOT` in a shell startup file the other accounts inherit, install the packs and databases once from the Plugin Manager as the administrator, then leave the root readable and executable for everyone but writable only by the administrator. Other users then open LGE, see the packs and databases as installed, and run workflows against them. LGE takes an exclusive lock on the install root during any pack or database operation, so a second install waits its turn rather than corrupting a shared environment. An install attempt into a read-only root stops with `conda root is read-only; reinstall as the admin user`.

To relocate the whole managed storage root, not just the conda install root, set `LUNGFISH_STORAGE_ROOT` instead. When both are set, `LUNGFISH_CONDA_ROOT` still wins for the conda install location.

## Next

Continue to [Provenance and Reproducibility](08-provenance-and-reproducibility.md) to learn how LGE records every operation it runs, including which tool versions were installed at the time, and how to export that record for sharing or publication.
