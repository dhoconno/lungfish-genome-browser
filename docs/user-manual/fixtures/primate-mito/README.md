# Primate mitochondrial genome set fixture

Five primate mitochondrial reference genomes (RefSeq), used unaligned as
input to the alignment chapter and, aligned, as input to the tree chapter.
Human is included so the set doubles as the human entry in the primate
reference collection alongside `docs/user-manual/fixtures/human-mito/`.

## Genomes

| Label | Accession | Species | Length (bp) |
| --- | --- | --- | --- |
| `Human_NC_012920.1` | `NC_012920.1` | *Homo sapiens* | 16,569 |
| `Chimp_NC_001643.1` | `NC_001643.1` | *Pan troglodytes* | 16,554 |
| `Gorilla_NC_011120.1` | `NC_011120.1` | *Gorilla gorilla gorilla* | 16,412 |
| `RhesusMacaque_NC_005943.1` | `NC_005943.1` | *Macaca mulatta* | 16,564 |
| `CynomolgusMacaque_NC_012670.1` | `NC_012670.1` | *Macaca fascicularis* | 16,575 |

Each header in `primate-mito.fasta` is rewritten from the raw NCBI defline
to `<Label>_<accession>` so alignment columns and tree tips read well
without a separate relabel step.

## Accession verification

All five accessions were checked against NCBI esummary
(`db=nuccore`) on 2026-09-06 before fetching, per the campaign brief. Every
accession resolved to the expected species at the expected length; **no
substitutions were needed**:

```
NC_012920.1 Homo sapiens mitochondrion, complete genome 16569
NC_001643.1 Pan troglodytes mitochondrion, complete genome 16554
NC_011120.1 Gorilla gorilla gorilla mitochondrion, complete genome 16412
NC_005943.1 Macaca mulatta mitochondrion, complete genome 16564
NC_012670.1 Macaca fascicularis mitochondrion, complete genome 16575
```

(One esummary call hit NCBI's public rate limit transiently and was
retried a few seconds later; retrying is a routine part of the eutils
workflow, not an accession problem.)

## Sources

Each record was fetched via NCBI eutils efetch, e.g. for the human record:

```
https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_012920.1&rettype=fasta&retmode=text
```

(substitute each accession above). All five are RefSeq organelle genome
records, part of the NCBI Reference Sequence (RefSeq) collection.

## License and citation

RefSeq records are produced by NCBI, a US government agency, and are in
the public domain in the United States; check your local jurisdiction if
redistributing outside the U.S.

Cite the RefSeq resource:

```bibtex
@article{oleary2016refseq,
  author  = {O'Leary, Nuala A. and Wright, Mathew W. and Brister, J. Rodney
             and Ciufo, Stacy and Haddad, Diana and McVeigh, Rich
             and Rajput, Bhanu and Robbertse, Barbara and Smith-White,
             Brian and Ako-Adjei, Danso and Astashyn, Alexander
             and Badretdin, Azat and Bao, Yiming and Blinkova, Olga
             and Brover, Vyacheslav and Chetvernin, Vyacheslav
             and Choi, Jinna and Cox, Eric and Ermolaeva, Olga
             and Farrell, Catherine M. and Goldfarb, Tamara
             and Gupta, Tripti and Haft, Daniel and Hatcher, Eneida
             and Hlavina, Wratko and Joardar, Vinita S. and Kodali,
             Vamsi K. and Li, Wenjun and Maglott, Donna
             and Masterson, Patrick and McGarvey, Kelly M.
             and Murphy, Michael R. and O'Neill, Kathleen
             and Pujar, Shashikant and Rangwala, Sanjida H.
             and Rausch, Daniel and Riddick, Lillian D.
             and Schoch, Conrad and Shkeda, Andrei
             and Storz, Susan S. and Sun, Hanzhen and Thibaud-Nissen,
             Francoise and Tolstoy, Igor and Tully, Raymond E.
             and Vatsan, Anjana R. and Wallin, Craig
             and Webb, David and Wu, Wendy and Landrum, Melissa J.
             and Kimchi, Avi and Tatusova, Tatiana and DiCuccio,
             Michael and Kitts, Paul and Murphy, Terence D.
             and Pruitt, Kim D.},
  title   = {Reference sequence (RefSeq) database at NCBI: current status,
             taxonomic expansion, and functional annotation},
  journal = {Nucleic Acids Research},
  year    = {2016},
  volume  = {44},
  number  = {D1},
  pages   = {D733--D745},
  doi     = {10.1093/nar/gkv1189}
}
```

