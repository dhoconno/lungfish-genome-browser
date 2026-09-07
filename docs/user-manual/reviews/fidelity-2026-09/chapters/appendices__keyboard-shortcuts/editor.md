# Editor pass, appendices/keyboard-shortcuts.md

Date: 2026-09-07. Role: brand copy editor. Chapter kept its reference-appendix
shape. `brand_reviewed` and `lead_approved` both remain `false`.

## 1. False claims fixed

All four, in the reviewer's own wording.

1. **Delete's position.** Was "Delete sits between Select All and the Find
   submenu". Now "**Delete** sits just above Select All with no shortcut."
   Confirmed at `MainMenu.swift:382-392`.
2. **Reset View Settings to Defaults.** Was "sits at the bottom". Now "sits
   near the bottom with no shortcut, followed by Enter Full Screen."
   Confirmed at `MainMenu.swift:597-613`.
3. **Show All.** The application-menu sentence now reads "The same menu also
   carries **About**, **Check for Updates...**, and **Show All**, and none of
   the three has a shortcut." Confirmed at `MainMenu.swift:143-147`.
4. **Opt-Right Arrow.** Added to the View menu's taxonomy paragraph, in the
   reviewer's sense: "**Opt-Right Arrow** expands the selected taxonomy row
   recursively, meaning that row and everything beneath it, which is narrower
   than Expand All." It also carries an index row. Confirmed at
   `TaxonomyTableView.swift:1511-1514`.

## 2. Unverifiable claims hedged or dropped

| Claim | Action |
|---|---|
| Settings > Advanced toggle title | Hedged. Now "you turn on **Show Experimental Features** in Settings, under Advanced", which names the pane without asserting a control title, and it drops the arrow path style the readers objected to. |
| Haplotype Definitions... presented as always present | Hedged. The sentence no longer implies permanence. It now names what the item does and says only that it has no shortcut, alongside the other two Tools items. |
| Sidebar context-menu chords as menu-scoped | Kept, reworded plainly per readers. "These three work only while the right-click menu is showing, rather than any time an item is selected." No stronger claim than before. |
| Pinch zoom reaching the sequence and alignment viewports | Narrowed. Mouse and trackpad now says only "pinching on a trackpad zooms the MSA viewport", which is the one confirmed case. |
| "Full Keyboard Access ... lets you reach every control" | Softened to "lets you reach LGE's controls without a pointer", per the reviewer's note. |

The macOS remapping and override-timing claims stayed, both being Apple
behaviour and both already weakened by the author.

## 3. Project manager rulings

**(a) Shortcut spelling, per the CONSISTENCY ruling.** Opt everywhere, never
Option (chapter was already clean). Control now comes first, so Show Sidebar
is **Ctrl-Cmd-S**, Restore Side Panes is **Ctrl-Cmd-Opt-F**, and Enter Full
Screen is **Ctrl-Cmd-F**. All three changed from the Cmd-first spelling the
author used, in the table rows, the Memorizing section, and the index. Symbol
keys are now named by the printed key in a new paragraph under How a shortcut
is written here, which covers comma, plus and equals, minus and hyphen and
underscore, and the two bracket keys as `]` and `[`. Cmd-? is written
**Cmd-Shift-slash (Cmd-?)** in the Help table and Cmd-Shift-slash in the
index, glossed in the following sentence as Command, Shift, and the slash key.

**(b) "Before you press anything".** New section, placed after What it is and
before every table. It states the focus rule and defines focus as the window
or pane you clicked most recently, states that a greyed item's shortcut does
nothing until the item is enabled, and states both Tools gates, the Genotyping
submenu's plugin pack and the hidden Workflow Builder item. Eight tables now
carry a window-state sentence: application menu (front application),
File (project window open and in front), Edit (whichever field or viewport has
focus), View panels and View zoom (project window in front), Sequence (a
sequence viewer open and in front), Tools, Operations, Window (front window),
Help, genotype result window (that window in front). The three inside-viewport
sections say to click into the display first.

