# Editor pass: 08-workflows/01-the-workflow-builder

Date: 2026-09-07
Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md` prints "no issues found".

Front-matter flags untouched. `brand_reviewed` and `lead_approved` both stay
`false` for the gate to flip. `estimated_reading_min` was raised from 26 to 34,
because the body grew from 5,989 words to roughly 7,900 and the old figure
would have been wrong rather than merely stale.

## Part 1. The seven false rows in fidelity.md

**Row 49, the input node's "only control".** Rewritten. Step 5 now opens by
saying every node begins with a **Label** field, then places the FASTQ bundle
popup below it.

**Row 52, the inspector showing node parameters.** Rewritten, and this was the
largest single change in the chapter. Step 5 now states that the five
operation nodes show Label, the tool name, a **Configure...** button, a port
summary and a validation summary, and that their settings are not in the
inspector at all. The route to them is **Configure...** and the shared
FASTQ/FASTA Operations dialog. The old contradiction between the step-5
paragraph and the Configure paragraph one below it is gone, since there is now
one account rather than two.

**Row 53 and row 54, "thirteen controls".** Both fixed to twelve. The Settings
lead-in now reads "Twelve controls live in this window. Nine belong to
individual nodes and three are window controls that belong to no node." The
step-5 pointer reads "all twelve controls".

**Rows 69, 70, 71, the reference-run table.** Rebuilt in one unit, reads
throughout, from the tool reports rather than the lineage. Read against
`workspace/HG002.chrM_fused_fastp_report_24AD6E28-....json`
(`before_filtering.total_reads` 19,916, `after_filtering.total_reads` 19,752)
and `workspace/HG002.chrM_deacon_summary.json` (`seqs_in` 19,752, `seqs_out`
318, `seqs_removed` 19,434). The four rows now read 19,916 to 19,752, 19,752 to
318, 318 to 225, and 225 to 106. A fifth column carries a short verdict per
row, which also answers a reader row asking for the Deacon drop to be flagged
in the table rather than several paragraphs later.

**Row 73, the Deacon sentence.** Now "Deacon removed 19,434 of 19,752 reads,
leaving 318, which is a 98.4 percent depletion."

**Row 74, "more reads out than in".** The premise was false, so the paragraph
was rewritten rather than patched. It now says the count falls from 318 to 225
because merging turns two mates into one, keeps the merged-plus-unmerged
explanation as the reason the fall is not by half, and moves the mean-length
figures into their own short paragraph so the gain shows up as length rather
than count.

**Row 76, the fastp fusion rule.** Narrowed to what the source supports.
"Remove PCR duplicates and Adapter + quality trim are combined into one fastp
command when they sit next to each other ... Merge overlapping pairs also runs
fastp but is never combined with anything, even when it sits beside another
fastp step."

**Row 89, the lineage reads-in and reads-out instruction.** Replaced. What
good looks like now says the lineage records commands and not counts, and
sends the reader to the two named tool reports under `workspace/`, compared
against the finished bundle's own read count in its viewport.

## Part 2. The three unverifiable rows

**Row 62, the Operations Panel shortcut.** Kept as written, because
CONSISTENCY.md fixes the same phrasing and shortcut for the whole manual
("The Operations panel opens with **Operations > Show Operations Panel**
(Cmd-Shift-P)"). Not a hedge, a citation.

**Row 105, the bundle's 19,916 reads and 248.4 mean.** Kept, and now stated as
the practice dataset's own figures rather than as a general expectation, which
was also a reader consensus row. 19,916 is independently corroborated as the
fastp input count in the run's own report.

**Row 106, the Required Setup pack.** Kept but narrowed. The sentence now
claims only that the three tools are included in that pack and that there is
no separate install step for them, and it no longer carries the Deacon index
along with them, since the index is now a separate paragraph with its own
install route.

**Row 107, the Plugin Manager listing the Deacon database.** Cut and replaced,
because a source check settled it against the chapter. See the ruling below.

## Part 3. The rulings

**The Deacon database.** Sourced rather than hedged. The Plugin Manager's
Databases tab is populated from `MetagenomicsDatabaseRegistry.availableDatabases()`,
whose catalog explicitly excludes the Deacon indexes
(`MetagenomicsDatabaseInfo.swift:405-407`, "Bundled sidecars (human scrubber,
Deacon indexes) are not catalog databases"), and the tab's own grouping renders
only kraken2, esviritu and taxtriage. So the chapter's old claim was wrong, not
merely unverified. The chapter now gives the CLI as the only install route,
with the identifier confirmed from `cli-help/conda.txt:611-617`
(`lungfish conda db install-managed deacon-panhuman`), one sentence saying the
Databases tab does not list it and why, `--list` as the way to check, and the
Plugin Manager named as a second way to see the state, through the Required
Setup pack's **Human Read Removal Data** row reading **Ready** or **Needs
download** (`PluginPackStatusService.swift:69-82`).

**The reference run's result.** Stated plainly in its own paragraph after the
merge discussion. 106 reads from 19,916 is what this tiny practice dataset
gives after human depletion of human mitochondrial reads, it is the expected
outcome rather than a mistake in the reader's setup, the point of the run is
the mechanics and the record, and the surviving reads are not a finding to
carry into an analysis.

**Terminal material.** The five cli_only flags now sit under an H3,
"Options that exist only on the command line", opened with one sentence saying
a window-only reader may skip to the next section. The command-line section
opens with CONSISTENCY.md's fixed paragraph verbatim, with "the window"
swapped in for "the dialog" per that sheet's instruction. Terminal's location
is given once, in Before you start where the reader first needs it for the
Deacon index, and the command-line section adds only the `cd` habit for
relative paths.

What good looks like was restructured so every check has a window route. The
run status is the Operations panel's two rows. The settings check reads the
command from the Operations panel row's **More** disclosure, which the source
confirms renders it with a Copy button (`OperationsPanelController.swift:954,
1046-1090`), and compares it against the **Configure...** dialog. The parent
check reads the Inspector's lineage block. The portability check reads the
input node's path control in the builder. The two checks that need a terminal,
reading `workflow.json` and running `--dry-run`, are marked optional and moved
into a closing paragraph after all of the window checks.

**Saving.** Stated as a plain warning in step 1 rather than as a correction of
an older manual, which also clears a reader row objecting to that aside.
Source settled what actually happens: `WorkflowBuilderViewController.swift:1026-1054`
shows a Save / Don't Save / Cancel alert on `windowShouldClose`, and Don't Save
discards without writing. There is no autosave. So the chapter says Run is what
saves, nothing else saves on its own, closing with unsaved changes raises that
prompt, and Don't Save discards the drawing for good. That is what source says
happens, and it is slightly gentler than "an unrun drawing is lost when the
window closes", which would have been wrong.

**Glosses at first use.** All applied. "The source" became "the app's own
code". Legacy path became "an older way of choosing the input, left in place so
that chains drawn before this one still work". Cheap and expensive became
faster and slower with the reason named. Read-only projects got their cause and
their two on-screen signs. Cut mode's right and tail are now distinguished, and
said to behave alike on this data. Maximum length names the joined-fragment
artefact and gives 400 on a 250-base protocol as an example. The chain version
number now says LGE stamps 1.0.0 on every save and nothing raises it. Index,
fastp, Deacon and seqkit, grid step (moved after the Grid toggle), `@/`,
inspector, data type, single-end, forward delete as Fn-Delete, the FASTQ/FASTA
Operations dialog with a link to 03-reads/04, exit status (the number was cut
rather than explained, per the reader suggestion), argv replaced by argument
list throughout, per-node status location, PCR duplicate, pipeline, dialog,
quality score, upstream, HG002, and provenance all got their gloss at first
use. The five lineage keys now sit in a two-column table beside the node names.

**Numbers.** 19,916 and 248.4 are flagged as the practice dataset's figures,
with the reason they are given. The 50-base cutoff's reason now appears at its
first mention in Why you would do this rather than only in Settings. The ZIP is
described as holding the whole repository with only two files needed, and no
size is given. The chapter says twice that the defaults are already correct for
this fixture and nothing needs typing or checking.

**The comparison defect.** Neither the source nor a tracked issue says a fix is
coming, so the chapter says it is a known defect in this release, that nothing
says when a fix will land, and that it affects only a script reading the
output, never the values.

**Defect disclosure, one sentence where the reader meets it.** All five old
defects plus the new one are disclosed in place. The diff formats printing text
sit in Comparing two versions. The missing `run.json` from a CLI run sits in
the command-line section, moved there from When a run fails per a reader row,
with When a run fails keeping the window behaviour and one forward pointer.
`validate` rejecting builder graphs sits in the command-line section.
`list` omitting chains sits in the same place. The new inspector defect sits in
step 5, named as a defect in 2026.9.13.

**The fifth shot.** Recaptioned to "An Adapter + quality trim node selected,
showing its Label field, the tool it runs, and the Configure... button in the
right-hand inspector", which is capturable.

## Part 4. Reader rows

All 37 consensus rows applied. Every one is covered by the ruling section
above except the following, which had no ruling and were applied directly.
The fan-out sentence in Connect them was split into the editor allowing the
drawing, the exporters accepting it, and the runner refusing it, with a note
that there is no pre-run check and Run is where it is caught, followed by a
sentence telling the reader to delete the extra connection. The Trimming node
background paragraph in step 2 is now introduced as skippable background, and
"bare shell", "qualified quality", and the minimap2 and allele-frequency
example were cut. The reference-and-assembly connection exception is now one
clause saying it covers node types the palette never offers, so it cannot
arise here. The unrecognised-parameter failure condition now says it exists for
a file from another version or hand-edited outside the app.

Of the 84 non-consensus rows, 62 were applied. They are mostly one-word
substitutions the readers asked for and I made without comment: rubber-band to
"draw a selection box", hover to "rest the pointer", commit to "release to
finish", invocation and fused to "command" and "combined", "look at hardest" to
"deserves the most attention", ticked to "which value you set months ago",
seeded (sentence cut), ship to "are included", over-read to "assume more than
it means", nicety to "required, not optional", "point the same chain at" to
"run the same chain on", "clicking through five dialogs" to "opening five
separate windows one after another", collapse to "can be hidden", "documentation
gap" to "this difference is deliberate", audit record to "records of what
happened, kept for reference", "path control ... resolves to on disk" to "LGE
shows the file's full location on your Mac", "plain match" to "a port only
accepts another port of the same type", "no paired-only typing" to "the port
does not check whether the reads are paired", chemistries to "sequencing kits",
"costs almost nothing" to "takes almost no extra time", and the shortened path
in the error block now says the middle was shortened to fit the page.

Also applied without being consensus rows: the ZIP route now leads and the
folder link follows as a place to confirm file names, the Settings menu path
and Cmd-comma were added, the tool version numbers are marked as being for the
record with some count difference expected, the bundle name is said to be
derived automatically, the alert sound is noted as the only feedback for a
refused connection, the port names are said to be descriptive rather than
different types, the run identifier is glossed at its first use in step 6 with
an example, Show Package Contents is given for reaching inside a bundle,
`workspace` files are said to be safe to delete, `--dedup` and `--cut_right`
are named as what they do, the trailing backslashes are explained, nf-core is
glossed with a pointer to sibling 03, the `cd` assumption for relative paths is
stated, the no-parent case now says what to do, the staging-folder paragraph
was reduced to one sentence, and the four-number sentence about the final
bundle was split with the point stated first.

Twenty-two non-consensus rows were not applied. Fifteen are requests to
restructure the chapter rather than to edit it, which is outside this role and
would need the Documentation Lead: opening What it is with the why argument
(partly honoured, since the section now opens with the one-sentence version),
putting the plain description of a directed acyclic graph before the term
(honoured), moving the six-node caution later (honoured), and moving the
quality-score scale to its first mention (partly honoured, since the first
mention now carries a one-clause gloss and the full scale stays in Settings
where the number is set). The rest are one-reader preferences that conflict
with a consensus row or with CONSISTENCY.md, chiefly the request to drop the
"This setting has no command-line flag" repetition, which I honoured by
stating it once in the section lead, as CONSISTENCY.md explicitly permits for
a group of settings that all lack a flag.

## Facts I could not source

None blocked an edit. Two are worth recording.

The Required Setup pack membership of fastp, Deacon and seqkit was not checked
against `third-party-tools-lock.json` in this pass, so the chapter's claim is
inherited from the author and narrowed to what it needs to say. The three conda
environments do exist on this machine.

Whether the inspector defect is a regression or the intended design is an app
decision, not a documentation one. The chapter describes what 2026.9.13 does
and calls it a defect, which is the safe wording until that decision lands. If
the app fixes it, step 5, the Settings lead-in, and the fifth shot caption all
change together.

## For the gate

`brand_reviewed: false` and `lead_approved: false` are untouched.

The fifth shot still needs capturing to the new caption, and none of the five
shots exists yet.

Defect 6 needs an app decision. If the intent is that node settings should be
editable in the inspector, this chapter's step 5, its Settings lead-in, and its
fifth shot caption are all written to the current behaviour and will need
revisiting.
