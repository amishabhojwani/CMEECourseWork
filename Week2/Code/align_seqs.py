#!/usr/bin/env python3

"""Matching two DNA sequences to be as similar as possible"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import sys

# Two example sequences to match
# seq2 = "ATCGCCGGATTACGGG"
# seq1 = "CAATTCGGAT"

"""Read two DNA sequences from twoseq.fasta"""

file = open('twoseq.fasta')
all_lines = file.readlines()

seq2 = all_lines[0]
seq1 = all_lines[1]

"""Assign the longer sequence s1, and the shorter s2.
   l1 is length of the longest, l2 that of the shortest"""

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

print("Sequences are placed one above the other according to a starting point.\n* means that the bases in both sequences are matched.\n- means that they aren't matched.\n")

def calculate_score(s1, s2, l1, l2, startpoint):

    """A function that computes a score by returning the number of matches starting
    from arbitrary startpoint, chosen by the user. s1 is the longer sequence and s2 the shorter.
    l1 is the length of the longer sequence and l2 the shorter."""
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

def main(argv):
    print("\n\nTesting the function with some example starting points:\n")
    print(calculate_score(s1, s2, l1, l2, 0))
    print(calculate_score(s1, s2, l1, l2, 1))
    print(calculate_score(s1, s2, l1, l2, 5))
    return 0

"""Find the best match (highest score) for the two sequences"""
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

"""Write a txt file with the best alignment and its' score"""
file = open('bestalign.txt', 'w')        
file.write(f'{my_best_align}{s1} \nBest score: {my_best_score}')
file.close()

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)