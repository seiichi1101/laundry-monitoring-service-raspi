#!/bin/bash
#NOW_TIME=`date "+%Y-%m-%d_%H:%M:%S"`
raspistill --nopreview -w 640 -h 480 -q 20 -o photos/`date +%Y-%m-%d_%H:%M:%S`.jpeg -t 9999999 -tl 650 -th 0:0:0
