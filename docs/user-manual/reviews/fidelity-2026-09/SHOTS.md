# Screenshot manifest: user manual fidelity campaign, 2026-09

One row per `<!-- SHOT: ... -->` marker in `docs/user-manual/chapters`, sorted by
chapter directory, then file, then line. Captions are copied from each chapter's
front matter `shots:` list. The fixture column names the project or fixture the
state is built from, `demo-project` meaning `~/Desktop/lge-docs/LGE Manual Demo.lungfish`
and `williams` meaning `~/Desktop/lge-docs/32566_MS267_Williams1.lungfish`.

Status is `new` when no PNG exists for the id, `stale` when a PNG exists but the
chapter was rewritten in this campaign and its Fable gate did not say the shot is
unchanged, and `existing` otherwise. No gate in this campaign declared a shot
unchanged, so there are no `existing` rows. Ten PNGs survive from the 2026-05
capture pass, all of them for chapters rewritten this month, so all ten are stale.

Two more things the checker cannot see are worth reading before a capture session.
The checker keys a shot on its part directory rather than its chapter file, so a
marker id reused across two parts needs one PNG per part directory. Eight ids
repeat across files, and three of those cross a part boundary. Separately, the ten
surviving PNGs sit one directory deeper than the checker looks, under
`assets/screenshots/<part>/<chapter>/`, so recapturing them writes to
`assets/screenshots/<part>/` and the old copies should be deleted rather than moved.

## Shots

