# Fidelity review, appendices/ai-assistant.md

Chapter: `docs/user-manual/chapters/appendices/ai-assistant.md` (roster row 59).
Fixture: demo project at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` (read only).
Registry ids: none, so `parameters_refs` is absent and settings coverage does not run.
Panel not exercised live (no API key). Every verdict below rests on source, on the
CLI help tree, or on read-only inspection of the demo project.

Arbiters read: `Sources/LungfishApp/Views/Settings/AIServicesSettingsTab.swift`,
`Sources/LungfishCore/Models/AppSettings.swift`,
`Sources/LungfishApp/Services/AI/AIAssistantService.swift`,
`Sources/LungfishApp/Services/AI/AIToolRegistry.swift`,
`Sources/LungfishApp/Views/AI/AIAssistantPanel.swift`,
`Sources/LungfishApp/App/MainMenu.swift`,
`Sources/LungfishApp/App/AppDelegate+MenuActions.swift`,
`Sources/LungfishApp/Views/Inspector/InspectorView.swift`,
`Sources/LungfishApp/Views/Inspector/InspectorViewModel.swift`,
`Sources/LungfishCore/Services/AI/AIProvider.swift`,
`Sources/LungfishCore/Services/AI/OpenAIEndpointConfiguration.swift`.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "The AI Assistant is a chat panel inside Lungfish Genome Explorer (LGE) that answers questions about the dataset you have open." | true | `AIAssistantPanel.swift:126` `AIAssistantViewController`, whose header, message stack, and input bar are built at `:183-238`. The controller is what both surfaces embed | |
| 2 | "the panel gathers the state of the active viewer, meaning the loaded bundle, the organism, the region on screen, and the rows you have selected in the variant or sample tables" | true | `AIToolRegistry.swift:39-58` `ViewerState` carries `bundleName`, `organism`, `chromosome`, `start`, `end`. `:166` `get_current_view`, `:174` `get_variant_table_context`, `:194` `get_sample_table_context` | |
| 3 | "LGE ships no model of its own and runs none for you." | true | `Sources/LungfishCore/Services/AI/` holds only `AnthropicProvider.swift`, `OpenAIProvider.swift`, `GeminiProvider.swift`, all remote HTTP clients. No local-inference path exists | |
| 4 | "LGE records nothing an assistant says into your project's provenance" | true | No provenance write appears in `AIToolRegistry.swift:265-300` (the dispatch switch) or in the request path of `AIAssistantService.swift:88-232` | |
| 5 | "a human chromosome 20 slice and an HBB gene record under `Reference Sequences/`, three read bundles under `Imports/`, and five analysis outputs under `Analyses/`" | true | Demo project listing. `Reference Sequences/` holds `HBB.lungfishref` and `chr20_10.0-10.5Mb.lungfishref`. `Imports/` holds `HG002-chrM.lungfishfastq`, `HG002.lungfishfastq`, `SRR36291587.lungfishfastq`. `Analyses/` holds `HG002-chrM`, `Multiple Sequence Alignments`, `kraken2-SRR36291587`, `mapping-HG002`, `nvd-demo` | |
| 6 | "including a SPAdes assembly of HG002 mitochondrial reads and a Kraken 2 classification" | true | `Analyses/HG002-chrM/` contains `run_spades.sh`, `spades.log`, `contigs.fasta`, and K-mer directories K21 through K127. `Analyses/kraken2-SRR36291587/` is the Kraken 2 run | |
| 7 | "Which chromosomes does the chromosome 20 bundle actually contain, how many variants sit in its variant track, and which of those variants fall inside a named gene." | false | The first two are answerable. The third is not, on this fixture. `chr20_10.0-10.5Mb.lungfishref/manifest.json` has `"annotations": []` and its `annotations/` directory is empty, so no gene exists to fall inside. The bundle that does carry annotations, `HBB.lungfishref`, has an empty `variants/` directory, so no bundle in the demo project has both | Drop the third question, or replace it with one the fixture can answer. Suggested: "Which chromosomes does the chromosome 20 bundle actually contain, how many variants sit in its variant track, and how do those variants break down by type." |
| 8 | "You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder." | true | The fixed Before you start sentence pair in `CONSISTENCY.md:138-146`, reproduced verbatim | |
| 9 | "LGE supports Anthropic, OpenAI, and Google Gemini." | true | `AIServicesSettingsTab.swift:119-121` tags `"anthropic"`, `"openai"`, `"gemini"`. `AIAssistantService.swift:257` builds the fallback order over the same three | |
| 10 | "every question you send comes back with a message saying no provider has a usable key" | false | Two different errors exist and the chapter names the wrong one for this case. With no key anywhere, `AIAssistantService.swift:266` throws `AIProviderError.missingAPIKey`, which renders as "API key is not configured. Please add your API key in Settings > AI Services." (`AIProvider.swift:518-519`). The "No configured AI provider has a valid API key with available credits." string at `:270` fires only when a key is present but fails validation | "every question you send comes back with a message saying the API key is not configured and pointing you at Settings > AI Services" |
| 11 | "the panel still opens and still shows its suggested questions" (with no account) | false | With `aiSearchEnabled` off, which is the install default, the Assistant tab is not built at all (`InspectorViewModel.swift:44-47`) and **View > AI Assistant** raises a modal alert headed "AI Assistant Disabled" instead of opening anything (`AppDelegate+MenuActions.swift:501-511`). A reader with no account and the default toggle sees no panel and no suggestions. With the toggle on but no key, the panel does open and does show suggestions | "the panel opens once you turn the toggle on, and still shows its suggested questions, but every question you send comes back with the message above" |
| 12 | "Choose **Settings...** (Cmd-,) from the application menu ... and click **AI Services**." | true | `MainMenu.swift:110-115`, `NSMenuItem(title: "Settings...", ..., keyEquivalent: ",")` in `appMenu`. `AIServicesSettingsTab.swift` is the tab | |
| 13 | "the toggle at the top of the tab, whose label reads `Enable AI-powered search`" | true | `AIServicesSettingsTab.swift:110`, `Toggle("Enable AI-powered search", isOn: $settings.aiSearchEnabled)`, first control in the Form | |
| 14 | "It is off when LGE is installed" | true | `AppSettings.swift:288`, `public var aiSearchEnabled: Bool = false` | |
| 15 | "while it is off the panel refuses every question with the reply \"AI Assistant is disabled. Enable it in Settings > AI Services.\"" | false | The string exists (`AIAssistantService.swift:92`) but no reader can reach it. With the toggle off the Assistant tab is absent (`InspectorViewModel.swift:44-47`) and the menu item raises an alert (`AppDelegate+MenuActions.swift:501-511`), so there is no question field to type into. The service guard is defence in depth behind an unreachable path | "while it is off there is no assistant to type into. The Assistant tab does not appear, and **View > AI Assistant** raises an alert headed \"AI Assistant Disabled\" whose text reads \"Enable AI-powered search in Settings > AI Services to use the assistant.\"" |
| 16 | "Nothing you type reaches a provider while the toggle is off" | true | `AIAssistantService.swift:91-93` returns before `resolveProviders()` is called. The UI gates earlier still | |
| 17 | "the picker whose label reads `Default provider:` ... with three options reading \"Anthropic Claude\", \"OpenAI\", and \"Google Gemini\"" | true | `AIServicesSettingsTab.swift:118-121` | |
| 18 | "`sk-ant-...` for Anthropic, `sk-...` for OpenAI, and `AIza...` for Google Gemini" | true | `AIServicesSettingsTab.swift:131`, `:146`, `:160`, each a `SecureField("API Key", ..., prompt:)` | |
| 19 | "LGE writes the key into the macOS Keychain ... and never into your project folder." | true | `AIServicesSettingsTab.swift:73-77` reads through `KeychainSecretStorage.shared.retrieve(forKey:)`. `:215-221` writes back with `debouncedStore`. No project path appears in either | |
| 20 | "A short line reading \"Saving API key changes to Keychain…\" appears under the form while the write is in progress." | true | `AIServicesSettingsTab.swift:195`, gated on `credentialPersistence.isSaving` | |
| 21 | "A small indicator sits to the left of each key field and reports what LGE knows about that key" | true | `AIServicesSettingsTab.swift:128`, `:143`, `:158` place `statusIndicator(state:)` before the `SecureField` in an `HStack`. `:255-274` maps five `KeyValidationState` cases to symbols | |
| 22 | "Choose **View > AI Assistant** (Cmd-Shift-A)." | true | `MainMenu.swift:481-487`, title "AI Assistant", `keyEquivalent: "a"`, mask `[.command, .shift]`. No collision (Select All is Cmd-A, `MainMenu.swift:388-391`) | |
| 23 | "A window titled \"AI Assistant\" opens beside your main window. It is a floating panel, meaning it stays in front of the main window and stays visible while you click around behind it, and it remembers where you put it." | false | The menu item opens no window. `AppDelegate+MenuActions.swift:499-526` `showOrToggleAIAssistant()` reveals the Inspector and posts `showInspectorRequested` with `inspectorTab: "ai"`, so the assistant appears as the Inspector's **Assistant** tab (`InspectorView.swift:86-88` `EmbeddedAIAssistantView`, label at `:233`, sparkles icon at `:217`). The floating `NSPanel` at `AIAssistantPanel.swift:39-60` lives in `AIAssistantWindowController`, which is constructed nowhere in `Sources/` and only in `Tests/LungfishAppTests/WindowAppearanceTests.swift:391`. It is dead code | "The Inspector opens on the right of your main window with its **Assistant** tab selected. The assistant is a tab in the Inspector rather than a separate window, so it stays beside your data and moves and resizes with the Inspector." |
| 24 | "Its header carries the title, a status line, a **Data sent…** button, and a **Clear** button." | true | `AIAssistantPanel.swift:271-306` builds the header on `AIAssistantViewController`, which the Inspector embeds (`InspectorView.swift:1324-1329`). Title `:277`, `statusLabel` `:280`, `disclosureButton.title = "Data sent…"` `:297`, `clearButton.title = "Clear"` `:285` | |
| 25 | "the suggestions include a data overview, a look at the current view, a gene search, a variant statistics breakdown, a PubMed literature search, and a chromosome guide" | true | `AIAssistantService.swift:733-806` builds titles "Data overview", "Explore current view", "Search for a gene", "Variant statistics", "Find related research", "Chromosome guide", among ten. The chr20 bundle has `variant_count: 1056` in its manifest, so the variant-gated suggestions at `:761-781` do appear | |
| 26 | "With no bundle loaded there is a single suggestion, which asks for step-by-step instructions on loading a bundle." | true | `AIAssistantService.swift:709-716`, the `state.bundleName == nil` branch returns exactly one "Getting started" query and returns early | |
| 27 | "A popover opens showing exactly what a request would carry and which companies could receive it, and it sends nothing while you read it." | true | `AIAssistantPanel.swift:309-334` builds an `NSPopover` whose text is `service.contextDisclosure()`. `AIAssistantService.swift:55-56` documents it as "Local preview only: never reads credentials, validates keys, or contacts a provider" | |
| 28 | "The preview names the fallback order, states that only providers with validated credentials are used, warns that a failed request may already have reached one provider ... and prints the current context in full" | true | `AIAssistantService.swift:68-77`, all four elements present, including "A failed request may already have reached one provider before another provider receives the fallback request." | |
| 29 | "the field at the bottom of the panel, which reads \"Ask about your genome data...\"" | true | `AIAssistantPanel.swift:343`, `inputField.placeholderString = "Ask about your genome data..."` | |
| 30 | "A spinning indicator appears while the provider works." | true | `AIAssistantPanel.swift:481-500`, an `NSProgressIndicator` with `style = .spinning`. It is accompanied by an "Analyzing..." label at `:493`, which the chapter does not name but does not contradict | |
| 31 | "The reply arrives as a message in the panel with a copy button on it, which turns to a checkmark for a moment after you click it." | true | `AIAssistantPanel.swift:740-748` adds the `doc.on.doc` button only when `!isUser && !isWelcome`. `:905-913` swaps to a checkmark and back after one second | |
| 32 | "While a request is in flight the panel declines a second with \"Please wait for the current request to complete.\"" | true | `AIAssistantService.swift:95-98`, the `!isProcessing` guard | |
| 33 | "Every message disappears, the welcome message returns, and the suggested questions are rebuilt against whatever is loaded now." | true | `AIAssistantPanel.swift:644-658` `clearConversation()`, in that order: `service.clearConversation()`, remove subviews, `addWelcomeMessage()`, unhide the container, `refreshSuggestedQueries()` | |
| 34 | "Clearing touches only the panel. It writes nothing to your project and deletes nothing from it." | true | `AIAssistantPanel.swift:644-658` and `AIAssistantService.swift:236-240` touch only view state, the message array, and the token counter | |
| 35 | "The **Restore Defaults** button at the foot of the tab returns all of them to the values described here, while leaving your keys in the Keychain untouched." | true | `AIServicesSettingsTab.swift:188` calls `settings.resetSection(.aiServices)`. `AppSettings.swift:837-846` resets the nine AI settings only. Key removal lives behind the separate Clear All Keys button at `:182` | |
| 36 | "`Enable AI-powered search`. ... The default is off" | true | `AIServicesSettingsTab.swift:110`, `AppSettings.swift:288` | |
| 37 | "Default provider:. ... The default is \"Anthropic Claude\"." | true | `AppSettings.swift:300`, `preferredAIProvider = "anthropic"`, which the picker tags to "Anthropic Claude" (`AIServicesSettingsTab.swift:119`) | |
| 38 | "the full order is your default followed by Anthropic, OpenAI, and Google Gemini with the default removed from the list" | true | `AIAssistantService.swift:257`, `[preferred] + [.anthropic, .openAI, .gemini].filter { $0 != preferred }`. Repeated at `:60-61` for the disclosure | |
| 39 | "A provider whose key field is empty is skipped before any request is made" | true | `AIAssistantService.swift:283-291` `makeProvider` returns nil when the Keychain value is absent or empty, before any provider is constructed | |
| 40 | "there is one such field under **Anthropic**, **OpenAI**, and **Google Gemini**" | true | `AIServicesSettingsTab.swift:129`, `:143`, `:157`, three `Section` headers of exactly those names, each with one `SecureField("API Key", ...)` | |
| 41 | "Anthropic offers four options and marks Claude Sonnet 4.6 as recommended, OpenAI offers twelve and marks GPT-5.5 as recommended, and Google Gemini offers eight and marks Gemini 3.5 Flash as recommended." | true | `AIServicesSettingsTab.swift:29-32` (4 entries, "Claude Sonnet 4.6 (Recommended)"), `:34-47` (12 entries, "GPT-5.5 (Recommended)"), `:49-58` (8 entries, "Gemini 3.5 Flash (Recommended)") | |
| 42 | "The defaults are those three recommended entries" | true | `AppSettings.swift:294` `claude-sonnet-4-6`, `:297` `gemini-3.5-flash`, `:291` resolving to `OpenAIEndpointConfiguration.defaultOpenAIModel`, which is `"gpt-5.5"` (`OpenAIEndpointConfiguration.swift:30`) | |
| 43 | "when your provider retires the default and the picker shows your saved value as a Custom entry instead" | true | `AIServicesSettingsTab.swift:250-252`, `Text("Custom (\(selection))")` appended when the saved id is not in the option list | |
| 44 | "**Use Azure AI-hosted endpoint.** ... The default is off." | true | `AIServicesSettingsTab.swift:172`, `Toggle("Use Azure AI-hosted endpoint", ...)`. `AppSettings.swift:303`, `openAIHostedEndpointEnabled = false` | |
| 45 | "`lungfish-cli genotype ai-haplotyping` accepts the same information as `--azure-openai-endpoint` and `--azure-openai-deployment`" | true | `lungfish-cli genotype ai-haplotyping --help`, both flags present, described as "Azure OpenAI endpoint, such as https://example.openai.azure.com" and "Azure OpenAI deployment name to use instead of a direct OpenAI model" | |
| 46 | "**Endpoint.** ... in the shape shown as placeholder text, `https://example.openai.azure.com`. There is no default and the field starts empty." | true | `AIServicesSettingsTab.swift:173`. `AppSettings.swift:309`, `openAIHostedEndpoint = ""` | |
| 47 | "**Deployment.** ... with `gpt-5-mini` shown as placeholder text" | true | `AIServicesSettingsTab.swift:174`. `AppSettings.swift:312`, `openAIHostedDeployment = ""` | |
| 48 | "**Clear All Keys.** Removes all three provider keys from the Keychain at once. ... LGE asks first, with a dialog headed \"Clear All API Keys?\" whose text reads \"This will remove the three AI provider keys from Keychain. You will need to re-enter them to use AI features.\"" | true | `AIServicesSettingsTab.swift:182` the button, `:236-240` the `.alert` with exactly that title and message, and a Clear and a Cancel button | |
| 49 | "A question the assistant answered by consulting your data will show it running lookups before the reply appears." | true | `AIAssistantService.swift:158-159` fires `onStatusUpdate?(toolLabel)` per tool call, and `:862-877` `toolDisplayName` returns strings such as "Searching genes...", "Reading variant table...", "Listing chromosomes...". `AIAssistantPanel.swift:602` binds them to `statusLabel` | |
| 50 | "Eleven lookups are available to the assistant ... Two of those move the view ... The other nine only read." | true | `AIToolRegistry.swift:271-295`, the dispatch switch names exactly eleven. `navigate_to_gene` and `navigate_to_region` move the view. The other nine read and none writes | |
| 51 | "list the chromosomes or contigs in the loaded reference with their sizes" | true | `AIToolRegistry.swift:243-249`, `list_chromosomes`, "List all chromosomes/contigs available in the loaded genome assembly with their sizes." | |
| 52 | "\"No configured AI provider has a valid API key with available credits.\" means the feature is on but no key survived validation" | true | `AIAssistantService.swift:268-270`, thrown after `filterValidProviders` returns empty, which is reached only when at least one provider was constructed from a non-empty key | |
| 53 | "\"I reached the maximum analysis steps ...\" means the assistant used up its budget of eight lookup rounds" | true | `AIAssistantService.swift:213` the exact string, `:42` `private let maxToolRounds = 8` | |
| 54 | "separate guidance for rhesus macaque, human, and mouse datasets and a general species-aware form for everything else" | true | `AIAssistantService.swift:656-698`, three branches keyed on organism or assembly substrings, then a `speciesDescriptor` fallback | |
| 55 | "On a macaque dataset it will name macaque-compatible antibody clones as examples and tell you to check clone and epitope compatibility." | true | `AIAssistantService.swift:657-666`, "for example, CD3 clone SP34-2 ... clearly tell the user to verify clone and epitope compatibility before use" | |
| 56 | "The assistant edits no files, runs no workflow, imports and deletes no bundles, and writes nothing into your project's provenance." | true | `AIToolRegistry.swift:271-295`. No case writes a file, launches a workflow, or mutates a bundle | |
| 57 | "The AI Assistant panel has no command-line counterpart." | true | No `lungfish-cli` command opens a chat session. `genotype ai-haplotyping` reaches a provider but operates on a `.lungfishgenotype` bundle without conversation | |
| 58 | "`lungfish-cli search` looks for an exact string, an IUPAC ambiguity motif, or a regular expression in a FASTA file and writes the hits as BED, with no model involved." | true | `lungfish-cli search --help`, "Search for exact strings, IUPAC motifs, or regex patterns ... Outputs results in BED format". Flags `--regex`, `--iupac`, `-o` | |
| 59 | "`lungfish-cli universal-search` queries a local index of the datasets and analyses inside one project, and its query language is a field syntax such as `type:fastq_dataset`" | true | `lungfish-cli universal-search --help`, "Queries the project-scoped universal search index", example `--query "type:fastq_dataset role:air_sample date>=2025-01-01"` | |
| 60 | "`lungfish-cli genotype ai-haplotyping` ... takes its own `--provider`, `--model`, `--azure-openai-endpoint`, and `--azure-openai-deployment` flags." | true | `lungfish-cli genotype ai-haplotyping --help`, all four present, `--provider` values openai or anthropic defaulting to openai | |
| 61 | No answer text is quoted anywhere | true | Every quoted string in the chapter traces to source. `AIAssistantService.swift:92`, `:97`, `:213`, `:270`, plus `AIServicesSettingsTab.swift:195` and `:239`. Nothing is model output | |
| 62 | Shot `ai-assistant-provider-setup` is capturable | true | The toggle, the `Default provider:` picker, and a provider's API Key field and Model picker are all on one tab (`AIServicesSettingsTab.swift:107-169`) and need no key to render | |
| 63 | Shot `ai-assistant-azure-endpoint` is capturable | true | `AIServicesSettingsTab.swift:171-177`, the Azure AI Section with the toggle and both TextFields, on the same tab, no key needed | |
| 64 | Shot `ai-assistant-panel` caption, "The AI Assistant panel floating beside a dataset viewport" | false | Nothing floats. The assistant renders inside the Inspector (claim 23). The rest of the caption is capturable, since the header, welcome message, and suggestion buttons all render without a key once the toggle is on and a genomics bundle is loaded | "The Assistant tab of the Inspector beside a dataset viewport, showing the welcome message, the suggested-question buttons, and the Data sent and Clear buttons in its header." |

