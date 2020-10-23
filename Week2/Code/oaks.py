#!/usr/bin/env python3

"""Finds just those taxa that are oak trees from a list of species"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

taxa = [ 'Quercus robur', 
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
         ]

def is_an_oak(name):
    """Checks if a species is an oak species"""
    return name.lower().startswith('quercus ')

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehension
oaks_lc=set([species for species in taxa if is_an_oak(species)])
print(oaks_loops)

##Get names in UPPER CASE using for loops
oaks_loops=set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc=set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)

