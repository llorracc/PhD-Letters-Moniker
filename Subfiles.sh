#!/bin/bash

latexmk -C

for f in *.tex; do
    latexmk -c "$f"
done


rm *.dep
