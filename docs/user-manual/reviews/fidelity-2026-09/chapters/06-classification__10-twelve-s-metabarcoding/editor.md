# Editor pass, 06-classification/10-twelve-s-metabarcoding

Chapter: `docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md`
Editor date: 2026-09-07. Build documented: Preview 2026.9.13.

Lint, verbatim final line:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md: no issues found
```

Counts. 2 of 2 false rows fixed. 35 of 35 consensus rows applied. 40 of the
remaining 67 reader rows applied. 3 rulings needed a source check that changed
what the ruling assumed, recorded under "Where the source overrode the brief".

## The two false rows

**Claim 7, the pack name.** Fixed in both places. The Before-you-start
paragraph now reads "which the card names as **Third-Party Tools**", and the
`twelve-s-workflow-library` caption in front matter now says "its dependency
row for the Third-Party Tools pack". Verified against
`third-party-tools-lock.json` line 3, `"displayName": "Third-Party Tools"`.
`lungfish-tools` is the pack id and is never shown, so it appears nowhere in
the chapter now.

**Claim 38, the control split.** The Settings lead-in for the Inspector group
now reads "The first four sit under **Target Rows** and the last two under
**Unmatched Reads**", which accounts for all six. Verified against
`TwelveSResultDisplaySection.swift:238-245`, where `Target Rows` holds
`filterControls` and `taxonomyControls` together, so Taxon Groups is the fourth
control in that disclosure rather than an orphan.

## The rulings

**Fixture.** Before you start rewritten. It carries the project sentence, the
fixture sentence with the GitHub folder link, and the CONSISTENCY.md Download
ZIP sentence verbatim. The three files the reader uses are named in their own
paragraph. One sentence states that the fixture is a constructed teaching set,
five primate 12S sequences cut from public mitochondrial genomes plus HG002's
own mitochondrial reads trimmed to the 12S region, so the human reads are
expected to match Homo sapiens and nothing else. Every instruction to build
anything from the demo project is gone, and `grep -i "demo project"` over the
chapter now returns nothing. `fixtures_refs: [primate-12s]` set.

**Orientation.** The Procedure now uses `HG002-12S-oriented.fastq` throughout
and never asks the reader to run `fastq orient`. The whole orientation
explanation moved into one Before-you-start paragraph, which glosses reverse
complement, states that the matcher checks one strand only and that
other-strand reads are silently unmatched, gives the 75-of-110 figure
attributed to the author's run on the unoriented reads, names the Orient Reads
operation with a link to `03-reads/08-read-processing.md`, and names Merge
Overlapping Pairs by link in the same chapter. The no-reverse-complement defect
is stated once, in that paragraph, and the old copy of it in What good looks
like is gone. The closing `fastq orient` paragraph now points back to Before
you start rather than to a section that no longer carries the trap.

**Enabling route.** Workflow Library, Specialized Workflows, Genotyping, the
Enabled switch, Install Dependencies, and the "(not enabled)" Tools item all
kept. The experimental-features sentence is cut entirely, which also settles
reader row 25. "Alert" became "message window" (row 83) and the
"same route by a longer path" clause is deleted (row 84).

**Inspector.** Introduced once at the end of Before you start with
**View > Show Inspector** (Cmd-Opt-I) and its location on the right-hand side.
See the source note below on why it does not say Analysis tab.

**Numbers.** The four-figure summary line is shown verbatim as an indented
block, `1 samples | 110 exact reads | 36.4% unresolved | 0 chimera candidates`,
computed from `summaryText` at `TwelveSAmpliconResultViewController.swift:1554`
against the author's run. A dedicated paragraph states that the unresolved
percent and the exact-match percent are complements of one figure, both
dividing by the same 173 input reads, and always sum to 100. No healthy
exact-match rate is given anywhere, and "A healthy 12S run resolves most of its
reads" was changed to "concentrates its matched reads on a small number of
species" so the section does not smuggle a threshold back in. No BLAST identity
cutoff is given, replaced by an explanation of what the Identity column
measures plus an explicit statement that the chapter gives no fixed cutoff.
What good looks like now says a rate is judged against what the reference
covers and that the fixture's 63.6 percent reflects reads from outside what the
five 60-base targets can match, which is the reading the fixture README's
"Internal consistency" section supports.

**Min Soft Clip.** The glossary link now resolves to a `soft-clip` entry that
covers this sense. The existing entry was CIGAR-only, so per the ruling I
appended one sentence to `GLOSSARY.md` giving the 12S sense, the read's own
bases hanging past each end of the matched stretch, and naming the Min Soft
Clip setting. The entry keeps its BAM sense first. The setting now gives the
registry's range, "0 or more", rather than an invented one, plus 5 or 10 as
values to try and what setting 0 means.

**Reference columns.** Step 1 now says the builder needs all seven columns and
sends the reader to the command-line section for the list, rather than naming
four and contradicting the later list. The four it does name are labelled as
the four a reader usually thinks of. The command-line paragraph says the list
there is the same one the dialog's builder needs. The help-text omission is
disclosed in one sentence with the version, naming `common_name` and
`name_source`. The parenthesis-free header defect is one sentence at the end of
step 1, with the version and the symptom. The `--compress` defect is one
sentence in the closing paragraph, with the version. None of the three carries
a fix status.

**Four other primates.** All four now named, the chimpanzee, the western
gorilla, the rhesus macaque, and the cynomolgus macaque, taken from the
fixture README's species table.

**Glosses at first use.** HG002 as a public reference human sample, plugin pack
with a glossary link plus network and time expectations, MIDORI as the public
reference database of animal mitochondrial marker sequences, ONT expanded to
Oxford Nanopore in the Read Platform entry, refs and reference records in step
4, chimera at its real first use in step 5 rather than only in Settings, soft
clip in the Min Soft Clip entry, the action bar located as the strip along the
bottom edge of the viewport at its first use in step 6, and the Show in Finder
route in step 7. The rhetorical question "So what should you do with this?" is
cut. Several bundles selected at once are stated to stay per-sample, sourced
from `TwelveSAmpliconMatchingWorkflow.swift:273-313`, which counts every sample
separately into `perSampleSequenceCounts`.

**Command line.** Every flag sentence kept. The Settings lead-in gained the
one-line note that those closing sentences belong to the optional command-line
section, extended with "Nothing later depends on having read them."

## Other reader rows applied

Rows 24 (matching rule stated once as containment, "base for base" dropped),
26 (step 1 no longer sends the reader to step 2 before they have a reference,
and its heading became "Choose or build a 12S reference"), 27, 28 (bundle
glossed once, and which file type a first-time reader will have), 29, 30, 31
(Sequence holds a label, Bases holds the DNA), 33, 34, 37, 40 (the two
operations that genuinely need the terminal are named, with a pointer to the
CLI appendix), 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 52, 53, 55 (the sequence
leaving the machine, stated plainly), 56 (63 reads stated directly), 57, 58,
59, 60, 61, 62, 63, 64, 65 is partly covered, 68, 69, 70, 72, 73, 74, 75, 76,
77, 78, 79, 81, 82, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95 is partly
covered, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108.

## Where the source overrode the brief

**The Inspector tab is Summary, not Analysis.** The ruling allowed "in its
Analysis tab if the source says so, otherwise in the Inspector". The source
says otherwise. `TwelveSResultDisplaySection` is rendered under
`case .resultSummary` in `InspectorView.swift:147-152`, and that tab's
on-screen label is "Summary" (`InspectorView.swift:235`). The `.analysis` tab
is a different one, labelled from `InspectorAnalysisWorkflowSection`. The
chapter therefore says the controls live in the Inspector, without naming a
tab.

**Confirmed is never written by the chimera review.**
`TwelveSChimeraReview.swift:157-172` parses the UCHIME output into `candidate`
or `notDetected` only. `confirmed` exists in `TwelveSChimeraStatus`
(`TwelveSAmpliconResultModels.swift:343-347`) and in the Inspector's Chimera
menu, but nothing in the review path sets it. The Settings entry now says so
rather than inventing a candidate-versus-confirmed distinction, and reader row
52's request to distinguish the two is answered by explaining that vsearch
reports only one of them.

**The `.lungfish12s` bundle is a plain folder, not a macOS package.** I first
wrote Show Package Contents into step 7, then found no `LSTypeIsPackage` or
package UTI declaration anywhere outside `.build`, so the Finder shows these as
ordinary folders. Step 7 now says to open the bundle like any other folder.

## What I could not source, and left alone

**Whether the window's Orient Reads is affected by the `--compress` defect.** I
drafted a sentence saying the window path is unaffected and then removed it. I
confirmed the CLI behaviour from the author's and the reviewer's independent
reproductions and from the fixture README's closing note, but I did not read
`FastqOrientSubcommand.swift` against the window's operation path closely
enough to assert anything about the GUI. The chapter now scopes the defect to
`lungfish-cli fastq orient` and says nothing either way about the window.

**How long a plugin pack install takes.** Reader rows asked for size, network
need, and duration. I state that it needs a network connection and usually
takes a few minutes, which matches the sibling chapters' treatment, but I have
no measured figure and gave no size.

**Whether `sample_id` is the label the 12S dialog documents.** The aliases
`sample_id`, `sample`, `sample_name`, and `id` come from
`SampleMetadataResolver.swift:278` and `:408`, which is the shared resolver. I
did not find 12S-specific documentation of the column, so the chapter states
the resolver's behaviour rather than any dialog-side help text.

## For the gate

- `brand_reviewed` and `lead_approved` both left `false`. The gate flips them.
- Seven shot markers still need capturing. The fixture is now published, so a
  Screenshot Scout can reach every one of them from
  `docs/user-manual/fixtures/primate-12s/` without rebuilding anything from a
  scratchpad, which was the fidelity reviewer's main worry.
- `twelve-s-unresolved-clusters` will show 56 single-read clusters. Honest, but
  a thin picture, and the author flagged the same thing.
- The fidelity reviewer's registry correction still stands.
  `parameters.yaml` lists three chimera states for
  `Run vsearch chimera review` and there are four. I did not edit the registry,
  since it is not mine to edit. The chapter names all four.
- The fidelity reviewer asked for `Analyses/12S amplicon results/` to be added
  to CONSISTENCY.md as a third `Analyses/` shape. Not mine to edit either. The
  chapter states the path in step 4.
- One `GLOSSARY.md` edit was made under an explicit ruling, the `soft-clip`
  entry described above. No other glossary entry was touched.
- The dialog's Overview section and its **Open Previous Run...** button remain
  undocumented, as the fidelity reviewer noted. I left this alone, since adding
  it is a structural call rather than an editorial one.
