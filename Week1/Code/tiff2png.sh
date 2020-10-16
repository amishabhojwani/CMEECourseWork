# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: tiff2png.sh
# Description: convert a .tiff file or files within a directory to .png
#
# Saves the output into a .png files
# Arguments: 1 -> file or directory
# Date: Oct 2020
# find the difference between file input and filepath input
#format and empty

echo "Checking .tif file(s)..."

if [[ $# -eq 0 ]]
  then
    echo "No file or directory given"
    exit 
fi

for f in *.tiff; 
    do echo "Converting $f"; 
    convert "$f"  "$(basename "$f" .tiff).png"; 
done echo "Done!"

#Exit