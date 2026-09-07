---
title: Aligning Sequences
chapter_id: 02-sequences/04-aligning-sequences
audience: analyst
prereqs: [01-foundations/01-what-is-a-genome, 02-sequences/01-importing-and-viewing]
estimated_reading_min: 16
task: Align a set of related sequences with MAFFT, read the alignment in the alignment viewport, and export the result.
tags: [sequences, msa, mafft, alignment, conservation, export]
tools: [mafft]
parameters_refs: [msa.mafft, msa.view, msa.export, import.msa]
entry_points:
  - Tools > Multiple Sequence Alignment > MAFFT...
  - Right-click a FASTA selection > Align with MAFFT...
  - File > Import Center... > Alignments > Multiple Sequence Alignments
  - "CLI: lungfish-cli align mafft"
  - "CLI: lungfish-cli msa export"
shots:
  - id: mafft-dialog
    caption: "The MAFFT pane of the operations dialog, with the scope summary line above the Strategy popup and the collapsed Advanced Options group."
  - id: alignment-viewport-primate-mito
    caption: "The primate mitochondrial alignment open in the alignment viewport, showing the resizable name gutter, the pinned comparison row above the five sequences, the column header, and the conservation overview strip."
  - id: export-alignment-sheet
    caption: "The Export Alignment sheet, with its Destination choices above the Sequences gap choice and the Format popup."
illustrations:
  - id: msa-column-homology
    caption: "Three sequences before and after alignment, showing how MAFFT inserts gaps so homologous bases share a column."
