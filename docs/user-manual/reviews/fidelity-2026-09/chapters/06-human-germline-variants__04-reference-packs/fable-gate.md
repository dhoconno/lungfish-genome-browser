# Fable gate: 06-human-germline-variants/04-reference-packs

Gate run by the project manager (Fable) on 2026-09-07 against the full
text after an interrupted editor pass and its completion, and the diff of
the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass for a reference chapter. What it is, Why you would do this, Before you start (three subsections), four file sections, What good looks like, On the command line, Next, with the dropped Procedure and Settings sections explained in the author's report and no registry ids to cover. |
| Every number traceable | Pass. 500,001 bases, the 34 byte .fai with its five fields, the 251 byte .dict with its M5, the 64,444,167 length in the failing header, 961 records with 809 SNVs and 152 indels, the 38,323 and 392 byte outputs, the 27 byte BED, the 1,191,386 byte table and 16,929,652 byte BAM, 887.6 and 369.9 MB against 600 and 180, the 865 MB export, 873 with 805 known and the two Ti/Tv figures, all reproduced from scratch by the fidelity review. |
| Commands runnable | Pass. Every block names its inputs and outputs, uses the full tool paths or the three shell variables, and lists its result, with the @RG check and the doubled --known-sites shown. The offline install pair was corrected to the positional form during the completion pass. |
| Fidelity false claims corrected | Pass. The .fai claim narrowed, bcftools introduced, the sibling build-pin claim dropped. Two unverifiable claims cut or softened. |
| Defects disclosed | Pass. conda install --pack refusing both packs at exit 3, the understated size estimates, the stale pack description, the missing .dict on both routes, each where the reader meets it. |
| Reader consensus | Pass. Forty-two of forty-two addressed, verified row by row by the completion pass. |
| Human example | Pass. HG002 chromosome 20. |
| Glossary alphabetised | Pass. Four new entries. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The unmeasured whole-genome duration and output size became a proportional statement.
2. The Ti/Tv guidance now reconciles the genome-wide and coding-region figures with the sibling chapter's range.
3. The 873 count is attributed to Picard's typing, since the manual's own count of the same file is 874.
4. Reading time raised to 30 minutes.
5. Hotfix to chapter 42, which claimed the pack puts `gatk` on the PATH and showed a bare `gatk` command. It now uses the full path and says the pack does not add the program to the shell's search path, matching this chapter.

## Rulings

DRIFT row 97's build-string pin stays unaddressed manual-wide and goes to Phase 6. The `gatk` glossary anchor does not exist, so the term stays out of glossary_refs. The fixture's benchmark VCF header keeping the full chromosome length is a fixture issue for Phase 6, and the chapter turns it into its worked failure.

## Findings for RESULTS.md

LGE never creates the .fai or .dict for a loose FASTA handed to gatk. `conda install --pack` rejects both experimental packs with exit 3 while `conda export-pack` accepts them. Plugin Manager size estimates understate installed environments by about half. GATK Core's description still says dry-run support.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
