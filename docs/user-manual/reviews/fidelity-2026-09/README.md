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
