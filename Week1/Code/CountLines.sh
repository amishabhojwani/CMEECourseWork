# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: CountLines.sh
# Description: counts the lines in a file
#
# Outputs on the terminal
# Arguments: 1 -> file
# Date: Oct 2020

if [[ $# -eq 1 ]] #test if there is one argument
    then 
        if test -s $1 #test if the input file size is greater than 0 and it exists
            then filename=$(basename $1)
            
            echo "Counting lines in $filename"
            
            NumLines=`wc -l < $1` #Count lines in $1
            
            echo "The file $filename has $NumLines lines"
            
        else echo "$1 is empty or does not exist"
        fi
else echo "Please provide one file to count lines"
fi

#Exit