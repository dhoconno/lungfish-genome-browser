# Editor pass, 06-human-germline-variants/02-joint-genotyping

Date: 2026-09-07. Editor: brand copy editor.

Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports **no issues found**.
No em dashes, no semicolons outside the quoted VCF row, no in-sentence
colons. Front-matter flags untouched, `brand_reviewed` and `lead_approved`
both still `false` for the gate.

## Fidelity false rows applied, 4 of 4

- **Row 4, GATK tool count.** Procedure lead now reads "reaches two GATK
  tools, GATK HaplotypeCaller and GATK + WhatsHap Phased". The true second
  half of the sentence is kept. Aligns with chapter 01 line 98.
- **Row 5 and row 7, the Settings lead-in.** "Four of them are required"
  becomes three, named as **Reference**, **Output**, **Intermediate**, with
  a following sentence saying a fourth, **GVCF**, ought to be required and
  is not. The three shared flags are now named rather than counted, per
  readers row 21. "The other seven subcommands" becomes "Six of the other
  nine", and the sentence goes on to say `haplotype-caller` is the previous
  chapter's and that `markdup` and `validate-sam` are not covered anywhere
  in this manual. No coverage is promised that does not exist.
- **Row 23, the GVCF entry.** "At least one is required" is gone. The entry
  now says there is no default and that LGE does not enforce passing any.
- **Row 40, the counts.** 843 and 184 become **844 and 182**, per the
  project manager's ruling and the Part V first-ALT convention at
  `05-variants/02-reading-the-variant-browser.md:98`. Added the ruled
  sentence that bcftools' own type headings count position 29224 under
  both substitution and insertion, so a bcftools tally reads 843 and 184,
  and that 844 plus 182 lands on 1,026 exactly. I reconfirmed the recount
  against `gatk-joint/cohort.vcf.gz` by the first-ALT rule and got
  844 / 182 / 1026, and confirmed position 29224 is `A > G,AGG`. This also
  closes readers row 39.

## New defect disclosed

The `--gvcf` entry now carries a second paragraph, written for the reader
rather than as a developer note: a command with a reference, an
intermediate, and an output but no `--gvcf` exits `0` and prints a
`CombineGVCFs` line carrying no input file, and `--execute` would hand GATK
that empty command. The reader is told to count `--gvcf` flags against
samples before running. The "What good looks like" sample-column check
names the same missing flag as the likely cause, which also closes
readers row 98.

## Unverifiable row hedged

Row 11, the step-time split. Per the ruling, the 3.30 second wall time is
quoted and the 1.61 plus 1.62 split is **dropped**, since no surviving
provenance record supports it. This also closes readers row 43, which
caught the arithmetic gap.

## Rulings applied

- **Mean depth.** 39.4 is now named as the mean of the INFO `DP` field,
  which sums depth across samples at each site, and chapter 01's 38 is
  named as the mean per-sample FORMAT `DP` at the same sites, differing by
  definition rather than by error. No acceptable range invented. Depth is
  said to be judged against the alignment's own depth, 44.7 for this slice.
- **Obtaining the GVCF.** Before you start now says the GVCF comes from
  running HaplotypeCaller in GVCF mode as chapter 01 describes, shows the
  one `lungfish-cli gatk haplotype-caller ... --emit-ref-confidence GVCF
  --execute` command from author.md, says the `.fai` index ships in the
  fixture folder beside the FASTA and what it is for, and uses the fixed
  **Download ZIP** sentence from CONSISTENCY.md, which is the right one
  since several files are needed.
- **Reading a compressed VCF.** Step 3 now carries
  `bcftools view cohort.vcf.gz | head -40`. The two checks in "What good
  looks like" carry `bcftools query -l`, `bcftools view -H | wc -l`, and
  `bcftools query -f '%QUAL\n' | sort -g | head -1`. bcftools is stated to
  ship with the Required Setup pack, which I confirmed from
  `third-party-tools-lock.json:14` plus `PluginPack.swift:424-437` (the
  required-setup pack is built from every tool in the lock), and phrased to
  match the precedent at `05-variants/02-reading-the-variant-browser.md:63`.
  `lungfish-cli variants query` was **rejected** for this job: the CLI help
  shows it queries a bundle variant database, not a loose VCF. Before you
  start says once where the terminal is (Applications, Utilities) and that
  every command runs from the one folder holding the files, with the
  `cd` plus drag-the-folder recipe.
