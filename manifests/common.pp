class sshkey::common {
  $upload_sshkey_path = "${boxen::config::home}/bin/upload_sshkey.sh"

  file { $upload_sshkey_path:
    ensure  => present,
    content => "puppet://modules/sshkey/upload_sshkey.sh",
    mode    => 755,
  }
}