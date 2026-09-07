# Phase 6 cross-chapter sweep

Date: 2026-09-07. Every item below applies one of the rulings in
`CONSISTENCY.md`. Each edited chapter was re-linted with
`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <file>`
and every `brand_reviewed: true` / `lead_approved: true` flag was left as it stood.

`docs/user-manual/chapters/appendices/troubleshooting.md` and
`docs/user-manual/GLOSSARY.md` were not touched, because another agent holds them.

## Item 1. Download ZIP sentence

Ruling: CONSISTENCY.md, "Before you start, fixed sentences", the folder-fixture
paragraph.

`grep -rln 'tree/main/docs/user-manual/fixtures' docs/user-manual/chapters` returned
46 chapters. Each was read in context and sorted into three groups.

**Already correct, carrying the fixed sentence verbatim (7).** No edit needed.

- `chapters/07-assembly/02-running-spades.md`
- `chapters/07-assembly/03-running-flye-or-hifiasm.md`
- `chapters/07-assembly/04-extracting-contigs.md`
- `chapters/06-classification/09-novel-virus-detection.md`
- `chapters/06-classification/10-twelve-s-metabarcoding.md`
- `chapters/06-human-germline-variants/04-reference-packs.md`
- `chapters/08-workflows/01-the-workflow-builder.md`

**Correctly out of scope (38).** These chapters name individual files rather than a
folder and send the reader to click a filename and then the Download raw file button,
which is what a single-file fixture needs. None tells the reader to download from the
tree link itself. The demo-project chapters
(`01-foundations/06`, `01-foundations/08`, `08-workflows/02`, `appendices/ai-assistant`,
`appendices/shared-projects`) carry the separate fixed build-instructions form and stay
as they are.

**Corrected (1).** `docs/user-manual/chapters/03-reads/07-ont-runs.md` asked the reader
to download a folder and gave a hand-rebuild workaround instead of the fixed sentence.

Before:

> and remember where you saved it. GitHub offers no way to download a folder, so you download the one file it holds and rebuild the folders around it by hand. On the GitHub page, click into each folder in turn, then click the filename and the Download raw file button. Then make three nested folders on your disk, an outer `ont-run`, a `fastq_pass` inside it, and a `barcode01` inside that, and put the downloaded file in the innermost one so that the path reads

After:

