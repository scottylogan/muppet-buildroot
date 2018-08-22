# == Class: buildroot::apt
#
# Generic APT configuration for a Muppet
#
# === Authors
#
# Scotty Logan <scotty@scottylogan.com>
#
class buildroot::apt {

  package {
    [
      'apt',
      'apt-transport-https',
    ]:
    ensure => latest,
  }

  # force apt-get update before package installation
  Class['apt::update'] -> Package<| |>

}
