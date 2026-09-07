# Editor pass: 07-assembly/03-running-flye-or-hifiasm

Date: 2026-09-07
Role: brand copy editor, 2026-09 fidelity campaign

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/07-assembly/03-running-flye-or-hifiasm.md` prints "no issues found".

Front matter flags untouched. `brand_reviewed` and `lead_approved` both remain `false` for the gate to flip. One front-matter key did change: `accession` was added to `glossary_refs`, because the Why you would do this section now links the accession term when it introduces `NC_012920.1`, and the fidelity reviewer's front-matter check requires every listed anchor to be linked and (by the same invariant) every linked anchor to be listed.

## 1. The fidelity report

### The one false row, applied

The haplotype-graph file names in the "Hifiasm keeps more than it shows" paragraph carried no project-name prefix. They now read `<project name>.bp.hap1.p_ctg.gfa` and `<project name>.bp.hap2.p_ctg.gfa`, matching the primary graph beside them and matching the reviewer's `revC.bp.hap1.p_ctg.gfa` on disk. The same sentence now decodes all four name parts once, since reader consensus asked for that too.

### The unverifiable row, hedged

The mechanism offered for hifiasm's doubling is a claim about hifiasm's internals that nothing in this campaign's evidence base can confirm. The paragraph no longer asserts what hifiasm is looking for. It now says hifiasm "looks through its graph for a point at which to stop" and that a loop with no ends gives it none, which describes the observed outcome and the graph's shape rather than the tool's internal reasoning. The observation itself, which was reproduced, is stated flatly.

### The reviewer's new defect, disclosed

The CLI's multi-input refusal exits 0. The command-line section now says so in one sentence where a scripting reader meets it: the command "exits with a success status even though it ran nothing, so a script cannot tell the refusal from a completed run by the exit code alone."

### Notes for the editor

- **Note 2** (the multi-file refusal sentence quotes the sheet's wording while sitting in the command-line section). Applied by giving both. That paragraph now names the CLI's own message and the sheet's two messages, and says outright that the wording differs by route.
- **Note 3** (the brief's setting count is off). No change needed. The chapter's own "seven controls for each assembler" was already right, and the Settings lead-in now explains why eight bold entries follow seven controls, which was a separate reader row.
- **Note 4** (the Flye nondeterminism paragraph should stay). Overridden by the project manager's ruling, which is more specific. See the rulings section below.
- **Note 6** (the three new GLOSSARY entries use semicolons). Ruling for the gate, not for me: `GLOSSARY.md` is not mine to edit and the prose ban is scoped to chapters. I left the entries alone. The house style of the surrounding file is semicolons throughout, so my reading is that the ban does not reach the glossary, but I am not the one to settle it.

## 2. The 43 consensus rows

All 43 applied. Grouped by what the change was.

**Glossed at first use** (these also satisfy the PM's gloss list): plasmid, basecalling and "basecalled" in place of "called", CLR expanded as continuous long read with a note that it is an older PacBio mode, multiplicity as Flye's estimate of how many times a sequence repeats, duplicate purging and the memory-saving filter each in one clause under Profile, Illumina named as the short-read sequencer used in most laboratories, ploidy and parental copies moved up into What it is where they are first used, `.lungfishref` explained as one bundle format shared by assemblies and reference sequences, "pins" replaced with "always uses the exact tool versions it was tested against", mate suffix glossed as the `_R1`/`_R2` marker with the note that long reads are never paired, deterministic glossed inline, GC content given a one-line gloss plus the fixture's own ~44% value, replicon glossed as one separate DNA molecule, wall time glossed, artifact glossed, the timestamp shape spelled out, ONT and CCS expanded at first use of the letters, the `16k` hint decoded as 16 kilobases tied to the 16,569 base genome, and the four GFA name parts decoded once.

**Made concrete rather than metaphorical**: the unambiguous-path metaphor now says the assembler follows a stretch while exactly one edge leads forward and stops where two or more do. Node and edge are used throughout instead of alternating with "point" and "connection", and the four graph names (overlap, assembly, repeat, unitig) are stated to be one graph at different stages. "Rubble" and "debris" are gone. "Points upstream" now says the problem lies in the reads rather than the assembler. The read-type detection sentence now says LGE matches the header text against the patterns each instrument writes.

**Answered the reader's question rather than leaving it hanging**: which sidebar bundles carry assembly provenance (every assembly LGE made, never imported reads or downloaded references); where the no-contigs message appears (in the viewport, in place of the contig table, quoted verbatim from chapter 01's source citation); how to reach the run folder (right-click the assembly, **Show in Finder**, stated once in step 3 and referred back to at both `assembly_info.txt` mentions); which contig the next chapter carries forward (the Flye one); what to do when two runs disagree (rerun, keep the one matching the expected size); that combining FASTQ files needs the terminal; that the picker with one option is correct rather than broken, with the reassurance now ahead of the explanation.

**Restructured**: the eight Advanced Settings descriptions each get one clause and a lead sentence saying they are reference notes to skip unless writing extra arguments. The seven Flye stage names get one sentence saying they are Flye's own internal names, that none asks anything of the reader, and that a slow stage is working rather than stuck. The two absent controls (Memory Limit, Min Contig) are now described rather than assumed from the SPAdes chapter, and the chapter no longer assumes that chapter was read. The N50 repetition is replaced by a link to the concept chapter's worked example.

**Numbers**: 300-fold coverage is anchored against the fixture's own arithmetic (950 ONT reads, 4,348,051 bases, over 16,569 bases, giving 262-fold; 363 HiFi reads at 301-fold), which also ties the read counts back to the coverage figure. The reference run times stay exact with no tolerance, each followed by "a slower machine takes longer" and by the standing note that run time is not a check on a result. Threads now says where a reader finds their core count (Apple menu, **About This Mac**) and that the sheet already picks a sound number.

**Fixture**: the CONSISTENCY.md Download ZIP sentence is verbatim. The unpacked folder is named (`lungfish-genome-explorer-main`), the download is stated to be the whole repository with only two files needed, and the import is stated to produce two bundles with the sidebar row names given.

## 3. The rulings

**Flye nondeterminism.** Reframed exactly as ruled. The paragraph now says four Flye runs are on record, three of them plus the fixture's committed output gave 16,359 bp, and one gave a doubled 32,652 bp contig. It says Flye is "deterministic on this fixture almost every time" and "rarely takes a different branch that doubles the circle", so the flat "Flye 2.9.6 is not deterministic here" is gone. It tells a reader whose run comes back at roughly twice the expected length that they have hit that branch.

**The doubled circle.** The check is the contig length against the 16,569 base reference, and the paragraph says plainly that the viewport shows nothing about circularity or multiplicity. The remedy is a full paragraph: rerun through **Reassemble...** (the timestamped folders keep both results for comparison), or confirm the doubling by extracting the contig and mapping the reads back, by link to Extracting Contigs and to Mapping Reads to a Reference, with the expected signature named (every read maps twice, coverage reads at about half, the two halves carry the same sequence). "Collapse it by hand" is gone, replaced by the statement that collapsing is not something LGE does and needs tools this manual does not cover. The paragraph also distinguishes the two tools: rerunning clears it on Flye and will not on hifiasm, where assembling alongside the nuclear genome is what avoids it.

**Run folder.** Stated once at the end of Procedure step 3: the run folder sits under `Analyses/` in the project, named in the app's timestamp shape (`flye-2026-09-07T14-23-10`, spelled out in words), and is opened by right-clicking the assembly in the sidebar and choosing **Show in Finder**. Source confirms that item exists on any single sidebar selection (`SidebarViewController+MenuDelegate.swift:310-315`). Both later pointers to `assembly_info.txt` refer back to it. The "There is no `Assemblies` folder" denial is cut.

**Terminal material.** The five `cli_only` flags and every raw flag that was sitting in a Profile or toggle sentence now live under an H3 inside Settings, "The same settings on the command line", opened with one sentence telling a window-only reader to skip to Reading the results. The eight Settings entries no longer end with a flag sentence at all, so the "last sentence is for the command line" confusion is gone. The combining-FASTQ instruction gets no window route, because none exists: `fastq merge` is bbmerge for overlapping paired-end reads, not concatenation, and nothing in `FASTQOperationToolPanes.swift` or the operation catalogue offers a concatenate. The chapter says plainly that combining files needs the terminal. The command-line section opens with the fixed paragraph, "the sheet" swapped for the surface, matching 04-extracting-contigs.md word for word otherwise, and it now explains the backslash line continuation.

**Numbers.** No coverage or shortfall threshold was invented. The chapter says outright that no honest shortfall threshold exists across genomes and that the comparison against a known genome size is what you have instead.

## 4. Non-consensus rows applied

Most one- and two-reader rows went in alongside the consensus work, since they touched the same sentences. Named individually: "ships" replaced with "includes"; assembler glossed as a program at first use; polishing glossed; the failure mode named in one clause at its tease in Why you would do this; the Ashkenazim proper nouns thinned to a trio gloss with both catalogue names in a parenthesis; the accession explained; "an honest one" replaced; "slices down to" replaced with "keeps only the reads that came from the mitochondrion"; the empty-folder instruction merged and the reuse-a-project question answered; the internet connection stated; the five assemblers named at their first mention; where the installed version is shown; the sequence preview given as 80 bases; the sidebar row names given; the resulting Project Name shown for the fixture file; the Read Layout answer (long reads are single) given; what to do when Detected is wrong; the Inputs section named as the check on a stray selection; the Advanced Settings closed-by-default state stated; the sheet-vs-chapter "Settings" ambiguity resolved by naming "this chapter's Settings section"; the Analyses sidebar row stated so double-clicking makes sense; Apple silicon dated; "wins" and "escape hatch" replaced; the metagenome term named with an example on each side of the boundary; primary and alternate glossed at the Procedure mention and again under the toggle; the hifiasm output prefix scoped to file names inside the run folder; the Run Mode mention cut; the several long multi-clause sentences split.

## 5. Left for the gate, or unsourced

1. **The GLOSSARY semicolons** (fidelity note 6). Not my file, and the prose ban is scoped to chapters. Needs a ruling if the campaign wants the glossary swept.
2. **The fixture's Flye assertion.** The fidelity report's app defect 1 asks somebody to choose between pinning a seed, recording a tolerance, and dropping the exact-length assertion in `regenerate.sh`. That is a fixture decision, not a prose one, and the chapter now teaches the size check either way.
3. **Two reader rows I could not source and did not invent.** One reader wanted the Plugin Manager's install button named and a download time given. I state the size-free fact (the pack installs on demand, needs an internet connection once) and left the button label and timing out, since I could not confirm either from source. One reader asked whether the Cmd-N shortcut convention is explained early in the manual. That is an ARCHITECTURE question for the Documentation Lead, not a change to this chapter.
4. **`estimated_reading_min: 24`.** The body grew by roughly 800 words. The figure is an editorial judgment the fidelity report already called unverifiable, and I left it alone rather than adjusting a front-matter value on my own guess.
