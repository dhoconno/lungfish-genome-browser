# Live spot-check of twenty operation dialogs

Date 2026-09-06. App version 2026.9.13, the Preview channel build, bundle id `com.lungfish.browser.preview`. Project "LGE Manual Demo".

Each dialog below was opened in the running app through the entry point recorded in `docs/user-manual/parameters.yaml`, photographed, and read control by control through the accessibility tree. Pop-up buttons cannot be opened in background mode, so the value shown on the closed control was taken as the default and the allowed list was read from the registry or the Swift source. No dialog was run. Every dialog was closed with its Cancel button.

| operation id | how it was opened | controls seen (label and default) | mismatches against the registry | action taken |
| --- | --- | --- | --- | --- |
| `import.fastq` | `File > Import Center...`, Sequencing Reads pane | card `Sequencing Read Files` with one `Import...` button and the accepted extensions `.fastq.gz, .fq.gz, .fastq, .fq, .bam` printed on the card | none, the card is a file panel and the settings live in the sheet that opens after it | note appended |
| `import.reference` | `File > Import Center...`, Reference Sequences pane | card `Reference Sequences` with one `Import...` button and the accepted extensions printed on the card, matching the registry note | none | note appended |
| `fetch.ncbi` | `Tools > Search Online Databases > Search NCBI...` | `Mode` Nucleotide, `RefSeq Only` off, `Include GFF3 Annotations` on, search scope `All Fields`, and after clicking Show the filters `Organism`, `Location`, `Gene`, `Author`, `Journal`, `Molecule Type` Any, `Sequence Length` blank on both sides, `Publication Date` blank on both sides, `Sequence Properties` none checked | none | note appended |
| `fetch.sra` | same dialog, SRA Runs pane in its sidebar | `Import Accessions` button, search scope `All Fields`, and after clicking Show the filters `Platform` Any, `Strategy` Any, `Layout` Any, `Min Size (Mbases)` blank, `Publication Date` blank on both sides, `Max Results` 50 | none | note appended |
| `fastq.fastp-trim` | `Tools > Trimming & Filtering > fastp Adapter + Quality Trim...` | `Threshold` 20, `Window Size` 4, `Mode` Cut Right, `Adapter Mode` Auto-Detect, `Output Strategy` Per Input | none, and `Adapter Sequence` was hidden exactly as the note says | note appended |
| `fastq.remove-human-reads` | `Tools > Decontamination > Remove Human Reads...` | `Output Strategy` Per Input, with a `Choose...` database button in the Inputs section | none, the Primary Settings pane carries the fixed-chooser wording the note records | note appended |
| `fastq.remove-duplicates` | `Tools > Decontamination > Remove Duplicates...` | `Preset` Exact PCR, `Output Strategy` Per Input | none, and the three Custom controls were hidden exactly as the note says | note appended |
| `fastq.merge-overlapping-pairs` | `Tools > Read Processing > Merge Overlapping Pairs...` | `Strictness` Normal, `Minimum Overlap` 12, `Output Strategy` Per Input | none | note appended |
| `fastq.subsample-by-proportion` | `Tools > Search & Subsetting > Subsample by Proportion...` | `Proportion` empty, `Output Strategy` Per Input, and a Readiness line reading `Enter a proportion between 0 and 1.` | none | note appended |
| `map.minimap2` | `Tools > Mapping > minimap2...` | `Reference` chr20_10.0-10.5Mb, `Preset` Short-read, read group `ID (--rg-id)` HG002, `Sample (--rg-sm)` HG002, `Library (--rg-lb)` HG002, `Platform (--rg-pl)` ILLUMINA, `Platform unit (--rg-pu)` HG002, `Threads:` 14, `Secondary alignments:` off, `Supplementary:` on, `Min mapping quality:` 0, `Extra arguments` empty | two, `Preset` renders as a pop-up rather than a radio group because the six options exceed the three-option segmented cutoff in `MappingWizardSheet.swift`, and the menu item carries a trailing ellipsis the entry point omitted | registry corrected, note appended |
| `bam.mark-duplicates` | not opened | not read | not assessed | none, see the note below the table |
| `bam.primer-trim` | not opened | not read | not assessed | none, see the note below the table |
| `variants.call-bcftools` | not opened | not read | not assessed | none, see the note below the table |
| `classify.kraken2` | `Tools > Classification > Kraken2...` | `Database` SILVA, `Sensitivity` Balanced, `Confidence:` 0.20, `Min hit groups:` 2, `Threads:` 4, `Memory mapping:` off, `Extra arguments:` empty | none | note appended |
| `classify.esviritu` | `Tools > Classification > EsViritu...` | `Sample` HG002, `Enable quality filtering (fastp)` on, `Min read length:` 100 bp, `Threads:` 14, `Extra arguments:` empty | one, `Sample` arrives filled with the detected sample name rather than empty, which `EsVirituWizardSheet.swift` line 230 sets on appear | registry corrected, note appended |
| `assemble.spades` | `Tools > Assembly > SPAdes...` | `Assembler` SPAdes, `Read Type` the locked label Illumina short reads, `Profile` Isolate, `Threads` 8, `Memory Limit` 32 GB, `Min Contig` 0 bp, `Careful mode` off, `Skip error correction` off, `Extra arguments` empty, `Project Name` HG002_assembly | none | note appended |
| `msa.mafft` | `Tools > Multiple Sequence Alignment > MAFFT...` | `Strategy` Automatic, `Sequence Type` Auto, `Output Order` Input Order, `Direction Adjustment` Off, `Symbol Policy` Strict Alphabet, `Threads` blank, `Deterministic threading` on, the FASTQ toggle off, `MAFFT Parameters` empty | none, and the scope radio group was replaced by the summary line the note describes | note appended |
| `tree.iqtree` | not opened in background mode, context menu only | not read | not assessed | none, see the note below the table |
| `genotype.miseq-amplicon` | `Tools > Genotyping > miSeq amplicon MHC genotyping...`, which opens the separate Workflow Operations window | `Project Reference` a pop-up showing Reference Sequences/chr20_10.0-10.5Mb.lungfishref beside Replace and Clear buttons, `Report Name` amplicon-genotyping, `Threads` 14, `Min Reads` 1, `Analysis Mode` Genotype only, and under the collapsed Advanced Options `minimap2 arguments` empty and `Keep Intermediates` off | two, the reference control is a pop-up labelled `Project Reference` rather than a plain file control labelled `Reference`, and `Report Name` is the fixed literal amplicon-genotyping rather than a name built from the read files | registry corrected, note appended |
| `workflow.viral-recon` | `Tools > Mapping > Viral Recon...` | `Scheme` ARTIC SARS-CoV-2 V3 (Built-in), `Minimum mapped reads:` 1,000, and under the collapsed Advanced group a `Choose GFF...` button and `Extra parameters` empty | two, the `Scheme` default and its allowed list used directory names where the pop-up shows manifest display names, so the alphabetically first entry is ARTIC SARS-CoV-2 V3 and not ARTIC-SARS-CoV-2-V4, and the reads label carries a trailing colon | registry corrected, note appended |

