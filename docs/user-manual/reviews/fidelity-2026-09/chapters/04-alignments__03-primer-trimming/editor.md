# Editor pass, 04-alignments/03-primer-trimming

Date: 2026-09-07
Role: brand-copy-editor

A previous editor on this chapter was interrupted part way through and left no
report. I read the chapter as it now stands and checked every fidelity row and
every reader row against it rather than assuming anything had been done. Eight
of the thirteen consensus reader rows were already applied by that editor and
are recorded below under "Already applied before this pass" so the record is
complete.

## Changes applied

### From the fidelity review

- **Fidelity row 56 (the one false row), ruling 1.** "pick the References tab"
  became "pick the Reference Sequences tab". `ImportCenterViewModel.swift:179`
  returns "Reference Sequences" as the tab's visible title, and that string is
  what the segmented control draws.
- **Fidelity row 52 (the one unverifiable row), ruling 2.** "`--format json`
  prints one JSON object per line instead of the plain progress messages" became
  "`--format json` prints the run summary as JSON instead of as plain text",
  which is the registry's own wording at `parameters.yaml:2897` and makes no
  claim about stream shape. A gloss of JSON follows in the same sentence, which
  also closes reader row 21.
- **Fidelity row 41 (soft note), ruling 3.** The provenance paragraph claimed one
  surface for facts that live on two. It now opens "The record of the run is
  split across two Inspector surfaces", puts the three steps and the SHA-256
  checksums in the **Provenance** section, and puts the scheme name and version,
  the canonical accession, and the iVar version in the alignment section's
  **Primer-trim Derivation** group. Group name verified at
  `ReadStyleSection.swift:1083`.
- **Fidelity row 38 (soft note), ruling 3.** The chapter said "Those four lines"
  of a five-line summary. It now says "Those lines", and a new passage quotes
  iVar's fifth line, "77.97% (133607) of reads had their insert size smaller than
  their read length", and says what it counts. The line carries information a
  reader would use, since it signals read-through into the opposite adapter and
  is expected on a short-amplicon library, so ruling 3's first branch applies
  rather than the "say the summary has five lines" fallback.

### From the reader synthesis, rows hit by three or more readers

- **Index is unglossed, no remedy (rows 1, 2, 3, 4).** "An eligible track is one
  stored as an indexed BAM" now carries a gloss of index as a companion file the
  mapping step writes automatically beside the BAM, and a remedy sentence saying
  to run the mapping again rather than hunt for the index.
- **Advanced Options as a real recommendation (rows 1, 2, 3, 4).** Step 3 now
  states plainly that the defaults suit a standard run and that most readers
  never open the disclosure at all.
- **No way to match a kit to one of the eight schemes (rows 1, 2, 3, 4).** Step 4
  now says to read the scheme name off the kit box or the wet-lab protocol sheet.
- **Inspector section holding the soft-clip toggle unnamed (rows 1, 2, 3, 4).**
  "the Inspector's read display controls" became "the Inspector's **View
  Settings** section, on its **Reads** tab". Verified at `InspectorView.swift:247`
  for the section title and `ReadStyleSection.swift:1006-1022` for the subsection
  tab label, with the toggle itself at `ReadStyleSection.swift:1976`.
- **Dense before-and-after numbers that do not visibly reconcile (rows 1, 2, 3,
  4).** The four counts and the two percentages moved into a three-row table, and
  a new passage accounts for the gap. Clipped bases rose by roughly 6.6 million
  while matched bases fell by roughly 8.1 million, and the difference is the
  matched bases carried out of the file by reads discarded under the minimum
  length. All six figures are unchanged from the verified originals.
- **Two accessions for one genome (rows 1, 2, 3, 4).** A clause now says duplicate
  deposits are ordinary rather than an error, that one accession usually comes
  from the submitting group and the other from a curated reference collection,
  and that either is valid.
- **The `aln_` identifier and the app (rows 1, 2, 3, 4).** The chapter now states
  that the identifier is not shown anywhere in the app, so `manifest.json` is the
  only place to read it, and points at `lungfish-cli bundle list --tracks`.
  Verified negatively by searching the Inspector views for any raw track-id
  render (only an annotation track id is drawn, at
  `ReadStyleSection.swift:2388`), and positively against
  `cli-help/bundle.txt:241-257`.
