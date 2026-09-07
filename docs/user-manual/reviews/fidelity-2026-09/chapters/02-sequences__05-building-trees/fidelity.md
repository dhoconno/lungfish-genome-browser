# Fidelity review: 02-sequences/05-building-trees

Chapter: `docs/user-manual/chapters/02-sequences/05-building-trees.md`

This is the new chapter split out of the retired `04-msa-and-trees.md`. The
DRIFT Part A entry for `02-sequences.md/04-msa-and-trees.md` (near line 595)
describes the pre-split text, so its tree-side rows are treated as guidance
rather than as verdicts on this chapter.

Ground truth used, in campaign order: the Swift source under `Sources/`, the
`lungfish-cli` help tree under `reviews/fidelity-2026-09/cli-help/`, the tool
lock manifest, `parameters.yaml`, the reality map
`ground-truth/02-sequences.md`, and `CONSISTENCY.md`. Live CLI runs were made
against the author's scratch project at
`.../scratchpad/primate-msa/proj.lungfish` and the fixture tree
`docs/user-manual/fixtures/primate-mito/expected/primate-mito.treefile`, under
the allowance in the brief. Every quoted number, Newick string, and error
message below was rechecked against a real run or a real source line.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues on this chapter.

## The two reported CLI defects

**`tree reroot` corrupts the tree. Confirmed, and worse than a display bug.**

```
$ lungfish-cli tree reroot \
    --bundle ".../Phylogenetic Trees/primate-mito.lungfishtree" \
    --on Gorilla_NC_011120.1 \
    --output ".../Phylogenetic Trees/primate-mito-rooted.lungfishtree"
Wrote tree bundle: .../primate-mito-rooted.lungfishtree
Provenance: .../primate-mito-rooted.lungfishtree/.lungfish-provenance.json
```

Exit status 0, no warning. The written tree is this.

```
(Gorilla_NC_011120.1:0.0,((RhesusMacaque_NC_005943.1:0.0650378784,CynomolgusMacaque_NC_012670.1:0.0298967035,CynomolgusMacaque_NC_012670.1:0.0298967035,RhesusMacaque_NC_005943.1:0.0650378784):0.8982249461,(Human_NC_012920.1:0.0601418813,Chimp_NC_001643.1:0.0589380925,Chimp_NC_001643.1:0.0589380925,Human_NC_012920.1:0.0601418813):0.0295655762,(RhesusMacaque_NC_005943.1:0.0650378784,CynomolgusMacaque_NC_012670.1:0.0298967035,CynomolgusMacaque_NC_012670.1:0.0298967035,RhesusMacaque_NC_005943.1:0.0650378784):0.8982249461):0.0740422285);
```

The written manifest agrees that the result is wrong.

```
$ grep -o '"tipCount"[^,]*\|"internalNodeCount"[^,]*\|"isRooted"[^,]*' \
    .../primate-mito-rooted.lungfishtree/manifest.json
"internalNodeCount" : 5
"isRooted" : true
"tipCount" : 13
```

Thirteen tips from a five-tip tree, exactly as reported. Every tip except the
new root is duplicated, and the macaque clade appears twice.

**The window's Re-root Here shares the defect exactly.** The viewport does not
re-root in process. `PhylogeneticTreeViewController.rerootSelectedNode`
(`Sources/LungfishPhylogeneticsUI/PhylogeneticTreeViewController.swift:880`)
only raises a `TreeBundleOperationRequest`, and
`TreeBundleTransformCommand.arguments`
(`Sources/LungfishApp/Views/Viewer/ViewerViewController.swift:4189-4196`)
turns that into the identical CLI invocation.

```swift
case .reroot:
    return [
        "tree", "reroot",
        "--bundle", bundlePath,
        "--on", request.nodeID,
        "--output", outputPath,
        "--format", "json",
    ]
```

So a reader who follows the chapter's Re-root Here instructions in the window
gets the same 13-tip bundle the CLI produces. The chapter's re-root wording is
therefore accurate about the design and unsafe as advice, because it tells the
reader to root on an outgroup to make an ancestry claim and the tree they get
back cannot support one. The two re-root rows below are marked false on that
basis, and the corrected wording adds the warning rather than deleting the
feature.

**`tree extract-subtree` is not affected.** The same bundle and the same node
ID produce a correct two-tip clade.

```
$ lungfish-cli tree extract-subtree --bundle ... --node node-a4609f19185ceddd --output .../macaques.lungfishtree
(RhesusMacaque_NC_005943.1:0.0650378784,CynomolgusMacaque_NC_012670.1:0.0298967035):0.8982249461;
"internalNodeCount" : 1
"tipCount" : 2
```

**`tree infer iqtree` mangling its output into `.../fishmsa/`. Refuted as
described.** The one permitted inference run wrote nothing to any `fishmsa`
path. It failed for an unrelated reason.

```
$ lungfish-cli tree infer iqtree ".../primate-mito.lungfishmsa" \
    --project ./proj.lungfish \
    --output "./proj.lungfish/Phylogenetic Trees/inferred.lungfishtree" \
    --name inferred --model MFP --bootstrap 1000
Error: The file ".lungfish-provenance.json" couldn't be opened because there is no such file.
```

