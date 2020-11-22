#!/usr/bin/env python3

"""Running python scripts LV1.py and LV2.py"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import subprocess
import LV2
import cProfile

#running LV1 through a subprocess
print("Running LV1.py ...")
p1 = subprocess.Popen(["ipython3 LV1.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True).wait()
if p1==0: #user feedback
    print("Ran LV1.py successfully")
else:
    print("Could not run LV1.py")

#running LV2 as a module with appropriate arguments
print("\nRunning LV2.py ...")
p2 = LV2.main([1., 0.1, 1.5, 0.75])
if p2==0: #user feedback
    print("Ran LV2.py successfully")
else:
    print("Could not run LV2.py")

#profiling LV1.py and LV2.py through subprocesses
print("\nProfiling LV1.py ...")
sp1 = subprocess.Popen("ipython3 -m cProfile LV1.py", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
stdout, stderr = sp1.communicate()
output1 = stdout.decode()
print("Done!\n\n", output1[40:103])

print("\n\nProfiling LV2.py ...")
sp2 = subprocess.Popen("ipython3 -m cProfile LV2.py", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
stdout, stderr = sp2.communicate()
output2 = stdout.decode()
print("Done!\n\n", output2[160:224])