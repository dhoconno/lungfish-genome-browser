# Author report, 05-variants/05-consensus-and-lineage

Chapter 30 of the campaign roster. Retitled "Extracting a Consensus Sequence",
file name unchanged, nav entry in `docs/user-manual/build/mkdocs.yml:102`
updated to match. Registry id `bam.extract-consensus`, fixture `hg002-chr20`.

Lint result, strict mode:

```
docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md: no issues found
```

## Runs I made

Every count and every quoted string in the chapter comes from one of the runs
below. All work happened under
`/private/tmp/claude-501/.../scratchpad/consensus/`, on copies of the fixture's
`expected/mapping/HG002.sorted.bam` and `GRCh38.chr20.10.0-10.5Mb.fasta`.
Nothing was written into `~/Desktop/lge-docs` or into the fixture folder.

The command chain reproduces exactly what `AlignmentDataProvider.fetchConsensus`
runs (`Sources/LungfishIO/Bundles/AlignmentDataProvider.swift:763-880`), stage
for stage, flag for flag. samtools was the app's own managed build,
`~/.lungfish/conda/envs/samtools/bin/samtools`, reporting `samtools 1.24` on
`htslib 1.24`.

Stage 1, the view snapshot:

```
samtools view -b -h -o filtered.bam -X HG002.sorted.bam HG002.sorted.bam.bai chr20_10.0-10.5Mb:1-500001
samtools index filtered.bam filtered.bam.bai
```

Stage 2, the caller, once per settings variation:

```
samtools consensus -r chr20_10.0-10.5Mb:1-500001 -a -f FASTA -m bayesian \
  --min-BQ 0 --ff 0 -d 8 --show-del yes --show-ins no filtered.bam
```

### Counts

Defaults, meaning whole contig, Bayesian, minimum depth 8, MAPQ 0, base
quality 0, no ambiguity codes, no gap masking:

| Measure | Value |
|---|---|
| Consensus length | 500,001 |
| Reference length | 500,001 |
| `A` | 150,916 |
| `T` | 149,881 |
| `C` | 99,532 |
| `G` | 98,677 |
| `N` | 724 (0.145 percent) |
| `*` (deletion) | 271 |
| Plain ACGT total | 499,006 |
| Positions differing from the reference, `N` excluded | 608 |

Variations, each one setting changed from those defaults:

| Run | `N` count | Share |
|---|---|---|
| Defaults | 724 | 0.145 percent |
| `-d 20` (Consensus minimum depth 20) | 5,339 | 1.068 percent |
| `-m simple` (Consensus Mode Simple) | 888 | 0.178 percent |
| `-A` (Use IUPAC ambiguity codes) | 171 | 0.034 percent |
| `-q 20` on the view stage (Consensus minimum MAPQ 20) | 800 | 0.160 percent |

The IUPAC run's ambiguity letters were `Y` 191, `R` 184, `W` 48, `M` 47,
`K` 45, `S` 38, for 553 total, and its `*` count fell to 94.
The Simple run's `*` count was 261.

### Position 2,078

The chapter's spot-check position, taken from the Reading an Alignment chapter.

```
samtools depth -q 0 -g 1796 -r chr20_10.0-10.5Mb:2078-2078 -X filtered.bam filtered.bam.bai
chr20_10.0-10.5Mb	2078	63

samtools mpileup -f GRCh38.chr20.10.0-10.5Mb.fasta -r chr20_10.0-10.5Mb:2078-2078 filtered.bam
chr20_10.0-10.5Mb 2078 G 51
aaAaAaAaaaAAAAaaaAaAaaAAAaaAAAAaaaaaaAaAAAAAaAaaaAa
```

Reference `G`, consensus `A`, 51 of 51 pileup bases `A`, total depth 63. The
consensus carried `A` in every one of the five runs above, which is the
expected behaviour for a homozygous change. The chapter quotes 51 and 63 and
explains the difference (samtools sets aside records it treats as unusable at
the pileup stage).

### The bare `>chrom` header

The project memory records that `samtools consensus` once wrote a bare
`>chrom` header that broke Extract Consensus. I checked whether the fix holds
and it does, on both sides.

The behaviour is unchanged. A whole-contig request still returns a bare header:

```
>chr20_10.0-10.5Mb
```

while a sub-region request returns the coordinate form:

```
>chr20_10.0-10.5Mb:2000-2200
```

The fix is in `AlignmentDataProvider.parseConsensusFASTA`
(`Sources/LungfishIO/Bundles/AlignmentDataProvider.swift:1134-1150`), which
now falls back to `0` when `parseConsensusHeaderStart` returns nil, with a
comment stating that a bare header denotes the contig origin rather than an
absent coordinate. `parseConsensusHeaderStart` itself
(`:1159-1166`) reads only the final colon-delimited field and requires a
numeric range, so a contig name containing colons cannot be misparsed. No
defect here.

## What I removed from the old chapter, and why

The old chapter was a three-surface tour of consensus plus a lineage guide.
The roster moves lineage assignment to the Viral Recon chapter and to Running
Freyja, and scopes this chapter to `bam.extract-consensus`, so most of the old
body had to go.

