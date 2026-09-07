# Editor pass, appendices/tool-versions

Chapter: `docs/user-manual/chapters/appendices/tool-versions.md`
Editor: Brand Copy Editor. Date: 2026-09-07.
Roster row 66. Generated reference table, four tables from the tool lock.

## False claims fixed

Three false claims and one unverifiable claim, all handled with the
reviewer's wording.

1. **In-app lock path.** Was `Contents/Resources/third-party-tools-lock.json`.
   Now the reviewer's corrected path,
   `Contents/Resources/LungfishGenomeBrowser_LungfishWorkflow.bundle/Contents/Resources/ManagedTools/third-party-tools-lock.json`.
   I confirmed the file is there before writing it, with an `ls` of that
   directory in the installed Preview bundle, which returns
   `third-party-tools-lock.json` and nothing else. The source-tree path beside
   it is unchanged. Both paths are now followed by the readers' request that
   the second be marked as being for developers working from a checkout.

2. **`SAMtools` display name.** The "On the command line" section said the
   command writes `SAMtools`. It writes `Samtools`. Changed to `Samtools`.
   `Trim_Galore` beside it was already right and is untouched.

3. **ucsc-bedgraphtobigwig License cell.** Was `Varies, see https://...` with
   a comma. The lock's own string carries a semicolon. I did not type the
   correction. I reran the author's script with one change to its License
   emitter, wrapping a license string containing a semicolon in a code span,
   and took the cell from its output. The cell now reads
   `` `Varies; see https://genome.ucsc.edu/license` `` inside a code span, so
   the chapter's claim that every cell is the lock's own field is exactly true
   and the house no-semicolon rule is not broken. The lint rule's own
   `proseText` helper strips `inlineCode` before it looks for a semicolon,
   which I checked in `build/scripts/lint/rules/severity.js`, so this is a
   real exemption rather than a lint accident.

4. **Viral Recon wizard version field (unverifiable).** Dropped. The sentence
   "and the Viral Recon release with the version field of the Viral Recon
   wizard" is gone. Nothing replaces it with a claim about that wizard. The
   surviving sentence names only the TaxTriage `--revision` route and then
   says plainly that the TaxTriage revision cannot be changed from a window,
   which also answers reader 4's GUI-mismatch row.

## Project manager rulings

**(a) Tables untouched except through the script.** Held. One cell changed,
the ucsc License cell, and it came from a rerun of the author's script rather
than from typing. Every other cell of all 59 rows is byte-identical to the
committed version, which the fidelity reviewer had already verified against
the lock cell by cell. The script was rerun once, on
`Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`,
and its 18-row always-installed output was diffed against the chapter's first
table. The other three tables were not regenerated, since no ruling or
reviewer finding touched a cell in them.

**(b) The one paragraph near the top.** Applied, in What it is, as two
consecutive paragraphs after the "look up a number and move on" lead. This is
the one place where I departed from the ruling's literal wording, and the
reason follows.

The ruling says to state that no window in LGE shows tool versions. That is
not true in this release, and writing it would have created a fourth false
claim in a chapter whose whole point is fidelity. `AboutWindowController.swift`
lines 322 to 356 build the About window's credits from
`AboutAcknowledgements.currentSections()`, which
(`AboutAcknowledgements.swift:25-46`) emits one entry per tool with
`detail: tool.version` for the bundled bootstrap, for every tool in the
Required Setup pack, and for every active optional pack, all read from the
same lock this chapter tabulates. The About window therefore prints a version
for every tool in an installed pack. Separately, the Plugin Manager's
Installed tab lists the exact packages and versions inside each environment,
which chapter 07's committed text already states at its lines 125 and 184.

So I kept every other part of the ruling and corrected only the factual half.
The chapter now says, once and near the top, that the About window shows the
app version, the dependency set, and a version for every tool in an installed
pack, that the Plugin Manager's Installed tab lists the packages inside each
environment, and that the provenance sidecar beside any result names the exact
tool versions that run used. It then locates the sidecar in one sentence, the
file named `.lungfish-provenance.json` beside the result or inside the
bundle's `provenance/` folder, plain text opened in TextEdit or any other text
editor, and points at the Tool Bibliography for the terminal-free routes
rather than repeating them. That still answers the readers' actual task, which
was "how do I find out what my own copy has", and it answers it with three
routes instead of one. This deviation is flagged here for the project manager
rather than decided quietly.

**(c) Command pointers and ordering.** Applied. The bare-name-fails note now
comes before the first command in the chapter. The first command is the
`conda install --pack` example in the plugin pack section, and the sentence
after it reads "Read 'On the command line' below before typing that, since the
bare name will not work as printed." The `tools update --plan` command in Two
checks carries the same pointer. The "On the command line" section itself now
opens with the campaign's fixed optional-section paragraph and then a "Before
you type anything" pointer to the CLI Reference section of that name, which is
where Terminal is located and where the `export PATH` line is printed. The
binary path ruling is honoured in the example itself, which now writes the
quoted full path
`"/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli" version --tools`
rather than the bare name, which was the readers' "trap" row.

