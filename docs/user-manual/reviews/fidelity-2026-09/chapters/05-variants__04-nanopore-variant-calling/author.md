# Author report, 05-variants/04-nanopore-variant-calling

Chapter 29 of the campaign roster. Registry ids `variants.call-medaka` and
`variants.call-clair3`. Fixture `hg002-long-reads` against the `human-mito`
reference.

Rewritten in place against Preview 2026.9.13. The CLI binary used as the
arbiter of truth is `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
which reports version `2026.9.13`.

## Runs made

All runs were made under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/nanopore-variants/`
against copies of the fixture files. Nothing was written into
`~/Desktop/lge-docs`.

### Import

`lungfish-cli import-fastq HG002.chrM.ont.fastq.gz --platform ont --project ONT.lungfish`
produced `ONT.lungfish/Imports/HG002.chrM.ont.lungfishfastq`, 1 sample,
single-end, 1.5 s.

`lungfish-cli import fasta NC_012920.1.fasta --name "Human mitochondrion rCRS" -o ONT.lungfish`
produced `Human_mitochondrion_rCRS.lungfishref`, 1 sequence, 16.6 kb.

### Mapping

A first attempt mapped the loose FASTQ directly and was refused:

```
Error: Workflow execution failed: Unable to detect a supported read class from the selected FASTQ inputs.
```

The read class is read off the imported bundle's metadata by
`MappingReadClass.detect(fromInputURL:)`, and the CLI exposes no
`--compatibility-read-class` override, so the FASTQ must be imported first.
That is now stated in the chapter's Before you start section.

Mapping the imported bundle succeeded:

```
lungfish-cli map ONT.lungfish/Imports/HG002.chrM.ont.lungfishfastq \
    --reference NC_012920.1.fasta --preset map-ont \
    --sample-name HG002-chrM-ONT -o mapping
```

The CLI's own run banner prints `Mode : Oxford Nanopore`, independently
confirming DRIFT row 7. Results: **1,210 total records, 1,210 mapped
(100.00%), 0 unmapped, runtime 1.7 s**. `samtools flagstat` on the adopted
BAM gives **950 primary, 0 secondary, 260 supplementary**. `samtools depth -a`
gives **mean depth 236.1 across all 16,569 positions, 0 positions under 10**.

The track was adopted with
`lungfish-cli bam adopt-mapping --track-id ont-minimap2`.

### Medaka, blocked twice

`lungfish-cli variants call --caller medaka --medaka-model r941_prom_sup_variant_g507`
against the adopted track failed at preflight:

```
Error: Medaka could not verify ONT/basecaller metadata in this BAM. Use a BAM that preserves ONT model information or choose a different caller.
Starting Medaka variant calling
Checking bundle and alignment inputs
Medaka could not verify ONT/basecaller metadata in this BAM. Use a BAM that preserves ONT model information or choose a different caller.
```

`BAMVariantCallingPreflight.validateMedakaHeaderIfNeeded` requires the model
string you typed to appear literally in the BAM header text or in a read
group's `DS`, `PU`, or `CN` field. LGE's own mapper writes no basecaller
model into the header, so no alignment LGE produced can pass. Verified by
re-mapping with `--rg-pu r941_prom_sup_variant_g507`, which does pass the
check, then failing at the next step:

```
Error: Variant caller execution failed: medaka: error: argument command: invalid choice: 'variant' (choose from compress_bam, features, train, inference, smolecule, tandem, consensus_from_features, fastrle, sequence, vcf, tools)
```

`medaka --help` from the managed environment confirms medaka 2.2.2, the
version the lock pins, has no `variant` subcommand. `ViralVariantCallingPipeline.medakaArguments`
still builds `medaka variant ...`. **No Medaka counts appear in the chapter,
because no Medaka run produced any.**

### Clair3, blocked once through LGE, run directly

`lungfish-cli variants call --caller clair3 --medaka-model <model dir>` got
past preflight, staged inputs, launched the tool, and stopped with:

```
/bin/sh: pypy3: command not found
[ERROR] pypy not found, please check you are in clair3 virtual environment
[ERROR] Current python execution path: /Users/dho/miniforge3/bin/python
```

`~/.lungfish/conda/envs/clair3/bin/pypy3` exists, so this is a PATH defect,
not a missing dependency. Adding `--extra-args "--include_all_ctgs"` did not
change it. The staged workspace is under `/var/folders/...` with no spaces,
so path whitespace is not the cause here.

