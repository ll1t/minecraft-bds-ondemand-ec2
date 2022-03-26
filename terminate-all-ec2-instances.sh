#!/bin/bash
. config 
echo "THIS WILL TERMINATE ALL YOUR EC2 INSTANCES. IF YOU DO NOT WANT THAT, HIT CTRL+C NOW THRICE! Sleeping for 10 seconds to let you decide ..."
sleep 10

aws ec2 terminate-instances --profile $AWSPROFILE --region $AWSREGION --instance-ids $(aws ec2 describe-instances --profile $AWSPROFILE --region $AWSREGION --filters  "Name=instance-state-name,Values=pending,running,stopped,stopping" --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ')
