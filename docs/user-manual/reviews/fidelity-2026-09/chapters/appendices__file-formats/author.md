# Author record, appendices/file-formats.md

Campaign: 2026-09 fidelity pass. Roster row 61. Target build: Preview 2026.9.13.
Author: bioinformatics-educator. Date: 2026-09-07.

## Outcome

Full rewrite in place. The appendix keeps its reference shape (one section per
standard format family, one per bundle kind) and now covers 25 registry format
rows plus 3 registry-identifier-only formats, and 13 bundle kinds.

Final lint, verbatim:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/file-formats.md: no issues found
```

## Commands run, with exit status

All scratch output written to
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/file-formats/`.
The Preview CLI was reached through a symlink named `lfcli` in that folder,
because the harness refuses a command path containing a space.

| Command | Exit | Purpose |
|---|---|---|
| `lfcli bundle --help` | 0 | Subcommand list for the reference bundle |
| `lfcli bundle export --help` | 0 | OCI export flags |
| `lfcli bundle info <HBB.lungfishref>` | 0 | Real manifest report quoted in the chapter |
| `lfcli bundle export <HBB.lungfishref> --format container --output ...` | 0 (error printed) | Reproduced the export defect |
| `lfcli bundle export <HBB.lungfishref> --output ...` | 0 (error printed) | Confirmed the flag is required and unusable |
| `lfcli fastq materialize --help` | 0 | Virtual bundle materialization flags |
| `lfcli metadata --help` | 0 | Confirmed `metadata.csv` and `samples.csv` |
| `lfcli metadata export-biosample --help` | 0 | Confirmed the BioSample TSV writer |
| `lfcli import fasta --help` | 0 | Compression suffixes and EMBL acceptance |
| `lfcli import bam --help` | 0 | CRAM acceptance |
| `head -3` on `GRCh38.chr20.10.0-10.5Mb.fasta` | 0 | FASTA sample |
| `cat` on `GRCh38.chr20.10.0-10.5Mb.fasta.fai` | 0 | FAI sample |
| `gzcat ... HG002.chr20.10.0-10.5Mb_R1.fastq.gz \| head -4` | 0 | FASTQ sample |
| `gzcat ... benchmark.vcf.gz \| grep -v '^##' \| head -4` | 0 | VCF sample |
| `head -6` on `HBB.lungfishref/annotations/imported_annotations.gff3` | 0 | GFF3 sample |
| `head -4` on `QIASeqDIRECT-SARS2.lungfishprimers/primers.bed` | 0 | Primer BED sample |
| `samtools idxstats <hg002-minimap2.bam>` | 0 | Real idxstats output quoted |
| `samtools flagstat <hg002-minimap2.bam>` | 0 | Real flagstat output quoted |
| `bcftools view -H <vc-6edd1356...vcf.gz>` | 0 | Real variant rows quoted |
| `cat <Primate mitochondria.lungfishtree/tree/primary.nwk>` | 0 | Real Newick quoted |
| `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/file-formats.md` | 0 | Ran three times. Baseline 32 warnings, then 1, then clean |
| `LUNGFISH_MANUAL_STRICT=1 ... lint-chapter.sh docs/user-manual/GLOSSARY.md` | 0 | 426 pre-existing warnings, all from the file's own "See also:" convention |

samtools 1.24 and bcftools from `~/miniforge3/bin` were used for the
inspection commands, matching the `variantCallerVersion` 1.24 the demo
project's own provenance records.

## Source files consulted

Arbiter for the standard formats:

- `Sources/LungfishIO/Registry/FormatRegistry+BuiltInDescriptors.swift`. Every
  descriptor was extracted programmatically to build the registry table,
  including each one's extensions, `canRead`, `canWrite`, and `uiCategory`.
- `Sources/LungfishIO/Registry/FormatIdentifier.swift`. Source of the three
  identifier-only formats (EMBL, 2bit, CSI) and of the three bundle
  identifiers that exist in the registry.

