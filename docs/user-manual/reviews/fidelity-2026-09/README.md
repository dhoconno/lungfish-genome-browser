# Fidelity and accessibility campaign, 2026-09

Spec: `docs/superpowers/specs/2026-09-06-user-manual-fidelity-campaign-design.md`
Plan: `docs/superpowers/plans/2026-09-06-user-manual-fidelity-campaign.md`

Layout:

- `cli-help/` one file per `lungfish-cli` command, the `--help` text of the
  2026.9.13 binary, recursed one level. Written once by Task 2.1.
- `ground-truth/<part>.md` reality maps, one per manual part (Task 2.2).
- `DRIFT.md` the consolidated per-chapter correction list and the chapter
  roster (Task 2.5).
- `chapters/<chapter>/` per-chapter pipeline records: `fidelity.md`,
  `readers.md` (the synthesized reader-team report), `editor.md`,
  `fable-gate.md`.
- `RESULTS.md` the closing report.

## Overused-word baseline (before rewrite)

Measured 2026-09-06 with the Task 1.3 `ai-tells` lint rule, after excluding
`wedge`, `unlock`/`unlocking`, `realm`, and `comprehensive` from the word
list as unavoidable terms of art (see `# Step 8 baseline exclusions` in
`build/scripts/lint/rules/ai-tells-words.txt`):

```
$ LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/*/*.md 2>&1 \
   | grep -oE "overused word '[^']+'" | sort | uniq -c | sort -rn | head -40
     10 overused word 'navigate'
      7 overused word 'navigation'
      2 overused word 'uncovered'
      2 overused word 'stalled'
      2 overused word 'diverged'
      2 overused word 'Navigation'
      1 overused word 'tackles'
      1 overused word 'stalling'
      1 overused word 'navigating'
      1 overused word 'nail'
      1 overused word 'enhanced'
      1 overused word 'diverging'
      1 overused word 'diverge'
      1 overused word 'dive'
      1 overused word 'critical'
      1 overused word 'cadence'
      1 overused word 'Navigating'
      1 overused word 'Navigate'
```

`navigate`/`navigation`/`navigating` dominate and are largely legitimate UI
vocabulary (menu items, "navigate to the folder"); they were kept in the
word list rather than excluded because the Task 1.3 test fixture requires
`navigating` to fire, matching the brief's own `tap` precedent (an
inline-code exemption, not a list exclusion, is the intended fix for a
literal command name inside a sentence). The remaining hits are ordinary
prose words (`stalled`, `diverged`, `dive`, `critical`, `nail`, `cadence`,
`tackles`, `enhanced`, `uncovered`) that a chapter rewrite pass can
address case by case.

## Checker baseline (before rewrite)

Measured 2026-09-06 with the Task 1.6 campaign checkers
(`docs/user-manual/build/scripts/campaign/`):

```
$ node docs/user-manual/build/scripts/campaign/check-links.mjs docs/user-manual | tail -1
11 broken link(s)
$ node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual | tail -1
44 shot problem(s)
$ node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml
parameters ok
```

Broken links (11): 10 are anchor-only links into `appendices/*.md` files
(`tool-versions.md#appendix-tool-versions`, `bibliography.md#appendix-bibliography`,
`primer-schemes.md#appendix-primer-schemes`) plus one `GLOSSARY.md#amplicon`
anchor from `ARCHITECTURE.md`, and one non-relative asset link
(`index.md:12` to `pdf/lungfish-user-manual.pdf`) that the checker correctly
flags because the PDF export does not exist yet. These are pre-existing gaps
for the rewrite phase to close, not checker bugs.

Shot problems (44 = 22 missing png + 22 missing recipe): every `<!-- SHOT -->`
marker in `01-foundations`, `02-sequences`, and `05-variants` chapters
currently has neither a screenshot nor a recipe on disk — screenshot capture
is later campaign work (see `screenshot-scout`). Additionally 5 orphan
recipes are reported as warnings under the old chapter-numbered asset
directory `assets/recipes/04-variants/` (`primer-trim-dialog.yaml`,
`variant-call-dialog.yaml`, `variant-table-fresh-call.yaml`,
`vcf-open-dialog.yaml`, `vcf-variant-table.yaml`) — these predate the
chapter renumbering to `05-variants` and are cleaned up in a later phase;
no orphan PNGs were found.

`validate-parameters.mjs` passes cleanly because `parameters.yaml` is still
the Task 1.5 skeleton (`operations: {}`); the registry has no entries yet
for the checker to validate, so `parameters ok` here is a baseline of zero
content rather than zero problems.
