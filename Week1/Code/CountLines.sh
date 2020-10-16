# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: CountLines.sh
# Description: counts the lines in a file
#
# Outputs on the terminal
# Arguments: 1 -> file
# Date: Oct 2020

echo "Checking $1"
if test -e $1 #test if the input file exists
    then 
        if test -s $1 #test if the input file size is greater than 0
            then echo "Counting lines in $1"
            NumLines=`wc -l < $1` #Count lines in $1
            echo "The file $1 has $NumLines lines"
            else echo "The file is empty"
        fi
    else echo "File not found"
fi

#Exit