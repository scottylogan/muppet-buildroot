# == Class: buildroot::apt
#
# Generic APT configuration for a Muppet
#
# === Authors
#
# Scotty Logan <scotty@scottylogan.com>
#
class buildroot::apt(
  $sources = [ ],
) {

  package {
    [
      'apt',
      'apt-transport-https',
    ]:
    ensure => latest,
  }

  class { 'apt':
    update  => {
      frequency => 'daily',
    },
    purge   => {
      'sources.list'   => true,
      'sources.list.d' => false,
    },
    sources => $sources,
  }

  # force apt-get update before package installation
  Class['apt::update'] -> Package<| |>

}
