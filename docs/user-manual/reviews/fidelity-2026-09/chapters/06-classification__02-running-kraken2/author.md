# Author report, 06-classification/02-running-kraken2

Chapter 33 of the 2026-09 fidelity campaign. Rewritten in place against Preview
2026.9.13, the Swift sources, `parameters.yaml`, and four live CLI runs made on
2026-09-07.

## Runs made

Every run used `.build/debug/lungfish-cli` against copies of
`SRR36291587_1.fastq` and `SRR36291587_2.fastq` taken out of the demo project
build's SRA scratch folder and written into
`scratchpad/kraken2/`. Nothing was written back into `~/Desktop/lge-docs`.
Both files are 251 bp reads, 85,199 read pairs on disk (the fixture README
records 86,281 pairs for the archived run, so the demo build's copy is
slightly smaller and every count in the chapter is quoted from the copy that
was actually classified). Tool versions were Kraken 2 2.17.1 and Bracken 3.0.1.

### Databases available

`lungfish-cli conda db install-managed --list` prints only the three managed
helper datasets (`human-scrubber`, `deacon-panhuman`, `deacon-ribokmers`), not
classification databases, so the catalog came from `conda db list` and from
`~/.lungfish/databases/metagenomics-db-registry.json`. Three databases are
installed and ready on this machine.

| Name | Status | Size | Version |
|---|---|---|---|
| Viral | ready | 0.5 GB | 20260626 |
| Standard-16 | ready | 16 GB | 20260626 |
| SILVA | ready | 12 GB | kraken2-special-v1 |

The smallest installed standard collection is **Standard-16**, and that is the
one the chapter's broad-database comparison uses. Viral is the primary
worked-example database because the fixture is a viral amplicon library.

### Run 1, Viral, balanced (the chapter's main example)

```
conda classify reads/SRR36291587_1.fastq reads/SRR36291587_2.fastq \
  --paired --db Viral --profile -o run-viral
```

Exit 0, runtime 2.6 s. Total 85,199. Classified 83,728 (98.27%).
Unclassified 1,471 (1.73%). Species 1. Kreport rows quoted in the chapter's
first results table, read directly from `run-viral/classification.kreport`.

| Taxon | Rank | Reads | Direct | Percent |
|---|---|---|---|---|
| Viruses | R1 | 83,728 | 65 | 98.27 |
| Coronaviridae | F | 83,663 | 0 | 98.20 |
| Betacoronavirus | G | 83,662 | 0 | 98.20 |
| Betacoronavirus pandemicum | S | 83,645 | 54 | 98.18 |
| SARS-CoV-2 | S1 | 83,591 | 83,591 | 98.11 |

Bracken reported 83,645 for *Betacoronavirus pandemicum*, identical to the
Kraken 2 clade count, which is why the chapter says the two agree only when one
species dominates.

### Run 2, Standard-16, balanced (the comparison)

Exit 0, runtime 11.3 s. Classified 3,320 (3.90%). Unclassified 81,879 (96.10%).
SARS-CoV-2 direct count 2,602. Species 1. No human taxon appeared at all,
despite Standard-16 containing the human genome, which the chapter explains as
the amplicon protocol having diluted the host background rather than as a
defect.

### Run 3, Viral, precise

Exit 0. Classified 78,731 (92.41%). Unclassified 6,468 (7.59%). Species 1.

### Run 4, Viral, sensitive

Exit 0. Classified 85,181 (99.98%). Unclassified 18 (0.02%). Species 5. The
four extra species are *Sinsheimervirus phiX174* (5 reads), *Vibrio* phage
ValB1MD-2 (2 reads), Frog adenovirus 1 (1 read), and Changjiang picorna-like
virus 6 (1 read). This is the chapter's worked illustration of what the
Sensitivity preset actually trades, with phiX identified as a genuine Illumina
spike-in and the other three as chance k-mer matches.

### Run 5, extraction

`conda extract` warns that it is deprecated in favour of
`extract reads --by-classifier --tool kraken2`. The recommended form was run
and is the one the chapter documents.

```
extract reads --by-classifier --tool kraken2 \
  --result run-viral --taxon 2697049 \
  --source reads/SRR36291587_1.fastq --output sars-reads.fastq
```

Extracted 83,591 read pairs, written as 167,182 read records. Note that
`--result` takes the run's output **directory**, not the `.kraken` file. Passing
the file produced "No reads could be extracted", so the chapter's example passes
the directory.

