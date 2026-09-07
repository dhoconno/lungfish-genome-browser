# Author report, 04-alignments/03-primer-trimming

Chapter 24 of the campaign roster. Registry id `bam.primer-trim`, fixture
`sarscov2-srr36291587`. Rewritten in place on 2026-09-07.

Lint result, verbatim.

```
docs/user-manual/chapters/04-alignments/03-primer-trimming.md: no issues found
```

## Which fixture the worked example uses, and why

The example uses the SRR36291587 SARS-CoV-2 reads, the fixture the roster
assigns.

The task brief said to check for the reads before falling back to
`sarscov2-clinical`. The fixture directory itself holds no reads and has no
`cache` subfolder, and the regenerate script writes to `./fixture-tmp`, which
does not exist anywhere on this machine. But the reads are present as a
by-product of the manual's own demo-project build, at
`/Users/dho/Desktop/lge-docs/LGE Manual Demo.build/_scratch/sra/SRR36291587_1.fastq`
and `_2.fastq`, 55.8 MB each. I copied both out into the scratch directory
and never wrote back into `~/Desktop/lge-docs`.

The fallback would have been wrong here in any case. `sarscov2-clinical` is
mapped to MT192765.1, and all eight bundled primer schemes name only
`MN908947.3` (canonical) and `NC_045512.2` (equivalent), so a trim against
that fixture would have needed `--target-reference` to resolve at all and
would have exercised the failure path rather than the normal one. It is also
shotgun-shaped nf-core test data, about 100 read pairs, so no primer scheme
matches its reads.

The chapter states in one sentence, in `## What it is`, that it is the
manual's one alignment-level primer-trimming example and uses viral data
because every bundled scheme is a SARS-CoV-2 scheme and no human amplicon
fixture exists. The biology around it is kept general and points the reader
at the read-level chapter for non-viral work.

## Runs I made

All runs used `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
against copies under
`.../scratchpad/primer-trim/`. Counts came from
`~/.lungfish/conda/envs/samtools/bin/samtools` and a small CIGAR-summing
script written in the same scratch directory.

**Run 1, bundle create.** `bundle create --fasta MN908947.3.fasta --name
MN908947.3 --compress`. Produced `MN908947.3.lungfishref`.

**Run 2, mapping.** `map SRR36291587_1.fastq SRR36291587_2.fastq --reference
MN908947.3.fasta --paired --preset sr --sample-name SRR36291587`. Reported
172,562 total reads, 171,355 mapped (99.30%), 1,207 unmapped, 8.1 s runtime.

**Run 3, adopt.** `bam adopt-mapping ... --name "minimap2 mapping"`. Track
id `aln_FB68A1C3`.

**Baseline counts on the untrimmed track.**

| Measure | Value |
|---|---|
| records in BAM (flagstat total) | 172,562 |
| primary mapped reads | 169,191 |
| reads carrying any soft clip | 131,813 |
| soft-clipped bases | 4,003,827 |
| matched (M/=/X) bases | 38,461,970 |
| soft-clip share of all bases in mapped reads | 9.43% |

**Run 4, the chapter's trim.** `bam primer-trim --bundle MN908947.3.lungfishref
--alignment-track aln_FB68A1C3 --scheme <QIASeqDIRECT-SARS2.lungfishprimers>
--name "minimap2 mapping • Primer-trimmed (QIAseq Direct SARS-CoV-2 with
Booster A)"`. Succeeded. Wrote
`alignments/primer-trimmed/aln_BC7DDF67.bam`, its `.bai`, a
`.primer-trim-provenance.json`, and a `.stats.db`. Wall time recorded in the
sidecar was 7.28 s, which I deliberately did not put in the chapter, since
the campaign forbids unsourced durations and a single machine's timing is
not a manual-grade figure.

**Counts on the trimmed track.**

| Measure | Value |
|---|---|
| records in BAM (flagstat total) | 164,704 |
| primary mapped reads | 163,278 |
| reads carrying any soft clip | 163,273 |
| soft-clipped bases | 10,641,749 |
| matched bases | 30,340,659 |
| soft-clip share of all bases in mapped reads | 25.97% |

