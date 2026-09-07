# Editor record: 07-assembly/04-extracting-contigs

Date: 2026-09-07. Brand copy editor pass over the lint-green author draft,
applying `fidelity.md`, `readers.md`, and the project manager's rulings.

Lint, `LUNGFISH_MANUAL_STRICT=1`, exit 0, "no issues found". No em dashes, no
semicolons, no in-sentence colons, verified by grep after the final edit.
Front-matter flags untouched, both still `false`.

## 1. False rows from fidelity.md, all four applied

**Context menu titles.** The Procedure paragraph after step 5 now reads
"Extract Sequence...", "BLAST Contig...", "Copy FASTA", "Export FASTA...",
"Extract to New Bundle...", and "Run Operation...". The chapter says plainly
that Extract to New Bundle is the context menu's name for Create Bundle.
Confirmed against `FASTASequenceActionMenuBuilder.swift:14` and `:17` for the
two overridable defaults, `:70-127` for the fixed titles, and
`AssemblyResultViewController.swift:294-309` for the one override this
viewport applies, `blastMenuTitle: "BLAST Contig…"`.

**The `contig-context-menu` caption.** Rewritten to the fidelity report's
wording, with the separator placed correctly below Extract to New Bundle and
Run Operation alone underneath it, and with Align with MAFFT removed.

**Align with MAFFT.** The greyed-out sentence is gone. The chapter now states
in its own short paragraph that the item is absent from this menu, glosses
MAFFT and multiple sequence alignment (a reader row), and says it appears in
the FASTA collection viewport instead. Verified that `refreshContextMenu`
never passes `onAlignWithMAFFT` and that `addItem` returns early on a nil
handler (`:138`), so the item is never built here.

**The project-root error string.** The quoted message is cut. The chapter now
says a Create Bundle run on an assembly outside a project stops before it
starts because there is no `Reference Sequences/` folder to write into, adds
that this is rare and how to resolve it (a reader row), and keeps the real
"Reference Bundle Creation Failed" alert.

Also fixed, and not on any row. The author's `entry_points` second line said
"contig table context menu: Create Bundle", which the false row disproves. It
now reads "Extract to New Bundle...". The registry still carries the old
string, so `parameters.yaml` needs the same correction. Left for the gate.

## 2. Unverifiable rows, all three hedged or cut

**SPAdes bundle-name example.** Cut, per ruling. The Bundle name entry now
gives the MEGAHIT suggestion the chapter's own reader will see, `k141_1`,
sourced from `defaultSuggestedName` returning `selectedContigs[0]` and from
the run's `final.contigs.fa` headers. The SPAdes point survives only as the
reason to rename, "which is common with SPAdes, whose contig names carry
their length and coverage", with no invented string.

**`--line-width 0`.** Softened to "note that 0 is accepted", the fidelity
report's own suggested wording. The untested "one unbroken line per record"
claim is gone.

**`manifest.json` sequence list.** Replaced with the report's wording, "records
the bundle's genome files and carries the Derived Subset metadata described
above".

## 3. Consensus rows, all 36 applied

Assembler glossed at first use as the program that joins overlapping reads,
with MEGAHIT and SPAdes named as the two the previous chapters run. The 4%
leftover share now follows a stated rule rather than preceding one, "one
contig is the one you want and the rest are short fragments the assembler
could not extend". The uncompressed-FASTA aside is cut from the primer and
survives only in the command-line section, where it describes a file on disk.
The rhetorical question is cut. Depth and variant call are both glossed before
the muddying sentence, which is split in two. The SPAdes-titled link now says
it is the chapter that covers both assemblers and that this chapter uses the
MEGAHIT run. The "no Assemblies folder" sentence is cut. Rank and GC percent
are glossed as columns, with GC given a value to expect. The "no coverage
column" sentence is cut, and the six columns are described positively instead.
Materialize is glossed as the app's word for writing the selection out as real
files. BLAST is glossed and linked to the BLAST Verification chapter. The
Operations Panel is introduced as a list of what LGE is running, opening it is
called optional, and the shortcut stays. The eight command-line flags are under
their own `### Command-line-only flags` heading, opened with a sentence telling
a window reader to stop there. The bundle-name example is the MEGAHIT one. The
observed 44.3% GC now follows the reference value. The move-or-rename warning
says what breaks, that the sequence is unaffected, and how to repair it. The
circular-genome sentence is split in two and says the assembler carries a
stretch past the cut so the ends overlap. Coverage is glossed in words and
given a rough number. The command-line section states up front that it assumes
prior terminal experience and where Terminal lives. The Create Bundle defect is
disclosed in the Procedure where the reader meets the button and again in
Settings, and the contradicting earlier claim is fixed (see below). Read is
glossed. The FASTA index is called a small automatic companion file. MEGAHIT is
introduced at first mention. Translate is disambiguated to protein translation.
The download instruction leads with the working ZIP route. "Quickly" is
replaced with the measured time. Extract Sequence is given performable words.
MAFFT and MSA are glossed. The BLAST cap is scoped to BLAST alone. Standard
output is glossed. The Derived Subset block is located in the Inspector. The
96.01% figure is given a way to judge it that invents no cutoff.

**The contradiction fix.** The old third case in Why you would do this said a
derived bundle carries the assembler unconditionally, which the command-line
section then contradicted. It now reads "A bundle made from the command line
with `--assembly` carries a small metadata block", and Reading the results
carries the same qualifier.

## 4. Other rows applied

