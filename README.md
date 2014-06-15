# Docker Challenge

A little challenge.

## Synopsis

1. Install docker and say something about how it went. 

2. Write a Nagios plugin that monitors the status of the Docker daemon  

3. Return the information provided by the "docker info" command as performance data.

## Arch

To complete this challenge I automated a Vagrant VM to do the following:

1. Deploy an Ubuntu Precise VM on 10.10.33.2
2. Provsion the VM with Puppet using the Vagrant Puppet provisioner
	1. Installs docker using garethr-docker
	2. Installs the training/webapp image
	3. Runs the container using an exec
		* the ```docker::run``` command kept failing with a very odd '<< is not a {}:hash' error. I grep'ed through the module to try and find where this was coming from and I think it's a heredoc within a function for the define. I still need to look into it. I ran an exec after the image is downloaded to get around this problem for now
	4. Installs nagios and my ruby plugin to monitor the docker service and the training/webapp image for the following:
		1. Is the docker command available? 
		2. Is the webapp running?
			- Is the webapp running? 
			- Checks the log for 404 errors and sends warnings if so
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

