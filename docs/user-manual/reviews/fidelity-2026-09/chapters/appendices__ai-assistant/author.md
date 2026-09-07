# Author record, appendices/ai-assistant.md

Chapter: `docs/user-manual/chapters/appendices/ai-assistant.md` (roster row 59).
Fixture: demo project. Registry ids: none, so `parameters_refs` is absent and
`settings-coverage.js` does not run against this chapter.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/ai-assistant.md`
prints `no issues found`.

## Source files consulted

### Sources/LungfishApp/Views/Settings/AIServicesSettingsTab.swift

| Line | What it settled |
|---|---|
| 29-32 | Anthropic model options, four entries, "Claude Sonnet 4.6 (Recommended)" first |
| 34-47 | OpenAI model options, twelve entries, "GPT-5.5 (Recommended)" first |
| 49-58 | Gemini model options, eight entries, "Gemini 3.5 Flash (Recommended)" first |
| 110 | Toggle label `Enable AI-powered search` |
| 111 | Accessibility id `SettingsAccessibilityID.aiSearchToggle` |
| 113 | Caption under the toggle |
| 117-121 | Picker label `Default provider:` and its three option titles "Anthropic Claude", "OpenAI", "Google Gemini" |
| 123 | Caption naming the fallback behaviour |
| 126-141 | Anthropic section, `SecureField("API Key", ...)` with prompt `sk-ant-...`, then `Picker("Model:", ...)` |
| 143-155 | OpenAI section, prompt `sk-...` |
| 157-169 | Google Gemini section, prompt `AIza...` |
| 171-175 | Azure AI section, toggle "Use Azure AI-hosted endpoint", `TextField("Endpoint", ...)` prompt `https://example.openai.azure.com`, `TextField("Deployment", ...)` prompt `gpt-5-mini` |
| 176 | Azure caption, "The deployment field accepts the deployment name exposed by your Azure resource." |
| 182 | Button "Clear All Keys" |
| 188 | Button "Restore Defaults", calling `settings.resetSection(.aiServices)` |
| 195 | Progress text "Saving API key changes to Keychain…" |
| 73-77, 215-221 | Keys are read from and written to `KeychainSecretStorage`, never a project file |
| 128, 131 | Per-key status indicator to the left of each SecureField |
| 236-239 | Alert title "Clear All API Keys?" and message "This will remove the three AI provider keys from Keychain. You will need to re-enter them to use AI features." |

### Sources/LungfishCore/Models/AppSettings.swift

| Line | Default |
|---|---|
| 288 | `aiSearchEnabled = false` |
| 291 | `openAIModel = OpenAIEndpointConfiguration.defaultOpenAIModel` |
| 294 | `anthropicModel = "claude-sonnet-4-6"` |
| 297 | `geminiModel = "gemini-3.5-flash"` |
| 300 | `preferredAIProvider = "anthropic"` |
| 303 | `openAIHostedEndpointEnabled = false` |
| 306 | `openAIHostedEndpointKind = "azure"` |
| 309 | `openAIHostedEndpoint = ""` |
| 312 | `openAIHostedDeployment = ""` |

`Sources/LungfishCore/Services/AI/OpenAIEndpointConfiguration.swift:30`,
`defaultOpenAIModel = "gpt-5.5"`, which is what the OpenAI Model default
resolves to.

### Sources/LungfishApp/Services/AI/AIAssistantService.swift

