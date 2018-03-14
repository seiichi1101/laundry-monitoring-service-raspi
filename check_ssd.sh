#/bin/sh
ssd_alive=$(/bin/df -m | grep "media")
if [ "$ssd_alive" = "" ] 
then
  echo "ssd doen't alive"
fi
