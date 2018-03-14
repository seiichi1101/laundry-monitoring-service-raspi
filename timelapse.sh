#!/bin/bash
set -eu

echo "start timelapse shell"
while [ `date "+%H"` -ge 5 ];
do
  NOW_DATE=`date "+%Y-%m-%d"`
  NOW_HOUR=`date "+%H"`
  NOW_MIN=`date "+%M"`
  NOW_SEC=`date "+%S"`
  mkdir -p /media/seiichi/laundry_monitoring_service/photos/${NOW_DATE}/${NOW_HOUR} &&
  raspistill -o /media/seiichi/laundry_monitoring_service/photos/${NOW_DATE}/${NOW_HOUR}/${NOW_MIN}-${NOW_SEC}.jpeg -w 240 -h 180 -q 5 &&
  echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Done taking photo"
  sleep 5
done


