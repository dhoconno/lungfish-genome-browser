# Editor pass: appendices/shared-projects

Chapter: `docs/user-manual/chapters/appendices/shared-projects.md`
Roster row 65. Editor pass date: 2026-09-07.
Inputs read in order: `author.md`, `fidelity.md` (63 claims, 3 false), `readers.md`
(80 merged rows, 32 consensus), `CONSISTENCY.md`, and the committed
`appendices/cli-reference.md` "Before you type anything" section.

## False claims fixed

All three, with the reviewer's own wording.

1. **Claim 44, the `unreadable` bundles.** The old sentence said those bundle
   types "store their metadata under a different filename". Replaced with the
   reviewer's wording. The chapter now says both bundles write their own kind
   of `manifest.json`, built for a tree or an alignment rather than for a
   reference, and that the migrator can only decode the reference manifest
   layout, so it reports the file it cannot read and moves on. The paragraph's
   conclusion, that the two lines are not damage, is unchanged because the
   reviewer confirmed it stands.
2. **Claim 31, the corrupt-lock error block.** The two ASCII apostrophes in
   `couldn't` and `isn't` are now U+2019, matching the app's stderr byte for
   byte. I scanned every other quoted block in the chapter and found no second
   instance.
3. **Claim 11, Recover and Open.** Replaced with the reviewer's wording. The
   button appears when the lock is not held by a live process on this Mac and
   LGE could still read a lock record, or when the record is corrupted, and it
   does not appear when the lock file could not be read at all. Added the
   consequence for the reader, that a read error leaves two buttons rather
   than three.

## Project manager rulings, and where each landed

**(a) The demo-project lock is not a shipped defect.** The author's finding 1
and the reviewer's confirmation of it are both about a lock belonging to the
Preview build running on the authoring machine with the project open. The
chapter never says this is a defect. The finding is rewritten as the ordinary
case it illustrates, one sentence plus its consequence, at the end of the
read-only section: a project copied while another copy of LGE still has the
original open carries that copy's lock, and the reader sees exactly the
read-only window this appendix describes. The fix, recover or close the other
session, follows in the same short paragraph.

**(b) The reader's actual situation first.** New H2 "If a project just opened
read-only", placed immediately after "What it is" and before any command. It
says what a read-only window means, gives the plain fix (ask whoever has the
project open to close it, then close and reopen your own window), names
**Recover and Open** as the route when the other session is gone, and states
that nothing in the rest of the appendix is required for that case. Reader
row "no section on what to do right now" and the consensus row about a
window-only reader's next step both close here.

**(c) Before you type anything, and per-command folder sentences.** New H2
"Before you type anything" precedes the first command block, pointing at
`cli-reference.md#before-you-type-anything` for the Terminal opener and
carrying the binary-path ruling (installed releases do not put `lungfish-cli`
on `PATH`, so the `export PATH=...` line runs once per session). It also
introduces the two-hyphen flag form and the backslash-escaped space, both
consensus rows. Every one of the four command blocks now carries a sentence
saying which folder it runs from, and in each case the answer is any folder,
because the path names the project outright.

**(d) The stale-lock contradiction resolved.** The old "So what should you do
with this?" paragraph in "What it is" advised taking a lock before scripted
maintenance as though the lock held. That advice is gone. The locking section
now leads with the rule rather than the story: a CLI lock marks intent rather
than possession, and it is stale the moment the command exits. One sentence
states what the CLI lock is for, marking intent in the record so the next
person to open the project sees who was doing what. "What good looks like"
item 3 is rewritten to say a second attempt exits 1 naming the owner only
while that owner is still running, which was the reader row flagging the
contradiction with the stale finding.

**(e) `--force` warning first, and a checkable test for "genuinely gone".**
A paragraph beginning "Two more points about `--force`, before the flag
appears in any example" now sits before the flag's first appearance in the
locking section, covering both that it keeps no archive and that it does not
stop the owning process. The recovery section gives the checkable test from
the two lock-record fields the reviewer verified: the host names the machine,
so a host that is not yours means asking its user, and when the host is your
own Mac you open Activity Monitor from **Applications > Utilities** and search
the process id. The unlock section's `--force` paragraph points back at that
same check rather than repeating it.

**(f) Hidden dot-prefixed paths.** The first such path, `.lungfish/project.lock`
in "What it is", carries the clause that Finder hides any name beginning with
a dot and that Cmd-Shift-period toggles them. The reminder repeats at the two
later introductions, `lock-recovery` under the project's hidden `.lungfish`
directory and the bundle's own hidden `.lungfish/migrations/` folder.

