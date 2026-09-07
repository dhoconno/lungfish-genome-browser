# Reality map: 01-foundations

Sources consulted:

- `Sources/LungfishApp/App/MainMenu.swift`
- `Sources/LungfishApp/App/AppDelegate+MenuActions.swift`
- `Sources/LungfishApp/App/AppDelegate+PersistenceHelp.swift`
- `Sources/LungfishApp/App/HardwareRequirements.swift`
- `Sources/LungfishApp/App/VCFAutoIngestor.swift`
- `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift`
- `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift`
- `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift`
- `Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift`
- `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift`
- `Sources/LungfishApp/Views/Sidebar/UniversalSearchAdvancedPopoverController.swift`
- `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift`
- `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift`
- `Sources/LungfishApp/Views/Settings/GeneralSettingsTab.swift`
- `Sources/LungfishApp/Views/Viewer/FilterProfileManager.swift`
- `Sources/LungfishApp/Views/Viewer/SmartFilterTokens.swift`
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift`
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift`
- `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`
- `Sources/LungfishCore/Storage/ProjectFile.swift`
- `Sources/LungfishCore/Storage/ProjectLockRecovery.swift`
- `Sources/LungfishCore/Storage/ManagedStorageConfigStore.swift`
- `Sources/LungfishCore/Bundles/BundleManifest.swift`
- `Sources/LungfishCore/CLICommandIdentity.swift`
- `Sources/LungfishCore/Models/AppSettings.swift`
- `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift`
- `Sources/LungfishIO/Bundles/PrimerSchemesFolder.swift`
- `Sources/LungfishIO/Bundles/PrimerSchemeBundle.swift`
- `Sources/LungfishIO/Bundles/AnalysesFolder.swift`
- `Sources/LungfishIO/Formats/FASTQ/OperationChain.swift`
- `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift`
- `Sources/LungfishWorkflow/Conda/PluginPack.swift`
- `Sources/LungfishWorkflow/Conda/PluginPackStatusService.swift`
- `Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift`
- `Sources/LungfishWorkflow/Mapping/MappingTool.swift`
- `Sources/LungfishWorkflow/Mapping/ManagedMappingPipeline.swift`
- `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift`
- `Sources/LungfishWorkflow/Provenance/ProvenanceExporter.swift`
- `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift`
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
- `Sources/LungfishApp/Resources/PrimerSchemes/*.lungfishprimers` (8 bundled schemes)
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/provenance.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/project.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/primers.txt`
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/conda.txt`
- `docs/user-manual/fixtures/sarscov2-srr36291587/` (README.md, MN908947.3.fasta, ivar.expected.vcf, lofreq.expected.vcf)
- `docs/user-manual/features.yaml`

Note. There is no June 2026 reality map for Foundations. Every row below was verified fresh against the sources listed above.

Two findings run across several chapters and are recorded per chapter as well.

- The command-line executable is `lungfish-cli`, not `lungfish` (`Sources/LungfishCore/CLICommandIdentity.swift:8`, and every banner in the `cli-help/` dumps). Chapters 06, 07, and 08 all print `lungfish`.
- The bundled example VCFs are the arbiter for chapter 05. `ivar.expected.vcf` and `lofreq.expected.vcf` in the fixture folder disagree with almost every VCF example the chapter prints.

## 01-what-is-a-genome.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "the way Lungfish Genome Explorer points at a position: 1-based and inclusive, so the first base is position 1 rather than 0" | true | `Sources/LungfishCore/Bundles/BundleManifest.swift` chromosome model and every viewport ruler use 1-based display; `docs/user-manual/fixtures/sarscov2-srr36291587/ivar.expected.vcf` POS column is 1-based | |
| 2 | "`MN908947.3`, the original SARS-CoV-2 isolate from December 2019, a single positive-sense, single-stranded RNA genome 29,903 nucleotides long" | true | `docs/user-manual/fixtures/sarscov2-srr36291587/MN908947.3.fasta` measures 29,903 bases; `ivar.expected.vcf` header `##contig=<ID=MN908947.3,length=29903>` | |
| 3 | "In Lungfish Genome Explorer (LGE) you meet it first as a FASTQ file ... and later as a BAM file" | true | `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift`; `Sources/LungfishWorkflow/Mapping/ManagedMappingPipeline.swift` writes sorted indexed BAM | |
| 4 | "NCBI's curated RefSeq database mirrors the identical 29,903-nucleotide sequence under the accession `NC_045512.2`" | true | Every bundled primer scheme manifest lists both as equivalent accessions, for example `Sources/LungfishApp/Resources/PrimerSchemes/ARTIC-SARS-CoV-2-V4.1.lungfishprimers/manifest.json` `reference_accessions` `[MN908947.3 canonical, NC_045512.2 equivalent]` | |
| 5 | "References sit in a project's `Reference Sequences/` folder as reference bundles" | true | `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift:20` `public static let folderName = "Reference Sequences"` | |
| 6 | "folders that hold the reference's `.fasta` sequence in plain text, its `.fai` index ... and a provenance record" | false | `Sources/LungfishCore/Bundles/BundleManifest.swift:79-93` documents the layout as `genome/sequence.fa.gz` (bgzip-compressed FASTA), `genome/sequence.fa.gz.fai`, and `genome/sequence.fa.gz.gzi`. The FASTA is not plain text and does not sit at the bundle root | "folders that hold the reference's sequence as a bgzip-compressed FASTA under `genome/`, its `.fai` and `.gzi` indexes beside it, and a provenance record of where the sequence came from, when, and from which version" |
| 7 | "Sample data lives elsewhere, in `Imports/` for files you brought from disk or `Downloads/` for files LGE fetched from a public archive on your behalf" | true | `Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift:435` writes to `Imports`; `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift:1956` creates `Downloads` | |
| 8 | "LGE, like every aligner and variant caller it wraps, treats every reference as linear." | true | `Sources/LungfishCore/Bundles/BundleManifest.swift` carries no circularity flag; no mapper in `Sources/LungfishWorkflow/Mapping/MappingTool.swift` takes a circular option | |
| 9 | "The 'circular by convention' problem belongs to plasmids and bacterial genomes, which the current LGE toolset does not target." | false | `Sources/LungfishWorkflow/Conda/PluginPack.swift:668-718` ships the `assembly` pack with SPAdes, MEGAHIT, SKESA, Flye, and Hifiasm, and `Sources/LungfishWorkflow/Conda/PluginPack.swift:771-822` ships Kraken2 and Bracken. Bacterial assembly and bacterial classification are both supported paths | "The 'circular by convention' problem belongs to plasmids and bacterial genomes. LGE can assemble and classify bacterial data, but it still unrolls every reference at the curator's chosen origin" |
| 10 | "Every position it shows, in the inspector, the variant table, and the genome ruler, is 1-based." | true | `Sources/LungfishApp/Views/Viewer/` renderers and the fixture VCFs all present 1-based POS | |
| 11 | "Our example's header reads `>MN908947.3 Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome`" | true | `docs/user-manual/fixtures/sarscov2-srr36291587/MN908947.3.fasta` line 1 is exactly that string | |
| 12 | "`MN908947.3:23403` points at base 23,403 on the SARS-CoV-2 reference. That base is an `A`" | true | Base 23403 of `MN908947.3.fasta` is `A`; `ivar.expected.vcf` row `MN908947.3 23403 . A G` | |
| 13 | "it sits inside the codon for amino acid 614 of the spike gene" | true | Bases 23402 to 23404 read `GAT`, the aspartate codon of D614G, and `ivar.expected.vcf` calls `A>G` there | |
| 14 | "Hand LGE a coordinate whose contig is not in the loaded reference and it refuses" | changed | `Sources/LungfishCore/Bundles/ChromosomeNameMapping.swift` exists precisely to reconcile differing contig names (for example `chr1` against `1`), so a mismatched name is first put through the mapping and only then rejected | "Hand LGE a coordinate whose contig cannot be matched to the loaded reference, even after its chromosome-name mapping runs, and it refuses" |
| 15 | "A single-sample VCF, the kind LGE produces, writes out only the positions where the sample departs from the reference." | true | `docs/user-manual/fixtures/sarscov2-srr36291587/ivar.expected.vcf` has one sample column and 91 rows, all variant positions; `lofreq.expected.vcf` has 108 rows and no sample column | |
| 16 | "every variant in an LGE project is stored next to the accession of the reference it was called against" | true | `ivar.expected.vcf` header carries `##contig=<ID=MN908947.3,length=29903>`; `Sources/LungfishCore/Bundles/BundleTracks.swift` variant tracks live inside the reference bundle | |
| 17 | "the variant table always shows the contig name in its first column" | true | `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView+TableView.swift` column order follows the VCF field order, CHROM first | |
| 18 | "Every reference imported into a project carries provenance: the accession, the source database, the download date, and a checksum, all visible from the project sidebar" | changed | Provenance is visible in the Inspector's Provenance section, not from the sidebar itself (`Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:32-84`). The section shows Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON, and `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:348` prints `sha256 <checksum>` | "Every reference imported into a project carries provenance: the accession, the source database, the download date, and a SHA-256 checksum, all visible in the Inspector's Provenance section when you select the reference in the sidebar" |
| 19 | "every variant call keeps the reference accession in its record header, so a VCF you hand to a collaborator describes itself" | true | `ivar.expected.vcf` and `lofreq.expected.vcf` both carry `##contig` or `##reference` lines naming MN908947.3 | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The project is a `.lungfish` directory bundle, not a bare folder | `Sources/LungfishCore/Storage/ProjectFile.swift:98` `public nonisolated static let fileExtension = "lungfish"` |
| Chromosome-name mapping between reference naming conventions | `Sources/LungfishCore/Bundles/ChromosomeNameMapping.swift` |
| The `.lungfishref` bundle's `genome/`, `annotations/`, `variants/`, and `tracks/` subfolders | `Sources/LungfishCore/Bundles/BundleManifest.swift:79-93` |
| Reference bundles can carry BigBed annotations and BigWig signal tracks | `Sources/LungfishCore/Bundles/BundleManifest.swift:70-93` |
| `Extractions/` project folder for read and region extraction bundles | `Sources/LungfishApp/Views/Viewer/ViewerViewController+Extraction.swift:575` |
| Bundle warnings retained with a finished import | `Sources/LungfishCore/Bundles/BundleManifest.swift:7-35` `BundleWarning` |
| The bundled GenBank record store inside a reference bundle | `Sources/LungfishCore/Bundles/BundleManifest.swift:38-50` `ReferenceRecordStoreInfo` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | Yes | The chapter is conceptual and needs no app screenshots |
| Illustration `linear-vs-circular-genomes` | Yes | Purely conceptual, unaffected by the corrections |
| Illustration `position-coordinates` | Yes | 29,903 and the 1-based ticks are both verified |
| Illustration `variant-notation` | Yes | The `MN908947.3:23403 A>G` breakdown is verified against the fixture |

