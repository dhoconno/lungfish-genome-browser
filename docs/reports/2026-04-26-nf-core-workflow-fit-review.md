# nf-core workflow fit review

Date: 2026-04-26

Source reviewed: live nf-core pipeline registry at `https://nf-co.re/pipelines.json` and the
nf-core website pipeline index. The registry returned 148 workflows.

## Executive summary

The user's intuition is right: for most nf-core workflows, the run dialog is not the hard
part. nf-core pipelines already expose structured schemas, and Lungfish already has an
`NFCoreRegistry`, Nextflow schema types, operation tracking, managed conda/Nextflow support,
and project/bundle result views. A generic schema-driven run dialog plus Docker/conda executor
choice is a tractable platform feature.

The hard part is result interpretation. Pipelines whose outputs are FASTQ, FASTA, BAM/CRAM,
VCF/BCF, BED/GFF/GTF, TSV, HTML, and MultiQC reports fit the current project/sidebar,
list/detail, reference/mapping viewport, and Inspector paradigms. Pipelines that produce
single-cell embeddings, spatial images, microscopy segmentations, proteomics spectra,
Hi-C matrices, pangenome graphs, tumor reports, or non-genomics outputs need new domain
models and visualization surfaces.

Recommended path:

1. Build a generic nf-core launcher first: registry browser, schema-driven parameter form,
   local executor profile, run folder, logs, and generic result bundle.
2. Add result adapters for the easy set first, especially `fetchngs`, `bamtofastq`,
   `fastqrepair`, `seqinspector`, `references`, `nanoseq`, `viralrecon`, and `vipr`.
3. Add moderate adapters by result family: variant/cancer, RNA/expression, epigenomic tracks,
   metagenomics/taxonomy, assembly/annotation, and cohort/statistics.
4. Treat hard workflows as separate product surfaces rather than simple nf-core dialog additions.

## Scoring rubric

- **Easy**: run dialog plus generic result browser is enough, or outputs map directly to existing
  Lungfish artifacts: FASTQ datasets, reference bundles, mapping bundles, variant tracks, reports,
  logs, or MultiQC HTML.
- **Moderate**: Nextflow launch is straightforward, but good UX requires a specific result
  adapter or modest new viewer: expression matrices, peak/signal tracks, taxonomic abundance
  tables, phylogenetic trees, cohort variant summaries, fusion tables, methylation summaries,
  or assembly QC comparisons.
- **Hard**: meaningful UX requires a new domain model or visualization class: single-cell and
  spatial omics, microscopy/image segmentation, proteomics/metabolomics, Hi-C contact matrices,
  pangenome graphs, complex clinical oncology reports, network medicine, astronomy, remote
  sensing, or other non-genome-explorer domains.

## Existing Lungfish surfaces that help

- Generic project sidebar and list/detail navigation.
- Harmonized reference/mapping viewport for contigs, mapped reads, variant tracks, and Inspector
  actions.
- Existing reference bundle and mapping bundle concepts.
- Existing metagenomics/classification workflows and result sidecars.
- Existing Nextflow/nf-core registry and schema model code.
- Operation tracking and managed local tool/runtime support.

## Platform work needed before individual pipeline adapters

1. **Registry browser**
   - Search/filter all nf-core workflows.
   - Show released/WIP/deprecated status, docs link, version pin, and schema availability.

2. **Schema-driven run dialog**
   - Generate controls from `nextflow_schema.json`.
   - Provide file pickers for path parameters.
   - Support executor choice: Docker, conda, possibly local.
   - Save run presets per project.

3. **Run bundle**
   - A `.lungfishrun` or similar bundle containing params, command, Nextflow version,
     pipeline version, executor, logs, timeline/trace/report, MultiQC, and output manifest.

4. **Result adapter interface**
   - Each adapter declares the output files it recognizes and which Lungfish artifacts it can
     create: FASTQ dataset, reference bundle, mapping bundle, variant track, taxonomy table,
     expression table, report-only result, etc.

5. **Generic report view**
   - Every pipeline should at least open logs, command provenance, output folder, Nextflow reports,
     and MultiQC/HTML artifacts.

