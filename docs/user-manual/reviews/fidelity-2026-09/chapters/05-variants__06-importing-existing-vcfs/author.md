# Author report, chapter 31: 05-variants/06-importing-existing-vcfs

Author: bioinformatics-educator. Date: 2026-09-07.
Chapter rewritten in place from scratch. Registry id `import.vcf`, fixture
`hg002-chr20`.

## Lint

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
      docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md

Result: `no issues found`. Clean on the first run and again after the two
glossary-link additions.

## Runs I made

Everything below ran from
`/private/tmp/claude-501/.../scratchpad/vcf-import/`, against copies of the
fixture files. Nothing was written into `~/Desktop/lge-docs` or into the
worktree. The CLI is `.build/debug/lungfish-cli` from the primary checkout.
bcftools is the managed environment build, `bcftools 1.24` on `htslib 1.24`
from `~/.lungfish/conda/envs/bcftools/bin/bcftools`.

### 1. Record count in the fixture's benchmark VCF

    bcftools view -H HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz | wc -l
    961

Matches the fixture README's stated 961 records. The file name is
`HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` with `.tbi` beside it.

### 2. `lungfish-cli import vcf` on the bgzipped benchmark

    lungfish-cli import vcf src/HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz \
      --output-dir ./imported

Printed, verbatim:

    VCF Import

    ℹ Reading VCF header and variants...
    ℹ Copied index: HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz.tbi

    Summary

    Format  : VCFv4.2
    Variants: 961
    Types   : SNP: 809, DEL: 74, INS: 64, OTHER: 14
    Samples : 1
    Contigs : 1

      Samples: HG002

    ✓ VCF import complete: HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz

The chapter quotes the Summary block. Output directory afterwards held the
VCF, its `.tbi`, a `.lungfish-provenance.json` for the directory, and one
sidecar per copied file. No bundle, no database, no bgzip step.

### 3. `lungfish-cli import vcf` on a plain uncompressed VCF

    bcftools view src/HG002...benchmark.vcf.gz -o src/benchmark-plain.vcf
    lungfish-cli import vcf src/benchmark-plain.vcf --output-dir ./imported-plain --format json

Same 961-variant summary. The output directory holds `benchmark-plain.vcf`
at 717 KB, uncompressed and unindexed, confirming the CLI does not bgzip or
index a plain VCF. `--format json` was accepted and ignored (see defects).

### 4. `lungfish-cli bundle create --variant`

    lungfish-cli bundle create \
      --fasta src/GRCh38.chr20.10.0-10.5Mb.fasta \
      --name "HG002 chr20 slice" \
      --variant src/HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz \
      --organism "Homo sapiens" --assembly GRCh38 \
      --output-dir "Manual Scratch.lungfish/Reference Sequences"

Created `HG002_chr20_slice.lungfishref`. Its `variants/` folder holds
`hg002.chr20.10.0-10.5mb.benchmark.vcf.bcf` (44 KB),
`.bcf.csi` (336 bytes), and `.db` (2.1 MB), which confirms the
CONSISTENCY.md Variant track storage note that this path writes `.bcf` plus
`.csi` rather than the `.vcf.gz` plus `.tbi` the attach path writes. The
chapter states that difference in the On the command line section.

    bcftools view -H <that .bcf> | wc -l
    961

### 5. Counts read out of the bundle's SQLite database

    sqlite3 <bundle>/variants/....db

    select count(*) from variants;                        -> 961
    select filter, count(*) from variants group by filter; -> PASS|961
    select variant_type, count(*) ... group by ...;        -> SNP 809, DEL 77, INS 75
    select min(quality), max(quality) from variants;       -> 50.0, 50.0
    select name from samples;                              -> HG002
    select genotype, count(*) from genotypes group by ...; -> 0/1 571, 1/1 374,
                                                              2/1 11, 1/2 4, 1/0 1

Every count the chapter quotes for the benchmark track comes from this run.
The 16 multi-allelic rows in the chapter are 11 + 4 + 1.

### 6. Representative rows read from the VCF itself

    position 2078   G -> A   PASS  GT 1/1  DP 1231
    position 250527 C -> T   PASS  GT 0/1  DP 1247

Position 250527 is the coordinate chapter 05-variants/02 uses for its
shared-call example (bcftools `0/1`, LoFreq `AF=0.571429`), so the benchmark
row there gives the chapter a real three-way agreement to point at. Both
positions were read with `bcftools view -H | awk`.

### 7. `analyze validate --strict`

    lungfish-cli analyze validate src/HG002...benchmark.vcf.gz --strict
    ✓ HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz: Valid VCF file

### 8. The two bundle-scoped query commands

    lungfish-cli variants extract-sample <bundle> --sample HG002 \
      --output HG002-benchmark.vcf     -> 961 records
    lungfish-cli variants query <bundle> --filter "Sample[HG002].GT=1/1" \
      --output hom-alt.vcf             -> 374 records

