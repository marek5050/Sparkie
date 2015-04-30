#!/usr/bin/env python
import subprocess

__author__ = 'mbejda'
#['test.sh', str(domid)]

names=["py","r"]
#names=["rhadoop"]
#names=["rhipe"]
#pairs=[
#	 ["1462","365"],
#	 ["731","182"],
# 	 ["488","122"],
#	 ["366","92"]
#	]
pairs=[
#	["8","995"],
# 	["16","498"],
# 	["32","249"],
 	["64","125"],
 	["80","100"],
 	["96","105"],
        ["112","84"],
 	["128","63"]
      ]



combiner="false"
#pairs=[["118","28"],["59","14"],["118","30"],["118","25"],["118","15"],["118","5"]]
input_file="12"
runs=3

for name in names: 
  for a in pairs:
     for i in range(0,runs):
	subprocess.call(["./tests.sh",name, input_file,a[0],a[1],combiner])
