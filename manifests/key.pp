define ssh::key (
  $path = "/Users/${::boxen_user}/.ssh",
  $domain = "github.com",
  $api_base_url = "https://api.github.com",
) {
  require ssh::common

  $private_key_file = "$path/id_rsa"
  $public_key_file = "$path/id_rsa.pub"

  file { $path:
    ensure => directory
  }

  exec { "generate $name key":
    command => "ssh-keygen -f -t rsa -N -C ${domain}",
    creates => $private_key_file,
  }

  exec { "test $name key":
    command => "ssh -T git@${domain}",
    returns => [1],
  }

  exec { "upload $name key":
    command => "${::ssh::common::upload_sshkey_path} \"$domain\" \"$api_base_url\" \"${::github_token}\" \"$public_key_file\""
  }

  File[$path] -> Exec["generate $name key"] -> Exec["upload $name key"] -> Exec["test $name key"]
  File[$::sshkey::common::upload_sshkey_path] -> Exec["upload $name key"]
}
