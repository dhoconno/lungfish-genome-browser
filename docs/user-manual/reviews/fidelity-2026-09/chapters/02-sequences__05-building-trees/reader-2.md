# Reader report: Building Trees

Persona: a senior who has pipetted for two years and never analyzed data. I have never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Maximum likelihood asks, of all..." | I had to read this three times. "Of all the trees it can build" and "makes the observed columns most probable" are two abstractions stacked into one sentence. | Split it so one sentence says the program tries many trees and one says it keeps the one that best explains the data. |
| What it is, "the estimated number of substitutions..." | I do not know what "per site" is counting. Per alignment position, or per base of the original genome? I could not judge whether 0.06 is a lot. | Say a branch length of 0.06 means about six changes per hundred alignment positions. |
| What it is, "a set of rates for turning..." | I understand the words but not why the program needs this assumption before it starts. It reads as a step I am told to accept. | One clause saying some base changes happen more often than others, so the model has to account for it. |
| Why you would do this, "The two macaques should be sisters." | "Sisters" is used as a technical term and never glossed. I guessed closest relatives but was not certain it did not mean something more specific. | Gloss sisters at first use, the way tip and clade are glossed. |
| Before you start, "Download the file primate-mito.fasta from..." | I am told to download the FASTA, but the procedure starts from a .lungfishmsa bundle made in the previous chapter. I could not tell whether I still need the FASTA here. | Say whether the FASTA is used in this chapter or only feeds the previous one. |
| Before you start, "Install it from Tools > Plugin..." | I did not know what to do once the Plugin Manager opened. Is there a list, a search box, an Install button? | One sentence naming what I click inside the Plugin Manager. |
| Procedure step 2, "Click the first sequence name in..." | I do not know what the name gutter is. I assumed the strip of names on the left, but the chapter never says. | Gloss name gutter, or write "the column of sequence names on the left". |
| Procedure step 3, "Its Inputs section carries a Scope..." | I did not know what to do with the Scope line. Am I meant to check it against something? | Say Scope should read 5 rows so I can confirm my selection took. |
| Procedure step 5, "Tick Ultrafast Bootstrap in the Branch..." | I have no idea what a replicate is at this point. It is explained later in Settings, but I met the number 1000 first. | A half-sentence gloss where the number first appears. |
| Procedure, "The new bundle appears in the sidebar..." | I did not know how long to wait or what tells me the run finished. Nothing said a progress indicator exists. | Say where progress shows and roughly how long this run takes. |
| Settings, "The Phylogenetic Tree Operations dialog holds thirteen..." | I counted eleven visible plus two hidden, but the procedure only had me touch three. I could not tell which of the other ten I was expected to read now. | A line saying the defaults are right for this chapter and the rest is reference. |
| Settings Sequence Type, "Set it by hand when the..." | I do not know what NT to AA does. Translating DNA to protein is my guess, and the sentence does not say. | Spell out that NT2AA translates the nucleotides to amino acids first. |
| Settings Ultrafast Bootstrap, "a procedure that rebuilds the tree many..." | "Shuffled versions of your columns" made me think the columns get scrambled into a nonsense alignment. I could not see why that would test anything. | Say the columns are sampled with replacement, not reordered. |
| Settings SH-aLRT, "compares each branch against the alternatives immediately..." | I could not picture what an alternative to a branch is. | One example, such as swapping two neighbouring groups. |
| Settings Seed, "Fixes the starting point of the..." | I did not understand why a random process has a fixed default of 1. It read as a contradiction. | Say the number is fixed on purpose so a rerun matches. |
| Settings Threads, "The default is blank, which lets..." | Every other setting reports a real default value. A blank one left me unsure whether I had broken something by not filling it in. | Say blank is correct and means automatic. |
| Settings Safe numerical mode, "Turn it on after a run..." | I would not recognize a likelihood error if I saw one, and I do not know where such an error appears. | Name the error text or say where it shows up. |
| Settings Keep identical sequences, "infers the tree faster, and puts them..." | I could not follow how a sequence removed before the analysis gets a position afterward. | One clause saying the duplicate is attached beside its identical twin. |
| Re-root, "Re-rooting shows no dialog." | I read this before I had ever re-rooted anything, so I did not know what I would have wanted a dialog for. The whole section describes settings for a thing the procedure never had me do. | A short numbered step re-rooting this tree once in the app. |
| Re-root, "the number after -rerooted grows if..." | I could not tell whether the names go -rerooted then -rerooted-2, or something else. | Show the second and third names. |
| Extract subtree, "On the command line this is..." | "A normalized node ID" appears with no explanation of what normalizes it or where such an ID comes from. It is explained ten paragraphs later. | Say here that the ID is an internal name the app assigns. |
| Reading the results, "On the primate tree it reads..." | I could not tell whether "unrooted" is a problem I caused. The chapter later says it is normal, but my first reaction was that my run had failed. | Say on first sight that unrooted is what IQ-TREE always gives. |
| Reading the results, "A tree of five tips can..." | I could not work out where the three comes from, so I could not apply the rule to a different number of sequences. | Give the rule, tips minus two. |
| Reading the results, "Written as Newick, the tree is..." | I read the Newick block and could not match it to the topology sentence above it. The nesting defeated me. | Point out which bracket pair is the macaque clade. |
| Reading the results, "The human and the chimpanzee sit..." | The human and chimp appear first in the Newick, and I expected the outsiders to come last. I could not tell if I was misreading the string. | Say Newick order does not indicate branching order. |
| Reading the results, "the Inspector reports a cumulative divergence..." | I could not tell what a good or bad cumulative divergence is, or whether it is worth checking on my own tree. | Say whether this number is diagnostic or only illustrative here. |
| Reading the results, "and it is more than ten..." | 0.8982 against 0.0740 is twelve times, so the claim holds, but I had to do the arithmetic before I trusted the sentence. | State the ratio outright. |
| Support values, "A support value at or above..." | The chapter says the bootstrap and SH-aLRT use the same 0 to 100 scale but are calculated differently. I could not tell whether 95 and 70 apply to both. | Say whether those cutoffs cover SH-aLRT too. |
| Acting on a node, "Right-click a tip or an..." | It promises ten items. I counted the ones named in the section and got nine. I could not tell what I had missed. | List them, or drop the count. |
| Acting on a node, "Collapse Clade folds an internal node's..." | I did not know whether collapsing changes the saved tree or only the picture on screen. | Say it changes the view only. |
| Relabelling tips, "add a tab-separated metadata.tsv file at..." | I do not know how to get inside a bundle. In Finder a bundle looks like a single file to me. | Say how to open the bundle, or that Reveal Provenance leads there. |
| Relabelling tips, "use tree relabel on the command..." | This is the only way to make relabelling permanent, and it is closed to me. I have never opened a terminal. | Say plainly that the popup is display only and there is no in-app equivalent. |
| What good looks like, "A short alignment, meaning under a..." | I do not know which of my columns count as informative, so I cannot tell whether my alignment passes. | Define informative column, or give the number for the primate alignment. |
| What good looks like, "If IQ-TREE reports that ModelFinder settled..." | ModelFinder is named here for the first time. I assume it is the MFP setting, but the chapter never connects the two names. | Say MFP is ModelFinder Plus back at the Model setting. |
| What good looks like, "where the full IQ-TREE output sits..." | I would open this expecting help, but I would not know what in a wall of IQ-TREE output counts as the error. | Say what to look for in that output. |
| On the command line, "The block below reproduces the whole..." | Nothing in this section is usable by me, and two things I wanted, permanent relabelling and a chosen name for a re-rooted tree, exist only here. | A note earlier saying which capabilities are command line only. |

The one thing I learned is that a tree and a similarity matrix answer different questions, and branching order is the thing only a tree gives you.

The one thing I still could not do is re-root the primate tree, because re-rooting is described as settings and as a command line call but never walked through once in the app.

The sentence I liked most is "A tree that says otherwise is reporting a problem with your run rather than news about primates."