## Front matter

Schema matches `STYLE.md:153-176`. All required keys present and well formed.

- `brand_reviewed: false` and `lead_approved: false`, both correct for this stage.
- `fixtures_refs: [demo-project]` resolves to `docs/user-manual/fixtures/demo-project`, a real directory.
- `features_refs: [ai.assistant]` resolves to `features.yaml:1156`.
- `glossary_refs: [ai-assistant, api-key, keychain, provenance]`. All four anchors
  exist, at `GLOSSARY.md:13`, `:17`, `:333`, `:521`. The two new entries follow the
  house shape and carry See also lines.
- `shots:` lists three ids, and the body carries three matching `<!-- SHOT: id -->`
  markers with no orphan on either side.
- `entry_points: ["View > AI Assistant"]` is the real menu item (`MainMenu.swift:483`),
  though the surface it opens is not what the body says. Correct as metadata.
- `estimated_reading_min: 16` is plausible for a chapter of this length.

One correction needed. The `ai-assistant-panel` caption must lose "floating", per
claim 64.

## Consistency

Checked against `CONSISTENCY.md`.

- Naming. "Lungfish Genome Explorer (LGE)" at line 29, "LGE" thereafter. "Lungfish"
  never appears alone. Correct.
- Menu paths. Bold, greater-than with spaces, ellipsis on dialog-opening items.
  **File > New Project**, **Settings...**, **View > AI Assistant**,
  **Settings > AI Services**. Correct.
