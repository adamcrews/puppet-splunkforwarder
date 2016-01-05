# == Class splunkforwarder::config
#
# This class is called from splunkforwarder for service config.
#
class splunkforwarder::config {
  ini_setting { 'Server Name':
    ensure  => present,
    path    => "${::splunkforwarder::splunk_home}/etc/system/local/server.conf",
    section => 'general',
    setting => 'serverName',
    value   => $::fqdn,
    require => Package[$splunkforwarder::package_name],
  }

  ini_setting { 'Disable SSLV3':
    ensure  => present,
    path    => "${::splunkforwarder::splunk_home}/etc/system/local/server.conf",
    section => 'sslConfig',
    setting => 'supportSSLV3Only',
    value   => 'False',
    require => Package[$splunkforwarder::package_name],
  }

  ini_setting { 'Set TLS 1.2':
    ensure  => present,
    path    => "${::splunkforwarder::splunk_home}/etc/system/local/server.conf",
    section => 'sslConfig',
    setting => 'cipherSuite',
    value   => $::splunkforwarder::tls_ciphers,
    require => Package[$splunkforwarder::package_name],
  }
}
