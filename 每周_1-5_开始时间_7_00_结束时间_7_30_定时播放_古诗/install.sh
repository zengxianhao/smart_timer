#!/bin/bash 

chmod -R 755 *

current_dir=`pwd`

do_smart_timer="*/5 *   * * *   root    cd $current_dir && ./do_smart_timer.sh"

grep "$do_smart_timer" /etc/crontab

if [[ $? != 0 ]]
then
    sudo echo "$do_smart_timer" >> /etc/crontab
fi