- Before you start. The fixed first two sentences from `CONSISTENCY.md:138-146`
  are reproduced verbatim, adapted for the fixture. Correct.
- Settings entries. All eight begin with the label in bold with the period inside
  the bold, then what it does, the default and why, and when to change it, then
  the flag sentence. `Clear All Keys` is an action rather than a stored value and
  says so, which is a reasonable adaptation. Correct.
- The command-line rule. Every entry ends with "This setting has no command-line
  flag." Correct.
- Fixture naming. **One deviation.** `CONSISTENCY.md:122-130` fixes the name
  "the HG002 chromosome 20 slice". The chapter writes "a human chromosome 20 slice"
  once (line 39) and "the chromosome 20 bundle" four times (lines 39, 75, 83). The
  editor should settle on the sheet name at first mention, then a short form.
- Glossary discipline. API key, large language model, provenance, headless, and
  Keychain are each glossed in plain words at first use. Correct.

## App defects

1. **The floating AI Assistant panel is dead code.** `AIAssistantWindowController`
   (`AIAssistantPanel.swift:39-60`) builds a titled, floating, autosaved `NSPanel`,
   and nothing in `Sources/` ever constructs it. The only reference is
   `Tests/LungfishAppTests/WindowAppearanceTests.swift:391`. The shipping surface
   is the Inspector's Assistant tab (`AppDelegate+MenuActions.swift:519-525`,
   `InspectorView.swift:86-88`). Either the panel should be removed or the menu
   item should open it. Until then the menu item's name and the class name both
   promise a window that never appears.

