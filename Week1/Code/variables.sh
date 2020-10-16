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
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum=`expr $a + $b`
echo $mysum

#Exit