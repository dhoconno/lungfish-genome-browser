# Fidelity review: 01-foundations/01-what-is-a-genome.md

Reviewed against the working-tree draft (not the committed version) on
2026-09-06. Ground truth used, in campaign order: the Swift source under
`Sources/`, a live run of `.build/debug/lungfish-cli` against the
`hbb-gene` fixture, the CLI help dumps, `parameters.yaml`, the reality map
`ground-truth/01-foundations.md`, and `CONSISTENCY.md`.

The live commands run for this review were

```
lungfish-cli import fasta docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb \
  --name HBB -o /tmp/hbb-fidelity-check
lungfish-cli bundle info "/tmp/hbb-fidelity-check/Reference Sequences/HBB.lungfishref"
```

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording when false |
|---|---|---|---|---|
| 1 | "how Lungfish Genome Explorer (LGE) points at a position, which is 1-based and inclusive, so the first base of a sequence is position 1 and not 0" | true | `Sources/LungfishApp/App/AppDelegate+SequenceMenu.swift:358-359` converts user input with `start - 1`, so input 1 maps to internal offset 0; `Sources/LungfishApp/Views/Viewer/EnhancedCoordinateRulerView.swift:1082` does the same | |
| 2 | "The HBB gene record is `NG_000007.3`, the RefSeqGene record for the beta-globin region of human chromosome 11." | true | `docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb:7-8` `ACCESSION NG_000007` / `VERSION NG_000007.3`; the DEFINITION block (lines 2-6) ends "RefSeqGene on chromosome 11" | |
| 3 | "This one is 81,706 bases long" | true | Fixture LOCUS line reads `81706 bp`; `bundle info` reports `Total Length : 81706 bp`; a direct count of the ORIGIN block returns 81706 | |
| 4 | "it carries eight genes and not only HBB" | true | `awk -F'\t' '!/^#/{print $3}' imported_annotations.gff3 \| sort \| uniq -c` returns `8 gene` | |
| 5 | "the HBB gene spans positions 70545 to 72152" | true | `docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb:542-543` `gene 70545..72152` with `/gene="HBB"` | |
| 6 | "it is written as `join(70595..70686,70817..71039,71890..72018)`" | true | `docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb:557` is that string verbatim, with `/gene="HBB"` on line 558 | |
| 7 | "The sixth amino acid of the mature beta-globin protein is glutamate, spelled by the codon `GAG`." | true | Translating the CDS join gives codons 1-8 `ATG GTG CAT CTG ACT CCT GAG GAG` and protein `MVHLTPEEK...`, matching the record's `/translation` at line 569. Codon 7 of the CDS is the first `GAG`; dropping the initiator methionine makes it residue 6 of the mature chain, which is the standard HbS numbering the fixture README also uses | |
| 8 | "Change the middle base of that codon from A to T and the codon becomes `GTG`, which specifies valine" | true | Bases 70613-70615 read `GAG`; substituting position 70614 `A` with `T` yields `GTG`, valine in the standard code | |
| 9 | "The fixture ships the record as `NG_000007.3.gb`, a GenBank flatfile." | true | `docs/user-manual/fixtures/hbb-gene/NG_000007.3.gb` exists and opens with a `LOCUS` line | |
| 10 | "Importing it takes well under a minute and needs no external tools, because reading sequence files is built into the app." | true | The import above completed in roughly one second with no conda environment provisioned; `Sources/LungfishIO/Formats/GenBank/GenBankReader.swift` is a native reader with no managed-tool dependency | |
| 11 | "Choose **File > Import Center...** (Cmd-Shift-I)" | true | `Sources/LungfishApp/App/MainMenu.swift:207-212` adds "Import Center…" to the File menu with `keyEquivalent: "i"` and `[.command, .shift]` | |
| 12 | "open its Reference Sequences tab" | true | `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift:179` `case .references: return "Reference Sequences"` is the tab title | |
| 13 | "Drop `NG_000007.3.gb` onto the Reference Sequences card." | true | `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift:512` `title: "Reference Sequences"` is a card on that tab; `parameters.yaml:1641` records the entry point "File > Import Center... > Reference Sequences > Reference Sequences" | |
| 14 | "LGE compresses and indexes the sequence and builds the bundle without asking you to confirm anything." | true | The bundle's `genome/` holds `sequence.fa.gz`, `sequence.fa.gz.fai`, and `sequence.fa.gz.gzi`; `parameters.yaml:1657-1663` records `settings: []` and the same no-confirmation note | |
| 15 | "Find the new bundle under `Reference Sequences/` in the sidebar" | true | `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift:20` `public static let folderName = "Reference Sequences"`; the live import wrote `/tmp/hbb-fidelity-check/Reference Sequences/HBB.lungfishref` | |
| 16 | "Because a GenBank record carries a feature table, the bundle arrives with an annotation track already attached" | true | `bundle info` reports one annotation track `imported_annotations` with 102 features; `parameters.yaml:1659-1661` states the same rule | |
| 17 | "Choose **Sequence > Go to Location...** (Cmd-L)" | true | `Sources/LungfishApp/App/MainMenu.swift:642-646` adds "Go to Location…" to the Sequence menu with `keyEquivalent: "l"` and no extra modifier mask, so the shortcut is Cmd-L | |
| 18 | "type `NG_000007:70613-70615`" (the imported contig name drops the version) | true | `bundle info` Chromosomes table lists `NG_000007`, and `manifest.json` `genome.chromosomes[0].name` is `NG_000007`. `Sources/LungfishWorkflow/Native/NativeBundleBuilder.swift:1493` `let chromName = record.locus.name` takes the LOCUS-line name, and the fixture's LOCUS line reads `NG_000007` while only the separate VERSION line carries `.3`. This settles the author's first flagged question | |
| 19 | "The viewport frames the three bases of the sickle cell codon, which read `GAG`." | true | Bases 70613-70615 of the fixture read `GAG`; `Sources/LungfishApp/App/AppDelegate+SequenceMenu.swift:358-362` maps the 1-based inclusive input to that window | |
| 20 | "Type the same coordinate into the position field on the ruler instead if you prefer. It accepts the same input and shows the placeholder `chr:start-end`." | true | `Sources/LungfishApp/Views/Viewer/EnhancedCoordinateRulerView.swift:181` `field.placeholderString = "chr:start-end"`; line 1066 documents the same accepted forms | |
| 21 | "a folder that macOS shows as one item and that carries the extension `.lungfishref`" | true | `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift:71` `let bundleName = "\(safeName).lungfishref"`; the live import produced the directory `HBB.lungfishref` | |
| 22 | "a `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its two indexes beside it, and `annotations/`, `variants/`, and `tracks/` folders hold anything attached to the sequence later" | true | The live bundle's root holds `manifest.json`, `genome/`, `annotations/`, `variants/`, `tracks/`, `metadata/`, and `provenance/`. `genome/` holds `sequence.fa.gz` plus `.fai` and `.gzi`, which are the two indexes | |
| 23 | "Select the reference in the sidebar and the Inspector shows a Provenance section" | true | `Sources/LungfishApp/Views/Inspector/Sections/ProvenanceSection.swift:32-84` builds the section from `DisclosureGroup`s, and the live import wrote `.lungfish-provenance.json` into the bundle for it to read | |
| 24 | "holding the accession, the source, the date, and a SHA-256 checksum" | **false** | The sidecar and the section carry no accession field. `.lungfish-provenance.json` records `createdAt`, `name`, `hostOS`, `appVersion`, an `options` block whose keys are `input_files`, `output_directory`, `source_url`, `bundle_path`, `identifier`, `compress_fasta`, and the three feature counts, and a `files` list whose entries carry `sha256`, `path`, `sizeBytes`, and `role`. `ProvenanceSection.swift:348` prints `sha256 <checksum>` and the section's seven blocks (lines 32-84) are Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON. There is no accession anywhere. The reality map's row 18 correction kept "the accession" from the old SARS-CoV-2 text, and it was wrong to keep for a local-file import | "holding the file it was built from, the date of the run, and a SHA-256 checksum for every file the import read and wrote" |
| 25 | "`NG_000007` is the name of the sequence, which the assembly literature calls the contig name." | true | Same evidence as row 18; `GLOSSARY.md:71` defines "Contig (in a reference)" as one named sequence in a reference bundle | |
| 26 | "It comes from the record's own identifier, which is why the import drops the trailing version and the coordinate does too." | true | `Sources/LungfishWorkflow/Native/NativeBundleBuilder.swift:1493` reads `record.locus.name`, and `Sources/LungfishIO/Formats/GenBank/GenBankReader.swift:412-416` parses that name from the LOCUS line, which for this record is `NG_000007` | |
| 27 | "`70613-70615` is the range, counted 1-based and inclusive, so it holds three bases and not two." | true | Same conversion evidence as row 1; the three bases returned are `GAG` | |
| 28 | "Hand LGE a coordinate whose contig cannot be matched to the loaded reference, even after its chromosome-name mapping runs, and it refuses." | **false** | The mapping half is right: `Sources/LungfishApp/Services/BundleDataProvider.swift:96-105` tries an exact name, then aliases, then `mapVCFChromosomes`. The refusal half is not. When the lookup fails, `Sources/LungfishApp/App/AppDelegate+SequenceMenu.swift:423-427` falls through to `navigateToPosition`, which ignores the contig argument entirely, validates the position against the sequence already loaded, and on success writes the unmatched name onto the frame (`Sources/LungfishApp/Views/Viewer/ViewerViewController.swift:3807-3852,3866-3870`). An unmatched contig with an in-bounds position navigates and relabels rather than refusing. The only refusal, "Position is outside the sequence bounds" (`AppDelegate+SequenceMenu.swift:374`), fires on the position, not the name | "Hand LGE a coordinate whose position falls outside the loaded sequence and it refuses. A contig name it cannot match is first put through its chromosome-name mapping, and if that fails too, the app navigates on the sequence already open rather than warning you. Checking that the name in the ruler is the one you meant is the first sign that you have loaded the wrong reference for your data" |
| 29 | "The record carries 8 genes, 5 mRNAs, 5 CDS features, and 13 exons, and 102 annotation features in total" | true | `awk -F'\t' '!/^#/{print $3}' imported_annotations.gff3 \| sort \| uniq -c` returns exactly `8 gene`, `5 mRNA`, `5 CDS`, `13 exon`, and the file holds 102 feature lines; `bundle info` reports `Features 102` | |
| 30 | "`70614` is the 1-based position, the middle base of the `GAG` codon at 70613 to 70615." | true | Base 70614 of the fixture is `A`, the middle base of `GAG` at 70613-70615 | |
| 31 | "`A` is the reference base, called REF in the language of VCF ... `T` is the observed base, called ALT." | true | `GLOSSARY.md:243` defines REF and ALT in exactly those terms | |
| 32 | "When REF and ALT are each one base long, the change is a single-nucleotide variant. An insertion makes REF one base and ALT several, and a deletion does the reverse." | true | `GLOSSARY.md:243` "A one-base REF and one-base ALT describe a SNP; longer REF or ALT describe insertions and deletions" | |
| 33 | "every variant in an LGE project is stored next to the accession of the reference it was called against" | true | Variant tracks live under the reference bundle's `variants/` folder, which the live bundle created alongside `genome/`; `Sources/LungfishCore/Bundles/BundleManifest.swift` carries the variants list inside the reference manifest | |
| 34 | "the variants table always shows the contig name in its first column" | **false** | `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView+Columns.swift:312-324` defines `variantColumnDefs` in display order as ID, Type, Chrom, Position, Ref, Alt, Quality, Filter, Samples, Source, Consequence, AA Change, and line 349 adds them to the table in that array order. Chrom is the third column, not the first. The header is also "Chrom", not "contig" | "the variants table always carries the contig in its Chrom column" |
| 35 | "In LGE you meet it first as a FASTQ file ... and later as a BAM file, which is the compact indexed form those reads take once aligned to a reference." | true | `Sources/LungfishIO/Formats/FASTQ/FASTQBundle.swift` is the FASTQ bundle model, and the mapping pipeline writes a sorted indexed BAM; the reality map row 3 records the same verdict | |
| 36 | "The trailing `.3` in `NG_000007.3` is a version number." | true | The fixture separates `ACCESSION NG_000007` (line 7) from `VERSION NG_000007.3` (line 8), which is what the trailing digit encodes | |
| 37 | "In a project, references sit under `Reference Sequences/`, files you brought from your own disk sit under `Imports/`, and files LGE fetched from a public archive sit under `Downloads/`." | true | `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift:20`; `Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift:432-435` writes to `Imports`; `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift:1949-1958` creates `Downloads` | |
| 38 | "Read or region extractions land under `Extractions/`." | true | `Sources/LungfishApp/Views/Viewer/ViewerViewController+Extraction.swift:573-580` `appendingPathComponent("Extractions", isDirectory: true)`; `CONSISTENCY.md` "Folders and files" lists the same | |
| 39 | "LGE, like every aligner and variant caller it wraps, treats every reference as linear." | true | `Sources/LungfishCore/Bundles/BundleManifest.swift` carries no circularity flag, and no mapper in `Sources/LungfishWorkflow/Mapping/MappingTool.swift` takes a circular option. Reality map row 8 records the same | |
| 40 | "LGE can assemble and classify bacterial data, but it still unrolls every reference at the curator's chosen origin." | true | `Sources/LungfishWorkflow/Conda/PluginPack.swift:668-718` ships SPAdes, MEGAHIT, SKESA, Flye, and Hifiasm; lines 771-822 ship Kraken2 and Bracken. This is the reality map's row 9 correction, applied verbatim | |
| 41 | "Confirm that the sequence viewport shows the length you expected, which is 81,706 bases for this record." | true | `bundle info` reports `Total Length : 81706 bp` and the chromosome row `NG_000007 81706` | |
| 42 | "a bundle built from a bare FASTA would show none" | true | `parameters.yaml:1659-1661` "A GenBank or EMBL record carries annotations, so importing one produces a bundle with an annotation track already attached, where a bare FASTA does not" | |
| 43 | "confirm that the Inspector's Provenance section names the file you imported" | true | The sidecar's `files` list carries the input entry with `role: input` and the full fixture path, and `ProvenanceSection.swift:59` renders the Files & Outputs block | |
| 44 | "Every reference imported into a project carries the provenance described above." | true | The live import wrote `.lungfish-provenance.json` into the bundle root with no flag asked for | |
| 45 | "every variant call keeps the reference accession in its file header, so a VCF you hand to a collaborator describes itself" | true | Reality map row 19 verified this against the bundled fixture VCFs, which carry `##contig` and `##reference` lines | |
| 46 | "The same import runs from `lungfish-cli`, which is the command-line tool that ships with LGE." | true | The command at the top of this file ran and produced the bundle; `CONSISTENCY.md` fixes the name as `lungfish-cli` | |
| 47 | Code block `lungfish-cli import fasta ... --name HBB --output-dir ~/Documents/hbb-example.lungfish` | true | `cli-help/import.txt` "import fasta" accepts `<input-file>`, `-o, --output-dir`, and `--name`; the same invocation ran successfully with `-o` | |
| 48 | "`--name` sets the display name of the reference the import creates, defaulting to the input filename." | true | `cli-help/import.txt` "--name <name> Display name for the reference (default: filename)"; `parameters.yaml:1650-1652` records the same. `bundle info` shows `Name : HBB` after `--name HBB` | |
| 49 | "`--output-dir` names the project directory the `.lungfishref` bundle is written into, defaulting to the current directory." | true | `cli-help/import.txt` "-o, --output-dir <output-dir> Output project directory (default: current directory)"; `parameters.yaml:1653-1655` records the same | |
| 50 | "Despite the subcommand name, the importer accepts GenBank as well as FASTA." | true | `cli-help/import.txt` "import fasta" argument reads "Path to the input reference (.fa/.fasta/.gb/.embl, optionally .gz/.bgz/.bz2/.xz/.zst)", and the live run imported a `.gb` file | |

