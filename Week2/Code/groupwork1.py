#!/usr/bin/env python3
__author__ = 'zeb bondzeb@gmail.com'
__title__ = 'align_seqs_fasta.py'
__version__ = '0.0.1'

#############
## IMPORTS ##
#############

import sys

###############
## VARIABLES ##
###############

seq2 = "ATCGCCGGATTACGGG"
seq1 = "CAATTCGGAT"

###############
## FUNCTIONS ##
###############

#use strip() somehow !!!!
#extract sequences from the .fasta files
'''open 2 fasta files'''
def readfasta(x='../Data/fasta/407228326.fasta', y='../Data/fasta/407228412.fasta'):
    with open(x) as f:
        slist1 = f.readlines()[2:]
    with open(y) as f:
        slist2 = f.readlines()[2:]
    slist1 = [x.strip("\n") for x in slist1]
    slist2 = [x.strip("\n") for x in slist2]
    sq1 = "".join(slist1)
    sq2 = "".join(slist2)
    print('The Sequences being aligned are', sq1, 'and', sq2, '\n')

    return sq1, sq2
    
#print(readfasta('../Data/fasta/407228326.fasta', '../Data/fasta/407228412.fasta'))

#assigns longer 1 shorter 2 l1 and l2 are there respective lengths
def assignvar(sq1, sq2):
    """ assigns lengths as l1 and l2 and the longer and sequences as s1 and s2 respectively """
    l1 = len(sq1) 
    l2 = len(sq2)
    if l1 >= l2:
        s1 = sq1
        s2 = sq2
    else:
        s1 = sq2
        s2 = sq1
        l1, l2 = l2, l1 # swap the two lengths

    return s1, s2, l1, l2 

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """ asigns alignments scores based on how well matched the bases are """
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# now try to find the best match (highest score) for the two sequences
def printbestalign(s1, s2, l1, l2):
    """ prints the alignment with the highest score """
    my_best_align = None
    my_best_score = -1

    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # think about what this is doing!
            my_best_score = z 
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)

    return my_best_align

def main(argv):
    sqT = readfasta(argv[1], argv[2])
    sq1 = sqT[0]
    sq2 = sqT[1]
    slT = assignvar(sq1, sq2)
    s1 = slT[0]
    s2 = slT[1]
    l1 = slT[2]
    l2 = slT[3]
    printbestalign(s1, s2, l1, l2)



##########
## MAIN ##
##########

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
