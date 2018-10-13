#coding:utf-8
import os
import re

from sys import stdin
from os import walk
from os.path import join

target_dir   = "/home/pi/smart_timer"
target_name  = "定时播放"
do_cmd_usr   = " pi "
crontab_file = "/etc/crontab"

add_crontab_content = ""
old_crontab_content = ""


for root, dirs, files in walk(target_dir):
    for dir_name in dirs:
        #print dir_name
        if target_name in dir_name:
            full_dir_name = (join(root, dir_name))
            #print dir_name
            #dir_name_split = dir_name.split('每周')
            result = re.search("(每周)_(.*)_(开始时间)_(.*)_(结束时间)_(.*)_(定时播放)", dir_name)
            if result:
                #print result.group(0)
                #print result.group(1)
                #print result.group(2)
                #print result.group(3)
                #print result.group(4)
                #print result.group(5)
                #print result.group(6)

                week       = result.group(2)
                start_time = result.group(4)
                end_time   = result.group(6)

                print week
                print start_time
                print end_time

                week = week.replace("_", ",")
                print "week = %s" %(week)

                # 组织定时启动命令
                start_time_hour   = start_time.split('_')[0]
                start_time_minute = start_time.split('_')[1]
                print "start_time_hour = %s, start_time_minute = %s" %(start_time_hour, start_time_minute)

                start_cmd = "cd %s && ./play_mp3.sh" %(full_dir_name)
                print start_cmd
                start_crontab = "%s %s * * %s %s %s\n" %(start_time_minute, start_time_hour, week, do_cmd_usr, start_cmd)
                print start_crontab

                add_crontab_content = add_crontab_content + start_crontab

                # 组织定时关闭命令
                end_time_hour   = end_time.split('_')[0]
                end_time_minute = end_time.split('_')[1]

                print "end_time_hour = %s, end_time_minute = %s" %(end_time_hour, end_time_minute)

                stop_cmd = "cd %s && ./stop_mp3.sh" %(target_dir)
                print stop_cmd
                stop_crontab = "%s %s * * %s %s %s\n" %(end_time_minute, end_time_hour, week, do_cmd_usr, stop_cmd)
                print stop_crontab

                add_crontab_content = add_crontab_content + stop_crontab


            #print dir_name_split
            
            #print full_dir_name

# 获取crontab中的原始内容
file_handle = open(crontab_file, 'rb')
for line in file_handle.readlines():
    line = line.strip()
    if not len(line) or line.startswith('#'):
        continue
    #print line
    result = re.search(do_cmd_usr, line)
    if not result:
        #print line.strip()
        old_crontab_content = old_crontab_content + line + "\n"
        
old_crontab_content = old_crontab_content + "\n"        
file_handle.close()
     

print old_crontab_content
#print "+++++++++++++++++++++++++"
print add_crontab_content


file_handle = open(crontab_file,'w')
file_handle.write(old_crontab_content)
file_handle.write(add_crontab_content)
file_handle.close()


#if __name__ == '__main__':


#55 6     * * 0,2,4   root    cd /home/pi/zengxiaolong/music/poetry  && ./play_mp3.bash
#40 7     * * 0,2,4   root    cd /home/pi/zengxiaolong/music/poetry  && ./stop_mp3.bash
    
