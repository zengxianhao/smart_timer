# -*- coding:utf-8 -*-  
import json
import urllib2
import datetime
import sys

# 0 weekday
# 1 weekend
# 2 holiday

def check_holiday(date):
    server_url      = "http://api.goseek.cn/Tools/holiday?date="
    vop_url_request = urllib2.Request(server_url+date)
    vop_response    = urllib2.urlopen(vop_url_request)
    vop_data        = json.loads(vop_response.read())

    #print vop_data
    #print "%s %d" %(date, vop_data['data'])
    return vop_data['data']

if __name__ == '__main__':
    date = datetime.datetime.now().strftime('%Y%m%d')
    #date = "20180930"
    retval = check_holiday(date)
    sys.exit(retval)

















