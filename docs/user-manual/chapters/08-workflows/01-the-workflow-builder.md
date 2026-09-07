---
title: The Workflow Builder
chapter_id: 08-workflows/01-the-workflow-builder
audience: analyst
prereqs: [01-foundations/06-the-lungfish-project, 01-foundations/08-provenance-and-reproducibility]
estimated_reading_min: 34
task: Compose a read-cleanup chain in the Workflow Builder window, save it into the project, and run it against a FASTQ bundle from the window or the command line.
tags: [workflows, builder, node-graph, fastq, experimental]
tools: [fastp, deacon, seqkit]
parameters_refs: [workflow.builder]
entry_points:
  - "Settings > Advanced (Show Experimental Features)"
  - "Tools > Workflow Builder (Experimental)..."
  - "CLI: lungfish-cli workflow builder-run"
  - "CLI: lungfish-cli workflow diff"
shots:
  - id: workflow-builder-experimental-toggle
    caption: "The Experimental Features section of Settings > Advanced, with the Show Experimental Features toggle that makes the Tools menu item appear."
  - id: workflow-builder-sidebar-library
    caption: "The Workflow Builder's left sidebar, showing the Workflows list above the node palette with its plus, duplicate, and trash buttons."
  - id: workflow-builder-palette
    caption: "The node palette with its Filter nodes search field and the four category headers it draws: Input, Trimming & Filtering, Decontamination, and Read Processing."
  - id: workflow-builder-canvas
    caption: "The canvas with the five-step read-cleanup chain composed by hand, running from FASTQ Bundle Input through to the pinned Project output anchor."
  - id: workflow-builder-node-inspector
    caption: "An Adapter + quality trim node selected, showing its Label field, the tool it runs, and the Configure... button in the right-hand inspector."