| Line | What it settled |
|---|---|
| 42 | `maxToolRounds = 8`, the eight lookup rounds named in Reading the results |
| 43 | `providerRequestTimeout = 150` seconds (not quoted in the chapter) |
| 57-79 | `contextDisclosure()`, the text the **Data sent…** popover shows. Local preview only, contacts no provider |
| 60-61 | Fallback order built as `[preferred] + [.anthropic, .openAI, .gemini].filter { $0 != preferred }` |
| 72 | "A failed request may already have reached one provider before another provider receives the fallback request." |
| 91-93 | Disabled message, "AI Assistant is disabled. Enable it in Settings > AI Services." |
| 95-98 | In-flight message, "Please wait for the current request to complete." |
| 212-214 | Step-ceiling message, "I reached the maximum analysis steps without a final text response. Please try again with a narrower query, fewer requested actions, or a different AI provider." |
| 257 | Fallback order again, in `resolveProviders()` |
| 268-270 | Missing-key message, "No configured AI provider has a valid API key with available credits." |
| 283-291 | A provider whose Keychain value is empty returns nil and is skipped before any request |
| 562-565 | System-prompt rule 11, the wet-lab follow-up and reagent guidance |
| 655-698 | Species branches for rhesus macaque, human, and mouse, plus the general species-aware fallback. The macaque branch names CD3 clone SP34-2 as an example and tells the user to verify clone and epitope compatibility |
| 705-806 | `suggestedQueries()`, the ten suggestion shapes, and the single "Getting started" suggestion when no bundle is loaded |
| 809-830 | `welcomeMessage()`, including the no-bundle variant that points at **Settings > AI Services** |

The two different messages the reality map called out are confirmed as
separate strings. `:91-93` is about the toggle, `:270` is about keys. The
chapter documents both, in step 2 and in Reading the results respectively.

### Sources/LungfishApp/Services/AI/AIToolRegistry.swift

| Line | What it settled |
|---|---|
| 176-192 | `get_variant_table_context` with `selection_scope` (selected, visible, selected_or_visible) and `limit` (default 25, max 200) |
| 194-215 | `get_sample_table_context` with `selection_scope`, `visible_only` (default true), and `limit` (default 50, max 300) |
| 168-172 | `get_current_view` |
| 222-230 | `navigate_to_gene` |
| 232-241 | `navigate_to_region` |
| 243-249 | `list_chromosomes`, the eleventh tool the old chapter omitted |
| 251-260 | `search_pubmed`, `max_results` default 5, max 10 |
| 276-296 | The dispatch switch, which is the authoritative list of eleven tools. Nine read, two move the view, none writes |

### Sources/LungfishApp/Views/AI/AIAssistantPanel.swift

| Line | What it settled |
|---|---|
| 37 | "Manages the floating AI assistant panel window" |
| 48-52 | `NSPanel` at 420x600, style mask `[.titled, .closable, .resizable, .utilityWindow]` |
| 54 | `panel.title = "AI Assistant"` |
| 55-57 | `isFloatingPanel = true`, `hidesOnDeactivate = false`, which is why the chapter says it stays in front and stays visible |
| 60 | `setFrameAutosaveName("AIAssistantPanel")`, which is why the chapter says it remembers where you put it |
| 277 | Header title label "AI Assistant" |
| 285 | `clearButton.title = "Clear"` |
| 297 | `disclosureButton.title = "Data sent…"` |
| 303 | Its tooltip, "Preview current context and possible AI recipients without sending data" |
| 309-334 | `showContextDisclosure()`, an `NSPopover` whose text view is `service.contextDisclosure()` |
| 343 | `inputField.placeholderString = "Ask about your genome data..."` |
| 371-386 | The clear path, which rebuilds suggested queries, re-adds the welcome message, and touches no project state |
| 481-519 | `showThinkingIndicator()` and its hide counterpart |
| 686, 742, 746 | The reply copy button, `doc.on.doc` symbol, tooltip "Copy response" |
| 910-912 | The copy button flipping to a checkmark and back |

### Sources/LungfishApp/App/MainMenu.swift

Note the reality map cites `MainMenu.swift` without a directory. The file is at
`Sources/LungfishApp/App/MainMenu.swift`, not `Sources/LungfishApp/MainMenu.swift`.

