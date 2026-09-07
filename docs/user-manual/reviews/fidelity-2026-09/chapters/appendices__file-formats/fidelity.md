# Fidelity review, appendices/file-formats.md

Campaign: 2026-09 fidelity pass. Roster row 61. Target build: Preview 2026.9.13.
Reviewer: manual-fidelity-reviewer. Date: 2026-09-07.

Arbiters used. `Sources/LungfishIO/Registry/FormatRegistry+BuiltInDescriptors.swift`
and `FormatIdentifier.swift` for the registry, the bundle manifest code under
`Sources/LungfishIO/Bundles/` and `Sources/LungfishWorkflow/`, the demo project
at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and the Williams project at
`~/Desktop/lge-docs/32566_MS267_Williams1.lungfish` (both read only), live runs
of `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
samtools 1.22 and bcftools from `/opt/homebrew/bin`, CONSISTENCY.md, the DRIFT
section at line 3269, and the committed chapters in Parts II, III, VI, VII, and
VIII.

## Claim table

### The format registry

Every one of the 25 descriptor rows was checked field by field against
`FormatRegistry+BuiltInDescriptors.swift`. The name, the extension list, the
`uiCategory`, `canRead`, and `canWrite` all match for every row. Rather than
repeat 25 identical verdicts, the rows are grouped, and only rows needing
comment are broken out.

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| The 25-row registry table, every name, extension list, category, read flag, and write flag | true | `FormatRegistry+BuiltInDescriptors.swift:18-418`. Checked descriptor by descriptor. FASTA's seven extensions at `:22`, GenBank's four at `:50`, GTF `canWrite: false` at `:85`, BED `canWrite: true` at `:99`, BCF `canWrite: false` at `:130`, BAM `canWrite: false` at `:166`, CRAM `canWrite: false` at `:183`, bedGraph read and write at `:230-231`, the five document rows at `:270-349` and the four image rows at `:354-418` all false and false | none |
| "The five categories are sequence, annotation, variant, alignment, and coverage, plus two more for the documents and images" | true | `FormatDescriptor.swift:186-209` defines nine cases. The chapter's own table carries an Index category row for `.fai` and `.bai`, so the sentence undercounts by naming five plus two where the enum has nine | Optional tightening. The sentence omits `index`, which the chapter's own table then uses. Consider "The categories are sequence, annotation, variant, alignment, coverage, and index, plus two more for documents and images." |
| "Two entries in the registry are detection only ... BigWig or a BigBed" | true | `:194` and `:210` both carry the string "detection only; in-process reader unavailable", and both set `canRead: false` | none |
| "Three more formats have registry identifiers without a full descriptor entry ... EMBL, 2bit, CSI" | **false** | `FormatIdentifier.swift` defines a **fourth**, `tbi` at `:246-250`, alongside `embl` `:126`, `twoBit` `:133`, and `csi` `:241`. None of the four has a descriptor in `createBuiltInDescriptors()`. The chapter names `.vcf.gz.tbi` twice in the variant section without saying it is a registry identifier | "Four more formats have registry identifiers without a full descriptor entry ... They are EMBL (`.embl`), the European counterpart to GenBank, 2bit (`.2bit`), a packed binary sequence format from the UCSC genome browser, and the two index formats CSI (`.csi`) and tabix (`.tbi`), both described under the variant section below." |
| "The `import fasta` command accepts an EMBL file" | true | Live run. `lungfish-cli import fasta --help` argument reads "(.fa/.fasta/.gb/.embl, optionally .gz/.bgz/.bz2/.xz/.zst)" | none |
| "A format LGE can write is one an internal LGE routine can produce directly ... a format can be central to your work and still carry a write flag of false" | true | Verified the caveat is needed and correct. `BEDWriter` exists at `Formats/BED/BEDReader.swift:357` with a static `write(_:to:columns:)` at `:444`, and `GFF3Writer` at `Formats/GFF/GFF3Reader.swift:476`, neither in a file named `*Writer.swift`. No SAM or VCF writer class exists anywhere in `Sources/LungfishIO/` despite both carrying `canWrite: true`, which is exactly what the paragraph warns about | none |

### Standard formats and the quoted samples

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| The FASTA sample, three lines from the `hg002-chr20` fixture | true | `head -3 docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta` reproduces all three lines verbatim | Minor. The block says "truncated to fit the page" but the sequence lines are the file's real 50-base width and are not truncated. Drop the truncation note or say the record continues below. |
| The FAI sample and its five column meanings | true | `cat GRCh38.chr20.10.0-10.5Mb.fasta.fai` gives `chr20_10.0-10.5Mb	500001	19	50	51` exactly. Column meanings match the samtools faidx specification | none |
| The FASTQ sample, four lines from `HG002.chr20.10.0-10.5Mb_R1.fastq.gz` | true | `gzcat ... | head -4` reproduces the header, sequence, `+`, and quality lines verbatim through the stated truncation | none |
| "LGE reads GenBank on import and converts each record into a FASTA plus a GFF3 annotation track, keeping the original record in a small database inside the bundle" | true | The HBB bundle holds `genome/sequence.fa.gz`, `annotations/imported_annotations.gff3`, and `metadata/genbank_records.sqlite`. The path constant is at `GenotypeReferenceRecordStoreSnapshot.swift:32` and `NativeBundleBuilder.swift:751` | none |
| "recognizes five compression suffixes, which are `.gz`, `.bgz`, `.bz2`, `.xz`, and `.zst`" | true | Live run of `import fasta --help` | none |
| The GFF3 sample, "the first three lines of the annotation track ... read from `HBB.lungfishref/annotations/imported_annotations.gff3`" | **false** | `head -3` on that file gives a `##gff-version 3` line then two feature lines whose attribute columns both begin `_lf_raw_genbank_location=52070..53062;db_xref=GeneID:103344929,HGNC:HGNC:49033,MIM:616308;gene=BGLT3;...`. The chapter's second feature line begins `gene=BGLT3;product=beta%20globin...`, which stitches together non-adjacent fragments of the real line with no ellipsis. Every substring shown does exist in the file, and the two points the paragraph makes (percent-encoding, `_lf_raw_genbank_location`) are both sound | Show the real lines with an explicit ellipsis where the attribute column is cut, for example `NG_000007	.	ncRNA	52070	53062	.	+	.	_lf_raw_genbank_location=52070..53062;...;gene=BGLT3;gene_synonym=BGL3%3B%20LINC01083%3B%20lncRNA-BGL3;...;product=beta%20globin%20locus%20transcript%203;transcript_id=NR_121648.1`, or label the block as abridged. |
| "the registry marks GTF as read only because LGE never writes one back out" | true | `:85` `canWrite: false`, and `Formats/GFF/GTFReader.swift` holds no writer class, unlike `GFF3Reader.swift` | none |
| The primer BED sample, two rows of `QIASeqDIRECT-SARS2/primers.bed` | true | `head -2` reproduces both rows verbatim | none |
| The zero-based and one-based coordinate paragraph | true | Standard format specifications. BED and bedGraph half-open zero-based, GFF3, GTF, and VCF one-based inclusive | none |
| "the `import bam` command accepts a BAM or a CRAM" | true | Live run. `import bam --help` overview reads "Import a BAM or CRAM alignment file" | none |
| "The mapping pipeline runs any tool that emits SAM through `samtools sort` and `samtools index`, then deletes the intermediate text file" | true | Matches DRIFT row 7's own corrected wording and the project's standing rule, and the demo project's `alignments/mapped/` holds only a sorted BAM plus `.bai` with no SAM | none |
| "CSI is the alternative index for a reference sequence longer than the roughly 512-megabase limit a `.bai` can address" | true | Standard htslib limit. CSI handling is present at `FileTypeUtility.swift:55` and `MarkdupService.swift:77-81` | none |
| The two samtools commands and their quoted output | true | Reran both. `samtools idxstats` gives `chr20_10.0-10.5Mb	500001	90990	213` and `*	0	0	0`. `samtools flagstat | head -5` gives all five quoted lines verbatim including `91203 + 0 in total`, `91148 + 0 primary`, `55 + 0 supplementary` | none |
| "90,990 of 91,203 reads mapped to the slice" | true | Arithmetic on the two verified outputs | none |
| The VCF sample, header line and two rows from the benchmark VCF | true | `gzcat ... | grep -v '^##' | head -3` reproduces the `#CHROM` line and both data rows verbatim through the stated truncation, and `head -1` gives `##fileformat=VCFv4.2` | none |
| "LGE reads VCF versions 4.0 through 4.4" | **false** | `VCFReader.swift:488-492` `validateFileFormat` throws only when the version string has the prefix `VCFv3.`. Nothing restricts the upper bound, so a 4.5 or later file is accepted rather than rejected. The v3 half of the claim is correct | "LGE rejects a file written in VCF version 3, which has to be converted with an outside tool before import. Any 4.x version is accepted." |
| "A large VCF is normally stored bgzip-compressed as `.vcf.gz` with a tabix index as `.vcf.gz.tbi`" | true | The demo project's variant tracks carry exactly that pair | none |
| The bcftools command and its two quoted rows | true | Reran with `/opt/homebrew/bin/bcftools`. Both rows match verbatim through the stated truncation | Note for the editor. The run also prints `[W::bcf_hdr_check_sanity] MQ should be declared as Type=Float` ahead of the rows, which a reader following the instruction will see and may mistake for an error. Worth one sentence, or leave as is. |
| The variant storage paragraph and both its exceptions | true | CONSISTENCY.md lines 225-233 rule exactly this, naming `variants/gatk/<track-id>.vcf.gz` and the `bundle create --variant` BCF plus CSI exception. The demo project's `variants/` folder holds `.vcf.gz`, `.vcf.gz.tbi`, and `.db` for each track, confirming the main path | none |
| The Newick sample and its reading | true | `cat "Primate mitochondria.lungfishtree/tree/primary.nwk"` reproduces the string character for character. The nesting reading and the 0.0299 branch length are both correct | none |

