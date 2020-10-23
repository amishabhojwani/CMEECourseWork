#!/usr/bin/env python3

"""Makes a bug"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

def makeabug(x):
    """Makes a bug with an error code of 'float division by zero'"""
    y = x**4
    z = 0.
    y = y/z
    return y

makeabug(25)