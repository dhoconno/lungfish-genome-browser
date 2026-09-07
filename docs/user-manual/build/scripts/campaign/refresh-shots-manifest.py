#!/usr/bin/env python3
"""Regenerate the checker output and counts at the foot of SHOTS.md.

    refresh-shots-manifest.py

Runs check-shots.mjs, replaces everything from "## check-shots output" to
the end of reviews/fidelity-2026-09/SHOTS.md with the fresh output and the
row counts by status, and prints the counts. Run it after every capture
commit so the manifest's tail matches the assets on disk.
"""
import subprocess
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
REPO = ROOT.parents[1]
MANIFEST = ROOT / "reviews" / "fidelity-2026-09" / "SHOTS.md"


def main():
    text = MANIFEST.read_text()
    out = subprocess.run(
        ["node", str(ROOT / "build/scripts/campaign/check-shots.mjs"), str(ROOT.relative_to(REPO))],
        capture_output=True, text=True, cwd=REPO,
    )
    checker = (out.stdout + out.stderr).strip()
    rows = [l for l in text.splitlines()
            if l.startswith("| ") and l.count(" | ") >= 8 and not l.startswith("| Chapter dir")]

    def status(line):
        cells = [c.strip() for c in line.strip().strip("|").split(" | ")]
        return cells[5] if len(cells) > 5 else ""

    counts = Counter(status(r) for r in rows)
    head = text.split("## check-shots output", 1)[0]
    block = (
        "## check-shots output\n\n"
        "Produced by `node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual` "
        "(refresh with `build/scripts/campaign/refresh-shots-manifest.py`).\n\n"
        f"```\n{checker}\n```\n\n## Counts\n\n"
        f"Total markers {len(rows)}, captured {counts.get('captured', 0)}, new {counts.get('new', 0)}, "
        f"stale {counts.get('stale', 0)}, existing {counts.get('existing', 0)}. "
        "Rows still open are listed by blocker in `captures/README.md` and worked through "
        "`COMPLETION-SPEC.md`.\n"
    )
    MANIFEST.write_text(head + block)
    print(dict(counts), "rows", len(rows))
    print(checker.splitlines()[-1] if checker else "checker produced no output")


if __name__ == "__main__":
    main()
