# @summary
#   The current style deployment for Red Hat 6.10+ and Red Hat 7.5+.
#
# @param package_name
#   The name of the package to install
# @param log_level
#   Change log level, valid options DEBUG, INFO, WARNING, ERROR, CRITICAL.
# @param auto_config
#   Attempt to auto configure with Satellite server.
# @param authmethod
#   Change authentication method, valid options BASIC, CERT.
# @param username
#   username to use when authmethod is BASIC.
# @param password
#   password to use when authmethod is BASIC.
# @param base_url
#   URL for your proxy. Example: http://user:pass@192.168.100.50:8080
# @param proxy
#   Proxy to use.
# @param cert_verify
#   How to verify the certificate chain of api.access.redhat.com. Can be True,
#   False or an absolute path.
# @param gpg
#   Enable/Disable GPG verification of dynamic configuration.
# @param auto_update
#   Automatically update the dynamic configuration.
# @param obfuscate
#   Whether to obfuscate IP addresses.
# @param obfuscate_hostname
#   Whether to obfuscate hostname.
#
# @author Lindani Phiri <lphiri@redhat.com>
# @author Dan Varga  <dvarga@redhat.com>
#
# Copyright 2015 Red Hat Inc.
#
class access_insights_client::current (
  $package_name = 'insights-client',
  Optional[Enum['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL']] $log_level = undef,
  $auto_config = 'True',
  $authmethod = undef,
  $username = undef,
  $password = undef,
  $base_url = undef,
  $proxy = undef,
  $cert_verify = undef,
  $gpg = undef,
  $auto_update = undef,
  $obfuscate = undef,
  $obfuscate_hostname = undef,
) {
  package { $package_name:
    ensure => installed,
  }

  # Ensure the old config is gone
  file { [
      '/etc/redhat-access-insights/redhat-access-insights.conf',
      '/etc/cron.daily/redhat-access-insights',
      '/etc/cron.weekly/redhat-access-insights',
    ]:
      ensure  => 'absent',
  }

  file { "/etc/${package_name}/${package_name}.conf":
    ensure  => 'file',
    content => template('access_insights_client/redhat-access-insights.conf.erb'),
    require => Package[$package_name],
  }

  if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
    file { [
        "/etc/cron.weekly/${package_name}",
        "/etc/cron.daily/${package_name}",
      ]:
        ensure => 'absent',
    }

    service { "${package_name}.timer":
      ensure  => 'running',
      enable  => true,
      require => Package[$package_name],
    }
  } else {
    file { "/etc/cron.daily/${package_name}":
      ensure  => 'link',
      target  => "/etc/${package_name}/${package_name}.cron",
      require => Package[$package_name],
    }

    file { "/etc/cron.weekly/${package_name}":
      ensure => 'absent',
    }
  }

  exec { "/usr/bin/${package_name} --register":
    creates => "/etc/${package_name}/.registered",
    unless  => "/usr/bin/test -f /etc/${package_name}/.unregistered",
    require => Package[$package_name],
  }
}
