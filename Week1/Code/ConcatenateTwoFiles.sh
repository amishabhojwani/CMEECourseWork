# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Description: Concatenate two files
#
# Saves the output into a .txt file
# Arguments: 2 -> files with data to concatenate
# Date: Oct 2020

if [[ $# == 2 ]] #check if 2 arguments are provided
  then 
    
    if test -s $1 #test if arg1 exists and has a size greater than 0
        then
            
            if test -s $2  #test if arg2 exists and has a size greater than 0
                then
                
                echo "Merging your files..."
                
                x="$(basename $1)" #remove filepath from $1
                w="${x%.*}" #remove file extension from $1
                
                z="$(basename $2)" #remove filepath from $2
                y="${z%.*}" #remove file extension from $2
                
                merged=../Data/${w}_${y} #name the new merged file and filepath
                
                cat $1 > $merged.txt
                cat $2 >> $merged.txt #concatenate files and output to a merged .txt file
                
                echo "Done! Your new file is $merged.txt"
            
            else echo "$2 is empty or does not exist"
            fi
    
    else echo "$1 is empty or does not exist"
    fi

else echo "Please provide 2 files to concatenate"
fi

#Exit