# Author record, appendices/troubleshooting.md

Chapter rewritten in place against Preview 2026.9.13. Roster row 67, no
registry ids, no fixture, last chapter of the roster.

## Shape

Reorganised from category-first to symptom-first, as briefed. The appendix now
opens with the Operations Panel failure-report instruction (the memory rule
that a failed GUI run is debugged from the failed row, never by reconstructing
the command), then holds six symptom tables with columns Symptom, What it
means, What to do, Chapter, plus four prose sections for the diagnostic
commands, integrity checks, and bug reporting.

Symptom table entries: 28 across six tables.

- Nothing happens when I choose a menu item: 3
- I cannot write to my project: 4
- A run stopped and I do not know why: 5
- A command refused me: 6
- The run finished but the result is not what I expected: 5
- Tools, databases, containers, integrity: covered in prose, 5 further
  symptoms named there (conda lock waiting, conda root read-only, proxy hang,
  container not ready, provenance verify on an unsigned record)

Of the 28 table entries, 21 come from the campaign's gate files. The remaining
7 come from the DRIFT Missing table and from CLI help.

## Quoted messages, with the source line for each

Every string printed in quotes or code font was grepped in `Sources/` first.

| Quoted text | Source |
|---|---|
| `(not enabled)` | `Sources/LungfishApp/App/MainMenu.swift:832` |
| `Show Experimental Features` | `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift:16` |
| `AI Assistant Disabled` | `Sources/LungfishApp/App/AppDelegate+MenuActions.swift:503` |
| ` (Read Only)` window-title suffix | `Sources/LungfishApp/App/AppDelegate.swift:673` (also `:609`) |
| `Project opened read-only` banner title | `Sources/LungfishApp/App/ProjectLockWarningPresentation.swift:18` |
| lock banner detail naming user, host, pid | `ProjectLockWarningPresentation.swift:28-30` |
| corrupted / unreadable lock metadata detail | `ProjectLockWarningPresentation.swift:35-44` |
| `Project Is Open Read Only` alert title | `Sources/LungfishApp/App/ProjectWriteGatePresenter.swift:22` |
| alert body, close the other writer or reopen | `ProjectWriteGatePresenter.swift:53` |
| `waiting for conda lock held by pid <n>` | `Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift:95` |
| `conda root is read-only; reinstall as the admin user` | `CondaRootMutationLock.swift:12` |
| `Empty Kraken2 report` | `Sources/LungfishIO/Formats/Kraken/KreportParser.swift:39` |
| provenance publication artifact wording | `Sources/LungfishWorkflow/Provenance/ProvenancePublicationSnapshot.swift:23`, `:26`, `:28` |
| genotyping "outside the result bundle" | `Sources/LungfishWorkflow/ONTGenotyping/GenotypeReviewableRowCatalogPublisher.swift:55` (also `AmpliconGenotypeScientificArtifactPublisher.swift:26`) |
| `At least two input FASTQ bundles are required for genotype-cohort.` | `Sources/LungfishCLI/Commands/FastqGenotypingSubcommand.swift:470` |
| VCFv3 refusal and the bcftools/vcftools remedy | `Sources/LungfishIO/Formats/VCF/VCFReader.swift:826` |
| `Input and output must be different files; in-place, symlink and hard-link aliases are rejected.` | `Sources/LungfishCLI/Commands/ConvertCommand.swift:19` |
| BigWig / BigBed "detection only; in-process reader unavailable" | `Sources/LungfishIO/Registry/FormatRegistry+BuiltInDescriptors.swift:193`, `:210` |
| failure-report directory `~/Library/Logs/<app>/Operations/Failures` | `Sources/LungfishKit/OperationFailureReportStore.swift:56`, `:70-77` |
| Nextflow scratch relocation on a volume without file locks or free of `._` sidecars | `Sources/LungfishWorkflow/Engines/NextflowRunner.swift:167-177` |
| `fetch genome` assembly-vs-nucleotide trap | `reviews/fidelity-2026-09/cli-help/fetch.txt:307-311` |
| `debug env --check-tools`, `--tool <name>` | `cli-help/debug.txt:32-33` |
| `debug container --pull-test` | `cli-help/debug.txt:55` |
| `conda db list` / `info` / `download` / `recommend` | `cli-help/conda.txt:427`, `:448`, `:472`, `:521` |
| `esviritu download-db`, `esviritu db-status` | `cli-help/esviritu.txt:19-20` |
| `taxtriage check-prerequisites` | `cli-help/taxtriage.txt:20`, `:81` |
| `analyze validate ... [--strict]` | `cli-help/analyze.txt:101-108` |
| `bundle validate <bundle>` | `cli-help/bundle.txt:204`, `:216` |