### Bundles

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Every bundle carries a manifest at its root, but the manifest's shape is not shared" and the four named shapes | true | Verified all four. `HBB.lungfishref/manifest.json` uses snake_case with `format_version`. The MSA and tree manifests use camelCase with `schemaVersion` and `bundleKind`. The QIAseq primer manifest uses `schema_version` and carries no file map. The MHC reference bundle's manifest is `mhc-reference.json` | none |
| "Only three bundle extensions have identifiers in the format registry, which are `.lungfishref`, `.lungfish12sref`, and `.lungfishmhcref`" | true | `FormatIdentifier.swift:323-341`, exactly three under the Bundle Formats heading | none |
| The 13-row bundle table, every extension and holds column | true | Extensions confirmed against `FASTQBundle.swift:14`, `MultipleSequenceAlignmentBundle.swift:7`, `TwelveSAmpliconResultBundle.swift:5`, `TwelveSReferenceBundle.swift:72`, `MHCAmpliconReferenceBundle.swift:150`, `ONTGenotypeResultBundle.swift:1830`, `WorkflowLibraryStore.swift:49`, `WorkflowPackageManifest.swift:260`, `NFCoreRunBundleManifest.swift:193`, `DocumentManager.swift:136-140`, and the CZ ID writer at `AppDelegate+ToolsMenu.swift:860-867`. Satisfies DRIFT rows 14 and 15 | none |
| "classifier results from Kraken2, EsViritu, TaxTriage, NAO-MGS, and NVD are not bundles ... plain result folders under `Analyses/`" | true | `Analyses/kraken2-SRR36291587` holds `classification-result.json`, `classification.kraken.gz`, `classification.kraken.gz.idx.sqlite`, and `classification.kreport` with no bundle extension. `Analyses/nvd-demo` likewise. CONSISTENCY.md lines 160-175 agree | Note. CONSISTENCY.md line 165 says the Import Center writes an NVD bundle into `Imports`, not `Analyses`. The chapter's sentence is about where classifier results sit generally and the demo project's own NVD copy came from the CLI with `Analyses` as the destination, so the sentence is true as written, but "under `Analyses/`" is narrower than the routes allow. |
| The `chr20_10.0-10.5Mb.lungfishref` layout block, "Here is the real layout" | **false** | The block is real but silently abridged. `find` on that bundle returns 12 further entries the block omits, including a second complete variant track (`vc-7ed9726c-de61-4735-80cf-0735eee621ec` with its `.vcf.gz`, `.tbi`, and `.db`), a per-track `.lungfish-provenance.json` beside each variant track, `alignments/mapped/hg002-minimap2.adopt-mapping-provenance.json`, and the whole `provenance/` subtree (`bundle.lungfish-provenance.json`, `manifest.json.lungfish-provenance.json`, and a `genome/` folder of three sidecars). The block shows `provenance/` as an empty leaf. Every path shown does exist | Either say the listing is abridged ("Here is the layout of `chr20_10.0-10.5Mb.lungfishref` from the demo project, with the provenance sidecars and a second variant track left out for room") or show the full tree. The second variant track matters because the very next paragraph tells the reader a folder listing does not say which caller produced which track, which lands better when two tracks are visible. |
| "The `annotations/` and `tracks/` folders exist even when empty" | true | Both present and empty in the chr20 bundle | none |
| "The HBB bundle ... fills `annotations/` with a GFF3 and its SQLite index and fills `metadata/` with a `genbank_records.sqlite`" | true | `annotations/` holds `imported_annotations.gff3` and `imported_annotations.db`. `metadata/` holds `genbank_records.sqlite` | none |
| The 14 manifest keys of `HBB.lungfishref/manifest.json` | true | Read the file. The key set is exactly `alignments`, `annotations`, `browser_summary`, `created_date`, `format_version`, `genome`, `identifier`, `modified_date`, `name`, `record_store`, `source`, `tracks`, `variants`, `warnings`. All 14 named, none missing, none invented | none |
| The quoted `genome` block | true | Reproduces the four keys verbatim. The real block also carries `chromosomes`, which the lead-in sentence discloses ("one entry per chromosome") | none |
| The `bundle info` command and its two quoted tables | true | Reran. The Chromosomes table (`NG_000007  81706  Yes  No`) and the Annotation Tracks table (`imported_annotations  Imported Annotations  gene  102  annotations/imported_annotations.gff3`) both reproduce verbatim including column headers and rule characters | none |
| The `HG002-chrM.lungfishfastq` layout, "Here is the whole of" | true | `find` returns exactly the seven entries shown and nothing else. This one genuinely is the whole bundle | none |
| "A paired-end import produces one interleaved file rather than two ... the meta sidecar records `pairingMode: interleaved`" | true | Confirmed on a real paired import. This very bundle's `ingestion.originalFilenames` reads `["HG002.chrM.R1.fastq.gz", "HG002.chrM.R2.fastq.gz"]` and `ingestion.pairingMode` reads `interleaved`, with one `HG002-chrM.fastq.gz` on disk. CONSISTENCY.md lines 236-241 rule the same | Optional precision. `pairingMode` sits inside the sidecar's `ingestion` block, not at its top level. Worth naming the block, since the chapter's next paragraph lists top-level keys. |
| The meta sidecar key list and the quoted `computedStatistics` block | true | All five quoted values match exactly (`baseCount` 2473714, `gcContent` 0.444, `maxReadLength` 250, `meanQuality` 26.52, `meanReadLength` 248.4), and every key the chapter names is present including `perPositionQuality`. The sidecar also carries `ingestion`, `seqkitStats`, and `sequencingPlatform` at top level and `readCount`, `q20Percentage`, `q30Percentage`, `qualityScoreHistogram`, and `readLengthHistogram` inside `computedStatistics`, all covered by the chapter's "Its keys include" hedge | none |
| The virtual bundle paragraph and `preview.fastq` of about a thousand reads | true | `03-reads/06-subsetting-and-extraction.md:226` and the project's standing rule agree | none |
| The `fastq materialize` example | true | Live `--help`. Usage is `fastq materialize <input> --output <output>`, and the help's own examples use the same shape | none |
| "`metadata.csv` inside the bundle ... `samples.csv` at the folder root ... `metadata export-biosample` turns a folder of them into a TSV" | true | Live `metadata --help` prints both sentences almost verbatim. `metadata export-biosample --help` reads "Export folder metadata as NCBI BioSample submission TSV ... can be submitted directly to NCBI's BioSample submission portal" | none |
| "aligned to the PHA4GE specification for pathogen sample descriptions" | true | `FASTQSampleMetadata.swift:1,41-45` | none |
| The `.lungfishmsa` layout block | **false** | Real but abridged without saying so. The bundle also holds `.lungfish-provenance.json` and `.viewstate.json` at its root, neither shown. Every path shown does exist | Add the two root files, or add "with the bundle's own provenance sidecar and view state left out" to the lead-in. |
| "Alignments land under `Analyses/Multiple Sequence Alignments/`" | true | The demo project's path, and CONSISTENCY.md lines 69-71 | none |
| The MSA manifest keys and all four counts | true | Read the manifest. `bundleKind` is `multiple-sequence-alignment`, `alignedLength` 17247, `rowCount` 5, `variableSiteCount` 5053, `parsimonyInformativeSiteCount` 2709, and `consensus`, `checksums`, and `fileSizes` are all present | none |
| The `.lungfishtree` layout block | **false** | Same abridgement. The bundle also holds `.lungfish-provenance.json` and `.viewstate.json` at its root | Same fix as the MSA block. |
| "lands in a top-level `Phylogenetic Trees/` folder, whether the tree was built in the window or imported" | true | CONSISTENCY.md lines 71-75 rule exactly this for both app routes, citing `ViewerViewController.swift:2156` and `ImportMSATreeSubcommands.swift:147`. That ruling adds that the CLI's `tree infer --output` writes wherever you point it, which the chapter does not contradict | none |
| The tree manifest keys and all five reported values | true | `bundleKind` `phylogenetic-tree`, `tipCount` 5, `internalNodeCount` 3, `treeCount` 1, `isRooted` false, `sourceFormat` `newick`, plus `checksums` and `fileSizes` | none |
| The QIAseq primer bundle layout, three files | true | `find` returns exactly `manifest.json`, `primers.bed`, and `PROVENANCE.md` | none |
| The primer manifest's 12 keys | true | Read the file. Key set is exactly `amplicon_count`, `created`, `description`, `display_name`, `name`, `organism`, `primer_count`, `reference_accessions`, `schema_version`, `source`, `source_url`, `version`. All 12 named, no file map present | none |
| "Preview 2026.9.13 ships eight built-in schemes" and the naming of all eight | true | `ls Sources/LungfishApp/Resources/PrimerSchemes/` returns exactly eight bundles. Four are ARTIC (nCoV-2019-V3, SARS-CoV-2-V4, V4.1, V5.3.2), plus QIASeqDIRECT-SARS2, Midnight-1200-V1, NEB-VarSkip-vss1, NEB-VarSkip-Long-vsl1. Satisfies DRIFT rows 19 and 20 | none |
| "**File > Import Center...**" | true | `MainMenu.swift:208` `withTitle: "Import Center\u{2026}"`. The ellipsis is present in the chapter | none |
| The `.lungfishgenotype` contents paragraph | true | Read the Williams bundle. Every named item is present: `genotype-result.json`, `finalcheck.xlsx` named for the run, `finalcheck.retained.demuxed.bam` with its `.bai`, per-sample and per-genotype CSVs, four stderr logs, `artifacts/` holding `projections` and `workbooks`, and `provenance/` with one sidecar per output | none |
| "The annotation layer ... is written as `annotations.json` and appears only once someone has annotated the result" | true | `GenotypeAnnotationSidecar.swift:118` names the file, and no `annotations.json` is present in this unannotated bundle | none |
| "lands under `Analyses/Amplicon genotyping results/`" | true | The Williams project's actual path | none |
| "A `.lungfish12s` bundle ... lands at `Analyses/12S amplicon results/<Result Name>.lungfish12s`, in a fixed category folder rather than a timestamped one" | true | `WorkflowOperationDialogState.swift:1545` `twelveSResultsDirectoryName = "12S amplicon results"`, and CONSISTENCY.md lines 183-187 | none |
| "both the app route and the command-line route write it to `Classifications/<sample>.lungfishtax`" | true | `AppDelegate+ToolsMenu.swift:861-866` composes exactly that path. CONSISTENCY.md lines 176-181 rule both routes | none |
| "the import sheet's Project Destination readout names a path under `Analyses` that nothing writes to" | true | CONSISTENCY.md lines 179-181, and restated from `06-classification/08-importing-cz-id-results.md` | none |
| The MHC reference bundle paragraph, `mhc-reference.json`, `haplotypes/`, `sources/` | true | `ls` on the shipped `MCM-MHC-miSeq-20260617.lungfishmhcref` returns `mhc-reference.json`, `haplotypes`, `sources`, a trimmed reference FASTA, and `.lungfish-provenance.json` | none |
| "Haplotype definitions are files inside that folder with the suffix `.lungfishhaplotypedef.json`, not a bundle format of their own" | true | `haplotypes/mcm-mhc-miseq-20260617.lungfishhaplotypedef.json` is a plain file. Satisfies the DRIFT decision to remove `.lungfishhaplotypedef` as a bundle | none |
| The three workflow bundles, their folders, and their filenames | true | `WorkflowLibraryStore.swift:48-52` gives `Workflows`, `lungfishflow`, `graph.json`, `workflow.json`, `provenance.json`. `WorkflowPackageManifest.swift:260-261` gives `lungfishflowpkg` and `manifest.json`. `NFCoreRunBundleManifest.swift:193-201` gives `lungfishrun`, `manifest.json`, and the created `logs`, `reports`, `outputs` subdirectories | none |
| "A run started from a bare graph JSON file ... lands under a `Workflow Runs/<run-id>/` folder" | true | `08-workflows/01-the-workflow-builder.md:220` | none |