## 02-sequencing-reads.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "The example fixture used in Calling Variants from Amplicon Reads holds 86,281 read pairs." | true | `docs/user-manual/fixtures/sarscov2-srr36291587/README.md:3-4` "paired-end Illumina, 86,281 read pairs" | |
| 2 | "Here is one record from the SARS-CoV-2 fixture" followed by a `@SRR36291587.1 1/1` record | changed | The 21.7 MB FASTQ is not committed (`docs/user-manual/fixtures/sarscov2-srr36291587/README.md:23-25`), so the printed record cannot be checked against a fixture file. The header shape is plausible for `fasterq-dump` output but is not sourced | "Here is one record in the shape SRA delivers for this run" |
| 3 | "A FASTQ with 86,281 reads runs to 345,124 lines." | changed | 86,281 x 4 = 345,124, so the arithmetic holds, but the fixture holds 86,281 read *pairs*, so each of the two files carries 86,281 reads and 345,124 lines | "A FASTQ with 86,281 reads runs to 345,124 lines. Each of this fixture's two files holds that many, because 86,281 is a count of pairs" |
| 4 | "LGE handles `.fastq` and `.fastq.gz` alike. You never need to unzip a file before importing it" | true | `Sources/LungfishIO/Formats/FASTQ/FASTQReader.swift` reads both; `cli-help/import-fastq.txt` accepts either | |
| 5 | "Behind the scenes, LGE stores reads compressed to keep project folders small." | changed | `cli-help/fastq.txt:287-289` shows `--compress` as an opt-in flag on FASTQ operations, and `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift` stores whatever the import supplied. Compression is not an unconditional store-time behaviour | "LGE keeps compressed reads compressed, and its FASTQ operations offer a compress option for their outputs" |
| 6 | "Illumina's own convention writes the suffix as `_R1` and `_R2`. The two mean the same thing, and LGE accepts either." | true | `Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift` pairing detection matches both suffix families | |
| 7 | "merging tools such as `fastp --merge` or `bbmerge` turn the overlap to advantage" | changed | LGE's merge operation is bbmerge only. `cli-help/fastq.txt:36` reads "merge Merge overlapping paired-end reads using bbmerge". No fastp merge path exists in `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift` | "merging turns the overlap to advantage, and LGE's Merge Overlapping Pairs operation uses `bbmerge` for it" |
| 8 | "LGE keeps the mates as separate records by default and leaves the overlap to the downstream aligner." | true | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:97-98,254-255` makes merging an explicit operation with its own strictness and min-overlap settings, so the default is not to merge | |
| 9 | "LGE bundles store paired-end reads interleaved internally, keeping both halves of a fragment together, but the import and export surfaces speak the two-file convention" | false | Interleaving is an explicit user operation, not the internal storage form. `Sources/LungfishIO/Formats/FASTQ/OperationChain.swift:22-23,102,139-142` defines `interleaveReformat` as an operation that converts between `.splitPaired` and `.interleaved`; `cli-help/fastq.txt:38-39` exposes both `deinterleave` and `interleave` as subcommands. `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift:230` resolves "paired R1/R2 FASTQ URLs", two files | "LGE bundles keep paired-end reads as two files, R1 and R2. Interleaving into a single alternating file is a separate operation you run when a downstream tool wants that shape, and Deinterleave reverses it" |
| 10 | "The character `!` (ASCII 33) is Q0; `5` (ASCII 53) is Q20; `?` (ASCII 63) is Q30; `I` (ASCII 73) is Q40." | true | Phred+33 arithmetic; no app claim | |
| 11 | "The `F` in the record above has ASCII code 70, which decodes to Q37" | true | 70 minus 33 = 37 | |
| 12 | "LGE and the tools underneath it (FastQC, fastp, BWA, minimap2) do the decoding and report the aggregate statistics." | changed | FastQC ships in the `illumina-qc` pack (`Sources/LungfishWorkflow/Conda/PluginPack.swift:464-471`, packages `fastqc`, `multiqc`, `trimmomatic`), which has no `requirements` list and is not marked `isActive`, so it is not an installable active pack. fastp is in Required Setup (`third-party-tools-lock.json` tools list). BWA is not shipped at all; the short-read mapper is BWA-MEM2 (`Sources/LungfishWorkflow/Mapping/MappingTool.swift:11`) | "LGE and the tools underneath it (fastp, BWA-MEM2, minimap2) do the decoding and report the aggregate statistics" |
| 13 | "LGE ships variant callers for both ends of the spectrum. LoFreq and iVar handle Illumina short reads ... Medaka and Clair3 handle Oxford Nanopore long reads" | changed | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:5-11` defines five callers: lofreq, ivar, medaka, bcftools, clair3. The `variant-calling` pack installs four of them (`Sources/LungfishWorkflow/Conda/PluginPack.swift:569`, packages `lofreq`, `ivar`, `medaka`, `clair3`); bcftools comes from Required Setup | "LGE ships variant callers for both ends of the spectrum. LoFreq, iVar, and bcftools handle Illumina short reads from shotgun and amplicon protocols. Medaka and Clair3 handle Oxford Nanopore long reads" |
| 14 | Platform table row "Illumina (NextSeq, NovaSeq, MiSeq) 75 to 300 bp" and the other three rows | true | Domain facts about sequencing platforms, not app claims. No number here is displayed by LGE | |
| 15 | "A 150 bp Illumina read spans about 0.5% of the SARS-CoV-2 genome (29,903 bp)." | true | 150 / 29,903 = 0.50%; genome length verified above | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The FASTQ Operations panel and its full operation catalogue | `cli-help/fastq.txt:24-49` lists 25 subcommands including subsample, length-filter, trim, quality-trim, adapter-trim, fixed-trim, contaminant-filter, entropy-filter, primer-remove, error-correct, merge, repair, deinterleave, interleave, deduplicate, demultiplex |
| Virtual FASTQ bundles and `fastq materialize` | `cli-help/fastq.txt:49` "materialize Materialize a virtual FASTQ bundle to a physical" |
| Read deduplication with clumpify.sh | `cli-help/fastq.txt:40` |
| Low-complexity entropy filtering and its threshold | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:84` "Shannon entropy threshold for the low-complexity filter (0.3-0.9, step 0.05)" |
| Barcode scouting and demultiplexing, including ONT and PacBio barcode paths | `cli-help/fastq.txt:41-48` |
| The FASTQ statistics the Inspector reports (read count, bases, mean length, mean quality) | `Sources/LungfishIO/Formats/FASTQ/FASTQStatisticsCollector.swift` |
| Merge Overlapping Pairs settings: strictness and minimum overlap, default 12 | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:97-98,254-255` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | Yes | Conceptual chapter; a FASTQ Operations panel shot would help but was not planned |
| Illustration `fastq-record-anatomy` | Yes | The four-line structure is correct |
| Illustration `paired-end-reads` | Yes | Correct as drawn |
| Illustration `phred-quality-bar` | Yes | Q20 and Q30 annotations are correct |
| Illustration `platform-read-length-comparison` | Yes | Read-length ranges are domain facts, not app claims |