Messages I did NOT print because I could not find them in source: the SRA
fallback line `Falling back to SRA Toolkit (prefetch + fasterq-dump)` (DRIFT
row 14 said verify or drop; grep found nothing, so the whole SRA/NCBI
download section is dropped rather than restated with an unsourced quote),
`could not acquire lock on manifest.json` (DRIFT row 28 says this is wrong
and names `.lungfish/project.lock` and `<conda-root>/.install.lock`
instead, which is what the chapter now says), and `command not found:
minimap2` (an invented shell error, replaced by pointing at
`debug env --check-tools`).

## Gate files consulted, and what each contributed

All 60 `fable-gate.md` files under `reviews/fidelity-2026-09/chapters/*/`
were read in full via their "Findings for RESULTS.md" sections. Six roster
directories carry no gate yet (`appendices__file-formats`,
`appendices__keyboard-shortcuts`, `appendices__power-user-notes`,
`appendices__primer-schemes`, `appendices__shared-projects`,
`appendices__tool-versions`); their reader and fidelity notes were checked
for reader-facing symptoms and contributed the File Formats reader finding
that a wrong on-screen destination must be flagged as a defect rather than
described as behaviour.

Findings taken into the appendix:

| Gate file | Finding used |
|---|---|
| `09-genotyping__01-what-is-mhc-genotyping` | Every Genotyping submenu item starts greyed until enabled in the Workflow Library, and nothing on screen says so beyond the suffix |
| `08-workflows__01-the-workflow-builder` | The Workflow Builder is behind Show Experimental Features (item absent, not greyed) |
| `appendices__ai-assistant` | The Assistant tab exists only in the genomics content mode, so five viewport kinds get an Inspector without it and without an explanation |
| `07-assembly__01-when-to-assemble` (and `07-assembly__02-running-spades`) | MEGAHIT 1.2.9 fails most runs on Apple Silicon with both workarounds active; a completing run is correct; rerunning is the only workaround |
| `06-classification__02-running-kraken2` | An all-unclassified run exits 64 with Empty Kraken2 report before Bracken runs |
| `appendices__cli-reference` | Any command whose working directory is under /private/tmp fails with a provenance publication artifact error and writes nothing; `bundle export` cannot be run because its `--format` collides with the global one |
| `09-genotyping__02-running-genotyping` | An output directory under /private/tmp fails at 84 percent with a misleading outside-the-bundle message; `genotype-cohort` enforces an undocumented two-bundle minimum; Min Reads and `--min-support` are recorded but never filter a genotype-only run |
| `09-genotyping__03-reading-the-genotype-comparison` | The cohort summary panel and Smart Cohorts are hidden on a genotype-only result by design, so cohort depth comes from `genotype list-samples` |
| `06-human-germline-variants__01-haplotype-caller`, `__02-joint-genotyping`, `__04-reference-packs` | `conda install --pack gatk-core` reports an unknown pack (exit 3); `--pack phasing` too; both install from the Plugin Manager |
| `appendices__06-running-in-ci` | `--format json` accepted and ignored by several commands; `provenance verify` handles only signed sidecars and signing is off by default, so it exits 64 on an ordinary record; the exit-status meanings 0/3/10/64 |
| `08-workflows__03-running-external-workflows` | The external-workflow route is where a Nextflow run on unsuitable storage surfaces |
| `05-variants__06-importing-existing-vcfs` | VCF import is the chapter for the VCFv3 refusal |
| `03-reads__07-ont-runs` | `fastq ont-barcode-genotype` deprecation, corrected per the cli-reference fidelity note to point at FASTQ import recipes plus `fastq genotype` / `genotype-cohort` rather than at `ont-genotype` |

