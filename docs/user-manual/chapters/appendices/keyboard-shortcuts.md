---
title: Keyboard Shortcuts
chapter_id: appendices/keyboard-shortcuts
audience: bench-scientist
prereqs: []
estimated_reading_min: 24
task: Look up the keyboard shortcut for any common Lungfish Genome Explorer operation.
tags: [reference, shortcuts, productivity, macos]
tools: []
entry_points: []
shots: []
illustrations: []
glossary_refs: [key-equivalent, modifier-key, classifier, pipeline, chord, lens, plate-map, metadata, call, bundle, provenance, plugin-pack, viewport, gff, fasta, haplotype, miseq, variant-caller]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

A reference of the keyboard shortcuts available in Lungfish Genome Explorer (LGE) on macOS. A keyboard shortcut is a combination of keys that runs a command without going to the menu bar. macOS calls the letter or symbol at the end of that combination the [key equivalent](../../GLOSSARY.md#key-equivalent), and every Shortcut column in this appendix prints the modifiers first and that key equivalent last.

The keys you hold down first are [modifier keys](../../GLOSSARY.md#modifier-key), and LGE uses four of them. Cmd is the Command key beside the space bar. Opt is the Option key next to it, labelled Alt on some keyboards. Shift is the key you already use for capital letters. Ctrl is the Control key near the left end of the bottom row, sitting just to the right of fn.

Every row below comes from the shipping LGE build's own menu and view definitions rather than from an earlier edition of this manual. The menu bar stays the fastest confirmation you can run yourself, because macOS prints the shortcut on the right-hand side of every menu row that has one.

Most of these shortcuts are ones LGE inherits from macOS itself, which is why they will already feel familiar. Cmd-Q quits, Cmd-W closes the window, Cmd-Z undoes, Cmd-C copies, Cmd-V pastes, and Cmd-A selects all, exactly as they do in every other Mac application. The shortcuts that are LGE's own act on sequence, on the analysis panels, and on the scientific [viewport](../../GLOSSARY.md#viewport), which is the main display area in the middle of the window. Each table below says which is which.

## Before you press anything

Three facts decide whether a shortcut does anything at all, and reading them first will save you a puzzled minute later.

A shortcut acts on the window that has focus. Focus means the window or pane you clicked most recently, so clicking a sequence display and then pressing an arrow key moves that display rather than the sidebar beside it. Every table below states the window or pane that must have focus before its rows work.

A greyed menu item is disabled, and its shortcut does nothing until the item is enabled. Nothing happens and no message appears. LGE greys items out on purpose whenever the command has nothing to act on, so **Zoom In** is disabled until a sequence is on screen and **Cancel All Operations** is disabled until something is running.

Two parts of the Tools menu are gated further. A tool inside the Genotyping submenu is disabled, with (not enabled) after its name, until you switch it on in the Workflow Library, which [What Is MHC Genotyping](../09-genotyping/01-what-is-mhc-genotyping.md) walks through, and its [plugin pack](../../GLOSSARY.md#plugin-pack), meaning the themed group of analysis programs LGE downloads on demand, must be installed first. **Workflow Builder (Experimental)...** is not greyed out but hidden entirely, and it appears only after you turn on **Show Experimental Features** in Settings, under Advanced.

Your work is saved as you go. There is no Save command and no Cmd-S in LGE, because every change is written to the project folder the moment you make it. Nothing sits in memory waiting to be saved, and closing a window loses nothing.

## How a shortcut is written here

Each shortcut is written with the modifier keys first and the key equivalent last, joined by hyphens, so Cmd-Shift-P means hold Command and Shift together and then press P. You can press the modifiers in any order. All of them need to be down before the final key goes down.

Symbol keys are named by the key a US keyboard prints on them, so you never have to guess whether Shift is part of the combination. Cmd-comma is the comma key. Cmd-plus and Cmd-minus are the equals key and the hyphen key, pressed with Command and no Shift, because LGE accepts the unshifted key in both places. Cmd-right bracket and Cmd-left bracket are the `]` and `[` keys. Cmd-? needs Shift, so it is written Cmd-Shift-slash wherever it appears. An arrow key can also be the final key, as in Cmd-Shift-Right Arrow, and the underscore key works anywhere Cmd-minus does.

Menu titles appear in **bold** when the text names them, and the bold form is the exact title the app prints, ellipsis included. That matters in one place only, the Customizing shortcuts section at the end, where an exact match is what makes a remapping work.

Menu paths are written as words throughout, as in Settings, under Advanced, rather than with arrows.

## Lungfish Genome Explorer menu

The leftmost menu, named for the app itself, holds the commands that act on the whole application rather than on a project. These four work whenever LGE is the front application, whether or not a project is open.

| Action | Shortcut | Origin |
|---|---|---|
| Settings... | Cmd-comma | Standard macOS |
| Hide Lungfish Genome Explorer | Cmd-H | Standard macOS |
| Hide Others | Cmd-Opt-H | Standard macOS |
| Quit Lungfish Genome Explorer | Cmd-Q | Standard macOS |

The same menu also carries **About**, **Check for Updates...**, and **Show All**, and none of the three has a shortcut. **Check for Updates...** greys out when automatic updates are not set up for that copy of LGE.

## File menu

Project-level commands. A project in LGE is a folder on disk that holds your reads, your reference sequences, and your results together. All four rows need a project window open and in front, and pressing one with nothing open does nothing.

| Action | Shortcut | Origin |
|---|---|---|
| New Project | Cmd-N | Standard macOS |
| Open Project Folder... | Cmd-O | Standard macOS |
| Close | Cmd-W | Standard macOS |
| Import Center... | Cmd-Shift-I | LGE's own |

**Import Center...** opens the window for bringing files into the project you have open. The File menu explains the absence of Save in its own words under **About Saving...**, which has no shortcut of its own. The menu's other unshortcut items are **Open Recent**, the **Export** submenu with its six export commands, the **Provenance** submenu nested inside Export, and **Manage Project Storage...**. [Provenance](../../GLOSSARY.md#provenance) is the record LGE keeps of how each result was produced, down to the tool version and the exact command.

## Edit menu

Standard Mac editing. These six work in whatever text field, table, or viewport selection has focus, so click into the thing you mean to edit first.

| Action | Shortcut | Origin |
|---|---|---|
| Undo | Cmd-Z | Standard macOS |
| Redo | Cmd-Shift-Z | Standard macOS |
| Cut | Cmd-X | Standard macOS |
| Copy | Cmd-C | Standard macOS |
| Paste | Cmd-V | Standard macOS |
| Select All | Cmd-A | Standard macOS |

The Find submenu at the bottom of the Edit menu holds three more, all of them standard. **Find...** is Cmd-F, **Find Next** is Cmd-G, and **Find Previous** is Cmd-Shift-G. **Delete** sits just above Select All with no shortcut.

## View menu

The panels that frame the main viewport, plus the zoom commands. These need a project window in front. The sidebar down the left lists everything in the project, and the Inspector down the right shows details of whatever is selected. The Document Inspector is a separate window listing the [bundle's](../../GLOSSARY.md#bundle) own [metadata](../../GLOSSARY.md#metadata), meaning the descriptive fields that record what a data item is rather than the sequence data itself. A bundle is one data item in the project, stored as a folder that macOS shows as a single icon.

| Action | Shortcut | Origin |
|---|---|---|
| Show Sidebar | Ctrl-Cmd-S | Standard macOS |
| Show Inspector | Cmd-Opt-I | LGE's own |
| Focus Viewer | Cmd-Opt-F | LGE's own |
| Restore Side Panes | Ctrl-Cmd-Opt-F | LGE's own |
| Document Inspector | Cmd-Opt-D | LGE's own |
| AI Assistant | Cmd-Shift-A | LGE's own |
| Enter Full Screen | Ctrl-Cmd-F | Standard macOS |

Ctrl-Cmd-S means Control, Command, and S held together, and every hyphenated row here works the same way.

**Focus Viewer** hides both the sidebar and the Inspector so the viewport fills the window, and **Restore Side Panes** brings both back. The two are a pair, and "side panes" names the same sidebar and Inspector the rest of this appendix does. **AI Assistant** reveals the Inspector's Assistant tab, a chat tab that answers questions about the data you have open.

The Sidebar and Inspector rows change their own titles as you use them. When the panel is showing, the menu reads **Hide Sidebar** or **Hide Inspector** instead, and the same shortcut does the hiding. The shortcut never changes.

The four zoom commands act on the scientific viewport, meaning the sequence, alignment, or assembly display in the middle of the window, and they are greyed out whenever no such display is open.

| Action | Shortcut | Origin |
|---|---|---|
| Zoom In | Cmd-plus | LGE's own |
| Zoom Out | Cmd-minus | LGE's own |
| Zoom to Fit | Cmd-0 | LGE's own |
| Zoom Reset (10kb) | Cmd-1 | LGE's own |

**Zoom Reset (10kb)** sets the view to a 10,000 base window centred on where you are, which is a working scale for reading genes rather than whole chromosomes.

The **Content Text Size** submenu is a different thing entirely and is the answer when the app's own interface text is too small to read comfortably. It changes the size of LGE's labels, tables, and panel text across the whole application, and it leaves the scientific viewport's own zoom alone.

| Action | Shortcut | Origin |
|---|---|---|
| Content Text Size > Larger | Cmd-Opt-plus | LGE's own |
| Content Text Size > Smaller | Cmd-Opt-minus | LGE's own |
| Content Text Size > Default | Cmd-Opt-0 | LGE's own |

Adding Opt is what turns a viewport zoom command into a text size command.

Three more View items round the menu out. In a sequence view, **Show as RNA (U instead of T)** is Cmd-Shift-U, which redraws the sequence with uracil in place of thymine and puts a checkmark beside the menu row while it is on. In a taxonomy viewport, meaning the tree of organism names that a [classifier](../../GLOSSARY.md#classifier) produces, **Expand All** is Cmd-Shift-Right Arrow and **Collapse All** is Cmd-Shift-Left Arrow. A classifier is software that decides which organism each read came from. Both taxonomy shortcuts need the tree itself to have focus, so click a row in it first. With the tree focused, **Opt-Right Arrow** expands the selected taxonomy row recursively, meaning that row and everything beneath it, which is narrower than Expand All. **Reset View Settings to Defaults** sits near the bottom with no shortcut, followed by Enter Full Screen.

## Sequence menu

Commands that act on the sequence currently on screen. All six need a sequence viewer open and in front, and all six are greyed out when none is. **Copy Visible Region as FASTA** and **Extract Visible Region...** take the region the viewport is showing, or the range you have selected inside it if you have made one.

| Action | Shortcut | Origin |
|---|---|---|
| Reverse Complement... | Cmd-Shift-R | LGE's own |
| Translate... | Cmd-Shift-T | LGE's own |
| Go to Location... | Cmd-L | LGE's own |
| Go to Gene... | Cmd-Opt-G | LGE's own |
| Copy Visible Region as FASTA | Cmd-Shift-C | LGE's own |
| Extract Visible Region... | Cmd-Shift-E | LGE's own |

These are LGE's own bindings and they do not match what other sequence viewers use for the same commands.

**Go to Location...** accepts a plain coordinate such as `32000000`, or a range written as chromosome, colon, start, hyphen, end. Type `chr6:32000000-32100000` to land on the human MHC region, where `chr6` is the contig name your own file uses rather than a literal word.

**Go to Gene...** matches gene names from the annotation attached to whatever is open, which is the [GFF](../../GLOSSARY.md#gff) or GenBank record the bundle carries. GFF is a table of gene positions stored beside the sequence, and a GenBank record carries the same information inside one file. The command finds nothing when the open file has no gene annotation. It takes Cmd-Opt-G rather than Cmd-G because **Find Next** already uses Cmd-G, and two commands cannot share the same keys.

**Copy Visible Region as FASTA** puts [FASTA](../../GLOSSARY.md#fasta) text on the system clipboard, ready to paste anywhere. FASTA is the plain-text format that holds a sequence under a name line beginning with `>`. **Extract Visible Region...** opens a dialog and saves a new bundle into the project's `Extractions/` folder. **Add Annotation...** and **Find ORFs...**, which finds open reading frames, sit at the bottom of the menu with no shortcuts.

## Tools menu

This row works whenever a project window is in front.

| Action | Shortcut | Origin |
|---|---|---|
| Plugin Manager... | Cmd-Shift-B | LGE's own |

The Plugin Manager is where you install and remove plugin packs, the add-on tool groups this appendix has already named. B is arbitrary here rather than a mnemonic, so treat it as the one exception to the Cmd-Shift-letter pattern described later.

Nothing else in the Tools menu has a shortcut, which is deliberate, because the menu holds one submenu per analysis category and dozens of tools inside those submenus. **Call Variants...** runs a [variant caller](../../GLOSSARY.md#variant-caller), **Workflow Library...** lists saved analysis chains, and **Haplotype Definitions...** manages the named allele combinations a genotyping run reports against. None of the three has a shortcut, and neither do the three items of the **Search Online Databases** submenu or any individual tool. **Workflow Builder (Experimental)...** has no shortcut either, and as noted above it is hidden until experimental features are on.

## Operations menu

This row works whenever a project window is in front.

| Action | Shortcut | Origin |
|---|---|---|
| Show Operations Panel | Cmd-Shift-P | LGE's own |

The Operations panel is the window that lists every [pipeline](../../GLOSSARY.md#pipeline) LGE is running or has finished. A pipeline is one analysis run as a chain of steps, so one row there is one thing you started. **Clear Completed** and **Cancel All Operations** sit below it without shortcuts, and **Cancel All Operations** stays greyed out until something cancellable is actually running.

## Window menu

Both rows act on the front window.

| Action | Shortcut | Origin |
|---|---|---|
| Minimize | Cmd-M | Standard macOS |
| New Window for Current Project | Cmd-Opt-N | LGE's own |

**New Window for Current Project** opens a second window onto the same project so you can keep two views side by side, and it is greyed out until a project is open. **Zoom** and **Bring All to Front** have no shortcuts.

## Help menu

This row works whenever LGE is the front application.

| Action | Shortcut | Origin |
|---|---|---|
| Lungfish Genome Explorer Help | Cmd-Shift-slash (Cmd-?) | Standard macOS |

Press Command, Shift, and the slash key together, which is what a question mark takes on a US keyboard. The other Help items open documents rather than commands and carry no shortcuts. They are **Getting Started**, **VCF Variants Guide**, **AI Assistant Guide**, **Documentation**, **Release Notes**, and **Report an Issue...**.

## Inside the sequence viewport

Click into the sequence display itself before pressing any of these, because they reach the display only while it has focus.

The left and right arrow keys move the view sideways by 100 bases each press, a fixed step that does not change with the zoom level. The up and down arrows zoom in and out rather than scrolling, which is the opposite of what most document windows do and is worth a moment to get used to. Cmd-C copies the current selection and Cmd-A selects everything, the same thing the Edit menu's own Copy and Select All do from here.

The Escape key does one of two things, decided by whether reads are still loading. While reads are loading, Escape cancels that load, which is the way out of a region carrying very many reads that is taking a long time. When nothing is loading, Escape clears the current selection instead.

The coordinate ruler above the sequence takes Cmd-0 for zoom to fit and Cmd-1 for the 10 kilobase reset, matching the View menu.

## Inside the alignment viewport

The compact read viewer that appears inside a classifier result window takes Cmd-plus, Cmd-minus, and Cmd-0 for zoom in, zoom out, and zoom to fit. Click into that viewer first. It offers the same three commands on a right-click menu, so you can see them without remembering them, and it accepts the equals key for plus and the underscore or hyphen key for minus.

## Inside the MSA viewport

A multiple sequence alignment, meaning several sequences stacked so that matching positions line up in columns, takes Cmd-C to copy the selection and Cmd-A to select the whole alignment once you have clicked into it. The arrow keys move the selection one position at a time, and holding Shift while pressing them extends the selection rather than moving it. On a trackpad, pinching zooms the alignment.

## Inside the genotype result window

The genotype viewport shows the alleles LGE [called](../../GLOSSARY.md#call) for each sample in a [plate](../../GLOSSARY.md#plate-map), where called means the app's best-guess identification from the read evidence and a plate is the grid of samples that came off one sequencing run. This window carries six shortcuts of its own, listed together below, and they reach it only while the genotype window is in front.

| Action | Shortcut | Origin |
|---|---|---|
| Focus the quick filter search field | Cmd-F | LGE's own |
| Clear the quick filter search field | Escape | LGE's own |
| Mark the selected sample reviewed | Cmd-R | LGE's own |
| Mark the selected sample confirmed | Cmd-K | LGE's own |
| Flag the selected sample as needing review | Cmd-Shift-F | LGE's own |
| Open the Sample Detail sheet | Cmd-Shift-O | LGE's own |

Cmd-F is taken over here for the quick filter rather than opening Find, which is the one place in LGE where that key does something other than what the Edit menu does. Escape clears the quick filter field when it holds text.

Reviewed and confirmed are two steps of the same check. Reviewed means you have looked at the sample, and confirmed means you agree with the call LGE made. The four review commands act on whichever sample is selected. They work only when the window is showing its Review [lens](../../GLOSSARY.md#lens), meaning the tab that presents one sample at a time for checking, or when a call is selected in a [haplotyped](../../GLOSSARY.md#haplotype) [MiSeq](../../GLOSSARY.md#miseq) result, meaning a short-read Illumina run whose allele calls have been grouped into inherited blocks. [Reading the Genotype Comparison](../09-genotyping/03-reading-the-genotype-comparison.md) covers the lenses in full. On any other result the four do nothing.

The comparison matrix inside that same window takes four more, all of them holding Cmd and Opt together. Cmd-Opt-P marks the selected cell a false positive, Cmd-Opt-N marks it a false negative, Cmd-Opt-R clears the review mark, and Cmd-Opt-M adds or edits a comment on the selection. Each mark is an annotation stored beside the result rather than a change to the result itself, and Cmd-Opt-R removes one. These four come from the matrix's right-click menu, so the menu itself is the reminder.

## Inside a classifier result window

The TaxTriage result window, TaxTriage being one of LGE's classifiers, switches between samples from the keyboard while that window is in front. It does so only when the run holds more than one sample. Cmd-right bracket moves to the next sample, Cmd-left bracket moves to the previous one, and Cmd-0 returns to the All Samples overview. Those two bracket keys are `]` and `[`.

The taxonomy sunburst is the circular chart of nested organism groups in the same window, with the broadest group at the centre and each ring outward splitting into narrower ones. Escape moves outward one ring toward that centre, and Cmd-0 returns to the centre in one press.

## Inside the sidebar

Right-clicking an item in the sidebar opens a context menu, and three of its commands print shortcuts. **New Folder** is Cmd-Shift-N, **Duplicate** is Cmd-D, and the delete command, whose title changes to name whatever you selected, is the Delete key on its own. These three work only while the right-click menu is showing, rather than any time an item is selected.

Delete removes the item from the project and moves its files to the Trash, and LGE asks you to confirm before it does. Recovering the item afterwards means retrieving it from the Trash yourself.

## Inside the Workflow Builder

The Workflow Builder is where you draw an analysis chain as connected boxes, so that a series of steps you would otherwise start one at a time can be saved and rerun as one. Its canvas takes the arrow keys to nudge a selected box one grid square at a time and Cmd-A to select every box, once the canvas has focus. The Delete key removes the selection, and Forward Delete does the same.

> **Known defect.** The toolbar's Zoom In and Zoom Out buttons carry tooltips advertising Cmd-plus and Cmd-minus, but no shortcut matches those tooltips in this release. Click the two buttons instead. No other tooltip in the app is affected.

## What LGE does not bind

Four shortcuts a user of another sequence viewer will reach for do not exist here, and knowing that up front is quicker than hunting for them.

- **Cmd-S** does nothing, because LGE saves every change as you make it.
- **Cmd-F inside the genotype window** focuses the quick filter rather than opening Find.
- **The arrow keys inside a viewport** zoom and pan the display rather than scrolling it.
- **Zoom to selection, annotate, and BLAST** have no shortcuts at all. Reach them from the menu bar or a right-click menu.

Every one of the 45 menu-bar shortcuts was checked against the others for collisions, and no two of them share the same combination.

## Mouse and trackpad

Shortcuts are not the only way to drive LGE. Scrolling moves the viewport along the sequence, pinching on a trackpad zooms the MSA viewport, and right-clicking almost anything in the sidebar or a result table opens a context menu of the operations that apply to it. When a shortcut slips your mind, the menu bar prints it, and a context menu prints the ones that belong to it.

## Memorizing combinations

A few patterns repeat, and knowing them beats memorizing every row one at a time. This section uses combination and [chord](../../GLOSSARY.md#chord) for the same thing, a set of keys pressed together.

Cmd-Shift-letter usually opens or toggles a panel, which is where **Show Operations Panel**, **AI Assistant**, **Plugin Manager...**, and **Import Center...** come from. For the Sequence menu commands, Cmd-Shift-letter performs the action on the visible region instead, which covers Extract, Copy, Translate, and Reverse Complement. Cmd-Opt-letter targets the inspectors and a few window-level commands, which is **Show Inspector**, **Document Inspector**, **Focus Viewer**, **Go to Gene...**, and **New Window for Current Project**.

The Sidebar breaks the first pattern. It toggles with Ctrl-Cmd-S rather than Cmd-Shift-S, because Control is what the macOS standard uses for that particular panel.

## Where Escape does something

Escape carries four different jobs across the app, each in its own window.

| Where | What Escape does |
|---|---|
| Sequence viewport, reads loading | Cancels the read load |
| Sequence viewport, nothing loading | Clears the current selection |
| Genotype result window | Clears the quick filter search field |
| Taxonomy sunburst | Steps outward one ring toward the centre |

## Customizing shortcuts

Any LGE menu item can be remapped from System Settings, which is a macOS feature rather than an LGE one and works the same way for every application. Open System Settings, click Keyboard, then Keyboard Shortcuts, then App Shortcuts. Click the plus button and choose Lungfish Genome Explorer from the application list. A preview build appears under its own name, such as Lungfish Preview, so pick the name printed in that copy's own menu bar, and use Other to browse for the app when it is not listed.

Type the menu title into the Menu Title field exactly, including any trailing ellipsis. `Reverse Complement...` and `Translate...` both end in a single ellipsis character rather than three periods, and an entry with three periods will not match the menu item. Type an ellipsis with Opt-semicolon on a US keyboard, or copy the title straight from the menu. Click into the Keyboard Shortcut field, press the new combination, then click Add. Quit LGE with Cmd-Q and reopen it for the override to take effect. Deleting the entry from the same panel restores the built-in shortcut.

## Accessibility

VoiceOver, the screen reader built into macOS, reads every LGE menu item and announces its shortcut along with it. Turn VoiceOver on with Cmd-F5 first, since none of its own keys do anything while it is off. Ctrl-Opt-M then moves VoiceOver into the menu bar so you can hear the whole tree.

Full Keyboard Access lets you reach LGE's controls without a pointer, with Tab moving between regions and Space activating whatever has focus. Turn it on in System Settings, under Keyboard, where the setting is labelled Full Keyboard Access.

If the difficulty is that the text is too small rather than that the mouse is hard to use, the View menu's **Content Text Size** submenu is the direct answer. Cmd-Opt-plus makes LGE's own interface text larger everywhere, Cmd-Opt-minus makes it smaller, and Cmd-Opt-0 returns it to the size it shipped with. This is separate from the macOS-wide display scaling in System Settings and separate again from the viewport zoom commands.

## Index of every shortcut

Sorted by the final key. Each row names where the shortcut works, because several combinations mean different things in different windows.

| Shortcut | Action | Where |
|---|---|---|
| Cmd-0 | Zoom to Fit | View menu, sequence viewport, coordinate ruler |
| Cmd-0 | Zoom to fit | Alignment viewport |
| Cmd-0 | All Samples overview | TaxTriage result window |
| Cmd-0 | Zoom to the centre | Taxonomy sunburst |
| Cmd-Opt-0 | Content Text Size, Default | View menu |
| Cmd-1 | Zoom Reset (10kb) | View menu, coordinate ruler |
| Cmd-A | Select All | Edit menu, sequence viewport, MSA viewport |
| Cmd-A | Select every box | Workflow Builder canvas |
| Cmd-Shift-A | AI Assistant | View menu |
| Cmd-Shift-B | Plugin Manager... | Tools menu |
| Cmd-C | Copy | Edit menu, sequence viewport, MSA viewport |
| Cmd-Shift-C | Copy Visible Region as FASTA | Sequence menu |
| Cmd-D | Duplicate | Sidebar right-click menu |
| Cmd-Opt-D | Document Inspector | View menu |
| Delete | Delete the selected item | Sidebar right-click menu |
| Delete | Delete the selection | Workflow Builder canvas |
| Cmd-Shift-E | Extract Visible Region... | Sequence menu |
| Escape | Cancel read load or clear selection | Sequence viewport |
| Escape | Clear the quick filter field | Genotype result window |
| Escape | Step outward one ring | Taxonomy sunburst |
| Cmd-F | Find... | Edit menu |
| Cmd-F | Focus the quick filter field | Genotype result window |
| Cmd-Opt-F | Focus Viewer | View menu |
| Cmd-Shift-F | Flag the sample as needing review | Genotype result window |
| Ctrl-Cmd-F | Enter Full Screen | View menu |
| Ctrl-Cmd-Opt-F | Restore Side Panes | View menu |
| Cmd-G | Find Next | Edit menu |
| Cmd-Shift-G | Find Previous | Edit menu |
| Cmd-Opt-G | Go to Gene... | Sequence menu |
| Cmd-H | Hide Lungfish Genome Explorer | Application menu |
| Cmd-Opt-H | Hide Others | Application menu |
| Cmd-Opt-I | Show Inspector | View menu |
| Cmd-Shift-I | Import Center... | File menu |
| Cmd-K | Mark the sample confirmed | Genotype result window |
| Cmd-L | Go to Location... | Sequence menu |
| Cmd-M | Minimize | Window menu |
| Cmd-Opt-M | Add or edit a comment | Genotype comparison matrix |
| Cmd-N | New Project | File menu |
| Cmd-Opt-N | New Window for Current Project | Window menu |
| Cmd-Opt-N | Mark the cell a false negative | Genotype comparison matrix |
| Cmd-Shift-N | New Folder | Sidebar right-click menu |
| Cmd-O | Open Project Folder... | File menu |
| Cmd-Shift-O | Open the Sample Detail sheet | Genotype result window |
| Cmd-Opt-P | Mark the cell a false positive | Genotype comparison matrix |
| Cmd-Shift-P | Show Operations Panel | Operations menu |
| Cmd-Q | Quit Lungfish Genome Explorer | Application menu |
| Cmd-R | Mark the sample reviewed | Genotype result window |
| Cmd-Opt-R | Clear the review mark | Genotype comparison matrix |
| Cmd-Shift-R | Reverse Complement... | Sequence menu |
| Ctrl-Cmd-S | Show Sidebar | View menu |
| Cmd-Shift-T | Translate... | Sequence menu |
| Cmd-Shift-U | Show as RNA (U instead of T) | View menu |
| Cmd-V | Paste | Edit menu |
| Cmd-W | Close | File menu |
| Cmd-X | Cut | Edit menu |
| Cmd-Z | Undo | Edit menu |
| Cmd-Shift-Z | Redo | Edit menu |
| Cmd-comma | Settings... | Application menu |
| Cmd-plus | Zoom In | View menu, alignment viewport |
| Cmd-Opt-plus | Content Text Size, Larger | View menu |
| Cmd-minus | Zoom Out | View menu, alignment viewport |
| Cmd-Opt-minus | Content Text Size, Smaller | View menu |
| Cmd-left bracket | Previous sample | TaxTriage result window |
| Cmd-right bracket | Next sample | TaxTriage result window |
| Cmd-Shift-slash | Lungfish Genome Explorer Help | Help menu |
| Arrow keys | Pan sideways, zoom up and down | Sequence viewport |
| Arrow keys | Move the selection, Shift extends it | MSA viewport |
| Arrow keys | Nudge the selected box | Workflow Builder canvas |
| Opt-Right Arrow | Expand the selected row recursively | Taxonomy viewport |
| Cmd-Shift-Right Arrow | Expand All | Taxonomy viewport |
| Cmd-Shift-Left Arrow | Collapse All | Taxonomy viewport |

## Next

See [CLI Reference](cli-reference.md), which is for people who type commands in a terminal window instead of clicking, or [Troubleshooting](troubleshooting.md) when a shortcut does not appear to work.
