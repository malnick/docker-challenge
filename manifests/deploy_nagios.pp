# Deploys Nagios service

notice("Deploying nagios service")

# Update this thing
exec { '/usr/bin/apt-get update':}

# Install nagios 
class { 'nagios': 
  require => Exec['/usr/bin/apt-get update'],
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


# Docker plugin need some python deps
#package { 'python-setuptools':
#  ensure    => present,
#}

#package { 'python-pip':
#  ensure => present,
#}

#exec {"/usr/bin/pip install docker-py":
#  require => Package['python-pip'],
#}
#exec {"/usr/bin/pip install nagiosplugin":
#  require => Package['python-pip'],
#}


#package { $docker_plugin_pkgs:
#  ensure => present,
#  provider => 'pip',
#}



