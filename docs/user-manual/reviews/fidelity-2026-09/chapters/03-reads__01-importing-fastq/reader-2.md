# Reader report: Importing Sequencing Reads

Reader 2. A senior who has pipetted for two years and never analyzed data. Never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Importing is the step that brings" | The word "project" is linked but I do not know if a project is one experiment, one sample, or one whole study. I have a folder of 96 samples and no idea whether that is one project or 96. | One sentence saying how much work belongs in a single project. |
| What it is, "What import produces is a bundle." | Bundle is defined as a folder LGE treats as one object, but I could not tell whether the bundle sits inside the project folder or somewhere else on my disk. | Say where the bundle folder physically lives. |
| What it is, "Inside it sit the read data," | A folder the application shows as one item, but that Finder would show as a folder, confused me. If I double-click it in Finder do I break it? | One sentence saying not to open or move the bundle in Finder. |
| What it is, "It computes a checksum, a short" | I understand the fingerprint idea but not what I ever do with it. Does something warn me if the checksum stops matching, or do I have to check by hand? | Say who checks the checksum and when. |
| What it is, "It usually rewrites the reads into" | The word usually made me anxious. I could not tell from the text when it does not rewrite them. | Name the case where it leaves the reads alone. |
| What it is, "It also covers an unmapped Oxford" | I have never heard of BAM. The gloss says raw reads rather than aligned reads, but I do not know why a raw-read file would be a BAM at all when everything else here is FASTQ. | One clause saying Nanopore instruments write BAM directly. |
| Why you would do this, "Mapping, quality control, trimming, classification," | Five operation names in one sentence and I recognise two. I had to read it twice to see it was a list of things I would do later, not things I must do now. | Name them as later chapters. |
| Why you would do this, "This chapter works through the HG002" | I do not know what slice means here. Later the text says 500 kb region so I worked it out, but not on first read. | Define slice at first use, not later. |
| Why you would do this, "The two files hold 45,574 read pairs" | 45,574 pairs and 500 kb. I have no sense of whether that is a lot of data or a tiny amount, so I could not judge whether ten seconds is fast. | Compare it to a normal run size. |
| Before you start, "Download the files HG002.chr20.10.0-10.5Mb_R1.fastq.gz" | The GitHub link is a folder listing. I have never downloaded a file from GitHub and did not know which button gets the actual file rather than a page of text. | One sentence on how to download from that page. |
| Before you start, "Nothing here needs a plugin pack" | Both plugin pack and Docker Desktop are explained, but I could not tell whether I should install them now anyway for later chapters. | Say whether to defer them. |
| How LGE decides, "The match is case-sensitive, so use" | I could not tell whether case sensitivity applies to the whole filename or only the suffix. If my sample is sample01 in one file and Sample01 in the other, do they pair? | Say whether the rest of the name is also case-sensitive. |
| How LGE decides, "A file whose mate is missing" | The phrase no warning appears alarmed me and I could not act on it. The next sentence says read the counts, but I do not know where the counts sit on the sheet. | Point to where on the sheet the counts appear. |
| How LGE decides, "Rename a file whose suffix is lowercase" | I did not know whether renaming a FASTQ file is safe. In my lab we were told never to rename raw data. | One clause saying the pairing name is not read from inside the file. |
| Procedure step 3, "The card accepts folders as well" | I could not tell whether selecting a folder pulls in subfolders too. The command-line section later mentions a recursive option, so I suspect not, but the app text does not say. | State whether the app walks subfolders. |
| Procedure step 4, "For these two files it reads R1:" | I could not picture where this summary sits on the sheet. Top, bottom, a side panel. The screenshot placeholder does not help me read the text. | Say where on the sheet the summary sits. |
| Procedure step 5, "There is no sample-name field, because" | I do not know what a stem is. I guessed it is the part before _R1, but the example still ends in a number and a dot. | Define stem, or say the part of the name before the mate suffix. |
| Procedure, "Watch the progress in the Operations Panel," | I could not tell whether I have to open this panel or whether the import runs fine without it. | Say the panel is optional. |
| Importing many samples, "The configuration sheet then applies its settings" | If one folder holds Illumina and Nanopore samples together, one setting for all of them sounds wrong, and the text does not say what happens. | Say what to do with a mixed folder. |
| Settings, "These are the controls on the" | Nine settings arrive at once with no signal about which ones a first-time user should touch. I froze on the sheet. | Say which settings can be left alone. |
| Settings, Platform, "It defaults to the platform detected" | I do not know what a read header is or how I would check what it says, so I cannot tell whether the detection was right. | Gloss read header. |
| Settings, Platform, "On the command line this is" | Seven choices in the app and four on the command line. I could not tell what happens to the missing three. | Say what the command line does for the other platforms. |
| Settings, Quality Binning, "Rounds each base quality score" | I do not know what a base quality score is yet. It is explained much later under Q20 and Q30, which I had not reached. | Gloss quality score here at first use. |
| Settings, Quality Binning, "Choose None when a downstream tool" | I cannot tell whether the variant calling I plan to do later counts as such a tool, so I did not know which way to set it. | Say whether LGE's own variant calling needs exact scores. |
| Settings, Optimize storage, "Turn it off on a machine short of memory" | Short of memory is not a number. My laptop has 16 GB and I could not decide. | Give a memory figure or a file-size threshold. |
| Settings, Compression Tool, "Pick Trim Galore only when you want" | This one setting silently changes my actual reads. That felt like a much bigger deal than the sentence's tone suggested, and I could not tell whether the original reads are recoverable. | Say whether trimming here is reversible. |
| Settings, Compression Tool, "It is resolved from the total input size" | Resolved reads like code. I read the sentence twice before deciding it means LGE picks. | A plain verb. |
| Settings, Apply processing recipe, "Runs a packaged multi-step workflow" | I do not know what a recipe contains or how I would find out before turning this on. | Say where to preview a recipe's steps. |
| Settings, recipe picker, "It appears only once the checkbox" | Both this setting and the one above map to the same command-line flag. I could not work out how the command line distinguishes them. | Say the one flag both enables and selects. |
| Settings, "A plain FASTQ import offers three bundled" | VSP2 Target Enrichment and Wastewater metagenomics mean nothing to me and are not glossed. | One clause each, or a pointer. |
| Reading the results, "Click the new bundle in the sidebar" | Viewport is used for the first time here without a gloss, and it is not in the glossary list at the top of the chapter. | Gloss viewport at first use. |
| Reading the results, "The top pane holds one summary bar" | Sparkline is defined two paragraphs later, after this sentence has already used sparkline strip. | Move the gloss to first use. |
| Reading the results, "Mean Length, Median Length, N50" | N50 is never explained. I half remember it from a lecture on genome assembly but not what it means for read lengths. | Gloss N50. |
| Reading the results, "Mean Q, 24.87" | A Mean Q of 24.87 sits between the Q20 and Q30 thresholds, and I could not tell whether that is good given the same paragraph calls Q20 and Q30 healthy. | Say what a good Mean Q is. |
| Reading the results, "and 248.6 against a 250-base run" | The text mentions the minimum of 35 bases but no card in the table reports a minimum. I looked for it and could not find it. | Say where the minimum is shown. |
| Reading the results, "GC gives the percentage of bases" | 39.4% GC is reported but nothing says what to expect for human. I could not judge it. | Give the expected human range. |
| Reading the results, "A Q30 figure below about 70%" | This is the only judgement threshold in the chapter, and it is Illumina only. I do not know what to expect for Nanopore, which the chapter also covers. | Give a Nanopore expectation too. |
| Reading the results, "it loads the first 1,000 records" | I could not tell whether there is any way to see more than 1,000, or whether that is a hard stop. | Say whether the limit can be raised. |
| Reading the results, "Importing does not compute a quality report" | This contradicts my read of the opening, which said import measures read length and quality. I had to re-read both to see that measuring is not the same as reporting. | Distinguish the measured cards from the report explicitly. |
| Editing sample metadata, "prepare a CSV with one row per sample" | This is the first place a task is offered only on the command line, and I have never opened a terminal. I could not do it. | Say whether the Inspector can do a batch. |
| Editing sample metadata, "Add --sync-bundles to also write" | I could not tell the difference between metadata that is imported and metadata that is also written into each bundle, or which one I want. | Say why you would want the per-bundle copy. |
| What good looks like, "A count that is twice what you expected" | I understood the check but not the fix. If I have already imported 20 wrong bundles, the chapter does not say how to undo it. | Say how to remove wrong bundles. |
| What good looks like, "An import skips a sample when" | The fix given is a command-line flag only. There is no in-app answer for a re-import, and I cannot use a terminal. | Give the in-app equivalent. |
| On the command line, "lungfish-cli import fastq" | Every block here assumes a terminal. I have never opened one, and the chapter never says where to find one or that this whole section is optional. | One sentence saying the section is optional. |
| On the command line, "relative paths resolve next to the CSV" | Relative paths resolve next to is jargon I had to read three times. | Plain phrasing. |
| What a bundle holds, "the two source files totalled 17,968,037 bytes" | Both figures are in bytes. I had to divide to see they were about 18 MB and 5.8 MB. | Use MB. |
| What a bundle holds, "A bundle can also be virtual." | I do not know what a manifest is, and the whole virtual-bundle idea arrives with no reason for me to care at this point. | Say why a beginner would meet one. |
| What a bundle holds, "To write one back out as" | Materialize is used as a verb with no gloss, and the only way given to do it is a terminal command. | Gloss materialize and say whether the app can do it. |

The one thing I learned is that a bundle is not a copy of my files, it is a measured and repackaged version that remembers where the reads came from and which two files were a pair.

The one thing I still could not do is fix a bad import. Every fix in the chapter, replacing a skipped sample, batch metadata, materializing a bundle, is a terminal command, and I have never opened a terminal.

The sentence I liked most is "The bundle records all three, so six months later the reads still know what they are."