### Provenance and sharing

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "LGE names them `<filename>.lungfish-provenance.json`, gathers a bundle's sidecars under a `provenance/` folder, and writes a `.lungfish-provenance.json` at the bundle root" | true | All three shapes present in every bundle inspected | none |
| The ten top-level provenance keys | true | Read the real sidecar. Key set is exactly `appVersion`, `endTime`, `hostOS`, `id`, `name`, `parameters`, `runtime`, `startTime`, `status`, `steps`. All ten named, none missing | none |
| The quoted seven-key JSON excerpt | true | All seven values match character for character, including the UUID and both timestamps | none |
| "There is no `schema_version` key in a provenance sidecar" | true | Absent from the real file. Settles DRIFT row 32 and reconciles with power-user-notes.md, whose `"schema_version": 2` sample DRIFT row 14 flags as needing the same correction | none |
| The four quoted parameter values and "each as an object with a `type` and a `value`" | true | `caller` `bcftools`, `variantCallerVersion` `1.24`, `threads` `14`, `minimumDepth` `caller-default`, each stored as `{"type": "string", "value": ...}` | none |
| "The `steps` array holds one entry per process ... each with an `id`, a `command` array ..., a `dependsOn` list, `startTime` and `endTime`, an `exitCode`, and `inputs` and `outputs` arrays" | true | 11 steps present, all eight named keys on every entry. Each entry also carries `toolName`, `toolVersion`, and `wallTime`, which the sentence omits without a hedge | Optional. Add the three, or hedge as the meta-sidecar paragraph does. `toolVersion` is worth naming because power-user-notes.md quotes it. |
| "**Every** file entry in those arrays carries a `path`, a `role`, a `format`, a `sha256` checksum, and a `sizeBytes` count, so the checksum and byte size claim holds for both directions" | **false** | Checked all 11 steps programmatically. Two entries lack both `sha256` and `sizeBytes`, and both are the pseudo-entry `pipe:stdout:bcftools-mpileup` (an output of step `336A044A-4829-489E-A15D-D89E88847888` and an input of step `700E167B-0DF6-4314-8332-14047212E4E9`). Every entry naming a real file on disk does carry all five. This is the settlement DRIFT row 33 asked for | "Every entry naming a file on disk carries a `path`, a `role`, a `format`, a `sha256` checksum, and a `sizeBytes` count. A step that pipes its output straight into the next one records that stream as an entry with a `path` such as `pipe:stdout:bcftools-mpileup` and no checksum or byte size, because no file was written." |
| The `zip -r` sharing route and the Finder paragraph | true | A bundle is a folder, so both hold | none |
| The OCI tarball entry list, five entry kinds plus a provenance record | true | `BundleContainerExportService.swift:74-81` builds exactly `oci-layout` (with `{"imageLayoutVersion":"1.0.0"}`), `index.json`, a config blob, a manifest blob, a `layer.tar` blob, each under `blobs/sha256/<digest>/`, plus `ProvenanceRecorder.provenanceFilename`. Written by `DeterministicTarWriter` | none |
| "In Preview 2026.9.13 that command cannot actually be run" and both quoted error messages | true | Reproduced both against `HBB.lungfishref`. `--format container` gives `Error: The value 'container' is invalid for '--format <format>'. Please provide one of 'text', 'json' or 'tsv'.` Omitting it gives `Error: Missing expected argument '--format <format>'`. The subcommand's own help advertises `--format container` in its example | none |
| The four inspection commands in the closing block | true | All four are read-only and well formed. The `bcftools view -H chr20_10.0-10.5Mb.lungfishref/variants/vc-6edd1356.vcf.gz` line uses a shortened track name that does not exist on disk (the real name carries the full UUID) | The shortened `vc-6edd1356.vcf.gz` will not resolve. Use the full `vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.vcf.gz` as the variant section already does, or write `vc-<uuid>.vcf.gz` to signal a placeholder. |

