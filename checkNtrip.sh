#!/bin/bash

HOST="Ntripcaster host"
PORT="2101"
MOUNTPOINT="MountPoint"
USER="guest"
PASS="guest"
ACCESS_TOKEN="LINEアクセストークン"
# 通知するかどうかフラグ
NOTIFY=0

## スクリプトへの引数を確認
if [ $1 = "-n" ];then
  NOTIFY=1;
elif [ $1 = "-e" ];then
  NOTIFY=0;
else
  echo "[-n]:正常通知　[-e]:異常通知"
  exit 1
fi

## NtripClientへのアクセスを試みる
message=`python3 /home/pi/NtripClient-Tools/NtripClient.py -u $USER -p $PASS -v -m 10 $HOST $PORT $MOUNTPOINT 2>&1| grep 'ICY 200 OK'`
echo $message
if [ $NOTIFY -eq 0 ] && [ -n "$message" ];then
  # 正常
  echo "good"
  exit 1
elif [ $NOTIFY -eq 1 ] && [ -n "$message" ];then
  #定期通知
  echo "running"
  MSG="Ntrip Caster 正常稼働中"
  curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -F "message=$MSG" https://notify-api.line.me/api/notify
  exit 0
else
  echo "error"
  MSG="Ntrip Casterから補正情報が受信出来ません "
  #MSG="Ntrip Casterから補正情報が受信出来ません NtripSeverを再起動します"
  curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -F "message=$MSG" https://notify-api.line.me/api/notify
  #sudo reboot
  exit 0
fi

