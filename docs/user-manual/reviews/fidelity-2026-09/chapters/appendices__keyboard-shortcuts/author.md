# Author record, appendices/keyboard-shortcuts.md

Chapter rewritten 2026-09-07 against Preview 2026.9.13 source. Every row is
source-derived. The app was not driven in this session, so no shortcut was
pressed and no row is behaviourally confirmed. Where a shortcut is gated by
`validateMenuItem`, the gate is recorded rather than exercised.

Arbiter for menu shortcuts: `Sources/LungfishApp/App/MainMenu.swift`.
Arbiter for view-level shortcuts: the view controllers named per row.

## Menu-bar shortcuts (MainMenu.swift)

Line numbers are the `keyEquivalent:` line. The mask line follows within a
few lines where a mask is set. An item with no explicit mask carries the
AppKit default `[.command]`.

| Title | Shortcut | Line | Mask |
|---|---|---|---|
| Settings... | Cmd-comma | 113 | default `.command` |
| Hide <app> | Cmd-H | 133 | default `.command` |
| Hide Others | Cmd-Opt-H | 139 | 141 `[.command, .option]` |
| Quit <app> | Cmd-Q | 154 | default `.command` |
| New Project | Cmd-N | 172 | default `.command` |
| Open Project Folder... | Cmd-O | 179 | default `.command` |
| Close | Cmd-W | 196 | default `.command` |
| Import Center... | Cmd-Shift-I | 210 | 212 `[.command, .shift]` |
| Undo | Cmd-Z | 351 | default `.command` |
| Redo | Cmd-Shift-Z | 357 | 359 `[.command, .shift]` |
| Cut | Cmd-X | 367 | default `.command` |
| Copy | Cmd-C | 373 | default `.command` |
| Paste | Cmd-V | 379 | default `.command` |
| Select All | Cmd-A | 391 | default `.command` |
| Find... | Cmd-F | 403 | default `.command` |
| Find Next | Cmd-G | 409 | default `.command` |
| Find Previous | Cmd-Shift-G | 415 | 417 `[.command, .shift]` |
| Show Sidebar | Cmd-Ctrl-S | 440 | 442 `[.command, .control]` |
| Show Inspector | Cmd-Opt-I | 450 | 452 `[.command, .option]` |
| Focus Viewer | Cmd-Opt-F | 458 | 460 `[.command, .option]` |
| Restore Side Panes | Cmd-Ctrl-Opt-F | 466 | 468 `[.command, .control, .option]` |
| Document Inspector | Cmd-Opt-D | 475 | 477 `[.command, .option]` |
| AI Assistant | Cmd-Shift-A | 485 | 487 `[.command, .shift]` |
| Content Text Size > Larger | Cmd-Opt-plus | 507 | 509 `[.command, .option]` |
| Content Text Size > Smaller | Cmd-Opt-minus | 518 | 520 `[.command, .option]` |
| Content Text Size > Default | Cmd-Opt-0 | 529 | 531 `[.command, .option]` |
| Zoom In | Cmd-plus | 545 | default `.command` |
| Zoom Out | Cmd-minus | 551 | default `.command` |
| Zoom to Fit | Cmd-0 | 557 | default `.command` |
| Zoom Reset (10kb) | Cmd-1 | 563 | default `.command` |
| Expand All | Cmd-Shift-Right Arrow | 574 | 576 `[.command, .shift]` |
| Collapse All | Cmd-Shift-Left Arrow | 581 | 583 `[.command, .shift]` |
| Show as RNA (U instead of T) | Cmd-Shift-U | 591 | 593 `[.command, .shift]` |
| Enter Full Screen | Cmd-Ctrl-F | 611 | 613 `[.command, .control]` |
| Reverse Complement... | Cmd-Shift-R | 630 | 631 `[.command, .shift]` |
| Translate... | Cmd-Shift-T | 636 | 637 `[.command, .shift]` |
| Go to Location... | Cmd-L | 645 | default `.command` |
| Go to Gene... | Cmd-Opt-G | 652 | 654 `[.command, .option]` |
| Copy Visible Region as FASTA | Cmd-Shift-C | 662 | 664 `[.command, .shift]` |
| Extract Visible Region... | Cmd-Shift-E | 669 | 671 `[.command, .shift]` |
| Plugin Manager... | Cmd-Shift-B | 777 | 779 `[.command, .shift]` |
| Show Operations Panel | Cmd-Shift-P | 870 | 872 `[.command, .shift]` |
| Minimize | Cmd-M | 906 | default `.command` |
| New Window for Current Project | Cmd-Opt-N | 920 | 922 `[.command, .option]` |
| Lungfish Genome Explorer Help | Cmd-? | 988 | default `.command` |

