# Reader 1 report — Decontamination

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is — "The first is to compare" | I do not know what a reference is here. It is called "a stored collection of sequence you already have" but I have never had one, so I cannot tell if it is a file I download or something the app already holds. | Say whether a reference is something I supply or something LGE ships. |
| What it is — "Reads matching a ribosomal database are" | I learned ribosomes make protein. I do not know why ribosomal RNA would be in my sequencing file at all, so I cannot tell when this operation applies to me. | One sentence saying rRNA gets sequenced because it is so abundant in the sample. |
| What it is — "carrying the extension `.lungfishfastq`" | I do not know what a folder with an extension is. On my Mac a folder does not have an extension. | Say it looks like a single file in Finder but is really a folder. |
| What it is — "One operation is an exception to" | Read this three times. "An exception to the word removal" made me think the operation was named wrong, not that it can be inverted. | Say plainly that this one operation can keep the rRNA instead of throwing it out. |
| What it is table — "Managed human index" | "Index" is new. Everywhere else the chapter says "database". I cannot tell if an index and a database are the same thing. | Use one word, or say the two words mean the same thing. |
| What it is table — "A spike-in, vector, or carrier" | Three unknown words in one table cell. I have no idea whether any of them describes something I would ever have. | Gloss "spike-in" at least, since PhiX is called one later. |
| Why you would do this — "produce a coverage spike that looks" | I do not know what coverage is. And "amplification" in my genetics class meant PCR, which does not seem to be the meaning here. | Define coverage before using it, and say which meaning of amplification is intended. |
| Why you would do this — "A variant caller reading that spike" | I do not know what a variant caller is and it is not explained anywhere in this chapter. | Gloss it or link it like the other terms. |
| Before you start — "This chapter uses the HG002 chromosome" | I do not know why a sample comes as two files, or which one is which. Later the commands use only R1 and I could not tell if that was deliberate. | One sentence on what R1 and R2 are and why some commands take just one. |
| Before you start — "Import both files as one bundle" | I could not do this from this text. It sends me to another chapter without saying whether making one bundle from two files is a special option or the normal thing. | Say the import is one action with both files selected. |
| Before you start — "No optional pack is needed, and" | I have never heard of Docker Desktop and could not tell whether I was supposed to already have it installed. | Drop the mention or say it belongs to other chapters. |
| Before you start — "On the command line, `lungfish-cli conda`" | A terminal command sits inside the section listing what I need before starting. I have never opened a terminal, so I stopped and worried I was skipping a required step. | Mark it as optional the way the later command-line section is. |
| Procedure step 3 — "Leave the Database row alone unless" | I do not know how anyone gets their own Deacon index, or how I would know whether the built-in one suits my sample. | Say most readers leave this alone and stop there. |
| Procedure step 3 — "The settings pane below the Inputs" | I would have assumed the dialog had failed to load properly. | Say the empty pane is expected here. |
| Procedure — "The result lands under `Analyses/<tool>-<timestamp>/`" | I do not know what `<tool>` or `<timestamp>` will actually say, so I would not recognise the folder in my project. | Show one real folder name as an example. |
| The other four — "shows one segmented **Retain Reads** control" | A button labelled "non-rRNA" confused me. I could not tell whether picking it keeps or removes the non-rRNA reads until the Settings section much further down. | Say keep-versus-remove right where the control is introduced. |
| The other four — "PhiX mode needs nothing else." | I did not know what PhiX was at this point. It is only explained later, in Settings. | Gloss PhiX here at first mention. |
| Settings, Remove Human Reads — "The command line reaches the same setting" | Command-line text turns up in a section I thought described the window, and I could not tell whether it was something I needed to do. | Keep the flags out of the GUI settings, or label them as command-line only. |
| Settings, Entropy Threshold — "The default is 0.60, which the" | I do not know what a tandem repeat is, and the benchmark dataset is not named, so I cannot judge whether 0.60 suits my data. | Gloss tandem repeat, and name the benchmark or drop the figure. |
| Settings, Entropy Threshold — "Raise it when repeats are still" | I cannot tell how I would ever see that repeats were inflating my coverage. Nothing in the chapter shows me that view. | Point to where in the app that would be visible. |
| Settings, Window — "The default is 50, comfortably shorter" | I do not know how long my own reads are, so I cannot tell whether 50 is safe for me. | Say where the read length is displayed. |
| Settings, K-mer — "Change it rarely, and then only" | I would not know where published bbduk settings live or why I would want to match one. | Say most readers never touch this. |
| Settings, Preset — "the two Optical presets target patterned" | I do not know what a patterned flowcell is or how to find out whether mine is one. | Say how to tell, for example from the instrument name. |
| Settings, Optical Distance — "Sets how many pixels apart two" | I did not know sequencing involved pixels or clusters. The sentence assumes a picture of the machine that I do not have. | One sentence saying reads are read off an image of the flowcell. |
| Reading the results — "Deacon v0.16.0; mode: deplete; input:" | The log says abs_threshold=2 and rel_threshold=0.01, but the Provenance paragraph says absoluteThreshold 1 and relativeThreshold 0. I could not tell which is right or whether I had done something wrong. | Explain why the two differ, or quote one run in both places. |
| Reading the results — "That is 99.84 percent of the" | Had to read twice and do the subtraction myself. The log gives the kept count and the sentence gives the removed percentage. | Add the removed count in the sentence. |
| Reading the results — "because SRR36291587 is an amplicon run" | I do not know what an amplicon run is, and it is the whole reason the number is low. | Gloss amplicon at first use. |
| Results table — "Remove Contaminants, chr20 as a custom" | The table row on its own reads like a setting I should try. Only the paragraph afterwards told me it was a deliberate mistake. | Mark the row as a demonstration of a mistake. |
| Reading the results — "a figure above roughly 20 percent" | I do not know what starting material means, or what I would actually do if I saw a figure that high. | Say what the reader should do in that case. |
| Reading the results — "using the first of the two" | "Mate files" is a new phrase for what was earlier called a pair. I stopped to check they were the same thing. | Use one term throughout. |
| Provenance — "and a checksum for every input" | I do not know what a checksum is or why it would matter to me. | Gloss it as a fingerprint that reveals if a file changed. |
| What good looks like — "a ribosomal index applied to a" | I do not know what a bacterial isolate is, and this is the example meant to teach me the trap. | Use a plainer example. |
| On the command line — "The block below runs all five" | The block assumes I can open a terminal and already be in the folder holding the files. The section says it is optional but not that it needs skills the rest of the chapter never asked for. | Say the section assumes terminal experience. |
| On the command line — "One flag does nothing at all." | I could not work out why a flag that does nothing is documented, or whether its existence should worry me. | Say it is listed only so an old script does not confuse the reader. |

One thing I learned. Unwanted reads are dangerous not only because they waste computer time but because a pile of repeat reads can fake a real-looking coverage spike that the next program will believe.

One thing I still could not do. Decide which of the five operations my own sample needs, because that depends on knowing whether my run was amplicon or shotgun and the chapter never tells me how to find that out.

The sentence I liked most. "Two runs of one operation on two samples span almost the whole possible range, which is why a removal rate only means something once you know what the sample was."
