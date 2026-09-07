# Editor pass, 06-human-germline-variants/03-filtering-selecting-and-metrics

Date: 2026-09-07. Roster row 44. Registry id `variants.gatk-plans`.

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh
docs/user-manual/chapters/06-human-germline-variants/03-filtering-selecting-and-metrics.md`
prints **no issues found**. Green on the first pass after the rewrite and again
after the `glossary_refs` addition. No em dash, no semicolon outside code or
data, no in-sentence colon. Front-matter flags untouched, both still `false`.

## 1. The fidelity report

### The one false row, fixed

The `##FILTER` sentence now reads exactly as the fidelity report's corrected
wording. "The output also carries a `##FILTER` header line for each distinct
test name, nine in all, because the duplicated `QD2` is declared once. A tenth
line, `LowQual`, came from the caller rather than from this step." Verified
against the artifact directly: `gunzip -c cohort.filtered.vcf.gz | grep
'^##FILTER'` returns ten lines, nine test names plus `LowQual`.

### The two unverifiable claims, marked as inherited

- **Whole-genome timing.** Now reads "a figure inherited from GATK's own
  published guidance rather than measured here." The claim survives, labelled.
- **Plugin Manager route.** Left as an instruction rather than a measured
  claim, consistent with chapter 02, which carries the same route. It makes no
  timing or count assertion that could be wrong, so nothing to hedge. Recorded
  here as inherited from chapter 02 rather than driven in the GUI.

### The `--sample` note added

Step 3 now says: "This fixture holds one sample, so `--sample HG002` here
selects the only column there is and drops nothing. On a real multi-sample
cohort it drops every other sample from the output." Closes the reader's
"a flag that appears to do nothing".

## 2. Consensus rows (43 of 43 applied)

