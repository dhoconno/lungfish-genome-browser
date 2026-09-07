# Fidelity review, appendices/keyboard-shortcuts.md

Reviewed 2026-09-07 against Preview 2026.9.13 source. No key was pressed in
this review either, so every verdict below is source-derived and matches the
author's own standard of evidence. Where a claim is about runtime responder
behaviour rather than about a binding, the verdict is unverifiable and the
row says what would settle it.

Arbiters used. `Sources/LungfishApp/App/MainMenu.swift` for every menu-bar
shortcut, `Sources/LungfishApp/App/AppDelegate.swift:1908-2060` for every
gate, and the `keyDown` / `performKeyEquivalent` / toolbar definitions named
per row for the rest.

## Roster confirmation, independently extracted

I extracted every `keyEquivalent:` argument in `MainMenu.swift` myself rather
than reading the author's table. The file carries 130 `keyEquivalent`
occurrences, of which 45 are non-empty. The 45 lines are 113, 133, 139, 154,
172, 179, 196, 210, 351, 357, 367, 373, 379, 391, 403, 409, 415, 440, 450,
458, 466, 475, 485, 507, 518, 529, 545, 551, 557, 563, 574, 581, 591, 611,
630, 636, 645, 652, 662, 669, 777, 870, 906, 920, 988.

That list is identical to the author's, line for line. **The roster of 45 is
confirmed.** Every title, key equivalent, and modifier mask in the author's
table matches source. I re-read each mask assignment rather than trusting the
"default `.command`" annotations, and every one of the 45 is correct.

Collision check, run independently over (modifier set, key equivalent) for
all 45. **No duplicate pair.** The near-misses are all separated by a real
modifier. Cmd-H against Cmd-Opt-H, Cmd-F against Cmd-Opt-F against
Cmd-Ctrl-Opt-F against Cmd-Ctrl-F, Cmd-N against Cmd-Opt-N, Cmd-G against
Cmd-Shift-G against Cmd-Opt-G, Cmd-Z against Cmd-Shift-Z, Cmd-A against
Cmd-Shift-A, Cmd-C against Cmd-Shift-C, and the plus/minus/0 trio against its
Cmd-Opt twin.

