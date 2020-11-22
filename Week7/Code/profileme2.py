#!/usr/bin/env python3

"""Alternative functions and profiling"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

#import scipy as sc

def my_squares(iters):
    """List comprehension"""
    #out = sc.ones([1, iters]) #trying it with a preallocated array
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """String concatenation"""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    """Testing the alternative functions"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")