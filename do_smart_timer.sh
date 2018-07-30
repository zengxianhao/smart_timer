#!/bin/bash  
  

u_disk_path="/media/pi"
dst_root_path="/home/pi/smart_timer"

total_file_size=0
has_new_file_to_copy=0
copy_timer_file=0


current_day=`date "+%Y-%m-%d"`

log_file_dir="/home/pi/raspberry_log/smart_timer_log"
log_file_name="$log_file_dir/smart_timer_log_$current_day"
u_disk_cnt=0
#echo $log_file_name


# 查看U盘中是否存在规定格式的文件
# 如果拷贝已经完成，并且U盘已经移除，将不再定时拷贝并刷新crontab定时任务
# 如果拷贝内容大于剩余空间则仅拷贝部分内容
for u_disk_dev in ${u_disk_path}/*
do
    if [[ -d $u_disk_dev ]]  
    then
        #echo $u_disk_cnt
        u_disk_cnt=$((u_disk_cnt+1))
        if [[ $u_disk_cnt == 1 ]];then
            #echo $u_disk_cnt
            current_time=`date "+%Y-%m-%d %H:%M:%S"`
            echo "$current_time 发现U盘，打开音箱"              >> $log_file_name
            python control_electric_raley.py 1
            python3  baidu_tts.py  "您好，树梅派发现U盘，好"
        fi

        for src_path in $u_disk_dev/*
        do
            target="定时播放"
            if [[ $src_path == *$target* ]]; then
                python3  baidu_tts.py  "您好，树梅派发现格式正确的定时播放目录，好"
                echo "src_path = $src_path"

                # 计算目录大小
                file_size=`du -b $src_path | awk '{print int($1/1048576)}'`
                echo "file_size = $file_size"
                ((total_file_size=total_file_size+file_size))
                
                # 比较U盘和树梅派中播放文件是否相同
                timer_dir_name=`basename $src_path`
                if [[ -d $dst_root_path/$timer_dir_name ]]; then 
                    python3  baidu_tts.py  "您好，树梅派开始做目录比对，可能比较耗时，请稍等，好"
                    echo "diff -a $src_path $dst_root_path/$timer_dir_name"
                    #diff -ra $src_path $dst_root_path/$timer_dir_name
                    if [[ $? != 0 ]]; then
                        python3  baidu_tts.py  "您好，树梅派发现需要拷贝的定时播放目录，好"
                        has_new_file_to_copy=1
                    fi
                else
                    python3  baidu_tts.py  "您好，树梅派发现需要拷贝的定时播放目录，好"
                    has_new_file_to_copy=1                    
                fi 
                
            fi
        done
    fi
done

if [[ $u_disk_cnt == 0 ]];then
    exit
fi 

# 发现U盘，发现定时播放目录，但是由于定时播放目录中的文件大于3G，禁止拷贝
if [[ $total_file_size -gt 3000 ]] && [[ 1 == $has_new_file_to_copy ]];then
    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time 需要拷贝的定时播放文件大小$total_file_size，大于3000M，不予拷贝"       >>  $log_file_name
    python3  baidu_tts.py  "您好，U盘中的MP3文件大于3G，禁止拷贝，请重新制作定时播放文件，好"

    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time 关闭音箱"                    >> $log_file_name
    python control_electric_raley.py 0

    exit
fi


# 发现U盘，但是U判中无定时播放目录，则退出
if [[ $u_disk_cnt != 0 ]] && [[ $total_file_size == 0 ]] ;then

    echo "$current_time 发现U盘，但是U盘中无定时播放目录，则退出" >> $log_file_name

    python3  baidu_tts.py  "您好，U盘中没有定时播放文件，请重新拷贝新的播放文件，否则请拔掉U盘，好"

    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time 关闭音箱"                    >> $log_file_name

    python control_electric_raley.py 0
    exit
fi

#发现U盘，且发现定时播放目录，但是由于定时播放文件已经拷贝成功，则退出
if [[ $u_disk_cnt != 0 ]] && [[ $total_file_size != 0 ]]  && [[ $has_new_file_to_copy == 0 ]];then 
    echo "$current_time 发现U盘，且发现定时播放目录，但是由于定时播放文件已经拷贝成功，则退出" >> $log_file_name

    python3  baidu_tts.py  "您好，定时播放目录之前已经拷贝过了，本次不需要拷贝，请拔掉U盘，好"

    current_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$current_time 关闭音箱"                    >> $log_file_name

    python control_electric_raley.py 0

    #current_time=`date "+%Y-%m-%d %H:%M:%S"`
    #echo "$current_time U盘中没有定时播放文件或者定时文件已经拷贝" >> $log_file_name
    #espeak -vzh U盘中没有定时播放文件，请重新拷贝新的播放文件，否则请拔掉U盘
    #echo "$current_time 关闭音箱" >> $current_day
    #python control_electric_raley.py 0
    exit
fi


#echo "$current_time 开始播放Bressanon.mp3" >> $log_file_name
#omxplayer Bressanon.mp3 &


python3  baidu_tts.py  "您好，树梅派开始制作定时闹钟，好"

dist_dir_cnt=0

# 删除树梅派中的原有播放文件
for dist_dir_name in ${dst_root_path}/*
do
    if [[ -d $dist_dir_name ]];then
        dist_dir_cnt=$((dist_dir_cnt+1))
        if [[ $dist_dir_cnt == 1 ]];then
            python3  baidu_tts.py  "您好，树梅派开始删除原有定时播放文件，好"
        fi

        echo "rm -fr $dist_dir_name"
        rm -fr $dist_dir_name
        current_time=`date "+%Y-%m-%d %H:%M:%S"`
        echo "$current_time 删除树梅派中的原有播放文件 $dist_dir_name" >> $log_file_name
    fi
done







chmod +x *.py
chmod +x *.sh

copy_dir_cnt=0

#espeak -vzh 开始拷贝U盘中的定时播放文件
# 将U盘的定时播放目录拷贝到树梅派指定目录，给目录拷贝播放脚本，并修改读写权限
for u_disk_dev in ${u_disk_path}/*
do
    if [[ -d $u_disk_dev ]]  
    then  
        #echo "disk existed"     
        #echo $file_a
        
        for src_path in $u_disk_dev/*
        do
            target="定时播放"
            #echo $file_name
            if [[ $src_path == *$target* ]]; then

                copy_dir_cnt=$((copy_dir_cnt+1))
                if [[ $copy_dir_cnt == 1 ]]; then
                    python3  baidu_tts.py  "您好，树梅派开始拷贝定时播放文件，请勿拔掉U盘，好"
                fi

                # copy tools to src_path
                echo "cp *.py $src_path"
                cp *.py $src_path
                echo "cp *.sh $src_path"
                cp *.sh $src_path         

                # 给音乐文件编号
                cd $src_path
                python del_num.py
                python add_num.py
                cd -
                
                echo "cp -r $src_path $dst_root_path"
                cp -r $src_path $dst_root_path

                # root用户给所有用户增加全部权限
                #timer_dir_name=`basename $src_path`
                #chmod -R 777 $dst_root_path/$timer_dir_name
            fi
        done

    fi
done

python3  baidu_tts.py  "您好，树梅派定时播放文件拷贝完毕，好"
current_time=`date "+%Y-%m-%d %H:%M:%S"`
echo "$current_time 拷贝U盘中的定时播放文件拷贝完毕" >> $log_file_name

# root用户给所有用户增加全部权限
chmod -R 777 $dst_root_path

#espeak -vzh 设置定时播放任务

# 备份定时配置文件
sudo cp /etc/crontab  /etc/crontab.bak
# 设置定时器任务
sudo python modify_etc_crontab.py
# 重新启动定时器任务
sudo /etc/init.d/cron restart

python3  baidu_tts.py  "您好，树梅派定时播放任务设置完毕，好"
python3  baidu_tts.py  "定时播放闹钟如下：好"
# 根据crontab文件播报定时闹钟时间
python read_crontab_time.py

python3  baidu_tts.py  "您好，树梅派定时闹钟设置完毕，请拔掉U盘，再见，好"

current_time=`date "+%Y-%m-%d %H:%M:%S"`
echo "$current_time 设置定时播放任务"             >> $log_file_name

#espeak -vzh 定时播放任务设置完毕，请拔掉U盘

current_time=`date "+%Y-%m-%d %H:%M:%S"`
echo "$current_time 关闭音箱"                    >> $log_file_name
python control_electric_raley.py 0
#echo "$current_time 停止播放Bressanon.mp3"       >> $log_file_name
#pkill omxplayer

#echo "end"

 