Menu shortcuts the chapter omits: **none.** All 45 appear in the chapter,
either in a table or in prose. Menu shortcuts the chapter lists that source
lacks: **none.**

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Settings... \| Cmd-comma" | true | `MainMenu.swift:110-113`, title `"Settings..."`, keyEquivalent `","`, no mask so AppKit default `.command` | |
| "Hide Lungfish Genome Explorer \| Cmd-H" | true | `MainMenu.swift:131-133`, `"Hide \(appIdentity.fullName)"`, keyEquivalent `"h"` | |
| "Hide Others \| Cmd-Opt-H" | true | `MainMenu.swift:137-141`, mask `[.command, .option]` at 141 | |
| "Quit Lungfish Genome Explorer \| Cmd-Q" | true | `MainMenu.swift:151-154` | |
| "The same menu also carries About and Check for Updates..., and neither has a shortcut." | true | `MainMenu.swift:93-104`, both `keyEquivalent: ""` | |
| "Check for Updates... is greyed out on a build that has no update feed configured." | true | `AppDelegate.swift:1940-1942`, `return canCheckForUpdatesHandler?() ?? false` | |
| The app-menu prose omits **Show All**, a further no-shortcut item sitting between Hide Others and Quit | false (omission) | `MainMenu.swift:143-147`, `withTitle: "Show All"`, `keyEquivalent: ""` | Add Show All to the sentence naming the menu's unshortcut items. |
| "New Project \| Cmd-N" | true | `MainMenu.swift:169-172` | |
| "Open Project Folder... \| Cmd-O" | true | `MainMenu.swift:175-179`, title `"Open Project Folder..."` | |
| "Close \| Cmd-W" | true | `MainMenu.swift:193-196`, title is bare `"Close"` | |
| "Import Center... \| Cmd-Shift-I" | true | `MainMenu.swift:207-212`, title `"Import Center\u{2026}"`, mask `[.command, .shift]` | |
| "There is no Save command and no Cmd-S." | true | No Save item exists. My own extraction of all 45 non-empty key equivalents contains one `"s"`, at line 440, which is Show Sidebar with mask `[.command, .control]`. There is no plain Cmd-S | |
| "The File menu explains this in its own words under About Saving..., which has no shortcut of its own." | true | `MainMenu.swift:197-201`, `withTitle: "About Saving…"`, `keyEquivalent: ""` | |
| "the Export submenu with its six export commands" | true | `MainMenu.swift:216-256`. Six `withTitle:` entries, Sequences (FASTA/GenBank), Annotations (GFF3), FASTQ, Project Sample Metadata (CSV), Image (PNG), Image (PDF). The Provenance submenu is counted separately by the chapter, correctly | |
| "the Provenance submenu nested inside Export" | true | `MainMenu.swift:259-272`, `exportMenu.addItem(provenanceItem)` at 271 | |
| "Manage Project Storage..." named as an unshortcut item | true | `MainMenu.swift:280-286`, `keyEquivalent: ""`. It is additionally gated at `AppDelegate.swift:2036-2044`, which the chapter does not say. Not an error, because the chapter's gating rule concerns shortcuts and this item has none | |
| The six Edit rows, Undo Cmd-Z, Redo Cmd-Shift-Z, Cut Cmd-X, Copy Cmd-C, Paste Cmd-V, Select All Cmd-A | true | `MainMenu.swift:351, 357-359, 367, 373, 379, 391`. Redo's mask at 359 | |
| "Find... is Cmd-F, Find Next is Cmd-G, and Find Previous is Cmd-Shift-G" | true | `MainMenu.swift:403, 409, 415-417` | |
| "Delete sits between Select All and the Find submenu with no shortcut." | false | `MainMenu.swift:382-397`. Delete is added at 382-386, Select All at 388-392, then the separator and the Find submenu at 397. Delete sits **above** Select All | "Delete sits just above Select All with no shortcut." |
| "Show Sidebar \| Cmd-Ctrl-S" | true | `MainMenu.swift:437-442`, mask `[.command, .control]`. Spelling disagreement handled under Consistency | |
| "Show Inspector \| Cmd-Opt-I" | true | `MainMenu.swift:447-452`, mask `[.command, .option]` | |
| "Focus Viewer \| Cmd-Opt-F" | true | `MainMenu.swift:455-460` | |
| "Restore Side Panes \| Cmd-Ctrl-Opt-F" | true | `MainMenu.swift:463-468`, mask `[.command, .control, .option]` | |
| "Document Inspector \| Cmd-Opt-D" | true | `MainMenu.swift:471-477` | |
| "AI Assistant \| Cmd-Shift-A" | true | `MainMenu.swift:482-487`, title is bare `"AI Assistant"` | |
| "Enter Full Screen \| Cmd-Ctrl-F" | true | `MainMenu.swift:607-613`, mask `[.command, .control]` | |
| "When the panel is showing, the menu reads Hide Sidebar or Hide Inspector instead, and the same shortcut does the hiding." | true | `AppDelegate.swift:1915-1930`. Tags 1000 and 1001 rewrite `menuItem.title` only, leaving `keyEquivalent` and the mask untouched | |
| "Zoom In Cmd-plus, Zoom Out Cmd-minus, Zoom to Fit Cmd-0, Zoom Reset (10kb) Cmd-1" | true | `MainMenu.swift:541-564`. All four carry no explicit mask, so `.command` | |
| "they are greyed out whenever no such display is open" | true | `AppDelegate.swift:2012-2022`, all four zoom selectors return `canZoom(viewerController:)` against `activeFullSequenceViewerController` | |
| "Larger is Cmd-Opt-plus, Smaller is Cmd-Opt-minus, and Default is Cmd-Opt-0." | true | `MainMenu.swift:503-531`, all three masked `[.command, .option]` | |
| "The Option key is what separates these three from the three viewport zoom commands" | true | `MainMenu.swift:489-491` source comment states exactly this. The masks confirm it | |
| "Show as RNA (U instead of T) is Cmd-Shift-U ... and puts a checkmark beside the menu row while it is on" | true | `MainMenu.swift:588-594`, tag 1002. `AppDelegate.swift:1932-1938` sets `menuItem.state = isRNAMode ? .on : .off` | |
| "Expand All is Cmd-Shift-Right Arrow and Collapse All is Cmd-Shift-Left Arrow" | true | `MainMenu.swift:571-583`, `NSRightArrowFunctionKey` / `NSLeftArrowFunctionKey`, both masked `[.command, .shift]` | |
| "Reset View Settings to Defaults sits at the bottom with no shortcut." | false | `MainMenu.swift:597-613`. It is followed by a separator and then **Enter Full Screen**, so it is not at the bottom of the View menu | "Reset View Settings to Defaults sits near the bottom with no shortcut." |
| The six Sequence rows, Reverse Complement... Cmd-Shift-R, Translate... Cmd-Shift-T, Go to Location... Cmd-L, Go to Gene... Cmd-Opt-G, Copy Visible Region as FASTA Cmd-Shift-C, Extract Visible Region... Cmd-Shift-E | true | `MainMenu.swift:626-671`. Masks at 631, 637, none for Go to Location, 654, 664, 671 | |
| "It takes Cmd-Opt-G rather than Cmd-G so that it does not collide with Find Next, which is Cmd-G and standard." | true | `MainMenu.swift:650-651` source comment says "Go to Gene uses Command-Option-G so Command-Shift-G remains Find Previous". The chapter names Find Next (Cmd-G) where the comment names Find Previous (Cmd-Shift-G). Both collisions are real and both are avoided, so the chapter's claim stands on its own terms | |
| "All six of these commands are greyed out when no sequence viewer is active." | true | `AppDelegate.swift:1978-2011` gates all six on `activeFullSequenceViewerController` | |
| "Add Annotation... and Find ORFs... sit at the bottom of the menu with no shortcuts." | true | `MainMenu.swift:673-687`, both `keyEquivalent: ""`, and they are the last two items | |
| "Plugin Manager... \| Cmd-Shift-B" | true | `MainMenu.swift:774-779` | |
| "Call Variants..., Workflow Library..., Haplotype Definitions..., the three items of the Search Online Databases submenu, and every individual tool are all reached by clicking." | true | `MainMenu.swift:719-723, 766-771, 709-713, 745-760`, all `keyEquivalent: ""`. `ToolsMenuModel` tool items are built with `keyEquivalent: ""` at `MainMenu.swift:810-816` | |
| "Haplotype Definitions..." presented as an ordinary always-present item | unverifiable as written | `MainMenu.swift:708-716` adds it only `if workflowFeatureAvailability.hasHaplotypeDefinitions`, and `AppDelegate.swift:1967-1971` additionally sets `menuItem.isHidden = !enabled`. The chapter's sentence is about the absence of a shortcut, which is true, but a reader will infer the item is always there. Settled by launching a build without the haplotype feature and looking at the Tools menu | Optionally note that Haplotype Definitions... appears only when the haplotype feature is available, the way the chapter already does for Workflow Builder. |
| "Workflow Builder (Experimental)... is absent from the menu until experimental features are on." | true | `MainMenu.swift:728-737`, the whole `addItem` sits inside `if experimentalFeaturesEnabled` | |
| "you turn on Show Experimental Features in Settings > Advanced" | unverifiable | `MainMenu.swift` receives `experimentalFeaturesEnabled` as a parameter and does not name the settings control. The toggle's own title and pane were not read in this review | Settled by reading the Advanced settings pane view controller for the toggle's exact title. |
| "a tool inside the Tools menu's Genotyping submenu is dead until its software pack is installed" | true | `ToolsMenuModel.swift:33-41` builds items with `isEnabled` / `isInstallable`, and `MainMenu.swift:810-816` applies that to the menu item | |
| "Show Operations Panel \| Cmd-Shift-P" | true | `MainMenu.swift:867-872` | |
| "Clear Completed and Cancel All Operations sit below it without shortcuts" | true | `MainMenu.swift:876-890`, both `keyEquivalent: ""` | |
| "Cancel All Operations stays greyed out until something cancellable is actually running." | true | `AppDelegate.swift:2023-2026`, `OperationCenter.shared.items.contains { $0.isCancellable }`. Additionally `MainMenu.swift:890` sets `isEnabled = false` statically, which the author flagged | |
| "Minimize \| Cmd-M" | true | `MainMenu.swift:903-906`, title bare `"Minimize"` | |
| "New Window for Current Project \| Cmd-Opt-N" | true | `MainMenu.swift:916-922` | |
| "it is greyed out until a project is open" | true | `AppDelegate.swift:2049-2054`, returns whether `projectSession.projectURL` or the sidebar's `currentProjectURL` is non-nil | |
| "Zoom and Bring All to Front have no shortcuts." | true | `MainMenu.swift:908-912, 925-929` | |
| "Lungfish Genome Explorer Help \| Cmd-?" | true | `MainMenu.swift:985-988`, title `"Lungfish Genome Explorer Help"`, keyEquivalent `"?"` | |
| "They are Getting Started, VCF Variants Guide, AI Assistant Guide, Documentation, Release Notes, and Report an Issue..." | true | `MainMenu.swift:993-1028`, six items, all `keyEquivalent: ""`, titles exact | |
| "Documentation" and "Release Notes" presented without a gate | unverifiable as written | `AppDelegate.swift:1909-1914` disables both when `documentationURL` / `releaseHistoryURL` is nil. Neither has a shortcut, so the chapter's claim about shortcuts is true, but the items can be dead | No change needed. Recorded so the editor knows the gate exists if the sentence is ever expanded. |
| "Left and right pan the view by a hundred bases at a time, and up and down zoom in and out." | true | `SequenceViewerView+Interaction.swift:350-361`, keyCodes 123/124 call `pan(by: -100)` / `pan(by: 100)`, keyCodes 126/125 call `zoomIn()` / `zoomOut()` | |
| "Cmd-C copies the current selection and Cmd-A selects everything" | true | `SequenceViewerView+Interaction.swift:364-378`, keyCode 8 and keyCode 0, each guarded by `.command` | |
| "While reads are still loading, Escape cancels that load ... When nothing is loading, Escape clears the current selection instead." | true | `SequenceViewerView+Interaction.swift:379-393`, keyCode 53. `if isFetchingReads \|\| backgroundPackTask != nil { cancelReadLoad(); return }` then `clearSelection()` | |
| "The coordinate ruler above the sequence takes Cmd-0 for zoom to fit and Cmd-1 for the 10 kilobase reset, matching the View menu." | true | `EnhancedCoordinateRulerView.swift:926-938`, `keyDown` guarded on `.command`, cases `"0"` and `"1"` | |
| "The compact read viewer ... takes Cmd-plus, Cmd-minus, and Cmd-0 ... and it offers the same three commands on a right-click menu" | true | `MiniBAMViewController.swift:797-814` routes through `ZoomShortcutHandler`. The context menu at `199-207` carries Zoom In `"+"`, Zoom Out `"-"`, Zoom to Fit `"0"`, each masked `.command` | |
| "The shared code behind these accepts the equals key for plus and the underscore key for minus" | true | `ZoomShortcutHandler.swift:46-56`, `case "+", "="` and `case "-", "_"` on `charactersIgnoringModifiers` | |
| "MSA ... takes Cmd-C to copy the selection and Cmd-A to select the whole alignment." | true | `MultipleSequenceAlignmentViewController.swift:3355-3359`, `.command` plus `"c"` / `"a"` | |
| "The arrow keys move the selection one position at a time, and holding Shift while pressing them extends the selection" | true | `MultipleSequenceAlignmentViewController.swift:3360-3365`, `onKeyboardNavigation?(direction, event.modifierFlags.contains(.shift))` | |
| "On a trackpad, pinching zooms the alignment." | true | `MultipleSequenceAlignmentViewController.swift:3367-3369`, `override func magnify` calls `onMagnification?` | |
| "Focus the quick filter search field \| Cmd-F" | true | `GenotypeResultViewController.swift:1119-1123`, `modifiers == cmd` and `"f"` | |
| "Mark reviewed Cmd-R, mark confirmed Cmd-K, flag needs review Cmd-Shift-F, open Sample Detail Cmd-Shift-O" | true | `GenotypeResultViewController.swift:1138-1151`, cases `("r", cmd)`, `("k", cmd)`, `("F", cmdShift)`, `("O", cmdShift)` | |
| "carries six shortcuts of its own" | true | Five table rows plus Escape, which the following paragraph names. The count is defensible as written | |
| "Escape clears the quick filter search field when it holds text." | true | `GenotypeResultViewController.swift:1124-1129`, `modifiers.isEmpty`, `"\u{1b}"`, `!quickFilterSearchText.isEmpty` | |
| "The four review commands ... work only when the window is on its Review lens or when a call is selected in a haplotyped MiSeq result" | true | `GenotypeResultViewController.swift:1131-1137`, the `guard (selectedLens == .review \|\| hasSelectedMiSeqCall)` sits **after** the Cmd-F and Escape handling and before the four review cases, exactly as the chapter splits them | |
| "Cmd-Opt-P ... Cmd-Opt-N ... Cmd-Opt-R ... Cmd-Opt-M ... These come from the matrix's right-click menu" | true | `GenotypeResultDisplayState.swift:478-508`, key equivalents `"p"`, `"n"`, `"r"`, `"m"`. The mask is `NSEvent.ModifierFlags([.command, .option]).rawValue` at `GenotypeComparisonMatrixView.swift:3216`. Dispatch at `3467-3477` matches against the same context-menu item list, so the menu genuinely is the source | |
| "Cmd-right bracket moves to the next sample, Cmd-left bracket moves to the previous one, and Cmd-0 returns to the All Samples overview." | true | `TaxTriageResultViewController.swift:1002-1027`, cases `"]"`, `"["`, `"0"` | |
| "it does so only when the run holds more than one sample" | true | `TaxTriageResultViewController.swift:996-1000`, `guard ... sampleIds.count > 1 else { return super.performKeyEquivalent(with: event) }` | |
| "The taxonomy sunburst ... takes Escape to step out one ring toward the root and Cmd-0 to return all the way to the root at once." | true | `TaxonomySunburstView.swift:667-681`. keyCode 53 walks to `centerNode?.parent`, and `case 29 where modifiers == .command` calls `zoomToRoot()` | |
| The chapter omits **Opt-Right Arrow**, expand selected recursively, in the taxonomy table | false (omission) | `TaxonomyTableView.swift:1511-1514`, `else if modifiers == .option { taxonomyTableView?.expandSelectedRecursively(); return }`. The author's own record lists this binding, but no sentence in the chapter carries it | Add to the View menu section's taxonomy paragraph. Suggested wording: "Opt-Right Arrow expands the selected branch and everything under it, which is narrower than Expand All." |
| "New Folder is Cmd-Shift-N, Duplicate is Cmd-D, and the delete command ... is the Delete key on its own." | true | `SidebarViewController+MenuDelegate.swift:42-43` and `271-272` (`keyEquivalent: "N"`, mask `[.command, .shift]`), `342-343` (`"D"`, mask `.command`), `362` (`"\u{8}"`, backspace, no mask set) | |
| "These shortcuts belong to that context menu, so they work while it is open rather than as global bindings." | unverifiable | The items are built in `menuNeedsUpdate` and are never installed in the main menu, which makes the claim the correct default reading of AppKit. But no key was pressed to confirm the menu does not vend them while closed. Settled by selecting a sidebar item without opening the context menu and pressing Cmd-D | |
| "The Workflow Builder canvas ... takes the arrow keys to nudge a selected box one grid square at a time and Cmd-A to select every box on the canvas. The Delete key removes the selection." | true | `WorkflowCanvasView.swift:1054-1075`. keyCodes 51 and 117 both call `deleteSelection()`, the four arrows call `moveSelection` by `gridSpacing`, keyCode 0 with `.command` calls `selectAllNodes()` | |
| "The Delete key removes the selection" without naming Forward Delete | true as written | `WorkflowCanvasView.swift:1056-1057`, `case 51, 117`. Forward Delete also works. Not an error, only narrower than source | Optionally "The Delete key removes the selection, and Forward Delete does the same." |
| "Its toolbar tooltips advertise Cmd-plus and Cmd-minus for the two zoom buttons, but no key binding matches those tooltips in this release." | true | Tooltips at `WorkflowBuilderViewController.swift:1112` (`"Zoom in (Cmd +)"`) and `:1122` (`"Zoom out (Cmd -)"`). The toolbar items carry `action` but no `keyEquivalent`. `WorkflowCanvasView.keyDown` (1054-1075) handles only Delete, arrows, and Cmd-A, and installs no `ZoomShortcutHandler`. The View menu's Zoom In is gated on `activeFullSequenceViewerController` at `AppDelegate.swift:2012-2022` | |
| "The zoom buttons work when clicked" | true | `WorkflowBuilderViewController.swift:1111, 1121` set `item.target = self` and `item.action = #selector(zoomIn(_:))` / `zoomOut(_:)` | |
| "pinching on a trackpad zooms in and out of the sequence, alignment, and MSA viewports" | unverifiable in part | MSA confirmed (`MultipleSequenceAlignmentViewController.swift:3367-3369`). The sequence and alignment viewports' `magnify` handlers were not located in this review | Settled by grepping for `override func magnify` in the sequence and alignment view classes. |
| "Any LGE menu item can be remapped from System Settings ... Open System Settings, click Keyboard, then Keyboard Shortcuts, then App Shortcuts." | unverifiable | macOS behaviour, outside LGE source. Documented by Apple and stable across many releases | |
| "`Reverse Complement...` and `Translate...` both end in an ellipsis character" | true | `MainMenu.swift:627` `"Reverse Complement\u{2026}"` and `:635` `"Translate\u{2026}"`. Both are U+2026, not three periods | |
| "the override takes effect the next time LGE launches" | unverifiable | macOS behaviour. The author kept the old chapter's claim in weakened form, which is the right call | |
| "Ctrl-Opt-M moves VoiceOver into the menu bar" | unverifiable | macOS VoiceOver behaviour, outside LGE source | |
| "Full Keyboard Access ... lets you reach every control without a pointer" | unverifiable | macOS behaviour, and the "every control" half is a claim about LGE that was not audited. The author recorded this as unverified too | Consider softening "every control" to "controls" unless an accessibility audit backs it. |
| "Cmd-Shift-letter usually opens or toggles a panel, which is where Show Operations Panel, AI Assistant, Plugin Manager..., and Import Center... come from." | true | All four confirmed above | |
| "On a Sequence menu verb, Cmd-Shift-letter performs the action on the visible region ... Extract, Copy, Translate, and Reverse Complement." | true | `MainMenu.swift:626-671`, all four are Cmd-Shift | |
| "Cmd-Opt-letter targets the inspectors and a few window-level commands, which is Show Inspector, Document Inspector, Focus Viewer, Go to Gene..., and New Window for Current Project." | true | Five Cmd-Opt bindings among the 45, and these are exactly them. Cmd-Opt-H and the three Content Text Size items are also Cmd-Opt, so the list is not exhaustive, but the chapter says "targets", not "is limited to" | |
| "knowing them is faster than memorizing forty-five separate rows" | true | The roster is 45, independently confirmed | |
| "Cmd-plus and Cmd-minus are written that way rather than as punctuation ... macOS treats the equals key and the plus key as the same physical key here" | true | The menu binds `"+"` literally (`MainMenu.swift:545`), and `ZoomShortcutHandler.swift:47-49` accepts `"="` alongside `"+"`. The claim holds for both surfaces | |

