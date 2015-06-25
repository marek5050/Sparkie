#!/usr/bin/env python
import sys
import random
import math


base=0
count=0
priorCluster=-1

currentCluster=-1



def mean(num):
    return str(num/count)

for line in sys.stdin:
    cord = line.split("\t")
    currentCluster=cord[0]
    _points=cord[1]
    _str_point=_points.split(" ")
    point= [int(numeric_string) for numeric_string in _str_point] 
    
    count+=1 
   
    if currentCluster!=priorCluster :  
       print " ".join(map(mean,point))
       priorCluster=currentCluster
       base=0
       count=0
       

    if base==0 :
       base=point    
    else:
        idx=0
        for coord in point:
           base[idx]+=coord
           idx+=0      
