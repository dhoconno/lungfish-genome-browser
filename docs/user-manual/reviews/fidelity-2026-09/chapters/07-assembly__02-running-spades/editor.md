# Editor pass: 07-assembly/02-running-spades

Date: 2026-09-07
Lint: `LUNGFISH_MANUAL_STRICT=1` reports "no issues found".
Front matter: `brand_reviewed` and `lead_approved` left at `false` for the gate.

## Inconsistency rows from fidelity.md

**SPAdes wall time.** All three occurrences of 110.7 seconds are now 13.7
seconds, taken from `fixtures/human-mito/expected/spades/assembly-result.json`
(13.719936966896057) and matching `01-when-to-assemble.md:112` and the fixture
README. The figures changed in Before you start, in the summary-strip reading,
and in the comparison table. Before you start now carries one sentence saying
the same command took 110.7 seconds in the author's run on a busy machine with
byte-identical results, so runtime is not a check on a result and cannot be
scaled from a core count. The `assembly-viewport` caption quotes no time and
was left alone.

**Threads crash rationale.** The entry no longer says MEGAHIT "crashes above
that on arm64", which implied two threads is safe. It now says the cap and the
disabled hardware acceleration reduce the crash rate and do not remove it, and
that a run may still stop partway with a nonzero exit code at two threads.

## The four Notes for the editor

1. Wall time. Done, as above.
2. MEGAHIT reliability caution. Added as one paragraph in the Settings lead,
   immediately before the **Assembler** entry, which is where a reader can
   first choose MEGAHIT from a control. It uses the reviewer's drafted wording
   with the exit-code symptom and the "a run that does complete is correct"
   point folded in. A second mention sits in the **Threads** entry, and the
   comparison table's lead sentence attributes the MEGAHIT row to a run that
   completed. Widening the concept chapter's k=99 claim belongs to that
   chapter's editor and is left for the gate.
3. Threads rationale. Done, as above.
4. Settings count. The lead now says eleven controls with SPAdes selected and
   explains in the same sentence that thirteen entries follow, because Profile
   is documented twice and Output Folder is a read-only row.

## Manager rulings

**MEGAHIT.** Figures kept and attributed. Caution paragraph placed as above,
one sentence added to **Threads**, one clause added to **Assembler** pointing
back to it.

**Align with MAFFT.** The action-bar paragraph no longer lists it among the
right-click additions. One sentence now says it does not appear in the assembly
contig menu in this release and names that as an app defect. This matches the
sibling chapter 04 finding.

**Min Contig.** The entry now opens with what the control does, names the
assemblers it reaches from source (MEGAHIT as `--min-contig-len`, SKESA as
`--min_contig`, per `ManagedAssemblyPipeline.swift:225-227` and `:263-265`),
then states in one plain sentence that with SPAdes the value is shown and
editable but never reaches the SPAdes command, so it changes nothing for
SPAdes, and that this is an app defect. The "recorded as one" tracking clause
is gone. The Procedure meets the control only through step 5's instruction to
change nothing, so the second statement lives in the command-line section's
flag notes, where `--min-contig-length` is described the same way. See "left
for the gate" below.

**Numbers.** No read-count threshold, coverage cutoff, or length margin
invented. The "low thousands" sentence is replaced by coverage arithmetic. Why
you would do this now says the 9,958 pairs assemble cleanly because the genome
is only 16.6 kb, giving about 122-fold coverage as the contig name reports, and
that coverage rather than the raw count is what matters. Before you start now
points at the Apple menu and About This Mac for the Chip and Memory lines.
SKESA's `257.173` is named as its coverage estimate, paired with the SPAdes
`cov_` field. The SPAdes k values 21, 33, 55, 77, 99, and 127 come from
`expected/spades/spades.log` ("with K=" lines) and the `K21` through `K127`
directories, and they are connected to the k-mer example, which now shows the
shared bases on `ACG`/`CGT`/`GTA` and states the k minus 1 rule.

**Careful mode.** The entry now says the reference run left it off, that off is
right for a first pass on any sample, which is why the Procedure says to change
nothing, and that a later run on a mitochondrial or small genome may turn it
on.

**Counts.** Done, as above.

**Fixture.** The CONSISTENCY.md Download ZIP sentence is used verbatim. The
unpacked folder is named as `human-mito`. No size is given for it. Install All
is now stated to need a network connection, with the pack at about 950 MB from
`01-when-to-assemble.md:70`, and no install time.

**Glosses at first use.** Coverage now sits in Why you would do this, ahead of
the coverage-anomaly clause, with depth named as the same quantity. Indel is
expanded as a small insertion or deletion. Fixture is glossed as the practice
dataset supplied with the manual. SPAdes is expanded and its pronunciation
given. GC content is glossed in What it is, well before the results block, and
N50 and L50 keep their definitions in Reading the results ahead of the table.
The Inspector is glossed as the right-hand panel with **View > Show Inspector**
(Cmd-Opt-I), verified at `MainMenu.swift:446-453`. The three pane layouts each
get one clause saying what sits where. Materialise and derived bundle are split
into plain sentences that say a freshly imported bundle is not derived, so the
step is instant for the fixture. "Sniffs the header" is now "reads the first
FASTQ header", with the header glossed as the identifier line above each read.
Parser is gone in favour of describing how LGE reads the field, and footer is
glossed as the strip along the bottom of the sheet. The SKESA `--min_count 2`
pin has its own paragraph explaining what it counts and what it protects
against. What it is states that an assembly bundle is a reference bundle in
`.lungfishref` form.