No `inferred.lungfishtree` and no `fishmsa` directory exist anywhere under the
scratch project afterwards, because the command's own `catch` block removes the
output bundle on any failure
(`Sources/LungfishCLI/Commands/TreeCommand.swift:595-597`). The output path is
used verbatim throughout the command, from
`let outputURL = URL(fileURLWithPath: outputPath).standardizedFileURL`
(`TreeCommand.swift:441`) through to `emitter.emitComplete(output: outputURL.path)`,
with no string surgery on it. The real cause is the input side. The scratch
`primate-mito.lungfishmsa` bundle has no `.lungfish-provenance.json` at its
root, and `rewriteManifestAndProvenance` hashes the whole input bundle through
`fileRecord(path:url:)` (`TreeCommand.swift:1250`, `:1343-1350`) after IQ-TREE
has already run. A bundle written by `align mafft` always carries that file
(`MultipleSequenceAlignmentBundle.swift:968`), so this is a hand-assembled
scratch bundle failing, not the documented path failing. The `.../fishmsa/`
detail in the report is most likely a truncated rendering of a
`...lungfishmsa/` path in an error line, since nothing in the code can produce
that directory name. Marked unverifiable rather than refuted only where the
chapter would depend on it, which it does not.

## Claims

| Claim | Verdict | Evidence | Correction |
|---|---|---|---|
| "Each sequence you put in becomes a tip ... Every place two branches meet is an internal node" | true | Definitional, and matches `PhylogeneticTreeNormalizedNode.isTip` / `childIDs` (`PhylogeneticTreeBundle.swift:336-350`) | |
| "the horizontal length of a branch is its branch length, the estimated number of substitutions per site" | true | The fixture Newick carries substitutions-per-site branch lengths from IQ-TREE, and the canvas draws Phylogram first (`PhylogeneticTreeViewController.swift:78-79`) | |
| "LGE builds trees with IQ-TREE, which uses maximum likelihood" | true | `tree.txt:38-39`, "Infer a maximum-likelihood tree from a .lungfishmsa bundle using IQ-TREE" | |
| "the five primate mitochondrial genomes ... human, chimpanzee, gorilla, rhesus macaque, and cynomolgus macaque" | true | `fixtures/primate-mito/README.md` genome table, all five accessions | |
| "The two macaques should be sisters. The human and the chimpanzee should be closer to each other than either is to the gorilla" | true as a statement of expected primate phylogeny | Standard primate relationships. Note this is the reader's grading rubric, not a claim about what the fixture tree shows, which is checked separately below | |
| "choose **File > New Project** (Cmd-N)" | true | `MainMenu.swift:169-173`, title "New Project", keyEquivalent "n" | |
| "IQ-TREE arrives in the `phylogenetics` plugin pack" | true | `third-party-tools-lock.json` packTools[17], `"packID": "phylogenetics", "id": "iqtree"` | |
| "Install it from **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:773-780`, title "Plugin Manager…", "b" with `[.command, .shift]` | |
| "The pack ships IQ-TREE 3.1.3." | true | `third-party-tools-lock.json` packTools[17], `"version": "3.1.3"`, executable `iqtree3` | |
| "The inference on this five-sequence alignment takes well under two minutes on a current Mac." | unverifiable | A runtime claim. The one permitted inference run failed on an unrelated input defect before completing, so no timing was observed. The fixture `regenerate.sh` does not record a duration | Settled by timing a successful `tree infer iqtree` on a bundle written by `align mafft`. Soften or drop if that is not done |
| Step 2, "**Build Tree with IQ-TREE...** stays greyed out until at least two rows are selected" | true | `MultipleSequenceAlignmentViewController.swift:1660`, `treeItem.isEnabled = bundleURL != nil && selectedRowIndices.count >= 2` | |
| Step 3, "the **Phylogenetic Tree Operations** dialog opens with the subtitle 'Configure IQ-TREE for the selected multiple sequence alignment.'" | true | `IQTreeInferenceDialog.swift:96-99`, both strings verbatim including the final period | |
| Step 3, "Its Inputs section carries a Scope line reporting the rows and columns your selection carried in." | true | `IQTreeInferenceDialog.swift:253-255` places `labeledValue("Scope", ...)` in the Inputs section, fed by `scopeSummary` (`:110-121`), which reports a row count and a column range | |
| Step 4, "Leave **Model** on `MFP`" | true | `IQTreeInferenceDialog.swift:80`, `self.model = "MFP"`; `tree.txt:52`, "(default: MFP)" | |
| Step 5, "Tick **Ultrafast Bootstrap** in the Branch Support group and leave its **Replicates** field on 1000." | true | `IQTreeInferenceDialog.swift:318-322` under a `Text("Branch Support")` header (`:315`); `:82-83`, `bootstrapEnabled = false`, `bootstrapReplicates = 1000` | |
| Step 5, "Bootstrap is off by default" | true | `IQTreeInferenceDialog.swift:82`, `self.bootstrapEnabled = false`; `tree.txt:56` gives `--bootstrap` no default | |
| Step 5, "Then click Run." | true | `DatasetOperationsDialog` is driven by `onRun` / `isRunEnabled` (`IQTreeInferenceDialog.swift:216-224`), and the campaign template fixes the button text as Run | |
| "The new bundle appears in the sidebar under `Phylogenetic Trees/`, which is where the app puts every tree it writes." | true | `ViewerViewController.swift:2155-2161` for inference and `:2254-2260` for the re-root and subtree transforms both build `projectURL.appendingPathComponent("Phylogenetic Trees")`. `import tree` agrees, verified live below | |
| "The alignment stays where it was, under `Analyses/Multiple Sequence Alignments/`." | true | CONSISTENCY.md "Folders and files", verified by a CLI run on 2026-09-06, and by the scratch project's own layout | |
| "There is no outgroup field in this dialog." | true | `IQTreeInferenceDialog.swift:250-305` enumerates every control, and none is an outgroup | |
| "Choose **File > Import Center...** (Cmd-Shift-I), open the Alignments tab, and drop the file on the Phylogenetic Trees card." | true | `MainMenu.swift:207-213`, "Import Center…", "i" with `[.command, .shift]`; `ImportCenterViewModel.swift:366-371`, card id `phylogenetic-tree`, title "Phylogenetic Trees", `tab: .alignments` | |
| "The card has no controls beyond a file panel, format detection is automatic, and each accepted file becomes one `.lungfishtree` bundle." | true | `ImportCenterViewModel.swift:372-388`, `importKind: .openPanel` with `allowsMultipleSelection: true` and no settings; `parameters.yaml` `import.tree` has `settings: []` | |
| "It reads Newick and Nexus, which covers IQ-TREE `.treefile` and `.contree` outputs as well as RAxML-NG and FastTree results." | true | `import.txt`, `--source-format` "newick or nexus"; `ImportCenterViewModel.swift:368-382`, the description names IQ-TREE, RAxML-NG, and FastTree and the allowed types include `.treefile` and `.contree` | |
| "The Phylogenetic Tree Operations dialog holds thirteen settings. Eleven sit in plain view and two sit inside a collapsed Advanced Options group." | true | Counting `IQTreeInferenceDialog.swift:258-303`: Output Name, Model, Sequence Type, Ultrafast Bootstrap, its Replicates, SH-aLRT, its Replicates, Seed, Threads, Safe numerical mode, Keep identical sequences is eleven, plus IQ-TREE Executable and IQ-TREE Parameters inside the `DisclosureGroup` labelled "Advanced Options" (`:288-303`). Thirteen matches the thirteen `settings:` entries under `tree.iqtree` in `parameters.yaml` | |
| **Output Name.** "The default is the alignment bundle's name with any `.lungfishtree` suffix removed, and Run stays disabled while the field is empty." | true | `IQTreeInferenceDialog.swift:78` seeds from `normalizedOutputName(request.suggestedName)`, and `:196-202` strips a trailing `.lungfishtree`; `:139-141` returns "Enter an output name." which drives `isRunEnabled` (`:133-135`) | |
| **Output Name.** "On the command line this is `--name`." | true | `tree.txt:51`, `--name <name>` "Output tree bundle name" | |
| **Model.** default `MFP`, flag `--model` | true | `IQTreeInferenceDialog.swift:80`; `tree.txt:52` | |
| **Sequence Type.** "The default is Auto ... On the command line this is `--sequence-type`, which takes `auto`, `DNA`, `AA`, `CODON`, `BIN`, `MORPH`, or `NT2AA`." | true | `IQTreeInferenceDialog.swift:81`, `sequenceType = .auto`; `tree.txt:53-55` lists exactly those seven values with "(default: auto)" | |
| **Sequence Type.** "it decides correctly on a full mitochondrial genome" | unverifiable | A claim about IQ-TREE's autodetection on this data. The permitted inference run did not complete, so no run log shows what Auto resolved to | Settled by reading the `sequenceType` recorded in a successful run's `.lungfish-provenance.json` options, or IQ-TREE's own log |
| **Ultrafast Bootstrap.** default off, flag `--bootstrap` | true | `IQTreeInferenceDialog.swift:82`; `tree.txt:56` | |
| **Replicates (Ultrafast Bootstrap).** "The default is 1000 ... On the command line this is the value you give to `--bootstrap`." | partly false, see correction | The default and the flag are right (`IQTreeInferenceDialog.swift:83`; `tree.txt:56`), but the control's on-screen label is plain `Replicates`, not `Replicates (Ultrafast Bootstrap)` (`IQTreeInferenceDialog.swift:320`, `labeledCompactTextField("Replicates", ...)`). The parenthetical is a disambiguator inherited from `parameters.yaml`, and the campaign rule is that a Settings paragraph opens with the control's label | Open the paragraph **Replicates.** and say which one it is in the sentence, for example "**Replicates.** The Replicates field beside Ultrafast Bootstrap sets how many resampled alignments the ultrafast bootstrap builds." |
| **SH-aLRT.** default off, flag `--alrt` | true | `IQTreeInferenceDialog.swift:84`, `alrtEnabled = false`; `:326` toggle; `tree.txt:57` | |
| **Replicates (SH-aLRT).** "The default is 1000 ... the value you give to `--alrt`." | partly false, see correction | Same label problem. The second field is also labelled plain `Replicates` (`IQTreeInferenceDialog.swift:328`). Default 1000 is right (`:85`) | Open the paragraph **Replicates.** and identify it as the field beside SH-aLRT |
| **Seed.** "The default is 1, which means a rerun reproduces your result" | true | `IQTreeInferenceDialog.swift:86`, `self.seed = 1`; `tree.txt:58`, "(default: 1)" | |
| **Threads.** "The default is blank, which lets the app choose a count that suits the machine." | true | `IQTreeInferenceDialog.swift:87`, `self.threads = nil`; `TreeCommand.swift:483`, `globalOptions.threads.map(String.init) ?? "AUTO"` | |
| **Safe numerical mode.** default off, flag `--safe` | true | `IQTreeInferenceDialog.swift:88`; `:280` toggle titled "Safe numerical mode"; `tree.txt:59` | |
| **Keep identical sequences.** default off, flag `--keep-identical` | true | `IQTreeInferenceDialog.swift:89`; `:282` toggle titled "Keep identical sequences"; `tree.txt:60` | |
| **IQ-TREE Executable.** "The default is empty, meaning the `iqtree3` binary from the `phylogenetics` pack ... `--iqtree-path`." | true | `IQTreeInferenceDialog.swift:91`, `iqtreePath = ""`; `:291` field titled "IQ-TREE Executable"; `tree.txt:66-67`; `third-party-tools-lock.json` executables `["iqtree3"]` | |
| **IQ-TREE Parameters.** "the dialog checks that whatever you type parses as command-line arguments before it will run ... `--extra-iqtree-options`." | true | `IQTreeInferenceDialog.swift:157-162` runs `AdvancedCommandLineOptions.parse(extraIQTreeOptions)` inside `validationMessage`; `:293` field title; `tree.txt:61-63` | |
| "Re-rooting shows no dialog. It runs on the node you right-clicked and writes a new bundle, leaving the original untouched." | true | `PhylogeneticTreeViewController.swift:880-882` fires the request with no sheet; `ViewerViewController.swift:2254-2266` writes to a fresh `nextAvailableBundleURL` in `Phylogenetic Trees/` and never opens the source for writing | |
| **Node to root on.** "re-rooting changes what the picture says about ancestry while leaving the branch lengths and the groupings alone" | false | Reproduced above. The written tree duplicates every non-root tip and reports 13 tips from a 5-tip input, so the groupings do not survive. The window shares the defect, because `TreeBundleTransformCommand.arguments` (`ViewerViewController.swift:4189-4196`) issues the same `tree reroot` command | Say what the app does today. For example "Re-rooting is meant to redraw every branch as leading away from the node you chose while leaving the branch lengths and the groupings alone. On this release it does not. Both `tree reroot` and **Re-root Here** write a bundle in which every tip except the new root is duplicated, so a five-tip tree comes back reporting thirteen tips. Do not re-root until this is fixed, and check the tip count in the summary line of any re-rooted bundle you already have." |
| **Node to root on.** "On the command line this is `--on`, which accepts a tip label, an internal node label, or a normalized node ID." | true | `tree.txt:137-138`, "Tip label, internal node label, or normalized node ID to root on"; `PhylogeneticTreeBundle.resolveNode(selector:)` (`PhylogeneticTreeBundle.swift:118-131`) implements all three | |
| **Output bundle name.** (re-root) "The default is the source bundle name with `-rerooted` appended ... so the number after `-rerooted` grows if you re-root more than once." | true | `TreeBundleTransformCommand.outputStem` (`ViewerViewController.swift:4172-4174`) returns `"\(sourceStem)-rerooted"`, and `nextAvailableBundleURL` (`ViewerViewController.swift:2260`) appends a disambiguating number when that name is taken | |
| **Node to extract.** "The default is the node you right-clicked ... On the command line this is `--node`." | true | `PhylogeneticTreeViewController.swift:884-886` and `:912-919` carry `selectedNodeID`; `tree.txt:162`, `--node` "Normalized node ID or unique node label to extract" | |
| **Output bundle name.** (subtree) "The default is the node label with `-subtree` appended" | true | `ViewerViewController.swift:4176`, `return "\(request.nodeLabel)-subtree"` | |
| **Export file name.** "The default is the node label with `.nwk` appended ... `--output` on `tree export subtree`." | true | `PhylogeneticTreeViewController.swift:930-940` builds the save panel from the export's `selectedLabel`; `tree.txt:113`, `--output <output>` "Output Newick file path" | |
| "The Phylogenetic Trees import card has no settings at all." | true | `parameters.yaml` `import.tree` carries `settings: []`; `ImportCenterViewModel.swift:372-388` shows an open panel and nothing else | |
| "Its three command-line options are covered in the last section." | true | `import.txt` gives `import tree` exactly `--name`, `--source-format`, and `--output` beyond `--project` and the global flags, and all three appear in the chapter's last section | |
| "A summary line runs above the toolbar." | true | `PhylogeneticTreeViewController.swift:294-298`, the toolbar's top anchor is pinned to `summaryLabel.bottomAnchor` | |
| "It gives the bundle name, then the tip count, then the internal node count, then the word rooted or unrooted." | true | `PhylogeneticTreeViewController.swift:161-166`, `[name, "\(tipCount) tips", "\(internalNodeCount) internal nodes", isRooted ? "rooted" : "unrooted"].joined(separator: "   ")` | |
| "On the primate tree it reads `primate-mito   5 tips   3 internal nodes   unrooted`." | true | Verified live. `lungfish-cli import tree ... --name primate-mito` on the fixture treefile reported "Tips: 5 / Internal nodes: 3", and the bundle manifest carries `"isRooted" : false`. The three-space separator matches the source | |
| "Below it a detail line reports the selected node." | true | `PhylogeneticTreeViewController.swift:305-309` places `detailLabel` under the canvas, and `:674` sets it to `detailText(for: node)` on every selection. Before any selection it shows format, primary tree, and warnings (`:734-739`), which the chapter does not claim otherwise | |
| "On the right, a `Nodes` drawer lists every tip and internal node" | false | The drawer is at the bottom, not the right. `PhylogeneticTreeViewController.swift:311-314` pins it leading to trailing across the view with `nodeDrawer.bottomAnchor.constraint(equalTo: view.bottomAnchor)`, under the detail line | "Below that, a `Nodes` drawer runs across the bottom of the window and lists every tip and internal node" |
| "in a table with five columns, `Node`, `Type`, `Tips`, `Branch`, and `Support`" | true | `PhylogeneticTreeViewController.swift:222-226`, exactly those five titles in that order | |
| "Click a row to center that node on the canvas, and clicking a node on the canvas highlights its row in turn." | true | `PhylogeneticTreeViewController.swift:201-206`, `selectNode(id:center: true)` on table selection; `:677-683` selects and scrolls the matching row whenever a node is selected from the canvas | |
| "One segmented control switches the drawing between `Phylogram` and `Cladogram`." | true | `PhylogeneticTreeViewController.swift:78-83`, `NSSegmentedControl(labels: ["Phylogram", "Cladogram"], ...)` | |
| "A second segmented control switches branch colouring between `None`, `Support`, and `Branch`." | true | `PhylogeneticTreeViewController.swift:84-89`, `labels: ["None", "Support", "Branch"]` | |
| "A `Tip labels` popup lists `Original` first and then any column found in the bundle's `metadata.tsv`, and it stays disabled when the bundle has no such file." | true | `PhylogeneticTreeViewController.swift:625-631`, adds "Original" then `metadataColumnTitles`, and sets `isEnabled = !metadataColumnTitles.isEmpty` | |
| "A `Find tip or node` search field selects and centers the first node whose label or metadata matches what you typed, rather than hiding the rest." | true | `PhylogeneticTreeViewController.swift:548-558`, matches `displayLabel`, `rawLabel`, or any metadata value and calls `selectNode(id:center: true)`. Nothing filters the node list. This corrects DRIFT row 60, which said the field filters the tree | |
| "Four icon buttons zoom in, zoom out, fit the tree to the window, and reset the view." | true | `PhylogeneticTreeViewController.swift:74-77` creates all four with empty titles, and `:540-546` configures each through `configureInspectorIconButton(symbolName:)`; the actions are at `:559-577` | |
| "Every node reports `Node`, `Type`, and `Descendant Tips`." | true | `PhylogeneticTreeViewController.swift:698-702`, those three rows are unconditional | |
| "A node with a branch adds `Branch Length` and `Cumulative Divergence`, the summed branch length back to the root." | true | `PhylogeneticTreeViewController.swift:703-708`, both are appended only when the optional is present; `PhylogeneticTreeNormalization.swift:43`, `nodeDivergence = cumulativeDivergence + (node.branchLength ?? 0)` accumulates from the root | |
| "Where support values are present, `Support` and `Support Type` appear as well." | true | `PhylogeneticTreeViewController.swift:709-712` | |
| "The primate tree has 5 tips and 3 internal nodes." | true | Verified live. `import tree` on the fixture treefile printed "Tips: 5" and "Internal nodes: 3", and the bundle's `tree/primary.normalized.json` holds exactly five `"isTip" : true` nodes and three `"isTip" : false` nodes | |
| "A tree of five tips can hold at most three internal nodes" | true | A rooted binary tree on five tips has four internal nodes, but IQ-TREE writes an unrooted tree, whose maximum is n-2, that is three. The fixture tree is unrooted and has three | |
| "The two macaques join each other first. The gorilla joins that macaque pair. The human and the chimpanzee sit outside that group." | true | Reading the fixture Newick, `(Gorilla,(RhesusMacaque,CynomolgusMacaque))` sits as one clade beside Human and Chimp at the trifurcation. Note this is the tree's shape, not the expected primate phylogeny the chapter set out earlier, and the chapter is careful to present it as the finding rather than as a match | |
| The quoted Newick block | true | Character-for-character consistent with `fixtures/primate-mito/expected/primate-mito.treefile` once the branch lengths are rounded to four places, which the fixture README states explicitly. The full-precision file reads `0.0601418813, 0.0589380925, 0.0740422285, 0.0650378784, 0.0298967035, 0.8982249461, 0.0295655762` | |
| "Those two sit on the shortest branches in the tree, 0.0650 and 0.0299" | false | 0.0299 is the shortest tip branch, but 0.0650 is not the second shortest. The seven branch lengths are 0.0296, 0.0299, 0.0589, 0.0601, 0.0650, 0.0740, 0.8982. The internal branch 0.0295655762 is shorter than both macaque tips, and Chimp at 0.0589 and Human at 0.0601 are both shorter than the rhesus macaque's 0.0650 | "Those two sit on branches of 0.0650 and 0.0299 substitutions per site, and the cynomolgus macaque's is the shortest tip branch in the tree" |
| "they are joined by a branch of 0.8982 that separates them from everything else" | true | The fixture Newick puts `:0.8982249461` on the macaque clade's stem | |
| "it is more than ten times the length of any tip branch" | true | 0.8982 divided by the longest tip branch, the gorilla's 0.0740422285, is 12.1 | |
| "Select the cynomolgus macaque tip and the Inspector reports a cumulative divergence of about 0.958, while the human tip reports about 0.060." | true | Read straight out of the bundle. `tree/primary.normalized.json` carries `"cumulativeDivergence" : 0.9576872258` and `"cumulativeDivergence" : 0.0601418813`, and the Inspector formats with `String(format: "%.6g", ...)` (`PhylogeneticTreeViewController.swift:707`) | |
| "each internal node carries a number, and it is the percentage of resampled trees that recovered that exact grouping" | true | Standard ultrafast bootstrap semantics, and matches the `Support` / `Support Type` rows the viewport surfaces (`PhylogeneticTreeViewController.swift:709-712`) | |
| "A support value at or above 95 is usually treated as well supported, and one below 70 should not be relied on." | true | Matches the guidance recorded in `parameters.yaml` `tree.iqtree`, Ultrafast Bootstrap, "values at or above 95 are usually treated as well supported" | |
| "Switch the colour control to `Support` to shade the branches by that number" | true | `PhylogeneticTreeViewController.swift:84-89`, the `Support` segment | |
| "the `Support` column of the Nodes drawer is empty down its whole length" | true | `PhylogeneticTreeViewController.swift:196-199` renders the support cell from `node.support`, which is nil throughout a tree built without `--bootstrap` or `--alrt` | |
| "IQ-TREE produces an unrooted tree, and the fixture tree reports `unrooted`." | true | The imported fixture bundle's manifest carries `"isRooted" : false`, and the summary line reads that as `unrooted` (`PhylogeneticTreeViewController.swift:165`) | |
| "Right-click a tip or an internal node for the ten items that act on it." | true | `PhylogeneticTreeViewController.swift:766-857` adds exactly ten items with no separators. Show in Inspector, Copy Node Label, Copy Subtree as Newick, Re-root Here, Collapse Clade or Expand Clade, Extract Subtree as New Bundle…, Export Subtree…, Copy Selected Tip Names, Center Node, Reveal Provenance | |
| "**Show in Inspector**, **Copy Node Label**, **Center Node**, and **Reveal Provenance** work on any selected node." | true | `PhylogeneticTreeViewController.swift:776`, `:785`, `:846`, `:855`. Reveal Provenance is gated on `bundleURL != nil` rather than on the node, which is a weaker condition and does not contradict the sentence | |
| "**Copy Subtree as Newick** puts that clade's Newick text on the clipboard." | true | `PhylogeneticTreeViewController.swift:788-794` | |
| "**Re-root Here** writes a new bundle rooted on the node you clicked." | false | It writes a new bundle, but the bundle is not a correctly rooted copy of the tree. See the reproduction above. The claim reads as an assurance that the operation works | "**Re-root Here** is meant to write a new bundle rooted on the node you clicked. On this release the bundle it writes duplicates tips, so treat its output as unusable until the defect is fixed." |
| "**Collapse Clade** folds an internal node's descendants into a single point, and the same item then reads **Expand Clade** to undo it. It is disabled on a tip" | true | `PhylogeneticTreeViewController.swift:805-813`, the title flips on `collapsedNodeIDs.contains`, and `isEnabled` is `isTip == false`; the toggle itself is at `:888-899` | |
| "Click a tip to select it, Shift-click more tips to build a set, then choose **Copy Selected Tip Names** to put one name per line on the clipboard." | true | `PhylogeneticTreeViewController.swift:230-233` reads the Shift modifier into `extendingSelection`, `:668-672` accumulates only tips, and `:901-906` joins the labels with newlines | |
| "**Extract Subtree as New Bundle...** produces a fresh `.lungfishtree` bundle with its own provenance." | true | `PhylogeneticTreeViewController.swift:815-822`; verified live, the extraction wrote a bundle with a `.lungfish-provenance.json` and a correct 2-tip macaque clade | |
| "**Export Subtree...** writes a plain `.nwk` Newick file through a save panel" | true | `PhylogeneticTreeViewController.swift:824-831` and `:930-940`, which builds an `NSSavePanel` | |
| "Its identifier column must be named `id`, `sample`, `sample_id`, `name`, or `tip`, matched without regard to case" | true | `PhylogeneticTreeViewController.swift:610`, `["id", "sample", "sample_id", "name", "tip"].contains($0.lowercased())` | |
| "any other column becomes a labelling choice" | true | `PhylogeneticTreeViewController.swift:611-613` drops only the id column from `metadataColumnTitles` | |
| "Reopen the bundle and pick the column from the `Tip labels` popup, which changes only what is drawn." | true | `applyTipLabelColumn` (`PhylogeneticTreeViewController.swift:634-644`) rewrites the in-memory `nodes` from `originalNodes` and never touches the bundle on disk | |
| "To write a permanent relabelled bundle instead, use `tree relabel` on the command line." | true | `tree.txt:179-188`; `PhylogeneticTreeBundle.swift:99-116` writes a derived bundle | |
| "the relabelled Newick reads `(Human:0.0601...,'Rhesus macaque':0.0650...)`, with the space-carrying labels quoted" | true | Verified live with the chapter's own `metadata.tsv`. `tree relabel --column species` wrote `(Human:0.0601418813,Chimpanzee:0.0589380925,(Gorilla:0.0740422285,('Rhesus macaque':0.0650378784,'Cynomolgus macaque':0.0298967035):0.8982249461):0.0295655762);`, with exactly the single-quoting the chapter shows | |
| "A missing tip usually means IQ-TREE dropped an identical sequence, which **Keep identical sequences** prevents." | true | `tree.txt:60`, "Keep identical sequences in the IQ-TREE analysis"; `TreeCommand.swift:512-514` passes IQ-TREE's `-keep-ident` | |
| "The 0.8982 branch separating apes from monkeys here is expected." | true | The branch length is in the fixture tree, and it is the stem of the macaque clade | |
| "open the operation's row with **Operations > Show Operations Panel** (Cmd-Shift-P), where the full IQ-TREE output sits beside the resolved command line" | true | `MainMenu.swift:866-872`, "Show Operations Panel", "p" with `[.command, .shift]`; `TreeCommand.swift:1233-1244` records the external tool's `stdout`, `stderr`, and `command` in the bundle provenance, and `ViewerViewController.swift:2186-2194` registers the run with `OperationCenter` carrying `cliCommand` | |
| CLI block, "Both `--project` and `--output` are required." | true | `tree.txt:41`, the usage line marks both as required outside the optional-options bracket | |
| CLI block, `tree reroot --bundle ... --on ... --output ...` | true as a form, but the command is unsafe | `tree.txt:133` requires exactly those three. The command runs and exits 0, and produces the corrupt 13-tip bundle reproduced above | Keep the invocation and add a warning line in the comment above it, for example "# Re-root is currently broken and duplicates tips. Check the tip count before trusting the result." |
| CLI block, `--node node-a4609f19185ceddd` | true | The ID exists in the fixture bundle's `tree/primary.normalized.json` and resolves to the macaque clade. Verified live, extracting on it returned the two macaques | |
| CLI block, `lungfish-cli import tree my-tree.nwk --project "$PROJECT"` | true | `import.txt`, `import tree <input-file> --project <project>`. Verified live on the fixture treefile | |
| "`--rows` restricts the run to named rows and `--columns` to 1-based column ranges" | true | `tree.txt:49-50`, "Optional comma-separated row IDs or display names" and "Optional 1-based aligned column ranges, e.g. 10-40,55" | |
| "which is what the GUI does with the selection you made before opening the dialog" | true | `ViewerViewController.swift:2167-2170` passes `request.rows` and `request.columns` straight through to the builder | |
| "`--extra-args` passes further arguments to IQ-TREE verbatim alongside `--extra-iqtree-options`, and `--force` overwrites an existing output bundle." | true | `tree.txt:64-65` and `:68` | |
| "A normalized node ID such as `node-a4609f19185ceddd` is matched first, then a display label or raw label." | true | `PhylogeneticTreeBundle.resolveNode(selector:)` (`PhylogeneticTreeBundle.swift:118-131`) tries `$0.id == trimmed` first and only then filters on `displayLabel` or `rawLabel` | |
| "A label that matches more than one node is refused with `Tree node label is ambiguous`" | true | Verified live. `tree extract-subtree --node "Internal node"` printed `Error: Tree node label is ambiguous: Internal node`. Source at `PhylogeneticTreeBundle.swift:287-288`. This settles DRIFT row 68, which asked for confirmation against the command source | |
| "and a label that matches none is refused with `Tree node not found`" | true | Verified live. `--node "Nosuchnode"` printed `Error: Tree node not found: Nosuchnode`. Source at `PhylogeneticTreeBundle.swift:285-286` | |
| "every unlabelled internal node in the primate tree displays as `Internal node` and so can only be named by its ID" | true | All three internal nodes in the fixture bundle carry `"displayLabel" : "Internal node"`, which is exactly why the ambiguity error above fires | |
| "Read the IDs out of the bundle's `tree/primary.normalized.json`" | true | That file exists in every tree bundle produced above and carries an `"id"` per node | |
| "`tree export subtree` ... takes the bundle as an argument, then either `--node` for a node ID or `--label` for a unique display label, plus `--output` for the `.nwk` path, `--output-format` (newick is the only value supported), and `--force`." | true | `tree.txt:102-114`, all five listed, with `--output-format` "Currently only newick is supported (default: newick)" | |
| "`import tree` takes `--project` for the destination and adds `--source-format` ... `--name` ... and `--output`" | true | `import.txt`, the `import tree` block lists exactly those beyond the globals | |
| "Without `--output` it lands in `Phylogenetic Trees/`, the same folder the app uses." | true | Verified live. `import tree ... --project ./proj.lungfish --name primate-mito` with no `--output` wrote `.../proj.lungfish/Phylogenetic Trees/primate-mito.lungfishtree`, matching `ImportMSATreeSubcommands.swift:147` and the app path at `ViewerViewController.swift:2155` | |
| "This is the last chapter in Sequences." | true | `docs/user-manual/build/mkdocs.yml:78-79` ends the Sequences section with Building Trees | |