| Chapter dir | File | Line | Id | Caption | Status | Fixture or project | App state | Prerequisites |
|---|---|---|---|---|---|---|---|---|
| 01-foundations | 01-what-is-a-genome.md | 74 | `import-center-reference-card` | The Import Center with the Reference Sequences tab open and the Reference Sequences card ready to accept a dropped file. | captured | demo-project | the Import Center on its Reference Sequences tab with the Reference Sequences card | hbb-gene fixture staged on disk |
| 01-foundations | 01-what-is-a-genome.md | 80 | `hbb-record-in-sequence-viewport` | The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases. | captured | demo-project | the HBB record open in the sequence viewport with its annotation lane | hbb-gene imported with its annotation track |
| 01-foundations | 01-what-is-a-genome.md | 84 | `go-to-location-hbb-codon` | The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record. | captured | demo-project | the Go to Location dialog holding the sickle cell codon coordinate | HBB record open in the sequence viewport |
| 01-foundations | 02-sequencing-reads.md | 235 | `fastq-viewport-summary-cards` | The FASTQ viewport for the HG002 chromosome 20 slice, showing the nine summary cards above the three sparkline charts. | captured | demo-project | the FASTQ viewport with the nine summary cards above the three sparklines | HG002 chr20 bundle imported and its QC summary computed |
| 01-foundations | 02-sequencing-reads.md | 241 | `fastq-viewport-reads-tab` | The Reads tab of the FASTQ viewport, listing the first records with their read identifier, length, mean quality, and sequence. | captured | demo-project | the Reads tab of the FASTQ viewport listing the first records | Same bundle as the summary-cards shot |
| 01-foundations | 03-amplicon-vs-shotgun.md | 121 | `primer-scheme-picker-built-in` | The Primer Scheme menu in the primer-trim dialog, open on its Built-in section listing the eight schemes LGE ships. | new | demo-project | the Primer Scheme menu of the primer-trim dialog open on its Built-in section | An alignment track selected so the primer-trim dialog opens |
| 01-foundations | 04-alignment-files.md | 140 | `bam-viewport-coverage-and-pileup` | The chr20 10.0-10.5Mb bundle in the demo project with its HG002 minimap2 alignment track selected, showing the coverage track above the stacked reads. | captured | demo-project | the chr20 bundle with the HG002 minimap2 track showing coverage above stacked reads | The demo project mapping run already present |
| 01-foundations | 05-variants-and-vcf.md | 180 | `variants-tab-hg002-bcftools` | The chr20 10.0-10.5Mb bundle in the demo project with the HG002 bcftools variant track open on the Variants tab of the table drawer. | captured | demo-project | the chr20 bundle with the bcftools track open on the Variants tab of the table drawer | bcftools variant track present in the demo project |
| 01-foundations | 05-variants-and-vcf.md | 188 | `variants-pass-chip-and-tokens` | The filter chips revealed by the Presets button, with the PASS chip switched on and the other smart-filter tokens beside it. | captured | demo-project | the Presets chip strip with the PASS chip on | Variants tab open with a track loaded |
| 01-foundations | 05-variants-and-vcf.md | 204 | `inspector-variant-selected` | The Inspector showing one selected variant, with its position, alleles, quality, filter, and INFO fields broken out. | captured | demo-project | the Inspector on one selected variant row | A variant row selected in the Variants tab |
| 01-foundations | 06-the-lungfish-project.md | 74 | `welcome-window` | The Lungfish Genome Explorer Welcome window, with the Create Project and Open Project cards, the Recent Projects list, and the required-setup panel below them. | stale | demo-project | the Welcome window with its Create and Open cards and the Recent Projects list | No project window open, and no user-specific paths in the recent list |
| 01-foundations | 06-the-lungfish-project.md | 82 | `empty-project-window` | A new empty project window with the sidebar on the left, an empty viewport in the centre, and the Inspector on the right. | stale | demo-project | a newly created empty project window, sidebar and empty viewport and Inspector | A throwaway empty project, not the demo project |
| 01-foundations | 06-the-lungfish-project.md | 98 | `sidebar-folder-conventions` | The sidebar of the demo project, showing the Analyses group above the Imports, Reference Sequences, Primer Schemes, and Extractions folders. | captured | demo-project | the sidebar with Analyses above Imports, Reference Sequences, Primer Schemes, and Extractions | Gate: the demo Analyses folders carry script-chosen names, so rename them to the app shape first or note the difference |
| 01-foundations | 06-the-lungfish-project.md | 137 | `file-export-menu` | The File > Export submenu open, showing the sequence, annotation, FASTQ, metadata, and image export items above the Provenance submenu. | new | demo-project | the File > Export submenu open above the Provenance submenu | A bundle selected so the export items are enabled |
| 01-foundations | 06-the-lungfish-project.md | 151 | `inspector-fastq-selected` | The demo project with a paired-end FASTQ bundle selected in the sidebar, the FASTQ operations view filling the viewport, and the Inspector showing dataset statistics and sample metadata. | captured | demo-project | the paired-end FASTQ bundle selected, FASTQ operations view in the viewport, Inspector on the right | HG002 chr20 pair imported into the demo project |
| 01-foundations | 06-the-lungfish-project.md | 157 | `inspector-fastq-detail` | The Inspector in close-up for the same FASTQ selection, showing read counts, length and quality statistics, ingestion settings, the pipeline that produced the dataset, and the editable metadata fields. | captured | demo-project | the same Inspector in close-up on read counts, statistics, ingestion settings, and metadata fields | Same selection as inspector-fastq-selected |
| 01-foundations | 06-the-lungfish-project.md | 167 | `operations-panel-row` | An Operations Panel row mid-run, expanded to show the CLI command, the log buttons, the running log output, and the progress bar. | stale | demo-project | an Operations Panel row mid-run, expanded to its CLI command, log buttons, and progress bar | A short operation started on the demo project so the row is genuinely running |
| 01-foundations | 06-the-lungfish-project.md | 175 | `operations-panel-right-click-menu` | The right-click menu on an Operations Panel row, showing Run Again, Copy CLI Command, Copy Log, View Log, Reveal Log in Finder, and Cancel. | stale | demo-project | the right-click menu on an Operations Panel row | At least one finished operation in the panel |
| 01-foundations | 07-plugin-packs.md | 73 | `plugin-manager-window` | The Plugin Manager on the Packs tab, with the Required Setup section above the Optional Tools section and the Read Mapping card showing its three mappers. | captured | none (app chrome) | the Plugin Manager on its Packs tab with Required Setup above Optional Tools | Plugin Manager opened with Tools > Plugin Manager... (Cmd-Shift-B) |
| 01-foundations | 07-plugin-packs.md | 112 | `plugin-manager-offline-commands` | The offline strip at the foot of one pack card, showing the two greyed command lines and the Copy button beside them. | captured | none (app chrome) | the offline strip at the foot of one pack card with its Copy button | Plugin Manager Packs tab |
| 01-foundations | 07-plugin-packs.md | 127 | `plugin-manager-installed-tab` | The Installed tab with one environment row expanded to list the packages and versions inside it, and the Check for Tool Updates button above the list. | captured | none (app chrome) | the Installed tab with one environment row expanded | At least one managed environment installed |
| 01-foundations | 07-plugin-packs.md | 149 | `plugin-manager-databases-tab` | The Databases tab, with installed databases beside ones offering a Download button, the recommended-database banner at the top, and the total storage readout at the foot. | captured | none (app chrome) | the Databases tab with the recommended banner and the storage readout | Plugin Manager open |
| 01-foundations | 08-provenance-and-reproducibility.md | 72 | `inspector-provenance-section` | The chr20 reference bundle selected in the demo project, with the Inspector's Provenance section open on the right showing Run Summary above the Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON blocks. | captured | demo-project | the chr20 reference bundle selected with the Inspector Provenance section open | Demo project runs already recorded so the sidecars exist |
| 01-foundations | 08-provenance-and-reproducibility.md | 78 | `provenance-lineage-step-expanded` | The Provenance section's Lineage block with one bcftools step expanded, showing that step's own Command, Inputs, Outputs, Exit Status, and Wall Time. | new | demo-project | the Lineage block with one bcftools step expanded | Provenance section open on the chr20 bundle |
| 01-foundations | 08-provenance-and-reproducibility.md | 82 | `file-export-menu` | The File > Export submenu open, showing the sequence, annotation, FASTQ, metadata, and image export items above the Provenance submenu. | new | demo-project | the File > Export submenu open above the Provenance submenu | A bundle selected so the export items are enabled |
| 01-foundations | 08-provenance-and-reproducibility.md | 86 | `provenance-export-folder` | The exported provenance folder open in Finder, with the primary artifact beside the provenance subdirectory of copied run records. | new | demo-project | the exported provenance folder open in Finder | A provenance export run first, and Finder access granted for the session |
| 01-foundations | 08-provenance-and-reproducibility.md | 146 | `provenance-signing-settings` | Settings > General > Provenance Signing, showing the Off, Local, and Cosign Plan provider choices above the local signing key field, the public key path field, and the Save Signing Key and Clear Signing Key buttons. | captured | none (Settings) | Settings > General > Provenance Signing with its provider choices and key fields | No real signing key in the fields |
| 02-sequences | 01-importing-and-viewing.md | 76 | `import-center-reference-card` | The Import Center with the Reference Sequences tab open and the Reference Sequences card ready to accept a dropped file. | captured | demo-project | the Import Center on its Reference Sequences tab with the Reference Sequences card | hbb-gene fixture staged on disk |
| 02-sequences | 01-importing-and-viewing.md | 84 | `hbb-record-in-sequence-viewport` | The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases. | captured | demo-project | the HBB record open in the sequence viewport with its annotation lane | hbb-gene imported with its annotation track |
| 02-sequences | 01-importing-and-viewing.md | 98 | `import-center-annotation-track-alert` | The Import Annotation Track alert, showing the Reference popup above the Track Name and Track ID fields. | new | demo-project | the Import Annotation Track alert with Reference, Track Name, and Track ID | An annotation file dropped onto the Import Center |
| 02-sequences | 01-importing-and-viewing.md | 146 | `go-to-location-hbb-codon` | The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record. | captured | demo-project | the Go to Location dialog holding the sickle cell codon coordinate | HBB record open in the sequence viewport |
| 02-sequences | 01-importing-and-viewing.md | 158 | `hbb-annotation-context-menu` | The right-click menu on the HBB gene feature in the annotation lane, with the Copy submenu open. | new | demo-project | the right-click menu on the HBB feature with the Copy submenu open | HBB record open with annotations drawn |
| 02-sequences | 01-importing-and-viewing.md | 174 | `translation-tool-hbb-cds` | The translation tool opened from the window toolbar, with its Mode, Genetic Code, and Color Scheme controls above the Apply button. | new | demo-project | the translation tool from the toolbar with Mode, Genetic Code, and Color Scheme | HBB CDS selected in the viewport |
| 02-sequences | 02-downloading-from-ncbi.md | 71 | `ncbi-search-dialog` | The database search dialog on its GenBank & Genomes pane, with the Mode picker on Nucleotide, the RefSeq Only and Include GFF3 Annotations checkboxes below it, and the accession typed into the query field. | captured | none (network) | the database search dialog on GenBank & Genomes with the accession typed in | Network reachable, human-mito accession NC_012920.1 |
| 02-sequences | 02-downloading-from-ncbi.md | 75 | `ncbi-advanced-filters` | The Advanced Search Filters panel expanded under the query field, showing the Organism, Location, Gene, Author, and Journal fields alongside the Molecule Type, Sequence Length, Publication Date, and Sequence Properties controls. | captured | none (network) | the Advanced Search Filters panel expanded under the query field | Same dialog as ncbi-search-dialog |
| 02-sequences | 02-downloading-from-ncbi.md | 79 | `ncbi-results-download-selected` | The results list with the NC_012920.1 record ticked and the primary button reading Download Selected instead of Search. | captured | none (network) | the results list with NC_012920.1 ticked and the button reading Download Selected | A completed NCBI search |
| 02-sequences | 02-downloading-from-ncbi.md | 85 | `ncbi-bundle-in-sidebar` | The downloaded NC_012920.1 reference bundle under the project's Downloads folder in the sidebar, open in the sequence viewport with its NCBI GFF3 Annotations track drawn above the bases. | new | demo-project | the downloaded NC_012920.1 bundle under Downloads, open with its GFF3 track | The NCBI download completed into the demo project |
| 02-sequences | 02-downloading-from-ncbi.md | 197 | `pathoplexus-pane` | The Pathoplexus pane after the access and benefit sharing notice is accepted, showing the organism chips above the shared query field. | new | none (network) | the Pathoplexus pane after the access and benefit sharing notice is accepted | The notice accepted once in this session |
| 02-sequences | 03-extracting-and-comparing.md | 70 | `hbb-record-in-sequence-viewport` | The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases. | captured | demo-project | the HBB record open in the sequence viewport with its annotation lane | hbb-gene imported with its annotation track |
| 02-sequences | 03-extracting-and-comparing.md | 78 | `go-to-location-hbb-codon` | The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record. | captured | demo-project | the Go to Location dialog holding the sickle cell codon coordinate | HBB record open in the sequence viewport |
| 02-sequences | 03-extracting-and-comparing.md | 84 | `extract-region-dialog` | The Extract Sequence sheet opened by Extract Visible Region, with its Action picker, its Source summary, the 5' Flank and 3' Flank fields with their preset buttons, the Options toggles, and the Extract button. | captured | demo-project | the Extract Sequence sheet from Extract Visible Region | A visible region selected in the HBB record |
| 02-sequences | 03-extracting-and-comparing.md | 98 | `hbb-annotation-context-menu` | The right-click menu on the HBB gene feature in the annotation lane, with the Copy submenu open. | new | demo-project | the right-click menu on the HBB feature with the Copy submenu open | HBB record open with annotations drawn |
| 02-sequences | 03-extracting-and-comparing.md | 134 | `find-orfs-dialog` | The Find ORFs dialog with its Reading Frames, Translation, Output, and Options groups above the Run button. | captured | demo-project | the Find ORFs dialog with its four control groups | A sequence record open |
| 02-sequences | 04-aligning-sequences.md | 82 | `mafft-dialog` | The MAFFT pane of the operations dialog, with the scope summary line above the Strategy popup and the collapsed Advanced Options group. | captured | primate-mito | the MAFFT pane of the operations dialog with its Strategy popup | primate-mito fixture imported |
| 02-sequences | 04-aligning-sequences.md | 158 | `alignment-viewport-primate-mito` | The primate mitochondrial alignment open in the alignment viewport, showing the resizable name gutter, the pinned comparison row above the five sequences, the column header, and the conservation overview strip. | captured | primate-mito | the primate mitochondrial alignment in the alignment viewport | A finished MAFFT run |
| 02-sequences | 04-aligning-sequences.md | 194 | `export-alignment-sheet` | The Export Alignment sheet, with its Destination choices above the Sequences gap choice and the Format popup. | new | primate-mito | the Export Alignment sheet with Destination, gap choice, and Format | An alignment open in the viewport |
| 02-sequences | 05-building-trees.md | 74 | `iqtree-dialog` | The Phylogenetic Tree Operations dialog, with the Output Name and Model fields above the Branch Support group and the collapsed Advanced Options group. | new | primate-mito | the Phylogenetic Tree Operations dialog | An alignment selected |
| 02-sequences | 05-building-trees.md | 152 | `tree-viewport-primate-mito` | The primate mitochondrial tree open in the tree viewport, with the summary line, the Phylogram and Cladogram control, and the Nodes drawer listing all eight nodes. | captured | primate-mito | the primate mitochondrial tree with the Nodes drawer listing eight nodes | A finished IQ-TREE run |
| 03-reads | 01-importing-fastq.md | 93 | `import-center-sequencing-reads-tab` | The Sequencing Reads tab of the Import Center, showing its cards with Sequencing Read Files among them. | captured | demo-project | the Sequencing Reads tab of the Import Center | hg002-chr20 fixture staged on disk |
| 03-reads | 01-importing-fastq.md | 99 | `import-fastq-configuration-sheet` | The Import FASTQ configuration sheet for the HG002 chromosome 20 pair, with the summary reading R1 and R2 on separate lines above the Platform, Pairing, Quality Binning, and compression controls. | new | demo-project | the Import FASTQ sheet for the HG002 pair with R1 and R2 on separate lines | The HG002 chr20 pair chosen in the file picker |
| 03-reads | 01-importing-fastq.md | 107 | `sidebar-after-import` | The sidebar after the paired-end import, showing the new HG002 chromosome 20 bundle under Imports. | captured | demo-project | the sidebar with the new HG002 chr20 bundle under Imports | The paired-end import finished |
| 03-reads | 01-importing-fastq.md | 147 | `fastq-viewport-summary-cards` | The FASTQ viewport for the HG002 chromosome 20 slice, showing the nine summary cards above the three sparkline charts. | captured | demo-project | the FASTQ viewport with the nine summary cards above the three sparklines | HG002 chr20 bundle imported and its QC summary computed |
| 03-reads | 02-downloading-from-sra.md | 67 | `sra-runs-pane` | The Database Browser on its SRA Runs pane, with the Import Accessions button above the query field and the Advanced Search Filters panel expanded to show Platform, Strategy, Layout, Min Size (Mbases), Publication Date, and Max Results. | captured | none (network) | the Database Browser on SRA Runs with the Advanced Search Filters panel expanded | Network reachable |
| 03-reads | 02-downloading-from-sra.md | 73 | `sra-results-download-selected` | The results list with the SRR32909537 run ticked and the dialog's primary button at the bottom of the window reading Download Selected instead of Search. | captured | none (network) | the results list with SRR32909537 ticked and the button reading Download Selected | A completed SRA search |
| 03-reads | 02-downloading-from-sra.md | 77 | `sra-import-configuration-sheet` | The Import FASTQ configuration sheet as it opens for an SRA download, with Platform on Illumina and Pairing on Paired-end, both read from the run's archive metadata. | new | none (network) | the Import FASTQ sheet as it opens for an SRA download, Illumina and Paired-end prefilled | The SRA download done ahead of the session so the sheet opens without a wait |
| 03-reads | 02-downloading-from-sra.md | 83 | `sra-bundle-in-sidebar` | The downloaded SRR32909537 read bundle under the project's Imports folder in the sidebar, open in the FASTQ viewport. | new | demo-project | the downloaded SRR32909537 bundle under Imports, open in the FASTQ viewport | The SRA download completed into the demo project |
| 03-reads | 03-quality-control.md | 73 | `fastq-viewport-summary-cards` | The FASTQ viewport for the HG002 chromosome 20 slice, showing the nine summary cards above the three sparkline charts. | captured | demo-project | the FASTQ viewport with the nine summary cards above the three sparklines | HG002 chr20 bundle imported and its QC summary computed |
| 03-reads | 03-quality-control.md | 77 | `fastq-sparkline-popover` | The Q / Position sparkline clicked open into its full-size popover, showing per-position quality falling away over the last ten bases of the read. | captured | demo-project | the Q / Position sparkline clicked open into its full-size popover | QC summary present on the bundle |
| 03-reads | 03-quality-control.md | 83 | `refresh-qc-summary-dialog` | The FASTQ/FASTA Operations window on Refresh QC Summary, with the HG002 chromosome 20 bundle listed as the input and the Output Strategy control below. | captured | demo-project | the FASTQ/FASTA Operations window on Refresh QC Summary | HG002 chr20 bundle selected in the sidebar |
| 03-reads | 03-quality-control.md | 135 | `fastq-viewport-reads-tab` | The Reads tab of the FASTQ viewport, listing the first records with their read identifier, length, mean quality, and sequence. | captured | demo-project | the Reads tab of the FASTQ viewport listing the first records | Same bundle as the summary-cards shot |
| 03-reads | 04-trimming-and-filtering.md | 90 | `trimming-dialog` | The FASTQ/FASTA Operations window on the fastp Adapter + Quality Trim pane at its defaults, with Threshold 20, Window Size 4, Mode on Cut Right, and Adapter Mode on Auto-Detect. | captured | demo-project | the fastp Adapter + Quality Trim pane at its defaults | HG002 chr20 bundle selected |
| 03-reads | 04-trimming-and-filtering.md | 100 | `trim-operation-row` | The Operations Panel with the finished trim row expanded, showing its state, elapsed time, and command line. | new | demo-project | the Operations Panel with the finished trim row expanded | A trim run completed on the demo project |
| 03-reads | 04-trimming-and-filtering.md | 110 | `length-filter-readiness` | The Filter by Read Length pane with both bounds empty, showing the readiness line reading Enter a minimum, a maximum, or both. | captured | demo-project | the Filter by Read Length pane with both bounds empty and its readiness line | FASTQ/FASTA Operations window open |
| 03-reads | 04-trimming-and-filtering.md | 126 | `primer-trimming-literal-pane` | The Primer Trimming pane with Primer Source on Literal Sequence, showing the Primer Sequence field above the three compact fields labelled k, mink, and hdist. | captured | demo-project | the Primer Trimming pane with Primer Source on Literal Sequence | FASTQ/FASTA Operations window open |
| 03-reads | 05-decontamination.md | 95 | `human-scrub-dialog` | The Remove Human Reads pane, with the Database row in the Inputs section holding the managed human database beside Replace... and Clear buttons, and the settings pane below it holding no controls. | captured | demo-project | the Remove Human Reads pane with the managed human database in the Inputs row | The human scrub database installed |
| 03-reads | 05-decontamination.md | 111 | `low-complexity-pane` | The Low-Complexity Filter pane, showing the Entropy Threshold slider at 0.60 with the Advanced disclosure open on the Window and K-mer fields. | captured | demo-project | the Low-Complexity Filter pane with the Advanced disclosure open | FASTQ/FASTA Operations window open |
| 03-reads | 05-decontamination.md | 115 | `remove-duplicates-preset-picker` | The Remove Duplicates pane with the Preset picker open on its six choices, Exact PCR selected. | new | demo-project | the Remove Duplicates pane with the Preset picker open on Exact PCR | FASTQ/FASTA Operations window open |
| 03-reads | 06-subsetting-and-extraction.md | 93 | `search-subsetting-menu` | The Tools > Search & Subsetting submenu, listing the five subsetting and extraction operations. | new | demo-project | the Tools > Search & Subsetting submenu | A FASTQ bundle selected so the items are enabled |
| 03-reads | 06-subsetting-and-extraction.md | 103 | `subsample-by-count-pane` | The Subsample by Count pane with its single Count field and the Output Strategy picker below it. | captured | demo-project | the Subsample by Count pane with its Count field and Output Strategy picker | FASTQ/FASTA Operations window open |
| 03-reads | 06-subsetting-and-extraction.md | 109 | `select-reads-by-sequence-pane` | The Select Reads by Sequence pane at its defaults, showing Search End on 5' End, Min Overlap 16, Error Rate 0.15, and Keep Matched Reads on. | captured | demo-project | the Select Reads by Sequence pane at its defaults | FASTQ/FASTA Operations window open |
| 03-reads | 07-ont-runs.md | 84 | `ont-import-configuration-sheet` | The Import FASTQ configuration sheet as it opens for an Oxford Nanopore run folder, with Platform reading Oxford Nanopore and the recipe checkbox offering the two nanopore demultiplexing recipes. | new | demo-project | the Import FASTQ sheet for a nanopore run folder with the recipe checkbox | hg002-long-reads staged as a run folder |
| 03-reads | 07-ont-runs.md | 88 | `ont-barcode-sheet-controls` | The Barcode Sheet and Demux Folder controls that appear on the configuration sheet once a nanopore demultiplexing recipe is chosen. | new | demo-project | the Barcode Sheet and Demux Folder controls once a demultiplexing recipe is chosen | Same sheet with a nanopore recipe ticked |
| 03-reads | 07-ont-runs.md | 92 | `sidebar-after-ont-import` | The sidebar after importing the HG002 long reads as a run folder, showing the barcode01 bundle at the top level of the project. | new | demo-project | the sidebar with the barcode01 bundle at the top level | The run-folder import finished |
| 03-reads | 07-ont-runs.md | 102 | `demultiplex-barcodes-pane` | The Demultiplex Barcodes pane of the FASTQ/FASTA Operations dialog, showing Barcode Source, Built-In Kit, Engine, Location, the two distance fields, Error Rate, and Trim Barcodes, with Output Strategy at the foot of the pane. | captured | demo-project | the Demultiplex Barcodes pane of the FASTQ/FASTA Operations dialog | A nanopore bundle selected |
| 03-reads | 08-read-processing.md | 68 | `read-processing-menu` | The Tools > Read Processing submenu open, showing its six operations. | new | demo-project | the Tools > Read Processing submenu open on its six operations | A FASTQ bundle selected |
| 03-reads | 08-read-processing.md | 218 | `merge-overlapping-pairs-pane` | The Merge Overlapping Pairs pane of the FASTQ/FASTA Operations dialog, with the Strictness segments set to Normal and the Minimum Overlap field reading 12. | captured | demo-project | the Merge Overlapping Pairs pane with Strictness on Normal | A paired-end bundle selected |
| 03-reads | 08-read-processing.md | 225 | `sidebar-after-merge` | The sidebar after a merge run, showing the new bundle under Analyses. | new | demo-project | the sidebar with the new merged bundle under Analyses | A merge run completed |
| 03-reads | 08-read-processing.md | 283 | `orient-reads-pane` | The Orient Reads pane, showing the Word Length field, the Database Mask segments, the Extra arguments field, and the reference chosen in the Inputs section. | captured | demo-project | the Orient Reads pane with its reference chosen in the Inputs section | A reference bundle available in the project |
| 04-alignments | 01-mapping-reads-to-a-reference.md | 77 | `tools-mapping-submenu` | The open Tools > Mapping submenu, showing its five items, minimap2..., BWA-MEM2..., Bowtie2..., BBMap..., and Viral Recon.... | new | demo-project | the Tools > Mapping submenu open on its five items | A read bundle and a reference selected so the items enable |
| 04-alignments | 01-mapping-reads-to-a-reference.md | 85 | `mapping-wizard-overview` | The Map Reads (minimap2) wizard with the HG002 reference and the Short-read preset chosen, the Input Compatibility readout reporting a match, and the collapsed Read Group and Advanced Settings disclosures beneath it. | captured | demo-project | the Map Reads (minimap2) wizard with the Short-read preset and the compatibility readout | HG002 reference and read bundle in the project |
| 04-alignments | 01-mapping-reads-to-a-reference.md | 128 | `mapping-wizard-advanced` | The Advanced Settings disclosure of the mapping wizard, expanded to show the Threads, Secondary alignments, Supplementary, Min mapping quality, and Extra arguments controls. | captured | demo-project | the wizard Advanced Settings disclosure expanded | Same wizard as mapping-wizard-overview |
| 04-alignments | 01-mapping-reads-to-a-reference.md | 152 | `alignment-inspector-stats` | The Inspector for the new alignment track, showing Total Mapped, Total Unmapped, Mapped %, Chromosomes, and Est. Coverage above the collapsed Flag Statistics list. | captured | demo-project | the Inspector for the new alignment track above the collapsed Flag Statistics list | A finished mapping run |
| 04-alignments | 02-reading-an-alignment.md | 86 | `bam-viewport-overview` | The alignment viewport for the HG002 chromosome 20 slice, with the coverage curve above the stacked reads, the Depth key and percent-covered figure at the left-hand edge of the coverage strip, and the max and mean label at its right-hand edge. | captured | demo-project | the alignment viewport with the coverage curve above the stacked reads | The demo mapping run present |
| 04-alignments | 02-reading-an-alignment.md | 92 | `pileup-zoom` | The pileup at position 2,078 of the HG002 chromosome 20 slice, with matching bases drawn as dots and the alternate A drawn as a coloured letter on both strands. | captured | demo-project | the pileup at position 2,078 with the alternate A on both strands | Zoomed to that coordinate in the chr20 slice |
| 04-alignments | 02-reading-an-alignment.md | 98 | `extract-reads-region-menu` | The context menu over a selected stretch of the alignment track, with Extract Reads in Selected Region... showing beneath Copy Visible Region, Copy Visible Region as FASTA, and Extract Visible Region... | new | demo-project | the context menu over a selected stretch of the alignment track | A region selected on the alignment track |
| 04-alignments | 02-reading-an-alignment.md | 108 | `view-settings-alignment-tab` | The Alignment tab of the Inspector's View Settings, showing the Visible Alignment picker, Show reads, Minimum alignment confidence, Coverage scale, and the three Read Inclusion toggles. | captured | demo-project | the Alignment tab of the Inspector View Settings | An alignment track open |
| 04-alignments | 02-reading-an-alignment.md | 124 | `view-settings-reads-tab` | The Reads tab of the Inspector's View Settings, showing the row controls, the Read display budget slider, and the base and strand toggles beneath them. | captured | demo-project | the Reads tab of the Inspector View Settings | An alignment track open |
| 04-alignments | 03-primer-trimming.md | 81 | `primer-trim-scheme-menu` | The Primer Trim dialog with the Primer Scheme menu open, showing the eight schemes under the Built-in heading. | new | sarscov2-srr36291587 | the Primer Trim dialog with the Primer Scheme menu open on its Built-in heading | A SARS-CoV-2 alignment track present |
| 04-alignments | 03-primer-trimming.md | 87 | `primer-trim-dialog-target` | The Primer Trim dialog's Target section, showing the Alignment Track menu, the pre-filled Output Track Name field, and the note that reads without matching primers are retained. | captured | sarscov2-srr36291587 | the Primer Trim dialog Target section with its prefilled output name | Same dialog as primer-trim-scheme-menu |
| 04-alignments | 03-primer-trimming.md | 99 | `primer-trim-track-result` | The sidebar after the run, showing the new track named minimap2 mapping, a bullet, Primer-trimmed, and the scheme name in parentheses. | new | sarscov2-srr36291587 | the sidebar with the new Primer-trimmed track name | A finished primer-trim run |
| 04-alignments | 04-alignment-quality.md | 72 | `inspector-alignment-stats` | The Inspector's alignment summary showing Total Mapped, Total Unmapped, Mapped %, Chromosomes, and Est. Coverage, with the Flag Statistics list expanded beneath them. | captured | demo-project | the Inspector alignment summary with Flag Statistics expanded | An alignment track selected |
| 04-alignments | 04-alignment-quality.md | 80 | `analysis-filtering-tab` | The Filtering tab of the Inspector's Analysis tab, showing Mark Duplicates in Bundle Tracks above the divider and the Create Filtered Alignment panel below it. | captured | demo-project | the Filtering tab of the Inspector Analysis tab | An alignment track selected |
| 04-alignments | 04-alignment-quality.md | 88 | `filter-panel-controls` | The Create Filtered Alignment panel with Starting Alignment, the two keep toggles, the Minimum alignment confidence stepper reading MAPQ 20, Duplicate handling, and the Name for New Alignment field. | captured | demo-project | the Create Filtered Alignment panel with MAPQ 20 in the stepper | Filtering tab open |
| 04-alignments | 04-alignment-quality.md | 94 | `analysis-export-tab` | The Export tab of the Inspector's Analysis tab, showing the Create Deduplicated Bundle button and its two explanatory lines. | captured | demo-project | the Export tab of the Inspector Analysis tab | An alignment track selected |
| 04-alignments | 05-viral-recon-wizard.md | 93 | `viral-recon-menu-item` | The open Tools > Mapping submenu, with Viral Recon... as its fifth item below minimap2, BWA-MEM2, Bowtie2, and BBMap. | new | sarscov2-srr36291587 | the Tools > Mapping submenu with Viral Recon... as its fifth item | A read bundle selected |
| 04-alignments | 05-viral-recon-wizard.md | 97 | `viral-recon-wizard-overview` | The Viral Recon sheet, showing the Viral Recon header and its Docker Desktop note above the Inputs, Primer Scheme, Minimum mapped reads, collapsed Advanced, and Readiness sections. | captured | sarscov2-srr36291587 | the Viral Recon sheet with its Docker note and Readiness section | Docker Desktop running so the readiness section is honest |
| 04-alignments | 05-viral-recon-wizard.md | 109 | `viral-recon-advanced-open` | The Advanced disclosure expanded, showing the annotation note, the Choose GFF... button, and the Extra parameters field with its schema-checking caption. | captured | sarscov2-srr36291587 | the Advanced disclosure expanded with Choose GFF... and Extra parameters | Same sheet as viral-recon-wizard-overview |
| 04-alignments | 05-viral-recon-wizard.md | 147 | `viral-recon-inspector-outputs` | The Inspector after a finished run, listing the Consensus, Lineage, Variants, Quality, and Provenance sections with one row per output file. | new | sarscov2-srr36291587 | the Inspector after a finished run listing Consensus through Provenance | The Viral Recon run done ahead of the session, it is far too slow to run live |
| 05-variants | 01-calling-variants-from-amplicons.md | 76 | `call-variants-dialog-bcftools` | The Call Variants dialog with bcftools selected, showing the tool sidebar on the left and the Overview, Thresholds, and bcftools Settings sections on the right. | captured | demo-project | the Call Variants dialog with bcftools selected | An alignment track selected |
| 05-variants | 01-calling-variants-from-amplicons.md | 96 | `variants-tab-two-callers` | The Variants tab of the table drawer with both the bcftools and LoFreq tracks loaded, and the Source column naming which track each row came from. | captured | demo-project | the Variants tab with both bcftools and LoFreq tracks and the Source column | Both caller tracks present in the demo project |
| 05-variants | 01-calling-variants-from-amplicons.md | 106 | `call-variants-dialog-ivar` | The Call Variants dialog with iVar selected, showing the primer-trim checkbox already ticked and the iVar Options section that only iVar displays. | captured | demo-project | the Call Variants dialog with iVar selected and its iVar Options section | Same dialog, iVar picked in the sidebar |
| 05-variants | 02-reading-the-variant-browser.md | 77 | `variants-tab-twelve-columns` | The Variants tab of the table drawer inside the reference bundle viewport, with the twelve fixed columns from ID through AA Change and both caller tracks loaded. | captured | demo-project | the Variants tab with all twelve fixed columns and both caller tracks | Both caller tracks loaded |
| 05-variants | 02-reading-the-variant-browser.md | 112 | `variants-inspector-row` | The Inspector filled with one selected variant row, showing its identity, quality and filter, genotype summary, and every INFO key on its own line. | captured | demo-project | the Inspector filled with one selected variant row | A variant row selected |
| 05-variants | 02-reading-the-variant-browser.md | 124 | `variants-preset-chips` | The Presets chip strip open above the Variants table, grouped into the Biological Effect, Quality / QC, Population / Frequency, and Sample / Genotype sections. | captured | demo-project | the Presets chip strip open in its four groups | Variants tab open |
| 05-variants | 02-reading-the-variant-browser.md | 156 | `variants-search-builder` | The Variant Query Builder sheet with two rules, one on Call Quality and one on an INFO field, combined with Match All. | captured | demo-project | the Variant Query Builder sheet with two rules combined with Match All | Variants tab open |
| 05-variants | 02-reading-the-variant-browser.md | 166 | `variants-source-column` | The Source column separating the bcftools rows from the LoFreq rows at one shared coordinate in the aggregated table. | captured | demo-project | the Source column separating bcftools from LoFreq at one shared coordinate | Both caller tracks loaded |
| 05-variants | 04-nanopore-variant-calling.md | 83 | `tools-mapping-submenu` | The Tools menu with the Mapping submenu open, showing minimap2 as its own item. | new | demo-project | the Tools > Mapping submenu open on its five items | A read bundle and a reference selected so the items enable |
| 05-variants | 04-nanopore-variant-calling.md | 103 | `call-variants-dialog-medaka` | The Call Variants dialog with Medaka selected in the tool sidebar, showing the two-column layout and the Medaka Settings section holding its single empty Medaka Model field. | captured | demo-project | the Call Variants dialog with Medaka selected and its empty Medaka Model field | A nanopore alignment track selected |
| 05-variants | 04-nanopore-variant-calling.md | 119 | `medaka-model-field` | The Medaka Model field with a model identifier typed in, the Readiness line naming that model back, and the Run button enabled. | captured | demo-project | the Medaka Model field filled, the readiness line naming it, and Run enabled | Same dialog with a model identifier typed in |
| 05-variants | 05-consensus-and-lineage.md | 57 | `analysis-consensus-tab` | The Inspector's Consensus tab, showing Show consensus track in viewer, the Consensus Mode and Consensus scope pickers, the two toggles, the three evidence sliders, and the Extract Consensus... button beneath the divider. | captured | demo-project | the Inspector Consensus tab with its pickers, toggles, and sliders | An alignment track selected |
| 05-variants | 05-consensus-and-lineage.md | 59 | `consensus-masking-sliders` | The Consensus tab with Hide high-gap sites turned on, revealing the Gap threshold and Masking minimum depth sliders between Consensus minimum depth and Consensus minimum MAPQ. | captured | demo-project | the Consensus tab with Hide high-gap sites on, revealing the two extra sliders | Consensus tab open |
| 05-variants | 05-consensus-and-lineage.md | 60 | `consensus-destination-dialog` | The Extract Sequence dialog showing its four Destination choices, with Save as Bundle selected by default above Save to File..., Copy to Clipboard, and Share..., and the Name field prefilled with the suggested consensus name. | captured | demo-project | the Extract Sequence dialog with Save as Bundle selected | Extract Consensus... clicked |
| 05-variants | 06-importing-existing-vcfs.md | 90 | `import-center-vcf-card` | The Variants tab of the Import Center showing the VCF Variants card and its Import... button. | captured | demo-project | the Variants tab of the Import Center with the VCF Variants card | Import Center open |
| 05-variants | 06-importing-existing-vcfs.md | 112 | `imported-benchmark-in-variants-tab` | The Variants tab of the table drawer after the benchmark import, with the Source column separating the benchmark rows from the bcftools and LoFreq rows. | new | demo-project | the Variants tab after the benchmark import with the Source column separating it | The HG002 benchmark VCF imported |
| 05-variants | 06-importing-existing-vcfs.md | 118 | `name-imported-variant-bundle` | The Name Imported Variant Bundle prompt that appears when no reference bundle is open, with the project path in its message and the file's base name filled into the text field. | new | demo-project | the Name Imported Variant Bundle prompt with the base name filled in | No reference bundle open when the VCF is imported |
| 06-classification | 01-what-is-classification.md | 78 | `import-center-classification-tab` | The Import Center on its Classification Results tab, showing all six cards, Kraken2 Results, EsViritu Results, TaxTriage Results, NAO-MGS Results, NVD Results, and CZ-ID Results. | captured | demo-project | the Import Center Classification Results tab showing all six cards | Import Center open |
| 06-classification | 01-what-is-classification.md | 102 | `classification-submenu` | The Tools menu open on its Classification submenu, showing the three runnable classifiers as separate items, Kraken2..., EsViritu..., and TaxTriage... | new | sarscov2-srr36291587 | the Tools > Classification submenu on its three items | A FASTQ bundle selected |
| 06-classification | 01-what-is-classification.md | 108 | `classification-dialog-tool-sidebar` | The FASTQ/FASTA Operations sheet opened from Tools > Classification > Kraken2..., with Kraken2 already selected and the tool sidebar listing EsViritu and TaxTriage beside it. | captured | sarscov2-srr36291587 | the FASTQ/FASTA Operations sheet with Kraken2 selected and the tool sidebar beside it | Opened from Tools > Classification > Kraken2... |
| 06-classification | 01-what-is-classification.md | 120 | `taxonomy-viewport-overview` | A Kraken2 taxonomy viewport showing the sunburst, the breadcrumb bar, and the per-taxon table with its Filter taxa... search field above the columns. | captured | sarscov2-srr36291587 | a Kraken2 taxonomy viewport with sunburst, breadcrumb, and per-taxon table | A finished Kraken2 run |
| 06-classification | 02-running-kraken2.md | 86 | `kraken2-databases-tab` | The Plugin Manager on its Databases tab, with the recommended-database banner at the top and the eleven Kraken 2 rows showing which collections are installed and which still offer a Download button. | captured | none (Plugin Manager) | the Databases tab with the eleven Kraken 2 rows | Plugin Manager open |
| 06-classification | 02-running-kraken2.md | 100 | `kraken2-dialog` | The FASTQ/FASTA Operations dialog opened from Tools > Classification > Kraken2..., showing the dataset line, the Database picker with its size readout, and the Sensitivity segmented control. | captured | sarscov2-srr36291587 | the Kraken2 pane with its Database picker and Sensitivity control | A Kraken2 database installed |
| 06-classification | 02-running-kraken2.md | 104 | `kraken2-advanced-settings` | The dialog's Advanced Settings disclosure expanded, showing the Confidence slider, the Min hit groups stepper, the Threads stepper, the Memory mapping checkbox, and the Extra arguments field. | captured | sarscov2-srr36291587 | the Kraken2 Advanced Settings disclosure expanded | Same dialog as kraken2-dialog |
| 06-classification | 02-running-kraken2.md | 114 | `kraken2-taxonomy-viewport` | The taxonomy viewport after classifying SRR36291587, with the breadcrumb bar running across the top of both panes, the sunburst on the left, and the per-taxon table on the right showing its Filter taxa... field and its Bracken column. | captured | sarscov2-srr36291587 | the taxonomy viewport after classifying SRR36291587, with the Bracken column | A finished Kraken2 run with Bracken |
| 06-classification | 02-running-kraken2.md | 126 | `kraken2-extract-reads` | Right-click menu on a taxon row, with Extract Reads... selected above Copy Taxon Name and Copy Taxonomy Path. | new | sarscov2-srr36291587 | the right-click menu on a taxon row with Extract Reads... showing | The taxonomy viewport open |
| 06-classification | 02-running-kraken2.md | 216 | `kraken2-drilldown-coronaviridae` | The sunburst re-centred on Coronaviridae after a double-click, with the breadcrumb bar showing the path back to the root. | captured | sarscov2-srr36291587 | the sunburst re-centred on Coronaviridae with the breadcrumb path | The taxonomy viewport open on the Kraken2 result |
| 06-classification | 03-running-esviritu.md | 101 | `esviritu-dialog` | The FASTQ/FASTA Operations dialog opened from Tools > Classification > EsViritu..., showing the Sample section with its name field and paired-end line, the Database section with its green dot and version, and the Enable quality filtering (fastp) checkbox. | captured | sarscov2-srr36291587 | the EsViritu pane with the Sample and Database sections and the fastp checkbox | The EsViritu database installed so the green dot shows |
| 06-classification | 03-running-esviritu.md | 105 | `esviritu-database-missing` | The dialog's Database section reading Database not installed, with the Download Database... button beside it. | new | sarscov2-srr36291587 | the Database section reading Database not installed with its Download button | Needs the database absent, so capture this before installing it, or on a fresh profile |
| 06-classification | 03-running-esviritu.md | 109 | `esviritu-advanced-settings` | The dialog's Advanced Settings disclosure expanded, showing the Min read length stepper, the Threads stepper, and the Extra arguments field. | captured | sarscov2-srr36291587 | the EsViritu Advanced Settings disclosure expanded | Same dialog as esviritu-dialog |
| 06-classification | 03-running-esviritu.md | 125 | `esviritu-result-viewport` | The EsViritu viewport after detecting viruses in SRR36291587, with the detection table on the left showing its Coverage column sparkline and the detail pane on the right showing the metric pills. | new | sarscov2-srr36291587 | the EsViritu viewport with the detection table and its detail pane pills | A finished EsViritu run |
| 06-classification | 03-running-esviritu.md | 193 | `esviritu-alignment-evidence` | The full alignment viewer filling the detail pane after a detection row is selected, showing the read pileup over the matched viral reference. | new | sarscov2-srr36291587 | the full alignment viewer filling the detail pane after a detection row is selected | A detection row selected in the EsViritu viewport |
| 06-classification | 04-running-taxtriage.md | 85 | `taxtriage-dialog` | The FASTQ/FASTA Operations dialog opened from Tools > Classification > TaxTriage..., showing the Prerequisites row with its Nextflow and Docker indicators, the Samples section with a sample-ID field and a role picker on each row, and the Kraken2 Database picker below. | captured | sarscov2-srr36291587 | the TaxTriage pane with its Prerequisites row and Samples section | Nextflow and Docker present so the indicators are honest |
| 06-classification | 04-running-taxtriage.md | 111 | `taxtriage-advanced-settings` | The dialog's Advanced Settings disclosure expanded, showing the K2 Confidence slider, the Top hits stepper, the Max memory stepper, the Max CPUs stepper, the Skip Krona visualization checkbox, and the Extra arguments field. | captured | sarscov2-srr36291587 | the TaxTriage Advanced Settings disclosure expanded | Same dialog as taxtriage-dialog |
| 06-classification | 04-running-taxtriage.md | 121 | `taxtriage-result-table` | The TaxTriage viewport after a single-sample run of SRR36291587, with the summary cards along the top, the organism table on the right showing its TASS Score and Confidence columns, and the alignment pane on the left. | new | sarscov2-srr36291587 | the TaxTriage viewport after a single-sample run with TASS Score and Confidence | A finished single-sample TaxTriage run |
| 06-classification | 04-running-taxtriage.md | 213 | `taxtriage-batch-overview` | The batch overview shown when the sample filter is set to All Samples on a two-sample run, with the menu that chooses the cell values above the cross-sample table and one column per sample. | new | sarscov2-srr36291587 | the batch overview with the sample filter on All Samples | A two-sample TaxTriage run |
| 06-classification | 05-running-nao-mgs.md | 78 | `nao-mgs-import-card` | The Import Center's Classification Results tab, showing the NAO-MGS Results card with its NM badge and the file hint reading virus_hits_final.tsv.gz or _virus_hits.tsv.gz. | captured | demo-project | the Classification Results tab with the NAO-MGS Results card and its NM badge | Import Center open |
| 06-classification | 05-running-nao-mgs.md | 88 | `nao-mgs-import-sheet` | The NAO-MGS Import sheet after a file is chosen, showing the read-only path readout beside the Browse... button and the Validation section reporting Valid NAO-MGS results with the source file name. | new | demo-project | the NAO-MGS Import sheet after a file is chosen, with the Validation section | A NAO-MGS results file to hand, still an open item per the gate |
| 06-classification | 05-running-nao-mgs.md | 114 | `nao-mgs-result-viewport` | The NAO-MGS viewport on the imported wastewater fixture, showing the Samples and Taxa summary cards along the top, the sample-filter button reading All Samples above the taxon table, the table's Sample, Taxon, Hits, Unique Reads, and Refs columns, and the overview bar chart filling the detail pane. | new | demo-project | the NAO-MGS viewport with the Samples and Taxa cards and the taxon table | Gate: capture with the Taxa card reading 7, and check the miniBAM heading and Taxid: strings in the same pass |
| 06-classification | 05-running-nao-mgs.md | 140 | `nao-mgs-taxon-detail` | The detail pane after a taxon row is selected, showing the taxon name header, the Taxid line with its unique-of-total read counts and accession count, and the miniBAM Panels section with one read-pileup panel per top accession. | new | demo-project | the detail pane after a taxon row is selected, with the miniBAM Panels section | A taxon row selected in the NAO-MGS viewport |
| 06-classification | 06-blast-verification.md | 84 | `blast-verify-popover` | The Verify via NCBI BLAST popover open over a taxonomy row, showing the Reads to submit slider, the warning that reads leave the app for NCBI, and the Run BLAST button. | captured | sarscov2-srr36291587 | the Verify via NCBI BLAST popover over a taxonomy row | A taxonomy row selected, network reachable |
| 06-classification | 06-blast-verification.md | 108 | `blast-results-drawer` | The BLAST Results drawer after a verification, showing the summary bar with its supporting and contradicting counts and confidence word, above the per-read rows in their six default columns. | new | sarscov2-srr36291587 | the BLAST Results drawer with its summary bar above the per-read rows | A completed BLAST verification |
| 06-classification | 07-running-freyja.md | 73 | `plugin-manager-wastewater-pack` | The Plugin Manager Packs tab, with Show Experimental Features turned on, showing the Wastewater Surveillance card, its Install All button, and the five tools it installs. | captured | none (Plugin Manager) | the Packs tab with the Wastewater Surveillance card and its five tools | Gate: turn on Show Experimental Features before capturing |
| 06-classification | 08-importing-cz-id-results.md | 82 | `czid-import-card` | The Import Center on its Classification Results tab with the CZ-ID Results card, whose file hint reads taxon report TSV, .zip, or extracted folder. | captured | demo-project | the Classification Results tab with the CZ-ID Results card | Import Center open |
| 06-classification | 08-importing-cz-id-results.md | 108 | `czid-import-sheet` | The CZ-ID Import sheet after a successful scan, showing the CZ-ID Export section with its Browse... button, the Preview panel listing Sample, Project, Rows, Source, Report, Pipeline, NT DB, NR DB, and Top taxa, and the Project Destination readout, which must stay visible because it is the defective control this chapter documents. | new | demo-project | the CZ-ID Import sheet after a successful scan, Project Destination readout in frame | A CZ-ID export to hand, and the Project Destination control must stay visible |
| 06-classification | 08-importing-cz-id-results.md | 188 | `czid-result-viewport` | An imported CZ ID result open in the taxonomy viewport, with the sunburst on the left, the per-taxon table on the right, and the action bar reading Imported CZ-ID result followed by the sample name and taxon count. | new | demo-project | an imported CZ ID result in the taxonomy viewport with its action bar | A CZ-ID import completed |
| 06-classification | 08-importing-cz-id-results.md | 196 | `czid-provenance-popover` | The CZ-ID Pipeline Info popover opened from the action bar's Provenance button, listing Sample, Project, Format Version, Rows, Pipeline, NT Database, NR Database, Bundle, and Source Files. | new | demo-project | the CZ-ID Pipeline Info popover from the action bar Provenance button | A CZ-ID result open |
| 06-classification | 09-novel-virus-detection.md | 90 | `nvd-import-card` | The Import Center on its Classification Results tab with the NVD Results card, whose file hint reads NVD run folder containing *_blast_concatenated.csv(.gz). | captured | demo-project | the Classification Results tab with the NVD Results card | Import Center open |
| 06-classification | 09-novel-virus-detection.md | 102 | `nvd-import-preview` | The NVD Import sheet after a successful scan of the NVD demo results, showing the Browse... button, the path readout, and the Preview panel's Experiment, Samples, Contigs, and BLAST hits rows. | new | nvd-demo | the NVD Import sheet after a scan, with the Preview panel rows | nvd-demo fixture staged on disk |
| 06-classification | 09-novel-virus-detection.md | 112 | `nvd-result-viewport` | The NVD viewport on the demo results, showing the four summary cards, the By Sample and By Taxon grouping control, the Search contigs... field, a contig row expanded to its secondary hits, and the detail pane alongside. | captured | nvd-demo | the NVD viewport with its four cards, grouping control, and an expanded contig row | The NVD demo results imported |
| 06-classification | 09-novel-virus-detection.md | 136 | `nvd-blast-drawer` | The BLAST results drawer open across the bottom of the NVD viewport below the outline and above the action bar, with the BLAST Verify button in the action bar at lower left. | new | nvd-demo | the BLAST results drawer across the bottom of the NVD viewport | A BLAST verification run from the NVD viewport |
| 06-classification | 09-novel-virus-detection.md | 179 | `nvd-column-menu` | The right-click menu on the contig outline's column header, showing the Standard Columns checklist, Reset Column Widths, and the Sample Metadata section. | new | nvd-demo | the right-click menu on the contig outline column header | Gate: confirm metadata columns survive closing and reopening an NVD result |
| 06-classification | 10-twelve-s-metabarcoding.md | 82 | `twelve-s-workflow-library` | The Workflow Library window with the 12S Amplicon Matching card under Specialized Workflows, showing its Specialized badge, its dependency row for the Third-Party Tools pack, and the Enabled switch. | captured | primate-12s | the Workflow Library with the 12S Amplicon Matching card and its Enabled switch | Gate: enable the 12S workflow through the Workflow Library first |
| 06-classification | 10-twelve-s-metabarcoding.md | 108 | `twelve-s-dialog-inputs` | The Workflow Operations dialog on 12S Amplicon Matching, showing the Reference picker with its Create 12S Reference... button, the Analysis Metadata picker, and the FASTQ Bundles list. | captured | primate-12s | the Workflow Operations dialog on 12S Amplicon Matching, Inputs group | 12S workflow enabled, primate-12s fixture imported |
| 06-classification | 10-twelve-s-metabarcoding.md | 118 | `twelve-s-dialog-options` | The same dialog's Read Platform segmented picker, Result Name field, and Min Soft Clip field, with the Advanced Options disclosure expanded to show Max Indels and Run vsearch chimera review. | captured | primate-12s | the same dialog with Advanced Options expanded | Same dialog as twelve-s-dialog-inputs |
| 06-classification | 10-twelve-s-metabarcoding.md | 134 | `twelve-s-result-species-table` | The 12S viewport on its Targets view, showing the Sample, Scientific Name, Common Names, Group, Tax ID, Exact Reads, % of Sample, Refs, and Alternates columns above the summary line. | new | primate-12s | the 12S viewport Targets view with its nine columns | A finished 12S run |
| 06-classification | 10-twelve-s-metabarcoding.md | 146 | `twelve-s-unresolved-clusters` | The viewport's Unresolved view, showing the Sequence, Reads, Samples, Chimera, and Bases columns for the clusters that matched no reference. | new | primate-12s | the viewport Unresolved view with its five columns | A finished 12S run |
| 06-classification | 10-twelve-s-metabarcoding.md | 156 | `twelve-s-blast-review` | An unresolved cluster sent to NCBI BLAST with the BLAST Verify button, with the returned Organism, Identity, and Accession hits in the drawer below the table. | new | primate-12s | an unresolved cluster sent to BLAST with its hits in the drawer | Network reachable, a cluster selected |
| 06-classification | 10-twelve-s-metabarcoding.md | 166 | `twelve-s-export` | The viewport's Export menu offering Export as CSV..., Export as TSV..., and Export as Excel... | new | primate-12s | the viewport Export menu with its three items | A 12S result open |
| 06-human-germline-variants | 01-haplotype-caller.md | 105 | `call-variants-dialog-gatk` | The Call Variants dialog with GATK HaplotypeCaller selected, showing the tool sidebar, the Overview section's Alignment Track picker and Output Variant Track Name field, the Thresholds fields the GATK tools ignore, and the readiness line in the footer. | captured | demo-project | the Call Variants dialog with GATK HaplotypeCaller selected | The GATK Core pack installed, which needs Show Experimental Features |
| 06-human-germline-variants | 01-haplotype-caller.md | 115 | `operations-panel-gatk-run` | The Operations panel row for a finished GATK HaplotypeCaller run, expanded to show the GATK command and the provenance the run recorded. | new | demo-project | the Operations row for a finished GATK run, expanded to its command and provenance | A finished GATK HaplotypeCaller run |
| 06-human-germline-variants | 04-reference-packs.md | 91 | `settings-advanced-experimental` | The Advanced tab of Settings, showing the Show Experimental Features toggle and the warning printed beside it. | captured | none (Settings) | the Advanced tab of Settings with the Show Experimental Features toggle | Settings window open |
| 06-human-germline-variants | 04-reference-packs.md | 95 | `plugin-manager-gatk-packs` | The Plugin Manager Packs tab with experimental features shown, listing the GATK Core and Variant Phasing cards under Variant Calling with their size estimates and install buttons. | captured | none (Plugin Manager) | the Packs tab with the GATK Core and Variant Phasing cards | Show Experimental Features on |
| 07-assembly | 01-when-to-assemble.md | 80 | `assembly-submenu` | The Tools menu open on its Assembly submenu, showing the five assemblers as separate items, SPAdes..., MEGAHIT..., SKESA..., Flye..., and Hifiasm... | new | human-mito | the Tools > Assembly submenu on its five items | A read bundle selected |
| 07-assembly | 01-when-to-assemble.md | 108 | `assembly-sheet-assembler-picker` | The assembly sheet's Primary Settings, with the segmented Assembler picker above the Read Type row, which reads Illumina short reads with the note Locked from FASTQ header detection beneath it. | captured | human-mito | the assembly sheet Primary Settings with the Assembler picker and locked Read Type | An Illumina bundle selected so the Read Type row locks |
| 07-assembly | 01-when-to-assemble.md | 170 | `assembly-bundle-in-analyses` | An assembly run folder under the project's Analyses folder in the sidebar, with the .lungfishref bundle inside it selected and the assembly viewport open behind. | captured | human-mito | an assembly run folder under Analyses with its .lungfishref selected | A finished assembly run |
| 07-assembly | 02-running-spades.md | 77 | `assembly-wizard-spades` | The assembly sheet opened from Tools > Assembly > SPAdes..., showing the read-only Inputs rows, the Assembler and Read Type controls at the top of Primary Settings, the Isolate profile, and the Readiness panel at the bottom. | captured | human-mito | the assembly sheet from Tools > Assembly > SPAdes... with the Isolate profile | An Illumina bundle selected |
| 07-assembly | 02-running-spades.md | 105 | `assembly-viewport` | The assembly result viewport after the HG002 mitochondrial run, with the summary strip along the top reporting one contig, 16697 total bp, and an N50 of 16697 bp, above the contig table. | captured | human-mito | the assembly viewport with one contig, 16697 bp, N50 16697 | A finished SPAdes run on the mito fixture |
| 07-assembly | 02-running-spades.md | 135 | `assembly-advanced-settings` | The sheet's Advanced Settings section with the Curated extra arguments disclosure expanded, showing the Careful mode and Skip error correction toggles above the Extra arguments field. | captured | human-mito | the Advanced Settings section with Curated extra arguments expanded | Same sheet as assembly-wizard-spades |
| 07-assembly | 02-running-spades.md | 167 | `contig-detail-pane` | The detail pane for the longest contig, showing its header, length, GC percent, rank, share of the assembly, and sequence. | captured | human-mito | the detail pane for the longest contig | The assembly viewport open |
| 07-assembly | 03-running-flye-or-hifiasm.md | 84 | `assembly-sheet-flye` | The assembly sheet opened from Tools > Assembly > Flye..., with the ONT bundle selected in the sidebar beforehand, showing the Inputs section reporting ONT reads under Detected, the Assembler picker offering Flye beside Hifiasm and nothing else, the locked Read Type row, and the Profile picker on Nano HQ. | new | hg002-long-reads | the assembly sheet on Flye with ONT detected and the Nano HQ profile | The ONT bundle selected in the sidebar beforehand |
| 07-assembly | 03-running-flye-or-hifiasm.md | 100 | `assembly-sheet-hifiasm` | The same sheet opened from Tools > Assembly > Hifiasm... with the HiFi bundle selected, where the Assembler picker shows Hifiasm alone because it is the only assembler that accepts PacBio HiFi reads, and the Profile picker sits on Diploid. | new | hg002-long-reads | the same sheet on Hifiasm with the Diploid profile | A PacBio HiFi bundle selected so Hifiasm is the only assembler offered |
| 07-assembly | 03-running-flye-or-hifiasm.md | 110 | `flye-contig-table` | The assembly viewport after the Flye run, with the summary strip across the top reporting one contig at 16,359 bp and the contig table below holding its single row. | new | hg002-long-reads | the assembly viewport after the Flye run, one contig at 16,359 bp | A finished Flye run |
| 07-assembly | 03-running-flye-or-hifiasm.md | 142 | `assembly-sheet-curated-arguments` | The Advanced Settings section with the Curated extra arguments disclosure expanded for Flye, showing the Metagenome mode toggle above the four read-only option descriptions and the Extra arguments text field. | new | hg002-long-reads | the Curated extra arguments disclosure expanded for Flye | Same sheet as assembly-sheet-flye |
| 07-assembly | 04-extracting-contigs.md | 79 | `create-bundle-action-bar` | The assembly result viewport for the HG002 mitochondrial MEGAHIT run, with the longest contig selected in the table and the action bar below reading one contig selected, so BLAST Contig, Copy FASTA, Export FASTA, and Create Bundle are all enabled. | captured | human-mito | the assembly viewport with the longest contig selected and the action bar enabled | A finished MEGAHIT run on the mito fixture |
| 07-assembly | 04-extracting-contigs.md | 89 | `contig-context-menu` | The contig table's right-click menu on a selected row, showing Extract Sequence..., BLAST Contig..., Copy FASTA, and Export FASTA... above Extract to New Bundle..., with a separator and Run Operation... below. | new | human-mito | the contig table right-click menu on a selected row | A contig row selected |
| 07-assembly | 04-extracting-contigs.md | 127 | `derived-bundle-in-sidebar` | The derived reference bundle in the project sidebar under Reference Sequences, carrying the selected contig's own name because a single contig was selected. | new | human-mito | the derived bundle under Reference Sequences carrying the contig name | A single contig extracted to a new bundle |
| 08-workflows | 01-the-workflow-builder.md | 69 | `workflow-builder-experimental-toggle` | The Experimental Features section of Settings > Advanced, with the Show Experimental Features toggle that makes the Tools menu item appear. | captured | none (Settings) | the Experimental Features section of Settings > Advanced with the toggle on | Gate: the toggle must be on, it is what makes the Tools menu item appear |
| 08-workflows | 01-the-workflow-builder.md | 95 | `workflow-builder-sidebar-library` | The Workflow Builder's left sidebar, showing the Workflows list above the node palette with its plus, duplicate, and trash buttons. | captured | human-mito | the Workflow Builder left sidebar with the Workflows list above the node palette | Show Experimental Features on |
| 08-workflows | 01-the-workflow-builder.md | 107 | `workflow-builder-palette` | The node palette with its Filter nodes search field and the four category headers it draws: Input, Trimming & Filtering, Decontamination, and Read Processing. | captured | human-mito | the node palette with its Filter nodes field and four category headers | Workflow Builder open |
| 08-workflows | 01-the-workflow-builder.md | 134 | `workflow-builder-canvas` | The canvas with the five-step read-cleanup chain composed by hand, running from FASTQ Bundle Input through to the pinned Project output anchor. | new | human-mito | the canvas with the five-step read-cleanup chain to the Project output anchor | The chain composed by hand first |
| 08-workflows | 01-the-workflow-builder.md | 156 | `workflow-builder-node-inspector` | An Adapter + quality trim node selected, showing its Label field, the tool it runs, and the Configure... button in the right-hand inspector. | new | human-mito | an Adapter + quality trim node selected in the right-hand inspector | Gate: the shot must show the Configure... button, not parameter fields |
| 08-workflows | 02-exporting-as-nextflow-or-snakemake.md | 89 | `export-provenance-submenu` | The File > Export > Provenance submenu, with the six export targets and the separator after the fourth. | new | demo-project | the File > Export > Provenance submenu with its six targets | A bundle with provenance selected |
| 08-workflows | 02-exporting-as-nextflow-or-snakemake.md | 97 | `export-provenance-save-panel` | The Export Provenance save panel, showing its message and the prefilled folder name ending in -provenance-nextflow. | new | demo-project | the Export Provenance save panel with the -provenance-nextflow folder name | Export Nextflow chosen from the submenu |
| 08-workflows | 02-exporting-as-nextflow-or-snakemake.md | 105 | `export-provenance-complete-alert` | The Provenance Export Complete alert, with its OK and Show in Finder buttons. | new | demo-project | the Provenance Export Complete alert with OK and Show in Finder | A finished provenance export |
| 08-workflows | 02-exporting-as-nextflow-or-snakemake.md | 159 | `nextflow-export-main-nf` | The generated main.nf open in a text editor, with one process per recorded step of the HG002 mapping run. | new | demo-project | the generated main.nf open in a text editor, one process per recorded step | A Nextflow export of the HG002 mapping run, and a plain text editor granted for the session |
| 08-workflows | 03-running-external-workflows.md | 78 | `workflow-library-linked-package` | The Workflow Library window's User Workflows heading with its Link Workflow... button, showing a linked Hello World Nextflow card whose Execution row reads Runnable. | new | none (linked package) | the Workflow Library User Workflows heading with a linked Hello World Nextflow card | Gate: the hello-world-nextflow package linked with its Execution row reading Runnable |
| 08-workflows | 03-running-external-workflows.md | 94 | `workflow-operations-runner` | The Workflow Operations window opened from a Tools category submenu, showing its Overview, Inputs, Primary Settings, Advanced Settings, Output, and Readiness sections. | captured | demo-project | the Workflow Operations window with its six sections | Gate: a reference bundle and a read bundle selected in the sidebar before the window opens |
| 09-genotyping | 01-what-is-mhc-genotyping.md | 85 | `genotyping-submenu` | The Tools menu open on its Genotyping submenu, showing the three specialized workflows it holds, miSeq amplicon MHC genotyping..., Full-length ONT MHC genotyping..., and 12S Amplicon Matching..., with any workflow that is not yet enabled shown in grey followed by (not enabled). | new | williams | the Tools > Genotyping submenu on its three workflows | Gate: show all three enabled, or one greyed to illustrate the (not enabled) suffix |
| 09-genotyping | 01-what-is-mhc-genotyping.md | 130 | `genotype-matrix-overview` | The Genotype Matrix view of the Williams MiSeq genotyping result, with allele-target rows down the left named by their reference record and one column per sample across the top. | new | williams | the Genotype Matrix view of the Williams MiSeq result | Gate: the Williams result at Amplicon genotyping results/ |
| 09-genotyping | 02-running-genotyping.md | 88 | `genotyping-run-dialog` | The Workflow Operations dialog on miSeq amplicon MHC genotyping, showing the Reference group with its Project Reference menu, the FASTQ Bundles group, the Report group with Report Name, and the Run Parameters group with Threads and Min Reads above the read-only mode caption. | new | williams | the Workflow Operations dialog on miSeq amplicon MHC genotyping | The Genotyping workflows enabled in the Workflow Library |
| 09-genotyping | 02-running-genotyping.md | 104 | `genotyping-analysis-mode` | The dialog's Haplotyping group with the Analysis Mode segmented picker on Genotype only, and the AI preset segment greyed out under the caption about configured API access. | new | williams | the Haplotyping group with Analysis Mode on Genotype only and the AI segment greyed | Same dialog as genotyping-run-dialog, no AI provider configured |
| 09-genotyping | 02-running-genotyping.md | 108 | `genotyping-advanced-options` | The dialog's Advanced Options disclosure expanded on the miSeq workflow, showing the minimap2 arguments field and the Keep Intermediates checkbox above the Directory group. | new | williams | the miSeq Advanced Options disclosure expanded | Same dialog as genotyping-run-dialog |
| 09-genotyping | 02-running-genotyping.md | 114 | `genotyping-operations-row` | The Operations panel tracking a running genotyping batch, with its progress message naming the merge, mapping, and filtering stages. | new | williams | the Operations panel tracking a running genotyping batch | A genotyping run actually in flight |
| 09-genotyping | 02-running-genotyping.md | 126 | `genotyping-full-length-dialog` | The Workflow Operations dialog on Full-length ONT MHC genotyping, showing the Length Filter group with Min Length and Max Length, the Call Thresholds group with its Locus % field, and the Advanced Options disclosure holding Orient Reference, Forward Primers, and Reverse Primers. | new | williams | the Workflow Operations dialog on Full-length ONT MHC genotyping | Gate: that workflow enabled first, and keep Keep Intermediates in frame |
| 09-genotyping | 03-reading-the-genotype-comparison.md | 72 | `genotype-matrix-reading` | The genotype result window on the Williams MiSeq result, with allele-target rows named by their reference record down the pinned left columns and one column per sample across the top. | new | williams | the genotype result window on the Williams MiSeq result with pinned left columns | The Williams result open |
| 09-genotyping | 03-reading-the-genotype-comparison.md | 104 | `genotype-call-evidence` | The detail pane after selecting one sample column, showing the sample header metrics and the Supported Alleles list of that sample's allele targets and read counts. | new | williams | the detail pane with the Supported Alleles list | Gate: one sample column selected, and the detail pane opens blank until then |
| 09-genotyping | 03-reading-the-genotype-comparison.md | 124 | `genotype-inspector-display` | The Inspector's Genotype Display section with the Alleles and Samples filter fields, the Min reads and Min percent controls, the Percent Basis picker, and the Cell Color choice. | new | williams | the Inspector Genotype Display section with its filters and Cell Color choice | Gate: the View tab Genotype Display section in frame, no filter row on the matrix itself |
| 09-genotyping | 04-haplotype-definitions-and-export.md | 73 | `genotype-inspector-export` | The Export block at the foot of the Inspector's Genotype Display section, showing the Filtered Pivot... button and the caption stating that the copy is one-way. | new | williams | the Export block at the foot of the Genotype Display section | The Inspector View tab scrolled to its Export block |
| 09-genotyping | 04-haplotype-definitions-and-export.md | 83 | `genotype-export-save-panel` | The Export Genotype View save panel opened by Filtered Pivot..., with the suggested filename ending in -filtered-pivot.xlsx. | new | williams | the Export Genotype View save panel with the -filtered-pivot.xlsx name | Filtered Pivot... clicked |
| 09-genotyping | 04-haplotype-definitions-and-export.md | 93 | `genotype-pivot-workbook` | The pivot sheet of an exported workbook in a spreadsheet application, with samples running across the columns and allele targets down the rows beneath the Total and # Obs. columns. | new | williams | the pivot sheet of the exported workbook in a spreadsheet application | A spreadsheet application granted for the session |
| appendices | ai-assistant.md | 37 | `ai-assistant-panel` | The Assistant tab of the Inspector beside a dataset viewport, showing the welcome message, the suggested-question buttons, and the Data sent and Clear buttons in its header. | captured | demo-project | the Assistant tab of the Inspector beside a dataset viewport | Gate: the HG002 chr20 slice selected with the toggle on, and the chr20 organism field corrected in the demo build script first, or the suggestion buttons will show the slice name |
| appendices | ai-assistant.md | 83 | `ai-assistant-provider-setup` | The AI Services settings tab with the Enable AI-powered search toggle, the Default provider picker, and one provider's API Key field, key-status indicator, and Model picker. | captured | none (Settings) | the AI Services settings tab with the enable toggle and one provider block | Gate: leave the key field empty |
| appendices | ai-assistant.md | 129 | `ai-assistant-azure-endpoint` | The Azure AI section of the AI Services settings tab, with the Use Azure AI-hosted endpoint toggle and the Endpoint and Deployment fields. | captured | none (Settings) | the Azure AI section of the AI Services settings tab | Gate: leave the key field empty |
| appendices | primer-schemes.md | 128 | `primer-scheme-import-card` | The Import Center on its Reference Sequences tab, with the Primer Scheme card and its file hint reading .bed (+ optional .fasta/.fa/.fna). | captured | demo-project | the Import Center Reference Sequences tab with the Primer Scheme card | Gate: from the demo project |
| appendices | primer-schemes.md | 132 | `primer-scheme-import-sheet` | The Import Primer Scheme sheet, showing the Files section with its BED and FASTA rows and the Identity section with its four text fields. | captured | demo-project | the Import Primer Scheme sheet with its Files and Identity sections | Gate: from the demo project |
| appendices | primer-schemes.md | 144 | `primer-scheme-inspector` | A primer scheme selected in the sidebar, with the Inspector showing the display name, the primer and amplicon counts, and the reference and equivalent accessions. | new | demo-project | a primer scheme selected in the sidebar with the Inspector showing its counts | Gate: a scheme selected, and a shipped scheme shows more fields than an imported one |
| appendices | shared-projects.md | 75 | `shared-projects-read-only-banner` | A project window opened read-only, with (Read Only) after the project name in the title bar and the yellow project-lock banner across the top naming the lock's owner, host, process, and creation time. | new | demo-project | a project window opened read-only with the yellow project-lock banner | Gate: needs a second session holding the demo project open, or a copy of the project made while the app has it open |
| appendices | troubleshooting.md | 46 | `operations-panel-failed-row` | A failed row in the Operations Panel expanded to show its command and log, with the right-click menu open on Copy Failure Report. | new | demo-project | a failed Operations Panel row expanded with the right-click menu on Copy Failure Report | A deliberately failed operation, for example a run with a missing input |

