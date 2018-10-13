#!/usr/bin/env python
#-*- encoding: utf-8 -*-

import os
import re

from sys import stdin
from os import walk
from os.path import join
target = ".mp3"

file_index = 0

for root, dirs, files in walk('.'):
    for file_name in files:
        if target in file_name: 
            src = (join(root, file_name))

            file_index = file_index + 1
            target_index = "%03d" %(file_index)

            result = re.search("^\d+", file_name)

            # 如果文件名没有数字编号，则添加数字编号
            if result:
                #print "group(0) %s" %result.group(0)
                #print "group(1) %s" %result.group(1)
                #print "group(2) %s" %result.group(2)

                print "%s has num index!" %file_name
            else:
                file_name = "%03d_%s" %(file_index, file_name)
                dst= (join(root, file_name))
                
                cmd = "mv %s %s" %(src, dst)
                print cmd
                os.system(cmd)



            


#if __name__ == "__main__":  
#    search(name="mp3")  