> and remember where you saved it. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`. The `ont-run` folder sits inside `hg002-long-reads`, already carrying the nested folders the importer needs, so the path reads

The replacement claim was checked against the committed fixture. `find
docs/user-manual/fixtures/hg002-long-reads/ont-run` returns
`ont-run/fastq_pass/barcode01/HG002_chrM_pass_barcode01_0.fastq.gz`, so the ZIP does
carry the nested folders and the hand-rebuild step is unnecessary.

Lint: `03-reads/07-ont-runs.md: no issues found`.

## Item 2. Shortcut spelling

Ruling: CONSISTENCY.md, "Shortcut spelling".

`grep -rn 'Cmd-Ctrl' docs/user-manual/chapters` returned no hits, so the
`Cmd-Ctrl-` to `Ctrl-Cmd-` half of the sweep had nothing to apply.
`grep -rn 'Cmd-Option' docs/user-manual/chapters` returned 8 hits across 7 files, all
of them `Cmd-Option-I` or `Cmd-Option-G`. Every one became `Cmd-Opt-`.

| File | Line | Before | After |
|---|---|---|---|
| `chapters/02-sequences/04-aligning-sequences.md` | 122 | `**View > Show Inspector** (Cmd-Option-I)` | `**View > Show Inspector** (Cmd-Opt-I)` |
| `chapters/02-sequences/01-importing-and-viewing.md` | 14 (front matter) | `Sequence > Go to Gene... (Cmd-Option-G)` | `Sequence > Go to Gene... (Cmd-Opt-G)` |
| `chapters/02-sequences/01-importing-and-viewing.md` | 150 | `**Sequence > Go to Gene...** (Cmd-Option-G)` | `**Sequence > Go to Gene...** (Cmd-Opt-G)` |
| `chapters/04-alignments/02-reading-an-alignment.md` | 90 | `**Sequence > Go to Gene...** (Cmd-Option-G)` | `**Sequence > Go to Gene...** (Cmd-Opt-G)` |
| `chapters/04-alignments/04-alignment-quality.md` | 72 | `**View > Show Inspector** (Cmd-Option-I)` | `**View > Show Inspector** (Cmd-Opt-I)` |
| `chapters/05-variants/05-consensus-and-lineage.md` | 56 | `**View > Show Inspector** (Cmd-Option-I)` | `**View > Show Inspector** (Cmd-Opt-I)` |
| `chapters/06-classification/05-running-nao-mgs.md` | 126 | `**View > Show Inspector** (Cmd-Option-I)` | `**View > Show Inspector** (Cmd-Opt-I)` |
| `chapters/06-classification/09-novel-virus-detection.md` | 201 | `**View > Show Inspector** (Cmd-Option-I)` | `**View > Show Inspector** (Cmd-Opt-I)` |

Post-sweep `grep -rn 'Cmd-Option\|Cmd-Ctrl' docs/user-manual/chapters` returns nothing.

Lint, all seven: `no issues found`.

## Item 3. Chapter 52, the `--expected-output` sidecar

Ruling: the chapter 58 finding, that a bundle output carries its sidecar inside the
bundle rather than beside it.

File: `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`.

Before (line 168):

> Separately, and this is the part that matters most, each path you named with `--expected-output` receives its own `.lungfish-provenance.json` sidecar written beside it once the run succeeds.

After:

> Separately, and this is the part that matters most, each path you named with `--expected-output` receives its own `.lungfish-provenance.json` sidecar once the run succeeds, written beside the output when it is a plain file and inside it at the bundle root when the output is a bundle, as both examples here are.

Before (line 176):

> Look for the paths you named with `--expected-output` and confirm each has a `.lungfish-provenance.json` beside it.

After:

> Look for the paths you named with `--expected-output` and confirm each has a `.lungfish-provenance.json`, at the bundle root for a bundle output and beside the file otherwise.

Lint: `08-workflows/03-running-external-workflows.md: no issues found`.

## Item 4. Chapter 50, the Deacon human index

Ruling: CONSISTENCY.md, "Exit statuses and the Deacon indexes". Both Deacon indexes
are Required Setup managed data and install with the app. The Plugin Manager's
Databases tab still lists only the Kraken 2 catalogue.

File: `docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md`, Before you
start. The fixed opener two paragraphs above was left untouched.

Before:

> Deacon also needs its human index, and that one you install yourself. An index is a prepared, searchable copy of a genome, built ahead of time so a program can check a read against the whole human genome in a moment rather than in an hour. The Plugin Manager's Databases tab does not list it, because that tab carries only the classifier databases, so the command line is the only route. Open the Terminal application from the Applications folder under Utilities, or by pressing Cmd-space and typing its name, and type this one line.
>
> ```bash
> lungfish-cli conda db install-managed deacon-panhuman
> ```
>
> The download runs once and takes a few minutes. To check whether it is already there, run `lungfish-cli conda db install-managed --list`, which prints the managed databases and marks the ones already installed. The Plugin Manager shows the same fact a second way. Open it with **Tools > Plugin Manager...** (Cmd-Shift-B) and look inside the Required Setup pack for the row named **Human Read Removal Data**, which reads **Ready** once the index is installed and **Needs download** before that.

After:

> Deacon also needs its human index, and that one is already there. An index is a prepared, searchable copy of a genome, built ahead of time so a program can check a read against the whole human genome in a moment rather than in an hour. It belongs to the Required Setup pack that installs with the app, so nothing is left for you to fetch.
>
> To confirm it, open the Terminal application from the Applications folder under Utilities, or by pressing Cmd-space and typing its name, and type this one line.
>
> ```bash
> lungfish-cli conda db install-managed --list
> ```
>
> That prints the managed databases and marks the ones already installed, and `deacon-panhuman` is among them. The Plugin Manager shows the same fact a second way. Open it with **Tools > Plugin Manager...** (Cmd-Shift-B) and look inside the Required Setup pack for the row named **Human Read Removal Data**, which reads **Ready**. The Databases tab does not list the index, because that tab carries only the Kraken 2 catalogue.

Lint: `08-workflows/01-the-workflow-builder.md: no issues found`.

## Item 5. Exit statuses in chapters 58 and 57

Ruling: CONSISTENCY.md, "Exit statuses and the Deacon indexes". 2 is a usage error,
64 is a workflow error, and 64 is the status behind the missing expected output
refusal, the empty Kraken 2 report, and `provenance verify` on an unsigned record.
Confirmed at source: `Sources/LungfishCLI/LungfishCLI.swift:154`, `case workflowError = 64`.

### `chapters/appendices/06-running-in-ci.md`

Before (line 128):

> That refusal exited 64, and `--quiet` did not suppress it, which is the behaviour a CI job wants.

After:

> That refusal exited 64, the workflow-error status, and `--quiet` did not suppress it, which is the behaviour a CI job wants.

Before (table, no row for 2):

> | 3 | A pack id was not recognised. The step fails and nothing was installed. |
> | 10 | `tools update --plan` found pending work. The step fails, which is what makes it an assertion. |
> | 64 | A usage refusal, such as a run with no `--expected-output` or a `provenance verify` on an unsigned record. The step fails before any work happened. |

After:

> | 2 | A usage error, such as a misspelled flag or a missing argument. The step fails before any work happened. |
> | 3 | A pack id was not recognised. The step fails and nothing was installed. |
> | 10 | `tools update --plan` found pending work. The step fails, which is what makes it an assertion. |
> | 64 | A workflow error, such as a run with no `--expected-output`, an empty Kraken 2 report, or a `provenance verify` on an unsigned record. The step fails. |

Lines 397 and 416 already read as bare statements of fact ("it exited 64", "The run
exits 64 saying an expected output is required") and needed no change.

Lint: `appendices/06-running-in-ci.md: no issues found`.

### `chapters/appendices/cli-reference.md`

Every mention of 64 and 2 was checked. Two called 64 a usage error.

Before (line 195):

> A bare `lungfish-cli import <path>` fails with a usage error naming the missing subcommand and exits 64, so name the format you are importing rather than the file alone.

After:

> A bare `lungfish-cli import <path>` fails with a message naming the missing subcommand and exits 64, the workflow-error status rather than the usage-error status 2, so name the format you are importing rather than the file alone.

Before (line 426):

> The input is a flag rather than a positional, so a bare path fails with `Specify exactly one of --assembly or --contigs` and an exit status of 64. The two usage errors in this section report 64 and 3 because they are raised at different layers of the program, and neither number tells you anything the message beside it does not.

After:

> The input is a flag rather than a positional, so a bare path fails with `Specify exactly one of --assembly or --contigs` and an exit status of 64, which is the workflow-error status rather than the usage-error status 2. The two refusals in this section report 64 and 3 because they are raised at different layers of the program, and neither number tells you anything the message beside it does not.

Line 735, the empty Kraken 2 report row of the troubleshooting table, already gives 64
and needed no change, and it is now the row the CONSISTENCY ruling names.

Lint: `appendices/cli-reference.md: no issues found`.

## Item 6. Foundations chapter 06, lock recovery

Ruling: the opening dialog offers Recover and Open when the lock is not held by a
live local process and the record is readable or corrupted, as
`chapters/appendices/shared-projects.md` documents at lines 43 and 65.

File: `docs/user-manual/chapters/01-foundations/06-the-lungfish-project.md`, line 127.

Before:

> The window has no button for this yet, so a stale lock is cleared from the command line.

After:

> The dialog LGE shows on opening offers a **Recover and Open** button that does this for you whenever the lock is not held by a live local process and the record is either readable or corrupted, and [Sharing a Project Between People](../appendices/shared-projects.md) walks through the confirmation it raises. The command line clears one as well.

Lint: `01-foundations/06-the-lungfish-project.md: no issues found`.

## Item 7. Foundations chapter 08, the provenance export promise

Ruling: chapter 51 (`08-workflows/02-exporting-as-nextflow-or-snakemake.md`, lines 51
and 61) found that neither emitted workflow validates in this release and that the
runnable targets are transcriptions to edit.

File: `docs/user-manual/chapters/01-foundations/08-provenance-and-reproducibility.md`,
the **Provenance.** settings paragraph.

Before:

> Nextflow and Snakemake are pipeline systems a bioinformatics collaborator may already run, so those two targets suit a handover to someone with a computational setup of their own. There is no default, because you pick a target from the submenu rather than accept one, and the first four sit above a separator as the runnable group while the last two are the read-only group. Pick the target that matches what the reader needs, a runnable pipeline for a collaborator, a methods draft for a manuscript, or the raw JSON for an auditor.

After:

> Nextflow and Snakemake are pipeline systems a bioinformatics collaborator may already run, so those two targets suit a handover to someone with a computational setup of their own. Neither emitted workflow passes its own engine's validity check in this release, so treat those two as accurate transcriptions a collaborator edits into a working pipeline rather than as pipelines that run unchanged, which [Exporting a Run as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md) covers in full. There is no default, because you pick a target from the submenu rather than accept one, and the first four sit above a separator as the runnable group while the last two are the read-only group. Pick the target that matches what the reader needs, a transcription for a collaborator to run, a methods draft for a manuscript, or the raw JSON for an auditor.

Lint: `01-foundations/08-provenance-and-reproducibility.md: no issues found`.

## Item 8. `fixtures/hg002-chr20/README.md` read count

**Not applied, because it was already correct.** The README no longer holds the
stale numbers the item quotes. Its Downsampling section reads:

> The resulting read set is 45,574 read pairs (91,148 reads, 182,296 lines per file) after downsampling and BAM-to-FASTQ singleton filtering.

which is what the committed files hold. Verified independently: `gzcat` on each of
`HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and `_R2.fastq.gz` gives 182,296 lines, so
45,574 records each and 91,148 in total.

