#!/bin/bash

at=$(grep -o "A\|T" E.coli.fasta | wc -l) #count a and t ocurrences
gc=$(grep -o  "G\|C" E.coli.fasta | wc -l) #count g and c occurences
atgc=$(bc <<< "scale=3; $at/$gc") #define and calculate atgc variable
echo $atgc

#end