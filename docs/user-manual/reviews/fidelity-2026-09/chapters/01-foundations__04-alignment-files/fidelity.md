# Fidelity review: 01-foundations/04-alignment-files.md

Reviewed 2026-09-06 against the Swift source, the `lungfish-cli` help tree,
the managed `samtools` 1.24 (htslib 1.24) at
`/Users/dho/.lungfish/conda/envs/bbtools/bin/samtools`, and the
`hg002-chr20` fixture.

A note on the fixture BAM. `expected/mapping/HG002.sorted.bam` and its
`.bai` were present at the start of this review and were removed from the
folder partway through it, presumably by another campaign role, since both
are gitignored and reproducible from `regenerate.sh`. Every BAM-derived
verdict below was captured before that removal, and each such row records
the command and its output so the evidence stands without the file. The
three JSON artifacts in that folder are still on disk.

## Verdict table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "A BAM holds a short header naming every reference sequence and its length, then one row per aligned read." | true | `samtools view -H` on the fixture BAM returns `@HD VN:1.6 SO:coordinate`, `@SQ SN:chr20_10.0-10.5Mb LN:500001`, `@RG`, and four `@PG` lines | |
| "Lungfish Genome Explorer reads and writes BAM through `samtools`, a standard toolkit that LGE installs and runs for you." | true | `ManagedMappingPipeline.swift:901` runs `samtools index`; `MarkdupService.swift:13` runs the samtools markdup pipeline; `samtools` is one of the 17 environments in `third-party-tools-lock.json` | |
| "For an ordinary reference that index is a BAI file named `<sample>.bam.bai`." | true | `ManagedMappingPipeline.swift:272` builds `\(derivedSampleName).sorted.bam.bai`; the fixture wrote `HG002.sorted.bam.bai` | |
| "Where a single reference sequence is too long for BAI to address, a CSI index takes its place. LGE writes whichever of the two the data requires, so this is a distinction to recognise rather than a choice to make." | false | LGE invokes bare `samtools index <bam>` with no format flag at `ManagedMappingPipeline.swift:903` and `MarkdupService.swift:274`, and no call site anywhere in `Sources/` passes `-c`. The samtools 1.24 man page states BAI "is currently the default when no format options are used" and that for chromosomes over 512 Mbp "you will need to use a CSI index", so CSI is an explicit user choice, not an automatic substitution. LGE does *read* a `.csi` if one is present (`BAMImportService.swift:642`, `MiniBAMViewController.swift:561`) | "For an ordinary reference that index is a BAI file named `<sample>.bam.bai`. BAI cannot address a reference sequence longer than 512 megabases, and a CSI index is the format that covers those. LGE writes BAI for the BAMs it produces and reads either format in a BAM that arrives from elsewhere." |
| "Every BAM LGE writes gets an index beside it, a `.bam.bai` for ordinary references and a `.csi` where a reference sequence is too long for BAI to address." | false | Same evidence as the row above. Every LGE-written index is BAI | "Every BAM LGE writes gets a `.bam.bai` index beside it." |
| "BAI can only reach 512 megabases into a single reference sequence, so a genome with one very long chromosome needs the CSI form." | true | `samtools-index.1` lines 99-102, "The BAI index format can handle individual chromosomes up to 512 Mbp (2^29 bases) in length" | |
| "LGE picks the right one without asking." | false | No BAI/CSI selection logic exists. The index path is hard-coded to `.bam.bai` at `ManagedMappingPipeline.swift:272` and samtools is called with no format flag | Delete the sentence. |
| BAM record: `QNAME D00360:94:H2YT5BCXX:1:1204:17390:64334`, `FLAG 99`, `RNAME chr20_10.0-10.5Mb`, `POS 99675`, `MAPQ 60`, `CIGAR 240M9S`, `RNEXT =`, `PNEXT 99795`, `TLEN 364` | true | `samtools view <bam> chr20_10.0-10.5Mb:99600-99900` returns exactly `D00360:94:H2YT5BCXX:1:1204:17390:64334  99  chr20_10.0-10.5Mb  99675  60  240M9S  =  99795  364` | |
| Mate record: `FLAG 147`, `POS 99795`, `MAPQ 60`, `CIGAR 6S244M` | true | Same command returns `... 147  chr20_10.0-10.5Mb  99795  60  6S244M  =  99675  -364` | |
| "A MAPQ of 60 is `minimap2`'s top value" | true | `mapping-result.json` records `medianMAPQ: 60`; both quoted records carry MAPQ 60 | |
| "The value 99 above unpacks into four of them... Its mate... carries FLAG 147" | true | 99 = 1+2+32+64 (paired, proper pair, mate reverse, read 1); 147 = 1+2+16+128 (paired, proper pair, read reverse, read 2). Both flags confirmed in the records above | |
| "The row above carries `240M9S`, which reads as 240 bases aligned to the reference followed by 9 bases clipped off the end." | true | CIGAR `240M9S` verified in the record; 240+9 = 249 matches the read length | |
| "Six clipped bases, then 244 aligned." | true | CIGAR `6S244M` verified in the mate record | |
| CIGAR letter table (`M` aligned either matching or mismatching, `I` inserted, `D` deleted, `S` soft-clipped) | true | Matches the SAM/BAM specification section 1.4 | |
| "LGE soft-clips wherever it can, so nothing is silently discarded." | true | `BAMPrimerTrimPipeline.swift:18-19` documents the argv ending in `-e` "so reads without a matching primer are kept rather than discarded"; minimap2 emits soft clips by default and the mapping pipeline adds no hard-clip flag | |
| "Its BAM holds 91,203 rows, of which 91,148 are primary alignments." | true | `samtools flagstat`: `91203 + 0 in total`, `91148 + 0 primary` | |
| "45,574 read 1 records and 45,574 read 2 records, matching the two FASTQ files exactly" | true | `samtools flagstat`: `45574 + 0 read1`, `45574 + 0 read2`; fixture README records 45,574 read pairs | |
| "The remaining 55 rows are supplementary alignments of reads already counted." | true | `samtools flagstat`: `55 + 0 supplementary`, `0 + 0 secondary` | |
| "the fixture's own `README.md` explains the same 55-record gap" | true | `docs/user-manual/fixtures/hg002-chr20/README.md`, "`samtools flagstat` reports 91,203 records in total because 55 reads also carry a supplementary alignment" | |
| "The coverage track along the top of the alignment viewport draws it as a histogram across the reference, one bar per position when you are zoomed in and one bar per screen column when you are zoomed out." | true | `ReadTrackRenderer.binnedDepthColumns` (lines 512-538) allocates one bin per pixel of width and, when a position spans several pixels, fills `startPx..<endPxExclusive`, so zoomed in a position occupies one or more bars and zoomed out each column holds the max depth in its span | |
| "mean depth of 44.7 across the 500,001-base slice" | true | `samtools depth -a -d 0 -Q 0 -q 0` over the BAM gives mean 44.7234 across 500,001 positions; `mapping-result.json` records `meanDepth: 44.7234` | |
| "99.77 percent of rows mapped" | true | `samtools flagstat`: `90990 + 0 mapped (99.77%)`; `mapping-result.json` records `mappedReadPercent: 99.7664550508207` | |
| "the deepest single position reaching 79" | true | Same `samtools depth` pass gives max = 79 | |
| "Only 31 positions in the whole slice have no coverage at all" | true | Same pass gives 31 positions at depth 0 | |
| "the fixture's coverage breadth of 99.99 percent" | true | Same pass gives breadth 0.999938; `mapping-result.json` records `coverageBreadth: 0.9999379999999999` | |
| "In this fixture 505 positions sit below a depth of 10, roughly one position in a thousand" | true | Same pass gives 505 positions under depth 10; 505/500,001 = 0.00101 | |
| "A position covered by 0 reads cannot be called at all and appears as `N` in any consensus sequence built from the BAM." | true | Standard behavior of `samtools consensus` and `ivar consensus` at zero depth; consistent with the project's consensus pipeline | |
| "At position 250,527 the reference base is `C`, and 53 reads cover it. Twenty of them show `C` and 33 show `T`." | true | `samtools mpileup -f <ref> -r chr20_10.0-10.5Mb:250527-250527 -d 10000 <bam>` at default filtering returns ref base `C`, depth 53, and a base string decomposing to 20 ref and 33 alt. (Raw depth with `-Q 0 -q 0` is 63, so the chapter's numbers are the default-filtered pileup a caller actually reads, which is the right column to quote) | |
| "The allele frequency of the alternate base is 33 divided by 53, or 0.62." | true | 33/53 = 0.6226 | |
| "Of the 33 alternate reads at position 250,527, 16 are forward and 17 are reverse" | true | Same default mpileup: `T` (forward) = 16, `t` (reverse) = 17 | |
| "The Genome in a Bottle benchmark for HG002 agrees, listing this position as a heterozygous `C>T`" | true | `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` row at POS 250527 reads `C  T  50  PASS ... GT:PS:DP:ADALL:AD:GQ  0/1:.:1247:175,167:335,335:553`, and `0/1` is heterozygous | |
| "The variant-calling dialog pre-fills a minimum alternate-allele frequency of 0.05" | true | `BAMVariantCallingDialogState.swift:75`, `self.minimumAlleleFrequencyText = "0.05"` | |
| "LGE runs `samtools markdup` for this" | true | `MarkdupService.swift:11-13`, "Runs the canonical samtools PCR-duplicate-marking pipeline... `samtools sort -n \| fixmate -m \| sort \| markdup`"; `cli-help/markdup.txt` overview reads "Mark PCR duplicates in BAM files using samtools markdup" | |
| "Duplicate marking finds rows that share a start and end position and flags the extras in the FLAG field, leaving the rows in place so nothing is lost." | true | `MarkdupService.swift:41-42` counts with flag filters `0x004` and `0x404`, i.e. it reads the 0x400 duplicate bit rather than removing rows | |
| "the fixture's BAM has none marked because the reads came from a PCR-free library" | true | Fixture README names the source as a "PCR-free" GIAB library; `samtools flagstat` reports `0 + 0 duplicates` | |
| "LGE's alignment-level primer trim runs `ivar trim` against a primer scheme and rewrites the BAM so that primer regions are soft-clipped." | true | `BAMPrimerTrimPipeline.swift:1` and `:39` build an `ivar trim` argv; `cli-help/bam.txt` documents `bam primer-trim` | |
| "some `ivar trim` options drop rows whose remaining aligned span is too short" | true | `cli-help/bam.txt`, `--ivar-min-length` "Minimum read length to retain after trimming (default: 30)", passed as `-m` at `BAMPrimerTrimPipeline.swift:48` | |
| "LGE ships four mappers" | true | `MappingTool.swift:9-13` defines `minimap2`, `bwaMem2`, `bowtie2`, `bbmap`; `cli-help/map.txt` lists the same four | |
| "`minimap2` is the default for long reads from Oxford Nanopore and PacBio and for many short-read jobs" | true | `cli-help/map.txt`, `--mapper` "(default: minimap2)"; `MappingTool.swift:260-270` returns a minimap2 mode for all four read classes | |
| "BWA-MEM2 and Bowtie2 are both offered for short paired-end Illumina data, and each is restricted to that role." | true | `MappingCompatibility.swift:86-93` blocks both unless `readClass == .illuminaShortReads`, with the message "only available for Illumina-style short-read mapping in v1" | |
| "BBMap handles messier reads where local alignment helps, up to 500 bases in its standard mode and 6,000 in its PacBio mode." | true | `MappingCompatibility.swift:44-45` declares `bbmapStandardMaxReadLength = 500` and `bbmapPacBioMaxReadLength = 6_000`, enforced at lines 144-154 | |
| "The fixture was mapped with `minimap2`'s `sr` preset, which is the short-read setting." | true | `MappingMode.defaultShortRead` maps to preset string `"sr"` (`MappingTool.swift:193`, `:219`); the fixture's `mapperInvocation.argv` contains `-x sr` and `mapping-result.json` records `modeID: "short-read-default"` | |
| "Its other presets cover Oxford Nanopore reads, PacBio reads, assembled contigs, and spliced RNA alignment" | true | `MappingTool.swift:194-198` defines `asm5`, `splice`, `map-ont`, `map-hifi`, `map-pb`, with display names Assembly-to-assembly, Spliced CDS/cDNA, Oxford Nanopore, PacBio HiFi, PacBio CLR | |
| "BBMap carries a standard and a PacBio mode of its own" | true | `MappingTool.swift:199-200`, `bbmapStandard` and `bbmapPacBio` | |
| "The mapper compatibility check compares your chosen mapper and preset against the read class it detects in your input and stops a combination it knows will fail, such as BWA-MEM2 on nanopore reads." | true | `MappingCompatibility.evaluate` (lines 47-105) takes tool, mode, and `readClass` and returns `.blocked` with a message; the BWA-MEM2 on non-Illumina case is lines 86-89 | |
| "Long-read mapping goes through `minimap2` for the same reason, since it is the one mapper here with no read-length ceiling." | true | `minimap2State` (lines 106-131) imposes no length limit; BWA-MEM2 and Bowtie2 are Illumina-only; BBMap is capped at 500/6,000. One nuance worth noting to the editor, BBMap standard mode is also *offered* for ONT reads at `MappingTool.swift:277`, but the 500-base cap blocks real nanopore data, so the sentence holds | |
| "Every mapping run writes a provenance sidecar named `mapping-provenance.json` beside the BAM it produced." | true | `MappingProvenance.filename` is referenced at `MappingDocumentStateBuilder.swift:173`, `MappingViewerBundlePublicationService.swift:701`, and `BAMAdoptMappingSubcommand.swift:133`; the file exists at `expected/mapping/mapping-provenance.json` | |
| "This one holds the mapper and its version, the preset, the exact command line, checksums of the input reads and reference, the read-group values written into the BAM header, and how long the run took." | true | The sidecar carries `mapper`/`mapperVersion` (2.31), `modeDisplayName` (Short-read), `mapperInvocation.argv`, `sha256` on all three `inputFiles`, `readGroup` (id/library/platform/platformUnit/sampleName), and `wallClockSeconds` | |
| "The fixture's copy records `minimap2` version 2.31 in short-read mode over 4.7 seconds." | true | `mapping-provenance.json`: `mapperVersion: "2.31"`, `modeDisplayName: "Short-read"`, `wallClockSeconds: 4.710162043571472` | |
| "A short-read BAM holds many short rows, 250 bases each in this fixture" | true | Fixture README names the reads "Illumina 2x250bp"; the quoted records are 249 and 250 bases (240M9S and 6S244M), consistent with 2x250 after adapter handling | |
| "The recommended variant caller differs with the read type. LoFreq, iVar, or bcftools for short reads, and Medaka or Clair3 for Oxford Nanopore." | true | `BundleVariantCallingModels.swift:5-10` defines exactly `lofreq`, `ivar`, `medaka`, `bcftools`, `clair3` | |
| "Four checks settle whether a BAM is worth building on, and all four are visible in the alignment viewport and the Inspector." | false | The Inspector's mapping rows (`MappingDocumentStateBuilder.swift:115-120`) carry Mapped Reads, Unmapped Reads, Total Reads, and Mapped Rate, but no mean depth and no coverage breadth. Those two appear in the mapping results table (`MappingContigTableView.swift:36-38`, columns "% Mapped", "Mean Depth", "Coverage Breadth") and, for depth, on the coverage track's own label (`ReadTrackRenderer.swift:490`, `"max: Nx  mean: N.Nx"`) | "Four checks settle whether a BAM is worth building on. The mapping results table reports the first three, the coverage track labels its own maximum and mean depth, and the Inspector records the mapped rate." |
| "The fixture reaches 99.77 percent, which is what you expect when the reads and the reference come from the same organism and region." | true | `samtools flagstat` `90990 + 0 mapped (99.77%)` | |
| "The fixture covers 99.99 percent of its slice, leaving 31 positions with no reads over them." | true | Breadth 0.999938 and 31 zero-depth positions from the `samtools depth` pass | |
| "LGE writes one for every BAM it produces and rebuilds a missing one on load" | true | `ManagedMappingPipeline.samtoolsIndex` runs on every mapping run; `MarkdupService.ensureFreshIndex` (line 39) rebuilds; `BAMImportService.resolveCreatedIndexURL` resolves an index after creation on import | |
| "Copy a BAM into a project without its index and LGE builds one when the file loads." | true | Same evidence as the row above | |
| "Mapping itself needs the read-mapping plugin pack." | true | `PluginPack.swift:474-479` defines pack `read-mapping` ("Read Mapping", packages minimap2/bwa-mem2/bowtie2, `isActive: true`); `cli-help/map.txt` says "Install the tools through the read-mapping plugin pack (`lungfish conda install read-mapping`)" | |
| "Reading a BAM that already exists needs no pack, because `samtools` comes with the Required Setup pack that LGE installs on first launch." | true | `third-party-tools-lock.json` lists `samtools` among its 17 tool environments, and `PluginPack.swift:431-432` places that lock's pack in `category: "Required Setup"` with `kind: .requiredSetup` | |
| "Docker Desktop is not needed anywhere in this chapter." | true | No mapping, markdup, or primer-trim path invokes a container. `NativeToolRunner` and `micromamba run` carry the fixture's five recorded steps | |
| "The fixture files are on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hg002-chr20, and the `README.md` in that folder carries the source, license, and citation for each one." | true | The README's Sources, License and citation, and Committed files sections carry all three | |
| CLI example: `lungfish-cli map --paired --mapper minimap2 --preset sr --reference ... --sample-name HG002 -o ... <R1> <R2>` | true | Every flag exists in `cli-help/map.txt` and in live `.build/debug/lungfish-cli map --help`. The two positional inputs match the `<fastq-files>` argument, and the filenames match the renamed fixture files `HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and `_R2` verified in `mapping-provenance.json.inputFASTQPaths` | |
| "`--paired` binds the two input files as read 1 and read 2 of one sample." | true | `cli-help/map.txt`, "--paired Input files are paired-end reads", and the overview "(--paired binds exactly two files as R1/R2 of that sample)" | |
| "the defaults are `minimap2` and the short-read preset" | true | `cli-help/map.txt` `--mapper ... (default: minimap2)`; `MappingTool.swift:262-263` returns `.defaultShortRead` for Illumina short reads | |
| "`--sample-name` names the sample in the BAM's read groups and in the output filenames." | true | `cli-help/map.txt`, "Sample name for BAM read groups and output naming"; the fixture's `@RG` line reads `ID:HG002 SM:HG002 LB:HG002 PL:ILLUMINA PU:HG002` and its output is `HG002.sorted.bam` | |
| "The command writes a coordinate-sorted, indexed BAM together with the `mapping-provenance.json` sidecar described above." | true | `cli-help/map.txt`, "Produces a coordinate-sorted, indexed BAM file"; the fixture header carries `SO:coordinate` and the folder holds `HG002.sorted.bam.bai` and `mapping-provenance.json` | |
| "`lungfish-cli bam` derives filtered alignment tracks, marks duplicates, trims primers, and attaches a mapping result to a reference bundle as a new alignment track." | true | `cli-help/bam.txt` subcommands `filter`, `markdup`, `primer-trim`, `adopt-mapping` (plus `annotate`, `annotate-best`, `annotate-cds-best`, which the sentence does not claim to exhaust) | |
| "`lungfish-cli markdup` marks duplicates on a BAM or on a whole folder of them." | true | `cli-help/markdup.txt`, argument `<path>` "Path to a BAM file or a directory containing BAMs" | |
| "no long-read plugin pack is user-reachable" (implied by the chapter never offering one) | true | `PluginPack.swift:823-831` defines the `long-read` pack without `isActive`, which defaults to `false` at line 345, and `activeOptionalPacks` filters on `$0.isActive` (lines 959, 965), so the pack never reaches the Plugin Manager. The chapter correctly routes long-read mapping through the `read-mapping` pack's minimap2 instead | |
| Front matter `parameters_refs: []` | true | The chapter documents no operation dialog and no settings, so the empty list is correct for a concept chapter | |
| Front matter `shots` lists every `<!-- SHOT -->` marker with a caption | true | The body holds one marker at line 140, `<!-- SHOT: bam-viewport-coverage-and-pileup -->`, and `shots:` holds exactly that id with a caption | |
| Every `glossary_refs` anchor resolves in GLOSSARY.md | true | All 22 anchors (`bam`, `bai`, `csi`, `alignment`, `mapping`, `mapper`, `coverage`, `depth`, `pileup`, `soft-clip`, `strand`, `strand-bias`, `cigar`, `mapq`, `flag`, `supplementary-alignment`, `allele-frequency`, `mark-duplicates`, `mapping-preset`, `provenance-sidecar`, `plugin-pack`, `variant-caller`) match a `{#anchor}` in `docs/user-manual/GLOSSARY.md` | |

## Notes for the editor

The four false rows are one defect. The chapter states that LGE chooses
between BAI and CSI on the data's behalf, and the app has no such logic. It
always writes BAI and reads either. The CSI glossary entry carries the same
error, "The alternative BAM index format Lungfish writes when a reference
sequence is longer than the 512-megabase limit", and the Bioinformatics
Educator owns that file, so the correction needs to reach `GLOSSARY.md` as
well as the chapter.

The fifth false row is smaller. Two of the four quality checks are not in
the Inspector.

One number outside this chapter's scope. The fixture README says "90,935 of
them mapped (99.77%)", which is the primary-mapped count, while
`mapping-result.json` records `mappedReads: 90990`, which counts the 55
supplementary rows too. Both are correct for what they measure and both
round to 99.77 percent, so the chapter's "99.77 percent of rows mapped" is
true either way. It is worth a line in the README so the two figures are not
read as a contradiction.

The pileup at 250,527 is worth keeping exactly as written. The numbers match
`samtools mpileup` at its default filtering, which is the column a caller
reads. Unfiltered, the same position shows 63 reads, 27 `C` and 36 `T`. If
the chapter ever gains a note on how the pileup is computed, that difference
is the thing to explain.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues on this chapter.

## Counts

56 true, 5 false, 0 unverifiable.