Findings read and deliberately NOT carried into the appendix, because they
are code-level or per-chapter interpretation problems rather than
reader-facing symptoms with an action: the Concatenate Exons dead control,
the MSA consensus threshold mismatch, `tree reroot` tip duplication, the
Mean Q double definition, `scrub-human --remove-reads` being ignored, the
`fastq sequence-filter` bbduk assertion, `fastq interleave` Phred
re-encoding, `map` labelling flagstat as Total reads, the
`extract reads --by-region` matcher, the iVar wrong-scheme silence, the
Viral Recon Extra-parameter refusal, the iVar codon merge band, the Het Only
chip, the Medaka and Clair3 failures, the alignment-consensus command
string, the EsViritu Identity column, TaxTriage TASS zeros, the NAO-MGS
summary single-sample read, the CZ ID Project Destination readout, the NVD
sort and TSV columns, the 12S reverse-complement omission, the GATK sidecar
overwrite, Flye and hifiasm circular doubling, the Nextflow and Snakemake
emitter defects, the bibliography matching tier, and the Workflow Builder
graph JSON. Several of these are named in their own chapters already, and
carrying all of them here would make the appendix a defect list rather than
a lookup.

## DRIFT verdicts, one by one

### False, all three applied

- Row 9. The per-classifier "database pack" sentence is gone. Replaced with
  the `conda db list` / `recommend` / `download <name>` route plus the two
  EsViritu commands, exactly as DRIFT specifies.
- Row 29. The "multi-user shared projects are not yet supported" claim is
  gone. Replaced by the whole "I cannot write to my project" section, which
  is the project-lock story, pointing at Shared Projects.
- Row 33. The `.lungfish/logs/cli.log` claim is gone. Replaced with the
  failure-report store under `~/Library/Logs/`, in a build-named folder,
  beneath `Operations/Failures`, written as the failure happens and pruned
  on each write. I did not print the number 50, because
  `OperationFailureReportStore` computes the retention limit rather than
  spelling 50 in the lines I read, so the chapter says "the most recent
  reports" instead.

### Changed, all twelve applied

- Row 8. `HTTPS_PROXY` advice kept, with the added sentence that it is read
  by micromamba and the underlying network stack rather than by LGE.
- Row 13. Dropped rather than kept. The retry-count and API-key-redaction
  sentence belonged to the NCBI download section, which is dropped whole
  (see row 14). Nothing in the rewrite asserts what the fetch provenance
  writer records.
- Row 14. Verbatim message not found in source, so the claim is dropped,
  and with it the SRA fallback paragraph.
- Row 15. The version-suffix claim is dropped. The NCBI accession advice
  that survives is row 16's, which is sourced from the command's own help.
- Row 16. Applied, with the trap stated as the help text states it, in the
  quiet-wrong-result table.
- Row 22. Applied. The project-lock material comes before any manifest
  discussion, and it is a section rather than a row, since it is the most
  likely reason a reader cannot write.
- Row 24. Applied. No RAM figures are asserted. The chapter points at
  `conda db recommend`, and the Kraken 2 chapter carries the capped-variant
  explanation.
- Row 26. The mpileup 600,000 figure is dropped from this chapter. DRIFT
  says verify it once in power-user-notes and cite it, and power-user-notes
  has no gate yet, so the appendix cites nothing rather than a figure it
  cannot stand behind.
- Row 28. Applied verbatim in substance. Lock failures surface against
  `.lungfish/project.lock` or a `.install.lock` in the conda root, never
  `manifest.json`, and the `._` sidecar check comes before any mount-option
  change.
- Row 32. Applied. `version --tools` for the managed set is the primary,
  with the dependency set explained.
- Row 35. Applied. The About window is named in full and `lungfish version`
  is offered.