iVar's own summary, taken verbatim from the `stderr` field of the provenance
sidecar and quoted in the chapter.

```
Trimmed primers from 99.15% (169906) of reads.
3.88% (6651) of reads were quality trimmed below the minimum length of 30 bp and were not written to file.
0.79% (1360) of reads started outside of primer regions. Since the -e flag was given, these reads were written to file.
1207 unmapped reads were not written to file.
```

**Run 5, the name-collision check.** Same command with `--name "minimap2
mapping"`. Refused, verbatim, with
`An alignment track named 'minimap2 mapping' already exists in this bundle.`
This confirms the DRIFT "missing" row about collision refusal.

**Run 6, the wrong-scheme demonstration.** Same source track, but
`--scheme ARTIC-nCoV-2019-V3.lungfishprimers`. It completed with **no error
and no warning**, producing `aln_5E8FE507`. Its iVar summary reported
`Trimmed primers from 22.13% (37921) of reads.` and `76.14% (130463) of reads
started outside of primer regions.`, and soft-clipping reached only 13.44% of
bases. This run is the evidence behind the chapter's `## What good looks
like` section, and it is the strongest single teaching point in the chapter,
because it shows the reader that a wrong scheme is silent and the trim rate
in the log is the only check.

## How each DRIFT row was settled

### The three unverifiable rows

**Row 32, "the operation log should report a non-trivial trim rate, typically
15% to 30% of bases soft-clipped."** Settled by run 4 and confirmed by run 6.
The claim conflated two different things. There *is* a trim rate, but it is a
percentage **of reads**, printed by iVar itself, not a percentage of bases,
and it is not produced by LGE's own pipeline output at all. `BAMPrimerTrimResult`
carries only URLs and the provenance struct. The old "15% to 30%" range is
wrong twice over. As a share of reads the correct figure is 99.15%, and as a
share of bases the correct figure is 25.97%, which lands inside the old range
by coincidence rather than by measurement. The chapter now gives both numbers
with what each measures, and uses the read percentage as the check, because
that is the number iVar actually prints.

**Row 33, "LoFreq does not honour soft-clipping the same way and will pull
some primer bases back into its pileups."** The prerequisite the DRIFT row
asked me to check came back positive. LoFreq 2.1.5 does ship, at
`third-party-tools-lock.json:36`, in the `variant-calling` pack. But shipping
is all I could confirm. The behavioural claim about LoFreq re-reading clipped
bases is a statement about a third-party tool that I did not test and that no
source in this repository asserts. **I removed it.** Repeating an untested
tool-behaviour claim is exactly the kind of drift this campaign exists to
remove, and the chapter loses nothing, because the positive advice (carry the
trimmed track into iVar, and check the acknowledgement is ticked) survives on
its own evidence.

**Row 17, "Requires Variant Calling Pack", carried as false.** The DRIFT
verdict is itself wrong and I reinstated the string. The literal does not
appear in `Sources/` because it is interpolated.
`BAMPrimerTrimCatalog.swift:29` returns `"Requires \(pack.name) Pack"`, and
`PluginPack.swift:565-566` gives the pack id `variant-calling` the name
`Variant Calling`. The rendered string is therefore exactly "Requires Variant
Calling Pack". The chapter quotes it.

### False rows

Row 6 and row 9, the scheme count. Corrected. The chapter says eight built-in
schemes and no longer claims ARTIC, Midnight, and VarSkip need importing. It
does not reproduce the seven-row table of counts from the DRIFT missing list,
because the reader picks a scheme by protocol name rather than by primer
count, and a table of eight rows of numbers no reader acts on is noise. The
chapter instead tells them the menu groups schemes under Built-in and In This
Project, and that the correct scheme is whichever one the wet-lab protocol
used.

Row 23, the Operations Panel row label. Corrected to
`Primer-trimming with QIAseq Direct SARS-CoV-2 with Booster A`, per
`InspectorViewController+TrimDuplicateWorkflows.swift:128`.

### Changed rows

Row 7. The picker shows the bare display name under a Built-in section
heading, per `PrimerSchemePickerView.swift:20-33`. No "(Built-in)" suffix.
Corrected.

Row 12. The chapter now says all eight bundled schemes name both accessions,
so the coordinate-mismatch trap bites imported schemes hardest.

Row 13. Verified against source. The primer-scheme importer is **not** a
`File > Import Center > Primer Scheme` submenu path. It is a card titled
"Primer Scheme" on the Import Center's **References** tab
(`ImportCenterViewModel.swift:591-598`), and there is no menu item for it
anywhere in `MainMenu.swift`. The chapter says so.

Row 14. Verified against `PrimerSchemeImportService.swift:116-124`, `:150`,
`:293`, `:307-310`. The file set is exactly `manifest.json`, `primers.bed`,
an optional `primers.fasta`, and `PROVENANCE.md`, plus an `attachments/`
folder when attachments are given. Kept as written.

Row 15. Copied verbatim from `cli-help/primers.txt`. The old example was
materially misleading. `--fasta` is documented as "Optional primer FASTA to
copy into the bundle", **not** a reference genome, and the old chapter passed
`--fasta <ref>`. `--output` and `--bed` are required, `--project` places the
result under `Primer Schemes/`. The chapter's example uses the real flags and
adds a sentence warning that `--fasta` is a primer FASTA and is optional.

Row 18. Corrected to the Analysis section's Primer Trim tab, and the chapter
explains why the button is invisible before you click the tab.

Row 21. Settled by reading `PrimerSchemePickerView.swift`. The picker shows
**no accession and no amplicon count**. It renders a menu of display names
and, beside the Choose Scheme... button, a caption repeating the selected
display name. The old chapter's "the dialog reports the scheme's reference
(MN908947.3) and amplicon count (223) below the picker" is fiction and is
gone. The chapter now says the caption repeats the name you picked and tells
the reader to confirm the reference by another route.

Row 30. Settled by reading `BAMPrimerTrimProvenance.swift` and the sidecar
from run 4. It records three `StepExecution` entries (`ivar trim`, `samtools
sort`, `samtools index`), the iVar version (1.4.4 on this run), the scheme's
manifest name, source, version, and canonical accession, resolved options,
and `FileRecord` entries carrying a `sha256` for the source BAM, its index,
and the scheme's `primers.bed`. So the old "two checksums" claim was roughly
right and is now stated precisely, and the chapter notes the command sits
behind a **Show command** button.

Row 31. Quoted verbatim from `BAMVariantCallingToolPanes.swift:98`. The string
is "This BAM has already been primer-trimmed for iVar." The chapter also
records that when provenance is found the toggle is forced on and disabled,
with a caption beneath giving the date and scheme name
(`BAMVariantCallingDialogState.swift:81-82`, `ToolPanes.swift:103`).

### Missing features now covered

Eight built-in schemes and their grouping in the menu. The **Output Track
Name** field and its collision refusal. The dialog's own retained-reads note.
The **Choose Scheme...** browse affordance (note the real label is "Choose
Scheme…", not "Browse..." as the DRIFT row said). The bundle-level operation
lock and its "Operation in Progress" alert. The pinned iVar version 1.4.4 and
the `variant-calling` pack. The per-control help popovers. The "Primer Trim
Failed" and readiness alerts. `--format json`.

## What I removed from the old chapter, and why

The `## Primer schemes` H2 and its one-row table. The table asserted a single
built-in scheme, which was the chapter's biggest factual error, and a table
listing eight schemes by primer count is not something a reader acts on. The
material moved into prose in `## What it is` and `## What good looks like`.

