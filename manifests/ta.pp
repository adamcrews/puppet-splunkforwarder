# == define splunkforwarder::ta
#
# This type will install a splunk TA pack.
#
define splunkforwarder::ta (
  $source,
  $ta_name = $title,
) {

  validate_re($source, 'zip$', '$source must be a zip file')

  case $::kernel {
    'windows': {
      ensure_packages('7zip', {provider => 'chocolatey', alias => 'unzip'})
      $ex_command = '"C:\Program Files\7-Zip\7z.exe" x -aoa'
    }
    'Linux', 'Darwin': {
      ensure_packages('unzip')
      $ex_command = '/usr/bin/unzip'
    }
    default: { fail("Unsupported OS: ${::operatingsystem}") }
  }

  # The download and extract are being done in 2 stages because there appears
  # to be a bug in the archive module on windows
  archive { "${::splunkforwarder::splunk_home}/${ta_name}.zip":
    source  => $source,
    extract => false,
    require => Package["$::splunkforwarder::package_name"]
  }

  exec { "Extract ${ta_name} Zip":
    cwd       => "${::splunkforwarder::splunk_home}/etc/apps",
    command   => "${ex_command} \"${::splunkforwarder::splunk_home}/${ta_name}.zip\"",
    creates   => "${::splunkforwarder::splunk_home}/etc/apps/${ta_name}",
    subscribe => Archive["${::splunkforwarder::splunk_home}/${ta_name}.zip"],
    require   => Package['unzip'],
    notify    => Service[$::splunkforwarder::service_name],
  }
}
