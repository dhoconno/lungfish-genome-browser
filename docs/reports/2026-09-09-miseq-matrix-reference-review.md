# MiSeq MHC reference matrix review — 2026-09-09

Reviewed the reference bundle `MCM-MHC-miSeq-primary-20260620.lungfishmhcref` and result `amplicon-genotyping_1.lungfishgenotype` in `/Volumes/Roger Lungfish Browser/32594_LGE_MS257_AG-MCM43-44_FLD.lungfish` with separate MHC genomics, bioinformatics, and UI reviewers.

## Findings

The reference contains 64 collapsed sequence targets, seven with multiple allele aliases. The result contains 105 sample-target observations across five samples and 41 distinct targets. Four observed targets have multiple aliases. Those aliases describe an unresolved sequence match; they must remain together on a single row, with one support count. Names, suffixes such as `N`, and allele resolution must be preserved exactly.

The matrix previously displayed synthetic identifiers and enabled biological allele ordering only for full-length ONT results. Its generic locus parser interpreted the `MCM_MHC_MiSeq_` prefix as `MHC-MCM`, overlooking `source_loci`. Consequently locus-relative support percentages also used the wrong denominator.

The source locus identifies the gene. `haplotype_groups` identifies the evidence group used by the haplotyper and is not a substitute for the gene locus. DQA1 and DQB1 remain distinct matrix loci even when the haplotyper combines their evidence into DQ.

## Display behavior

Use the complete `alleles=` metadata as the analyst-facing Allele field. Join multiple alternatives with ` / `, preserving all names without splitting or duplicating read counts. Retain the original full identifier as the scientific identity and expose it through the optional **Full reference name** column. Use the established MHC biological comparator with support for both underscore and asterisk allele separators. Keep E among class I loci and numbered AG loci with AG. Give MiSeq aliases a wider default column; summary counts and full identifiers remain available from Columns. Preserve existing reference-metadata behavior for ordinary FASTA and full-length ONT results.

Search should find both the displayed alleles and raw identifiers. Visible-view exports should show the concise label while carrying the raw identity separately so annotations still apply to the correct row.

## Workbook failure

The initial Python MiSeq workbook report uses `startedAt`/`completedAt` provenance fields. The managed workbook update path treated it as the canonical Swift provenance envelope, which requires `createdAt`, causing the reported decoding failure. Recognize the specific legacy report format when determining managed workbook state, retain it as source provenance, and write canonical provenance for the successful update. Do not fabricate a creation timestamp or broadly ignore malformed provenance.

The supplied annotation sidecar has no matrix reviews, styles, or comments and contains no `MHC-MCM` targets. The original scientific bundle is retained while reproduction runs use a separate copy.

## Generated XLSX grouping

The Python report formatter tested an `A1` suffix before recognizing DQA1/DPA1 and a `B` suffix before DRB. Class II checks now precede class I suffix checks. Numbered B loci (including B17 and B21Ps) enter the B section, and K has its own section instead of falling through to DP. Each section sorts by the displayed allele with natural numeric ordering, rather than by the opaque reference number.

These changes apply to newly generated reports. Annotation-only workbook updates deliberately retain existing worksheet values; they do not regenerate historical section headings. The scratch report regenerated for validation is not a replacement deliverable because its diagnostic-definition staging input was unavailable.

## Validation

- Read-only matrix smoke against the supplied result: 41 target rows, five samples, and 106,454 total unique-read counts retained.
- Original workbook update failure reproduced on a separate copy, then completed successfully with the fix. Original five worksheet cell values and original report provenance retained; new canonical provenance records the command, resolved options, managed runtime, checksums/sizes, exit status, stderr, timing, and publication.
- Regenerated report validation compared all 105 sample/target read counts, preserved labels, and checked natural ordering within nine sections, including explicit K and DPA/DPB-only DP rows.
- Focused display, export annotation identity, workbook authority, and broader ONT bundle/haplotype regression suites exercised the changes. Test logs are local development artifacts under `/tmp/lungfish-miseq-*` and `/tmp/lungfish-mhc-*`.

No original reference or genotype bundle payload was edited. Changes are source-code changes in this repository, not a packaged application release.
