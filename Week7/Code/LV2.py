#!/usr/bin/env python3

"""Plotting a Lotka-Volterra model"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p

def dCR_dt(pops, t, r, a, z, e, K):
    """Function defining consumer growth rate and resource population size at time t"""
    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1-(R/K)) - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return sc.array([dRdt, dCdt])

#plots
def fsave(pops, t, r, a, z, e):
    """Saves figures"""
    #plotting f1
    f1 = p.figure() #open plot 1

    p.plot(t, pops[:,0], 'g-', label='Resource density')
    p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
    p.grid()                  
    p.legend(loc='best')
    p.figtext(0.45, 0.15, ('r = {}, a = {}, z = {}, e = {}'.format(r, a, z, e)), color = "red", weight = "bold") #show variable values on plot
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics')
    #p.show()
    p.close()

    #final predator prey values
    print("The final prey and predator values are {} and {}, respectively".format(round(pops[-1,0], 2), round(pops[-1,1], 2)))

    f1.savefig('../Results/LV2_model.pdf') #save figure

    return 0

#command line arguments
def main(argvs):
    """ Main entry point of the program """
    #assigning time vector with arbitrary time units
    t = sc.linspace(0, 60, 1000)
    #set initial conidtions
    R0 = 10.0
    C0 = 5.0
    RC0 = sc.array([R0, C0])
    K = 45.0
    #read in argvs if there are any
    if len(sys.argv) < 5: #no arguments
        print("Using default parameters as not enough were specified")
        r = 1.3
        a = 0.3
        z = 1.
        e = 0.8
    elif len(sys.argv) == 5: #arguments given
        r = float(sys.argv[1])
        a = float(sys.argv[2])
        z = float(sys.argv[3])
        e = float(sys.argv[4])
    #integrate the system
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, args=(r, a, z, e, K), full_output=True)
    fsave(pops, t, r, a, z, e)
    return 0

#making the script an importable module
if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)

