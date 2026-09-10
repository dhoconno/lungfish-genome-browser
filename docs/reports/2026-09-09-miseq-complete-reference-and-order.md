# Complete MiSeq MHC reference and display order

The revised reference is at `outputs/mcm-mhc-complete-reference-20260909/MCM-MHC-miSeq-complete-primary-haplotypes-20260909.lungfishmhcref`. It contains 218 sequence targets: the 189-target full reference plus 29 additional strand-unique targets from the original 180-record FASTA. Of the original records, 108 match the full reference in the forward orientation and 43 match in reverse complement. The merger does not trim or merge near matches.

All 64 primary diagnostic headers and sequences are retained exactly. The embedded primary haplotype definition is byte-for-byte unchanged (SHA-256 `d04dc74b602ec542a6c2a997a1b8debd7b227c8866a0af2e90b8fbfcf4e14f97`): 42 haplotypes across six evidence loci. Adding genotyping targets does not add haplotype evidence associations. Multiple allele aliases remain together on one target with one read count. Unclassified control names remain unclassified.

The bundle stores this default matrix order:

`F → G → AG → A1 → A2/A3/A4/A5 → K → L → E → B → DRB → DQA → DQB → DPA → DPB`

The order uses allele gene names, rather than haplotype evidence groups. Thus A1 and A2 remain distinct for display, and DQA/DQB and DPA/DPB can be ordered separately. Unlisted loci follow the named groups. The bundle includes MHC-A2 targets from both the full reference and the original FASTA.

In the Inspector, **View → Genotype Display → Locus display order** accepts a comma-separated order and slash-separated groups. **Apply** saves an audited analysis override; **Use Bundle Default** clears it. The Included Loci controls continue to select haplotype evidence loci. Result manifests retain the bundle default, so display order does not depend on the source volume remaining mounted. View exports preserve the effective sorting settings in their projection and provenance.

Plain FASTA references use leading integer prefixes for default matrix sorting, including prefixes larger than machine integer limits. Numbered records precede unnumbered records; equal integer prefixes have a deterministic natural-name tie break. An explicit locus display order takes precedence.

The reported `05_M4_A1_031_01` failure occurred when workbook publication treated every imported `.lungfishref` as an annotated MHC catalog. Imported FASTA references without a record store now use their retained FASTA snapshot as the generic row authority. Annotated MHC catalogs retain strict validation. Arbitrary FASTA identifiers remain valid genotyping identities without inventing allele annotations.

The merger and bundle builder retain source snapshots, sequence mapping, workflow versions, commands, options/defaults, runtime identity, input/output hashes and sizes, timing, exit status, and stderr. Canonical bundle provenance describes the final stored payload. The original source and analysis payloads were not edited.

The external Roger Lungfish Browser volume became unavailable during this work. The revised deliverable is therefore local. Existing analysis counts must be regenerated against the new reference; adding sequences to a reference does not retroactively genotype an old result.

## Verification

- Merger regression passes; independent data audit confirms 218 targets, all 180 raw records represented, all 64 primary targets retained exactly, and unchanged haplotype definition bytes.
- 34 final sorting and Inspector tests pass, covering numeric prefixes, explicit locus overrides, persistence, reset, projection, and provenance. The editor was also visually inspected.
- 48 final workflow/core/CLI regressions pass with no skips, including reference-catalog authority, Unknown controls, builder output hashes/version, and a synthetic imported-FASTA pipeline that generates a real workbook with the production report script and openpyxl. Mapping and filtering use deterministic test doubles; this is not a rerun of the unavailable five-sample experiment.
- Unclassified reference rows require an authoritative raw reference identity. Candidate rows still require a resolved locus; strict annotated MHC reference validation is retained.
- The bundle container is explicitly unhashed to avoid a self-referential digest as provenance is written. Each scientific payload file has a final path, SHA-256, and size. CLI provenance uses the canonical CLI version.
- Final independent bundle audit passes: all 17 visible payload files are attested, all 20 regular-file input/output descriptors and the input-directory digest verify, no output path points to staging, and provenance records `lungfish-cli 2026.9.14`. The embedded reference passes CLI integrity validation.
- Debug coordinator `debug --portable` completes successfully. The resulting app is installed at `/Applications/Lungfish Debug.app`, version 2026.9.14 (build 1). Installed signature, CLI version, executable relocation smoke, and equality with the built GUI/CLI executable hashes all pass.
