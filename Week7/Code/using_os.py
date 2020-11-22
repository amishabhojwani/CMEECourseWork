#!/usr/bin/env python3

"""Subprocesses practial 1"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for (dirpath, dirnames, filenames) in subprocess.os.walk(home):
    C1dirpath = re.findall(r'/C\w*[\.\w]*', dirpath)
    for x in C1dirpath:
        if x not in FilesDirsStartingWithC:
            FilesDirsStartingWithC.append(x)

print(FilesDirsStartingWithC)

#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithCc = []

# Use a for loop to walk through the home directory.
for (dirpath, dirnames, filenames) in subprocess.os.walk(home):
    C2dirpath = re.findall(r'/[Cc]\w*[\.\w]*', dirpath)
    for x in C2dirpath:
        if x not in FilesDirsStartingWithCc:
            FilesDirsStartingWithCc.append(x)

print(FilesDirsStartingWithCc)

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
DirsStartingWithCc = []

# Use a for loop to walk through the home directory.
for (dirpath, dirnames, filenames) in subprocess.os.walk("/home/amisha/Documents/CMEECourseWork/Week2"):
    C3dirpath = re.findall(r'/([Cc][\w\d\.\-]*$|[Cc][\w\d\.\-]*/)', dirpath)
    for x in C3dirpath:
        if x not in DirsStartingWithCc:
            DirsStartingWithCc.append(x)

print(DirsStartingWithCc)