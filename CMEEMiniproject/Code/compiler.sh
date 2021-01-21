#!/bin/bash
#Author: Amisha Bhojwani a.bhojwani20@imperial.ac.uk
#Script: compiler.sh
#Desc: a script to run and compile my miniproject in its entirety
#Arguments: none
#Date: January 2021

echo "Welcome to Amisha's miniproject. Let's begin!"

#run analyses
Rscript data_prep.R
Rscript starting_values.R
Rscript model_fitting.R
Rscript plotting.R

#compile pdf of the report
touch wordcount.txt
texcount -1 -sum report.tex -out=wordcount.txt #output wordcount to txt file to input into the report
bash CompileLatex.sh report.tex miniproject_biblio

#End message
echo "Done, Amisha's miniproject has been run successfully! :)"
