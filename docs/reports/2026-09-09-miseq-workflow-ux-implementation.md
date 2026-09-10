# miSeq UX implementation — 2026-09-09

Implemented the approved workflow review in the existing shared surfaces.

- Haplotype bars display assignment names with automatic readable foregrounds. Comfortable spacing is the default (at least 24 points per slot), Compact is optional, and both follow content text sizing.
- Inspector typography uses the shared observable content-size preference for labels, values, tabs, metadata, evidence, manual overrides, provenance and help. Summary/override rows wrap or stack instead of squeezing enlarged values into fixed label columns. Native mutation buttons receive an explicit shared font.
- Result Inspector includes an explicit, dismissible review guide, concise display-filter guidance and a collapsed layout/locus-order group. Help adapts to whether the result includes haplotyping.
- Matrix Columns is visible as well as available in the header context menu. The full active haplotype legend is available in a scrollable, selectable popover. Long evidence-association lists can be expanded explicitly.
- Setup uses Defined haplotypes, identifies MHC reference bundles, explains their difference from FASTA, and gives read-platform-appropriate guidance. Scientific defaults and mode identifiers are preserved.
- Reference-view summary text uses the shared typography preference. The existing shared sequence table retains its behavior.

No scientific assignments, reference sequences, calling thresholds or provenance contracts were changed by these presentation edits.

## Verification

The initial focused suite passed 306 tests, covering outline virtualization and density, contrast, matrix discovery/legend, evidence, typography and selection, Inspector state and workflow setup. The final Inspector/override suite passed 130 tests with zero failures. The portable Debug coordinator passed relocation/resource smoke and signature validation. Installed and launched `/Applications/Lungfish Debug.app`, version 2026.9.14 build 1; the installed CLI version and app executable smoke both passed.

Low-vision staff usability testing remains valuable: automated geometry, contrast and accessibility checks do not substitute for testing on actual lab displays with the people using them.
