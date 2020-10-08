# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv files
# Arguments: 1 -> tab delimited file
# Date: Oct 2020

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"

# Exit