#!/bin/bash

# */10 * * * * /bin/bash $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.cronvmesstest.sh >> $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.log 2>&1

#vmess="vmess://ewogICAgImFkZCI6ICJwYXMyLXJodnAuZGFya3ViZS5hcHAiLAogICAgImFpZCI6ICIwIiwKICAgICJob3N0IjogIiIsCiAgICAiaWQiOiAiNjUxNzVmZTQtNjI2ZC00MmFhLWQ1MWQtOWM3MTkxMGVlOTY2IiwKICAgICJuZXQiOiAid3MiLAogICA>
vmess="vmess://eyJhZGQiOiJwYXMyLXJodnAuZGFya3ViZS5hcHAiLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiNjUxNzVmZTQtNjI2ZC00MmFhLWQ1MWQtOWM3MTkxMGVlOTY2IiwibmV0Ijoid3MiLCJwYXRoIjoiL2FwaSIsInBvcnQiOiI0NDMiLCJwcyI6Imh0dHBzLWh0dHBzLW1vbml0b3JpbmctOHR3dmw1Iiwic2N5IjoiYXV0byIsInNuaSI6ImNycmtjaXhub3dnbmpvdy5kYXJrdWJlLmFwcCIsInRscyI6InRscyIsInR5cGUiOiJub25lIiwidiI6IjIifQ=="
uptime_kuma_base_api_url="https://status.abrarvan.online/api/push/hmU2NyUTrF"
ping_count=10
ping_delay=5
down_message="NotOK"
up_message="OK"

avg_ping_time=$($HOME/x-ui-compose/uptime-kuma/bin/vmessping_amd64_linux -c $ping_count -i $ping_delay $vmess | grep "rtt min/avg/max" | awk -F '/' '{print $4}')

if [ $avg_ping_time -eq 0 ]
then
  curl "$uptime_kuma_base_api_url?status=down&msg=$down_message"
else
  curl "$uptime_kuma_base_api_url?status=up&msg=$up_message&ping=$avg_ping_time"
fi
