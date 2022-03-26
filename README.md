# minecraft-bds-onthefly-ec2: Deploy an existing Minecraft Bedrock Dedicated Server on demand to ec2

The purpose of this set of scripts is a) to deploy an existing minecraft-bds to an AWS ec2 t2.micro instance and b) to cleanly terminate the bds, back it up to a local folder and then terminate the instance. We don't catch any errors over here (no, really, this is rather quick and dirty), use at your own risk, YMMV, see LICENSE etc.


## Requirements
bash, ssh, rsync, curl, aws-cli

## Configuration
1. You need to configure <your home dir>/.aws/config and <your home dir>/.aws/credentials for aws-cli to work, 
2. have an aws access key configured with the privileges required to launch and interact with ec2 instances, and
3. have and aws security group configured that allows access to ssh and the ports minecraft bds requires (TCP22, TCP 19132, UDP 38441).
4. Your will also need to create a public key pair for this user and save it where the user running the scripts can access it. AWS takes care of the first step. 
5. To avoid having to change the server address in your minecraft client each time, we use a dynamic dns service to update the FQDN to the aws instances IP address. In my case, I can do the update using a simple HTTPS GET request and basic auth. YMMV.
6. Place the minecraft-bds installation you want to run into ./minecraft-bds folder. If you start with a fresh server, extract the archive to this folder, not into another subfolder.
7. Make sure to keep the files minecraft-bds.service and run-bds.sh in the folder ./minecraft-bds/
8. The remaining configuration can be found in ```config```.  
9. You will need to figure out how to update your dynamic DNS hostname. The provider I use allows me to send a HTTPS GET request with basic authentication to update the hostname. You will to adapt this to whatever your provider requires. Change ```update-dyndns.sh``` accordingly, it will not work as it is right now, as it contains placeholders instead of my provider's URL.

## Using it
1. ```run.sh``` to deploy and run the server
2. ```terminate-ec2-instance.sh``` to stop and backup the server, and terminate the ec2 instance
3. WARNING: the other script ```terminate-all-ec2-instances.sh``` is the nuclear option for cost control. It terminates ALL EC2 instances the respective access key can control (in the given region).

## How it works
In detail, we 
1. run ```launch-e2-instance.sh```, which reads ```config```, uses aws-cli to launch an t2.micro instance, parses the instance id from the resulting json and writes it to our ```.instance.run``` file. Then it sleeps for 10 seconds to allow the instance be provisioned, then uses the instance id retrieve the instance's public IP address, and writes the address to the ```.instance.run file```. This file now contains all information we need to interact with the instance.
2. then run ```deploy-server.sh```, which reads the ```.instance.run``` file, updates the dynamic dns hostname to the current instance IP address (via ```update-dyndns.sh```), uses rsync via ssh to copy the folder containing the minecraft-bds to the instance, uses ssh to install the systemd unit ```minecraft-bds.service``` from the bds folder, and start the service. As apparently usual with minecraft dedicated servers, the 'service' is a named screen session and a bash one-liner in a trenchcoat. 
3. run terminate-ec2-instance, which reads ```config``` and ```.instance.run```, uses ssh to stop the minecraft-bds service, uses rsync via ssh to sync all changes from the remote minecraft-bds folder to the local minecraft-bds folder and uses aws-cli to terminate the ec2 instance.

## Acknowledgements
The ~~author~~editor thanks various stackexchange contributors and/or redditors, as well as, Google (for their search engine).
