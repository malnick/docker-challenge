# Deploys Nagios service

notice("Deploying nagios service")
class { 'nagios::server':
    apache_httpd_ssl             => false,
    cgi_authorized_for_system_information        => '*',
      cgi_authorized_for_configuration_information => '*',
        cgi_authorized_for_system_commands           => '*',
          cgi_authorized_for_all_services              => '*',
            cgi_authorized_for_all_hosts                 => '*',
              cgi_authorized_for_all_service_commands      => '*',
                cgi_authorized_for_all_host_commands         => '*',
                  cgi_default_statusmap_layout                 => '3',
}
