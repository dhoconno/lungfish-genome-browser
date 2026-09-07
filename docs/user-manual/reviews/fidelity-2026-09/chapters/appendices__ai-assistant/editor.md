# Editor pass, appendices/ai-assistant.md

Chapter: `docs/user-manual/chapters/appendices/ai-assistant.md` (roster row 59).
Date: 2026-09-07. Inputs read in order: `author.md`, `fidelity.md` (64 claims,
6 false), `readers.md` (101 merged rows, 26 in Consensus), and
`reviews/fidelity-2026-09/CONSISTENCY.md`.

## False claims fixed

All six, using the reviewer's drafted wordings.

| # | Was | Now |
|---|---|---|
| 7 | Third sample question asked which variants fall inside a named gene, which the fixture cannot answer | Replaced with the reviewer's suggestion, how the variants break down by type. The three questions are now three separate question sentences, which also clears reader row 53 |
| 10 | No-key case described as "no provider has a usable key" | Before you start now says the message reports the API key is not configured and points at **Settings > AI Services** |
| 11 | "the panel still opens and still shows its suggested questions" with no account | Now says the tab opens once the toggle is on, shows its suggestions, and returns the key-not-configured message |
| 15 | Toggle-off behaviour described as a reply in the panel | Step 2 now says there is no assistant to type into, the Assistant tab does not appear, and **View > AI Assistant** raises the "AI Assistant Disabled" alert. Alert body carried in code font because `voice.js` flags "AI-powered" inside quotes but strips inline code |
| 23 | Floating "AI Assistant" window, `NSPanel`, remembers its position | Step 4 rewritten to the Inspector's **Assistant** tab, per the reviewer's wording. Every later "the panel" in the body is now "the assistant" or "the tab". Title, `task:`, and What it is all follow |
| 64 | Shot caption said "floating beside a dataset viewport" | Replaced with the reviewer's caption, the Assistant tab of the Inspector |

Structural consequence of claim 23 applied throughout, not only at step 4. The
dead `AIAssistantWindowController` is not mentioned, since a reader cannot reach it.

Fixture naming settled to CONSISTENCY.md's sheet name. "The HG002 chromosome 20
slice" at first mention, then the same phrase or "the slice", replacing the old
"a human chromosome 20 slice" and four bare "chromosome 20 bundle" mentions.

## Project manager rulings

