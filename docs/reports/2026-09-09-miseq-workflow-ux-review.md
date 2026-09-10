# miSeq workflow UX review — 2026-09-09

## Conclusion

The workflow has substantial analyst functionality, but its presentation is not yet consistently approachable or suitable for low-vision use. The highest priorities are visible haplotype names, scalable assignment targets, consistent text sizing, accurate setup terminology, and discoverable contextual help. This review proposes changes; it does not change the app or scientific data.

Independent reviewers examined setup/learnability and accessibility. The primary reviewer examined result controls, evidence, legends, column discovery and shared help infrastructure. See the companion learnability and accessibility audits for source references. This is a source/test review informed by the supplied screenshots, with an installed-app accessibility snapshot; it is not a completed staff usability study or end-to-end execution of a new analysis.

## Recommended interaction model

Keep one workflow for everyone. Make common actions obvious, and disclose advanced options when relevant. A separate beginner mode would force users to learn a second interface as their skills develop.

1. **Set up:** choose reads, reference and whether to call haplotypes. Explain the selected reference's capability in one sentence. Show detailed mapper/runtime settings in Advanced.
2. **Review assignments:** open Haplotype Calls with readable names inside the bars. Selecting an assignment opens its evidence. Keep assignment status separate from review warnings.
3. **Inspect observations:** switch to Genotype Matrix to compare allele read support across samples. Keep Allele as the default identity; expose Columns visibly as well as through the existing header context menu.
4. **Focus:** use diagnostic-only display, locus filters and read filters with a compact active-filter summary and a clear reset. Make hidden data apparent without repeatedly explaining the whole filter system.
5. **Curate:** keep arbitrary-name overrides behind the existing explicit name/rationale/acknowledgement/stage/apply flow. Display the original and proposed call together. Do not add friction to selection, inspection or copying.
6. **Deliver:** distinguish updating the current workbook from exporting a filtered copy. Keep the fact that Excel edits do not flow back visible at the export decision; put mechanics in help.

## Help without clutter

Use the existing `LungfishHelpContent.HelpItem` system for a short tooltip and an optional expanded explanation. `Sources/LungfishKit/LungfishHelpContent.swift` already models summaries, details and audiences, but contains no miSeq/genotype/haplotype learning entries. Tooltips should also be available through keyboard focus and an explicit help popover; essential meaning must not require hovering.

Suggested short copy:

| Element | Short help |
| --- | --- |
| Haplotype Calls | Review haplotype assignments inferred from the sample's allele evidence. Select a call to inspect its support. |
| Genotype Matrix | Compare reads supporting each allele or indistinguishable allele group across samples. |
| Diagnostic alleles only | Show alleles used by the active haplotype definitions. This changes the display, not the calls. |
| Total reads | Sum of supporting unique reads across all samples in this result. |
| Haplotype cell colors | Show which assigned haplotypes an allele supports. Shared support is gray; unmatched support is neutral. |
| Locus display order | Arrange allele rows by locus. This changes presentation, not haplotype assignments. |
| Full reference name | Show the original reference identifier and metadata. |

The diagnostic filter's expanded help must retain the distinction that it uses all active definitions, including unresolved calls, rather than only alleles supporting the currently assigned pair. Total reads must explicitly describe all result samples, even when some columns are hidden.

Offer a small, dismissible **How to review this result** popover with three concepts: allele observations, haplotype assignments, and evidence linking them. Explain that slash-separated allele labels can represent sequences the assay cannot distinguish. Do not imply that every observed allele is diagnostic or that a read count alone establishes an assignment. Use the actual active reference and repertoire in examples; never hard-code M1/M3 as the only possibilities.

## Concrete result-surface findings

- `GenotypeResultDisplaySection.swift:1280–1320` stacks sizing, layouts, diagnostic filters, thresholds, locus order, visibility, color, highlighting and export. Group routine display controls first; disclose layout/order and annotation styling separately.
- `:1360`, `:1382`, `:1765` and `:1790` put lengthy explanations in caption/caption2 text. Move supporting mechanics to help while retaining concise consequences and active-state feedback.
- `GenotypeComparisonMatrixView.swift:1728–1757` exposes optional columns through a header context menu. Preserve this shortcut and add a visible Columns affordance so discovery does not depend on control-click knowledge.
- `GenotypeComparisonMatrixView.swift:2195–2222` shows only six haplotype legend entries and sends the remainder to hover. Provide an expandable, keyboard-accessible legend that includes the complete active repertoire.
- `GenotypeCallEvidenceView.swift:984` caps visible associated haplotypes at five and adds a count. Provide an explicit expand action for remaining associations, preserving compact default rows.
- Evidence controls already provide useful targeted help, and matrix cells already support tooltips and accessible metadata. Extend those patterns instead of adding permanent instructional paragraphs to every row.

## Accessibility priorities

1. Draw names in assigned haplotype slots with readable foreground contrast.
2. Make bar height and glyph size follow shared typography. Current slots are approximately 13 pt high, even when row text is enlarged. Start with a comfortable mode of at least 24 pt per slot as a design target, then validate with staff; preserve compact mode as an option.
3. Apply text sizing to Inspector/help/reference-shell content and primary actions as consistently as the main matrix.
4. Preserve existing keyboard and VoiceOver behavior, and ensure full labels and legends remain available without color or hover.

These dimensions are proposed design targets, not a claim of standards compliance. The existing matrix's shared typography and automatic text contrast are strengths to retain.

## Validation and acceptance

Use actual reference and result copies without changing original scientific assignments. Test default and largest text sizes, narrow and wide windows, light/dark appearance, Increase Contrast, keyboard-only navigation and VoiceOver. Verify full names can be inspected, primary actions remain reachable, and target/focus behavior survives filtering and refresh.

Ask a new analyst to choose a reference, explain genotype versus haplotype, inspect support for an assignment, reveal all observed alleles, find hidden columns, cancel an override and export the intended view. Ask an experienced analyst to do the same quickly with shortcuts. Include lab staff with low vision; record wrong actions, missed controls and requests for help. A source audit alone cannot establish that all staff can use the interface effectively.
