# Fidelity review: 01-foundations/03-amplicon-vs-shotgun.md

Reviewed 2026-09-06 against the Swift source under `Sources/`, the
`.build/debug/lungfish-cli` help tree, the eight bundled primer-scheme
manifests, the committed HG002 fixture files, the Williams MiSeq project at
`~/Desktop/lge-docs/32566_MS267_Williams1.lungfish`, `docs/user-manual/GLOSSARY.md`,
and `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`.

## Note on the HG002 numbers

The chapter's HG002 figures were judged against the committed FASTQ files,
not against `docs/user-manual/fixtures/hg002-chr20/README.md`. The README
says 91,203 total reads and 45,614 pairs. The committed files hold 45,574
records each (`gzcat ... | wc -l` gives 182,296 lines per file, so 45,574
records, 91,148 reads total). The stale figure also survives in
`expected/mapping/mapping-result.json` as `"totalReads": 91203`. The
minimap2 log embedded in that same run's `mapping-provenance.json` reads
`mapped 91148 sequences`, which confirms the run itself consumed the
committed files, so the depth and breadth numbers derived from it are
sound while the read-count summary field is not. Each HG002 row below says
which artifact settled it.

## Claims

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "It holds 45,574 Illumina read pairs from a well-characterised human genome" | true | Committed `docs/user-manual/fixtures/hg002-chr20/HG002.chr20.10.0-10.5Mb.R1.fastq.gz` and `.R2.fastq.gz` each hold 182,296 lines, so 45,574 records each. Judged against the committed files, not the README's stale 45,614 | |
| "covering a 500,001 base stretch of chromosome 20" | true | `docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta.fai` reads `chr20_10.0-10.5Mb 500001 19 50 51` | |
| "Mapped back to its own reference those reads reach a mean depth of 44.7 reads per position" | true | `docs/user-manual/fixtures/hg002-chr20/expected/mapping/mapping-result.json` `"meanDepth": 44.7234`. That run's minimap2 log in `mapping-provenance.json` reads `mapped 91148 sequences`, matching the committed FASTQ, so the figure is derived from the committed files | |
| "and cover 99.99% of the slice" | true | Same file, `"coverageBreadth": 0.9999379999999999`, which is 99.9938%. Derived from the same committed-file run | |
| "Depth is the number of reads stacked at one position." | true | `docs/user-manual/GLOSSARY.md:85` "**Depth**{#depth}. Synonym for coverage in this manual. The number of reads stacked at one reference position." | |
| "It holds 30 macaque samples prepared by PCR against the MHC" | true | `ls ~/Desktop/lge-docs/32566_MS267_Williams1.lungfish/Imports` returns 30 `.lungfishfastq` bundles, `WD1_S148_L001` through `WD30_...`. `docs/user-manual/fixtures/demo-assets/README.md` "30 MiSeq amplicon samples" and the IPD-MHC Mamu reference bundle | |
| "and sequenced on an Illumina MiSeq" | true | `Imports/WD28_S175_L001.lungfishfastq/WD28_S175_L001.fastq.gz.lungfish-meta.json` `sequencingPlatform = illumina`, `assemblyReadType = illuminaShortReads`; project name `32566_MS267_Williams1` and the demo-assets README name MiSeq | |
| "One of its samples, WD28, holds 32,740 reads" | true | Same meta JSON, `seqkitStats.numSeqs = 32740` | |
| "every one of them exactly 251 bases long" | true | Same meta JSON, `minLen = 251`, `maxLen = 251`, `avgLen = 251`, `sumLen = 8217740` (32,740 x 251 exactly) | |
| "the reference it is genotyped against is a database of 970 short allele sequences" | true | `26128_ipd-mhc-mamu-2021-07-09.lungfishref/genome/sequence.fa.gz.fai` has 970 lines | |
| "577 of them 156 bases long and 198 of them 244 bases long" | true | Same `.fai`, length column tallies to 577 entries of 156 and 198 entries of 244 (next largest groups are 57 at 154 and 39 at 192) | |
| "The Williams project works differently, because the MHC targets it amplifies are separate genes rather than one continuous region" | true | The reference is 970 short allele records rather than one contig (`sequence.fa.gz.fai`), and `GLOSSARY.md:175` describes MHC as "A gene-dense immune region genotyped here by amplicon sequencing" | |
| "the minimum allele-frequency setting in the variant-calling dialog, which is pre-filled at 0.05" | true | `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift:75` `self.minimumAlleleFrequencyText = "0.05"`; the field is labelled "Minimum Allele Frequency" at `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift:52-56` | |
| "LGE's Primer Remove operation takes the primer sequences, matches them against each FASTQ read, strips those bases, and writes a trimmed FASTQ." | false | No surface in LGE is called "Primer Remove". The GUI operation title is "Primer Trimming" (`Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:1961`), the derivative service display name is "PCR Primer Trimming" (`Sources/LungfishApp/Services/FASTQDerivativeServiceModels.swift:102`), and `primer-remove` is only the CLI subcommand (`lungfish-cli fastq primer-remove --help`). The behaviour described is right | "LGE's Primer Trimming operation takes the primer sequences, matches them against each FASTQ read, strips those bases, and writes a trimmed FASTQ. On the command line this is `lungfish-cli fastq primer-remove`." |
| "Its engine is `bbduk` by default, with `cutadapt-linked` as the alternative." | false | True of the CLI only. `lungfish-cli fastq primer-remove --help` gives `--engine <engine> Primer trimming engine: bbduk or cutadapt-linked (default: bbduk)`. The GUI exposes no engine control at all and picks the tool from the primer source: a literal primer sequence uses `tool: .bbduk` and a reference FASTA uses `tool: .cutadapt` with `mode: .linked` (`Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift:546-565`). The chapter frames this as a property of the operation, which misleads a GUI reader | "On the command line its engine is `bbduk` by default, with `cutadapt-linked` as the alternative. In the app the engine follows the primer source, `bbduk` for a typed-in primer sequence and linked `cutadapt` for a primer FASTA." |
| "Because it matches sequence rather than position, it needs no reference" | true | `Sources/LungfishIO/Formats/FASTQ/FASTQDerivatives.swift:46` `FASTQPrimerSource` allows a literal primer sequence with no reference genome; the CLI takes `--literal` or a primer `--ref` FASTA, never a reference genome | |
| "`ivar trim` takes the primer coordinates from a BED file, walks each aligned read in the BAM, finds where the read's mapped position overlaps a primer footprint, and marks those bases as soft-clipped." | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:1,10` "Run ivar trim + samtools sort/index with provenance ... Resolves the primer scheme's BED to the BAM's reference name, runs `ivar trim`"; argv at lines 38-48 passes `-b <bed> -i <bam>` | |
| "Soft-clipping means the bases stay in the record but are excluded from coverage, pileup, and variant calling." | true | `docs/user-manual/GLOSSARY.md:275` "**Soft-clip**{#soft-clip}. ... bases at the start or end of a read that are present in the record but excluded from pileup, coverage, and variant calling" | |
| "In LGE this runs after alignment and before variant calling, from the Inspector's Primer Trim tab" | true | `Sources/LungfishApp/Views/Inspector/Sections/ReadStyleSection.swift:1029,1043` defines `AnalysisWorkflowSubsection.primerTrim` with display title "Primer Trim", rendered at line 2057 inside `AnalysisSection`. `CONSISTENCY.md:29` fixes the house wording: "The Inspector's Analysis section is a grid of six tabs (Filtering, Annotations, Consensus, Primer Trim, Variant Calling, Export)". The source implements the grid as `LungfishInspectorSegmentedButtonGrid`, but the sheet settles the noun | |
| "its provenance sidecar records the exact options used so the run can be repeated" | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:247` `ivarTrimArgs: ivarArgs`; the Inspector renders "iVar trim args" from it at `ReadStyleSection.swift:1458` | |
| "Some `ivar trim` options can drop a read whose remaining aligned stretch is too short to be useful." | true | `BAMPrimerTrimPipeline.swift:18` the argv "ends with `\"-e\"` so reads without a matching primer are kept rather than discarded", and the argv passes `-m <minReadLength>` (line 44), iVar's minimum-length drop | |
| "the six standard columns are chrom, start, end, name, score, strand" | true | `Sources/LungfishApp/Resources/PrimerSchemes/ARTIC-nCoV-2019-V3.lungfishprimers/primers.bed:1` `MN908947.3 30 54 nCoV-2019_1_LEFT 1 +` | |
| BED row example `MN908947.3 999 1021 scheme_1_LEFT 1 +` | true | The generic name `scheme_1_LEFT` matches no bundled scheme (`grep` across `Sources/LungfishApp/Resources/PrimerSchemes/*/primers.bed` finds only `nCoV-2019_*`, `SARS-CoV-2_*`, and vendor names), so it cannot be mistaken for a real row. This is the DRIFT row 10 correction, applied | |
| "LGE packages a scheme as a `.lungfishprimers` bundle, a folder that macOS shows as one item." | true | `Sources/LungfishIO/Bundles/PrimerSchemeBundle.swift` resolves a directory bundle; all eight bundled schemes are directories under `Sources/LungfishApp/Resources/PrimerSchemes/` | |
| "Inside sit the BED file, the primer sequences as a companion FASTA where the scheme supplies them, a manifest, and a provenance note" | true | Every bundled scheme holds `manifest.json`, `primers.bed`, and `PROVENANCE.md`. No bundled scheme ships a `primers.fasta` (`ls */primers.fasta` matches nothing), which the hedge "where the scheme supplies them" covers correctly; `lungfish-cli primers import --fasta` is documented as "Optional primer FASTA to copy into the bundle" | |
| "Bundles you add yourself live in the project's `Primer Schemes/` folder." | true | `Sources/LungfishIO/Bundles/PrimerSchemesFolder.swift:19` `public static let folderName = "Primer Schemes"`; `lungfish-cli primers import --project` writes "relative output ... under Primer Schemes/" | |
| "Primer schemes in LGE are viral by design, and the eight it bundles are all SARS-CoV-2 schemes." | true | `Sources/LungfishApp/Resources/PrimerSchemes/` holds exactly eight `.lungfishprimers` directories, and every `manifest.json` declares `"organism": "Severe acute respiratory syndrome coronavirus 2"` | |
| "They appear in the Primer Scheme menu under the heading \"Built-in\", and any scheme you added to your own project is listed separately under \"In This Project\"." | true | `Sources/LungfishApp/Views/BAM/PrimerSchemePickerView.swift:18,21,28` `Picker("Primer Scheme", ...)` with `Section("Built-in")` and `Section("In This Project")` | |
| "A \"Choose Scheme…\" button beside the menu opens a file chooser for a bundle stored somewhere else on disk." | true | `PrimerSchemePickerView.swift:36-41` an `HStack` beside the picker holds `Button(action: onBrowse) { Label("Choose Scheme…", systemImage: "folder") }` | |
| "**ARTIC SARS-CoV-2 V3** is the original 400-base scheme, 98 amplicons across 218 primer rows" | true | `ARTIC-nCoV-2019-V3.lungfishprimers/manifest.json` `"display_name": "ARTIC SARS-CoV-2 V3"`, `"amplicon_count": 98`, `"primer_count": 218`, description "400 bp amplicon scheme, version 3". `primers.bed` holds 218 rows | |
| "more rows than twice the amplicon count because the scheme includes alternate primers for some positions" | true | 218 rows against 98 amplicons, so 22 rows beyond the 196 a bare pair-per-amplicon design would need. This is the DRIFT row 1 explanation, retained | |
| "**ARTIC SARS-CoV-2 V4** and **ARTIC SARS-CoV-2 V4.1** each hold 99 amplicons, across 198 and 209 primers" | true | `ARTIC-SARS-CoV-2-V4.lungfishprimers/manifest.json` `amplicon_count 99`, `primer_count 198` (198 BED rows); `ARTIC-SARS-CoV-2-V4.1.lungfishprimers/manifest.json` `amplicon_count 99`, `primer_count 209` (209 BED rows). Both display names match verbatim | |
| "V4.1 adds spike-in primers that restore coverage lost to Omicron mutations" | true | `ARTIC-SARS-CoV-2-V4.1.lungfishprimers/manifest.json` description "Adds spike-in primers restoring Omicron coverage" | |
| "**ARTIC SARS-CoV-2 V5.3.2** is a redesign rebalanced for coverage uniformity, 96 amplicons across 192 primers." | true | `ARTIC-SARS-CoV-2-V5.3.2.lungfishprimers/manifest.json` `"display_name": "ARTIC SARS-CoV-2 V5.3.2"`, `amplicon_count 96`, `primer_count 192` (192 BED rows) | |
| "**QIAseq Direct SARS-CoV-2 with Booster A** is a commercial kit built for fragmented RNA, 223 amplicons across 563 primers." | true | `QIASeqDIRECT-SARS2.lungfishprimers/manifest.json` `"display_name": "QIAseq Direct SARS-CoV-2 with Booster A"`, `amplicon_count 223`, `primer_count 563` (563 BED rows) | |
| "**Midnight 1200 bp V1** uses far longer amplicons, 29 of them across 58 primers, suited to Oxford Nanopore reads." | true | `Midnight-1200-V1.lungfishprimers/manifest.json` `"display_name": "Midnight 1200 bp V1"`, `amplicon_count 29`, `primer_count 58`, description "designed for Oxford Nanopore rapid-barcoding workflows" | |
| "**NEB VarSkip Short v1** holds 74 amplicons across 148 primers" | true | `NEB-VarSkip-vss1.lungfishprimers/manifest.json` `"display_name": "NEB VarSkip Short v1"`, `amplicon_count 74`, `primer_count 148` | |
| "and **NEB VarSkip Long v1** holds 29 across 50" | true | `NEB-VarSkip-Long-vsl1.lungfishprimers/manifest.json` `"display_name": "NEB VarSkip Long v1"`, `amplicon_count 29`, `primer_count 50` | |
| "Any scheme LGE does not bundle has to be imported, which on the command line is `lungfish-cli primers import`." | true | `lungfish-cli primers --help` lists one subcommand, `import`, "Import a BED primer scheme as a .lungfishprimers bundle" | |
| "Every bundled scheme declares both `MN908947.3` and `NC_045512.2` as accessions for the same SARS-CoV-2 sequence" | true | All eight `manifest.json` files carry `reference_accessions` with `MN908947.3` `"canonical": true` and `NC_045512.2` `"equivalent": true` | |
| "so a BAM aligned to either name resolves against the scheme without further work" | true | `Sources/LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:10` "Resolves the primer scheme's BED to the BAM's reference name" | |
| "The SARS-CoV-2 schemes LGE ships are tiling schemes of this kind." | true | `GLOSSARY.md:293` defines tiling as overlapping amplicons laid end to end; all eight bundled schemes are whole-genome SARS-CoV-2 designs (29 to 223 amplicons over one 29,903-base contig) | |
| "The [Variants and VCF Files](05-variants-and-vcf.md) chapter covers that setting." | true | `docs/user-manual/chapters/01-foundations/05-variants-and-vcf.md` exists | |
| "[Trimming and Filtering](../03-reads/04-trimming-and-filtering.md) documents the read-based settings" | true | `docs/user-manual/chapters/03-reads/04-trimming-and-filtering.md` exists | |
| "[Primer Trimming](../04-alignments/03-primer-trimming.md) documents the alignment-based ones" | true | `docs/user-manual/chapters/04-alignments/03-primer-trimming.md` exists | |
| "Continue to [Alignment Files](04-alignment-files.md)" | true | `docs/user-manual/chapters/01-foundations/04-alignment-files.md` exists | |
| "Confirm the primer trim actually ran, which the Inspector shows on the trimmed alignment track." | true | `Sources/LungfishApp/Views/Inspector/Sections/ReadStyleSection.swift:572` loads `primerTrimProvenance` per BAM and lines 1447-1459 render scheme, source, canonical accession, source BAM, iVar version, args, and timestamp | |
| "Two primers, each usually 18 to 30 bases long" | true | `GLOSSARY.md:223` "**Primer**{#primer}. A short oligonucleotide, typically 18 to 30 bases" | |
| "which is called tiling" | true | `GLOSSARY.md:293` `{#tiling}` | |
| "Target enrichment, also called capture or hybridisation capture, uses probes" | true | `GLOSSARY.md:291` "**Target enrichment**{#target-enrichment}. A library preparation that pulls chosen regions out of a randomly sheared sample using complementary probes" | |
| "For every workflow in this manual, treat capture data as shotgun data. Do not trim primers, since there are none." | true | `GLOSSARY.md:291` "without carrying primer sequence at their ends and without needing a primer trim"; the BAM primer trim is opt-in, never forced (`Sources/LungfishWorkflow/Variants/BundleVariantCallingModels.swift:39` `ivarPrimerTrimConfirmed: Bool = false`) | |
| "Twist and IDT sell panels of this kind." | unverifiable | A vendor fact about the wider market, not an app claim. Nothing in `Sources/` or the CLI speaks to it. A citation to the Twist and IDT product pages in the chapter's source notes would settle it | |
| "That coverage is smooth ... and it climbs and falls gently with the local base composition rather than jumping at fixed points." | unverifiable | The committed fixture holds no per-base depth track, and `expected/mapping/` reports only aggregate mean depth and breadth. Running `samtools depth` over `expected/mapping/HG002.sorted.bam` and plotting the profile would settle it. The claim is consistent with 99.99% breadth at 44.7x but is not established by any artifact in the repo | |
| "Its coverage does not spread across a chromosome at all. It piles onto a set of designed targets" | unverifiable | The Williams genotype result bundles were not opened (the review was read-only over the manifest, meta, and `.fai`). The 970-record allele-database reference makes the claim highly plausible but no coverage artifact was inspected. Opening one `.lungfishgenotype` bundle's coverage table would settle it | |
| "the sequencing submission record names the kit, for a public dataset in the SRA or ENA fields describing library strategy and construction protocol" | unverifiable | A claim about SRA and ENA metadata schemas, outside the app. `lungfish-cli` has no command that reports these fields. Checking an SRA experiment XML for `LIBRARY_STRATEGY` and `LIBRARY_CONSTRUCTION_PROTOCOL` would settle it | |
| "Adapters do get removed, but adapter trimming is a different step with a different tool, and the sequencing instrument's own software often does it before you ever see the file." | unverifiable | The first half is true in LGE (`FASTQOperationDialogState.swift:1961` lists "Adapter Removal" as a separate operation from "Primer Trimming"). The claim about instrument software running it upstream is a fact about sequencer vendors, not about LGE, and nothing in the repo speaks to it | |

