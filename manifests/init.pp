# @summary
#   Full description of class access_insights_client here.
#
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
# @param upload_schedule
#   How often to update. Can be daily or weekly.
#
# @author Lindani Phiri <lphiri@redhat.com>
# @author Dan Varga  <dvarga@redhat.com>
#
# Copyright 2015 Red Hat Inc.
#
class access_insights_client(
  $log_level = undef,
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
  $upload_schedule = undef,
) {
  package { 'redhat-access-insights':
    ensure => latest,
  }

  file { '/etc/redhat-access-insights/redhat-access-insights.conf':
    ensure  => file,
    content => template('access_insights_client/redhat-access-insights.conf.erb'),
    require => Package['redhat-access-insights'],
  }

  if $upload_schedule == 'weekly' {
    file { '/etc/cron.weekly/redhat-access-insights':
      ensure  => 'link',
      target  => '/etc/redhat-access-insights/redhat-access-insights.cron',
      require => Package['redhat-access-insights'],
    }

    file { '/etc/cron.daily/redhat-access-insights':
      ensure => 'absent',
    }
  } else {
    file { '/etc/cron.daily/redhat-access-insights':
      ensure  => 'link',
      target  => '/etc/redhat-access-insights/redhat-access-insights.cron',
      require => Package['redhat-access-insights'],
    }

    file { '/etc/cron.weekly/redhat-access-insights':
      ensure => 'absent',
    }
  }

  exec { '/usr/bin/redhat-access-insights --register':
    creates => '/etc/redhat-access-insights/.registered',
    unless  => '/usr/bin/test -f /etc/redhat-access-insights/.unregistered',
    require => Package['redhat-access-insights'],
  }
}