Arbiter for the bundle formats:

- `Sources/LungfishApp/App/DocumentManager.swift:117-143`. The `DocumentType`
  enum and its extension lists, which is the set of bundles the app opens
  directly.
- `Sources/LungfishIO/Bundles/MHCAmpliconReferenceBundle.swift:150`,
  `MultipleSequenceAlignmentBundle.swift:7`,
  `ONTGenotypeResultBundle.swift:1830`,
  `TwelveSAmpliconResultBundle.swift:5`, `TwelveSReferenceBundle.swift:72`,
  `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift:14`,
  `Sources/LungfishWorkflow/nf-core/NFCoreRunBundleManifest.swift:193`. Every
  `directoryExtension` constant. The extension list in the chapter comes from
  these plus the string-literal sweep below, not from memory.
- `Sources/LungfishWorkflow/Builder/WorkflowLibraryStore.swift:49-52`. The
  `.lungfishflow` extension and its `graph.json`, `workflow.json`,
  `provenance.json` filenames.
- `Sources/LungfishWorkflow/WorkflowPackages/WorkflowPackageManifest.swift:260-261`.
  `.lungfishflowpkg` and its `manifest.json`.
- `Sources/LungfishWorkflow/nf-core/NFCoreRunBundleManifest.swift:191-201`. The
  `.lungfishrun` bundle's `manifest.json` plus `logs/`, `reports/`, `outputs/`.
- `Sources/LungfishIO/Bundles/HaplotypeDefinitionStore.swift:19` and
  `Sources/LungfishWorkflow/ONTGenotyping/MHCAmpliconReferenceBundleBuilder.swift:181`.
  Settled that `.lungfishhaplotypedef` is a JSON file suffix inside an MHC
  reference bundle, not a bundle format.
- `Sources/LungfishIO/Bundles/GenotypeAnnotationSidecar.swift:118`.
  `annotations.json` as the annotation-layer filename.
- `Sources/LungfishWorkflow/Containers/BundleContainerExportService.swift:74-81`.
  The exact OCI tarball entry list quoted in the sharing section.
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift:860-867`. CZ ID writing
  to `Classifications/<sample>.lungfishtax`.
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift:1399-1400,1545`.
  `Workflow Runs/` and the `12S amplicon results` folder name.
- A repository-wide sweep for `"lungfish[a-z0-9]*"` string literals produced the
  candidate extension list, which was then narrowed to the ones actually written.

## Bundles and fixtures actually opened