## Operations not opened

Sixteen of the twenty were opened and read. Four were not, for two separate reasons.

`tree.iqtree` has no menu-bar entry at all. Its only entry point is the alignment viewport's context menu, and background mode cannot open a context menu, so this row is recorded as not opened in background mode rather than forced.

`bam.mark-duplicates`, `bam.primer-trim`, and `variants.call-bcftools` all need the chr20 reference bundle selected in the sidebar before their entry point becomes reachable. Selecting a sidebar row needs a momentary front-most switch, and the computer-use layer refused every such action for the whole second half of the session because the user was typing in another application. Menu commands and sheet buttons kept working throughout, which is why the other sixteen completed. `Tools > Call Variants...` was reached and it answered with the alert `No Bundle Loaded`, confirming the entry point exists and is gated on a loaded bundle. These three should be retried when the machine is idle.

## Registry changes made

Six settings were corrected across five operations.

- `map.minimap2` entry point gained the trailing ellipsis the menu item carries, and `Preset` changed from `radio` to `popup`.
- `classify.esviritu` `Sample` default changed from empty to the detected sample name filled in on open.
- `genotype.miseq-amplicon` `Reference` became `Project Reference` with control `popup`, and `Report Name` default became the fixed literal amplicon-genotyping.
- `workflow.viral-recon` `Scheme` default and allowed list moved to the manifest display names, and the reads label became `Minimum mapped reads:` with its trailing colon.

The sentence `Live-checked in Preview 2026.9.13 on 2026-09-06.` was appended to the `notes` of all sixteen operations that were opened.
