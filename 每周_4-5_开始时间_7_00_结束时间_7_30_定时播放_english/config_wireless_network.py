#coding:utf-8
import os
import re

from sys import stdin
from os import walk
from os.path import join

fixed_content = \
"network={\n" + \
"   ssid=\"zxl-iPhone\"\n" + \
"   psk=\"12345678\"\n"    + \
"   key_mgmt=WPA-PSK\n"    + \
"}\n" 

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
    file_handle = open("wifi.txt", 'rb')
    lines = file_handle.readlines()    
    file_handle.close()
    
    ssid = lines[0].strip()
    psk  = lines[1].strip()

    file_handle = open(network_config_file_2, 'rb')
    lines = file_handle.readlines()    
    file_handle.close()

    file_content=""
    for i in range(0, len(lines)):
        if (i < 2):
            file_content += lines[i]

    #print "#######################################"
    #print  file_content   
    #print "#######################################"

    file_content += "network={\n"
    file_content += "   ssid=\"%s\"\n" %(ssid)
    file_content += "   psk=\"%s\"\n"  %(psk)
    file_content += "   key_mgmt=WPA-PSK\n"
    file_content += "}\n" 
    file_content += fixed_content

    file_handle = open(network_config_file_2,'w')
    file_handle.write(file_content)
    file_handle.close()

    bash_cmd = "more %s" %(network_config_file_2)
    print bash_cmd
    print "++++++++++++++++++++++++++++++++++++++"
    #print file_content
    os.system(bash_cmd)


if __name__ == "__main__":

    modify_interfaces(network_config_file_1)
    print "\n\n\n"
    modify_wpa_supplicant(network_config_file_2)










