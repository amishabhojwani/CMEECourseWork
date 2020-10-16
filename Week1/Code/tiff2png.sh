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
for f in *.tif; 
    do echo "Converting $f"; 
    convert "$f"  "$(basename "$f" .tif).png"; 
done echo "Done!"

#Exit