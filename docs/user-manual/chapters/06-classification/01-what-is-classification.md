---
title: What Is Read Classification
chapter_id: 06-classification/01-what-is-classification
audience: bench-scientist
prereqs: [01-foundations/02-sequencing-reads, 01-foundations/07-plugin-packs, 03-reads/01-importing-fastq]
estimated_reading_min: 15
task: Understand the question read classifiers answer, tell the three classifiers LGE runs apart from the results it only imports, and pick the one that fits your sample.
tags: [classification, taxonomy, kraken2, esviritu, taxtriage, nao-mgs, nvd, cz-id]
tools: []
parameters_refs: []
entry_points:
  - Tools > Classification > Kraken2...
  - Tools > Classification > EsViritu...
  - Tools > Classification > TaxTriage...
  - File > Import Center... (Classification Results tab)
shots:
  - id: classification-submenu
    caption: "The Tools menu open on its Classification submenu, showing the three runnable classifiers as separate items, Kraken2..., EsViritu..., and TaxTriage..."
  - id: classification-dialog-tool-sidebar
    caption: "The FASTQ/FASTA Operations sheet opened from Tools > Classification > Kraken2..., with Kraken2 already selected and the tool sidebar listing EsViritu and TaxTriage beside it."
  - id: taxonomy-viewport-overview
    caption: "A Kraken2 taxonomy viewport showing the sunburst, the breadcrumb bar, and the per-taxon table with its Filter taxa... search field above the columns."
  - id: import-center-classification-tab
    caption: "The Import Center on its Classification Results tab, showing all six cards, Kraken2 Results, EsViritu Results, TaxTriage Results, NAO-MGS Results, NVD Results, and CZ-ID Results."
illustrations:
  - id: classification-question
    brief: "Schematic showing a FASTQ bundle on the left, a classifier box in the middle labelled with a reference database, and a sunburst diagram on the right with reads assigned to taxonomic groups (host, bacteria, virus, unclassified). Use Lungfish Creamsicle for the classifier box and Deep Ink for the labels."
glossary_refs: [fastq, read, taxon, taxonomic-rank, lowest-common-ancestor, read-classification, metagenomics, kraken2, esviritu, taxtriage, cz-id, nao-mgs, nvd, freyja, plugin-pack, minimizer, k-mer, blast, container, nextflow, host-depletion, import-center, operations-panel, clade, amplicon, paired-end, accession, provenance, coverage, bracken, contig]
features_refs: []
fixtures_refs: [sarscov2-srr36291587]
brand_reviewed: true
lead_approved: true
---

## What it is

