#!/bin/sh
ppp_alive=$(/sbin/ifconfig | grep "ppp0")
if [ "$ppp_alive" = "" ]
then
	HUB=`/usr/bin/lsusb -v 2>/dev/null | grep ^Bus | grep "LG Electronics, Inc. Ally/Optimus One"`
	BUS=`echo $HUB | awk '{print $2}'`
	DEV=`echo $HUB | awk '{print $4}' | sed -e "s/\(.*\)\:/\1/p;d"`
	for i in 1 2 3 4
	do
		echo '[POWER_OFF] p=0,  BUS:'${BUS}', DEV:'${DEV}', i:'${i}
		/home/seiichi/laundry-monitoring-raspi/hub-ctrl -b $BUS -d $DEV -P $i -p 0
	done
	sleep 20
	for i in 1 2 3 4
	do
		echo '[POWER_ON] p=1  BUS:'${BUS}', DEV:'${DEV}', i:'${i}
		/home/seiichi/laundry-monitoring-raspi/hub-ctrl -b $BUS -d $DEV -P $i -p 1
	done
fi

