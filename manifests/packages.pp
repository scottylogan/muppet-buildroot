# == Class: buildroot::packages
#
# Installs all the buildroot dependencies
#
# automatically included by buildroot module
#
# === Authors
#
# Scotty Logan <scotty@scottylogan.com>
#
# === Copyright
#
# Copyright (c) 2018 Scotty Logan
#
class buildroot::packages (
  $package_type,
  $install,
  $uninstall,
  $pip,
){

  include stdlib

  Package { provider => $package_type }

  stage { 'pre-packages':
    before => Stage['main'],
  }

  class { "buildroot::${package_type}":
    stage   => 'pre-packages',
  }

  $only_install = difference($install, $uninstall)

  $installing = join($only_install, ' ')
  $uninstalling = join($uninstall, ' ')

  ensure_packages($only_install, { ensure => present })
  ensure_packages($uninstall, { ensure => absent })

  # python packages via pip
  if (! empty($pip)) {

    $pip_pkgs = $facts['os']['family'] ? {
      'Debian' => [ 'python-pip' ],
      'RedHat' => [ 'python-setuptools' ],
    }

    $pip_install = $facts['os']['family'] ? {
      'RedHat' => '/usr/bin/easy_install pip',
      default  => '/bin/true',
    }

    ensure_packages($pip_pkgs, { ensure => present })

    exec { 'pip_install':
      command => $pip_install,
      require => Package[$pip_pkgs],
    }

    ensure_packages ($pip, {
      ensure => present,
      provider => 'pip',
      require => Exec['pip_install'],
    })

  }
}
