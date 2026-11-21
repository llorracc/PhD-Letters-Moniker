#!/bin/bash
# Build Letter.pdf (and a PDF of each section in Subfiles/) from this repository alone.
# Red [CDC: ...] markers show where the advisor's own passages go: they live in a
# folder you never see, and only the advisor's build script reads them.
#
#   ./Letter-make.sh                 build
#   SKIP_CV_SYNC=1 ./Letter-make.sh  build without refreshing JMFiles/CV.pdf from \CVUrl
#
# Exit status 1 if LaTeX fails or a citation is unresolved (a key missing from Letter.bib,
# a duplicate entry, an unreadable .bib): fix Letter.bib and run again.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT" || exit 1

for f in cdc-build.flag cdc-final.flag advisor-local.ltx cdc-references.bib; do
  if [ -e "$f" ]; then
    echo "ERROR: $f is here. It belongs only in the advisor's throwaway build copy; delete it and run again." >&2
    exit 1
  fi
done

# If \CVUrl is set in student-macros.ltx, refresh JMFiles/CV.pdf when the remote PDF changes.
if [ -f scripts/sync-cv-from-url.sh ]; then
  bash scripts/sync-cv-from-url.sh || echo "Warning: CV sync reported an error; continuing with the letter build."
fi

latexmk -C Letter >/dev/null 2>&1
if ! latexmk -pdf Letter >Letter-make.log 2>&1; then
  echo "ERROR: the letter did not build. The end of the log:" >&2
  tail -25 Letter-make.log >&2
  exit 1
fi

# BibTeX problems stop the build (latexmk alone does not always say so).
problems=""
[ -f Letter.blg ] && problems=$(grep -E "^Warning--I didn't find a database entry|^Repeated entry|^I couldn't open|^I found no" Letter.blg)
undefined=$(grep -E "Citation .* undefined" Letter.log)
if [ -n "$problems$undefined" ]; then
  echo "ERROR: citation problems (fix Letter.bib):" >&2
  [ -n "$problems" ] && echo "$problems" >&2
  [ -n "$undefined" ] && echo "$undefined" | sort -u >&2
  exit 1
fi

# A PDF of each section, for checking one section at a time.
( cd Subfiles && ./Subfiles.sh >/dev/null 2>&1 )

latexmk -c Letter >/dev/null 2>&1
rm -f Letter-make.log
echo "Built Letter.pdf ($(pdfinfo Letter.pdf 2>/dev/null | awk '/^Pages:/{print $2}') pages)."
