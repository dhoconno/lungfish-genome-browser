# Reader 1 report, Building Trees

Persona. A sophomore fresh from a genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Maximum likelihood asks, of all" | I read this twice. "Which one makes the observed columns most probable" reversed the direction I expected, since I thought the data was the guess. | Say the tree is the guess being scored and the alignment is the fixed evidence. |
| What it is, "the estimated number of substitutions" | I do not know what counts as one "site" here, or whether a site is one alignment column. | Gloss site as one alignment column at first use. |
| What it is, "That assumed model is the" | I never learned any substitution model in genetics. I do not know why more than one model exists. | One sentence saying models differ in which base changes they treat as more likely. |
| Why you would do this, "The two macaques should be sisters." | "Sisters" is used as a technical term with no gloss. I guessed it means they join each other first. | Gloss sister as the two tips that meet at the same node. |
| Before you start, "Install it from Tools > Plugin" | I do not know what I click once the Plugin Manager opens, or how I know it finished. | Name the button and say what confirms the install. |
| Before you start, "The pack ships IQ-TREE 3.1.3." | I could not tell whether this version number needs action from me or is only for the record. | Say it is for reproducibility and needs no action. |
| Procedure step 3, "Its Inputs section carries a Scope" | I do not know what the Scope line should say for my run, so I cannot tell a correct one from a wrong one. | Give the exact Scope text expected for the five primate rows. |
| Procedure step 4, "Leave Model on MFP, which" | MFP is never expanded. Later the chapter says "ModelFinder" and I did not connect the two. | Expand MFP as ModelFinder Plus at first use. |
| Procedure step 5, "leave its Replicates field on 1000" | I do not know what a replicate is at this point. Settings explains it, but that comes after the procedure. | One clause here saying a replicate is one rebuilt tree from shuffled columns. |
| Procedure, "The new bundle appears in the" | Nothing tells me what signals the run has finished, only that a bundle appears at some point. | Say the run is done when the new bundle appears in the sidebar. |
| Settings, "Set it by hand when the" | I do not know what a codon alignment is as distinct from a normal one, and codon is not glossed. | Gloss codon alignment as one aligned in three-base blocks. |
| Settings Sequence Type, "which takes auto, DNA, AA, CODON" | BIN and MORPH mean nothing to me and are never explained anywhere in the chapter. | Say those two are for non-sequence data and can be ignored. |
| Settings SH-aLRT, "Turns on a second, faster support" | I could not judge when to turn this on. "When you want two independent support measures" is circular for me. | Say plainly whether a beginner needs it. |
| Settings Seed, "Fixes the starting point of the" | I do not know what a bad seed would look like, or whether changing it is ever required of me. | Say the default is fine and this is only for reproducibility checks. |
| Settings Threads, "The default is blank, which lets" | Blank as a default confused me. I expected a number and worried the field was broken. | Say blank means automatic. |
| Settings Safe numerical mode, "Makes IQ-TREE use slower arithmetic that" | Read twice. I followed the part about small probabilities but not why slower arithmetic fixes it. | Drop the mechanism and say it uses a slower method that tolerates tiny numbers. |
| Settings Keep identical sequences, "puts them back on the finished" | I could not picture what "puts them back" looks like on the drawing. | Say the duplicate appears as a tip with a zero-length branch. |
| Settings IQ-TREE Parameters, "such as a partition file or" | Neither partition file nor topology constraint is glossed and I have no idea what either is. | Drop the examples or gloss one. |
| Re-root, "which accepts a tip label, an" | Normalized node ID appears here first with no explanation of what normalized means. | Gloss it as the app's internal name for a node. |
| Re-root, "so the number after -rerooted grows" | No number was mentioned before this, so I did not know a number existed. | Say repeated re-roots produce -rerooted-2 and so on. |
| Reading the results, "It gives the bundle name, then" | I could not see three internal nodes on the canvas, since only tips carry visible labels. | Say internal nodes are the unlabelled junction points. |
| Reading the results, "A second segmented control switches branch" | I do not know what colouring by "Branch" shows. Support is explained later, Branch never is. | Say Branch shades by branch length. |
| Reading the results, "Cumulative Divergence, the summed branch length" | The tree is called unrooted, so I did not understand what root this sums back to. | Say it sums back to the drawing's left edge on an unrooted tree. |
| The numbers on this tree, "A tree of five tips can" | I could not work out where three comes from and had to take it on faith. | Give the rule as tips minus two for an unrooted tree. |
| The numbers on this tree, "The gorilla joins that macaque pair." | This contradicts the earlier promise that all three apes sit apart from the two monkeys, and the chapter never says so. I stopped and could not tell which passage was right. | Say directly that this grouping is an artefact of the unrooted drawing. |
| The numbers on this tree, "Written as Newick, the tree is" | I cannot read the bracket string, so I could not check it against the topology just described. | Point out which bracket pair is the macaque clade. |
| The numbers on this tree, "Those two sit on the shortest" | I do not know whether 0.03 substitutions per site is a small or a large amount of change. | Give a rough scale, such as three changes per hundred bases. |
| The numbers on this tree, "That long branch is the ape-to-monkey" | With only five sequences I could not tell whether one branch this dominant is normal or a red flag. I only learned it was expected in a later section. | Say here that this one is expected. |
| Support values and rooting, "A support value at or above" | I do not know what to do with a value between 70 and 95, which is the whole middle range. | Say what the middle range means. |
| Support values and rooting, "IQ-TREE produces an unrooted tree, and" | Fixture is used without gloss and I do not know whether it means my tree or a sample one. | Say "the tree you just built". |
| Acting on a node, "Show in Inspector, Copy Node Label" | I do not know what Reveal Provenance shows or why I would click it. | One clause saying it shows how the bundle was made. |
| Acting on a node, "Right-click a tip or an internal" | I counted the items named in these paragraphs and got nine, not ten, so I thought I had missed one. | Match the stated count to the items listed. |
| Relabelling tips from metadata, "To show something more readable, add" | I do not know how to get inside a bundle. It looks like one file in the sidebar. | Say to right-click and Show Package Contents in Finder. |
| Relabelling tips from metadata, "To write a permanent relabelled bundle" | I have never opened a terminal, so this is closed to me, and the chapter does not say whether a GUI route exists. | Say plainly that permanent relabelling is command line only. |
| What good looks like, "A short alignment, meaning under a" | Informative column is a new term here and is not glossed. I do not know how to count them. | Gloss it or say where the count is shown. |
| What good looks like, "If IQ-TREE reports that ModelFinder settled" | I do not know where to see which model was chosen, or what counts as few parameters. | Say where the chosen model is reported. |
| On the command line, "PROJECT=~/Documents/primates.lungfish" | The whole block is unusable for me. I could not tell whether the GUI covers all of it or whether I am missing steps. | A line saying the GUI does all of this except relabel. |
| On the command line, "--node node-a4609f19185ceddd" | This ID is not derivable from anything shown earlier in the chapter. | Say where this ID came from. |

One thing I learned. A tree's shape and its confidence are two separate results, and the bootstrap box is the only thing that produces the second one.

One thing I still could not do. Decide whether the tree I built is right, because the chapter promised the apes would group together and then showed a tree where the gorilla joins the macaques without saying which to believe.

The sentence I liked most. "A tree that says otherwise is reporting a problem with your run rather than news about primates."