- Row 36. The Help-menu GitHub claim is replaced by the two routes that were
  verified by chapter 6, which are the failed row's **Open GitHub Issue**
  and **Help > Report an Issue...**. No repository URL is printed.

### Missing, eighteen rows

Sixteen of the eighteen are in the chapter. The project-lock failure mode is
now a section. The conda mutation lock's two messages are quoted. `debug env
--check-tools` and `--tool`, `debug container --pull-test`, `tools update
--plan` with its exit 10, `conda db recommend` / `list`, `esviritu db-status`,
`taxtriage check-prerequisites`, `analyze validate --strict`, `bundle
validate`, `provenance verify` with its signing caveat, the VCFv3 rejection
and its remedy, the `convert` in-place refusal, BigWig and BigBed being
detect-only, the `fetch genome` accession trap, and `--format json` being
ignored are each an entry or a sentence.

Two are named but not given their own entry, to keep the appendix a lookup
rather than a command catalogue. `debug resource-smoke` and `debug
workflow-log` / `debug fastq-ingest` have no reader-visible symptom that
sends a reader to them, so they are left to the CLI Reference. This is a
deliberate omission, recorded here for the gate to overturn if it disagrees.

### Unverifiable, five

DRIFT counts five unverifiable claims without itemising them. Reading the
old body against the verdict counts, the five that neither the true, false,
nor changed tables account for are the iCloud corruption claim, the NFS
`noac,actimeo=0` remedy, the bundle-version write refusal, `lungfish project
migrate` with `--dry-run`, and the 5 GB free-space figure for a conda
install. All five are dropped.

- iCloud corruption. No source found asserting an atomicity assumption that
  iCloud breaks. Dropped rather than restated as folklore.
- `noac,actimeo=0`. A mount-option recipe with no LGE source behind it, and
  DRIFT row 28 supplies a better-sourced replacement, which the chapter uses.
- Bundle version write refusal and `project migrate --dry-run`. Neither
  appears in the committed CLI Reference's 44-command index nor in
  `cli-help/`, and no campaign record settles them, so the whole "Migrating
  from older Lungfish versions" section is dropped.
- 5 GB free space. An invented threshold. Replaced by `tools update --plan`,
  which reports the actual estimated download, and which printed 157.3 MB on
  this machine.

## Commands run, with exit statuses

All four ran with the working directory at `~` (never `/private/tmp`), using
the worktree's `.build/debug/lungfish-cli` at
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
No downloads, installs, or analyses were run.

| Command | Exit | What it printed, quoted in the chapter |
|---|---|---|
| `lungfish-cli debug env` | 0 | `macOS Version  : Version 26.6.2 (Build 25G83)`, `CPU Cores      : 14`, `Physical Memory: 48 GB`, `Architecture   : arm64`, and under Container Support, `✓ Apple Containerization available (macOS 26+)` |
| `lungfish-cli debug container` | 0 | `✓ Apple Containerization framework available`, `Status      : Ready`, `VM Type     : Apple Virtualization`, `Architecture: arm64` |
| `lungfish-cli version --tools` | 0 | `Lungfish 2026.9.13`, `Dependency set: 2026.2 (2026-08-18)`, then 18 tool rows (micromamba bundled, 17 managed) |
| `lungfish-cli tools update --plan` | 10 | `Target dependency set: 2026.2`, a `preserve bracken` line, a `reinstall gatk-core  unknown -> bioconda::gatk4=4.6.2.0=py310hdfd78af_1  [buildChanged]` line, and `Estimated download: 157.3 MB` |

The exit-10 result independently confirms the CI chapter's exit-status table
for `tools update --plan`, and it is the number the appendix quotes.

## Consistency sheet compliance

- App named "Lungfish Genome Explorer (LGE)" at first mention, then LGE.
  "Lungfish" alone is never used for the app (one link title corrected from
  "The Lungfish Project" to "The Lungfish Genome Explorer Project" to
  satisfy the app-name rule, matching the other spelling already in use in
  the manual).
- CLI binary named `lungfish-cli` throughout.
- Menu paths in bold with `>` and spaces, ellipsis where the item opens a
  dialog. Operations panel opened with **Operations > Show Operations
  Panel** (Cmd-Shift-P), Plugin Manager with **Tools > Plugin Manager...**
  (Cmd-Shift-B), both as the sheet fixes them.
- Shortcuts spelled Cmd-Shift-P and Cmd-Shift-B per the chapter 62 ruling.
- Experimental features introduced with the fixed sentence, verbatim.
- MEGAHIT paragraph carries the sheet's four required points and does not
  claim the two-thread cap fixes it.
- The /private/tmp defect stated as the sheet and the cli-reference gate
  state it, including that `/tmp/...` works, so it is the spelling.
- Read-only project ruling followed. Multi-user projects are supported and
  coordinated with locks, pointing at Shared Projects.
- The demo project is not referenced, since this appendix uses no fixture.
- No em dash, no semicolon, no in-sentence colon. Bullet lists: none used,
  since every enumeration became a table or prose.

## Front matter

`estimated_reading_min` set to 18, up from 12, for a longer appendix with
six tables. `brand_reviewed` and `lead_approved` both left `false`.
`shots` holds one entry, `operations-panel-failed-row`, matching the single
`<!-- SHOT: ... -->` marker in the body. DRIFT's screenshot row suggested
two shots, the expanded failed row and the project-lock dialog. I declared
only the failed row, because the lock dialog's content depends on a live
lock from a second session and is awkward to stage deterministically, and
because the failed row is the shot the "Start here" instruction depends on.
The Screenshot Scout may add the lock shot if it can be staged.

## Glossary terms added

Four, each one sentence in the existing shape with an explicit anchor, and
each listed in `glossary_refs`.

- **Failure report** `{#failure-report}`, in F, before FASTA.
- **Symlink** `{#symlink}`, in S, before Supplementary alignment.
- **Workflow Library** `{#workflow-library}`, in W, after Workflow package.
- **Working directory** `{#working-directory}`, in W, after Workflow package.

Terms already present and reused rather than redefined: advisory lock,
conda, container, dependency set, exit status, Operations Panel, plugin
pack, project lock, provenance sidecar.

## What I could not verify

1. The SRA Toolkit fallback message. Not found in `Sources/`. The whole
   network-and-download section is dropped rather than kept with an
   unsourced quote. If a campaign run record has the line, this section
   should come back at the gate.
2. The retention count of the failure-report store. The directory and the
   prune-on-write behaviour are in
   `OperationFailureReportStore.swift`, but I did not read the literal 50
   in the lines I opened, so the chapter says "the most recent reports".
3. The mpileup depth cap of 600,000. DRIFT row 26 defers it to
   power-user-notes, which has no gate yet, so nothing is cited.
4. `bundle export`, `conda install --pack gatk-core`, and the ONT
   deprecation notice were not re-run here. The environment refused a
   command whose program name came from a shell variable, and re-running
   them was outside the "cheap diagnostics only" brief. All three are taken
   from the committed CLI Reference's Known defects table and the gate files
   that produced it, which is the campaign record the brief points at.
5. The Deacon index example from the brief ("installing only from the
   command line") does not hold in this release. Both Deacon databases ship
   with the Required Setup pack, per
   `chapters/03-reads/05-decontamination.md:81`, and are shown in the
   Plugin Manager as Human Read Removal Data and Ribosomal RNA Removal
   Data. The example is dropped rather than printed.
6. The Nextflow external-drive behaviour is stated from
   `NextflowRunner.swift:167-177`, which is silent relocation with no
   user-facing message. The entry therefore names the symptom and the
   remedy without quoting a message, since there is none to quote.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/troubleshooting.md`

Two warnings on the first pass, both fixed. `stalled` was an overused word
in the orientation paragraph, and one link title used bare "Lungfish" for
the app. Final run prints:

```text
docs/user-manual/chapters/appendices/troubleshooting.md: no issues found
```

All 18 relative chapter links were resolved against the filesystem and
every one exists.
