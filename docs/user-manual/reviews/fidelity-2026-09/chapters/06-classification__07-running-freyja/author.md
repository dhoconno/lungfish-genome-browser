# Author report, 06-classification/07-running-freyja

Chapter 38 of the campaign roster. Registry id `workflow.freyja-demix`.
Fixture `sarscov2-srr36291587`. Rewritten in place against Preview 2026.9.13
on 2026-09-07.

## Runs made

Freyja can run on this machine, so the worked example is a real run rather
than a reconstruction from help text. The `wastewater-surveillance` pack is
installed at `~/.lungfish/conda/envs/freyja`, `freyja --version` reports
`freyja, version 2.0.3`, and the bundled lineage barcode data is present at
`~/.lungfish/conda/envs/freyja/lib/python3.1/site-packages/freyja/data/`
with `usher_barcodes.feather` (4.9 MB) and `last_barcode_update.txt`
reading `03_22_2026-00-48`.

All work was done under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/freyja/`
on copies. Nothing under `~/Desktop/lge-docs` was touched, nothing in the
repository outside `docs/user-manual/` was modified, and no build was run.

### Run 1, inputs

The primer-trimmed BAM from the chapter 24 scratch
(`MN908947.3.lungfishref/alignments/primer-trimmed/aln_5E8FE507.bam`) and
`MN908947.3.fasta` were copied into the scratch directory. Freyja's own
`freyja variants` produced the two input tables.

```
freyja variants srr36291587.trimmed.bam \
    --variants srr36291587.variants.tsv \
    --depths srr36291587.depths.tsv \
    --ref MN908947.3.fasta
```

Counts. Variants table 16,779 data rows (1,465,197 bytes). Depths table
29,903 rows (685,276 bytes), exactly the length of `MN908947.3`. Wall time
11.7 s.

One PATH trap worth recording for the Screenshot Scout and for Phase 5.
Running `freyja variants` without prepending
`~/.lungfish/conda/envs/freyja/bin` to `PATH` fails silently in the useful
sense. Freyja shells out to `samtools mpileup | ivar variants`, the shell
reports `ivar: command not found`, freyja exits 0 anyway, and both output
files are created with the depths table populated and the variants table
absent. This is Freyja's behaviour, not LGE's, and LGE does not wrap
`freyja variants` at all, so the chapter documents the command and leaves
the environment to the reader.

### Run 2, dry run

```
lungfish-cli freyja demix --dry-run \
    --variants .../srr36291587.variants.tsv \
    --depths .../srr36291587.depths.tsv \
    --output-dir demix-dry --sample SRR36291587
```

Printed the composed Freyja command line and `Command plan: .../demix-dry/freyja-command-plan.json`.
Directory contents afterwards, two files. `freyja-command-plan.json` (2,452
bytes) and `.lungfish-provenance.json` (3,923 bytes). No `freyja-demix.tsv`.

### Run 3, execute

```
lungfish-cli freyja demix --execute \
    --variants .../srr36291587.variants.tsv \
    --depths .../srr36291587.depths.tsv \
    --output-dir demix-run --sample SRR36291587
```

Printed the composed command line then `Freyja demix complete.` Exit code 0
in the sidecar, wall time 16.743734002113342 s. Three files written,
`freyja-demix.tsv` (500 bytes), `freyja-command-plan.json` (2,452 bytes),
`.lungfish-provenance.json` (3,922 bytes).

The result, verbatim.

```
	.../srr36291587.variants.tsv