Roughly 40 of the non-consensus rows. Reader 3's idiom list is applied nearly
in full ("hands you", "the thing you were after", "extend", "derives",
"scatter", "a single place to go", "the route across", "tidying", the bundle
given a voice twice, "costs you nothing", "leaves nothing to choose between",
"reads the count back to you", "carry", "greyed out", "bare command",
"readers" for people, "cheap signal", "one" for run folder, "pipe", "bare",
"uneventful"). Also applied. `.lungfishref` described as a folder macOS shows
as a single item, HG002 identified as a widely used human reference sample,
Cmd glossed once, "open LGE first" added as the opening instruction, the
project glossed, fixtures called example files for practice, a timestamped
folder name shown, the sidebar located, the contig row named as the top row by
length with its real name `k141_1` so the code block's `--contig k141_1` is no
longer its first appearance, the FASTQ/FASTA Operations dialog described,
`NC_012920.1` called an accession number, vector disambiguated as a cloning
vector such as a plasmid, "collapsed" replaced with plain words, the collision
counter said to apply to the new bundle and shown where the reader meets it,
Control-click added for trackpads, the four-action sentence broken into a
numbered list, backslash continuation and angle brackets both explained,
"scriptable" glossed, the double-clicking-a-contig expectation stated for
readers of other sequence viewers, the Next section told first-time readers
which chapter follows, and `--assembly` noted as visible in the Finder rather
than the sidebar.

**Not applied, deliberately.** Four rows asked for numbers the sources do not
carry, and the ruling forbids inventing them. No cutoff is given for the 4%
leftover share, the 96% dominant share, "too distant to map against
comfortably", or a GC range beyond the reference comparison. Each is instead
given a way for the reader to judge the number. The ZIP download size is not
stated, since it is a property of the repository at download time rather than
a documented fact. The "how big is the download" row is therefore unmet.

## 5. Rulings

Every ruling is applied as written. The worked example stays on MEGAHIT and
Before you start now carries the Apple Silicon sentence, that a rerun may be
needed, that a completed run is correct, and the single-contig SPAdes
fallback. The SPAdes-titled link names the chapter as the place MEGAHIT is
run without implying SPAdes produced the example. The destination paragraph
says `Reference Sequences`, `<assembly>-subset`, the `-subset 2` and `_2`
collision forms, and the contrast with `Extractions`. The Create Bundle defect
is disclosed in two places in plain words. The mitochondrial comparison uses
16,569 bases from `NC_012920.1` and explains the 142 extra bases in two short
sentences. "Quickly" became "a couple of seconds", from `wallTimeSeconds`
2.70 in the run's `assembly-result.json`. Terminal material is under its own
subheading with a skip sentence, the command-line section opens with
CONSISTENCY.md's fixed opener with "the dialog" swapped for "the action bar"
as that sheet directs, and standard output and standard error are glossed
once each. The Download ZIP sentence is verbatim from CONSISTENCY.md. Sibling
chapters 01, 02, and 03 were not edited, and chapter 02 is linked by file
name.

**One ruling met with a source correction.** The ruling asked for the Extract
Sequence sub-range step "in performable words from source". The source does
not support a sub-range. `FASTASequenceExtractionDialog.swift` carries exactly
two controls, a Destination radio group and a Name field, with no start or end
position anywhere in the file or its model. So the chapter now describes the
dialog as it is and states plainly that it takes whole contigs rather than a
sub-range. This makes the author's "takes a sub-range of a contig rather than
the whole thing" a fifth false claim that the fidelity review marked true. Its
evidence cited the wiring at `AssemblyResultViewController.swift:297` rather
than the dialog the wiring opens.

**One ruling was already true.** GC content is compared against the organism's
known value, and the fixture does record it. `NC_012920.1.fasta` computes to
44.36%, quoted as 44.4%, against the contig's 44.3%. So the fallback wording
was not needed.

## 6. Left for the gate

- The two front-matter flags, `brand_reviewed` and `lead_approved`, both left
  `false`.
- `parameters.yaml` `assemble.extract-contigs` still lists the second entry
  point as "contig table context menu: Create Bundle". The chapter's front
  matter is corrected, the registry is not, because it is not this role's
  file. Registry `settings` and `cli_only` needed no change and the chapter
  still documents all ten.
- `CONSISTENCY.md` should record `Reference Sequences/` as a named second
  exception to the `Extractions/` rule, per the fidelity report.
- Chapter 02 carries the same Align with MAFFT error and is owned by another
  editor this round.
- Chapter 01's blanket MEGAHIT-fails claim versus chapters 02 and 04. This
  chapter now acknowledges the caution rather than contradicting it silently,
  which is what the fidelity report asked of it, but the underlying conflict
  is unresolved.
- The DRIFT claim 14 verdict still needs amending.
- Three shot captions still need a capture pass. Two are corrected here, so
  the capture should be taken against this version.

## 7. Facts I could not source

- The size of the repository ZIP download, and where a browser puts it. Two
  readers asked. Not a property of the app or the fixture.
- `--format json` and `--format tsv` output shapes. The author's run 6 shows
  only that the flag is accepted. The chapter still describes purpose, not
  output.
- The Export FASTA save panel's pre-filled name, still uncovered by any
  chapter.
- Whether Align with MAFFT's absence is an oversight or deliberate. The
  chapter calls it a gap in the wiring, which is what the code shows, and does
  not guess at intent.

## Status

brand_reviewed: false (the gate flips it)