## Front matter

| Field | Verdict | Note |
|---|---|---|
| `title: Keyboard Shortcuts` | true | Matches the roster row |
| `chapter_id: appendices/keyboard-shortcuts` | true | Matches the file path |
| `audience: bench-scientist` | true | Consistent with the campaign's other appendices |
| `prereqs: []` | true | A lookup appendix needs none |
| `estimated_reading_min: 9` | true | 225 lines with 11 tables. Nine minutes is defensible for the full read the field measures |
| `task:` "Look up the keyboard shortcut for any common LGE operation." | true | Describes what the chapter does |
| `tags: [reference, shortcuts, productivity, macos]` | true | Accurate |
| `tools: []`, `entry_points: []`, `shots: []`, `illustrations: []`, `features_refs: []`, `fixtures_refs: []` | true | The chapter documents no tool and no operation, so it needs no `parameters_refs` either. DRIFT records no planned shots |
| `glossary_refs: [key-equivalent, modifier-key]` | true | Both anchors exist in `GLOSSARY.md` at lines 361 and 445, and both are linked on first use in the chapter's opening paragraph |
| `brand_reviewed: false`, `lead_approved: false` | true | Correctly left for the later gates |

## Consistency

**Cmd-Opt-I against Cmd-Option-I.** Counted across every committed chapter
under `docs/user-manual/chapters/`, excluding this appendix itself.