## Easy workflows

These should be implementable with the generic launcher plus light result import because their
outputs are already close to current Lungfish concepts.

- `nf-core/bacass`
- `nf-core/bamtofastq`
- `nf-core/demo`
- `nf-core/demultiplex`
- `nf-core/detaxizer`
- `nf-core/fastqrepair`
- `nf-core/fastquorum`
- `nf-core/fetchngs`
- `nf-core/genomeannotator`
- `nf-core/genomeassembler`
- `nf-core/genomeskim`
- `nf-core/isoseq`
- `nf-core/nanoseq`
- `nf-core/readsimulator`
- `nf-core/references`
- `nf-core/seqinspector`
- `nf-core/vipr`
- `nf-core/viralrecon`

Best first wave:

- `fetchngs`: imports public FASTQ plus metadata into project datasets.
- `bamtofastq`: converts current BAM/CRAM inputs into FASTQ datasets.
- `fastqrepair`: produces repaired FASTQ datasets plus QC.
- `seqinspector`: report-only QC workflow using generic report/MultiQC view.
- `references`: produces reusable reference bundles.
- `nanoseq`: produces QC plus alignments that can become mapping bundles.
- `viralrecon` and `vipr`: align naturally with reference, mapped reads, consensus, and variant
  tracks already central to Lungfish.

## Moderate workflows

These are practical, but each needs a result adapter and often one additional view mode or Inspector
tab. Most should still be considered good candidates after the launcher exists.

### Variant, clinical, and cohort genomics

These produce BAM/VCF-compatible artifacts, but useful UX needs sample grouping, annotation,
filtering, interpretation tables, SV/CNV support, benchmarking views, or clinical-style summaries.

- `nf-core/createpanelrefs`
- `nf-core/deepvariant`
- `nf-core/exoseq`
- `nf-core/genomicrelatedness`
- `nf-core/longraredisease`
- `nf-core/pacvar`
- `nf-core/radseq`
- `nf-core/raredisease`
- `nf-core/rarevariantburden`
- `nf-core/rnadnavar`
- `nf-core/rnavar`
- `nf-core/sarek`
- `nf-core/tumourevo`
- `nf-core/variantbenchmarking`
- `nf-core/variantcatalogue`
- `nf-core/variantprioritization`

Information needed:

- Which result classes matter first: SNV/indel only, SV, CNV, purity/ploidy, signatures,
  clinical reports, or benchmarking metrics.
- Whether Lungfish should normalize these outputs into one variant database model.
- How strongly to support tumor/normal pairing and cohorts in the Inspector.

### RNA, expression, transcript, and fusion workflows

These can reuse BAM/reference tracks, but their main outputs are matrices, count tables,
differential-expression results, fusions, splicing events, or transcript annotations.

- `nf-core/alleleexpression`
- `nf-core/cageseq`
- `nf-core/circrna`
- `nf-core/denovotranscript`
- `nf-core/differentialabundance`
- `nf-core/drop`
- `nf-core/dualrnaseq`
- `nf-core/evexplorer`
- `nf-core/hlatyping`
- `nf-core/lncpipe`
- `nf-core/metatdenovo`
- `nf-core/nanostring`
- `nf-core/ncrnannotator`
- `nf-core/rnafusion`
- `nf-core/rnaseq`
- `nf-core/rnasplice`
- `nf-core/slamseq`
- `nf-core/smrnaseq`
- `nf-core/stableexpression`
- `nf-core/tfactivity`

Information needed:

- Whether expression matrices should be first-class Lungfish datasets or just report tables.
- Minimum useful plots: sample QC, PCA/UMAP, heatmap, volcano, MA plot, fusion table,
  splice-junction table.
- Whether gene annotations/transcript models should attach to reference bundles.

### Epigenomic interval and signal workflows

These need BED/narrowPeak/bigWig-like interval and signal tracks. This is conceptually close to
the harmonized reference viewport, but Lungfish needs a more general track model beyond BAM/VCF.

