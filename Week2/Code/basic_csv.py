#!/usr/bin/env python3

"""Reads a file containing species information and
writes a file with only species and body mass"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'
f=open('../Data/testcsv.csv', 'r')

csvread=csv.reader(f)
temp=[]
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close

# Write a file contaiing only species name and Body mass
f=open('../Data/testcsv.csv', 'r')
g=open('../Data/bodymass.csv', 'w')

csvread=csv.reader(f)
csvwrite=csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()