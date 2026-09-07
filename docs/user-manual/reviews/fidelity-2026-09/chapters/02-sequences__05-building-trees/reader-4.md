# Reader report: Building Trees

Persona: undergraduate who used Geneious in one class, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Maximum likelihood asks, of all" | Read it three times. "Which one makes the observed columns most probable" tangled me up, because I could not tell whether the tree or the columns is the thing being scored. | Say the tree gets a score and the highest score wins. |
| What it is, "the estimated number of substitutions" | I do not know what a site is here. In Geneious I only ever saw branch lengths as a number with no unit. | Say a site is one column of the alignment. |
| What it is, "IQ-TREE can pick the model" | I do not know what happens if it picks badly, or whether I would ever notice. | Say whether a wrong model shows up anywhere I can see. |
| Why you would do this, "The known primate relationships make this" | Had to reread "grade the answer". I first thought the app grades it. | Say you can check the answer against what is already known. |
| Before you start, "Download the file `primate-mito.fasta` from" | The FASTA is asked for but the procedure never uses it, only the `.lungfishmsa` bundle from the last chapter. I did not know whether I needed both. | Say whether the FASTA is needed for this chapter at all. |
| Before you start, "Install it from **Tools > Plugin" | I did not know what to click once the Plugin Manager opened, or how long the install takes. It says no internet is needed once installed, which implies internet is needed to install, but never says so. | Say the install downloads the pack and needs internet. |
| Procedure, "Open the `.lungfishmsa` bundle so its" | I could not do this from the text alone. It does not say where to double-click, in the sidebar or somewhere else. | Say double-click the bundle in the sidebar. |
| Procedure, "Click the first sequence name in" | I did not know what the name gutter is, and it is not glossed. | Gloss the name gutter as the column of names on the left. |
| Procedure, "Its Inputs section carries a Scope" | I do not know what to do with the Scope line or what a wrong value would look like. | Say what the Scope line should read for the five primates. |
| Procedure, "Tick **Ultrafast Bootstrap** in the Branch" | I do not know how long 1000 replicates takes. The earlier promise of under two minutes seemed to be for a run without support. | Say the two minutes includes the bootstrap. |
| Procedure, "The new bundle appears in the" | I could not tell whether the `Phylogenetic Trees/` folder already exists or gets made for me. | Say the folder is created if it is not there. |
| Import a tree built elsewhere, "Choose **File > Import Center...** (Cmd-Shift-I)" | The tree card sits under a tab called Alignments, which I read twice because a tree is not an alignment. | Say the Alignments tab also holds trees. |
| Settings, "The Phylogenetic Tree Operations dialog holds" | It says thirteen settings but I counted twelve bold paragraphs before Re-root. I could not find the thirteenth. | Make the count match the paragraphs. |
| Settings, "**Model.** Names the substitution model, the" | I do not know what `GTR+G` means and it is not glossed. Geneious gave me a dropdown of codes like that and I never learned them. | Gloss `GTR+G` once in parentheses. |
| Settings, "**Sequence Type.** Tells IQ-TREE what the" | The dialog value is written "NT to AA" but the command line value is `NT2AA`. I could not tell whether those are the same thing. | Say they are the same option. |
| Settings, "The default is Auto, which lets" | I do not know how I would tell if it decided wrong on some other input. | Say where the chosen type is reported after the run. |
| Settings, "**Replicates (Ultrafast Bootstrap).** Sets how many" | Confusing next to the Ultrafast Bootstrap paragraph, which gives the same flag `--bootstrap`. I could not tell whether that flag is a switch or a number. | Say `--bootstrap 1000` turns it on and sets the count at once. |
| Settings, "**SH-aLRT.** Turns on a second, faster" | I do not know how to judge an SH-aLRT number. The chapter later gives 95 and 70 thresholds only for the bootstrap. | Give the good and bad values for SH-aLRT too. |
| Settings, "**Threads.** Sets how many processor cores" | I do not know what "a small number" means. Two? Four? I do not know how many cores my Mac has. | Give one concrete number as an example. |
| Settings, "**Keep identical sequences.** Keeps sequences that" | Read it twice. I could not tell whether the duplicates appear on the tree by default or vanish. | Say duplicates do appear by default, just without their own branch length. |
| Re-root, "**Output bundle name.** Names the new" | It says the number after `-rerooted` grows, but no number was ever shown, so I did not know a number existed. | Show the second name, such as `-rerooted-2`. |
| The shape of the viewport, "On the primate tree it reads" | The summary says unrooted, but the Newick further down has a three-way split at the top, and I could not connect those two facts. | Say the three-way split at the top is what unrooted looks like. |
| The numbers on this tree, "The gorilla joins that macaque pair." | This contradicts the earlier promise that all three apes should sit apart from the two monkeys and that a tree saying otherwise reports a problem. Here it is stated flatly as the finding. I could not tell whether the tree is wrong or the expectation was. | Say plainly whether this tree passes or fails the check set out earlier. |
| The numbers on this tree, "Select the cynomolgus macaque tip and" | I cannot judge 0.958. The chapter says what it is summed from but never what counts as normal. | Say what a large cumulative divergence means. |
| Support values and rooting, "If you ticked Ultrafast Bootstrap, each" | I never saw a support value anywhere in this chapter. The Newick block carries no numbers and the screenshot caption does not mention any. | Show the tree with its support numbers once. |
| Acting on a node, "Right-click a tip or an internal" | It promises ten items but I counted nine named ones. I could not find the tenth. | Make the count match the list. |
| Acting on a node, "**Show in Inspector**, **Copy Node Label**" | I do not know what **Reveal Provenance** shows me or where it opens. The word is linked to a glossary entry but the menu item's behaviour is never described. | Say what appears when you choose it. |
| Relabelling tips from metadata, "To show something more readable, add" | I could not do this. A bundle looks like a single file to me and the chapter never says how to get inside one. | Say how to open the bundle, such as right-click and Show Package Contents. |
| Relabelling tips from metadata, "To write a permanent relabelled bundle" | This is the only way to make the relabel permanent and it is command line only. I have never opened a terminal. | Say whether a GUI route exists. |
| What good looks like, "A short alignment, meaning under a" | I do not know what an informative column is, or how to count them for my own alignment. | Gloss informative column and say where the count is shown. |
| What good looks like, "If IQ-TREE reports that ModelFinder settled" | I would not know how many parameters a model has, or where IQ-TREE says which model it chose. | Say where the chosen model is reported. |
| On the command line, "--node node-a4609f19185ceddd" | The node ID appears with no hint of where this particular one came from, and the paragraph explaining IDs only arrives after the block. | Point forward to the paragraph that explains node IDs. |

One thing I learned. A tree and a similarity matrix answer different questions, and only the tree says which split happened first.

One thing I still could not do. Relabel the tips, because I cannot get a `metadata.tsv` inside a bundle and I cannot use the command line.

The sentence I liked most. "A tree that says otherwise is reporting a problem with your run rather than news about primates."
