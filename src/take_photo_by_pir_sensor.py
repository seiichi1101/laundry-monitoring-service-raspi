# 参考サイト: https://qiita.com/isann_tech/items/778a8fc71a5c57bff72d

import traceback
from functools import wraps
import time
import RPi.GPIO as GPIO
import picamera

__author__ = 'isann'


def wrapper(func):
    @wraps(func)
    def _func(*args, **keywords):
        try:
            func(*args, **keywords)
        except Exception:
            traceback.print_exc()

    return _func


@wrapper
def main():
    sensor_pin = 18
    sleeptime = 5

    GPIO.cleanup()
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(sensor_pin, GPIO.IN)

    cam = picamera.PiCamera()
    cam.resolution = (384, 288)

    try:
        print "App Start"
        print "ctrl+c  :  if you want to stop app"
        while True:
            if (GPIO.input(sensor_pin) == GPIO.HIGH):
                print('shot!!!!')
                filename = time.strftime('%Y%m%d%H%M%S') + '.jpg'
                save_file = '/tmp' + '/' + filename
                cam.capture(save_file)
                time.sleep(sleeptime)
                print('wait...')
            else:
                time.sleep(1)
    except KeyboardInterrupt:
        print "Quit"
    finally:
        print "clean up"
        GPIO.cleanup()

if __name__ in '__main__':
    main()