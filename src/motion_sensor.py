# 参考: https://programming-beginner-zeroichi.jp/articles/249
import time
import picamera
import gzip
from datetime import datetime, timezone, timedelta
import RPi.GPIO as GPIO
from PIL import Image

INTERVAL = 5
SLEEPTIME = 1
GPIO_PIN = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_PIN, GPIO.IN)
JST = timezone(timedelta(hours=+9), 'JST') 

def take_photo():
    with picamera.PiCamera(file_name) as camera:
        camera.resolution = (1024, 768)
        # camera.brightness = 70
        # camera.start_preview()
        camera.capture(f'{file_name}.jpg')

def gzip_png(file_name):
    with open(f"{file_name}.png", "rb").read() as ima:
        t = zlib.compress(img)

if __name__ == '__main__':
    try:
        print ("CTRL+C to exit")
        count = 0
        while True:
            count += 1
            if(GPIO.input(GPIO_PIN) == GPIO.HIGH):
                print("detect num: ", count)
                current_datetime = datetime.now(JST).strftime("%Y/%m/%d/%H/%M-%S")
                take_photo(current_datetime)
                gzip_png(file_name)
            time.sleep(SLEEPTIME)
    except KeyboardInterrupt:
        print("Quit")
    finally:
        GPIO.cleanup()

