# 参考: https://programming-beginner-zeroichi.jp/articles/249
import io
import time
import picamera
import gzip
import boto3
import shutil
import zlib
import os
from datetime import datetime, timezone, timedelta
import RPi.GPIO as GPIO
from PIL import Image

INTERVAL = 5
SLEEPTIME = 1
GPIO_PIN = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_PIN, GPIO.IN)
JST = timezone(timedelta(hours=+9), 'JST') 

s3_client = boto3.client('s3', region_name='ap-northeast-1')

def take_photo(stream, file_name):
    print("...taking photo")
    with picamera.PiCamera() as camera:
        camera.resolution = (1024, 768)
        # camera.brightness = 70
        # camera.start_preview()
        # camera.capture(f'photos/{file_name}.png')
        camera.capture(stream, 'png')

def compress_png(stream, file_name):
    print("...compressing photo")
    target=f'photos/{file_name}.png'
    with open(target, 'rb') as img:
        t = zlib.compress(img.read())

def upload_photo(stream, file_name):
    print("...uploading photo")
    stream.seek(0)
    key_prefix=file_name.replace("-","/")
#    s3_client.upload_file(
#            f'photos/{file_name}.png',
#            'laundry-monitoring-service-storage-prod',
#            f'photos/{key_prefix}.png',
#            ExtraArgs={
#                'ACL': 'public-read',
#                'ContentType': 'png',
#            }
#        )
    s3_client.upload_fileobj(
            stream,
            'laundry-monitoring-service-storage-prod',
            f'photos/{key_prefix}.png',
            ExtraArgs={
                'ACL': 'public-read',
                'ContentType': 'png'
            }
        )

if __name__ == '__main__':
    try:
        print ("CTRL+C to exit")
        start = time.time()
        while True:
            if(GPIO.input(GPIO_PIN) == GPIO.HIGH):
                print("elapsed_time: ", int(time.time()-start))
                stream = io.BytesIO()
                current_datetime = datetime.now(JST).strftime("%Y-%m-%d-%H-%M-%S")
                take_photo(stream, current_datetime)
                # compress_png(stream, current_datetime)
                upload_photo(stream, current_datetime)
                print("...removing photo")
                # shutil.rmtree('./photos/')
                # os.mkdir('photos')
                stream.close()
#            time.sleep(SLEEPTIME)
    except KeyboardInterrupt:
        print("Quit")
    finally:
        GPIO.cleanup()