## The three flagged questions, settled

**1. `NG_000007` or `NG_000007.3`.** `NG_000007`. The bundle builder takes
the chromosome name from the GenBank LOCUS line
(`Sources/LungfishWorkflow/Native/NativeBundleBuilder.swift:1493`
`let chromName = record.locus.name`, parsed at
`Sources/LungfishIO/Formats/GenBank/GenBankReader.swift:412-416`), and this
record's LOCUS line reads `NG_000007` while the version lives on the
separate VERSION line. `bundle info` confirms the chromosome is
`NG_000007`, 81706 bp. The chapter is right on rows 18, 25, and 26.

**2. The codon coordinates and the Glu6Val numbering.** Both right.
70613-70615 reads `GAG`, 70614 is the `A`, and substituting `T` gives
`GTG`. On the numbering, the CDS `join(70595..70686,70817..71039,71890..72018)`
places 70613 at offset 18, which is codon 7 of the CDS. The chapter avoids
the trap by saying "the sixth amino acid of the mature beta-globin
protein", and the mature chain drops the initiator methionine, so CDS codon
7 is mature residue 6. The record's own `/translation` (line 569) begins
`MVHLTPEEK`, whose residue 7 is the first `E` and whose mature residue 6 is
the same glutamate. The wording is correct as written, and would become
wrong if anyone rewrote it as "codon 6 of the CDS".

**3. Menu paths, dialog names, and Inspector elements.** The menu paths,
shortcuts, tab, card, dialog title, and ruler placeholder all check out
(rows 11, 12, 13, 17, 20). Two Procedure-adjacent surface claims do not.
Row 24 attributes an accession to the Provenance section that the section
never shows for a local-file import, and row 34 puts the contig in the
variants table's first column when it is the third and is headed "Chrom".

## Two notes outside the claim table

These are not app-claim verdicts, so they carry no verdict of their own,
but the chapter owner should see them.

The front matter sets `parameters_refs` nowhere, yet the chapter documents
`--name` and `--output-dir` from `import.reference`
(`parameters.yaml:1638-1663`). The campaign rule is that a chapter
documenting an operation cites its ids in `parameters_refs`.

`CONSISTENCY.md` gained a "Before you start, fixed sentences" block after
the chapter 1 reader team, requiring two fixed sentences about opening a
project and downloading `NG_000007.3.gb` from the GitHub fixtures path. The
draft's Before you start section carries neither.

## Counts

True 47, false 3, unverifiable 0.
