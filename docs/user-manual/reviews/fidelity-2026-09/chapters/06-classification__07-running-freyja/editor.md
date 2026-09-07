# Editor report, 06-classification/07-running-freyja

Date: 2026-09-07. Chapter
`docs/user-manual/chapters/06-classification/07-running-freyja.md`.
Inputs applied in order: the two false rows and three unverifiable rows in
`fidelity.md`, the eighteen consensus rows in `readers.md`, as many of the
remaining 59 reader rows as could be applied without inventing facts, and the
project manager's seven rulings.

Lint is clean under `LUNGFISH_MANUAL_STRICT=1`, first run and after every
subsequent edit. Zero em dashes, zero semicolons, zero in-sentence colons,
verified independently of the linter.

## Fidelity rows

### False row 6, the Plugin Manager instruction

Replaced. Before you start now carries the CONSISTENCY.md fixed sentence
verbatim ("This feature is experimental. Turn on **Show Experimental
Features** in **Settings > Advanced** before you look for it.") ahead of the
Plugin Manager instruction, then says the pack's card appears on the Packs
tab with the toggle on and that **Install All** installs it.

The fixed sentence's label and pane were confirmed against source and needed
no correction. `AdvancedSettingsTab.swift:16` has
`Toggle("Show Experimental Features", ...)` and `SettingsView.swift:56` gives
the pane `Label("Advanced", ...)`. Nothing in the sheet needs updating.

Three further details verified rather than assumed. The **Install All**
button title comes from `PluginManagerView.swift:576`, which reads
`status.pack.isRequiredBeforeLaunch ? "Install" : "Install All"`, and the
wastewater pack does not set `isRequiredBeforeLaunch`
(`PluginPack.swift:832-847`), so **Install All** is the right label. The tab
is named Packs at `PluginManagerView.swift:103`. Cmd-Shift-B is confirmed at
`MainMenu.swift:773-779`.

The CLI alternative is stated as
`lungfish-cli conda install --pack wastewater-surveillance`. The form was
confirmed from `cli-help/conda.txt` and `CondaCommand.swift:84,159-165`.
`--pack` is a `@Flag`, not an option taking a value, and the pack id is a
positional argument matched against `$0.id`, which is
`wastewater-surveillance` at `PluginPack.swift:833`.

### False row 8, the Experimental marking

Replaced with the reviewer's corrected wording, "The pack is marked
experimental in the source, which is why the Plugin Manager hides it behind
the experimental-features toggle." The explanation that survived, that the
marking means less testing inside LGE rather than an unfinished Freyja, was
kept as the reviewer recommended, and it absorbed reader row 4-on-experimental
by adding that results are fine to report as long as the tool version is
recorded alongside them.

### Unverifiable rows 41 and 42, barcode staleness

Hedged rather than cut, since both are the kind of guidance a reader needs.
Row 41 now reads "What a total well under 1 most likely means is ...", and
the sentence before it says plainly that no campaign run produced a low total
and so no floor is quoted. Row 42 lost "a poor residual or" entirely, per the
residual ruling, and now names the low abundance total as the likely symptom.
Neither is attributed to Freyja's documentation, because no such statement
exists in the pack (see Facts I could not source).

### Unverifiable row, `estimated_reading_min`

Left at 16 and untouched. It is a front-matter field with no campaign rule
fixing the conversion, and changing it is not an editor call.

### Changed row, front-matter `tools`

Added `minimap2`, so the list is `[freyja, ivar, minimap2, samtools]`. The
chapter tells the reader to map with minimap2 in Before you start and the
pack ships it.

### Shot caption

Rewritten to match the corrected reality, since the old caption described a
badge on a card the default build never draws. It now reads: "The Plugin
Manager Packs tab, with Show Experimental Features turned on, showing the
Wastewater Surveillance card, its Install All button, and the five tools it
installs." The Screenshot Scout's recipe must turn the toggle on before
opening the Plugin Manager or the card will not be on screen.

## Rulings

**Experimental pack.** Applied as described above. Label and pane confirmed
correct, so the fixed sentence stands unchanged and the sheet needs no edit.

**Terminal-only warning up front.** The first paragraph of What it is now
opens with one sentence saying Freyja has no dialog or menu item in LGE and
runs from the command line only. Before you start repeats it in its own first
paragraph with a link to `appendices/cli-reference.md` and an instruction to
read that appendix before investing in the prerequisites. The Procedure's
fuller explanation was kept, though shortened per consensus row 8.

**Step 1 performable.** The command now calls
`~/.lungfish/conda/envs/freyja/bin/freyja`, confirmed present on this machine
with `ls -la` (a 248-byte executable dated 1 September). The prose states the
program must be run by that full path or from a terminal where that folder is
on the PATH, glosses PATH, and warns in one sentence that a bare `freyja` the
shell cannot find produces an empty variants table and exit code 0, so the
failure is silent. No environment activation is described anywhere. The same
full path was applied to the Step 1 block in On the command line.

**Before you start prerequisites.** The compressed sentence became a
three-item numbered list, one per prerequisite, each linking its Part IV
chapter, followed by a sentence saying to do them in that order because each
takes the previous one's output.

**Residual and coverage.** No numeric threshold is given for either. The
residual is now "the fit error of the mixture model", with lower meaning the
named lineages explain the observed mutations better, judged by comparing
samples within one batch. Coverage is now "the percent of the genome at
usable depth". The sentence treating a poor residual as a check was removed
from What good looks like and replaced with guidance for the single-sample
case, which was also reader row "processed the same way".

**Provenance defects.** Reading the results now states both. The demix result
record carries no checksum or size, and the stderr text is absent from the
sidecar on both the success and the failure paths, with the note that a
failed run's stderr still reaches the terminal and must be saved by hand.

**`--sample`.** Already stated correctly in the Sample settings paragraph and
left as written.

**Barcode date.** 22 March 2026 kept, and its attribution tightened to the
pack ("The barcode file that came with the pack used in this chapter").

**App defects disclosed once where the reader meets them.** Silent
`freyja variants` failure in Step 1, both provenance gaps in Reading the
results, the Plugin Manager visibility defect in Before you start (as the
toggle instruction), and the silent output-directory overwrite in the Output
dir settings paragraph.

## Consensus rows, all 18 applied

Four unglossed tool names now named as the earlier chapters' classifiers and
marked not a prerequisite. "Solves for" became a search for the best match,
with a sentence saying no exact answer exists. A few dozen positions is now
called a tiny fraction, tied to why a consensus hides it. Prerequisites are
a numbered list. "Pins" became "installs and locks to exactly version 2.0.3".
Barcode staleness now says lineages are named continuously and a snapshot
more than a few months old will be missing recent ones. The `freyja update`
dead end now tells a first-time terminal user to leave it alone. The Tools
menu explanation was cut to one clause and leads with "Freyja runs from the
command line only." Step 1 is performable via the full path. The BAM filename
is marked a placeholder, with the bundle's `alignments/primer-trimmed` folder
named. The 16,779-row count is marked as varying and explicitly not a check,
against the depths count which is. Wall time glossed as elapsed clock time.
The listing threshold now names `--eps` and its 0.001 default. The residual
is explained as unjudgeable in isolation. SHA-256 checksum glossed as a
fingerprint that changes with the file. The "close to 1" instruction now says
no floor is quoted and why. `cat` glossed. The Intel-container closing note
was cut to a link plus a statement that it does not affect the reader's run.

## Other reader rows applied

Roughly 30 of the remaining 59. Accession glossed at first use. "Fakes"
replaced with frequencies wrong in an unpredictable direction. Pack download
size given as around 1.5 GB, sourced from `estimatedSizeMB: 1500`. Pangolin
and Nextclade marked as not used in this chapter, and iVar and minimap2 each
paired with the step it performs. Command plan glossed at first use. The
both-flags note now leads with the instruction. Settings lead says plainly
there is no dialog and glosses "flag" as a word beginning with two dashes.
The `--eps` unit reconciled by stating abundances are proportions, so 0.001
is one tenth of one percent. The hidden dot file explained with
Cmd-Shift-Period. The result block's first line labelled. The bracket
notation named as Freyja's own. Coverage's meaning shift from the alignment
chapters flagged explicitly, with 40 percent as a concrete unusable example.
The 96.9 versus 98.85 arithmetic reconciled. The close-relative warning
promoted to its own opening sentence, with the mechanism before the metaphor
and "solver" replaced by a reference back to the search. "The lesson
generalises" cut. The published-figure analogy replaced with "the question
anyone should ask about a result". A two-column table of the first three
name-and-number pairs added beneath the output block. The unrecoverable
overwrite in Output dir marked as a departure from other tools. Extra args
now says what a bad value looks like. Dry run says it is not needed for a
one-off run and drops the double negative. Backslash line continuation
explained once in the Procedure lead. Separate dry-run and real output
directories explained. The ellipsis note moved ahead of its code block, and
"leading dots" corrected to the directory part of each path. Idioms replaced:
"reaching for" to "when to use", "stands in for" to "represents", "worth
taking at face value" to "worth believing", "Freyja reads nothing but allele
frequencies" to "Allele frequencies are all Freyja reads". BQ.1 and BA.5.3.2
identified as Omicron descendants circulating in late 2022. Cross-
contamination glossed. Cmd-N made an explicit alternative. Project folder
placement clarified. GitHub's Download raw file control named. SRA size given
as 21.7 MB from the fixture README. Consensus genome glossed where it first
appears. The 60/40 inconsistency corrected to 60/35 to match the running
example. The second-limitation numbering fixed. The depth-trust question
answered with Freyja's own ten-read `--covcut` cutoff. Mapping glossed at
first use in What it is.

## Left for the gate

`brand_reviewed` and `lead_approved` are both still `false`. I flipped
neither, per instruction.

The Screenshot Scout still needs to shoot
`plugin-manager-wastewater-pack` with the experimental toggle turned on
first, and the recipe must include that step.

Registry drift the fidelity reviewer raised for whoever owns
`parameters.yaml` is untouched by me, since I do not own that file. The
`--dry-run` effect line does not record that the flag overrides `--execute`,
and the `--extra-args` effect line could name `--eps`.

The author's third defect, that LGE does not wrap `freyja variants`, remains
a Documentation Lead question. The chapter now warns about the silent failure
but cannot remove the reader's one unmanaged step.

## Facts I could not source

Freyja's own documentation inside the pack states no threshold for a good
residual and no floor for the abundance total. I checked the installed
package's `METADATA` (all 57 lines) and `freyja demix --help`, which is a
read-only invocation. The help gives `--eps` default 0.001 and `--covcut`
default 10, both of which are now used in the chapter, and it gives no
guidance on interpreting `resid`. So no numeric threshold is quoted for
either figure, per the ruling.

The exact wording ArgumentParser prints for an unrecognised flag is not in
the captured CLI help, so the Settings lead describes the failure as an error
plus the usage line rather than quoting a message I could not verify.

The claim that new lineages are named continuously and a snapshot more than a
few months old will be missing recent ones is general Pango practice, not
sourced from a file on this machine. It is phrased as guidance rather than as
a measured fact, and it replaces a reader-flagged gap where the chapter gave
no way at all to judge staleness. Worth a fact-check if the gate wants it
tighter.

The 1.5 GB pack size and the several-minutes download estimate come from
`estimatedSizeMB: 1500` in `PluginPack.swift`. The size is sourced. The
time range is my inference from that size and is deliberately vague.
