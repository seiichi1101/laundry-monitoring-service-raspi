# 参考: https://programming-beginner-zeroichi.jp/articles/249
import time
import picamera
import RPi.GPIO as GPIO

INTERVAL = 5
SLEEPTIME = 1
GPIO_PIN = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_PIN, GPIO.IN)

if __name__ == '__main__':
    try:
        print ("CTRL+C to exit")
        count = 0
        while True:
            count += 1
            if(GPIO.input(GPIO_PIN) == GPIO.HIGH):
                print("detect: ", count)
                with picamera.PiCamera() as camera:
                    camera.resolution = (1024, 768)
                    camera.brightness = 70
                    camera.start_preview()
                    camera.capture('picture.jpg')
            time.sleep(SLEEPTIME)
    except KeyboardInterrupt:
        print("Quit")
    finally:
        GPIO.cleanup()