### Run 6, the exit-64 case

Confirmed. Classifying the same reads against SILVA exits **64** with
`Error: Workflow execution failed: Empty Kraken2 report`. This is reported as an
app defect below, because the report was not empty.

## What was removed from the old chapter, and why

The old chapter was substantially fiction. The following came out.

**The tool label.** "Classify & Profile (Kraken2)" appears nowhere in the
source. Replaced with "Kraken2" and its description "Classify reads
taxonomically" (DRIFT false 1).

**The menu path.** `Tools > FASTQ/FASTA Operations > Classification…` and the
assertion "It is one menu item, not a submenu" were both wrong. Replaced with
`Tools > Classification > Kraken2...`, with the note that FASTQ/FASTA
Operations is the dialog title (DRIFT false 17). The **Classifier** picker does
not exist either, so the instruction to choose Kraken2 in it went with it
(DRIFT false 18).

**The whole database table.** The old table had a Custom row for a
user-built database, which the closed nine-collection catalog has no case for,
and it gave the Viral RAM figure as 1 GB against the source's 0.5 GB (DRIFT
false 12, changed 6). Rather than restate a corrected table, the chapter now
defers the catalog to `01-foundations/07-plugin-packs.md`, which owns it and
already carries a live-checked version. That also removes the duplicated RAM
and memory-mapping discussion. The chapter keeps only what it needs, which is
the idea of a capped database and the consequence of picking a small one.

**The result location.** "a `SRR36291587.kraken2.viral.lungfishtax` bundle
appears in the sidebar" and "The result lands as a taxonomy bundle" were both
wrong. Replaced with `Analyses/kraken2-<timestamp>/` per CONSISTENCY.md and
DRIFT false 33 and changed 3.

**The Operations Panel row title.** `Kraken2: <bundle>` replaced with
`Classifying <file name>` and `Classification Batch (N samples)` (DRIFT false
32).

**"a million reads against the Viral database finish in seconds on a laptop"**
and "it downloads in under a minute on a typical home connection" and "A few
hundred thousand reads against the Viral database take under a minute". All
three were unsourced durations. The chapter now quotes only the two runtimes it
measured (2.6 s and 11.3 s), with an explicit caveat that both were warm-cache
runs.

**The extraction destination.** "a new virtual FASTQ bundle into the project"
replaced with the top-level `Extractions` folder (DRIFT changed 38).

**`build-db kraken2` as a database builder.** Reworded to say it indexes an
existing result and that LGE offers no route to build a Kraken 2 classification
database (DRIFT changed 63). The old chapter called it "the power-user route
when you need a custom database the Plugin Manager does not offer", which was
the same error as the Custom table row.

**The wastewater framing.** The old chapter called the fixture "a SARS-CoV-2
wastewater FASTQ" and built its interpretation section around wastewater host
load. The fixture README says QIAseq Direct amplicon from a clinical run, and
the campaign roster names it a human clinical swab amplicon run, so the framing
was rewritten around a clinical amplicon specimen and its consequences for what
the classifier does and does not see.

**`{{ fixtures_refs[] | cite }}`.** Removed, per STYLE.md, which states there is
no citation macro.

Smaller corrections applied without further comment: **Min hit groups** is a
stepper with range 1 to 10 rather than a field (changed 22); the section is
**Advanced Settings** (changed 27); the dataset line replaces the "Input FASTQ
field" (changed 28); the table's real columns are Sample, Taxon Name, Rank,
Reads, Direct, Bracken, and % (changed 34).

## How each DRIFT unverifiable row was settled

DRIFT records two unverifiable rows for this chapter.

**Row 5, "35 bases by default in Kraken2".** The ground-truth map notes that
Kraken 2's own k default is not set or surfaced anywhere in the LGE source and
that settling it needs the upstream Kraken 2 manual. Settled by **removal**. The
chapter no longer quotes a k value at all. It explains what a k-mer and a
minimizer are, says Kraken 2 matches on minimizers, and leaves the numeric
parameter out, since the number is a property of the upstream tool that LGE
neither sets nor displays and the reader cannot act on it.

