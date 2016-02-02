# == Class splunkforwarder::install
#
# This class is called from splunkforwarder for install.
#
class splunkforwarder::install {

  package { $::splunkforwarder::package_name:
    ensure   => $::splunkforwarder::package_ensure,
    provider => $::splunkforwarder::package_provider,
    source   => $::splunkforwarder::package_src,
  }

  if $::osfamily != 'windows' {
    exec { 'Install Splunk Service':
      command   => "${::splunkforwarder::splunk_home}/bin/splunk enable boot-start",
      path      => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', "${splunkforwarder::splunk_home}/bin"],
      subscribe => Package[$::splunkforwarder::package_name],
      unless    => 'test -f /etc/init.d/splunk',
    }
  }
}