The 374 matches the genotype table exactly, which is why the chapter uses
that filter as its worked query rather than an invented one.

## What I removed from the old chapter, and why

The old chapter's core mechanism did not exist. Removed in full:

- The **Inferred reference** field, the alias-map matching story, and the
  claim that the Import Center names the matching bundle. No such field,
  string, or code path exists (`AppDelegate+ImportCenter.swift:39-61` makes
  no inference). DRIFT rows 12 and 32.
- The **"No matching bundle"** readout and the disabled Import button.
  Replaced by the real no-bundle behaviour, per DRIFT row 13. DRIFT row 36's
  troubleshooting entry went with it.
- The **Reference** dropdown for overriding a wrong match. DRIFT row 14.
- **Choose File** as a control name. The card's button reads `Import…`
  (`ImportCenterView.swift:230`). DRIFT row 11.
- The drag-drop **inference gate** ("completes silently if unambiguous,
  reopens the Import Center pre-selected if not"). Neither branch exists.
  DRIFT row 17.
- The claim that a track appears **nested under the bundle** in the sidebar.
  There is no per-variant-track sidebar node (reality map standing note).
  DRIFT rows 16, 33, 34.
- The `chrCOV19` and `SARS-CoV-2-WH01` alias examples. Neither string is
  anywhere in `Sources/`. DRIFT row 5.
- The **SARS-CoV-2 worked example** in its entirety. Replaced with a human
  one, per the campaign's human-first rule and because the fixture for this
  chapter is `hg002-chr20`. DRIFT rows 32, 33, 35.
- The **Accepted formats table**, whose BCF row was wrong for the guided
  path (the file panel offers only `.vcf` and `.gz`,
  `ImportCenterViewModel.swift:397-401`). The surviving facts are now prose
  in step 2 and the On the command line section. DRIFT row 7.
- The **VCFv3 troubleshooting section**, which admitted it had not confirmed
  the behaviour it described. Unsourced speculation has no place in the
  rewrite, and the campaign template has no Troubleshooting section.
- The **"progress bar, then close the Import Center"** narration. The real
  surface is a progress label plus an OperationCenter row titled
  `Importing <file>` with detail `Importing VCF variants (<profile>)...`
  (`AppDelegate+ImportCenter.swift:1073-1081`). DRIFT row 15.

Kept and re-sourced: the CLI's argument set and its summary fields, the
`variants query` 5,000-record silent cap, the provenance-sidecar staging
behaviour, and the statement that LGE never re-coordinates positions onto a
different sequence (DRIFT row 37, correct as a statement of what does not
happen).

## Newly documented, from the Missing table

Every row of the reality map's Missing table is now covered except one.

- The `Name Imported Variant Bundle` prompt: step 5, with its message text,
  its pre-filled default, and its Create/Cancel buttons.
- The replace-existing behaviour when the name collides: step 5.
- The background NCBI reference download after a variant-only import:
  step 5, including why it is a bad idea on this fixture (the benchmark
  header still carries the full GRCh38 contig list, so it would try to fetch
  a human reference for a 500 kb example).
- The `No Active Project` refusal: step 5, quoting the real alert title.
- The multi-file selection the panel permits: step 2.
- The `Default Ploidy` metadata item and its auto/haploid rule: step 5.
- `analyze validate --strict`: On the command line, with the run's output.
- `--format` with `text`, `json`, `tsv`: On the command line.
- The write-permission gate: step 3.
- `File > Open` as a fourth entry point: **not added**, deliberately. See
  defects below. `features.yaml:18` claims it, but MainMenu.swift has no
  File-menu item that opens a file (only `Open Project Folder...`), and the
  action that would serve it, `importVCFToBundle`, is wired to no menu item.
  I did not add an entry point I could not reach.
- `import sample-metadata` and `import metadata`: **not added**. They attach
  a sample sheet rather than import a VCF, they have their own registry
  entry (`import.sample-metadata`), and adding them would have pushed the
  On the command line section past what one chapter should carry. Flagged
  here for the Lead in case a cross-reference is wanted.

## How each DRIFT unverifiable row was settled

The Part A section lists one unverifiable row.

**Row 20**, "If your merged files are diploid, change that default in the
bundle's import settings before you read genotypes." The reality map could
not locate a writable surface for `Default Ploidy` after import.

Settled: there is none. `VCFAutoIngestor.swift:253` computes
`defaultPloidy` once at ingest time from `vcfURLs.count > 1` and writes it
at `:273` as a `MetadataItem` inside an `Import Settings` `MetadataGroup` in
the manifest. `MetadataItem` is written by the manifest builder and is not
reachable from any editing control. A `grep` for `Default Ploidy` across
`Sources/` returns that one write site and nothing that reads or edits it.
The separate `Auto / Haploid / Diploid` segmented control in the Variants
tab toolbar is a display setting for the frequency chips and is documented
in chapter 05-variants/02, not a writer of this manifest value.

The chapter therefore states what the value records and when it is
`haploid`, and gives no instruction to change it, because the instruction in
the old chapter pointed at a control that does not exist.

## Shot markers

Three markers, three matching `shots:` entries, all captions rewritten.

| id | Why |
|---|---|
| `import-center-vcf-card` | Replaces the old `import-center-variants`. The old caption promised a chosen-VCF readout and an inferred-reference field, neither of which exists. New caption names the `VCF Variants` card and its `Import...` button. |
| `name-imported-variant-bundle` | New, and the shot the reality map asked for. This prompt is the most visible step on the no-bundle path and the old chapter never mentioned it. |
| `imported-benchmark-in-variants-tab` | Replaces the old `imported-vcf-track-sidebar`. There is no nested variant-track sidebar node. New caption asks for the table drawer's Variants tab with the `Source` column separating the three tracks. |

Both old planned shots are retired by name. The Screenshot Scout should
treat all three as new captures.

## Glossary

One term added, alphabetised between `Variant-caller` and `Variant track`,
in the existing one-sentence-plus-`See also:` shape:

- **Variant-only bundle** `{#variant-only-bundle}`. The `.lungfishref`
  bundle built around imported VCFs with no reference sequence of its own,
  which is what the `Name Imported Variant Bundle` path produces.

No other term needed adding. `Benchmark VCF`, `bgzip`, `CSI`, `FILTER`,
`Genotype`, `Import Center`, `Provenance`, `Provenance sidecar`,
`Reference bundle`, `Table drawer`, `Tabix`, `Variant track`, and `VCF` all
already existed and are listed in `glossary_refs` with a link earned in the
body.

One existing entry is now stale and I left it alone because this chapter no
longer references it. **Alias map** `{#alias-map}` describes an internal
table that resolves accessions during VCF import so a VCF keyed against one
resolves to a bundle keyed against another. That is the mechanism DRIFT row
5 and reality-map row 12 both struck down. The resolver exists but does not
do that job on this path. Flagging for the Lead rather than editing an entry
another chapter may still cite.

## Possible app defects found

Four, in descending order of how much they would confuse a reader.

**1. `bundle create --variant` writes `variant_count: 0` into the manifest.**
After run 4 above, `bundle info` reports the track with `Variants: 0`, and
`manifest.json` carries `"variant_count": 0`, while the `.bcf` holds 961
records and the `.db` holds 961 rows. The count is simply never written. A
reader who runs `bundle info` to confirm an import worked is told it did
not. I wrote the chapter around the database and the BCF rather than around
`bundle info` because of this, but the chapter cannot say the tool is wrong,
so the number is best fixed.

**2. `importVCFToBundle` is an orphaned action, and `features.yaml`'s
`File > Open (filter: VCF)` entry point is not reachable.**
`AppDelegate+MenuActions.swift:285` implements a full VCF import flow with
its own file panel (`AppFilePanelFactory.vcfImportPanel`), and
`AppDelegate.swift:1951` validates its menu item, but no `NSMenuItem` in
`MainMenu.swift` carries that selector. The File menu's only Open item is
`Open Project Folder...`, which takes a directory. So the fourth entry point
the reality map asked me to add (`features.yaml:18`) cannot be exercised.
Either the menu item was dropped in a refactor and should come back, or the
action and the features.yaml row should go.

**3. The Settings picker's `lowMemory` tag does not match the enum's raw
value.** `GeneralSettingsTab.swift:65` tags the Low Memory option
`"lowMemory"`, but `VCFImportProfile.lowMemory` has raw value `"low-memory"`
(`VariantDatabaseModels.swift:236`). It works only because
`selectedVCFImportProfile()` has a lowercased fallback that catches
`"lowmemory"` (`AppDelegate+ImportCenter.swift:1497`). Remove that fallback
and the setting silently reverts to Auto. The picker also omits the fourth
case, `ultraLowMemory`, which the import path can still select.

**4. `import vcf --format json` is accepted and ignored.** Run 3 above
passed `--format json` and got the same human-readable text block. The flag
is declared in the help output for every `import` subcommand, so a script
parsing the output has no way to know it did not get JSON. Either implement
it or reject the value.

Two smaller observations, offered as notes rather than defects.

- The two variant-type classifiers disagree. `import vcf` reports
  `SNP: 809, DEL: 74, INS: 64, OTHER: 14` on the same file the bundle
  database sorts into `SNP 809, DEL 77, INS 75`. Both total 961. The chapter
  says so explicitly rather than picking one, but one classifier would be
  better than two.
- The database `bundle create` writes has no `source_file` column
  (`.schema variants` shows twelve columns, none of them a source), where
  the GUI's `VCFAutoIngestor` sets `sourceFile` per row
  (`VCFAutoIngestor.swift:160`, `:187`, `:205`). The Variants tab's `Source`
  column therefore falls back to the manifest track's `source` for a
  CLI-built bundle. Worth confirming that a CLI-built multi-track bundle
  still separates its tracks in the table.