## Committed files

| File | Size |
| --- | --- |
| `primate-mito.fasta` | 82 KB |
| `expected/primate-mito.aligned.fasta` | 84 KB |
| `expected/primate-mito.treefile` | <1 KB (210 bytes) |

Total committed: ~166 KB, well under the 50 MB fixture-set cap; every file
is under the 10 MB per-file cap. `expected/tmp-project.lungfish/` (the
scratch Lungfish project `regenerate.sh` builds the MSA and tree bundles
in) is gitignored and reproducible.

## Alignment result

`regenerate.sh` runs `lungfish-cli align mafft --strategy auto` over the
five unaligned genomes. Observed on 2026-09-06: **5 rows, 17,247 aligned
columns**. The aligned FASTA is copied from the bundle's
`alignment/primary.aligned.fasta` to `expected/primate-mito.aligned.fasta`.

## Tree result

`regenerate.sh` then runs `lungfish-cli tree infer iqtree` (default model
`MFP`, i.e. IQ-TREE's ModelFinder Plus) over that alignment bundle.
Observed on 2026-09-06: a single unrooted tree with **5 tips** and 3
internal nodes:

```
(Human_NC_012920.1:0.0601,Chimp_NC_001643.1:0.0589,(Gorilla_NC_011120.1:0.0740,(RhesusMacaque_NC_005943.1:0.0650,CynomolgusMacaque_NC_012670.1:0.0299):0.8982):0.0296);
```

(branch lengths rounded to 4 places above; see
`expected/primate-mito.treefile` for full precision). The topology groups
Human and Chimp together and the two macaques together at the tips, which
matches the well-established primate phylogeny; IQ-TREE writes an
unrooted tree so the three-way split at the root (Human, Chimp, and the
Gorilla+macaque clade) does not imply a rooting and is not itself a
finding. The tree file is copied from the bundle's canonical
`tree/primary.nwk` (identical to `artifacts/iqtree/run.treefile`, per
`manifest.json`'s `primaryTreeID`/`sourceFileName`) to
`expected/primate-mito.treefile`.

## Internal consistency

The tree's five tip labels are exactly the five headers written by
`fetch.sh` (`Human_NC_012920.1`, `Chimp_NC_001643.1`,
`Gorilla_NC_011120.1`, `RhesusMacaque_NC_005943.1`,
`CynomolgusMacaque_NC_012670.1`), confirming the alignment and tree steps
round-trip every input record with no drops, renames, or duplicates.
Because MAFFT progressive alignment and IQ-TREE's numerical optimizer are
not bit-for-bit deterministic across runs on this machine, re-running
`regenerate.sh` reproduces the same alignment length (17,247 columns) and
tree topology/tip set, but branch lengths can differ in the 6th-7th
decimal place between runs; that is expected and not a fixture defect.

## `--project` gotcha

The brief's sketch used a scratch directory named plain `tmp-project`, but
`lungfish-cli`'s `--project` flag requires a directory whose path carries
a literal `.lungfish` extension (`LungfishIO`'s
`ProjectTempDirectory.findProjectRoot` walks up the directory tree looking
for that extension) -- a plain `tmp-project` directory is rejected with
`Project context required but no .lungfish root found`. `regenerate.sh`
therefore uses `expected/tmp-project.lungfish` instead; it is still
gitignored and still scratch.

## Regenerating

```bash
bash docs/user-manual/fixtures/primate-mito/fetch.sh       # rebuilds primate-mito.fasta from NCBI
bash docs/user-manual/fixtures/primate-mito/regenerate.sh  # rebuilds expected/primate-mito.{aligned.fasta,treefile}
```

`fetch.sh` needs only `curl`. `regenerate.sh` needs a built `lungfish-cli`
(`.build/debug/lungfish-cli`) with the managed MAFFT and IQ-TREE packs
installed (`~/.lungfish/conda/envs/mafft`, `~/.lungfish/conda/envs/iqtree`).
