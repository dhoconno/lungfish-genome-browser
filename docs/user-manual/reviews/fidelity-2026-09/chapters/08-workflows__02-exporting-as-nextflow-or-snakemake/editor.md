# Editor record: 08-workflows/02-exporting-as-nextflow-or-snakemake

Date: 2026-09-07. Roster row 51, registry id `provenance.export`.
Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` prints "no issues found",
green on the first run after the rewrite and again after the final edit.

Counts. 3 of 3 false rows fixed, 41 of 41 consensus rows applied, 55 of the
remaining 55 reader rows applied, 5 Notes-for-the-editor items applied, all
14 project-manager rulings applied.

## The three false rows

**Params block (fidelity line 36).** The four-line quote is replaced with the
complete eight-line block copied verbatim from the emitted
`out-nextflow/main.nf`, including the duplicated `params.hg002_sorted_bam`.
A sentence after the block says the first three lines are inputs and the next
four are intermediate files, and names the duplicate as the defect covered
below rather than a copying mistake. Verified against the scratch export.

**Snakemake version (fidelity line 78).** "The reference checks in the
previous section used those pinned versions" is replaced. The chapter now says
the Nextflow check ran on the pinned 26.04.6, the Snakemake check ran on
Snakemake 8.26.0 because that was the copy installed on the test machine, and
the cyclic-graph result is worth reconfirming on 9.25.2.

**Command-line opener (fidelity line 83).** The CONSISTENCY fixed paragraph is
kept with the "nothing here unlocks" clause dropped, per the ruling, and a
sentence added naming the three command-line-only things (scripting an export,
the bibliography, and verify). The two paragraphs that follow now read
consistently with it.

## Notes items and defect corrections

Defect 3's site count is now four, not three, and the fourth site (the
workflow block's channel declarations) is folded into the plain-language
sentence rather than counted at the reader. Verified: `main.nf` params,
`main.nf` workflow channels, `config.yaml`, and `reproduce.py` INPUTS, the
last of which I confirmed silently drops the first copy.

Defect 2 is reworded to attribute the duplication to the emitter rather than
the record. The new sentence says the exporter gives the `samtools flagstat`
step the same BAM as input and output, that flagstat writes its report to the
screen rather than to disk, and that Snakemake refuses to schedule a step
waiting on itself.

The new defect 5 is disclosed. The `verify` paragraph now says the command
exits with a failing status on an unsigned record, and the defect list carries
it as a one-sentence entry.

## Rulings

Honesty. The What it is section carries one plain sentence saying neither
emitted workflow passed its own engine's check. The defects now live under a
findable H3, **Known defects in this release**, which the "reported below"
promise points at by name. Each defect is one reader-facing sentence with no
file paths or line numbers.

Command line. Every terminal instruction a window-only reader was told to
perform has moved into the last section, which now holds the two validation
commands, `-resume`, and the executable-bit sentence. What good looks like
gained a window-only second check (open the export in a text editor, confirm
tool versions and file names, with a pointer to where the versions sit in each
of the six targets) and names the terminal checks as optional.

Terminal onboarding. One paragraph at the first terminal instruction says
where Terminal is, that Spotlight finds it, that commands run from the folder
holding the export, and where `lungfish-cli` comes from.

Glosses at first use, all applied: Nextflow and Snakemake as workflow engines,
cluster, command line, viewport, minimap2, samtools, BAM, `.lungfishref`,
conda environment, JSON, SHA-256 tied back to checksum, signature and public
key and signer with what signing proves, container and image digest together,
`publishDir` and `params.outdir` in one clause each, `set -euo pipefail`, the
angle-bracket convention, DOI, subcommand, rule, Singularity, the backslash
continuation, `./`, executable bit, requested specification versus resolved
lock, shell script, plate-free plain wording for auditor (a journal reviewer
checking your analysis), sanitizing (replaced with a plain statement of the
transformation plus advice to read the file), the Python Script row, the
walks-the-chain-backwards sentence, and the byte-copy replay qualifier.

Numbers. The five processes are stated as one per recorded command, so the
count follows the run. Only the one error stops a run and the eleven warnings
are advisory, and ten of the eleven are named as the same defect surfacing a
second way, which the author record and the fidelity review both support. The
version pins are described as what this release ships and tested against, with
older and newer engines untested. The real username in the conda path is
replaced with `/Users/.../.lungfish/conda` and a sentence says the three dots
stand for the account name and the reader's own export shows their own.

Demo project. The Before you start section now carries the published fixture
route (the GitHub demo-project instructions and the `~/Desktop/lge-docs/`
path, matching the two committed Foundations chapters) and says any finished
run in the reader's own project works the same way, reached through the
sidebar's `Analyses` folder.

`--from-lockfile`. Cut. The paragraph now states in plain words that the file
records which packages were asked for rather than which builds were installed,
so it cannot rebuild the identical environment.

Also applied: a worked `--config` override using a real key from the emitted
`config.yaml`, the Desktop as a concrete export location, the double negative
rewritten as "if a file of that same name already sits in the folder you
chose", and the Provenance setting reworded as naming the selected record's
rendering target with no control to set.

## Left for the gate

`brand_reviewed` and `lead_approved` are both still false. I did not flip them.

The four planned shots are still uncaptured, and the two-levels-deep reader
row (row 98) was fixed in prose only, so the submenu screenshot still needs to
land before step 2's dividing-line sentence, which reader row 49 asks for.

Reader row 15 asked for the `.lungfishref` mention to be glossed or dropped. I
glossed it. If the Documentation Lead prefers it dropped, that is a one-line
cut.

Cross-chapter items from the fidelity review are untouched by me and belong to
others. The `methods-export` glossary entry is stale, and the committed
Foundations provenance chapter promises a re-runnable export in a way this
chapter now contradicts.

## Facts I could not source

Reader row 29 asked for the oldest Nextflow and Snakemake versions that still
work. No source states one, so the chapter says instead that the shipped
versions are what this release was tested against and that older and newer
engines were not tested.

Reader row 31 asked whether the Workflow Builder's export shares these
defects. Nothing tested it. The Next section now says the defects belong to
this chapter's exporter, that the Builder's was not tested here, and that the
reader should check its output the same way.

`GLOSSARY.md` has no `json` or `cluster` entry and the glossary is not mine to
edit, so both terms are glossed inline in prose with no link, and
`glossary_refs` is unchanged.
