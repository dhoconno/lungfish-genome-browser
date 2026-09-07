---
title: 12S Amplicon Metabarcoding
chapter_id: 06-classification/10-twelve-s-metabarcoding
audience: bench-scientist
prereqs: [06-classification/01-what-is-classification, 03-reads/01-importing-fastq]
estimated_reading_min: 30
task: Match merged 12S amplicon reads to a deduplicated reference FASTA, resolve cross-species ambiguity, review unresolved clusters, and export species rows.
tags: [classification, metabarcoding, twelve-s, amplicon, blast, export]
tools: [blast, vsearch]
parameters_refs: [classify.twelve-s-match]
entry_points:
  - "Tools > Workflow Library..."
  - "Tools > Genotyping > 12S Amplicon Matching..."
  - "CLI: lungfish-cli fastq 12s-match"
shots:
  - id: twelve-s-workflow-library
    caption: "The Workflow Library window with the 12S Amplicon Matching card under Specialized Workflows, showing its Specialized badge, its dependency row for the Third-Party Tools pack, and the Enabled switch."
  - id: twelve-s-dialog-inputs
    caption: "The Workflow Operations dialog on 12S Amplicon Matching, showing the Reference picker with its Create 12S Reference... button, the Analysis Metadata picker, and the FASTQ Bundles list."
  - id: twelve-s-dialog-options
    caption: "The same dialog's Read Platform segmented picker, Result Name field, and Min Soft Clip field, with the Advanced Options disclosure expanded to show Max Indels and Run vsearch chimera review."
  - id: twelve-s-result-species-table
    caption: "The 12S viewport on its Targets view, showing the Sample, Scientific Name, Common Names, Group, Tax ID, Exact Reads, % of Sample, Refs, and Alternates columns above the summary line."
  - id: twelve-s-unresolved-clusters
    caption: "The viewport's Unresolved view, showing the Sequence, Reads, Samples, Chimera, and Bases columns for the clusters that matched no reference."
  - id: twelve-s-blast-review
    caption: "An unresolved cluster sent to NCBI BLAST with the BLAST Verify button, with the returned Organism, Identity, and Accession hits in the drawer below the table."
  - id: twelve-s-export
    caption: "The viewport's Export menu offering Export as CSV..., Export as TSV..., and Export as Excel..."
illustrations: []
glossary_refs: [amplicon, blast, chimera, deduplicated-reference, fastq, metabarcoding, plugin-pack, read, read-orientation, soft-clip, taxonomy-id, twelve-s, vsearch]
features_refs: [classify.twelve-s]
fixtures_refs: [primate-12s]
brand_reviewed: true
lead_approved: true
---

## What it is

12S metabarcoding identifies which vertebrate species are present in a mixed sample. The 12S ribosomal RNA gene sits in the mitochondrial genome, the small separate loop of DNA every animal cell carries outside its nucleus. A short slice of that gene, usually somewhere between 100 and 200 bases, can be copied by the polymerase chain reaction (PCR) using primers that bind conserved sites shared across vertebrates. That length is a description of the marker rather than a rule the software enforces, and it is shorter than a typical Illumina read of 150 or 250 bases, which is why one read can hold the whole slice.