2. **The Assistant tab exists only in genomics content mode.**
   `InspectorViewModel.swift:34-73` appends `.ai` only in the `.genomics` case.
   With a FASTQ bundle, an assembly, a mapping result, a classifier result, or a
   genotype bundle selected, **View > AI Assistant** reveals the Inspector but the
   tab it asks for is not in `availableTabs`, so the reader gets an Inspector with
   no assistant and no explanation. The chapter's premise that the assistant answers
   questions about "the dataset you have open" holds only for reference bundles.

3. **The disabled-state message at `AIAssistantService.swift:92` is unreachable.**
   The UI hides the tab (`InspectorViewModel.swift:44-47`) and the menu raises an
   alert (`AppDelegate+MenuActions.swift:501-511`) before any question can be typed.
   Not a bug on its own, but it means two different disabled messages exist and only
   the alert's wording ("Enable AI-powered search in Settings > AI Services to use
   the assistant.") is ever seen. Worth aligning the two strings.

4. **`AppSettings.openAIHostedEndpointKind` has no control.** `AppSettings.swift:306`
   defaults it to `"azure"` and `resetSection` restores it (`:844`), but the Azure AI
   section exposes only the toggle, the endpoint, and the deployment. Confirmed as
   the author reported. An unsurfaced setting rather than a broken one, and correctly
   left out of the chapter.

