taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

taxa_dic={}        
Chiroptera=[]
Rodentia=[]
Afrosoricida=[]
Carnivora=[]

orderslist=

for x in taxa:
        for x[1] == 'Chiroptera':
                order.append(x[0])
                #print(Chiroptera)
        if x[1] == 'Rodentia':
                Rodentia.append(x[0])
                #print(Rodentia)
        if x[1] == 'Afrosoricida':
                Afrosoricida.append(x[0])
                #print(Afrosoricida)
        if x[1] == 'Carnivora':
                Carnivora.append(x[0])
                #print(Carnivora)
        
taxa_dic['Chiroptera']=Chiroptera
taxa_dic['Rodentia']=Rodentia
taxa_dic['Afrosoricida']=Afrosoricida
taxa_dic['Carnivora']=Carnivora
print(taxa_dic)

#Exit