## 03-amplicon-vs-shotgun.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "ARTIC v3 for SARS-CoV-2 uses 98 primer pairs in two pools to make 98 overlapping amplicons of about 400 bp each" | true | `Sources/LungfishApp/Resources/PrimerSchemes/ARTIC-nCoV-2019-V3.lungfishprimers/manifest.json` reports `amplicon_count` 98. The BED holds 218 primer rows because the scheme includes alternate primers | |
| 2 | "the default minimum-allele-frequency threshold usually filters them out" | true | `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:75` `self.minimumAlleleFrequencyText = "0.05"` | |
| 3 | "Two approaches exist, and LGE supports both, depending on where in the workflow you want the trim to fall." | true | Read-based: `cli-help/fastq.txt:34` `primer-remove`. Alignment-based: `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift` | |
| 4 | "A tool such as `fastp` takes the primer sequences, walks each FASTQ read end, matches primer sequence at the read's 5' edge, strips those bases, and writes a trimmed FASTQ." | false | LGE's read-based primer removal uses bbduk or cutadapt-linked, never fastp. `cli-help/fastq.txt:279-280` `--engine <engine> Primer trimming engine: bbduk or cutadapt-linked (default: bbduk)` | "LGE's Primer Remove operation takes the primer sequences, matches them against each FASTQ read, strips those bases, and writes a trimmed FASTQ. Its engine is `bbduk` by default, with `cutadapt-linked` as the alternative" |
| 5 | "A tool such as `ivar trim` or `samtools ampliconclip` takes the primer coordinates from a BED file ... and marks those bases as soft-clipped." | changed | LGE runs `ivar trim` only. `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:1,39` builds an `ivar trim` argument list; `samtools ampliconclip` appears nowhere in `Sources/` | "`ivar trim` takes the primer coordinates from a BED file, walks each aligned read in the BAM, finds where the read's mapped position overlaps a primer footprint, and marks those bases as soft-clipped" |
| 6 | "It is the ARTIC project's recommended approach, and the LGE default for the iVar variant-calling lane." | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift` is the app's primer-trim pipeline, and `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:39` carries `ivarPrimerTrimConfirmed` as a gate on the iVar lane | |
| 7 | "In LGE, the BAM-level primer trim runs `ivar trim` against a chosen primer scheme, after alignment and before variant calling." | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:10` "Resolves the primer scheme's BED to the BAM's reference name, runs `ivar trim`" | |
| 8 | "The operation's provenance sidecar records the exact options used, so the run is always recoverable." | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimProvenance.swift:26` "Literal argument list passed to `ivar trim` (excluding the program name)" | |
| 9 | "the six standard columns are chrom, start, end, name, score, strand" | true | `Sources/LungfishApp/Resources/PrimerSchemes/ARTIC-nCoV-2019-V3.lungfishprimers/primers.bed` line 1 `MN908947.3 30 54 nCoV-2019_1_LEFT 1 +` | |
| 10 | "A minimal BED row for the forward primer in the example above reads: `MN908947.3 999 1021 nCoV-2019_1_LEFT 1 +`" | changed | The name `nCoV-2019_1_LEFT` is the real ARTIC v3 primer, but its real coordinates are `30 54`, not `999 1021` (`primers.bed` line 1). Using a real primer name with invented coordinates is confusing beside the bundled scheme | Keep the invented coordinates but rename the primer, for example `scheme_1_LEFT`, so it cannot be mistaken for the bundled ARTIC v3 row |
| 11 | "LGE packages primer schemes as `.lungfishprimers` bundles. Each bundle is a folder holding the BED file, the primer sequences as a companion FASTA, and a provenance note naming the source and the reference accession" | true | `Sources/LungfishIO/Bundles/PrimerSchemeBundle.swift:143-146` resolves `manifest.json`, `primers.bed`, `primers.fasta`, and `PROVENANCE.md`. The FASTA is optional (`fastaURL: URL?` at line 121) | |
| 12 | "Bundles sit in the project's `Primer Schemes/` folder" | true | `Sources/LungfishIO/Bundles/PrimerSchemesFolder.swift:19` `public static let folderName = "Primer Schemes"` | |
| 13 | "**ARTIC v3** ... Coordinates target Wuhan-Hu-1 (`MN908947.3`)." | true | `ARTIC-nCoV-2019-V3.lungfishprimers/manifest.json` `reference_accessions` names MN908947.3 canonical | |
| 14 | "**ARTIC v4.1.** Released in late 2021 ... Same 400 bp amplicon size, revised primer positions." | true | The bundled `ARTIC-SARS-CoV-2-V4.1.lungfishprimers/manifest.json` description reads "ARTIC Network SARS-CoV-2 400 bp amplicon scheme, version 4.1. Adds spike-in primers restoring Omicron coverage", with 99 amplicons | |
| 15 | "**ARTIC v5.3.2** (released January 2023). A redesigned 400 bp scheme rebalanced for coverage uniformity." | changed | The bundled `ARTIC-SARS-CoV-2-V5.3.2.lungfishprimers/manifest.json` reports 96 amplicons and 192 primers, a different amplicon count from v3 (98) and v4.x (99). The chapter never says LGE bundles it | "**ARTIC v5.3.2.** A redesigned 400 bp scheme rebalanced for coverage uniformity, 96 amplicons across 192 primers. LGE bundles it" |
| 16 | "The ARTIC project keeps shipping updates (the v5.4.2 scheme, for one, released for JN.1-era mutations), so always check the scheme version against your protocol metadata." | changed | v5.4.2 is not among the eight bundled schemes (`Sources/LungfishApp/Resources/PrimerSchemes/`). Naming it without saying it must be imported by hand misleads the reader | "The ARTIC project keeps shipping updates. LGE bundles ARTIC v3, v4, v4.1, and v5.3.2; any newer scheme has to be imported with `lungfish-cli primers import`" |
| 17 | "**QIAseq Direct SARS-CoV-2.** A commercial enhanced-amplicon kit with shorter (~250 bp) amplicons" | changed | LGE bundles it as `QIASeqDIRECT-SARS2.lungfishprimers` with 563 primers and 223 amplicons. The chapter does not say it is bundled, and 223 amplicons across a 30 kb genome averages nearer 134 bp per amplicon step than 250 bp | "**QIAseq Direct SARS-CoV-2.** A commercial enhanced-amplicon kit built for fragmented RNA, 223 amplicons across 563 primers. LGE bundles it, and it is the scheme the manual's SRR36291587 fixture was prepared with" |
| 18 | "**Midnight (1200 bp).** A coarser, 1200 bp amplicon scheme built for Oxford Nanopore long reads." | true | Bundled as `Midnight-1200-V1.lungfishprimers`, 29 amplicons across 58 primers, consistent with a 1200 bp tiling of a 30 kb genome | |
| 19 | "For LGE workflows, treat capture-based data like shotgun data. Skip primer trimming" | true | Primer trim is opt-in per operation, never forced (`Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:39` `ivarPrimerTrimConfirmed: Bool = false`) | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| LGE bundles eight primer schemes ready to pick, with no import step | `Sources/LungfishApp/Resources/PrimerSchemes/` holds ARTIC v3, v4, v4.1, v5.3.2, Midnight 1200 V1, NEB VarSkip vss1, NEB VarSkip Long vsl1, and QIAseq Direct |
| NEB VarSkip and VarSkip Long schemes | `NEB-VarSkip-vss1.lungfishprimers` (74 amplicons), `NEB-VarSkip-Long-vsl1.lungfishprimers` (29 amplicons) |
| `lungfish-cli primers import` for a scheme LGE does not bundle | `cli-help/primers.txt` "Import a BED primer scheme as a .lungfishprimers bundle" |
| Scheme import options: `--reference-accession`, `--equivalent-accession`, `--display-name`, `--attachment` | `cli-help/primers.txt:24-36` |
| Every bundled scheme declares both MN908947.3 and NC_045512.2, so a BAM aligned to either resolves | All eight `manifest.json` files list `reference_accessions` with a canonical and an equivalent entry |
| Primer Remove settings: `--kmer` 23, `--mink` 11, `--hdist` 1, `--minimum-overlap` 12, `--error-rate` 0.12 | `cli-help/fastq.txt:276-286` |
| The `amplicon-analysis` plugin pack | `Sources/LungfishWorkflow/Conda/PluginPack.swift:907-924` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | No | The chapter now needs one shot of the primer-scheme picker showing the eight bundled schemes, since "LGE bundles these" is the corrected message |
| Illustration `amplicon-vs-shotgun` | Yes | Conceptual and correct |
| Illustration `primer-scheme-diagram` | Yes | Correct, provided its BED coordinates are not presented as ARTIC v3's real ones |
| Illustration `primer-trim-soft-clip` | Yes | Soft-clipping is what `ivar trim` does |

## 04-alignment-files.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "LGE runs several mappers behind the scenes, and the surface you actually work with in this chapter is the BAM viewport" | true | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:10-13` defines four mappers | |
| 2 | "LGE ships four mappers and picks a sensible default by read type." | true | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:10-13` minimap2, bwa-mem2, bowtie2, bbmap; `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:1939-1942` exposes the same four | |
| 3 | "minimap2 is the default for long reads (Oxford Nanopore, PacBio) and for many short-read jobs." | true | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:194-195` carries minimap2 presets, and `Sources/LungfishWorkflow/Mapping/MappingCompatibility.swift` treats minimap2 as unconstrained by read length while BBMap is capped | |
| 4 | "BBMap handles messier reads where local alignment helps." | changed | BBMap is length-constrained, not a general messy-read fallback. `Sources/LungfishWorkflow/Mapping/MappingCompatibility.swift:46-47` sets `bbmapStandardMaxReadLength = 500` and `bbmapPacBioMaxReadLength = 6_000`, and `Sources/LungfishWorkflow/Mapping/ManagedMappingPipeline.swift:455` switches to a PacBio mode above the standard cap | "BBMap handles messier reads where local alignment helps, up to 500 bases in its standard mode and 6,000 in its PacBio mode" |
| 5 | "Project-stored alignment tracks in LGE are always sorted, indexed BAMs; the GUI never puts a raw SAM file in front of you." | true | `Sources/LungfishIO/Services/MarkdupService.swift:77-81` and `Sources/LungfishWorkflow/Mapping/ManagedMappingPipeline.swift` sort and index every output | |
| 6 | "The FLAG column, a bitwise integer with twelve canonical bits" | true | SAM specification fact, not an app claim | |
| 7 | "Every BAM LGE writes gets a `.bam.bai` alongside it." | changed | LGE writes `.bai` or `.csi` as the data requires. `Sources/LungfishIO/Services/MarkdupService.swift:77-81` removes "ALL existing index files (both .bai and .csi)" before re-indexing, so both are live index forms | "Every BAM LGE writes gets an index alongside it, a `.bam.bai` for ordinary references and a `.csi` where a contig is too long for BAI" |
| 8 | "Copy a BAM into a project without its index and LGE rebuilds one when the file loads" | true | `Sources/LungfishIO/Registry/FileTypeUtility.swift:55` treats fai, bai, csi, tbi, and gzi as companion indexes and the load path regenerates a missing one | |
| 9 | "It carries a per-contig size limit of 512 megabases, so references with a single contig longer than that ... need the CSI index format instead." | true | htslib fact; `Sources/LungfishIO/Registry/FormatIdentifier.swift:240-244` confirms CSI is a first-class supported format | |
| 10 | "LGE creates the right index for you automatically" | true | `Sources/LungfishIO/Services/MarkdupService.swift:77-81` handles both forms without user choice | |
| 11 | "LGE's iVar and LoFreq lanes default to a minimum alternate-allele frequency of 0.05, so a 10 percent ALT is reportable but a 0.5 percent ALT is not" | changed | The 0.05 default is a GUI dialog default (`Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:75`), not a caller-lane constant. The pipeline request itself defaults to `minimumAlleleFrequency: Double? = nil` (`Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:38,53`), which lets each tool's own default apply | "The variant-calling dialog pre-fills a minimum alternate-allele frequency of 0.05, so at that setting a 10 percent ALT is reportable but a 0.5 percent ALT is not" |
| 12 | "LGE's BAM-level primer trim runs `ivar trim` against a primer scheme and rewrites the BAM so that primer regions are soft-clipped" | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:1,10,39` | |
| 13 | "Most records pass through, their count unchanged, though some `ivar trim` options can drop records whose remaining aligned span is too short." | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:18` notes the argument array "ends with `-e`", iVar's include-reads-with-no-primers flag, which governs exactly this | |
| 14 | "LGE uses soft-clipping wherever it can." | true | `ivar trim` soft-clips; no hard-clip path exists in `Sources/LungfishWorkflow/Primers/` | |
| 15 | "the recommended variant caller differs: LoFreq or iVar for short reads, Medaka or Clair3 for Oxford Nanopore" | changed | bcftools is a fifth supported caller and is omitted (`Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:5-11`) | "the recommended variant caller differs: LoFreq, iVar, or bcftools for short reads, Medaka or Clair3 for Oxford Nanopore" |
| 16 | "The coverage track at the top of the BAM viewport draws coverage as a histogram across the reference" | true | `Sources/LungfishApp/Views/Viewer/` alignment rendering draws a coverage histogram above the read stack | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| Duplicate marking as an alignment step | `cli-help/markdup.txt`; `Sources/LungfishIO/Services/MarkdupService.swift` |
| minimap2 presets beyond the read-type default (`asm5`, `splice`, and the rest) | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:194-195` |
| The mapper compatibility check that warns before a mismatched mapper runs | `Sources/LungfishWorkflow/Mapping/MappingCompatibility.swift:44-100` |
| The `bam` CLI command group | `cli-help/bam.txt` |
| The `map` CLI command and its settings | `cli-help/map.txt` |
| The mapping provenance sidecar written beside every BAM | `Sources/LungfishApp/Views/Inspector/MappingDocumentStateBuilder.swift:173` `MappingProvenance.filename` |
| The `long-read` plugin pack for nanopore and PacBio alignment | `Sources/LungfishWorkflow/Conda/PluginPack.swift:823-831` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | No | A chapter whose stated habit is "read the coverage track first, then zoom to a position and read the pileup" should show the BAM viewport at least once |
| Illustration `read-mapping-cartoon` | Yes | Correct as drawn |
| Illustration `coverage-histogram` | Yes | Correct as drawn |
| Illustration `pileup-view` | Yes | Correct as drawn |
| Illustration `cigar-anatomy` | Yes | `5S140M5S` is a valid CIGAR for the described record |

## 05-variants-and-vcf.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "A typical iVar VCF for a SARS-CoV-2 isolate opens with about 30 header lines, then a few hundred variant rows." | changed | `docs/user-manual/fixtures/sarscov2-srr36291587/ivar.expected.vcf` carries 18 header lines and 91 variant rows | "A typical iVar VCF for a SARS-CoV-2 isolate opens with about twenty header lines, then tens to hundreds of variant rows" |
| 2 | "The compression is `bgzip` ... not ordinary gzip." | true | `Sources/LungfishCore/Bundles/BundleManifest.swift:81-83` uses bgzip plus `.gzi` for the genome FASTA, the same htslib convention | |
| 3 | "Inside an LGE bundle, variants are not stored as a `.vcf.gz` on disk. The variant track is a SQLite database (`variants.db`)" | false | The bundle's variant payload is a `.bcf` with a `.csi` index, and SQLite is an *optional sidecar*. `Sources/LungfishCore/Bundles/BundleManifest.swift:87-90` shows `variants/snps.bcf`, `variants/snps.bcf.csi`, and `variants/snps.sqlite # Optional SQLite sidecar for app queries`. `Sources/LungfishCore/Bundles/BundleTracks.swift:303,400` makes `databasePath` optional. The literal name `variants.db` appears only in the auto-ingest path at `Sources/LungfishApp/App/VCFAutoIngestor.swift:150` | "Inside an LGE bundle the variant track is stored as a BCF with a CSI index under `variants/`, and an optional SQLite sidecar beside it indexes the same rows for the variant browser's fast filtering" |
| 4 | "When an operation needs a VCF (export, a downstream tool, sharing), LGE regenerates one from SQLite" | changed | The canonical on-disk payload is BCF, so a VCF is produced from the BCF, not from the optional SQLite sidecar (`Sources/LungfishCore/Bundles/BundleManifest.swift:87-90`) | "When an operation needs a VCF, LGE writes one from the stored BCF; on import it reads VCFs back in through the same path" |
| 5 | VCF excerpt beginning `##source=lofreq call` with `##FORMAT` lines and a `SRR36291587` sample column | false | LoFreq VCFs in LGE have eight columns and no sample column at all. `docs/user-manual/fixtures/sarscov2-srr36291587/lofreq.expected.vcf` header row is `#CHROM POS ID REF ALT QUAL FILTER INFO`, with no FORMAT and no sample. Its declared INFO keys are `DP`, `AF`, `SB`, `DP4`, `INDEL`, `CONSVAR`, `HRUN` | Replace the excerpt with the real iVar shape (see rows 6 to 9) or with a real LoFreq eight-column excerpt, and label which caller produced it |
| 6 | Sample row `MN908947.3 23403 . A G 228 PASS DP=1842;AF=0.998 GT:DP:AF 1/1:1842:0.998` | false | Both fixtures disagree. The real iVar row is `MN908947.3 23403 . A G . PASS TYPE=SNP GT:DP:REF_DP:REF_RV:REF_QUAL:ALT_DP:ALT_RV:ALT_QUAL:ALT_FREQ 1:2299:7:4:39:2290:1166:38:0.996085`. The real LoFreq row is `MN908947.3 23403 . A G 3076 PASS DP=187;AF=0.994652;SB=0;DP4=0,1,89,97` with no sample column | Use the real iVar row verbatim, or the real LoFreq row verbatim, and say which |
| 7 | Sample row `MN908947.3 1989 . A G 9 ft DP=1750;AF=0.005 GT:DP:AF 0/0:1750:0.005` | false | The real LoFreq row at 1989 is `MN908947.3 1989 . A G 80 PASS DP=2032;AF=0.004921;SB=0;DP4=1022,1000,5,5`. It is `PASS`, not `ft`, and its QUAL is 80, not 9. No iVar row exists at 1989 | Pick a real non-PASS row. The iVar fixture's four `ft` rows include `MN908947.3 44 . C T . ft TYPE=SNP GT:DP:REF_DP:REF_RV:REF_QUAL:ALT_DP:ALT_RV:ALT_QUAL:ALT_FREQ 1:79:75:75:38:4:2:38:0.0506329` |
| 8 | "LGE's variant callers emit a small set: `GT` (genotype), `DP` (depth at this position), `AF` (allele frequency), and sometimes `AD`" | false | iVar's FORMAT keys in LGE are `GT:DP:REF_DP:REF_RV:REF_QUAL:ALT_DP:ALT_RV:ALT_QUAL:ALT_FREQ`, plus `MERGED_AF` and `MERGED_DP` when codon merging fires (`ivar.expected.vcf` header). There is no `AF` and no `AD` key. LoFreq emits no FORMAT at all | "iVar output carries `GT`, `DP`, then per-allele detail (`REF_DP`, `REF_RV`, `REF_QUAL`, `ALT_DP`, `ALT_RV`, `ALT_QUAL`) and `ALT_FREQ` for the alternate fraction, with `MERGED_AF` and `MERGED_DP` added when codon merging fires. LoFreq output carries no FORMAT column at all and puts `DP`, `AF`, `SB`, and `DP4` in INFO instead" |
| 9 | "In a viral haploid context the convention has flattened to `1/1` for a confidently called variant" and "LGE's iVar lane uses `1/1` to stay compatible with downstream diploid-shaped tooling" | false | Every iVar row in the fixture writes a bare haploid `1`, not `1/1`. See `MN908947.3 23403 ... 1:2299:...` in `ivar.expected.vcf` | "LGE's iVar lane writes the haploid genotype `1` for a called variant, not the diploid-shaped `1/1`" |
| 10 | "A `QUAL` of `.` means the caller did not score the row, common in LGE-normalised iVar output" | true | Every row in `ivar.expected.vcf` has QUAL `.` | |
| 11 | "iVar natively emits a TSV with a `PASS` boolean, and LGE's conversion to VCF sets `QUAL` to `.`" | true | `ivar.expected.vcf` `##source=iVar 1.4.4 ... (TSV-to-VCF: Lungfish ...)`; `Sources/LungfishWorkflow/Variants/IVarTSVToVCFConverter.swift` | |
| 12 | "LGE supports four variant callers across its short-read and long-read lanes: iVar, LoFreq, Medaka, and Clair3." | false | Five. `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:5-11` `case lofreq, ivar, medaka, bcftools, clair3` | "LGE supports five variant callers across its short-read and long-read lanes: iVar, LoFreq, bcftools, Medaka, and Clair3" |
| 13 | FILTER table row "`ft` The row failed the allele-frequency threshold (typically `AF` below 0.05 or 0.10)" | changed | iVar's own header defines `ft` differently: `##FILTER=<ID=ft,Description="Fisher's exact test of variant frequency compared to mean error rate, p-value > 0.05">` (`ivar.expected.vcf`) | "`ft` The row failed iVar's Fisher exact test comparing the variant's frequency against the mean error rate (p-value above 0.05)" |
| 14 | FILTER table row "`sb` The row failed a strand-bias filter" | changed | No flag named `sb` appears in either fixture. LoFreq's strand-bias flag is `sb_fdr` (`##FILTER=<ID=sb_fdr,Description="Strand-Bias Multiple Testing Correction: fdr corr. pvalue > 0.001000">`), and iVar declares no strand-bias flag at all | "`sb_fdr` (LoFreq) The row failed the strand-bias false-discovery-rate correction: ALT support is lopsided across the strands" |
| 15 | FILTER table row "`bq` The row failed a base-quality filter: the supporting bases were low Phred quality." | true | `ivar.expected.vcf` `##FILTER=<ID=bq,Description="Bad quality variant: ALT_QUAL lower than 20">`. The chapter's gloss should name the 20 threshold | Add the threshold: "the supporting bases averaged below Phred 20" |
| 16 | FILTER table row "`q10` `QUAL` was below 10 (a 10% false-positive probability)." | false | No `q10` flag appears in either fixture, and neither caller declares one. LoFreq's quality flags are dynamically named `min_snvqual_NN` (for example `min_snvqual_53`, `min_snvqual_67`) and `min_indelqual_20`, plus `min_dp_10` for coverage | Replace with "`min_snvqual_NN` (LoFreq) The SNV's QUAL fell below the threshold LoFreq computed for that region; the number in the name is the threshold" and "`min_dp_10` (LoFreq) Fewer than ten reads covered the position" |
| 17 | "The quickest way to home in on confident calls is the `Presets > PASS` chip in the filter bar" | false | There is no `Presets > PASS` control. PASS is a smart-filter token chip labelled "PASS" (`Sources/LungfishApp/Views/Viewer/SmartFilterTokens.swift:16,52`). Named profiles live separately in `Sources/LungfishApp/Views/Viewer/FilterProfileManager.swift:39-69` as Clinical, Research, QC, and High Confidence | "The quickest way to home in on confident calls is the **PASS** filter chip, which hides every row whose `FILTER` is anything but `PASS`" |
| 18 | "iVar disables strand-bias filtering by default for exactly that reason, and the LGE iVar dialog ships with `Ignore strand bias` already on." | true | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:61` `ivarIgnoreStrandBias: Bool = true`; `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:179-180` labels the toggle "Ignore strand bias (recommended for amplicons)" | |
| 19 | "LGE exposes the threshold in every variant-calling dialog, so the choice stays visible." | true | `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:56` `TextField("0.05", text: $state.minimumAlleleFrequencyText)` | |
| 20 | "LGE's variant tracks carry that provenance in the Inspector." | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:32-84` | |
| 21 | "LGE's variant browser opens when you click any variant track in the project sidebar. It stacks three regions top to bottom." | true | `Sources/LungfishApp/Views/Viewer/VCFDatasetViewController.swift` plus the annotation table drawer compose a genome track, a reference panel, and a table | |
| 22 | "The genome track at the top draws each variant as a tick at its `POS`, colour-coded by `FILTER` (PASS rows in Creamsicle, non-PASS rows in Peach)." | changed | `Sources/LungfishApp/Views/Viewer/VariantTrackRenderer.swift` draws the ticks, but no PASS-versus-non-PASS Creamsicle/Peach split is defined there. The specific colour mapping is unverifiable from source | "The genome track at the top draws each variant as a tick at its `POS`." Drop the colour claim, or confirm it against the running app before restating it |
| 23 | "plus a few derived columns: the source caller, the gene name from any attached GFF3 annotation, the protein consequence where iVar's codon-merge applied" | true | `Sources/LungfishWorkflow/Variants/IVarCodonMerger.swift:33,73` merges codon-adjacent SNPs, and the fixture README records the N-gene 28881-28883 trio collapsing into one row | |
| 24 | "the Inspector populates with the per-variant detail: the full `INFO` field broken out one row per key, the `FORMAT` payload for the sample, any annotation context ..., and the row's provenance" | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift` plus the variant detail sections | |
| 25 | "LGE's variant browser starts unfiltered: every row in the VCF is on show." | true | `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView+Filtering.swift:394` `if !selectedVariantPresetByKey.isEmpty { return true }` implies an empty default filter set | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The other three built-in filter profiles: Clinical, Research, QC, High Confidence | `Sources/LungfishApp/Views/Viewer/FilterProfileManager.swift:38-69` |
| The other smart-filter tokens: SNV, Indel, High Impact, Moderate Impact, Rare Variant, Quality >= 30, Depth >= 10, ClinVar Pathogenic | `Sources/LungfishApp/Views/Viewer/SmartFilterTokens.swift:16-24` |
| Saving a custom filter profile | `Sources/LungfishApp/Views/Viewer/FilterProfileManager.swift:88` `saveCustomProfiles` |
| The Variant Query Builder sheet for structured queries | `Sources/LungfishApp/Views/Viewer/VariantQueryBuilderSheet.swift` |
| iVar consensus and codon-merge settings: consensus AF 0.75, merge AF threshold 0.25, bad-quality threshold 20 | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:59-61` |
| The minimum-depth setting on the variant-calling dialog | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:39` `minimumDepth: Int?` |
| The advanced-arguments passthrough on the variant-calling dialog | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:41` `advancedArguments: [String]` |
| The Medaka model setting | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:40` `medakaModel: String?` |
| The `variants` CLI command group | `cli-help/variants.txt` |
| VCF import profiles and semantics (`ultraLowMemory`, `viralFrequency`) | `Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:85-93` |
| iVar's `MERGED_AF` and `MERGED_DP` FORMAT keys | `ivar.expected.vcf` header lines |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter, but `features_refs` names `viewport.variant-browser` | No | The chapter devotes a full section to "How LGE renders a VCF" and describes three viewport regions, the PASS chip, and the Inspector. Every one of those needs a shot, and the missing shots are why the `Presets > PASS` error survived |
| Illustration `vcf-row-anatomy` | No | It labels a `GT:DP:AF` FORMAT and a `1/1` genotype. Both are wrong for LGE's iVar output. Redraw against the real `GT:DP:REF_DP:...:ALT_FREQ` shape with genotype `1` |
| Illustration `allele-frequency-haploid-vs-diploid` | Yes | The conceptual contrast is sound |
| Illustration `filter-flag-cartoon` | No | It shows `FILTER=ft` glossed as "failed allele-frequency threshold" and `FILTER=sb`. `ft` is a Fisher exact test flag and `sb` does not exist. Redraw with `PASS`, `ft` (Fisher exact test), and `bq` (bad quality) |

## 06-the-lungfish-project.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Front matter entry point "File > Open (Cmd-O)" | false | The menu item is titled "Open Project Folder..." (`Sources/LungfishApp/App/MainMenu.swift:177`) | "File > Open Project Folder... (Cmd-O)" |
| 2 | Front matter entry point "View > Show Sidebar (Cmd-Shift-S)" | false | `Sources/LungfishApp/App/MainMenu.swift:442` sets `keyEquivalentModifierMask = [.command, .control]` on the "s" key, so it is Control-Command-S | "View > Show Sidebar (Ctrl-Cmd-S)" |
| 3 | Front matter entry point "File > New Project (Cmd-N)" | true | `Sources/LungfishApp/App/MainMenu.swift:170` title "New Project", keyEquivalent "n" | |
| 4 | Front matter entry point "View > Show Inspector (Cmd-Opt-I)" | true | `Sources/LungfishApp/App/MainMenu.swift:448,453` title "Show Inspector", `[.command, .option]` on "i" | |
| 5 | Front matter entry point "Operations > Show Operations Panel (Cmd-Shift-P)" | true | `Sources/LungfishApp/App/MainMenu.swift:868,872` | |
| 6 | "A Lungfish Genome Explorer (LGE) project keeps imported files, derived bundles, and their provenance together in a project folder." | changed | It is a `.lungfish` directory bundle, and Finder shows it as a single item, not a plain folder (`Sources/LungfishCore/Storage/ProjectFile.swift:98`) | "A Lungfish Genome Explorer (LGE) project keeps imported files, derived bundles, and their provenance together in a `.lungfish` project bundle, a directory Finder shows as one item" |
| 7 | "Native projects also store the sequence catalog and version history in an internal project database." | true | `Sources/LungfishCore/Storage/ProjectFile.swift:15,27` `.project.db` hidden SQLite database for edit tracking and versioning | |
| 8 | "LGE also ships a command-line tool, `lungfish`, that mirrors most GUI actions." | false | The executable is `lungfish-cli` (`Sources/LungfishCore/CLICommandIdentity.swift:8`; every `cli-help/` banner reads `USAGE: lungfish-cli ...`) | "LGE also ships a command-line tool, `lungfish-cli`, that mirrors most GUI actions." |
| 9 | "**File > About Saving…** explains this behavior; there is no separate document Save or Save As command." | true | `Sources/LungfishApp/App/MainMenu.swift:200` adds "About Saving…"; the File menu (lines 162-285) contains no Save or Save As item | |
| 10 | "Project changes are stored when an import or edit completes successfully. Check the Operations Panel for running or failed work." | true | Close paraphrase of `Sources/LungfishApp/App/AppDelegate+PersistenceHelp.swift:11`, which says "Check Operations for running or failed work" | |
| 11 | "Lungfish remembers project windows and views when they close or the app quits." | true | `Sources/LungfishApp/App/AppDelegate+PersistenceHelp.swift:11` verbatim | |
| 12 | "**Create Project** makes a new empty project folder at a location you pick. Shortcut: `Cmd-N`." | true | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:626` `case createProject = "Create Project"`; `MainMenu.swift:170` binds Cmd-N | |
| 13 | "**Open Project** opens an existing project folder you choose from the file dialog. Shortcut: `Cmd-O`." | true | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:627` `case openProject = "Open Project"`; `MainMenu.swift:179` binds Cmd-O | |
| 14 | "**Recent Projects** lists the projects you opened lately." | true | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:657` `case recentProjects = "Recent Projects"`; the list caps at ten (line 26) | |
| 15 | "`File > New Project` and `File > Open` work from the menu bar" | false | The second item is "Open Project Folder..." (`Sources/LungfishApp/App/MainMenu.swift:177`) | "`File > New Project` and `File > Open Project Folder...` work from the menu bar" |
| 16 | "The menu items use the macOS names 'New' and 'Open', while the Welcome window cards say 'Create Project' and 'Open Project'." | false | The menu items are "New Project" and "Open Project Folder...", not "New" and "Open" (`MainMenu.swift:170,177`) | "The menu items read 'New Project' and 'Open Project Folder...', while the Welcome window cards say 'Create Project' and 'Open Project'. Same actions, different wording" |
| 17 | "You can open projects with built-in viewers before installing external tools. Actions that need tools retain their setup requirements." | true | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:847` "Open projects with built-in viewers before installing tools. Analyses that need external tools will show their setup requirements." | |
| 18 | "Opening waits while an installation or storage change is in progress." | true | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:884` "Wait for the current installation or storage change to finish before opening a project." | |
| 19 | "If the sidebar is not visible, choose `View > Show Sidebar` or press `Cmd-Shift-S`." | false | The shortcut is Control-Command-S (`Sources/LungfishApp/App/MainMenu.swift:442`) | "If the sidebar is not visible, choose `View > Show Sidebar` or press `Ctrl-Cmd-S`." |
| 20 | "The project folder now exists on disk at `~/Documents/SARS-CoV-2 SRR36291587/`." | false | The path carries the `.lungfish` extension, since `ProjectFile.create` appends it when absent (`Sources/LungfishCore/Storage/ProjectFile.swift:135-137`) | "The project bundle now exists on disk at `~/Documents/SARS-CoV-2 SRR36291587.lungfish/`." |
| 21 | "LGE keeps no hidden state outside that folder for this project's data." | changed | True for project data, but the shared managed-storage root holds tool packs and databases the project references, and the recent-projects list lives in user defaults (`Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:99-121`) | "LGE keeps no hidden state outside that bundle for this project's data. Tool packs and reference databases are shared machine-wide and live elsewhere" |
| 22 | "**Imports/** holds anything you brought in from a local file on your Mac" | true | `Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift:435`; `Sources/LungfishApp/App/AppDelegate+ImportCenter.swift:706` | |
| 23 | "**Downloads/** holds anything LGE fetched from the internet" | true | `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift:1949-1958`; `Sources/LungfishWorkflow/ViralRecon/ViralReconReferenceCatalog.swift:19` | |
| 24 | "**Reference Sequences/** holds reference bundles, each carrying the extension `.lungfishref`." | true | `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift:20,105-106` | |
| 25 | "**Assemblies/** holds de novo assembly bundles, also `.lungfishref`." | true | `docs/user-manual/chapters/07-assembly/02-running-spades.md:67` names the folder, and assembly output is bundled the same way | |
| 26 | "**Primer Schemes/** holds amplicon primer-scheme bundles with the extension `.lungfishprimers`." | true | `Sources/LungfishIO/Bundles/PrimerSchemesFolder.swift:12,19,66` | |
| 27 | "**Analyses/** holds the outputs that do not naturally attach to a reference or assembly bundle" | true | `Sources/LungfishIO/Bundles/AnalysesFolder.swift:18` `public static let directoryName = "Analyses"`; `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift:107-115` | |
| 28 | "Each analysis lives in its own timestamped subfolder with its own provenance sidecar." | true | `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift:672,717` `AnalysesFolder.formatTimestamp(info.timestamp)` | |
| 29 | "Every download lands with a provenance sidecar recording the URL, the accession, the timestamp, and the checksum." | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:348` prints `sha256 <checksum>`; the fixture ships `MN908947.3.gff3.lungfish-provenance.json` | |
| 30 | "It is a directory holding a `manifest.json` at the root, a primary FASTA, an index, optional annotations, optional attached tracks, and a `provenance/` subfolder." | changed | `Sources/LungfishCore/Bundles/BundleManifest.swift:79-93` puts the FASTA and its indexes under `genome/`, annotations under `annotations/`, variants under `variants/`, and signal tracks under `tracks/`. Only `manifest.json` sits at the root | "It is a directory holding a `manifest.json` at the root, a `genome/` folder with the bgzip-compressed FASTA and its indexes, and optional `annotations/`, `variants/`, and `tracks/` folders alongside a provenance record" |
| 31 | "Right-click any bundle in Finder and choose **Show Package Contents** to look inside." | true | `.lungfishref` is a directory bundle; Finder exposes Show Package Contents for it | |
| 32 | "A search field sits at the top of the sidebar ... a small spinner and a 'Searching project' label appear just below the field." | changed | The label reads "Searching project…" with a trailing ellipsis (`Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift:313`) | "a small spinner and a 'Searching project…' label appear just below the field" |
| 33 | "A Scope selector narrows the search to one kind of data: All Project Data, EsViritu, Kraken/Bracken, TaxTriage, FASTQ Datasets, VCF + Reference, or JSON Manifests." | true | `Sources/LungfishApp/Views/Sidebar/UniversalSearchAdvancedPopoverController.swift:22-28` gives exactly those seven labels in that order | |
| 34 | "structured fields filter by Keywords, Virus, Family, Species, and Sample, by Min Unique Reads and Min and Max Total Reads, and by a Date From and Date To range" | true | `Sources/LungfishApp/Views/Sidebar/UniversalSearchAdvancedPopoverController.swift:96-108` lists Scope, Keywords, Virus, Family, Species, Sample, Min Unique Reads, Min Total Reads, Max Total Reads, Date From, Date To | |
| 35 | "A 'High-confidence pathogens only' checkbox restricts results to flagged pathogens." | true | `Sources/LungfishApp/Views/Sidebar/UniversalSearchAdvancedPopoverController.swift:76` verbatim checkbox title | |
| 36 | "**Apply** writes the assembled query into the sidebar search field and runs it. **Clear** empties both the popover and the field." | true | `Sources/LungfishApp/Views/Sidebar/UniversalSearchAdvancedPopoverController.swift:78-79,222,226` | |
| 37 | "A fourth surface, the Operations Panel, opens in its own window from the **Operations** menu" | true | `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift:15,18` is an `NSWindowController` building its own `NSWindow` | |
| 38 | "The panel covers the current session only." | true | `Sources/LungfishKit/OperationCenter.swift` holds items in memory with no persistence path | |
| 39 | "**Clear Completed** at the bottom removes finished rows" | true | `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift:396` `NSButton(title: "Clear Completed", ...)` in the footer (line 97) | |
| 40 | "The context menu offers ... **Copy CLI Command**, **Copy Log**, **View Log**, **Reveal Log in Finder**, and **Cancel**." | changed | `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift:1502-1580` builds the menu conditionally and can also add **Run Again…** at the top when a replay source exists (line 1510), and **Clear** in place of Cancel on a finished non-cancellable row (line 1577) | "The context menu offers **Run Again…** when the row can be replayed, then **Copy CLI Command**, **Copy Log**, **View Log**, **Reveal Log in Finder**, and either **Cancel** on a running row or **Clear** on a finished one" |
| 41 | "**Copy Failure Report** and **Open GitHub Issue** replace **Cancel** on failed rows." | changed | Both appear on failed rows (lines 1543-1551), and a third, **Reveal Failure Report in Finder**, appears when the report file exists (lines 1556-1564). What replaces Cancel on a failed row is **Clear** (line 1577), since a failed row is not cancellable | "Failed rows add **Copy Failure Report**, **Open GitHub Issue**, and, once the report file is written, **Reveal Failure Report in Finder**. Cancel gives way to **Clear**" |
| 42 | "**Copy Failure Report** gathers the operation title, the CLI command, the error message, the error detail, and the log into one text block" | true | `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift:1466` builds the report and appends retry metadata as well | |
| 43 | "You can also press `Cmd-Period` with the row selected." | changed | No Cmd-Period binding appears in `OperationsPanelController.swift` or in the Operations menu (`MainMenu.swift:860-895`). The menu offers **Cancel All Operations** with no key equivalent (line 885) | Drop the Cmd-Period sentence, or verify it against the running app before restating it |
| 44 | "choose `Help > Lungfish Genome Explorer Help` to open it in your default browser" | false | It opens the macOS Help Book in Help Viewer, falling back to an in-app help window, never the default browser (`Sources/LungfishApp/App/AppDelegate+MenuActions.swift:842-856` `HelpBookIntegration.openTopic(topicID)` then `HelpWindowController`) | "choose `Help > Lungfish Genome Explorer Help` to open it in the macOS Help Viewer" |
| 45 | "`Help > Report an Issue...` opens a pre-filled GitHub issue template that includes the version string" | true | `Sources/LungfishApp/App/MainMenu.swift:1026` "Report an Issue..."; the reporter includes `LungfishAppVersion.short` | |
| 46 | "Select a paired-end FASTQ bundle in `Imports/` and the Inspector shows the read count, the average length, the per-base quality summary, and a button to run a classification or a mapping." | true | `Sources/LungfishIO/Formats/FASTQ/FASTQStatisticsCollector.swift` supplies the statistics; `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift` supplies the actions | |
| 47 | "Exports create separate files. Sequence and annotation exports use an explicit sidebar selection before falling back to the current document." | true | `Sources/LungfishApp/App/MainMenu.swift:220-233` wires `exportFASTA` and `exportGFF3`; the selection-first behaviour is in `FileMenuActions` | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| **File > Import Center… (Cmd-Shift-I)**, the main import surface | `Sources/LungfishApp/App/MainMenu.swift:206-212` |
| **File > Manage Project Storage…**, project-scoped storage review and safe Trash cleanup | `Sources/LungfishApp/App/MainMenu.swift:275-283`; `Sources/LungfishApp/Views/ProjectStorage/ProjectStorageSheetViewModel.swift` |
| The rest of the File > Export menu: Sequences (FASTA/GenBank), Annotations (GFF3), FASTQ, Project Sample Metadata (CSV), Image (PNG), Image (PDF) | `Sources/LungfishApp/App/MainMenu.swift:220-256` |
| **File > Open Recent** submenu | `Sources/LungfishApp/App/MainMenu.swift:182-187` |
| **View > Focus Viewer (Cmd-Opt-F)** and **View > Restore Side Panes (Ctrl-Cmd-Opt-F)** | `Sources/LungfishApp/App/MainMenu.swift:465-478` |
| **Operations > Cancel All Operations** | `Sources/LungfishApp/App/MainMenu.swift:884-890` |
| **Tools > Workflow Library…** | `Sources/LungfishApp/App/MainMenu.swift:765-771` |
| The other Help items: Getting Started, VCF Variants Guide, AI Assistant Guide, Documentation, Release Notes | `Sources/LungfishApp/App/MainMenu.swift:993-1024` |
| `Extractions/` project folder, where read and region extractions land | `Sources/LungfishApp/Views/Viewer/ViewerViewController+Extraction.swift:575` |
| `Haplotype Definitions/` project folder | `Sources/LungfishIO/Bundles/HaplotypeDefinitionStore.swift:18` |
| Project locking for shared storage, and lock recovery | `Sources/LungfishCore/Storage/ProjectLock.swift`; `Sources/LungfishCore/Storage/ProjectLockRecovery.swift`; `cli-help/project.txt` `lock`, `unlock`, `--mode`, `--force` |
| Project bundle migration | `cli-help/project.txt` `project migrate` with `--dry-run` |
| The "Analyses" sidebar group is synthetic, prepended when results exist, not always a real folder | `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift:107-115` |
| The recent-projects list caps at ten entries | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:26` |
| The Welcome window's setup panel, tool-status cards, and "Choose Another Storage Location" flow | `Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift:1265-1520` |
| The project's hidden `.project.db` and `metadata.json` | `Sources/LungfishCore/Storage/ProjectFile.swift:15-16,392-399` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- SHOT: welcome-window -->` | Yes | Create Project, Open Project, and Recent Projects are all verified. The caption is accurate |
| `<!-- SHOT: empty-project-window -->` | Yes | Three-pane layout is correct. Retake only if the window title now shows the `.lungfish` extension differently from the caption |
| `<!-- SHOT: sidebar-folder-conventions -->` | Retake | The caption lists Analyses, Downloads, Imports, Multiple Sequence Alignments, Phylogenetic Trees, Reference Sequences, and Workflows, but omits Extractions and Primer Schemes, and the corrected text adds them. A shot that shows Extractions would settle it |
| `<!-- SHOT: inspector-fastq-selected -->` | Yes | The described Inspector regions match the FASTQ sections in source |
| `<!-- SHOT: inspector-fastq-detail -->` | Yes | Read counts, length and quality statistics, ingestion settings, pipeline, and metadata all exist |
| `<!-- SHOT: operations-panel-row -->` | Yes | Expanded row with CLI command, View Log, Reveal in Finder, log output, and progress is accurate |
| `<!-- SHOT: operations-panel-right-click-menu -->` | Retake | The caption omits **Run Again…** and says Copy Failure Report and Open GitHub Issue appear "in place of Cancel". A failed row shows **Clear**, not the absence of Cancel, and can also show **Reveal Failure Report in Finder** |
| New shot needed: File > Export menu with the Provenance submenu | Missing | Chapter 08 leans on it, and chapter 06's Exports section never shows the menu |

