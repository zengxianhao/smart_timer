#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a very simple example

#echo "Hello World"  

# 删除一个月以前的历史日志，防止日志占满flash空间
#######################################
current_day=`date "+%Y-%m-%d"`
current_time=`date "+%Y-%m-%d %H:%M:%S"`

current_dir=`pwd`

echo $current_dir

log_file_dir="$current_dir/raspberry_log/reboot_log"
log_file_name="$log_file_dir/reboot_log_$current_day"
player=omxplayer
smart_timer_dir="$current_dir"
server_addr="www.baidu.com"

if [[ ! -d $log_file_dir ]];then
    mkdir -p $log_file_dir
fi

#获取30天前的日期
before_day=`date "+%Y-%m-%d" --date="-30 day"`
#需要删除的日志文件的时间戳
before_day_time_stamp=`date -d "$before_day" +%s`

# 删除一个月以前的历史日志，防止日志占满flash空间
for file_a in $log_file_dir/*
do
    result=$(echo $file_a | egrep "$log_file_dir/smart_timer_log_[0-9]+\-[0-9]+\-[0-9]+")
    if [[ "$result" != "" ]]; then
        #echo "file_a = $file_a"
        log_file=`basename $file_a`        
        #echo $log_file
        log_file_time=`echo $log_file | cut -d "_" -f4`
        #echo $log_file_time

        # 历史日志文件对应的时间戳
        log_file_time_stamp=`date -d "$log_file_time" +%s` 

        #echo "before_day_time_stamp = $before_day_time_stamp log_file_time_stamp = $log_file_time_stamp"
        # 删除一个月以前的历史日志
        if [[ $before_day_time_stamp -gt $log_file_time_stamp ]]; then
            #echo "$before_day > $split_file_name"
            current_time=`date "+%Y-%m-%d %H:%M:%S"`
            echo "$current_time  before_day_time_stamp = $before_day_time_stamp log_file_time_stamp = $log_file_time_stamp"   >>  $log_file_name 
            echo "$current_time 删除一个月以前的历史日志 $file_a"                                                                >>  $log_file_name 
            rm -fr $file_a
        fi
    fi
done


#从crontab文件中获取定时重启时间，如果当前重启是"定时重启"触发，则返回1，否则返回2
python $smart_timer_dir/get_reboot_time_from_crontab.py         >>  $log_file_name 

if [[ $? == 2 ]]; then
    # 给音箱供电
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    python $smart_timer_dir/control_electric_raley.py  1
    echo "$current_time 树梅派开机 打开音箱" >> $log_file_name



    # 检测树梅派网络是否配置成功

    sudo ping $server_addr -c 3

    # 如果网络不通，则播放本地录制mp3
    if [[ $? != 0 ]]; then
        current_time=`date "+%Y-%m-%d %H:%M:%S"`
        echo "$current_time 网络不通"           >>  $log_file_name   

        current_time=`date "+%Y-%m-%d %H:%M:%S"`
        echo "$current_time 您好，树梅派网络不通" >> $log_file_name
        $player $smart_timer_dir/network_error.mp3
    else
        #语音播报 开机成功消息
        #ilang  树梅派开机成功
        current_time=`date "+%Y-%m-%d %H:%M:%S"`
        echo "$current_time 您好，树梅派开机成功" >> $log_file_name
        python3 $smart_timer_dir/baidu_tts.py  "您好，树梅派开机成功，哦"

        python  $smart_timer_dir/read_crontab_time.py
    fi



    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    python $smart_timer_dir/control_electric_raley.py  0
    echo "$current_time 树梅派开机 关闭音箱" >> $log_file_name
else
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time 定时自动重启(crontab)静悄悄地开机" >> $log_file_name 
fi