5. **The demo project has no bundle carrying both annotations and variants.**
   `chr20_10.0-10.5Mb.lungfishref` has `"annotations": []` and 1056 variants across
   two tracks. `HBB.lungfishref` has `imported_annotations.gff3` and an empty
   `variants/` directory. Any chapter that wants to demonstrate a gene-and-variant
   question needs a fixture change. This is what makes claim 7 false.

6. **The chr20 bundle's organism reads "chr20 10.0-10.5Mb".** Its `manifest.json`
   `source.organism` and `source.assembly` both carry the slice name rather than
   "Homo sapiens" or "GRCh38". `AIAssistantService.swift:668` detects human on
   `homo sapiens`, `human`, `grch`, or `hg` substrings, so the demo project's chr20
   bundle will not trigger the human branch, and the suggestions at `:733-806` will
   interpolate "chr20 10.0-10.5Mb" where they mean an organism. A fixture metadata
   defect worth fixing before the shot is captured.

## Notes for the editor

- Claims 11, 15, and 23 are one root cause. The chapter describes a floating window
  that does not open and a toggle-off behaviour that no reader can reach. Step 4 and
  the first Settings paragraph both need rewriting around the Inspector's Assistant
  tab. The corrected wordings in the table are drafted to slot in.
- Claim 10 is the other substantive fix, and it is small. The no-key case produces
  the "API key is not configured" string, not the "available credits" one. The
  Reading the results paragraph that quotes the credits message is correct as it
  stands, because it describes the key-present-but-invalid case. Only the Before you
  start sentence needs the swap.