## Front matter

`fixtures_refs: [hbb-gene, hg002-chr20, primate-mito, demo-project]`. All four
are real directories under `docs/user-manual/fixtures/`. All four earn their
place. `hg002-chr20` supplies the FASTA, FAI, FASTQ, and benchmark VCF quotes,
`hbb-gene` is the source record behind the HBB bundle (confirmed by the
`bundle info` Source URL, which points at
`docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb`), `primate-mito` is behind
the alignment and tree, and `demo-project` is the project every layout block and
inspection command reads. Nothing is cited that is not used, and nothing quoted
comes from a fixture not listed. Verdict true.

`glossary_refs` carries 34 anchors. Every one resolves against GLOSSARY.md's
`{#anchor}` set, checked mechanically. The eleven new entries are all present,
all in the file's one-sentence-plus-"See also:" shape, all alphabetically
placed, and all factually correct against the same sources used above. One
narrowness. The CSI entry calls it "The alternative BAM index format", but CSI
also indexes BCF and VCF, which this chapter itself says two sections earlier.
Consider "The alternative index format for a BAM, BCF, or compressed VCF whose
reference sequence is longer than the 512-megabase limit a BAI index can
address."

`shots: []` and `illustrations: []` are correct and match DRIFT's screenshot
row, which rules that a citation appendix needs none.

