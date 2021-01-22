# !bin/bash
# Author: Amisha a.bhojwani20@imperial.ac.uk
# Script: variables.sh
# Description: shows the use of variables and reading multiple values
#
# Outputs on the terminal
# Arguments: 1 string and two integers read as input
# Date: Oct 2020

# Shows the use of variables
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string, or default values will be used'
read MyVar

echo 'the current value of the variable is' ${MyVar:='some other string'}

printf "\n"

## Reading multiple values
echo 'Enter two numbers separated by space(s), or default values will be used'
read a b
echo 'The numbers are' ${a:=2} 'and' ${b:=3}'. Their sum is:'
mysum=`expr $a + $b`
echo $mysum

#Exit