# Metagenomics Three-Fix Plan

## Issue 1: BAM Pileup Layout
- Pileup buried at bottom of scrolling detail pane
- For low read-count detections (1-10 reads), pileup IS the most important view
- Fix: dynamically size coverage chart vs pileup based on read count
  - <50 reads: minimize coverage chart (80px), maximize pileup
  - ≥50 reads: equal split

## Issue 2: EsViritu Results Not Persisted
- Results display but aren't saved to disk
- Not visible in sidebar after running
- Not available between app launches
- Need: save results as a classification result directory in the FASTQ bundle
  (like classification-{UUID}/ for Kraken2)
- Need: sidebar discovery + Document Inspector for classification results
- Inspector should show: classifier version, parameters, databases used

## Issue 3: Nextflow Detection + TaxTriage UI Issues
- Nextflow installed via conda but not detected by wizard
  (likely checking PATH but conda envs aren't in PATH)
- TaxTriage wizard layout is wrong/broken
- "Clinical Triage" label is misleading — TaxTriage is general-purpose
- Need better descriptive labels for all three analysis types