- `Cmd-Opt-` spellings: **9 occurrences in 6 files.** `07-assembly/02` (1),
  `09-genotyping/04` (1), `09-genotyping/03` (1), `01-foundations/06` (3),
  `06-classification/03` (1), `06-classification/10` (1).
- `Cmd-Option-` spellings: **8 occurrences in 7 files.** `02-sequences/04`
  (1), `04-alignments/02` (1), `04-alignments/04` (1), `02-sequences/01` (2),
  `05-variants/05` (1), `06-classification/05` (1),
  `06-classification/09` (1).

**Majority is Cmd-Opt, 9 to 8.** The chapter already uses Cmd-Opt, so it
needs no change and Phase 6 should sweep the eight Cmd-Option occurrences.
The margin is one, so this is a close call rather than a settled convention,
and the editor should record the decision somewhere Phase 6 can find it. The
author's report understates the Cmd-Opt side, naming two files where there
are six.

**Cmd-Ctrl-S against Ctrl-Cmd-S.** Counted the same way.

- `Cmd-Ctrl-S`: **0 occurrences** in any committed chapter other than this
  appendix.
- `Ctrl-Cmd-S`: **2 occurrences**, both in
  `01-foundations/06-the-lungfish-project.md`, at lines 14 and 84.

**Majority is Ctrl-Cmd-S, 2 to 0.** By the campaign's stated rule the editor
adopts the majority, which means **this chapter should change to Ctrl-Cmd-S**
and Phase 6 has nothing to sweep. The author's report reaches the opposite
conclusion by weighing the old appendix and a modifier-order convention
rather than by counting, which is not the rule the brief sets. I flag the
tension rather than resolve it, because a modifier-order convention is a
reasonable thing to want. If the editor prefers Cmd-Ctrl-S on convention
grounds, the sweep runs the other way and touches two lines in one file.
Note that the source comment at `MainMenu.swift:434` writes it as
"Control-Command-S", which favours Ctrl-Cmd-S.