The "dozen or more phantoms in an ARTIC v3 BAM" figure. Invented. Nothing in
this repository or in my runs supports a specific count. Replaced with the
mechanism, which is what the reader needs, and with a real measured
demonstration of the wrong-scheme failure.

The "typically under a minute for a SARS-CoV-2 BAM" duration. Unsourced, and
the campaign forbids it.

The LoFreq warning, discussed above.

The `--scheme "Primer Schemes/QIASeqDIRECT-SARS2.lungfishprimers"` framing
that implied a built-in scheme lives in the project folder. Built-in schemes
live inside the app bundle. The chapter's CLI block keeps the project-relative
form because that is the path a reader will actually have after importing,
and the surrounding prose no longer claims the built-ins are project files.

The old `## What you will learn` section, which is not in the campaign
template, and the old `## Equivalent CLI` and `## Interpretation` headings,
which are replaced by the template's `## On the command line` and
`## Reading the results`.

## Template conformance

Sections in template order. What it is, Why you would do this, Before you
start (opening with the two fixed CONSISTENCY sentences, adjusted for this
fixture), Procedure, Settings, Reading the results, What good looks like, On
the command line, Next.

Seven Settings paragraphs, one per setting in `parameters.yaml` under
`bam.primer-trim`, each in the fixed three-sentence shape with the registry
label verbatim inside the bold and the period inside the bold. `settings-coverage.js`
passes. The two CLI-only flags (`--target-reference`, `--format`) are covered
in `## On the command line` rather than as Settings paragraphs, since they are
not dialog controls.