`tools: [samtools, bcftools]` matches the two outside programs the chapter tells
the reader to run. Correct.

`features_refs: []` and `entry_points: []`. Acceptable for a reference appendix
that documents no operation of its own. The chapter cites no `parameters_refs`
and needs none, since it documents no settings.

`estimated_reading_min: 26`. Unverifiable as a fact but reasonable for roughly
4,900 words with twenty blocks a reader stops to read.

`brand_reviewed: false`, `lead_approved: false`. Correct at this stage.

`audience: analyst`. Correct. The chapter's own opening promises to gloss every
term, and it does, so a bench reader is not shut out.

## Consistency

Every storage fact the brief asked about was checked against CONSISTENCY.md and
against the committed chapter that verified it at first hand. All agree.

**The `Assemblies/` question is settled against the chapter's favor, meaning the
author was right and the task brief was wrong.** CONSISTENCY.md line 80 states
flatly "There is no `Assemblies/` folder." The committed assembly chapter agrees
at `07-assembly/03-running-flye-or-hifiasm.md:40`, which says each run produces
a `.lungfishref` assembly bundle "inside a per-run folder under the project's
`Analyses` folder", and at `:108` and `:210`, which name `Analyses/flye-<timestamp>/`.
`07-assembly/04-extracting-contigs.md:45` adds that an assembly bundle is already
a `.lungfishref`. The chapter's sentence, that an assembly is "the same format in
a different place, landing in the assembler's own run folder under `Analyses/`",
matches all three. The author was right to drop the old `Assemblies/` table row.

