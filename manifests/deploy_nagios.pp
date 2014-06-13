# Deploys Nagios service

notice("Deploying nagios service")
class { 'nagios': }

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

# Docker plugin need some python deps
$docker_plugin_pkgs = ['docker-py','nagiosplugin']

package { 'python-setuptools':
  ensure => present,
}

exec {"/usr/bin/pip install -r ${docker_plugin_pks}":
  creates => '',
  require => Packge ['python-setuptools'],
}

#package { $docker_plugin_pkgs:
#  ensure => present,
#  provider => 'pip',
#}



