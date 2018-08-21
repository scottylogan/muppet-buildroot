# == Class: buildroot
#
# Buildroot setup and configuration
#
# === Examples
#
#  include buildroot
#
# === Authors
#
# Scotty Logan <scotty@catbert.net>
#
# === Copyright
#
# Copyright (c) 2018 Scotty Logan
#
class buildroot (
  $add_cloud_config
) {

  include buildroot::packages

  if ($add_cloud_config) {

    file { '/etc/cloud/cloud.cfg':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/${module_name}/cloud.cfg",
      require => Package['cloud-init'],
    }

  }

}