summarized	[('Omicron', 0.9885371959826457)]
lineages	BQ.1 BE.1.1.1 BQ.1.19 BQ.1.31 BQ.1.8.1 BQ.1.17 BA.5.1.11 BQ.1.1.59 BQ.1.21 BQ.1.16 BA.5.3.2 BA.5.3.3
abundances	0.62326010 0.34613150 0.00468872 0.00359143 0.00190295 0.00150844 0.00145548 0.00132447 0.00123930 0.00121142 0.00113320 0.00109019
resid	12.28623928020283
coverage	99.50506638129953
```

Twelve lineages. Top two 0.62326010 and 0.34613150, summing to 0.9693916.
Remaining ten summing to 0.0191456. All twelve summing to 0.9885372, which
equals the `summarized` Omicron figure to seven decimal places because every
reported lineage is an Omicron descendant. Residual 12.29, coverage 99.51
percent. Every number in the chapter's Reading the results section comes
from this run.

### Run 4, both flags

```
lungfish-cli freyja demix --execute --dry-run ... --output-dir demix-both ...
```

Settles DRIFT row 13 by observation. Two files only, no `freyja-demix.tsv`,
and the sidecar records `"execute": {"type": "string", "value": "false"}`.
Freyja did not run.

### Run 5, neither flag

Same command with neither `--execute` nor `--dry-run`, output dir
`demix-default`. Wrote the plan and the sidecar, no result table. Not
executing is the default, which the chapter states in the **Dry run.**
settings paragraph.

### Run 6, extra args

`--extra-args "--eps 0.01"` with no execute. The composed command line ends
`... --output .../demix-extra/freyja-demix.tsv --eps 0.01`, confirming that
pass-through arguments are appended after LGE's own `--output` rather than
merged into it.

## DRIFT rows settled

Part A listed one changed row, three unverifiable rows, and three missing
features. Each is settled below.

### Changed row 7

Old text claimed Freyja stays off "the FASTQ/FASTA Operations menu because
that menu is reserved for direct data operations." Replaced with the
corrected wording from the reality map, in the Procedure lead paragraph.
Freyja is not a FASTQ or FASTA operation, so it never appears in the Tools
category submenus, and those cover operations that read a FASTQ or FASTA
directly while Freyja consumes variant and depth tables instead.

### Unverifiable row 13, `--dry-run` beats `--execute`

Settled true, two ways. Source, `FreyjaCommand.swift` gates the tool call on
`if execute && !dryRun`. Run 4 above confirms it empirically, including the
`execute: false` value written into provenance. The chapter states it as a
behaviour to expect, with the observed directory contents behind it.

### Unverifiable row 14, output file name

Settled true. `FreyjaDemixPlan.swift` composes
`configuration.outputDirectory.appendingPathComponent("freyja-demix.tsv")`
and passes it as Freyja's `--output`. Run 3 produced exactly that file at
500 bytes. The chapter names the file in the Procedure, in the results
table, and in the command-line block.

### Unverifiable row 16, provenance fields

Settled by reading a real sidecar rather than by trusting the old chapter's
list, and the old list was partly wrong. What the sidecar actually holds is
the workflow name `lungfish freyja demix`, the app version
`lungfish-cli 2026.9.13`, the host OS `macOS 26.6.2 (arm64)`, the user, a
run UUID, start and end timestamps in ISO 8601, status `completed`, and one
step carrying the LGE command line as an argv array, exit code, wall time,
and input and output file records. The parameters block holds `packID`,
`execute`, `sampleName`, `runtime` (the conda env path), `containerRuntime`
(`none`), `options`, and `resolvedDefaults`.

The pinned tool version `2.0.3` and the composed Freyja command are in
`freyja-command-plan.json` rather than in the sidecar, so the old chapter's
sentence attributing "the tool version" and "the exact command" to the
sidecar was conflating the two files. The rewrite splits them, saying which
file holds what.

Checksums are the other correction. The old chapter said the sidecar records
"checksums and file sizes when the files exist." Both input tables carry
`sha256` and `sizeBytes`, and so does `freyja-command-plan.json`, but
`freyja-demix.tsv` carries neither even though it exists on disk after a
successful run. See the defect section below. The chapter states this
limitation plainly at the end of Reading the results.

Stderr is not recorded on a successful run. The sidecar has no `stderr` key
at all here, because `writeCommandPlanProvenance` defaults it to nil and
`FreyjaCommand` never passes one. The old chapter's claim that the sidecar
records "stderr when execution turns up useful diagnostic text" is not
supported by the successful run, so the rewrite drops it rather than
restating it.

### Missing feature, pack is experimental

Added to Before you start. `PluginPack.swift:838` sets `isExperimental: true`.
The chapter says the card is marked Experimental and, because the campaign
reader is an undergraduate, explains what the marking means, which is that
the pack has had less testing inside LGE rather than that Freyja is
unfinished.

The CONSISTENCY.md fixed sentence for experimental features
("Turn on **Show Experimental Features** in **Settings > Advanced**") was
deliberately NOT used. That sentence is about a feature hidden behind the
experimental-features toggle. The Wastewater Surveillance pack is visible in
the Plugin Manager without any toggle and merely carries an `isExperimental`
badge, so quoting the fixed sentence would send the reader to a preference
that has no bearing on finding the pack.

### Missing feature, the pack ships five tools

Added to Before you start. `PluginPack.swift:836` lists
`["freyja", "ivar", "pangolin", "nextclade", "minimap2"]`. The chapter names
all five and says what each is for, which also explains to the reader why a
pack for one tool is a large download.

### Missing feature, handler with no menu item

Added to the Procedure lead. `MainMenu.swift:1172` declares
`showFreyjaDemix` in the actions protocol and
`AppDelegate+ToolsMenu.swift:146-148` implements it by opening the Plugin
Manager at the pack, but no `NSMenuItem` targets that selector. The chapter
states that there is no menu item, that the handler exists and only opens
the Plugin Manager, and therefore that the Plugin Manager is the whole of
LGE's graphical surface for Freyja.

## What was removed from the old chapter and why

The old chapter had non-template sections `What you will learn`, `Inputs`,
`GUI path`, `CLI path`, and `Provenance`, and no `Why you would do this`,
`Before you start`, `Settings`, `Reading the results`, `What good looks
like`, or `Next`. The whole file was restructured to the template order.
Beyond the structure, these specific things went.

The `--sample sample-001` framing implied the identifier reaches Freyja. It
does not. `FreyjaDemixPlan.swift` carries a comment saying Freyja 2.0.3 has
no `--sample` option and aborts when given one, the composed command in run
3 contains no `--sample`, and the identifier appears only in the plan's
`options` and in the sidecar. The **Sample.** settings paragraph now says
this explicitly, because a reader who assumed otherwise would misread the
provenance.

The sentence "Advanced Freyja arguments pass through with `--extra-args`"
survived as a settings paragraph but gained the two things it was missing,
which are that arguments are appended after LGE's own `--output` and that
they are unchecked, so a misspelling is refused by Freyja rather than by LGE.
The old example `--eps 1e-6` was replaced with `--eps 0.01`, because 0.01 is
above Freyja's documented default of 0.001 and therefore actually changes
the output, while 1e-6 is below the default and produces no visible effect
on this fixture. Freyja's own `demix --help` gives the default.

The provenance field list was rewritten from a real sidecar, as described
above, dropping the stderr claim and moving the tool version and the exact
Freyja command to the plan file where they actually live.

The old chapter never said what the output means. It named
`freyja-demix.tsv` and stopped. The entire Reading the results section is
new, and it is where most of the added length went, because the result file
has an unusual shape (five labelled lines, with lineage names and abundances
on two parallel lines) that no reader would guess.

The old chapter never mentioned the barcode file, which is the single input
most likely to make a run wrong without producing an error.

## Fixture honesty

The task required saying plainly that a single clinical sample is not
wastewater. This is stated twice. Once at the end of Why you would do this,
saying the run demonstrates the mechanics on a single clinical sample and
that a real wastewater sample gives a broader mixture, and once in Reading
the results, where the 62 percent and 35 percent split is interpreted as
probably one true lineage with a close relative absorbing part of the signal
rather than as two genuine infections. BQ.1 and BE.1.1.1 are both Omicron
descendants, which is why they are hard to separate, and that generalises
into a rule the reader can apply.

No duration is quoted for the reader's own machine anywhere. The two
durations that appear (11.7 s for `freyja variants`, 16.7 s for the demix)
are both labelled as the recorded run and the chapter says the time depends
on table size and barcode size.

## Shot markers

One marker, `plugin-manager-wastewater-pack`, in Before you start, with a
matching `shots` entry in the front matter. Caption names the Experimental
marking and the five tools, which are the two things the surrounding prose
asks the reader to look for.

The reality map judged the old empty `shots` list "correct as it stands" but
then said a Plugin Manager shot scoped to this pack "would help, since the
chapter tells the reader to find that pack by name." The rewrite takes that
suggestion, because the pack is now the chapter's only GUI step and the
Experimental badge is a visual detail the prose asserts.

No other marker was added. Every remaining surface in this chapter is a
terminal, and the campaign does not shoot terminals.

## Glossary additions

Five terms, all in the existing entry shape, all alphabetised, all listed in
`glossary_refs`.

- **Demixing** `{#demixing}`, placed before Depth.
- **Lineage barcode** `{#lineage-barcode}`, placed after Lineage.
- **Residual** `{#residual}`, placed before Ribosomal RNA.
- **Sublineage** `{#sublineage}`, placed before Subsampling.
- **Wastewater Surveillance pack** `{#wastewater-surveillance}`, placed
  before Workflow lineage.

The existing Freyja and Lineage entries were left untouched. Linting
`GLOSSARY.md` shows the five new lines carry only the "See also:" colon
warning that every pre-existing entry in the file already carries, and none
of them carries a semicolon warning.

## Possible app defects found

**1. The demix result carries no checksum or size in the plan or the
sidecar.** `FreyjaDemixPlan.swift` builds the output `FileRecord` for
`freyja-demix.tsv` at plan-construction time, before Freyja has run, so
`ProvenanceRecorder.fileRecord` finds no file and records only the path,
format, and role. `FreyjaCommand.executeForTesting` then reuses
`plan.outputs` verbatim when it writes provenance after the run, so the
record is never refreshed. The consequence is that a Freyja run's provenance
proves which inputs went in but cannot prove which result came out, which is
the one thing a reproducibility record is for. Both input tables and the
plan file do carry `sha256` and `sizeBytes`, so the machinery works and only
this one record misses it. Confirmed in run 3's sidecar. Documented in the
chapter as a limitation rather than hidden.

**2. Successful runs record no stderr.** Minor and possibly intended.
`writeCommandPlanProvenance` accepts a `stderr` parameter defaulting to nil
and `FreyjaCommand` never passes one, so even a run that produced solver
warnings would leave no trace of them. On the failure path the stderr goes
into the thrown `CLIError` instead, so it reaches the user but not the
sidecar.

**3. `freyja variants` fails silently without the pack env on PATH.** Not an
LGE defect, since LGE does not wrap that subcommand, but it is the most
likely way a reader following this chapter gets a wrong answer with no error
to explain it. Worth considering whether LGE should wrap `freyja variants`
the way it wraps `freyja demix`, which would remove the reader's only
unmanaged step. Flagged for the Documentation Lead rather than fixed here.

## Phase 5

Nothing is outstanding on counts. Freyja ran, so every number and every
quoted output line in the chapter comes from a run recorded above. Phase 5
needs only the one screenshot, `plugin-manager-wastewater-pack`.

## Lint

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/06-classification/07-running-freyja.md: no issues found
```

Clean on the first run under `LUNGFISH_MANUAL_STRICT=1`. Zero em dashes,
zero semicolons, zero in-sentence colons, nine H2 sections in template order,
seven Settings paragraphs, one shot marker paired with its front-matter entry.
