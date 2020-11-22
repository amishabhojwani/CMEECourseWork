#!/usr/bin/env python3

"""Translating the StochRick R script to python"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import re

# Read the file (using a different, more python 3 way, just for fun!)
f = open("../Data/blackbirds.txt", "r")
text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (slightly easier!), or a single one (slightly harder!)

#multiple expressions
#Kingdom
Kingdom = re.findall(r'Kingdom\s*([\w]*)', text)
#Phylum
Phylum = re.findall(r'Phylum\s*([\w]*)', text)
#Species
Species = re.findall(r'Species\s*([\w*\s\w]*)', text)

for sp in range(len(Kingdom)):
    print(Kingdom[sp], ", ", Phylum[sp], ", ", Species[sp], "\n", sep="")

#one line
#Taxonomy = re.findall(r'Kingdom\s*([\w]*).\sPhylum\s*([\w]*)', text) need to describe whats in between and then parenthesis what i want