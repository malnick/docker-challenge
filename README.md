# Docker Challenge

A little challenge.

## Synopsis

1. Install docker and say something about how it went. 

2. Write a Nagios plugin that monitors the status of the Docker daemon  

3. Return the information provided by the "docker info" command as performance data.

## Arch

To complete this challenge I automated a Vagrant VM to do the following:

1. Install docker via the vagrant-docker provisioner
2. Pull a docker image from the registry. I chose a simple ```ubuntu``` image. 
3. Provision the VM using the vagrant-puppet provider, allowing me to install Nagios on run and configure my nagios monitoring script. 

## To Run

1. ```git clone https://github.com/malnick/docker-challenge```
2. ```cd docker-challenge```
3. ```vagrant up```

The vagrant docker provisioner will now run and exit with an error. I believe this has to do with my vagrant version 1.5x. I refuse to upgrade and test this with a new version since it will break all my plugins. 

However the error is not really an error, vagrant provisioner tries to start the service and it's already running. So to get around this run the vagrant provisioner again with --provision-with: 

4. ```vagrant provision --provision-with puppet```

This will run the last part of the block which runs my puppet code to install nagios and the docker_check plugin. 

4. Point your browser to ```http://10.10.33.2/nagios3```
5. User/Password - nagiosadmin/nagiosadmin

## Notes

1. I R&D'ed [rip-off and deploy] ```https://github.com/jsmartin/nagios-docker``` 