`grep -rn '45,614\|45614' docs/ README.md` now returns hits only inside this campaign's
own review notes, which record the historic discrepancy and are correct to keep it.
The one surviving 91,203 in the fixture README is the `samtools flagstat` record count,
correctly attributed:

> `samtools flagstat` reports 91,203 records in total because 55 reads also carry a supplementary alignment.

The fixture owner appears to have applied the correction that
`chapters/01-foundations__02-sequencing-reads/fidelity.md:119` assigned to them.
No edit made.

## Item 9. Root `README.md`, the assembly view

File: `README.md`, line 75.

Before:

> The assembly view pairs a contig table and Nx plot with the ordinary sequence viewer, and selected contigs can be extracted for mapping or annotation.

After:

> The assembly view pairs a contig table, a summary strip, and a detail pane with the ordinary sequence viewer, and selected contigs can be extracted for mapping or annotation.

## Item 10. `features.yaml` AI assistant, and the ground-truth MainMenu citation

### `docs/user-manual/features.yaml`, the `ai.assistant` entry

The chapter 59 fidelity review (`chapters/appendices__ai-assistant/fidelity.md`, row 23)
found that the floating `NSPanel` in `AIAssistantPanel.swift` lives in
`AIAssistantWindowController`, which is constructed nowhere in `Sources/` and only in a
test. The live surface is the Inspector's **Assistant** tab, built at
`InspectorView.swift:86-88` (`EmbeddedAIAssistantView`), labelled at `:233`, with the
service held at `InspectorViewModel.swift:175`.

