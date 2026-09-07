# Editor pass: 06-human-germline-variants/04-reference-packs

Date: 2026-09-07
Chapter: `docs/user-manual/chapters/06-human-germline-variants/04-reference-packs.md`
Lint: `LUNGFISH_MANUAL_STRICT=1` reports "no issues found".

This pass was completed from an interrupted earlier pass. That editor wrote
no `editor.md` and was cut off inside the On the command line section. The
chapter on disk was their partial result, so everything below is recorded in
two columns of responsibility, applied by the earlier pass or applied by me.
Where I confirmed rather than changed something, I say so, because the brief
asks for confirmation of each row and not only for new edits.

## Fidelity rows

### The three false rows

All three were already applied by the earlier pass. I re-read each against
`fidelity.md` and confirmed the corrected wording is present and accurate.

- **The `.fai` overstatement.** Line 41 now carries the narrower claim. LGE
  never builds either companion for a loose FASTA, and the sentence goes on
  to grant that LGE does index the FASTA inside a reference bundle when it
  builds one, under a different name and no use to a `gatk` command pointed
  at the reader's own file. This matches the reviewer's corrected wording.
  Confirmed by the earlier pass, unchanged by me.
- **`bcftools` never introduced.** Line 102 now reads that two of the files
  are made with the GATK binary and the rest with `samtools` and `bcftools`,
  both shipping in the Required Setup pack. Confirmed, unchanged by me.
- **The GATK build-string pin.** The chapter makes no claim that a sibling
  chapter carries the pin. It states version 4.6.2.0 and the install path
  and stops there, which is what the reviewer asked for. The pin itself
  (drift row 97) is still unaddressed manual-wide and belongs to whichever
  chapter owns pack provenance, not to this one. Left for the gate.

### The two unverifiable claims

Both were already handled by the earlier pass and I confirmed each.

- **BQSR step timings.** The two decimals are gone. Line 291 now says the
  provenance records the run as two steps, each a few seconds on this
  fixture, and that exact durations depend on the machine. This is the
  reviewer's own suggested softening.
- **dbSNP and Mills download sizes.** Both figures are cut. Line 171 now
  says dbSNP is much the larger of the two and adds that neither file's
  size has been measured for this manual, so no figure is quoted. Marking
  the absence explicitly is stronger than silently dropping the numbers.

### The fixture's byte-identical `.fai`

Already applied at line 83, and I verified the underlying fact rather than
taking it on trust. The shipped
`docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta.fai`
is 34 bytes and its single line matches the chapter's table field for field.
The chapter tells the reader the two are byte-identical, that keeping the
shipped one is allowed, and that building it once is still worth doing.

## Reader consensus rows

I walked all 42 consensus rows against the chapter as it stood. The earlier
pass had addressed 38 of them, which I confirmed one by one rather than
assuming. Four were outstanding and I applied them. Below are the four I
changed, then a note on how the 38 stand.

1. **Exit status 3 (consensus row, and a binding gloss ruling).** The
   earlier pass had cut the number entirely rather than glossing it, which
   satisfied the reader row by deletion but broke the ruling that requires a
   gloss at first use. I restored it inside the defects note at line 100 with
   the gloss attached, that it is the number a command hands back to say how
   it finished, zero meaning success and anything else meaning it stopped.
2. **The BAM's origin (fixture ruling).** The old sentence said the BAM was
   made by mapping, which reads as an instruction to go and map it. The BAM
   ships in the ZIP, one level deeper than the other files, so line 81 now
   says all four arrive in the same unpacked folder rather than needing
   anything run to produce them, names the `expected/mapping/` subfolder so
   the reader can find it, and keeps the HaplotypeCaller link for a reader
   who would rather produce their own.
3. **The comparison to a command the chapter never runs (row 46).** Line 350
   led with the joint-genotype contrast, which cost three readers the thread.
   The actionable instruction now leads, read Step 4's preview to see where
   the option landed, and the sibling chapter is named after it as the one
   case that differs rather than as the subject of the sentence.
