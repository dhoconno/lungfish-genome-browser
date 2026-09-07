# Editor pass, 03-reads/07-ont-runs.md

Date: 2026-09-07. Role: brand-copy-editor. Chapter edited in place. No other
file touched. Lint green before and after.

## Changes applied

### Fidelity

- **Row 29 (false), plus ruling 1.** The run-folder import destination was
  `Imports/` in four places and is now the project root everywhere.
  - Frontmatter caption for `sidebar-after-ont-import`, "under Imports"
    becomes "at the top level of the project".
  - Procedure step 5 now reads "appears at the top level of your project in
    the sidebar, not under `Imports/` where a plain file import would put
    it", keeps "A 24-barcode run would land 24 bundles there", and adds the
    sibling-folder case from `ONTImportOperationCoordinator.resolvedOutputDirectory`,
    "Import a second run into the same project and its bundles are grouped
    into a folder named after that run, at the top level again".
  - What good looks like, first check, "count the bundles under `Imports/`
    after" becomes "count the bundles at the top level of the project after".
  - The chapter has no sidebar description paragraph beyond the caption, so
    those are the four sites.
- **Row 47 note, plus ruling 3.** Built-In Kit now says "Twenty kits are
  offered on the Cutadapt path" and adds "while the Exact Bare Barcode
  engine narrows the menu to the kits it can handle"
  (`FASTQOperationDialogState.swift:1097-1101`, `:1633-1638`).
- **Row 68 note, plus ruling 3.** On the command line now names all three
  commands, "The scout, demultiplex, and Fluidigm commands need to be run
  from inside a `.lungfish` project folder, because all three resolve their
  paths against a project."
- **Row 90 (half false), plus ruling 2.** The chapter did not previously
  quote the Fluidigm provenance error at all, so no sentence said a script
  would read the failure as success. The correction is therefore additive
  rather than a repair. Reading the results now states the defect with the
  right exit behaviour, "It prints a provenance error after it reports
  completion and after it has written its manifest, and it then exits with a
  failure status, so a script sees a failure for work that was in fact done.
  This is a known defect and it is filed." Nothing in the chapter claimed
  exit 0, so nothing needed deleting.

### Reader rows hit by three or more readers (13 of 13 addressed)

1. **Pore and electrical signal.** What it is now defines a pore as a
   protein hole in a membrane, says a single DNA strand threads through, and
   says each base changes the current by its own characteristic amount, so
   the run's raw output is a current trace rather than letters.
2. **Failed reads and the quality threshold.** The same paragraph now names
   `fastq_fail`, says the threshold is applied by the basecaller rather than
   set by the reader, and says LGE does not import that folder and it can be
   left alone.
3. **Phred 7.9 to one in six.** Why you would do this now gives the
   conversion in one clause, "the error probability is 10 raised to the
   power of minus the score divided by 10, so 7.9 works out to about 0.16",
   and states plainly that the figure is ordinary for an older nanopore
   chemistry rather than evidence of a broken run.
4. **Error Rate rounding.** The setting now says Cutadapt multiplies the
   fraction by the barcode length and rounds down, with a second worked
   example that is unambiguous, a 24-base barcode tolerating 3 because 3.6
   rounds down.
5. **950 versus 927.** A paragraph now sits immediately after the
   demultiplex summary where 927 first appears, saying 23 reads go missing
   between the counts, that the printed figure is the post-loss count, that
   this is a filed LGE defect rather than reader error, and that 950 is the
   real number. Sourced from fidelity row 89.
6. **Base count 72 percent.** What good looks like now says "This is a known
   defect in LGE, filed against the importer, and nothing you did causes
   it. It is confined to that one field", and rebuilds trust explicitly,
   "every number in the FASTQ viewport is measured rather than estimated".
7. **Command-line file name versus bundle name.** On the command line now
   states plainly why they differ, that the last three commands read a plain
   FASTQ under `Imports/` where a plain file import puts one, that either
   input works, and that the name differs only because these runs used the
   fixture file directly.
8. **GitHub folder download.** Before you start now says GitHub offers no
   folder download, spells the three folder names out in order as prose plus
   a code block showing the finished path, and says to leave the file
   compressed with its name unchanged.
9. **Docker Desktop and plugin pack.** Both mentions removed, replaced with
   the plain statement "Nothing in this chapter needs anything installed
   beyond LGE itself." This takes the reader row's first option, drop the
   mention.
10. **Inner and outer barcode.** The demultiplexing section now says both
    sit on the same molecule one after the other, with the outer at the very
    end of the read where MinKNOW finds it first and the inner just behind
    it, closer to the sample DNA.
11. **Barcode scout is command-line only.** The subsection now opens with
    "This check runs only on the command line, so if you are working
    entirely in the window you can skip this section and lose nothing from
    the procedure above."
12. **Nine cards and three sparklines.** Reading the results now
    cross-references `01-importing-fastq.md` for all nine and names the
    three this chapter uses, Reads, Bases, and Mean Q.
13. **POD5 and FAST5.** What this chapter does not cover now says they sit
    in their own directories beside `fastq_pass` in a real run, that they can
    be left where they are, and that the importer walks past them.

### Reader rows hit by one or two readers, fixed in a sentence or two

