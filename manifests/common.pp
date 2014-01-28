class ssh::common {
  include boxen::config

  $upload_sshkey_path = "${boxen::config::home}/bin/upload_sshkey.sh"

  file { $upload_sshkey_path:
    ensure  => present,
    source  => 'puppet:///modules/ssh/upload_sshkey.sh',
    mode    => '0755',
  }
}
