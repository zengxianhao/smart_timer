#coding:utf-8
import os
import re

from sys import stdin
from os import walk
from os.path import join

ssid = "TP-LINK_A258E2"
psk  = "ZxL@20178A+"

network_config_file_1 = "/etc/network/interfaces"
network_config_file_2 = "/etc/wpa_supplicant/wpa_supplicant.conf"

def modify_interfaces(network_config_file_1):
    file_handle = open(network_config_file_1, 'rb')
    file_content=""
    for line in file_handle.readlines():
        if re.search("wlan0", line) or re.search("wpa_supplicant.conf", line):
            print ""
        else:
            file_content += line
    file_handle.close()

    file_content += "allow-hotplug wlan0                                     //允许-热插拔 wlan0\n"
    file_content += "iface wlan0 inet manual                                 //设置wlan0为状态遵循手册\n"
    file_content += "    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf    //wpa协议文件的位置\n"

    file_handle = open(network_config_file_1,'w')
    file_handle.write(file_content)
    file_handle.close()


    bash_cmd = "more %s" %(network_config_file_1)
    print bash_cmd
    print "++++++++++++++++++++++++++++++++++++++"
    os.system(bash_cmd)

def modify_wpa_supplicant(network_config_file_2):
    file_handle = open(network_config_file_2, 'rb')
    file_content=""
    for line in file_handle.readlines():
        if re.search("ssid=", line):
            file_content += "       ssid=%s\n" %(ssid)
        elif re.search("psk=", line):
            file_content += "       psk=%s\n" %(psk)
        else:
            file_content += line
    file_handle.close()

    file_handle = open(network_config_file_2,'w')
    file_handle.write(file_content)
    file_handle.close()

    bash_cmd = "more %s" %(network_config_file_2)
    print bash_cmd
    print "++++++++++++++++++++++++++++++++++++++"
    os.system(bash_cmd)


if __name__ == "__main__":

    modify_interfaces(network_config_file_1)
    print "\n\n"
    modify_wpa_supplicant(network_config_file_2)










