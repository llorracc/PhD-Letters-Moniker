#!/bin/bash

latexmk -C

for f in *.tex; do
    latexmk "$f"
done

latexmk -c