Before:

```yaml
  ai.assistant:
    title: AI assistant panel
    ...
    sources:
      - Sources/LungfishApp/Views/AI/AIAssistantPanel.swift
      - Sources/LungfishApp/Services/AI/AIAssistantService.swift
```

After:

```yaml
  ai.assistant:
    title: AI Assistant
    ...
    sources:
      - Sources/LungfishApp/Views/Inspector/InspectorView.swift
      - Sources/LungfishApp/Views/Inspector/InspectorViewModel.swift
      - Sources/LungfishApp/Services/AI/AIAssistantService.swift
```

### `reviews/fidelity-2026-09/ground-truth/appendices.md`

Seventy bare `` `MainMenu.swift `` citations were qualified to
`` `Sources/LungfishApp/App/MainMenu.swift ``. The Sources-consulted list at line 6
already carried the full path and was left as it was, and no double prefix was
introduced (`grep -c 'App/Sources/'` returns 0). Example:

Before (line 496):

> | 9 | "Show or Hide Sidebar \| Cmd-Ctrl-S" | true | `MainMenu.swift:436-442`, ...

After:

> | 9 | "Show or Hide Sidebar \| Cmd-Ctrl-S" | true | `Sources/LungfishApp/App/MainMenu.swift:436-442`, ...

This file is a review artefact rather than a chapter, so no lint applies to it. Its
own quoted chapter strings, such as the `Cmd-Ctrl-S` row above, are records of what a
chapter said at review time and were deliberately not swept by item 2.

