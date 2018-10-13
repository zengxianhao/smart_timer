#!/user/bin/python
# -*- coding: UTF-8 -*-
# like this use: python gpiotest.py 1 or 0

import sys
import RPi.GPIO as GPIO
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

args = sys.argv
pin = 17   # 这里的pin = 17 为 BCM 编码 的 17 ，树莓派的第11号口，wiringPi的0
ct1 = args[1]

# 继电器接通了NO1，COM1
# 继电器断电
if (int(ct1) == 0):
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin,GPIO.HIGH)

# 继电器通电 
if (int(ct1) == 1):
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin,GPIO.LOW)
