#coding:utf-8
import os
import re
import time
import string
import sys

from sys import stdin
from os import walk
from os.path import join

do_cmd_usr   = "root"
do_cmd       = "reboot"
crontab_file = "/etc/crontab"



if __name__ == "__main__":
    reboot_time=""

    # 获取crontab中reboot时间
    file_handle = open(crontab_file, 'rb')
    for line in file_handle.readlines():
        result = re.search(do_cmd_usr, line)
        if re.search(do_cmd_usr, line) and re.search(do_cmd, line):
            line_split = line.split()
            reboot_time="%02d%02d" %(string.atoi(line_split[1]), string.atoi(line_split[0]))

    file_handle.close()

    #print "raspberry reboot time  = %s"    %(reboot_time)
    #print "raspberry reboot time  = %s %s" %(line_split[1], line_split[0])
    #print "raspberry current time = %s"    %(time.strftime("%H:%M"))

    reboot_ok_time_h = string.atoi(line_split[1])
    reboot_ok_time_m = string.atoi(line_split[0]) + 10

    if (reboot_ok_time_m >= 60):
        reboot_ok_time_m = reboot_ok_time_m % 60
        reboot_ok_time_h = reboot_ok_time_h + 1

    reboot_ok_time = "%02d%02d" %(reboot_ok_time_h, reboot_ok_time_m) 

    print "%s crontab reboot_time   :%s" %(time.strftime("%Y-%m-%d %H:%M:%S"), reboot_time)
    print "%s crontab reboot_ok_time:%s" %(time.strftime("%Y-%m-%d %H:%M:%S"), reboot_ok_time)
    print "%s raspberry time        :%s" %(time.strftime("%Y-%m-%d %H:%M:%S"), time.strftime("%H%M"))

    #reboot_time="2310"
    #reboot_ok_time="2320"

    if (int(reboot_ok_time) > int(time.strftime("%H%M")) >= int(reboot_time)):
        sys.exit(1)
    else:
        sys.exit(2)

    #if (int(reboot_ok_time) > 1008 > int(reboot_time)):
    #    print "aaaaaaaaaaaaaaaaaaaaaa"


    
