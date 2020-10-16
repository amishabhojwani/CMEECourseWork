# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv files
# Arguments: 1 -> tab delimited file
# Date: Oct 2020

echo "Checking file: $1..."
if test -e $1; #test if the file exists
    then 
        if test -s $1; #test if the size of the file is greater than 0
            then 
                if [[ $1 = *.txt || $1 = *.tsv ]]; #check if the file type is supported (is .txt or .tsv)
                    then echo "Creating a comma delimited version of $1..."
                    x="$1"
                    y=${x%.*} #remove file extension
                    cat $1 | tr -s "\t" "," >> $y.csv #substitute tabs for commas and add csv extension
                    echo "Done! Your new file is $y.csv"
                    else echo "File type not supported"
                fi
            else echo "File is empty"
        fi
    else echo "File not found"
fi

# Exit