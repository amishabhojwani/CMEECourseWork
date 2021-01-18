#!/usr/bin/env python3

"""Takes in 6 arguments for the parameters to run a time discrete, stochastic Lotka Volterra model and output two figures of the change over time"""

__appname__ = '[LV4.py]'
__author__ = '[Alex Chan (hhc4317@ic.ac.uk)]'
__version__= '0.0.1'
__license__ = "License for this code/program"


### Dependencies
import sys
import scipy as sc
import numpy as np
import scipy.integrate as integrate
import scipy.stats as stats
import matplotlib.pylab as p

#Functions
def discreteLotVolt_norm(pops,r,a,z,e,K):
    """Time discrete Lotka Volterra Equation with gaussian fluctuations in prey populations"""
    #pops is an array with 2 starting values for R and C
    R=pops[0]
    C=pops[1]

    #fluctuations in resource growth rate
    flucR = stats.norm.rvs(loc = 0, scale = 0.1, size = 1) #random numbers from a normal distribution
    flucC = stats.norm.rvs(loc = 0, scale = 0.1, size = 1) # added this, from below
    Rt1 = R*(1+(float(flucR)+r)*(1-(R/K))-a*C)
    Ct1 = C*(1-z+float(flucC)+(e*a*R)) # added this, from below

    #simultaneous fluctuations in both consumer and resource populations
    #flucR = stats.norm.rvs(loc = 0, scale = 0.01, size = 1)
    #flucC = stats.norm.rvs(loc = 0, scale = 0.01, size = 1) #two random numbers from normal distributions
    #Rt1 = R*(1+float(flucR)+r*(1-(R/K))-a*C)
    #Ct1 = C*(1-z+float(flucC)+(e*a*R))

    return np.array([Rt1,Ct1])

#Plotting 
def plot_norm(pops,t,txtstr):
    """Plotting the figures"""
    time = range(0,t,1) #time vector for plotting
    #Figure 1
    f1 = p.figure()
    ax = f1.add_subplot(111)
    p.plot(time,pops[:,0], 'g-', label='Resource Density')
    p.plot(time, pops[:,1], 'b-', label='Consumer Density')
    p.grid()
    p.legend(loc='best')
    #plotting the text box:
    ax.text(0, max(pops[:,0])*0.75, txtstr, style='italic', fontsize=12, 
        bbox={'facecolor': 'grey', 'alpha': 0.5, 'pad': 10})
    p.xlabel('Time')
    p.ylabel('Population Density')
    p.title('Consumer-Resource Population Dynamics')
    f1.savefig('../Results/LV4_model.pdf')

    #figure 2
    f2 = p.figure()
    ax = f2.add_subplot(111)
    p.xlim(0,max(pops[:,0]))
    p.ylim(0,max(pops[:,1]))
    p.plot(pops[:,0],pops[:,1],'r-')
    p.grid()
    ax.text(0, max(pops[:,1])*0.75, txtstr, style='italic', fontsize=12, 
        bbox={'facecolor': 'grey', 'alpha': 0.5, 'pad': 10})
    p.xlabel('Resource Density')
    p.ylabel('Consumer Density')
    p.title('Consumer-Resource Population Dynamics')
    f2.savefig('../Results/LV4_model2.pdf')



def runsim_norm(t, params):
    """Runs simulation of the time discrete Lotka Volterra model for time t"""
    #starting values:
    R0 = 10
    C0 = 5
    #import ipdb; ipdb.set_trace()
    RCarray = np.ones((t,2)) # initialize array with 1s
    RCarray[0,:] = np.array([R0,C0]) #starting levels

    for i in range(1,t,1):
        RCt1 = discreteLotVolt_norm(RCarray[i-1,:],params[0],params[1],params[2],params[3],params[4]) #Get Resource and Consumer for t+1
        RCarray[i,:] = RCt1
    #import ipdb; ipdb.set_trace()
    return(RCarray)


def main(argv):
    """Main function that runs for the python program"""

    if(len(argv)==7):
        #import ipdb; ipdb.set_trace()
        params = (float(argv[1]),float(argv[2]),float(argv[3]),float(argv[4]),float(argv[5]))
        t = int(argv[6])
        pops = runsim_norm(t,params)

        txtstr = ("r = %f\na = %f\nz = %f\ne = %f\nK = %f" %(params[0],params[1],params[2],params[3],params[4])) 

        # defining txt to plot
        plot_norm(pops,t,txtstr)
        print("Final Resource Level:%f\nFinal Consumer Level:%f"%(pops[t-1,0],pops[t-1,1]))
        return(0)
    else:
        #If there is incorrect number of input parameters
        print("Incorrect number of parameters entered, using default values")
        params = (1,0.1,0.1,0.1,100)
        t = 500
        pops = runsim_norm(t,params)
        print("ran_sim")

        txtstr = ("r = %f\na = %f\nz = %f\ne = %f\nK = %f" %(params[0],params[1],params[2],params[3],params[4])) 
        
        # defining txt to plot
        plot_norm(pops,t,txtstr)
        print("Final Resource Level:%f\nFinal Consumer Level:%f"%(pops[t-1,0],pops[t-1,1]))

        return(0)



if __name__ == "__main__":
    """Makes sure main function runs when script is ran"""
    status=main(sys.argv)
    sys.exit(status)