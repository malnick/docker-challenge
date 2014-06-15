# Deploy docker and an Ubuntu image to play with
class {'docker':}
docker::image { 'training/webapp':
  require => Class['docker'],
}
# Super hero hack to run the docker image... see readme for why.
# Also, in no way is this idempotent, if it's running it'll fail.
exec { '/usr/bin/docker run -d -p 5000:5000 training/webapp python app.py':
  require => Docker::Image['training/webapp'],
}
#docker::run { 'webapp':
#  image   => 'ubuntu',
#  command => '/bin/echo test',
#  require => Docker::Image['training/webapp'],
#}

# Update this thing
exec { '/usr/bin/apt-get update':}

# Install nagios 
class { 'nagios': 
  require => [Exec['/usr/bin/apt-get update'],Class['docker']]
}

# Get my plugin on the system correctly
nagios::plugin { 'docker_status':
   source => 'nagios/nagios-plugins/docker_status.rb'
}

# WARNING: TOTAL HACK PLEASE DON'T JUDGE ME
exec { '/bin/echo "command[docker_status]=/usr/lib/nagios/plugins/docker_status" >> /etc/nagios/nrpe.cfg':
  require => File['/etc/nagios/nrpe.cfg'],
  notify => Service['nrpe'],
}

# Ensure docker and nagios are in the same group
exec {'/usr/sbin/usermod -a -G docker nagios':
  require => Class['nagios'],
  notify  => Service['nrpe'],
}

nagios::command { 'docker_status':
  command_line => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c docker_status',
}

# Set the nagiosadmin password 
exec { '/usr/bin/htpasswd -cb /etc/nagios3/htpasswd.users nagiosadmin nagiosadmin': 
  require => Class['nagios'],
}

# I wrote my plugin in Ruby so lets make sure the VM has it. 
package { 'ruby1.9.1':
  ensure => present,
  require => Class['nagios'],
}


