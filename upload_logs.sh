#!/bin/bash
set -eu
/usr/bin/curl inet-ip.info -o /media/seiichi/laundry_monitoring_service/logs/gip &&
/usr/local/bin/aws s3 cp /media/seiichi/laundry_monitoring_service/logs s3://laundry-monitoring-service-storage-prod/logs --recursive
