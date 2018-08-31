#!/bin/bash 

chmod -R 755 *

current_dir=`pwd`

echo "config /etc/crontab"

# 备份定时配置文件
cp /etc/crontab  /etc/crontab.bak

# 删除原来的定时制作脚本
sed -i '/do_smart_timer.sh/d' /etc/crontab

# 添加新的定时器制作脚本
do_smart_timer="*/5 *   * * *   root    cd $current_dir && ./do_smart_timer.sh"
echo "$do_smart_timer" >> /etc/crontab

#python control_electric_raley.py 1
# 设置定时器任务
python modify_etc_crontab.py
# 重新启动定时器任务
/etc/init.d/cron restart

echo "Smart Timer Install OK!"

#python3  baidu_tts.py  "定时播放闹钟如下：好"
# 根据crontab文件播报定时闹钟时间
#python read_crontab_time.py

#python3  baidu_tts.py  "您好，树梅派定时闹钟设置完毕，再见，好"

#python control_electric_raley.py 0

