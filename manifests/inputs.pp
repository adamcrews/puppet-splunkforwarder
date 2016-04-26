# == Class: splunkforwarder::inputs
#
# Manage the inputs.conf file
#
# === Parameters
#
# [*path*]
#   The path to the inputs.conf
#   Default: ${::splunk::splunk_home}/etc/system/local
#
# [*host*]
#   The hostname of the sending node
#   Default: $::fqdn
#
# [*source*]
#   The default source to monitor.  It is better to use the
#   splunk::inputs::<module> types to manage the sources.
#   Default: undef
#
# [*sourcetype*]
#   The default sourcetype to monitor.  It is better to use the
#   splunk::inputs::<module> types to mange the sourcetypes.
#   Default: undef
#
# [*queue*]
#   The queuing method, parsingQueue or indexQueue.
#   Default: undef
#
# [*tcp_routing*]
#   An array of tcpout group names.
#   Default: undef
#
# [*syslog_routing*]
#   An array of syslog group names.
#   Default: undef
#
# [*index_and_forward_routing*]
#   Causes all data coming from the input stanza to be labeled with
#   the value.
#   Default: undef
#
# === Examples
#
# class { 'splunkforwarder::inputs':
#   host => 'my_special_host_role',
# }
#
# splunkforwarder::inputs::monitor { '/var/log/messages':
#   index      => 'my_index_name',
#   sourcetype => 'linux_messages_syslog',
# }
#
class splunkforwarder::inputs (
  $path = "${::splunkforwarder::splunk_home}/etc/system/local",

  $host                      = $::fqdn,
  $index                     = undef,
  $source                    = undef,
  $sourcetype                = undef,
  $queue                     = undef,
  $tcp_routing               = undef,
  $syslog_routing            = undef,
  $index_and_forward_routing = undef,
  $custom_hash               = undef,
  ) {

  if $::osfamily == 'windows' {
    File { source_permissions => ignore }
  }

  validate_absolute_path("${path}/inputs.conf")
  validate_string($index)

  if $source {
    validate_absolute_path($source)
  }

  validate_string($sourcetype)

  if $queue {
    validate_re($queue, '^(parsingQueue|indexQueue)')
  }

  if $tcp_routing {
    validate_array($tcp_routing)
  }

  if $syslog_routing {
    validate_array($syslog_routing)
  }

  concat { 'inputs.conf':
    path    => "${path}/inputs.conf",
    mode    => '0644',
    warn    => true,
    require => Class['splunkforwarder::install'],
    notify  => Class['splunkforwarder::service'],
  }

  concat::fragment { 'header_inputs.conf':
    target  => 'inputs.conf',
    order   => '01',
    content => template("${module_name}/inputs/01-header.erb"),
  }
}
