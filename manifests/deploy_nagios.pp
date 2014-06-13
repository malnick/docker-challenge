# Deploys Nagios service

notice("Deploying nagios service")
class { 'nagios': }

exec { '/usr/bin/htpasswd -cb /etc/nagios3/htpasswd.users nagiosadmin nagiosadmin': 
  require => Class['nagios'],
}

file { '/usr/local/bin/check_docker':
  ensure => file,
  source => 'puppet:///modules/nagios/check_docker',
}

file { '/etc/init/docker.conf':
  ensure => file,
  source => 'puppet:///modules/nagios/docker.conf',
  owner => 'root',
  group => 'root',
  require => File['/usr/local/bin/check_docker'],
}

file { '/etc/nagios-plugins/config/docker.cfg':
  ensure => file,
  source => 'puppet:///modules/nagios/docker.cfg',
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



