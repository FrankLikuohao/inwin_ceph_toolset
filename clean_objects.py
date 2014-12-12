#!/usr/bin/python
#This is the program for clean all objects in pool which you input
#					Frank Li 2014/12/12
#					frank.likuohao@gmail.com

def file_lines(full_path):
  """ Count number of lines in a file."""
  f = open(full_path)
  nr_of_lines = sum(1 for line in f)
  f.close()
  return nr_of_lines

import os
import sys

print sys.argv

#check the parameter
if len(sys.argv)  <= 1:
	os.system("ceph df")
	print("please input a pool name")
	print("ex: %s  .rgw.buckets"%sys.argv[0])
	sys.exit()

poolname = sys.argv[1]
#sys.exit()
tmpfile='/tmp/all_objects_list'

#cerate list
cmd_create_list="rados -p " + poolname +" ls - >" + tmpfile  
print("create list [%s]"%cmd_create_list)
os.system(cmd_create_list)
#sys.exit()

num_objs = file_lines(tmpfile)
print("total objects in pool [%s]  = [%d]"%(poolname,num_objs))
#sys.exit()

file = open(tmpfile, 'r')
while True:
 line = file.readline().rstrip('\n')
 if not line: break
 #print(line)
 cmd_del_a_obj="rados -p " + poolname  + " rm " + line    
 print("%d object [%s] deleted"%(num_objs,cmd_del_a_obj))
 num_objs=num_objs-1
 os.system(cmd_del_a_obj)
 #break
file.close()
