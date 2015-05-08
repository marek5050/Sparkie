#!/usr/bin/env python
import sys
import math
import random
x = 0
y = 0
def dist(point1, point2):
 return math.sqrt(pow(point1[0] - point2[0], 2) + pow(point2[1] - point1[1], 2))

def closest(point, centroids):
   closestDistance=-1
   centr=-1
   idx=0
   for centroid in centroids: 
	d = dist(point,centroid)
        #print "Distance %d ,closestDistance %d, centroid: %d"  % (d, closestDistance,centr)
        if d < closestDistance or closestDistance == -1:
           closestDistance=d
           centr=idx
        idx+=1 
   #print idx
   return centr

#Add the necessary captions and stuff
#centroids=[(0,0),(1,1),(-10,-10)]
centroids=[]
f = open('kmeans_output.txt', 'r')
for line in f:
    words = line.split()
    point= [int(numeric_string) for numeric_string in words]
    print point

for line in sys.stdin:
    words = line.split()
    point= [int(numeric_string) for numeric_string in words]
    
    if len(centroids) == 0:
       closest_centroid = random.randint(0,5)
    else:
       closest_centroid = closest(point, centroids)
   
    print ("%d \t" % (closest_centroid))+" " .join(map(str,point))
