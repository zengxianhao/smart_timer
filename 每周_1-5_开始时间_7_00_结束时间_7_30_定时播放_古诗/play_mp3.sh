#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a very simple example

echo "Hello World"  

Folder_A="."
next_play_index_file="play_index.txt"
play_total_file="play_total_file.txt"
next_play_index=0
total_file_cnt=0


# 删除一个月以前的历史日志，防止日志占满flash空间
#######################################
current_day=`date "+%Y-%m-%d"`
current_time=`date "+%Y-%m-%d %H:%M:%S"`

current_dir=`pwd`

echo $current_dir

log_file_dir="$current_dir/../raspberry_log/smart_timer_log"
log_file_name="$log_file_dir/smart_timer_log_$current_day"

if [[ ! -d $log_file_dir ]] ;then
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
        #echo $file_a
        split_file_name=`echo $file_a          | cut -d "/" -f6`
        split_file_name=`echo $split_file_name | cut -d "_" -f4`
        #echo $split_file_name
        # 历史日志文件对应的时间戳
        log_file_time_stamp=`date -d "$split_file_name" +%s` 

        # 删除一个月以前的历史日志
        if [[ $before_day_time_stamp -gt $log_file_time_stamp ]]; then
            #echo "$before_day > $split_file_name"
            current_time=`date "+%Y-%m-%d %H:%M:%S"`
            echo "$current_time 删除一个月以前的历史日志 $file_a"           >>  $log_file_name 
            rm -fr $file_a
        fi
    fi
done



# 保存播放文件个数，如果当前目录没有mp3文件，则退出
#######################################
file_cnt=0

# 搜索mp3文件，统计文件个数
for file_a in ${Folder_A}/*
do
    result=$(echo $file_a | egrep "${Folder_A}/*.mp3$")

    if [[ "$result" != "" ]]; then
        ((file_cnt++))
        #temp_file=`basename $file_a`
        #echo "$current_time file_cnt=$file_cnt, temp_file=$temp_file"         >>  $log_file_name 
    fi
done


if [[ $file_cnt == 0 ]]; then
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time ERROR No mp3 file in current dir = `pwd`"         >>  $log_file_name   
    exit -1
else
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo $file_cnt > $play_total_file
fi

# 获取上次播放序号
#######################################
if [[ -f $next_play_index_file ]];then
    next_play_index=$(cat $next_play_index_file)
fi


# 获取播放文件个数
#######################################
total_file_cnt=$(cat $play_total_file)

echo "$current_time 当前目录文件总数: $total_file_cnt"   >> $log_file_name
echo "$current_time 上一次播放结束时预期播放的一下首歌曲序号:$next_play_index"  >> $log_file_name

# 播放序号保护
if [[ $next_play_index -ge $total_file_cnt ]]; then
    next_play_index=0
fi

echo "$current_time 本次播放需要播放的歌曲序号:$next_play_index"  >> $log_file_name


# 给音箱供电
echo "$current_time 打开音箱" >> $log_file_name
python control_electric_raley.py  1

#######################################
play_index=0  
while true
do
    for file_a in ${Folder_A}/*.mp3 
    do
        #temp_file=`basename $file_a`    
        #echo $temp_file
        #echo $file_a
        
        # 从上次关闭程序时所播放的文件处开始继续播放        
        if [[ $play_index -ge $next_play_index ]]; then
            current_time=`date "+%Y_%m_%d %H:%M:%S"`
            echo "$current_time 播放文件: $play_index, $file_a"     >> $log_file_name
	        omxplayer $file_a
            echo "$current_time 播放文件: $play_index, $file_a OK"  >> $log_file_name

            #保存下一曲编号
            ((play_index++))
            play_index=$(( $play_index%$total_file_cnt ))
            
            current_time=`date "+%Y_%m_%d %H:%M:%S"`
            echo "$current_time 下一首播放序号: $play_index"  >> $log_file_name            
            echo $play_index > $next_play_index_file

            #本次播放一轮循环完毕后需要从头开始播放,所以需要刷新next_play_index            
            if [[ $play_index == 0 ]]; then
                next_play_index=$(cat $next_play_index_file)
            fi
        else
            current_time=`date "+%Y_%m_%d %H:%M:%S"`
            echo "$current_time  搜索下一个需要播放的文件 next_play_index = $next_play_index, play_index = $play_index"  >> $log_file_name         
            ((play_index++))
        fi
    done
done