- **The `-e` flag in the log (rows 1, 2, 3).** A sentence now says the flag keeps
  the primerless reads and that LGE always passes it, so it is not a reader
  choice. Placed after the fourth line's explanation so the enumeration of the
  four lines is not interrupted.
- **Phred 20 to Phred 30 (rows 1, 2, 4).** The Minimum quality entry now gives one
  wrong base in a thousand as the second data point.
- **Primer offset symptom (rows 1, 2, 4).** The Primer offset entry now names the
  symptom, a low trim rate from a scheme you otherwise trust, and says why
  displaced coordinates produce it.
- **Sliding window unpicturable (rows 1, 2, 4).** The Sliding window width entry
  now describes the frame starting at the read's end and sliding inward one base
  at a time, and says iVar cuts where the average inside the frame first falls
  below the minimum.

### From the reader synthesis, rows hit by two readers whose fix is a sentence

- **Checksum with no reason to care (rows 2, 3).** A sentence now says a checksum
  is computed from the file's contents, so comparing it later proves the file you
  have is the file the run used.
- **No trim-rate threshold (rows 1, 4).** "What good looks like" now says a
  well-matched scheme should reach the high nineties and that anything below
  about 90% is a reason to stop and check the scheme. Framed as a reading rule
  against the two measured runs (99.15% correct, 22.13% wrong) rather than
  presented as a figure any source states.
- **Trim rate or soft-clip percentage as the real check (rows 2, 4).** The section
  now states plainly that the trim rate is the check and the base percentage only
  corroborates it.
- **Import Center steps read as terminal-only (rows 3, 4).** See "Left unchanged"
  below. The requested move is structural. In its place, a signpost sentence now
  opens that passage, "The rest of this section is not terminal-only", and says
  the scheme is built in the app whether or not you use the command line.

### Already applied before this pass

Verified present and correct, so no edit was needed. Read-level versus
alignment-level in the opening sentence, the gloss of manifest, the `150M` to
`22S128M` CIGAR example, the explanation of a deliberate primer mismatch, the
typical read-pair range with the pairs-times-two reconciliation, the 90% mapping
rate floor, iVar named as a toolkit holding both a trimmer and a variant caller,
the six Analysis tabs named, and the plugin-pack install paragraph with the
network requirement.

## Left unchanged, and why

- **Reader row 24, moving the Import Center steps out of the command-line
  section into their own heading.** This is a section-order change. Ruling 4
  forbids changing section order, and the brand-copy-editor persona forbids
  structural editing outright and routes such a concern back to the
  Documentation Lead. I applied the sentence-level signpost instead. **For the
  project manager to rule on.** If the move is wanted, it needs the Documentation
  Lead or the chapter author, not this role.
- **No settings paragraph added or removed.** All seven remain in order with
  their bold labels verbatim. Three of them gained a clause inside the existing
  three-sentence shape, which ruling 4 permits.
- **The fidelity review's glossary caveat on the Primer scheme entry.** The note
  observes that `GLOSSARY.md` says the scheme's FASTA is optional without saying
  none of the bundled schemes carries one. Ruling 4 forbids touching
  `GLOSSARY.md`, and the persona forbids editing glossary entries. The chapter
  itself already states the fact at its own last line. Left for whoever owns the
  glossary.
- **The estimated_reading_min of 22.** The chapter grew by roughly a page. I did
  not adjust the figure because no ruling covers it and the frontmatter value is
  the author's. **Worth a glance from the project manager.**
- **The two confirmed defect claims in the fidelity review** (a wrong scheme
  trims silently at exit 0, and the scheme picker shows nothing beyond the
  display name). These are product defects, not chapter defects. The chapter
  already tells the reader that a wrong scheme is silent and that the trim rate
  is the only check, which is the correct documentation response.

## Lint

Command:

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/04-alignments/03-primer-trimming.md

Output, verbatim:

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/04-alignments/03-primer-trimming.md: no issues found

The chapter was lint-green before this pass and is lint-green after it. No
intermediate run reported an issue, so nothing needed fixing and rerunning.

## Status

brand_reviewed: true