glossary_refs: [msa, mafft, alignment-column, gap, conservation, consensus-sequence, homologous, fasta, accession, mitochondrial-genome, p-distance, percent-identity, plugin-pack, provenance, bundle, sidebar, inspector, operations-panel]
features_refs: []
fixtures_refs: [primate-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

A [multiple sequence alignment](../../GLOSSARY.md#msa), or MSA, takes a set of related sequences and lines them up so that positions descended from the same ancestral position sit in the same column. Two positions that share an ancestor this way are [homologous](../../GLOSSARY.md#homologous). The result is a rectangle. Each row is one input sequence, and each column is one inferred homologous position.

Sequences of the same gene are rarely the same length. One lineage gains bases that another never had, and one lineage loses bases the other kept. To keep the rectangle square, the aligner writes a [gap](../../GLOSSARY.md#gap) character, the `-` symbol, into a row that has nothing to put in that column. So a row's length in the alignment is its own length plus the gaps that were added to it.

![Three short sequences before and after gap insertion so homologous bases share columns](../../assets/illustrations-imagegen/02-sequences/04-aligning-sequences/msa-column-homology.png)

Once the rectangle exists, a column is something you can count. A residue is one unit of the sequence, a single base in DNA or a single amino acid in a protein. Take a column of five rows where four read `A` and one reads `G`. Four of the five agree, so that column scores 4 divided by 5, or 0.8. That number is [conservation](../../GLOSSARY.md#conservation), the share of the non-gap rows that carry the column's most common residue. A column where every row reads `A` scores 1 and is fully conserved. The disagreement in every other column is exactly the signal that later analyses read.

Lungfish Genome Explorer (LGE) aligns with [MAFFT](../../GLOSSARY.md#mafft) and stores the result as a `.lungfishmsa` [bundle](../../GLOSSARY.md#bundle), a folder that the Finder shows as one file. You can copy, move, rename, and back it up like any other file, and the app keeps track of what is inside. The bundle holds the aligned FASTA, the unaligned input it was built from, and a [provenance](../../GLOSSARY.md#provenance) record naming the tool version and the exact command line. Build the alignment first, read the columns, and only then hand the alignment to whatever comes next.

## Why you would do this

This chapter aligns five primate [mitochondrial genomes](../../GLOSSARY.md#mitochondrial-genome). The mitochondrial genome is the small circular DNA carried inside the mitochondrion, separate from the chromosomes in the nucleus. It is a common choice for comparing species because every cell carries many copies of it, it is short enough to sequence whole, and it accumulates change faster than most nuclear DNA.

The five are human, chimpanzee, gorilla, rhesus macaque, and cynomolgus macaque. All five sit in the one fixture file, `primate-mito.fasta`, one after another.

| Label in the file | Accession | Species | Length in bases |
|---|---|---|---|
| `Human_NC_012920.1` | `NC_012920.1` | Human | 16,569 |
| `Chimp_NC_001643.1` | `NC_001643.1` | Chimpanzee | 16,554 |
| `Gorilla_NC_011120.1` | `NC_011120.1` | Gorilla | 16,412 |
| `RhesusMacaque_NC_005943.1` | `NC_005943.1` | Rhesus macaque | 16,564 |
| `CynomolgusMacaque_NC_012670.1` | `NC_012670.1` | Cynomolgus macaque | 16,575 |

The gorilla is the shortest at 16,412 bases and the cynomolgus macaque the longest at 16,575, a spread of 163 bases. A spread that small is ordinary for mitochondrial genomes across primates. No two are the same length, so none of them can be compared position by position until they are aligned. Their relationships are already settled science, which is what makes them a good teaching set. You know before you start that the two macaques should look most alike, and that the human and the chimpanzee should look more alike than either looks to a macaque. An alignment that says otherwise is telling you something went wrong with the run, not something new about primates.

Alignment is also the step that most later work depends on. Column-by-column conservation is how you find a stretch conserved enough to design a primer against. Column-by-column disagreement is what tree inference reads. A pairwise identity matrix, which asks how similar every pair of sequences is, is computed straight off the aligned columns. None of those questions can be asked of unaligned FASTA.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the primate mitochondrial genomes. Download the file `primate-mito.fasta` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/primate-mito and remember where you saved it. That link opens a folder listing rather than the file, so click `primate-mito.fasta` in the listing, then click the Download raw file button at the top right of the file view.

MAFFT arrives in the `multiple-sequence-alignment` [plugin pack](../../GLOSSARY.md#plugin-pack), a bundle of managed tools LGE installs into its own environment. Install it before you start. Open **Tools > Plugin Manager...** (Cmd-Shift-B), find Multiple Sequence Alignment in the list, and click its Install button. The download needs an internet connection, and nothing after it does. The pack ships MAFFT 7.526, a version number recorded so a colleague can reproduce your run. It asks nothing of you. Docker is not involved.

Import the FASTA first, the way [Importing and Viewing a Sequence](01-importing-and-viewing.md) describes, so the five records sit in the project as a `.lungfishref` reference bundle you can open and select in. That is the same kind of folder-shown-as-a-file as the `.lungfishmsa` bundle the alignment will produce, holding unaligned sequences rather than aligned ones.

## Procedure

### Align the five genomes

1. Find the imported bundle in the sidebar under `Reference Sequences/` and double-click it so its five sequences are listed. Click one sequence and press Cmd-A to select all five, or click nothing at all and let the dialog take the whole file. Either way the run covers all five.

2. Choose **Tools > Multiple Sequence Alignment > MAFFT...**. The operations dialog opens on the MAFFT pane. You are in the right place even though the window title reads FASTQ/FASTA Operations. That is the title the one shared operations dialog always carries, not a menu you went looking for and missed.

3. Look at the top of the pane. Because you are aligning the whole file, there is no scope choice to make, so a single line states what will run, either Aligning all 5 sequences. or Aligning the 5 sequences you selected. The **Sequences to align** radio group appears in its place only when you select some but not all of a file's sequences, and Settings below describes it.

    <!-- SHOT: mafft-dialog -->

4. Leave **Strategy** on **Automatic** and click Run. MAFFT is the only aligner in LGE, so there is no aligner to pick. The remaining controls are covered in Settings below, and the shipped defaults are right for this input. Leave the Advanced Options group collapsed unless one of the symptoms named in Settings actually appears.

The dialog closes and a row for the run appears in the Operations panel, where a progress bar tracks it to completion. On this input on a current Mac the run is short, well under the time it takes to read the next section. The new bundle then appears in the sidebar under `Analyses/Multiple Sequence Alignments/`. Double-click it to open the alignment viewport.

Right-clicking a FASTA selection and choosing **Align with MAFFT...** opens the same dialog with that selection already scoped. The alignment viewport does not offer that item, because realigning sequences that already carry gaps is a different operation from aligning sequences. MAFFT scores a gap as though it were a residue, so the gaps an earlier run inserted are read as real data on the second pass, and MAFFT then aligns to them and inserts more. LGE warns you when a run's input already contains gaps.

### Import an alignment built elsewhere

An alignment produced by another program can come in as a native bundle and use every viewport control in this chapter. Choose **File > Import Center...** (Cmd-Shift-I), open the Alignments tab, and drop the file on the Multiple Sequence Alignments card. The card has no controls beyond a file panel, format detection is automatic, and each accepted file becomes one `.lungfishmsa` bundle. It reads aligned FASTA, Clustal, PHYLIP, NEXUS, Stockholm, and the a2m and a3m profile formats. The last two come from profile search tools such as HMMER and HHsuite, and most readers will never meet a file in either one. This is the route for reproducing a published alignment from a program LGE does not run.

## Settings

The MAFFT pane holds eleven settings. Five sit in plain view, and they are the first five described below, from Sequences to align through Output Order. The other six sit inside a collapsed Advanced Options group, and they are the last six, from Direction Adjustment through MAFFT Parameters. Click the Advanced Options triangle to reach that second group.

**Sequences to align.** Chooses whether the run covers every sequence in the source file or only the sequences you highlighted in the viewport. The default is All sequences, with the row count in the label, so All sequences (5) tells you the size of the run before you start it. Pick the selected scope when the file holds a sequence you do not want in the alignment, such as an unrelated outgroup or a failed sample. The radio group only appears when you have selected some but not all of the file's sequences, because otherwise there is nothing to choose between, and a summary line takes its place. On the command line this is `--sequence`, which is repeatable and accepts a full FASTA header such as `>Human_NC_012920.1 Homo sapiens mitochondrion`, a bare [accession](../../GLOSSARY.md#accession) such as `NC_012920.1`, or the label shown in the alignment such as `Human_NC_012920.1`.

**Batch Output.** States that every selected input file is pooled into one alignment. The default and only choice is Combine all inputs, run once (1 result), and the row is locked with the reason "Alignment requires all sequences in one run", which means the control is greyed out and cannot be clicked. The row appears only when you feed the dialog two or more files, because with one file there is nothing to combine, so the procedure above never shows it. This setting has no command-line flag.

**Strategy.** Picks how hard MAFFT works to place gaps. The default is Automatic, which lets MAFFT choose from the number and length of your sequences, and on the five primate genomes it chooses a progressive method, one that aligns the two most similar sequences first and then adds the rest in turn. Automatic is the right choice for this chapter, and the five named alternatives are for inputs outside its scope. Move to L-INS-i when you have under about 200 sequences of similar length and the automatic alignment leaves ragged gap columns, meaning gaps scattered one and two at a time down a region rather than falling into clean blocks. On the command line this is `--strategy`, which takes `auto`, `linsi`, `ginsi`, `einsi`, `fftns2`, or `parttree`.

**Sequence Type.** Tells MAFFT whether the letters are DNA or amino acids, which decides the scoring table it uses. The default is Auto, which lets MAFFT guess from the residues it sees, and the guess is reliable on a full mitochondrial genome. Set it by hand when a short or ambiguous sequence makes the guess wrong. A protein alignment scored as DNA shows up in the viewport as rows full of letters the nucleotide colouring leaves uncoloured, with gaps scattered instead of blocked. On the command line this is `--sequence-type`.

**Output Order.** Chooses the order of rows in the finished alignment. The default is Input Order, which keeps the order of your source file, so the primate rows stay in the order the FASTA lists them. Switch to Aligned Order when you want related sequences adjacent so that shared differences line up in the viewport. On the command line this is `--output-order`.

**Direction Adjustment.** Lets MAFFT reverse-complement a sequence that was submitted on the wrong strand, that is, read it backwards along the other of the DNA molecule's two strands. The default is Off, which trusts the strand you gave, and the five RefSeq records all come in on the same strand. Turn it on when some inputs came from a source that does not enforce a strand, which shows up as one row in the alignment that is nearly all gaps. On the command line this is `--adjust-direction`, taking `off`, `fast`, or `accurate`.

**Symbol Policy.** Decides what MAFFT does with letters outside the standard DNA or protein alphabet. The default is Strict Alphabet, which stops on an unexpected character rather than aligning something you did not mean to align. This matters mainly for protein alignments and is rare. Choose Allow Any Symbol when your sequences carry stop codons or unusual amino acids such as selenocysteine, which MAFFT would otherwise reject. On the command line this is `--symbols`.

**Threads.** Sets how many processor cores MAFFT may use. The default is blank, which lets the app choose a count that suits the machine. Set a small number, `2` for instance, when you want to run another job at the same time and keep the machine responsive. On the command line this is `--threads`.

**Deterministic threading.** Keeps MAFFT's iterative refinement single-threaded so that the same input always produces the same alignment. The default is on, because a result you cannot reproduce is hard to defend in a methods section. Clear it only when a large alignment is too slow and you do not need exactly the same result on a rerun. On the command line, clearing the box sends `--allow-nondeterministic-threads`.

**Treat FASTQ records as assembled or consensus sequences.** Lets you feed FASTQ files to MAFFT by converting each record to FASTA first. The default is off, because aligning raw sequencing reads to each other is almost never what anyone wants. Tick it when the FASTQ actually holds finished consensus or assembled sequences rather than raw reads. On the command line this is `--allow-fastq-assembly-inputs`.

**MAFFT Parameters.** Passes text straight to MAFFT after the chosen strategy. The default is empty, and the dialog checks that whatever you type parses as command-line arguments before it will run. Most readers should leave it empty. Use it only for a MAFFT option the dialog does not expose, such as a custom gap-opening penalty, the cost MAFFT charges itself for starting a new run of gaps. On the command line this is `--extra-mafft-options`.

### Viewport display controls

These nine settings change what you see and never change the bundle on disk. Six of them live in the Inspector's View tab, which is the panel on the right of the project window, opened with **View > Show Inspector** (Cmd-Option-I). Those six are Numbering, the two consensus sliders named Low support and High gap, Mask, Reference, and Display. The remaining three live on the viewport itself, and they are All Sites, the colour scheme, and the name gutter.

**All Sites / Variable Sites.** Chooses whether the viewport shows every alignment column or only the columns where the sequences disagree. The default is All Sites, which is the honest starting view because it shows the conserved stretches as well as the differences. Switch to Variable Sites on a long alignment of close relatives, where the differences would otherwise be thousands of columns apart. This setting has no command-line flag.

**Nucleotide / Conservation.** Chooses the residue colouring. The default is Nucleotide, which gives each base its own colour, so you read the letters directly. Switch to Conservation, which shades each column by how many rows share its most common residue, when you care about which regions are constant rather than which base sits in a given cell. This setting has no command-line flag.

**Numbering.** Chooses which coordinates the column header labels. The default is Alignment + Source, which shows both because they disagree wherever a gap sits, alignment columns counting gapped positions from the left edge and source coordinates counting ungapped positions along each original sequence. The other choices are Alignment Columns, Source Coordinates, and Hidden. Choose Source Coordinates when you need a position you can look up in the original record, and Hidden when the numbers crowd a narrow window. This setting has no command-line flag.

**Low support (of non-gap residues).** Sets how much of a column must agree before the consensus shows a base there, counting only the rows that have a residue rather than a gap. Anything below the threshold is masked instead. The default is 50 percent, which calls a base whenever a simple majority of the rows that have one agree. Raise it when you want a consensus that only shows positions where the sequences strongly agree. This slider governs the consensus row drawn on screen, which is the one the procedure above produced. The command line has its own separate control in `msa consensus --threshold`, which defaults to 0.6 rather than 0.5.

**High gap.** Sets the share of rows that may be gaps before the consensus masks that column. The default is 50 percent, so a column with more than half its rows gapped is masked. Lower it when partial sequences are letting sparse columns into the consensus. This setting has no command-line flag. A separate command-line option, `msa consensus --gap-policy`, decides whether gap columns are written out at all.

**Mask.** Picks the character that stands in for a masked consensus position. The default is Auto, which writes `X` for protein alignments and `N` for everything else, so the primate consensus masks with `N`. `N` is the standard DNA code for any base, and `X` is its protein equivalent for any amino acid. Set it by hand when the alignment alphabet is ambiguous and the automatic choice picks the wrong letter. This setting has no command-line flag.

**Reference.** Names the sequence every other row is compared against. The default is Consensus, which is not one of your five input records but a sequence LGE computes by taking each column's most common residue. That makes it the neutral choice when no one row is privileged. Point it at a published reference or a wild-type sample when you want every difference reported relative to that sequence. This setting has no command-line flag, and the right-click items **Use Consensus** and **Use as Reference** set the same value from the alignment itself.

**Display.** Chooses whether matching residues are spelled out or replaced by dots. The default is Letters, which spells everything out. Switch to Dots to Consensus or Dots to Reference as soon as the alignment is mostly identical, because the differences are then the only letters left on screen. Dots to Reference stays disabled until a Reference row is chosen. This setting has no command-line flag.

**Name gutter width.** Sets how much room the sequence names get on the left of the alignment, dragged with the handle between the names and the residues and remembered for the next session. The default is the shipped width, which fits a short label but truncates a long one. Widen it when a label such as `CynomolgusMacaque_NC_012670.1` is cut off, and narrow it to give the residues more room. The handle stops on its own at each end, at a ceiling of 640 points and a floor of 160, points being the screen unit macOS measures interface widths in. This setting has no command-line flag.

### Export Alignment sheet

**Destination.** Chooses where the exported alignment goes. The default is Save to File..., which writes a plain file anywhere on disk. Choose Save as Bundle when the subset is the input to another LGE step, and Copy to Clipboard for a quick paste into a message or a notebook. This setting has no command-line flag, though a bundle export runs `msa extract` underneath and a file or clipboard export runs `msa export`.

**Sequences.** Decides whether the export keeps the gap characters. The default is Aligned FASTA (keep gaps), which preserves the alignment as a grid so the receiving program sees the same columns you did. Choose Unaligned FASTA (remove gaps) when the destination wants raw sequences at their original lengths, such as a BLAST search or a primer design tool. On the command line the flag depends on the Destination you picked. A Save to File... or Copy to Clipboard export sends `--output-format`, and a Save as Bundle export sends `--output-kind`.

**Format.** Picks the file format of a file export, and the row appears only for that destination because bundle and clipboard exports are always FASTA. The default is `aligned-fasta`, which every alignment reader accepts. The other choices are `phylip`, `nexus`, `clustal`, `stockholm`, `a2m`, and `a3m`. Removing the gaps forces the format to plain `fasta` and hides this row, because there is then only one format to pick. Change it to match the program that will read the file, since a tree builder that wants PHYLIP will not accept FASTA. On the command line this is `--output-format`.

**Scope.** Chooses whether the export covers the whole alignment or only the rows and columns you selected, and the row appears only when a selection exists. The labels carry live counts of whatever you have selected, so with three rows highlighted out of five the choices read Selected subalignment (3 rows) and Entire alignment (5). Selected subalignment is the default whenever rows are selected. Keep it when you highlighted a clade or a gene region and want only that piece in the output file. On the command line this is `--rows` and `--columns`.

**Bundle name.** Names the new bundle when the destination is Save as Bundle, and the row appears only for that destination. The default is the current alignment name, and the Create Bundle button stays disabled until the field holds something. Set it whenever the export is a subset, so the bundle name says what the subset is. On the command line this is `--name`.

The Multiple Sequence Alignments import card has no settings at all. Its three command-line options are covered in the last section.

## Reading the results

<!-- SHOT: alignment-viewport-primate-mito -->

### The shape of the viewport

Four regions stack around the residues. On the left, a resizable name gutter lists every sequence in alignment order. Click a name to select that row, Command-click to add rows, and Shift-click for a range. Across the top, a column header carries the numbering, and below it a conservation overview strip draws a bar at each column whose height is the fraction of non-gap rows sharing that column's most common residue. Above the sequence rows sits the pinned comparison row, which holds the current Reference and stays in place while the rows below it scroll.

The residues fill the middle. They are coloured by the `Nucleotide` scheme by default, which you can swap for `Conservation`. An annotation is a labelled feature over a stretch of sequence, a gene or a coding region for instance, and any annotations the source sequences carried draw as tracks over the alignment. The plain FASTA fixture this chapter uses carries none, so nothing extra is drawn on the primate alignment. There is no toggle to switch these tracks off when a file does bring them.

The toolbar carries the working controls. A `Find sequence or column` search field matches a sequence name, and typing a bare column number jumps to that column instead, switching back to All Sites first if the column is one the Variable Sites view is hiding. An `All Sites` and `Variable Sites` segmented control sets which columns are drawn, and **Previous Variable** and **Next Variable** step between disagreeing columns without changing that setting. Both buttons grey out when the alignment has no variable column at all. Icon buttons zoom in, zoom out, and fit the columns to the window.

### The numbers on this alignment

The primate alignment is 5 rows and 17,247 columns. Read that against the input. Every row is now 17,247 characters wide, so subtracting each sequence's own length gives the gaps that row received. The longest input is the cynomolgus macaque at 16,575 bases, and 17,247 minus 16,575 is 672 gaps. The shortest is the gorilla at 16,412 bases, and 17,247 minus 16,412 is 835. A total column count close to the longest input is what a set of genuinely related sequences should give. A column count several times the longest input means the aligner could not find shared structure, and the usual cause is that one input is not what you thought it was.

Of those 17,247 columns, 5,053 are variable, meaning they hold more than one distinct non-gap residue. Dividing 5,053 by the 17,247 columns of the whole alignment gives 29.3 percent, which the rest of this chapter rounds to 29 percent. That is what two genera separated by tens of millions of years look like in mitochondrial DNA. A middle figure like this one is the normal healthy case. Under a few percent means your sequences are near-identical and the alignment is unlikely to distinguish them. Over about half means they may be too divergent for column-by-column comparison to mean much.

The consensus built from this alignment is 17,247 characters long with 479 of them masked as `N`. A masked position is one where the rows did not agree strongly enough under the current thresholds. Read the count as a share of the alignment. Here 479 out of 17,247 is under 3 percent, and anything in the low single digits means the sequences broadly agree. A tenth of the alignment or more means they do not.

### Pairwise identity

The clearest single check is a pairwise identity matrix, which reports for every pair of rows the fraction of compared positions at which they agree. It is the same arithmetic as [percent identity](../../GLOSSARY.md#percent-identity), computed across the whole alignment rather than a local hit.

No window or Inspector row in LGE draws this matrix. It comes only from the command line, from `lungfish-cli msa distance`, which the last section of this chapter shows. The numbers below are that command's output on the primate bundle, and they are worth reading even if you never run it, because they are what the viewport is showing you in another form.

On this alignment the two macaques come out at 0.926, or 92.6 percent identical, the highest pair in the matrix. Human and chimpanzee come out at 0.913. Human against either macaque falls to about 0.789.

Those three numbers are the finding. Within-genus pairs are the most similar, the two great apes come next, and the ape-to-monkey comparisons are lowest. That ordering is the known primate relationship recovered from the alignment alone, which is what tells you the run worked. A matrix where the two macaques were not the closest pair would mean a mislabelled input, not a discovery.

What the Inspector does show for the selected bundle is a live summary of the alignment's own shape, counting the columns currently displayed and how many of them vary. It changes as you change the display, so read what is on screen rather than looking for a fixed row.

### Acting on a selection

Select rows by clicking their names in the gutter, and select a range of columns by dragging across the residues from the first column you want to the last. The two together define a block. Right-click inside the alignment for the items that act on that block, or Control-click if you are on a trackpad with no second button.

**Copy Subalignment** puts the selected block on the clipboard as FASTA. **Extract Selection to New Bundle...** writes the block as a fresh `.lungfishref` reference bundle with its own provenance, and **Export Selected Residues...** writes it to a file. **Export Alignment...** opens the export sheet described in Settings.

<!-- SHOT: export-alignment-sheet -->

Two items set the comparison target without touching the alignment. **Use as Reference** makes the row you clicked the pinned comparison row, and **Use Consensus** puts the consensus back. Pair either with the Display setting Dots to Reference or Dots to Consensus, and every position that matches collapses to a dot so only the differences stay as letters.

Two more items work on annotations. **Add Annotation from Selection...** records a named feature over the selected columns of one row, and **Apply Annotation to Selected Rows** copies an existing annotation onto the other rows you have selected. The second item enables only once two conditions hold together. More than one row must be selected, and the selected columns must cover a stretch that an annotation already occupies, so drag across an annotated region rather than an empty one.

**Build Tree with IQ-TREE...** also sits on this menu. It stays greyed out until at least two rows are selected, and the next chapter covers what it does.

Copy to Clipboard on the export sheet disables itself with an explanation when the alignment text would exceed 5 MB, rather than failing after you commit to it. As a rough guide, one character of the alignment is one byte, so 5 MB is around 300 rows the length of these mitochondrial genomes. The five primate rows come to under 90 KB and stay far below the cap.

## What good looks like

Four checks are worth running before you trust an alignment.

Confirm the row count matches your input. Five sequences in should give five rows out, with the names unchanged. A missing row means an input was rejected, and the Operations panel holds the reason. Open it with **Operations > Show Operations Panel** (Cmd-Shift-P).

Confirm the column count sits near the longest input, as 17,247 does against 16,575 here. A count far above that means the aligner found little shared structure.

Confirm the conservation overview strip looks like the one in the screenshot above. On related sequences it reads as runs of tall bars broken by shorter stretches. An even wash of low bars across the whole width, with no run of tall bars anywhere, means the rows are not aligned to each other in any meaningful way.

Confirm the pairwise identities put the pairs in the order biology predicts, the way the two macaques lead this matrix at 0.926. When they do not, suspect the inputs before the aligner.

When a run does go wrong, the input is almost always the cause. Sequences in mixed orientation align as though unrelated, and the fix is **Direction Adjustment** rather than an external tool. Sequences from different genes, or of wildly different lengths, produce mostly-gap alignments, so spot-read a few headers and lengths in the sidebar before blaming the run. Very divergent sequences sit at the edge of what the Automatic strategy handles well, and **L-INS-i** buys accuracy at the cost of runtime. If none of that explains it, open the operation's row in the Operations panel, where the full MAFFT output sits beside the resolved command line.

## On the command line

This section is for readers who want to script the work or run it on a machine with no screen. Everything the chapter has covered so far is available in the app, so if you have no use for a terminal you can stop reading here and go on to the next chapter. One exception is worth knowing about. The pairwise identity matrix in Reading the results comes only from `lungfish-cli msa distance` below.

The block reproduces the whole chapter. The fixture path is written as if you downloaded it to your Downloads folder, and the project is a `.lungfish` folder you already created.

```bash
# Align the five genomes. --project is required and receives the bundle.
lungfish-cli align mafft ~/Downloads/primate-mito.fasta \
  --project ~/Documents/primates.lungfish \
  --name primate-mito \
  --strategy auto

# Align only three of the five. --sequence is repeatable.
lungfish-cli align mafft ~/Downloads/primate-mito.fasta \
  --project ~/Documents/primates.lungfish \
  --sequence Human_NC_012920.1 \
  --sequence RhesusMacaque_NC_005943.1 \
  --sequence CynomolgusMacaque_NC_012670.1 \
  --name primates-three

# Ask how different the sequences are, without building a tree.
lungfish-cli msa distance \
  ~/Documents/primates.lungfish/Analyses/"Multiple Sequence Alignments"/primate-mito.lungfishmsa \
  --output primate-mito-identity.tsv

# Export for a program that wants PHYLIP.
lungfish-cli msa export \
  ~/Documents/primates.lungfish/Analyses/"Multiple Sequence Alignments"/primate-mito.lungfishmsa \
  --output-format phylip --output primate-mito.phy

# Bring an alignment built elsewhere into the project.
lungfish-cli import msa my-alignment.fasta --project ~/Documents/primates.lungfish
```

`align mafft` takes `--project` for the project directory that receives the bundle, and every dialog setting reaches it as the flag named in that setting's paragraph above. Two more options exist only here. `--output` names an explicit `.lungfishmsa` path instead of letting the project choose one, and `--extra-args` passes further arguments to MAFFT verbatim alongside `--extra-mafft-options`.

`lungfish-cli msa` is a different command from `lungfish-cli align`. It transforms and inspects an alignment that already exists, and it cannot build one from unaligned FASTA. Two introspection subcommands say what it can do. `msa actions` lists every registered alignment action with its category and whether it is implemented, and `msa describe <action-id>` prints one action's detail, taking an identifier such as `msa.alignment.mafft`.

The transforms each write a new file or bundle with its own provenance, and each takes `--output` for the destination and `--force` to overwrite one that already exists.

One default differs between the app and the command line, so read the table with it in mind. The export sheet's Format setting defaults to `aligned-fasta`, which keeps the gaps, while `msa export` defaults to plain `fasta`, which strips them. An aligned export from the command line therefore needs `--output-format aligned-fasta` written out.

| Subcommand | What it does | Key options |
|---|---|---|
| `msa export` | Write the alignment out in another format. | `--output-format fasta\|aligned-fasta\|phylip\|nexus\|clustal\|stockholm\|a2m\|a3m` (default `fasta`), `--rows`, `--columns` |
| `msa consensus` | Collapse the alignment into a consensus FASTA or `.lungfishref`. | `--output-kind fasta\|reference`, `--threshold` (default 0.6), `--gap-policy omit\|include`, `--rows`, `--name` |
| `msa distance` | Write a pairwise distance matrix as TSV. | `--model identity\|p-distance` (default `identity`), `--rows`, `--columns` |
| `msa extract` | Pull selected rows and columns into a new FASTA or MSA bundle. | `--output-kind fasta\|msa`, `--rows`, `--columns`, `--name` |
| `msa annotate` | Add, edit, delete, or project column annotations. | the `add`, `edit`, `delete`, and `project` verbs, with `--row`, `--columns`, `--type`, `--strand` |

Two more subcommands derive a new bundle by narrowing the columns. `msa mask columns` marks columns as masked without deleting them, taking `--ranges` for explicit 1-based ranges, `--gap-threshold` and `--conservation-below` for numeric cutoffs, `--parsimony-uninformative` for columns a tree builder cannot use, `--annotation` for the columns one annotation spans, `--codon-position 1|2|3` for a position within the three-base codons of a coding sequence, and `--reason` to record why. Parsimony is a tree-building idea outside this chapter's scope, and the flag is there for readers who already reach for it. `msa trim columns` removes columns outright and takes `--gap-only` and `--gap-threshold`. Both are spelled with the `columns` verb, hence `lungfish-cli msa mask columns`.

`import msa` takes `--project` for the destination and adds `--source-format` to force a file whose extension does not match its contents to be read as `aligned-fasta`, `clustal`, `phylip`, `nexus`, `stockholm`, or `a2m-a3m`, `--name` to set the bundle's display name, and `--output` to write the bundle to an explicit path.

The [p-distance](../../GLOSSARY.md#p-distance) model that `msa distance` offers alongside identity is the proportion of positions at which two aligned sequences differ. It applies no correction for changes a simple count cannot see, since a site that mutated from `A` to `G` and later back to `A` reads today as no change at all. Read p-distance as the raw disagreement and identity as its complement.

## Next

Continue to [Building Trees](05-building-trees.md), which takes this alignment and infers a phylogeny from it with IQ-TREE.