## Front matter

| Item | Verdict | Evidence |
|---|---|---|
| `parameters_refs: [tree.iqtree, tree.reroot, tree.extract-subtree, import.tree]` | true | All four ids exist in `docs/user-manual/parameters.yaml`, and the chapter documents every setting each one lists, subject to the two Replicates label corrections above |
| Every setting has a Settings paragraph with label, default, and allowed values | true | Thirteen for `tree.iqtree`, two for `tree.reroot`, three for `tree.extract-subtree`, and `import.tree` has none, which the chapter states explicitly |
| `shots:` lists every `<!-- SHOT -->` marker with a caption | true | The body carries exactly two markers, `iqtree-dialog` at line 74 and `tree-viewport-primate-mito` at line 138, and both are declared in `shots:` with captions |
| The `tree-viewport-primate-mito` caption says the Nodes drawer lists "all eight nodes" | true | Five tips plus three internal nodes is eight, and the drawer lists every node (`PhylogeneticTreeViewController.swift:178-180`, `numberOfRows` returns `nodes.count`) |
| Every `glossary_refs` anchor resolves in `GLOSSARY.md` | true | All 26 anchors resolve. Checked individually against `docs/user-manual/GLOSSARY.md` |
| Nav has both new entries and the old file is gone | true | `docs/user-manual/build/mkdocs.yml:78-79` carries Aligning Sequences and Building Trees. `docs/user-manual/chapters/02-sequences/` no longer holds `04-msa-and-trees.md` |
| The illustration path `assets/illustrations-imagegen/02-sequences/05-building-trees/tree-anatomy.png` | true | The file exists at that path, and the old `02-sequences/04-msa-and-trees/` asset directory is gone |