**Project Name.** The entry now shows the result for the fixture,
`HG002.chrM_assembly`. Verified against `AssemblyWizardSheet.swift:326-334`,
where the stem comes from the bundle after `deletingPathExtension`, so the
`HG002.chrM` bundle yields that name. The imported bundle's row name,
`HG002.chrM`, is stated in Before you start and again in Procedure step 1.

**Run Mode.** "which is the setting" is gone. The entry now says two options
are shown and only Run separately per bundle can be selected.

**Assemblies folder.** The denial is cut. The run folder sentence now gives the
timestamp shape `<tool>-2026-09-07T14-23-10` and says the letter T separates
the date from the time.

**App defects disclosed.** Four, each in one sentence where the reader meets
it. Min Contig inert for SPAdes (Settings entry, and again in the command-line
flag notes). MEGAHIT unreliable on Apple Silicon (Settings lead caution, plus
the Threads sentence). MEGAHIT's Threads slider overridden without notice
(Threads entry). Align with MAFFT absent from the assembly contig menu (action
bar paragraph). The locked Run Mode caption's semicolon is a manual problem
rather than a user-visible one, so it stays paraphrased as before.

## Consensus reader rows (37) and others applied

All 37 consensus rows are applied. Beyond them I applied the great majority of
the two-reader and one-reader rows, including the idiom and metaphor
rewrites in What it is and Why you would do this ("gets there", "the shape of
it is right", "ships", "walks the surviving unambiguous paths", "nothing but",
"leave every setting alone", the rhetorical question, "blind"/"blind spot",
"the tube", "toy", "on demand", "break", "pins", "earns its keep", "meet",
"at the edges", "normal state of affairs", "N50 is the one you will meet
most", "so nothing scrolls away permanently"), the segmented-buttons and
disclosure vocabulary, the ceiling/reservation metaphor, the L50 direction, the
Skip error correction double negative, the nine-values sentence turned into a
code block, the ONT and PacBio expansions, the backslash continuation note, the
bare-filename working-directory note, the `--extra-arg` singular note, the
alias interchangeability note, the `--profile` accepted-and-ignored
reassurance, the CLI-installed pointer, the chapter numbering note in Next, the
BLAST gloss with where the search runs (NCBI, verified in
`ViewerViewController+Nvd.swift:112`), the row-selection clarification, the
header-column meaning, the GC naming reconciled to one figure across the three
places, the smoke-test duration and recovery step, the read-type picker
fallback pointer, the "land close to" tolerance, the empty-project-folder
sentence, the gzip-import statement, the mate-files gloss, the Isolate gloss at
its first use, the timestamp T clause, the plasmid and metagenome glosses, the
long-read contrast, the short-extras explanation, the SPAdes-versus-SKESA speed
explanation, the circular double-write clause, and the MEGAHIT internal-id
detail moved out of the window section into the command-line flag notes.

Two reader suggestions I did not take as written.

The suggestion to move every Settings flag sentence into a table in the
command-line section conflicts with the CONSISTENCY.md Settings entry shape,
which requires the flag in a final short sentence per entry. Instead the
Settings lead now says up front that those closing sentences belong to the
optional command-line section, which is the reader's stated need (the "optional
label arrives too late" row) without breaking the fixed shape.

The suggestion to pull Min Contig out as a separate known-issue note would
change the section's structure, which is not mine to change. The plain sentence
at the entry carries the same information.

## Facts I could not source

**SKESA's `257.173` field.** No documentation for SKESA's contig header format
is present in the installed pack. `skesa --help` does not describe it, and
`~/.lungfish/conda/envs/skesa/share/doc` holds only `xz` documentation. I
named the field as SKESA's own coverage estimate on the strength of the
positional analogy with the SPAdes `cov_` field and the run data, and the
chapter says plainly that each tool counts coverage its own way so the two are
not comparable. If the gate wants a citation, SKESA's own repository README is
the source and is not in this checkout.

**Min Contig threshold guidance.** I gave "somewhere above twice your read
length", tied to the fixture's 250-base reads, which lands near 500 and
therefore keeps the chapter's existing 500 example. This is a rule of thumb
rather than a source-backed figure, and the sentence is framed as guidance
rather than as a rule the app enforces. Flag it if the gate wants it removed.

**Coverage bands in Reading the results.** "Tens is thin, around a hundred is
comfortable, thousands brings no further benefit" for a genome this small is
general practice rather than a measured figure from this fixture. Flagged for
the same reason.

## Left for the gate

The concept chapter `01-when-to-assemble.md` still names k=99 and SIGABRT as
the MEGAHIT failure. Widening that to the general fault is the reviewer's
second Note and belongs to that chapter, not this one.

The Procedure never surfaces the Min Contig control, because step 5 tells the
reader to change nothing and the sheet's Primary Settings are not walked
control by control. The ruling asks for the defect once at the entry and once
in the Procedure where the reader meets the control. I placed the second
statement in the command-line flag notes instead, since that is the only other
place the reader meets the setting. If the gate wants it inside the Procedure,
step 5 would need a sentence naming the control, which is a structural addition
I did not make.

`brand_reviewed` and `lead_approved` are both still `false`.
