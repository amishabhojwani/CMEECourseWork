# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

Rainfall100=[x for x in rainfall if x[1]>100]
print('Months and rainfall values greater than 100mm:', Rainfall100)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm.

Months50=[x[0] for x in rainfall if x[1]<50]
print('Months where rainfall values are less than 50mm:', Months50)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

Rainfall100=[]
for x in rainfall:
    if x[1]>100:
        Rainfall100.append(x)
print('Months and rainfall values greater than 100mm:', Rainfall100)

Months50=[]
for x in rainfall:
    if x[1]<50:
        Months50.append(x[0])
print('Months where rainfall values are less than 50mm:', Months50)

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