- Claim 7 needs the third question dropped or replaced. The fixture cannot answer it.
- Defect 2 deserves a sentence in the chapter even after the rewrite. A reader who
  opens a Kraken 2 result and reaches for the assistant will find nothing, and the
  chapter currently promises the opposite.
- The `ai-assistant` glossary entry at `GLOSSARY.md:13` contains a semicolon, which
  the prose rules ban. It predates this chapter and the author correctly left it. It
  needs a Phase 6 sweep, not a fix here.
- The reality map cites `MainMenu.swift` without a directory. The file is at
  `Sources/LungfishApp/App/MainMenu.swift`. Confirmed, and worth correcting in the
  ground-truth file so later chapters do not chase it.
- `features.yaml:1156-1167` titles the feature "AI assistant panel" and lists
  `AIAssistantPanel.swift` as a source. Both carry the same stale framing as the
  chapter. The code cartographer should be told.
- Lint is clean. `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` prints "no issues found".
  Independently verified: no em dashes, no semicolons, no mid-sentence colons in
  prose, no bullet lists at all, so the 5/2 caps are moot. The two backticked labels
  the author flagged are a reasonable workaround and read acceptably.
- The nav line sits at `mkdocs.yml:147`, immediately after Running in CI at `:146`,
  as intended.

## Counts

64 claims checked. 58 true, 6 false, 0 unverifiable.

False: 7 (gene question the fixture cannot answer), 10 (wrong no-key message),
11 (panel does not open with the toggle off), 15 (unreachable disabled reply),
23 (floating window is dead code, the surface is the Inspector's Assistant tab),
and 64 as a consequence of 23 (shot caption).

Six app or fixture defects recorded, of which the floating-panel dead code and the
genomics-only Assistant tab are new.
