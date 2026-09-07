# Reader reports, merged, Building Trees

Four readers. Table sorted by how many hit each spot, four first.

| Location | What stopped readers | Readers | Shortest fix |
| --- | --- | --- | --- |
| What it is, "Maximum likelihood asks, of all" | The direction of comparison is unclear. Readers could not tell whether the tree or the data is the thing being scored. | 4 | Say the tree is scored and the alignment is the fixed evidence. |
| What it is, "the estimated number of substitutions...per site" | "Site" is never defined, so readers could not tell what unit a branch length is in or whether a value like 0.03 or 0.06 is a lot. | 4 | Gloss site as one alignment column at first use and give a rough scale, such as six changes per hundred bases. |
| What it is, substitution models | Readers do not know why more than one substitution model exists or what goes wrong if the wrong one is used. | 4 | Add one sentence saying models differ in which base changes they treat as more likely, and what a wrong model would cost. |
| Before you start, "Install it from Tools > Plugin Manager" | Readers do not know what to click once the Plugin Manager opens or how they know the install finished. | 4 | Name the row and the button, and say what shows when the install is done. |
| Procedure, "Its Inputs section carries a Scope" | Readers do not know what value the Scope line should show, so they cannot confirm their selection took. | 4 | Say Scope should read 5 rows for the five primate sequences. |
| Procedure, "Leave Model on MFP" / "What good looks like," ModelFinder | MFP is never expanded where it first appears. The chapter later says ModelFinder without connecting the two names, so readers do not realize they are the same setting. | 4 | Expand MFP as ModelFinder Plus at first use. |
| Procedure, "leave its Replicates field on 1000" | Readers meet the number 1000 before they know what a replicate is. The gloss in Settings comes too late to help. | 4 | Add a half-sentence gloss where replicates first appears, saying a replicate is one rebuilt tree from resampled columns. |
| Procedure, "The new bundle appears in the sidebar" | Nothing tells readers how long the run takes or what signals it has finished. | 4 | Say where progress shows and roughly how long the run takes. |
| Settings, Threads, "The default is blank" | A blank default reads as broken to readers used to seeing a real number. | 4 | Say blank means automatic. |
| Reading the results, "A tree of five tips can hold..." three internal nodes | Readers cannot verify where the number three comes from and cannot apply the rule to a different sequence count. | 4 | Give the rule directly, tips minus two for an unrooted tree. |
| The numbers on this tree, "The gorilla joins that macaque pair" | This appears to contradict the earlier claim that all three apes group apart from the two monkeys. Readers cannot tell whether the tree is wrong or the earlier claim was, and the chapter never resolves it. | 4 | State plainly whether this tree passes or fails the check set out earlier, and call the grouping an artefact of the unrooted drawing. |
| Acting on a node, "Right-click a tip or an internal node...ten" | The section promises ten menu items but readers count nine named ones. | 4 | Make the stated count match the items listed. |
| Relabelling tips from metadata, opening a bundle to add metadata.tsv | Readers do not know how to get inside a bundle. In Finder it looks like a single file. | 4 | Say how to open the bundle, for example right-click and Show Package Contents. |
| Relabelling tips from metadata, "use tree relabel on the command line" | This is the only way to make relabelling permanent, and it is closed to readers who have never opened a terminal. No GUI alternative is stated. | 4 | Say plainly that permanent relabelling is command line only, with no in-app equivalent. |
| What good looks like, "under a few hundred informative columns" | Informative column is never glossed and readers cannot tell how to count them or where the count is shown. | 4 | Gloss informative column and say where the count appears. |
| On the command line | Nothing tells readers this whole section is optional and can be skipped, or which capabilities exist only there. | 4 | Add a line up front saying which capabilities are command line only, and that the rest is optional reference. |
| On the command line, "--node node-a4609f19185ceddd" | The node ID is used before the paragraph that explains where such IDs come from. | 3 | Point forward to the explanation, or move the explanation earlier. |
| Procedure, "Click the first sequence name in the name gutter" | Name gutter is never glossed. | 3 | Gloss it as the column of sequence names on the left. |
| Settings, "The Phylogenetic Tree Operations dialog holds thirteen" | Readers count eleven to twelve bold settings before Re-root, not thirteen, and cannot tell which items are covered by the stated count. | 3 | Make the stated count match the paragraphs, or say the later groups belong to a different menu item. |
| Re-root, walking through re-rooting | The Settings reference describes re-rooting in detail, but the procedure never has readers actually re-root anything, so the section describes controls for an action never demonstrated. | 3 | Add one short numbered step that re-roots the sample tree once in the app. |
| Re-root / Extract subtree, "a normalized node ID" | This term appears with no explanation well before the paragraph that defines it. | 3 | Gloss it at first use as the app's internal name for a node. |
| Settings, Safe numerical mode | Readers do not know what a likelihood error looks like or where it would appear, so they cannot judge when to turn this on. | 3 | Name or quote the error text, and say where it shows up. |
| Settings, Keep identical sequences | Readers cannot picture how a sequence removed before analysis reappears on the finished tree. | 3 | Say the duplicate appears as a tip with a zero-length branch next to its identical twin. |
| Settings, Seed | Readers do not understand why a random process has a fixed default, and read it as a contradiction. | 3 | Say the number is fixed on purpose so a rerun matches exactly. |
| Reading the results, Newick string | Readers cannot read the bracket string and the text never walks through even one bracket pair. | 3 | Point out which bracket pair is the macaque clade. |
| Acting on a node, Reveal Provenance | Readers do not know what this menu item shows or why they would click it. | 3 | Add one clause saying it shows the record of how the bundle was made. |
| Settings, SH-aLRT | Readers cannot judge when to turn this on or how to read its score, since no thresholds are given for it the way 95 and 70 are given for the bootstrap. | 3 | Say plainly whether a beginner needs it, and give it a threshold or say the bootstrap thresholds also apply. |
| The numbers on this tree, cumulative divergence reference point | The tree is called unrooted, so readers cannot tell what fixed point the cumulative divergence sums back to. | 2 | Say it sums back to the drawing's left edge on an unrooted tree. |
| Before you start, FASTA file vs. the .lungfishmsa bundle | Readers are told to download the FASTA, but the procedure starts from the bundle made in the previous chapter, so they cannot tell if the FASTA is still needed. | 2 | Say whether the FASTA is used in this chapter or only feeds the previous one. |
| Why you would do this, "sisters" | Sisters is used as a technical term with no gloss. | 2 | Gloss sister as the two tips that meet at the same node. |
| Why you would do this / Settings, "grade the answer" | Grade is read as an idiom, and one reader first assumed the app itself grades the run. | 2 | Replace grade with check. |
| Settings, Sequence Type, codon alignment | Codon alignment is used but never glossed. | 2 | Gloss codon alignment as one aligned in three-base blocks. |
| Settings, Sequence Type, NT2AA / NT to AA | The dialog shows "NT to AA" while the command line shows NT2AA, and readers cannot tell these are the same option, or what it does. | 2 | Say the two names are the same option, and that it translates the nucleotides to amino acids first. |
| Settings, Ultrafast Bootstrap, "shuffled versions of your columns" | Readers read shuffled as scrambling the order, which sounds meaningless as a test, rather than resampling with replacement. | 2 | Say the columns are sampled again with replacement, not reordered. |
| Settings, Threads, choosing a number | Readers do not know how many cores their Mac has or what a small number means in practice. | 2 | Give one concrete example number. |
| Support values and rooting, support value between 70 and 95 | The chapter defines the ends of the scale but not the middle range, which is where readers expect to land. | 2 | Say what the middle range means. |
| Settings, IQ-TREE Parameters, partition file / topology constraint | Neither term is glossed and readers have no idea what either is. | 2 | Drop the examples or gloss one. |
| What it is, "node" | Readers took a node for a real, look-up-able ancestor rather than a computed point with no corresponding sample. | 1 | Say plainly the node is a calculated guess, not a sample. |
| What it is, "the tree's main claim" | A tree does not claim anything, so the figure of speech did not land. | 1 | Say the topology is the main result. |
| Before you start, "environment" | Readers do not know what it means for software to install into its own environment. | 1 | Say it installs privately and does not touch other software. |
| Procedure, opening the .lungfishmsa bundle | The chapter does not say to double-click the bundle in the sidebar. | 1 | Say double-click it in the sidebar. |
| Procedure, model testing duration | Readers do not know whether model testing is included in the under-two-minute estimate, so a long pause looks like a freeze. | 1 | Say model testing is included in the time estimate. |
| Procedure, whether the Phylogenetic Trees folder already exists | Readers cannot tell if the destination folder is created for them or must already exist. | 1 | Say the folder is created if it is not already there. |
| Import a tree built elsewhere, RAxML-NG and FastTree | These are named with no explanation of what they are. | 1 | Say they are other tree-building programs. |
| Import a tree built elsewhere, tree cards under the Alignments tab | A tab called Alignments holding tree cards reads as a mismatch. | 1 | Say the Alignments tab also holds trees. |
| Settings, "GTR+G" | The model code is never glossed. | 1 | Gloss GTR+G once in parentheses. |
| Settings, Sequence Type, Auto | Readers do not know where a wrongly auto-detected type would be reported. | 1 | Say where the chosen type is reported after the run. |
| Settings, Replicates vs. the --bootstrap flag | The same flag is shown as both a switch and a number carrier, and readers cannot tell which it is. | 1 | Say --bootstrap 1000 both turns the bootstrap on and sets the count. |
| Settings, Sequence Type, BIN and MORPH | These values are never explained anywhere in the chapter. | 1 | Say those two are for non-sequence data and can be ignored. |
| Settings, IQ-TREE Executable, "binary" | Readers do not know what a binary is or where one would be found. | 1 | Say most readers never need to touch this. |
| Settings, Extract subtree, "the two subtree items" | This is the first mention that there are two such items. | 1 | Name both items in this sentence. |
| Reading the results, summary line spacing | Readers cannot tell if the wide spaces in the example summary line are meaningful. | 1 | Say the app separates the parts with spacing. |
| Reading the results, "segmented control" | This Mac interface term is not glossed. | 1 | Say it is a small two- or three-part button. |
| Reading the results, metadata.tsv referenced before its section | A control is said to depend on metadata.tsv before the chapter has explained what that file is. | 1 | Point forward to the relabelling section. |
| Reading the results, "A node with a branch" | This phrasing implies every node has a branch, and readers cannot tell which one does not. | 1 | Say the root has no branch. |
| Reading the results, "Branch" coloring option | Support coloring is explained later, but Branch coloring is never explained. | 1 | Say Branch shades by branch length. |
| Reading the results, unrooted tree and the three-way split | Readers cannot connect the word unrooted to the three-way split shown in the Newick block. | 1 | Say the three-way split at the top is what unrooted looks like. |
| Reading the results, first reaction to "unrooted" | Readers' first read of unrooted is that their run failed, since the chapter only later says it is normal. | 1 | State on first mention that unrooted is what IQ-TREE always produces. |
| Reading the results, Newick tip order | Human and chimpanzee appear first in the Newick string, which readers expected to mean something about branching order. | 1 | Say Newick order does not indicate branching order. |
| Reading the results, cumulative divergence, diagnostic or illustrative | Readers cannot tell whether this number is worth checking on their own tree or is only an example. | 1 | Say whether the number is diagnostic or only illustrative here. |
| Reading the results, "more than ten" times | Readers had to compute the ratio themselves before trusting the claim. | 1 | State the ratio outright. |
| The numbers on this tree, "collapsed" | This word is reused later for Collapse Clade in a different sense. | 1 | Use a different word for one of the two meanings. |
| The numbers on this tree, long branch dominance | With only five sequences, readers cannot tell whether one dominant branch is normal or a red flag until a later section says so. | 1 | State here that this one is expected. |
| The numbers on this tree, 0.8982 scale | This value is far larger than any other and readers have no scale to judge whether that is normal. | 1 | Say what range is typical. |
| Support values and rooting, root at the left edge not being real | This warning arrives after the numbers section has already used the left edge as if it were meaningful. | 1 | Move the warning earlier, before the left edge is used implicitly. |
| Support values and rooting, support values never actually shown | No support numbers appear anywhere in the chapter's example tree or screenshots. | 1 | Show the tree with its support numbers at least once. |
| Acting on a node, Collapse Clade | Readers cannot tell whether collapsing changes the saved tree or only the on-screen view. | 1 | Say it changes the view only. |
| Relabelling tips from metadata, ellipsis in the example string | Readers cannot tell whether the dots in the example output are literal or stand for omitted text. | 1 | Say the dots stand for omitted text. |
| What good looks like, missing tip | Readers do not know whether a dropped tip is reported anywhere or only discovered by counting. | 1 | Say whether a message appears when a tip is dropped. |
| What good looks like, where the IQ-TREE error appears in the log | Readers would not know what in a wall of IQ-TREE output counts as the error. | 1 | Say what to look for in that output. |

## Summary

Across all four readers, the most common failure is a term or number used before it is defined. Site, MFP, replicate, name gutter, and normalized node ID all appear and confuse readers well ahead of their glosses. The second most common failure is a missing confirmation signal, readers cannot tell what a correct Scope value looks like, when a run has finished, or whether the gorilla-macaque grouping they see is expected or a problem. The single sharpest failure is the gorilla-macaque tree, which every reader who reached it read as contradicting the chapter's own earlier promise about ape relationships, with no line in the chapter resolving which claim to trust.