| Ruling | Where applied |
|---|---|
| (a) Retitle to "The AI Assistant" | Front matter `title`, and `task:` rewritten to "Open the Inspector's Assistant tab, connect a bring-your-own-key provider, and ask questions about the dataset that is open" |
| (b) Genomics-mode-only tab stated once | Before you start, third paragraph. Names FASTQ, assembly, mapping, classifier (the demo project's Kraken 2 run), and genotype as the viewports that show an Inspector without the tab, and names the HG002 chromosome 20 slice under `Reference Sequences/` as a bundle that does show it. This is the reviewer's app defect 2 |
| (c) Key-status indicator states from source | Step 3, fourth paragraph. All five `KeyValidationState` cases from `AIServicesSettingsTab.swift:255-274` and their captions from `:277-298`. Grey minus, orange hourglass (entered or checking), green filled checkmark ("Key is valid and ready for AI queries."), red filled cross. Validation glossed in the same paragraph and tied back from the Default provider Settings entry |
| (d) Table drawer located | Two clauses. What it is glosses it at first use as the panel that slides up from the bottom edge of a reference bundle viewport. Reading the results adds that it opens by itself when the bundle holds an annotation or variant track (`GLOSSARY.md` table-drawer), so the What good looks like check is performable. Reader rows 24 and 100 clear |
| (e) Account creation, no URL, no price | Before you start. Says the account is created on the provider's own website, which is also where the provider issues the key, that signing up asks for payment details, and that each provider charges per question at its own rates, which the manual does not quote. No URL and no figure anywhere |
| (f) Command-line section short | Keeps CONSISTENCY.md's fixed opener verbatim with "the dialog" swapped for "the Assistant tab", then one paragraph saying the assistant has no command-line counterpart and no headless procedure. The three commands are named so a reader who finds them does not mistake them for the assistant |
| (g) Terms glossed at first use | bundle, viewport, viewer (folded into viewport, one word used throughout per reader row 35), track, grounded, sidebar, fallback, Inspector, Operations panel, table drawer, provenance, API key, Keychain, large language model, placeholder text, validation, contig, PubMed, BED, antibody clone, assembly, classification, headless, `.lungfishgenotype`. Two new `GLOSSARY.md` entries, alphabetical, house shape with See also lines. The existing `ai-assistant` entry's semicolon left as found, per the ruling |
| (h) Eleven-lookup count | The bare number is gone. Reading the results now gives the lookups as a five-bullet list (within the 5/2 cap) with the two view-moving ones marked, so nothing needs reconciling against a count |
| (i) No fabricated answers | No model output anywhere. Every quoted string traces to source. Sample questions only, and the chapter still says replies differ between providers, models, and runs |
| (j) Three SHOT markers | All three kept and matched to `shots` entries. `ai-assistant-panel` recaptioned to the Inspector tab per claim 64. `ai-assistant-provider-setup` extended to name the key-status indicator, since ruling (c) makes it load-bearing. `ai-assistant-azure-endpoint` unchanged |

## Glossary changes

Two entries added to `docs/user-manual/GLOSSARY.md`, both in alphabetical position.

- `**Grounded answer**{#grounded-answer}` in section G, between GFF and GTF.
- `**Provider fallback**{#provider-fallback}` in section P, after Provenance sidecar.

`glossary_refs` grown from four ids to twelve: `ai-assistant, api-key, keychain,
provenance, bundle, viewport, sidebar, table-drawer, operations-panel,
grounded-answer, provider-fallback, contig`. All twelve anchors verified present.
No existing entry was edited.

## Reader rows

Consensus rows: 26 of 26 applied.

Other merged rows: 75 outside Consensus. 68 applied, 7 skipped.

| Row | Skip reason |
|---|---|
| 42, 59, 72, 75, 80, 84, 95, 105 | No change requested. These readers reported the passage as clear. Counted as applied-by-no-change rather than as skips, so they are not in the 7 below |
| 12, 57 | Ruling (e) forbids a pricing figure. Replaced with the provider-charges-at-its-own-rates sentence instead of the requested order-of-magnitude cost |
| 56 | Asked how to reopen the Welcome window. No such menu item exists in `MainMenu.swift`, and no other chapter claims one. Inventing a path would be a new false claim, so the sentence was cut rather than guessed |
| 87 | Asked for a time difference between model choices. No source gives one, and the panel was never run, so any figure would be invented. Replaced with the recommended-entry-is-right guidance from row 25 |
| 96 | Partly applied. The status strings are now quoted from `AIAssistantService.swift:862-877`, but the reader also wanted a live example, which was not observed |
| 99 | Applied as a `### Wet-lab follow-ups` heading. The reader also asked how to turn the behaviour off. Source offers no control, so the chapter says plainly that it cannot be turned off |
| 107 | Applied in Next, one line for readers with no provider account. The reader wanted an alternative feature to use instead, and there is none, so the line says the rest of the manual works without this appendix |

Notable applications. Row 21 moved the `genotype ai-haplotyping` flag note out of
the Azure Settings entry into the command-line section. Row 23 replaced the
abstract fallback rule with a worked example ("choose OpenAI and the order is
OpenAI, then Anthropic, then Google Gemini"). Row 26 is satisfied because ruling
(f) already makes the section say plainly there is no counterpart. Rows 31 and 76
replaced the run-on suggestion list with the six real button labels from
`AIAssistantService.swift:733-806` and glossed PubMed. Rows 15 and 97 became the
lookup list with the two view-movers marked. Row 40 cut the template-artefact
sentence "It is not a stored value and so has no default." Row 86 settled setting
names on one format, bold label with the period inside, except the two labels the
linter only accepts in code font.

Idiom and ESL rows 44, 45, 48, 49, 60, 67, 68, 81, 83 all applied. "Ships",
"behind the scenes", "against the viewport", "earns its keep", "bearing", the
double "hand", "two askings", and "stale" are gone. Row 47 deleted the rhetorical
question "So what should you do with this?".

## Brand and style

No em dashes, no semicolons, no colons inside a sentence, verified by grep as
zero of each. No word from `ai-tells-words.txt`, which the linter checks. Sentences
kept near 20 words, and the long sentences readers flagged at rows 34, 46, 74, 79,
and 91 were split. Template section order unchanged. `brand_reviewed: false` and
`lead_approved: false` both left as found.

Two labels stay in code font, as the author documented. `Enable AI-powered search`
and `Default provider:` in its step 3 mention. The "AI Assistant Disabled" alert
body joined them, because `voice.js` flags "AI-powered" inside quotation marks but
strips inline code, and the string must be quoted verbatim.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/ai-assistant.md`

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/ai-assistant.md: no issues found
```

## Routed onward

Not fixed here, for the roles that own them.

- `features.yaml:1156` titles the feature "AI assistant panel" and lists
  `AIAssistantPanel.swift`. Both carry the framing claim 23 disproved. Code
  cartographer.
- The `ai-assistant` glossary entry's semicolon at `GLOSSARY.md:13`. Phase 6 sweep.
- App defect 6, the chr20 bundle's `source.organism` reading "chr20 10.0-10.5Mb"
  rather than "Homo sapiens", so the human branch never fires and the suggestion
  strings interpolate a slice name where they mean an organism. It should be fixed
  before `ai-assistant-panel` is captured, or the shot will show the wrong text.
