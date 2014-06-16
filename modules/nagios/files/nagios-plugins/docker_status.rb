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
	if system("which docker > /dev/null")
		webapp_status()
	else
		critical("Docker isn't installed")
	end
end

def webapp_status()
	# Ensure the webapp is running on localhost:5000
	webapp_run = `netstat -anp | grep 5000 | awk '{print $7}' | cut -d/ -f2`
	should_be   = "docker"
	webapp_run.chomp!.strip!
	if webapp_run == should_be
		# Check to ensure there are no 404 errors in the log
		check_this = "docker logs $(docker ps -l | awk '{print $1}' | awk '{if (NR == 2){print $0}}') 2>&1 | grep 404 | awk '{print $7}' | sort | uniq -c"
		check = system(check_this)
		if check 
			IO.popen(check_this) do |io|
				line  = io.readlines
				errors = {} 
				line.each do |this|
					number = this.split(' ').first
					url = this.split(' ').last
					errors.store(url, number)	
				end	
				max_value = errors.values.max
				max_key = errors.select { |k,v| v==max_value }.keys	
				case max_value.to_i > 20  
					when false  
						warning("#{max_value} 404 Errors at localhost#{max_key}")
					when true 
						critical("#{max_value} 404 Errors at localhost#{max_key}")
				end
			end	
		else
			ok("Docker & Webapp are in good shape!")
		end
	else
		critical("Webapp is not running on localhost:5000")
	end
end

docker_installed()
	
