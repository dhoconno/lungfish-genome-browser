# Editor pass: 06-classification/03-running-esviritu

Date: 2026-09-07
Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports "no issues found".
Front matter untouched. `brand_reviewed` and `lead_approved` both remain `false` for the gate.

## Fidelity false rows (6 of 6 applied)

- **Databases tab grouping.** Rewrote step 1.1 to say the tab groups rows by tool and the EsViritu Viral DB is the only row under the **EsViritu Databases** heading. Reviewer's wording, per the project manager's ruling.
- **Run Mode control shape.** Both the step 2 batch note and the Settings entry now say the control offers **Run separately per bundle**, with the bundle count beside it, and a greyed-out **Combine all inputs, run once**. Dropped "fixed on".
- **Run Mode lock reason.** The on-screen caption carries a semicolon, so per the ruling it is paraphrased rather than quoted. The chapter now says the selection runs as one classification batch producing a single Operations Panel entry and a merged summary, with each sample classified on its own inside it. The pooling rationale is kept as the chapter's own explanation, not as the on-screen text. Registry entry `classify.esviritu` already carries the same correction.
- **Phase strings.** Rewrote the step 3 paragraph. Phases are now named as examples that LGE matches against the tool's own output, with an explicit statement that they can repeat, arrive in a different order, or never appear. All claim of sequence dropped. Four of the six are named rather than all ten, per the ruling. The four LGE emits itself are still given in their real order, which the reviewer verified as true.
- **Identity in the reference-run table.** The table row now reads `99.7% (read from the detail pane)`, and the prose says plainly that a display defect leaves the table's Identity column showing 1.0% for the same detection because it prints the stored fraction without converting it. The detail-pane section repeats which figure to read.
- **Export menu.** Now lists **Export as CSV...**, **Export as TSV...**, **Copy Summary**, and **Show Provenance...**.

## Unverifiable row

- "the columns survive closing and reopening the result" is cut. The claim is unsourced and the reviewer could find no reload path in `EsVirituResultViewController`.

## Consensus reader rows (17 of 17 applied)

1. Off-target PCR product glossed, alongside conserved region and PCR duplicates in the same paragraph.
2. Segment cell now reads `not applicable` instead of the literal words "em dash". Two other prose mentions changed to "a dash".
3. Thin-window guidance is qualitative per the ruling. The chapter says to compare a window against the run's own mean depth and notes this run's thinnest window is roughly a quarter of the 1259.4x mean. No invented cutoff.
4. RPKMF now says to compare viruses within one run, or the same virus across runs of similar size, rather than against a fixed number. No invented anchor.
5. Memory check added as Apple menu, About This Mac, Memory line, stated as total memory.
6. Both `db-status` and `download-db` paragraphs marked optional in chapter 33's wording ("and this is optional because the dialog already shows them").
7. Pairing fix now says a correct selection is the one bundle row holding both mates.
8. toolVersion defect now states plainly that only the version label is wrong and the detections and displayed numbers are unaffected.
9. Inspector's three validation states split into their own paragraph with the action each asks for. Only "No reference provided" asks anything. Mismatch and consensus displays glossed. Inspector location and `View > Show Inspector` (Cmd-Opt-I) added, matching chapters 04-04 and 05-05.
10. Unique Reads figure is **not** invented. Per the ruling, the chapter says the reference run did not record one and the reader should compare their own two columns. Confirmed absent from author.md and from the run's `detected_virus.info.tsv`, which has no unique-read column.
11. "curated viral assemblies" glossed at first use.
12. SRA download size and time deliberately left out. Not measured anywhere.
13. Trailing-colon aside replaced with chapter 33's exact single explanation of the colon-plus-period convention.
14. 170,180 now attributed to the run's read-statistics file and to the detection table's own column.
15. "Small fraction" for Unique Reads given as a rule of thumb at roughly a tenth of Reads, explicitly framed as a rule of thumb rather than a threshold the app enforces.
16. Read packing glossed as stacking reads into rows so none overlap.
17. "On the command line" now opens with chapter 33's optional-section paragraph, including the gloss of headless.

## Other reader rows applied

Sequencing run, mapping wording tightened to one act, what the tool maps against, minimap2 never called directly, viewport glossed as the result window, indexed alignment glossed, window and consensus glossed where first met, database-size tradeoff stated as a deliberate design choice with Kraken 2's Standard named, QIAseq Direct product name dropped, SRA glossed, conda environment glossed as an isolated copy, Plugin Manager pack install now names the **Packs** tab, **Install All**, and what an installed pack looks like, version-drift note added to the Procedure lead, RAM warning split from the batch note and stated as non-blocking, batch list eight-sample cap added, already-trimmed guidance added for the fastp checkbox, stepper glossed, "scrutinise" replaced and pointed at What good looks like, Extra arguments points at the EsViritu project's own documentation and explains the unclosed-quote block plainly, filter count quoted as "N of M assemblies", sparkline placement given as left of the number, `x` glossed as times, breadth defined before depth, "a pile rather than a genome" replaced with the plain meaning, Coverage filter breadth defect stated in one sentence per the ruling, Identity defined as percent of bases matching, metric pills glossed as small rounded boxes, segmented-virus grid described as filled versus empty cells with the Segment column named as how you know in advance, every row carrying alignment data stated, BAM located inside the result folder, BLAST Verify states the reads leave the machine for NCBI over the internet, ellipsis called three dots and moved ahead of the Recompute button with guidance on when to press it, provenance tool-version defect disclosed where the reader meets the information button, 95% given as the single Identity cut point, lineage and variant glossed, `--format tsv` added.

## Not applied

- **Two example sparklines, good and bad, side by side** (one reader). This is an illustration request and `illustrations` is owned elsewhere. Routed to the Documentation Lead rather than added as prose.
- **Read length lookup in LGE** (one reader). No sourced answer for where an imported FASTQ's read length is displayed. Left alone rather than guessed.
- **What fraction of known viruses the 19,925 assemblies cover** (one reader). No source. Not invented.
- **SRA download size and time**, per the ruling.

## Facts I could not source

- The reference run's Unique Reads value. Absent from `author.md`, from the run TSV, and from the scratchpad output directory.
- Whether imported metadata columns persist across close and reopen. Left cut rather than hedged, since a hedge would still assert the behaviour exists.

## Status

brand_reviewed: false (the gate flips it)
