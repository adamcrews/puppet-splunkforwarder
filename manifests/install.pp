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

}
