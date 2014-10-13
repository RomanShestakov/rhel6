# -*- mode: puppet-mode -*-
# vi: set ft=ruby :


class known_hosts( $username = 'root', $server_list = [ 'github.com' ] ) {
  $group = $username
  
  file{ "/home/${username}/.ssh/known_hosts" :
    ensure => file,
    group  => $group,
    owner  => $username,
    mode   => 0600,
  }
  
  $modulepath = get_module_path('known_hosts')
  
  exec{ 'add_known_hosts' :
    command  => "bash -c \"known_hosts.sh github.com ${username}\"",
    path     => "${modulepath}/files/:/sbin:/usr/bin:/usr/local/bin/:/bin/",
    provider => shell,
    require  => File[ "/home/${username}/.ssh/known_hosts" ],
  }
}