## Files still referencing the retired chapter id `02-sequences/04-msa-and-trees`

These are outside this chapter and belong to other roles. Listed for the lead.

Live files that need retargeting.

- `docs/user-manual/help-ids.yaml`, five entries at lines 228, 234, 326, 332, and 486. `dialog.IQTreeInferenceDialog`, `dialog.MSAOperations`, `viewport.MSAViewer`, `viewport.TreeViewer`, and `menu.Tools.FASTQOperations.MSA`. All five point at chapter `02-sequences/04-msa-and-trees` and at anchors that no longer exist. Two of them, `dialog.IQTreeInferenceDialog` and `viewport.TreeViewer`, belong to this chapter and would send Help to a missing page.
- `docs/user-manual/illustrations.yaml:197`, the `02-sequences/04-msa-and-trees:` key that still owns `tree-anatomy` and `msa-column-homology`.
- `docs/user-manual/assets/illustrations-imagegen/manifest.json`, lines 188, 193, 194, 197, 202, and 203, whose `chapter`, `svg`, and `sourcePng` fields all name the old path even though the assets have already moved.
- `docs/user-manual/ARCHITECTURE.md:219`, the chapter list entry.

Review and historical files, which record the pre-split state and need no
change.

- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md`, lines 595, 3661, 3738, 3739, and 3795.
- `docs/user-manual/reviews/fidelity-2026-09/ground-truth/02-sequences.md:311`.
- `docs/user-manual/reviews/fidelity-2026-09/chapters/02-sequences__03-extracting-and-comparing/fidelity.md:175` and `reader-1.md:54`.
- `docs/user-manual/reviews/fidelity-2026-09/chapters/02-sequences__04-aligning-sequences/fidelity.md`, lines 8, 9, and 96.
- `docs/user-manual/reviews/illustrations/illustrations-todo.md:388` and `:403`.
- `docs/user-manual/reviews/part-ii-fidelity-2026-06-02/ILLUSTRATIONS-SPEC.md:63`, `SCREENSHOT-SPEC.md:40`, `ground-truth/02-sequences.md:14`, and `round-3/cross-chapter-consistency.md:119` and `:185`.

## Counts

True 76, false 6, unverifiable 2.
