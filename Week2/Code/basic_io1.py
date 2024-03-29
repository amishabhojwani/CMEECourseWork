#!/usr/bin/env python3

"""Shows how to strip a file of blanks"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#############################
# FILE INPUT
#############################
# Open a file for reading
f = open('../Sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../Sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()
