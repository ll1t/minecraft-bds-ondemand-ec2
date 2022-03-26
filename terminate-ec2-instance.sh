#!/bin/bash

. config
. .instance.run

echo "Terminating minecraft-bds ..."
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION ubuntu@$INSTANCEIP sudo service minecraft-bds stop

#echo "Make sure minecraft-bds on ec2 has been terminated, else hit CTRL+C now thrice! Sleeping for 10 seconds to let you decide ..."
#sleep 10

echo "Backing up changes from minecraft"
rsync -O --delete-during --ignore-errors -ave "ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -i $SSHKEYLOCATION" ubuntu@$INSTANCEIP:/home/ubuntu/minecraft-bds/ ./minecraft-bds

aws ec2 terminate-instances --profile $AWSPROFILE --region $AWSREGION --instance-ids $INSTANCEID
