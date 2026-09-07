# Editor pass, 08-workflows/03-running-external-workflows

Date: 2026-09-07
Chapter: `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`
Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues found.

## 1. False and unverifiable rows from fidelity.md

**Claim 27, section titles.** Applied. The body now reads "Overview, Inputs,
Primary Settings, Advanced Settings, Output, and Readiness", and the
`workflow-operations-runner` caption carries the same title-case list. Source
`DatasetOperationsModels.swift:11-26`.

**Claim 39, Cores disabled during a Run Again.** Applied. The **Cores**
paragraph now closes with the disabled-during-Run-Again sentence and its
reason. The Output Name sentence stayed. Source
`WorkflowOperationsDialog.swift:335-338`, which disables both fields on
`state.replayConfiguration != nil`.

**Claim 61, stdout line count.** Applied. The count is gone. The sentence now
reads that the log is short and ends `[SUCCESS] completed=1 failed=0 cached=0`.
I re-read the scratch file to confirm the reviewer's five lines
(`bundles/main-2.lungfishrun/logs/stdout.log`, 5 lines, `stderr.log` 0 bytes),
and dropped the figure rather than swap four for five.

**Claim 86, the nav entry.** Left for the gate. The prompt forbids editing
`build/mkdocs.yml`, and the entry is already corrected there.

**Claim 34, the Operations panel shortcut.** Not hedged, because I settled it.
`MainMenu.swift:866-873` adds "Show Operations Panel" with `keyEquivalent: "p"`
and `[.command, .shift]`, so Cmd-Shift-P is exact and the claim is true rather
than unverifiable. Recording it here so the reviewer's cross-chapter question
is closed with a source rather than a hedge.

## 2. Shot convention

Front-matter key `planned_shots` renamed to `shots`, ids and captions kept, and
both body markers converted from `<!-- planned: id -->` to `<!-- SHOT: id -->`.
This follows the just-committed sibling `08-workflows/02`, which carries
`shots:` with four `<!-- SHOT: -->` markers, and `STYLE.md:87-89`. Caption
casing checked against source and corrected as noted under claim 27.

## 3. Consensus rows (40 of 40 applied)

Version pins named as installed and pinned by LGE. Reference bundle, read
bundle, and the in-bundle index glossed at first use. The Download ZIP sentence
replaced with CONSISTENCY.md's fixed folder-fixture wording plus a named
destination and a description of the unzipped folder. The raw
`"runtime": {"kind": "none"}` JSON removed in favour of "ask for no container
at all, which the manifest writes as a runtime kind of none". The Link Workflow
panel now says the package appears as one selectable item and that one click
plus Link Workflow is enough (`canChooseFiles = false`,
`canChooseDirectories = true`, `allowsMultipleSelection = false`).
Command-runner package glossed where it is excluded. Workflow identity led with
the concrete relink case and glossed as the manifest's `id` string.

The greyed-versus-enabled contradiction resolved into one statement per the
ruling, the item is listed greyed with "(not enabled)" from the moment it is
linked, and enabling makes it live (`MainMenu.swift:821-845`). The Required
Setup contradiction resolved the same way, nothing to install, because
`lungfish-tools` is the pack LGE installs on first launch, described in
`PluginPack.swift:427` as needed before you can create or open a project.

Before you start now names the two bundles to select in the sidebar, and the
Procedure repeats that selection before the window opens, so the Reference
picker and the FASTQ Bundles list are filled. Step 4 says what success looks
like, one Operations row reading **Completed**
(`OperationCenter.swift:193-204`), and quotes the two reference run times from
author.md unscaled, two seconds for Nextflow and nine for Snakemake, read back
from the scratch bundles' `startedAt` and `completedAt`.

Cores anchored to About This Mac and stated plainly as honoured by Snakemake
and only recorded by Nextflow. Run Again introduced in step 4, before its first
use in Settings, as the Operations panel row's right-click item
(`OperationsPanelController.swift:1508-1514`). The command-line-only section
opens with a skip sentence for window-only readers. SHA-256 named as simply the
kind of checksum already explained. `ops stats` moved out of Reading the
results into the command-line section. Peak RAM unknown marked expected. The
"logs should be quiet" sentence rewritten as a plain statement of what a
successful log ends with. The two known defects moved out of What good looks
like into their own **Known defects** heading. The Terminal's location and the
run-from-the-package-folder instruction added once at the head of the
command-line section, matching the sibling chapter. PATH glossed. The
repeat-run rule stated as a general rule before the `--repeat-from` example.
File locks, extended attributes, and sidecars each given one clause, with the
observable fact first.