Primers are short pieces of synthetic DNA that mark where copying starts and stops, and conserved means the sequence at those sites has stayed the same across many species. The copied slice is an [amplicon](../../GLOSSARY.md#amplicon), meaning a defined stretch of DNA amplified from a known pair of primer sites. The primer sites stay constant while the interior of the slice differs from species to species. That contrast is what makes the marker work, because reading the interior tells you which animal the DNA came from.

[Metabarcoding](../../GLOSSARY.md#metabarcoding) is the practice of amplifying and sequencing one marker gene across a whole mixed sample at once, so you get an inventory of the taxa present rather than a single answer. A taxon is any named group in the tree of life, from a species up to a whole class. This approach is common in diet studies, where you ask what an animal ate, in environmental DNA work, where you ask which species passed through a body of water or a patch of soil, and in any mixed-sample setting where you need a roster of the animals present.

Lungfish Genome Explorer (LGE) resolves a 12S run by exact matching rather than by a taxonomic database. Each [read](../../GLOSSARY.md#read), meaning one stretch of sequence the instrument produced, is checked against a [deduplicated reference](../../GLOSSARY.md#deduplicated-reference) FASTA. That is a curated file where every record is one known 12S sequence labelled with the species it belongs to, and where identical sequences have been collapsed so each unique sequence appears exactly once. FASTA is the plain-text format that stores a name line beginning with a greater-than sign followed by the sequence itself.

The matching rule is one sentence, and the whole chapter rests on it. A reference record must appear inside the read as an unbroken run of bases, every base the same and in the same order, and the read is then assigned to that record's species. The read is longer than the record and carries its own bases at each end, so the record is contained rather than equalled.

This differs from a classifier such as Kraken 2, another LGE workflow covered earlier in this part, which breaks reads into short overlapping chunks and looks those chunks up in a large tree-of-life database. Exact matching is the right tool here for three reasons. A 12S amplicon is short, the reference is small and curated rather than very large and machine-built, and a base-perfect match to a curated record is a confident species call in a way that a partial match never is. The trade is that a species missing from your reference can never be reported, no matter how many reads it contributed. Run the workflow against a reference built for the animals you expect, read the species table for what resolved, then look at the unresolved clusters before you trust the roster.

## Why you would do this

You would run 12S matching when your sample is a mixture and the question is which vertebrates are in it. A gut-content sample, a water sample, a swab from a surface, or a pooled field collection all give you DNA from several animals at once. Neither [mapping](../04-alignments/01-mapping-reads-to-a-reference.md), which lines reads up against one chosen genome, nor [variant calling](../05-variants/01-calling-variants-from-amplicons.md), which asks how one sample's sequence differs from a reference, will answer the roster question for you.

The reason to prefer exact matching over a broad classifier is confidence in the individual call. A broad classifier is built to place a read somewhere in the tree of life even when the evidence is thin, so it will report a genus, a broader claim than a species, when the read only supports a family, which is broader still. For a species roster that behaviour is a problem, because the whole value of the result is that each named species is really there. Exact matching against a curated reference refuses to guess. A read either contains a known 12S sequence exactly or it does not, and the reads that do not are kept separately for you to look at rather than forced into a call.

The cost of that strictness is that the reference decides what you can find, so this workflow rewards care in building the reference and rewards reading the unresolved view afterwards. This chapter works through a human example, matching reads from one person against a small reference holding five primates.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. A name written as Cmd-N is a keyboard shortcut, meaning hold the Command key and press N. LGE runs on macOS, which is where these shortcuts and menu paths apply.

This chapter uses the primate 12S fixture. Download the folder `primate-12s` from the manual's fixtures on GitHub at

https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/primate-12s

GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`.

Three files inside that folder do the work. `primate-12s-dedup.fasta` is the deduplicated reference. `primate-12s-midori.tsv` is the metadata table that labels each reference sequence with its species. `HG002-12S-oriented.fastq` holds the reads you will match.

The fixture is a constructed teaching set rather than a published metabarcoding study. Five primate 12S sequences were cut from public mitochondrial genomes, and the reads are HG002's own mitochondrial reads trimmed to the 12S region, so the human reads are expected to match Homo sapiens and nothing else. HG002 is a public reference human sample, sequenced and released so that everyone can test their methods on the same DNA.

Orientation matters here more than anywhere else in this workflow, so it is worth a paragraph before you start. DNA is double-stranded and a sequencer can read a fragment from either strand, which means the same stretch of sequence arrives either as written or as its [reverse complement](../../GLOSSARY.md#reverse-complement), the same bases read backwards with each one swapped for its partner. The 12S matcher checks one strand only. It never tries the reverse complement, so a read carrying the target on the other strand is silently left unmatched with nothing in the result to say why. Matching the fixture's reads before they were oriented found only 35 of the 110 the author's run found afterwards, because the other 75 carried the target on the opposite strand. The reads in `HG002-12S-oriented.fastq` were already turned the right way round with the Orient Reads operation described in [Read Processing](../03-reads/08-read-processing.md), so you have nothing to do here. Orient your own reads the same way, and merge their pairs with the Merge Overlapping Pairs operation in that same chapter, before you match them.

Merging is the other requirement. The workflow expects reads that are already merged, meaning that the forward and reverse reads of each pair have been stitched into one sequence covering the whole fragment, and it does not merge pairs for you. The fixture's reads need no merging. Without it, the short 12S targets come back with almost nothing matched.

12S Amplicon Matching is a specialized workflow rather than a core one, so it does not appear in the menus until you enable it. Open **Tools > Workflow Library...**, find the **12S Amplicon Matching** card under the **Specialized Workflows** heading in the **Genotyping** group, and turn its **Enabled** switch on. The card shows a **Specialized** badge beside its title and a dependency row underneath reading either Ready or Needs install for the [plugin pack](../../GLOSSARY.md#plugin-pack) the workflow depends on, which the card names as **Third-Party Tools**. A plugin pack is a themed group of tools LGE downloads on demand into its own private storage, so nothing is added to the rest of your Mac and nothing has to be undone later. Installing one needs a network connection, since the pack is downloaded. If that row says Needs install, the switch is replaced by an **Install Dependencies** button that fetches the pack and enables the workflow when it finishes. Once the switch is on, the workflow appears as **Tools > Genotyping > 12S Amplicon Matching...**.

Until you do this, the Tools menu still lists the workflow, but greyed out and with the words "(not enabled)" after its name. Choosing it in that state does not run anything. It raises a message window headed Enable "12S Amplicon Matching"? whose **Open Workflow Library** button takes you to the card described above.

<!-- SHOT: twelve-s-workflow-library -->

The Inspector is worth opening before you go further, because six of this workflow's settings live in it rather than in the run dialog. It is the panel down the right-hand side of the window, and **View > Show Inspector** (Cmd-Opt-I) shows it if it is hidden.

## Procedure

### 1. Choose or build a 12S reference

The workflow needs a deduplicated 12S reference before it can match anything. It takes that reference in either of two forms. A plain FASTA is the form you will have when someone sends you a reference or when you cut one yourself, and it is the form the fixture ships. A `.lungfish12sref` bundle is a folder LGE has already packaged, holding the sequences and their species labels together so later runs need only the one item. Bundle is LGE's word throughout for a folder the app treats as a single file, which is why reference bundles, read bundles, and result bundles all carry the name.

The fixture gives you the plain FASTA, so you can go straight to step 2 and point the Reference picker at `primate-12s-dedup.fasta`. Build a bundle when you expect to reuse the same reference often.

To build one inside the app, choose **Tools > Genotyping > 12S Amplicon Matching...** and click **Create 12S Reference...** beside the Reference picker. The builder asks for the fixture's two files. The first is the deduplicated FASTA itself. Its name lines must read as a common name followed by the scientific name in parentheses, for example `>Rhesus macaque (Macaca mulatta)`, and the parentheses are required rather than decorative. The second is a metadata table in the MIDORI style, named for the public reference database of animal mitochondrial marker sequences whose column layout it follows. It is a tab-separated file carrying one row per sequence, and the full list of columns it must have is given in the command-line section at the end of this chapter, because the builder needs all seven rather than the four a reader usually thinks of. Those four are the common name, the scientific name, the taxon group, and the [taxid](../../GLOSSARY.md#taxonomy-id), the number NCBI's taxonomy database assigns to that species.

LGE then matches each FASTA record to its metadata row by the scientific name and writes a `.lungfish12sref` bundle. In Preview 2026.9.13 a name line without parentheses, such as `>Homo_sapiens`, matches no row and produces a reference whose species, common name, taxid, and group columns are all empty, with no warning and a successful exit, so check that your built reference carries species names before you match against it.

### 2. Open the workflow and set its inputs

Choose **Tools > Genotyping > 12S Amplicon Matching...**. The Workflow Operations dialog opens with the workflow already selected.

Set the **Reference** to `primate-12s-dedup.fasta` using its **Choose...** button. The Project Reference menu above that button is a shortcut rather than a second route. LGE scans the whole project folder for reference bundles it recognises and lists what it finds there, so a loose FASTA sitting outside the project never appears in it and an empty menu means only that no bundle has been saved into the project yet.

Set the **FASTQ Bundles** to the reads. This picker lists the read bundles in your project rather than loose files, so import `HG002-12S-oriented.fastq` first if you have not already, following [Importing FASTQ Files](../03-reads/01-importing-fastq.md). Selecting more than one bundle is allowed and they run together as one batch, which is what the summary line under the picker means when it says they will run as one batch. Batched does not mean pooled. LGE counts every sample separately and gives each one its own rows in the result, so a five-bundle run reports five samples rather than one merged roster.

The **Analysis Metadata** picker is optional and the fixture does not need it. Give it a CSV or TSV with a `sample_id` column whose values match the read bundle names, plus whatever else you want recorded, and the viewport will show those fields as extra columns beside the species counts. A column headed `sample`, `sample_name`, or `id` is accepted in place of `sample_id`. That is how you get collection site or date onto the same table as the read counts.

<!-- SHOT: twelve-s-dialog-inputs -->

### 3. Set the platform and run

Leave the **Read Platform** picker on the Illumina setting, which is what the fixture's reads need, or switch it to the Nanopore setting for Oxford Nanopore reads. Give the run a **Result Name** if the suggested one will not identify it later.

The only other fields are Min Soft Clip, and Max Indels and the chimera review checkbox inside Advanced Options. Every one of them is already set to the value the worked example used, and those values work unchanged for Illumina reads, so you can run now and read Settings afterwards.

Click **Run**. The workflow matches the merged reads against the reference, resolves reads whose sequence is shared between two or more species, a case Reading the results explains in full, reviews the unresolved clusters for chimeras, and writes a result bundle into the folder shown under **Directory**.

<!-- SHOT: twelve-s-dialog-options -->

### 4. Read the species table

The result appears in the sidebar down the left of the window, under the project's `Analyses` folder in a folder named `12S amplicon results`. Double-click it to open the 12S viewport, the main panel in the middle of the window where LGE draws a result. It opens on the **Targets** view, which is the species table, and each row is one species in one sample.

Nine columns describe that row. Sample, Scientific Name, and Common Names identify it. Group is a label such as Mammal or Fish, taken from the reference's own metadata rather than from any formal taxonomic rank, and Tax ID is the NCBI number for the species. Exact Reads and % of Sample are the counts, and Reading the results below takes them together.

The last two columns are the ones that decide how much to trust a row. Refs is how many reference records matched this species, where a record is one entry in the reference FASTA. A species can have several records when the reference carries more than one 12S variant for it, and a higher count is neither good nor bad by itself. Alternates is how many other species share the matched sequence, so a nonzero value there is the app telling you the name is not certain.

A summary line above the table reports four figures separated by vertical bars, in the order samples, exact reads, percent unresolved, chimera candidates. The worked example's line reads

    1 samples | 110 exact reads | 36.4% unresolved | 0 chimera candidates

Sort by Exact Reads to put the dominant species at the top, and use the **Filter species or matches** field to narrow the table by species name, common name, taxon group, or alternate-match text.

<!-- SHOT: twelve-s-result-species-table -->

Right-clicking a single species row adds two lookups to the bottom of the context menu. **Learn More About** opens that species' NCBI Taxonomy page in your browser, using its taxid when the reference supplied one and a name search otherwise. **View Photo of** opens its Wikipedia article, which carries a photograph of the animal. Both open the browser immediately and do not ask for confirmation first. That is intended behaviour rather than a fault, so treat them as a way to look something up rather than as a step in the analysis.

### 5. Review the unresolved clusters

Switch the view to **Unresolved**. An unresolved sequence cluster is a group of reads that all carry the same sequence. A cluster lands here for one of two reasons. Either it matched no reference record at all, which is the common case, or it matched several species whose sequences are identical and the abundance rule described in Reading the results could not pick a winner between them.

Five columns describe each cluster. Sequence holds a short label naming the cluster rather than any DNA, and the DNA itself is in the last column, Bases. Between them, Reads is how many reads the cluster holds, Samples is how many samples they came from, and Chimera is the verdict of the review described in Settings.

Sort by Reads. A cluster with many reads and a Chimera status of not detected is the most interesting case, because it is a sequence your sample produced in quantity that matched nothing you gave it, which often means a species your reference does not cover. Clusters marked as chimera candidates are usually artifacts, meaning sequences created by the laboratory process rather than by any organism, and can be set aside. A [chimera](../../GLOSSARY.md#chimera) is the commonest kind, formed when two real templates join during PCR so the result looks like one genuine molecule while belonging to no animal.

<!-- SHOT: twelve-s-unresolved-clusters -->

### 6. Verify a cluster with BLAST

Select one or more unresolved clusters and click **BLAST Verify**. That button sits in the action bar, the strip of buttons running along the bottom edge of the viewport, which also holds Export and the information button used later in this chapter.

LGE sends the cluster sequence to [BLAST](../../GLOSSARY.md#blast), NCBI's public sequence search service, which compares it against GenBank, NCBI's public collection of published sequences, and returns the closest records it holds. The sequence leaves your machine to do this, travelling to NCBI's servers with no confirmation step in between, so check your laboratory's data-handling rules before sending anything you are not free to share. The hits appear in a drawer below the table with Organism, Identity, and Accession columns, where the accession is the permanent identifier of the GenBank record.

Read the Identity column first. It reports what percentage of the compared bases agree, so the closer to 100 the hit sits, the stronger the claim. A near-perfect hit to a plausible animal is good evidence that the cluster is a real species missing from your reference, and a hit whose identity drops well below the rest of the list is too distant to name a species from. This chapter gives no fixed cutoff, because the honest one depends on how densely your target group is represented in GenBank. A scattered result, meaning top hits to organisms with nothing to do with each other or with your sample, points back toward an artifact. One cluster takes as long as NCBI's queue takes, which is much slower than the local match because the work happens on NCBI's servers rather than yours. [BLAST Verification](06-blast-verification.md) covers the drawer and the judgement in more detail.

<!-- SHOT: twelve-s-blast-review -->

### 7. Export the table

Click **Export** in the action bar. The menu offers **Export as CSV...**, **Export as TSV...**, and **Export as Excel...**. The Excel export puts the unresolved clusters on a second sheet, so one file carries both tables.

Every export honours the Inspector filters described in Settings below. All of them are off on a fresh result, so an export made right after a run carries every row, and filtering the table to one taxon group before exporting is what gives you just those rows.

The viewport has no FASTA export. The workflow already wrote an `unresolved-sequences.fasta` into the result bundle, and you can reach it without the command line. Right-click the result in the sidebar and choose **Show in Finder**, which opens the enclosing folder with the bundle selected, then open the bundle like any other folder to find the FASTA inside. The other route is the `12s-export-unresolved` command shown at the end of this chapter, which is also the only way to filter what goes into the FASTA.

<!-- SHOT: twelve-s-export -->

## Settings

The dialog carries eight controls and the Inspector's **12S Results** section carries six more that filter what the viewport shows. Each entry below names the control, says what it does, gives its default, and ends with the command-line flag that does the same job. Those closing sentences belong to the optional command-line section at the end of this chapter, so skip them if you are staying in the window. Nothing later depends on having read them.

**Reference.** Names the collection of known 12S sequences every read is matched against, which is the most important choice in the run because a species missing from this file can never be reported. There is no default and the Run button stays disabled until you supply one, either as a deduplicated FASTA or as a `.lungfish12sref` bundle. Use a reference built for the animal group you are studying, since a fish-only reference will not name the mammals in a gut sample. On the command line this is `--reference`.

**Analysis Metadata.** Stores a copy of a table of per-sample information inside the result so the viewport can show it as extra columns beside the species counts. It starts empty, reading "No analysis metadata selected", and the run proceeds without it. Supply a CSV or TSV of per-sample rows when you want collection site, date, or host recorded alongside the counts. On the command line this is `--sample-metadata`.

**Read Platform.** Chooses how much difference the match allows, as a segmented picker with two settings whose on-screen labels are the names used here. The default is Illumina exact, which accepts only reads that contain a reference sequence with no substitutions at all. Switch to ONT indel-tolerant for Oxford Nanopore reads, ONT being the usual short form of that company's name, whose characteristic error is the inserted or deleted base that this setting allows and the Illumina setting rejects. On the command line this is `--matching-mode`.

**Result Name.** Names the `.lungfish12s` result bundle the run writes. It arrives filled in with a name worked out from the read files you selected. Change it when that suggested name will not identify the run six months from now. On the command line this is `--output-name`.

**Min Soft Clip.** Sets how many of the read's own bases must sit on each side of the matched reference stretch, which rejects reads that only graze the target rather than containing it. Picture the read as a line with the matched reference stretch marked somewhere inside it, and the [soft clip](../../GLOSSARY.md#soft-clip) is the leftover length hanging past each end of that mark. The default is 1, so a read needs at least one base of its own beyond each end, and the field accepts 0 or more. Raise it when short partial overlaps are producing matches you do not trust, and set it to 0 only when a read may legitimately begin or end exactly at the target's edge. On the command line this is `--min-soft-clip`.

**Max Indels.** Sets how many inserted or deleted bases a read may carry and still count as a match. The default is 3, which applies only in the ONT indel-tolerant platform setting, since the field is greyed out under Illumina exact and has no effect there. Against a 60-base target like the fixture's, three indels is a change to one base in twenty. Raise it for noisier Nanopore chemistry, and lower it when you want only near-perfect matches. It lives inside **Advanced Options**, a section you expand by clicking the arrow beside its name. On the command line this is `--max-indels`.

**Run vsearch chimera review.** Checks the unresolved sequence clusters for chimeras using [vsearch](../../GLOSSARY.md#vsearch), a sequence-comparison program that ships inside the Third-Party Tools pack, so each cluster comes back marked not reviewed, not detected, candidate, or confirmed. The review itself only ever writes not detected or candidate, so candidate is the verdict to expect on a real chimera and confirmed is reserved for a judgement made outside this step rather than something vsearch reports. It is ticked by default because a chimera looks exactly like a novel species until something checks it. Leave it on, and untick it only to shorten a run whose unresolved clusters you will not look at. It also lives inside **Advanced Options**. On the command line this is `--chimera-review`, with `--no-chimera-review` turning it off.

**Directory.** Chooses where the result bundle is written, and defaults to the project's 12S amplicon results folder. Change it only when the result belongs somewhere outside the project folder. On the command line this is `--output-dir`.

The six controls that follow live in the Inspector's **12S Results** section rather than in the dialog, which is why you were asked to open the Inspector in Before you start. They filter what the viewport draws and what an export writes, and none of them changes the stored result, which is why each one corresponds to a flag on the export command rather than on the match command. The first four sit under **Target Rows** and the last two under **Unmatched Reads**.

**Minimum Exact Reads.** Hides species rows with fewer exact-matching reads than this. The default is 0, so every row that matched at all is shown, and the field accepts 0 to 1,000,000. Raise it to cut the long tail of one-read and two-read hits that are usually noise rather than animals. On the command line this is `--min-exact-reads` on the export command.

**Exclude Human.** Hides the Homo sapiens row from the species table, matching on taxid 9606, the number NCBI's taxonomy database gives our species. It is off by default, so human reads are shown like any other species. Turn it on for diet or environmental studies, where human reads are almost always contamination from whoever handled the sample rather than a finding, and leave it off for work like this chapter's worked example, where the human reads are the result. On the command line this is `--exclude-human` on the export command.

**Only With Alternates.** Shows only the species whose matched sequence is shared with at least one other species, meaning the rows whose names are not certain. It is off by default, so the table shows every species. Turn it on when you want to review exactly which of your calls are ambiguous before you report them. On the command line this is `--require-alternate-matches` on the export command.

**Taxon Groups.** Includes or excludes whole groups of animals, such as Mammal, Fish, or Bird, as a row of pills where each pill cycles through neutral, included, and excluded as you click it. Every pill starts neutral, which places no constraint of its own, so the table shows every group until you set at least one pill. Setting any pill to included narrows the table to the included groups alone, which is what makes neutral different from included once you start clicking. Use it to hold a mixed result to one group, such as fish only in a diet study. On the command line this is `--taxon-group` to keep a group and `--exclude-taxon-group` to drop one, both on the export command.

**Minimum Unresolved Reads.** Hides unresolved sequence clusters with fewer reads than this, in both the Unresolved table and the Excel export. The default is 0, so every cluster is shown, and the field accepts 0 to 1,000,000. Raise it to 2 or higher to skip singleton clusters, which are far more often sequencing error than a real unknown species. This is a different filter from the `--min-reads` option on the FASTA export command described at the end of this chapter, which has its own default of 5. On the command line this is `--min-unresolved-reads` on the export command.

**Chimera.** Restricts the unresolved clusters shown to one chimera verdict, as a pop-up menu offering All, Not Reviewed, Not Detected, Candidate, and Confirmed. The default is All, and Not Reviewed is what every cluster reads when the review was turned off. Choose Not Detected to look only at the clusters that might be genuinely new sequence rather than PCR artifacts. On the command line this is `--chimera-status` on the export command.

## Reading the results

The two views answer different questions and are meant to be read together. The Targets view tells you what is present and catalogued. The Unresolved view tells you what is present and not yet explained.

Read the summary line first, because the unresolved percent frames everything below it. In the worked example for this chapter, 173 merged reads went in and 110 matched exactly, an exact-match rate of 63.6 percent, leaving 63 reads unresolved. The fixture file is a small teaching subset rather than a whole sequencing run, so 173 is the expected size here and not a sign that something went wrong.

The unresolved percent in the summary line and the exact-match rate are two views of one figure rather than two measurements. Both divide by the same 173 reads that went in, so on this run they read 36.4 percent unresolved and 63.6 percent exact, and the pair always adds to 100. Whichever you quote, say which one it is.

Exact Reads and % of Sample are the two columns to read together. Exact Reads is a count. % of Sample is that count as a share of the reads that matched in that sample, counting matched reads only and not the unresolved ones, which is why a species can read 100 percent of a sample whose exact-match rate is 63.6 percent. Those two figures answer different questions and do not contradict each other.

The percent is what lets you compare a species across samples of different sizes. A species holding a large share of one sample and a negligible share of another is a real difference. The same species holding a hundred reads in a deeply sequenced sample and ten in a shallow one may be no difference at all, since the deeper sample simply produced more reads of everything.

With those definitions in hand, the worked example reads cleanly. The species table showed Homo sapiens with 110 exact reads and 100 percent of the sample, and the other four primates in the reference at zero each, those being the chimpanzee, the western gorilla, the rhesus macaque, and the cynomolgus macaque. That pattern, one species holding all the matched reads while its close relatives hold none, is what a single-species sample looks like, and it is the right answer for human reads run against a primate reference.

Alternates is the column that most often changes a conclusion. A nonzero value means the sequence this row matched is identical in at least one other species, so the name on the row is one of several the evidence allows. LGE picks a winner by abundance, described in the next paragraph, and records the ambiguity in this column rather than hiding it. Treat a species with a high Alternates count more cautiously than one with none, and say so in your report if the distinction matters to your question.

Reads whose sequence is shared between species are resolved by abundance. LGE counts how many reads unambiguously support each candidate species elsewhere in the sample, then assigns the shared read to whichever candidate leads. The default policy lets any nonzero lead win, which does mean a one-read lead can decide a call, and the window offers no control over that policy. Changing it needs the command line, where `--ambiguity-resolution conservative` requires a stronger lead before it will assign anything. In practice the case arises only when two species in your reference carry an identical 12S sequence, so a reference of distinct sequences, like this chapter's, never triggers it at all.

Every such reassignment is written to a `reassignments.tsv` file inside the result bundle, one row per move, and is kept out of the exact-match counts rather than folded silently into them. Open that file, by the Show in Finder route given in step 7, whenever a run reports reassignments and you need to see which reads moved where. If two closely related species in your reference share their 12S sequence and your question depends on separating them, the 12S amplicon alone cannot do it, and the abundance-based winner should not be reported as certain.

In the Unresolved view, read the Reads and Chimera columns together. The worked example produced 56 unresolved clusters, all of them marked not detected, holding 63 reads in total. Of those clusters 51 held a single read, four held two reads, and one held four. A tail shaped like that, many singletons and no chimeras, is ordinary sequencing noise from reads that overlapped the target region without containing it. A cluster holding tens or hundreds of reads with a not-detected chimera status is a wholly different case, and that is the one to send to BLAST.

## What good looks like

A healthy 12S run concentrates its matched reads on a small number of species and leaves an unresolved tail you can account for.

The exact-match percent in the summary is the first check, and it has no fixed threshold. This chapter deliberately gives no target number, because the rate is judged against what your reference covers rather than against any absolute standard. A reference holding every species in the sample can be expected to match most of the reads, while a reference holding five primates cannot be expected to match reads from anywhere else, and the same percent means opposite things in the two cases.

The worked example's 63.6 percent is an example of the second case rather than a poor sample. Its unmatched reads fall inside the 12S locus but do not contain any of the five 60-base reference targets whole with bases to spare at each end, which is the matching rule doing exactly what it is supposed to do on a reference that covers only part of what was sequenced. Judge your own rate the same way, by asking what your reference could have matched rather than by comparing it to a number in a manual.

The shape of the species table is the second check. You want a few rows carrying large read counts rather than dozens of rows carrying one or two each. Many rows with tiny counts, say twenty or more rows none of which holds more than a handful of reads, usually means the reference and the sample do not match each other well.

The unresolved tail is the third check. What is in it should be mostly singletons or chimera candidates. A large not-detected cluster appearing once or twice is normal and is exactly the cue to run BLAST on it. A table full of large not-detected clusters means your reference does not cover the sample, and the fix is to add the missing species and rerun rather than to reinterpret the result you have.

A small unresolved tail is expected and is not a failure. Real samples carry PCR artifacts, off-target amplification where the primers copied some region other than the one they were designed for, and species nobody has catalogued. The workflow shows that tail deliberately so you can judge it, rather than forcing every read into a call it cannot support.

Click the information button at the right of the action bar to open the Provenance popover, a small panel that appears over the window. [Provenance](../../GLOSSARY.md#provenance) is the record LGE keeps of where a result came from and how it was made. The popover reports the analysis name, the sample count, the exact-read count, the unmatched percent, the creation time, and the path to the provenance record on disk. That record carries the exact command, the reference, and the settings the run used, so a result can be reproduced or defended later.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it. It is here for readers who want to script a run or repeat one on a server. Five subcommands cover the whole workflow, and they run headless, meaning with no window at all, by typing into the Terminal application.

Two things in this chapter have no window equivalent and do require the command line. One is writing the unresolved clusters out as FASTA. The other is choosing the conservative ambiguity policy. Everything else here repeats what the window already does. If you have never opened a terminal, the [Command-Line Reference](../appendices/cli-reference.md) explains how to start one and how to run `lungfish-cli` from it.

Building a reference takes two of them. `12s-reference-metadata` joins a deduplicated FASTA to a MIDORI-style metadata table and writes the target metadata TSV. `12s-reference-bundle` packages the same pair into a reusable `.lungfish12sref` bundle, which is what the dialog's **Create 12S Reference...** button does.

```bash
# Package a deduplicated FASTA and its metadata as a reusable reference bundle
lungfish-cli fastq 12s-reference-bundle \
  --dedup-fasta primate-12s-dedup.fasta \
  --midori-metadata primate-12s-midori.tsv \
  --output primate-12s.lungfish12sref \
  --name "Primate 12S"
```

The metadata TSV must carry the columns `seq_id`, `common_name`, `latin_name`, `group`, `taxid`, `name_source`, and `taxonomy`. This is the full list promised in step 1, and it is also the list the dialog's builder needs, so a file built for one route works for the other. In Preview 2026.9.13 the help text for both `12s-reference-metadata` and `12s-reference-bundle` names only five of the seven, leaving out `common_name` and `name_source`, so build the file from this list rather than from the help output or the command will stop with a missing-column error. The fixture's `primate-12s-midori.tsv` already carries all seven.

Matching is one command. The merged reads are listed after the command with no flag in front of them, and a reference, an output directory, and an output name are required.

```bash
# Match merged 12S reads against the reference bundle
lungfish-cli fastq 12s-match HG002-12S-oriented.fastq \
  --reference primate-12s.lungfish12sref \
  --output-dir results \
  --output-name HG002-12S-oriented
```

`--reference` accepts either a plain deduplicated FASTA or a `.lungfish12sref` bundle, and passing the bundle picks up its target metadata automatically. `--reference-metadata` supplies a target metadata TSV that overrides the one inside the bundle when both are present. `--ambiguity-resolution` chooses how a read matching several species is assigned, and defaults to `strict`, which gives the read to whichever species holds any lead elsewhere in the sample. Passing `conservative` instead requires the winner to hold at least twice the runner-up and at least ten reads, and leaves the read unresolved when neither condition is met. Prefer `conservative` when your reference holds species that share 12S sequence and the difference between them matters to your conclusion, since it declines the call instead of settling it on a thin lead. `--force` replaces an output bundle that already exists at that path. The dialog's own controls all reach the command line as `--matching-mode`, `--min-soft-clip`, `--max-indels`, `--chimera-review`, `--sample-metadata`, `--output-dir`, and `--output-name`.

The run writes a `.lungfish12s` bundle holding `targets.tsv`, `samples.tsv`, `sample-target-counts.tsv`, `unresolved-sequences.tsv`, `read-fate.json`, a copy of the reference, and `unresolved-sequences.fasta`, alongside a provenance record for each. `read-fate.json` is the quickest way to check a run from a script, since it holds the total, exact-match, unresolved, ambiguous, and chimera-candidate read counts as five plain numbers.

Exporting the species rows is `12s-export`, which takes the same filters the viewport offers.

```bash
# Export mammal rows with at least 20 exact reads
lungfish-cli fastq 12s-export --bundle results/HG002-12S-oriented.lungfish12s \
  --export-format tsv --output mammals.tsv \
  --min-exact-reads 20 --taxon-group Mammal
```

`--export-format` takes `csv`, `tsv`, or `xlsx`, and the `xlsx` form adds the unresolved rows as a second sheet. `--filter` matches case-insensitively against species, common name, taxon, or alternate-match text. `--exclude-taxon-group` removes a group instead of keeping it, `--exclude-human` drops Homo sapiens rows, and `--require-alternate-matches` keeps only the rows carrying an alternate-match note. `--min-unresolved-reads` and `--chimera-status` shape the unresolved sheet of an Excel export.

Exporting the unresolved sequences themselves is `12s-export-unresolved`, and this is the only route to a FASTA of those clusters.

```bash
# Export unresolved clusters above a read threshold, with a metadata sidecar
lungfish-cli fastq 12s-export-unresolved \
  --bundle results/HG002-12S-oriented.lungfish12s \
  --min-reads 5 --output unresolved.fasta \
  --metadata-output unresolved-metadata.tsv
```

`--min-reads` defaults to 5 on purpose, so low-count clusters are skipped. On a run whose unresolved clusters are nearly all singletons, the worked example included, the default writes an empty FASTA, which is the command telling you there is nothing there worth chasing rather than an error. Lower it to 1 to see every cluster. This is a separate filter from the Inspector's Minimum Unresolved Reads, which defaults to 0 and shapes only the table and the Excel export. `--include-chimera-candidates` adds the sequences flagged candidate or confirmed, which the export leaves out by default. `--sequence-id` can be repeated to export only the clusters you name, and `--metadata-output` writes a companion TSV describing what was exported.

One neighbouring command matters enough to name here. `lungfish-cli fastq orient` turns reads to match a reference before you match them, which is the command-line form of the Orient Reads operation described in Before you start, and it is how this chapter's `HG002-12S-oriented.fastq` was made. In Preview 2026.9.13 its `--compress` option writes plain text rather than gzip even when the output name ends in `.gz`, so name the output plainly, as below, and compress it yourself if you need it compressed.

```bash
# Orient reads against the reference before matching
lungfish-cli fastq orient HG002-12S-amplicon.fastq.gz \
  --reference primate-12s-dedup.fasta \
  --output HG002-12S-oriented.fastq
```

## Next

Return to [What Is Read Classification](01-what-is-classification.md) for how 12S matching sits beside the taxonomic classifiers, or see [BLAST Verification](06-blast-verification.md) for more on confirming an unresolved cluster against NCBI.
