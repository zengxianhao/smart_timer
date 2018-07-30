#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a very simple example

echo Hello World

current_day=`date "+%Y-%m-%d"`
current_time=`date "+%Y-%m-%d %H:%M:%S"`

log_file_name="/home/pi/raspberry_log/smart_timer_log/smart_timer_log_$current_day"

# 音箱断电
echo "$current_time 关闭音箱"         >> $log_file_name
python control_electric_raley.py  0

# 关闭播放程序
echo "$current_time 关闭 play_mp3.sh" >> $log_file_name
echo "$current_time 关闭 omplayer"    >> $log_file_name
pkill play_mp3.sh
pkill omxplayer
