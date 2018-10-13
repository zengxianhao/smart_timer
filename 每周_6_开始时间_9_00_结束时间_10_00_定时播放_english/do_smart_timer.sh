#!/bin/bash  
  

u_disk_path="/media/pi"
dst_root_path="/home/pi/smart_timer"

total_file_size=0
has_new_file_to_copy=0
copy_timer_file=0

# 查看U盘中是否存在规定格式的文件
# 如果拷贝已经完成，并且U盘已经移除，将不再定时拷贝并刷新crontab定时任务
# 如果拷贝内容大于剩余空间则仅拷贝部分内容
for u_disk_dev in ${u_disk_path}/*
do
    if [[ -d $u_disk_dev ]]  
    then
        for src_path in $u_disk_dev/*
        do
            target="定时播放"
            if [[ $src_path == *$target* ]]; then
                echo "src_path = $src_path"
                # 计算文件大小
                file_size=`du -b $src_path | awk '{print int($1/1048576)}'`
                echo "file_size = $file_size"
                ((total_file_size=total_file_size+file_size))
                
                # 比较U盘和树梅派中播放文件是否相同
                timer_dir_name=`basename $src_path`
                if [[ -d $dst_root_path/$timer_dir_name ]]; then 
                    echo "diff -a $src_path $dst_root_path/$timer_dir_name"
                    diff -ra $src_path $dst_root_path/$timer_dir_name
                    if [[ $? != 0 ]]; then
                        has_new_file_to_copy=1
                    fi
                else
                    has_new_file_to_copy=1                    
                fi 
                
            fi
        done

    fi
done

echo "total_file_size      = $total_file_size MBytes"
echo "has_new_file_to_copy = $has_new_file_to_copy"

# 如果有文件且大小小于2G，U盘中有新文件需要拷贝
if [[ $total_file_size != 0 ]] && [[ $total_file_size -le 2000 ]] && [[ 1 == $has_new_file_to_copy ]];then
    copy_timer_file=1
fi

# 如果没有需要拷贝的文件，则退出
if [[ $copy_timer_file == 0 ]];then
    exit
fi


# 删除树梅派中的原有播放文件
for dist_dir_name in ${dst_root_path}/*
do
    if [[ -d $dist_dir_name ]];then
        echo "rm -fr $dist_dir_name"
        rm -fr $dist_dir_name
    fi
done


chmod +x *.py
chmod +x *.sh

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

# root用户给所有用户增加全部权限
chmod -R 777 $dst_root_path

# 备份定时配置文件
cp /etc/crontab  /etc/crontab.bak
# 设置定时器任务
python modify_etc_crontab.py
# 重新启动定时器任务
sudo /etc/init.d/cron restart


#echo "end"

 
