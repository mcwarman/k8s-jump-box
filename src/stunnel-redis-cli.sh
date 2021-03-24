#!/usr/bin/env bash

set -euo pipefail

redis_address=${1}
redis_port=${2:-6379}

echo "Adding config to [/etc/stunnel/stunnel.conf]"

printf '
setuid = stunnel
setgid = stunnel

pid = /run/stunnel/stunnel.pid

client = yes

debug = info
output = /var/log/stunnel/stunnel.log

[redis-cli]
client = yes
accept = 127.0.0.1:6380
connect = %s:%s
' "${redis_address}" "${redis_port}" | tee /etc/stunnel/stunnel.conf

echo
echo "Killing [stunnel]"
killall stunnel

echo
echo "Starting [stunnel]"
stunnel

echo
echo "Starting [redis-cli]"
redis-cli -h 127.0.0.1 -p 6380
