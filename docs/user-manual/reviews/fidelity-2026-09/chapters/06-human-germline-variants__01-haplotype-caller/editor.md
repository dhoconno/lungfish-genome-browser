# Editor pass, 06-human-germline-variants/01-haplotype-caller

Date: 2026-09-07
Editor: brand-copy-editor

Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues found.

Front-matter flags untouched. `brand_reviewed` and `lead_approved` both stay
`false` for the gate to flip.

## 1. The five false rows

**Claim 26, Step 2.** Replaced "the two numbers are recorded with the run and
then ignored" with the reviewer's wording. Step 2 now reads that the numbers
"are discarded when the run starts" and "reach neither GATK nor the provenance
record, so do not go looking for them there afterwards."

**Claim 42, Minimum Allele Frequency.** Rewritten to the reviewer's wording,
opening "Sets a frequency floor that the GATK entries never use" and stating
the value is "discarded when the run starts rather than passed along or
recorded." Kept the default and range in a following sentence with the reason
they are still shown, which also answers a consensus reader row asking why a
default exists for a value that does nothing.

**Claim 44, Minimum Depth.** Same treatment, with the depth gloss moved inline.

**Claim 58, phased `cli_only` count.** "Five settings" is now "Six settings".
Dropped the duplicated `--extra-gatk-args` paragraph, which is the shared Extra
arguments control's flag and is already covered in the shared paragraph. Added
`--execute` and `--dry-run` paragraphs in registry order. The Settings section
now carries twenty paragraphs.

## 2. The two unverifiable rows

**Row 9, the New Project boilerplate.** Left in place. It is the CONSISTENCY.md
fixed sentence and is verified in the committed chapters. Added only the gloss
of what a project is, which a reader row asked for.

**Row 38, Alignment Track preselection.** Cut the unverifiable negative claim.
The paragraph now states the rule positively and stops at what the registry
supports, "the first analysis-ready BAM alignment track the bundle holds,
whichever track you opened the dialog from." This also clears a consensus row
about the double negative and "arrived from".

## 3. The two smaller Notes items

**The second badge.** Step 2 now names both, "Requires GATK Core Pack" for a
missing pack and "Requires GATK4" for a pack installed without the tool ready.
Confirmed at `BAMVariantCallingCatalog.swift:94-104` with the `displayName:
"GATK4"` requirement at `PluginPack.swift:632`.

**`--emit-ref-confidence` fallback.** The entry now says anything other than
`GVCF` or `NONE` falls back to `GVCF` rather than raising an error, with a
prompt to check spelling. Confirmed at `GATKCommand.swift:185`, which is
`GATKEmitReferenceConfidence(rawValue: ...uppercased()) ?? .gvcf`.

## 4. Rulings applied

**Variant counts.** 843 and 184 replaced with 844 and 182 throughout, with one
sentence saying a `bcftools` tally reads 843 and 184 because it counts one
record under both type headings. Recounted the fixture VCF by first ALT allele
to confirm the ruling: 1,026 total, 844 SNVs, 182 indels.

**Heterozygous ratio.** Stated once as 589 of 1,026, about 57 percent, with
"a ratio near or somewhat above one to one is what a single human sample at
this depth looks like." Removed the three-to-two phrasing from Reading the
results and the near-half phrasing from What good looks like, which now quotes
the same figure.

**Mean depth.** Both figures now name their field. 38 is "the mean of the
per-sample FORMAT DP field across the 1,026 called positions" and 44.7 is "the
mean read depth across the whole 500 kilobase window, read from the alignment
rather than from the calls", with one sentence on why they differ.

**GVCF rows.** One clause added, the GVCF's 1,199 alternate-allele rows exceed
the genotyped VCF's 1,026 "because a GVCF also keeps candidate positions that
the genotyping step later looked at and did not call."

**Experimental features.** The fixed CONSISTENCY.md sentence moved out of the
overview into Before you start, with one added sentence on what experimental
means here, which answers a reader row.

**Sequence dictionary.** Now a required step in Before you start under its own
subheading, with the `gatk CreateSequenceDictionary` command in its own block
and a plain statement that both routes need it, "the dialog exactly as much as
the command line, because both hand GATK the same bare FASTA." Removed it from
the command-line shell block, which now links back. The failed
`conda install --pack gatk-core` is now a defect note in the command-line
section rather than a route offered beside the Plugin Manager, and Before you
start gives only the Plugin Manager.

**Terminal material.** The On the command line section opens with chapter 33's
fixed paragraph. The first cli_only block opens with "A reader working only in
the window can skip this subsection and the next one." "Step 0" is replaced by
a link to the Before you start install subheading.

**Scales.** QUAL is named as Phred once, with 30 and 60 related to it, and
`--stand-call-conf` says its 30.0 sits on that same scale and is a permissive
bar. No acceptable range invented for QUAL, the 961 benchmark, or the 373 of
589 phasing rate. Each is now judged against the benchmark or against other
samples, in those words.

