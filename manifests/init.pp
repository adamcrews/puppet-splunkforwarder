# Class: splunkforwarder
# ===========================
#
# This will install and manage the Splunk universal forwarder.  It provides
# basic client configuration of inputs and outputs.  If you want to manage
# anything more than the universal forwarder, this is not the correct module to
# use.
#
# Parameters
# ----------
#
# * `package_name`
#   The name of the pacakge to install from a pre-configured repository.
#   Default: splunkforwarder
#
# * `pacakge_provier`
#   The provider to use to install the package.
#   Default: *nix, uses the OS default.  Windows uses chocolatey
#
# * `package_src`
#   A url to pass to the package type.
#   Default: undef
#
# * `pacakge_ensure`
#   Specify the ensure for a package, [present|latest|absent]
#   Default: present
#
# * `service_name`
#   The name of the universal forwarder service.
#   Default: splunkforwarder
#
class splunkforwarder (
  $package_name     = $::splunkforwarder::params::package_name,
  $package_provider = $::splunkforwarder::params::package_provider,
  $package_src      = $::splunkforwarder::params::package_src,
  $package_ensure   = 'present',

  $service_name   = $::splunkforwarder::params::service_name,
  $service_manage = true,
  $service_enable = true,

  $splunk_home    = $::splunkforwarder::params::splunk_home,

  $tls_ciphers    = 'TLSv1.2'

) inherits ::splunkforwarder::params {

  # validate all the things!
  validate_re($package_ensure, ['^present', '^absent', '^latest'])
  validate_bool($service_manage, $service_enable)
  validate_absolute_path($splunk_home)

  class { '::splunkforwarder::install': } ->
  class { '::splunkforwarder::config': } ~>
  class { '::splunkforwarder::service': } ->
  Class['::splunkforwarder']
}
