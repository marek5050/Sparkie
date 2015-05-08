#!/usr/bin/env python
import subprocess

__author__ = 'mbejda'
#['test.sh', str(domid)]

#names=["java"]
#names=["rhadoop"]
names=["rhipe"]
filenames= [
"googlebooks-eng-all-5gram-20120701-ta",# 5.6GB
"googlebooks-eng-all-5gram-20120701-un",# 9.4GB
"googlebooks-eng-all-5gram-20120701-st",#16.7GB
"googlebooks-eng-all-5gram-20120701-on",#25.2GB
 "googlebooks-eng-all-5gram-20120701-be",#45.7GB
 "googlebooks-eng-all-5gram-20120701-in",#77.7GB
]

#airs=[
#	 ["497","125"],
# 	 ["398","100"],
#  	 ["332","83"],
# 	 ["284","71"],
# 	 ["249","63"]
#	]
#pairs=[
#   	["32","20"],
#    	["48","20"],
##    	["64","20"],
#    	["80","20"],
#   	["96","20"],
#        ["112","20"],
#  	["128","20"]
#       ]
pairs=[
	["128","5"],
	["128","10"],
	["128","15"],
	["128","20"],
	["128","25"],
	["128","30"],
	["128","35"],
	["128","40"]
]
combiner="false"
#pairs=[["118","28"],["59","14"],["118","30"],["118","25"],["118","15"],["118","5"]]
files=[0,1,2,3]
runs=3

for name in names: 
 for file in files: 
  for a in pairs:
     subprocess.call(["./tests.sh",name,filenames[file],a[0],a[1],"true"])
     for i in range(0,runs):
	print filenames[file]
	subprocess.call(["./tests.sh",name, filenames[file] ,a[0],a[1],combiner])
