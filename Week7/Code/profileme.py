#!/usr/bin/env python3

"""Checking out profiling"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

def my_squares(iters):
    """power of 2 by appending to a list"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """Joining in a list"""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Running time for joins vs appends"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

#test functions
run_my_funcs(10000000,"My string")