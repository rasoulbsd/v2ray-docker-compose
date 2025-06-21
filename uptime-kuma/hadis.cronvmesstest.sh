#!/bin/bash

# */10 * * * * /bin/bash $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.cronvmesstest.sh >> $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.log 2>&1

#vmess="vmess://eyJhZGQiOiJhcnZwYXMtZWNmMzlkMThjOS1ycmh2cC5hcHBzLmlyLXRoci1iYTEuYXJ2YW5jYWFzLmlyIiwiYWlkIjoiMCIsImhvc3QiOiIiLCJpZCI6IjdlNDZkMGQ4LWY0NjctNDkxMi05YmUwLTI3ODI0YTEzNjQ5ZSIsIm5ldCI6IndzIiwicGF0aCI6Ii9hcGkvZGFyay90ci9jbCI>
#vmess="vmess://ewogICAgImFkZCI6ICJhcnZwYXMtZWNmMzlkMThjOS1yaHZwLmFwcHMuaXItdGJ6LXNoMS5hcnZhbmNhYXMuaXIiLAogICAgImFpZCI6ICIwIiwKICAgICJob3N0IjogIiIsCiAgICAiaWQiOiAiN2U0NmQwZDgtZjQ2Ny00OTEyLTliZTAtMjc4MjRhMTM2NDllIiwKICAgICJuZXQiOiAi>
vmess="vmess://ewogICAgImFkZCI6ICJhcnZwYXMtZWNmMzlkMThjOS1yaHZwLmFwcHMuaXItdGJ6LXNoMS5hcnZhbmNhYXMuaXIiLAogICAgImFpZCI6ICIwIiwKICAgICJob3N0IjogIiIsCiAgICAiaWQiOiAiN2U0NmQwZDgtZjQ2Ny00OTEyLTliZTAtMjc4MjRhMTM2NDllIiwKICAgICJuZXQiOiAid3MiLAogICAgInBhdGgiOiAiL2FwaS9kYXJrL3RyL2NsIiwKICAgICJwb3J0IjogIjQ0MyIsCiAgICAicHMiOiAiNDMyMDgwNTk1QEhhZGlzIiwKICAgICJzY3kiOiAiYXV0byIsCiAgICAic25pIjogImJ4em91c2FvYXMuYXBwcy5pci10Ynotc2gxLmFydmFuY2Fhcy5pciIsCiAgICAidGxzIjogInRscyIsCiAgICAidHlwZSI6ICJub25lIiwKICAgICJ2IjogIjIiCn0K"
uptime_kuma_base_api_url="https://status.abrarvan.online/api/push/uUr0E1ovOg"
ping_count=10
ping_delay=5
down_message="NotOK"
up_message="OK"

avg_ping_time=$($HOME/rahbazkon/x-ui-compose/uptime-kuma/bin/vmessping_amd64_linux -c $ping_count -i $ping_delay $vmess | grep "rtt min/avg/max" | awk -F '/' '{print $4}')

if [ $avg_ping_time -eq 0 ]
then
  curl "$uptime_kuma_base_api_url?status=down&msg=$down_message"
else
  curl "$uptime_kuma_base_api_url?status=up&msg=$up_message&ping=$avg_ping_time"
fi