**(c) Genotype count and gating.** Escape is now a table row, so the stated
six matches a six-row table. The gating clause glosses lens ("the tab that
presents one sample at a time for checking"), haplotyped ("whose allele calls
have been grouped into inherited blocks"), and MiSeq ("a short-read Illumina
run"), and points at [Reading the Genotype
Comparison](../09-genotyping/03-reading-the-genotype-comparison.md) by title.

**(d) Alphabetical index.** New closing section, "Index of every shortcut", a
single table of 72 rows sorted by the final key, with a Where column because
several combinations mean different things in different windows. Built only
from rows already in the chapter and sourced by `author.md`. Two macOS-only
VoiceOver keys were deliberately left out of the index and kept in the
Accessibility prose, since the author's record does not source them as LGE
bindings.

**(e) Geneious differences.** New section, "What LGE does not bind", naming
Cmd-S, Cmd-F inside the genotype window, the arrow keys zooming rather than
scrolling, and the absence of zoom-to-selection, annotate, and BLAST
shortcuts. It also carries the collision result the reviewer confirmed, that
no two of the 45 menu shortcuts share a combination.

**(f) Ellipsis.** The Customizing section now says to type one with
Opt-semicolon on a US keyboard, or to copy the title straight from the menu.

**(g) Plain words.** "Produces silence" is now "Nothing happens and no
message appears." All three uses of "dead" are now "disabled". "Key binding"
in the Workflow Builder note is now "shortcut".

**(h) Glosses.** Glossed at first use in one clause each: classifier,
pipeline, bundle, provenance, plugin pack, chord, called, lens, plate, GFF,
metadata, plus FASTA, viewport, ORF, haplotype, MiSeq, and variant caller.
"Pack" and "plugin" are now the single term plugin pack throughout, which
resolves the reader row about the chapter using two names for one thing.

**(i) Citations.** No row cites source in the chapter body, and no shortcut
was added that `author.md` does not source. The two VoiceOver keys are
described as macOS behaviour in prose only.

## 4. Reader rows

**Consensus section, 31 rows. All 31 applied.** Key equivalent now earns its
definition by naming what the Shortcut column prints. The source-code framing
is gone. Software pack, provenance, bundle, metadata, pipeline, classifier,
chord, called, plate, lens, and deep region are glossed. The equals-and-plus
explanation is rewritten as a plain instruction. Focus Viewer and Restore Side
Panes are described as a pair. AI Assistant, Zoom Reset (10kb), and the
Go to Location syntax get concrete descriptions, the last with the worked
example `chr6:32000000-32100000`. The programmer's "shared code behind these"
is gone. The genotype count matches its table. The false positive and false
negative marks are stated as annotations that Cmd-Opt-R removes. Bracket keys
show as `]` and `[`. VoiceOver now says to turn it on with Cmd-F5 first.
Control is described as near the left end beside fn. "Stronger still" is now
"not greyed out but hidden entirely". "Global bindings" is gone. The
forty-five count moved into the collision sentence, where it is checkable. The
ellipsis keystroke is given. The Workflow Builder defect is a marked blockquote
note saying to click the buttons. Full Keyboard Access is named once. Arrow
keys as final keys are covered in the writing-style section, and the taxonomy
tree focus requirement is stated. The focus rule moved to the new opening
section. Sidebar delete now says what it removes and that LGE confirms first.

**Other merged rows, 56. Applied 52, skipped 4.**