- **Scales.** The Phred scale is now explained at the `30.0` threshold in
  Settings, where the number first appears, with 10 / 20 / 30 as one in
  ten, hundred, thousand. Reading the results names `QUAL` and `GQ` as two
  Phred-scaled confidences measuring different things, relates the 30
  threshold and the 20 weakness mark to that scale, and says 99 is GATK's
  ceiling. `phred-score` added to `glossary_refs` and linked.
- **Terminal-only.** The first paragraph and Before you start keep the
  plain no-dialog statement. The command-line section keeps the Freyja
  pattern ("The whole procedure, from ... to ...") and gains the chapter 33
  reassurance that the section repeats what is above and unlocks nothing
  new. The chapter 33 fixed opener was not pasted verbatim, because its
  "If you do your work in the LGE window, everything above is complete
  without it" is false for a chapter with no window.

## Glosses added at first use

terminal, matched normal, HG002 and slice, the tilde, the backslash line
continuation (with `\` versus `/` and where it sits on the keyboard), exit
code 0 as success, genotype `0` and `1`, the GenomicsDB workspace files as
GATK bookkeeping the reader never opens, SHA-256 as the recipe used to
compute the checksum, tabix, "pins" replaced with "installs exactly version
4.6.2.0 of GATK and no other", "the reads simply ran out" replaced with "no
reads covered the position", the three-dots shortening marked as this
page's own formatting with a note that the reader's terminal prints full
paths, and the confidence figure in What it is named as the same quantity
later reported as `GQ`. One example `--extra-args` string that passes a
second copy of a flag is shown
(`--extra-args "--standard-min-confidence-threshold-for-calling 20.0"`),
with a sentence saying why a duplicate flag is not a mistake here. The
silent `--combine-strategy` fallback now says plainly that nothing later in
the run warns you and the finished VCF looks the same either way. The
24-hour step limit is stated with "no flag on this subcommand changes that
limit", which I sourced from `GATKPipelineExecutor.swift:50` and `:66`
(the timeout is an initialiser default with no CLI flag reaching it); the
chapter does not claim what happens to files on timeout, which no source
states.

## Consensus reader rows, 29 of 29 applied

Rows 7-19 (terminal, `0/1`, matched normal, HG002 and slice, tilde, 24-hour
limit, exit code 0, step 3 unperformable, Dry run ordering, mixed scales,
mean depth verdict, GenomicsDB files, header check unperformable), rows
20-33 (experimental meaning and the defect paragraph led by the working
instruction, the three shared flags named, Phred before 30, SHA-256, the
full download list, `--emit-ref-confidence GVCF` inside a command, pins,
reads ran out, backslash, tabix, the `--extra-args` example string, the
silent fallback with no later warning, INFO DP versus FORMAT DP, the three
dots), row 34 (confidence figure as GQ), and row 35 (`--execute` named
before the reader is told to leave it off). The Dry run entry now leads
with the override behaviour and says second that on its own it changes
nothing.

## Other reader rows applied, 43

36 (both combining tools named at step 1), 37 (what each tool does badly on
the wrong side of 50), 38 and 51 (forty-seven fold given, with a band), 40
(a one-line methods-section example), 41 (the GenomicsDB inference split
into short sentences with the comparison figure), 42 (the run creates the
intermediate), 44 (the exit-code caveat carries its own worked case rather
than only pointing ahead), 45 (flag glossed in Procedure at first use), 46
(a cohort of exactly 50 is its own sentence), 47 (the bqsr comparison
dropped), 48 (working directory glossed and marked as needing nothing), 49
(count corrected to five files, table row split), 50 (columns of the
example row labelled), 52 (BED file shown), 53 (wrap and elision marked),
54 (PL set aside explicitly), 55 and 102 and 107 (run from one folder, with
`cd` added to the summary block), 56 and 92 (what CreateSequenceDictionary
prints and leaves), 57 (fixture glossed as the practice dataset), 58 and 91
(what the open project is actually for), 59 (the eight `AS_` keys marked as
not needed to read a result), 60 (`1/1` with zero reference reads is the
expected pattern), 61 (Phred glossed), 62 and 76 (`.fai` and `.dict` both
glossed), 63 (why `lungfish-cli` is bare and GATK is a full path), 64 (the
preview is a record to read), 65 (30.0 named as a Phred score where it
appears), 67 (Picard glossed, `chr20` shown), 68 (allele-specific
annotation glossed at the `-G` mention), 69 (any non-zero code means
failure), 70 (tab-separated glossed), 71 (the store is one file or one
folder), 74 (ten to twenty minutes), 75 (defect paragraph leads with the
working instruction), 77 (the case where the two exit codes differ), 78
(provenance linked and glossed at its first appearance), 79 (the repetition
rule stated first), 80 and 111 (file path versus folder name, with the
`auto` case named), 81 (straight double quotes), 82 (quality divided by
depth), 83 (the sidecar named as the exception to the cleanup), 84 (the
1,026-row comparison figure supplied), 85 ("several of those files"), 86 ("a
missing row"), 87 ("compare position by position yourself"), 88 ("Use this
chapter when"), 89 (the tool choice changes, the typed command does not),
90 and 103 (a `lungfish-cli --version` check before step 1), 93 (both
possible first words named), 94 (LGE adds the two options automatically),
95 (`chr20` shown as an example), 96 ("hidden inside a single averaged
figure"), 97 (the two meanings of `.` split into two sentences), 99 ("mark"
for the verb), 104 (the sidecar is JSON, any text editor opens it), 105 (the
workspace can be deleted), 106 (the minimum-QUAL command given), 108
(experimental spelled out for the reader), 109 (row quality and genotype
quality distinguished by name), 110 ("automated series of steps" for
pipeline), 112 (required and shape split).

## Rows not applied, and why

- **Row 66**, marking which entries are required. Applied as naming them in
  the lead-in rather than adding a marker to each entry, because the fixed
  three-sentence Settings shape has no slot for a marker.
- **Row 100**, a rough file size for one human sample GVCF. Left out. No
  source in the campaign's evidence tree gives a whole-genome GVCF size,
  and I will not invent one. The fixture's own 851 KB over 500 kilobases is
  not a safe basis for extrapolating to a genome.
- **Row 101**, the menu path for Call Variants. Left out deliberately. The
  Call Variants surface is chapter 01's and the sibling chapter is being
  edited concurrently, so adding a menu path here risks contradicting it.
  Worth a gate check.
- **Row 73**, the GVCF must sit beside the reference. Covered by the
  stronger general rule now in Before you start, that every file goes in one
  folder and every command runs from it.

## For the gate

1. **Front-matter flags.** `brand_reviewed` and `lead_approved` left
   `false`, per instruction.
2. **`glossary_refs` decision, taken.** Dropped `bam` and `variant-caller`,
   which the body never linked and which look inherited from chapter 01.
   Kept `genotypegvcfs` and linked it at its first prose appearance in the
   exit-code paragraph. Added `phred-score` and `tabix`, both newly linked
   in the body, and both anchors resolve (`GLOSSARY.md:427` and `:609`).
   All 17 refs are now linked from the body.
3. **Registry gap, unresolved and not mine to fix.** `variants.gatk-plans`
   never names `--reference`, `--output`, or `--intervals` for this
   subcommand, so the chapter is the more complete document. The fidelity
   reviewer asked for a registry ticket and I have not opened one.
4. **Cross-chapter check.** The counts ruling, the 38 versus 39.4 depth
   ruling, and the two-GATK-tool count all touch chapter 01, which another
   editor holds. I did not open that file for editing and read it only to
   align. Worth confirming at the gate that both chapters landed the same
   ruling.
5. **Chapter 04.** The fidelity review notes chapter 04 documents the same
   failing `conda install --pack` command and needs the same treatment.
   Out of scope here.

## Facts I could not source

- What happens to partial output when a GATK step hits the 24-hour limit.
  The chapter states only that the limit exists and that no flag changes
  it. The executor's timeout path was not traced far enough to say whether
  the failure cleanup applies, so no claim is made.
- The size of a whole-genome GVCF, per row 100 above.