Barcode kit default named (TruSeq Single Index Set A (D701-D712), the first
element of `BarcodeKitRegistry.builtinKits()`, and flagged as an Illumina
kit so the "almost never the one you want" warning is now checkable). Kit
code sourced to the kit box or library preparation record, in both the
Built-In Kit setting and the Demultiplex Barcodes paragraph. Window has no
unclassified control, stated plainly. `barcodeNN` named as the literal
folder pattern the importer looks for. Barcode stated to sit in the read
sequence itself at the read's start. The two reasons a barcode fails to call
named. "Control software" replaced with "the program that runs the
sequencer, on the sequencer's own attached computer". "Chunks" replaced
throughout with "files" (five sites). Library preparation glossed and linked
at first use. Read-length spread stated as normal for every run. Coverage
named and linked at the "pile of reads" sentence. 262-fold benchmarked
against the 30-fold to 50-fold most variant work asks for. Operations Panel
given its menu path and glossary link. The Pairing control's job explained in
one clause. Step 4 now says the pictured controls only appear once the
checkbox is on. Step 2 now says to highlight the folder rather than open into
it. The Tools menu item stated to open the FASTQ/FASTA Operations dialog. CS1
and CS2 stated to be already known to LGE. Read header glossed. Undecided
defined as falling between the two thresholds. Settings lead-in now names the
boundary settings and counts both groups, and says the five deferred settings
stay at their defaults. Barcode Sheet given its file type, an example PacBio
row, its usual origin, and a note that the trailing colon is the on-screen
label. Demux Folder now names the underscore as the replacement character.
The recipe picker now names its two choices before describing them and says
it sits directly under the checkbox. Bare barcode glossed and the Engine's
two ideas separated, position freedom against sequence strictness, with a
Fluidigm amplicon as the concrete case. Location rewritten to "at which end
of the read", with 5' and 3' glossed as start and finish. 5' Distance now
says 0 is strict rather than off, and gives about 10 as a working value.
Trim Barcodes command-line default stated as trimming. Output Strategy's
"safe reading of a multi-select" replaced with plain words. `Output:
imported` identified as the output folder name. Sparkline glossed and linked.
`unassigned` versus `unclassified` distinguished side by side.
`.lungfishfastq` identified as a bundle folder shown as one icon. The
Fluidigm manifest identified as a separate file in its own output folder.
`demux-manifest.json` located in the output folder and marked ignorable for
window users. Wrong-kit versus no-barcode cases now distinguished by
rerunning the scout with the suspected kit. The base-count pointer now names
its destination, "the third check under What good looks like, just below".
The `.lungfish` project folder identified as the folder made in Before you
start. Backslash stated to be typed. The `--threads` provenance sentence
rewritten without the unglossed term. The Quality Binning sentence split in
two. The scout flags broken into their own paragraph, away from the PacBio
command. Strand direction moved forward into Why you would do this, with the
Next section now back-referencing it.

### Style and consistency

- Prose rules hold. No em dash, no semicolon, and the only colons inside a
  paragraph are the two settings labels `Barcode Sheet:` and `Demux
  Folder:`, which `sentence-colon.js` now subtracts (commit `fc365eaf5`).
- No banned word from `ai-tells-words.txt` was introduced. "Chunk" was
  removed for reader clarity, not because of the word list.
- CONSISTENCY.md already carries the ONT project-root line settled at this
  review, and the chapter now matches it in substance.
- Naming holds. "Lungfish Genome Explorer" at first mention in What it is,
  "LGE" everywhere after.
- No new durations. The only timing claims remain the quoted 0.2s and 2.5s
  from the recorded runs.
- Voice. Both defect disclosures are written trustworthy and calm, each
  saying plainly that the fault is LGE's, that it is filed, and what number
  to trust instead.
- Caption for `demultiplex-barcodes-pane` extended to name Output Strategy,
  which two readers could not find on screen.
- `glossary_refs` gained `library-prep`, `coverage`, `operations-panel`, and
  `sparkline` for the four new glossary links. All four entries already exist
  in `GLOSSARY.md`, which was not edited.

## Left unchanged, and why

- **Section order, and the Settings paragraph set.** Untouched per ruling 4.
  All 13 registry settings keep their bold labels verbatim, including the two
  ending in a colon.
- **The reader row asking to split Settings under two subheadings.** That is
  a structural change, which ruling 4 forbids and the persona forbids
  independently. Addressed within the existing lead-in instead, by naming
  the boundary settings and counting each group. **For the project manager to
  rule on** if the lead-in proves insufficient.
- **The reader row asking to strip the trailing colon from `Barcode
  Sheet:`.** The label is verbatim from `parameters.yaml` and ruling 4
  requires it. The chapter now explains the punctuation to the reader
  instead.
- **The reader row asking for a healthy demultiplex summary beside the empty
  one.** Inventing a successful summary would breach the campaign's ground
  truth rule, since no run produced one on this fixture. **For the project
  manager to rule on** whether a second fixture is worth commissioning.
- **The reader row asking for a diagram of nested inner and outer
  barcodes.** `illustrations` is empty and this role does not own that list.
  Handled in prose. Flagging it as an illustration candidate.
- **The reader row asking to replace the step 4 placeholder with a real
  picture.** Screenshots belong to the screenshot-scout. The marker stays and
  the step now describes the checkbox's position in words.
- **Procedure step count.** Five numbered steps, at the `bullet-cap.js` cap,
  so every addition went into an existing step rather than into a sixth.
- **The three CLI input paths in the code block.** Fidelity verified these as
  the exact commands run on 2026-09-07. Changing them to the `barcode01`
  bundle path would break that provenance, so the mismatch is explained in
  prose instead.
- **The Fluidigm defect's root cause and the missing 23 reads.** Documented
  as filed defects, not diagnosed. Source fixes are not this role's.

## Lint output

```
$ LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/03-reads/07-ont-runs.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/03-reads/07-ont-runs.md: no issues found
```

## Status

brand_reviewed: true
