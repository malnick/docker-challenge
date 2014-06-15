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
		webapp_status()
	else
		critical("Docker isn't installed")
	end
end

def webapp_status()
	# Ensure the webapp is running on localhost:5000
	webapp_run = `docker ps -l | awk {'print $11}' | cut -d- -f1` 
	if "#{webapp_run}" == "0.0.0.0:5000"
		# Check to ensure there are no 404 errors in the log
		# $? = 0 then 404 is found, otherwise returns 1 when not found
		if system("docker logs $(docker ps -l | awk '{print $12}') 2>&1 | grep 404") 
			warning("Docker logs indicate 404 errors")
		else
			ok("Docker & Webapp are in good shape!")
		end
	else
		critical("Webapp is not running on localhost:5000")
	end
end

docker_installed()
	
