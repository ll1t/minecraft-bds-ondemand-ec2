#!/bin/bash

. .instance.run
aws ec2 describe-instances --profile autolaunch --region eu-central-1 --instance-ids $INSTANCEID --query "Reservations[*].Instances[*].PublicIpAddress" --output=text