## Item 11. The `variants.gatk-plans` registry entry

Ledger items: the entry indexes subcommands rather than per-plan flags, and it lacks
`--preset custom` and the lenient parses (recorded in
`chapters/06-human-germline-variants__02-joint-genotyping/fable-gate.md:11` and
`chapters/06-human-germline-variants__03-filtering-selecting-and-metrics/fable-gate.md:11`).

File: `docs/user-manual/parameters.yaml`, `variants.gatk-plans`, `cli_only`.

The three chapters read were
`chapters/06-human-germline-variants/02-joint-genotyping.md` (Settings, lines 141-176),
`chapters/06-human-germline-variants/03-filtering-selecting-and-metrics.md` (Settings,
lines 214-262), and `chapters/06-human-germline-variants/04-reference-packs.md`
(the `bqsr` procedure and its entry point at line 14).

The list went from 13 entries, of which 10 were bare subcommand names, to 33 entries.
Every subcommand row is kept, and each flag those chapters document now has its own row.

Rows added: `--reference`, `--output`, `--gvcf`, `--intermediate`,
`--combine-strategy`, `--preset`, `--sample`, `--type`, `--intervals`, `--fields`,
`--known-sites`, `--recal-table`, `--create-output-bam-index`,
`--split-multi-allelics`, `--max-indel-length`, `--max-leading-bases`,
`--output-prefix`, `--dbsnp`, `--sequence-dictionary`, `--gvcf-input`.

The three ledger gaps are now recorded.

`--preset custom`, before: the `filter` row listed only three values.

> effect: Builds a VariantFiltration command that flags calls failing a preset, with --preset set to best-practices-snp, best-practices-indel, or best-practices-both.

After, as its own row:

> - flag: --preset
>   default: best-practices-both
>   effect: Chooses which published list of hard filter tests the filter applies, accepting best-practices-snp, best-practices-indel, best-practices-both, and custom. The custom value is unfinished rather than a working option. It applies no filter expressions at all, so the command copies the file and marks nothing, and there is no companion flag for supplying your own tests.

The `--combine-strategy` lenient parse, before: recorded only inside the
`joint-genotype` prose as "set to auto, combine-gvcfs, or genomicsdb". After:

> effect: Chooses which GATK tool gathers the GVCFs, accepting auto, combine-gvcfs, or genomicsdb. Under auto a cohort of 50 samples or fewer uses CombineGVCFs and a larger one uses GenomicsDB. An unrecognised value is parsed leniently, falling back to auto with no warning, so a typo such as genomics-db quietly runs the automatic choice.

The `--type` lenient parse, before: absent. After:

> effect: Restricts the output to one class of variant, accepting SNP, INDEL, and MIXED. The value is parsed leniently, so an unrecognised class is not rejected and no restriction is applied. Empty keeps every class.

