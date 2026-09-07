# Editor pass: 01-foundations/01-what-is-a-genome

Date: 2026-09-06
Editor: brand-copy-editor
Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh` prints "no issues found".

## Fidelity (3 changes)

- Reading the results, Provenance paragraph: replaced "holding the accession, the source, the date, and a SHA-256 checksum" with the reviewer's corrected wording, "holding the file it was built from, the date of the run, and a SHA-256 checksum for every file the import read and wrote" (fidelity row 24, false, no accession field exists for a local-file import).
- Reading the results, coordinate paragraph: replaced the false refusal claim with the reviewer's corrected wording, so the refusal is now attributed to an out-of-range position with the quoted message "Position is outside the sequence bounds", the chromosome-name mapping is described as a fallback, and an unmatched name is said to move to the position on the sequence already open rather than warning (fidelity row 28, false). Split into its own paragraph for length.
- Reading a variant, closing paragraph: replaced "the variants table always shows the contig name in its first column" with the reviewer's corrected wording, "the variants table always carries the contig in its Chrom column", and named it as the third column (fidelity row 34, false).

## Readers (multi-reader rows, 4 or 3 readers)

- What it is: glossed well-characterised as sequenced deeply and checked by independent groups (4 readers).
- What it is: defined inclusive by saying both the start base and the end base of a range are counted (4 readers).
- What it is: added a sample definition and a scale for reads, 150 bases and tens of millions per run (3 readers).
- What it is: split the packed accession sentence and the packed 1-based sentence, each into two (3 readers).
- Why you would do this: moved the RefSeqGene definition ahead of the term (4 readers).
- Why you would do this: added the clause explaining why the beta-globin cluster is filed in one record (4 readers).
- Why you would do this: glossed the join notation, join lists the stitched pieces and the two dots mark a range (4 readers).
- Why you would do this: explained mature as the protein after the initiator methionine is removed, and tied it to CDS codon 7 (4 readers).
- Why you would do this: added a two-line code block laying positions 70613, 70614, 70615 under the bases G, A, G (3 readers).
- Before you start: opened with the two CONSISTENCY.md fixed sentences, which supply project creation (4 readers).
- Before you start: glossed fixture as a small fixed example dataset and gave its GitHub location (4 readers).
- Before you start: removed the unrendered `{{ fixtures_refs[] | cite }}` placeholder and pointed at the README beside the file (4 readers).
- Procedure step 1: said the tabs run across the top and that the shortcut equals the menu choice (3 readers, plus the 1-reader shortcut row).
- Procedure step 2: said the import finishes in about a second and the reference appearing in the sidebar is the end state (4 readers), and said to drag the file from the folder it was saved in (1 reader, one sentence).
- Procedure step 3: said the bundle appears as `NG_000007.3`, verified against the name derivation in `Sources/LungfishIO/Bundles/ReferenceSequenceFolder.swift` (3 readers).
- Procedure step 4: flagged the dropped `.3` at the moment of typing and gave the LOCUS-line reason (4 readers).
- Procedure step 5: said the ruler is the numbered strip across the top of the viewport with the field at its left end (4 readers).
- Reading the results: glossed chromosome-name mapping as the table matching equivalent spellings such as `chr11` and `11` (4 readers). Fact unchanged, explanation added, since fidelity confirmed the mapping half true.
- Reading the results: gave a frame for 102 features, a hundred or so is expected and single digits signals a lost feature table (4 readers).
- Reading the results: named both indexes, `.fai` and `.gzi`, and said what each maps (3 readers).
- Reading a variant: split REF and ALT into separate sentences and named VCF as a file format that uses them as column headings (4 readers).
- Reading a variant: spelled out the deletion case with the worked pair `A>ACGT` and `ACGT>A` and the shared anchor base (4 readers).
- Sample data and reference data: said some low-coverage stretches are expected in any run (4 readers).
- Sample data and reference data: explained a quality score and its scale, 20, 30, and 40 (3 readers).
- Sample data and reference data: said what pinning the version looks like, writing the accession with its version in the methods section (3 readers).
- Linear, circular, and segmented genomes: named the split-read problem again and glossed plasmid (4 readers).
- What good looks like: named the Inspector as the place the length appears (3 readers).
- Why reference choice matters: glossed assembly and reframed GRCh38 and GRCh37 as an assembly and its earlier release (3 readers).
- On the command line: said the section is optional for readers who stay in the window (4 readers).
- On the command line: replaced the repo-relative fixture path with `~/Downloads/NG_000007.3.gb`, matching where Before you start tells the reader to save it (4 readers).

## Readers (single-reader rows fixed in one sentence)

- What it is: said the fragments come from random positions along the sequence.
- What it is: named GenBank at the National Center for Biotechnology Information as the database.
- What it is: said the `NG_` prefix does encode a record type, a curated genomic region rather than a whole chromosome.
- What it is: replaced the idioms "runs on", "hand you", and "Take the map away" with plain wording.
- What it is: named the What good looks like section as the one holding the checkpoint coordinate.
- Why you would do this: used the word intron once, in place of the periphrasis.
- Why you would do this: added the single-copy case, sickle cell trait and usually healthy.
- Why you would do this: gave a scale for 81,706 bases, roughly a thousandth of chromosome 11.
- Reading the results: said the bundle behaves like a single file until you ask otherwise, via Show Package Contents.
- Reading the results: said what a checksum mismatch means, a different or damaged copy.
- Reading the results: explained the gene-to-mRNA gap, three of the eight are pseudogenes.
- Reading the results: quoted the message the reader would see, "Position is outside the sequence bounds", folded into the fidelity row 28 rewrite.
- Reading a variant: said the variants table is the Variants tab of the table drawer and that the variant calling chapters cover it.
- Sample data and reference data: glossed read extraction and region extraction and deferred both to later chapters.
- Sample data and reference data: replaced the figurative "stillness" and "teaches as it organises" with plain statements.
- Linear, circular, and segmented genomes: put the mechanical reason before the indistinguishability claim.
- Linear, circular, and segmented genomes: said a circular reference changes no step in this chapter.
- What good looks like: said how to tell a bare FASTA from a GenBank flatfile, `>` headers versus a `LOCUS` line and FEATURES table.
- What good looks like: said what would make the codon check fail, the wrong record or wrong version.
- Why reference choice matters: said plainly that LGE does not convert coordinates between assemblies.
- On the command line: moved the "import fasta accepts GenBank" caveat ahead of the code block.
- On the command line: said the command creates the project directory if absent, verified at `Sources/LungfishCLI/Commands/ImportCommand.swift:543-545`, and that `.lungfish` and `.lungfishref` differ.

## Consistency (2 changes)

- Before you start now opens with the two CONSISTENCY.md fixed sentences, adjusted to the HBB gene record and `NG_000007.3.gb`, with the GitHub fixtures path for `hbb-gene`.
- Fixture named as "the HBB gene record" throughout, matching the CONSISTENCY.md fixture-name list.

## Template and parameters (2 changes)

- Frontmatter `parameters_refs` set to `[import.reference]`, which the fidelity review flagged as missing.
- Added a `## Settings` section between Procedure and Reading the results, the template's position, in one paragraph. It states that the Reference Sequences card has no settings, that it opens a file panel and imports the chosen file, and gives the command-line equivalent with `--name` and `-o`, matching the `settings: []`, `cli_only`, and notes under `import.reference` in `parameters.yaml`.