| Consensus row | What changed |
|---|---|
| Opening gives no next step for a terminal novice | CLI Reference pointer moved into the first paragraph of What it is, with what it covers and a 15-minute estimate taken from that appendix's own `estimated_reading_min` |
| GATK never expanded | Expanded at first use as "the Genome Analysis Toolkit, the standard software package for human variant work" |
| FILTER column described by position with no example | Two labelled VCF lines now shown before the seventh column is named, taken verbatim from the fixture's own file |
| Filter statistics never tied to where they live | The example row's `DP=62` and `QD=28.73` are named as INFO-field entries, and Why you would do this now says "INFO-field statistics" |
| "Slice" unexplained | Glossed at first use as "a 500 kb region cut out of chromosome 20 rather than the whole chromosome" |
| `.dict` required, command never given | `gatk CreateSequenceDictionary` block added to Before you start, copied from `04-reference-packs.md:99-101`, with that chapter linked as where it is explained |
| Downloaded FASTA never used in the Procedure | `leftalign` promoted to Procedure Step 4, which uses `--reference GRCh38.chr20.10.0-10.5Mb.fasta`. The download instruction now says "Step 3 below uses this file" (numbering later shifted, see note under Left for the gate) |
| "Stops" reads as a crash | Now "composes its GATK command, prints it, and exits without running anything or writing any file. That is a safe preview rather than a failure." |
| Four of six SNP tests never explained | New five-row table after the Step 1 preview gives each test, the INFO field it reads, its threshold, and one plain sentence. `ReadPosRankSum` follows in a sentence rather than a sixth row, to stay inside the CONSISTENCY table conventions and keep the row count readable |
| Origin of the sample name never explained | Step 3 says a sample name is a column heading from the tenth column on, and gives `bcftools query -l` to list them |
| Procedure covers three of five operations | Now seven steps covering all five. `leftalign` is Step 4, `variants-to-table` Step 5 |
| Step 4 benchmark rebuild command never given | `bcftools reheader --fai` plus `bcftools index --tbi -f` added to Before you start, copied from `04-reference-packs.md:128-131`. The metrics step now passes `known-sites.vcf.gz`, the rebuilt file, and says so |
| AF and DP named without a worked meaning | Fields entry now glosses both and reads the example row's `AF=1.00` as "both copies carry it" |
| "Load-bearing" metaphor | Replaced. Max leading bases now says an out-of-window indel "is left exactly as the caller wrote it and nothing in the output says so, which makes it look normalized when it is not" |
| Caller's quality floor never given a number | Now quoted as HaplotypeCaller's emission threshold of 30 on the Phred scale, linked to `01-haplotype-caller.md`, which states it at line 155. Not invented here |
| 836 plus 175 does not reach 1,013 | Now stated: "those two add to 1,011 rather than 1,013 because the two `MIXED` rows are the remaining `PASS` rows, and they are in neither file" |
| Three different SNP counts unreconciled | A paragraph in The metrics files names all three and what each counts (842 every SNP row, 836 PASS SNP rows, 835 Picard's substitution count among PASS rows) |
| `HET_HOMVAR_RATIO` never explained | One sentence added, plus a table-row gloss |
| Header rewrite described with no command | Command given, see the Step 4 row above |
| BED file never shown | Its single tab-separated line is now shown in On the command line, read from the artifact, and the Intervals entry explains the format including the zero-based start |
| Five subcommand names not identified as subcommands | What it is now says "all five are subcommand names you type after `lungfish-cli gatk`" |
| "Evidence a careful reader would reject" reads backwards | Now "the rows whose supporting evidence is too weak to believe" |
| "A variant caller is deliberately generous" | Variant caller glossed in place, and the sentence rewritten to "reports every position with any supporting evidence at all" |
| "A trained approach" unnamed | Named as VQSR, with what it does. No cohort-size claim, per the ruling |
| 13 of 1,026 has no percentage at first mention | "or 1.3 percent" added at first mention in Why you would do this |
| gatk-core defect warning unclear | Now its own paragraph, saying the Plugin Manager is the only route that works, that the CLI installer bug is known, and that "it does not affect any of the runs below" |
| Exit code 0 never explained | "Exit code 0 means the run succeeded, and any other number means it did not," at its first appearance in Step 2 |
| "Path stem" unglossed | Now "the start of a file name that the tool completes for you" |
| Flag gloss arrives after flags are in use | Moved to the Procedure lead-in, ahead of Step 1 |
| MIXED has no example where defined | The Type entry now carries position 29,224's record, read from the artifact: reference `A`, alternatives `G` and `AGG` |
| Unrecognised-preset fallback sits too late | Moved to sit directly under Step 1, where `--preset` is first typed. Kept as a line in What good looks like |
| 12 plus 2 equals 14 arithmetic left to the reader | The overlap is now stated before the table, the two table rows are annotated "one of them also ...", and the arithmetic is written out as 12 plus 2 minus 1 |
| `DBSNP_TITV` range not in the row | "Expect 2 to 3" now in the table row, and `NOVEL_TITV` gained "Usually lower" |
| "Artefact of the chemistry" names no step | Now "an artefact of library preparation or of the sequencing chemistry" |
| 19-row split arithmetic left to the reader | "the split added exactly 19 rows and 1,026 plus 19 is 1,045" |
| 500,000 against 500,001 off-by-one | Explained as an inclusive cut of both end positions, with `cat ...fasta.fai` given as the way to read the true length. Verified: the fixture's `.fai` second column is `500001` |
| "Conda environment" never glossed | Glossed in The provenance record as "a self-contained folder holding one program and everything it needs" |
| "Upstream" unglossed | Removed rather than glossed. Both uses now say "earlier in the analysis" and "in the mapping or the calling that ran earlier" |
| Two `markdup` subcommands distinguished only in passing | The closing paragraph became its own H3 section, and the two `markdup` commands get a dedicated paragraph saying to check which one a command names |
| Trailing backslash assumed knowledge | The Procedure lead-in now says to paste the block as one piece and that the line breaks need not be typed |
| Three dots not identified as the manual's shorthand | Now "this manual's own shorthand for your folder rather than something that will appear in your output" |
| `mkdir -p` unexplained | Now "a terminal command rather than an LGE one, typed in the same terminal" |
| Provenance collision explained too late for Step 3 | Disclosed at the end of Step 2, naming Steps 2 and 3 as the pair that collides, and restated in The provenance record |

## 3. Rulings from the project manager

- **Variant counts.** GATK's 842 SNP, 182 INDEL, 2 MIXED stay, presented as
  GATK's own typing. A new paragraph says the manual counts by first ALT allele
  under which the file is 844 and 182, that GATK files the two both-kinds rows
  as MIXED, and that "GATK's 842 plus 2 and the manual's 844 describe the same
  file counted two ways, and both totals reach 1,026." 836 against 835 is
  reconciled with author.md's reason, that the metrics count only `PASS` rows
  and use Picard's typing. PASS arithmetic shown once (836 plus 175 is 1,011,
  plus the 2 MIXED is 1,013).
- **Prerequisites performable.** Both commands added, copied from
  `04-reference-packs.md`, with that chapter linked. The FASTA is now used in
  Procedure Step 4.
- **Five operations.** All five are numbered Procedure steps. No promise trimmed.
- **Filter statistics.** All six SNP tests and the four indel tests explained in
  one place under Step 1, each tied to its INFO field, in a table plus one
  sentence for `ReadPosRankSum`. A labelled VCF row appears in What it is so the
  FILTER column can be found.
- **Silent fallbacks.** Preset fallback moved under Step 1, dropped `--type`
  warning moved under Step 3, provenance-overwrite disclosed at the end of Step 2.
  The old Settings paragraph carrying both was removed to avoid saying it twice.
- **Terminal material.** Terminal location and the run-from-the-file-folder rule
  stated once in Before you start. Backslash, three dots, `mkdir -p`, exit code 0,
  path stem, conda environment, and GATK expansion all covered. "Upstream" cut
  rather than glossed.
