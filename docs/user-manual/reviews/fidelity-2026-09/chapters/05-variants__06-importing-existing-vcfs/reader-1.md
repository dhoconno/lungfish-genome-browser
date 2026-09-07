# Reader report, undergraduate (sophomore, genetics course, no lab time)

Chapter: `docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md`

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Most people arrive at Lungfish" | "tab-separated text file" is used before I know whether I ever open the VCF myself or only ever hand it to the app. | Say once that I never edit the VCF by hand. |
| What it is, "It might be a published study's" | "a truth set downloaded from" means nothing to me. The idea is only defined a whole section later. | Gloss "truth set" here, at first use. |
| What it is, "A VCF's coordinates are meaningless" | Position 250,527 appears out of nowhere. I read it twice looking for the table it came from. | Say it is the position reused later in the chapter. |
| What it is, "If no bundle is open, LGE asks" | "fetch a matching reference sequence from NCBI" - I do not know what NCBI is or whether this costs me anything. | One clause saying NCBI is a free public sequence database. |
| What it is, "There is also a command line route" | I could not tell whether I was allowed to skip this. I have never opened a terminal. | Say up front that the command line part is optional. |
| Why you would do this, "The HG002 chromosome 20 slice" | "the HG002 cell line" - I do not know why one person's DNA becomes a standard. | One sentence saying HG002 is DNA from one well studied person used as a shared standard. |
| Why you would do this, "The two earlier chapters in this part" | "1,056 and 862 rows" arrive before I know whether more rows is better or worse. | Say here that a bigger count is not automatically better. |
| Why you would do this, "A position only one caller reports" | I followed the logic but could not tell what I actually do on screen to see agreement. Do I eyeball it? | Point forward to the Source column here. |
| Before you start, "choose File > New Project (Cmd-N)" | Three ways to do one thing in one sentence, and I could not tell which one to use. | Give one route. |
| Before you start, "Download the file HG002.chr20" | The two filenames differ only by `.tbi` at the end and I nearly downloaded the same one twice. | Say plainly that these are two separate downloads. |
| Before you start, "The `.tbi` is a tabix index" | I could not tell whether I ever open, rename, or move this file. | Say I never open or rename it. |
| Before you start, "Follow Calling Variants first" | No idea how long that chapter takes, so I could not choose between doing it and taking the step 5 path. | A time estimate for the prerequisite. |
| Before you start, "The optional command-line section" | "the Required Setup pack" is named as if I have already met it. I have not. | A pointer to where packs are explained. |
| Procedure lead-in, "The first three do the import" | "which is the path you want" made me unsure whether step 5 is a mistake or a real alternative. | Say step 5 is a valid alternative, not an error. |
| Step 1, "wait for the viewport to fill with it" | I do not know what "filled" looks like or how long to wait before something has gone wrong. | Say what appears when it is ready. |
| Step 1, "comparing it against the first column of the VCF" | I cannot see the first column. I never opened the file and the chapter never says how. This is the step I could not perform. | Say how to see the VCF's sequence name without a terminal. |
| Step 2, "hinting `.vcf, .vcf.gz` underneath" | "hinting" as a verb made me read the sentence twice. | A plainer verb. |
| Step 2, "so a `.bcf` cannot be chosen here" | BCF is named as a format I might have, but I do not know what it is or how I would convert one. | One clause saying BCF is a compact binary VCF, and where to convert it. |
| Step 3, "where `Auto` names the import profile" | "profile" is used before Settings defines it, and I did not know whether I needed to change it first. | Say the default is fine. |
| Step 3, "writes the rows into a SQLite database" | I have never seen the word SQLite and could not tell whether this is a file I now own. | Gloss it or drop the name. |
| Step 3, "records a provenance entry" | I do not know what provenance means. The glossary link is the only clue. | Gloss it inline at first use. |
| Step 3, "you will be told to wait" | I could not tell whether the import fails outright or queues itself. | Say whether I must start it again. |
| Step 4, "Every track in the bundle loads into the one table at once" | I could not tell how many tracks I should now see, so I had no way to check I got it right. | State the expected number, three. |
| Step 5, "records a `Default Ploidy` value" | Ploidy in my genetics class meant chromosome copy number, which does not obviously apply to a file setting. | Gloss ploidy as it is used here. |
| Step 5, "which is a large download for a 500 kb example" | "large" gives me no number. I cannot tell if that is 100 MB or 3 GB. | Give an approximate size. |
| Settings, "Change it to Fast when you import large VCFs" | I cannot judge "plenty of memory" or "multi-gigabyte" against my own laptop. | A rough threshold in GB. |
| Settings, "**--output-dir.** Names the directory" | I skipped this because I never use the command line, then worried it also changed the app. | Mark it command line only in the first clause. |
| Reading the results, "with the scope control set to" | I do not know where the scope control is or what its other values are. | Say where it sits. |
| Reading the results, "so 961 differences in 500,001" | I followed the arithmetic but not why one in a thousand is the human expectation. | One clause on where that figure comes from. |
| Reading the results, "since bcftools reports more than" | Stated as bare fact, and it is the sentence that decides how I read the whole table. | One clause on why each caller behaves that way. |
| Reading the results, "Every one of the 1,056 bcftools" | I did not know a bare `.` meant "no value" rather than a filter actually named dot. | Say the dot means missing. |
| Reading the results, "Clicking the `PASS` preset chip" | "preset chip" appears here for the first time. I did not know chips existed in this table. | Say where the chips are. |
| Reading the results, "reading a benchmark row's 50" | A bcftools quality of 225 has no scale attached, so I cannot tell whether it is high. | Say what the quality scale runs over. |
| Reading the results, "with sixteen more rows carrying" | I could not read `2/1`. My class only ever covered two alleles. | Gloss what allele 2 means. |
| Reading the results, "and with LoFreq's allele frequency" | I could not connect 0.571 to a `0/1` genotype until the sentence after had already moved on. | Put the connection before the number. |
| What good looks like, "First, check that the sequence name" | I could not tell whether `Chrom` is the same thing as the "sequence name" from step 1. | Use one term for it. |
| What good looks like, "far fewer for two clonal" | "clonal isolates" is vocabulary I do not have. | Simpler phrasing. |
| What good looks like, "a filter that empties the view" | The three possible explanations are never listed, so I could not run this check. | List the three. |
| On the command line, "Types   : SNP: 809, DEL: 74" | SNP, DEL, and INS are never expanded, and the table above uses long words for the same things. | Map the abbreviations to the table's words. |
| On the command line, "taking the same per-sample filter" | "filter grammar" and "Search Builder" both arrive unexplained. | Cross-reference the chapter covering the Search Builder. |
| On the command line, "both cap the export at 5,000" | I could not tell whether the 5,000 cap also applies to the window. | Say it is command line only. |

The one thing I learned: which reference bundle is open on screen at the moment I import is the whole decision, because LGE never reads the file to work it out.

The one thing I still could not do: perform the step 1 check that the VCF's sequence name matches the bundle, since the chapter tells me to read the file's first column but never says how to see it without a terminal.

The sentence I liked most: "A caller missing a class of variant it was never looking for is a configuration fact, not a failure."
