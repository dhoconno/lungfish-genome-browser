# Editor pass: 01-foundations/07-plugin-packs

Date: 2026-09-06

Chapter: `docs/user-manual/chapters/01-foundations/07-plugin-packs.md`

Lint after the pass: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/01-foundations/07-plugin-packs.md`
reports no issues found.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Procedure step 3, status labels | Added the two managed-data rows on the Required Setup card reading **Needs download** or **Needs refresh**, and changed the closing sentence from "every tool inside it" to "every row inside it" | Fidelity row 19. The card shows six labels, and two Required Setup rows are reference data rather than programs | fidelity |
| Procedure step 3, "integrity check" | Added a sentence saying the check confirms installed files are complete and undamaged and never touches user data | Four readers could not judge whether a failed check was dangerous | readers |
| Procedure step 3, "Storage unavailable" | Replaced "the volume the install lives on is not currently mounted" with "the external drive the install lives on is unplugged" | Four readers hit "volume" and "mounted" as new terms | readers |
| Procedure step 4 | Added that Required Setup is present but not yet installed on a first launch | One reader could not tell whether it was already installed | readers |
| Procedure step 4 | Added that a sleeping Mac pauses the download, so leave the lid open | Two readers wanted this stated before the closed-lid reference later in the section | readers |
| Procedure step 5, "several can install at once" | Replaced with "starting a second one is safe" plus the exclusive lock on the install root making the second install wait | Fidelity row 23. Installs are serialised by the conda root lock, and the chapter's shared-workstation section already said so. Resolved in favour of the later, correct sentence | fidelity |
| Procedure step 5, first install | Added "usually a few minutes on a fast connection" | One reader could not tell minutes from hours | readers |
| The packs, experimental lead-in | Deleted the stray repeated "This feature is experimental" sentence, stated that seven cards show until the setting is turned on, and added that experimental packs are simply less tested | Four readers re-read the passage unable to tell what "this feature" referred to. One asked what turning it on costs, one asked whether packs are hidden or marked | readers |
| Pack table, `metagenomics` row | "Kraken2" changed to "Kraken 2" in the table cell only | Fidelity row 33. The card label carries a space. The tool name stays "Kraken2" in prose | fidelity |
| Pack table, `wastewater-surveillance` row | "Freyja" changed to "Freyja, iVar, Pangolin, Nextclade, minimap2" | Fidelity row 39. The card renders five requirement rows, not one. Only Freyja is pinned in the lock, which is why the manifest alone read as a single tool | fidelity |
| Pack table | Added an approximate size column, one figure per pack from `PluginPack.swift` | Three readers could not tell which pack is large and could not reconcile the prose figures | readers |
| The packs, source-code pack ids | Replaced the paragraph about unswitched ids with "The list above is complete" | Four readers said ids they cannot see serve no purpose | readers |
| The packs, MHC and Savont | Added a gloss for MHC and a job description for Savont | MHC unglossed (one reader), Savont undescribed unlike its neighbours (three readers) | readers |
| The packs, sizes paragraph | Replaced "a few hundred megabytes ... about 1 GB" with the arithmetic, about 5.9 GB for all ten optional packs on top of 2.7 GB | Three readers could not reconcile the per-pack figures against the stated totals | readers |
| The packs, post-install hooks | Named Freyja as the tool fetching lineage data, glossed lineage data, and replaced "hovering" with "resting the pointer on the count without clicking" | Two readers on the unnamed tool and unglossed lineage data, one on "hovering" | readers |
| Install without internet, air-gapped | Glossed air-gapped and firewalled with a campus and hospital example | Three readers on the term, one on whether university WiFi counts | readers |
| Install without internet, before the code block | Added that both commands go into the Terminal application, with a pointer to the previous chapter | Four readers had never opened a terminal and the chapter never said where to type | readers |
| Install without internet, closing sentence | "This is the one place in the chapter where you type a command" changed to "the only step in the walkthrough" | Fidelity row 105. The chapter prints eleven further commands. Resolved in favour of the later, correct content | fidelity |
| Manage installed environments, Check for Tool Updates | Restated as comparing installed tools against the exact versions this copy of LGE expects, and named that set "the pinned dependency list" once for the whole chapter | Four readers saw three names for one thing, one could not follow what was compared to what | readers |
| Manage installed environments, orphaned rows | "a bare hexadecimal name" changed to "a long string of letters and numbers", and "a hash-named environment" changed to "one of those leftovers" | Four readers on "hexadecimal" | readers |
| Settings lead-in | Added the forward reference to locally built databases, a note that every command starts with `lungfish-cli`, and a gloss for angle brackets | Four readers hit the locally-built fact before it was explained. Three on angle brackets, one on the dropped prefix | readers |
| Settings, Download | "seventy-two" now reads "seventy-two gigabytes", command prefixed with `lungfish-cli` | Four readers re-read to confirm the dropped unit | readers |
| Settings, Remove / Refresh | Commands prefixed with `lungfish-cli` | Prefix consistency across command examples | readers |
| Settings, Update | "the app's dependency list" changed to "the app's pinned dependency list", "databases built on your own machine" changed to "the locally built databases described above", command prefixed | One term for the pinned list, and the forward reference the readers asked for | readers |
| Settings, Storage Settings.... | "the app's own managed storage folder" now glossed as the shared folder holding environments and databases, and "This setting has no command-line flag" changed to "There is no command-line equivalent for this setting" | One reader could not tell managed storage from managed environment, one did not know what a flag is | readers |
| Reading the results, row contents | Split the install-state clause and named the on-screen labels **Installed** and **Download**, verified against `PluginManagerView.swift` | Two readers could not picture the labels | readers |
| Reading the results, memory column | Added that a database is loaded into RAM to run, pointing back to Before you start | Two readers did not expect a stored file to need memory | readers |
| Reading the results, database count | "Sixteen databases are listed" changed to "Thirteen databases are listed" | Fidelity row 69. The Databases tab drops the three bundled decontamination sidecars from the catalog, and `conda db list` prints thirteen | fidelity |
| Reading the results, Kraken2 collections | Converted the nine collections to a table with memory and coverage columns, glossed vector sequence, gave EuPathDB46 example organisms and the release number, gave MinusB its 11 GB figure and a reason to choose it, and added a Kraken2 gloss | Two readers could not reach the count by prose, three wanted MinusB's size and rationale, two on unglossed vector sequence and Kraken2, four on EuPathDB46 | readers |
| Reading the results, compression | Added a paragraph on what compression costs in sensitivity | Four readers said this was the only option available on a 16 GB Mac and its cost was unstated | readers |
| Reading the results, SILVA and Greengenes | Reconciled "built" with "rebuild by downloading" by naming the **Download** button, and added the 12 GB against 8 GB comparison with when to choose each | Two readers read the two descriptions as contradictory, one could not choose between them | readers |
| Reading the results, EsViritu | Dropped the precise 19,925 and 63 counts for a plain description, and added when to reach for EsViritu against the Kraken2 Viral database | Four readers could not judge the counts, one could not choose between the two viral options | readers |
| Reading the results, human-removal entries | Rewritten as "Three more reference sets handle host and background sequence, and they do not appear on this tab", separating the rRNA index from the human-removal ones and naming `conda db install-managed --list` | Fidelity row 81. None of the three is on the Databases tab, and Ribosomal RNA Removal Data is not a human-removal entry. Also fixes the three-readers count-mismatch item | fidelity |
| What a missing tool looks like | Moved the reassurance forward as "The operation stopped before writing anything", named the Packs tab twice, said what to do about an empty package list, and repeated the read-only-root message here | One reader re-read the reassurance, two lost the Install All tab and the empty-list case, one noted the read-only message sat only in the skipped section | readers |
| Disk usage | Restated the totals as about 5.9 GB optional plus 2.7 GB required, under 9 GB installed, with the 67 GB and 72 GB database figures | Three readers doing the arithmetic could not make the totals add up | readers |
| What good looks like | "a storage volume that was unmounted mid-run" changed to "an external drive unplugged mid-run" | Same volume and mounted jargon four readers flagged in step 3 | readers |
| On the command line, lead-in | Marked the section optional, glossed SSH, and said `lungfish-cli` ships inside the app with a pointer to the CLI Reference appendix | Three readers on SSH and the remote-machine assumption, two on where `lungfish-cli` comes from | readers |
| On the command line, subcommand list | Cut the bare list of five subcommands down to the two that matter, `envs` and `list` | One reader skipped the line entirely | readers |
| On the command line, closing paragraph | Glossed double-dash options, and replaced "the layer beneath all of this" with a plain statement that `provision-tools` installs micromamba and LGE normally does it for you | One reader on the vague phrase, one on the never-introduced double-dash flags | readers |
| Code comment in the CLI block | "pinned dependency set" changed to "pinned dependency list" | One term for the pinned list throughout | readers |
| Notes for shared workstations, opening | "This section is for whoever sets LGE up ... Everyone else can skip it" changed to "Skip this section" first | Two readers wanted the skip instruction stated more firmly at the top | readers |
| Before you start, hardware paragraph | Split memory and disk into two paragraphs, named where the Mac reports memory and free disk, replaced "hardware floor" with "minimum requirements", named where the About window is, and said plainly that a smaller figure slows or narrows rather than blocks | Four readers could not check their own memory, three on the unstated consequence and the About window, one lost track of three numbers in one sentence | readers |
| Before you start, external storage | Dropped "Use a real SSD over Thunderbolt, USB-C, or USB 3. A spinning external drive is too slow ..." and replaced it with "Any modern external SSD is fast enough, and the drive's own product listing will say SSD rather than hard disk" | Fidelity row 108, unverifiable. Nothing in the source states a storage-medium requirement, and the project manager ruled the claim dropped. The replacement clause also answers the four-reader item about telling an SSD from a spinning drive | fidelity |
| Before you start, closing | Dropped "the whole tour takes about ten minutes plus whatever your network spends downloading" and glossed Docker Desktop | Fidelity row 107, unverifiable, dropped by the project manager. Three readers wanted Docker Desktop glossed or dropped | fidelity |
| Before you start, opening | "Everything here is done in ... against your own machine" changed to "Everything here happens in the Plugin Manager window, against your own machine" | The two fixed sentences from CONSISTENCY stand as written, adjusted for a chapter with no fixture. Passive voice tightened | consistency |
| What it is, opening | Glossed bioinformatics tool and command-line tool | Four readers on command-line tool, two on bioinformatics tool | readers |
| What it is, mappers and callers | Added that the three mappers do the same job and each chapter names its own, and that the four callers differ by sequencing technology | Four readers on the callers, two on the mappers | readers |
| What it is, reference genome | Glossed as a finished genome sequence used as a yardstick | Used before being defined | readers |
| What it is, backtick ids | New paragraph saying names in that typeface are internal ids and the card shows a plain title | One reader on the typeface, one on linking ids to card titles | readers |
| What it is, Required Setup naming | Named the on-screen label Third-Party Tools first, then the manual's name for it | Two readers on the same pack carrying two or three names | readers |
| What it is, "Its contents answer a question" | Stated the question directly, which is where the ordinary file-handling tools went | One reader re-read three times looking for the question | readers |
| What it is, trimming and BBMap | Glossed trimming, described BBMap as a general-purpose read mapper and named `bbtools` as the card entry, and said the remaining utilities are internal helpers | Four readers on trimming and on BBMap, two on the seventeen utilities against the five named | readers |
| What it is, libraries | Replaced "libraries it needs" with "shared code it depends on" and noted this is not a sequencing library | Three readers misread library on first pass | readers |
| What it is, micromamba | "speaks the conda protocol" replaced with "does the same job faster, and you never touch it directly" | One reader could not decode the metaphor, one flagged "protocol" specifically | readers |
| What it is, environment collision | Added "and neither one breaks the other" as the symptom | One reader understood the words but not why it would arise | readers |
| What it is, hidden folder | Said the `~` stands for your home folder and that you never need to open it | Four readers on the tilde and hidden folders | readers |
| Why you would do this, workflow chapters | Added what a workflow chapter is and where they start | One reader could not tell workflow from foundations chapters | readers |
| Why you would do this, disk figures | "eight gigabytes and seventy-two" changed to the 8 GB Standard-8 and 72 GB PlusPF with a forward reference | One reader could not match the 8 GB figure to anything later. Also settles the digits-against-words number style | readers |
| Install without internet, chapter link | "[The Lungfish Project]" link text changed to "[previous chapter]" | The linter flags bare "Lungfish" for the app. The chapter title cannot appear as link text under `app-name.js` | style |

## Deliberately unchanged

The Settings bold labels keep their exact form, including the four-dot
`**Storage Settings....**`, which matches the app's ellipsis label and the
linter's expectation. The five Settings entries keep the fixed three-sentence
shape, so glosses the readers asked for went into the section lead-in rather
than into the entries. Fidelity row 101's seventeen-utilities sentence stands
as written, with the nineteen-row fact carried by the new sentence in Procedure
step 3. Fidelity row 43's `gatk-core` sentence stands, since the review
confirmed it true. No claim marked true in `fidelity.md` was altered except
where a reader item asked for added explanation around it.

## Status

brand_reviewed: false
lead_approved: false