Variant folder and its two exceptions. Matches CONSISTENCY.md lines 225-233
word for word, including the GATK `variants/gatk/<track-id>.vcf.gz` exception and
the `bundle create --variant` BCF plus CSI exception. The author flagged the
second as resting on the CONSISTENCY ruling rather than a source read. That flag
is honest and the treatment is correct, since CONSISTENCY.md is binding.

Paired-end storage. Matches CONSISTENCY.md lines 236-241 and
`03-reads/01-importing-fastq.md:236`, and I confirmed it on a real paired bundle
rather than taking it on the ruling.

Virtual FASTQ preview. Matches `03-reads/06-subsetting-and-extraction.md:226`.

Classifier placement. Matches CONSISTENCY.md lines 160-181 for CZ ID. The one
softness is noted in the claim table, that the chapter says classifier results
sit "under `Analyses/`" where the Import Center writes NVD into `Imports`.

12S results, workflow bundles, and genotype bundles. All match CONSISTENCY.md
and the committed chapters cited in the claim table.

Naming discipline. "Lungfish Genome Explorer (LGE)" at first mention then "LGE"
throughout, `lungfish-cli` for the command-line tool, "the Variants tab of the
table drawer" as CONSISTENCY.md requires. Bundle extensions in code font
everywhere. No stray bare "Lungfish" for the app.

