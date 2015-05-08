#!/usr/bin/env python
import subprocess

__author__ = 'mbejda'
#['test.sh', str(domid)]

#names=["py","r"]
#names=["rhadoop"]
filenames= [
"googlebooks-eng-all-5gram-20120701-ta",# 5.6GB
"googlebooks-eng-all-5gram-20120701-un",# 9.4GB
"googlebooks-eng-all-5gram-20120701-st",#16.7GB
"googlebooks-eng-all-5gram-20120701-on",#25.2GB
"googlebooks-eng-all-5gram-20120701-be",#45.7GB
"googlebooks-eng-all-5gram-20120701-in",#77.7GB
]

names=["py","r","rhadoop"]
pairs=[
 	 ["75","20"],
 	 ["86","20"],
  	 ["100","20"],
  	 ["120","20"],
  	 ["100","25"],
  	 ["100","30"],
  	 ["100","35"],
  	 ["86","35"],
  	 ["75","35"]
 	]
#pairs=[
 #	["8","995"],
# 	["16","498"],
# 	["32","249"],
# 	["64","125"],
# 	["80","100"],
# 	["96","105"],
#        ["112","84"],
# 	["128","63"]
#      ]

combiner="true"
#pairs=[["118","28"],["59","14"],["118","30"],["118","25"],["118","15"],["118","5"]]
files=[1]
runs=2

for name in names: 
 for file in files: 
  for a in pairs:
     for i in range(0,runs):
	subprocess.call(["./tests.sh",name, filenames[file],a[0],a[1],combiner])
