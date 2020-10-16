# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: ConcatenateTwoFiles1.sh
# Description: Version2. Trying to make ConcatenateTwoFiles.sh look cleaner. Concatenates two files into a new output file
#
# Saves the output into a .txt file
# Arguments: 2 -> files with data to concatenate
# Date: Oct 2020

echo "Checking files..."

if [[ $# -eq 0 ]] #check for arguments
  then
    echo "No files given"
    exit 
fi

if test -e $1 #test if $1 exists
    then
    else echo "Cannot locate $1"
    exit 
fi   
        
if test -e $2 #test if $2 exists
    then
    else echo "Cannot locate $2"
    exit
fi    
    
if test -s $1 #test if size of $1 is greater than 0
    then
    else echo "$1 is empty"
    exit 
fi    
                        
if test -s $2  #test if size of $2 is greater than 0
    then
    else echo "$2 is empty"
    exit
fi                            
                            
echo "Merging your files..."
x="$(basename $1)" #remove filepath from $1
w="${x%.*}" #remove file extension from $1
z="$(basename $2)" #remove filepath from $2
y="${z%.*}" #remove file extension from $2
merged=../Data/${w}_${y} #name the new merged file and filepath
cat $1 > $merged.txt
cat $2 >> $merged.txt #concatenate files and output to a merged .txt file
echo "Done! Your new file is $merged.txt"

#Exit