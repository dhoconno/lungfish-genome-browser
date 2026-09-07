# Reader report: Importing Existing VCFs

Persona: undergraduate who used Geneious in one class, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "It might be a published study's supplementary" | "Truth set downloaded from a benchmarking consortium" is three unfamiliar words at once, and I did not know what a consortium hands out. | Say a truth set is a list of the differences experts already agreed are real. |
| What it is / "LGE answers that question by" | I could not tell what "the viewport" is. In Geneious I had a document list and a viewer, and I did not know which part of the LGE window counts. | Name the viewport once as the big panel that fills the window when you click a bundle. |
| What it is / "If no bundle is open, LGE" | "Quietly tries to fetch a matching reference sequence from NCBI" alarmed me and I did not know if that was good or bad here. | Say in that sentence whether the download is wanted or is the thing to avoid. |
| What it is / "There is also a command line route" | I have never opened a terminal, so I could not tell whether I was allowed to skip this paragraph. | A first-word marker that the command line part is optional. |
| Why you would do this / "The two earlier chapters in this part" | I have not read those chapters, so 1,056 and 862 arrived with no context and I had to read the paragraph twice. | One clause saying those are two different programs run on the same reads. |
| Why you would do this / "so it is a far better description" | I did not know why combining many technologies makes a call set better, and I could not judge that claim. | One sentence saying different technologies make different mistakes. |
| Before you start / "Download the file HG002.chr20.10.0-10.5Mb" | The file name has dots, dashes, and a .gz, and I was not sure the .gz needed unzipping first. | Say plainly not to decompress the .gz. |
| Before you start / "Follow Calling Variants first, which" | I could not tell how long that other chapter takes before I commit to it. | An estimate of the time that prerequisite chapter costs. |
| Before you start / "The optional command-line section at the end" | "Required Setup pack" is named as if I should know it, and I did not know if I already had it. | Point to where a pack is installed or checked. |
| Step 1 / "You can check by looking at the" | I did not know where in the viewport a sequence name appears, so I could not perform the check. | Say which corner or header shows the sequence name. |
| Step 1 / "comparing it against the first column" | I have never opened a VCF as text and did not know how to see its first column without a terminal. | Say the same name shows up after import in the Chrom column. |
| Step 2 / "The panel accepts more than one file" | I did not know if I should also select the .tbi index file in the panel. | Say to select only the .vcf.gz and leave the .tbi alone. |
| Step 3 / "where Auto names the import profile" | I did not know what an import profile is at this point, and the Settings section is later. | A three-word gloss on first mention. |
| Step 3 / "writes the rows into a SQLite database" | SQLite is an unexplained word, and I could not tell if I ever have to touch that file. | Gloss it as an internal table file you never open. |
| Step 3 / "If the import fails on a permissions check" | I did not know what to actually do if this happened to me. | Name the fix, such as choosing a project folder in your home directory. |
| Step 4 / "The table drawer along the bottom" | I did not know a drawer existed, and I would not have found the Variants tab if it had not opened by itself. | Say where the drawer sits and how to reopen it if it is closed. |
| Step 5 / "The bundle records a Default Ploidy value" | Ploidy, auto, and haploid all landed at once and I could not tell whether I needed to care. | Say whether this value affects anything I will look at. |
| Step 5 / "reads the VCF's contig lines and record" | Contig lines and NCBI accession are both unexplained, and the sentence is long enough that I read it twice. | Gloss contig as one named sequence in the file's header. |
| Settings / "The default is Auto, and the alternatives" | I could not judge what "plenty of memory" means on my laptop. | A number in gigabytes to compare against. |
| Settings / "--output-dir. Names the directory that" | This whole entry is command line only and I could not use it, but it sits under a heading that looks like app settings. | Mark the entry as command line only in its first words. |
| Reading the results / "Open the Variants tab with the scope" | I did not know what the scope control is or where it sits. | Say where the scope control appears in the drawer. |
| Reading the results / "so 961 differences in 500,001 bases" | I could not follow the arithmetic to "one every 520 bases" quickly and had to redo it. | Show the division once. |
| Reading the results / "since bcftools reports more than is" | I did not know why one program overcalls and the other undercalls. | One clause on why the two programs differ in strictness. |
| Reading the results / "Every one of the 1,056 bcftools rows" | A bare dot as a value confused me, and I first read it as missing data. | Say the dot means no filter was applied. |
| Reading the results / "Clicking the PASS preset chip therefore" | I did not know what a preset chip is or where to find it. | Say the chips are small buttons above the table. |
| Reading the results / "carries 571 rows called 0/1 and 374" | Sixteen more rows with calls like 2/1 were left unexplained and I did not know what a second alternate means. | One clause saying 2/1 means two different non-reference alleles. |
| Reading the results / "with LoFreq's allele frequency of 0.571" | I could not see why 0.571 is the same statement as 0/1. | Say a heterozygous site gives about half the reads. |
| What good looks like / "far fewer for two clonal isolates" | Clonal isolates is an unexplained term and the bacterial comparison did not help me judge my own file. | Gloss clonal isolates as two samples grown from one cell. |
| On the command line / "Both commands write a provenance sidecar" | Provenance sidecar is glossed only by a link, and I could not tell what the extra file is for. | Say it is a small record of how the file was made. |
| Next / "revisit Reading the Variants Table to work" | The link text here and the chapter name in the prereqs list do not read the same, so I was not sure it was the same chapter. | Use one name for that chapter in both places. |

One thing I learned: which reference bundle is open on screen at the moment I import is the thing that decides where the variants go, and nothing later lets me change it.

One thing I still could not do: perform the step 1 check that the sequence name in the viewport matches the VCF, because I do not know where the name appears on screen or how to look inside the VCF without a terminal.

The sentence I liked most: "A caller missing a class of variant it was never looking for is a configuration fact, not a failure."
