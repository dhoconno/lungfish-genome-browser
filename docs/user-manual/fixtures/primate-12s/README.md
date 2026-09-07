# Primate 12S amplicon fixture

A five-species primate 12S reference and a matching human amplicon read set,
supporting the 12S Amplicon Metabarcoding chapter
(`docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md`).

This is a constructed teaching fixture, not a published 12S dataset. Nothing
here was downloaded from a metabarcoding study. Every base comes from two
fixtures already in this directory, cut down to the 12S locus so the chapter's
figures come from real primate mitochondrial sequence and real HG002 reads
rather than from invented numbers.

## Why it is constructed

There is no published 12S amplicon dataset in this repository and none in the
manual's demo project. Rather than write the chapter with no figures, the
fixture was built from material the manual already ships. The trade-off is
worth stating plainly. A reader following the chapter gets a run whose numbers
they can reproduce exactly, but the read set is a selection out of a
whole-mitochondrion library rather than a real amplicon library off a
sequencer, and the reference holds five primates rather than the thousands of
vertebrates a working MIDORI reference would carry.

## How it was constructed

Both source fixtures are read only. Neither is modified.

**The reference.** `build_ref.py` reads
`../primate-mito/primate-mito.fasta`, the five primate mitochondrial genomes.
Human MT-RNR1, the 12S rRNA gene, is `NC_012920.1:648-1601`. The script cuts a
60-base slice from inside that gene, starting at offset 900 of the human
genome, and finds the homologous slice in each of the other four genomes by
anchoring on the conserved 18-base flank at the slice's 5' end. Anchor
identity came out 18 of 18 for human and gorilla, 17 of 18 for chimpanzee, and
16 of 18 for both macaques. All five slices are distinct, so nothing collapsed
during deduplication and the reference carries five targets.

Sixty bases is short on purpose. The matcher requires flanking read bases on
both sides of the matched target, so a target has to be short enough that a
250-base read can contain it whole and still have bases left over at each end.

Headers are written in the `Common name (Scientific name)` form. The metadata
joiner parses the species out of the FASTA header, so an underscored header
joins nothing and leaves every metadata column empty.

**The reads.** `make_amplicon.py` reads
`../human-mito/HG002.chrM_R1.fastq.gz`, 9,958 Illumina reads of 250 bases from
the human mitochondrion. It keeps the reads that overlap the human 12S locus,
deciding overlap by an exact 24-base seed shared with `NC_012920.1:648-1601`
in either orientation. 631 of the 9,958 reads are kept, which makes the
selection behave like a 12S amplicon library rather than whole-mitochondrion
shotgun.

**Orientation.** `regenerate.sh` then runs `lungfish-cli fastq orient` over
those 631 reads against the reference. The 12S matcher has no
reverse-complement pass, so reverse-strand reads go unmatched until this step
flips them. 173 of the 631 reads survive orientation. That drop is the point
of the step and the chapter says so.

## Species

| Reference header | Scientific name | NCBI taxid | Source genome |
| --- | --- | --- | --- |
| `Human (Homo sapiens)` | *Homo sapiens* | 9606 | `NC_012920.1` |
| `Chimpanzee (Pan troglodytes)` | *Pan troglodytes* | 9598 | `NC_001643.1` |
| `Western gorilla (Gorilla gorilla)` | *Gorilla gorilla* | 9593 | `NC_011120.1` |
| `Rhesus macaque (Macaca mulatta)` | *Macaca mulatta* | 9544 | `NC_005943.1` |
| `Cynomolgus macaque (Macaca fascicularis)` | *Macaca fascicularis* | 9541 | `NC_012670.1` |

Each target is 60 bases. The taxids were taken from NCBI Taxonomy and are
carried in `primate-12s-midori.tsv` with `name_source` set to `NCBI`.

## Read counts

| Stage | Reads |
| --- | --- |
| `../human-mito/HG002.chrM_R1.fastq.gz` (input) | 9,958 |
| `HG002-12S-amplicon.fastq.gz` (overlap the 12S locus) | 631 |
| `HG002-12S-oriented.fastq` (after orientation) | 173 |