**Row 48, "The table's top row is usually unclassified".** The map says row
ordering depends on the parsed kreport and needs a real run to settle. Settled
by **run**. In all four of my kreports the unclassified row is the first line of
the file, but the viewport's table is sortable and column-filterable, so "the
top row" is a claim about a default sort I did not verify in the GUI. The
chapter therefore drops the positional claim and instead states the fact that
matters, which is that unclassified is a count you must read, giving the
measured values (1.73% for Viral, 96.10% for Standard-16) and making the
unclassified share the first check in What good looks like.

## Shot markers

Six markers, six front-matter entries, all captions written to the corrected
surfaces.

| id | Where it sits | Note |
|---|---|---|
| `kraken2-databases-tab` | End of Procedure step 1 | Replaces the old `kraken2-plugin-manager`, recaptioned to the Databases tab with its recommendation banner, which is the surface the chapter now describes. |
| `kraken2-dialog` | Procedure step 2, after the Database picker | Replaces `kraken2-wizard`. Recaptioned to name the FASTQ/FASTA Operations dialog rather than a Classification wizard, per the DRIFT screenshot row. |
| `kraken2-advanced-settings` | Procedure step 2, at the settings paragraph | New. The chapter documents five Advanced Settings controls and none of the old planned shots showed them. |
| `kraken2-taxonomy-viewport` | End of Procedure step 3 | Caption now names the Filter taxa... field and the Bracken column, both of which the DRIFT missing table flagged and the chapter now covers. |
| `kraken2-extract-reads` | Procedure step 4 | Recaptioned from "Extract Reads as FASTQ Bundle" to **Extract Reads...**, which is the real menu item, and the caption now names the two Copy items beneath it. |
| `kraken2-drilldown-coronaviridae` | Reading the results, Moving around the tree | Kept, moved out of the procedure into the results section where the drill-down is taught. |

## Glossary additions

Five terms added to `GLOSSARY.md` in the existing entry shape, alphabetised,
and listed in `glossary_refs`.

- **Bracken** (`#bracken`), between Bootstrap and Branch length.
- **Capped database** (`#capped-database`), before CIGAR.
- **Clade count** (`#clade-count`), between Clade and Cladogram.
- **Kreport** (`#kreport`), after Kraken 2 at the end of the K section.
- **Spike-in control** (`#spike-in-control`), between Sparkline and SRA.

All other `glossary_refs` entries resolved to existing anchors.

## Possible app defects found

**1. An all-unclassified Kraken 2 run fails with a misleading error and exit
64.** Classifying the SRR36291587 reads against the SILVA database exits 64 with
`Error: Workflow execution failed: Empty Kraken2 report`. The report is not
empty. `run-silva/classification.kreport` contains one well-formed line.

```
100.00	85199	85199	0	0	U	0	unclassified
```

`KreportParser.swift:39` maps `.emptyReport` to that string, and a report whose
only row is the unclassified row apparently trips it (or trips
`.missingRootNode`, whose message would at least have been accurate). Two
problems follow. The message misdescribes the file, sending a reader to look for
a truncated write that did not happen. And a legitimate scientific result, which
is that this database matched nothing in this sample, is presented as a workflow
failure rather than as a report reading 100% unclassified. The equivalent GUI
path is worth checking, since a user picking the wrong database will see a
failure alert rather than a result telling them why. The chapter documents the
behaviour as it stands and tells the reader what it means, but the honest fix is
for the parser to accept a report whose only row is `U`.

**2. `conda extract` is deprecated but still the entry point named in
`parameters.yaml`.** Running `conda extract` prints a deprecation warning
directing the user to `extract reads --by-classifier --tool kraken2`, yet
`classify.extract-reads-by-taxon` in `parameters.yaml` still lists
`CLI: lungfish-cli conda extract ...` as its entry point and still documents
`--taxid`, `--kraken-output`, `--kreport`, `--include-children`, and
`--no-read-pairs` as its `cli_only` flags. Those flags belong to the deprecated
command. The chapter documents the recommended form, so the registry entry and
the chapter now disagree on the command name. This is a registry maintenance
item rather than an app bug, but it should be reconciled before the appendix
CLI reference is written.

**3. `extract reads --by-classifier --result` misreports a wrong argument type.**
Passing the `.kraken` file rather than the run's result directory produces
`Error: No reads could be extracted: 1 sample(s) were skipped because their
classification output or source FASTQ could not be located (sample).` and exits
1. The exit code is right, but the message points at a missing file when the
real problem is that the option wanted a directory and was handed a file. A
message naming the expected argument type would save the reader the guess. Minor
compared with defect 1, and noted only because the chapter had to work it out by
trial.
