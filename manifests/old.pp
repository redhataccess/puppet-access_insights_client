# @summary
#   The old style deployment for Red Hat 6.9 and older or Red Hat 7.4 and
#   older.
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
# @param tags
#   Data Hash to populate tags.yaml file ---> This will not work for the old style of deployment.
#
# @author Lindani Phiri <lphiri@redhat.com>
# @author Dan Varga  <dvarga@redhat.com>
#
# Copyright 2015 Red Hat Inc.
#
class access_insights_client::old (
  $package_name = 'redhat-access-insights',
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
  Hash $tags = {},
) {
  if !$tags.empty {
    fail('You cant use tags with this implementation')
  }

  package { $package_name:
    ensure => installed,
  }

  file { "/etc/${package_name}/${package_name}.conf":
    ensure  => file,
    content => template('access_insights_client/redhat-access-insights.conf.erb'),
    require => Package[$package_name],
  }

  file { "/etc/cron.daily/${package_name}":
    ensure  => 'link',
    target  => "/etc/${package_name}/${package_name}.cron",
    require => Package[$package_name],
  }

  file { "/etc/cron.weekly/${package_name}":
    ensure => 'absent',
  }

  exec { "/usr/bin/${package_name} --register":
    creates => "/etc/${package_name}/.registered",
    unless  => "/usr/bin/test -f /etc/${package_name}/.unregistered",
    require => Package[$package_name],
  }
}
