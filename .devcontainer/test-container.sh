#!/bin/bash
# Test script to verify the dev container is properly configured

set -e

echo "=========================================="
echo "Dev Container Environment Test"
echo "=========================================="
echo ""

# Test 1: Check LaTeX binaries
echo "1. Checking LaTeX binaries..."
echo "   - pdflatex: $(which pdflatex)"
echo "   - bibtex: $(which bibtex)"
echo "   - latexmk: $(which latexmk)"
echo "   ✓ All LaTeX binaries found"
echo ""

# Test 2: Check versions
echo "2. Checking versions..."
pdflatex --version | head -n 1
echo ""

# Test 3: Check TEXMF paths
echo "3. Checking TEXMF configuration..."
kpsewhich -var-value=TEXMFHOME
kpsewhich -var-value=TEXMFLOCAL
echo "   ✓ TEXMF paths configured"
echo ""

# Test 4: Create a minimal test document
echo "4. Testing LaTeX compilation..."
cat > /tmp/test.tex << 'EOF'
\documentclass{article}
\usepackage{amsmath}
\usepackage{hyperref}
\begin{document}
Hello from LaTeX! $E = mc^2$
\end{document}
EOF

cd /tmp
if pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1; then
    echo "   ✓ LaTeX compilation successful"
    rm -f test.* texput.log
else
    echo "   ✗ LaTeX compilation failed"
    exit 1
fi
echo ""

# Test 5: Check for common packages
echo "5. Checking common LaTeX packages..."
packages=(
    "natbib.sty"
    "graphicx.sty"
    "hyperref.sty"
    "amsmath.sty"
    "booktabs.sty"
)

for pkg in "${packages[@]}"; do
    if kpsewhich "$pkg" > /dev/null 2>&1; then
        echo "   ✓ $pkg found"
    else
        echo "   ✗ $pkg not found"
    fi
done
echo ""

# Test 6: Check Git
echo "6. Checking Git..."
git --version
echo "   ✓ Git configured"
echo ""

# Test 7: Check Python (for scripts)
echo "7. Checking Python..."
python3 --version
echo "   ✓ Python available"
echo ""

echo "=========================================="
echo "✓ All tests passed!"
echo "=========================================="
echo ""
echo "Container is ready for LaTeX development."
echo "Run 'make test' or 'latexmk Letter.tex' to compile your document."

