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
  require => File['/usr/local/bin/check_docker'],
}


}
