define ssh::key (
  $path = "/Users/${::boxen_user}/.ssh",
  $domain = "github.com",
  $api_base_url = "https://api.github.com",
  $upload_key = true,
) {
  require ssh::common

  $private_key_file = "$path/id_rsa"
  $public_key_file = "$path/id_rsa.pub"

  file { $path:
    ensure => directory
  }

  exec { "generate $name key":
    command => "ssh-keygen -f ${private_key_file} -t rsa -N '' -C ${domain}",
    creates => $private_key_file,
  }
  
  exec { "add known host ${domain}":
    command => "ssh-keyscan -H ${domain} >> ~/.ssh/known_hosts",
    unless => "grep ${domain} ~/.ssh/known_hosts",
  }

  exec { "test $name key":
    command => "ssh -T git@${domain}",
    returns => [1],
  }

  if $upload_key {
    exec { "upload $name key":
      command => "${::ssh::common::upload_sshkey_path} \"$domain\" \"$api_base_url\" \"${::github_token}\" \"$public_key_file\"",
      require => File[$::ssh::common::upload_sshkey_path],
    }
  }

  File[$path] -> Exec["generate $name key"] -> Exec["upload $name key"] -> Exec["add known host ${domain}"] -> Exec["test $name key"]
}