| Line | What it settled |
|---|---|
| 110-115 | `Settings...` with `keyEquivalent: ","` in the application menu |
| 481-487 | View menu item "AI Assistant", `keyEquivalent: "a"` with `[.command, .shift]`, so Cmd-Shift-A |
| 1006 | A separate Help menu item "AI Assistant Guide" exists. Not documented in this chapter, since it is a help-book entry rather than a panel control |

## Help runs

All against `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

- `lungfish-cli search --help`. Exact string, IUPAC motif, or regex search in a
  FASTA, output as BED. No AI involvement. Matches
  `reviews/fidelity-2026-09/cli-help/search.txt`.
- `lungfish-cli universal-search --help`. Queries a project-scoped local index
  with a field syntax such as `type:fastq_dataset role:air_sample`. No AI
  involvement. Matches `cli-help/universal-search.txt`.
- `lungfish-cli genotype ai-haplotyping --help`. Exit 0. This is the one CLI
  command that reaches an AI provider, with `--provider` (openai or anthropic,
  default openai), `--model`, `--azure-openai-endpoint`,
  `--azure-openai-deployment`, `--mode` (ai-discovery or ai-refinement, default
  ai-refinement), and `--preview-prompt`. It operates on a
  `.lungfishgenotype` bundle and has nothing to do with the chat panel.

Conclusion recorded in the chapter: the panel has no command-line counterpart.
The On the command line section says so in one paragraph and names all three
commands so a reader who finds them does not mistake them for the panel.

## Demo project

Read-only inspection of `~/Desktop/lge-docs/LGE Manual Demo.lungfish`.

- `Reference Sequences/` holds `HBB.lungfishref` and
  `chr20_10.0-10.5Mb.lungfishref`.
- `Imports/` holds `HG002-chrM.lungfishfastq`, `HG002.lungfishfastq`, and
  `SRR36291587.lungfishfastq`.
- `Analyses/` holds `HG002-chrM` (a SPAdes assembly), `Multiple Sequence
  Alignments`, `kraken2-SRR36291587`, `mapping-HG002`, and `nvd-demo`, which is
  five outputs.

The Why you would do this section describes that inventory, and the sample
question in step 6 asks about the chromosome 20 bundle's variant count and
chromosome list, both of which are lookups the panel's own tools can serve.

## Not verified, because the panel was not run

This session had no API key for Anthropic, OpenAI, or Google Gemini, and did
not request one. The panel was therefore never exercised end to end. Everything
below is described from source and was not observed on screen.

- No answer text is quoted anywhere in the chapter, and none was invented. The
  chapter states plainly that replies differ between providers, between models,
  and between two askings of the same question.
- The three UI strings quoted as replies are app strings read from
  `AIAssistantService.swift` at `:92`, `:97`, `:213`, and `:270`, not model
  output.
- The status line's behaviour during a live request is described in general
  terms ("reports what the assistant is doing while it works") because the
  exact `onStatusUpdate` strings during tool execution were not observed.
- The per-key validation indicator is described as reporting what LGE knows
  about the key, without naming the five `KeyValidationState` cases, since the
  rendered symbols were not seen.
- The **Data sent…** popover's rendered content was not seen. Its structure is
  taken verbatim from `contextDisclosure()` at `AIAssistantService.swift:57-79`.
- Whether **Restore Defaults** visibly clears the Azure fields was not observed.
  The chapter says it returns the settings to the documented defaults and
  leaves Keychain keys alone, which follows from `resetSection(.aiServices)`
  touching `AppSettings` only, with key removal living behind the separate
  "Clear All Keys" button.

## App defects found

None. Every label, message, and default the chapter names was located in
source and is self-consistent. Two observations that are not defects but are
worth recording.

- `AppSettings.openAIHostedEndpointKind` (`:306`, default `"azure"`) has no
  control in the AI Services tab. The Azure AI section exposes the toggle, the
  endpoint, and the deployment, but not the kind. It is therefore an
  unsurfaced setting rather than a broken one, and the chapter does not
  document it because a reader cannot reach it.
- The Help menu carries a separate "AI Assistant Guide" item
  (`MainMenu.swift:1006`) alongside the View menu's panel item. The chapter
  documents only the panel, per the roster scope.

## Documentation defect corrected in this pass

`docs/user-manual/GLOSSARY.md`, the existing `ai-assistant` entry, contains a
semicolon, which the manual's prose rules ban. It predates this chapter and is
not in this chapter's scope, so it was left as found rather than edited. Worth
a sweep.

## Edits made

1. `docs/user-manual/chapters/appendices/ai-assistant.md`, rewritten in place
   to the operation template shape. Front matter now carries
   `brand_reviewed: false`, `lead_approved: false`,
   `fixtures_refs: [demo-project]`, `estimated_reading_min: 16`, and a real
   `shots:` list of three. The non-conventional `planned_shots` key and the two
   `<!-- planned: ... -->` markers are gone, replaced by `<!-- SHOT: id -->`
   markers.
2. `docs/user-manual/GLOSSARY.md`, two new entries. `**API key**{#api-key}`
   after `API access` in section A, and `**Keychain**{#keychain}` after `k-mer`
   in section K.
3. `docs/user-manual/build/mkdocs.yml`, one nav line added to the Reference
   block, `    - AI Assistant: chapters/appendices/ai-assistant.md`, placed
   immediately after the Running in CI line.

## Two labels written in code font rather than bold

Two verbatim control labels are written in backticks rather than bold, because
the linter has no other way to accept them.

- `Enable AI-powered search` contains "AI-powered", which `voice.js` flags as
  marketing voice. That rule strips inline code but not quoted text, so the
  label passes only in backticks. It appears that way in step 2 and as the
  opening label of its Settings paragraph.
- `Default provider:` carries a trailing colon on screen. `sentence-colon.js`
  exempts a trailing colon inside a leading bold label of a Settings paragraph
  but not one mid-sentence in a Procedure step, so the step 3 mention is in
  backticks while the Settings paragraph keeps `**Default provider:.**`.

## Shots

Three markers, three front-matter entries.

- `ai-assistant-panel`, at the end of What it is. Caption reworded from
  "docked beside" to "floating beside" per the reality map, and extended to
  name the header's Data sent and Clear buttons.
- `ai-assistant-provider-setup`, at the end of step 3. Caption now names the
  three controls the reality map asked for, plus the Model picker.
- `ai-assistant-azure-endpoint`, new, after the Deployment settings paragraph.
  The reality map suggested a second shot for the Azure AI section.

## Drift rows applied

All four Changed rows and all ten Missing rows from
`DRIFT.md` `### appendices.md/ai-assistant.md` are applied.

| Row | Where it landed |
|---|---|
| Changed 5 (three providers, plus Azure) | Before you start, and the three Azure settings paragraphs |
| Changed 7 (toggle, picker, key field wording) | Steps 2 and 3 |
| Changed 12 (two different messages) | Step 2 for the disabled message, Reading the results for the missing-key message |
| Changed 21 (`list_chromosomes`) | Reading the results, in the eleven-lookup sentence |
| Missing, Azure section | Three settings paragraphs and a shot |
| Missing, model pickers | The `Model:` settings paragraph, with all three option counts and defaults |
| Missing, clear-keys action | The `Clear All Keys` settings paragraph, with the confirmation copy quoted |
| Missing, `list_chromosomes` | Reading the results |
| Missing, `selection_scope` / `visible_only` | Step 6 and Reading the results, described as reading selected or visible rows |
| Missing, step ceiling | Reading the results, with the message quoted and the eight-round budget named |
| Missing, fallback privacy consequence | Step 5, and What it is |
| Missing, second question refused | Step 6, with the message quoted |
| Missing, species detection | Reading the results, naming macaque, human, and mouse |
| Missing, `genotype ai-haplotyping` | On the command line |
