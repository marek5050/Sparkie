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
"googlebooks-eng-all-5gram-20120701-of",#104.3GB
"googlebooks-eng-all-5gram-20120701-th",#285.1GB
"googlebooks-eng-all-5gram-20120701-t*"#390GB
]

#airs=[
#	 ["497","125"],
# 	 ["398","100"],
#  	 ["332","83"],
# 	 ["284","71"],
# 	 ["249","63"]
#	]
pairs=[
   #	["86","20","true"],
    #	["80","53","true"],
    #	["80","95","true"],
    #	["80","162","true"],
    #	["80","217","true"],
     	["128","843","true"] 
      ]

#pairs=[["118","28"],["59","14"],["118","30"],["118","25"],["118","15"],["118","5"]]
files=[8]
runs=1

#for name in names: 
# for file in files: 
#  for a in pairs:
#     for i in range(0,runs):
#	print filenames[file]
#	subprocess.call(["./tests.sh",name, filenames[file] ,a[0],a[1],a[2]])
i=0

for name in names: 
 for file in files: 
	print filenames[file]
	subprocess.call(["./tests.sh",name, filenames[file] ,pairs[i][0],pairs[i][1],'true'])
	i+=1