**Glosses at first use.** Added for managed software environment, SQLite (as an
internal index the reader never opens), genotype likelihoods, WhatsHap as a
separate program, library and PCR-free, whole-genome against exome against
amplicon with the fixture named as whole-genome, shotgun against amplicon with
the fixture named as shotgun, ploidy and diploid inside the Extra arguments
paragraph before the `--ploidy` entry, analysis-ready in Step 1 before the term
is used again, unsettled replaced by "the reads disagree with each other",
tabix and bcftools and wc with their sources, half a megabase against chr20's
length, the provenance record's location and how to open it, and the Map Reads
wizard's Read Group Sample field as where to check SM.

**Defects kept, one sentence each where the reader meets them.** The phased
dialog entry that cannot run is in Step 5, now leading with the instruction to
use the command line. `variants phase --threads` leads with "Does not work in
this release" and names the global-option collision the fidelity reviewer
found. The missing `.dict` is in Before you start. The threshold fields being
discarded is in Step 2 and in both Settings paragraphs.

## 5. Consensus reader rows applied

All 41 consensus rows (three or more readers) are applied. Beyond those already
listed above under rulings, the notable ones are the Step 1 heading dropping
"analysis-ready" and defining it in the body, the dense dialog paragraph broken
into a four-item list with the generated track name shown as a worked example,
Step 3 stating what a window-only reader should do about the GVCF default,
Step 4 saying what changed since Step 1 and spelling out click-to-sort and what
filter chips are, "a loose BAM in a folder cannot be called from in the window"
rewritten plainly, "order of magnitude" replaced by a comparison to the
benchmark, `--dry-run` leading with its use case and saying "takes priority"
rather than "wins", the two renamed GATK flags stated as a rename up front, the
`tabix` line given with its filename inside the phased code block, the mapping
step given a settings instruction and a time, the What good looks like exit
check given its window equivalent, and the Next section saying the GVCF comes
from the command-line route only.

## 6. Other reader rows applied

Applied: the aligner gloss, the reference gloss, the GVCF gloss at first use in
What it is, the haplotype gloss in What it is, the slash notation introduced
before the counts that use it, the QUAL sentence given its object, the
experimental sentence given its scope, the fixture named PCR-free, the
pseudoautosomal clause cut for "most of the male X chromosome", the ploidy
diagnosis marked command-line only, wall time replaced by elapsed time, core
count given a source and a rule of thumb, `--max-alternate-alleles` saying what
happens at the cap and using "positions" for "sites", the five control names
listed in order, "draw" replaced by "show", Step 3 contrasting only two terms,
the drawer's trigger stated, viewport glossed, the track id explained as
generated, sorted and indexed explained as automatic, the BAM's origin stated,
threads glossed, FASTA and FASTQ glossed, bundle and track glossed, the two
blocking items named outright, the working directory stated, and the
`--extra-args` failure given a concrete example.

Not applied: the row asking to put every Settings flag in a trailing
parenthesis, because CONSISTENCY.md fixes the flag sentence shape and a single
reader is not grounds to break it. The row asking to move the Step 5 defect
note out of the Procedure, because the reader meets the entry there and the
rulings require the defect disclosed where it is met. Step 5 now leads with the
action instead.

## 7. Facts I could not source, and what I did

**bcftools and tabix provenance.** The chapter previously implied they arrive
with the packs. They do not. `PluginPack.swift` carries neither, and
`third-party-tools-lock.json:14-15` puts `bcftools` and `htslib` in managed
environments of their own. The chapter now says so and gives the two
`lungfish-cli conda install` lines, and names `wc` as shipping with macOS.

**`gatk` on the shell PATH after a pack install.** The author ran bare `gatk`
successfully but nothing in source states that the pack puts it on PATH. The
chapter now tells the reader to install the pack first and gives the absolute
path `~/.lungfish/conda/envs/gatk-core/bin/gatk` as the fallback, which exists
on this machine.

**Per-megabase variant rate.** Written as "one to two thousand differences from
the reference in every megabase", which is consistent with the fixture's 961
records over half a megabase. No single source cited, so it is stated as an
order of magnitude rather than a figure.

## 8. Left for the gate or for other owners

- `build/mkdocs.yml:118` still labels this page "HaplotypeCaller Dry Runs". Not
  mine to edit.
- `parameters.yaml:3721`, `:3728`, `:3809`, `:3816` still say "Recorded with
  the run" for the two threshold settings, which the fidelity review proved
  wrong for the GATK entries. The chapter now contradicts the registry
  deliberately. Registry owner's fix.
- CONSISTENCY.md wants two new entries, the `variants/gatk` storage exception
  and the depth-field ruling. Not mine to edit.
- The joint-genotyping chapter still prints 843 and 184 at line 155 and an
  unnamed 39.4 at line 168. The project manager's ruling covers both and that
  chapter has its own owner.
- Both shot captions are unchanged and still describe only confirmed things.
- Front-matter `brand_reviewed` and `lead_approved` remain false.
