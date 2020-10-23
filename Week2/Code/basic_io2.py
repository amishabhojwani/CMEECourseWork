#!/usr/bin/env python3

"""Writes a .txt file with a list of numbers from 0-99"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#############################
# FILE OUTPUT
#############################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../Sandbox/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()