# Drift report, 2026-09 fidelity campaign

Generated from the eleven reality maps under ground-truth/. Part A is
mechanical; the Decision line under each chapter and all of Part B are
written by the controller.

## Part A: per chapter

### 01-foundations.md/01-what-is-a-genome.md

Verdicts: 15 true, 2 false, 2 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | "folders that hold the reference's `.fasta` sequence in plain text, its `.fai` index ... and a provenance record" | "folders that hold the reference's sequence as a bgzip-compressed FASTA under `genome/`, its `.fai` and `.gzi` indexes beside it, and a provenance record of where the sequence came from, when, and from which version" |
| 9 | "The 'circular by convention' problem belongs to plasmids and bacterial genomes, which the current LGE toolset does not target." | "The 'circular by convention' problem belongs to plasmids and bacterial genomes. LGE can assemble and classify bacterial data, but it still unrolls every reference at the curator's chosen origin" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 14 | "Hand LGE a coordinate whose contig is not in the loaded reference and it refuses" | "Hand LGE a coordinate whose contig cannot be matched to the loaded reference, even after its chromosome-name mapping runs, and it refuses" |
| 18 | "Every reference imported into a project carries provenance: the accession, the source database, the download date, and a checksum, all visible from the project sidebar" | "Every reference imported into a project carries provenance: the accession, the source database, the download date, and a SHA-256 checksum, all visible in the Inspector's Provenance section when you select the reference in the sidebar" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The project is a `.lungfish` directory bundle, not a bare folder | `Sources/LungfishCore/Storage/ProjectFile.swift:98` `public nonisolated static let fileExtension = "lungfish"` |
| Chromosome-name mapping between reference naming conventions | `Sources/LungfishCore/Bundles/ChromosomeNameMapping.swift` |
| The `.lungfishref` bundle's `genome/`, `annotations/`, `variants/`, and `tracks/` subfolders | `Sources/LungfishCore/Bundles/BundleManifest.swift:79-93` |
| Reference bundles can carry BigBed annotations and BigWig signal tracks | `Sources/LungfishCore/Bundles/BundleManifest.swift:70-93` |
| `Extractions/` project folder for read and region extraction bundles | `Sources/LungfishApp/Views/Viewer/ViewerViewController+Extraction.swift:575` |
| Bundle warnings retained with a finished import | `Sources/LungfishCore/Bundles/BundleManifest.swift:7-35` `BundleWarning` |
| The bundled GenBank record store inside a reference bundle | `Sources/LungfishCore/Bundles/BundleManifest.swift:38-50` `ReferenceRecordStoreInfo` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | Yes | The chapter is conceptual and needs no app screenshots |
| Illustration `linear-vs-circular-genomes` | Yes | Purely conceptual, unaffected by the corrections |
| Illustration `position-coordinates` | Yes | 29,903 and the 1-based ticks are both verified |
| Illustration `variant-notation` | Yes | The `MN908947.3:23403 A>G` breakdown is verified against the fixture |

Fixture (after Phase 3): hbb-gene (NG_000007.3)
Decision: rewrite. Concept chapter; worked example moves from SARS-CoV-2 to the human HBB gene record (sickle cell as the motivating variant).

### 01-foundations.md/02-sequencing-reads.md

Verdicts: 8 true, 1 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 9 | "LGE bundles store paired-end reads interleaved internally, keeping both halves of a fragment together, but the import and export surfaces speak the two-file convention" | "LGE bundles keep paired-end reads as two files, R1 and R2. Interleaving into a single alternating file is a separate operation you run when a downstream tool wants that shape, and Deinterleave reverses it" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "Here is one record from the SARS-CoV-2 fixture" followed by a `@SRR36291587.1 1/1` record | "Here is one record in the shape SRA delivers for this run" |
| 3 | "A FASTQ with 86,281 reads runs to 345,124 lines." | "A FASTQ with 86,281 reads runs to 345,124 lines. Each of this fixture's two files holds that many, because 86,281 is a count of pairs" |
| 5 | "Behind the scenes, LGE stores reads compressed to keep project folders small." | "LGE keeps compressed reads compressed, and its FASTQ operations offer a compress option for their outputs" |
| 7 | "merging tools such as `fastp --merge` or `bbmerge` turn the overlap to advantage" | "merging turns the overlap to advantage, and LGE's Merge Overlapping Pairs operation uses `bbmerge` for it" |
| 12 | "LGE and the tools underneath it (FastQC, fastp, BWA, minimap2) do the decoding and report the aggregate statistics." | "LGE and the tools underneath it (fastp, BWA-MEM2, minimap2) do the decoding and report the aggregate statistics" |
| 13 | "LGE ships variant callers for both ends of the spectrum. LoFreq and iVar handle Illumina short reads ... Medaka and Clair3 handle Oxford Nanopore long reads" | "LGE ships variant callers for both ends of the spectrum. LoFreq, iVar, and bcftools handle Illumina short reads from shotgun and amplicon protocols. Medaka and Clair3 handle Oxford Nanopore long reads" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The FASTQ Operations panel and its full operation catalogue | `cli-help/fastq.txt:24-49` lists 25 subcommands including subsample, length-filter, trim, quality-trim, adapter-trim, fixed-trim, contaminant-filter, entropy-filter, primer-remove, error-correct, merge, repair, deinterleave, interleave, deduplicate, demultiplex |
| Virtual FASTQ bundles and `fastq materialize` | `cli-help/fastq.txt:49` "materialize Materialize a virtual FASTQ bundle to a physical" |
| Read deduplication with clumpify.sh | `cli-help/fastq.txt:40` |
| Low-complexity entropy filtering and its threshold | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:84` "Shannon entropy threshold for the low-complexity filter (0.3-0.9, step 0.05)" |
| Barcode scouting and demultiplexing, including ONT and PacBio barcode paths | `cli-help/fastq.txt:41-48` |
| The FASTQ statistics the Inspector reports (read count, bases, mean length, mean quality) | `Sources/LungfishIO/Formats/FASTQ/FASTQStatisticsCollector.swift` |
| Merge Overlapping Pairs settings: strictness and minimum overlap, default 12 | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:97-98,254-255` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | Yes | Conceptual chapter; a FASTQ Operations panel shot would help but was not planned |
| Illustration `fastq-record-anatomy` | Yes | The four-line structure is correct |
| Illustration `paired-end-reads` | Yes | Correct as drawn |
| Illustration `phred-quality-bar` | Yes | Q20 and Q30 annotations are correct |
| Illustration `platform-read-length-comparison` | Yes | Read-length ranges are domain facts, not app claims |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. Example reads become the HG002 chromosome 20 slice; ONT and PacBio read examples come from hg002-long-reads.

### 01-foundations.md/03-amplicon-vs-shotgun.md

Verdicts: 13 true, 1 false, 5 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "A tool such as `fastp` takes the primer sequences, walks each FASTQ read end, matches primer sequence at the read's 5' edge, strips those bases, and writes a trimmed FASTQ." | "LGE's Primer Remove operation takes the primer sequences, matches them against each FASTQ read, strips those bases, and writes a trimmed FASTQ. Its engine is `bbduk` by default, with `cutadapt-linked` as the alternative" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "A tool such as `ivar trim` or `samtools ampliconclip` takes the primer coordinates from a BED file ... and marks those bases as soft-clipped." | "`ivar trim` takes the primer coordinates from a BED file, walks each aligned read in the BAM, finds where the read's mapped position overlaps a primer footprint, and marks those bases as soft-clipped" |
| 10 | "A minimal BED row for the forward primer in the example above reads: `MN908947.3 999 1021 nCoV-2019_1_LEFT 1 +`" | Keep the invented coordinates but rename the primer, for example `scheme_1_LEFT`, so it cannot be mistaken for the bundled ARTIC v3 row |
| 15 | "**ARTIC v5.3.2** (released January 2023). A redesigned 400 bp scheme rebalanced for coverage uniformity." | "**ARTIC v5.3.2.** A redesigned 400 bp scheme rebalanced for coverage uniformity, 96 amplicons across 192 primers. LGE bundles it" |
| 16 | "The ARTIC project keeps shipping updates (the v5.4.2 scheme, for one, released for JN.1-era mutations), so always check the scheme version against your protocol metadata." | "The ARTIC project keeps shipping updates. LGE bundles ARTIC v3, v4, v4.1, and v5.3.2; any newer scheme has to be imported with `lungfish-cli primers import`" |
| 17 | "**QIAseq Direct SARS-CoV-2.** A commercial enhanced-amplicon kit with shorter (~250 bp) amplicons" | "**QIAseq Direct SARS-CoV-2.** A commercial enhanced-amplicon kit built for fragmented RNA, 223 amplicons across 563 primers. LGE bundles it, and it is the scheme the manual's SRR36291587 fixture was prepared with" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| LGE bundles eight primer schemes ready to pick, with no import step | `Sources/LungfishApp/Resources/PrimerSchemes/` holds ARTIC v3, v4, v4.1, v5.3.2, Midnight 1200 V1, NEB VarSkip vss1, NEB VarSkip Long vsl1, and QIAseq Direct |
| NEB VarSkip and VarSkip Long schemes | `NEB-VarSkip-vss1.lungfishprimers` (74 amplicons), `NEB-VarSkip-Long-vsl1.lungfishprimers` (29 amplicons) |
| `lungfish-cli primers import` for a scheme LGE does not bundle | `cli-help/primers.txt` "Import a BED primer scheme as a .lungfishprimers bundle" |
| Scheme import options: `--reference-accession`, `--equivalent-accession`, `--display-name`, `--attachment` | `cli-help/primers.txt:24-36` |
| Every bundled scheme declares both MN908947.3 and NC_045512.2, so a BAM aligned to either resolves | All eight `manifest.json` files list `reference_accessions` with a canonical and an equivalent entry |
| Primer Remove settings: `--kmer` 23, `--mink` 11, `--hdist` 1, `--minimum-overlap` 12, `--error-rate` 0.12 | `cli-help/fastq.txt:276-286` |
| The `amplicon-analysis` plugin pack | `Sources/LungfishWorkflow/Conda/PluginPack.swift:907-924` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | No | The chapter now needs one shot of the primer-scheme picker showing the eight bundled schemes, since "LGE bundles these" is the corrected message |
| Illustration `amplicon-vs-shotgun` | Yes | Conceptual and correct |
| Illustration `primer-scheme-diagram` | Yes | Correct, provided its BED coordinates are not presented as ARTIC v3's real ones |
| Illustration `primer-trim-soft-clip` | Yes | Soft-clipping is what `ivar trim` does |

Fixture (after Phase 3): hg002-chr20 (shotgun) and the Williams MiSeq project (amplicon)
Decision: rewrite. Amplicon example becomes MHC amplicons from the Williams project; shotgun example stays HG002.

### 01-foundations.md/04-alignment-files.md

Verdicts: 12 true, 0 false, 4 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "BBMap handles messier reads where local alignment helps." | "BBMap handles messier reads where local alignment helps, up to 500 bases in its standard mode and 6,000 in its PacBio mode" |
| 7 | "Every BAM LGE writes gets a `.bam.bai` alongside it." | "Every BAM LGE writes gets an index alongside it, a `.bam.bai` for ordinary references and a `.csi` where a contig is too long for BAI" |
| 11 | "LGE's iVar and LoFreq lanes default to a minimum alternate-allele frequency of 0.05, so a 10 percent ALT is reportable but a 0.5 percent ALT is not" | "The variant-calling dialog pre-fills a minimum alternate-allele frequency of 0.05, so at that setting a 10 percent ALT is reportable but a 0.5 percent ALT is not" |
| 15 | "the recommended variant caller differs: LoFreq or iVar for short reads, Medaka or Clair3 for Oxford Nanopore" | "the recommended variant caller differs: LoFreq, iVar, or bcftools for short reads, Medaka or Clair3 for Oxford Nanopore" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Duplicate marking as an alignment step | `cli-help/markdup.txt`; `Sources/LungfishIO/Services/MarkdupService.swift` |
| minimap2 presets beyond the read-type default (`asm5`, `splice`, and the rest) | `Sources/LungfishWorkflow/Mapping/MappingTool.swift:194-195` |
| The mapper compatibility check that warns before a mismatched mapper runs | `Sources/LungfishWorkflow/Mapping/MappingCompatibility.swift:44-100` |
| The `bam` CLI command group | `cli-help/bam.txt` |
| The `map` CLI command and its settings | `cli-help/map.txt` |
| The mapping provenance sidecar written beside every BAM | `Sources/LungfishApp/Views/Inspector/MappingDocumentStateBuilder.swift:173` `MappingProvenance.filename` |
| The `long-read` plugin pack for nanopore and PacBio alignment | `Sources/LungfishWorkflow/Conda/PluginPack.swift:823-831` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter | No | A chapter whose stated habit is "read the coverage track first, then zoom to a position and read the pileup" should show the BAM viewport at least once |
| Illustration `read-mapping-cartoon` | Yes | Correct as drawn |
| Illustration `coverage-histogram` | Yes | Correct as drawn |
| Illustration `pileup-view` | Yes | Correct as drawn |
| Illustration `cigar-anatomy` | Yes | `5S140M5S` is a valid CIGAR for the described record |

Fixture (after Phase 3): hg002-chr20 expected/mapping
Decision: rewrite. BAM examples quote the HG002 minimap2 output; 'via HTSlib' wording removed (alignments are read through managed samtools).

### 01-foundations.md/05-variants-and-vcf.md

Verdicts: 11 true, 9 false, 5 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Inside an LGE bundle, variants are not stored as a `.vcf.gz` on disk. The variant track is a SQLite database (`variants.db`)" | "Inside an LGE bundle the variant track is stored as a BCF with a CSI index under `variants/`, and an optional SQLite sidecar beside it indexes the same rows for the variant browser's fast filtering" |
| 5 | VCF excerpt beginning `##source=lofreq call` with `##FORMAT` lines and a `SRR36291587` sample column | Replace the excerpt with the real iVar shape (see rows 6 to 9) or with a real LoFreq eight-column excerpt, and label which caller produced it |
| 6 | Sample row `MN908947.3 23403 . A G 228 PASS DP=1842;AF=0.998 GT:DP:AF 1/1:1842:0.998` | Use the real iVar row verbatim, or the real LoFreq row verbatim, and say which |
| 7 | Sample row `MN908947.3 1989 . A G 9 ft DP=1750;AF=0.005 GT:DP:AF 0/0:1750:0.005` | Pick a real non-PASS row. The iVar fixture's four `ft` rows include `MN908947.3 44 . C T . ft TYPE=SNP GT:DP:REF_DP:REF_RV:REF_QUAL:ALT_DP:ALT_RV:ALT_QUAL:ALT_FREQ 1:79:75:75:38:4:2:38:0.0506329` |
| 8 | "LGE's variant callers emit a small set: `GT` (genotype), `DP` (depth at this position), `AF` (allele frequency), and sometimes `AD`" | "iVar output carries `GT`, `DP`, then per-allele detail (`REF_DP`, `REF_RV`, `REF_QUAL`, `ALT_DP`, `ALT_RV`, `ALT_QUAL`) and `ALT_FREQ` for the alternate fraction, with `MERGED_AF` and `MERGED_DP` added when codon merging fires. LoFreq output carries no FORMAT column at all and puts `DP`, `AF`, `SB`, and `DP4` in INFO instead" |
| 9 | "In a viral haploid context the convention has flattened to `1/1` for a confidently called variant" and "LGE's iVar lane uses `1/1` to stay compatible with downstream diploid-shaped tooling" | "LGE's iVar lane writes the haploid genotype `1` for a called variant, not the diploid-shaped `1/1`" |
| 12 | "LGE supports four variant callers across its short-read and long-read lanes: iVar, LoFreq, Medaka, and Clair3." | "LGE supports five variant callers across its short-read and long-read lanes: iVar, LoFreq, bcftools, Medaka, and Clair3" |
| 16 | FILTER table row "`q10` `QUAL` was below 10 (a 10% false-positive probability)." | Replace with "`min_snvqual_NN` (LoFreq) The SNV's QUAL fell below the threshold LoFreq computed for that region; the number in the name is the threshold" and "`min_dp_10` (LoFreq) Fewer than ten reads covered the position" |
| 17 | "The quickest way to home in on confident calls is the `Presets > PASS` chip in the filter bar" | "The quickest way to home in on confident calls is the **PASS** filter chip, which hides every row whose `FILTER` is anything but `PASS`" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "A typical iVar VCF for a SARS-CoV-2 isolate opens with about 30 header lines, then a few hundred variant rows." | "A typical iVar VCF for a SARS-CoV-2 isolate opens with about twenty header lines, then tens to hundreds of variant rows" |
| 4 | "When an operation needs a VCF (export, a downstream tool, sharing), LGE regenerates one from SQLite" | "When an operation needs a VCF, LGE writes one from the stored BCF; on import it reads VCFs back in through the same path" |
| 13 | FILTER table row "`ft` The row failed the allele-frequency threshold (typically `AF` below 0.05 or 0.10)" | "`ft` The row failed iVar's Fisher exact test comparing the variant's frequency against the mean error rate (p-value above 0.05)" |
| 14 | FILTER table row "`sb` The row failed a strand-bias filter" | "`sb_fdr` (LoFreq) The row failed the strand-bias false-discovery-rate correction: ALT support is lopsided across the strands" |
| 22 | "The genome track at the top draws each variant as a tick at its `POS`, colour-coded by `FILTER` (PASS rows in Creamsicle, non-PASS rows in Peach)." | "The genome track at the top draws each variant as a tick at its `POS`." Drop the colour claim, or confirm it against the running app before restating it |

#### Missing

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

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers; `shots: []` in front matter, but `features_refs` names `viewport.variant-browser` | No | The chapter devotes a full section to "How LGE renders a VCF" and describes three viewport regions, the PASS chip, and the Inspector. Every one of those needs a shot, and the missing shots are why the `Presets > PASS` error survived |
| Illustration `vcf-row-anatomy` | No | It labels a `GT:DP:AF` FORMAT and a `1/1` genotype. Both are wrong for LGE's iVar output. Redraw against the real `GT:DP:REF_DP:...:ALT_FREQ` shape with genotype `1` |
| Illustration `allele-frequency-haploid-vs-diploid` | Yes | The conceptual contrast is sound |
| Illustration `filter-flag-cartoon` | No | It shows `FILTER=ft` glossed as "failed allele-frequency threshold" and `FILTER=sb`. `ft` is a Fisher exact test flag and `sb` does not exist. Redraw with `PASS`, `ft` (Fisher exact test), and `bq` (bad quality) |

Fixture (after Phase 3): hg002-chr20 benchmark VCF and expected/ caller output
Decision: rewrite. Every VCF example is replaced with real rows from the HG002 fixture; the invented FILTER flags (sb, q10) and the wrong LoFreq and iVar column layouts go.

### 01-foundations.md/06-the-lungfish-project.md

Verdicts: 32 true, 8 false, 7 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Front matter entry point "File > Open (Cmd-O)" | "File > Open Project Folder... (Cmd-O)" |
| 2 | Front matter entry point "View > Show Sidebar (Cmd-Shift-S)" | "View > Show Sidebar (Ctrl-Cmd-S)" |
| 8 | "LGE also ships a command-line tool, `lungfish`, that mirrors most GUI actions." | "LGE also ships a command-line tool, `lungfish-cli`, that mirrors most GUI actions." |
| 15 | "`File > New Project` and `File > Open` work from the menu bar" | "`File > New Project` and `File > Open Project Folder...` work from the menu bar" |
| 16 | "The menu items use the macOS names 'New' and 'Open', while the Welcome window cards say 'Create Project' and 'Open Project'." | "The menu items read 'New Project' and 'Open Project Folder...', while the Welcome window cards say 'Create Project' and 'Open Project'. Same actions, different wording" |
| 19 | "If the sidebar is not visible, choose `View > Show Sidebar` or press `Cmd-Shift-S`." | "If the sidebar is not visible, choose `View > Show Sidebar` or press `Ctrl-Cmd-S`." |
| 20 | "The project folder now exists on disk at `~/Documents/SARS-CoV-2 SRR36291587/`." | "The project bundle now exists on disk at `~/Documents/SARS-CoV-2 SRR36291587.lungfish/`." |
| 44 | "choose `Help > Lungfish Genome Explorer Help` to open it in your default browser" | "choose `Help > Lungfish Genome Explorer Help` to open it in the macOS Help Viewer" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | "A Lungfish Genome Explorer (LGE) project keeps imported files, derived bundles, and their provenance together in a project folder." | "A Lungfish Genome Explorer (LGE) project keeps imported files, derived bundles, and their provenance together in a `.lungfish` project bundle, a directory Finder shows as one item" |
| 21 | "LGE keeps no hidden state outside that folder for this project's data." | "LGE keeps no hidden state outside that bundle for this project's data. Tool packs and reference databases are shared machine-wide and live elsewhere" |
| 30 | "It is a directory holding a `manifest.json` at the root, a primary FASTA, an index, optional annotations, optional attached tracks, and a `provenance/` subfolder." | "It is a directory holding a `manifest.json` at the root, a `genome/` folder with the bgzip-compressed FASTA and its indexes, and optional `annotations/`, `variants/`, and `tracks/` folders alongside a provenance record" |
| 32 | "A search field sits at the top of the sidebar ... a small spinner and a 'Searching project' label appear just below the field." | "a small spinner and a 'Searching project…' label appear just below the field" |
| 40 | "The context menu offers ... **Copy CLI Command**, **Copy Log**, **View Log**, **Reveal Log in Finder**, and **Cancel**." | "The context menu offers **Run Again…** when the row can be replayed, then **Copy CLI Command**, **Copy Log**, **View Log**, **Reveal Log in Finder**, and either **Cancel** on a running row or **Clear** on a finished one" |
| 41 | "**Copy Failure Report** and **Open GitHub Issue** replace **Cancel** on failed rows." | "Failed rows add **Copy Failure Report**, **Open GitHub Issue**, and, once the report file is written, **Reveal Failure Report in Finder**. Cancel gives way to **Clear**" |
| 43 | "You can also press `Cmd-Period` with the row selected." | Drop the Cmd-Period sentence, or verify it against the running app before restating it |

#### Missing

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

#### Screenshots

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

Fixture (after Phase 3): demo project
Decision: rewrite. Menu item is Open Project Folder..., Show Sidebar is Ctrl-Cmd-S, a project is a .lungfish directory bundle, Help opens the macOS Help Viewer; add project locks and Manage Project Storage.

### 01-foundations.md/07-plugin-packs.md

Verdicts: 27 true, 12 false, 7 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "The `read-mapping` pack hands you four read mappers, `minimap2`, `BWA-MEM2`, `Bowtie2`, and `BBMap`, plus `samtools`" | "The `read-mapping` pack hands you three read mappers, `minimap2`, `BWA-MEM2`, and `Bowtie2`. BBMap and `samtools` come with the Required Setup pack, so they are already there" |
| 9 | Pack table row "`read-mapping` minimap2, BWA-MEM2, Bowtie2, BBMap, samtools" | "`read-mapping` minimap2, BWA-MEM2, Bowtie2" |
| 10 | Pack table row "`variant-calling` iVar, LoFreq, Medaka, Clair3, bcftools, tabix, bgzip" | "`variant-calling` iVar, LoFreq, Medaka, Clair3" |
| 13 | Pack table row "`classification-kraken2` Kraken2, KrakenTools" | Replace the four `classification-*` rows with one row: "`metagenomics` Kraken2, Bracken, EsViritu, RiboDetector" |
| 14 | Pack table row "`classification-esviritu` EsViritu and its references" | Folded into the `metagenomics` row above |
| 15 | Pack table row "`classification-taxtriage` TaxTriage workflow tools" | Remove the row |
| 16 | Pack table row "`classification-naomgs` NAO-MGS pipeline tools" | Remove the row |
| 19 | Pack table row "`read-qc` fastp" | Remove the row. Say instead that fastp arrives with Required Setup |
| 20 | Pack table row "`decontamination` Deacon, RiboDetector" | Remove the row. Deacon is Required Setup; RiboDetector is in `metagenomics` |
| 33 | Offline command block `lungfish conda export-pack --pack read-mapping --output ./read-mapping-conda-offline-pack.tgz` | `lungfish-cli conda export-pack --pack read-mapping --output ./read-mapping-conda-offline-pack.tgz` |
| 34 | Offline command block `lungfish conda install --offline --from-bundle ./read-mapping-conda-offline-pack.tgz` | `lungfish-cli conda install --offline --from-bundle ./read-mapping-conda-offline-pack.tgz` |
| 45 | "LGE stops with `install root is read-only; reinstall as the admin user`." | "LGE stops with `conda root is read-only; reinstall as the admin user`." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "The `variant-calling` pack hands you four variant callers, iVar, LoFreq, Medaka, and Clair3, alongside `bcftools` for working with VCF files and the indexing utilities they depend on." | "The `variant-calling` pack hands you four variant callers, iVar, LoFreq, Medaka, and Clair3. `bcftools` and the htslib indexing utilities come with the Required Setup pack" |
| 7 | "Keep at least 50 GB of free disk before installing packs" | "Keep well clear of a full disk before installing packs, and follow the app's own 100 GB recommendation where you can" |
| 17 | Pack table row "`wastewater-surveillance` Freyja" | "`wastewater-surveillance` Freyja (experimental)" |
| 21 | "A typical pack install pulls 100 MB to 300 MB across the wire and finishes in 30 seconds to 3 minutes" | "A typical optional pack install pulls a few hundred megabytes, though the larger ones run to 1 GB. The Required Setup pack is the biggest at roughly 2.7 GB" |
| 22 | "`gatk-core` runs larger than the viral caller packs, because GATK4 ships as a Java toolkit with its own runtime. Budget roughly 600 MB of installed space for it." | "`gatk-core` runs larger than the viral caller packs, because GATK4 ships as a Java toolkit with its own runtime" |
| 40 | "you get an error like 'missing tool: minimap2. Install the `read-mapping` plugin pack.'" | "you get 'minimap2 is not installed. Install the read-mapping plugin pack first.'" |
| 41 | "A full set of the packs in the table above lands in the 1 to 3 GB range" | "Required Setup alone is roughly 2.7 GB, and a full set of the optional packs adds a few gigabytes on top" |

#### Missing

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

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- SHOT: plugin-manager-window -->` | Retake | The caption says "the Read Mapping pack with all three mappers ready", which is right, but the chapter body around it claims four mappers plus samtools. Once the body is corrected the shot should be retaken to show the corrected pack contents and the "Optional Tools" section heading |
| `<!-- SHOT: plugin-manager-databases-tab -->` | Yes | The caption's database names (EuPathDB46, MinusB, PlusPF, PlusPF-16, PlusPF-8, Standard, Standard-8, Standard-16, Viral, EsViritu Viral DB, NCBI Taxonomy) all match `third-party-tools-lock.json` exactly, and the "Recommended for your system" banner is verified |
| New shot needed: the Installed tab with an expanded environment row | Missing | The chapter devotes a whole subsection to it with no shot |
| New shot needed: a pack card's two greyed offline command lines and Copy button | Missing | The offline procedure is the one place the chapter asks the reader to type, and its commands were wrong |

Fixture (after Phase 3): none
Decision: rewrite. Pack table regenerated from PluginPack.swift and the lock (no classification-*, read-qc, or decontamination packs; Kraken2, Bracken, EsViritu, RiboDetector are the metagenomics pack); experimental packs and the Show Experimental Features switch explained; CLI is lungfish-cli.

### 01-foundations.md/08-provenance-and-reproducibility.md

Verdicts: 14 true, 7 false, 9 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Front matter entry point "Inspector > Provenance tab" | "Inspector > Provenance section" |
| 3 | "One of its tabs, **Provenance**, holds the run record for that result." | "One of its sections, **Provenance**, holds the run record for that result." |
| 5 | "**Inputs** lists every file the run read. **Outputs** lists every file it produced." | "**Files & Outputs** lists the files the run read and produced, and Run Summary carries their counts. Each step inside Lineage carries its own Inputs and Outputs lists" |
| 16 | "`lungfish provenance verify` checks a signed provenance sidecar against its signature." | "`lungfish-cli provenance verify` checks a signed provenance sidecar against its signature." |
| 17 | Code block `lungfish provenance verify ~/Projects/SARS-CoV-2.lungfish` | `lungfish-cli provenance verify ~/Projects/SARS-CoV-2.lungfish` |
| 21 | "`lungfish provenance bibliography` reads a bundle's provenance and prints a citation for every tool it recognizes" | "`lungfish-cli provenance bibliography` reads a bundle's provenance and prints a citation for every tool it recognizes" |
| 22 | Code block `lungfish provenance bibliography ~/Projects/SARS-CoV-2.lungfish` | `lungfish-cli provenance bibliography ~/Projects/SARS-CoV-2.lungfish` |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "The tab breaks into sections you can scan top to bottom." | "The section breaks into blocks you can scan top to bottom: Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON" |
| 10 | Format table rows "Shell Script", "Python Script", "Nextflow Pipeline", "Snakemake Workflow", "Methods Section", "Full Provenance" | Rename the last row "Full Provenance (JSON)" |
| 12 | "A `run.sh` bash script that re-runs every step in order" | Drop the exact file name, or confirm it by running an export before restating it |
| 13 | "A `reproduce.py` that drives the same tool calls programmatically" | Drop the exact file name, or confirm it before restating it |
| 15 | "If your collaborator also runs LGE, you need not export at all. A project is just a folder on disk. Hand over the folder directly" | "If your collaborator also runs LGE, you need not export at all. Hand over the `.lungfish` project bundle directly, or share it on lab storage. On shared storage use `lungfish-cli project lock` so two people cannot run advanced workflows against it at once" |
| 20 | "On success it prints `Signature valid` along with the signing provider, the provenance SHA-256, and the two artifact paths it checked." | Confirm the exact success line by running verify against a signed sidecar, or soften to "On success it reports that the signature is valid and names what it checked" |
| 23 | "Tools the catalog does not recognize are listed separately under a 'Tools without known citations' heading" | Confirm the exact heading by running the command against a bundle, or drop the quoted heading |
| 28 | "If you open a result and the Provenance tab is empty, that is a bug." | "If you open a result LGE produced and its Provenance section is empty, that is a bug. A file you simply copied into the project folder by hand has no run record to show" |
| 30 | "Some tools are sensitive to thread counts or hardware, others are not, and LGE tells you which." | "Some tools are sensitive to thread counts or hardware, others are not. The Invocation & Options section of the run record shows the thread count that was used, so you can match it" |

#### Missing

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

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- SHOT: classifier-provenance-disclosure -->` | Retake | The caption says "the Inspector's Provenance tab" and lists "Run Summary, Inputs, Outputs, Warnings, and Lineage". It is a section, not a tab, and the real sections are Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON |
| `<!-- SHOT: file-export-provenance-menu -->` | Retake | The caption's format list ends "or the full record as JSON". The menu item reads "Full Provenance (JSON)…". A fresh shot should show the six items with the separator after the fourth |
| `<!-- SHOT: provenance-signing-settings -->` | Yes | Off, Local, and Cosign Plan are exact, and Off is the verified default. The shot should also show the signing key and public key path fields the chapter never mentions |
| New shot needed: the Provenance section's Lineage expanded to show a step's Inputs and Outputs | Missing | The corrected text now distinguishes per-step Inputs and Outputs from the Run Summary counts, and a shot would settle it |

Fixture (after Phase 3): demo project
Decision: rewrite. CLI name corrected; export formats and the failure report under ~/Library/Logs added; unverifiable export file names confirmed during the demo-project build.

### 02-sequences.md/01-importing-and-viewing.md

Verdicts: 39 true, 9 false, 10 changed, 7 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "Compressed FASTA or GenBank ... Carries annotations: No" | Set the Carries annotations cell to "Same as the uncompressed format" |
| 11 | "The sheet shows a drop zone and a format picker, and previews the file before you commit. Click **Import** when the preview looks right." | "The window shows a row of tabs and a grid of import cards, one per file kind. Switch to **Reference Sequences**, then drop the file on the **Reference Sequences** card or click that card's **Import…** button." |
| 16 | Step 2, "A sheet drops down with a drop zone in the centre." | "A window opens showing import cards grouped under six tabs." |
| 17 | Step 3, "The format picker auto-detects FASTA and previews the file's contents." | "Dropping the file on the Reference Sequences card starts the import at once." |
| 18 | Step 4, "Click Import." | Delete the separate confirm step |
| 20 | "the annotation lane now shows the spike (`S`), nucleocapsid (`N`), ORF1ab, and other coding regions as orange blocks" | "as coloured blocks, one colour per feature type" |
| 36 | "**Copy Visible Region** puts its bases on the clipboard, **Zoom to Visible Region** fits the view to it, and **Center View Here** recentres on the click point." | "**Copy Visible Region** puts its bases on the clipboard and **Center View Here** recentres on the click point. **Zoom to Fit** returns the whole sequence to view." |
| 40 | "Open a sequence bundle, then choose **Sequence > Translate...**. A sheet opens with a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`" | "Open a sequence bundle, then click **Translate** in the window toolbar. A sheet opens with a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`" |
| 60 | "the `--track-name` option instead defaults to `ORFs`" | "the `--track-name` option has no default, so pass it when you want a named track" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | Format table row FASTA, "`.fasta`, `.fa`, `.fna`" | Add `.faa`, `.ffn`, `.frn`, `.fas`, and `.fsa` to the FASTA row |
| 6 | Format table row Compressed, "`.gz`, `.bgz`, `.bz2`, `.xz`, `.zst`" | Add `.gzip` and `.zstd` |
| 9 | "Open the project window, then drag the `.fasta` or `.gb` from the Finder onto the **Reference Sequences** folder in the sidebar." | "drag the file from the Finder onto the project sidebar" |
| 22 | "Three panes stack vertically. The **position ruler** ... The **base track** ... The **annotation track**" | Say "three lanes stack vertically" and drop the implication that each is a separate labelled pane |
| 23 | "The Inspector on the right summarises the bundle: the source file, contig list, total length, annotation count, and any tracks attached" | Name only the rows you can point at, or mark the sentence as a summary |
| 24 | "Right-click for rename, reveal in Finder, and move-to-trash actions." | "Right-click for **Rename...**, **Show in Finder**, and **Move to Trash**." |
| 30 | Right-click Copy submenu, "the feature's name, coordinates, bases, complement, reverse complement, or FASTA, with a protein-FASTA option on CDS features" | Use the literal item titles, in particular **Copy Sequence** rather than "bases" |
| 35 | The annotation-menu bullet list omits "Show Annotation in Inspector" | Add it to the bullet list, or say the list is partial |
| 37 | "Right-click a region you have dragged out instead, and the menu turns to the selection" | Say the items act on the visible region even when a drag selection exists |
| 50 | "the global `--format json` flag prints a machine-readable summary of the run (input and output files, sequence and translation counts, and the genetic code)" | Keep the flag, drop the field list unless you verify it from a run |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Import Center's six tabs (Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, Application Exports) | `ImportCenterViewModel.swift:173-181` |
| The Import Center cards for `Geneious Export` and `Primer Scheme`, both reachable from the same window | `ImportCenterViewModel.swift:571-594` |
| `Sequence > Reverse Complement…` (Cmd-Shift-R), the sibling of Translate on the same menu | `MainMenu.swift:627-632` |
| The window toolbar's `Translate` button as the only route to the overlay translation tool | `MainWindowController.swift:941-956` |
| `File > Export > Sequences (FASTA/GenBank)…` and `File > Export > Annotations (GFF3)…`, the round trip out of a bundle | `MainMenu.swift:220-231` |
| The `File > Export > Provenance` submenu, which writes the bundle's provenance record | `MainMenu.swift:259-271` |
| The viewport's `Show All Translations` and `Hide All Translations` context items in multi-sequence mode | `SequenceViewerView+Interaction.swift:695-707` |
| `Show Annotation in Inspector` on the annotation context menu | `SequenceViewerView+Interaction.swift:1050` |
| `lungfish sequence delete-annotations` and `lungfish sequence delete-annotation-track`, the only way to remove a track added here | `sequence.txt:61`, `:88` |
| `annotate-orfs` scoping options `--sequence`, `--start`, `--end`, which pick the contig and sub-range | `sequence.txt:26-32` |
| `bam annotate-cds-best` options `--include-secondary`, `--include-supplementary`, `--output-track-id`, `--replace` | `bam.txt:157-167` |
| `lungfish extract sequence --line-width` (default 70), which sets FASTA wrapping | `extract.txt:55-56` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: import-center-fasta`, "The Import Center with a FASTA file selected." | No | The Import Center has no file-selection state to photograph. Reshoot as the Reference Sequences tab with the Reference Sequences card highlighted as a drop target (`ImportCenterView.swift:196-252`) |
| `<!-- planned: import-center-fasta -->` at step 1 | No | It sits under "Open a project", before the Import Center is open. Move it to the corrected step 2 |
| `planned_shots: sequence-viewport-genbank`, "An annotated GenBank record open in the sequence viewport." | Yes | The annotated GenBank case is unchanged. The caption should say "coloured blocks, one colour per feature type" rather than orange |
| `<!-- planned: sequence-viewport-genbank -->` under "What you see in the viewport" | Yes | Correctly placed |
| `illustrations: reference-bundle-anatomy` | Yes | The bundle layout (FASTA, FAI, manifest, provenance) is unchanged |
| `illustrations: viewport-panes` | Changed | The illustration labels three "panes". Relabel as lanes to match claim 22 |

Fixture (after Phase 3): hbb-gene
Decision: rewrite. Import Center is a tabbed card grid with per-card drop targets; Sequence > Translate runs the translate operation, the overlay is the toolbar Translate button; Go to Location (Cmd-L) exists.

### 02-sequences.md/02-downloading-from-ncbi.md

Verdicts: 37 true, 2 false, 4 changed, 4 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "a bundle-owned annotation track converted from the record's `gene`, `CDS`, and `mat_peptide` features" | "converted from every feature the record carries" |
| 16 | "the annotation track `annotations/imported_annotations.gff3`" | "the annotation track `annotations/ncbi_gff3_annotations.db`, named NCBI GFF3 Annotations" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 10 | "RefSeq Only ... Restricts results to curated RefSeq records (the `NC_`/`GCF_` series)." | Say it filters nucleotide searches to RefSeq records |
| 17 | "a `.lungfish-provenance.json` sidecar recording the source, the output checksums, file sizes, runtime, exit status, and wall time" | List the fields the CLI actually writes, and mark the GUI sidecar as separately checked |
| 32 | "you will see the source URL it actually hit (so you can confirm whether you fetched from `eutils.ncbi.nlm.nih.gov` or a mirror)" | Drop the mirror clause |
| 45 | "SRA accessions begin with `SRR`, `ERR`, or `DRR` and route through `lungfish fetch sra`, which uses an ENA mirror and falls back to the SRA Toolkit." | Keep the command, verify the fallback order against `SRAService.swift` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `lungfish fetch search` options `--limit` (default 20) and `--organism` | `fetch.txt:76-79` |
| `lungfish fetch search --db genome`, a third database the fetch command does not offer | `fetch.txt:76-77` |
| `lungfish fetch genome --api-key`, the rate-limit flag on the assembly path | `fetch.txt:338` |
| `lungfish fetch genome` accepting a plain nucleotide accession, and the warning that the assembly database substitutes a different record for one | `fetch.txt:307-311` |
| `Tools > Search Online Databases > Search SRA...`, the third item in the same submenu | `MainMenu.swift:747-751` |
| The SRA Runs tab living in the same dialog as the NCBI and Pathoplexus tabs | `SRARunsSearchPane.swift` |
| The Pathoplexus organism requirement, which blocks a download with "Select a Pathoplexus organism" | `DatabaseBrowserViewController.swift:2447-2451` |
| The GFF3-fetch failure fallback to GenBank FEATURES, which silently changes the track id and name | `GenBankBundleDownloadViewModel.swift:130-165` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: ncbi-search-dialog` | Yes | The Mode picker, both toggles, the results list, and the Search-to-Download-Selected button swap all still exist as described |
| `<!-- planned: ncbi-search-dialog -->` before step 1 | Yes | Correctly placed ahead of the procedure |
| `planned_shots: ncbi-bundle-prompt`, "The .lungfishref bundle produced directly by Download Selected" | Changed | Valid as a shot, but any visible track name must read `NCBI GFF3 Annotations`, not `imported_annotations` |
| `<!-- planned: ncbi-bundle-prompt -->` after step 5 | Yes | Correctly placed |
| `illustrations: ncbi-accession-anatomy` | Yes | Accession shape and the nucleotide-versus-assembly split are unchanged |

Fixture (after Phase 3): live fetch of NG_000007.3 and NC_012920.1
Decision: rewrite. Output is annotations/ncbi_gff3_annotations.db with no feature filter; NCBI, SRA, and Pathoplexus dialogs documented from the registry (fetch.ncbi has 18 settings).

### 02-sequences.md/03-extracting-and-comparing.md

Verdicts: 26 true, 8 false, 9 changed, 4 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 9 | "`Copy Visible Region as FASTA` and `Find ORFs` carry no ellipsis, yet Find ORFs still opens a dialog." | "`Copy Visible Region as FASTA` is the only item here without an ellipsis, and it acts at once." |
| 14 | Step 4, "Choose a destination, name the new bundle, and click `Extract`." | "Choose a destination, name the new bundle, and click `Create Bundle`." |
| 16 | Step 5, "Lungfish writes a new `.lungfishref` bundle into the project's `Reference Sequences/` folder and selects it in the sidebar." | "into the project's `Extractions/` folder" |
| 34 | Worked example step 2, "Press `Cmd-Shift-E` ... name the new bundle `MN908947.3-spike`, and click `Extract`." | Replace `Extract` with `Create Bundle` |
| 35 | Worked example step 3, "Lungfish writes `Reference Sequences/MN908947.3-spike.lungfishref/`" | `Extractions/MN908947.3-spike.lungfishref/` |
| 37 | "Map reads to it with `Tools > FASTQ/FASTA Operations > Mapping…` (the \"Map Reads\" operation)" | "Map reads to it with `Tools > Mapping > minimap2…`" |
| 40 | Primer example step 4, "The header names the source bundle and the extracted coordinates" |  |
| 42 | ORF example step 3, "Lungfish adds an `ORFs` track with one feature per qualifying ORF." | "adds a track named after the sequence, for example `NODE_1 ORFs`" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "Find ORFs ... `Sequence > Find ORFs` ... none" | Write the menu path as `Sequence > Find ORFs…` |
| 10 | "`Cmd-Shift-C` overrides the standard macOS Copy because the active window is a sequence viewport." | Drop the override claim |
| 11 | Step 2, "Drag across the ruler, or type coordinates into the position field ... The selected range lights up orange. The dialog extracts whatever region is visible" | "Frame the region by typing coordinates into the position field. Extraction takes whatever the viewport is showing, so a drag selection does not narrow it." |
| 15 | Step 4 implies one destination kind | Name all four, and say the Name field hides for clipboard and share |
| 18 | "The clipboard now holds a FASTA record whose header names the source bundle and the extracted coordinates" | "a FASTA record whose header names the region and its length, in the bracketed form `MN908947.3:21562-25384 [MN908947.3:21562-25384] [3822 bp]`" |
| 23 | "The dialog (titled **Find ORFs**)" | Note both, or quote the header |
| 33 | Worked example step 1, "type `21563-25384`, then press `Return`. The viewport scrolls to the spike CDS and the range highlights." | Drop the highlight clause |
| 36 | "The new bundle is 3,822 bases long." | Say "about 3,822 bases", or verify against a produced bundle |
| 39 | Primer example step 3, "Press `Cmd-Shift-C`. The 22 bases plus a FASTA header are now on the clipboard." | "the visible bases plus a FASTA header are now on the clipboard" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Extract Sequence sheet's Save to File…, Copy to Clipboard, and Share… destinations | `ClassifierExtractionDialog.swift:17-31` |
| The sheet's "N selected" count in its header, which reports what the extraction covers | `FASTASequenceExtractionDialog.swift:35` |
| The annotation right-click route into the same sheet, `Extract Sequence…` on a feature block | `SequenceViewerView+Interaction.swift:1013` |
| `Extract Reads in Selected Region…`, offered on the selection menu when an alignment selection exists | `SequenceViewerView+Interaction.swift:756-763` |
| `annotate-orfs` options `--sequence`, `--start`, `--end`, `--include-partial`, `--allow-alternative-starts`, and `--track-id` on the command line | `sequence.txt:26-46` |
| `lungfish extract sequence --line-width` (default 70) | `extract.txt:55-56` |
| `lungfish extract contigs`, the sibling that pulls contigs out of an assembly | `extract.txt:169` |
| The `Extractions/` folder as the destination convention for every GUI extraction | `ViewerViewController+Extraction.swift:575-582` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: extract-region-dialog`, "The Extract Sequence dialog with its destination and name fields." | Yes | The sheet is unchanged. The caption should say the destination group offers four choices and the button reads Create Bundle |
| `<!-- planned: extract-region-dialog -->` after step 5 | Changed | It sits after the procedure ends. Move it beside step 3, where the sheet first appears |

Fixture (after Phase 3): hbb-gene
Decision: rewrite. GUI extraction writes to Extractions/ via a Create Bundle button; FASTA header uses bracket tokens; no Zoom to Visible Region item.

### 02-sequences.md/04-msa-and-trees.md

Verdicts: 60 true, 4 false, 13 changed, 4 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "Lungfish runs MAFFT under `Tools > FASTQ/FASTA Operations > Multiple Sequence Alignment…`" | "Lungfish runs MAFFT under `Tools > Multiple Sequence Alignment > MAFFT…`" |
| 9 | Step 2, "Choose `Tools > FASTQ/FASTA Operations > Multiple Sequence Alignment…`. The MSA wizard opens on the MAFFT pane." | "Choose `Tools > Multiple Sequence Alignment > MAFFT…`. The operations dialog opens on the MAFFT pane." |
| 22 | "On the left, the row picker lists every input sequence in alignment order, each with a checkbox to hide that row from the column ruler's conservation calculation." | "On the left, a resizable name gutter lists every sequence in alignment order. Click a name to select that row, Command-click to add rows, Shift-click for a range." |
| 26 | "the viewport's `Annotations` toggle projects gene boundaries onto the column ruler" | "Annotations carried by the source sequences draw on the alignment tracks. There is no toggle to switch them off." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "From that open bundle, right-click and choose **Build Tree with IQ-TREE…**" | Add "select at least two sequences first, or the item stays disabled" |
| 10 | Step 3, "add all ten FASTAs. Lungfish concatenates them into a single multi-FASTA before handing them to MAFFT." | "add all ten FASTAs, then set the run mode to combine them into one alignment" |
| 11 | Step 4, "Leave **Strategy** on **Auto**" | "Leave **Strategy** on **Automatic**" |
| 23 | "bases in the standard four-color nucleotide palette and gaps as light dashes on the Cream background" | "bases coloured by the `Nucleotide` scheme, which you can swap for `Conservation`" |
| 24 | "The column ruler across the top carries two tracks: a 1-based column index and a conservation track whose height at each column is the fraction of non-gap rows that share the modal base." | "A column header runs across the top carrying the numbering, and below it a conservation overview strip whose height at each column is the fraction of non-gap rows sharing the modal base." |
| 25 | The column ruler shows "a 1-based column index" only | Say the header shows alignment columns and per-row source coordinates by default, and name the four numbering modes |
| 30 | "`lungfish msa export` writes aligned FASTA, PHYLIP, NEXUS, Clustal, Stockholm, and the a2m/a3m HMMER formats through `--output-format`" | Add plain `fasta` and note it is the default, so an aligned export needs `--output-format aligned-fasta` |
| 34 | "`msa mask columns` ... `--ranges`, `--gap-threshold`, `--conservation-below`, `--codon-position 1\|2\|3`" | Add the three missing options |
| 56 | "`Layout` switches between a branch-length phylogram and an equal-depth cladogram." | Name the segments instead of a `Layout` label |
| 57 | "`Color` can highlight support values or branch lengths." | "A second control switches branch colouring between `None`, `Support`, and `Branch`." |
| 59 | "navigation buttons: `Zoom in`, `Zoom out`, `Fit tree`, and `Reset`" | Describe them as icon buttons for zoom in, zoom out, fit, and reset |
| 68 | "If more than one node matches a label, Lungfish reports the ambiguity instead of guessing." | Confirm against `TreeCommand.swift` |
| 80 | "switch **Strategy** from Auto to **L-INS-i** ... (the CLI spelling is `--strategy linsi`)" | "switch **Strategy** from Automatic to **L-INS-i**" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The **Sequences to align** scope picker, the September addition offering "All sequences (n)" or "Selected sequences (n)" and falling back to a one-line summary when there is no choice | `MSASequenceScopePicker.swift:50-71`; `FASTQOperationToolPanes.swift:607-611`; release note 2026.9.8 |
| The CLI counterpart `align mafft --sequence <name>`, repeatable, accepting a full header, an accession, or the alignment label | `align.txt`, `--sequence` |
| The warning raised when realigning sequences that already carry gaps | release note 2026.9.8, "Realigning sequences that already contain gaps now warns" |
| **Export Alignment…** on the alignment right-click menu, with destinations Save as Bundle, Save to File…, and Copy to Clipboard, and a gap choice of Aligned FASTA (keep gaps) or Unaligned FASTA (remove gaps) | `MultipleSequenceAlignmentViewController.swift:1637-1644`; `MSAAlignmentExportSheet.swift:10-66` |
| The export sheet's scope choice between the entire alignment and the selected rows, and its 5 MB clipboard cap | `MSAAlignmentExportSheet.swift:69-101` |
| **Use as Reference** and **Use Consensus** on the row menu, which switch the comparison target without changing the alignment | `MultipleSequenceAlignmentViewController.swift:1645-1650`, `:1683`; release notes 2026.9.10 and 2026.9.12 |
| The pinned comparison row that stays above the sequences while scrolling | `MultipleSequenceAlignmentViewController.swift:390-391`, `comparisonLabelView` and `comparisonHeaderView`; release note 2026.9.12 |
| The residue identity display modes `Letters`, `Dots to Consensus`, and `Dots to Reference` | `MSAAlignmentNumberingMode.swift:95-113` |
| The **All Sites** and **Variable Sites** segmented control, plus the **Previous Variable** and **Next Variable** buttons | `MultipleSequenceAlignmentViewController.swift:379-386`, `:1010-1012`, `:1053-1059` |
| The `Find sequence or column` search field, which also jumps to a typed column number | `MultipleSequenceAlignmentViewController.swift:625`, `:1029` |
| The `Nucleotide` and `Conservation` colour scheme control | `MultipleSequenceAlignmentViewController.swift:82-92`, `:395-399` |
| The numbering modes `Alignment + Source`, `Alignment Columns`, `Source Coordinates`, and `Hidden` | `MSAAlignmentNumberingMode.swift:7-25` |
| The consensus display options, the low-support and high-gap thresholds (both 50 percent) and the mask symbol mode Auto, N, or X | `MSAAlignmentNumberingMode.swift:53-93` |
| The resizable name gutter, persisted between 160 and 640 points | `MultipleSequenceAlignmentViewController.swift:407-419` |
| Row selection by click, Command-click, and Shift-click, and **Extract Selection to New Bundle…** and **Export Selected Residues…** on the same menu | `MultipleSequenceAlignmentViewController.swift:1617-1625`; release notes 2026.9.8 and 2026.9.10 |
| **Add Annotation from Selection…** and **Apply Annotation to Selected Rows** on the alignment menu | `MultipleSequenceAlignmentViewController.swift:1664-1676` |
| **Copy Subalignment**, the renamed Copy FASTA item | `MultipleSequenceAlignmentViewController.swift:1636` |
| The tool versions the alignment and tree actually run, MAFFT 7.526 and IQ-TREE 3.1.3, and their packs `multiple-sequence-alignment` and `phylogenetics` | `third-party-tools-lock.json` packTools entries |
| `msa actions` and `msa describe`, the two introspection subcommands | `msa.txt:27`, `:52` |
| `align mafft --output`, which names an explicit bundle path instead of letting the project pick | `align.txt`, `--output` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `shots: msa-viewport`, "An MSA viewport showing aligned sequences with a column ruler." | No | The viewport changed substantially across 2026.9.8 to 2026.9.13. Reshoot to show the name gutter, the pinned comparison row, the column header, and the conservation overview strip, and drop "column ruler" from the caption |
| `<!-- SHOT: msa-viewport -->` after the MAFFT procedure | Yes | Correctly placed, provided it follows the corrected menu path in step 2 |
| `shots: tree-viewport`, "A phylogenetic tree viewport showing a rectangular tree with annotated tips." | Yes | The tree viewport is unchanged. Consider showing the Nodes drawer, which the chapter describes but the caption ignores |
| `<!-- SHOT: tree-viewport -->` before the tree interpretation section | Yes | Correctly placed |
| `illustrations: msa-column-homology` | Yes | Gap insertion for homology is unchanged |
| `illustrations: tree-anatomy` | Yes | Tips, internal nodes, branch lengths, and support values all still appear in the viewport |
| A shot of the **Sequences to align** picker | Missing | The September scope picker is the most consequential undocumented control in this chapter and has no planned shot |
| A shot of the **Export Alignment…** sheet | Missing | Three destinations and a gap choice, none documented and none photographed |

Fixture (after Phase 3): primate-mito
Decision: rewrite and split into 02-sequences/04-aligning-sequences.md (MAFFT, the alignment view, scope picker, Use as Reference, identity and numbering modes, Export Alignment) and 02-sequences/05-building-trees.md (IQ-TREE, two-row minimum, the tree view, re-root and subtree extraction). The September MSA work is otherwise undocumented.

### 03-reads.md/01-importing-fastq.md

Verdicts: 25 true, 11 false, 7 changed, 5 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | Pairing table row "Mixed case (`_r1`, `_R1`) / `Sample_r1.fastq.gz` / Paired-end (case-insensitive match)" | Delete the row. Replace with a row for `_R1_001` / `_R2_001`, which the code does support and the table omits: "`<stem>_R1_001.fastq[.gz]` + `<stem>_R2_001.fastq[.gz]` / `Sample01_R1_001.fastq.gz`, `Sample01_R2_001.fastq.gz` / Paired-end (Illumina bcl2fastq and DRAGEN style)". |
| 7 | "The match is case-insensitive, so `_R1` and `_r1` both work." | "The match is case-sensitive, so use the uppercase `_R1` and `_R2` forms. Rename a file whose suffix is lowercase before import." |
| 8 | "If a file's mate is missing, the import dialog warns you before continuing so you can cancel and find the mate." | "A file whose mate is missing is imported as single-end without a warning. The sheet's summary counts paired and single-end samples, so read those counts before you import." |
| 10 | "The Import Center opens with the two files listed and a green "Paired" badge linking them." | "Dropping the files opens the Import FASTQ configuration sheet. Its summary reads `R1:` and `R2:` on separate lines with the total size, which is how you confirm the pair was detected." |
| 11 | "Confirm the sample name (Lungfish proposes the shared stem, here `SRR36291587`) and click Import." | "Confirm the platform and the other import settings, then click Import. The sample name is taken from the shared filename stem and is not editable in this sheet." |
| 12 | "The dialog detects the pair and shows them on one row with a "Paired" badge." | "The configuration sheet shows the detected pair as `R1:` and `R2:` lines in its summary." |
| 13 | "Optionally edit the sample name in the row before importing." | Delete the step. |
| 15 | "BAM read input is single-end and cannot be imported under another platform." | "A BAM input is always treated as single-end because it carries no R1/R2 filenames. You can still change the Platform popup, though Oxford Nanopore is the case this path was built for." |
| 41 | "The viewport shows one row per file in the bundle (one row for single-end, two rows for paired-end)." | "The viewport's top pane shows one summary card bar and one sparkline strip for the whole bundle, not a row per file." |
| 42 | "Each row carries a small sparkline summarising read length and a second sparkline summarising mean per-base quality across the file." | "The sparkline strip holds three charts, labelled Length Dist., Q / Position, and Q Score Dist. Clicking one opens a full-size chart in a popover." |
| 43 | "Below the sparklines, the metadata drawer shows the technical fields Lungfish read off the file: detected platform … total read count, total base count, read length range, and the bundle's checksums." | "Above the sparklines, a summary bar shows nine cards computed from the reads: Reads, Bases, Mean Length, Median Length, N50, Mean Q, Q20, Q30, and GC." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 22 | "Storage-optimized read reordering is on by default; pass `--no-optimize-storage` to keep the original read order." | "Storage-optimized read reordering is on by default for Illumina, Element Biosciences, MGI, and Ultima Genomics inputs and off for Oxford Nanopore, PacBio, and unknown platforms. Pass `--no-optimize-storage` to keep the original read order." |
| 29 | "Choosing Oxford Nanopore forces single-end and drops quality binning to None" | "Choosing Oxford Nanopore hides the Pairing control and treats the input as single-end, and it resets Quality Binning to None (preserve original). You can still change the binning after the reset." |
| 30 | "**Quality Binning** takes Illumina 4-level, 8-level, or None (preserve original), defaulting to 4-level for Illumina, Element, and MGI and to None for the long-read platforms." | "…defaulting to Illumina 4-level for Illumina, Element Biosciences, and MGI / DNBSEQ, and to None for Oxford Nanopore, PacBio, Ultima Genomics, and Unknown / Other." |
| 33 | "The **Optimize storage** checkbox, on by default, reorders reads for tighter compression" | "The **Optimize storage (reorder reads for better compression)** checkbox reorders reads for tighter compression. It starts on for Illumina, Element Biosciences, MGI / DNBSEQ, and Ultima Genomics and off for the other platforms." |
| 35 | "The ONT demultiplexing recipes, one splitting by Fluidigm sample barcodes and one by PacBio barcode pairs, need two extra inputs before they can run: a barcode sheet, a CSV, TSV, or text file of sample names and barcodes, and a name for the demux output folder." | "On a plain FASTQ import the recipe list holds the three bundled Illumina recipes: VSP2 Target Enrichment, Wastewater metagenomics, and Illumina Amplicon Merge. The two ONT demultiplexing recipes, one splitting by Fluidigm sample barcodes and one by PacBio barcode pairs, appear only when you import an ONT run folder, and each needs a Barcode Sheet and a Demux Folder name before it can run." |
| 39 | "Imports do **not** auto-run QC." | Keep the sentence. Change the cross-reference so it does not promise a QC tab. See rows 47 and 48 of chapter 03. |
| 44 | "Technical fields (read count, length, checksum) are computed from the file and are not editable." | "Technical fields such as read count, read length, and quality percentages are computed from the file and are not editable." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The **Compression Tool** popup on the import sheet, offering BBTools and Trim Galore, with a disclosure line beneath it | `FASTQImportConfigSheet.swift:122` (label "Compression Tool:"), 320-338, 635-637 (`clumpingToolChoices` is `[.bbtools, .trimGalore]`), 710 |
| CLI `--clumping-tool` with values auto, bbtools, trim-galore, none | `import-fastq.txt`: "--clumping-tool … Storage optimization tool: auto, bbtools, trim-galore, none (default: platform-specific)" |
| CLI `--platform` accepts only illumina, ont, pacbio, ultima, which is four of the seven GUI platforms | `import-fastq.txt`: "--platform <platform>  Sequencing platform: illumina, ont, pacbio, ultima (default: auto-detect)" |
| The `_R1_001` / `_R2_001` pairing convention | `FASTQImportConfiguration.swift:182` |
| The three bundled processing recipes and their real names | `Sources/LungfishWorkflow/Resources/Recipes/vsp2.recipe.json` (name "VSP2 Target Enrichment"), `wastewater-metagenomics.recipe.json` ("Wastewater metagenomics"), `illumina-amplicon-merge.recipe.json` ("Illumina Amplicon Merge"), all `"platforms": ["illumina"]` |
| The viewport's two middle tabs, Operations and Reads, and the read preview table with columns #, Read ID, Length, Mean Q, Sequence | `FASTQDatasetViewController.swift:494-496`, 1438-1463 |
| The read preview loads the first 1,000 records | `FASTQDatasetViewController.swift:290` |
| The summary cards Median Length and N50, which no reads chapter mentions | `FASTQChartViews.swift:35-36` |
| CLI `import fastq --format`, `--threads`, `--verbose`, `--quiet`, `--log-file` and the other global options | `import-fastq.txt` OPTIONS block |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `import-center-fastq` ("The Import Center Sequencing Reads tab with the FASTQ Files tile and paired files auto-detected.") | Change | The tile is named "Sequencing Read Files", not "FASTQ Files" (`ImportCenterViewModel.swift:253`). Pairing is shown in the configuration sheet that follows, not on the tile. Recaption as the Sequencing Reads tab showing the three tiles, and add a second shot of the Import FASTQ configuration sheet. |
| `<!-- planned: import-center-fastq -->` placed after the drag-drop step | Change | Drag-drop opens the Import FASTQ configuration sheet directly (`MainSplitViewController+FASTQImport.swift:721`), not the Import Center window. The marker should show the configuration sheet at this point in the procedure. |
| `sidebar-after-import` ("The sidebar after a paired-end import, showing the new bundle under Imports.") | Valid | Bundles land under `Imports/` (`AppDelegate+ToolsMenu.swift:636`). |
| `fastq-viewport-sparklines` ("The FASTQ viewport showing per-file QC sparklines and the metadata drawer.") | Change | There is no per-file sparkline and no metadata drawer. Recaption to the summary card bar and the three-chart sparkline strip (`FASTQChartViews.swift:30-42`, `FASTQSparklineStrip.swift:20-31`). |
| `inspector-sample-metadata` ("The Inspector with sample metadata fields editable for a selected FASTQ bundle.") | Unverifiable | Depends on claim 45, which is unresolved. Confirm the Inspector's editable fields before capturing. |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. Pairing is case-sensitive and accepts _R1_001; import sheet settings from import.fastq; ONT demux recipes appear only on the run-folder path.

### 03-reads.md/02-downloading-from-sra.md

Verdicts: 17 true, 4 false, 9 changed, 6 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "then writes the FASTQs to the project's `Downloads/` folder next to a provenance sidecar that records which source served the data and how" | "then downloads the FASTQs from ENA and runs the same import the Import Center uses, so each run lands as a `.lungfishfastq` bundle under the project's `Imports/` folder with ENA provenance written into the bundle's metadata sidecar." |
| 9 | "Use the filter chips above the table to restrict by platform or layout when a query returns many candidates." | "Use the Platform, Strategy, and Layout menus in the filter grid to restrict the search when a query returns many candidates. These filters narrow the search itself, so change them and search again." |
| 13 | "Confirm the **Layout** dropdown reads **Auto-detect (recommended)**." | "Click Download. Lungfish shows the Import FASTQ configuration sheet with the platform and pairing it read from the run's metadata. Confirm those settings, or override the Pairing popup when you know the archive metadata is wrong, then import." |
| 36 | "The fix is to re-run the download with the **Layout** dropdown forced to **Paired**." | "The fix is to re-run the download and set the import sheet's Pairing popup to Paired-end before you import." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > Search Online Databases > Search SRA" (front matter and body, four occurrences) | "`Tools > Search Online Databases > Search SRA...`" |
| 6 | "The search dialog opens with a single query field at the top." | "The Database Browser opens on its SRA Runs pane. A query field sits at the top, and a filter grid beneath it holds Platform, Strategy, Layout, Min Size (Mbases), Publication Date, and Max Results." |
| 12 | "The Download button activates as soon as a row is selected." | Verify the button's `disabled` binding before asserting. If it holds, keep the sentence. |
| 14 | "Auto-detect leans on the run's SRA metadata to choose single-end or paired-end output. Override it only when you know the metadata is wrong" | Fold into the corrected step 13 above. |
| 15 | "The dialog closes and the Operations Panel … opens a new row for the download." | Verify which surface shows the row before asserting, and name that surface. |
| 16 | "Single-end runs land as `<accession>.fastq.gz`. Paired runs land as `<accession>_1.fastq.gz` and `<accession>_2.fastq.gz`" | "From the command line the run lands as `<accession>.fastq.gz`, or as `<accession>_1.fastq.gz` and `<accession>_2.fastq.gz` for a paired run. From the app the same files are imported into a `.lungfishfastq` bundle under `Imports/`." |
| 23 | "`lungfish fetch ena search <query>` … prints a table of matching accessions with each record's title, organism, and length" | Verify the printed columns before naming them, or drop the column list. |
| 27 | "and prints its metadata, platform, library strategy, layout, read count, and file size, alongside the exact ENA FASTQ download URLs" | Confirm the printed field set, or shorten to "prints its metadata alongside the exact ENA FASTQ download URLs". |
| 32 | Table row "Tools involved / Direct HTTPS fetch plus checksum verify / `prefetch` then `fasterq-dump`" | Confirm the ENA checksum step, or shorten the cell to "Direct HTTPS fetch". |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| That Search SRA opens the shared Database Browser window with an SRA Runs pane, alongside GenBank Genomes and Pathoplexus panes | `AppDelegate+ToolsMenu.swift:1667-1674`, `SRARunsSearchPane.swift`, `GenBankGenomesSearchPane.swift`, `PathoplexusSearchPane.swift` |
| The SRA filter controls Strategy, Min Size (Mbases), Publication Date (From and To), and Max Results (50, 100, 200, 500) | `DatabaseBrowserPane.swift:524-570` |
| That an SRA download shows the Import FASTQ configuration sheet, so every import setting from chapter 01 applies to a download too | `DatabaseBrowserViewController.swift:2888-2891` |
| That the GUI download maps the confirmed platform onto the CLI `--platform` string, collapsing Element, MGI, and Unknown to `illumina` | `DatabaseBrowserViewController.swift:2900-2907` |
| That a recipe chosen on the import sheet also runs on an SRA download | `DatabaseBrowserViewController.swift:2909-2920`, 3127 |
| The `fetch` command's other subcommands `ncbi`, `search`, and `genome` | `fetch.txt` banners at lines 20, 60, 301 |
| `fetch sra search` and every other fetch subcommand accept `--format json|tsv` and the global verbosity options | `fetch.txt` OPTIONS blocks |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `sra-search-results` ("The SRA search dialog showing search results with run accessions.") | Change | Recaption to the Database Browser's SRA Runs pane, and include the filter grid, since the corrected procedure now tells the reader to use it. |
| `sra-operations-record` ("The Operations Panel row for an SRA download, with the provenance disclosure expanded.") | Change | Depends on claim 15. Capture whichever surface actually carries the row, the Downloads popover or the Operations Panel, and name it in the caption. |
| Missing shot | Add | The corrected download step now goes through the Import FASTQ configuration sheet. Add a shot of that sheet as it appears for an SRA download, showing the platform and pairing read from the run metadata. |

Fixture (after Phase 3): live SRA search (HG002 run accession)
Decision: rewrite. Layout filter offers Any, PAIRED, and SINGLE and filters results; ENA-first fallback stated as the code does.

### 03-reads.md/03-quality-control.md

Verdicts: 6 true, 12 false, 6 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > FASTQ/FASTA Operations > QC & Reporting… (then Refresh QC Summary)" (front matter `entry_points`) | "Tools > QC & Reporting > Refresh QC Summary…" |
| 2 | "FASTQ viewport > QC tab" (front matter `entry_points`) | "FASTQ viewport > Operations tab > Compute Quality Report" |
| 5 | "The summary covers per-base quality across the read length, reported as Phred scores … plus the read-length distribution, GC content, and adapter contamination indicators." | "The summary covers per-position quality across the read length, reported as Phred scores, the read-length distribution, the quality-score distribution, and GC content. It does not report adapter contamination." |
| 6 | "To run it, choose `Tools > FASTQ/FASTA Operations > QC & Reporting…`, then pick `Refresh QC Summary` from the operations list in the dialog that opens." | "To run it, choose `Tools > QC & Reporting > Refresh QC Summary…`. The FASTQ/FASTA Operations dialog opens with that operation already selected." |
| 7 | "The result lands in the FASTQ viewport's QC tab as a set of charts and a structured report." | "The result lands in the FASTQ viewport's top pane, as a summary card bar and three sparkline charts you can click to enlarge." |
| 11 | "With the same bundle still selected, click the `QC` tab at the top of the FASTQ viewport." | "With the same bundle still selected, look at the top pane of the FASTQ viewport." |
| 12 | "Read the panels in this order: per-base quality, length distribution, GC content, adapter contamination." | "Read the summary cards first, above all Mean Q, Q20, Q30, and GC, then the three sparklines: Length Dist., Q / Position, and Q Score Dist." |
| 17 | "choose `Tools > FASTQ/FASTA Operations > Trimming & Filtering…` and run a quality trim with a Q20 floor and a sliding window" | "choose `Tools > Trimming & Filtering > Quality Trim…` and run a quality trim with a Q20 floor and a sliding window" |
| 20 | "Adapter contamination stays below 1 percent." (SARS-CoV-2 shape) | Delete the sentence. |
| 21 | "Adapter content is 0.4 percent on read 1 and 0.6 percent on read 2." (SRR36291587 worked example) | Delete the sentence. |
| 23 | "A higher adapter percentage on a freshly downloaded copy probably means the SRA served the un-trimmed FASTQ" | Delete the sentence. |
| 24 | "adapter contamination stays below a few percent" (Deciding to proceed) | Delete the clause. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "Lungfish computes a per-bundle QC summary by scanning the reads directly, with no external tool required." | "Lungfish computes a per-bundle QC summary by scanning the reads. The command-line summary is fully native; the in-app quality report also calls the bundled seqkit." |
| 9 | "Select `Refresh QC Summary` in the dialog and click `Run`." | "Confirm the input bundle and click `Run`." |
| 10 | "The Operations Panel shows a new row that moves from `running` to `complete`" | Confirm the running-state label the Operations Panel shows, then quote it exactly. |
| 15 | "The QC tab does not block downstream operations. It informs them." | "The QC summary does not block downstream operations. It informs them." |
| 19 | "The fix is adapter trimming, also handled from `Trimming & Filtering…`." | "The fix is adapter trimming, handled by `Tools > Trimming & Filtering > Adapter Removal…`." |
| 25 | "A bundle that fails on any of these axes goes through `Trimming & Filtering…` first" | "…goes through an operation under `Tools > Trimming & Filtering` first" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The nine summary cards Reads, Bases, Mean Length, Median Length, N50, Mean Q, Q20, Q30, GC, which are the app's real QC readout | `FASTQChartViews.swift:30-42` |
| The Q Score Dist. sparkline, a quality-score histogram the chapter never names | `FASTQSparklineStrip.swift:22`, 29 |
| That clicking a sparkline opens the full-size chart in a popover | `FASTQSparklineStrip.swift:16-17`, 46-51 |
| The "Compute Quality Report" entry point from the sparkline strip itself | `FASTQDatasetViewController.swift:463-465`, 1623 |
| The distinction between the sampled pass over 100k reads and the full scan | `FASTQDatasetViewController.swift:1720` comment "Sampled distributions from 100k reads via FASTQStatisticsCollector" |
| The Reads tab's read preview table, an inspection surface adjacent to QC | `FASTQDatasetViewController.swift:494-496`, 1438-1463 |
| That `qc-summary` takes multiple inputs in one call and writes one report | `fastq.txt` `==== fastq qc-summary ====` USAGE `<inputs> ...` |
| The min and max read length the collector computes but no card shows | `FASTQStatisticsCollector.swift:61-63` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `fastq-qc-charts` ("The FASTQ viewport showing per-base quality, length distribution, and GC content charts.") | Change | There is no GC chart, only a GC summary card, and no QC tab. Recaption to the viewport's top pane showing the nine summary cards and the three sparklines Length Dist., Q / Position, and Q Score Dist. |
| `<!-- planned: fastq-qc-charts -->` placed inside step 4 | Change | Step 4 currently tells the reader to click a QC tab that does not exist. Move the marker to the corrected step that points at the top pane. |
| Missing shot | Add | One sparkline expanded into its popover, since the corrected interpretation now tells the reader to click through. |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. There is no QC tab (Operations and Reads only) and no adapter-contamination metric; the chapter is rebuilt around the QC summary the app actually shows.

### 03-reads.md/04-trimming-and-filtering.md

Verdicts: 18 true, 9 false, 7 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > FASTQ/FASTA Operations > Trimming & Filtering… (then pick the operation)" (front matter) | "Tools > Trimming & Filtering > (pick the operation)" |
| 3 | "Choose `Tools > FASTQ/FASTA Operations > Trimming & Filtering…` and pick the one you want from the list inside." | "Choose the operation directly from `Tools > Trimming & Filtering`. The FASTQ/FASTA Operations dialog opens on it, and its left list lets you switch to any other operation." |
| 14 | "Choose `Tools > FASTQ/FASTA Operations > Trimming & Filtering…`. In the dialog that opens, select `fastp Adapter + Quality Trim` from the operations list" | "Choose `Tools > Trimming & Filtering > fastp Adapter + Quality Trim…`." |
| 19 | "Open it and check the FASTQ viewport's QC tab" | "Open it and check the FASTQ viewport's top pane." |
| 20 | "the adapter contamination indicator should drop to near zero" | Delete the clause. |
| 29 | "re-run `Refresh QC Summary` from `Tools > FASTQ/FASTA Operations > QC & Reporting…` on the new bundle and set the QC tab beside the input" | "re-run `Tools > QC & Reporting > Refresh QC Summary…` on the new bundle and compare its top pane against the input's" |
| 30 | "A good trim shows three signs: a per-base quality plot that no longer dips below Q20, an adapter contamination indicator near zero, and a length distribution tightened" | "A good trim shows two signs: a Q / Position sparkline that no longer dips below Q20, and a length distribution tightened around the expected fragment size with most reads still standing." |
| 33 | "Check the QC tab for the adapter sequence it settled on" | Delete the sentence. The adapter fastp chose is not surfaced in the app's QC readout. |
| 34 | "re-run with a custom adapter FASTA" | "re-run with **Adapter Mode** set to Manual Sequence and paste your kit's adapter sequence" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "four are in play: most operations run fastp, primer trimming runs bbduk or cutadapt depending on the primer source, and the length filter runs seqkit" | Confirm the length filter's engine in the derivative pipeline before naming seqkit, or drop the tool from that row. |
| 6 | "Each one writes a new FASTQ bundle into the project's `Imports/` folder and leaves the input bundle untouched." | Verify which folder a Trimming & Filtering derivative lands in for a project-scoped run, then name that folder once and use it consistently across chapters 04, 05, 06, and 08. |
| 12 | Table row "Filter by Read Length … seqkit … Min Length and Max Length both blank (you set them)" | Keep the defaults; resolve the tool column per row 5. |
| 15 | "Leave adapter trimming enabled with auto-detection, the Phred threshold at Q20, and the window size at 4 bp." | "Leave **Adapter Mode** on Auto-Detect, **Threshold** at 20, and **Window Size** at 4." |
| 18 | "a trimmed bundle appears under `Imports/`" | Resolve per row 6. |
| 25 | "supply the primer sequences as a literal sequence or a primer-scheme FASTA" | "set **Primer Source** to Literal Sequence or Reference FASTA, and for the reference path pick the **Primer Reference** file in the Inputs section" |
| 26 | "the k-mer, minimum k-mer, and Hamming distance fields govern this path alone, defaulting in the dialog to 15, 11, and 1" | "…and the **k**, **mink**, and **hdist** fields govern this path alone, defaulting to 15, 11, and 1." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The "Extra arguments" field on the Quality Trim pane, which the combined fastp pane does not have | `FASTQOperationToolPanes.swift:356` |
| The Output Strategy segmented picker, Per Input or Grouped Result, shown for every operation in this category | `FASTQOperationToolPanes.swift:109-115`, `FASTQOperationDialogState.swift:1066-1072`, 2200-2210 |
| The readiness line at the bottom of the pane and its exact messages, for example "Enter at least one fixed trim amount." | `FASTQOperationDialogState.swift:1032-1064`, 1343-1346 |
| That the dialog also accepts FASTA input and relabels itself accordingly | `FASTQOperationDialogState.swift:1243-1260` |
| CLI `--force` and `--compress` on every trimming subcommand | `fastq.txt` OPTIONS blocks at lines 113-212 |
| `fastq trim --adapter-trimming` as the positive form of the toggle | `fastq.txt` `==== fastq trim ====` |
| That the primer reference input is validated against a FASTA-like extension list | `FASTQOperationDialogState.swift:2258-2270` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `trimming-dialog` ("The combined fastp Adapter + Quality Trim dialog with default parameters.") | Valid, recaption | The operation name is right. Recaption to name the real controls: Threshold 20, Window Size 4, Mode on Cut Right, Adapter Mode on Auto-Detect. |
| `<!-- planned: trimming-dialog -->` placed inside step 2 | Valid | The marker sits at the right point in the corrected procedure. |
| Missing shot | Add | The Primer Trimming pane in Literal Sequence mode, showing the **k**, **mink**, and **hdist** fields, since the chapter currently names those three fields wrongly. |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. Menu path Tools > Trimming & Filtering > <tool>...; every setting from the six fastq.* trim and filter entries; primer trimming k defaults differ GUI (15) vs CLI (23).

### 03-reads.md/05-decontamination.md

Verdicts: 23 true, 4 false, 5 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > FASTQ/FASTA Operations > Decontamination… (then pick the operation)" (front matter) | "Tools > Decontamination > (pick the operation)" |
| 4 | "Choose `Tools > FASTQ/FASTA Operations > Decontamination…` and pick the operation from the list inside the dialog." | "Choose the operation directly from `Tools > Decontamination`." |
| 20 | "Choose `Tools > FASTQ/FASTA Operations > Decontamination…`. In the dialog, select `Remove Human Reads` from the operations list." | "Choose `Tools > Decontamination > Remove Human Reads…`." |
| 32 | "Pass the kept-read bundle to `Tools > FASTQ/FASTA Operations > Mapping…` and choose the SARS-CoV-2 reference." | "Pass the kept-read bundle to `Tools > Mapping > minimap2…` and choose the SARS-CoV-2 reference." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "Each writes a new FASTQ bundle with the targeted reads removed and leaves the original untouched." | "Each writes a new FASTQ bundle and leaves the original untouched. Remove Ribosomal RNA is the exception to removal: its Retain Reads control decides which class it keeps." |
| 17 | "A threshold of 0.5 removed 1.8 percent of all reads and 79 percent of the microsatellite reads. A threshold of 0.6 removed 4.1 percent and 89 percent. A threshold of 0.7 removed 5.7 percent and 94 percent." | Keep the 0.6 pair, matching the pane's own rounding of about 4 percent and about 89 percent. Drop the 0.5 and 0.7 figures unless the benchmark that produced them can be cited. |
| 21 | "The managed `deacon-panhuman` database is selected for you. The pane has no extra controls for this operation." | "The Inputs section shows a **Database** row for the managed human database. The settings pane below it is empty, because this operation has no tuning controls." |
| 22 | "**Remove Ribosomal RNA** shows one segmented `Retain Reads` control (keep non-rRNA, keep rRNA, or keep both; the default keeps non-rRNA), and no RiboDetector toggle." | "**Remove ribosomal RNA sequences** shows one segmented **Retain Reads** control with the segments non-rRNA, rRNA, and Both. It defaults to non-rRNA." |
| 26 | "**Remove Duplicates** shows a `Preset` picker, with substitution and optical-duplicate fields exposed under the custom preset." | "**Remove Duplicates** shows a **Preset** picker offering Exact PCR (the default), Near Duplicate 1, Near Duplicate 2, Optical HiSeq, Optical NovaSeq, and Custom. Choosing Custom reveals a **Substitutions** field, an **Optical Duplicates** toggle, and, with that toggle on, an **Optical Distance** field." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The **Database** input row on the Remove Human Reads pane and its Choose… and Clear buttons | `FASTQOperationDialogState.swift:2092-2093`, 2228; `FASTQOperationToolPanes.swift:195-219` |
| The six deduplicate presets by name and the Exact PCR default | `FASTQOperationToolPanes.swift:1086-1101`, `FASTQOperationDialogState.swift:250` |
| The Optical Distance default of 40 | `FASTQOperationDialogState.swift:253`; `fastq.txt` `==== fastq deduplicate ====` "--dupedist … (default: 40)" |
| CLI `deduplicate --subs` default 0 and `--optical`, which the GUI presets wrap | `fastq.txt` `==== fastq deduplicate ====` |
| CLI `deacon-ribo --absolute-threshold` (default 1) and `--relative-threshold` (default 0.0), which the GUI does not expose | `fastq.txt` `==== fastq deacon-ribo ====` |
| CLI `deacon-ribo` accepts paired R1/R2 inputs and writes to an output directory rather than a file | `fastq.txt` `==== fastq deacon-ribo ====` ARGUMENTS and `-o, --output <output>  Output directory` |
| CLI `entropy-filter --threads`, default 4 | `fastq.txt` `==== fastq entropy-filter ====` |
| `scrub-human --remove-reads` is a deprecated no-op | `fastq.txt` `==== fastq scrub-human ====`: "Deprecated compatibility flag; ignored because Deacon always removes matched reads" |
| The managed databases' user-facing display names, "Human Read Removal Data" and "Ribosomal RNA Removal Data", which is what the reader sees in the manager | `third-party-tools-lock.json:27-28`, 74-75 |
| Deacon's pinned version, 0.16.0 | `third-party-tools-lock.json:12` |
| The Output Strategy picker, available on four of these five operations | `FASTQOperationDialogState.swift:2200-2210` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `human-scrub-dialog` ("The Remove Human Reads dialog with the managed deacon-panhuman database selected.") | Valid, recaption | The operation and the database are right. Recaption to show the Inputs section's Database row, which is the pane's only control and which the chapter currently denies exists. |
| `<!-- planned: human-scrub-dialog -->` placed inside step 3 | Valid | The marker sits at the right point once step 3 is corrected per claim 21. |
| Missing shot | Add | The Low-Complexity Filter pane with its Entropy Threshold slider and the Advanced disclosure open, since the chapter devotes a whole section to those three controls and shows none of them. |
| Missing shot | Add | The Remove Duplicates pane with the Preset picker open, since the corrected wording now names six presets. |

Fixture (after Phase 3): hg002-chr20 reads (host removal on a human sample is the teaching point, nearly everything is removed)
Decision: rewrite. Human and rRNA removal run Deacon; contaminant and low-complexity filters run bbduk; settings from the registry.

### 03-reads.md/06-subsetting-and-extraction.md

Verdicts: 18 true, 6 false, 3 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > FASTQ/FASTA Operations > Search & Subsetting… (then pick the operation)" (front matter) | "Tools > Search & Subsetting > (pick the operation)" |
| 4 | "Choose `Tools > FASTQ/FASTA Operations > Search & Subsetting…` and pick one from the list inside the dialog." | "Choose the operation directly from `Tools > Search & Subsetting`." |
| 9 | "For paired data both mates of a matched read are kept." (Extract Reads by ID) | Delete the sentence from this row. Pair keeping is a property of `lungfish extract reads --by-id`, which the chapter already covers in its own section. |
| 11 | Procedure table row "Select Reads by Sequence … `Min Overlap`; `Error Rate`; … Min Overlap 8, Error Rate 0.1, both toggles off" | "Min Overlap 16, Error Rate 0.15, `Keep Matched Reads` on, `Search Reverse Complement` off. The command line defaults differently: `--min-overlap` 8, `--error-rate` 0.1, and `--keep-matched` off unless you pass it." |
| 25 | "Try it with `Search Reverse Complement` on and the default 0.1 error rate before you conclude a sequence is absent." | "Try it with `Search Reverse Complement` on and the default 0.15 error rate before you conclude a sequence is absent." |
| 28 | "choose **Select Reads by Sequence**, paste the sequence, keep the default 0.1 error rate, tick `Search Reverse Complement`, and tick `Keep Matched Reads`" | "choose **Select Reads by Sequence**, paste the sequence, keep the default 0.15 error rate, tick `Search Reverse Complement`, and leave `Keep Matched Reads` on" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "The new bundle appears under `Imports/`." | Resolve once for the whole part and use the same folder name here. |
| 12 | "Turn on `Keep Matched Reads` to keep the reads that carry the sequence instead of discarding them." | "`Keep Matched Reads` starts on, so the operation keeps the reads that carry the sequence. Turn it off to discard them instead." |
| 18 | "With more than one source `--keep-read-pairs` is the default, so a hit on either mate keeps the pair. Pass `--no-keep-read-pairs` to emit only the exact reads whose IDs matched." | Confirm the multi-source default in the implementation before asserting it, or restate as "pass `--keep-read-pairs` to keep the pair when either mate matches, and `--no-keep-read-pairs` to emit only the exact reads whose IDs matched". |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| That the GUI Search End picker has no Both option while the CLI defaults to `both`, so the two surfaces search different ends unless you set them | `FASTQOperationToolPanes.swift:591-596` versus `fastq.txt` `==== fastq sequence-filter ====` |
| The `--fasta-path` CLI option, which is how the CLI accepts the FASTA the GUI takes in the same text field | `fastq.txt` `==== fastq sequence-filter ====`; `FASTQOperationDialogState.swift:784` decides between literal and path by inspecting the string |
| The Output Strategy picker, offered for all five operations | `FASTQOperationDialogState.swift:2200-2205` |
| `extract reads`'s other three strategies, `--by-region`, `--by-db`, and `--by-classifier` | `extract.txt` `==== extract reads ====` |
| `extract reads --read-format fasta` | `extract.txt` |
| `extract contigs`, the assembly counterpart | `extract.txt` banner at line 169 |
| CLI `--force` and `--compress` on all four subsetting subcommands | `fastq.txt` OPTIONS blocks |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: []` (the chapter plans none) | Change | Add one shot of the Select Reads by Sequence pane at its real defaults, Min Overlap 16, Error Rate 0.15, Keep Matched Reads on. The chapter's three defaults for this operation are all wrong, so a screenshot at the real defaults is the cheapest guard against the error returning. |
| No `<!-- SHOT -->` or `<!-- planned: -->` markers appear in the body | Change | Place the new marker in the procedure section, beside the operation table. |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. Select Reads by Sequence dialog defaults are 16, 0.15, keep-matched on; BAM-to-FASTQ is CLI only; outputs land in Analyses/ (settle the Imports/ versus Analyses/ question by reading the dialog default at capture time).

### 03-reads.md/07-ont-runs.md

Verdicts: 26 true, 10 false, 3 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "Tools > FASTQ/FASTA Operations > Read Processing… (then Orient Reads)" (front matter) | "Tools > Read Processing > Orient Reads…" |
| 3 | "Tools > FASTQ/FASTA Operations > Demultiplexing" (front matter) | "Tools > Demultiplexing > Demultiplex Barcodes…" |
| 14 | "Open one of the new bundles and choose `Tools > FASTQ/FASTA Operations > Read Processing…`, then select `Orient Reads` in the dialog." | "Open one of the new bundles and choose `Tools > Read Processing > Orient Reads…`." |
| 18 | "a `Database Mask` picker and a `Query Mask` picker (each set to `dust` … or `none`)" | "a `Database Mask` picker, set to `dust` to mask low-complexity regions or `none` to mask nothing" |
| 19 | "a `Save unoriented` checkbox, on by default, that writes the reads vsearch could not orient to a separate output file instead of dropping them" | "The operations dialog always discards the reads vsearch cannot orient. To keep them, run Orient Reads from the FASTQ viewport's Operations tab instead, where a **Save unoriented reads** checkbox is on by default." |
| 20 | "and a `Threads` stepper" | Delete the clause. |
| 21 | "The matching CLI flags are `--word-length`, `--mask` (which sets both masks at once), and `--save-unoriented`." | "The matching CLI flags are `--word-length` and `--db-mask`. The command line has no save-unoriented option." |
| 22 | "Passing verbatim vsearch flags is a CLI-only feature, `--extra-args`; the wizard has no such field." | "The Orient Reads pane has an **Extra arguments** field for verbatim vsearch flags, matching the command line's `--extra-args`." |
| 24 | "Reads vsearch cannot confidently orient are handled by the `Save unoriented` checkbox: on by default in the wizard … On the command line the same behavior is off by default, so pass `--save-unoriented`" | "The operations dialog discards reads vsearch cannot orient, so check the output read count against the input. Run the operation from the FASTQ viewport instead when you need to keep them." |
| 26 | "Lungfish demultiplexes both from the command line and from `Tools > FASTQ/FASTA Operations > Demultiplexing` in the app." | "Lungfish demultiplexes both from the command line and from `Tools > Demultiplexing > Demultiplex Barcodes…` in the app." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 13 | "`--quality-binning` (`none`, the default, or `illumina4` / `eightLevel`) re-quantises base qualities" | "`--quality-binning` (`none`, the default, or `illumina4` / `eightLevel`) re-quantises base qualities on the `--optimize-storage` path." |
| 32 | "Lungfish runs cutadapt … and writes one `.lungfishfastq` bundle per barcode under the output directory, plus a `demux-manifest.json`" | Confirm the manifest filename in the demultiplexing pipeline before quoting it. |
| 38 | "Reads whose barcode could not be called land in a bin named `unassigned` … Pass `--discard-unassigned` to throw it away." | Confirm the unassigned bin's directory or bundle name before quoting it. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The GUI Demultiplex Barcodes pane in full: Barcode Source (Built-In Kit or Custom Definition), the Built-In Kit menu, the Engine picker (Cutadapt or Exact Bare Barcode), Location, 5' Distance, 3' Distance, Error Rate, and the Trim Barcodes toggle | `FASTQOperationToolPanes.swift:646-692` |
| That the GUI's Trim Barcodes toggle starts on, the inverse of the CLI's `--no-trim` opt-out | `FASTQOperationDialogState.swift:281` |
| The "ONT Fluidigm Sample Split" operation, the second item in the Demultiplexing category, which splits one bulk ONT Fluidigm bundle into counted per-sample CS1-CS2 insert bundles | `FASTQOperationDialogState.swift:1267`, 1957, 1161; `fastq.txt` `==== fastq ont-fluidigm-samples ====`; `ONTFluidigmSampleMaterializer.swift:157`, 405 |
| CLI `fastq ont-fluidigm-samples` and its options `--primer-mismatches` (default 2), `--minimum-insert-length` (default 20), and the canonicalize-reverse-complements pair (default disabled) | `fastq.txt` `==== fastq ont-fluidigm-samples ====` |
| CLI `fastq ont-pacbio-barcode-demux` for full-length MHC ONT amplicons with PacBio barcode pairs | `fastq.txt` `==== fastq ont-pacbio-barcode-demux ====` |
| That the two ONT recipes, Split by Fluidigm sample barcodes and Demultiplex full-length MHC ONT amplicons with PacBio barcodes, are offered on the ONT run folder import itself, with a Barcode Sheet and a Demux Folder name | `MainSplitViewController+FASTQImport.swift:721-760`; `FASTQImportConfigSheet.swift:65-87`, 131, 136 |
| The full list of twenty built-in barcode kits | `fastq.txt` `==== fastq demultiplex ====` "Built-in kits:" block |
| CLI `import-ont --concurrency`, default 4 | `fastq.txt` `==== fastq import-ont ====` |
| The scout's `--error-rate` and `--overlap` overrides and its `--format text|json|tsv` | `fastq.txt` `==== fastq scout ====` |
| The Extra arguments field on the Orient Reads pane | `FASTQOperationToolPanes.swift:507` |
| That Orient Reads is reachable from the FASTQ viewport's Operations tab with an inline parameter bar and a Save unoriented reads checkbox | `FASTQDatasetViewController.swift:1095-1127`, 2504-2505 |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `ont-import-dialog` ("The Import Center ONT Run Folder tile with a barcoded run directory selected.") | Change | The tile itself opens a folder chooser, so nothing is "selected" on the tile. Recaption to the Import FASTQ configuration sheet as it appears for an ONT run folder, which is the surface that actually shows the barcode-directory count and the two ONT recipes. |
| `<!-- planned: ont-import-dialog -->` placed after step 2 | Valid | The marker sits at the right point once recaptioned. |
| Missing shot | Add | The Orient Reads pane, since four of the chapter's claims about its controls are wrong. Show the Word Length field, the single Database Mask picker, and the Extra arguments field. |
| Missing shot | Add | The Demultiplex Barcodes pane, which the chapter mentions as an entry point but never shows, and whose eight controls it never lists. |

Fixture (after Phase 3): hg002-long-reads laid out as an ONT run folder
Decision: rewrite. Run-folder import with the two ONT demultiplexing recipes and sample sheets; Fluidigm split documented from fastq.ont-fluidigm-sample-split.

### 03-reads.md/08-read-processing.md

Verdicts: 14 true, 3 false, 7 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Tools > FASTQ/FASTA Operations > Read Processing… (then pick the operation)" (front matter) | "Tools > Read Processing > (pick the operation)" |
| 3 | "Choose `Tools > FASTQ/FASTA Operations > Read Processing…` and pick one from the list inside the dialog." | "Choose the operation directly from `Tools > Read Processing`." |
| 27 | "This is the last chapter in [Reads (FASTQ)](.)." | Keep the sentence in 08 and remove it from 07, whose Next section should point to 08. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "Each operation writes a new FASTQ bundle and leaves the input untouched." | "Each operation writes a new bundle and leaves the input untouched. Translate is the exception to the format: it emits protein FASTA rather than FASTQ, because amino-acid sequences carry no quality scores." |
| 6 | "Translate is covered with the sequence tools." | Add a Translate row to the table, or state plainly that Read Processing holds six operations and name the two covered elsewhere. |
| 11 | Procedure table row "Merge Overlapping Pairs / `Strictness` (Normal or Strict); `Min Overlap` / Strictness Normal, Min Overlap 12" | "`Strictness` (Normal or Strict); `Minimum Overlap` / Strictness Normal, Minimum Overlap 12" |
| 13 | Procedure table row "Correct Sequencing Errors / `K-mer` size / 50 (valid range 1 to 62)" | "`K-mer Size` / 50 (the command line caps it at 62; the dialog accepts any positive value)" |
| 15 | Procedure table row "Repair Paired-End Files / none / none / Restores pairing order and keeps reads whose mate is missing as singletons in the output." | Confirm the singleton behaviour in the pipeline before asserting it, since repair.sh can be run either way. |
| 24 | "Raise `Min Overlap` or switch to Strict when you would rather reject a doubtful join" | Use the exact label. |
| 26 | "Repair Paired-End Files … re-pairs what it can and sets the orphaned reads aside as singletons in the same output, so no read is silently lost." | Same as row 15. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Translate operation, the sixth member of Read Processing, which emits protein FASTA and runs frame 1 | `FASTQOperationDialogState.swift:1273`, 1191; `FASTQOperationToolPanes.swift:495-497` "Frame 1 translation is used for this operation." |
| That the CLI `fastq translate` exposes `--frame` (1 to 6, default 1) and `--table` (default 1) while the dialog fixes frame 1 and offers neither | `fastq.txt` `==== fastq translate ====` versus `FASTQOperationDialogState.swift:672-677`, which passes `frameOffset: 0` |
| The Output Strategy picker, offered on all six operations (STRUCK 2026-09-07 at the chapter 21 review. The cited lines are `supportsFASTA`. The picker is gated by `supportsConfigurableOutput` at `:2135-2141`, which admits all six.) | `FASTQOperationDialogState.swift:2135-2141` |
| The advanced-settings note that merged amplicon reads are stored as counted exemplars with support in the FASTQ header | `FASTQOperationToolPanes.swift:851-853` |
| CLI `--force` and `--compress` on merge, error-correct, repair, reverse-complement, and translate | `fastq.txt` OPTIONS blocks |
| The readiness messages this category can show, for example "Enter a positive minimum overlap." and "Enter a positive k-mer size." | `FASTQOperationDialogState.swift:1378-1381`, 1479-1482 |
| bbtools' pinned version 40.02, which covers bbmerge, repair.sh, tadpole, and reformat | `third-party-tools-lock.json:10` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: []` (the chapter plans none) | Change | Add one shot of the Merge Overlapping Pairs pane showing the Strictness segments and the Minimum Overlap field, since the chapter gets that field's label wrong. |
| No `<!-- SHOT -->` or `<!-- planned: -->` markers appear in the body | Change | Place the new marker in the procedure section, beside the operation table. |

Fixture (after Phase 3): hg002-chr20 reads
Decision: rewrite. Merge, repair, orient (viewport-only save-unoriented control), error correction, reverse complement, translate; added to the nav.

### 04-alignments.md/01-mapping-reads-to-a-reference.md

Verdicts: 33 true, 7 false, 9 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "You pick the FASTQ bundle in the sidebar first, then open `Tools > FASTQ/FASTA Operations > Mapping…` and click the row for the mapper you want" | "You pick the FASTQ bundle in the sidebar first, then choose `Tools > Mapping` and click the mapper you want." |
| 5 | "All it asks you for is the reference and the preset." | "The two fields it always asks you for are the reference and the preset. Read Group and Advanced Settings sit below them as collapsed disclosures you can open." |
| 27 | Advanced table row "Threads / (uses host cores) / How many CPU threads the mapper uses." | Threads row CLI flag should read `-t, --threads`, and the effect "How many CPU threads the mapper uses. The wizard defaults to every core on the machine and will not let you set more." |
| 35 | Step 2: "Choose `Tools > FASTQ/FASTA Operations > Mapping…` from the menu bar, then click the tool row for the mapper you want" | "Choose `Tools > Mapping` from the menu bar, then choose the mapper you want: **minimap2…** (the default), **BWA-MEM2…**, **Bowtie2…**, or **BBMap…**." |
| 39 | Step 5: "the operation appears in the Operations Panel at the bottom of the project window ... a status row labelled `map`" | "the operation appears in the Operations Panel at the bottom of the project window ... a status row labelled `Map Reads (minimap2): <sample name>`" |
| 43 | "the Inspector fills with mapping statistics: total reads, mapped reads, mapping rate, mean coverage, and primary-alignment count" | "the Inspector fills with mapping statistics: Total Mapped, Total Unmapped, Mapped %, the chromosome count, and, for a single-contig reference, Est. Coverage. Expand the Flag Stats list below them for the raw `samtools flagstat` categories, including primary, secondary, supplementary, and properly paired." |
| 50 | "the dialog sets paired mode only when both slots hold matching FASTQs" | "pairing is decided after the run starts, from the files the bundle actually resolves to, not from anything you set in the dialog" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "By the time the wizard opens it already knows the reads, from your sidebar selection, and the mapper, from the row you clicked." | "By the time the wizard opens it already knows the reads, from your sidebar selection, and the mapper, from the menu item you chose." |
| 7 | "Underneath minimap2 the pipeline is `minimap2 -ax <preset>` piped into `samtools sort` piped into `samtools index`" (chapter quotes it as one backticked pipeline) | "Underneath minimap2 the steps are `minimap2 -a -x <preset>`, then `samtools sort`, then `samtools index`. The mapper writes a SAM file that the sort step consumes and the pipeline then deletes." |
| 16 | "The assembly, splice, and PacBio CLR presets above are minimap2 modes; BBMap offers its own two instead of these tokens." | "The assembly, splice, and PacBio presets are minimap2 modes. BBMap offers its own two instead. BWA-MEM2 and Bowtie2 offer nothing but Short-read, so their picker holds a single option." |
| 29 | Advanced table row "Supplementary / `--no-supplementary` / Exclude supplementary (split-read) alignment records." | "Supplementary / `--no-supplementary` / The wizard checkbox is on by default and keeps supplementary (split-read) records. The CLI flag is its inverse and drops them." |
| 32 | "60 is the practical ceiling" for MAPQ | "60 is the practical ceiling for minimap2 and BWA, and the highest value the wizard's stepper accepts." |
| 33 | "The wizard has five sections, top to bottom: **Reference**, **Preset** (titled "Mode" for the non-minimap2 mappers), **Read Group**, **Input Compatibility**, and **Advanced Settings**." | Add after the sentence: "Select more than one FASTQ bundle and a sixth section appears between Preset and Read Group, asking whether to run each bundle separately or pool them, and the Read Group fields are replaced by a note saying each bundle gets its own read group." |
| 42 | "a CLI run uses whatever you pass to `--name`" | "a CLI run uses whatever you pass to `lungfish bam adopt-mapping --name`" |
| 48 | "`lungfish map --reference` resolves the primary FASTA from whatever you point it at." | "`lungfish map --reference` wants a FASTA file. A `.lungfishref` bundle path works only when Lungfish can extract the bundle's primary FASTA, so if a bundle path is rejected, pass the FASTA inside it instead." |
| 51 | "Lungfish also exposes a Viral Recon wizard wrapping the nf-core/viralrecon pipeline. It sits alongside the mappers, as another tool row in the same `Tools > FASTQ/FASTA Operations > Mapping…` dialog." | "It sits alongside the mappers, as a fifth item in the same `Tools > Mapping` submenu." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Multi-bundle mapping. Selecting several FASTQ bundles adds a run-mode picker offering per-bundle runs (the default) or one pooled run, and per-bundle mode replaces the editable Read Group fields with an automatic per-bundle read group. | `MappingWizardSheet.swift:154-157` (`multiBundleRunPolicy` with `allowedModes: [.perBundle, .combined]`, `defaultMode: .perBundle`), `:517-524` (the picker), `:527-537` and `:545-553` (the notice) |
| The Read Group disclosure is editable in the wizard, with five labelled fields naming their CLI twins (`ID (--rg-id)`, `Sample (--rg-sm)`, `Library (--rg-lb)`, `Platform (--rg-pl)`, `Platform unit (--rg-pu)`). The chapter treats read groups as CLI-only. | `MappingWizardSheet.swift:697-712` |
| Changing the preset rewrites the Platform field automatically whenever it still holds the old preset's default. | `MappingWizardSheet.swift:484-489` |
| The wizard auto-selects a preset from the detected read class on open, and stops doing so once you change the preset yourself. | `MappingWizardSheet.swift:944-975` (`autoSelectPreferredModeIfNeeded`, guarded by `modeWasChangedByUser`) |
| The Extra arguments field is parsed as you type and a parse error both blocks Run and prints in the footer. | `MappingWizardSheet.swift:438-441`, `:768-772`, `:948-955` |
| Per-mapper Extra arguments placeholders, which are the fastest hint at what each mapper accepts (`--eqx -N 5`, `-M -Y`, `--very-sensitive -N 1`, `minid=0.97 local=t`). | `MappingWizardSheet.swift:199-210` |
| Each preset carries a one-line description under the picker, for example "Optimized for Oxford Nanopore reads." | `MappingWizardSheet.swift:643-647`, `:848-867` |
| Mappers ship in the `read-mapping` plugin pack and BBMap comes from the required BBTools environment, so an un-provisioned machine cannot map. | `map.txt` overview ("Install the tools through the read-mapping plugin pack (`lungfish conda install read-mapping`)"); `third-party-tools-lock.json:31-33` (packID `read-mapping`), `:10` (bbtools) |
| Pinned mapper versions the chapter never states: minimap2 2.31, BWA-MEM2 2.3, Bowtie2 2.5.5, BBMap 40.02, samtools 1.24. | `third-party-tools-lock.json:10, 13, 31-33` |
| Bowtie2 keeps secondary alignments by adding `-k 10`, and BBMap by `secondary=t`, so "Secondary alignments" means something mapper-specific rather than one flag. | `MappingCommandBuilder.swift:145-147`, `:180` |
| `lungfish map` treats multiple inputs as one sample's reads and must be invoked once per sample for per-sample results. | `map.txt` overview paragraph 3 |
| `lungfish map --format json` and `--format tsv` for scripted output. | `map.txt` `--format` |
| `bam annotate-best` and `bam annotate-cds-best`, two mapping-result consumers that build a new bundle from the best read per interval. | `bam.txt` SUBCOMMANDS and their sections |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: mapping-tool-picker -->` and planned_shot `mapping-tool-picker`, captioned "The FASTQ/FASTA Operations dialog, Mapping category, with the minimap2 tool row selected." | No | The dialog and its tool rows are not the entry point. Recapture as the open `Tools > Mapping` submenu showing its five items, and rewrite the caption to match. |
| `<!-- planned: mapping-wizard-overview -->` and planned_shot `mapping-wizard-overview`, captioned "The mapping wizard with Reference and Preset filled in and the Input Compatibility readout reporting a compatible match." | Yes | Reference, Preset, and Input Compatibility are all real sections in the order described (`MappingWizardSheet.swift:513-539`). Frame it so the collapsed Read Group and Advanced Settings disclosures are visible beneath, since claim 5 needs correcting toward them. |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite. Tools > Mapping > minimap2... (one item per mapper); Inspector fields are Total Mapped, Total Unmapped, Mapped %, Chromosomes, Est. Coverage plus Flag Stats; settings from map.*.

### 04-alignments.md/02-reading-an-alignment.md

Verdicts: 18 true, 13 false, 6 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "the Inspector reports per-strand depth as plain numbers you can read without seeing the colours" | "the forward and reverse colours are yours to set, so a reader who cannot separate the defaults can pick two that work" (with the accompanying evidence being `ReadStyleSection.swift:1993-2010`, the two `ColorPicker` wells) |
| 7 | "Choose **File > Open** and pick a BAM, CRAM, or SAM file" | "Choose **File > Import Center…** and pick a BAM, CRAM, or SAM file" |
| 13 | Step 2: "The track's peak depth is also printed as an `Nx` label in its top-left corner, so `40x` marks the deepest column in view." | "The track's peak depth is printed as a `max: Nx` label at the right-hand edge of the coverage strip, so `max: 40x` marks the deepest column in view. At some zoom levels the label also carries the mean, as `max: 40x  mean: 12.3x`." |
| 16 | Step 3: "The alignment viewport has no typed-coordinate prompt." | "To jump straight to a coordinate, choose `Sequence > Go to Location…` (Cmd-L) and type it. `Sequence > Go to Gene…` (Cmd-Option-G) jumps by gene name instead." |
| 26 | Step 5: "The summary at the top reports total reads, mapped reads, mean coverage across the reference, the split between primary and supplementary alignments, and the provenance sidecar from the mapping step" | "The summary at the top reports Total Mapped, Total Unmapped, Mapped %, the chromosome count, and, for a single-contig reference, Est. Coverage. Expand Flag Stats for the raw `samtools flagstat` categories, including primary and supplementary. Expand Provenance for the mapping step's recorded command, which you can reveal with **Show command**." |
| 27 | "click it to select it, then right-click and choose **Copy Read Sequence (FASTQ)**, **Copy Read Sequence (FASTA)**, or **Copy Read Name**" | "click it to select it, then right-click and choose **Copy as FASTA (aligned orientation)** to put the read on the clipboard exactly as it was aligned, soft clips and all, or **Extract Reads… (original reads)** to pull the read as originally sequenced out of the source FASTQ." |
| 28 | "On opening, the viewport draws a representative sample of about 2,500 reads and marks the status bar a `sampled overview` (for example `2,500 of 40,000 reads`); it swaps in the full set automatically only when a contig holds fewer than about 10,000 reads." | "The viewport draws every read in the window up to a budget of 50,000. Past that it draws a deterministic even sample and posts a banner reading "Showing 50,000 of 620,000 reads in view · depth, coverage and consensus use all reads", with a **Load all** button beside it that lifts the budget to a two-million-read ceiling. Depth, coverage, and the consensus track always come from the whole BAM and are never sampled." |
| 29 | "Heavier contigs stay in the sampled sketch" | "A window heavier than the budget stays sampled until you press **Load all**." |
| 35 | "**By pair** tints first-of-pair and second-of-pair reads differently." | Delete the "Colour channels beyond strand" section. Replace it with the two controls that do ship: the "Color reads by strand" toggle, and the forward and reverse colour wells beneath it (`ReadStyleSection.swift:1988-2010`). |
| 36 | "**By insert size** flags pairs whose mates map too close, too far, onto the wrong chromosome, or in the wrong orientation, in the IGV convention." | See claim 35. |
| 37 | "**By split read** highlights reads whose two halves land in separate places" | See claim 35. |
| 38 | "**By read group** tints each read group on its own" | See claim 35. |
| 39 | "A reader chasing a structural variant usually switches from strand to insert size; a reader auditing a merged BAM switches to read group." | Delete. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 11 | "`lungfish import bam` ... accepts BAM, CRAM, and SAM inputs (including `.gz`)" | "It accepts BAM, CRAM, and SAM inputs, copies and indexes the alignment into the output directory, and prints total, mapped, and unmapped read counts alongside the reference contig count." |
| 15 | Step 2: "The status bar along the bottom reports the loaded read count and the current scale in bp/px" | "The status bar along the bottom reports the position, the current selection, and the scale in bp/px, not depth, so read the peak off the coverage label." |
| 24 | Step 4: "a reference-base track beneath the coverage histogram carries the reference letter at each position and the stacked read bases sit under it: a match renders as a small tick, a mismatch as the alternate base letter" | Add after the sentence: "That dotted rendering is the Inspector's "Show matching bases as dots" setting, on by default. Turn it off and every base is drawn as a letter, matches in grey." |
| 31 | "The Inspector's Analysis section is the launch point for every alignment-driven operation" | "The Inspector's Analysis section is the launch point for every alignment-driven operation. It is split into six tabs, Filtering, Annotations, Consensus, Primer Trim, Variant Calling, and Export, and shows one at a time." |
| 32 | "The full set of buttons: **Primer-trim BAM…** ... **Call Variants…** ... **Mark Duplicates in Bundle Tracks** and **Create Deduplicated Bundle** ... **Create Filtered Alignment** ... **Convert Mapped Reads to Annotations**, and **Extract Consensus…**." | Recast the list as a tab map: Filtering holds **Mark Duplicates in Bundle Tracks** and **Create Filtered Alignment**, Annotations holds **Convert Mapped Reads to Annotations**, Consensus holds **Extract Consensus…**, Primer Trim holds **Primer-trim BAM…**, Variant Calling holds **Call Variants…**, and Export holds **Create Deduplicated Bundle**. |
| 34 | "Launch from the Inspector and the dialog opens with this BAM already set as input" | "Launch from the Inspector and the dialog opens with an alignment track already chosen, the first eligible one in the bundle. Check the picker when the bundle carries several." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The coverage scale picker, with Linear (default), Log10, and Square root. Log10 is the setting that makes a dropout visible next to a deep amplicon peak, which is exactly the diagnostic this chapter teaches. | `CoverageScaleMode.swift:14-30`, `ReadStyleSection.swift:1696-1709` |
| The Read Inclusion toggles: "Include duplicate-marked reads", "Include secondary alignments", "Include supplementary alignments". These change what the pileup and the coverage curve count. | `ReadStyleSection.swift:1711-1728` |
| A minimum-MAPQ slider on the viewer itself, separate from the mapping-time filter. | `ReadStyleSection.swift:1686-1693` |
| The "Visible Alignment" picker, which switches between showing all alignment tracks together and one at a time. | `ReadStyleSection.swift:1651-1680` |
| "Show reads", "Limit visible rows" with a row cap, and "Use compact row height", the three controls that decide how much of a deep pile is drawn. | `ReadStyleSection.swift:1682`, `:1937-1956` |
| "Show soft-clipped sequence" and "Show insertion and deletion markers" toggles. The chapter treats soft-clip lightening as unconditional. | `ReadStyleSection.swift:1976-1982` |
| Selecting a read fills a per-read Inspector panel with base qualities and an insertion list, with an empty state reading "Select a read in the viewer to inspect it here." | `ReadStyleSection.swift:1511`, `:1575-1602` |
| Right-clicking a selection in the alignment track offers "Extract Reads in Selected Region…", the region read extraction the campaign brief names. | `SequenceViewerView+Interaction.swift:725-733` |
| Right-clicking the alignment track offers "Show BAM in Finder" (or "Show Alignment File in Finder" for CRAM and SAM), with a submenu when several tracks are loaded. | `SequenceViewerView+Interaction.swift:882-909`, `:936-938` |
| Escape cancels an in-flight read load rather than clearing the selection, the escape hatch for an extreme-depth window. A loading badge reads "Loading mapped reads… N" then "Packing N reads…", with "(esc to cancel)" appended. | `SequenceViewerView+Interaction.swift:378-385`, `ReadBudgetState.swift:88-111` |
| Below a zoom threshold the read track is replaced by a message, "Zoom in to view individual mapped reads (<= 2.0 bp/px)", with the current zoom printed beneath. | `SequenceViewerView+AnnotationRendering.swift:926-927`, `ReadViewportPolicy.swift:5-6` |
| Three rendering tiers, coverage, packed, and base, chosen by bp per pixel, so what the viewport draws changes as you zoom rather than just getting bigger. | `ReadViewportPolicy.swift:5-18` |
| "Zoom Reset (10kb)" on Cmd-1, a fourth zoom command the chapter does not list. | `MainMenu.swift:560-564` |
| The consensus track and its settings, shown in the viewer above the reads: Bayesian or Simple mode, whole-contig or selected-region scope, IUPAC ambiguity codes, and high-gap masking. | `ReadStyleSection.swift:2440-2473` |
| Alignments are read by shelling out to managed samtools for every region query, not through a linked HTSlib, which is why an unprovisioned toolchain shows an empty pileup. | `AlignmentDataProvider.swift:1`, `:343-345`, `:418`, `:458` |
| The Inspector's provenance rows collapse their commands by default and carry a "Show command" button, with the note "Commands are collapsed by default." | `ReadStyleSection.swift:1264`, `:1297`, `:1356` |
| Selecting multiple reads and copying skips records with an empty or `*` SEQ, reporting the skip count in the status bar rather than failing. | `SequenceViewerView+Interaction.swift:863-880` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: bam-viewport-overview -->` and planned_shot `bam-viewport-overview`, captioned "The BAM viewport showing reads stacked on the reference with a coverage histogram." | Yes | Layout and strand-split histogram both confirmed (`ReadTrackRenderer.swift:291-386`). Frame it wide enough to include the `max: Nx` label at the right edge, since claim 13 corrects its position. |
| `<!-- planned: pileup-zoom -->` and planned_shot `pileup-zoom`, captioned "Zoomed pileup view at a single position showing per-read base calls." | Yes | The base tier is real (`ReadViewportPolicy.swift:6`, `:11-13`). Capture it with "Show matching bases as dots" at its default so the dot-and-letter rendering claim 24 corrects is what the reader sees. |
| `<!-- planned: alignment-inspector -->` and planned_shot `alignment-inspector`, captioned "The Inspector for an alignment track, with aggregate stats and the Analysis section." | No, recapture | The caption implies stats and Analysis appear together. They are different Inspector surfaces, and Analysis is a six-tab grid. Split into two shots, one of the alignment summary with Flag Stats expanded, one of the Analysis tab grid, and rewrite both captions. |

Fixture (after Phase 3): hg002-chr20 expected/mapping
Decision: rewrite. Delete the colour-channels section (no such UI); 50,000-read budget with Load all to 2,000,000; coverage scale linear, log10, and square root; right-click items are Copy as FASTA (aligned orientation) and Extract Reads...; Go to Location exists; File > Import Center.

### 04-alignments.md/03-primer-trimming.md

Verdicts: 18 true, 4 false, 9 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | "The current release ships one built-in scheme." | "The current release ships eight built-in schemes, all for SARS-CoV-2." |
| 9 | "ARTIC, midnight, and other lab or vendor schemes belong in the project's `Primer Schemes/` folder, imported as `.lungfishprimers` bundles." | "Seven more schemes ship built in beside it: ARTIC V3, V4, V4.1, and V5.3.2, Midnight 1200 bp V1, and NEB VarSkip Short v1 and Long v1. Any scheme not on that list belongs in the project's `Primer Schemes/` folder, imported as a `.lungfishprimers` bundle." |
| 17 | "Until it is, the dialog's Run button stays disabled and its Readiness line reads "Requires Variant Calling Pack"." | Quote the real string. Read the `.disabled` reason produced by `BAMPrimerTrimCatalog` and reproduce it verbatim, or write the sentence without quoting: "Until it is, the dialog's Run button stays disabled and its Readiness line names what is missing." |
| 23 | Step 5: "a new entry, labelled `bam primer-trim`, appears in the Operations Panel" | "a new entry, labelled `Primer-trimming with QIAseq Direct SARS-CoV-2 with Booster A`, appears in the Operations Panel" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "It appears in the picker as **QIAseq Direct SARS-CoV-2 with Booster A (Built-in)**." | "Its display name is **QIAseq Direct SARS-CoV-2 with Booster A**, and the picker lists it among the built-in schemes." |
| 12 | "A scheme built on one coordinate system, applied to a BAM mapped on another, can miss primers without a word of warning" | "A scheme built on one coordinate system, applied to a BAM mapped on another, can miss primers without a word of warning. The bundled SARS-CoV-2 schemes accept both `MN908947.3` and `NC_045512.2`, so the trap bites hardest on imported schemes." |
| 13 | "Use `File > Import Center > Primer Scheme` to build a project-local scheme from a BED file, an optional primer FASTA, and optional attachments." | Verify the sub-item label against the Import Center source before the rewrite, or drop to "Use `File > Import Center…` and choose the primer-scheme importer". |
| 14 | "Lungfish writes `manifest.json`, `primers.bed`, an optional `primers.fasta`, and `PROVENANCE.md` under `Primer Schemes/<name>.lungfishprimers`." | Cite `Sources/LungfishWorkflow/Primers/PrimerSchemeImportService.swift` for the exact file set before the rewrite. |
| 15 | "`lungfish primers import --bed <bed> --fasta <ref> --output <name>.lungfishprimers`" | Copy the flag names verbatim from `cli-help/primers.txt`. |
| 18 | Step 2: "In the Inspector, expand the **Analysis** section and click **Primer-trim BAM…**." | "In the Inspector, open the **Analysis** section, click its **Primer Trim** tab, and click **Primer-trim BAM…**." |
| 21 | Step 3: "The dialog reports the scheme's reference (MN908947.3) and amplicon count (223) below the picker." | Read `Sources/LungfishApp/Views/BAM/PrimerSchemePickerView.swift` and quote the fields it actually shows. |
| 30 | "The Inspector's **Provenance** section for the new track lists the primer-trim step with the exact `ivar trim` command, the scheme's BED checksum, and the input BAM's checksum." | Read `Sources/LungfishWorkflow/Primers/BAMPrimerTrimProvenance.swift` and name the fields it actually writes. Note also that the command is collapsed until you click **Show command**. |
| 31 | "the variant-calling dialog ... shows the "this BAM has been primer-trimmed" acknowledgement already confirmed" | Quote the real acknowledgement string from `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift`. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Seven built-in schemes the chapter does not list, with their real counts: ARTIC SARS-CoV-2 V3 (218 primers, 98 amplicons), V4 (198, 99), V4.1 (209, 99), V5.3.2 (192, 96), Midnight 1200 bp V1 (58, 29), NEB VarSkip Short v1 (148, 74), NEB VarSkip Long v1 (50, 29). | Each scheme's `manifest.json` under `Sources/LungfishApp/Resources/PrimerSchemes/` |
| Every bundled manifest names both `MN908947.3` (canonical) and `NC_045512.2` (equivalent), so a BAM mapped to either accession resolves. | `reference_accessions` in all eight manifests |
| The **Output Track Name** field in the Target section, and the fact that a name colliding with an existing track is refused. | `BAMPrimerTrimToolPanes.swift:65-67`, `BAMPrimerTrimSubcommand.swift:181` |
| The dialog's own note that unmatched reads are retained, which is the same warning the Interpretation section gives, stated in the UI. | `BAMPrimerTrimToolPanes.swift:69` |
| A **Browse...** affordance on the scheme picker for a scheme outside the project. | `BAMPrimerTrimToolPanes.swift:44`, `BAMPrimerTrimDialog.swift:13` |
| The bundle-level operation lock: the run is refused with "Operation in Progress" when another operation already holds the bundle. | `InspectorViewController+TrimDuplicateWorkflows.swift:88-96` |
| The pinned iVar version, 1.4.4, and its pack id `variant-calling`. | `third-party-tools-lock.json:37` |
| Per-control help popovers on every field in the dialog. | `BAMPrimerTrimToolPanes.swift:45, 62, 67, 71, 77-85, 96` (`.lungfishHelp(...)`) |
| Failure surfaces as an alert titled "Primer Trim Failed", and a readiness failure as one titled "Primer Trim Not Ready" carrying the readiness text. | `InspectorViewController+TrimDuplicateWorkflows.swift:103`, `:239` |
| `lungfish bam primer-trim --format json` for scripted output. | `bam.txt` `bam primer-trim` `--format` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: primer-trim-dialog-overview -->` and planned_shot `primer-trim-dialog-overview`, captioned "The Primer Trim dialog with a primer scheme selected." | Yes, with a caption change | The dialog is real and its four panes are confirmed (`BAMPrimerTrimToolPanes.swift:17-22`). Capture it with the scheme menu open so the eight built-ins are visible, since claim 6 turns on that count, and name the Output Track Name field in the caption. |
| `<!-- planned: primer-trim-track-result -->` and planned_shot `primer-trim-track-result`, captioned "The primer-trimmed alignment track in the sidebar, with the (Primer-trimmed) suffix and soft-clip ticks visible at amplicon ends." | No, caption is wrong | The default name is `<track name> • Primer-trimmed (<scheme display name>)` (`BAMPrimerTrimDialogState.swift:114`), not a bare `(Primer-trimmed)` suffix. Keep the shot, rewrite the caption to the real name shape, and make sure "Show soft-clipped sequence" is on so the clipped ends actually render (`ReadStyleSection.swift:1976`). |

Fixture (after Phase 3): sarscov2-srr36291587 (viral by design: the bundled schemes are SARS-CoV-2)
Decision: rewrite. Inspector > Analysis > Primer Trim tab; eight bundled schemes; settings from bam.primer-trim.

### 04-alignments.md/04-alignment-quality.md

Verdicts: 13 true, 4 false, 9 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "Read the **Mean coverage** field. This is the average depth across the entire reference" | "Read the **Est. Coverage** field. It is the estimated average depth across the reference, and it appears only when the alignment has a single contig. For a multi-contig reference, read depth off the coverage track instead." |
| 7 | "Note the **Primary alignments** count." | "Expand **Flag Stats** and note the `primary` row." |
| 25 | "Re-read the **Mean coverage** field after marking; it falls by the duplicate fraction." | "Re-read the **Est. Coverage** field after marking. It only falls once duplicates are actually excluded, so use **Create Deduplicated Bundle** or `--exclude-marked-duplicates` if you want the effective depth." |
| 29 | "This is the last chapter in [Alignments](.)." | "The last chapter in this part is [Viral Recon Wizard](05-viral-recon-wizard.md)." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Frontmatter entry point "Inspector > Analysis > Mark Duplicates in Bundle Tracks" | "Inspector > Analysis > Filtering > Mark Duplicates in Bundle Tracks" |
| 5 | "Read the **Mapped reads** and **Properly paired** counts." | "Read the **Total Mapped** count and the **Mapped %** beneath it. For the properly-paired figure, expand **Flag Stats** and find the `properly paired` row." |
| 9 | "Drag horizontally across the genome." | "Pan across the genome with the Left and Right arrow keys, or jump to a coordinate with `Sequence > Go to Location…`." |
| 10 | "click **Mark Duplicates in Bundle Tracks** in the Inspector's Analysis section" | "click **Mark Duplicates in Bundle Tracks** in the Inspector's Analysis section, under its Filtering tab" |
| 12 | "The command wraps a `samtools markdup` pipeline (name-sort, fixmate, coordinate-sort, mark, index ...)" | Cite `Sources/LungfishCLI/Commands/MarkdupCommand.swift` for the stage list before the rewrite. |
| 16 | "The GUI equivalent is **Create Deduplicated Bundle** in the same Analysis section." | "The GUI equivalent is **Create Deduplicated Bundle**, under the Analysis section's Export tab." |
| 19 | "Omit `--output` and Lungfish writes a uniquely named deduplicated copy beside the source." | Confirm the default output naming in `Sources/LungfishCLI/Commands/BundleCommand.swift`, or soften to "Omit `--output` and Lungfish chooses a name for the copy." |
| 21 | "The GUI equivalent is **Create Filtered Alignment** in the Inspector's Analysis section." | "The GUI equivalent is **Create Filtered Alignment**, under the Analysis section's Filtering tab." |
| 24 | "`--exclude-marked-duplicates` and `--remove-duplicates` are mutually exclusive, and so are `--exact-match` and `--min-percent-identity`." | Confirm the guard in `Sources/LungfishCLI/Commands/BAMFilterSubcommand.swift`, or state the intent without asserting an error. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The GUI filter panel, which is where a reader will actually build a filter: a source track picker, "Keep mapped reads only", "Keep one primary alignment per read", a MAPQ slider reading "MAPQ N" with the note "Uses SAM MAPQ. Set to 0 to keep every alignment confidence level.", a "Duplicate handling" picker, "Keep reads with zero mismatches to reference", a minimum percent-identity field, and a "Name for New Alignment" field. The chapter documents only the CLI equivalents. | `ReadStyleSection.swift:2141-2264` |
| The filter panel's own pointer to where the result lands: "After creating a filtered alignment, find it under Bundle > Alignment Tracks and compare it separately under View > Alignment." | `ReadStyleSection.swift:2106` |
| The coverage scale picker (Linear, Log10, Square root), which is the single most useful control for the dropout hunt this chapter teaches, since a linear axis buries a shallow region beside a deep amplicon peak. | `CoverageScaleMode.swift:8-13`, `:14-30`; `ReadStyleSection.swift:1696-1709` |
| Read Inclusion toggles for duplicate-marked, secondary, and supplementary reads, which change the depth the viewport draws after marking. | `ReadStyleSection.swift:1711-1728` |
| `lungfish markdup --sort-threads`, default 4, separate from the global `--threads`. | `markdup.txt` |
| `bam markdup` also exists as a subcommand of `bam`, alongside the top-level `markdup`, and lacks `--deduplicated-bundle`. | `bam.txt` `bam markdup` section |
| `bam filter --output-track-id` for a stable, scriptable track identifier. | `bam.txt` `bam filter` |
| `bam annotate`, which converts mapped reads into a sortable, filterable annotation track, the QC surface for reading read fields as a table. | `bam.txt` `bam annotate`; `ReadStyleSection.swift:2300-2404` |
| The Inspector's Flag Stats list, the actual home of properly-paired, primary, secondary, supplementary, and duplicate counts, with QC-failed counts shown separately in orange. | `ReadStyleSection.swift:1218-1236`, `AlignmentMetadataDatabase.swift:392-407` |
| The Read Groups list, which names each `@RG` with its sample, library, and platform, the check that a merged BAM carries the read groups a joint caller needs. | `ReadStyleSection.swift:1197-1214` |
| A per-chromosome mapped-read breakdown, the way to spot one contig soaking up the reads. | `ReadStyleSection.swift:1240-1259` |
| Est. Coverage is shown only for a single-contig alignment, so multi-contig references get no depth number at all in the Inspector. | `ReadStyleSection.swift:1189-1192` |
| The bundle-level operation lock, which refuses a duplicate-marking run while another operation holds the bundle. | `InspectorViewController+TrimDuplicateWorkflows.swift:88-96` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: inspector-alignment-stats -->` and planned_shot `inspector-alignment-stats`, captioned "Inspector pane showing mean coverage, mapped reads, and flagstat-style counts for an alignment track." | No, caption is wrong | The fields are Total Mapped, Total Unmapped, Mapped %, Chromosomes, and Est. Coverage, with flagstat counts in a separate collapsible list. Capture with Flag Stats expanded and rewrite the caption to the real labels. |
| `<!-- planned: coverage-histogram-uniform -->` and planned_shot `coverage-histogram-uniform`, captioned "BAM viewport coverage histogram for a well-tiled amplicon BAM, showing roughly even depth across the genome." | Yes | Real and unchanged. Capture on the Linear scale so it matches the default the reader sees. |
| `<!-- planned: coverage-histogram-dropout -->` and planned_shot `coverage-histogram-dropout`, captioned "BAM viewport coverage histogram with two amplicon-edge dropouts visible as gaps in the histogram." | Yes, and worth a companion | Real. Add a paired Log10 capture of the same region, since that scale is what makes a shallow dropout legible beside a deep peak (`CoverageScaleMode.swift:8-13`). |
| `<!-- planned: markdup-dialog -->` and planned_shot `markdup-dialog`, captioned "The Inspector's Analysis section showing the Mark Duplicates in Bundle Tracks and Create Deduplicated Bundle buttons." | No | The two buttons are on different tabs, Filtering and Export, and cannot appear in one frame. Split into two shots, or capture the Filtering tab alone and rewrite the caption. |

Fixture (after Phase 3): hg002-chr20 expected/mapping
Decision: rewrite. Real Inspector field set; mark duplicates and consensus from their tabs; what good looks like against the HG002 numbers.

### 04-alignments.md/05-viral-recon-wizard.md

Verdicts: 37 true, 2 false, 8 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "There is no "Workflows" menu in Lungfish. You reach Viral Recon at `Tools > FASTQ/FASTA Operations > Mapping…`, then by clicking the **Viral Recon** tool row" | "There is no "Workflows" menu in Lungfish. You reach Viral Recon at `Tools > Mapping > Viral Recon…`, the same submenu that holds minimap2 and BWA-MEM2." |
| 28 | Procedure step 2: "Choose `Tools > FASTQ/FASTA Operations > Mapping…`, then click the **Viral Recon** tool row." | "Choose `Tools > Mapping > Viral Recon…`." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 18 | "`NC_045512.2` is the same genome under a different accession, but it is never substituted" | "`NC_045512.2` is the same genome under a different accession, and the wizard always asks for `MN908947.3` so the reference the pipeline receives is the one the samplesheet names." |
| 19 | "It stages `primers.bed` into the prepared input directory and cuts `primers.fasta` out of the reference, since no bundled scheme ships one." | Check each scheme directory for a `primers.fasta` before asserting none ships one. |
| 21 | "The sheet shows four controls, in this order: 1. **Inputs** ... 2. **Primer Scheme** ... 3. **Minimum mapped reads** ... 4. **Readiness**." | "The sheet opens with a Viral Recon heading and the note that Docker Desktop is required, then shows four controls in this order. A fifth, Platform, appears between Inputs and Primer Scheme when the reads do not name their platform." |
| 22 | "**Primer Scheme.** The scheme menu, with its accession, primer count and amplicon count." | Read the construction of `ViralReconPrimerOption.detail` in `ViralReconWizardSheet.swift` and name the fields it actually prints. |
| 35 | "To change any of them, type the matching parameter into the Advanced field, for example `--consensus_caller ivar` or `--max_memory 16.GB`." | Test both examples against `ViralReconParameterSchema` before publishing them. Pick examples outside the reserved set if they are refused. |
| 46 | "`lungfish provenance bibliography <bundle>` can generate a first-pass citation list" | Confirm the subcommand name against `cli-help/provenance.txt`. |
| 47 | "Continue to [Alignment Quality](04-alignment-quality.md) when you want to inspect a Lungfish-native alignment" | Reconcile with chapter 04's Next link so exactly one chapter closes the part. |
| 48 | CLI example passes `--param primer_bed=PrimerSchemes/primers.bed` | Verify against `Sources/LungfishCLI/Commands/WorkflowCommand.swift` before publishing an example that may be refused. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The primer-scheme picker draws on the same eight bundled SARS-CoV-2 schemes as the primer-trim dialog, so "if none are installed" is a case that only arises for a broken install. | `Sources/LungfishApp/Resources/PrimerSchemes/` (eight bundles) |
| Nanopore runs pass two extra parameters the Illumina path does not, `fastq_dir` and `sequencing_summary`, which is why a Nanopore selection needs a fastq_pass directory. | `ViralReconRunRequest.swift:151-156` |
| Primer suffix handling: `primer_left_suffix` and `primer_right_suffix` are read off the scheme and passed to the pipeline. | `ViralReconRunRequest.swift:135-136`, `ViralReconRunRequest.swift:97-98` |
| `max_cpus` is defaulted to the machine's core count capped at 8, not left to the pipeline. | `ViralReconWizardSheet.swift:619-621` |
| The Advanced group's Clear button for a chosen GFF, and its note that the downloaded reference already carries GFF3 annotations, so most runs need no replacement. | `ViralReconWizardSheet.swift:284`, `:294` |
| `primer_fasta` is emitted only when the file exists on disk, because naming an unwritten path made runs die inside Nextflow instead of failing schema validation up front. | `ViralReconRunRequest.swift:143-149` |
| The full reserved-parameter list the Advanced field refuses, which is longer than the three the chapter names. | `ViralReconRunRequest.swift:250-264` |
| `ViralReconResultIngest` and `ViralReconResultInventory`, the path by which finished outputs come back into the project. The chapter stops at "the launched workflow writes its Nextflow outputs into the chosen results directory". | `Sources/LungfishWorkflow/ViralRecon/ViralReconResultIngest.swift`, `ViralReconResultInventory.swift` |
| `workflow run --repeat-from <bundle>`, which validates an original run bundle before starting a fresh attempt, the reproducibility path a workflow chapter should name. | `workflow.txt` `--repeat-from` |
| `--params-file` for JSON or YAML parameters, an alternative to repeating `--param`. | `workflow.txt` `--params-file` |
| Consensus coordinate mapping, which is how a viralrecon consensus lands back on reference coordinates. | `Sources/LungfishWorkflow/ViralRecon/ConsensusCoordinateMap.swift` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: viral-recon-tool-row -->` and planned_shot `viral-recon-tool-row`, captioned "The FASTQ/FASTA Operations dialog, Mapping category, with the Viral Recon tool row selected." | No | The dialog and its rows are not the entry point. Recapture as the open `Tools > Mapping` submenu with Viral Recon… visible as its fifth item, and rewrite the caption. |
| `<!-- planned: viral-recon-wizard-overview -->` and planned_shot `viral-recon-wizard-overview`, captioned "The Viral Recon wizard showing its four controls: inputs, primer scheme, minimum mapped reads, and readiness." | No, caption is wrong | The sheet also carries a Viral Recon header with the Docker Desktop note above the four, and a collapsed Advanced group between Minimum mapped reads and Readiness. Keep the shot, capture with a scheme selected and Readiness green, and rewrite the caption to name the header and Advanced. |

Fixture (after Phase 3): sarscov2-srr36291587 (viral by design)
Decision: rewrite. Four controls, Docker only, SARS-CoV-2 only, fetches MN908947.3 itself; lineage (Pangolin, Nextclade) documented here and nowhere else.

### 05-variants.md/01-calling-variants-from-amplicons.md

Verdicts: 40 true, 9 false, 7 changed, 5 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 17 | "Leave `Layout` at `Auto-detect`, so Lungfish reads the run's metadata and settles on paired-end by itself." | Leave `Layout` at `Any`, which is its default. `Layout` filters the search results by library layout; it does not tell the downloader what to do |
| 20 | "Then choose `Tools > FASTQ/FASTA Operations > Mapping…` and click the `minimap2` tool row." | Then choose `Tools > Mapping > minimap2` |
| 25 | "For long-read Nanopore data, click the `minimap2` row and choose the `Map ONT (map-ont)` preset instead." | For long-read Nanopore data, click the `minimap2` row and choose the `Oxford Nanopore` preset instead, which passes `-x map-ont` |
| 33 | "The Variant Calling dialog opens in three columns: a tool sidebar on the left, an `Inputs` section in the middle, and an `Output` section on the right." | The Call Variants dialog opens in two columns. A tool sidebar runs down the left. The right pane scrolls through `Overview`, `Thresholds`, a `<Tool> Settings` section named for the selected caller, `iVar Options` when iVar is selected, `Extra arguments`, and `Readiness`. A footer bar carries the readiness text, `Cancel`, and `Run` |
| 35 | "The `Inputs` section shows the primer-trimmed alignment track." | The `Overview` section carries an `Alignment Track` picker set to the primer-trimmed track, and an `Output Variant Track Name` field |
| 43 | "A new variant track named `iVar variants` appears under `MN908947.3 > Variants`." | The new variant track joins the bundle. Open the reference bundle and its rows appear on the Variants tab of the bottom table drawer, tagged in the `Source` column |
| 45 | "Click the `iVar variants` track in the sidebar to open the variant browser." | Open the `MN908947.3` reference bundle. The table drawer opens by itself at the bottom of the viewport because the bundle now carries a variant track. Click its `Variants` tab |
| 47 | "Its columns are `ID`, `Chrom`, `Position`, `Ref`, `Alt`, `Quality`, `Filter`, and `Source`." | Its fixed columns are `ID`, `Type`, `Chrom`, `Position`, `Ref`, `Alt`, `Quality`, `Filter`, `Samples`, `Source`, `Consequence`, and `AA Change`, plus a bookmark column |
| 55 | "The `R203K` and `G204R` consequences on screen come from the Inspector re-deriving them against the bundle's GFF3 as you select the row, not from any field in the file." | The amino-acid consequence is not in the VCF. Lungfish Genome Explorer derives it against the bundle's GFF3 and shows it in the table's `Consequence` and `AA Change` columns, and again in the Inspector when you select the row |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "Choose `Tools > Search Online Databases > Search NCBI…` to open the database search dialog." | Choose `Tools > Search Online Databases > Search NCBI...` |
| 16 | "Choose `Tools > Search Online Databases > Search SRA…`" | Choose `Tools > Search Online Databases > Search SRA...` |
| 28 | "In the `Primer scheme` picker, choose the bundled `QIASeqDIRECT-SARS2` scheme." | In the `Primer Scheme` picker, choose the bundled `QIASeqDIRECT-SARS2` scheme |
| 38 | "The iVar-specific `iVar Options` section holds the rest: consensus allele frequency `0.75`, merge AF distance `0.25`, minimum ALT quality `20`, and `Ignore strand bias (recommended for amplicons)` on." | Add a sentence noting the `Extra arguments` box below `iVar Options`, whose contents are inserted into the `ivar variants` command line |
| 41 | "The Lungfish converter reads it and, because the GFF3 came along, folds adjacent SNPs inside one codon into a single VCF row wherever the codon collapses into a single amino-acid change." | The converter folds adjacent within-codon SNPs into one VCF row when their allele frequencies agree, either because every frequency clears the consensus allele frequency or because they all sit within the merge AF distance of one another |
| 46 | "At the top sits a genome track that draws each variant as a tick; below it a reference panel updates as you navigate; at the bottom of the window waits a sortable variant table." | Describe the arrangement as the reference bundle viewport, with the variant table in a resizable drawer at the bottom |
| 49 | "To keep only confident calls, click the `Presets` toggle in the filter bar and select the `PASS` chip." | Click the `Presets ▸` button in the drawer toolbar and select the `PASS` chip |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `Tools > Call Variants…` as a direct top-level Tools menu route into the same dialog | `MainMenu.swift:719-724` |
| The `Extra arguments` free-text field in the Call Variants dialog, and where its contents land in the `ivar variants` command | `BAMVariantCallingToolPanes.swift:138-147`; `ViralVariantCallingPipeline.swift:1244` inserts them right after the `variants` subcommand |
| The `Readiness` section and its per-caller messages, which are also mirrored in the dialog footer | `BAMVariantCallingToolPanes.swift:187-195`; `BAMVariantCallingDialogState.swift:137-200`; `DatasetOperationsDialog.swift:123-140` |
| The `Alignment Track` picker, which lets the reader choose a different BAM without leaving the dialog | `BAMVariantCallingToolPanes.swift:31-37` |
| The tool sidebar's availability badges and `Requires <Pack> Pack` disabled reasons | `BAMVariantCallingCatalog.swift:94-104`; `DatasetOperationsDialog.swift:91-95` |
| The `bq` and `sb` FILTER codes the converter can emit alongside `ft` | `IVarTSVToVCFConverter.swift:123, 125` |
| The all-haplotypes VCF the converter writes beside the primary VCF | `ViralVariantCallingPipeline.swift:731`, `:745-751`; `IVarCodonMerger.swift:58-66` |
| The `QUAL` column in a Lungfish iVar VCF is always `.`, so sorting by `Quality` is meaningless for iVar rows | `IVarTSVToVCFConverter.swift:144` writes a literal `.` in the QUAL field |
| The SQLite variant database written alongside the VCF and index | `BundleVariantCallingModels.swift:81-104`, `:206-253` |
| The seven other bundled primer schemes beside QIASeqDIRECT-SARS2 | `Sources/LungfishApp/Resources/PrimerSchemes/` holds ARTIC-nCoV-2019-V3, ARTIC-SARS-CoV-2-V4, V4.1, V5.3.2, Midnight-1200-V1, NEB-VarSkip-vss1, NEB-VarSkip-Long-vsl1 |
| The primer-trim dialog's `Target` section, its `Output Track Name` field, and the caption that unmatched reads are retained | `BAMPrimerTrimToolPanes.swift:49-73` |
| `bundle create` options the script does not use but a reader may want, notably `--organism` and `--assembly` | `bundle.txt`, `==== bundle create ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `ncbi-search-fasta` | yes | The NCBI search pane with `Mode` and the results list is unchanged (`GenBankGenomesSearchPane.swift:22-36`) |
| `ncbi-search-gff3` | yes | `Include GFF3 Annotations` exists and is on by default, so the shot should show it already on rather than being toggled. Reword the caption |
| `sra-search-dialog` | caption needs a rewrite | The caption is fine but the surrounding procedure names a `Layout` value that does not exist. Reshoot after claim 17 is fixed so the visible `Layout` reads `Any` |
| `mapping-dialog` | yes | The five wizard sections are current |
| `primer-trim-dialog` | yes | The `Primer Scheme`, `Target`, and `Advanced Options` sections and their four defaults are current |
| `variant-call-dialog-ivar` | reshoot | The chapter's caption is fine but the surrounding text describes three columns and `Inputs`/`Output` sections. The shot must show the two-column dialog with `Overview`, `Thresholds`, `iVar Settings`, `iVar Options`, `Extra arguments`, and `Readiness` |
| `variant-browser-overview` | reshoot | The shot must show the reference bundle viewport with the table drawer open on its Variants tab, showing the twelve fixed columns, not a standalone browser with eight |
| `variant-browser-codon-merge` | reshoot | Same surface correction. The shot should also show the `Consequence` and `AA Change` columns populated, since claim 55 turns on them |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite, retitle 'Calling Variants'. Dialog is two columns (Overview, Thresholds, <Tool> Settings, iVar Options, Extra arguments, Readiness); Minimum AF and Minimum Depth reach only iVar; LoFreq runs plain call; results open in the table drawer's Variants tab.

### 05-variants.md/02-reading-the-variant-browser.md

Verdicts: 23 true, 12 false, 17 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "The variant browser is the main surface in Lungfish for reading, sorting, and exporting variants. It opens when you click a variant track in the sidebar, and it occupies the full viewport area of the project window." | The variant table is the main surface for reading and sorting variants. It sits in a resizable drawer at the bottom of the reference bundle viewport, and it opens by itself when the bundle you open carries at least one variant track |
| 5 | "A filter bar above the table accepts both chip-style presets and free-text smart-filter queries." | A toolbar above the table offers chip-style preset filters, a Search Builder sheet for structured queries, a scope control that switches between the visible region and the whole genome, and a Clear button |
| 8 | "The table has eight fixed columns. Seven come from the VCF specification and one (`Source`) is Lungfish-specific." | The table has twelve fixed columns. Seven come from the VCF specification. `Type` and `Samples` are derived from the record. `Source`, `Consequence`, and `AA Change` are added by Lungfish Genome Explorer |
| 18 | "In the sidebar, expand `Reference Sequences > MN908947.3 > Variants` and click the `iVar variants` track. The viewport switches to the variant browser." | Open the `MN908947.3` reference bundle from the sidebar. The table drawer opens at the bottom of the viewport because the bundle carries a variant track. Click the drawer's `Variants` tab |
| 29 | "Type into the free-text field on the right of the filter bar to write a smart-filter query directly." | Open the `Search Builder...` sheet to compose a query. The sheet writes the filter text for you |
| 34 | "`Position>=21000` keeps rows at or beyond coordinate 21000." | Use `pos:21000-29903` to keep rows in a coordinate window. The key is `pos` or `range`, and it takes a range rather than a comparison |
| 37 | "no colon syntax such as `Pos:1193`" | Colon and equals are interchangeable for the known keys, so `pos:100-200` and `pos=100-200` both work. The key is `pos`, not `Position` |
| 45 | "The track ticks are color-coded, but the `Source` column is the readable discriminator" | Use the `Source` column to tell the callers apart. The tick colors encode genotype and variant type, not which file a row came from, so they cannot separate two callers |
| 46 | "The chip applies the smart-filter expression `Filter=PASS` behind the scenes; you can verify this by clicking the chip while watching the free-text field." | Drop the verification instruction. The `PASS` chip restricts the table to rows whose `Filter` reads `PASS` |
| 47 | "You should see `Ref C`, `Alt T`, `Quality` near the caller maximum" | You should see `Ref C`, `Alt T`, a blank `Quality` because iVar writes none, `Filter PASS`, and the per-sample `FORMAT` values |
| 49 | "Now switch the filter to `AF>=0.05 AF<0.5` by typing into the free-text field. The chip selection clears." | Open the `Search Builder...` sheet and build the two clauses `AF>=0.05` and `AF<0.5` |
| 50 | "Clear the filter by clicking the `x` on the right of the free-text field." | Clear the filter with the `Clear` button in the drawer toolbar |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "The browser has three regions stacked vertically. The top region is a genome track ... The middle region is a reference panel ... The bottom region is a sortable variant table" | Describe the viewport plus a drawer, and say the drawer height is draggable and persists |
| 12 | Column table row: "`Quality` \| Phred-scaled caller confidence \| Sort to triage low-confidence rows" | Note that iVar rows carry no quality value, so the column is blank for them |
| 13 | Column table row: "`Filter` \| Caller-assigned status (`PASS`, `ft`, `sb_fdr`, etc.)" | Caller-assigned status. Lungfish's iVar output uses `PASS`, `ft`, `bq`, and `sb`. LoFreq writes its own codes |
| 14 | "Beyond those eight, the table promotes whatever `INFO` keys the loaded VCF actually defines into their own columns. There is no fixed list and no dotted `INFO.AF` naming" | Beyond the fixed columns, the table promotes whatever `INFO` keys the loaded VCF defines. A curated few are placed first in a biologically useful order and the rest follow in discovery order |
| 16 | "a `GT` sub-tab above the table switches the view from one-row-per-variant to one-row-per-sample genotype" | A two-segment control above the table switches between `Calls` and `Genotypes`. At narrow widths the second segment shortens to `GT` |
| 17 | "the left-pane sample selector controls which samples that genotype view and the per-sample filters apply to" | Use the drawer's `Samples` tab to hide or show samples. The genotype view and the per-sample filters follow that same visible set |
| 19 | "If the track does not appear in the sidebar, the variant calling step from the previous chapter has not finished yet." | If the drawer does not open, or its Variants tab is empty, the variant calling step has not finished yet |
| 21 | "Click the `Quality` header to sort by caller confidence; the highest-quality calls float to the top." | Click `Quality` to sort by caller confidence. The first click sorts ascending, so click twice for the highest first. iVar rows carry no quality value |
| 24 | "The Inspector on the right fills with the per-row detail: every `INFO` field from the VCF, every `FORMAT` field for every sample, and any annotation context Lungfish can attach" | Add that the same consequence and amino-acid change appear in the table columns |
| 25 | "The filter bar sits above the table. Click the `Presets` toggle on the left to reveal a row of curated chips." | Click the `Presets ▸` button in the drawer toolbar to reveal a row of curated chips. The button hides itself when the window is too narrow or the VCF carries no INFO keys |
| 26 | "The curated set includes `PASS`, `SNV`, `Indel`, `High Impact`, `Qual >= 30`, `DP >= 10`, and three chips built for reading viral minority variants: `Minor (<=20%)`, `Mixed (20-80%)`, and `Dominant (>=80%)`." | The curated set holds fourteen chips grouped into four sections. `Biological Effect` carries `SNV`, `Indel`, `High Impact`, `Moderate+`, and `ClinVar Path.`. `Quality / QC` carries `PASS`, `Qual >= 30`, and `DP >= 10`. `Population / Frequency` carries `Rare (<1%)`, `Minor (<=20%)`, `Mixed (20-80%)`, and `Dominant (>=80%)`. `Sample / Genotype` carries `Het Only` and `Bookmarked` |
| 27 | "Click a chip to apply it, click again to remove it, and combine chips to narrow further." | Click a chip to apply it and click again to remove it. Chips from different groups combine, but the two type chips, the two impact chips, and the three frequency chips each behave like radio buttons within their group |
| 30 | "the operators are `=`, `!=`, `<`, `<=`, `>`, `>=`, and `~` (contains)" | The table filter recognises `=`, `!=`, `<`, `<=`, `>`, `>=`, `~` (contains), `!~` (does not contain), `^=` (starts with), and `$=` (ends with). Per-sample clauses accept only the six comparison operators |
| 35 | "`AF>=0.05 AF<0.5` keeps rows in the minority-variant band." | Write `AF>=0.05; AF<0.5`. Separate clauses with a semicolon |
| 48 | "The Inspector also shows the annotation block `Gene S, Codon 19, AA T19I`, which it derives from the bundle's GFF3" | Say the derived consequence appears in both the table's `Consequence` and `AA Change` columns and in the Inspector |
| 52 | "A row tagged anything else (`ft`, `sb_fdr`, `min_dp_10`, depending on the caller) failed at least one." | A row tagged anything else failed at least one. Lungfish's iVar output uses `ft`, `bq`, and `sb`. Other callers write their own codes |
| 54 | "`Filter=PASS AF>=0.05 DP>=20` is a reasonable opening filter" | `Filter=PASS; AF>=0.05; DP>=20` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `Search Builder...` sheet, which is the actual query-composition surface, and the fact that it is disabled on very large databases | `AnnotationTableDrawerView.swift:859-866`; `+Columns.swift:108-131` gates it on database size and viewport width, with a tooltip explaining why |
| The `Region` / `Genome` scope control, which decides whether the table follows the visible viewport or queries the whole genome | `AnnotationTableDrawerView.swift:776-789` |
| The haploid-mode menu that decides how the within-sample frequency chips behave | `AnnotationTableDrawerView.swift:794-800`, tooltip `Within-sample AF token mode: Auto from reference size, or force haploid/diploid` |
| The `Local: Visible Rows` badge that tells the reader the filter is scoped to loaded rows | `AnnotationTableDrawerView.swift:545` |
| The bookmark column and the `Bookmarked` chip that reads it | `+Columns.swift:404-406`; `SmartFilterTokens.swift:26`, `:61` |
| The drawer's `Annotations` and `Samples` tabs, which share the same drawer with `Variants` | `+Columns.swift:344-347`; sample columns at `:327-332` |
| The drawer's export path for the visible rows | `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView+Export.swift` |
| Saved query presets, which the Search Builder can store and reapply | `+Filtering.swift:2139-2144`; `VariantQueryBuilderSheet.swift:36`, `:214-221` |
| Column visibility and ordering are persisted per tab across sessions | `+Columns.swift:415-430` (`ColumnPrefsKey.load`) |
| The `Type` and `Samples` columns, and what each holds | `+Columns.swift:314`, `:320`; `+TableView.swift:804-805` |
| The drawer is resizable and its height persists in `UserDefaults` | `ViewerViewController+AnnotationDrawer.swift:132-135` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `variant-browser-overview` (planned) | reshoot, and rewrite the caption | The caption names eight columns. There are twelve fixed columns plus a bookmark column, and the surface is a drawer inside the bundle viewport rather than a standalone browser |
| `variant-browser-filter` (planned) | reshoot, and rewrite the caption | The caption says "filter bar with the PASS smart-filter chip selected". The button is `Presets ▸`, the strip is grouped into four named sections, and there is no free-text field beside it |
| `variant-browser-inspector` (planned) | yes, with a caption change | The Inspector does show INFO and FORMAT for the selected row. The caption should note that the consequence also appears in the table's own columns |
| `variant-browser-source-column` (planned) | yes | Two variant tracks in one bundle do aggregate into one table with a populated `Source` column. Keep the shot but make sure it does not imply the ticks are color-coded by caller |
| New shot needed | add | The `Search Builder...` sheet, since it replaces every free-text-field instruction in this chapter |

Fixture (after Phase 3): hg002-chr20 expected/ caller output
Decision: rewrite, retitle 'Reading the Variants Table'. No variant browser viewport; the drawer's Variants tab with twelve columns (Consequence and AA Change included), Presets chips in four sections, Search Builder, pos and range clauses; the free-text field is hidden.

### 05-variants.md/03-cross-caller-comparison.md

Verdicts: 19 true, 7 false, 7 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 10 | "The `Inputs` section shows the selected alignment." | The `Overview` section shows an `Alignment Track` picker set to the selected alignment |
| 13 | "The only controls that reach LoFreq are the shared `Minimum Allele Frequency` and `Minimum Depth` thresholds and the free-text `Extra arguments` box." | The only control that reaches LoFreq is the free-text `Extra arguments` box. The shared `Minimum Allele Frequency` and `Minimum Depth` fields are recorded in provenance for the run but are not passed to LoFreq |
| 15 | "Behind the dialog, Lungfish runs `lofreq call-parallel --pp-threads N -f <reference> -o <out> <bam>`, slotting anything from `Extra arguments` in immediately after `call-parallel`" | Behind the dialog, Lungfish Genome Explorer runs `lofreq call -f <reference> -o <out> <bam>`, inserting anything from `Extra arguments` immediately after `call` and ahead of the `-f`, `-o`, and BAM arguments |
| 18 | "A new variant track named `LoFreq variants` appears under `MN908947.3 > Variants` beside the iVar track" | The new track joins the bundle, and its rows appear on the Variants tab of the table drawer with `Source` naming the LoFreq file |
| 20 | "Click either variant track in the sidebar to open the variant browser." | Open the reference bundle. The table drawer opens with both callers' rows already loaded |
| 23 | "To navigate, click the row in the table, or type a `Position=` clause into the filter bar (for example `Position=1193`)." | To navigate, click the row in the table, or open the `Search Builder...` sheet and add a `pos` range clause such as `pos:1190-1196` |
| 24 | "The colon syntax some tools use (`Pos:1193`) is not a valid operator here, and the column is `Position`, not `Pos`." | Colon and equals are interchangeable for the known clause keys. The clause key for coordinates is `pos` or `range` and it takes a range, even though the column header reads `Position` |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | Caller table row: "Codon awareness \| Yes, when given a GFF; merges adjacent within-codon SNPs into one row" for iVar | Yes, when given a GFF. Adjacent within-codon SNPs merge into one row when their allele frequencies agree |
| 8 | "In the Inspector's `Analysis` section, select `Variant Calling` and click `Call Variants`." | click `Call Variants…` |
| 11 | "The `This BAM has already been primer-trimmed` acknowledgement matters only for iVar and stays unchecked here." | The primer-trim acknowledgement belongs to iVar. With LoFreq selected the caller section shows only a one-line note, so the toggle is not on screen at all |
| 22 | "Read the callers apart from the `Source` text, not the tick color on the genome track" | Read the callers apart from the `Source` text. The tick colors encode genotype and variant type, not the source file, so they cannot separate two callers at all |
| 25 | "Filter to `Position=1193`. In the fixture the table shows one row, source iVar, with `REF A`, `ALT G`, an allele frequency around 0.12 at a depth near 1500, filter `PASS`." | Filter to `pos:1190-1196`. In the fixture the table shows one row, source iVar, ... |
| 26 | "Filter to `Position=1989`." (and the same at 27889 and 28881) | Use a `pos` range clause in each case |
| 27 | "The amino-acid labels come from the Inspector deriving them against the bundle's GFF3; they are not stored in the VCF, whose only `INFO` key is `TYPE`." | The amino-acid labels are derived against the bundle's GFF3 and shown in the table's `Consequence` and `AA Change` columns as well as in the Inspector. They are not stored in the VCF, whose only `INFO` key is `TYPE` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `bcftools mpileup` flags Lungfish actually uses, which differ from the iVar pileup and explain part of the caller disagreement | `ViralVariantCallingPipeline.swift:1329-1336` runs `bcftools mpileup -Ou -f <ref> <bam>` with no depth cap, where iVar's pileup uses `-aa -A -d 600000 -B -Q 20 -q 0` (`:1227-1239`) |
| The `bcftools call -mv -Ov` flags the pipeline appends after any extra arguments | `ViralVariantCallingPipeline.swift:1338-1346` |
| LoFreq's indel-quality preprocessing branch, which fires whenever `--call-indels` appears in `Extra arguments` and inserts `lofreq indelqual --dindel` plus `lofreq index` ahead of the call | `ViralVariantCallingPipeline.swift:1188-1215`, `:578-676` |
| The all-haplotypes VCF, which is the closest thing Lungfish has to a decomposed iVar call set and would remove the need for `bcftools norm -a` in some workflows | `ViralVariantCallingPipeline.swift:731`, `:745-751` |
| Clair3 and Medaka as further orthogonal callers reachable from the same dialog | `BAMVariantCallingCatalog.swift:9-16` |
| The `Samples` column and the `Genotypes` sub-tab, both of which help when two tracks carry different sample names | `+Columns.swift:320`, `:39-64` |
| The drawer's saved query presets, which make a repeated cross-caller filter reusable | `+Filtering.swift:2139-2144` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `cross-caller-source-column` (planned) | yes, with a caption change | The aggregated table with a populated `Source` column is real. The caption should not imply a standalone browser |
| `cross-caller-disagreement-1193` (planned) | reshoot the procedure around it | The shot itself is fine, but the instruction that produces it (`Position=1193`) does not work. Capture it after filtering with a `pos` range clause from the Search Builder |
| `cross-caller-disagreement-1989` (planned) | reshoot the procedure around it | Same reason |
| `cross-caller-codon-merge-28881` (planned) | yes, with an added requirement | Keep the shot but make sure the `Consequence` and `AA Change` columns are visible, since claim 27 turns on them |
| New shot needed | add | The `LoFreq Settings` section of the Call Variants dialog, showing that it holds only the one-line note and that the primer-trim toggle is absent |

Fixture (after Phase 3): none
Decision: delete. No comparison view, intersection, or union export exists. One paragraph in the retitled chapter 02 explains how to compare two callers' tracks by eye with presets; the nav entry is removed and its help-ids retargeted.

### 05-variants.md/04-nanopore-variant-calling.md

Verdicts: 20 true, 7 false, 2 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "Then choose `Tools > FASTQ/FASTA Operations > Mapping…` and click the `minimap2` tool row." | Then choose `Tools > Mapping > minimap2` |
| 7 | "Under `Preset`, choose `Map ONT (map-ont)`, which tunes minimap2 for noisy long reads." | Under `Preset`, choose `Oxford Nanopore`, which passes `-x map-ont` and tunes minimap2 for noisy long reads |
| 10 | "Medaka, like iVar, reads the sidecar and knows the alignment is already trimmed." | Lungfish Genome Explorer reads the primer-trim sidecar, but it acts on it only for iVar. Medaka receives no signal that the alignment was trimmed, so the trim step matters biologically rather than mechanically here |
| 11 | "The dialog opens in three columns: a tool sidebar on the left, an `Inputs` section in the middle, and an `Output` section on the right." | The dialog opens in two columns, a tool sidebar and a scrolling detail pane |
| 16 | "depth comes from the shared `Minimum Depth` threshold, which defaults to `10`" | The shared `Minimum Depth` field is recorded in the run's provenance but is not passed to Medaka or Clair3. To set a depth threshold in either tool, use the `Extra arguments` box |
| 21 | "When the operation finishes, a new variant track appears under `Variants` in the sidebar." | The new variant track joins the bundle and its rows appear on the Variants tab of the table drawer |
| 24 | "primer-trim with the bundled `ARTIC-v3-SARS2` scheme" | primer-trim with the bundled `ARTIC-nCoV-2019-V3` scheme |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 13 | "The middle column redraws to show a single caller-specific control: a model field. Both callers read from the same field, so there is one box to fill no matter which of the two you picked." | The detail pane redraws to show one caller-specific control, labelled `Medaka Model` or `Clair3 Model`. Both write to the same underlying setting, so switching between the two callers keeps whatever you typed |
| 27 | "The third is picking the `Short read (sr)` minimap2 preset by accident." | The third is picking the `Short-read` minimap2 preset by accident |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `Extra arguments` box, which is the only route to any Medaka or Clair3 flag beyond the model | `BAMVariantCallingToolPanes.swift:138-147`; `ViralVariantCallingPipeline.swift:1308`, `:1326` |
| Clair3's `--output` flag, which points at the directory Lungfish then reads `merge_output.vcf.gz` from | `ViralVariantCallingPipeline.swift:1325`, `:914-940` |
| The `-t <threads>` value Medaka and Clair3 receive, which defaults to the machine's active processor count | `BundleVariantCallingModels.swift:53` |
| The `Readiness` line for Medaka and Clair3, which names the model back to the reader before the run | `BAMVariantCallingDialogState.swift:191-198` |
| The FASTQ reconstruction's flag filter, `samtools fastq -F 2304`, which drops secondary and supplementary alignments before Medaka sees the reads | `ViralVariantCallingPipeline.swift:262-271` |
| The distinct failure mode when FASTQ reconstruction produces nothing, which surfaces as a named error rather than an empty VCF | `ViralVariantCallingPipeline.swift:279-286` |
| The pinned tool versions, medaka 2.2.2 and clair3 2.0.2, which bound which model families are usable | `third-party-tools-lock.json:38-39` |
| The other bundled ONT-relevant primer schemes, Midnight-1200-V1 and the two NEB VarSkip schemes | `Sources/LungfishApp/Resources/PrimerSchemes/` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `variant-call-dialog-medaka` (planned) | reshoot, and rewrite the caption | The caption says "with Medaka selected on the tool sidebar and the empty model field showing its placeholder", which is accurate, but the surrounding procedure describes a three-column dialog. Capture the two-column layout with the `Medaka Settings` section and its `Medaka Model` field |
| `medaka-model-field` (planned) | yes | A model string typed in with `Run` enabled is exactly what the code produces (`BAMVariantCallingDialogState.swift:225-227`) |
| New shot needed | add | The `Tools > Mapping` submenu, since claim 5 replaces a menu path this chapter and chapter 01 both get wrong |

Fixture (after Phase 3): hg002-long-reads (ONT chrM) mapped with map-ont
Decision: rewrite. Medaka and Clair3 from the same Call Variants dialog; model identifiers are required; preset name is Oxford Nanopore.

### 05-variants.md/05-consensus-and-lineage.md

Verdicts: 18 true, 1 false, 6 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 18 | "`Extract Consensus…` exports the selected bases when there is an active base selection; otherwise it exports the visible viewport." | `Extract Consensus…` uses the `Consensus scope` picker above it. Choose `Whole contig` for the full sequence or `Selected region` for a selection |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Lungfish produces a consensus FASTA on three other surfaces: the Viral Recon wizard ..., `lungfish msa consensus` ..., and the Inspector's consensus mode" | Name the Inspector surface the Analysis tab's `Consensus` section, and say its `Extract Consensus…` button writes a FASTA for the scope you choose |
| 9 | Table row: "Inspector consensus mode \| Consensus minimum depth, minimum MAPQ, and minimum base quality sliders" | List the full control set, or say the section carries a mode picker, a scope picker, two toggles, and up to five numeric sliders |
| 12 | "Choose `Tools > Mapping > Mapping…`, then select the `Viral Recon` tool row in the Mapping category." | Choose `Tools > Mapping > Viral Recon` |
| 17 | "The controls there (`Consensus Mode`, `Use IUPAC ambiguity codes`, `Hide high-gap sites`, and sliders for consensus minimum depth, minimum MAPQ, and minimum base quality) drive the preview." | Add the `Bayesian` and `Simple` modes, the `Consensus scope` picker with `Whole contig` and `Selected region`, the `Show consensus track in viewer` toggle, and the two masking sliders that appear when `Hide high-gap sites` is on |
| 19 | "This is for inspection. For a whole-genome deposit, use Viral Recon or `lungfish msa consensus`." | Say the Inspector path can produce a whole-contig consensus, and that Viral Recon is preferred for surveillance because it runs the whole pipeline from reads |
| 26 | "Lungfish produces a consensus FASTA and stops. Lineage assignment is deliberately left to external software" | Lungfish Genome Explorer's own consensus surfaces stop at the FASTA. The Viral Recon pipeline is the exception, because nf-core/viralrecon runs Pangolin and Nextclade as stages of its own |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `Consensus Mode` picker's two values, `Bayesian` and `Simple`, and what choosing between them means | `ReadStyleSection.swift:2450-2453`; `AlignmentDataProvider.swift:59-63` |
| The `Consensus scope` picker, `Whole contig` versus `Selected region`, which is what `Extract Consensus…` actually reads | `ReadStyleSection.swift:2459-2466`, `:2530-2532` |
| The `Show consensus track in viewer` toggle | `ReadStyleSection.swift:2445-2448` |
| The `Gap threshold` and `Masking minimum depth` sliders, which appear only when `Hide high-gap sites` is on | `ReadStyleSection.swift:2488-2506` |
| The consensus insertion and deletion policies the underlying request carries | `AlignmentDataProvider.swift:90-98` (`InsertionPolicy` omit or include, `DeletionPolicy` n or omit) |
| The read-group filter that also gates consensus evidence | `AlignmentDataProvider.swift:66-72` (`readGroups`, `excludedFlags`) |
| `lungfish msa consensus --output-kind reference`, which writes a `.lungfishref` bundle rather than a bare FASTA | `msa.txt`, `--output-kind  Output kind: fasta or reference (default: fasta)` |
| `lungfish msa consensus --rows`, which restricts the consensus to named rows | `msa.txt` |
| `lungfish freyja demix --extra-args` | `freyja.txt` |
| The Freyja version the lock pins, 2.0.3 | `third-party-tools-lock.json:53` |
| That `wastewater-surveillance`, like `gatk-core` and `phasing`, is an experimental pack | `PluginPack.swift:833-840` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `viralrecon-consensus-picker` (planned) | cannot judge | The wizard's `Consensus` picker was not confirmed in source in this pass. Confirm the control exists before commissioning the shot |
| `inspector-consensus-mode` (planned) | reshoot, and rewrite the caption | The caption names four controls. The section holds at least eight, and the caption omits the `Consensus scope` picker, which claim 18 turns on |
| `msa-consensus-cli` (planned) | yes | A terminal shot of the command with an explicit `--threshold` is accurate |
| New shot needed | add | The `Tools > Mapping > Viral Recon` menu path, since claim 12 corrects it |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite, retitle 'Extracting a Consensus Sequence'. Inspector Consensus tab with its scope picker and evidence controls (bam.extract-consensus); lineage assignment moves to the Viral Recon chapter.

### 05-variants.md/06-importing-existing-vcfs.md

Verdicts: 22 true, 8 false, 9 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 11 | "Click **Choose File** and select your VCF." | Click the **VCF Variants** card's Import button and select your VCF in the file panel that opens. The panel allows more than one file |
| 12 | "Read the **Inferred reference** field. Lungfish reads the VCF's `CHROM` column, applies its alias map, and names the reference bundle in your project that matches." | There is no inferred-reference readout. Which bundle the VCF joins is decided by which reference bundle is open in the viewport when you import |
| 13 | "If none matches, the field reads \"No matching bundle\" and the **Import** button stays disabled." | With no reference bundle open, Lungfish Genome Explorer asks you to name a new variant bundle it will create inside the active project. With no project open at all, it refuses and tells you to open or create one first |
| 14 | "If it is wrong ..., open the **Reference** dropdown and pick the right one by hand." | To send the VCF to a particular bundle, open that bundle in the viewport first, then import |
| 17 | "If inference is unambiguous, the import completes silently and the track appears. If inference is ambiguous or fails, the Import Center opens with the file pre-selected." | Drag-drop runs the same import logic. With no reference bundle open it prompts for a new bundle name, exactly as the Import Center path does |
| 32 | "The **Inferred reference** field reads `MN908947.3 (SARS-CoV-2 reference)`, with a small caption noting that the VCF's `CHROM` value `NC_045512.2` matched through the RefSeq alias." | Rewrite the worked example around the real flow. Open the `MN908947.3` bundle in the viewport first, then import the study VCF, and it joins that bundle |
| 34 | "Click that track. The variant browser opens" | Open the bundle. The table drawer opens on its own with the imported rows |
| 36 | "If the Import Center reports \"No matching bundle\"" | Rewrite the troubleshooting entry around the real failure, which is `No Active Project` when no project is open (`MainSplitViewController+GenomicsDisplay.swift:158-160`) |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "The Import Center under the File menu is the guided path, the one that matches the VCF to a reference bundle and attaches it as a variant track you read in the browser." | The Import Center's `Variants` tab opens a file picker. What happens next depends on the project. With a reference bundle already open in the viewport, the VCF attaches to that bundle. With none open, Lungfish Genome Explorer builds a new bundle around the VCF and then tries to download a matching reference |
| 5 | "Lungfish ships an alias map that recognises these as one sequence and matches the VCF to whatever reference bundle in your project carries that sequence under any of those names." | Lungfish Genome Explorer normalises chromosome names through an alias resolver, and it recognises `MN908947.3` and `NC_045512.2` as the same SARS-CoV-2 sequence. Do not promise recognition of `chrCOV19` or `SARS-CoV-2-WH01`, which the code does not carry |
| 7 | Format table row: "BCF \| `.bcf` \| None required \| Accepted by the reader; the CLI also accepts `.bcf`." | BCF: accepted by `lungfish import vcf`. The Import Center's file picker offers only `.vcf` and `.gz`, so a BCF has to be converted before the guided import |
| 10 | "Open the Import Center with `File > Import Center`, then click the **Variants** tab." | Open the Import Center with `File > Import Center…`, then click the **Variants** tab |
| 15 | "Wait for the progress bar to finish, then close the Import Center. As it imports, it copies the VCF into the project, bgzips and indexes it if needed, and writes a provenance entry recording the source path and the matched reference." | Rewrite to say the import copies the VCF into the project, bgzips and indexes it when needed, and records a provenance entry for the run |
| 16 | "When it finishes, the new variant track appears in the sidebar, nested under the matched reference bundle." | When it finishes, the bundle appears in the sidebar. Open it and the imported variants fill the Variants tab of the table drawer |
| 33 | "The sidebar now shows a variant track named `study42_lineage_calls` under the SARS-CoV-2 reference bundle." | Rewrite alongside claim 32 |
| 35 | "Cross-reference the published variants against your own samples by opening both tracks at once" | Cross-reference by importing the published VCF into the same bundle that holds your own calls. Both callers' rows land in one table, told apart by the `Source` column |
| 40 | Frontmatter: `entry_points: ["File > Import Center > Variants", "Drag-drop a VCF into the sidebar", "CLI: lungfish import vcf"]` | Add `File > Open` as a fourth entry point and write the menu item as `File > Import Center…` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `File > Open` as a VCF entry point | `docs/user-manual/features.yaml:18` |
| The bundle-naming prompt, `Name Imported Variant Bundle`, which is the single most visible step on the no-bundle path | `MainSplitViewController+GenomicsDisplay.swift:250-270` |
| The replace-existing behaviour when the chosen bundle name already exists in the project | `MainSplitViewController+GenomicsDisplay.swift:268-273` |
| The background reference download that fires after a naked-bundle import, using accessions inferred from the VCF | `MainSplitViewController+GenomicsDisplay.swift:212-224`; `VCFReferenceInference.swift:43`, `:133-201` |
| The `No Active Project` refusal, which is the real "cannot import" path | `MainSplitViewController+GenomicsDisplay.swift:155-165` |
| The multi-file selection the Import Center's panel permits | `ImportCenterViewModel.swift:402` |
| The `Default Ploidy` metadata item the auto-ingestor writes into the bundle | `VCFAutoIngestor.swift:273` |
| `lungfish analyze validate --strict` | `analyze.txt` |
| The `import sample-metadata` and `import metadata` commands, which attach a sample sheet to an imported variant track | `import.txt` subcommand list |
| The `variants extract-sample` and `variants query` `--format` option (`text`, `json`, `tsv`) | `variants.txt` |
| The write-permission gate that runs before any VCF import | `AppDelegate+ImportCenter.swift:48-54` (`canWriteProjectOutputs`) |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `import-center-variants` (planned) | reshoot, and rewrite the caption | The caption says "with a chosen VCF and the inferred reference bundle shown". Neither a chosen-file readout nor an inferred-reference field exists. Capture the `Variants` tab showing the `VCF Variants` card |
| `imported-vcf-track-sidebar` (planned) | reshoot, and rewrite the caption | The caption says "with the new variant track nested under its matched reference bundle". There is no nested variant-track node. Capture the bundle in the sidebar with the table drawer open on its Variants tab |
| New shot needed | add | The `Name Imported Variant Bundle` prompt, which is the step the chapter never mentions and every no-bundle import hits |

Fixture (after Phase 3): hg002-chr20 benchmark VCF
Decision: rewrite from scratch. The VCF Variants card opens a plain file panel; with a bundle open the VCF joins it, otherwise Name Imported Variant Bundle creates one and a reference downloads in the background. No inference UI.

### 06-classification.md/01-what-is-classification.md

Verdicts: 16 true, 4 false, 3 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Open the run wizard at `Tools > FASTQ/FASTA Operations > Classification…` and let it pick the right database." | "Open the classifier you want from `Tools > Classification`, which lists Kraken2, EsViritu, and TaxTriage as three separate items." |
| 15 | "Open it from `Tools > FASTQ/FASTA Operations > Classification…`. This is a single menu item, not a submenu: there is no `Classification > Kraken2` or `Classification > EsViritu` path." | "Open it from `Tools > Classification`. That is a submenu, and it lists the three runnable classifiers as separate items, so `Tools > Classification > Kraken2…` opens the dialog with Kraken2 already selected." |
| 20 | "the Operations Panel logs the run, and the result appears as a new track on the source FASTQ bundle when it completes" | "the Operations Panel logs the run, and the result appears in the project's `Analyses` folder as its own timestamped analysis directory when it completes" |
| 21 | "Lungfish keeps each classification result as its own track on the FASTQ bundle, so you can have a Kraken2 result and an EsViritu result side by side" | "Lungfish writes each classification run into its own timestamped folder under `Analyses`, so a Kraken2 result and an EsViritu result sit side by side without overwriting each other." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 10 | "Each row is one taxon, with columns for rank, name, read count, and percent of classified reads." | "Each row is one taxon, with columns for Sample, Taxon Name, Rank, Reads (the clade count), Direct (reads assigned exactly to that taxon), and % of classified reads. A Bracken column joins them when Bracken abundance estimation ran." |
| 16 | "The wizard opens with a tool picker showing the three runnable classifiers (Kraken2 in blue, EsViritu in green, TaxTriage in purple…)" | "The dialog opens on the classifier you picked in the menu, with a sidebar listing the other classifiers in the Classification category so you can switch without reopening the menu." |
| 22 | "A standard Kraken2 database covers bacteria, archaea, viruses, fungi, and the human genome" | "A standard Kraken2 database covers archaea, bacteria, viruses, plasmids, the human genome, and UniVec. Fungi and protozoa arrive with the PlusPF builds." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Classification category submenu also carries the workflow-library entries for the category, drawn separately below a divider (STRUCK 2026-09-07 at the chapter 32 review. The divider is drawn only when the category has workflows, and no WorkflowLibraryItem is filed under classification, so the submenu holds three items and no divider.) | `MainMenu.swift:794-798` |
| Six cards on the Import Center's Classification Results tab, not three: Kraken2, EsViritu, TaxTriage, NAO-MGS, NVD, CZ-ID | `ImportCenterViewModel.swift:413-508` |
| 12S Amplicon Matching is filed under the Genotyping category, not Classification, and is a specialized workflow that must be enabled first | `WorkflowLibrary.swift:141-149` (`categoryID: .genotyping`, `maturity: .specialized`) |
| The Kraken 2 catalog has nine collections including MinusB and EuPathDB46, plus two locally built special databases (SILVA, Greengenes) | `MetagenomicsModels.swift:75-84`; `third-party-tools-lock.json` databases section |
| Every classification run registers an OperationCenter entry titled "Classifying <file>" or "Classification Batch (N samples)" | `AppDelegate+Classification.swift:851-858`, `:1385-1386` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `classification-wizard-tool-picker` (planned) | No | Its caption says "The Classification wizard with its three runnable tools visible". The live surface is the shared FASTQ/FASTA Operations dialog opened from `Tools > Classification > Kraken2…`, with the other two classifiers in a sidebar. Recaption to name that dialog and the menu path that opens it. |
| `taxonomy-viewport-overview` (planned) | Yes, with a caption fix | The sunburst, per-taxon table, and breadcrumb bar all exist (`TaxonomyViewController.swift`, `TaxonomyTableView.swift`, `TaxonomyBreadcrumbBar.swift`). The caption should also name the "Filter taxa…" search field above the table (`TaxonomyTableView.swift:225-232`). |
| `<!-- planned: taxonomy-viewport-overview -->` marker | Yes | Sits in the viewport section, which is the right place. |
| `<!-- planned: classification-wizard-tool-picker -->` marker | Yes, once the surrounding text is corrected | Sits under "Where the wizard lives", which must be rewritten around the new menu path first. |
| `classification-question` illustration | Yes | The schematic is conceptual and does not depend on any menu path. |

Fixture (after Phase 3): sarscov2-srr36291587 (viral by design)
Decision: rewrite. Concept chapter; Tools > Classification > <tool>...; results land in Analyses/<tool>-<timestamp>/.

### 06-classification.md/02-running-kraken2.md

Verdicts: 47 true, 6 false, 8 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "Lungfish labels the tool 'Classify & Profile (Kraken2)'" | "Lungfish labels the tool 'Kraken2' and describes it as 'Classify reads taxonomically', because it runs Kraken2 to assign the reads and then Bracken to estimate community abundance from those assignments." |
| 12 | " \| Custom \| varies \| … \| User-built from selected RefSeq taxa \| " | Drop the Custom row and replace it with the two collections the table omits: " |
| 17 | "With a FASTQ bundle selected in the project sidebar, open `Tools > FASTQ/FASTA Operations > Classification…`. It is one menu item, not a submenu." | "With a FASTQ bundle selected in the project sidebar, open `Tools > Classification > Kraken2…`. Classification is a submenu, and picking Kraken2 there opens the FASTQ/FASTA Operations dialog with Kraken2 already selected." |
| 18 | "In the **Classifier** picker, choose **Kraken2**." | "Kraken2 is already selected, because you chose it in the menu. The dialog's tool sidebar lists EsViritu and TaxTriage beside it if you want to switch." |
| 32 | "The Operations Panel … shows a progress row labelled `Kraken2: <bundle>`." | "The Operations Panel shows a progress row labelled `Classifying <file name>`, or `Classification Batch (N samples)` for a multi-sample run." |
| 33 | "a `SRR36291587.kraken2.viral.lungfishtax` bundle appears in the sidebar" | "a `kraken2-<timestamp>` folder appears under the project's `Analyses` folder in the sidebar" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "The result lands as a taxonomy bundle in the project and opens in the taxonomy viewport" | "The result lands as a timestamped analysis folder under the project's `Analyses` folder and opens in the taxonomy viewport" |
| 6 | " \| Viral \| ~0.5 GB \| 1 GB \| " | " |
| 22 | "a **Minimum hit groups** field (default 2)" | "a **Min hit groups** stepper (default 2, range 1 to 10)" |
| 27 | "The Advanced section" (name) | "The **Advanced Settings** section" |
| 28 | "The **Input FASTQ** field is pre-filled with whatever bundle was selected when you opened the wizard." | "The dialog's dataset line names whatever bundle was selected when you opened it." |
| 34 | "The table on the right mirrors the sunburst, one row per taxon, with columns for taxon name, rank, read count, and percentage of total classified reads." | "The table on the right mirrors the sunburst, one row per taxon, with columns for Sample, Taxon Name, Rank, Reads, Direct, and %. A Bracken column appears when Bracken abundance estimation ran." |
| 38 | "Save as Bundle writes a new virtual FASTQ bundle into the project" | "Save as Bundle writes a new FASTQ bundle into the project's top-level `Extractions` folder" |
| 63 | "`lungfish build-db kraken2 <result-dir>` builds a SQLite database from a Kraken2 result directory … the power-user route when you need a custom database the Plugin Manager does not offer." | "`lungfish build-db kraken2 <result-dir>` builds a SQLite index over an existing Kraken2 result directory so the viewport can query it quickly (with `--force` to overwrite, `--no-cleanup` to keep intermediates, and `--sample-dir` to name one sample directory at a time). It does not build a Kraken2 classification database, and LGE offers no route to build one." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The taxonomy table's "Filter taxa…" search field, added in August 2026 | `TaxonomyTableView.swift:185`, `:225-232` |
| The Bracken column, hidden until Bracken abundance estimation ran | `TaxonomyTableView.swift:288-298`, `:63` |
| Per-column header filter menus on the taxonomy table | `TaxonomyTableView.swift:141-151`, `:960-979` |
| The taxon context menu's Copy Taxon Name and Copy Path items | `TaxonomyViewController.swift:1315-1330` |
| The taxon context menu's "BLAST Matching Reads…" item, the per-row route to verification | `TaxonomyViewController.swift:1405-1414` |
| The action bar's "Extract FASTQ" button, a second route to extraction beside the right-click menu | `ClassifierActionBar.swift:49-51` |
| The extraction dialog's Name field and its clipboard read cap, which disables the Copy to Clipboard destination for large selections | `ClassifierExtractionDialog.swift:234-247`, `:213`; `TaxonomyReadExtractionAction.swift:94` |
| `conda classify --recursive`, which pulls eligible FASTQ or FASTA out of subfolders | `cli-help/conda.txt`, `==== conda classify ====` |
| `conda db update` (with `--all` and a required `--yes`) and `conda db install-managed` | `cli-help/conda.txt`, `==== conda db update ====`, `==== conda db install-managed ====` |
| A folder prompt appears when the sidebar selection is a folder holding FASTQ in subfolders | `AppDelegate+ToolsMenu.swift:286-311` |
| The multi-bundle run-mode picker is shown but locked to per-bundle for Kraken2, with an explanatory lock reason | `ClassificationWizardSheet.swift:100-113` |
| The RAM warning banner's exact text names the required and available gigabytes | `ClassificationWizardSheet.swift:250-257` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `kraken2-wizard` (planned) | Yes, with a caption fix | The database picker and the dataset line both exist. The caption should say "the FASTQ/FASTA Operations dialog with Kraken2 selected", since the surface is the shared dialog and not a standalone Classification wizard. |
| `kraken2-plugin-manager` (planned) | Yes | The Plugin Manager and its Databases tab exist (`ClassificationWizardSheet.swift:448-455` opens it directly). |
| `kraken2-taxonomy-viewport` (planned) | Yes, with a caption fix | Sunburst and table both exist. Add the "Filter taxa…" field to the caption so the shot is framed to include it. |
| `kraken2-drilldown-coronaviridae` (planned) | Yes | Double-click re-centring and the breadcrumb bar are both real (`TaxonomySunburstView.swift:564-577`). |
| `kraken2-extract-reads` (planned) | No, as captioned | Its caption says the menu item is "Extract Reads as FASTQ Bundle". The real item is "Extract Reads…" (`TaxonomyViewController.swift:1305`), which opens the dialog where Save as Bundle is one of four destinations. Recaption to "Right-click menu on a taxon row, with Extract Reads… selected". |
| `<!-- planned: kraken2-wizard -->` marker placement | Yes | Sits at the end of step 2, after the settings are described. |
| `<!-- planned: kraken2-extract-reads -->` marker placement | Yes | Sits right after the extraction paragraph. |

Fixture (after Phase 3): sarscov2-srr36291587 with the Viral database
Decision: rewrite. Nine closed collections (no Custom); Bracken column and search field in the browser; build-db indexes a result; settings from classify.kraken2 and classify.install-database.

### 06-classification.md/03-running-esviritu.md

Verdicts: 22 true, 7 false, 3 changed, 5 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "The EsViritu tool itself ships inside the `classification` plugin pack." | "The EsViritu tool itself ships inside the `metagenomics` plugin pack, listed in the Plugin Manager as **Metagenomics** alongside Kraken 2, Bracken, and RiboDetector." |
| 7 | "Find the **EsViritu** row under the Classification group." | "Find the **EsViritu** row under the Metagenomics group." |
| 9 | "Wait until the row's status badge reads **Database ready**." | "Wait until the wizard's Database section shows a green dot and reads `EsViritu <version>` with the installed size beside it, instead of `Database not installed`." |
| 14 | "Open **Tools > FASTQ/FASTA Operations > Classification…** and choose **EsViritu** in the wizard's tool picker." | "Open **Tools > Classification > EsViritu…**, which opens the FASTQ/FASTA Operations dialog with EsViritu already selected." |
| 15 | "Confirm the **Inputs** step lists both paired reads … If only one mate shows, click **Add second mate** and pick the partner file." | "Confirm the Sample section reports **Paired-end reads** when you selected a pair. Pairing comes from the sample grouper, so if it reads Single-end, close the dialog and fix the bundle selection in the sidebar." |
| 16 | "Move to the **Database** step. The picker should read **EsViritu (installed)** with a version string and an install date." | "Check the **Database** section. It should show a green dot and read `EsViritu <version>` with the installed size beside it." |
| 22 | "it defaults to `esviritu-<sample>` beside the input" | "the output directory defaults to the current directory" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "Click **Install Database**." | "Open the Plugin Manager's Databases tab, which the wizard's **Download Database…** button also reaches, and install the EsViritu database from there." |
| 17 | "On the **Options** step … EsViritu exposes two controls here: **Min Read Length** (default 100 nt) … and a quality-filter toggle" | "The **Quality Filtering** section carries the one top-level option, the checkbox **Enable quality filtering (fastp)**, on by default. **Min read length** lives inside Advanced Settings with the Threads stepper and the Extra arguments field." |
| 26 | "with columns for accession, organism, read count, unique read count, RPKMF …, and coverage" | "with columns for Sample, Virus Name, Family, Reads, Unique Reads, RPKMF (reads per kilobase of reference per million reads, a length-normalised abundance measure), Coverage, Identity, and Segment" |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The wizard's sample-name text field for a single-sample run | `EsVirituWizardSheet.swift:361-364` |
| The limited-RAM warning banner shown when the machine is small | `EsVirituWizardSheet.swift:409-411`, `:420-425` |
| The multi-bundle run-mode picker in batch mode | `EsVirituWizardSheet.swift:339-343` |
| `esviritu detect --recursive`, which pulls eligible FASTQ out of subfolders | `cli-help/esviritu.txt`, `==== esviritu detect ====` |
| `lungfish import esviritu <results-dir>`, the route for a run produced outside LGE | `cli-help/import.txt`, `==== import esviritu ====` |
| `lungfish build-db esviritu <result-dir>`, which indexes an EsViritu result for the viewport | `cli-help/build-db.txt`, `==== build-db esviritu ====` |
| The action bar's Extract FASTQ button, a route to extraction beside the row menu | `ClassifierActionBar.swift:49-51` |
| The Identity and Family columns in the detection table | `ViralDetectionTableView.swift:446`, `:491` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `esviritu-wizard-tool-step` (planned) | Yes, with a caption fix | The caption says "the run wizard with EsViritu chosen as the tool". Recaption to "the FASTQ/FASTA Operations dialog opened from Tools > Classification > EsViritu…", since the tool is chosen in the menu, not in the dialog. |
| `esviritu-database-missing` (planned) | Yes, with a caption fix | The state exists but the wording is wrong. Recaption to "the wizard's Database section reading Database not installed, with the Download Database… button beside it" (`EsVirituWizardSheet.swift:398-406`). |
| Its marker placement | No | The marker sits inside step 1 of the install procedure, which tells the reader to open the Plugin Manager. The shot belongs in the wizard walkthrough where the missing-database state is first seen. |
| `esviritu-result-viewport` (planned) | Yes | Coverage sparklines exist in the Coverage column (`ViralDetectionTableView.swift:26`). |
| `esviritu-bam-viewer` (planned) | Yes | The full alignment viewer does appear in the detail pane on row selection (`EsVirituResultViewController.swift:436-437`). |

Fixture (after Phase 3): sarscov2-srr36291587
Decision: rewrite. EsViritu is in the metagenomics pack; no Database ready badge, Install Database button, or Add second mate control; settings from classify.esviritu.

### 06-classification.md/04-running-taxtriage.md

Verdicts: 22 true, 7 false, 3 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 9 | "install the reference database, which is separate from the Kraken2 and EsViritu databases and is not bundled with the application" | "TaxTriage classifies against an installed Kraken2 database, so it needs no database of its own. Install a Kraken2 database as in the Kraken2 chapter and TaxTriage will pick it up." |
| 10 | "The first time you select TaxTriage in the wizard, its Tool step shows a 'Database not installed' warning instead of a database picker." | "When no Kraken2 database is installed, the wizard's **Kraken2 Database** section reads `No Kraken2 databases installed` instead of showing a picker." |
| 11 | "Open the **Plugin Manager** from `Tools > Plugin Manager…` (Cmd-Shift-B), find the TaxTriage entry under Classification, and click **Install**." | "Open the Plugin Manager from `Tools > Plugin Manager…` (Cmd-Shift-B) and install a Kraken2 database from the Databases tab. TaxTriage itself is not a plugin pack, because it runs as a Nextflow pipeline inside a container rather than as a conda tool." |
| 12 | "The default clinical-surveillance database is on the order of tens of gigabytes" | "The size depends on which Kraken2 database you point it at, which ranges from 0.5 GB for Viral to 72 GB for PlusPF." |
| 15 | "select all four FASTQ bundles. Open **Tools > FASTQ/FASTA Operations > Classification…** and choose **TaxTriage** in the wizard's tool picker." | "select all four FASTQ bundles, then open **Tools > Classification > TaxTriage…**, which opens the FASTQ/FASTA Operations dialog with TaxTriage already selected." |
| 25 | "Switch to the **batch overview** tab." | "Set the sample filter back to **All Samples**. With more than one sample loaded, the viewport swaps the per-sample organism table for the batch overview." |
| 31 | "A second tab holds a **cross-sample SNP table**" | Delete the claim. The strain-comparison surface is not reachable in the shipping app. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 16 | "The four samples populate the Inputs step." | "The four samples populate the **Samples** section, one editable row each, and an **Add Sample** button lets you add another." |
| 19 | "the **Skip Krona** toggle controls whether the pipeline renders its own Krona chart" | "Inside Advanced Settings, the **Skip Krona visualization** toggle, off by default, controls whether the pipeline renders its own Krona chart." |
| 29 | "right-click its row on the batch table and choose **Verify with BLAST…**" | "Select the row and click **BLAST Verify** in the action bar." Verify the row context menu in the running app before naming a right-click item. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The per-sample **role** picker on each sample row, with Clinical Sample, Negative Control, Positive Control, Environmental Control, and Extraction Blank | `TaxTriageWizardSheet.swift:394-399`; `FASTQSampleMetadata.swift:26-33` |
| The **Add Sample** and **Remove** buttons, which let you edit the sample list inside the dialog | `TaxTriageWizardSheet.swift:362-366`, `:405-409` |
| The Prerequisites section, which shows a live green or amber dot for Nextflow and for the detected container runtime by name | `TaxTriageWizardSheet.swift:316-347` |
| The **Max CPUs** stepper in Advanced Settings, defaulting to the machine's active processor count | `TaxTriageWizardSheet.swift:104`, `:522-531` |
| The **Extra arguments** field, which forwards raw flags to TaxTriage or Nextflow | `TaxTriageWizardSheet.swift:105`, `:537-542` |
| The batch overview's facet control, which reswitches the cell value between TASS score and other facets such as unique reads | `TaxTriageBatchOverviewView.swift:66-68`, `:166-171` |
| The sample filter segmented control, whose "All Samples" segment is what reveals the batch overview | `TaxTriageResultViewController.swift:1209`, `:1373-1380` |
| `taxtriage run --rank`, `--max-cpus`, `--revision`, `--extra-args`, and `--recursive` | `cli-help/taxtriage.txt`, `==== taxtriage run ====` |
| `lungfish import taxtriage <results-dir>` and `lungfish build-db taxtriage <result-dir>` | `cli-help/import.txt`, `==== import taxtriage ====`; `cli-help/build-db.txt`, `==== build-db taxtriage ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `taxtriage-wizard-tool-step` (planned) | Yes, with a caption fix | The caption says "the run wizard with TaxTriage selected and a multi-sample batch loaded". Recaption to name the FASTQ/FASTA Operations dialog, and frame the shot to include the Prerequisites indicators and the per-sample role pickers, which the chapter must now cover. |
| Its marker placement | Yes | It sits in the step that checks the database and prerequisites, which is where the shot is most useful. |
| `taxtriage-result-table` (planned) | Yes | The TASS Score and Confidence columns both exist (`BatchTaxTriageTableView.swift:253`, `:256`). |
| Its marker placement | No | The marker sits at the end of step 3, which is about the reagent blank column of the batch overview. Move it to step 1, which is where the result table is read. |
| `taxtriage-batch-overview` (planned) | Yes, with a caption fix | The overview exists but is reached by setting the sample filter to All Samples, not by clicking a tab. The caption should not imply a tab. |
| `taxtriage-batch-export` (planned) | Yes | `TaxTriageBatchExporter.swift:44` writes exactly the matrix the caption describes. |

Fixture (after Phase 3): sarscov2-srr36291587
Decision: rewrite. TaxTriage classifies against an installed Kraken 2 database and needs Docker; no SNP table tab; batch overview via the All Samples filter.

### 06-classification.md/05-running-nao-mgs.md

Verdicts: 20 true, 1 false, 2 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "Click **Choose** and select either the pipeline output directory or the `virus_hits_final.tsv(.gz)` file directly." | "Click **Browse…** and select either the pipeline output directory or the `virus_hits_final.tsv(.gz)` file directly." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 9 | "an NAO-MGS result appears in the sidebar under your project's classification results" | "an NAO-MGS result appears in the sidebar under the project's `Analyses` folder, named `naomgs-<sample>`" |
| 16 | "It is not a time series. One import shows one run's taxa; there is no multi-week chart, no series, and no per-week abundance line." | Soften to what the map can prove and verify the chart surface in the running app before restating the negative. The single-import split view is real; the absence of every chart is not established. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The sample-filter button above the taxon table, labelled "All Samples" or "N of M Samples" | `NaoMgsResultViewController.swift:110`, `:669-671` |
| The action bar's Export and Extract FASTQ buttons | `ClassifierActionBar.swift:36-38`, `:49-51`; `NaoMgsResultViewController.swift:310` |
| A "View on NCBI" action on a taxon | `NaoMgsResultViewController.swift:313` (`onViewOnNCBI`) |
| Sample metadata columns loaded through the Inspector's Import Metadata… | `NaoMgsResultViewController.swift:234-241`; `InspectorView.swift:1155-1160` |
| `extract reads --by-db`, which queries the NAO-MGS SQLite database directly by taxid or accession | `cli-help/extract.txt`, `==== extract reads ====`, "By Database (--by-db)" |
| The NAO-MGS result is stored SQLite-backed for random-access queries | `NaoMgsDatabase+Queries.swift`; `features.yaml:711-712` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `nao-mgs-import-card` (planned) | Yes | `ImportCenterViewModel.swift:414-422` defines exactly that card on the Classification Results tab. |
| Its marker placement | Yes | It sits in step 1 beside the Import Center instruction. |
| `nao-mgs-result-viewport` (planned) | Yes, with a caption fix | The split layout is real (`NaoMgsResultViewController.swift:32`). Add the sample-filter button to the caption so the shot is framed to include it. |

Fixture (after Phase 3): a NAO-MGS virus_hits_final.tsv.gz sample (open item; otherwise the chapter shows the import sheet only)
Decision: rewrite, retitle 'Importing NAO-MGS Results'. Import-only; repository securebio/nao-mgs-workflow.

### 06-classification.md/06-blast-verification.md

Verdicts: 19 true, 0 false, 2 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "(A taxon's right-click menu offers the same action, labelled 'BLAST Verify…' or 'BLAST Matching Reads…'.)" | "(A right-click menu offers the same action. In the taxonomy viewport it reads **BLAST Matching Reads…**; in the NVD contig viewport it reads **Verify with BLAST…**.)" |
| 13 | "The columns available are Status, Read ID, Organism, Identity, E-value, Bit score, Accession, Coverage, Align Length, Tax ID, and the per-read Verdict." | "The drawer shows Status, Read ID or Accession, Organism, Identity, E-value, and Bit score. Right-click the column header to add Coverage, Align Length, Tax ID, and Verdict, which stay hidden until you ask for them. Your choice persists between sessions." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The popover's own warning that the reads leave the app for NCBI | `BlastConfigPopoverView.swift:90` |
| When a taxon has fewer reads than the slider minimum, the popover drops the slider and states the fixed count instead | `BlastConfigPopoverView.swift:54`, `:86` |
| A conflicting-organisms warning in the drawer, which counts reads whose hits disagree with each other | `BlastResultsDrawerTab.swift:468` |
| Column visibility choices persist under the UserDefaults key `blastResultsHiddenColumns` | `BlastResultsDrawerTab.swift:228-229`, `:253-257` |
| In the taxonomy viewport the drawer is one of two tabs, shared with Collections | `TaxonomyViewController.swift:1155-1182` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `blast-verify-popover` (planned) | Yes | Both the "Reads to submit" slider and the "Run BLAST" button exist exactly as captioned (`BlastConfigPopoverView.swift:71`, `:98`). |
| `blast-results-drawer` (planned) | Yes, with a caption fix | The verdict, the verification rate, and the per-read rows are all real. The caption should not imply the optional columns are visible by default, since Coverage, Align Length, Tax ID, and Verdict are hidden until enabled. |

Fixture (after Phase 3): sarscov2-srr36291587 Kraken 2 result
Decision: rewrite. Verify button and drawer as they are; settings from classify.blast-verify.

### 06-classification.md/07-running-freyja.md

Verdicts: 12 true, 0 false, 1 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "Freyja stays off the FASTQ/FASTA Operations menu because that menu is reserved for direct data operations." | "Freyja is not a FASTQ/FASTA operation, so it never appears in the Tools category submenus. Those cover operations that read a FASTQ or FASTA directly, and Freyja consumes variant and depth tables instead." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `wastewater-surveillance` pack is flagged experimental, so the Plugin Manager marks it as such | `PluginPack.swift:838` (`isExperimental: true`) |
| The pack ships iVar, Pangolin, Nextclade, and minimap2 alongside Freyja, so installing it brings a whole surveillance toolset | `PluginPack.swift:836` |
| Freyja is one of the few tools whose GUI handler exists but is wired to no menu item, which is why the chapter's CLI-only framing holds | `MainMenu.swift:1172`; `AppDelegate+ToolsMenu.swift:146-148` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers and an empty `planned_shots` list | Correct as it stands | The chapter documents a CLI-only workflow whose only GUI surface is the Plugin Manager, which the Plugin Packs chapter already illustrates. Adding a Plugin Manager shot scoped to the `wastewater-surveillance` pack would help, since the chapter tells the reader to find that pack by name. |

Fixture (after Phase 3): sarscov2-srr36291587 Viral Recon variant and depth tables
Decision: rewrite short. Command-line only, experimental wastewater-surveillance pack (cannot be installed from the CLI while hidden), the Tools item opens the Plugin Manager.

### 06-classification.md/08-importing-cz-id-results.md

Verdicts: 14 true, 0 false, 1 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "It does not turn CZ-ID into a runnable option under `Tools > FASTQ/FASTA Operations > Classification`." | "It does not turn CZ-ID into a runnable option under `Tools > Classification`." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The sheet's **Browse…** button and its Project Destination section | `CzIdImportSheet.swift:176`, `:253` |
| The Import Center card's own file hint, "taxon report TSV, .zip, or extracted folder" | `ImportCenterViewModel.swift:504` |
| Imported CZ-ID results open in a dedicated `CzIdResultViewController`, and the chapter never describes that viewport | `Sources/LungfishApp/Views/Metagenomics/CzIdResultViewController.swift`; `features.yaml:754-757` |
| A CZ-ID provenance view exists for reviewing the recorded pipeline and database versions | `Sources/LungfishApp/Views/Metagenomics/CzIdProvenanceView.swift` |
| `cz-id import` takes no `--sample-name`, so the standalone form derives the sample from the export | `cli-help/cz-id.txt`, `==== cz-id import ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| No `<!-- SHOT -->` markers and an empty `planned_shots` list | Not adequate | The chapter describes a Preview panel with seven named fields and an Import button that stays disabled until the scan succeeds (`CzIdImportSheet.swift:192-243`, `:101-102`). That is the chapter's one visual surface and it should be shot. Add a planned shot of the CZ-ID import sheet with a successful preview, and a second of the imported result in the sidebar under `Classifications`. |

Fixture (after Phase 3): a CZ ID taxon report export (open item)
Decision: rewrite. Import-only, as the chapter mostly already says.

### 06-classification.md/09-novel-virus-detection.md

Verdicts: 23 true, 1 false, 0 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "Click **Choose** and select the NVD results directory." | "Click **Browse…** and select the NVD results directory." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The import sheet's Preview panel, which scans and counts rows before you commit | `NvdImportSheet.swift:213-263` |
| The BLAST results drawer opens at the bottom of the NVD viewport, 220 points tall | `NvdResultViewController.swift:1898-1904` |
| BLAST Verify is disabled unless exactly one identity-backed row is selected, with the reason shown in the tooltip | `NvdResultViewController.swift:2107`, `:2128` |
| Column visibility and sorting in the contig outline, driven by the shared column-filter machinery | `NvdResultViewController.swift:1208-1287`; `LungfishKit/ColumnFilter.swift` |
| `extract reads --by-classifier --tool nvd` reproduces the GUI extraction byte for byte from the command line | `cli-help/extract.txt`, `==== extract reads ====`, "By Classifier Selection (--by-classifier)" |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `nvd-import-card` (planned) | Yes | `ImportCenterViewModel.swift:488-496` defines exactly that card on the Classification Results tab. |
| Its marker placement | Yes | It sits in step 1 beside the Import Center instruction. |
| `nvd-result-viewport` (planned) | Yes, with a caption fix | The expanded contig row, the detail pane, and the full BAM viewer are all real. The caption should also name the By Sample and By Taxon grouping control and the Search contigs… field, since the chapter covers both (`NvdResultViewController.swift:313`, `:1482`). |

Fixture (after Phase 3): nvd-demo
Decision: rewrite. Import-only of an NVD results directory; NVD is a Snakemake pipeline.

### 06-classification.md/10-twelve-s-metabarcoding.md

Verdicts: 28 true, 1 false, 2 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "The workflow merges any remaining paired reads, matches them, resolves cross-species reads, reviews unresolved clusters for chimeras, and writes a result bundle into your project." | "The workflow matches the merged reads, resolves cross-species reads, reviews unresolved clusters for chimeras, and writes a result bundle into your project. It does not merge pairs for you, so merge them first with the read-processing operation." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "Leave the matching mode on the default for Illumina reads, or switch it to the Nanopore mode" | "Leave the **Read Platform** picker on the Illumina setting, or switch it to the Nanopore setting" |
| 10 | "Each row is one species, with its scientific name, common name, taxon group (for example Fish or Mammal), taxid, and the number of reads that matched it exactly." | "Each row is one species, with columns for Sample, Scientific Name, Common Names, Group (for example Fish or Mammal), Tax ID, Exact Reads, % of Sample, Refs (how many reference records it matched), and Alternates (how many other species share its sequence)." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The dialog's **Min Soft Clip** field, which sets how many read bases must flank the matched target | `WorkflowOperationsDialog.swift:332`; `cli-help/fastq.txt`, `==== fastq 12s-match ====`, "--min-soft-clip … (default: 1)" |
| The Advanced Options disclosure's **Max Indels** field, enabled only in the Nanopore mode | `WorkflowOperationsDialog.swift:519-520`; `cli-help/fastq.txt`, "--max-indels … (default: 3)" |
| The Advanced Options disclosure's **Run vsearch chimera review** toggle | `WorkflowOperationsDialog.swift:521` |
| The sample-metadata picker in the dialog, with **Choose Metadata…** and **Replace Metadata…** | `WorkflowOperationsDialog.swift:268-282` |
| A reference-bundle draft builder in the dialog, for turning a FASTA plus MIDORI metadata into a `.lungfish12sref` bundle in place | `WorkflowOperationsDialog.swift:61`, `:140`, `:175-178` |
| `fastq 12s-reference-metadata`, which builds the target metadata TSV from a dedup FASTA plus a MIDORI metadata TSV | `cli-help/fastq.txt`, `==== fastq 12s-reference-metadata ====` |
| `fastq 12s-reference-bundle`, which packages that pair into a reusable `.lungfish12sref` bundle | `cli-help/fastq.txt`, `==== fastq 12s-reference-bundle ====` |
| `12s-match --force`, which replaces an existing output bundle | `cli-help/fastq.txt`, `==== fastq 12s-match ====` |
| The viewport's Provenance popover | `TwelveSAmpliconResultViewController.swift:390-392`, `:1596-1605` |
| 12S Amplicon Matching is a specialized workflow that must be enabled before it appears, and it lives under Genotyping | `WorkflowLibrary.swift:145-147` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `twelve-s-workflow-library` (planned) | Yes, with a caption fix | The caption says "the merged FASTQ and reference FASTA inputs listed". The dialog also carries the Read Platform picker, Min Soft Clip, the metadata picker, and the Advanced Options disclosure, all of which the chapter must now cover. Widen the caption or add a second shot of the dialog's options. |
| Its marker placement | No | The marker sits at the end of the "What it is" section, before the procedure begins. Move it into step 1, where the reader is told to open the workflow. |
| `twelve-s-result-species-table` (planned) | Yes, with a caption fix | The Targets table exists. The caption names only per-species read counts, but the real table also shows Sample, Common Names, Group, Tax ID, % of Sample, Refs, and Alternates (`TwelveSTargetTableView.swift:156-164`). |
| `twelve-s-unresolved-clusters` (planned) | Yes | `TwelveSAmpliconResultViewController.swift:234`, `:243` confirm the Unresolved view and its table. |
| `twelve-s-blast-review` (planned) | Yes | The unresolved BLAST path is real (`TwelveSAmpliconResultViewController.swift:313`, `:856-858`). |
| `twelve-s-export` (planned) | No, as captioned | The caption says the export control writes "CSV, TSV, Excel, or FASTA". The viewport's Export menu offers only CSV, TSV, and Excel (`TwelveSAmpliconResultExportService.swift:8-11`), and the FASTA export of unresolved clusters is command-line only, which the chapter itself says. Recaption to name the three formats the menu offers. |

Fixture (after Phase 3): a public 12S metabarcoding run (open item)
Decision: rewrite. The workflow does not merge pairs; five 12s-* subcommands; viewport controls from classify.twelve-s-match.

### 06-human-germline-variants.md/01-haplotype-caller.md

Verdicts: 33 true, 1 false, 9 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 35 | "A second GUI tool, **GATK + WhatsHap Phased** ... pairs HaplotypeCaller with read-backed phasing." | "A second entry, **GATK + WhatsHap Phased**, appears in the dialog, but running it from the GUI does not work in this release. Selecting it and clicking Run raises a 'Variant Calling Not Ready' alert and nothing is written. Use `lungfish variants phase` from the CLI instead." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | "Run the command below as written and nothing touches your data." | Keep as is. Optionally add that on `--execute` Lungfish creates the output directory before the first GATK command runs. |
| 10 | "The command Lungfish builds calls `HaplotypeCaller`, emits a GVCF by default (`--emit-ref-confidence GVCF`), and sets sample ploidy to `2`." | "The command Lungfish builds calls `HaplotypeCaller`, emits a GVCF by default (the printed command shows GATK's short form `-ERC GVCF`), and sets sample ploidy to `2` with `--sample-ploidy`." |
| 11 | "Reach for `--extra-args` when you need a GATK option Lungfish has not promoted yet. Whatever sits inside the quotes passes to GATK verbatim" | "Reach for `--extra-args` when you need a GATK option Lungfish has not promoted yet. Lungfish splits the quoted string into arguments and appends them to the end of the GATK command unchanged. A string it cannot split is rejected before anything runs." |
| 12 | "The rule in the code is `isDryRun = !execute || dryRun`" | Drop the code quotation and state the behaviour. "You must pass `--execute`, and `--dry-run` wins whenever both are present." |
| 30 | "Open a bundle that carries a BAM track, open the BAM variant-calling dialog, and choose **GATK HaplotypeCaller**" | "Open a bundle that carries an analysis-ready BAM track, choose **Tools > Call Variants…**, and pick **GATK HaplotypeCaller** in the CALL VARIANTS dialog." |
| 39 | "Pass `--emit-ref-confidence NONE` to the CLI to match the GUI" | "Pass `--emit-ref-confidence NONE` to the CLI to get the same kind of output as the GUI. The two commands still differ in the arguments each path leaves at its own defaults, so expect the flags to read differently even when the output type matches." |
| 41 | Frontmatter `entry_points` lists "GUI: BAM variant-calling dialog -> GATK HaplotypeCaller" | "GUI: Tools > Call Variants… > GATK HaplotypeCaller" |
| 42 | Frontmatter `title: HaplotypeCaller` | Change the mkdocs nav label to "HaplotypeCaller" so nav and title agree. |
| 43 | Frontmatter `features_refs: []` | `features_refs: [variants.gatk-germline]`. Note that the features.yaml entry itself is stale, since it lists a nonexistent `lungfish gatk genotype` at line 610 and omits the GUI entry point. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Tools > Call Variants… menu item, the only discoverable route to the dialog | `Sources/LungfishApp/App/MainMenu.swift:719-724` |
| The alignment track must be analysis-ready, and the dialog refuses to open otherwise with "No Analysis-Ready BAM Tracks" | `Sources/LungfishApp/Views/Inspector/InspectorViewController+VariantWorkflow.swift:26-33` |
| The dialog refuses to open while another operation holds the bundle lock, with an "Operation in Progress" alert | `Sources/LungfishApp/Views/Inspector/InspectorViewController+VariantWorkflow.swift:35-42` |
| The dialog's Output Variant Track Name field, prefilled as "<alignment name> • GATK HaplotypeCaller" with a numeric suffix on collision | `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:39`, `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:300-320` |
| The dialog's Advanced Options text field, which is the only way to reach GATK flags from the GUI and is passed as `extraArguments` | `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:138-146`, `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:412` |
| The dialog's Minimum Allele Frequency and Minimum Depth fields are shown for the GATK tools but are silently ignored by them | `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:46-70` renders them unconditionally, `BAMVariantCallingDialogState.swift:392-418` never reads `minimumAlleleFrequency` or `minimumDepth` |
| The dialog's Alignment Track picker | `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:31-37` |
| The readiness line for the GATK tool, "Ready to run GATK HaplotypeCaller on <track>." | `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:168-170` |
| The GATK tool row is disabled with "Requires GATK Core Pack" or "Requires GATK4" until the pack is ready | `Sources/LungfishApp/Views/BAM/BAMVariantCallingCatalog.swift:94-104`, `:132-153` |
| On a failed `--execute` run the executor deletes outputs it created during that run, keeping any that existed beforehand | `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift:758`, `:767`, `:811-831` |
| Provenance also records the VCF sidecar indexes (`.tbi`, `.csi`, `.idx`) when they exist | `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift:873-902` |
| The GUI attaches a SQLite variant database and its own attachment provenance alongside the VCF, and names the track description "GATK HaplotypeCaller variants from <alignment>" | `Sources/LungfishWorkflow/Variants/GATKBundleVariantAttachmentService.swift:124-131`, `:174-178` |
| The GUI run can be cancelled from the Operations Panel | `Sources/LungfishApp/Views/Inspector/InspectorViewController+VariantWorkflow.swift:272-277`, `:296-298` |
| `lungfish variants phase --execute` is the working phasing route, with `--threads` (default 1), `--sample`, `--output-dir`, `--extra-gatk-args`, `--extra-whatshap-args` | `cli-help/variants.txt:70-93`, `Sources/LungfishWorkflow/Variants/PhasedVariantCallingPlan.swift:91-117` |
| The phased plan hard-codes `-ERC NONE` and writes an intermediate `gatk-unphased.vcf.gz` next to the phased output | `Sources/LungfishWorkflow/Variants/PhasedVariantCallingPlan.swift:89-98`, `:124-125` |
| The default `--pair-hmm-threads 4` is always emitted, even in the GUI, where the CLI default and the struct default coincide | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:58`, `:391` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) `shots: []` and `illustrations: []` in the frontmatter, and no `<!-- SHOT -->` markers anywhere in the file | n/a, but a gap | Chapter 01 is the only chapter in this part that documents a GUI procedure, and it has no shot plan at all. The corrected procedure in row 30 needs at least one shot of the CALL VARIANTS dialog with GATK HaplotypeCaller selected, showing the tool list, the Output Variant Track Name field, the Advanced Options field, and the readiness line. A second shot of the Operations Panel row for a finished GATK run would support row 34. Do not plan a shot of the GATK + WhatsHap Phased tool running, because per row 35 it cannot run from the GUI. |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite. Part retitled 'Human Germline Variants (Experimental)'; nav label 'HaplotypeCaller'; the GATK entries are in the Call Variants dialog but their packs need Show Experimental Features; the phased option currently ends in Variant Calling Not Ready (documented as a limitation, with the CLI route).

### 06-human-germline-variants.md/02-joint-genotyping.md

Verdicts: 13 true, 0 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 44 | "By default `lungfish gatk joint-genotype` prints the GATK commands it would run; add `--execute` to run GATK4 and write provenance." | Split into two sentences. "By default `lungfish gatk joint-genotype` prints the GATK commands it would run. Add `--execute` to run GATK4 and write provenance." |
| 45 | "See [HaplotypeCaller](01-haplotype-caller.md) for the full preview-versus-`--execute` model and the `isDryRun = !execute || dryRun` rule." | Drop the code quotation, matching the chapter 01 correction. |
| 53 | "Force `genomicsdb` and you pass a workspace directory path to `--intermediate`; force `combine-gvcfs` and you pass a combined GVCF path." | "Force `genomicsdb` and `--intermediate` is a workspace directory path. Force `combine-gvcfs` and it is a combined GVCF path. Either way `--intermediate` is required." |
| 59 | "When it finishes, the CLI prints the GATK exit code and `Provenance: <path>`." | "When it finishes, the CLI prints the exit code of the last GATK step and `Provenance: <path>`." |
| 60 | "No 'future' provenance step waits in the wings: execution records the cohort VCF's lineage today." | "Execution records the cohort VCF's lineage today. No future provenance step is waiting in the wings." |
| 62 | Frontmatter `features_refs: []` | `features_refs: [variants.gatk-germline]` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `--intervals` is a joint-genotype option and is applied to both steps, not just one | `cli-help/gatk.txt:77`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:592-594`, `:603-605`, `:621-623`, `:632-634`. The chapter uses `--intervals` in an example without ever explaining it. |
| GenotypeGVCFs always receives `-G AS_StandardAnnotation` because `alleleSpecificAnnotations` defaults to true, and the CLI exposes no way to turn it off | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:100`, `:656-658`, no `--allele-specific` option in `cli-help/gatk.txt:67-82` |
| GenotypeGVCFs always receives `--standard-min-confidence-threshold-for-calling 30.0`, and the joint-genotype subcommand exposes no flag to change it even though the configuration struct has the field | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:99`, `:654`, `cli-help/gatk.txt:67-82` lists no `--stand-call-conf` for this subcommand |
| The strategy value is parsed leniently and silently falls back to `auto` on an unrecognised string, so a typo such as `--combine-strategy genomics-db` changes behaviour without an error | `Sources/LungfishCLI/Commands/GATKCommand.swift:282` (`GATKJointGenotypingStrategy(rawValue: combineStrategy) ?? .auto`) |
| Each GATK step runs with its own working directory, derived from that step's output path | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:607-610`, `:636-639` |
| On failure the executor removes outputs it created and writes a failure provenance record before throwing | `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift:766-783` |
| The default runner has a 24 hour timeout | `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift:50` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) `shots: []` and `illustrations: []`, no `<!-- SHOT -->` markers | valid as is | This chapter documents a CLI-only operation with no GUI surface (row 61), so no screenshot is warranted. An illustration of the auto strategy split at 50 samples would help a reader, but a screenshot would not. |

Fixture (after Phase 3): hg002-chr20 (single sample; joint genotyping shown on the CLI plan)
Decision: rewrite. CLI gatk subcommands build plans and run with --execute.

### 06-human-germline-variants.md/03-filtering-selecting-and-metrics.md

Verdicts: 16 true, 0 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 63 | "By default each command below prints the GATK command it would run; add `--execute` to run GATK4 and write provenance." | Split into two sentences. |
| 65 | "The `filter` preset is one of `best-practices-snp`, `best-practices-indel`, or `best-practices-both` (the default)" | "The `filter` preset is one of `best-practices-snp`, `best-practices-indel`, or `best-practices-both`, which is the default. A fourth value, `custom`, is accepted but applies no filter expressions from the CLI, so avoid it." |
| 70 | "`--split-multi-allelics` splits multi-allelic records into one row per allele." | "`--split-multi-allelics` splits multi-allelic records into one row per allele. Lungfish always writes this argument into the GATK command with an explicit `true` or `false`, so you will see it in the preview even when you leave it off." |
| 80 | "Every command in this chapter accepts `--extra-args` for advanced GATK or Picard options, written verbatim." | "Every command in this chapter accepts `--extra-args`. Lungfish splits the quoted string into arguments and appends them to the end of the GATK command unchanged." |
| 83 | Frontmatter `glossary_refs: [VCF]` | Expand `glossary_refs` to cover the terms the chapter actually introduces. |
| 84 | Frontmatter `features_refs: []` | `features_refs: [variants.gatk-germline]` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `lungfish gatk markdup`, a Picard MarkDuplicates wrapper with `--bam` (repeatable), `--output`, `--metrics`, `--create-index` (default true), `--remove-duplicates`, `--validation-stringency` | `cli-help/gatk.txt:170-192`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:509-525`. This is a different tool from `lungfish markdup`, which wraps samtools and is covered in `docs/user-manual/chapters/04-alignments/04-alignment-quality.md`. No chapter in the manual documents the Picard one. |
| `lungfish gatk validate-sam`, a Picard ValidateSamFile wrapper with `--bam`, `--output`, `--reference`, `--mode` (SUMMARY or VERBOSE, default SUMMARY), `--validate-index` (default true), `--ignore-warnings` (default false) | `cli-help/gatk.txt:195-216`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:527-543`. Undocumented anywhere in the manual. |
| `select --intervals`, an option the chapter never mentions even though it documents the other three select options | `cli-help/gatk.txt:115`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:453-455` |
| `leftalign --intervals` | `cli-help/gatk.txt:230`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:557-559` |
| The exact hard-filter expressions each preset applies, six for SNPs (QD2, FS60, MQ40, MQRankSum-12.5, ReadPosRankSum-8, SOR3) and four for indels (QD2, FS200, ReadPosRankSum-20, SOR10) | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:144-158`. The chapter says "GATK's recommended hard-filter expressions" without naming one, so a reader cannot check what was applied. |
| `best-practices-both` concatenates the SNP and indel lists, so `QD2` appears twice in the generated command | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:137-138`, `:145`, `:154` |
| An unrecognised `--preset` value silently falls back to `best-practices-both` rather than failing | `Sources/LungfishCLI/Commands/GATKCommand.swift:366` (`GATKVariantFiltrationPreset(rawValue: preset) ?? .bestPracticesBoth`) |
| `variants-to-table` fields are split on commas and emitted as one `-F` per field | `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:466-468` |
| `collect-metrics --output-prefix` is a prefix path, not a file, and Picard appends its own suffixes | `cli-help/gatk.txt:253-254`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:570` |
| None of these five operations has a GUI surface | `Sources/LungfishApp/Views/BAM/BAMVariantCallingCatalog.swift:9-16` lists no filter, select, table, leftalign, or metrics tool |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) `shots: []` and `illustrations: []`, no `<!-- SHOT -->` markers | valid as is | Every operation in this chapter is CLI-only, so no screenshot applies. A worked example showing the printed preview of a `filter --preset best-practices-both` command would be more useful than any image, and would also close the gap noted in the Missing table about unnamed filter expressions. |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite. Same CLI-plan treatment; settings from variants.gatk-plans.

### 06-human-germline-variants.md/04-reference-packs.md

Verdicts: 10 true, 3 false, 10 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 96 | "Install the `gatk-core` pack before running these commands ... `lungfish conda install --pack gatk-core`" | Remove the CLI install instruction. Install the pack from the app instead. "Install the GATK Core pack from the Plugin Manager. Open Settings, go to Advanced, and turn on Show Experimental Features, then open the Plugin Manager and install GATK Core. The `lungfish conda install --pack` route does not work for this pack, because the CLI installer hides experimental packs." |
| 101 | "`lungfish conda install --pack phasing`" | Remove the CLI install line and point at the Plugin Manager with Show Experimental Features on, as in row 96. |
| 105 | Frontmatter `entry_points` lists "CLI: lungfish conda install --pack gatk-core" and "CLI: lungfish conda install --pack phasing" | Replace both with "GUI: Plugin Manager > GATK Core (needs Show Experimental Features)" and the same for Variant Phasing. Keep "CLI: lungfish gatk bqsr". |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 92 | "base quality score recalibration: GATK's correction of systematic sequencer quality errors using known sites" | Rewrite without the in-sentence colon, for example "base quality score recalibration, which is GATK's correction of systematic sequencer quality errors using known sites". |
| 94 | "`--intervals` restricts recalibration to a region list" | "`--intervals` restricts both the recalibration and the apply step to a region list." |
| 97 | "The pack pins `bioconda::gatk4=4.6.2.0` and verifies it with `gatk --version`." | "The pack pins `bioconda::gatk4=4.6.2.0=py310hdfd78af_1`, which fixes the build as well as the version, and verifies it by running `gatk --version` and checking for the Genome Analysis Toolkit banner." |
| 98 | "The pack is flagged experimental, which keeps it out of validated or clinical use until you have qualified it yourself." | "The pack is flagged experimental. That flag has a concrete effect. The Plugin Manager hides GATK Core unless you turn on Show Experimental Features in Settings > Advanced, and the CLI installer does not list it at all. Treat the pack as unqualified for validated or clinical use until you have tested it yourself." |
| 99 | "the download runs roughly 600 MB, which stings when students pull it over shared lab wifi" | "The Plugin Manager shows the pack as about 600 MB, which stings when students pull it over shared lab wifi." |
| 100 | "The phased GUI tool (**GATK + WhatsHap Phased**, see [HaplotypeCaller](01-haplotype-caller.md)) needs a second pack alongside `gatk-core`." | "The phased entry, **GATK + WhatsHap Phased**, needs a second pack alongside `gatk-core`. That entry does not run from the GUI in this release, so install the pack for the CLI `lungfish variants phase` route." |
| 102 | "The `phasing` pack provides WhatsHap (`bioconda::whatshap=2.3`) and is also flagged experimental." | "The Variant Phasing pack, id `phasing`, provides WhatsHap pinned as `bioconda::whatshap=2.3=py311h1457a19_3`, and it is also flagged experimental." |
| 104 | "Running a workflow is a separate step: a `gatk` command with `--execute`, which runs GATK in this environment and records final-output provenance in the bundle" | "Running a workflow is a separate step. Use a `gatk` command with `--execute`. It runs GATK in this environment and writes provenance beside the output file, or into the bundle when you run the GUI tool instead." |
| 106 | Frontmatter `title: Reference Files for GATK` | Change the mkdocs nav label to "Reference Files for GATK" so nav and title agree. |
| 107 | Frontmatter `features_refs: []` | `features_refs: [variants.gatk-germline]` |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Settings > Advanced > Show Experimental Features toggle, which is the gate on seeing either pack in the Plugin Manager | `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift:16-17`, `Sources/LungfishApp/Views/Settings/SettingsView.swift:52-56` (the tab is labelled "Advanced"), `Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift:490-492` |
| The warning shown next to that toggle, "Experimental features may be incomplete, change without compatibility guarantees, and are not intended for production scientific work." | `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift:19` |
| The pack display names and descriptions a reader will actually see, "GATK Core" with "GATK4 command construction and dry-run support for human germline workflows", and "Variant Phasing" with "Read-backed haplotype phasing with WhatsHap" | `Sources/LungfishWorkflow/Conda/PluginPack.swift:619-620`, `:645-646`. The GATK Core description is itself stale, since it still says "dry-run support" for a pack that now executes. |
| Both packs sit under the "Variant Calling" category in the Plugin Manager | `Sources/LungfishWorkflow/Conda/PluginPack.swift:623`, `:649` |
| The Variant Phasing pack is estimated at 180 MB | `Sources/LungfishWorkflow/Conda/PluginPack.swift:666` |
| The WhatsHap smoke test is `whatshap --version` with a 10 second timeout and no required output substring | `Sources/LungfishWorkflow/Conda/PluginPack.swift:656-663` |
| Environments live under `~/.lungfish/conda/envs/gatk-core` and `~/.lungfish/conda/envs/phasing`, and that path is recorded in provenance as `condaEnvironment` | `Sources/LungfishCLI/Commands/GATKCommand.swift:68-72`, `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:469-473`, `:450-452`, `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift:924-926`, `cli-help/conda.txt` banner "Tools are stored in /Users/dho/.lungfish/conda" |
| `lungfish conda packs`, `lungfish conda envs`, and `lungfish conda list` are how a reader would check what is installed | `cli-help/conda.txt` subcommand list |
| `lungfish gatk bqsr` builds two commands, BaseRecalibrator then ApplyBQSR, and the chapter never says the preview prints two lines | `cli-help/gatk.txt:144`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:503-506` |
| `bqsr --extra-args` is appended to both BQSR commands, unlike joint-genotype where it lands only on the last step | `cli-help/gatk.txt:163-165`, `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift:488`, `:501` |
| Neither pack is installable through the CLI at all, so the offline routes `conda export-pack` and `conda offline-install` are the only scripted paths, and `conda export-pack` does resolve experimental ids because it uses `builtInPack(id:)` rather than the visible list | `Sources/LungfishCLI/Commands/CondaCommand.swift:595` versus `:162` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) `shots: []` and `illustrations: []`, no `<!-- SHOT -->` markers | not adequate for the corrected procedure | Once rows 96 and 101 are fixed, this chapter's only working install route is a GUI one, and it needs shots. Plan two. One of Settings > Advanced showing the Show Experimental Features toggle and its warning text, and one of the Plugin Manager listing GATK Core and Variant Phasing with their size estimates and install buttons. Without those, a reader following the corrected wording has no way to confirm they are looking at the right pane. |

Fixture (after Phase 3): hg002-chr20
Decision: rewrite, retitle 'Reference Files for GATK' (nav label fixed). conda install --pack gatk-core does not work while the pack is hidden; explain the Plugin Manager route.

### 07-assembly.md/01-when-to-assemble.md

Verdicts: 13 true, 5 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` | `entry_points: ["Tools > Assembly > SPAdes…", "Tools > Assembly > MEGAHIT…", "Tools > Assembly > SKESA…", "Tools > Assembly > Flye…", "Tools > Assembly > Hifiasm…"]` |
| 6 | "One menu item opens the wizard, `Tools > FASTQ/FASTA Operations > Assembly…`, and you pick the assembler from a segmented Assembler control inside it." | "Five menu items open the same sheet, one per assembler, under `Tools > Assembly`. Inside the sheet a segmented Assembler control lets you switch between the assemblers that fit your reads." |
| 13 | Table row: "Flye \| … up to ~100 Mb" and "SPAdes \| … up to ~10 Mb" and "MEGAHIT \| … unbounded" | Keep the guidance but mark it as advice, for example "Practical ceiling, not enforced by the app" as the column heading. |
| 22 | "The contigs themselves appear as navigable sequences in the sidebar, and any one can be opened in a sequence viewport" | "The assembly bundle appears in the sidebar as a single item. Opening it shows the contig table. To open one contig in a sequence viewport, select it and derive a reference bundle from it, which chapter [Extracting Contigs](04-extracting-contigs.md) covers." |
| 23 | "used as a mapping target for a fresh `Map Reads` run" | "used as a mapping target for a fresh run of minimap2, BWA-MEM2, Bowtie2, or BBMap under `Tools > Mapping`" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Lungfish runs five assemblers through one wizard" | "Lungfish Genome Explorer ships five assemblers behind one shared configuration sheet. You reach it by picking a tool under `Tools > Assembly`, and the sheet opens with that tool preselected in its Assembler picker." |
| 4 | "packages every result the same way: a `.lungfishref` assembly bundle in the project's `Assemblies/` folder" | "packages every result the same way, as a `.lungfishref` assembly bundle inside a per-run folder in the project's `Analyses/` folder" |
| 5 | "with each contig as a navigable sequence and the assembly statistics (N50, total length, contig count) in the Inspector" | "with each contig listed in a table and the assembly statistics in the viewport's summary strip. The strip shows the assembler, the read type, the contig count, total bp, N50, L50, the longest contig, and the whole-assembly GC percent." |
| 19 | "Every assembler in this list writes a `.lungfishref` assembly bundle into the project's `Assemblies/` folder." | "Every assembler writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses/` folder." |
| 20 | "The bundle's primary FASTA holds the contigs in length-descending order." | "The bundle's primary FASTA holds the contigs in whatever order the assembler emitted them. The contig table in the assembly viewport ranks them by length, so the longest is row 1 regardless." |
| 21 | "The Inspector shows N50, total assembled length, contig count, longest-contig length, and the resolved tool version." | "The viewport's summary strip shows the assembler, read type, contig count, total bp, N50, L50, longest contig, global GC percent, and, when the run recorded them, the tool version and wall time." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Assembly category submenu itself, with one item per assembler | `MainMenu.swift:786-819`, `ToolsMenuModel.swift:71` |
| The managed Genome Assembly conda pack, which must be installed before any assembler runs, and the Readiness panel that reports its state | `PluginPack.swift:669-716`, `AssemblyWizardSheet.swift:646-695` |
| Pinned tool versions: SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, hifiasm 0.25.0 | `third-party-tools-lock.json:42-46` |
| The Read Type picker, which appears and becomes editable when header detection is inconclusive, and is a locked label when detection succeeds | `AssemblyWizardSheet.swift:507-524` |
| The blocking message for a mixed selection, "Hybrid assembly is not supported in v1. Select one read class per run." | `AssemblyCompatibility.swift:10-11` |
| The second blocking message for a selection mixing detected and unclassified inputs | `AssemblyWizardSheet.swift:56-57` |
| The multi-bundle run mode picker for SPAdes, MEGAHIT, and SKESA when more than one bundle is selected, currently locked to per-bundle | `AssemblyWizardSheet.swift:167-187, 402-409` |
| Long-read tools reject a multi-file selection outright | `AssemblyWizardSheet.swift:261-270` |
| MEGAHIT threads are capped at 2 on Apple Silicon because 1.2.9 arm64 crashes above that, and `--no-hw-accel` is added | `AssemblyRunRequest.swift:99-104`, `ManagedAssemblyPipeline.swift:233-236` |
| Sidebar context menu "Reassemble…" on a bundle that carries assembly provenance | `SidebarViewController+MenuDelegate.swift:207-209` |
| The `completedWithNoContigs` outcome, reached when an assembler exits cleanly but produces nothing | `AssemblyOutputNormalizer.swift:56-70` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-assembler-picker`, captioned "The Assembly wizard's segmented Assembler picker (SPAdes, MEGAHIT, SKESA, Flye, Hifiasm) above the separate Read Type control." | Retake with a new caption | The picker and its position above Read Type are real (`AssemblyWizardSheet.swift:496-524`), but it never shows all five at once for a bundle whose read class was detected. The caption must say the picker lists the assemblers compatible with the detected read class. |
| `assembly-bundle-in-sidebar`, captioned "An assembly bundle in the Assemblies/ folder, with contigs listed in the Inspector." | Retake with a new caption | Wrong folder and wrong pane. The bundle lives under `Analyses/`, and contigs are listed in the assembly viewport's table, not the Inspector. |
| `<!-- planned: assembly-bundle-in-sidebar -->` marker in "Where the result lands" | Keep the marker, fix the shot | The section itself is the right home for a shot of where output lands. |
| Illustration `assembly-vs-mapping` | Valid | Conceptual schematic with no app claim in it. |

Fixture (after Phase 3): human-mito
Decision: rewrite. Genome-size ceilings are author guidance, say so; five assemblers with read-type gating; no Assemblies/ folder, output is Analyses/<tool>-<timestamp>/.

### 07-assembly.md/02-running-spades.md

Verdicts: 27 true, 6 false, 8 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "the assembly result viewport ranks the contig list by length, with per-contig length, coverage, and GC content" | "the assembly result viewport ranks the contig list by length and shows each contig's length, GC percent, and share of the assembly, with a sequence preview" |
| 9 | Procedure step 2: "Your selection pre-fills the input FASTQ bundle; confirm it, or swap it with the input picker." | "The Inputs section at the top shows the dataset you selected, its read layout, and the detected read class. These are read-only. To assemble a different bundle, close the sheet, select that bundle in the sidebar, and open the menu item again." |
| 11 | Procedure step 3: "The `Min Contig` stepper there sets a length below which Lungfish drops contigs after SPAdes finishes. It is a Lungfish post-filter, not a SPAdes flag." | "The `Min Contig` stepper sits in Primary Settings, below the Threads and Memory Limit sliders. It takes effect for MEGAHIT and SKESA, which receive it as `--min-contig-len` and `--min_contig`. With SPAdes selected the stepper is shown but the value is not applied to the run, so leave it at 0." Flag this to engineering as a defect rather than a documentation gap. |
| 13 | Procedure step 4: "The output lands in the project's `Assemblies/` folder." | "The output lands in the project's `Analyses/` folder. The Output Folder row below the name shows the exact path." |
| 23 | "Click the row. The Inspector shows length, coverage (parsed from the SPAdes contig header, for example the `cov_412.7` field in `NODE_1_length_29812_cov_412.7`), and GC content." | "Click the row. The detail pane beside the table shows the contig header, its length, its GC percent, its rank in the assembly, its share of the total assembly length, and a scrollable view of its sequence. SPAdes encodes its own coverage estimate in the contig name, for example `NODE_1_length_29812_cov_412.7`, so you can read the depth off the header text even though it is not a separate column." |
| 24 | "Double-click the contig. It opens in a sequence viewport" | "Select the contig and use `Create Bundle` in the action bar to derive a reference bundle from it, which you can then open in a sequence viewport." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` and `"CLI: lungfish assemble"` | `entry_points: ["Tools > Assembly > SPAdes…", "Tools > Assembly > MEGAHIT…", "Tools > Assembly > SKESA…", "CLI: lungfish assemble"]` |
| 4 | "Lungfish writes a `.lungfishref` assembly bundle into the project's `Assemblies/` folder." | "Lungfish Genome Explorer writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses/` folder." |
| 8 | Procedure step 2: "Choose `Tools > FASTQ/FASTA Operations > Assembly…`. The Assembly wizard opens. Set the Assembler picker at the top to `SPAdes`." | "Choose `Tools > Assembly > SPAdes…`. The assembly sheet opens with SPAdes already chosen in the Assembler picker at the top of Primary Settings." |
| 10 | Procedure step 3: "For SPAdes' slower, more accurate run, expand Advanced Settings and turn on `Careful mode`." | "expand the Curated extra arguments disclosure under Advanced Settings and turn on `Careful mode`" |
| 16 | Procedure step 5: "When the run completes, the new assembly bundle appears in `Assemblies/` and opens in the assembly result viewport." | "the new assembly bundle appears under `Analyses/` and opens in the assembly result viewport" |
| 20 | "The wizard shows it only for the assemblers that accept a memory budget, SPAdes, MEGAHIT, and SKESA, and passes the value as `--memory`. It is hidden for Flye and hifiasm" | Add one sentence: "MEGAHIT takes the same budget in bytes, so Lungfish Genome Explorer converts your gigabyte figure before passing it." |
| 25 | "The headline assembly metrics live in the bundle's Inspector, and N50 is the one you will meet most." | "The headline assembly metrics live in the summary strip along the top of the assembly viewport, and N50 is the one you will meet most." |
| 39 | CLI flag table: "`--min-contig-length <bp>` \| Minimum contig length post-filter" | "Minimum contig length, passed to MEGAHIT and SKESA. Ignored by SPAdes, Flye, and hifiasm." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Readiness panel, which reports the managed tool status and blocks Run until the assembly pack is installed and smoke-tested | `AssemblyWizardSheet.swift:646-695`, `:218-224` |
| The validation message strip in the footer, which names exactly why Run is disabled | `AssemblyWizardSheet.swift:29-52, 447-455` |
| The Inputs section rows Dataset, Read Layout, and Detected | `AssemblyWizardSheet.swift:474-490, 731-754` |
| The Read Type picker and the "Locked from FASTQ header detection." caption | `AssemblyWizardSheet.swift:507-524` |
| The Extra arguments free-text field and its parse error, which also disables Run | `AssemblyWizardSheet.swift:609-618, 801-808` |
| The Output Folder read-only row | `AssemblyWizardSheet.swift:635-641` |
| The multi-bundle run mode picker for the three short-read tools, locked to per-bundle with the reason string | `AssemblyWizardSheet.swift:167-187, 402-409` |
| MEGAHIT threads capped at 2 and `--no-hw-accel` added on Apple Silicon | `AssemblyRunRequest.swift:99-104`, `ManagedAssemblyPipeline.swift:233-236` |
| The advanced option descriptions the wizard prints per tool, four for SPAdes, three for MEGAHIT, three for SKESA | `AssemblyOptionCatalog.swift:168-244`, rendered at `AssemblyWizardSheet.swift:599-607` |
| The action-bar buttons `BLAST Contigs`, `Copy FASTA`, `Export FASTA`, `Create Bundle`, all disabled until a contig is selected | `AssemblyActionBar.swift:10-13, 59-68` |
| The contig-table context menu, which adds `Extract Sequence…`, `Align with MAFFT…`, and `Run Operation…` | `FASTASequenceActionMenuBuilder.swift:70-127`, wired at `AssemblyResultViewController.swift:295-309` |
| The three assembly panel layouts, detail-leading (default), list-leading, and stacked | `AssemblyLayoutPreference.swift:9-22` |
| The `Share of Assembly (%)` and `Sequence Preview` columns | `AssemblyContigTableView.swift:32-45` |
| L50 and Global GC in the summary strip | `AssemblySummaryStrip.swift:328, 330` |
| Pinned tool versions SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1 | `third-party-tools-lock.json:42-44` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-spades`, captioned "The Assembly wizard with SPAdes selected and the Isolate profile chosen." | Valid, retake for the current sheet | Both controls exist (`AssemblyWizardSheet.swift:496-540`). The shot should be reached through `Tools > Assembly > SPAdes…` and should include the Inputs rows and the Readiness panel so the caption can name them. |
| `<!-- planned: assembly-wizard-spades -->` marker in procedure step 2 | Keep | Right place in the corrected procedure. |
| `assembly-viewport`, captioned "The assembly result viewport showing contigs ranked by length with N50 in the summary strip." | Valid | Both true (`AssemblyContigTableView.swift:20-45`, `AssemblySummaryStrip.swift:327`). |
| `<!-- planned: assembly-viewport -->` marker in procedure step 5 | Keep | Right place. |
| `contig-inspector`, captioned "Inspector pane for the longest contig showing length, coverage, and GC content." | Invalid, respecify | Wrong pane and a control that does not exist. Respecify as `contig-detail-pane`, captioned "The detail pane for the longest contig, showing its header, length, GC percent, rank, share of the assembly, and sequence." |
| `<!-- planned: contig-inspector -->` marker after the double-click paragraph | Move | The paragraph it follows is being rewritten. Place the marker after the corrected "Click the row" paragraph instead. |

Fixture (after Phase 3): human-mito (SPAdes, expected/spades)
Decision: rewrite. Tools > Assembly > SPAdes...; wizard Inputs are read-only rows; Minimum Contig Length is ignored by SPAdes (app defect, documented as a limitation); contig table columns are #, Contig, Length (bp), GC %, Share of Assembly (%), Sequence Preview; no Nx plot, no coverage.

### 07-assembly.md/03-running-flye-or-hifiasm.md

Verdicts: 14 true, 1 false, 9 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | Frontmatter `entry_points: "Tools > FASTQ/FASTA Operations > Assembly…"` | `entry_points: ["Tools > Assembly > Flye…", "Tools > Assembly > Hifiasm…", "CLI: lungfish assemble"]` |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "both produce the same kind of output: an assembly bundle under `Assemblies/` in your project folder, holding a contigs FASTA and per-contig metadata" | "both produce an assembly bundle in a per-run folder under `Analyses/` in your project, holding a contigs FASTA and its index" |
| 5 | Comparison table: "Output style \| Flye: Single primary assembly \| Hifiasm: Primary plus haplotype-resolved contigs" | "Hifiasm produces primary and haplotype-resolved contigs. Lungfish Genome Explorer loads the primary contig set into the viewport, so the alternate haplotigs remain in the run folder and are not listed." |
| 7 | "In this version Flye accepts ONT reads only. PacBio CLR is not an accepted Flye input, and the wizard will not offer Flye for a CLR bundle." | "In this version Flye accepts ONT reads only. PacBio CLR has no read class of its own, so a CLR bundle is detected as no single read class, the Read Type picker unlocks, and you must choose a class before Run enables." |
| 8 | Flye step 2: "Choose **Tools > FASTQ/FASTA Operations > Assembly…**. The Assembly wizard opens. Set the Assembler picker to **Flye** and confirm the input FASTQ is your ONT bundle." | "Choose **Tools > Assembly > Flye…**. The sheet opens with Flye already chosen. Confirm the Inputs section names your ONT bundle and reports ONT reads under Detected." |
| 10 | Flye step 4: "Leave the **Metagenome mode** toggle (under Advanced Settings) off unless your sample is a mixed community." | "Leave the **Metagenome mode** toggle, inside the Curated extra arguments disclosure under Advanced Settings, off unless your sample is a mixed community." |
| 15 | Hifiasm step 4: "For just the primary assembly, without the alternate haplotigs, turn on **Primary contigs only** under Advanced Settings." | "Turn on **Primary contigs only**, inside the Curated extra arguments disclosure, to have hifiasm emit only the primary assembly. The viewport lists the primary contigs either way, so this mostly saves disk and time." |
| 17 | The Haploid/Viral profile is described only as "Single-haplotype assembly for haploid or viral genomes" with no mention of what it adds | Add to the Hifiasm step 3 text: "Haploid/Viral also tells hifiasm to expect one haplotype and to skip purging and the bloom filter, which is what makes it fast on a small genome." |
| 20 | "The Operations Panel logs each Flye stage: read overlap, graph construction, contig extraction, and polishing." | "The Operations Panel streams Flye's own output as it works through overlap, graph construction, contig extraction, and polishing, and the full text is saved as `assembly.log` in the run folder." |
| 21 | "The new bundle in `Assemblies/` holds a single contig of about 29.8 kb." | "The new bundle under `Analyses/` holds a single contig of about 29.8 kb." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Flye and hifiasm each accept exactly one input file, and a multi-file selection is refused before Run with a per-tool message | `AssemblyWizardSheet.swift:261-270`, `ManagedAssemblyPipeline.swift:278-282, 300-304` |
| The Memory Limit slider is hidden for both long-read tools | `AssemblyOptionCatalog.swift:116-120`, `AssemblyWizardSheet.swift:226-230, 551` |
| The Min Contig stepper is also hidden for both, since neither is in the minimum-contig-length mapping | `AssemblyOptionCatalog.swift:126-131`, `AssemblyWizardSheet.swift:232-236, 564` |
| The Haploid/Viral profile silently adds `--n-hap 1`, `-l0`, and `-f0` unless you already passed them | `ManagedAssemblyPipeline.swift:400-414` |
| Hifiasm output is a GFA that Lungfish Genome Explorer converts to `contigs.fasta` before the viewport can show it | `AssemblyOutputNormalizer.swift:44-52`, `GFASegmentFASTAWriter.swift` |
| Flye's assembly graph is kept as `assembly_graph.gfa` in the run folder | `AssemblyOutputNormalizer.swift:38-41` |
| Hifiasm writes its output under a prefix built from the Project Name, so renaming the run renames the files | `ManagedAssemblyPipeline.swift:311` |
| Pinned versions Flye 2.9.6 and hifiasm 0.25.0 | `third-party-tools-lock.json:45-46` |
| Four Flye and four hifiasm advanced option descriptions printed in the sheet without controls | `AssemblyOptionCatalog.swift:245-304` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `assembly-wizard-flye`, captioned "Assembly wizard with Flye selected, an ONT FASTQ chosen as input, and the Nano HQ profile in the Profile picker." | Valid, retake for the current sheet | All three elements exist (`AssemblyWizardSheet.swift:496-540`, `:892-897`). Reach it through `Tools > Assembly > Flye…`. The caption should say the input was selected in the sidebar before the sheet opened, since the sheet has no input picker. |
| `<!-- planned: assembly-wizard-flye -->` marker after Flye step 5 | Keep | Right place. |
| `assembly-wizard-hifiasm`, captioned "Assembly wizard with Hifiasm selected and a PacBio HiFi FASTQ chosen as input." | Valid, retake | Same as above. With a HiFi bundle selected the Assembler picker will show Hifiasm alone, since it is the only tool compatible with `pacBioHiFi` (`AssemblyCompatibility.swift:21-22`). The caption should say so, because a reader will otherwise think the picker is broken. |
| `<!-- planned: assembly-wizard-hifiasm -->` marker after Hifiasm step 5 | Keep | Right place. |
| `flye-single-contig-result`, captioned "Project sidebar showing a Flye assembly bundle that contains a single full-length contig." | Retake with a new caption | The sidebar shows the bundle, not its contigs. Either recaption as "the Flye assembly bundle in the sidebar under Analyses" or reshoot as the assembly viewport with its one-row contig table, which is what the surrounding prose actually describes. |
| `<!-- planned: flye-single-contig-result -->` marker in the worked example | Keep | Right place for whichever of the two shots is chosen. |

Fixture (after Phase 3): hg002-long-reads (ONT chrM for Flye, HiFi chrM for hifiasm)
Decision: rewrite. Read-type gating; hifiasm Diploid default with Haploid/Viral alternative.

### 07-assembly.md/04-extracting-contigs.md

Verdicts: 18 true, 7 false, 8 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "From the assembly viewport the work runs as a short background task (the GUI calls the same `extract contigs` CLI command under the hood), so it returns quickly without a progress bar but is not strictly instantaneous." | "Create Bundle starts a real operation named `Create Reference Bundle`, which appears in the Operations Panel with its own row and can be cancelled. It is quick, because the only work is subsetting and indexing the contigs you chose." |
| 6 | "The assembly viewport is designed for this and shows per-contig length, coverage, and GC content." | "The assembly viewport is designed for this and shows each contig's length, GC percent, and share of the assembly." |
| 7 | Procedure step 1: "Open the assembly bundle (from `Assemblies/` in the sidebar)" | "Open the assembly bundle from `Analyses/` in the sidebar" |
| 8 | Procedure step 1: "The contig table lists every contig with its length, coverage, and GC content." | "The contig table lists every contig with its rank, name, length, GC percent, share of the assembly, and a sequence preview." |
| 13 | Procedure step 4: "The work runs as a short background task, so there is no progress bar" | "The work runs as a `Create Reference Bundle` operation, so you can watch it and cancel it from the Operations Panel." |
| 30 | Worked example step 4: "Open the mapping wizard from `Tools > FASTQ/FASTA Operations > Mapping…`." | "Open a mapper from `Tools > Mapping`, for example `minimap2…` for long reads or `BWA-MEM2…` for Illumina short reads." |
| 31 | Interpretation: "the operation logs a single line in the Operations Panel showing the source assembly, the selected contig identifiers, and the new bundle UUID" | "the Operations Panel row reads `Create Reference Bundle` while it runs, naming how many sequences were selected, and then reports the name of the bundle it created" |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Lungfish writes the selected contigs to a new FASTA, bgzip-compresses it, builds a FASTA index, assembles a `.lungfishref` bundle around it, and writes a provenance record pointing at the source assembly." | "Lungfish Genome Explorer writes the selected contigs to a new FASTA, builds a FASTA index for it, assembles a `.lungfishref` bundle around it, and writes a provenance record pointing at the source assembly." |
| 5 | "most reference-driven operations downstream (mapping, variant calling, primer-scheme alignment, coverage analysis) want a reference bundle, not an assembly bundle" | "An assembly bundle is already a `.lungfishref`, so a reference picker will accept it whole. Extracting is how you narrow it to the contigs you actually want as the mapping or variant-calling target, instead of every fragment the assembler emitted." |
| 11 | Procedure step 3: "The same action bar also offers **BLAST Contigs**, **Copy FASTA**, and **Export FASTA** on the current selection." | "The same action bar also offers **BLAST Contigs**, **Copy FASTA**, and **Export FASTA** on the current selection. With a single contig selected the first button reads **BLAST Contig**." |
| 14 | "The Create Bundle button runs the `extract contigs` CLI command for you, so the bundle it produces is identical to what you would get from the command line." | "Create Bundle and `lungfish extract contigs --bundle` both produce a `.lungfishref` bundle of the selected contigs in `Reference Sequences/`, so you can script the same result you get from the button." |
| 15 | "The CLI form is `lungfish extract contigs --assembly <bundle> --contig <id> [--contig <id> ...] --output <path>`" | "The CLI form is `lungfish extract contigs --assembly <run folder> --contig <id> [--contig <id> ...] --bundle --bundle-name <name> --project-root <project>`. Pass the run folder under `Analyses/` that holds `assembly-result.json`, not the `.lungfishref` bundle inside it. Swap `--bundle` for `--output <path>` to write a plain FASTA instead." |
| 23 | "From the Create Bundle button, the suggested name comes from your selection: a single selected contig suggests the contig identifier itself (for example `NODE_1_length_29812`), and a multi-contig selection suggests `<assembly>-selected-contigs`." | "a single selected contig suggests that contig's full identifier, for example `NODE_1_length_29812_cov_412.7`, and a multi-contig selection suggests `<run folder name>-selected-contigs`" |
| 26 | "Renaming the bundle later in the sidebar does not break provenance, because the provenance record holds bundle UUIDs, not display names." | "The derived bundle records where it came from in its own source information, including the source assembly's path and name. Renaming the derived bundle in the sidebar is safe. Moving or renaming the source assembly afterwards is what makes that record harder to follow." |
| 28 | Worked example step 1: "The result is an assembly bundle named something like `SRR36291587-spades`" | "The result is an assembly bundle named from the Project Name you set, `SRR36291587_assembly` by default, inside a timestamped `spades-` folder under `Analyses/`." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The contig-table context menu, which offers `Extract Sequence…`, `BLAST`, `Copy FASTA`, `Export FASTA`, `Create Bundle`, `Align with MAFFT…`, and `Run Operation…` | `FASTASequenceActionMenuBuilder.swift:70-127`, wired at `AssemblyResultViewController.swift:295-309` |
| BLAST is capped at 50 selected sequences, with a tooltip explaining why the item is disabled | `FASTASequenceActionMenuBuilder.swift:83-90` |
| `Align with MAFFT…` needs at least two selected contigs | `FASTASequenceActionMenuBuilder.swift:113-118` |
| The Export FASTA save panel pre-fills a `.fa` filename derived from the same suggested name | `AssemblyResultViewController.swift:387, 397-400` |
| Copy FASTA writes the selection to the clipboard through the same `extract contigs` call | `AssemblyContigMaterializationAction.swift:39-42` |
| The derived bundle's metadata carries the assembler, the source assembly name, the selected contig list, and a selection summary | `ExtractContigsCommand.swift:315-321`, `AssemblySubsetBundleMetadata.swift` |
| A `Create Bundle` run can fail with "Could not resolve the enclosing Lungfish project root", which happens when the assembly sits outside a project | `AssemblyContigMaterializationAction.swift:19-21` |
| The failure alert "Reference Bundle Creation Failed" | `ViewerViewController.swift:2438-2450` |
| The three assembly panel layouts, which change where the detail pane sits relative to the table | `AssemblyLayoutPreference.swift:9-22` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `create-bundle-action-bar`, captioned "The assembly result action bar with three contigs selected in the table and the Create Bundle button enabled." | Valid | Both true (`AssemblyActionBar.swift:13, 59-64`). With three selected, the first button reads "BLAST Contigs", which the caption may note. |
| `<!-- planned: create-bundle-action-bar -->` marker after procedure step 4 | Keep | Right place in the corrected procedure. |
| `derived-bundle-in-sidebar`, captioned "The derived reference bundle in the project sidebar under Reference Sequences/, named with the -subset default." | Retake with a new caption | The folder is right (`ExtractContigsCommand.swift:305`), but `-subset` is the CLI default only. A bundle made with the button carries the contig identifier or `<run folder>-selected-contigs`. Recaption to match whichever path the shot actually uses, and prefer the button path since that is what the chapter's worked example does. |
| `<!-- planned: derived-bundle-in-sidebar -->` marker in the worked example | Keep | Right place. |

Fixture (after Phase 3): human-mito expected/spades
Decision: rewrite. Selection-based extraction only; Create Reference Bundle is a visible operation; FASTA is not bgzip-compressed; extract contigs has no length or coverage flags.

### 08-workflows.md/01-the-workflow-builder.md

Verdicts: 57 true, 18 false, 22 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | (implied throughout, never stated) the Builder appears unconditionally | Add to the Procedure: the item appears only after you turn on Show Experimental Features in Settings > Advanced. Without that setting the Tools menu has no Workflow Builder entry. |
| 9 | "The palette groups operations into seven categories: **Input**, **Preprocessing**, **Trimming & Filtering**, **Decontamination**, **Read Processing**, **Analysis**, and **Output**." | "The palette shows four category headers: **Input**, **Trimming & Filtering**, **Decontamination**, and **Read Processing**. The node type model defines three more categories (Preprocessing, Analysis, Output), but no node in those categories is offered in the palette." |
| 11 | "Hovering a node shows a one-line description." | "Hovering a node shows its name and the data type of each input and output port." |
| 12 | "The five runnable FASTQ operations live in Trimming & Filtering, Decontamination, and Read Processing; the Analysis category holds the export-only nodes." | "The five runnable FASTQ operations live in Trimming & Filtering, Decontamination, and Read Processing. Nothing else is offered." |
| 13 | (undocumented palette control) the palette has no search field | Add to the Procedure: a **Filter nodes** search field sits above the palette and narrows the list by node name as you type. |
| 26 | (undocumented) duplicate edges are rejected | Add one sentence: drawing the same edge twice is rejected the same way an incompatible edge is. |
| 32 | (missing from that row) Cut mode's allowed values and the numeric bounds | Add the allowed values and ranges to the Settings entries, since the campaign template requires a Settings entry per setting. |
| 40 | "The table below lists the node types that exist in the palette" | "The table below lists the six node types the palette offers. A saved graph can also hold node types that came from an earlier version or from the CLI, listed after them." |
| 45 | Node table row "Sample Sheet \| Input \| CSV/TSV \| per-row metadata \| input" | If retained at all, describe the output as a FASTQ Bundle port and mark the node as not offered in the palette. |
| 52 | (missing from the node table) the `Export` node type | Either list it with the other not-offered types or say the table is limited to the palette. |
| 54 | "Choose **File > Save Workflow** or press `Cmd-S`." | "Use the workflow library in the left sidebar to create, rename, duplicate, or delete a workflow in the active project. Clicking **Run** saves the current graph into the project library before it starts, so a workflow you run is always a saved workflow." |
| 65 | (missing) `--format tsv` on `workflow diff` | Mention tsv alongside json, or say the format flag takes text, json, or tsv. |
| 72 | "Per-node status is one of running, succeeded, failed, or skipped" | "Per-node status is one of pending, running, succeeded, failed, or skipped." |
| 74 | "The Operations Panel receives a parent workflow row and one child row per node, all carrying the same durable run id" | "The Operations Panel receives a parent row named after the workflow and one row for the runner itself, both carrying the same run id, so you can watch progress while working elsewhere in the app." |
| 78 | (missing) the `--threads` default | State the default of 4 threads. |
| 90 | "A successful workflow run leaves three things in your project: the output artefact …, one Operations Panel row per node with its full provenance, and a `runs/` folder …" | "A successful run leaves the derived `.lungfishfastq` bundle, a parent and a runner row in the Operations Panel, and a `runs/<run-id>/` folder inside the workflow bundle." |
| 94 | "the Operations Panel marks that row's status `failed` and leaves the downstream nodes `skipped`" | "Lungfish marks the run failed in the Operations Panel and records the skipped nodes in `run.json`." |
| 96 | "The builder refuses to save a **FASTQ Bundle Input** node whose path points outside the project root, with an error that names the offending value." | "Lungfish refuses to run a workflow whose FASTQ Bundle Input node points outside the project root, with an error that names the offending path. Saving does not check." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "A new window opens showing three panes: an operation palette on the left, a canvas in the middle, and an inspector on the right." | "A new window opens showing three panes. The left sidebar holds the project workflow library above the node palette, the canvas is in the middle, and the node inspector is on the right." |
| 15 | "You can move a placed node at any time by dragging its header." | "You can move a placed node at any time by dragging it. The two pinned anchors cannot be moved." |
| 16 | "To delete a node, select it and press `Delete` or `Backspace`." | "To delete a node, select it and press `Delete` or forward delete. The two pinned anchors cannot be deleted." |
| 22 | "The generic Alignment node, for example, shows a reads port and a reference port side by side, and the generic Variant Calling node shows an alignments port and a reference port." | Remove the example, or move it to a note that these node types exist in saved graphs and in the exporter model but are not offered in the palette. |
| 36 | "The generic Analysis export nodes (Alignment, Variant Calling, Quantification, Assembly) do not expose scientific parameters … They carry only two hidden metadata fields" | Keep the fact and re-frame it as a note about saved graphs rather than about something the reader can select in the palette. |
| 39 | "The builder rejects bundle paths that point outside the project root" | "Lungfish rejects a bundle path that points outside the project root when you run the workflow. Saving does not check the path." |
| 42 | Node table row "FASTQ Input \| Input \| FASTQ file \| FASTQ reads \| input" | Move to a separate table of node types not offered in the palette. |
| 43 | Node table row "FASTA Input \| Input \| FASTA file \| reference bundle \| input" | Same as row 42. |
| 44 | Node table row "BAM Input \| Input \| BAM/CRAM file \| alignments \| input" | Same as row 42. |
| 48 | Node table row "Merge overlapping pairs \| Read Processing \| paired FASTQ reads \| merged FASTQ reads \| yes" | Describe both ports as FASTQ Bundle and say separately that the underlying fastp merge step needs paired input. |
| 49 | Node table rows "Quality Control" and "Trimming" as Preprocessing, export-only | Move to the not-offered table. Note that `Trimming` does carry two real parameters, minimum length default 20 and qualified quality default 15 (`WorkflowNode.swift:278-298`), which contradicts the chapter's blanket claim that export nodes carry only hidden metadata. |
| 50 | Node table rows "Alignment", "Variant Calling", "Quantification", "Assembly" as Analysis, export-only | Move to the not-offered table. |
| 51 | Node table row "Report \| Output \| report inputs \| report file \| export-only" | Move to the not-offered table. |
| 55 | "The first save prompts for a name and writes the workflow to the active project at `Workflows/<name>.lungfishflow`." | "New workflows are created from the sidebar and land in the project at `Workflows/<name>.lungfishflow`." |
| 56 | "The saved bundle includes the node graph, every parameter value, the tool versions in use at save time, and a provenance entry recording who saved the workflow and when." | "The saved bundle holds the node graph with every parameter value, a version-history entry, and a provenance record naming the Lungfish version, the save time, and the checksum of each written file." |
| 60 | "and is shown in the Workflow Builder window subtitle after a graph load or a version change" | "The window subtitle shows the workflow name, and after the first load or save it shows the version alongside it." |
| 73 | "written as text in the record (the Operations Panel shows the same words, not a colour cue alone)" | Drop the Operations Panel half of the sentence. |
| 75 | "The first failing node marks the run failed and leaves every downstream node in the `skipped` state for inspection." | "A failure marks the run failed, records the failing node when it can be identified, and leaves every unfinished node in the `skipped` state." |
| 79 | "command lines recorded inside a provenance file (for example, argv beginning `workflow builder-run --graph-id …` or `workflow builder-step run …`) are audit records, not user-invocable commands" | Replace the invented argv examples with the real ones, for example an argv beginning `Lungfish "Tools > Workflow Builder (Experimental)" run`. |
| 85 | "Lungfish ships a built-in VSP2 template that generates the same chain programmatically … so two people who start from the template get byte-for-byte the same graph." | "A built-in VSP2 template exists in the code and produces this chain with stable node identifiers, but no menu item or command exposes it yet. Build the chain by hand." |
| 86 | "Save the workflow as `vsp2-fastq` and click **Run**." | "Name the workflow `vsp2-fastq` in the library sidebar and click **Run**." |
| 91 | "If you ran the workflow three times against three bundles, you have three entries under `runs/` and three output bundles; the workflow file itself is unchanged." | "Each run adds an entry under `runs/` and an output bundle. Running also re-saves the graph, so `versions/history.json` gains one line per run." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Show Experimental Features setting that gates the whole menu item | `MainMenu.swift:728`, `AdvancedSettingsTab.swift:16` |
| The project workflow library in the left sidebar, with create, rename, duplicate, and delete | `WorkflowBuilderViewController.swift:114-127`, `:588-630` |
| The palette Filter nodes search field | `WorkflowNodePalette.swift:94-103`, `:166-192` |
| The Builder's own toolbar Export menu, with Export to Nextflow and Export to Snakemake | `WorkflowBuilderViewController.swift:1160-1170`, `:1200-1207` |
| Zoom In, Zoom Out, and Reset Zoom toolbar items and their Cmd-plus and Cmd-minus tooltips | `WorkflowBuilderViewController.swift:1107-1135` |
| The Grid and Snap toolbar toggles | `WorkflowBuilderViewController.swift:1137-1155`, `:979-986` |
| The toggle-sidebar toolbar item and the collapsible inspector | `WorkflowBuilderViewController.swift:1062`, `:145-158` |
| Undo and Redo on the canvas | `WorkflowBuilderViewController.swift:1358-1376`, `WorkflowCanvasView.swift:1022-1027` |
| Arrow-key nudging of the selection by one grid step | `WorkflowCanvasView.swift:1058-1066` |
| Rubber-band selection of several nodes at once | `WorkflowCanvasView.swift:1038-1047` |
| The Configure operation button in the inspector, which opens the shared FASTQ Operations dialog with an Apply button | `WorkflowBuilderViewController.swift:789-810`, `WorkflowNodeInspectorView.swift:35` |
| The graph validation issues that block a run, listed in a Workflow Not Ready alert | `WorkflowBuilderViewController.swift:346-354`, `WorkflowGraph.swift:520-575` |
| The No Active Project alert when no project is open | `WorkflowBuilderViewController.swift:356-365` |
| The Input Bundle Not Ready alert when the bundle path is unset or unresolvable | `WorkflowBuilderViewController.swift:371-380` |
| The Project Is Open Read Only refusal | `WorkflowBuilderViewController.swift:874-887` |
| The disclosure line when several sidebar items were selected but only one seeded the sample anchor | `WorkflowBuilderViewController.swift:424-434` |
| The unsaved-changes prompt on New Workflow, with Save, Don't Save, and Cancel | `WorkflowBuilderViewController.swift:199-227` |
| The `Trimming` node's real parameters, minimum length 20 and qualified quality 15 | `WorkflowNode.swift:278-298` |
| The `Quality Control` node's Fail on QC error parameter, default off | `WorkflowNode.swift:299-308` |
| The `Export` node type | `WorkflowNode.swift:51`, `:78`, `:176-179` |
| Parameter bounds, quality 0 to 93, window minimum 1, minimum length minimum 0, maximum length minimum 1, minimum overlap minimum 1 | `WorkflowNode.swift:325-326`, `:334`, `:361`, `:370`, `:377` |
| The `--dry-run` mode of `workflow builder-run`, which prints the compiled plan as JSON without running tools | `cli-help/workflow.txt`, builder-run options |
| The CLI's default run directory when `--run-directory` is omitted | `WorkflowCommand.swift:97-105` |
| `workflow diff --format tsv` | `WorkflowCommand.swift:159-166` |
| The `parameters_refs` requirement of the campaign, which this chapter's front matter leaves empty along with `features_refs` and `glossary_refs` | chapter front matter lines 20-23 |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: workflow-builder-palette -->` and planned shot `workflow-builder-palette` | no | Its caption promises "the seven real category headers: Input, Preprocessing, Trimming & Filtering, Decontamination, Read Processing, Analysis, Output". The palette shows four headers. Recaption to the four real headers and add the Filter nodes field. |
| planned shot `workflow-builder-canvas` | yes, with a caveat | The VSP2 chain can be composed by hand, so the shot is capturable, but the caption must not imply the template generated it. |
| `<!-- planned: workflow-builder-node-inspector -->` and planned shot `workflow-builder-node-inspector` | yes | An `Adapter + quality trim` node with its four parameters is real and selectable. Consider also showing the Configure operation button. |
| Missing shot | add one | The left sidebar workflow library is undocumented and unillustrated, yet it is the only way to name or manage a workflow. |
| Missing shot | add one | The Settings > Advanced Show Experimental Features toggle, since without it the chapter's first step fails. |

Fixture (after Phase 3): demo project
Decision: rewrite short. Experimental; four category headers and six node types; no Save Workflow item; graph-mode run rows; the VSP2 template is unreachable so the example is built by hand from the six nodes.

### 08-workflows.md/02-exporting-as-nextflow-or-snakemake.md

Verdicts: 37 true, 7 false, 9 changed, 3 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 15 | "In the save dialog, name the export folder `run-nf` and pick a location outside the project … Click **Export**." | "In the save panel titled Export Provenance, accept or replace the prefilled folder name and choose a location outside the project, then click **Save**." |
| 16 | "Lungfish writes the export folder and reveals it in Finder." | "Lungfish writes the export folder and shows a Provenance Export Complete alert. Click **Show in Finder** to open it." |
| 32 | "The Nextflow export's container references then use that image digest instead of resolving tools from a registry at run time." | "The digest of each image is recorded in `containers/manifest.json` so an auditor can check which image produced each output. The `main.nf` process still names the image by its recorded reference, so pointing a run at a local tarball means editing the config yourself." |
| 34 | `lungfish conda install --from-lockfile locks/read-mapping-lock.yml` | Remove the second command, or replace it with `lungfish conda install --pack read-mapping` and say the specification documents the request rather than pinning it. |
| 35 | "The lockfile recreates the same pinned environment before running the workflow." | "The specification records which packages were requested. It is documentation of intent, not a pinned reconstruction." |
| 43 | "The shell and Python exports expose inputs as `INPUT_n` variables." | "The shell export exposes inputs as `INPUT_n` variables. The Python export lists them in an `INPUTS` dictionary keyed by filename, with the recorded checksum as the value." |
| 56 | "This is the last chapter in [Workflows](.)." | "Continue to Running External Workflows." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "You never had to build a workflow in the Builder to export one. Any sequence of operations leaves provenance behind, and that provenance is what the exporter renders." | "Select the artifact whose history you want. Lungfish exports the provenance chain of the selected or currently displayed artifact, and falls back to the most recent completed run when nothing is selected." |
| 14 | "With the project open, choose **File > Export > Provenance > Nextflow Pipeline**." | "Select the artifact whose run you want to export, then choose **File > Export > Provenance > Nextflow Pipeline**." |
| 18 | "The generated `main.nf` declares one Nextflow process per recorded provenance step." | Add the qualifier that a run whose steps are byte-copy replays emits one replay process instead. |
| 20 | The quoted `nextflow.config` block, `process { errorStrategy = 'terminate' }` and `docker.enabled = true` | Add the conditional `container = null` line to the quoted block, or say the block is what you get when no step ran in a container. |
| 33 | `lungfish conda lock --pack read-mapping --output locks/read-mapping-lock.yml` | Rename the file in the example to `read-mapping-spec.json` and say the command writes a requested specification. |
| 36 | "The collaborator clones the repository, installs Nextflow (`curl -s https://get.nextflow.io \| bash`), and runs `nextflow run main.nf`." | Name the pinned version. `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` pins Nextflow 26.04.6. |
| 45 | "Nextflow's resume semantics also matter when steps are expensive: a failed run restarts from the failed process, not from the beginning." | Say that resume needs `nextflow run main.nf -resume` and that the generated config terminates on the first error. |
| 51 | "The methods export emits one Markdown paragraph naming each tool, its resolved version, and the parameters that differed from defaults, in the order the operations ran." | "The methods export emits a short Markdown document headed Methods, with a Computational Analysis section naming each successful step's tool and version in the order they ran, above a comment reminding you to read the draft before submitting." |
| 53 | "You can run more than one export from the same project. The exports are independent folders and do not overwrite each other." | "The default folder name carries the format, so successive exports of the same artifact do not collide. Exporting onto an existing file, rather than a folder, is refused." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The CLI equivalent `lungfish provenance export <input> --format <shell, python, nextflow, snakemake, methods, json> --output <dir>`, the only way to script an export | `cli-help/provenance.txt`, banner `==== provenance export ====` |
| `lungfish provenance verify`, which checks a signature the chapter tells the reader an auditor will want | `cli-help/provenance.txt`, banner `==== provenance verify ====` |
| `lungfish provenance bibliography`, which generates a citation list and belongs beside the Methods Section target | `cli-help/provenance.txt`, banner `==== provenance bibliography ====` |
| The Provenance Export Complete alert and its Show in Finder button | `AppDelegate+ImportExport.swift:215-228` |
| The prefilled export folder name `<artifact>-provenance-<format>` | `AppDelegate+ImportExport.swift:189-193` |
| The no-provenance alert path when the selection has no recorded history | `AppDelegate+ImportExport.swift:57-59`, `:65-68` |
| The fallback to the most recent completed run when nothing is selected | `AppDelegate+ImportExport.swift:64-70` |
| The export provenance sidecar the exporter writes for the export itself | `ProvenanceExporter.swift:188-197` |
| The retained-selection replay variants of the Nextflow, Snakemake, shell, and Python exports | `ProvenanceExporter.swift:968-987`, `:1086-1095`, `:823`, `:906` |
| That `run.sh` and `reproduce.py` are made executable | `ProvenanceExporter.swift:135`, `:139` |
| The Nextflow version Lungfish pins, 26.04.6, and the Snakemake version, 9.25.2 | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` |
| That the Workflow Builder has its own separate Nextflow and Snakemake exporters, a different code path from provenance export | `Sources/LungfishWorkflow/Builder/NextflowExporter.swift`, `SnakemakeExporter.swift`, reached from `WorkflowBuilderViewController.swift:1160-1170` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `<!-- planned: export-provenance-submenu -->` and planned shot `export-provenance-submenu` | yes | Six targets with a separator after the fourth is exactly what `MainMenu.swift:263-268` builds. |
| `<!-- planned: nextflow-export-main-nf -->` and planned shot `nextflow-export-main-nf` | yes, with a caveat | Capture a run whose steps are ordinary operations, not a retained-selection replay, or the file will show one replay process instead of one per step. |
| Missing shot | add one | The Export Provenance save panel, since the corrected step names its title, its message, and its prefilled folder name. |
| Missing shot | add one | The Provenance Export Complete alert with Show in Finder, since the corrected step replaces the false automatic reveal. |

Fixture (after Phase 3): demo project
Decision: rewrite. Export writes the recorded image reference (digest in containers/manifest.json); Save button and a Provenance Export Complete alert; conda lock is a requested spec and --from-lockfile is unsupported.

### 08-workflows.md/03-running-external-workflows.md

Verdicts: 45 true, 2 false, 9 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | (not stated) which packages a beta build can enable | Add one sentence: a linked package can be enabled only when its runner is Nextflow or Snakemake and its manifest declares a required reference bundle input, a required FASTQ bundle input, and at least one output. Others are catalogued but not runnable. |
| 30 | (not stated) Docker is the only working executor | Add a sentence: `--executor docker` is the default and the path Lungfish exercises. Apple Containerization is mapped onto the same Docker profile, so a working Docker runtime is what the pipeline actually needs. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "**Workflow Operations** configures enabled specialized workflows and supported imported local packages." | "Choosing an enabled workflow from its Tools category submenu opens the **Workflow Operations** window, which configures enabled specialized workflows and linked local packages." |
| 8 | "The engine is inferred from the path: a `.nf` extension is treated as Nextflow, and a filename containing `snakefile` (case-insensitive) is treated as Snakemake." | "A `.nf` extension in lower case is treated as Nextflow, and a filename containing `snakefile` in any case is treated as Snakemake." |
| 13 | (missing) which planning flag waives the expected-output requirement | Say the requirement is waived by `--prepare-only`. Flag the error message's mention of `--dry-run` as a source defect if the intent was to waive both. |
| 17 | Flag table "`--params-file <path>` \| Load parameters from a JSON file." | "Load parameters from a JSON or YAML file." |
| 20 | Flag table "`--cpus <n>` \| Retained CPU request; passed as `--cores` for local Snakemake. The local Nextflow adapter does not enforce a per-process CPU limit from this field." | Add the nf-core behaviour to the row. |
| 21 | Flag table "`--memory <size>` \| Retained memory request. The local adapters do not enforce a memory ceiling from this field." | Add the nf-core behaviour to the row. |
| 25 | Flag table "`--dry-run` \| Print the resolved plan without executing anything." | "Validate the workflow without executing it." |
| 49 | "**Open Tool Setup…** opens the existing runtime management surface." | "**Open Tool Setup…** opens the Plugin Manager, where tool runtimes are installed and repaired." |
| 53 | "Choose **Run** only after the check succeeds." | "The **Run** button stays disabled until the readiness line reports the configuration is ready." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `--repeat-from <bundle>` flag, which validates an original run bundle before a fresh attempt and is the CLI counterpart of Run Again | `cli-help/workflow.txt`, run options |
| The `--format text, json, tsv` output flag on `workflow run`, `list`, and `validate` | `cli-help/workflow.txt`, all three banners |
| `run-headless`, the thin alias for `workflow run --quiet` | `cli-help/run-headless.txt` |
| `ops stats`, which summarises runtime and peak memory from the provenance sidecars a run leaves | `cli-help/ops.txt`, banner `==== ops stats ====` |
| The pinned Nextflow version 26.04.6 and Snakemake version 9.25.2 | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` |
| The pinned viralrecon revision 3.0.0 | Same lock file, pipelines list, and `NFCoreSupportedWorkflowCatalog.swift:148` |
| The **Link Workflow...** button and the Link Workflow Package open panel, which is how a `.lungfishflowpkg` enters the library at all | `WorkflowLibraryPanelView.swift:136-143`, `:196-205` |
| That a linked package stays at its original location and that relinking the same identity replaces the source and version while preserving enablement | `WorkflowLibraryPanelView.swift:174-179`, panel message at `:199` |
| The Runnable versus Catalog only badge on a linked package card | `WorkflowLibraryPanelView.swift:434` |
| The two shipped example packages a reader could link to try this | `Examples/WorkflowPackages/hello-world-nextflow.lungfishflowpkg`, `hello-world-snakemake.lungfishflowpkg` |
| That an enabled workflow also appears as a Tools category submenu item, and that a disabled one appears greyed with "(not enabled)" and prompts to enable | `MainMenu.swift:794-799`, `:821-844` |
| Where the Nextflow launch scratch lives, which moves off the project volume when that volume cannot host `.nextflow/` | `Sources/LungfishWorkflow/Native/NextflowScratchVolumeProbe.swift:8-27`, `:49-52`, and the scratch work directory passed at `WorkflowCommand.swift:722-724` |
| The `-work-dir` override that scratch placement applies for nf-core runs | `WorkflowCommand.swift:683-724` |
| That local Snakemake receives `--directory <results-dir>` and `--config key=value` pairs | `LocalWorkflowRunBundle.swift:216-228` |
| The batch policy note, that Workflow Operations pools every selected FASTQ bundle into one run | `WorkflowOperationsDialog.swift:63-71` |
| The Workflow Operation Error alert | `WorkflowOperationsDialog.swift:34-43` |
| The six dialog sections a reader will actually see, Overview, Inputs, Primary settings, Advanced settings, Output, Readiness | `WorkflowOperationsDialog.swift:76-128` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| planned shot `workflow-operations-runner` | yes, with a caveat | The window and its configuration controls are real, but the caption should say the window opens from a Tools category submenu, not from a menu item named Workflow Operations. |
| Missing marker | note | The chapter has no `<!-- SHOT -->` or `<!-- planned: … -->` marker in its body, so the single planned shot is never placed. Add a marker in the Run Again section. |
| Missing shot | add one | The Workflow Library panel with the Link Workflow... button and a Runnable versus Catalog only badge, since linking is how a package arrives and the chapter never shows it. |

Fixture (after Phase 3): Examples/WorkflowPackages hello-world packages
Decision: rewrite. Workflow Library, .lungfishflowpkg manifests, Run Again and Open Previous Run, Docker as the only Nextflow executor; added to the nav.

### 09-genotyping.md/01-what-is-mhc-genotyping.md

Verdicts: 10 true, 5 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1.3 | "the miSeq amplicon, ONT, and full-length ONT MHC genotyping workflows listed in the genotyping group" (planned shot caption `workflow-library-genotyping`) | Two MHC genotyping workflows, not three. The one tool the chapter splits into "miSeq" and "ONT" is one tool, `miSeq amplicon MHC genotyping`, which handles both read types. |
| 1.10 | "Each of these M-families is a whole-region haplotype ... spanning all six MHC loci" | haplotyping (placeholder scope). The correct count is five reported loci. |
| 1.11 | "Those six are three class I loci (MHC-A, MHC-E, and MHC-B) and three class II loci (MHC-DR, MHC-DQ, and MHC-DP)." | haplotyping (placeholder scope). MHC-E is a source locus rolled into the MHC-A haplotype group, not a reported locus. |
| 1.12 | "Each allele target has an identifier such as `0068[MHC-A1]`, where `0068` is that sequence's catalogue number in the library and the bracketed part names its locus." | The allele-target identifier is the FASTA record name, for example `MCM_MHC_MiSeq_0068`, and its source locus is carried in the header field `source_loci=MHC-A1`. |
| 1.13 | "M1 across the six MCM miSeq loci (illustrative): MHC-A 0068[MHC-A1], 0129[MHC-K], 0079[MHC-AG1] / MHC-E 0010 / ..." (the fenced block) | haplotyping (placeholder scope). The block must drop the MHC-E row, use full record names, and distinguish `primaryAlleles` from the longer `diagnosticAlleles` list. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1.1 | "Workflow Library > miSeq amplicon MHC genotyping" (frontmatter `entry_points`) | `Tools > Genotyping > miSeq amplicon MHC genotyping...`. The Workflow Library window enables the workflow, it does not launch it. |
| 1.2 | "The genotyping workflows live together in the Workflow Library: the short-amplicon miSeq route ... and the full-length Oxford Nanopore (ONT) route" | Two MHC genotyping workflows appear under Tools > Genotyping, `miSeq amplicon MHC genotyping` and `Full-length ONT MHC genotyping`. `Savont Clustering` and `12S Amplicon Matching` also sit in that category. |
| 1.14 | "Lungfish prefers to keep a family intact when the evidence allows" | haplotyping (placeholder scope). Slot consistency is a rule given to the AI haplotyping provider, not a deterministic calling behavior. |
| 1.17 | "when three or more families turn up with credible support at a locus, Lungfish does not quietly pick the two strongest and move on. It reports `?/?` and flags the locus for a person" | haplotyping (placeholder scope). The overcall guard is an AI haplotyping prompt instruction, not a deterministic pipeline guard. |
| 1.18 | "That behaviour is the overcall guard, covered in detail in Reading the Genotype Comparison Viewport" | haplotyping (placeholder scope) |
| 1.20 | "It first clusters reads into consensus sequences ... using Savont or pbAA, and then genotypes those consensus sequences" | The full-length route clusters with Savont. pbAA is a separate clustering operation whose saved artifact the full-length workflow can reuse. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `mcm-mhc-miseq` locked preset, which carries its own reference and definitions and cannot be combined with `--reference` | cli-help `fastq.txt`, `fastq genotype` `--preset` "Locked genotyping preset. Supported value: mcm-mhc-miseq." |
| bbmerge pair merging of overlapping Illumina mates before mapping, without which every 244 bp DRB amplicon silently receives zero reads | `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift:5-34` |
| The zero-mismatch, full-reference-span retention rule that defines what counts as a supporting read | `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift:316-364` |
| `evidenceWeights` and the `primaryAlleles` versus `diagnosticAlleles` distinction inside a definition | the definition JSON gives `MCM_MHC_MiSeq_0079` a weight of `0.25` while primary records carry `1` |
| `Savont Clustering` and `12S Amplicon Matching` also live in the Genotyping category | `Sources/LungfishApp/Services/WorkflowLibrary.swift:141-186` |
| The plugin packs the two workflows require, `lungfish-tools`, `read-mapping`, and `full-length-mhc-genotyping` | `Sources/LungfishApp/Services/WorkflowLibrary.swift:157-162, 173-179` |
| Savont 0.6.3 and BLAST 2.16.0 are the pinned tools of the full-length pack | `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`, `full-length-mhc-genotyping` entries |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `workflow-library-genotyping` (planned) | no | Its caption names three MHC genotyping workflows and places them in the Workflow Library. There are two, and the launch path is Tools > Genotyping. Recapture as a Tools > Genotyping submenu shot. |
| `<!-- planned: workflow-library-genotyping -->` marker | keep, recaption | The marker sits in the right paragraph. Only the caption is wrong. |
| `alleles-vs-haplotypes-schematic` (planned) | no | Its caption names six loci spanning MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, MHC-DP. There are five, and MHC-E is not one of them. Under the campaign decision this schematic belongs in the haplotyping placeholder, so drop it from the rewrite. |
| `<!-- planned: alleles-vs-haplotypes-schematic -->` marker | drop | Sits inside the M-family block, which the campaign decision reduces to a placeholder. |

Fixture (after Phase 3): Williams MiSeq project
Decision: rewrite. One genotyping tool (miSeq amplicon MHC genotyping) handles Illumina and ONT inputs; record names are MCM_MHC_MiSeq_0068 style; MCM definitions have five reported loci; haplotyping gets the placeholder section.

### 09-genotyping.md/02-running-genotyping.md

Verdicts: 27 true, 6 false, 9 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2.5 | "You start every run from the Workflow Library, the launcher that lists the workflows Lungfish can run against your project data." | Runs start from the Tools menu, at Tools > Genotyping. The Workflow Library window is where a specialized workflow is enabled before it appears there. |
| 2.7 | "Three routes share this chapter" | Two genotyping operations exist in the app. On the command line the MiSeq operation is reachable as `fastq genotype` or `fastq genotype-cohort`, and `fastq ont-genotype` is a separate simpler mapping-and-filtering command that produces no haplotype analysis. |
| 2.8 | "ONT MHC genotyping (sample bundles or barcode demux)" as a distinct workflow in the routing table | The one operation, `miSeq amplicon MHC genotyping`, covers ONT sample bundles, Illumina paired bundles, and the deprecated ONT barcode-demux mode. |
| 2.9 | "Open your project, then open the Workflow Library from the toolbar." | Open your project, then choose Tools > Genotyping and the workflow you need. |
| 2.10 | "leave the mode on Illumina sample bundles" | There is no mode control to leave alone. The mode is derived from the selected reads and shown as a caption. `WorkflowOperationsDialog.swift:302-304` renders `state.effectiveGenotypingMode.displayName` as read-only text. |
| 2.42 | "Each reportable sample carries six locus rows (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP)" | haplotyping (placeholder scope). Five loci, and MHC-E is a source locus inside the MHC-A group. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 2.1 | "Workflow Library > miSeq amplicon MHC genotyping" and "Workflow Library > Full-length ONT MHC genotyping" (frontmatter) | `Tools > Genotyping > miSeq amplicon MHC genotyping...` and `Tools > Genotyping > Full-length ONT MHC genotyping...`. |
| 2.12 | "Choose the barcode-demux mode ... only for legacy barcode-split inputs: it is deprecated" | True of the CLI. There is no such mode control in the dialog, so the GUI half of this instruction has no target. |
| 2.14 | "The workflow clusters each sample with Savont by default, using a quality-value cutoff and a minimum cluster size" | The full-length route clusters with Savont. In the dialog you set only Min Length and Max Length. The Savont quality cutoff and minimum cluster size are command-line settings. |
| 2.15 | "As an alternative upstream path, you can cluster PacBio HiFi or ONT reads with pbAA first and feed the passed consensus FASTA in as the reads." | pbAA runs as its own operation and stores a reusable artifact. The full-length workflow reuses a compatible saved pbAA artifact rather than taking its FASTA as input reads. |
| 2.17 | "All three routes report into the Operations Panel" | Both genotyping operations report into the Operations Panel. |
| 2.22 | "Each command writes CSV summaries, a workbook, run statistics, and provenance into its output directory" | `fastq genotype` and `fastq genotype-cohort` write CSV summaries, a workbook, statistics, and provenance. `fastq ont-genotype` writes filtered BAMs and indexes, a report CSV, and provenance, with no workbook. |
| 2.23 | "Run `lungfish fastq genotype-cohort` in place of `genotype` ... it needs at least two `.lungfishfastq` bundles" | Drop the two-bundle minimum. The documented requirement is that each input bundle holds one prepared per-sample FASTQ. |
| 2.31 | Options table row `--haplotype-min-locus-percent` default `0` (off) | The command-line default is 0, which disables the filter. The dialog's `Locus %` field starts at 1.0. |
| 2.43 | "A sample where nearly every M-family has substantial support across many loci is the pattern the overcall guard is designed to catch." | haplotyping (placeholder scope) |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The dialog's `Analysis Mode` picker with three values, `AI preset`, `Deterministic`, and `Genotype only`, which decides whether a run haplotypes at all | `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationDialogState.swift:34-56`, `WorkflowOperationsDialog.swift:363-395` |
| The AI specialist preset path, disabled until API access is configured | `WorkflowOperationsDialog.swift:370-387`, `WorkflowOperationDialogState.swift:1264-1271` |
| The `Manage...` button beside the Haplotype Definition picker, which opens the Haplotype Definitions editor from inside the run dialog | `WorkflowOperationsDialog.swift:416-432` |
| The locked multi-bundle run picker that tells you selections run as one merged batch, with the reason string "Selections run as one genotyping batch producing a merged report. Run bundles individually for separate per-sample reports." | `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift:313-318` |
| `Analysis Name` and `Report Name` fields in both dialogs | `FASTQOperationToolPanes.swift:553-554`, `WorkflowOperationsDialog.swift:294, 311` |
| The full-length dialog's `Call Thresholds` group, its `Locus %` field, and the caption "Used for haplotype calls and Excel output. Inspector filters only change what is shown." | `WorkflowOperationsDialog.swift:322-325` |
| Optional orientation reference and forward and reverse primer FASTA pickers on the full-length sheet | `WorkflowOperationsDialog.swift:491-511` |
| `fastq savont-cluster` as a standalone operation, and `Savont Clustering` as a Tools > Genotyping item | cli-help `fastq.txt` `==== fastq savont-cluster ====`, `WorkflowLibrary.swift:166-171` |
| `fastq ont-fluidigm-samples` and `fastq ont-pacbio-barcode-demux`, the two sample-preparation commands that make the per-sample bundles the genotyper wants | cli-help `fastq.txt` lines 478 and 515 |
| `fastq update-current-workbook`, which applies review edits back into a bundle's `current.xlsx` | cli-help `fastq.txt` `==== fastq update-current-workbook ====` |
| bbmerge pair merging and the DRB zero-read failure it prevents | `Sources/LungfishWorkflow/ONTGenotyping/IlluminaAmpliconPairMerger.swift:5-34` |
| `--extra-args` for advanced minimap2 arguments, exposed in the dialog's advanced section | cli-help `fastq.txt` `--extra-args`, `FASTQOperationToolPanes.swift:887-890` |
| `--comparison-workbook` and `--comparison-name`, which lay an expected-call sheet beside the result | cli-help `fastq.txt` `fastq genotype` |
| `--sort-threads`, default 4 | cli-help `fastq.txt` `fastq genotype` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `genotyping-workflow-config` (planned) | recaption | The sheet exists but is reached from Tools > Genotyping, not the Workflow Library. Caption should name the Report, Run Parameters, and Haplotyping groups it actually shows. |
| `genotyping-ont-barcode-config` (planned) | no | Its caption promises "barcode-demux mode selected" from a mode control. No such control exists in the dialog. Drop it. |
| `genotyping-full-length-clustering` (planned) | no | Its caption promises "the Savont or pbAA clustering options". The sheet offers Min Length, Max Length, Threads, a Locus % threshold, and primer pickers. Recapture as the full-length sheet's Length Filter and Call Thresholds groups. |
| `genotyping-operations-panel` (planned) | yes, recaption | The Operations Panel does track the run. The caption's "cohort genotyping run from clustering through to a genotype result bundle" is fine for the full-length route only. |
| `<!-- planned: genotyping-workflow-config -->` marker at line 111 | keep | Sits under Step 1, which survives the rewrite as a Tools-menu step. |
| `<!-- planned: genotyping-ont-barcode-config -->` marker at line 145 | drop | Its Step 3 has no distinct workflow behind it. |
| `<!-- planned: genotyping-full-length-clustering -->` marker at line 161 | keep, recaption | Step 4 survives, but only Min Length and Max Length are dialog settings. |
| `<!-- planned: genotyping-operations-panel -->` marker at line 174 | keep | Step 5 survives unchanged. |

Fixture (after Phase 3): Williams MiSeq project
Decision: rewrite. Runs launch from Tools > Genotyping, the Workflow Library only enables workflows; settings from genotype.miseq-amplicon.

### 09-genotyping.md/03-reading-the-genotype-comparison.md

Verdicts: 16 true, 10 false, 6 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 3.3 | "The viewport opens on one of three lenses, chosen from a segmented control at the top right." | A MiSeq genotyping result opens on a two-way control whose segments are `Haplotype Calls` and `Genotype Matrix`. Summary, Review, and Audit remain only for older non-MiSeq result shapes. |
| 3.4 | "Summary is the dashboard this chapter describes" | The Summary lens is not offered on a MiSeq result. It is the internal state the two presentation choices both sit inside. |
| 3.5 | "Review is a queue that walks the flagged samples one at a time" | haplotyping (placeholder scope) for its call-evidence half. For a MiSeq result there is no Review lens. Flagged samples are reached through the Needs Review smart cohort instead. |
| 3.6 | "Audit lays out the haplotype definitions and the run artifacts the calls rest on." | There is no Audit lens on a MiSeq result. |
| 3.11 | "Each row is an allele target from the reference library, written with its identifier and source label such as `0068[MHC-A1]`." | Rows are named by the reference record, for example `MCM_MHC_MiSeq_0068`. |
| 3.15 | "For the selected sample it lays out the six MHC loci (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP)" | haplotyping (placeholder scope). Five loci. |
| 3.20 | "Summary and Review share a filter bar above the content. Its search field is sample-oriented" | The search field matches samples and alleles. Its placeholder reads "Search samples or alleles…". |
| 3.26 | "Because the Matrix instantiates only a capped window of sample columns, a wide cohort shows a 'Showing N of M samples' banner with a Show all button." | The Inspector offers `Show All Rows` and `Show All Columns` buttons that undo hiding you applied yourself. There is no automatic column window and no "Showing N of M samples" banner. |
| 3.27 | "Four rationale categories cover most calls ... `direct-primary` ... `shared-resolved` ... `secondary-rescued` ... `overcall-human-curation`" | haplotyping (placeholder scope). These four category names do not exist. The call-evidence panel shows diagnostic support counts, observed allele reads, "Other possible haplotypes", and "Why alternatives were not selected". |
| 3.28 | "Before ranking any calls, Lungfish checks whether the sample is even consistent with that." | haplotyping (placeholder scope) |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3.2 | "The dashboard has three regions ... the comparison matrix ... the haplotype tape ... the cohort summary." | The dashboard carries at least seven regions. Naming three as "the" regions understates it. |
| 3.7 | "Within Summary, an Outline and Matrix toggle switches how the samples are laid out." | On a MiSeq result the switch is the viewport's own `Haplotype Calls` and `Genotype Matrix` segmented control. The Inspector's "Show haplotyping view" and "Show genotype matrix" button appears only on older result shapes. |
| 3.17 | "Lungfish reorders H1 and H2 freely to keep the same M-family aligned down a column of loci" | haplotyping (placeholder scope) |
| 3.19 | "Each tally names its samples when you hover the count" | Hovering names the samples behind the two low-coverage tallies. It lists at most eight, then "(+N more)". The other tallies carry no tooltip. |
| 3.23 | "the built-in 'Needs review' cohort is the one the Review lens activates" | The built-in smart cohort is named `Needs Review`. On a MiSeq result you activate it yourself rather than having a Review lens do it. |
| 3.29 | "Picture a hypothetical animal we will call LF2840, showing credible support for nearly every family" | haplotyping (placeholder scope). Drop the worked example with the guard it illustrates. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The `Actions` menu button beside the presentation control, carrying `AI Discovery`, `AI Refinement`, and `Export Excel View…` | `GenotypeResultViewController.swift:2665-2682` |
| The Inspector's `Genotype Display` section, holding Min Reads, Min Percent, a Percent Basis picker, cell colours, highlight scope, and content text size | `GenotypeResultDisplaySection.swift:1224-1251, 1433-1560, 1289-1310` |
| The `Percent Basis` choice between the sample's retained reads and the viewed locus | `GenotypeResultDisplaySection.swift:1566-1571`, cli-help `genotype.txt` `--percent-basis` |
| Cmd-F focuses the search field and Escape clears it | `GenotypeResultViewController.swift:1119-1128` |
| Weak calls draw at half opacity | `GenotypeHaplotypeTapeView.swift:320-322`, `withAlphaComponent(0.5)` |
| Override hatching drawn over an overridden tape cell | `GenotypeHaplotypeTapeView.swift:137-140` |
| The manual haplotype editor with its copy-candidate list, a separate surface from a single-slot override | `Sources/LungfishGenotypeUI/GenotypeManualHaplotypeEditor.swift:29-47, 846` |
| The candidate-allele evidence surfaces for the full-length route, including the difference track | `GenotypeCandidateEvidenceSection.swift`, `GenotypeCandidateDifferenceTrackView.swift` |
| Block classifications shown in the outline, `Block coherent`, `Regional recombinant`, `Atypical`, `Unknown` | `GenotypeResultViewController.swift:9634-9640` |
| The read-only session behavior on a read-only bundle, where a presentation change is not saved | `GenotypeResultPresentationPolicy.swift:126-131` |
| The explanation shown when a saved haplotype analysis is empty or malformed | `GenotypeResultPresentationPolicy.swift:124-127` |
| The `genotype list-samples` and `genotype list-cohorts` read-only inspection commands | cli-help `genotype.txt` |
| The three replay commands that reproduce a recorded GUI edit headlessly, `replay-matrix-annotation`, `replay-manual-haplotype-assignments`, `replay-call-overrides` | cli-help `genotype.txt` |
| `genotype apply-annotations`, which merges an annotation patch into the sidecar | cli-help `genotype.txt` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `genotype-matrix-overview` (planned) | yes | The allele-by-sample matrix is real. Caption should say the row label is the reference record name, not `0068[MHC-A1]`. |
| `genotype-haplotype-tape` (planned) | recaption, haplotyping scope | The tape exists, but the caption's six loci are five. Under the campaign decision this belongs to the placeholder section. |
| `genotype-cohort-summary` (planned) | yes | The four-section panel is real. Caption should name the four sections. |
| `genotype-call-evidence` (planned) | recaption | The panel exists, but "the rationale behind a called haplotype" promises rationale categories that do not exist. Recaption to diagnostic support, observed reads, and alternatives not selected. |
| `genotype-manual-haplotyping` (planned) | recaption, haplotyping scope | The override control exists. The caption should not imply a lone slot control, since a separate manual haplotype editor also exists. |
| `<!-- planned: genotype-matrix-overview -->` at line 45 | keep | Sits in the opening description, which survives. |
| `<!-- planned: genotype-haplotype-tape -->` at line 121 | move | Its section becomes the haplotyping placeholder. |
| `<!-- planned: genotype-cohort-summary -->` at line 141 | keep | The cohort summary section survives. |
| `<!-- planned: genotype-call-evidence -->` at line 194 | keep, recaption | Step 3 survives once the four rationale categories are removed. |
| `<!-- planned: genotype-manual-haplotyping -->` at line 235 | move | Step 4 is override and annotation work, and its haplotype half moves to the placeholder. |

Fixture (after Phase 3): Williams MiSeq project
Decision: rewrite. Haplotype Calls and Genotype Matrix views; Show All Rows and Show All Columns; Min Reads and Min Percent; the rationale-category worked example is removed; haplotype tape and AI haplotyping go to the placeholder section.

### 09-genotyping.md/04-haplotype-definitions-and-export.md

Verdicts: 37 true, 3 false, 4 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4.9 | "Each of the six loci (MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP) lists the M-families it can call" | haplotyping (placeholder scope). Five loci. |
| 4.11 | "The editor opens as a sheet showing the definition's loci down one axis and its families across the marker columns" | haplotyping (placeholder scope). The editor is a locus sidebar beside the selected locus's family list, one locus at a time. |
| 4.32 | "The genotype viewport offers a single in-app export: the Audit lens carries an **Export Excel View...** button" | The viewport offers two in-app exports. `Export Excel View…` sits in the Actions menu beside the presentation control, and `Filtered Pivot…` sits at the foot of the Inspector's Genotype Display section. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4.2 | "Genotype viewport > Haplotype Definitions" (frontmatter) | haplotyping (placeholder scope). The in-app route to the editor is Tools > Haplotype Definitions, or the `Manage…` button in the genotyping run dialog. |
| 4.4 | "Genotype viewport > Export" (frontmatter) | `Genotype viewport > Actions > Export Excel View…` and `Inspector > Genotype Display > Filtered Pivot…`. |
| 4.10 | "a definition ID, an assay label, a species code such as MCM, a version, and a per-family display color" | haplotyping (placeholder scope). The metadata is an id, a display name, an assay id, a species code and name, and an allele prefix. No version field exists in the built-in set. |
| 4.18 | "The same operations are available headless under `lungfish haplotypes`: `list`, `validate`, and `save`, plus `export`, `import`, `duplicate`, and `delete` ... and `bundle-create`, `bundle-save`, and `bundle-replace-reference`" | haplotyping (placeholder scope). Add `bundle-install`, which installs an existing `.lungfishmhcref` bundle into a project. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Tools > Haplotype Definitions item appears only when an enabled workflow declares the `haplotypeDefinitions` capability | `MainMenu.swift:708`, `WorkflowLibrary.swift:69-102, 162, 178` |
| `haplotypes bundle-install`, the eleventh subcommand | cli-help `haplotypes.txt` |
| `--include-shadowed` and `--include-reference-bundles` on `haplotypes list` | cli-help `haplotypes.txt` |
| `--change-note`, the provenance note carried on import, save, bundle-save, and duplicate | cli-help `haplotypes.txt` |
| `--compact-knowledge-pack`, which retrieves only prompt-relevant knowledge-pack records | cli-help `genotype.txt` |
| `--prompt-template-id` and `--prompt-template-version`, which pin a prompt for reproducibility | cli-help `genotype.txt` |
| `--temperature` default 0.0, `--max-output-tokens` default 4096, `--max-observations-per-chunk` default 10000, `--max-provider-retries` default 2 | cli-help `genotype.txt` |
| `--debug-output`, which validates a run without publishing a revision, and the chunk-index flags that pair with it | cli-help `genotype.txt` |
| `--population` and `--assay-resolution` prompt hints, such as `mcm` or `indian-rhesus` and `short-exon-amplicon` or `full-length` | cli-help `genotype.txt` |
| The `--lens`, `--min-reads`, `--filter`, and `--view-projection` provenance options on `genotype export` | cli-help `genotype.txt` |
| `Export Filtered Pivot...` also exists as a viewport button on non-MiSeq result shapes | `GenotypeResultViewController.swift:9658-9670` |
| The XLSX Matrix sheet colours ERR cells with the Lungfish danger colour and leaves absent cells unfilled | `GenotypeExportXLSXSubcommand.swift:14-16` |
| The export is provenance `inspectOnly` and never modifies the bundle or its sidecar | `GenotypeExportXLSXSubcommand.swift:22-23` |
| The definition editor's read-only diagnostic matrix adds one column per diagnostic target after the six fixed columns | `GenotypeHaplotypeDefinitionMatrixView.swift:278-283` |
| No `parameters_refs` entry in the chapter frontmatter, and no genotyping operation is registered in `docs/user-manual/parameters.yaml` yet. `fastq.savont-clustering` is the only entry in the genotyping neighbourhood | `docs/user-manual/parameters.yaml:1229` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `haplotype-definition-editor` (planned) | recaption, haplotyping scope | The editor exists. Its caption's "aligned marker columns" is not a control name found in source. Under the campaign decision the whole definitions procedure becomes a placeholder. |
| `haplotype-ai-discovery` (planned) | recaption | The AI Discovery panel is reached from an `Actions` menu, which the caption should show. |
| `genotype-export-dialog` (planned) | no | Its caption promises "the XLSX, CSV, TSV, and samples-across pivot options" in one dialog. There is no in-app format picker. Recapture as the Actions menu plus the Inspector's Filtered Pivot button. |
| `genotype-labkey-export` (planned) | no | The LabKey export is command-line only. There is no in-app surface to photograph. Replace with a listing of the five CSV filenames. |
| `<!-- planned: haplotype-definition-editor -->` at line 106 | move | Step 1 becomes the haplotyping placeholder. |
| `<!-- planned: haplotype-ai-discovery -->` at line 141 | keep, recaption | Step 2 survives as an advisory-drafting section. |
| `<!-- planned: genotype-export-dialog -->` at line 187 | keep, recaption | Step 3 survives once the single-dialog framing is dropped. |
| `<!-- planned: genotype-labkey-export -->` at line 219 | drop | Step 4 has no in-app screen. |

Fixture (after Phase 3): Williams MiSeq project
Decision: rewrite, retitle 'Exporting Genotypes'. Export Excel View and Filtered Pivot from the Actions menu and Inspector; CSV, TSV, LabKey CSV on the CLI; haplotype definitions become the placeholder section.

### appendices.md/cli-reference.md

Verdicts: 86 true, 25 false, 39 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "The binary exposes 43 top-level commands." | "The binary exposes 44 top-level commands." |
| 4 | The command index table (44 rows expected) | Add a row for `tools`. It inspects and updates managed third-party tools against the pinned dependency set (`tools update`). |
| 10 | "`genotype` \| Inspect and export ONT genotype result bundles (7 subcommands)." | "`genotype` \| Inspect, annotate, and export ONT genotype result bundles (11 subcommands)." |
| 11 | "`haplotypes` \| Manage ONT genotyping haplotype definition sets (10 subcommands)." | "`haplotypes` \| Manage ONT genotyping haplotype definition sets (11 subcommands)." |
| 26 | The `fetch` section omits `fetch search` and `fetch sra info`. | Add: "`lungfish fetch search <query> [--db <database>] [--limit <n>] [--organism <name>]` searches NCBI databases and lists matching accessions. `lungfish fetch sra info <accession>` prints metadata for one SRA run." |
| 32 | "`lungfish import application-export <kind> <source-path> --project <path>` ... Imports an external application export (such as a Geneious-style project)" | "`lungfish import application-export <kind> <source-path> --project <path>` imports an external application export. `<kind>` is one of `clc-workbench`, `dnastar-lasergene`, `benchling-bulk`, `sequence-design-library`, `alignment-tree`, `sequencing-platform-run-folder`, `phylogenetics-result-set`, `qiime2-archive`, or `igv-session-track-set`. Geneious exports have their own subcommand, `lungfish import geneious <path> --project <path>`." |
| 34 | "`lungfish bundle create --fasta <path> [--annotation <path>...] --name <name> [--output-dir <dir>] [--compress]`" | "`lungfish bundle create --fasta <path> --name <name> --output-dir <dir> [--annotation <path>...] [--variant <path>...] [--identifier <id>] [--bundle-description <text>] [--organism <name>] [--assembly <name>] [--compress]`. All three of `--fasta`, `--name`, and `--output-dir` are required." |
| 36 | "`lungfish bundle list` ... Lists every reference bundle in the project's `Reference Sequences/` folder." | "`lungfish bundle list <bundle> [--tracks] [--files]` lists the files and tracks inside one `.lungfishref` bundle. `--tracks` shows tracks only and `--files` shows files only." |
| 42 | The `map` signature omits `--mapper`, `--secondary`, `--no-supplementary`, and `--min-mapq`. | Add to the signature: `[--mapper <minimap2\|bwa-mem2\|bowtie2\|bbmap>] [--secondary] [--no-supplementary] [--min-mapq <int>]`, and note that `--min-mapq` defaults to 0, `--secondary` keeps secondary alignments in the normalized BAM, and `--no-supplementary` drops supplementary ones. |
| 47 | "`lungfish bam primer-trim --bundle <bundle> --alignment-track <id> --scheme <path> [--name <name>]`" | "`lungfish bam primer-trim --bundle <bundle> --alignment-track <id> --scheme <path> --name <name> [--target-reference <sn>] [--ivar-min-quality <int>] [--ivar-min-length <int>] [--ivar-sliding-window <int>] [--ivar-primer-offset <int>]`. `--name` is required. The iVar trim options default to quality 20, length 30, and a 4-base sliding window." |
| 52 | The `variants call` flag table omits `--min-depth`, `--ivar-consensus-af`, `--ivar-merge-af-threshold`, `--ivar-bad-quality-threshold`, and `--ivar-no-ignore-strand-bias`. | Add rows: `--min-depth <int>` minimum depth threshold. `--ivar-consensus-af <float>` allele frequency above which an iVar haplotype counts as consensus (default 0.75). `--ivar-merge-af-threshold <float>` maximum allele frequency distance for merging adjacent iVar SNPs (default 0.25). `--ivar-bad-quality-threshold <int>` iVar ALT_QUAL below this fails the bq filter (default 20). `--ivar-no-ignore-strand-bias` applies the iVar strand-bias filter, which is off by default for amplicon data. |
| 62 | The `esviritu` section omits `download-db` and `db-status`. | Add: "`lungfish esviritu download-db` downloads the EsViritu viral reference database, and `lungfish esviritu db-status` reports whether it is installed." |
| 64 | The `taxtriage run` signature omits `--top-hits`, `--rank`, `--skip-assembly`, `--skip-krona`, `--max-memory`, `--max-cpus`, `--nf-profile`, `--revision`, and `--recursive`. | Add a note listing the tuning flags: `--top-hits <n>` (default 10), `--rank <D\|P\|C\|O\|F\|G\|S>` (default S), `--skip-assembly` / `--no-skip-assembly`, `--skip-krona`, `--max-memory <nextflow-size>` (default 16.GB), `--max-cpus <n>`, `--nf-profile <profile>` (default docker), `--revision <ref>`, and `--recursive`. |
| 68 | The `blast verify` description omits `--max-concurrent`, `--include-children`, and `--extra-args`. | Add: "`--max-concurrent <n>` caps in-flight BLAST submissions for this process (default 1), `--include-children` adds reads classified to descendant taxa, and `--extra-args` passes BLAST URL API parameters as `KEY=VALUE` tokens." |
| 90 | The `workflow` section omits `builder-run`. | Add: "`lungfish workflow builder-run <graph>` runs a native Workflow Builder graph from the command line." |
| 94 | "`lungfish conda list` ... Lists installed packs and their versions." | "`lungfish conda list [--env <name>]` lists the packages installed in one conda environment, or in every environment when `--env` is omitted." |
| 96 | "`lungfish conda search <query>` ... Searches the bioconda index for available packs." | "`lungfish conda search <query>` searches bioconda and conda-forge for available packages. To list plugin packs instead, use `lungfish conda packs`." |
| 101 | The plugin-pack section omits `conda export-pack`, `conda offline-export`, `conda offline-install`, `conda db`, and `conda extract`. | Add: "`lungfish conda offline-export --pack <id> --output <dir>` and `lungfish conda offline-install <pack-directory> [--conda-root <dir>] [--overwrite]` move environments between machines without network access. `lungfish conda db <subcommand>` manages metagenomics reference databases with `list`, `info`, `download`, `remove`, `recommend`, `update`, and `install-managed`. `lungfish conda extract --kraken-output <file> --source <fastq>... --output <fastq>... --taxid <id>...` pulls Kraken2-classified reads out of a FASTQ." |
| 108 | The `translate` signature omits `--trim-to-stop`, `--no-stop-asterisk`, and `--longest-orf`. | Add: "`--trim-to-stop` stops translation at the first stop codon, `--no-stop-asterisk` omits stop-codon asterisks, and `--longest-orf` outputs only the longest open reading frame per sequence per frame." |
| 126 | "The ten subcommands cover `list`, `validate`, `import`, `save`, `export`, `duplicate`, `delete`, and three bundle-management subcommands" | "The eleven subcommands cover `list`, `validate`, `import`, `save`, `export`, `duplicate`, `delete`, and four bundle-management subcommands (`bundle-install`, `bundle-create`, `bundle-save`, `bundle-replace-reference`)." |
| 129 | "The seven subcommands are `list-samples`, `list-cohorts`, `apply-annotations`, `export`, `export-xlsx`, `export-pivot-xlsx`, and `export-labkey`." | "The eleven subcommands are `list-samples`, `list-cohorts`, `ai-haplotyping`, `apply-annotations`, `replay-matrix-annotation`, `replay-manual-haplotype-assignments`, `replay-call-overrides`, `export`, `export-xlsx`, `export-pivot-xlsx`, and `export-labkey`." |
| 139 | "Input and output must be different files" is missing from the chapter. | Add: "The input and output must be different files. In-place conversions and symlink or hard-link aliases of the input are rejected." |
| 140 | "`lungfish search <pattern> --in <path>` ... Searches a FASTA or FASTQ for sequence patterns." | "`lungfish search <input> <pattern> [--regex] [--iupac] [--max-mismatches <n>] [--forward-only] [--case-sensitive] [-o <path>]` searches a FASTA for an exact string, an IUPAC motif, or a regular expression, and writes BED-format hits (chrom, start, end, name, score, strand). Both strands are searched by default for nucleotide sequences." |
| 145 | The `tree` section omits `export`, `reroot`, `extract-subtree`, and `relabel`. | Add: "The `tree` group also exposes `export` (export tree bundle payloads with provenance), `reroot`, `extract-subtree` (extract a selected clade as a new `.lungfishtree` bundle), and `relabel` (relabel tips from the bundle's `metadata.tsv`)." |
| 148 | "The remaining `debug` subcommands are `fastq-ingest` and `workflow-log`." | "The remaining `debug` subcommands are `resource-smoke`, `fastq-ingest`, and `workflow-log`." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "`bam` \| Operate on bundle-owned BAM tracks (`filter`, `annotate`, `markdup`, `primer-trim`, `adopt-mapping`)." | "`bam` \| Operate on bundle-owned BAM tracks (`filter`, `annotate`, `annotate-best`, `annotate-cds-best`, `markdup`, `primer-trim`, `adopt-mapping`)." |
| 6 | "`conda` \| Manage plugin packs and run Kraken2 (`conda classify`)." | "`conda` \| Manage plugin packs, metagenomics databases, and Kraken2 classification (`conda classify`, `conda db`, `conda extract`)." |
| 7 | "`debug` \| Diagnostic commands (env check, container diagnostics, log parser)." | "`debug` \| Diagnostic commands (env check, container diagnostics, packaged-resource smoke test, FASTQ ingest, log parser)." |
| 8 | "`esviritu` \| EsViritu viral detection (`esviritu detect`)." | "`esviritu` \| EsViritu viral detection and database management (`detect`, `download-db`, `db-status`)." |
| 12 | "`taxtriage` \| Run the TaxTriage classification pipeline (`taxtriage run`)." | "`taxtriage` \| Run the TaxTriage classification pipeline and check its prerequisites (`run`, `check-prerequisites`)." |
| 13 | "`workflow` \| Run, list, validate, and diff Lungfish workflows." | "`workflow` \| Run, run a builder graph, list, validate, and diff Lungfish workflows." |
| 15 | "`tree` \| Infer a phylogenetic tree (IQ-TREE)." | "`tree` \| Infer, export, re-root, subset, and relabel phylogenetic tree bundles (IQ-TREE for inference)." |
| 20 | "`lungfish fetch ncbi <accession> [--db <database>] [--fetch-format <format>] [--save-to <path>]`" | "`lungfish fetch ncbi <accession>... [--db <database>] [--fetch-format <format>] [--save-to <path>] [--api-key <key>] [--no-retry]`. Accessions are repeatable, so one call can fetch several records into one file." |
| 23 | "`lungfish fetch genome <assembly-accession> [--name <name>] [--output-dir <dir>] [--fasta-only]`" | "`lungfish fetch genome <accession> [--name <name>] [--output-dir <dir>] [--fasta-only] [--no-bundle]`. The accession may be an assembly accession (`GCF_`/`GCA_`) or a nucleotide accession such as `MN908947.3`. `--no-bundle` downloads the files without wrapping them in a `.lungfishref` bundle." |
| 33 | "`lungfish import nao-mgs <path>`, `lungfish import cz-id <path>`, and `lungfish import nvd <path>` import classifier results from those pipelines into the project's `Imports/` folder." | "`lungfish import nao-mgs <path>`, `lungfish import cz-id <path>`, `lungfish import nvd <path>`, `lungfish import kraken2 <path>`, `lungfish import esviritu <path>`, and `lungfish import taxtriage <path>` import classifier results from those pipelines. `-o`/`--output-dir` names the destination project or import directory and defaults to the current directory." |
| 53 | "`--min-af <float>` \| Minimum allele frequency threshold (iVar default: 0.05)." | "`--min-af <float>` \| Minimum allele frequency threshold. The flag has no CLI default; when it is omitted the iVar pipeline uses its own 0.05 threshold." |
| 54 | "`--name <name>` \| Output track name." | "`--name`, `--output-track-name` \| Display name for the created variant track." |
| 55 | "`--extra-args <args>` \| Additional caller options forwarded to the selected caller." | "`--extra-args`, `--advanced-options` \| Additional caller arguments, written exactly as they should be passed to the underlying tool." |
| 57 | "`lungfish conda classify <fastq...> --db <name> [--preset <preset>] [--paired] [--profile] [-o <dir>]`" | "`lungfish conda classify <fastq...> --db <name> [--preset <preset>] [--paired] [--recursive] [--profile] [--confidence <float>] [--min-hit-groups <n>] [--memory-mapping] [--quick] [--bracken-read-length <n>] [--bracken-level <D\|P\|C\|O\|F\|G\|S>] [--bracken-threshold <n>] [--extra-args <args>] [-o <dir>]`" |
| 70 | "You must pick exactly one mode; omitting it fails with `Error: Validation failed: Exactly one of --by-id, --by-region, --by-db, or --by-classifier must be specified`." | Keep the rule and drop the verbatim error string, or verify the string by running the command. |
| 74 | "`lungfish assemble <fastq...> [--assembler <tool>] [--read-type <type>] [--profile <profile>] [--extra-args <args>] [--output <path>]`" | "`lungfish assemble <fastq...> [--assembler <tool>] [--read-type <type>] [--paired] [--profile <profile>] [--memory-gb <n>] [--min-contig-length <n>] [--name <name>] [--extra-args <args>] [--extra-arg <arg>...] [-o <dir>]`. `--assembler` defaults to `spades`, and `--paired` binds exactly two input files as mates of one sample." |
| 75 | "Exactly one of the two is required; supplying a bare path like `extract contigs my-assembly/` fails with `Error: Specify exactly one of --assembly or --contigs`." | Keep the rule and drop the verbatim error string, or verify the string by running the command. |
| 76 | "Name each contig with a repeatable `--contig` flag" | "Name each contig with a repeatable `--contig` flag, or list them one per line in a file passed to a repeatable `--contig-file`. `--line-width` sets the output FASTA line width (default 60)." |
| 77 | "The `fastq` group has 30-plus subcommands in total" | "The `fastq` group has 44 subcommands in total, including a five-command 12S metabarcoding lane." |
| 79 | "`lungfish fastq length-filter <input> -o <path> --min <int> [--max <int>]`" | "`lungfish fastq length-filter <input> -o <path> [--min <int>] [--max <int>]`. Both bounds are optional, so you can cap length without setting a floor." |
| 82 | "`lungfish fastq orient <input> -o <path> --reference <path>` ... The standalone top-level `lungfish orient <input> --reference <path>` runs the same operation outside the `fastq` group." | "`lungfish fastq orient <input> -o <path> --reference <path> [--word-length <n>] [--db-mask <method>] [--extra-args <args>]` writes a single oriented FASTQ. The standalone `lungfish orient <input> --reference <path> [-o <dir>] [--word-length <n>] [--mask <dust\|none>] [--save-unoriented]` runs the same vsearch orientation but writes into an output directory and can save unoriented reads separately. Both default the word length to 12 and the masking mode to `dust`." |
| 86 | "Useful viralrecon flags include `--results-dir`, `--expected-output`, `--version`, `--workdir`, `--param key=value`, `--cpus`, `--memory`, `--resume`, `--dry-run`, and `--prepare-only`." | Add `--executor <docker\|conda\|local>` (default `docker`), `--params-file <json-or-yaml>`, and `--timeout <minutes>` to the list. |
| 87 | "With `--nf-core`, lists the supported Viral Recon pipeline. Without the flag, prints a usage hint; it does not inventory project workflows." | Keep the `--nf-core` sentence. The no-flag behavior is settled by reading `Sources/LungfishCLI/Commands/WorkflowCommand*.swift`. |
| 88 | "`lungfish workflow validate <file>` ... Checks a local Nextflow file or Snakefile without running it. YAML workflow definitions are not accepted by this command." | Keep the first sentence. The YAML exclusion is settled by reading the validator source. |
| 100 | "`lungfish conda envs` ... Lists installed conda environments with package counts and on-disk sizes." | Keep the first clause. The column detail is settled by running the command or reading `Sources/LungfishCLI/Commands/CondaCommand*.swift`. |
| 105 | "`--alphabet` overrides the alphabet, which otherwise auto-detects from the file extension (`.faa` is protein, everything else DNA)." | Keep the flag description. The `.faa` mapping is settled by reading the alphabet-detection code. |
| 106 | "`lungfish analyze validate <file>... [--strict]` ... Checks that one or more files are well-formed for their detected format, across FASTA, FASTQ, GenBank, GFF3, VCF, and BED." | Keep the signature. The format list is settled by reading the validator source. |
| 110 | "`lungfish sequence annotate-orfs <bundle> [--frames <list>] [--table <id>]`" | "`lungfish sequence annotate-orfs <bundle> [--sequence <name>] [--start <n>] [--end <n>] [--frames <list>] [--table <id>] [--min-length <nt>] [--include-partial] [--allow-alternative-starts]`. `--frames` defaults to all six (`+1,+2,+3,-1,-2,-3`), `--min-length` to 100 nucleotides, and the coordinates are 0-based with an exclusive end." |
| 115 | "Recognized field tokens are `type:<kind>` ... Date bounds use `date>=YYYY-MM-DD` ..." | Keep the paragraph. The exact matching rules (exact for `role`, substring for the rest) are settled by reading the query parser. |
| 117 | "`lungfish align mafft <fasta...> --project <path> [--output <path>] [--name <name>] [--strategy <strategy>]`" | "`lungfish align mafft <fasta...> --project <path> [--output <path>] [--name <name>] [--strategy <strategy>] [--output-order <input\|aligned>] [--sequence-type <auto\|nucleotide\|protein>] [--adjust-direction <off\|fast\|accurate>] [--symbols <strict\|any>] [--sequence <name>...] [--extra-mafft-options <args>]`. `--sequence` is repeatable and restricts the alignment to the named records." |
| 127 | "definitions are project-scoped and sourced from the project's `.lungfishmhcref` bundles" | "Definitions are project-scoped. They may live as project JSON definition files or be embedded in the project's `.lungfishmhcref` reference bundles, and `haplotypes list --include-reference-bundles` shows the embedded ones." |
| 128 | "`lungfish build-db <taxtriage\|esviritu\|kraken2> <results-path> [--force]`" | "`lungfish build-db <taxtriage\|esviritu\|kraken2> <results-path> [--force] [--no-cleanup]`. `--no-cleanup` keeps the intermediate files the build produced." |
| 130 | "Read-only subcommands print to stdout; the rest merge into the annotation sidecar beside the bundle's `genotype-result.json` without modifying pipeline output." | "Read-only subcommands print to stdout, and the annotation subcommands merge into the `annotations.json` sidecar beside the bundle's `genotype-result.json` without modifying pipeline output. `ai-haplotyping` is the exception: it is a scientific write workflow that appends a versioned AI haplotype analysis revision with its own provenance and review metadata." |
| 132 | "Reads Lungfish provenance from a bundle or output directory, preferring the root `.lungfish-provenance.json` sidecar and falling back to bundle roll-ups under `provenance/`." | Keep the first clause. The sidecar-preference order is settled by reading `Sources/LungfishCLI/Commands/ProvenanceCommand*.swift`. |
| 138 | "The input format is auto-detected from the extension across FASTA (`.fa`, `.fasta`, `.fna`, `.faa`), GenBank (`.gb`, `.gbk`, `.genbank`), FASTQ (`.fastq`, `.fq`), and `.lungfishref` bundles; a trailing `.gz` is stripped before detection" | Keep the auto-detection statement. The extension list and the `.gz` stripping are settled by reading `Sources/LungfishIO/Registry/FileTypeUtility.swift` and the convert command source. |
| 143 | "`lungfish tree infer iqtree <msa-bundle> --project <project> --output <name>` ... The `iqtree` subcommand is required, the MSA bundle path is positional, and `--project` and `--output` are both mandatory. There is no `--msa` or `--out` flag." | "`lungfish tree infer iqtree <msa-bundle> --project <project> --output <name>`. `iqtree` is the default subcommand, so `lungfish tree infer <msa-bundle> ...` runs it. The MSA bundle path is positional, and `--project` and `--output` are both mandatory. There is no `--msa` or `--out` flag." |
| 144 | "Tune the run with `--model` (default `MFP`), `--bootstrap`, and `--alrt`." | "Tune the run with `--model` (default `MFP`), `--bootstrap`, `--alrt`, `--sequence-type` (default `auto`), and `--seed` (default 1). `--rows` and `--columns` restrict the inference to named rows or 1-based aligned column ranges, `--safe` enables IQ-TREE's safe numerical mode, and `--keep-identical` keeps identical sequences in the analysis." |
| 146 | "Reports the host environment: macOS version, CPU cores, memory, and a Container Support line that states whether Apple Containerization is available (macOS 26 or later). `--check-tools` probes common bioinformatics tools on `PATH`; `--tool` checks a single named tool. This is the default `debug` subcommand." | Keep the flag and default-subcommand sentences. The reported fields are settled by running the command or reading `Sources/LungfishCLI/Commands/DebugCommand*.swift`. |
| 149 | "Every command accepts these flags." (global flag table) | Replace `--project <path>` with `--format <text\|json\|tsv>` (default `text`), and add `--progress` / `--no-progress` (progress bar, auto-detected from the TTY by default). Note that `--project` is a per-command option, not a global one. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `lungfish tools update [--plan] [--apply --yes] [--json] [--required-only] [--include-databases] [--storage-root <dir>]`, the whole `tools` command group | `cli-help/tools.txt` `==== tools ====` and `==== tools update ====`, including its documented exit codes 0, 10, 2, and 1 |
| `lungfish fetch search <query> [--db <database>] [--limit <n>] [--organism <name>]` | `cli-help/fetch.txt` `==== fetch search ====` |
| `lungfish fetch sra info <accession>` | `cli-help/fetch.txt` `==== fetch sra ====` subcommand block |
| `lungfish fetch genome --no-bundle` | `cli-help/fetch.txt` `==== fetch genome ====` |
| `lungfish import msa`, `import tree`, `import sample-metadata`, `import metadata`, `import kraken2`, `import esviritu`, `import taxtriage`, `import geneious` | `cli-help/import.txt` `==== import ====` subcommand block |
| `lungfish import fastq --recipe <vsp2\|wgs\|hifi\|none>`, `--quality-binning <illumina4\|eightLevel\|none>`, `--log-dir`, `--dry-run`, `--no-optimize-storage`, `--clumping-tool`, `--compression`, `--force`, `--recursive` | `cli-help/import.txt` `==== import fastq ====` |
| `lungfish bam annotate-best` and `lungfish bam annotate-cds-best` | `cli-help/bam.txt` `==== bam ====` subcommand block |
| `lungfish bam filter` | `cli-help/bam.txt` `==== bam ====`, "Derive a filtered BAM alignment track from a bundle or mapping analysis directory" |
| `lungfish bam annotate --output-track-id`, `--primary-only`, `--include-sequence`, `--include-qualities`, `--replace` | `cli-help/bam.txt` `==== bam annotate ====` |
| `lungfish workflow builder-run` | `cli-help/workflow.txt` `==== workflow ====` |
| `lungfish workflow run --params-file`, `--timeout`, `--executor` default `docker` | `cli-help/workflow.txt` `==== workflow run ====` |
| `lungfish conda offline-export`, `conda offline-install`, `conda export-pack` | `cli-help/conda.txt` `==== conda ====` subcommand block. The CI appendix uses `offline-export` and `offline-install`, so the CLI reference should list them |
| `lungfish conda db` and its seven subcommands (`list`, `info`, `download`, `remove`, `recommend`, `update`, `install-managed`) | `cli-help/conda.txt` `==== conda db ====` |
| `lungfish conda extract --kraken-output --source --output --taxid [--include-children] [--kreport] [--no-read-pairs]` | `cli-help/conda.txt` `==== conda extract ====` |
| `lungfish esviritu download-db` and `esviritu db-status` | `cli-help/esviritu.txt` `==== esviritu ====` |
| `lungfish taxtriage check-prerequisites` | `cli-help/taxtriage.txt` `==== taxtriage ====` |
| `lungfish debug resource-smoke` | `cli-help/debug.txt` `==== debug ====` |
| `lungfish tree export`, `tree reroot`, `tree extract-subtree`, `tree relabel` | `cli-help/tree.txt` `==== tree ====` |
| `lungfish genotype ai-haplotyping` and its provider, model, Azure-endpoint, chunking, and review-scope options | `cli-help/genotype.txt` `==== genotype ai-haplotyping ====` |
| `lungfish genotype replay-matrix-annotation`, `replay-manual-haplotype-assignments`, `replay-call-overrides` | `cli-help/genotype.txt` `==== genotype ====` |
| `lungfish genotype export` (the generic `--export-format xlsx\|csv\|tsv` view-projection export, distinct from `export-xlsx`) | `cli-help/genotype.txt` `==== genotype export ====` |
| `lungfish haplotypes bundle-install`, `bundle-create`, `bundle-save`, `bundle-replace-reference` | `cli-help/haplotypes.txt` `==== haplotypes ====` |
| The five `fastq 12s-*` subcommands (`12s-reference-metadata`, `12s-reference-bundle`, `12s-match`, `12s-export`, `12s-export-unresolved`) | `cli-help/fastq.txt` `==== fastq ====` subcommand block |
| `lungfish fastq genotype`, `genotype-cohort`, `ont-genotype`, `ont-barcode-genotype`, `full-length-ont-mhc-genotype`, `update-current-workbook`, `mhc-reference-bundle` | `cli-help/fastq.txt` `==== fastq ====` subcommand block |
| `lungfish fastq pbaa-cluster`, `savont-cluster`, `scout`, `import-ont`, `ont-fluidigm-samples`, `ont-pacbio-barcode-demux` | `cli-help/fastq.txt` `==== fastq ====` subcommand block |
| `lungfish fastq deacon-ribo`, `sequence-filter`, `search-motif`, `reverse-complement`, `translate` | `cli-help/fastq.txt` `==== fastq ====` subcommand block |
| `lungfish provision-tools --arch`, `--force-rebuild`, `--list-tools`, `--status` | `cli-help/provision-tools.txt` `==== provision-tools ====` |
| `lungfish variants extract-sample` and `variants query` are named but never given a signature | `cli-help/variants.txt` `==== variants ====` |
| `lungfish msa columns` (surfaced by `msa extract` and `msa trim`) | `cli-help/msa.txt` shows `columns` in the subcommand extraction |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | The chapter's front matter has `shots: []` and no `planned_shots` key, and the body contains no `<!-- SHOT -->` or `<!-- planned: -->` markers. A pure command reference does not need screenshots |

Fixture (after Phase 3): cli-help dumps
Decision: rewrite from the help dumps. 44 top-level commands including tools; subcommand counts corrected (genotype 11, haplotypes 11, fastq 44); usage lines copied verbatim.

### appendices.md/06-running-in-ci.md

Verdicts: 11 true, 2 false, 6 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | "`lungfish conda offline-export --pack classification --output .ci/lungfish-conda-packs/classification`" | Use a real pack ID. For a Kraken2 classification job that is `metagenomics`: `lungfish conda offline-export --pack metagenomics --output .ci/lungfish-conda-packs`. Update every later occurrence of `classification` in both CI examples to match. |
| 13 | "`lungfish run-headless workflows/classify-sample.yaml --input samplesheet.csv --results-dir outputs/classify-sample --expected-output outputs/classify-sample`" | Use a real workflow argument in all three examples: either a Nextflow file (`pipeline.nf`), a `Snakefile`, or `nf-core/viralrecon`. For the viralrecon path, note that it requires exactly one `--input` samplesheet. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Lungfish CLI workflows run without a display server." | "Lungfish Genome Explorer CLI workflows run without the app's window, so a CI runner needs no display. They do still need a container runtime or a conda executor, chosen with `--executor`." |
| 4 | "Every headless run writes the same provenance sidecars as the app: tool names and versions, argv, resolved options, runtime identity, input and output paths, checksums, file sizes, exit status, wall time, and useful stderr." | Keep the first clause. The field list is settled by reading the provenance writer, and it must match the one in power-user-notes.md and file-formats.md. |
| 7 | "`--output .ci/lungfish-conda-packs/classification`" names the pack directory itself. | "`--output` names the directory the pack directory will be written into, so pass `.ci/lungfish-conda-packs` and let the command create the pack folder under it." |
| 8 | "`lungfish conda offline-install .ci/lungfish-conda-packs/classification --conda-root \"$LUNGFISH_CONDA_ROOT\"`" | "`lungfish conda offline-install .ci/lungfish-conda-packs/metagenomics --conda-root \"$LUNGFISH_CONDA_ROOT\" --overwrite`. `--overwrite` replaces environments with matching names, which a re-run of a cached CI job will hit." |
| 14 | "`runs-on: macos-26`" in the GitHub Actions example. | Keep the intent and note why: container support needs macOS 26 or later. Verify the runner label against GitHub's current image list before publishing. |
| 19 | "offline packs are portable artifacts with their own provenance" | Keep the portability claim. The pack's own provenance is settled by reading the offline-export writer. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| `--executor <docker\|conda\|local>`, which decides whether the CI job needs a container runtime at all. This is the single most important CI flag and the chapter never names it. Its default is `docker` | `cli-help/workflow.txt` `==== workflow run ====`, `--executor  Execution profile for nf-core workflows: docker, conda, or local (default: docker)` |
| `--dry-run` and `--prepare-only`, the two ways to validate a workflow in CI without paying for a full run. `--prepare-only` creates the run bundle and command preview without launching Nextflow | `cli-help/workflow.txt` `==== workflow run ====` |
| `--timeout <minutes>`, which is how a CI job stops a hung workflow rather than waiting for the runner's own timeout | `cli-help/workflow.txt` `==== workflow run ====` |
| `--resume`, which pairs with a cached work directory to restart a failed run | `cli-help/workflow.txt` `==== workflow run ====` |
| `lungfish tools update --plan`, which exits 10 when work is pending. That exit code is designed for exactly this job, letting a CI step assert the runner matches the pinned dependency set before any scientific work starts | `cli-help/tools.txt` `==== tools update ====`, "Exit codes: 0 nothing to do, or the update was applied; 10 work is pending (--plan only); 2 usage error, such as --apply without --yes; 1 an item failed to install" |
| `lungfish debug env --check-tools` and `lungfish debug container`, the two preflight checks a CI job should run before a workflow | `cli-help/debug.txt` `==== debug env ====` and `==== debug container ====` |
| `LUNGFISH_STORAGE_ROOT`, the second storage override beside `LUNGFISH_CONDA_ROOT` | `Sources/LungfishCore/Storage/ManagedStorageConfigStore.swift:138`, which checks both keys together |
| `NCBI_API_KEY`, which a CI job that fetches from NCBI needs to avoid rate limiting | `Sources/LungfishCore/Services/NCBI/NCBIService.swift:89`. `Sources/LungfishCLI/Commands/FetchCommand.swift:461` |
| `--format json` on every command, which is how a CI step parses a result rather than scraping text | `cli-help/_root.txt` `OPTIONS:`, `--format <format>  Output format: text, json, tsv (default: text)` |
| The ten real pack IDs a CI author must choose from when writing an `offline-export` step | Lock `packTools[].packID` values |
| `lungfish conda export-pack`, the third offline-transfer command beside `offline-export` and `offline-install` | `cli-help/conda.txt` `==== conda ====` |
| `lungfish conda db download` and `conda db install-managed`, which stage the reference databases a classification workflow needs. An offline conda pack carries tools, not databases, so a CI job that classifies reads needs both | `cli-help/conda.txt` `==== conda db ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. A CI chapter is YAML and shell, and a screenshot of a CI web interface would go stale on the vendor's next redesign |

Fixture (after Phase 3): none
Decision: rewrite short. No classification pack; accepted workflow input types from workflow.txt; runner labels marked as examples.

### appendices.md/ai-assistant.md

Verdicts: 22 true, 0 false, 4 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 5 | "Lungfish supports three: Anthropic, OpenAI, and Google Gemini." | "Lungfish Genome Explorer supports three providers: Anthropic, OpenAI, and Google Gemini. The OpenAI path can also be pointed at a model you have deployed behind an Azure AI or Azure OpenAI endpoint, using the Azure AI section of the same settings tab." |
| 7 | "Choose your preferred provider, paste your API key, and enable AI services." | "Turn on **Enable AI-powered search**, choose a **Default provider**, and paste your API key into that provider's section." |
| 12 | "If no key is set, the panel will tell you AI services are disabled and point you back to this tab." | "If the **Enable AI-powered search** toggle is off, the panel replies that the AI Assistant is disabled and points you at Settings > AI Services. If the toggle is on but no provider has a usable key, it reports that no configured provider has a valid API key with available credits." |
| 21 | "Within a single request it reads the active viewer state, searches your genome data for genes and variants, reports variant statistics and gene details, moves the browser view to a gene or region you ask about, and searches PubMed for related literature." | Add "lists the chromosomes or contigs in the loaded reference" to the sentence, so all eleven tools are covered. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The Azure AI section of the settings tab: the "Use Azure AI-hosted endpoint" toggle, the endpoint URL field, and the deployment-name field | `AIServicesSettingsTab.swift:171-175`. `AppSettings.swift:303-309`. `Sources/LungfishCore/Services/AI/OpenAIEndpointConfiguration.swift` |
| The per-provider model pickers, which let the reader choose a specific model rather than the provider default | `AIServicesSettingsTab.swift:136-168` (`aiAnthropicModelPicker`, `aiOpenAIModelPicker`, `aiGeminiModelPicker`), with the Gemini options enumerated at `:52-59` |
| The "remove all keys from Keychain" action and its confirmation copy | `AIServicesSettingsTab.swift:239`, "This will remove the three AI provider keys from Keychain. You will need to re-enter them to use AI features." |
| The `list_chromosomes` tool | `AIToolRegistry.swift:248`, `:294` |
| The `selection_scope` and `visible_only` parameters, which decide whether the assistant reads the selected rows or every visible row | `AIToolRegistry.swift:180-215` |
| The multi-step tool loop and its ceiling. A question that needs many lookups can hit a maximum analysis-step limit and return without a final answer | `AIAssistantService.swift:212-214`, "I reached the maximum analysis steps without a final text response. Please try again with a narrower query, fewer requested actions, or a different AI provider." |
| The privacy consequence of fallback. A failed request may already have reached one provider before a second provider receives the fallback request | `AIAssistantService.swift:72`, "A failed request may already have reached one provider before another provider receives the fallback request." |
| The panel refuses a second question while one is in flight | `AIAssistantService.swift:95-98`, "Please wait for the current request to complete." |
| The species-detection behavior. The assistant's assay and reagent guidance changes depending on whether it reads the dataset as macaque, human, or mouse | `AIAssistantService.swift:659-678` |
| `lungfish genotype ai-haplotyping`, the other place an AI provider is used, with its own `--provider`, `--model`, `--azure-openai-endpoint`, and `--azure-openai-deployment` flags | `cli-help/genotype.txt` `==== genotype ai-haplotyping ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| `planned_shots: ai-assistant-panel`, captioned "The AI Assistant panel docked beside a dataset viewport with a question about the active result and its answer." | changed | The panel is a floating `NSPanel` (`AIAssistantPanel.swift:37-48`), not a docked pane. Reword the caption to "floating beside" rather than "docked beside". The rest of the shot is right and the marker sits correctly at the end of "What it is" |
| `<!-- planned: ai-assistant-panel -->` marker placement | true | It sits after the "What it is" section, which is where a reader first needs to see the panel |
| `planned_shots: ai-assistant-provider-setup`, captioned "The provider settings where a bring-your-own-key credential is entered for the AI Assistant." | changed | Still the right shot, but the corrected procedure now names three controls the caption should show: the "Enable AI-powered search" toggle, the "Default provider:" picker, and one provider's key field (`AIServicesSettingsTab.swift:110`, `:118`, `:129-141`). Frame the shot to include all three, and consider a second shot for the Azure AI section |
| `<!-- planned: ai-assistant-provider-setup -->` marker placement | true | It sits at the end of "Connecting a bring-your-own-key provider", immediately after the text it illustrates |

Fixture (after Phase 3): demo project
Decision: rewrite. Providers Anthropic, OpenAI (with Azure), Gemini; gated by Enable AI-powered search; the tools the assistant can call; the context preview.

### appendices.md/bibliography.md

Verdicts: 23 true, 0 false, 9 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "It matches tool names with a local alias table, prints known citations, and lists unmatched tools so you can add any lab-specific scripts manually." | Settled by reading the same source as row 3. |
| 17 | "UCSC bigBed/bigWig tools \| Kent WJ, Zweig AS, Barber G, Hinrichs AS, Karolchik D. BigWig and BigBed: enabling browsing of large distributed datasets. Bioinformatics. 2010. \| 10.1093/bioinformatics/btq351" | "UCSC bedGraphToBigWig \| Kent WJ, Zweig AS, Barber G, Hinrichs AS, Karolchik D. BigWig and BigBed: enabling browsing of large distributed datasets. Bioinformatics. 2010. \| 10.1093/bioinformatics/btq351" |
| 24 | "BWA \| Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. 2009. \| 10.1093/bioinformatics/btp324" | "BWA-MEM2 \| Vasimuddin Md, Misra S, Li H, Aluru S. Efficient architecture-aware acceleration of BWA-MEM for multicore systems. IEEE IPDPS. 2019. \| 10.1109/IPDPS.2019.00041". Keep the Li and Durbin 2009 BWA paper as a secondary citation for the underlying algorithm. |
| 26 | "BEDTools \| Quinlan AR, Hall IM. BEDTools ... Bioinformatics. 2010. \| 10.1093/bioinformatics/btq033" | Move it to a clearly labeled section for tools that reach a run only through an external pipeline's containers, or drop it. The chapter must not imply LGE manages it. |
| 27 | "MAFFT \| Katoh K, Misawa K, Kuma K, Miyata T. MAFFT ... Nucleic Acids Research. 2002. \| 10.1093/nar/gkf436" | "MAFFT \| Katoh K, Standley DM. MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Molecular Biology and Evolution. 2013. \| 10.1093/molbev/mst010". Keep the 2002 paper as the original-method citation. |
| 28 | "IQ-TREE \| Nguyen LT, Schmidt HA, von Haeseler A, Minh BQ. IQ-TREE ... Molecular Biology and Evolution. 2015. \| 10.1093/molbev/msu300" | "IQ-TREE \| Minh BQ, Schmidt HA, Chernomor O, et al. IQ-TREE 2: new models and efficient methods for phylogenetic inference in the genomic era. Molecular Biology and Evolution. 2020. \| 10.1093/molbev/msaa015". Check whether IQ-TREE 3 has published its own citation before finalizing. |
| 29 | "MultiQC \| Ewels P, Magnusson M, Lundin S, Kaller M. MultiQC ... Bioinformatics. 2016. \| 10.1093/bioinformatics/btw354" | Move to the external-pipeline section described in row 26, or drop. |
| 30 | "Pangolin \| O'Toole A, Scher E, Underwood A, et al. ... Virus Evolution. 2021. \| 10.1093/ve/veab064" | Move to the external-pipeline section, or drop. |
| 31 | "Nextclade \| Aksamentov I, Roemer C, Hodcroft EB, Neher RA. Nextclade ... Journal of Open Source Software. 2021. \| 10.21105/joss.03773" | Move to the external-pipeline section, or drop, and fix the matching claim in file-formats.md. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Trim Galore, in the always-installed tool set | Lock `tools[]` entry `id: trim_galore`, version 2.3.0. Cite Krueger F, Trim Galore, https://github.com/FelixKrueger/TrimGalore |
| Bracken, which runs whenever `conda classify --profile` is used | Lock `packTools[]` entry `id: bracken`, version 1.0.0, `packID: metagenomics`. Cite Lu J, Breitwieser FP, Thielen P, Salzberg SL. Bracken: estimating species abundance in metagenomics data. PeerJ Computer Science. 2017. 10.7717/peerj-cs.104 |
| EsViritu, a whole classification lane the manual documents | Lock `packTools[]` entry `id: esviritu`, version 1.3.3, `packID: metagenomics` |
| RiboDetector, behind `lungfish fastq deacon-ribo` | Lock `packTools[]` entry `id: ribodetector`, version 0.3.3, `packID: metagenomics` |
| BLAST, behind `lungfish blast verify` and the full-length MHC genotyping lane | Lock `packTools[]` entry `id: blast`, version 2.16.0, `packID: full-length-mhc-genotyping`. Cite Camacho C, Coulouris G, Avagyan V, et al. BLAST+: architecture and applications. BMC Bioinformatics. 2009. 10.1186/1471-2105-10-421 |
| Savont, the clustering tool behind full-length ONT MHC genotyping | Lock `packTools[]` entry `id: savont`, version 0.6.3, `packID: full-length-mhc-genotyping` |
| Clair3, a variant caller the CLI reference documents by name | Lock `packTools[]` entry `id: clair3`, version 2.0.2, `packID: variant-calling`. Cite Zheng Z, Li S, Su J, et al. Symphonizing pileup and full-alignment for deep learning-based long-read variant calling. Nature Computational Science. 2022. 10.1038/s43588-022-00387-x |
| GATK4, an entire ten-subcommand CLI group | Lock `packTools[]` entry `id: gatk4`, version 4.6.2.0, `packID: gatk-core`. Cite McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit. Genome Research. 2010. 10.1101/gr.107524.110 |
| WhatsHap, the phasing half of `lungfish variants phase` | Lock `packTools[]` entry `id: whatshap`, version 2.3, `packID: phasing`. Cite Martin M, Patterson M, Garg S, et al. WhatsHap: fast and accurate read-based phasing. bioRxiv. 2016. 10.1101/085050 |
| Freyja, which has its own CLI command | Lock `packTools[]` entry `id: freyja`, version 2.0.3, `packID: wastewater-surveillance`. Cite Karthikeyan S, Levy JI, De Hoff P, et al. Wastewater sequencing reveals early cryptic SARS-CoV-2 variant transmission. Nature. 2022. 10.1038/s41586-022-05049-6 |
| All five assemblers, which the assembly chapter and CLI reference both document | Lock `packTools[]` entries under `packID: assembly`: spades 4.3.0, megahit 1.2.9, skesa 2.5.1, flye 2.9.6, hifiasm 0.25.0 |
| TaxTriage, a pinned pipeline with its own CLI command | Lock `pipelines[]` entry `id: taxtriage`, `repository: jhuapl-bio/taxtriage`, `releaseVersion: v3.3.8` |
| pysam and openpyxl, which produce scientific output (BAM parsing and XLSX workbooks) and belong in a methods section | Lock `tools[]` entries `id: pysam` 0.24.0 and `id: openpyxl` 3.1.5 |
| The reference databases a methods section must cite by version, not just the tools that read them | Lock `databases[]`: nine Kraken2 databases at `20260626`, `esviritu-viral-v3` at `v3.2.4`, `deacon-panhuman` at `panhuman-1`, `human-scrubber` at `20260706v2`, and the NCBI taxonomy at `live` |
| A statement of what version of the citation list this is. A bibliography for a release should name the dependency set it matches | Lock top-level `dependencySet` 2026.2 and `version` 2026.9.13 |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. A citation table needs none |

Fixture (after Phase 3): none
Decision: rewrite. One entry per tool in the lock, canonical citations; missing entries added.

### appendices.md/file-formats.md

Verdicts: 15 true, 3 false, 11 changed, 5 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 15 | The bundle-type table omits `.lungfishgenotype`, `.lungfishrun`, and `.lungfishflow`. | Add three rows: Genotype result \| `.lungfishgenotype` \| ONT genotype calls, an annotation sidecar, and an XLSX workbook. Workflow run \| `.lungfishrun` \| A recorded workflow execution with its typed configuration and provenance. Workflow definition \| `.lungfishflow` \| A saved workflow graph as JSON. |
| 19 | "The current release ships the `QIASeqDIRECT-SARS2` built-in scheme." | "The current release ships eight built-in schemes, including `QIASeqDIRECT-SARS2` and four ARTIC versions. See [Primer Scheme Bundles](primer-schemes.md#appendix-primer-schemes) for the full list." |
| 29 | "Provenance records which aligner ran (MAFFT, MUSCLE, Nextclade) and with what parameters." | "Provenance records which aligner ran and with what parameters. MAFFT is the aligner Lungfish Genome Explorer ships, through `lungfish align mafft`." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "FASTA \| `.fa`, `.fasta`, `.fna` \| Nucleotide or protein sequence" | "FASTA \| `.fa`, `.fasta`, `.fna`, `.faa`, `.ffn`, `.frn`, `.fas` \| Nucleotide or protein sequence" |
| 3 | "GenBank \| `.gb`, `.gbk` \| Annotated sequence record" | "GenBank \| `.gb`, `.gbk`, `.genbank`, `.gbff` \| Annotated sequence record" |
| 7 | "Lungfish always reads and writes sorted, indexed BAM, and it never keeps SAM as a deliverable. When a tool emits SAM, Lungfish runs it through `samtools sort` plus `samtools index` and then deletes the intermediate file." | Keep the convention, and attribute it to the mapping pipeline rather than to format support. SAM is a format Lungfish Genome Explorer can read. It is simply never left behind as an output. |
| 14 | The bundle-type table lists ten bundle kinds. | Keep the table. Add a note that only `.lungfishref`, `.lungfish12sref`, and `.lungfishmhcref` are registered in the format registry. The rest are bundle kinds recognized by their own commands. |
| 16 | "Every bundle carries a `manifest.json` at the root that names the bundle, declares its kind and version, and lists the files inside." | Soften to "Every bundle carries a `manifest.json` at the root. The keys differ by bundle kind, so read the manifest rather than assuming a shared shape. The primer-scheme manifest, for instance, uses `schema_version` and has no `files` map." |
| 17 | The minimal manifest sample block (`kind`, `version`, `name`, `files`) | Label the sample plainly as illustrative, or replace it with a real manifest read from a shipped bundle. The chapter already hedges in "Manifest schema" ("painted in broad strokes"). The same hedge belongs here. |
| 20 | "Import ARTIC, midnight, vendor, or lab schemes through `File > Import Center > Primer Scheme`" | "Import vendor or lab schemes through `File > Import Center > Primer Scheme`. The ARTIC and Midnight schemes already ship." |
| 27 | "`.lungfishtax` ... Only the CZ-ID import path produces this bundle (`lungfish cz-id import` or `File > Import Center > CZ-ID`)." | Verify the `.lungfishtax` extension against the CZ-ID importer, or describe the output as a Lungfish result directory, which is what the CLI help calls it. |
| 30 | The `.lungfishmsa` layout block shows `alignment.fasta`, `alignment.fasta.fai`, `metadata.tsv`, `manifest.json`, `provenance/`. | Verify the internal filenames against the MSA bundle writer, or label the layout as typical rather than fixed. |
| 32 | The provenance sidecar sample block (`workflow`, `version`, `command`, `inputs`, `outputs`, `runtime`, `tool`, `steps`) | Keep one canonical sample and mark it as illustrative, or replace both with a real sidecar. The two chapters must not disagree about whether `schema_version` is present. |
| 33 | "The `inputs[]` and `outputs[]` arrays carry a SHA-256 checksum and a byte size for every file." | Settled by reading the provenance writer in `Sources/LungfishCore` or `Sources/LungfishWorkflow`. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| BigWig and BigBed, both registered and both detect-only. Lungfish Genome Explorer recognizes these files but cannot read their contents in process, which is exactly the kind of limit a formats appendix must state | `FormatRegistry+BuiltInDescriptors.swift:192-195` ("Binary coverage/signal format (detection only; in-process reader unavailable)") and `:208-211` ("Binary annotation format (detection only; in-process reader unavailable)") |
| BedGraph, a registered coverage format | `FormatRegistry+BuiltInDescriptors.swift:224`. `FormatIdentifier.swift:218` |
| CRAM, a registered alignment format alongside SAM and BAM | `FormatRegistry+BuiltInDescriptors.swift:173`. `FormatIdentifier.swift:156`. `cli-help/import.txt` `==== import bam ====` accepts "the BAM or CRAM file" |
| BCF, the binary form of VCF | `FormatRegistry+BuiltInDescriptors.swift:122`. `FormatIdentifier.swift:195` |
| EMBL, accepted by `import fasta` | `FormatIdentifier.swift:126`. `cli-help/import.txt` `==== import fasta ====` argument "(.fa/.fasta/.gb/.embl, optionally .gz/.bgz/.bz2/.xz/.zst)" |
| 2bit, a registered sequence format | `FormatIdentifier.swift:133` |
| CSI, the second BAM/VCF index format beside BAI and TBI | `FormatIdentifier.swift:241` |
| The five compression suffixes `import fasta` accepts, which are `.gz`, `.bgz`, `.bz2`, `.xz`, `.zst`. The chapter mentions only `.gz` | `cli-help/import.txt` `==== import fasta ====` |
| The document formats the registry carries, which matter for attachments and exports. They are PDF, plain text, Markdown, CSV, and TSV | `FormatRegistry+BuiltInDescriptors.swift:271`, `:289`, `:305`, `:321`, `:337`. `FormatIdentifier.swift:257-285` |
| The image formats the registry carries, which are PNG, JPEG, TIFF, and SVG | `FormatRegistry+BuiltInDescriptors.swift:355`, `:372`, `:389`, `:406`. `FormatIdentifier.swift:294-315` |
| Which formats Lungfish Genome Explorer can write, as distinct from read. Each descriptor carries `canRead` and `canWrite` flags, and only FASTQ has a dedicated writer in `Sources/LungfishIO/Formats/` | `FormatRegistry+BuiltInDescriptors.swift:25-26` (`canRead: true, canWrite: true`), and `Sources/LungfishIO/Formats/FASTQ/FASTQWriter.swift` plus `FASTQAtomicFileWriter.swift` are the only writer files in the Formats tree |
| The NCBI BioSample export writer, which produces a submission TSV from folder metadata | `Sources/LungfishIO/Formats/FASTQ/NCBIBioSampleExporter.swift`. `cli-help/metadata.txt` `==== metadata ====`, `export-biosample  Export folder metadata as NCBI BioSample submission TSV` |
| The `uiCategory` grouping the registry assigns each format, which is what decides where a format appears in a file picker | `FormatRegistry+BuiltInDescriptors.swift:26` (`uiCategory: .sequence`) and the same key on every descriptor |
| The OCI-layout tarball a bundle export produces, with its `oci-layout`, `index.json`, manifest, config, and layer files. The chapter's bundle table has no row for it | `cli-help/bundle.txt` `==== bundle export ====`. Power-user-notes.md describes the same artifact |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. The chapter's illustrations are code blocks showing file layouts and record shapes, which serve the reader better than screenshots would |

Fixture (after Phase 3): none
Decision: rewrite. Writers as they are (GFF3 yes, BED no); BigWig and BigBed detect-only; eight primer schemes; remove .lungfishhaplotypedef and .lungfishtax; one provenance sidecar sample taken from a real file.

### appendices.md/keyboard-shortcuts.md

Verdicts: 35 true, 2 false, 10 changed, 2 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 1 | "A reference of every keyboard shortcut available in Lungfish on macOS." | "A reference of the keyboard shortcuts available in Lungfish Genome Explorer on macOS." |
| 4 | "Save Project \| Cmd-S" | Remove the row. Lungfish Genome Explorer writes changes as they happen, so there is no Save command and no Cmd-S. The File menu explains this under "About Saving…". |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "Open Project \| Cmd-O" | "Open Project Folder \| Cmd-O" |
| 5 | "Close Window \| Cmd-W" | "Close \| Cmd-W" |
| 8 | "Minimize Window \| Cmd-M" | "Minimize \| Cmd-M" |
| 11 | "Operations Panel \| Cmd-Shift-P" | "Show Operations Panel \| Cmd-Shift-P". Move it out of the View table into its own Operations section, because the item is in the Operations menu. |
| 13 | "AI Assistant Panel \| Cmd-Shift-A" | "AI Assistant \| Cmd-Shift-A" |
| 22 | "In a sequence view, Show as RNA is Cmd-Shift-U." | "In a sequence view, Show as RNA (U instead of T) is Cmd-Shift-U." |
| 27 | "Import and tools" groups Import Center, Plugin Manager, and Settings under one heading. | Split the table by menu, or say plainly that Import Center is in File, Plugin Manager is in Tools, and Settings is in the Lungfish Genome Explorer menu. |
| 44 | "Lungfish Help \| Cmd-?" | "Lungfish Genome Explorer Help \| Cmd-?" |
| 47 | "`Cmd-Opt-letter` targets inspectors (Inspector, Document Inspector)." | "`Cmd-Opt-letter` targets the inspectors and a few window-level commands: Show Inspector, Document Inspector, Focus Viewer, Go to Gene, and New Window for Current Project." |
| 48 | "enter the exact menu title (for example, `Reverse Complement`)" | "Enter the exact menu title, including any trailing ellipsis. `Reverse Complement…` and `Translate…` both end in an ellipsis character, so an entry that omits it will not match." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Hide Others, Cmd-Opt-H | `MainMenu.swift:135-141`, `withTitle: "Hide Others"`, `keyEquivalent: "h"`, mask `[.command, .option]` |
| Content Text Size Larger, Cmd-Opt-+ | `MainMenu.swift:503-509`, `withTitle: "Larger"`, `keyEquivalent: "+"`, mask `[.command, .option]`. The source comment says Option separates these app-wide accessibility commands from the viewport zoom commands |
| Content Text Size Smaller, Cmd-Opt-- | `MainMenu.swift:514-520`, `withTitle: "Smaller"`, `keyEquivalent: "-"`, mask `[.command, .option]` |
| Content Text Size Default, Cmd-Opt-0 | `MainMenu.swift:525-531`, `withTitle: "Default"`, `keyEquivalent: "0"`, mask `[.command, .option]` |
| New Window for Current Project, Cmd-Opt-N | `MainMenu.swift:916-922`, `keyEquivalent: "n"`, mask `[.command, .option]` |
| The Content Text Size submenu is the accessibility answer to "the type is too small", which the Accessibility section never mentions | `MainMenu.swift:492-535`, the whole `contentTextSizeMenu` block with its accessibility labels |
| Reset View Settings to Defaults, no shortcut | `MainMenu.swift:597-602` |
| Add Annotation… and Find ORFs…, no shortcut | `MainMenu.swift:675-687` |
| Clear Completed and Cancel All Operations, no shortcut | `MainMenu.swift:876-890` |
| Open Recent, About Saving…, and the Export and Provenance submenus, no shortcut | `MainMenu.swift:182-187`, `197-201`, `216`, `260` |
| About and Check for Updates…, no shortcut | `MainMenu.swift:93-104` |
| Zoom and Bring All to Front, no shortcut | `MainMenu.swift:908-912`, `925-929` |
| Workflow Library… and Search Online Databases, no shortcut | `MainMenu.swift:766-771`, `740` |
| Getting Started and VCF Variants Guide, no shortcut | `MainMenu.swift:993-1000` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. A chord table does not need a screenshot, though a shot of the System Settings App Shortcuts pane would help the Customizing shortcuts section |

Fixture (after Phase 3): none
Decision: rewrite from MainMenu.swift. No Save or Cmd-S; every keyEquivalent listed.

### appendices.md/power-user-notes.md

Verdicts: 10 true, 4 false, 22 changed, 10 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 16 | "`\"tool_version\": \"samtools 1.21\"`" in the `steps[]` sample | Update to `"samtools 1.24"`. |
| 24 | "A conda lockfile from `lungfish conda lock --pack <name> --output lockfile.yml`" | "A requested environment specification from `lungfish conda lock --pack <name> --output requested-environment.json`. It is a JSON record of what was asked for, not a resolved artifact lock, so it does not by itself guarantee a byte-identical rebuild." |
| 25 | "`lungfish conda lock --pack <name> --output lockfile.yml` writes a conda-lock-compatible YAML file for a built-in plugin pack." | "`lungfish conda lock --pack <name> --output requested-environment.json` writes a Lungfish requested environment specification in JSON. It records the pack identity, the requested packages, the target platforms, the channels, and the post-install hooks. It is not conda-lock compatible and it is not a resolved artifact inventory." |
| 27 | "Reinstall from it with: `lungfish conda install --from-lockfile lockfile.yml`" | "There is no reinstall-from-lock path today. `lungfish conda install --from-lockfile` exists only to refuse the operation, and it fails before creating or changing an environment. For a reproducible rebuild, use the OCI export or an offline conda pack instead." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "The iVar variant caller in Lungfish is a two-process pipeline. First `samtools mpileup` ... That pileup pipes straight into `ivar variants`." | Settled by reading the iVar pipeline in `Sources/LungfishWorkflow`. The claim is plausible and internally consistent with file-formats.md, which shows the same two `steps[]` entries. |
| 5 | The canonical `ivar variants -p variants -q 20 -t 0.05 -m 10 -r reference.fasta -g annotations.gff3` block | Settled by reading the pipeline source. Note that `--min-af` and `--min-depth` override `-t` and `-m` from the CLI. |
| 6 | "`-t <float>` \| Minimum allele frequency threshold \| 0.05 (overridable in the dialog)" | "`-t <float>` \| Minimum allele frequency threshold \| 0.05, overridable with `--min-af` on the CLI or in the dialog" |
| 13 | "The Lungfish convention is to hand LoFreq the un-trimmed BAM" | Keep it as a stated convention rather than as tool behavior. |
| 14 | The provenance sidecar sample block with `"schema_version": 2` | Reconcile the two samples against a real sidecar. They must agree. |
| 15 | "`\"version\": \"0.5.0-alpha11\"`" in the sidecar sample | Update the sample's `version` to `2026.9.13`. |
| 21 | "It walks every `.lungfish-provenance.json` sidecar it can find, skips the failed and cancelled runs, and reports the completed run count, the total wall time, the average wall time per operation name, and the single largest peak-RAM figure any step recorded." | Keep the first clause. The skip rule and the reported columns are settled by running the command or reading `Sources/LungfishCLI/Commands/OpsCommand.swift`. |
| 22 | "Recent Lungfish builds also stamp each step with `peakMemoryBytes`" | Settled by reading the provenance writer. The camelCase name also sits oddly beside the snake_case keys in the same sample block, which is worth checking. |
| 26 | "Inside are the pack ID, the channels, the platforms, a content hash, and one package record for every pinned requirement." | Reconcile with cli-reference.md, and verify against a real exported file. The two chapters currently disagree. |
| 28 | "For bit-identical reproduction across machines, pair the provenance sidecar with one of: an OCI image artifact ... a conda lockfile ... a Snakemake / Nextflow export" | "For bit-identical reproduction across machines, pair the provenance sidecar with an OCI image artifact from `lungfish bundle export --format container`, or with an offline conda pack from `lungfish conda offline-export`. A Snakemake or Nextflow export helps only when it carries lockfile or container references." |
| 29 | "Both commands leave a `.lungfish-provenance.json` beside their output or conda root." | Keep the `conda lock` half and drop the install half. |
| 30 | The per-tool determinism table rows for `samtools sort`, `samtools index`, `samtools mpileup`, `ivar variants` | Keep the table and label it as upstream tool behavior at the pinned versions, which is what it is. |
| 31 | "`minimap2` \| Mostly \| Multi-threading can produce non-bit-identical CIGAR strings ... Pin `--threads 1` for strict determinism." | Keep it. Label it as upstream behavior at minimap2 2.31, the pinned version. |
| 32 | "`spades` / `flye` / `hifiasm` \| No \| Multi-threaded assembly graphs traversed non-deterministically" | Add rows for MEGAHIT and SKESA, or say the row covers every assembler in the `assembly` pack. |
| 33 | "samtools tightened indel realignment in 1.20 and up" | "The `tool.version` field in each sidecar is how a re-runner catches that drift. This release pins samtools 1.24, so a sidecar recording an earlier samtools came from a different installation." |
| 34 | "Apple Containers \| macOS 26+, arm64 \| Default on supported Macs" | "Apple Containers is available on macOS 26 and later on Apple Silicon. It is not the `workflow run` default, which is `docker`; select it with `--executor`." |
| 35 | "Inside sit the bundle payload files, the pinned plugin-pack metadata, and the standard OCI furniture: `oci-layout`, `index.json`, the manifest, the config, the layer tar, and a `.lungfish-provenance.json`." | Settled by reading the OCI exporter, or by exporting a fixture bundle and listing the tarball. |
| 37 | "These stay single-threaded: `lungfish bundle create`, `lungfish import-fastq`" | Reword to say the flag is accepted globally but has no effect on these commands, and verify which ones actually consume it. |
| 42 | "When an operation fails, read the stderr disclosure first." | "When an operation fails, read the stderr disclosure. Lungfish Genome Explorer also writes a failure report to `~/Library/Logs/<app name>/Operations/Failures` as the failure happens, so you can read it later without the app running." |
| 43 | "`lungfish variants call --caller ivar --extra-args \"--gff annotations.gff3 --pass_only\"`" | Pick an example flag the pipeline does not already set, so the reader does not learn to fight the wrapper. |
| 45 | "`source ~/.lungfish/conda/envs/ivar/bin/activate`" | "The supported escape hatch is `lungfish conda run [--env <name>] <tool> [args...]`, which runs the tool from its managed environment and passes stdout, stderr, and the exit code straight through. It still bypasses provenance recording, so use it sparingly." |
| 46 | "A later `lungfish bam adopt-mapping` will have no way to confirm the BAM came from the pipeline it expected." | Keep the warning. It follows from the command requiring a `lungfish map` result directory rather than a loose BAM. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The five iVar tuning flags the CLI exposes, which are exactly this chapter's subject. They are `--ivar-consensus-af` (default 0.75), `--ivar-merge-af-threshold` (default 0.25), `--ivar-bad-quality-threshold` (default 20), `--ivar-no-ignore-strand-bias`, and `--min-depth` | `cli-help/variants.txt` `==== variants call ====` |
| `--ivar-no-ignore-strand-bias` is the direct answer to the chapter's own LoFreq strand-bias section. iVar's strand-bias filter is off by default for amplicon data and this flag turns it on | `cli-help/variants.txt` `==== variants call ====`, "Apply iVar strand-bias filter (off by default for amplicon data)" |
| The four primer-trim tuning flags, which sit upstream of every iVar call this chapter describes. They are `--ivar-min-quality` (20), `--ivar-min-length` (30), `--ivar-sliding-window` (4), `--ivar-primer-offset` | `cli-help/bam.txt` `==== bam primer-trim ====` |
| `--target-reference` on `bam primer-trim`, the fix for a scheme whose accession does not match the BAM's `@SQ` SN | `cli-help/bam.txt` `==== bam primer-trim ====` |
| `lungfish conda offline-export` and `offline-install`, the reproducibility path that actually works, unlike the lockfile path this chapter recommends | `cli-help/conda.txt` `==== conda offline-export ====`, `==== conda offline-install ====` |
| The conda mutation lock at `<conda-root>/.install.lock` and its two user-visible messages, which a power user driving concurrent installs will hit | `Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift:22`, `:95`, `:12` |
| `lungfish tools update --plan` and its exit code 10, the machine-readable way to assert an installation matches the pinned dependency set | `cli-help/tools.txt` `==== tools update ====` |
| Failure reports on disk at `~/Library/Logs/<app name>/Operations/Failures`, capped at 50 reports with older ones pruned on each write | `OperationFailureReportStore.swift:20-22` (`defaultRetentionLimit = 50`), `:56-77` (the path construction), `:10-18` (the rationale) |
| Failure reports are keyed on app identity, so a Debug build's reports never interleave with a shipped build's | `OperationFailureReportStore.swift:52-54`, "keyed on app identity so a Debug build never interleaves its reports with a shipped build's" |
| A failed write of a failure report is swallowed rather than raised, so an absent report is not itself a signal | `OperationFailureReportStore.swift:73-78`, "Returns nil for operations that did not fail, and also for any I/O error" |
| `lungfish variants query`, a per-sample smart filter over bundle variants, and `lungfish variants extract-sample` | `cli-help/variants.txt` `==== variants ====` |
| `--format json` on `ops stats`, which is how a power user pipes cost data into a script | `cli-help/ops.txt` `==== ops stats ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | changed | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. The "Operations Panel as a debug tool" section describes an eight-field disclosure in prose and would be far clearer with one screenshot of an expanded failed row showing the stderr and command fields |

Fixture (after Phase 3): none
Decision: rewrite. Pipeline internals verified against Sources/LungfishWorkflow or dropped; conda lock wording aligned with the CLI; provenance sample from a real file.

### appendices.md/primer-schemes.md

Verdicts: 15 true, 2 false, 9 changed, 0 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 2 | "The current release ships a single built-in scheme in the app resources." | "The current release ships eight built-in schemes in the app resources. All eight target SARS-CoV-2 with canonical accession `MN908947.3` and equivalent accession `NC_045512.2`." Follow with a table of the eight. They are ARTIC SARS-CoV-2 V3 (`ARTIC-nCoV-2019-V3`, 218 primers, 98 amplicons), ARTIC SARS-CoV-2 V4 (`ARTIC-SARS-CoV-2-V4`, 198, 99), ARTIC SARS-CoV-2 V4.1 (`ARTIC-SARS-CoV-2-V4.1`, 209, 99), ARTIC SARS-CoV-2 V5.3.2 (`ARTIC-SARS-CoV-2-V5.3.2`, 192, 96), Midnight 1200 bp V1 (`Midnight-1200-V1`, 58, 29), NEB VarSkip Short v1 (`NEB-VarSkip-vss1`, 148, 74), NEB VarSkip Long v1 (`NEB-VarSkip-Long-vsl1`, 50, 29), QIAseq Direct SARS-CoV-2 with Booster A (`QIASeqDIRECT-SARS2`, 563, 223). |
| 9 | The manifest table omits `imported` and `attachments`. | Add two rows. `imported` is the timestamp written when an existing scheme was imported into a project, as distinct from `created`. `attachments` is an array of `{path, description}` objects naming the extra files copied under `attachments/`. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 6 | The bundle layout block shows `manifest.json`, `primers.bed`, `primers.fasta` (optional), `attachments/` (optional), `PROVENANCE.md`, and `.lungfish-provenance.json`. | Keep the layout for imported bundles, but say that `.lungfish-provenance.json` appears only on bundles the importer wrote. The eight built-in schemes ship with `manifest.json`, `primers.bed`, and `PROVENANCE.md` only. |
| 11 | "`amplicon_count` \| Distinct amplicon names inferred from BED column 4 after stripping `_LEFT` and `_RIGHT`." | Keep the field description. The `_LEFT` / `_RIGHT` stripping rule is settled by reading the primer-scheme importer. |
| 12 | "`source` \| Provenance of the scheme: `built-in` for the shipped scheme." | "`source` \| Where the scheme came from. All eight shipped schemes use `built-in`." |
| 17 | "`lungfish primers import --bed primers.bed --fasta reference.fasta --output MyScheme.lungfishprimers --reference-accession MN908947.3 --display-name \"My Scheme\"`" | Rename the example argument to `primers.fasta`, and say that `--fasta` copies a primer FASTA into the bundle rather than a reference sequence. |
| 19 | "The `.lungfishprimers` suffix is added for you when you leave it off." | Keep the sentence. It is settled by reading the primers importer. |
| 21 | "`--reference-accession` names the canonical reference accession." | "`--reference-accession` names the canonical reference accession. Leave it off and the importer takes the value from the BED file's first column." |
| 22 | "`--display-name` sets the label shown in pickers." | "`--display-name` sets the label shown in pickers, and defaults to the output filename's stem." |
| 24 | "Run the import. Lungfish writes `Primer Schemes/<name>.lungfishprimers`, copies the files, writes `manifest.json`, and adds both human-readable and machine-readable provenance." | Keep the destination path, which the CLI help corroborates. The exact file set written is settled by reading `launchPrimerSchemeImport`. |
| 26 | "Commands that consume primer schemes take the bundle path: `lungfish bam primer-trim --bundle ... --alignment-track <track-id> --scheme \"Primer Schemes/MyScheme.lungfishprimers\"`" | Add `--name "<track name>"` to the example. `bam primer-trim` requires `--bundle`, `--alignment-track`, `--scheme`, and `--name`. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Seven of the eight built-in schemes, namely the four ARTIC versions, Midnight 1200 bp V1, and both NEB VarSkip schemes, with their primer and amplicon counts | `Sources/LungfishApp/Resources/PrimerSchemes/` and the `manifest.json` in each bundle |
| The `imported` manifest field, distinct from `created` | `PrimerSchemeBundle.swift:15`, `:110` |
| The `attachments` manifest array and its `{path, description}` shape | `PrimerSchemeBundle.swift:16`, `:87-95`, `:112` |
| `PROVENANCE.md` is required, not optional. A bundle without it fails to load | `PrimerSchemeBundle.swift:134`, `case .missingProvenance: return "Bundle is missing PROVENANCE.md."` |
| The four load failures the reader may hit, which are missing manifest, missing BED, missing provenance, and an unparseable manifest | `PrimerSchemeBundle.swift:120-131`, `LoadError` cases `missingManifest`, `missingBED`, `missingProvenance`, `invalidManifest(underlying:)` |
| The manifest decoder tolerates missing `canonical` and `equivalent` flags, defaulting both to false, so a hand-written accession list with neither flag is accepted but resolves through the first-entry fallback | `PrimerSchemeBundle.swift:76-84` and `:50-54` |
| `bam primer-trim --target-reference`, which overrides the `@SQ` SN used to resolve the scheme when a BAM names the reference differently. This is the fix for the chapter's own warning about a scheme trimming zero primers | `cli-help/bam.txt` `==== bam primer-trim ====` |
| The four iVar trim parameters a custom scheme may need tuned, which are `--ivar-min-quality` (default 20), `--ivar-min-length` (default 30), `--ivar-sliding-window` (default 4), `--ivar-primer-offset` | `cli-help/bam.txt` `==== bam primer-trim ====` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | changed | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. The GUI Import Procedure is a five-step click path through a wizard sheet (`ImportCenterViewModel.swift:598`, `:803`) and would benefit from one shot of the Import Center with Primer Scheme selected, and one of the wizard's name and accession fields. A shot of the scheme picker showing all eight built-in schemes would also fix the reader's mental model that only one ships |

Fixture (after Phase 3): Sources/LungfishApp/Resources/PrimerSchemes
Decision: rewrite. Eight bundled schemes listed; import via primers import.

### appendices.md/shared-projects.md

Verdicts: 15 true, 1 false, 6 changed, 4 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 4 | "the commands below invoke the CLI as `lungfish`, matching the command name the help text uses" | "The commands below invoke the CLI as `lungfish`, the name an installed release puts on `PATH`. The help text itself prints `lungfish-cli`, which is the SwiftPM product name." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 7 | "The record contains the tool name, LGE CLI version, project path, user, host, process id, process start time when available, current working directory, creation time, and lock mode." | "The record contains the schema version, the tool name, the LGE CLI version, the project path, the lock mode, the user, the host, a machine identifier, the process id, the process start time when available, the current working directory, and the creation time." |
| 8 | The sample lock JSON block (`appVersion`, `createdAt`, `cwd`, `host`, `mode`, `pid`, `processStartTime`, `projectPath`, `schemaVersion`, `toolName`, `user`) | Add `"machineIdentifier": "<opaque id>",` to the sample, and update `appVersion` to a current value such as `"lungfish-cli 2026.9.13"`. |
| 14 | "Locks from another host (where this machine cannot tell whether the process is still alive) are treated as active unless you pass `--force`." | "A lock from another host, where this machine cannot tell whether the process is still alive, is recorded as unknown rather than active. Unknown locks block writes the same way active ones do, and clearing one takes `--force`." |
| 15 | "`unlock` removes a lock owned by the current process, or a stale local lock owned by the current user." | Keep the sentence. The exact ownership predicate is settled by reading `ProjectLockManager`'s unlock path. |
| 23 | "Unsupported legacy bundles are reported as `unsupported` with action `report-only` or `dry-run-report`. They are not renamed or changed." | Keep the behavioral sentence. Verify or drop the two literal action strings. |
| 24 | "when a migration actually rewrites or wraps scientific data, it must preserve existing provenance sidecars and write new migration provenance describing the workflow or tool name and version, options, inputs, outputs, checksums, file sizes, runtime identity, exit status, stderr when useful, and wall time" | Mark it plainly as the project's provenance requirement for future migrations, not as a description of what the current command writes. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The GUI's project-lock resolution dialog and its three choices. On opening a locked project the reader is offered "Open Read-Only", "Cancel", and, when the lock is stale, corrupted, or unknown, "Recover and Open" | `ProjectLockResolutionDialog.swift:10` (`case readOnly, cancel, recover`), `:63-66` (the three buttons), `:75-76` (the return mapping) |
| The second confirmation before recovery, which warns that recovering a lock while another session is writing can damage the project | `ProjectLockResolutionDialog.swift:84-88`, "Before continuing, ensure this project is closed in other Lungfish versions, in the CLI, and on other computers. Recovering a lock while another session is writing can damage the project. Lungfish will retain an archive of the existing lock for review." |
| Lock recovery archives the displaced lock rather than deleting it, and writes a recovery record beside it | `ProjectLockRecovery.swift:38-41`, `ProjectLockRecoveryResult` carrying `archiveURL` and `recoveryRecordURL`. `:61` `recover(snapshot:reason:)` |
| The fourth lock status, `corrupted`, and what the reader sees when the lock file cannot be parsed | `ProjectLock.swift:12` (`case corrupted`), `:15-27` (`ProjectLockCorruption` with its `lockURL` and `reason`), `ProjectLockResolutionDialog.swift:51-52`, `ProjectLockWarningPresentation.swift:36-38` |
| The exact banner text the reader will see, which names the lock owner, host, pid, and creation time | `ProjectLockWarningPresentation.swift:29-31`, "\(record.toolName) has an \(lockStatus.rawValue) \(record.mode) lock from \(record.user)@\(record.host) pid \(record.pid), created \(createdAt). Project-writing workflows are blocked to protect shared storage." |
| `machineIdentifier`, the field that lets LGE tell a same-machine lock from a remote one even when host names collide | `ProjectLock.swift:43`, `:93` (`ProjectLockMetadata.machineIdentifier`) |
| `project lock --force`, which the chapter mentions only for `unlock` | `cli-help/project.txt` `==== project lock ====`, `--force  Replace an active lock without stale-owner checks` |
| `project migrate --format tsv` as a third output shape | `cli-help/project.txt` `==== project migrate ====`, `--format` values text, json, tsv |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | changed | Front matter has `shots: []` and `planned_shots: []`, and the body carries no markers. The chapter would be clearer with two. Add the project-lock resolution dialog with its three buttons (`ProjectLockResolutionDialog.swift:63-66`) and the read-only banner over an open project (`ProjectLockWarningPresentation.swift:16-31`). Both are GUI surfaces the chapter describes in prose and never shows |

Fixture (after Phase 3): demo project on a shared volume
Decision: rewrite. Lock recovery dialog (Open Read-Only, Cancel, Recover and Open), project lock, unlock, and migrate on the CLI; troubleshooting's contradiction removed.

### appendices.md/tool-versions.md

Verdicts: 9 true, 13 false, 2 changed, 1 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 3 | "micromamba \| 2.0.5-0 \| bundled \| BSD-3-Clause \| `micromamba`" | "micromamba \| 2.9.0-0 \| bundled \| BSD-3-Clause \| `micromamba`" |
| 4 | "Nextflow \| 25.10.4 \| managed \| `nextflow` \| Apache-2.0 \| `nextflow`" | "Nextflow \| 26.04.6 \| managed \| `nextflow` \| Apache-2.0 \| `nextflow`" |
| 5 | "Snakemake \| 9.19.0 \| managed \| `snakemake` \| MIT \| `snakemake`" | "Snakemake \| 9.25.2 \| managed \| `snakemake` \| MIT \| `snakemake`" |
| 6 | "BBTools \| 39.80 \| managed \| `bbtools` \| BSD-3-Clause-LBNL \| `clumpify.sh`, `bbduk.sh`, `bbmerge.sh`, `repair.sh`, `tadpole.sh`, `reformat.sh`, `bbmap.sh`, `mapPacBio.sh`, `java`" | "BBTools \| 40.02 \| managed \| `bbtools` \| BSD-3-Clause-LBNL \| (executables unchanged)" |
| 7 | "Fastp \| 1.3.2 \| managed \| `fastp` \| MIT \| `fastp`" | "fastp \| 1.3.6 \| managed \| `fastp` \| MIT \| `fastp`" |
| 8 | "Deacon \| 0.15.0 \| managed \| `deacon` \| MIT \| `deacon`" | "Deacon \| 0.16.0 \| managed \| `deacon` \| MIT \| `deacon`" |
| 9 | "Samtools \| 1.23.1 \| managed \| `samtools` \| MIT \| `samtools`" | "SAMtools \| 1.24 \| managed \| `samtools` \| MIT \| `samtools`" |
| 10 | "BCFtools \| 1.23.1 \| managed \| `bcftools` \| GPL \| `bcftools`" | "BCFtools \| 1.24 \| managed \| `bcftools` \| GPL \| `bcftools`" |
| 11 | "HTSlib \| 1.23.1 \| managed \| `htslib` \| MIT \| `bgzip`, `tabix`" | "HTSlib \| 1.24 \| managed \| `htslib` \| MIT \| `bgzip`, `tabix`" |
| 14 | "VSEARCH \| 2.30.5 \| managed \| `vsearch` \| GPL-3.0-or-later OR BSD-2-Clause \| `vsearch`" | "VSEARCH \| 2.31.0 \| managed \| `vsearch` \| GPL-3.0-or-later OR BSD-2-Clause \| `vsearch`" |
| 20 | The Managed Tools table has 16 rows. | Add a row: "Trim Galore \| 2.3.0 \| managed \| `trim_galore` \| GPL-3.0-only \| `trim_galore`". It is the default clumping tool option in `import fastq --clumping-tool trim-galore`. |
| 21 | "Tools such as Clair3, WhatsHap, and Freyja are not in the bundled managed-tool lock and do not appear in `lungfish version --tools`." | "Plugin-pack tools such as Clair3, WhatsHap, and Freyja are pinned in the same lock file, under its `packTools` list rather than its always-installed `tools` list. They are installed on demand with `lungfish conda install --pack <name>`, so a fresh machine has none of them until the pack is installed. The Pack Tools table below gives the pinned versions." |
| 24 | The Supported Workflow Pins table has one row. | Add a row: "jhuapl-bio/taxtriage \| v3.3.8 (commit `e10bfebd`) \| Add `--revision <ref>` to `lungfish taxtriage run`". The lock pins the exact commit, not just the release tag. |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 22 | "They are provided by separate plugin packs (for example the GATK, phasing, and wastewater-surveillance packs)" | "They are provided by separate plugin packs. The ten pack IDs are `read-mapping`, `full-length-mhc-genotyping`, `variant-calling`, `gatk-core`, `phasing`, `assembly`, `multiple-sequence-alignment`, `phylogenetics`, `metagenomics`, and `wastewater-surveillance`." |
| 25 | "The numbers and flag values match dependency set 2026.2." (stated in power-user-notes. This appendix never names its dependency set) | Add a line to "What it is": "This appendix reflects dependency set 2026.2 as pinned by release 2026.9.13." |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| Trim Galore 2.3.0, environment `trim_galore`, GPL-3.0-only | Lock `tools[]` entry `id: trim_galore` |
| The whole Pack Tools table. The lock pins 23 pack tools across 10 packs and the appendix names none of their versions | Lock `packTools[]`: read-mapping (minimap2 2.31, bwa-mem2 2.3, bowtie2 2.5.5), full-length-mhc-genotyping (savont 0.6.3, blast 2.16.0), variant-calling (lofreq 2.1.5, ivar 1.4.4, medaka 2.2.2, clair3 2.0.2), gatk-core (gatk4 4.6.2.0), phasing (whatshap 2.3), assembly (spades 4.3.0, megahit 1.2.9, skesa 2.5.1, flye 2.9.6, hifiasm 0.25.0), multiple-sequence-alignment (mafft 7.526), phylogenetics (iqtree 3.1.3), metagenomics (kraken2 2.17.1, bracken 1.0.0, esviritu 1.3.3, ribodetector 0.3.3), wastewater-surveillance (freyja 2.0.3) |
| The whole Databases table. The lock pins 16 databases with their own versions | Lock `databases[]`: nine Kraken2 databases at `20260626` (standard, standard-8, standard-16, pluspf, pluspf-8, pluspf-16, viral, minus-b) plus eupathdb46 at `20230407`. Esviritu-viral-v3 at `v3.2.4`. Ncbi-taxonomy at `live`. Kraken2-special-silva and kraken2-special-greengenes at `kraken2-special-v1`. Human-scrubber at `20260706v2`. Deacon-panhuman at `panhuman-1`. Deacon-ribokmers at `bbmap-ribokmers-k31w15` |
| The two managed data sets, which are neither tools nor databases in the usual sense | Lock `managedData[]`: `deacon-panhuman` ("Human Read Removal Data") and `deacon-ribokmers` ("Ribosomal RNA Removal Data") |
| `lungfish tools update --plan` as the way to see what this machine is missing against the pinned set, and its exit code 10 for "work is pending" | `cli-help/tools.txt` `==== tools update ====` |
| The `retiredEnvironments` list, which is currently empty but is the lock's record of environments removed from the pinned set | Lock top-level key `retiredEnvironments: []` |
| `dependencySetDate`, the date the pinned set was cut | Lock top-level key `dependencySetDate` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | not applicable | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. A version table is text, and a screenshot of it would go stale faster than the table itself |

Fixture (after Phase 3): third-party-tools-lock.json
Decision: rewrite as a generated table from the lock (dependency set 2026.2), including Clair3, WhatsHap, Freyja, and micromamba 2.9.0-0.

### appendices.md/troubleshooting.md

Verdicts: 16 true, 3 false, 12 changed, 5 unverifiable.

#### False claims

| # | Claim | Corrected wording |
|---|---|---|
| 9 | "If a classifier asks for a database that the Plugin Manager does not list, the database pack is separate from the tool pack. EsViritu, TaxTriage, and Kraken2 each have their own database pack, installed the same way: `lungfish conda install --pack <database-name>`." | "Databases are managed separately from tool packs. Use `lungfish conda db list` to see what is available and installed, `lungfish conda db recommend` to see what suits this machine, and `lungfish conda db download <id>` to fetch one. EsViritu has its own shortcut, `lungfish esviritu download-db`, and `lungfish esviritu db-status` reports whether it is installed." |
| 29 | "For team workflows, the right answer is currently: one project per researcher per analysis, on local disk. Multi-user shared projects are not yet supported." | "For team workflows, coordinate with project locks. See [Shared Projects](shared-projects.md), which covers `lungfish project lock`, the read-only banner the app shows when someone else holds a lock, and how to recover a stale one." |
| 33 | "For complex failures that involve multiple operations, the project's `.lungfish/logs/cli.log` carries the full transcript." | "Failed operations write a report to `~/Library/Logs/<app name>/Operations/Failures` as the failure happens, so you can read it after quitting the app. The store keeps the most recent 50 reports and prunes older ones on each write. Attach the relevant report to the bug." |

#### Changed claims

| # | Claim | Corrected wording |
|---|---|---|
| 8 | "A firewall or proxy that blocks bioconda will hang the solver indefinitely; on a corporate or institutional network, ask the network team about an HTTPS proxy and set `HTTPS_PROXY` in the shell that runs Lungfish." | Keep the advice, and say plainly that `HTTPS_PROXY` is read by micromamba and the underlying network stack, not by LGE itself. |
| 13 | "Provenance sidecars record retry count and backoff timing, and only record whether an API key was provided." | Keep the redaction claim. The recorded retry fields are settled by reading the fetch provenance writer. |
| 14 | "the operation row's provenance disclosure shows `Falling back to SRA Toolkit (prefetch + fasterq-dump)`" | Keep the behavior and verify or drop the verbatim message. |
| 15 | "Nucleotide accessions need the version suffix (`MN908947.3`, not `MN908947`)." | "Give the version suffix when you want a specific record version. NCBI resolves an unversioned accession to its current version, which can change under you." |
| 16 | "Assembly accessions go through `lungfish fetch genome`, not `lungfish fetch ncbi`." | "Assembly accessions go through `lungfish fetch genome`. That command also accepts a nucleotide accession, and it warns why the distinction matters: asking the assembly database for a nucleotide accession returns the linked assembly instead, under a different sequence name." |
| 22 | "If a project opens empty, the project's `manifest.json` may be corrupted." | Add a lock row to the Project and file integrity table before the manifest row. See the Missing table below. |
| 24 | "The Standard database needs roughly 50 GB. The PlusPF database needs roughly 80 GB. On a 16 GB MacBook, only the Viral database (about 500 MB) fits." | "The full Standard and PlusPF databases need far more RAM than a laptop has. Both ship in capped variants, `Standard-8` and `Standard-16`, `PlusPF-8` and `PlusPF-16`, whose numbers are their approximate memory ceilings in gigabytes. On a 16 GB machine, use `Standard-8` or the Viral database. Run `lungfish conda db recommend` to see what this machine can handle." |
| 26 | "For variant calling on amplicon data, the chapter on iVar mentions that Lungfish raises the mpileup depth cap to 600,000." | Verify the 600,000 figure once, in power-user-notes.md, and let this chapter cite it. |
| 28 | "NFS-mounted lab storage works but file locking can fail on some configurations, leading to \"could not acquire lock on manifest.json\" errors." | "On network storage, lock failures surface against `.lungfish/project.lock` for a project or `<conda-root>/.install.lock` for a plugin install, not against `manifest.json`. A reported locking failure is often a metadata-sidecar problem rather than a real lock problem, so check for stray dot-underscore files before changing mount options." |
| 32 | "The plugin pack versions (`lungfish conda list`)" | "The installed tool versions (`lungfish version --tools` for the managed set, `lungfish conda list` for what is inside each environment, and `lungfish conda envs` for which environments exist)." |
| 35 | "The Lungfish app version (Lungfish menu > About Lungfish)" | "The app version (the Lungfish Genome Explorer menu, then About Lungfish Genome Explorer, or `lungfish version` from a terminal)." |
| 36 | "File bug reports through the GitHub repository linked from the Lungfish Help menu" | Verify a Help-menu GitHub item exists. If it does not, point the reader at the repository URL that `lungfish --help` prints. |

#### Missing

| Feature or setting | Evidence it exists |
|---|---|
| The whole project-lock failure mode, which is the most likely reason a reader cannot write to a project. The window title gains " (Read Only)", a banner explains who holds the lock, and write operations are blocked | `AppDelegate.swift:673`. `ProjectLockWarningPresentation.swift:16-31`. `ProjectWriteGatePresenter.swift:22`. `ProjectLockResolutionDialog.swift:44-66` |
| The conda mutation lock and its two messages, which a reader running two installs at once will hit. They read "waiting for conda lock held by pid <n>" and "conda root is read-only; reinstall as the admin user" | `CondaRootMutationLock.swift:95`, `:12` |
| `lungfish debug env --check-tools` and `lungfish debug env --tool <name>`, the first diagnostic for any missing-tool error | `cli-help/debug.txt` `==== debug env ====` |
| `lungfish debug container --pull-test`, the first diagnostic for any container-runtime failure, which is what a Nextflow-backed workflow depends on | `cli-help/debug.txt` `==== debug container ====` |
| `lungfish debug resource-smoke`, which verifies packaged runtime resources without launching the app UI | `cli-help/debug.txt` `==== debug ====` |
| `lungfish debug workflow-log`, a log parser for workflow failures, and `lungfish debug fastq-ingest` | `cli-help/debug.txt` `==== debug ====` |
| `lungfish tools update --plan`, which names every install, reinstall, removal, and database update this machine is missing against the pinned set, and exits 10 when work is pending | `cli-help/tools.txt` `==== tools update ====` |
| `lungfish conda db recommend`, which answers "which Kraken2 database fits this machine" directly, and `conda db list` and `conda db info` for what is installed and current | `cli-help/conda.txt` `==== conda db ====` |
| `lungfish esviritu db-status`, the EsViritu-specific database check | `cli-help/esviritu.txt` `==== esviritu ====` |
| `lungfish taxtriage check-prerequisites`, which verifies Nextflow and the container runtime before a TaxTriage run | `cli-help/taxtriage.txt` `==== taxtriage ====` |
| `lungfish analyze validate <files>... [--strict]`, the direct answer to "is this file malformed" | `cli-help/analyze.txt` `==== analyze validate ====` |
| `lungfish bundle validate <bundle>`, the direct answer to "is this bundle intact" | `cli-help/bundle.txt` `==== bundle ====` |
| `lungfish provenance verify`, which detects a sidecar or report that changed after signing | `cli-help/provenance.txt` `==== provenance verify ====` |
| The VCFv3 rejection and its exact remedy, which is a real import failure with a precise fix | `VCFReader.swift:490`, `:826`, "Convert to VCF 4.x with bcftools convert or vcf-convert (vcftools) before importing" |
| The `convert` in-place refusal. Passing the same path as input and output, or a symlink to it, is rejected | `cli-help/convert.txt` `==== convert ====`, "Input and output must be different files; in-place, symlink and hard-link aliases are rejected." |
| BigWig and BigBed are detect-only. A reader who imports one and sees nothing render needs to know the reader is unavailable in process, not that the file is broken | `FormatRegistry+BuiltInDescriptors.swift:192-195`, `:208-211` |
| The `fetch genome` accession trap, which the help itself calls out. Asking the assembly database for a nucleotide accession returns the linked assembly under a different sequence name | `cli-help/fetch.txt` `==== fetch genome ====` |
| `--format json` on any command, which turns an opaque failure into a parseable one | `cli-help/_root.txt` `OPTIONS:` |

#### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
| (none) | changed | Front matter has `shots: []`, no `planned_shots` key, and the body carries no markers. Two shots would earn their place. One is the expanded Operations Panel row the "Collecting diagnostics" section tells the reader to gather, and the project-lock dialog, which is the failure mode the chapter is currently missing entirely |

Fixture (after Phase 3): none
Decision: rewrite. Failure reports live under ~/Library/Logs/<app>/Operations/Failures; multi-user projects are supported; every path and command re-verified.

## Part A totals

| Chapter | True | False | Changed | Unverifiable | Missing rows | Screenshot rows |
|---|---|---|---|---|---|---|
| 01-foundations.md/01-what-is-a-genome.md | 15 | 2 | 2 | 0 | 7 | 4 |
| 01-foundations.md/02-sequencing-reads.md | 8 | 1 | 6 | 0 | 7 | 5 |
| 01-foundations.md/03-amplicon-vs-shotgun.md | 13 | 1 | 5 | 0 | 7 | 4 |
| 01-foundations.md/04-alignment-files.md | 12 | 0 | 4 | 0 | 7 | 5 |
| 01-foundations.md/05-variants-and-vcf.md | 11 | 9 | 5 | 0 | 11 | 4 |
| 01-foundations.md/06-the-lungfish-project.md | 32 | 8 | 7 | 0 | 16 | 8 |
| 01-foundations.md/07-plugin-packs.md | 27 | 12 | 7 | 0 | 15 | 4 |
| 01-foundations.md/08-provenance-and-reproducibility.md | 14 | 7 | 9 | 0 | 13 | 4 |
| 02-sequences.md/01-importing-and-viewing.md | 39 | 9 | 10 | 7 | 12 | 6 |
| 02-sequences.md/02-downloading-from-ncbi.md | 37 | 2 | 4 | 4 | 8 | 5 |
| 02-sequences.md/03-extracting-and-comparing.md | 26 | 8 | 9 | 4 | 8 | 2 |
| 02-sequences.md/04-msa-and-trees.md | 60 | 4 | 13 | 4 | 20 | 8 |
| 03-reads.md/01-importing-fastq.md | 25 | 11 | 7 | 5 | 9 | 5 |
| 03-reads.md/02-downloading-from-sra.md | 17 | 4 | 9 | 6 | 7 | 3 |
| 03-reads.md/03-quality-control.md | 6 | 12 | 6 | 1 | 8 | 3 |
| 03-reads.md/04-trimming-and-filtering.md | 18 | 9 | 7 | 1 | 7 | 3 |
| 03-reads.md/05-decontamination.md | 23 | 4 | 5 | 3 | 11 | 4 |
| 03-reads.md/06-subsetting-and-extraction.md | 18 | 6 | 3 | 2 | 7 | 2 |
| 03-reads.md/07-ont-runs.md | 26 | 10 | 3 | 3 | 11 | 4 |
| 03-reads.md/08-read-processing.md | 14 | 3 | 7 | 3 | 7 | 2 |
| 04-alignments.md/01-mapping-reads-to-a-reference.md | 33 | 7 | 9 | 3 | 13 | 2 |
| 04-alignments.md/02-reading-an-alignment.md | 18 | 13 | 6 | 2 | 17 | 3 |
| 04-alignments.md/03-primer-trimming.md | 18 | 4 | 9 | 3 | 10 | 2 |
| 04-alignments.md/04-alignment-quality.md | 13 | 4 | 9 | 3 | 13 | 4 |
| 04-alignments.md/05-viral-recon-wizard.md | 37 | 2 | 8 | 1 | 11 | 2 |
| 05-variants.md/01-calling-variants-from-amplicons.md | 40 | 9 | 7 | 5 | 12 | 8 |
| 05-variants.md/02-reading-the-variant-browser.md | 23 | 12 | 17 | 2 | 11 | 5 |
| 05-variants.md/03-cross-caller-comparison.md | 19 | 7 | 7 | 0 | 7 | 5 |
| 05-variants.md/04-nanopore-variant-calling.md | 20 | 7 | 2 | 0 | 8 | 3 |
| 05-variants.md/05-consensus-and-lineage.md | 18 | 1 | 6 | 2 | 11 | 4 |
| 05-variants.md/06-importing-existing-vcfs.md | 22 | 8 | 9 | 1 | 11 | 3 |
| 06-classification.md/01-what-is-classification.md | 16 | 4 | 3 | 0 | 5 | 5 |
| 06-classification.md/02-running-kraken2.md | 47 | 6 | 8 | 2 | 12 | 7 |
| 06-classification.md/03-running-esviritu.md | 22 | 7 | 3 | 5 | 8 | 5 |
| 06-classification.md/04-running-taxtriage.md | 22 | 7 | 3 | 3 | 9 | 6 |
| 06-classification.md/05-running-nao-mgs.md | 20 | 1 | 2 | 0 | 6 | 3 |
| 06-classification.md/06-blast-verification.md | 19 | 0 | 2 | 1 | 5 | 2 |
| 06-classification.md/07-running-freyja.md | 12 | 0 | 1 | 3 | 3 | 1 |
| 06-classification.md/08-importing-cz-id-results.md | 14 | 0 | 1 | 2 | 5 | 1 |
| 06-classification.md/09-novel-virus-detection.md | 23 | 1 | 0 | 2 | 5 | 3 |
| 06-classification.md/10-twelve-s-metabarcoding.md | 28 | 1 | 2 | 2 | 10 | 6 |
| 06-human-germline-variants.md/01-haplotype-caller.md | 33 | 1 | 9 | 0 | 16 | 1 |
| 06-human-germline-variants.md/02-joint-genotyping.md | 13 | 0 | 6 | 0 | 7 | 1 |
| 06-human-germline-variants.md/03-filtering-selecting-and-metrics.md | 16 | 0 | 6 | 0 | 10 | 1 |
| 06-human-germline-variants.md/04-reference-packs.md | 10 | 3 | 10 | 0 | 11 | 1 |
| 07-assembly.md/01-when-to-assemble.md | 13 | 5 | 6 | 0 | 11 | 4 |
| 07-assembly.md/02-running-spades.md | 27 | 6 | 8 | 0 | 15 | 6 |
| 07-assembly.md/03-running-flye-or-hifiasm.md | 14 | 1 | 9 | 0 | 9 | 6 |
| 07-assembly.md/04-extracting-contigs.md | 18 | 7 | 8 | 0 | 9 | 4 |
| 08-workflows.md/01-the-workflow-builder.md | 57 | 18 | 22 | 0 | 25 | 5 |
| 08-workflows.md/02-exporting-as-nextflow-or-snakemake.md | 37 | 7 | 9 | 3 | 12 | 4 |
| 08-workflows.md/03-running-external-workflows.md | 45 | 2 | 9 | 1 | 17 | 3 |
| 09-genotyping.md/01-what-is-mhc-genotyping.md | 10 | 5 | 6 | 0 | 8 | 4 |
| 09-genotyping.md/02-running-genotyping.md | 27 | 6 | 9 | 1 | 15 | 8 |
| 09-genotyping.md/03-reading-the-genotype-comparison.md | 16 | 10 | 6 | 0 | 15 | 10 |
| 09-genotyping.md/04-haplotype-definitions-and-export.md | 37 | 3 | 4 | 1 | 15 | 8 |
| appendices.md/cli-reference.md | 86 | 25 | 39 | 1 | 29 | 1 |
| appendices.md/06-running-in-ci.md | 11 | 2 | 6 | 1 | 12 | 1 |
| appendices.md/ai-assistant.md | 22 | 0 | 4 | 0 | 10 | 4 |
| appendices.md/bibliography.md | 23 | 0 | 9 | 2 | 15 | 1 |
| appendices.md/file-formats.md | 15 | 3 | 11 | 5 | 14 | 1 |
| appendices.md/keyboard-shortcuts.md | 35 | 2 | 10 | 2 | 14 | 1 |
| appendices.md/power-user-notes.md | 10 | 4 | 22 | 10 | 12 | 1 |
| appendices.md/primer-schemes.md | 15 | 2 | 9 | 0 | 8 | 1 |
| appendices.md/shared-projects.md | 15 | 1 | 6 | 4 | 8 | 1 |
| appendices.md/tool-versions.md | 9 | 13 | 2 | 1 | 7 | 1 |
| appendices.md/troubleshooting.md | 16 | 3 | 12 | 5 | 18 | 1 |
| **Total** | 1555 | 352 | 499 | 122 | 732 | 245 |

## Part B: chapter roster after the campaign

Registry ids for groups not yet extracted are the ids Task 2.3 must use: `classify.kraken2`, `classify.esviritu`, `classify.taxtriage`, `classify.blast-verify`, `classify.extract-reads-by-taxon`, `classify.taxonomy-browser`, `classify.install-database`, `classify.twelve-s-match`, `assemble.spades`, `assemble.megahit`, `assemble.skesa`, `assemble.flye`, `assemble.hifiasm`, `assemble.extract-contigs`, `msa.mafft`, `msa.export`, `tree.iqtree`, `tree.reroot`, `tree.extract-subtree`, `genotype.miseq-amplicon`, `genotype.full-length-ont`, `genotype.export`, `workflow.viral-recon`, `workflow.freyja-demix`, `workflow.library-run`, `workflow.builder`, `provenance.export`.

Status column values: queued, authored, reviewed, edited, gated, committed.

| # | chapter_id | Title | parameters_refs | Fixture | Existing or new | Status |
|---|---|---|---|---|---|---|
| 1 | 01-foundations/01-what-is-a-genome | What Is a Genome | [import.reference] | hbb-gene | existing | done |
| 2 | 01-foundations/02-sequencing-reads | Sequencing Reads | [] | hg002-chr20, hg002-long-reads | existing | done |
| 3 | 01-foundations/03-amplicon-vs-shotgun | Amplicons and Shotgun Sequencing | [] | hg002-chr20, Williams project | existing | done |
| 4 | 01-foundations/04-alignment-files | Alignment Files | [] | hg002-chr20 | existing | done |
| 5 | 01-foundations/05-variants-and-vcf | Variants and VCF Files | [] | hg002-chr20 | existing | done |
| 6 | 01-foundations/06-the-lungfish-project | The Lungfish Genome Explorer Project | [] | demo project | existing | done |
| 7 | 01-foundations/07-plugin-packs | Plugin Packs | [classify.install-database] | none | existing | done |
| 8 | 01-foundations/08-provenance-and-reproducibility | Provenance and Reproducibility | [provenance.export] | demo project | existing | done |
| 9 | 02-sequences/01-importing-and-viewing | Importing and Viewing | [import.reference, import.annotation-track] | hbb-gene | existing | done |
| 10 | 02-sequences/02-downloading-from-ncbi | Downloading from NCBI | [fetch.ncbi, fetch.pathoplexus] | live fetch | existing | done |
| 11 | 02-sequences/03-extracting-and-comparing | Extracting and Comparing | [sequence.find-orfs, sequence.extract-region] | hbb-gene | existing | done |
| 12 | 02-sequences/04-aligning-sequences | Aligning Sequences | [msa.mafft, msa.view, msa.export, import.msa] | primate-mito | new (split from 04-msa-and-trees) | done |
| 13 | 02-sequences/05-building-trees | Building Trees | [tree.iqtree, tree.reroot, tree.extract-subtree, import.tree] | primate-mito | new (split from 04-msa-and-trees) | done |
| 14 | 03-reads/01-importing-fastq | Importing FASTQ | [import.fastq, import.fastq-sample-sheet] | hg002-chr20 | existing | done |
| 15 | 03-reads/02-downloading-from-sra | Downloading from SRA | [fetch.sra] | live SRA | existing | done |
| 16 | 03-reads/03-quality-control | Quality Control | [fastq.refresh-qc-summary] | hg002-chr20 | existing | done |
| 17 | 03-reads/04-trimming-and-filtering | Trimming and Filtering | [fastq.fastp-trim, fastq.quality-trim, fastq.adapter-removal, fastq.primer-trimming, fastq.trim-fixed-bases, fastq.filter-by-read-length] | hg002-chr20 | existing | done |
| 18 | 03-reads/05-decontamination | Decontamination | [fastq.remove-human-reads, fastq.remove-ribosomal-rna, fastq.remove-contaminants, fastq.low-complexity-filter, fastq.remove-duplicates] | hg002-chr20 | existing | done |
| 19 | 03-reads/06-subsetting-and-extraction | Subsetting and Extraction | [fastq.subsample-by-proportion, fastq.subsample-by-count, fastq.extract-reads-by-id, fastq.extract-reads-by-motif, fastq.select-reads-by-sequence] | hg002-chr20 | existing | done |
| 20 | 03-reads/07-ont-runs | ONT Runs | [import.ont-run, fastq.demultiplex-barcodes, fastq.ont-fluidigm-sample-split] | hg002-long-reads | existing | done |
| 21 | 03-reads/08-read-processing | Read Processing | [fastq.merge-overlapping-pairs, fastq.repair-paired-end-files, fastq.reverse-complement, fastq.translate, fastq.orient-reads, fastq.correct-sequencing-errors] | hg002-chr20 | existing (add to nav) | done |
| 22 | 04-alignments/01-mapping-reads-to-a-reference | Mapping Reads to a Reference | [map.minimap2, map.bwa-mem2, map.bowtie2, map.bbmap, import.bam] | hg002-chr20 | existing | done |
| 23 | 04-alignments/02-reading-an-alignment | Reading an Alignment | [bam.read-display, bam.extract-reads-in-region] | hg002-chr20 | existing | done |
| 24 | 04-alignments/03-primer-trimming | Primer Trimming | [bam.primer-trim] | sarscov2-srr36291587 | existing | done |
| 25 | 04-alignments/04-alignment-quality | Alignment Quality | [bam.mark-duplicates, bam.filter] | hg002-chr20 | existing | done |
| 26 | 04-alignments/05-viral-recon-wizard | Viral Recon Wizard | [workflow.viral-recon] | sarscov2-srr36291587 | existing | done |
| 27 | 05-variants/01-calling-variants-from-amplicons | Calling Variants | [variants.call-lofreq, variants.call-ivar, variants.call-bcftools] | hg002-chr20 | existing (retitled) | done |
| 28 | 05-variants/02-reading-the-variant-browser | Reading the Variants Table | [variants.filter-table, variants.query] | hg002-chr20 | existing (retitled; absorbs the comparison paragraph) | done |
| 29 | 05-variants/04-nanopore-variant-calling | Nanopore Variant Calling | [variants.call-medaka, variants.call-clair3] | hg002-long-reads | existing | done |
| 30 | 05-variants/05-consensus-and-lineage | Extracting a Consensus Sequence | [bam.extract-consensus] | hg002-chr20 | existing (retitled) | done |
| 31 | 05-variants/06-importing-existing-vcfs | Importing Existing VCFs | [import.vcf] | hg002-chr20 | existing | done |
| 32 | 06-classification/01-what-is-classification | What Is Classification | [] | sarscov2-srr36291587 | existing | done |
| 33 | 06-classification/02-running-kraken2 | Running Kraken 2 | [classify.kraken2, classify.install-database, classify.taxonomy-browser, classify.extract-reads-by-taxon] | sarscov2-srr36291587 | existing | done |
| 34 | 06-classification/03-running-esviritu | Running EsViritu | [classify.esviritu] | sarscov2-srr36291587 | existing | done |
| 35 | 06-classification/04-running-taxtriage | Running TaxTriage | [classify.taxtriage] | sarscov2-srr36291587 | existing | done |
| 36 | 06-classification/05-running-nao-mgs | Importing NAO-MGS Results | [import.nao-mgs] | NAO-MGS sample (open item) | existing (retitled) | done |
| 37 | 06-classification/06-blast-verification | BLAST Verification | [classify.blast-verify] | sarscov2-srr36291587 | existing | done |
| 38 | 06-classification/07-running-freyja | Running Freyja | [workflow.freyja-demix] | sarscov2-srr36291587 | existing | done |
| 39 | 06-classification/08-importing-cz-id-results | Importing CZ ID Results | [import.cz-id] | CZ ID export (open item) | existing | done |
| 40 | 06-classification/09-novel-virus-detection | Novel Virus Diagnostics | [import.nvd] | nvd-demo | existing | done |
| 41 | 06-classification/10-twelve-s-metabarcoding | 12S Amplicon Metabarcoding | [classify.twelve-s-match] | primate-12s | existing | done |
| 42 | 06-human-germline-variants/01-haplotype-caller | HaplotypeCaller | [variants.call-gatk-haplotypecaller, variants.call-gatk-whatshap-phased] | hg002-chr20 | existing (nav label fixed) | queued |
| 43 | 06-human-germline-variants/02-joint-genotyping | Joint Genotyping | [variants.gatk-plans] | hg002-chr20 | existing | queued |
| 44 | 06-human-germline-variants/03-filtering-selecting-and-metrics | Filtering, Selecting, and Metrics | [variants.gatk-plans] | hg002-chr20 | existing | queued |
| 45 | 06-human-germline-variants/04-reference-packs | Reference Files for GATK | [] | hg002-chr20 | existing (nav label fixed) | queued |
| 46 | 07-assembly/01-when-to-assemble | When to Assemble | [] | human-mito | existing | queued |
| 47 | 07-assembly/02-running-spades | Running SPAdes | [assemble.spades, assemble.megahit, assemble.skesa] | human-mito | existing | queued |
| 48 | 07-assembly/03-running-flye-or-hifiasm | Running Flye or hifiasm | [assemble.flye, assemble.hifiasm] | hg002-long-reads | existing | queued |
| 49 | 07-assembly/04-extracting-contigs | Extracting Contigs | [assemble.extract-contigs] | human-mito | existing | queued |
| 50 | 08-workflows/01-the-workflow-builder | The Workflow Builder | [workflow.builder] | demo project | existing | queued |
| 51 | 08-workflows/02-exporting-as-nextflow-or-snakemake | Exporting as Nextflow or Snakemake | [provenance.export] | demo project | existing | queued |
| 52 | 08-workflows/03-running-external-workflows | Running External Workflows | [workflow.library-run] | hello-world packages | existing (add to nav) | queued |
| 53 | 09-genotyping/01-what-is-mhc-genotyping | What Is MHC Genotyping | [] | Williams project | existing (add to nav) | queued |
| 54 | 09-genotyping/02-running-genotyping | Running Genotyping | [genotype.miseq-amplicon, genotype.full-length-ont] | Williams project | existing (add to nav) | queued |
| 55 | 09-genotyping/03-reading-the-genotype-comparison | Reading the Genotype Comparison | [] | Williams project | existing (add to nav) | queued |
| 56 | 09-genotyping/04-haplotype-definitions-and-export | Exporting Genotypes | [genotype.export] | Williams project | existing (retitled, add to nav) | queued |
| 57 | appendices/cli-reference | CLI Reference | [] | cli-help dumps | existing | queued |
| 58 | appendices/06-running-in-ci | Running in CI | [] | none | existing | queued |
| 59 | appendices/ai-assistant | AI Assistant | [] | demo project | existing (add to nav) | queued |
| 60 | appendices/bibliography | Bibliography | [] | none | existing | queued |
| 61 | appendices/file-formats | File Formats | [] | none | existing | queued |
| 62 | appendices/keyboard-shortcuts | Keyboard Shortcuts | [] | none | existing | queued |
| 63 | appendices/power-user-notes | Power User Notes | [] | none | existing | queued |
| 64 | appendices/primer-schemes | Primer Schemes | [] | bundled schemes | existing | queued |
| 65 | appendices/shared-projects | Shared Projects and Bundle Migration | [] | demo project | existing | queued |
| 66 | appendices/tool-versions | Tool Versions | [] | tool lock | existing (generated) | queued |
| 67 | appendices/troubleshooting | Troubleshooting | [] | none | existing | queued |

Removed: `05-variants/03-cross-caller-comparison` (no feature behind it; nav entry removed, help-ids retargeted to chapter 28). Removed by split: `02-sequences/04-msa-and-trees` (replaced by chapters 12 and 13; nav and help-ids updated).

Nav changes: add chapters 21, 52, 53 to 56, and 59; replace the MSA entry with 12 and 13; remove the cross-caller entry; relabel the Human Germline part "Human Germline Variants (Experimental)" and its first and fourth entries; retitle 27, 28, 30, 36, 56.

Deliberately undocumented (with reason): per-node Operations Panel rows (test-only), the standalone VCF dataset view (dead code), the VSP2 builder template (unreachable), the cross-sample TaxTriage SNP table (internal, test-only), pbAA and Savont advanced run modes beyond the visible Run Mode row.

Fixture additions beyond the plan (Phase 3): `hg002-long-reads/` (ONT and HiFi chrM reads from GIAB, laid out once as an ONT run folder) for chapters 2, 20, 29, 48. Open items for the user: a public 12S metabarcoding run, a NAO-MGS `virus_hits_final.tsv.gz` sample, and a CZ ID taxon report export.
