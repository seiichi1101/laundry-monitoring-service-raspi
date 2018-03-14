#!/bin/sh

#set -eu

echo "start timelapse shell"

#while true;
while [ `date "+%H"` -ge 6 ];
do
	NOW_DATE=`date "+%Y-%m-%d"`
	NOW_HOUR=`date "+%H"`
	NOW_MIN=`date "+%M"`
	NOW_SEC=`date "+%S"`
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Start taking photo" && 
	mkdir -p /tmp/laundry_monitoring_service/ &&
	raspistill -o /tmp/laundry_monitoring_service/${NOW_MIN}-${NOW_SEC}.jpeg -w 320 -h 240 -q 10 &&
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Done taking photo" && 
#	sleep 3 &&
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Start gzip photo" && 
	/bin/gzip /tmp/laundry_monitoring_service/${NOW_MIN}-${NOW_SEC}.jpeg &&
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Done gzip photo" && 
#	sleep 3 &&
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Start uploading photo" &&
	/usr/local/bin/aws s3 cp /tmp/laundry_monitoring_service/${NOW_MIN}-${NOW_SEC}.jpeg.gz s3://laundry-monitoring-service-storage-prod/photos/${NOW_DATE}/${NOW_HOUR}/${NOW_MIN}-${NOW_SEC}.jpeg.gz --acl public-read --content-encoding "gzip" --region ap-northeast-1 --endpoint-url http://s3-accelerate.amazonaws.com &&
	/bin/rm /tmp/laundry_monitoring_service/${NOW_MIN}-${NOW_SEC}.jpeg.gz &&
	echo `/bin/date "+%Y-%m-%d %H:%M:%S"` ": Done uploading photo" 
done

