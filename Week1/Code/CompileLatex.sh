# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: CompileLatex.sh
# Description: Compiles a latex from .bib files and a tex file in a same directory
#
# Outputs pdf in the same file as input
# Arguments: 1 -> .tex file
# Date: Oct 2020

## Test arguments
if [[ $# -eq 0 ]]
  then
  echo "No .tex file provided"
  exit 
fi

if [[ $1 = *.tex ]];
  then echo "Compiling your pdf"
  else echo "Unsupported extension. Please provide a .tex file!"
  exit
fi

## Compile pdf
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