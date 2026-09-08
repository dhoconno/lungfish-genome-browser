---
title: Building Trees
chapter_id: 02-sequences/05-building-trees
audience: analyst
prereqs: [01-foundations/01-what-is-a-genome, 02-sequences/04-aligning-sequences]
estimated_reading_min: 17
task: Infer a maximum-likelihood tree from an alignment with IQ-TREE, read it in the tree viewport, and re-root or extract a clade from it.
tags: [sequences, phylogenetics, iqtree, tree, newick, bootstrap]
tools: [iqtree]
parameters_refs: [tree.iqtree, tree.reroot, tree.extract-subtree, import.tree]
entry_points:
  - Right-click in the alignment viewport > Build Tree with IQ-TREE...
  - File > Import Center... > Alignments > Phylogenetic Trees
  - "CLI: lungfish-cli tree infer iqtree"
  - "CLI: lungfish-cli tree reroot"
  - "CLI: lungfish-cli tree extract-subtree"
shots:
  - id: iqtree-dialog
    caption: "The Phylogenetic Tree Operations dialog, with the Output Name and Model fields above the Branch Support group and the collapsed Advanced Options group."
  - id: tree-viewport-primate-mito
    caption: "The primate mitochondrial tree open in the tree viewport, with the summary line, the Phylogram and Cladogram control, and the Nodes drawer showing the visible subset of the tree’s nodes."
illustrations:
  - id: tree-anatomy
    caption: "Anatomy of a rectangular phylogram, showing tips, internal nodes, branch lengths, and support values."