Demo project at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` (read only):

- `Reference Sequences/HBB.lungfishref`. Full folder listing and full
  `manifest.json`. Source of the `genome` block excerpt, the annotation-track
  listing, and the GFF3 excerpt.
- `Reference Sequences/chr20_10.0-10.5Mb.lungfishref`. Full folder listing.
  Source of the reference-bundle layout block, the `alignments/mapped/` path,
  the `vc-<uuid>` variant naming, and the provenance sidecar excerpt.
- `Imports/HG002-chrM.lungfishfastq`. Full folder listing and the
  `.lungfish-meta.json` sidecar. Source of the read-bundle layout and the
  `computedStatistics` excerpt.
- `Analyses/Multiple Sequence Alignments/Primate-mitochondria.lungfishmsa`.
  Full folder listing and full `manifest.json`. Source of the MSA layout and
  the camelCase manifest keys and counts.
- `Phylogenetic Trees/Primate mitochondria.lungfishtree`. Full folder listing,
  full `manifest.json`, and `tree/primary.nwk`. Source of the tree layout, the
  tree counts, and the Newick example.
- `Analyses/kraken2-SRR36291587` and `Analyses/nvd-demo`. Listings only, to
  confirm classifier results are plain folders rather than bundles.

Williams MiSeq genotyping project at
`~/Desktop/lge-docs/32566_MS267_Williams1.lungfish` (read only):

- `Analyses/Amplicon genotyping results/finalcheck.lungfishgenotype`. Full
  folder listing. Source of the genotype-bundle contents paragraph.

Shipped app resources in the worktree:

- `Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref`.
  Full listing. Source of the `mhc-reference.json` manifest-name fact and the
  `haplotypes/` and `sources/` folders.
- `Sources/LungfishApp/Resources/PrimerSchemes/`. Listing of all eight bundles,
  plus the full `manifest.json` and `primers.bed` of `QIASeqDIRECT-SARS2`.

Manual fixtures (read only):

- `docs/user-manual/fixtures/hg002-chr20/`. FASTA, FAI, FASTQ, and benchmark
  VCF excerpts.
- `docs/user-manual/fixtures/hbb-gene/`. Named as the source of the HBB bundle.
- `docs/user-manual/fixtures/primate-mito/`. Named as the source of the
  alignment and tree.

`fixtures_refs` was set to `[hbb-gene, hg002-chr20, primate-mito, demo-project]`,
which are the four fixture folders whose data reaches a quoted line.

## Facts taken from CONSISTENCY.md

CONSISTENCY.md was treated as binding and won wherever it and the old appendix
disagreed.

- The project folder set. `Imports/`, `Downloads/`, `Reference Sequences/`,
  `Primer Schemes/`, `Extractions/`, `Analyses/`, `Classifications/`,
  `Workflows/`, `Workflow Runs/`, and the top-level `Phylogenetic Trees/`.
- **There is no `Assemblies/` folder.** The task brief listed one and
  CONSISTENCY.md denies it, so CONSISTENCY.md was followed. The rewrite says an
  assembly is a `.lungfishref` inside the assembler's run folder under
  `Analyses/`. This also deletes the old appendix's "Assembly | `.lungfishref`
  (in `Assemblies/`)" bundle-table row. Confirmed independently against
  `07-assembly/03-running-flye-or-hifiasm.md:40` and against a repository sweep
  showing `Assemblies` survives only in one stale doc comment at
  `AssemblyConfigurationViewController.swift:47`.
- Variant track storage. `<name>.vcf.gz` plus `.vcf.gz.tbi` plus a `.db` SQLite
  sidecar under the reference bundle's `variants/` folder, with the two named
  exceptions, which are the GATK entries writing `variants/gatk/<track-id>.vcf.gz`
  and `bundle create --variant` writing `.bcf` plus `.csi`. The `.bcf` and
  `.csi` exception was taken from CONSISTENCY.md alone (see unverified below).
- Paired-end storage as one interleaved file with `pairingMode: interleaved`.
- Multiple sequence alignments under `Analyses/Multiple Sequence Alignments/`
  and trees in a top-level `Phylogenetic Trees/` folder.
- 12S results at `Analyses/12S amplicon results/<Result Name>.lungfish12s`.
- CZ ID results at `Classifications/<sample>.lungfishtax`, and that classifier
  results generally are not bundles.
- The Variants tab naming ("the Variants tab of the table drawer").
- Naming discipline. "Lungfish Genome Explorer" then "LGE", `lungfish-cli` as
  the command-line tool's name.

## Facts taken from committed chapters

- `02-sequences/01-importing-and-viewing.md:230`. `genome/sequence.fa.gz` as
  the reference bundle's sequence path.
- `03-reads/01-importing-fastq.md:37,236`. The read bundle sitting under
  `Imports/` and the interleaved-storage paragraph.
- `03-reads/06-subsetting-and-extraction.md:226`. Virtual bundles holding only
  a `preview.fastq` of about a thousand reads.
- `07-assembly/03-running-flye-or-hifiasm.md:40,210` and
  `07-assembly/04-extracting-contigs.md:65`. Assembly results as `.lungfishref`
  in a timestamped run folder under `Analyses/`.
- `08-workflows/01-the-workflow-builder.md:97,220`. `Workflows/<name>.lungfishflow`,
  the `runs/<run-id>/` folder inside a bundle, and the `Workflow Runs/<run-id>/`
  fallback for a bare graph JSON.
- `08-workflows/03-running-external-workflows.md:34,46`. `.lungfishflowpkg` and
  `.lungfishrun` descriptions.
- `06-classification/08-importing-cz-id-results.md:114,122`. The
  `Classifications/<sample>.lungfishtax` destination and the Project
  Destination readout defect, restated in one sentence here.
- `06-classification/10-twelve-s-metabarcoding.md:90,122`. The
  `.lungfish12sref` role and the `12S amplicon results` folder.
- `appendices/primer-schemes.md`. Consulted for the primer manifest field list.
  That appendix has not yet been rewritten and still claims a single built-in
  scheme, so this chapter states the verified eight and links to it for the
  field-by-field manifest rather than for the scheme count.

## DRIFT rows applied

False claims. Row 15, three bundle-table rows added (`.lungfishgenotype`,
`.lungfishrun`, `.lungfishflow`), and the table was extended further to 13 rows.
Row 19, eight built-in schemes rather than one. Row 29, MAFFT named as the
shipped aligner rather than a list of three.

Changed claims. Row 1, the seven FASTA extensions. Row 3, the four GenBank
extensions. Row 7, the SAM convention reattributed to the mapping pipeline
rather than to format support. Row 14, the note that only three bundle
extensions are registry-registered. Row 16, the manifest claim softened, with
the four differing real manifest shapes named. Row 17, the invented minimal
manifest replaced by a real excerpt from `HBB.lungfishref/manifest.json`. Row
20, ARTIC and Midnight described as shipped rather than as things to import.
Row 27, `.lungfishtax` verified against the CZ ID importer and kept, with the
correction that other classifier results are plain result folders. Row 30, the
MSA layout replaced by the real one read from the demo project. Row 32, the
invented provenance sample replaced by a real one, and the absence of
`schema_version` stated explicitly. Row 33, settled by reading a real sidecar,
`sha256` and `sizeBytes` are carried on every entry of both arrays.

Missing rows. All fifteen were added. BigWig and BigBed as detection only,
bedGraph, CRAM, BCF, EMBL, 2bit, CSI, the five compression suffixes, the five
document formats, the four image formats, the read and write distinction as its
own paragraph plus a column in the registry table, the BioSample TSV export, the
`uiCategory` grouping explained as the category column, and the OCI layout
tarball with its five entry kinds.

Removed as unsupported. `.lungfishhaplotypedef` as a bundle format, the
`Assemblies/` folder, the "every manifest uses snake_case keys" claim (the MSA
and tree manifests are camelCase), the "every bundle carries a `manifest.json`
that lists the files inside" claim, the invented `.lungfishref` layout showing
`reference.fasta` and a `tracks/` BAM, the invented provenance schema, and the
broken `primer-schemes.md#appendix-primer-schemes` anchor, which does not exist
in that file and was replaced with a plain file link.

