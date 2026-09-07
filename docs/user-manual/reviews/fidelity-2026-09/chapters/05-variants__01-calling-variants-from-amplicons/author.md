# Author report, 05-variants/01-calling-variants-from-amplicons.md

Chapter 27 of the campaign roster. Rewritten in place and retitled "Calling
Variants". The file name is unchanged. The nav entry in
`docs/user-manual/build/mkdocs.yml` line 99 was retitled to match.

Registry ids documented: `variants.call-bcftools`, `variants.call-lofreq`,
`variants.call-ivar`. Fixture: hg002-chr20.

## Runs I made

Everything ran from a scratch project under the session scratchpad at
`.../scratchpad/variants/scratch.lungfish`. Nothing was written under
`~/Desktop/lge-docs` or into the fixture folder.

Setup, mirroring the fixture's own `regenerate.sh` so the comparison is
like for like:

```
lungfish-cli import fasta GRCh38.chr20.10.0-10.5Mb.fasta --name "chr20 10.0-10.5Mb" -o <scratch project>
lungfish-cli bam adopt-mapping --bundle <bundle> --mapping-result <copy of expected/mapping> \
    --name "HG002 minimap2" --track-id hg002-minimap2
lungfish-cli variants call --bundle <bundle> --alignment-track hg002-minimap2 --caller bcftools --name "Doc bcftools"
lungfish-cli variants call --bundle <bundle> --alignment-track hg002-minimap2 --caller lofreq   --name "Doc LoFreq"
```

The BAM I adopted is a copy of the fixture's `expected/mapping/HG002.sorted.bam`,
which is gitignored but present locally. `adopt-mapping` moves its input, so
copying first is required.

Counting was done with the app's own managed bcftools at
`~/.lungfish/conda/envs/bcftools/bin/bcftools`.

### Counts from my runs

| Measure | bcftools | LoFreq |
|---|---|---|
| Records (`bcftools view -H \| wc -l`) | 1,056 | 862 |
| FILTER `.` | 1,056 | 0 |
| FILTER `PASS` | 0 | 862 |
| Single-base substitutions | 873 | 862 |
| Insertions or deletions | 183 | 0 |
| Distinct positions | 1,053 | 861 |
| Columns per row | 10 | 8 |
| Genotype `0/1` | 623 | not applicable |
| Genotype `1/1` | 415 | not applicable |

Against the fixture's 961-record benchmark VCF, matching CHROM and POS only,
954 of bcftools' 1,053 distinct positions and 808 of LoFreq's 861 match a
benchmark position. bcftools and LoFreq share 852 distinct positions with each
other. All three of those match the fixture README.

### Comparison against the expected VCFs

Both of my VCFs are **byte-identical in content** to the committed expected
files. `bcftools view -H` output for
`expected/variants/bcftools/HG002.bcftools.vcf.gz` and my
`vc-44ffbd29-....vcf.gz` diffed clean, as did the LoFreq pair. The compressed
files are also the same size (46,134 bytes and 14,112 bytes). **No differences
found.** Every number quoted in the chapter therefore comes from a run I made
and is independently corroborated by the committed fixture output.

### Storage layout, verified

The CONSISTENCY.md variant-track storage rule is confirmed exactly. Each track
wrote three files into the bundle's `variants/` folder under one shared stem:

```
vc-44ffbd29-3c06-4e0d-8731-9264a30adc7a.vcf.gz        46,134 bytes
vc-44ffbd29-3c06-4e0d-8731-9264a30adc7a.vcf.gz.tbi       368 bytes
vc-44ffbd29-3c06-4e0d-8731-9264a30adc7a.db            2,228,224 bytes
```

Plus a `.lungfish-provenance.json` sidecar, which the consistency sheet does
not name but which is written alongside. No BCF and no CSI index, as the sheet
says. The chapter quotes the three sizes for the bcftools track.

### Provenance, read from my own runs

Commands recorded, confirming the parameters.yaml notes verbatim:

- bcftools: `bcftools mpileup -Ou -f <ref> <bam>` piped into
  `bcftools call -mv -Ov -o <out>`, then `bcftools reheader`, `bcftools sort`,
  `bgzip`, `tabix`, SQLite import.
- LoFreq: `lofreq call -f <ref> -o <out> <bam>`, then the same normalise,
  sort, compress, index, import tail.

Tool versions from the sidecars: bcftools 1.24
(`bioconda::bcftools=1.24=h6bd33b9_2`), samtools 1.24, htslib 1.24.
LoFreq's version field records the tool's own error text, because the binary
rejects `--version`; `lofreq version` reports 2.1.5 directly. iVar in the
managed environment is 1.4.4. App version on all runs was `lungfish-cli
2026.9.13`.