45 menu-bar shortcuts. A collision check over all 45 (modifier set plus key
equivalent) found **no duplicate pair**. Cmd-plus/Cmd-minus/Cmd-0 versus
Cmd-Opt-plus/Cmd-Opt-minus/Cmd-Opt-0 are distinguished by Option, which the
source comment at line 490 states is the deliberate reason.

## Menu items with no shortcut, named in the chapter

Per the DRIFT Missing rows. About and Check for Updates... (`MainMenu.swift:93-104`),
Open Recent (`182-187`), About Saving... (`197-201`), the Export submenu (`216`)
and the Provenance submenu inside it (`260`), Manage Project Storage... (`280`),
Delete in Edit (`382`), Reset View Settings to Defaults (`597-602`), Add
Annotation... and Find ORFs... (`675-687`), Call Variants... (`719`),
Haplotype Definitions... (`709`), Workflow Builder (Experimental)... (`729`),
Search Online Databases with its three items (`740-761`), Workflow Library...
(`766-771`), Clear Completed and Cancel All Operations (`876-890`), Zoom and
Bring All to Front (`908-912`, `925-929`), Getting Started and VCF Variants
Guide (`993-1000`), AI Assistant Guide (`1005`), Documentation (`1013`),
Release Notes (`1019`), Report an Issue... (`1025`).

## View-level and window-level shortcuts

