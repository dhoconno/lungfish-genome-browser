# STYLE — Lungfish User Manual

Derived from `lungfish_brand_style_guide.md` (memory). The linter in
`build/scripts/lint/` enforces every mechanical rule here.

## Written identity

- The product is **Lungfish** — title case, one word.
- Never: LUNGFISH, LungFish, Lung Fish, lungfish.
- Kit names: **Lungfish Air Kit**, **Lungfish Wastewater Kit**.
- Device: **InBio Apollo Sampler**. Consumable: **Cassette** (capitalised
  site-facing, lowercase in prose).
- Lint: `written-identity.js`.

## Palette

Five colors, nothing else, in prose hex references and embedded SVG fills:

| Name | Hex | Use |
|---|---|---|
| Lungfish Creamsicle | `#EE8B4F` | Primary accent, headings, CTAs |
| Peach | `#F6B088` | Secondary warm tint |
| Deep Ink | `#1F1A17` | Primary text — never pure black |
| Cream | `#FAF4EA` | Page backgrounds — never pure white |
| Warm Grey | `#8A847A` | Captions, metadata |

- Never red-amber-green in data viz; encode severity with Deep Ink weight
  + annotation.
- Never Creamsicle on Peach, never Creamsicle body text.
- Lint: `palette.js`, `data-viz.js`.

## Typography

| Role | Face | Sizes |
|---|---|---|
| Display / H1 | Space Grotesk Bold | 32–40pt |
| Section / H2 | Space Grotesk Medium | 24–28pt |
| Subsection / H3 | Space Grotesk Medium | 18–22pt |
| Body | Inter Regular | 11–14pt |
| Caption / Label | Inter SemiBold | 9–11pt |
| Data / Code | IBM Plex Mono | 10–12pt |

Prose never names a font. Inline HTML `style=` attributes and `<style>` blocks
must use only these faces. Lint: `typography.js`.

## Voice

Six qualities: **Purposeful · Precise and scientific · Trustworthy and calm ·
Actionable · Thoughtful · Inclusive and empowering.** Never hyped, never cold.

Banned patterns (lint flags):

- `revolutionary`, `breakthrough`, `powerful`, `cutting-edge`, `AI-powered`,
  `game-changing`, `unleash`, `leverages`, `next-generation` (the last is
  permitted *only* when literally referring to NGS, inside a primer)
- `!` at sentence end in body prose (permitted in quoted CLI output)
- Superlative chains (`most advanced, most accurate, most…`).

Lint: `voice.js`.

## Chapter structure

Every chapter:

1. Opens with `## What it is` or `## Why this matters` before any `## Procedure`
   section.
2. Has YAML frontmatter validated by `frontmatter.js`.
3. Has one `<!-- SHOT: id -->` marker per entry in `shots[]` and vice versa.
4. Resolves every `prereqs[]`, `glossary_refs[]`, `fixtures_refs[]`,
   `features_refs[]` to an existing target.

Lint: `frontmatter.js`, `primer-before-procedure.js`.

## Fixture references

When a chapter uses a fixture, it cites the fixture's `README.md` citation
block via `{{ fixtures_refs[] | cite }}`. Chapters do not reproduce licenses or
accessions inline.

## Audience tiers

Every chapter declares one: `bench-scientist | analyst | power-user`. No
chapter may mention a concept the audience tier has not been primed for.

## Screenshots

- Cream backgrounds (light appearance) unless the chapter is specifically about
  dark-mode features.
- Dark-mode screenshots sit on a Deep Ink containment panel.
- Annotation callouts and brackets: Creamsicle, 2px stroke.
- SVG overlays composited post-capture, not drawn in the app.

## Frontmatter schema

```yaml
title: <human title>
chapter_id: <path-style id matching file location>
audience: bench-scientist | analyst | power-user
prereqs: [<chapter_id>, ...]
estimated_reading_min: <int>
shots:
  - id: <kebab-case>
    caption: "<sentence>"
glossary_refs: [<term>, ...]
features_refs: [<features.yaml id>, ...]
fixtures_refs: [<fixture dir name>, ...]
brand_reviewed: false
lead_approved: false
```