## App defects found

1. **`lungfish-cli bundle export` cannot be run in Preview 2026.9.13.** Its
   `--format` option collides with the global `--format` option that every
   command carries. Passing the documented `--format container` returns
   `Error: The value 'container' is invalid for '--format <format>'. Please
   provide one of 'text', 'json' or 'tsv'.`, while omitting it returns
   `Error: Missing expected argument '--format <format>'`. The subcommand's own
   help text advertises the `--format container` form. The export code path in
   `BundleContainerExportService.swift` looks complete, so this reads as an
   argument-parser layering bug rather than a missing feature. Stated in the
   chapter with the zip workaround.
2. Restated, not newly found. The CZ ID Import sheet's Project Destination
   readout names an `Analyses/cz-id-<timestamp>` path that nothing writes to.
   Already recorded in `06-classification/08-importing-cz-id-results.md`.

## What could not be verified

- **`bundle create --variant` writing `.bcf` plus `.csi`.** Taken from
  CONSISTENCY.md, which attributes it to the chapter 28 review. A grep of
  `Sources/LungfishCLI/Commands/BundleCommand.swift` found no `bcf` or `csi`
  handling, so the write may live in a service the command calls. CONSISTENCY.md
  is binding, so the claim was kept as written there, but it rests on that
  ruling rather than on a source read or a run of my own.
