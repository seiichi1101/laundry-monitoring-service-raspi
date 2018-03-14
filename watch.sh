#!/bin/sh
set -eu

echo `date` ": start watch shell"

while [ `date "+%H"` -ge 5 ];
do
  msg=`inotifywait -r -e CREATE /media/seiichi/laundry_monitoring_service/photos/ | sed -e 's/~//g'` &&
  echo ${msg} | grep '\<.*jpeg\>$' &&
  {
    echo `/bin/date "+%Y-%m-%d %H:%M:%S "` 'success_msg: ' ${msg}
    args1=`echo ${msg} | sed -e 's/ //g' -e 's/~//g' -e 's/CREATE//g' -e 's/.jpeg//g' | awk -F "photos" '{print$1}'` 
    args2=`echo ${msg} | sed -e 's/ //g' -e 's/~//g' -e 's/CREATE//g' -e 's/.jpeg//g' | awk -F "photos" '{print"photos"$2}'` 
    echo 'args1: ' ${args1}
    echo 'args2: ' ${args2}
    /home/seiichi/laundry-monitoring-raspi/upload_photos.sh ${args1} ${args2} & 
  } ||
  echo `/bin/date "+%Y-%m-%d %H:%M:%S "` 'failure_msg: ' ${msg}
done