Prose rules. `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports "no issues
found", reproducing the author's result. I read the chapter for the rules the
linter cannot see. No em dashes, no semicolons, no colons inside a sentence
(every colon ends a lead-in before a block). Bullet and list caps are not
approached, since the chapter uses tables and code blocks rather than lists.
Terms are glossed at first use as the campaign requires. Examples are human and
macaque throughout, with viral data appearing only in the primer-scheme section,
where the feature is viral by design. Compliant.

Template. The chapter opens with "What it is" and closes with "Next", which is
the reference-appendix shape the other appendices use. It documents no
operation, so the Settings entry shape does not apply.

## App defects

1. **`lungfish-cli bundle export` is unusable in Preview 2026.9.13.** Confirmed
   at first hand, not merely restated. The subcommand declares its own
   `--format <format>` option while the root command declares a global
   `--format <format>` restricted to `text`, `json`, and `tsv`. The global wins
   during parsing, so the documented `--format container` is rejected with
   `Error: The value 'container' is invalid for '--format <format>'. Please
   provide one of 'text', 'json' or 'tsv'.`, and omitting the flag is rejected
   with `Error: Missing expected argument '--format <format>'`. There is no
   accepted spelling. The subcommand's own `--help` still advertises the
   `--format container` form in its example. The export implementation in
   `BundleContainerExportService.swift:74-81` is complete and correct, so this
   is an ArgumentParser option-collision bug in the CLI's command layering, not
   a missing feature. The chapter states it plainly and gives the zip
   workaround, which is the right treatment. Worth an issue against the CLI.

2. Restated, not newly found. The CZ ID Import sheet's Project Destination
   readout composes an `Analyses/cz-id-<timestamp>` path nothing writes to,
   while both routes write `Classifications/<sample>.lungfishtax`. Already
   recorded in CONSISTENCY.md and in
   `06-classification/08-importing-cz-id-results.md`.

No new defect beyond these two. The `[W::bcf_hdr_check_sanity]` warning the
demo project's VCF provokes is a header-declaration wrinkle in the fixture, not
an LGE defect.

## Notes for the editor

**The four false claims are all narrow and all cheaply fixed.** None requires
restructuring a section. Three are a matter of adding a word of disclosure to a
block that is real but abridged, and the fourth is a version-range claim that is
stricter than the code.

**On the abridged layout blocks.** Three blocks (the chr20 reference bundle, the
MSA, and the tree) are introduced with language promising a complete listing
("Here is the real layout", "Here is the layout") and then omit files. The
FASTQ block, by contrast, promises "the whole of" and delivers exactly that.
The fix is to bring the three promises down to the level the blocks deliver,
which costs a clause each. I would not expand the blocks themselves. Provenance
sidecars are numerous and the chapter has a whole section about them, so leaving
them out of a layout diagram is a good editorial choice that only needs saying.
The chr20 case is the one worth a second look, because the omitted second
variant track would actually strengthen the paragraph that follows it.

**On the GFF3 block.** This is the one place where a quoted sample is stitched
rather than truncated. The chapter's convention everywhere else is honest
right-truncation with a stated "truncated to fit", and a reader who runs the
`head -6` the author record cites will not see what the chapter shows. The
substance is fine and the fix is an ellipsis.

**On DRIFT's "BED no" decision line.** DRIFT's decision reads "Writers as they
are (GFF3 yes, BED no)". The chapter says BED writes, following the registry,
and the chapter is right. `BEDWriter` is a real class at
`Formats/BED/BEDReader.swift:357` with a static `write(_:to:columns:)` at
`:444`. DRIFT's own missing-row evidence ("only FASTQ has a dedicated writer in
`Sources/LungfishIO/Formats/`") reasoned from filenames and missed both
`BEDWriter` and `GFF3Writer`, because neither lives in a file named
`*Writer.swift`. So DRIFT is wrong on BED and right on GFF3 by accident. The
author followed the registry, flagged the discrepancy, and added a paragraph
explaining what a write flag means. That paragraph is the most valuable
sentence in the registry section and should survive editing, because two rows
in the table (SAM and VCF) carry `canWrite: true` with no writer class anywhere
in `Sources/LungfishIO/`, and without the paragraph a reader would take those
two rows as a promise the app does not keep.

**On DRIFT's five unverifiable claims.** The author could not recover which five
DRIFT meant, since the section lists no unverifiable table. I could not either.
The header count appears to be an artifact of the DRIFT template rather than
five identifiable claims. Rewriting every claim against source, a real bundle,
or a run, as the author did, is the correct response and the count should not
block the gate.

**On DRIFT row 29 (MAFFT).** The row corrects a sentence about provenance
recording which aligner ran. That sentence does not appear anywhere in the
rewritten chapter, which mentions no aligner at all. The row is moot rather
than unapplied. No action.

**On the author record's two small errors.** Neither touches the chapter, but
both should be corrected if the record is kept. First, the record says the
`primer-schemes.md#appendix-primer-schemes` anchor "does not exist in that
file"; it does, as an HTML anchor at `primer-schemes.md:22`. The chapter's plain
file link is fine either way, so no chapter change follows. Second, the record
says bcftools came from `~/miniforge3/bin`; no bcftools exists there on this
machine, and the reproduction ran from `/opt/homebrew/bin`. The quoted output
matched regardless.

