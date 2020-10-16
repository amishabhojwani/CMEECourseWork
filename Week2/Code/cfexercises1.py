#!/usr/bin/env python3

"""Some functions exemplifying the use of conditionals"""

__appname__= 'Conditionals'
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__= '-'

## imports ##
import sys

## functions ##
"""Find the value of x with an exponent of 0.5"""
def foo_1(x):
    return x ** 0.5

"""Return largest value"""
def foo_2(x, y):
    if x > y:
        return x
    return y

"""Move the largest value to the end of the list"""
def foo_3(x, y, z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

"""Method1 to determine the factorial of x"""
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

"""Method2 to determine the factorial of x, recursive function"""
def foo_5(x): 
    if x == 1:
        return 1
    return x * foo5(x - 1)

"""Method3 to determine the factorial of x"""     
def foo_6(x):
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto