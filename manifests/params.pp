# == Class splunkforwarder::params
#
# This class is meant to be called from splunkforwarder.
# It sets variables according to platform.
#
class splunkforwarder::params {
  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $package_name = 'splunkforwarder'
      $service_name = 'splunkforwarder'
      $splunk_home  = '/opt/splunkforwarder'
    }
    'Windows': {
      $package_name     = 'splunkforwarder'
      $package_provider = 'chocolatey'
      $service_name     = 'SplunkForwarder'
      $splunk_home      = 'C:/Program Files/SplunkUniversalForwarder'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