Clair3 was then run directly from its managed environment with its own `bin`
on PATH, against the same adopted BAM and the same reference. A first direct
run against the in-bundle path failed differently, with a `samtools idxstats`
usage dump and `Contig name NC_012920.1 provided but no mapped reads in BAM`.
`CheckEnvs.py:73` builds that call with
`shlex.split("{} idxstats {}".format(samtools, bam_fn))`, which tears apart
any path containing a space, and the bundle path contains
`Reference Sequences`. Copying the BAM and reference to a space-free
directory fixed it and the run completed.

Counts from `bcftools` on the resulting `merge_output.vcf.gz`:

| Measure | Count |
| --- | --- |
| Total records | 44 |
| `PASS` | 27 |
| `LowQual` | 17 |
| SNVs | 18 |
| Indels | 26 |
| PASS genotype `1/1` | 23 |
| PASS genotype `0/1` | 4 |

The 14 PASS substitutions are at 263, 456, 750, 1438, 4336, 4769, 6800,
8557, 8860, 9028, 14229, 15175, 15326, 16304. Positions 263, 750, 1438,
4769, 8860, 15326 are the near-universal rCRS differences. 4336, 15175,
16304 are haplogroup markers. Position 9028 C>T is the one low-quality PASS
row, DP 239, AF 0.3054, QUAL 4.38, GT 0/1, and the chapter uses it as the
heteroplasmy-versus-noise example.

Every count in the chapter comes from this run. The chapter says plainly
that these numbers came from Clair3 run outside LGE, and why.

## What was removed from the old chapter, and why

- **The entire "A note on fixture status" section and the `ONT-SAMPLE-01`
  worked example.** The old chapter labelled itself aspirational and invented
  a SARS-CoV-2 ARTIC v3 run with no real data behind it. The
  `hg002-long-reads` fixture now exists, so the example is real and human,
  matching the campaign's human-first rule.
- **"The expected output ... is roughly 60 to 90 PASS variants."** Invented.
  Replaced with 27 PASS from a run actually made.
- **"tens to low hundreds of PASS rows" and "several thousand PASS rows"**
  as interpretation anchors. Both were guesses about a run nobody made.
- **The five-row Medaka model table.** It listed models by pore and
  basecaller from memory. Two of its five entries
  (`r1041_e82_400bps_sup_v4.2.0`, `r1041_e82_400bps_sup_v5.0.0`) are
  consensus models, wrong for variant calling, and the chapter recommended
  them for exactly that. Replaced with the instruction to ask
  `medaka tools list_models` and the rule that a variant model carries
  `variant` in its name.
- **The Dorado FASTQ header decoding section.** Its `zcat | head -n 1`
  example and its `model_version_id` translation rule were unverified against
  any file, and the fixture's own reads carry no such field. Replaced with
  the shorter and checkable instruction to read the model off the run report.
- **"Medaka, like iVar, reads the sidecar."** False, per DRIFT row 10 and
  confirmed in `BAMVariantCallingToolPanes.swift:95-112`.
- **The three-column dialog description.** False, per DRIFT row 11.
- **"depth comes from the shared Minimum Depth threshold."** False, per
  DRIFT row 16.
- **"a new variant track appears under Variants in the sidebar."** False,
  per DRIFT row 21.
- **`ARTIC-v3-SARS2`.** No such scheme ships. Corrected to
  `ARTIC-nCoV-2019-V3` per DRIFT row 24.
- **`Tools > FASTQ/FASTA Operations > Mapping…`.** Corrected to
  **Tools > Mapping > minimap2...** per DRIFT row 5.
- **`Map ONT (map-ont)` and `Short read (sr)`.** Corrected to
  **Oxford Nanopore** and **Short-read** per DRIFT rows 7 and 27.
- **The "Choosing between Medaka and Clair3" comparison table.** Its
  recommendations rested on claims about validated Clair3 models and viral
  consensus pipelines that nothing in the app supports. The real difference,
  that Medaka reads a rebuilt FASTQ while Clair3 reads the BAM, is now in
  the procedure where it changes what you do.
- **The `lungfish variants call` invocations.** The binary is
  `lungfish-cli`, and the old blocks used `lungfish`.

## DRIFT unverifiable rows

The DRIFT verdict line for this chapter reads "20 true, 7 false, 2 changed,
**0 unverifiable**", so there were no unverifiable rows to settle. Both
changed rows were settled by running the app rather than by reading source
alone. Row 13's shared-storage claim is confirmed in
`BAMVariantCallingToolPanes.swift:119` and `:129` and is now written as the
"switching callers keeps whatever you typed" warning, with the differing
labels `Medaka Model` and `Clair3 Model` both carried as their own Settings
paragraphs. Row 27's `Short-read` display name is confirmed by
`MappingTool.swift:206` and by the CLI banner.

