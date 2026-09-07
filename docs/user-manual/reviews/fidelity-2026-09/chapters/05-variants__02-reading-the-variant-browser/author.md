# Author report, chapter 28, Reading the Variants Table

File: `docs/user-manual/chapters/05-variants/02-reading-the-variant-browser.md`
Registry ids: `variants.filter-table`, `variants.query`
Fixture: `hg002-chr20`
Lint: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`, first pass, no fixes needed.

## Measurements

Every number in the chapter comes from a run in
`/private/tmp/claude-501/.../scratchpad/variants-table/`. Two scripts hold the
work, `measure.sh` and `measure2.sh` for bcftools counting, and `mkbundle.sh`
plus `query.sh` and `query2.sh` for the CLI runs. bcftools 1.24 from
`~/.lungfish/conda/envs/bcftools/bin/bcftools`, run against copies of the two
committed expected VCFs.

### Record counts and composition

| Measurement | bcftools track | LoFreq track |
|---|---|---|
| Records | 1,056 | 862 |
| FILTER values | 1,056 unset `.` | 862 `PASS` |
| Substitutions | 874 | 862 |
| Insertions or deletions | 182 | 0 |
| QUAL range | 4.4503 to 228.417 | 73 to 2478 |
| QUAL below 30 | 24 | 0 |
| DP at or above 10 | 1,049 | 862 |
| Distinct positions | 1,053 | 861 |
| INFO keys declared | 16 | 7 |
| FORMAT keys | GT, PL, AD | none, no sample column |

The fixture README quotes 1,056 and 862, which my counts reproduce exactly.

The SNV and indel split differs by one from the figure chapter 27 quotes
(873 and 183). `bcftools view -v snps` and `-v indels` both count a
multiallelic record that carries a substitution and an indel, so the two
subsets overlap by one record and 874 plus 182 is the same file as 873 plus
183. I used 874 and 182 and did not repeat chapter 27's numbers, so the two
chapters do not contradict each other on a shared row count. Worth a
reviewer's eye if the campaign wants one convention.

### Cross-caller position overlap

Computed with `bcftools query -f '%POS\n' | sort -u` on each file and `comm`.

- Positions in both call sets: 852
- bcftools-only positions: 201
- LoFreq-only positions: 9

### Allele frequency and genotype distributions

LoFreq's own `AF` INFO key splits the 862 rows into 339 at or above 0.8, 517
between 0.2 and 0.8, and 6 below 0.2. The bcftools genotypes split 1,056 rows
into 623 `0/1`, 415 `1/1`, and 18 `1/2`.

### Region-scoped counts used in the Search Builder walkthrough

- bcftools rows at position 250,000 or below: 574
- of those, rows with `INFO/DP >= 30`: 512
- LoFreq rows at position 250,000 or below: 464

### CLI runs

I built a real bundle with
`lungfish-cli bundle create --fasta <fixture fasta> --variant <bcftools vcf>
--variant <lofreq vcf>` and ran `variants query` against it. Row counts from
`bcftools view -H <output> | wc -l`.

| `--filter` | Result |
|---|---|
| `Sample[HG002].GT=1/1` | 415 records |
| `Sample[HG002].GT=0/1` | 623 records |
| `Sample[HG002].GT!=0/1` | 433 records |
| `Sample[HG002].AF>=0.5` | 770 records |
| `count(Sample[*].GT=1/1) >= 1` | 415 records |
| `Sample[HG002].GT=1/1 --limit 20` | 20 records |
| `Sample[HG002].DP>=1` | 0 records |
| `filter=PASS` | Error, "Unsupported smart-filter clause" |
| `type=SNV` | Error, same |
| `qual>=30` | Error, same |
| `DP>=10` | Error, same |
| `pos:1-100000` | Error, same |
| `AF>=0.8` | Error, same |
| `AF>=0.05; AF<0.5` | Error on the first clause |
| `filter=PASS; DP>=10` | Error on the first clause |

The 415, 623, and 433 counts match the genotype tallies from `bcftools query
-f '[%GT]\n'` exactly, so the CLI is reading the same rows the VCF holds. The
770 from `Sample[HG002].AF>=0.5` matches an independent count I made in awk
over the `AD` field, which confirms that the per-sample `AF` is derived from
allele depths rather than read from an `AF` tag
(`VariantSmartFilter.alleleFrequencyExpression` computes alt over ref plus
alt in SQL).

A provenance sidecar named `<output>.lungfish-provenance.json` was written
beside every successful output, sized 3.7 to 3.8 KB.

## What I removed from the old chapters and why

### From the old chapter 02

- The whole "variant browser" framing, including the claim that it opens by
  clicking a variant track in the sidebar and occupies the full viewport.
  There is no such surface, no such sidebar node, and the table is a drawer
  inside the reference bundle viewport.
- Every instruction to type into a free-text filter field or to clear it with
  an `x`. The variant free-text field is permanently hidden
  (`+Columns.swift:92`), so the whole set of instructions was unreachable.
  The Search Builder and the Clear button replace them.
- The eight-column table and its "seven VCF plus one Lungfish" split.
  Replaced with the real twelve, and with the correct provenance of each,
  seven from the VCF, `Type` and `Samples` derived, `Source`, `Consequence`,
  and `AA Change` added by LGE.
- `Position>=21000` and every other comparison against a `Position` key. The
  clause key is `pos` or `range` and it takes a range.
- The claim that colon syntax such as `Pos:1193` is invalid. Colon and equals
  are interchangeable for the known keys.
- The claim that the track ticks are color-coded by caller. They encode
  genotype and variant type only (`VariantTrackRenderer.swift:534, :543,
  :563`), so I say plainly that they cannot separate two callers.
- The instruction to verify the PASS chip by watching the free-text field.
  Nothing can be watched.
- The nine-chip curated list. Replaced with the real fourteen in four named
  sections, plus the availability gating that decides which of them a reader
  actually sees.
- "Click a chip to apply it and combine chips to narrow further" as a blanket
  rule. Three groups are radio buttons within themselves.
- The SARS-CoV-2 SRR36291587 worked example, the spike T19I walkthrough, and
  the space-separated `AF>=0.05 AF<0.5` clause pair. The chapter's fixture is
  now `hg002-chr20`, and the campaign wants human examples first.
- The claim that iVar quality sorts usefully. LGE's iVar converter writes a
  literal `.` in QUAL (`IVarTSVToVCFConverter.swift:144`), so I say the
  column is blank on an iVar track.
- The "roughly 80 PASS rows" figure, which was illustrative rather than
  measured, and the "more than a quarter of rows" disagreement rule of thumb,
  which had no source. Both replaced with measured fixture numbers.

### From the retiring chapter 03

Kept, in the new step 6 and in the "What good looks like" fourth check: the
idea that two tracks aggregate into one table, that the `Source` column is
the only readable discriminator, that sorting by `Position` puts the two
callers' rows for a shared coordinate on adjacent lines, and that a
disagreement usually has a mundane cause in a caller default rather than an
interesting one. I grounded that last point on the measured indel split
(182 bcftools indels against 0 from LoFreq) rather than on the old chapter's
unmeasured claims.

Dropped: the four-position SARS-CoV-2 walkthrough (1193, 1989, 27889,
28881), the iVar codon-merge teaching, the `bcftools isec` and
`bcftools norm -a` recipe, the caller-comparison table, and the LoFreq run
procedure. The LoFreq procedure now belongs to chapter 27, and the rest
described either a fixture this chapter no longer uses or an external
workflow no LGE feature backs.

## How each DRIFT unverifiable row was settled

The Part A block for this chapter lists two unverifiable rows.

**Row 15, "A LoFreq VCF defines `DP`, `AF`, `SB`, and `DP4` in `INFO`".**
Settled by measurement rather than left out. `bcftools view -h` on the
fixture's LoFreq VCF declares seven INFO keys, `DP AF SB DP4 INDEL CONSVAR
HRUN`, and the bcftools VCF declares sixteen. The chapter therefore states
the counts, sixteen and seven, and names only the keys it actually uses,
rather than asserting a fixed four-key list that is a property of LoFreq's
build and not of LGE.

**Row 31, "The filter bar shows a count of matched rows directly under the
input".** Settled as false and dropped. The only count label I could find in
the source belongs to the standalone `VCFDatasetViewController`, which the
ground-truth standing note identifies as a separate dead-code viewer. The
drawer has a `Local: Visible Rows` badge (`AnnotationTableDrawerView.swift:545`)
whose tooltip is about column-header filters being scoped to loaded rows,
which is not a match count. Since the claim depended on a free-text input
that does not exist, the whole sentence went with the field. The chapter
makes no claim about a row-count readout anywhere.

## Files changed for the retirement

1. `git rm docs/user-manual/chapters/05-variants/03-cross-caller-comparison.md`.
2. `docs/user-manual/build/mkdocs.yml`, removed the
   `Cross-Caller Comparison` nav entry and retitled the chapter 02 entry from
   `Reading the Variant Browser` to `Reading the Variants Table`.
3. `docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md`,
   two links to the deleted chapter repointed at this one, at the end of
   step 4 and in the Next section. Chapter 27 relints clean.
4. `docs/user-manual/help-ids.yaml`. No entry named the deleted chapter, but
   both entries pointing at chapter 02 carried anchors that no longer match a
   live heading. `viewport.VariantBrowser` moved from `procedure` to
   `step-2-read-the-columns` with a rewritten description, and
   `inspector.VariantSection` moved from
   `step-3-read-a-row-in-the-inspector` to
   `step-3-select-a-row-and-read-the-inspector`. I also added
   `viewport.VariantFilterTable` pointing at
   `step-4-filter-with-the-preset-chips`, since the chip strip and the Search
   Builder are the surface a reader most needs help on and no help id reached
   them.

`docs/user-manual/ARCHITECTURE.md:298` still describes the deleted chapter,
and the two `reviews/part-ii-fidelity-2026-06-02/` specs still reference its
illustration slot. Both are owned by other roles, so I left them for the
Documentation Lead.

## Shot markers

Five, each with a caption in the frontmatter and a marker in the body.

| Id | Where |
|---|---|
| `variants-tab-twelve-columns` | End of step 1 |
| `variants-inspector-row` | End of step 3 |
| `variants-preset-chips` | Inside step 4, after the PASS lesson |
| `variants-search-builder` | End of step 5 |
| `variants-source-column` | Inside step 6, after the 250527 walkthrough |

Every one is a reshoot relative to the old planned shots, which named a
standalone browser with eight columns and a free-text field. The Search
Builder shot is the new one the drift report asked for.

## Glossary additions

Four new entries, all in the existing one-sentence-plus-See-also shape and
alphabetised in place.

- **Allele depth** `{#allele-depth}` in A, between Allele and Allele
  frequency. Needed because the per-sample `AF` clause is derived from `AD`,
  which is the reason `Sample[HG002].DP>=1` returns nothing.
- **Consequence** `{#consequence}` in C, after Consensus sequence.
- **Table drawer** `{#table-drawer}` in T, after Tabix.
- **Variant track** `{#variant-track}` in V, after Variant-caller.

`smart-filter-token` and `filter-profile` already existed, so the chapter
links those rather than adding near-duplicates. `glossary_refs` names
`smart-filter-token`.

## Possible app defects found

1. **`Het Only` chip can never appear.** `SmartToken.isAvailable` returns a
   hard `false` for `.heterozygous`
   (`SmartFilterTokens.swift`, the `case .heterozygous: return false` in
   `isAvailable`), with the unavailability reason "Genotype filtering not
   yet supported". `parameters.yaml` lists it as one of the fourteen chips
   without saying it is inert, and the foundations chapter does not flag it
   either. Either the chip should be removed from the token list or the
   registry entry should say it is unimplemented. I wrote the chapter to say
   the chip is unavailable on every track today.

2. **The CLI `--filter` grammar is a strict subset of the drawer's.** The
   `variants.query` registry note says "a query you build in the sheet can be
   pasted straight into `--filter`". That is not true. `VariantSmartFilter`
   parses per-sample clauses only, so every plain clause key the Search
   Builder writes (`filter=`, `pos:`, `type=`, `qual>=`) and every INFO
   comparison is rejected with "Unsupported smart-filter clause". A reader
   following the registry note would hit an error on their first attempt. The
   chapter states the restriction plainly instead. The registry note needs
   correcting by whoever owns `parameters.yaml`.

3. **`Sample[<name>].DP` matches nothing on a bcftools track.** `--filter
   'Sample[HG002].DP>=1'` returned zero records against a track with 1,056
   rows all carrying real depth in `INFO/DP`. The exported rows show `DP` as
   `.` in the FORMAT payload, because the bcftools VCF declares `GT:PL:AD`
   and carries no per-sample `DP` at all, so the ingest has nothing to store.
   The behaviour is arguably correct, but a silent empty result where the
   depth is plainly present in `INFO` is a trap. Either the ingest could fall
   back to `INFO/DP` for a single-sample file, or the CLI could warn that the
   requested per-sample field is absent from the database. I taught the trap
   rather than the workaround.

4. **`bundle create --variant` writes BCF and CSI, not VCF.GZ and TBI.** The
   CONSISTENCY sheet's "Variant track storage" section, settled by the
   chapter 5 fidelity review, states that a variant track is
   `<name>.vcf.gz` with `.vcf.gz.tbi` and a `.db` sidecar, and that there is
   no BCF and no CSI index. My `bundle create --variant` run produced
   `hg002.bcftools.vcf.bcf`, `hg002.bcftools.vcf.bcf.csi`, and
   `hg002.bcftools.vcf.db` under the bundle's `variants/` folder. So the two
   attachment paths disagree, `BundleVariantTrackAttachmentService` (used by
   `variants call`) writing one shape and `bundle create --variant` writing
   another. The chapter avoids the question by never describing what
   `bundle create --variant` leaves on disk, but the inconsistency is real
   and the CONSISTENCY sheet's claim is true only of the calling path.

5. **`Match Any` exists in the model but not in the UI.** `QueryLogic`
   defines `matchAny` and overrides `allCases` to hide it, and
   `loadPreset` silently rewrites a `matchAny` preset to `matchAll`. A saved
   or imported preset that meant OR therefore executes as AND without telling
   the user. Low severity today because nothing can create such a preset from
   the UI, but a decoded preset from another source would be silently
   changed. The chapter says Match All is the only choice.
