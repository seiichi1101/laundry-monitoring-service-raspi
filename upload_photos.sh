#!/bin/bash
set -eu

sleep 5 &&
echo "start gzip" &&
/bin/gzip ${1}${2}.jpeg &&
echo "start uploading to s3" &&
/usr/local/bin/aws s3 cp ${1}${2}.jpeg.gz s3://laundry-monitoring-service-storage-prod/${2}.jpeg.gz --acl public-read --content-encoding "gzip"