- `nf-core/atacseq`
- `nf-core/chipseq`
- `nf-core/circdna`
- `nf-core/clipseq`
- `nf-core/cutandrun`
- `nf-core/methylarray`
- `nf-core/methylong`
- `nf-core/methylseq`
- `nf-core/mnaseseq`
- `nf-core/nascent`
- `nf-core/riboseq`
- `nf-core/sammyseq`
- `nf-core/ssds`

Information needed:

- Which track formats to support first: BED, GFF/GTF, narrowPeak/broadPeak, bedGraph, bigWig.
- Whether signal tracks should have their own Inspector tab.
- How to handle multiple samples and differential peak sets.

### Metagenomics, taxonomy, pathogen, and functional profiling

These fit Lungfish better than most domains because the app already has metagenomics workflows,
but nf-core outputs differ by pipeline and need adapters for abundance tables, bins, taxonomic
trees, MAGs, phage annotations, and functional hits.

- `nf-core/ampliseq`
- `nf-core/coproid`
- `nf-core/createtaxdb`
- `nf-core/eager`
- `nf-core/funcprofiler`
- `nf-core/funcscan`
- `nf-core/mag`
- `nf-core/magmap`
- `nf-core/metapep`
- `nf-core/pathogensurveillance`
- `nf-core/phageannotator`
- `nf-core/phyloplace`
- `nf-core/proteinfamilies`
- `nf-core/taxprofiler`
- `nf-core/tbanalyzer`
- `nf-core/viralmetagenome`

Information needed:

- Whether taxonomy results should map into the existing metagenomics sidecar/store.
- Whether MAG/bin views should be reference-bundle-like, taxonomy-table-like, or a new bundle type.
- Which databases and classifiers Lungfish should manage versus leaving to nf-core params.

### Assembly, annotation, comparative genomics, and phylogeny

These often produce FASTA/GFF-compatible files, but good interpretation needs assembly QC,
comparative tables, trees, dot plots, or multiple-alignment views.

- `nf-core/bactmap`
- `nf-core/crisprvar`
- `nf-core/denovohybrid`
- `nf-core/epitopeprediction`
- `nf-core/genephylomodeler`
- `nf-core/genomeqc`
- `nf-core/kmermaid`
- `nf-core/multiplesequencealign`
- `nf-core/neutronstar`
- `nf-core/pairgenomealign`
- `nf-core/proteinannotator`
- `nf-core/reportho`
- `nf-core/viralintegration`

Information needed:

- Whether Lungfish needs a tree viewer and dot-plot/synteny viewer.
- Whether multiple FASTA/reference outputs should become a collection bundle.
- How much protein/amino-acid annotation should be supported in a genome explorer.

### Specialized but still plausible

These are not first-wave candidates, but could be supported with focused table/report adapters.

- `nf-core/abotyper`
- `nf-core/airrflow`
- `nf-core/crisprseq`
- `nf-core/deepmutscan`
- `nf-core/gwas`
- `nf-core/hgtseq`
- `nf-core/mitodetect`
- `nf-core/phaseimpute`

Information needed:

- Which of these domains are strategically important to Lungfish users.
- Whether a generic tabular result viewer is good enough initially.
- Whether any require specialized domain vocabulary in the Inspector.

## Hard workflows

These are hard because the output is not primarily a genome-browser artifact. They can still be
launched from a generic nf-core runner, but "good Lungfish support" would mean new product areas.

### Single-cell and spatial omics

- `nf-core/hadge`
- `nf-core/marsseq`
- `nf-core/panoramaseq`
- `nf-core/pixelator`
- `nf-core/scdownstream`
- `nf-core/scflow`
- `nf-core/scnanoseq`
- `nf-core/scrnaseq`
- `nf-core/smartseq2`
- `nf-core/sopa`
- `nf-core/spatialvi`
- `nf-core/spatialxe`

Needed interfaces:

- Matrix-backed datasets.
- Cell/sample metadata browser.
- Embedding plots, cluster selection, marker-gene tables.
- Spatial image/coordinate overlays for Visium/Xenium/spatial pipelines.

### Imaging, cytometry, and segmentation

- `nf-core/cellpainting`
- `nf-core/imcyto`
- `nf-core/lsmquant`
- `nf-core/mcmicro`
- `nf-core/molkart`
- `nf-core/rangeland`