The arrow metaphor and the two-doors metaphor both replaced with plain
statements. `.lungfishflowpkg` described as a folder Finder shows as one item.
"Declares" explained at first use. The command line marked optional at its
first mention in What it is. A window route for exit codes added, the
Operations panel row's status column. The moved-package consequence stated at
its first mention in Before you start as well as in step 1. Category explained
at first use as both the Library group heading and the Tools submenu name.
Advanced Settings stated as read-only up front. The readiness line quoted
verbatim, "Ready to run.", from `WorkflowOperationDialogState.swift:611` with
`isRunEnabled` gating on that exact string at `:616`. The `--input` double
mapping explained once, in a short paragraph after the FASTQ Bundles entry,
sourced to `cli-help/workflow.txt:52-53` ("repeat for multiple inputs"). Docker
settled per the ruling. The empty JSON manifest explained where the reader
first meets it, with the reassurance ahead of the observation. The exit code 64
put in plain words. exFAT glossed with the Finder Get Info check.

## 4. Other reader rows applied

Roughly thirty of the remaining seventy-three. Pipeline glossed as the same
thing as a workflow, and process glossed as one step running a single command.
Audience stated in the chapter's first sentence. Exit status glossed at its
first use in Why you would do this rather than much later. Sidecar glossed
there too. "Six months on" replaced by the named question. Terminal glossed at
that first mention with the note that the window route needs none. The
nf-core paragraph opened with a skip line. "Pinned" replaced with "fixed" and
explained. The four-base sequence explained as deliberately tiny. Conda glossed
and the no-Python-needed fact stated. The "neither reads its input" order
reversed so the reason comes first. The four Runnable conditions broken into a
five-item list, and the card's contract rows into the same list, both within
the five-bullet cap. `.lungfishref` and `.lungfishfastq` said in words.
"Open panel" replaced with "file chooser". Specialized workflow glossed.
Library glossed as one prepared sample's reads. The "surprises people" aside
and the "clicking hopefully" idiom both removed. "Reports into" replaced.
"Merely finished" made explicit. "Cheapest" replaced with "quickest". The
"round this out" and "narrower than its name" idioms replaced. Array and block
replaced with list and section, with a line saying to open the files in a text
editor since LGE does not display them. The `8.GB` dot confirmed as the
engines' own spelling. `--timeout` marked as currently having no effect up
front. `--expected-output` led with its purpose, telling LGE which files to
fingerprint. Nextflow's single-dash convention noted once. Scratch glossed.
The trailing-backslash convention explained once. Signing marked optional and
off by default. The `results/` path split into two sentences with the
exact-match warning. The `--config` second use marked as irrelevant to these
examples. `run-headless` explained as the same command with less output.
`validate` given a plain statement of what it does and does not check, plus
what a failure prints. The Workflows link given a readable name. The
window-versus-command-line bundle location split, answering the reader who
could not find `main.lungfishrun` from the window route. Include subfolders
given the missing-checkbox meaning.

## 5. One fidelity correction not in any report

The chapter said several read bundles are pooled into one run, with the summary
line "They will run as one batch." That is true of built-in workflows and false
for a linked package. `WorkflowOperationDialogState.swift:460-462` returns
`false` from `showsMultiBundleRunModePicker` for `.workflowPackage`, so the
batch picker and that summary line never appear, and `:568-571` returns the
readiness text "Imported workflow packages currently accept one FASTQ bundle.
Select one bundle, or choose a built-in workflow for folder batches." A linked
package takes exactly one read bundle. I corrected the Procedure and the
**FASTQ Bundles** setting to say so and quoted the readiness line. Without this
the Procedure is not performable, which the ruling required, and the registry's
`FASTQ Bundles` effect line still carries the pooling wording, so the registry
needs the same correction. Left for the gate, since the registry is not mine.

## 6. Left for the gate

- `brand_reviewed` and `lead_approved` stay `false`. Not flipped.
- The nav entry in `build/mkdocs.yml`, already corrected per the prompt.
- `parameters.yaml`, two rows. The `Cores` row needs the Run Again sentence the
  reviewer asked for under claim 39, and the `FASTQ Bundles` row's pooling
  sentence is wrong for linked packages per section 5 above.
- Both shots are still uncaptured. The three things worth confirming at capture
  time are the six section titles, the contract row order on the card, and the
  greyed menu item, all sourced from Swift rather than from a screen.
- Defect 3 from author.md, `ops stats` exiting zero on an unknown option, is
  now one sentence in the command-line section rather than absent, because the
  ruling asked for every app defect to be disclosed where the reader meets it.
  It is still worth filing separately.

## 7. Facts I could not source

None. Every figure in the chapter traces to author.md, the scratch outputs, the
Swift source, the CLI help, or `third-party-tools-lock.json`. Two figures I
deliberately did not state. I gave no failure-run example, because none was
captured and the readers who asked for one would need a real one. And I gave no
count for the `stdout.log` lines, per claim 61.
