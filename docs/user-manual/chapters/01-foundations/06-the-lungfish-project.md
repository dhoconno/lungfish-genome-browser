---
title: The Lungfish Genome Explorer Project
chapter_id: 01-foundations/06-the-lungfish-project
audience: bench-scientist
prereqs: [01-foundations/01-what-is-a-genome]
estimated_reading_min: 12
task: Understand the Lungfish Genome Explorer project bundle, the sidebar, the Inspector, and the Operations Panel.
tags: [foundations, project, sidebar, inspector, operations-panel, bundle, ui]
tools: []
parameters_refs: []
entry_points:
  - File > New Project (Cmd-N)
  - File > Open Project Folder... (Cmd-O)
  - View > Show Sidebar (Ctrl-Cmd-S)
  - View > Show Inspector (Cmd-Opt-I)
  - Operations > Show Operations Panel (Cmd-Shift-P)
shots:
  - id: welcome-window
    caption: "The Lungfish Genome Explorer Welcome window, with the Create Project and Open Project cards, the Recent Projects sidebar item, and the Third-Party Tools readiness panel below the cards."
  - id: empty-project-window
    caption: "A new empty project window with the sidebar on the left, an empty viewport in the centre, and the Inspector on the right."
  - id: sidebar-folder-conventions
    caption: "The sidebar of the demo project, showing the Analyses group above the Imports, Reference Sequences, Primer Schemes, and Extractions folders."
  - id: inspector-fastq-selected
    caption: "The demo project with a paired-end FASTQ bundle selected in the sidebar, the FASTQ operations view filling the viewport, and the Inspector showing dataset statistics and sample metadata."
  - id: inspector-fastq-detail
    caption: "The Inspector in close-up for the same FASTQ selection, showing read counts, length and quality statistics, ingestion settings, the pipeline that produced the dataset, and the editable metadata fields."
  - id: file-export-menu
    caption: "The File > Export submenu open, showing the sequence, annotation, FASTQ, metadata, and image export items above the Provenance submenu."
  - id: operations-panel-row
    caption: "An Operations Panel row mid-run, expanded to show the CLI command, the log buttons, the running log output, and the progress bar."
  - id: operations-panel-right-click-menu
    caption: "The right-click menu on a completed trim operation, showing Copy CLI Command, Copy Log, View Log, Reveal Log in Finder, and Clear."
