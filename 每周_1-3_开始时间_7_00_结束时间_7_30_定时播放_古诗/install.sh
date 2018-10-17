#!/bin/bash 

chmod -R 755 *

current_dir=`pwd`

sudo python config_wireless_network.py

for file_a in $current_dir/*
do
    result=$(echo $file_a | egrep "每周")
    if [[ "$result" != "" ]]; then

        rm -fr $file_a/play_index.txt
        rm -fr $file_a/play_total_file.txt
        rm -fr $file_a/raspberry_log

        cp *.sh $file_a
        cp *.py $file_a
    fi
done


echo "install omxplayer"
apt-get install omxplayer

echo "config /etc/crontab"

# 备份定时配置文件
cp /etc/crontab  /etc/crontab.bak

# 删除原来的定时制作脚本
sed -i '/do_smart_timer.sh/d' /etc/crontab

# 添加新的定时器制作脚本
do_smart_timer="*/5 *   * * *   root    cd $current_dir && ./do_smart_timer.sh"
echo "$do_smart_timer" >> /etc/crontab

# 设置定时器任务
python modify_etc_crontab.py
# 重新启动定时器任务
/etc/init.d/cron restart

echo "Smart Timer Install OK!"


