# MHC Reference Completeness-Aware Classification Design

## Goal

Prevent full-length genomic MHC references from being labeled as partial extensions when an ONT cluster matches the entire curated reference exactly and contains only terminal primer/barcode-derived soft-clipped sequence.

## Reference completeness

Each `MHCReferenceRecord` carries a genomic-completeness assessment with a status (`complete`, `incomplete`, or `unknown`), a machine-readable reason, observed exon/intron numbers, and the accepted terminal exon numbers for its locus topology.

The catalog derives this assessment from the bundle's imported annotation SQLite track. A genomic record is complete only when:

- its locus has a supported topology;
- numbered exons form a continuous chain beginning with exon 1;
- the terminal exon number is accepted for that locus;
- exon 1 starts at reference coordinate zero and the terminal exon ends at the reference length;
- each adjacent exon pair is separated by the correspondingly numbered intron; and
- a non-fuzzy CDS spans the same complete reference interval.

The initial topology policy accepts terminal exons 7 or 8 for class-I loci (including MHC-E), exon 5 for DRA loci, and exon 6 for DRB, DPA, DPB, DQA, and DQB loci. Unsupported loci and bundles without usable annotations remain `unknown`; they are never promoted by the new rule. cDNA records remain in the cDNA structural-extension pathway regardless of exon coverage.

## Classification

The existing exact end-to-end genomic rule remains valid. In addition, a zero-SNP alignment to a reference assessed as complete is known when it starts at reference base 1, spans the entire reference, contains no insertion, deletion, skipped reference, or hard clipping, and differs from the reference only by terminal soft clipping. Soft-clipped sequence is treated as non-allelic primer/barcode flank only in this branch.

Incomplete or unknown genomic references retain the existing partial-extension behavior. Any internal substitution or indel prevents the completeness-aware known promotion.

## Reproducibility

The reference-catalog projection records each reference's assessment and evidence. The catalog-import provenance includes the annotation database as a checksummed input, the resolved topology policy, assessment counts, exact argv, defaults, output, exit status, timing, and stderr behavior required by the repository provenance policy. Candidate-classification provenance records the revised precedence and soft-clip rule.

## Verification

Tests cover complete seven- and eight-exon class-I references, complete shorter class-II references, cDNA, missing annotations, missing introns, missing boundary exons, fuzzy CDS annotations, Mamu-E-style bilateral soft clipping, internal indels, catalog provenance, backward decoding, and existing DRB partial-extension behavior. The final deliverable is a fresh `Lungfish Debug.app` built from the isolated worktree.