The PATH sentence is split into five short sentences and both terms are
glossed. PATH is "the list of folders your shell searches for programs" and
shell is "the program reading what you type at the prompt", each in its own
clause rather than stacked into one dense sentence.

**(d) Present from the first launch, reconciled.** Applied. The two sentences
that contradicted each other are now one true statement taken from the
author's record of Required Setup and from `PluginPack.swift:424-437`, which
builds the Required Setup pack straight from the lock's `tools` array. The
chapter now reads "These eighteen come with every copy of LGE and install
themselves without being asked. Seventeen are conda environments in the
Required Setup pack, the one pack LGE installs by itself the first time it
needs them, so no reader ever installs them by hand." That matches the
framing the committed chapters 04, 05, and 08 already use for Required Setup,
so the manual says one thing about it.

**(e) NCBI Taxonomy warning beside the table.** Applied, as a bolded
one-sentence lead-in paragraph immediately under the database table, headed
"Warning about the NCBI Taxonomy row." It names the consequence for a methods
section in that one sentence, since that is what changes what a methods
section must record. The old buried paragraph in the middle of the section is
gone.

**(f) Glosses.** Applied at first use, one clause each, for lock file,
pinned, dependency set, plugin pack, conda environment, executable, assembler,
home folder and the tilde, repository, Nextflow, commit identifier, release
tag, exit status, host reads, the Kraken 2 memory suffix, and the four source
policy values including `liveSnapshot`, which the reviewer noted was never
explained anywhere in the old text. Glossary changes are listed below.

**(g) A terminal-free What good looks like check.** Applied. The section is
renamed "Two checks before you cite a number", which was reader 3's row about
the heading promising a judgement standard. Its first check is now entirely
terminal-free, opening the About window and reading the Dependency set line.
Its second check leads with the window route, the Plugin Manager's Check for
Tool Updates button, and marks the command as skippable for readers who do
not use a terminal.

## Reader rows

**Consensus section, 27 rows. All 27 applied.** No consensus row was skipped.

The ones worth naming, since they moved structure rather than words. The four
program names in the opening now each carry a clause saying what they do. The
lock file path now says the reader never needs to open it. A finished methods
sentence is shown in a code block, which was the single most-requested row. The
sidecar is located once, near the top, and linked. "Four ideas separate the
four tables" became "Four columns need a note each". The tilde is glossed as
the home folder and the folder is called hidden. The lock-file jargon sentence
is split and "key" became "a labelled entry of its own", with `bootstrap`
dropped rather than glossed, since the reader gains nothing from the key name.
The odd version numbers now end in "copy it whole, exactly as it appears, and
it will be right in a citation". The Plugin Manager paragraph now says what
the window shows, that a pack takes a few minutes, and how to see what is
installed. The four source policies are all explained before the table, in the
order the table lists them, and `unpinnedArchive` now says plainly that
nothing checks the archive's contents have not changed. The exit-status
sentence is marked as being for readers who write scripts and says what
everybody else sees. The staleness warning moved from the last screen to the
third paragraph of What it is. "Provisions on first use" is gone. The
`python` executable rows are explained. Both early commands carry a pointer to
the command-line section. `--revision` gains a real example value and a "most
readers should leave both pinned". "The lock pins sixteen" became "sixteen
databases". The Kraken 2 suffixes are explained as memory in gigabytes with a
pointer to where a run names its own. The retiredEnvironments paragraph is cut
to one sentence saying it matters only when upgrading. The example now uses
the full quoted path rather than the bare name.

**Other merged rows, 52 in total. 46 applied, 6 skipped.**

Applied, in brief. The opening now leads with what LGE does. The source path
is marked as being for developers. "Cut on" became "frozen on". Each number in
the dependency set sentence is labelled, so 2026.9.13 is "app release". "Hands
them their files" became "gives those programs their files". The 48-word lock
file sentence is split. "Outside program" became "program written by somebody
else". "Float upward" became "allowed to change to a newer one". Assembler is
glossed. The executables example now leads with SAMtools, a name the reader
knows, before IQ-TREE and Clair3. The license warning now says plainly that
using and citing a tool is not redistribution. The Environment column carries
an "ignore this unless" clause. The 42-word conda sentence is split at "so
that". The bare `GPL` cell is explained. The bbtools against BBTools spelling
question is answered, with the published capitalisation named as the one for a
paper. The link-only license cell is covered by the same rule. The pack
section leads with the uninstalled-pack fact as its own sentence. The
standalone list of ten pack IDs is cut, since the table carries them. The
Bibliography's caveat is now beside the install command, naming the three
packs the command-line installer rejects. Bracken 1.0.0 is explained. Whether
an uninstalled pack's row still describes a past run is answered. Repository,
revision, and Nextflow are each glossed, with Nextflow named as the same tool
in the first table. The commit identifier is explained before the table. "In
principle" became "though this is rare". "Quote" became "write into your
methods section". Host reads are glossed. The `managedData` key sentence is
cut. The verification date is removed from the reader's path. The three
presentation differences are a three-item list with the consequence stated
first in its own sentence. The truncated sample output now says it is cut
short and gains a trailing ellipsis line. Which page a methods section should
cite is answered in Which one governs. A "which table holds what" sentence
opens the chapter.

