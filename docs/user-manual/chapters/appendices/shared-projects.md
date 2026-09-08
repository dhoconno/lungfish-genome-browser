---
title: Shared Projects and Bundle Migration
chapter_id: appendices/shared-projects
audience: power-user
prereqs: [01-foundations/06-the-lungfish-project, 01-foundations/08-provenance-and-reproducibility]
estimated_reading_min: 30
task: Coordinate one project between two people or two machines with project locks, read the read-only state the window shows, and inspect or migrate older bundles from the command line.
tags: [appendix, reference, power-user, project, multi-user, locking, migration, provenance, cli]
tools: []
entry_points:
  - "CLI: lungfish-cli project lock"
  - "CLI: lungfish-cli project unlock"
  - "CLI: lungfish-cli project migrate"
shots:
  - id: shared-projects-read-only-banner
    caption: "The copied demo project opened with Open Read-Only after the lock alert, with (Read Only) after the project name in the window title. This Preview shows no yellow banner."
illustrations: []
glossary_refs: [advisory-lock, bundle, bundle-migration, checksum, exit-status, host-name, json, manifest, process, process-id, project, project-lock, project-store, provenance-sidecar, schema-version, stale-lock, standard-error, transformer, viewport, wall-time]
features_refs: []
fixtures_refs: [demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

A Lungfish Genome Explorer (LGE) [project](../../GLOSSARY.md#project) is a `.lungfish` folder holding one analysis, meaning one coherent piece of work such as every sample and every result from a single sequencing run. Nothing about that folder prevents two people from opening it at once. Put it on a shared drive, or reach it from a laptop and a lab workstation in turn, and two people running LGE can open it together. Both would write into the same files, and the second write would quietly overwrite the first.

LGE handles this with a [project lock](../../GLOSSARY.md#project-lock), a small record written inside the project saying who currently holds it. The record lives at `.lungfish/project.lock` inside the project folder. Finder hides any name beginning with a dot, so that folder is invisible until you press Cmd-Shift-period, which toggles hidden names on and off. Both the LGE window and the command line, meaning the Terminal application where you type commands rather than click, write this record when they take a project and read it before they touch one.

The lock works only because every LGE [process](../../GLOSSARY.md#process), meaning one running copy of a program, agrees to check it. That is what the word [advisory](../../GLOSSARY.md#advisory-lock) means here. LGE never asks macOS to refuse anyone access, so a Finder copy, an rsync job, or a Dropbox or Google Drive sync client is not stopped by the lock at all. It coordinates LGE with LGE and nothing else.

When LGE finds a lock it cannot claim, it offers to open the project read-only. Read-only means you can look at everything and change nothing. Every [viewport](../../GLOSSARY.md#viewport) opens, every bundle can be inspected, and no operation that writes into the project will start, where an operation is a named piece of work LGE runs and reports in the Operations panel. The words `(Read Only)` after the project name in the window title confirm the state. The opening lock alert identifies the session that holds the lock. The current Preview may show no banner after the project opens.

The second half of this appendix covers [bundle migration](../../GLOSSARY.md#bundle-migration), a different problem with the same audience. A [bundle](../../GLOSSARY.md#bundle) is a folder Finder shows as one icon, so you normally never open one directly, and you would need Finder's Show Package Contents to look inside. Each bundle carries a [manifest](../../GLOSSARY.md#manifest), a small file at the top level of the bundle folder naming what the bundle holds. Manifests carry a [schema version](../../GLOSSARY.md#schema-version), a number saying which layout the file was written to, currently 1.0 for a reference bundle. A project built by an older LGE can hold manifests written to an older layout, and `project migrate` is the command that reports on them.

## If a project just opened read-only

This is the situation most readers arrive with, so it comes first. Your project window says `(Read Only)` after its name. If you chose **Open Read-Only** in the opening lock alert, LGE found a lock belonging to another session and is protecting the files rather than letting two writers collide.

The plain fix needs no terminal. Ask whoever has the project open to close it, then close your own window and open the project again. The lock disappears when their session releases it, and your reopened window is writable. The opening lock alert names the person and the machine, so it tells you who to ask.

When the other session is genuinely gone and the lock is still there, the dialog LGE shows on opening offers a **Recover and Open** button that clears the lock for you. That button and its warning are described in the next section. Nothing after that section is required for this case. The command line half of this appendix exists for readers who script maintenance runs, and a reader working in the window can stop once the project reopens.

## Why you would do this

Three situations bring a reader here. In the first, a project sits on lab storage and two people work on it in the same week. In the second, one person keeps a project on an external drive and opens it from two Macs. In the third, a project made a year ago is opened by a current LGE and its bundles need checking.

The first two are the same problem. Without the lock, whichever write lands second finds a result folder half-written or the project's own index of its contents left inconsistent, and there is no message saying so at the time. The lock turns a silent corruption into a visible refusal.

The third is a different worry. Older bundles usually still open, because LGE reads old manifests as well as new ones. What an old manifest can lack is a cached chromosome list the window reads when it draws a reference. Without it the window has to work the list out from the sequence data, so the chromosome list takes noticeably longer to appear each time you open the bundle. `project migrate` finds those and offers to fill the cache in, without touching the sequence data underneath.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This appendix uses the demo project. Build it by following the instructions in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/demo-project, which have you create the project in the app at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and then fill it in about two minutes. The GitHub page needs no account and asks you to make the project in LGE rather than download one.

Everything in the first half of this appendix is visible from the window alone. Everything in the second half is typed at a command line, because the window has no equivalent for taking a lock, releasing one, or migrating bundles on demand. A window-only reader does the read-only fix described above and stops there.

One caution about practising. Every command in this appendix acts on a real project immediately. Practise on a copy. Duplicating a `.lungfish` folder in Finder with Cmd-D copies the whole bundle intact, and the duplicate opens and behaves exactly like the original, so point the commands at the duplicate and throw it away when you are done.

## Reading the window's read-only state

Open a project another session already holds and LGE stops before showing it, with a dialog whose title is the project name followed by the words "may already be open". What it says next depends on what it found. When the other session is running, the text reads "Another session is using this project. You can open it read-only to inspect it. Close the other session and try again to make changes." When the lock file is damaged and cannot be read, the text says the lock information is damaged, so LGE cannot tell whether another session is using it.

The dialog offers up to three buttons. **Open Read-Only** is the default and opens the project for inspection. **Cancel** backs out and opens nothing. **Recover and Open** appears when the lock is not held by a live process on this Mac and LGE could still read a lock record, or when the record is corrupted. It does not appear when the lock file could not be read at all, so a read error leaves you with two buttons rather than three. Below the buttons a details block names the session, the owner, the [host](../../GLOSSARY.md#host-name), meaning the name of the computer that took the lock, the [process id](../../GLOSSARY.md#process-id), meaning the number macOS gave that one running copy of the app, when the lock was created, and the project path. The owner and host are the two fields that tell you who to go and ask.

Choosing **Recover and Open** raises a second confirmation, because recovery is the one choice here that can lose data. It asks you to make sure the project is closed in other LGE versions, in the CLI, and on other computers before continuing, and it warns in these words that "Recovering a lock while another session is writing can damage the project." It adds that an archive of the existing lock will be kept for review. Read that warning as written.

Recovery is safe when the other session is genuinely gone and dangerous when it is not, and LGE cannot tell the difference for you. Two fields in the details block settle it. The host names the machine that took the lock, so a host that is not your Mac means asking the person who uses it. When the host is your own Mac, open Activity Monitor from **Applications > Utilities**, type the process id into its search field, and see whether any running process carries that number. Nothing found means the session is gone.

Recovery does not delete the record it displaces. It moves it into a `lock-recovery` folder under the project's hidden `.lungfish` directory, in a uniquely named subfolder, and writes a `recovery.json` beside it. That file holds the reason, the time, the original path, a [checksum](../../GLOSSARY.md#checksum) of the archived bytes, meaning a short fingerprint that changes if the file changes, and the record for the session that performed the recovery. If you later need to work out who was locked out and when, that pair of files is the evidence.

Once a project is open read-only, the title bar carries `(Read Only)` after the project name. In Preview 2026.9.13 build 4673, the copied demo project showed that title without a yellow banner. Its opening alert had identified owner `dho`, host `raven.local`, process `24234`, and creation time `2026-09-08T02:25:32Z`. Use the title to confirm the open window's state and the opening alert to identify the lock. A missing banner does not mean that no lock exists.

<!-- SHOT: shared-projects-read-only-banner -->

Try to run something that writes and a sheet appears titled **Project Is Open Read Only**, naming the workflow you tried and telling you to close the other writer or reopen the project after the lock is released. Running a classifier, calling variants, and importing reads are all writing work and all refused. Opening a bundle and scrolling its viewport are not, and stay available throughout.

A project copied while another copy of LGE still has the original open carries that copy's lock inside it, which is the ordinary case this appendix describes rather than a fault. Open the copy and its opening alert names the session from the original project. Choosing **Open Read-Only** gives the window shown above. Closing the original session does not remove the lock record already copied into the duplicate. Once that session has ended, use the recovery flow to reopen the copy for writing.

One case has nothing to do with sharing. A folder built only by `lungfish-cli`, never opened by the app, has no [project store](../../GLOSSARY.md#project-store), meaning the app's own hidden index of the project's contents, and the app opens it read-only for that reason instead. The title says `(Read Only)` either way and does not identify the cause. Read the opening alert and its details. The absence of a yellow banner cannot distinguish a lock conflict from a missing project store.

## Before you type anything

Every command from here on is typed into Terminal, an application macOS ships with, and the CLI Reference's [Before you type anything](cli-reference.md#before-you-type-anything) section shows where to find it and how to open one. That section also carries the ruling on the binary, which installed releases do not put on your `PATH`, so run its one `export PATH=...` line once per Terminal session before the bare name `lungfish-cli` works. Every example below writes the bare name.

Two conventions in these examples are worth naming once. A word beginning with two hyphens, such as `--dry-run` or `--force`, is a flag, meaning an option you type after the command to change what it does. A backslash before a space in a path, as in `LGE\ Manual\ Demo.lungfish`, protects that space so the shell reads the whole thing as one folder name rather than two. Dragging a folder from Finder onto a Terminal window pastes its path with the backslashes already in place, which is easier than typing them.

## Locking a project from the command line

The four lock states LGE distinguishes are worth naming before the commands, because every message below reports one of them. A lock is **active** when its recorded process is running on this machine. It is **stale** when that process has exited. A lock also counts as stale when macOS has since given the same process id to a different program, which is rare and which LGE detects by comparing start times. A lock is **unknown** when LGE cannot tell, which is the state for every lock written on a different machine, so on shared lab storage nearly every lock you meet reads as unknown. It is **corrupted** when the lock file exists but cannot be read as valid [JSON](../../GLOSSARY.md#json), a plain-text format for structured data.

Take a lock with `project lock`, giving the project's path. Run it from any folder, since the path names the project outright.

```bash
lungfish-cli project lock ~/Desktop/lge-docs/LGE\ Manual\ Demo.lungfish --mode exclusive
```

On success it prints three lines and exits 0. The [exit status](../../GLOSSARY.md#exit-status) is the number a command hands back when it finishes, where 0 means it succeeded and any other number means it refused or failed.

```
Locked project: /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish
Lock file: /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock
Mode: exclusive
```

Passing `--format json` prints the record itself instead of those three lines. It holds twelve fields, and the three that matter to a reader are the user, the host, and the process id, which together name who holds the lock and where. A record taken by the command line looks like this.

```json
{
  "appVersion" : "lungfish-cli 2026.9.13",
  "createdAt" : "2026-09-07T14:18:09Z",
  "cwd" : "/Users/dho/Documents/lungfish-genome-explorer",
  "host" : "raven.local",
  "machineIdentifier" : "38750482-9E30-587B-9B7D-5ADBCB1CF8B2",
  "mode" : "exclusive",
  "pid" : 97050,
  "processStartTime" : "Mon Sep  7 09:18:09 2026",
  "projectPath" : "/Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish",
  "schemaVersion" : 1,
  "toolName" : "lungfish project lock",
  "user" : "dho"
}
```

Two fields deserve a note. `machineIdentifier` is a meaningless code standing for the Mac itself, unrelated to any personal information and stable over time. It exists because `host` is not, since a hostname changes when the network changes and the same Mac can report two different names minutes apart. LGE compares the machine identifier first and falls back to comparing hostnames only for records old enough to lack it, which is how it tells a lock taken on this Mac from a lock taken elsewhere. The practical consequence is that an opening alert or a CLI error can name a host you do not recognise as your own machine.

The other is `mode`, set by `--mode` and accepting `exclusive`, which is the default, or `maintenance`. It is a label, not a permission level. Nothing in LGE reads the string and grants or withholds anything on the strength of it, so `exclusive` and `maintenance` block writes in exactly the same way and differ only in what they tell a reader.

A lock whose owner is still running blocks a second lock. The command exits 1 and prints the owner. Numbers in an error message like this are information to read, never something to type back.

```
Error: Project is already locked at /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock by dho@raven.local pid 97287 mode exclusive.
```

Here is the rule that surprises people. A lock taken from the command line marks intent rather than possession, meaning it is a message to other LGE sessions that maintenance is under way, not a live hold on the project. The reason is what the CLI process is. `lungfish-cli project lock` writes the record and exits immediately, so the process id in the record belongs to that one short-lived command and is dead before your next command runs. The lock is stale the moment the command exits. Run `project lock` twice in a row on a free project and the second call succeeds, because `project lock` replaces a stale lock without complaint.

So do not lock a project and then run maintenance as though the lock were holding it. A script that needs an unbroken hold, which is a concern for readers automating runs rather than for anyone working in the window, must keep an LGE process alive for the duration or arrange for no concurrent access by other means. What the CLI lock does give you is a durable note in the project saying who is doing what, which the next person to open the project will see.

Two more points about `--force`, before the flag appears in any example. It replaces a lock without the stale-owner checks, and unlike the window's recovery path it keeps no archive, so the record it displaces is gone. Use it only when you have checked in Activity Monitor that the owning process id is not running, or confirmed with the person named as the owner that they have finished. A lock from another machine is recorded as unknown rather than active, because this Mac cannot see whether that process is alive, and clearing one takes `--force` for exactly that reason.

## Unlocking a project

Release a lock with `project unlock`. This too runs from any folder.

```bash
lungfish-cli project unlock ~/Desktop/lge-docs/LGE\ Manual\ Demo.lungfish
```

Without `--force`, the command removes a lock in two cases only. The first is a lock belonging to the running process itself. The second is a lock belonging to the current user on this machine whose owning process has exited, making it stale. Everything else is refused with exit 1.

```
Error: Refusing to remove lock at /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock owned by dho@raven.local pid 97287; pass --force to override.
```

That message is worth reading closely, because it appeared in testing for a lock owned by the same user on the same Mac. Same user is not enough. The owning process must be gone. A live process is protected from a plain unlock whoever started it.

A corrupted lock is refused too, and the error names the reason. The doubled period after "format" is what LGE actually prints, not a typo in this manual.

```
Error: Project lock file is corrupted at /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock: The data couldn’t be read because it isn’t in the correct format.. Inspect the lock file or pass --force only after confirming no active writer is using the project.
```

Adding `--force` removes the lock in every one of these cases, including a corrupted one, exiting 0. It deletes the file. It does not stop the process that wrote it, which will carry on writing into the project believing it still holds the lock, so run the Activity Monitor check above before you use it.

Unlocking a project with no lock is not an error. The command prints `No project lock found:` with the path and exits 0, which is useful to script authors, since it makes the command safe to put in a cleanup step that runs whether or not the lock was ever taken.

## Migrating older bundles

`project migrate` walks a project, reads the manifest of every bundle it finds, and reports the schema version each one is written to. Run it with `--dry-run` first, a mode that reports without changing anything. Like the lock commands it takes the project path, so the folder your Terminal window sits in does not matter.

```bash
lungfish-cli project migrate ~/Desktop/lge-docs/LGE\ Manual\ Demo.lungfish --dry-run
```

Read the per-bundle lines in the report below rather than the counts along the top. Those four counts do not add up, for reasons given after the block, and readers who try to reconcile them conclude their own run is broken.

```
Project migration report
Project: /Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish
Dry run: true
Bundles inspected: 4
Current: 1
Unsupported: 2
Migrated: 0
- Analyses/Multiple Sequence Alignments/Primate-mitochondria.lungfishmsa: unreadable (report-only)
- Phylogenetic Trees/Primate mitochondria.lungfishtree: unreadable (report-only)
- Reference Sequences/HBB.lungfishref: current (none)
- Reference Sequences/chr20_10.0-10.5Mb.lungfishref: migration-available (dry-run-synthesize-browser-summary)
```

The scan counts as a bundle any folder whose extension begins with `lungfish` and which contains a `manifest.json`. The extension is the part of a folder's name after the last dot, `lungfishref` in `HBB.lungfishref`, and Finder hides extensions by default, so turn them on in **Finder > Settings > Advanced** if you want to check a folder yourself. That rule reaches multiple sequence alignments and trees as well as reference bundles. Each line ends with a status and, in parentheses, the action taken or planned. Five statuses appear.

1. `current (none)` means the manifest is at the current schema version and nothing was touched.
2. `migration-available` under `--dry-run` means the browser summary cache is missing and nothing was written.
3. `migrated` means the cache was filled on a real run.
4. `unsupported` means no [transformer](../../GLOSSARY.md#transformer) exists for that schema version, so the bundle was left alone.
5. `unreadable` means the manifest could not be decoded, which is expected and harmless for alignment and tree bundles.

The two `unreadable` lines in the demo project are not damage. Those bundle types write their own kind of `manifest.json`, built for a tree or an alignment rather than for a reference. The migrator can only decode the reference manifest layout, so it reports the file it cannot read and moves on. They are left untouched, which is the correct outcome.

Now the counts. `Unsupported` counts both `unsupported` and `unreadable` bundles, which is why it reads 2 when no bundle is actually unsupported. And `migration-available` is counted in no line at all. So the arithmetic runs:

```
1 current + 2 unsupported + 0 migrated = 3, against 4 inspected
```

Both quirks are known and neither is expected to change in this release, so trust the per-bundle lines and ignore the summary.

The one gap LGE can currently fill is that missing browser summary. Filling it makes the reference bundle's chromosome list appear as soon as you open it, because the list is then read from the manifest rather than worked out from the sequence data. A reference manifest at schema version 1.0 that lacks the cache gets `migration-available` on a dry run and is filled on a real one. Everything else is reported only. Drop `--dry-run` to perform the migration, again from any folder.

```bash
lungfish-cli project migrate ~/Desktop/lge-docs/LGE\ Manual\ Demo.lungfish
```

On a test copy this exited 0, and the one eligible bundle's line changed to `migrated (synthesized-browser-summary)`. Inside that bundle, under its own hidden `.lungfish/migrations/` folder, the run left two timestamped files, a `.manifest.json.backup` holding the manifest exactly as it was and a `.project-migrate-provenance.json` recording the change. Both names begin with a dot, so Cmd-Shift-period in Finder is what shows them. An interrupted run is safe. The original manifest is copied to the backup before anything else, and the new manifest is put into place last, so an interruption leaves the bundle with its old manifest untouched. Rerunning the dry run afterwards reported that bundle as `current (none)`, so the command is safe to run twice.

Unsupported legacy bundles are reported and never rewritten. The action string reads `dry-run-report` on a dry run and `report-only` on a real one, and either way nothing on disk changes. This restraint is deliberate. Rewriting scientific data would mean knowing the old layout exactly, moving the payload across, carrying the provenance records with it, and keeping the original recoverable. Until a transformer exists that does all of that for a given schema version, LGE reports the gap rather than acting on a guess.

The rest of this section is for readers writing scripts, and anyone else can move on. The `--format` option accepts `text`, `json`, and `tsv`. Use `json` for a machine-readable report, which gives per-bundle entries carrying the relative path, the manifest path, the schema version, the status and action, the message, and whether a provenance sidecar was found. Note that `tsv` is accepted but currently prints the same text report rather than tab-separated values. That is a known defect with no fix announced, so script against `json`.

## Provenance expectations

Locks are bookkeeping rather than a scientific result, so taking and releasing one writes no [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), meaning the small companion file LGE stores next to a result recording how it was made. Nor should it. Migration is different, because it changes a file inside a bundle.

The browser-summary migration writes its provenance record before it puts the new manifest in place, so the record describes the final file. It records:

1. The tool name and version, and the command that reproduces the run.
2. The input files and output files, including the backup, each with its checksum and size.
3. The [exit status](../../GLOSSARY.md#exit-status) and the [wall time](../../GLOSSARY.md#wall-time), meaning how long the run took by the clock.
4. The host and user who ran it.
5. The transformer's name and the schema versions it read from and wrote to.

The bundle's original creation sidecar is left where it is, so the record of how the bundle was made and the record of how it was migrated sit side by side.

## What good looks like

Four checks tell you a shared project is in the state you think it is.

1. The window title shows the project name with no `(Read Only)` after it when you expect to be able to write.
2. A `(Read Only)` title confirms the window is read-only. The opening alert explains a lock conflict and identifies its owner. The absence of a banner does not establish the cause.
3. `project lock` on a free project exits 0 and prints three lines, and a second attempt exits 1 naming the owner only while that owner is still running.
4. `project migrate --dry-run` reports every bundle as `current`, `unreadable` for alignments and trees, or names exactly the ones it would change.

When one disagrees, close the project window and open it again to read the opening alert. If it reports a lock, ask the person it names or follow the recovery guidance after confirming the owning session has ended. If it reports a missing project store, address that separately. Do not infer either cause from whether a banner appears.

## Next

- [The Lungfish Genome Explorer Project](../01-foundations/06-the-lungfish-project.md) for the project-folder layout these commands operate on, and for how to copy a bundle with its provenance intact.
- [Provenance and Reproducibility](../01-foundations/08-provenance-and-reproducibility.md) for the run records migrations preserve.
- [The Workflow Builder](../08-workflows/01-the-workflow-builder.md) for how a read-only project refuses a workflow run, where a workflow is a saved chain of operations LGE runs in order.
- [CLI Reference](cli-reference.md) for the full set of `lungfish-cli project` commands and their flags.
