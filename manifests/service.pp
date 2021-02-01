# @api private
#
# @summary Set up and start the Lenses service
#
class lenses::service (
  $lenses_conf_file,
  $environment_file,
  $environment_options,
){

  assert_private()

  file { $environment_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('lenses/lenses.service.environment.epp', {
      'environment_options' => $environment_options,
    }),
  }

  file { 'lenses_service_unit':
    ensure  => file,
    path    => '/etc/systemd/system/lenses.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('lenses/lenses.service.epp', {
      'lenses_conf_file' => $lenses_conf_file,
      'environment_file' => $environment_file,
    }),
    notify  => Exec['lenses_systemd_daemon-reload'],
    require => File[$environment_file],
  }

  exec { 'lenses_systemd_daemon-reload':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => 'systemctl daemon-reload > /dev/null',
    refreshonly => true,
  }

  service { 'lenses':
    ensure    => running,
    enable    => true,
    subscribe => Exec['lenses_systemd_daemon-reload'],
  }

}
