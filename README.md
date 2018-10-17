git clone https://github.com/zengxianhao/smart_timer

sudo chmod +x *

sudo ./install.sh



文件目录说明
------------------------------------------
install.sh                      // 安装smart_timer
network.sh                      // 配置wifi密码
wifi.txt                        // wifi设备和密码
do_smart_timer.sh               // 检测U盘，拷贝播放文件，配置定时文件，install.sh将会把该脚本配置crontab文件中定时执行
README.md                       // readme
play_mp3.sh                     // 开始播放音乐
stop_mp3.sh                     // 停止播放音乐
add_num.py                      // 给播放文件编号，do_smart_timer.sh调用
del_num.py                      // 删除原有编号，do_smart_timer.sh调用
baidu_tts.py                    // 文字转换成语音(需要网络)
check_holiday.py                // 检查法定节假日(需要网络)，play_mp3.sh调用
config_wireless_network.py      // 配置网络，network.sh调用
control_electric_raley.py       // 控制继电器，play_mp3.sh 
get_reboot_time_from_crontab.py // 获取树梅派自动重启时间
modify_etc_crontab.py           // 配置定时文件
network_error.mp3               // 网络异常语音播放文件
raspberry_start_up.sh           // 树梅派启动自动执行脚本，如果设置的自动重启触发的重启，将不进行语音播放
read_crontab_time.py            // 获取定时闹钟执行时间
crontab
raspberry_log                   // 日志目录
每周_1-3_开始时间_7_00_结束时间_7_30_定时播放_古诗      // 播放文件目录
每周_4-5_开始时间_7_00_结束时间_7_30_定时播放_english
每周_6_开始时间_9_00_结束时间_10_00_定时播放_古诗
每周_7_开始时间_9_00_结束时间_10_00_定时播放_english

