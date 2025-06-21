#!/bin/bash

# */10 * * * * /bin/bash $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.cronvmesstest.sh >> $HOME/x-ui-compose/uptime-kuma/VMESS_NAME.log 2>&1

#vmess="vmess://ewogICAgImFkZCI6ICJhcnZwYXMtcnJodnAuYXBwcy5pci10aHItYmExLmFydmFucGFhcy5pciIsCiAgICAiYWlkIjogIjAiLAogICAgImhvc3QiOiAiIiwKICAgICJpZCI6ICI2NTE3NWZlNC02MjZkLTQyYWEtZDUxZC05YzcxOTEwZWU5NjYiLAo>
vmess="vmess://eyJhZGQiOiJhcnZwYXMtZWNmMzlkMThjOS1ycmh2cC5hcHBzLmlyLXRoci1iYTEuYXJ2YW5jYWFzLmlyIiwiYWlkIjoiMCIsImhvc3QiOiIiLCJpZCI6IjY1MTc1ZmU0LTYyNmQtNDJhYS1kNTFkLTljNzE5MTBlZTk2NiIsIm5ldCI6IndzIiwicGF0aCI6Ii9hcGkvZGFyay90ci9kaXJlY3QiLCJwb3J0IjoiNDQzIiwicHMiOiJodHRwcy1odHRwcy1tb25pdG9yaW5nLTh0d3ZsNSIsInNjeSI6ImF1dG8iLCJzbmkiOiJ6emdydGRtZm1pLmFwcHMuaXItdGhyLWJhMS5hcnZhbmNhYXMuaXIiLCJ0bHMiOiJ0bHMiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0="
uptime_kuma_base_api_url="https://status.abrarvan.online/api/push/S59gU5kqye"
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
