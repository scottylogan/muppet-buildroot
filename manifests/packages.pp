# == Class: buildroot::packages
#
# Installs all the buildroot dependencies
#
# automatically included by buildroot module
#
# === Authors
#
# Scotty Logan <scotty@catbert.net>
#
# === Copyright
#
# Copyright (c) 2018 Scotty Logan
#
class buildroot::packages (
  $install,
  $uninstall,
  $pip,
  $easy_install,
  $package_type,
){

  include stdlib

  Package { provider => $package_type }

  stage { 'pre-packages':
    before => Stage['main'],
  }

  class { "base::${package_type}":
    stage   => 'pre-packages',
  }

  $only_install = difference($install, $uninstall)

  $installing = join($only_install, ' ')
  $uninstalling = join($uninstall, ' ')

  ensure_packages($only_install, { ensure => present })
  ensure_packages($uninstall, { ensure => absent })

  if (! empty($pip)) {
    ensure_packages(['python-setuptools'], { ensure => present })

    exec { 'easy_install_pip':
      command => "${easy_install} pip",
      require => Package['python-setuptools'],
    }

    # python packages via pip
    ensure_packages ($pip, {
      ensure   => present,
      provider => 'pip',
      require  => Exec['easy_install_pip'],
    })
  }
}