**(g) Terms glossed at first use.** Exit status is glossed where the first
exit code appears, with 0 meaning success and any other number a refusal or
failure. Glossed in the body at first use: JSON, host, process, process id,
checksum, standard error, wall time, project store, transformer, advisory,
operation, viewport, bundle, manifest, schema version, flag, dry-run mode,
metadata (folded into the manifest gloss), provenance sidecar, workflow, folder
extension, opaque machine identifier, and the accepted `--mode` values. The
term "project catalog" is dropped rather than glossed, replaced by "the
project's own index of its contents", per the reader row's second option.
"Schema version" is now used consistently, with bare "schema" and "format
version" both eliminated. "Process id" replaces every "process number".

**(h) The demo-project sentence.** Already byte-identical to the canonical
form at `appendices/ai-assistant.md:53` and kept as it stands, with the GitHub
build instructions intact. Added one sentence after it saying the GitHub page
needs no account and asks you to make the project in LGE rather than download
one, which closes the consensus row about that link.

**(i) The escaped backslash.** Explained rather than removed, in the "Before
you type anything" section, with the note that dragging a folder from Finder
onto a Terminal window pastes the path with the backslashes already in place.
The paths themselves keep the escapes, since they are what a reader must type.

**(j) The shot marker.** The one `<!-- SHOT: shared-projects-read-only-banner -->`
marker is kept, still inside the read-only section, still matched to the single
`shots` entry. Verified after the edit.

## Reader rows applied

**Consensus section, 32 rows: 32 applied, 0 skipped.**

**Other merged rows, 48 total: 43 applied, 5 skipped.**

The five skips, each with its reason.

1. *"Add a screenshot of the may already be open dialog"* (reader 2). Skipped.
   Shots are the Screenshot Scout's and the Lead's to add, and the author's
   record gives the reason the dialog was not declared, that staging it needs
   two concurrent LGE sessions on one project. Out of an editor's authority.
2. *"State the current schema version once, and say where a reader can see
   their own"* (reader 2). Half applied, half skipped. The current version, 1.0
   for a reference bundle, is now stated twice. Where a reader sees their own
   is skipped, because the only route is the `--format json` report, which the
   same reader team asked to be marked script-authors-only.
3. *"Say whether the tsv defect is being fixed"* (reader 1). Applied as far as
   the evidence goes, "a known defect with no fix announced". A promise about
   a future release is not the editor's to make.
4. *"Say how to copy a bundle safely, or link to where that is covered"*
   (reader 2). Applied as a link only, added to the See also entry for chapter
   6. Writing the procedure here would duplicate another chapter's material.
5. *"Move the read-only section first for window readers"* (reader 4). Skipped
   as stated, because the chapter template fixes the section order. Satisfied
   instead by ruling (b), the new short section before any command, which is
   what that reader actually needed.

## Brand and style pass

No em dashes, no semicolons in prose (the one semicolon left is inside a
verbatim error message), no colons inside a sentence. The two colons in the
body both end a lead-in immediately before a code block or a list, which the
rule allows. No word from the AI-tells list. Long sentences broken toward the
20-word target throughout, heaviest in "What it is", the machine-identifier
paragraph, and the interrupted-run sentence the readers stopped at. The
twelve-fields prose list is cut to the three fields a reader uses, and the
provenance record's ten-item sentence becomes a five-item list. The two
"Verified on a copy" asides that read as private test notes are gone, with
their factual content kept as plain statements. The hostname anecdote is cut
to one clause. "Lungfish Genome Explorer (LGE)" at first mention, "LGE" after.
`brand_reviewed: false` and `lead_approved: false` are unchanged.

## Front matter changes

`estimated_reading_min` raised from 14 to 16, since the chapter gained a
section and several glosses. `glossary_refs` grew from 8 terms to 20, adding
`advisory-lock`, `checksum`, `exit-status`, `host-name`, `json`, `process`,
`process-id`, `project-store`, `standard-error`, `transformer`, `viewport`,
and `wall-time`. Every anchor verified present in `GLOSSARY.md`. All other
front-matter fields are unchanged.

## Glossary changes

Six entries added to `docs/user-manual/GLOSSARY.md`, each in alphabetical
position in the existing entry shape, and each added to this chapter's
`glossary_refs`.

- **Host name**{#host-name}, in H before Host depletion.
- **Process**{#process} and **Process id**{#process-id}, in P before Project.
- **Project store**{#project-store}, in P after Project lock.
- **Standard error**{#standard-error}, in S after Stale lock.
- **Transformer**{#transformer}, in T after Topology.

Six further terms the consensus asked for were already defined and needed only
a `glossary_refs` entry and an inline gloss: advisory lock, checksum, exit
status, JSON, viewport, and wall time. No existing entry was edited.

## Lint result

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/shared-projects.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/shared-projects.md: no issues found
exit=0
```

One intermediate warning and its fix. The Activity Monitor check first read
"see whether a running Lungfish process carries that number", which tripped the
bare-app-name rule. Since the sentence only needs the reader to search a number,
it now reads "see whether any running process carries that number", which is
both lint-clean and accurate.
