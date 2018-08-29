#coding:utf-8
import os
import re

from sys import stdin
from os import walk
from os.path import join


target_string  = "定时播放"
crontab_file   = "/etc/crontab"
smart_timer_dir= os.getcwd()

# 获取crontab中的原始内容
file_handle = open(crontab_file, 'rb')
for line in file_handle.readlines():
    line = line.strip()

    result = re.search(target_string, line)
    if result:
        print line
        smart_timer_dir = line.split()[7]
        print smart_timer_dir
        print os.path.basename(smart_timer_dir)
        smart_timer_cmd = os.path.basename(smart_timer_dir)
        smart_timer_cmd_split = smart_timer_cmd.split("_")
        print "%s" %(smart_timer_cmd_split)
        smart_timer_cmd_split[1] = smart_timer_cmd_split[1].replace('-', '到')
        smart_timer_cmd_split[1].replace('-', '到')
        read_format = "%s %s %s %s:%s %s %s:%s %s %s文件" %(smart_timer_cmd_split[0], smart_timer_cmd_split[1], \
                                                        smart_timer_cmd_split[2], smart_timer_cmd_split[3], \
                                                        smart_timer_cmd_split[4], smart_timer_cmd_split[5], \
                                                        smart_timer_cmd_split[6], smart_timer_cmd_split[7], \
                                                        smart_timer_cmd_split[8], smart_timer_cmd_split[9])
        #print read_format
        read_cmd = "python3 %s/baidu_tts.py \"%s\"" %(smart_timer_dir, read_format)
        os.system(read_cmd)

file_handle.close()
    
