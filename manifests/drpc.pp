# Class: storm::drpc
#
# This module manages storm drpcation
#
# Parameters: None
#
# Actions: None
#
# Requires: storm:install
#
# Sample Usage:
#
#  class{'storm::drpc': }
#
class storm::drpc(
  $manage_service                  = false,
  $enable                          = true,
  $force_provider                  = undef,
  $mem                             = '1024m',
  $jvm                             = [
    '-Dlog4j.configuration=file:/etc/storm/storm.log.properties',
    '-Dlogfile.name=drpc.log'],
  $port                            = 3772,
  $servers                         = [''],
  $invocations_port                = 3773,
  $request_timeout_secs            = 600,
) inherits storm {

  validate_array($jvm)
  validate_array($servers)

  concat::fragment { 'drpc':
    ensure  => present,
    target  => $config_file,
    content => template("${module_name}/storm_drpc.erb"),
    order   => 4,
  }

  # Install drpc /etc/default
  storm::service { 'drpc':
    manage_service => $manage_service,
    force_provider => $force_provider,
    enable         => $enable,
    config_file    => $config_file,
    jvm_memory     => $mem,
    opts           => $jvm,
  }

}