## Style (13 changes)

- "Every organism runs on an instruction set" to "carries an instruction set" (idiom, plain voice).
- "The example that runs through this chapter is" to "This chapter works through" (idiom).
- Split the well-characterised sentence into two (sentence length).
- Split the beta-globin cluster sentence into two (sentence length).
- "the intervening non-coding stretches you met in class as introns" to "intervening non-coding stretches called introns" (drops an assumption about the reader, keeps the term).
- Split the quality-score sentence into two (sentence length).
- Split the bare-FASTA check into three sentences (sentence length).
- Split the GRCh38 sentence into two (sentence length).
- Split the `--output-dir` sentence into two (sentence length).
- Split the two-indexes sentence into two (sentence length).
- Split the variants-table sentence into two (sentence length, 41 words).
- Split the FASTQ-and-BAM sentence into two (sentence length, 43 words).
- "The habit that saves the most grief is simple" to "One habit prevents most of this trouble", "hands you" to "gives you", and "A reference is what you hold it up against" to "the fixed sequence you compare it against" (calmer voice, idiom). Replaced "navigates" with "moves to the position", the one AI-tell the linter caught in new prose.

## Left unchanged, with reasons

- `brand_reviewed` and `lead_approved` stay `false`. The campaign task did not ask for the flip, and `lead_approved` is never mine.
- Every fidelity row marked true is untouched as fact. Where a reader was confused by a true fact, explanation was added instead. This applies to the mature-protein numbering, the dropped accession version, the chromosome-name mapping, and the `NG_000007` contig name.
- The mature-protein wording keeps "the sixth amino acid of the mature beta-globin protein". The fidelity review warns that rewriting it as "codon 6 of the CDS" would make it wrong.
- Chapter structure, section order, and the shot and illustration markers are unchanged, apart from inserting the Settings section the template requires.
- The reader row on the `{{ fixtures_refs[] | cite }}` placeholder was resolved by removal rather than by rendering, because the build filter is not wired up and the CONSISTENCY.md fixed sentences already give the reader the file's location.
