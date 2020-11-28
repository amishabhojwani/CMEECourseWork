#!/usr/bin/env python3

"""Playing around with data from the Miniproject options"""

__author__ = 'Amisha Bhojwani (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#cd Documents/CMEECourseWork/CMEEMiniproject/Sandbox/Code

import pandas as pd
import scipy as sc
import matplotlib.pylab as pl
import seaborn as sns

###########################################
########### Functional responses ##########
###########################################

# How well do different mathematical models, e.g., based upon foraging theory (mechanistic)
# principles vs. phenomenological ones, fit to functional responses data across species?
data = pd.read_csv("../Data/CRat.csv")
print("Loaded {} columns.".format(len(data.columns.values)))
data.head()  
print(data.columns.values)
print(data.TraitUnit.unique()) #units of the response variable
print(data.ResDensityUnit.unique()) #units of the independent variable 
print(data.ID.unique()) #units of the independent variable
data_subset = data[data['ID']==39982]
data_subset.head()
sns.lmplot("ResDensity", "N_TraitValue", data=data_subset, fit_reg=False)
pl.show()

###########################################
############# Population growth ###########
###########################################

# How well do different mathematical models, e.g., based upon population growth (mechanistic)
# theory vs. phenomenological ones, fit to functional responses data across species?

data = pd.read_csv("../Data/LogisticGrowthData.csv")
print("Loaded {} columns.".format(len(data.columns.values)))
print(data.columns.values)
pd.read_csv("../Data/LogisticGrowthMetaData.csv")
data.head()
print(data.PopBio_units.unique()) #units of the response variable
print(data.Time_units.unique()) #units of the independent variable
data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)
print(data.ID.unique()) #units of the independent variable
data_subset = data[data['ID']=='Chryseobacterium.balustinum_5_TSB_Bae, Y.M., Zheng, L., Hyun, J.E., Jung, K.S., Heu, S. and Lee, S.Y., 2014. Growth characteristics and biofilm formation of various spoilage bacteria isolated from fresh produce. Journal of food science, 79(10), pp.M2072-M2080.']
data_subset.head()
sns.lmplot("Time", "PopBio", data = data_subset, fit_reg = False) # will give warning - you can ignore it
pl.show()

###########################################
####### Thermal performance curves ########
###########################################

# How well do different mathematical models, e.g., based upon biochemical (mechanistic)
# principles vs. phenomenological ones, fit to the thermal responses of metabolic traits?

data = pd.read_csv("../Data/ThermRespData.csv")
print("Loaded {} columns.".format(len(data.columns.values)))
data.head()
print(data.columns.values)
print(data.OriginalTraitUnit.unique()) #units of the response variable
print(data.ConTempUnit.unique()) #units of the independent variable 
print(data.ID.unique()) #units of the independent variable 
data_subset = data[data['ID']==110]
data_subset.head()
sns.lmplot("ConTemp", "OriginalTraitValue", data=data_subset, fit_reg=False)
pl.show()