**The most useful provenance finding.** With `--min-af` and `--min-depth`
omitted, both runs recorded `minimumAlleleFrequency: "caller-default"` and
`minimumDepth: "caller-default"`. That is direct machine evidence for the
parameters.yaml claim that those two fields never reach bcftools or LoFreq,
and the chapter cites it in the What good looks like section as the way a
reader can check the same thing for themselves.

## What I removed from the old chapter, and why

The old chapter was an eight-step SARS-CoV-2 amplicon walkthrough. Almost all
of it went.

1. **The whole SRR36291587 procedure (steps 1 to 5).** Fetching MN908947.3
   from NCBI, downloading SRA reads, mapping with minimap2, and primer-trimming
   are each now a chapter of their own earlier in the manual. Repeating them
   here duplicated four chapters and carried three false menu paths with it
   (`Tools > FASTQ/FASTA Operations > Mapping...` does not exist, `Layout` has
   no `Auto-detect` value, the ONT preset is not called `Map ONT (map-ont)`).
   The rewrite starts from an alignment track that already exists and points
   back at those chapters.

2. **The fixture swap.** The roster reassigns this chapter to hg002-chr20, and
   the campaign rule puts human examples first. The worked example is now
   bcftools and LoFreq on the HG002 alignment, and iVar is documented as the
   amplicon caller with a pointer to the primer-trimmed SARS-CoV-2 track from
   Primer Trimming rather than a second worked run.

3. **"The Variant Calling dialog opens in three columns" with `Inputs` and
   `Output` sections.** False. The dialog is two columns and the right pane
   stacks Overview, Thresholds, `<Tool> Settings`, iVar Options (iVar only),
   Extra arguments, Readiness. Verified against
   `BAMVariantCallingToolPanes.swift` body order.

4. **Every reference to a standalone variant browser.** No such viewport
   exists. Results reach the reader through the Variants tab of the table
   drawer, per the ground-truth standing note and the consistency sheet.

5. **The eight-column table list.** There are twelve fixed columns plus a
   bookmark column. The rewrite does not re-enumerate them, because chapter
   02 owns that table, and instead names only the Source column, which this
   chapter needs to tell two callers apart.

6. **The Presets `x`-to-clear and free-text filter instructions.** The variant
   free-text field is permanently hidden. Filtering is Presets chips plus the
   Search Builder sheet, and chapter 02 documents both.

7. **The codon-merge worked example at position 28881.** It depended on the
   SARS-CoV-2 run this chapter no longer performs, and its stated merge rule
   was wrong anyway (the merge is gated on allele frequency, not on the
   amino-acid outcome). The mechanism survives, correctly stated, in the
   Settings entries for Consensus allele frequency and Merge AF distance and
   in one sentence at the end of step 6.

8. **The `{{ fixtures_refs... | cite }}` macro line.** STYLE.md says the build
   has no citation macro and it must never be written.

9. **The unsourced "about five minutes" and "250 MB" figures.** No timing
   claim survives, per the campaign rule against unsourced durations.

## What I added that the drift report listed as missing

`Tools > Call Variants...` as a top-level route and its `No Bundle Loaded`
gate. The `Extra arguments` field and where its text lands in each caller's
command line. The `Readiness` section and its per-caller messages, including
the iVar "Confirm the BAM was primer-trimmed" block. The `Alignment Track`
picker. The tool sidebar's availability badges and pack gating, including that
bcftools is gated on the Required Setup pack rather than the Variant Calling
pack. The `.db` SQLite sidecar and the full three-file storage layout. The
`bq` filter code, via the Minimum ALT quality setting. That the thresholds
reach iVar alone.

Deliberately left out, as belonging to a neighbouring chapter rather than this
one: the all-haplotypes second VCF, the always-`.` QUAL column on iVar rows
(chapter 02 owns the Quality column), the seven other bundled primer schemes
(Primer Trimming owns the scheme menu), the primer-trim dialog's Target
section, and `bundle create --organism`/`--assembly`.

## How each DRIFT unverifiable row was settled

The Part A section lists five unverifiable rows. All five attach to claims the
rewrite deletes, so each is settled by removal rather than by a live check.
This is recorded explicitly so no later pass re-opens them against this
chapter.

