#!/bin/bash

## Purpose: will update dynamic dns entery for game server to instance ip, 
## and deploy and start minecraft bedrock dedicated server. To be run after launch-ec2-instance.sh.

. config
. .instance.run

echo "Updating DNS A Record for $GAMESERVERFQDN."
./update-dyndns.sh $GAMESERVERFQDN $INSTANCEIP

echo ""
echo "Sleeping 60 seconds to allow our little instance to boot completely ..."
sleep 60
echo "Deploying server using rsync ..."
rsync -O --delete-during --ignore-errors -ave "ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION" ./minecraft-bds ubuntu@$INSTANCEIP:/home/ubuntu/

echo "Setting up systemd service and starting bedrock dedicated server ..."
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION ubuntu@$INSTANCEIP sudo cp ./minecraft-bds/minecraft-bds.service /etc/systemd/system/
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION ubuntu@$INSTANCEIP sudo service minecraft-bds start

echo "Done. Your should be able to connect to and play on $GAMESERVERFQDN on the default bds port." 
echo ""
echo "When you're done playing, run ./terminate-ec2-instance.sh to stop and backup the server, and terminate the ec2 instance. It will the stop incurring costs."