glossary_refs: [iqtree, phylogram, cladogram, clade, newick, support-value, sh-alrt, bootstrap, maximum-likelihood, substitution-model, tip, internal-node, branch-length, topology, rooting, outgroup, msa, alignment-column, mitochondrial-genome, accession, plugin-pack, provenance, bundle, sidebar, inspector, operations-panel]
features_refs: []
fixtures_refs: [primate-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

A phylogenetic tree is a diagram of inferred ancestry. Each sequence you put in becomes a [tip](../../GLOSSARY.md#tip), a point at the end of a branch. Every place two branches meet is an [internal node](../../GLOSSARY.md#internal-node), which stands for an ancestor that no longer exists and was never sequenced. An internal node is a calculated guess, not a sample you could look up in a database. The pattern of who joins whom is called the [topology](../../GLOSSARY.md#topology), and the topology is the main result of a tree run.

The lengths matter too. On the default drawing, the horizontal length of a branch is its [branch length](../../GLOSSARY.md#branch-length), the estimated number of substitutions per site accumulated along it. A site is one column of the alignment, meaning one position compared across all your sequences. So a branch length of 0.06 means about six substitutions for every hundred sites, and a branch length of 0.9 means the two ends are separated by roughly one inferred change per site. A long branch means a lot of inferred change. A tree drawn this way is called a [phylogram](../../GLOSSARY.md#phylogram).

![Rectangular phylogram with tips, internal nodes, branch lengths, and support values](../../assets/illustrations-imagegen/02-sequences/05-building-trees/tree-anatomy.png)

Lungfish Genome Explorer (LGE) builds trees with [IQ-TREE](../../GLOSSARY.md#iqtree), which uses [maximum likelihood](../../GLOSSARY.md#maximum-likelihood). Your alignment is the fixed evidence and the tree is what gets scored against it. Maximum likelihood tries the trees it can build from your alignment and keeps the one that makes the observed columns most probable under an assumed model of how bases change. That assumed model is the [substitution model](../../GLOSSARY.md#substitution-model), a set of rates for turning one base into another. Models differ in which changes they treat as more likely, because in real DNA an A-to-G change is more common than an A-to-T change, and a model that ignores that difference underestimates how much change a long branch really carries. IQ-TREE can pick the model for you.

A tree is only ever a summary of the alignment it came from. It cannot see anything the [alignment columns](../../GLOSSARY.md#alignment-column) do not contain, and a bad alignment gives a confident-looking bad tree. So read the alignment first, the way [Aligning Sequences](04-aligning-sequences.md) describes, and build the tree only once the alignment looks sound.

## Why you would do this

This chapter builds a tree from the five primate [mitochondrial genomes](../../GLOSSARY.md#mitochondrial-genome) that the previous chapter aligned. The five are human, chimpanzee, gorilla, rhesus macaque, and cynomolgus macaque.

The previous chapter got as far as a pairwise identity matrix, which says how similar every pair is. A matrix is not a history. It tells you the two macaques are the most similar pair, but it does not say whether the gorilla joins the human and the chimpanzee before or after the macaques split off. That question is about branching order, and branching order is what a tree answers.

The known primate relationships make this a good teaching set, because you can check the answer. The two macaques should be sisters, meaning the two tips that meet at the same internal node with nothing else between them. The human and the chimpanzee should be closer to each other than either is to the gorilla, and all three apes should sit apart from the two monkeys. A tree that says otherwise is reporting a problem with your run rather than news about primates.

Tree building is also the step where confidence has to be measured separately from the answer. The topology comes out looking equally crisp whether the data supported it strongly or barely at all. The support values this chapter turns on are the only thing that tells the two apart.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the primate mitochondrial genomes. Download the file `primate-mito.fasta` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/primate-mito and remember where you saved it.

The FASTA file is the raw material for the previous chapter, not for this one. This chapter starts from the alignment that chapter produced. Build it first by working through [Aligning Sequences](04-aligning-sequences.md), which leaves a `.lungfishmsa` [bundle](../../GLOSSARY.md#bundle) under `Analyses/Multiple Sequence Alignments/`. Keep the FASTA anyway, in case you want to rebuild the alignment.

IQ-TREE arrives in the `phylogenetics` [plugin pack](../../GLOSSARY.md#plugin-pack), a group of managed tools LGE installs privately for its own use without touching any other software on your Mac. Install it from **Tools > Plugin Manager...** (Cmd-Shift-B) before you start. Find the `phylogenetics` row in the list, click its Install button, and wait until the row's status reads Installed. The pack ships IQ-TREE 3.1.3. Docker is not involved, and no internet connection is needed once the pack is installed. Model testing is part of the run, so a pause after you click Run is the run working rather than the app freezing.

## Procedure

### Infer the tree

1. Double-click the `.lungfishmsa` bundle in the sidebar so its five rows are listed in the alignment viewport.

2. Click the first sequence name in the name gutter, the column of sequence names down the left side of the alignment, then Shift-click the last, so all five rows are selected. **Build Tree with IQ-TREE...** stays greyed out until at least two rows are selected, so a run with nothing selected is not possible.

3. Right-click inside the alignment and choose **Build Tree with IQ-TREE...**. The **Phylogenetic Tree Operations** dialog opens with the subtitle "Configure IQ-TREE for the selected multiple sequence alignment." Its Inputs section carries a Scope line reporting the rows and columns your selection carried in. With all five primate sequences selected the Scope line reports 5 rows. A smaller number means the selection did not take, so go back to step 2.

4. Set **Output Name** to `primate-mito`. Leave **Model** on `MFP`, short for ModelFinder Plus, which asks IQ-TREE to test many models against your data and use the one that fits best.

    <!-- SHOT: iqtree-dialog -->

5. Tick **Ultrafast Bootstrap** in the Branch Support group and leave its **Replicates** field on 1000. A replicate is one whole tree rebuilt from a resampled copy of your alignment columns, so 1000 replicates means a thousand rebuilt trees. Bootstrap is off by default, so a tree built without this step carries no support values at all and the next section has nothing to read. Then click Run.

Progress shows in the Operations panel, which you open with **Operations > Show Operations Panel** (Cmd-Shift-P). The row's status is what tells you it is done.

The new bundle appears in the sidebar under `Phylogenetic Trees/`, which is where the app puts every tree it writes. LGE creates that folder if the project does not have one yet. The alignment stays where it was, under `Analyses/Multiple Sequence Alignments/`. Double-click the new bundle to open the tree viewport.

There is no outgroup field in this dialog. Choosing a root is a separate step you take on the finished tree, described below.

### Try re-rooting, and check what comes back

Re-rooting is the step that turns a tree of groupings into a tree of ancestry. On this release it does not work, so the one step below is a demonstration of the check rather than a step you build on.

1. Right-click the gorilla tip and choose **Re-root Here**. A new bundle named `primate-mito-rerooted` appears under `Phylogenetic Trees/`.

2. Double-click the new bundle and read its summary line. It should say 5 tips. It says 13 tips instead, because the operation duplicates every tip except the new root. Stop here and keep using the original tree.

That tip count is the check to run on any re-rooted bundle, including ones you made before reading this. A re-rooted bundle with more tips than its source is the defect, and the tree inside it cannot support a claim about ancestry.

### Import a tree built elsewhere

A tree produced by another program can come in as a native bundle and use every viewport control in this chapter. Choose **File > Import Center...** (Cmd-Shift-I), open the Alignments tab, which holds tree cards alongside the alignment ones, and drop the file on the Phylogenetic Trees card. The card has no controls beyond a file panel, format detection is automatic, and each accepted file becomes one `.lungfishtree` bundle. It reads [Newick](../../GLOSSARY.md#newick) and Nexus, which covers IQ-TREE `.treefile` and `.contree` outputs as well as results from RAxML-NG and FastTree, two other tree-building programs.

## Settings

The Phylogenetic Tree Operations dialog holds thirteen settings, and the thirteen paragraphs that follow cover them all. Eleven sit in plain view and two sit inside a collapsed Advanced Options group. The Re-root and Extract subtree headings after them belong to different menu items and are counted separately.

**Output Name.** Names the `.lungfishtree` bundle the run writes into the project's `Phylogenetic Trees/` folder. The default is the alignment bundle's name with any `.lungfishtree` suffix removed, and Run stays disabled while the field is empty. Change it when the tree is one of several from the same alignment and the names would otherwise collide. On the command line this is `--name`.

**Model.** Names the substitution model, the set of assumptions about how one base turns into another. The default is `MFP`, which is not a model at all but an instruction to test many models on your data and use the one that fits best, so you do not have to choose. Name a model directly, such as `GTR+G`, meaning a general model that allows every base change its own rate plus an allowance for some sites changing faster than others, when a reviewer or a published method requires that exact model, or when model testing takes too long on a large alignment. On the command line this is `--model`.

**Sequence Type.** Tells IQ-TREE what the alignment characters are. The default is Auto, which lets IQ-TREE decide from the residues it sees, and the type it settled on is written into the run's IQ-TREE output in the Operations panel. Set it by hand when the alignment is a codon alignment, meaning one aligned in three-base blocks so that each block stays a whole codon, or pick NT to AA when you want a protein tree from nucleotide input, which translates the bases to amino acids before building the tree. On the command line this is `--sequence-type`, which takes `auto`, `DNA`, `AA`, `CODON`, `BIN`, `MORPH`, or `NT2AA`, where `NT2AA` is the same option the dialog calls NT to AA, and `BIN` and `MORPH` are for non-sequence data you can ignore here.

**Ultrafast Bootstrap.** Turns on branch support from resampled alignments, a procedure that rebuilds the tree many times from your alignment columns sampled again with replacement, meaning some columns are drawn twice and others not at all, and counts how often each grouping comes back. The default is off, which is the setting most likely to cost you, because a tree without support values cannot be read for confidence. Turn it on for any tree you plan to interpret or publish. On the command line this is `--bootstrap`, which both turns the bootstrap on and sets the replicate count, so `--bootstrap 1000` does the work of the tick box and the field together.

**Replicates (Ultrafast Bootstrap).** Sets how many resampled alignments the ultrafast bootstrap builds. On screen this field is labelled plain `Replicates`, and it is the one directly beside Ultrafast Bootstrap. The default is 1000, the value IQ-TREE's authors recommend for the ultrafast method, and more replicates make the numbers steadier at the cost of runtime. Change it rarely. On the command line this is the value you give to `--bootstrap`.

**SH-aLRT.** Turns on a second, faster support test that compares each branch against the alternatives immediately around it. The default is off, and a beginner does not need it, because the bootstrap alone answers the question of whether a grouping is trustworthy. The test reports on the same 0 to 100 scale as the bootstrap and the same reading applies, at or above 95 well supported and below 70 not to be relied on. Turn it on alongside the bootstrap when you want two independent support measures on every branch. On the command line this is `--alrt`.

**Replicates (SH-aLRT).** Sets how many replicates the [SH-aLRT](../../GLOSSARY.md#sh-alrt) test uses. This field is also labelled plain `Replicates` on screen, and it is the one beside SH-aLRT rather than the one beside Ultrafast Bootstrap. The default is 1000, and as with the bootstrap more replicates cost time and steady the numbers. Change it rarely. On the command line this is the value you give to `--alrt`.

**Seed.** Fixes the starting point of the random choices IQ-TREE makes, so the same alignment and the same seed give the same tree. The default is 1, a fixed number chosen on purpose so that rerunning the same alignment reproduces your result exactly rather than landing on a near miss. Change it when you want to check that a different random start reaches the same tree. On the command line this is `--seed`.

**Threads.** Sets how many processor cores IQ-TREE may use. The default is blank, which does not mean zero or unset. Blank means automatic, so the app picks a count that suits the machine. Set a small number, such as 2, to keep the machine responsive while a long inference runs. On the command line this is `--threads`.

**Safe numerical mode.** Makes IQ-TREE use slower arithmetic that avoids numerical underflow, a failure where the probabilities it multiplies together get too small for the computer to hold. The default is off, because the slower arithmetic is not worth paying for until you need it. Turn it on after a run stops with a message about the likelihood being not finite or numerical underflow, which appears in the run's IQ-TREE output in the Operations panel and happens most often on very long alignments. On the command line this is `--safe`.

**Keep identical sequences.** Keeps sequences that exactly match another sequence in the analysis. The default is off, because IQ-TREE otherwise removes the duplicates, infers the tree faster, and puts them back on the finished tree with the same topology, where each restored duplicate appears as a tip on a zero-length branch beside its identical twin. Turn it on when you need every input name to appear as its own tip with its own branch length. On the command line this is `--keep-identical`.

**IQ-TREE Executable.** Points the run at a specific IQ-TREE program file instead of the one the app manages. The default is empty, meaning the `iqtree3` program from the `phylogenetics` pack, which is the version this manual documents, and most readers never need to touch this field. Set it when you must reproduce a result with a particular IQ-TREE version. On the command line this is `--iqtree-path`.

**IQ-TREE Parameters.** Passes text straight to IQ-TREE after the settings above. The default is empty, and the dialog checks that whatever you type parses as command-line arguments before it will run. Use it for an IQ-TREE option the dialog does not expose, which is a matter for IQ-TREE's own documentation rather than this chapter. On the command line this is `--extra-iqtree-options`.

### Re-root

Re-rooting shows no dialog. It runs on the node you right-clicked and writes a new bundle, leaving the original untouched.

Re-rooting is broken in this release. Both **Re-root Here** in the window and `lungfish-cli tree reroot` write a bundle in which every tip except the new root is duplicated, so the five-tip primate tree comes back reporting thirteen tips. The sign is a re-rooted bundle whose summary line reports more tips than the tree it came from. Do not build on a re-rooted tree until a later release fixes this. The two settings below are documented as designed, because the controls are real and the defect is in what the operation writes.

**Node to root on.** Sets which node becomes the base of the tree, so every branch is redrawn as leading away from it. The default is the node you right-clicked, and re-rooting is meant to change what the picture says about ancestry while leaving the branch lengths and the groupings alone, which is what it will do once the duplication defect above is fixed. Root on a known [outgroup](../../GLOSSARY.md#outgroup), meaning a sequence you are confident falls outside the group you are studying, because an unrooted tree cannot say which lineage came first. On the command line this is `--on`, which accepts a tip label, an internal node label, or a normalized node ID, the app's own internal name for a node.

**Output bundle name.** Names the new `.lungfishtree` bundle written into the project's `Phylogenetic Trees/` folder. The default is the source bundle name with `-rerooted` appended, and the viewport does not offer the field, so the number after `-rerooted` grows if you re-root more than once. Change it rarely, because the command line takes the path directly. On the command line this is `--output`.

### Extract subtree

Neither of the two subtree items, **Extract Subtree as New Bundle...** and **Export Subtree...**, shows a dialog either. Each runs on the node you right-clicked.

**Node to extract.** Chooses the [clade](../../GLOSSARY.md#clade) that becomes the new tree, meaning that node and everything descended from it. The default is the node you right-clicked, and everything outside the clade is left behind. Pick the node whose descendants are the group you want to look at on its own, such as one well supported lineage inside a large tree. On the command line this is `--node`.

**Output bundle name.** Names the new `.lungfishtree` bundle that **Extract Subtree as New Bundle...** writes into the project's `Phylogenetic Trees/` folder. The default is the node label with `-subtree` appended, and the viewport does not offer the field. Change it rarely, because the command line takes the path directly. On the command line this is `--output`.

**Export file name.** Names the plain Newick file that **Export Subtree...** writes through a save panel. The default is the node label with `.nwk` appended, and Newick is the one-line bracketed text format that nearly every tree program reads. Change it in the save panel when another program expects a particular file name. On the command line this is `--output` on `tree export subtree`.

The Phylogenetic Trees import card has no settings at all. Its three command-line options are covered in the last section.

## Reading the results

<!-- SHOT: tree-viewport-primate-mito -->

### The shape of the viewport

A summary line runs above the toolbar. It gives the bundle name, then the tip count, then the internal node count, then the word rooted or unrooted, separated by wide spacing rather than by punctuation. On the primate tree it reads `primate-mito   5 tips   3 internal nodes   unrooted`. Unrooted is what IQ-TREE always produces, so the word is the expected outcome rather than a sign your run failed.

The tree itself fills the canvas, drawn as a rectangular phylogram. Below it a detail line reports the selected node. Below that, a `Nodes` drawer runs across the bottom of the window and lists every tip and internal node in a table with five columns, `Node`, `Type`, `Tips`, `Branch`, and `Support`. Click a row to center that node on the canvas, and clicking a node on the canvas highlights its row in turn.

The toolbar carries the working controls. One segmented control, meaning a small button divided into two or three labelled parts, switches the drawing between `Phylogram` and `Cladogram`. A [cladogram](../../GLOSSARY.md#cladogram) sets every tip at the same depth and shows only who joins whom, which is easier to read when one branch is so long it squashes the rest. A second segmented control switches branch colouring between `None`, `Support`, and `Branch`, where `Support` shades each branch by its support value and `Branch` shades it by its branch length. A `Tip labels` popup lists `Original` first and then any column found in the bundle's `metadata.tsv`, a file you can add yourself as described under Relabelling tips from metadata below, and the popup stays disabled when the bundle has no such file. A `Find tip or node` search field selects and centers the first node whose label or metadata matches what you typed, rather than hiding the rest. Four icon buttons zoom in, zoom out, fit the tree to the window, and reset the view.

Selecting a node fills the Inspector with its detail rows. Every node reports `Node`, `Type`, and `Descendant Tips`. Every node except the root sits at the end of a branch, and those nodes add `Branch Length` and `Cumulative Divergence`, the summed branch length back to the root. Where support values are present, `Support` and `Support Type` appear as well.

### The numbers on this tree

The primate tree has 5 tips and 3 internal nodes. Read that against the input. Five sequences give five tips, always. An unrooted tree can hold at most the number of tips minus two internal nodes, which for five tips is three, so three means IQ-TREE resolved every grouping it could and left nothing unresolved. Fewer than three would mean the alignment could not separate some of the sequences.

The topology is the finding, and on an unrooted tree it is best read as a set of splits, meaning the two groups of tips you get by cutting one branch. Written as Newick, the tree is this.

```text
(Human_NC_012920.1:0.0601,Chimp_NC_001643.1:0.0589,(Gorilla_NC_011120.1:0.0740,(RhesusMacaque_NC_005943.1:0.0650,CynomolgusMacaque_NC_012670.1:0.0299):0.8982):0.0296);
```

Newick nests groups inside brackets. The innermost bracket pair, `(RhesusMacaque_NC_005943.1:0.0650,CynomolgusMacaque_NC_012670.1:0.0299)`, is the macaque pair, and cutting the branch below it splits the two macaques from the three apes. The bracket around it appears to add the gorilla to the macaques, but on an unrooted tree that nesting is only a way of writing the tree down. What the bracket records is the branch that separates the gorilla and the macaques on one side from the human and the chimpanzee on the other. Read from the other end, that same branch is what makes the human and the chimpanzee each other's closest relatives. The order the tips are written in carries no meaning. The outermost bracket splits three ways rather than two, into human, chimpanzee, and the rest. That three-way split at the top is what unrooted looks like written down. A rooted tree would split two ways there.

Those two splits answer the check set out earlier in this chapter. The macaques are sisters, the human and the chimpanzee are closer to each other than either is to the gorilla, and the three apes sit on one side of a branch with the two monkeys on the other. All three expected relationships are present. What the unrooted tree cannot say is which lineage branched off first, because that needs a root. The gorilla appearing to sit beside the macaques on the canvas is an artefact of drawing an unrooted tree from an arbitrary starting point, not a claim that gorillas are monkeys.

The macaque pair is the point to check. Those two sit on branches of 0.0650 and 0.0299 substitutions per site, and the cynomolgus macaque's 0.0299 is the shortest tip branch in the tree. They are joined by a branch of 0.8982 that separates them from everything else. That long branch is the ape-to-monkey split, and at 12 times the longest tip branch, the gorilla's 0.0740, it is what tens of millions of years of separation looks like in mitochondrial DNA. One branch dominating a small tree this way is normal on a set that spans that much time.

Cumulative divergence puts the same fact another way. Select the cynomolgus macaque tip and the Inspector reports a cumulative divergence of about 0.958, while the human tip reports about 0.060. On an unrooted tree the number sums back to the drawing's left edge rather than to a real ancestor, so it is illustrative here rather than a number worth checking on its own. The monkeys sit far from the point the tree is currently drawn from and the apes sit close to it.

### Support values and rooting

If you ticked Ultrafast Bootstrap, each internal node carries a number, and it is the percentage of resampled trees that recovered that exact grouping. A [support value](../../GLOSSARY.md#support-value) at or above 95 is usually treated as well supported, and one below 70 should not be relied on. Between 70 and 95 the grouping is likely but unsettled, so report it as provisional and say so rather than treating it as established. Switch the colour control to `Support` to shade the branches by that number rather than reading each one.

If you did not tick it, there are no numbers at all, and the `Support` column of the Nodes drawer is empty down its whole length. That empty column is the usual sign the box was left unticked, not a sign the data was uninformative.

The summary line's last word matters just as much. IQ-TREE produces an unrooted tree, and the fixture tree reports `unrooted`. An unrooted tree states who groups with whom and nothing about which lineage came first. The apparent root at the left edge of the canvas is a drawing convention with no biological meaning, which is why the cumulative divergence numbers above sum back to an arbitrary point. To make a claim about ancestry you would re-root the tree on an [outgroup](../../GLOSSARY.md#outgroup) yourself. On this release you cannot, because re-rooting duplicates tips as described above, so the primate tree in this chapter stays unrooted.

### Acting on a node

Right-click a tip or an internal node for the ten items that act on it. All ten are named below. **Show in Inspector**, **Copy Node Label**, and **Center Node** work on any selected node, and so does **Reveal Provenance**, which shows the [provenance](../../GLOSSARY.md#provenance) record of how this bundle was made. **Copy Subtree as Newick** puts that clade's Newick text on the clipboard.

**Re-root Here** is meant to write a new bundle rooted on the node you clicked. On this release the bundle it writes duplicates every tip except the new root, so treat its output as unusable until the defect is fixed. **Collapse Clade** folds an internal node's descendants into a single point on screen, and the same item then reads **Expand Clade** to undo it. It changes the drawing only and never the saved tree. It is disabled on a tip, which has nothing to fold. Click a tip to select it, Shift-click more tips to build a set, then choose **Copy Selected Tip Names** to put one name per line on the clipboard.

Two items lift out a clade, and they differ in what they write. **Extract Subtree as New Bundle...** produces a fresh `.lungfishtree` bundle with its own [provenance](../../GLOSSARY.md#provenance). **Export Subtree...** writes a plain `.nwk` Newick file through a save panel, for handing to a program outside LGE.

### Relabelling tips from metadata

Tip labels come straight from the alignment row names, which are often accession-heavy. To show something more readable, add a tab-separated `metadata.tsv` file at the root of the tree bundle. A bundle looks like a single file in the Finder but is really a folder, so right-click it and choose Show Package Contents to get inside, then save the file there. Its identifier column must be named `id`, `sample`, `sample_id`, `name`, or `tip`, matched without regard to case, and any other column becomes a labelling choice.

```tsv
id	species
Human_NC_012920.1	Human
Chimp_NC_001643.1	Chimpanzee
Gorilla_NC_011120.1	Gorilla
RhesusMacaque_NC_005943.1	Rhesus macaque
CynomolgusMacaque_NC_012670.1	Cynomolgus macaque
```

Reopen the bundle and pick the column from the `Tip labels` popup, which changes only what is drawn. Making the new labels permanent is a command-line job. Run `tree relabel` as shown in the last section, because the window has no equivalent control. On the primate tree with the file above, the relabelled Newick reads `(Human:0.0601...,'Rhesus macaque':0.0650...)`, where the three dots stand for digits left out here and the space-carrying labels are quoted.

## What good looks like

Five checks are worth running before you trust a tree.

Confirm the tip count matches your input. Five sequences in should give five tips out, with the names unchanged. A missing tip usually means IQ-TREE dropped an identical sequence, which **Keep identical sequences** prevents. Nothing in the window announces the drop, so counting the tips is how you find it, and IQ-TREE's own output in the Operations panel names the sequence it removed.

Confirm the topology matches what you already know. On this tree the two macaques are sisters, the human and the chimpanzee are sisters, and the apes and the monkeys sit on opposite sides of the long branch, which is what the primates are known to do. Only the order in which the lineages branched off is beyond an unrooted tree. When a set with known relationships comes back rearranged, suspect a mislabelled input before you suspect a discovery.

Confirm the support values are there and are high. Without the bootstrap box ticked the `Support` column is empty, which is a run to redo rather than a result to read. With it ticked, values below 70 mark groupings the alignment did not really settle.

Confirm no single branch dwarfs the whole tree unexpectedly. The 0.8982 branch separating apes from monkeys here is expected. An unexpected branch that long usually means one input is far more distant than the others, or is not the same gene at all.

Confirm that any bundle whose name ends in `-rerooted` has the same tip count as the tree it came from. On this release it will not, because re-rooting duplicates tips, and a bundle reporting thirteen tips from a five-tip tree is that defect rather than a real result. Do not build on a re-rooted tree until a later release fixes it.

When a run does go wrong, the alignment is usually the cause. Identical or near-identical sequences give zero-length branches and low support everywhere. A short alignment carries too little signal for confident support, so expect values in the 50s to 70s and do not over-read them. What counts is informative columns, meaning columns where at least two different bases each appear in at least two sequences, since a column every sequence agrees on cannot separate anything. IQ-TREE reports that count as parsimony-informative sites in its own output, and under a few hundred is thin. If IQ-TREE reports that ModelFinder, the model-testing step the `MFP` setting turns on, settled on a model with very few parameters, the data is probably too uniform for the question. When none of that explains it, open the operation's row with **Operations > Show Operations Panel** (Cmd-Shift-P), where the full IQ-TREE output sits beside the resolved command line. Read that output from the bottom, because IQ-TREE prints the line that stopped the run last, beginning with the word ERROR.

## On the command line

This section is optional reference and you can skip it. Everything in the chapter so far can be done in the window, with one exception. Writing a permanently relabelled bundle with `tree relabel` exists only here, so that is the one reason to come back to this section.

The block below reproduces the whole chapter. The project is a `.lungfish` folder you already created, holding the alignment from the previous chapter.

```bash
PROJECT=~/Documents/primates.lungfish
MSA="$PROJECT/Analyses/Multiple Sequence Alignments/primate-mito.lungfishmsa"
TREES="$PROJECT/Phylogenetic Trees"

# Infer the tree. Both --project and --output are required.
lungfish-cli tree infer iqtree "$MSA" \
  --project "$PROJECT" \
  --output "$TREES/primate-mito.lungfishtree" \
  --name primate-mito \
  --model MFP \
  --bootstrap 1000

# Re-root on the gorilla as an outgroup to the two macaques.
# Broken in this release. It duplicates tips, turning 5 tips into 13.
# Check the tip count of the output before trusting the result.
lungfish-cli tree reroot \
  --bundle "$TREES/primate-mito.lungfishtree" \
  --on Gorilla_NC_011120.1 \
  --output "$TREES/primate-mito-rooted.lungfishtree"

# Pull the macaque clade out as its own bundle. The node ID comes from the
# bundle itself, as the paragraph after this block explains.
lungfish-cli tree extract-subtree \
  --bundle "$TREES/primate-mito.lungfishtree" \
  --node node-a4609f19185ceddd \
  --output "$TREES/macaques.lungfishtree"

# Relabel the tips from metadata.tsv into a new bundle.
lungfish-cli tree relabel \
  --bundle "$TREES/primate-mito.lungfishtree" \
  --column species \
  --output "$TREES/primate-mito-species.lungfishtree"

# Bring a tree built elsewhere into the project.
lungfish-cli import tree my-tree.nwk --project "$PROJECT"
```

`tree infer iqtree` takes the alignment bundle as its argument, plus `--project` for staging and `--output` for the bundle path, and every dialog setting reaches it as the flag named in that setting's paragraph above. Four more options exist only here. `--rows` restricts the run to named rows and `--columns` to 1-based column ranges, which is what the GUI does with the selection you made before opening the dialog. `--extra-args` passes further arguments to IQ-TREE verbatim alongside `--extra-iqtree-options`, and `--force` overwrites an existing output bundle.

The node selectors on `tree reroot` and `tree extract-subtree` resolve in a fixed order. A normalized node ID such as `node-a4609f19185ceddd` is matched first, then a display label or raw label. A label that matches more than one node is refused with `Tree node label is ambiguous`, and a label that matches none is refused with `Tree node not found`. This matters for internal nodes, because every unlabelled internal node in the primate tree displays as `Internal node` and so can only be named by its ID. Read the IDs out of the bundle's `tree/primary.normalized.json`, or click the node in the viewport and use the right-click menu instead.

`tree export subtree` is the Newick counterpart to `extract-subtree`. It takes the bundle as an argument, then either `--node` for a node ID or `--label` for a unique display label, plus `--output` for the `.nwk` path, `--output-format` (newick is the only value supported), and `--force`.

`import tree` takes `--project` for the destination and adds `--source-format` to force a file to be read as `newick` or `nexus` when its extension does not match its contents, `--name` to set the bundle's display name, and `--output` to write the bundle to an explicit path. Without `--output` it lands in `Phylogenetic Trees/`, the same folder the app uses.

## Next

This is the last chapter in Sequences. Continue to [Importing FASTQ](../03-reads/01-importing-fastq.md), the first chapter of Reads (FASTQ), for workflows that start from raw sequencing data.