| Row | Claim | Settlement |
|---|---|---|
| 12 | "the Inspector shows `1 annotation track` beside the bundle metadata" | Removed with the NCBI-fetch step. The rewrite never asserts an Inspector annotation count. |
| 13 | "The SARS-CoV-2 GFF3 from NCBI lists 24 features" | Removed with the same step. It was a property of an NCBI record, never of LGE, so it could not have been settled from the app in any case. |
| 23 | Alignment track named `minimap2 Mapping` under `MN908947.3 > Alignments` | The name is settled and reused, not by me but by the already-committed mapping chapter, which states "minimap2 Mapping" from its own reference run. This chapter cites that chapter for the track and asserts no sidebar path of its own, since there is no `Alignments` child node. |
| 30 | Primer-trim output name `... - Primer-trimmed (QIASeqDIRECT-SARS2)` | Removed with the primer-trim step. The committed Primer Trimming chapter owns and states that name. |
| 51 | "Select a row and the genome track centers on that position" | Removed. The rewrite makes no claim about row-selection centering, which belongs to chapter 02's treatment of the table. I did not trace the wiring, so it stays open for chapter 02 rather than being closed here. |

One additional item from the live spot-check, Task 2.4. The bcftools dialog
could not be opened live because selecting a sidebar row needed a front-most
switch the computer-use layer refused while the user was typing elsewhere. Two
consequences for this chapter. Everything I say about the bcftools pane comes
from source (`BAMVariantCallingToolPanes.swift`,
`BAMVariantCallingDialogState.swift`, `BAMVariantCallingCatalog.swift`) plus
my own CLI runs, not from a live sighting, and the two dialog shot markers
should be treated as un-captured rather than as reshoots of an existing image.
The one thing the spot-check did establish live, that `Tools > Call Variants...`
exists and answers `No Bundle Loaded` without a bundle, is stated in step 1.

## Shot markers

Three, all new, all with captions in the front matter. The old chapter's eight
markers are gone with the procedure they illustrated.

| id | Where | What it must show |
|---|---|---|
| `call-variants-dialog-bcftools` | Step 2 | The two-column dialog with bcftools selected. Tool sidebar left. Right pane showing Overview with the Alignment Track menu and the pre-filled Output Variant Track Name, Thresholds, and the bcftools Settings line. No iVar Options section. |
| `call-variants-dialog-ivar` | Step 6 | The same dialog with iVar selected, the primer-trim checkbox ticked and greyed with its date-and-scheme caption, and the iVar Options section visible with its four controls. Needs a primer-trimmed track, so shoot it against the SARS-CoV-2 bundle from Primer Trimming, not against HG002. |
| `variants-tab-two-callers` | Step 5 | The reference bundle viewport with the table drawer open on its Variants tab, both tracks loaded, and the Source column populated with two distinct values. |

## Glossary additions

Seven terms added in the existing entry shape, alphabetised, each one sentence
or two with a `See also:` trailer, each listed in `glossary_refs`.

`bcftools`, `bgzip`, `indel`, `lofreq`, `mpileup`, `ploidy`, `snv`.

Terms the chapter uses that already existed and were reused unchanged include
`variant-caller`, `filter`, `format`, `info`, `genotype`, `pileup`,
`allele-frequency`, `depth`, `benchmark-vcf`, `ivar`, `primer-trim`,
`primer-scheme`, `tabix`, `ref-alt`, `phred-score`, and `ploidy`'s neighbours
`heterozygous` and `homozygous`.

## Possible app defects noticed

1. **Thresholds that silently do nothing.** The Thresholds section is drawn
   identically for all seven callers, but Minimum Allele Frequency and Minimum
   Depth only reach iVar. A reader who types 0.20 before a bcftools run gets
   no warning, no disabled field, and a provenance record reading
   `caller-default`. The values are accepted, recorded, and discarded. This is
   the single most likely source of a wrong result in this dialog. A
   disclosure or a disabled state on the non-iVar callers would fix it. I
   documented the behaviour plainly rather than papering over it, but it reads
   as a UI defect rather than a design choice.

2. **The PASS chip empties a bcftools table with no explanation.** Because a
   default bcftools run leaves every FILTER as `.`, the PASS chip hides all
   1,056 rows. The table simply goes blank. A reader with no VCF background
   will read that as a broken track. Foundations chapter 05 already flags this
   and I repeat it here, but an empty-state line naming the cause would spare
   the explanation.

3. **Minor, and cosmetic.** The top-level menu item is titled
   `Call Variants…` with a real ellipsis character, while the Tools submenu
   items nearby use three ASCII periods (`Search NCBI...`). Harmless, but it
   is an inconsistency a reader copying strings will notice.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md
```

Result: `no issues found`, clean on the first run.

`GLOSSARY.md` was linted too. It emits only the pre-existing `See also:`
colon warnings that every one of its entries has carried since the file was
created. My seven new entries add exactly seven colons, one per `See also:`
trailer, and zero semicolons, matching the house entry shape.
