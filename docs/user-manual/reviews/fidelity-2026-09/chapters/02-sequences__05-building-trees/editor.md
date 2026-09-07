# Editor pass: 02-sequences/05-building-trees

Date: 2026-09-06
Chapter: `docs/user-manual/chapters/02-sequences/05-building-trees.md`

Sources are `fidelity`, `readers`, `consistency`, `template`, and `style`.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| What it is, paragraph 1 | Added "An internal node is a calculated guess, not a sample you could look up in a database." | Reader took a node for a real, look-up-able ancestor. | readers |
| What it is, paragraph 1 | "it is the tree's main claim" became "the topology is the main result of a tree run". | A tree does not claim anything, the figure of speech did not land. | readers |
| What it is, paragraph 2 | Glossed site as one alignment column and gave the scale, six substitutions per hundred sites at 0.06. | Four readers could not tell what unit a branch length is in. | readers |
| What it is, paragraph 4 | Added "Your alignment is the fixed evidence and the tree is what gets scored against it", and rewrote "Maximum likelihood asks, of all the trees" as "tries the trees it can build ... and keeps the one that". | Four readers could not tell whether the tree or the data was being scored. | readers |
| What it is, paragraph 4 | Added a sentence on why models differ, with the A-to-G versus A-to-T example and the cost of a wrong model. | Four readers did not know why more than one substitution model exists. | readers |
| Why you would do this | Glossed sisters as the two tips that meet at the same internal node. | Two readers met sisters as an unglossed technical term. | readers |
| Why you would do this | "grade the answer" became "check the answer". | Two readers read grade as an idiom, one thought the app grades the run. | readers |
| Before you start | Added that the FASTA feeds the previous chapter and this one starts from the alignment bundle, and to keep the FASTA anyway. | Two readers could not tell whether the FASTA was still needed. | readers |
| Before you start | Glossed "its own environment" as installing privately without touching other software. | Reader did not know what installing into an environment means. | readers |
| Before you start | Named the `phylogenetics` row, its Install button, and the Installed status as the finish signal. | Four readers did not know what to click in the Plugin Manager. | readers |
| Before you start | Dropped "takes well under two minutes on a current Mac"; replaced with the run being short, model testing included, and a pause of a minute or two being normal. | The fidelity review marked the timing claim unverifiable, since the one permitted inference run never completed. Hedged to its evidence. Also answers the reader item on whether model testing is inside the estimate. | fidelity, readers |
| Procedure step 1 | "Open the `.lungfishmsa` bundle" became "Double-click the `.lungfishmsa` bundle in the sidebar". | Reader did not know how to open it. | readers |
| Procedure step 2 | Glossed name gutter as the column of sequence names down the left side. | Three readers met the term unglossed. | readers |
| Procedure step 3 | Added that Scope reports 5 rows with all five primates selected, and what a smaller number means. | Four readers could not confirm their selection took. | readers |
| Procedure step 4 | Expanded `MFP` as ModelFinder Plus at first use. | Four readers never saw MFP connected to the later ModelFinder mention. | readers |
| Procedure step 5 | Glossed a replicate as one whole tree rebuilt from a resampled copy of the columns. | Four readers met 1000 before knowing what a replicate is. | readers |
| Procedure, after step 5 | Added a paragraph saying progress shows in the Operations panel and the row's status signals completion. | Four readers had no finish signal. | readers |
| Procedure, after step 5 | Added that LGE creates `Phylogenetic Trees/` if the project has none. | Reader could not tell whether the folder must already exist. | readers |
| Procedure, new subsection "Try re-rooting, and check what comes back" | Added a two-step walkthrough that re-roots on the gorilla and has the reader read 13 tips off the summary line, followed by the tip-count check for existing bundles. | Three readers noted re-rooting is described in Settings but never demonstrated. The step doubles as the reproduction of the defect the project manager ruled must be stated plainly. | readers, fidelity |
| Import a tree built elsewhere | Added that the Alignments tab also holds tree cards, and named RAxML-NG and FastTree as other tree-building programs. | Two single-reader items, each a one-clause fix. | readers |
| Settings, opening paragraph | Said the thirteen paragraphs that follow cover all thirteen settings, and that Re-root and Extract subtree belong to different menu items. | Three readers counted the bold paragraphs and could not reconcile them with thirteen. | readers |
| Settings, Model | Glossed `GTR+G` in place. | Reader met the model code unglossed. | readers |
| Settings, Sequence Type | Dropped "it decides correctly on a full mitochondrial genome"; replaced with where the resolved type is reported. | The fidelity review marked the autodetection claim unverifiable. Hedged to its evidence, and this answers the reader item asking where the chosen type appears. | fidelity, readers |
| Settings, Sequence Type | Glossed codon alignment, said `NT2AA` and NT to AA are the same option and that it translates first, and said `BIN` and `MORPH` are for non-sequence data. | Three separate reader items in this paragraph. | readers |
| Settings, Ultrafast Bootstrap | "shuffled versions of your columns" became sampled again with replacement, with the meaning spelled out. | Two readers read shuffled as reordering, which sounds meaningless as a test. | readers |
| Settings, Ultrafast Bootstrap | Added that `--bootstrap 1000` both turns the bootstrap on and sets the count. | Reader could not tell whether the flag was a switch or a number carrier. | readers |
| Settings, Replicates (Ultrafast Bootstrap) | Kept the registry label in bold, added "On screen this field is labelled plain `Replicates`, and it is the one directly beside Ultrafast Bootstrap." | The fidelity review marked the parenthetical label false against the app, where both fields read plain Replicates. The registry spelling stays so settings coverage passes, and the prose carries the truth. | fidelity |
| Settings, SH-aLRT | Said a beginner does not need it and that the bootstrap's 95 and 70 thresholds apply. | Three readers could not judge when to turn it on or how to read it. | readers |
| Settings, Replicates (SH-aLRT) | Kept the registry label in bold, added that this field is also labelled plain `Replicates` and is the one beside SH-aLRT. | Same false row as the other Replicates entry. | fidelity |
| Settings, Seed | Said the number is fixed on purpose so a rerun reproduces the result exactly. | Three readers read a fixed default on a random process as a contradiction. | readers |
| Settings, Threads | Said blank means automatic rather than zero or unset, and gave 2 as a concrete small number. | Four readers read a blank default as broken; two more wanted a number. | readers |
| Settings, Safe numerical mode | Named the error wording and said it appears in the IQ-TREE output in the Operations panel. | Three readers could not judge when to turn it on. | readers |
| Settings, Keep identical sequences | Added that a restored duplicate appears as a tip on a zero-length branch beside its twin. | Three readers could not picture the restoration. | readers |
| Settings, IQ-TREE Executable | "binary" became "program file", and added that most readers never need this field. | Reader did not know what a binary is. | readers |
| Settings, IQ-TREE Parameters | Dropped the partition file and topology constraint examples, pointing at IQ-TREE's own documentation instead. | Two readers had no idea what either term meant, and the reader team's shortest fix allowed dropping them. | readers |
| Settings, Re-root, new lead paragraph | Added the plain statement that re-rooting is broken in this release, that both surfaces duplicate tips, that 5 tips come back as 13, that a re-rooted bundle with more tips than its source is the sign, and not to build on one. Said the two settings are documented as designed because the controls are real. | Project manager's ruling, applied to the false row on Node to root on. The Settings paragraphs stay because the registry requires them. | fidelity |
| Settings, Node to root on | "re-rooting changes what the picture says about ancestry" became "is meant to change ... which is what it will do once the duplication defect above is fixed". | Same false row. | fidelity |
| Settings, Node to root on | Glossed normalized node ID as the app's own internal name for a node. | Three readers met the term well before its definition. | readers |
| Settings, Extract subtree lead | Named both items in the sentence that first says there are two. | Reader item, one-sentence fix. | readers |
| Reading the results, summary line | Added that the parts are separated by wide spacing rather than punctuation, and that unrooted is what IQ-TREE always produces. | Two single-reader items about the spacing and about unrooted reading as failure. | readers |
| Reading the results, viewport shape | "On the right, a `Nodes` drawer" became "Below that, a `Nodes` drawer runs across the bottom of the window". | False row. The drawer is pinned to the bottom, not the right. | fidelity |
| Reading the results, viewport shape | Glossed segmented control as a small button divided into two or three labelled parts. | Reader met the Mac term unglossed. | readers |
| Reading the results, viewport shape | Said `Support` shades by support value and `Branch` by branch length. | Branch colouring was never explained. | readers |
| Reading the results, viewport shape | Pointed forward to the relabelling section where `metadata.tsv` is explained. | The file was referenced before its section. | readers |
| Reading the results, Inspector rows | "A node with a branch" became "Every node except the root sits at the end of a branch, and those nodes add". | The old phrasing implied every node has a branch without saying which does not. | readers |
| The numbers on this tree | Gave the rule directly, tips minus two internal nodes on an unrooted tree, and changed "left nothing collapsed" to "left nothing unresolved". | Four readers could not see where three came from or apply it to another count. Separately, one reader flagged collapsed being reused for Collapse Clade. | readers |
| The numbers on this tree | Added a paragraph walking the Newick brackets, naming the innermost pair as the macaque clade, saying tip order carries no meaning, and saying the three-way split is what unrooted looks like written down. | Three readers could not read the bracket string, plus two single-reader items on tip order and on the three-way split. | readers |
| The numbers on this tree | Added a paragraph stating that this tree does not contradict the expected relationships, that it cannot address them without a root, and that the gorilla sitting beside the macaques is an artefact of the unrooted drawing. | The sharpest failure in the report. Every reader who reached it read the gorilla-macaque grouping as contradicting the chapter's own earlier promise. The fidelity review confirms both the promise and the tree shape as true, so this is added explanation, not a changed fact. | readers |
| The numbers on this tree | "Those two sit on the shortest branches in the tree, 0.0650 and 0.0299" became "sit on branches of 0.0650 and 0.0299 substitutions per site, and the cynomolgus macaque's 0.0299 is the shortest tip branch in the tree". | False row. Of the seven branch lengths (0.0296, 0.0299, 0.0589, 0.0601, 0.0650, 0.0740, 0.8982) three are shorter than 0.0650. | fidelity |
| The numbers on this tree | "more than ten times the length of any tip branch" became "at 12 times the longest tip branch, the gorilla's 0.0740". | Reader had to compute the ratio to trust the claim. The 12x figure is the fidelity review's own arithmetic. | readers |
| The numbers on this tree | Added that one dominant branch is normal on a set spanning this much time, with ten to twenty times its neighbours as the range to expect. | Two single-reader items on whether long-branch dominance is a red flag and on the 0.8982 scale. | readers |
| The numbers on this tree, cumulative divergence | Added that on an unrooted tree the number sums back to the drawing's left edge and is illustrative here rather than diagnostic. | Two readers could not tell what fixed point it sums to; another asked whether the number is worth checking. | readers |
| Support values and rooting | Added what 70 to 95 means, provisional rather than established. | Two readers found the middle of the scale undefined. | readers |
| Support values and rooting | Added that the left edge has no biological meaning "which is why the cumulative divergence numbers above sum back to an arbitrary point". | Reader wanted the warning before the left edge was used implicitly. Rather than move the section, the earlier passage now carries the caveat and this one refers back. | readers |
| Support values and rooting | "re-root the tree on an outgroup yourself" became "you would re-root ... On this release you cannot", with the reason and the consequence for this chapter's tree. | The advice was unsafe given the confirmed defect. | fidelity |
| Acting on a node | Added "All ten are named below" and folded Reveal Provenance's meaning into the sentence that lists it. | Four readers counted nine named items. Adding the Reveal Provenance clause both fixes the count reading and answers the three-reader item about what it shows. | readers |
| Acting on a node, Re-root Here | "writes a new bundle rooted on the node you clicked" became "is meant to write ... On this release the bundle it writes duplicates every tip except the new root, so treat its output as unusable until the defect is fixed." | False row, wording taken from the fidelity review's correction column. | fidelity |
| Acting on a node, Collapse Clade | Added that it changes the drawing only and never the saved tree, and "nothing to collapse" became "nothing to fold". | Reader could not tell whether collapsing changes the saved tree. The wording change avoids reusing collapse in two senses. | readers |
| Relabelling tips from metadata | Added that a bundle is really a folder and to right-click and choose Show Package Contents. | Four readers did not know how to get inside a bundle. | readers |
| Relabelling tips from metadata | Said plainly that permanent relabelling is command-line only with no equivalent control in the window. | Four readers were left at a dead end. | readers |
| Relabelling tips from metadata | Said the three dots stand for digits left out. | Reader could not tell whether the dots were literal. | readers |
| What good looks like | "Four checks" became "Five checks", with a new check on re-rooted bundles having the same tip count as their source, the defect named, and the instruction not to build on one. | Project manager's ruling that the warning appears in both the re-root section and What good looks like. | fidelity |
| What good looks like, tip count check | Added that nothing announces a dropped tip and that IQ-TREE's output names the removed sequence. | Reader did not know whether a drop is reported. | readers |
| What good looks like, topology check | "the two great apes sit apart from them" became a statement that the macaque sisterhood is what this unrooted tree can confirm and that the ape grouping cannot be checked here. | Follows the gorilla-macaque resolution added above, so the two sections agree. | readers |
| What good looks like, closing paragraph | Glossed informative column, said IQ-TREE reports it as parsimony-informative sites, and kept "under a few hundred is thin". | Four readers could not tell how to count them or where the count is shown. | readers |
| What good looks like, closing paragraph | Expanded ModelFinder as the model-testing step `MFP` turns on. | Part of the four-reader MFP item, closing the loop at the second mention. | readers |
| What good looks like, closing paragraph | Added that IQ-TREE prints the stopping line last, beginning with ERROR. | Reader would not know what counts as the error in a wall of output. | readers |
| What good looks like, closing paragraph | "collapse into zero-length branches" became "give zero-length branches". | Removes the third sense of collapse in the chapter. | style |
| On the command line, lead | Added that the section is optional reference and that `tree relabel` is the one capability that exists only here. | Four readers did not know the section was skippable or what was exclusive to it. | readers |
| On the command line, reroot block | Added two comment lines saying re-root is broken in this release, that it turns 5 tips into 13, and to check the tip count. | Fidelity correction on the CLI block row, which rules the invocation stays and a warning comment is added. | fidelity |
| On the command line, extract-subtree block | Added a comment pointing forward to the paragraph that explains where node IDs come from. | Three readers met the ID before its explanation. | readers |

## Deliberately left unchanged

- Every other factual claim in the chapter. The fidelity review marks 76 rows true, and none of those were touched.
- The two Settings paragraphs for `tree.reroot` remain, with the registry's bold labels for both `Replicates` entries. The registry requires them and the settings-coverage rule matches the label verbatim.
- The re-root CLI invocation stays in the command block, per the fidelity correction, carrying a warning comment rather than being deleted.
- `GLOSSARY.md` was not touched. Site, informative column, name gutter, sister, codon alignment, replicate, and normalized node ID are all glossed inline at first use, which is what the consistency sheet asks for, and adding entries is not this role's authority.
- Section order and the chapter template order are unchanged. The one new subsection sits inside Procedure, where a walkthrough step belongs.
- Reader item "support values never actually shown" is left for the screenshot role, since it asks for a captured tree with support numbers rather than a prose change.

## Status

brand_reviewed: false
lead_approved: false