illustrations: []
glossary_refs: [adapter, bundle, checksum, deacon, directed-acyclic-graph, fastp, fastq, host-depletion, node-port, operations-panel, paired-end, pcr-duplicate, provenance, read, read-merging, reproducibility, seqkit, sliding-window-trimming, workflow-bundle, workflow-lineage]
features_refs: []
fixtures_refs: [human-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

If you run the same read-cleaning steps on more than two samples, stop repeating them by hand. Draw the chain once and run the saved file from then on. The Workflow Builder is the window in Lungfish Genome Explorer (LGE) where that drawing happens.

A read is one stretch of sequence the instrument produced. An adapter is a short synthetic sequence that library preparation attached to each fragment so the machine could bind it, and it is not part of the organism's own DNA, which is why it has to come back out of the data. In the Workflow Builder you draw a read-cleaning procedure as a chain of boxes and then run it. Each box is one operation, such as trimming [adapters](../../GLOSSARY.md#adapter) or dropping short [reads](../../GLOSSARY.md#read). You drag the boxes onto a canvas, connect them with lines, set each one's numbers, and click Run. What LGE saves is not a picture of a procedure but the procedure itself, so next month you can run the same chain on a different sample without opening five separate dialogs one after another. A dialog is a window that opens on top of the main one to collect settings before an action runs, and running those five steps by hand means opening five of them in turn.

The window is the only place this drawing happens. There is no command that composes a chain for you, and there are no starter templates and no menu item that generates one, so the chain this chapter builds is the intended starting example. What the command line does offer is the other half of the job. Once a chain exists as a file, `lungfish-cli workflow builder-run` executes it and `lungfish-cli workflow diff` compares two versions of it, which you will not need if you work in the window. This chapter runs both against real data. So the honest summary is that composing is window-only and running is available in both places.

The whole drawing is a set of boxes joined by one-way arrows in which no path ever leads back to where it started, which has a name, a [directed acyclic graph](../../GLOSSARY.md#directed-acyclic-graph). This chapter calls the boxes nodes and the lines connections, which is what the app's own code calls them. Chain, workflow, and graph all mean the same drawing in this chapter. The one-way property is why LGE refuses to let you connect a node's output back into anything upstream of it, meaning earlier in the chain. A procedure that fed itself would never finish.

One boundary matters more than any other and it is easy to assume more than it means. The palette, which is the list of node types you drag from, offers six node types and nothing else, all of them concerned with cleaning FASTQ files. [FASTQ](../../GLOSSARY.md#fastq) is the plain-text format that holds sequencing reads along with a quality score for every base, a quality score being the instrument's own estimate of the chance that it called that base wrong. There is no mapping node, no variant-calling node, no assembly node, and no download node. Those operations live in their own dialogs elsewhere in LGE, and a finished run made with them can still be turned into a shareable pipeline, meaning a fixed sequence of analysis steps that runs start to finish on its own. [Exporting as Nextflow or Snakemake](02-exporting-as-nextflow-or-snakemake.md) covers that.

## Why you would do this

The reason to build a chain rather than run five dialogs is that the five dialogs do not remember each other. Each one records what it did, which is why [provenance](../../GLOSSARY.md#provenance) exists, provenance being a record of what was run and with what settings. Nothing in that record says the five steps belonged together or in what order a colleague should repeat them. A saved chain says exactly that, and it says it in a file a colleague can open.

The second reason is that the numbers travel with the chain. Say you decided that reads shorter than 50 bases are not worth keeping, because a read that short matches too many places in a genome to tell you which one it came from. That decision lives inside the file rather than in your memory of which value you set months ago. Someone who opens the file six months later gets your thresholds, not the defaults.

The third reason is smaller and practical. A chain records where its input file sits inside the project folder rather than where it sits on your particular Mac, so moving the project to another machine does not break it. LGE enforces this. A chain whose input points outside the project is refused when you run it, and this chapter shows the exact refusal.

This chapter builds its chain over the HG002 mitochondrial reads, a human sample. HG002 is a widely used human reference sample that sequencing groups run to check their methods. That choice makes one of the five steps behave in a way worth watching closely, and the Reading the results section returns to it.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder.

This chapter uses the HG002 mitochondrial reads. Download the folder `human-mito` from the manual's fixtures on GitHub. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`. That ZIP holds the whole repository and only two files inside it matter here, so you can delete the rest once you have them. The folder page at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/human-mito is worth opening to confirm the file names, but it offers nothing to download.

The two files this chapter needs are `HG002.chrM_R1.fastq.gz` and `HG002.chrM_R2.fastq.gz`. Import them following [Importing FASTQ Files](../03-reads/01-importing-fastq.md), which recognises them as the two halves of a [paired-end](../../GLOSSARY.md#paired-end) library and groups them into a single [bundle](../../GLOSSARY.md#bundle). Paired-end means the instrument read each DNA fragment from both ends, and a bundle is a folder LGE treats as one object and draws as a single sidebar row. LGE derives the bundle's name itself, `HG002.chrM.lungfishfastq` under the project's `Imports` folder, so you type nothing.

That bundle holds 19,916 reads, which is 9,958 pairs, with a mean read length of 248.4 bases. Those are the figures for this deliberately tiny practice dataset rather than figures to expect from a real experiment, and they are given so you can check your own import matches before you go on. A real mitochondrial library would hold hundreds of times more reads.

This feature is experimental. Turn on **Show Experimental Features** in **Settings > Advanced** before you look for it. Settings opens from **Lungfish Genome Explorer > Settings...** (Cmd-comma), and Advanced is one of the tabs across the top.

<!-- SHOT: workflow-builder-experimental-toggle -->

That toggle is required, not optional. The **Tools > Workflow Builder (Experimental)...** item is added to the menu only when the setting is on, so with it off there is no menu item to find and nothing on screen explains why. The settings pane says beside the toggle that experimental features may be incomplete, may change without compatibility guarantees, and are not intended for production scientific work, and a second note under a Workflow Builder heading says the builder is marked experimental while the builder and the runner are being validated. Take that at face value. Use this window to learn the mechanics and to keep a repeatable record of what you ran, and put a result you intend to publish through the individual dialogs that are not marked experimental.

The chain calls three tools. [fastp](../../GLOSSARY.md#fastp) trims adapters and low-quality bases, [Deacon](../../GLOSSARY.md#deacon) removes reads that came from the host, and [seqkit](../../GLOSSARY.md#seqkit) filters reads by length. All three are included in the Required Setup pack that LGE installs as a unit, so there is no separate install step for them.

Deacon also needs its human index, and that one is already there. An index is a prepared, searchable copy of a genome, built ahead of time so a program can check a read against the whole human genome in a moment rather than in an hour. It belongs to the Required Setup pack that installs with the app, so nothing is left for you to fetch.

To confirm it, open the Terminal application from the Applications folder under Utilities, or by pressing Cmd-space and typing its name, and type this one line.

```bash
lungfish-cli conda db install-managed --list
```

That prints the managed databases and marks the ones already installed, and `deacon-panhuman` is among them. The Plugin Manager shows the same fact a second way. Open it with **Tools > Plugin Manager...** (Cmd-Shift-B) and look inside the Required Setup pack for the row named **Human Read Removal Data**, which reads **Ready**. The Databases tab does not list the index, because that tab carries only the Kraken 2 catalogue.

## Procedure

Every number and every quoted line in this chapter came from real runs made on 2026-09-07 with LGE 2026.9.13, using fastp 1.3.6, Deacon 0.16.0, and seqkit 2.13.0. Those version numbers are here for the record rather than as something to match. Different tool versions shift the exact counts a little without changing what any of them mean, so expect your own figures to be close rather than identical.

### 1. Open the window and create a workflow

Choose **Tools > Workflow Builder (Experimental)...**. A window opens with three panes. The left sidebar holds the project workflow library above the node palette, the canvas is in the middle, and the node inspector is on the right. The inspector is the panel that shows the selected node's settings, and this chapter uses that name from here on. The sidebar and the inspector can each be hidden, and the canvas cannot.

The top of the sidebar is a list headed **Workflows** with three small buttons beside the heading, whose tooltips read New workflow, Duplicate workflow, and Delete workflow. A tooltip is the small label that appears when you rest the pointer on a button. This list is the whole of workflow management.

Saving works differently here than in most Mac applications, so read this before you draw anything. There is no **File > Save Workflow** item and no Cmd-S binding. Clicking **Run** saves the current drawing into the library before it starts, so a chain you have run is always a chain that has been saved. Nothing else saves on its own. If you close the window with unsaved changes, LGE asks whether to save them and offers Save, Don't Save, and Cancel, and choosing Don't Save discards the drawing for good. The safe habit is to run a chain as soon as it is complete, and to choose Save if that prompt ever appears.

<!-- SHOT: workflow-builder-sidebar-library -->

Click the plus button. A prompt titled **New Workflow** appears, with the message "Name this workflow before adding it to the project library.", a name field prefilled with `New Workflow`, and a **Create** button. Name it `Mito read cleanup` and click Create. LGE writes the workflow into the project at `Workflows/Mito read cleanup.lungfishflow`. Right-clicking a row in the list offers **Rename**, **Duplicate**, and **Delete**.

The canvas is not empty. Two pinned nodes sit on it from the start, labelled **Sample input** on the left and **Project output** on the right. Pinned means they cannot be dragged and cannot be deleted, and the rest of this chapter leaves the Sample input anchor alone. It is an older way of choosing the input, left in place so that chains drawn before this one still work, and it asks you to pick a sample each time the chain runs. Nothing is broken about it and this chapter simply does not use it. The chain you are about to build names its input inside the drawing instead, which is the route to follow.

### 2. Read the palette

The palette sits below the workflow list. A search field with the placeholder **Filter nodes** sits above it and narrows the list by node name as you type.

The palette shows four category headers, **Input**, **Trimming & Filtering**, **Decontamination**, and **Read Processing**. Click a header to expand or collapse it, and all four arrive expanded. Rest the pointer on a node and LGE shows its name and the data type of each input and output port. A [port](../../GLOSSARY.md#node-port) is a labelled connection point on the edge of a node. Its data type is the kind of thing that may flow through it, and in this palette there is only one kind, a FASTQ bundle of reads.

<!-- SHOT: workflow-builder-palette -->

Six node types live under those four headers, and the whole palette is the following table. Remove PCR duplicates is worth a word before the table. PCR is the copying reaction that library preparation uses to make enough material to sequence, and it sometimes copies one original fragment many times over. Those copies come back as separate reads that look like independent evidence and are not, so a step that collapses them to one gives a truer count.

| Node | Category | Input port | Output port |
|---|---|---|---|
| FASTQ Bundle Input | Input | none | Reads (FASTQ Bundle) |
| Remove PCR duplicates | Trimming & Filtering | Reads (FASTQ Bundle) | Deduplicated (FASTQ Bundle) |
| Adapter + quality trim | Trimming & Filtering | Reads (FASTQ Bundle) | Trimmed (FASTQ Bundle) |
| Remove short reads | Trimming & Filtering | Reads (FASTQ Bundle) | Filtered (FASTQ Bundle) |
| Remove human reads | Decontamination | Reads (FASTQ Bundle) | Scrubbed (FASTQ Bundle) |
| Merge overlapping pairs | Read Processing | Reads (FASTQ Bundle) | Merged (FASTQ Bundle) |

Every one of those output ports is a FASTQ bundle. The names Deduplicated, Trimmed, Filtered, Scrubbed, and Merged describe what the node did, not different kinds of port, so any of them connects to any input port in the table.

One port needs a caution. Merge overlapping pairs takes a plain Reads port typed the same as every other, and the port does not check whether the reads are paired. Single-end means the instrument read each fragment from one end only, so those reads have no mate to merge with. Wire single-end reads into this node and the step runs and finds nothing to merge, instead of being blocked.

The rest of this section is background, and a first-time reader can skip to step 3 without losing anything. The app's own code defines eleven further node types across three categories the palette never draws, Preprocessing, Analysis, and Output. They exist so a file written by an older version, or by another tool, still opens, and so the Nextflow and Snakemake exporters have something to render. You cannot place one, because the palette never offers them. Two facts about them are worth carrying if you ever open such a file. The Trimming type does hold settings of its own, a minimum length defaulting to 20 and a quality threshold defaulting to 15, and the Quality Control type holds a Fail on QC error switch that is off by default. The four Analysis types carry no scientific settings at all, so a saved graph containing an Alignment node holds nothing about how the alignment would be done.

### 3. Place the nodes

Click and hold a palette entry, drag it onto the canvas, and release. The node appears where you dropped it with its ports drawn along its left and right edges. Drag anywhere on a placed node to move it. The two pinned anchors do not move. To delete a node, select it and press `Delete`, or forward delete, which on a laptop keyboard with one Delete key means holding Fn and pressing Delete. The two pinned anchors ignore both keys.

Place all six in a left-to-right row, starting with **FASTQ Bundle Input** at the far left and then, in this order, **Remove PCR duplicates**, **Adapter + quality trim**, **Remove human reads**, **Merge overlapping pairs**, and **Remove short reads**. That order is the one the next step wires together, and it is chosen so the faster steps run first and the slow human-read comparison has fewer reads left to work through.

Four canvas conveniences save time here. The toolbar carries **Zoom In** and **Zoom Out**, whose tooltips name Cmd-plus and Cmd-minus, a **Reset Zoom** that returns to 100 percent, and **Grid** and **Snap** toggles. Grid shows a faint square grid behind the canvas, and Snap makes a dropped node settle onto the nearest line of that grid. With the grid in view, the arrow keys nudge a selection one grid square at a time. Drag on empty canvas to draw a selection box around several nodes at once. Undo and redo work on the canvas as they do everywhere else.

<!-- SHOT: workflow-builder-canvas -->

### 4. Connect them into one straight line

Click an output port and drag to an input port on another node, then release over the target to finish the connection. The line follows a curve that redraws as you move either node. Click a line once to select it and press `Delete` to remove it.

Wire the chain as a single straight line, from **FASTQ Bundle Input** through the five operation nodes in the order above and finally into **Project output**. Keep it straight, because the runner requires it. The canvas will let you draw a second line out of one node, so that its output feeds two nodes downstream, and the Nextflow and Snakemake exporters accept that shape too. The runner does not. There is no check that catches it while you draw, so Run is where you find out. Running such a graph from the command line produced this exact refusal.

```
Error: Workflow Builder runner requires a single linear FASTQ chain: Node 'FASTQ bundle input' must have exactly one outgoing connection.
```

If you meet that message, delete the extra connection so that each node feeds exactly one node downstream, then run again.

LGE checks a connection before it accepts one. A port only accepts another port of the same data type, so a Reads port joins another Reads port and nothing else. The pinned Project output is the exception, because its data type is Any, which accepts every kind. Two further exceptions cover node types the palette never offers, so they cannot arise in a chain built from this chapter. Drawing a connection LGE cannot accept makes it play the system alert sound and drop the line, and drawing the same connection twice is rejected the same way. So is any connection that would form a loop. There is no on-screen message for a refused connection, only that sound, so on a muted Mac watch for the line failing to appear.

### 5. Set the parameters

Click a node to select it and the right-hand inspector shows that node. Every node begins with a **Label** field holding the name drawn on the box, which you may change to something meaningful without changing what the node does.

Start with the input node. Below its Label field the inspector shows a **FASTQ bundle** popup listing the bundles in the open project. Choose `HG002.chrM`. Below the popup, LGE shows the file's full location on your Mac. What the node stores is not that full location but the shorter form `@/Imports/HG002.chrM.lungfishfastq`, where `@/` stands for the project folder itself. That is what lets the project move to another Mac without breaking the chain.

<!-- SHOT: workflow-builder-node-inspector -->

The five operation nodes work differently, and this is a defect in 2026.9.13 worth knowing before it puzzles you. Their settings are not shown in the inspector at all. Select one and the inspector shows its Label, the name of the tool it runs, a **Configure...** button, a summary of its ports, and a validation summary. The eight numbers and switches those nodes carry live behind that button. Click **Configure...** to open the shared FASTQ/FASTA Operations dialog, which is the same dialog [Trimming and Filtering Reads](../03-reads/04-trimming-and-filtering.md) documents, set the values there, and click Apply to hand them back to the node.

You do not need to do that for this run. Every operation node arrives at the values this chapter uses, so the defaults are already correct for this fixture and there is nothing to type or check before you run. The Settings section below documents all twelve controls, and says which node each one belongs to so you know where to look for it behind **Configure...**.

### 6. Run it

Click **Run** in the toolbar. LGE validates the drawing first and, if anything is wrong, stops with a **Workflow Not Ready** alert listing the problems it found. It looks for an empty drawing, a loop, an input node with nothing wired out of it, a required port with nothing wired into it, and an output node with nothing wired into it. It also rejects a node setting it does not recognise or one that is required and missing, which cannot happen in a chain you built from the palette and left at its defaults. That check exists for a file written by another version of LGE, or one edited by hand outside the app.

Three further refusals are worth knowing before you meet them. **No Active Project** appears when no project is open, since the `@/` paths have nothing to resolve against. **Input Bundle Not Ready** appears when the FASTQ Bundle Input node has no bundle chosen or the one it names cannot be found. A project opened read-only refuses the run rather than writing into it. A project goes read-only when another copy of LGE already has it open, or when the disk it lives on has gone away, and you can see the state two ways, in the words `(Read Only)` after the project name in the window title and in a banner across the top of the project window.

Because this chain names its input inside the drawing, the run starts as soon as validation passes and nothing asks you which sample to use. Had you left the pinned Sample input anchor in the chain instead, a small sheet would appear offering a Sample popup, a Project label, and Run and Cancel buttons.

While the run proceeds, the [Operations Panel](../../GLOSSARY.md#operations-panel) in the main project window, which you open with **Operations > Show Operations Panel** (Cmd-Shift-P), shows two rows and not one per node. One is a parent row named after the workflow and the other is a row for the runner itself. Both carry the same run identifier, which is a long string of letters and digits such as `9008AAD2-0223-4F26-9CD8-00E36F21940C` that LGE makes up to tell one run from another. You can work elsewhere in LGE while it finishes.

## Settings

Twelve controls live in this window. Nine belong to individual nodes and three are window controls that belong to no node. None of the twelve has a command-line flag, because the command line runs a saved file rather than composing one, so that fact is stated here once and not repeated under each entry. Eight of the nine node settings are reached through the **Configure...** button rather than the inspector, as step 5 explains, and each entry below names the node it belongs to.

**FASTQ bundle.** Names the reads the whole chain will run on, chosen from a popup of the bundles in the open project, on the FASTQ Bundle Input node. It arrives unset and its allowed values are the project's own bundles, stored in the `@/` form such as `@/Imports/HG002.chrM.lungfishfastq` rather than as a location on your Mac, which is what lets the file move between machines. Set it once per chain, and change it to run the same sequence of steps on a different library. This is the one node setting the inspector shows directly.

**Detect adapters.** Lets fastp work out the adapter sequence from the reads themselves rather than being told it, on the Adapter + quality trim node. It is on by default and takes only true or false, and detection is on because leaving adapter sequence in makes reads look like they carry bases the sample never had. Turn it off only when you already know the adapter and supply it another way, since detection takes almost no extra time.

**Quality threshold.** Sets the lowest quality score that survives trimming on the Adapter + quality trim node, and it accepts whole numbers from 0 to 93. The scale runs so that every rise of 10 divides the estimated chance of a wrong base by ten, so 10 means about 1 base in 10 wrong, 20 about 1 in 100, and 30 about 1 in 1,000. The default is 15, which sits between 1 in 10 and 1 in 100. The top of the scale exists for formats that allow it rather than for real data, where scores above 40 almost never occur. Raise it toward 20 when the calls downstream must be conservative, and lower it when a thin run needs every base it can keep.

**Window size.** Sets how many neighbouring bases fastp averages when it decides where quality has fallen off, on the Adapter + quality trim node, and it accepts whole numbers of 1 or more. The default is 5. A larger window smooths over a single bad base, and a smaller one reacts to that one base and can cut a read short for no good reason, which is the greater risk of the two, so 5 sits nearer the small end without reaching it. Change it rarely, because [sliding-window trimming](../../GLOSSARY.md#sliding-window-trimming) at 5 is the ordinary setting for Illumina data.

**Cut mode.** Chooses which end of each read the sliding-quality trim works from, on the Adapter + quality trim node, and it offers exactly four values, `right`, `front`, `tail`, and `both`. Both `right` and `tail` trim from the 3-prime end, which is the end the instrument reads last and where quality falls off, so on this data they behave alike and `right` is the default. `front` trims from the other end and `both` trims from each. Choose `front` or `both` when the run's quality plots show the first bases are also poor, which happens on some sequencing kits.

**Database.** Names the human reference index Deacon uses to spot and drop human reads, on the Remove human reads node. Its default and its only allowed value are both `deacon-panhuman`, so the control records the choice rather than offering a real alternative. Change it rarely, since there is nothing else to change it to.

**Minimum overlap.** Sets how many bases the two reads of a pair must share before fastp joins them into one longer read, on the Merge overlapping pairs node, and it accepts whole numbers of 1 or more. The default is 15, short against this chapter's 248-base reads but long enough that two reads which never really overlapped will rarely match by chance across all fifteen, which would fuse two unrelated sequences into one wrong read. Raise it when the fragments are long enough that real overlaps are large.

**Minimum length.** Drops any read shorter than this after trimming, on the Remove short reads node, and it accepts whole numbers of 0 or more. The default is 50 bases, long enough that a read usually matches one place on a genome rather than many when it is later compared against one, and reads that match everywhere add noise rather than evidence. Raise it for a reference full of repeats, and lower it when the target region is itself short.

**Maximum length.** Drops any read longer than this, on the Remove short reads node, and it accepts whole numbers of 1 or more. It arrives unset, meaning no upper limit, which keeps every read that passed the minimum. Set it when a protocol that should give reads of one fixed length has produced much longer ones, which usually means two fragments were stuck end to end during library preparation rather than that one long molecule existed, so on a 250-base protocol a limit of about 400 would catch them.

**Filter nodes.** Narrows the palette to node types whose name contains what you type, and it is the search field above the palette rather than a node setting. It starts empty, accepts any text, and clearing it brings the full list back. Use it to reach a node without scrolling.

**Grid.** Shows or hides the faint alignment grid behind the canvas, as a toolbar toggle rather than a node setting. It is on by default and takes only on or off. Turn it off for a cleaner picture of a finished chain.

**Snap.** Makes a dragged node settle onto the nearest grid position rather than stopping wherever you released it, as a toolbar toggle rather than a node setting. It is on by default and takes only on or off, and it is on because a row of aligned nodes is easier to read than a scattered one. Turn it off when you want a node exactly where you put it.

**Remove PCR duplicates** deserves one line of its own, because it is the only node with no settings at all. It runs, and there is nothing to set.

### Options that exist only on the command line

Five more options belong to the command that runs a saved file rather than to the window, so they have no control anywhere in it. If you work only in the window, skip to the next section without losing anything.

**`--workflow`.** Names the `.lungfishflow` bundle or the graph JSON file to run. It has no default and the command refuses to start without it. Pass the folder itself for a bundle, since the command finds the `workflow.json` inside it.

**`--project`.** Names the `.lungfish` project directory that the graph's `@/` paths resolve against. It has no default and the command refuses to start without it. It is the same project the window would have open.

**`--run-directory`.** Chooses where run state and intermediate files are written. When you omit it the command derives one, and the two shapes it derives are the subject of the Reading the results section below. Pass it when you want the working files somewhere specific, such as a fast local disk.

**`--threads`.** Sets how many processor cores the tools in the chain may use at once. The default is 4, which is safe on every Mac LGE runs on and leaves most of the machine free for other work, so you never need to look your own core count up. Raise it to finish sooner on a machine you are not otherwise using.

**`--dry-run`.** Compiles the chain into an executable plan and prints that plan as JSON without running a single tool. It is off by default. Use it to see exactly which commands a chain would issue before you spend the time running them.

## Reading the results

A run leaves three things behind, and where the first two land depends on what you pointed the runner at.

Run the saved `.lungfishflow` bundle and each run gets its own folder at `runs/<run-id>/` inside that bundle, where the run identifier is the long string of letters and digits the Operations panel showed. A `.lungfishflow` bundle is a folder that the Finder draws as one file, so to look inside it, right-click it and choose **Show Package Contents**. Run a bare graph JSON file instead, which is what a scripted run often does, and the runner has no bundle to write into, so it derives an ordinary folder under the project at `Workflow Runs/<run-id>/`. Both were confirmed by running the same chain each way.

Inside that run folder sit three things. `builder-plan.json` is the compiled plan, the same JSON that `--dry-run` prints. A `workspace` folder holds the intermediate files each step handed to the next, which are working copies rather than results, so they are safe to delete once you have read the counts out of them. An `outputs` folder holds the finished bundle.

The finished bundle is a new `.lungfishfastq` named for the input and the workflow together, which on the reference run was `HG002.chrM-mito-read-cleanup.lungfishfastq`. It records the bundle it came from as `@/Imports/HG002.chrM.lungfishfastq`, and it carries a [lineage](../../GLOSSARY.md#workflow-lineage) of five entries, one per logical step, each holding the exact command that produced it. The lineage spells the five steps in the app's internal names rather than the node names you placed, so this table maps them.

| Node you placed | Lineage key |
|---|---|
| Remove PCR duplicates | `deduplicate` |
| Adapter + quality trim | `fastpTrim` |
| Remove human reads | `humanReadScrub` |
| Merge overlapping pairs | `pairedEndMerge` |
| Remove short reads | `lengthFilter` |

The bundle also holds a `provenance.json` recording the run that made it, which is the file to hand a colleague who asks what you did.

### What the reference run did to the reads

Read the counts before reading anything else, because they are where the chain either did what you meant or did not. Every figure in this table is a count of reads, never of pairs.

| Step | Tool | Reads in | Reads out | Verdict |
|---|---|---|---|---|
| Remove PCR duplicates + Adapter + quality trim | fastp 1.3.6 | 19,916 | 19,752 | as expected |
| Remove human reads | Deacon 0.16.0 | 19,752 | 318 | expected, see below |
| Merge overlapping pairs | fastp 1.3.6 | 318 | 225 | as expected |
| Remove short reads | seqkit 2.13.0 | 225 | 106 | as expected |

Four rows for five nodes is not an error, and the first row explains why. Remove PCR duplicates and Adapter + quality trim are combined into one fastp command when they sit next to each other, carrying both `--dedup`, which is the option that drops the duplicate copies, and `--cut_right`, which is the option that trims from the 3-prime end. Merge overlapping pairs also runs fastp but is never combined with anything, even when it sits beside another fastp step. The record names both combined steps inside that one row, and the lineage still lists five entries, so nothing about the accounting is lost.

That first row loses only 164 reads of 19,916, well under one percent, which is what a clean library should look like at this stage. A first step that removed a large share would be worth stopping over.

The second row deserves the most attention, and it is why this chapter uses a human sample. Deacon removed 19,434 of 19,752 reads, leaving 318, which is a 98.4 percent depletion. That is not a fault. These are human mitochondrial reads and Remove human reads does [host depletion](../../GLOSSARY.md#host-depletion), meaning it drops reads that came from the organism the sample was taken from. Pointed at human data it does exactly what it says. The plain lesson is that a step that is right for one experiment can be wrong for another. Keep this node in a chain when you are hunting for something that is not the host, and take it out when the host is your subject.

The third row falls from 318 to 225, and the reason is arithmetic rather than loss. [Read merging](../../GLOSSARY.md#read-merging) joins the two mates of a pair into one longer sequence where they overlap, so two reads become one and the count has to fall. It does not fall by half, because fastp also writes out the pairs it could not merge, so the 225 mixes merged single reads with unmerged mates.

What merging bought shows up in length rather than in count. The final bundle held 106 reads over 30,498 bases. That is a mean read length of 287.7 bases, up from the input's 248.4, and the rise is the merged pairs being longer than either mate alone.

Now the honest reading of that last figure. Starting from 19,916 reads, this run ends with 106, because a chain built to find something other than the host was pointed at a sample that is nothing but host. That is what this deliberately tiny practice dataset gives, and it is the expected outcome rather than a mistake in your setup. The point of this run is the mechanics of building a chain and the record it leaves behind, not the reads at the end. Do not treat 106 reads as a finding, do not draw a conclusion from them, and do not carry them into an analysis. On a real sample the same chain would be pointed at data where the host is the background rather than the whole story.

The output bundle is published all at once rather than a piece at a time, so an interrupted run leaves no half-finished bundle behind. Either the bundle and its [reproducibility](../../GLOSSARY.md#reproducibility) record both arrive, or neither does.

### When a run fails

A failure stops the run, raises an alert naming the workflow, marks the run failed, records the failing node when LGE can work out which one it was, and leaves every unfinished node in the `skipped` state. Per-node status is one of pending, running, succeeded, failed, or skipped.

Those five words are not drawn on the canvas and not shown in the inspector. In 2026.9.13 the only place they appear is the run record file described next, so what you watch on screen while a run proceeds is the two Operations panel rows, and what tells you which node stopped is that file.

A run made from the Workflow Builder window writes `run.json` and `provenance.json` into `runs/<run-id>/`, holding the timestamps, a checksum of the drawing, the sample and project bindings, the per-node statuses, any error message, and the run's own provenance. Open the run folder with **Show Package Contents** as above and read `run.json` in TextEdit. A run started from the command line writes neither of those two files, which the command-line section below returns to.

### Comparing two versions of a chain

Every saved chain carries a version such as `1.0.0`, written into the `workflow.json` inside the bundle. In 2026.9.13 nothing changes that number. LGE stamps `1.0.0` on every chain it saves, no control anywhere raises it, and the only way a chain carries a different version is if someone edited `workflow.json` by hand. Saving also appends a line to `versions/history.json` recording the version, the workflow name, and the time. Because clicking Run saves first, a run adds a line to that history even when you changed nothing, so the history is a log of saves rather than of edits. A run started from the command line adds no line, because the command line never saves.

`workflow diff` compares two saved chains. Comparing two hand-edited copies, one with the minimum length at 50 and the version at `1.0.0` and the other at 100 and `1.1.0`, produced this.

```
Workflow diff: Mito read cleanup (1.0.0) -> Mito read cleanup (1.1.0)
- Version: 1.0.0 -> 1.1.0
- Node Remove short reads parameter minLength: 50 -> 100
```

The text names version changes, added or removed nodes, changed node settings, and changed connections. Its `--format` option accepts `text`, `json`, and `tsv`, but a defect in 2026.9.13 makes all three print the text form. This is a known defect in this release, and nothing in the app or in the project's tracked issues says when a fix will land, so plan around it rather than waiting for it. It affects only a script trying to read the comparison, never the values themselves, which are correct in the text output above. A script should read the two `workflow.json` files directly instead.

## What good looks like

Start with the run itself. The Operations panel's two rows should both finish without an error, and a failure raises an alert naming the workflow, so a run that ended quietly is a run that reached the end.

Then check the counts step by step. A chain that ran without an error still ran wrongly if a step you did not think about removed most of your data, which is exactly what Remove human reads did here. The lineage in the finished bundle records the command each step ran but not how many reads went in and out, so the counts come from the tool reports the run leaves in its `workspace` folder. Open the run folder, then `workspace`, and read `<name>_fused_fastp_report_<id>.json` for the fastp steps and `<name>_deacon_summary.json` for the human-read step. Compare those against the finished bundle's own read count, which the bundle's viewport shows when you select it in the sidebar. Ask of any large drop whether you meant it.

Then check that four numbers agree with what you set. Select the finished bundle's run row in the Operations panel, click **More** to expand it, and the panel shows the command that ran with a Copy button beside it. The run's fastp command should carry the quality threshold as `-q`, the window size as `-W`, and the cut mode as `--cut_right` or its equivalent, and the seqkit command should carry the minimum length as `-m`. The reference run's combined fastp call read `-q 15 -W 5 --cut_right` and its seqkit call read `-m 50`, which are the defaults this chapter used. To see what the chain currently holds, select the node in the builder and click **Configure...**. If a number in the command does not match the number in that dialog, you are looking at a different saved version than the one on screen.

Then check the parent. Select the finished bundle in the sidebar and its Inspector shows the lineage block, which should name the bundle it came from, here `@/Imports/HG002.chrM.lungfishfastq`. A bundle with no parent recorded cannot tell anyone where its data came from, so if you find one, rerun the chain rather than trusting it, since the record is the whole reason to use this window.

Then check that the chain is portable before you send it to anyone. In the builder, select the FASTQ Bundle Input node and confirm the path under the bundle popup names a file inside the project rather than one somewhere else on your Mac. LGE enforces this when the chain runs rather than when it saves, so a chain with a bad path saves quietly and fails later. Pointing the input at a path outside the project produced this refusal, where the middle of the path has been shortened here to fit the page.

```
Error: FASTQ bundle input is outside the active project: /tmp/.../Outside.lungfishfastq
```

Finally, treat a first run as a rehearsal. Run the chain once on one sample and read the counts before pointing it at thirty samples overnight.

Two further checks are optional and need the Terminal, so skip them if you work in the window. You can confirm the portable path by reading the `workflow.json` inside the `.lungfishflow` bundle and checking that the input node's `bundle_path` begins `@/`. And you can rehearse a chain without running any tool by adding `--dry-run` to the command in the next section, which prints the plan instead of executing it.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, apart from comparing two saved chains, which only the command line offers. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application.

Terminal lives in the Applications folder under Utilities, and pressing Cmd-space and typing its name opens it too. The commands below use paths written relative to where Terminal is currently sitting, so before you type them, move Terminal into the folder that holds your project by typing `cd `, dragging that folder from the Finder onto the Terminal window, and pressing Return.

One caveat comes first and it is the reason the first paragraph of this chapter said what it did. Composing a chain is window-only. No subcommand creates a chain, adds a node, or draws a connection, and `lungfish-cli workflow list` lists the supported nf-core pipeline rather than the chains saved in your project. nf-core is a public collection of ready-made analysis pipelines that LGE can launch, which [Running External Workflows](03-running-external-workflows.md) covers and which has nothing to do with the chains you draw here. What the command line runs is a file the window wrote, or a graph JSON you produced some other way.

A second caveat matters more. A `builder-run` started here writes no `run.json` and no `provenance.json`, so a scripted run leaves `builder-plan.json`, the workspace, and whatever the command printed, and none of the per-node statuses. This difference is deliberate rather than an oversight, and a window run is unaffected, so use the window when you want the fuller record.

`lungfish-cli workflow validate` does not help here either. It checks Nextflow and Snakemake files, so pointing it at a builder graph refuses with this message.

```
Error: Unsupported format: Unknown workflow format
```

Compile the plan without running anything by adding `--dry-run`. The backslash at the end of each line below tells the shell that the command continues on the next line, so type them as shown and the four lines run as one command.

```bash
lungfish-cli workflow builder-run \
  --workflow "Mito read cleanup.lungfishflow" \
  --project "Mito Workflow.lungfish" \
  --dry-run
```

That prints the whole executable plan as JSON, which is the same content the runner later writes to `builder-plan.json`. The plan names the graph, the input bundle it resolved, the run directory it would use, a recipe rendering of the chain, and one entry per step carrying the operation, its settings, and the exact argument list, meaning the command name followed by every option handed to it. Run the same command without `--dry-run` to execute it.

```bash
lungfish-cli workflow builder-run \
  --workflow "Mito read cleanup.lungfishflow" \
  --project "Mito Workflow.lungfish" \
  --threads 4
```

The reference run finished in a few seconds and printed three lines naming the output bundle and its provenance file.

```
Workflow Builder run completed
Output bundle: .../runs/AC7F4093-12E5-44C4-A421-766687890D11/outputs/HG002.chrM-mito-read-cleanup.lungfishfastq
Provenance: .../runs/AC7F4093-12E5-44C4-A421-766687890D11/outputs/HG002.chrM-mito-read-cleanup.lungfishfastq/.lungfish-provenance.json
```

Comparing two saved chains is the third and last subcommand that applies.

```bash
lungfish-cli workflow diff \
  Workflows/mito-v1.lungfishflow \
  Workflows/mito-v1.1.lungfishflow
```

Both arguments accept either a `.lungfishflow` folder or a bare graph JSON file.

One thing you will meet inside a plan or a provenance record is an argument list that looks like a command but is not one. The plan's steps each carry an argument list beginning `lungfish-cli workflow builder-step run --operation ...`, and a save made in the window records one beginning `Lungfish "Tools > Workflow Builder (Experimental)" Save`. Neither is a command you can type. `builder-step` is not a subcommand the executable offers, and the second is a description of a menu action. Both are records of what happened, kept for reference, and the three commands above are the ones that actually run.

## Next

Continue to [Exporting as Nextflow or Snakemake](02-exporting-as-nextflow-or-snakemake.md) to turn a finished run into a pipeline a collaborator can run without LGE, or to [Running External Workflows](03-running-external-workflows.md) for the pipelines LGE launches rather than composes.
