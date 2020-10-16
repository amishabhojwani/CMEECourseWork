# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: CompileLatex.sh
# Description: Compiles a latex from .bib files and a tex file in a same directory
#
# Outputs pdf in the same file as input
# Arguments: 1 -> .tex file
# Date: Oct 2020

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