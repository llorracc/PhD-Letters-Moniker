#!/usr/bin/env python3
"""
Compare two pdftotext outputs. Exit 0 if differences look like metadata / layout noise only.
Exit 1 if there may be substantive CV content changes (human or AI should review).

Heuristic: strip lines that are typically PDF metadata or timestamps, normalize whitespace,
then compare. Lines longer than 120 chars are never discarded as trivial.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path


# Lines that are only boilerplate / timing / page markers (case-insensitive).
# Keep patterns narrow so real CV sentences are never dropped.
_TRIVIAL_ONLY = re.compile(
    r"""^(
        \s* |
        page\s+\d+(\s+of\s+\d+)?\s* |
        \d{1,2}[/.\-]\d{1,2}[/.\-]\d{2,4}\s* |
        \d{4}[/.\-]\d{1,2}[/.\-]\d{1,2}\s* |
        (jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s+\d{1,2},?\s+\d{4}\s* |
        \d{1,2}:\d{2}(:\d{2})?(\s*[ap]m)?\s* |
        (confidential|proprietary)\s* |
        \d+\s*$
    )$""",
    re.I | re.VERBOSE,
)

# Substrings that often appear in PDF producer lines (whole line may still be long).
_META_FRAG = re.compile(
    r"(adobe|pdf|acrobat|latex|pdftex|xetex|luatex|ghostscript|quartz|mac os|creator|producer|creationdate|moddate)",
    re.I,
)


def _normalize(text: str) -> str:
    # Unify line endings and collapse runs of spaces (pdftotext layout varies).
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines_out: list[str] = []
    for raw in text.split("\n"):
        line = " ".join(raw.split())
        if not line:
            continue
        if len(line) > 120:
            lines_out.append(line.lower())
            continue
        if _TRIVIAL_ONLY.match(line):
            continue
        if _META_FRAG.search(line) and len(line) < 100:
            continue
        lines_out.append(line.lower())
    return "\n".join(lines_out)


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: cv_trivial_diff.py <old.txt> <new.txt>", file=sys.stderr)
        return 2
    old_p, new_p = Path(sys.argv[1]), Path(sys.argv[2])
    if not old_p.is_file() or not new_p.is_file():
        print("cv_trivial_diff: missing input file", file=sys.stderr)
        return 2
    old_t = _normalize(old_p.read_text(encoding="utf-8", errors="replace"))
    new_t = _normalize(new_p.read_text(encoding="utf-8", errors="replace"))
    if old_t == new_t:
        return 0
    # Residual difference: treat as substantive so the advisor/student review.
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
