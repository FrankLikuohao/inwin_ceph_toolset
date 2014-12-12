#!/usr/bin/python
#This is the program for clean all objects in .rgw.buckets pool 
#					                              Frank Li 2014/12/12
#	                                  frank.likuohao@gmail.com
import os
#rados -p .rgw.buckets ls - > allbuckets

os.system("rados -p .rgw.buckets ls - > allbuckets")
#os.system("rados -p data ls - > allbuckets")
#str = os.popen("rados -p .rgw.buckets ls -").read()
#line = str.split("\n")

file = open('allbuckets', 'r')
while True:
 line = file.readline()
 if not line: break
 #print(line)
 #print("rados -p .rgw.buckets  rm %s"%(line))
 os.system("rados -p .rgw.buckets  rm %s"%(line))
 #os.system("rados -p data  rm %s"%(line))
 #print('.')
 print(cmd)
 #os.system(cmd)
 #break
file.close()
