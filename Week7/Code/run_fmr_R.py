#!/usr/bin/env python3

"""Running fmr.R in Python with Subprocess"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import subprocess

#run the R file in a subprocess
p = subprocess.Popen("Rscript --verbose fmr.R > ../Results/fmr.Rout 2> ../Results/fmr_errFile.Rout", shell=True).wait()

#check if it ran well
print("\nReturn code for the subprocess is: {}".format(p))
if p == 0: #feedback
    print("Successful run\n")
else:
    print("Unsuccessful run\n")
        
#print rconsole contents
stdout = open("../Results/fmr.Rout")
print("This is the output from the R console:")
print(stdout.read())