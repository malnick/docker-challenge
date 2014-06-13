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


