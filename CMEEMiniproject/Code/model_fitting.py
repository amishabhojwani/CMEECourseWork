from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import matplotlib.pylab as plt
import pandas as pd

#####plotting cubic polynomial for eachs data subset
#Create object for storing parameters
params_linear = Parameters()

#Add parameters and initial values to it
params_linear.add('a', value = 1)
params_linear.add('b', value = 1)
params_linear.add('c', value = 1)
params_linear.add('d', value = 1)

#Write down the objective function that we want to minimize, i.e., the residuals 
def residuals_linear(params, t, data):
    """Calculate cubic growth and subtract data"""
    
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    
    #Cubic model
    model = v['a']*t**3 + v['b']*t**2 + v['c']*t + v['d']

    return model - data     #Return residuals

#Create a Minimizer object
minner = Minimizer(residuals_linear, params_linear, fcn_args=(t, np.log(N_rand)))

#Perform the minimization
fit_linear_NLLS = minner.minimize()

#fit summary
report_fit(fit_linear_NLLS)

subdata = pd.read_csv("../Data/data_subsets/subset_2.csv")
fit_linear_OLS = np.polyfit(np.log(subdata["ResDensity"]), np.log(subdata["N_TraitValue"]), 3) # degree = 3 for cubic polynomial
my_poly = np.poly1d(fit_linear_OLS)
ypred = my_poly(subdata["ResDensity"])
residuals = ypred - np.log(subdata["N_TraitValue"])

#plotting
result_linear = np.log(subdata["N_TraitValue"]) + residuals # These points lay on top of the theoretical fitted curve
plt.plot(np.log(subdata["ResDensity"]), result_linear, 'y.', markersize = 15, label = 'Linear')
#Get a smooth curve by plugging a time vector to the fitted logistic model
ResDens_vec = np.linspace(0,max(subdata["ResDensity"]),1000)
log_N_vec = np.ones(len(ResDens_vec))#Create a vector of ones.
residual_smooth_linear = residuals_linear(fit_linear_OLS, ResDens_vec, log_N_vec)
plt.plot(t_vec, residual_smooth_linear + log_N_vec, 'orange', linestyle = '--', linewidth = 1)