**A third instance of the same disagreement, not in the author's report.**
`01-foundations/06:86` writes **Ctrl-Cmd-Opt-F** for Restore Side Panes
against this chapter's **Cmd-Ctrl-Opt-F**. Count is 1 to 0 for Ctrl-Cmd-Opt-F.
This is the same Control-before-Command question, so it must be swept
whichever way Show Sidebar goes. Splitting them would leave the manual
inconsistent with itself in a new way.

**Other cross-chapter spellings, checked and clean.** `01-foundations/06:84`
writes Cmd-Shift-P for Show Operations Panel, matching. `04-alignments/02:90`
writes Cmd-0 and Cmd-1 for Zoom to Fit and Zoom Reset (10kb), matching.
`02-sequences/01:150` and `04-alignments/02:90` write Cmd-Option-G for Go to
Gene, which the Cmd-Opt sweep above covers.

## App defects

1. **Workflow Builder toolbar tooltips advertise unbound chords.** Confirmed
   independently. `WorkflowBuilderViewController.swift:1112` and `:1122` set
   `toolTip` to `"Zoom in (Cmd +)"` and `"Zoom out (Cmd -)"`. Neither
   toolbar item sets a `keyEquivalent`, `WorkflowCanvasView.keyDown`
   (`1054-1075`) does not handle those chords, and the canvas installs no
   `ZoomShortcutHandler`. The View menu's Zoom In and Zoom Out are gated on
   an active sequence viewer (`AppDelegate.swift:2012-2022`), which a
   Workflow Builder window does not provide. So the chords are dead in that
   window. Fix by installing a `ZoomShortcutHandler` on the canvas, which is
   what `MiniBAMViewController` and `SequenceViewerView` already do, or by
   removing the chords from the tooltips. The author's finding stands.
