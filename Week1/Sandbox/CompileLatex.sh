#!/bin/bash
filename="$(basename -s .tex $1)"
pdflatex $1
bibtex $filename
pdflatex $1
pdflatex $1
evince $filename.pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg