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
"googlebooks-eng-all-5gram-20120701-of",#104.3GB
"googlebooks-eng-all-5gram-20120701-th",#285.1GB
"googlebooks-eng-all-5gram-20120701-t*"#400~GB
]

names=["py"]
pairs0=[
 #	 ["324","53"],
# 	 ["585","95"],
 # 	 ["995","162"],
   	 ["3167","843"],
	 ["6316","843"] 
 	]

pairs=[pairs0]

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
files=[8]
runs=1
filecount=0
i=0

for name in names: 
 i=0
 for file in files:
  for pair in pairs: 
    subprocess.call(["./tests.sh",name, filenames[file],pairs0[i][0],pairs0[i][1],"true"])
    i+=1
