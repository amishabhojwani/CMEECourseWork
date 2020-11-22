#!/usr/bin/env python3

"""Plotting a Lotka-Volterra model"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p

def dCR_dt(pops, t=0):
    """Function defining consumer growth rate and resource population size at time t"""
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return sc.array([dRdt, dCdt])

#assigning parameter values
r = 1.
a = 0.1 
z = 1.5
e = 0.75
t = sc.linspace(0, 15, 1000) #time vector with arbitrary time units

#set initial conidtions
R0 = 10
C0 = 5 
RC0 = sc.array([R0, C0])

#integrate the system
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

#plotting f1
f1 = p.figure() #open plot 1

p.plot(t, pops[:,0], 'g-', label='Resource density')
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
#p.show()
p.close()

f1.savefig('../Results/LV1_model.pdf') #save figure

#plotting f2
f2 =p.figure() #open plot 2

p.plot(pops[:,0], pops[:,1], 'r-')
p.grid()
p.legend(loc='best')
p.xlabel('Resource density')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
#p.show()
p.close()

f2.savefig('../Results/LV1_model1.pdf') #save figure