The Procedure is split into two H3 subsections so no list exceeds the
five-item cap.

## Shot markers

Three, each with a `shots` entry. The old front matter carried `shots: []`
with two `planned_shots`, so these are now real markers.

| Marker | Caption |
|---|---|
| `primer-trim-scheme-menu` | The Primer Trim dialog with the Primer Scheme menu open, showing the eight schemes under the Built-in heading. |
| `primer-trim-dialog-target` | The Primer Trim dialog's Target section, showing the Alignment Track menu, the pre-filled Output Track Name field, and the note that reads without matching primers are retained. |
| `primer-trim-track-result` | The sidebar after the run, showing the new track named minimap2 mapping, a bullet, Primer-trimmed, and the scheme name in parentheses. |

The DRIFT screenshot table asked for the scheme menu to be captured open so
the eight built-ins are visible, and for the result caption to use the real
name shape rather than a bare `(Primer-trimmed)` suffix. Both are done. I
split the old single dialog shot into two, because the scheme menu open and
the Target section cannot both be legible in one frame. The Screenshot Scout
should note that `primer-trim-track-result` needs "Show soft-clipped
sequence" turned on if the clipped ends are to render.

## Glossary additions

Three new entries, alphabetised in the existing shape.

- **BED**{#bed}, in section B before Benchmark VCF.
- **iVar**{#ivar}, in section I after IQ-TREE.
- **Alignment track**{#alignment-track} was **not** added. It already existed
  and my first draft duplicated it. I removed the duplicate and left the
  original wording untouched.

One correction to an existing entry. **Primer scheme**{#primer-scheme}
asserted that a `.lungfishprimers` bundle "carries the BED coordinates, the
primer sequences in FASTA, and provenance". That is wrong for every scheme a
reader will meet. None of the eight bundled schemes contains a
`primers.fasta`, only `manifest.json`, `primers.bed`, and `PROVENANCE.md`.
The FASTA is optional and only present when an importer supplied one. The
entry now says so and names the manifest.

## Possible app defects

**A wrong primer scheme trims silently.** Run 6 applied the ARTIC V3 scheme to
a QIAseq library and completed with exit 0, no warning in the log, no banner
in the UI, and a new adopted track that looks in every way like a successful
result. Three quarters of reads matched no primer. The information needed to
catch this is already computed, because iVar prints
`76.14% (130463) of reads started outside of primer regions` in its own
stderr, and LGE captures that stderr into the provenance sidecar. Nothing
surfaces it. A warning when the "started outside of primer regions" fraction
exceeds some threshold, or simply promoting iVar's four summary lines into
the operation row's detail text, would catch a whole class of quiet analysis
errors. I would rate this the most valuable small change in this operation.

**The scheme picker shows nothing about the selected scheme.**
`PrimerSchemePickerView` renders a menu of display names and a caption that
repeats the display name already visible in the menu. It has the
`PrimerSchemeBundle` in hand, so the canonical accession, the primer count,
and the amplicon count are all available and none is shown. The old chapter
described a detail line showing the accession and amplicon count, which
suggests either it once existed or the author assumed it should. It would
make the reference-mismatch check the chapter has to describe in prose into
something the reader can just look at.

**The chapter cannot tell the reader how to confirm the scheme's reference in
the GUI**, as a direct consequence of the above. The only route is opening
the `.lungfishprimers` folder in Finder and reading `manifest.json`. I wrote
around this rather than inventing a UI affordance.
