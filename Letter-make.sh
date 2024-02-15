#!/bin/bash

pdflatex Letter.tex
bibtex   Letter.tex
pdflatex Letter.tex
pdflatex Letter.tex

cd Subfiles

for f in *.tex; do
    pdflatex $f
    bibtex $f
    pdflatex $f
    pdflatex $f
done

cd ..

latexmk -C
latexmk Letter
latexmk -c