- The whole "three consensus surfaces" table and framing. The chapter now
  documents one surface, the Inspector's Consensus tab, and names the other
  two only where a reader needs the pointer.
- The entire Viral Recon procedure, the `Tools > Mapping > Mapping...` menu
  path in it, and the caller-row step. That path was wrong (DRIFT changed
  claim 12, corrected to `Tools > Mapping > Viral Recon`) and the caller-row
  step was one of the two unverifiable rows. Both are now the Viral Recon
  chapter's problem, which is committed and covers them.
- The consensus-threshold table with its 0.5, 0.75, 0.9 rows. Those values
  described a read allele-frequency threshold that this operation does not
  have. The Consensus tab's controls are a depth floor, two quality floors,
  and a mode picker, so the table would have taught the reader a control that
  is not on the screen.
- The Freyja `demix` section. It belongs to
  `06-classification/07-running-freyja.md` per the roster.
- The Pangolin and Nextclade interpretation section, the "What Lungfish does
  not do" section, and the two web-interface URLs. DRIFT changed claim 26
  because the boundary is not absolute, and the accurate version of that
  statement now sits in one sentence at the end of What it is, pointing at the
  Viral Recon chapter where the pipeline really does run both tools.
- The false claim 18 sentence about selection versus visible viewport. It is
  replaced by the `Consensus scope` picker throughout.
- The SARS-CoV-2 worked example. The campaign's example rule puts human data
  first, and the fixture is human.

## How each DRIFT unverifiable row was settled

The Part A section lists two unverifiable claims, both in the ground-truth map
at `ground-truth/05-variants.md:400-401`.

- Claim 13, "In the wizard's caller row, set `Variants` to your variant caller
  and set `Consensus` to `iVar` or `bcftools`." Settled by removal. The claim
  is about the Viral Recon wizard, which is no longer this chapter's subject.
  `docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md` is
  committed and documents that wizard's controls, so the claim is now owned by
  a chapter that verified it rather than left unresolved here.
- Claim 14, "Choose the executor and click to run." Settled the same way and
  for the same reason. It is a Viral Recon wizard step.

Neither row needed a GUI run, because neither statement survives into the
rewritten chapter. The planned shot `viralrecon-consensus-picker`, which DRIFT
marked "cannot judge" for the same reason, is dropped along with them.

## Shot markers

Three markers, three matching `shots` entries, and no leftovers from the old
`planned_shots` list.

| Marker | What it shows |
|---|---|
| `analysis-consensus-tab` | The Consensus tab with the full control set and the Extract Consensus... button below the divider |
| `consensus-masking-sliders` | The same tab with Hide high-gap sites on, revealing Gap threshold and Masking minimum depth |
| `consensus-destination-dialog` | The Extract Sequence dialog with its four destinations and the prefilled Name field |

The old `inspector-consensus-mode` shot is replaced by
`analysis-consensus-tab`, whose caption names the whole control set rather
than four of them, which is what DRIFT's screenshot table asked for. The old
`msa-consensus-cli` and `viralrecon-consensus-picker` planned shots are gone
with their sections. The `Tools > Mapping > Viral Recon` menu-path shot DRIFT
called for belongs to the Viral Recon chapter now.

## Glossary additions

Two entries, both in the existing shape, both alphabetised in place.

- **IUPAC ambiguity code** (`#iupac-ambiguity-code`), inserted before **iVar**
  in the I section. Needed because the `Use IUPAC ambiguity codes` setting is
  meaningless without it, and the chapter quotes real `R`, `Y`, `M`, `K`, `S`,
  and `W` counts from the fixture.
- **samtools** (`#samtools`), inserted between **Sample sheet** and **savONT**
  in the S section. Needed because the chapter names the tool that does the
  work, and no entry existed even though several committed chapters mention it.

Every other term in `glossary_refs` already existed. `consensus-fasta` and
`consensus-sequence` both existed and are both referenced, with
`consensus-sequence` doing the work in the body since this operation produces a
sequence from reads rather than a surveillance deposit.

## Possible defects found

One, and it is minor and documentation-adjacent rather than a code fault.

**The recorded command is not runnable.** The operation history records this
run as `Lungfish.app alignment consensus --scope <scope> --region <region>
--reference-fill never`
(`Sources/LungfishApp/Views/Viewer/ViewerViewController+Mapping.swift:134`).
That string looks like a command line and is not one. There is no
`lungfish-cli` subcommand for alignment consensus, so a reader who follows the
project's own "right-click the failed Operations row and re-run the command"
habit will find nothing to run. The `parameters.yaml` note already flags this,
and the chapter states plainly in On the command line that no CLI equivalent
exists. Worth a cartographer or lead decision on whether the recorded string
should read differently, but nothing in the chapter depends on it.

Two things I checked and found sound rather than defective.

- The bare `>chrom` header path, covered above.
- The all-N confirmation gate. `Consensus Contains Only N` fires before the
  destination dialog rather than after the file is written
  (`ViewerViewController+Mapping.swift:218-244`), which is the right order, and
  its message names the specific minimum depth that caused it.

Finally, `features.yaml` still has no entry for this operation, which
ground-truth claim 27 already flagged as a cartographer task. `features_refs`
stays empty and `parameters_refs` carries `bam.extract-consensus`.
