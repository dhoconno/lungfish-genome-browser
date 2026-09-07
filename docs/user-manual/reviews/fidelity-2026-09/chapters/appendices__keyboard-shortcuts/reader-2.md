# Reader 2 report, Keyboard Shortcuts

Persona: senior, two years of wet-lab pipetting, library prep and PCR, no data
analysis, never opened a terminal. Reading this as a student looking up one
shortcut in a hurry.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "the [key equivalent](../../GLOSSARY.md#key-equivalent)" | The chapter defines "key equivalent" and then never uses the phrase again. I read the paragraph twice trying to work out what I was supposed to do with the word. | Drop the term and just say the last key in the combination. |
| What it is, "Ctrl is the Control key at the far left of the bottom row" | On my laptop the far left of the bottom row is the fn key and Control is second. I hunted for the wrong key. | Say Control is labelled "control" and sits near the bottom left. |
| What it is, "read out of the source code that builds LGE's menus" | I do not know what source code is in this context and cannot check it, so this told me the table might be wrong without telling me what to do. | Say the table was checked against the app build, and the menu bar is the live check. |
| What it is, "a tool inside the Tools menu's Genotyping submenu is dead until its software pack is installed" | "Software pack" appears here for the first and only time. I do not know what one is, where it comes from, or how to install it. | Name the thing as a plugin and point to the Plugin Manager. |
| What it is, "**Workflow Builder (Experimental)...** item is stronger still" | "Stronger still" describing a menu item stopped me. I reread it to see that it means "more hidden", not "more powerful". | Say the item is not greyed out but hidden entirely. |
| How a shortcut is written here, "macOS treats the equals key and the plus key as the same physical key here" | This says both that I do not need Shift and that plus and equals are the same key, which felt contradictory on a keyboard where plus is printed above equals. | Say press Command and the equals key, no Shift needed. |
| How a shortcut is written here, "Menu titles are quoted exactly as the app prints them, ellipsis included" | "Ellipsis" is not glossed. I had to guess it means the three dots. | Say the three trailing dots. |
| File menu, "A project in LGE is a folder on disk" | Good gloss, but nowhere in this appendix is there a hint about which of these shortcuts need a project open. I pressed Cmd-Shift-I with nothing open and nothing happened. | Add that File and View shortcuts need a project window open. |
| File menu, "the **Provenance** submenu nested inside Export" | "Provenance" is used with no explanation. I have no idea what it exports. | Gloss provenance as the record of how a result was produced. |
| View menu, "the Document Inspector is a separate window of manifest-level metadata for the bundle you have open" | Three unexplained words in one clause, manifest, metadata, bundle. This was the sentence I reread the most. | Split it and gloss bundle as one data item in the project. |
| View menu, "Restore Side Panes | Cmd-Ctrl-Opt-F" | Four keys with no description of what restoring side panes does or when it is useful. I could press it but not predict the result. | Add one line saying it brings back the sidebar and Inspector together. |
| View menu, "AI Assistant | Cmd-Shift-A" | Listed with no description at all, unlike every other LGE row nearby. | Add a phrase saying it opens the assistant panel. |
| View menu, "Zoom Reset (10kb) | Cmd-1" | "10kb" is not expanded here, only later as "10 kilobase reset". As a bench person I read kb as kilobase but I still cannot tell whether this zooms so 10 kb fills the window. | Say it sets the view width to ten thousand bases. |
| View menu, "**Expand All** is Cmd-Shift-Right Arrow" | I could not tell whether the taxonomy viewport must be clicked into first, unlike the sequence viewport section which says to click in. | Say the taxonomy tree must have focus. |
| Sequence menu, "**Go to Location...** accepts a plain coordinate or a `chromosome:start-end` range" | The code formatting and the placeholder words are the closest thing to a terminal in the chapter and no example is given. I did not know what to actually type. | Give one worked example such as chr6:32000000-32100000. |
| Sequence menu, "**Copy Visible Region as FASTA**" | FASTA is not glossed anywhere in the chapter. I have seen the word on files but could not say what would land on my clipboard. | Gloss FASTA as plain text sequence with a header line. |
| Sequence menu, "**Extract Visible Region...** opens a dialog and writes a new bundle into the project" | Bundle again, still unglossed, and I could not tell where in the project it lands. | Say it saves a new item into the project's Extractions folder. |
| Sequence menu, "**Add Annotation...** and **Find ORFs...**" | ORF is an abbreviation I half remember from genetics and it is never expanded. | Expand as open reading frames on first use. |
| Tools menu, "**Plugin Manager... | Cmd-Shift-B**" | B for Plugin Manager has no mnemonic, and the Memorizing chords section later calls it a panel toggle, which did not help me remember it either. | Note it is the one panel shortcut whose letter does not match its name. |
| Operations menu, "the window that lists every pipeline LGE is running" | "Pipeline" is used as a noun with no gloss. In my lab that word means something vaguer. | Gloss pipeline as one analysis job LGE runs for you. |
| Help menu, "Lungfish Genome Explorer Help | Cmd-? | Standard macOS" | Cmd-? does not say whether Shift is needed, and question mark is a shifted key on my keyboard. This is exactly the ambiguity the plus and minus paragraph was careful about. | Say press Command and Shift and the slash key. |
| Inside the sequence viewport, "Once you have clicked into the sequence display itself" | This is the only place that explains focus, and it arrives after eight menu sections that quietly assumed it. | Move the focus explanation up into How a shortcut is written here. |
| Inside the sequence viewport, "Left and right pan the view by a hundred bases at a time" | I could not tell whether this is a fixed hundred bases or a hundred bases of the current zoom. At a whole-chromosome zoom a hundred bases would be invisible. | Say whether the step scales with the zoom level. |
| Inside the alignment viewport, "The compact read viewer that appears inside a classifier result window" | "Classifier" is used before it is explained. The taxonomy line later half explains it. | Gloss classifier at first use as the tool that assigns reads to organisms. |
| Inside the alignment viewport, "The shared code behind these accepts the equals key" | "Shared code" is an implementation detail I cannot see or check, and it made me wonder whether this viewport differs from the others. | Say the equals and underscore keys work here too. |
| Inside the genotype result window, "carries six shortcuts of its own" | The table below has five rows. I counted twice, then found Escape mentioned after the table, so I still cannot tell whether the count is wrong or Escape is the sixth. | Make the count match the table or fold Escape into it. |
| Inside the genotype result window, "the alleles LGE called for each sample in a plate" | "Called" as a verb is analysis jargon. I know alleles and I know plates, but "called" stopped me. | Say the alleles LGE identified. |
| Inside the genotype result window, "when the window is on its Review lens" | "Lens" is an app-specific word used with no explanation and no instruction on how to get to that lens. | Say which control switches the window to Review. |
| Inside the genotype result window, "or when a call is selected in a haplotyped MiSeq result" | Haplotyped is unglossed and this whole condition is the one thing standing between me and the four review shortcuts working. | Gloss haplotype and say plainly when the shortcuts are live. |
| Inside the genotype result window, "Cmd-Opt-P marks the selected cell a false positive" | I know what a false positive is, but not what marking a cell does to my data or whether it can be undone. | Add that the mark is an annotation and Cmd-Opt-R removes it. |
| Inside a classifier result window, "Cmd-right bracket moves to the next sample" | The bracket keys are named in words while every other key in the chapter is a letter or a symbol. I looked for a key labelled "right bracket". | Say the ] key. |
| Inside a classifier result window, "steps out one ring toward the root" | "Root" of a sunburst is not explained, and this is the second job given to Escape without saying which window I have to be in. | Say the centre of the chart. |
| Inside the sidebar, "the delete command, whose title changes to name whatever you selected, is the Delete key on its own" | I could not tell whether this deletes the file from my disk or only from the project. That is a scary shortcut to document without saying. | Say what delete removes and whether it can be undone. |
| Inside the Workflow Builder, "no key binding matches those tooltips in this release" | "Key binding" is a new term for the same thing the chapter has called a shortcut throughout. | Use shortcut, the word already established. |
| Memorizing chords, "faster than memorizing forty-five separate rows" | The heading word "chords" is never defined. The How a shortcut is written section calls them combinations. | Use combination, or define chord once. |
| Customizing shortcuts, "Press the new chord, click Add" | The steps skip what happens between typing the menu title and pressing keys, namely which field the cursor must be in. | Name the Keyboard Shortcut field before saying press the keys. |
| Customizing shortcuts, "the override takes effect the next time LGE launches" | I could not tell whether I must quit and reopen LGE, or whether closing the window is enough. | Say quit LGE with Cmd-Q and open it again. |
| Accessibility, "Ctrl-Opt-M moves VoiceOver into the menu bar" | This assumes VoiceOver is already turned on and does not say how to turn it on, so I could not perform the step. | Add that VoiceOver is toggled with Cmd-F5. |
| Whole chapter, no shortcut index | There is no single alphabetical list of shortcuts. To find what Cmd-Shift-F does I had to scan ten sections. | Add a one-column list of every shortcut in key order at the end. |

Three lines.

The one thing I learned is that LGE has no Save command because it writes
every change to the project folder as it happens.

The one thing I still could not do is fire any of the four genotype review
shortcuts, because I do not know what a Review lens is or how to get the
window onto one.

The sentence I liked most is "LGE greys items out on purpose whenever the
command has nothing to act on."
