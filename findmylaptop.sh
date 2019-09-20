#! /bin/bash

result=$(ping -c 4 ya.ru | tail -2 | head -1 | awk '{print $4}')
error="ping: unknown host ya.ru"

echo "$result"
while [[ ( $result =  $error ) || ( $result -eq 0) ]]
do
result=$(ping -c 4 ya.ru | tail -2 | head -1 | awk '{print $4}')
sleep 60
echo "No connection"
done

ssid=$(nmcli -t -f active,ssid dev wifi | grep 'yes' | cut -d\' -f2)
externalip=$(dig +short myip.opendns.com @resolver1.opendns.com)
mac=$(ip neigh|grep "$(ip -4 route list 0/0|cut -d' ' -f3) "|cut -d' ' -f5|tr '[a-f]' '[A-F]')

echo "SSID:  $ssid"
echo "MAC: $mac"
echo "EXTERNAL IP: $externalip"

curl -d "msg= SSID: $ssid , IP: $externalip, MAC: $mac " https://sms.ru/sms/send\?api_id=id_from_sms_ru\&to=79061111111