**One thing worth praising, because it should not be edited away.** The chapter
is unusually disciplined about the difference between what it verified and what
it inferred. It shows no layout block for `.lungfishflow`, `.lungfishflowpkg`,
`.lungfishrun`, `.lungfish12s`, or `.lungfish12sref`, because no instance of any
of them exists in either demo project, and it names what those bundles hold from
source constants instead. That is the right call and the absence of those blocks
is a feature.

## Counts

Claims checked: 78.

- True: 72
- False: 4
- Unverifiable: 2

The two unverifiable claims are `estimated_reading_min: 26`, which is a
judgment rather than a fact, and the `bundle create --variant` BCF plus CSI
exception, which rests on CONSISTENCY.md's binding chapter 28 ruling rather than
on a source read or a run. A grep of `Sources/LungfishCLI/Commands/BundleCommand.swift`
finds no `bcf` or `csi` handling, so the write likely lives in a service the
command calls. Running `lungfish-cli bundle create --variant` against a scratch
copy and listing the result would settle it, but that writes, so it is outside
this role's remit.

The four false claims, one line each.

1. "Three more formats have registry identifiers without a full descriptor
   entry" undercounts. There are four, since `tbi` at `FormatIdentifier.swift:246`
   is an identifier with no descriptor exactly as `csi` is.
2. "LGE reads VCF versions 4.0 through 4.4" is stricter than the code, which
   rejects only `VCFv3.*` at `VCFReader.swift:488-492` and accepts any 4.x.
3. Three layout blocks (chr20 `.lungfishref`, `.lungfishmsa`, `.lungfishtree`)
   are introduced as complete listings but silently omit files, most notably a
   whole second variant track and the `provenance/` subtree in the chr20 block.
4. "Every file entry in those arrays carries a `path`, a `role`, a `format`, a
   `sha256` checksum, and a `sizeBytes` count" fails for the two
   `pipe:stdout:bcftools-mpileup` stream entries, which carry neither checksum
   nor byte size.

A fifth item sits between false and imprecise and is listed with the false
claims in the table above for the editor's convenience. The GFF3 sample block is
presented as the first three lines of a real file but stitches non-adjacent
fragments of the attribute column together without an ellipsis.