## 07-plugin-packs.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Front matter entry point "Tools > Plugin Manager (Cmd-Shift-B)" | true | `Sources/LungfishApp/App/MainMenu.swift:775,779` title "Plugin Manager…", `[.command, .shift]` on "b" | |
| 2 | "The `read-mapping` pack hands you four read mappers, `minimap2`, `BWA-MEM2`, `Bowtie2`, and `BBMap`, plus `samtools`" | false | The pack holds three mappers and no samtools. `Sources/LungfishWorkflow/Conda/PluginPack.swift:474-524` lists `packages: ["minimap2", "bwa-mem2", "bowtie2"]` with matching requirements, and `third-party-tools-lock.json` `packTools` confirms `read-mapping -> ['minimap2', 'bwa-mem2', 'bowtie2']`. BBMap arrives via `bbtools` and samtools via `samtools`, both in the Required Setup pack (`third-party-tools-lock.json` `tools`) | "The `read-mapping` pack hands you three read mappers, `minimap2`, `BWA-MEM2`, and `Bowtie2`. BBMap and `samtools` come with the Required Setup pack, so they are already there" |
| 3 | "The `variant-calling` pack hands you four variant callers, iVar, LoFreq, Medaka, and Clair3, alongside `bcftools` for working with VCF files and the indexing utilities they depend on." | changed | The four callers are right (`Sources/LungfishWorkflow/Conda/PluginPack.swift:569` `packages: ["lofreq", "ivar", "medaka", "clair3"]`), but bcftools and htslib are Required Setup tools, not pack members (`third-party-tools-lock.json` `tools` includes `bcftools` and `htslib`) | "The `variant-calling` pack hands you four variant callers, iVar, LoFreq, Medaka, and Clair3. `bcftools` and the htslib indexing utilities come with the Required Setup pack" |
| 4 | "The packs live in a hidden directory in your home folder and are shared across every LGE project on the machine." | true | `Sources/LungfishWorkflow/Conda/CondaManager.swift:128` "All conda data is stored in `~/.lungfish/conda/`" | |
| 5 | "Plugin packs run on macOS 26 Tahoe or later, on Apple Silicon Macs." | true | `Sources/LungfishApp/App/HardwareRequirements.swift:8-9` "Minimum macOS 26 Tahoe", "Apple Silicon required" | |
| 6 | "The About window states the same hardware floor: macOS 26 Tahoe or later, Apple Silicon, 16 GB RAM minimum, 32 GB RAM recommended for metagenomics and assembly, and 100 GB free disk recommended for a working set of tool packs, databases, and projects." | true | `Sources/LungfishApp/App/HardwareRequirements.swift:8-12` matches on every line. The app string reads "100 GB free disk recommended for tool packs, databases, and projects", so "a working set of" is the chapter's own addition | |
| 7 | "Keep at least 50 GB of free disk before installing packs" | changed | The app's only stated disk figure is 100 GB recommended (`HardwareRequirements.swift:12`). The 50 GB floor is unsourced and sits oddly beside the 100 GB the same section quotes | "Keep well clear of a full disk before installing packs, and follow the app's own 100 GB recommendation where you can" |
| 8 | "The storage-location settings live in the Plugin Manager's Databases tab." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:984` `Button("Storage Settings...")` sits in the Databases tab body | |
| 9 | Pack table row "`read-mapping` minimap2, BWA-MEM2, Bowtie2, BBMap, samtools" | false | Same evidence as row 2 | "`read-mapping` minimap2, BWA-MEM2, Bowtie2" |
| 10 | Pack table row "`variant-calling` iVar, LoFreq, Medaka, Clair3, bcftools, tabix, bgzip" | false | Same evidence as row 3 | "`variant-calling` iVar, LoFreq, Medaka, Clair3" |
| 11 | Pack table row "`gatk-core` GATK4" | true | `Sources/LungfishWorkflow/Conda/PluginPack.swift:617-642` `packages: ["gatk4"]`. It is also marked `isExperimental: true` (line 626), which the chapter never says | Add that `gatk-core` is experimental |
| 12 | Pack table row "`phasing` WhatsHap" | true | `Sources/LungfishWorkflow/Conda/PluginPack.swift:643-667` `packages: ["whatshap"]`, display name "Variant Phasing", also `isExperimental: true` (line 652) | Add that `phasing` is experimental |
| 13 | Pack table row "`classification-kraken2` Kraken2, KrakenTools" | false | No such pack exists. Kraken2 and Bracken live in the `metagenomics` pack (`Sources/LungfishWorkflow/Conda/PluginPack.swift:771-822`, `packages: ["kraken2", "bracken", "esviritu", "ribodetector"]`) | Replace the four `classification-*` rows with one row: "`metagenomics` Kraken2, Bracken, EsViritu, RiboDetector" |
| 14 | Pack table row "`classification-esviritu` EsViritu and its references" | false | Same evidence. EsViritu is in the `metagenomics` pack; its database is a separate Databases-tab item (`third-party-tools-lock.json` `databases` id `esviritu-viral-v3`) | Folded into the `metagenomics` row above |
| 15 | Pack table row "`classification-taxtriage` TaxTriage workflow tools" | false | No pack with this id or any TaxTriage pack tool exists in `Sources/LungfishWorkflow/Conda/PluginPack.swift` or in `third-party-tools-lock.json` `packTools` | Remove the row |
| 16 | Pack table row "`classification-naomgs` NAO-MGS pipeline tools" | false | No pack with this id exists in either source | Remove the row |
| 17 | Pack table row "`wastewater-surveillance` Freyja" | changed | The pack exists and its only pack tool is Freyja (`third-party-tools-lock.json` `packTools` `wastewater-surveillance -> ['freyja']`), but its declared packages are `["freyja", "ivar", "pangolin", "nextclade", "minimap2"]` (`PluginPack.swift:838`) and it is `isExperimental: true` (line 841) | "`wastewater-surveillance` Freyja (experimental)" |
| 18 | Pack table row "`assembly` SPAdes, MEGAHIT, SKESA, Flye, Hifiasm" | true | `Sources/LungfishWorkflow/Conda/PluginPack.swift:668-719` `packages: ["spades", "megahit", "skesa", "flye", "hifiasm"]`, display name "Genome Assembly" | |
| 19 | Pack table row "`read-qc` fastp" | false | No `read-qc` pack exists. fastp is a Required Setup tool (`third-party-tools-lock.json` `tools` includes `fastp`). The QC-shaped pack is `illumina-qc` with fastqc, multiqc, and trimmomatic (`PluginPack.swift:464-471`), and it declares no requirements and is not `isActive` | Remove the row. Say instead that fastp arrives with Required Setup |
| 20 | Pack table row "`decontamination` Deacon, RiboDetector" | false | No `decontamination` pack exists. Deacon is a Required Setup tool (`third-party-tools-lock.json` `tools` includes `deacon`), and RiboDetector is in the `metagenomics` pack (`PluginPack.swift:783-822`) | Remove the row. Deacon is Required Setup; RiboDetector is in `metagenomics` |
| 21 | "A typical pack install pulls 100 MB to 300 MB across the wire and finishes in 30 seconds to 3 minutes" | changed | `Sources/LungfishWorkflow/Conda/PluginPack.swift:524` gives `read-mapping` an `estimatedSizeMB: 260`, but `illumina-qc` is 1000 (line 470) and `long-read` is 700 (line 830). The Required Setup pack is 2700 (line 435) | "A typical optional pack install pulls a few hundred megabytes, though the larger ones run to 1 GB. The Required Setup pack is the biggest at roughly 2.7 GB" |
| 22 | "`gatk-core` runs larger than the viral caller packs, because GATK4 ships as a Java toolkit with its own runtime. Budget roughly 600 MB of installed space for it." | changed | `Sources/LungfishWorkflow/Conda/PluginPack.swift:617-642` sets no `estimatedSizeMB` for `gatk-core`, so 600 MB is unsourced | "`gatk-core` runs larger than the viral caller packs, because GATK4 ships as a Java toolkit with its own runtime" |
| 23 | "Three tabs run across the top. **Installed** lists every tool LGE currently knows about. **Packs** holds the themed groups of tools. **Databases** holds the reference databases" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:22-31` defines exactly the three tabs installed, packs, databases | |
| 24 | "every tool wears one of four status labels. **Ready** ... **Needs install** ... **Needs reinstall** ... **Storage unavailable**" | true | `Sources/LungfishWorkflow/Conda/PluginPackStatusService.swift:70-82` returns exactly "Storage unavailable", "Ready", "Needs reinstall", "Needs install" in that precedence | |
| 25 | "Click **Install** next to a pack to start, or **Install All** when several tools in it are missing." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:576` chooses `"Install"` for the required-setup pack and `"Install All"` otherwise | |
| 26 | "Each optional pack that is already installed shows a **Remove All** button in place of Install." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:571-576,672-676` | |
| 27 | "The Required Setup pack has no Remove All, since LGE leans on it to run." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:576` branches on `pack.isRequiredBeforeLaunch`, and the `.removeAll` action is not offered for it | |
| 28 | "The **Packs** tab ... Required Setup section at the top ... Below it, optional packs" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:451,477` render the section headings "Required Setup" and "Optional Tools". The chapter never names the second heading | Name the second section "Optional Tools" |
| 29 | "The **Installed** tab lists every managed environment LGE has built, one per tool. Click a row to expand it and read the exact packages and their versions" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:341,379` show a package count and a "Loading packages..." expansion | |
| 30 | "Each row also carries a **Remove** button that deletes that single environment" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:355` `label: { Text("Remove") }` | |
| 31 | "LGE hides these from the tool list and gathers them into an **Orphaned Environments** row that reports how many it found. Its **Remove** button clears them in one pass" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:218-224,273-301` `OrphanedEnvironmentRecoveryRow` with `Text("Orphaned Environments")` and a Remove button | |
| 32 | "Every pack card on the **Packs** tab shows two greyed command lines and a **Copy** button" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:747,753,762` render `exportCommand`, `installCommand`, and a `Button("Copy")` | |
| 33 | Offline command block `lungfish conda export-pack --pack read-mapping --output ./read-mapping-conda-offline-pack.tgz` | false | The generated command uses `lungfish-cli`, not `lungfish`. `Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift:511-519` builds it from `CLICommandIdentity.executableName`, which is `"lungfish-cli"` (`Sources/LungfishCore/CLICommandIdentity.swift:8`). The pack id, flags, and archive name are otherwise exact (line 510 `"./\(pack.id)-conda-offline-pack.tgz"`) | `lungfish-cli conda export-pack --pack read-mapping --output ./read-mapping-conda-offline-pack.tgz` |
| 34 | Offline command block `lungfish conda install --offline --from-bundle ./read-mapping-conda-offline-pack.tgz` | false | Same evidence; `Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift:520-527` | `lungfish-cli conda install --offline --from-bundle ./read-mapping-conda-offline-pack.tgz` |
| 35 | "The Copy button fills in whichever pack you are looking at, so the archive name always matches its pack id." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift:510` interpolates `pack.id` into the archive path | |
| 36 | "Each row shows the database's size, its RAM requirement, its install state or a **Download** action ..., the install date, the version, and whether the local copy is **Up to date**." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:1043-1054,1215-1245` render Recommended, Update available, Installed, Update, Remove, Download | |
| 37 | "A 'Recommended for your system' banner at the top of the Databases tab points to the database that best fits your Mac's RAM." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:858` `Text("Recommended for your system (\(formatRAM(viewModel.systemRAMBytes)) RAM): ")` | |
| 38 | "Any database whose RAM requirement outstrips your system reads '(exceeds system RAM)' inline" | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:1077` `Text("(exceeds system RAM)")` | |
| 39 | "While a database is downloading, its row shows a progress bar with a **Cancel** button." | true | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:1178,1209` downloading state plus `label: { Text("Cancel") }` | |
| 40 | "you get an error like 'missing tool: minimap2. Install the `read-mapping` plugin pack.'" | changed | The real message reads "minimap2 is not installed. Install the read-mapping plugin pack first." (`Sources/LungfishWorkflow/Mapping/ManagedMappingPipeline.swift:56`) | "you get 'minimap2 is not installed. Install the read-mapping plugin pack first.'" |
| 41 | "A full set of the packs in the table above lands in the 1 to 3 GB range" | changed | The table itself is wrong (rows 13 to 20), and the Required Setup pack alone is 2,700 MB (`PluginPack.swift:435`), with `illumina-qc` at 1,000 and `long-read` at 700 | "Required Setup alone is roughly 2.7 GB, and a full set of the optional packs adds a few gigabytes on top" |
| 42 | "LGE reads the `LUNGFISH_CONDA_ROOT` environment variable to make this work." | true | `Sources/LungfishCore/Storage/ManagedStorageConfigStore.swift:126,185` | |
| 43 | "To relocate the whole managed storage root ... set `LUNGFISH_STORAGE_ROOT` instead. `LUNGFISH_CONDA_ROOT` still takes priority for the conda install location when both are set." | true | `Sources/LungfishCore/Storage/ManagedStorageConfigStore.swift:155,185` reads `LUNGFISH_STORAGE_ROOT` first for the storage root and `LUNGFISH_CONDA_ROOT` for the conda root, so the conda override wins for that location | |
| 44 | "LGE's pack and database operations take an exclusive lock on the install root, so a second install waits its turn" | true | `Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift` | |
| 45 | "LGE stops with `install root is read-only; reinstall as the admin user`." | false | The message is "conda root is read-only; reinstall as the admin user" (`Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift:12`) | "LGE stops with `conda root is read-only; reinstall as the admin user`." |
| 46 | "tools such as Kraken2 load the active database straight into RAM" | true | The Databases tab tracks a per-database RAM requirement precisely because of this (`PluginPackView.swift:1077`) | |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Required Setup pack's actual contents: 17 tools including nextflow, snakemake, bbtools, fastp, deacon, samtools, bcftools, htslib, seqkit, cutadapt, trim_galore, vsearch, pigz, sra-tools, pysam | `third-party-tools-lock.json` `tools` list |
| The `full-length-mhc-genotyping` pack (Savont, BLAST) | `Sources/LungfishWorkflow/Conda/PluginPack.swift:527-563` |
| The `multiple-sequence-alignment` pack (MAFFT) | `Sources/LungfishWorkflow/Conda/PluginPack.swift:720-745` |
| The `phylogenetics` pack (IQ-TREE) | `Sources/LungfishWorkflow/Conda/PluginPack.swift:746-770` |
| The `long-read`, `rna-seq`, `single-cell`, `amplicon-analysis`, `genome-annotation`, and `data-format-utils` packs | `Sources/LungfishWorkflow/Conda/PluginPack.swift:823-960` |
| Which packs are experimental (`gatk-core`, `phasing`, `wastewater-surveillance`) | `PluginPack.swift:626,652,841` `isExperimental: true` |
| The nine Kraken2 databases by name: Standard, Standard-8, Standard-16, PlusPF, PlusPF-8, PlusPF-16, Viral, MinusB, EuPathDB46 | `third-party-tools-lock.json` `databases` |
| The locally built SILVA and Greengenes Kraken2 databases | `third-party-tools-lock.json` `databases` ids `kraken2-special-silva`, `kraken2-special-greengenes` |
| The human-decontamination databases: Human Read Scrubber, Deacon panhuman, Deacon ribokmers | `third-party-tools-lock.json` `databases` ids `human-scrubber`, `deacon-panhuman`, `deacon-ribokmers` |
| **Check for Tool Updates…** on the Installed tab | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:172` |
| **Refresh** on the Databases tab and the total-storage-used readout | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:851,993` |
| Post-install hooks a pack can declare, and the count shown on its card | `Sources/LungfishApp/Views/PluginManager/PluginManagerView.swift:726` |
| The `conda` CLI command group beyond the two offline commands | `cli-help/conda.txt` |
| The `tools` and `provision-tools` CLI command groups | `cli-help/tools.txt`, `cli-help/provision-tools.txt` |
| The lock manifest's `version` field tracks the app version, currently 2026.9.13 | `third-party-tools-lock.json` top-level `version` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- SHOT: plugin-manager-window -->` | Retake | The caption says "the Read Mapping pack with all three mappers ready", which is right, but the chapter body around it claims four mappers plus samtools. Once the body is corrected the shot should be retaken to show the corrected pack contents and the "Optional Tools" section heading |
| `<!-- SHOT: plugin-manager-databases-tab -->` | Yes | The caption's database names (EuPathDB46, MinusB, PlusPF, PlusPF-16, PlusPF-8, Standard, Standard-8, Standard-16, Viral, EsViritu Viral DB, NCBI Taxonomy) all match `third-party-tools-lock.json` exactly, and the "Recommended for your system" banner is verified |
| New shot needed: the Installed tab with an expanded environment row | Missing | The chapter devotes a whole subsection to it with no shot |
| New shot needed: a pack card's two greyed offline command lines and Copy button | Missing | The offline procedure is the one place the chapter asks the reader to type, and its commands were wrong |

