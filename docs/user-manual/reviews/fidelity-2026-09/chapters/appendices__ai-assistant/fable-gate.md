# Fable gate: appendices/ai-assistant

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (seven steps), Settings, Reading the results with the wet-lab subsection, What good looks like, On the command line, Next. |
| Every setting present | Pass. Eight AI Services controls plus Restore Defaults, each with label, effect, default, when to change, and the no-flag sentence. |
| Every string traceable | Pass. The disabled alert, the not-configured reply, the credits reply, the maximum-steps reply, the busy reply, the validating and valid captions, the Clear All API Keys dialog text, the placeholder shapes, the six suggested-question buttons, the three recommended models, the 150-second timeout and eight rounds, all from source with line numbers in the author's and reviewer's records. |
| Surfaces | Pass. The Inspector's Assistant tab, View > AI Assistant with Cmd-Shift-A, Settings > AI Services with Cmd-comma, the Data sent... popover, the Clear button, the table drawer located. |
| Fidelity false claims corrected | Pass. Six of six. The floating window is gone from every sentence. |
| Rulings | Pass. All ten, with the retitle, the genomics-mode-only sentence, the five indicator states, the drawer located, the provider-website wording with no URL or price, the short command-line section, and the reconciled lookup list. |
| Reader consensus | Pass. Twenty-six of twenty-six applied, 68 of 75 others. |
| Honesty | Pass. No answer text is quoted, and the chapter says why. |
| Nav | Pass. The AI Assistant entry sits after Running in CI in the Appendices block. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The demo-project sentence replaced with the manual's fixed form and its GitHub build instructions.
2. The command-line opener reduced to one sentence, since the feature has no command-line counterpart and the fixed paragraph promised a headless procedure.
3. The Next link uses the Foundations chapter's title.

## Rulings

A chapter whose subject has no command-line counterpart replaces the fixed opener with one sentence saying the section is short. The title is The AI Assistant. Phase 6 items: the ai-assistant glossary entry's semicolon, features.yaml's "AI assistant panel" title and its dead source citation, the appendices reality map's MainMenu.swift path.

## Findings for RESULTS.md

View > AI Assistant reveals the Inspector's Assistant tab, and the floating window controller is dead code constructed only in a test. The Assistant tab exists only in the genomics content mode, so read, assembly, mapping, classifier, and genotype viewports get an Inspector without it and without an explanation. The demo project's chr20 bundle records its organism as the slice name rather than Homo sapiens, so species-aware suggestions interpolate a slice name. An Azure endpoint-kind setting has no control.

## Phase 5 notes

Three shots. The Assistant tab shot needs the HG002 chromosome 20 slice selected with the toggle on, and the chr20 organism field should be corrected in the demo project's build script before capture or the suggestion buttons will show the slice name. The two settings shots need a key field left empty.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
