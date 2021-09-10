#!/usr/bin/env bash

set -euo pipefail

clamav_address=${1}
clamav_port=${2:-3310}

echo "Adding config to [/etc/clamav/clamd.conf]"

mkdir -p /etc/clamav

printf '
TCPAddr %s
TCPSocket %s
' "${clamav_address}" "${clamav_port}" | tee /etc/clamav/clamd.conf