## Shot size ruling (2026-09-08)

Read the Docs renders the Material theme's content column at about 800 CSS pixels, and Retina screens draw it at two device pixels per CSS pixel. Every stored PNG is therefore at most 1600 pixels wide, so it fills the column at exactly two device pixels per CSS pixel and never upscales. Full-window shots are taken with the main window at 1400 by 900 points, captured at the display's 2x scale (2800 by 1800 pixels) and downscaled to 1600 wide. Dialog, sheet, panel, and Inspector shots are captured as their own window at 2x and kept at that size, which is at most about 1100 pixels wide for a 520-point dialog, so their text is at least as large as the page's own. A region crop from a full-window capture keeps the 2x pixels and is downscaled only if wider than 1600. Every capture uses `screencapture -l <window id> -o -x` so the window is captured alone, without its shadow, the menu bar, or the Dock. The build's `resize-images.sh` still shrinks anything wider than 1200 for the PDF, which is a build-time copy and does not touch the stored files.

## Prerequisites for a capture session

- Set the Mac to light appearance for the whole session, since System Settings is off limits to computer use and the user has to switch it by hand if it is dark.
- Size the main window to 1600 by 1000 before every full-app shot, and capture the window rather than the display so neither the menu bar nor the Dock is in frame.
- Run only the Preview app, confirmed from the process list, so no Debug or stable build appears in a screenshot.
- Open the demo project from `~/Desktop/lge-docs/LGE Manual Demo.lungfish`, which every row marked `demo-project` is built from.
- Turn on Show Experimental Features in Settings > Advanced before the Workflow Builder shots, the Freyja wastewater pack shot, and the GATK pack shots, because none of those surfaces exists without it.
- Enable the Genotyping workflows in the Workflow Library before the genotyping dialog shots, and enable Full-length ONT MHC genotyping specifically before `genotyping-full-length-dialog`.
- Enable the 12S Amplicon Matching workflow through the Workflow Library before any of the seven 12S shots.
- Do the SRA download of SRR32909537 ahead of the session so `sra-import-configuration-sheet` and `sra-bundle-in-sidebar` do not wait on the network mid-capture.
- Do the Viral Recon run ahead of the session as well, since `viral-recon-inspector-outputs` needs a finished run and the pipeline is far too slow to run live.
- Correct the chr20 organism field in the demo project's build script before capturing `ai-assistant-panel`, or the Assistant's suggestion buttons will show the slice name instead of the organism.
- Capture `esviritu-database-missing` before installing the EsViritu database, or on a profile where it is absent, because the shot is the not-installed state.
- Use the Williams project at `~/Desktop/lge-docs/32566_MS267_Williams1.lungfish` for all thirteen genotyping shots: `genotyping-submenu`, `genotype-matrix-overview`, `genotyping-run-dialog`, `genotyping-analysis-mode`, `genotyping-advanced-options`, `genotyping-operations-row`, `genotyping-full-length-dialog`, `genotype-matrix-reading`, `genotype-call-evidence`, `genotype-inspector-display`, `genotype-inspector-export`, `genotype-export-save-panel`, and `genotype-pivot-workbook`, with the matrix shots taken on the result under `Amplicon genotyping results/`.
- Two shots need something beyond a single window. `shared-projects-read-only-banner` needs a second session holding the demo project open, or a copy of the project made while the app has it open, and `genotype-pivot-workbook` needs the exported workbook opened in a spreadsheet application, which must be granted for the session alongside the app.
- `nextflow-export-main-nf` and `provenance-export-folder` also leave the app, needing a plain text editor and Finder respectively, so grant those before starting rather than mid-session.
- Rename the demo project's `Analyses/` folders to the app's `<tool>-<timestamp>` shape before `sidebar-folder-conventions`, or accept the script-chosen names and say so in the recipe, since the gate flagged the difference.
- Capture `nao-mgs-result-viewport` with the Taxa card reading 7, and check the miniBAM heading and the `Taxid:` line strings in the same pass. A publishable NAO-MGS sample output is still an open item, so this chapter's four shots may block.
- Keep the CZ-ID `Project Destination` readout visible in `czid-import-sheet`, because it is the defective control that chapter documents.
- Show the Configure... button rather than parameter fields in `workflow-builder-node-inspector`, and link the hello-world-nextflow package with its Execution row reading Runnable before `workflow-library-linked-package`.
- Select a reference bundle and a read bundle in the sidebar before opening the window for `workflow-operations-runner`.
- Select one sample column before `genotype-call-evidence`, since the detail pane opens blank, and confirm from the window that no filter row sits on the matrix itself.
- Leave every API key field empty in `ai-assistant-provider-setup` and `ai-assistant-azure-endpoint`, and keep no real signing key in `provenance-signing-settings`.
- Never click Run inside a capture session unless the row is the running state, and then only on the demo project. Close each dialog with Cancel.
- Confirm metadata columns survive closing and reopening an NVD result while capturing `nvd-column-menu`.

