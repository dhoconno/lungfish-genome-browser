# Reader 4 report: Decontamination

Persona: a student who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Decontamination is the step that throws" | "before anything is computed from them" tells me when but not what goes wrong if I skip it. I read the sentence twice looking for the harm. | Name the harm in the same sentence. |
| What it is, "The first is to compare it against" | A reference is glossed as a stored collection of sequence, but I could not tell whether I download one or the app already has it. | Say two of the operations ship their own. |
| What it is, "Lungfish Genome Explorer (LGE) offers five" | "three of the first kind and two of the second" made me scroll back and count which was which. | Name the three and the two. |
| What it is, "A bundle is the folder LGE treats" | I did not know a folder could be one object. In Geneious a read set is a row in a list, not a folder. | One clause saying Finder shows a folder and LGE shows one item. |
| What it is, "One operation is an exception to the word" | I could not tell why keeping ribosomal reads would ever be useful, so the exception felt dropped in early. | Give the reason beside it. |
| Table row, "Remove ribosomal RNA sequences, Deacon, Managed ribosomal index" | "Managed" appears here first and I did not know what manages it or whether I ever pick it. | Gloss managed at first use. |
| Table row, "Low-Complexity Filter, bbduk, Nothing, it scores" | "scores the read itself" gave me no idea what the score is until the Settings section, much later. | Say the score is entropy here. |
| Why you would do this, "A read made of a repeating three-letter unit" | I could not picture how one repetitive read becomes thousands stacked on a few positions. I read the paragraph three times. | Show one short example sequence. |
| Why you would do this, "produce a coverage spike that looks like" | I do not know what coverage is. It is used here and again in the results and never glossed in this chapter. | Gloss coverage at first use. |
| Why you would do this, "A variant caller reading that spike" | I do not know what a variant caller is or whether I will ever run one. | Gloss it or cut it. |
| Why you would do this, "the HG002 chromosome 20 slice, a pair" | I did not know what a slice is or why chromosome 20 in particular. | Say a slice is a small extracted region. |
| Why you would do this, "That operation runs on the SRR36291587" | The accession-style name meant nothing to me and I could not tell if I had to look it up somewhere. | Say it is a public run covered by the fixture link. |
| Before you start, "click a filename and then the Download raw" | I followed this but could not tell how many files to download in total, since the second fixture is introduced afterwards. | State the file count for each fixture. |
| Before you start, "Every tool this chapter needs arrives with" | I could not confirm from the text that the pack was actually installed on my machine. | Say where the app shows it as installed. |
| Before you start, "which is why neither appears on the Plugin Manager's" | Explaining an absence sent me hunting for the Databases tab to check something that was never a problem. | Cut or move to Plugin Packs. |
| Before you start, "`lungfish-cli conda db install-managed --list` names them" | A terminal command in a setup section, well before the section that says the command line is optional. | Move it to the command-line section. |
| Before you start, "Deacon spends about four of those seconds" | Four seconds of index loading did not square with the 56 millisecond run reported later. | Reconcile the two timings. |
| Procedure step 3, "with Choose... and Clear buttons beside it" | I did not know what Clear does or whether clearing the database breaks the run. | Say what happens with no database set. |
| Procedure step 3, "unless you have your own Deacon index" | I would not know how to get or build a Deacon index, so I could not judge whether this applies to me. | Say most readers never need this. |
| Procedure, "The result lands under `Analyses/<tool>-<timestamp>/`" | I could not tell whether the result appears in the sidebar by itself or whether I go find it in Finder. | Say it appears in the sidebar. |
| The other four operations, "the segments non-rRNA, rRNA, and Both" | I could not tell whether Both writes two bundles or one bundle holding everything. | Say how many bundles Both writes. |
| The other four operations, "Five other presets sit behind it" | Six presets are listed in Settings but only five are promised here, and I had to count to see the two agree. | State six once. |
| Settings intro, "Remove ribosomal RNA sequences is the one that does not" | I did not follow why writing one file per read class rules out the Output Strategy choice. | One sentence on the conflict. |
| Remove Human Reads, "The command line reaches the same setting as `--database-id`" | A setting with no control is said to have a flag, and I could not tell whether I can change it in the window at all. | Say the Inputs row is the window equivalent. |
| Remove Contaminants, K-mer, "long enough that a 31-base exact match" | Shorten it when reads slip through, but I did not know whether that means 25 or 5. | Give the allowed range. |
| Remove Contaminants, Hamming Distance, "Raise it for error-prone reads, and lower" | I have no way to know whether my reads are error-prone, so neither direction was actionable. | Point at the read-quality chapter. |
| Low-Complexity Filter, "running from 0 for a single repeated base" | Entropy is described as 0 to 1 but the slider stops at 0.3 and 0.9, and I could not tell why the ends are missing. | Say the ends are never useful. |
| Low-Complexity Filter, "about 89 percent of tandem-repeat reads" | I do not know what a tandem repeat is, or which benchmark dataset this refers to. | Gloss tandem repeat. |
| Low-Complexity Filter, Window, "The default is 50, comfortably shorter than a 250-base" | My reads may not be 250 bases and the chapter never says how to find my own read length. | Say where read length is shown. |
| Low-Complexity Filter, K-mer, "a read of repeating three-letter units uses" | Repeating three-letter units using all four bases in fair proportion did not make sense. I read it four times. | Show the example unit. |
| Remove Duplicates, Preset, "the two Optical presets target patterned flowcells" | I do not know what a patterned flowcell is or how to find out which made my data. | Gloss patterned flowcell. |
| Remove Duplicates, Optical Distance, "how many pixels apart two clusters" | Pixels as a distance on a sequencer was completely unfamiliar to me. | One clause on the imaging step. |
| Reading the results, "options: abs_threshold=2, rel_threshold=0.01" | These printed values disagree with the defaults of 1 and 0.0 given later, and I could not tell which is right. | Reconcile the two places. |
| Reading the results, "Retained 85192/85199 sequences (99.992%)" | Seven dropped reads is called a very low figure, but nothing told me what a high figure would be. | Give a rough expected range. |
| Reading the results, "because SRR36291587 is an amplicon run" | Amplicon appears here and again in What good looks like and is never glossed. | Gloss amplicon at first use. |
| Reading the results, "Retained 72/45574 sequences (0.158%)" | The block says 0.158 percent and the next line says 99.84 percent, and I had to work out these are the same fact from opposite ends. | Label the printed number as kept. |
| Results table, "Remove Contaminants, chr20 as a custom reference" | Nothing in the Procedure showed me how to supply chr20 as a reference, so I could not reproduce this row. | Name the file that was used. |
| Results table paragraph, "a figure above roughly 20 percent would say" | This is the only threshold in the chapter I could act on, and it sits in prose rather than beside the setting. | Repeat it in the Preset entry. |
| Provenance, "the parameters `absoluteThreshold` 1 and `relativeThreshold` 0" | These names differ from the printed abs_threshold and from the flags, three spellings of what I think is one setting. | Use one spelling. |
| What good looks like, "Record it and stop rather than mapping 72 reads" | I did not know where to record it or what stopping means for my project folder. | Say the provenance sidecar records it. |
| What good looks like, "a ribosomal index applied to a DNA library" | I could not tell whether the HG002 fixture is a DNA library, and the chapter runs the ribosomal filter on it anyway. | Say the fixture run is a demonstration. |
| On the command line, "The `lungfish-cli` program ships inside" | I have never opened a terminal, and the section did not say whether skipping it costs me any capability. | Keep the reassurance, it helped. |
| On the command line, "`scrub-human --remove-reads` is kept for compatibility" | A flag that does nothing made me wonder whether other settings are quietly ignored too. | Say it is the only one. |

The one thing I learned. Duplicate removal is the wrong operation on amplicon data, because identical reads are the intended product there rather than an artifact.

The one thing I still could not do. Supply my own contaminant reference, since the Procedure never shows the Contaminant Reference row being filled and the results table uses a file it does not name.

The sentence I liked most. "Two runs of one operation on two samples span almost the whole possible range, which is why a removal rate only means something once you know what the sample was."
