class ssh::common {
  include boxen::confine

  $upload_sshkey_path = "${boxen::config::home}/bin/upload_sshkey.sh"

  file { $upload_sshkey_path:
    ensure  => present,
    source  => 'puppet:///modules/sshkey/upload_sshkey.sh',
    mode    => '0755',
  }
}