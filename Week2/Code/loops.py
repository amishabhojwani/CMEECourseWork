#!/usr/bin/env python3

"""Shows functionality of loops"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#FOR loops
################
#prints a list from range 0-5
for i in range(5):
    print(i)

#prints every value in the list    
my_list=[0,2,"geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

#adds every value to the next
total=0
summands=[0,1,11,111,1111]
for s in summands:
    total=total+s
    print(total)

#WHILE loops
###############
#prints from 1-100
z=0
while z<100:
    z=z+1
    print(z)

#infinite loop
b=True
while b:
    print("GERONIMO! infinite loop! ctrl+c to stop!")