2. **Cmd-0 means four different things by responder context.** Confirmed.
   Zoom to Fit (`MainMenu.swift:557`), All Samples in a TaxTriage result
   (`TaxTriageResultViewController.swift:1022-1027`), zoom to root in the
   taxonomy sunburst (`TaxonomySunburstView.swift:679-680`), and zoom to fit
   in miniBAM and MiniPileupView via `ZoomShortcutHandler`. These sit in
   separate responder contexts and do not collide, so this is an overload
   rather than a bug, and the chapter is right to describe each in place.
   Recorded because it is the likeliest support question this appendix
   generates.
3. **`Cancel All Operations` is disabled statically as well as dynamically.**
   Confirmed. `MainMenu.swift:890` sets `cancelAllItem.isEnabled = false` at
   build time, and `AppDelegate.swift:2023-2026` validates it every time the
   menu opens. Harmless today because the validator runs, but the static
   assignment is redundant and would silently freeze the item if the
   validator were ever removed. Worth a cleanup ticket, not a doc change.
4. **New, not in the author's report. `Restore Side Panes` and `Enter Full
   Screen` are the tightest pair in the roster.** Not a collision, because
   the masks differ (`[.command, .control, .option]` against
   `[.command, .control]`). Recorded only because any future edit that drops
   `.option` from Restore Side Panes would create a real collision with
   Enter Full Screen, and the roster currently has none. No action needed.

No other defect surfaced. The nine drops were all correct. I re-checked the
two carrying the most weight. **Save Project / Cmd-S** genuinely does not
exist, confirmed by my own extraction of all 45 key equivalents, in which the
only `"s"` is Show Sidebar at line 440 with a Control-Command mask. **The
Cmd-? viewport-scoping claim** has no support in source. The item is reached
through `showLungfishHelp(_:)` at `MainMenu.swift:987`, and nothing in the
menu construction passes viewport context. Dropping it was right.

## Notes for the editor

1. **Four false claims, all small and all fixable in one line each.** The
   Delete menu position, the Reset View Settings position, the omitted Show
   All, and the omitted Opt-Right Arrow. None changes a shortcut, and none
   misleads a reader looking up a chord. **Opt-Right Arrow is the one worth
   fixing**, because it is a real binding a reader cannot discover any other
   way, the taxonomy table has no menu row for it, and the author's own
   record already documents it.
2. **The Show All omission is the weakest of the four.** The sentence says
   "The same menu also carries About and Check for Updates..., and neither
   has a shortcut", which is true as stated and does not claim to be
   exhaustive. Adding Show All costs three words and removes the ambiguity.
   The editor may reasonably leave it.
3. **The Ctrl-Cmd-S decision is the only judgement call.** Counting says
   change this chapter. Convention says change the other file. The brief says
   adopt the majority, so the default is to change this chapter to
   Ctrl-Cmd-S and Ctrl-Cmd-Opt-F, and to record why. Whichever way it goes,
   **Restore Side Panes must move with Show Sidebar.**
4. **The Cmd-Opt margin of one is thin enough to be worth pinning.** Nine to
   eight is not a convention, it is a coin flip that landed. Since the
   chapter already uses Cmd-Opt, and Cmd-Opt matches the Opt label this
   chapter teaches in its opening paragraph, keeping Cmd-Opt and sweeping the
   eight is the low-friction path. Write the decision down so Phase 6 does
   not re-litigate it.
5. **Two gating notes the chapter could carry but does not have to.**
   Haplotype Definitions... is conditionally added and conditionally hidden,
   and Documentation and Release Notes disable themselves when their URLs are
   nil. Neither item has a shortcut, so neither belongs in a shortcuts
   appendix by the chapter's own scope rule. Recorded so the editor knows
   they were checked rather than missed.
6. **The chapter has eleven markdown tables, not ten**, because the View menu
   section carries two (panels, then zoom). The count appears nowhere in the
   chapter text, so this affects the campaign's bookkeeping rather than the
   reader.
7. **Lint is green.** `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` prints
   `no issues found`. I independently confirmed zero em dashes and zero
   semicolons. The chapter's 23 H2 sections each carry at most one list, well
   inside the five-bullet and two-list caps. First mention is "Lungfish
   Genome Explorer (LGE)" and every later mention is LGE. Both glossary terms
   are linked on first use and both entries sit in correct alphabetical
   position, Key equivalent after Keychain and Modifier key after mosdepth.
8. **Nothing here was behaviourally confirmed.** The author said so and I am
   repeating it, because the strongest claim this chapter makes is that a
   binding exists, and the weakest link is whether a responder swallows it
   first. The rows most exposed are Cmd-C and Cmd-A in the sequence viewport
   against the Edit menu's own, Cmd-F in the genotype window against Find...,
   Cmd-D in the sidebar context menu, and Cmd-0 across its four contexts. A
   single pass through the running app with those six chords would retire
   every unverifiable row in this report that is about LGE rather than about
   macOS.

## Counts

Claim table: **68 rows.** 59 true, 4 false, 5 unverifiable.

The four false claims.

1. "Delete sits between Select All and the Find submenu" (it sits above
   Select All, `MainMenu.swift:382-397`).
2. "Reset View Settings to Defaults sits at the bottom" (Enter Full Screen
   follows it, `MainMenu.swift:597-613`).
3. The app-menu prose omits **Show All** (`MainMenu.swift:143-147`).
4. The chapter omits **Opt-Right Arrow**, expand selected recursively
   (`TaxonomyTableView.swift:1511-1514`).

The five unverifiable claims. The Settings > Advanced toggle title, the
Haplotype Definitions availability gate as a reader would infer it, whether
the sidebar context-menu chords fire only while the menu is open, whether
pinch zoom reaches the sequence and alignment viewports, and the macOS claims
about System Settings remapping, override timing, VoiceOver, and Full
Keyboard Access.

Front matter: **12 fields checked, 12 true.**

Roster: **45 menu-bar key equivalents, independently extracted and confirmed
identical to the author's. Zero omitted by the chapter, zero listed without
source. Zero collisions.**

Chapter structure: **41 table rows across 11 tables, all 41 shortcut strings
distinct.** About 30 further shortcuts in prose. Lint green.

Spelling counts. **Cmd-Opt 9, Cmd-Option 8**, majority Cmd-Opt, chapter
already correct. **Ctrl-Cmd-S 2, Cmd-Ctrl-S 0**, majority Ctrl-Cmd-S, chapter
currently disagrees. The same disagreement recurs for Restore Side Panes,
**Ctrl-Cmd-Opt-F 1, Cmd-Ctrl-Opt-F 0**, and must be swept with it.

App defects: **4.** Three confirming the author, one new and minor (the
Restore Side Panes / Enter Full Screen mask proximity).