## Front matter

| Item | Verdict | Evidence |
|---|---|---|
| `parameters_refs: []` | true | The chapter documents no operation settings. It explicitly defers both settings sets: "This chapter does not cover the settings of either operation," pointing at `03-reads/04-trimming-and-filtering.md` and `04-alignments/03-primer-trimming.md`. A concept chapter with an empty `parameters_refs` is correct under the campaign rule |
| `shots` lists every `<!-- SHOT -->` marker with a caption | true | The body holds exactly one marker, `<!-- SHOT: primer-scheme-picker-built-in -->` at line 111. Front matter declares one shot, id `primer-scheme-picker-built-in`, with a caption. Ids match and the count matches |
| Every `glossary_refs` anchor resolves in `GLOSSARY.md` | true | All eleven resolve: `{#amplicon}` line 21, `{#shotgun}` 267, `{#primer}` 223, `{#primer-scheme}` 225, `{#primer-trim}` 227, `{#soft-clip}` 275, `{#target-enrichment}` 291, `{#tiling}` 293, `{#library-prep}` 157, `{#mhc}` 175, `{#coverage}` 77 |
| Illustration assets exist for all three declared ids | true | `docs/user-manual/assets/illustrations-imagegen/01-foundations/03-amplicon-vs-shotgun/` holds `amplicon-vs-shotgun.png`, `primer-scheme-diagram.png`, and `primer-trim-soft-clip.png`, all three referenced from the body |

## Notes for the controller

Two items sit outside the claim table and are worth a decision.

The `glossary_refs` list includes `coverage`, and the body links `[depth](../../GLOSSARY.md#coverage)`. The anchor resolves, and `GLOSSARY.md:85` defines Depth as a synonym pointing back to Coverage, so the link is not wrong. Linking the word "depth" to `#depth` would be more direct.

`docs/user-manual/fixtures/hg002-chr20/README.md:80,88` and
`expected/mapping/mapping-result.json` `"totalReads"` both carry the stale
91,203 figure that the committed FASTQ files contradict. This chapter is
now correct against the files. Any other chapter that quoted the README's
figure is not. The fixture owner should reconcile the README, and the
`totalReads` field is a summary artifact of a run whose own minimap2 log
says 91,148.

The Primer Trim wording is judged true because `CONSISTENCY.md:29` fixes
"tab" as the house noun for the six Analysis-section controls. The source
builds them as `LungfishInspectorSegmentedButtonGrid`, not as tabs. If the
sheet is ever revised, this chapter's sentence follows it.

## Verdict count

True 53, false 2, unverifiable 5. That is 49 true in the claims table plus
the 4 front-matter checks.