| Where | Shortcut | Source |
|---|---|---|
| Sequence viewport, pan left/right 100 bases | Left/Right Arrow | `SequenceViewerView+Interaction.swift:352-361` |
| Sequence viewport, zoom in/out | Up/Down Arrow | `SequenceViewerView+Interaction.swift:362-365` |
| Sequence viewport, copy selection | Cmd-C | `SequenceViewerView+Interaction.swift:366-372` (keyCode 8) |
| Sequence viewport, select all | Cmd-A | `SequenceViewerView+Interaction.swift:373-379` (keyCode 0) |
| Sequence viewport, cancel read load, else clear selection | Escape | `SequenceViewerView+Interaction.swift:380-393` (keyCode 53) |
| Sequence viewport, zoom chord passthrough | Cmd-plus / Cmd-minus / Cmd-0 | `SequenceViewerView+Interaction.swift:345-348, 398-402` via `ZoomShortcutHandler` |
| Coordinate ruler, zoom to fit | Cmd-0 | `EnhancedCoordinateRulerView.swift:929-932` |
| Coordinate ruler, zoom reset | Cmd-1 | `EnhancedCoordinateRulerView.swift:933-935` |
| miniBAM alignment panel, zoom in/out/fit | Cmd-plus / Cmd-minus / Cmd-0 | `MiniBAMViewController.swift:798-814`; right-click menu at `200-207` |
| miniBAM local monitor for the same chords | as above | `MiniBAMViewController.swift:819-829` |
| MiniPileupView, zoom in/out/fit | Cmd-plus / Cmd-minus / Cmd-0 | `MiniPileupView.swift:758, 793-805` |
| Shared zoom chord accepts `=` for plus, `_` for minus | n/a | `ZoomShortcutHandler.swift:46-56` (keyCodes 24/69, 27/78, 29/82) |
| MSA viewport, copy selection | Cmd-C | `MultipleSequenceAlignmentViewController.swift:3357` |
| MSA viewport, select all | Cmd-A | `MultipleSequenceAlignmentViewController.swift:3358` |
| MSA viewport, move selection, Shift extends | Arrow keys | `MultipleSequenceAlignmentViewController.swift:3360-3364` |
| MSA viewport, pinch zoom | trackpad magnify | `MultipleSequenceAlignmentViewController.swift:3367-3369` |
| Taxonomy table, expand all | Cmd-Shift-Right Arrow | `TaxonomyTableView.swift:1506-1510` |
| Taxonomy table, collapse all | Cmd-Shift-Left Arrow | `TaxonomyTableView.swift:1517-1522` |
| Taxonomy table, expand selected recursively | Opt-Right Arrow | `TaxonomyTableView.swift:1511-1514` |
| Taxonomy sunburst, step out one ring | Escape | `TaxonomySunburstView.swift:668-677` |
| Taxonomy sunburst, zoom to root | Cmd-0 | `TaxonomySunburstView.swift:679-680` (keyCode 29) |
| Genotype window, focus quick filter search | Cmd-F | `GenotypeResultViewController.swift:1119-1123` |
| Genotype window, clear quick filter search | Escape | `GenotypeResultViewController.swift:1124-1129` |
| Genotype window, mark reviewed | Cmd-R | `GenotypeResultViewController.swift:1139-1141` |
| Genotype window, mark confirmed | Cmd-K | `GenotypeResultViewController.swift:1142-1144` |
| Genotype window, flag needs review | Cmd-Shift-F | `GenotypeResultViewController.swift:1145-1147` |
| Genotype window, open Sample Detail sheet | Cmd-Shift-O | `GenotypeResultViewController.swift:1148-1150` |
| Genotype matrix, mark false positive | Cmd-Opt-P | `GenotypeResultDisplayState.swift:479-484` + mask `GenotypeComparisonMatrixView.swift:3216` |
| Genotype matrix, mark false negative | Cmd-Opt-N | `GenotypeResultDisplayState.swift:486-491` |
| Genotype matrix, clear review | Cmd-Opt-R | `GenotypeResultDisplayState.swift:493-498` |
| Genotype matrix, add or edit comment | Cmd-Opt-M | `GenotypeResultDisplayState.swift:500-508` |
| Genotype matrix, dispatch of the four above | n/a | `GenotypeComparisonMatrixView.swift:3467-3477` |
| TaxTriage result, next sample | Cmd-] | `TaxTriageResultViewController.swift:1003-1011` |
| TaxTriage result, previous sample | Cmd-[ | `TaxTriageResultViewController.swift:1013-1020` |
| TaxTriage result, All Samples overview | Cmd-0 | `TaxTriageResultViewController.swift:1022-1027` |
| Sidebar context menu, New Folder | Cmd-Shift-N | `SidebarViewController+MenuDelegate.swift:42-43` and `271-272` |
| Sidebar context menu, Duplicate | Cmd-D | `SidebarViewController+MenuDelegate.swift:342-343` |
| Sidebar context menu, delete selection | Delete (backspace `\u{8}`) | `SidebarViewController+MenuDelegate.swift:362` |
| Workflow canvas, delete selection | Delete / Forward Delete | `WorkflowCanvasView.swift:1056-1057` |
| Workflow canvas, nudge selection one grid square | Arrow keys | `WorkflowCanvasView.swift:1058-1065` |
| Workflow canvas, select all nodes | Cmd-A | `WorkflowCanvasView.swift:1066-1071` |

## Gating recorded (greyed items whose shortcut is inert)

`AppDelegate.swift:1908-2060` is the single `validateMenuItem`. Named gates:
Check for Updates... (`1940-1942`), the three Content Text Size items
(`1944-1948`), Call Variants... (`1962-1965`), Go to Location... (`1978-1984`),
Go to Gene... (`1985-1990`), Reverse Complement / Translate / Copy Visible
Region as FASTA (`1991-2002`), Extract Visible Region... (`2004-2011`), the
four Zoom items (`2012-2022`), Cancel All Operations (`2023-2026`), Clear
Completed (`2027-2031`), New Window for Current Project (`2049-2054`).
Show Sidebar and Show Inspector retitle themselves via tags 1000 and 1001
(`1915-1930`) while keeping the same shortcut, which the chapter states.
Show as RNA carries tag 1002 and shows a checkmark (`1932-1938`).
The Genotyping submenu's tools are built disabled when their pack is not
installed (`ToolsMenuModel.swift:33-41`, `isEnabled` / `isInstallable`), and
none of those tool items carries a key equivalent.
Workflow Builder (Experimental)... is not merely greyed, it is omitted from
the menu unless `experimentalFeaturesEnabled` (`MainMenu.swift:728-737`).
Haplotype Definitions... is likewise conditionally added (`MainMenu.swift:708-716`)
and additionally hidden in validation (`AppDelegate.swift:1967-1971`).

## Rows dropped from the old chapter

Nine rows or claims were removed. Each is listed with why.

1. **Save Project, Cmd-S.** No such menu item and no such key equivalent
   exists anywhere in `MainMenu.swift`. The File menu carries **About
   Saving...** (`197-201`) instead. DRIFT false claim 4. The Workflow
   Builder chapter independently states there is no Cmd-S binding.
2. **"A reference of every keyboard shortcut."** Downgraded to "the
   keyboard shortcuts", per DRIFT false claim 1, because the chapter cannot
   promise completeness over every dialog's default button.
3. **"Hide Lungfish" and "Quit Lungfish".** Retitled to the full app name,
   which is what `appIdentity.fullName` interpolates (`MainMenu.swift:131, 152`)
   and what the manual's naming rule requires.
4. **"Operations Panel" in the View table.** The item is **Show Operations
   Panel** and lives in the Operations menu (`MainMenu.swift:867-872`), so
   it moved to its own Operations section. DRIFT changed claim 11.
5. **"AI Assistant Panel".** The title is **AI Assistant** (`MainMenu.swift:483`).
6. **"Import and tools" as a single grouping.** Split into File, Tools, and
   the app menu, which is where the three items actually live. DRIFT
   changed claim 27.
7. **"Go to Gene, Cmd-Option-G".** Rewritten as Cmd-Opt-G for consistency
   with the campaign's shortcut spelling. The binding itself is correct
   (`MainMenu.swift:652-654`).
8. **"Lungfish Help".** The title is **Lungfish Genome Explorer Help**
   (`MainMenu.swift:986`). DRIFT changed claim 44.
9. **"Cmd-? opens this user manual in the default browser, scoped to the
   chapter that matches the current viewport when possible."** Dropped. The
   claim of viewport-scoped chapter selection is not supported by anything
   found in source, and the chapter now says only that the item exists.

Two further old statements were rewritten rather than dropped. "Show as RNA
is Cmd-Shift-U" gained the parenthetical the menu title actually carries
(DRIFT changed claim 22), and the Customizing shortcuts paragraph gained the
ellipsis warning (DRIFT changed claim 48).

## Disagreements between a committed chapter and source

1. **Workflow Builder canvas, Cmd-plus and Cmd-minus.**
   `chapters/08-workflows/01-the-workflow-builder.md:132` says the toolbar's
   Zoom In and Zoom Out buttons have "tooltips [that] name Cmd-plus and
   Cmd-minus". That chapter is precise and correct about what it claims,
   because the tooltips do say so (`WorkflowBuilderViewController.swift:1112`
   `"Zoom in (Cmd +)"` and `:1122` `"Zoom out (Cmd -)"`). But **no key
   binding matches them.** `WorkflowCanvasView.keyDown` (`1054-1075`) handles
   only Delete, the arrows, and Cmd-A, and the canvas installs no
   `ZoomShortcutHandler`. The toolbar items carry actions but no
   `keyEquivalent` (`1112-1126`). The Workflow Builder is a separate window,
   so the View menu's own Cmd-plus routes to `ViewMenuActions.zoomIn`, which
   `AppDelegate.validateMenuItem:2012-2022` gates on an active sequence
   viewer and would therefore be disabled there. Reported as a defect below.
   The chapter as written says the tooltips advertise the chords and that no
   binding matches, rather than choosing between the two sources.
2. **Cmd-Opt-I versus Cmd-Option-I.** Committed chapters use both spellings
   for the same binding. `02-sequences/04`, `04-alignments/04`, and
   `05-variants/05` write Cmd-Option-I. `07-assembly/02` and
   `09-genotyping/04` write Cmd-Opt-I. Source is a single binding
   (`MainMenu.swift:450-452`). This chapter uses Cmd-Opt-I per the campaign
   brief. Flagged for the Phase 6 sweep, not resolved here.
3. **Cmd-Ctrl-S versus Ctrl-Cmd-S.** `01-foundations/06-the-lungfish-project.md`
   writes "Ctrl-Cmd-S" twice (lines 14 and 84). This chapter writes
   Cmd-Ctrl-S, matching the old appendix and the modifier-first-then-key
   convention. Same binding either way (`MainMenu.swift:440-442`). Flagged.

## App defects found

1. **Workflow Builder toolbar tooltips advertise unbound chords.** The Zoom
   In and Zoom Out toolbar items claim "(Cmd +)" and "(Cmd -)" in their
   tooltips (`WorkflowBuilderViewController.swift:1112, 1122`) but nothing
   binds those chords in the Workflow Builder window. Pressing them there
   does nothing, because the canvas keyDown does not handle them and the
   View menu's Zoom In is disabled without a sequence viewer. Either bind
   them on the canvas or remove them from the tooltips.
2. **No duplicate key equivalent in the menu bar.** Checked and clean, which
   is worth recording as a negative result. All 45 menu shortcuts are
   distinct on (modifier set, key equivalent).
3. **Cmd-0 is overloaded across contexts, deliberately but confusingly.**
   Zoom to Fit in the View menu (`MainMenu.swift:557`), All Samples in the
   TaxTriage result (`TaxTriageResultViewController.swift:1022`), zoom to
   root in the taxonomy sunburst (`TaxonomySunburstView.swift:679`), zoom to
   fit in miniBAM and MiniPileupView. These are in different responder
   contexts so they do not collide, but a reader who moves between windows
   will find Cmd-0 doing four different things. Not a bug, recorded because
   it is the most likely source of a support question about this appendix.
4. **`Cancel All Operations` ships with `isEnabled = false` set at build
   time** (`MainMenu.swift:890`) in addition to being validated dynamically
   (`AppDelegate.swift:2023-2026`). Harmless, but the static assignment is
   redundant and would mask the validation if the item ever lost its
   validator.

## Not verified

1. **No key was pressed.** Every row is read from source. A binding that a
   responder swallows before it reaches the intended handler would not show
   up in this record. The three most likely candidates are Cmd-C and Cmd-A
   in the sequence viewport versus the Edit menu's own bindings, Cmd-F in
   the genotype window versus the Edit menu's Find..., and Cmd-0 across the
   contexts listed above.
2. **DRIFT's two unverifiable rows.** The old chapter's claim that Cmd-? is
   scoped to the current viewport, and its claim about System Settings
   override timing ("on next launch"), were both unverifiable from source.
   The first was dropped. The second was kept in weakened form ("the next
   time LGE launches") because it describes macOS behaviour rather than LGE
   behaviour and is documented by Apple.
3. **Whether the sidebar context-menu chords fire as global bindings.** They
   are set on `NSMenuItem`s built in `menuNeedsUpdate`
   (`SidebarViewController+MenuDelegate.swift:42, 271, 342, 362`). A context
   menu's key equivalents are normally live only while the menu is open, and
   the chapter says so, but this was not tested.
4. **Whether Full Keyboard Access reaches every LGE control.** Asserted from
   the old chapter and from macOS documentation, not audited.
5. **The Content Text Size range.** `canPerformContentTextSizeAction`
   (`AppDelegate.swift:1944-1948`) gates the three items, presumably at the
   ends of the size range, but the sizes themselves were not read.

## Glossary terms added

Two, both alphabetical, both in the existing one-sentence-plus-See-also shape.

- **Key equivalent** with anchor `key-equivalent`, inserted in section K
  between "Keychain" and "Kraken 2".
- **Modifier key** with anchor `modifier-key`, inserted in section M between
  "mosdepth" and "mpileup".

Both are listed in the chapter's `glossary_refs` and linked on first use.

## Front matter

`brand_reviewed: false` and `lead_approved: false` left untouched.
`estimated_reading_min` raised from 4 to 9. The chapter roughly doubled in
length, and a lookup appendix is read in fragments, so 9 reflects a full
read-through of the prose plus a scan of the tables rather than a cover-to-
cover reading of every row.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/keyboard-shortcuts.md`
prints `no issues found`.

One lint finding was resolved rather than reworded away. The linter flagged
"Keyboard Navigation" as the banned word "navigate". That string is the
literal name of a System Settings pane, so it is now written in straight
double quotes, which STYLE.md exempts for exactly this case.