- **Numbers.** Every item applied. See the consensus table above.
- **Glosses.** Slice, HG002 (Genome in a Bottle), the BED file (shown), MIXED
  (with its record), the two markdup subcommands, and VQSR by name with no size
  claim.
- **App defects.** All six disclosed in one sentence each, at the point the
  reader meets them. gatk-core install in Before you start, preset fallback at
  Step 1, `--type` at Step 3, provenance overwrite at Step 2, `--preset custom`
  in Settings, and the metrics exit-3 message in When the metrics step fails.

## 4. Other reader rows applied

Applied beyond the consensus set: the "raw answer" metaphor, "bare full stop",
"leave the row count alone", "artefact", "downstream", "a handful of positions",
the VCF-as-table against flattening tension, indel glossed at first use, the
`.tbi` and `.fai` index gloss, the cohort VCF identified as joint genotyping's
output, provenance glossed at Step 2, JSON glossed, SHA-256 as the recipe,
the What good looks like TITV range brought into line with the metrics section
(both now say 2 to 3), Settings duplicated-opener sentence deleted, the six
recorded runs enumerated, `custom` called unfinished in its first sentence, a
typical indel length given, Dry run led with the override, "which is the more
careful way to work", "holding several samples" in full, "when your VCF header
does not list the contigs", the Extra args practical note, the Preset filter-then-
split order question answered, the metrics-failure `(195, 1)` numbers labelled,
the contig rename explained, `PCT_DBSNP` shown as both fraction and percentage,
the detail file's two extra fields named, purine and pyrimidine used, the
"surprises people" sentence reordered to state the cause first, the semicolon
clause made its own sentence, the eight tests that marked nothing stated, the
exported table offered as the way to look up a position, Step 7 saying the files
are plain text, the closing block labelled a recap, the BAM subcommands moved
into their own section, and BQSR glossed in the Next section.

Two reader rows I declined, with reasons.

- **Group Settings entries under one subheading per subcommand** (reader 4).
  Declined. `CONSISTENCY.md` fixes the Settings section as a flat run of
  `**Label.**` paragraphs, and the `settings-coverage` lint rule reads that
  shape. A structural change here belongs to the Documentation Lead, not to this
  pass.
- **Add a Settings entry for `--reference`** (readers 2 and 3). Applied rather
  than declined, since `leftalign` genuinely takes it and the registry's
  `leftalign` row implies it. Flagged below because it adds a 21st Settings
  paragraph the fidelity report counted as 20.

## 5. Facts I could not source, and what I did

- **Why the project must be open.** The readers asked what it is for. I first
  wrote that the CLI expects a project context, then checked
  `Sources/LungfishCLI/Commands/GATKCommand.swift` and found no project option
  at all. Rewrote to the only use I can defend, that the project is where the
  GATK Core pack is installed from and that none of the five commands reads or
  writes it. If that is wrong, it is a claim the gate should check.
- **Cohort size that counts as "large" for VQSR.** The reader row asked for a
  rough number. The ruling says name VQSR with no size claim, and I found no
  sourced figure, so no number appears.
- **Whole-genome runtime.** Unmeasured, now labelled as inherited from GATK's
  guidance rather than from a run.
- **`HET_HOMVAR_RATIO` expected range.** I wrote "near 1.5 to 2 for a human
  sample" as general background, the same standing this chapter already gives
  the TITV range. It is not measured from the fixture and the fixture's 1.459
  is the only number I verified. Worth a reviewer's eye.

## 6. Left for the gate

1. **Front-matter flags.** `brand_reviewed` and `lead_approved` both left
   `false`, as instructed.
2. **`estimated_reading_min`** raised from 7 to 12. The body grew by roughly a
   third. A rough estimate rather than a measurement.
3. **Settings paragraph count is now 21**, not the 20 the fidelity report
   counted, because of the new `--reference` entry. The registry's
   `variants.gatk-plans` entry should gain a `--reference` row for `leftalign`
   so the count reconciles.
4. **`glossary_refs` gained `bam`**, because the new BAM-subcommands section
   links it. The anchor resolves (`GLOSSARY.md:47`).
5. **The registry is still behind the chapter**, as the fidelity report's note 5
   says. `variants.gatk-plans` omits `--preset custom`, records neither lenient
   parse, and now also omits `--reference`. Not mine to edit.
6. **Siblings 01 and 02** are being edited by others. This chapter now states
   the first-ALT convention as 844 and 182 per the ruling. If the siblings ship
   with 843 and 184, the reconciling paragraph here will contradict them.
7. **Step numbering against the download instruction.** Before you start says
   "Step 3 below uses this file" of the FASTA, and after `leftalign` was
   inserted the FASTA is used at Step 4. Corrected in the body, noted here in
   case a later edit renumbers again.

## Status

brand_reviewed: false (the gate flips it)
