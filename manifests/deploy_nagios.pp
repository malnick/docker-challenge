# Deploys Nagios service

notice("Deploying nagios service")

exec { '/usr/bin/apt-get update':}

class { 'nagios': 
  require => Exec['/usr/bin/apt-get update'],
}

file { '/etc/nagios3/auto.d/hosts/localhost.cfg':
  ensure => file,
  source => 'puppet:///modules/nagios/localhost.cfg',
  require => Class['nagios'],
  notify => Service['nrpe','nagios3'],
}

exec {'/usr/sbin/usermod -a -G docker nagios':
  require => Class['nagios'],
  notify  => Service['nrpe'],
}


nagios::command { 'docker_status':
  command_line => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c docker_status',
}

exec { '/usr/bin/htpasswd -cb /etc/nagios3/htpasswd.users nagiosadmin nagiosadmin': 
  require => Class['nagios'],
}

file { '/usr/lib/nagios/plugins/docker_socket.py':
  ensure => file,
  source => 'puppet:///modules/nagios/docker_socket.py',
}


# Docker plugin need some python deps
$docker_plugin_pkgs = ['docker-py','nagiosplugin']

package { 'python-setuptools':
  ensure    => present,
}

package { 'python-pip':
  ensure => present,
}

exec {"/usr/bin/pip install docker-py":
  require => Package['python-pip'],
}
exec {"/usr/bin/pip install nagiosplugin":
  require => Package['python-pip'],
}


#package { $docker_plugin_pkgs:
#  ensure => present,
#  provider => 'pip',
#}