illustrations: []
glossary_refs: [project, bundle, reference-bundle, primer-scheme, extraction, project-lock, inspector, operations-panel, sidebar, provenance, provenance-sidecar]
features_refs: []
fixtures_refs: [demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

A Lungfish Genome Explorer (LGE) [project](../../GLOSSARY.md#project) keeps imported files, derived bundles, and their [provenance](../../GLOSSARY.md#provenance) together in a `.lungfish` project bundle. Provenance is the record of where a file came from and what was done to it. A project bundle is an ordinary folder that Finder displays as one item rather than as a folder you can open. Double-click it and the app opens rather than a Finder window. To look inside, Control-click it (hold Control and click, or click with two fingers on a trackpad) and choose Show Package Contents. What you see there is an ordinary set of folders.

Inside that bundle sit two files you never edit. `.project.db` is hidden and `metadata.json` sits in plain sight beside the folders. `.project.db` is a SQLite database, which is a single-file database engine, and it holds the project's sequence catalog, the list of sequences the project knows about, along with its version history. `metadata.json` holds the project's own name, its format version, and the dates it was created and last changed. LGE writes both for you. Because the catalog is a database rather than a pile of files, the sidebar can show a stored sequence that has no separate FASTA file of its own in Finder.

A small number of analyses lean on reference databases tens of gigabytes in size, such as the Kraken2 standard database used to identify which organisms a sample contains. LGE installs those once and shares them across every project on the machine, so they sit outside the bundle deliberately. LGE checks the free space for you and offers another storage location when the disk is short. The project's provenance still records which database name and version a run used, which keeps the result reproducible. Reproducing it on another Mac takes a compatible LGE version, the same plugin packs, which are the optional sets of analysis tools LGE installs on request, and the same shared databases.

Open a project and one window appears with three panes that stay put. The [sidebar](../../GLOSSARY.md#sidebar) runs down the left and lists the project's contents as a folder tree. The viewport fills the centre and shows whatever you select, such as a sequence track, an alignment, a variants table, or a classification chart. Later chapters introduce each of those views in turn, so nothing is lost if none of them means anything yet. The [Inspector](../../GLOSSARY.md#inspector) runs down the right and holds metadata and actions for the current selection. A fourth window, the [Operations Panel](../../GLOSSARY.md#operations-panel), opens from the **Operations** menu and reports every long-running job.

LGE also ships a command-line tool, `lungfish-cli`, that mirrors most of what the window does. This chapter stays in the window. Read it once before any other interface chapter, because every later chapter assumes you can find the sidebar, the Inspector, and the Operations Panel by name.

## Why you would do this

Every other chapter in this manual starts by saying where something lands. Reads land under `Imports/`, references under `Reference Sequences/`, results under `Analyses/`. Reads are the short sequence fragments a sequencing machine produces from a sample. Those sentences only help if you already know that the project is one bundle on disk and that the sidebar is a picture of it. Learning the layout once means every later instruction reads as a location rather than as a puzzle.

The layout also carries meaning that nothing else records. A file under `Imports/` came off your own disk, and its history reaches back only as far as your copy of it. A file under `Downloads/` came from a public archive, and it arrived with a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), a small JSON file naming the source URL, the accession, the time of the fetch, and a checksum of the bytes. A checksum is a short fingerprint calculated from a file's contents, and a matching one shows the file has not been altered since it was fetched. When you later need to reproduce a published analysis, the download is the one you want, and the folder name is what tells you which is which.

This chapter uses the demo project, which is the worked project the manual's screenshots are taken from. It already holds imported reads, two reference bundles, and the results of several analyses, so every folder this chapter describes has something in it.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the demo project. Build it by following the instructions in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/demo-project. That page asks you to create an empty project named LGE Manual Demo in the app first, saved under `~/Desktop/lge-docs/`, and then to copy one command into the Terminal application and press Return, so it does need a terminal, and the page shows you exactly what to paste. The command fills the project in about two minutes. The `~` at the front of a path is shorthand for your home folder, the one named after your account.

You can also read this chapter against an empty project you make yourself. The tour of the sidebar then shows fewer folders, because a project grows most of them the first time a workflow needs one. Nothing here needs a plugin pack or Docker Desktop, so you can skip both for this chapter. Docker Desktop is a separate free application that runs an analysis tool inside a self-contained package of its own, which a few later chapters rely on.

One rule about who creates a project is worth knowing before you start. Only the app creates the project store, the `.project.db` file described above. This manual calls that file the project store throughout, and it is one file inside the project bundle rather than the bundle itself. **File > New Project** creates it, and so does the Create Project card on the Welcome window. `lungfish-cli` never does. A folder built only from the command line therefore has no store, and the app opens it as a read-only view of the files with "(Read Only)" appended to the window title. The reverse order works. Create the project in the app first, close it, and the command line can then fill it with reads, references, and results.

## Procedure

1. Launch LGE with no project open. The Welcome window appears. Its Get Started page offers the Create Project and Open Project cards and a setup panel underneath. Choose Recent Projects in the sidebar to see recent projects.

    <!-- SHOT: welcome-window -->

2. Read the setup panel before you go further. It reports whether the Required Setup pack is installed, with one status card per tool behind the Show Details button. You do not need to click Install for this chapter, because nothing here runs an analysis tool. Its Install button runs the setup, and a "Need more space? Choose another storage location…" link opens a sheet that moves the folder where LGE keeps its shared tools and databases somewhere with more room. If an installation or a storage change is already running, the project opens as soon as it finishes.

3. Click Open Project and choose the demo project at `~/Desktop/lge-docs/LGE Manual Demo.lungfish`. To make an empty project instead, click Create Project, pick a folder, type a name, and click Save. Either card has a menu equivalent, so **File > New Project** (Cmd-N) and **File > Open Project Folder...** (Cmd-O) do the same work from an open window. The wording differs between the Welcome window and the menu, and the actions do not.

4. Look at the window that opens. The window title carries the project name. The sidebar on the left shows the folder tree. The viewport in the centre is empty until you select something. The Inspector on the right is empty for the same reason.

    <!-- SHOT: empty-project-window -->

5. Bring back any pane that is missing, then open the Operations Panel. **View > Show Sidebar** (Ctrl-Cmd-S) restores the sidebar and **View > Show Inspector** (Cmd-Opt-I) restores the Inspector. **Operations > Show Operations Panel** (Cmd-Shift-P) opens the Operations Panel in a window of its own, empty until something runs. Leave it open while you read the rest of this chapter.

    Two more items widen the viewport when you need the room. **View > Focus Viewer** (Cmd-Opt-F) hides the sidebar and the Inspector at once, which helps when a wide result runs off the edge of the centre pane, and **View > Restore Side Panes** (Ctrl-Cmd-Opt-F) brings them back.

## The Welcome window

The Welcome window greets you whenever LGE launches with no project open. The Create Project card makes a new empty project bundle at a location you pick. The Open Project card opens an existing one through a file dialog. The Recent Projects list holds the projects you opened lately, capped at ten entries, and a click on any row reopens it. The same list appears inside an open project as the **File > Open Recent** submenu.

Below the cards sits the setup panel described in the procedure. It exists because analysis tools are installed separately from the app. You can open projects and use the built-in viewers before installing anything, and the actions that need external tools show their setup requirements when you reach them. The Plugin Packs chapter covers what gets installed and where.

## A tour of the sidebar

The sidebar is the authoritative view of the project, so when it and Finder disagree, trust the sidebar. Some folders are created with the project and others appear the first time a workflow needs one, so a young project shows fewer than the demo project does. Most bench work starts in `Imports/` and `Reference Sequences/`, and results then appear under `Analyses/`. The other folders in the table below fill in as particular workflows need them.

<!-- SHOT: sidebar-folder-conventions -->

| Folder | What lands there |
|---|---|
| `Imports/` | Anything you brought in from your own disk, such as reads copied off a sequencer or a reference a colleague mailed you |
| `Downloads/` | Reference records LGE fetched from NCBI, each arriving with its origin recorded. Reads fetched from SRA go through the import path and land under `Imports/` instead |
| `Reference Sequences/` | Reference bundles, each carrying the extension `.lungfishref` |
| `Primer Schemes/` | Primer-scheme bundles carrying the extension `.lungfishprimers`, which list the short DNA primers used to amplify a target region |
| `Extractions/` | Reads and reference regions pulled out into new bundles by an extraction operation |
| `Haplotype Definitions/` | Files listing which combinations of alleles travel together on one chromosome, used by the MHC genotyping chapters |
| `Phylogenetic Trees/` | Tree bundles carrying the extension `.lungfishtree`, built from an alignment in the window or imported |
| `Analyses/` | Every analysis result. A run by a named tool such as a classifier, a mapper, or an assembler gets its own subfolder named `<tool>-<timestamp>`, and a read operation from the operations window writes its result bundle here directly, named for the operation |

The angle brackets in `<tool>-<timestamp>` stand for values LGE fills in, so a real folder is named something like `kraken2-2026-09-04T14-12-33`. You never type that name yourself. A trimmed or decontaminated read bundle skips that subfolder and sits directly under `Analyses/` with a name built from its input and the operation, such as `HG002.chr20.10.0-10.5Mb-fastpTrim`. Most results record their provenance beside the output, and the Provenance and Reproducibility chapter shows where each one keeps it.

The Analyses group in the sidebar is worth one caveat. LGE builds that group from the project's own records rather than reading the folder directly, so it can list a result whose files Finder shows somewhere else. An empty project shows no Analyses group at all, and one appears as soon as the first result lands.

De novo assemblies are results, so they land under `Analyses/` beside everything else. A de novo assembly builds a genome sequence from reads alone, with no reference to compare against. They are packaged as `.lungfishref` bundles, exactly like a downloaded reference, and the two are interchangeable wherever a workflow asks for a reference. The folder tells you which is which. A bundle under `Reference Sequences/` was published by somebody else and a bundle under `Analyses/` was built here.

### What "bundle" means

Every time this manual says [bundle](../../GLOSSARY.md#bundle), it means a folder that Finder shows as a single icon with an extension. A `.lungfishref` is neither a zip archive nor a single file. It is a directory holding a `manifest.json` at the root, a `genome/` folder with the bgzip-compressed FASTA and its indexes, and optional `annotations/`, `variants/`, and `tracks/` folders alongside a provenance record. A genome index is a small companion file that records where each position sits inside the sequence file, so a tool can read one gene without scanning the whole genome first. Bgzip is a block-compressed form of gzip that lets a tool jump straight to one part of the file without unpacking the rest.

Bundles travel as a unit. Copy a `.lungfishref` into another project and the sequence, its indexes, its annotations, and its provenance all move together. You cannot strand an index from the FASTA it belongs to, or an annotation from the sequence it describes.

## Sharing a project and moving it forward

A project can be opened by more than one person when it sits on shared storage, so LGE writes a lock record inside the bundle to say who holds it. The record names the user, the Mac it was taken on, the running copy of the app, the app version, and the time it was taken, and both the app and the CLI read it before touching the project. The **Project Is Open Read Only** message appears when the lock belongs to somebody else, and it means what it says. You can still open the project and look at everything in it. Only writing is blocked, so nothing you have already saved is at risk.

A lock can outlive the copy of the app that took it, for example when a Mac is force-restarted mid-run. LGE calls that a stale lock and it has an explicit recovery path, which archives the old record and writes a note of why it was removed rather than deleting it quietly. The dialog LGE shows on opening offers a **Recover and Open** button that does this for you whenever the lock is not held by a live local process and the record is either readable or corrupted, and [Sharing a Project Between People](../appendices/shared-projects.md) walks through the confirmation it raises. The command line clears one as well. `lungfish-cli project lock <project>` takes a lock, `--mode` records what kind, and `lungfish-cli project unlock <project>` releases one, where `<project>` stands for the path to your own project bundle and the angle brackets are not typed. Both accept `--force`. On `lock` it replaces an active lock without the stale-owner checks, and on `unlock` it removes a lock even when another user or process holds it, so keep it for a lock you are certain nobody holds.

Project bundles carry a schema version, which is a number recording the layout LGE used when it wrote the project. A project written by an older LGE may need migrating before a newer one opens it, and you would see a message saying so when you try to open it. `lungfish-cli project migrate <project>` handles that, and it is deliberately cautious. It scans the bundles inside the project, leaves anything already current alone, and reports any older layout it cannot safely convert instead of rewriting it. Run it with `--dry-run` first to see what it plans to do. When it reports a layout it cannot convert, keep the project on the LGE version that wrote it and ask the maintainers before going further.

## Saving and exporting

LGE saves for you, and there is no Save or Save As command to look for. Project changes are stored when an import or an edit finishes successfully, so check the Operations Panel for work that is still running or has failed. Some editing tools hold your unfinished changes as a draft and ask you to apply or discard it before you leave, the sample metadata fields at the bottom of the Inspector among them. LGE remembers project windows and views when they close or the app quits. **File > About Saving…** explains this behaviour in the app.

Two menu items shape what enters and leaves a project. **File > Import Center...** (Cmd-Shift-I) is the main way data comes in, a tabbed window of cards where each card is a drop target for one kind of file. **File > Manage Project Storage…** goes the other way, reviewing what the project is using on disk and moving what you no longer need to the Trash.

<!-- SHOT: file-export-menu -->

Exports write separate files and never change the project. The **File > Export** submenu offers Sequences (FASTA/GenBank), Annotations (GFF3), FASTQ, Project Sample Metadata (CSV), Image (PNG), and Image (PDF), with a Provenance submenu underneath that the Provenance and Reproducibility chapter covers in full. Sequence and annotation exports choose their source in two steps. If you have selected an item in the sidebar, that is what gets exported. If you have selected nothing, LGE exports whatever the viewport currently shows. An annotation export asks you to choose a source when several supported sources are selected, reports the ones it cannot use, and names the source and the annotation count on the destination sheet. It never silently merges annotations from different sources.

## Searching the project

A search field sits at the top of the sidebar in every project window. Type into it and LGE searches the whole project as you type, matching datasets, references, annotations, classification hits, and analyses against an index it maintains in the background. You do not wait for that index. Anything you import can be found as soon as the import finishes. While a query runs, a small spinner and a "Searching project…" label appear just below the field. Clear the field and the full folder tree returns.

For a structured query, click the filter button to the right of the field to open the Advanced Search popover, which assembles the query so you need not learn any syntax. A Scope selector narrows the search to one kind of data, offering All Project Data, EsViritu, Kraken/Bracken, TaxTriage, FASTQ Datasets, VCF + Reference, and JSON Manifests. EsViritu, Kraken/Bracken, and TaxTriage are analysis tools that identify which organisms a sample contains, and the Classification chapters cover each of them, so leave the scope on All Project Data until you have run one. Below it, fields filter by Keywords, Virus, Family, Species, and Sample, by Min Unique Reads and Min and Max Total Reads, and by a Date From and Date To range typed as `YYYY-MM-DD`. Leaving the read-count fields blank is normal and returns everything, and a value like 50 in Min Unique Reads is a reasonable first cut when a classification returns too many faint hits. A "High-confidence pathogens only" checkbox restricts results to the organisms the classification tool itself flagged as confident calls. Apply writes the assembled query into the sidebar field and runs it, and Clear empties both the popover and the field.

## The Inspector

The Inspector is the right-hand pane, and it reacts to you. Its contents change the moment you change what is selected in the sidebar or the viewport.

<!-- SHOT: inspector-fastq-selected -->

Select the `HG002` paired-end FASTQ bundle under `Imports/` in the demo project and the Inspector shows the read count, the mean length, a per-base quality summary, and buttons to run a classification or a mapping. Paired-end means the sequencer read the same DNA fragment from both ends, giving two reads that belong together. The per-base quality summary is the average Phred score across the reads, a number saying how confident the sequencer was in each base it called. Scores above 30 are good and mean about one wrong base in a thousand, and an average below 20 is worth investigating before you go on.

Select an alignment track inside a `.lungfishref` and it switches to alignment statistics, showing the mapped and unmapped read counts, the proportion of reads that mapped, the mapper and preset that produced the alignment, and a button to call variants. Click a row in the Variants tab of the table drawer, the panel that slides up from the bottom of a reference bundle viewport, and the Inspector switches again. It shows that variant's position, alleles, quality, and filter, a genotype summary with the alternate allele frequency, its `INFO` fields, and a Copy Info button that puts the whole summary on the clipboard. `INFO` fields come from the VCF file format, the standard text format for recording variants, and the Variant Calling chapters cover what each field holds. Variants live in the table drawer rather than the sidebar because a single track holds far more of them than a sidebar could usefully list.

<!-- SHOT: inspector-fastq-detail -->

The FASTQ Inspector repays a close look, because the same shape repeats for every other kind of selection. The top names the item and gives its read count. Summary statistics follow, then the ingestion settings recorded at import time, then the processing pipeline that produced this exact dataset with a tool name, a command line, and an elapsed time for each step. Editable sample metadata sits at the bottom. Whatever you select, the Inspector shows what is known about it and what you can do next, and an empty Inspector means nothing is selected.

## The Operations Panel

The Operations Panel tracks long-running work as it happens, covering downloads, mappings, variant calls, classifications, and exports. Each of those kinds has its own chapter later in the manual, so you need not recognise them yet. The panel opens from **Operations > Show Operations Panel** (Cmd-Shift-P) in a window of its own.

Each operation gets a row showing its type, its name, a progress bar, and the elapsed time. Underneath the buttons, LGE runs established command-line tools such as minimap2 and Kraken2, so every operation has a command behind it. Click the disclosure triangle to expand a row and you get the command LGE built, buttons to view or reveal the log file, and the running log output in a scrolling area. Failed operations stay in the panel until you dismiss them with **Clear** on the row, so you can read the log and decide whether to run the work again.

<!-- SHOT: operations-panel-row -->

The panel covers the current session only. **Clear Completed** at the bottom removes finished rows, and **Operations > Cancel All Operations** stops everything still running at once. The durable record lives elsewhere, in the provenance sidecars and logs that finished workflows write into the project, and those outlast both the panel row and a relaunch. The [Provenance and Reproducibility](08-provenance-and-reproducibility.md) chapter covers reading and exporting them.

### When things go wrong

Right-click any row to act on it without leaving the panel. The menu is assembled from what that row supports, so a running row and a failed one do not offer the same items. A missing item means only that the row does not support that action, never that something has broken.

<!-- SHOT: operations-panel-right-click-menu -->

**Run Again…** appears at the top when LGE still holds enough of the original request to replay it. It is absent on rows that came from something other than a replayable workflow package, an ordinary file import among them. **Copy CLI Command** copies the exact command line that ran, which is the fastest way to reproduce a run by hand or to capture it for a bug report. **Copy Log** puts the log text on the clipboard, **View Log** opens it inline, and **Reveal Log in Finder** opens the folder at the log file. At the bottom, a running row offers **Cancel** and a finished one offers **Clear**. Cancellation is cooperative, so the tool is asked to stop and clean up rather than being killed outright. The row can sit for a few seconds before it reads as cancelled, because LGE waits for the tool to exit and clears away the partial output it owns first. Treat the row reading cancelled as the signal that the cleanup is done.

A failed row adds three more items. **Copy Failure Report** gathers the operation title, the command, the error message, the error detail, and the log into one block ready to paste. **Open GitHub Issue** opens a pre-filled issue in your browser with that report attached, which you review and submit yourself, so nothing is ever filed without your action. **Reveal Failure Report in Finder** points straight at the report file, and it appears on its own as soon as the failure is recorded, so it is already there when you open the menu. A failed row is not cancellable, so **Clear** takes the place of **Cancel** there.

When something fails and the message alone does not explain it, work through it in order. Open the panel, expand the failed row and read the inline log, then right-click and choose **Open GitHub Issue**. Add anything else in the browser before you submit. The [Troubleshooting](../appendices/troubleshooting.md) appendix lists the common failure modes and their fixes.

## Finding this manual inside the app

The manual ships inside the application. **Help > Lungfish Genome Explorer Help** opens it in the macOS Help Viewer, the system window that displays an application's built-in help, falling back to an in-app window when the Help Viewer is unavailable. Three shorter guides sit under it, Getting Started, VCF Variants Guide, and AI Assistant Guide, where VCF is the Variant Call Format, the standard text format for recording variants. Below those, Documentation and Release Notes open pages on the web.

**Help > Report an Issue...** opens a pre-filled GitHub issue template carrying the version string, and it is the right menu item when a failure is not tied to one operation. For a failure you can see in the Operations Panel, the right-click **Open GitHub Issue** route is faster, because it captures the command, the log, and the error for you. The [Keyboard Shortcuts](../appendices/keyboard-shortcuts.md) appendix lists every shortcut this chapter names.

## What good looks like

Four checks tell you a project is set up the way you think it is. Confirm the window title carries the project name without "(Read Only)" after it. That suffix has two causes, and they are easy to tell apart. If the project was made in the app and somebody else is in it, LGE shows the **Project Is Open Read Only** message naming who holds the lock. If no such message appears, the folder was built outside the app and never given a project store. Confirm the sidebar shows the folders you expect, remembering that a folder only appears once something has landed in it. Confirm that the folder a file sits in matches where it came from, so a downloaded reference is under `Downloads/` and not `Imports/`. And confirm that a finished run left a row in the Operations Panel and a result under `Analyses/`.

When one of those disagrees, suspect the project rather than the app. A project folder made outside LGE, a bundle copied without its provenance, or a lock left behind by a crashed run accounts for most of what looks like a missing feature.

## On the command line

The import commands here are optional, because the window does the same work. The lock, unlock, and migrate commands are not optional, because the window has no equivalent for them yet, which is why the Sharing section above sends you here. The app is the only thing that creates a project store, so the first step below is the one you cannot replace, and it stands in for **File > New Project**. Everything after it fills the project you already made.

Three details in the block are worth naming. A backslash at the end of a line only continues the command onto the next line, so you can type each command as one long line if you prefer. The project path is written with `$HOME` inside quotation marks, because the quotes keep the spaces in the name together and `$HOME` is the form of your home folder that works inside them, where `~` would not. The two import commands take different flags for the same path, `--output-dir` for `import fasta` and `--project` for `import fastq`, which is how the tool is built rather than a mistake here. Run `lungfish-cli import fasta --help` to see which flag any subcommand wants.

```bash
# 1. In the app: File > New Project, name it, save it, then close it.
# 2. Fill it from the command line.
lungfish-cli import fasta ~/Downloads/chr20.fasta \
  --name chr20 \
  --output-dir "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish"

lungfish-cli import fastq ~/Downloads/HG002_R1.fastq.gz ~/Downloads/HG002_R2.fastq.gz \
  --project "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish"

# Coordinate access when the project sits on shared storage.
# --mode records what kind of lock it is. Exclusive is the one most readers need.
lungfish-cli project lock "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish" --mode exclusive
lungfish-cli project unlock "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish"

# Check an older project before a newer LGE opens it.
lungfish-cli project migrate "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish" --dry-run
```

The two extensions are easy to confuse. A project bundle ends in `.lungfish` and a reference bundle inside it ends in `.lungfishref`. The CLI rejects a `--project` path that does not end in `.lungfish`.

## Next

Continue to [Plugin Packs](07-plugin-packs.md) to learn how LGE installs and manages the analysis tools the workflow chapters depend on.