- **The `.lungfishflow`, `.lungfishflowpkg`, and `.lungfishrun` internal
  layouts.** No instance of any of the three exists in either demo project, so
  the filenames come from the source constants and from the committed workflow
  chapters rather than from a bundle I opened. The chapter states them without
  a folder-listing block, which is the honest presentation.
- **The `.lungfish12s` and `.lungfish12sref` internal layouts.** No instance
  exists in either demo project. The chapter names what they hold and where
  they land, taken from CONSISTENCY.md and the 12S chapter, and shows no layout
  block for either.
- **Whether an outside GTF import really produces no GTF on the way out.** The
  registry marks GTF `canWrite: false` and no GTF writer exists in
  `Sources/LungfishIO/Formats/`, which is the basis for the claim. I did not
  run a GTF import to confirm the conversion end to end.
- **The `.lungfishtax` manifest's own keys.** No `.lungfishtax` bundle exists in
  either demo project, so the chapter says what the bundle holds and where it
  lands without describing its manifest.
- **DRIFT's "BED no" writer decision.** DRIFT's decision line says "Writers as
  they are (GFF3 yes, BED no)", but
  `FormatRegistry+BuiltInDescriptors.swift:96` sets BED to `canWrite: true`. The
  source was followed and the table says BED writes. Flagging the discrepancy
  for the reviewer, since the DRIFT line may have been written against an
  earlier build or may reflect a distinction between a registry flag and a real
  BED writer, which does not exist in `Sources/LungfishIO/Formats/` either. By
  that same standard several other `canWrite: true` rows would also be false,
  which is why the chapter carries a paragraph explaining that the write flag
  means an internal routine can produce the format rather than that a
  dedicated writer file exists.
- **The five unverifiable DRIFT verdicts.** DRIFT's header line counts five
  unverifiable claims for this chapter but the section lists no unverifiable
  table, only False, Changed, Missing, and Screenshots. I could not recover
  which five claims they were, so I rewrote every claim in the chapter against
  source, a real bundle, or a run rather than trying to match that count.

## Glossary changes

Eleven terms added to `docs/user-manual/GLOSSARY.md`, each in the existing
one-sentence-plus-"See also:" shape and each placed alphabetically.

`bedGraph`, `BigBed`, `BigWig`, `CRAM`, `EMBL (sequence format)`,
`Format registry`, `GenBank (sequence format)`, `GTF (gene transfer format)`,
`OCI layout`, `SAM (Sequence Alignment Map)`, `Two-bit (2bit)`.

All eleven anchors plus the twenty-two pre-existing ones named in
`glossary_refs` were checked to resolve against the file's `{#anchor}` set.
None of the new entries introduces a semicolon. The glossary's 426 lint
warnings are pre-existing and come from the file's own "See also:" convention,
which trips `sentence-colon.js` on essentially every entry.

## Front matter

Kept every key. `brand_reviewed` and `lead_approved` remain false.
`estimated_reading_min` raised from 14 to 26, which reflects roughly 4,900 words
of dense reference prose plus twenty code and table blocks a reader stops to
read. `audience` left at `analyst`. `tools` set to `[samtools, bcftools]`, the
two outside programs the chapter tells the reader to run. `shots` stays empty,
per DRIFT's screenshot row, since the chapter's illustrations are file layouts
and record shapes that code blocks serve better than screenshots would.
