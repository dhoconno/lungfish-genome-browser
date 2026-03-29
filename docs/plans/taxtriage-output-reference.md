# TaxTriage Output Reference

## Key Files for GUI Display

### Primary Data Sources (parse in Swift)
1. `report/all.organisms.report.txt` — TSV, 33 columns, TASS scores + categories
2. `report/<sample>.organisms.report.txt` — per-sample TSV
3. Per-sample `<sample>.paths.json` — structured JSON with nested organisms + sub-scores
4. `alignment/<sample>.bam` + `.csi` — multi-reference BAM for alignment inspection

### Display in WKWebView/PDFKit
5. `report/all.organisms.report.pdf` — clinical-grade PDF report
6. `report/combined_krona_kreports.html` — Krona taxonomy plot
7. `report/all.comparison.report.html` — multi-sample heatmap
8. `report/multiqc_report.html` — aggregate QC

### Optional Outputs
9. `assembly/` — de novo contigs (Flye/MEGAHIT)
10. `bcftools/<sample>.<taxid>.vcf.gz` — variant calls
11. `bcftools/<sample>.consensus.fa` — consensus FASTA

## TASS Score Components
- Breadth log score (sigmoid-transformed coverage fraction)
- Gini coefficient (coverage evenness)
- Minhash reduction (false positive detection via Sourmash)
- HMP percentile (abundance vs healthy humans)
- MapQ score (mapping quality)
- Disparity score (reads vs other organisms)
- K2 disparity (classifier vs aligner agreement)
- Diamond identity (optional protein verification)

## Confidence Thresholds by Sample Type
| Type | Threshold |
|------|-----------|
| Sterile/Blood/CSF | 0.30 |
| Vaginal | 0.50 |
| Stool | 0.55 |
| Oral | 0.60 |
| Nasal | 0.65 |
| Skin/Wound | 0.70 |
| Unknown | 0.50 |

## Microbial Category Colors
| Category | Color | Hex |
|----------|-------|-----|
| Primary pathogen (direct) | Light coral/red | #F08080 |
| Primary pathogen (derived) | Orange | #FAB462 |
| Commensal | Light green | #90EE90 |
| Opportunistic | Light yellow | #FFE6A8 |
| Potential pathogen | Light blue | #ADD8E6 |
| Unknown | White | #FFFFFF |

## Samplesheet CSV Format
| Column | Required | Description |
|--------|----------|-------------|
| sample | Yes | Unique sample name |
| platform | Yes | ILLUMINA, OXFORD, PACBIO |
| fastq_1 | Yes | Path to R1 FASTQ |
| fastq_2 | No | Path to R2 FASTQ (paired-end) |
| type | Recommended | Sample type (blood, stool, oral, etc.) |
| negative | No | Negative control sample name |
| positive | No | Positive control sample name |
