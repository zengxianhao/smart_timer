#!/usr/bin/env python
#-*- encoding: utf-8 -*-

import os
import re

from sys import stdin
from os import walk
from os.path import join
target = ".mp3"


for root, dirs, files in walk('.'):
    for file_name in files:
        # 搜索后缀为.mp3的文件
        if target in file_name: 
            src = (join(root, file_name))

            # 如果有数字编号，则删除数字编号
            result = re.search("^\d+", file_name)
            if result:
                # 搜索文件名开始的数字编号，并删除掉数字编号
                result = re.search("([0-9]*)_*(.*)", file_name)
                if result:
                    #print "group(0) %s" %result.group(0)
                    #print "group(1) %s" %result.group(1)
                    #print "group(2) %s" %result.group(2)
                    # 获取去掉数字编号后的文件名
                    file_name = result.group(2)
                    #print file_name
                    dst= (join(root, file_name))
                    
                    cmd = "mv %s %s" %(src, dst)
                    print cmd
                    os.system(cmd)



            


#if __name__ == "__main__":  
#    search(name="mp3")  