Skipped, with a reason each.

1. **"Show two lines of an actual provenance record once, anywhere in the
   chapter"** (reader 2, one reader). Skipped. This is the Tool Bibliography's
   job and it already does it. Duplicating a sidecar excerpt here would create
   a second place to keep in step with the file format, and the ruling for
   this chapter is to point at Bibliography rather than repeat it.

2. **"Cut the sentence 'Every number on this page is read out of one file'"**
   (readers 2 and 4). Skipped as written. The readers wanted the "look up a
   number and move on" guidance placed first, and that is now the second
   paragraph of the chapter, ahead of the lock file explanation. But the
   provenance claim itself has to stay, because it is what licenses the
   generated-table rule and what a reviewer checks the page against. It is
   moved down rather than cut.

3. **"Say which licenses are the restrictive ones"** (reader 3, one reader).
   Skipped. Naming which of GPL, MPL, and BSD is more restrictive than the
   others is legal interpretation, and the chapter's own standing rule is that
   licenses are copied from the lock and not interpreted here. The row's
   underlying worry is answered instead, by saying plainly that analysing and
   citing is not redistribution, which is the consensus-adjacent half of the
   same complaint.

4. **"Gloss 'command line' at its first use in Reading the tables"**
   (reader 3, one reader). Skipped. The phrase now appears there only inside
   "in a provenance record and in a command line", where it is an aside rather
   than an instruction, and a full gloss at that point would land ten sections
   before the section that teaches it. The command-line section's own opening
   paragraph glosses it where the reader needs it.

5. **"Move the command line section earlier"** (reader 2, one reader).
   Skipped. Section order is structure, which is outside this role's
   authority, and the ruling's chosen fix, a pointer before every command,
   solves the same problem without moving a section. Both early commands now
   carry that pointer.

6. **"Add a search or index so a reader can find one tool"** (reader 2, one
   reader). Skipped as an artifact-level request. A search box is not
   something a Markdown chapter can carry. The half of the row this chapter
   can answer, a sentence at the top saying which table holds which kind of
   tool, is applied.

## Script rerun

Yes, once. The author's `generate_tables.py` was rerun against the committed
lock with a one-line change to its License emitter, so a license string
containing a semicolon is wrapped in a code span. Its always-installed output
was compared against the chapter's first table. One cell differed, the
ucsc-bedgraphtobigwig License cell, and the script's version replaced the
chapter's. No other table cell changed anywhere in the chapter.

## Glossary changes

Three terms added to `docs/user-manual/GLOSSARY.md`, each in the existing
one-sentence entry shape with a `{#anchor}` and a See also line, inserted in
alphabetical position.

- **Commit**{#commit}, after Cohort in the C section.
- **Executable**{#executable}, between EsViritu and Exit status in the E
  section.
- **Home folder**{#home-folder}, before Homologous in the H section.

`glossary_refs` in the chapter front matter is now
`[assembler, commit, conda, dependency-set, executable, exit-status,
home-folder, micromamba, nextflow, pinned, plugin-pack, provenance-sidecar,
repository, tool-lock-manifest]`. Six terms added, `assembler`, `commit`,
`executable`, `exit-status`, `home-folder`, and `nextflow`, plus `repository`.
Two removed, `provenance` and `reproducibility`, because neither is linked
from the body any more and the fidelity reviewer's standing check is that
every ref is linked. All fourteen anchors were verified to resolve with a
per-anchor grep returning exactly one match.

I did not touch the pre-existing misordering in the H section, where Host name
and Host depletion sit after the `## I` heading. It predates this pass and
belongs to the Glossary's owner.

## Brand and style

No em dashes. No semicolons in prose, the one semicolon in the chapter being
inside a code span in a table cell by ruling. No colon inside a sentence. No
word from `ai-tells-words.txt`. Sentences held to roughly 20 words, with the
three longest sentences of the old draft split. Bullet caps met, the chapter
carrying one three-item list in total. "Lungfish Genome Explorer (LGE)" at
first mention, "LGE" after. The `<a id="appendix-tool-versions"></a>` anchor is
preserved immediately after the front matter, and four chapters link to it.

`brand_reviewed` and `lead_approved` are both left at `false`.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/tool-versions.md`
passed on its first run and again after the front-matter trim. Result line,
verbatim:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/tool-versions.md: no issues found
```

I ran no git commands, dispatched no subagents, wrote nothing into
`~/Desktop/lge-docs/`, and edited no sibling chapter.
