# Reader report, undergraduate reader 4

Persona: a student who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| Front matter, "task: Understand the question read classifiers" | "Classifiers" is used before anything says it is a program. | Say "a classifier is a program that" at the first use. |
| What it is, "A classifier walks the reads one" | I could not tell whether "walks the reads" means it reads them in order or does something cleverer. | Replace "walks" with "goes through". |
| What it is, "compares each one against a reference" | I do not know what a reference database physically is. In Geneious I picked a file. Is this a file, a folder, or a website? | One sentence saying a database here is a folder of files you download onto your own computer. |
| What it is, "running from domain down through phylum" | I learned kingdom in class and there is no kingdom in this list. I read it twice looking for a mistake. | Note that this is the set of ranks the tools report and kingdom is skipped. |
| What it is, "reports the lowest common ancestor, the most" | I understood the words but not how the program decides when to stop climbing, or whether I control that. | Say whether the user sets this or the tool decides alone. |
| What it is, "which is honest rather than a failure" | Read twice. I could not tell if this was reassurance or a warning that the result is weaker. | Say plainly that a genus-level call is still a usable result. |
| Why you would do this, "That is three answers a targeted" | I had to count back through the previous sentence to find the three. | Number them, or drop the count. |
| Why you would do this, "a wastewater pellet, a culture you" | I do not know what a wastewater pellet is. I pictured a pill. | Gloss it as the solid material spun down out of a wastewater sample. |
| Why you would do this, "use the SRR36291587 SARS-CoV-2 reads" | I do not know what an SRR number is or where it comes from. It looks like a code I should already recognise. | Say it is an accession number from a public sequence archive. |
| Why you would do this, "a clinical amplicon dataset of 86,281" | I do not know what amplicon means here, and I cannot judge whether 86,281 is a lot or a little. | Gloss amplicon, and say whether that count is small, typical, or large. |
| Why you would do this, "read pairs" | Pairs of what? I thought a read was one sequence, so I could not tell if this is 86,281 reads or double that. | One clause saying a pair is two reads from the two ends of one fragment. |
| What LGE runs, "reports how well each one is covered" | Covered by what? Coverage is not defined until several paragraphs later. | Gloss coverage where it first appears. |
| What LGE runs, "assembles reads into longer sequences and" | I do not know what assembly is and this is the only mention. | Add three words saying assembly stitches overlapping reads into longer pieces. |
| What LGE runs, "keep provenance for alongside your own" | I do not know what provenance means in this app. It sounds like art history. | Gloss provenance at first use as the stored record of how a result was made. |
| Table, "How do I bring a hosted CZ-ID" | Every other row in that column asks a biology question and this one asks a software question, so the column stopped making sense. | Make the import rows describe the biological question too. |
| Import route, "The Import Center's Classification Results tab carries six cards" | The table just above says three tools are import only, then this says six. I read both twice unsure which was right. | Put the six-card fact before the table so it does not read as a contradiction. |
| Freyja paragraph, "It reads variant and depth tables" | I do not know what a variant table or a depth table is. | Gloss both, or say they are files an earlier step in this manual produces. |
| Freyja paragraph, "estimates which SARS-CoV-2 lineages are mixed" | I do not know how a lineage differs from a taxon. | One clause distinguishing lineage from taxon. |
| Picking a classifier, "plasmids, the human genome, and vector" | I do not know what vector sequence means here. I only know vector as a mosquito. | Gloss vector sequence as laboratory cloning sequence. |
| Picking a classifier, "They arrive with the PlusPF builds" | PlusPF is never expanded and I do not know what a build is. | Expand PlusPF once, and say a build is one prepared version of a database. |
| Picking a classifier, "short fixed-length words of sequence called" | I could follow k-mer but not minimizer. "Compact fingerprints of them" gave me nothing to picture. | Say a minimizer is one chosen representative k-mer standing in for a group. |
| Picking a classifier, "without aligning any of them" | Aligning is not explained and I only half-remember it from Geneious. | Gloss aligning in half a sentence. |
| Picking a classifier, "stacked on one conserved gene" | I do not know what conserved means in this sentence. | Gloss conserved as nearly identical across many organisms. |
| Picking a classifier, "it needs both Nextflow and a container" | I could not do this. I do not know how to check whether these are on my computer and I have never opened a terminal. | Point to the place in the app that reports whether they are present. |
| Where the classifiers live, "Cmd-Shift-B" | I could not tell what the B stands for and thought it might be a typo. | Give the menu path first and the shortcut second, or drop the shortcut. |
| Where the classifiers live, "Select your reads in the project sidebar" | I could not perform this. Nothing says what a reads item looks like in the sidebar or how I would know I picked the right one. | Name what the selected item is called in the sidebar. |
| Where the classifiers live, "named for the tool that produced it, for example" | I stared at `kraken2-20260907-143005` before working out the digits. | Say the digits are the date and time. |
| Results, "which writes a `.lungfishtax` bundle into a top-level" | I do not know what a bundle is in this app, or what top-level means relative to my project. | Gloss bundle once, and say top-level means directly inside the project folder. |
| Results, "columns for Sample, Taxon Name, Rank, Reads, Direct, and %" | The % column is never explained. Percent of all reads or of classified reads? | State what the percentage is calculated from. |
| Results, "A Bracken column joins them when Bracken" | Bracken appears here with no explanation of what it does. | Gloss Bracken in one clause at first use. |
| Results, "abundance estimation ran alongside the classification" | I do not know what abundance estimation is or how I would make it happen. | Say whether it is a checkbox I tick or something automatic. |
| Databases, "half a gigabyte for the viral-only build to 72 GB" | I can read the numbers but cannot judge whether 72 GB is feasible on my laptop. | Say roughly how much free disk space each end needs. |
| Databases, "lists thirteen databases, nine of them Kraken2" | I could not work out what the other four are or whether I need any. | Name the four, or say which tools they serve. |
| Databases, "which also carries RiboDetector" | RiboDetector is named once and never explained, so I did not know if I needed it. | Add three words saying what it does. |
| What good looks like, "which the run's provenance record names" | I could not perform this check. I do not know where the provenance record is or how to open it. | Name the click that shows the provenance record. |
| What good looks like, "the unclassified fraction is consistent with" | I do not know how to judge this. No number anywhere says what a normal unclassified fraction looks like. | Give one rough range for a typical clinical sample. |

One thing I learned: the gap between the Reads column and the Direct column tells you whether the classifier resolved a genus down to species, so a large gap is informative rather than a problem.

One thing I still could not do: check whether Nextflow and a container runtime are on my machine, because every route I can imagine for that involves a terminal I have never opened.

The sentence I liked most: "A hundred reads spread across a whole genome is a very different observation from a hundred reads stacked on one conserved gene, and only the first supports saying the virus is present."
