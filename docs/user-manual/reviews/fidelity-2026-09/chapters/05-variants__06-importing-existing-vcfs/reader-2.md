# Reader report: Importing Existing VCFs

Persona: senior undergraduate, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is: "A VCF is a tab-separated text file..." | I do not know what "tab-separated" means for a file I cannot open. I double-clicked a `.vcf.gz` and got nothing readable. | Say a VCF is a plain text table you normally never open by hand. |
| What it is: "It might be a published study's supplementary..." | "Truth set downloaded from a benchmarking consortium" was four unfamiliar words in a row. I read it twice. | Gloss "truth set" the first time it appears. |
| What it is: "LGE answers that question by looking..." | "There is no inference readout" stopped me cold. I do not know what an inference readout would look like, so I cannot tell what is missing. | Say plainly that the app never tells you which reference it thinks the file belongs to. |
| What it is: "then quietly tries to fetch a matching reference sequence from NCBI" | I do not know what NCBI is, and "quietly" made me nervous that something is happening I cannot see or stop. | Gloss NCBI at first use and say whether the download can be cancelled. |
| What it is: "`lungfish-cli import vcf` validates the file" | A command appears in the third paragraph of the first section. I have never opened a terminal and did not know if I needed this to continue. | Say up front that the command line route is optional and covered at the end. |
| Why you would do this: "The HG002 chromosome 20 slice carries..." | I could not tell whether HG002 is a person, a cell line, a file, or a folder. It is used as several of these later. | One sentence saying HG002 is a well-studied human cell line used as a standard. |
| Why you would do this: "produced 1,056 and 862 rows" | I do not know whether a gap of about 200 rows between two callers is alarming or ordinary. | Say whether that spread is expected before using it as evidence. |
| Why you would do this: "since bcftools reports more than is really there" | This is stated as a fact about the tool with no reason given, and I could not judge it. | Add why bcftools over-reports here. |
| Before you start: "which is a fixture, the sample data set..." | The definition is buried mid-sentence between commas and I read the sentence twice before it parsed. | Define fixture in its own short sentence. |
| Before you start: "Download the file `HG002.chr20.10.0-10.5Mb...`" | The two file names are long and nearly identical. I was not sure whether the `.tbi` is a separate download or comes with the first. | State that these are two separate downloads. |
| Before you start: "Keep the two files together in one folder." | I did not know whether "together" means inside my project folder or any folder at all. | Say any folder works as long as both files share it. |
| Before you start: "which arrives in the Required Setup pack" | I do not know what the Required Setup pack is or whether I already have it. | Point to where Required Setup is installed or checked. |
| Procedure: "The procedure has five steps." | Step 5 is an alternative path but it is numbered like a sequential step. I started doing it after step 4 and got confused. | Label step 5 as an alternative rather than a next step. |
| Step 1: "wait for the viewport to fill with it" | I do not know what "filled" looks like or how long to wait before deciding something went wrong. | Say what appears when the bundle has finished loading. |
| Step 1: "comparing it against the first column of the VCF" | I cannot open the VCF to see its first column. The file is compressed and I have no terminal. | Say how to see that value from inside the app, or say to skip this check. |
| Step 2: "hinting `.vcf, .vcf.gz` underneath" | The word "hinting" describing screen text confused me. I looked for a hint icon. | Say the card shows those extensions as small grey text. |
| Step 2: "so a `.bcf` cannot be chosen here" | I do not know what a BCF is, and the next sentence tells me to convert one without saying how. | Gloss BCF and say where the conversion is described. |
| Step 3: "where `Auto` names the import profile from Settings" | I had not read the Settings section yet and did not know whether I was supposed to have changed something first. | Say the default is fine and needs no action. |
| Step 3: "writes the rows into a SQLite database" | I do not know what SQLite is, and it is not in the glossary list at the top of the chapter. | Say it is an internal file format that keeps the table fast. |
| Step 3: "Only one operation can hold a bundle at a time" | I could not tell how I would know a run is still going, or what the wait message looks like. | Name the message that appears. |
| Step 3: "If the import fails on a permissions check" | I would not know how to make a folder writable, and there is no instruction. | One sentence on what to do when the folder is not writable. |
| Step 4: "The table drawer along the bottom... opens by itself" | Mine might not open by itself if I skipped the earlier chapter. I did not know how to open it manually. | Say how to open the table drawer if it does not appear. |
| Step 5: "a `.lungfishref` bundle holding variant rows and no reference sequence" | I could not picture what that is good for, since the chapter already said coordinates are meaningless without a reference. | Say what you can and cannot do with a variant-only bundle. |
| Step 5: "the existing one is replaced, so type carefully" | This destroys something and there is no word on whether the old bundle can be recovered. | Say whether the replaced bundle is gone for good. |
| Step 5: "records a `Default Ploidy` value... set to `auto`" | I do not know what ploidy is, and it is not glossed here even though genotypes get explained later. | Gloss ploidy where it first appears. |
| Step 5: "which is a large download for a 500 kb example" | "Large" gave me no number, so I could not decide whether to risk it on my laptop. | Give an approximate download size. |
| Settings: "Import profile. Chooses how much memory..." | I do not know how much memory my laptop has or how to find out, so I cannot choose between Fast and Low Memory. | Say how to check available memory, or say to leave it on Auto. |
| Settings: "**--output-dir.** Names the directory..." | This is a command line flag sitting in the same list as an app setting, with nothing separating them. | Mark it clearly as command line only. |
| Reading the results: "with the scope control set to **Genome**" | I do not know where the scope control is or what its other values are. | Say where the scope control sits in the drawer. |
| Reading the results: "961 differences in 500,001 bases is about one every 520 bases" | I could not connect one every 520 bases to one base in a thousand. I read this three times and still think they disagree. | Show the comparison to the one-in-a-thousand expectation directly. |
| Reading the results: "Every one of the 1,056 bcftools rows reads a bare `.`" | I did not know a period here means "no verdict" rather than a missing value or an error. | Say a period means the caller made no judgement. |
| Reading the results: "Clicking the `PASS` preset chip" | I do not know what a preset chip is or where the chips are on screen. | Say where the preset chips appear in the Variants tab. |
| Reading the results: "reading a benchmark row's 50 against a bcftools row's 225" | The number 225 arrives with no earlier mention and I could not tell if it is typical or one example. | Say it is one example value. |
| Reading the results: "so 152 of the benchmark's rows were never in reach" | I could not tell where 152 came from until I added 77 and 75 myself. | Show the sum. |
| Reading the results: "sixteen more rows carrying multi-allelic calls such as `2/1`" | I do not know what multi-allelic means or how to read `2/1`. | Gloss multi-allelic and say what the 2 refers to. |
| Reading the results: "with LoFreq's allele frequency of 0.571" | I could not see why 0.571 agrees with a `0/1` genotype. The link between a fraction and a genotype is never made. | Say a heterozygous site should show roughly half the reads carrying the change. |
| What good looks like: "Sort by `Chrom` and read the value." | I did not know `Chrom` was a column name, because earlier the chapter called it the first column of the VCF. | Use one name for this column throughout. |
| What good looks like: "far fewer for two clonal isolates of the same bacterium" | "Clonal isolates" is a term I have heard but could not define well enough to use it as a benchmark. | Gloss clonal isolate or drop the example. |
| What good looks like: "a filter that empties the view has three possible explanations" | The three explanations are never listed, so I could not actually perform this check. | List the three. |
| On the command line: "`lungfish-cli import vcf` reads the header..." | The whole section assumes a terminal is already open with the command available. Nothing says how to get there. | One line saying where these commands are typed. |
| On the command line: "Types   : SNP: 809, DEL: 74, INS: 64, OTHER: 14" | These numbers contradict the earlier 809, 77, 75 and I thought I had done something wrong before the next paragraph explained it. | Warn before the output block that the counts will differ. |
| On the command line: "`bcftools view -H` counts in the same file" | A second tool appears with a flag and no explanation of what it does. | Say what that command counts. |
| On the command line: "--fasta GRCh38.chr20.10.0-10.5Mb.fasta" | This file was never in the download list, so I do not have it and cannot run the example. | Say where the FASTA comes from. |
| On the command line: "both cap the export at 5,000 records unless you raise `--limit`" | Since the cap is called silent, I could not tell how I would ever notice rows were missing. | Say the extra rows are simply absent from the output file. |

The one thing I learned is that a benchmark VCF is an answer key you drop into the same table as your own calls, and that the `Source` column is what keeps the three sets apart.

The one thing I still could not do is verify in step 1 that the VCF belongs to the bundle I have open, because that check needs me to read the first column of a compressed file I have no way to open.

The sentence I liked most is "A caller missing a class of variant it was never looking for is a configuration fact, not a failure."
