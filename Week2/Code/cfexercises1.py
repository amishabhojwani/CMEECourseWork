#!/usr/bin/env python3

"""Some functions exemplifying the use of conditionals"""

__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys

## functions ##

def foo_1(x):
    """Find the square root of x"""
    y=x ** 0.5
    return "The square root of %f is %f" % (x, y)

def foo_2(x, y):
    """Return largest value of two"""
    if x > y:
        return "%f is larger than %f" % (x, y)
    return "%f is larger than %f" % (y, x)


def foo_3(x, y, z):
    """Move the largest value of three to the end of the list"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return "%f is larger than %f and %f" % (z, x, y)


def foo_4(x):
    """Determine the factorial of x through iterations"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return "The factorial of %f is %f" % (i, result)


def foo_5(x):
    """Determine the factorial of x through a recursive function"""
    if x == 1:
        return 1
    return x * foo5(x - 1)


def foo_6(x):
    """Determine the factorial of x"""     
    facto = 1
    y = x
    while y >= 1:
        facto = facto * y
        y = y - 1
    return "The factorial of %f is %f" % (x, facto)

def main(argv):
    """Argv's"""
    print(foo_1(4))
    print(foo_1(11))
    print(foo_2(3, 6))
    print(foo_2(56, 7))
    print(foo_3(2, 14, 8))
    print(foo_3(123, 33, 78))
    print(foo_4(5))
    print(foo_5(5))
    print(foo_6(5))

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)