## check-shots output

Produced by `node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual`.

```
missing png 01-foundations/import-center-reference-card
missing recipe 01-foundations/import-center-reference-card
missing png 01-foundations/hbb-record-in-sequence-viewport
missing recipe 01-foundations/hbb-record-in-sequence-viewport
missing png 01-foundations/go-to-location-hbb-codon
missing recipe 01-foundations/go-to-location-hbb-codon
missing png 01-foundations/fastq-viewport-summary-cards
missing recipe 01-foundations/fastq-viewport-summary-cards
missing png 01-foundations/fastq-viewport-reads-tab
missing recipe 01-foundations/fastq-viewport-reads-tab
missing png 01-foundations/primer-scheme-picker-built-in
missing recipe 01-foundations/primer-scheme-picker-built-in
missing png 01-foundations/bam-viewport-coverage-and-pileup
missing recipe 01-foundations/bam-viewport-coverage-and-pileup
missing png 01-foundations/variants-tab-hg002-bcftools
missing recipe 01-foundations/variants-tab-hg002-bcftools
missing png 01-foundations/variants-pass-chip-and-tokens
missing recipe 01-foundations/variants-pass-chip-and-tokens
missing png 01-foundations/inspector-variant-selected
missing recipe 01-foundations/inspector-variant-selected
missing png 01-foundations/welcome-window
missing recipe 01-foundations/welcome-window
missing png 01-foundations/empty-project-window
missing recipe 01-foundations/empty-project-window
missing png 01-foundations/sidebar-folder-conventions
missing recipe 01-foundations/sidebar-folder-conventions
missing png 01-foundations/file-export-menu
missing recipe 01-foundations/file-export-menu
missing png 01-foundations/inspector-fastq-selected
missing recipe 01-foundations/inspector-fastq-selected
missing png 01-foundations/inspector-fastq-detail
missing recipe 01-foundations/inspector-fastq-detail
missing png 01-foundations/operations-panel-row
missing recipe 01-foundations/operations-panel-row
missing png 01-foundations/operations-panel-right-click-menu
missing recipe 01-foundations/operations-panel-right-click-menu
missing png 01-foundations/plugin-manager-window
missing recipe 01-foundations/plugin-manager-window
missing png 01-foundations/plugin-manager-offline-commands
missing recipe 01-foundations/plugin-manager-offline-commands
missing png 01-foundations/plugin-manager-installed-tab
missing recipe 01-foundations/plugin-manager-installed-tab
missing png 01-foundations/plugin-manager-databases-tab
missing recipe 01-foundations/plugin-manager-databases-tab
missing png 01-foundations/inspector-provenance-section
missing recipe 01-foundations/inspector-provenance-section
missing png 01-foundations/provenance-lineage-step-expanded
missing recipe 01-foundations/provenance-lineage-step-expanded
missing png 01-foundations/file-export-menu
missing recipe 01-foundations/file-export-menu
missing png 01-foundations/provenance-export-folder
missing recipe 01-foundations/provenance-export-folder
missing png 01-foundations/provenance-signing-settings
missing recipe 01-foundations/provenance-signing-settings
missing png 02-sequences/import-center-reference-card
missing recipe 02-sequences/import-center-reference-card
missing png 02-sequences/hbb-record-in-sequence-viewport
missing recipe 02-sequences/hbb-record-in-sequence-viewport
missing png 02-sequences/import-center-annotation-track-alert
missing recipe 02-sequences/import-center-annotation-track-alert
missing png 02-sequences/go-to-location-hbb-codon
missing recipe 02-sequences/go-to-location-hbb-codon
missing png 02-sequences/hbb-annotation-context-menu
missing recipe 02-sequences/hbb-annotation-context-menu
missing png 02-sequences/translation-tool-hbb-cds
missing recipe 02-sequences/translation-tool-hbb-cds
missing png 02-sequences/ncbi-search-dialog
missing recipe 02-sequences/ncbi-search-dialog
missing png 02-sequences/ncbi-advanced-filters
missing recipe 02-sequences/ncbi-advanced-filters
missing png 02-sequences/ncbi-results-download-selected
missing recipe 02-sequences/ncbi-results-download-selected
missing png 02-sequences/ncbi-bundle-in-sidebar
missing recipe 02-sequences/ncbi-bundle-in-sidebar
missing png 02-sequences/pathoplexus-pane
missing recipe 02-sequences/pathoplexus-pane
missing png 02-sequences/hbb-record-in-sequence-viewport
missing recipe 02-sequences/hbb-record-in-sequence-viewport
missing png 02-sequences/go-to-location-hbb-codon
missing recipe 02-sequences/go-to-location-hbb-codon
missing png 02-sequences/extract-region-dialog
missing recipe 02-sequences/extract-region-dialog
missing png 02-sequences/hbb-annotation-context-menu
missing recipe 02-sequences/hbb-annotation-context-menu
missing png 02-sequences/find-orfs-dialog
missing recipe 02-sequences/find-orfs-dialog
missing png 02-sequences/mafft-dialog
missing recipe 02-sequences/mafft-dialog
missing png 02-sequences/alignment-viewport-primate-mito
missing recipe 02-sequences/alignment-viewport-primate-mito
missing png 02-sequences/export-alignment-sheet
missing recipe 02-sequences/export-alignment-sheet
missing png 02-sequences/iqtree-dialog
missing recipe 02-sequences/iqtree-dialog
missing png 02-sequences/tree-viewport-primate-mito
missing recipe 02-sequences/tree-viewport-primate-mito
missing png 03-reads/import-center-sequencing-reads-tab
missing recipe 03-reads/import-center-sequencing-reads-tab
missing png 03-reads/import-fastq-configuration-sheet
missing recipe 03-reads/import-fastq-configuration-sheet
missing png 03-reads/sidebar-after-import
missing recipe 03-reads/sidebar-after-import
missing png 03-reads/fastq-viewport-summary-cards
missing recipe 03-reads/fastq-viewport-summary-cards
missing png 03-reads/sra-runs-pane
missing recipe 03-reads/sra-runs-pane
missing png 03-reads/sra-results-download-selected
missing recipe 03-reads/sra-results-download-selected
missing png 03-reads/sra-import-configuration-sheet
missing recipe 03-reads/sra-import-configuration-sheet
missing png 03-reads/sra-bundle-in-sidebar
missing recipe 03-reads/sra-bundle-in-sidebar
missing png 03-reads/fastq-viewport-summary-cards
missing recipe 03-reads/fastq-viewport-summary-cards
missing png 03-reads/fastq-sparkline-popover
missing recipe 03-reads/fastq-sparkline-popover
missing png 03-reads/refresh-qc-summary-dialog
missing recipe 03-reads/refresh-qc-summary-dialog
missing png 03-reads/fastq-viewport-reads-tab
missing recipe 03-reads/fastq-viewport-reads-tab
missing png 03-reads/trimming-dialog
missing recipe 03-reads/trimming-dialog
missing png 03-reads/trim-operation-row
missing recipe 03-reads/trim-operation-row
missing png 03-reads/length-filter-readiness
missing recipe 03-reads/length-filter-readiness
missing png 03-reads/primer-trimming-literal-pane
missing recipe 03-reads/primer-trimming-literal-pane
missing png 03-reads/human-scrub-dialog
missing recipe 03-reads/human-scrub-dialog
missing png 03-reads/low-complexity-pane
missing recipe 03-reads/low-complexity-pane
missing png 03-reads/remove-duplicates-preset-picker
missing recipe 03-reads/remove-duplicates-preset-picker
missing png 03-reads/search-subsetting-menu
missing recipe 03-reads/search-subsetting-menu
missing png 03-reads/subsample-by-count-pane
missing recipe 03-reads/subsample-by-count-pane
missing png 03-reads/select-reads-by-sequence-pane
missing recipe 03-reads/select-reads-by-sequence-pane
missing png 03-reads/ont-import-configuration-sheet
missing recipe 03-reads/ont-import-configuration-sheet
missing png 03-reads/ont-barcode-sheet-controls
missing recipe 03-reads/ont-barcode-sheet-controls
missing png 03-reads/sidebar-after-ont-import
missing recipe 03-reads/sidebar-after-ont-import
missing png 03-reads/demultiplex-barcodes-pane
missing recipe 03-reads/demultiplex-barcodes-pane
missing png 03-reads/read-processing-menu
missing recipe 03-reads/read-processing-menu
missing png 03-reads/merge-overlapping-pairs-pane
missing recipe 03-reads/merge-overlapping-pairs-pane
missing png 03-reads/sidebar-after-merge
missing recipe 03-reads/sidebar-after-merge
missing png 03-reads/orient-reads-pane
missing recipe 03-reads/orient-reads-pane
missing png 04-alignments/tools-mapping-submenu
missing recipe 04-alignments/tools-mapping-submenu
missing png 04-alignments/mapping-wizard-overview
missing recipe 04-alignments/mapping-wizard-overview
missing png 04-alignments/mapping-wizard-advanced
missing recipe 04-alignments/mapping-wizard-advanced
missing png 04-alignments/alignment-inspector-stats
missing recipe 04-alignments/alignment-inspector-stats
missing png 04-alignments/bam-viewport-overview
missing recipe 04-alignments/bam-viewport-overview
missing png 04-alignments/pileup-zoom
missing recipe 04-alignments/pileup-zoom
missing png 04-alignments/extract-reads-region-menu
missing recipe 04-alignments/extract-reads-region-menu
missing png 04-alignments/view-settings-alignment-tab
missing recipe 04-alignments/view-settings-alignment-tab
missing png 04-alignments/view-settings-reads-tab
missing recipe 04-alignments/view-settings-reads-tab
missing png 04-alignments/primer-trim-scheme-menu
missing recipe 04-alignments/primer-trim-scheme-menu
missing png 04-alignments/primer-trim-dialog-target
missing recipe 04-alignments/primer-trim-dialog-target
missing png 04-alignments/primer-trim-track-result
missing recipe 04-alignments/primer-trim-track-result
missing png 04-alignments/inspector-alignment-stats
missing recipe 04-alignments/inspector-alignment-stats
missing png 04-alignments/analysis-filtering-tab
missing recipe 04-alignments/analysis-filtering-tab
missing png 04-alignments/filter-panel-controls
missing recipe 04-alignments/filter-panel-controls
missing png 04-alignments/analysis-export-tab
missing recipe 04-alignments/analysis-export-tab
missing png 04-alignments/viral-recon-menu-item
missing recipe 04-alignments/viral-recon-menu-item
missing png 04-alignments/viral-recon-wizard-overview
missing recipe 04-alignments/viral-recon-wizard-overview
missing png 04-alignments/viral-recon-advanced-open
missing recipe 04-alignments/viral-recon-advanced-open
missing png 04-alignments/viral-recon-inspector-outputs
missing recipe 04-alignments/viral-recon-inspector-outputs
missing png 05-variants/call-variants-dialog-bcftools
missing recipe 05-variants/call-variants-dialog-bcftools
missing png 05-variants/variants-tab-two-callers
missing recipe 05-variants/variants-tab-two-callers
missing png 05-variants/call-variants-dialog-ivar
missing recipe 05-variants/call-variants-dialog-ivar
missing png 05-variants/variants-tab-twelve-columns
missing recipe 05-variants/variants-tab-twelve-columns
missing png 05-variants/variants-inspector-row
missing recipe 05-variants/variants-inspector-row
missing png 05-variants/variants-preset-chips
missing recipe 05-variants/variants-preset-chips
missing png 05-variants/variants-search-builder
missing recipe 05-variants/variants-search-builder
missing png 05-variants/variants-source-column
missing recipe 05-variants/variants-source-column
missing png 05-variants/tools-mapping-submenu
missing recipe 05-variants/tools-mapping-submenu
missing png 05-variants/call-variants-dialog-medaka
missing recipe 05-variants/call-variants-dialog-medaka
missing png 05-variants/medaka-model-field
missing recipe 05-variants/medaka-model-field
missing png 05-variants/analysis-consensus-tab
missing recipe 05-variants/analysis-consensus-tab
missing png 05-variants/consensus-masking-sliders
missing recipe 05-variants/consensus-masking-sliders
missing png 05-variants/consensus-destination-dialog
missing recipe 05-variants/consensus-destination-dialog
missing png 05-variants/import-center-vcf-card
missing recipe 05-variants/import-center-vcf-card
missing png 05-variants/imported-benchmark-in-variants-tab
missing recipe 05-variants/imported-benchmark-in-variants-tab
missing png 05-variants/name-imported-variant-bundle
missing recipe 05-variants/name-imported-variant-bundle
missing png 06-classification/import-center-classification-tab
missing recipe 06-classification/import-center-classification-tab
missing png 06-classification/classification-submenu
missing recipe 06-classification/classification-submenu
missing png 06-classification/classification-dialog-tool-sidebar
missing recipe 06-classification/classification-dialog-tool-sidebar
missing png 06-classification/taxonomy-viewport-overview
missing recipe 06-classification/taxonomy-viewport-overview
missing png 06-classification/kraken2-databases-tab
missing recipe 06-classification/kraken2-databases-tab
missing png 06-classification/kraken2-dialog
missing recipe 06-classification/kraken2-dialog
missing png 06-classification/kraken2-advanced-settings
missing recipe 06-classification/kraken2-advanced-settings
missing png 06-classification/kraken2-taxonomy-viewport
missing recipe 06-classification/kraken2-taxonomy-viewport
missing png 06-classification/kraken2-extract-reads
missing recipe 06-classification/kraken2-extract-reads
missing png 06-classification/kraken2-drilldown-coronaviridae
missing recipe 06-classification/kraken2-drilldown-coronaviridae
missing png 06-classification/esviritu-dialog
missing recipe 06-classification/esviritu-dialog
missing png 06-classification/esviritu-database-missing
missing recipe 06-classification/esviritu-database-missing
missing png 06-classification/esviritu-advanced-settings
missing recipe 06-classification/esviritu-advanced-settings
missing png 06-classification/esviritu-result-viewport
missing recipe 06-classification/esviritu-result-viewport
missing png 06-classification/esviritu-alignment-evidence
missing recipe 06-classification/esviritu-alignment-evidence
missing png 06-classification/taxtriage-dialog
missing recipe 06-classification/taxtriage-dialog
missing png 06-classification/taxtriage-advanced-settings
missing recipe 06-classification/taxtriage-advanced-settings
missing png 06-classification/taxtriage-result-table
missing recipe 06-classification/taxtriage-result-table
missing png 06-classification/taxtriage-batch-overview
missing recipe 06-classification/taxtriage-batch-overview
missing png 06-classification/nao-mgs-import-card
missing recipe 06-classification/nao-mgs-import-card
missing png 06-classification/nao-mgs-import-sheet
missing recipe 06-classification/nao-mgs-import-sheet
missing png 06-classification/nao-mgs-result-viewport
missing recipe 06-classification/nao-mgs-result-viewport
missing png 06-classification/nao-mgs-taxon-detail
missing recipe 06-classification/nao-mgs-taxon-detail
missing png 06-classification/blast-verify-popover
missing recipe 06-classification/blast-verify-popover
missing png 06-classification/blast-results-drawer
missing recipe 06-classification/blast-results-drawer
missing png 06-classification/plugin-manager-wastewater-pack
missing recipe 06-classification/plugin-manager-wastewater-pack
missing png 06-classification/czid-import-card
missing recipe 06-classification/czid-import-card
missing png 06-classification/czid-import-sheet
missing recipe 06-classification/czid-import-sheet
missing png 06-classification/czid-result-viewport
missing recipe 06-classification/czid-result-viewport
missing png 06-classification/czid-provenance-popover
missing recipe 06-classification/czid-provenance-popover
missing png 06-classification/nvd-import-card
missing recipe 06-classification/nvd-import-card
missing png 06-classification/nvd-import-preview
missing recipe 06-classification/nvd-import-preview
missing png 06-classification/nvd-result-viewport
missing recipe 06-classification/nvd-result-viewport
missing png 06-classification/nvd-blast-drawer
missing recipe 06-classification/nvd-blast-drawer
missing png 06-classification/nvd-column-menu
missing recipe 06-classification/nvd-column-menu
missing png 06-classification/twelve-s-workflow-library
missing recipe 06-classification/twelve-s-workflow-library
missing png 06-classification/twelve-s-dialog-inputs
missing recipe 06-classification/twelve-s-dialog-inputs
missing png 06-classification/twelve-s-dialog-options
missing recipe 06-classification/twelve-s-dialog-options
missing png 06-classification/twelve-s-result-species-table
missing recipe 06-classification/twelve-s-result-species-table
missing png 06-classification/twelve-s-unresolved-clusters
missing recipe 06-classification/twelve-s-unresolved-clusters
missing png 06-classification/twelve-s-blast-review
missing recipe 06-classification/twelve-s-blast-review
missing png 06-classification/twelve-s-export
missing recipe 06-classification/twelve-s-export
missing png 06-human-germline-variants/call-variants-dialog-gatk
missing recipe 06-human-germline-variants/call-variants-dialog-gatk
missing png 06-human-germline-variants/operations-panel-gatk-run
missing recipe 06-human-germline-variants/operations-panel-gatk-run
missing png 06-human-germline-variants/settings-advanced-experimental
missing recipe 06-human-germline-variants/settings-advanced-experimental
missing png 06-human-germline-variants/plugin-manager-gatk-packs
missing recipe 06-human-germline-variants/plugin-manager-gatk-packs
missing png 07-assembly/assembly-submenu
missing recipe 07-assembly/assembly-submenu
missing png 07-assembly/assembly-sheet-assembler-picker
missing recipe 07-assembly/assembly-sheet-assembler-picker
missing png 07-assembly/assembly-bundle-in-analyses
missing recipe 07-assembly/assembly-bundle-in-analyses
missing png 07-assembly/assembly-wizard-spades
missing recipe 07-assembly/assembly-wizard-spades
missing png 07-assembly/assembly-viewport
missing recipe 07-assembly/assembly-viewport
missing png 07-assembly/assembly-advanced-settings
missing recipe 07-assembly/assembly-advanced-settings
missing png 07-assembly/contig-detail-pane
missing recipe 07-assembly/contig-detail-pane
missing png 07-assembly/assembly-sheet-flye
missing recipe 07-assembly/assembly-sheet-flye
missing png 07-assembly/assembly-sheet-hifiasm
missing recipe 07-assembly/assembly-sheet-hifiasm
missing png 07-assembly/flye-contig-table
missing recipe 07-assembly/flye-contig-table
missing png 07-assembly/assembly-sheet-curated-arguments
missing recipe 07-assembly/assembly-sheet-curated-arguments
missing png 07-assembly/create-bundle-action-bar
missing recipe 07-assembly/create-bundle-action-bar
missing png 07-assembly/contig-context-menu
missing recipe 07-assembly/contig-context-menu
missing png 07-assembly/derived-bundle-in-sidebar
missing recipe 07-assembly/derived-bundle-in-sidebar
missing png 08-workflows/workflow-builder-experimental-toggle
missing recipe 08-workflows/workflow-builder-experimental-toggle
missing png 08-workflows/workflow-builder-sidebar-library
missing recipe 08-workflows/workflow-builder-sidebar-library
missing png 08-workflows/workflow-builder-palette
missing recipe 08-workflows/workflow-builder-palette
missing png 08-workflows/workflow-builder-canvas
missing recipe 08-workflows/workflow-builder-canvas
missing png 08-workflows/workflow-builder-node-inspector
missing recipe 08-workflows/workflow-builder-node-inspector
missing png 08-workflows/export-provenance-submenu
missing recipe 08-workflows/export-provenance-submenu
missing png 08-workflows/export-provenance-save-panel
missing recipe 08-workflows/export-provenance-save-panel
missing png 08-workflows/export-provenance-complete-alert
missing recipe 08-workflows/export-provenance-complete-alert
missing png 08-workflows/nextflow-export-main-nf
missing recipe 08-workflows/nextflow-export-main-nf
missing png 08-workflows/workflow-library-linked-package
missing recipe 08-workflows/workflow-library-linked-package
missing png 08-workflows/workflow-operations-runner
missing recipe 08-workflows/workflow-operations-runner
missing png 09-genotyping/genotyping-submenu
missing recipe 09-genotyping/genotyping-submenu
missing png 09-genotyping/genotype-matrix-overview
missing recipe 09-genotyping/genotype-matrix-overview
missing png 09-genotyping/genotyping-run-dialog
missing recipe 09-genotyping/genotyping-run-dialog
missing png 09-genotyping/genotyping-analysis-mode
missing recipe 09-genotyping/genotyping-analysis-mode
missing png 09-genotyping/genotyping-advanced-options
missing recipe 09-genotyping/genotyping-advanced-options
missing png 09-genotyping/genotyping-operations-row
missing recipe 09-genotyping/genotyping-operations-row
missing png 09-genotyping/genotyping-full-length-dialog
missing recipe 09-genotyping/genotyping-full-length-dialog
missing png 09-genotyping/genotype-matrix-reading
missing recipe 09-genotyping/genotype-matrix-reading
missing png 09-genotyping/genotype-call-evidence
missing recipe 09-genotyping/genotype-call-evidence
missing png 09-genotyping/genotype-inspector-display
missing recipe 09-genotyping/genotype-inspector-display
missing png 09-genotyping/genotype-inspector-export
missing recipe 09-genotyping/genotype-inspector-export
missing png 09-genotyping/genotype-export-save-panel
missing recipe 09-genotyping/genotype-export-save-panel
missing png 09-genotyping/genotype-pivot-workbook
missing recipe 09-genotyping/genotype-pivot-workbook
missing png appendices/ai-assistant-panel
missing recipe appendices/ai-assistant-panel
missing png appendices/ai-assistant-provider-setup
missing recipe appendices/ai-assistant-provider-setup
missing png appendices/ai-assistant-azure-endpoint
missing recipe appendices/ai-assistant-azure-endpoint
missing png appendices/primer-scheme-import-card
missing recipe appendices/primer-scheme-import-card
missing png appendices/primer-scheme-import-sheet
missing recipe appendices/primer-scheme-import-sheet
missing png appendices/primer-scheme-inspector
missing recipe appendices/primer-scheme-inspector
missing png appendices/shared-projects-read-only-banner
missing recipe appendices/shared-projects-read-only-banner
missing png appendices/operations-panel-failed-row
missing recipe appendices/operations-panel-failed-row
orphan recipe 04-variants/primer-trim-dialog.yaml
orphan recipe 04-variants/variant-call-dialog.yaml
orphan recipe 04-variants/variant-table-fresh-call.yaml
orphan recipe 04-variants/vcf-open-dialog.yaml
orphan recipe 04-variants/vcf-variant-table.yaml
414 shot problem(s)
```

## Counts

Total markers 207, new 197, stale 10, existing 0, orphans reported by the checker 5, all of them recipes under `assets/recipes/04-variants/` left over from a part directory that no longer exists.
