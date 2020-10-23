#!/usr/bin/env python3

"""Practical testing for loops and list comprehensions"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.

LatinNames=[x[0] for x in birds]
print('Latin Names:', LatinNames)

CommonNames=[y[1] for y in birds]
print('Common Names:', CommonNames)

MeanMass=[z[2] for z in birds]
print('Mean Mass:', MeanMass)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

LatinNames=[]
for x in birds:
    LatinNames.append(x[0])
print('Latin Names:', LatinNames)

CommonNames=[]
for x in birds:
    CommonNames.append(x[1])
print('Common Names:', CommonNames)

MeanMass=[]
for x in birds:
    MeanMass.append(x[2])
print('Mean Mass:', MeanMass)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.