## 08-provenance-and-reproducibility.md

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Front matter entry point "Inspector > Provenance tab" | false | Provenance is a section in the Inspector, built from `DisclosureGroup`s, not a tab (`Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:32-84,93`) | "Inspector > Provenance section" |
| 2 | Front matter entry point "File > Export > Provenance" | true | `Sources/LungfishApp/App/MainMenu.swift:259-271` builds a "Provenance" submenu inside the Export submenu | |
| 3 | "One of its tabs, **Provenance**, holds the run record for that result." | false | Same evidence as row 1 | "One of its sections, **Provenance**, holds the run record for that result." |
| 4 | "**Run Summary** names the workflow, the tool, and its version, with the start time and how long the run took." | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:32,155-159` shows Tool, Created, Exit Status, and Wall Time | |
| 5 | "**Inputs** lists every file the run read. **Outputs** lists every file it produced." | false | There are no top-level Inputs and Outputs sections. Run Summary shows *counts* (`ProvenanceSection.swift:162-163` `summaryRow("Inputs", ...)`, `summaryRow("Outputs", ...)`), the file lists live under a single **Files & Outputs** section (line 59), and per-step Inputs and Outputs appear inside each Lineage step (lines 290,293) | "**Files & Outputs** lists the files the run read and produced, and Run Summary carries their counts. Each step inside Lineage carries its own Inputs and Outputs lists" |
| 6 | "**Warnings** surfaces any non-fatal notes the tool emitted." | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:40-49`, shown only when warnings exist | |
| 7 | "**Lineage** traces the chain of earlier steps that produced this run's inputs, so you can click backward through the workflow." | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:52-57,283-310` numbered, expandable steps | |
| 8 | "The tab breaks into sections you can scan top to bottom." | changed | There are seven sections, and the chapter names only five. The full list is Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON (`ProvenanceSection.swift:32-84`) | "The section breaks into blocks you can scan top to bottom: Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON" |
| 9 | "The Provenance submenu offers six formats" | true | `Sources/LungfishApp/App/MainMenu.swift:1079-1116` `ProvenanceExportMenuModel.items` has six entries; `cli-help/provenance.txt` `--format` accepts "shell, python, nextflow, snakemake, methods, json" | |
| 10 | Format table rows "Shell Script", "Python Script", "Nextflow Pipeline", "Snakemake Workflow", "Methods Section", "Full Provenance" | changed | Five titles are exact. The sixth menu item is titled "Full Provenance (JSON)…", not "Full Provenance" (`Sources/LungfishApp/App/MainMenu.swift:1112`) | Rename the last row "Full Provenance (JSON)" |
| 11 | "split into a runnable-script group and a human-readable group" | true | `Sources/LungfishApp/App/MainMenu.swift:263-268` adds the first four items, then a separator, then the remaining two | |
| 12 | "A `run.sh` bash script that re-runs every step in order" | changed | The export format is `.shell` (`Sources/LungfishWorkflow/Provenance/ProvenanceExporter.swift:11`), but the file name `run.sh` is not set in `ProvenanceExporter.swift` and cannot be confirmed from source | Drop the exact file name, or confirm it by running an export before restating it |
| 13 | "A `reproduce.py` that drives the same tool calls programmatically" | changed | Same reasoning as row 12; the file name is unsourced | Drop the exact file name, or confirm it before restating it |
| 14 | "Each export is a folder. Inside sits the primary artifact you chose ... alongside a `provenance/` directory carrying the per-step records" | true | `cli-help/provenance.txt` `provenance export` takes `--output <output> Output directory for the export bundle`, and `Sources/LungfishApp/Views/Inspector/InspectorViewController+Notifications.swift:458` calls `ProvenanceExporter().exportBundle` | |
| 15 | "If your collaborator also runs LGE, you need not export at all. A project is just a folder on disk. Hand over the folder directly" | changed | A project is a `.lungfish` directory bundle, and shared-storage handoff has real coordination machinery the sentence glosses over (`cli-help/project.txt` `lock`, `unlock`, `migrate`) | "If your collaborator also runs LGE, you need not export at all. Hand over the `.lungfish` project bundle directly, or share it on lab storage. On shared storage use `lungfish-cli project lock` so two people cannot run advanced workflows against it at once" |
| 16 | "`lungfish provenance verify` checks a signed provenance sidecar against its signature." | false | The executable is `lungfish-cli` (`cli-help/provenance.txt` `USAGE: lungfish-cli provenance verify <file> ...`) | "`lungfish-cli provenance verify` checks a signed provenance sidecar against its signature." |
| 17 | Code block `lungfish provenance verify ~/Projects/SARS-CoV-2.lungfish` | false | Same evidence | `lungfish-cli provenance verify ~/Projects/SARS-CoV-2.lungfish` |
| 18 | "By default it looks for the signature beside the sidecar at `<sidecar>.signature.json` and the public key at `<sidecar>.pub`; pass `--signature` or `--public-key` to point elsewhere." | true | `cli-help/provenance.txt` `provenance verify` options: "Signature artifact path; defaults to <sidecar>.signature.json" and "Public key artifact path; defaults to <sidecar>.pub" | |
| 19 | "Point it at a sidecar file, a bundle, or an output directory" | true | `cli-help/provenance.txt` `<file> Provenance sidecar file, bundle, or output directory` | |
| 20 | "On success it prints `Signature valid` along with the signing provider, the provenance SHA-256, and the two artifact paths it checked." | changed | The help text does not state the success output, and it is not in the sources consulted. Unverifiable without running verify against a signed sidecar | Confirm the exact success line by running verify against a signed sidecar, or soften to "On success it reports that the signature is valid and names what it checked" |
| 21 | "`lungfish provenance bibliography` reads a bundle's provenance and prints a citation for every tool it recognizes" | false | The executable is `lungfish-cli` (`cli-help/provenance.txt` `USAGE: lungfish-cli provenance bibliography <bundle>`). The behaviour matches the overview "Generate a citation list from a bundle's provenance" | "`lungfish-cli provenance bibliography` reads a bundle's provenance and prints a citation for every tool it recognizes" |
| 22 | Code block `lungfish provenance bibliography ~/Projects/SARS-CoV-2.lungfish` | false | Same evidence | `lungfish-cli provenance bibliography ~/Projects/SARS-CoV-2.lungfish` |
| 23 | "Tools the catalog does not recognize are listed separately under a 'Tools without known citations' heading" | changed | Not stated in `cli-help/provenance.txt`, which gives only the one-line overview and the `<bundle>` argument. Unverifiable from the help dump | Confirm the exact heading by running the command against a bundle, or drop the quoted heading |
| 24 | "Two more `provenance` subcommands run from the command line ... Neither has a menu equivalent" | true | `cli-help/provenance.txt` lists three subcommands: bibliography, export, verify. Only `export` has a menu counterpart (`Sources/LungfishApp/App/MainMenu.swift:259-271`) | |
| 25 | "LGE offers a Provenance Signing option in `Settings > General`, set to Off by default." | true | `Sources/LungfishApp/Views/Settings/GeneralSettingsTab.swift:109` `Section("Provenance Signing")`; `Sources/LungfishCore/Models/AppSettings.swift:220` `public var provenanceSigningProvider: String = "off"` | |
| 26 | "The Local and Cosign Plan options exist for sites that must produce signed audit artifacts." | true | `Sources/LungfishApp/Views/Settings/GeneralSettingsTab.swift:111-113` `Text("Off").tag("off")`, `Text("Local").tag("local")`, `Text("Cosign Plan").tag("cosign")` | |
| 27 | "LGE writes the record automatically for every supported workflow. You never have to ask for it, and you cannot skip it by accident." | true | `Sources/LungfishWorkflow/Provenance/` writes a sidecar per pipeline, with no opt-out surfaced in any dialog | |
| 28 | "If you open a result and the Provenance tab is empty, that is a bug." | changed | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift` renders "No Provenance Available" style states legitimately for items with no run record, such as a file you dragged in (`Sources/LungfishApp/Views/Inspector/InspectorViewController+Notifications.swift:438` alert title "No Provenance Available"). Also "tab" should read "section" | "If you open a result LGE produced and its Provenance section is empty, that is a bug. A file you simply copied into the project folder by hand has no run record to show" |
| 29 | "LGE pins the plugin pack version, the bundle that carries the tool, which makes a re-run on the same Mac reliable." | true | `third-party-tools-lock.json` pins every tool by environment, and the lock's `version` and `dependencySet` fields travel with the app | |
| 30 | "Some tools are sensitive to thread counts or hardware, others are not, and LGE tells you which." | changed | No per-tool thread-sensitivity advisory appears anywhere in `Sources/LungfishWorkflow/`. The claim that LGE tells you which is unsupported | "Some tools are sensitive to thread counts or hardware, others are not. The Invocation & Options section of the run record shows the thread count that was used, so you can match it" |

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|
| The Invocation & Options, Runtime, and Raw JSON sections of the Provenance section | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:65-84` |
| The Provenance section's filter field for searching a long lineage | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:26-29` "Filter provenance" |
| The Copy button that puts the whole run record on the clipboard | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:98-103` |
| SHA-256 checksums shown per artifact | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:348` |
| The Signatures count in Run Summary when a sidecar is signed | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:169-171` |
| The sidecar path shown in Run Summary | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:172-174` |
| `lungfish-cli provenance export`, the CLI equivalent of the Export menu | `cli-help/provenance.txt` `provenance export <input> --format <format> --output <output>` |
| The Settings controls beside the signing provider: Local signing key, Public key path, Save Signing Key, Clear Signing Key | `Sources/LungfishApp/Views/Settings/GeneralSettingsTab.swift:117-133` |
| The signing status line and error line under those controls | `Sources/LungfishApp/Views/Settings/GeneralSettingsTab.swift:135-141` |
| Project locking, unlocking, and lock modes for shared-storage handoff | `cli-help/project.txt` `project lock --mode <mode> --force`, `project unlock --force` |
| Project bundle migration and its conservative dry-run | `cli-help/project.txt` `project migrate --dry-run` |
| Project lock recovery, which archives a corrupt or stale lock rather than deleting it | `Sources/LungfishCore/Storage/ProjectLockRecovery.swift` |
| The "Provenance Export Complete" confirmation and its Reveal action | `Sources/LungfishApp/Views/Inspector/InspectorViewController+Notifications.swift:485-491` |

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- SHOT: classifier-provenance-disclosure -->` | Retake | The caption says "the Inspector's Provenance tab" and lists "Run Summary, Inputs, Outputs, Warnings, and Lineage". It is a section, not a tab, and the real sections are Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON |
| `<!-- SHOT: file-export-provenance-menu -->` | Retake | The caption's format list ends "or the full record as JSON". The menu item reads "Full Provenance (JSON)…". A fresh shot should show the six items with the separator after the fourth |
| `<!-- SHOT: provenance-signing-settings -->` | Yes | Off, Local, and Cosign Plan are exact, and Off is the verified default. The shot should also show the signing key and public key path fields the chapter never mentions |
| New shot needed: the Provenance section's Lineage expanded to show a step's Inputs and Outputs | Missing | The corrected text now distinguishes per-step Inputs and Outputs from the Run Summary counts, and a shot would settle it |
