#!/bin/bash

. config
echo "Starting EC2 t2.micro instance ..."

# we use a Ubuntu image and a t2.micro instance
aws ec2 run-instances --profile $AWSPROFILE --region $AWSREGION --image-id ami-042ad9eec03638628 --count 1 --instance-type t2.micro --key-name $AWSKEYNAME --security-group-ids $AWSSECGROUPIDS --associate-public-ip-address --output=json > launch-output.json

instanceid=$(grep InstanceId launch-output.json | sed s/[\",]//g | sed s/^.*:\ //)

echo "export INSTANCEID=$instanceid" > .instance.run

echo "Instance started ..."
echo "Waiting for instance to complete provisioning so we can retrieve its public IP address ..."
sleep 10
echo "Requesting instance public IP address ..."
instanceip=$(aws ec2 describe-instances --profile autolaunch --region eu-central-1 --instance-ids $INSTANCEID --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)

echo "export INSTANCEIP=$instanceip" >> .instance.run
echo "Instance information written to run file .instance.run"
