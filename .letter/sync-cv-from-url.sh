#!/usr/bin/env bash
# Sync JMFiles/CV.pdf from \CVUrl in student-macros.ltx when the remote PDF changes.
# Invoked from Letter-make.sh before the LaTeX build. (This file is in .letter/, one level below the root.)
#
# Environment:
#   SKIP_CV_SYNC=1     — skip this script entirely
#   CV_SYNC_VERBOSE=1  — extra messages

set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

MACROS="$REPO_ROOT/student-macros.ltx"
JM="$REPO_ROOT/JMFiles"
NEW_PDF="$JM/.cv-sync-download.pdf"
OLD_TXT="$JM/.cv-sync-old.txt"
NEW_TXT="$JM/.cv-sync-new.txt"
REVIEW_DIR="$JM/CV-sync-review"
SCRIPT_PY="$REPO_ROOT/.letter/cv_trivial_diff.py"

if [ -n "${SKIP_CV_SYNC:-}" ]; then
  [ -n "${CV_SYNC_VERBOSE:-}" ] && echo "=== CV sync: skipped (SKIP_CV_SYNC set) ==="
  exit 0
fi

if [ ! -f "$MACROS" ]; then
  exit 0
fi

# Extract \newcommand{\CVUrl}{...} value (first closing brace only; URL must not contain }).
CV_URL=$(sed -n 's/^\\newcommand{\\CVUrl}{\([^}]*\)}.*/\1/p' "$MACROS" | head -1)
CV_URL="${CV_URL#"${CV_URL%%[![:space:]]*}"}"
CV_URL="${CV_URL%"${CV_URL##*[![:space:]]}"}"

if [ -z "$CV_URL" ]; then
  [ -n "${CV_SYNC_VERBOSE:-}" ] && echo "=== CV sync: no \\CVUrl in student-macros.ltx — nothing to do ==="
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "⚠ CV sync: curl not found; cannot fetch CV from URL (install curl or set SKIP_CV_SYNC=1)."
  exit 1
fi

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "⚠ CV sync: pdftotext not found; cannot compare CV text (install poppler or set SKIP_CV_SYNC=1)."
  exit 1
fi

mkdir -p "$JM"

echo "=== CV sync: fetching $CV_URL ==="
if ! curl -fsSL --connect-timeout 15 --max-time 120 -o "$NEW_PDF" "$CV_URL"; then
  echo "⚠ CV sync: download failed (network or HTTP error). Letter build continues."
  rm -f "$NEW_PDF"
  exit 1
fi

# Basic PDF check
if ! head -c 5 "$NEW_PDF" | grep -q '%PDF'; then
  echo "⚠ CV sync: downloaded file does not look like a PDF. Leaving JMFiles/CV.pdf unchanged."
  rm -f "$NEW_PDF"
  exit 1
fi

TARGET="$JM/CV.pdf"

if [ ! -f "$TARGET" ]; then
  mv "$NEW_PDF" "$TARGET"
  echo "  ✓ Saved initial CV to JMFiles/CV.pdf"
  exit 0
fi

if cmp -s "$NEW_PDF" "$TARGET"; then
  rm -f "$NEW_PDF"
  [ -n "${CV_SYNC_VERBOSE:-}" ] && echo "  ✓ CV.pdf unchanged (identical to remote)"
  exit 0
fi

pdftotext -layout "$TARGET" "$OLD_TXT" 2>/dev/null || pdftotext "$TARGET" "$OLD_TXT"
pdftotext -layout "$NEW_PDF" "$NEW_TXT" 2>/dev/null || pdftotext "$NEW_PDF" "$NEW_TXT"

# python3 exits 0 => only trivial / metadata-style text differences
SUBSTANTIVE_CHANGE=1
if command -v python3 >/dev/null 2>&1 && [ -f "$SCRIPT_PY" ]; then
  if python3 "$SCRIPT_PY" "$OLD_TXT" "$NEW_TXT"; then
    SUBSTANTIVE_CHANGE=0
  else
    SUBSTANTIVE_CHANGE=1
  fi
else
  echo "⚠ CV sync: python3 or cv_trivial_diff.py missing — treating text change as substantive."
  SUBSTANTIVE_CHANGE=1
fi

rm -f "$OLD_TXT" "$NEW_TXT"

if [ "$SUBSTANTIVE_CHANGE" -eq 0 ]; then
  mv "$NEW_PDF" "$TARGET"
  echo "  ✓ CV.pdf updated from URL (text differs only in trivial/metadata-style lines)."
  exit 0
fi

TS=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="CV_${TS}.pdf"
mkdir -p "$REVIEW_DIR"
mv "$TARGET" "$JM/$ARCHIVE_NAME"
mv "$NEW_PDF" "$TARGET"
echo "  ✓ Archived previous CV as JMFiles/$ARCHIVE_NAME"
echo "  ✓ Replaced JMFiles/CV.pdf with the newly downloaded file"

# Text extracts for AI-assisted review (paths without leading dot for user visibility).
pdftotext -layout "$JM/$ARCHIVE_NAME" "$REVIEW_DIR/previous_${TS}.txt" 2>/dev/null || pdftotext "$JM/$ARCHIVE_NAME" "$REVIEW_DIR/previous_${TS}.txt"
pdftotext -layout "$TARGET" "$REVIEW_DIR/current_${TS}.txt" 2>/dev/null || pdftotext "$TARGET" "$REVIEW_DIR/current_${TS}.txt"
ln -sf "previous_${TS}.txt" "$REVIEW_DIR/previous_for_ai_review.txt" 2>/dev/null || true
ln -sf "current_${TS}.txt" "$REVIEW_DIR/current_for_ai_review.txt" 2>/dev/null || true

cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CV sync: substantive text change detected (not just timestamps/metadata heuristics).

1. Compare text extracts (or ask an AI to compare them):
     $REVIEW_DIR/previous_${TS}.txt
     $REVIEW_DIR/current_${TS}.txt
   Symlinks for convenience:
     $REVIEW_DIR/previous_for_ai_review.txt
     $REVIEW_DIR/current_for_ai_review.txt

2. Ask the AI whether updates are needed elsewhere in this repo, e.g.:
     student-macros.ltx, Subfiles/*.tex, email-templates/student-info.md,
     letter-opportunities/*/opportunity.md

3. Previous PDF retained as: JMFiles/$ARCHIVE_NAME
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

exit 0
