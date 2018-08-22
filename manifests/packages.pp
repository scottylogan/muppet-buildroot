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
  $easy_install_pkg,
  $easy_install,
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
    # if easy_install is set, install the package that installs it
    # then use easy_install to install pip
    if ($easy_install) {
      ensure_packages([$easy_install_pkg], { ensure => present })
      -> exec { 'easy_install_pip':
        command => "${easy_install} pip",
      }
    }

    ensure_packages ($pip, {
      ensure   => present,
      provider => 'pip',
      require  => Exec['easy_install_pip'],
    })
  }
}
