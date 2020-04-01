#!/bin/bash

HOST="Ntripcaster host"
PORT="2101"
MOUNTPOINT="MountPoint"
USER="guest"
PASS="guest"
ACCESS_TOKEN="LINEアクセストークン"
MSG="Ntrip Casterから補正情報が受信出来ません"
#MSG="Ntrip Casterから補正情報が受信出来ません NtripSeverを再起動します"

## NtripClientへのアクセスを試みる
message=`python3 /home/pi/NtripClient-Tools/NtripClient.py -u $USER -p $PASS -v -m 10 $HOST $PORT $MOUNTPOINT 2>&1| grep 'ICY 200 OK'`
echo $message
if [ -n "$message" ]
 then
    # 正常
    echo "good"
    exit 1
else
 echo "error"
 curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -F "message=$MSG" https://notify-api.line.me/api/notify
 #sudo reboot
 exit 0
fi

