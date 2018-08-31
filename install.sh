#!/bin/bash 

chmod -R 755 *

current_dir=`pwd`

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


