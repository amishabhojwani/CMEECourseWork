# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: csvtospace.sh
# Description: substitute the commas in the file with spaces
#
# Saves the output into .txt files
# Arguments: 1 -> comma delimited file
# Date: Oct 2020

echo "Checking file: $1..."

# Test for arguments
if [[ $# -eq 1 ]]
    then 
        
        if [[ $1 = *.csv ]] #check if the file is csv
            then 
                
                if test -s $1 #test if the size of the file is greater than 0 and exists
                    then echo "Creating a space delimited version of $1..."
                    
                    x="$1"
                    y=${x%.*} #remove file extension
                    cat $1 | tr -s "," " " >> $y.txt #substitute commas for spaces and add .txt extension
                    
                    echo "Done! Your new file is $y.txt"
                
                else echo "File is empty or does not exist"
                fi
        
        else echo "File is not .csv"
        fi

else echo "Provide 1 .csv file"
fi

 #Exit