Two further chapter facts were folded into `notes`, the three fixed GATK options on
`joint-genotype` that have no flag (the 30.0 calling-confidence threshold,
`-G AS_StandardAnnotation`, and each step's working directory), and a note that
`markdup` and `validate-sam` are covered by no chapter.

Validator: `node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml` prints `parameters ok`.

## Item 12. Glossary item for the project manager, not applied

`docs/user-manual/GLOSSARY.md` is held by another agent, so this is recorded rather
than edited. Line 17 currently reads:

> **AI assistant**{#ai-assistant}. An in-app chat panel that answers questions about the active dataset and suggests workflows through a bring-your-own-key AI provider; it interprets and explains but does not modify your project.

Two problems. The semicolon breaks the manual campaign's no-semicolons rule and needs
splitting into two sentences. Separately, "chat panel" is the wording the chapter 59
fidelity review corrected. The assistant is the Inspector's **Assistant** tab, not a
panel or a separate window, so the entry should say so when it is rewritten. A
suggested replacement:

> **AI assistant**{#ai-assistant}. A chat surface in the Inspector's Assistant tab that answers questions about the active dataset and suggests workflows through a bring-your-own-key AI provider. It interprets and explains, and it does not modify your project.

Two neighbouring entries, **API access** at line 19 and **API key** at line 21, both
cross-reference "AI assistant" and stay correct under that rewrite.

## Lint and link results

Every chapter edited was linted with `LUNGFISH_MANUAL_STRICT=1`. All returned
`no issues found`.

| File | Result |
|---|---|
| `chapters/03-reads/07-ont-runs.md` | no issues found |
| `chapters/02-sequences/04-aligning-sequences.md` | no issues found |
| `chapters/02-sequences/01-importing-and-viewing.md` | no issues found |
| `chapters/04-alignments/02-reading-an-alignment.md` | no issues found |
| `chapters/04-alignments/04-alignment-quality.md` | no issues found |
| `chapters/05-variants/05-consensus-and-lineage.md` | no issues found |
| `chapters/06-classification/05-running-nao-mgs.md` | no issues found |
| `chapters/06-classification/09-novel-virus-detection.md` | no issues found |
| `chapters/08-workflows/03-running-external-workflows.md` | no issues found |
| `chapters/08-workflows/01-the-workflow-builder.md` | no issues found |
| `chapters/appendices/06-running-in-ci.md` | no issues found |
| `chapters/appendices/cli-reference.md` | no issues found |
| `chapters/01-foundations/06-the-lungfish-project.md` | no issues found |
| `chapters/01-foundations/08-provenance-and-reproducibility.md` | no issues found |

`node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml`
prints `parameters ok`.

`node docs/user-manual/build/scripts/campaign/check-links.mjs docs/user-manual` reports
5 broken links, all of them pre-existing and none in a file this sweep touched.

```
ARCHITECTURE.md:109 ../GLOSSARY.md#amplicon
chapters/01-foundations/07-plugin-packs.md:176 ../appendices/troubleshooting.md#plugin-packs-and-conda-environments
chapters/02-sequences/01-importing-and-viewing.md:134 ../../assets/illustrations-imagegen/02-sequences/01-importing-and-viewing/viewport-lanes.png
chapters/02-sequences/03-extracting-and-comparing.md:188 ../../assets/illustrations-imagegen/02-sequences/03-extracting-and-comparing/extraction-header-anatomy.png
index.md:12 pdf/lungfish-user-manual.pdf
```

Three are missing assets that the screenshot and illustration passes will supply. One
is a heading anchor in `troubleshooting.md`, which another agent holds and which this
sweep was told not to edit. One is the built PDF, which does not exist until the manual
is built. The two links this sweep added, from `01-foundations/06` to
`appendices/shared-projects.md` and from `01-foundations/08` to
`08-workflows/02-exporting-as-nextflow-or-snakemake.md`, both resolve and neither
appears in the report.

## Files changed

- `docs/user-manual/chapters/03-reads/07-ont-runs.md`
- `docs/user-manual/chapters/02-sequences/04-aligning-sequences.md`
- `docs/user-manual/chapters/02-sequences/01-importing-and-viewing.md`
- `docs/user-manual/chapters/04-alignments/02-reading-an-alignment.md`
- `docs/user-manual/chapters/04-alignments/04-alignment-quality.md`
- `docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md`
- `docs/user-manual/chapters/06-classification/05-running-nao-mgs.md`
- `docs/user-manual/chapters/06-classification/09-novel-virus-detection.md`
- `docs/user-manual/chapters/08-workflows/03-running-external-workflows.md`
- `docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md`
- `docs/user-manual/chapters/appendices/06-running-in-ci.md`
- `docs/user-manual/chapters/appendices/cli-reference.md`
- `docs/user-manual/chapters/01-foundations/06-the-lungfish-project.md`
- `docs/user-manual/chapters/01-foundations/08-provenance-and-reproducibility.md`
- `docs/user-manual/features.yaml`
- `docs/user-manual/parameters.yaml`
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/appendices.md`
- `README.md`
- `docs/user-manual/reviews/fidelity-2026-09/phase6-sweep.md` (this record)

Not changed: `docs/user-manual/fixtures/hg002-chr20/README.md` (item 8, already
correct), `docs/user-manual/GLOSSARY.md` and
`docs/user-manual/chapters/appendices/troubleshooting.md` (held by another agent).
