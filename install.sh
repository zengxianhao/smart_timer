#!/bin/bash 

chmod -R 755 *

current_dir=`pwd`

# 删除原来的定时制作脚本
sed -i '/do_smart_timer.sh/d' /etc/crontab

# 添加新的定时器制作脚本
do_smart_timer="*/5 *   * * *   root    cd $current_dir && ./do_smart_timer.sh"
sudo echo "$do_smart_timer" >> /etc/crontab