Both read files are committed. The chapter uses the amplicon file to show what
an unoriented run looks like and the oriented file for the run it quotes
throughout.

## Sources, license, and citation

This fixture inherits its sources and its license from the two fixtures it is
cut from. See `../primate-mito/README.md` and `../human-mito/README.md` for
the full source records, the accession verification, and the citation blocks.

The reference genomes are RefSeq organelle records, fetched via NCBI eutils
efetch by `../primate-mito/fetch.sh`. The reads are HG002/NA24385 (Ashkenazim
son) NIST/GIAB Illumina 2x250bp data, sliced to `chrM` and downsampled by
`../human-mito/fetch.sh`.

Both source sets are US government works and are in the public domain in the
United States, so the cut-down material here carries no additional
restriction. Check your local jurisdiction if redistributing outside the U.S.

Cite the underlying resources rather than this fixture. The RefSeq citation is
in `../primate-mito/README.md`. The rCRS and GIAB citations are in
`../human-mito/README.md`.

## Committed files

| File | Size |
| --- | --- |
| `primate-12s-dedup.fasta` | <1 KB (467 bytes) |
| `primate-12s-midori.tsv` | <1 KB (590 bytes) |
| `primate-12s-targets.tsv` | 1.4 KB |
| `HG002-12S-amplicon.fastq.gz` | 67 KB |
| `HG002-12S-oriented.fastq` | 91 KB |
| `build_ref.py` | 3.3 KB |
| `make_amplicon.py` | 2.1 KB |
| `regenerate.sh` | 2.1 KB |

Total committed is 244 KB, far under the 50 MB fixture-set cap, and every file
is far under the 10 MB per-file cap.

The `.lungfish12sref` bundle is deliberately not committed. The workflow
dialog's **Create 12S Reference...** button builds that bundle from the
deduplicated FASTA and the metadata TSV, which is the route the chapter walks
the reader through, so the two loose files are both the smaller form and the
form the procedure actually needs. `lungfish-cli fastq 12s-match` accepts
either the loose FASTA or a bundle at `--reference`.

Provenance sidecars (`*.lungfish-provenance.json`) are written beside the CLI
outputs and are gitignored, matching the sibling fixtures.

## Result

Running `lungfish-cli fastq 12s-match` over `HG002-12S-oriented.fastq` against
this reference on 2026-09-07 gave 173 reads in, 110 exact matches, and 63
unresolved, an exact match rate of 63.58 percent. `sample-target-counts.tsv`
put all 110 reads on *Homo sapiens* and zero on each of the other four
species. This is the run the chapter quotes throughout.

## Internal consistency

The result is biologically correct in a way that makes the fixture
self-checking. The reads are human, and the only species that takes any reads
is human. The chimpanzee, gorilla, and two macaque targets sit at zero even
though they differ from the human target by only a handful of bases across the
60-base window, which confirms that the matcher is doing exact containment
rather than approximate matching, and that the reference targets really are
distinct from one another.

The 63 unresolved reads are genuinely unresolved rather than a defect. They
fall in the 12S locus but do not contain any reference target whole with
flanking bases on both sides, which is what the chapter's discussion of
unresolved clusters is about.

## Regenerating

```bash
bash docs/user-manual/fixtures/primate-12s/regenerate.sh
```

Nothing is fetched from the network. The script rebuilds every committed
artifact from `../primate-mito/primate-mito.fasta` and
`../human-mito/HG002.chrM_R1.fastq.gz`, so both sibling fixtures must be
present first. It needs `python3` (standard library only) and a built
`lungfish-cli` (`.build/debug/lungfish-cli`) with the managed vsearch
environment installed for the orientation step.

Regeneration was verified on 2026-09-07. Running the script over a wiped
directory reproduced all five artifacts byte for byte, matching both the
previous run and the author's original scratchpad build. The gzip output is
written with a zeroed timestamp so even the compressed read file is stable
across runs.

## A note on `--compress`

`regenerate.sh` writes the oriented reads to a plain `.fastq` name rather than
asking for `--compress` and a `.gz` name. `lungfish-cli fastq orient` writes
plain text regardless of that flag, so requesting compression produces a file
whose name claims gzip and whose contents are not. Writing the plain name
keeps the committed file honest.
