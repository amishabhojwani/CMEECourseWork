#!/usr/bin/env python3

"""Shows use of pickle and writing binary files"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#############################
# STORING OBJECTS
#############################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../Sandbox/testp.p','wb') ## note the b: accept binary files
pickle.dump(my_dictionary, f)
f.close()

## Load the data again
f = open('../Sandbox/testp.p','rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)