Applied, in brief: consistent path style as words; the split "order does not
matter" sentence; bold as the exact-title form; the plain-language update-feed
sentence; the project-open precondition on File and View; the GFF and GenBank
gloss with the no-annotation caveat; the FASTA gloss; Content Text Size moved
from prose into its own table; the fixed 100-base step stated; B named as
arbitrary; the sunburst centre described; the Keyboard Shortcut field named;
"verb" replaced with "the Sequence menu commands"; saving led with in the new
opening section; Cmd-? spelled out; Cmd-comma as the comma key; Import Center
described; classifier glossed at both uses; viewport glossed in What it is;
one term for the add-on tools; TaxTriage glossed; the Preview app-name case
covered; a prerequisites-shaped opening section added; the Extractions folder
named; ORF expanded; haplotype glossed; "key binding" replaced; quit-and-reopen
stated; the alphabetical index added; "the authority" and "the reader"
rewritten; "produces silence" and "dead" replaced; "type" to "text"; the Opt
rule stated without the positional reference; the two Extract and Copy commands
named; "collide" replaced; plugin and the Plugin Manager described; "pan"
stated plainly; the Escape rule stated before its two cases; the design
sentence about plate work cut; reviewed against confirmed distinguished; the
Workflow Builder purpose sentence added; the Sidebar exception named to the
specific pattern; the CLI Reference described for a non-terminal reader;
Ctrl-Cmd-S spelled out as three keys held together; the Sequence menu bindings
flagged as LGE's own; the collision check stated for all bindings; the three
Tools items glossed; up and down flagged as zoom rather than scroll; Cmd-F
flagged as taken over in the genotype window; the Escape behaviours collected
in their own table; and the Geneious-absences section.

Skipped, with reasons.

1. **"Drop the term key equivalent."** Skipped the drop half of the row and
   took the alternative the same row offers, making the term earn its place,
   because it is a declared `glossary_refs` entry and the chapter's own
   spelling rule is built on it.
2. **"Say the rows were checked against the shipping app build."** Applied as
   worded, but the row's implicit invitation to claim behavioural testing was
   skipped. Neither the author nor the reviewer pressed a key, so the chapter
   says the rows were checked against the shipping build and no more.
3. **"Note that these are LGE's own bindings and do not match other
   viewers"** was applied for the Sequence menu, but the same reader's request
   to compare LGE against a named competitor product throughout was skipped.
   Naming another product in every section is outside the appendix's shape and
   the brand voice, and ruling (e) already collects the differences in one
   place.
4. **"Collect the Escape behaviours in one small table"** was applied, but the
   adjacent suggestion to move the Workflow Builder defect out of the chapter
   was skipped. The reviewer confirmed the defect and the chapter's own
   accuracy rule requires stating it where a reader meets the buttons.

## 5. Glossary changes

Seven entries added to `docs/user-manual/GLOSSARY.md`, each in the existing
one-sentence-plus-See-also shape, each in alphabetical position.

| Term | Anchor | Placed |
|---|---|---|
| Call | `call` | C, before Capped database |
| Chord | `chord` | C, before Circular consensus sequencing |
| Classifier | `classifier` | C, before Clumpify |
| Lens | `lens` | L, before Library prep |
| Metadata | `metadata` | M, before Metagenomics |
| Pipeline | `pipeline` | P, before Pileup |
| Plate map | `plate-map` | P, before Ploidy |

`glossary_refs` now reads `[key-equivalent, modifier-key, classifier,
pipeline, chord, lens, plate-map, metadata, call, bundle, provenance,
plugin-pack, viewport, gff, fasta, haplotype, miseq, variant-caller]`. All
eighteen anchors were confirmed to resolve. Bundle, provenance, plugin pack,
GFF, FASTA, viewport, haplotype, MiSeq, and variant-caller already existed and
were linked rather than duplicated.

## 6. Brand and style

No em dashes, no semicolons, no colons inside a sentence. No banned word from
`ai-tells-words.txt`. Sentences held near 20 words. "Lungfish Genome Explorer
(LGE)" at first mention and LGE after. Bullet lists stay inside the five-bullet
cap, and no H2 carries more than one list. `estimated_reading_min` raised from
9 to 11 for the two new sections and the index.

## 7. Lint

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/keyboard-shortcuts.md: no issues found
```

## 8. Routed to the Documentation Lead

The Ctrl-first spelling adopted here settles the reviewer's open question
against the author's Cmd-first preference, on the CONSISTENCY ruling's
authority. Phase 6 therefore has nothing to sweep for Show Sidebar or Restore
Side Panes, since `01-foundations/06-the-lungfish-project.md` already writes
Ctrl-Cmd-S and Ctrl-Cmd-Opt-F. The eight Cmd-Option occurrences across seven
chapters still need the Cmd-Opt sweep.