4. **The offline-install command (row 112, and the completeness ruling).**
   Two corrections. The paragraph now opens by telling most readers they can
   stop and stating exactly who it applies to, someone setting up a second
   machine with no display. And the command itself was wrong. The chapter
   said `--pack-dir <dir>`, but `cli-help/conda.txt:319` shows the pack
   directory is a positional argument with no option in front of it. Both
   commands are now shown as a runnable pair with a concrete path.

The other 38 consensus rows were addressed by the earlier pass and I
confirmed each in place. The terminal onboarding subsection carries the
Terminal location, the `cd` instruction, the tilde, the shell and its search
path, and the `lungfish-cli` gloss. The preview-versus-execute mechanic is
stated once before the first command block and again explicitly at Steps 4
and 5. Every gloss the ruling names is present at first use, GATK, BAM,
bgzip against gzip, checksum, bundle, contig, transition and transversion,
the Mills set, the elided `file:///.../` path, the `@HD` and `@SQ` fields
worth checking, and the plain statement that LGE does not track the folder
in place of "not an LGE object". The zero-based half-open interval is worked
through in one-based terms. "Check four things" is now a numbered list of
exactly four, covered by three commands including the `@RG` check. The
repeated `--known-sites` option is shown written twice. A plain text editor
is named for the BED file with the word-processor warning.

## Other rows applied

Beyond the consensus set I confirmed the non-consensus rows the earlier pass
had reached, including the `M5` checksum question (stated to match on the
reader's machine, `UR` stated to differ), the `-f` on the index rebuild, the
"features" naming in GATK's error text, the `.dict` size tolerance, and the
Variant Phasing pack being explicitly not needed. I applied no further
non-consensus rows, because the remainder either duplicate consensus rows
already fixed or would require facts I could not source.

## Numbers verified rather than trusted

I re-measured every figure I could reach rather than copying it forward. The
`.fai` at 34 bytes, the `.dict` at 251 bytes with `LN:500001` and the M5
value quoted, the reheadered known-sites file at 38,323 bytes with its 392
byte index, the BED file at 27 bytes, the recalibration table at 1,191,386
bytes, and the recalibrated BAM at 16,929,652 bytes all match the chapter
exactly, against the scratch outputs under `scratchpad/gatk-refs/`. I also
confirmed that `gatk` is genuinely not on the shell's search path on this
machine, which is what justifies this chapter writing the full path every
time. Worth flagging that sibling chapter 01 says installing the pack "also
puts the `gatk` program on your path" and shows a bare `gatk` command, which
contradicts this chapter and did not hold when I checked. That is a sibling
chapter's line, not mine to edit, so it goes to the gate.

## Left for the gate

- Both front-matter flags stay `false`. I flipped neither.
- The GATK build-string pin, drift row 97, is unaddressed manual-wide and
  needs routing to whichever chapter owns pack provenance.
- The mkdocs nav label at `build/mkdocs.yml:121` still reads "Reference
  Packs" against a chapter titled "Reference Files for GATK", which belongs
  to the documentation lead.
- The benchmark VCF's unreheadered header is a fixture question for the
  Cartographer. The chapter teaches it as the worked failure deliberately.
- Sibling chapter 01's claim that the pack puts `gatk` on the path, which
  disagrees with this chapter and with what I measured.
- The two shots are unbuilt and belong to the Screenshot Scout.
- `GATK` has no `GLOSSARY.md` anchor. The reader row asked for both a gloss
  and a glossary entry. The gloss is in the chapter at first use, but the
  entry is not mine to add, so `gatk` is deliberately absent from
  `glossary_refs`. `checksum` and `contig` both resolve and are listed.

## Facts I could not source

None introduced by me. The two unverifiable claims from `fidelity.md` are
both handled by removal rather than by invention, and the chapter now says
in the dbSNP case that no figure has been measured rather than leaving the
reader to assume one was.
