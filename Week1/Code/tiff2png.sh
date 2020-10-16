#!/bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: tiff2png.sh
# Description: convert a .tif file or files within a directory to .png
#
# Saves the output into a .png files
# Arguments: 1 -> file or directory with .tif files
# Date: Oct 2020

if [[ $# -eq 0 ]]
  then
  echo "No .tif file present"
  exit 
fi

for f in *.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done