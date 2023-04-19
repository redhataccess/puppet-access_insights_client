# @summary
#   The access insights module is intended to deploy and configure the Red Hat
#   Access Insights client.
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
# @param deployment_style
#   How the module should be deploy. Can be undef (auto),
#   current (6.10+ or 7.5+) or old.
# @param tags
#   Data Hash to populate tags.yaml file
#
# @author Lindani Phiri <lphiri@redhat.com>
# @author Dan Varga  <dvarga@redhat.com>
#
# Copyright 2015 Red Hat Inc.
#
class access_insights_client (
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
  Hash $tags = {},
  Optional[Enum['current', 'old']] $deployment_style = undef,
) {
  if $deployment_style {
    $class_name = $deployment_style
  } else {
    if (versioncmp($facts['os']['release']['full'], '6.10') < 0 or
    (versioncmp($facts['os']['release']['full'], '7.0') >= 0 and versioncmp($facts['os']['release']['full'], '7.5') < 0)) {
      $class_name = 'old'
    } else {
      $class_name = 'current'
    }
  }

  class { "access_insights_client::${class_name}":
    log_level          => $log_level,
    auto_config        => $auto_config,
    authmethod         => $authmethod,
    username           => $username,
    password           => $password,
    base_url           => $base_url,
    proxy              => $proxy,
    cert_verify        => $cert_verify,
    gpg                => $gpg,
    auto_update        => $auto_update,
    obfuscate          => $obfuscate,
    obfuscate_hostname => $obfuscate_hostname,
    tags               => $tags,
  }
  contain "access_insights_client::${class_name}"
}