## Missing features now covered

All eight DRIFT "missing" rows are in the chapter. The `Extra arguments` box
and its differing insertion point per caller, Clair3's `--output` and the
`merge_output.vcf.gz` readback, the `-t <threads>` default of the machine's
processor count, the `Readiness` line with both callers' exact messages, the
`samtools fastq -F 2304` filter and its effect on the fixture's 260
supplementary records, the pinned medaka 2.2.2 and clair3 2.0.2, and the
other bundled ONT primer schemes. The one row not carried as written is the
distinct FASTQ-reconstruction failure mode, because the Medaka path never
reaches it on this build, and describing an error nobody can currently see
would be worse than omitting it.

## Shot markers

Three, each with a frontmatter caption.

| id | Why |
| --- | --- |
| `tools-mapping-submenu` | The new shot DRIFT asked for, since claim 5 replaces a menu path this chapter and chapter 01 both had wrong. |
| `call-variants-dialog-medaka` | Reshoot per DRIFT. Caption rewritten for the two-column layout and the `Medaka Settings` section. |
| `medaka-model-field` | Kept. Caption extended to include the Readiness line, which is the control DRIFT listed as missing. |

The old `planned_shots` block is gone. All three are real `shots` entries
with matching `<!-- SHOT: id -->` markers.

## Glossary additions

Three terms, alphabetised, in the existing entry shape, all listed in
`glossary_refs`.

- **Haplogroup** `{#haplogroup}`, needed by the mitochondrial interpretation.
- **Homopolymer** `{#homopolymer}`, needed by the primer, which explains why
  a short-read caller misreads nanopore data.
- **Medaka** `{#medaka}`, which was referenced by three existing entries
  (`basecaller`, `duplex-read`, `clair3`) as a "See also" target but had no
  entry of its own.

## Possible app defects

Four, in descending severity. All four block or complicate the operation this
chapter documents.

1. **Medaka is unrunnable, because the pinned version has no `variant`
   subcommand.** `ViralVariantCallingPipeline.medakaArguments`
   (`:1306-1316`) builds `medaka variant -i ... -r ... -o ... -m ... -t ...`.
   Medaka 2.2.2, pinned at `third-party-tools-lock.json:38`, exposes only
   `compress_bam, features, train, inference, smolecule, tandem,
   consensus_from_features, fastrle, sequence, vcf, tools`. The `variant`
   wrapper was removed upstream in favour of `inference` plus `vcf`. Every
   Medaka run on this build fails.

2. **The Medaka preflight header check cannot be satisfied by LGE's own
   mapper.** `BAMVariantCallingPreflight.validateMedakaHeaderIfNeeded`
   (`:283-318`) requires the typed model string to appear in the BAM header.
   `ManagedMappingPipeline` writes `PL:ONT` but never a basecaller model, so
   the check rejects every alignment LGE produced. Confirmed by re-mapping
   with `--rg-pu <model>`, which passes. Users are told to "use a BAM that
   preserves ONT model information", which no LGE surface can create.

3. **Clair3 is launched without its own environment on PATH.**
   `run_clair3.sh` resolves `pypy3` and `python` through the ambient shell,
   so it finds the user's own installation (`/Users/dho/miniforge3/bin/python`
   here) and aborts with "pypy not found, please check you are in clair3
   virtual environment". `~/.lungfish/conda/envs/clair3/bin/pypy3` exists.
   Adding that directory to PATH makes the identical command work. This is
   the same class of defect recorded in memory as "never `/usr/bin/env
   <tool>` from the CLI".

4. **Clair3 cannot read a BAM whose path contains a space.** Clair3's own
   `preprocess/CheckEnvs.py:73` builds
   `shlex.split("{} idxstats {}".format(samtools, bam_fn))` with no quoting.
   Bundle alignments live under `Reference Sequences/`, so every in-project
   path hits this. The symptom is misleading, a `samtools idxstats` usage
   dump followed by "no mapped reads in BAM" and a header-only VCF, so it
   reads as an empty result rather than a path error. This is upstream code,
   but LGE must stage Clair3's inputs to a space-free directory the way it
   already learned to for QUAST under Viral Recon. Note that LGE stages the
   reference into its workspace but passes the bundle's own BAM path
   through, which is what exposes the bug.

A fifth, milder observation. `lungfish-cli map` refuses a loose FASTQ with
"Unable to detect a supported read class", and offers no flag to override,
while the GUI wizard has a compatibility override. The message does not tell
the reader that importing first is the fix. Documented as a workaround
rather than filed as a defect.
