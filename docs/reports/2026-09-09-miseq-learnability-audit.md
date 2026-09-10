# miSeq setup and learnability audit — 2026-09-09

Scope: source review of Workflow Operations and the FASTQ operation entry path. No production edits, no scientific outputs changed. This is a heuristic review, not an observed novice usability session or accessibility certification. Source locations refer to the current checkout.

## What already works

- Inputs, primary settings, advanced settings, output and readiness are grouped consistently (`WorkflowOperationsDialog.swift:98–132`). Keep this sequence.
- The MHC bundle collapses assay/species/definition selectors to the bundle’s paired definition (`WorkflowOperationsDialog.swift:416–443`). This is useful progressive disclosure.
- Advanced minimap2 arguments and intermediate retention are behind a disclosure (`WorkflowOperationsDialog.swift:478`). Preserve advanced access.
- Readiness gives a concrete next required input and blocks invalid launch (`WorkflowOperationDialogState.swift:530–581`).
- Execution captures detailed CLI diagnostics (`WorkflowOperationExecutionService.swift:464–475`); retain those for experienced analysts and support.

All source paths below are relative to `Sources/LungfishApp/Views/WorkflowOperations/` unless otherwise stated.

## Prioritized findings

### P1 — Explain what the analysis produces, before algorithm labels

Evidence: `WorkflowOperationDialogState.swift:39–54` exposes “AI preset”, “Deterministic”, “Genotype only”. `WorkflowOperationsDialog.swift:363–394` uses these as the primary haplotyping choice. “Deterministic” names an implementation property and does not tell a new analyst what they will receive. “No haplotyping” remains an option inside the deterministic definition picker (`:462–471`), while readiness rejects the selection (`WorkflowOperationDialogState.swift:578–581`).

Proposed labels: **Defined haplotypes**, **Genotype only**, **AI preset**. Preserve underlying mode identifiers. In defined-haplotype mode use **Choose definition…** as the empty selector label, not “No haplotyping”.

Help, attached to the mode control and available through keyboard focus or an adjacent help popover:

- Defined haplotypes: “Report detected alleles and match their diagnostic evidence to the selected haplotype definitions.”
- Genotype only: “Report detected alleles and supporting reads without assigning haplotypes.”
- AI preset: “Use a preset reference and an AI analysis workflow. Review its conclusions against the read evidence.”

Do not change which workflow runs or silently select a scientific mode as part of a wording update. Evaluate default mode policy separately: initialization currently depends on configured AI access (`WorkflowOperationDialogState.swift:190`).

### P1 — Make MHC bundle versus FASTA explicit

Evidence: file dialog says “Select a .lungfishref bundle or FASTA file” (`WorkflowOperationsDialog.swift:733`), omitting the very `.lungfishmhcref` format used here. The reference section itself contains names/paths but no help explaining the distinction (`:152–190`). Bundle copy only says it pairs a definition with a FASTA (`:441`).

Chooser message for miSeq: **Choose an MHC reference bundle (.lungfishmhcref) or reference FASTA.** Preserve other accepted formats where applicable.

Reference help: “An MHC reference bundle contains allele sequences, haplotype definitions and display order. A FASTA contains sequences; choose a separate definition to call haplotypes.”

Selected bundle summary: **Haplotype definitions: [name] · From reference bundle**. Keep full path/version accessible through help or details, not repeated paragraphs. A compact **Inspect Reference** affordance would let analysts verify content before running.

### P1 — Clarify “Min Reads” and separate scientific thresholds from display filters

Evidence: `WorkflowOperationsDialog.swift:299–300` places “Min Reads” alongside Threads without help. Field helpers (`:657–683`) do not accept HelpItems. By contrast FASTQ setup already uses `LungfishHelpContent.fastqMinReads` at `Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift:559`. That help is generic. The request exposes `haplotypeDropoutEvaluator` using `minSupport` (`Sources/LungfishWorkflow/ONTGenotyping/ONTBarcodeDemuxGenotypingPipeline.swift:328–340`), so wording needs to describe actual miSeq scope rather than borrow a generic cluster/read description.

Proposed label: **Minimum supporting reads**. Proposed help after confirming all affected outputs in the pipeline: “Minimum read support used when evaluating haplotype evidence. This changes the analysis; Inspector filters only change the view.” Keep the distinction visible in a short tooltip, not repeated inline paragraphs. Confirm exact scope before shipping this copy; this audit did not exhaustively trace every pipeline consumer of minSupport.

Reuse the shared `lungfishHelp` infrastructure in the Workflow Operations field helpers so both entry paths have consistent help and accessibility descriptions. Threads help: “Worker threads used for this run. More threads can shorten processing time but use more of this computer.”

### P2 — Avoid platform-mismatched guidance

