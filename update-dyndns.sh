#!/bin/bash
hostname=$1
ip=$2

if [ -z ${hostname+x} ]; then 
    echo "Missing hostname. Correct usage is: update-dyndns.sh <hostname> <ip address>"; 
    exit 1
else 
    echo "Setting A record for $hostname to $ip."; 
    curl -u $DDNSU:$DDNSPW "https://dyndns.<yourddns.provider.FIXME>/path/update?hostname=$hostname&myip=$ip"
fi
