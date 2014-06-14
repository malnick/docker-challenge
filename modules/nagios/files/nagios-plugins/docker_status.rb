#!/usr/bin/ruby
# Checks the docker status command for number of running containers
# Ensures the docker container is running by checking that the socket exists
# 

# Define some helper methods for Nagios with appropriate exit codes
def ok(message)
	puts "OK - #{message}"
	exit 0
end

def critical(message)
	puts "Critical - #{message}"
	exit 2
end

def warning(message)
	puts "Warning - #{message}"
	exit 1
end

def unknown(message)
	puts "Unknown - #{message}"
	exit 3
end

# Check to ensure docker is installed

def docker_installed()
	if system("which docker")
		ok("docker installed")
	else
		critical("docker isn't installed")
	end
end

docker_installed()
	
