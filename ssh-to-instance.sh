#!/bin/bash

## Purpose: will update dynamic dns entery for game server to instance ip, 
## and deploy and start minecraft bedrock dedicated server. To be run after launch-ec2-instance.sh.

. config
. .instance.run

ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION ubuntu@$INSTANCEIP