[Read classification](../../GLOSSARY.md#read-classification) answers one practical question about a sequencing run, which is what organisms the sample contained. A [read](../../GLOSSARY.md#read) is one stretch of sequence the instrument produced, a few hundred bases long, stored as one record in a [FASTQ](../../GLOSSARY.md#fastq) file. A classifier is a program that goes through the reads one at a time, compares each one against a reference database of known genomes, and writes down which organism it best matches. That reference database is a folder of files you install on your own machine, not a website the app queries, and the last section of this chapter covers installing one. Compare every read in the file and you have a count of which organisms are present and in what proportion.

The answer for a single read is a [taxon](../../GLOSSARY.md#taxon), which is any named group on the tree of life. *Homo sapiens* is a taxon, and so is *Streptococcus*, and so is the virus family *Coronaviridae*. Every taxon sits at a [taxonomic rank](../../GLOSSARY.md#taxonomic-rank), the level of the naming hierarchy it belongs to. The ranks these tools report run from broadest to narrowest as domain, phylum, class, order, family, genus, species, so for a person that ladder reads Eukaryota, Chordata, Mammalia, Primates, Hominidae, *Homo*, *Homo sapiens*. Kingdom is missing from that list because these tools do not report it, not because it was forgotten.

A classifier does not always reach species, and a call that stops at genus is still a usable answer rather than a failure. When a read's sequence is shared by several close relatives, the classifier steps back up the hierarchy and reports the [lowest common ancestor](../../GLOSSARY.md#lowest-common-ancestor), the most specific taxon that all the matching organisms belong to. A read matching every *Streptococcus* species equally well is reported as *Streptococcus* rather than guessed at species level. The tool decides where to stop on its own, from what the database contains, and you do not set that level yourself.

This is a different question from mapping reads to a reference genome. Mapping starts from an organism you already named and asks where on its genome each read fits. Classification starts from nothing and asks which organism each read came from at all. The two are complementary, and a common working pattern is to classify first to find out what is present, then map against whichever genome the classification named.

![A FASTQ bundle feeding a classifier box that carries a reference database, producing a taxonomy sunburst split into host, bacterial, viral, and unclassified shares](../../assets/illustrations-imagegen/06-classification/01-what-is-classification/classification-question.png)

The whole-sample answer is a distribution rather than a verdict. A classification does not answer yes or no about one organism you had in mind. It reports what share of the reads went to each taxon, calculated over the reads it managed to classify, plus a separate share it could not place at all. Classification of this kind belongs to [metagenomics](../../GLOSSARY.md#metagenomics), the study of all the nucleic acid in a mixed sample at once, which the [Plugin Packs](../01-foundations/07-plugin-packs.md) chapter introduced when explaining why these tools ask for so much memory. What this asks of you is one decision before you run anything. Work out which question you are actually asking, because Lungfish Genome Explorer (LGE) offers several classifiers and they answer different questions.

## Why you would do this

You classify when you cannot fully predict what is in the tube. A clinical swab is the clearest case. Most of what a nasal or throat swab yields is the patient's own genome, because sampling a person collects far more human cells than microbial ones, and whatever pathogen you are chasing sits somewhere in the remainder. Classification answers three questions at once. How much of the run went to human background, whether one bacterium dominates the rest, and whether the virus you suspected is present at all. A targeted assay, meaning a test that looks only for organisms chosen in advance, answers only the third of those, because it reports on nothing it was not designed to look for.

The same reasoning covers a mixed environmental sample, a wastewater pellet, meaning the solid material spun down out of a wastewater sample, a culture you suspect is contaminated, and any run where the quality-control question is simply whether the library holds what you think it holds. [Host depletion](../../GLOSSARY.md#host-depletion), the removal of the sampled organism's own reads, is often run before classification precisely because the host fraction is so large, and the [Decontamination](../03-reads/05-decontamination.md) chapter covers that step.

The example runs in the chapters that follow use the SRR36291587 SARS-CoV-2 reads, a clinical [amplicon](../../GLOSSARY.md#amplicon) dataset of 86,281 read pairs. An amplicon is a stretch of genome copied many times over by PCR before sequencing, so an amplicon run reads a chosen region deeply rather than the whole sample evenly. SRR36291587 is an [accession](../../GLOSSARY.md#accession), the permanent identifier the NCBI Sequence Read Archive gives one public sequencing run. The reads are [paired-end](../../GLOSSARY.md#paired-end), meaning each fragment was read from both ends, so 86,281 pairs is 172,562 reads in all. That is a small run by current standards, which is normal for a clinical amplicon panel covering a single 30 kb viral genome. That is a viral example rather than the human one this manual would usually reach for, and the reason is practical. The databases these classifiers ship with are pathogen databases, built to name microbes and viruses rather than to characterise a host genome, so a viral sample is what actually exercises them end to end. The concepts here apply unchanged to a human clinical specimen, where the classification would report the human fraction as the dominant taxon and the pathogen as a small slice beside it.

## What LGE runs and what it only imports

LGE draws a firm line between classifiers it launches for you and results it accepts from elsewhere. Knowing which side a tool sits on saves a long search for a menu item that does not exist.

Three classifiers run inside the app. [Kraken2](../../GLOSSARY.md#kraken2) surveys a sample broadly, [EsViritu](../../GLOSSARY.md#esviritu) identifies viruses and reports [coverage](../../GLOSSARY.md#coverage) for each one, meaning how much of that virus's genome the reads actually reached, and [TaxTriage](../../GLOSSARY.md#taxtriage) runs a pathogen-detection workflow that scores its calls for confidence. A call is the classifier's decision that a given organism is present, and TaxTriage attaches a numeric score to each one so a reviewer can sort the strong calls from the weak. Each appears as its own item in the **Tools > Classification** submenu, and the app's own one-line descriptions for them are "Classify reads taxonomically", "Detect viruses and report coverage", and "Run the TaxTriage pathogen workflow".

Three more tools produce results LGE can read but never runs. [CZ-ID](../../GLOSSARY.md#cz-id) is a hosted metagenomics service you use through a web browser. [NAO-MGS](../../GLOSSARY.md#nao-mgs) is a wastewater metagenomic surveillance pipeline from SecureBio. [NVD](../../GLOSSARY.md#nvd) is a novel-virus pipeline that assembles reads into longer sequences, stitching overlapping reads into stretches called [contigs](../../GLOSSARY.md#contig) without any step you perform yourself, then searches each contig against a public database with [BLAST](../../GLOSSARY.md#blast). For all three, you run the analysis upstream and bring the output into LGE, which converts it into a result you can browse and export. Each import chapter names the file its tool produces. LGE also records [provenance](../../GLOSSARY.md#provenance) for an imported result, meaning the record of where a result came from and how it was produced, so an imported result carries the same history as one you ran yourself.

The table below is the whole catalogue. Each tool has its own chapter later in this part. The last column asks what biological question the tool answers best, and for the three import-only tools that question is the one the upstream run already answered.

| Tool | Does LGE run it? | The question it answers best |
|---|---|---|
| Kraken2 | Yes, from **Tools > Classification > Kraken2...** | What is in this sample, across bacteria, archaea, viruses, and host? |
| EsViritu | Yes, from **Tools > Classification > EsViritu...** | Which viruses are here, and how much of each genome did we recover? |
| TaxTriage | Yes, from **Tools > Classification > TaxTriage...** | Is a reportable pathogen present, and how confident is the call? |
| CZ-ID | No, import only | What is in this sample, according to a run made on a hosted service? |
| NAO-MGS | No, import only | Which viral taxa are circulating in this wastewater catchment? |
| NVD | No, import only | Is there a virus here that no database names exactly? |

A colleague may have run Kraken2, EsViritu, or TaxTriage for you on another machine, so the import route is wider than those three tools. The Import Center's Classification Results tab carries six cards, not three, and a result produced elsewhere imports just as readily as one you ran natively. That is why the tab holds more cards than the table above has import-only rows. Open it with **File > Import Center...** and pick the Classification Results tab.

<!-- SHOT: import-center-classification-tab -->

One tool has a chapter among the classification chapters without being a classifier. [Freyja](../../GLOSSARY.md#freyja) estimates which SARS-CoV-2 lineages are mixed together in a wastewater sample, and it does not classify reads at all. A lineage is a named subgroup inside one species, finer than any rank a classifier reports, so Freyja is answering a question that starts after the species is already known. It reads the variant table and the depth table that a mapping run produces, listing which positions differ from the reference and how many reads covered each position, and works out what mixture of known lineages would explain them. [Running Freyja](07-running-freyja.md) covers it, and it belongs after mapping rather than instead of a classifier.

## Picking a classifier for your sample

Two questions settle the choice most of the time. How much do you already know about the sample, and what will you do with the answer?

Start with **Kraken2** when you have no specific hypothesis. It covers the widest range of organisms LGE offers, because its Standard database covers archaea, bacteria, viruses, plasmids, the human genome, and vector sequence in one pass. Vector sequence means the laboratory cloning DNA that sometimes contaminates a library, which is worth naming so you do not read it as a biological finding. Fungi and protozoa are not in Standard. They arrive with the PlusPF builds, PlusPF standing for Plus Protozoa and Fungi, where a build is one prepared version of a database rather than a different program. The [Plugin Packs](../01-foundations/07-plugin-packs.md) chapter lists those builds alongside the other database collections. Kraken2 is also the right first move for routine quality control, where the question is whether the host fraction looks the way you expected and whether anything unexpected is riding along.

Kraken 2's own documentation describes how it does this, and the short version is worth carrying. It matches short fixed-length words of sequence called [k-mers](../../GLOSSARY.md#k-mer), a few dozen bases each rather than a whole read, and it stores one chosen representative k-mer, called a [minimizer](../../GLOSSARY.md#minimizer), to stand in for each group of neighbouring k-mers. Looking up short exact words is far cheaper than aligning, which means fitting each read against a reference base by base, and that is why Kraken2 can survey tens of millions of reads in a single pass.

Move to **EsViritu** once you know you are looking at a virus and want a more careful viral answer. Its database is a curated set of viral genomes rather than a broad tree of life, and rather than only counting reads it reports how much of each viral genome those reads actually covered. Coverage matters for a viral call in a way read count alone does not. A hundred reads spread across a whole genome is a very different observation from a hundred reads stacked on one conserved gene, meaning a gene that is nearly identical across many organisms and so cannot tell them apart, and only the first supports saying the virus is present. The Coverage column in the EsViritu results table is where you read that difference. Run EsViritu as a second pass after a broad survey. You can also run it first when the sample type makes a viral target near certain.

Reach for **TaxTriage** in a pathogen-detection setting where a reviewer needs to see how well supported each call is. It runs as a [Nextflow](../../GLOSSARY.md#nextflow) pipeline, meaning a published multi-step workflow driven by a workflow engine rather than a single program, and it scores the organisms it reports for confidence. It is heavier to set up than the other two, because it needs both Nextflow and a [container](../../GLOSSARY.md#container) runtime present on the machine. You do not have to guess whether yours has them. The TaxTriage pane in the operations sheet carries a Prerequisites row with an indicator for each, so opening it tells you at a glance, and its own chapter covers what to do when either is missing. It also classifies against an installed Kraken2 database rather than carrying one of its own.

Import instead of rerunning when your lab already produced a result elsewhere. Rerunning a classifier only to view its output wastes hours and produces a second answer you then have to reconcile with the first.

A reasonable default, when the choice still feels open, is to run Kraken2 first to see the shape of the sample, then run a more specific tool on the same reads to sharpen whatever it turned up.

## Where the classifiers live

Every runnable classifier opens from the **Tools** menu. Open **Tools > Classification** and you get a submenu with three items, **Kraken2...**, **EsViritu...**, and **TaxTriage...**. There is no single Classification command that then asks which tool you want. You choose the tool in the menu.

<!-- SHOT: classification-submenu -->

Select your reads in the project sidebar before you open the menu. The classifiers work on whatever is selected when they open, and they offer no file picker of their own, so an empty selection means going back and starting again. What you are selecting is a reads bundle under the project's `Imports/` folder, put there by the [Importing Sequencing Reads](../03-reads/01-importing-fastq.md) chapter.

Picking a menu item opens a sheet headed FASTQ/FASTA Operations with your chosen classifier already selected. That heading names the sheet, not a menu, and the same sheet serves the trimming, filtering, and mapping tools from their own submenus. A sidebar down its left edge lists the other classifiers in the Classification category, so switching from Kraken2 to EsViritu takes one click rather than a trip back to the menu. Near the top of the sheet, a dataset line reports what you selected. It shows the bundle's path inside the project when one bundle is selected, reads "No FASTQ selected" when nothing is, and reads as a count such as "3 FASTQ datasets" when several are, which is also how you start a run across several samples at once.

<!-- SHOT: classification-dialog-tool-sidebar -->

The button that starts the work says **Run**. Clicking it closes the sheet and registers the work in the [Operations panel](../../GLOSSARY.md#operations-panel), where a single-sample Kraken2 run appears as a row titled "Classifying" followed by the input file name, and a multi-sample run appears as "Classification Batch" followed by the sample count. The main window stays usable while the run proceeds.

A finished run lands in the project's `Analyses` folder in its own timestamped subfolder, named for the tool that produced it, for example `kraken2-2026-09-07T14-30-05`. Everything after the tool name is the date, then a `T`, then the time in hours, minutes, and seconds, so that folder holds a run started at half past two in the afternoon on 7 September 2026. Nothing is written back onto the reads bundle you started from. That is what lets a Kraken2 result and an EsViritu result on the same reads sit side by side without either overwriting the other, and it means a project accumulates a readable history of every classification you ran.

The one exception is a CZ-ID import, which writes a `.lungfishtax` bundle into a `Classifications` folder sitting directly inside the project folder rather than under `Analyses`. The app chooses that location for you rather than asking. You never handle the `.lungfishtax` file directly. Click it in the sidebar and it opens as a result, the same as anything else in the project. [Importing CZ-ID Results](08-importing-cz-id-results.md) covers that path.

## What you will see in the results

The result window depends on the tool. Kraken2 results, and imported CZ-ID results, open the taxonomy viewport described here. EsViritu, TaxTriage, NAO-MGS, and NVD each open a table built around what that tool actually reports, and their own chapters describe them.

<!-- SHOT: taxonomy-viewport-overview -->

The taxonomy viewport shows the same result three ways, as a sunburst chart, a table, and a breadcrumb bar. Clicking a taxon in the sunburst or the table selects it in the other, and the breadcrumb bar follows as you drill down.

The sunburst is the at-a-glance view. It is a ring chart read from the middle outwards. The centre is labelled with the taxon everything else sits beneath, along with its read count, and each ring further out is a finer taxonomic rank. The angular width of a wedge is proportional to the number of reads assigned to that taxon and everything below it, so one glance tells you whether the sample is dominated by a single organism or spread thinly across many. Colour groups the wedges by phylum, so relatives sit in related shades. There is no legend, and hovering over a wedge names it.

The table is the precise view. One row per taxon, with columns for Sample, Taxon Name, Rank, Reads, Direct, and %. Sample names which input the row came from, which matters in a batch run and simply repeats the input name when you ran one sample. Reads is the [clade](../../GLOSSARY.md#clade) count, meaning every read assigned to that taxon or to anything beneath it, while Direct counts only the reads pinned to that exact taxon and no lower. The difference between them is informative. A genus with a large Reads figure and a near-zero Direct figure means the classifier resolved almost everything to species beneath it, and a genus where the two are close means it mostly could not. The % column is that row's clade count as a share of the reads the classifier managed to classify, so the unclassified reads are not in the denominator.

A Bracken column joins those six when [Bracken](../../GLOSSARY.md#bracken) ran alongside the classification. Bracken is a companion program to Kraken2 that pushes reads parked at a broad rank back down onto the species they most likely came from, so its column often names a species where the Reads column stops at a genus. You do not tick a box for it. A Kraken2 run started from the operations sheet always runs Bracken after the classification. Above the columns sits a **Filter taxa...** search field that narrows the table to matching names, which is the fastest way to check for one organism in a result holding thousands of rows.

The breadcrumb bar keeps track of where you are. It records the path you drilled down through and lets you step back up to a parent rank without losing your place.

What the viewport reports is not the same as what the sample contained, and the distinction matters. Every row says that this many reads were assigned to this taxon, by this classifier, against this database. Change the database and the same reads give a different answer. A read goes unclassified when its organism is absent from the database, when it is too short to carry a distinguishing signal, or when it falls in a stretch of sequence too conserved to separate one organism from another. Some unclassified fraction is normal in any real sample. There is no single number that separates normal from alarming, because the honest expectation depends entirely on the database. A viral-only database run on a human swab should leave nearly everything unclassified, while a Standard database run on the same swab should place most of the reads on the human genome. Work out what your database could possibly have matched before you judge the number, and treat a surprise as a prompt to check the database you chose rather than to doubt the sample.

## Databases, and why you install one first

A classifier with no database has nothing to compare reads against, and none of these databases ship inside the application. The reason is size. The Kraken2 collections run from 0.5 GB for the viral-only build to 72 GB for PlusPF, and asking everyone to download the whole set on first launch would be unreasonable when almost nobody needs more than one.

Tools and databases install separately, and both go through the Plugin Manager at **Tools > Plugin Manager...** (Cmd-Shift-B). The keyboard shortcut opens exactly the same window as the menu item, so use whichever you prefer. Kraken2, Bracken, and EsViritu arrive together in the `metagenomics` [plugin pack](../../GLOSSARY.md#plugin-pack), shown in the Plugin Manager as Metagenomics, which also carries RiboDetector, a tool for stripping ribosomal RNA reads out of a library before classification. TaxTriage is not in a pack at all, because it runs as a containerised Nextflow pipeline rather than as an installed program, and it classifies against whichever Kraken2 database you already have.

The Plugin Manager's Databases tab lists thirteen databases. Nine are the Kraken2 collections just described, built from RefSeq. Two more, SILVA and Greengenes, are also Kraken2 databases but are built from ribosomal RNA reference collections for 16S work rather than from whole genomes. The last two serve other tools, one being the EsViritu Viral DB that EsViritu needs and one being NCBI Taxonomy, which supplies the names and the hierarchy every result is labelled with. The [Plugin Packs](../01-foundations/07-plugin-packs.md) chapter walks through installing one and reading what each collection covers.

Two things follow from this that are worth knowing before you start. The first is that a machine set up for one classifier and one database is a perfectly normal setup, and most people never install more. The second is that the large collections are large downloads, so if your work needs a Standard or PlusPF build, start it before you need it rather than at the moment you sit down to analyse a sample. A database also occupies its download size in free disk space once installed, so PlusPF needs 72 GB free on the machine before you start. The capped builds exist for exactly this problem. Standard-8 and PlusPF-8 cover the same ground as their full versions inside an 8 GB limit, at the cost of resolving fewer reads.

## What good looks like

Three checks tell you a classification result is worth interpreting.

1. The run finished rather than stopping. The Operations panel shows this, and the presence of a timestamped folder under `Analyses` confirms it. A run that stopped leaves a failed row in the panel instead, and the [Troubleshooting](../appendices/troubleshooting.md) appendix covers reading one.
2. The database you meant to use is the one that ran. Open the taxonomy viewport's export menu and choose **Show Provenance...**, which names the tool version, the database, and the path it was read from. This matters most on a machine with several databases installed.
3. The unclassified fraction is consistent with the sample type and the database rather than surprising you. A viral-only database run against a clinical swab will leave most reads unclassified by design, because it has no human genome to match them to, and that is the expected result rather than a fault.

When a result disagrees with what you expected, suspect the database before the sample. The commonest cause of a taxon missing from a result is that it was never in the reference collection to begin with.

## Next

Continue to [Running Kraken 2](02-running-kraken2.md) for a full walkthrough of a broad survey, which is the run most readers want first. From there, [Running EsViritu](03-running-esviritu.md) covers viral identification with coverage, and [Running TaxTriage](04-running-taxtriage.md) covers confidence-scored pathogen detection. [BLAST Verification](06-blast-verification.md) shows how to check a single surprising hit against NCBI, and the import chapters, [Importing NAO-MGS Results](05-running-nao-mgs.md), [Importing CZ-ID Results](08-importing-cz-id-results.md), and [Novel Virus Diagnostics](09-novel-virus-detection.md), cover results produced elsewhere.

One chapter in this part answers a classification question through a different menu. [12S Amplicon Metabarcoding](10-twelve-s-metabarcoding.md) identifies vertebrate species from a short mitochondrial marker, and the app files it under Genotyping rather than Classification, so you will not find it in the submenu this chapter described. It shows in the **Tools > Genotyping** submenu as "12S Amplicon Matching (not enabled)" in grey until you enable it through **Tools > Workflow Library...**.