Needed interfaces:

- Large image/OME-TIFF handling.
- Segmentation mask overlays.
- Feature-table linkage between image objects and measurements.
- Non-genome spatial navigation.

### Proteomics, metabolomics, peptide, and mass spectrometry

- `nf-core/ddamsproteomics`
- `nf-core/diaproteomics`
- `nf-core/metaboigniter`
- `nf-core/mhcquant`
- `nf-core/mspepid`
- `nf-core/proteogenomicsdb`
- `nf-core/proteomicslfq`
- `nf-core/quantms`
- `nf-core/ribomsqc`

Needed interfaces:

- Protein/peptide-centric result models.
- Spectra or chromatogram views.
- Quantification matrices and experimental design views.
- Links from proteins/peptides back to genome/transcript annotations where applicable.

### Contact maps, graphs, networks, and high-complexity clinical reports

- `nf-core/diseasemodulediscovery`
- `nf-core/hic`
- `nf-core/hicar`
- `nf-core/omicsgenetraitassociation`
- `nf-core/oncoanalyser`
- `nf-core/pacsomatic`
- `nf-core/pangenome`
- `nf-core/proteinfold`

Needed interfaces:

- Contact map viewer for Hi-C/HiCAR.
- Graph viewer for pangenomes and network medicine.
- Tumor/normal clinical report model if `oncoanalyser` or `pacsomatic` are prioritized.
- 3D protein model surface for `proteinfold`, which is not aligned with current genome views.

### Outside current Lungfish scope or too generic

- `nf-core/callingcards`
- `nf-core/datasync`
- `nf-core/deepmodeloptim`
- `nf-core/drugresponseeval`
- `nf-core/liverctanalysis`
- `nf-core/meerpipe`
- `nf-core/seqsubmit`
- `nf-core/spinningjenny`
- `nf-core/troughgraph`

Needed decision:

- Whether Lungfish should expose these only through a generic "run any nf-core workflow" mode,
  or hide them from the curated workflow browser by default.

## Proposed Inspector model

Keep the Inspector content-driven, not workflow-driven:

- **Run**: pipeline version, executor, command, params, status, logs, retry/cancel/open output.
- **Inputs**: selected FASTQ/BAM/reference/sample sheet and validation.
- **Results**: detected result artifacts and import actions.
- **Reads**: FASTQ/BAM-specific actions.
- **Reference/Tracks**: FASTA, contigs, annotations, mapped reads, variants, intervals, signal.
- **Variants**: VCF/SV/CNV/filtering/annotation/callset actions.
- **Expression**: matrices, gene filters, DE result tables, plots.
- **Taxonomy**: abundance tables, trees, classifier reports.
- **Reports**: MultiQC, HTML, PDFs, static plots.

Tabs should appear disabled or empty when a workflow does not produce that content. This matches
the recent harmonized reference/mapping direction and avoids one-off Inspector layouts per pipeline.

## Implementation recommendation

The scalable architecture is a two-layer system:

1. **Generic nf-core platform**
   - Registry browser.
   - Schema-driven parameter dialog.
   - Local execution profile.
   - Run bundle with provenance/logs/reports.
   - Generic output manifest and report viewer.

2. **Pipeline result adapters**
   - Small adapters detect known nf-core output directories/files.
   - Adapters create Lungfish artifacts or sidecars.
   - Adapters add Inspector tabs/actions only for actual result content.

This keeps adding a new run dialog cheap while making result interpretation explicit and testable.

## Suggested first implementation sequence

1. Generic registry browser and schema dialog.
2. Generic run bundle and report viewer.
3. `seqinspector`, `fetchngs`, `bamtofastq`, `fastqrepair`.
4. `references`, `nanoseq`.
5. `viralrecon` and `vipr`.
6. General interval/signal track support.
7. `sarek` and variant-family adapters.
8. `taxprofiler` and metagenomics-family adapters.
9. RNA/expression-family adapters.
10. Reassess hard workflows only after deciding whether Lungfish is expanding into
    single-cell/spatial/proteomics/imaging.