Evidence: miSeq Advanced says arguments follow “the ONT mapping preset” (`WorkflowOperationsDialog.swift:485`) even though the workflow supports Illumina and resolves platform from input metadata (`WorkflowOperationDialogState.swift:406–426`). The separate FASTQ entry path always tells users to select a barcode definition (`Sources/LungfishApp/Views/FASTQ/FASTQOperationToolPanes.swift:562`), although its operation description also supports prepared Illumina samples (`FASTQOperationDialogState.swift:2029`). This audit has not verified which FASTQ pane paths are reachable with every input platform; test both pathways before changing conditional guidance.

Proposed advanced help: “Additional minimap2 options for this run. The selected read platform determines the base mapping preset.” Prefer resolved platform-specific wording when available.

Prepared Illumina help: “Use prepared paired-read sample bundles and an allele reference.” Show barcode instructions only in the barcode-demultiplexing path.

### P2 — Provide a brief learning route rather than permanent instruction blocks

Evidence: the setup overview offers a tool summary and “Open Previous Run…” (`WorkflowOperationsDialog.swift:78–82`), but no task-focused learning entry in this view. New analysts must infer how reference, genotype and haplotype relate from separated controls.

Add one **How this analysis works** help button opening a short, reusable help panel:

1. **Choose the reference.** Allele sequences determine what the read analysis can detect. Haplotype definitions specify which alleles provide diagnostic evidence.
2. **Review haplotypes.** Assigned calls summarize the selected definition’s evidence. Unassigned means the analysis has not assigned that slot; it does not prove that a haplotype is absent.
3. **Inspect genotypes.** Rows show reference allele targets; cells show supporting reads. Some targets represent multiple alleles that this amplicon cannot distinguish.
4. **Review and export.** Inspect evidence before overriding a call. Overrides retain the original call and your rationale. Update the workbook after review.

Keep this panel available from setup and results. Avoid automatic multi-step tours blocking experienced analysts. Use a short first-open hint with a dismiss/persist choice only if user testing finds the help entry insufficient.

### P2 — Make output identity legible without long paths

Evidence: “Report Name” in primary settings (`WorkflowOperationsDialog.swift:295`) is separated from “Directory” (`:547–555`), with destination shown in caption text limited to two lines. FASTQ setup has separate report and analysis names (`FASTQOperationToolPanes.swift:553–554`).

Show a resolved **Result: [name].lungfishgenotype** preview beside destination before launch. Tooltip: “Creates a new analysis bundle here. Open the result to review calls and update its current workbook.” Verify this preview against actual resolved output naming rather than assembling a second independent naming rule. Use **Result name** consistently when the field actually names the bundle; distinguish workbook title only where it is truly independent.

### P2 — Connect recovery to the failed task

Evidence: setup catches launch errors in a generic “Workflow Operation Error” with only OK (`WorkflowOperationsDialog.swift:35–43`). Execution errors are recorded with complete CLI diagnostics (`WorkflowOperationExecutionService.swift:464–475`), but the top-level failure is simply “miSeq amplicon MHC genotyping failed”.

For identifiable validation problems, name the input and recovery: e.g. “Reference could not be read. Choose a valid reference bundle or FASTA.” Provide **Show details** / **Copy failure report** without exposing a wall of stderr by default. Do not guess a cause from exit code alone. Preserve exact diagnostics and prior run provenance. Verify the existing Operation Center actions before adding duplicate recovery controls.

## Accessibility considerations for setup

The setup uses semantic callout/body styles, but essential selected inputs and reference details are `.caption` + `.secondary`, frequently clipped (`WorkflowOperationsDialog.swift:170–173`, `223–226`, `549–552`). Helper text is uniformly caption/secondary (`:651–654`). Manage uses `.controlSize(.small)` (`:424`). These are risk indicators, not measured failures.

- Essential selected filename, analysis mode and readiness should use normal body-sized text with sufficient contrast. Put full paths in selectable details/tooltips.
- Ensure text enlargement increases control and row heights, not only fonts. Fixed-width numeric fields (`:671`, `:681`) must accommodate enlarged text and localized values.
- Help must be reachable by keyboard and screen reader; hover tooltips alone are insufficient.
- Validate at enlarged system display/text settings, increased contrast, reduced transparency and VoiceOver, with real lab staff. Test field labels, focus order, clipped input names and all disabled-state explanations.

## Suggested small implementation sequence

1. Correct format/platform wording and replace “Deterministic” with a user-task label.
2. Reuse shared help support throughout setup; write miSeq-specific threshold help after pipeline verification.
3. Add the reusable short learning panel and resolved result preview.
4. Test two novices and two experienced analysts with the same tasks: select correct bundle, explain genotype vs haplotype, run prepared Illumina input, locate evidence, identify unassigned, perform a deliberate override, export current review state.

Success criteria: no instruction from the observer needed; analysts can explain why a genotype target may name several alleles, distinguish view filters from analytical thresholds, and recover from an invalid reference. Accessibility acceptance requires observed enlarged-text/keyboard/VoiceOver checks, not a source review alone.
